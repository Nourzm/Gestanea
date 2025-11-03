// lib/main.dart
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart'; // ✅ Add this
import 'package:gestanea/l10n/app_localizations.dart'; // ✅ Add this
import 'features/dashboard/presentation/pages/dashboard_page.dart';
import 'app.dart';
final RouteObserver<ModalRoute<void>> routeObserver =
    RouteObserver<ModalRoute<void>>();

void main() {
  runApp(const MyApp());
}
