import 'package:flutter_test/flutter_test.dart';
import 'package:monitoring_application/features/surveillance_system/data/repositories/mock_surveillance_repository.dart';
import 'package:monitoring_application/features/surveillance_system/domain/entities/branch.dart';
import 'package:monitoring_application/features/surveillance_system/domain/entities/camera_status.dart';
import 'package:monitoring_application/features/surveillance_system/domain/entities/nvr_brand.dart';
import 'package:monitoring_application/features/surveillance_system/domain/entities/nvr_device.dart';

void main() {
  group('MockSurveillanceRepository Unit Tests', () {
    late MockSurveillanceRepository repository;

    setUp(() {
      repository = const MockSurveillanceRepository();
    });

    test('getFavoriteCameras returns list of favorited cameras', () async {
      final cameras = await repository.getFavoriteCameras();

      expect(cameras, isNotEmpty);
      expect(cameras.length, equals(4));
      expect(cameras.first.id, equals('CAM-14'));
      expect(cameras.every((c) => c.isFavorite), isTrue);
    });

    test('getZoneCameras returns cameras for target zone', () async {
      final zoneCameras = await repository.getZoneCameras('ZONE-B');

      expect(zoneCameras, isNotEmpty);
      expect(zoneCameras.length, equals(5));
      expect(zoneCameras.any((c) => c.status == CameraStatus.alert), isTrue);
    });

    test('getAssetCategories returns distribution categories', () async {
      final categories = await repository.getAssetCategories();

      expect(categories, isNotEmpty);
      expect(categories.length, equals(3));
      expect(categories.first.branchesCount, equals(12));
    });

    test('getBranches returns registered enterprise branches', () async {
      final branches = await repository.getBranches();

      expect(branches, isNotEmpty);
      expect(branches.any((b) => b.nvrDevice.brand == NvrBrand.hikvision), isTrue);
      expect(branches.any((b) => b.nvrDevice.brand == NvrBrand.dahua), isTrue);
    });

    test('addBranch registers a new branch and NVR device', () async {
      const newBranch = Branch(
        id: 'BR-TEST',
        name: 'فرع تجريبي جديد',
        categoryType: 'المجمعات التجارية',
        location: 'الرياض',
        camerasCount: 16,
        nvrDevice: NvrDevice(
          id: 'NVR-TEST',
          brand: NvrBrand.onvif,
          ipAddress: '192.168.1.200',
          port: 554,
          username: 'admin',
          password: 'pass',
          channelsCount: 16,
        ),
      );

      await repository.addBranch(newBranch);
      final branches = await repository.getBranches();

      expect(branches.any((b) => b.id == 'BR-TEST'), isTrue);
    });
  });
}
