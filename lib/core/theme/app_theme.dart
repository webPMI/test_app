import 'package:flutter/material.dart';
import 'bloc/theme_state.dart';

class AppTheme {
  /// Obtiene el ThemeData para el Claro (Light) basado en la paleta seleccionada
  static ThemeData getLightTheme(ThemePalette palette) {
    switch (palette) {
      case ThemePalette.indigoSlate:
        return _buildTheme(
          brightness: Brightness.light,
          primary: const Color(0xFF4F46E5), // Indigo 600
          onPrimary: Colors.white,
          secondary: const Color(0xFF0EA5E9), // Sky 500
          background: const Color(0xFFF8FAFC), // Slate 50
          surface: Colors.white,
          onBackground: const Color(0xFF0F172A), // Slate 900
          onSurface: const Color(0xFF0F172A),
        );
      case ThemePalette.emeraldAmber:
        return _buildTheme(
          brightness: Brightness.light,
          primary: const Color(0xFF059669), // Emerald 600
          onPrimary: Colors.white,
          secondary: const Color(0xFFD97706), // Amber 600
          background: const Color(0xFFF0FDF4), // Emerald 50
          surface: Colors.white,
          onBackground: const Color(0xFF064E3B), // Emerald 900
          onSurface: const Color(0xFF064E3B),
        );
      case ThemePalette.cyberpunkRose:
        return _buildTheme(
          brightness: Brightness.light,
          primary: const Color(0xFF9333EA), // Purple 600
          onPrimary: Colors.white,
          secondary: const Color(0xFFDB2777), // Pink 600
          background: const Color(0xFFFDF2F8), // Pink 50
          surface: Colors.white,
          onBackground: const Color(0xFF1E1B4B), // Indigo 950
          onSurface: const Color(0xFF1E1B4B),
        );
      case ThemePalette.deepPurpleGold:
        return _buildTheme(
          brightness: Brightness.light,
          primary: const Color(0xFF6D28D9), // Purple 700
          onPrimary: Colors.white,
          secondary: const Color(0xFFD97706), // Amber 600
          background: const Color(0xFFF5F3FF), // Purple 50
          surface: Colors.white,
          onBackground: const Color(0xFF2E1065), // Purple 950
          onSurface: const Color(0xFF2E1065),
        );
      case ThemePalette.coralTeal:
        return _buildTheme(
          brightness: Brightness.light,
          primary: const Color(0xFFE11D48), // Rose 600
          onPrimary: Colors.white,
          secondary: const Color(0xFF0D9488), // Teal 600
          background: const Color(0xFFFFF1F2), // Rose 50
          surface: Colors.white,
          onBackground: const Color(0xFF4C0519), // Rose 950
          onSurface: const Color(0xFF4C0519),
        );
      case ThemePalette.sunsetOrange:
        return _buildTheme(
          brightness: Brightness.light,
          primary: const Color(0xFFEA580C), // Orange 600
          onPrimary: Colors.white,
          secondary: const Color(0xFFDB2777), // Pink 600
          background: const Color(0xFFFFF7ED), // Orange 50
          surface: Colors.white,
          onBackground: const Color(0xFF431407), // Orange 955
          onSurface: const Color(0xFF431407),
        );
      case ThemePalette.forestMint:
        return _buildTheme(
          brightness: Brightness.light,
          primary: const Color(0xFF15803D), // Green 700
          onPrimary: Colors.white,
          secondary: const Color(0xFF059669), // Emerald 600
          background: const Color(0xFFF0FDF4), // Green 50
          surface: Colors.white,
          onBackground: const Color(0xFF14532D), // Green 950
          onSurface: const Color(0xFF14532D),
        );
      case ThemePalette.monochromeInk:
        return _buildTheme(
          brightness: Brightness.light,
          primary: const Color(0xFF18181B), // Zinc 900
          onPrimary: Colors.white,
          secondary: const Color(0xFF52525B), // Zinc 600
          background: const Color(0xFFF4F4F5), // Zinc 100
          surface: Colors.white,
          onBackground: const Color(0xFF09090B), // Zinc 950
          onSurface: const Color(0xFF09090B),
        );
      case ThemePalette.oceanBreeze:
        return _buildTheme(
          brightness: Brightness.light,
          primary: const Color(0xFF1D4ED8), // Blue 700
          onPrimary: Colors.white,
          secondary: const Color(0xFF0891B2), // Cyan 600
          background: const Color(0xFFEFF6FF), // Blue 50
          surface: Colors.white,
          onBackground: const Color(0xFF1E3A8A), // Blue 950
          onSurface: const Color(0xFF1E3A8A),
        );
    }
  }

