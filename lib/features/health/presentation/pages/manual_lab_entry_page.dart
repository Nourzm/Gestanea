import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gestanea/core/constants/app_colors.dart';
import 'package:gestanea/core/constants/app_text_styles.dart';
import 'package:gestanea/core/widgets/custom_button.dart';
import 'package:gestanea/core/database/models/lab_result_model.dart';
import 'package:gestanea/l10n/app_localizations.dart';
import '../../logic/bloc/lab_results_bloc.dart';
import '../../logic/bloc/lab_results_event.dart';

class ManualLabEntryPage extends StatefulWidget {
  const ManualLabEntryPage({super.key});

  @override
  State<ManualLabEntryPage> createState() => _ManualLabEntryPageState();
}

class _ManualLabEntryPageState extends State<ManualLabEntryPage> {
  final _formKey = GlobalKey<FormState>();
  final _testNameController = TextEditingController();
  final _valueController = TextEditingController();
  final _unitController = TextEditingController();
  final _minRangeController = TextEditingController();
  final _maxRangeController = TextEditingController();
  final _notesController = TextEditingController();

  DateTime _selectedDate = DateTime.now();

  @override
  void dispose() {
    _testNameController.dispose();
    _valueController.dispose();
    _unitController.dispose();
    _minRangeController.dispose();
    _maxRangeController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );

    if (date != null) {
      setState(() {
        _selectedDate = date;
      });
    }
  }

  void _saveResult() {
    if (_formKey.currentState!.validate()) {
      final labResult = LabResultModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        userId: '', // real owner is stamped by the bloc on insert
        testName: _testNameController.text,
        value: double.tryParse(_valueController.text),
        unit: _unitController.text.isNotEmpty ? _unitController.text : null,
        normalRangeMin: double.tryParse(_minRangeController.text),
        normalRangeMax: double.tryParse(_maxRangeController.text),
        interpretation: _notesController.text.isNotEmpty
            ? _notesController.text
            : null,
        labDate: _selectedDate,
        extractedByOcr: false,
        createdAt: DateTime.now(),
      );

      context.read<LabResultsBloc>().add(AddLabResult(labResult));

      Navigator.pop(context);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.labResultAdded),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(t.manualLabEntry),
        backgroundColor: AppColors.main500,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                t.enterLabDetails,
                style: AppTextStyles.headline2.copyWith(
                  fontSize: 18,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 20),

              // Test Name
              _buildTextField(
                controller: _testNameController,
                label: t.testNameRequired,
                hint: 'e.g., Hemoglobin, Glucose',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return t.pleaseEnterTestName;
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Value
              _buildTextField(
                controller: _valueController,
                label: t.valueRequired,
                hint: 'e.g., 12.5',
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return t.pleaseEnterValue;
                  }
                  if (double.tryParse(value) == null) {
                    return t.pleaseEnterValidNumber;
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Unit
              _buildTextField(
                controller: _unitController,
                label: t.unitLabel,
                hint: 'e. g., g/dL, mg/dL',
              ),
              const SizedBox(height: 16),

              // Normal Range
              Text(
                t.normalRangeLabel,
                style: AppTextStyles.subtitle1.copyWith(
                  fontSize: 14,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: _buildTextField(
                      controller: _minRangeController,
                      label: t.minLabel,
                      hint: '12',
                      keyboardType: TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildTextField(
                      controller: _maxRangeController,
                      label: t.maxLabel,
                      hint: '16',
                      keyboardType: TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Date
              Text(
                t.testDate,
                style: AppTextStyles.subtitle1.copyWith(
                  fontSize: 14,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: _selectDate,
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.main300),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.calendar_today,
                        color: AppColors.main500,
                        size: 20,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                        style: AppTextStyles.body1,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Notes
              _buildTextField(
                controller: _notesController,
                label: t.notesOptional,
                hint: t.anyAdditionalNotes,
                maxLines: 3,
              ),
              const SizedBox(height: 30),

              // Save Button
              SizedBox(
                width: double.infinity,
                child: AppButton(
                  onPressed: _saveResult,
                  text: t.saveResult,
                  filled: true,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    String? hint,
    int maxLines = 1,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.subtitle1.copyWith(
            fontSize: 14,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Colors.grey.shade400),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppColors.main300),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppColors.main300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.main500, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.red),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
          ),
          validator: validator,
        ),
      ],
    );
  }
}
