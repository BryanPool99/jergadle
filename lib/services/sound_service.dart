import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';

/// Efectos de sonido del juego.
///
/// Usa un pequeño conjunto de sonidos generados para Jergadle (ver
/// `assets/audio`). Cada efecto se reproduce en un reproductor propio para
/// que dos sonidos puedan solaparse (por ejemplo, la nota de una letra
/// mientras se revela la fila).
class SoundService {
  SoundService();

  final Map<SoundEffect, AudioPlayer> _players = <SoundEffect, AudioPlayer>{};

  bool _enabled = true;

  /// `true` si los sonidos están activados.
  bool get isEnabled => _enabled;

  /// Activa o desactiva el sonido.
  void setEnabled(bool value) => _enabled = value;

  /// Prepara los reproductores (se llama una vez al iniciar la app).
  Future<void> init() async {
    for (final effect in SoundEffect.values) {
      final player = AudioPlayer(playerId: 'jergadle_${effect.name}');
      try {
        await player.setReleaseMode(ReleaseMode.stop);
        await player.setSource(AssetSource('audio/${effect.file}'));
      } catch (error) {
        debugPrint('No se pudo cargar el sonido ${effect.file}: $error');
      }
      _players[effect] = player;
    }
  }

  /// Reproduce un efecto (no hace nada si el sonido está desactivado).
  Future<void> play(SoundEffect effect) async {
    if (!_enabled) return;
    final player = _players[effect];
    if (player == null) return;
    try {
      await player.stop();
      await player.resume();
    } catch (error) {
      debugPrint('Error reproduciendo ${effect.name}: $error');
    }
  }

  /// Libera los reproductores.
  Future<void> dispose() async {
    for (final player in _players.values) {
      await player.dispose();
    }
    _players.clear();
  }
}

/// Catálogo de efectos de sonido.
enum SoundEffect {
  /// Pulsación de una tecla.
  key('key.wav'),

  /// Envío de una palabra.
  submit('submit.wav'),

  /// Letra en la posición correcta.
  correct('correct.wav'),

  /// Letra presente en otra posición.
  present('present.wav'),

  /// Letra ausente.
  absent('absent.wav'),

  /// Partida ganada.
  win('win.wav'),

  /// Partida perdida.
  lose('lose.wav');

  const SoundEffect(this.file);

  /// Nombre del archivo dentro de `assets/audio`.
  final String file;
}
