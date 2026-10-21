import 'dart:convert';

import 'game_guess.dart';

/// Estado de una partida (guardado por día).
///
/// Permite restaurar la partida exactamente como estaba si el usuario cierra
/// la app y vuelve a abrirla el mismo día.
class DailyGame {
  const DailyGame({
    required this.dateKey,
    required this.secretIndex,
    required this.secretWord,
    this.guesses = const <GameGuess>[],
    this.status = GameStatus.playing,
  });

  /// Clave `yyyy-MM-dd` del día al que pertenece la partida.
  final String dateKey;

  /// Índice de la palabra secreta dentro del diccionario.
  final int secretIndex;

  /// Palabra secreta (5 letras en mayúsculas).
  ///
  /// Se guarda además del índice para que un cambio en el diccionario no
  /// rompa la partida en curso del usuario.
  final String secretWord;

  /// Intentos ya enviados (evaluados).
  final List<GameGuess> guesses;

  /// Estado actual de la partida.
  final GameStatus status;

  /// `true` si la partida terminó.
  bool get isFinished => status != GameStatus.playing;

  /// `true` si el usuario acertó la palabra.
  bool get isWin => status == GameStatus.won;

  /// `true` si el usuario agotó los intentos.
  bool get isLost => status == GameStatus.lost;

  DailyGame copyWith({
    List<GameGuess>? guesses,
    GameStatus? status,
  }) =>
      DailyGame(
        dateKey: dateKey,
        secretIndex: secretIndex,
        secretWord: secretWord,
        guesses: guesses ?? this.guesses,
        status: status ?? this.status,
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
        'dateKey': dateKey,
        'secretIndex': secretIndex,
        'secretWord': secretWord,
        'guesses': guesses.map((g) => g.toJson()).toList(),
        'status': status.name,
      };

  String encode() => jsonEncode(toJson());

  factory DailyGame.decode(String? raw) {
    if (raw == null || raw.isEmpty) {
      throw const FormatException('Partida vacía');
    }
    final json = jsonDecode(raw) as Map<String, dynamic>;
    return DailyGame(
      dateKey: json['dateKey'] as String? ?? '',
      secretIndex: (json['secretIndex'] as num?)?.toInt() ?? 0,
      secretWord: (json['secretWord'] as String? ?? '').toUpperCase(),
      guesses: (json['guesses'] as List<dynamic>? ?? const <dynamic>[])
          .map((e) => GameGuess.fromJson(e as Map<String, dynamic>))
          .toList(),
      status: GameStatus.values.firstWhere(
        (s) => s.name == json['status'],
        orElse: () => GameStatus.playing,
      ),
    );
  }
}

/// Estado de una partida diaria.
enum GameStatus {
  /// La partida sigue en curso.
  playing,

  /// El usuario adivinó la palabra.
  won,

  /// El usuario agotó los 6 intentos.
  lost,
}
