import 'package:flutter/material.dart';

class MyBottomBarItem {
  const MyBottomBarItem({
    required this.icon,
    required this.label,
    this.selectedIcon,
  });

  final IconData icon;
  final String label;
  final IconData? selectedIcon;
}

/// Una barra de navegación inferior flotante premium con micro-animaciones de escala.
///
/// ```dart
/// MyBottomBar(
///   items: [
///     MyBottomBarItem(icon: Icons.home_rounded, label: 'Inicio'),
///     MyBottomBarItem(icon: Icons.search_rounded, label: 'Buscar'),
///     MyBottomBarItem(icon: Icons.person_rounded, label: 'Perfil'),
///   ],
///   currentIndex: _index,
///   onTap: (idx) { ... },
/// )
/// ```
class MyBottomBar extends StatelessWidget {
  const MyBottomBar({
    super.key,
    required this.items,
    required this.currentIndex,
    required this.onTap,
    this.backgroundColor,
    this.selectedColor,
    this.unselectedColor,
    this.floating = true,
  });

  final List<MyBottomBarItem> items;
  final int currentIndex;
  final ValueChanged<int> onTap;
  final Color? backgroundColor;
  final Color? selectedColor;
  final Color? unselectedColor;
  final bool floating;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    final actualBg = backgroundColor ?? (isDark ? cs.surfaceContainer : Colors.white);
    final activeColor = selectedColor ?? cs.primary;
    final inactiveColor = unselectedColor ?? cs.onSurface.withValues(alpha: 0.4);

    final barWidget = Container(
      height: 72,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: actualBg,
        borderRadius: floating ? BorderRadius.circular(24) : null,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: floating ? 0.08 : 0.04),
            blurRadius: floating ? 16 : 8,
            offset: Offset(0, floating ? 6 : -2),
          ),
        ],
        border: floating
            ? Border.all(color: cs.onSurface.withValues(alpha: 0.05))
            : Border(top: BorderSide(color: cs.onSurface.withValues(alpha: 0.08))),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(items.length, (index) {
          final item = items[index];
          final isSelected = index == currentIndex;
          final color = isSelected ? activeColor : inactiveColor;

          return Expanded(
            child: InkWell(
              onTap: () => onTap(index),
              borderRadius: BorderRadius.circular(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AnimatedScale(
                    scale: isSelected ? 1.2 : 1.0,
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.easeOutBack,
                    child: Icon(
                      isSelected ? (item.selectedIcon ?? item.icon) : item.icon,
                      color: color,
                      size: 24,
                    ),
                  ),
                  const SizedBox(height: 4),
                  AnimatedDefaultTextStyle(
                    duration: const Duration(milliseconds: 200),
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                      color: color,
                    ),
                    child: Text(item.label),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );

    if (floating) {
      return Padding(
        padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20, top: 8),
        child: SafeArea(
          child: barWidget,
        ),
      );
    }

    return barWidget;
  }
}
