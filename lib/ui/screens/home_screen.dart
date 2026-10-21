import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../core/theme/app_theme.dart';
import '../../providers/game_provider.dart';
import '../../providers/settings_provider.dart';
import '../widgets/home_background.dart';
import '../widgets/settings_sheet.dart';
import '../widgets/virtual_keyboard.dart';
import 'game_screen.dart';

/// Pantalla de inicio.
///
/// Muestra la identidad de Jergadle, las reglas, el estado de la racha y el
/// acceso al juego. Es el punto de entrada tras abrir la app.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  late final AnimationController _intro = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 900),
  );

  @override
  void initState() {
    super.initState();
    _intro.forward();
  }

  @override
  void dispose() {
    _intro.dispose();
    super.dispose();
  }

  /// Curva de entrada con retardo por elemento (efecto escalonado).
  Animation<double> _stagger(int index) {
    final start = (index * 0.09).clamp(0.0, 0.55);
    final end = (start + 0.45).clamp(0.0, 1.0);
    return CurvedAnimation(
      parent: _intro,
      curve: Interval(start, end, curve: Curves.easeOutCubic),
    );
  }

  @override
  Widget build(BuildContext context) {
    final game = context.watch<GameProvider>();
    final settings = context.watch<SettingsProvider>();
    final theme = Theme.of(context);

    return Scaffold(
      body: Stack(
        children: <Widget>[
          // Fondo animado con jergas flotantes.
          const HomeBackground(),
          // Captura el teclado físico: al escribir una letra se entra
          // directo al juego.
          Focus(
            autofocus: true,
            onKeyEvent: (FocusNode node, KeyEvent event) {
              if (event is! KeyDownEvent && event is! KeyRepeatEvent) {
                return KeyEventResult.ignored;
              }
              if (event.logicalKey == LogicalKeyboardKey.enter ||
                  event.logicalKey == LogicalKeyboardKey.numpadEnter) {
                _openGame(context);
                return KeyEventResult.handled;
              }
              final letter = physicalKeyToLetter(event);
              if (letter != null) {
                _openGame(context, initialLetter: letter);
                return KeyEventResult.handled;
              }
              return KeyEventResult.ignored;
            },
            child: const SizedBox.expand(),
          ),
          SafeArea(
            child: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                return SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 560),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          _topBar(settings: settings),
                          const SizedBox(height: 18),
                          _logo(theme: theme),
                          const SizedBox(height: 8),
                          FadeTransition(
                            opacity: _stagger(1),
                            child: SlideTransition(
                              position: Tween<Offset>(
                                begin: const Offset(0, 0.25),
                                end: Offset.zero,
                              ).animate(_stagger(1)),
                              child: Text(
                                'La jerga peruana de 5 letras',
                                textAlign: TextAlign.center,
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: theme.subtle,
                                  letterSpacing: 1.2,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 22),
                          FadeTransition(
                            opacity: _stagger(2),
                            child: _streakCard(game: game),
                          ),
                          const SizedBox(height: 14),
                          FadeTransition(
                            opacity: _stagger(3),
                            child: _rulesCard(
                              theme: theme,
                              showHints: settings.settings.showKeyboardHints,
                            ),
                          ),
                          const SizedBox(height: 22),
                          FadeTransition(
                            opacity: _stagger(4),
                            child: _playButton(
                              game: game,
                              onPressed: () => _openGame(context),
                            ),
                          ),
                          const SizedBox(height: 10),
                          FadeTransition(
                            opacity: _stagger(5),
                            child: _statsLink(
                              context: context,
                              game: game,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  /// Barra superior con el logo pequeño y los ajustes.
  Widget _topBar({required SettingsProvider settings}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(
          'JERGADLE',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w800,
            letterSpacing: 3,
            color: Theme.of(context).accent,
          ),
        ),
        Row(
          children: <Widget>[
            IconButton(
              tooltip: 'Tema claro / oscuro',
              onPressed: settings.toggleTheme,
              icon: Icon(
                settings.settings.themeMode == ThemeMode.light
                    ? Icons.dark_mode_outlined
                    : Icons.light_mode_outlined,
                color: Theme.of(context).onBackground,
              ),
            ),
            IconButton(
              tooltip: 'Ajustes',
              onPressed: () => showSettingsSheet(context),
              icon: Icon(
                Icons.tune,
                color: Theme.of(context).onBackground,
              ),
            ),
          ],
        ),
      ],
    );
  }

  /// Logo principal con entrada animada.
  Widget _logo({required ThemeData theme}) {
    return FadeTransition(
      opacity: _intro,
      child: ScaleTransition(
        scale: Tween<double>(begin: 0.86, end: 1.0).animate(
          CurvedAnimation(parent: _intro, curve: Curves.easeOutBack),
        ),
        child: Column(
          children: <Widget>[
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: theme.accent, width: 2),
              ),
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  'JERGADLE',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 6,
                    color: theme.accent,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Jerga del día #${gameDayNumber(context)}',
              style: theme.textTheme.bodySmall?.copyWith(color: theme.subtle),
            ),
          ],
        ),
      ),
    );
  }

  /// Tarjeta con la racha actual y el mejor récord.
  Widget _streakCard({required GameProvider game}) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      decoration: BoxDecoration(
        color: theme.surface,
        borderRadius: BorderRadius.circular(AppTheme.radius),
        border: Border.all(color: theme.tileEmptyBorder),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Flexible(
            child: _miniStat(
              icon: Icons.local_fire_department,
              iconColor: theme.accent,
              value: '${game.currentStreak}',
              label: 'Racha actual',
            ),
          ),
          Container(width: 1, height: 38, color: theme.tileEmptyBorder),
          Flexible(
            child: _miniStat(
              icon: Icons.emoji_events_outlined,
              iconColor: theme.subtle,
              value: '${game.maxStreak}',
              label: 'Mejor racha',
            ),
          ),
          Container(width: 1, height: 38, color: theme.tileEmptyBorder),
          Flexible(
            child: _miniStat(
              icon: Icons.percent,
              iconColor: theme.subtle,
              value: '${game.winRate.toStringAsFixed(0)}%',
              label: 'Aciertos',
            ),
          ),
        ],
      ),
    );
  }

  /// Métrica corta dentro de la tarjeta de racha.
  Widget _miniStat({
    required IconData icon,
    required Color iconColor,
    required String value,
    required String label,
  }) {
    final theme = Theme.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        FittedBox(
          fit: BoxFit.scaleDown,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Icon(icon, size: 16, color: iconColor),
              const SizedBox(width: 5),
              Text(
                value,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
              ),
            ],
          ),
        ),
        const SizedBox(height: 2),
        FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            label,
            style: TextStyle(fontSize: 11, color: theme.subtle),
          ),
        ),
      ],
    );
  }

  /// Tarjeta con las reglas del juego.
  Widget _rulesCard({required ThemeData theme, required bool showHints}) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: theme.surface,
        borderRadius: BorderRadius.circular(AppTheme.radius),
        border: Border.all(color: theme.tileEmptyBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Icon(Icons.help_outline, size: 18, color: theme.accent),
              const SizedBox(width: 8),
              Text(
                'CÓMO JUGAR',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.4,
                  color: theme.accent,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: <Widget>[
              _legendTile(theme: theme, color: AppTheme.correct, label: 'Verde'),
              _legendTile(theme: theme, color: AppTheme.present, label: 'Amarillo'),
              _legendTile(theme: theme, color: AppTheme.absent, label: 'Gris'),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            '• Verde: la letra está en su posición.\n'
            '• Amarillo: la letra está, pero en otro lado.\n'
            '• Gris: la letra no está en la jerga.\n'
            '• 6 intentos por día, la misma jerga para todos.\n'
            '• Al terminar te cuento qué significa en el Perú.',
            style: TextStyle(fontSize: 13, height: 1.65, color: theme.subtle),
          ),
          if (showHints) ...<Widget>[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: theme.tileEmpty,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                '💡 El teclado virtual y el teclado físico funcionan igual. '
                'La Ñ también cuenta como letra.',
                style: TextStyle(fontSize: 12, height: 1.5, color: theme.subtle),
              ),
            ),
          ],
        ],
      ),
    );
  }

  /// Muestra cuadrada de la leyenda de colores.
  Widget _legendTile({
    required ThemeData theme,
    required Color color,
    required String label,
  }) {
    return Expanded(
      child: Column(
        children: <Widget>[
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: TextStyle(fontSize: 11, color: theme.subtle),
          ),
        ],
      ),
    );
  }

  /// Botón principal de juego, con pulso continuo.
  Widget _playButton({
    required GameProvider game,
    required VoidCallback onPressed,
  }) {
    final theme = Theme.of(context);
    return _PulseButton(
      onPressed: onPressed,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 18),
        decoration: BoxDecoration(
          color: theme.accent,
          borderRadius: BorderRadius.circular(AppTheme.radius),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(Icons.play_arrow_rounded, color: theme.brightness == Brightness.dark ? Colors.black : Colors.white),
            const SizedBox(width: 10),
            Text(
              game.hasPlayedToday ? 'SEGUIR JUGANDO' : 'JUGAR',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w800,
                letterSpacing: 1.5,
                color: theme.brightness == Brightness.dark ? Colors.black : Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Enlace a las estadísticas completas.
  Widget _statsLink({required BuildContext context, required GameProvider game}) {
    final theme = Theme.of(context);
    return TextButton.icon(
      onPressed: () => _openGame(context),
      icon: Icon(Icons.bar_chart, size: 18, color: theme.accent),
      label: Text(
        'Ver estadísticas',
        style: TextStyle(color: theme.accent, fontWeight: FontWeight.w600),
      ),
    );
  }

  /// Abre la pantalla de juego con una transición animada.
  ///
  /// Si [initialLetter] no es `null`, esa letra se escribe automáticamente
  /// al entrar (para poder empezar a jugar sin tocar el ratón).
  Future<void> _openGame(BuildContext context, {String? initialLetter}) async {
    await Navigator.of(context).push(
      PageRouteBuilder<void>(
        transitionDuration: const Duration(milliseconds: 420),
        reverseTransitionDuration: const Duration(milliseconds: 320),
        pageBuilder: (_, _, _) => GameScreen(initialLetter: initialLetter),
        transitionsBuilder: (
          BuildContext context,
          Animation<double> animation,
          Animation<double> secondary,
          Widget child,
        ) {
          final curved = CurvedAnimation(
            parent: animation,
            curve: Curves.easeOutCubic,
            reverseCurve: Curves.easeInCubic,
          );
          return FadeTransition(
            opacity: curved,
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0, 0.06),
                end: Offset.zero,
              ).animate(curved),
              child: child,
            ),
          );
        },
      ),
    );
  }

  /// Número de día del challenge (1-indexado).
  int gameDayNumber(BuildContext context) {
    final game = context.read<GameProvider>();
    return game.wordService.daysSinceEpoch(DateTime.now()) + 1;
  }
}

/// Botón con un pulso continuo suave para llamar la atención.
class _PulseButton extends StatefulWidget {
  const _PulseButton({required this.onPressed, required this.child});

  final VoidCallback onPressed;
  final Widget child;

  @override
  State<_PulseButton> createState() => _PulseButtonState();
}

class _PulseButtonState extends State<_PulseButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulse = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1600),
  );

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Con "reducir movimiento" activo el botón deja de pulsar.
    if (MediaQuery.disableAnimationsOf(context)) {
      _pulse.stop();
      _pulse.value = 0;
    } else if (!_pulse.isAnimating) {
      _pulse.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _pulse.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onPressed,
      child: AnimatedBuilder(
        animation: _pulse,
        builder: (BuildContext context, Widget? child) {
          final t = Curves.easeInOut.transform(_pulse.value);
          return Transform.scale(
            scale: 1 + (t * 0.022),
            child: child,
          );
        },
        child: widget.child,
      ),
    );
  }
}
