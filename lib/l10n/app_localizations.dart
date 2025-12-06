import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

/// Minimal localization scaffold to satisfy imports and provide basic lookup.
/// You can extend this to load strings from ARB/JSON later.
class AppLocalizations {
  final Locale locale;
  const AppLocalizations(this.locale);

  // Supported locales in the app
  static const supportedLocales = <Locale>[
    Locale('en'),
    Locale('fr'),
    Locale('ar'),
  ];

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations) ??
        const AppLocalizations(Locale('en'));
  }

  // Basic fallback translation function
  String t(String key) => _localizedValues[key] ?? key;

  // Convenience getters used across the app
  // Auth & Login
  String get auth => t('auth');
  String get auth2 => t('auth2');
  String get or => t('or');
  String get register => t('register');
  String get welcome_back => t('welcome_back');
  String get login => t('login');
  String get email => t('email');
  String get enter_email => t('enter_email');
  String get password => t('password');
  String get rememberMe => t('rememberMe');
  String get forgot => t('forgot');
  String get notRegistered => t('notRegistered');
  String get createAccount => t('createAccount');
  
  // Signup
  String get your_name => t('your_name');
  String get enter_name => t('enter_name');
  String get signup => t('signup');
  
  // Dashboard & Tips
  String get searchHint => t('searchHint');
  
  // Doctors
  String get doctorDetails => t('doctorDetails');
  String get useCurrentLocation => t('useCurrentLocation');
  String get algiers => t('algiers');
  String get oran => t('oran');
  String get constantine => t('constantine');
  String get annaba => t('annaba');
  String get blida => t('blida');
  String get bouira => t('bouira');
  String get doctors => t('doctors');
  String get findDoctors => t('findDoctors');
  String get noDoctorsFound => t('noDoctorsFound');
  String get noResults => t('noResults');
  String noMatchingDoctors() => t('noMatchingDoctors');
  String get tryAdjustingFilters => t('tryAdjustingFilters');
  String get callNow => t('callNow');
  String get contactInformation => t('contactInformation');
  String get address => t('address');
  String get phoneNumber => t('phoneNumber');
  String get openingHours => t('openingHours');
  String kmAway(String distance) => '$distance km away';
  String get reviews => t('reviews');
  String get getDirections => t('getDirections');
  String get doctorsFoundSingle => t('doctorsFoundSingle');
  String doctorsFoundPlural(int count) => '$count doctors found';
  String get filter => t('filter');
  String get filterDoctors => t('filterDoctors');
  String get clearAll => t('clearAll');
  String get maximumDistance => t('maximumDistance');
  String upToKm(String km) => 'Up to $km km';
  String get minimumRating => t('minimumRating');
  String ratingAndAbove(String rating) => '$rating and above';
  String get gender => t('gender');
  String get all => t('all');
  String get male => t('male');
  String get female => t('female');
  String get minimumReviews => t('minimumReviews');
  String atLeastReviews(String count) => 'At least $count reviews';
  String get cancel => t('cancel');
  String get applyFilters => t('applyFilters');
  String get healthLog => t('healthLog');
  String get trackYourWellness => t('trackYourWellness');
  String get add => t('add');
  String get measurement => t('measurement');
  String get vitals => t('vitals');

  // Example values map; populate as needed
  static const Map<String, String> _localizedValues = {
    'app_title': 'Gestanéa',
    // Auth & Login
    'auth': 'Welcome to Gestanéa',
    'auth2': 'Join us to track pregnancy and baby care',
    'or': 'OR',
    'register': 'Create Account',
    'welcome_back': 'Welcome Back',
    'login': 'LOG IN',
    'email': 'Email Address',
    'enter_email': 'Enter your email',
    'password': 'Password',
    'rememberMe': 'Remember me',
    'forgot': 'Forgot Password?',
    'notRegistered': "Don't have an account?",
    'createAccount': 'Create an Account',
    // Signup
    'your_name': 'Your Name',
    'enter_name': 'Enter your full name',
    'signup': 'Sign Up',
    // Dashboard & Tips
    'searchHint': 'Search...',
    // Doctors
    'doctorDetails': 'Doctor Details',
    'useCurrentLocation': 'Use Current Location',
    'algiers': 'Algiers',
    'oran': 'Oran',
    'constantine': 'Constantine',
    'annaba': 'Annaba',
    'blida': 'Blida',
    'bouira': 'Bouira',
    'doctors': 'Doctors',
    'findDoctors': 'Find Doctors',
    'noDoctorsFound': 'No doctors found',
    'noResults': 'No results',
    'noMatchingDoctors': 'No matching doctors',
    'tryAdjustingFilters': 'Try adjusting your filters',
    'callNow': 'Call Now',
    'contactInformation': 'Contact Information',
    'address': 'Address',
    'phoneNumber': 'Phone Number',
    'openingHours': 'Opening Hours',
    'reviews': 'Reviews',
    'getDirections': 'Get Directions',
    'doctorsFoundSingle': '1 doctor found',
    'filter': 'Filter',
    'filterDoctors': 'Filter Doctors',
    'clearAll': 'Clear All',
    'maximumDistance': 'Maximum Distance',
    'minimumRating': 'Minimum Rating',
    'gender': 'Gender',
    'all': 'All',
    'male': 'Male',
    'female': 'Female',
    'minimumReviews': 'Minimum Reviews',
    'cancel': 'Cancel',
    'applyFilters': 'Apply Filters',
    'healthLog': 'Health Log',
    'trackYourWellness': 'Track Your Wellness',
    'add': 'Add',
    'measurement': 'Measurement',
    'vitals': 'Vitals',
  };

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) =>
      AppLocalizations.supportedLocales.any((l) => l.languageCode == locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) async {
    // In a full implementation, load resources here.
    return SynchronousFuture<AppLocalizations>(AppLocalizations(locale));
  }

  @override
  bool shouldReload(covariant LocalizationsDelegate<AppLocalizations> old) => false;
}
