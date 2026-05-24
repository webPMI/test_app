import 'package:flutter/material.dart';

/// Un selector Dropdown estilizado y consistente.
///
/// ```dart
/// MyDropdownField<String>(
///   label: 'País',
///   value: _selectedCountry,
///   items: ['España', 'México', 'Argentina'].map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
///   onChanged: (val) { ... },
/// )
/// ```
class MyDropdownField<T> extends StatelessWidget {
  const MyDropdownField({
    super.key,
    required this.label,
    required this.items,
    this.value,
    this.onChanged,
    this.validator,
    this.prefixIcon,
  });

  final String label;
  final List<DropdownMenuItem<T>> items;
  final T? value;
  final ValueChanged<T?>? onChanged;
  final FormFieldValidator<T>? validator;
  final IconData? prefixIcon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: DropdownButtonFormField<T>(
        initialValue: value,
        items: items,
        onChanged: onChanged,
        validator: validator,
        style: TextStyle(color: cs.onSurface, fontSize: 15),
        icon: Icon(Icons.keyboard_arrow_down_rounded, color: cs.onSurface.withValues(alpha: 0.6)),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: cs.onSurface.withValues(alpha: 0.6), fontSize: 14),
          prefixIcon: prefixIcon != null ? Icon(prefixIcon, color: cs.primary, size: 20) : null,
          filled: true,
          fillColor: cs.surface,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
        ),
      ),
    );
  }
}
