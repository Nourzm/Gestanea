import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/database/db_helper.dart';
import '../../../../core/database/models/symptom_model.dart';
import 'symptoms_event.dart';
import 'symptoms_state.dart';

class SymptomsBloc extends Bloc<SymptomsEvent, SymptomsState> {
  final DatabaseHelper _dbHelper = DatabaseHelper. instance;

  SymptomsBloc() : super(SymptomsInitial()) {
    on<LoadSymptoms>(_onLoad);
    on<AddSymptom>(_onAdd);
    on<DeleteSymptom>(_onDelete);
    on<RefreshSymptoms>(_onRefresh);
  }

  Future<void> _onLoad(LoadSymptoms event, Emitter<SymptomsState> emit) async {
    emit(SymptomsLoading());
    try {
      final symptoms = await _getSymptoms();
      final latest = symptoms.isNotEmpty ? symptoms. first : null;
      emit(SymptomsLoaded(symptoms, latest));
    } catch (e) {
      emit(SymptomsError(e.toString()));
    }
  }

  Future<void> _onAdd(AddSymptom event, Emitter<SymptomsState> emit) async {
    try {
      await _saveSymptom(event.symptom);
      add(LoadSymptoms());
    } catch (e) {
      emit(SymptomsError(e. toString()));
    }
  }

  Future<void> _onDelete(DeleteSymptom event, Emitter<SymptomsState> emit) async {
    try {
      await _deleteSymptom(event.id);
      add(LoadSymptoms());
    } catch (e) {
      emit(SymptomsError(e.toString()));
    }
  }

  Future<void> _onRefresh(RefreshSymptoms event, Emitter<SymptomsState> emit) async {
    add(LoadSymptoms());
  }

  // Database operations
  Future<List<SymptomModel>> _getSymptoms() async {
    final db = await _dbHelper.database;
    final maps = await db.query(
      'symptoms',
      orderBy: 'recorded_at DESC',
    );
    return maps.map((map) => SymptomModel.fromMap(map)).toList();
  }

  Future<void> _saveSymptom(SymptomModel symptom) async {
    final db = await _dbHelper.database;
    await db.insert('symptoms', symptom.toMap());
  }

  Future<void> _deleteSymptom(String id) async {
    final db = await _dbHelper.database;
    await db.delete(
      'symptoms',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<SymptomModel?> getLatestSymptom() async {
    final symptoms = await _getSymptoms();
    return symptoms.isNotEmpty ? symptoms.first : null;
  }
}