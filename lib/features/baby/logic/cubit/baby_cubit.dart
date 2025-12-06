import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gestanea/core/database/models/baby_model.dart';
import 'package:gestanea/core/database/models/baby_growth_model.dart';
import 'package:gestanea/core/database/models/milestone_model.dart';
import 'package:gestanea/core/database/models/feeding_log_model.dart';
import 'package:gestanea/features/baby/logic/repositories/baby_repository.dart';
import 'package:uuid/uuid.dart';
import 'baby_state.dart';

class BabyCubit extends Cubit<BabyState> {
  final BabyRepository _repository;
  final String userId;
  String? _currentBabyId;

  BabyCubit({
    required BabyRepository repository,
    required this.userId,
  })  : _repository = repository,
        super(BabyInitial());

  String? get currentBabyId => _currentBabyId;

  // ==================== BABY PROFILE ====================

  Future<void> loadBabyProfile() async {
    emit(BabyLoading());
    try {
      final baby = await _repository.getBabyByUserId(userId);
      if (baby == null) {
        emit(NoBabyProfile());
        return;
      }

      _currentBabyId = baby.id;

      final growthRecords = await _repository.getGrowthRecords(baby.id);
      final milestones = await _repository.getMilestones(baby.id);
      final feedingLogs = await _repository.getFeedingLogs(baby.id, limit: 10);
      final latestGrowth = await _repository.getLatestGrowthRecord(baby.id);

      emit(BabyLoaded(
        baby: baby,
        growthRecords: growthRecords,
        milestones: milestones,
        feedingLogs: feedingLogs,
        latestGrowth: latestGrowth,
      ));
    } catch (e) {
      emit(BabyError('Failed to load baby profile: ${e.toString()}'));
    }
  }

  Future<void> createBabyProfile({
    required String name,
    required DateTime dateOfBirth,
    String? gender,
    double? birthWeight,
    double? birthHeight,
    String? themeColor,
  }) async {
    emit(BabyLoading());
    try {
      final now = DateTime.now();
      final baby = BabyModel(
        id: const Uuid().v4(),
        userId: userId,
        name: name,
        gender: gender,
        dateOfBirth: dateOfBirth,
        birthWeight: birthWeight,
        birthHeight: birthHeight,
        themeColor: themeColor,
        isActive: true,
        createdAt: now,
        updatedAt: now,
      );

      await _repository.createBaby(baby);
      _currentBabyId = baby.id;

      emit(BabyLoaded(
        baby: baby,
        growthRecords: const [],
        milestones: const [],
        feedingLogs: const [],
      ));
    } catch (e) {
      emit(BabyError('Failed to create baby profile: ${e.toString()}'));
    }
  }

  Future<void> updateBabyProfile(BabyModel baby) async {
    final currentState = state;
    emit(BabyLoading());
    try {
      final updatedBaby = BabyModel(
        id: baby.id,
        userId: baby.userId,
        name: baby.name,
        gender: baby.gender,
        dateOfBirth: baby.dateOfBirth,
        birthWeight: baby.birthWeight,
        birthHeight: baby.birthHeight,
        themeColor: baby.themeColor,
        isActive: baby.isActive,
        createdAt: baby.createdAt,
        updatedAt: DateTime.now(),
      );

      await _repository.updateBaby(updatedBaby);

      if (currentState is BabyLoaded) {
        emit(currentState.copyWith(baby: updatedBaby));
      } else {
        await loadBabyProfile();
      }
    } catch (e) {
      emit(BabyError('Failed to update baby profile: ${e.toString()}'));
    }
  }

  // ==================== GROWTH TRACKING ====================

  Future<void> loadGrowthRecords() async {
    if (_currentBabyId == null) {
      emit(const BabyError('No baby profile selected'));
      return;
    }

    emit(GrowthLoading());
    try {
      final baby = await _repository.getBabyById(_currentBabyId!);
      if (baby == null) {
        emit(const BabyError('Baby profile not found'));
        return;
      }
      
      final records = await _repository.getGrowthRecords(_currentBabyId!);
      final latest = await _repository.getLatestGrowthRecord(_currentBabyId!);

      emit(GrowthLoaded(
        baby: baby,
        growthRecords: records,
        latestGrowth: latest,
      ));
    } catch (e) {
      emit(BabyError('Failed to load growth records: ${e.toString()}'));
    }
  }

  Future<void> addGrowthRecord({
    required DateTime recordedDate,
    double? weight,
    double? height,
    int? weightPercentile,
    int? heightPercentile,
    String? growthStatus,
    String? notes,
  }) async {
    if (_currentBabyId == null) {
      emit(const BabyError('No baby profile selected'));
      return;
    }

    try {
      final growth = BabyGrowthModel(
        id: const Uuid().v4(),
        babyId: _currentBabyId!,
        recordedDate: recordedDate,
        weight: weight,
        height: height,
        weightPercentile: weightPercentile,
        heightPercentile: heightPercentile,
        growthStatus: growthStatus,
        notes: notes,
        createdAt: DateTime.now(),
      );

      await _repository.addGrowthRecord(growth);
      // Reload growth records to update the UI
      await loadGrowthRecords();
    } catch (e) {
      emit(BabyError('Failed to add growth record: ${e.toString()}'));
    }
  }

