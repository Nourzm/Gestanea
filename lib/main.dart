import 'package:flutter/material.dart';
import 'app.dart';
import 'core/config/supabase_config.dart';
import 'core/services/connectivity_service.dart';

final RouteObserver<ModalRoute<void>> routeObserver =
    RouteObserver<ModalRoute<void>>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Supabase
  await SupabaseConfig.initialize();

  // await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  // Initialize connectivity service
  final connectivityService = ConnectivityService();
  await connectivityService.initialize();
  runApp(const MyApp());
}
