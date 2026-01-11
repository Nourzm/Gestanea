import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:gestanea/firebase_options.dart';
import 'app.dart';
import 'core/config/supabase_config.dart';
import 'core/services/connectivity_service.dart';
import 'core/services/notification_service.dart';

final RouteObserver<ModalRoute<void>> routeObserver =
    RouteObserver<ModalRoute<void>>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await NotificationService.instance.initialize();
  // Initialize Supabase
  try {
    await SupabaseConfig.initialize();
  } catch (e) {
    print('Error initializing Supabase: $e');
    // Continue app startup even if Supabase fails
  }

  // Initialize connectivity service
  try {
    final connectivityService = ConnectivityService();
    await connectivityService.initialize();
  } catch (e) {
    print('Error initializing ConnectivityService: $e');
  }

  

  runApp(const MyApp());
}
