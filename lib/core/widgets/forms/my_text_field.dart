import 'package:flutter/material.dart';

/// Campo de entrada de texto premium adaptado al Design System.
///
/// ```dart
/// MyTextField(
///   label: 'Correo Electrónico',
///   hintText: 'ejemplo@correo.com',
///   prefixIcon: Icons.email_outlined,
///   validator: (v) => v!.isEmpty ? 'Requerido' : null,
/// )
/// ```
class MyTextField extends StatelessWidget {
  const MyTextField({
    super.key,
    required this.label,
    this.controller,
    this.hintText,
    this.prefixIcon,
    this.suffixIcon,
    this.keyboardType,
    this.obscureText = false,
    this.validator,
    this.onChanged,
    this.enabled = true,
  });

  final String label;
  final TextEditingController? controller;
  final String? hintText;
  final IconData? prefixIcon;
  final Widget? suffixIcon;
  final TextInputType? keyboardType;
  final bool obscureText;
  final FormFieldValidator<String>? validator;
  final ValueChanged<String>? onChanged;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        obscureText: obscureText,
        validator: validator,
        onChanged: onChanged,
        enabled: enabled,
        style: TextStyle(color: cs.onSurface, fontSize: 15),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: cs.onSurface.withValues(alpha: 0.6), fontSize: 14),
          hintText: hintText,
          hintStyle: TextStyle(color: cs.onSurface.withValues(alpha: 0.35)),
          prefixIcon: prefixIcon != null ? Icon(prefixIcon, color: cs.primary, size: 20) : null,
          suffixIcon: suffixIcon,
          filled: true,
          fillColor: enabled ? cs.surface : cs.onSurface.withValues(alpha: 0.04),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: cs.onSurface.withValues(alpha: 0.12)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: cs.onSurface.withValues(alpha: 0.12)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: cs.primary, width: 2),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: cs.error),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: cs.error, width: 2),
          ),
        ),
      ),
    );
  }
}
