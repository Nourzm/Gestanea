import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:gestanea/firebase_options.dart';
import 'app.dart';
import 'core/config/supabase_config.dart';
import 'core/services/connectivity_service.dart';
import 'core/services/notification_service.dart';
import 'core/services/alarm_scheduler.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

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

  // await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  // Load environment variables
  await dotenv.load(fileName: ".env");

  // Initialize connectivity service
  final connectivityService = ConnectivityService();
  await connectivityService.initialize();

  // Initialize notification service

  final notificationService = NotificationService();
  await notificationService.initialize();

  // Initialize alarm scheduler

  final alarmScheduler = AlarmScheduler();
  await alarmScheduler.initialize();

  // Initialize Supabase
  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL']!,
    anonKey: dotenv.env['SUPABASE_ANON_KEY']!,
  );

  runApp(const MyApp());
}
