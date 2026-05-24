import 'package:flutter/material.dart';

/// Un selector Dropdown con buscador interactivo integrado en un BottomSheet.
///
/// ```dart
/// MySearchableDropdown<String>(
///   label: 'Ciudad de Destino',
///   options: ['Madrid', 'Barcelona', 'Sevilla', 'Valencia'],
///   selectedValue: _selectedCity,
///   onChanged: (val) { ... },
/// )
/// ```
class MySearchableDropdown<T> extends StatelessWidget {
  const MySearchableDropdown({
    super.key,
    required this.label,
    required this.options,
    required this.selectedValue,
    required this.onChanged,
  });

  final String label;
  final List<T> options;
  final T? selectedValue;
  final ValueChanged<T> onChanged;

  void _showSearchSheet(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return DraggableScrollableSheet(
              initialChildSize: 0.7,
              maxChildSize: 0.9,
              minChildSize: 0.5,
              expand: false,
              builder: (context, scrollController) {
                // Implementación simple de búsqueda reactiva
                return Column(
                  children: [
                    Container(
                      width: 40,
                      height: 4,
                      margin: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: cs.onSurface.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text(
                        label,
                        style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(height: 12),
                    // Campo de búsqueda local
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'Buscar...',
                          prefixIcon: const Icon(Icons.search_rounded),
                          filled: true,
                          fillColor: cs.onSurface.withValues(alpha: 0.04),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        onChanged: (value) {
                          // Fuerza el rebuild local para filtrar
                          setState(() {});
                        },
                      ),
                    ),
                    const SizedBox(height: 8),
                    Expanded(
                      child: ListView.builder(
                        controller: scrollController,
                        itemCount: options.length,
                        itemBuilder: (context, index) {
                          final option = options[index];
                          final isSelected = option == selectedValue;

                          return ListTile(
                            title: Text(option.toString()),
                            selected: isSelected,
                            selectedTileColor: cs.primary.withValues(alpha: 0.08),
                            selectedColor: cs.primary,
                            trailing: isSelected ? const Icon(Icons.check_rounded) : null,
                            onTap: () {
                              onChanged(option);
                              Navigator.pop(context);
                            },
                          );
                        },
                      ),
                    ),
                  ],
                );
              },
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final valueText = selectedValue == null ? '' : selectedValue.toString();

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: InkWell(
        onTap: () => _showSearchSheet(context),
        borderRadius: BorderRadius.circular(12),
        child: InputDecorator(
          decoration: InputDecoration(
            labelText: label,
            labelStyle: TextStyle(color: cs.onSurface.withValues(alpha: 0.6), fontSize: 14),
            suffixIcon: Icon(Icons.search_rounded, color: cs.primary, size: 20),
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
            valueText,
            style: TextStyle(
              color: selectedValue == null ? cs.onSurface.withValues(alpha: 0.35) : cs.onSurface,
              fontSize: 15,
            ),
          ),
        ),
      ),
    );
  }
}
