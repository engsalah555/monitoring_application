/// Centralized consumer & business string constants for Smart CCTV Monitoring.
class AppStrings {
  const AppStrings._();

  static const String appTitle = 'كاميراتي — نظام مراقبة الكاميرات الذكي';
  static const String brandTitle = 'كاميراتي Smart CCTV';
  static const String brandSubtitle = 'مراقبة المتاجر والمنازل والمستودعات';

  // Greeting & Status
  static const String greetingUser = 'أهلاً بك، سلمان العتيبي';
  static const String systemStatusNormal = 'جميع الكاميرات متصلة وتعمل بكفاءة';
  static const String systemStatusEmergency = 'تنبيه حركة نشط في مستودع الدمام';
  static const String alertsCountFormat = '%d تنبيهات';

  // Emergency Mode Buttons
  static const String emergencyCancel = 'إلغاء التنبيه';
  static const String emergencySimulate = 'تجربة التنبيه';

  // Search & Filters
  static const String searchPlaceholder = 'ابحث عن كاميرا، موقع، أو فرع...';
  static const String editFavorites = 'تعديل المفضلة';
  static const String criticalAndFavorites = 'الكاميرات المفضلة والتنبيهات المباشرة';
  static const String assetsDistribution = 'المواقع والفروع المربوطة';
  static const String totalCamerasCount = 'المجموع: ٩٢ كاميرا';

  // Navigation Tabs
  static const String tabCommand = 'الكاميرات';
  static const String tabHierarchy = 'المواقع';
  static const String tabLiveSingle = 'البث المباشر';
  static const String tabMultiGrid = 'الشبكة';
  static const String tabArchive = 'التسجيلات';
  static const String tabSettings = 'الفريق والإعدادات';

  // Hierarchy Screen
  static const String hierarchyBreadcrumb = 'المستودعات › مستودع الدمام › البوابة ٣ › ';
  static const String zoneTitle = 'منطقة التحميل والشحن';
  static const String zoneSubtitle = '٨ كاميرات متصلة · تحديث فوري';
  static const String camListTab = 'قائمة الكاميرات';
  static const String floorMapTab = 'مخطط الموقع';
  static const String interactiveFloorMap = 'مخطط الموقع التفاعلي';

  // Live Screen
  static const String camLocationHeader = 'مستودع الدمام / منطقة الشحن والتفريغ';
  static const String camLiveTag = 'كاميرا الشحن · مباشر';
  static const String camEmergencyTag = 'كاميرا الشحن · تنبيه حركة';
  static const String swipeUpArchiveHint = 'اسحب للأعلى لتصفح التسجيلات السابقة';
  static const String screenshotCaptured = 'تم التقاط صورة من الكاميرا وتخزينها';
  static const String recordingStarted = 'جاري تسجيل مقطع الفيديو...';
  static const String linkShared = 'تم نسخ رابط مشاركة الكاميرا';
  static const String ptzZoomIn = 'تقريب';

  // Grid Screen
  static const String multiStreamTitle = 'بث شبكة الكاميرات المتعددة';
  static const String grid4Cam = '٤ كاميرات';
  static const String grid8Cam = '٨ كاميرات';

  // Timeline / Archive Screen
  static const String archiveBadge = 'التسجيلات السابقة';
  static const String todayDate = 'اليوم · 18 أغسطس 2026';
  static const String archiveRetention = 'تسجيل متواصل · حفظ حتى 30 يوماً';
  static const String secBackward = '-15ث';
  static const String secForward = '+15ث';

  // Settings Screen
  static const String settingsTitle = 'إعدادات الكاميرات والفريق (RBAC)';
  static const String settingsSubtitle = 'إدارة الأجهزة، مشاركة الكاميرات، ودعوة المدراء';
}
