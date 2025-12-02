import 'package:flutter/material.dart';
import 'package:gestanea/core/constants/app_colors.dart';
import 'package:gestanea/core/widgets/Sub_Header.dart';
import 'package:gestanea/l10n/app_localizations.dart';
import 'package:gestanea/features/plan/presentation/widgets/medicine_card.dart';

class MedicinesPage extends StatefulWidget {
  const MedicinesPage({super.key});

  @override
  State<MedicinesPage> createState() => _MedicinesPageState();
}

class _MedicinesPageState extends State<MedicinesPage> {
  String selectedFilter = 'All'; // All, Taken, Missed
  bool _showFilters = true;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.offset > 50 && _showFilters) {
      setState(() {
        _showFilters = false;
      });
    } else if (_scrollController.offset <= 50 && !_showFilters) {
      setState(() {
        _showFilters = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppColors.bg_1,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SubHeader(
              title: localizations.medicine,
              showBackButton: true,
              onBackPressed: () => Navigator.of(context).pop(),
            ),
            Expanded(
              child: SingleChildScrollView(
                controller: _scrollController,
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Filter Pills (All, Taken, Missed) - with animation
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      height: _showFilters ? null : 0,
                      curve: Curves.easeInOut,
                      child: AnimatedOpacity(
                        duration: const Duration(milliseconds: 300),
                        opacity: _showFilters ? 1.0 : 0.0,
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: screenWidth * 0.05,
                          ),
                          child: Row(
                            children: [
                              _buildFilterPill('All', 4),
                              SizedBox(width: 12),
                              _buildFilterPill('Taken', 1),
                              SizedBox(width: 12),
                              _buildFilterPill('Missed', 2),
                            ],
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: screenHeight * 0.025),

                    // Medicine List
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: screenWidth * 0.05,
                      ),
                      child: Column(
                        children: [
                          MedicineCard(
                            name: 'Captopril',
                            dosage: '2 Capsules',
                            time: '20:00',
                            frequency: 'Daily',
                            imagePath: 'assets/images/captopril.png',
                            buttonText: 'Take',
                            buttonColor: AppColors.main500,
                            isTaken: false,
                            screenWidth: screenWidth,
                            screenHeight: screenHeight,
                          ),
                          SizedBox(height: screenHeight * 0.015),
                          MedicineCard(
                            name: 'B 12',
                            dosage: '1 Injection',
                            time: '22:00',
                            frequency: 'Daily',
                            imagePath: 'assets/images/b12.png',
                            buttonText: 'Taken',
                            buttonColor: Colors.green,
                            isTaken: true,
                            screenWidth: screenWidth,
                            screenHeight: screenHeight,
                          ),
                          SizedBox(height: screenHeight * 0.015),
                          MedicineCard(
                            name: 'I-DROP MGD',
                            dosage: '2 Drops',
                            time: '22:00',
                            frequency: 'Daily',
                            imagePath: 'assets/images/idrop.png',
                            buttonText: 'Take',
                            buttonColor: AppColors.main500,
                            isTaken: false,
                            screenWidth: screenWidth,
                            screenHeight: screenHeight,
                            showMissedBadge: true,
                          ),
                          SizedBox(height: screenHeight * 0.015),
                          MedicineCard(
                            name: 'Niacin',
                            dosage: '0.5 Pill',
                            time: '22:00',
                            frequency: 'Daily',
                            imagePath: 'assets/images/niacin.png',
                            buttonText: 'Take',
                            buttonColor: AppColors.main500,
                            isTaken: false,
                            screenWidth: screenWidth,
                            screenHeight: screenHeight,
                            showMissedBadge: true,
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: screenHeight * 0.1),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterPill(String label, int count) {
    final isSelected = selectedFilter == label;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedFilter = label;
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.main300 : AppColors.bg_1,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppColors.main500 : Colors.transparent,
            width: 1,
          ),
          // Neumorphism shadows
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: const Color(0xFF000000).withOpacity(0.25),
                    blurRadius: 4,
                    offset: const Offset(2, 2),
                  ),
                ]
              : [
                  BoxShadow(
                    color: const Color(0xFF000000).withOpacity(0.1),
                    blurRadius: 6,
                    offset: const Offset(4, 4),
                  ),
                  const BoxShadow(
                    color: Color(0xFFFFFFFF),
                    blurRadius: 6,
                    offset: Offset(-4, -4),
                  ),
                ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: isSelected ? AppColors.main600 : Colors.black87,
              ),
            ),
            SizedBox(width: 8),
            Text(
              count.toString(),
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: isSelected ? AppColors.main600 : Colors.grey.shade600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ...existing code...
}
