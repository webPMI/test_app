import 'package:flutter/material.dart';
import '../atoms/my_badge.dart';

/// Un selector múltiple o único basado en chips interactivos.
///
/// ```dart
/// MyChipSelector<String>(
///   label: 'Temas de Interés',
///   options: ['Música', 'Tecnología', 'Deportes'],
///   selectedOptions: _selectedTopics,
///   onChanged: (list) { ... },
/// )
/// ```
class MyChipSelector<T> extends StatelessWidget {
  const MyChipSelector({
    super.key,
    required this.label,
    required this.options,
    required this.selectedOptions,
    required this.onChanged,
  });

  final String label;
  final List<T> options;
  final List<T> selectedOptions;
  final ValueChanged<List<T>> onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: cs.onSurface.withValues(alpha: 0.6),
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: options.map((option) {
              final isSelected = selectedOptions.contains(option);
              return GestureDetector(
                onTap: () {
                  final newList = List<T>.from(selectedOptions);
                  if (isSelected) {
                    newList.remove(option);
                  } else {
                    newList.add(option);
                  }
                  onChanged(newList);
                },
                child: MyBadge(
                  label: option.toString(),
                  variant: isSelected ? MyBadgeVariant.primary : MyBadgeVariant.neutral,
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
