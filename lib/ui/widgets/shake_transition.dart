import 'dart:math' as math;

import 'package:flutter/material.dart';

/// Envuelve a su hijo y lo sacude horizontalmente cuando cambia [trigger].
///
/// Se usa para avisar al jugador de que el intento enviado no era válido.
class ShakeTransition extends StatefulWidget {
  const ShakeTransition({
    super.key,
    required this.trigger,
    required this.child,
  });

  /// Valor que, al cambiar, dispara la sacudida.
  final int trigger;

  /// Contenido envuelto.
  final Widget child;

  @override
  State<ShakeTransition> createState() => _ShakeTransitionState();
}

class _ShakeTransitionState extends State<ShakeTransition>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 420),
  );

  late final Animation<double> _progress = CurvedAnimation(
    parent: _controller,
    curve: Curves.easeOut,
  );

  @override
  void didUpdateWidget(covariant ShakeTransition oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.trigger != widget.trigger) {
      _controller.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (MediaQuery.disableAnimationsOf(context)) return widget.child;

    return AnimatedBuilder(
      animation: _progress,
      builder: (BuildContext context, Widget? child) {
        final t = _progress.value;
        // Onda amortiguada: 3 ciclos que se apagan.
        final dx = 12 * (1 - t) * math.sin(3 * 2 * math.pi * t);
        return Transform.translate(
          offset: Offset(dx, 0),
          child: child,
        );
      },
      child: widget.child,
    );
  }
}
