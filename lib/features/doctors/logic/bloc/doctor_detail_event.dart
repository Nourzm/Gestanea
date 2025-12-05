abstract class DoctorDetailEvent {}

class OpenDirections extends DoctorDetailEvent {
  final double latitude;
  final double longitude;

  OpenDirections(this.latitude, this.longitude);
}

class MakePhoneCall extends DoctorDetailEvent {
  final String phoneNumber;

  MakePhoneCall(this.phoneNumber);
}
