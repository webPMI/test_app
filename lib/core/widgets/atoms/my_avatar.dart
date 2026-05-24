import 'package:flutter/material.dart';

/// Un avatar dinámico que extrae las iniciales de un nombre.
///
/// Se adapta automáticamente a los colores del tema actual.
///
/// ```dart
/// MyAvatar(name: 'Developer Mode') // Renderiza "DM"
/// ```
class MyAvatar extends StatelessWidget {
  const MyAvatar({super.key, required this.name, this.radius = 20.0});

  final String name;
  final double radius;

  String get _initials {
    if (name.trim().isEmpty) return '?';
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.length > 1) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return name.substring(0, name.length >= 2 ? 2 : 1).toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return CircleAvatar(
      radius: radius,
      backgroundColor: cs.primary.withValues(alpha: 0.15),
      foregroundColor: cs.primary,
      child: Text(
        _initials,
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: radius * 0.8),
      ),
    );
  }
}
