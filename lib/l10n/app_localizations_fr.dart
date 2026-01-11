// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get locationPermissionRequired =>
      'Autorisation de localisation requise';

  @override
  String get locationPermissionMessage =>
      'Nous avons besoin d\'accéder à votre localisation pour afficher les médecins à proximité.';

  @override
  String get gettingLocation => 'Obtention de votre position...';

  @override
  String get locationPermissionDenied => 'Autorisation de localisation refusée';

  @override
  String get locationUpdated => 'Localisation mise à jour';

  @override
  String get retry => 'Réessayer';

  @override
  String get showingDoctorsNearYou =>
      'Affichage des médecins près de chez vous';

  @override
  String get selectLocation => 'Sélectionner l\'emplacement';

  @override
  String get searchWilaya => 'Rechercher une wilaya...';

  @override
  String get security => 'Sécurité';

  @override
  String get i_gave_birth => 'J\'ai accouché';

  @override
  String get no_longer_pregnant => 'Je ne suis plus enceinte';

  @override
  String get help_support => 'Aide & Support';

  @override
  String get contact_us => 'Contactez-nous';

  @override
  String get privacy_policy => 'Politique de confidentialité';

  @override
  String get about_app => 'À propos de l\'application';

  @override
  String get change => 'Modifier';

  @override
  String get save => 'Enregistrer';

  @override
  String get save_changes => 'Enregistrer les modifications';

  @override
  String get logout_confirmation => 'Voulez-vous vraiment vous déconnecter ? ';

  @override
  String get cancel => 'Annuler';

  @override
  String get unknown => 'Inconnu';

  @override
  String get profile => 'Profil';

  @override
  String get profile_updated => 'Profil mis à jour';

  @override
  String get edit_profile => 'Modifier le profil';

  @override
  String get change_profile_photo => 'Changer la photo de profil';

  @override
  String get full_name => 'Nom complet';

  @override
  String get enable_notifications => 'Activer les notifications';

  @override
  String get phone => 'Téléphone';

  @override
  String get country => 'Pays';

  @override
  String get plan => 'Plan';

  @override
  String get sundayShort => 'D';

  @override
  String get mondayShort => 'L';

  @override
  String get tuesdayShort => 'M';

  @override
  String get wednesdayShort => 'M';

  @override
  String get thursdayShort => 'J';

  @override
  String get fridayShort => 'V';

  @override
  String get saturdayShort => 'S';

  @override
  String get todaysMedicine => 'Médicaments du jour';

  @override
  String get upcomingAppointments => 'Rendez-vous à venir';

  @override
  String get scheduled => 'Prévu';

  @override
  String get addNewMedicine => 'Ajouter un médicament';

  @override
  String get addNewAppointment => 'Ajouter un rendez-vous';

  @override
  String get medicine => 'Médicaments';

  @override
  String get appointments => 'Rendez-vous';

  @override
  String get appointmentName => 'Nom du rendez-vous';

  @override
  String get medicationName => 'Nom du médicament';

  @override
  String get nextLabel => 'Suivant';

  @override
  String get doneLabel => 'Terminé';

  @override
  String get uploadPicture => 'Télécharger une photo';

  @override
  String get camera => 'Caméra';

  @override
  String get gallery => 'Galerie';

  @override
  String get removeImage => 'Supprimer l\'image';

  @override
  String get tapToAddPicture => 'Appuyez pour ajouter une photo';

  @override
  String get optionalImageNote =>
      'L\'ajout d\'une photo est facultatif. Vous pouvez ignorer cette étape.';

  @override
  String get selectFormDose => 'Choisir la forme et la dose';

  @override
  String get frequencySchedule => 'Fréquence et programme';

  @override
  String get frequencyType => 'Type de fréquence';

  @override
  String get frequencyValue => 'Valeur de la fréquence';

  @override
  String get scheduledTimesLabel => 'Heures planifiées';

  @override
  String get asNeeded => 'Selon les besoins';

  @override
  String get dosage => 'Dosage';

  @override
  String get dosageExample => 'ex.: 5 mg ou 10 ml';

  @override
  String get formPill => 'Comprimé';

  @override
  String get formInjection => 'Injection';

  @override
  String get formSpray => 'Spray';

  @override
  String get formDrop => 'Goutte';

  @override
  String get formSyrup => 'Sirop';

  @override
  String get formOthers => 'Autres';

  @override
  String medicinesTaken(int taken, int total) {
    return '$taken sur $total pris';
  }

  @override
  String get daily => 'Quotidien';

  @override
  String get weekly => 'Hebdomadaire';

  @override
  String get monthly => 'Mensuel';

  @override
  String get timesPerDayExample => 'ex.: 3 (fois par jour)';

  @override
  String get timesPerWeekExample => 'ex.: 2 (fois par semaine)';

  @override
  String get timesPerMonthExample => 'ex.: 1 (fois par mois)';

  @override
  String get appointmentDateTime => 'Date et heure du rendez-vous';

  @override
  String get appointmentLocation => 'Lieu du rendez-vous';

  @override
  String get selectDate => 'Sélectionner la date';

  @override
  String get selectTime => 'Sélectionner l\'heure';

  @override
  String get startDate => 'Date de début';

  @override
  String get endDate => 'Date de fin (Optionnel)';

  @override
  String get selectStartDate => 'Sélectionner la date de début';

  @override
  String get selectEndDate => 'Sélectionner la date de fin';

  @override
  String get addTime => 'Ajouter l\'heure';

  @override
  String get noScheduledTimesAdded => 'Aucune heure planifiée ajoutée';

  @override
  String get today => 'Aujourd\'hui';

  @override
  String get tomorrow => 'Demain';

  @override
  String get noAppointmentsFound => 'Aucun rendez-vous trouvé';

  @override
  String get appointment => 'Rendez-vous';

  @override
  String get pleaseAddScheduledTime =>
      'Veuillez ajouter au moins une heure planifiée';

  @override
  String reviewsCount(Object count) {
    return '$count avis';
  }

  @override
  String get qty => 'Qté';

  @override
  String get noMedicines => 'Aucun médicament';

  @override
  String get schedule => 'Programme';

  @override
  String get availability => 'Disponibilité';

  @override
  String get specialty => 'Spécialité';

  @override
  String get bookAppointment => 'Réserver un rendez-vous';

  @override
  String get price => 'Prix';

  @override
  String get quantity => 'Quantité';

  @override
  String get checkout => 'Paiement';

  @override
  String get applyCoupon => 'Appliquer un coupon';

  @override
  String get popular => 'Populaire';

  @override
  String get offers => 'Offres';

  @override
  String get newLabel => 'Nouveau';

  @override
  String get contact => 'Contact';

  @override
  String get message => 'Message';

  @override
  String get location => 'Localisation';

  @override
  String get noResults => 'Aucun résultat';

  @override
  String get search => 'Recherche';

  @override
  String get sort => 'Trier';

  @override
  String get marketplace => 'Boutique';

  @override
  String get doctorsFeatureTitle => 'Médecins';

  @override
  String get planFeatureTitle => 'Plan';

  @override
  String get addMedicine => 'Ajouter un médicament';

  @override
  String get addAppointment => 'Ajouter un rendez-vous';

  @override
  String get error => 'Erreur';

  @override
  String get success => 'Succès';

  @override
  String get confirm => 'Confirmer';

  @override
  String get remove => 'Supprimer';

  @override
  String get apply => 'Appliquer';

  @override
  String get reviewsLabel => 'Avis';

  @override
  String get rating => 'Note';

  @override
  String get recommended => 'Recommandé';

  @override
  String get noReviews => 'Aucun avis';

  @override
  String get delivery => 'Livraison';

  @override
  String get shipping => 'Expédition';

  @override
  String get taxes => 'Taxes';

  @override
  String get sunday => 'Dimanche';

  @override
  String get monday => 'Lundi';

  @override
  String get tuesday => 'Mardi';

  @override
  String get wednesday => 'Mercredi';

  @override
  String get thursday => 'Jeudi';

  @override
  String get friday => 'Vendredi';

  @override
  String get saturday => 'Samedi';

  @override
  String get jan => 'Janv';

  @override
  String get feb => 'Févr';

  @override
  String get mar => 'Mars';

  @override
  String get apr => 'Avr';

  @override
  String get may => 'Mai';

  @override
  String get jun => 'Juin';

  @override
  String get jul => 'Juil';

  @override
  String get aug => 'Août';

  @override
  String get sep => 'Sept';

  @override
  String get oct => 'Oct';

  @override
  String get nov => 'Nov';

  @override
  String get dec => 'Déc';

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
  String get welcome_back => 'Bon retour ! ';

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
  String get sendOtp => 'Envoyer le code';

  @override
  String get verifyOtp => 'Vérifier le code';

  @override
  String get enterOtpCode => 'Entrez le code de vérification';

  @override
  String get otpSent => 'Code de vérification envoyé à votre email';

  @override
  String get otpCodePlaceholder => 'Code à 6 chiffres';

  @override
  String get resendOtp => 'Renvoyer le code';

  @override
  String get noInternetConnection =>
      'Pas de connexion Internet. Veuillez vérifier votre réseau et réessayer.';

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
  String get searchHint => 'Trouvez ce dont vous avez besoin.. .';

  @override
  String get dontMissOut => 'Ne ratez pas ! ';

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

  @override
  String get moodTab => 'Humeur';

  @override
  String get recentEntries => 'Entrées récentes';

  @override
  String get howAreYouFeelingToday => 'Comment vous sentez-vous aujourd\'hui ?';

  @override
  String get feltEnergeticToday => 'Je me suis senti énergique aujourd\'hui';

  @override
  String hoursAgo(int hours) {
    return 'il y a $hours heures';
  }

  @override
  String get calm => 'Calme';

  @override
  String get relaxingEvening => 'Soirée relaxante';

  @override
  String get yesterday => 'Hier';

  @override
  String get tired => 'Fatigué(e)';

  @override
  String get needMoreSleep => 'Besoin de plus de sommeil';

  @override
  String daysAgo(int days) {
    return 'il y a $days jours';
  }

  @override
  String get trackingMoodHelps =>
      'Suivre votre humeur vous aide à comprendre votre bien-être.';

  @override
  String get great => 'Super';

  @override
  String get good => 'Bien';

  @override
  String get okay => 'Moyen';

  @override
  String get moodTrendsLast7Days => 'Tendances de l\'humeur (7 derniers jours)';

  @override
  String get mostlyPositiveMoods => 'Humeurs majoritairement positives';

  @override
  String get selfCareSuggestions => 'Suggestions d\'auto-soin';

  @override
  String get takeShortWalk => 'Faire une courte promenade';

  @override
  String get practiceDeepBreathing => 'Pratiquer la respiration profonde';

  @override
  String get listenToCalmingMusic => 'Écouter de la musique apaisante';

  @override
  String get connectWithLovedOnes => 'Se connecter avec ses proches';

  @override
  String get doctors => 'Médecins';

  @override
  String get findDoctors => 'trouver des médecins par nom ou spécialité';

  @override
  String get useCurrentLocation => 'Utiliser ma position actuelle';

  @override
  String get doctorsFoundSingle => '1 Médecin Trouvé';

  @override
  String doctorsFoundPlural(int count) {
    return '$count Médecins Trouvés';
  }

  @override
  String get filter => 'Filtrer';

  @override
  String get filterDoctors => 'Filtrer les médecins';

  @override
  String get clearAll => 'Tout effacer';

  @override
  String get maximumDistance => 'Distance maximale';

  @override
  String upToKm(String distance) {
    return 'Jusqu\'à $distance km';
  }

  @override
  String get minimumRating => 'Évaluation minimale';

  @override
  String ratingAndAbove(String rating) {
    return '$rating et plus';
  }

  @override
  String get gender => 'Genre';

  @override
  String get male => 'Homme';

  @override
  String get female => 'Femme';

  @override
  String get minimumReviews => 'Avis minimum';

  @override
  String atLeastReviews(int count) {
    return 'Au moins $count avis';
  }

  @override
  String get applyFilters => 'Appliquer les filtres';

  @override
  String kmAway(String distance) {
    return 'à $distance km';
  }

  @override
  String get reviews => 'avis';

  @override
  String get noDoctorsFound => 'Aucun médecin trouvé';

  @override
  String noMatchingDoctors(String query) {
    return 'Aucun médecin ne correspond à \"$query\"';
  }

  @override
  String get tryAdjustingFilters => 'Essayez d\'ajuster vos filtres';

  @override
  String get doctorDetails => 'Détails du médecin';

  @override
  String get couldNotOpenMaps => 'Impossible d\'ouvrir les cartes';

  @override
  String get phoneNumberNotAvailable => 'Numéro de téléphone non disponible';

  @override
  String get couldNotMakePhoneCall =>
      'Impossible de passer l\'appel téléphonique';

  @override
  String get gynecologist => 'Gynécologue';

  @override
  String get pediatrician => 'Pédiatre';

  @override
  String get obstetrician => 'Obstétricien';

  @override
  String get generalPractitioner => 'Médecin généraliste';

  @override
  String get getDirections => 'Obtenir l\'itinéraire';

  @override
  String get contactInformation => 'Informations de contact';

  @override
  String get address => 'Adresse';

  @override
  String get phoneNumber => 'Numéro de téléphone';

  @override
  String get openingHours => 'Heures d\'ouverture';

  @override
  String get callNow => 'Appeler maintenant';

  @override
  String get all => 'Tous';

  @override
  String get taken => 'Pris';

  @override
  String get missed => 'Manqué';

  @override
  String get take => 'Prendre';

  @override
  String get noMedicinesFound => 'Aucun médicament trouvé';

  @override
  String get pleaseLoginToViewPlan =>
      'Veuillez vous connecter pour voir votre plan';

  @override
  String get selectColor => 'Sélectionnez la couleur';

  @override
  String get selectSize => 'Sélectionnez la taille';

  @override
  String get addToCart => 'Ajouter au panier';

  @override
  String get buyNow => 'Acheter maintenant';

  @override
  String get description => 'Description';

  @override
  String get noDescriptionAvailable => 'Aucune description disponible';

  @override
  String get specifications => 'Spécifications';

  @override
  String get customerReviews => 'Avis des clientes';

  @override
  String get seeAll => 'voir tout';

  @override
  String get completeYourOrder => 'Complétez votre commande';

  @override
  String get orderSummary => 'Résumé de la commande';

  @override
  String get product => 'Produit';

  @override
  String get size => 'Taille';

  @override
  String get subtotal => 'Sous-total';

  @override
  String get deliveryFee => 'Frais de livraison';

  @override
  String get total => 'Total';

  @override
  String get deliveryInformation => 'Informations de livraison';

  @override
  String get fullName => 'Nom complet';

  @override
  String get enterYourFullName => 'Entrez votre nom complet';

  @override
  String get enterYourPhoneNumber => 'Entrez votre numéro de téléphone';

  @override
  String get deliveryAddress => 'Adresse de livraison';

  @override
  String get streetAddressApartment => 'Adresse, appartement, etc.';

  @override
  String get city => 'Ville';

  @override
  String get enterYourCity => 'Entrez votre ville';

  @override
  String get specialInstructions => 'Instructions spéciales (Facultatif)';

  @override
  String get addDeliveryNotes =>
      'Ajoutez des notes de livraison, demandes spéciales...';

  @override
  String get paymentMethod => 'Méthode de paiement';

  @override
  String get cashOnDelivery => 'Paiement à la livraison';

  @override
  String get creditDebitCard => 'Carte de crédit / débit';

  @override
  String get digitalWallet => 'Portefeuille numérique';

  @override
  String get placeOrder => 'Passer la commande';

  @override
  String orderPlacedSuccessfully(String orderId) {
    return 'Commande $orderId passée avec succès !';
  }

  @override
  String get yourInformationIsSecure =>
      'Vos informations sont sécurisées et cryptées';

  @override
  String get openNow => 'Ouvert maintenant';

  @override
  String get nausea => 'Nausea';

  @override
  String get headache => 'Headache';

  @override
  String get backPain => 'Back pain';

  @override
  String get swelling => 'Swelling';

  @override
  String get fatigue => 'Fatigue';

  @override
  String get dizziness => 'Dizziness';

  @override
  String get heartburn => 'Heartburn';

  @override
  String get legCramps => 'Leg cramps';

  @override
  String get other => 'Other';

  @override
  String get pleaseSelectSymptom => 'Please select a symptom';

  @override
  String get pleaseSelectSeverity => 'Please select severity';

  @override
  String get symptomLoggedSuccessfully => 'Symptom logged successfully!';

  @override
  String get addSymptom => 'Add Symptom';

  @override
  String get symptomType => 'Symptom type';

  @override
  String get selectSymptom => 'Select symptom';

  @override
  String get specifySymptom => 'Specify symptom';

  @override
  String get pleaseSpecifySymptom => 'Please specify the symptom';

  @override
  String get severity => 'Severity';

  @override
  String get mild => 'Mild';

  @override
  String get moderate => 'Moderate';

  @override
  String get severe => 'Severe';

  @override
  String get duration => 'Duration';

  @override
  String get pleaseEnterDuration => 'Please enter duration';

  @override
  String get notes => 'Notes';

  @override
  String get veryHappy => 'Très heureux(se)';

  @override
  String get happy => 'Heureux(se)';

  @override
  String get neutral => 'Neutre';

  @override
  String get sad => 'Triste';

  @override
  String get verySad => 'Très triste';

  @override
  String get pleaseSelectMood => 'Veuillez sélectionner une humeur';

  @override
  String get moodLoggedSuccessfully => 'Humeur enregistrée avec succès !';

  @override
  String get howAreYouFeeling => 'Comment vous sentez-vous ?';

  @override
  String get energyLevel => 'Niveau d\'énergie';

  @override
  String get low => 'Faible';

  @override
  String get high => 'Élevé';

  @override
  String get sleepQuality => 'Qualité du sommeil';

  @override
  String get howWasYourDay => 'Comment s\'est passée votre journée ?';

  @override
  String get prePregnancyBMI => 'Pre-pregnancy BMI';

  @override
  String get normalBMI => 'Normal';

  @override
  String get currentGain => 'Current gain';

  @override
  String get targetRange => 'Target range';

  @override
  String get expected => 'Expected';

  @override
  String get recentLabResults => 'Recent Lab Results';

  @override
  String get keepLabResultsOrganized =>
      'Keep your lab results organized for better tracking.';

  @override
  String get viewAllLabResults => 'View All Lab Results';

  @override
  String get riskFactorsToMonitor => 'Risk factors to monitor';

  @override
  String get lowRisk => 'Faible risque';

  @override
  String get withinNormalRange => 'Dans la plage normale';

  @override
  String get gestationalDiabetes => 'Diabète gestationnel';

  @override
  String get glucoseLevelsNormal => 'Les niveaux de glucose sont normaux';

  @override
  String get preeclampsia => 'Prééclampsie';

  @override
  String get noProteinInUrine => 'Aucune protéine dans les urines';

  @override
  String get warningSignsToWatch => 'Signes d\'alerte à surveiller';

  @override
  String get severeHeadache => 'Forte migraine';

  @override
  String get blurredVision => 'Vision trouble';

  @override
  String get severeAbdominalPain => 'Douleur abdominale sévère';

  @override
  String get decreasedFetalMovement => 'Mouvements fœtaux diminués';

  @override
  String get vaginalBleeding => 'Saignement vaginal';

  @override
  String get emergencyCall => 'Appel d\'urgence';

  @override
  String get areYouSureCall911 => 'Êtes-vous sûr de vouloir appeler le 911 ?';

  @override
  String get couldNotMakeEmergencyCall =>
      'Impossible de passer l\'appel d\'urgence.';

  @override
  String get ifYouExperienceWarnings =>
      'Si vous ressentez un signe d\'alerte, contactez immédiatement votre professionnel de santé.';

  @override
  String get allIndicatorsNormal => 'Tous les indicateurs sont normaux';

  @override
  String get emergencyContact => 'Contact d\'urgence';

  @override
  String get overallRiskLevel => 'Niveau de risque global';

  @override
  String get call911OrProvider =>
      'Appelez le 911 ou votre professionnel de santé';

  @override
  String get recentSymptoms => 'Recent Symptoms';

  @override
  String get logNewSymptom => 'Log new symptom';

  @override
  String get symptomFrequency => 'Symptom frequency';

  @override
  String get swollenFeet => 'Swollen feet';

  @override
  String get sleepIssues => 'Sleep issues';

  @override
  String get times => 'times';

  @override
  String get commonSymptomsWeek24 =>
      'Common symptoms at week 24 include back pain and swelling.';

  @override
  String get viewAllSymptoms => 'View All Symptoms';

  @override
  String get weightProgress => 'Weight Progress';

  @override
  String get measurementSavedSuccessfully => 'Measurement saved successfully!';

  @override
  String get addMeasurement => 'Add Measurement';

  @override
  String get weightKg => 'Weight (kg)';

  @override
  String get pleaseEnterWeight => 'Please enter your weight';

  @override
  String get pleaseEnterValidNumber => 'Please enter a valid number';

  @override
  String get weightRange => 'Weight must be between 30 and 200 kg';

  @override
  String get heartRateBpm => 'Heart Rate (bpm)';

  @override
  String get pleaseEnterHeartRate => 'Please enter your heart rate';

  @override
  String get heartRateRange => 'Heart rate must be between 40 and 200 bpm';

  @override
  String get systolic => 'Systolique';

  @override
  String get required => 'Required';

  @override
  String get invalid => 'Invalid';

  @override
  String get systolicRange => 'Systolic must be between 70 and 190';

  @override
  String get diastolic => 'Diastolique';

  @override
  String get diastolicRange => 'Diastolic must be between 40 and 130';

  @override
  String get normalRangeLabel => 'Normal range';

  @override
  String get uploadLabResults => 'Upload Lab Results';

  @override
  String get nextLabAppointment => 'Next Lab Appointment';

  @override
  String get navHome => 'Accueil';

  @override
  String get navTrack => 'Suivre';

  @override
  String get navHealth => 'Santé';

  @override
  String get navPlan => 'Plan';

  @override
  String get navMarket => 'Marché';

  @override
  String get hello => 'Bonjour';

  @override
  String get done => 'FAIT';

  @override
  String get daysToGo => 'JOURS RESTANTS';

  @override
  String get weekLabel => 'SEMAINE';

  @override
  String get day => 'jour';

  @override
  String get days => 'jours';

  @override
  String get more => 'Plus';

  @override
  String get ourTips => 'Nos Conseils';

  @override
  String get followBestPractices => 'suivre les meilleures pratiques';

  @override
  String get ourDoctors => 'Nos médecins';

  @override
  String get findTheBestDoctor => 'trouver le meilleur médecin';

  @override
  String get upComing => 'À venir';

  @override
  String get noUpcomingEvents => 'Aucun événement à venir';

  @override
  String get addAppointmentsInPlan => 'Ajouter des rendez-vous dans le Plan';

  @override
  String get overdue => 'En retard';

  @override
  String inMinutes(int minutes) {
    return 'Dans $minutes minutes';
  }

  @override
  String inHours(int hours) {
    return 'Dans $hours heures';
  }

  @override
  String todayAt(String time) {
    return 'Aujourd\'hui à $time';
  }

  @override
  String tomorrowAt(String time) {
    return 'Demain à $time';
  }

  @override
  String get at => 'à';

  @override
  String get myMoods => 'Mes humeurs';

  @override
  String get noMoodsLoggedYet => 'Aucune humeur enregistrée !';

  @override
  String get tapLogMoodToStart =>
      'Appuyez sur \"Enregistrer l\'humeur\" pour commencer.';

  @override
  String get noData => 'Aucune donnée';

  @override
  String get pleaseLogInToSaveMood =>
      'Veuillez vous connecter pour enregistrer l\'humeur';

  @override
  String get mySymptoms => 'Mes symptômes';

  @override
  String get tapLogNewSymptomToStart =>
      'Appuyez sur \"Enregistrer un nouveau symptôme\" pour commencer.';

  @override
  String get myMeasurements => 'Mes mesures';

  @override
  String get tapAddMeasurementToStart =>
      'Appuyez sur \"Ajouter une mesure\" pour commencer.';

  @override
  String get myLabResults => 'Mes résultats de laboratoire';

  @override
  String get uploadFirstLabResult =>
      'Téléchargez votre premier résultat de laboratoire pour commencer.';

  @override
  String get labPapersGallery => 'Galerie de documents de laboratoire';

  @override
  String get uploadLabReportsToSee =>
      'Téléchargez des rapports de laboratoire pour les voir ici';

  @override
  String get exportingLabPapers => 'Export des documents de laboratoire...';

  @override
  String get healthRiskAssessment => 'Évaluation des risques de santé';

  @override
  String get analyzingYourHealthData => 'Analyse de vos données de santé...';

  @override
  String get unableToAssessRisk => 'Impossible d\'évaluer le risque';

  @override
  String get noAssessmentAvailable => 'Aucune évaluation disponible';

  @override
  String get viewAllMeasurements => 'Voir toutes les mesures';

  @override
  String get viewAllMoods => 'Voir toutes les humeurs';

  @override
  String get viewAllLabPapers => 'Afficher tous les documents de laboratoire';

  @override
  String get noWeightDataAvailable => 'Aucune donnée de poids disponible';

  @override
  String get monitor => 'Surveiller';

  @override
  String get cameraPermissionDenied => 'Permission de caméra refusée';

  @override
  String get photosPermissionDenied => 'Permission de photos refusée';

  @override
  String failedToPickImage(String error) {
    return 'Échec de la sélection de l\'image : $error';
  }

  @override
  String failedToPickPDF(String error) {
    return 'Échec de la sélection du PDF : $error';
  }

  @override
  String get reviewEditLabResults =>
      'Réviser et modifier les résultats de laboratoire';

  @override
  String get imageNotAvailable => 'Image non disponible';

  @override
  String get addTest => 'Ajouter un test';

  @override
  String saveResults(int count) {
    return 'Enregistrer $count résultat(s)';
  }

  @override
  String get labResultsSavedSuccessfully =>
      'Résultats de laboratoire enregistrés avec succès !';

  @override
  String failedToSaveResults(String error) {
    return 'Échec de l\'enregistrement des résultats : $error';
  }

  @override
  String get noResultsToSave => 'Aucun résultat à enregistrer';

  @override
  String get pdfLabReport => 'Rapport de laboratoire PDF';

  @override
  String get savePDFReference => 'Enregistrer la référence PDF';

  @override
  String get enterDataManually => 'Saisir les données manuellement';

  @override
  String get pdfSavedAndUploaded => 'PDF enregistré et téléchargé !';

  @override
  String failedToSavePDF(String error) {
    return 'Échec de l\'enregistrement du PDF : $error';
  }

  @override
  String get extractLabResults => 'Extraire les résultats de laboratoire';

  @override
  String get extractingTextFromImage => 'Extraction du texte de l\'image...';

  @override
  String get viewRawText => 'Voir le texte brut';

  @override
  String get noDataExtracted => 'Aucune donnée extraite';

  @override
  String get saveImageOnly => 'Enregistrer uniquement l\'image';

  @override
  String get imageSaved =>
      'Image enregistrée ! Vous pouvez ajouter des détails plus tard.';

  @override
  String get enterManually => 'Saisir manuellement';

  @override
  String get noImageSaved => 'Aucune image enregistrée. Veuillez réessayer.';

  @override
  String get manualLabEntry => 'Saisie manuelle de laboratoire';

  @override
  String get labResultAddedSuccessfully =>
      'Résultat de laboratoire ajouté avec succès !';

  @override
  String get exporting => 'Exportation...';

  @override
  String get labResultImage => 'Image du résultat de laboratoire';

  @override
  String get deleteResult => 'Supprimer le résultat';

  @override
  String areYouSureDeleteResult(String testName) {
    return 'Êtes-vous sûr de vouloir supprimer $testName ?';
  }

  @override
  String get delete => 'Supprimer';

  @override
  String get exportLabResults => 'Exporter les résultats de laboratoire';

  @override
  String get exportAllLabResultsAsZIP =>
      'Exporter toutes les images de résultats de laboratoire dans un fichier ZIP ?';

  @override
  String get export => 'Exporter';

  @override
  String get labResultUpdatedSuccessfully =>
      'Résultat de laboratoire mis à jour avec succès';

  @override
  String errorUpdatingResult(String error) {
    return 'Erreur lors de la mise à jour du résultat : $error';
  }

  @override
  String get editLabResult => 'Modifier le résultat de laboratoire';

  @override
  String errorCallingContact(String contactName, String error) {
    return 'Erreur lors de l\'appel de $contactName : $error';
  }

  @override
  String get iDontNeedThisContact => 'Je n\'ai pas besoin de ce contact';

  @override
  String get saveEmergencyContacts => 'Enregistrer';

  @override
  String get setupEmergencyContacts => 'Configurer les contacts d\'urgence';

  @override
  String get setupContactsDescription =>
      'Ajoutez des contacts d\'urgence pour un accès rapide en cas de situations urgentes.';

  @override
  String get partner => 'Partenaire';

  @override
  String get healthcareProvider => 'Fournisseur de soins de santé';

  @override
  String get parent => 'Parent/Famille';

  @override
  String get actionNeeded => 'ACTION REQUISE';

  @override
  String get detectedPatterns => 'Schémas détectés';

  @override
  String get recommendations => 'Recommandations';

  @override
  String get aiAnalysis => 'Analyse IA';

  @override
  String get aiRiskAssessmentDisclaimer =>
      '⚠️ Évaluation des risques générée par l\'IA. Ce n\'est pas un diagnostic médical. Consultez toujours votre professionnel de la santé pour toute préoccupation.';

  @override
  String get riskLevel => 'RISQUE';

  @override
  String get none => 'AUCUN';

  @override
  String get normalRisk => 'Normal';

  @override
  String get lowRiskLevel => 'Faible';

  @override
  String get mediumRisk => 'Moyen';

  @override
  String get highRisk => 'Élevé';

  @override
  String get urgentRisk => 'Urgent';

  @override
  String get noSignificantConcerns => 'Aucune préoccupation significative';

  @override
  String get heartRateProgress => 'Progression de la fréquence cardiaque';

  @override
  String get bloodPressureTrend => 'Tendance de la pression artérielle';

  @override
  String get noSymptomLogged => 'Aucun symptôme enregistré';

  @override
  String get noMoodsLogged => 'Aucune humeur enregistrée';

  @override
  String get noLabResultsYet => 'Aucun résultat de laboratoire pour le moment';

  @override
  String get lowStatus => 'Bas';

  @override
  String get highStatus => 'Élevé';

  @override
  String get noSymptomDataAvailable => 'Aucune donnée de symptôme disponible';

  @override
  String get noNotes => 'Aucune note';

  @override
  String get noMoodDataAvailable => 'Aucune donnée d\'humeur disponible';

  @override
  String get noSignificantConcernsMessage =>
      'Aucune préoccupation significative';

  @override
  String get noAssessmentDetailsAvailable =>
      'Aucun détail d\'évaluation disponible';

  @override
  String minAgo(int minutes) {
    return 'il y a $minutes min';
  }

  @override
  String minAgoShort(int minutes) {
    return 'il y a ${minutes}m';
  }

  @override
  String hoursAgoShort(int hours) {
    return 'il y a ${hours}h';
  }

  @override
  String daysAgoShort(int days) {
    return 'il y a ${days}j';
  }

  @override
  String get underweight => 'Insuffisance pondérale';

  @override
  String get overweight => 'Surpoids';

  @override
  String get obese => 'Obèse';

  @override
  String get mixedMoodsCareMessage =>
      'Humeurs mélangées - prenez soin de vous!';
}
