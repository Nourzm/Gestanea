import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gestanea/core/constants/app_colors.dart';
import 'package:gestanea/core/constants/app_text_styles.dart';
import 'package:gestanea/l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import '../../logic/bloc/lab_results_bloc.dart';
import '../../logic/bloc/lab_results_state.dart';
import '../pages/lab_results_list_page.dart';
import 'dialogs/upload_lab_results_dialog.dart';

class LabResultsTabContent extends StatelessWidget {
  const LabResultsTabContent({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Stack(
      children: [
        Container(
          decoration: const BoxDecoration(
            color: Color(0xFFFAF0FF),
            borderRadius: BorderRadius.only(topLeft: Radius.circular(15)),
          ),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Recent Lab Results
                Text(
                  l10n. recentLabResults,
                  style: AppTextStyles.headline2. copyWith(
                    fontSize: 18,
                    color: AppColors.textDark,
                  ),
                ),
                const SizedBox(height: 12),

                // Dynamic Lab Result Cards from Database
                BlocBuilder<LabResultsBloc, LabResultsState>(
                  builder: (context, state) {
                    if (state is LabResultsLoaded) {
                      if (state.labResults.isEmpty) {
                        return const Padding(
                          padding: EdgeInsets.all(20.0),
                          child: Center(
                            child: Text(
                              'No lab results yet',
                              style: TextStyle(color: Colors.grey),
                            ),
                          ),
                        );
                      }
                      
                      // Show only the 4 most recent results
                      final recentResults = state.labResults. take(4).toList();
                      return Column(
                        children: recentResults.map((result) {
                          Color statusColor = const Color(0xFFB8E6B8);
                          String status = l10n.normal;
                          
                          if (result.normalRangeMin != null && 
                              result.normalRangeMax != null && 
                              result.value != null) {
                            if (result.value! < result.normalRangeMin!) {
                              statusColor = const Color(0xFFFFE0B2);
                              status = 'Low';
                            } else if (result.value! > result.normalRangeMax!) {
                              statusColor = const Color(0xFFFFB8B8);
                              status = 'High';
                            }
                          }
                          
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: _buildLabResultCard(
                              context,
                              test: result.testName,
                              value: result.value != null 
                                  ? '${result.value} ${result. unit ?? ''}' 
                                  : 'N/A',
                              status: status,
                              statusColor: statusColor,
                              date: DateFormat('MMM dd, yyyy').format(result.labDate),
                              range: result.normalRangeMin != null && result.normalRangeMax != null
                                  ? '${result.normalRangeMin}-${result.normalRangeMax} ${result.unit ?? ''}'
                                  : 'N/A',
                            ),
                          );
                        }). toList(),
                      );
                    }
                    return const Center(child: CircularProgressIndicator());
                  },
                ),

                const SizedBox(height: 20),

                // Upload Results Button
                _buildUploadButton(context),

                const SizedBox(height: 20),

                // View All Button
                Builder(
                  builder: (btnContext) {
                    return SizedBox(
                      width: double.infinity,
                      child: ElevatedButton. icon(
                        onPressed: () {
                          Navigator.push(
                            btnContext,
                            MaterialPageRoute(
                              builder: (navContext) => BlocProvider.value(
                                value: btnContext.read<LabResultsBloc>(),
                                child: const LabResultsListPage(),
                              ),
                            ),
                          );
                        },
                        icon: const Icon(Icons.list),
                        label: const Text('View All Lab Results'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.main500,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    );
                  }
                ),

                const SizedBox(height: 20),

                // Next Appointment Card
                _buildNextAppointmentCard(context),

                const SizedBox(height: 16),

                // Tip Card
                _buildTipCard(l10n. keepLabResultsOrganized),
              ],
            ),
          ),
        ),

        // TOP inset shadow
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: IgnorePointer(
            child: Container(
              height: 25,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(topLeft: Radius.circular(15)),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.12),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
        ),

        // LEFT inset shadow
        Positioned(
          top: 0,
          left: 0,
          bottom: 0,
          child: IgnorePointer(
            child: Container(
              width: 25,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(topLeft: Radius.circular(15)),
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                    Colors.black.withValues(alpha: 0.12),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLabResultCard(
    BuildContext context, {
    required String test,
    required String value,
    required String status,
    required Color statusColor,
    required String date,
    required String range,
  }) {
    final l10n = AppLocalizations.of(context)!;
    
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Color(0x3F000000),
            blurRadius: 4,
            offset: Offset(2, 2),
            spreadRadius: 0,
          ),
          BoxShadow(
            color: AppColors.white,
            blurRadius: 6,
            offset: Offset(-3, -3),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                test,
                style: AppTextStyles.subtitle1.copyWith(
                  fontSize: 14,
                  color: AppColors.textDark,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                decoration: BoxDecoration(
                  color: statusColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  status,
                  style: AppTextStyles. smallLabel.copyWith(
                    fontSize: 11,
                    color: const Color(0xFF2D5F2D),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                value,
                style: AppTextStyles.headline2.copyWith(
                  fontSize: 18,
                  color: AppColors.textDark,
                ),
              ),
              Text(
                date,
                style: AppTextStyles.smallLabel.copyWith(
                  fontSize: 11,
                  color: AppColors.textDark,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            '${l10n.normalRangeLabel}: $range',
            style: AppTextStyles.smallLabel.copyWith(
              fontSize: 11,
              color: AppColors.textDark,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUploadButton(BuildContext context) {
    final l10n = AppLocalizations. of(context)!;
    
    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (context) => const UploadLabResultsDialog(),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [AppColors.blue600, AppColors.blue500],
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [
            BoxShadow(
              color: Color(0x3F000000),
              blurRadius: 4,
              offset: Offset(2, 2),
              spreadRadius: 0,
            ),
            BoxShadow(
              color: AppColors.white,
              blurRadius: 6,
              offset: Offset(-3, -3),
              spreadRadius: 0,
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.upload_file, color: AppColors.white, size: 24),
            const SizedBox(width: 8),
            Text(
              l10n.uploadLabResults,
              style: AppTextStyles.subtitle1.copyWith(
                color: AppColors.white,
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNextAppointmentCard(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.main500, Color(0xFFB388CC)],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Color(0x3F000000),
            blurRadius: 4,
            offset: Offset(2, 2),
            spreadRadius: 0,
          ),
          BoxShadow(
            color: AppColors. white,
            blurRadius: 6,
            offset: Offset(-3, -3),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white. withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.calendar_today, color: AppColors.white, size: 24),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n. nextLabAppointment,
                  style: AppTextStyles.body1.copyWith(
                    color: AppColors.white,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'November 15, 2025 - 10:00 AM',
                  style: AppTextStyles.subtitle1.copyWith(
                    color: AppColors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTipCard(String message) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFE8D5F2),
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Color(0x3F000000),
            blurRadius: 4,
            offset: Offset(2, 2),
            spreadRadius: 0,
          ),
          BoxShadow(
            color: AppColors.white,
            blurRadius: 6,
            offset: Offset(-3, -3),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Text(
        message,
        style: AppTextStyles.body1. copyWith(
          color: const Color(0xFF7B4BA6),
          fontSize: 12,
        ),
      ),
    );
  }
}