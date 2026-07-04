import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';
import 'app_localizations_fr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en'),
    Locale('fr'),
  ];

  /// No description provided for @security.
  ///
  /// In en, this message translates to:
  /// **'Security'**
  String get security;

  /// No description provided for @i_gave_birth.
  ///
  /// In en, this message translates to:
  /// **'I gave birth'**
  String get i_gave_birth;

  /// No description provided for @no_longer_pregnant.
  ///
  /// In en, this message translates to:
  /// **'No longer pregnant'**
  String get no_longer_pregnant;

  /// No description provided for @help_support.
  ///
  /// In en, this message translates to:
  /// **'Help & Support'**
  String get help_support;

  /// No description provided for @contact_us.
  ///
  /// In en, this message translates to:
  /// **'Contact us'**
  String get contact_us;

  /// No description provided for @privacy_policy.
  ///
  /// In en, this message translates to:
  /// **'Privacy policy'**
  String get privacy_policy;

  /// No description provided for @about_app.
  ///
  /// In en, this message translates to:
  /// **'About App'**
  String get about_app;

  /// No description provided for @change.
  ///
  /// In en, this message translates to:
  /// **'Change'**
  String get change;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @save_changes.
  ///
  /// In en, this message translates to:
  /// **'Save changes'**
  String get save_changes;

  /// No description provided for @logout_confirmation.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to log out?'**
  String get logout_confirmation;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @unknown.
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get unknown;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @profile_updated.
  ///
  /// In en, this message translates to:
  /// **'Profile updated'**
  String get profile_updated;

  /// No description provided for @edit_profile.
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get edit_profile;

  /// No description provided for @change_profile_photo.
  ///
  /// In en, this message translates to:
  /// **'Change profile photo'**
  String get change_profile_photo;

  /// No description provided for @full_name.
  ///
  /// In en, this message translates to:
  /// **'Full name'**
  String get full_name;

  /// No description provided for @enable_notifications.
  ///
  /// In en, this message translates to:
  /// **'Enable notifications'**
  String get enable_notifications;

  /// No description provided for @phone.
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get phone;

  /// No description provided for @country.
  ///
  /// In en, this message translates to:
  /// **'Country'**
  String get country;

  /// No description provided for @plan.
  ///
  /// In en, this message translates to:
  /// **'Plan'**
  String get plan;

  /// No description provided for @sundayShort.
  ///
  /// In en, this message translates to:
  /// **'S'**
  String get sundayShort;

  /// No description provided for @mondayShort.
  ///
  /// In en, this message translates to:
  /// **'M'**
  String get mondayShort;

  /// No description provided for @tuesdayShort.
  ///
  /// In en, this message translates to:
  /// **'T'**
  String get tuesdayShort;

  /// No description provided for @wednesdayShort.
  ///
  /// In en, this message translates to:
  /// **'W'**
  String get wednesdayShort;

  /// No description provided for @thursdayShort.
  ///
  /// In en, this message translates to:
  /// **'T'**
  String get thursdayShort;

  /// No description provided for @fridayShort.
  ///
  /// In en, this message translates to:
  /// **'F'**
  String get fridayShort;

  /// No description provided for @saturdayShort.
  ///
  /// In en, this message translates to:
  /// **'S'**
  String get saturdayShort;

  /// No description provided for @todaysMedicine.
  ///
  /// In en, this message translates to:
  /// **'Today\'s Medicine'**
  String get todaysMedicine;

  /// No description provided for @upcomingAppointments.
  ///
  /// In en, this message translates to:
  /// **'Upcoming Appointments'**
  String get upcomingAppointments;

  /// No description provided for @scheduled.
  ///
  /// In en, this message translates to:
  /// **'Scheduled'**
  String get scheduled;

  /// No description provided for @addNewMedicine.
  ///
  /// In en, this message translates to:
  /// **'Add New Medicine'**
  String get addNewMedicine;

  /// No description provided for @addNewAppointment.
  ///
  /// In en, this message translates to:
  /// **'Add New Appointment'**
  String get addNewAppointment;

  /// No description provided for @medicine.
  ///
  /// In en, this message translates to:
  /// **'Medicine'**
  String get medicine;

  /// No description provided for @appointments.
  ///
  /// In en, this message translates to:
  /// **'Appointments'**
  String get appointments;

  /// No description provided for @appointmentName.
  ///
  /// In en, this message translates to:
  /// **'Appointment Name'**
  String get appointmentName;

  /// No description provided for @medicationName.
  ///
  /// In en, this message translates to:
  /// **'Medication Name'**
  String get medicationName;

  /// No description provided for @nextLabel.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get nextLabel;

  /// No description provided for @doneLabel.
  ///
  /// In en, this message translates to:
  /// **'DONE'**
  String get doneLabel;

  /// No description provided for @uploadPicture.
  ///
  /// In en, this message translates to:
  /// **'Upload a picture'**
  String get uploadPicture;

  /// No description provided for @camera.
  ///
  /// In en, this message translates to:
  /// **'Camera'**
  String get camera;

  /// No description provided for @gallery.
  ///
  /// In en, this message translates to:
  /// **'Gallery'**
  String get gallery;

  /// No description provided for @removeImage.
  ///
  /// In en, this message translates to:
  /// **'Remove Image'**
  String get removeImage;

  /// No description provided for @tapToAddPicture.
  ///
  /// In en, this message translates to:
  /// **'Tap to add picture'**
  String get tapToAddPicture;

  /// No description provided for @optionalImageNote.
  ///
  /// In en, this message translates to:
  /// **'Adding a picture is optional. You can skip this step.'**
  String get optionalImageNote;

  /// No description provided for @selectFormDose.
  ///
  /// In en, this message translates to:
  /// **'Select Form & Dose'**
  String get selectFormDose;

  /// No description provided for @frequencySchedule.
  ///
  /// In en, this message translates to:
  /// **'Frequency & Schedule'**
  String get frequencySchedule;

  /// No description provided for @frequencyType.
  ///
  /// In en, this message translates to:
  /// **'Frequency Type'**
  String get frequencyType;

  /// No description provided for @frequencyValue.
  ///
  /// In en, this message translates to:
  /// **'Frequency Value'**
  String get frequencyValue;

  /// No description provided for @scheduledTimesLabel.
  ///
  /// In en, this message translates to:
  /// **'Scheduled Times'**
  String get scheduledTimesLabel;

  /// No description provided for @asNeeded.
  ///
  /// In en, this message translates to:
  /// **'As Needed'**
  String get asNeeded;

  /// No description provided for @dosage.
  ///
  /// In en, this message translates to:
  /// **'Dosage'**
  String get dosage;

  /// No description provided for @dosageExample.
  ///
  /// In en, this message translates to:
  /// **'e.g., 5mg or 10ml'**
  String get dosageExample;

  /// No description provided for @formPill.
  ///
  /// In en, this message translates to:
  /// **'Pill'**
  String get formPill;

  /// No description provided for @formInjection.
  ///
  /// In en, this message translates to:
  /// **'Injection'**
  String get formInjection;

  /// No description provided for @formSpray.
  ///
  /// In en, this message translates to:
  /// **'Spray'**
  String get formSpray;

  /// No description provided for @formDrop.
  ///
  /// In en, this message translates to:
  /// **'Drop'**
  String get formDrop;

  /// No description provided for @formSyrup.
  ///
  /// In en, this message translates to:
  /// **'Syrup'**
  String get formSyrup;

  /// No description provided for @formOthers.
  ///
  /// In en, this message translates to:
  /// **'Others'**
  String get formOthers;

  /// Medicine taken status
  ///
  /// In en, this message translates to:
  /// **'{taken} of {total} taken'**
  String medicinesTaken(int taken, int total);

  /// No description provided for @daily.
  ///
  /// In en, this message translates to:
  /// **'Daily'**
  String get daily;

  /// No description provided for @weekly.
  ///
  /// In en, this message translates to:
  /// **'Weekly'**
  String get weekly;

  /// No description provided for @monthly.
  ///
  /// In en, this message translates to:
  /// **'Monthly'**
  String get monthly;

  /// No description provided for @timesPerDayExample.
  ///
  /// In en, this message translates to:
  /// **'e.g., 3 (times per day)'**
  String get timesPerDayExample;

  /// No description provided for @timesPerWeekExample.
  ///
  /// In en, this message translates to:
  /// **'e.g., 2 (times per week)'**
  String get timesPerWeekExample;

  /// No description provided for @timesPerMonthExample.
  ///
  /// In en, this message translates to:
  /// **'e.g., 1 (times per month)'**
  String get timesPerMonthExample;

  /// No description provided for @appointmentDateTime.
  ///
  /// In en, this message translates to:
  /// **'Appointment Date & Time'**
  String get appointmentDateTime;

  /// No description provided for @appointmentLocation.
  ///
  /// In en, this message translates to:
  /// **'Appointment location'**
  String get appointmentLocation;

  /// No description provided for @selectDate.
  ///
  /// In en, this message translates to:
  /// **'Select Date'**
  String get selectDate;

  /// No description provided for @selectTime.
  ///
  /// In en, this message translates to:
  /// **'Select time'**
  String get selectTime;

  /// No description provided for @startDate.
  ///
  /// In en, this message translates to:
  /// **'Start Date'**
  String get startDate;

  /// No description provided for @endDate.
  ///
  /// In en, this message translates to:
  /// **'End Date (Optional)'**
  String get endDate;

  /// No description provided for @selectStartDate.
  ///
  /// In en, this message translates to:
  /// **'Select Start Date'**
  String get selectStartDate;

  /// No description provided for @selectEndDate.
  ///
  /// In en, this message translates to:
  /// **'Select End Date'**
  String get selectEndDate;

  /// No description provided for @addTime.
  ///
  /// In en, this message translates to:
  /// **'Add Time'**
  String get addTime;

  /// No description provided for @noScheduledTimesAdded.
  ///
  /// In en, this message translates to:
  /// **'No scheduled times added yet'**
  String get noScheduledTimesAdded;

  /// No description provided for @today.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get today;

  /// No description provided for @tomorrow.
  ///
  /// In en, this message translates to:
  /// **'Tomorrow'**
  String get tomorrow;

  /// No description provided for @noAppointmentsFound.
  ///
  /// In en, this message translates to:
  /// **'No appointments found'**
  String get noAppointmentsFound;

  /// No description provided for @appointment.
  ///
  /// In en, this message translates to:
  /// **'Appointment'**
  String get appointment;

  /// No description provided for @pleaseAddScheduledTime.
  ///
  /// In en, this message translates to:
  /// **'Please add at least one scheduled time'**
  String get pleaseAddScheduledTime;

  /// No description provided for @reviewsCount.
  ///
  /// In en, this message translates to:
  /// **'{count} reviews'**
  String reviewsCount(Object count);

  /// No description provided for @qty.
  ///
  /// In en, this message translates to:
  /// **'Qty'**
  String get qty;

  /// No description provided for @noMedicines.
  ///
  /// In en, this message translates to:
  /// **'No medicines'**
  String get noMedicines;

  /// No description provided for @schedule.
  ///
  /// In en, this message translates to:
  /// **'Schedule'**
  String get schedule;

  /// No description provided for @availability.
  ///
  /// In en, this message translates to:
  /// **'Availability'**
  String get availability;

  /// No description provided for @specialty.
  ///
  /// In en, this message translates to:
  /// **'Specialty'**
  String get specialty;

  /// No description provided for @bookAppointment.
  ///
  /// In en, this message translates to:
  /// **'Book Appointment'**
  String get bookAppointment;

  /// No description provided for @price.
  ///
  /// In en, this message translates to:
  /// **'Price'**
  String get price;

  /// No description provided for @quantity.
  ///
  /// In en, this message translates to:
  /// **'Quantity'**
  String get quantity;

  /// No description provided for @checkout.
  ///
  /// In en, this message translates to:
  /// **'Checkout'**
  String get checkout;

  /// No description provided for @applyCoupon.
  ///
  /// In en, this message translates to:
  /// **'Apply coupon'**
  String get applyCoupon;

  /// No description provided for @popular.
  ///
  /// In en, this message translates to:
  /// **'Popular'**
  String get popular;

  /// No description provided for @offers.
  ///
  /// In en, this message translates to:
  /// **'Offers'**
  String get offers;

  /// No description provided for @newLabel.
  ///
  /// In en, this message translates to:
  /// **'New'**
  String get newLabel;

  /// No description provided for @contact.
  ///
  /// In en, this message translates to:
  /// **'Contact'**
  String get contact;

  /// No description provided for @message.
  ///
  /// In en, this message translates to:
  /// **'Message'**
  String get message;

  /// No description provided for @location.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get location;

  /// No description provided for @noResults.
  ///
  /// In en, this message translates to:
  /// **'No results'**
  String get noResults;

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// No description provided for @sort.
  ///
  /// In en, this message translates to:
  /// **'Sort'**
  String get sort;

  /// No description provided for @marketplace.
  ///
  /// In en, this message translates to:
  /// **'Marketplace'**
  String get marketplace;

  /// No description provided for @doctorsFeatureTitle.
  ///
  /// In en, this message translates to:
  /// **'Doctors'**
  String get doctorsFeatureTitle;

  /// No description provided for @planFeatureTitle.
  ///
  /// In en, this message translates to:
  /// **'Plan'**
  String get planFeatureTitle;

  /// No description provided for @addMedicine.
  ///
  /// In en, this message translates to:
  /// **'Add medicine'**
  String get addMedicine;

  /// No description provided for @addAppointment.
  ///
  /// In en, this message translates to:
  /// **'Add appointment'**
  String get addAppointment;

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// No description provided for @success.
  ///
  /// In en, this message translates to:
  /// **'Success'**
  String get success;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// No description provided for @remove.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get remove;

  /// No description provided for @apply.
  ///
  /// In en, this message translates to:
  /// **'Apply'**
  String get apply;

  /// No description provided for @reviewsLabel.
  ///
  /// In en, this message translates to:
  /// **'Reviews'**
  String get reviewsLabel;

  /// No description provided for @rating.
  ///
  /// In en, this message translates to:
  /// **'Rating'**
  String get rating;

  /// No description provided for @recommended.
  ///
  /// In en, this message translates to:
  /// **'Recommended'**
  String get recommended;

  /// No description provided for @noReviews.
  ///
  /// In en, this message translates to:
  /// **'No reviews'**
  String get noReviews;

  /// No description provided for @delivery.
  ///
  /// In en, this message translates to:
  /// **'Delivery'**
  String get delivery;

  /// No description provided for @shipping.
  ///
  /// In en, this message translates to:
  /// **'Shipping'**
  String get shipping;

  /// No description provided for @taxes.
  ///
  /// In en, this message translates to:
  /// **'Taxes'**
  String get taxes;

  /// No description provided for @sunday.
  ///
  /// In en, this message translates to:
  /// **'Sunday'**
  String get sunday;

  /// No description provided for @monday.
  ///
  /// In en, this message translates to:
  /// **'Monday'**
  String get monday;

  /// No description provided for @tuesday.
  ///
  /// In en, this message translates to:
  /// **'Tuesday'**
  String get tuesday;

  /// No description provided for @wednesday.
  ///
  /// In en, this message translates to:
  /// **'Wednesday'**
  String get wednesday;

  /// No description provided for @thursday.
  ///
  /// In en, this message translates to:
  /// **'Thursday'**
  String get thursday;

  /// No description provided for @friday.
  ///
  /// In en, this message translates to:
  /// **'Friday'**
  String get friday;

  /// No description provided for @saturday.
  ///
  /// In en, this message translates to:
  /// **'Saturday'**
  String get saturday;

  /// No description provided for @jan.
  ///
  /// In en, this message translates to:
  /// **'Jan'**
  String get jan;

  /// No description provided for @feb.
  ///
  /// In en, this message translates to:
  /// **'Feb'**
  String get feb;

  /// No description provided for @mar.
  ///
  /// In en, this message translates to:
  /// **'Mar'**
  String get mar;

  /// No description provided for @apr.
  ///
  /// In en, this message translates to:
  /// **'Apr'**
  String get apr;

  /// No description provided for @may.
  ///
  /// In en, this message translates to:
  /// **'May'**
  String get may;

  /// No description provided for @jun.
  ///
  /// In en, this message translates to:
  /// **'Jun'**
  String get jun;

  /// No description provided for @jul.
  ///
  /// In en, this message translates to:
  /// **'Jul'**
  String get jul;

  /// No description provided for @aug.
  ///
  /// In en, this message translates to:
  /// **'Aug'**
  String get aug;

  /// No description provided for @sep.
  ///
  /// In en, this message translates to:
  /// **'Sep'**
  String get sep;

  /// No description provided for @oct.
  ///
  /// In en, this message translates to:
  /// **'Oct'**
  String get oct;

  /// No description provided for @nov.
  ///
  /// In en, this message translates to:
  /// **'Nov'**
  String get nov;

  /// No description provided for @dec.
  ///
  /// In en, this message translates to:
  /// **'Dec'**
  String get dec;

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Pregnancy & Baby Care'**
  String get appTitle;

  /// No description provided for @welcome.
  ///
  /// In en, this message translates to:
  /// **'Welcome'**
  String get welcome;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @signup.
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get signup;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @darkMode.
  ///
  /// In en, this message translates to:
  /// **'Dark Mode'**
  String get darkMode;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @help.
  ///
  /// In en, this message translates to:
  /// **'Help'**
  String get help;

  /// No description provided for @about.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about;

  /// No description provided for @welcome_back.
  ///
  /// In en, this message translates to:
  /// **'Welcome Back! '**
  String get welcome_back;

  /// No description provided for @or.
  ///
  /// In en, this message translates to:
  /// **'— OR —'**
  String get or;

  /// No description provided for @register.
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get register;

  /// No description provided for @auth.
  ///
  /// In en, this message translates to:
  /// **'Your trusted companion for every stage of motherhood'**
  String get auth;

  /// No description provided for @auth2.
  ///
  /// In en, this message translates to:
  /// **'Let Gestanéa guide you through pregnancy, baby care, and beyond.'**
  String get auth2;

  /// No description provided for @forgot.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password?'**
  String get forgot;

  /// No description provided for @notRegistered.
  ///
  /// In en, this message translates to:
  /// **'Not registered yet?'**
  String get notRegistered;

  /// No description provided for @createAccount.
  ///
  /// In en, this message translates to:
  /// **'Create an Account'**
  String get createAccount;

  /// No description provided for @your_name.
  ///
  /// In en, this message translates to:
  /// **'Your Name'**
  String get your_name;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @enter_email.
  ///
  /// In en, this message translates to:
  /// **'Enter your email'**
  String get enter_email;

  /// No description provided for @enter_name.
  ///
  /// In en, this message translates to:
  /// **'Enter your Name'**
  String get enter_name;

  /// No description provided for @rememberMe.
  ///
  /// In en, this message translates to:
  /// **'Remember me'**
  String get rememberMe;

  /// No description provided for @version.
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get version;

  /// No description provided for @pregnant.
  ///
  /// In en, this message translates to:
  /// **'Pregnant'**
  String get pregnant;

  /// No description provided for @postpartum.
  ///
  /// In en, this message translates to:
  /// **'Postpartum'**
  String get postpartum;

  /// Week number
  ///
  /// In en, this message translates to:
  /// **'Week {week}'**
  String week(int week);

  /// No description provided for @daysLeft.
  ///
  /// In en, this message translates to:
  /// **'{days} days left'**
  String daysLeft(int days);

  /// Market page title
  ///
  /// In en, this message translates to:
  /// **'Market'**
  String get market;

  /// Maternity wear category
  ///
  /// In en, this message translates to:
  /// **'Maternity Wear'**
  String get maternityWear;

  /// Pain relief category
  ///
  /// In en, this message translates to:
  /// **'Pain Relief'**
  String get painRelief;

  /// Skin care category
  ///
  /// In en, this message translates to:
  /// **'Skin Care'**
  String get skinCare;

  /// Pregnancy pillow product
  ///
  /// In en, this message translates to:
  /// **'Pregnancy Pillow'**
  String get pregnancyPillow;

  /// Back support belt product
  ///
  /// In en, this message translates to:
  /// **'Back Support Belt'**
  String get backSupportBelt;

  /// Search bar hint text
  ///
  /// In en, this message translates to:
  /// **'Find what you need.. .'**
  String get searchHint;

  /// Promotional banner title
  ///
  /// In en, this message translates to:
  /// **'Don\'t miss out! '**
  String get dontMissOut;

  /// Promotional discount text
  ///
  /// In en, this message translates to:
  /// **'Discount up to 50%'**
  String get discountUpTo;

  /// Upgrade button text
  ///
  /// In en, this message translates to:
  /// **'Upgrade Now'**
  String get upgradeNow;

  /// No description provided for @healthLog.
  ///
  /// In en, this message translates to:
  /// **'Health Log'**
  String get healthLog;

  /// No description provided for @trackYourWellness.
  ///
  /// In en, this message translates to:
  /// **'Track your wellness'**
  String get trackYourWellness;

  /// No description provided for @vitals.
  ///
  /// In en, this message translates to:
  /// **'Vitals'**
  String get vitals;

  /// No description provided for @symptoms.
  ///
  /// In en, this message translates to:
  /// **'Symptoms'**
  String get symptoms;

  /// No description provided for @labResults.
  ///
  /// In en, this message translates to:
  /// **'Lab\nResults'**
  String get labResults;

  /// No description provided for @riskAlerts.
  ///
  /// In en, this message translates to:
  /// **'Risk\nAlerts'**
  String get riskAlerts;

  /// No description provided for @mood.
  ///
  /// In en, this message translates to:
  /// **'Mood'**
  String get mood;

  /// No description provided for @weight.
  ///
  /// In en, this message translates to:
  /// **'Weight'**
  String get weight;

  /// No description provided for @heartRate.
  ///
  /// In en, this message translates to:
  /// **'Heart Rate'**
  String get heartRate;

  /// No description provided for @bloodPressure.
  ///
  /// In en, this message translates to:
  /// **'Blood Pressure'**
  String get bloodPressure;

  /// No description provided for @normal.
  ///
  /// In en, this message translates to:
  /// **'Normal'**
  String get normal;

  /// No description provided for @add.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get add;

  /// No description provided for @measurement.
  ///
  /// In en, this message translates to:
  /// **'Measurement'**
  String get measurement;

  /// No description provided for @healthTipMessage.
  ///
  /// In en, this message translates to:
  /// **'Great job!  You\'re maintaining a healthy weight gain pace. Keep up with your balanced diet and gentle exercise routine.'**
  String get healthTipMessage;

  /// No description provided for @onTrack.
  ///
  /// In en, this message translates to:
  /// **'On Track'**
  String get onTrack;

  /// No description provided for @moodTab.
  ///
  /// In en, this message translates to:
  /// **'Mood Tab'**
  String get moodTab;

  /// No description provided for @recentEntries.
  ///
  /// In en, this message translates to:
  /// **'Recent entries'**
  String get recentEntries;

  /// No description provided for @howAreYouFeelingToday.
  ///
  /// In en, this message translates to:
  /// **'How are you feeling today?'**
  String get howAreYouFeelingToday;

  /// No description provided for @feltEnergeticToday.
  ///
  /// In en, this message translates to:
  /// **'Felt energetic today'**
  String get feltEnergeticToday;

  /// No description provided for @hoursAgo.
  ///
  /// In en, this message translates to:
  /// **'{hours} hours ago'**
  String hoursAgo(Object hours);

  /// No description provided for @calm.
  ///
  /// In en, this message translates to:
  /// **'Calm'**
  String get calm;

  /// No description provided for @relaxingEvening.
  ///
  /// In en, this message translates to:
  /// **'Relaxing evening'**
  String get relaxingEvening;

  /// No description provided for @yesterday.
  ///
  /// In en, this message translates to:
  /// **'Yesterday'**
  String get yesterday;

  /// No description provided for @tired.
  ///
  /// In en, this message translates to:
  /// **'Tired'**
  String get tired;

  /// No description provided for @needMoreSleep.
  ///
  /// In en, this message translates to:
  /// **'Need more sleep'**
  String get needMoreSleep;

  /// No description provided for @daysAgo.
  ///
  /// In en, this message translates to:
  /// **'{days} days ago'**
  String daysAgo(Object days);

  /// No description provided for @trackingMoodHelps.
  ///
  /// In en, this message translates to:
  /// **'Tracking your mood helps you understand your well-being.'**
  String get trackingMoodHelps;

  /// No description provided for @great.
  ///
  /// In en, this message translates to:
  /// **'Great'**
  String get great;

  /// No description provided for @good.
  ///
  /// In en, this message translates to:
  /// **'Good'**
  String get good;

  /// No description provided for @okay.
  ///
  /// In en, this message translates to:
  /// **'Okay'**
  String get okay;

  /// No description provided for @moodTrendsLast7Days.
  ///
  /// In en, this message translates to:
  /// **'Mood trends (last 7 days)'**
  String get moodTrendsLast7Days;

  /// No description provided for @mostlyPositiveMoods.
  ///
  /// In en, this message translates to:
  /// **'Mostly positive moods'**
  String get mostlyPositiveMoods;

  /// No description provided for @takeCareYourself.
  ///
  /// In en, this message translates to:
  /// **'Be gentle with yourself — reach out if you need support'**
  String get takeCareYourself;

  /// No description provided for @logMoodToSeeTrends.
  ///
  /// In en, this message translates to:
  /// **'Log your mood to see weekly trends'**
  String get logMoodToSeeTrends;

  /// No description provided for @noEntriesYet.
  ///
  /// In en, this message translates to:
  /// **'No entries yet'**
  String get noEntriesYet;

  /// No description provided for @selfCareSuggestions.
  ///
  /// In en, this message translates to:
  /// **'Self-care suggestions'**
  String get selfCareSuggestions;

  /// No description provided for @takeShortWalk.
  ///
  /// In en, this message translates to:
  /// **'Take a short walk'**
  String get takeShortWalk;

  /// No description provided for @practiceDeepBreathing.
  ///
  /// In en, this message translates to:
  /// **'Practice deep breathing'**
  String get practiceDeepBreathing;

  /// No description provided for @listenToCalmingMusic.
  ///
  /// In en, this message translates to:
  /// **'Listen to calming music'**
  String get listenToCalmingMusic;

  /// No description provided for @connectWithLovedOnes.
  ///
  /// In en, this message translates to:
  /// **'Connect with loved ones'**
  String get connectWithLovedOnes;

  /// No description provided for @doctors.
  ///
  /// In en, this message translates to:
  /// **'Doctors'**
  String get doctors;

  /// No description provided for @findDoctors.
  ///
  /// In en, this message translates to:
  /// **'find doctors by name or speciality'**
  String get findDoctors;

  /// No description provided for @useCurrentLocation.
  ///
  /// In en, this message translates to:
  /// **'Use current location'**
  String get useCurrentLocation;

  /// No description provided for @algiers.
  ///
  /// In en, this message translates to:
  /// **'Algiers'**
  String get algiers;

  /// No description provided for @oran.
  ///
  /// In en, this message translates to:
  /// **'Oran'**
  String get oran;

  /// No description provided for @constantine.
  ///
  /// In en, this message translates to:
  /// **'Constantine'**
  String get constantine;

  /// No description provided for @annaba.
  ///
  /// In en, this message translates to:
  /// **'Annaba'**
  String get annaba;

  /// No description provided for @blida.
  ///
  /// In en, this message translates to:
  /// **'Blida'**
  String get blida;

  /// No description provided for @bouira.
  ///
  /// In en, this message translates to:
  /// **'Bouira'**
  String get bouira;

  /// No description provided for @doctorsFoundSingle.
  ///
  /// In en, this message translates to:
  /// **'1 Doctor Found'**
  String get doctorsFoundSingle;

  /// No description provided for @doctorsFoundPlural.
  ///
  /// In en, this message translates to:
  /// **'{count} Doctors Found'**
  String doctorsFoundPlural(int count);

  /// No description provided for @filter.
  ///
  /// In en, this message translates to:
  /// **'Filter'**
  String get filter;

  /// No description provided for @filterDoctors.
  ///
  /// In en, this message translates to:
  /// **'Filter Doctors'**
  String get filterDoctors;

  /// No description provided for @clearAll.
  ///
  /// In en, this message translates to:
  /// **'Clear All'**
  String get clearAll;

  /// No description provided for @maximumDistance.
  ///
  /// In en, this message translates to:
  /// **'Maximum Distance'**
  String get maximumDistance;

  /// No description provided for @upToKm.
  ///
  /// In en, this message translates to:
  /// **'Up to {distance} km'**
  String upToKm(String distance);

  /// No description provided for @minimumRating.
  ///
  /// In en, this message translates to:
  /// **'Minimum Rating'**
  String get minimumRating;

  /// No description provided for @ratingAndAbove.
  ///
  /// In en, this message translates to:
  /// **'{rating} and above'**
  String ratingAndAbove(String rating);

  /// No description provided for @gender.
  ///
  /// In en, this message translates to:
  /// **'Gender'**
  String get gender;

  /// No description provided for @male.
  ///
  /// In en, this message translates to:
  /// **'Male'**
  String get male;

  /// No description provided for @female.
  ///
  /// In en, this message translates to:
  /// **'Female'**
  String get female;

  /// No description provided for @minimumReviews.
  ///
  /// In en, this message translates to:
  /// **'Minimum Reviews'**
  String get minimumReviews;

  /// No description provided for @atLeastReviews.
  ///
  /// In en, this message translates to:
  /// **'At least {count} reviews'**
  String atLeastReviews(int count);

  /// No description provided for @applyFilters.
  ///
  /// In en, this message translates to:
  /// **'Apply Filters'**
  String get applyFilters;

  /// No description provided for @kmAway.
  ///
  /// In en, this message translates to:
  /// **'{distance} km away'**
  String kmAway(String distance);

  /// No description provided for @reviews.
  ///
  /// In en, this message translates to:
  /// **'reviews'**
  String get reviews;

  /// No description provided for @noDoctorsFound.
  ///
  /// In en, this message translates to:
  /// **'No doctors found'**
  String get noDoctorsFound;

  /// No description provided for @noMatchingDoctors.
  ///
  /// In en, this message translates to:
  /// **'No doctors match \"{query}\"'**
  String noMatchingDoctors(String query);

  /// No description provided for @tryAdjustingFilters.
  ///
  /// In en, this message translates to:
  /// **'Try adjusting your filters'**
  String get tryAdjustingFilters;

  /// No description provided for @doctorDetails.
  ///
  /// In en, this message translates to:
  /// **'Doctor Details'**
  String get doctorDetails;

  /// No description provided for @couldNotOpenMaps.
  ///
  /// In en, this message translates to:
  /// **'Could not open maps'**
  String get couldNotOpenMaps;

  /// No description provided for @phoneNumberNotAvailable.
  ///
  /// In en, this message translates to:
  /// **'Phone number not available'**
  String get phoneNumberNotAvailable;

  /// No description provided for @couldNotMakePhoneCall.
  ///
  /// In en, this message translates to:
  /// **'Could not make phone call'**
  String get couldNotMakePhoneCall;

  /// No description provided for @gynecologist.
  ///
  /// In en, this message translates to:
  /// **'Gynecologist'**
  String get gynecologist;

  /// No description provided for @pediatrician.
  ///
  /// In en, this message translates to:
  /// **'Pediatrician'**
  String get pediatrician;

  /// No description provided for @obstetrician.
  ///
  /// In en, this message translates to:
  /// **'Obstetrician'**
  String get obstetrician;

  /// No description provided for @generalPractitioner.
  ///
  /// In en, this message translates to:
  /// **'General Practitioner'**
  String get generalPractitioner;

  /// No description provided for @getDirections.
  ///
  /// In en, this message translates to:
  /// **'Get Directions'**
  String get getDirections;

  /// No description provided for @contactInformation.
  ///
  /// In en, this message translates to:
  /// **'Contact Information'**
  String get contactInformation;

  /// No description provided for @address.
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get address;

  /// No description provided for @phoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get phoneNumber;

  /// No description provided for @openingHours.
  ///
  /// In en, this message translates to:
  /// **'Opening Hours'**
  String get openingHours;

  /// No description provided for @callNow.
  ///
  /// In en, this message translates to:
  /// **'Call Now'**
  String get callNow;

  /// No description provided for @all.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get all;

  /// No description provided for @taken.
  ///
  /// In en, this message translates to:
  /// **'Taken'**
  String get taken;

  /// No description provided for @missed.
  ///
  /// In en, this message translates to:
  /// **'Missed'**
  String get missed;

  /// No description provided for @take.
  ///
  /// In en, this message translates to:
  /// **'Take'**
  String get take;

  /// No description provided for @noMedicinesFound.
  ///
  /// In en, this message translates to:
  /// **'No medicines found'**
  String get noMedicinesFound;

  /// No description provided for @pleaseLoginToViewPlan.
  ///
  /// In en, this message translates to:
  /// **'Please log in to view your plan'**
  String get pleaseLoginToViewPlan;

  /// No description provided for @selectColor.
  ///
  /// In en, this message translates to:
  /// **'Select Color'**
  String get selectColor;

  /// No description provided for @selectSize.
  ///
  /// In en, this message translates to:
  /// **'Select Size'**
  String get selectSize;

  /// No description provided for @addToCart.
  ///
  /// In en, this message translates to:
  /// **'Add to Cart'**
  String get addToCart;

  /// No description provided for @buyNow.
  ///
  /// In en, this message translates to:
  /// **'Buy Now'**
  String get buyNow;

  /// No description provided for @description.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get description;

  /// No description provided for @noDescriptionAvailable.
  ///
  /// In en, this message translates to:
  /// **'No description available'**
  String get noDescriptionAvailable;

  /// No description provided for @specifications.
  ///
  /// In en, this message translates to:
  /// **'Specifications'**
  String get specifications;

  /// No description provided for @customerReviews.
  ///
  /// In en, this message translates to:
  /// **'Customer Reviews'**
  String get customerReviews;

  /// No description provided for @seeAll.
  ///
  /// In en, this message translates to:
  /// **'see all'**
  String get seeAll;

  /// No description provided for @completeYourOrder.
  ///
  /// In en, this message translates to:
  /// **'Complete Your Order'**
  String get completeYourOrder;

  /// No description provided for @orderSummary.
  ///
  /// In en, this message translates to:
  /// **'Order Summary'**
  String get orderSummary;

  /// No description provided for @product.
  ///
  /// In en, this message translates to:
  /// **'Product'**
  String get product;

  /// No description provided for @size.
  ///
  /// In en, this message translates to:
  /// **'Size'**
  String get size;

  /// No description provided for @subtotal.
  ///
  /// In en, this message translates to:
  /// **'Subtotal'**
  String get subtotal;

  /// No description provided for @deliveryFee.
  ///
  /// In en, this message translates to:
  /// **'Delivery Fee'**
  String get deliveryFee;

  /// No description provided for @total.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get total;

  /// No description provided for @deliveryInformation.
  ///
  /// In en, this message translates to:
  /// **'Delivery Information'**
  String get deliveryInformation;

  /// No description provided for @fullName.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get fullName;

  /// No description provided for @enterYourFullName.
  ///
  /// In en, this message translates to:
  /// **'Enter your full name'**
  String get enterYourFullName;

  /// No description provided for @enterYourPhoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Enter your phone number'**
  String get enterYourPhoneNumber;

  /// No description provided for @deliveryAddress.
  ///
  /// In en, this message translates to:
  /// **'Delivery Address'**
  String get deliveryAddress;

  /// No description provided for @streetAddressApartment.
  ///
  /// In en, this message translates to:
  /// **'Street address, apartment, etc.'**
  String get streetAddressApartment;

  /// No description provided for @city.
  ///
  /// In en, this message translates to:
  /// **'City'**
  String get city;

  /// No description provided for @enterYourCity.
  ///
  /// In en, this message translates to:
  /// **'Enter your city'**
  String get enterYourCity;

  /// No description provided for @specialInstructions.
  ///
  /// In en, this message translates to:
  /// **'Special Instructions (Optional)'**
  String get specialInstructions;

  /// No description provided for @addDeliveryNotes.
  ///
  /// In en, this message translates to:
  /// **'Add delivery notes, special requests...'**
  String get addDeliveryNotes;

  /// No description provided for @paymentMethod.
  ///
  /// In en, this message translates to:
  /// **'Payment Method'**
  String get paymentMethod;

  /// No description provided for @cashOnDelivery.
  ///
  /// In en, this message translates to:
  /// **'Cash on Delivery'**
  String get cashOnDelivery;

  /// No description provided for @creditDebitCard.
  ///
  /// In en, this message translates to:
  /// **'Credit / Debit Card'**
  String get creditDebitCard;

  /// No description provided for @digitalWallet.
  ///
  /// In en, this message translates to:
  /// **'Digital Wallet'**
  String get digitalWallet;

  /// No description provided for @placeOrder.
  ///
  /// In en, this message translates to:
  /// **'Place Order'**
  String get placeOrder;

  /// No description provided for @orderPlacedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Order {orderId} placed successfully!'**
  String orderPlacedSuccessfully(String orderId);

  /// No description provided for @yourInformationIsSecure.
  ///
  /// In en, this message translates to:
  /// **'Your information is secure and encrypted'**
  String get yourInformationIsSecure;

  /// No description provided for @openNow.
  ///
  /// In en, this message translates to:
  /// **'Open Now'**
  String get openNow;

  /// No description provided for @nausea.
  ///
  /// In en, this message translates to:
  /// **'Nausea'**
  String get nausea;

  /// No description provided for @headache.
  ///
  /// In en, this message translates to:
  /// **'Headache'**
  String get headache;

  /// No description provided for @backPain.
  ///
  /// In en, this message translates to:
  /// **'Back pain'**
  String get backPain;

  /// No description provided for @swelling.
  ///
  /// In en, this message translates to:
  /// **'Swelling'**
  String get swelling;

  /// No description provided for @fatigue.
  ///
  /// In en, this message translates to:
  /// **'Fatigue'**
  String get fatigue;

  /// No description provided for @dizziness.
  ///
  /// In en, this message translates to:
  /// **'Dizziness'**
  String get dizziness;

  /// No description provided for @heartburn.
  ///
  /// In en, this message translates to:
  /// **'Heartburn'**
  String get heartburn;

  /// No description provided for @legCramps.
  ///
  /// In en, this message translates to:
  /// **'Leg cramps'**
  String get legCramps;

  /// No description provided for @other.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get other;

  /// No description provided for @pleaseSelectSymptom.
  ///
  /// In en, this message translates to:
  /// **'Please select a symptom'**
  String get pleaseSelectSymptom;

  /// No description provided for @pleaseSelectSeverity.
  ///
  /// In en, this message translates to:
  /// **'Please select severity'**
  String get pleaseSelectSeverity;

  /// No description provided for @symptomLoggedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Symptom logged successfully!'**
  String get symptomLoggedSuccessfully;

  /// No description provided for @addSymptom.
  ///
  /// In en, this message translates to:
  /// **'Add Symptom'**
  String get addSymptom;

  /// No description provided for @symptomType.
  ///
  /// In en, this message translates to:
  /// **'Symptom type'**
  String get symptomType;

  /// No description provided for @selectSymptom.
  ///
  /// In en, this message translates to:
  /// **'Select symptom'**
  String get selectSymptom;

  /// No description provided for @specifySymptom.
  ///
  /// In en, this message translates to:
  /// **'Specify symptom'**
  String get specifySymptom;

  /// No description provided for @pleaseSpecifySymptom.
  ///
  /// In en, this message translates to:
  /// **'Please specify the symptom'**
  String get pleaseSpecifySymptom;

  /// No description provided for @severity.
  ///
  /// In en, this message translates to:
  /// **'Severity'**
  String get severity;

  /// No description provided for @mild.
  ///
  /// In en, this message translates to:
  /// **'Mild'**
  String get mild;

  /// No description provided for @moderate.
  ///
  /// In en, this message translates to:
  /// **'Moderate'**
  String get moderate;

  /// No description provided for @severe.
  ///
  /// In en, this message translates to:
  /// **'Severe'**
  String get severe;

  /// No description provided for @duration.
  ///
  /// In en, this message translates to:
  /// **'Duration'**
  String get duration;

  /// No description provided for @pleaseEnterDuration.
  ///
  /// In en, this message translates to:
  /// **'Please enter duration'**
  String get pleaseEnterDuration;

  /// No description provided for @notes.
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get notes;

  /// No description provided for @veryHappy.
  ///
  /// In en, this message translates to:
  /// **'Very happy'**
  String get veryHappy;

  /// No description provided for @happy.
  ///
  /// In en, this message translates to:
  /// **'Happy'**
  String get happy;

  /// No description provided for @neutral.
  ///
  /// In en, this message translates to:
  /// **'Neutral'**
  String get neutral;

  /// No description provided for @sad.
  ///
  /// In en, this message translates to:
  /// **'Sad'**
  String get sad;

  /// No description provided for @verySad.
  ///
  /// In en, this message translates to:
  /// **'Very sad'**
  String get verySad;

  /// No description provided for @pleaseSelectMood.
  ///
  /// In en, this message translates to:
  /// **'Please select a mood'**
  String get pleaseSelectMood;

  /// No description provided for @moodLoggedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Mood logged successfully!'**
  String get moodLoggedSuccessfully;

  /// No description provided for @howAreYouFeeling.
  ///
  /// In en, this message translates to:
  /// **'How are you feeling?'**
  String get howAreYouFeeling;

  /// No description provided for @energyLevel.
  ///
  /// In en, this message translates to:
  /// **'Energy level'**
  String get energyLevel;

  /// No description provided for @low.
  ///
  /// In en, this message translates to:
  /// **'Low'**
  String get low;

  /// No description provided for @high.
  ///
  /// In en, this message translates to:
  /// **'High'**
  String get high;

  /// No description provided for @elevated.
  ///
  /// In en, this message translates to:
  /// **'Elevated'**
  String get elevated;

  /// No description provided for @kg.
  ///
  /// In en, this message translates to:
  /// **'Kg'**
  String get kg;

  /// No description provided for @bpm.
  ///
  /// In en, this message translates to:
  /// **'bpm'**
  String get bpm;

  /// No description provided for @borderline.
  ///
  /// In en, this message translates to:
  /// **'Borderline'**
  String get borderline;

  /// No description provided for @analyzeWithAi.
  ///
  /// In en, this message translates to:
  /// **'Analyze with AI'**
  String get analyzeWithAi;

  /// No description provided for @aiAnalyzing.
  ///
  /// In en, this message translates to:
  /// **'Analyzing your results…'**
  String get aiAnalyzing;

  /// No description provided for @aiDisclaimerTitle.
  ///
  /// In en, this message translates to:
  /// **'Before you use AI analysis'**
  String get aiDisclaimerTitle;

  /// No description provided for @aiDisclaimerBody.
  ///
  /// In en, this message translates to:
  /// **'This feature uses AI to help you understand your lab results in plain language. It is educational only — not a diagnosis or medical advice, and not a substitute for your doctor or midwife. Your report is sent securely for analysis. Do you want to continue?'**
  String get aiDisclaimerBody;

  /// No description provided for @iUnderstandContinue.
  ///
  /// In en, this message translates to:
  /// **'I understand, continue'**
  String get iUnderstandContinue;

  /// No description provided for @aiNeedsConnection.
  ///
  /// In en, this message translates to:
  /// **'AI analysis needs an internet connection. Showing the standard view instead.'**
  String get aiNeedsConnection;

  /// No description provided for @aiRateLimited.
  ///
  /// In en, this message translates to:
  /// **'You\'ve reached today\'s AI analysis limit. Please try again tomorrow.'**
  String get aiRateLimited;

  /// No description provided for @aiAnalysisFailed.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t analyze the results right now. Please try again later.'**
  String get aiAnalysisFailed;

  /// No description provided for @aiResultTitle.
  ///
  /// In en, this message translates to:
  /// **'AI Lab Analysis'**
  String get aiResultTitle;

  /// No description provided for @aiOverallSummary.
  ///
  /// In en, this message translates to:
  /// **'Summary'**
  String get aiOverallSummary;

  /// No description provided for @aiGuidance.
  ///
  /// In en, this message translates to:
  /// **'Guidance'**
  String get aiGuidance;

  /// No description provided for @aiDetectedTests.
  ///
  /// In en, this message translates to:
  /// **'Your results'**
  String get aiDetectedTests;

  /// No description provided for @aiSeekCareTitle.
  ///
  /// In en, this message translates to:
  /// **'Please contact your provider'**
  String get aiSeekCareTitle;

  /// No description provided for @sleepQuality.
  ///
  /// In en, this message translates to:
  /// **'Sleep quality'**
  String get sleepQuality;

  /// No description provided for @howWasYourDay.
  ///
  /// In en, this message translates to:
  /// **'How was your day?'**
  String get howWasYourDay;

  /// No description provided for @prePregnancyBMI.
  ///
  /// In en, this message translates to:
  /// **'Pre-pregnancy BMI'**
  String get prePregnancyBMI;

  /// No description provided for @bmiUnderweight.
  ///
  /// In en, this message translates to:
  /// **'Underweight'**
  String get bmiUnderweight;

  /// No description provided for @bmiOverweight.
  ///
  /// In en, this message translates to:
  /// **'Overweight'**
  String get bmiOverweight;

  /// No description provided for @bmiObese.
  ///
  /// In en, this message translates to:
  /// **'Obese'**
  String get bmiObese;

  /// No description provided for @setUpBmiTracking.
  ///
  /// In en, this message translates to:
  /// **'Set up BMI tracking'**
  String get setUpBmiTracking;

  /// No description provided for @bmiSetupPrompt.
  ///
  /// In en, this message translates to:
  /// **'Add your height and pre-pregnancy weight to track BMI and healthy weight gain.'**
  String get bmiSetupPrompt;

  /// No description provided for @heightCmLabel.
  ///
  /// In en, this message translates to:
  /// **'Height (cm)'**
  String get heightCmLabel;

  /// No description provided for @prePregnancyWeightLabel.
  ///
  /// In en, this message translates to:
  /// **'Pre-pregnancy weight (kg)'**
  String get prePregnancyWeightLabel;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @normalBMI.
  ///
  /// In en, this message translates to:
  /// **'Normal'**
  String get normalBMI;

  /// No description provided for @currentGain.
  ///
  /// In en, this message translates to:
  /// **'Current gain'**
  String get currentGain;

  /// No description provided for @targetRange.
  ///
  /// In en, this message translates to:
  /// **'Target range'**
  String get targetRange;

  /// No description provided for @expected.
  ///
  /// In en, this message translates to:
  /// **'Expected'**
  String get expected;

  /// No description provided for @recentLabResults.
  ///
  /// In en, this message translates to:
  /// **'Recent Lab Results'**
  String get recentLabResults;

  /// No description provided for @keepLabResultsOrganized.
  ///
  /// In en, this message translates to:
  /// **'Keep your lab results organized for better tracking.'**
  String get keepLabResultsOrganized;

  /// No description provided for @viewAllLabResults.
  ///
  /// In en, this message translates to:
  /// **'View All Lab Results'**
  String get viewAllLabResults;

  /// No description provided for @riskFactorsToMonitor.
  ///
  /// In en, this message translates to:
  /// **'Risk factors to monitor'**
  String get riskFactorsToMonitor;

  /// No description provided for @lowRisk.
  ///
  /// In en, this message translates to:
  /// **'Low risk'**
  String get lowRisk;

  /// No description provided for @moderateRisk.
  ///
  /// In en, this message translates to:
  /// **'Moderate'**
  String get moderateRisk;

  /// No description provided for @highRisk.
  ///
  /// In en, this message translates to:
  /// **'High'**
  String get highRisk;

  /// No description provided for @monitorWithProvider.
  ///
  /// In en, this message translates to:
  /// **'Monitor and discuss with your provider'**
  String get monitorWithProvider;

  /// No description provided for @contactProviderSoon.
  ///
  /// In en, this message translates to:
  /// **'Contact your provider soon'**
  String get contactProviderSoon;

  /// No description provided for @addMeasurementToAssess.
  ///
  /// In en, this message translates to:
  /// **'Add a measurement to assess this'**
  String get addMeasurementToAssess;

  /// No description provided for @someIndicatorsElevated.
  ///
  /// In en, this message translates to:
  /// **'Some indicators are slightly elevated'**
  String get someIndicatorsElevated;

  /// No description provided for @someIndicatorsHigh.
  ///
  /// In en, this message translates to:
  /// **'Some indicators need attention'**
  String get someIndicatorsHigh;

  /// No description provided for @assessedFromYourData.
  ///
  /// In en, this message translates to:
  /// **'Based on your logged measurements'**
  String get assessedFromYourData;

  /// No description provided for @withinNormalRange.
  ///
  /// In en, this message translates to:
  /// **'Within normal range'**
  String get withinNormalRange;

  /// No description provided for @gestationalDiabetes.
  ///
  /// In en, this message translates to:
  /// **'Gestational diabetes'**
  String get gestationalDiabetes;

  /// No description provided for @glucoseLevelsNormal.
  ///
  /// In en, this message translates to:
  /// **'Glucose levels are normal'**
  String get glucoseLevelsNormal;

  /// No description provided for @preeclampsia.
  ///
  /// In en, this message translates to:
  /// **'Preeclampsia'**
  String get preeclampsia;

  /// No description provided for @noProteinInUrine.
  ///
  /// In en, this message translates to:
  /// **'No protein in urine'**
  String get noProteinInUrine;

  /// No description provided for @warningSignsToWatch.
  ///
  /// In en, this message translates to:
  /// **'Warning signs to watch'**
  String get warningSignsToWatch;

  /// No description provided for @severeHeadache.
  ///
  /// In en, this message translates to:
  /// **'Severe headache'**
  String get severeHeadache;

  /// No description provided for @blurredVision.
  ///
  /// In en, this message translates to:
  /// **'Blurred vision'**
  String get blurredVision;

  /// No description provided for @severeAbdominalPain.
  ///
  /// In en, this message translates to:
  /// **'Severe abdominal pain'**
  String get severeAbdominalPain;

  /// No description provided for @decreasedFetalMovement.
  ///
  /// In en, this message translates to:
  /// **'Decreased fetal movement'**
  String get decreasedFetalMovement;

  /// No description provided for @vaginalBleeding.
  ///
  /// In en, this message translates to:
  /// **'Vaginal bleeding'**
  String get vaginalBleeding;

  /// No description provided for @emergencyCall.
  ///
  /// In en, this message translates to:
  /// **'Emergency Call'**
  String get emergencyCall;

  /// No description provided for @areYouSureCall911.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to call emergency services?'**
  String get areYouSureCall911;

  /// No description provided for @couldNotMakeEmergencyCall.
  ///
  /// In en, this message translates to:
  /// **'Could not make emergency call.'**
  String get couldNotMakeEmergencyCall;

  /// No description provided for @ifYouExperienceWarnings.
  ///
  /// In en, this message translates to:
  /// **'If you experience any warning signs, contact your healthcare provider immediately.'**
  String get ifYouExperienceWarnings;

  /// No description provided for @allIndicatorsNormal.
  ///
  /// In en, this message translates to:
  /// **'All indicators are normal'**
  String get allIndicatorsNormal;

  /// No description provided for @emergencyContact.
  ///
  /// In en, this message translates to:
  /// **'Emergency Contact'**
  String get emergencyContact;

  /// No description provided for @overallRiskLevel.
  ///
  /// In en, this message translates to:
  /// **'Overall risk level'**
  String get overallRiskLevel;

  /// No description provided for @call911OrProvider.
  ///
  /// In en, this message translates to:
  /// **'Call emergency services or your healthcare provider'**
  String get call911OrProvider;

  /// No description provided for @recentSymptoms.
  ///
  /// In en, this message translates to:
  /// **'Recent Symptoms'**
  String get recentSymptoms;

  /// No description provided for @logNewSymptom.
  ///
  /// In en, this message translates to:
  /// **'Log new symptom'**
  String get logNewSymptom;

  /// No description provided for @symptomFrequency.
  ///
  /// In en, this message translates to:
  /// **'Symptom frequency'**
  String get symptomFrequency;

  /// No description provided for @swollenFeet.
  ///
  /// In en, this message translates to:
  /// **'Swollen feet'**
  String get swollenFeet;

  /// No description provided for @sleepIssues.
  ///
  /// In en, this message translates to:
  /// **'Sleep issues'**
  String get sleepIssues;

  /// No description provided for @times.
  ///
  /// In en, this message translates to:
  /// **'times'**
  String get times;

  /// No description provided for @commonSymptomsWeek24.
  ///
  /// In en, this message translates to:
  /// **'Common symptoms at week 24 include back pain and swelling.'**
  String get commonSymptomsWeek24;

  /// No description provided for @viewAllSymptoms.
  ///
  /// In en, this message translates to:
  /// **'View All Symptoms'**
  String get viewAllSymptoms;

  /// No description provided for @weightProgress.
  ///
  /// In en, this message translates to:
  /// **'Weight Progress'**
  String get weightProgress;

  /// No description provided for @measurementSavedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Measurement saved successfully!'**
  String get measurementSavedSuccessfully;

  /// No description provided for @addMeasurement.
  ///
  /// In en, this message translates to:
  /// **'Add Measurement'**
  String get addMeasurement;

  /// No description provided for @weightKg.
  ///
  /// In en, this message translates to:
  /// **'Weight (kg)'**
  String get weightKg;

  /// No description provided for @pleaseEnterWeight.
  ///
  /// In en, this message translates to:
  /// **'Please enter your weight'**
  String get pleaseEnterWeight;

  /// No description provided for @pleaseEnterValidNumber.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid number'**
  String get pleaseEnterValidNumber;

  /// No description provided for @weightRange.
  ///
  /// In en, this message translates to:
  /// **'Weight must be between 30 and 200 kg'**
  String get weightRange;

  /// No description provided for @heartRateBpm.
  ///
  /// In en, this message translates to:
  /// **'Heart Rate (bpm)'**
  String get heartRateBpm;

  /// No description provided for @pleaseEnterHeartRate.
  ///
  /// In en, this message translates to:
  /// **'Please enter your heart rate'**
  String get pleaseEnterHeartRate;

  /// No description provided for @heartRateRange.
  ///
  /// In en, this message translates to:
  /// **'Heart rate must be between 40 and 200 bpm'**
  String get heartRateRange;

  /// No description provided for @systolic.
  ///
  /// In en, this message translates to:
  /// **'Systolic'**
  String get systolic;

  /// No description provided for @required.
  ///
  /// In en, this message translates to:
  /// **'Required'**
  String get required;

  /// No description provided for @invalid.
  ///
  /// In en, this message translates to:
  /// **'Invalid'**
  String get invalid;

  /// No description provided for @systolicRange.
  ///
  /// In en, this message translates to:
  /// **'Systolic must be between 70 and 190'**
  String get systolicRange;

  /// No description provided for @diastolic.
  ///
  /// In en, this message translates to:
  /// **'Diastolic'**
  String get diastolic;

  /// No description provided for @diastolicRange.
  ///
  /// In en, this message translates to:
  /// **'Diastolic must be between 40 and 130'**
  String get diastolicRange;

  /// No description provided for @normalRangeLabel.
  ///
  /// In en, this message translates to:
  /// **'Normal range'**
  String get normalRangeLabel;

  /// No description provided for @uploadLabResults.
  ///
  /// In en, this message translates to:
  /// **'Upload Lab Results'**
  String get uploadLabResults;

  /// No description provided for @nextLabAppointment.
  ///
  /// In en, this message translates to:
  /// **'Next Lab Appointment'**
  String get nextLabAppointment;

  /// No description provided for @currentWeekLabel.
  ///
  /// In en, this message translates to:
  /// **'Current week'**
  String get currentWeekLabel;

  /// No description provided for @viewingWeek.
  ///
  /// In en, this message translates to:
  /// **'Viewing week {week}'**
  String viewingWeek(int week);

  /// No description provided for @previewingWeek.
  ///
  /// In en, this message translates to:
  /// **'Previewing week {selected} — your current week is {current}.'**
  String previewingWeek(int selected, int current);

  /// No description provided for @length.
  ///
  /// In en, this message translates to:
  /// **'Length'**
  String get length;

  /// No description provided for @whatToExpectWeek.
  ///
  /// In en, this message translates to:
  /// **'What to expect at week {week}'**
  String whatToExpectWeek(int week);

  /// No description provided for @kickCounter.
  ///
  /// In en, this message translates to:
  /// **'Kick counter'**
  String get kickCounter;

  /// No description provided for @noKickSessions.
  ///
  /// In en, this message translates to:
  /// **'No sessions recorded yet.'**
  String get noKickSessions;

  /// No description provided for @kicksValue.
  ///
  /// In en, this message translates to:
  /// **'{count} kicks'**
  String kicksValue(int count);

  /// No description provided for @minutesShort.
  ///
  /// In en, this message translates to:
  /// **'{minutes} min'**
  String minutesShort(int minutes);

  /// No description provided for @startLabel.
  ///
  /// In en, this message translates to:
  /// **'Start'**
  String get startLabel;

  /// No description provided for @tapToStartKicks.
  ///
  /// In en, this message translates to:
  /// **'Tap to start a kick-counting session'**
  String get tapToStartKicks;

  /// No description provided for @tapToCount.
  ///
  /// In en, this message translates to:
  /// **'Tap to count'**
  String get tapToCount;

  /// No description provided for @resetLabel.
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get resetLabel;

  /// No description provided for @finishLabel.
  ///
  /// In en, this message translates to:
  /// **'Finish'**
  String get finishLabel;

  /// No description provided for @sessionSaved.
  ///
  /// In en, this message translates to:
  /// **'Session saved: {count} kicks'**
  String sessionSaved(int count);

  /// No description provided for @weeksDaysSuffix.
  ///
  /// In en, this message translates to:
  /// **'weeks, {days} days'**
  String weeksDaysSuffix(int days);

  /// No description provided for @notSet.
  ///
  /// In en, this message translates to:
  /// **'Not set'**
  String get notSet;

  /// No description provided for @firstTrimester.
  ///
  /// In en, this message translates to:
  /// **'1st Trimester'**
  String get firstTrimester;

  /// No description provided for @secondTrimester.
  ///
  /// In en, this message translates to:
  /// **'2nd Trimester'**
  String get secondTrimester;

  /// No description provided for @thirdTrimester.
  ///
  /// In en, this message translates to:
  /// **'3rd Trimester'**
  String get thirdTrimester;

  /// No description provided for @weekNote4.
  ///
  /// In en, this message translates to:
  /// **'Baby\'s heart begins to form and will soon start beating.'**
  String get weekNote4;

  /// No description provided for @weekNote6.
  ///
  /// In en, this message translates to:
  /// **'Tiny buds that become the arms and legs are appearing.'**
  String get weekNote6;

  /// No description provided for @weekNote8.
  ///
  /// In en, this message translates to:
  /// **'Fingers, toes and the major organs are taking shape.'**
  String get weekNote8;

  /// No description provided for @weekNote10.
  ///
  /// In en, this message translates to:
  /// **'Vital organs are formed and baby can bend its limbs.'**
  String get weekNote10;

  /// No description provided for @weekNote12.
  ///
  /// In en, this message translates to:
  /// **'Reflexes kick in — baby may curl fingers and toes.'**
  String get weekNote12;

  /// No description provided for @weekNote14.
  ///
  /// In en, this message translates to:
  /// **'Facial muscles develop and baby starts making expressions.'**
  String get weekNote14;

  /// No description provided for @weekNote16.
  ///
  /// In en, this message translates to:
  /// **'Baby makes small movements you\'ll soon be able to feel.'**
  String get weekNote16;

  /// No description provided for @weekNote20.
  ///
  /// In en, this message translates to:
  /// **'Halfway there! Baby is settling into a sleep-wake rhythm.'**
  String get weekNote20;

  /// No description provided for @weekNote24.
  ///
  /// In en, this message translates to:
  /// **'Baby\'s lungs keep developing and hearing is improving.'**
  String get weekNote24;

  /// No description provided for @weekNote28.
  ///
  /// In en, this message translates to:
  /// **'Eyes can open and close, and baby responds to sounds.'**
  String get weekNote28;

  /// No description provided for @weekNote32.
  ///
  /// In en, this message translates to:
  /// **'Baby practices breathing and is gaining weight quickly.'**
  String get weekNote32;

  /// No description provided for @weekNote36.
  ///
  /// In en, this message translates to:
  /// **'Baby usually settles head-down; the lungs are nearly ready.'**
  String get weekNote36;

  /// No description provided for @weekNote40.
  ///
  /// In en, this message translates to:
  /// **'Full term! Baby could arrive any day now.'**
  String get weekNote40;

  /// No description provided for @trackTitle.
  ///
  /// In en, this message translates to:
  /// **'Track'**
  String get trackTitle;

  /// No description provided for @trackingTools.
  ///
  /// In en, this message translates to:
  /// **'Tracking tools'**
  String get trackingTools;

  /// No description provided for @babyProgress.
  ///
  /// In en, this message translates to:
  /// **'Baby progress'**
  String get babyProgress;

  /// No description provided for @noMilestonesYet.
  ///
  /// In en, this message translates to:
  /// **'No milestones added yet'**
  String get noMilestonesYet;

  /// No description provided for @milestonesReached.
  ///
  /// In en, this message translates to:
  /// **'{achieved} of {total} milestones reached'**
  String milestonesReached(int achieved, int total);

  /// No description provided for @latestWeightValue.
  ///
  /// In en, this message translates to:
  /// **'Latest weight: {weight} kg'**
  String latestWeightValue(String weight);

  /// No description provided for @feedsToday.
  ///
  /// In en, this message translates to:
  /// **'Feeds today'**
  String get feedsToday;

  /// No description provided for @lastFeedAt.
  ///
  /// In en, this message translates to:
  /// **'Last {time}'**
  String lastFeedAt(String time);

  /// No description provided for @noFeedsYet.
  ///
  /// In en, this message translates to:
  /// **'No feeds yet'**
  String get noFeedsYet;

  /// No description provided for @latestWeight.
  ///
  /// In en, this message translates to:
  /// **'Latest weight'**
  String get latestWeight;

  /// No description provided for @recorded.
  ///
  /// In en, this message translates to:
  /// **'Recorded'**
  String get recorded;

  /// No description provided for @milestonesLabel.
  ///
  /// In en, this message translates to:
  /// **'Milestones'**
  String get milestonesLabel;

  /// No description provided for @achievedLabel.
  ///
  /// In en, this message translates to:
  /// **'Achieved'**
  String get achievedLabel;

  /// No description provided for @feedingLogTitle.
  ///
  /// In en, this message translates to:
  /// **'Feeding Log'**
  String get feedingLogTitle;

  /// No description provided for @feedingLogSub.
  ///
  /// In en, this message translates to:
  /// **'Track feeds'**
  String get feedingLogSub;

  /// No description provided for @growthTrackerTitle.
  ///
  /// In en, this message translates to:
  /// **'Growth Tracker'**
  String get growthTrackerTitle;

  /// No description provided for @growthTrackerSub.
  ///
  /// In en, this message translates to:
  /// **'Weight & height'**
  String get growthTrackerSub;

  /// No description provided for @milestonesSub.
  ///
  /// In en, this message translates to:
  /// **'Development'**
  String get milestonesSub;

  /// No description provided for @vaccinesTitle.
  ///
  /// In en, this message translates to:
  /// **'Vaccines'**
  String get vaccinesTitle;

  /// No description provided for @vaccinesSub.
  ///
  /// In en, this message translates to:
  /// **'Immunization'**
  String get vaccinesSub;

  /// No description provided for @noBabyProfile.
  ///
  /// In en, this message translates to:
  /// **'No baby profile yet'**
  String get noBabyProfile;

  /// No description provided for @addBabyPrompt.
  ///
  /// In en, this message translates to:
  /// **'Add your baby to start tracking feeds, growth, milestones and vaccines.'**
  String get addBabyPrompt;

  /// No description provided for @breastfeed.
  ///
  /// In en, this message translates to:
  /// **'Breastfeed'**
  String get breastfeed;

  /// No description provided for @bottle.
  ///
  /// In en, this message translates to:
  /// **'Bottle'**
  String get bottle;

  /// No description provided for @logAFeed.
  ///
  /// In en, this message translates to:
  /// **'Log a feed'**
  String get logAFeed;

  /// No description provided for @logFeed.
  ///
  /// In en, this message translates to:
  /// **'Log feed'**
  String get logFeed;

  /// No description provided for @amountMlOptional.
  ///
  /// In en, this message translates to:
  /// **'Amount (ml) — optional'**
  String get amountMlOptional;

  /// No description provided for @durationMinOptional.
  ///
  /// In en, this message translates to:
  /// **'Duration (min) — optional'**
  String get durationMinOptional;

  /// No description provided for @feedLogged.
  ///
  /// In en, this message translates to:
  /// **'Feed logged'**
  String get feedLogged;

  /// No description provided for @saveUpper.
  ///
  /// In en, this message translates to:
  /// **'SAVE'**
  String get saveUpper;

  /// No description provided for @ageNewborn.
  ///
  /// In en, this message translates to:
  /// **'Newborn'**
  String get ageNewborn;

  /// No description provided for @ageMonths.
  ///
  /// In en, this message translates to:
  /// **'{months} mo old'**
  String ageMonths(int months);

  /// No description provided for @ageYears.
  ///
  /// In en, this message translates to:
  /// **'{years}y old'**
  String ageYears(int years);

  /// No description provided for @ageYearsMonths.
  ///
  /// In en, this message translates to:
  /// **'{years}y {months}mo old'**
  String ageYearsMonths(int years, int months);

  /// No description provided for @languages.
  ///
  /// In en, this message translates to:
  /// **'Languages'**
  String get languages;

  /// No description provided for @chooseLanguage.
  ///
  /// In en, this message translates to:
  /// **'Choose your preferred language'**
  String get chooseLanguage;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @french.
  ///
  /// In en, this message translates to:
  /// **'French'**
  String get french;

  /// No description provided for @arabic.
  ///
  /// In en, this message translates to:
  /// **'Arabic'**
  String get arabic;

  /// No description provided for @faq.
  ///
  /// In en, this message translates to:
  /// **'FAQ'**
  String get faq;

  /// No description provided for @congratsBabyAdded.
  ///
  /// In en, this message translates to:
  /// **'Congratulations! Your baby has been added 🎉'**
  String get congratsBabyAdded;

  /// No description provided for @endPregnancyConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure? This will end your pregnancy tracking.'**
  String get endPregnancyConfirm;

  /// No description provided for @pregnancyTrackingEnded.
  ///
  /// In en, this message translates to:
  /// **'Pregnancy tracking ended'**
  String get pregnancyTrackingEnded;

  /// No description provided for @secureYourAccount.
  ///
  /// In en, this message translates to:
  /// **'Secure your account'**
  String get secureYourAccount;

  /// No description provided for @secureYourAccountDesc.
  ///
  /// In en, this message translates to:
  /// **'Enable additional security features to protect your personal health information'**
  String get secureYourAccountDesc;

  /// No description provided for @changePassword.
  ///
  /// In en, this message translates to:
  /// **'Change password'**
  String get changePassword;

  /// No description provided for @lastChanged30Days.
  ///
  /// In en, this message translates to:
  /// **'Last changed 30 days ago'**
  String get lastChanged30Days;

  /// No description provided for @biometricAuth.
  ///
  /// In en, this message translates to:
  /// **'Biometric authentication'**
  String get biometricAuth;

  /// No description provided for @biometricAuthDesc.
  ///
  /// In en, this message translates to:
  /// **'Use fingerprint or Face ID to unlock'**
  String get biometricAuthDesc;

  /// No description provided for @twoFactorAuth.
  ///
  /// In en, this message translates to:
  /// **'Two-factor authentication'**
  String get twoFactorAuth;

  /// No description provided for @twoFactorAuthDesc.
  ///
  /// In en, this message translates to:
  /// **'Add an extra layer of security'**
  String get twoFactorAuthDesc;

  /// No description provided for @autoLock.
  ///
  /// In en, this message translates to:
  /// **'Auto-lock'**
  String get autoLock;

  /// No description provided for @autoLockDesc.
  ///
  /// In en, this message translates to:
  /// **'Lock app after 5 minutes of inactivity'**
  String get autoLockDesc;

  /// No description provided for @manageNotifPrefs.
  ///
  /// In en, this message translates to:
  /// **'Manage your notification preferences'**
  String get manageNotifPrefs;

  /// No description provided for @pushNotifications.
  ///
  /// In en, this message translates to:
  /// **'Push notifications'**
  String get pushNotifications;

  /// No description provided for @pushNotificationsDesc.
  ///
  /// In en, this message translates to:
  /// **'Receive notifications on your device'**
  String get pushNotificationsDesc;

  /// No description provided for @emailNotifications.
  ///
  /// In en, this message translates to:
  /// **'Email notifications'**
  String get emailNotifications;

  /// No description provided for @emailNotificationsDesc.
  ///
  /// In en, this message translates to:
  /// **'Get updates via email'**
  String get emailNotificationsDesc;

  /// No description provided for @appointmentReminders.
  ///
  /// In en, this message translates to:
  /// **'Appointment reminders'**
  String get appointmentReminders;

  /// No description provided for @appointmentRemindersDesc.
  ///
  /// In en, this message translates to:
  /// **'Never miss a doctor\'s appointment'**
  String get appointmentRemindersDesc;

  /// No description provided for @healthTips.
  ///
  /// In en, this message translates to:
  /// **'Health tips'**
  String get healthTips;

  /// No description provided for @healthTipsDesc.
  ///
  /// In en, this message translates to:
  /// **'Daily wellness recommendations'**
  String get healthTipsDesc;

  /// No description provided for @weeklyReports.
  ///
  /// In en, this message translates to:
  /// **'Weekly reports'**
  String get weeklyReports;

  /// No description provided for @weeklyReportsDesc.
  ///
  /// In en, this message translates to:
  /// **'Summary of your health progress'**
  String get weeklyReportsDesc;

  /// No description provided for @vitaminReminders.
  ///
  /// In en, this message translates to:
  /// **'Vitamin reminders'**
  String get vitaminReminders;

  /// No description provided for @vitaminRemindersDesc.
  ///
  /// In en, this message translates to:
  /// **'Don\'t forget your supplements'**
  String get vitaminRemindersDesc;

  /// No description provided for @contactsTitle.
  ///
  /// In en, this message translates to:
  /// **'Contacts'**
  String get contactsTitle;

  /// No description provided for @getInTouch.
  ///
  /// In en, this message translates to:
  /// **'Get in touch'**
  String get getInTouch;

  /// No description provided for @getInTouchDesc.
  ///
  /// In en, this message translates to:
  /// **'Have a question or feedback? We\'d love to hear from you. Fill out the form below and we\'ll get back to you within 24 hours.'**
  String get getInTouchDesc;

  /// No description provided for @yourName.
  ///
  /// In en, this message translates to:
  /// **'Your name'**
  String get yourName;

  /// No description provided for @enterYourName.
  ///
  /// In en, this message translates to:
  /// **'Enter your name'**
  String get enterYourName;

  /// No description provided for @emailAddress.
  ///
  /// In en, this message translates to:
  /// **'Email address'**
  String get emailAddress;

  /// No description provided for @subjectLabel.
  ///
  /// In en, this message translates to:
  /// **'Subject'**
  String get subjectLabel;

  /// No description provided for @subjectHint.
  ///
  /// In en, this message translates to:
  /// **'What is this about?'**
  String get subjectHint;

  /// No description provided for @messageLabel.
  ///
  /// In en, this message translates to:
  /// **'Message'**
  String get messageLabel;

  /// No description provided for @messageHint.
  ///
  /// In en, this message translates to:
  /// **'Tell us how we can help...'**
  String get messageHint;

  /// No description provided for @sendMessage.
  ///
  /// In en, this message translates to:
  /// **'Send message'**
  String get sendMessage;

  /// No description provided for @wereHereToHelp.
  ///
  /// In en, this message translates to:
  /// **'We\'re here to help'**
  String get wereHereToHelp;

  /// No description provided for @wereHereToHelpDesc.
  ///
  /// In en, this message translates to:
  /// **'Choose the support option that works best for you. Our team is available 24/7 to assist you.'**
  String get wereHereToHelpDesc;

  /// No description provided for @knowledgeBase.
  ///
  /// In en, this message translates to:
  /// **'Knowledge base'**
  String get knowledgeBase;

  /// No description provided for @knowledgeBaseDesc.
  ///
  /// In en, this message translates to:
  /// **'Browse articles and guides'**
  String get knowledgeBaseDesc;

  /// No description provided for @liveChat.
  ///
  /// In en, this message translates to:
  /// **'Live chat'**
  String get liveChat;

  /// No description provided for @liveChatDesc.
  ///
  /// In en, this message translates to:
  /// **'Chat with our support team'**
  String get liveChatDesc;

  /// No description provided for @videoTutorials.
  ///
  /// In en, this message translates to:
  /// **'Video tutorials'**
  String get videoTutorials;

  /// No description provided for @videoTutorialsDesc.
  ///
  /// In en, this message translates to:
  /// **'Watch step-by-step guides'**
  String get videoTutorialsDesc;

  /// No description provided for @emailSupport.
  ///
  /// In en, this message translates to:
  /// **'Email support'**
  String get emailSupport;

  /// No description provided for @phoneSupport.
  ///
  /// In en, this message translates to:
  /// **'Phone support'**
  String get phoneSupport;

  /// No description provided for @communityForum.
  ///
  /// In en, this message translates to:
  /// **'Community forum'**
  String get communityForum;

  /// No description provided for @communityForumDesc.
  ///
  /// In en, this message translates to:
  /// **'Connect with other users'**
  String get communityForumDesc;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @noBabyProfileFound.
  ///
  /// In en, this message translates to:
  /// **'No baby profile found. Please add your baby first.'**
  String get noBabyProfileFound;

  /// No description provided for @totalTime.
  ///
  /// In en, this message translates to:
  /// **'Total time'**
  String get totalTime;

  /// No description provided for @recentFeedings.
  ///
  /// In en, this message translates to:
  /// **'Recent feedings'**
  String get recentFeedings;

  /// No description provided for @viewAll.
  ///
  /// In en, this message translates to:
  /// **'View all'**
  String get viewAll;

  /// No description provided for @noFeedingLogs.
  ///
  /// In en, this message translates to:
  /// **'No feeding logs yet'**
  String get noFeedingLogs;

  /// No description provided for @addFeeding.
  ///
  /// In en, this message translates to:
  /// **'Add feeding'**
  String get addFeeding;

  /// No description provided for @feedingTypeLabel.
  ///
  /// In en, this message translates to:
  /// **'Feeding type'**
  String get feedingTypeLabel;

  /// No description provided for @durationMinutesLabel.
  ///
  /// In en, this message translates to:
  /// **'Duration (minutes)'**
  String get durationMinutesLabel;

  /// No description provided for @amountMlLabel.
  ///
  /// In en, this message translates to:
  /// **'Amount (ml)'**
  String get amountMlLabel;

  /// No description provided for @sideOptional.
  ///
  /// In en, this message translates to:
  /// **'Side (optional)'**
  String get sideOptional;

  /// No description provided for @notSpecified.
  ///
  /// In en, this message translates to:
  /// **'Not specified'**
  String get notSpecified;

  /// No description provided for @sideLeft.
  ///
  /// In en, this message translates to:
  /// **'Left'**
  String get sideLeft;

  /// No description provided for @sideRight.
  ///
  /// In en, this message translates to:
  /// **'Right'**
  String get sideRight;

  /// No description provided for @sideBoth.
  ///
  /// In en, this message translates to:
  /// **'Both'**
  String get sideBoth;

  /// No description provided for @timeLabel.
  ///
  /// In en, this message translates to:
  /// **'Time'**
  String get timeLabel;

  /// No description provided for @mlValue.
  ///
  /// In en, this message translates to:
  /// **'{ml} ml'**
  String mlValue(String ml);

  /// No description provided for @minSideValue.
  ///
  /// In en, this message translates to:
  /// **'{min} min · {side}'**
  String minSideValue(int min, String side);

  /// No description provided for @currentWeight.
  ///
  /// In en, this message translates to:
  /// **'Current weight'**
  String get currentWeight;

  /// No description provided for @noData.
  ///
  /// In en, this message translates to:
  /// **'No data'**
  String get noData;

  /// No description provided for @lastUpdated.
  ///
  /// In en, this message translates to:
  /// **'Last updated: {date}'**
  String lastUpdated(String date);

  /// No description provided for @noRecordsYet.
  ///
  /// In en, this message translates to:
  /// **'No records yet'**
  String get noRecordsYet;

  /// No description provided for @weightProgressChart.
  ///
  /// In en, this message translates to:
  /// **'Weight progress chart'**
  String get weightProgressChart;

  /// No description provided for @chartPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Chart visualization would go here'**
  String get chartPlaceholder;

  /// No description provided for @recentLogs.
  ///
  /// In en, this message translates to:
  /// **'Recent logs'**
  String get recentLogs;

  /// No description provided for @noWeightRecords.
  ///
  /// In en, this message translates to:
  /// **'No weight records yet'**
  String get noWeightRecords;

  /// No description provided for @addWeightLog.
  ///
  /// In en, this message translates to:
  /// **'Add weight log'**
  String get addWeightLog;

  /// No description provided for @dateLabel.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get dateLabel;

  /// No description provided for @kgValue.
  ///
  /// In en, this message translates to:
  /// **'{value} kg'**
  String kgValue(String value);

  /// No description provided for @completedLabel.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get completedLabel;

  /// No description provided for @developmentalMilestones.
  ///
  /// In en, this message translates to:
  /// **'Developmental milestones'**
  String get developmentalMilestones;

  /// No description provided for @expectedAtMonths.
  ///
  /// In en, this message translates to:
  /// **'Expected at {months} months'**
  String expectedAtMonths(String months);

  /// No description provided for @completedOn.
  ///
  /// In en, this message translates to:
  /// **'Completed: {date}'**
  String completedOn(String date);

  /// No description provided for @addMilestoneTitle.
  ///
  /// In en, this message translates to:
  /// **'Add milestone'**
  String get addMilestoneTitle;

  /// No description provided for @milestoneTitle.
  ///
  /// In en, this message translates to:
  /// **'Milestone title'**
  String get milestoneTitle;

  /// No description provided for @expectedAgeMonthsLabel.
  ///
  /// In en, this message translates to:
  /// **'Expected age (months)'**
  String get expectedAgeMonthsLabel;

  /// No description provided for @addLabel.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get addLabel;

  /// No description provided for @msFirstSmile.
  ///
  /// In en, this message translates to:
  /// **'First smile'**
  String get msFirstSmile;

  /// No description provided for @msHoldsHeadUp.
  ///
  /// In en, this message translates to:
  /// **'Holds head up'**
  String get msHoldsHeadUp;

  /// No description provided for @msRollsOver.
  ///
  /// In en, this message translates to:
  /// **'Rolls over'**
  String get msRollsOver;

  /// No description provided for @msSitsWithoutSupport.
  ///
  /// In en, this message translates to:
  /// **'Sits without support'**
  String get msSitsWithoutSupport;

  /// No description provided for @msCrawls.
  ///
  /// In en, this message translates to:
  /// **'Crawls'**
  String get msCrawls;

  /// No description provided for @msFirstWords.
  ///
  /// In en, this message translates to:
  /// **'First words'**
  String get msFirstWords;

  /// No description provided for @notAvailable.
  ///
  /// In en, this message translates to:
  /// **'N/A'**
  String get notAvailable;

  /// No description provided for @vaccineTrackerTitle.
  ///
  /// In en, this message translates to:
  /// **'Vaccine tracker'**
  String get vaccineTrackerTitle;

  /// No description provided for @seeFullSchedule.
  ///
  /// In en, this message translates to:
  /// **'See full schedule'**
  String get seeFullSchedule;

  /// No description provided for @upcomingLabel.
  ///
  /// In en, this message translates to:
  /// **'Upcoming'**
  String get upcomingLabel;

  /// No description provided for @helloGreeting.
  ///
  /// In en, this message translates to:
  /// **'Hello!'**
  String get helloGreeting;

  /// No description provided for @hello.
  ///
  /// In en, this message translates to:
  /// **'Hello'**
  String get hello;

  /// No description provided for @ourDoctors.
  ///
  /// In en, this message translates to:
  /// **'Our Doctors'**
  String get ourDoctors;

  /// No description provided for @findBestDoctor.
  ///
  /// In en, this message translates to:
  /// **'find the best doctor'**
  String get findBestDoctor;

  /// No description provided for @upComing.
  ///
  /// In en, this message translates to:
  /// **'Up coming'**
  String get upComing;

  /// No description provided for @overdue.
  ///
  /// In en, this message translates to:
  /// **'Overdue'**
  String get overdue;

  /// No description provided for @inMinutes.
  ///
  /// In en, this message translates to:
  /// **'In {minutes} minutes'**
  String inMinutes(int minutes);

  /// No description provided for @inHours.
  ///
  /// In en, this message translates to:
  /// **'In {hours} hours'**
  String inHours(int hours);

  /// No description provided for @noUpcomingEvents.
  ///
  /// In en, this message translates to:
  /// **'No upcoming events'**
  String get noUpcomingEvents;

  /// No description provided for @addAppointmentsInPlan.
  ///
  /// In en, this message translates to:
  /// **'Add appointments in Plan'**
  String get addAppointmentsInPlan;

  /// No description provided for @atTimeFormat.
  ///
  /// In en, this message translates to:
  /// **'{day} at {time}'**
  String atTimeFormat(String day, String time);

  /// No description provided for @allCaughtUp.
  ///
  /// In en, this message translates to:
  /// **'You\'re all caught up'**
  String get allCaughtUp;

  /// No description provided for @noNotificationsDesc.
  ///
  /// In en, this message translates to:
  /// **'No new notifications right now.'**
  String get noNotificationsDesc;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @showMore.
  ///
  /// In en, this message translates to:
  /// **'Show more'**
  String get showMore;

  /// No description provided for @showLess.
  ///
  /// In en, this message translates to:
  /// **'Show less'**
  String get showLess;

  /// No description provided for @daysToGoLabel.
  ///
  /// In en, this message translates to:
  /// **'DAYS TO GO'**
  String get daysToGoLabel;

  /// No description provided for @weekLabel.
  ///
  /// In en, this message translates to:
  /// **'WEEK'**
  String get weekLabel;

  /// No description provided for @daysLeftLabel.
  ///
  /// In en, this message translates to:
  /// **'DAYS LEFT'**
  String get daysLeftLabel;

  /// No description provided for @moreLabel.
  ///
  /// In en, this message translates to:
  /// **'More'**
  String get moreLabel;

  /// No description provided for @plusDays.
  ///
  /// In en, this message translates to:
  /// **'+{day} days'**
  String plusDays(int day);

  /// No description provided for @ourTips.
  ///
  /// In en, this message translates to:
  /// **'Our Tips'**
  String get ourTips;

  /// No description provided for @followBestPractices.
  ///
  /// In en, this message translates to:
  /// **'follow best practices'**
  String get followBestPractices;

  /// No description provided for @allGoodNoAlerts.
  ///
  /// In en, this message translates to:
  /// **'All good! No health alerts at the moment.'**
  String get allGoodNoAlerts;

  /// No description provided for @babyDefault.
  ///
  /// In en, this message translates to:
  /// **'Baby'**
  String get babyDefault;

  /// No description provided for @heightLabel.
  ///
  /// In en, this message translates to:
  /// **'Height'**
  String get heightLabel;

  /// No description provided for @growthLabel.
  ///
  /// In en, this message translates to:
  /// **'Growth'**
  String get growthLabel;

  /// No description provided for @allCaughtUpShort.
  ///
  /// In en, this message translates to:
  /// **'All caught up!'**
  String get allCaughtUpShort;

  /// No description provided for @nextColon.
  ///
  /// In en, this message translates to:
  /// **'Next: {date}'**
  String nextColon(String date);

  /// No description provided for @vaccineOverdue.
  ///
  /// In en, this message translates to:
  /// **'{name}: Overdue'**
  String vaccineOverdue(String name);

  /// No description provided for @vaccineToday.
  ///
  /// In en, this message translates to:
  /// **'{name}: Today'**
  String vaccineToday(String name);

  /// No description provided for @vaccineOn.
  ///
  /// In en, this message translates to:
  /// **'{name}: {date}'**
  String vaccineOn(String name, String date);

  /// No description provided for @noUpcomingVaccines.
  ///
  /// In en, this message translates to:
  /// **'No upcoming vaccines'**
  String get noUpcomingVaccines;

  /// No description provided for @tipsTitle.
  ///
  /// In en, this message translates to:
  /// **'Tips'**
  String get tipsTitle;

  /// No description provided for @catWellness.
  ///
  /// In en, this message translates to:
  /// **'Wellness'**
  String get catWellness;

  /// No description provided for @catNutrition.
  ///
  /// In en, this message translates to:
  /// **'Nutrition'**
  String get catNutrition;

  /// No description provided for @catExercise.
  ///
  /// In en, this message translates to:
  /// **'Exercise'**
  String get catExercise;

  /// No description provided for @catSleep.
  ///
  /// In en, this message translates to:
  /// **'Sleep'**
  String get catSleep;

  /// No description provided for @catMind.
  ///
  /// In en, this message translates to:
  /// **'Mind'**
  String get catMind;

  /// No description provided for @minRead.
  ///
  /// In en, this message translates to:
  /// **'{minutes} min read'**
  String minRead(int minutes);

  /// No description provided for @tip1Title.
  ///
  /// In en, this message translates to:
  /// **'Eating for Two'**
  String get tip1Title;

  /// No description provided for @tip1Summary.
  ///
  /// In en, this message translates to:
  /// **'Essential nutrients and meal planning for a healthy pregnancy'**
  String get tip1Summary;

  /// No description provided for @tip2Title.
  ///
  /// In en, this message translates to:
  /// **'Gentle Prenatal Stretches'**
  String get tip2Title;

  /// No description provided for @tip2Summary.
  ///
  /// In en, this message translates to:
  /// **'Low-impact moves to ease back pain and stay flexible'**
  String get tip2Summary;

  /// No description provided for @tip3Title.
  ///
  /// In en, this message translates to:
  /// **'Sleep Better While Pregnant'**
  String get tip3Title;

  /// No description provided for @tip3Summary.
  ///
  /// In en, this message translates to:
  /// **'Pillow tricks and positions that actually work'**
  String get tip3Summary;

  /// No description provided for @tip4Title.
  ///
  /// In en, this message translates to:
  /// **'Managing Morning Sickness'**
  String get tip4Title;

  /// No description provided for @tip4Summary.
  ///
  /// In en, this message translates to:
  /// **'What helps, what doesn’t, and when to see a doctor'**
  String get tip4Summary;

  /// No description provided for @myLabResults.
  ///
  /// In en, this message translates to:
  /// **'My Lab Results'**
  String get myLabResults;

  /// No description provided for @exportAsZip.
  ///
  /// In en, this message translates to:
  /// **'Export as ZIP'**
  String get exportAsZip;

  /// No description provided for @exporting.
  ///
  /// In en, this message translates to:
  /// **'Exporting...'**
  String get exporting;

  /// No description provided for @noLabResultsYet.
  ///
  /// In en, this message translates to:
  /// **'No lab results yet!'**
  String get noLabResultsYet;

  /// No description provided for @uploadFirstLabResult.
  ///
  /// In en, this message translates to:
  /// **'Upload your first lab result to get started.'**
  String get uploadFirstLabResult;

  /// No description provided for @normalLabel.
  ///
  /// In en, this message translates to:
  /// **'Normal'**
  String get normalLabel;

  /// No description provided for @autoExtracted.
  ///
  /// In en, this message translates to:
  /// **'Auto-extracted'**
  String get autoExtracted;

  /// No description provided for @labResultImage.
  ///
  /// In en, this message translates to:
  /// **'Lab Result Image'**
  String get labResultImage;

  /// No description provided for @deleteResult.
  ///
  /// In en, this message translates to:
  /// **'Delete Result'**
  String get deleteResult;

  /// No description provided for @deleteResultConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete {name}?'**
  String deleteResultConfirm(String name);

  /// No description provided for @exportLabResults.
  ///
  /// In en, this message translates to:
  /// **'Export Lab Results'**
  String get exportLabResults;

  /// No description provided for @exportZipConfirm.
  ///
  /// In en, this message translates to:
  /// **'Export all lab result images as a ZIP file?'**
  String get exportZipConfirm;

  /// No description provided for @export.
  ///
  /// In en, this message translates to:
  /// **'Export'**
  String get export;

  /// No description provided for @normalRangeValue.
  ///
  /// In en, this message translates to:
  /// **'Normal: {min}-{max} {unit}'**
  String normalRangeValue(String min, String max, String unit);

  /// No description provided for @labResultAdded.
  ///
  /// In en, this message translates to:
  /// **'Lab result added successfully!'**
  String get labResultAdded;

  /// No description provided for @manualLabEntry.
  ///
  /// In en, this message translates to:
  /// **'Manual Lab Entry'**
  String get manualLabEntry;

  /// No description provided for @enterLabDetails.
  ///
  /// In en, this message translates to:
  /// **'Enter Lab Result Details'**
  String get enterLabDetails;

  /// No description provided for @testNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Test Name *'**
  String get testNameRequired;

  /// No description provided for @pleaseEnterTestName.
  ///
  /// In en, this message translates to:
  /// **'Please enter test name'**
  String get pleaseEnterTestName;

  /// No description provided for @valueRequired.
  ///
  /// In en, this message translates to:
  /// **'Value *'**
  String get valueRequired;

  /// No description provided for @pleaseEnterValue.
  ///
  /// In en, this message translates to:
  /// **'Please enter value'**
  String get pleaseEnterValue;

  /// No description provided for @unitLabel.
  ///
  /// In en, this message translates to:
  /// **'Unit'**
  String get unitLabel;

  /// No description provided for @minLabel.
  ///
  /// In en, this message translates to:
  /// **'Min'**
  String get minLabel;

  /// No description provided for @maxLabel.
  ///
  /// In en, this message translates to:
  /// **'Max'**
  String get maxLabel;

  /// No description provided for @testDate.
  ///
  /// In en, this message translates to:
  /// **'Test Date'**
  String get testDate;

  /// No description provided for @notesOptional.
  ///
  /// In en, this message translates to:
  /// **'Notes (Optional)'**
  String get notesOptional;

  /// No description provided for @anyAdditionalNotes.
  ///
  /// In en, this message translates to:
  /// **'Any additional notes...'**
  String get anyAdditionalNotes;

  /// No description provided for @saveResult.
  ///
  /// In en, this message translates to:
  /// **'Save Result'**
  String get saveResult;

  /// No description provided for @myMeasurements.
  ///
  /// In en, this message translates to:
  /// **'My Measurements'**
  String get myMeasurements;

  /// No description provided for @noMeasurementsYet.
  ///
  /// In en, this message translates to:
  /// **'No measurements yet!'**
  String get noMeasurementsYet;

  /// No description provided for @tapAddMeasurement.
  ///
  /// In en, this message translates to:
  /// **'Tap \"Add Measurement\" to start.'**
  String get tapAddMeasurement;

  /// No description provided for @mySymptoms.
  ///
  /// In en, this message translates to:
  /// **'My Symptoms'**
  String get mySymptoms;

  /// No description provided for @noSymptomsYet.
  ///
  /// In en, this message translates to:
  /// **'No symptoms logged yet!'**
  String get noSymptomsYet;

  /// No description provided for @tapLogSymptom.
  ///
  /// In en, this message translates to:
  /// **'Tap \"Log New Symptom\" to start.'**
  String get tapLogSymptom;

  /// No description provided for @pdfLabReport.
  ///
  /// In en, this message translates to:
  /// **'PDF Lab Report'**
  String get pdfLabReport;

  /// No description provided for @pdfSavedSnack.
  ///
  /// In en, this message translates to:
  /// **'PDF saved!'**
  String get pdfSavedSnack;

  /// No description provided for @pdfSavedTitle.
  ///
  /// In en, this message translates to:
  /// **'PDF Saved'**
  String get pdfSavedTitle;

  /// No description provided for @filePrefix.
  ///
  /// In en, this message translates to:
  /// **'File: {name}'**
  String filePrefix(String name);

  /// No description provided for @savePdfReference.
  ///
  /// In en, this message translates to:
  /// **'Save PDF Reference'**
  String get savePdfReference;

  /// No description provided for @enterDataManually.
  ///
  /// In en, this message translates to:
  /// **'Enter Data Manually'**
  String get enterDataManually;

  /// No description provided for @ocrFailed.
  ///
  /// In en, this message translates to:
  /// **'OCR failed: {error}'**
  String ocrFailed(String error);

  /// No description provided for @noImageSaved.
  ///
  /// In en, this message translates to:
  /// **'No image saved. Please try again.'**
  String get noImageSaved;

  /// No description provided for @noDataExtracted.
  ///
  /// In en, this message translates to:
  /// **'No Data Extracted'**
  String get noDataExtracted;

  /// No description provided for @ocrNoResultsPrompt.
  ///
  /// In en, this message translates to:
  /// **'OCR could not extract lab results. Would you like to:\n\n1. Save just the image for reference\n2. Enter data manually'**
  String get ocrNoResultsPrompt;

  /// No description provided for @labReport.
  ///
  /// In en, this message translates to:
  /// **'Lab Report'**
  String get labReport;

  /// No description provided for @imageSavedAddLater.
  ///
  /// In en, this message translates to:
  /// **'Image saved! You can add details later.'**
  String get imageSavedAddLater;

  /// No description provided for @saveImageOnly.
  ///
  /// In en, this message translates to:
  /// **'Save Image Only'**
  String get saveImageOnly;

  /// No description provided for @enterManually.
  ///
  /// In en, this message translates to:
  /// **'Enter Manually'**
  String get enterManually;

  /// No description provided for @labResultsSaved.
  ///
  /// In en, this message translates to:
  /// **'Lab results saved successfully!'**
  String get labResultsSaved;

  /// No description provided for @extractLabResults.
  ///
  /// In en, this message translates to:
  /// **'Extract Lab Results'**
  String get extractLabResults;

  /// No description provided for @extractingText.
  ///
  /// In en, this message translates to:
  /// **'Extracting text from image...'**
  String get extractingText;

  /// No description provided for @extractedResults.
  ///
  /// In en, this message translates to:
  /// **'Extracted Results'**
  String get extractedResults;

  /// No description provided for @noLabResultsDetected.
  ///
  /// In en, this message translates to:
  /// **'No lab results detected. You can add them manually.'**
  String get noLabResultsDetected;

  /// No description provided for @viewRawText.
  ///
  /// In en, this message translates to:
  /// **'View Raw Text'**
  String get viewRawText;

  /// No description provided for @noTextExtracted.
  ///
  /// In en, this message translates to:
  /// **'No text extracted'**
  String get noTextExtracted;

  /// No description provided for @saveResults.
  ///
  /// In en, this message translates to:
  /// **'Save Results'**
  String get saveResults;

  /// No description provided for @cameraPermissionDenied.
  ///
  /// In en, this message translates to:
  /// **'Camera permission denied'**
  String get cameraPermissionDenied;

  /// No description provided for @photosPermissionDenied.
  ///
  /// In en, this message translates to:
  /// **'Photos permission denied'**
  String get photosPermissionDenied;

  /// No description provided for @failedToPickImage.
  ///
  /// In en, this message translates to:
  /// **'Failed to pick image: {error}'**
  String failedToPickImage(String error);

  /// No description provided for @failedToPickPdf.
  ///
  /// In en, this message translates to:
  /// **'Failed to pick PDF: {error}'**
  String failedToPickPdf(String error);

  /// No description provided for @takePhoto.
  ///
  /// In en, this message translates to:
  /// **'Take Photo'**
  String get takePhoto;

  /// No description provided for @takePhotoDesc.
  ///
  /// In en, this message translates to:
  /// **'Use camera to capture lab result'**
  String get takePhotoDesc;

  /// No description provided for @chooseFromGallery.
  ///
  /// In en, this message translates to:
  /// **'Choose from Gallery'**
  String get chooseFromGallery;

  /// No description provided for @chooseFromGalleryDesc.
  ///
  /// In en, this message translates to:
  /// **'Select existing photo'**
  String get chooseFromGalleryDesc;

  /// No description provided for @uploadPdf.
  ///
  /// In en, this message translates to:
  /// **'Upload PDF'**
  String get uploadPdf;

  /// No description provided for @uploadPdfDesc.
  ///
  /// In en, this message translates to:
  /// **'Select PDF lab report'**
  String get uploadPdfDesc;

  /// No description provided for @manualEntryTitle.
  ///
  /// In en, this message translates to:
  /// **'Manual Entry'**
  String get manualEntryTitle;

  /// No description provided for @manualEntryDesc.
  ///
  /// In en, this message translates to:
  /// **'Enter results manually'**
  String get manualEntryDesc;

  /// No description provided for @viewAllMeasurements.
  ///
  /// In en, this message translates to:
  /// **'View All Measurements'**
  String get viewAllMeasurements;

  /// No description provided for @minutesAgo.
  ///
  /// In en, this message translates to:
  /// **'{minutes} min ago'**
  String minutesAgo(int minutes);

  /// No description provided for @pleaseEnterAppointmentName.
  ///
  /// In en, this message translates to:
  /// **'Please enter an appointment name'**
  String get pleaseEnterAppointmentName;

  /// No description provided for @pleaseSelectDate.
  ///
  /// In en, this message translates to:
  /// **'Please select a date'**
  String get pleaseSelectDate;

  /// No description provided for @pleaseSelectTime.
  ///
  /// In en, this message translates to:
  /// **'Please select a time'**
  String get pleaseSelectTime;

  /// No description provided for @pleaseEnterMedicationName.
  ///
  /// In en, this message translates to:
  /// **'Please enter a medication name'**
  String get pleaseEnterMedicationName;

  /// No description provided for @pleaseSelectForm.
  ///
  /// In en, this message translates to:
  /// **'Please select a form'**
  String get pleaseSelectForm;

  /// No description provided for @pleaseSelectStartDate.
  ///
  /// In en, this message translates to:
  /// **'Please select a starting date'**
  String get pleaseSelectStartDate;

  /// No description provided for @notAuthenticated.
  ///
  /// In en, this message translates to:
  /// **'Not authenticated'**
  String get notAuthenticated;

  /// No description provided for @stillHaveQuestions.
  ///
  /// In en, this message translates to:
  /// **'Still have questions?'**
  String get stillHaveQuestions;

  /// No description provided for @contactSupport.
  ///
  /// In en, this message translates to:
  /// **'Contact Support'**
  String get contactSupport;

  /// No description provided for @faqQ1.
  ///
  /// In en, this message translates to:
  /// **'How do I set appointment reminders?'**
  String get faqQ1;

  /// No description provided for @faqA1.
  ///
  /// In en, this message translates to:
  /// **'You can set appointment reminders by navigating to the \"Appointments\" section, selecting your scheduled visit, and tapping the \"Set Reminder\" option. You will be able to choose a time interval (e.g., 1 day or 1 hour before).'**
  String get faqA1;

  /// No description provided for @faqQ2.
  ///
  /// In en, this message translates to:
  /// **'Is my health data secure?'**
  String get faqQ2;

  /// No description provided for @faqA2.
  ///
  /// In en, this message translates to:
  /// **'Yes. We use industry-leading encryption and follow HIPAA/GDPR compliance guidelines to ensure your personal health information remains private and secure. Data is stored anonymously on secure servers.'**
  String get faqA2;

  /// No description provided for @faqQ3.
  ///
  /// In en, this message translates to:
  /// **'How do I change my due date?'**
  String get faqQ3;

  /// No description provided for @faqA3.
  ///
  /// In en, this message translates to:
  /// **'If you are tracking a pregnancy, you can change your estimated due date (EDD) in the \"Profile\" or \"Tracking\" settings. Tap on the current due date field to manually enter a new date based on your latest ultrasound or doctor\'s recommendation.'**
  String get faqA3;

  /// No description provided for @faqQ4.
  ///
  /// In en, this message translates to:
  /// **'Can I export my health records?'**
  String get faqQ4;

  /// No description provided for @faqA4.
  ///
  /// In en, this message translates to:
  /// **'Yes! Go to Settings > Data & Privacy > Download My Data to export all your information in a readable format.'**
  String get faqA4;

  /// No description provided for @faqQ5.
  ///
  /// In en, this message translates to:
  /// **'How do I contact support?'**
  String get faqQ5;

  /// No description provided for @faqA5.
  ///
  /// In en, this message translates to:
  /// **'You can contact support via the \"Contact Support\" button at the bottom of this screen, or you can email us directly at support@appname.com. We typically respond within 24 hours.'**
  String get faqA5;

  /// No description provided for @faqQ6.
  ///
  /// In en, this message translates to:
  /// **'What languages are supported?'**
  String get faqQ6;

  /// No description provided for @faqA6.
  ///
  /// In en, this message translates to:
  /// **'Currently, the app supports English, French, and Arabic. You can change your preferred language in the \"App Settings\" menu.'**
  String get faqA6;

  /// No description provided for @aboutDescription.
  ///
  /// In en, this message translates to:
  /// **'Your trusted companion through pregnancy and motherhood. Track your journey, get personalized insights, and connect with a supportive community.'**
  String get aboutDescription;

  /// No description provided for @activeUsers.
  ///
  /// In en, this message translates to:
  /// **'Active Users'**
  String get activeUsers;

  /// No description provided for @appRating.
  ///
  /// In en, this message translates to:
  /// **'App Rating'**
  String get appRating;

  /// No description provided for @versionInfo.
  ///
  /// In en, this message translates to:
  /// **'Version Info'**
  String get versionInfo;

  /// No description provided for @madeWithLove.
  ///
  /// In en, this message translates to:
  /// **'Made with Love'**
  String get madeWithLove;

  /// No description provided for @madeWithLoveSub.
  ///
  /// In en, this message translates to:
  /// **'For moms everywhere'**
  String get madeWithLoveSub;

  /// No description provided for @copyrightNotice.
  ///
  /// In en, this message translates to:
  /// **'© 2025 MomCare. All rights reserved.'**
  String get copyrightNotice;

  /// No description provided for @privacyMatters.
  ///
  /// In en, this message translates to:
  /// **'Your Privacy Matters'**
  String get privacyMatters;

  /// No description provided for @privacyMattersDesc.
  ///
  /// In en, this message translates to:
  /// **'We are committed to protecting your personal information and ensuring transparency about how we use your data.'**
  String get privacyMattersDesc;

  /// No description provided for @privacyLastUpdated.
  ///
  /// In en, this message translates to:
  /// **'Last Updated: December 4, 2025'**
  String get privacyLastUpdated;

  /// No description provided for @dataCollection.
  ///
  /// In en, this message translates to:
  /// **'Data Collection'**
  String get dataCollection;

  /// No description provided for @dataCollectionContent.
  ///
  /// In en, this message translates to:
  /// **'We collect only essential information needed to provide you with the best health tracking experience. This includes your profile information, health metrics, and app usage data.'**
  String get dataCollectionContent;

  /// No description provided for @dataSecurity.
  ///
  /// In en, this message translates to:
  /// **'Data Security'**
  String get dataSecurity;

  /// No description provided for @dataSecurityContent.
  ///
  /// In en, this message translates to:
  /// **'Your data is encrypted using industry-standard protocols. We employ multiple layers of security to protect your personal health information from unauthorized access.'**
  String get dataSecurityContent;

  /// No description provided for @dataUsage.
  ///
  /// In en, this message translates to:
  /// **'Data Usage'**
  String get dataUsage;

  /// No description provided for @dataUsageContent.
  ///
  /// In en, this message translates to:
  /// **'We use your data to personalize your app experience, provide relevant health insights, and improve. We do not sell personal data to third parties.'**
  String get dataUsageContent;

  /// No description provided for @yourRights.
  ///
  /// In en, this message translates to:
  /// **'Your Rights'**
  String get yourRights;

  /// No description provided for @yourRightsContent.
  ///
  /// In en, this message translates to:
  /// **'You have the right to access, or update, or request deletion of your data. You can manage privacy settings within the app or contact support.'**
  String get yourRightsContent;

  /// No description provided for @fillAllFields.
  ///
  /// In en, this message translates to:
  /// **'Please fill all fields'**
  String get fillAllFields;

  /// No description provided for @welcomeBack.
  ///
  /// In en, this message translates to:
  /// **'Welcome Back'**
  String get welcomeBack;

  /// No description provided for @loginToContinue.
  ///
  /// In en, this message translates to:
  /// **'Login to continue your journey'**
  String get loginToContinue;

  /// No description provided for @fillRequiredFields.
  ///
  /// In en, this message translates to:
  /// **'Please fill required fields'**
  String get fillRequiredFields;

  /// No description provided for @mustAgreeTerms.
  ///
  /// In en, this message translates to:
  /// **'You must agree to the Terms and Privacy Policy'**
  String get mustAgreeTerms;

  /// No description provided for @startJourneyToday.
  ///
  /// In en, this message translates to:
  /// **'Start your journey with us today'**
  String get startJourneyToday;

  /// No description provided for @mustBe8Chars.
  ///
  /// In en, this message translates to:
  /// **'Must be at least 8 characters'**
  String get mustBe8Chars;

  /// No description provided for @iAgreeTo.
  ///
  /// In en, this message translates to:
  /// **'I agree to the '**
  String get iAgreeTo;

  /// No description provided for @termsConditions.
  ///
  /// In en, this message translates to:
  /// **'Terms & Conditions'**
  String get termsConditions;

  /// No description provided for @alreadyHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account? '**
  String get alreadyHaveAccount;

  /// No description provided for @signIn.
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get signIn;

  /// No description provided for @tellUsAboutYou.
  ///
  /// In en, this message translates to:
  /// **'Tell us about you'**
  String get tellUsAboutYou;

  /// No description provided for @helpPersonalize.
  ///
  /// In en, this message translates to:
  /// **'Help us personalize your experience'**
  String get helpPersonalize;

  /// No description provided for @howFarAlong.
  ///
  /// In en, this message translates to:
  /// **'How Far Along?'**
  String get howFarAlong;

  /// No description provided for @couldNotSavePregnancy.
  ///
  /// In en, this message translates to:
  /// **'Could not save pregnancy: {error}'**
  String couldNotSavePregnancy(String error);

  /// No description provided for @wellCalculateDueDate.
  ///
  /// In en, this message translates to:
  /// **'We\'ll calculate your due date'**
  String get wellCalculateDueDate;

  /// No description provided for @completeSetup.
  ///
  /// In en, this message translates to:
  /// **'Complete Setup'**
  String get completeSetup;

  /// No description provided for @canUpdateAnytime.
  ///
  /// In en, this message translates to:
  /// **'You can update this information anytime'**
  String get canUpdateAnytime;

  /// No description provided for @byWeeks.
  ///
  /// In en, this message translates to:
  /// **'By Weeks'**
  String get byWeeks;

  /// No description provided for @byDate.
  ///
  /// In en, this message translates to:
  /// **'By Date'**
  String get byDate;

  /// No description provided for @youAre.
  ///
  /// In en, this message translates to:
  /// **'You are'**
  String get youAre;

  /// No description provided for @selectWeeks.
  ///
  /// In en, this message translates to:
  /// **'Select Weeks'**
  String get selectWeeks;

  /// No description provided for @weekShort.
  ///
  /// In en, this message translates to:
  /// **'Week {n}'**
  String weekShort(int n);

  /// No description provided for @pickFirstDayLastPeriod.
  ///
  /// In en, this message translates to:
  /// **'Pick the first day of your last period'**
  String get pickFirstDayLastPeriod;

  /// No description provided for @additionalDays.
  ///
  /// In en, this message translates to:
  /// **'Additional Days'**
  String get additionalDays;

  /// No description provided for @tellAboutBaby.
  ///
  /// In en, this message translates to:
  /// **'Tell Us About Your Baby'**
  String get tellAboutBaby;

  /// No description provided for @tellAboutBabyMultiline.
  ///
  /// In en, this message translates to:
  /// **'Tell Us About\nYour Baby'**
  String get tellAboutBabyMultiline;

  /// No description provided for @pleasePickBirthDate.
  ///
  /// In en, this message translates to:
  /// **'Please pick your baby\'s birth date'**
  String get pleasePickBirthDate;

  /// No description provided for @couldNotSaveBaby.
  ///
  /// In en, this message translates to:
  /// **'Could not save baby: {error}'**
  String couldNotSaveBaby(String error);

  /// No description provided for @helpPersonalizedCare.
  ///
  /// In en, this message translates to:
  /// **'Help us provide personalized care'**
  String get helpPersonalizedCare;

  /// No description provided for @babysName.
  ///
  /// In en, this message translates to:
  /// **'Baby\'s Name'**
  String get babysName;

  /// No description provided for @babysGender.
  ///
  /// In en, this message translates to:
  /// **'Baby\'s Gender'**
  String get babysGender;

  /// No description provided for @girlLabel.
  ///
  /// In en, this message translates to:
  /// **'Girl'**
  String get girlLabel;

  /// No description provided for @boyLabel.
  ///
  /// In en, this message translates to:
  /// **'Boy'**
  String get boyLabel;

  /// No description provided for @babysBirthDate.
  ///
  /// In en, this message translates to:
  /// **'Baby\'s Birth Date'**
  String get babysBirthDate;

  /// No description provided for @pickADate.
  ///
  /// In en, this message translates to:
  /// **'Pick a date'**
  String get pickADate;

  /// No description provided for @continueToDashboard.
  ///
  /// In en, this message translates to:
  /// **'Continue to Dashboard'**
  String get continueToDashboard;

  /// No description provided for @infoKeptPrivate.
  ///
  /// In en, this message translates to:
  /// **'All information is kept private and secure'**
  String get infoKeptPrivate;

  /// No description provided for @whatBestDescribes.
  ///
  /// In en, this message translates to:
  /// **'What best describes you'**
  String get whatBestDescribes;

  /// No description provided for @imPregnant.
  ///
  /// In en, this message translates to:
  /// **'I\'m Pregnant'**
  String get imPregnant;

  /// No description provided for @pregnantOptionDesc.
  ///
  /// In en, this message translates to:
  /// **'Track your pregnancy journey, get weekly insights, and prepare for your baby'**
  String get pregnantOptionDesc;

  /// No description provided for @iHaveBaby.
  ///
  /// In en, this message translates to:
  /// **'I have a baby'**
  String get iHaveBaby;

  /// No description provided for @babyOptionDesc.
  ///
  /// In en, this message translates to:
  /// **'Postpartum care, baby development tracking, and parenting support'**
  String get babyOptionDesc;

  /// No description provided for @canChangeAnytime.
  ///
  /// In en, this message translates to:
  /// **'Don\'t worry, you can change this anytime in settings'**
  String get canChangeAnytime;

  /// No description provided for @obTrack.
  ///
  /// In en, this message translates to:
  /// **'Track'**
  String get obTrack;

  /// No description provided for @obYourJourney.
  ///
  /// In en, this message translates to:
  /// **'Your Journey'**
  String get obYourJourney;

  /// No description provided for @obDesc1.
  ///
  /// In en, this message translates to:
  /// **'Monitor your pregnancy week by week with personalized tips and insights'**
  String get obDesc1;

  /// No description provided for @obBabyGrowth.
  ///
  /// In en, this message translates to:
  /// **'Baby Growth'**
  String get obBabyGrowth;

  /// No description provided for @obMonitor.
  ///
  /// In en, this message translates to:
  /// **'Monitor'**
  String get obMonitor;

  /// No description provided for @obDesc2.
  ///
  /// In en, this message translates to:
  /// **'Follow your baby\'s growth and milestones month by month'**
  String get obDesc2;

  /// No description provided for @obNeverMiss.
  ///
  /// In en, this message translates to:
  /// **'Never Miss a'**
  String get obNeverMiss;

  /// No description provided for @obMoment.
  ///
  /// In en, this message translates to:
  /// **'Moment'**
  String get obMoment;

  /// No description provided for @obDesc3.
  ///
  /// In en, this message translates to:
  /// **'Set reminders for appointments, vaccines, and important checkups'**
  String get obDesc3;

  /// No description provided for @obMomBaby.
  ///
  /// In en, this message translates to:
  /// **'Mom & Baby'**
  String get obMomBaby;

  /// No description provided for @obMarketplace.
  ///
  /// In en, this message translates to:
  /// **'Marketplace'**
  String get obMarketplace;

  /// No description provided for @obDesc4.
  ///
  /// In en, this message translates to:
  /// **'Shop curated products for you and your baby'**
  String get obDesc4;

  /// No description provided for @getStarted.
  ///
  /// In en, this message translates to:
  /// **'Get Started'**
  String get getStarted;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @everythingYouNeed.
  ///
  /// In en, this message translates to:
  /// **'Everything you need for pregnancy, baby care, and beyond — all in one place'**
  String get everythingYouNeed;

  /// No description provided for @trackYourPregnancy.
  ///
  /// In en, this message translates to:
  /// **'Track Your Pregnancy'**
  String get trackYourPregnancy;

  /// No description provided for @weekByWeekInsights.
  ///
  /// In en, this message translates to:
  /// **'Week-by-week insights'**
  String get weekByWeekInsights;

  /// No description provided for @healthAppointments.
  ///
  /// In en, this message translates to:
  /// **'Health & Appointments'**
  String get healthAppointments;

  /// No description provided for @neverMissCheckup.
  ///
  /// In en, this message translates to:
  /// **'Never miss a checkup'**
  String get neverMissCheckup;

  /// No description provided for @communitySupport.
  ///
  /// In en, this message translates to:
  /// **'Community Support'**
  String get communitySupport;

  /// No description provided for @connectWithOthers.
  ///
  /// In en, this message translates to:
  /// **'Connect with others'**
  String get connectWithOthers;

  /// No description provided for @takesLessMinute.
  ///
  /// In en, this message translates to:
  /// **'Takes less than a minute'**
  String get takesLessMinute;

  /// No description provided for @yourJourneyOurSupport.
  ///
  /// In en, this message translates to:
  /// **'Your Journey,\nOur Support'**
  String get yourJourneyOurSupport;

  /// No description provided for @letsGetStarted.
  ///
  /// In en, this message translates to:
  /// **'Let\'s Get Started'**
  String get letsGetStarted;

  /// No description provided for @appTagline.
  ///
  /// In en, this message translates to:
  /// **'Your Journey, Our Care'**
  String get appTagline;

  /// No description provided for @loadingExperience.
  ///
  /// In en, this message translates to:
  /// **'Loading your experience...'**
  String get loadingExperience;

  /// No description provided for @weeksUnit.
  ///
  /// In en, this message translates to:
  /// **'weeks'**
  String get weeksUnit;

  /// No description provided for @navHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get navHome;

  /// No description provided for @navTrack.
  ///
  /// In en, this message translates to:
  /// **'Track'**
  String get navTrack;

  /// No description provided for @navHealth.
  ///
  /// In en, this message translates to:
  /// **'Health'**
  String get navHealth;

  /// No description provided for @navPlan.
  ///
  /// In en, this message translates to:
  /// **'Plan'**
  String get navPlan;

  /// No description provided for @navMarket.
  ///
  /// In en, this message translates to:
  /// **'Market'**
  String get navMarket;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en', 'fr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
    case 'fr':
      return AppLocalizationsFr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
