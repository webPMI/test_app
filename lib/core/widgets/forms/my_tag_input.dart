import 'package:flutter/material.dart';
import '../atoms/my_badge.dart';

/// Campo de entrada de texto interactivo para añadir y eliminar tags.
///
/// ```dart
/// MyTagInput(
///   label: 'Tags de Proyecto',
///   tags: _tags,
///   onTagsChanged: (list) { ... },
/// )
/// ```
class MyTagInput extends StatefulWidget {
  const MyTagInput({
    super.key,
    required this.label,
    required this.tags,
    required this.onTagsChanged,
    this.hintText = 'Añadir tag...',
  });

  final String label;
  final List<String> tags;
  final ValueChanged<List<String>> onTagsChanged;
  final String hintText;

  @override
  State<MyTagInput> createState() => _MyTagInputState();
}

class _MyTagInputState extends State<MyTagInput> {
  final TextEditingController _controller = TextEditingController();

  void _addTag(String val) {
    final cleaned = val.trim();
    if (cleaned.isNotEmpty && !widget.tags.contains(cleaned)) {
      final newList = List<String>.from(widget.tags)..add(cleaned);
      widget.onTagsChanged(newList);
      _controller.clear();
    }
  }

  void _removeTag(String tag) {
    final newList = List<String>.from(widget.tags)..remove(tag);
    widget.onTagsChanged(newList);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

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
            widget.label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: cs.onSurface.withValues(alpha: 0.6),
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: cs.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: cs.onSurface.withValues(alpha: 0.12)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (widget.tags.isNotEmpty) ...[
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: widget.tags.map((tag) {
                      return GestureDetector(
                        onTap: () => _removeTag(tag),
                        child: MyBadge(
                          label: tag,
                          variant: MyBadgeVariant.primary,
                          icon: Icons.close_rounded,
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 8),
                ],
                TextField(
                  controller: _controller,
                  decoration: InputDecoration(
                    hintText: widget.hintText,
                    hintStyle: TextStyle(color: cs.onSurface.withValues(alpha: 0.35)),
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                  ),
                  onSubmitted: _addTag,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
