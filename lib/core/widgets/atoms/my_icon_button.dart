import 'package:flutter/material.dart';

enum MyIconButtonVariant { primary, secondary, ghost, destructive }

/// Botón de icono circular con variantes de diseño consistentes con el Design System.
///
/// ```dart
/// MyIconButton(icon: Icons.add, onPressed: () {})
/// MyIconButton(icon: Icons.delete, variant: MyIconButtonVariant.destructive)
/// ```
class MyIconButton extends StatelessWidget {
  const MyIconButton({
    super.key,
    required this.icon,
    this.onPressed,
    this.variant = MyIconButtonVariant.ghost,
    this.tooltip,
    this.size = 40.0,
  });

  final IconData icon;
  final VoidCallback? onPressed;
  final MyIconButtonVariant variant;
  final String? tooltip;
  final double size;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isDisabled = onPressed == null;

    Color bg;
    Color fg;

    switch (variant) {
      case MyIconButtonVariant.primary:
        bg = cs.primary;
        fg = cs.onPrimary;
        break;
      case MyIconButtonVariant.secondary:
        bg = cs.primary.withValues(alpha: 0.1);
        fg = cs.primary;
        break;
      case MyIconButtonVariant.ghost:
        bg = Colors.transparent;
        fg = cs.onSurface;
        break;
      case MyIconButtonVariant.destructive:
        bg = const Color(0xFFEF4444).withValues(alpha: 0.1);
        fg = const Color(0xFFEF4444);
        break;
    }

    if (isDisabled) {
      bg = bg == Colors.transparent
          ? Colors.transparent
          : cs.onSurface.withValues(alpha: 0.1);
      fg = cs.onSurface.withValues(alpha: 0.3);
    }

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(color: bg, shape: BoxShape.circle),
      child: IconButton(
        icon: Icon(icon),
        color: fg,
        onPressed: onPressed,
        iconSize: size * 0.5,
        splashRadius: size * 0.5,
        padding: EdgeInsets.zero,
        tooltip: tooltip,
      ),
    );
  }
}
