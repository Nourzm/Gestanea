import 'package:equatable/equatable.dart';
import 'package:gestanea/core/models/tip.dart';

abstract class EducationState extends Equatable {
  const EducationState();
  
  @override
  List<Object?> get props => [];
}

class EducationInitial extends EducationState {}

class EducationLoading extends EducationState {}

class EducationLoaded extends EducationState {
  final List<Tip> tips;
  final List<Tip> savedTips;

  const EducationLoaded({this.tips = const [], this.savedTips = const []});

  @override
  List<Object?> get props => [tips, savedTips];
}

class EducationError extends EducationState {
  final String message;

  const EducationError(this.message);

  @override
  List<Object?> get props => [message];
}
