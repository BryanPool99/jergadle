import 'package:flutter/material.dart';

/// Paleta y estilos globales de Jergadle.
///
/// La paleta replica el contraste alto del clásico "Wordle" para que los tres
/// estados de color (verde / amarillo / gris) se distinguan de inmediato
/// incluso en pantallas pequeñas o con baja luminosidad.
class AppTheme {
  AppTheme._();

  // --- Colores de los estados de evaluación ---
  static const Color correct = Color(0xFF538D4E);
  static const Color present = Color(0xFFB59F3B);
  static const Color absent = Color(0xFF3A3A3C);

  // --- Colores de superficie ---
  static const Color background = Color(0xFF121213);
  static const Color tileEmpty = Color(0xFF121213);
  static const Color tileEmptyBorder = Color(0xFF3A3A3C);
  static const Color onBackground = Color(0xFFF2F2F2);
  static const Color subtle = Color(0xFF9A9A9A);

  // --- Acento de marca ---
  static const Color accent = Color(0xFFE0A93B);

  static ThemeData get dark {
    final base = ThemeData.dark(useMaterial3: true);
    return base.copyWith(
      scaffoldBackgroundColor: background,
      colorScheme: base.colorScheme.copyWith(
        surface: background,
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
        backgroundColor: Color(0xFF1A1A1B),
        surfaceTintColor: Colors.transparent,
      ),
      snackBarTheme: const SnackBarThemeData(
        backgroundColor: Color(0xFF2A2A2C),
        contentTextStyle: TextStyle(color: onBackground),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
