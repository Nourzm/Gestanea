class LabResultModel {
  final String id;
  final String userId;
  final String testName;
  final double? value;
  final String?  unit;
  final double? normalRangeMin;
  final double? normalRangeMax;
  final String? interpretation;
  final DateTime labDate;
  final String? reportImageUrl;
  final bool extractedByOcr;
  final DateTime createdAt;

  LabResultModel({
    required this.id,
    required this.userId,
    required this.testName,
    this.value,
    this.unit,
    this.normalRangeMin,
    this.normalRangeMax,
    this.interpretation,
    required this.labDate,
    this.reportImageUrl,
    this.extractedByOcr = false,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'test_name': testName,
      'value': value,
      'unit': unit,
      'normal_range_min': normalRangeMin,
      'normal_range_max': normalRangeMax,
      'interpretation': interpretation,
      'lab_date': labDate.toIso8601String(). split('T')[0],
      'report_image_url': reportImageUrl,
      'extracted_by_ocr': extractedByOcr ?  1 : 0,
      'created_at': createdAt.toIso8601String(),
    };
  }

  factory LabResultModel.fromMap(Map<String, dynamic> map) {
    return LabResultModel(
      id: map['id'] as String,
      userId: map['user_id'] as String,
      testName: map['test_name'] as String,
      value: map['value'] != null ? (map['value'] as num).toDouble() : null,
      unit: map['unit'] as String?,
      normalRangeMin: map['normal_range_min'] != null
          ?  (map['normal_range_min'] as num).toDouble()
          : null,
      normalRangeMax: map['normal_range_max'] != null
          ? (map['normal_range_max'] as num).toDouble()
          : null,
      interpretation: map['interpretation'] as String?,
      labDate: DateTime.parse(map['lab_date'] as String),
      reportImageUrl: map['report_image_url'] as String?,
      extractedByOcr: (map['extracted_by_ocr'] as int) == 1,
      createdAt: DateTime. parse(map['created_at'] as String),
    );
  }

  LabResultModel copyWith({
    String? id,
    String? userId,
    String? testName,
    double? value,
    String? unit,
    double? normalRangeMin,
    double? normalRangeMax,
    String? interpretation,
    DateTime? labDate,
    String? reportImageUrl,
    bool? extractedByOcr,
    DateTime? createdAt,
  }) {
    return LabResultModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      testName: testName ??  this.testName,
      value: value ?? this.value,
      unit: unit ?? this.unit,
      normalRangeMin: normalRangeMin ?? this.normalRangeMin,
      normalRangeMax: normalRangeMax ?? this.normalRangeMax,
      interpretation: interpretation ?? this.interpretation,
      labDate: labDate ?? this.labDate,
      reportImageUrl: reportImageUrl ?? this. reportImageUrl,
      extractedByOcr: extractedByOcr ?? this.extractedByOcr,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}