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
  final int synced;

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
    this.synced = 0,
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
      'synced': synced,
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
          ? (map['normal_range_min'] as num).toDouble()
          : null,
      normalRangeMax: map['normal_range_max'] != null
          ? (map['normal_range_max'] as num).toDouble()
          : null,
      interpretation: map['interpretation'] as String?,
      labDate: _parseDate(map['lab_date']),
      reportImageUrl: map['report_image_url'] as String?,
      extractedByOcr: map['extracted_by_ocr'] is int 
          ? (map['extracted_by_ocr'] as int) == 1
          : map['extracted_by_ocr'] as bool? ?? false,
      createdAt: _parseDateTime(map['created_at']),
      synced: map['synced'] as int? ?? 0,
    );
  }

  static DateTime _parseDate(dynamic value) {
    if (value is DateTime) return value;
    if (value is String) {
      // Handle both full ISO8601 and date-only formats
      return DateTime.parse(value.split('T')[0]);
    }
    return DateTime.now();
  }

  static DateTime _parseDateTime(dynamic value) {
    if (value is DateTime) return value;
    if (value is String) {
      return DateTime.parse(value);
    }
    return DateTime.now();
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
    int? synced,
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
      synced: synced ?? this.synced,
    );
  }
}