import 'package:flutter/material.dart';

/// Casilla de verificación (Checkbox) animada y accesible.
///
/// ```dart
/// MyCheckbox(
///   label: 'Acepto los términos y condiciones',
///   value: _accepted,
///   onChanged: (val) { ... },
/// )
/// ```
class MyCheckbox extends StatelessWidget {
  const MyCheckbox({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
    this.subtitle,
    this.isDisabled = false,
  });

  final String label;
  final bool value;
  final ValueChanged<bool?>? onChanged;
  final String? subtitle;
  final bool isDisabled;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: InkWell(
        onTap: isDisabled ? null : () => onChanged?.call(!value),
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 4.0),
          child: Row(
            crossAxisAlignment: subtitle != null ? CrossAxisAlignment.start : CrossAxisAlignment.center,
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                width: 22,
                height: 22,
                decoration: BoxDecoration(
                  color: isDisabled
                      ? cs.onSurface.withValues(alpha: 0.05)
                      : value
                          ? cs.primary
                          : Colors.transparent,
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(
                    color: isDisabled
                        ? cs.onSurface.withValues(alpha: 0.15)
                        : value
                            ? cs.primary
                            : cs.onSurface.withValues(alpha: 0.25),
                    width: 2,
                  ),
                ),
                child: value
                    ? Icon(
                        Icons.check_rounded,
                        size: 16,
                        color: isDisabled ? cs.onSurface.withValues(alpha: 0.3) : cs.onPrimary,
                      )
                    : null,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: isDisabled ? cs.onSurface.withValues(alpha: 0.4) : cs.onSurface,
                      ),
                    ),
                    if (subtitle != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        subtitle!,
                        style: TextStyle(
                          fontSize: 12,
                          color: cs.onSurface.withValues(alpha: 0.5),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
