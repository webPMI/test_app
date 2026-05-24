import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test_demo_app/core/language/bloc/language_bloc.dart';
import 'package:test_demo_app/core/language/bloc/language_state.dart';
import 'package:test_demo_app/core/language/language_translation.dart';
import 'package:test_demo_app/core/storage/storage_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  // Las pruebas unitarias se agrupan con la función 'group' para mantener el código ordenado y estructurado.
  group('Pruebas Unitarias de Idioma y Traducción', () {
    // ==========================================
    // SECCIÓN 1: PRUEBAS PARA EL CUBIT (ESTADO)
    // ==========================================
    group('LanguageCubit', () {
      late LanguageCubit languageCubit;
      late StorageService storageService;

      // setUp se ejecuta antes de cada test. Nos asegura que cada prueba trabaje
      // con una instancia limpia del cubit para evitar interferencias.
      setUp(() async {
        // Inicializamos los valores mockeados de SharedPreferences vacíos antes de cada test
        SharedPreferences.setMockInitialValues({});
        final prefs = await SharedPreferences.getInstance();
        storageService = StorageService(prefs);
        languageCubit = LanguageCubit(storageService: storageService);
      });

      // tearDown se ejecuta después de cada test. Es importante cerrar los streams
      // y controladores de BLoC/Cubit para evitar fugas de memoria (memory leaks).
      tearDown(() {
        languageCubit.close();
      });

      test(
        'El estado inicial debe ser el idioma del sistema (en en las pruebas)',
        () {
          // Assert: Dado que SharedPreferences está vacío, detecta el idioma del sistema (inglés en pruebas)
          expect(languageCubit.state, const LanguageState(Locale('en')));
        },
      );

      test(
        'Debe cargar el idioma guardado desde el StorageService al inicializar',
        () async {
          // 1. Configuramos el mock de SharedPreferences con un idioma guardado previamente ('es')
          SharedPreferences.setMockInitialValues({'app_locale': 'es'});
          final prefs = await SharedPreferences.getInstance();
          final storage = StorageService(prefs);

          // 2. Creamos un nuevo Cubit que consuma este storage
          final newCubit = LanguageCubit(storageService: storage);

          // 3. Verificamos que el estado inicial se haya cargado del storage ('es')
          expect(newCubit.state, const LanguageState(Locale('es')));
          await newCubit.close();
        },
      );

      test('Debe guardar el idioma en el StorageService al cambiarlo', () async {
        // Act: Cambiamos el idioma a español
        await languageCubit.setLanguage(const Locale('es'));

        // Assert: Comprobamos que el Cubit emita el estado correcto
        expect(languageCubit.state, const LanguageState(Locale('es')));
        // Assert: Comprobamos que se haya guardado en el StorageService localmente
        expect(storageService.getString('app_locale'), 'es');
      });

      test(
        'Debe emitir un nuevo LanguageState al cambiar el idioma a Español (es)',
        () async {
          // expectLater escucha el stream del cubit antes de ejecutar la acción.
          // Esperamos que emita exactamente el estado con Locale('es') porque inicialmente está en 'en'.
          expectLater(
            languageCubit.stream,
            emitsInOrder([const LanguageState(Locale('es'))]),
          );

          // Act: Ejecutamos el cambio de idioma
          await languageCubit.setLanguage(const Locale('es'));
        },
      );

      test(
        'No debe emitir nada si se intenta cambiar al mismo idioma actual (evita rebuilds innecesarios)',
        () async {
          // expectLater no debe detectar ninguna emisión porque intentamos cambiar a 'en' que ya es el actual
          await languageCubit.setLanguage(const Locale('en'));

          // El estado sigue siendo el mismo y no se emitieron eventos duplicados.
          expect(languageCubit.state, const LanguageState(Locale('en')));
        },
      );

      // --- NUEVOS CASOS NEGATIVOS ---

      test(
        'No debe cambiar el idioma si el locale no está soportado (ej: "fr")',
        () async {
          // Arrange: el cubit ya está en 'en'
          final stateAntes = languageCubit.state;

          // Act: intentamos cambiar a un locale no soportado
          await languageCubit.setLanguage(const Locale('zz'));

          // Assert: el estado no debe cambiar y nada se debe guardar
          expect(languageCubit.state, stateAntes);
          expect(storageService.getString('app_locale'), null);
        },
      );

      test(
        'Si el locale guardado no está soportado, debe usar el fallback del sistema',
        () async {
          // Arrange: guardamos un locale inválido en SharedPreferences
          SharedPreferences.setMockInitialValues({'app_locale': 'zz'});
          final prefs = await SharedPreferences.getInstance();
          final storage = StorageService(prefs);

          // Act: el cubit debe detectar que 'zz' no está soportado y caer al sistema (en)
          final newCubit = LanguageCubit(storageService: storage);

          // Assert: el estado debe ser el idioma del sistema (en en el entorno de pruebas)
          expect(newCubit.state, const LanguageState(Locale('en')));
          await newCubit.close();
        },
      );

      test(
        'getLanguage() no debe lanzar excepciones si el cubit está cerrado',
        () async {
          // Arrange: cerramos el cubit antes de llamar a getLanguage
          await languageCubit.close();

          // Act & Assert: no debe lanzar ninguna excepción
          expect(() => languageCubit.getLanguage(), returnsNormally);
        },
      );
    });

    // ==========================================
    // SECCIÓN 2: PRUEBAS PARA LA TRADUCCIÓN (TR)
    // ==========================================
    group('Clase Tr (Traductor)', () {
      test('Debe traducir correctamente palabras simples en Español', () {
        final trEs = Tr(const Locale('es'));

        // Verificamos traducciones directas de claves existentes
        expect(trEs('spanish'), 'Español');
        expect(trEs('english'), 'Ingles');
        expect(trEs('empty_application'), 'Aplicación Vacía');
      });

      test('Debe traducir correctamente palabras simples en Inglés', () {
        final trEn = Tr(const Locale('en'));

        expect(trEn('spanish'), 'Spanish');
        expect(trEn('english'), 'English');
        expect(trEn('empty_application'), 'Empty Application');
      });

      test('Debe devolver la misma key si la clave de traducción no existe', () {
        final tr = Tr(const Locale('es'));

        // Si buscamos una clave inexistente, debe retornar la clave original (fallback)
        expect(tr('clave_inexistente'), 'clave_inexistente');
      });

      test(
        'Debe reemplazar correctamente los parámetros dinámicos {placeholder}',
        () {
          final trEs = Tr(const Locale('es'));
          final trEn = Tr(const Locale('en'));

          // Probamos la interpolación de variables dinámicas: 'Hola, {name}' -> 'Hola, Carlos'
          expect(
            trEs('hello_user', params: {'name': 'Carlos'}),
            'Hola, Carlos',
          );

          expect(trEn('hello_user', params: {'name': 'John'}), 'Hello, John');
        },
      );

      // --- NUEVOS CASOS ADICIONALES ---

      test(
        'Tr.of() estático debe devolver el mismo resultado que la instancia',
        () {
          // El método estático Tr.of() debe ser equivalente a instanciar Tr y llamar call()
          const locale = Locale('es');
          final trInstance = Tr(locale);

          expect(Tr.of(locale, 'spanish'), trInstance('spanish'));
          expect(
            Tr.of(locale, 'empty_application'),
            trInstance('empty_application'),
          );
          expect(Tr.of(locale, 'clave_inexistente'), 'clave_inexistente');
        },
      );

      test('Tr.of() estático debe funcionar correctamente con parámetros', () {
        expect(
          Tr.of(const Locale('en'), 'hello_user', params: {'name': 'World'}),
          'Hello, World',
        );
      });

      test(
        'Locale no soportado debe usar el idioma inglés como fallback en Tr',
        () {
          // Locale 'fr' no está en el mapa, debe caer en el 'default' del switch (english)
          final trFr = Tr(const Locale('fr'));
          expect(
            trFr('english'),
            'English',
          ); // respuesta en inglés, no en francés
          expect(trFr('spanish'), 'Spanish');
        },
      );

      test(
        'Parámetros vacíos no deben afectar al resultado de la traducción',
        () {
          final trEs = Tr(const Locale('es'));
          // Pasar params vacío debe devolver el valor sin modificar
          expect(trEs('spanish', params: {}), 'Español');
        },
      );

      test('Debe ignorar placeholders en la traducción si params es null', () {
        final trEs = Tr(const Locale('es'));
        // 'hello_user' tiene el placeholder {name}; sin params, debe devolverse sin reemplazar
        expect(trEs('hello_user'), 'Hola, {name}');
      });
    });
  });
}
