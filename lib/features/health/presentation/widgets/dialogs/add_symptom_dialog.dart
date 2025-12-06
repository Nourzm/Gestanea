import 'package:flutter/material.dart';
import 'package:gestanea/core/constants/app_colors.dart';
import 'package:gestanea/core/constants/app_text_styles.dart';
import 'package:gestanea/core/widgets/custom_button.dart';
import 'package:gestanea/l10n/app_localizations.dart';
import '../../../../../core/database/models/symptom_model.dart';
import '../../../logic/bloc/symptoms_bloc.dart';
import '../../../logic/bloc/symptoms_event.dart';

class AddSymptomDialog extends StatefulWidget {
  final SymptomsBloc bloc;
  
  const AddSymptomDialog({super.key, required this.bloc});

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

  @override
  void dispose() {
    _durationController. dispose();
    _notesController.dispose();
    _otherSymptomController.dispose();
    super.dispose();
  }

  List<String> _getSymptoms(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return [
      l10n.nausea,
      l10n. headache,
      l10n. backPain,
      l10n. swelling,
      l10n. fatigue,
      l10n. dizziness,
      l10n.heartburn,
      l10n. legCramps,
      l10n.other,
    ];
  }

  void _handleSave() {
    final l10n = AppLocalizations.of(context)!;
    
    if (_formKey.currentState!.validate()) {
      if (_selectedSymptom == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.pleaseSelectSymptom)),
        );
        return;
      }
      if (_selectedSeverity == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.pleaseSelectSeverity)),
        );
        return;
      }

      final symptomName = _selectedSymptom == l10n.other 
          ? _otherSymptomController.text 
          : _selectedSymptom!;
      
      final symptom = SymptomModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        userId: 'current_user', // TODO: Get from session/auth
        symptomName: symptomName,
        severity: _selectedSeverity,
        notes: _notesController.text. isNotEmpty ? _notesController. text : null,
        recordedAt: _selectedDate,
        createdAt: DateTime.now(),
      );
      
      // Use widget.bloc to add symptom
      widget.bloc. add(AddSymptom(symptom));
      
      Navigator.pop(context);
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.symptomLoggedSuccessfully),
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
    final l10n = AppLocalizations. of(context)!;
    final symptoms = _getSymptoms(context);

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey. shade600. withOpacity(0.3),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                
                Center(
                  child: Text(
                    l10n.addSymptom,
                    style: AppTextStyles.headline2. copyWith(
                      fontSize: 20,
                      color: AppColors.textDark,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                
                Text(
                  l10n. symptomType,
                  style: AppTextStyles.subtitle1.copyWith(
                    fontSize: 14,
                    color: AppColors.textDark,
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
                        l10n.selectSymptom,
                        style: AppTextStyles. body1.copyWith(
                          color: Colors.grey.shade600,
                        ),
                      ),
                      value: _selectedSymptom,
                      items: symptoms.map((symptom) {
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
                
                if (_selectedSymptom == l10n.other) ...[
                  const SizedBox(height: 12),
                  _buildTextField(
                    controller: _otherSymptomController,
                    label: l10n.specifySymptom,
                    validator: (value) {
                      if (_selectedSymptom == l10n.other && (value == null || value.isEmpty)) {
                        return l10n.pleaseSpecifySymptom;
                      }
                      return null;
                    },
                  ),
                ],
                
                const SizedBox(height: 20),
                
                Text(
                  l10n. severity,
                  style: AppTextStyles.subtitle1.copyWith(
                    fontSize: 14,
                    color: AppColors. textDark,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _buildSeverityButton(l10n.mild, const Color(0xFFB8E6B8)),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _buildSeverityButton(l10n. moderate, const Color(0xFFFFE4B5)),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _buildSeverityButton(l10n. severe, const Color(0xFFFFB8B8)),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                
                _buildTextField(
                  controller: _durationController,
                  label: l10n.duration,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return l10n.pleaseEnterDuration;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                
                _buildTextField(
                  controller: _notesController,
                  label: l10n.notes,
                  maxLines: 3,
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
                          style: AppTextStyles.body1. copyWith(
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
            color: isSelected ? AppColors.textDark : Colors.grey.shade600,
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
          hintStyle: AppTextStyles.body1.copyWith(
            color: Colors.grey.shade600,
            fontSize: 14,
          ),
        ),
        style: AppTextStyles.body1. copyWith(
          color: AppColors.textDark,
          fontSize: 14,
        ),
        validator: validator,
      ),
    );
  }
}