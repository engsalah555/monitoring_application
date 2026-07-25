import 'nvr_device.dart';

/// Immutable domain entity representing a enterprise business branch facility.
class Branch {
  final String id;
  final String name;
  final String categoryType; // e.g. Mall, Warehouse, Outlet, Company HQ
  final String location;
  final NvrDevice nvrDevice;
  final int camerasCount;

  const Branch({
    required this.id,
    required this.name,
    required this.categoryType,
    required this.location,
    required this.nvrDevice,
    required this.camerasCount,
  });
}
