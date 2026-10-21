import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// Utilidades compartidas por los tests de UI.
///
/// La app arranca en la pantalla de inicio, así que los tests que necesitan
/// el juego pulsan el botón "JUGAR" antes de interactuar con el tablero.
extension JergadleTestHelpers on WidgetTester {
  /// Activa la preferencia de accesibilidad "reducir movimiento".
  ///
  /// Las animaciones continuas (fondo flotante, botón pulsante) se detienen,
  /// de modo que [pumpAndSettle] puede converger.
  void enableReducedMotion() {
    platformDispatcher.accessibilityFeaturesTestValue =
        const FakeAccessibilityFeatures(disableAnimations: true);
    addTearDown(platformDispatcher.clearAccessibilityFeaturesTestValue);
  }

  /// Navega desde la pantalla de inicio hasta la pantalla de juego.
  Future<void> goToGame() async {
    await settle();
    final playButton = find.text('JUGAR');
    if (playButton.evaluate().isNotEmpty) {
      // El botón puede estar fuera de pantalla en pantallas pequeñas.
      await ensureVisible(playButton.first);
      await pumpAndSettle();
      await tap(playButton.first);
    }
    await settle();
  }

  /// Escribe una palabra pulsando las teclas del teclado virtual.
  Future<void> typeWord(String word) async {
    for (final letter in word.split('')) {
      await tap(find.byKey(ValueKey<String>('key-$letter')));
      await pump();
    }
  }

  /// Pulsa ENTER y espera a que se estabilice la pantalla.
  Future<void> pressEnter() async {
    await tap(find.byKey(const ValueKey<String>('key-ENTER')));
    await settle();
  }

  /// Espera a que la pantalla se estabilice.
  ///
  /// Usa [pumpAndSettle] con un límite de tiempo generoso porque las
  /// animaciones de la app son continuas.
  Future<void> settle() async {
    await pumpAndSettle(
      const Duration(milliseconds: 100),
      EnginePhase.sendSemanticsUpdate,
      const Duration(seconds: 10),
    );
  }

  /// Configura el tamaño de la pantalla de prueba.
  void setScreenSize(Size size) {
    view.physicalSize = size;
    view.devicePixelRatio = 1.0;
    addTearDown(view.reset);
  }
}
