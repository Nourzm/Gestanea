import 'package:equatable/equatable.dart';
import 'package:gestanea/core/models/doctor.dart';

abstract class DoctorsState extends Equatable {
  const DoctorsState();
  
  @override
  List<Object?> get props => [];
}

class DoctorsInitial extends DoctorsState {}

class DoctorsLoading extends DoctorsState {}

class DoctorsLoaded extends DoctorsState {
  final List<Doctor> doctors;
  final List<Doctor> favoriteDoctors;

  const DoctorsLoaded({this.doctors = const [], this.favoriteDoctors = const []});

  @override
  List<Object?> get props => [doctors, favoriteDoctors];
}

class DoctorsError extends DoctorsState {
  final String message;

  const DoctorsError(this.message);

  @override
  List<Object?> get props => [message];
}
