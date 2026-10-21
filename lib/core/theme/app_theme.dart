import 'package:flutter/material.dart';

/// Paleta y estilos globales de Jergadle.
///
/// La paleta replica el contraste alto del clásico "Wordle" para que los tres
/// estados de color (verde / amarillo / gris) se distingan de inmediato
/// incluso en pantallas pequeñas o con baja luminosidad.
///
/// Se definen dos temas completos:
/// - [dark]: el clásico, con fondo casi negro.
/// - [light]: fondo claro tipo papel, pensado para uso diurno.
class AppTheme {
  AppTheme._();

  // --- Colores de los estados de evaluación (comunes a ambos temas) ---
  static const Color correct = Color(0xFF538D4E);
  static const Color present = Color(0xFFB59F3B);
  static const Color absent = Color(0xFF3A3A3C);

  // --- Tema oscuro ---
  static const Color background = Color(0xFF121213);
  static const Color tileEmpty = Color(0xFF121213);
  static const Color tileEmptyBorder = Color(0xFF3A3A3C);
  static const Color onBackground = Color(0xFFF2F2F2);
  static const Color subtle = Color(0xFF9A9A9A);
  static const Color surface = Color(0xFF1A1A1B);

  // --- Tema claro ---
  static const Color lightBackground = Color(0xFFFBFBF8);
  static const Color lightTileEmpty = Color(0xFFFBFBF8);
  static const Color lightTileEmptyBorder = Color(0xFFD3D3CC);
  static const Color lightOnBackground = Color(0xFF1A1A1A);
  static const Color lightSubtle = Color(0xFF6E6E6E);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightAccent = Color(0xFFB37A16);

  // --- Acento de marca ---
  static const Color accent = Color(0xFFE0A93B);

  /// Radio de borde estándar de las fichas y tarjetas.
  static const double radius = 8;

  /// Tema oscuro (por defecto).
  static ThemeData get dark {
    final base = ThemeData.dark(useMaterial3: true);
    return base.copyWith(
      scaffoldBackgroundColor: background,
      colorScheme: base.colorScheme.copyWith(
        surface: surface,
        primary: accent,
        onSurface: onBackground,
      ),
      textTheme: base.textTheme.apply(
        bodyColor: onBackground,
        displayColor: onBackground,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: background,
        foregroundColor: onBackground,
        elevation: 0,
        centerTitle: true,
      ),
      dialogTheme: const DialogThemeData(
        backgroundColor: surface,
        surfaceTintColor: Colors.transparent,
      ),
      snackBarTheme: const SnackBarThemeData(
        backgroundColor: Color(0xFF2A2A2C),
        contentTextStyle: TextStyle(color: onBackground),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  /// Tema claro.
  static ThemeData get light {
    final base = ThemeData.light(useMaterial3: true);
    return base.copyWith(
      scaffoldBackgroundColor: lightBackground,
      colorScheme: base.colorScheme.copyWith(
        surface: lightSurface,
        primary: lightAccent,
        onSurface: lightOnBackground,
      ),
      textTheme: base.textTheme.apply(
        bodyColor: lightOnBackground,
        displayColor: lightOnBackground,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: lightBackground,
        foregroundColor: lightOnBackground,
        elevation: 0,
        centerTitle: true,
      ),
      dialogTheme: const DialogThemeData(
        backgroundColor: lightSurface,
        surfaceTintColor: Colors.transparent,
      ),
      snackBarTheme: const SnackBarThemeData(
        backgroundColor: Color(0xFF2A2A2C),
        contentTextStyle: TextStyle(color: Colors.white),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}

/// Colores semánticos resueltos según el tema activo.
///
/// Permite que los widgets usen `context.surface` en vez de hardcodear el
/// color del tema oscuro.
extension ThemeColors on ThemeData {
  Color get surface => colorScheme.surface;

  Color get subtle => brightness == Brightness.dark
      ? AppTheme.subtle
      : AppTheme.lightSubtle;

  Color get onBackground => brightness == Brightness.dark
      ? AppTheme.onBackground
      : AppTheme.lightOnBackground;

  Color get accent => brightness == Brightness.dark
      ? AppTheme.accent
      : AppTheme.lightAccent;

  /// Color de fondo de una ficha vacía.
  Color get tileEmpty => brightness == Brightness.dark
      ? AppTheme.tileEmpty
      : AppTheme.lightTileEmpty;

  /// Color del borde de una ficha vacía.
  Color get tileEmptyBorder => brightness == Brightness.dark
      ? AppTheme.tileEmptyBorder
      : AppTheme.lightTileEmptyBorder;
}
