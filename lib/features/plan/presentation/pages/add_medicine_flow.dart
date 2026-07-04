import 'package:flutter/material.dart';
import 'add_medicine/medication_name_page.dart';
import 'add_medicine/form_dose_page.dart';
import 'add_medicine/frequency_page.dart';
import 'add_medicine/upload_picture_page.dart';
import 'package:gestanea/core/constants/app_colors.dart';
import 'package:gestanea/core/database/models/medicine_model.dart';
import 'package:gestanea/features/plan/data/repositories/medicine_repository.dart';
import 'package:uuid/uuid.dart';
import 'package:gestanea/l10n/app_localizations.dart';

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

  String? selectedMedication;
  String? selectedForm;
  double selectedDose = 0.5;
  int frequencyNumber = 1;
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
    final t = AppLocalizations.of(context)!;
    if (selectedMedication == null || selectedMedication!.isEmpty) {
      _showError(t.pleaseEnterMedicationName);
      return;
    }

    if (selectedForm == null || selectedForm!.isEmpty) {
      _showError(t.pleaseSelectForm);
      return;
    }

    if (startingDate == null) {
      _showError(t.pleaseSelectStartDate);
      return;
    }

    if (scheduledTimes.isEmpty) {
      _showError(AppLocalizations.of(context)!.pleaseAddScheduledTime);
      return;
    }

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
        maxDoses: null,
        medicineImageUrl: medicationImage,
        isActive: true,
        createdAt: DateTime.now(),
      );

      final result = await _medicineRepository.insertMedicine(medicine);

      if (result.state) {
        if (mounted) {
          Navigator.pop(context, true); // Return true to indicate success
        }
      } else {
        _showError(result.message);
      }
    } catch (e) {
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
                      setState(() => selectedMedication = med);
                      _nextPage();
                    },
                    onBack: _previousPage,
                  ),
                  FormDosePage(
                    selectedForm: selectedForm,
                    selectedDose: selectedDose,
                    onFormSelected: (form) =>
                        setState(() => selectedForm = form),
                    onDoseChanged: (dose) =>
                        setState(() => selectedDose = dose),
                    onNext: _nextPage,
                    onBack: _previousPage,
                  ),
                  FrequencyPage(
                    onNext: _nextPage,
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
                    ? const Color(0xFFA67FF5)
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
