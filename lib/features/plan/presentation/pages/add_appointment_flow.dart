import 'package:flutter/material.dart';
import 'package:gestanea/l10n/app_localizations.dart';
import 'add_appointment/appointment_name_page.dart';
import 'add_appointment/appointment_location_page.dart';
import 'add_appointment/appointment_date_time.dart';
import 'package:gestanea/core/database/models/appointment_model.dart';
import 'package:gestanea/features/plan/data/repositories/appointment_repository.dart';
import 'package:uuid/uuid.dart';

// Main Add Appointment Flow
class AddAppointmentFlow extends StatefulWidget {
  final String userId;

  const AddAppointmentFlow({super.key, required this.userId});

  @override
  State<AddAppointmentFlow> createState() => _AddAppointmentFlowState();
}

class _AddAppointmentFlowState extends State<AddAppointmentFlow> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  final _appointmentRepository = AppointmentRepository.getInstance();

  String appointmentName = '';
  String appointmentLocation = '';
  DateTime? appointmentDate;
  TimeOfDay? appointmentTime;

  void _nextPage() {
    if (_currentPage < 2) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _previousPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      Navigator.pop(context);
    }
  }

  Future<void> _saveAppointment() async {
    final t = AppLocalizations.of(context)!;
    if (appointmentName.isEmpty) {
      _showError(t.pleaseEnterAppointmentName);
      return;
    }

    if (appointmentDate == null) {
      _showError(t.pleaseSelectDate);
      return;
    }

    if (appointmentTime == null) {
      _showError(t.pleaseSelectTime);
      return;
    }

    try {
      final uuid = Uuid();
      final dateTime = DateTime(
        appointmentDate!.year,
        appointmentDate!.month,
        appointmentDate!.day,
        appointmentTime!.hour,
        appointmentTime!.minute,
      );

      final appointment = AppointmentModel(
        id: uuid.v4(),
        userId: widget.userId,
        babyId: null,
        title: appointmentName,
        doctorName: null,
        appointmentType: null,
        appointmentDate: dateTime,
        location: appointmentLocation.isNotEmpty ? appointmentLocation : null,
        notes: null,
        reminderTime: null,
        isCompleted: false,
        createdAt: DateTime.now(),
      );

      final result = await _appointmentRepository.insertAppointment(
        appointment,
      );

      if (result.state) {
        if (mounted) {
          Navigator.pop(context, true); // Return true to indicate success
        }
      } else {
        _showError(result.message);
      }
    } catch (e) {
      _showError('Failed to save appointment: $e');
    }
  }

  void _showError(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message), backgroundColor: Colors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F3F8),
      body: SafeArea(
        child: Column(
          children: [
            _buildProgressIndicator(),
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                onPageChanged: (index) {
                  setState(() => _currentPage = index);
                },
                children: [
                  AppointmentNamePage(
                    initialName: appointmentName,
                    onNameChanged: (name) =>
                        setState(() => appointmentName = name),
                    onNext: _nextPage,
                    onBack: _previousPage,
                  ),
                  AppointmentLocationPage(
                    initialLocation: appointmentLocation,
                    onLocationChanged: (location) =>
                        setState(() => appointmentLocation = location),
                    onNext: _nextPage,
                    onBack: _previousPage,
                  ),
                  AppointmentDateTimePage(
                    selectedDate: appointmentDate,
                    selectedTime: appointmentTime,
                    onDateSelected: (date) =>
                        setState(() => appointmentDate = date),
                    onTimeSelected: (time) =>
                        setState(() => appointmentTime = time),
                    onNext: () async {
                      await _saveAppointment();
                    },
                    onBack: _previousPage,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressIndicator() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Row(
        children: List.generate(3, (index) {
          return Expanded(
            child: Container(
              height: 4,
              margin: EdgeInsets.only(right: index < 2 ? 8 : 0),
              decoration: BoxDecoration(
                color: index <= _currentPage
                    ? const Color(0xFFA67FF5)
                    : const Color(0xFFD9D9D9),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          );
        }),
      ),
    );
  }
}
