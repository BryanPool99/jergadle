import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../core/theme/app_theme.dart';
import '../../providers/game_provider.dart';
import '../widgets/app_header.dart';
import '../widgets/grid_board.dart';
import '../widgets/stats_dialog.dart';
import '../widgets/virtual_keyboard.dart';

/// Pantalla principal del juego.
///
/// Layout responsive:
/// - Móvil (ancho < 700): cabecera, tablero, teclado en columna.
/// - Web / tablet (ancho >= 700): panel lateral con estadísticas + hints.
class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  bool _dialogShown = false;

  @override
  Widget build(BuildContext context) {
    final game = context.watch<GameProvider>();

    // Mostrar el diálogo automáticamente al terminar la partida.
    if (game.isGameOver && !_dialogShown) {
      _dialogShown = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        _showStatsDialog(game);
      });
    } else if (!game.isGameOver) {
      _dialogShown = false;
    }

    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            final bool isWide = constraints.maxWidth >= 700;
            return Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 900),
                child: Column(
                  children: <Widget>[
                    AppHeader(
                      stats: game.stats,
                      dayNumber: game.wordService.daysSinceEpoch(
                        DateTime.now(),
                      ) + 1,
                      onStatsPressed: () => _showStatsDialog(game),
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: isWide
                            ? _wideLayout(game: game)
                            : _narrowLayout(game: game),
                      ),
                    ),
                    _keyboardSection(game: game),
                    const SizedBox(height: 8),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  /// Layout compacto (móvil).
  Widget _narrowLayout({required GameProvider game}) {
    return Column(
      children: <Widget>[
        const SizedBox(height: 8),
        _boardSection(game: game),
        const SizedBox(height: 12),
        _statusLine(game: game),
        const SizedBox(height: 12),
      ],
    );
  }

  /// Layout ancho (web / tablet) con panel lateral.
  Widget _wideLayout({required GameProvider game}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Expanded(
          child: Column(
            children: <Widget>[
              const SizedBox(height: 8),
              _boardSection(game: game),
              const SizedBox(height: 12),
              _statusLine(game: game),
            ],
          ),
        ),
        const SizedBox(width: 24),
        SizedBox(
          width: 260,
          child: Padding(
            padding: const EdgeInsets.only(top: 20),
            child: _infoPanel(game: game),
          ),
        ),
      ],
    );
  }

  /// Tablero centrado con tamaño adaptativo.
  Widget _boardSection({required GameProvider game}) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        const spacing = 6.0;
        const maxCell = 62.0;
        final available = constraints.maxWidth - spacing * 4;
        var cell = available / 5;
        if (cell > maxCell) cell = maxCell;
        if (cell < 32) cell = 32;

        return Center(
          child: GridBoard(
            rows: game.board,
            cellSize: cell,
            spacing: spacing,
          ),
        );
      },
    );
  }

  /// Línea de estado bajo el tablero.
  Widget _statusLine({required GameProvider game}) {
    String text;
    IconData icon;
    Color color;

    if (game.isGameOver) {
      final won = game.isWin;
      text = won
          ? '¡La pegaste! La jerga era ${game.secretWord}'
          : 'La jerga era ${game.secretWord}';
      icon = won ? Icons.emoji_events : Icons.sentiment_dissatisfied;
      color = won ? AppTheme.correct : AppTheme.subtle;
    } else if (game.attemptsRemaining <= 2) {
      text = '¡Últimos ${game.attemptsRemaining} intentos!';
      icon = Icons.warning_amber_rounded;
      color = AppTheme.accent;
    } else {
      text = 'Adivina la jerga peruana de 5 letras';
      icon = Icons.lightbulb_outline;
      color = AppTheme.subtle;
    }

    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: AppTheme.background,
          border: Border.all(color: AppTheme.tileEmptyBorder),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(icon, size: 18, color: color),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                text,
                style: TextStyle(color: color, fontSize: 13),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Panel lateral de información (solo en layout ancho).
  Widget _infoPanel({required GameProvider game}) {
    final stats = game.stats;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        _InfoCard(
          title: 'RACHAS',
          children: <Widget>[
            _InfoRow(label: 'Actual', value: '${stats.currentStreak}'),
            _InfoRow(label: 'Mejor', value: '${stats.maxStreak}'),
            _InfoRow(
              label: 'Aciertos',
              value: '${stats.winRate.toStringAsFixed(0)}%',
            ),
          ],
        ),
        const SizedBox(height: 12),
        _InfoCard(
          title: 'PARTIDAS',
          children: <Widget>[
            _InfoRow(label: 'Jugadas', value: '${stats.gamesPlayed}'),
            _InfoRow(label: 'Ganadas', value: '${stats.gamesWon}'),
          ],
        ),
        const SizedBox(height: 12),
        _InfoCard(
          title: 'CÓMO JUGAR',
          children: <Widget>[
            const Text(
              '• Verde: letra en su posición.\n'
              '• Amarillo: letra presente, mal posición.\n'
              '• Gris: la letra no está.\n'
              '• 6 intentos por día.',
              style: TextStyle(fontSize: 12, color: AppTheme.subtle, height: 1.6),
            ),
          ],
        ),
      ],
    );
  }

  /// Teclado virtual con soporte de teclado físico.
  Widget _keyboardSection({required GameProvider game}) {
    return Focus(
      autofocus: true,
      onKeyEvent: (FocusNode node, KeyEvent event) {
        if (event is! KeyDownEvent && event is! KeyRepeatEvent) {
          return KeyEventResult.ignored;
        }
        if (event.logicalKey == LogicalKeyboardKey.enter ||
            event.logicalKey == LogicalKeyboardKey.numpadEnter) {
          game.submitGuess();
          return KeyEventResult.handled;
        }
        if (event.logicalKey == LogicalKeyboardKey.backspace) {
          game.backspace();
          return KeyEventResult.handled;
        }
        final letter = physicalKeyToLetter(event);
        if (letter != null) {
          game.addLetter(letter);
          return KeyEventResult.handled;
        }
        return KeyEventResult.ignored;
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6),
        child: VirtualKeyboard(
          enabled: !game.isGameOver,
          keyStates: game.keyboardState,
          onLetter: (String letter) {
            keyboardHaptic();
            game.addLetter(letter);
          },
          onSubmit: () {
            keyboardHaptic();
            game.submitGuess();
          },
          onBackspace: () {
            keyboardHaptic();
            game.backspace();
          },
        ),
      ),
    );
  }

  /// Muestra el modal con estadísticas y la definición de la jerga.
  Future<void> _showStatsDialog(GameProvider game) async {
    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) => StatsDialog(
        stats: game.stats,
        wordEntry: game.secretEntry,
        won: game.isWin,
        attempts: game.attemptsUsed,
      ),
    );
    if (!mounted) return;
    // Tras cerrar el diálogo se ofrece seguir jugando (modo práctica).
    if (game.isGameOver) {
      final bool? playAgain = await showDialog<bool>(
        context: context,
        builder: (BuildContext ctx) => AlertDialog(
          title: const Text('¿Seguir jugando?'),
          content: const Text(
            'La jerga del día ya se terminó. Puedes seguir en modo práctica '
            'para no perder la racha ni alterar tus estadísticas.',
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(false),
              child: const Text('Salir'),
            ),
            FilledButton(
              onPressed: () => Navigator.of(ctx).pop(true),
              child: const Text('Seguir practicando'),
            ),
          ],
        ),
      );
      if (playAgain == true) {
        await game.startPractice();
      }
    }
  }
}

/// Tarjeta de información del panel lateral.
class _InfoCard extends StatelessWidget {
  const _InfoCard({required this.title, required this.children});

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1B),
        border: Border.all(color: AppTheme.tileEmptyBorder),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.2,
              color: AppTheme.accent,
            ),
          ),
          const SizedBox(height: 10),
          ...children,
        ],
      ),
    );
  }
}

/// Fila etiqueta / valor del panel lateral.
class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(label, style: const TextStyle(fontSize: 13, color: AppTheme.subtle)),
          Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }
}
