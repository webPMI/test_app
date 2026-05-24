import 'package:flutter/material.dart';
import '../atoms/my_button.dart';

/// Un widget de estado vacío (Empty State) premium y consistente con el tema.
///
/// ```dart
/// MyEmptyState(
///   title: 'Sin Resultados',
///   description: 'No pudimos encontrar nada con tu criterio de búsqueda.',
///   icon: Icons.search_off,
///   actionLabel: 'Reintentar',
///   onActionPressed: () {},
/// )
/// ```
class MyEmptyState extends StatelessWidget {
  const MyEmptyState({
    super.key,
    required this.title,
    required this.description,
    this.icon = Icons.hourglass_empty,
    this.actionLabel,
    this.onActionPressed,
    this.illustration,
  });

  final String title;
  final String description;
  final IconData icon;
  final String? actionLabel;
  final VoidCallback? onActionPressed;
  final Widget? illustration;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (illustration != null)
              illustration!
            else
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: cs.primary.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  size: 40,
                  color: cs.primary,
                ),
              ),
            const SizedBox(height: 24),
            Text(
              title,
              textAlign: TextAlign.center,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: cs.onSurface,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              description,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: cs.onSurface.withValues(alpha: 0.6),
                height: 1.5,
              ),
            ),
            if (actionLabel != null && onActionPressed != null) ...[
              const SizedBox(height: 24),
              MyButton(
                label: actionLabel!,
                onPressed: onActionPressed,
                variant: MyButtonVariant.secondary,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
