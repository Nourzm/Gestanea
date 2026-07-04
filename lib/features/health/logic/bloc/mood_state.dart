import '../../../../core/database/models/mood_model.dart';

abstract class MoodState {
  const MoodState();
}

class MoodInitial extends MoodState {
  const MoodInitial();
}

class MoodLoading extends MoodState {
  const MoodLoading();
}

class MoodLoaded extends MoodState {
  final List<MoodModel> moods;
  final MoodModel? latest;
  const MoodLoaded(this.moods, this.latest);
}

class MoodError extends MoodState {
  final String message;
  const MoodError(this.message);
}
