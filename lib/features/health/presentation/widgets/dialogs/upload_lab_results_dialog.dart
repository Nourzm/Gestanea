import 'package:flutter/material.dart';
import 'package:gestanea/core/constants/app_colors.dart';
import 'package:gestanea/core/constants/app_text_styles.dart';
import 'package:gestanea/core/widgets/custom_button.dart';

class UploadLabResultsDialog extends StatefulWidget {
  const UploadLabResultsDialog({super.key});

  @override
  State<UploadLabResultsDialog> createState() => _UploadLabResultsDialogState();
}

class _UploadLabResultsDialogState extends State<UploadLabResultsDialog> {
  final _formKey = GlobalKey<FormState>();
  final _testValueController = TextEditingController();
  final _normalRangeController = TextEditingController();
  final _notesController = TextEditingController();
  String? _selectedTestName;
  DateTime _selectedDate = DateTime.now();
  bool _hasFileAttached = false;

  final List<String> _commonTests = [
    'Hemoglobin',
    'Glucose',
    'Blood Pressure',
    'Protein (Urine)',
    'Iron Level',
    'Thyroid Function',
    'Ultrasound',
    'Other',
  ];

  @override
  void dispose() {
    _testValueController.dispose();
    _normalRangeController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
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

  void _attachFile() {
    // TODO: Implement file picker
    setState(() {
      _hasFileAttached = !_hasFileAttached;
    });
  }

  void _saveLabResult() {
    if (_formKey.currentState!.validate()) {
      // TODO: Save lab result data
      Navigator.pop(context);
    }
  }

  Widget _buildNeumorphicContainer({required Widget child}) {
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
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      decoration: const BoxDecoration(
        color: Color(0xFFFAF0FF),
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
                'Upload Lab Results',
                style: AppTextStyles.headline2.copyWith(
                  fontSize: 22,
                  color: AppColors.textDark,
                ),
              ),
              const SizedBox(height: 20),

              // Test Name Dropdown
              _buildNeumorphicContainer(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Test Name',
                      style: AppTextStyles.smallLabel.copyWith(
                        fontSize: 12,
                        color: AppColors.textDark,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<String>(
                      value: _selectedTestName,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.zero,
                      ),
                      hint: Text(
                        'Select test',
                        style: AppTextStyles.body1.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                      items: _commonTests.map((test) {
                        return DropdownMenuItem(
                          value: test,
                          child: Text(test),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedTestName = value;
                        });
                      },
                      validator: (value) {
                        if (value == null) {
                          return 'Please select a test';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),

              // Test Value Input
              _buildNeumorphicContainer(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Test Value',
                      style: AppTextStyles.smallLabel.copyWith(
                        fontSize: 12,
                        color: AppColors.textDark,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _testValueController,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: 'e.g., 12.5 g/dL',
                        contentPadding: EdgeInsets.zero,
                      ),
                      style: AppTextStyles.body1.copyWith(
                        color: AppColors.textDark,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter test value';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),

              // Normal Range Input
              _buildNeumorphicContainer(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Normal Range',
                      style: AppTextStyles.smallLabel.copyWith(
                        fontSize: 12,
                        color: AppColors.textDark,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _normalRangeController,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: 'e.g., 12-16 g/dL',
                        contentPadding: EdgeInsets.zero,
                      ),
                      style: AppTextStyles.body1.copyWith(
                        color: AppColors.textDark,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),

              // Date Picker
              GestureDetector(
                onTap: () => _selectDate(context),
                child: _buildNeumorphicContainer(
                  child: Row(
                    children: [
                      const Icon(Icons.calendar_today, color: AppColors.main500),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Date of Test',
                              style: AppTextStyles.smallLabel.copyWith(
                                fontSize: 12,
                                color: AppColors.textDark,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
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
              const SizedBox(height: 12),

              // File Upload Button
              GestureDetector(
                onTap: _attachFile,
                child: _buildNeumorphicContainer(
                  child: Row(
                    children: [
                      Icon(
                        _hasFileAttached ? Icons.check_circle : Icons.upload_file,
                        color: _hasFileAttached ? Colors.green : AppColors.main500,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          _hasFileAttached ? 'File Attached' : 'Attach File (Optional)',
                          style: AppTextStyles.body1.copyWith(
                            color: AppColors.textDark,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const Icon(Icons.arrow_forward_ios, size: 16, color: AppColors.textSecondary),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // Notes Input
              _buildNeumorphicContainer(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Notes',
                      style: AppTextStyles.smallLabel.copyWith(
                        fontSize: 12,
                        color: AppColors.textDark,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _notesController,
                      maxLines: 3,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Additional notes...',
                        contentPadding: EdgeInsets.zero,
                      ),
                      style: AppTextStyles.body1.copyWith(
                        color: AppColors.textDark,
                      ),
                    ),
                  ],
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
                      onPressed: _saveLabResult,
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

void showUploadLabResultsDialog(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => const UploadLabResultsDialog(),
  );
}
