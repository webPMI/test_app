import 'package:flutter/material.dart';
import '../component_showcase.dart';
import '../../core/widgets/organisms/my_section_header.dart';
import '../../core/widgets/organisms/my_empty_state.dart';
import '../../core/widgets/organisms/my_tab_bar.dart';
import '../../core/widgets/organisms/my_tag_list.dart';
import '../../core/widgets/organisms/my_timeline_item.dart';
import '../../core/widgets/organisms/my_expandable_card.dart';
import '../../core/widgets/organisms/my_stepper_steps.dart';
import '../../core/widgets/organisms/my_bottom_bar.dart';
import '../../core/widgets/organisms/my_carousel.dart';
import '../../core/widgets/organisms/my_dialog.dart';

class ShowcaseOrganisms extends StatefulWidget {
  const ShowcaseOrganisms({super.key});

  @override
  State<ShowcaseOrganisms> createState() => _ShowcaseOrganismsState();
}

class _ShowcaseOrganismsState extends State<ShowcaseOrganisms> {
  int _currentBottomBarIndex = 0;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 16.0, top: 8.0),
          child: Text(
            '3. Organismos',
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
        ),
        const ComponentShowcase(
          title: 'MySectionHeader',
          description: 'Encabezado de sección con título, subtítulo e icono decorado.',
          child: MySectionHeader(
            title: 'Configuraciones Generales',
            subtitle: 'Gestiona el comportamiento del sistema.',
            icon: Icons.settings_outlined,
          ),
        ),
        ComponentShowcase(
          title: 'MyEmptyState',
          description: 'Vista para indicar la ausencia de datos con ilustración e instrucciones.',
          child: MyEmptyState(
            title: 'Sin Correos Nuevos',
            description: 'Tu bandeja de entrada está completamente limpia por hoy.',
            icon: Icons.mark_email_read_outlined,
            actionLabel: 'Sincronizar',
            onActionPressed: () {},
          ),
        ),
        ComponentShowcase(
          title: 'MyTabBar',
          description: 'Pestañas de navegación tipo píldora animadas.',
          child: SizedBox(
            height: 120,
            child: DefaultTabController(
              length: 3,
              child: Builder(
                builder: (context) {
                  return Column(
                    children: [
                      MyTabBar(
                        controller: DefaultTabController.of(context),
                        tabs: const [
                          Tab(text: 'Hoy'),
                          Tab(text: 'Semana'),
                          Tab(text: 'Historial'),
                        ],
                      ),
                      Expanded(
                        child: TabBarView(
                          controller: DefaultTabController.of(context),
                          children: const [
                            Center(child: Text('Contenido de Hoy')),
                            Center(child: Text('Contenido de la Semana')),
                            Center(child: Text('Contenido Histórico')),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
        ComponentShowcase(
          title: 'MyTagList',
          description: 'Visualización de tags seleccionables de forma horizontal.',
          child: MyTagList(
            tags: const ['Móvil', 'Backend', 'Flutter', 'Dart', 'AWS', 'Docker'],
            selectedTags: const ['Flutter', 'Dart'],
            onTagSelected: (tag) {},
          ),
        ),
        const ComponentShowcase(
          title: 'MyTimelineItem',
          description: 'Hito cronológico con conexión vertical y fecha.',
          child: Column(
            children: [
              MyTimelineItem(
                title: 'Despliegue Exitoso',
                description: 'La versión v1.0.0 fue subida a producción sin errores.',
                time: '14:25',
                icon: Icons.rocket_launch_outlined,
                isFirst: true,
              ),
              MyTimelineItem(
                title: 'Revisión de Código',
                description: 'Se aprobaron los cambios de los widgets reutilizables.',
                time: '12:10',
                icon: Icons.code_rounded,
                isLast: true,
              ),
            ],
          ),
        ),
        const ComponentShowcase(
          title: 'MyExpandableCard',
          description: 'Contenedor colapsable con animación suave de apertura.',
          child: MyExpandableCard(
            title: 'Ver logs técnicos',
            subtitle: 'Detalle de peticiones HTTP locales.',
            child: Text(
              'GET /api/v1/user - 200 OK (14ms)\nPOST /api/v1/auth/login - 200 OK (120ms)',
              style: TextStyle(fontFamily: 'monospace', fontSize: 12),
            ),
          ),
        ),
        const ComponentShowcase(
          title: 'MyStepperSteps',
          description: 'Indicador de pasos jerárquicos horizontales para formularios secuenciales.',
          child: MyStepperSteps(
            steps: ['Datos', 'Envío', 'Resumen'],
            currentStep: 1,
          ),
        ),
        ComponentShowcase(
          title: 'MyBottomBar',
          description: 'Barra de navegación inferior flotante premium con micro-animaciones.',
          child: MyBottomBar(
            items: const [
              MyBottomBarItem(icon: Icons.home_rounded, label: 'Inicio'),
              MyBottomBarItem(icon: Icons.favorite_rounded, label: 'Favoritos'),
              MyBottomBarItem(icon: Icons.person_rounded, label: 'Perfil'),
            ],
            currentIndex: _currentBottomBarIndex,
            onTap: (index) {
              setState(() {
                _currentBottomBarIndex = index;
              });
            },
          ),
        ),
        ComponentShowcase(
          title: 'MyCarousel',
          description: 'Carrusel de elementos premium interactivo con auto-play.',
          child: MyCarousel(
            height: 140,
            items: [
              Container(
                color: cs.primaryContainer,
                alignment: Alignment.center,
                child: Text('Slide 1', style: TextStyle(color: cs.onPrimaryContainer, fontWeight: FontWeight.bold)),
              ),
              Container(
                color: cs.secondaryContainer,
                alignment: Alignment.center,
                child: Text('Slide 2', style: TextStyle(color: cs.onSecondaryContainer, fontWeight: FontWeight.bold)),
              ),
              Container(
                color: cs.tertiaryContainer,
                alignment: Alignment.center,
                child: Text('Slide 3', style: TextStyle(color: cs.onTertiaryContainer, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),
        ComponentShowcase(
          title: 'MyDialog',
          description: 'Diálogos emergentes con variantes predefinidas y ranuras personalizadas.',
          child: Center(
            child: ElevatedButton.icon(
              icon: const Icon(Icons.open_in_new_rounded),
              label: const Text('Abrir Diálogo de Prueba'),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => MyDialog(
                    title: 'Operación Exitosa',
                    description: 'Los 10 nuevos componentes se crearon e integraron exitosamente en el sistema de diseño.',
                    type: MyDialogType.success,
                    confirmLabel: '¡Genial!',
                    onConfirm: () {},
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
