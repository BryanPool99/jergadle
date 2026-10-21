import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/theme/app_theme.dart';
import '../../models/game_stats.dart';
import '../../models/word_entry.dart';

/// Diálogo modal con las estadísticas del jugador y el significado de la
/// jerga del día.
class StatsDialog extends StatelessWidget {
  const StatsDialog({
    super.key,
    required this.stats,
    required this.wordEntry,
    required this.won,
    required this.attempts,
  });

  /// Estadísticas acumuladas del jugador.
  final GameStats stats;

  /// Entrada del diccionario correspondiente a la palabra del día.
  final WordEntry? wordEntry;

  /// `true` si el usuario ganó la partida.
  final bool won;

  /// Número de intentos utilizados.
  final int attempts;

  /// Longitud de la palabra secreta.
  static const int wordLength = 5;

  /// Texto del resultado para compartir.
  String get shareText {
    final word = wordEntry?.normalized ?? '?????';
    final result = won
        ? '¡Adiviné la jerga del día en $attempts ${attempts == 1 ? 'intento' : 'intentos'}!'
        : 'La jerga del día era $word y no la saqué.';
    return 'Jergadle $attempts/$wordLength\n$result';
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.all(16),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 420),
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Text(
                won ? '¡Ganaste, causa!' : 'Se te fue, causa...',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  color: AppTheme.accent,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                wordEntry?.normalized ?? '?????',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 6,
                ),
              ),
              const SizedBox(height: 20),
              _StatsRow(
                label: 'Racha actual',
                value: '${stats.currentStreak}',
              ),
              _StatsRow(
                label: 'Mejor racha',
                value: '${stats.maxStreak}',
              ),
              _StatsRow(
                label: 'Partidas jugadas',
                value: '${stats.gamesPlayed}',
              ),
              _StatsRow(
                label: 'Victorias',
                value: '${stats.gamesWon}',
              ),
              _StatsRow(
                label: '% de aciertos',
                value: '${stats.winRate.toStringAsFixed(0)}%',
              ),
              const SizedBox(height: 16),
              _Distribution(distribution: stats.guessDistribution),
              const SizedBox(height: 20),
              if (wordEntry != null) ...<Widget>[
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: AppTheme.background,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppTheme.tileEmptyBorder),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const Text(
                        'QUÉ SIGNIFICA EN EL PERÚ',
                        style: TextStyle(
                          color: AppTheme.accent,
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.2,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        wordEntry!.definition,
                        style: const TextStyle(fontSize: 14, height: 1.4),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
              ],
              Row(
                children: <Widget>[
                  Expanded(
                    child: TextButton.icon(
                      onPressed: () {
                        Navigator.of(context).pop();
                        showShareSheet(context, shareText);
                      },
                      icon: const Icon(Icons.ios_share, size: 18),
                      label: const Text('Compartir'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: FilledButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Cerrar'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Fila etiqueta / valor de las estadísticas.
class _StatsRow extends StatelessWidget {
  const _StatsRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(label, style: const TextStyle(color: AppTheme.subtle, fontSize: 14)),
          Text(
            value,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }
}

/// Histograma con la distribución de intentos usados para ganar.
class _Distribution extends StatelessWidget {
  const _Distribution({required this.distribution});

  final List<int> distribution;

  @override
  Widget build(BuildContext context) {
    final maxValue = distribution.fold<int>(1, (a, b) => b > a ? b : a);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Text(
          'DISTRIBUCIÓN DE INTENTOS',
          style: TextStyle(
            color: AppTheme.subtle,
            fontSize: 11,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: 8),
        for (var i = 0; i < distribution.length; i++)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 2),
            child: Row(
              children: <Widget>[
                SizedBox(
                  width: 20,
                  child: Text(
                    '${i + 1}',
                    style: const TextStyle(color: AppTheme.subtle, fontSize: 13),
                  ),
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Container(
                    height: 18,
                    decoration: BoxDecoration(
                      color: AppTheme.background,
                      borderRadius: BorderRadius.circular(3),
                      border: Border.all(color: AppTheme.tileEmptyBorder),
                    ),
                    child: FractionallySizedBox(
                      alignment: Alignment.centerLeft,
                      widthFactor: distribution[i] / maxValue,
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppTheme.correct,
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                SizedBox(
                  width: 26,
                  child: Text(
                    '${distribution[i]}',
                    textAlign: TextAlign.right,
                    style: const TextStyle(fontSize: 13),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

/// Hoja inferior para compartir el resultado (móvil) o diálogo (web).
Future<void> showShareSheet(BuildContext context, String text) {
  return showModalBottomSheet<void>(
    context: context,
    backgroundColor: const Color(0xFF1A1A1B),
    builder: (BuildContext sheetContext) => SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text(
              text,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16, height: 1.5),
            ),
            const SizedBox(height: 20),
            FilledButton.icon(
              onPressed: () async {
                await Clipboard.setData(ClipboardData(text: text));
                if (sheetContext.mounted) Navigator.of(sheetContext).pop();
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Resultado copiado al portapapeles')),
                  );
                }
              },
              icon: const Icon(Icons.copy, size: 18),
              label: const Text('Copiar resultado'),
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: () => Navigator.of(sheetContext).pop(),
              child: const Text('Cerrar'),
            ),
          ],
        ),
      ),
    ),
  );
}
