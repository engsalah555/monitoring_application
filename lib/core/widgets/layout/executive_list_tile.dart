import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../theme/app_palette.dart';
import '../../theme/app_typography.dart';

/// Standardized high-performance executive list tile for cameras, branches, categories, and events.
class ExecutiveListTile extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Widget? leading;
  final Widget? trailing;
  final VoidCallback? onTap;
  final bool showDivider;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;

  const ExecutiveListTile({
    super.key,
    required this.title,
    this.subtitle,
    this.leading,
    this.trailing,
    this.onTap,
    this.showDivider = false,
    this.margin,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin ?? const EdgeInsets.only(bottom: 10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          InkWell(
            onTap: onTap != null
                ? () {
                    HapticFeedback.lightImpact();
                    onTap!();
                  }
                : null,
            borderRadius: BorderRadius.circular(18),
            child: Container(
              padding: padding ?? const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              decoration: BoxDecoration(
                color: AppPalette.cardDark,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: AppPalette.borderDark),
              ),
              child: Row(
                children: [
                  if (leading != null) ...[
                    leading!,
                    const SizedBox(width: 12),
                  ],
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTypography.cairoBold(
                            fontSize: 13,
                            color: Colors.white,
                          ),
                        ),
                        if (subtitle != null) ...[
                          const SizedBox(height: 2),
                          Text(
                            subtitle!,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: AppTypography.cairoRegular(
                              fontSize: 11,
                              color: AppPalette.textLightMuted,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  if (trailing != null) ...[
                    const SizedBox(width: 10),
                    trailing!,
                  ],
                ],
              ),
            ),
          ),
          if (showDivider)
            const Divider(height: 1, color: AppPalette.borderDark),
        ],
      ),
    );
  }
}
