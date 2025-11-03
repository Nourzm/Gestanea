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
  String get login => 'Login';

  @override
  String get signup => 'Sign Up';

  @override
  String get email => 'Email';

  @override
  String get password => 'Password';

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

  @override
  String get market => 'Market';

  @override
  String get maternityWear => 'Maternity Wear';

  @override
  String get painRelief => 'Pain Relief';

  @override
  String get skinCare => 'Skin Care';

  @override
  String get pregnancyPillow => 'Pregnancy Pillow';

  @override
  String get backSupportBelt => 'Back Support Belt';

  @override
  String get searchHint => 'Find what you need...';

  @override
  String get dontMissOut => 'Don\'t miss out!';

  @override
  String get discountUpTo => 'Discount up to 50%';

  @override
  String get upgradeNow => 'Upgrade Now';

  @override
  String get healthLog => 'Health Log';

  @override
  String get trackYourWellness => 'Track your wellness';

  @override
  String get vitals => 'Vitals';

  @override
  String get symptoms => 'Symptoms';

  @override
  String get labResults => 'Lab\nResults';

  @override
  String get riskAlerts => 'Risk\nAlerts';

  @override
  String get mood => 'Mood';

  @override
  String get weight => 'Weight';

  @override
  String get heartRate => 'Heart Rate';

  @override
  String get bloodPressure => 'Blood Pressure';

  @override
  String get normal => 'Normal';

  @override
  String get add => 'Add';

  @override
  String get measurement => 'Measurement';

  @override
  String get healthTipMessage =>
      'Great job! You\'re maintaining a healthy weight gain pace. Keep up with your balanced diet and gentle exercise routine.';

  @override
  String get onTrack => 'On Track';
}
