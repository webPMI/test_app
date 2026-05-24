import 'package:flutter/material.dart';

/// Elemento de una línea de tiempo conector y cuerpo de contenido.
///
/// ```dart
/// MyTimelineItem(
///   title: 'Cuenta Creada',
///   description: 'Se registró de forma exitosa en el sistema.',
///   time: '10:30 AM',
///   isFirst: true,
/// )
/// ```
class MyTimelineItem extends StatelessWidget {
  const MyTimelineItem({
    super.key,
    required this.title,
    required this.description,
    this.time,
    this.icon = Icons.circle,
    this.isFirst = false,
    this.isLast = false,
    this.child,
  });

  final String title;
  final String description;
  final String? time;
  final IconData icon;
  final bool isFirst;
  final bool isLast;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Sección de línea y nodo
          SizedBox(
            width: 48,
            child: Column(
              children: [
                // Línea superior
                Expanded(
                  child: Container(
                    width: 2,
                    color: isFirst ? Colors.transparent : cs.outlineVariant,
                  ),
                ),
                // Icono/Nodo
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: cs.primary.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                    border: Border.all(color: cs.primary, width: 2),
                  ),
                  child: Icon(
                    icon,
                    size: 14,
                    color: cs.primary,
                  ),
                ),
                // Línea inferior
                Expanded(
                  child: Container(
                    width: 2,
                    color: isLast ? Colors.transparent : cs.outlineVariant,
                  ),
                ),
              ],
            ),
          ),
          // Sección de contenido
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 16.0, bottom: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          title,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: cs.onSurface,
                          ),
                        ),
                      ),
                      if (time != null)
                        Text(
                          time!,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: cs.onSurface.withValues(alpha: 0.4),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    description,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: cs.onSurface.withValues(alpha: 0.6),
                      height: 1.4,
                    ),
                  ),
                  if (child != null) ...[
                    const SizedBox(height: 12),
                    child!,
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
