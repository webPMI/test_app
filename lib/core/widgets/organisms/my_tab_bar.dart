import 'package:flutter/material.dart';

/// Un selector de pestañas (Tab Bar) con estilo premium de píldora/burbuja.
///
/// ```dart
/// MyTabBar(
///   controller: _tabController,
///   tabs: [
///     Tab(text: 'General'),
///     Tab(text: 'Seguridad'),
///     Tab(text: 'Notificaciones'),
///   ],
/// )
/// ```
class MyTabBar extends StatelessWidget implements PreferredSizeWidget {
  const MyTabBar({
    super.key,
    required this.controller,
    required this.tabs,
    this.height = 48.0,
  });

  final TabController controller;
  final List<Tab> tabs;
  final double height;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Container(
      height: height,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: cs.onSurface.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(100),
      ),
      child: TabBar(
        controller: controller,
        tabs: tabs,
        splashBorderRadius: BorderRadius.circular(100),
        indicatorSize: TabBarIndicatorSize.tab,
        dividerColor: Colors.transparent,
        indicator: BoxDecoration(
          color: cs.surface,
          borderRadius: BorderRadius.circular(100),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        labelColor: cs.primary,
        unselectedLabelColor: cs.onSurface.withValues(alpha: 0.6),
        labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
        unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w500, fontSize: 13),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(height + 16);
}
