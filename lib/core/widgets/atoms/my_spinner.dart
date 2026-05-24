import 'dart:math' as math;
import 'package:flutter/material.dart';

enum MySpinnerType { circular, dots }

/// Un indicador de carga premium que soporta modo circular y de puntos rebotantes.
///
/// ```dart
/// MySpinner(
///   type: MySpinnerType.dots,
///   size: 40.0,
///   color: Colors.blue,
/// )
/// ```
class MySpinner extends StatefulWidget {
  const MySpinner({
    super.key,
    this.type = MySpinnerType.circular,
    this.size = 36.0,
    this.color,
  });

  final MySpinnerType type;
  final double size;
  final Color? color;

  @override
  State<MySpinner> createState() => _MySpinnerState();
}

class _MySpinnerState extends State<MySpinner> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spinnerColor = widget.color ?? theme.colorScheme.primary;

    if (widget.type == MySpinnerType.dots) {
      return SizedBox(
        width: widget.size * 2,
        height: widget.size,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: List.generate(3, (index) {
            return AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                // Generamos un desfase (delay) para cada punto de 0.2
                final delay = index * 0.2;
                double value = _controller.value - delay;
                if (value < 0) value += 1.0;
                
                // Usamos math.sin para un rebote senoidal suave de 0 a pi (primera mitad del ciclo)
                double bounce = 0.0;
                if (value < 0.5) {
                  bounce = math.sin(value * 2.0 * math.pi);
                }
                final offset = -bounce * (widget.size * 0.4);

                return Transform.translate(
                  offset: Offset(0, offset),
                  child: Container(
                    width: widget.size * 0.35,
                    height: widget.size * 0.35,
                    decoration: BoxDecoration(
                      color: spinnerColor.withValues(
                        alpha: 0.4 + (0.6 * bounce),
                      ),
                      shape: BoxShape.circle,
                    ),
                  ),
                );
              },
            );
          }),
        ),
      );
    }

    // Circular style
    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(spinnerColor),
        strokeWidth: 3.5,
        backgroundColor: spinnerColor.withValues(alpha: 0.1),
      ),
    );
  }
}
