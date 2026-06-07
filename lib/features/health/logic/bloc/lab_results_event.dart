import '../../../../core/database/models/lab_result_model.dart';

abstract class LabResultsEvent {}

class LoadLabResults extends LabResultsEvent {}

class AddLabResult extends LabResultsEvent {
  final LabResultModel labResult;
  AddLabResult(this.labResult);
}

class DeleteLabResult extends LabResultsEvent {
  final String id;
  final String?  imagePath;
  DeleteLabResult(this.id, this.imagePath);
}

class ExportLabResultsAsZip extends LabResultsEvent {}

class RefreshLabResults extends LabResultsEvent {}