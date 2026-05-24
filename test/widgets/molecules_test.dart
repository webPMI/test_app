import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:test_demo_app/core/widgets/my_widgets.dart';

void main() {
  group('Pruebas de Molecules (13 Widgets)', () {
    
    group('MyCard', () {
      testWidgets('Renderiza cabecera, cuerpo y acciones', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: MyCard(
                title: 'Card Title',
                subtitle: 'Card Subtitle',
                actions: [TextButton(onPressed: () {}, child: const Text('Action'))],
                child: const Text('Card Body'),
              ),
            ),
          ),
        );
        expect(find.text('Card Title'), findsOneWidget);
        expect(find.text('Card Body'), findsOneWidget);
      });
    });

    group('MyListTile', () {
      testWidgets('Renderiza contenido y responde a tap', (WidgetTester tester) async {
        bool tapped = false;
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: MyListTile(title: 'List Title', subtitle: 'List Subtitle', onTap: () => tapped = true),
            ),
          ),
        );
        expect(find.text('List Title'), findsOneWidget);
        await tester.tap(find.text('List Title'));
        expect(tapped, isTrue);
      });
    });

    group('MyInfoChip', () {
      testWidgets('Renderiza etiqueta y responde a eliminación', (WidgetTester tester) async {
        bool deleted = false;
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: MyInfoChip(label: 'Filtro Activo', onDeleted: () => deleted = true),
            ),
          ),
        );
        expect(find.text('Filtro Activo'), findsOneWidget);
        await tester.tap(find.byIcon(Icons.close));
        expect(deleted, isTrue);
      });
    });

    group('MyStatCard', () {
      testWidgets('Renderiza título, valor y tendencia', (WidgetTester tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: MyStatCard(title: 'Ventas', value: '\$100', trend: '+5%'),
            ),
          ),
        );
        expect(find.text('Ventas'), findsOneWidget);
        expect(find.text('\$100'), findsOneWidget);
        expect(find.text('+5%'), findsOneWidget);
      });
    });

    group('MySearchBar', () {
      testWidgets('Muestra placeholder de búsqueda', (WidgetTester tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: MySearchBar(hintText: 'Buscar aquí...'),
            ),
          ),
        );
        expect(find.text('Buscar aquí...'), findsOneWidget);
      });
    });

    group('MyProgressBar', () {
      testWidgets('Dibuja porcentaje e indicador de progreso', (WidgetTester tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: MyProgressBar(value: 0.6, label: 'Cargando', showPercent: true),
            ),
          ),
        );
        expect(find.text('Cargando'), findsOneWidget);
        expect(find.text('60%'), findsOneWidget);
      });
    });

    group('MyAlertBanner', () {
      testWidgets('Muestra mensaje de alerta correctamente', (WidgetTester tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: MyAlertBanner(message: 'Error de servidor', type: MyAlertType.error),
            ),
          ),
        );
        expect(find.text('Error de servidor'), findsOneWidget);
      });
    });

    group('MyMenuItem', () {
      testWidgets('Muestra icono y etiqueta', (WidgetTester tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: MyMenuItem(icon: Icons.edit, label: 'Editar Perfil'),
            ),
          ),
        );
        expect(find.text('Editar Perfil'), findsOneWidget);
        expect(find.byIcon(Icons.edit), findsOneWidget);
      });
    });

    group('MyTooltipWrapper', () {
      testWidgets('Envuelve al hijo de forma segura', (WidgetTester tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: MyTooltipWrapper(message: 'Help Text', child: Text('Hover Child')),
            ),
          ),
        );
        expect(find.text('Hover Child'), findsOneWidget);
      });
    });

    group('MyNotificationBadge', () {
      testWidgets('Superpone número en el badge', (WidgetTester tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: MyNotificationBadge(
                count: 8,
                child: Text('Child'),
              ),
            ),
          ),
        );
        expect(find.text('8'), findsOneWidget);
      });
    });

    group('MyBreadcrumbs', () {
      testWidgets('Muestra items y responde a clicks', (WidgetTester tester) async {
        bool tapped = false;
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: MyBreadcrumbs(
                items: [
                  MyBreadcrumbItem(label: 'Home', onTap: () => tapped = true),
                  const MyBreadcrumbItem(label: 'Dashboard'),
                ],
              ),
            ),
          ),
        );
        expect(find.text('Home'), findsOneWidget);
        expect(find.text('Dashboard'), findsOneWidget);
        await tester.tap(find.text('Home'));
        expect(tapped, isTrue);
      });
    });

    group('MyAccordion', () {
      testWidgets('Alterna despliegue al hacer tap', (WidgetTester tester) async {
        bool toggled = false;
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: MyAccordion(
                title: 'Pregunta',
                onToggle: (v) => toggled = v,
                child: const Text('Respuesta'),
              ),
            ),
          ),
        );
        expect(find.text('Pregunta'), findsOneWidget);
        await tester.tap(find.text('Pregunta'));
        expect(toggled, isTrue);
      });
    });

    group('MyToast', () {
      testWidgets('Muestra mensaje de toast y responde a cierre', (WidgetTester tester) async {
        bool dismissed = false;
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: MyToast(
                message: 'Guardado',
                onDismiss: () => dismissed = true,
              ),
            ),
          ),
        );
        expect(find.text('Guardado'), findsOneWidget);
        await tester.tap(find.byIcon(Icons.close_rounded));
        expect(dismissed, isTrue);
      });
    });
  });
}
