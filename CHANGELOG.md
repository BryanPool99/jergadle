# Changelog

Todas las novedades de Jergadle se documentan en este archivo.

El formato sigue [Keep a Changelog](https://keepachangelog.com/es-ES/1.1.0/) y
el proyecto se adhiere a [Semantic Versioning](https://semver.org/lang/es/).

## [No publicado]

## [0.1.0] - 2026-10-21

### Anadido

- Juego tipo Wordle con jergas peruanas de 5 letras (67 entradas locales).
- Algoritmo de palabra del dia determinista: `indice = dias % total de palabras`,
  sin backend, la misma palabra para todos.
- Evaluacion de letras en dos pasadas para manejar correctamente letras
  repetidas (verdes primero, luego amarillos).
- Teclado virtual QWERTY con N con tilde, ENTER y BACKSPACE, con prioridad de
  color verde > amarillo > gris.
- Soporte de teclado fisico en web y Android.
- Sistema de rachas: racha actual, mejor racha, partidas jugadas, victorias y
  porcentaje de aciertos.
- Persistencia local con `shared_preferences`: la partida del dia se restaura
  al reabrir la app.
- Modal final con estadisticas, distribucion de intentos y el significado
  peruano de la jerga del dia.
- Modo practica opcional tras terminar la partida (no altera rachas).
- Layout responsive: compacto en movil, con panel lateral en web/tablet.
- 43 tests: evaluador, servicio de palabras, estadisticas, proveedor, layout
  responsive y flujo completo de UI.
- Estructura de proyecto con GitFlow documentado en `CONTRIBUTING.md`.
