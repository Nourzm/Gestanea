import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:gestanea/core/constants/app_colors.dart';
import 'package:gestanea/core/constants/app_text_styles.dart';
import 'package:gestanea/features/doctors/data/datasources/mock_doctor_data.dart';
import 'package:gestanea/features/doctors/logic/map_navigation_usecase.dart';
import 'package:gestanea/features/doctors/logic/phone_call_usecase.dart';
import 'package:gestanea/features/doctors/presentation/widgets/doctor_info_map_section.dart';
import 'package:gestanea/features/doctors/presentation/widgets/contact_info.dart';

import 'package:gestanea/features/doctors/presentation/widgets/call_now.dart';
import 'package:gestanea/l10n/app_localizations.dart';

class DoctorDetailScreen extends StatefulWidget {
  final Map<String, dynamic>? doctor;

  const DoctorDetailScreen({super.key, this.doctor});

  @override
  State<DoctorDetailScreen> createState() => _DoctorDetailScreenState();
}

class _DoctorDetailScreenState extends State<DoctorDetailScreen> {
  final MapController _mapController = MapController();
  late Map<String, dynamic> _doctor;

  // Use cases
  final _mapNavigationUseCase = MapNavigationUseCase();
  final _phoneCallUseCase = PhoneCallUseCase();

  @override
  void initState() {
    super.initState();
    _doctor = widget.doctor ?? MockDoctorData.sampleDoctor;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _mapController.move(
        LatLng(_doctor['latitude'], _doctor['longitude']),
        15.0,
      );
    });
  }

  Future<void> _openDirections() async {
    final lat = _doctor['latitude'];
    final lng = _doctor['longitude'];

    final success = await _mapNavigationUseCase.openDirections(lat, lng);

    if (!success && mounted) {
      final l10n = AppLocalizations.of(context)!;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.couldNotOpenMaps),
          backgroundColor: AppColors.alerts,
        ),
      );
    }
  }

  Future<void> _makePhoneCall() async {
    final phoneNumber = _doctor['phone_number'] ?? '';

    if (phoneNumber.isEmpty) {
      if (mounted) {
        final l10n = AppLocalizations.of(context)!;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.phoneNumberNotAvailable),
            backgroundColor: AppColors.alerts,
          ),
        );
      }
      return;
    }

    final success = await _phoneCallUseCase.makePhoneCall(phoneNumber);

    if (!success && mounted) {
      final l10n = AppLocalizations.of(context)!;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.couldNotMakePhoneCall),
          backgroundColor: AppColors.alerts,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: AppColors.bg_1,
      appBar: AppBar(
        backgroundColor: AppColors.bg_1,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: AppColors.main500, size: 24),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          l10n.doctorDetails,
          style: AppTextStyles.headline1.copyWith(
            color: AppColors.main500,
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
    );
  }
}
