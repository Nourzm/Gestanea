import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/database/db_helper.dart';
import '../../../../core/database/models/lab_result_model.dart';
import '../../../../core/services/image_storage_service.dart';
import 'lab_results_event.dart';
import 'lab_results_state.dart';

class LabResultsBloc extends Bloc<LabResultsEvent, LabResultsState> {
  final DatabaseHelper _dbHelper = DatabaseHelper. instance;
  final ImageStorageService _imageStorage = ImageStorageService();

  LabResultsBloc() : super(LabResultsInitial()) {
    on<LoadLabResults>(_onLoad);
    on<AddLabResult>(_onAdd);
    on<DeleteLabResult>(_onDelete);
    on<ExportLabResultsAsZip>(_onExport);
    on<RefreshLabResults>(_onRefresh);
  }

  Future<void> _onLoad(LoadLabResults event, Emitter<LabResultsState> emit) async {
    emit(LabResultsLoading());
    try {
      final labResults = await _getLabResults();
      final latest = labResults.isNotEmpty ? labResults.first : null;
      emit(LabResultsLoaded(labResults, latest));
    } catch (e) {
      emit(LabResultsError(e.toString()));
    }
  }

  Future<void> _onAdd(AddLabResult event, Emitter<LabResultsState> emit) async {
    try {
      await _saveLabResult(event.labResult);
      add(LoadLabResults());
    } catch (e) {
      emit(LabResultsError(e.toString()));
    }
  }

  Future<void> _onDelete(DeleteLabResult event, Emitter<LabResultsState> emit) async {
    try {
      await _deleteLabResult(event.id);
      
      // Delete associated image
      if (event.imagePath != null) {
        await _imageStorage. deleteImage(event.imagePath! );
      }
      
      add(LoadLabResults());
    } catch (e) {
      emit(LabResultsError(e.toString()));
    }
  }

  Future<void> _onExport(ExportLabResultsAsZip event, Emitter<LabResultsState> emit) async {
    emit(LabResultsExporting());
    try {
      await _imageStorage.shareZip();
      add(LoadLabResults()); // Return to normal state
    } catch (e) {
      emit(LabResultsError(e.toString()));
    }
  }

  Future<void> _onRefresh(RefreshLabResults event, Emitter<LabResultsState> emit) async {
    add(LoadLabResults());
  }

  // Database operations
  Future<List<LabResultModel>> _getLabResults() async {
    final db = await _dbHelper.database;
    final maps = await db.query(
      'lab_results',
      orderBy: 'lab_date DESC, created_at DESC',
    );
    return maps.map((map) => LabResultModel. fromMap(map)).toList();
  }

  Future<void> _saveLabResult(LabResultModel labResult) async {
    final db = await _dbHelper.database;
    await db. insert('lab_results', labResult.toMap());
  }

  Future<void> _deleteLabResult(String id) async {
    final db = await _dbHelper.database;
    await db.delete(
      'lab_results',
      where: 'id = ? ',
      whereArgs: [id],
    );
  }
}