import 'package:flutter_test/flutter_test.dart';
import 'package:gestanea/core/database/models/baby_model.dart';

void main() {
  group('BabyModel', () {
    late DateTime testDate;
    late BabyModel testBaby;

    setUp(() {
      testDate = DateTime(2024, 1, 1);
      testBaby = BabyModel(
        id: 'baby123',
        userId: 'user123',
        name: 'Sofia',
        gender: 'Female',
        dateOfBirth: testDate,
        birthWeight: 3.5,
        birthHeight: 50.0,
        themeColor: '#FF69B4',
        isActive: true,
        createdAt: testDate,
        updatedAt: testDate,
      );
    });

    test('toMap should convert model to map correctly', () {
      final map = testBaby.toMap();

      expect(map['id'], 'baby123');
      expect(map['user_id'], 'user123');
      expect(map['name'], 'Sofia');
      expect(map['gender'], 'Female');
      expect(map['date_of_birth'], '2024-01-01');
      expect(map['birth_weight'], 3.5);
      expect(map['birth_height'], 50.0);
      expect(map['theme_color'], '#FF69B4');
      expect(map['is_active'], 1);
    });

    test('fromMap should create model from map correctly', () {
      final map = {
        'id': 'baby456',
        'user_id': 'user456',
        'name': 'Adam',
        'gender': 'Male',
        'date_of_birth': '2024-06-15',
        'birth_weight': 3.8,
        'birth_height': 52.5,
        'theme_color': '#4169E1',
        'is_active': 1,
        'created_at': '2024-06-15T08:30:00.000',
        'updated_at': '2024-06-15T08:30:00.000',
      };

      final baby = BabyModel.fromMap(map);

      expect(baby.id, 'baby456');
      expect(baby.userId, 'user456');
      expect(baby.name, 'Adam');
      expect(baby.gender, 'Male');
      expect(baby.dateOfBirth, DateTime(2024, 6, 15));
      expect(baby.birthWeight, 3.8);
      expect(baby.birthHeight, 52.5);
      expect(baby.themeColor, '#4169E1');
      expect(baby.isActive, true);
    });

    test('should handle baby with minimal optional fields', () {
      final minimalBaby = BabyModel(
        id: 'baby789',
        userId: 'user789',
        name: 'Emma',
        dateOfBirth: DateTime(2024, 3, 20),
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      final map = minimalBaby.toMap();

      expect(map['gender'], null);
      expect(map['birth_weight'], null);
      expect(map['birth_height'], null);
      expect(map['theme_color'], null);

      final recovered = BabyModel.fromMap(map);
      expect(recovered.gender, null);
      expect(recovered.birthWeight, null);
      expect(recovered.birthHeight, null);
    });

    test('should handle inactive baby', () {
      final inactiveBaby = BabyModel(
        id: 'baby000',
        userId: 'user000',
        name: 'Test',
        dateOfBirth: DateTime(2023, 1, 1),
        isActive: false,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      final map = inactiveBaby.toMap();
      expect(map['is_active'], 0);

      final recovered = BabyModel.fromMap(map);
      expect(recovered.isActive, false);
    });

    test('toMap and fromMap should be reversible', () {
      final map = testBaby.toMap();
      final recovered = BabyModel.fromMap(map);

      expect(recovered.id, testBaby.id);
      expect(recovered.name, testBaby.name);
      expect(recovered.gender, testBaby.gender);
      expect(recovered.birthWeight, testBaby.birthWeight);
      expect(recovered.birthHeight, testBaby.birthHeight);
      expect(recovered.isActive, testBaby.isActive);
    });

    test('should handle edge case weights and heights', () {
      final tinyBaby = BabyModel(
        id: 'b1',
        userId: 'u1',
        name: 'Tiny',
        dateOfBirth: DateTime(2024, 1, 1),
        birthWeight: 2.0, // Low birth weight
        birthHeight: 45.0,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      final map = tinyBaby.toMap();
      final recovered = BabyModel.fromMap(map);

      expect(recovered.birthWeight, 2.0);
      expect(recovered.birthHeight, 45.0);
    });

    test('should handle large birth measurements', () {
      final largeBaby = BabyModel(
        id: 'b2',
        userId: 'u2',
        name: 'Large',
        dateOfBirth: DateTime(2024, 1, 1),
        birthWeight: 5.5, // Large baby
        birthHeight: 58.0,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      final map = largeBaby.toMap();
      final recovered = BabyModel.fromMap(map);

      expect(recovered.birthWeight, 5.5);
      expect(recovered.birthHeight, 58.0);
    });
  });
}
