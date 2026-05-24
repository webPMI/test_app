import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test_demo_app/core/storage/storage_service.dart';

void main() {
  // Asegurar que los bindings de prueba estén inicializados
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Pruebas Unitarias de StorageService', () {
    late StorageService storageService;

    setUp(() async {
      // Mockear valores iniciales con un set de datos representativo
      SharedPreferences.setMockInitialValues({
        'string_key': 'hello',
        'bool_key': true,
        'int_key': 42,
        'double_key': 3.14,
      });

      final prefs = await SharedPreferences.getInstance();
      storageService = StorageService(prefs);
    });

    // ==========================================
    // SECCIÓN 1: LECTURA DE VALORES EXISTENTES
    // ==========================================
    group('Lectura de valores existentes', () {
      test('Debe obtener valores correctamente si existen en persistencia', () {
        expect(storageService.getString('string_key'), 'hello');
        expect(storageService.getBool('bool_key'), true);
        expect(storageService.getInt('int_key'), 42);
        expect(storageService.getDouble('double_key'), 3.14);
      });

      test('Debe retornar null para String si la clave no existe', () {
        expect(storageService.getString('non_existing_key'), null);
      });

      test('Debe retornar null para Bool si la clave no existe', () {
        expect(storageService.getBool('non_existing_key'), null);
      });

      test('Debe retornar null para Int si la clave no existe', () {
        expect(storageService.getInt('non_existing_key'), null);
      });

      test('Debe retornar null para Double si la clave no existe', () {
        expect(storageService.getDouble('non_existing_key'), null);
      });
    });

    // ==========================================
    // SECCIÓN 2: ESCRITURA Y LECTURA POSTERIOR
    // ==========================================
    group('Escritura y lectura posterior', () {
      test('Debe escribir y leer un String correctamente', () async {
        await storageService.setString('new_string_key', 'world');
        expect(storageService.getString('new_string_key'), 'world');
      });

      test('Debe escribir y leer un Bool false correctamente', () async {
        await storageService.setBool('new_bool_key', false);
        expect(storageService.getBool('new_bool_key'), false);
      });

      test('Debe escribir y leer un Int correctamente', () async {
        await storageService.setInt('new_int_key', 100);
        expect(storageService.getInt('new_int_key'), 100);
      });

      test('Debe escribir y leer un Double correctamente', () async {
        await storageService.setDouble('new_double_key', 2.718);
        expect(storageService.getDouble('new_double_key'), 2.718);
      });

      test('Debe sobreescribir un valor existente correctamente', () async {
        // Valor inicial
        expect(storageService.getString('string_key'), 'hello');

        // Sobreescribir
        await storageService.setString('string_key', 'overwritten');
        expect(storageService.getString('string_key'), 'overwritten');
      });

      test('setString debe devolver true al guardar correctamente', () async {
        final result = await storageService.setString('key_result', 'value');
        expect(result, true);
      });

      test('setBool debe devolver true al guardar correctamente', () async {
        final result = await storageService.setBool('key_result_bool', true);
        expect(result, true);
      });

      test('setInt debe devolver true al guardar correctamente', () async {
        final result = await storageService.setInt('key_result_int', 99);
        expect(result, true);
      });

      test('setDouble debe devolver true al guardar correctamente', () async {
        final result = await storageService.setDouble('key_result_double', 0.5);
        expect(result, true);
      });

      test('Debe escribir todos los tipos en una sola sesión y leerlos consistentemente', () async {
        await storageService.setString('s', 'abc');
        await storageService.setBool('b', false);
        await storageService.setInt('i', 7);
        await storageService.setDouble('d', 1.5);

        expect(storageService.getString('s'), 'abc');
        expect(storageService.getBool('b'), false);
        expect(storageService.getInt('i'), 7);
        expect(storageService.getDouble('d'), 1.5);
      });
    });

    // ==========================================
    // SECCIÓN 3: ELIMINACIÓN DE CLAVES
    // ==========================================
    group('Eliminación de claves', () {
      test('Debe eliminar una clave guardada correctamente', () async {
        expect(storageService.getString('string_key'), 'hello');

        final result = await storageService.remove('string_key');
        expect(result, true);
        expect(storageService.getString('string_key'), null);
      });

      test('Debe retornar true al eliminar una clave que no existe', () async {
        // SharedPreferences.remove() devuelve true incluso si la clave no existe
        final result = await storageService.remove('key_that_never_existed');
        expect(result, true);
      });

      test('Después de eliminar, los demás valores no deben verse afectados', () async {
        await storageService.remove('string_key');

        // Las demás claves deben seguir intactas
        expect(storageService.getBool('bool_key'), true);
        expect(storageService.getInt('int_key'), 42);
        expect(storageService.getDouble('double_key'), 3.14);
      });
    });
  });
}
