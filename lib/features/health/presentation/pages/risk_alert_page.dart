import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gestanea/core/constants/app_colors.dart';
import 'package:gestanea/core/constants/app_text_styles.dart';
import 'package:gestanea/core/services/gemini_service.dart';
import 'package:gestanea/l10n/app_localizations.dart';
import '../../logic/bloc/measurements_bloc.dart';
import '../../logic/bloc/measurements_state.dart';
import '../../logic/bloc/symptoms_bloc.dart';
import '../../logic/bloc/symptoms_state.dart';
import '../../logic/bloc/lab_results_bloc.dart';
import '../../logic/bloc/lab_results_state.dart';
import '../../logic/bloc/moods_bloc.dart';
import '../../logic/bloc/moods_state.dart';

class RiskAlertPage extends StatefulWidget {
  const RiskAlertPage({super.key});

  @override
  State<RiskAlertPage> createState() => _RiskAlertPageState();
}

class _RiskAlertPageState extends State<RiskAlertPage> {
  final GeminiService _geminiService = GeminiService();
  Map<String, dynamic>? _riskAssessment;
  bool _isLoading = true;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _loadRiskAssessment();
  }

  Future<void> _loadRiskAssessment() async {
    setState(() {
      _isLoading = true;
      _hasError = false;
    });

    try {
      // Gather all health data from blocs
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
      final assessment = await _geminiService.generateRiskAssessment(
        pregnancyWeek: 20, // TODO: Get from user profile
        vitalsData: vitalsData,
        recentSymptoms: recentSymptoms,
        recentLabs: recentLabs,
        moodCounts: moodCounts,
      );

      setState(() {
        _riskAssessment = assessment;
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading risk assessment: $e');
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

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: const Color(0xFFFAF0FF),
      appBar: AppBar(
        title: const Text('Health Risk Assessment'),
        backgroundColor: const Color(0xFF7B4BA6),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadRiskAssessment,
            tooltip: 'Refresh Assessment',
          ),
        ],
      ),
      body: _isLoading
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    color: Color(0xFF7B4BA6),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Analyzing your health data...',
                    style: TextStyle(color: Color(0xFF7B4BA6)),
                  ),
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
                      const Text('Unable to assess risk'),
                      const SizedBox(height: 8),
                      ElevatedButton.icon(
                        onPressed: _loadRiskAssessment,
                        icon: const Icon(Icons.refresh),
                        label: const Text('Retry'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF7B4BA6),
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ],
                  ),
                )
              : _buildRiskAssessment(l10n),
    );
  }

  Widget _buildRiskAssessment(AppLocalizations l10n) {
    if (_riskAssessment == null) {
      return const Center(child: Text('No assessment available'));
    }

    final riskLevel = (_riskAssessment!['riskLevel']?.toString() ?? 'none').isEmpty ? 'none' : _riskAssessment!['riskLevel'].toString();
    final primaryConcern = (_riskAssessment!['primaryConcern']?.toString() ?? 'No significant concerns').isEmpty ? 'No significant concerns' : _riskAssessment!['primaryConcern'].toString();
    final patterns = _riskAssessment!['detectedPatterns'] as List<dynamic>? ?? [];
    final recommendations = _riskAssessment!['recommendations'] as List<dynamic>? ?? [];
    final urgency = (_riskAssessment!['urgency']?.toString() ?? 'Monitor').isEmpty ? 'Monitor' : _riskAssessment!['urgency'].toString();
    final reasoning = (_riskAssessment!['reasoning']?.toString() ?? 'No assessment details available').isEmpty ? 'No assessment details available' : _riskAssessment!['reasoning'].toString();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Risk Level Card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
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
                  size: 64,
                  color: _getRiskColor(riskLevel),
                ),
                const SizedBox(height: 12),
                Text(
                  riskLevel.toUpperCase() + ' RISK',
                  style: AppTextStyles.headline2.copyWith(
                    color: _getRiskColor(riskLevel),
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  primaryConcern,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.body1.copyWith(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Urgency Banner
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
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
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'ACTION NEEDED',
                        style: AppTextStyles.body1.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        urgency,
                        style: AppTextStyles.body1.copyWith(
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
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
                      style: AppTextStyles.body1,
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
                  decoration: BoxDecoration(
                    color: const Color(0xFF7B4BA6),
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
                    style: AppTextStyles.body1,
                  ),
                ),
              ],
            ),
          )),

          const SizedBox(height: 24),

          // Reasoning
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
}
