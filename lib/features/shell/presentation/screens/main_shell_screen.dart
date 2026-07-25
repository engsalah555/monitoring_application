import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../command_center/presentation/screens/command_center_screen.dart';
import '../../../hierarchy/presentation/screens/hierarchy_screen.dart';
import '../../../live_surveillance/presentation/screens/live_single_view_screen.dart';
import '../../../multi_grid/presentation/screens/multi_view_grid_screen.dart';
import '../../../settings/presentation/screens/settings_screen.dart';
import '../../../surveillance_system/presentation/controllers/aegis_provider.dart';
import '../../../timeline_dvr/presentation/screens/timeline_screen.dart';
import '../widgets/aegis_app_bar.dart';
import '../widgets/aegis_bottom_nav.dart';

/// Main Application Shell Screen managing top app bar, animated tab transitions, and floating dock.
class MainShellScreen extends StatelessWidget {
  const MainShellScreen({super.key});

  static const List<Widget> _screens = [
    CommandCenterScreen(key: ValueKey('command')),
    HierarchyScreen(key: ValueKey('hierarchy')),
    LiveSingleViewScreen(key: ValueKey('liveSingle')),
    MultiViewGridScreen(key: ValueKey('multiGrid')),
    TimelineScreen(key: ValueKey('archive')),
    SettingsScreen(key: ValueKey('settings')),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgPage,
      appBar: const AegisAppBar(),
      body: Selector<AegisProvider, int>(
        selector: (_, p) => p.selectedTabIndex,
        builder: (context, activeIndex, child) {
          final safeIndex = activeIndex.clamp(0, _screens.length - 1);
          return AnimatedSwitcher(
            duration: const Duration(milliseconds: 320),
            reverseDuration: const Duration(milliseconds: 250),
            switchInCurve: Curves.easeInOutCubic,
            switchOutCurve: Curves.easeInCubic,
            transitionBuilder: (child, animation) {
              return FadeTransition(
                opacity: animation,
                child: ScaleTransition(
                  scale: Tween<double>(begin: 0.96, end: 1.0).animate(animation),
                  child: child,
                ),
              );
            },
            child: _screens[safeIndex],
          );
        },
      ),
      bottomNavigationBar: const AegisBottomNav(),
    );
  }
}
