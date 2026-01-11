// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get locationPermissionRequired => 'Location Permission Required';

  @override
  String get locationPermissionMessage =>
      'We need access to your location to show nearby doctors.';

  @override
  String get gettingLocation => 'Getting your location...';

  @override
  String get locationPermissionDenied => 'Location permission denied';

  @override
  String get locationUpdated => 'Location updated';

  @override
  String get retry => 'Retry';

  @override
  String get showingDoctorsNearYou => 'Showing doctors near you';

  @override
  String get selectLocation => 'Select Location';

  @override
  String get searchWilaya => 'Search for a wilaya...';

  @override
  String get security => 'Security';

  @override
  String get i_gave_birth => 'I gave birth';

  @override
  String get no_longer_pregnant => 'No longer pregnant';

  @override
  String get help_support => 'Help & Support';

  @override
  String get contact_us => 'Contact us';

  @override
  String get privacy_policy => 'Privacy policy';

  @override
  String get about_app => 'About App';

  @override
  String get change => 'Change';

  @override
  String get save => 'Save';

  @override
  String get save_changes => 'Save changes';

  @override
  String get logout_confirmation => 'Are you sure you want to log out?';

  @override
  String get cancel => 'Cancel';

  @override
  String get unknown => 'Unknown';

  @override
  String get profile => 'Profile';

  @override
  String get profile_updated => 'Profile updated';

  @override
  String get edit_profile => 'Edit Profile';

  @override
  String get change_profile_photo => 'Change profile photo';

  @override
  String get full_name => 'Full name';

  @override
  String get enable_notifications => 'Enable notifications';

  @override
  String get phone => 'Phone';

  @override
  String get country => 'Country';

  @override
  String get plan => 'Plan';

  @override
  String get sundayShort => 'S';

  @override
  String get mondayShort => 'M';

  @override
  String get tuesdayShort => 'T';

  @override
  String get wednesdayShort => 'W';

  @override
  String get thursdayShort => 'T';

  @override
  String get fridayShort => 'F';

  @override
  String get saturdayShort => 'S';

  @override
  String get todaysMedicine => 'Today\'s Medicine';

  @override
  String get upcomingAppointments => 'Upcoming Appointments';

  @override
  String get scheduled => 'Scheduled';

  @override
  String get addNewMedicine => 'Add New Medicine';

  @override
  String get addNewAppointment => 'Add New Appointment';

  @override
  String get medicine => 'Medicine';

  @override
  String get appointments => 'Appointments';

  @override
  String get appointmentName => 'Appointment Name';

  @override
  String get medicationName => 'Medication Name';

  @override
  String get nextLabel => 'Next';

  @override
  String get doneLabel => 'Done';

  @override
  String get uploadPicture => 'Upload a picture';

  @override
  String get camera => 'Camera';

  @override
  String get gallery => 'Gallery';

  @override
  String get removeImage => 'Remove Image';

  @override
  String get tapToAddPicture => 'Tap to add picture';

  @override
  String get optionalImageNote =>
      'Adding a picture is optional. You can skip this step.';

  @override
  String get selectFormDose => 'Select Form & Dose';

  @override
  String get frequencySchedule => 'Frequency & Schedule';

  @override
  String get frequencyType => 'Frequency Type';

  @override
  String get frequencyValue => 'Frequency Value';

  @override
  String get scheduledTimesLabel => 'Scheduled Times';

  @override
  String get asNeeded => 'As Needed';

  @override
  String get dosage => 'Dosage';

  @override
  String get dosageExample => 'e.g., 5mg or 10ml';

  @override
  String get formPill => 'Pill';

  @override
  String get formInjection => 'Injection';

  @override
  String get formSpray => 'Spray';

  @override
  String get formDrop => 'Drop';

  @override
  String get formSyrup => 'Syrup';

  @override
  String get formOthers => 'Others';

  @override
  String medicinesTaken(int taken, int total) {
    return '$taken of $total taken';
  }

  @override
  String get daily => 'Daily';

  @override
  String get weekly => 'Weekly';

  @override
  String get monthly => 'Monthly';

  @override
  String get timesPerDayExample => 'e.g., 3 (times per day)';

  @override
  String get timesPerWeekExample => 'e.g., 2 (times per week)';

  @override
  String get timesPerMonthExample => 'e.g., 1 (times per month)';

  @override
  String get appointmentDateTime => 'Appointment Date & Time';

  @override
  String get appointmentLocation => 'Appointment location';

  @override
  String get selectDate => 'Select Date';

  @override
  String get selectTime => 'Select time';

  @override
  String get startDate => 'Start Date';

  @override
  String get endDate => 'End Date (Optional)';

  @override
  String get selectStartDate => 'Select Start Date';

  @override
  String get selectEndDate => 'Select End Date';

  @override
  String get addTime => 'Add Time';

  @override
  String get noScheduledTimesAdded => 'No scheduled times added yet';

  @override
  String get today => 'Today';

  @override
  String get tomorrow => 'Tomorrow';

  @override
  String get noAppointmentsFound => 'No appointments found';

  @override
  String get appointment => 'Appointment';

  @override
  String get pleaseAddScheduledTime => 'Please add at least one scheduled time';

  @override
  String reviewsCount(Object count) {
    return '$count reviews';
  }

  @override
  String get qty => 'Qty';

  @override
  String get noMedicines => 'No medicines';

  @override
  String get schedule => 'Schedule';

  @override
  String get availability => 'Availability';

  @override
  String get specialty => 'Specialty';

  @override
  String get bookAppointment => 'Book Appointment';

  @override
  String get price => 'Price';

  @override
  String get quantity => 'Quantity';

  @override
  String get checkout => 'Checkout';

  @override
  String get applyCoupon => 'Apply coupon';

  @override
  String get popular => 'Popular';

  @override
  String get offers => 'Offers';

  @override
  String get newLabel => 'New';

  @override
  String get contact => 'Contact';

  @override
  String get message => 'Message';

  @override
  String get location => 'Location';

  @override
  String get noResults => 'No results';

  @override
  String get search => 'Search';

  @override
  String get sort => 'Sort';

  @override
  String get marketplace => 'Marketplace';

  @override
  String get doctorsFeatureTitle => 'Doctors';

  @override
  String get planFeatureTitle => 'Plan';

  @override
  String get addMedicine => 'Add medicine';

  @override
  String get addAppointment => 'Add appointment';

  @override
  String get error => 'Error';

  @override
  String get success => 'Success';

  @override
  String get confirm => 'Confirm';

  @override
  String get remove => 'Remove';

  @override
  String get apply => 'Apply';

  @override
  String get reviewsLabel => 'Reviews';

  @override
  String get rating => 'Rating';

  @override
  String get recommended => 'Recommended';

  @override
  String get noReviews => 'No reviews';

  @override
  String get delivery => 'Delivery';

  @override
  String get shipping => 'Shipping';

  @override
  String get taxes => 'Taxes';

  @override
  String get sunday => 'Sunday';

  @override
  String get monday => 'Monday';

  @override
  String get tuesday => 'Tuesday';

  @override
  String get wednesday => 'Wednesday';

  @override
  String get thursday => 'Thursday';

  @override
  String get friday => 'Friday';

  @override
  String get saturday => 'Saturday';

  @override
  String get jan => 'Jan';

  @override
  String get feb => 'Feb';

  @override
  String get mar => 'Mar';

  @override
  String get apr => 'Apr';

  @override
  String get may => 'May';

  @override
  String get jun => 'Jun';

  @override
  String get jul => 'Jul';

  @override
  String get aug => 'Aug';

  @override
  String get sep => 'Sep';

  @override
  String get oct => 'Oct';

  @override
  String get nov => 'Nov';

  @override
  String get dec => 'Dec';

  @override
  String get appTitle => 'Pregnancy & Baby Care';

  @override
  String get welcome => 'Welcome';

  @override
  String get login => 'Login';

  @override
  String get signup => 'Sign Up';

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
  String get welcome_back => 'Welcome Back! ';

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
  String get forgot => 'Forgot Password?';

  @override
  String get notRegistered => 'Not registered yet?';

  @override
  String get createAccount => 'Create an Account';

  @override
  String get your_name => 'Your Name';

  @override
  String get email => 'Email';

  @override
  String get enter_email => 'Enter your email';

  @override
  String get enter_name => 'Enter your Name';

  @override
  String get rememberMe => 'Remember me';

  @override
  String get sendOtp => 'Send Code';

  @override
  String get verifyOtp => 'Verify Code';

  @override
  String get enterOtpCode => 'Enter verification code';

  @override
  String get otpSent => 'Verification code sent to your email';

  @override
  String get otpCodePlaceholder => '6-digit code';

  @override
  String get resendOtp => 'Resend code';

  @override
  String get noInternetConnection =>
      'No internet connection. Please check your network and try again.';

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
  String get searchHint => 'Find what you need.. .';

  @override
  String get dontMissOut => 'Don\'t miss out! ';

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
      'Great job!  You\'re maintaining a healthy weight gain pace. Keep up with your balanced diet and gentle exercise routine.';

  @override
  String get onTrack => 'On Track';

  @override
  String get moodTab => 'Mood Tab';

  @override
  String get recentEntries => 'Recent entries';

  @override
  String get howAreYouFeelingToday => 'How are you feeling today?';

  @override
  String get feltEnergeticToday => 'Felt energetic today';

  @override
  String hoursAgo(Object hours) {
    return '$hours hours ago';
  }

  @override
  String get calm => 'Calm';

  @override
  String get relaxingEvening => 'Relaxing evening';

  @override
  String get yesterday => 'Yesterday';

  @override
  String get tired => 'Tired';

  @override
  String get needMoreSleep => 'Need more sleep';

  @override
  String daysAgo(Object days) {
    return '$days days ago';
  }

  @override
  String get trackingMoodHelps =>
      'Tracking your mood helps you understand your well-being.';

  @override
  String get great => 'Great';

  @override
  String get good => 'Good';

  @override
  String get okay => 'Okay';

  @override
  String get moodTrendsLast7Days => 'Mood trends (last 7 days)';

  @override
  String get mostlyPositiveMoods => 'Mostly positive moods';

  @override
  String get selfCareSuggestions => 'Self-care suggestions';

  @override
  String get takeShortWalk => 'Take a short walk';

  @override
  String get practiceDeepBreathing => 'Practice deep breathing';

  @override
  String get listenToCalmingMusic => 'Listen to calming music';

  @override
  String get connectWithLovedOnes => 'Connect with loved ones';

  @override
  String get doctors => 'Doctors';

  @override
  String get findDoctors => 'find doctors by name or speciality';

  @override
  String get useCurrentLocation => 'Use current location';

  @override
  String get doctorsFoundSingle => '1 Doctor Found';

  @override
  String doctorsFoundPlural(int count) {
    return '$count Doctors Found';
  }

  @override
  String get filter => 'Filter';

  @override
  String get filterDoctors => 'Filter Doctors';

  @override
  String get clearAll => 'Clear All';

  @override
  String get maximumDistance => 'Maximum Distance';

  @override
  String upToKm(String distance) {
    return 'Up to $distance km';
  }

  @override
  String get minimumRating => 'Minimum Rating';

  @override
  String ratingAndAbove(String rating) {
    return '$rating and above';
  }

  @override
  String get gender => 'Gender';

  @override
  String get male => 'Male';

  @override
  String get female => 'Female';

  @override
  String get minimumReviews => 'Minimum Reviews';

  @override
  String atLeastReviews(int count) {
    return 'At least $count reviews';
  }

  @override
  String get applyFilters => 'Apply Filters';

  @override
  String kmAway(String distance) {
    return '$distance km away';
  }

  @override
  String get reviews => 'reviews';

  @override
  String get noDoctorsFound => 'No doctors found';

  @override
  String noMatchingDoctors(String query) {
    return 'No doctors match \"$query\"';
  }

  @override
  String get tryAdjustingFilters => 'Try adjusting your filters';

  @override
  String get doctorDetails => 'Doctor Details';

  @override
  String get couldNotOpenMaps => 'Could not open maps';

  @override
  String get phoneNumberNotAvailable => 'Phone number not available';

  @override
  String get couldNotMakePhoneCall => 'Could not make phone call';

  @override
  String get gynecologist => 'Gynecologist';

  @override
  String get pediatrician => 'Pediatrician';

  @override
  String get obstetrician => 'Obstetrician';

  @override
  String get generalPractitioner => 'General Practitioner';

  @override
  String get getDirections => 'Get Directions';

  @override
  String get contactInformation => 'Contact Information';

  @override
  String get address => 'Address';

  @override
  String get phoneNumber => 'Phone Number';

  @override
  String get openingHours => 'Opening Hours';

  @override
  String get callNow => 'Call Now';

  @override
  String get all => 'All';

  @override
  String get taken => 'Taken';

  @override
  String get missed => 'Missed';

  @override
  String get take => 'Take';

  @override
  String get noMedicinesFound => 'No medicines found';

  @override
  String get pleaseLoginToViewPlan => 'Please log in to view your plan';

  @override
  String get selectColor => 'Select Color';

  @override
  String get selectSize => 'Select Size';

  @override
  String get addToCart => 'Add to Cart';

  @override
  String get buyNow => 'Buy Now';

  @override
  String get description => 'Description';

  @override
  String get noDescriptionAvailable => 'No description available';

  @override
  String get specifications => 'Specifications';

  @override
  String get customerReviews => 'Customer Reviews';

  @override
  String get seeAll => 'see all';

  @override
  String get completeYourOrder => 'Complete Your Order';

  @override
  String get orderSummary => 'Order Summary';

  @override
  String get product => 'Product';

  @override
  String get size => 'Size';

  @override
  String get subtotal => 'Subtotal';

  @override
  String get deliveryFee => 'Delivery Fee';

  @override
  String get total => 'Total';

  @override
  String get deliveryInformation => 'Delivery Information';

  @override
  String get fullName => 'Full Name';

  @override
  String get enterYourFullName => 'Enter your full name';

  @override
  String get enterYourPhoneNumber => 'Enter your phone number';

  @override
  String get deliveryAddress => 'Delivery Address';

  @override
  String get streetAddressApartment => 'Street address, apartment, etc.';

  @override
  String get city => 'City';

  @override
  String get enterYourCity => 'Enter your city';

  @override
  String get specialInstructions => 'Special Instructions (Optional)';

  @override
  String get addDeliveryNotes => 'Add delivery notes, special requests...';

  @override
  String get paymentMethod => 'Payment Method';

  @override
  String get cashOnDelivery => 'Cash on Delivery';

  @override
  String get creditDebitCard => 'Credit / Debit Card';

  @override
  String get digitalWallet => 'Digital Wallet';

  @override
  String get placeOrder => 'Place Order';

  @override
  String orderPlacedSuccessfully(String orderId) {
    return 'Order $orderId placed successfully!';
  }

  @override
  String get yourInformationIsSecure =>
      'Your information is secure and encrypted';

  @override
  String get openNow => 'Open Now';

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
  String get veryHappy => 'Very happy';

  @override
  String get happy => 'Happy';

  @override
  String get neutral => 'Neutral';

  @override
  String get sad => 'Sad';

  @override
  String get verySad => 'Very sad';

  @override
  String get pleaseSelectMood => 'Please select a mood';

  @override
  String get moodLoggedSuccessfully => 'Mood logged successfully!';

  @override
  String get howAreYouFeeling => 'How are you feeling?';

  @override
  String get energyLevel => 'Energy level';

  @override
  String get low => 'Low';

  @override
  String get high => 'High';

  @override
  String get sleepQuality => 'Sleep quality';

  @override
  String get howWasYourDay => 'How was your day?';

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
  String get lowRisk => 'Low risk';

  @override
  String get withinNormalRange => 'Within normal range';

  @override
  String get gestationalDiabetes => 'Gestational diabetes';

  @override
  String get glucoseLevelsNormal => 'Glucose levels are normal';

  @override
  String get preeclampsia => 'Preeclampsia';

  @override
  String get noProteinInUrine => 'No protein in urine';

  @override
  String get warningSignsToWatch => 'Warning signs to watch';

  @override
  String get severeHeadache => 'Severe headache';

  @override
  String get blurredVision => 'Blurred vision';

  @override
  String get severeAbdominalPain => 'Severe abdominal pain';

  @override
  String get decreasedFetalMovement => 'Decreased fetal movement';

  @override
  String get vaginalBleeding => 'Vaginal bleeding';

  @override
  String get emergencyCall => 'Emergency Call';

  @override
  String get areYouSureCall911 => 'Are you sure you want to call 911?';

  @override
  String get couldNotMakeEmergencyCall => 'Could not make emergency call.';

  @override
  String get ifYouExperienceWarnings =>
      'If you experience any warning signs, contact your healthcare provider immediately.';

  @override
  String get allIndicatorsNormal => 'All indicators are normal';

  @override
  String get emergencyContact => 'Emergency Contact';

  @override
  String get overallRiskLevel => 'Overall risk level';

  @override
  String get call911OrProvider => 'Call 911 or your healthcare provider';

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
  String get systolic => 'Systolic';

  @override
  String get required => 'Required';

  @override
  String get invalid => 'Invalid';

  @override
  String get systolicRange => 'Systolic must be between 70 and 190';

  @override
  String get diastolic => 'Diastolic';

  @override
  String get diastolicRange => 'Diastolic must be between 40 and 130';

  @override
  String get normalRangeLabel => 'Normal range';

  @override
  String get uploadLabResults => 'Upload Lab Results';

  @override
  String get nextLabAppointment => 'Next Lab Appointment';

  @override
  String get navHome => 'Home';

  @override
  String get navTrack => 'Track';

  @override
  String get navHealth => 'Health';

  @override
  String get navPlan => 'Plan';

  @override
  String get navMarket => 'Market';

  @override
  String get hello => 'Hello';

  @override
  String get done => 'DONE';

  @override
  String get daysToGo => 'DAYS TO GO';

  @override
  String get weekLabel => 'WEEK';

  @override
  String get day => 'day';

  @override
  String get days => 'days';

  @override
  String get more => 'More';

  @override
  String get ourTips => 'Our Tips';

  @override
  String get followBestPractices => 'follow best practices';

  @override
  String get ourDoctors => 'Our Doctors';

  @override
  String get findTheBestDoctor => 'find the best doctor';

  @override
  String get upComing => 'Up coming';

  @override
  String get noUpcomingEvents => 'No upcoming events';

  @override
  String get addAppointmentsInPlan => 'Add appointments in Plan';

  @override
  String get overdue => 'Overdue';

  @override
  String inMinutes(int minutes) {
    return 'In $minutes minutes';
  }

  @override
  String inHours(int hours) {
    return 'In $hours hours';
  }

  @override
  String todayAt(String time) {
    return 'Today at $time';
  }

  @override
  String tomorrowAt(String time) {
    return 'Tomorrow at $time';
  }

  @override
  String get at => 'at';
}
