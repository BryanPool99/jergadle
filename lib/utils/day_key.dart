/// Utilidades de fecha para el cálculo de la palabra del día y las rachas.
///
/// Se trabaja siempre con la **fecha local** del usuario y con una clave
/// textual `yyyy-MM-dd` que permite comparar días de forma trivial.
class DayKey {
  DayKey._();

  /// Clave `yyyy-MM-dd` de una fecha local.
  static String of(DateTime date) {
    final y = date.year.toString().padLeft(4, '0');
    final m = date.month.toString().padLeft(2, '0');
    final d = date.day.toString().padLeft(2, '0');
    return '$y-$m-$d';
  }

  /// Clave del día de hoy.
  static String today() => of(DateTime.now());

  /// Compara dos claves `yyyy-MM-dd` en orden lexicográfico (equivalente a
  /// cronológico porque el formato es year-month-day de ancho fijo).
  static int compare(String a, String b) => a.compareTo(b);

  /// `true` si [previous] es el día inmediatamente anterior a [current].
  static bool isConsecutive(String previous, String current) {
    final prev = DateTime.parse(previous);
    final cur = DateTime.parse(current);
    final diff = DateTime(cur.year, cur.month, cur.day)
        .difference(DateTime(prev.year, prev.month, prev.day))
        .inDays;
    return diff == 1;
  }

  /// Normaliza una fecha a medianoche local (para evitar errores por la hora).
  static DateTime midnight(DateTime date) =>
      DateTime(date.year, date.month, date.day);
}
