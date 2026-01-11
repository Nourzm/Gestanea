import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';


class GeminiService {
  static String get _apiKey => dotenv.env['GEMINI_API_KEY'] ?? ''; // TODO: Move to .env
  static const String _model = 'gemini-1.5-flash';
  
  late final GenerativeModel _gemini;
  
  // Cache keys
  static const String _cacheKeyVitals = 'gemini_cache_vitals';
  static const String _cacheKeySymptoms = 'gemini_cache_symptoms';
  static const String _cacheKeyMoods = 'gemini_cache_moods';
  static const String _cacheKeyLabResults = 'gemini_cache_lab';
  
  // Cache duration: 6 hours
  static const Duration _cacheDuration = Duration(hours: 6);
  
  GeminiService() {
    _gemini = GenerativeModel(
      model: _model,
      apiKey: _apiKey,
      generationConfig: GenerationConfig(
        temperature: 0.7,
        maxOutputTokens: 200,
      ),
    );
  }
  
  /// Generate personalized vitals insights
  Future<Map<String, String>> generateVitalsInsights({
    required double? currentWeight,
    required double? previousWeight,
    required int? heartRate,
    required int? systolic,
    required int? diastolic,
    required int pregnancyWeek,
    required String language,
  }) async {
    final cacheKey = _cacheKeyVitals;
    
    // Check cache first
    final cached = await _getCachedResponse(cacheKey);
    if (cached != null) {
      return cached;
    }
    
    // Calculate weight change
    final weightChange = currentWeight != null && previousWeight != null 
        ? currentWeight - previousWeight 
        : null;
    final weightTrend = weightChange != null 
        ? (weightChange > 0 ? 'gained ${weightChange.toStringAsFixed(1)}kg' : 'lost ${(-weightChange).toStringAsFixed(1)}kg')
        : 'stable';
    
    // Analyze BP status
    String bpStatus = 'normal';
    if (systolic != null && diastolic != null) {
      if (systolic > 140 || diastolic > 90) bpStatus = 'elevated';
      else if (systolic < 90 || diastolic < 60) bpStatus = 'low';
    }
    
    // Analyze heart rate
    String hrStatus = 'normal';
    if (heartRate != null) {
      if (heartRate > 100) hrStatus = 'elevated';
      else if (heartRate < 60) hrStatus = 'low';
    }
    
    final prompt = '''
You are a pregnancy health expert. Analyze these EXACT vitals and provide SPECIFIC self-care tips.

ACTUAL MEASUREMENTS:
- Pregnancy: Week $pregnancyWeek
- Weight: ${currentWeight ?? 'N/A'}kg (${previousWeight != null ? weightTrend : 'first measurement'})
- Heart Rate: ${heartRate ?? 'N/A'}bpm ($hrStatus range for pregnancy)
- Blood Pressure: ${systolic ?? 'N/A'}/${diastolic ?? 'N/A'} mmHg ($bpStatus)

CRITICAL RULES:
1. Message MUST comment on the ACTUAL numbers shown above (weight change, BP level, HR level)
2. Tip1 MUST address the PRIMARY concern in their vitals (BP if elevated/low, weight if changing fast, HR if abnormal)
3. Tip2 MUST address the SECONDARY concern or support the first tip
4. DO NOT give generic pregnancy tips - ONLY tips directly tied to their measurements

BAD (generic): "Stay hydrated, Get enough rest"
GOOD (specific): "Reduce salt for elevated BP, Limit caffeine for high heart rate"

Format as JSON:
{
  "message": "Comment on their actual weight/BP/HR numbers",
  "tip1": "Specific action for their PRIMARY vital concern",
  "tip2": "Specific action for their SECONDARY vital concern"
}

EXAMPLES:

IF weight +3kg in short time, BP 145/92 HIGH, HR 105 HIGH:
{
  "message": "Rapid 3kg gain with elevated BP and heart rate",
  "tip1": "Cut salt and processed foods for blood pressure",
  "tip2": "Reduce caffeine, rest more for heart rate"
}

IF weight stable, BP 110/70 normal, HR 72 normal:
{
  "message": "Excellent stable weight and normal vitals",
  "tip1": "Keep current diet maintaining these good vitals",
  "tip2": "Continue regular prenatal exercise routine"
}

IF weight -1kg lost, BP 85/55 LOW, HR 58 LOW:
{
  "message": "Weight loss with low BP and heart rate - needs attention",
  "tip1": "Increase calorie intake, eat more frequently",
  "tip2": "Stay hydrated, rise slowly to prevent dizziness"
}

Now analyze THEIR specific vitals!
''';
    
    try {
      final response = await _gemini.generateContent([Content.text(prompt)]);
      final text = response.text ?? '{}';
      
      // Extract JSON from response
      final jsonMatch = RegExp(r'\{[\s\S]*\}').firstMatch(text);
      if (jsonMatch != null) {
        final jsonStr = jsonMatch.group(0)!;
        final Map<String, dynamic> data = json.decode(jsonStr);
        final result = {
          'message': data['message'] as String? ?? 'Keep up the great work!',
          'tip1': data['tip1'] as String? ?? 'Stay hydrated',
          'tip2': data['tip2'] as String? ?? 'Get enough rest',
        };
        
        // Cache the response
        await _cacheResponse(cacheKey, result);
        return result;
      }
    } catch (e) {
      print('Gemini API error: $e');
    }
    
    // Fallback
    return {
      'message': 'Keep monitoring your health regularly!',
      'tip1': 'Stay hydrated throughout the day',
      'tip2': 'Get adequate rest and sleep',
    };
  }
  
