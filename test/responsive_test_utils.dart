import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// Tamaños de pantalla estándar para todas nuestras pruebas.
final Map<String, Size> defaultScreenSizes = {
  'Mobile Pequeño': const Size(320, 568),
  'Mobile Estándar': const Size(412, 915),
  'Tablet': const Size(768, 1024),
  'Desktop': const Size(1920, 1080),
};

/// Un envoltorio personalizado para ejecutar una prueba en múltiples resoluciones.
void testWidgetsResponsive(
  String description,
  WidgetTesterCallback callback, {
  Map<String, Size>? screenSizes,
}) {
  final sizes = screenSizes ?? defaultScreenSizes;

  for (final entry in sizes.entries) {
    testWidgets('$description (on ${entry.key})', (WidgetTester tester) async {
      // Interceptar errores de overflow
      final originalOnError = FlutterError.onError;
      String? overflowError;
      
      FlutterError.onError = (FlutterErrorDetails details) {
        final message = details.toString();
        if (message.contains('overflowed')) {
          overflowError = message;
        }
        originalOnError?.call(details);
      };

      // Configuramos el tamaño de la pantalla
      tester.view.physicalSize = entry.value;
      tester.view.devicePixelRatio = 1.0;

      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
        FlutterError.onError = originalOnError;
      });

      // Ejecutamos la prueba real
      await callback(tester);

      // Si se capturó un overflow, fallar el test
      if (overflowError != null) {
        fail('Desbordamiento visual detectado en ${entry.key}: $overflowError');
      }
    });
  }
}
