import 'package:flutter/material.dart';

/// Divisor horizontal con etiqueta central opcional.
///
/// ```dart
/// MyDivider()
/// MyDivider(label: 'O continúa con')
/// MyDivider(label: 'Sección', thickness: 2)
/// ```
class MyDivider extends StatelessWidget {
  const MyDivider({
    super.key,
    this.label,
    this.thickness = 1.0,
    this.color,
    this.indent = 0,
    this.endIndent = 0,
  });

  final String? label;
  final double thickness;
  final Color? color;
  final double indent;
  final double endIndent;

  @override
  Widget build(BuildContext context) {
    final resolvedColor = color ?? Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.12);

    if (label == null) {
      return Divider(
        thickness: thickness,
        color: resolvedColor,
        indent: indent,
        endIndent: endIndent,
      );
    }

    return Row(
      children: [
        SizedBox(width: indent),
        Expanded(
          child: Divider(thickness: thickness, color: resolvedColor),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Text(
            label!,
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),
              fontSize: 12,
              fontWeight: FontWeight.w500,
              letterSpacing: 0.3,
            ),
          ),
        ),
        Expanded(
          child: Divider(thickness: thickness, color: resolvedColor),
        ),
        SizedBox(width: endIndent),
      ],
    );
  }
}
