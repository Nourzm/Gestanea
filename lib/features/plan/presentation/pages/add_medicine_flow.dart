import 'package:flutter/material.dart';
import 'add_medicine/medication_name_page.dart';
import 'add_medicine/form_dose_page.dart';
import 'add_medicine/frequency_page.dart';
import 'add_medicine/upload_picture_page.dart';
import 'package:gestanea/core/constants/app_colors.dart';

class AddMedicineFlow extends StatefulWidget {
  const AddMedicineFlow({super.key});

  @override
  State<AddMedicineFlow> createState() => _AddMedicineFlowState();
}

class _AddMedicineFlowState extends State<AddMedicineFlow> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  String? selectedMedication;
  String? selectedForm;
  double selectedDose = 0.5;
  int frequencyNumber = 1;

  DateTime? startingDate;
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
                  FrequencyPage(onNext: _nextPage, onBack: _previousPage),

                  UploadPicturePage(
                    onBack: _previousPage,
                    onDone: () {
                      Navigator.pop(context);
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
