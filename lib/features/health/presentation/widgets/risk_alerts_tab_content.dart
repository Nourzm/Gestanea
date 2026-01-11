import 'package:flutter/material.dart';
import 'package:gestanea/core/constants/app_colors.dart';
import 'package:gestanea/core/constants/app_text_styles.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gestanea/core/theme/theme_cubit.dart';
import 'package:gestanea/l10n/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:gestanea/features/pregnancyTracking/data/repositories/pregnancy_repository.dart';
import '../../../../core/services/gemini_service.dart';
import '../../../../core/services/risk_alerts_service.dart';
import '../../logic/bloc/measurements_bloc.dart';
import '../../logic/bloc/measurements_state.dart';
import '../../logic/bloc/symptoms_bloc.dart';
import '../../logic/bloc/symptoms_state.dart';
import '../../logic/bloc/lab_results_bloc.dart';
import '../../logic/bloc/lab_results_state.dart';
import '../../logic/bloc/moods_bloc.dart';
import '../../logic/bloc/moods_state.dart';

class RiskAlertsTabContent extends StatefulWidget {
  const RiskAlertsTabContent({super.key});

  @override
  State<RiskAlertsTabContent> createState() => _RiskAlertsTabContentState();
}

class _RiskAlertsTabContentState extends State<RiskAlertsTabContent> {
  final GeminiService _geminiService = GeminiService();
  final RiskAlertsService _riskAlertsService = RiskAlertsService();
  final PregnancyRepository _pregnancyRepository = PregnancyRepository();
  Map<String, dynamic>? _riskAssessment;
  bool _isLoading = false;
  bool _hasError = false;
  int _currentWeek = 20; // Default fallback

