import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gestanea/core/constants/app_colors.dart';
import 'package:gestanea/core/constants/app_text_styles.dart';
import 'package:gestanea/core/database/models/tip_model.dart';
import 'package:gestanea/core/widgets/search_bar.dart';
import 'package:gestanea/features/auth/logic/auth_bloc.dart';
import 'package:gestanea/features/auth/logic/auth_state.dart';
import 'package:gestanea/features/dashboard/data/repositories/dashboard_repository_impl.dart';
import 'package:gestanea/features/dashboard/presentation/pages/tip_details_page.dart';
import 'package:gestanea/features/dashboard/presentation/widgets/category_card.dart';
import 'package:gestanea/features/dashboard/presentation/widgets/tipFinal_card.dart';
import 'package:gestanea/features/dashboard/presentation/widgets/tips_empty_state.dart';
import 'package:gestanea/l10n/app_localizations.dart';

class TipsOverviewPage extends StatefulWidget {
  const TipsOverviewPage({super.key});

  @override
  State<TipsOverviewPage> createState() => _TipsOverviewPageState();
}

class _TipsOverviewPageState extends State<TipsOverviewPage> {
  final DashboardRepositoryImpl _repository = DashboardRepositoryImpl();
  final TextEditingController _searchController = TextEditingController();

  List<TipModel> _tips = [];
  List<TipModel> _filteredTips = [];
  List<String> _savedTipIds = [];
  bool _isLoading = true;
  String _selectedCategory = 'All';
  String? _userId;
  bool _isPostpartum = false;
  int? _currentWeek;
  int? _currentMonth;
  int? _postpartumWeek;

  static const List<Map<String, String>> _tipCategories = [
    {'name': 'All', 'asset': 'assets/icons/global.svg', 'filter': ''},
    {'name': 'Nutrition', 'asset': 'assets/icons/food.svg', 'filter': 'Food'},
    {'name': 'Exercise', 'asset': 'assets/icons/sports.svg', 'filter': 'Sport'},
    {'name': 'Sleep', 'asset': 'assets/icons/sleep.svg', 'filter': 'Sleep'},
    {'name': 'Baby Care', 'asset': 'assets/icons/baby.svg', 'filter': 'General'},
    {'name': 'Wellness', 'asset': 'assets/icons/health.svg', 'filter': 'Mental'},
  ];

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_applyFilters);
    _loadTips();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
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
      try {
        final dashboard =
            await _repository.getPostpartumDashboardByStringId(userId);
        final babyAgeInDays = dashboard.babyAgeInMonths * 30;
        final postpartumWeek = (babyAgeInDays ~/ 7) + 1;
        return {
          'isPostpartum': true,
          'postpartumWeek': postpartumWeek,
          'currentWeek': null,
          'currentMonth': null,
        };
      } catch (e) {
        return {
          'isPostpartum': true,
          'postpartumWeek': null,
          'currentWeek': null,
          'currentMonth': null,
        };
      }
    } else {
      try {
        final dashboard =
            await _repository.getPregnancyDashboardByStringId(userId);
        final currentMonth = (dashboard.currentWeek / 4).ceil();
        return {
          'isPostpartum': false,
          'currentWeek': dashboard.currentWeek,
          'currentMonth': currentMonth,
          'postpartumWeek': null,
        };
      } catch (e) {
        return {
          'isPostpartum': false,
          'currentWeek': null,
          'currentMonth': null,
          'postpartumWeek': null,
        };
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

      await _repository.syncTips();

      if (_userId != null && _userId!.isNotEmpty) {
        final stageInfo = await _getUserStageInfo(_userId!);
        _isPostpartum = stageInfo['isPostpartum'] as bool;
        _currentWeek = stageInfo['currentWeek'] as int?;
        _currentMonth = stageInfo['currentMonth'] as int?;
        _postpartumWeek = stageInfo['postpartumWeek'] as int?;
        _savedTipIds = await _repository.getSavedTipIds(_userId!);
      }

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
      final categoryFilter = _selectedCategory == 'All'
          ? null
          : _tipCategories
              .firstWhere((c) => c['name'] == _selectedCategory)['filter'];

      final tipsData = await _repository.getTips(
        category: categoryFilter?.isEmpty == true ? null : categoryFilter,
        targetAudience: targetAudience,
        currentWeek: _currentWeek,
        currentMonth: _currentMonth,
        isPostpartum: _isPostpartum,
        postpartumWeek: _postpartumWeek,
        showAllStages: _selectedCategory == 'All',
        limit: 50,
      );

      final tips = tipsData.map((tipData) => TipModel.fromMap(tipData)).toList();

      if (mounted) {
        setState(() {
          _tips = tips;
          _isLoading = false;
        });
        _applyFilters();
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

  void _applyFilters() {
    final query = _searchController.text.trim().toLowerCase();
    setState(() {
      _filteredTips = _tips.where((tip) {
        if (query.isEmpty) return true;
        return tip.title.toLowerCase().contains(query) ||
            tip.content.toLowerCase().contains(query);
      }).toList();
    });
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

  void _openTipDetails(TipModel tip) {
    final isSaved = _savedTipIds.contains(tip.id);
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
  }

  String _estimateReadTime(String content) {
    final minutes = (content.length / 200).ceil().clamp(1, 15);
    return '$minutes min read';
  }

  String _truncateDescription(String content, {int maxLength = 100}) {
    if (content.length <= maxLength) return content;
    return '${content.substring(0, maxLength).trim()}...';
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
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
          l10n.tipsTitle,
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
            ? ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: const [
                  SizedBox(height: 200),
                  Center(child: CircularProgressIndicator()),
                ],
              )
            : SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Container(
                  width: double.infinity,
                  color: AppColors.bg_1,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                    child: Column(
                      children: [
                        searchBar(
                          controller: _searchController,
                          hintText: l10n.searchHint,
                          onChanged: (_) => _applyFilters(),
                        ),
                        const SizedBox(height: 20),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: _tipCategories.map((category) {
                              final name = category['name']!;
                              return Padding(
                                padding: const EdgeInsets.only(left: 12),
                                child: CategoryCard(
                                  categoryName: name,
                                  svgAssetPath: category['asset']!,
                                  isSelected: _selectedCategory == name,
                                  onTap: () => _onCategorySelected(name),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                        const SizedBox(height: 10),
                        if (_filteredTips.isEmpty)
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 40),
                            child: TipsEmptyState(category: _selectedCategory),
                          )
                        else
                          ...List.generate(_filteredTips.length, (index) {
                            final tip = _filteredTips[index];
                            return ProductCardToggle(
                              initialExpanded: index == 0,
                              title: tip.title,
                              description: _truncateDescription(tip.content),
                              readTime: _estimateReadTime(tip.content),
                              imagePath: 'assets/images/onboarding5.png',
                              onDetailsTap: () => _openTipDetails(tip),
                            );
                          }),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}
