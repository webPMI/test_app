import 'package:flutter/material.dart';

/// Un campo selector numérico (Stepper) con botones de incremento y decremento.
///
/// ```dart
/// MyStepperField(
///   label: 'Cantidad',
///   value: _quantity,
///   onChanged: (val) { ... },
/// )
/// ```
class MyStepperField extends StatelessWidget {
  const MyStepperField({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
    this.min = 0,
    this.max = 99,
  });

  final String label;
  final int value;
  final ValueChanged<int> onChanged;
  final int min;
  final int max;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: cs.onSurface.withValues(alpha: 0.7),
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: cs.onSurface.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(100),
            ),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.remove_rounded),
                  color: cs.primary,
                  disabledColor: cs.onSurface.withValues(alpha: 0.2),
                  onPressed: value <= min ? null : () => onChanged(value - 1),
                ),
                Container(
                  constraints: const BoxConstraints(minWidth: 40),
                  alignment: Alignment.center,
                  child: Text(
                    value.toString(),
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: cs.onSurface,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add_rounded),
                  color: cs.primary,
                  disabledColor: cs.onSurface.withValues(alpha: 0.2),
                  onPressed: value >= max ? null : () => onChanged(value + 1),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
