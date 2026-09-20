import 'package:flutter/material.dart';
import '../../theme/app_palette.dart';
import '../../theme/app_typography.dart';

/// Unified dark-mode form text input for devices, branches, and user management.
class ExecutiveTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String? hint;
  final IconData? prefixIcon;
  final Widget? suffix;
  final bool obscureText;
  final TextInputType keyboardType;
  final FormFieldValidator<String>? validator;
  final ValueChanged<String>? onChanged;

  const ExecutiveTextField({
    super.key,
    required this.controller,
    required this.label,
    this.hint,
    this.prefixIcon,
    this.suffix,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.validator,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: AppTypography.cairoBold(
            fontSize: 11.5,
            color: AppPalette.textLightSecondary,
          ),
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          obscureText: obscureText,
          keyboardType: keyboardType,
          validator: validator,
          onChanged: onChanged,
          style: AppTypography.cairoRegular(fontSize: 12.5, color: Colors.white),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: AppTypography.cairoRegular(
              fontSize: 11.5,
              color: AppPalette.textLightMuted,
            ),
            prefixIcon: prefixIcon != null
                ? Icon(prefixIcon, color: AppPalette.primary, size: 18)
                : null,
            suffixIcon: suffix,
            filled: true,
            fillColor: AppPalette.surfaceDark,
            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: AppPalette.borderDark),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: AppPalette.primary, width: 1.5),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: AppPalette.crimsonAlert),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: AppPalette.crimsonAlert, width: 1.5),
            ),
          ),
        ),
      ],
    );
  }
}
