import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class FrequencyPage extends StatefulWidget {
  final VoidCallback onNext;
  final VoidCallback onBack;
  final Function(int)? onFrequencyChanged;
  final Function(DateTime)? onDateSelected;
  final Function(String)? onFrequencyTypeChanged;
  final Function(List<String>)? onScheduledTimesChanged;
  final Function(DateTime)? onEndDateSelected;

  const FrequencyPage({
    super.key,
    required this.onNext,
    required this.onBack,
    this.onFrequencyChanged,
    this.onDateSelected,
    this.onFrequencyTypeChanged,
    this.onScheduledTimesChanged,
    this.onEndDateSelected,
  });

  @override
  State<FrequencyPage> createState() => _FrequencyPageState();
}

class _FrequencyPageState extends State<FrequencyPage> {
  final TextEditingController _frequencyController = TextEditingController();
  DateTime? _selectedStartDate;
  DateTime? _selectedEndDate;
  String _frequencyType = 'daily';
  List<String> _scheduledTimes = [];

  @override
  void dispose() {
    _frequencyController.dispose();
    super.dispose();
  }

  bool get _canProceed {
    return _frequencyController.text.isNotEmpty &&
        _selectedStartDate != null &&
        _scheduledTimes.isNotEmpty;
  }

  void _showCalendar({required bool isStartDate}) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => AppointmentCalendarWidget(
        selectedDate: isStartDate
            ? (_selectedStartDate ?? DateTime.now())
            : (_selectedEndDate ?? DateTime.now()),
        onDateSelected: (date) {
          setState(() {
            if (isStartDate) {
              _selectedStartDate = date;
              widget.onDateSelected?.call(date);
            } else {
              _selectedEndDate = date;
              widget.onEndDateSelected?.call(date);
            }
          });
          Navigator.pop(context);
        },
      ),
    );
  }

  void _showTimePicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => MedicineTimeWidget(
        onTimeSelected: (time) {
          final timeString =
              '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
          if (!_scheduledTimes.contains(timeString)) {
            setState(() {
              _scheduledTimes.add(timeString);
              _scheduledTimes.sort();
            });
            widget.onScheduledTimesChanged?.call(_scheduledTimes);
          }
          Navigator.pop(context);
        },
      ),
    );
  }

  void _removeTime(String time) {
    setState(() {
      _scheduledTimes.remove(time);
    });
    widget.onScheduledTimesChanged?.call(_scheduledTimes);
  }

  @override
  Widget build(BuildContext context) {
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
              const Expanded(
                child: Text(
                  'Frequency & Schedule',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(width: 48),
            ],
          ),
        ),
        const SizedBox(height: 24),

        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Frequency Type Dropdown
                const Text(
                  'Frequency Type',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  value: _frequencyType,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                        color: Color(0xFFA67FF5),
                        width: 2,
                      ),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 16,
                    ),
                  ),
                  items: const [
                    DropdownMenuItem(value: 'daily', child: Text('Daily')),
                    DropdownMenuItem(value: 'weekly', child: Text('Weekly')),
                    DropdownMenuItem(value: 'monthly', child: Text('Monthly')),
                    DropdownMenuItem(
                      value: 'as-needed',
                      child: Text('As Needed'),
                    ),
                  ],
                  onChanged: (value) {
                    if (value != null) {
                      setState(() => _frequencyType = value);
                      widget.onFrequencyTypeChanged?.call(value);
                    }
                  },
                ),
                const SizedBox(height: 24),

                // Frequency Value Input
                const Text(
                  'Frequency Value',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _frequencyController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: _frequencyType == 'daily'
                        ? 'e.g., 3 (times per day)'
                        : _frequencyType == 'weekly'
                        ? 'e.g., 2 (times per week)'
                        : 'e.g., 1 (times per month)',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                        color: Color(0xFFA67FF5),
                        width: 2,
                      ),
                    ),
                    prefixIcon: const Icon(Icons.repeat),
                  ),
                  onChanged: (value) {
                    setState(() {}); // Rebuild to update button state
                    if (value.isNotEmpty) {
                      final freq = int.tryParse(value);
                      if (freq != null) {
                        widget.onFrequencyChanged?.call(freq);
                      }
                    }
                  },
                ),
                const SizedBox(height: 24),

                // Scheduled Times
                const Text(
                  'Scheduled Times',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),
                if (_scheduledTimes.isEmpty)
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey[300]!),
                    ),
                    child: const Text(
                      'No scheduled times added yet',
                      style: TextStyle(color: Colors.black54),
                    ),
                  )
                else
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _scheduledTimes.map((time) {
                      return Chip(
                        label: Text(time),
                        deleteIcon: const Icon(Icons.close, size: 18),
                        onDeleted: () => _removeTime(time),
                        backgroundColor: const Color(0xFFE8D5F5),
                        deleteIconColor: const Color(0xFFA67FF5),
                      );
                    }).toList(),
                  ),
                const SizedBox(height: 12),
                OutlinedButton.icon(
                  onPressed: _showTimePicker,
                  icon: const Icon(Icons.access_time),
                  label: const Text('Add Time'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFFA67FF5),
                    side: const BorderSide(color: Color(0xFFA67FF5)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Start Date Selector
                const Text(
                  'Start Date',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),
                InkWell(
                  onTap: () => _showCalendar(isStartDate: true),
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: _selectedStartDate != null
                          ? Border.all(color: const Color(0xFFA67FF5), width: 2)
                          : Border.all(color: Colors.grey[300]!),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.calendar_today,
                          color: _selectedStartDate != null
                              ? const Color(0xFFA67FF5)
                              : Colors.black87,
                        ),
                        const SizedBox(width: 16),
                        Text(
                          _selectedStartDate != null
                              ? DateFormat(
                                  'MMMM dd, yyyy',
                                ).format(_selectedStartDate!)
                              : 'Select Start Date',
                          style: TextStyle(
                            fontSize: 16,
                            color: _selectedStartDate != null
                                ? Colors.black87
                                : Colors.black54,
                            fontWeight: _selectedStartDate != null
                                ? FontWeight.w500
                                : FontWeight.normal,
                          ),
                        ),
                        const Spacer(),
                        const Icon(
                          Icons.arrow_forward_ios,
                          size: 16,
                          color: Colors.black54,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // End Date Selector
                const Text(
                  'End Date (Optional)',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),
                InkWell(
                  onTap: () => _showCalendar(isStartDate: false),
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: _selectedEndDate != null
                          ? Border.all(color: const Color(0xFFA67FF5), width: 2)
                          : Border.all(color: Colors.grey[300]!),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.calendar_today,
                          color: _selectedEndDate != null
                              ? const Color(0xFFA67FF5)
                              : Colors.black87,
                        ),
                        const SizedBox(width: 16),
                        Text(
                          _selectedEndDate != null
                              ? DateFormat(
                                  'MMMM dd, yyyy',
                                ).format(_selectedEndDate!)
                              : 'Select End Date',
                          style: TextStyle(
                            fontSize: 16,
                            color: _selectedEndDate != null
                                ? Colors.black87
                                : Colors.black54,
                            fontWeight: _selectedEndDate != null
                                ? FontWeight.w500
                                : FontWeight.normal,
                          ),
                        ),
                        const Spacer(),
                        const Icon(
                          Icons.arrow_forward_ios,
                          size: 16,
                          color: Colors.black54,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),

        // Next Button
        Padding(
          padding: const EdgeInsets.all(16),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _canProceed ? widget.onNext : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: _canProceed
                    ? const Color(0xFFA67FF5)
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
              child: const Text(
                'Next',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// Calendar Widget
class AppointmentCalendarWidget extends StatefulWidget {
  final DateTime selectedDate;
  final Function(DateTime) onDateSelected;

  const AppointmentCalendarWidget({
    super.key,
    required this.selectedDate,
    required this.onDateSelected,
  });

  @override
  State<AppointmentCalendarWidget> createState() =>
      _AppointmentCalendarWidgetState();
}

class _AppointmentCalendarWidgetState extends State<AppointmentCalendarWidget> {
  late DateTime currentMonth;
  DateTime? selectedDate;

  @override
  void initState() {
    super.initState();
    currentMonth = DateTime(
      widget.selectedDate.year,
      widget.selectedDate.month,
    );
    selectedDate = widget.selectedDate;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Select date',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(Icons.chevron_left),
                onPressed: () {
                  setState(() {
                    currentMonth = DateTime(
                      currentMonth.year,
                      currentMonth.month - 1,
                    );
                  });
                },
              ),
              Text(
                '${_getMonthName(currentMonth.month)} ${currentMonth.year}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.chevron_right),
                onPressed: () {
                  setState(() {
                    currentMonth = DateTime(
                      currentMonth.year,
                      currentMonth.month + 1,
                    );
                  });
                },
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: ['M', 'T', 'W', 'T', 'F', 'S', 'S']
                .map(
                  (day) => SizedBox(
                    width: 40,
                    child: Text(
                      day,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Colors.black54,
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: 8),
          ..._buildCalendarDays(),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                if (selectedDate != null) {
                  widget.onDateSelected(selectedDate!);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFA67FF5),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                elevation: 0,
              ),
              child: const Text(
                'Done',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildCalendarDays() {
    final firstDayOfMonth = DateTime(currentMonth.year, currentMonth.month, 1);
    final lastDayOfMonth = DateTime(
      currentMonth.year,
      currentMonth.month + 1,
      0,
    );
    final daysInMonth = lastDayOfMonth.day;
    final firstWeekday = firstDayOfMonth.weekday;

    List<Widget> rows = [];
    List<Widget> dayWidgets = [];

    for (int i = 1; i < firstWeekday; i++) {
      dayWidgets.add(const SizedBox(width: 40, height: 40));
    }

    for (int day = 1; day <= daysInMonth; day++) {
      final date = DateTime(currentMonth.year, currentMonth.month, day);
      final isSelected =
          selectedDate?.year == date.year &&
          selectedDate?.month == date.month &&
          selectedDate?.day == date.day;

      dayWidgets.add(
        GestureDetector(
          onTap: () => setState(() => selectedDate = date),
          child: Container(
            width: 40,
            height: 40,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: isSelected ? const Color(0xFFA67FF5) : Colors.transparent,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              day.toString(),
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.black,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ),
        ),
      );

      if (dayWidgets.length == 7) {
        rows.add(
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.from(dayWidgets),
            ),
          ),
        );
        dayWidgets.clear();
      }
    }

    if (dayWidgets.isNotEmpty) {
      while (dayWidgets.length < 7) {
        dayWidgets.add(const SizedBox(width: 40, height: 40));
      }
      rows.add(
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: dayWidgets,
          ),
        ),
      );
    }

    return rows;
  }

  String _getMonthName(int month) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return months[month - 1];
  }
}

// Time Picker Widget for Medicine
class MedicineTimeWidget extends StatefulWidget {
  final Function(TimeOfDay) onTimeSelected;

  const MedicineTimeWidget({super.key, required this.onTimeSelected});

  @override
  State<MedicineTimeWidget> createState() => _MedicineTimeWidgetState();
}

class _MedicineTimeWidgetState extends State<MedicineTimeWidget> {
  late FixedExtentScrollController _hourController;
  late FixedExtentScrollController _minuteController;

  int selectedHour = TimeOfDay.now().hour;
  int selectedMinute = 0;

  @override
  void initState() {
    super.initState();
    _hourController = FixedExtentScrollController(initialItem: selectedHour);
    _minuteController = FixedExtentScrollController(
      initialItem: selectedMinute,
    );
  }

  @override
  void dispose() {
    _hourController.dispose();
    _minuteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Select time',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          const SizedBox(height: 40),
          SizedBox(
            height: 200,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Hour picker
                SizedBox(
                  width: 80,
                  child: ListWheelScrollView.useDelegate(
                    controller: _hourController,
                    itemExtent: 50,
                    perspective: 0.005,
                    diameterRatio: 1.2,
                    physics: const FixedExtentScrollPhysics(),
                    onSelectedItemChanged: (index) {
                      setState(() => selectedHour = index);
                    },
                    childDelegate: ListWheelChildBuilderDelegate(
                      builder: (context, index) {
                        if (index < 0 || index > 23) return null;
                        final isSelected = index == selectedHour;
                        return Center(
                          child: Text(
                            index.toString().padLeft(2, '0'),
                            style: TextStyle(
                              fontSize: isSelected ? 32 : 20,
                              fontWeight: isSelected
                                  ? FontWeight.w600
                                  : FontWeight.normal,
                              color: isSelected ? Colors.black : Colors.black26,
                            ),
                          ),
                        );
                      },
                      childCount: 24,
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    ':',
                    style: TextStyle(fontSize: 32, fontWeight: FontWeight.w600),
                  ),
                ),
                // Minute picker
                SizedBox(
                  width: 80,
                  child: ListWheelScrollView.useDelegate(
                    controller: _minuteController,
                    itemExtent: 50,
                    perspective: 0.005,
                    diameterRatio: 1.2,
                    physics: const FixedExtentScrollPhysics(),
                    onSelectedItemChanged: (index) {
                      setState(() => selectedMinute = index);
                    },
                    childDelegate: ListWheelChildBuilderDelegate(
                      builder: (context, index) {
                        if (index < 0 || index > 59) return null;
                        final isSelected = index == selectedMinute;
                        return Center(
                          child: Text(
                            index.toString().padLeft(2, '0'),
                            style: TextStyle(
                              fontSize: isSelected ? 32 : 20,
                              fontWeight: isSelected
                                  ? FontWeight.w600
                                  : FontWeight.normal,
                              color: isSelected ? Colors.black : Colors.black26,
                            ),
                          ),
                        );
                      },
                      childCount: 60,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 40),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                widget.onTimeSelected(
                  TimeOfDay(hour: selectedHour, minute: selectedMinute),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFA67FF5),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                elevation: 0,
              ),
              child: const Text(
                'Done',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