  /// Generate personalized symptoms insights
  Future<Map<String, String>> generateSymptomsInsights({
    required List<Map<String, dynamic>> recentSymptoms,
    required int pregnancyWeek,
    required String language,
  }) async {
    final cacheKey = _cacheKeySymptoms;
    
    final cached = await _getCachedResponse(cacheKey);
    if (cached != null) {
      return cached;
    }
    
    // Analyze symptom patterns
    final symptomsList = recentSymptoms.map((s) => 
      '${s['name']} (${s['severity']}, ${s['duration'] ?? 'N/A'})').join(', ');
    
    final severeCounts = recentSymptoms.where((s) => 
      s['severity']?.toString().toLowerCase() == 'severe').length;
    final hasNausea = recentSymptoms.any((s) => 
      s['name']?.toString().toLowerCase().contains('nausea') ?? false);
    final hasHeadache = recentSymptoms.any((s) => 
      s['name']?.toString().toLowerCase().contains('headache') ?? false);
    final hasSwelling = recentSymptoms.any((s) => 
      s['name']?.toString().toLowerCase().contains('swell') ?? false);
    
    final prompt = '''
You are a pregnancy health expert. Provide SPECIFIC self-care for these EXACT symptoms.

ACTUAL SYMPTOMS (Week $pregnancyWeek):
$symptomsList

PATTERN DETECTED:
- Severe symptoms: $severeCounts
- Has nausea: $hasNausea
- Has headache: $hasHeadache  
- Has swelling: $hasSwelling

CRITICAL RULES:
1. Message MUST mention the SPECIFIC symptoms listed above by name
2. Tip1 MUST give relief for the FIRST/MAIN symptom they have
3. Tip2 MUST give relief for the SECOND symptom or support first tip
4. DO NOT give generic pregnancy advice - ONLY remedies for their listed symptoms

BAD (generic): "Rest when needed, Stay hydrated"
GOOD (specific): "Ginger tea for nausea, Cold compress for headache"

Format as JSON:
{
  "message": "Acknowledge their SPECIFIC symptoms by name",
  "tip1": "Direct remedy for their PRIMARY symptom",
  "tip2": "Direct remedy for their SECONDARY symptom"
}

EXAMPLES:

IF has Morning Sickness (severe) + Fatigue (moderate):
{
  "message": "Severe morning sickness with fatigue is challenging",
  "tip1": "Eat crackers before rising, try ginger for nausea",
  "tip2": "Take short naps, rest when fatigue hits"
}

IF has Back Pain (mild) + Leg Cramps (moderate) + Swelling (mild):
{
  "message": "Back pain and leg cramps with mild swelling detected",
  "tip1": "Prenatal massage, warm compress for back pain",
  "tip2": "Stretch calves, magnesium for leg cramps"
}

IF has Headache (severe):
{
  "message": "Severe headache needs attention",
  "tip1": "Rest in dark room, cold compress on forehead",
  "tip2": "Stay hydrated, if persistent see doctor"
}

Now address THEIR specific symptoms!
''';
    
    try {
      final response = await _gemini.generateContent([Content.text(prompt)]);
      final text = response.text ?? '{}';
      
      final jsonMatch = RegExp(r'\{[\s\S]*\}').firstMatch(text);
      if (jsonMatch != null) {
        final jsonStr = jsonMatch.group(0)!;
        final Map<String, dynamic> data = json.decode(jsonStr);
        final result = {
          'message': data['message'] as String? ?? 'Track your symptoms daily',
          'tip1': data['tip1'] as String? ?? 'Rest when needed',
          'tip2': data['tip2'] as String? ?? 'Stay comfortable',
        };
        
        await _cacheResponse(cacheKey, result);
        return result;
      }
    } catch (e) {
      print('Gemini API error: $e');
    }
    
    return {
      'message': 'Common pregnancy symptoms - you\'re doing great!',
      'tip1': 'Rest and elevate your feet when tired',
      'tip2': 'Stay hydrated and eat small meals',
    };
  }
  
