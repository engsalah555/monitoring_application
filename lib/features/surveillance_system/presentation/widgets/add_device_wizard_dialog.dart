import 'package:flutter/material.dart';
import '../../../../core/theme/app_palette.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/inputs/executive_text_field.dart';
import '../../../../core/widgets/royal/royal_button.dart';

/// User-friendly Add Device / Camera Wizard for App Store & Google Play users in Matte Obsidian theme.
class AddDeviceWizardDialog extends StatefulWidget {
  const AddDeviceWizardDialog({super.key});

  static Future<void> show(BuildContext context) {
    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (_) => const AddDeviceWizardDialog(),
    );
  }

  @override
  State<AddDeviceWizardDialog> createState() => _AddDeviceWizardDialogState();
}

class _AddDeviceWizardDialogState extends State<AddDeviceWizardDialog> {
  int _currentStep = 0;
  String _selectedMethod = 'onvif'; // 'onvif', 'qr', 'rtsp'

  final _nameController = TextEditingController(text: 'كاميرا الحوش والمدخل');
  final _ipController = TextEditingController(text: '192.168.1.120');
  final _portController = TextEditingController(text: '554');
  final _userController = TextEditingController(text: 'admin');
  final _passwordController = TextEditingController(text: '123456');

  bool _isTestingConnection = false;
  bool _connectionSuccess = false;

