import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/database/db_helper.dart';
import '../../../../core/database/models/measurement_model.dart';
import 'measurements_event.dart';
import 'measurements_state.dart';

class MeasurementsBloc extends Bloc<MeasurementsEvent, MeasurementsState> {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  /// Owner of the records this bloc reads and writes. All queries are scoped
  /// to this id so users never see each other's data.
  final String userId;

  MeasurementsBloc({required this.userId}) : super(MeasurementsInitial()) {
    on<LoadMeasurements>(_onLoad);
    on<AddMeasurement>(_onAdd);
    on<DeleteMeasurement>(_onDelete);
    on<RefreshMeasurements>(_onRefresh);
  }

  Future<void> _onLoad(
    LoadMeasurements event,
    Emitter<MeasurementsState> emit,
  ) async {
    emit(MeasurementsLoading());
    try {
      final measurements = await _getMeasurements();
      final latest = measurements.isNotEmpty ? measurements.first : null;
      emit(MeasurementsLoaded(measurements, latest));
    } catch (e) {
      emit(MeasurementsError(e.toString()));
    }
  }

  Future<void> _onAdd(
    AddMeasurement event,
    Emitter<MeasurementsState> emit,
  ) async {
    try {
      // Stamp the real owner regardless of what the caller supplied.
      await _saveMeasurement(event.measurement.copyWith(userId: userId));
      add(LoadMeasurements());
    } catch (e) {
      emit(MeasurementsError(e.toString()));
    }
  }

  Future<void> _onDelete(
    DeleteMeasurement event,
    Emitter<MeasurementsState> emit,
  ) async {
    try {
      await _deleteMeasurement(event.id);
      add(LoadMeasurements());
    } catch (e) {
      emit(MeasurementsError(e.toString()));
    }
  }

  Future<void> _onRefresh(
    RefreshMeasurements event,
    Emitter<MeasurementsState> emit,
  ) async {
    add(LoadMeasurements());
  }

  // Database operations
  Future<List<MeasurementModel>> _getMeasurements() async {
    final db = await _dbHelper.database;
    final maps = await db.query(
      'measurements',
      where: 'user_id = ?',
      whereArgs: [userId],
      orderBy: 'recorded_at DESC',
    );
    return maps.map((map) => MeasurementModel.fromMap(map)).toList();
  }

  Future<void> _saveMeasurement(MeasurementModel measurement) async {
    final db = await _dbHelper.database;
    await db.insert('measurements', measurement.toMap());
  }

  Future<void> _deleteMeasurement(String id) async {
    final db = await _dbHelper.database;
    await db.delete(
      'measurements',
      where: 'id = ? AND user_id = ?',
      whereArgs: [id, userId],
    );
  }

  Future<MeasurementModel?> getLatestMeasurement() async {
    final measurements = await _getMeasurements();
    return measurements.isNotEmpty ? measurements.first : null;
  }
}
