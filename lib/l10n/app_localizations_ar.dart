// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get locationPermissionRequired => 'مطلوب إذن الموقع';

  @override
  String get locationPermissionMessage =>
      'نحتاج إلى الوصول إلى موقعك لعرض الأطباء القريبين.';

  @override
  String get gettingLocation => 'جارٍ تحديد موقعك...';

  @override
  String get locationPermissionDenied => 'تم رفض إذن الموقع';

  @override
  String get locationUpdated => 'تم تحديث الموقع';

  @override
  String get retry => 'إعادة المحاولة';

  @override
  String get showingDoctorsNearYou => 'عرض الأطباء القريبين منك';

  @override
  String get selectLocation => 'اختر الموقع';

  @override
  String get searchWilaya => 'ابحث عن ولاية...';

  @override
  String get security => 'الأمان';

  @override
  String get i_gave_birth => 'لقد ولدتُ';

  @override
  String get no_longer_pregnant => 'لم أعد حاملاً';

  @override
  String get help_support => 'المساعدة والدعم';

  @override
  String get contact_us => 'اتصلي بنا';

  @override
  String get privacy_policy => 'سياسة الخصوصية';

  @override
  String get about_app => 'حول التطبيق';

  @override
  String get change => 'تغيير';

  @override
  String get save => 'حفظ';

  @override
  String get save_changes => 'حفظ التغييرات';

  @override
  String get logout_confirmation => 'هل أنتِ متأكدة أنكِ تريدين تسجيل الخروج؟';

  @override
  String get cancel => 'إلغاء';

  @override
  String get unknown => 'غير معروف';

  @override
  String get profile => 'الملف الشخصي';

  @override
  String get profile_updated => 'تم تحديث الملف الشخصي';

  @override
  String get edit_profile => 'تعديل الملف الشخصي';

  @override
  String get change_profile_photo => 'تغيير صورة الملف الشخصي';

  @override
  String get full_name => 'الاسم الكامل';

  @override
  String get enable_notifications => 'تفعيل الإشعارات';

  @override
  String get phone => 'الهاتف';

  @override
  String get country => 'البلد';

  @override
  String get plan => 'الخطة';

  @override
  String get sundayShort => 'ح';

  @override
  String get mondayShort => 'ن';

  @override
  String get tuesdayShort => 'ث';

  @override
  String get wednesdayShort => 'ر';

  @override
  String get thursdayShort => 'خ';

  @override
  String get fridayShort => 'ج';

  @override
  String get saturdayShort => 'س';

  @override
  String get todaysMedicine => 'دواء اليوم';

  @override
  String get upcomingAppointments => 'المواعيد القادمة';

  @override
  String get scheduled => 'مجدول';

  @override
  String get addNewMedicine => 'إضافة دواء جديد';

  @override
  String get addNewAppointment => 'إضافة موعد جديد';

  @override
  String get medicine => 'الأدوية';

  @override
  String get appointments => 'المواعيد';

  @override
  String get appointmentName => 'اسم الموعد';

  @override
  String get medicationName => 'اسم الدواء';

  @override
  String get nextLabel => 'التالي';

  @override
  String get doneLabel => 'تم';

  @override
  String get uploadPicture => 'ارفعي صورة';

  @override
  String get camera => 'الكاميرا';

  @override
  String get gallery => 'المعرض';

  @override
  String get removeImage => 'إزالة الصورة';

  @override
  String get tapToAddPicture => 'اضغط لإضافة صورة';

  @override
  String get optionalImageNote => 'إضافة صورة اختيارية. يمكنك تخطي هذه الخطوة.';

  @override
  String get selectFormDose => 'اختاري الشكل والجرعة';

  @override
  String get frequencySchedule => 'التكرار والجدول';

  @override
  String get frequencyType => 'نوع التكرار';

  @override
  String get frequencyValue => 'قيمة التكرار';

  @override
  String get scheduledTimesLabel => 'الأوقات المجدولة';

  @override
  String get asNeeded => 'عند الحاجة';

  @override
  String get dosage => 'الجرعة';

  @override
  String get dosageExample => 'مثال: 5mg أو 10ml';

  @override
  String get formPill => 'حبة دواء';

  @override
  String get formInjection => 'حقنة';

  @override
  String get formSpray => 'رذاذ';

  @override
  String get formDrop => 'قطرة';

  @override
  String get formSyrup => 'شراب';

  @override
  String get formOthers => 'أخرى';

  @override
  String medicinesTaken(int taken, int total) {
    return '$taken من $total تم أخذها';
  }

  @override
  String get daily => 'يوميًا';

  @override
  String get weekly => 'أسبوعيًا';

  @override
  String get monthly => 'شهريًا';

  @override
  String get timesPerDayExample => 'مثال: 3 مرات يوميًا';

  @override
  String get timesPerWeekExample => 'مثال: 2 مرتين أسبوعيًا';

  @override
  String get timesPerMonthExample => 'مثال: 1 مرة شهريًا';

  @override
  String get appointmentDateTime => 'تاريخ ووقت الموعد';

  @override
  String get appointmentLocation => 'مكان الموعد';

  @override
  String get selectDate => 'اختر التاريخ';

  @override
  String get selectTime => 'اختر الوقت';

  @override
  String get startDate => 'تاريخ البدء';

  @override
  String get endDate => 'تاريخ النهاية (اختياري)';

  @override
  String get selectStartDate => 'اختر تاريخ البدء';

  @override
  String get selectEndDate => 'اختر تاريخ النهاية';

  @override
  String get addTime => 'إضافة وقت';

  @override
  String get noScheduledTimesAdded => 'لم تتم إضافة أوقات مجدولة بعد';

  @override
  String get today => 'اليوم';

  @override
  String get tomorrow => 'غداً';

  @override
  String get noAppointmentsFound => 'لا توجد مواعيد';

  @override
  String get appointment => 'موعد';

  @override
  String get pleaseAddScheduledTime => 'يرجى إضافة وقت مجدول واحد على الأقل';

  @override
  String reviewsCount(Object count) {
    return '$count تقييمات';
  }

  @override
  String get qty => 'الكمية';

  @override
  String get noMedicines => 'لا توجد أدوية';

  @override
  String get schedule => 'الجدول';

  @override
  String get availability => 'التوفر';

  @override
  String get specialty => 'التخصص';

  @override
  String get bookAppointment => 'احجزي موعدًا';

  @override
  String get price => 'السعر';

  @override
  String get quantity => 'الكمية';

  @override
  String get checkout => 'إتمام الشراء';

  @override
  String get applyCoupon => 'تطبيق القسيمة';

  @override
  String get popular => 'شائع';

  @override
  String get offers => 'عروض';

  @override
  String get newLabel => 'جديد';

  @override
  String get contact => 'تواصل';

  @override
  String get message => 'رسالة';

  @override
  String get location => 'الموقع';

  @override
  String get noResults => 'لا توجد نتائج';

  @override
  String get search => 'بحث';

  @override
  String get sort => 'فرز';

  @override
  String get marketplace => 'المتجر';

  @override
  String get doctorsFeatureTitle => 'الأطباء';

  @override
  String get planFeatureTitle => 'الخطة';

  @override
  String get addMedicine => 'أضيفي دواء';

  @override
  String get addAppointment => 'أضيفي موعدًا';

  @override
  String get error => 'خطأ';

  @override
  String get success => 'نجاح';

  @override
  String get confirm => 'تأكيد';

  @override
  String get remove => 'إزالة';

  @override
  String get apply => 'تطبيق';

  @override
  String get reviewsLabel => 'تقييمات';

  @override
  String get rating => 'التقييم';

  @override
  String get recommended => 'موصى به';

  @override
  String get noReviews => 'لا توجد تقييمات';

  @override
  String get delivery => 'التسليم';

  @override
  String get shipping => 'الشحن';

  @override
  String get taxes => 'الضرائب';

  @override
  String get sunday => 'الأحد';

  @override
  String get monday => 'الاثنين';

  @override
  String get tuesday => 'الثلاثاء';

  @override
  String get wednesday => 'الأربعاء';

  @override
  String get thursday => 'الخميس';

  @override
  String get friday => 'الجمعة';

  @override
  String get saturday => 'السبت';

  @override
  String get jan => 'يناير';

  @override
  String get feb => 'فبراير';

  @override
  String get mar => 'مارس';

  @override
  String get apr => 'أبريل';

  @override
  String get may => 'مايو';

  @override
  String get jun => 'يونيو';

  @override
  String get jul => 'يوليو';

  @override
  String get aug => 'أغسطس';

  @override
  String get sep => 'سبتمبر';

  @override
  String get oct => 'أكتوبر';

  @override
  String get nov => 'نوفمبر';

  @override
  String get dec => 'ديسمبر';

  @override
  String get appTitle => 'رعاية الحمل والطفل';

  @override
  String get welcome => 'مرحباً';

  @override
  String get login => 'تسجيل الدخول';

  @override
  String get signup => 'إنشاء حساب';

  @override
  String get password => 'كلمة المرور';

  @override
  String get logout => 'تسجيل الخروج';

  @override
  String get settings => 'الإعدادات';

  @override
  String get language => 'اللغة';

  @override
  String get darkMode => 'الوضع الداكن';

  @override
  String get notifications => 'الإشعارات';

  @override
  String get help => 'المساعدة';

  @override
  String get about => 'حول';

  @override
  String get welcome_back => 'مرحباً بعودتكِ! ';

  @override
  String get or => '— أو —';

  @override
  String get register => 'تسجيل';

  @override
  String get auth => 'رفيقكِ الموثوق في كل مرحلة من مراحل الأمومة';

  @override
  String get auth2 => 'دعي Gestanéa ترشدكِ خلال الحمل، ورعاية الطفل، وما بعده.';

  @override
  String get forgot => 'نسيتِ كلمة المرور؟';

  @override
  String get notRegistered => 'لم تقومي بالتسجيل بعد؟';

  @override
  String get createAccount => 'إنشاء حساب';

  @override
  String get your_name => 'اسمكِ';

  @override
  String get email => 'البريد الإلكتروني';

  @override
  String get enter_email => 'أدخلي بريدكِ الإلكتروني';

  @override
  String get enter_name => 'أدخلي اسمكِ';

  @override
  String get rememberMe => 'تذكريني';

  @override
  String get sendOtp => 'إرسال الرمز';

  @override
  String get verifyOtp => 'تحقق من الرمز';

  @override
  String get enterOtpCode => 'أدخلي رمز التحقق';

  @override
  String get otpSent => 'تم إرسال رمز التحقق إلى بريدكِ الإلكتروني';

  @override
  String get otpCodePlaceholder => 'رمز من 6 أرقام';

  @override
  String get resendOtp => 'إعادة إرسال الرمز';

  @override
  String get noInternetConnection =>
      'لا يوجد اتصال بالإنترنت. يرجى التحقق من شبكتكِ والمحاولة مرة أخرى.';

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

  @override
  String get market => 'المتجر';

  @override
  String get maternityWear => 'ملابس الحمل';

  @override
  String get painRelief => 'تخفيف الألم';

  @override
  String get skinCare => 'العناية بالبشرة';

  @override
  String get pregnancyPillow => 'وسادة الحمل';

  @override
  String get backSupportBelt => 'حزام دعم الظهر';

  @override
  String get searchHint => 'ابحثي عما تحتاجينه.. .';

  @override
  String get dontMissOut => 'لا تفوتي الفرصة! ';

  @override
  String get discountUpTo => 'خصم يصل إلى 50%';

  @override
  String get upgradeNow => 'قومي بالترقية الآن';

  @override
  String get healthLog => 'سجل الصحة';

  @override
  String get trackYourWellness => 'تابعي صحتكِ';

  @override
  String get vitals => 'المؤشرات الحيوية';

  @override
  String get symptoms => 'الأعراض';

  @override
  String get labResults => 'نتائج\nالمختبر';

  @override
  String get riskAlerts => 'تنبيهات\nالمخاطر';

  @override
  String get mood => 'المزاج';

  @override
  String get weight => 'الوزن';

  @override
  String get heartRate => 'معدل ضربات القلب';

  @override
  String get bloodPressure => 'ضغط الدم';

  @override
  String get normal => 'طبيعي';

  @override
  String get add => 'إضافة';

  @override
  String get measurement => 'القياس';

  @override
  String get healthTipMessage =>
      'عمل رائع! أنتِ تحافظين على وتيرة زيادة وزن صحية. استمري في تناول نظام غذائي متوازن وممارسة التمارين الخفيفة.';

  @override
  String get onTrack => 'على المسار الصحيح';

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
  String get doctors => 'الأطباء';

  @override
  String get findDoctors => 'ابحثي عن الأطباء بالاسم أو التخصص';

  @override
  String get useCurrentLocation => 'استخدمي موقعي الحالي';

  @override
  String get doctorsFoundSingle => 'تم العثور على طبيب واحد';

  @override
  String doctorsFoundPlural(int count) {
    return 'تم العثور على $count أطباء';
  }

  @override
  String get filter => 'تصفية';

  @override
  String get filterDoctors => 'تصفية الأطباء';

  @override
  String get clearAll => 'مسح الكل';

  @override
  String get maximumDistance => 'المسافة القصوى';

  @override
  String upToKm(String distance) {
    return 'حتى $distance كم';
  }

  @override
  String get minimumRating => 'التقييم الأدنى';

  @override
  String ratingAndAbove(String rating) {
    return '$rating وما فوق';
  }

  @override
  String get gender => 'الجنس';

  @override
  String get male => 'ذكر';

  @override
  String get female => 'أنثى';

  @override
  String get minimumReviews => 'الحد الأدنى من المراجعات';

  @override
  String atLeastReviews(int count) {
    return 'على الأقل $count مراجعة';
  }

  @override
  String get applyFilters => 'تطبيق التصفية';

  @override
  String kmAway(String distance) {
    return 'على بعد $distance كم';
  }

  @override
  String get reviews => 'مراجعات';

  @override
  String get noDoctorsFound => 'لم يتم العثور على أطباء';

  @override
  String noMatchingDoctors(String query) {
    return 'لا يوجد أطباء يطابقون \"$query\"';
  }

  @override
  String get tryAdjustingFilters => 'حاولي تعديل التصفية';

  @override
  String get doctorDetails => 'تفاصيل الطبيب';

  @override
  String get couldNotOpenMaps => 'تعذر فتح الخرائط';

  @override
  String get phoneNumberNotAvailable => 'رقم الهاتف غير متوفر';

  @override
  String get couldNotMakePhoneCall => 'تعذر إجراء المكالمة الهاتفية';

  @override
  String get gynecologist => 'طبيب نساء وتوليد';

  @override
  String get pediatrician => 'طبيب أطفال';

  @override
  String get obstetrician => 'طبيب توليد';

  @override
  String get generalPractitioner => 'طبيب عام';

  @override
  String get getDirections => 'احصلي على الاتجاهات';

  @override
  String get contactInformation => 'معلومات الاتصال';

  @override
  String get address => 'العنوان';

  @override
  String get phoneNumber => 'رقم الهاتف';

  @override
  String get openingHours => 'ساعات العمل';

  @override
  String get callNow => 'اتصلي الآن';

  @override
  String get all => 'الكل';

  @override
  String get taken => 'تم تناولها';

  @override
  String get missed => 'فاتت';

  @override
  String get take => 'تناولي';

  @override
  String get noMedicinesFound => 'لم يتم العثور على أدوية';

  @override
  String get pleaseLoginToViewPlan => 'يرجى تسجيل الدخول لعرض خطتك';

  @override
  String get selectColor => 'اختاري اللون';

  @override
  String get selectSize => 'اختاري المقاس';

  @override
  String get addToCart => 'أضيفي إلى السلة';

  @override
  String get buyNow => 'اشتري الآن';

  @override
  String get description => 'الوصف';

  @override
  String get noDescriptionAvailable => 'لا يوجد وصف متاح';

  @override
  String get specifications => 'المواصفات';

  @override
  String get customerReviews => 'تقييمات العملاء';

  @override
  String get seeAll => 'عرض الكل';

  @override
  String get completeYourOrder => 'أكملي طلبك';

  @override
  String get orderSummary => 'ملخص الطلب';

  @override
  String get product => 'المنتج';

  @override
  String get size => 'المقاس';

  @override
  String get subtotal => 'المجموع الفرعي';

  @override
  String get deliveryFee => 'رسوم التوصيل';

  @override
  String get total => 'المجموع';

  @override
  String get deliveryInformation => 'معلومات التوصيل';

  @override
  String get fullName => 'الاسم الكامل';

  @override
  String get enterYourFullName => 'أدخلي اسمك الكامل';

  @override
  String get enterYourPhoneNumber => 'أدخلي رقم هاتفك';

  @override
  String get deliveryAddress => 'عنوان التوصيل';

  @override
  String get streetAddressApartment => 'عنوان الشارع، الشقة، إلخ.';

  @override
  String get city => 'المدينة';

  @override
  String get enterYourCity => 'أدخلي مدينتك';

  @override
  String get specialInstructions => 'تعليمات خاصة (اختياري)';

  @override
  String get addDeliveryNotes => 'أضيفي ملاحظات التوصيل، طلبات خاصة...';

  @override
  String get paymentMethod => 'طريقة الدفع';

  @override
  String get cashOnDelivery => 'الدفع عند الاستلام';

  @override
  String get creditDebitCard => 'بطاقة ائتمان / خصم';

  @override
  String get digitalWallet => 'محفظة رقمية';

  @override
  String get placeOrder => 'إتمام الطلب';

  @override
  String orderPlacedSuccessfully(String orderId) {
    return 'تم تقديم الطلب $orderId بنجاح!';
  }

  @override
  String get yourInformationIsSecure => 'معلوماتك آمنة ومشفرة';

  @override
  String get openNow => 'مفتوح الآن';

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
}
