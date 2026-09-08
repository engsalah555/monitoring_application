import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/extensions/build_context_x.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/neumorphic_decorations.dart';
import '../../../surveillance_system/domain/entities/branch.dart';
import '../../../surveillance_system/domain/entities/nvr_brand.dart';
import '../../../surveillance_system/domain/entities/nvr_device.dart';
import '../../../surveillance_system/presentation/controllers/aegis_provider.dart';

/// Soft Neumorphic Wizard Dialog for Business Owners to register a new Branch with GPS & NVR device.
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
  final _locationController = TextEditingController(text: 'الرياض - حي العليا');
  final _categoryController = TextEditingController(text: 'المنازل والفلل');
  final _ipController = TextEditingController(text: '192.168.1.100');
  final _portController = TextEditingController(text: '554');
  final _usernameController = TextEditingController(text: 'admin');
  final _passwordController = TextEditingController(text: 'pass1234');
  final _channelsController = TextEditingController(text: '16');

  NvrBrand _selectedBrand = NvrBrand.hikvision;
  bool _isTesting = false;
  bool _isLocatingGps = false;

  @override
  void dispose() {
    _nameController.dispose();
    _locationController.dispose();
    _categoryController.dispose();
    _ipController.dispose();
    _portController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    _channelsController.dispose();
    super.dispose();
  }

  void _fetchGpsLocation() async {
    setState(() => _isLocatingGps = true);
    await Future.delayed(const Duration(milliseconds: 900));
    if (mounted) {
      setState(() {
        _isLocatingGps = false;
        _locationController.text =
            'الموقع المحدد: 24.7136° N, 46.6753° E (الرياض)';
      });
      context.showSnackBar('تم تحديد الموقع الجغرافي للفرع عبر الـ GPS بنجاح!');
    }
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
      categoryType: _categoryController.text.trim(),
      location: _locationController.text.trim(),
      nvrDevice: nvr,
      camerasCount: nvr.channelsCount,
    );

    final success = await provider.addBranch(newBranch);
    if (mounted) {
      Navigator.of(context).pop();
      if (success) {
        context.showSnackBar(
          'تم إضافة الفرع بالموقع المحدد وربط جهاز ${_selectedBrand.label} بنجاح!',
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 490),
        decoration: NeumorphicDecorations.softRaised(
          color: AppColors.clayCard,
          borderRadius: 28,
        ),
        padding: const EdgeInsets.all(22),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            gradient: AppColors.primaryGradient,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.add_business_rounded,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'إضافة فرع محلي مع تحديد الـ GPS',
                          style: AppTypography.cairoBold(
                            fontSize: 15,
                            color: AppColors.textDarkPrimary,
                          ),
                        ),
                      ],
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.close_rounded,
                        color: AppColors.textDarkSecondary,
                        size: 22,
                      ),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                const Divider(color: Color(0xFFE2E8F0)),
                const SizedBox(height: 12),

                // Section 1: Branch Details & GPS
                Text(
                  '١. بيانات الفرع والموقع الجغرافي (GPS)',
                  style: AppTypography.cairoBold(
                    fontSize: 12.5,
                    color: AppColors.primaryBlue,
                  ),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _nameController,
                  style: AppTypography.cairoRegular(
                    fontSize: 12,
                    color: AppColors.textDarkPrimary,
                  ),
                  decoration: _buildInputDecoration(
                    'اسم الفرع (مثلاً: فرع النخيل مول، مستودع السلي)',
                    Icons.storefront_rounded,
                  ),
                  validator: (v) => v == null || v.trim().isEmpty
                      ? 'يرجى إدخال اسم الفرع'
                      : null,
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _locationController,
                        style: AppTypography.cairoRegular(
                          fontSize: 11.5,
                          color: AppColors.textDarkPrimary,
                        ),
                        decoration: _buildInputDecoration(
                          'موقع الفرع والإحداثيات',
                          Icons.location_on_outlined,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    InkWell(
                      onTap: _isLocatingGps ? null : _fetchGpsLocation,
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 14),
                        decoration: NeumorphicDecorations.softRaised(
                          color: AppColors.clayBg,
                          borderRadius: 12,
                        ),
                        child: _isLocatingGps
                            ? const SizedBox(
                                width: 18,
                                height: 18,
                                child:
                                    CircularProgressIndicator(strokeWidth: 2),
                              )
                            : Row(
                                children: [
                                  const Icon(Icons.my_location_rounded,
                                      color: AppColors.primaryBlue, size: 18),
                                  const SizedBox(width: 6),
                                  Text(
                                    'تحديد GPS',
                                    style: AppTypography.cairoBold(
                                        fontSize: 11,
                                        color: AppColors.primaryBlue),
                                  ),
                                ],
                              ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                // Category Free Text & Quick Chips Section
                Text(
                  'نوع / تصنيف الموقع (يمكنك كتابة أي تصنيف يناسبك)',
                  style: AppTypography.cairoBold(
                    fontSize: 12,
                    color: AppColors.textDarkPrimary,
                  ),
                ),
                const SizedBox(height: 6),
                TextFormField(
                  controller: _categoryController,
                  style: AppTypography.cairoRegular(
                    fontSize: 12,
                    color: AppColors.textDarkPrimary,
                  ),
                  decoration: _buildInputDecoration(
                    'اكتب التصنيف الخاص بك (مثلاً: منزل، محل حلاقة، مستودع، مكتب...)',
                    Icons.category_outlined,
                  ),
                  validator: (v) => v == null || v.trim().isEmpty
                      ? 'يرجى كتابة أو اختيار تصنيف الموقع'
                      : null,
                ),
                const SizedBox(height: 6),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: [
                    '🏡 منزل / فيلا',
                    '🛍️ متجر / محل',
                    '📦 مستودع / مخزن',
                    '🏢 مجمع / مول',
                    '💼 مكتب / شركة',
                  ].map((suggestion) {
                    return InkWell(
                      onTap: () {
                        setState(() {
                          _categoryController.text = suggestion
                              .replaceAll(RegExp(r'^[^\s]+\s*'), ''); // Clean emoji prefix if clicked
                        });
                      },
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: AppColors.clayBg,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: const Color(0xFFCBD5E1)),
                        ),
                        child: Text(
                          suggestion,
                          style: AppTypography.cairoRegular(
                            fontSize: 10.5,
                            color: AppColors.textDarkSecondary,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 18),

                // Section 2: Universal NVR Brand Selection
                Text(
                  '٢. اختيار نوع جهاز الـ NVR (متوافق مع كل الشركات)',
                  style: AppTypography.cairoBold(
                    fontSize: 12.5,
                    color: AppColors.primaryBlue,
                  ),
                ),
                const SizedBox(height: 10),
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
                        color:
                            isSelected ? Colors.white : AppColors.primaryBlue,
                      ),
                      label: Text(
                        brand.label,
                        style: AppTypography.cairoBold(
                          fontSize: 11,
                          color: isSelected
                              ? Colors.white
                              : AppColors.textDarkPrimary,
                        ),
                      ),
                      selectedColor: AppColors.primaryBlue,
                      backgroundColor: AppColors.clayBg,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      side: BorderSide(
                        color: isSelected
                            ? AppColors.primaryBlue
                            : const Color(0xFFCBD5E1),
                      ),
                      onSelected: (_) => setState(() => _selectedBrand = brand),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 18),

                // Section 3: Connection Config
                Text(
                  '٣. بيانات شبكة الـ IP/RTSP الخاصة بالفرع',
                  style: AppTypography.cairoBold(
                    fontSize: 12.5,
                    color: AppColors.primaryBlue,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: TextFormField(
                        controller: _ipController,
                        style: AppTypography.monoRegular(
                          fontSize: 12,
                          color: AppColors.textDarkPrimary,
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
                          color: AppColors.textDarkPrimary,
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
                          color: AppColors.textDarkPrimary,
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
                          color: AppColors.textDarkPrimary,
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
                    color: AppColors.textDarkPrimary,
                  ),
                  decoration: _buildInputDecoration(
                    'عدد القنوات / الكاميرات (Channels)',
                    Icons.grid_on_outlined,
                  ),
                ),
                const SizedBox(height: 22),

                // Submit Button
                InkWell(
                  onTap: _isTesting ? null : _submit,
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    width: double.infinity,
                    height: 50,
                    decoration: BoxDecoration(
                      gradient: AppColors.primaryGradient,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primaryBlue.withValues(alpha: 0.35),
                          blurRadius: 14,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Center(
                      child: _isTesting
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const SizedBox(
                                  width: 18,
                                  height: 18,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Text(
                                  'جاري الفحص وحفظ الفرع...',
                                  style: AppTypography.cairoBold(
                                    fontSize: 12.5,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            )
                          : Text(
                              'اختبار الاتصال وحفظ الفرع',
                              style: AppTypography.cairoBold(
                                fontSize: 13,
                                color: Colors.white,
                              ),
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
        color: AppColors.textDarkTertiary,
      ),
      prefixIcon: Icon(icon, color: AppColors.primaryBlue, size: 18),
      filled: true,
      fillColor: AppColors.clayBg,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: AppColors.primaryBlue, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: AppColors.red),
      ),
    );
  }
}
