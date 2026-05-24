import 'package:flutter/material.dart';

/// Variantes de estado disponibles para [MyBadge].
enum MyBadgeVariant { success, warning, error, info, neutral, primary }

/// Un badge/chip de estado con icono opcional y múltiples variantes semánticas.
///
/// Se adapta automáticamente al tema activo (paleta y brillo).
///
/// ```dart
/// MyBadge(label: 'Activo', variant: MyBadgeVariant.success)
/// MyBadge(label: 'Error', variant: MyBadgeVariant.error, icon: Icons.close)
/// ```
class MyBadge extends StatelessWidget {
  const MyBadge({
    super.key,
    required this.label,
    this.variant = MyBadgeVariant.neutral,
    this.icon,
    this.size = MyBadgeSize.medium,
  });

  final String label;
  final MyBadgeVariant variant;
  final IconData? icon;
  final MyBadgeSize size;

  @override
  Widget build(BuildContext context) {
    final colors = _resolveColors(context);
    final fontSize = size == MyBadgeSize.small ? 11.0 : 12.0;
    final iconSize = size == MyBadgeSize.small ? 12.0 : 14.0;
    final hPad = size == MyBadgeSize.small ? 8.0 : 10.0;
    final vPad = size == MyBadgeSize.small ? 2.0 : 4.0;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: hPad, vertical: vPad),
      decoration: BoxDecoration(
        color: colors.background,
        borderRadius: BorderRadius.circular(100),
        border: Border.all(color: colors.border, width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: iconSize, color: colors.foreground),
            const SizedBox(width: 4),
          ],
          Text(
            label,
            style: TextStyle(
              color: colors.foreground,
              fontSize: fontSize,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.2,
            ),
          ),
        ],
      ),
    );
  }

  _BadgeColors _resolveColors(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final a = isDark ? 0.2 : 0.12;
    final b = isDark ? 0.35 : 0.2;

    switch (variant) {
      case MyBadgeVariant.success:
        return _BadgeColors(
          background: const Color(0xFF22C55E).withValues(alpha: a),
          foreground: isDark ? const Color(0xFF86EFAC) : const Color(0xFF15803D),
          border: const Color(0xFF22C55E).withValues(alpha: b),
        );
      case MyBadgeVariant.warning:
        return _BadgeColors(
          background: const Color(0xFFF59E0B).withValues(alpha: a),
          foreground: isDark ? const Color(0xFFFCD34D) : const Color(0xFFB45309),
          border: const Color(0xFFF59E0B).withValues(alpha: b),
        );
      case MyBadgeVariant.error:
        return _BadgeColors(
          background: const Color(0xFFEF4444).withValues(alpha: a),
          foreground: isDark ? const Color(0xFFFCA5A5) : const Color(0xFFB91C1C),
          border: const Color(0xFFEF4444).withValues(alpha: b),
        );
      case MyBadgeVariant.info:
        return _BadgeColors(
          background: const Color(0xFF3B82F6).withValues(alpha: a),
          foreground: isDark ? const Color(0xFF93C5FD) : const Color(0xFF1D4ED8),
          border: const Color(0xFF3B82F6).withValues(alpha: b),
        );
      case MyBadgeVariant.primary:
        return _BadgeColors(
          background: cs.primary.withValues(alpha: a),
          foreground: cs.primary,
          border: cs.primary.withValues(alpha: b),
        );
      case MyBadgeVariant.neutral:
        return _BadgeColors(
          background: cs.onSurface.withValues(alpha: 0.08),
          foreground: cs.onSurface.withValues(alpha: 0.7),
          border: cs.onSurface.withValues(alpha: 0.15),
        );
    }
  }
}

enum MyBadgeSize { small, medium }

class _BadgeColors {
  const _BadgeColors({
    required this.background,
    required this.foreground,
    required this.border,
  });
  final Color background;
  final Color foreground;
  final Color border;
}
