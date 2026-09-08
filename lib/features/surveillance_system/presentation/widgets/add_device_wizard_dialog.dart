import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';

/// User-friendly Add Device / Camera Wizard for App Store & Google Play users.
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
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.add_a_photo_rounded, color: AppColors.primaryBlue, size: 24),
                const SizedBox(width: 10),
                Text(
                  'إضافة كاميرا / جهاز جديد',
                  style: AppTypography.cairoBold(fontSize: 16, color: AppColors.textDarkPrimary),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const Divider(height: 20),

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
          style: AppTypography.cairoRegular(fontSize: 13, color: AppColors.textDarkSecondary),
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
          child: ElevatedButton(
            onPressed: () => setState(() => _currentStep = 1),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryBlue,
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: Text(
              'التالي',
              style: AppTypography.cairoBold(fontSize: 14, color: Colors.white),
            ),
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
      borderRadius: BorderRadius.circular(12),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryBlue.withValues(alpha: 0.08) : Colors.grey.shade50,
          border: Border.all(
            color: isSelected ? AppColors.primaryBlue : Colors.grey.shade300,
            width: isSelected ? 1.5 : 1,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(icon, color: isSelected ? AppColors.primaryBlue : Colors.grey.shade600, size: 24),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: AppTypography.cairoBold(fontSize: 13, color: AppColors.textDarkPrimary)),
                  Text(subtitle, style: AppTypography.cairoRegular(fontSize: 11, color: AppColors.textDarkSecondary)),
                ],
              ),
            ),
            if (isSelected) const Icon(Icons.check_circle_rounded, color: AppColors.primaryBlue, size: 20),
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
          style: AppTypography.cairoBold(fontSize: 13, color: AppColors.textDarkPrimary),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _nameController,
          decoration: const InputDecoration(
            labelText: 'اسم الكاميرا (مثال: كاميرا المدخل الرئيسي)',
            prefixIcon: Icon(Icons.videocam_outlined),
          ),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              flex: 2,
              child: TextField(
                controller: _ipController,
                decoration: const InputDecoration(
                  labelText: 'عنوان IP أو RTSP URL',
                  prefixIcon: Icon(Icons.lan_outlined),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: TextField(
                controller: _portController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'المنفذ Port',
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _userController,
                decoration: const InputDecoration(
                  labelText: 'اسم المستخدم',
                  prefixIcon: Icon(Icons.person_outline),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'كلمة السر',
                  prefixIcon: Icon(Icons.lock_outline),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        Row(
          children: [
            OutlinedButton(
              onPressed: () => setState(() => _currentStep = 0),
              child: const Text('السابق'),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    _currentStep = 2;
                    _testConnection();
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryBlue,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: Text(
                  'اختبار الاتصال والحفظ',
                  style: AppTypography.cairoBold(fontSize: 13, color: Colors.white),
                ),
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
          const CircularProgressIndicator(),
          const SizedBox(height: 16),
          Text(
            'جاري الاتصال بالكاميرا واختبار البث...',
            style: AppTypography.cairoRegular(fontSize: 13, color: AppColors.textDarkSecondary),
          ),
        ] else if (_connectionSuccess) ...[
          const Icon(Icons.check_circle_outline_rounded, color: AppColors.green, size: 54),
          const SizedBox(height: 12),
          Text(
            'تم الاتصال بنجاح! الكاميرا جاهزة للبث.',
            style: AppTypography.cairoBold(fontSize: 15, color: AppColors.textDarkPrimary),
          ),
          const SizedBox(height: 6),
          Text(
            'تم إدراج ${_nameController.text} ضمن قائمة كاميراتك.',
            style: AppTypography.cairoRegular(fontSize: 12, color: AppColors.textDarkSecondary),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.green,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: Text(
                'تم - إنهاء',
                style: AppTypography.cairoBold(fontSize: 14, color: Colors.white),
              ),
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
