import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gestanea/core/constants/app_colors.dart';
import 'package:gestanea/core/constants/app_text_styles.dart';
import 'package:gestanea/core/database/models/tip_model.dart';
import 'package:gestanea/features/auth/logic/auth_bloc.dart';
import 'package:gestanea/features/auth/logic/auth_state.dart';
import 'package:gestanea/features/dashboard/data/repositories/dashboard_repository_impl.dart';
import 'package:gestanea/features/dashboard/presentation/widgets/tip_card_widget.dart';
import 'package:gestanea/features/dashboard/presentation/widgets/tips_category_tab.dart';
import 'package:gestanea/features/dashboard/presentation/widgets/tips_empty_state.dart';
import 'package:gestanea/features/dashboard/presentation/pages/tip_details_page.dart';

class TipsOverviewPage extends StatefulWidget {
  const TipsOverviewPage({super.key});

  @override
  State<TipsOverviewPage> createState() => _TipsOverviewPageState();
}

class _TipsOverviewPageState extends State<TipsOverviewPage> {
  final DashboardRepositoryImpl _repository = DashboardRepositoryImpl();
  List<TipModel> _tips = [];
  List<String> _savedTipIds = [];
  bool _isLoading = true;
  String _selectedCategory = 'All';
  String? _userId;
  bool _isPostpartum = false;
  int? _currentWeek;
  int? _currentMonth;
  int? _postpartumWeek;
  String _dynamicTitle = 'Tips';

  // Available categories
  static const List<String> _categories = [
    'All',
    'Food',
    'Sport',
    'Sleep',
    'Mental',
    'Medical',
    'General',
  ];

  @override
  void initState() {
    super.initState();
    _loadTips();
  }

  String _getUserId() {
    final authState = context.read<AuthBloc>().state;
    if (authState is AuthAuthenticated) {
      return authState.user.id;
    }
    return '';
  }

  Future<Map<String, dynamic>> _getUserStageInfo(String userId) async {
    final isPregnant = await _repository.isUserPregnantByStringId(userId);
    final hasBaby = await _repository.hasActiveBabyByStringId(userId);
    
    if (!isPregnant && hasBaby) {
      // Postpartum - calculate week from baby birth date
      try {
        final dashboard = await _repository.getPostpartumDashboardByStringId(userId);
        final babyAgeInDays = dashboard.babyAgeInMonths * 30;
        final postpartumWeek = (babyAgeInDays ~/ 7) + 1;
        return {
          'isPostpartum': true,
          'postpartumWeek': postpartumWeek,
          'currentWeek': null,
          'currentMonth': null,
        };
      } catch (e) {
        return {'isPostpartum': true, 'postpartumWeek': null, 'currentWeek': null, 'currentMonth': null};
      }
    } else {
      // Pregnancy - calculate week from LMP date
      try {
        final dashboard = await _repository.getPregnancyDashboardByStringId(userId);
        final currentMonth = (dashboard.currentWeek / 4).ceil();
        return {
          'isPostpartum': false,
          'currentWeek': dashboard.currentWeek,
          'currentMonth': currentMonth,
          'postpartumWeek': null,
        };
      } catch (e) {
        return {'isPostpartum': false, 'currentWeek': null, 'currentMonth': null, 'postpartumWeek': null};
      }
    }
  }

