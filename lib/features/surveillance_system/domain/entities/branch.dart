import 'nvr_device.dart';
import 'site_category_type.dart';

/// Immutable domain entity representing a surveillance site / branch (Home, Store, Warehouse, Mall, etc.).
class Branch {
  final String id;
  final String name;
  final String categoryType; // e.g. Home, Store, Warehouse, Mall
  final String location;
  final NvrDevice nvrDevice;
  final int camerasCount;
  final SiteCategoryType siteType;

  const Branch({
    required this.id,
    required this.name,
    required this.categoryType,
    required this.location,
    required this.nvrDevice,
    required this.camerasCount,
    SiteCategoryType? siteType,
  }) : siteType = siteType ?? SiteCategoryType.custom;
}

