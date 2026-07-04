import '../../../../core/database/models/mood_model.dart';

abstract class MoodEvent {
  const MoodEvent();
}

class LoadMoods extends MoodEvent {
  const LoadMoods();
}

class AddMood extends MoodEvent {
  final MoodModel mood;
  const AddMood(this.mood);
}

class DeleteMood extends MoodEvent {
  final String id;
  const DeleteMood(this.id);
}
