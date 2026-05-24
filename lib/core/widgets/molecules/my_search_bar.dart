import 'package:flutter/material.dart';

/// Barra de búsqueda estándar interactiva.
///
/// ```dart
/// MySearchBar(hintText: 'Buscar...', onChanged: (val) {})
/// ```
class MySearchBar extends StatelessWidget {
  const MySearchBar({
    super.key,
    this.hintText = 'Buscar...',
    this.onChanged,
    this.controller,
  });

  final String hintText;
  final ValueChanged<String>? onChanged;
  final TextEditingController? controller;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return TextField(
      controller: controller,
      onChanged: onChanged,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(color: cs.onSurface.withValues(alpha: 0.4)),
        prefixIcon: Icon(Icons.search, color: cs.primary),
        filled: true,
        fillColor: cs.onSurface.withValues(alpha: 0.05),
        contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(100),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(100),
          borderSide: BorderSide(color: cs.onSurface.withValues(alpha: 0.05)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(100),
          borderSide: BorderSide(color: cs.primary.withValues(alpha: 0.5)),
        ),
      ),
    );
  }
}