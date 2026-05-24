import 'package:flutter/material.dart';

/// Barra de calificación interactiva (Rating Bar).
///
/// ```dart
/// MyRatingBar(
///   rating: _rating,
///   onChanged: (val) { ... },
/// )
/// ```
class MyRatingBar extends StatelessWidget {
  const MyRatingBar({
    super.key,
    required this.rating,
    required this.onChanged,
    this.maxRating = 5,
    this.icon = Icons.star_rounded,
    this.size = 32.0,
  });

  final int rating;
  final ValueChanged<int> onChanged;
  final int maxRating;
  final IconData icon;
  final double size;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(maxRating, (index) {
          final isSelected = index < rating;
          return IconButton(
            icon: Icon(
              icon,
              color: isSelected ? Colors.amber : cs.onSurface.withValues(alpha: 0.15),
              size: size,
            ),
            onPressed: () => onChanged(index + 1),
            padding: const EdgeInsets.symmetric(horizontal: 2.0),
            constraints: const BoxConstraints(),
            splashRadius: size * 0.6,
          );
        }),
      ),
    );
  }
}
