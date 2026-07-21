import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../models/camera_model.dart';
import '../state/aegis_provider.dart';
import '../theme/app_colors.dart';

/// Screen 2: Hierarchy and Asset locations list screen.
class HierarchyScreen extends StatefulWidget {
  const HierarchyScreen({super.key});

  @override
  State<HierarchyScreen> createState() => _HierarchyScreenState();
}

class _HierarchyScreenState extends State<HierarchyScreen> {
  int _segmentedIndex = 0; // 0: Cam List, 1: Floor Map

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AegisProvider>(context);
    final primaryColor = AppColors.getPrimary(provider.isEmergency);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Breadcrumb Navigation Bar
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Row(
            children: [
              Text(
                'المجمعات › مول وسط المدينة › الطابق ٢ › ',
                style: GoogleFonts.cairo(
                  color: AppColors.textTertiary,
                  fontSize: 11,
                ),
              ),
              Text(
                'المنطقة ب',
                style: GoogleFonts.cairo(
                  color: primaryColor,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),

        // Section Title Header
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          decoration: const BoxDecoration(
            border: Border(
              bottom: BorderSide(color: AppColors.panelLine),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'المنطقة ب — صالة المطاعم',
                style: GoogleFonts.cairo(
                  color: AppColors.textPrimary,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                '١٤ كاميرا نشطة · ٢ متوقفة · تحديث فوري',
                style: GoogleFonts.cairo(
                  color: AppColors.textSecondary,
                  fontSize: 11.5,
                ),
              ),
            ],
          ),
        ),

        // Segmented Control (Camera List vs Floor Map)
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          padding: const EdgeInsets.all(3),
          decoration: BoxDecoration(
            color: AppColors.panel,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppColors.panelLine),
          ),
          child: Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () => setState(() => _segmentedIndex = 0),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      color: _segmentedIndex == 0
                          ? AppColors.panelRaised
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'قائمة الكاميرات',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.cairo(
                        color: _segmentedIndex == 0
                            ? primaryColor
                            : AppColors.textSecondary,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () => setState(() => _segmentedIndex = 1),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      color: _segmentedIndex == 1
                          ? AppColors.panelRaised
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'خريطة الطابق',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.cairo(
                        color: _segmentedIndex == 1
                            ? primaryColor
                            : AppColors.textSecondary,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

        // Content Area
        Expanded(
          child: _segmentedIndex == 0
              ? ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  children: [
                    _buildCamRow(
                      name: 'كاميرا ١٤ — المدخل الشمالي',
                      statusText: 'بث مباشر · بدقة 1080p',
                      statusColor: AppColors.cyan,
                      isLive: true,
                      onTap: () => provider.setSelectedTab(AppTab.liveSingle),
                    ),
                    _buildCamRow(
                      name: 'كاميرا ١٥ — منطقة العائلات',
                      statusText: 'بث مباشر · بدقة 1080p',
                      statusColor: AppColors.cyan,
                      isLive: true,
                      onTap: () => provider.setSelectedTab(AppTab.liveSingle),
                    ),
                    _buildCamRow(
                      name: 'كاميرا ١٦ — ممر الخدمات خلفي',
                      statusText: 'غير متصل · منذ ساعتين',
                      statusColor: AppColors.textTertiary,
                      isOffline: true,
                      onTap: () => provider.setSelectedTab(AppTab.liveSingle),
                    ),
                    _buildCamRow(
                      name: 'كاميرا ١٧ — بوابة الشحن والتفريغ',
                      statusText: provider.isEmergency
                          ? 'اختراق أمني · كشف حركة'
                          : 'بث مباشر · بدقة 4K',
                      statusColor: provider.isEmergency
                          ? AppColors.red
                          : AppColors.amber,
                      isAlert: true,
                      onTap: () => provider.setSelectedTab(AppTab.liveSingle),
                    ),
                    _buildCamRow(
                      name: 'كاميرا ١٨ — السلم الكهربائي الغربي',
                      statusText: 'بث مباشر · بدقة 1080p',
                      statusColor: AppColors.cyan,
                      isLive: true,
                      onTap: () => provider.setSelectedTab(AppTab.liveSingle),
                    ),
                  ],
                )
              : Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.map_outlined,
                          color: primaryColor, size: 48),
                      const SizedBox(height: 12),
                      Text(
                        'خريطة الطابق التفاعلية — interactive floor map',
                        style: GoogleFonts.cairo(
                          color: AppColors.textSecondary,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
        ),
      ],
    );
  }

  Widget _buildCamRow({
    required String name,
    required String statusText,
    required Color statusColor,
    bool isLive = false,
    bool isOffline = false,
    bool isAlert = false,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.panelLine)),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(vertical: 4),
        onTap: onTap,
        leading: Container(
          width: 60,
          height: 45,
          decoration: BoxDecoration(
            color: isOffline ? AppColors.bgPage : AppColors.panelRaised,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppColors.panelLine),
          ),
          child: Center(
            child: Icon(
              isOffline ? Icons.videocam_off : Icons.videocam,
              color: statusColor,
              size: 20,
            ),
          ),
        ),
        title: Text(
          name,
          style: GoogleFonts.cairo(
            color: AppColors.textPrimary,
            fontSize: 12.5,
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Row(
          children: [
            Container(
              width: 6,
              height: 6,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: statusColor,
                boxShadow: isOffline
                    ? []
                    : [
                        BoxShadow(
                          color: statusColor.withValues(alpha: 0.8),
                          blurRadius: 4,
                        )
                      ],
              ),
            ),
            const SizedBox(width: 6),
            Text(
              statusText,
              style: GoogleFonts.cairo(
                color: AppColors.textSecondary,
                fontSize: 10.5,
              ),
            ),
          ],
        ),
        trailing: const Icon(Icons.chevron_left,
            color: AppColors.textTertiary, size: 20),
      ),
    );
  }
}
