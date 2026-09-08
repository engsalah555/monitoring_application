import '../../domain/entities/asset_category.dart';
import '../../domain/entities/branch.dart';
import '../../domain/entities/camera_node.dart';
import '../../domain/entities/camera_status.dart';
import '../../domain/entities/nvr_brand.dart';
import '../../domain/entities/nvr_device.dart';
import '../../domain/repositories/i_surveillance_repository.dart';

import '../../domain/entities/site_category_type.dart';

/// Mock implementation of [ISurveillanceRepository] supporting dynamic branch addition.
class MockSurveillanceRepository implements ISurveillanceRepository {
  static final List<Branch> _mockBranches = [
    const Branch(
      id: 'BR-HOME-01',
      name: 'كاميرات المنزل والفيلا',
      categoryType: 'المنازل والفلل',
      siteType: SiteCategoryType.home,
      location: 'الرياض — حي النخيل',
      camerasCount: 8,
      nvrDevice: NvrDevice(
        id: 'NVR-EZVIZ-01',
        brand: NvrBrand.ezviz,
        ipAddress: '192.168.1.50',
        port: 554,
        username: 'home_admin',
        password: '***',
        channelsCount: 8,
      ),
    ),
    const Branch(
      id: 'BR-STORE-01',
      name: 'متجر السعادة للتجزئة',
      categoryType: 'المتاجر والمحلات',
      siteType: SiteCategoryType.store,
      location: 'جدة — شارع التحلية',
      camerasCount: 12,
      nvrDevice: NvrDevice(
        id: 'NVR-DAHUA-01',
        brand: NvrBrand.dahua,
        ipAddress: '192.168.2.80',
        port: 554,
        username: 'store_owner',
        password: '***',
        channelsCount: 16,
      ),
    ),
    const Branch(
      id: 'BR-WH-01',
      name: 'مستودع الميناء الرئيسي',
      categoryType: 'المستودعات والمخازن',
      siteType: SiteCategoryType.warehouse,
      location: 'الدمام — المنطقة الصناعية',
      camerasCount: 24,
      nvrDevice: NvrDevice(
        id: 'NVR-DAHUA-02',
        brand: NvrBrand.dahua,
        ipAddress: '10.0.4.50',
        port: 554,
        username: 'admin',
        password: '***',
        channelsCount: 32,
      ),
    ),
    const Branch(
      id: 'BR-MALL-01',
      name: 'فرع مول وسط المدينة',
      categoryType: 'المجمعات والمولات',
      siteType: SiteCategoryType.mall,
      location: 'الرياض — حي العليا',
      camerasCount: 48,
      nvrDevice: NvrDevice(
        id: 'NVR-HIK-01',
        brand: NvrBrand.hikvision,
        ipAddress: '192.168.1.100',
        port: 554,
        username: 'admin',
        password: '***',
        channelsCount: 64,
      ),
    ),
  ];

  const MockSurveillanceRepository();

  @override
  Future<List<CameraNode>> getFavoriteCameras() async {
    return const [
      CameraNode(
        id: 'CAM-14',
        name: 'خزينة الإدارة',
        resolution: '1080p',
        status: CameraStatus.live,
        location: 'المبنى الرئيسي',
        isFavorite: true,
      ),
      CameraNode(
        id: 'CAM-17',
        name: 'بوابة الشحن ٣',
        resolution: '4K',
        status: CameraStatus.alert,
        location: 'المنطقة ب',
        isFavorite: true,
      ),
      CameraNode(
        id: 'CAM-01',
        name: 'مدخل المول',
        resolution: '1080p',
        status: CameraStatus.live,
        location: 'المدخل الرئيس',
        isFavorite: true,
      ),
      CameraNode(
        id: 'CAM-08',
        name: 'الخزنة الرئيسية',
        resolution: '4K',
        status: CameraStatus.live,
        location: 'الطابق السفلي',
        isFavorite: true,
      ),
    ];
  }

  @override
  Future<List<CameraNode>> getZoneCameras(String zoneId) async {
    return const [
      CameraNode(
        id: 'CAM-14',
        name: 'كاميرا ١٤ — المدخل الشمالي',
        resolution: '1080p',
        status: CameraStatus.live,
        location: 'صالة المطاعم',
      ),
      CameraNode(
        id: 'CAM-15',
        name: 'كاميرا ١٥ — منطقة العائلات',
        resolution: '1080p',
        status: CameraStatus.live,
        location: 'صالة المطاعم',
      ),
      CameraNode(
        id: 'CAM-16',
        name: 'كاميرا ١٦ — ممر الخدمات خلفي',
        resolution: '1080p',
        status: CameraStatus.offline,
        location: 'خدمات',
      ),
      CameraNode(
        id: 'CAM-17',
        name: 'كاميرا ١٧ — بوابة الشحن والتفريغ',
        resolution: '4K',
        status: CameraStatus.alert,
        location: 'المنطقة ب',
      ),
      CameraNode(
        id: 'CAM-18',
        name: 'كاميرا ١٨ — السلم الكهربائي الغربي',
        resolution: '1080p',
        status: CameraStatus.live,
        location: 'الطابق ٢',
      ),
    ];
  }

  @override
  Future<List<AssetCategory>> getAssetCategories() async {
    final totalCameras = _mockBranches.fold<int>(
        0, (sum, branch) => sum + branch.camerasCount);

    return [
      AssetCategory(
        title: 'المجمعات التجارية (المولات)',
        subtitle: '١٢ فرعاً موزعة · ٣٤٠ كاميرا نشطة',
        branchesCount: 12,
        camerasCount: 340 + totalCameras,
      ),
      const AssetCategory(
        title: 'المستودعات والمخازن',
        subtitle: '٨ مواقع استراتيجية · ٢١٠ كاميرات',
        branchesCount: 8,
        camerasCount: 210,
      ),
      const AssetCategory(
        title: 'المتاجر ونقاط العمالة',
        subtitle: '٦٤ منفذاً · ٥١٢ كاميرا أمنية',
        branchesCount: 64,
        camerasCount: 512,
      ),
    ];
  }

  @override
  Future<List<Branch>> getBranches() async {
    return List.unmodifiable(_mockBranches);
  }

  @override
  Future<void> addBranch(Branch branch) async {
    _mockBranches.add(branch);
  }

  @override
  Future<bool> testNvrConnection(NvrDevice nvr) async {
    await Future.delayed(const Duration(milliseconds: 600));
    return nvr.ipAddress.isNotEmpty && nvr.port > 0;
  }
}