  Future<void> _loadTips() async {
    if (!mounted) return;
    
    setState(() {
      _isLoading = true;
    });

    try {
      _userId = _getUserId();
      if (_userId == null || _userId!.isEmpty) {
        setState(() {
          _isLoading = false;
        });
        return;
      }

      // Determine user stage (pregnancy or postpartum)
      final isPregnant = await _repository.isUserPregnantByStringId(_userId!);
      final hasBaby = await _repository.hasActiveBabyByStringId(_userId!);
      
      _isPostpartum = !isPregnant && hasBaby;

      // Calculate current week/month based on stage
      // We'll use a helper to get stage info
      final stageInfo = await _getUserStageInfo(_userId!);
      _isPostpartum = stageInfo['isPostpartum'] as bool;
      _currentWeek = stageInfo['currentWeek'] as int?;
      _currentMonth = stageInfo['currentMonth'] as int?;
      _postpartumWeek = stageInfo['postpartumWeek'] as int?;
      
      if (_isPostpartum && _postpartumWeek != null) {
        _dynamicTitle = 'Tips for Postpartum Week $_postpartumWeek';
      } else if (_currentWeek != null) {
        _dynamicTitle = 'Tips for Week $_currentWeek';
      } else {
        _dynamicTitle = _isPostpartum ? 'Postpartum Tips' : 'Pregnancy Tips';
      }

      // Load saved tip IDs
      _savedTipIds = await _repository.getSavedTipIds(_userId!);

      // Fetch tips
      await _fetchTips();
    } catch (e) {
      print('Error loading tips: $e');
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _fetchTips() async {
    try {
      final targetAudience = _isPostpartum ? 'postpartum' : 'pregnant';
      final tipsData = await _repository.getTips(
        category: _selectedCategory == 'All' ? null : _selectedCategory,
        targetAudience: targetAudience,
        currentWeek: _currentWeek,
        currentMonth: _currentMonth,
        isPostpartum: _isPostpartum,
        postpartumWeek: _postpartumWeek,
        limit: 50,
      );

      final tips = tipsData
          .map((tipData) => TipModel.fromMap(tipData))
          .toList();

      if (mounted) {
        setState(() {
          _tips = tips;
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Error fetching tips: $e');
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _toggleSaveTip(TipModel tip) async {
    if (_userId == null || _userId!.isEmpty) return;

    try {
      final isSaved = _savedTipIds.contains(tip.id);
      if (isSaved) {
        await _repository.removeSavedTipForUser(_userId!, tip.id);
        setState(() {
          _savedTipIds.remove(tip.id);
        });
      } else {
        await _repository.saveTipForUser(_userId!, tip.id);
        setState(() {
          _savedTipIds.add(tip.id);
        });
      }
    } catch (e) {
      print('Error toggling save tip: $e');
    }
  }

  void _onCategorySelected(String category) {
    setState(() {
      _selectedCategory = category;
    });
    _fetchTips();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg_1,
      appBar: AppBar(
        backgroundColor: AppColors.bg_1,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: AppColors.main500,
            size: 24,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          _dynamicTitle,
          style: AppTextStyles.headline1.copyWith(
            color: AppColors.main500,
            fontSize: 32,
            fontFamily: 'Lato',
            letterSpacing: -0.40,
          ),
          textAlign: TextAlign.center,
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: RefreshIndicator(
        onRefresh: _loadTips,
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : Column(
                children: [
                  // Category tabs
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: _categories.map((category) {
                          return TipsCategoryTab(
                            category: category,
                            isSelected: _selectedCategory == category,
                            onTap: () => _onCategorySelected(category),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                  // Tips list
                  Expanded(
                    child: _tips.isEmpty
                        ? TipsEmptyState(category: _selectedCategory)
                        : ListView.builder(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            itemCount: _tips.length,
                            itemBuilder: (context, index) {
                              final tip = _tips[index];
                              final isSaved = _savedTipIds.contains(tip.id);
                              final isHighPriority = tip.priority >= 8;

                              return TipCardWidget(
                                tip: tip,
                                isHighPriority: isHighPriority,
                                isSaved: isSaved,
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => TipDetailsPage(
                                        tip: tip,
                                        userId: _userId ?? '',
                                        isSaved: isSaved,
                                        onSaveToggle: () => _toggleSaveTip(tip),
                                      ),
                                    ),
                                  ).then((_) {
                                    // Refresh saved tip IDs when returning
                                    if (_userId != null) {
                                      _repository.getSavedTipIds(_userId!).then((ids) {
                                        if (mounted) {
                                          setState(() {
                                            _savedTipIds = ids;
                                          });
                                        }
                                      });
                                    }
                                  });
                                },
                                onSaveToggle: () => _toggleSaveTip(tip),
                              );
                            },
                          ),
                  ),
                ],
              ),
      ),
    );
  }
}
