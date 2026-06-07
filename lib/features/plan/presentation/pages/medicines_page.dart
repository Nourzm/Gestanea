import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gestanea/core/constants/app_colors.dart';
import 'package:gestanea/core/widgets/subheader.dart';
import 'package:gestanea/l10n/app_localizations.dart';
import 'package:gestanea/features/plan/presentation/widgets/medicine_card.dart';
import 'package:gestanea/core/database/models/medicine_model.dart';
import 'package:gestanea/core/database/models/medicine_logged_model.dart';
import 'package:uuid/uuid.dart';
import '../../logic/plan_bloc.dart';
import '../../logic/medicines_bloc.dart';

class MedicinesPage extends StatefulWidget {
  final String userId;

  const MedicinesPage({super.key, required this.userId});

  @override
  State<MedicinesPage> createState() => _MedicinesPageState();
}

class _MedicinesPageState extends State<MedicinesPage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    context.read<PlanBloc>().add(LoadMedicines(userId: widget.userId));
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    final medicinesBloc = context.read<MedicinesBloc>();
    if (_scrollController.offset > 50) {
      medicinesBloc.add(const UpdateScrollVisibility(false));
    } else if (_scrollController.offset <= 50) {
      medicinesBloc.add(const UpdateScrollVisibility(true));
    }
  }

  void _handleTakeMedicine(MedicineModel medicine) {
    final uuid = Uuid();
    final log = MedicineLoggedModel(
      id: uuid.v4(),
      medicineId: medicine.id,
      userId: widget.userId,
      loggedDate: DateTime.now(),
      status: 'taken',
      loggedAt: DateTime.now(),
    );

    context.read<PlanBloc>().add(LogMedicineEvent(log: log));
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
              onBackPressed: () {
                Navigator.of(context).pop();
              },
            ),
            Expanded(
              child: BlocListener<PlanBloc, PlanState>(
                listener: (context, state) {
                  if (state is MedicinesLoaded || state is PlanLoaded) {
                    final medicines = state is MedicinesLoaded
                        ? state.medicines
                        : (state as PlanLoaded).medicines;
                    final logs = state is MedicinesLoaded
                        ? state.medicineLogs
                        : (state as PlanLoaded).medicineLogs;

                    context.read<MedicinesBloc>().add(
                      LoadMedicinesWithLogs(medicines: medicines, logs: logs),
                    );
                  }
                },
                child: SingleChildScrollView(
                  controller: _scrollController,
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Filter Pills (All, Taken, Missed) - with animation
                      BlocBuilder<MedicinesBloc, MedicinesState>(
                        builder: (context, state) {
                          if (state is! MedicinesDisplayState) {
                            return const SizedBox.shrink();
                          }

                          return AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            height: state.showFilters ? null : 0,
                            curve: Curves.easeInOut,
                            child: AnimatedOpacity(
                              duration: const Duration(milliseconds: 300),
                              opacity: state.showFilters ? 1.0 : 0.0,
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: screenWidth * 0.05,
                                ),
                                child: Row(
                                  children: [
                                    _buildFilterPill(
                                      localizations.all,
                                      state.allCount,
                                      state.selectedFilter == localizations.all,
                                    ),
                                    SizedBox(width: 12),
                                    _buildFilterPill(
                                      localizations.taken,
                                      state.takenCount,
                                      state.selectedFilter ==
                                          localizations.taken,
                                    ),
                                    SizedBox(width: 12),
                                    _buildFilterPill(
                                      localizations.missed,
                                      state.missedCount,
                                      state.selectedFilter ==
                                          localizations.missed,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),

                      SizedBox(height: screenHeight * 0.025),

                      // Medicine List
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: screenWidth * 0.05,
                        ),
                        child: BlocBuilder<PlanBloc, PlanState>(
                          builder: (context, planState) {
                            if (planState is PlanLoading) {
                              return Center(
                                child: CircularProgressIndicator(
                                  color: AppColors.main500,
                                ),
                              );
                            }

                            if (planState is PlanError) {
                              return Center(
                                child: Padding(
                                  padding: EdgeInsets.all(screenHeight * 0.05),
                                  child: Text(
                                    '${localizations.error}: ${planState.message}',
                                    style: TextStyle(
                                      fontSize: screenWidth * 0.04,
                                      color: Colors.red,
                                    ),
                                  ),
                                ),
                              );
                            }

                            return BlocBuilder<MedicinesBloc, MedicinesState>(
                              builder: (context, medicinesState) {
                                if (medicinesState is! MedicinesDisplayState) {
                                  return const SizedBox.shrink();
                                }

                                if (medicinesState.filteredMedicines.isEmpty) {
                                  return Center(
                                    child: Padding(
                                      padding: EdgeInsets.all(
                                        screenHeight * 0.05,
                                      ),
                                      child: Text(
                                        localizations.noMedicinesFound,
                                        style: TextStyle(
                                          fontSize: screenWidth * 0.04,
                                          color: Colors.grey.shade600,
                                        ),
                                      ),
                                    ),
                                  );
                                }

                                return Column(
                                  children: medicinesState.filteredMedicines
                                      .map((medicine) {
                                        final log = medicinesState.logs
                                            .firstWhere(
                                              (l) =>
                                                  l.medicineId == medicine.id,
                                              orElse: () => MedicineLoggedModel(
                                                id: '',
                                                medicineId: '',
                                                userId: '',
                                                loggedDate: DateTime.now(),
                                                status: '',
                                                loggedAt: DateTime.now(),
                                              ),
                                            );
                                        final hasLog = log.id.isNotEmpty;

                                        return Padding(
                                          padding: EdgeInsets.only(
                                            bottom: screenHeight * 0.015,
                                          ),
                                          child: MedicineCard(
                                            medicine: medicine,
                                            log: hasLog ? log : null,
                                            scheduledTime:
                                                medicine
                                                    .scheduledTimes
                                                    ?.first ??
                                                '00:00',
                                            screenWidth: screenWidth,
                                            screenHeight: screenHeight,
                                            onTakeMedicine: () =>
                                                _handleTakeMedicine(medicine),
                                          ),
                                        );
                                      })
                                      .toList(),
                                );
                              },
                            );
                          },
                        ),
                      ),

                      SizedBox(height: screenHeight * 0.1),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterPill(String label, int count, bool isSelected) {
    return GestureDetector(
      onTap: () {
        context.read<MedicinesBloc>().add(SelectFilter(label));
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
}
