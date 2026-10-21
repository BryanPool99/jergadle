import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/theme/app_theme.dart';
import '../../models/game_guess.dart';

/// Teclado virtual QWERTY con la Ñ peruana.
///
/// Las teclas toman el color del mejor resultado obtenido con esa letra
/// (verde > amarillo > gris). Incluye las teclas especiales `ENTER` y
/// `BACKSPACE`.
class VirtualKeyboard extends StatelessWidget {
  const VirtualKeyboard({
    super.key,
    required this.onLetter,
    required this.onSubmit,
    required this.onBackspace,
    this.keyStates = const <String, LetterResult>{},
    this.enabled = true,
  });

  /// Fila 1 del teclado.
  static const List<String> row1 = <String>[
    'Q', 'W', 'E', 'R', 'T', 'Y', 'U', 'I', 'O', 'P',
  ];

  /// Fila 2 del teclado (incluye la Ñ).
  static const List<String> row2 = <String>[
    'A', 'S', 'D', 'F', 'G', 'H', 'J', 'K', 'L', 'Ñ',
  ];

  /// Fila 3 del teclado (deja espacio para ENTER y BACKSPACE).
  static const List<String> row3 = <String>[
    'Z', 'X', 'C', 'V', 'B', 'N', 'M',
  ];

  /// Callback al pulsar una letra.
  final ValueChanged<String> onLetter;

  /// Callback al pulsar ENTER.
  final VoidCallback onSubmit;

  /// Callback al pulsar BACKSPACE.
  final VoidCallback onBackspace;

  /// Estado de color por letra.
  final Map<String, LetterResult> keyStates;

  /// `false` deshabilita el teclado (partida terminada).
  final bool enabled;

  /// Color de fondo de una tecla según su estado.
  Color _keyColor(LetterResult result) {
    switch (result) {
      case LetterResult.correct:
        return AppTheme.correct;
      case LetterResult.present:
        return AppTheme.present;
      case LetterResult.absent:
        return AppTheme.absent;
      case LetterResult.none:
        return AppTheme.tileEmptyBorder;
    }
  }

  Widget _letterKey(String letter, double width, double height) {
    final result = keyStates[letter] ?? LetterResult.none;
    final isKnown = result != LetterResult.none;

    return Padding(
      padding: const EdgeInsets.all(3),
      child: SizedBox(
        width: width,
        height: height,
        child: Material(
          color: isKnown ? _keyColor(result) : AppTheme.tileEmptyBorder,
          borderRadius: BorderRadius.circular(4),
          child: InkWell(
            onTap: enabled ? () => onLetter(letter) : null,
            child: Center(
              child: Text(
                letter,
                key: ValueKey<String>('key-$letter'),
                style: TextStyle(
                  color: isKnown ? Colors.white : AppTheme.onBackground,
                  fontSize: (width * 0.55).clamp(15.0, 22.0),
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _actionKey({
    required IconData icon,
    required String label,
    required VoidCallback? onTap,
    required double width,
    required double height,
    Key? key,
  }) {
    return Padding(
      padding: const EdgeInsets.all(3),
      child: SizedBox(
        width: width,
        height: height,
        child: Material(
          color: AppTheme.tileEmptyBorder,
          borderRadius: BorderRadius.circular(4),
          child: InkWell(
            onTap: onTap,
            child: Center(
              child: icon == Icons.backspace
                  ? Icon(icon, color: AppTheme.onBackground, size: 20)
                  : Text(
                          label,
                          key: key,
                          style: const TextStyle(
                            color: AppTheme.onBackground,
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Ancho de tecla proporcional al ancho disponible (10 teclas por fila).
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        // Cada tecla tiene 3px de padding a cada lado, por lo que el ancho
        // total de la fila es 10 * (w + 6). Se descuenta para que el teclado
        // ocupe exactamente el ancho disponible (alineado con el tablero).
        final double w = (constraints.maxWidth / 10 - 6).clamp(18.0, 46.0);
        final double height = (w * 1.45).clamp(36.0, 60.0);

        return Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            // Fila 1
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                for (final letter in row1) _letterKey(letter, w, height),
              ],
            ),
            // Fila 2
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                for (final letter in row2) _letterKey(letter, w, height),
              ],
            ),
            // Fila 3: ENTER + Z..M + BACKSPACE
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                _actionKey(
                  icon: Icons.keyboard_return,
                  label: 'ENTER',
                  key: const ValueKey<String>('key-ENTER'),
                  onTap: enabled ? onSubmit : null,
                  width: w * 1.5,
                  height: height,
                ),
                for (final letter in row3) _letterKey(letter, w, height),
                _actionKey(
                  icon: Icons.backspace,
                  label: '',
                  key: const ValueKey<String>('key-BACKSPACE'),
                  onTap: enabled ? onBackspace : null,
                  width: w * 1.5,
                  height: height,
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}

/// Envuelve una pulsación de tecla del sistema con feedback háptico.
void keyboardHaptic() {
  HapticFeedback.selectionClick();
}

/// Devuelve la letra presionada en el teclado físico (o `null`).
String? physicalKeyToLetter(KeyEvent event) {
  if (event is! KeyDownEvent && event is! KeyRepeatEvent) return null;
  final key = event.logicalKey;
  final char = key.keyLabel.toUpperCase();
  if (char.length == 1 && 'ABCDEFGHIJKLMNÑOPQRSTUVWXYZ'.contains(char)) {
    return char;
  }
  return null;
}
