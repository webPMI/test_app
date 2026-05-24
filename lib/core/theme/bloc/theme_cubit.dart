import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../storage/storage_service.dart';
import 'theme_state.dart';

class ThemeCubit extends Cubit<ThemeState> {
  ThemeCubit({required this.storageService})
      : super(const ThemeState(
          themeMode: ThemeMode.system,
          palette: ThemePalette.indigoSlate,
        )) {
    loadTheme();
  }

  final StorageService storageService;
  
  static const String _themeKey = 'app_theme_mode';
  static const String _paletteKey = 'app_theme_palette';

  /// Carga el tema y la paleta guardados desde el StorageService
  void loadTheme() {
    if (isClosed) return;
    
    // 1. Cargar el modo de brillo
    ThemeMode mode = ThemeMode.system;
    final savedThemeName = storageService.getString(_themeKey);
    if (savedThemeName != null) {
      mode = ThemeMode.values.firstWhere(
        (e) => e.name == savedThemeName,
        orElse: () => ThemeMode.system,
      );
    }

    // 2. Cargar la paleta de color
    ThemePalette palette = ThemePalette.indigoSlate;
    final savedPaletteName = storageService.getString(_paletteKey);
    if (savedPaletteName != null) {
      palette = ThemePalette.values.firstWhere(
        (e) => e.name == savedPaletteName,
        orElse: () => ThemePalette.indigoSlate,
      );
    }

    emit(ThemeState(themeMode: mode, palette: palette));
  }

  /// Guarda y establece el nuevo modo de tema de la aplicación
  Future<void> setTheme(ThemeMode mode) async {
    if (isClosed) return;
    emit(ThemeState(themeMode: mode, palette: state.palette));
    await storageService.setString(_themeKey, mode.name);
  }

  /// Guarda y establece la nueva paleta de colores
  Future<void> setPalette(ThemePalette palette) async {
    if (isClosed) return;
    emit(ThemeState(themeMode: state.themeMode, palette: palette));
    await storageService.setString(_paletteKey, palette.name);
  }

  /// Alterna alternativamente entre tema Claro y Oscuro
  Future<void> toggleTheme() async {
    final currentMode = state.themeMode;
    final newMode = currentMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    await setTheme(newMode);
  }
}
