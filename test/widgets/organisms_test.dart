import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:test_demo_app/core/widgets/my_widgets.dart';

void main() {
  group('Pruebas de Organisms (10 Widgets)', () {
    
    group('MySectionHeader', () {
      testWidgets('Muestra cabecera de sección', (WidgetTester tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: MySectionHeader(title: 'Ajustes', subtitle: 'Configurar preferencias'),
            ),
          ),
        );
        expect(find.text('Ajustes'), findsOneWidget);
        expect(find.text('Configurar preferencias'), findsOneWidget);
      });
    });

    group('MyEmptyState', () {
      testWidgets('Renderiza textos y botón de acción', (WidgetTester tester) async {
        bool action = false;
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: MyEmptyState(
                title: 'Vacío',
                description: 'No hay datos',
                actionLabel: 'Recargar',
                onActionPressed: () => action = true,
              ),
            ),
          ),
        );
        expect(find.text('Vacío'), findsOneWidget);
        await tester.tap(find.text('Recargar'));
        expect(action, isTrue);
      });
    });

    group('MyTabBar', () {
      testWidgets('Muestra pestañas e indicador', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: DefaultTabController(
                length: 2,
                child: Builder(
                  builder: (context) {
                    return MyTabBar(
                      controller: DefaultTabController.of(context),
                      tabs: const [Tab(text: 'Uno'), Tab(text: 'Dos')],
                    );
                  },
                ),
              ),
            ),
          ),
        );
        expect(find.text('Uno'), findsOneWidget);
        expect(find.text('Dos'), findsOneWidget);
      });
    });

    group('MyTagList', () {
      testWidgets('Muestra tags en formato scroll', (WidgetTester tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: MyTagList(tags: ['TagA', 'TagB']),
            ),
          ),
        );
        expect(find.text('TagA'), findsOneWidget);
        expect(find.text('TagB'), findsOneWidget);
      });
    });

    group('MyTimelineItem', () {
      testWidgets('Muestra ítem cronológico', (WidgetTester tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: MyTimelineItem(title: 'Paso 1', description: 'Registro completo', time: '12:00'),
            ),
          ),
        );
        expect(find.text('Paso 1'), findsOneWidget);
        expect(find.text('12:00'), findsOneWidget);
      });
    });

    group('MyExpandableCard', () {
      testWidgets('Muestra cabecera y cuerpo colapsado', (WidgetTester tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: MyExpandableCard(title: 'Desplegable', child: Text('Cuerpo Oculto')),
            ),
          ),
        );
        expect(find.text('Desplegable'), findsOneWidget);
        expect(find.text('Cuerpo Oculto'), findsOneWidget);
      });
    });

    group('MyStepperSteps', () {
      testWidgets('Renderiza pasos secuenciales correctamente', (WidgetTester tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: MyStepperSteps(
                steps: ['Paso1', 'Paso2'],
                currentStep: 0,
              ),
            ),
          ),
        );
        expect(find.text('Paso1'), findsOneWidget);
        expect(find.text('Paso2'), findsOneWidget);
      });
    });

    group('MyBottomBar', () {
      testWidgets('Renderiza items y maneja tap', (WidgetTester tester) async {
        int index = 0;
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: MyBottomBar(
                items: const [
                  MyBottomBarItem(icon: Icons.home, label: 'Inicio'),
                  MyBottomBarItem(icon: Icons.settings, label: 'Ajustes'),
                ],
                currentIndex: index,
                onTap: (v) => index = v,
              ),
            ),
          ),
        );
        expect(find.text('Inicio'), findsOneWidget);
        await tester.tap(find.text('Ajustes'));
        expect(index, 1);
      });
    });

    group('MyCarousel', () {
      testWidgets('Muestra elementos de carrusel', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: MyCarousel(
                items: const [
                  Text('Elemento 1'),
                  Text('Elemento 2'),
                ],
              ),
            ),
          ),
        );
        expect(find.text('Elemento 1'), findsOneWidget);
      });
    });

    group('MyDialog', () {
      testWidgets('Renderiza diálogos con títulos y botones', (WidgetTester tester) async {
        bool confirmed = false;
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: MyDialog(
                title: 'Alerta',
                description: 'Mensaje de confirmación',
                confirmLabel: 'Confirmar',
                onConfirm: () => confirmed = true,
              ),
            ),
          ),
        );
        expect(find.text('Alerta'), findsOneWidget);
        expect(find.text('Confirmar'), findsOneWidget);
        await tester.tap(find.text('Confirmar'));
        expect(confirmed, isTrue);
      });
    });
  });
}
