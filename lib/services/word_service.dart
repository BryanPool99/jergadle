import '../data/peruvian_words.dart';
import '../models/word_entry.dart';
import '../utils/day_key.dart';

/// Servicio que determina la **palabra del día**.
///
/// El cálculo es determinista y local: `índice = días transcurridos %
/// total de palabras`. Al no haber backend, todos los usuarios obtienen la
/// misma palabra en la misma fecha (asumiendo el mismo huso horario local).
class WordService {
  WordService({List<WordEntry>? words}) : _words = words ?? peruvianWords;

  /// Diccionario activo.
  final List<WordEntry> _words;

  /// Fecha base del calendario del juego (día 0).
  static final DateTime epoch = DateTime(2024, 1, 1);

  /// Palabras disponibles.
  List<WordEntry> get words => List<WordEntry>.unmodifiable(_words);

  /// Número total de palabras del diccionario.
  int get wordCount => _words.length;

  /// Días transcurridos desde [epoch] hasta [date] (siempre >= 0).
  int daysSinceEpoch(DateTime date) {
    final diff = DayKey.midnight(date).difference(epoch).inDays;
    return diff < 0 ? 0 : diff;
  }

  /// Índice de la palabra del día para [date].
  int indexForDate(DateTime date) {
    if (_words.isEmpty) return 0;
    return daysSinceEpoch(date) % _words.length;
  }

  /// Palabra del día (entrada completa con definición) para [date].
  WordEntry entryForDate(DateTime date) => _words[indexForDate(date)];

  /// Palabra del día (solo la palabra) para [date].
  String wordForDate(DateTime date) => entryForDate(date).normalized;
}
