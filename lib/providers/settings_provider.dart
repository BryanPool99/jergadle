import 'package:flutter/foundation.dart';

import '../models/app_settings.dart';
import '../services/sound_service.dart';
import '../services/storage_service.dart';

/// Estado de las preferencias del jugador (tema, sonido, háptica).
class SettingsProvider extends ChangeNotifier {
  SettingsProvider({
    required this.storage,
    this.sound,
  });

  /// Servicio de almacenamiento usado para persistir los ajustes.
  final StorageService storage;

  /// Servicio de sonido (opcional, para poder silenciarlo).
  final SoundService? sound;

  AppSettings _settings = AppSettings.defaults;

  /// Ajustes actuales.
  AppSettings get settings => _settings;

  /// `true` si los sonidos están activados.
  bool get soundEnabled => _settings.soundEnabled;

  /// `true` si el feedback háptico está activado.
  bool get hapticsEnabled => _settings.hapticsEnabled;

  /// Carga los ajustes guardados.
  Future<void> init() async {
    try {
      _settings = await storage.loadSettings();
    } catch (_) {
      _settings = AppSettings.defaults;
    }
    sound?.setEnabled(_settings.soundEnabled);
    notifyListeners();
  }

  /// Aplica y persiste un cambio.
  Future<void> _apply(AppSettings next) async {
    _settings = next;
    sound?.setEnabled(next.soundEnabled);
    notifyListeners();
    try {
      await storage.saveSettings(next);
    } catch (_) {
      // Sin persistencia los ajustes viven sólo en memoria.
    }
  }

  /// Alterna entre tema claro y oscuro.
  Future<void> toggleTheme() => _apply(_settings.toggleTheme());

  /// Activa o desactiva los efectos de sonido.
  Future<void> toggleSound() =>
      _apply(_settings.copyWith(soundEnabled: !_settings.soundEnabled));

  /// Activa o desactiva el feedback háptico.
  Future<void> toggleHaptics() =>
      _apply(_settings.copyWith(hapticsEnabled: !_settings.hapticsEnabled));

  /// Muestra u oculta las ayudas en la pantalla inicial.
  Future<void> toggleKeyboardHints() => _apply(
        _settings.copyWith(showKeyboardHints: !_settings.showKeyboardHints),
      );
}
