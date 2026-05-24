import 'package:flutter/material.dart';

enum MyToastType { success, error, warning, info }

/// Una alerta flotante (Toast) premium con temporizador visual animado en la parte inferior.
///
/// ```dart
/// MyToast(
///   message: 'Operación completada con éxito.',
///   type: MyToastType.success,
///   duration: Duration(seconds: 4),
///   onDismiss: () => print('Descartado'),
/// )
/// ```
class MyToast extends StatefulWidget {
  const MyToast({
    super.key,
    required this.message,
    this.type = MyToastType.info,
    this.duration = const Duration(seconds: 4),
    this.onDismiss,
    this.actionLabel,
    this.onActionPressed,
  });

  final String message;
  final MyToastType type;
  final Duration duration;
  final VoidCallback? onDismiss;
  final String? actionLabel;
  final VoidCallback? onActionPressed;

  @override
  State<MyToast> createState() => _MyToastState();
}

class _MyToastState extends State<MyToast> with SingleTickerProviderStateMixin {
  late AnimationController _progressController;

  @override
  void initState() {
    super.initState();
    _progressController = AnimationController(
      vsync: this,
      duration: widget.duration,
    );

    _progressController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        widget.onDismiss?.call();
      }
    });

    _progressController.forward();
  }

  @override
  void dispose() {
    _progressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    // Colores y símbolos de tipo
    Color baseColor;
    Color containerColor;
    IconData icon;

    switch (widget.type) {
      case MyToastType.success:
        baseColor = const Color(0xFF10B981); // Emerald
        containerColor = const Color(0xFFECFDF5);
        icon = Icons.check_circle_rounded;
        break;
      case MyToastType.error:
        baseColor = const Color(0xFFEF4444); // Red
        containerColor = const Color(0xFFFEF2F2);
        icon = Icons.error_rounded;
        break;
      case MyToastType.warning:
        baseColor = const Color(0xFFF59E0B); // Amber
        containerColor = const Color(0xFFFFFBEB);
        icon = Icons.warning_rounded;
        break;
      case MyToastType.info:
        baseColor = const Color(0xFF3B82F6); // Blue
        containerColor = const Color(0xFFEFF6FF);
        icon = Icons.info_rounded;
        break;
    }

    final isDark = theme.brightness == Brightness.dark;
    final finalContainerColor = isDark
        ? cs.surfaceContainerHighest.withValues(alpha: 0.8)
        : containerColor;
    final finalTextColor = isDark ? cs.onSurface : Colors.grey[800];

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: finalContainerColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? baseColor.withValues(alpha: 0.3) : baseColor.withValues(alpha: 0.15),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
              child: Row(
                children: [
                  Icon(icon, color: baseColor, size: 22),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      widget.message,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: finalTextColor,
                      ),
                    ),
                  ),
                  if (widget.actionLabel != null && widget.onActionPressed != null) ...[
                    const SizedBox(width: 8),
                    TextButton(
                      onPressed: widget.onActionPressed,
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: Text(
                        widget.actionLabel!,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: baseColor,
                        ),
                      ),
                    ),
                  ],
                  const SizedBox(width: 4),
                  IconButton(
                    icon: const Icon(Icons.close_rounded, size: 18),
                    color: isDark ? cs.onSurface.withValues(alpha: 0.4) : Colors.grey[500],
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    onPressed: widget.onDismiss,
                  ),
                ],
              ),
            ),
            // Barra de progreso animada al pie
            AnimatedBuilder(
              animation: _progressController,
              builder: (context, child) {
                return Align(
                  alignment: Alignment.centerLeft,
                  child: FractionallySizedBox(
                    // La barra decrece a medida que avanza la animación
                    widthFactor: 1.0 - _progressController.value,
                    child: Container(
                      height: 3,
                      color: baseColor.withValues(alpha: 0.7),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
