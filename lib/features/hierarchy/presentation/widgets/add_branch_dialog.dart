import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/extensions/build_context_x.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../surveillance_system/domain/entities/branch.dart';
import '../../../surveillance_system/domain/entities/nvr_brand.dart';
import '../../../surveillance_system/domain/entities/nvr_device.dart';
import '../../../surveillance_system/presentation/controllers/aegis_provider.dart';

/// Glassmorphic Wizard Dialog for Enterprise Business Owners to register a new Branch & NVR/DVR device.
class AddBranchDialog extends StatefulWidget {
  const AddBranchDialog({super.key});

  static Future<void> show(BuildContext context) {
    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => const AddBranchDialog(),
    );
  }

  @override
  State<AddBranchDialog> createState() => _AddBranchDialogState();
}

class _AddBranchDialogState extends State<AddBranchDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _ipController = TextEditingController(text: '192.168.1.100');
  final _portController = TextEditingController(text: '554');
  final _usernameController = TextEditingController(text: 'admin');
  final _passwordController = TextEditingController(text: 'pass1234');
  final _channelsController = TextEditingController(text: '16');

  String _selectedCategory = 'المجمعات التجارية (المولات)';
  NvrBrand _selectedBrand = NvrBrand.hikvision;
  bool _isTesting = false;

  @override
  void dispose() {
    _nameController.dispose();
    _ipController.dispose();
    _portController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    _channelsController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isTesting = true);

    final provider = context.read<AegisProvider>();
    final nvr = NvrDevice(
      id: 'NVR-${DateTime.now().millisecondsSinceEpoch}',
      brand: _selectedBrand,
      ipAddress: _ipController.text.trim(),
      port: int.tryParse(_portController.text.trim()) ?? 554,
      username: _usernameController.text.trim(),
      password: _passwordController.text.trim(),
      channelsCount: int.tryParse(_channelsController.text.trim()) ?? 16,
    );

    final isConnected = await provider.testNvrConnection(nvr);
    setState(() => _isTesting = false);

    if (!isConnected) {
      if (mounted) {
        context.showSnackBar(
          'تعذر الاتصال بجهاز NVR، يرجى التأكد من العنوان وتوافق الشبكة',
        );
      }
      return;
    }

    final newBranch = Branch(
      id: 'BR-${DateTime.now().millisecondsSinceEpoch}',
      name: _nameController.text.trim(),
      categoryType: _selectedCategory,
      location: 'فرع مخصص حديثاً',
      nvrDevice: nvr,
      camerasCount: nvr.channelsCount,
    );

    final success = await provider.addBranch(newBranch);
    if (mounted) {
      Navigator.of(context).pop();
      if (success) {
        context.showSnackBar(
          'تم إضافة الفرع وربط جهاز ${_selectedBrand.label} بنجاح!',
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AegisProvider>();
    final primaryColor = AppColors.getPrimary(provider.isEmergency);

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 480),
        decoration: BoxDecoration(
          color: AppColors.panel,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: primaryColor.withValues(alpha: 0.3)),
          boxShadow: [
            BoxShadow(
              color: primaryColor.withValues(alpha: 0.15),
              blurRadius: 24,
            ),
          ],
        ),
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Dialog Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.add_business_outlined,
                          color: primaryColor,
                          size: 24,
                        ),
                        const SizedBox(width: 10),
                        Text(
                          'إضافة فرع وجهاز كاميرات NVR',
                          style: AppTypography.cairoBold(
                            fontSize: 15,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.close,
                        color: AppColors.textSecondary,
                        size: 20,
                      ),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
                const Divider(color: AppColors.panelLine),
                const SizedBox(height: 12),

                // Branch Details Section
                Text(
                  '١. بيانات الفرع والموقع',
                  style: AppTypography.cairoBold(
                    fontSize: 12,
                    color: primaryColor,
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _nameController,
                  style: AppTypography.cairoRegular(
                    fontSize: 12,
                    color: Colors.white,
                  ),
                  decoration: _buildInputDecoration(
                    'اسم الفرع (مثلاً: فرع مول الرياض، مستودع الخرج)',
                    Icons.storefront,
                  ),
                  validator: (v) => v == null || v.trim().isEmpty
                      ? 'يرجى إدخال اسم الفرع'
                      : null,
                ),
                const SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  initialValue: _selectedCategory,
                  dropdownColor: AppColors.panelRaised,
                  style: AppTypography.cairoRegular(
                    fontSize: 12,
                    color: Colors.white,
                  ),
                  decoration: _buildInputDecoration(
                    'تصنيف المنشأة',
                    Icons.category_outlined,
                  ),
                  items: const [
                    DropdownMenuItem(
                      value: 'المجمعات التجارية (المولات)',
                      child: Text('المجمعات التجارية (المولات)'),
                    ),
                    DropdownMenuItem(
                      value: 'المستودعات والمخازن',
                      child: Text('المستودعات والمخازن'),
                    ),
                    DropdownMenuItem(
                      value: 'المتاجر ونقاط العمالة',
                      child: Text('المتاجر ونقاط العمالة'),
                    ),
                    DropdownMenuItem(
                      value: 'المقرات الإدارية',
                      child: Text('المقرات الإدارية'),
                    ),
                  ],
                  onChanged: (val) => setState(() => _selectedCategory = val!),
                ),
                const SizedBox(height: 18),

                // NVR Brand Selection Section
                Text(
                  '٢. نوع جهاز الكاميرات (NVR/DVR Brand)',
                  style: AppTypography.cairoBold(
                    fontSize: 12,
                    color: primaryColor,
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: NvrBrand.values.map((brand) {
                    final isSelected = _selectedBrand == brand;
                    return ChoiceChip(
                      selected: isSelected,
                      showCheckmark: false,
                      avatar: Icon(
                        brand.icon,
                        size: 16,
                        color: isSelected ? Colors.black : primaryColor,
                      ),
                      label: Text(
                        brand.label,
                        style: AppTypography.cairoBold(
                          fontSize: 10.5,
                          color: isSelected
                              ? Colors.black
                              : AppColors.textPrimary,
                        ),
                      ),
                      selectedColor: primaryColor,
                      backgroundColor: AppColors.panelRaised,
                      side: BorderSide(
                        color: isSelected ? primaryColor : AppColors.panelLine,
                      ),
                      onSelected: (_) => setState(() => _selectedBrand = brand),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 18),

                // NVR Connection Credentials Section
                Text(
                  '٣. بيانات اتصال الشبكة (RTSP/IP Config)',
                  style: AppTypography.cairoBold(
                    fontSize: 12,
                    color: primaryColor,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: TextFormField(
                        controller: _ipController,
                        style: AppTypography.monoRegular(
                          fontSize: 12,
                          color: Colors.white,
                        ),
                        decoration: _buildInputDecoration(
                          'IP / DDNS Server',
                          Icons.dns_outlined,
                        ),
                        validator: (v) =>
                            v == null || v.trim().isEmpty ? 'مطلوب' : null,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      flex: 2,
                      child: TextFormField(
                        controller: _portController,
                        keyboardType: TextInputType.number,
                        style: AppTypography.monoRegular(
                          fontSize: 12,
                          color: Colors.white,
                        ),
                        decoration: _buildInputDecoration(
                          'Port',
                          Icons.numbers,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _usernameController,
                        style: AppTypography.cairoRegular(
                          fontSize: 12,
                          color: Colors.white,
                        ),
                        decoration: _buildInputDecoration(
                          'اسم المستخدم',
                          Icons.person_outline,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextFormField(
                        controller: _passwordController,
                        obscureText: true,
                        style: AppTypography.cairoRegular(
                          fontSize: 12,
                          color: Colors.white,
                        ),
                        decoration: _buildInputDecoration(
                          'كلمة المرور',
                          Icons.lock_outline,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _channelsController,
                  keyboardType: TextInputType.number,
                  style: AppTypography.monoRegular(
                    fontSize: 12,
                    color: Colors.white,
                  ),
                  decoration: _buildInputDecoration(
                    'عدد القنوات / الكاميرات (Channels)',
                    Icons.grid_on_outlined,
                  ),
                ),
                const SizedBox(height: 22),

                // Action Buttons
                SizedBox(
                  width: double.infinity,
                  height: 46,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: _isTesting ? null : _submit,
                    child: _isTesting
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.black,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Text(
                                'جاري اختبار الاتصال والجلب...',
                                style: AppTypography.cairoBold(
                                  fontSize: 12,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          )
                        : Text(
                            'اختبار الاتصال وحفظ الفرع',
                            style: AppTypography.cairoBold(
                              fontSize: 12,
                              color: Colors.black,
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _buildInputDecoration(String hint, IconData icon) {
    return InputDecoration(
      hintText: hint,
      hintStyle: AppTypography.cairoRegular(
        fontSize: 11,
        color: AppColors.textTertiary,
      ),
      prefixIcon: Icon(icon, color: AppColors.textSecondary, size: 18),
      filled: true,
      fillColor: AppColors.panelRaised,
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: AppColors.panelLine),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: AppColors.cyan),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: AppColors.red),
      ),
    );
  }
}
