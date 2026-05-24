import 'package:flutter/material.dart';

/// List tile rico con leading, trailing, subtítulo, estado seleccionado y deshabilitado.
///
/// ```dart
/// MyListTile(title: 'Elemento', onTap: () {})
/// MyListTile(title: 'Seleccionado', isSelected: true, leading: Icon(Icons.star))
/// ```
class MyListTile extends StatelessWidget {
  const MyListTile({
    super.key,
    required this.title,
    this.subtitle,
    this.leading,
    this.trailing,
    this.onTap,
    this.isSelected = false,
    this.isDisabled = false,
    this.dense = false,
  });

  final String title;
  final String? subtitle;
  final Widget? leading;
  final Widget? trailing;
  final VoidCallback? onTap;
  final bool isSelected;
  final bool isDisabled;
  final bool dense;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      decoration: BoxDecoration(
        color: isSelected
            ? cs.primary.withValues(alpha: 0.1)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        border: isSelected
            ? Border.all(color: cs.primary.withValues(alpha: 0.25))
            : null,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isDisabled ? null : onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 12,
              vertical: dense ? 8 : 12,
            ),
            child: Row(
              children: [
                if (leading != null) ...[
                  Opacity(opacity: isDisabled ? 0.4 : 1.0, child: leading!),
                  const SizedBox(width: 12),
                ],
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontWeight: isSelected
                              ? FontWeight.bold
                              : FontWeight.w500,
                          fontSize: dense ? 14 : 15,
                          color: isDisabled
                              ? cs.onSurface.withValues(alpha: 0.4)
                              : isSelected
                              ? cs.primary
                              : cs.onSurface,
                        ),
                      ),
                      if (subtitle != null) ...[
                        const SizedBox(height: 2),
                        Text(
                          subtitle!,
                          style: TextStyle(
                            fontSize: 12,
                            color: cs.onSurface.withValues(
                              alpha: isDisabled ? 0.3 : 0.55,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                if (trailing != null) ...[
                  const SizedBox(width: 8),
                  Opacity(opacity: isDisabled ? 0.4 : 1.0, child: trailing!),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
