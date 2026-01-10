import '../../../../core/database/models/measurement_model.dart';

abstract class MeasurementsEvent {}

class LoadMeasurements extends MeasurementsEvent {}

class AddMeasurement extends MeasurementsEvent {
  final MeasurementModel measurement;
  AddMeasurement(this.measurement);
}

class DeleteMeasurement extends MeasurementsEvent {
  final String id;
  DeleteMeasurement(this.id);
}

class RefreshMeasurements extends MeasurementsEvent {}