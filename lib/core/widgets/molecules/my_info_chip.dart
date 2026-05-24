import 'package:flutter/material.dart';

/// Chip de información redondeado, útil para filtros o etiquetas con acción.
///
/// ```dart
/// MyInfoChip(label: 'Filtro', onDeleted: () {})
/// ```
class MyInfoChip extends StatelessWidget {
  const MyInfoChip({super.key, required this.label, this.icon, this.onDeleted});

  final String label;
  final IconData? icon;
  final VoidCallback? onDeleted;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Chip(
      label: Text(
        label,
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w500,
          color: cs.onSurface,
        ),
      ),
      avatar: icon != null ? Icon(icon, size: 16, color: cs.primary) : null,
      deleteIcon: const Icon(Icons.close, size: 16),
      onDeleted: onDeleted,
      backgroundColor: cs.surface,
      side: BorderSide(color: cs.onSurface.withValues(alpha: 0.1)),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    );
  }
}
