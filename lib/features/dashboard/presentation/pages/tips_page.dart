import 'package:flutter/material.dart';
import 'package:gestanea/core/constants/app_colors.dart';
import 'package:gestanea/core/widgets/search_bar.dart';
import 'package:gestanea/l10n/app_localizations.dart';

/// Tips list page. Replaces the previous stub that mis-used a marketplace
/// widget. Matches Figma frame 102:247.
class Tips extends StatefulWidget {
  const Tips({super.key});

  @override
  State<Tips> createState() => _TipsState();
}

class _TipsState extends State<Tips> {
  final TextEditingController _searchController = TextEditingController();

  int _selectedCategory = 0;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final l10n = AppLocalizations.of(context)!;

    final categories = <_TipCategory>[
      _TipCategory(l10n.catWellness, Icons.spa_outlined),
      _TipCategory(l10n.catNutrition, Icons.restaurant_outlined),
      _TipCategory(l10n.catExercise, Icons.fitness_center_outlined),
      _TipCategory(l10n.catSleep, Icons.bedtime_outlined),
      _TipCategory(l10n.catMind, Icons.self_improvement_outlined),
    ];

    final tips = <_TipItem>[
      _TipItem(
        title: l10n.tip1Title,
        summary: l10n.tip1Summary,
        readMinutes: 5,
        featured: true,
      ),
      _TipItem(
        title: l10n.tip2Title,
        summary: l10n.tip2Summary,
        readMinutes: 4,
      ),
      _TipItem(
        title: l10n.tip3Title,
        summary: l10n.tip3Summary,
        readMinutes: 6,
      ),
      _TipItem(
        title: l10n.tip4Title,
        summary: l10n.tip4Summary,
        readMinutes: 3,
      ),
    ];

    return Scaffold(
      backgroundColor: AppColors.bg_1,
      appBar: AppBar(
        backgroundColor: AppColors.bg_1,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: AppColors.main500,
            size: 22,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          l10n.tipsTitle,
          style: const TextStyle(
            color: AppColors.main500,
            fontSize: 28,
            fontFamily: 'Lato',
            fontWeight: FontWeight.w700,
            letterSpacing: -0.4,
          ),
        ),
        centerTitle: true,
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16, top: 8, bottom: 8),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: AppColors.shadow1,
            ),
            child: const Icon(
              Icons.notifications_outlined,
              color: AppColors.main500,
              size: 20,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppSearchBar(
              controller: _searchController,
              hintText: l10n.searchHint,
              onSearchTapped: () {},
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 78,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: categories.length,
                separatorBuilder: (_, __) => const SizedBox(width: 12),
                itemBuilder: (context, i) {
                  final cat = categories[i];
                  final selected = _selectedCategory == i;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedCategory = i),
                    child: Column(
                      children: [
                        Container(
                          width: 56,
                          height: 56,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: selected
                                ? const LinearGradient(
                                    colors: [
                                      AppColors.main500,
                                      AppColors.main600,
                                    ],
                                  )
                                : null,
                            color: selected ? null : Colors.white,
                            boxShadow: AppColors.shadow1,
                          ),
                          child: Icon(
                            cat.icon,
                            color: selected ? Colors.white : AppColors.main500,
                            size: 24,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          cat.label,
                          style: TextStyle(
                            fontSize: 11,
                            color: selected
                                ? AppColors.main600
                                : Colors.black54,
                            fontWeight: selected
                                ? FontWeight.w700
                                : FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            for (final tip in tips)
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: tip.featured
                    ? _FeaturedTipCard(tip: tip)
                    : _TipListCard(tip: tip),
              ),
          ],
        ),
      ),
    );
  }
}

class _TipCategory {
  const _TipCategory(this.label, this.icon);
  final String label;
  final IconData icon;
}

class _TipItem {
  const _TipItem({
    required this.title,
    required this.summary,
    required this.readMinutes,
    this.featured = false,
  });
  final String title;
  final String summary;
  final int readMinutes;
  final bool featured;
}

class _FeaturedTipCard extends StatelessWidget {
  const _FeaturedTipCard({required this.tip});
  final _TipItem tip;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFFAECFF),
        borderRadius: BorderRadius.circular(16),
        boxShadow: AppColors.shadow1,
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 120,
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.main300, AppColors.main500],
              ),
            ),
            alignment: Alignment.center,
            child: const Icon(
              Icons.restaurant_outlined,
              color: Colors.white,
              size: 36,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  tip.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                    color: Color(0xFF1C2229),
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        tip.summary,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF4C4C4C),
                          height: 1.4,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Icon(
                      Icons.arrow_forward_ios,
                      color: AppColors.main500,
                      size: 16,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TipListCard extends StatelessWidget {
  const _TipListCard({required this.tip});
  final _TipItem tip;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFFAECFF),
        borderRadius: BorderRadius.circular(16),
        boxShadow: AppColors.shadow1,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              color: const Color(0xFFE8E9EA),
              borderRadius: BorderRadius.circular(12),
            ),
            alignment: Alignment.center,
            child: const Icon(
              Icons.lightbulb_outline,
              color: AppColors.main500,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  tip.title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1C2229),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  tip.summary,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF4C4C4C),
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),
                Text(
                  AppLocalizations.of(context)!.minRead(tip.readMinutes),
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.main500,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
