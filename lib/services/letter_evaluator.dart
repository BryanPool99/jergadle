import '../models/game_guess.dart';

/// Evaluador de intentos contra la palabra secreta.
///
/// Implementa el algoritmo clásico de "dos pasadas" para manejar correctamente
/// las letras repetidas:
///
/// 1. **Primera pasada (verdes):** toda letra que coincide en su posición
///    exacta se marca como [LetterResult.correct] y se "consume" de la
///    palabra secreta.
/// 2. **Segunda pasada (amarillos):** para el resto de letras, se cuenta
///    cuántas veces aparece cada letra en la parte *no consumida* de la
///    palabra secreta. Si queda alguna disponible, la letra se marca como
///    [LetterResult.present]; en caso contrario, [LetterResult.absent].
///
/// Este enfoque evita el error clásico de marcar en amarillo una letra que en
/// realidad no está en la palabra.
class LetterEvaluator {
  LetterEvaluator._();

  /// Evalúa [guess] (5 letras) contra [secret] (5 letras).
  static GuessResult evaluate({required String guess, required String secret}) {
    final g = guess.toUpperCase();
    final s = secret.toUpperCase();
    final n = g.length < s.length ? g.length : s.length;

    final results = List<LetterResult>.filled(n, LetterResult.absent);

    // Disponibilidad de cada letra de la palabra secreta (letras "pool").
    final pool = <String, int>{};
    for (var i = 0; i < s.length; i++) {
      pool[s[i]] = (pool[s[i]] ?? 0) + 1;
    }

    // --- Pasada 1: posiciones correctas (verde) ---
    for (var i = 0; i < n; i++) {
      if (g[i] == s[i]) {
        results[i] = LetterResult.correct;
        pool[g[i]] = (pool[g[i]] ?? 1) - 1;
      }
    }

    // --- Pasada 2: presentes en otra posición (amarillo) ---
    for (var i = 0; i < n; i++) {
      if (results[i] == LetterResult.correct) continue;
      final letter = g[i];
      final available = pool[letter] ?? 0;
      if (available > 0) {
        results[i] = LetterResult.present;
        pool[letter] = available - 1;
      } else {
        results[i] = LetterResult.absent;
      }
    }

    return GuessResult(word: g, results: results);
  }

  /// `true` si [guess] es una palabra de 5 letras formada solo por letras del
  /// alfabeto español (incluida la Ñ).
  static bool isValidGuess(String guess) {
    if (guess.length != 5) return false;
    final allowed = 'ABCDEFGHIJKLMNÑOPQRSTUVWXYZ';
    for (final ch in guess.toUpperCase().split('')) {
      if (!allowed.contains(ch)) return false;
    }
    return true;
  }
}
