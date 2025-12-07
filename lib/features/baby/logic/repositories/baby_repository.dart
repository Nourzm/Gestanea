import 'package:gestanea/core/database/models/baby_model.dart';
import 'package:gestanea/core/database/models/baby_growth_model.dart';
import 'package:gestanea/core/database/models/milestone_model.dart';
import 'package:gestanea/core/database/models/feeding_log_model.dart';
import 'package:gestanea/features/baby/data/datasources/baby_local_data_source.dart';

class BabyRepository {
  final BabyLocalDataSource _localDataSource;

  BabyRepository(this._localDataSource);

  // ==================== BABY ====================

  Future<BabyModel?> getBabyByUserId(String userId) {
    return _localDataSource.getBabyByUserId(userId);
  }

  Future<List<BabyModel>> getAllBabiesByUserId(String userId) {
    return _localDataSource.getAllBabiesByUserId(userId);
  }

  Future<BabyModel?> getBabyById(String babyId) {
    return _localDataSource.getBabyById(babyId);
  }

  Future<void> createBaby(BabyModel baby) {
    return _localDataSource.createBaby(baby);
  }

  Future<void> updateBaby(BabyModel baby) {
    return _localDataSource.updateBaby(baby);
  }

  Future<void> deleteBaby(String babyId) {
    return _localDataSource.deleteBaby(babyId);
  }

  // ==================== GROWTH ====================

  Future<List<BabyGrowthModel>> getGrowthRecords(String babyId) {
    return _localDataSource.getGrowthRecords(babyId);
  }

  Future<BabyGrowthModel?> getLatestGrowthRecord(String babyId) {
    return _localDataSource.getLatestGrowthRecord(babyId);
  }

  Future<void> addGrowthRecord(BabyGrowthModel growth) {
    return _localDataSource.addGrowthRecord(growth);
  }

  Future<void> updateGrowthRecord(BabyGrowthModel growth) {
    return _localDataSource.updateGrowthRecord(growth);
  }

  Future<void> deleteGrowthRecord(String growthId) {
    return _localDataSource.deleteGrowthRecord(growthId);
  }

  // ==================== MILESTONES ====================

  Future<List<MilestoneModel>> getMilestones(String babyId) {
    return _localDataSource.getMilestones(babyId);
  }

  Future<List<MilestoneModel>> getAchievedMilestones(String babyId) {
    return _localDataSource.getAchievedMilestones(babyId);
  }

  Future<void> addMilestone(MilestoneModel milestone) {
    return _localDataSource.addMilestone(milestone);
  }

  Future<void> updateMilestone(MilestoneModel milestone) {
    return _localDataSource.updateMilestone(milestone);
  }

  Future<void> markMilestoneAchieved(String milestoneId, DateTime achievedDate) {
    return _localDataSource.markMilestoneAchieved(milestoneId, achievedDate);
  }

  Future<void> deleteMilestone(String milestoneId) {
    return _localDataSource.deleteMilestone(milestoneId);
  }

  // ==================== FEEDING ====================

  Future<List<FeedingLogModel>> getFeedingLogs(String babyId, {int? limit}) {
    return _localDataSource.getFeedingLogs(babyId, limit: limit);
  }

  Future<List<FeedingLogModel>> getFeedingLogsByDate(String babyId, DateTime date) {
    return _localDataSource.getFeedingLogsByDate(babyId, date);
  }

  Future<void> addFeedingLog(FeedingLogModel feedingLog) {
    return _localDataSource.addFeedingLog(feedingLog);
  }

  Future<void> updateFeedingLog(FeedingLogModel feedingLog) {
    return _localDataSource.updateFeedingLog(feedingLog);
  }

  Future<void> deleteFeedingLog(String feedingLogId) {
    return _localDataSource.deleteFeedingLog(feedingLogId);
  }

  // ==================== STATISTICS ====================

  Future<Map<String, dynamic>> getFeedingStats(String babyId, {int days = 7}) {
    return _localDataSource.getFeedingStats(babyId, days: days);
  }
}
