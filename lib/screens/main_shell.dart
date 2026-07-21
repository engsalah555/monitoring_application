import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../models/camera_model.dart';
import '../state/aegis_provider.dart';
import '../theme/app_colors.dart';
import 'command_center_screen.dart';
import 'hierarchy_screen.dart';
import 'live_single_view_screen.dart';
import 'multi_view_grid_screen.dart';
import 'timeline_screen.dart';

/// Shell container for AEGIS Command Center managing top header status and bottom navigation bar.
class MainShellScreen extends StatelessWidget {
  const MainShellScreen({super.key});

  static const List<Widget> _screens = [
    CommandCenterScreen(),
    HierarchyScreen(),
    LiveSingleViewScreen(),
    MultiViewGridScreen(),
    TimelineScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AegisProvider>(context);
    final primaryColor = AppColors.getPrimary(provider.isEmergency);

    return Scaffold(
      backgroundColor: AppColors.bgPage,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(66),
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.panel.withValues(alpha: 0.85),
            border: const Border(
              bottom: BorderSide(color: AppColors.panelLine, width: 1.5),
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          child: SafeArea(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Executive Logo & Subtitle
                Row(
                  children: [
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        gradient: LinearGradient(
                          colors: [
                            primaryColor,
                            const Color(0xFF1B4B5C),
                          ],
                        ),
                      ),
                      child: Center(
                        child: Text(
                          'A',
                          style: GoogleFonts.cairo(
                            color: Colors.black,
                            fontWeight: FontWeight.w900,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'AEGIS COMMAND',
                          style: GoogleFonts.cairo(
                            color: AppColors.textPrimary,
                            fontSize: 13,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        Text(
                          'غرفة القيادة والسيطرة',
                          style: GoogleFonts.cairo(
                            color: AppColors.textSecondary,
                            fontSize: 9.5,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                // Executive Header Actions & Emergency Mode Trigger
                Row(
                  children: [
                    // Alerts Counter Badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: provider.isEmergency
                            ? AppColors.redDim
                            : AppColors.amberDim,
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(
                          color: provider.isEmergency
                              ? AppColors.red
                              : AppColors.amber,
                        ),
                      ),
                      child: Text(
                        '${provider.alertCount} تنبيهات',
                        style: GoogleFonts.cairo(
                          color: provider.isEmergency
                              ? AppColors.red
                              : AppColors.amber,
                          fontSize: 10.5,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),

                    // Toggle Emergency Mode Button
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: provider.isEmergency
                            ? AppColors.redDim
                            : AppColors.panelRaised,
                        foregroundColor: provider.isEmergency
                            ? Colors.white
                            : AppColors.textPrimary,
                        side: BorderSide(
                          color: provider.isEmergency
                              ? AppColors.red
                              : AppColors.panelLine,
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 6),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        elevation: 0,
                      ),
                      onPressed: () => provider.toggleEmergencyMode(),
                      child: Text(
                        provider.isEmergency
                            ? 'إلغاء الطوارئ'
                            : 'محاكاة الطوارئ',
                        style: GoogleFonts.cairo(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),

      // Screen Body Stack
      body: IndexedStack(
        index: provider.selectedTabIndex,
        children: _screens,
      ),

      // Bottom Navigation Bar generated strongly-typed from AppTab enum
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: AppColors.panel.withValues(alpha: 0.85),
          border: const Border(
            top: BorderSide(color: AppColors.panelLine, width: 1.5),
          ),
        ),
        child: BottomNavigationBar(
          currentIndex: provider.selectedTabIndex,
          onTap: (index) => provider.setSelectedTabIndex(index),
          backgroundColor: Colors.transparent,
          elevation: 0,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: primaryColor,
          unselectedItemColor: AppColors.textTertiary,
          selectedLabelStyle: GoogleFonts.cairo(
            fontSize: 10,
            fontWeight: FontWeight.bold,
          ),
          unselectedLabelStyle: GoogleFonts.cairo(
            fontSize: 10,
            fontWeight: FontWeight.w600,
          ),
          items: AppTab.values.map((tab) {
            return BottomNavigationBarItem(
              icon: Icon(tab.icon),
              activeIcon: Icon(tab.activeIcon),
              label: tab.label,
            );
          }).toList(),
        ),
      ),
    );
  }
}
