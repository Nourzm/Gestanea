import '../../../../core/database/models/lab_result_model.dart';

abstract class LabResultsState {}

class LabResultsInitial extends LabResultsState {}

class LabResultsLoading extends LabResultsState {}

class LabResultsLoaded extends LabResultsState {
  final List<LabResultModel> labResults;
  final LabResultModel? latest;

  LabResultsLoaded(this.labResults, this.latest);
}

class LabResultsError extends LabResultsState {
  final String message;
  LabResultsError(this.message);
}

class LabResultsExporting extends LabResultsState {}

class LabResultsExported extends LabResultsState {
  final String zipPath;
  LabResultsExported(this.zipPath);
}
