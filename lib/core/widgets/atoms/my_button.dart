import 'package:flutter/material.dart';

/// Variantes visuales de [MyButton].
enum MyButtonVariant { primary, secondary, ghost, destructive }

/// Botón completo y accesible con 4 variantes, estado de carga, icono y ancho completo.
///
/// ```dart
/// MyButton(label: 'Guardar', onPressed: _save)
/// MyButton(label: 'Eliminar', variant: MyButtonVariant.destructive, icon: Icons.delete)
/// MyButton(label: 'Cargando...', isLoading: true, onPressed: null)
/// ```
class MyButton extends StatelessWidget {
  const MyButton({
    super.key,
    required this.label,
    this.onPressed,
    this.variant = MyButtonVariant.primary,
    this.icon,
    this.isLoading = false,
    this.isFullWidth = false,
    this.size = MyButtonSize.medium,
  });

  final String label;
  final VoidCallback? onPressed;
  final MyButtonVariant variant;
  final IconData? icon;
  final bool isLoading;
  final bool isFullWidth;
  final MyButtonSize size;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isDisabled = onPressed == null && !isLoading;

    final (bg, fg, border) = _resolveColors(cs);
    final (hPad, vPad, fontSize, iconSize, radius) = _resolveSizes();

    final content = Row(
      mainAxisSize: isFullWidth ? MainAxisSize.max : MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (isLoading)
          SizedBox(
            width: iconSize,
            height: iconSize,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: fg,
            ),
          )
        else if (icon != null)
          Icon(icon, size: iconSize, color: isDisabled ? fg.withValues(alpha: 0.4) : fg),
        if ((isLoading || icon != null)) const SizedBox(width: 8),
        Text(
          label,
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.w600,
            color: isDisabled ? fg.withValues(alpha: 0.4) : fg,
            letterSpacing: 0.1,
          ),
        ),
      ],
    );

    final shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(radius),
      side: border != null ? BorderSide(color: border, width: 1.5) : BorderSide.none,
    );

    Widget button;
    if (variant == MyButtonVariant.ghost || variant == MyButtonVariant.secondary) {
      button = TextButton(
        onPressed: isLoading ? null : onPressed,
        style: TextButton.styleFrom(
          backgroundColor: isDisabled ? bg.withValues(alpha: 0.4) : bg,
          padding: EdgeInsets.symmetric(horizontal: hPad, vertical: vPad),
          shape: shape,
        ),
        child: content,
      );
    } else {
      button = ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: isDisabled ? bg.withValues(alpha: 0.5) : bg,
          foregroundColor: fg,
          elevation: 0,
          padding: EdgeInsets.symmetric(horizontal: hPad, vertical: vPad),
          shape: shape,
        ),
        child: content,
      );
    }

    return isFullWidth ? SizedBox(width: double.infinity, child: button) : button;
  }

  (Color, Color, Color?) _resolveColors(ColorScheme cs) {
    switch (variant) {
      case MyButtonVariant.primary:
        return (cs.primary, cs.onPrimary, null);
      case MyButtonVariant.secondary:
        return (cs.primary.withValues(alpha: 0.1), cs.primary, cs.primary.withValues(alpha: 0.3));
      case MyButtonVariant.ghost:
        return (Colors.transparent, cs.onSurface, null);
      case MyButtonVariant.destructive:
        return (const Color(0xFFEF4444), Colors.white, null);
    }
  }

  (double, double, double, double, double) _resolveSizes() {
    switch (size) {
      case MyButtonSize.small:
        return (12, 6, 13, 14, 10);
      case MyButtonSize.medium:
        return (20, 11, 15, 18, 14);
      case MyButtonSize.large:
        return (28, 14, 16, 20, 16);
    }
  }
}

enum MyButtonSize { small, medium, large }
