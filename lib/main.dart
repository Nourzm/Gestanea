// lib/main.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:gestanea/core/services/notifications_service.dart';
import 'package:gestanea/core/services/supabase_service.dart';
import 'package:gestanea/core/sync/powersync_service.dart';
import 'app.dart';

final RouteObserver<ModalRoute<void>> routeObserver =
    RouteObserver<ModalRoute<void>>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Supabase MUST be initialised before MyApp so any provider that reads
  // `Supabase.instance` doesn't blow up. PowerSync also needs Supabase
  // to be ready before it can mint a sync token.
  await SupabaseService.instance.init();
  await PowerSyncService.instance.init();

  // If a session already exists from a previous launch, light up sync now.
  if (SupabaseService.instance.currentSession != null) {
    unawaited(PowerSyncService.instance.connect());
  }

  // Best-effort init; failure must not block app launch (emulators without
  // notification support, denied permissions, etc.).
  unawaited(NotificationsService.instance.init());
  runApp(const MyApp());
}

