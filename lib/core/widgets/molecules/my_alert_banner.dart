import 'package:flutter/material.dart';

/// Tipo de alerta para [MyAlertBanner].
enum MyAlertType { info, success, warning, error }

/// Banner de alerta con tipo semántico, título opcional, acción y dismiss.
///
/// ```dart
/// MyAlertBanner(message: 'Datos guardados', type: MyAlertType.success)
/// MyAlertBanner(title: '¡Atención!', message: 'Se perderán los cambios.', type: MyAlertType.warning, onDismiss: ...)
/// ```
class MyAlertBanner extends StatelessWidget {
  const MyAlertBanner({
    super.key,
    required this.message,
    required this.type,
    this.title,
    this.onDismiss,
    this.action,
    this.actionLabel,
  });

  final String message;
  final MyAlertType type;
  final String? title;
  final VoidCallback? onDismiss;
  final VoidCallback? action;
  final String? actionLabel;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colors = _resolveColors(isDark);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: colors.background,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: colors.border),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(colors.icon, size: 20, color: colors.foreground),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (title != null) ...[
                  Text(
                    title!,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: colors.foreground,
                    ),
                  ),
                  const SizedBox(height: 3),
                ],
                Text(
                  message,
                  style: TextStyle(
                    fontSize: 13,
                    color: colors.foreground.withValues(alpha: 0.85),
                  ),
                ),
                if (action != null && actionLabel != null) ...[
                  const SizedBox(height: 8),
                  GestureDetector(
                    onTap: action,
                    child: Text(
                      actionLabel!,
                      style: TextStyle(
                        color: colors.foreground,
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (onDismiss != null)
            GestureDetector(
              onTap: onDismiss,
              child: Icon(Icons.close_rounded, size: 18, color: colors.foreground.withValues(alpha: 0.6)),
            ),
        ],
      ),
    );
  }

  _AlertColors _resolveColors(bool isDark) {
    switch (type) {
      case MyAlertType.info:
        return _AlertColors(
          background: const Color(0xFF3B82F6).withValues(alpha: isDark ? 0.15 : 0.08),
          foreground: isDark ? const Color(0xFF93C5FD) : const Color(0xFF1D4ED8),
          border: const Color(0xFF3B82F6).withValues(alpha: isDark ? 0.3 : 0.2),
          icon: Icons.info_outline_rounded,
        );
      case MyAlertType.success:
        return _AlertColors(
          background: const Color(0xFF22C55E).withValues(alpha: isDark ? 0.15 : 0.08),
          foreground: isDark ? const Color(0xFF86EFAC) : const Color(0xFF15803D),
          border: const Color(0xFF22C55E).withValues(alpha: isDark ? 0.3 : 0.2),
          icon: Icons.check_circle_outline_rounded,
        );
      case MyAlertType.warning:
        return _AlertColors(
          background: const Color(0xFFF59E0B).withValues(alpha: isDark ? 0.15 : 0.08),
          foreground: isDark ? const Color(0xFFFCD34D) : const Color(0xFFB45309),
          border: const Color(0xFFF59E0B).withValues(alpha: isDark ? 0.3 : 0.2),
          icon: Icons.warning_amber_rounded,
        );
      case MyAlertType.error:
        return _AlertColors(
          background: const Color(0xFFEF4444).withValues(alpha: isDark ? 0.15 : 0.08),
          foreground: isDark ? const Color(0xFFFCA5A5) : const Color(0xFFB91C1C),
          border: const Color(0xFFEF4444).withValues(alpha: isDark ? 0.3 : 0.2),
          icon: Icons.error_outline_rounded,
        );
    }
  }
}

class _AlertColors {
  const _AlertColors({required this.background, required this.foreground, required this.border, required this.icon});
  final Color background;
  final Color foreground;
  final Color border;
  final IconData icon;
}