  /// Obtiene el ThemeData para el Oscuro (Dark) basado en la paleta seleccionada
  static ThemeData getDarkTheme(ThemePalette palette) {
    switch (palette) {
      case ThemePalette.indigoSlate:
        return _buildTheme(
          brightness: Brightness.dark,
          primary: const Color(0xFF818CF8), // Indigo 400
          onPrimary: const Color(0xFF0F172A),
          secondary: const Color(0xFF38BDF8), // Sky 400
          background: const Color(0xFF0F172A), // Slate 900
          surface: const Color(0xFF1E293B), // Slate 800
          onBackground: const Color(0xFFF1F5F9), // Slate 100
          onSurface: const Color(0xFFF1F5F9),
        );
      case ThemePalette.emeraldAmber:
        return _buildTheme(
          brightness: Brightness.dark,
          primary: const Color(0xFF34D399), // Emerald 400
          onPrimary: const Color(0xFF062F24),
          secondary: const Color(0xFFF59E0B), // Amber 500
          background: const Color(0xFF062F24), // Emerald 950
          surface: const Color(0xFF0A4736), // Emerald 900
          onBackground: const Color(0xFFECFDF5), // Emerald 50
          onSurface: const Color(0xFFECFDF5),
        );
      case ThemePalette.cyberpunkRose:
        return _buildTheme(
          brightness: Brightness.dark,
          primary: const Color(0xFFD946EF), // Fuchsia 500
          onPrimary: const Color(0xFF09090B),
          secondary: const Color(0xFFF43F5E), // Rose 500
          background: const Color(0xFF09090B), // Zinc 950 (Pitch Black)
          surface: const Color(0xFF18181B), // Zinc 900
          onBackground: const Color(0xFFFAFAFA), // Zinc 50
          onSurface: const Color(0xFFFAFAFA),
        );
      case ThemePalette.deepPurpleGold:
        return _buildTheme(
          brightness: Brightness.dark,
          primary: const Color(0xFFA78BFA), // Purple 400
          onPrimary: const Color(0xFF1E1B4B),
          secondary: const Color(0xFFFBBF24), // Amber 400
          background: const Color(0xFF1E1B4B), // Indigo 950
          surface: const Color(0xFF2D2A72),
          onBackground: const Color(0xFFF5F3FF),
          onSurface: const Color(0xFFF5F3FF),
        );
      case ThemePalette.coralTeal:
        return _buildTheme(
          brightness: Brightness.dark,
          primary: const Color(0xFFFB7185), // Rose 400
          onPrimary: const Color(0xFF4C0519),
          secondary: const Color(0xFF2DD4BF), // Teal 400
          background: const Color(0xFF4C0519), // Rose 950
          surface: const Color(0xFF701A2F),
          onBackground: const Color(0xFFFFF1F2),
          onSurface: const Color(0xFFFFF1F2),
        );
      case ThemePalette.sunsetOrange:
        return _buildTheme(
          brightness: Brightness.dark,
          primary: const Color(0xFFFB923C), // Orange 400
          onPrimary: const Color(0xFF431407),
          secondary: const Color(0xFFF472B6), // Pink 400
          background: const Color(0xFF431407), // Orange 950
          surface: const Color(0xFF6C200C),
          onBackground: const Color(0xFFFFF7ED),
          onSurface: const Color(0xFFFFF7ED),
        );
      case ThemePalette.forestMint:
        return _buildTheme(
          brightness: Brightness.dark,
          primary: const Color(0xFF4ADE80), // Green 400
          onPrimary: const Color(0xFF052E16),
          secondary: const Color(0xFF34D399), // Emerald 400
          background: const Color(0xFF052E16), // Green 950
          surface: const Color(0xFF14532D),
          onBackground: const Color(0xFFF0FDF4),
          onSurface: const Color(0xFFF0FDF4),
        );
      case ThemePalette.monochromeInk:
        return _buildTheme(
          brightness: Brightness.dark,
          primary: const Color(0xFFE4E4E7), // Zinc 200
          onPrimary: const Color(0xFF09090B),
          secondary: const Color(0xFFA1A1AA), // Zinc 400
          background: const Color(0xFF09090B), // Zinc 950
          surface: const Color(0xFF27272A), // Zinc 800
          onBackground: const Color(0xFFFAFAFA),
          onSurface: const Color(0xFFFAFAFA),
        );
      case ThemePalette.oceanBreeze:
        return _buildTheme(
          brightness: Brightness.dark,
          primary: const Color(0xFF60A5FA), // Blue 400
          onPrimary: const Color(0xFF172554),
          secondary: const Color(0xFF22D3EE), // Cyan 400
          background: const Color(0xFF172554), // Blue 950
          surface: const Color(0xFF1E3A8A),
          onBackground: const Color(0xFFEFF6FF),
          onSurface: const Color(0xFFEFF6FF),
        );
    }
  }

  /// Helper privado para construir un ThemeData moderno a partir de colores primarios
  static ThemeData _buildTheme({
    required Brightness brightness,
    required Color primary,
    required Color onPrimary,
    required Color secondary,
    required Color background,
    required Color surface,
    required Color onBackground,
    required Color onSurface,
  }) {
    final isDark = brightness == Brightness.dark;
    
    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: ColorScheme(
        brightness: brightness,
        primary: primary,
        onPrimary: onPrimary,
        secondary: secondary,
        onSecondary: Colors.white,
        error: Colors.redAccent,
        onError: Colors.white,
        surface: surface,
        onSurface: onSurface,
      ),
      scaffoldBackgroundColor: background,
      
      // Estilo moderno para botones elevados (redondeados y elegantes)
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: onPrimary,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
      ),

      // Estilo moderno para botones de texto
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),

      // Estilo moderno para Cards (usando CardThemeData para compatibilidad)
      cardTheme: CardThemeData(
        color: surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          side: BorderSide(
            color: (isDark ? Colors.white10 : Colors.black12),
            width: 1,
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        margin: const EdgeInsets.all(8),
      ),

      // Estilo moderno para DropdownButtons y menús desplegables
      dropdownMenuTheme: DropdownMenuThemeData(
        menuStyle: MenuStyle(
          backgroundColor: WidgetStateProperty.all(surface),
          elevation: WidgetStateProperty.all(8),
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        ),
      ),

      // Tipografía moderna
      textTheme: const TextTheme(
        headlineMedium: TextStyle(
          fontWeight: FontWeight.w900,
          letterSpacing: -0.5,
        ),
        bodyLarge: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
