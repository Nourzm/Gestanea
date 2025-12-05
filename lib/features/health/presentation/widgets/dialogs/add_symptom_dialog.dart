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
  final _otherSymptomController = TextEditingController();
  
  String? _selectedSymptom;
  String? _selectedSeverity;
  DateTime _selectedDate = DateTime.now();

  final List<String> _symptoms = [
    'Nausea',
    'Headache',
    'Back Pain',
    'Swelling',
    'Fatigue',
    'Dizziness',
    'Heartburn',
    'Leg Cramps',
    'Other',
  ];

  @override
  void dispose() {
    _durationController.dispose();
    _notesController.dispose();
    _otherSymptomController.dispose();
    super.dispose();
  }

  void _handleSave() {
    if (_formKey.currentState!.validate()) {
      if (_selectedSymptom == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select a symptom')),
        );
        return;
      }
      if (_selectedSeverity == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select severity')),
        );
        return;
      }

      final symptom = _selectedSymptom == 'Other' 
          ? _otherSymptomController.text 
          : _selectedSymptom;
      
      print('Symptom: $symptom');
      print('Severity: $_selectedSeverity');
      print('Duration: ${_durationController.text}');
      print('Notes: ${_notesController. text}');
      print('Date: $_selectedDate');
      
      Navigator.pop(context);
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Symptom logged successfully!'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  Future<void> _selectDateTime() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    
    if (date != null) {
      final time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay. fromDateTime(_selectedDate),
      );
      
      if (time != null) {
        setState(() {
          _selectedDate = DateTime(
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

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        decoration: const BoxDecoration(
          color: Color(0xFFFAF0FF),
          borderRadius: BorderRadius.vertical(top: Radius. circular(20)),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey. shade600.withOpacity(0.3),
                      borderRadius: BorderRadius. circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                
                Center(
                  child: Text(
                    'Add Symptom',
                    style: AppTextStyles.headline2.copyWith(
                      fontSize: 20,
                      color: AppColors. textDark,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                
                Text(
                  'Symptom Type',
                  style: AppTextStyles.subtitle1.copyWith(
                    fontSize: 14,
                    color: AppColors. textDark,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors. white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x3F000000),
                        blurRadius: 4,
                        offset: Offset(2, 2),
                      ),
                      BoxShadow(
                        color: AppColors.white,
                        blurRadius: 6,
                        offset: Offset(-3, -3),
                      ),
                    ],
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      isExpanded: true,
                      hint: Text(
                        'Select symptom',
                        style: AppTextStyles.body1.copyWith(
                          color: Colors.grey. shade600,
                        ),
                      ),
                      value: _selectedSymptom,
                      items: _symptoms.map((symptom) {
                        return DropdownMenuItem(
                          value: symptom,
                          child: Text(symptom),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() => _selectedSymptom = value);
                      },
                    ),
                  ),
                ),
                
                if (_selectedSymptom == 'Other') ...[
                  const SizedBox(height: 12),
                  _buildTextField(
                    controller: _otherSymptomController,
                    label: 'Specify symptom',
                    validator: (value) {
                      if (_selectedSymptom == 'Other' && (value == null || value.isEmpty)) {
                        return 'Please specify the symptom';
                      }
                      return null;
                    },
                  ),
                ],
                
                const SizedBox(height: 20),
                
                Text(
                  'Severity',
                  style: AppTextStyles.subtitle1.copyWith(
                    fontSize: 14,
                    color: AppColors.textDark,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _buildSeverityButton('Mild', const Color(0xFFB8E6B8)),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _buildSeverityButton('Moderate', const Color(0xFFFFE4B5)),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _buildSeverityButton('Severe', const Color(0xFFFFB8B8)),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                
                _buildTextField(
                  controller: _durationController,
                  label: 'Duration (e.g., 2 hours, All day)',
                  validator: (value) {
                    if (value == null || value. isEmpty) {
                      return 'Please enter duration';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                
                _buildTextField(
                  controller: _notesController,
                  label: 'Notes (optional)',
                  maxLines: 3,
                ),
                const SizedBox(height: 16),
                
                GestureDetector(
                  onTap: _selectDateTime,
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius. circular(16),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x3F000000),
                          blurRadius: 4,
                          offset: Offset(2, 2),
                        ),
                        BoxShadow(
                          color: AppColors.white,
                          blurRadius: 6,
                          offset: Offset(-3, -3),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.calendar_today, color: AppColors.main500, size: 20),
                        const SizedBox(width: 12),
                        Text(
                          '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year} ${_selectedDate.hour}:${_selectedDate.minute.toString().padLeft(2, '0')}',
                          style: AppTextStyles.body1.copyWith(
                            color: AppColors.textDark,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                
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
                        onPressed: _handleSave,
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
      ),
    );
  }

  Widget _buildSeverityButton(String severity, Color color) {
    final isSelected = _selectedSeverity == severity;
    
    return GestureDetector(
      onTap: () => setState(() => _selectedSeverity = severity),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? color : Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4,
                    offset: const Offset(2, 2),
                    spreadRadius: -2,
                  ),
                ]
              : const [
                  BoxShadow(
                    color: Color(0x3F000000),
                    blurRadius: 4,
                    offset: Offset(2, 2),
                  ),
                  BoxShadow(
                    color: AppColors.white,
                    blurRadius: 6,
                    offset: Offset(-3, -3),
                  ),
                ],
        ),
        child: Text(
          severity,
          textAlign: TextAlign.center,
          style: AppTextStyles.body1.copyWith(
            fontSize: 13,
            fontWeight: isSelected ? FontWeight. w600 : FontWeight.w500,
            color: isSelected ?  AppColors.textDark : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Color(0x3F000000),
            blurRadius: 4,
            offset: Offset(2, 2),
          ),
          BoxShadow(
            color: AppColors. white,
            blurRadius: 6,
            offset: Offset(-3, -3),
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: label,
          hintStyle: AppTextStyles.body1. copyWith(
  color: Colors.grey. shade600,  // Much more readable!
  fontSize: 14,
),
        ),
        style: AppTextStyles.body1.copyWith(
          color: AppColors.textDark,
          fontSize: 14,
        ),
        validator: validator,
      ),
    );
  }
}