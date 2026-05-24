import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../core/theme/bloc/theme_cubit.dart';
import '../core/theme/bloc/theme_state.dart';
import '../core/language/bloc/language_bloc.dart';
import '../core/language/language_context.dart';
import 'stat_card.dart';
import 'info_row.dart';
import '../core/layout/responsive_layout.dart';
import 'dev_widgets_list.dart';
import 'architecture_planning/dev_architecture_planner_page.dart';

class DevInfoPanel extends StatelessWidget {
  const DevInfoPanel({super.key});

  @override
  Widget build(BuildContext context) {
    final themeCubit = context.watch<ThemeCubit>();
    final palette = themeCubit.state.palette;
    final isDark = themeCubit.state.themeMode == ThemeMode.dark;
    final currentLanguage = context
        .watch<LanguageCubit>()
        .state
        .language
        .languageCode
        .toUpperCase();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // 1. Hero Card con gradiente dinámico
        Container(
          decoration: BoxDecoration(
            gradient: palette.gradient,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: palette.gradient.colors[0].withValues(alpha: 0.4),
                blurRadius: 16,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      context.tr('hello_user', args: {'name': 'Developer'}),
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      'v1.0.0 Active',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                context.tr('welcome_title'),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                context.tr('welcome_subtitle'),
                style: const TextStyle(color: Colors.white70, fontSize: 14),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        // 1. Diagnósticos / Info de Estados (Grid de Stats)
        LayoutBuilder(
          builder: (context, constraints) {
            final width = constraints.maxWidth;
            int crossAxisCount = 1;
            if (width > 600) {
              crossAxisCount = 3;
            } else if (width > 400) {
              crossAxisCount = 2;
            }

            final double cardWidth =
                (width - ((crossAxisCount - 1) * 16)) / crossAxisCount;

            return Wrap(
              spacing: 16,
              runSpacing: 16,
              children: [
                StatCard(
                  icon: Icons.language,
                  title: context.tr('language_label'),
                  value: currentLanguage == 'ES' ? 'Español' : 'English',
                  width: cardWidth,
                ),
                StatCard(
                  icon: isDark ? Icons.dark_mode : Icons.light_mode,
                  title: context.tr('theme_mode_label'),
                  value: isDark ? 'Dark Mode' : 'Light Mode',
                  width: cardWidth,
                ),
                StatCard(
                  icon: Icons.palette_outlined,
                  title: context.tr('color_palette_label'),
                  value: palette.displayName,
                  width: cardWidth,
                ),
              ],
            );
          },
        ),
        const SizedBox(height: 24),

        // 2. Panel de Información del Sistema
        Card(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.tr('settings_title'),
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  context.tr('settings_desc'),
                  style: TextStyle(
                    color: Theme.of(
                      context,
                    ).colorScheme.onSurface.withValues(alpha: 0.6),
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 16),
                const Divider(),
                const SizedBox(height: 16),

                // Fila de Información de Script
                const InfoRow(
                  icon: Icons.terminal_rounded,
                  label: 'CLI',
                  value: './dev.sh help',
                ),
                const SizedBox(height: 16),

                // Fila de Cobertura
                const InfoRow(
                  icon: Icons.analytics_rounded,
                  label: 'Tests',
                  value: './dev.sh test',
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 24),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Arquitectura de Producto',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Crea la estructura final de la app, define stack de base de datos y recibe recomendaciones automáticas.',
                  style: TextStyle(
                    color: Theme.of(
                      context,
                    ).colorScheme.onSurface.withValues(alpha: 0.6),
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 16),
                FilledButton.icon(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) => const DevArchitecturePlannerPage(),
                      ),
                    );
                  },
                  icon: const Icon(Icons.design_services_rounded),
                  label: const Text('Abrir Blueprint Builder'),
                ),
              ],
            ),
          ),
        ),
        DevWidgetsList(),
        const SizedBox(height: 24),
        ElevatedButton.icon(
          onPressed: () {
            ResponsiveLayoutController.of(context)?.setSelectedIndex(0);
          },
          icon: const Icon(Icons.arrow_back),
          label: Text(context.tr('back_to_home')),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ],
    );
  }
}
