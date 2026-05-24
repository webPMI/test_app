import 'package:flutter/material.dart';

enum MyDialogType { success, error, warning, info }

/// Un cuadro de diálogo emergente premium con variantes de estado.
///
/// ```dart
/// showDialog(
///   context: context,
///   builder: (context) => MyDialog(
///     title: 'Éxito',
///     description: 'La transacción se completó correctamente.',
///     type: MyDialogType.success,
///     confirmLabel: 'Aceptar',
///     onConfirm: () => Navigator.pop(context),
///   ),
/// );
/// ```
class MyDialog extends StatelessWidget {
  const MyDialog({
    super.key,
    required this.title,
    required this.description,
    this.type = MyDialogType.info,
    this.confirmLabel = 'Aceptar',
    this.cancelLabel,
    this.onConfirm,
    this.onCancel,
    this.customContent,
  });

  final String title;
  final String description;
  final MyDialogType type;
  final String confirmLabel;
  final String? cancelLabel;
  final VoidCallback? onConfirm;
  final VoidCallback? onCancel;
  final Widget? customContent;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    // Colores y símbolos según tipo
    Color baseColor;
    IconData icon;

    switch (type) {
      case MyDialogType.success:
        baseColor = const Color(0xFF10B981); // Emerald
        icon = Icons.check_circle_outline_rounded;
        break;
      case MyDialogType.error:
        baseColor = const Color(0xFFEF4444); // Red
        icon = Icons.error_outline_rounded;
        break;
      case MyDialogType.warning:
        baseColor = const Color(0xFFF59E0B); // Amber
        icon = Icons.warning_amber_rounded;
        break;
      case MyDialogType.info:
        baseColor = const Color(0xFF3B82F6); // Blue
        icon = Icons.info_outline_rounded;
        break;
    }

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      elevation: 12,
      backgroundColor: theme.brightness == Brightness.dark ? cs.surfaceContainerHigh : Colors.white,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.topCenter,
        children: [
          // Icono flotante superior
          Positioned(
            top: -30,
            child: Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: baseColor,
                shape: BoxShape.circle,
                border: Border.all(
                  color: theme.brightness == Brightness.dark ? cs.surfaceContainerHigh : Colors.white,
                  width: 4,
                ),
                boxShadow: [
                  BoxShadow(
                    color: baseColor.withValues(alpha: 0.35),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Icon(icon, color: Colors.white, size: 30),
            ),
          ),
          // Cuerpo del diálogo
          Padding(
            padding: const EdgeInsets.only(top: 48, left: 24, right: 24, bottom: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: cs.onSurface,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 13,
                    color: cs.onSurface.withValues(alpha: 0.6),
                    height: 1.4,
                  ),
                  textAlign: TextAlign.center,
                ),
                if (customContent != null) ...[
                  const SizedBox(height: 16),
                  customContent!,
                ],
                const SizedBox(height: 24),
                // Botones de acción
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    if (cancelLabel != null)
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            Navigator.pop(context);
                            onCancel?.call();
                          },
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            side: BorderSide(color: cs.onSurface.withValues(alpha: 0.12)),
                          ),
                          child: Text(
                            cancelLabel!,
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: cs.onSurface.withValues(alpha: 0.7),
                            ),
                          ),
                        ),
                      ),
                    if (cancelLabel != null) const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                          onConfirm?.call();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: baseColor,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          elevation: 0,
                        ),
                        child: Text(
                          confirmLabel,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
