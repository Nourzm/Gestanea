import 'package:flutter/material.dart';
import 'add_medicine/medication_name_page.dart';
import 'add_medicine/form_dose_page.dart';
import 'add_medicine/frequency_page.dart';
import 'add_medicine/upload_picture_page.dart';
import 'package:gestanea/core/constants/app_colors.dart';
import 'package:gestanea/core/database/models/medicine_model.dart';
import 'package:gestanea/features/plan/data/repositories/medicine_repository.dart';
import 'package:gestanea/core/services/alarm_scheduler.dart';
import 'package:uuid/uuid.dart';
import 'package:gestanea/l10n/app_localizations.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gestanea/core/theme/theme_cubit.dart';

class AddMedicineFlow extends StatefulWidget {
  final String userId;

  const AddMedicineFlow({super.key, required this.userId});

  @override
  State<AddMedicineFlow> createState() => _AddMedicineFlowState();
}

class _AddMedicineFlowState extends State<AddMedicineFlow> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  final _medicineRepository = MedicineRepository.getInstance();
  final _alarmScheduler = AlarmScheduler();

  String? selectedMedication;
  String? selectedForm;
  double? selectedDose;
  int? frequencyNumber;
  String frequencyType = 'daily';
  List<String> scheduledTimes = [];

  DateTime? startingDate;
  DateTime? endingDate;
  String? medicationImage;

  void _nextPage() {
    if (_currentPage < 3) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _previousPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      Navigator.pop(context);
    }
  }

  Future<void> _saveMedicine() async {
    try {
      final uuid = Uuid();
      final medicine = MedicineModel(
        id: uuid.v4(),
        userId: widget.userId,
        babyId: null,
        medicineName: selectedMedication!,

        dosage: '$selectedDose $selectedForm',
        type: selectedForm,
        frequencyType: frequencyType,
        frequencyValue: frequencyNumber,
        scheduledTimes: scheduledTimes,
        startDate: startingDate!,
        endDate: endingDate,
        medicineImageUrl: medicationImage,
        isActive: true,
        createdAt: DateTime.now(),
      );
      print('💊 Saving medicine: ${medicine.medicineName}');
      print('   Times: ${medicine.scheduledTimes}');
      print('   Start date: ${medicine.startDate}');

      // Save medicine to database
      final result = await _medicineRepository.insertMedicine(medicine);

      if (result.state) {
        print('✅ Medicine saved to database');

        // Schedule alarms for this medicine
        if (medicine.scheduledTimes != null &&
            medicine.scheduledTimes!.isNotEmpty) {
          print('⏰ Scheduling alarms for medicine...');

          await _alarmScheduler.scheduleMedicineAlarms(
            medicineId: medicine.id,
            medicineName: medicine.medicineName,
            dosage: medicine.dosage,
            scheduledTimes: medicine.scheduledTimes!,
            startDate: medicine.startDate,
            endDate: medicine.endDate,
          );

          print('✅ Alarms scheduled successfully');
        }

        if (mounted) {
          Navigator.pop(context, true);
        }
      } else {
        _showError(result.message);
        Navigator.pop(context, true);
      }
    } catch (e) {
      print('❌ Error saving medicine: $e');
      _showError('Failed to save medicine: $e');
    }
  }

  void _showError(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message), backgroundColor: Colors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg_1,
      body: SafeArea(
        child: Column(
          children: [
            _buildProgressIndicator(),
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                onPageChanged: (index) {
                  setState(() => _currentPage = index);
                },
                children: [
                  MedicationNamePage(
                    onMedicationSelected: (med) {
                      if (med.length <= 2) {
                        _showError(
                          'Medicine name must be greater than 2 characters',
                        );
                        return;
                      }
                      setState(() => selectedMedication = med);
                      _nextPage();
                    },
                    onBack: _previousPage,
                  ),
                  FormDosePage(
                    selectedForm: selectedForm,
                    selectedDose: selectedDose ?? 0,
                    onFormSelected: (form) =>
                        setState(() => selectedForm = form),
                    onDoseChanged: (dose) =>
                        setState(() => selectedDose = dose),
                    onNext: () {
                      if (selectedForm == null || selectedForm!.isEmpty) {
                        _showError('Please select a form');
                        return;
                      }
                      if (selectedDose == null || selectedDose! <= 0) {
                        _showError('Please enter a valid dose');
                        return;
                      }
                      _nextPage();
                    },
                    onBack: _previousPage,
                  ),
                  FrequencyPage(
                    onNext: () {
                      if (frequencyNumber == null || frequencyNumber! <= 0) {
                        _showError('Please enter a valid frequency value');
                        return;
                      }

                      if (startingDate == null) {
                        _showError('Please select a starting date');
                        return;
                      }
                      if (scheduledTimes.isEmpty) {
                        _showError(
                          AppLocalizations.of(context)!.pleaseAddScheduledTime,
                        );
                        return;
                      }
                      _nextPage();
                    },
                    onBack: _previousPage,
                    onFrequencyChanged: (freq) =>
                        setState(() => frequencyNumber = freq),
                    onFrequencyTypeChanged: (type) =>
                        setState(() => frequencyType = type),
                    onScheduledTimesChanged: (times) =>
                        setState(() => scheduledTimes = times),
                    onDateSelected: (date) =>
                        setState(() => startingDate = date),
                    onEndDateSelected: (date) =>
                        setState(() => endingDate = date),
                  ),

                  UploadPicturePage(
                    onBack: _previousPage,
                    initialImagePath: medicationImage,
                    onImageSelected: (imagePath) {
                      setState(() => medicationImage = imagePath);
                    },
                    onDone: () async {
                      await _saveMedicine();
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressIndicator() {
    final themeData = context.watch<ThemeCubit>().currentTheme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Row(
        children: List.generate(4, (index) {
          return Expanded(
            child: Container(
              height: 4,
              margin: EdgeInsets.only(right: index < 3 ? 8 : 0),
              decoration: BoxDecoration(
                color: index <= _currentPage
                    ? themeData.primaryColor
                    : const Color(0xFFD9D9D9),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          );
        }),
      ),
    );
  }
}
