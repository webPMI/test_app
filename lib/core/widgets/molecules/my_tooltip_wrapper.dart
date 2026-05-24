import 'package:flutter/material.dart';

/// Un envoltorio de tooltip con diseño premium adaptado al tema.
///
/// Soporta disparadores por hover o tap/longpress y ofrece una presentación visual
/// superior al tooltip por defecto de Flutter.
///
/// ```dart
/// MyTooltipWrapper(
///   message: 'Información confidencial',
///   child: Icon(Icons.info_outline),
/// )
/// ```
class MyTooltipWrapper extends StatelessWidget {
  const MyTooltipWrapper({
    super.key,
    required this.message,
    required this.child,
    this.preferBelow = false,
    this.triggerMode,
    this.waitDuration,
    this.showDuration,
  });

  final String message;
  final Widget child;
  final bool preferBelow;
  final TooltipTriggerMode? triggerMode;
  final Duration? waitDuration;
  final Duration? showDuration;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // Colores premium para el Tooltip
    final backgroundColor = isDark 
        ? theme.colorScheme.surfaceContainerHighest
        : theme.colorScheme.onSurface;
    final textColor = isDark 
        ? theme.colorScheme.onSurface
        : theme.colorScheme.surface;

    return Tooltip(
      message: message,
      preferBelow: preferBelow,
      triggerMode: triggerMode,
      waitDuration: waitDuration,
      showDuration: showDuration,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(
          color: theme.colorScheme.onSurface.withValues(alpha: 0.08),
          width: 1,
        ),
      ),
      textStyle: TextStyle(
        color: textColor,
        fontSize: 12,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.2,
      ),
      child: child,
    );
  }
}
