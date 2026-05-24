import 'package:flutter/material.dart';

enum ThemePalette {
  indigoSlate,
  emeraldAmber,
  cyberpunkRose,
  deepPurpleGold,
  coralTeal,
  sunsetOrange,
  forestMint,
  monochromeInk,
  oceanBreeze,
}

extension ThemePaletteX on ThemePalette {
  String get displayName {
    switch (this) {
      case ThemePalette.indigoSlate:
        return 'Indigo Slate';
      case ThemePalette.emeraldAmber:
        return 'Emerald Amber';
      case ThemePalette.cyberpunkRose:
        return 'Cyberpunk Rose';
      case ThemePalette.deepPurpleGold:
        return 'Royal Gold';
      case ThemePalette.coralTeal:
        return 'Coral Teal';
      case ThemePalette.sunsetOrange:
        return 'Sunset Glow';
      case ThemePalette.forestMint:
        return 'Forest Mint';
      case ThemePalette.monochromeInk:
        return 'Monochrome Ink';
      case ThemePalette.oceanBreeze:
        return 'Ocean Breeze';
    }
  }

  Color get primaryColor {
    switch (this) {
      case ThemePalette.indigoSlate:
        return const Color(0xFF4F46E5);
      case ThemePalette.emeraldAmber:
        return const Color(0xFF059669);
      case ThemePalette.cyberpunkRose:
        return const Color(0xFFD946EF);
      case ThemePalette.deepPurpleGold:
        return const Color(0xFF6D28D9);
      case ThemePalette.coralTeal:
        return const Color(0xFFF43F5E);
      case ThemePalette.sunsetOrange:
        return const Color(0xFFF97316);
      case ThemePalette.forestMint:
        return const Color(0xFF15803D);
      case ThemePalette.monochromeInk:
        return const Color(0xFF18181B);
      case ThemePalette.oceanBreeze:
        return const Color(0xFF1D4ED8);
    }
  }

  LinearGradient get gradient {
    switch (this) {
      case ThemePalette.indigoSlate:
        return const LinearGradient(
          colors: [Color(0xFF4F46E5), Color(0xFF0EA5E9)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      case ThemePalette.emeraldAmber:
        return const LinearGradient(
          colors: [Color(0xFF059669), Color(0xFFD97706)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      case ThemePalette.cyberpunkRose:
        return const LinearGradient(
          colors: [Color(0xFFD946EF), Color(0xFFF43F5E)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      case ThemePalette.deepPurpleGold:
        return const LinearGradient(
          colors: [Color(0xFF6D28D9), Color(0xFFF59E0B)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      case ThemePalette.coralTeal:
        return const LinearGradient(
          colors: [Color(0xFFF43F5E), Color(0xFF0D9488)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      case ThemePalette.sunsetOrange:
        return const LinearGradient(
          colors: [Color(0xFFF97316), Color(0xFFEC4899)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      case ThemePalette.forestMint:
        return const LinearGradient(
          colors: [Color(0xFF15803D), Color(0xFF10B981)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      case ThemePalette.monochromeInk:
        return const LinearGradient(
          colors: [Color(0xFF18181B), Color(0xFF71717A)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      case ThemePalette.oceanBreeze:
        return const LinearGradient(
          colors: [Color(0xFF1D4ED8), Color(0xFF06B6D4)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
    }
  }
}

class ThemeState {
  const ThemeState({
    required this.themeMode,
    required this.palette,
  });

  final ThemeMode themeMode;
  final ThemePalette palette;

  @override
  String toString() => 'ThemeState(mode: $themeMode, palette: $palette)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ThemeState &&
          runtimeType == other.runtimeType &&
          themeMode == other.themeMode &&
          palette == other.palette;

  @override
  int get hashCode => themeMode.hashCode ^ palette.hashCode;
}
