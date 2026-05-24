import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../storage/storage_service.dart';

import 'language_state.dart';

class LanguageCubit extends Cubit<LanguageState> {
  LanguageCubit({required this.storageService}) : super(const LanguageState(Locale('es'))) {
    getLanguage();
  }

  final StorageService storageService;
  
  // La clave de almacenamiento ahora es responsabilidad del dominio del idioma, no del StorageService
  static const String _localeKey = 'app_locale';

  Set<Locale> supportedLocales = {const Locale('es'), const Locale('en')};

  void getLanguage() {
    if (isClosed) return;

    // 1. Cargar locale usando la clave local del dominio
    final savedLangCode = storageService.getString(_localeKey);
    if (savedLangCode != null && _isSupported(savedLangCode)) {
      emit(LanguageState(Locale(savedLangCode)));
      return;
    }

    // 2. Fallback al idioma del sistema
    final systemLanguage =
        WidgetsBinding.instance.platformDispatcher.locale.languageCode;
    final locale = _isSupported(systemLanguage)
        ? Locale(systemLanguage)
        : const Locale('en');
    emit(LanguageState(locale));
  }

  Future<void> setLanguage(Locale locale) async {
    if (_isSupported(locale.languageCode)) {
      if (isClosed) return;
      emit(LanguageState(locale));
      await storageService.setString(_localeKey, locale.languageCode);
    }
  }

  // funcion reutilizable
  bool _isSupported(String languageCode) {
    return supportedLocales.contains(Locale(languageCode));
  }
}
