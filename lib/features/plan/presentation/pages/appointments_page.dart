import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gestanea/core/constants/app_colors.dart';
import 'package:gestanea/core/widgets/subheader.dart';
import 'package:gestanea/l10n/app_localizations.dart';
import 'package:gestanea/core/database/models/appointment_model.dart';
import '../../logic/plan_bloc.dart';

class AppointmentsPage extends StatefulWidget {
  final String userId;

  const AppointmentsPage({super.key, required this.userId});

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
    _loadAppointments();
  }

  void _loadAppointments() {
    context.read<PlanBloc>().add(LoadAppointments(userId: widget.userId));
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
              onBackPressed: () {
                Navigator.of(context).pop();
              },
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
                      child: BlocBuilder<PlanBloc, PlanState>(
                        builder: (context, state) {
                          if (state is PlanLoading) {
                            return Center(
                              child: CircularProgressIndicator(
                                color: AppColors.main500,
                              ),
                            );
                          }

                          if (state is PlanError) {
                            return Center(
                              child: Padding(
                                padding: EdgeInsets.all(screenHeight * 0.05),
                                child: Text(
                                  '${localizations.error}: ${state.message}',
                                  style: TextStyle(
                                    fontSize: screenWidth * 0.04,
                                    color: Colors.red,
                                  ),
                                ),
                              ),
                            );
                          }

                          List<AppointmentModel> appointments = [];
                          if (state is AppointmentsLoaded) {
                            appointments = state.appointments;
                          } else if (state is PlanLoaded) {
                            appointments = state.appointments;
                          }

                          if (appointments.isEmpty) {
                            return Center(
                              child: Padding(
                                padding: EdgeInsets.all(screenHeight * 0.05),
                                child: Text(
                                  localizations.noAppointmentsFound,
                                  style: TextStyle(
                                    fontSize: screenWidth * 0.04,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                              ),
                            );
                          }

                          return Column(
                            children: appointments.map((appointment) {
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
                          );
                        },
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

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final tomorrow = now.add(Duration(days: 1));

    if (date.year == now.year &&
        date.month == now.month &&
        date.day == now.day) {
      return AppLocalizations.of(context)!.today;
    } else if (date.year == tomorrow.year &&
        date.month == tomorrow.month &&
        date.day == tomorrow.day) {
      return AppLocalizations.of(context)!.tomorrow;
    } else {
      final localizations = AppLocalizations.of(context)!;
      final months = [
        localizations.jan,
        localizations.feb,
        localizations.mar,
        localizations.apr,
        localizations.may,
        localizations.jun,
        localizations.jul,
        localizations.aug,
        localizations.sep,
        localizations.oct,
        localizations.nov,
        localizations.dec,
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
    final localizations = AppLocalizations.of(context)!;
    final icon = Icons.access_time;
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
                              localizations.appointment,
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
      ],
    );
  }
}
