import '../../../../core/database/models/symptom_model.dart';

abstract class SymptomsEvent {}

class LoadSymptoms extends SymptomsEvent {}

class AddSymptom extends SymptomsEvent {
  final SymptomModel symptom;
  AddSymptom(this.symptom);
}

class DeleteSymptom extends SymptomsEvent {
  final String id;
  DeleteSymptom(this.id);
}

class RefreshSymptoms extends SymptomsEvent {}
