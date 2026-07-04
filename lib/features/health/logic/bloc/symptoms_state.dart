import '../../../../core/database/models/symptom_model.dart';

abstract class SymptomsState {}

class SymptomsInitial extends SymptomsState {}

class SymptomsLoading extends SymptomsState {}

class SymptomsLoaded extends SymptomsState {
  final List<SymptomModel> symptoms;
  final SymptomModel? latest;

  SymptomsLoaded(this.symptoms, this.latest);
}

class SymptomsError extends SymptomsState {
  final String message;
  SymptomsError(this.message);
}
