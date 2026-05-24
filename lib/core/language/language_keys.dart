import 'package:flutter/material.dart';

class LanguageKeys {
  static const Map<String, Map<String, String>> _localizedValues = {
    'es': spanish,
    'en': english,
  };
  static String of(Locale locale, String key) {
    final langCode = _localizedValues.containsKey(locale.languageCode)
        ? locale.languageCode
        : 'es';
    return _localizedValues[langCode]?[key] ??
        _localizedValues['es']?[key] ??
        key;
  }

  static String tr(BuildContext context, String key) {
    final locale = Localizations.maybeLocaleOf(context) ?? const Locale('es');
    return of(locale, key);
  }
}

const Map<String, String> spanish = {
  'english': 'Ingles',
  'spanish': 'Español',
  'empty_application': 'Aplicación Vacía',
  'hello_user': 'Hola, {name}',
  'welcome_title': 'Consola de Control',
  'welcome_subtitle': 'Ajustes globales y monitoreo del sistema',
  'settings_title': 'Panel de Configuración',
  'settings_desc': 'Personaliza tu experiencia visual y de idioma',
  'theme_mode_label': 'Modo de Brillo',
  'color_palette_label': 'Paleta del Sistema',
  'language_label': 'Idioma Regional',
  'stats_status': 'Estado',
  'stats_active': 'Activo',
  'app_name': 'Test Demo App',
  'home': 'Inicio',
  'dev_center': 'Centro Dev',
  'developer_console': 'Consola de Desarrollador',
  'developer_console_desc': 'Accede a scripts CLI e información de pruebas.',
  'back_to_home': 'Volver al Inicio',
};

const Map<String, String> english = {
  'english': 'English',
  'spanish': 'Spanish',
  'empty_application': 'Empty Application',
  'hello_user': 'Hello, {name}',
  'welcome_title': 'Control Console',
  'welcome_subtitle': 'Global settings & system monitoring',
  'settings_title': 'Configuration Panel',
  'settings_desc': 'Personalize your visual and language experience',
  'theme_mode_label': 'Brightness Mode',
  'color_palette_label': 'System Palette',
  'language_label': 'Regional Language',
  'stats_status': 'Status',
  'stats_active': 'Active',
  'app_name': 'Test Demo App',
  'home': 'Home',
  'dev_center': 'Dev Center',
  'developer_console': 'Developer Console',
  'developer_console_desc': 'Access CLI scripts and test information.',
  'back_to_home': 'Back to Home',
};
