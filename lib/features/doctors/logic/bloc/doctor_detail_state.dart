abstract class DoctorDetailState {}

class DoctorDetailInitial extends DoctorDetailState {}

class DoctorDetailActionInProgress extends DoctorDetailState {}

class DoctorDetailActionSuccess extends DoctorDetailState {
  final String message;

  DoctorDetailActionSuccess(this.message);
}

class DoctorDetailActionFailure extends DoctorDetailState {
  final String error;

  DoctorDetailActionFailure(this.error);
}
