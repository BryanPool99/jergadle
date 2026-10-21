/// Entrada del diccionario de jergas peruanas.
///
/// Cada [word] tiene exactamente 5 letras (la Ñ cuenta como una) y un
/// [definition] con el significado popular peruano de la jerga.
class WordEntry {
  const WordEntry({required this.word, required this.definition});

  /// Palabra secreta en mayúsculas, siempre de 5 letras.
  final String word;

  /// Significado / uso popular de la jerga en el Perú.
  final String definition;

  /// Palabra normalizada (mayúsculas, sin espacios).
  String get normalized => word.toUpperCase().trim();

  /// `true` si la palabra cumple el formato requerido por el juego.
  bool get isValid => normalized.length == 5;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'word': normalized,
        'definition': definition,
      };

  factory WordEntry.fromJson(Map<String, dynamic> json) => WordEntry(
        word: (json['word'] as String? ?? ''),
        definition: (json['definition'] as String? ?? ''),
      );

  @override
  String toString() => 'WordEntry($normalized)';

  @override
  bool operator ==(Object other) =>
      other is WordEntry && other.normalized == normalized;

  @override
  int get hashCode => normalized.hashCode;
}
