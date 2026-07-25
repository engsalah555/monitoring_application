/// Centralized string constants for AEGIS Command Center.
class AppStrings {
  const AppStrings._();

  static const String appTitle = 'أيجيس — غرفة القيادة والسيطرة التنفيذية';
  static const String brandTitle = 'AEGIS COMMAND';
  static const String brandSubtitle = 'غرفة القيادة والسيطرة';

  // Greeting & Status
  static const String greetingUser = 'صباح الخير، ألكسندر';
  static const String systemStatusNormal = '٢٤٧ كاميرا متصلة · النظام مستقر';
  static const String systemStatusEmergency = 'حالة طوارئ نشطة · تنبيه أمني بمستودع ٣';
  static const String alertsCountFormat = '%d تنبيهات';

  // Emergency Mode Buttons
  static const String emergencyCancel = 'إلغاء الطوارئ';
  static const String emergencySimulate = 'محاكاة الطوارئ';

  // Search & Filters
  static const String searchPlaceholder = 'ابحث عن فروع، كاميرات، أو عمالة...';
  static const String editFavorites = 'تعديل';
  static const String criticalAndFavorites = 'الحالات الحرجة والمفضلة';
  static const String assetsDistribution = 'توزيع الأصول والفروع';
  static const String totalCamerasCount = '٥١٢ كاميرا';

  // Navigation Tabs
  static const String tabCommand = 'القيادة';
  static const String tabHierarchy = 'الأصول';
  static const String tabLiveSingle = 'المراقبة';
  static const String tabMultiGrid = 'الشبكة';
  static const String tabArchive = 'الأرشيف';
  static const String tabSettings = 'الإعدادات';

  // Hierarchy Screen
  static const String hierarchyBreadcrumb = 'المجمعات › مول وسط المدينة › الطابق ٢ › ';
  static const String zoneTitle = 'المنطقة ب — صالة المطاعم';
  static const String zoneSubtitle = '١٤ كاميرا نشطة · ٢ متوقفة · تحديث فوري';
  static const String camListTab = 'قائمة الكاميرات';
  static const String floorMapTab = 'خريطة الطابق';
  static const String interactiveFloorMap = 'خريطة الطابق التفاعلية — interactive floor map';

  // Live Screen
  static const String camLocationHeader = 'مول وسط المدينة / الطابق ٢ / المنطقة ب';
  static const String camLiveTag = 'كاميرا ١٤ · مباشر';
  static const String camEmergencyTag = 'كاميرا ١٤ · طوارئ';
  static const String swipeUpArchiveHint = 'اسحب للأعلى لتصفح الأرشيف';
  static const String screenshotCaptured = 'تم التقاط لقطة الشاشة وتخزينها';
  static const String recordingStarted = 'جاري تسجيل الحدث المباشر...';
  static const String linkShared = 'تم مشاركة الرابط التصعيدي للحدَث';
  static const String ptzZoomIn = 'تقريب';

  // Grid Screen
  static const String multiStreamTitle = 'المنطقة ب · البث المتعدد';
  static const String grid4Cam = '٤ كاميرات';
  static const String grid8Cam = '٨ كاميرات';

  // Timeline / Archive Screen
  static const String archiveBadge = 'سجل ARCHIVE';
  static const String todayDate = 'اليوم · ١٣ يوليو ٢٠٢٦';
  static const String archiveRetention = 'أرشيف DVR · الاحتفاظ بالتسجيلات لمدة ٣٠ يوماً';
  static const String secBackward = '-١٥ث';
  static const String secForward = '+١٥ث';

  // Settings Screen
  static const String settingsTitle = 'إعدادات المنظومة وتكوين NVR';
  static const String settingsSubtitle = 'إدارة الأجهزة، جودة البث، وتنبيهات الأمان';
}
