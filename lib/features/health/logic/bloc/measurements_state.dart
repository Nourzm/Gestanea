import '../../../../core/database/models/measurement_model.dart';

abstract class MeasurementsState {}

class MeasurementsInitial extends MeasurementsState {}

class MeasurementsLoading extends MeasurementsState {}

class MeasurementsLoaded extends MeasurementsState {
  final List<MeasurementModel> measurements;
  final MeasurementModel? latest;

  MeasurementsLoaded(this.measurements, this.latest);
}

class MeasurementsError extends MeasurementsState {
  final String message;
  MeasurementsError(this.message);
}