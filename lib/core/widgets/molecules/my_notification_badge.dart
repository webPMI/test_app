import 'package:flutter/material.dart';

/// Un wrapper premium que superpone un indicador o contador de notificaciones sobre cualquier widget.
///
/// ```dart
/// MyNotificationBadge(
///   count: 5,
///   child: Icon(Icons.notifications_rounded),
/// )
/// ```
class MyNotificationBadge extends StatelessWidget {
  const MyNotificationBadge({
    super.key,
    required this.child,
    this.count,
    this.showBadge = true,
    this.badgeColor,
    this.textColor,
    this.maxCount = 99,
    this.alignment = const Alignment(0.85, -0.85),
  });

  final Widget child;
  final int? count;
  final bool showBadge;
  final Color? badgeColor;
  final Color? textColor;
  final int maxCount;
  final Alignment alignment;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    final actualBadgeColor = badgeColor ?? cs.error;
    final actualTextColor = textColor ?? cs.onError;

    final displayLabel = count != null
        ? (count! > maxCount ? '$maxCount+' : count!.toString())
        : null;

    final isDot = count == null;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        child,
        if (showBadge)
          Positioned.fill(
            child: Align(
              alignment: alignment,
              child: AnimatedScale(
                scale: showBadge ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeOutBack,
                child: Container(
                  padding: isDot
                      ? const EdgeInsets.all(4.0)
                      : const EdgeInsets.symmetric(horizontal: 5.5, vertical: 2.0),
                  constraints: BoxConstraints(
                    minWidth: isDot ? 8 : 16,
                    minHeight: isDot ? 8 : 16,
                  ),
                  decoration: BoxDecoration(
                    color: actualBadgeColor,
                    shape: isDot ? BoxShape.circle : BoxShape.rectangle,
                    borderRadius: isDot ? null : BorderRadius.circular(100),
                    border: Border.all(
                      color: theme.scaffoldBackgroundColor,
                      width: 1.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.15),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: isDot
                      ? const SizedBox.shrink()
                      : Text(
                          displayLabel!,
                          style: TextStyle(
                            color: actualTextColor,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            height: 1.1,
                          ),
                          textAlign: TextAlign.center,
                        ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
