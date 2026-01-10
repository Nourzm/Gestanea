import 'package:flutter/material.dart';
import 'package:gestanea/core/constants/app_colors.dart';
import 'package:gestanea/core/widgets/Sub_Header.dart';
import 'package:gestanea/l10n/app_localizations.dart';
import 'package:gestanea/features/plan/presentation/widgets/medicine_card.dart';
import 'package:gestanea/core/database/models/medicine_model.dart';
import 'package:gestanea/core/database/models/medicine_logged_model.dart';
import 'package:gestanea/features/plan/data/mock_data/plan_mock_data.dart';
import 'package:uuid/uuid.dart';

class MedicinesPage extends StatefulWidget {
  const MedicinesPage({super.key});

  @override
  State<MedicinesPage> createState() => _MedicinesPageState();
}

class _MedicinesPageState extends State<MedicinesPage> {
  String selectedFilter = 'All'; // All, Taken, Missed
  bool _showFilters = true;
  final ScrollController _scrollController = ScrollController();

  List<MedicineModel> _medicines = [];
  List<MedicineLoggedModel> _medicineLogs = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _loadMedicines();
  }

  Future<void> _loadMedicines() async {
    // TODO: Replace with actual user ID from auth
    // final userId = PlanMockData.mockUserId;

    try {
      // Use mock data for now
      // final medicines = await _dataSource.getMedicines(userId);
      // final logs = await _dataSource.getMedicineLogs(userId, DateTime.now());

      final mockMedicines = PlanMockData.getMockMedicines();
      final mockLogs = PlanMockData.getMockMedicineLogs(mockMedicines);

      setState(() {
        _medicines = mockMedicines;
        _medicineLogs = mockLogs;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      // Handle error
    }
  }

  List<MedicineModel> get filteredMedicines {
    if (selectedFilter == 'All') {
      return _medicines;
    } else if (selectedFilter == 'Taken') {
      return _medicines.where((med) {
        final log = _medicineLogs.firstWhere(
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
      return _medicines.where((med) {
        final log = _medicineLogs.firstWhere(
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

  int _getFilterCount(String filter) {
    if (filter == 'All') {
      return _medicines.length;
    } else if (filter == 'Taken') {
      return _medicineLogs.where((l) => l.status == 'taken').length;
    } else {
      return _medicineLogs.where((l) => l.status == 'missed').length;
    }
  }

  Future<void> _handleTakeMedicine(MedicineModel medicine) async {
    final uuid = Uuid();
    final log = MedicineLoggedModel(
      id: uuid.v4(),
      medicineId: medicine.id,
      userId: PlanMockData.mockUserId,
      loggedDate: DateTime.now(),
      status: 'taken',
      loggedAt: DateTime.now(),
    );

    // TODO: Save to database
    // await _dataSource.logMedicine(log);

    setState(() {
      _medicineLogs.add(log);
    });
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
                      child: _isLoading
                          ? Center(
                              child: CircularProgressIndicator(
                                color: AppColors.main500,
                              ),
                            )
                          : filteredMedicines.isEmpty
                          ? Center(
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
                            )
                          : Column(
                              children: filteredMedicines.map((medicine) {
                                final log = _medicineLogs.firstWhere(
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
                                        medicine.scheduledTimes?.first ??
                                        '00:00',
                                    screenWidth: screenWidth,
                                    screenHeight: screenHeight,
                                    onTakeMedicine: () =>
                                        _handleTakeMedicine(medicine),
                                  ),
                                );
                              }).toList(),
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

  Widget _buildFilterPill(String label, int? providedCount) {
    final isSelected = selectedFilter == label;
    final count = providedCount ?? _getFilterCount(label);
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
