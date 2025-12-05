import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gestanea/core/constants/app_colors.dart';
import 'package:gestanea/core/widgets/Sub_Header.dart';
import 'package:gestanea/l10n/app_localizations.dart';
import 'package:gestanea/features/plan/presentation/widgets/medicine_card.dart';
import 'package:gestanea/core/database/models/medicine_model.dart';
import 'package:gestanea/core/database/models/medicine_logged_model.dart';
import 'package:uuid/uuid.dart';
import '../../logic/plan_bloc.dart';
import '../../core/plan_constants.dart';
import 'plan_page.dart';

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
    _loadMedicines();
  }

  void _loadMedicines() {
    context.read<PlanBloc>().add(
      LoadMedicines(userId: PlanConstants.mockUserId),
    );
  }

  List<MedicineModel> _getFilteredMedicines(
    List<MedicineModel> medicines,
    List<MedicineLoggedModel> logs,
  ) {
    if (selectedFilter == 'All') {
      return medicines;
    } else if (selectedFilter == 'Taken') {
      return medicines.where((med) {
        final log = logs.firstWhere(
          (l) => l.medicineId == med.id,
          orElse: () => MedicineLoggedModel(
            id: '',
            medicineId: '',
            userId: '',
            loggedDate: DateTime.now(),
            status: '',
            loggedAt: DateTime.now(),
          ),
        );
        return log.status == 'taken';
      }).toList();
    } else {
      // Missed
      return medicines.where((med) {
        final log = logs.firstWhere(
          (l) => l.medicineId == med.id,
          orElse: () => MedicineLoggedModel(
            id: '',
            medicineId: '',
            userId: '',
            loggedDate: DateTime.now(),
            status: '',
            loggedAt: DateTime.now(),
          ),
        );
        return log.status == 'missed';
      }).toList();
    }
  }

  int _getFilterCount(
    String filter,
    List<MedicineModel> medicines,
    List<MedicineLoggedModel> logs,
  ) {
    if (filter == 'All') {
      return medicines.length;
    } else if (filter == 'Taken') {
      return logs.where((l) => l.status == 'taken').length;
    } else {
      return logs.where((l) => l.status == 'missed').length;
    }
  }

  Future<void> _handleTakeMedicine(MedicineModel medicine) async {
    final uuid = Uuid();
    final log = MedicineLoggedModel(
      id: uuid.v4(),
      medicineId: medicine.id,
      userId: PlanConstants.mockUserId,
      loggedDate: DateTime.now(),
      status: 'taken',
      loggedAt: DateTime.now(),
    );

    context.read<PlanBloc>().add(LogMedicineEvent(log: log));
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
              onBackPressed: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => const PlanMainPage()),
                );
              },
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
                          child: BlocBuilder<PlanBloc, PlanState>(
                            builder: (context, state) {
                              List<MedicineModel> medicines = [];
                              List<MedicineLoggedModel> logs = [];

                              if (state is MedicinesLoaded) {
                                medicines = state.medicines;
                                logs = state.medicineLogs;
                              } else if (state is PlanLoaded) {
                                medicines = state.medicines;
                                logs = state.medicineLogs;
                              }

                              return Row(
                                children: [
                                  _buildFilterPill('All', medicines, logs),
                                  SizedBox(width: 12),
                                  _buildFilterPill('Taken', medicines, logs),
                                  SizedBox(width: 12),
                                  _buildFilterPill('Missed', medicines, logs),
                                ],
                              );
                            },
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
                      child: BlocBuilder<PlanBloc, PlanState>(
                        builder: (context, state) {
                          if (state is PlanLoading) {
                            return Center(
                              child: CircularProgressIndicator(
                                color: AppColors.main500,
                              ),
                            );
                          }

                          if (state is PlanError) {
                            return Center(
                              child: Padding(
                                padding: EdgeInsets.all(screenHeight * 0.05),
                                child: Text(
                                  'Error: ${state.message}',
                                  style: TextStyle(
                                    fontSize: screenWidth * 0.04,
                                    color: Colors.red,
                                  ),
                                ),
                              ),
                            );
                          }

                          List<MedicineModel> medicines = [];
                          List<MedicineLoggedModel> logs = [];

                          if (state is MedicinesLoaded) {
                            medicines = state.medicines;
                            logs = state.medicineLogs;
                          } else if (state is PlanLoaded) {
                            medicines = state.medicines;
                            logs = state.medicineLogs;
                          }

                          final filteredMedicines = _getFilteredMedicines(
                            medicines,
                            logs,
                          );

                          if (filteredMedicines.isEmpty) {
                            return Center(
                              child: Padding(
                                padding: EdgeInsets.all(screenHeight * 0.05),
                                child: Text(
                                  'No medicines found',
                                  style: TextStyle(
                                    fontSize: screenWidth * 0.04,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                              ),
                            );
                          }

                          return Column(
                            children: filteredMedicines.map((medicine) {
                              final log = logs.firstWhere(
                                (l) => l.medicineId == medicine.id,
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
                                      medicine.scheduledTimes?.first ?? '00:00',
                                  screenWidth: screenWidth,
                                  screenHeight: screenHeight,
                                  onTakeMedicine: () =>
                                      _handleTakeMedicine(medicine),
                                ),
                              );
                            }).toList(),
                          );
                        },
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

  Widget _buildFilterPill(
    String label,
    List<MedicineModel> medicines,
    List<MedicineLoggedModel> logs,
  ) {
    final isSelected = selectedFilter == label;
    final count = _getFilterCount(label, medicines, logs);
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
