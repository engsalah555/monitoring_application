import 'package:flutter/material.dart';

/// Navigation tabs available in AEGIS Command Center.
enum AppTab {
  command(label: 'القيادة', icon: Icons.dashboard_outlined, activeIcon: Icons.dashboard),
  hierarchy(label: 'الأصول', icon: Icons.account_tree_outlined, activeIcon: Icons.account_tree),
  liveSingle(label: 'المراقبة', icon: Icons.videocam_outlined, activeIcon: Icons.videocam),
  multiGrid(label: 'الشبكة', icon: Icons.grid_view_outlined, activeIcon: Icons.grid_view),
  archive(label: 'الأرشيف', icon: Icons.history_outlined, activeIcon: Icons.history);

  final String label;
  final IconData icon;
  final IconData activeIcon;

  const AppTab({
    required this.label,
    required this.icon,
    required this.activeIcon,
  });
}

/// Camera status states.
enum CameraStatus {
  live,
  offline,
  alert,
}

/// Model representing a camera node in the AEGIS surveillance network.
class CameraModel {
  final String id;
  final String name;
  final String resolution;
  final CameraStatus status;
  final String location;
  final bool isFavorite;

  const CameraModel({
    required this.id,
    required this.name,
    required this.resolution,
    required this.status,
    required this.location,
    this.isFavorite = false,
  });
}

/// Model for asset categories (Malls, Warehouses, Outlets).
class AssetCategoryModel {
  final String title;
  final String metaText;
  final int branchesCount;
  final int camerasCount;

  const AssetCategoryModel({
    required this.title,
    required this.metaText,
    required this.branchesCount,
    required this.camerasCount,
  });
}
