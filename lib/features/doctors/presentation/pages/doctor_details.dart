import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:gestanea/core/constants/app_colors.dart';
import 'package:gestanea/core/constants/app_text_styles.dart';
import 'package:gestanea/features/doctors/data/datasources/mock_doctor_data.dart';

class DoctorDetailScreen extends StatefulWidget {
  final Map<String, dynamic>? doctor;

  const DoctorDetailScreen({super.key, this.doctor});

  @override
  State<DoctorDetailScreen> createState() => _DoctorDetailScreenState();
}

class _DoctorDetailScreenState extends State<DoctorDetailScreen> {
  final MapController _mapController = MapController();
  late Map<String, dynamic> _doctor;

  @override
  void initState() {
    super.initState();
    // Use provided doctor or default to sample doctor from mock data
    _doctor = widget.doctor ?? MockDoctorData.sampleDoctor;

    // Center map on Doctor location after build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _mapController.move(
        LatLng(
          _doctor['latitude'] ?? 36.753769,
          _doctor['longitude'] ?? 3.058756,
        ),
        15.0,
      );
    });
  }

  Future<void> _openDirections() async {
    final lat = _doctor['latitude'] ?? 36.753769;
    final lng = _doctor['longitude'] ?? 3.058756;

    // Try Google Maps first (works on both Android and iOS if installed)
    final googleMapsUrl = Uri.parse(
      'https://www.google.com/maps/dir/?api=1&destination=$lat,$lng',
    );

    try {
      // Don't check canLaunchUrl, just try to launch
      final launched = await launchUrl(
        googleMapsUrl,
        mode: LaunchMode.externalApplication,
      );

      if (!launched) {
        // If Google Maps fails, try platform default
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Could not open maps: $e'),
            backgroundColor: AppColors.alerts,
          ),
        );
      }
    }
  }

  Future<void> _makePhoneCall() async {
    final phoneNumber = _doctor['phone_number'] ?? '';
    if (phoneNumber.isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Phone number not available'),
            backgroundColor: AppColors.alerts,
          ),
        );
      }
      return;
    }

    // Clean the phone number (remove spaces, dashes, parentheses)
    final cleanNumber = phoneNumber.replaceAll(RegExp(r'[^\d+]'), '');
    final telUrl = Uri.parse('tel:$cleanNumber');

    try {
      final launched = await launchUrl(telUrl);
      if (!launched) {
        throw 'Could not launch phone dialer';
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Could not make phone call: $e'),
            backgroundColor: AppColors.alerts,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final lat = _doctor['latitude'] ?? 36.753769;
    final lng = _doctor['longitude'] ?? 3.058756;
    final distance = _doctor['distance_km'] ?? 0.0;

    return Scaffold(
      backgroundColor: AppColors.bg_1,
      body: SafeArea(
        child: Column(
          children: [
            // Header with back button (Neumorphic)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Container(
                    width: 45,
                    height: 45,
                    decoration: BoxDecoration(
                      color: AppColors.main300,
                      borderRadius: BorderRadius.circular(11),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x3F000000),
                          blurRadius: 4,
                          offset: Offset(2, 2),
                          spreadRadius: 0,
                        ),
                        BoxShadow(
                          color: AppColors.white,
                          blurRadius: 6,
                          offset: Offset(-3, -3),
                          spreadRadius: 0,
                        ),
                      ],
                    ),
                    child: IconButton(
                      icon: const Icon(
                        Icons.arrow_back,
                        color: AppColors.main600,
                      ),
                      onPressed: () => Navigator.pop(context),
                      padding: EdgeInsets.zero,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      'Doctor Details',
                      style: AppTextStyles.headline2.copyWith(
                        color: AppColors.main600,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(width: 45), // Balance the back button
                ],
              ),
            ),
            // Scrollable content
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // Doctor Info Card (Neumorphic)
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: AppColors.main300,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x3F000000),
                            blurRadius: 4,
                            offset: Offset(2, 2),
                            spreadRadius: 0,
                          ),
                          BoxShadow(
                            color: AppColors.white,
                            blurRadius: 6,
                            offset: Offset(-3, -3),
                            spreadRadius: 0,
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          // Avatar (Neumorphic)
                          Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              color: AppColors.bg_1,
                              shape: BoxShape.circle,
                              boxShadow: const [
                                BoxShadow(
                                  color: Color(0x3F000000),
                                  blurRadius: 4,
                                  offset: Offset(2, 2),
                                  spreadRadius: 0,
                                ),
                                BoxShadow(
                                  color: AppColors.white,
                                  blurRadius: 6,
                                  offset: Offset(-3, -3),
                                  spreadRadius: 0,
                                ),
                              ],
                            ),
                            child: const Center(
                              child: Icon(
                                Icons.person,
                                color: AppColors.main600,
                                size: 32,
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          // Doctor info
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _doctor['name'] ?? 'Dr. Sarah Johnson',
                                  style: AppTextStyles.headline2,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  _doctor['specialty'] ?? 'Cardiologist',
                                  style: AppTextStyles.body1,
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.star,
                                      size: 16,
                                      color: Colors.amber,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      '${_doctor['rating'] ?? 4.8}',
                                      style: AppTextStyles.body1.copyWith(
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.textPrimary,
                                      ),
                                    ),
                                    Text(
                                      ' (${_doctor['total_reviews'] ?? 124})',
                                      style: AppTextStyles.body1,
                                    ),
                                    const SizedBox(width: 12),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 10,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: AppColors.blue200,
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Text(
                                        'Open Now',
                                        style: TextStyle(
                                          fontSize: 11,
                                          color: Color(0xFF059669),
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Map section (Neumorphic)
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                      height: 200,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: AppColors.bg_1,
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x3F000000),
                            blurRadius: 4,
                            offset: Offset(2, 2),
                            spreadRadius: 0,
                          ),
                          BoxShadow(
                            color: AppColors.white,
                            blurRadius: 6,
                            offset: Offset(-3, -3),
                            spreadRadius: 0,
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Stack(
                          children: [
                            FlutterMap(
                              mapController: _mapController,
                              options: MapOptions(
                                initialCenter: LatLng(lat, lng),
                                initialZoom: 15.0,
                              ),
                              children: [
                                TileLayer(
                                  urlTemplate:
                                      'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                                  userAgentPackageName: 'com.medigo.app',
                                ),
                                MarkerLayer(
                                  markers: [
                                    Marker(
                                      point: LatLng(lat, lng),
                                      width: 50,
                                      height: 50,
                                      child: const Icon(
                                        Icons.location_on,
                                        color: AppColors.main600,
                                        size: 50,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Distance and Get Directions (Neumorphic)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.main300,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: const [
                                BoxShadow(
                                  color: Color(0x3F000000),
                                  blurRadius: 4,
                                  offset: Offset(2, 2),
                                  spreadRadius: 0,
                                ),
                                BoxShadow(
                                  color: AppColors.white,
                                  blurRadius: 6,
                                  offset: Offset(-3, -3),
                                  spreadRadius: 0,
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.navigation_outlined,
                                  size: 16,
                                  color: AppColors.main600,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  '${distance.toStringAsFixed(1)} km away',
                                  style: AppTextStyles.body1.copyWith(
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [
                                    AppColors.main600,
                                    AppColors.main500,
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Color(0x3F000000),
                                    blurRadius: 4,
                                    offset: Offset(2, 2),
                                    spreadRadius: 0,
                                  ),
                                  BoxShadow(
                                    color: AppColors.white,
                                    blurRadius: 6,
                                    offset: Offset(-3, -3),
                                    spreadRadius: 0,
                                  ),
                                ],
                              ),
                              child: ElevatedButton(
                                onPressed: _openDirections,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.transparent,
                                  foregroundColor: AppColors.white,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 12,
                                  ),
                                  elevation: 0,
                                  shadowColor: Colors.transparent,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                                child: Text(
                                  'Get Directions',
                                  style: AppTextStyles.body1.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    // Contact Information Section (Neumorphic)
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: AppColors.main300,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x3F000000),
                            blurRadius: 4,
                            offset: Offset(2, 2),
                            spreadRadius: 0,
                          ),
                          BoxShadow(
                            color: AppColors.white,
                            blurRadius: 6,
                            offset: Offset(-3, -3),
                            spreadRadius: 0,
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Contact Information',
                            style: AppTextStyles.headline2,
                          ),
                          const SizedBox(height: 20),
                          // Address
                          _buildContactItem(
                            icon: Icons.location_on_outlined,
                            iconColor: AppColors.main600,
                            title: 'Address',
                            content:
                                _doctor['address'] ??
                                '123 Medical Center Blvd,\nHealthtown',
                          ),
                          const SizedBox(height: 16),
                          // Phone
                          _buildContactItem(
                            icon: Icons.phone_outlined,
                            iconColor: AppColors.main600,
                            title: 'Phone Number',
                            content:
                                _doctor['phone_number'] ?? '(555) 789-456-438',
                          ),
                          const SizedBox(height: 16),
                          // Opening Hours
                          _buildContactItem(
                            icon: Icons.access_time_outlined,
                            iconColor: AppColors.main600,
                            title: 'Opening Hours',
                            content: _formatOpeningHours(
                              _doctor['opening_hours'],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    // How to Get There Section (Neumorphic)
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: AppColors.main300,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x3F000000),
                            blurRadius: 4,
                            offset: Offset(2, 2),
                            spreadRadius: 0,
                          ),
                          BoxShadow(
                            color: AppColors.white,
                            blurRadius: 6,
                            offset: Offset(-3, -3),
                            spreadRadius: 0,
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'How to Get There',
                            style: AppTextStyles.headline2,
                          ),
                          const SizedBox(height: 20),
                          _buildDirectionStep(
                            stepNumber: '1',
                            title: 'Start from your location',
                            subtitle: 'Current location',
                            color: AppColors.main600,
                          ),
                          const SizedBox(height: 16),
                          _buildDirectionStep(
                            stepNumber: '2',
                            title: 'Head North on Main St',
                            subtitle: 'Continue for 2.5 km',
                            color: AppColors.main600,
                          ),
                          const SizedBox(height: 16),
                          _buildDirectionStep(
                            stepNumber: '3',
                            title: 'Turn right onto Park Ave',
                            subtitle: 'Go straight for 1.2 km',
                            color: AppColors.main600,
                          ),
                          const SizedBox(height: 16),
                          _buildDirectionStep(
                            stepNumber: '✓',
                            title: 'You\'ve arrived!',
                            subtitle: 'Destination on the right',
                            color: Color(0xFF059669),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    // Call Now button (Neumorphic with gradient)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [AppColors.main600, AppColors.main500],
                          ),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: const [
                            BoxShadow(
                              color: Color(0x3F000000),
                              blurRadius: 4,
                              offset: Offset(2, 2),
                              spreadRadius: 0,
                            ),
                            BoxShadow(
                              color: AppColors.white,
                              blurRadius: 6,
                              offset: Offset(-3, -3),
                              spreadRadius: 0,
                            ),
                          ],
                        ),
                        child: ElevatedButton.icon(
                          onPressed: _makePhoneCall,
                          icon: const Icon(Icons.phone, size: 20),
                          label: Text(
                            'Call Now',
                            style: AppTextStyles.subtitle1.copyWith(
                              fontWeight: FontWeight.w600,
                              color: AppColors.white,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            foregroundColor: AppColors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            elevation: 0,
                            shadowColor: Colors.transparent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactItem({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String content,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: AppColors.bg_1,
            shape: BoxShape.circle,
            boxShadow: const [
              BoxShadow(
                color: Color(0x3F000000),
                blurRadius: 4,
                offset: Offset(2, 2),
                spreadRadius: 0,
              ),
              BoxShadow(
                color: AppColors.white,
                blurRadius: 6,
                offset: Offset(-3, -3),
                spreadRadius: 0,
              ),
            ],
          ),
          child: Icon(icon, size: 20, color: iconColor),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: AppTextStyles.smallLabel),
              const SizedBox(height: 4),
              Text(
                content,
                style: AppTextStyles.body1.copyWith(
                  fontWeight: FontWeight.w500,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDirectionStep({
    required String stepNumber,
    required String title,
    required String subtitle,
    required Color color,
    bool isLast = false,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            boxShadow: const [
              BoxShadow(
                color: Color(0x3F000000),
                blurRadius: 4,
                offset: Offset(2, 2),
                spreadRadius: 0,
              ),
              BoxShadow(
                color: AppColors.white,
                blurRadius: 6,
                offset: Offset(-3, -3),
                spreadRadius: 0,
              ),
            ],
          ),
          child: Center(
            child: Text(
              stepNumber,
              style: AppTextStyles.body1.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.white,
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppTextStyles.body1.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 2),
              Text(subtitle, style: AppTextStyles.smallLabel),
            ],
          ),
        ),
      ],
    );
  }

  String _formatOpeningHours(String? hours) {
    if (hours == null) {
      return 'Open Now\nMon-Fri: 9:00 AM - 6:00 PM\nSat: 10:00 AM - 4:00 PM\nSun: Closed';
    }
    return hours;
  }
}
