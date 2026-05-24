import 'package:flutter/material.dart';

/// Ítem de menú contextual con icono, variante destructiva y separador opcional.
///
/// ```dart
/// MyMenuItem(icon: Icons.edit, label: 'Editar', onTap: _edit)
/// MyMenuItem(icon: Icons.delete, label: 'Eliminar', onTap: _delete, isDestructive: true)
/// ```
class MyMenuItem extends StatelessWidget {
  const MyMenuItem({
    super.key,
    required this.icon,
    required this.label,
    this.onTap,
    this.isDestructive = false,
    this.trailing,
    this.subtitle,
    this.isDisabled = false,
  });

  final IconData icon;
  final String label;
  final VoidCallback? onTap;
  final bool isDestructive;
  final Widget? trailing;
  final String? subtitle;
  final bool isDisabled;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final Color resolvedColor = isDestructive
        ? const Color(0xFFEF4444)
        : isDisabled
        ? cs.onSurface.withValues(alpha: 0.35)
        : cs.onSurface;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: isDisabled ? null : onTap,
        borderRadius: BorderRadius.circular(10),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: Row(
            children: [
              Icon(
                icon,
                size: 18,
                color: isDestructive
                    ? const Color(0xFFEF4444)
                    : isDisabled
                    ? cs.onSurface.withValues(alpha: 0.3)
                    : cs.primary,
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
                        color: resolvedColor,
                      ),
                    ),
                    if (subtitle != null)
                      Text(
                        subtitle!,
                        style: TextStyle(
                          fontSize: 11,
                          color: cs.onSurface.withValues(alpha: 0.4),
                        ),
                      ),
                  ],
                ),
              ),
              // ignore: use_null_aware_elements
              if (trailing != null) trailing!,
            ],
          ),
        ),
      ),
    );
  }
}
