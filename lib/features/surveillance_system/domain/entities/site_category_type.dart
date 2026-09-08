import 'package:flutter/material.dart';

/// Supported surveillance site categories for universal flexibility.
enum SiteCategoryType {
  all(
    id: 'all',
    label: 'الكل',
    icon: Icons.grid_view_rounded,
    badgeColor: Color(0xFF4F63F6),
  ),
  home(
    id: 'home',
    label: 'المنازل والفلل',
    icon: Icons.home_outlined,
    badgeColor: Color(0xFF10B981),
  ),
  store(
    id: 'store',
    label: 'المتاجر والمحلات',
    icon: Icons.store_mall_directory_outlined,
    badgeColor: Color(0xFFF59E0B),
  ),
  warehouse(
    id: 'warehouse',
    label: 'المستودعات والمخازن',
    icon: Icons.inventory_2_outlined,
    badgeColor: Color(0xFF8B5CF6),
  ),
  mall(
    id: 'mall',
    label: 'المجمعات والمولات',
    icon: Icons.apartment_outlined,
    badgeColor: Color(0xFF06B6D4),
  ),
  custom(
    id: 'custom',
    label: 'مواقع مخصصة',
    icon: Icons.cell_tower_outlined,
    badgeColor: Color(0xFFEC4899),
  );

  final String id;
  final String label;
  final IconData icon;
  final Color badgeColor;

  const SiteCategoryType({
    required this.id,
    required this.label,
    required this.icon,
    required this.badgeColor,
  });

  static SiteCategoryType fromString(String categoryStr) {
    if (categoryStr.contains('منزل') || categoryStr.contains('فيلا') || categoryStr == 'home') {
      return SiteCategoryType.home;
    }
    if (categoryStr.contains('متجر') || categoryStr.contains('محل') || categoryStr == 'store') {
      return SiteCategoryType.store;
    }
    if (categoryStr.contains('مستودع') || categoryStr.contains('مخزن') || categoryStr == 'warehouse') {
      return SiteCategoryType.warehouse;
    }
    if (categoryStr.contains('مجمع') || categoryStr.contains('مول') || categoryStr == 'mall') {
      return SiteCategoryType.mall;
    }
    return SiteCategoryType.custom;
  }
}
