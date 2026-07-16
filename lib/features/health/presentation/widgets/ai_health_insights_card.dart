import 'package:flutter/material.dart';
import 'package:gestanea/core/constants/app_colors.dart';
import 'package:gestanea/core/constants/app_text_styles.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../core/services/gemini_service.dart';

class AIHealthInsightsCard extends StatefulWidget {
  final Map<String, dynamic> healthData;
  final String insightType; // 'vitals', 'symptoms', 'moods', 'lab'
  final String language;

  const AIHealthInsightsCard({
    super.key,
    required this.healthData,
    required this.insightType,
    required this.language,
  });

  @override
  State<AIHealthInsightsCard> createState() => _AIHealthInsightsCardState();
}

class _AIHealthInsightsCardState extends State<AIHealthInsightsCard> {
  final GeminiService _geminiService = GeminiService();
  Map<String, String>? _insights;
  bool _isLoading = true;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _loadInsights();
  }

  Future<void> _loadInsights() async {
    setState(() {
      _isLoading = true;
      _hasError = false;
    });

    try {
      Map<String, String> insights;

      switch (widget.insightType) {
        case 'vitals':
          insights = await _geminiService.generateVitalsInsights(
            currentWeight: widget.healthData['currentWeight'] as double?,
            previousWeight: widget.healthData['previousWeight'] as double?,
            heartRate: widget.healthData['heartRate'] as int?,
            systolic: widget.healthData['systolic'] as int?,
            diastolic: widget.healthData['diastolic'] as int?,
            pregnancyWeek: widget.healthData['pregnancyWeek'] as int? ?? 20,
            language: widget.language,
          );
          break;

        case 'symptoms':
          insights = await _geminiService.generateSymptomsInsights(
            recentSymptoms: widget.healthData['symptoms'] as List<Map<String, dynamic>>? ?? [],
            pregnancyWeek: widget.healthData['pregnancyWeek'] as int? ?? 20,
            language: widget.language,
          );
          break;

        case 'moods':
          insights = await _geminiService.generateMoodInsights(
            moodCounts: widget.healthData['moodCounts'] as Map<String, int>? ?? {},
            pregnancyWeek: widget.healthData['pregnancyWeek'] as int? ?? 20,
            language: widget.language,
          );
          break;

        case 'lab':
          insights = await _geminiService.generateLabResultsInsights(
            recentLabs: widget.healthData['labResults'] as List<Map<String, dynamic>>? ?? [],
            pregnancyWeek: widget.healthData['pregnancyWeek'] as int? ?? 20,
            language: widget.language,
          );
          break;

        default:
          insights = {
            'message': 'Keep tracking your health!',
            'tip1': 'Stay consistent',
            'tip2': 'Consult your doctor regularly',
          };
      }

      setState(() {
        _insights = insights;
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading AI insights: $e');
      setState(() {
        _hasError = true;
        _isLoading = false;
        _insights = {
          'message': 'Keep monitoring your health regularly!',
          'tip1': 'Stay hydrated throughout the day',
          'tip2': 'Get adequate rest and sleep',
        };
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFE8D5F2), Color(0xFFF3E5FF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with AI badge
          Row(
            children: [
              const Icon(
                Icons.auto_awesome,
                color: Color(0xFF7B4BA6),
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'Personalized Health Insights',
                style: AppTextStyles.body1.copyWith(
                  color: const Color(0xFF7B4BA6),
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Main message
          if (_isLoading)
            _buildLoadingShimmer()
          else if (_insights != null) ...[
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.7),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.lightbulb_outline,
                    color: Color(0xFF7B4BA6),
                    size: 18,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      _insights!['message']!,
                      style: AppTextStyles.body1.copyWith(
                        color: const Color(0xFF7B4BA6),
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // Tips
            Text(
              'Self-Care Tips:',
              style: AppTextStyles.body1.copyWith(
                color: const Color(0xFF7B4BA6),
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 8),

            _buildTipRow(Icons.check_circle_outline, _insights!['tip1']!),
            const SizedBox(height: 6),
            _buildTipRow(Icons.check_circle_outline, _insights!['tip2']!),

            const SizedBox(height: 12),

            // Disclaimer
            Text(
              '⚠️ AI-generated insights. Not medical advice. Consult your healthcare provider for concerns.',
              style: AppTextStyles.body1.copyWith(
                color: const Color(0xFF7B4BA6),
                fontSize: 9,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTipRow(IconData icon, String tip) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          color: const Color(0xFF7B4BA6),
          size: 16,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            tip,
            style: AppTextStyles.body1.copyWith(
              color: const Color(0xFF7B4BA6),
              fontSize: 12,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLoadingShimmer() {
    return Shimmer.fromColors(
      baseColor: Colors.white.withValues(alpha: 0.5),
      highlightColor: Colors.white.withValues(alpha: 0.8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 50,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          const SizedBox(height: 12),
          Container(
            height: 12,
            width: 100,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(6),
            ),
          ),
          const SizedBox(height: 8),
          Container(
            height: 16,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          const SizedBox(height: 6),
          Container(
            height: 16,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ],
      ),
    );
  }
}
