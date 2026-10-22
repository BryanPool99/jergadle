# Changelog

Todas las novedades de Jergadle se documentan en este archivo.

El formato sigue [Keep a Changelog](https://keepachangelog.com/es-ES/1.1.0/) y
el proyecto se adhiere a [Semantic Versioning](https://semver.org/lang/es/).

## [No publicado]

### Anadido

- Identidad visual completa: favicon propio (el tablero 2x2 del juego), iconos
  PWA y adaptativos de Android, lanzador de Android en sus 5 densidades, logo
  para el README e imagen de vista previa (og-image) para compartir el enlace.
- `scripts/generate_icons.py` regenera todos los iconos de forma reproducible.
- Meta tags de Open Graph y Twitter Card en `web/index.html`, con la imagen de
  vista previa.
- Cabecera con el logo y enlace directo al juego en el README.
- Despliegue web automatico a Vercel con GitHub Actions: `vercel.json` con
  `buildCommand`, `outputDirectory`, rewrites y headers de cache; workflow
  `.github/workflows/deploy-web.yml` con jobs de test, produccion (main) y
  preview (develop y PRs); y el script `scripts/deploy-web.sh` para desplegar
  desde el equipo.
- El motor CanvasKit se sirve desde el propio dominio
  (`--no-web-resources-cdn`), sin depender de gstatic.com.
- Documentacion del despliegue en el README, con las dos rutas para crear el
  proyecto de Vercel (CLI o dashboard) y donde encontrar cada secreto.
- 84 jergas limeñas de 5 letras en el diccionario, todas de uso real en Lima
  y la costa central. Fuentes: DiPerú (Academia Peruana de la Lengua),
  "Peruanismos de Lima y la costa central" (108 términos), Wikilengua y
  Martha Hildebrandt.
- `"git": { "deploymentEnabled": false }` en `vercel.json`: evita el doble
  despliegue (Vercel + GitHub Actions) en el mismo push.
- El token de Vercel se pasa por variable de entorno y no por `--token`, que
  quedaba visible en el listado de procesos del runner.
- Nuevas jergas: AGUJA, BROER, CRUDA, FICHO, GUCHA, GUITA, JONCA, LLECA,
  LOMPA, LORNA, MISIO, ROCHE, SIMON, SONSO, TABAS, TASAR, TROME y YUNTA.
- Test que valida letra por letra que cada palabra se puede teclear con el
  teclado virtual.

### Quitado

- Las palabras que no son propiamente peruanas: chilenas (chulo, paila, greña,
  trujo, chuza, fuego), mexicanas (tilin) y las que son español estándar sin
  uso jergático local (macho, manso, cobra, plata, trago, hielo, jerga,
  piñon, fatal, bolsa, gordo, lanza).
- El modal final muestra el cuadro de emojis del resultado, sin necesidad de
  abrir la hoja de compartir.

### Corregido

- La hoja de compartir se desbordaba por debajo del boton "Copiar resultado"
  en pantallas bajas: ahora es desplazable y ocupa hasta el 85% del alto.

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
- Las letras escritas ya no se veian en los cuadritos de la fila activa: la
  casilla mostraba siempre el estado vacio en vez del caracter tipeado.
- La tecla de borrar (BACKSPACE) no era identificable por los tests.

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
