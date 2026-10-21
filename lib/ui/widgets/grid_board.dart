import 'package:flutter/material.dart';

import '../../models/game_guess.dart';
import 'letter_tile.dart';

/// Tablero de 6 filas x 5 columnas.
///
/// Recibe el estado ya calculado por el proveedor y lo dibuja usando
/// [LetterTile]. Las fichas de una fila se revelan en cascada (cada letra
/// gira ligeramente después de la anterior).
class GridBoard extends StatelessWidget {
  const GridBoard({
    super.key,
    required this.rows,
    this.cellSize = 56,
    this.spacing = 6,
    this.cascade = true,
  });

  /// Filas del tablero. Cada fila es una lista de 5 celdas
  /// `(letra, estado)`.
  final List<List<({String letter, LetterResult result})>> rows;

  /// Lado de cada celda.
  final double cellSize;

  /// Separación entre celdas.
  final double spacing;

  /// `true` para revelar las letras en cascada.
  final bool cascade;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        for (var rowIndex = 0; rowIndex < rows.length; rowIndex++)
          Padding(
            padding: EdgeInsets.only(bottom: rowIndex == rows.length - 1 ? 0 : spacing),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                for (var colIndex = 0; colIndex < rows[rowIndex].length; colIndex++)
                  Padding(
                    padding: EdgeInsets.only(
                      right: colIndex == rows[rowIndex].length - 1 ? 0 : spacing,
                    ),
                    child: LetterTile(
                      letter: rows[rowIndex][colIndex].letter,
                      result: rows[rowIndex][colIndex].result,
                      size: cellSize,
                      revealDelay: cascade
                          ? Duration(milliseconds: 70 * colIndex)
                          : Duration.zero,
                    ),
                  ),
              ],
            ),
          ),
      ],
    );
  }
}
