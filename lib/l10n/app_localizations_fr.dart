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
  String get login => 'Connexion';

  @override
  String get signup => 'S\'inscrire';

  @override
  String get email => 'Email';

  @override
  String get password => 'Mot de passe';

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
  String get postpartum => 'Post-partum';

  @override
  String week(int week) {
    return 'Semaine $week';
  }

  @override
  String daysLeft(int days) {
    return '$days jours restants';
  }

  @override
  String get market => 'Marché';

  @override
  String get maternityWear => 'Vêtements de Maternité';

  @override
  String get painRelief => 'Soulagement de la Douleur';

  @override
  String get skinCare => 'Soins de la Peau';

  @override
  String get pregnancyPillow => 'Oreiller de Grossesse';

  @override
  String get backSupportBelt => 'Ceinture de Soutien Dorsal';

  @override
  String get searchHint => 'Trouvez ce dont vous avez besoin...';

  @override
  String get dontMissOut => 'Ne manquez pas!';

  @override
  String get discountUpTo => 'Réduction jusqu\'à 50%';

  @override
  String get upgradeNow => 'Mettre à niveau maintenant';

  @override
  String get healthLog => 'Journal de Santé';

  @override
  String get trackYourWellness => 'Suivez votre bien-être';

  @override
  String get vitals => 'Signes Vitaux';

  @override
  String get symptoms => 'Symptômes';

  @override
  String get labResults => 'Résultats Labo';

  @override
  String get riskAlerts => 'Alertes Risque';

  @override
  String get mood => 'Humeur';

  @override
  String get weight => 'Poids';

  @override
  String get heartRate => 'Rythme Cardiaque';

  @override
  String get bloodPressure => 'Tension Artérielle';

  @override
  String get normal => 'Normal';

  @override
  String get add => 'Ajouter';

  @override
  String get measurement => 'Mesure';

  @override
  String get healthTipMessage =>
      'Excellent travail! Vous maintenez un rythme de prise de poids sain. Continuez avec votre alimentation équilibrée et vos exercices doux.';

  @override
  String get onTrack => 'Sur la Bonne Voie';
}
