// lib/features/pregnancy/data/repositories/pregnancy_repository.dart
import '../datasources/pregnancy_local_data_source.dart';
import '../../../../core/database/models/pregnancy_model.dart';
import '../../../../core/database/models/kick_count_model.dart';

abstract class IPregnancyRepository {
  Future<PregnancyModel?> getActivePregnancy(String userId);
  Future<Map<String, dynamic>> getPregnancyInfo(String userId);
  Future<void> deactivatePregnancy(String userId);
  Future<List<KickCountModel>> getKickHistory(String userId, {int? limit});
  Future<void> saveKickSession(String userId, int kickCount, int durationMinutes, String? notes);
}

class PregnancyRepository implements IPregnancyRepository {
  final PregnancyLocalDataSource _dataSource;

  PregnancyRepository({PregnancyLocalDataSource? dataSource})
      : _dataSource = dataSource ?? PregnancyLocalDataSourceImpl();

  @override
  Future<PregnancyModel?> getActivePregnancy(String userId) async {
    return await _dataSource.getActivePregnancy(userId);
  }

  @override
  Future<Map<String, dynamic>> getPregnancyInfo(String userId) async {
    return await _dataSource.calculatePregnancyWeek(userId);
  }

  @override
  Future<void> deactivatePregnancy(String userId) async {
    final pregnancy = await _dataSource.getActivePregnancy(userId);
    if (pregnancy != null) {
      await _dataSource.deactivatePregnancy(pregnancy.id);
    }
  }

  @override
  Future<List<KickCountModel>> getKickHistory(String userId, {int? limit}) async {
    return await _dataSource.getKickCounts(userId, limit: limit);
  }

  @override
  Future<void> saveKickSession(String userId, int kickCount, int durationMinutes, String? notes) async {
    final now = DateTime.now();
    final kickSession = KickCountModel(
      id: now.millisecondsSinceEpoch.toString(),
      userId: userId,
      kickCount: kickCount,
      durationMinutes: durationMinutes,
      recordedAt: now,
      notes: notes,
      createdAt: now,
    );
    await _dataSource.saveKickSession(kickSession);
  }
}