  Future<void> deleteGrowthRecord(String growthId) async {
    try {
      await _repository.deleteGrowthRecord(growthId);
      emit(const BabyOperationSuccess('Growth record deleted'));
      await loadGrowthRecords();
    } catch (e) {
      emit(BabyError('Failed to delete growth record: ${e.toString()}'));
    }
  }

  // ==================== MILESTONES ====================

  Future<void> loadMilestones() async {
    if (_currentBabyId == null) {
      emit(const BabyError('No baby profile selected'));
      return;
    }

    emit(MilestoneLoading());
    try {
      final all = await _repository.getMilestones(_currentBabyId!);
      final achieved = all.where((m) => m.achievedDate != null).toList();
      final upcoming = all.where((m) => m.achievedDate == null).toList();

      emit(MilestoneLoaded(
        allMilestones: all,
        achievedMilestones: achieved,
        upcomingMilestones: upcoming,
      ));
    } catch (e) {
      emit(BabyError('Failed to load milestones: ${e.toString()}'));
    }
  }

  Future<void> addMilestone({
    required String milestoneName,
    int? expectedAgeMonths,
    DateTime? achievedDate,
    String? notes,
  }) async {
    if (_currentBabyId == null) {
      emit(const BabyError('No baby profile selected'));
      return;
    }

    try {
      final milestone = MilestoneModel(
        id: const Uuid().v4(),
        babyId: _currentBabyId!,
        milestoneName: milestoneName,
        expectedAgeMonths: expectedAgeMonths,
        achievedDate: achievedDate,
        notes: notes,
        createdAt: DateTime.now(),
      );

      await _repository.addMilestone(milestone);
      emit(const BabyOperationSuccess('Milestone added successfully'));
      await loadMilestones();
    } catch (e) {
      emit(BabyError('Failed to add milestone: ${e.toString()}'));
    }
  }

  Future<void> markMilestoneAchieved(String milestoneId) async {
    try {
      await _repository.markMilestoneAchieved(milestoneId, DateTime.now());
      emit(const BabyOperationSuccess('Milestone marked as achieved!'));
      await loadMilestones();
    } catch (e) {
      emit(BabyError('Failed to mark milestone: ${e.toString()}'));
    }
  }

  Future<void> deleteMilestone(String milestoneId) async {
    try {
      await _repository.deleteMilestone(milestoneId);
      emit(const BabyOperationSuccess('Milestone deleted'));
      await loadMilestones();
    } catch (e) {
      emit(BabyError('Failed to delete milestone: ${e.toString()}'));
    }
  }

  // ==================== FEEDING LOGS ====================

  Future<void> loadFeedingLogs({String filterType = 'All'}) async {
    if (_currentBabyId == null) {
      emit(const BabyError('No baby profile selected'));
      return;
    }

    emit(FeedingLoading());
    try {
      var logs = await _repository.getFeedingLogs(_currentBabyId!);
      final stats = await _repository.getFeedingStats(_currentBabyId!);

      // Apply filter
      if (filterType != 'All') {
        logs = logs.where((log) => log.feedingType == filterType).toList();
      }

      emit(FeedingLoaded(
        feedingLogs: logs,
        stats: stats,
        selectedType: filterType,
      ));
    } catch (e) {
      emit(BabyError('Failed to load feeding logs: ${e.toString()}'));
    }
  }

  Future<void> addFeedingLog({
    required String feedingType,
    int? durationMinutes,
    double? amountMl,
    String? breastSide,
    DateTime? loggedAt,
    String? notes,
  }) async {
    if (_currentBabyId == null) {
      emit(const BabyError('No baby profile selected'));
      return;
    }

    try {
      final feedingLog = FeedingLogModel(
        id: const Uuid().v4(),
        babyId: _currentBabyId!,
        feedingType: feedingType,
        durationMinutes: durationMinutes,
        amountMl: amountMl,
        breastSide: breastSide,
        loggedAt: loggedAt ?? DateTime.now(),
        notes: notes,
        createdAt: DateTime.now(),
      );

      await _repository.addFeedingLog(feedingLog);
      emit(const BabyOperationSuccess('Feeding log added successfully'));
      
      // Reload with current filter
      final currentState = state;
      final filterType = currentState is FeedingLoaded 
          ? currentState.selectedType 
          : 'All';
      await loadFeedingLogs(filterType: filterType);
    } catch (e) {
      emit(BabyError('Failed to add feeding log: ${e.toString()}'));
    }
  }

  Future<void> deleteFeedingLog(String feedingLogId) async {
    try {
      await _repository.deleteFeedingLog(feedingLogId);
      emit(const BabyOperationSuccess('Feeding log deleted'));
      
      final currentState = state;
      final filterType = currentState is FeedingLoaded 
          ? currentState.selectedType 
          : 'All';
      await loadFeedingLogs(filterType: filterType);
    } catch (e) {
      emit(BabyError('Failed to delete feeding log: ${e.toString()}'));
    }
  }

  void filterFeedingLogs(String type) {
    final currentState = state;
    if (currentState is FeedingLoaded) {
      loadFeedingLogs(filterType: type);
    }
  }
}
