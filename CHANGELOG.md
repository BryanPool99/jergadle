# Changelog

Todas las novedades de Jergadle se documentan en este archivo.

El formato sigue [Keep a Changelog](https://keepachangelog.com/es-ES/1.1.0/) y
el proyecto se adhiere a [Semantic Versioning](https://semver.org/lang/es/).

## [No publicado]

## [0.2.0] - 2026-10-21

### Anadido

- Pantalla de inicio con el logo, las reglas, el estado de la racha y un fondo
  animado con jergas flotantes.
- Tema claro y oscuro conmutable desde la barra superior o desde la hoja de
  ajustes; la preferencia se guarda en el dispositivo.
- Hoja de ajustes con switches para tema, sonido, feedback haptico y consejos.
- Efectos de sonido generados para Jergadle (tecla, envio, letra correcta,
  letra presente, letra ausente, victoria y derrota) con `audioplayers`.
- Compartir con emojis al estilo Wordle: el resultado se copia como un cuadro
  de cuadritos de color.
- Animacion de giro 3D en las fichas al revelarse, con efecto en cascada por
  letra.
- Sacudida del tablero y aviso visual cuando se envia un intento incompleto.
- Retroalimentacion visual al pulsar las teclas del teclado virtual.
- Entrada animada de la pantalla de juego y transicion suave al navegar.
- El teclado fisico funciona desde la pantalla de inicio: al escribir una
  letra se entra directo al juego.
- Las animaciones respetan la preferencia de accesibilidad "reducir movimiento".
- 51 tests: evaluador, palabras, estadisticas, proveedor, tema, emojis,
  layout responsive y flujo completo de UI.

### Corregido

- Las estadisticas solo se contaban al terminar la partida, no en cada intento.
- El modo practica ya no sobrescribe la partida guardada del dia.
- El tablero se desbordaba a 320 px de ancho.

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
- Estructura de proyecto con GitFlow documentado en `CONTRIBUTING.md`.
