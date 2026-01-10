import '../../../../core/database/models/lab_result_model.dart';
import 'dart:io';

abstract class LabResultsEvent {}

class LoadLabResults extends LabResultsEvent {}

class AddLabResult extends LabResultsEvent {
  final LabResultModel labResult;
  AddLabResult(this.labResult);
}

class UpdateLabResult extends LabResultsEvent {
  final LabResultModel labResult;
  UpdateLabResult(this.labResult);
}

class DeleteLabResult extends LabResultsEvent {
  final String id;
  final String?  imagePath;
  DeleteLabResult(this.id, this.imagePath);
}

class ExportLabResultsAsZip extends LabResultsEvent {}

class RefreshLabResults extends LabResultsEvent {}