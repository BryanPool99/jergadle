import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';
import '../../models/game_guess.dart';

/// Ficha individual del tablero.
///
/// Muestra la letra con el color correspondiente al estado de evaluación:
/// verde (correcta), amarillo (presente) o gris (ausente). Las fichas vacías
/// se dibujan con borde.
///
/// Cuando la ficha se evalúa hace un **giro 3D** (como en el Wordle clásico):
/// primero se ve la cara vacía, y al pasar la mitad del giro aparece la letra
/// sobre su color definitivo.
class LetterTile extends StatefulWidget {
  const LetterTile({
    super.key,
    required this.letter,
    this.result = LetterResult.none,
    this.size = 56,
    this.revealDelay = Duration.zero,
  });

  /// Letra a mostrar (vacía si la celda está libre).
  final String letter;

  /// Estado de evaluación de la letra.
  final LetterResult result;

  /// Lado del cuadrado (en píxeles lógicos).
  final double size;

  /// Retardo antes de iniciar el giro (para el efecto en cascada).
  final Duration revealDelay;

  @override
  State<LetterTile> createState() => _LetterTileState();
}

class _LetterTileState extends State<LetterTile>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 520),
  );

  late final Animation<double> _flip = CurvedAnimation(
    parent: _controller,
    curve: Curves.easeInCubic,
  ).drive(
    Tween<double>(begin: 0, end: math.pi).chain(CurveTween(curve: Curves.linear)),
  );

  @override
  void initState() {
    super.initState();
    if (widget.result != LetterResult.none) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _reveal());
    }
  }

  @override
  void didUpdateWidget(covariant LetterTile oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.result != widget.result &&
        widget.result != LetterResult.none) {
      _reveal();
    }
  }

  /// Gira la ficha: la cara vacía da la vuelta y muestra el color y la letra.
  Future<void> _reveal() async {
    if (widget.revealDelay > Duration.zero) {
      await Future<void>.delayed(widget.revealDelay);
      if (!mounted) return;
    }
    await _controller.forward(from: 0);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Color get _backgroundColor {
    switch (widget.result) {
      case LetterResult.correct:
        return AppTheme.correct;
      case LetterResult.present:
        return AppTheme.present;
      case LetterResult.absent:
        return AppTheme.absent;
      case LetterResult.none:
        return Theme.of(context).tileEmpty;
    }
  }

  Color get _borderColor {
    final theme = Theme.of(context);
    return widget.result == LetterResult.none
        ? theme.tileEmptyBorder
        : _backgroundColor;
  }

  /// Cara "frontal": casilla vacía con borde.
  Widget _buildFront() {
    return Container(
      width: widget.size,
      height: widget.size,
      decoration: BoxDecoration(
        color: Theme.of(context).tileEmpty,
        border: Border.all(color: Theme.of(context).tileEmptyBorder, width: 2),
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }

  /// Cara "trasera": letra sobre su color de evaluación.
  Widget _buildBack() {
    return Container(
      width: widget.size,
      height: widget.size,
      decoration: BoxDecoration(
        color: _backgroundColor,
        border: Border.all(color: _borderColor, width: 2),
        borderRadius: BorderRadius.circular(4),
      ),
      alignment: Alignment.center,
      child: Text(
        widget.letter,
        style: TextStyle(
          color: Colors.white,
          fontSize: widget.size * 0.46,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final reduceMotion = MediaQuery.disableAnimationsOf(context);
    final hasLetter = widget.letter.isNotEmpty;

    return AnimatedBuilder(
      animation: _controller,
      builder: (BuildContext context, Widget? child) {
        final angle = reduceMotion ? math.pi : _flip.value;
        // Por debajo de 90 grados se ve la cara vacía; por encima, la de color.
        final showingBack = angle >= math.pi / 2;

        final face = showingBack && hasLetter ? _buildBack() : _buildFront();

        return Transform(
          alignment: Alignment.center,
          transform: Matrix4.identity()
            ..setEntry(3, 2, 0.0012)
            ..rotateY(angle),
          child: showingBack
              // Compensa el espejado que produce el giro.
              ? Transform(
                  alignment: Alignment.center,
                  transform: Matrix4.identity()..rotateY(math.pi),
                  child: face,
                )
              : face,
        );
      },
    );
  }
}
