import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../models/camera_model.dart';
import '../state/aegis_provider.dart';
import '../theme/app_colors.dart';
import '../widgets/radar_avatar_ring.dart';

/// Screen 1: Command Center executive dashboard.
class CommandCenterScreen extends StatelessWidget {
  const CommandCenterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AegisProvider>(context);
    final primaryColor = AppColors.getPrimary(provider.isEmergency);

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Executive Header Card
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.panel,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.panelLine),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'صباح الخير، ألكسندر',
                      style: GoogleFonts.cairo(
                        color: AppColors.textPrimary,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: provider.isEmergency
                                ? AppColors.red
                                : AppColors.green,
                            boxShadow: [
                              BoxShadow(
                                color: (provider.isEmergency
                                        ? AppColors.red
                                        : AppColors.green)
                                    .withValues(alpha: 0.6),
                                blurRadius: 6,
                              )
                            ],
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          provider.systemStatusText,
                          style: GoogleFonts.cairo(
                            color: AppColors.textSecondary,
                            fontSize: 11.5,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                // Avatar with Radar Glow Ring
                RadarRingWidget(
                  size: 44,
                  borderColor: primaryColor,
                  child: Container(
                    color: AppColors.panelRaised,
                    child: Center(
                      child: Text(
                        'أ ر',
                        style: GoogleFonts.cairo(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),

          // Search Field Widget
          Container(
            height: 44,
            padding: const EdgeInsets.symmetric(horizontal: 14),
            decoration: BoxDecoration(
              color: AppColors.panel.withValues(alpha: 0.6),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.panelLine),
            ),
            child: Row(
              children: [
                Icon(Icons.search, color: primaryColor, size: 18),
                const SizedBox(width: 10),
                Text(
                  'ابحث عن فروع، كاميرات، أو عمالة...',
                  style: GoogleFonts.cairo(
                    color: AppColors.textSecondary,
                    fontSize: 12.5,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Section 1: Favorites & Critical Status
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'الحالات الحرجة والمفضلة',
                style: GoogleFonts.cairo(
                  color: AppColors.textPrimary,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'تعديل',
                style: GoogleFonts.cairo(
                  color: primaryColor,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildFavItem('خزينة الإدارة', primaryColor, false, () {
                  provider.setSelectedTab(AppTab.liveSingle);
                }),
                const SizedBox(width: 14),
                _buildFavItem(
                  'بوابة الشحن ٣',
                  provider.isEmergency ? AppColors.red : AppColors.amber,
                  true,
                  () {
                    provider.setSelectedTab(AppTab.liveSingle);
                  },
                ),
                const SizedBox(width: 14),
                _buildFavItem('مدخل المول', primaryColor, false, () {
                  provider.setSelectedTab(AppTab.liveSingle);
                }),
                const SizedBox(width: 14),
                _buildFavItem('الخزنة الرئيسية', primaryColor, false, () {
                  provider.setSelectedTab(AppTab.liveSingle);
                }),
              ],
            ),
          ),
          const SizedBox(height: 26),

          // Section 2: Distributed Assets
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'توزيع الأصول والفروع',
                style: GoogleFonts.cairo(
                  color: AppColors.textPrimary,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '٥١٢ كاميرا',
                style: GoogleFonts.cairo(
                  color: primaryColor,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          _buildAssetCard(
            context: context,
            title: 'المجمعات التجارية (المولات)',
            subtitle: '١٢ فرعاً موزعة · ٣٤٠ كاميرا نشطة',
            icon: Icons.store_mall_directory_outlined,
            onTap: () => provider.setSelectedTab(AppTab.hierarchy),
          ),
          _buildAssetCard(
            context: context,
            title: 'المستودعات والمخازن',
            subtitle: '٨ مواقع استراتيجية · ٢١٠ كاميرات',
            icon: Icons.inventory_2_outlined,
            onTap: () => provider.setSelectedTab(AppTab.hierarchy),
          ),
          _buildAssetCard(
            context: context,
            title: 'المتاجر ونقاط العمالة',
            subtitle: '٦٤ منفذاً · ٥١٢ كاميرا أمنية',
            icon: Icons.people_outline,
            onTap: () => provider.setSelectedTab(AppTab.hierarchy),
          ),
        ],
      ),
    );
  }

  Widget _buildFavItem(
      String label, Color color, bool isAlert, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          RadarRingWidget(
            size: 64,
            borderColor: color,
            isAlert: isAlert,
            child: Container(
              color: AppColors.panelRaised,
              child: Icon(Icons.videocam_outlined, color: color, size: 22),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: GoogleFonts.cairo(
              color: AppColors.textSecondary,
              fontSize: 10.5,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAssetCard({
    required BuildContext context,
    required String title,
    required String subtitle,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    final provider = Provider.of<AegisProvider>(context, listen: false);
    final primaryColor = AppColors.getPrimary(provider.isEmergency);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: AppColors.panel,
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(14),
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.panelLine),
            ),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppColors.panelRaised,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppColors.panelLine),
                  ),
                  child: Icon(icon, color: primaryColor, size: 20),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: GoogleFonts.cairo(
                          color: AppColors.textPrimary,
                          fontSize: 13.5,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        subtitle,
                        style: GoogleFonts.cairo(
                          color: AppColors.textSecondary,
                          fontSize: 10.5,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_left, color: AppColors.textTertiary, size: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
