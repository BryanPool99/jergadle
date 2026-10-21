import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../core/theme/app_theme.dart';
import '../../models/daily_game.dart';
import '../../models/game_guess.dart';
import '../../providers/game_provider.dart';
import '../../providers/settings_provider.dart';
import '../../services/sound_service.dart';
import '../widgets/app_header.dart';
import '../widgets/grid_board.dart';
import '../widgets/shake_transition.dart';
import '../widgets/stats_dialog.dart';
import '../widgets/virtual_keyboard.dart';

/// Pantalla principal del juego.
///
/// Layout responsive:
/// - Móvil (ancho < 700): cabecera, tablero, teclado en columna.
/// - Web / tablet (ancho >= 700): panel lateral con estadísticas + hints.
class GameScreen extends StatefulWidget {
  const GameScreen({super.key, this.initialLetter});

  /// Letra que se escribe automáticamente al entrar (teclado físico).
  final String? initialLetter;

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen>
    with WidgetsBindingObserver, SingleTickerProviderStateMixin {
  bool _dialogShown = false;

  /// Número de intentos ya revelados (para detectar filas nuevas).
  int _revealedGuesses = 0;

  /// Estado de juego de la última revisión (para detectar fin de partida).
  GameStatus _lastStatus = GameStatus.playing;

  /// Último contador de intentos inválidos visto.
  int _lastInvalidCount = 0;

  /// Controlador de la entrada animada de la pantalla.
  late final AnimationController _entrance = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 650),
  );

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _entrance.forward();

    // Letra escrita desde la pantalla de inicio.
    final initial = widget.initialLetter;
    if (initial != null && initial.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        context.read<GameProvider>().addLetter(initial);
      });
    }
  }

  @override
  void dispose() {
    _entrance.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // Al volver a la app puede haber cambiado el día (la app quedó abierta
    // a medianoche): se prepara la nueva palabra del día.
    if (state == AppLifecycleState.resumed) {
      context.read<GameProvider>().checkNewDay();
    }
  }

  @override
  Widget build(BuildContext context) {
    final game = context.watch<GameProvider>();

    // Sonido al revelar una fila nueva.
    if (game.guesses.length != _revealedGuesses) {
      _revealedGuesses = game.guesses.length;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        _playGuessSound(game);
      });
    }

    // Aviso visual cuando se envía un intento incompleto.
    if (game.invalidAttemptCount != _lastInvalidCount) {
      final isFirst = _lastInvalidCount == 0;
      _lastInvalidCount = game.invalidAttemptCount;
      if (!isFirst) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!mounted) return;
          _showInvalidAttemptHint();
        });
      }
    }

    // Sonido de victoria o derrota.
    if (game.status != _lastStatus) {
      _lastStatus = game.status;
      if (game.isGameOver) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!mounted) return;
          _playEndSound(game);
        });
      }
    }

    // Mostrar el diálogo automáticamente al terminar la partida diaria.
    // En modo práctica se muestra un resumen simple sin afectar estadísticas.
    if (game.isGameOver && !_dialogShown) {
      _dialogShown = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        if (game.isPractice) {
          _showPracticeSummary(game);
        } else {
          _showStatsDialog(game);
        }
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
                constraints: const BoxConstraints(maxWidth: 1100),
                child: Column(
                  children: <Widget>[
                    AppHeader(
                      stats: game.stats,
                      dayNumber: game.wordService.daysSinceEpoch(
                        DateTime.now(),
                      ) + 1,
                      onStatsPressed: () => _showStatsDialog(game),
                      onBackPressed: () =>
                          Navigator.of(context).maybePop(),
                    ),
                    Expanded(
                      child: LayoutBuilder(
                        builder: (BuildContext context, BoxConstraints inner) {
                          return SingleChildScrollView(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child: ConstrainedBox(
                              constraints: BoxConstraints(
                                minHeight: inner.maxHeight,
                              ),
                              child: Center(
                                child: FadeTransition(
                                  opacity: CurvedAnimation(
                                    parent: _entrance,
                                    curve: const Interval(
                                      0,
                                      0.7,
                                      curve: Curves.easeOut,
                                    ),
                                  ),
                                  child: SlideTransition(
                                    position: Tween<Offset>(
                                      begin: const Offset(0, 0.03),
                                      end: Offset.zero,
                                    ).animate(
                                      CurvedAnimation(
                                        parent: _entrance,
                                        curve: Curves.easeOutCubic,
                                      ),
                                    ),
                                    child: isWide
                                        ? _wideLayout(game: game)
                                        : _narrowLayout(game: game),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  /// Layout compacto (móvil): tablero, estado y teclado apilados.
  ///
  /// Tablero y teclado comparten el mismo ancho para que queden alineados.
  Widget _narrowLayout({required GameProvider game}) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final double width = constraints.maxWidth > 520 ? 520 : constraints.maxWidth;
        return SizedBox(
          width: width,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const SizedBox(height: 8),
              _boardSection(game: game, fitWidth: true, width: width),
              const SizedBox(height: 12),
              _statusLine(game: game),
              const SizedBox(height: 16),
              _keyboardSection(game: game, width: width),
              const SizedBox(height: 12),
            ],
          ),
        );
      },
    );
  }

  /// Ancho compartido por el tablero y el teclado en layout ancho, para que
  /// ambos queden perfectamente alineados.
  static const double _wideGameWidth = 460;

  /// Layout ancho (web / tablet): tablero + teclado a la izquierda y panel
  /// de información a la derecha.
  Widget _wideLayout({required GameProvider game}) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 860),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const SizedBox(height: 8),
                SizedBox(
                  width: _wideGameWidth,
                  child: _boardSection(game: game, fitWidth: true),
                ),
                const SizedBox(height: 12),
                _statusLine(game: game),
                const SizedBox(height: 16),
                SizedBox(
                  width: _wideGameWidth,
                  child: _keyboardSection(
                    game: game,
                    width: _wideGameWidth,
                  ),
                ),
                const SizedBox(height: 12),
              ],
            ),
          ),
          const SizedBox(width: 28),
          SizedBox(
            width: 250,
            child: Padding(
              padding: const EdgeInsets.only(top: 20),
              child: _infoPanel(game: game),
            ),
          ),
        ],
      ),
    );
  }

  /// Tablero centrado con tamaño adaptativo.
  ///
  /// Con [fitWidth] la celda se calcula para ocupar exactamente el ancho
  /// disponible (el mismo que el teclado).
  Widget _boardSection({
    required GameProvider game,
    bool fitWidth = false,
    double? width,
  }) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        const spacing = 6.0;
        const maxCell = 62.0;
        final base = width ?? constraints.maxWidth;
        final available = base - spacing * 4;
        var cell = available / 5;
        if (!fitWidth && cell > maxCell) cell = maxCell;
        if (cell < 32) cell = 32;

        return Center(
          child: ShakeTransition(
            trigger: game.invalidAttemptCount,
            child: GridBoard(
              rows: game.board,
              cellSize: cell,
              spacing: spacing,
            ),
          ),
        );
      },
    );
  }

  /// Línea de estado bajo el tablero.
  Widget _statusLine({required GameProvider game}) {
    final theme = Theme.of(context);
    String text;
    IconData icon;
    Color color;

    if (game.isGameOver) {
      final won = game.isWin;
      text = won
          ? '¡La pegaste! La jerga era ${game.secretWord}'
          : 'La jerga era ${game.secretWord}';
      icon = won ? Icons.emoji_events : Icons.sentiment_dissatisfied;
      color = won ? AppTheme.correct : theme.subtle;
    } else if (game.attemptsRemaining <= 2) {
      text = '¡Últimos ${game.attemptsRemaining} intentos!';
      icon = Icons.warning_amber_rounded;
      color = theme.accent;
    } else {
      text = 'Adivina la jerga peruana de 5 letras';
      icon = Icons.lightbulb_outline;
      color = theme.subtle;
    }

    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: theme.tileEmpty,
          border: Border.all(color: theme.tileEmptyBorder),
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
    final theme = Theme.of(context);
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
            Text(
              '• Verde: letra en su posición.\n'
              '• Amarillo: letra presente, mal posición.\n'
              '• Gris: la letra no está.\n'
              '• 6 intentos por día.',
              style: TextStyle(fontSize: 12, color: theme.subtle, height: 1.6),
            ),
          ],
        ),
      ],
    );
  }

  /// Teclado virtual con soporte de teclado físico.
  Widget _keyboardSection({required GameProvider game, double? width}) {
    return Focus(
      autofocus: true,
      onKeyEvent: (FocusNode node, KeyEvent event) {
        if (event is! KeyDownEvent && event is! KeyRepeatEvent) {
          return KeyEventResult.ignored;
        }
        if (event.logicalKey == LogicalKeyboardKey.enter ||
            event.logicalKey == LogicalKeyboardKey.numpadEnter) {
          _haptic();
          game.submitGuess();
          return KeyEventResult.handled;
        }
        if (event.logicalKey == LogicalKeyboardKey.backspace) {
          _haptic();
          context.read<SoundService>().play(SoundEffect.key);
          game.backspace();
          return KeyEventResult.handled;
        }
        final letter = physicalKeyToLetter(event);
        if (letter != null) {
          _haptic();
          context.read<SoundService>().play(SoundEffect.key);
          game.addLetter(letter);
          return KeyEventResult.handled;
        }
        return KeyEventResult.ignored;
      },
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: width ?? 520,
          ),
          child: VirtualKeyboard(
            enabled: !game.isGameOver,
            keyStates: game.keyboardState,
            onLetter: (String letter) {
              _haptic();
              context.read<SoundService>().play(SoundEffect.key);
              game.addLetter(letter);
            },
            onSubmit: () {
              _haptic();
              game.submitGuess();
            },
            onBackspace: () {
              _haptic();
              context.read<SoundService>().play(SoundEffect.key);
              game.backspace();
            },
          ),
        ),
      ),
    );
  }

  /// Muestra un aviso cuando el intento enviado no tiene 5 letras.
  void _showInvalidAttemptHint() {
    final theme = Theme.of(context);
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: const Text('Necesito 5 letras para enviar la palabra'),
          duration: const Duration(milliseconds: 1600),
          behavior: SnackBarBehavior.floating,
          backgroundColor: theme.tileEmptyBorder,
        ),
      );
  }

  /// Reproduce el sonido de las letras de la última fila enviada.
  void _playGuessSound(GameProvider game) {
    if (game.guesses.isEmpty) return;
    final sound = context.read<SoundService>();
    final guess = game.guesses.last;

    sound.play(SoundEffect.submit);
    for (final result in guess.results) {
      // Pequeño retardo escalonado para que se oiga la secuencia.
      Future<void>.delayed(
        Duration(milliseconds: 90 * guess.results.indexOf(result)),
        () => sound.play(_effectFor(result)),
      );
    }
  }

  /// Efecto de sonido asociado a un resultado de letra.
  SoundEffect _effectFor(LetterResult result) {
    switch (result) {
      case LetterResult.correct:
        return SoundEffect.correct;
      case LetterResult.present:
        return SoundEffect.present;
      case LetterResult.absent:
        return SoundEffect.absent;
      case LetterResult.none:
        return SoundEffect.key;
    }
  }

  /// Reproduce el sonido de fin de partida.
  void _playEndSound(GameProvider game) {
    final sound = context.read<SoundService>();
    sound.play(game.isWin ? SoundEffect.win : SoundEffect.lose);
  }

  /// Feedback háptico respetando la preferencia del usuario.
  void _haptic() {
    if (context.read<SettingsProvider>().hapticsEnabled) {
      keyboardHaptic();
    }
  }

  /// Resumen de fin de partida en modo práctica (no toca estadísticas).
  Future<void> _showPracticeSummary(GameProvider game) async {
    await showDialog<void>(
      context: context,
      builder: (BuildContext ctx) => AlertDialog(
        title: Text(game.isWin ? '¡Practice ganada!' : 'Fin del practice'),
        content: Text(
          game.isWin
              ? 'Adivinaste ${game.secretWord}. Tu racha y estadísticas no '
                  'cambian en modo práctica.'
              : 'La jerga era ${game.secretWord}. Tu racha y estadísticas no '
                  'cambian en modo práctica.',
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cerrar'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              game.startPractice();
            },
            child: const Text('Seguir practicando'),
          ),
        ],
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
        guesses: game.guesses,
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
        if (mounted) setState(() {});
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
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: theme.surface,
        border: Border.all(color: theme.tileEmptyBorder),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.2,
              color: theme.accent,
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
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(label, style: TextStyle(fontSize: 13, color: theme.subtle)),
          Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }
}
