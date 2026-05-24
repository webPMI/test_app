import 'package:flutter/material.dart';

/// Un indicador horizontal premium de pasos secuenciales para wizard flows.
///
/// ```dart
/// MyStepperSteps(
///   steps: ['Datos', 'Envío', 'Pago'],
///   currentStep: 1,
/// )
/// ```
class MyStepperSteps extends StatelessWidget {
  const MyStepperSteps({
    super.key,
    required this.steps,
    required this.currentStep,
    this.activeColor,
    this.completedColor,
    this.inactiveColor,
  });

  final List<String> steps;
  final int currentStep; // 0-indexed
  final Color? activeColor;
  final Color? completedColor;
  final Color? inactiveColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    final primary = activeColor ?? cs.primary;
    final success = completedColor ?? const Color(0xFF10B981);
    final gray = inactiveColor ?? cs.onSurface.withValues(alpha: 0.15);

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      child: Row(
        children: List.generate(steps.length, (index) {
          final isCompleted = index < currentStep;
          final isActive = index == currentStep;
          final isLast = index == steps.length - 1;

          // Color del paso
          final stepColor = isCompleted
              ? success
              : isActive
                  ? primary
                  : gray;

          return Expanded(
            flex: isLast ? 0 : 1,
            child: Row(
              children: [
                // Círculo del paso
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        color: isActive ? stepColor : Colors.transparent,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: stepColor,
                          width: 2.0,
                        ),
                      ),
                      child: Center(
                        child: isCompleted
                            ? Icon(Icons.check_rounded, color: success, size: 16)
                            : Text(
                                (index + 1).toString(),
                                style: TextStyle(
                                  color: isActive
                                      ? cs.onPrimary
                                      : cs.onSurface.withValues(alpha: 0.6),
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      steps[index],
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                        color: isActive
                            ? cs.onSurface
                            : cs.onSurface.withValues(alpha: 0.5),
                      ),
                    ),
                  ],
                ),
                // Línea conectora
                if (!isLast)
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 16.0, left: 8.0, right: 8.0),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        height: 2.0,
                        color: index < currentStep ? success : gray,
                      ),
                    ),
                  ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
