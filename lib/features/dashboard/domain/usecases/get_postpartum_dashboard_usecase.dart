// lib/features/dashboard/domain/usecases/get_postpartum_dashboard_usecase.dart
import '../entities/postpartum_dashboard.dart';

class GetPostpartumDashboardUseCase {
  // TODO: Inject repository when data layer is implemented
  
  Future<PostpartumDashboard> call() async {
    // TODO: Replace with actual data from repository
    // Mock data for now
    return PostpartumDashboard(
      userName: 'Sara',
      babyName: 'Emma',
      babyAgeInMonths: 3,
      babyWeight: 5.2,
      babyHeight: 58.0,
      growthStatus: 'On track',
      nextVaccines: [
        VaccineReminder(
          id: '1',
          vaccineName: 'DTaP',
          dueDate: DateTime.now().add(const Duration(days: 15)),
          isCompleted: false,
        ),
        VaccineReminder(
          id: '2',
          vaccineName: 'Polio',
          dueDate: DateTime.now().add(const Duration(days: 15)),
          isCompleted: false,
        ),
        VaccineReminder(
          id: '3',
          vaccineName: 'Hib',
          dueDate: DateTime.now().add(const Duration(days: 15)),
          isCompleted: false,
        ),
      ],
      todayFeedingSchedule:  FeedingSchedule(
        totalFeedings: 8,
        breastfeedCount: 5,
        bottleCount: 3,
        lastFeedingTime: DateTime(2025,0,0),
      ),
      motherHealthStatus: MotherHealthStatus(
        overallStatus: 'good',
        concerns: [],
        lastCheckup: DateTime.now().subtract(const Duration(days: 15)),
      ),
      tipOfTheDay: 'Tummy time helps strengthen baby\'s neck and back muscles. Start with 3-5 minutes.',
    );
  }
}