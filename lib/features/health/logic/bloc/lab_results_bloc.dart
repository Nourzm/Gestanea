import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/database/db_helper.dart';
import '../../../../core/database/models/lab_result_model.dart';
import '../../../../core/services/image_storage_service.dart';
import '../../../../core/services/lab_results_service.dart';
import 'lab_results_event.dart';
import 'lab_results_state.dart';

class LabResultsBloc extends Bloc<LabResultsEvent, LabResultsState> {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;
  final ImageStorageService _imageStorage = ImageStorageService();
  final LabResultsService _labResultsService = LabResultsService();
  String? _currentUserId;

  LabResultsBloc() : super(LabResultsInitial()) {
    on<LoadLabResults>(_onLoad);
    on<AddLabResult>(_onAdd);
    on<UpdateLabResult>(_onUpdate);
    on<DeleteLabResult>(_onDelete);
    on<ExportLabResultsAsZip>(_onExport);
    on<RefreshLabResults>(_onRefresh);
  }

  void setUserId(String userId) {
    _currentUserId = userId;
  }

  Future<void> _onLoad(LoadLabResults event, Emitter<LabResultsState> emit) async {
    emit(LabResultsLoading());
    try {
      print('Loading lab results for user: $_currentUserId');
      if (_currentUserId == null) {
        print('Error: User ID is null');
        emit(LabResultsError('User not logged in'));
        return;
      }
      
      final labResults = await _labResultsService.getLabResults();
      print('Loaded ${labResults.length} lab results');
      final latest = labResults.isNotEmpty ? labResults.first : null;
      emit(LabResultsLoaded(labResults, latest));
    } catch (e) {
      print('Error loading lab results: $e');
      emit(LabResultsError(e.toString()));
    }
  }

  Future<void> _onAdd(AddLabResult event, Emitter<LabResultsState> emit) async {
    try {
      print('Adding lab result: ${event.labResult.testName}');
      print('User ID: ${event.labResult.userId}');
      await _labResultsService.addLabResult(event.labResult);
      print('Lab result added successfully');
      add(LoadLabResults());
    } catch (e) {
      print('Error adding lab result: $e');
      emit(LabResultsError(e.toString()));
    }
  }

  Future<void> _onUpdate(UpdateLabResult event, Emitter<LabResultsState> emit) async {
    try {
      print('Updating lab result: ${event.labResult.testName}');
      await _labResultsService.updateLabResult(event.labResult);
      print('Lab result updated successfully');
      add(LoadLabResults());
    } catch (e) {
      print('Error updating lab result: $e');
      emit(LabResultsError(e.toString()));
    }
  }

  Future<void> _onDelete(DeleteLabResult event, Emitter<LabResultsState> emit) async {
    try {
      await _labResultsService.deleteLabResult(event.id);
      
      // Delete associated image
      if (event.imagePath != null) {
        await _imageStorage.deleteImage(event.imagePath!);
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
}