import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/database/models/lab_result_model.dart';

class LabResultsRemoteDataSource {
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<List<LabResultModel>> getLabResults(String userId) async {
    try {
      final response = await _supabase
          .from('lab_results')
          .select()
          .eq('user_id', userId)
          .order('lab_date', ascending: false)
          .order('created_at', ascending: false);

      return (response as List)
          .map((json) => LabResultModel.fromMap(json))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch lab results: $e');
    }
  }

  Future<void> addLabResult(LabResultModel labResult) async {
    try {
      await _supabase.from('lab_results').insert(labResult.toMap());
    } catch (e) {
      throw Exception('Failed to add lab result: $e');
    }
  }

  Future<void> updateLabResult(LabResultModel labResult) async {
    try {
      await _supabase
          .from('lab_results')
          .update(labResult.toMap())
          .eq('id', labResult.id);
    } catch (e) {
      throw Exception('Failed to update lab result: $e');
    }
  }

  Future<void> deleteLabResult(String id) async {
    try {
      await _supabase.from('lab_results').delete().eq('id', id);
    } catch (e) {
      throw Exception('Failed to delete lab result: $e');
    }
  }

  Future<LabResultModel?> getLabResultById(String id) async {
    try {
      final response = await _supabase
          .from('lab_results')
          .select()
          .eq('id', id)
          .single();

      return LabResultModel.fromMap(response);
    } catch (e) {
      throw Exception('Failed to fetch lab result: $e');
    }
  }

  Future<List<LabResultModel>> getLabResultsByDateRange(
    String userId,
    DateTime startDate,
    DateTime endDate,
  ) async {
    try {
      final response = await _supabase
          .from('lab_results')
          .select()
          .eq('user_id', userId)
          .gte('lab_date', startDate.toIso8601String().split('T')[0])
          .lte('lab_date', endDate.toIso8601String().split('T')[0])
          .order('lab_date', ascending: false);

      return (response as List)
          .map((json) => LabResultModel.fromMap(json))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch lab results by date range: $e');
    }
  }
}
