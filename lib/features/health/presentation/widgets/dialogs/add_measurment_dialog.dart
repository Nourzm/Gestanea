import 'package:flutter/material.dart';
import 'package:gestanea/core/constants/app_colors.dart';
import 'package:gestanea/core/constants/app_text_styles.dart';
import 'package:gestanea/core/widgets/custom_button.dart';
import 'package:gestanea/l10n/app_localizations.dart';
import '../../../../../core/database/models/measurement_model.dart';
import '../../../logic/bloc/measurements_bloc.dart';
import '../../../logic/bloc/measurements_event.dart';

class AddMeasurementDialog extends StatefulWidget {
  final MeasurementsBloc bloc;

  const AddMeasurementDialog({super.key, required this.bloc});

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
    final l10n = AppLocalizations.of(context)!;

    if (_formKey.currentState!.validate()) {
      final measurement = MeasurementModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        userId: 'current_user', // TODO: Get from session/auth
        weight: _weightController.text.isNotEmpty
            ? double.tryParse(_weightController.text)
            : null,
        heartRate: _heartRateController.text.isNotEmpty
            ? int.tryParse(_heartRateController.text)
            : null,
        systolic: _systolicController.text.isNotEmpty
            ? int.tryParse(_systolicController.text)
            : null,
        diastolic: _diastolicController.text.isNotEmpty
            ? int.tryParse(_diastolicController.text)
            : null,
        recordedAt: _selectedDate,
        createdAt: DateTime.now(),
      );

      // Use widget.bloc instead of context. read
      widget.bloc.add(AddMeasurement(measurement));

      Navigator.pop(context);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.measurementSavedSuccessfully),
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
      if (!mounted) return;
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
    final l10n = AppLocalizations.of(context)!;

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
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
                    color: Colors.grey.shade600.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 20),

                Text(
                  l10n.addMeasurement,
                  style: AppTextStyles.headline2.copyWith(
                    fontSize: 20,
                    color: AppColors.textDark,
                  ),
                ),
                const SizedBox(height: 24),

                _buildInputField(
                  l10n,
                  label: l10n.weightKg,
                  controller: _weightController,
                  icon: Icons.monitor_weight_outlined,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return l10n.pleaseEnterWeight;
                    }
                    final weight = double.tryParse(value);
                    if (weight == null) return l10n.pleaseEnterValidNumber;
                    if (weight < 30 || weight > 200) return l10n.weightRange;
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                _buildInputField(
                  l10n,
                  label: l10n.heartRateBpm,
                  controller: _heartRateController,
                  icon: Icons.favorite,
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return l10n.pleaseEnterHeartRate;
                    }
                    final hr = int.tryParse(value);
                    if (hr == null) return l10n.pleaseEnterValidNumber;
                    if (hr < 40 || hr > 200) return l10n.heartRateRange;
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                Text(
                  l10n.bloodPressure,
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
                        l10n,
                        label: l10n.systolic,
                        controller: _systolicController,
                        icon: Icons.arrow_upward,
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return l10n.required;
                          }
                          final sys = int.tryParse(value);
                          if (sys == null) return l10n.invalid;
                          if (sys < 70 || sys > 190) return l10n.systolicRange;
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildInputField(
                        l10n,
                        label: l10n.diastolic,
                        controller: _diastolicController,
                        icon: Icons.arrow_downward,
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return l10n.required;
                          }
                          final dia = int.tryParse(value);
                          if (dia == null) return l10n.invalid;
                          if (dia < 40 || dia > 130) return l10n.diastolicRange;
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
                        const Icon(
                          Icons.calendar_today,
                          color: AppColors.main500,
                          size: 20,
                        ),
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
                        text: l10n.cancel,
                        filled: false,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: AppButton(
                        onPressed: _handleSave,
                        text: l10n.save,
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

  Widget _buildInputField(
    AppLocalizations l10n, {
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
            color: AppColors.white,
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
                hintStyle: AppTextStyles.body1.copyWith(
                  color: Colors.grey.shade600,
                  fontSize: 14,
                ),
              ),
              style: AppTextStyles.body1.copyWith(
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
