import 'package:flutter/material.dart';
import 'package:gestanea/core/constants/app_colors.dart';
import 'package:gestanea/core/constants/app_text_styles.dart';
import 'package:gestanea/core/widgets/custom_button.dart';

class AddMeasurementDialog extends StatefulWidget {
  const AddMeasurementDialog({super.key});

  @override
  State<AddMeasurementDialog> createState() => _AddMeasurementDialogState();
}

class _AddMeasurementDialogState extends State<AddMeasurementDialog> {
  final _formKey = GlobalKey<FormState>();
  final _weightController = TextEditingController();
  final _heartRateController = TextEditingController();
  final _systolicController = TextEditingController();
  final _diastolicController = TextEditingController();
  DateTime _selectedDateTime = DateTime.now();

  @override
  void dispose() {
    _weightController.dispose();
    _heartRateController.dispose();
    _systolicController.dispose();
    _diastolicController.dispose();
    super.dispose();
  }

  Future<void> _selectDateTime(BuildContext context) async {
    final date = await showDatePicker(
      context: context,
      initialDate: _selectedDateTime,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );

    if (date != null && context.mounted) {
      final time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(_selectedDateTime),
      );

      if (time != null) {
        setState(() {
          _selectedDateTime = DateTime(
            date.year,
            date.month,
            date.day,
            time.hour,
            time.minute,
          );
        });
      }
    }
  }

  void _saveMeasurement() {
    if (_formKey.currentState!.validate()) {
      // TODO: Save measurement data
      Navigator.pop(context);
    }
  }

  Widget _buildNeumorphicInputField({
    required String label,
    required TextEditingController controller,
    required String suffix,
    TextInputType keyboardType = TextInputType.number,
    String? Function(String?)? validator,
  }) {
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
          Text(
            label,
            style: AppTextStyles.smallLabel.copyWith(
              fontSize: 12,
              color: AppColors.textDark,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: controller,
            keyboardType: keyboardType,
            validator: validator,
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: 'Enter $label',
              suffixText: suffix,
              suffixStyle: AppTextStyles.body1.copyWith(
                color: AppColors.textSecondary,
              ),
              contentPadding: EdgeInsets.zero,
            ),
            style: AppTextStyles.headline2.copyWith(
              fontSize: 18,
              color: AppColors.textDark,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      decoration: const BoxDecoration(
        color: AppColors.bg_1,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Drag handle
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.textSecondary.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 20),

              // Title
              Text(
                'Add Measurement',
                style: AppTextStyles.headline2.copyWith(
                  fontSize: 22,
                  color: AppColors.textDark,
                ),
              ),
              const SizedBox(height: 20),

              // Weight Input
              _buildNeumorphicInputField(
                label: 'Weight',
                controller: _weightController,
                suffix: 'kg',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter weight';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),

              // Heart Rate Input
              _buildNeumorphicInputField(
                label: 'Heart Rate',
                controller: _heartRateController,
                suffix: 'bpm',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter heart rate';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),

              // Blood Pressure Inputs
              Row(
                children: [
                  Expanded(
                    child: _buildNeumorphicInputField(
                      label: 'Systolic',
                      controller: _systolicController,
                      suffix: 'mmHg',
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Required';
                        }
                        if (int.tryParse(value) == null) {
                          return 'Invalid';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildNeumorphicInputField(
                      label: 'Diastolic',
                      controller: _diastolicController,
                      suffix: 'mmHg',
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Required';
                        }
                        if (int.tryParse(value) == null) {
                          return 'Invalid';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Date & Time Picker
              GestureDetector(
                onTap: () => _selectDateTime(context),
                child: Container(
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
                  child: Row(
                    children: [
                      const Icon(Icons.calendar_today, color: AppColors.main500),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Date & Time',
                              style: AppTextStyles.smallLabel.copyWith(
                                fontSize: 12,
                                color: AppColors.textDark,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${_selectedDateTime.day}/${_selectedDateTime.month}/${_selectedDateTime.year} ${_selectedDateTime.hour}:${_selectedDateTime.minute.toString().padLeft(2, '0')}',
                              style: AppTextStyles.body1.copyWith(
                                color: AppColors.textDark,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Buttons
              Row(
                children: [
                  Expanded(
                    child: AppButton(
                      onPressed: () => Navigator.pop(context),
                      text: 'Cancel',
                      filled: false,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: AppButton(
                      onPressed: _saveMeasurement,
                      text: 'Save',
                      filled: true,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void showAddMeasurementDialog(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => const AddMeasurementDialog(),
  );
}
