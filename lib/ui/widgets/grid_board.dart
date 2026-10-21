import 'package:flutter/material.dart';

import '../../models/game_guess.dart';
import 'letter_tile.dart';

/// Tablero de 6 filas x 5 columnas.
///
/// Recibe el estado ya calculado por el proveedor (o el teclado físico) y lo
/// dibuja usando [LetterTile].
class GridBoard extends StatelessWidget {
  const GridBoard({
    super.key,
    required this.rows,
    this.cellSize = 56,
    this.spacing = 6,
  });

  /// Filas del tablero. Cada fila es una lista de 5 celdas
  /// `(letra, estado)`. Las filas pueden tener menos elementos si la partida
  /// está en curso.
  final List<List<({String letter, LetterResult result})>> rows;

  /// Lado de cada celda.
  final double cellSize;

  /// Separación entre celdas.
  final double spacing;

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
                    ),
                  ),
              ],
            ),
          ),
      ],
    );
  }
}
