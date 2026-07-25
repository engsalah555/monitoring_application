import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../surveillance_system/domain/entities/branch.dart';

/// Registered Enterprise Branch & NVR Connection Info Tile.
class NvrBranchTile extends StatelessWidget {
  final Branch branch;
  final VoidCallback onTap;

  const NvrBranchTile({
    super.key,
    required this.branch,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final nvr = branch.nvrDevice;

    return Container(
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.panelLine)),
      ),
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
        leading: Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: AppColors.panelRaised,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppColors.panelLine),
          ),
          child: Icon(nvr.brand.icon, color: AppColors.cyan, size: 20),
        ),
        title: Text(
          branch.name,
          style: AppTypography.cairoBold(
            fontSize: 12.5,
            color: AppColors.textPrimary,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 2),
            Text(
              '${nvr.brand.label} · ${nvr.ipAddress}:${nvr.port}',
              style: AppTypography.monoRegular(
                fontSize: 10.5,
                color: AppColors.textSecondary,
              ),
            ),
            Text(
              '${branch.categoryType} · ${branch.camerasCount} قناة/كاميرا',
              style: AppTypography.cairoRegular(
                fontSize: 10,
                color: AppColors.textTertiary,
              ),
            ),
          ],
        ),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: AppColors.cyanDim,
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: AppColors.cyan),
          ),
          child: Text(
            'متصل',
            style: AppTypography.cairoBold(
              fontSize: 10,
              color: AppColors.cyan,
            ),
          ),
        ),
      ),
    );
  }
}
