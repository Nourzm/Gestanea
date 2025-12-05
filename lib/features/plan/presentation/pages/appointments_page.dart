import 'package:flutter/material.dart';
import 'package:gestanea/core/constants/app_colors.dart';
import 'package:gestanea/core/widgets/Sub_Header.dart';
import 'package:gestanea/l10n/app_localizations.dart';
import 'package:gestanea/core/database/models/appointment_model.dart';
import 'package:gestanea/features/plan/data/repositories/plan_local_data_source.dart';
import 'package:gestanea/features/plan/data/repositories/plan_database_initializer.dart';
import 'package:gestanea/features/plan/data/mock_data/plan_mock_data.dart';

class AppointmentsPage extends StatefulWidget {
  const AppointmentsPage({super.key});

  @override
  State<AppointmentsPage> createState() => _AppointmentsPageState();
}

class _AppointmentsPageState extends State<AppointmentsPage> {
  bool _showBadge = true;
  final ScrollController _scrollController = ScrollController();
  final PlanLocalDataSource _dataSource = PlanLocalDataSource();
  final PlanDatabaseInitializer _dbInitializer = PlanDatabaseInitializer();
  List<AppointmentModel> _appointments = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _loadAppointments();
  }

  Future<void> _loadAppointments() async {
    // TODO: Replace with actual user ID from auth
    final userId = PlanMockData.mockUserId;

    try {
      // Initialize database with mock data if empty
      await _dbInitializer.initializeWithMockData(userId);

      // Load from database
      final appointments = await _dataSource.getAppointments(userId);

      setState(() {
        _appointments = appointments;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
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
                      child: _isLoading
                          ? Center(
                              child: CircularProgressIndicator(
                                color: AppColors.main500,
                              ),
                            )
                          : _appointments.isEmpty
                          ? Center(
                              child: Padding(
                                padding: EdgeInsets.all(screenHeight * 0.05),
                                child: Text(
                                  'No appointments found',
                                  style: TextStyle(
                                    fontSize: screenWidth * 0.04,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                              ),
                            )
                          : Column(
                              children: _appointments.map((appointment) {
                                return Padding(
                                  padding: EdgeInsets.only(
                                    bottom: screenHeight * 0.015,
                                  ),
                                  child: _buildAppointmentCard(
                                    appointment,
                                    screenWidth,
                                    screenHeight,
                                  ),
                                );
                              }).toList(),
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

  IconData _getIconForAppointmentType(String? type) {
    switch (type) {
      case 'Checkup':
        return Icons.favorite_border;
      case 'Imaging':
        return Icons.camera_alt_outlined;
      case 'Lab Test':
        return Icons.science_outlined;
      default:
        return Icons.access_time;
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final tomorrow = now.add(Duration(days: 1));

    if (date.year == now.year &&
        date.month == now.month &&
        date.day == now.day) {
      return 'Today';
    } else if (date.year == tomorrow.year &&
        date.month == tomorrow.month &&
        date.day == tomorrow.day) {
      return 'Tomorrow';
    } else {
      final months = [
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
      return '${months[date.month - 1]} ${date.day}, ${date.year}';
    }
  }

  String _formatTime(DateTime date) {
    final hour = date.hour > 12
        ? date.hour - 12
        : (date.hour == 0 ? 12 : date.hour);
    final minute = date.minute.toString().padLeft(2, '0');
    final period = date.hour >= 12 ? 'PM' : 'AM';
    return '$hour:$minute $period';
  }

  Widget _buildAppointmentCard(
    AppointmentModel appointment,
    double screenWidth,
    double screenHeight,
  ) {
    final now = DateTime.now();
    final remaining = appointment.appointmentDate.difference(now);
    final totalSeconds = remaining.inSeconds > 0 ? remaining.inSeconds : 0;
    final icon = _getIconForAppointmentType(appointment.appointmentType);
    final dateStr = _formatDate(appointment.appointmentDate);
    final timeStr = _formatTime(appointment.appointmentDate);

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
                          appointment.title,
                          style: TextStyle(
                            fontSize: screenWidth * 0.042,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          appointment.doctorName ??
                              appointment.location ??
                              'Appointment',
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
                              dateStr,
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
                              timeStr,
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
