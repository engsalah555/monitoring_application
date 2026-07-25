import 'package:flutter/material.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';

/// Breadcrumb Navigation Header Widget for Hierarchy Screen.
class HierarchyBreadcrumb extends StatelessWidget {
  final Color primaryColor;

  const HierarchyBreadcrumb({super.key, required this.primaryColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        children: [
          Text(
            AppStrings.hierarchyBreadcrumb,
            style: AppTypography.cairoRegular(
              fontSize: 11,
              color: AppColors.textTertiary,
            ),
          ),
          Text(
            'المنطقة ب',
            style: AppTypography.cairoBold(
              fontSize: 11,
              color: primaryColor,
            ),
          ),
        ],
      ),
    );
  }
}
