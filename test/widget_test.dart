import 'package:flutter_test/flutter_test.dart';

import 'home_robot.dart';
import 'responsive_test_utils.dart';

void main() {
  group('Pruebas de Interfaz (Widget Tests) de la Pantalla Principal', () {
    
    // 1. Prueba Responsiva (Smoke Test)
    // Verifica que la interfaz básica se renderice en múltiples resoluciones sin desbordamientos (overflows)
    testWidgetsResponsive('La app se renderiza sin desbordamientos en diferentes pantallas', (
      WidgetTester tester,
    ) async {
      final robot = HomeRobot(tester);

      // Cargar la app
      await robot.pumpMyApp(initialPrefs: {'app_locale': 'es'});
      
      // Verificar que el texto inicial se muestre según corresponda
      robot.expectEmptyApplicationText();
    });

    // 2. Prueba de Interacción y Flujo Reactivo
    // Verifica que cuando el usuario interactúe con el selector de idiomas,
    // el estado cambie y la interfaz se traduzca de forma inmediata (reactividad).
    testWidgets('El cambio de idioma en el DropdownButton actualiza los textos reactivamente', (
      WidgetTester tester,
    ) async {
      final robot = HomeRobot(tester);

      // Paso 1: Cargar la app. Por defecto empieza en Español ('es').
      await robot.pumpMyApp(initialPrefs: {'app_locale': 'es'});

      // Paso 2: Verificar que se muestra inicialmente en Español
      robot.expectText('Aplicación Vacía');

      // Paso 3: Simular cambiar el idioma a Inglés ('en') a través del selector de la UI
      await robot.selectLanguage('en');

      // Paso 4: Verificar que el texto cambió inmediatamente a Inglés
      robot.expectText('Empty Application');

      // Paso 5: Volver a cambiar a Español ('es') para asegurar la bidireccionalidad
      await robot.selectLanguage('es');

      // Paso 6: Verificar que vuelve a Español
      robot.expectText('Aplicación Vacía');
    });
  });
}
