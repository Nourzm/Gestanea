import 'package:flutter_test/flutter_test.dart';
import 'package:gestanea/core/database/models/pregnancy_model.dart';

void main() {
  group('PregnancyModel', () {
    late DateTime testDate;
    late PregnancyModel testPregnancy;

    setUp(() {
      testDate = DateTime(2024, 1, 1);
      testPregnancy = PregnancyModel(
        id: 'pregnancy123',
        userId: 'user123',
        lmpDate: testDate,
        dueDate: testDate.add(const Duration(days: 280)),
        currentWeek: 12,
        currentTrimester: 'First',
        isActive: true,
        medicalConditions: 'None',
        createdAt: testDate,
        updatedAt: testDate,
      );
    });

    test('toMap should convert model to map correctly', () {
      final map = testPregnancy.toMap();

      expect(map['id'], 'pregnancy123');
      expect(map['user_id'], 'user123');
      expect(map['lmp_date'], '2024-01-01');
      expect(map['due_date'], '2024-10-07');
      expect(map['current_week'], 12);
      expect(map['current_trimester'], 'First');
      expect(map['is_active'], 1);
      expect(map['medical_conditions'], 'None');
    });

    test('fromMap should create model from map correctly', () {
      final map = {
        'id': 'pregnancy456',
        'user_id': 'user456',
        'lmp_date': '2024-02-15',
        'due_date': '2024-11-22',
        'current_week': 20,
        'current_trimester': 'Second',
        'is_active': 1,
        'medical_conditions': 'Gestational diabetes',
        'created_at': '2024-02-15T10:00:00.000',
        'updated_at': '2024-02-15T10:00:00.000',
      };

      final pregnancy = PregnancyModel.fromMap(map);

      expect(pregnancy.id, 'pregnancy456');
      expect(pregnancy.userId, 'user456');
      expect(pregnancy.lmpDate, DateTime(2024, 2, 15));
      expect(pregnancy.dueDate, DateTime(2024, 11, 22));
      expect(pregnancy.currentWeek, 20);
      expect(pregnancy.currentTrimester, 'Second');
      expect(pregnancy.isActive, true);
      expect(pregnancy.medicalConditions, 'Gestational diabetes');
    });

    test('fromMap should handle inactive pregnancy', () {
      final map = {
        'id': 'pregnancy789',
        'user_id': 'user789',
        'lmp_date': '2023-01-01',
        'due_date': '2023-10-08',
        'current_week': null,
        'current_trimester': null,
        'is_active': 0,
        'medical_conditions': null,
        'created_at': '2023-01-01T00:00:00.000',
        'updated_at': '2023-10-15T00:00:00.000',
      };

      final pregnancy = PregnancyModel.fromMap(map);

      expect(pregnancy.isActive, false);
      expect(pregnancy.currentWeek, null);
      expect(pregnancy.currentTrimester, null);
      expect(pregnancy.medicalConditions, null);
    });

    test('toMap and fromMap should be reversible', () {
      final map = testPregnancy.toMap();
      final recovered = PregnancyModel.fromMap(map);

      expect(recovered.id, testPregnancy.id);
      expect(recovered.userId, testPregnancy.userId);
      expect(recovered.lmpDate.year, testPregnancy.lmpDate.year);
      expect(recovered.lmpDate.month, testPregnancy.lmpDate.month);
      expect(recovered.lmpDate.day, testPregnancy.lmpDate.day);
      expect(recovered.isActive, testPregnancy.isActive);
    });

    test('should handle edge case with far future due date', () {
      final futurePregnancy = PregnancyModel(
        id: 'p1',
        userId: 'u1',
        lmpDate: DateTime(2025, 12, 31),
        dueDate: DateTime(2026, 10, 6),
        isActive: true,
        createdAt: DateTime(2025, 12, 31),
        updatedAt: DateTime(2025, 12, 31),
      );

      final map = futurePregnancy.toMap();
      final recovered = PregnancyModel.fromMap(map);

      expect(recovered.dueDate.year, 2026);
      expect(recovered.dueDate.month, 10);
      expect(recovered.dueDate.day, 6);
    });
  });
}
