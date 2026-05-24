import 'package:flutter/material.dart';

/// Deslizador numérico continuo o discreto con valor visible en tiempo real.
///
/// ```dart
/// MySliderField(
///   label: 'Volumen',
///   min: 0,
///   max: 100,
///   value: _volume,
///   onChanged: (val) { ... },
/// )
/// ```
class MySliderField extends StatelessWidget {
  const MySliderField({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
    this.min = 0.0,
    this.max = 1.0,
    this.divisions,
    this.valueSuffix = '',
  });

  final String label;
  final double value;
  final ValueChanged<double> onChanged;
  final double min;
  final double max;
  final int? divisions;
  final String valueSuffix;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: cs.onSurface.withValues(alpha: 0.7),
                  ),
                ),
              ),
              Text(
                '${value.toStringAsFixed(divisions == null ? 1 : 0)}$valueSuffix',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: cs.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          SliderTheme(
            data: SliderThemeData(
              trackHeight: 4,
              activeTrackColor: cs.primary,
              inactiveTrackColor: cs.primary.withValues(alpha: 0.15),
              thumbColor: cs.primary,
              overlayColor: cs.primary.withValues(alpha: 0.12),
              valueIndicatorColor: cs.primary,
            ),
            child: Slider(
              value: value,
              min: min,
              max: max,
              divisions: divisions,
              onChanged: onChanged,
            ),
          ),
        ],
      ),
    );
  }
}
