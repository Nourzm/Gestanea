import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  DateTime _selectedDate = DateTime.now();

  @override
  void dispose() {
    _weightController.dispose();
    _heartRateController.dispose();
    _systolicController.dispose();
    _diastolicController.dispose();
    super.dispose();
  }

  void _handleSave() {
    if (_formKey.currentState! .validate()) {
      print('Weight: ${_weightController.text} kg');
      print('Heart Rate: ${_heartRateController. text} bpm');
      print('Blood Pressure: ${_systolicController.text}/${_diastolicController.text}');
      print('Date: $_selectedDate');
      
      Navigator.pop(context);
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Measurement saved successfully!'),
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
      lastDate: DateTime. now(),
    );
    
    if (date != null) {
      final time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(_selectedDate),
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
        bottom: MediaQuery.of(context). viewInsets.bottom,
      ),
      child: Container(
        decoration: const BoxDecoration(
          color: AppColors.main300,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.textSecondary. withOpacity(0.3),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 20),
                
                Text(
                  'Add Measurement',
                  style: AppTextStyles.headline2. copyWith(
                    fontSize: 20,
                    color: AppColors.textDark,
                  ),
                ),
                const SizedBox(height: 24),
                
                _buildInputField(
                  label: 'Weight (kg)',
                  controller: _weightController,
                  icon: Icons.monitor_weight_outlined,
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'Please enter weight';
                    final weight = double.tryParse(value);
                    if (weight == null) return 'Please enter a valid number';
                    if (weight < 30 || weight > 200) return 'Weight must be between 30-200 kg';
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                
                _buildInputField(
                  label: 'Heart Rate (bpm)',
                  controller: _heartRateController,
                  icon: Icons.favorite,
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'Please enter heart rate';
                    final hr = int.tryParse(value);
                    if (hr == null) return 'Please enter a valid number';
                    if (hr < 40 || hr > 200) return 'Heart rate must be between 40-200 bpm';
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                
                Text(
                  'Blood Pressure',
                  style: AppTextStyles.subtitle1.copyWith(
                    fontSize: 14,
                    color: AppColors.textDark,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: _buildInputField(
                        label: 'Systolic',
                        controller: _systolicController,
                        icon: Icons.arrow_upward,
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) return 'Required';
                          final sys = int.tryParse(value);
                          if (sys == null) return 'Invalid';
                          if (sys < 70 || sys > 190) return '70-190';
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildInputField(
                        label: 'Diastolic',
                        controller: _diastolicController,
                        icon: Icons.arrow_downward,
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) return 'Required';
                          final dia = int.tryParse(value);
                          if (dia == null) return 'Invalid';
                          if (dia < 40 || dia > 130) return '40-130';
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                
                GestureDetector(
                  onTap: _selectDateTime,
                  child: Container(
                    padding: const EdgeInsets.all(16),
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
                          '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year} ${_selectedDate.hour}:${_selectedDate.minute. toString().padLeft(2, '0')}',
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

  Widget _buildInputField({
    required String label,
    required TextEditingController controller,
    required IconData icon,
    required TextInputType keyboardType,
    String? Function(String?)? validator,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
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
      child: Row(
        children: [
          Icon(icon, color: AppColors.main500, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: TextFormField(
              controller: controller,
              keyboardType: keyboardType,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: label,
                hintStyle: AppTextStyles.body1. copyWith(
  color: Colors.grey. shade600,  // Much more readable!
  fontSize: 14,
),
              ),
              style: AppTextStyles.body1. copyWith(
                color: AppColors.textDark,
                fontSize: 14,
              ),
              validator: validator,
            ),
          ),
        ],
      ),
    );
  }
}