  /// Generate personalized mood insights
  Future<Map<String, String>> generateMoodInsights({
    required Map<String, int> moodCounts,
    required int pregnancyWeek,
    required String language,
  }) async {
    final cacheKey = _cacheKeyMoods;
    
    final cached = await _getCachedResponse(cacheKey);
    if (cached != null) {
      return cached;
    }
    
    final moodSummary = moodCounts.entries
      .map((e) => '${e.key}: ${e.value} times')
      .join(', ');
    
    // Analyze mood patterns
    final totalMoods = moodCounts.values.fold(0, (sum, count) => sum + count);
    final positiveMoods = (moodCounts['Great'] ?? 0) + (moodCounts['Good'] ?? 0);
    final negativeMoods = (moodCounts['Terrible'] ?? 0) + (moodCounts['Bad'] ?? 0);
    final positivePercent = totalMoods > 0 ? ((positiveMoods / totalMoods) * 100).round() : 0;
    final mostCommon = moodCounts.entries.isNotEmpty 
        ? moodCounts.entries.reduce((a, b) => a.value > b.value ? a : b).key
        : 'varied';
    
    final prompt = '''
You are a pregnancy mental health expert. Provide SPECIFIC emotional support for this EXACT mood pattern.

ACTUAL MOOD DATA (Week $pregnancyWeek):
$moodSummary
Total: $totalMoods entries | Positive: $positivePercent% | Most common: $mostCommon

CRITICAL RULES:
1. Message MUST describe their SPECIFIC mood pattern (mostly positive/negative/mixed, what's most common)
2. Tip1 MUST give advice tailored to THEIR pattern (if struggling→seek help, if positive→maintain, if mixed→identify triggers)
3. Tip2 MUST complement first tip with specific emotional strategy
4. DO NOT give generic mental health tips - ONLY relevant to their mood distribution

BAD (generic): "Practice self-care, Connect with others"
GOOD (specific to pattern): "Journal to identify bad mood triggers, Maintain routines from your great days"

Format as JSON:
{
  "message": "Describe their SPECIFIC mood pattern/distribution",
  "tip1": "Strategy for THEIR specific pattern",
  "tip2": "Supporting strategy for THEIR pattern"
}

EXAMPLES:

IF Great:8, Good:5, Okay:2 (93% positive):
{
  "message": "Excellent mood stability with 93% positive entries!",
  "tip1": "Keep doing what's working - note your routines",
  "tip2": "Share your strategies with other expecting moms"
}

IF Okay:6, Bad:4, Terrible:3 (0% positive, struggling):
{
  "message": "Consistently low moods detected - this needs support",
  "tip1": "Talk to your doctor about pregnancy depression screening",
  "tip2": "Join pregnancy support group, don't face this alone"
}

IF Great:3, Okay:5, Bad:2 (mixed, mostly neutral):
{
  "message": "Mixed moods with neutral baseline - typical hormonal shifts",
  "tip1": "Journal when moods dip to identify triggers",
  "tip2": "Schedule activities from your great days regularly"
}

IF Terrible:7, Bad:8 (very negative):
{
  "message": "Predominant negative moods are concerning",
  "tip1": "Urgent: Discuss with healthcare provider immediately",
  "tip2": "Call pregnancy support hotline for immediate help"
}

Now analyze THEIR mood pattern!
''';
    
    try {
      final response = await _gemini.generateContent([Content.text(prompt)]);
      final text = response.text ?? '{}';
      
      final jsonMatch = RegExp(r'\{[\s\S]*\}').firstMatch(text);
      if (jsonMatch != null) {
        final jsonStr = jsonMatch.group(0)!;
        final Map<String, dynamic> data = json.decode(jsonStr);
        final result = {
          'message': data['message'] as String? ?? 'Your emotional wellbeing matters!',
          'tip1': data['tip1'] as String? ?? 'Connect with loved ones',
          'tip2': data['tip2'] as String? ?? 'Practice relaxation',
        };
        
        await _cacheResponse(cacheKey, result);
        return result;
      }
    } catch (e) {
      print('Gemini API error: $e');
    }
    
    return {
      'message': 'Tracking moods helps understand your wellbeing',
      'tip1': 'Take short walks for mood boost',
      'tip2': 'Practice deep breathing exercises',
    };
  }
  
