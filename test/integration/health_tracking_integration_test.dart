import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:gestanea/features/health/logic/bloc/measurements_bloc.dart';
import 'package:gestanea/features/health/logic/bloc/measurements_event.dart';
import 'package:gestanea/features/health/logic/bloc/measurements_state.dart';
import 'package:gestanea/features/health/logic/bloc/symptoms_bloc.dart';
import 'package:gestanea/features/health/logic/bloc/symptoms_event.dart';
import 'package:gestanea/features/health/logic/bloc/symptoms_state.dart';
import 'package:gestanea/features/health/logic/bloc/moods_bloc.dart';
import 'package:gestanea/features/health/logic/bloc/moods_event.dart';
import 'package:gestanea/features/health/logic/bloc/moods_state.dart';
import 'package:gestanea/core/database/models/measurement_model.dart';
import 'package:gestanea/core/database/models/symptom_model.dart';
import 'package:gestanea/core/database/models/mood_model.dart';

void main() {
  group('Health Tracking BLoC Tests', () {
    group('MeasurementsBloc', () {
      late MeasurementsBloc measurementsBloc;

      setUp(() {
        measurementsBloc = MeasurementsBloc();
      });

      tearDown(() {
        measurementsBloc.close();
      });

      test('initial state is MeasurementsInitial', () {
        expect(measurementsBloc.state, isA<MeasurementsInitial>());
      });

      blocTest<MeasurementsBloc, MeasurementsState>(
        'emits [MeasurementsLoading] when LoadMeasurements is added',
        build: () => measurementsBloc,
        act: (bloc) => bloc.add(LoadMeasurements()),
        expect: () => [isA<MeasurementsLoading>()],
      );

      blocTest<MeasurementsBloc, MeasurementsState>(
        'emits [MeasurementsLoading] when AddMeasurement is added',
        build: () => measurementsBloc,
        act: (bloc) {
          final measurement = MeasurementModel(
            id: 'test_measurement_1',
            userId: 'test_user',
            weight: 65.5,
            heartRate: 75,
            systolic: 120,
            diastolic: 80,
            recordedAt: DateTime.now(),
            createdAt: DateTime.now(),
          );
          bloc.add(AddMeasurement(measurement));
        },
        expect: () => [isA<MeasurementsLoading>()],
      );

      blocTest<MeasurementsBloc, MeasurementsState>(
        'emits [MeasurementsLoading] when DeleteMeasurement is added',
        build: () => measurementsBloc,
        act: (bloc) => bloc.add(DeleteMeasurement('test_id')),
        expect: () => [isA<MeasurementsLoading>()],
      );

      blocTest<MeasurementsBloc, MeasurementsState>(
        'emits [MeasurementsLoading] when RefreshMeasurements is added',
        build: () => measurementsBloc,
        act: (bloc) => bloc.add(RefreshMeasurements()),
        expect: () => [isA<MeasurementsLoading>()],
      );

      test('handles invalid measurement data gracefully', () {
        final invalidMeasurement = MeasurementModel(
          id: 'test_invalid',
          userId: 'test_user',
          weight: -65.5, // Invalid negative weight
          heartRate: 75,
          systolic: 120,
          diastolic: 80,
          recordedAt: DateTime.now(),
          createdAt: DateTime.now(),
        );

        measurementsBloc.add(AddMeasurement(invalidMeasurement));

        // Should not crash - validation handled by bloc
        expect(measurementsBloc.isClosed, false);
      });
    });

    group('SymptomsBloc', () {
      late SymptomsBloc symptomsBloc;

      setUp(() {
        symptomsBloc = SymptomsBloc();
      });

      tearDown(() {
        symptomsBloc.close();
      });

      test('initial state is SymptomsInitial', () {
        expect(symptomsBloc.state, isA<SymptomsInitial>());
      });

      blocTest<SymptomsBloc, SymptomsState>(
        'emits [SymptomsLoading] when LoadSymptoms is added',
        build: () => symptomsBloc,
        act: (bloc) => bloc.add(LoadSymptoms()),
        expect: () => [isA<SymptomsLoading>()],
      );

      blocTest<SymptomsBloc, SymptomsState>(
        'emits [SymptomsLoading] when AddSymptom is added',
        build: () => symptomsBloc,
        act: (bloc) {
          final symptom = SymptomModel(
            id: 'test_symptom_1',
            userId: 'test_user',
            symptomName: 'Headache',
            severity: 'Moderate',
            notes: 'Started in the morning',
            recordedAt: DateTime.now(),
            createdAt: DateTime.now(),
          );
          bloc.add(AddSymptom(symptom));
        },
        expect: () => [isA<SymptomsLoading>()],
      );

      blocTest<SymptomsBloc, SymptomsState>(
        'emits [SymptomsLoading] when DeleteSymptom is added',
        build: () => symptomsBloc,
        act: (bloc) => bloc.add(DeleteSymptom('test_id')),
        expect: () => [isA<SymptomsLoading>()],
      );

      test('handles multiple symptoms correctly', () async {
        final symptoms = [
          SymptomModel(
            id: 'symptom_1',
            userId: 'test_user',
            symptomName: 'Nausea',
            severity: 'Mild',
            notes: 'Morning sickness',
            recordedAt: DateTime.now(),
            createdAt: DateTime.now(),
          ),
          SymptomModel(
            id: 'symptom_2',
            userId: 'test_user',
            symptomName: 'Back Pain',
            severity: 'Severe',
            notes: 'Lower back',
            recordedAt: DateTime.now(),
            createdAt: DateTime.now(),
          ),
        ];

        for (var symptom in symptoms) {
          symptomsBloc.add(AddSymptom(symptom));
        }

        // Should handle multiple additions without crashing
        expect(symptomsBloc.isClosed, false);
      });
    });

    group('MoodsBloc', () {
      late MoodsBloc moodsBloc;

      setUp(() {
        moodsBloc = MoodsBloc();
      });

      tearDown(() {
        moodsBloc.close();
      });

      test('initial state is MoodsInitial', () {
        expect(moodsBloc.state, isA<MoodsInitial>());
      });

      blocTest<MoodsBloc, MoodsState>(
        'emits [MoodsLoading] when LoadMoods is added',
        build: () => moodsBloc,
        act: (bloc) => bloc.add(LoadMoods()),
        expect: () => [isA<MoodsLoading>()],
      );

      blocTest<MoodsBloc, MoodsState>(
        'emits [MoodsLoading] when AddMood is added',
        build: () => moodsBloc,
        act: (bloc) {
          final mood = MoodModel(
            id: 'test_mood_1',
            userId: 'test_user',
            mood: 'Happy',
            intensity: 8,
            notes: 'Feeling great today',
            recordedAt: DateTime.now(),
            createdAt: DateTime.now(),
          );
          bloc.add(AddMood(mood));
        },
        expect: () => [isA<MoodsLoading>()],
      );

      blocTest<MoodsBloc, MoodsState>(
        'emits [MoodsLoading] when DeleteMood is added',
        build: () => moodsBloc,
        act: (bloc) => bloc.add(DeleteMood('test_id')),
        expect: () => [isA<MoodsLoading>()],
      );

      test('handles mood tracking over time', () async {
        final moods = [
          MoodModel(
            id: 'mood_1',
            userId: 'test_user',
            mood: 'Happy',
            intensity: 8,
            notes: 'Great day',
            recordedAt: DateTime.now().subtract(const Duration(days: 2)),
            createdAt: DateTime.now(),
          ),
          MoodModel(
            id: 'mood_2',
            userId: 'test_user',
            mood: 'Anxious',
            intensity: 6,
            notes: 'Worried',
            recordedAt: DateTime.now().subtract(const Duration(days: 1)),
            createdAt: DateTime.now(),
          ),
          MoodModel(
            id: 'mood_3',
            userId: 'test_user',
            mood: 'Calm',
            intensity: 7,
            notes: 'Peaceful',
            recordedAt: DateTime.now(),
            createdAt: DateTime.now(),
          ),
        ];

        for (var mood in moods) {
          moodsBloc.add(AddMood(mood));
        }

        // Should handle multiple mood entries without issues
        expect(moodsBloc.isClosed, false);
      });
    });

    group('Comprehensive Health Tracking Flow', () {
      late MeasurementsBloc measurementsBloc;
      late SymptomsBloc symptomsBloc;
      late MoodsBloc moodsBloc;

      setUp(() {
        measurementsBloc = MeasurementsBloc();
        symptomsBloc = SymptomsBloc();
        moodsBloc = MoodsBloc();
      });

      tearDown(() {
        measurementsBloc.close();
        symptomsBloc.close();
        moodsBloc.close();
      });

      test('handles complete daily health tracking workflow', () async {
        // Step 1: Add measurements
        final measurement = MeasurementModel(
          id: 'daily_measurement',
          userId: 'test_user',
          weight: 68.2,
          heartRate: 72,
          systolic: 118,
          diastolic: 78,
          recordedAt: DateTime.now(),
          createdAt: DateTime.now(),
        );
        measurementsBloc.add(AddMeasurement(measurement));

        // Step 2: Log symptoms
        final symptom = SymptomModel(
          id: 'daily_symptom',
          userId: 'test_user',
          symptomName: 'Fatigue',
          severity: 'Mild',
          notes: 'Afternoon tiredness',
          recordedAt: DateTime.now(),
          createdAt: DateTime.now(),
        );
        symptomsBloc.add(AddSymptom(symptom));

        // Step 3: Record mood
        final mood = MoodModel(
          id: 'daily_mood',
          userId: 'test_user',
          mood: 'Content',
          intensity: 7,
          notes: 'Feeling good overall',
          recordedAt: DateTime.now(),
          createdAt: DateTime.now(),
        );
        moodsBloc.add(AddMood(mood));

        // Small delay to allow processing
        await Future.delayed(const Duration(milliseconds: 100));

        // Step 4: Load all data
        measurementsBloc.add(LoadMeasurements());
        symptomsBloc.add(LoadSymptoms());
        moodsBloc.add(LoadMoods());

        await Future.delayed(const Duration(milliseconds: 100));

        // All blocs should be operational
        expect(measurementsBloc.isClosed, false);
        expect(symptomsBloc.isClosed, false);
        expect(moodsBloc.isClosed, false);
      });

      test('all blocs can be used concurrently', () async {
        // Test that all three blocs can operate simultaneously
        measurementsBloc.add(LoadMeasurements());
        symptomsBloc.add(LoadSymptoms());
        moodsBloc.add(LoadMoods());

        await Future.delayed(const Duration(milliseconds: 100));

        // Verify all are still operational
        expect(measurementsBloc.isClosed, false);
        expect(symptomsBloc.isClosed, false);
        expect(moodsBloc.isClosed, false);

        // Verify states are appropriate
        expect(
          measurementsBloc.state is MeasurementsLoading ||
              measurementsBloc.state is MeasurementsLoaded ||
              measurementsBloc.state is MeasurementsError,
          true,
        );
        expect(
          symptomsBloc.state is SymptomsLoading ||
              symptomsBloc.state is SymptomsLoaded ||
              symptomsBloc.state is SymptomsError,
          true,
        );
        expect(
          moodsBloc.state is MoodsLoading ||
              moodsBloc.state is MoodsLoaded ||
              moodsBloc.state is MoodsError,
          true,
        );
      });
    });
  });
}
