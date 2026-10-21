import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';
import '../../models/game_guess.dart';

/// Ficha individual del tablero.
///
/// Muestra la letra con el color correspondiente al estado de evaluación:
/// verde (correcta), amarillo (presente) o gris (ausente). Las fichas vacías
/// se dibujan con borde.
class LetterTile extends StatefulWidget {
  const LetterTile({
    super.key,
    required this.letter,
    this.result = LetterResult.none,
    this.isActive = false,
    this.size = 56,
  });

  /// Letra a mostrar (vacía si la celda está libre).
  final String letter;

  /// Estado de evaluación de la letra.
  final LetterResult result;

  /// `true` si la celda corresponde a la fila en curso.
  final bool isActive;

  /// Lado del cuadrado (en píxeles lógicos).
  final double size;

  @override
  State<LetterTile> createState() => _LetterTileState();
}

class _LetterTileState extends State<LetterTile> with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 450),
  );

  late final Animation<double> _scale = Tween<double>(begin: 0.6, end: 1.0).animate(
    CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
  );

  @override
  void initState() {
    super.initState();
    if (widget.result != LetterResult.none) _controller.forward();
  }

  @override
  void didUpdateWidget(covariant LetterTile oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.result != widget.result &&
        widget.result != LetterResult.none) {
      _controller.forward(from: 0);
    }
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
        return AppTheme.tileEmpty;
    }
  }

  Color get _borderColor =>
      widget.result == LetterResult.none ? AppTheme.tileEmptyBorder : _backgroundColor;

  @override
  Widget build(BuildContext context) {
    final hasLetter = widget.letter.isNotEmpty;

    return ScaleTransition(
      scale: _scale,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        width: widget.size,
        height: widget.size,
        decoration: BoxDecoration(
          color: _backgroundColor,
          border: Border.all(color: _borderColor, width: 2),
          borderRadius: BorderRadius.circular(4),
        ),
        alignment: Alignment.center,
        child: hasLetter
            ? Text(
                widget.letter,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 26,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0,
                ),
              )
            : null,
      ),
    );
  }
}