  @override
  void initState() {
    super.initState();
    // Auto-load on init
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadRiskAssessment();
    });
  }

  Future<void> _loadRiskAssessment({bool clearCache = false}) async {
    setState(() {
      _isLoading = true;
      _hasError = false;
    });

    // Only clear cache if explicitly requested (e.g., on pull-to-refresh)
    if (clearCache) {
      await _geminiService.clearCache();
      print('🔄 Cache cleared, generating fresh risk assessment...');
    }

    try {
      print('🔄 _loadRiskAssessment: Starting...');
      
      // Get actual pregnancy week
      final userId = Supabase.instance.client.auth.currentUser?.id;
      if (userId != null) {
        print('🔄 _loadRiskAssessment: Fetching pregnancy info for $userId');
        final pregInfo = await _pregnancyRepository.getPregnancyInfo(userId);
        _currentWeek = pregInfo['currentWeek'] ?? 20;
        print('🔄 _loadRiskAssessment: Current week = $_currentWeek');
      }

      // Gather all health data from blocs
      print('🔄 _loadRiskAssessment: Reading BLoC states');
      final measurementsState = context.read<MeasurementsBloc>().state;
      final symptomsState = context.read<SymptomsBloc>().state;
      final labResultsState = context.read<LabResultsBloc>().state;
      final moodsState = context.read<MoodsBloc>().state;

      // Extract vitals
      final measurements = measurementsState is MeasurementsLoaded 
          ? measurementsState.measurements : [];
      final latest = measurements.isNotEmpty ? measurements.first : null;

      final vitalsData = {
        'currentWeight': latest?.weight,
        'previousWeight': measurements.length >= 2 ? measurements[1].weight : null,
        'heartRate': latest?.heartRate,
        'systolic': latest?.systolic,
        'diastolic': latest?.diastolic,
      };

      // Extract symptoms
      final symptoms = symptomsState is SymptomsLoaded 
          ? symptomsState.symptoms : [];
      final recentSymptoms = symptoms.take(10).map((s) => {
        'name': s.symptomName,
        'severity': s.severity,
        'duration': s.duration,
      }).toList();

      // Extract lab results
      final labResults = labResultsState is LabResultsLoaded 
          ? labResultsState.labResults : [];
      final recentLabs = labResults.take(5).map((lab) => {
        'testName': lab.testName,
        'value': lab.value,
        'unit': lab.unit,
        'normalRangeMin': lab.normalRangeMin,
        'normalRangeMax': lab.normalRangeMax,
      }).toList();

      // Extract moods
      final moods = moodsState is MoodsLoaded ? moodsState.moods : [];
      final moodCounts = <String, int>{};
      for (final mood in moods.take(20)) {
        moodCounts[mood.mood] = (moodCounts[mood.mood] ?? 0) + 1;
      }

      // Generate risk assessment
      print('🔍 Generating risk assessment with:');
      print('  - Vitals: $vitalsData');
      print('  - Symptoms: ${recentSymptoms.length} symptoms');
      print('  - Labs: ${recentLabs.length} labs');
      print('  - Moods: $moodCounts');
      
      final assessment = await _geminiService.generateRiskAssessment(
        pregnancyWeek: _currentWeek,
        vitalsData: vitalsData,
        recentSymptoms: recentSymptoms,
        recentLabs: recentLabs,
        moodCounts: moodCounts,
      );

      print('✅ Risk assessment generated: $assessment');

      // Save to Supabase for historical tracking
      try {
        final userId = Supabase.instance.client.auth.currentUser?.id;
        if (userId != null) {
          await _riskAlertsService.saveRiskAssessment(
            userId: userId,
            assessment: assessment,
          );
        }
      } catch (e) {
        print('⚠️ Failed to save risk assessment to Supabase: $e');
        // Don't fail the whole operation if saving fails
      }

      setState(() {
        _riskAssessment = assessment;
        _isLoading = false;
      });
    } catch (e, stackTrace) {
      print('❌ Error loading risk assessment: $e');
      print('Stack trace: $stackTrace');
      setState(() {
        _hasError = true;
        _isLoading = false;
      });
    }
  }

  Color _getRiskColor(String riskLevel) {
    switch (riskLevel.toLowerCase()) {
      case 'none':
        return const Color(0xFF4CAF50);
      case 'low':
        return const Color(0xFF8BC34A);
      case 'medium':
        return const Color(0xFFFFA726);
      case 'high':
        return const Color(0xFFFF7043);
      case 'urgent':
        return const Color(0xFFE53935);
      default:
        return Colors.grey;
    }
  }

  IconData _getRiskIcon(String riskLevel) {
    switch (riskLevel.toLowerCase()) {
      case 'none':
        return Icons.check_circle;
      case 'low':
        return Icons.info;
      case 'medium':
        return Icons.warning_amber;
      case 'high':
        return Icons.warning;
      case 'urgent':
        return Icons.emergency;
      default:
        return Icons.help;
    }
  }

  Future<Map<String, String?>> _getEmergencyContacts() async {
    try {
      final userId = Supabase.instance.client.auth.currentUser?.id;
      if (userId == null) return {};

      final response = await Supabase.instance.client
          .from('users')
          .select('partner_phone, healthcare_provider_phone, parent_phone')
          .eq('id', userId)
          .single();

      return {
        'partner': response['partner_phone'] as String?,
        'healthcare': response['healthcare_provider_phone'] as String?,
        'parent': response['parent_phone'] as String?,
      };
    } catch (e) {
      print('Error fetching emergency contacts: $e');
      return {};
    }
  }

  bool _hasAllEmergencyContacts(Map<String, String?> contacts) {
    return (contacts['partner'] != null) &&
           (contacts['healthcare'] != null) &&
           (contacts['parent'] != null);
  }

  Future<void> _saveEmergencyContact(String type, String phoneNumber) async {
    try {
      final userId = Supabase.instance.client.auth.currentUser?.id;
      if (userId == null) return;

      String columnName;
      switch (type) {
        case 'partner':
          columnName = 'partner_phone';
          break;
        case 'healthcare':
          columnName = 'healthcare_provider_phone';
          break;
        case 'parent':
          columnName = 'parent_phone';
          break;
        default:
          return;
      }

      await Supabase.instance.client
          .from('users')
          .update({columnName: phoneNumber})
          .eq('id', userId);

      setState(() {}); // Refresh UI
    } catch (e) {
      print('Error saving emergency contact: $e');
    }
  }

  Widget _buildEmergencyContactSetupCard(Map<String, String?> existingContacts) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 360;

    return Container(
      padding: EdgeInsets.all(isSmallScreen ? 12 : 16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFFF6B6B), Color(0xFFFF8E53)],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(isSmallScreen ? 6 : 8),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(Icons.phone_callback, color: Colors.white, size: isSmallScreen ? 20 : 24),
              ),
              SizedBox(width: isSmallScreen ? 8 : 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Emergency Contacts Setup',
                      style: AppTextStyles.headline2.copyWith(
                        color: Colors.white,
                        fontSize: isSmallScreen ? 14 : 16,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      'Add important contacts for quick access',
                      style: AppTextStyles.body1.copyWith(
                        color: Colors.white.withValues(alpha: 0.9),
                        fontSize: isSmallScreen ? 10 : 12,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: isSmallScreen ? 12 : 16),
          _buildContactInputRow('Partner', 'partner', existingContacts['partner']),
          SizedBox(height: isSmallScreen ? 6 : 8),
          _buildContactInputRow('Healthcare Provider', 'healthcare', existingContacts['healthcare']),
          SizedBox(height: isSmallScreen ? 6 : 8),
          _buildContactInputRow('Parent/Family', 'parent', existingContacts['parent']),
        ],
      ),
    );
  }

  Widget _buildContactInputRow(String label, String type, String? existingValue) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 360;
    final isNoNeed = existingValue == 'NO_NEED';
    final displayText = isNoNeed 
        ? '$label: Not needed' 
        : (existingValue ?? '$label: Not set');
    
    return Row(
      children: [
        Expanded(
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: isSmallScreen ? 8 : 12, 
              vertical: isSmallScreen ? 6 : 8,
            ),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(
                  existingValue != null ? Icons.check_circle : Icons.add_circle_outline,
                  color: Colors.white,
                  size: isSmallScreen ? 16 : 20,
                ),
                SizedBox(width: isSmallScreen ? 6 : 8),
                Expanded(
                  child: Text(
                    displayText,
                    style: AppTextStyles.body1.copyWith(
                      color: Colors.white,
                      fontSize: isSmallScreen ? 11 : 13,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(width: isSmallScreen ? 4 : 8),
        IconButton(
          onPressed: () => _showAddContactDialog(label, type, existingValue),
          icon: Icon(
            existingValue != null ? Icons.edit : Icons.add,
            color: Colors.white,
            size: isSmallScreen ? 20 : 24,
          ),
          style: IconButton.styleFrom(
            backgroundColor: Colors.white.withValues(alpha: 0.3),
            padding: EdgeInsets.all(isSmallScreen ? 6 : 8),
          ),
        ),
      ],
    );
  }

  Future<void> _showAddContactDialog(String label, String type, String? existingValue) async {
    final isNoNeed = existingValue == 'NO_NEED';
    final controller = TextEditingController(text: isNoNeed ? '' : existingValue);
    
    final result = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFFF3E5FF),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFF7B4BA6).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.phone, color: Color(0xFF7B4BA6), size: 24),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'Add $label Contact',
                style: AppTextStyles.headline2.copyWith(
                  color: const Color(0xFF7B4BA6),
                  fontSize: 18,
                ),
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: controller,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                labelText: 'Phone Number',
                labelStyle: const TextStyle(color: Color(0xFF7B4BA6)),
                hintText: 'e.g., 0555123456',
                hintStyle: TextStyle(color: Colors.grey.shade400),
                prefixIcon: const Icon(Icons.phone, color: Color(0xFF7B4BA6)),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFF7B4BA6)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFF7B4BA6), width: 2),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
              ),
            ),
            const SizedBox(height: 12),
            TextButton.icon(
              onPressed: () => Navigator.pop(context, 'NO_NEED'),
              icon: const Icon(Icons.block, size: 18),
              label: Text(AppLocalizations.of(context)!.iDontNeedThisContact),
              style: TextButton.styleFrom(
                foregroundColor: Colors.grey.shade600,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: TextStyle(color: Colors.grey.shade600),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              final text = controller.text.trim();
              if (text.isNotEmpty) {
                Navigator.pop(context, text);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF7B4BA6),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(AppLocalizations.of(context)!.saveEmergencyContacts),
          ),
        ],
      ),
    );

    if (result != null && result.isNotEmpty) {
      await _saveEmergencyContact(type, result);
    }
  }

  Future<void> _makeEmergencyCall(BuildContext context) async {
    final l10n = AppLocalizations.of(context)!;

    // Get saved emergency contacts
    final contacts = await _getEmergencyContacts();

    // Show dialog with multiple emergency contact options
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFFFAF0FF),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            const Icon(Icons.phone, color: Colors.red, size: 28),
            const SizedBox(width: 8),
            Text(
              l10n.emergencyContact,
              style: AppTextStyles.headline2.copyWith(
                color: AppColors.textDark,
                fontSize: 18,
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Who would you like to call?',
              style: AppTextStyles.body1.copyWith(
                color: AppColors.textDark,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 16),
            _buildEmergencyContactOption(
              context,
              icon: Icons.local_hospital,
              title: 'Hospital (Algeria)',
              subtitle: '15 - Emergency Medical Services',
              phoneNumber: '15',
            ),
            if (contacts['healthcare'] != null && contacts['healthcare'] != 'NO_NEED') ...[
              const SizedBox(height: 8),
              _buildEmergencyContactOption(
                context,
                icon: Icons.medical_services,
                title: 'Healthcare Provider',
                subtitle: contacts['healthcare']!,
                phoneNumber: contacts['healthcare']!,
              ),
            ],
            if (contacts['partner'] != null && contacts['partner'] != 'NO_NEED') ...[
              const SizedBox(height: 8),
              _buildEmergencyContactOption(
                context,
                icon: Icons.favorite,
                title: 'Partner',
                subtitle: contacts['partner']!,
                phoneNumber: contacts['partner']!,
              ),
            ],
            if (contacts['parent'] != null && contacts['parent'] != 'NO_NEED') ...[
              const SizedBox(height: 8),
              _buildEmergencyContactOption(
                context,
                icon: Icons.family_restroom,
                title: 'Parent/Family',
                subtitle: contacts['parent']!,
                phoneNumber: contacts['parent']!,
              ),
            ],
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              l10n.cancel,
              style: TextStyle(color: Colors.grey.shade600),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmergencyContactOption(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required String phoneNumber,
  }) {
    return InkWell(
      onTap: () async {
        Navigator.pop(context);
        await _callPhoneNumber(context, phoneNumber, title);
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFF7B4BA6).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: const Color(0xFF7B4BA6), size: 24),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextStyles.subtitle1.copyWith(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: AppTextStyles.body1.copyWith(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.phone, color: Color(0xFF7B4BA6), size: 20),
          ],
        ),
      ),
    );
  }

  Future<void> _callPhoneNumber(BuildContext context, String phoneNumber, String contactName) async {
    final l10n = AppLocalizations.of(context)!;
    
    final Uri phoneUri = Uri(scheme: 'tel', path: phoneNumber);
    try {
      if (await canLaunchUrl(phoneUri)) {
        await launchUrl(phoneUri);
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(l10n.couldNotMakePhoneCall),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error calling $contactName: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Stack(
      children: [
        Container(
          decoration: const BoxDecoration(
            color: Color(0xFFFAF0FF),
            borderRadius: BorderRadius.only(topLeft: Radius.circular(15)),
          ),
          child: RefreshIndicator(
            onRefresh: () => _loadRiskAssessment(clearCache: true),
            child: _isLoading
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(color: Color(0xFF7B4BA6)),
                        SizedBox(height: 16),
                        Text(AppLocalizations.of(context)!.analyzingYourHealthData, 
                          style: TextStyle(color: Color(0xFF7B4BA6))),
                      ],
                    ),
                  )
                : _hasError
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.error_outline, size: 64, color: Colors.red),
                            const SizedBox(height: 16),
                            Text(AppLocalizations.of(context)!.unableToAssessRisk),
                            const SizedBox(height: 8),
                            ElevatedButton.icon(
                              onPressed: _loadRiskAssessment,
                              icon: const Icon(Icons.refresh),
                              label: Text(AppLocalizations.of(context)!.retry),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF7B4BA6),
                                foregroundColor: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      )
                    : _buildRiskAssessmentContent(l10n),
          ),
        ),
        // TOP inset shadow
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: IgnorePointer(
            child: Container(
              height: 25,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(15),
                ),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.12),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRiskAssessmentContent(AppLocalizations l10n) {
    if (_riskAssessment == null) {
      return Center(child: Text(AppLocalizations.of(context)!.noAssessmentAvailable));
    }

    final riskLevel = (_riskAssessment!['riskLevel']?.toString() == null || _riskAssessment!['riskLevel'].toString().isEmpty) 
        ? 'none' : _riskAssessment!['riskLevel'].toString();
    final primaryConcern = (_riskAssessment!['primaryConcern']?.toString() == null || _riskAssessment!['primaryConcern'].toString().isEmpty)
        ? l10n.noSignificantConcernsMessage : _riskAssessment!['primaryConcern'].toString();
    final patterns = (_riskAssessment!['detectedPatterns'] as List<dynamic>?) ?? [];
    final recommendations = (_riskAssessment!['recommendations'] as List<dynamic>?) ?? [];
    final urgency = (_riskAssessment!['urgency']?.toString() == null || _riskAssessment!['urgency'].toString().isEmpty)
        ? 'Monitor' : _riskAssessment!['urgency'].toString();
    final reasoning = (_riskAssessment!['reasoning']?.toString() == null || _riskAssessment!['reasoning'].toString().isEmpty)
        ? l10n.noAssessmentDetailsAvailable : _riskAssessment!['reasoning'].toString();

    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Emergency Contact Setup Card (show if no contacts configured)
          FutureBuilder<Map<String, String?>>(
            future: _getEmergencyContacts(),
            builder: (context, snapshot) {
              if (snapshot.hasData && !_hasAllEmergencyContacts(snapshot.data!)) {
                return Column(
                  children: [
                    _buildEmergencyContactSetupCard(snapshot.data!),
                    const SizedBox(height: 16),
                  ],
                );
              }
              return const SizedBox.shrink();
            },
          ),

          // Risk Level Card
          LayoutBuilder(
            builder: (context, constraints) {
              final isSmallScreen = constraints.maxWidth < 340;
              return Container(
                width: double.infinity,
                padding: EdgeInsets.all(isSmallScreen ? 14 : 20),
                decoration: BoxDecoration(
                  color: _getRiskColor(riskLevel).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: _getRiskColor(riskLevel),
                    width: 2,
                  ),
                ),
                child: Column(
                  children: [
                    Icon(
                      _getRiskIcon(riskLevel),
                      size: isSmallScreen ? 48 : 64,
                      color: _getRiskColor(riskLevel),
                    ),
                    SizedBox(height: isSmallScreen ? 8 : 12),
                    Text(
                      riskLevel.toUpperCase() + ' RISK',
                      style: AppTextStyles.headline2.copyWith(
                        color: _getRiskColor(riskLevel),
                        fontSize: isSmallScreen ? 18 : 24,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: isSmallScreen ? 6 : 8),
                    Text(
                      primaryConcern,
                      textAlign: TextAlign.center,
                      style: AppTextStyles.body1.copyWith(
                        fontSize: isSmallScreen ? 13 : 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textDark,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),

          const SizedBox(height: 24),

          // Urgency Banner
          LayoutBuilder(
            builder: (context, constraints) {
              final isSmallScreen = constraints.maxWidth < 340;
              return Container(
                width: double.infinity,
                padding: EdgeInsets.all(isSmallScreen ? 12 : 16),
                decoration: BoxDecoration(
                  color: riskLevel.toLowerCase() == 'urgent' || riskLevel.toLowerCase() == 'high'
                      ? const Color(0xFFFFEBEE)
                      : const Color(0xFFE8F5E9),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: riskLevel.toLowerCase() == 'urgent' || riskLevel.toLowerCase() == 'high'
                        ? Colors.red.shade300
                        : Colors.green.shade300,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.schedule,
                      color: riskLevel.toLowerCase() == 'urgent' || riskLevel.toLowerCase() == 'high'
                          ? Colors.red
                          : Colors.green,
                      size: isSmallScreen ? 20 : 24,
                    ),
                    SizedBox(width: isSmallScreen ? 8 : 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'ACTION NEEDED',
                            style: AppTextStyles.body1.copyWith(
                              fontWeight: FontWeight.bold,
                              fontSize: isSmallScreen ? 10 : 12,
                              color: AppColors.textDark,
                            ),
                          ),
                          Text(
                            urgency,
                            style: AppTextStyles.body1.copyWith(
                              fontSize: isSmallScreen ? 12 : 14,
                              color: AppColors.textDark,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),

          const SizedBox(height: 24),

          // Detected Patterns
          if (patterns.isNotEmpty) ...[
            Text(
              'Detected Patterns',
              style: AppTextStyles.headline2.copyWith(
                fontSize: 18,
                color: AppColors.textDark,
              ),
            ),
            const SizedBox(height: 12),
            ...patterns.map((pattern) => Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  const Icon(Icons.fiber_manual_record, size: 12, color: Color(0xFF7B4BA6)),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      pattern.toString(),
                      style: AppTextStyles.body1.copyWith(
                        color: AppColors.textDark,
                      ),
                    ),
                  ),
                ],
              ),
            )),
            const SizedBox(height: 24),
          ],

          // Recommendations
          Text(
            'Recommendations',
            style: AppTextStyles.headline2.copyWith(
              fontSize: 18,
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(height: 12),
          ...recommendations.asMap().entries.map((entry) => Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  width: 24,
                  height: 24,
                  decoration: const BoxDecoration(
                    color: Color(0xFF7B4BA6),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      '${entry.key + 1}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    entry.value.toString(),
                    style: AppTextStyles.body1.copyWith(
                      color: AppColors.textDark,
                    ),
                  ),
                ),
              ],
            ),
          )),

          const SizedBox(height: 24),

          // Emergency Call Button (if urgent)
          if (riskLevel.toLowerCase() == 'urgent') ...[
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => _makeEmergencyCall(context),
                icon: const Icon(Icons.phone, size: 24),
                label: Text(
                  l10n.emergencyCall,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 4,
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],

          // AI Reasoning
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFF3E5FF),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.psychology, color: Color(0xFF7B4BA6)),
                    const SizedBox(width: 8),
                    Text(
                      'AI Analysis',
                      style: AppTextStyles.body1.copyWith(
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF7B4BA6),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  reasoning,
                  style: AppTextStyles.body1.copyWith(
                    color: const Color(0xFF7B4BA6),
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Emergency Contact Card (Always show)
          _buildEmergencyContactCard(context),

          const SizedBox(height: 16),

          // Disclaimer
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.orange.shade50,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.orange.shade200),
            ),
            child: Row(
              children: [
                Icon(Icons.warning_amber, color: Colors.orange.shade700, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    '⚠️ AI-generated risk assessment. Not a medical diagnosis. Always consult your healthcare provider for concerns.',
                    style: AppTextStyles.body1.copyWith(
                      fontSize: 11,
                      color: Colors.orange.shade900,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOverallRiskCard(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 360;

    return Container(
      padding: EdgeInsets.all(isSmallScreen ? 12 : 16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF4CAF50), Color(0xFF66BB6A)],
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
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(isSmallScreen ? 8 : 12),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.3),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.check_circle,
              color: AppColors.white,
              size: isSmallScreen ? 24 : 32,
            ),
          ),
          SizedBox(width: isSmallScreen ? 10 : 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.overallRiskLevel,
                  style: AppTextStyles.body1.copyWith(
                    color: AppColors.white,
                    fontSize: isSmallScreen ? 11 : 13,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: isSmallScreen ? 2 : 4),
                Text(
                  l10n.lowRisk,
                  style: AppTextStyles.headline2.copyWith(
                    color: AppColors.white,
                    fontSize: isSmallScreen ? 18 : 24,
                  ),
                ),
                SizedBox(height: isSmallScreen ? 2 : 4),
                Text(
                  l10n.allIndicatorsNormal,
                  style: AppTextStyles.smallLabel.copyWith(
                    color: Colors.white.withValues(alpha: 0.9),
                    fontSize: isSmallScreen ? 10 : 12,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRiskFactorCard(
    BuildContext context, {
    required IconData icon,
    required String factor,
    required String level,
    required Color levelColor,
    required String description,
  }) {
    final themeData = context.watch<ThemeCubit>().currentTheme;
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 360;

    return Container(
      padding: EdgeInsets.all(isSmallScreen ? 10 : 14),
      decoration: BoxDecoration(
        color: AppColors.white,
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
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(isSmallScreen ? 6 : 10),
            decoration: BoxDecoration(
              color: themeData.cardColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: themeData.primaryColor, size: isSmallScreen ? 18 : 24),
          ),
          SizedBox(width: isSmallScreen ? 8 : 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  factor,
                  style: AppTextStyles.subtitle1.copyWith(
                    fontSize: isSmallScreen ? 12 : 14,
                    color: AppColors.textDark,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: isSmallScreen ? 2 : 4),
                Text(
                  description,
                  style: AppTextStyles.smallLabel.copyWith(
                    fontSize: isSmallScreen ? 9 : 11,
                    color: AppColors.textDark,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          SizedBox(width: isSmallScreen ? 4 : 8),
          Flexible(
            flex: 0,
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: isSmallScreen ? 6 : 10, 
                vertical: isSmallScreen ? 3 : 4,
              ),
              decoration: BoxDecoration(
                color: levelColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                level,
                style: AppTextStyles.smallLabel.copyWith(
                  fontSize: isSmallScreen ? 9 : 11,
                  color: const Color(0xFF2D5F2D),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWarningSignsCard(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 360;

    return Container(
      padding: EdgeInsets.all(isSmallScreen ? 10 : 14),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF3CD),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.warning_amber,
                color: const Color(0xFF856404),
                size: isSmallScreen ? 20 : 24,
              ),
              SizedBox(width: isSmallScreen ? 6 : 8),
              Expanded(
                child: Text(
                  l10n.warningSignsToWatch,
                  style: AppTextStyles.subtitle1.copyWith(
                    fontSize: isSmallScreen ? 12 : 14,
                    color: const Color(0xFF856404),
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          SizedBox(height: isSmallScreen ? 8 : 12),
          _buildWarningSignItem(l10n.severeHeadache),
          _buildWarningSignItem(l10n.blurredVision),
          _buildWarningSignItem(l10n.severeAbdominalPain),
          _buildWarningSignItem(l10n.decreasedFetalMovement),
          _buildWarningSignItem(l10n.vaginalBleeding),
        ],
      ),
    );
  }

  Widget _buildWarningSignItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          const Icon(Icons.circle, size: 6, color: Color(0xFF856404)),
          const SizedBox(width: 8),
          Text(
            text,
            style: AppTextStyles.body1.copyWith(
              fontSize: 12,
              color: const Color(0xFF856404),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmergencyContactCard(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 360;

    return GestureDetector(
      onTap: () => _makeEmergencyCall(context),
      child: Container(
        padding: EdgeInsets.all(isSmallScreen ? 12 : 16),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFFE53935), Color(0xFFEF5350)],
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
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(isSmallScreen ? 8 : 10),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(Icons.phone, color: AppColors.white, size: isSmallScreen ? 20 : 24),
            ),
            SizedBox(width: isSmallScreen ? 8 : 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.emergencyContact,
                    style: AppTextStyles.body1.copyWith(
                      color: AppColors.white,
                      fontSize: isSmallScreen ? 11 : 13,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: isSmallScreen ? 2 : 4),
                  Text(
                    l10n.call911OrProvider,
                    style: AppTextStyles.subtitle1.copyWith(
                      color: AppColors.white,
                      fontSize: isSmallScreen ? 13 : 16,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward, color: AppColors.white, size: isSmallScreen ? 20 : 24),
          ],
        ),
      ),
    );
  }

  Widget _buildTipCard(String message) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFE8D5F2),
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
      child: Text(
        message,
        style: AppTextStyles.body1.copyWith(
          color: const Color(0xFF7B4BA6),
          fontSize: 12,
        ),
      ),
    );
  }
}
