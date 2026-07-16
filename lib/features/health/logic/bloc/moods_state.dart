import '../../../../../core/database/models/mood_model.dart';

abstract class MoodsState {}

class MoodsInitial extends MoodsState {}

class MoodsLoading extends MoodsState {}

class MoodsLoaded extends MoodsState {
  final List<MoodModel> moods;

  MoodsLoaded(this.moods);
}

class MoodsError extends MoodsState {
  final String message;

  MoodsError(this.message);
}
