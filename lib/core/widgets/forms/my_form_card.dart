import 'package:flutter/material.dart';

/// Tarjeta premium optimizada para contener formularios.
///
/// ```dart
/// MyFormCard(
///   child: Column(
///     children: [ ... ],
///   ),
/// )
/// ```
class MyFormCard extends StatelessWidget {
  const MyFormCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(20.0),
  });

  final Widget child;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Container(
      width: double.infinity,
      padding: padding,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: cs.onSurface.withValues(alpha: 0.08),
          width: 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }
}
