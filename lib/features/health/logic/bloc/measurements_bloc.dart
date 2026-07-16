import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/database/models/measurement_model.dart';
import '../../../../core/services/measurements_service.dart';
import 'measurements_event.dart';
import 'measurements_state.dart';

class MeasurementsBloc extends Bloc<MeasurementsEvent, MeasurementsState> {
  final MeasurementsService _measurementsService = MeasurementsService();

  MeasurementsBloc() : super(MeasurementsInitial()) {
    on<LoadMeasurements>(_onLoad);
    on<AddMeasurement>(_onAdd);
    on<DeleteMeasurement>(_onDelete);
    on<RefreshMeasurements>(_onRefresh);
  }

  Future<void> _onLoad(LoadMeasurements event, Emitter<MeasurementsState> emit) async {
    emit(MeasurementsLoading());
    try {
      final measurements = await _measurementsService.getMeasurements();
      final latest = measurements.isNotEmpty ? measurements.first : null;
      emit(MeasurementsLoaded(measurements, latest));
    } catch (e) {
      emit(MeasurementsError(e.toString()));
    }
  }

  Future<void> _onAdd(AddMeasurement event, Emitter<MeasurementsState> emit) async {
    try {
      await _measurementsService.addMeasurement(event.measurement);
      add(LoadMeasurements());
    } catch (e) {
      emit(MeasurementsError(e.toString()));
    }
  }

  Future<void> _onDelete(DeleteMeasurement event, Emitter<MeasurementsState> emit) async {
    try {
      await _measurementsService.deleteMeasurement(event.id);
      add(LoadMeasurements());
    } catch (e) {
      emit(MeasurementsError(e.toString()));
    }
  }

  Future<void> _onRefresh(RefreshMeasurements event, Emitter<MeasurementsState> emit) async {
    add(LoadMeasurements());
  }

  Future<MeasurementModel?> getLatestMeasurement() async {
    return await _measurementsService.getLatestMeasurement();
  }
}