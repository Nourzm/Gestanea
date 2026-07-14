// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

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
  String get moodTab => 'علامة المزاج';

  @override
  String get recentEntries => 'الإدخالات الأخيرة';

  @override
  String get howAreYouFeelingToday => 'كيف تشعرين اليوم؟';

  @override
  String get feltEnergeticToday => 'شعرت بالنشاط اليوم';

  @override
  String hoursAgo(Object hours) {
    return 'منذ $hours ساعة';
  }

  @override
  String get calm => 'هادئة';

  @override
  String get relaxingEvening => 'أمسية مريحة';

  @override
  String get yesterday => 'أمس';

  @override
  String get tired => 'متعبة';

  @override
  String get needMoreSleep => 'بحاجة إلى مزيد من النوم';

  @override
  String daysAgo(Object days) {
    return 'منذ $days يوم';
  }

  @override
  String get trackingMoodHelps => 'تتبع مزاجك يساعدك على فهم حالتك النفسية.';

  @override
  String get great => 'رائعة';

  @override
  String get good => 'جيدة';

  @override
  String get okay => 'لا بأس';

  @override
  String get moodTrendsLast7Days => 'اتجاهات المزاج (آخر 7 أيام)';

  @override
  String get mostlyPositiveMoods => 'مزاج إيجابي في الغالب';

  @override
  String get takeCareYourself => 'كوني لطيفة مع نفسك — اطلبي الدعم عند الحاجة';

  @override
  String get logMoodToSeeTrends => 'سجّلي مزاجك لرؤية الاتجاهات الأسبوعية';

  @override
  String get noEntriesYet => 'لا توجد إدخالات بعد';

  @override
  String get selfCareSuggestions => 'اقتراحات العناية الذاتية';

  @override
  String get takeShortWalk => 'قومي بنزهة قصيرة';

  @override
  String get practiceDeepBreathing => 'مارسي التنفس العميق';

  @override
  String get listenToCalmingMusic => 'استمعي إلى موسيقى هادئة';

  @override
  String get connectWithLovedOnes => 'تواصلي مع أحبائك';

  @override
  String get doctors => 'الأطباء';

  @override
  String get findDoctors => 'ابحثي عن الأطباء بالاسم أو التخصص';

  @override
  String get useCurrentLocation => 'استخدمي موقعي الحالي';

  @override
  String get algiers => 'الجزائر';

  @override
  String get oran => 'وهران';

  @override
  String get constantine => 'قسنطينة';

  @override
  String get annaba => 'عنابة';

  @override
  String get blida => 'البليدة';

  @override
  String get bouira => 'البويرة';

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
  String get nausea => 'غثيان';

  @override
  String get headache => 'صداع';

  @override
  String get backPain => 'ألم الظهر';

  @override
  String get swelling => 'تورّم';

  @override
  String get fatigue => 'إرهاق';

  @override
  String get dizziness => 'دوخة';

  @override
  String get heartburn => 'حرقة المعدة';

  @override
  String get legCramps => 'تشنجات الساق';

  @override
  String get other => 'أخرى';

  @override
  String get pleaseSelectSymptom => 'يرجى اختيار عرض';

  @override
  String get pleaseSelectSeverity => 'يرجى اختيار الشدة';

  @override
  String get symptomLoggedSuccessfully => 'تم تسجيل العرض بنجاح!';

  @override
  String get addSymptom => 'إضافة عرض';

  @override
  String get symptomType => 'نوع العرض';

  @override
  String get selectSymptom => 'اختر العرض';

  @override
  String get specifySymptom => 'حدّد العرض';

  @override
  String get pleaseSpecifySymptom => 'يرجى تحديد العرض';

  @override
  String get severity => 'الشدة';

  @override
  String get mild => 'خفيف';

  @override
  String get moderate => 'متوسط';

  @override
  String get severe => 'شديد';

  @override
  String get duration => 'المدة';

  @override
  String get pleaseEnterDuration => 'يرجى إدخال المدة';

  @override
  String get notes => 'ملاحظات';

  @override
  String get veryHappy => 'سعيدة جداً';

  @override
  String get happy => 'سعيدة';

  @override
  String get neutral => 'محايدة';

  @override
  String get sad => 'حزينة';

  @override
  String get verySad => 'حزينة جداً';

  @override
  String get pleaseSelectMood => 'يرجى اختيار المزاج';

  @override
  String get moodLoggedSuccessfully => 'تم تسجيل المزاج بنجاح!';

  @override
  String get howAreYouFeeling => 'كيف تشعرين؟';

  @override
  String get energyLevel => 'مستوى الطاقة';

  @override
  String get low => 'منخفض';

  @override
  String get high => 'مرتفع';

  @override
  String get elevated => 'مرتفع قليلاً';

  @override
  String get kg => 'كغ';

  @override
  String get bpm => 'نبضة/د';

  @override
  String get borderline => 'حدّي';

  @override
  String get analyzeWithAi => 'تحليل بالذكاء الاصطناعي';

  @override
  String get aiAnalyzing => 'جارٍ تحليل نتائجك…';

  @override
  String get aiDisclaimerTitle => 'قبل استخدام تحليل الذكاء الاصطناعي';

  @override
  String get aiDisclaimerBody =>
      'تستخدم هذه الميزة الذكاء الاصطناعي لمساعدتك على فهم نتائج تحاليلك بلغة بسيطة. إنها لأغراض تثقيفية فقط — وليست تشخيصاً ولا نصيحة طبية، ولا تغني عن طبيبك أو قابلتك. يُرسَل تقريرك بشكل آمن للتحليل. هل تريدين المتابعة؟';

  @override
  String get iUnderstandContinue => 'فهمت، تابعي';

  @override
  String get aiNeedsConnection =>
      'يتطلّب تحليل الذكاء الاصطناعي اتصالاً بالإنترنت. سيتم عرض الواجهة العادية بدلاً من ذلك.';

  @override
  String get aiRateLimited =>
      'لقد بلغتِ حد تحليلات الذكاء الاصطناعي لليوم. حاولي مرة أخرى غداً.';

  @override
  String get aiAnalysisFailed =>
      'تعذّر تحليل النتائج الآن. حاولي مرة أخرى لاحقاً.';

  @override
  String get aiResultTitle => 'تحليل المختبر بالذكاء الاصطناعي';

  @override
  String get aiOverallSummary => 'ملخّص';

  @override
  String get aiGuidance => 'إرشادات';

  @override
  String get aiDetectedTests => 'نتائجك';

  @override
  String get aiSeekCareTitle => 'يرجى التواصل مع مقدّم الرعاية الصحية';

  @override
  String get aiSaveResults => 'حفظ في نتائجي';

  @override
  String get aiResultsSaved => 'تم حفظ تحليل الذكاء الاصطناعي في نتائج مختبرك';

  @override
  String get sleepQuality => 'جودة النوم';

  @override
  String get howWasYourDay => 'كيف كان يومك؟';

  @override
  String get prePregnancyBMI => 'مؤشر كتلة الجسم قبل الحمل';

  @override
  String get bmiUnderweight => 'نقص الوزن';

  @override
  String get bmiOverweight => 'زيادة الوزن';

  @override
  String get bmiObese => 'سمنة';

  @override
  String get setUpBmiTracking => 'إعداد تتبع مؤشر كتلة الجسم';

  @override
  String get bmiSetupPrompt =>
      'أضيفي طولك ووزنك قبل الحمل لتتبّع مؤشر كتلة الجسم وزيادة الوزن الصحية.';

  @override
  String get heightCmLabel => 'الطول (سم)';

  @override
  String get prePregnancyWeightLabel => 'الوزن قبل الحمل (كغ)';

  @override
  String get edit => 'تعديل';

  @override
  String get normalBMI => 'طبيعي';

  @override
  String get currentGain => 'الزيادة الحالية';

  @override
  String get targetRange => 'النطاق المستهدف';

  @override
  String get expected => 'المتوقع';

  @override
  String get recentLabResults => 'نتائج التحاليل الأخيرة';

  @override
  String get keepLabResultsOrganized =>
      'احتفظي بنتائج تحاليلك منظمة لمتابعة أفضل.';

  @override
  String get viewAllLabResults => 'عرض جميع نتائج التحاليل';

  @override
  String get riskFactorsToMonitor => 'عوامل الخطر التي يجب مراقبتها';

  @override
  String get lowRisk => 'خطر منخفض';

  @override
  String get moderateRisk => 'متوسط';

  @override
  String get highRisk => 'مرتفع';

  @override
  String get monitorWithProvider => 'راقبي الوضع وناقشيه مع طبيبك';

  @override
  String get contactProviderSoon => 'تواصلي مع طبيبك قريباً';

  @override
  String get addMeasurementToAssess => 'أضيفي قياساً لتقييم هذا';

  @override
  String get someIndicatorsElevated => 'بعض المؤشرات مرتفعة قليلاً';

  @override
  String get someIndicatorsHigh => 'بعض المؤشرات تحتاج إلى انتباه';

  @override
  String get assessedFromYourData => 'بناءً على قياساتك المسجّلة';

  @override
  String get withinNormalRange => 'ضمن النطاق الطبيعي';

  @override
  String get gestationalDiabetes => 'سكري الحمل';

  @override
  String get glucoseLevelsNormal => 'مستويات الجلوكوز طبيعية';

  @override
  String get preeclampsia => 'تسمم الحمل';

  @override
  String get noProteinInUrine => 'لا يوجد بروتين في البول';

  @override
  String get warningSignsToWatch => 'علامات التحذير التي يجب الانتباه إليها';

  @override
  String get severeHeadache => 'صداع شديد';

  @override
  String get blurredVision => 'تشوش الرؤية';

  @override
  String get severeAbdominalPain => 'ألم شديد في البطن';

  @override
  String get decreasedFetalMovement => 'انخفاض حركة الجنين';

  @override
  String get vaginalBleeding => 'نزيف مهبلي';

  @override
  String get emergencyCall => 'مكالمة طوارئ';

  @override
  String get areYouSureCall911 => 'هل أنت متأكدة أنك تريدين الاتصال بالطوارئ؟';

  @override
  String get couldNotMakeEmergencyCall => 'تعذّر إجراء مكالمة الطوارئ.';

  @override
  String get ifYouExperienceWarnings =>
      'إذا واجهت أي علامات تحذيرية، تواصلي مع مقدم الرعاية الصحية فوراً.';

  @override
  String get allIndicatorsNormal => 'جميع المؤشرات طبيعية';

  @override
  String get emergencyContact => 'جهة اتصال الطوارئ';

  @override
  String get overallRiskLevel => 'مستوى الخطر العام';

  @override
  String get call911OrProvider => 'اتصلي بالطوارئ أو بمقدم الرعاية الصحية';

  @override
  String get recentSymptoms => 'الأعراض الأخيرة';

  @override
  String get logNewSymptom => 'تسجيل عرض جديد';

  @override
  String get symptomFrequency => 'تكرار الأعراض';

  @override
  String get swollenFeet => 'تورّم القدمين';

  @override
  String get sleepIssues => 'مشاكل النوم';

  @override
  String get times => 'مرات';

  @override
  String get commonSymptomsWeek24 =>
      'تشمل الأعراض الشائعة في الأسبوع 24 ألم الظهر والتورّم.';

  @override
  String get viewAllSymptoms => 'عرض جميع الأعراض';

  @override
  String get weightProgress => 'تطور الوزن';

  @override
  String get measurementSavedSuccessfully => 'تم حفظ القياس بنجاح!';

  @override
  String get addMeasurement => 'إضافة قياس';

  @override
  String get weightKg => 'الوزن (كجم)';

  @override
  String get pleaseEnterWeight => 'يرجى إدخال وزنك';

  @override
  String get pleaseEnterValidNumber => 'يرجى إدخال رقم صالح';

  @override
  String get weightRange => 'يجب أن يكون الوزن بين 30 و200 كجم';

  @override
  String get heartRateBpm => 'معدل ضربات القلب (نبضة/دقيقة)';

  @override
  String get pleaseEnterHeartRate => 'يرجى إدخال معدل ضربات قلبك';

  @override
  String get heartRateRange =>
      'يجب أن يكون معدل ضربات القلب بين 40 و200 نبضة/دقيقة';

  @override
  String get systolic => 'الانقباضي';

  @override
  String get required => 'مطلوب';

  @override
  String get invalid => 'غير صالح';

  @override
  String get systolicRange => 'يجب أن يكون الضغط الانقباضي بين 70 و190';

  @override
  String get diastolic => 'الانبساطي';

  @override
  String get diastolicRange => 'يجب أن يكون الضغط الانبساطي بين 40 و130';

  @override
  String get normalRangeLabel => 'النطاق الطبيعي';

  @override
  String get uploadLabResults => 'رفع نتائج التحاليل';

  @override
  String get nextLabAppointment => 'موعد التحاليل القادم';

  @override
  String get currentWeekLabel => 'الأسبوع الحالي';

  @override
  String viewingWeek(int week) {
    return 'عرض الأسبوع $week';
  }

  @override
  String previewingWeek(int selected, int current) {
    return 'معاينة الأسبوع $selected — أسبوعك الحالي هو $current.';
  }

  @override
  String get length => 'الطول';

  @override
  String whatToExpectWeek(int week) {
    return 'ما يمكن توقعه في الأسبوع $week';
  }

  @override
  String get kickCounter => 'عدّاد الركلات';

  @override
  String get noKickSessions => 'لا توجد جلسات مسجلة بعد.';

  @override
  String kicksValue(int count) {
    return '$count ركلة';
  }

  @override
  String minutesShort(int minutes) {
    return '$minutes دقيقة';
  }

  @override
  String get startLabel => 'ابدئي';

  @override
  String get tapToStartKicks => 'اضغطي لبدء جلسة عدّ الركلات';

  @override
  String get tapToCount => 'اضغطي للعدّ';

  @override
  String get resetLabel => 'إعادة';

  @override
  String get finishLabel => 'إنهاء';

  @override
  String sessionSaved(int count) {
    return 'تم حفظ الجلسة: $count ركلة';
  }

  @override
  String weeksDaysSuffix(int days) {
    return 'أسبوعًا، $days يوم';
  }

  @override
  String get notSet => 'غير محدد';

  @override
  String get firstTrimester => 'الثلث الأول';

  @override
  String get secondTrimester => 'الثلث الثاني';

  @override
  String get thirdTrimester => 'الثلث الثالث';

  @override
  String get weekNote4 => 'يبدأ قلب الطفل بالتكوّن وسينبض قريباً.';

  @override
  String get weekNote6 => 'تظهر براعم صغيرة ستصبح الذراعين والساقين.';

  @override
  String get weekNote8 => 'تتشكل الأصابع وأصابع القدم والأعضاء الرئيسية.';

  @override
  String get weekNote10 => 'تتكوّن الأعضاء الحيوية ويستطيع الطفل ثني أطرافه.';

  @override
  String get weekNote12 => 'تظهر ردود الأفعال — قد يثني الطفل أصابعه.';

  @override
  String get weekNote14 => 'تتطور عضلات الوجه ويبدأ الطفل في تكوين التعابير.';

  @override
  String get weekNote16 => 'يقوم الطفل بحركات صغيرة ستشعرين بها قريباً.';

  @override
  String get weekNote20 => 'منتصف الطريق! ينتظم الطفل في دورة نوم ويقظة.';

  @override
  String get weekNote24 => 'تستمر رئتا الطفل في النمو ويتحسن سمعه.';

  @override
  String get weekNote28 =>
      'يمكن للعينين أن تفتحا وتغلقا، ويستجيب الطفل للأصوات.';

  @override
  String get weekNote32 => 'يتدرب الطفل على التنفس ويكتسب الوزن بسرعة.';

  @override
  String get weekNote36 =>
      'عادةً ما يستقر الطفل ورأسه للأسفل؛ والرئتان شبه جاهزتين.';

  @override
  String get weekNote40 => 'اكتمل الحمل! قد يصل الطفل في أي يوم.';

  @override
  String get trackTitle => 'المتابعة';

  @override
  String get trackingTools => 'أدوات المتابعة';

  @override
  String get babyProgress => 'تقدم الطفل';

  @override
  String get noMilestonesYet => 'لم تتم إضافة أي معالم بعد';

  @override
  String milestonesReached(int achieved, int total) {
    return 'تم تحقيق $achieved من $total معلم';
  }

  @override
  String latestWeightValue(String weight) {
    return 'آخر وزن: $weight كجم';
  }

  @override
  String get feedsToday => 'الرضعات اليوم';

  @override
  String lastFeedAt(String time) {
    return 'آخر رضعة $time';
  }

  @override
  String get noFeedsYet => 'لا توجد رضعات بعد';

  @override
  String get latestWeight => 'آخر وزن';

  @override
  String get recorded => 'مُسجّل';

  @override
  String get milestonesLabel => 'المعالم';

  @override
  String get achievedLabel => 'تم تحقيقها';

  @override
  String get feedingLogTitle => 'سجل الرضاعة';

  @override
  String get feedingLogSub => 'تتبع الرضعات';

  @override
  String get growthTrackerTitle => 'متابعة النمو';

  @override
  String get growthTrackerSub => 'الوزن والطول';

  @override
  String get milestonesSub => 'التطور';

  @override
  String get vaccinesTitle => 'اللقاحات';

  @override
  String get vaccinesSub => 'التحصين';

  @override
  String get noBabyProfile => 'لا يوجد ملف للطفل بعد';

  @override
  String get addBabyPrompt =>
      'أضيفي طفلك لبدء تتبع الرضاعة والنمو والمعالم واللقاحات.';

  @override
  String get breastfeed => 'رضاعة طبيعية';

  @override
  String get bottle => 'رضاعة بالزجاجة';

  @override
  String get logAFeed => 'تسجيل رضعة';

  @override
  String get logFeed => 'إضافة رضعة';

  @override
  String get amountMlOptional => 'الكمية (مل) — اختياري';

  @override
  String get durationMinOptional => 'المدة (دقيقة) — اختياري';

  @override
  String get feedLogged => 'تم تسجيل الرضعة';

  @override
  String get saveUpper => 'حفظ';

  @override
  String get ageNewborn => 'حديث الولادة';

  @override
  String ageMonths(int months) {
    return '$months شهر';
  }

  @override
  String ageYears(int years) {
    return '$years سنة';
  }

  @override
  String ageYearsMonths(int years, int months) {
    return '$years سنة و$months شهر';
  }

  @override
  String get languages => 'اللغات';

  @override
  String get chooseLanguage => 'اختاري لغتك المفضلة';

  @override
  String get english => 'الإنجليزية';

  @override
  String get french => 'الفرنسية';

  @override
  String get arabic => 'العربية';

  @override
  String get faq => 'الأسئلة الشائعة';

  @override
  String get congratsBabyAdded => 'تهانينا! تمت إضافة طفلك 🎉';

  @override
  String get endPregnancyConfirm =>
      'هل أنت متأكدة؟ سيؤدي هذا إلى إنهاء متابعة الحمل.';

  @override
  String get pregnancyTrackingEnded => 'تم إنهاء متابعة الحمل';

  @override
  String get secureYourAccount => 'أمّني حسابك';

  @override
  String get secureYourAccountDesc =>
      'فعّلي ميزات أمان إضافية لحماية معلوماتك الصحية الشخصية';

  @override
  String get changePassword => 'تغيير كلمة المرور';

  @override
  String get lastChanged30Days => 'آخر تغيير قبل 30 يوماً';

  @override
  String get biometricAuth => 'المصادقة البيومترية';

  @override
  String get biometricAuthDesc => 'استخدمي البصمة أو معرّف الوجه لفتح القفل';

  @override
  String get twoFactorAuth => 'المصادقة الثنائية';

  @override
  String get twoFactorAuthDesc => 'أضيفي طبقة حماية إضافية';

  @override
  String get autoLock => 'القفل التلقائي';

  @override
  String get autoLockDesc => 'قفل التطبيق بعد 5 دقائق من عدم النشاط';

  @override
  String get manageNotifPrefs => 'أديري تفضيلات الإشعارات';

  @override
  String get pushNotifications => 'الإشعارات الفورية';

  @override
  String get pushNotificationsDesc => 'استقبلي الإشعارات على جهازك';

  @override
  String get emailNotifications => 'إشعارات البريد الإلكتروني';

  @override
  String get emailNotificationsDesc =>
      'احصلي على التحديثات عبر البريد الإلكتروني';

  @override
  String get appointmentReminders => 'تذكيرات المواعيد';

  @override
  String get appointmentRemindersDesc => 'لا تفوّتي أي موعد طبي';

  @override
  String get healthTips => 'نصائح صحية';

  @override
  String get healthTipsDesc => 'توصيات يومية للعافية';

  @override
  String get weeklyReports => 'التقارير الأسبوعية';

  @override
  String get weeklyReportsDesc => 'ملخص تقدمك الصحي';

  @override
  String get vitaminReminders => 'تذكيرات الفيتامينات';

  @override
  String get vitaminRemindersDesc => 'لا تنسي مكمّلاتك';

  @override
  String get contactsTitle => 'جهات الاتصال';

  @override
  String get getInTouch => 'تواصلي معنا';

  @override
  String get getInTouchDesc =>
      'لديك سؤال أو ملاحظة؟ يسعدنا سماعك. املئي النموذج أدناه وسنعاود التواصل خلال 24 ساعة.';

  @override
  String get yourName => 'اسمك';

  @override
  String get enterYourName => 'أدخلي اسمك';

  @override
  String get emailAddress => 'البريد الإلكتروني';

  @override
  String get subjectLabel => 'الموضوع';

  @override
  String get subjectHint => 'ما موضوع رسالتك؟';

  @override
  String get messageLabel => 'الرسالة';

  @override
  String get messageHint => 'أخبرينا كيف يمكننا المساعدة...';

  @override
  String get sendMessage => 'إرسال الرسالة';

  @override
  String get wereHereToHelp => 'نحن هنا لمساعدتك';

  @override
  String get wereHereToHelpDesc =>
      'اختاري خيار الدعم الأنسب لك. فريقنا متاح على مدار الساعة لمساعدتك.';

  @override
  String get knowledgeBase => 'قاعدة المعرفة';

  @override
  String get knowledgeBaseDesc => 'تصفحي المقالات والأدلة';

  @override
  String get liveChat => 'الدردشة المباشرة';

  @override
  String get liveChatDesc => 'تحدثي مع فريق الدعم';

  @override
  String get videoTutorials => 'دروس فيديو';

  @override
  String get videoTutorialsDesc => 'شاهدي أدلة خطوة بخطوة';

  @override
  String get emailSupport => 'الدعم عبر البريد';

  @override
  String get phoneSupport => 'الدعم الهاتفي';

  @override
  String get communityForum => 'منتدى المجتمع';

  @override
  String get communityForumDesc => 'تواصلي مع مستخدمات أخريات';

  @override
  String get retry => 'إعادة المحاولة';

  @override
  String get noBabyProfileFound =>
      'لم يتم العثور على ملف للطفل. أضيفي طفلك أولاً.';

  @override
  String get totalTime => 'الوقت الإجمالي';

  @override
  String get recentFeedings => 'الرضعات الأخيرة';

  @override
  String get viewAll => 'عرض الكل';

  @override
  String get noFeedingLogs => 'لا توجد سجلات رضاعة بعد';

  @override
  String get addFeeding => 'إضافة رضعة';

  @override
  String get feedingTypeLabel => 'نوع الرضاعة';

  @override
  String get durationMinutesLabel => 'المدة (دقائق)';

  @override
  String get amountMlLabel => 'الكمية (مل)';

  @override
  String get sideOptional => 'الجانب (اختياري)';

  @override
  String get notSpecified => 'غير محدد';

  @override
  String get sideLeft => 'الأيسر';

  @override
  String get sideRight => 'الأيمن';

  @override
  String get sideBoth => 'كلاهما';

  @override
  String get timeLabel => 'الوقت';

  @override
  String mlValue(String ml) {
    return '$ml مل';
  }

  @override
  String minSideValue(int min, String side) {
    return '$min دقيقة · $side';
  }

  @override
  String get currentWeight => 'الوزن الحالي';

  @override
  String get noData => 'لا توجد بيانات';

  @override
  String lastUpdated(String date) {
    return 'آخر تحديث: $date';
  }

  @override
  String get noRecordsYet => 'لا توجد سجلات بعد';

  @override
  String get weightProgressChart => 'مخطط تطور الوزن';

  @override
  String get chartPlaceholder => 'سيظهر الرسم البياني هنا';

  @override
  String get recentLogs => 'السجلات الأخيرة';

  @override
  String get noWeightRecords => 'لا توجد سجلات وزن بعد';

  @override
  String get addWeightLog => 'إضافة سجل وزن';

  @override
  String get dateLabel => 'التاريخ';

  @override
  String kgValue(String value) {
    return '$value كجم';
  }

  @override
  String get completedLabel => 'المكتملة';

  @override
  String get developmentalMilestones => 'معالم النمو';

  @override
  String expectedAtMonths(String months) {
    return 'متوقع عند $months شهر';
  }

  @override
  String completedOn(String date) {
    return 'اكتمل في $date';
  }

  @override
  String get addMilestoneTitle => 'إضافة معلم';

  @override
  String get milestoneTitle => 'عنوان المعلم';

  @override
  String get expectedAgeMonthsLabel => 'العمر المتوقع (أشهر)';

  @override
  String get addLabel => 'إضافة';

  @override
  String get msFirstSmile => 'أول ابتسامة';

  @override
  String get msHoldsHeadUp => 'يرفع رأسه';

  @override
  String get msRollsOver => 'يتقلّب';

  @override
  String get msSitsWithoutSupport => 'يجلس دون دعم';

  @override
  String get msCrawls => 'يحبو';

  @override
  String get msFirstWords => 'أول الكلمات';

  @override
  String get notAvailable => 'غير متاح';

  @override
  String get vaccineTrackerTitle => 'متابعة اللقاحات';

  @override
  String get seeFullSchedule => 'عرض الجدول الكامل';

  @override
  String get upcomingLabel => 'قادم';

  @override
  String get helloGreeting => 'مرحباً!';

  @override
  String get hello => 'مرحباً';

  @override
  String get ourDoctors => 'أطباؤنا';

  @override
  String get findBestDoctor => 'اعثري على أفضل طبيب';

  @override
  String get upComing => 'القادم';

  @override
  String get overdue => 'متأخر';

  @override
  String inMinutes(int minutes) {
    return 'خلال $minutes دقيقة';
  }

  @override
  String inHours(int hours) {
    return 'خلال $hours ساعة';
  }

  @override
  String get noUpcomingEvents => 'لا توجد أحداث قادمة';

  @override
  String get addAppointmentsInPlan => 'أضيفي مواعيد في قسم التخطيط';

  @override
  String atTimeFormat(String day, String time) {
    return '$day الساعة $time';
  }

  @override
  String get allCaughtUp => 'لقد اطّلعت على كل شيء';

  @override
  String get noNotificationsDesc => 'لا توجد إشعارات جديدة حالياً.';

  @override
  String get delete => 'حذف';

  @override
  String get showMore => 'عرض المزيد';

  @override
  String get showLess => 'عرض أقل';

  @override
  String get daysToGoLabel => 'الأيام المتبقية';

  @override
  String get weekLabel => 'الأسبوع';

  @override
  String get daysLeftLabel => 'الأيام المتبقية';

  @override
  String get moreLabel => 'المزيد';

  @override
  String plusDays(int day) {
    return '+$day يوم';
  }

  @override
  String get ourTips => 'نصائحنا';

  @override
  String get followBestPractices => 'اتبعي أفضل الممارسات';

  @override
  String get allGoodNoAlerts =>
      'كل شيء على ما يرام! لا توجد تنبيهات صحية حالياً.';

  @override
  String get babyDefault => 'الطفل';

  @override
  String get heightLabel => 'الطول';

  @override
  String get growthLabel => 'النمو';

  @override
  String get allCaughtUpShort => 'كل شيء مكتمل!';

  @override
  String nextColon(String date) {
    return 'التالي: $date';
  }

  @override
  String vaccineOverdue(String name) {
    return '$name: متأخر';
  }

  @override
  String vaccineToday(String name) {
    return '$name: اليوم';
  }

  @override
  String vaccineOn(String name, String date) {
    return '$name: $date';
  }

  @override
  String get noUpcomingVaccines => 'لا توجد لقاحات قادمة';

  @override
  String get tipsTitle => 'نصائح';

  @override
  String get catWellness => 'العافية';

  @override
  String get catNutrition => 'التغذية';

  @override
  String get catExercise => 'التمارين';

  @override
  String get catSleep => 'النوم';

  @override
  String get catMind => 'الذهن';

  @override
  String minRead(int minutes) {
    return 'قراءة $minutes دقائق';
  }

  @override
  String get tip1Title => 'التغذية لشخصين';

  @override
  String get tip1Summary => 'العناصر الغذائية الأساسية وتخطيط الوجبات لحمل صحي';

  @override
  String get tip2Title => 'تمددات لطيفة قبل الولادة';

  @override
  String get tip2Summary => 'حركات خفيفة لتخفيف ألم الظهر والحفاظ على المرونة';

  @override
  String get tip3Title => 'نوم أفضل أثناء الحمل';

  @override
  String get tip3Summary => 'حيل الوسائد والوضعيات التي تنفع فعلاً';

  @override
  String get tip4Title => 'التعامل مع غثيان الصباح';

  @override
  String get tip4Summary => 'ما يساعد وما لا يساعد ومتى تراجعين الطبيب';

  @override
  String get myLabResults => 'تحاليلي';

  @override
  String get exportAsZip => 'تصدير كملف ZIP';

  @override
  String get exporting => 'جارٍ التصدير...';

  @override
  String get noLabResultsYet => 'لا توجد تحاليل بعد!';

  @override
  String get uploadFirstLabResult => 'ارفعي أول تحليل للبدء.';

  @override
  String get normalLabel => 'طبيعي';

  @override
  String get autoExtracted => 'مستخرج تلقائياً';

  @override
  String get labResultImage => 'صورة نتيجة التحليل';

  @override
  String get deleteResult => 'حذف النتيجة';

  @override
  String deleteResultConfirm(String name) {
    return 'هل أنت متأكدة من حذف $name؟';
  }

  @override
  String get exportLabResults => 'تصدير التحاليل';

  @override
  String get exportZipConfirm => 'تصدير كل صور التحاليل كملف ZIP؟';

  @override
  String get export => 'تصدير';

  @override
  String normalRangeValue(String min, String max, String unit) {
    return 'الطبيعي: $min-$max $unit';
  }

  @override
  String get labResultAdded => 'تمت إضافة التحليل بنجاح!';

  @override
  String get manualLabEntry => 'إدخال يدوي للتحليل';

  @override
  String get enterLabDetails => 'أدخلي تفاصيل نتيجة التحليل';

  @override
  String get testNameRequired => 'اسم الفحص *';

  @override
  String get pleaseEnterTestName => 'يرجى إدخال اسم الفحص';

  @override
  String get valueRequired => 'القيمة *';

  @override
  String get pleaseEnterValue => 'يرجى إدخال القيمة';

  @override
  String get unitLabel => 'الوحدة';

  @override
  String get minLabel => 'الأدنى';

  @override
  String get maxLabel => 'الأقصى';

  @override
  String get testDate => 'تاريخ الفحص';

  @override
  String get notesOptional => 'ملاحظات (اختياري)';

  @override
  String get anyAdditionalNotes => 'أي ملاحظات إضافية...';

  @override
  String get saveResult => 'حفظ النتيجة';

  @override
  String get myMeasurements => 'قياساتي';

  @override
  String get noMeasurementsYet => 'لا توجد قياسات بعد!';

  @override
  String get tapAddMeasurement => 'اضغطي على «إضافة قياس» للبدء.';

  @override
  String get mySymptoms => 'أعراضي';

  @override
  String get noSymptomsYet => 'لم يتم تسجيل أعراض بعد!';

  @override
  String get tapLogSymptom => 'اضغطي على «تسجيل عرض جديد» للبدء.';

  @override
  String get pdfLabReport => 'تقرير PDF';

  @override
  String get pdfSavedSnack => 'تم حفظ ملف PDF!';

  @override
  String get pdfSavedTitle => 'تم حفظ PDF';

  @override
  String filePrefix(String name) {
    return 'الملف: $name';
  }

  @override
  String get savePdfReference => 'حفظ مرجع PDF';

  @override
  String get enterDataManually => 'إدخال البيانات يدوياً';

  @override
  String ocrFailed(String error) {
    return 'فشل التعرّف الضوئي: $error';
  }

  @override
  String get noImageSaved => 'لم يتم حفظ أي صورة. حاولي مرة أخرى.';

  @override
  String get noDataExtracted => 'لم يتم استخراج بيانات';

  @override
  String get ocrNoResultsPrompt =>
      'تعذّر استخراج النتائج. هل ترغبين في:\n\n1. حفظ الصورة فقط للرجوع إليها\n2. إدخال البيانات يدوياً';

  @override
  String get labReport => 'تقرير التحليل';

  @override
  String get imageSavedAddLater =>
      'تم حفظ الصورة! يمكنك إضافة التفاصيل لاحقاً.';

  @override
  String get saveImageOnly => 'حفظ الصورة فقط';

  @override
  String get enterManually => 'إدخال يدوي';

  @override
  String get labResultsSaved => 'تم حفظ التحاليل بنجاح!';

  @override
  String get extractLabResults => 'استخراج التحاليل';

  @override
  String get extractingText => 'جارٍ استخراج النص من الصورة...';

  @override
  String get extractedResults => 'النتائج المستخرجة';

  @override
  String get noLabResultsDetected =>
      'لم يتم اكتشاف نتائج. يمكنك إضافتها يدوياً.';

  @override
  String get viewRawText => 'عرض النص الخام';

  @override
  String get noTextExtracted => 'لم يتم استخراج نص';

  @override
  String get saveResults => 'حفظ النتائج';

  @override
  String get cameraPermissionDenied => 'تم رفض إذن الكاميرا';

  @override
  String get photosPermissionDenied => 'تم رفض إذن الصور';

  @override
  String failedToPickImage(String error) {
    return 'تعذّر اختيار الصورة: $error';
  }

  @override
  String failedToPickPdf(String error) {
    return 'تعذّر اختيار ملف PDF: $error';
  }

  @override
  String get takePhoto => 'التقاط صورة';

  @override
  String get takePhotoDesc => 'استخدمي الكاميرا لالتقاط نتيجة التحليل';

  @override
  String get chooseFromGallery => 'اختيار من المعرض';

  @override
  String get chooseFromGalleryDesc => 'اختاري صورة موجودة';

  @override
  String get uploadPdf => 'رفع ملف PDF';

  @override
  String get uploadPdfDesc => 'اختاري تقرير PDF';

  @override
  String get manualEntryTitle => 'إدخال يدوي';

  @override
  String get manualEntryDesc => 'أدخلي النتائج يدوياً';

  @override
  String get viewAllMeasurements => 'عرض جميع القياسات';

  @override
  String minutesAgo(int minutes) {
    return 'منذ $minutes دقيقة';
  }

  @override
  String get pleaseEnterAppointmentName => 'يرجى إدخال اسم الموعد';

  @override
  String get pleaseSelectDate => 'يرجى اختيار تاريخ';

  @override
  String get pleaseSelectTime => 'يرجى اختيار وقت';

  @override
  String get pleaseEnterMedicationName => 'يرجى إدخال اسم الدواء';

  @override
  String get pleaseSelectForm => 'يرجى اختيار الشكل';

  @override
  String get pleaseSelectStartDate => 'يرجى اختيار تاريخ البدء';

  @override
  String get notAuthenticated => 'غير مُسجّل الدخول';

  @override
  String get stillHaveQuestions => 'هل لديك المزيد من الأسئلة؟';

  @override
  String get contactSupport => 'تواصلي مع الدعم';

  @override
  String get faqQ1 => 'كيف أضبط تذكيرات المواعيد؟';

  @override
  String get faqA1 =>
      'يمكنك ضبط تذكيرات المواعيد بالانتقال إلى قسم «المواعيد»، واختيار زيارتك، ثم الضغط على «ضبط تذكير». ستتمكنين من اختيار المدة (مثل يوم أو ساعة قبل الموعد).';

  @override
  String get faqQ2 => 'هل بياناتي الصحية آمنة؟';

  @override
  String get faqA2 =>
      'نعم. نستخدم تشفيراً رائداً ونلتزم بمعايير HIPAA/GDPR لضمان بقاء معلوماتك الصحية خاصة وآمنة. تُخزَّن البيانات بشكل مجهول على خوادم آمنة.';

  @override
  String get faqQ3 => 'كيف أغيّر تاريخ الولادة المتوقع؟';

  @override
  String get faqA3 =>
      'إذا كنت تتابعين حملاً، يمكنك تغيير تاريخ الولادة المتوقع من إعدادات «الملف» أو «المتابعة». اضغطي على حقل التاريخ لإدخال تاريخ جديد بناءً على آخر فحص.';

  @override
  String get faqQ4 => 'هل يمكنني تصدير سجلاتي الصحية؟';

  @override
  String get faqA4 =>
      'نعم! انتقلي إلى الإعدادات > البيانات والخصوصية > تنزيل بياناتي لتصدير جميع معلوماتك بصيغة قابلة للقراءة.';

  @override
  String get faqQ5 => 'كيف أتواصل مع الدعم؟';

  @override
  String get faqA5 =>
      'يمكنك التواصل مع الدعم عبر زر «تواصلي مع الدعم» أسفل الشاشة، أو مراسلتنا على support@appname.com. نردّ عادةً خلال 24 ساعة.';

  @override
  String get faqQ6 => 'ما اللغات المدعومة؟';

  @override
  String get faqA6 =>
      'يدعم التطبيق حالياً الإنجليزية والفرنسية والعربية. يمكنك تغيير لغتك من قائمة «الإعدادات».';

  @override
  String get aboutDescription =>
      'رفيقك الموثوق خلال الحمل والأمومة. تابعي رحلتك، واحصلي على رؤى مخصصة، وتواصلي مع مجتمع داعم.';

  @override
  String get activeUsers => 'المستخدمات النشطات';

  @override
  String get appRating => 'تقييم التطبيق';

  @override
  String get versionInfo => 'معلومات الإصدار';

  @override
  String get madeWithLove => 'صُنع بحب';

  @override
  String get madeWithLoveSub => 'لكل الأمهات';

  @override
  String get copyrightNotice => '© 2025 MomCare. جميع الحقوق محفوظة.';

  @override
  String get privacyMatters => 'خصوصيتك تهمنا';

  @override
  String get privacyMattersDesc =>
      'نلتزم بحماية معلوماتك الشخصية وبالشفافية حول كيفية استخدام بياناتك.';

  @override
  String get privacyLastUpdated => 'آخر تحديث: 4 ديسمبر 2025';

  @override
  String get dataCollection => 'جمع البيانات';

  @override
  String get dataCollectionContent =>
      'نجمع فقط المعلومات الأساسية اللازمة لتقديم أفضل تجربة متابعة صحية، وتشمل بيانات ملفك ومؤشراتك الصحية واستخدامك للتطبيق.';

  @override
  String get dataSecurity => 'أمان البيانات';

  @override
  String get dataSecurityContent =>
      'تُشفَّر بياناتك وفق بروتوكولات قياسية. نستخدم طبقات حماية متعددة لحماية معلوماتك الصحية من الوصول غير المصرّح به.';

  @override
  String get dataUsage => 'استخدام البيانات';

  @override
  String get dataUsageContent =>
      'نستخدم بياناتك لتخصيص تجربتك وتقديم رؤى صحية مناسبة والتحسين المستمر. لا نبيع البيانات الشخصية لأي طرف ثالث.';

  @override
  String get yourRights => 'حقوقك';

  @override
  String get yourRightsContent =>
      'لديك الحق في الوصول إلى بياناتك أو تحديثها أو طلب حذفها. يمكنك إدارة إعدادات الخصوصية داخل التطبيق أو التواصل مع الدعم.';

  @override
  String get fillAllFields => 'يرجى ملء جميع الحقول';

  @override
  String get welcomeBack => 'مرحباً بعودتك';

  @override
  String get loginToContinue => 'سجّلي الدخول لمواصلة رحلتك';

  @override
  String get fillRequiredFields => 'يرجى ملء الحقول المطلوبة';

  @override
  String get mustAgreeTerms => 'يجب الموافقة على الشروط وسياسة الخصوصية';

  @override
  String get startJourneyToday => 'ابدئي رحلتك معنا اليوم';

  @override
  String get mustBe8Chars => 'يجب أن تكون 8 أحرف على الأقل';

  @override
  String get iAgreeTo => 'أوافق على ';

  @override
  String get termsConditions => 'الشروط والأحكام';

  @override
  String get alreadyHaveAccount => 'لديك حساب بالفعل؟ ';

  @override
  String get signIn => 'تسجيل الدخول';

  @override
  String get tellUsAboutYou => 'أخبرينا عن نفسك';

  @override
  String get helpPersonalize => 'ساعدينا في تخصيص تجربتك';

  @override
  String get howFarAlong => 'في أي مرحلة أنت؟';

  @override
  String couldNotSavePregnancy(String error) {
    return 'تعذّر حفظ الحمل: $error';
  }

  @override
  String get wellCalculateDueDate => 'سنحسب تاريخ ولادتك المتوقع';

  @override
  String get completeSetup => 'إكمال الإعداد';

  @override
  String get canUpdateAnytime => 'يمكنك تحديث هذه المعلومات في أي وقت';

  @override
  String get byWeeks => 'حسب الأسابيع';

  @override
  String get byDate => 'حسب التاريخ';

  @override
  String get youAre => 'أنت';

  @override
  String get selectWeeks => 'اختاري الأسابيع';

  @override
  String weekShort(int n) {
    return 'الأسبوع $n';
  }

  @override
  String get pickFirstDayLastPeriod => 'اختاري أول يوم من آخر دورة شهرية';

  @override
  String get additionalDays => 'أيام إضافية';

  @override
  String get tellAboutBaby => 'أخبرينا عن طفلك';

  @override
  String get tellAboutBabyMultiline => 'أخبرينا عن\nطفلك';

  @override
  String get pleasePickBirthDate => 'يرجى اختيار تاريخ ميلاد طفلك';

  @override
  String couldNotSaveBaby(String error) {
    return 'تعذّر حفظ بيانات الطفل: $error';
  }

  @override
  String get helpPersonalizedCare => 'ساعدينا في تقديم رعاية مخصصة';

  @override
  String get babysName => 'اسم الطفل';

  @override
  String get babysGender => 'جنس الطفل';

  @override
  String get girlLabel => 'بنت';

  @override
  String get boyLabel => 'ولد';

  @override
  String get babysBirthDate => 'تاريخ ميلاد الطفل';

  @override
  String get pickADate => 'اختاري تاريخاً';

  @override
  String get continueToDashboard => 'المتابعة إلى لوحة التحكم';

  @override
  String get infoKeptPrivate => 'تبقى جميع المعلومات خاصة وآمنة';

  @override
  String get whatBestDescribes => 'ما الذي يصفك بشكل أفضل';

  @override
  String get imPregnant => 'أنا حامل';

  @override
  String get pregnantOptionDesc =>
      'تابعي رحلة حملك، واحصلي على رؤى أسبوعية، واستعدّي لطفلك';

  @override
  String get iHaveBaby => 'لديّ طفل';

  @override
  String get babyOptionDesc =>
      'رعاية ما بعد الولادة، وتتبّع نمو الطفل، ودعم الأبوة';

  @override
  String get canChangeAnytime =>
      'لا تقلقي، يمكنك تغيير ذلك في أي وقت من الإعدادات';

  @override
  String get obTrack => 'تابعي';

  @override
  String get obYourJourney => 'رحلتك';

  @override
  String get obDesc1 => 'راقبي حملك أسبوعاً بأسبوع مع نصائح ورؤى مخصصة';

  @override
  String get obBabyGrowth => 'نمو الطفل';

  @override
  String get obMonitor => 'راقبي';

  @override
  String get obDesc2 => 'تابعي نمو طفلك ومعالمه شهراً بشهر';

  @override
  String get obNeverMiss => 'لا تفوّتي أي';

  @override
  String get obMoment => 'لحظة';

  @override
  String get obDesc3 => 'اضبطي تذكيرات للمواعيد واللقاحات والفحوصات المهمة';

  @override
  String get obMomBaby => 'الأم والطفل';

  @override
  String get obMarketplace => 'المتجر';

  @override
  String get obDesc4 => 'تسوّقي منتجات مختارة لك ولطفلك';

  @override
  String get getStarted => 'ابدئي';

  @override
  String get next => 'التالي';

  @override
  String get everythingYouNeed =>
      'كل ما تحتاجينه للحمل ورعاية الطفل وأكثر — في مكان واحد';

  @override
  String get trackYourPregnancy => 'تابعي حملك';

  @override
  String get weekByWeekInsights => 'رؤى أسبوعية';

  @override
  String get healthAppointments => 'الصحة والمواعيد';

  @override
  String get neverMissCheckup => 'لا تفوّتي أي فحص';

  @override
  String get communitySupport => 'دعم المجتمع';

  @override
  String get connectWithOthers => 'تواصلي مع الآخرين';

  @override
  String get takesLessMinute => 'يستغرق أقل من دقيقة';

  @override
  String get yourJourneyOurSupport => 'رحلتك،\nدعمنا';

  @override
  String get letsGetStarted => 'لنبدأ';

  @override
  String get appTagline => 'رحلتك، رعايتنا';

  @override
  String get loadingExperience => 'جارٍ تحميل تجربتك...';

  @override
  String get weeksUnit => 'أسابيع';

  @override
  String get navHome => 'الرئيسية';

  @override
  String get navTrack => 'المتابعة';

  @override
  String get navHealth => 'الصحة';

  @override
  String get navPlan => 'التخطيط';

  @override
  String get navMarket => 'المتجر';
}
