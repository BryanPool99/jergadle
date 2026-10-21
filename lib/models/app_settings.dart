import 'dart:convert';

import 'package:flutter/material.dart';

/// Ajustes de preferencias del jugador.
///
/// Se persisten en `SharedPreferences` para que la preferencia sobreviva a
/// reinicios de la app.
class AppSettings {
  const AppSettings({
    this.themeMode = ThemeMode.dark,
    this.soundEnabled = true,
    this.hapticsEnabled = true,
    this.showKeyboardHints = true,
  });

  /// Modo de tema preferido (sistema, claro u oscuro).
  final ThemeMode themeMode;

  /// `true` si los efectos de sonido están activados.
  final bool soundEnabled;

  /// `true` si el feedback háptico está activado.
  final bool hapticsEnabled;

  /// `true` si se muestran las ayudas ("cómo jugar") en la pantalla inicial.
  final bool showKeyboardHints;

  /// Ajustes por defecto.
  static const AppSettings defaults = AppSettings();

  AppSettings copyWith({
    ThemeMode? themeMode,
    bool? soundEnabled,
    bool? hapticsEnabled,
    bool? showKeyboardHints,
  }) =>
      AppSettings(
        themeMode: themeMode ?? this.themeMode,
        soundEnabled: soundEnabled ?? this.soundEnabled,
        hapticsEnabled: hapticsEnabled ?? this.hapticsEnabled,
        showKeyboardHints: showKeyboardHints ?? this.showKeyboardHints,
      );

  /// Alterna entre tema claro y oscuro.
  AppSettings toggleTheme() => copyWith(
        themeMode: themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light,
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
        'themeMode': themeMode.name,
        'soundEnabled': soundEnabled,
        'hapticsEnabled': hapticsEnabled,
        'showKeyboardHints': showKeyboardHints,
      };

  String encode() => jsonEncode(toJson());

  factory AppSettings.fromJson(Map<String, dynamic> json) => AppSettings(
        themeMode: ThemeMode.values.firstWhere(
          (m) => m.name == json['themeMode'],
          orElse: () => ThemeMode.dark,
        ),
        soundEnabled: json['soundEnabled'] as bool? ?? true,
        hapticsEnabled: json['hapticsEnabled'] as bool? ?? true,
        showKeyboardHints: json['showKeyboardHints'] as bool? ?? true,
      );

  /// Lee los ajustes desde un JSON serializado.
  static AppSettings decode(String? raw) {
    if (raw == null || raw.isEmpty) return defaults;
    try {
      return AppSettings.fromJson(jsonDecode(raw) as Map<String, dynamic>);
    } catch (_) {
      return defaults;
    }
  }
}
