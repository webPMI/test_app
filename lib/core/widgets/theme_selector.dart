import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../theme/bloc/theme_cubit.dart';
import '../theme/bloc/theme_state.dart';

enum ThemeSelectorType { dots, dropdown, grid }

/// Un selector de temas visual en forma de círculos de colores, menú desplegable o cuadrícula interactiva.
class ThemeSelector extends StatelessWidget {
  const ThemeSelector({
    super.key,
    this.type = ThemeSelectorType.dots,
  });

  final ThemeSelectorType type;

  @override
  Widget build(BuildContext context) {
    final themeCubit = context.watch<ThemeCubit>();
    final currentPalette = themeCubit.state.palette;
    final isDark = themeCubit.state.themeMode == ThemeMode.dark;
    final cs = Theme.of(context).colorScheme;

    switch (type) {
      case ThemeSelectorType.dropdown:
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildDropdown(themeCubit, currentPalette, isDark, cs),
            const SizedBox(width: 12),
            _buildBrightnessToggle(themeCubit, isDark),
          ],
        );
      case ThemeSelectorType.grid:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildGrid(themeCubit, currentPalette, isDark, cs),
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(
                  isDark ? Icons.dark_mode_rounded : Icons.light_mode_rounded,
                  size: 20,
                  color: cs.onSurface.withValues(alpha: 0.6),
                ),
                const SizedBox(width: 8),
                Text(
                  isDark ? 'Modo Oscuro Activo' : 'Modo Claro Activo',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: cs.onSurface.withValues(alpha: 0.7),
                  ),
                ),
                const Spacer(),
                Switch.adaptive(
                  value: isDark,
                  activeThumbColor: cs.primary,
                  onChanged: (_) => themeCubit.toggleTheme(),
                ),
              ],
            ),
          ],
        );
      case ThemeSelectorType.dots:
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.black.withValues(alpha: 0.03),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: isDark ? Colors.white.withValues(alpha: 0.1) : Colors.black.withValues(alpha: 0.05),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: ThemePalette.values.map((palette) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: _ThemeDot(
                          color: palette.primaryColor,
                          isSelected: currentPalette == palette,
                          onTap: () => themeCubit.setPalette(palette),
                          tooltip: palette.displayName,
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
              Container(
                height: 20,
                width: 1,
                margin: const EdgeInsets.symmetric(horizontal: 8),
                color: isDark ? Colors.white.withValues(alpha: 0.2) : Colors.black.withValues(alpha: 0.1),
              ),
              _buildBrightnessToggle(themeCubit, isDark),
            ],
          ),
        );
    }
  }

  Widget _buildDropdown(ThemeCubit themeCubit, ThemePalette currentPalette, bool isDark, ColorScheme cs) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.black.withValues(alpha: 0.03),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? Colors.white.withValues(alpha: 0.1) : Colors.black.withValues(alpha: 0.05),
        ),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<ThemePalette>(
          value: currentPalette,
          icon: Icon(Icons.arrow_drop_down_rounded, color: cs.primary),
          borderRadius: BorderRadius.circular(16),
          dropdownColor: isDark ? const Color(0xFF1E293B) : Colors.white,
          onChanged: (palette) {
            if (palette != null) themeCubit.setPalette(palette);
          },
          items: ThemePalette.values.map((palette) {
            return DropdownMenuItem<ThemePalette>(
              value: palette,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 14,
                    height: 14,
                    decoration: BoxDecoration(
                      color: palette.primaryColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    palette.displayName,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: cs.onSurface,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildGrid(ThemeCubit themeCubit, ThemePalette currentPalette, bool isDark, ColorScheme cs) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: ThemePalette.values.map((palette) {
        final isSelected = palette == currentPalette;
        return GestureDetector(
          onTap: () => themeCubit.setPalette(palette),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              gradient: palette.gradient,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isSelected ? Colors.white : Colors.transparent,
                width: 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: palette.primaryColor.withValues(alpha: isSelected ? 0.35 : 0.1),
                  blurRadius: isSelected ? 8 : 2,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  palette.displayName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    shadows: [
                      Shadow(
                        color: Colors.black26,
                        blurRadius: 3,
                        offset: Offset(0, 1),
                      ),
                    ],
                  ),
                ),
                if (isSelected) ...[
                  const SizedBox(width: 4),
                  const Icon(Icons.check_circle_rounded, color: Colors.white, size: 14),
                ],
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildBrightnessToggle(ThemeCubit themeCubit, bool isDark) {
    return IconButton(
      icon: Icon(isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded),
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
      style: IconButton.styleFrom(
        backgroundColor: isDark ? Colors.white.withValues(alpha: 0.1) : Colors.black.withValues(alpha: 0.05),
      ),
      onPressed: () => themeCubit.toggleTheme(),
    );
  }
}

class _ThemeDot extends StatelessWidget {
  const _ThemeDot({
    required this.color,
    required this.isSelected,
    required this.onTap,
    required this.tooltip,
  });

  final Color color;
  final bool isSelected;
  final VoidCallback onTap;
  final String tooltip;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOutBack,
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            border: Border.all(
              color: isSelected 
                  ? Colors.white 
                  : Colors.transparent,
              width: 2.5,
            ),
            boxShadow: [
              BoxShadow(
                color: color.withValues(alpha: isSelected ? 0.6 : 0.2),
                blurRadius: isSelected ? 12 : 4,
                spreadRadius: isSelected ? 2 : 0,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: AnimatedScale(
            scale: isSelected ? 1.0 : 0.0,
            duration: const Duration(milliseconds: 200),
            child: const Icon(
              Icons.check, 
              color: Colors.white, 
              size: 14,
            ),
          ),
        ),
      ),
    );
  }
}
