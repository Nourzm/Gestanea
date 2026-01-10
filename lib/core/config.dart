/// Configuration file for Gestanea app
///
/// Update the API_BASE_URL based on your environment:
/// - Android emulator: http://10.0.2.2:8000/api/v1
/// - iOS simulator: http://localhost:8000/api/v1
/// - Physical device: http://YOUR_COMPUTER_IP:8000/api/v1
/// - Production: https://your-api-domain.com/api/v1
class Config {
  // API Configuration
  static const String apiBaseUrl = 'http://10.0.2.2:8000/api/v1';

  // You can also use environment-based configuration:
  // static const String apiBaseUrl = String.fromEnvironment(
  //   'API_BASE_URL',
  //   defaultValue: 'http://10.0.2.2:8000/api/v1',
  // );

  // App Configuration
  static const String appName = 'Gestanea';

  // Other configuration values can go here
  static const int defaultPageSize = 100;
  static const Duration apiTimeout = Duration(seconds: 30);
}
