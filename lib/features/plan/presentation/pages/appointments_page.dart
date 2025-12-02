import 'package:flutter/material.dart';
import 'package:gestanea/core/constants/app_colors.dart';
import 'package:gestanea/core/widgets/Sub_Header.dart';
import 'package:gestanea/l10n/app_localizations.dart';

class AppointmentsPage extends StatefulWidget {
  const AppointmentsPage({super.key});

  @override
  State<AppointmentsPage> createState() => _AppointmentsPageState();
}

class _AppointmentsPageState extends State<AppointmentsPage> {
  bool _showBadge = true;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.offset > 50 && _showBadge) {
      setState(() {
        _showBadge = false;
      });
    } else if (_scrollController.offset <= 50 && !_showBadge) {
      setState(() {
        _showBadge = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppColors.bg_1,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SubHeader(
              title: localizations.appointments,
              showBackButton: true,
              onBackPressed: () => Navigator.of(context).pop(),
            ),
            Expanded(
              child: SingleChildScrollView(
                controller: _scrollController,
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: screenHeight * 0.025),

                    // Appointment Cards
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: screenWidth * 0.05,
                      ),
                      child: Column(
                        children: [
                          _buildAppointmentCard(
                            'Follow-up Visit',
                            'Dr. Sarah Johnson',
                            'Tomorrow',
                            '10:00 AM',
                            Icons.favorite_border,
                            screenWidth,
                            screenHeight,
                          ),
                          SizedBox(height: screenHeight * 0.015),
                          _buildAppointmentCard(
                            'Radiology Appointment',
                            'Radiology Dept',
                            'Feb 5, 2025',
                            '2:30 PM',
                            Icons.access_time,
                            screenWidth,
                            screenHeight,
                          ),
                          SizedBox(height: screenHeight * 0.015),
                          _buildAppointmentCard(
                            'Blood Test',
                            'Lab Services',
                            'Feb 10, 2025',
                            '9:00 AM',
                            Icons.science_outlined,
                            screenWidth,
                            screenHeight,
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: screenHeight * 0.1),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppointmentCard(
    String title,
    String subtitle,
    String date,
    String time,
    IconData icon,
    double screenWidth,
    double screenHeight,
  ) {
    // Parse date and time to DateTime (simple demo, real parsing may need localization)
    DateTime? appointmentDateTime;
    if (date == 'Tomorrow') {
      appointmentDateTime = DateTime.now().add(Duration(days: 1));
    } else {
      try {
        appointmentDateTime = DateTime.parse(date);
      } catch (_) {
        appointmentDateTime = DateTime.now();
      }
    }
    // Add time if possible
    if (appointmentDateTime != null && time.contains(':')) {
      final timeParts = time.split(' ');
      final hourMinute = timeParts[0].split(':');
      int hour = int.tryParse(hourMinute[0]) ?? 0;
      int minute = int.tryParse(hourMinute[1]) ?? 0;
      if (timeParts.length > 1 &&
          timeParts[1].toLowerCase() == 'pm' &&
          hour < 12) {
        hour += 12;
      }
      appointmentDateTime = DateTime(
        appointmentDateTime.year,
        appointmentDateTime.month,
        appointmentDateTime.day,
        hour,
        minute,
      );
    }
    final now = DateTime.now();
    final remaining = appointmentDateTime.difference(now);
    final totalSeconds = remaining.inSeconds > 0 ? remaining.inSeconds : 0;
    final maxSeconds = 86400; // 1 day for demo
    final progress = (totalSeconds / maxSeconds).clamp(0.0, 1.0);

    return Stack(
      children: [
        Container(
          padding: EdgeInsets.all(screenWidth * 0.04),
          decoration: BoxDecoration(
            color: AppColors.bg_1,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Color(0x3F000000),
                blurRadius: 4,
                offset: Offset(4, 4),
                spreadRadius: 0,
              ),
              BoxShadow(
                color: Color(0xFFFFFFFF),
                blurRadius: 10,
                offset: Offset(-6, -6),
                spreadRadius: 0,
              ),
            ],
          ),
          child: Column(
            children: [
              Row(
                children: [
                  // Icon Circle
                  Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [AppColors.main500, AppColors.main600],
                      ),
                    ),
                    child: Icon(icon, color: Colors.white, size: 24),
                  ),
                  SizedBox(width: screenWidth * 0.04),
                  // Appointment Info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: TextStyle(
                            fontSize: screenWidth * 0.042,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          subtitle,
                          style: TextStyle(
                            fontSize: screenWidth * 0.035,
                            color: Colors.grey.shade600,
                          ),
                        ),
                        SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(
                              Icons.calendar_today,
                              size: 14,
                              color: Colors.grey.shade500,
                            ),
                            SizedBox(width: 4),
                            Text(
                              date,
                              style: TextStyle(
                                fontSize: screenWidth * 0.032,
                                color: Colors.grey.shade600,
                              ),
                            ),
                            SizedBox(width: 12),
                            Icon(
                              Icons.access_time,
                              size: 14,
                              color: Colors.grey.shade500,
                            ),
                            SizedBox(width: 4),
                            Text(
                              time,
                              style: TextStyle(
                                fontSize: screenWidth * 0.032,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12),
           
            ],
          ),
        ),
        // Animated badge for remaining time at top right
        Positioned(
          top: 0,
          right: 0,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            height: totalSeconds > 0 ? null : 0,
            curve: Curves.easeInOut,
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 300),
              opacity: totalSeconds > 0 ? 1.0 : 0.0,
              child: Padding(
                padding: EdgeInsets.only(right: screenWidth * 0.05, top: 8),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.main600,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.access_time, color: Colors.white, size: 14),
                      SizedBox(width: 4),
                      Text(
                        totalSeconds > 0
                            ? _formatDuration(Duration(seconds: totalSeconds))
                            : 'Now',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  String _formatDuration(Duration duration) {
    if (duration.inDays > 0) {
      return '${duration.inDays}d ${duration.inHours % 24}h';
    } else if (duration.inHours > 0) {
      return '${duration.inHours}h ${duration.inMinutes % 60}m';
    } else if (duration.inMinutes > 0) {
      return '${duration.inMinutes}m';
    } else {
      return '${duration.inSeconds}s';
    }
  }
}
