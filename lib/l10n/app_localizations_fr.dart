// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'Grossesse et soins du bébé';

  @override
  String get welcome => 'Bienvenue';

  @override
  String get login => 'Connexion';

  @override
  String get signup => 'S\'inscrire';

  @override
  String get password => 'Mot de passe';

  @override
  String get logout => 'Déconnexion';

  @override
  String get settings => 'Paramètres';

  @override
  String get language => 'Langue';

  @override
  String get darkMode => 'Mode sombre';

  @override
  String get notifications => 'Notifications';

  @override
  String get help => 'Aide';

  @override
  String get about => 'À propos';

  @override
  String get welcome_back => 'Bon retour !';

  @override
  String get or => '— OU —';

  @override
  String get register => 'S\'inscrire';

  @override
  String get auth =>
      'Votre compagnon de confiance à chaque étape de la maternité';

  @override
  String get auth2 =>
      'Laissez Gestanéa vous guider pendant la grossesse, les soins du bébé et au-delà.';

  @override
  String get forgot => 'Mot de passe oublié ?';

  @override
  String get notRegistered => 'Pas encore inscrit ?';

  @override
  String get createAccount => 'Créer un compte';

  @override
  String get your_name => 'Votre nom';

  @override
  String get email => 'E-mail';

  @override
  String get enter_email => 'Entrez votre e-mail';

  @override
  String get enter_name => 'Entrez votre nom';

  @override
  String get rememberMe => 'Se souvenir de moi';

  @override
  String get version => 'Version';

  @override
  String get pregnant => 'Enceinte';

  @override
  String get postpartum => 'Postpartum';

  @override
  String week(int week) {
    return 'Semaine $week';
  }

  @override
  String daysLeft(int days) {
    return 'Il reste $days jours';
  }

  @override
  String get market => 'Marché';

  @override
  String get maternityWear => 'Vêtements de maternité';

  @override
  String get painRelief => 'Soulagement de la douleur';

  @override
  String get skinCare => 'Soins de la peau';

  @override
  String get pregnancyPillow => 'Coussin de grossesse';

  @override
  String get backSupportBelt => 'Ceinture de soutien dorsal';

  @override
  String get searchHint => 'Trouvez ce dont vous avez besoin...';

  @override
  String get dontMissOut => 'Ne ratez pas !';

  @override
  String get discountUpTo => 'Remise jusqu\'à 50%';

  @override
  String get upgradeNow => 'Améliorez maintenant';

  @override
  String get healthLog => 'Journal de santé';

  @override
  String get trackYourWellness => 'Suivez votre bien-être';

  @override
  String get vitals => 'Signes vitaux';

  @override
  String get symptoms => 'Symptômes';

  @override
  String get labResults => 'Résultats\nde laboratoire';

  @override
  String get riskAlerts => 'Alertes\nde risque';

  @override
  String get mood => 'Humeur';

  @override
  String get weight => 'Poids';

  @override
  String get heartRate => 'Fréquence cardiaque';

  @override
  String get bloodPressure => 'Tension artérielle';

  @override
  String get normal => 'Normal';

  @override
  String get add => 'Ajouter';

  @override
  String get measurement => 'Mesure';

  @override
  String get healthTipMessage =>
      'Bravo ! Vous maintenez un rythme de prise de poids sain. Continuez votre alimentation équilibrée et vos exercices doux.';

  @override
  String get onTrack => 'Sur la bonne voie';
}
