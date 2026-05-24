import 'package:flutter/material.dart';

/// Grupo de botones de selección exclusiva (Radio Group).
///
/// ```dart
/// MyRadioGroup<String>(
///   title: 'Género',
///   options: ['Masculino', 'Femenino', 'Otro'],
///   selectedValue: _selectedGender,
///   onChanged: (val) { ... },
/// )
/// ```
class MyRadioGroup<T> extends StatelessWidget {
  const MyRadioGroup({
    super.key,
    required this.options,
    required this.selectedValue,
    required this.onChanged,
    this.title,
    this.isHorizontal = false,
  });

  final String? title;
  final List<T> options;
  final T selectedValue;
  final ValueChanged<T> onChanged;
  final bool isHorizontal;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    final items = options.map((option) {
      final isSelected = option == selectedValue;
      return InkWell(
        onTap: () => onChanged(option),
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isSelected ? cs.primary : cs.onSurface.withValues(alpha: 0.25),
                    width: 2,
                  ),
                ),
                child: Center(
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    width: isSelected ? 10 : 0,
                    height: isSelected ? 10 : 0,
                    decoration: BoxDecoration(
                      color: cs.primary,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                option.toString(),
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  color: cs.onSurface,
                ),
              ),
            ],
          ),
        ),
      );
    }).toList();

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null) ...[
            Text(
              title!,
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: cs.onSurface.withValues(alpha: 0.6),
              ),
            ),
            const SizedBox(height: 8),
          ],
          if (isHorizontal)
            Wrap(
              spacing: 12,
              runSpacing: 8,
              children: items,
            )
          else
            Column(
              children: items,
            ),
        ],
      ),
    );
  }
}
