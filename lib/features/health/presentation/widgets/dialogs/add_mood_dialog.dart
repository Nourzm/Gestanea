import 'package:flutter/material.dart';
import 'package:gestanea/core/constants/app_colors.dart';
import 'package:gestanea/core/constants/app_text_styles.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gestanea/core/theme/theme_cubit.dart';
import 'package:gestanea/core/widgets/custom_button.dart';
import 'package:gestanea/l10n/app_localizations.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../../core/database/models/mood_model.dart';
import '../../../logic/bloc/moods_bloc.dart';
import '../../../logic/bloc/moods_event.dart';

class AddMoodDialog extends StatefulWidget {
  final MoodsBloc bloc;
  final String? initialMood;

  const AddMoodDialog({super.key, required this.bloc, this.initialMood});

  @override
  State<AddMoodDialog> createState() => _AddMoodDialogState();
}

class _AddMoodDialogState extends State<AddMoodDialog> {
  final _formKey = GlobalKey<FormState>();
  final _notesController = TextEditingController();

  String? _selectedMood;
  double _energyLevel = 3;
  int _sleepQuality = 3;
  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    _selectedMood = widget.initialMood;
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  List<Map<String, String>> _getMoods(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return [
      {'emoji': '😊', 'name': l10n.veryHappy},
      {'emoji': '🙂', 'name': l10n.happy},
      {'emoji': '😐', 'name': l10n.neutral},
      {'emoji': '😔', 'name': l10n.sad},
      {'emoji': '😢', 'name': l10n.verySad},
    ];
  }

  void _handleSave() {
    final l10n = AppLocalizations.of(context)!;

    if (_selectedMood == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.pleaseSelectMood)));
      return;
    }

    final userId = Supabase.instance.client.auth.currentUser?.id;
    if (userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.pleaseLogInToSaveMood),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final mood = MoodModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      userId: userId,
      mood: _selectedMood!,
      intensity: _energyLevel.toInt(),
      notes: _notesController.text.isNotEmpty ? _notesController.text : null,
      recordedAt: _selectedDate,
      createdAt: DateTime.now(),
    );

    // Use widget.bloc to add mood
    widget.bloc.add(AddMood(mood));

    Navigator.pop(context);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(l10n.moodLoggedSuccessfully),
        backgroundColor: Colors.green,
      ),
    );
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
    final themeData = context.watch<ThemeCubit>().currentTheme;
    final moods = _getMoods(context);

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
                      color: Colors.grey.shade600.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                Center(
                  child: Text(
                    l10n.howAreYouFeeling,
                    style: AppTextStyles.headline2.copyWith(
                      fontSize: 20,
                      color: AppColors.textDark,
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: moods.map((mood) {
                    final isSelected = _selectedMood == mood['name'];
                    return GestureDetector(
                      onTap: () => setState(() => _selectedMood = mood['name']),
                      child: Container(
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(
                          color: isSelected
                              ? themeData.cardColor
                              : Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: isSelected
                              ? [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.15),
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
                        child: Center(
                          child: Text(
                            mood['emoji']!,
                            style: const TextStyle(fontSize: 32),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 24),

                Text(
                  l10n.energyLevel,
                  style: AppTextStyles.subtitle1.copyWith(
                    fontSize: 14,
                    color: AppColors.textDark,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
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
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            l10n.low,
                            style: AppTextStyles.body1.copyWith(
                              fontSize: 12,
                              color: Colors.grey.shade600,
                            ),
                          ),
                          Text(
                            _energyLevel.toInt().toString(),
                            style: AppTextStyles.subtitle1.copyWith(
                              fontSize: 18,
                              color: themeData.primaryColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            l10n.high,
                            style: AppTextStyles.body1.copyWith(
                              fontSize: 12,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                      SliderTheme(
                        data: SliderThemeData(
                          activeTrackColor: themeData.primaryColor,
                          inactiveTrackColor: themeData.cardColor,
                          thumbColor: themeData.secondaryColor,
                          overlayColor: themeData.primaryColor.withOpacity(0.2),
                        ),
                        child: Slider(
                          value: _energyLevel,
                          min: 1,
                          max: 5,
                          divisions: 4,
                          onChanged: (value) {
                            setState(() => _energyLevel = value);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                Text(
                  l10n.sleepQuality,
                  style: AppTextStyles.subtitle1.copyWith(
                    fontSize: 14,
                    color: AppColors.textDark,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
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
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: List.generate(5, (index) {
                      return GestureDetector(
                        onTap: () => setState(() => _sleepQuality = index + 1),
                        child: Icon(
                          index < _sleepQuality
                              ? Icons.star
                              : Icons.star_border,
                          color: themeData.primaryColor,
                          size: 32,
                        ),
                      );
                    }),
                  ),
                ),
                const SizedBox(height: 20),

                Text(
                  l10n.notes,
                  style: AppTextStyles.subtitle1.copyWith(
                    fontSize: 14,
                    color: AppColors.textDark,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
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
                  child: TextField(
                    controller: _notesController,
                    maxLines: 3,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: l10n.howWasYourDay,
                      hintStyle: AppTextStyles.body1.copyWith(
                        color: Colors.grey.shade600,
                        fontSize: 14,
                      ),
                    ),
                    style: AppTextStyles.body1.copyWith(
                      color: AppColors.textDark,
                      fontSize: 14,
                    ),
                  ),
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
                        Icon(
                          Icons.calendar_today,
                          color: themeData.primaryColor,
                          size: 20,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year} ${_selectedDate.hour}:${_selectedDate.minute.toString().padLeft(2, '0')}',
                          style: AppTextStyles.body1.copyWith(
                            color: themeData.primaryColor,
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
}
