import 'package:get_it/get_it.dart';
import '../database/db_helper.dart';
import '../repositories/user_repository.dart';
import '../repositories/pregnancy_repository.dart';
import '../repositories/baby_repository.dart';
import '../repositories/health_repository.dart';
import '../repositories/feeding_repository.dart';
import '../repositories/growth_repository.dart';
import '../repositories/milestone_repository.dart';
import '../repositories/appointment_repository.dart';
import '../repositories/medicine_repository.dart';
import '../repositories/reminder_repository.dart';
import '../repositories/doctor_repository.dart';
import '../repositories/education_repository.dart';
import '../repositories/marketplace_repository.dart';
import '../repositories/risk_repository.dart';

final getIt = GetIt.instance;

Future<void> setupServiceLocator() async {
  // Database
  getIt.registerLazySingleton<DatabaseHelper>(() => DatabaseHelper.instance);

  // Repositories
  getIt.registerLazySingleton<UserRepository>(() => UserRepository());
  getIt.registerLazySingleton<PregnancyRepository>(() => PregnancyRepository());
  getIt.registerLazySingleton<BabyRepository>(() => BabyRepository());
  getIt.registerLazySingleton<HealthRepository>(() => HealthRepository());
  getIt.registerLazySingleton<FeedingRepository>(() => FeedingRepository());
  getIt.registerLazySingleton<GrowthRepository>(() => GrowthRepository());
  getIt.registerLazySingleton<MilestoneRepository>(() => MilestoneRepository());
  getIt.registerLazySingleton<AppointmentRepository>(() => AppointmentRepository());
  getIt.registerLazySingleton<MedicineRepository>(() => MedicineRepository());
  getIt.registerLazySingleton<ReminderRepository>(() => ReminderRepository());
  getIt.registerLazySingleton<DoctorRepository>(() => DoctorRepository());
  getIt.registerLazySingleton<EducationRepository>(() => EducationRepository());
  getIt.registerLazySingleton<MarketplaceRepository>(() => MarketplaceRepository());
  getIt.registerLazySingleton<RiskRepository>(() => RiskRepository());
}
