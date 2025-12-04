import 'package:equatable/equatable.dart';
import 'package:gestanea/core/models/baby.dart';

abstract class BabyState extends Equatable {
  const BabyState();
  
  @override
  List<Object?> get props => [];
}

class BabyInitial extends BabyState {}

class BabyLoading extends BabyState {}

class BabyLoaded extends BabyState {
  final List<Baby> babies;

  const BabyLoaded(this.babies);

  @override
  List<Object?> get props => [babies];
}

class BabyError extends BabyState {
  final String message;

  const BabyError(this.message);

  @override
  List<Object?> get props => [message];
}

class BabyOperationSuccess extends BabyState {
  final String message;

  const BabyOperationSuccess(this.message);

  @override
  List<Object?> get props => [message];
}
