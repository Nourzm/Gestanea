// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Pregnancy & Baby Care';

  @override
  String get welcome => 'Welcome';

  @override
  String get welcome_back => 'Welcome Back!';

  @override
  String get or => '— OR —';

  @override
  String get register => 'Register';

  @override
  String get auth => 'Your trusted companion for every stage of motherhood';

  @override
  String get auth2 =>
      'Let Gestanéa guide you through pregnancy, baby care, and beyond.';

  @override
  String get login => 'Login';

  @override
  String get forgot => 'Forgot Password?';

  @override
  String get notRegistered => 'Not registered yet?';

  @override
  String get createAccount => 'Create an Account';

  @override
  String get signup => 'Sign Up';

  @override
  String get your_name => 'Your Name';

  @override
  String get email => 'Email';

  @override
  String get enter_email => 'Enter your email';

  @override
  String get enter_name => 'Enter your Name';

  @override
  String get password => 'Password';

  @override
  String get rememberMe => 'Remember me';

  @override
  String get logout => 'Logout';

  @override
  String get settings => 'Settings';

  @override
  String get language => 'Language';

  @override
  String get darkMode => 'Dark Mode';

  @override
  String get notifications => 'Notifications';

  @override
  String get help => 'Help';

  @override
  String get about => 'About';

  @override
  String get version => 'Version';

  @override
  String get pregnant => 'Pregnant';

  @override
  String get postpartum => 'Postpartum';

  @override
  String week(int week) {
    return 'Week $week';
  }

  @override
  String daysLeft(int days) {
    return '$days days left';
  }
}
