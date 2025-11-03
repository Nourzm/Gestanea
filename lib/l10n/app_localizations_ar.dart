// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appTitle => 'رعاية الحمل والطفل';

  @override
  String get welcome => 'أهلا وسهلا';

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
  String get login => 'دخول';

  @override
  String get forgot => 'Forgot Password?';

  @override
  String get notRegistered => 'Not registered yet?';

  @override
  String get createAccount => 'Create an Account';

  @override
  String get signup => 'إنشاء حساب';

  @override
  String get your_name => 'Your Name';

  @override
  String get email => 'البريد الإلكتروني';

  @override
  String get enter_email => 'Enter your email';

  @override
  String get enter_name => 'Enter your Name';

  @override
  String get password => 'كلمة المرور';

  @override
  String get rememberMe => 'Remember me';

  @override
  String get logout => 'تسجيل الخروج';

  @override
  String get settings => 'الإعدادات';

  @override
  String get language => 'اللغة';

  @override
  String get darkMode => 'الوضع الليلي';

  @override
  String get notifications => 'الإشعارات';

  @override
  String get help => 'المساعدة';

  @override
  String get about => 'حول';

  @override
  String get version => 'الإصدار';

  @override
  String get pregnant => 'حامل';

  @override
  String get postpartum => 'ما بعد الولادة';

  @override
  String week(int week) {
    return 'الأسبوع $week';
  }

  @override
  String daysLeft(int days) {
    return '$days أيام متبقية';
  }
}
