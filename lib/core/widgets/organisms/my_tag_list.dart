import 'package:flutter/material.dart';
import '../atoms/my_badge.dart';

/// Lista de tags/badges con opción de scroll horizontal o wrap dinámico.
///
/// ```dart
/// MyTagList(
///   tags: ['Flutter', 'Dart', 'Web', 'Mobile'],
///   selectedTags: ['Flutter'],
///   onTagSelected: (tag) { ... },
/// )
/// ```
class MyTagList extends StatelessWidget {
  const MyTagList({
    super.key,
    required this.tags,
    this.selectedTags = const [],
    this.onTagSelected,
    this.isScrollable = true,
  });

  final List<String> tags;
  final List<String> selectedTags;
  final ValueChanged<String>? onTagSelected;
  final bool isScrollable;

  @override
  Widget build(BuildContext context) {
    if (isScrollable) {
      return SizedBox(
        height: 38,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: tags.length,
          separatorBuilder: (_, index) => const SizedBox(width: 8),
          itemBuilder: (context, index) {
            final tag = tags[index];
            return _buildTagItem(tag);
          },
        ),
      );
    }

    return Wrap(
      spacing: 8.0,
      runSpacing: 8.0,
      children: tags.map(_buildTagItem).toList(),
    );
  }

  Widget _buildTagItem(String tag) {
    final isSelected = selectedTags.contains(tag);

    return GestureDetector(
      onTap: onTagSelected != null ? () => onTagSelected!(tag) : null,
      child: MyBadge(
        label: tag,
        variant: isSelected ? MyBadgeVariant.primary : MyBadgeVariant.neutral,
      ),
    );
  }
}
