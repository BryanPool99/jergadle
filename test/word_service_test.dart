import 'package:flutter_test/flutter_test.dart';
import 'package:jergadle/data/peruvian_words.dart';
import 'package:jergadle/services/word_service.dart';

void main() {
  group('Diccionario de jergas', () {
    test('tiene al menos 80 palabras', () {
      expect(peruvianWords.length, greaterThanOrEqualTo(80));
    });

    test('todas las palabras tienen 5 letras y definición', () {
      for (final entry in peruvianWords) {
        expect(entry.normalized.length, 5, reason: 'Palabra inválida: ${entry.word}');
        // Mayúsculas: el juego sólo acepta letras del teclado.
        expect(
          entry.normalized,
          matches(RegExp(r'^[A-ZÑ]{5}$')),
          reason: 'Palabra inválida: ${entry.word}',
        );
        expect(entry.definition.trim(), isNotEmpty, reason: 'Sin definición: ${entry.word}');
      }
    });

    test('cada palabra se puede teclear con el teclado virtual', () {
      // Las teclas disponibles en el teclado de la app.
      const available = 'ABCDEFGHIJKLMNÑOPQRSTUVWXYZ';
      for (final entry in peruvianWords) {
        for (final letter in entry.normalized.split('')) {
          expect(
            available.contains(letter),
            isTrue,
            reason: 'La letra "$letter" de ${entry.word} no está en el teclado',
          );
        }
      }
    });

    test('las definiciones no tienen caracteres corruptos', () {
      for (final entry in peruvianWords) {
        // CJK, cirílico, etc. Provienen de un pegado con mala codificación.
        expect(
          entry.definition,
          isNot(matches(RegExp(r'[\u4e00-\u9fff\u0400-\u04ff\uac00-\ud7ff]'))),
          reason: 'Definición con caracteres raros: ${entry.word}',
        );
      }
    });

    test('no hay palabras duplicadas', () {
      final words = peruvianWords.map((e) => e.normalized).toList();
      expect(words.toSet().length, words.length);
    });
  });

  group('WordService', () {
    final service = WordService();

    test('la palabra del día es estable para la misma fecha', () {
      final date = DateTime(2026, 3, 15);
      expect(service.wordForDate(date), service.wordForDate(date));
    });

    test('la palabra del día rota cada día', () {
      final d1 = service.wordForDate(DateTime(2026, 3, 15));
      final d2 = service.wordForDate(DateTime(2026, 3, 16));
      expect(d1, isNot(d2));
    });

    test('el índice usa el módulo del total de palabras', () {
      final date = DateTime(2026, 3, 15);
      final days = date.difference(WordService.epoch).inDays;
      expect(service.indexForDate(date), days % peruvianWords.length);
    });

    test('cicla correctamente tras un ciclo completo', () {
      final date = DateTime(2026, 3, 15);
      final cycle = peruvianWords.length;
      expect(
        service.wordForDate(date.add(Duration(days: cycle))),
        service.wordForDate(date),
      );
    });
  });
}
