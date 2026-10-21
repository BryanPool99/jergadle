import 'dart:convert';

/// Estado de una letra dentro de un intento evaluado.
enum LetterResult {
  /// La letra no fue probada todavía.
  none,

  /// Letra correcta y en la posición correcta (verde).
  correct,

  /// Letra presente en la palabra pero en otra posición (amarillo).
  present,

  /// La letra no existe en la palabra secreta (gris).
  absent;

  /// Prioridad para colorear el teclado: verde > amarillo > gris.
  int get priority => switch (this) {
        LetterResult.correct => 3,
        LetterResult.present => 2,
        LetterResult.absent => 1,
        LetterResult.none => 0,
      };
}

/// Resultado de evaluar un intento contra la palabra secreta.
class GuessResult {
  const GuessResult({required this.word, required this.results});

  /// Palabra enviada por el usuario (5 letras en mayúsculas).
  final String word;

  /// Estado de cada letra, en el mismo orden que [word].
  final List<LetterResult> results;

  /// `true` si todas las letras están en la posición correcta.
  bool get isWin =>
      results.length == 5 && results.every((r) => r == LetterResult.correct);

  /// Copia inmutable de los resultados como mapa letra -> estado.
  Map<String, LetterResult> get byLetter => <String, LetterResult>{
        for (var i = 0; i < results.length && i < word.length; i++)
          word[i]: results[i],
      };

  List<int> toJson() => results.map((r) => r.index).toList();

  factory GuessResult.fromJson(List<dynamic> json, String word) =>
      GuessResult(
        word: word,
        results: json
            .map((e) => LetterResult.values[e as int])
            .toList(growable: false),
      );

  @override
  String toString() => 'GuessResult($word -> $results)';
}

/// Un intento (línea del tablero) con su evaluación.
class GameGuess {
  const GameGuess({required this.word, required this.results});

  /// Palabra enviada por el usuario (5 letras, mayúsculas).
  final String word;

  /// Estado de cada letra de [word].
  final List<LetterResult> results;

  /// Intento ya evaluado como objeto completo.
  GuessResult get result => GuessResult(word: word, results: results);

  bool get isWin => result.isWin;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'word': word,
        'results': results.map((r) => r.index).toList(),
      };

  factory GameGuess.fromJson(Map<String, dynamic> json) => GameGuess(
        word: (json['word'] as String? ?? '').toUpperCase(),
        results: GuessResult.fromJson(
          (json['results'] as List<dynamic>? ?? const <dynamic>[]),
          (json['word'] as String? ?? '').toUpperCase(),
        ).results,
      );

  @override
  String toString() => 'GameGuess($word)';
}

/// Utilidades de serialización para [GameGuess].
String encodeGuesses(List<GameGuess> guesses) =>
    jsonEncode(guesses.map((g) => g.toJson()).toList());

List<GameGuess> decodeGuesses(String? raw) {
  if (raw == null || raw.isEmpty) return <GameGuess>[];
  try {
    final list = jsonDecode(raw) as List<dynamic>;
    return list
        .map((e) => GameGuess.fromJson(e as Map<String, dynamic>))
        .toList();
  } on FormatException {
    return <GameGuess>[];
  }
}
