import 'package:flutter/material.dart';
import 'custom_app_bar.dart';
import 'custom_drawer.dart';
import 'reactive_body.dart';

class ResponsiveLayoutController extends InheritedWidget {
  const ResponsiveLayoutController({
    super.key,
    required this.selectedIndex,
    required this.setSelectedIndex,
    required super.child,
  });

  final int selectedIndex;
  final ValueChanged<int> setSelectedIndex;

  static ResponsiveLayoutController? of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<ResponsiveLayoutController>();
  }

  @override
  bool updateShouldNotify(ResponsiveLayoutController oldWidget) {
    return selectedIndex != oldWidget.selectedIndex;
  }
}

class ResponsiveLayout extends StatefulWidget {
  const ResponsiveLayout({
    super.key,
    required this.pages,
    this.initialIndex = 0,
  });

  final List<Widget> pages;
  final int initialIndex;

  @override
  State<ResponsiveLayout> createState() => _ResponsiveLayoutState();
}

class _ResponsiveLayoutState extends State<ResponsiveLayout> {
  late int _selectedIndex;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;
  }

  void _handleSelection(int index) {
    if (_selectedIndex == index) return;
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isDesktop = width >= 1024;

    final activeIndex = _selectedIndex < widget.pages.length
        ? _selectedIndex
        : 0;
    final activePage = widget.pages[activeIndex];

    final layoutContent = isDesktop
        ? SafeArea(
            child: Scaffold(
              body: Row(
                children: [
                  CustomDrawer(
                    selectedIndex: activeIndex,
                    onDestinationSelected: _handleSelection,
                    isPermanent: true,
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        CustomAppBar(isDesktop: true),
                        Expanded(child: ReactiveBody(child: activePage)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )
        : SafeArea(
            child: Scaffold(
              appBar: CustomAppBar(isDesktop: false),
              drawer: CustomDrawer(
                selectedIndex: activeIndex,
                onDestinationSelected: (index) {
                  _handleSelection(index);
                  // Close mobile drawer
                  if (Navigator.canPop(context)) {
                    Navigator.pop(context);
                  }
                },
              ),
              body: ReactiveBody(child: activePage),
            ),
          );

    return ResponsiveLayoutController(
      selectedIndex: activeIndex,
      setSelectedIndex: _handleSelection,
      child: layoutContent,
    );
  }
}
