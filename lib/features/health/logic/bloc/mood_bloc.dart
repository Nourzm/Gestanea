import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/database/db_helper.dart';
import '../../../../core/database/models/mood_model.dart';
import 'mood_event.dart';
import 'mood_state.dart';

class MoodBloc extends Bloc<MoodEvent, MoodState> {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  /// Owner of the records this bloc reads and writes. All queries are scoped
  /// to this id so users never see each other's data.
  final String userId;

  MoodBloc({required this.userId}) : super(const MoodInitial()) {
    on<LoadMoods>(_onLoad);
    on<AddMood>(_onAdd);
    on<DeleteMood>(_onDelete);
  }

  Future<void> _onLoad(LoadMoods event, Emitter<MoodState> emit) async {
    emit(const MoodLoading());
    try {
      final moods = await _getMoods();
      emit(MoodLoaded(moods, moods.isNotEmpty ? moods.first : null));
    } catch (e) {
      emit(MoodError(e.toString()));
    }
  }

  Future<void> _onAdd(AddMood event, Emitter<MoodState> emit) async {
    try {
      // Stamp the real owner regardless of what the caller supplied.
      final db = await _dbHelper.database;
      await db.insert('moods', event.mood.copyWith(userId: userId).toMap());
      add(const LoadMoods());
    } catch (e) {
      emit(MoodError(e.toString()));
    }
  }

  Future<void> _onDelete(DeleteMood event, Emitter<MoodState> emit) async {
    try {
      final db = await _dbHelper.database;
      await db.delete(
        'moods',
        where: 'id = ? AND user_id = ?',
        whereArgs: [event.id, userId],
      );
      add(const LoadMoods());
    } catch (e) {
      emit(MoodError(e.toString()));
    }
  }

  Future<List<MoodModel>> _getMoods() async {
    final db = await _dbHelper.database;
    final maps = await db.query(
      'moods',
      where: 'user_id = ?',
      whereArgs: [userId],
      orderBy: 'recorded_at DESC',
    );
    return maps.map((m) => MoodModel.fromMap(m)).toList();
  }
}