  /// Generate personalized lab results insights
  Future<Map<String, String>> generateLabResultsInsights({
    required List<Map<String, dynamic>> recentLabs,
    required int pregnancyWeek,
    required String language,
  }) async {
    final cacheKey = _cacheKeyLabResults;
    
    final cached = await _getCachedResponse(cacheKey);
    if (cached != null) {
      return cached;
    }
    
    // Analyze lab values
    final labsList = recentLabs.map((lab) {
      final value = lab['value'];
      final min = lab['normalRangeMin'];
      final max = lab['normalRangeMax'];
      String status = 'normal';
      if (value != null && min != null && max != null) {
        if (value < min) status = 'LOW';
        else if (value > max) status = 'HIGH';
      }
      return '${lab['testName']}: ${value ?? 'N/A'} ${lab['unit'] ?? ''} ($status, range: ${min ?? '?'}-${max ?? '?'})';
    }).join('\n');
    
    final abnormalCount = recentLabs.where((lab) {
      final value = lab['value'];
      final min = lab['normalRangeMin'];
      final max = lab['normalRangeMax'];
      return value != null && min != null && max != null && 
             (value < min || value > max);
    }).length;
    
    final hasIronTest = recentLabs.any((lab) => 
      lab['testName']?.toString().toLowerCase().contains('iron') ?? false);
    final hasGlucoseTest = recentLabs.any((lab) => 
      lab['testName']?.toString().toLowerCase().contains('glucose') ?? false);
    
    final prompt = '''
You are a pregnancy health expert. Provide SPECIFIC nutrition/lifestyle advice for these EXACT lab results.

ACTUAL LAB RESULTS (Week $pregnancyWeek):
$labsList

DETECTED ISSUES:
- Abnormal values: $abnormalCount
- Has iron test: $hasIronTest
- Has glucose test: $hasGlucoseTest

CRITICAL RULES:
1. Message MUST comment on SPECIFIC test names and whether they're HIGH/LOW/normal
2. Tip1 MUST give dietary/lifestyle fix for the MAIN abnormal result (if low iron→iron foods, if high glucose→reduce sugar)
3. Tip2 MUST support first tip or address SECOND abnormal result
4. DO NOT give generic health tips - ONLY actions tied to their lab values

BAD (generic): "Eat balanced diet, Stay active"
GOOD (specific to labs): "Eat spinach and red meat for low hemoglobin, Take iron with vitamin C"

Format as JSON:
{
  "message": "Mention SPECIFIC test names and HIGH/LOW/normal status",
  "tip1": "Diet/lifestyle fix for PRIMARY abnormal result",
  "tip2": "Diet/lifestyle fix for SECONDARY result or support first"
}

EXAMPLES:

IF Hemoglobin:10.2 LOW, Iron:45 LOW, Glucose:92 normal:
{
  "message": "Low hemoglobin and iron detected, glucose normal",
  "tip1": "Eat iron-rich: red meat, spinach, lentils, beans daily",
  "tip2": "Take iron supplement with orange juice (vitamin C)"
}

IF Glucose:145 HIGH, HbA1c:6.8 HIGH:
{
  "message": "Elevated glucose and HbA1c - gestational diabetes risk",
  "tip1": "Cut sugar, white bread, juice - focus on vegetables",
  "tip2": "Walk 15min after meals to lower blood sugar"
}

IF Hemoglobin:12.5 normal, Platelets:180 normal, WBC:8.5 normal:
{
  "message": "All blood counts in healthy normal ranges",
  "tip1": "Maintain current prenatal vitamin routine",
  "tip2": "Keep balanced diet that's working well"
}

IF TSH:4.8 HIGH, Vitamin D:18 LOW:
{
  "message": "High thyroid hormone, low vitamin D needs correction",
  "tip1": "Get 15min morning sun for vitamin D daily",
  "tip2": "Discuss thyroid medication with doctor"
}

Now address THEIR specific lab results!
''';
    
    try {
      final response = await _gemini.generateContent([Content.text(prompt)]);
      final text = response.text ?? '{}';
      
      final jsonMatch = RegExp(r'\{[\s\S]*\}').firstMatch(text);
      if (jsonMatch != null) {
        final jsonStr = jsonMatch.group(0)!;
        final Map<String, dynamic> data = json.decode(jsonStr);
        final result = {
          'message': data['message'] as String? ?? 'Lab results look routine!',
          'tip1': data['tip1'] as String? ?? 'Maintain balanced diet',
          'tip2': data['tip2'] as String? ?? 'Stay consistent with checkups',
        };
        
        await _cacheResponse(cacheKey, result);
        return result;
      }
    } catch (e) {
      print('Gemini API error: $e');
    }
    
    return {
      'message': 'Keep tracking your lab results regularly!',
      'tip1': 'Maintain healthy nutrition and hydration',
      'tip2': 'Attend all scheduled checkups',
    };
  }
  
  /// Cache response to local storage
  Future<void> _cacheResponse(String key, Map<String, String> data) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cacheData = {
        'data': data,
        'timestamp': DateTime.now().toIso8601String(),
      };
      await prefs.setString(key, json.encode(cacheData));
    } catch (e) {
      print('Cache save error: $e');
    }
  }
  
  /// Get cached response if still valid
  Future<Map<String, String>?> _getCachedResponse(String key) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cached = prefs.getString(key);
      
      if (cached != null) {
        final cacheData = json.decode(cached);
        final timestamp = DateTime.parse(cacheData['timestamp'] as String);
        final age = DateTime.now().difference(timestamp);
        
        if (age < _cacheDuration) {
          return Map<String, String>.from(cacheData['data']);
        }
      }
    } catch (e) {
      print('Cache read error: $e');
    }
    
    return null;
  }
  
  /// Clear all cached insights (call on logout or settings change)
  Future<void> clearCache() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_cacheKeyVitals);
      await prefs.remove(_cacheKeySymptoms);
      await prefs.remove(_cacheKeyMoods);
      await prefs.remove(_cacheKeyLabResults);
    } catch (e) {
      print('Cache clear error: $e');
    }
  }
}
