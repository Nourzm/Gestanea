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

  /// No description provided for @findTheBestDoctor.
  ///
  /// In en, this message translates to:
  /// **'find the best doctor'**
  String get findTheBestDoctor;

  /// No description provided for @upComing.
  ///
  /// In en, this message translates to:
  /// **'Up coming'**
  String get upComing;

  /// No description provided for @seeAll.
  ///
  /// In en, this message translates to:
  /// **'see all'**
  String get seeAll;

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

  /// No description provided for @at.
  ///
  /// In en, this message translates to:
  /// **'at'**
  String get at;

  /// No description provided for @overdue.
  ///
  /// In en, this message translates to:
  /// **'Overdue'**
  String get overdue;

  /// No description provided for @in_.
  ///
  /// In en, this message translates to:
  /// **'In'**
  String get in_;

  /// No description provided for @minutes.
  ///
  /// In en, this message translates to:
  /// **'minutes'**
  String get minutes;

  /// No description provided for @hours.
  ///
  /// In en, this message translates to:
  /// **'hours'**
  String get hours;

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

  /// No description provided for @getInTouch.
  ///
  /// In en, this message translates to:
  /// **'Get in Touch'**
  String get getInTouch;

  /// No description provided for @contactFormDescription.
  ///
  /// In en, this message translates to:
  /// **'Have a question or feedback? We\'d love to hear from you. Fill out the form below and we\'ll get back to you within 24 hours.'**
  String get contactFormDescription;

  /// No description provided for @supportEmail.
  ///
  /// In en, this message translates to:
  /// **'support@momcare.com'**
  String get supportEmail;

  /// No description provided for @supportPhone.
  ///
  /// In en, this message translates to:
  /// **'+1 (800) 123-4567'**
  String get supportPhone;

  /// No description provided for @supportHours.
  ///
  /// In en, this message translates to:
  /// **'Mon-Fri, 9AM-6PM EST'**
  String get supportHours;

  /// No description provided for @yourNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Your Name'**
  String get yourNameLabel;

  /// No description provided for @enterYourName.
  ///
  /// In en, this message translates to:
  /// **'Enter your name'**
  String get enterYourName;

  /// No description provided for @emailAddressLabel.
  ///
  /// In en, this message translates to:
  /// **'Email Address'**
  String get emailAddressLabel;

  /// No description provided for @emailPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'your.email@example.com'**
  String get emailPlaceholder;

  /// No description provided for @subjectLabel.
  ///
  /// In en, this message translates to:
  /// **'Subject'**
  String get subjectLabel;

  /// No description provided for @whatIsThisAbout.
  ///
  /// In en, this message translates to:
  /// **'What is this about?'**
  String get whatIsThisAbout;

  /// No description provided for @messageLabel.
  ///
  /// In en, this message translates to:
  /// **'Message'**
  String get messageLabel;

  /// No description provided for @tellUsHowWeCanHelp.
  ///
  /// In en, this message translates to:
  /// **'Tell us how we can help...'**
  String get tellUsHowWeCanHelp;

  /// No description provided for @sendMessage.
  ///
  /// In en, this message translates to:
  /// **'Send Message'**
  String get sendMessage;

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'Gestanéa'**
  String get appName;

  /// No description provided for @appVersion.
  ///
  /// In en, this message translates to:
  /// **'Version 2.1.0'**
  String get appVersion;

  /// No description provided for @appDescription.
  ///
  /// In en, this message translates to:
  /// **'Your trusted companion through pregnancy and motherhood. Track your journey, get personalized insights, and connect with a supportive community.'**
  String get appDescription;

  /// No description provided for @activeUsersCount.
  ///
  /// In en, this message translates to:
  /// **'100K+'**
  String get activeUsersCount;

  /// No description provided for @activeUsers.
  ///
  /// In en, this message translates to:
  /// **'Active Users'**
  String get activeUsers;

  /// No description provided for @appRatingValue.
  ///
  /// In en, this message translates to:
  /// **'4.8★'**
  String get appRatingValue;

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

  /// No description provided for @versionBuild.
  ///
  /// In en, this message translates to:
  /// **'Build 2.1.0 (245)'**
  String get versionBuild;

  /// No description provided for @madeWithLove.
  ///
  /// In en, this message translates to:
  /// **'Made with Love'**
  String get madeWithLove;

  /// No description provided for @forMomsEverywhere.
  ///
  /// In en, this message translates to:
  /// **'For moms everywhere'**
  String get forMomsEverywhere;

  /// No description provided for @copyrightText.
  ///
  /// In en, this message translates to:
  /// **'© 2025 Gestanéa. All rights reserved.'**
  String get copyrightText;

  /// No description provided for @faqIntroText.
  ///
  /// In en, this message translates to:
  /// **'Choose your preferred language'**
  String get faqIntroText;

  /// No description provided for @faqQuestion1.
  ///
  /// In en, this message translates to:
  /// **'How do I set appointment reminders?'**
  String get faqQuestion1;

  /// No description provided for @faqAnswer1.
  ///
  /// In en, this message translates to:
  /// **'You can set appointment reminders by navigating to the \"Appointments\" section, selecting your scheduled visit, and tapping the \"Set Reminder\" option. You will be able to choose a time interval (e.g., 1 day or 1 hour before).'**
  String get faqAnswer1;

  /// No description provided for @faqQuestion2.
  ///
  /// In en, this message translates to:
  /// **'Is my health data secure?'**
  String get faqQuestion2;

  /// No description provided for @faqAnswer2.
  ///
  /// In en, this message translates to:
  /// **'Yes. We use industry-leading encryption and follow HIPAA/GDPR compliance guidelines to ensure your personal health information remains private and secure. Data is stored anonymously on secure servers.'**
  String get faqAnswer2;

  /// No description provided for @faqQuestion3.
  ///
  /// In en, this message translates to:
  /// **'How do I change my due date?'**
  String get faqQuestion3;

  /// No description provided for @faqAnswer3.
  ///
  /// In en, this message translates to:
  /// **'If you are tracking a pregnancy, you can change your estimated due date (EDD) in the \"Profile\" or \"Tracking\" settings. Tap on the current due date field to manually enter a new date based on your latest ultrasound or doctor\'s recommendation.'**
  String get faqAnswer3;

  /// No description provided for @faqQuestion4.
  ///
  /// In en, this message translates to:
  /// **'Can I export my health records?'**
  String get faqQuestion4;

  /// No description provided for @faqAnswer4.
  ///
  /// In en, this message translates to:
  /// **'Yes! Go to Settings > Data & Privacy > Download My Data to export all your information in a readable format.'**
  String get faqAnswer4;

  /// No description provided for @faqQuestion5.
  ///
  /// In en, this message translates to:
  /// **'How do I contact support?'**
  String get faqQuestion5;

  /// No description provided for @faqAnswer5.
  ///
  /// In en, this message translates to:
  /// **'You can contact support via the \"Contact Support\" button at the bottom of this screen, or you can email us directly at support@appname.com. We typically respond within 24 hours.'**
  String get faqAnswer5;

  /// No description provided for @faqQuestion6.
  ///
  /// In en, this message translates to:
  /// **'What languages are supported?'**
  String get faqQuestion6;

  /// No description provided for @faqAnswer6.
  ///
  /// In en, this message translates to:
  /// **'Currently, the app supports English, Spanish, French, and German. You can change your preferred language in the \"App Settings\" menu.'**
  String get faqAnswer6;

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

  /// No description provided for @faq.
  ///
  /// In en, this message translates to:
  /// **'FAQ'**
  String get faq;

  /// No description provided for @yourPrivacyMatters.
  ///
  /// In en, this message translates to:
  /// **'Your Privacy Matters'**
  String get yourPrivacyMatters;

  /// No description provided for @privacyCommitmentDescription.
  ///
  /// In en, this message translates to:
  /// **'We are committed to protecting your personal information and ensuring transparency about how we use your data.'**
  String get privacyCommitmentDescription;

  /// No description provided for @lastUpdatedPrivacy.
  ///
  /// In en, this message translates to:
  /// **'Last Updated: December 4, 2025'**
  String get lastUpdatedPrivacy;

  /// No description provided for @dataCollection.
  ///
  /// In en, this message translates to:
  /// **'Data Collection'**
  String get dataCollection;

  /// No description provided for @dataCollectionDescription.
  ///
  /// In en, this message translates to:
  /// **'We collect only essential information needed to provide you with the best health tracking experience. This includes your profile information, health metrics, and app usage data.'**
  String get dataCollectionDescription;

  /// No description provided for @dataSecurity.
  ///
  /// In en, this message translates to:
  /// **'Data Security'**
  String get dataSecurity;

  /// No description provided for @dataSecurityDescription.
  ///
  /// In en, this message translates to:
  /// **'Your data is encrypted using industry-standard protocols. We employ multiple layers of security to protect your personal health information from unauthorized access.'**
  String get dataSecurityDescription;

  /// No description provided for @dataUsage.
  ///
  /// In en, this message translates to:
  /// **'Data Usage'**
  String get dataUsage;

  /// No description provided for @dataUsageDescription.
  ///
  /// In en, this message translates to:
  /// **'We use your data to personalize your app experience, provide relevant health insights, and improve. We do not sell personal data to third parties.'**
  String get dataUsageDescription;

  /// No description provided for @yourRights.
  ///
  /// In en, this message translates to:
  /// **'Your Rights'**
  String get yourRights;

  /// No description provided for @yourRightsDescription.
  ///
  /// In en, this message translates to:
  /// **'You have the right to access, or update, or request deletion of your data. You can manage privacy settings within the app or contact support.'**
  String get yourRightsDescription;

  /// No description provided for @weAreHereToHelp.
  ///
  /// In en, this message translates to:
  /// **'We\'re Here to Help'**
  String get weAreHereToHelp;

  /// No description provided for @chooseSupportOptionDescription.
  ///
  /// In en, this message translates to:
  /// **'Choose the support option that works best for you. Our team is available 24/7 to assist you.'**
  String get chooseSupportOptionDescription;

  /// No description provided for @knowledgeBase.
  ///
  /// In en, this message translates to:
  /// **'Knowledge Base'**
  String get knowledgeBase;

  /// No description provided for @browseArticlesAndGuides.
  ///
  /// In en, this message translates to:
  /// **'Browse articles and guides'**
  String get browseArticlesAndGuides;

  /// No description provided for @liveChat.
  ///
  /// In en, this message translates to:
  /// **'Live Chat'**
  String get liveChat;

  /// No description provided for @chatWithSupportTeam.
  ///
  /// In en, this message translates to:
  /// **'Chat with our support team'**
  String get chatWithSupportTeam;

  /// No description provided for @videoTutorials.
  ///
  /// In en, this message translates to:
  /// **'Video Tutorials'**
  String get videoTutorials;

  /// No description provided for @watchStepByStepGuides.
  ///
  /// In en, this message translates to:
  /// **'Watch step-by-step guides'**
  String get watchStepByStepGuides;

  /// No description provided for @emailSupport.
  ///
  /// In en, this message translates to:
  /// **'Email Support'**
  String get emailSupport;

  /// No description provided for @emailSupportAddress.
  ///
  /// In en, this message translates to:
  /// **'support@momcare.com'**
  String get emailSupportAddress;

  /// No description provided for @phoneSupport.
  ///
  /// In en, this message translates to:
  /// **'Phone Support'**
  String get phoneSupport;

  /// No description provided for @phoneSupportNumber.
  ///
  /// In en, this message translates to:
  /// **'1-800-MOM-CARE'**
  String get phoneSupportNumber;

  /// No description provided for @communityForum.
  ///
  /// In en, this message translates to:
  /// **'Community Forum'**
  String get communityForum;

  /// No description provided for @connectWithOtherUsers.
  ///
  /// In en, this message translates to:
  /// **'Connect with other users'**
  String get connectWithOtherUsers;

  /// No description provided for @secureYourAccount.
  ///
  /// In en, this message translates to:
  /// **'Secure Your Account'**
  String get secureYourAccount;

  /// No description provided for @enableSecurityFeaturesDescription.
  ///
  /// In en, this message translates to:
  /// **'Enable additional security features to protect your personal health information'**
  String get enableSecurityFeaturesDescription;

  /// No description provided for @changePassword.
  ///
  /// In en, this message translates to:
  /// **'Change Password'**
  String get changePassword;

  /// No description provided for @lastChangedDaysAgo.
  ///
  /// In en, this message translates to:
  /// **'Last changed 30 days ago'**
  String get lastChangedDaysAgo;

  /// No description provided for @biometricAuthentication.
  ///
  /// In en, this message translates to:
  /// **'Biometric Authentication'**
  String get biometricAuthentication;

  /// No description provided for @useFingerprintOrFaceId.
  ///
  /// In en, this message translates to:
  /// **'Use fingerprint or Face ID to unlock'**
  String get useFingerprintOrFaceId;

  /// No description provided for @twoFactorAuthentication.
  ///
  /// In en, this message translates to:
  /// **'Two-Factor Authentication'**
  String get twoFactorAuthentication;

  /// No description provided for @addExtraLayerSecurity.
  ///
  /// In en, this message translates to:
  /// **'Add an extra layer of security'**
  String get addExtraLayerSecurity;

  /// No description provided for @autoLock.
  ///
  /// In en, this message translates to:
  /// **'Auto-Lock'**
  String get autoLock;

  /// No description provided for @lockAppAfterInactivity.
  ///
  /// In en, this message translates to:
  /// **'Lock app after 5 minutes of inactivity'**
  String get lockAppAfterInactivity;

  /// No description provided for @manageNotificationPreferences.
  ///
  /// In en, this message translates to:
  /// **'Manage your notification preferences'**
  String get manageNotificationPreferences;

  /// No description provided for @pushNotifications.
  ///
  /// In en, this message translates to:
  /// **'Push Notifications'**
  String get pushNotifications;

  /// No description provided for @receiveNotificationsOnDevice.
  ///
  /// In en, this message translates to:
  /// **'Receive notifications on your device'**
  String get receiveNotificationsOnDevice;

  /// No description provided for @emailNotifications.
  ///
  /// In en, this message translates to:
  /// **'Email Notifications'**
  String get emailNotifications;

  /// No description provided for @getUpdatesViaEmail.
  ///
  /// In en, this message translates to:
  /// **'Get updates via email'**
  String get getUpdatesViaEmail;

  /// No description provided for @appointmentReminders.
  ///
  /// In en, this message translates to:
  /// **'Appointment Reminders'**
  String get appointmentReminders;

  /// No description provided for @neverMissAppointment.
  ///
  /// In en, this message translates to:
  /// **'Never miss a doctor\'s appointment'**
  String get neverMissAppointment;

  /// No description provided for @healthTips.
  ///
  /// In en, this message translates to:
  /// **'Health Tips'**
  String get healthTips;

  /// No description provided for @dailyWellnessRecommendations.
  ///
  /// In en, this message translates to:
  /// **'Daily wellness recommendations'**
  String get dailyWellnessRecommendations;

  /// No description provided for @weeklyReports.
  ///
  /// In en, this message translates to:
  /// **'Weekly Reports'**
  String get weeklyReports;

  /// No description provided for @healthProgressSummary.
  ///
  /// In en, this message translates to:
  /// **'Summary of your health progress'**
  String get healthProgressSummary;

  /// No description provided for @vitaminReminders.
  ///
  /// In en, this message translates to:
  /// **'Vitamin Reminders'**
  String get vitaminReminders;

  /// No description provided for @dontForgetSupplements.
  ///
  /// In en, this message translates to:
  /// **'Don\'t forget your supplements'**
  String get dontForgetSupplements;

  /// No description provided for @choosePreferredLanguage.
  ///
  /// In en, this message translates to:
  /// **'Choose your preferred language'**
  String get choosePreferredLanguage;

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
  /// **'Done'**
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

  /// No description provided for @password.
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

  /// No description provided for @signup.
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get signup;

  /// No description provided for @your_name.
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

  /// Back support belt product
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

  /// No description provided for @sendOtp.
  ///
  /// In en, this message translates to:
  /// **'Send Code'**
  String get sendOtp;

  /// No description provided for @verifyOtp.
  ///
  /// In en, this message translates to:
  /// **'Verify Code'**
  String get verifyOtp;

  /// No description provided for @enterOtpCode.
  ///
  /// In en, this message translates to:
  /// **'Enter verification code'**
  String get enterOtpCode;

  /// No description provided for @otpSent.
  ///
  /// In en, this message translates to:
  /// **'Verification code sent to your email'**
  String get otpSent;

  /// No description provided for @otpCodePlaceholder.
  ///
  /// In en, this message translates to:
  /// **'6-digit code'**
  String get otpCodePlaceholder;

  /// No description provided for @resendOtp.
  ///
  /// In en, this message translates to:
  /// **'Resend code'**
  String get resendOtp;

  /// No description provided for @noInternetConnection.
  ///
  /// In en, this message translates to:
  /// **'No internet connection. Please check your network and try again.'**
  String get noInternetConnection;

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
  String hoursAgo(int hours);

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
  String daysAgo(int days);

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
  /// **'Are you sure you want to call 911?'**
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
  /// **'Call 911 or your healthcare provider'**
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

  /// No description provided for @hello.
  ///
  /// In en, this message translates to:
  /// **'Hello'**
  String get hello;

  /// No description provided for @done.
  ///
  /// In en, this message translates to:
  /// **'DONE'**
  String get done;

  /// No description provided for @daysToGo.
  ///
  /// In en, this message translates to:
  /// **'DAYS TO GO'**
  String get daysToGo;

  /// No description provided for @weekLabel.
  ///
  /// In en, this message translates to:
  /// **'WEEK'**
  String get weekLabel;

  /// No description provided for @day.
  ///
  /// In en, this message translates to:
  /// **'day'**
  String get day;

  /// No description provided for @days.
  ///
  /// In en, this message translates to:
  /// **'days'**
  String get days;

  /// No description provided for @more.
  ///
  /// In en, this message translates to:
  /// **'More'**
  String get more;

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

  /// No description provided for @ourDoctors.
  ///
  /// In en, this message translates to:
  /// **'Our Doctors'**
  String get ourDoctors;

  /// No description provided for @findTheBestDoctor.
  ///
  /// In en, this message translates to:
  /// **'find the best doctor'**
  String get findTheBestDoctor;

  /// No description provided for @upComing.
  ///
  /// In en, this message translates to:
  /// **'Up coming'**
  String get upComing;

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

  /// No description provided for @todayAt.
  ///
  /// In en, this message translates to:
  /// **'Today at {time}'**
  String todayAt(String time);

  /// No description provided for @tomorrowAt.
  ///
  /// In en, this message translates to:
  /// **'Tomorrow at {time}'**
  String tomorrowAt(String time);

  /// No description provided for @at.
  ///
  /// In en, this message translates to:
  /// **'at'**
  String get at;

  /// No description provided for @myMoods.
  ///
  /// In en, this message translates to:
  /// **'My Moods'**
  String get myMoods;

  /// No description provided for @noMoodsLoggedYet.
  ///
  /// In en, this message translates to:
  /// **'No moods logged yet!'**
  String get noMoodsLoggedYet;

  /// No description provided for @tapLogMoodToStart.
  ///
  /// In en, this message translates to:
  /// **'Tap \"Log Mood\" to start.'**
  String get tapLogMoodToStart;

  /// No description provided for @noData.
  ///
  /// In en, this message translates to:
  /// **'No data'**
  String get noData;

  /// No description provided for @pleaseLogInToSaveMood.
  ///
  /// In en, this message translates to:
  /// **'Please log in to save mood'**
  String get pleaseLogInToSaveMood;

  /// No description provided for @mySymptoms.
  ///
  /// In en, this message translates to:
  /// **'My Symptoms'**
  String get mySymptoms;

  /// No description provided for @tapLogNewSymptomToStart.
  ///
  /// In en, this message translates to:
  /// **'Tap \"Log New Symptom\" to start.'**
  String get tapLogNewSymptomToStart;

  /// No description provided for @myMeasurements.
  ///
  /// In en, this message translates to:
  /// **'My Measurements'**
  String get myMeasurements;

  /// No description provided for @tapAddMeasurementToStart.
  ///
  /// In en, this message translates to:
  /// **'Tap \"Add Measurement\" to start.'**
  String get tapAddMeasurementToStart;

  /// No description provided for @myLabResults.
  ///
  /// In en, this message translates to:
  /// **'My Lab Results'**
  String get myLabResults;

  /// No description provided for @uploadFirstLabResult.
  ///
  /// In en, this message translates to:
  /// **'Upload your first lab result to get started.'**
  String get uploadFirstLabResult;

  /// No description provided for @labPapersGallery.
  ///
  /// In en, this message translates to:
  /// **'Lab Papers Gallery'**
  String get labPapersGallery;

  /// No description provided for @uploadLabReportsToSee.
  ///
  /// In en, this message translates to:
  /// **'Upload lab reports to see them here'**
  String get uploadLabReportsToSee;

  /// No description provided for @exportingLabPapers.
  ///
  /// In en, this message translates to:
  /// **'Exporting lab papers...'**
  String get exportingLabPapers;

  /// No description provided for @healthRiskAssessment.
  ///
  /// In en, this message translates to:
  /// **'Health Risk Assessment'**
  String get healthRiskAssessment;

  /// No description provided for @analyzingYourHealthData.
  ///
  /// In en, this message translates to:
  /// **'Analyzing your health data...'**
  String get analyzingYourHealthData;

  /// No description provided for @unableToAssessRisk.
  ///
  /// In en, this message translates to:
  /// **'Unable to assess risk'**
  String get unableToAssessRisk;

  /// No description provided for @noAssessmentAvailable.
  ///
  /// In en, this message translates to:
  /// **'No assessment available'**
  String get noAssessmentAvailable;

  /// No description provided for @viewAllMeasurements.
  ///
  /// In en, this message translates to:
  /// **'View All Measurements'**
  String get viewAllMeasurements;

  /// No description provided for @viewAllMoods.
  ///
  /// In en, this message translates to:
  /// **'View All Moods'**
  String get viewAllMoods;

  /// No description provided for @viewAllLabPapers.
  ///
  /// In en, this message translates to:
  /// **'View All Lab Papers'**
  String get viewAllLabPapers;

  /// No description provided for @noWeightDataAvailable.
  ///
  /// In en, this message translates to:
  /// **'No weight data available'**
  String get noWeightDataAvailable;

  /// No description provided for @monitor.
  ///
  /// In en, this message translates to:
  /// **'Monitor'**
  String get monitor;

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

  /// No description provided for @failedToPickPDF.
  ///
  /// In en, this message translates to:
  /// **'Failed to pick PDF: {error}'**
  String failedToPickPDF(String error);

  /// No description provided for @reviewEditLabResults.
  ///
  /// In en, this message translates to:
  /// **'Review & Edit Lab Results'**
  String get reviewEditLabResults;

  /// No description provided for @imageNotAvailable.
  ///
  /// In en, this message translates to:
  /// **'Image not available'**
  String get imageNotAvailable;

  /// No description provided for @addTest.
  ///
  /// In en, this message translates to:
  /// **'Add Test'**
  String get addTest;

  /// No description provided for @saveResults.
  ///
  /// In en, this message translates to:
  /// **'Save {count} Result(s)'**
  String saveResults(int count);

  /// No description provided for @labResultsSavedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Lab results saved successfully!'**
  String get labResultsSavedSuccessfully;

  /// No description provided for @failedToSaveResults.
  ///
  /// In en, this message translates to:
  /// **'Failed to save results: {error}'**
  String failedToSaveResults(String error);

  /// No description provided for @noResultsToSave.
  ///
  /// In en, this message translates to:
  /// **'No results to save'**
  String get noResultsToSave;

  /// No description provided for @pdfLabReport.
  ///
  /// In en, this message translates to:
  /// **'PDF Lab Report'**
  String get pdfLabReport;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @applyFilters.
  ///
  /// In en, this message translates to:
  /// **'Save PDF Reference'**
  String get savePDFReference;

  /// No description provided for @enterDataManually.
  ///
  /// In en, this message translates to:
  /// **'Enter Data Manually'**
  String get enterDataManually;

  /// No description provided for @pdfSavedAndUploaded.
  ///
  /// In en, this message translates to:
  /// **'PDF saved and uploaded!'**
  String get pdfSavedAndUploaded;

  /// No description provided for @failedToSavePDF.
  ///
  /// In en, this message translates to:
  /// **'Failed to save PDF: {error}'**
  String failedToSavePDF(String error);

  /// No description provided for @extractLabResults.
  ///
  /// In en, this message translates to:
  /// **'Extract Lab Results'**
  String get extractLabResults;

  /// No description provided for @extractingTextFromImage.
  ///
  /// In en, this message translates to:
  /// **'Extracting text from image...'**
  String get extractingTextFromImage;

  /// No description provided for @viewRawText.
  ///
  /// In en, this message translates to:
  /// **'View Raw Text'**
  String get viewRawText;

  /// No description provided for @noDataExtracted.
  ///
  /// In en, this message translates to:
  /// **'No Data Extracted'**
  String get noDataExtracted;

  /// No description provided for @saveImageOnly.
  ///
  /// In en, this message translates to:
  /// **'Save Image Only'**
  String get saveImageOnly;

  /// No description provided for @imageSaved.
  ///
  /// In en, this message translates to:
  /// **'Image saved!  You can add details later.'**
  String get imageSaved;

  /// No description provided for @enterManually.
  ///
  /// In en, this message translates to:
  /// **'Enter Manually'**
  String get enterManually;

  /// No description provided for @noImageSaved.
  ///
  /// In en, this message translates to:
  /// **'No image saved.  Please try again.'**
  String get noImageSaved;

  /// No description provided for @manualLabEntry.
  ///
  /// In en, this message translates to:
  /// **'Manual Lab Entry'**
  String get manualLabEntry;

  /// No description provided for @labResultAddedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Lab result added successfully!'**
  String get labResultAddedSuccessfully;

  /// No description provided for @exporting.
  ///
  /// In en, this message translates to:
  /// **'Exporting.. .'**
  String get exporting;

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

  /// No description provided for @areYouSureDeleteResult.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete {testName}?'**
  String areYouSureDeleteResult(String testName);

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @exportLabResults.
  ///
  /// In en, this message translates to:
  /// **'Export Lab Results'**
  String get exportLabResults;

  /// No description provided for @exportAllLabResultsAsZIP.
  ///
  /// In en, this message translates to:
  /// **'Call Now'**
  String get callNow;

  /// Pregnancy pillow product
  ///
  /// In en, this message translates to:
  /// **'Pregnancy Pillow'**
  String get pregnancyPillow;

  /// No description provided for @essentialNutrientsMealPlanning.
  ///
  /// In en, this message translates to:
  /// **'Essential nutrients and meal planning for a healthy pregnancy'**
  String get essentialNutrientsMealPlanning;

  /// No description provided for @fiveMinRead.
  ///
  /// In en, this message translates to:
  /// **'5 min read'**
  String get fiveMinRead;
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