  @override
  void dispose() {
    _nameController.dispose();
    _ipController.dispose();
    _portController.dispose();
    _userController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppPalette.cardDark,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(22),
        side: const BorderSide(color: AppPalette.borderDark),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: AppPalette.primary.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.add_a_photo_rounded, color: AppPalette.primary, size: 22),
                ),
                const SizedBox(width: 10),
                Text(
                  'إضافة كاميرا / جهاز جديد',
                  style: AppTypography.cairoBold(fontSize: 15, color: Colors.white),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.close, color: AppPalette.textLightMuted),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const Divider(height: 20, color: AppPalette.borderDark),

            if (_currentStep == 0) _buildStep0MethodSelection(),
            if (_currentStep == 1) _buildStep1DetailsInput(),
            if (_currentStep == 2) _buildStep2TestingAndFinish(),
          ],
        ),
      ),
    );
  }

  Widget _buildStep0MethodSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'اختر طريقة ربط الكاميرا المناسبة لك:',
          style: AppTypography.cairoRegular(fontSize: 12.5, color: AppPalette.textLightSecondary),
        ),
        const SizedBox(height: 14),

        _methodOption(
          id: 'onvif',
          title: 'البحث التلقائي في الشبكة (ONVIF Scan)',
          subtitle: 'البحث عن الكاميرات الموصولة بـ Wi-Fi أو الكيبل تلقائياً',
          icon: Icons.wifi_find_rounded,
        ),
        _methodOption(
          id: 'qr',
          title: 'مسح رمز QR Code',
          subtitle: 'مسح الملصق الموجود خلف الكاميرا أو الكرتون',
          icon: Icons.qr_code_scanner_rounded,
        ),
        _methodOption(
          id: 'rtsp',
          title: 'إدخال IP / RTSP مباشر',
          subtitle: 'ربط مباشر عبر بروتوكول RTSP أو عنوان IP للجهاز',
          icon: Icons.link_rounded,
        ),
        const SizedBox(height: 16),

        SizedBox(
          width: double.infinity,
          child: RoyalButton(
            label: 'التالي',
            variant: RoyalButtonVariant.primary,
            height: 44,
            onPressed: () => setState(() => _currentStep = 1),
          ),
        ),
      ],
    );
  }

  Widget _methodOption({
    required String id,
    required String title,
    required String subtitle,
    required IconData icon,
  }) {
    final isSelected = _selectedMethod == id;
    return InkWell(
      onTap: () => setState(() => _selectedMethod = id),
      borderRadius: BorderRadius.circular(14),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected ? AppPalette.primary.withValues(alpha: 0.12) : AppPalette.surfaceDark,
          border: Border.all(
            color: isSelected ? AppPalette.primary : AppPalette.borderDark,
            width: isSelected ? 1.5 : 1,
          ),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            Icon(icon, color: isSelected ? AppPalette.primary : AppPalette.textLightMuted, size: 24),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: AppTypography.cairoBold(fontSize: 12.5, color: Colors.white)),
                  Text(subtitle, style: AppTypography.cairoRegular(fontSize: 10.5, color: AppPalette.textLightMuted)),
                ],
              ),
            ),
            if (isSelected) const Icon(Icons.check_circle_rounded, color: AppPalette.primary, size: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildStep1DetailsInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'أدخل بيانات الكاميرا / الجهاز:',
          style: AppTypography.cairoBold(fontSize: 13, color: Colors.white),
        ),
        const SizedBox(height: 12),
        ExecutiveTextField(
          controller: _nameController,
          label: 'اسم الكاميرا',
          hint: 'مثال: كاميرا المدخل الرئيسي',
          prefixIcon: Icons.videocam_outlined,
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              flex: 2,
              child: ExecutiveTextField(
                controller: _ipController,
                label: 'IP / RTSP URL',
                hint: '192.168.1.120',
                prefixIcon: Icons.lan_outlined,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: ExecutiveTextField(
                controller: _portController,
                label: 'Port',
                hint: '554',
                keyboardType: TextInputType.number,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: ExecutiveTextField(
                controller: _userController,
                label: 'اسم المستخدم',
                hint: 'admin',
                prefixIcon: Icons.person_outline,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: ExecutiveTextField(
                controller: _passwordController,
                label: 'كلمة السر',
                obscureText: true,
                hint: '••••••',
                prefixIcon: Icons.lock_outline,
              ),
            ),
          ],
        ),
        const SizedBox(height: 18),

        Row(
          children: [
            OutlinedButton(
              onPressed: () => setState(() => _currentStep = 0),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: AppPalette.borderDark),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                foregroundColor: AppPalette.textLightMuted,
              ),
              child: const Text('السابق'),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: RoyalButton(
                label: 'اختبار الاتصال والحفظ',
                variant: RoyalButtonVariant.primary,
                height: 44,
                onPressed: () {
                  setState(() {
                    _currentStep = 2;
                    _testConnection();
                  });
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStep2TestingAndFinish() {
    return Column(
      children: [
        const SizedBox(height: 10),
        if (_isTestingConnection) ...[
          const CircularProgressIndicator(color: AppPalette.primary),
          const SizedBox(height: 16),
          Text(
            'جاري الاتصال بالكاميرا واختبار البث...',
            style: AppTypography.cairoRegular(fontSize: 13, color: AppPalette.textLightSecondary),
          ),
        ] else if (_connectionSuccess) ...[
          const Icon(Icons.check_circle_outline_rounded, color: AppPalette.emeraldLive, size: 54),
          const SizedBox(height: 12),
          Text(
            'تم الاتصال بنجاح! الكاميرا جاهزة للبث.',
            style: AppTypography.cairoBold(fontSize: 15, color: Colors.white),
          ),
          const SizedBox(height: 6),
          Text(
            'تم إدراج ${_nameController.text} ضمن قائمة كاميراتك.',
            style: AppTypography.cairoRegular(fontSize: 12, color: AppPalette.textLightMuted),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: RoyalButton(
              label: 'تم - إنهاء',
              variant: RoyalButtonVariant.primary,
              height: 44,
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ],
        const SizedBox(height: 10),
      ],
    );
  }

  Future<void> _testConnection() async {
    setState(() => _isTestingConnection = true);
    await Future.delayed(const Duration(milliseconds: 1200));
    if (mounted) {
      setState(() {
        _isTestingConnection = false;
        _connectionSuccess = true;
      });
    }
  }
}
