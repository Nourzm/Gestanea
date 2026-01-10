import 'package:flutter/material.dart';
import 'package:gestanea/l10n/app_localizations.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gestanea/core/theme/theme_cubit.dart';

class FormDosePage extends StatefulWidget {
  final String? selectedForm;
  final double selectedDose;
  final Function(String) onFormSelected;
  final Function(double) onDoseChanged;
  final VoidCallback onNext;
  final VoidCallback onBack;

  const FormDosePage({
    super.key,
    required this.selectedForm,
    required this.selectedDose,
    required this.onFormSelected,
    required this.onDoseChanged,
    required this.onNext,
    required this.onBack,
  });

  @override
  State<FormDosePage> createState() => _FormDosePageState();
}

class _FormDosePageState extends State<FormDosePage> {
  final TextEditingController _dosageController = TextEditingController();

  @override
  void dispose() {
    _dosageController.dispose();
    super.dispose();
  }

  bool get _canProceed {
    return widget.selectedForm != null &&
        widget.selectedForm!.isNotEmpty &&
        _dosageController.text.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final themeData = context.watch<ThemeCubit>().currentTheme;
    final forms = [
      {'name': localizations.formPill, 'icon': '💊'},
      {'name': localizations.formInjection, 'icon': '💉'},
      {'name': localizations.formSpray, 'icon': '🧴'},
      {'name': localizations.formDrop, 'icon': '💧'},
      {'name': localizations.formSyrup, 'icon': '🧪'},
      {'name': localizations.formOthers, 'icon': '•••'},
    ];

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back_ios, size: 20),
                onPressed: widget.onBack,
              ),
              Expanded(
                child: Text(
                  AppLocalizations.of(context)!.selectFormDose,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(width: 48),
            ],
          ),
        ),
        const SizedBox(height: 32),

        // Dosage Input Field
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: TextField(
            controller: _dosageController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: InputDecoration(
              labelText: AppLocalizations.of(context)!.dosage,
              hintText: AppLocalizations.of(context)!.dosageExample,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: themeData.primaryColor, width: 2),
              ),
              prefixIcon: const Icon(Icons.medical_services),
            ),
            onChanged: (value) {
              final dose = double.tryParse(value);
              if (dose != null) {
                widget.onDoseChanged(dose);
              }
              setState(() {}); // Rebuild to update button color
            },
          ),
        ),
        const SizedBox(height: 24),

        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: 0.9,
            ),
            itemCount: forms.length,
            itemBuilder: (context, index) {
              final form = forms[index];
              final isSelected = widget.selectedForm == form['name'];
              return GestureDetector(
                onTap: () {
                  widget.onFormSelected(form['name'] as String);
                  setState(() {}); // Rebuild to update button color
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: isSelected
                        ? Border.all(color: themeData.primaryColor, width: 2)
                        : null,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        form['icon'] as String,
                        style: const TextStyle(fontSize: 32),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        form['name'] as String,
                        style: const TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _canProceed ? widget.onNext : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: _canProceed
                    ? themeData.primaryColor
                    : const Color(0xFFE0E0E0),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                elevation: 0,
                disabledBackgroundColor: const Color(0xFFE0E0E0),
                disabledForegroundColor: Colors.white,
              ),
              child: Text(
                AppLocalizations.of(context)!.nextLabel,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
