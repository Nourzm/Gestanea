/// Parsed result of the `analyze-lab` Edge Function (Claude lab interpretation).
class LabAiResult {
  final List<LabAiTest> tests;
  final String overallSummary;
  final bool redFlag;
  final String redFlagMessage;
  final List<String> guidance;
  final String disclaimer;

  const LabAiResult({
    required this.tests,
    required this.overallSummary,
    required this.redFlag,
    required this.redFlagMessage,
    required this.guidance,
    required this.disclaimer,
  });

  factory LabAiResult.fromJson(Map<String, dynamic> json) {
    return LabAiResult(
      tests: ((json['tests'] as List?) ?? const [])
          .map((e) => LabAiTest.fromJson(e as Map<String, dynamic>))
          .toList(),
      overallSummary: (json['overallSummary'] as String?) ?? '',
      redFlag: (json['redFlag'] as bool?) ?? false,
      redFlagMessage: (json['redFlagMessage'] as String?) ?? '',
      guidance: ((json['guidance'] as List?) ?? const [])
          .map((e) => e.toString())
          .toList(),
      disclaimer: (json['disclaimer'] as String?) ?? '',
    );
  }
}

class LabAiTest {
  final String testName;
  final String value;
  final String unit;
  final String referenceRange;
  final String status; // normal | low | high | borderline | unknown
  final String explanation;

  const LabAiTest({
    required this.testName,
    required this.value,
    required this.unit,
    required this.referenceRange,
    required this.status,
    required this.explanation,
  });

  factory LabAiTest.fromJson(Map<String, dynamic> json) {
    return LabAiTest(
      testName: (json['testName'] as String?) ?? '',
      value: (json['value'] as String?) ?? '',
      unit: (json['unit'] as String?) ?? '',
      referenceRange: (json['referenceRange'] as String?) ?? '',
      status: (json['status'] as String?) ?? 'unknown',
      explanation: (json['explanation'] as String?) ?? '',
    );
  }
}
