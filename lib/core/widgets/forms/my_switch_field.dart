import 'package:flutter/material.dart';

/// Interruptor Toggle (Switch) premium con soporte para etiquetas y descripción.
///
/// ```dart
/// MySwitchField(
///   label: 'Notificaciones Push',
///   subtitle: 'Recibe alertas sobre tu cuenta en tiempo real.',
///   value: _pushEnabled,
///   onChanged: (val) { ... },
/// )
/// ```
class MySwitchField extends StatelessWidget {
  const MySwitchField({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
    this.subtitle,
    this.isDisabled = false,
  });

  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;
  final String? subtitle;
  final bool isDisabled;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: InkWell(
        onTap: isDisabled ? null : () => onChanged(!value),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
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
              const SizedBox(width: 16),
              Switch.adaptive(
                value: value,
                onChanged: isDisabled ? null : onChanged,
                activeThumbColor: cs.primary,
                activeTrackColor: cs.primary.withValues(alpha: 0.3),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
