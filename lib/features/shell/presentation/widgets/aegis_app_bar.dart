import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_palette.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/royal/royal_badge.dart';
import '../../../../core/widgets/royal/royal_glass.dart';
import '../../../surveillance_system/domain/entities/app_tab.dart';
import '../../../surveillance_system/presentation/controllers/aegis_provider.dart';

/// Royal Executive Frosted Glass App Bar for AEGIS Command Center.
class AegisAppBar extends StatelessWidget implements PreferredSizeWidget {
  const AegisAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(74);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppPalette.bgDarkObsidian,
        boxShadow: [
          BoxShadow(
            color: Color(0x66000000),
            blurRadius: 20,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
          child: RoyalGlassContainer(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            borderRadius: 20,
            blur: 24,
            enableBlur: true,
            backgroundColor: AppPalette.surfaceDark.withValues(alpha: 0.8),
            border: Border.all(
              color: AppPalette.borderGlow,
              width: 1.2,
            ),
            child: Selector<AegisProvider, ({bool isEmergency, int alertCount})>(
              selector: (_, p) =>
                  (isEmergency: p.isEmergency, alertCount: p.alertCount),
              builder: (context, state, child) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Brand Crest & Executive Monogram
                    Row(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            gradient: state.isEmergency
                                ? AppPalette.emergencyGradient
                                : AppPalette.royalSapphireGradient,
                            borderRadius: BorderRadius.circular(13),
                            border: Border.all(
                              color: state.isEmergency
                                  ? AppPalette.crimsonAlert
                                  : AppPalette.imperialGold,
                              width: 1.2,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: (state.isEmergency
                                        ? AppPalette.crimsonAlert
                                        : AppPalette.primary)
                                    .withValues(alpha: 0.4),
                                blurRadius: 10,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: const Center(
                            child: Icon(
                              Icons.security_rounded,
                              color: Colors.white,
                              size: 22,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              children: [
                                Text(
                                  AppStrings.brandTitle,
                                  style: AppTypography.cairoBold(
                                    fontSize: 14,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 6, vertical: 1.5),
                                  decoration: BoxDecoration(
                                    color: AppPalette.imperialGold
                                        .withValues(alpha: 0.18),
                                    borderRadius: BorderRadius.circular(6),
                                    border: Border.all(
                                      color: AppPalette.imperialGold
                                          .withValues(alpha: 0.5),
                                      width: 0.8,
                                    ),
                                  ),
                                  child: Text(
                                    'PRO',
                                    style: AppTypography.monoBold(
                                      fontSize: 9,
                                      color: AppPalette.imperialGold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              AppStrings.brandSubtitle,
                              style: AppTypography.cairoRegular(
                                fontSize: 10,
                                color: AppPalette.textLightMuted,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),

                    // Royal Header Actions
                    Row(
                      children: [
                        // Live Status / Alert Badge
                        if (state.isEmergency)
                          RoyalStatusBadge.alert(count: state.alertCount)
                        else
                          RoyalStatusBadge.live(label: 'مباشر (LIVE)'),
                        const SizedBox(width: 8),

                        // Sleek Emergency Mode Switch
                        InkWell(
                          onTap: () => context
                              .read<AegisProvider>()
                              .toggleEmergencyMode(),
                          borderRadius: BorderRadius.circular(12),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 250),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 6),
                            decoration: BoxDecoration(
                              gradient: state.isEmergency
                                  ? AppPalette.emergencyGradient
                                  : null,
                              color: state.isEmergency
                                  ? null
                                  : AppPalette.cardDark.withValues(alpha: 0.8),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: state.isEmergency
                                    ? AppPalette.crimsonAlert
                                    : Colors.white.withValues(alpha: 0.15),
                                width: 1,
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  state.isEmergency
                                      ? Icons.warning_amber_rounded
                                      : Icons.shield_moon_outlined,
                                  size: 14,
                                  color: state.isEmergency
                                      ? Colors.white
                                      : AppPalette.textLightSecondary,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  state.isEmergency
                                      ? AppStrings.emergencyCancel
                                      : 'طوارئ',
                                  style: AppTypography.cairoBold(
                                    fontSize: 10.5,
                                    color: state.isEmergency
                                        ? Colors.white
                                        : AppPalette.textLightSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 6),

                        // Circular Glass Settings Button
                        Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            color: AppPalette.cardDark.withValues(alpha: 0.7),
                            borderRadius: BorderRadius.circular(11),
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.12),
                            ),
                          ),
                          child: IconButton(
                            padding: EdgeInsets.zero,
                            icon: const Icon(
                              Icons.tune_rounded,
                              color: Colors.white,
                              size: 18,
                            ),
                            onPressed: () => context
                                .read<AegisProvider>()
                                .setSelectedTab(AppTab.settings),
                            tooltip: 'إعدادات المنظومة',
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

