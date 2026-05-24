import 'package:flutter/material.dart';
import 'package:test_demo_app/dev/dev_tile.dart';

import '../core/widgets/my_text.dart';
import '../core/widgets/language_selector.dart';
import '../core/widgets/theme_selector.dart';
import '../core/layout/responsive_layout.dart';
import '../dev/dev_info_panel.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const ResponsiveLayout(pages: [HomePageBody(), DevInfoPanel()]);
  }
}

class HomePageBody extends StatelessWidget {
  const HomePageBody({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isDesktop = width >= 1024;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Selectores en el cuerpo para Móvil / Tablet
        if (!isDesktop) ...[
          Center(
            child: Wrap(
              spacing: 12,
              runSpacing: 8,
              alignment: WrapAlignment.center,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: const [LanguageSelector(), ThemeSelector()],
            ),
          ),
          const SizedBox(height: 20),
        ],
        //   Expanded(child: DevWidgetsList()),
        // 2. Panel de Opciones de Desarrollo (Sólo visible/activo en modo desarrollo)
        DevTile(),
        const SizedBox(height: 40),

        // 3. Muted Footer
        Center(
          child: MyText(
            'empty_application',
            style: TextStyle(
              color: Theme.of(
                context,
              ).colorScheme.onSurface.withValues(alpha: 0.4),
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
