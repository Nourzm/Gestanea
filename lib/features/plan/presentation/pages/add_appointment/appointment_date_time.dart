import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:gestanea/l10n/app_localizations.dart';

class AppointmentDateTimePage extends StatefulWidget {
  final DateTime? selectedDate;
  final TimeOfDay? selectedTime;
  final Function(DateTime) onDateSelected;
  final Function(TimeOfDay) onTimeSelected;
  final VoidCallback onNext;
  final VoidCallback onBack;

  const AppointmentDateTimePage({
    super.key,
    this.selectedDate,
    this.selectedTime,
    required this.onDateSelected,
    required this.onTimeSelected,
    required this.onNext,
    required this.onBack,
  });

  @override
  State<AppointmentDateTimePage> createState() =>
      AppointmentDateTimePageState();
}

class AppointmentDateTimePageState extends State<AppointmentDateTimePage> {
  @override
  void initState() {
    super.initState();
  }

  bool get _canProceed {
    return widget.selectedDate != null && widget.selectedTime != null;
  }

  void _showCalendar() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => AppointmentCalendarWidget(
        selectedDate: widget.selectedDate ?? DateTime.now(),
        onDateSelected: (date) {
          widget.onDateSelected(date);
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
      builder: (context) => AppointmentTimeWidget(
        selectedTime: widget.selectedTime,
        onTimeSelected: (time) {
          widget.onTimeSelected(time);
          Navigator.pop(context);
        },
      ),
    );
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
              Expanded(
                child: Text(
                  AppLocalizations.of(context)!.appointmentDateTime,
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
        const SizedBox(height: 48),

        // Date Selector
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: InkWell(
            onTap: _showCalendar,
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: widget.selectedDate != null
                    ? Border.all(color: const Color(0xFFA67FF5), width: 2)
                    : null,
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.calendar_today,
                    color: widget.selectedDate != null
                        ? const Color(0xFFA67FF5)
                        : Colors.black87,
                  ),
                  const SizedBox(width: 16),
                  Text(
                    widget.selectedDate != null
                        ? DateFormat(
                            'MMMM dd, yyyy',
                          ).format(widget.selectedDate!)
                        : AppLocalizations.of(context)!.selectDate,
                    style: TextStyle(
                      fontSize: 16,
                      color: widget.selectedDate != null
                          ? Colors.black87
                          : Colors.black54,
                      fontWeight: widget.selectedDate != null
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
        ),

        const SizedBox(height: 16),

        // Time Selector
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: InkWell(
            onTap: _showTimePicker,
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: widget.selectedTime != null
                    ? Border.all(color: const Color(0xFFA67FF5), width: 2)
                    : null,
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.access_time,
                    color: widget.selectedTime != null
                        ? const Color(0xFFA67FF5)
                        : Colors.black87,
                  ),
                  const SizedBox(width: 16),
                  Text(
                    widget.selectedTime != null
                        ? '${widget.selectedTime!.hour.toString().padLeft(2, '0')}:${widget.selectedTime!.minute.toString().padLeft(2, '0')}'
                        : AppLocalizations.of(context)!.selectTime,
                    style: TextStyle(
                      fontSize: 16,
                      color: widget.selectedTime != null
                          ? Colors.black87
                          : Colors.black54,
                      fontWeight: widget.selectedTime != null
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
        ),

        const Spacer(),

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
              Text(
                AppLocalizations.of(context)!.selectDate,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
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
              child: Text(
                AppLocalizations.of(context)!.doneLabel,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
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

// Time Picker Widget
class AppointmentTimeWidget extends StatefulWidget {
  final TimeOfDay? selectedTime;
  final Function(TimeOfDay) onTimeSelected;

  const AppointmentTimeWidget({
    super.key,
    required this.selectedTime,
    required this.onTimeSelected,
  });

  @override
  State<AppointmentTimeWidget> createState() => _AppointmentTimeWidgetState();
}

class _AppointmentTimeWidgetState extends State<AppointmentTimeWidget> {
  late FixedExtentScrollController _hourController;
  late FixedExtentScrollController _minuteController;

  int selectedHour = 1;
  int selectedMinute = 0;

  @override
  void initState() {
    super.initState();
    if (widget.selectedTime != null) {
      selectedHour = widget.selectedTime!.hour;
      selectedMinute = widget.selectedTime!.minute;
    }
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
              Text(
                AppLocalizations.of(context)!.selectTime,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
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
              child: Text(
                AppLocalizations.of(context)!.doneLabel,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
