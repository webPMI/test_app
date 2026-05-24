import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:test_demo_app/core/widgets/my_widgets.dart';

void main() {
  group('Pruebas de Atoms (7 Widgets)', () {
    
    group('MyButton', () {
      testWidgets('Renderiza etiqueta y responde a taps', (WidgetTester tester) async {
        bool pressed = false;
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: MyButton(label: 'Click Me', onPressed: () => pressed = true),
            ),
          ),
        );
        expect(find.text('Click Me'), findsOneWidget);
        await tester.tap(find.text('Click Me'));
        expect(pressed, isTrue);
      });

      testWidgets('No responde a tap si está cargando (isLoading)', (WidgetTester tester) async {
        bool pressed = false;
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: MyButton(label: 'Submit', isLoading: true, onPressed: () => pressed = true),
            ),
          ),
        );
        expect(find.byType(CircularProgressIndicator), findsOneWidget);
        await tester.tap(find.text('Submit'));
        expect(pressed, isFalse);
      });
    });

    group('MyBadge', () {
      testWidgets('Renderiza etiqueta e icono opcional', (WidgetTester tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: MyBadge(label: 'Nuevo', icon: Icons.star, variant: MyBadgeVariant.success),
            ),
          ),
        );
        expect(find.text('Nuevo'), findsOneWidget);
        expect(find.byIcon(Icons.star), findsOneWidget);
      });
    });

    group('MyIconButton', () {
      testWidgets('Renderiza icono y responde a taps', (WidgetTester tester) async {
        bool tapped = false;
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: MyIconButton(icon: Icons.add, onPressed: () => tapped = true),
            ),
          ),
        );
        expect(find.byIcon(Icons.add), findsOneWidget);
        await tester.tap(find.byIcon(Icons.add));
        expect(tapped, isTrue);
      });
    });

    group('MyAvatar', () {
      testWidgets('Extrae iniciales correctamente', (WidgetTester tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: MyAvatar(name: 'John Doe'),
            ),
          ),
        );
        expect(find.text('JD'), findsOneWidget);
      });
    });

    group('MyDivider', () {
      testWidgets('Renderiza divisor con texto central', (WidgetTester tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: MyDivider(label: 'O continuar con'),
            ),
          ),
        );
        expect(find.text('O continuar con'), findsOneWidget);
      });
    });

    group('MySpinner', () {
      testWidgets('Renderiza spinner circular', (WidgetTester tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: MySpinner(type: MySpinnerType.circular),
            ),
          ),
        );
        expect(find.byType(CircularProgressIndicator), findsOneWidget);
      });

      testWidgets('Renderiza spinner de puntos (dots)', (WidgetTester tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: MySpinner(type: MySpinnerType.dots),
            ),
          ),
        );
        expect(find.byType(MySpinner), findsOneWidget);
      });
    });

    group('MyNetworkImage', () {
      testWidgets('Renderiza imagen con url', (WidgetTester tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: MyNetworkImage(imageUrl: 'https://example.com/img.png'),
            ),
          ),
        );
        expect(find.byType(MyNetworkImage), findsOneWidget);
      });
    });
  });
}
