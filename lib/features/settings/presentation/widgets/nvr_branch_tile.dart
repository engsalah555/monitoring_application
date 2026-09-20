import 'package:flutter/material.dart';
import '../../../../core/theme/app_palette.dart';
import '../../../../core/widgets/layout/executive_list_tile.dart';
import '../../../surveillance_system/domain/entities/branch.dart';

/// Registered Enterprise Branch & NVR Connection Info Tile built on ExecutiveListTile.
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

    return ExecutiveListTile(
      title: branch.name,
      subtitle: '${nvr.brand.label} · ${nvr.ipAddress}:${nvr.port}\n${branch.categoryType} · ${branch.camerasCount} قناة/كاميرا',
      onTap: onTap,
      margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      leading: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: AppPalette.primary.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppPalette.primary.withValues(alpha: 0.3)),
        ),
        child: Icon(nvr.brand.icon, color: AppPalette.primary, size: 22),
      ),
      trailing: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: AppPalette.emeraldLive.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppPalette.emeraldLive.withValues(alpha: 0.5)),
        ),
        child: const Text(
          'متصل',
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.bold,
            color: AppPalette.emeraldLive,
            fontFamily: 'Cairo',
          ),
        ),
      ),
    );
  }
}
