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
  int _sleepQuality = 3;
  DateTime _selectedDate = DateTime.now();

  final List<Map<String, String>> _moods = [
    {'emoji': '😊', 'name': 'Very Happy'},
    {'emoji': '🙂', 'name': 'Happy'},
    {'emoji': '😐', 'name': 'Neutral'},
    {'emoji': '😔', 'name': 'Sad'},
    {'emoji': '😢', 'name': 'Very Sad'},
  ];

  @override
  void dispose() {
    _notesController.dispose();
    super. dispose();
  }

  void _handleSave() {
    if (_selectedMood == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select your mood')),
      );
      return;
    }

    print('Mood: $_selectedMood');
    print('Energy Level: $_energyLevel');
    print('Sleep Quality: $_sleepQuality');
    print('Notes: ${_notesController.text}');
    print('Date: $_selectedDate');
    
    Navigator.pop(context);
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Mood logged successfully! '),
        backgroundColor: Colors.green,
      ),
    );
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
                      color: AppColors.textSecondary. withOpacity(0.3),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                
                Center(
                  child: Text(
                    'How are you feeling? ',
                    style: AppTextStyles.headline2.copyWith(
                      fontSize: 20,
                      color: AppColors.textDark,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: _moods.map((mood) {
                    final isSelected = _selectedMood == mood['name'];
                    return GestureDetector(
                      onTap: () => setState(() => _selectedMood = mood['name']),
                      child: Container(
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(
                          color: isSelected ? AppColors.main300 : Colors.white,
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
                  'Energy Level',
                  style: AppTextStyles.subtitle1.copyWith(
                    fontSize: 14,
                    color: AppColors.textDark,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Low',
                            style: AppTextStyles.body1.copyWith(
                              fontSize: 12,
                              color: AppColors. textSecondary,
                            ),
                          ),
                          Text(
                            _energyLevel.toInt().toString(),
                            style: AppTextStyles.subtitle1.copyWith(
                              fontSize: 18,
                              color: AppColors.main500,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'High',
                            style: AppTextStyles.body1.copyWith(
                              fontSize: 12,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                      SliderTheme(
                        data: SliderThemeData(
                          activeTrackColor: AppColors.main500,
                          inactiveTrackColor: AppColors.main300,
                          thumbColor: AppColors.main600,
                          overlayColor: AppColors.main500. withOpacity(0.2),
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
                  'Sleep Quality',
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
                          index < _sleepQuality ? Icons.star : Icons.star_border,
                          color: AppColors.main500,
                          size: 32,
                        ),
                      );
                    }),
                  ),
                ),
                const SizedBox(height: 20),
                
                Text(
                  'Notes (optional)',
                  style: AppTextStyles.subtitle1.copyWith(
                    fontSize: 14,
                    color: AppColors. textDark,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
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
                      hintText: 'How was your day?',
                      hintStyle: AppTextStyles.body1.copyWith(
                        color: AppColors.textSecondary,
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
}