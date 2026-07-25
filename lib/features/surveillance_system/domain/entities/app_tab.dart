import 'package:flutter/material.dart';
import '../../../../core/constants/app_strings.dart';

/// App navigation tabs enum.
enum AppTab {
  command(
    label: AppStrings.tabCommand,
    icon: Icons.dashboard_outlined,
    activeIcon: Icons.dashboard,
  ),
  hierarchy(
    label: AppStrings.tabHierarchy,
    icon: Icons.account_tree_outlined,
    activeIcon: Icons.account_tree,
  ),
  liveSingle(
    label: AppStrings.tabLiveSingle,
    icon: Icons.videocam_outlined,
    activeIcon: Icons.videocam,
  ),
  multiGrid(
    label: AppStrings.tabMultiGrid,
    icon: Icons.grid_view_outlined,
    activeIcon: Icons.grid_view,
  ),
  archive(
    label: AppStrings.tabArchive,
    icon: Icons.history_outlined,
    activeIcon: Icons.history,
  ),
  settings(
    label: AppStrings.tabSettings,
    icon: Icons.settings_outlined,
    activeIcon: Icons.settings,
  );

  final String label;
  final IconData icon;
  final IconData activeIcon;

  const AppTab({
    required this.label,
    required this.icon,
    required this.activeIcon,
  });
}
