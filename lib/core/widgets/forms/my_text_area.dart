import 'package:flutter/material.dart';

/// Campo de texto de múltiples líneas (Text Area) con contador de caracteres.
///
/// ```dart
/// MyTextArea(
///   label: 'Biografía',
///   maxLines: 5,
///   maxLength: 250,
/// )
/// ```
class MyTextArea extends StatelessWidget {
  const MyTextArea({
    super.key,
    required this.label,
    this.controller,
    this.hintText,
    this.maxLines = 4,
    this.maxLength = 500,
    this.validator,
    this.onChanged,
  });

  final String label;
  final TextEditingController? controller;
  final String? hintText;
  final int maxLines;
  final int maxLength;
  final FormFieldValidator<String>? validator;
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        maxLength: maxLength,
        validator: validator,
        onChanged: onChanged,
        style: TextStyle(color: cs.onSurface, fontSize: 15),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: cs.onSurface.withValues(alpha: 0.6), fontSize: 14),
          hintText: hintText,
          hintStyle: TextStyle(color: cs.onSurface.withValues(alpha: 0.35)),
          filled: true,
          fillColor: cs.surface,
          alignLabelWithHint: true,
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
          counterStyle: TextStyle(color: cs.onSurface.withValues(alpha: 0.4), fontSize: 11),
        ),
      ),
    );
  }
}
