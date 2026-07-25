import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/extensions/build_context_x.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../hierarchy/presentation/widgets/add_branch_dialog.dart';
import '../../../surveillance_system/presentation/controllers/aegis_provider.dart';
import '../widgets/nvr_branch_tile.dart';
import '../widgets/settings_section_card.dart';

/// Screen 6: System Settings, NVR Management, Stream Config & Security Controls.
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _isHighQualityStream = true;
  bool _isHardwareAccelerated = true;
  bool _isEmergencyAudioAlerts = true;
  bool _isBiometricLockEnabled = true;

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AegisProvider>();
    final primaryColor = AppColors.getPrimary(provider.isEmergency);

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Executive Title
          Text(
            AppStrings.settingsTitle,
            style: AppTypography.cairoBold(
              fontSize: 16,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            AppStrings.settingsSubtitle,
            style: AppTypography.cairoRegular(
              fontSize: 11.5,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 16),

          // Section 1: Branches & NVR Management
          SettingsSectionCard(
            title: 'إدارة الفروع وأجهزة الـ NVR المسجلة',
            icon: Icons.dns_outlined,
            children: [
              ...provider.branches.map(
                (branch) => NvrBranchTile(
                  branch: branch,
                  onTap: () {
                    context.showSnackBar(
                      'جاري اختبار وتشخيص سيرفر ${branch.nvrDevice.ipAddress}...',
                      backgroundColor: AppColors.panelRaised,
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: SizedBox(
                  width: double.infinity,
                  height: 44,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    icon: const Icon(Icons.add_business_outlined, size: 18),
                    label: Text(
                      'إضافة فرع وجهاز NVR جديد',
                      style: AppTypography.cairoBold(fontSize: 11.5),
                    ),
                    onPressed: () => AddBranchDialog.show(context),
                  ),
                ),
              ),
            ],
          ),

          // Section 2: Streaming & Quality Settings
          SettingsSectionCard(
            title: 'جودة البث وأداء الشبكة (Streaming & Network)',
            icon: Icons.high_quality_outlined,
            children: [
              SwitchListTile(
                value: _isHighQualityStream,
                activeThumbColor: primaryColor,
                title: Text(
                  'البث بدقة عالية (Main Stream HD 1080p/4K)',
                  style: AppTypography.cairoBold(
                    fontSize: 12,
                    color: AppColors.textPrimary,
                  ),
                ),
                subtitle: Text(
                  'استخدام البث الرئيسي عالي الدقة (يتطلب سرعة اتصالات عالية)',
                  style: AppTypography.cairoRegular(
                    fontSize: 10,
                    color: AppColors.textSecondary,
                  ),
                ),
                onChanged: (v) => setState(() => _isHighQualityStream = v),
              ),
              const Divider(height: 1, color: AppColors.panelLine),
              SwitchListTile(
                value: _isHardwareAccelerated,
                activeThumbColor: primaryColor,
                title: Text(
                  'تسريع العتاد البرمجي (Hardware Decoding)',
                  style: AppTypography.cairoBold(
                    fontSize: 12,
                    color: AppColors.textPrimary,
                  ),
                ),
                subtitle: Text(
                  'معالجة بث الفيديو باستخدام كرت الشاشة وتقليل استهلاك المعالج',
                  style: AppTypography.cairoRegular(
                    fontSize: 10,
                    color: AppColors.textSecondary,
                  ),
                ),
                onChanged: (v) => setState(() => _isHardwareAccelerated = v),
              ),
            ],
          ),

          // Section 3: Alerts & Security Controls
          SettingsSectionCard(
            title: 'الأمان والتنبيهات الصوتية (Security & Alerts)',
            icon: Icons.shield_outlined,
            children: [
              SwitchListTile(
                value: _isEmergencyAudioAlerts,
                activeThumbColor: primaryColor,
                title: Text(
                  'التنبيهات الصوتية عند الطوارئ (Emergency Siren)',
                  style: AppTypography.cairoBold(
                    fontSize: 12,
                    color: AppColors.textPrimary,
                  ),
                ),
                subtitle: Text(
                  'تشغيل نغمة إنذار صوتية فورية عند رصد اختراق أمني',
                  style: AppTypography.cairoRegular(
                    fontSize: 10,
                    color: AppColors.textSecondary,
                  ),
                ),
                onChanged: (v) => setState(() => _isEmergencyAudioAlerts = v),
              ),
              const Divider(height: 1, color: AppColors.panelLine),
              SwitchListTile(
                value: _isBiometricLockEnabled,
                activeThumbColor: primaryColor,
                title: Text(
                  'الحماية بالبصمة / FaceID عند الفتح',
                  style: AppTypography.cairoBold(
                    fontSize: 12,
                    color: AppColors.textPrimary,
                  ),
                ),
                subtitle: Text(
                  'طلب المصادقة البيومترية قبل الدخول إلى غرفة القيادة والسيطرة',
                  style: AppTypography.cairoRegular(
                    fontSize: 10,
                    color: AppColors.textSecondary,
                  ),
                ),
                onChanged: (v) => setState(() => _isBiometricLockEnabled = v),
              ),
            ],
          ),

          // Section 4: System Info & Diagnostics
          SettingsSectionCard(
            title: 'عن المنظومة وتشخيص الأداء (System Info)',
            icon: Icons.info_outline,
            children: [
              ListTile(
                title: Text(
                  'إصدار منصة أيجيس التنفيذية',
                  style: AppTypography.cairoBold(fontSize: 12),
                ),
                trailing: Text(
                  'v2.4.0 (Enterprise Build)',
                  style: AppTypography.monoBold(
                    fontSize: 10.5,
                    color: primaryColor,
                  ),
                ),
              ),
              const Divider(height: 1, color: AppColors.panelLine),
              ListTile(
                title: Text(
                  'تشخيص حالة الاتصال بالسيرفرات',
                  style: AppTypography.cairoBold(fontSize: 12),
                ),
                trailing: const Icon(
                  Icons.chevron_left,
                  color: AppColors.textTertiary,
                  size: 18,
                ),
                onTap: () {
                  context.showSnackBar(
                    'جميع السيرفرات والأجهزة تعمل بكفاءة 100%',
                    backgroundColor: AppColors.panelRaised,
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 80),
        ],
      ),
    );
  }
}
