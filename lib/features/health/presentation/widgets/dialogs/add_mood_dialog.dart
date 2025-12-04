import 'package:flutter/material.dart';
import 'package:gestanea/core/constants/app_colors.dart';
import 'package:gestanea/core/constants/app_text_styles.dart';
import 'package:gestanea/core/widgets/custom_button.dart';

class AddMoodDialog extends StatefulWidget {
  const AddMoodDialog({super.key});

  @override
  State<AddMoodDialog> createState() => _AddMoodDialogState();
}

class _AddMoodDialogState extends State<AddMoodDialog> {
  final _formKey = GlobalKey<FormState>();
  final _notesController = TextEditingController();
  String? _selectedMood;
  double _energyLevel = 3;
  String _sleepQuality = 'Good';
  DateTime _selectedDateTime = DateTime.now();

  final List<Map<String, String>> _moods = [
    {'emoji': '😊', 'label': 'Great', 'color': '0xFFFFF9C4'},
    {'emoji': '😌', 'label': 'Good', 'color': '0xFFE1F5FE'},
    {'emoji': '😐', 'label': 'Okay', 'color': '0xFFE8EAF6'},
    {'emoji': '😔', 'label': 'Low', 'color': '0xFFFFE0B2'},
    {'emoji': '😢', 'label': 'Sad', 'color': '0xFFFFC4C4'},
  ];

  final List<String> _sleepQualities = ['Poor', 'Fair', 'Good', 'Excellent'];

  @override
  void dispose() {
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

  void _saveMood() {
    if (_formKey.currentState!.validate()) {
      // TODO: Save mood data
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

  Widget _buildMoodSelector() {
    return _buildNeumorphicContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'How are you feeling?',
            style: AppTextStyles.smallLabel.copyWith(
              fontSize: 12,
              color: AppColors.textDark,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: _moods.map((mood) {
              final isSelected = _selectedMood == mood['label'];
              final moodColor = Color(int.parse(mood['color']!));

              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedMood = mood['label'];
                  });
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                  decoration: BoxDecoration(
                    color: isSelected ? moodColor : Colors.transparent,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isSelected ? AppColors.main500 : Colors.transparent,
                      width: 2,
                    ),
                  ),
                  child: Column(
                    children: [
                      Text(
                        mood['emoji']!,
                        style: TextStyle(
                          fontSize: isSelected ? 36 : 32,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        mood['label']!,
                        style: AppTextStyles.smallLabel.copyWith(
                          fontSize: 11,
                          color: AppColors.textDark,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildEnergyLevelSlider() {
    return _buildNeumorphicContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Energy Level',
            style: AppTextStyles.smallLabel.copyWith(
              fontSize: 12,
              color: AppColors.textDark,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.battery_0_bar, color: AppColors.textSecondary, size: 20),
              Expanded(
                child: SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    activeTrackColor: AppColors.main500,
                    inactiveTrackColor: AppColors.main300,
                    thumbColor: AppColors.main600,
                    overlayColor: AppColors.main500.withOpacity(0.2),
                  ),
                  child: Slider(
                    value: _energyLevel,
                    min: 1,
                    max: 5,
                    divisions: 4,
                    label: _energyLevel.toInt().toString(),
                    onChanged: (value) {
                      setState(() {
                        _energyLevel = value;
                      });
                    },
                  ),
                ),
              ),
              const Icon(Icons.battery_full, color: AppColors.main500, size: 20),
            ],
          ),
          Center(
            child: Text(
              'Level: ${_energyLevel.toInt()}/5',
              style: AppTextStyles.body1.copyWith(
                color: AppColors.textDark,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSleepQualitySelector() {
    return _buildNeumorphicContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Sleep Quality',
            style: AppTextStyles.smallLabel.copyWith(
              fontSize: 12,
              color: AppColors.textDark,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: _sleepQualities.map((quality) {
              final isSelected = _sleepQuality == quality;

              return Expanded(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _sleepQuality = quality;
                    });
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      color: isSelected ? AppColors.main300 : Colors.transparent,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isSelected ? AppColors.main500 : AppColors.textSecondary,
                        width: isSelected ? 2 : 1,
                      ),
                    ),
                    child: Text(
                      quality,
                      textAlign: TextAlign.center,
                      style: AppTextStyles.smallLabel.copyWith(
                        fontSize: 11,
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
                'Log Your Mood',
                style: AppTextStyles.headline2.copyWith(
                  fontSize: 22,
                  color: AppColors.textDark,
                ),
              ),
              const SizedBox(height: 20),

              // Mood Selector
              _buildMoodSelector(),
              const SizedBox(height: 12),

              // Energy Level Slider
              _buildEnergyLevelSlider(),
              const SizedBox(height: 12),

              // Sleep Quality Selector
              _buildSleepQualitySelector(),
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
                        hintText: 'How was your day?',
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
                      onPressed: _saveMood,
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

void showAddMoodDialog(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => const AddMoodDialog(),
  );
}
