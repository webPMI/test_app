import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:test_demo_app/core/widgets/my_widgets.dart';

void main() {
  group('Pruebas de Forms (20 Widgets)', () {
    
    group('MyTextField', () {
      testWidgets('Captura entrada de texto', (WidgetTester tester) async {
        final controller = TextEditingController();
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: MyTextField(label: 'Nombre', controller: controller),
            ),
          ),
        );
        await tester.enterText(find.byType(TextFormField), 'Juan');
        expect(controller.text, 'Juan');
      });
    });

    group('MyPasswordField', () {
      testWidgets('Muestra toggle de visibilidad', (WidgetTester tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: MyPasswordField(label: 'Clave'),
            ),
          ),
        );
        expect(find.byIcon(Icons.visibility_off_outlined), findsOneWidget);
        await tester.tap(find.byIcon(Icons.visibility_off_outlined));
        await tester.pump();
        expect(find.byIcon(Icons.visibility_outlined), findsOneWidget);
      });
    });

    group('MyTextArea', () {
      testWidgets('Renderiza con límite de caracteres', (WidgetTester tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: MyTextArea(label: 'Notas', maxLength: 100),
            ),
          ),
        );
        expect(find.text('Notas'), findsOneWidget);
      });
    });

    group('MyDropdownField', () {
      testWidgets('Renderiza con valor inicial', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: MyDropdownField<String>(
                label: 'Opción',
                value: 'A',
                items: const [DropdownMenuItem(value: 'A', child: Text('A'))],
                onChanged: (_) {},
              ),
            ),
          ),
        );
        expect(find.text('A'), findsOneWidget);
      });
    });

    group('MyCheckbox', () {
      testWidgets('Alterna estado al hacer tap', (WidgetTester tester) async {
        bool val = false;
        await tester.pumpWidget(
          StatefulBuilder(
            builder: (context, setState) => MaterialApp(
              home: Scaffold(
                body: MyCheckbox(label: 'Check', value: val, onChanged: (v) => setState(() => val = v!)),
              ),
            ),
          ),
        );
        await tester.tap(find.text('Check'));
        expect(val, isTrue);
      });
    });

    group('MyRadioGroup', () {
      testWidgets('Muestra opciones de selección única', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: MyRadioGroup<String>(
                options: const ['Si', 'No'],
                selectedValue: 'Si',
                onChanged: (_) {},
              ),
            ),
          ),
        );
        expect(find.text('Si'), findsOneWidget);
        expect(find.text('No'), findsOneWidget);
      });
    });

    group('MySwitchField', () {
      testWidgets('Alterna estado del switch', (WidgetTester tester) async {
        bool val = false;
        await tester.pumpWidget(
          StatefulBuilder(
            builder: (context, setState) => MaterialApp(
              home: Scaffold(
                body: MySwitchField(label: 'Switch', value: val, onChanged: (v) => setState(() => val = v)),
              ),
            ),
          ),
        );
        await tester.tap(find.byType(Switch));
        expect(val, isTrue);
      });
    });

    group('MySliderField', () {
      testWidgets('Muestra slider con valor', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: MySliderField(label: 'Brillo', value: 0.5, onChanged: (_) {}),
            ),
          ),
        );
        expect(find.text('Brillo'), findsOneWidget);
      });
    });

    group('MyDateField', () {
      testWidgets('Muestra campo con icono de fecha', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: MyDateField(label: 'Fecha', selectedDate: DateTime(2026, 5, 23), onDateSelected: (_) {}),
            ),
          ),
        );
        expect(find.text('23/05/2026'), findsOneWidget);
      });
    });

    group('MyChipSelector', () {
      testWidgets('Muestra chips interactivos', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: MyChipSelector<String>(
                label: 'Chips',
                options: const ['Tag1'],
                selectedOptions: const ['Tag1'],
                onChanged: (_) {},
              ),
            ),
          ),
        );
        expect(find.text('Tag1'), findsOneWidget);
      });
    });

    group('MyRatingBar', () {
      testWidgets('Cambia estrellas al hacer tap', (WidgetTester tester) async {
        int rating = 2;
        await tester.pumpWidget(
          StatefulBuilder(
            builder: (context, setState) => MaterialApp(
              home: Scaffold(
                body: MyRatingBar(rating: rating, onChanged: (v) => setState(() => rating = v)),
              ),
            ),
          ),
        );
        await tester.tap(find.byType(IconButton).at(3));
        expect(rating, 4);
      });
    });

    group('MyFormSection', () {
      testWidgets('Muestra título de sección', (WidgetTester tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: MyFormSection(title: 'Contacto', children: [Text('Child')]),
            ),
          ),
        );
        expect(find.text('Contacto'), findsOneWidget);
      });
    });

    group('MyStepperField', () {
      testWidgets('Incrementa valor numérico', (WidgetTester tester) async {
        int val = 1;
        await tester.pumpWidget(
          StatefulBuilder(
            builder: (context, setState) => MaterialApp(
              home: Scaffold(
                body: MyStepperField(label: 'Número de acompañantes', value: val, onChanged: (v) => setState(() => val = v)),
              ),
            ),
          ),
        );
        await tester.tap(find.byIcon(Icons.add_rounded));
        expect(val, 2);
      });
    });

    group('MySearchableDropdown', () {
      testWidgets('Muestra campo desplegable buscador', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: MySearchableDropdown<String>(
                label: 'Buscador',
                options: const ['A'],
                selectedValue: 'A',
                onChanged: (_) {},
              ),
            ),
          ),
        );
        expect(find.text('A'), findsOneWidget);
      });
    });

    group('MyTagInput', () {
      testWidgets('Muestra etiquetas añadidas', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: MyTagInput(
                label: 'Tags',
                tags: const ['T1'],
                onTagsChanged: (_) {},
              ),
            ),
          ),
        );
        expect(find.text('T1'), findsOneWidget);
      });
    });

    group('MyPinField', () {
      testWidgets('Muestra número de celdas correcto', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: MyPinField(length: 4, onChanged: (_) {}),
            ),
          ),
        );
        expect(find.byType(TextFormField), findsNWidgets(4));
      });
    });

    group('MyFormCard', () {
      testWidgets('Envuelve hijos en tarjeta de formulario', (WidgetTester tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: MyFormCard(child: Text('Card Inside')),
            ),
          ),
        );
        expect(find.text('Card Inside'), findsOneWidget);
      });
    });

    group('MyToggleGroup', () {
      testWidgets('Alterna botones de grupo', (WidgetTester tester) async {
        String val = 'A';
        await tester.pumpWidget(
          StatefulBuilder(
            builder: (context, setState) => MaterialApp(
              home: Scaffold(
                body: MyToggleGroup<String>(
                  options: const ['A', 'B'],
                  selectedOption: val,
                  onChanged: (v) => setState(() => val = v),
                ),
              ),
            ),
          ),
        );
        await tester.tap(find.text('B'));
        expect(val, 'B');
      });
    });

    group('MyColorPicker', () {
      testWidgets('Muestra valor hexadecimal seleccionado', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: MyColorPicker(
                label: 'Color',
                selectedColor: const Color(0xFF3B82F6),
                onColorSelected: (_) {},
              ),
            ),
          ),
        );
        expect(find.text('#3B82F6'), findsOneWidget);
      });
    });

    group('MyFileUploadField', () {
      testWidgets('Dibuja zona de arrastre', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: MyFileUploadField(label: 'Cargar', onFileSelected: (_) {}),
            ),
          ),
        );
        expect(find.text('Haz clic para cargar un archivo'), findsOneWidget);
      });
    });
  });
}
