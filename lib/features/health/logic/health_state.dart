import 'package:equatable/equatable.dart';
import 'package:gestanea/core/models/vital.dart';
import 'package:gestanea/core/models/symptom.dart';
import 'package:gestanea/core/models/mood.dart';
import 'package:gestanea/core/models/lab_result.dart';

abstract class HealthState extends Equatable {
  const HealthState();
  
  @override
  List<Object?> get props => [];
}

class HealthInitial extends HealthState {}

class HealthLoading extends HealthState {}

class HealthLoaded extends HealthState {
  final List<Vital> vitals;
  final List<Symptom> symptoms;
  final List<Mood> moods;
  final List<LabResult> labResults;

  const HealthLoaded({
    this.vitals = const [],
    this.symptoms = const [],
    this.moods = const [],
    this.labResults = const [],
  });

  @override
  List<Object?> get props => [vitals, symptoms, moods, labResults];
}

class HealthError extends HealthState {
  final String message;

  const HealthError(this.message);

  @override
  List<Object?> get props => [message];
}
