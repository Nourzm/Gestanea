import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:gestanea/core/constants/app_colors.dart';
import 'package:gestanea/core/constants/app_text_styles.dart';
import 'package:gestanea/core/database/models/doctor_model.dart';
import 'package:gestanea/features/doctors/logic/bloc/doctor_detail_bloc.dart';
import 'package:gestanea/features/doctors/logic/bloc/doctor_detail_event.dart';
import 'package:gestanea/features/doctors/logic/bloc/doctor_detail_state.dart';
import 'package:gestanea/features/doctors/presentation/widgets/doctor_info_map_section.dart';
import 'package:gestanea/features/doctors/presentation/widgets/contact_info.dart';
import 'package:gestanea/features/doctors/presentation/widgets/call_now.dart';
import 'package:gestanea/l10n/app_localizations.dart';
import 'package:gestanea/core/theme/theme_cubit.dart';

class DoctorDetailScreen extends StatefulWidget {
  final DoctorModel doctor;

  const DoctorDetailScreen({super.key, required this.doctor});

  @override
  State<DoctorDetailScreen> createState() => _DoctorDetailScreenState();
}

class _DoctorDetailScreenState extends State<DoctorDetailScreen> {
  final MapController _mapController = MapController();
  late DoctorModel _doctor;

  @override
  void initState() {
    super.initState();
    _doctor = widget.doctor;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _mapController.move(
        LatLng(_doctor.latitude ?? 0, _doctor.longitude ?? 0),
        15.0,
      );
    });
  }

  void _openDirections() {
    final lat = _doctor.latitude ?? 0;
    final lng = _doctor.longitude ?? 0;
    context.read<DoctorDetailBloc>().add(OpenDirections(lat, lng));
  }

  void _makePhoneCall() {
    final phoneNumber = _doctor.phone ?? '';
    context.read<DoctorDetailBloc>().add(MakePhoneCall(phoneNumber));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final themeData = context.watch<ThemeCubit>().currentTheme;
    return BlocListener<DoctorDetailBloc, DoctorDetailState>(
      listener: (context, state) {
        if (state is DoctorDetailActionFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.error),
              backgroundColor: AppColors.alerts,
            ),
          );
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.bg_1,
        appBar: AppBar(
          backgroundColor: AppColors.bg_1,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: themeData.primaryColor,
              size: 24,
            ),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(
            l10n.doctorDetails,
            style: AppTextStyles.headline1.copyWith(
              color: themeData.primaryColor,
              fontSize: 32,
              fontFamily: 'Lato',
              letterSpacing: -0.40,
            ),
            textAlign: TextAlign.center,
          ),
          centerTitle: true,
          elevation: 0,
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                DoctorInfoMapSection(
                  doctor: _doctor,
                  mapController: _mapController,
                  onGetDirections: _openDirections,
                ),
                const SizedBox(height: 24),
                ContactInfoSection(doctor: _doctor),
                const SizedBox(height: 24),

                const SizedBox(height: 24),
                CallNowSection(onPressed: _makePhoneCall),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
