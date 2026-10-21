import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:jergadle/app.dart';
import 'package:jergadle/models/game_guess.dart';
import 'package:jergadle/providers/game_provider.dart';
import 'package:jergadle/ui/screens/game_screen.dart';
import 'package:jergadle/ui/widgets/grid_board.dart';
import 'package:jergadle/ui/widgets/letter_tile.dart';

import 'helpers/test_helpers.dart';

/// Comprueba que la fila activa del tablero muestra las letras que se
/// están escribiendo (y no casillas vacías).
void main() {
  /// Devuelve la lista de letras que se ven en cada fila del tablero.
  List<List<String>> visibleLetters(WidgetTester tester) {
    final board = tester.widget<GridBoard>(find.byType(GridBoard));
    return board.rows
        .map((row) => row.map((cell) => cell.letter).toList())
        .toList();
  }

  testWidgets('la fila activa muestra las letras escritas',
      (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues(<String, Object>{});
    tester.setScreenSize(const Size(1280, 900));
    tester.enableReducedMotion();

    await tester.pumpWidget(const JergadleApp());
    await tester.goToGame();

    // Todavía no se ha escrito nada: la fila activa está vacía.
    expect(visibleLetters(tester)[0], <String>['', '', '', '', '']);

    await tester.typeWord('PL');
    await tester.pump();

    expect(visibleLetters(tester)[0], <String>['P', 'L', '', '', '']);

    await tester.typeWord('ATA');
    await tester.pump();

    expect(visibleLetters(tester)[0], <String>['P', 'L', 'A', 'T', 'A']);
  });

  testWidgets('la letra escrita se ve en el cuadro del tablero',
      (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues(<String, Object>{});
    tester.setScreenSize(const Size(1280, 900));
    tester.enableReducedMotion();

    await tester.pumpWidget(const JergadleApp());
    await tester.goToGame();

    await tester.typeWord('CHA');
    await tester.pump();

    // La ficha de la primera celda debe contener la letra "C".
    final tiles = tester.widgetList<LetterTile>(find.byType(LetterTile)).toList();
    expect(tiles.first.letter, 'C');
    expect(tiles[0].result, LetterResult.none);
  });

  testWidgets('al enviar, la fila pasa a mostrar los colores',
      (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues(<String, Object>{});
    tester.setScreenSize(const Size(1280, 900));
    tester.enableReducedMotion();

    await tester.pumpWidget(const JergadleApp());
    await tester.goToGame();

    final game = Provider.of<GameProvider>(
      tester.element(find.byType(GameScreen)),
      listen: false,
    );

    await tester.typeWord(game.secretWord);
    await tester.pressEnter();

    // La primera fila ya no está vacía y la segunda vuelve a estarlo.
    final rows = visibleLetters(tester);
    expect(rows[0], game.secretWord.split(''));
    expect(rows[1], <String>['', '', '', '', '']);
  });

  testWidgets('al borrar, la letra desaparece del cuadro',
      (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues(<String, Object>{});
    tester.setScreenSize(const Size(1280, 900));
    tester.enableReducedMotion();

    await tester.pumpWidget(const JergadleApp());
    await tester.goToGame();

    await tester.typeWord('PL');
    await tester.pump();
    expect(visibleLetters(tester)[0], <String>['P', 'L', '', '', '']);

    await tester.tap(find.byKey(const ValueKey<String>('key-BACKSPACE')));
    await tester.pump();

    expect(visibleLetters(tester)[0], <String>['P', '', '', '', '']);
  });
}
