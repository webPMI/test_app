import 'package:flutter/material.dart';

/// Barra de progreso animada con etiqueta, porcentaje y color personalizable.
///
/// ```dart
/// MyProgressBar(value: 0.72, label: 'Completado')
/// MyProgressBar(value: 0.45, label: 'Carga', showPercent: true, color: Colors.orange)
/// MyProgressBar(value: null)  // Modo indeterminado
/// ```
class MyProgressBar extends StatelessWidget {
  const MyProgressBar({
    super.key,
    required this.value,
    this.label,
    this.showPercent = false,
    this.height = 8.0,
    this.color,
    this.backgroundColor,
  });

  /// Valor entre 0.0 y 1.0. Si es null, muestra progreso indeterminado.
  final double? value;
  final String? label;
  final bool showPercent;
  final double height;
  final Color? color;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final resolvedColor = color ?? cs.primary;
    final resolvedBg =
        backgroundColor ?? resolvedColor.withValues(alpha: isDark ? 0.2 : 0.12);

    final hasLabel = label != null || showPercent;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (hasLabel)
          Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (label != null)
                  Text(
                    label!,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: cs.onSurface.withValues(alpha: 0.7),
                    ),
                  ),
                if (showPercent && value != null)
                  Text(
                    '${(value! * 100).round()}%',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: resolvedColor,
                    ),
                  ),
              ],
            ),
          ),
        ClipRRect(
          borderRadius: BorderRadius.circular(height),
          child: Container(
            height: height,
            color: resolvedBg,
            child: value == null
                ? LinearProgressIndicator(
                    backgroundColor: Colors.transparent,
                    valueColor: AlwaysStoppedAnimation(resolvedColor),
                  )
                : TweenAnimationBuilder<double>(
                    tween: Tween(begin: 0, end: value!.clamp(0.0, 1.0)),
                    duration: const Duration(milliseconds: 600),
                    curve: Curves.easeOutCubic,
                    builder: (_, val, _) => FractionallySizedBox(
                      alignment: Alignment.centerLeft,
                      widthFactor: val,
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [resolvedColor, cs.secondary],
                          ),
                          borderRadius: BorderRadius.circular(height),
                        ),
                      ),
                    ),
                  ),
          ),
        ),
      ],
    );
  }
}
