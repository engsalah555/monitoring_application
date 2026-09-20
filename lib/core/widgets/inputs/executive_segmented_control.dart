import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../theme/app_palette.dart';
import '../../theme/app_typography.dart';

/// Represents a single item inside [ExecutiveSegmentedControl].
class SegmentItem<T> {
  final T value;
  final String label;
  final IconData? icon;

  const SegmentItem({
    required this.value,
    required this.label,
    this.icon,
  });
}

/// Unified, fluidly animated dark-mode segmented control for surveillance filters and tabs.
class ExecutiveSegmentedControl<T> extends StatelessWidget {
  final List<SegmentItem<T>> items;
  final T selectedValue;
  final ValueChanged<T> onValueChanged;
  final bool isExpanded;
  final EdgeInsetsGeometry padding;
  final Color? activeColor;

  const ExecutiveSegmentedControl({
    super.key,
    required this.items,
    required this.selectedValue,
    required this.onValueChanged,
    this.isExpanded = false,
    this.padding = const EdgeInsets.all(4),
    this.activeColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: AppPalette.surfaceDark,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppPalette.borderDark),
      ),
      child: isExpanded
          ? Row(
              children: items.map((item) => Expanded(child: _buildItem(item))).toList(),
            )
          : SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: items.map(_buildItem).toList(),
              ),
            ),
    );
  }

  Widget _buildItem(SegmentItem<T> item) {
    final isSelected = item.value == selectedValue;
    final accent = activeColor ?? AppPalette.primary;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2),
      child: GestureDetector(
        onTap: () {
          if (!isSelected) {
            HapticFeedback.selectionClick();
            onValueChanged(item.value);
          }
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOutCubic,
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            gradient: isSelected
                ? (activeColor != null
                    ? LinearGradient(colors: [accent, accent.withValues(alpha: 0.8)])
                    : AppPalette.violetGradient)
                : null,
            color: isSelected ? null : Colors.transparent,
            borderRadius: BorderRadius.circular(16),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: accent.withValues(alpha: 0.35),
                      blurRadius: 10,
                      offset: const Offset(0, 3),
                    ),
                  ]
                : null,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (item.icon != null) ...[
                Icon(
                  item.icon,
                  size: 14,
                  color: isSelected ? Colors.white : AppPalette.textLightMuted,
                ),
                const SizedBox(width: 6),
              ],
              Text(
                item.label,
                style: AppTypography.cairoBold(
                  fontSize: 11,
                  color: isSelected ? Colors.white : AppPalette.textLightSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
