import 'package:flutter/material.dart';
import 'add_appointment/appointment_name_page.dart';
import 'add_appointment/appointment_location_page.dart';
import 'add_appointment/appointment_date_time.dart';

// Main Add Appointment Flow
class AddAppointmentFlow extends StatefulWidget {
  const AddAppointmentFlow({super.key});

  @override
  State<AddAppointmentFlow> createState() => _AddAppointmentFlowState();
}

class _AddAppointmentFlowState extends State<AddAppointmentFlow> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

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
                    onNext: () {
                      // Save appointment and close
                      Navigator.pop(context);
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
