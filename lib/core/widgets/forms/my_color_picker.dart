import 'package:flutter/material.dart';

/// Un selector de color interactivo que despliega una cuadrícula de opciones consistentes.
///
/// ```dart
/// MyColorPicker(
///   label: 'Color de Categoría',
///   selectedColor: _color,
///   onColorSelected: (color) { ... },
/// )
/// ```
class MyColorPicker extends StatelessWidget {
  const MyColorPicker({
    super.key,
    required this.label,
    required this.selectedColor,
    required this.onColorSelected,
    this.colors = const [
      Color(0xFF3B82F6), // Azul
      Color(0xFFEF4444), // Rojo
      Color(0xFF10B981), // Verde
      Color(0xFFF59E0B), // Naranja
      Color(0xFF8B5CF6), // Violeta
      Color(0xFFEC4899), // Rosa
      Color(0xFF6B7280), // Gris
      Color(0xFF111827), // Negro/Oscuro
    ],
  });

  final String label;
  final Color selectedColor;
  final ValueChanged<Color> onColorSelected;
  final List<Color> colors;

  void _showColorDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        final cs = Theme.of(context).colorScheme;
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
          content: SingleChildScrollView(
            child: Wrap(
              spacing: 12,
              runSpacing: 12,
              children: colors.map((color) {
                final isSelected = color == selectedColor;
                return GestureDetector(
                  onTap: () {
                    onColorSelected(color);
                    Navigator.pop(context);
                  },
                  child: Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isSelected ? cs.primary : Colors.transparent,
                        width: 3.0,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: isSelected
                        ? const Icon(Icons.check_rounded, color: Colors.white, size: 20)
                        : null,
                  ),
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: InkWell(
        onTap: () => _showColorDialog(context),
        borderRadius: BorderRadius.circular(12),
        child: InputDecorator(
          decoration: InputDecoration(
            labelText: label,
            labelStyle: TextStyle(color: cs.onSurface.withValues(alpha: 0.6), fontSize: 14),
            suffixIcon: Container(
              width: 24,
              height: 24,
              margin: const EdgeInsets.only(right: 12),
              decoration: BoxDecoration(
                color: selectedColor,
                shape: BoxShape.circle,
                border: Border.all(color: cs.onSurface.withValues(alpha: 0.1)),
              ),
            ),
            filled: true,
            fillColor: cs.surface,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: cs.onSurface.withValues(alpha: 0.12)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: cs.onSurface.withValues(alpha: 0.12)),
            ),
          ),
          child: Text(
            '#${selectedColor.toARGB32().toRadixString(16).substring(2).toUpperCase()}',
            style: TextStyle(
              color: cs.onSurface,
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
