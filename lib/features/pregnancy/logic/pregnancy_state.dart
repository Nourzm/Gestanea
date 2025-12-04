import 'package:equatable/equatable.dart';
import 'package:gestanea/core/models/pregnancy.dart';
import 'package:gestanea/core/models/kick_count.dart';

abstract class PregnancyState extends Equatable {
  const PregnancyState();
  
  @override
  List<Object?> get props => [];
}

class PregnancyInitial extends PregnancyState {}

class PregnancyLoading extends PregnancyState {}

class PregnancyLoaded extends PregnancyState {
  final Pregnancy? activePregnancy;
  final List<KickCount> kickCounts;

  const PregnancyLoaded({this.activePregnancy, this.kickCounts = const []});

  @override
  List<Object?> get props => [activePregnancy, kickCounts];
}

class PregnancyError extends PregnancyState {
  final String message;

  const PregnancyError(this.message);

  @override
  List<Object?> get props => [message];
}
