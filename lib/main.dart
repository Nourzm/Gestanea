// lib/main.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:gestanea/core/services/notifications_service.dart';
import 'app.dart';

final RouteObserver<ModalRoute<void>> routeObserver =
    RouteObserver<ModalRoute<void>>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Best-effort init; failure must not block app launch (emulators without
  // notification support, denied permissions, etc.).
  unawaited(NotificationsService.instance.init());
  runApp(const MyApp());
}

