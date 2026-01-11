import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/services/moods_service.dart';
import 'moods_event.dart';
import 'moods_state.dart';

class MoodsBloc extends Bloc<MoodsEvent, MoodsState> {
  final MoodsService _moodsService = MoodsService();

  MoodsBloc() : super(MoodsInitial()) {
    // Start connectivity listener for auto-sync
    _moodsService.startConnectivityListener();
    
    on<LoadMoods>(_onLoadMoods);
    on<AddMood>(_onAddMood);
    on<DeleteMood>(_onDeleteMood);
    on<RefreshMoods>(_onRefreshMoods);
  }

  Future<void> _onLoadMoods(LoadMoods event, Emitter<MoodsState> emit) async {
    emit(MoodsLoading());
    try {
      final moods = await _moodsService.getMoods();
      emit(MoodsLoaded(moods));
    } catch (e) {
      emit(MoodsError(e.toString()));
    }
  }

  Future<void> _onAddMood(AddMood event, Emitter<MoodsState> emit) async {
    try {
      await _moodsService.addMood(event.mood);
      // Get from local database to immediately show the new mood
      final moods = await _moodsService.getLocalMoods();
      emit(MoodsLoaded(moods));
    } catch (e) {
      emit(MoodsError(e.toString()));
    }
  }

  Future<void> _onDeleteMood(DeleteMood event, Emitter<MoodsState> emit) async {
    try {
      await _moodsService.deleteMood(event.id);
      final moods = await _moodsService.getMoods();
      emit(MoodsLoaded(moods));
    } catch (e) {
      emit(MoodsError(e.toString()));
    }
  }

  Future<void> _onRefreshMoods(RefreshMoods event, Emitter<MoodsState> emit) async {
    try {
      await _moodsService.syncNow();
      final moods = await _moodsService.getMoods();
      emit(MoodsLoaded(moods));
    } catch (e) {
      emit(MoodsError(e.toString()));
    }
  }
}
