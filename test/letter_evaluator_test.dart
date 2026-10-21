import 'package:flutter_test/flutter_test.dart';
import 'package:jergadle/models/game_guess.dart';
import 'package:jergadle/services/letter_evaluator.dart';

void main() {
  group('LetterEvaluator', () {
    test('marca verde todas las letras cuando el intento es exacto', () {
      final result = LetterEvaluator.evaluate(guess: 'PLATA', secret: 'PLATA');
      expect(result.isWin, isTrue);
      expect(result.results, everyElement(LetterResult.correct));
    });

    test('marca gris las letras ausentes', () {
      final result = LetterEvaluator.evaluate(guess: 'XXXXX', secret: 'PLATA');
      expect(result.results, everyElement(LetterResult.absent));
    });

    test('detecta amarillo cuando la letra existe en otra posición', () {
      // Secreto: PLATA.  Intento: TALPA
      // T -> no en pos 0 (P) -> presente
      // A -> PATA? no, secreto[1] = L -> presente
      // L -> secreto[2] = A -> presente
      // P -> secreto[3] = T -> presente
      // A -> secreto[4] = A -> correcto
      final result = LetterEvaluator.evaluate(guess: 'TALPA', secret: 'PLATA');
      expect(result.results[0], LetterResult.present);
      expect(result.results[1], LetterResult.present);
      expect(result.results[2], LetterResult.present);
      expect(result.results[3], LetterResult.present);
      expect(result.results[4], LetterResult.correct);
    });

    test('maneja letras repetidas: no marca amarillo de más', () {
      // Secreto: PAPAS (P:2, A:2, S:1).  Intento: AAAAA
      // Las A en posición 1 y 3 caen en verde y consumen las 2 A disponibles,
      // por lo que las demás A deben quedar grises.
      final result = LetterEvaluator.evaluate(guess: 'AAAAA', secret: 'PAPAS');
      expect(result.results[0], LetterResult.absent);
      expect(result.results[1], LetterResult.correct);
      expect(result.results[2], LetterResult.absent);
      expect(result.results[3], LetterResult.correct);
      expect(result.results[4], LetterResult.absent);
    });

    test('las letras verdes se consumen antes de marcar amarillos', () {
      // Secreto: PAPAS.  Intento: SPAPP
      // Ninguna letra cae en verde; hay 2 P y 2 A disponibles, así que
      // S, P, A, P quedan amarillas y la última P se agota y queda gris.
      final result = LetterEvaluator.evaluate(guess: 'SPAPP', secret: 'PAPAS');
      expect(result.results[0], LetterResult.present);
      expect(result.results[1], LetterResult.present);
      expect(result.results[2], LetterResult.present);
      expect(result.results[3], LetterResult.present);
      expect(result.results[4], LetterResult.absent);
    });

    test('prioriza la posición correcta sobre la letra presente', () {
      final result = LetterEvaluator.evaluate(guess: 'PLATA', secret: 'PLATA');
      expect(result.isWin, isTrue);
      expect(result.results.every((r) => r == LetterResult.correct), isTrue);
    });

    test('rechaza intentos que no son de 5 letras', () {
      expect(LetterEvaluator.isValidGuess('PLATA'), isTrue);
      expect(LetterEvaluator.isValidGuess('PLAT'), isFalse);
      expect(LetterEvaluator.isValidGuess('PLATAS'), isFalse);
    });

    test('acepta la Ñ como letra válida', () {
      expect(LetterEvaluator.isValidGuess('PIÑON'), isTrue);
      final result = LetterEvaluator.evaluate(guess: 'PIÑON', secret: 'PIÑON');
      expect(result.isWin, isTrue);
    });
  });
}
