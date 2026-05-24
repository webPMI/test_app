import 'package:shared_preferences/shared_preferences.dart';

/// Un servicio de almacenamiento genérico.
/// Es agnóstico a las claves y lógica de negocio. Solo actúa como un wrapper
/// simple de persistencia. Esto previene que se convierta en una clase gigante
/// (God Class) a medida que la app crece y respeta el Single Responsibility Principle (SRP).
class StorageService {
  StorageService(this._prefs);

  final SharedPreferences _prefs;

  // Getters y Setters genéricos por tipo de datos
  
  String? getString(String key) => _prefs.getString(key);
  Future<bool> setString(String key, String value) => _prefs.setString(key, value);

  bool? getBool(String key) => _prefs.getBool(key);
  Future<bool> setBool(String key, bool value) => _prefs.setBool(key, value);

  int? getInt(String key) => _prefs.getInt(key);
  Future<bool> setInt(String key, int value) => _prefs.setInt(key, value);

  double? getDouble(String key) => _prefs.getDouble(key);
  Future<bool> setDouble(String key, double value) => _prefs.setDouble(key, value);

  Future<bool> remove(String key) => _prefs.remove(key);
}
