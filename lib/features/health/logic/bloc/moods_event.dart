import '../../../../../core/database/models/mood_model.dart';

abstract class MoodsEvent {}

class LoadMoods extends MoodsEvent {}

class AddMood extends MoodsEvent {
  final MoodModel mood;

  AddMood(this.mood);
}

class DeleteMood extends MoodsEvent {
  final String id;

  DeleteMood(this.id);
}

class RefreshMoods extends MoodsEvent {}
