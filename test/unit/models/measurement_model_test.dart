import 'package:flutter_test/flutter_test.dart';
import 'package:gestanea/core/database/models/measurement_model.dart';

void main() {
  group('MeasurementModel', () {
    final testDate = DateTime(2024, 6, 15, 10, 30);
    final createdDate = DateTime(2024, 6, 15, 10, 35);

    test('should create measurement with all fields', () {
      // Arrange & Act
      final measurement = MeasurementModel(
        id: 'measure_123',
        userId: 'user_456',
        weight: 65.5,
        heartRate: 75,
        systolic: 120,
        diastolic: 80,
        recordedAt: testDate,
        createdAt: createdDate,
      );

      // Assert
      expect(measurement.id, 'measure_123');
      expect(measurement.userId, 'user_456');
      expect(measurement.weight, 65.5);
      expect(measurement.heartRate, 75);
      expect(measurement.systolic, 120);
      expect(measurement.diastolic, 80);
      expect(measurement.recordedAt, testDate);
      expect(measurement.createdAt, createdDate);
    });

    test('should create measurement with partial fields', () {
      // Arrange & Act
      final measurement = MeasurementModel(
        id: 'measure_partial',
        userId: 'user_456',
        weight: 66.0,
        heartRate: null,
        systolic: null,
        diastolic: null,
        recordedAt: testDate,
        createdAt: createdDate,
      );

      // Assert
      expect(measurement.weight, 66.0);
      expect(measurement.heartRate, null);
      expect(measurement.systolic, null);
      expect(measurement.diastolic, null);
    });

    test('should convert to JSON correctly', () {
      // Arrange
      final measurement = MeasurementModel(
        id: 'measure_123',
        userId: 'user_456',
        weight: 65.5,
        heartRate: 75,
        systolic: 120,
        diastolic: 80,
        recordedAt: testDate,
        createdAt: createdDate,
      );

      // Act
      final json = measurement.toMap();

      // Assert
      expect(json['id'], 'measure_123');
      expect(json['user_id'], 'user_456');
      expect(json['weight'], 65.5);
      expect(json['heart_rate'], 75);
      expect(json['systolic'], 120);
      expect(json['diastolic'], 80);
      expect(json['recorded_at'], testDate.toIso8601String());
      expect(json['created_at'], createdDate.toIso8601String());
    });

    test('should create from JSON correctly', () {
      // Arrange
      final json = {
        'id': 'measure_123',
        'user_id': 'user_456',
        'weight': 65.5,
        'heart_rate': 75,
        'systolic': 120,
        'diastolic': 80,
        'recorded_at': testDate.toIso8601String(),
        'created_at': createdDate.toIso8601String(),
      };

      // Act
      final measurement = MeasurementModel.fromMap(json);

      // Assert
      expect(measurement.id, 'measure_123');
      expect(measurement.userId, 'user_456');
      expect(measurement.weight, 65.5);
      expect(measurement.heartRate, 75);
      expect(measurement.systolic, 120);
      expect(measurement.diastolic, 80);
    });

    test('should handle null optional fields in JSON', () {
      // Arrange
      final json = {
        'id': 'measure_partial',
        'user_id': 'user_456',
        'weight': 66.0,
        'heart_rate': null,
        'systolic': null,
        'diastolic': null,
        'recorded_at': testDate.toIso8601String(),
        'created_at': createdDate.toIso8601String(),
      };

      // Act
      final measurement = MeasurementModel.fromMap(json);

      // Assert
      expect(measurement.weight, 66.0);
      expect(measurement.heartRate, null);
      expect(measurement.systolic, null);
      expect(measurement.diastolic, null);
    });

    test('should create copy with updated fields', () {
      // Arrange
      final original = MeasurementModel(
        id: 'measure_123',
        userId: 'user_456',
        weight: 65.5,
        heartRate: 75,
        systolic: 120,
        diastolic: 80,
        recordedAt: testDate,
        createdAt: createdDate,
      );

      // Act
      final updated = original.copyWith(weight: 66.0, heartRate: 78);

      // Assert
      expect(updated.id, original.id);
      expect(updated.userId, original.userId);
      expect(updated.weight, 66.0);
      expect(updated.heartRate, 78);
      expect(updated.systolic, original.systolic);
      expect(updated.diastolic, original.diastolic);
    });

    test('should compare measurements correctly', () {
      // Arrange
      final measurement1 = MeasurementModel(
        id: 'measure_123',
        userId: 'user_456',
        weight: 65.5,
        heartRate: 75,
        systolic: 120,
        diastolic: 80,
        recordedAt: testDate,
        createdAt: createdDate,
      );

      final measurement2 = MeasurementModel(
        id: 'measure_123',
        userId: 'user_456',
        weight: 65.5,
        heartRate: 75,
        systolic: 120,
        diastolic: 80,
        recordedAt: testDate,
        createdAt: createdDate,
      );

      final measurement3 = MeasurementModel(
        id: 'measure_789',
        userId: 'user_456',
        weight: 66.0,
        heartRate: 78,
        systolic: 118,
        diastolic: 79,
        recordedAt: testDate,
        createdAt: createdDate,
      );

      // Assert - Since MeasurementModel doesn't override ==, these are different objects
      expect(measurement1 == measurement2, false);
      expect(measurement1 == measurement3, false);
      // Compare fields instead
      expect(measurement1.id, measurement2.id);
      expect(measurement1.weight, measurement2.weight);
      expect(measurement1.heartRate, measurement2.heartRate);
    });

    group('Weight Tracking', () {
      test('should handle different weight values', () {
        // Arrange
        final weights = [50.0, 60.5, 70.3, 80.0, 90.5, 100.0];

        // Act & Assert
        for (var weight in weights) {
          final measurement = MeasurementModel(
            id: 'measure_${weight}',
            userId: 'user_456',
            weight: weight,
            heartRate: null,
            systolic: null,
            diastolic: null,
            recordedAt: testDate,
            createdAt: createdDate,
          );

          expect(measurement.weight, weight);
        }
      });

      test('should track weight changes over time', () {
        // Arrange
        final measurements = [
          MeasurementModel(
            id: 'measure_1',
            userId: 'user_456',
            weight: 65.0,
            heartRate: null,
            systolic: null,
            diastolic: null,
            recordedAt: DateTime(2024, 6, 1),
            createdAt: DateTime(2024, 6, 1),
          ),
          MeasurementModel(
            id: 'measure_2',
            userId: 'user_456',
            weight: 66.5,
            heartRate: null,
            systolic: null,
            diastolic: null,
            recordedAt: DateTime(2024, 6, 15),
            createdAt: DateTime(2024, 6, 15),
          ),
          MeasurementModel(
            id: 'measure_3',
            userId: 'user_456',
            weight: 68.0,
            heartRate: null,
            systolic: null,
            diastolic: null,
            recordedAt: DateTime(2024, 6, 30),
            createdAt: DateTime(2024, 6, 30),
          ),
        ];

        // Assert
        expect(measurements[0].weight, 65.0);
        expect(measurements[1].weight, 66.5);
        expect(measurements[2].weight, 68.0);
        expect(measurements[2].weight! > measurements[0].weight!, true);
      });
    });

    group('Heart Rate', () {
      test('should handle different heart rate values', () {
        // Arrange
        final heartRates = [60, 72, 85, 95, 110];

        // Act & Assert
        for (var heartRate in heartRates) {
          final measurement = MeasurementModel(
            id: 'measure_hr_$heartRate',
            userId: 'user_456',
            weight: 65.0,
            heartRate: heartRate,
            systolic: null,
            diastolic: null,
            recordedAt: testDate,
            createdAt: createdDate,
          );

          expect(measurement.heartRate, heartRate);
        }
      });

      test('should identify resting vs elevated heart rate', () {
        // Arrange
        final restingHR = MeasurementModel(
          id: 'measure_resting',
          userId: 'user_456',
          weight: 65.0,
          heartRate: 70,
          systolic: null,
          diastolic: null,
          recordedAt: testDate,
          createdAt: createdDate,
        );

        final elevatedHR = MeasurementModel(
          id: 'measure_elevated',
          userId: 'user_456',
          weight: 65.0,
          heartRate: 110,
          systolic: null,
          diastolic: null,
          recordedAt: testDate,
          createdAt: createdDate,
        );

        // Assert
        expect(restingHR.heartRate! < 100, true);
        expect(elevatedHR.heartRate! >= 100, true);
      });
    });

    group('Blood Pressure', () {
      test('should handle blood pressure measurements', () {
        // Arrange & Act
        final normalBP = MeasurementModel(
          id: 'measure_normal_bp',
          userId: 'user_456',
          weight: 65.0,
          heartRate: 75,
          systolic: 120,
          diastolic: 80,
          recordedAt: testDate,
          createdAt: createdDate,
        );

        final highBP = MeasurementModel(
          id: 'measure_high_bp',
          userId: 'user_456',
          weight: 65.0,
          heartRate: 75,
          systolic: 140,
          diastolic: 90,
          recordedAt: testDate,
          createdAt: createdDate,
        );

        final lowBP = MeasurementModel(
          id: 'measure_low_bp',
          userId: 'user_456',
          weight: 65.0,
          heartRate: 75,
          systolic: 100,
          diastolic: 65,
          recordedAt: testDate,
          createdAt: createdDate,
        );

        // Assert
        expect(normalBP.systolic, 120);
        expect(normalBP.diastolic, 80);
        expect(highBP.systolic, greaterThan(normalBP.systolic!));
        expect(lowBP.systolic, lessThan(normalBP.systolic!));
      });

      test('should validate blood pressure relationship', () {
        // Arrange
        final measurement = MeasurementModel(
          id: 'measure_bp',
          userId: 'user_456',
          weight: 65.0,
          heartRate: 75,
          systolic: 120,
          diastolic: 80,
          recordedAt: testDate,
          createdAt: createdDate,
        );

        // Assert - Systolic should always be higher than diastolic
        expect(measurement.systolic, greaterThan(measurement.diastolic!));
      });

      test('should handle only systolic measurement', () {
        // Arrange
        final measurement = MeasurementModel(
          id: 'measure_systolic_only',
          userId: 'user_456',
          weight: 65.0,
          heartRate: 75,
          systolic: 120,
          diastolic: null,
          recordedAt: testDate,
          createdAt: createdDate,
        );

        // Assert
        expect(measurement.systolic, 120);
        expect(measurement.diastolic, null);
      });
    });

    group('Complete Measurements', () {
      test('should identify complete vs partial measurements', () {
        // Arrange
        final completeMeasurement = MeasurementModel(
          id: 'measure_complete',
          userId: 'user_456',
          weight: 65.5,
          heartRate: 75,
          systolic: 120,
          diastolic: 80,
          recordedAt: testDate,
          createdAt: createdDate,
        );

        final partialMeasurement = MeasurementModel(
          id: 'measure_partial',
          userId: 'user_456',
          weight: 65.5,
          heartRate: null,
          systolic: null,
          diastolic: null,
          recordedAt: testDate,
          createdAt: createdDate,
        );

        // Assert
        expect(completeMeasurement.heartRate != null, true);
        expect(completeMeasurement.systolic != null, true);
        expect(completeMeasurement.diastolic != null, true);

        expect(partialMeasurement.heartRate == null, true);
        expect(partialMeasurement.systolic == null, true);
        expect(partialMeasurement.diastolic == null, true);
      });
    });

    group('Time-based Measurements', () {
      test('should track measurements chronologically', () {
        // Arrange
        final measurements = [
          MeasurementModel(
            id: 'measure_1',
            userId: 'user_456',
            weight: 65.0,
            heartRate: 75,
            systolic: 120,
            diastolic: 80,
            recordedAt: DateTime(2024, 6, 1),
            createdAt: DateTime(2024, 6, 1),
          ),
          MeasurementModel(
            id: 'measure_2',
            userId: 'user_456',
            weight: 66.0,
            heartRate: 76,
            systolic: 118,
            diastolic: 79,
            recordedAt: DateTime(2024, 6, 15),
            createdAt: DateTime(2024, 6, 15),
          ),
          MeasurementModel(
            id: 'measure_3',
            userId: 'user_456',
            weight: 67.0,
            heartRate: 77,
            systolic: 119,
            diastolic: 78,
            recordedAt: DateTime(2024, 6, 30),
            createdAt: DateTime(2024, 6, 30),
          ),
        ];

        // Assert
        expect(
          measurements[0].recordedAt.isBefore(measurements[1].recordedAt),
          true,
        );
        expect(
          measurements[1].recordedAt.isBefore(measurements[2].recordedAt),
          true,
        );
      });
    });
  });
}
