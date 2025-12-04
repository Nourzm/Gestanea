import 'package:flutter/material.dart';
import 'package:gestanea/core/constants/app_colors.dart';
import 'package:gestanea/core/constants/app_text_styles.dart';
import 'package:gestanea/core/widgets/custom_button.dart';

class AddSymptomDialog extends StatefulWidget {
  const AddSymptomDialog({super.key});

  @override
  State<AddSymptomDialog> createState() => _AddSymptomDialogState();
}

class _AddSymptomDialogState extends State<AddSymptomDialog> {
  final _formKey = GlobalKey<FormState>();
  final _durationController = TextEditingController();
  final _notesController = TextEditingController();
  String? _selectedSymptom;
  String _selectedSeverity = 'Mild';
  DateTime _selectedDateTime = DateTime.now();

  final List<String> _commonSymptoms = [
    'Back Pain',
    'Heartburn',
    'Swollen Feet',
    'Trouble Sleeping',
    'Nausea',
    'Headache',
    'Fatigue',
    'Leg Cramps',
    'Other',
  ];

  final List<String> _severityLevels = ['Mild', 'Moderate', 'Severe'];

  @override
  void dispose() {
    _durationController.dispose();
    _notesController.dispose();
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

  void _saveSymptom() {
    if (_formKey.currentState!.validate()) {
      // TODO: Save symptom data
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

  Widget _buildSeveritySelector() {
    return _buildNeumorphicContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Severity',
            style: AppTextStyles.smallLabel.copyWith(
              fontSize: 12,
              color: AppColors.textDark,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: _severityLevels.map((severity) {
              final isSelected = _selectedSeverity == severity;
              Color badgeColor;
              if (severity == 'Mild') {
                badgeColor = const Color(0xFFFFF3CD);
              } else if (severity == 'Moderate') {
                badgeColor = const Color(0xFFFFE0B2);
              } else {
                badgeColor = const Color(0xFFFFC4C4);
              }

              return Expanded(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedSeverity = severity;
                    });
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      color: isSelected ? badgeColor : AppColors.main300,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isSelected ? AppColors.main500 : Colors.transparent,
                        width: 2,
                      ),
                    ),
                    child: Text(
                      severity,
                      textAlign: TextAlign.center,
                      style: AppTextStyles.smallLabel.copyWith(
                        fontSize: 12,
                        color: AppColors.textDark,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
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
                'Log New Symptom',
                style: AppTextStyles.headline2.copyWith(
                  fontSize: 22,
                  color: AppColors.textDark,
                ),
              ),
              const SizedBox(height: 20),

              // Symptom Dropdown
              _buildNeumorphicContainer(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Symptom Type',
                      style: AppTextStyles.smallLabel.copyWith(
                        fontSize: 12,
                        color: AppColors.textDark,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<String>(
                      value: _selectedSymptom,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.zero,
                      ),
                      hint: Text(
                        'Select symptom',
                        style: AppTextStyles.body1.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                      items: _commonSymptoms.map((symptom) {
                        return DropdownMenuItem(
                          value: symptom,
                          child: Text(symptom),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedSymptom = value;
                        });
                      },
                      validator: (value) {
                        if (value == null) {
                          return 'Please select a symptom';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),

              // Severity Selector
              _buildSeveritySelector(),
              const SizedBox(height: 12),

              // Duration Input
              _buildNeumorphicContainer(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Duration',
                      style: AppTextStyles.smallLabel.copyWith(
                        fontSize: 12,
                        color: AppColors.textDark,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _durationController,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: 'e.g., 2 hours, All day',
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
                        hintText: 'Additional details...',
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

              // Date & Time Picker
              GestureDetector(
                onTap: () => _selectDateTime(context),
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
                      onPressed: _saveSymptom,
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

void showAddSymptomDialog(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => const AddSymptomDialog(),
  );
}
