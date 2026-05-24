import 'package:flutter/material.dart';

class MyBreadcrumbItem {
  const MyBreadcrumbItem({
    required this.label,
    this.onTap,
  });

  final String label;
  final VoidCallback? onTap;
}

/// Un rastro de navegación (Breadcrumbs) premium para indicar la ruta actual.
///
/// ```dart
/// MyBreadcrumbs(
///   items: [
///     MyBreadcrumbItem(label: 'Inicio', onTap: () {}),
///     MyBreadcrumbItem(label: 'Ajustes', onTap: () {}),
///     MyBreadcrumbItem(label: 'Seguridad'),
///   ],
/// )
/// ```
class MyBreadcrumbs extends StatelessWidget {
  const MyBreadcrumbs({
    super.key,
    required this.items,
    this.separator,
    this.style,
    this.activeStyle,
  });

  final List<MyBreadcrumbItem> items;
  final Widget? separator;
  final TextStyle? style;
  final TextStyle? activeStyle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    final defaultStyle = style ?? TextStyle(
      fontSize: 13,
      fontWeight: FontWeight.w500,
      color: cs.onSurface.withValues(alpha: 0.5),
    );

    final defaultActiveStyle = activeStyle ?? TextStyle(
      fontSize: 13,
      fontWeight: FontWeight.bold,
      color: cs.primary,
    );

    final defaultSeparator = separator ?? Icon(
      Icons.chevron_right_rounded,
      size: 16,
      color: cs.onSurface.withValues(alpha: 0.3),
    );

    final List<Widget> widgets = [];

    for (int i = 0; i < items.length; i++) {
      final item = items[i];
      final isLast = i == items.length - 1;

      widgets.add(
        isLast || item.onTap == null
            ? Text(
                item.label,
                style: isLast ? defaultActiveStyle : defaultStyle,
              )
            : InkWell(
                onTap: item.onTap,
                borderRadius: BorderRadius.circular(4),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 2.0),
                  child: Text(
                    item.label,
                    style: defaultStyle,
                  ),
                ),
              ),
      );

      if (!isLast) {
        widgets.add(
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: defaultSeparator,
          ),
        );
      }
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: widgets,
      ),
    );
  }
}
