// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appTitle => 'رعاية الحمل والطفل';

  @override
  String get welcome => 'أهلا وسهلا';

  @override
  String get login => 'دخول';

  @override
  String get signup => 'إنشاء حساب';

  @override
  String get email => 'البريد الإلكتروني';

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
    return '$days يوم متبقي';
  }

  @override
  String get market => 'السوق';

  @override
  String get maternityWear => 'ملابس الأمومة';

  @override
  String get painRelief => 'تخفيف الألم';

  @override
  String get skinCare => 'العناية بالبشرة';

  @override
  String get pregnancyPillow => 'وسادة الحمل';

  @override
  String get backSupportBelt => 'حزام دعم الظهر';

  @override
  String get searchHint => 'ابحث عما تحتاجه...';

  @override
  String get dontMissOut => 'لا تفوت الفرصة!';

  @override
  String get discountUpTo => 'خصم يصل إلى 50٪';

  @override
  String get upgradeNow => 'قم بالترقية الآن';

  @override
  String get healthLog => 'سجل الصحة';

  @override
  String get trackYourWellness => 'تتبع عافيتك';

  @override
  String get vitals => 'العلامات الحيوية';

  @override
  String get symptoms => 'الأعراض';

  @override
  String get labResults => 'نتائج المختبر';

  @override
  String get riskAlerts => 'تنبيهات المخاطر';

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
  String get measurement => 'قياس';

  @override
  String get healthTipMessage =>
      'عمل رائع! أنت تحافظين على وتيرة صحية لزيادة الوزن. استمري في نظامك الغذائي المتوازن وممارسة التمارين الخفيفة.';

  @override
  String get onTrack => 'على المسار الصحيح';
}
