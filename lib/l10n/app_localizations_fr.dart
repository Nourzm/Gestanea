// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'Soins de la Grossesse et du Bébé';

  @override
  String get welcome => 'Bienvenue';

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
  String get login => 'Connexion';

  @override
  String get forgot => 'Forgot Password?';

  @override
  String get notRegistered => 'Not registered yet?';

  @override
  String get createAccount => 'Create an Account';

  @override
  String get signup => 'S\'inscrire';

  @override
  String get your_name => 'Your Name';

  @override
  String get email => 'Email';

  @override
  String get enter_email => 'Enter your email';

  @override
  String get enter_name => 'Enter your Name';

  @override
  String get password => 'Mot de passe';

  @override
  String get rememberMe => 'Remember me';

  @override
  String get logout => 'Déconnexion';

  @override
  String get settings => 'Paramètres';

  @override
  String get language => 'Langue';

  @override
  String get darkMode => 'Mode Sombre';

  @override
  String get notifications => 'Notifications';

  @override
  String get help => 'Aide';

  @override
  String get about => 'À propos';

  @override
  String get version => 'Version';

  @override
  String get pregnant => 'Enceinte';

  @override
  String get postpartum => 'Après l\'accouchement';

  @override
  String week(int week) {
    return 'Semaine $week';
  }

  @override
  String daysLeft(int days) {
    return '$days jours restants';
  }
}
