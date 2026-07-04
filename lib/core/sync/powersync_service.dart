import 'package:flutter/foundation.dart';
import 'package:gestanea/core/config/app_config.dart';
import 'package:gestanea/core/services/supabase_service.dart';
import 'package:gestanea/core/sync/powersync_schema.dart';
import 'package:gestanea/core/sync/supabase_connector.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:powersync/powersync.dart';

/// Long-lived holder for the PowerSync database + connector.
///
/// Lifecycle:
///   1. `init()` opens (or creates) the PowerSync local SQLite at
///      `<docs>/gestanea_powersync.db`.
///   2. `connect()` is called once the user signs in to Supabase. It
///      attaches the connector and starts streaming changes.
///   3. `disconnect()` is called on logout to stop syncing and forget
///      the cached credentials.
///
/// When `POWERSYNC_URL` is empty (default for unconfigured checkouts)
/// every method is a no-op so the app keeps running fully offline.
class PowerSyncService {
  PowerSyncService._();
  static final PowerSyncService instance = PowerSyncService._();

  PowerSyncDatabase? _db;
  bool _connected = false;

  bool get isReady => _db != null;
  bool get isConnected => _connected;

  /// Direct access — feature repositories that have migrated off the
  /// legacy DatabaseHelper write/read against this DB so PowerSync can
  /// pick up the changes via its local CRUD queue.
  PowerSyncDatabase get db {
    final d = _db;
    if (d == null) {
      throw StateError('PowerSyncService.init() must be called first');
    }
    return d;
  }

  Future<void> init() async {
    if (_db != null) return;
    if (!AppConfig.isPowerSyncConfigured) {
      debugPrint(
        'PowerSyncService: POWERSYNC_URL not set — sync disabled, '
        'app will run fully offline against legacy SQLite.',
      );
      return;
    }
    final dir = await getApplicationDocumentsDirectory();
    final path = p.join(dir.path, 'gestanea_powersync.db');
    _db = PowerSyncDatabase(schema: powerSyncSchema, path: path);
    await _db!.initialize();
  }

  /// Attach the Supabase connector and start syncing. Safe to call again
  /// (no-ops if already connected).
  Future<void> connect() async {
    if (_db == null || _connected) return;
    if (!SupabaseService.instance.isReady ||
        SupabaseService.instance.currentSession == null) {
      debugPrint('PowerSyncService.connect: no Supabase session — skipping');
      return;
    }
    final connector = SupabaseConnector(powerSyncUrl: AppConfig.powerSyncUrl);
    await _db!.connect(connector: connector);
    _connected = true;
  }

  Future<void> disconnect() async {
    if (_db == null || !_connected) return;
    await _db!.disconnect();
    _connected = false;
  }

  /// Drop the local PowerSync DB content. Call on hard logout if you
  /// want to ensure no synced rows linger on the device for the next
  /// account that signs in.
  Future<void> wipeLocal() async {
    if (_db == null) return;
    await _db!.disconnectAndClear();
    _connected = false;
  }
}
