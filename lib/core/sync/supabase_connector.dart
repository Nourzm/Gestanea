import 'package:flutter/foundation.dart';
import 'package:gestanea/core/services/supabase_service.dart';
import 'package:http/http.dart' as http;
import 'package:powersync/powersync.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Bridges PowerSync to our Supabase project so:
///   - Reads: PowerSync pulls changes from the PowerSync sync service,
///     which itself watches Supabase via logical replication.
///   - Writes: when PowerSync flushes the local upload queue, this
///     connector replays each crud op against Supabase via the REST
///     client — every write inherits the caller's RLS policies.
///
/// Mirrors the canonical sample from PowerSync's Supabase guide.
class SupabaseConnector extends PowerSyncBackendConnector {
  final SupabaseService _supabase;
  final String powerSyncUrl;

  SupabaseConnector({
    required this.powerSyncUrl,
    SupabaseService? supabase,
  }) : _supabase = supabase ?? SupabaseService.instance;

  @override
  Future<PowerSyncCredentials?> fetchCredentials() async {
    final session = _supabase.currentSession;
    if (session == null) {
      throw Exception('Supabase user is not signed in — cannot fetch sync token');
    }
    return PowerSyncCredentials(
      endpoint: powerSyncUrl,
      token: session.accessToken,
      expiresAt: DateTime.fromMillisecondsSinceEpoch(
        (session.expiresAt ?? 0) * 1000,
      ),
    );
  }

  @override
  Future<void> uploadData(PowerSyncDatabase database) async {
    final batch = await database.getCrudBatch();
    if (batch == null) return;

    final client = _supabase.client;
    try {
      for (final op in batch.crud) {
        final table = client.from(op.table);
        switch (op.op) {
          case UpdateType.put:
            // PowerSync sends the full row map for puts.
            final row = Map<String, dynamic>.from(op.opData ?? {});
            row['id'] = op.id;
            await table.upsert(row);
            break;
          case UpdateType.patch:
            await table.update(op.opData ?? {}).eq('id', op.id);
            break;
          case UpdateType.delete:
            await table.delete().eq('id', op.id);
            break;
        }
      }
      await batch.complete();
    } on PostgrestException catch (e) {
      // Fatal codes (e.g. RLS denied) must NOT be retried forever — log,
      // mark complete, and surface to the user via UI elsewhere.
      final fatal = const {'23505', '42501', '23503'}.contains(e.code);
      if (fatal) {
        debugPrint('SupabaseConnector: dropping fatal CRUD op: ${e.code} ${e.message}');
        await batch.complete();
      } else {
        rethrow;
      }
    } on http.ClientException catch (e) {
      // Network blips: rethrow so PowerSync retries the same batch.
      debugPrint('SupabaseConnector: network error, will retry: $e');
      rethrow;
    }
  }
}
