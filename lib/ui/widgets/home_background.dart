import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';

/// Fondo decorativo de la pantalla de inicio.
///
/// Muestra jergas peruano flotando lentamente con opacidad baja, para dar
/// vida a la pantalla sin distraer del contenido.
class HomeBackground extends StatefulWidget {
  const HomeBackground({super.key, this.words});

  /// Jergas a mostrar. Si es `null` se usa una lista por defecto.
  final List<String>? words;

  @override
  State<HomeBackground> createState() => _HomeBackgroundState();
}

class _HomeBackgroundState extends State<HomeBackground>
    with SingleTickerProviderStateMixin {
  static const List<String> _defaultWords = <String>[
    'CHAMBA',
    'MONSE',
    'PLATA',
    'QUEBE',
    'TAQUE',
    'FIRME',
    'GUARO',
    'JATO',
    'CHULA',
    'PISCO',
  ];

  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 24),
  );

  late final List<String> _words = widget.words ?? _defaultWords;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Respeta la preferencia de accesibilidad "reducir movimiento": si está
    // activa, el fondo se queda estático en una posición fija.
    if (MediaQuery.disableAnimationsOf(context)) {
      _controller.value = 0.3;
      _controller.stop();
    } else if (!_controller.isAnimating) {
      _controller.repeat();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // Respeta la preferencia de accesibilidad "reducir movimiento".
    final reduceMotion = MediaQuery.disableAnimationsOf(context);
    return IgnorePointer(
      child: RepaintBoundary(
        child: AnimatedBuilder(
          animation: _controller,
          builder: (BuildContext context, _) {
            return CustomPaint(
              painter: _FloatingWordsPainter(
                progress: reduceMotion ? 0.3 : _controller.value,
                words: _words,
                color: theme.subtle.withValues(alpha: 0.10),
                accent: theme.accent.withValues(alpha: 0.08),
              ),
              size: Size.infinite,
            );
          },
        ),
      ),
    );
  }
}

/// Pinta las jergas flotando en diagonal.
class _FloatingWordsPainter extends CustomPainter {
  _FloatingWordsPainter({
    required this.progress,
    required this.words,
    required this.color,
    required this.accent,
  });

  final double progress;
  final List<String> words;
  final Color color;
  final Color accent;

  @override
  void paint(Canvas canvas, Size size) {
    if (words.isEmpty || size.isEmpty) return;

    final painter = TextPainter(textDirection: TextDirection.ltr);
    final random = math.Random(7);

    for (var i = 0; i < words.length; i++) {
      painter.text = TextSpan(
        text: words[i],
        style: TextStyle(
          fontSize: 26 + random.nextDouble() * 26,
          fontWeight: FontWeight.w800,
          letterSpacing: 3,
          color: i.isEven ? color : accent,
        ),
      );
      painter.layout();

      // Cada palabra recorre una diagonal con un desfase propio.
      final seed = random.nextDouble();
      final phase = (progress + seed) % 1.0;
      final x = -60 + phase * (size.width + 120) - painter.width / 2;
      final y = size.height * (0.08 + random.nextDouble() * 0.82) +
          math.sin((phase + seed) * math.pi * 2) * 22;

      painter.paint(canvas, Offset(x, y));
    }
  }

  @override
  bool shouldRepaint(covariant _FloatingWordsPainter oldDelegate) =>
      oldDelegate.progress != progress;
}
