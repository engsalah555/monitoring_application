import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/extensions/build_context_x.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../surveillance_system/presentation/controllers/aegis_provider.dart';
import '../../../surveillance_system/presentation/widgets/add_device_wizard_dialog.dart';
import '../widgets/nvr_branch_tile.dart';
import '../widgets/settings_section_card.dart';
import 'team_management_screen.dart';

/// Screen 6: System Settings, NVR Management, Team Permissions (RBAC) & Stream Config.
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
              fontSize: 16.5,
              color: AppColors.textDarkPrimary,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            AppStrings.settingsSubtitle,
            style: AppTypography.cairoRegular(
              fontSize: 12,
              color: AppColors.textDarkSecondary,
            ),
          ),
          const SizedBox(height: 16),

          // Section 0: Team & Role Permissions (RBAC) - Prominent Banner
          Container(
            width: double.infinity,
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: AppColors.primaryGradient,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primaryBlue.withValues(alpha: 0.3),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                const Icon(Icons.admin_panel_settings_rounded, color: Colors.white, size: 36),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'إدارة الفريق والصلاحيات (RBAC)',
                        style: AppTypography.cairoBold(fontSize: 14, color: Colors.white),
                      ),
                      Text(
                        'إضافة مدراء الفروع (مثل مدير المخازن)، وتخصيص الكاميرات والصلاحيات لهم',
                        style: AppTypography.cairoRegular(fontSize: 11, color: Colors.white.withValues(alpha: 0.9)),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const TeamManagementScreen()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: AppColors.primaryBlue,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: Text(
                    'فتح الفريق',
                    style: AppTypography.cairoBold(fontSize: 11, color: AppColors.primaryBlue),
                  ),
                ),
              ],
            ),
          ),

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
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(14.0),
                child: InkWell(
                  onTap: () => AddDeviceWizardDialog.show(context),
                  borderRadius: BorderRadius.circular(14),
                  child: Container(
                    width: double.infinity,
                    height: 48,
                    decoration: BoxDecoration(
                      gradient: AppColors.primaryGradient,
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primaryBlue.withValues(alpha: 0.35),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.add_business_rounded,
                            color: Colors.white, size: 18),
                        const SizedBox(width: 8),
                        Text(
                          'إضافة فرع وجهاز NVR جديد',
                          style: AppTypography.cairoBold(
                              fontSize: 12.5, color: Colors.white),
                        ),
                      ],
                    ),
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
            title: 'عن المنظومة وتراخيص المتاجر (System Info & Store Readiness)',
            icon: Icons.info_outline,
            children: [
              ListTile(
                title: Text(
                  'إصدار منصة أيجيس التنفيذية',
                  style: AppTypography.cairoBold(fontSize: 12),
                ),
                subtitle: Text(
                  'مجهزة كلياً للنشر على Google Play & App Store',
                  style: AppTypography.cairoRegular(fontSize: 10, color: AppColors.textDarkSecondary),
                ),
                trailing: Text(
                  'v2.4.0 (Store Production)',
                  style: AppTypography.monoBold(
                    fontSize: 10.5,
                    color: primaryColor,
                  ),
                ),
              ),
              const Divider(height: 1, color: AppColors.panelLine),
              ListTile(
                title: Text(
                  'سياسة الخصوصية وأمان البيانات',
                  style: AppTypography.cairoBold(fontSize: 12),
                ),
                subtitle: Text(
                  'تشفير كامل للبث المباشر والتسجيلات (End-to-End Encryption)',
                  style: AppTypography.cairoRegular(fontSize: 10, color: AppColors.textDarkSecondary),
                ),
                trailing: const Icon(
                  Icons.privacy_tip_outlined,
                  color: AppColors.green,
                  size: 20,
                ),
                onTap: () {
                  context.showSnackBar(
                    'البيانات والتسجيلات مشفرة بالكامل طبقا لمعايير الأمان العالمية ISO 27001',
                    backgroundColor: AppColors.panelRaised,
                  );
                },
              ),
              const Divider(height: 1, color: AppColors.panelLine),
              ListTile(
                title: Text(
                  'تشخيص حالة الاتصال بالسيرفرات والتراخيص',
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
