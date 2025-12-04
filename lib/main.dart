// lib/main.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'app.dart';
import 'core/database/db_helper.dart';
import 'core/database/database_seeder.dart';
import 'core/utils/service_locator.dart';
import 'features/auth/logic/auth_cubit.dart';
import 'features/baby/logic/baby_cubit.dart';
import 'features/pregnancy/logic/pregnancy_cubit.dart';
import 'features/health/logic/health_cubit.dart';
import 'features/doctors/logic/doctors_cubit.dart';
import 'features/marketplace/logic/marketplace_cubit.dart';
import 'features/marketplace/logic/cart_cubit.dart';
import 'features/education/logic/education_cubit.dart';
import 'features/profile/logic/profile_cubit.dart';
import 'features/dashboard/logic/dashboard_cubit.dart';

final RouteObserver<ModalRoute<void>> routeObserver =
    RouteObserver<ModalRoute<void>>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize database
  await DatabaseHelper.instance.database;
  
  // Check if database is empty and seed if needed
  final isEmpty = await DatabaseHelper.instance.isDatabaseEmpty();
  if (isEmpty) {
    final seeder = DatabaseSeeder();
    await seeder.seedDatabase();
  }
  
  // Setup service locator
  await setupServiceLocator();
  
  runApp(const MyApp());
}
