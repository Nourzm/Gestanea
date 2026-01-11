import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:gestanea/core/constants/app_colors.dart';
import 'package:gestanea/core/constants/app_text_styles.dart';
import 'package:gestanea/core/database/models/tip_model.dart';

class TipDetailsPage extends StatefulWidget {
  final TipModel tip;
  final String userId;
  final bool isSaved;
  final VoidCallback? onSaveToggle;

  const TipDetailsPage({
    super.key,
    required this.tip,
    required this.userId,
    this.isSaved = false,
    this.onSaveToggle,
  });

  @override
  State<TipDetailsPage> createState() => _TipDetailsPageState();
}

class _TipDetailsPageState extends State<TipDetailsPage> {
  late bool _isSaved;
  String? _localizedContent;
  String? _localizedTitle;

  @override
  void initState() {
    super.initState();
    _isSaved = widget.isSaved;
    _loadLocalizedContent();
  }

  void _loadLocalizedContent() {
    // Get current language
    final locale = Localizations.localeOf(context);
    final languageCode = locale.languageCode;

    // Try to parse JSON content if available
    if (widget.tip.contentJson != null && widget.tip.contentJson!.isNotEmpty) {
      try {
        final jsonContent = jsonDecode(widget.tip.contentJson!);
        if (jsonContent is Map<String, dynamic>) {
          _localizedContent = jsonContent[languageCode] as String?;
          _localizedTitle = jsonContent['${languageCode}_title'] as String?;
        }
      } catch (e) {
        print('Error parsing JSON content: $e');
      }
    }

    // Fallback to default content if JSON parsing fails
    _localizedContent ??= widget.tip.content;
    _localizedTitle ??= widget.tip.title;
  }

  String _getTimeBadge() {
    final tip = widget.tip;
    if (tip.isGlobal) return 'Always';
    if (tip.pregnancyWeekFrom != null && tip.pregnancyWeekTo != null) {
      return 'Week ${tip.pregnancyWeekFrom}-${tip.pregnancyWeekTo}';
    }
    if (tip.pregnancyWeekFrom != null) {
      return 'Week ${tip.pregnancyWeekFrom}+';
    }
    if (tip.pregnancyMonthFrom != null && tip.pregnancyMonthTo != null) {
      return 'Month ${tip.pregnancyMonthFrom}-${tip.pregnancyMonthTo}';
    }
    if (tip.pregnancyMonthFrom != null) {
      return 'Month ${tip.pregnancyMonthFrom}+';
    }
    if (tip.postpartumWeekFrom != null && tip.postpartumWeekTo != null) {
      return 'Postpartum Week ${tip.postpartumWeekFrom}-${tip.postpartumWeekTo}';
    }
    if (tip.postpartumWeekFrom != null) {
      return 'Postpartum Week ${tip.postpartumWeekFrom}+';
    }
    return 'General';
  }

  Color _getCategoryColor(String? category) {
    switch (category?.toLowerCase()) {
      case 'food':
        return AppColors.pink500;
      case 'sport':
      case 'exercise':
        return AppColors.blue500;
      case 'sleep':
        return AppColors.main500;
      case 'mental':
        return AppColors.pink400;
      case 'medical':
        return AppColors.error1;
      default:
        return AppColors.main600;
    }
  }

  IconData _getCategoryIcon(String? category) {
    switch (category?.toLowerCase()) {
      case 'food':
        return Icons.restaurant;
      case 'sport':
      case 'exercise':
        return Icons.fitness_center;
      case 'sleep':
        return Icons.bedtime;
      case 'mental':
        return Icons.psychology;
      case 'medical':
        return Icons.medical_services;
      default:
        return Icons.article;
    }
  }

  @override
  Widget build(BuildContext context) {
    final categoryColor = _getCategoryColor(widget.tip.category);

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
          _localizedTitle ?? widget.tip.title,
          style: AppTextStyles.headline2.copyWith(
            color: AppColors.main500,
            fontSize: 20,
            fontFamily: 'Lato',
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        actions: [
          if (widget.onSaveToggle != null)
            IconButton(
              icon: Icon(
                _isSaved ? Icons.bookmark : Icons.bookmark_border,
                color: _isSaved ? AppColors.main600 : AppColors.textSecondary,
              ),
              onPressed: () {
                setState(() {
                  _isSaved = !_isSaved;
                });
                widget.onSaveToggle?.call();
              },
            ),
        ],
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Category and time badge
            Row(
              children: [
                if (widget.tip.category != null)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: categoryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: categoryColor.withOpacity(0.3)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          _getCategoryIcon(widget.tip.category),
                          size: 18,
                          color: categoryColor,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          widget.tip.category!,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: categoryColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: AppColors.main300,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    _getTimeBadge(),
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: AppColors.main600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            // Title
            Text(
              _localizedTitle ?? widget.tip.title,
              style: AppTextStyles.headline1.copyWith(
                fontSize: 28,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 16),
            // Content
            Text(
              _localizedContent ?? widget.tip.content,
              style: AppTextStyles.body1.copyWith(
                fontSize: 16,
                height: 1.6,
                color: AppColors.textDark,
              ),
            ),
            if (widget.tip.source != null && widget.tip.source!.isNotEmpty) ...[
              const SizedBox(height: 32),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.main300.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(Icons.info_outline, color: AppColors.main600, size: 20),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Source',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: AppColors.main600,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            widget.tip.source!,
                            style: TextStyle(
                              fontSize: 14,
                              color: AppColors.textDark.withOpacity(0.7),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
