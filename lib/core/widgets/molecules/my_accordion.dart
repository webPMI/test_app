import 'package:flutter/material.dart';

/// Un acordeón colapsable premium con animaciones suaves de tamaño e ícono rotativo.
///
/// ```dart
/// MyAccordion(
///   title: '¿Cómo funciona?',
///   child: Text('Funciona de forma totalmente reactiva.'),
/// )
/// ```
class MyAccordion extends StatefulWidget {
  const MyAccordion({
    super.key,
    required this.title,
    required this.child,
    this.initiallyExpanded = false,
    this.isExpanded,
    this.onToggle,
    this.titleStyle,
    this.cardDecoration,
  });

  final String title;
  final Widget child;
  final bool initiallyExpanded;
  final bool? isExpanded;
  final ValueChanged<bool>? onToggle;
  final TextStyle? titleStyle;
  final BoxDecoration? cardDecoration;

  @override
  State<MyAccordion> createState() => _MyAccordionState();
}

class _MyAccordionState extends State<MyAccordion> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _heightFactor;
  late Animation<double> _iconRotation;
  bool _isExpanded = false;

  bool get _effectiveExpanded => widget.isExpanded ?? _isExpanded;

  @override
  void initState() {
    super.initState();
    _isExpanded = widget.initiallyExpanded;
    _controller = AnimationController(
      duration: const Duration(milliseconds: 250),
      vsync: this,
    );
    _heightFactor = _controller.drive(CurveTween(curve: Curves.easeInOut));
    _iconRotation = _controller.drive(Tween<double>(begin: 0.0, end: 0.5).chain(
      CurveTween(curve: Curves.easeInOut),
    ));

    if (_effectiveExpanded) {
      _controller.value = 1.0;
    }
  }

  @override
  void didUpdateWidget(covariant MyAccordion oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isExpanded != null && widget.isExpanded != oldWidget.isExpanded) {
      if (widget.isExpanded!) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTap() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_effectiveExpanded) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
    widget.onToggle?.call(_effectiveExpanded);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    final defaultDecoration = BoxDecoration(
      color: cs.surface,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: cs.onSurface.withValues(alpha: 0.08)),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.02),
          blurRadius: 6,
          offset: const Offset(0, 3),
        ),
      ],
    );

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6.0),
      decoration: widget.cardDecoration ?? defaultDecoration,
      child: Column(
        children: [
          InkWell(
            onTap: _handleTap,
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      widget.title,
                      style: widget.titleStyle ?? TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: cs.onSurface,
                      ),
                    ),
                  ),
                  RotationTransition(
                    turns: _iconRotation,
                    child: Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: cs.primary,
                    ),
                  ),
                ],
              ),
            ),
          ),
          AnimatedBuilder(
            animation: _controller.view,
            builder: (context, child) {
              return ClipRect(
                child: Align(
                  heightFactor: _heightFactor.value,
                  child: child,
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0),
              child: widget.child,
            ),
          ),
        ],
      ),
    );
  }
}
