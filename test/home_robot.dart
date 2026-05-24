import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test_demo_app/core/language/bloc/language_bloc.dart';
import 'package:test_demo_app/core/storage/storage_service.dart';
import 'package:test_demo_app/core/layout/custom_drawer.dart';
import 'package:test_demo_app/core/layout/custom_app_bar.dart';
import 'package:test_demo_app/screens/home_page.dart';
import 'package:test_demo_app/main.dart';

/// El Robot Pattern es un patrón de diseño excelente para pruebas de widgets/UI.
/// Nos permite encapsular el "cómo" interactuamos con la UI (ej. clics, buscar widgets)
/// dejando el archivo de pruebas centrado en el "qué" estamos probando.
class HomeRobot {
  HomeRobot(this.tester);

  final WidgetTester tester;

  // ──────────────────────────────────────────────
  // SETUP
  // ──────────────────────────────────────────────

  /// Arranca la aplicación en el entorno de pruebas de Flutter con preferencias mockeadas.
  Future<void> pumpMyApp({Map<String, Object> initialPrefs = const {}}) async {
    SharedPreferences.setMockInitialValues(initialPrefs);
    final prefs = await SharedPreferences.getInstance();
    final storageService = StorageService(prefs);
    await tester.pumpWidget(MyApp(storageService: storageService));
    await tester.pumpAndSettle(); // Espera a que terminen todas las animaciones y cargas
  }

  // ──────────────────────────────────────────────
  // VERIFICACIONES DE TEXTO
  // ──────────────────────────────────────────────

  /// Verifica de manera dinámica el texto en base al estado del Cubit.
  void expectEmptyApplicationText() {
    final element = tester.element(find.byType(HomePage));
    final languageCubit = BlocProvider.of<LanguageCubit>(element);
    final expectedText = languageCubit.state.language.languageCode == 'es'
        ? 'Aplicación Vacía'
        : 'Empty Application';

    expect(find.text(expectedText), findsOneWidget);
  }

  /// Verifica de forma explícita que un texto específico esté en pantalla.
  void expectText(String text) {
    expect(find.text(text), findsOneWidget);
  }

  /// Verifica que un texto NO esté presente en pantalla.
  void expectNoText(String text) {
    expect(find.text(text), findsNothing);
  }

  // ──────────────────────────────────────────────
  // IDIOMA
  // ──────────────────────────────────────────────

  /// Simula la interacción del usuario para cambiar de idioma en el DropdownButton.
  Future<void> selectLanguage(String languageCode) async {
    // 1. Encontrar el DropdownButton en pantalla
    final dropdownFinder = find.byType(DropdownButton<String>);
    expect(dropdownFinder, findsOneWidget);

    // 2. Tocar el Dropdown para que se abra la lista desplegable
    await tester.tap(dropdownFinder);
    await tester.pumpAndSettle(); // Reconstruye el árbol con la animación del menú abierto

    // 3. Buscar el DropdownMenuItem que tiene el valor que deseamos seleccionar (ej: 'en')
    // Dado que Flutter renderiza un menú emergente, buscamos el item correspondiente.
    final itemFinder = find.byWidgetPredicate(
      (widget) => widget is DropdownMenuItem<String> && widget.value == languageCode,
    ).last; // Obtenemos el último (el que está activo en el menú desplegado)

    expect(itemFinder, findsOneWidget);

    // 4. Seleccionar el item
    await tester.tap(itemFinder, warnIfMissed: false);
    await tester.pumpAndSettle(); // Esperar a que se cierre el menú y se actualice el estado
  }

  // ──────────────────────────────────────────────
  // TEMA
  // ──────────────────────────────────────────────

  /// Verifica qué icono de tema se muestra
  void expectThemeIcon(IconData icon) {
    expect(find.byIcon(icon), findsOneWidget);
  }

  /// Toca el botón de cambiar tema
  Future<void> tapThemeButton() async {
    final finder = find.byType(IconButton);
    expect(finder, findsOneWidget);
    await tester.tap(finder);
    await tester.pumpAndSettle();
  }

  /// Selecciona una paleta de color a través de su tooltip
  Future<void> selectThemePalette(String tooltip) async {
    final dotFinder = find.byTooltip(tooltip);
    expect(dotFinder, findsOneWidget);
    await tester.tap(dotFinder);
    await tester.pumpAndSettle();
  }

  /// Verifica que una paleta específica tenga el check de seleccionado
  void expectPaletteSelected(String tooltip) {
    final checkFinder = find.descendant(
      of: find.byTooltip(tooltip),
      matching: find.byIcon(Icons.check),
    );
    expect(checkFinder, findsOneWidget);
  }

  // ──────────────────────────────────────────────
  // LAYOUT Y NAVEGACIÓN
  // ──────────────────────────────────────────────

  /// Verifica que el `CustomDrawer` esté presente en el árbol de widgets.
  void expectDrawerPresent() {
    expect(find.byType(CustomDrawer), findsOneWidget);
  }

  /// Verifica que el `CustomAppBar` esté presente en el árbol de widgets.
  void expectAppBarPresent() {
    expect(find.byType(CustomAppBar), findsOneWidget);
  }

  /// Abre el drawer deslizando o pulsando el botón hamburguesa (en móvil/tablet).
  Future<void> openDrawer() async {
    await tester.tap(find.byIcon(Icons.menu_rounded));
    await tester.pumpAndSettle();
  }

  /// Toca un ítem del drawer buscándolo por su icono.
  Future<void> tapDrawerItem(IconData icon) async {
    await tester.tap(find.byIcon(icon));
    await tester.pumpAndSettle();
  }
}
