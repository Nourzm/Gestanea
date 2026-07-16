import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/services/symptoms_service.dart';
import '../../../../core/database/models/symptom_model.dart';
import 'symptoms_event.dart';
import 'symptoms_state.dart';

class SymptomsBloc extends Bloc<SymptomsEvent, SymptomsState> {
  final SymptomsService _symptomsService = SymptomsService();

  SymptomsBloc() : super(SymptomsInitial()) {
    on<LoadSymptoms>(_onLoad);
    on<AddSymptom>(_onAdd);
    on<DeleteSymptom>(_onDelete);
    on<RefreshSymptoms>(_onRefresh);
  }

  Future<void> _onLoad(LoadSymptoms event, Emitter<SymptomsState> emit) async {
    emit(SymptomsLoading());
    try {
      final symptoms = await _symptomsService.getSymptoms();
      final latest = symptoms.isNotEmpty ? symptoms.first : null;
      emit(SymptomsLoaded(symptoms, latest));
    } catch (e) {
      emit(SymptomsError(e.toString()));
    }
  }

  Future<void> _onAdd(AddSymptom event, Emitter<SymptomsState> emit) async {
    try {
      await _symptomsService.addSymptom(event.symptom);
      add(LoadSymptoms());
    } catch (e) {
      emit(SymptomsError(e.toString()));
    }
  }

  Future<void> _onDelete(DeleteSymptom event, Emitter<SymptomsState> emit) async {
    try {
      await _symptomsService.deleteSymptom(event.id);
      add(LoadSymptoms());
    } catch (e) {
      emit(SymptomsError(e.toString()));
    }
  }

  Future<void> _onRefresh(RefreshSymptoms event, Emitter<SymptomsState> emit) async {
    add(LoadSymptoms());
  }

  Future<SymptomModel?> getLatestSymptom() async {
    return await _symptomsService.getLatestSymptom();
  }
}