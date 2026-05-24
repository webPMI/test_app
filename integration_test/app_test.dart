import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:test_demo_app/main.dart' as app;
import 'package:shared_preferences/shared_preferences.dart';
import '../test/home_robot.dart';

void main() {
  // Inicializa el binding del driver de Integration Test para correr en el dispositivo/emulador real
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Pruebas de Extremo a Extremo (E2E Tests)', () {
    setUp(() async {
      // Limpiar SharedPreferences para garantizar que cada test empiece con un estado aislado y limpio.
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();
    });

    testWidgets('Flujo E2E completo: Cambiar idioma, alternar tema y cambiar paleta en dispositivo real', (
      WidgetTester tester,
    ) async {
      // 1. Arrancamos la aplicación real llamando a su main() (dispara el Storage nativo)
      app.main();
      await tester.pumpAndSettle(); // Esperamos que cargue la persistencia y la UI inicial

      // Reutilizamos el HomeRobot de las pruebas de widget. 
      // El patrón Robot funciona de la misma manera en E2E porque las consultas e interacciones de UI son idénticas.
      final robot = HomeRobot(tester);

      // 2. Flujo de Idioma: Cambiar a inglés
      await robot.selectLanguage('en');
      robot.expectText('Empty Application');

      // 3. Flujo de Tema: Alternar brillo a Oscuro
      robot.expectThemeIcon(Icons.dark_mode); // Inicialmente muestra botón para cambiar a oscuro
      await robot.tapThemeButton();
      robot.expectThemeIcon(Icons.light_mode); // Ya en oscuro, el botón debe cambiar a claro

      // 4. Flujo de Paletas: Cambiar a Cyberpunk Rose
      robot.expectPaletteSelected('Indigo Slate');
      await robot.selectThemePalette('Cyberpunk Rose');
      robot.expectPaletteSelected('Cyberpunk Rose');

      // 5. Flujo de Idioma de regreso a Español
      await robot.selectLanguage('es');
      robot.expectText('Aplicación Vacía');
    });

    testWidgets('Debe persistir la configuración (idioma, modo oscuro, paleta) tras reiniciar la aplicación', (
      WidgetTester tester,
    ) async {
      // 1. Arrancar la aplicación inicial
      app.main();
      await tester.pumpAndSettle();

      final robot = HomeRobot(tester);

      // 2. Establecer una configuración específica: Inglés, Modo Oscuro, Cyberpunk Rose
      // Cambiar a inglés
      await robot.selectLanguage('en');
      robot.expectText('Empty Application');

      // Cambiar a modo oscuro (si no lo está)
      // Como el estado inicial por defecto de ThemeCubit es ThemeMode.system, 
      // y en las pruebas corre en modo claro por defecto, tapThemeButton() cambia a oscuro.
      await robot.tapThemeButton();
      robot.expectThemeIcon(Icons.light_mode); // Debe mostrar el icono para volver a claro

      // Cambiar a la paleta Cyberpunk Rose
      await robot.selectThemePalette('Cyberpunk Rose');
      robot.expectPaletteSelected('Cyberpunk Rose');

      // Esperar brevemente para asegurar que los canales de plataforma nativos completen las operaciones de escritura.
      await Future.delayed(const Duration(milliseconds: 500));

      // 3. Simular reinicio de la aplicación volviendo a invocar app.main().
      // Dado que corre en un dispositivo/emulador real, SharedPreferences guardará los datos reales
      // y la nueva inicialización cargará el estado persistido.
      app.main();
      await tester.pumpAndSettle();

      // 4. Verificar que se mantienen los valores guardados sin realizar ninguna acción táctil
      robot.expectText('Empty Application');
      robot.expectThemeIcon(Icons.light_mode);
      robot.expectPaletteSelected('Cyberpunk Rose');
    });
  });
}
