// This file is disabled because supabase_flutter is not available in this branch
// TODO: Enable when supabase_flutter is added to pubspec.yaml

// import 'package:supabase_flutter/supabase_flutter.dart';
//
// /// Remote data source for dashboard data from Supabase
// class DashboardRemoteDataSource {
//   final SupabaseClient _client;
//
//   DashboardRemoteDataSource(this._client);
//
//   /// Fetch tips from Supabase
//   /// Returns list of tips matching the target audience and optionally week
//   Future<List<Map<String, dynamic>>> fetchTips({
//     required String targetAudience,
//     int? week,
//     int limit = 100,
//   }) async {
//     try {
//       var query = _client
//           .from('tips')
//           .select()
//           .eq('is_active', true)
//           .eq('target_audience', targetAudience);
//
//       // If week is provided, filter by pregnancy_week if the column exists
//       // Note: This assumes the tips table has a pregnancy_week column
//       // If not, this will be ignored
//       if (week != null) {
//         query = query.eq('pregnancy_week', week);
//       }
//
//       final response = await query.limit(limit);
//       return List<Map<String, dynamic>>.from(response);
//     } catch (e) {
//       print('Error fetching tips from Supabase: $e');
//       // Return empty list on error to allow offline fallback
//       return [];
//     }
//   }
//
//   /// Sync tips: fetch all active tips and return them
//   Future<List<Map<String, dynamic>>> syncTips() async {
//     try {
//       final response = await _client
//           .from('tips')
//           .select()
//           .eq('is_active', true)
//           .order('created_at', ascending: false);
//
//       return List<Map<String, dynamic>>.from(response);
//     } catch (e) {
//       print('Error syncing tips from Supabase: $e');
//       return [];
//     }
//   }
// }
