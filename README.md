# Jergadle

**Wordle peruano.** Adivina la jerga del día en 5 letras, todos los días, desde
tu celular o tu navegador.

- 🇵🇪 84 jergas limeñas de 5 letras en el diccionario local
- 🎯 6 intentos por día, misma palabra para todos (sin backend)
- 🔥 Rachas diarias y mejor racha guardadas en el dispositivo
- 📖 Al terminar te mostramos **qué significa la jerga en el Perú**
- 📱 Android + 🌐 Web (responsive)
- 🌗 Tema claro y oscuro, con sonido y animaciones

---

## Cómo jugar

| Color | Significado |
|-------|-------------|
| 🟩 Verde | La letra está en la posición correcta |
| 🟨 Amarillo | La letra existe, pero en otra posición |
| ⬜ Gris | La letra no está en la palabra |

Escribe con el teclado virtual (incluye la **Ñ**) o con tu teclado físico.
En la pantalla de inicio ya puedes escribir: la primera letra te mete
directo al juego.

Al terminar la partida se abre un modal con tus estadísticas, la distribución
de intentos y el **significado peruano de la jerga del día**. Desde ahí puedes
copiar tu resultado con el cuadro de emojis estilo Wordle:

```
Jergadle 3/5
🟩⬜🟨⬜🟩
🟩🟩🟩🟩🟩
```

### Ajustes

En la pantalla de inicio, el icono de **rayos** (arriba a la derecha) alterna
entre tema claro y oscuro, y el de **ajustes** abre el panel con sonido,
feedback háptico y consejos. Todo se guarda en el dispositivo.

---

## Cómo ejecutar

Requisitos: Flutter 3.47+ (Dart 3.13+).

```bash
# Instalar dependencias
flutter pub get

# Ejecutar en web (Chrome)
flutter run -d chrome

# Ejecutar en un dispositivo Android
flutter run -d <device-id>

# Tests
flutter test

# Análisis estático
flutter analyze

# Build de producción
flutter build web --release      # salida en build/web
flutter build apk --release      # salida en build/app/outputs/flutter-apk
```

---

## Arquitectura

```
lib/
├── main.dart                     # punto de entrada
├── app.dart                      # MaterialApp + MultiProvider
├── core/theme/app_theme.dart     # temas claro/oscuro + colores semánticos
├── models/
│   ├── word_entry.dart            # jerga + significado peruano
│   ├── game_guess.dart            # intento evaluado + LetterResult
│   ├── game_stats.dart            # rachas, victorias, distribución
│   ├── daily_game.dart            # estado serializable de la partida
│   └── app_settings.dart          # tema, sonido, háptica
├── data/peruvian_words.dart      # diccionario local (84 jergas)
├── services/
│   ├── storage_service.dart       # SharedPreferences (async)
│   ├── word_service.dart          # palabra del día (epoch + módulo)
│   ├── letter_evaluator.dart      # algoritmo de dos pasadas
│   └── sound_service.dart         # efectos de sonido (audioplayers)
├── providers/
│   ├── game_provider.dart         # ChangeNotifier con toda la lógica
│   └── settings_provider.dart     # preferencias del jugador
├── ui/
│   ├── screens/
│   │   ├── home_screen.dart       # pantalla de inicio con las reglas
│   │   └── game_screen.dart       # layout responsive del juego
│   └── widgets/
│       ├── letter_tile.dart        # ficha con giro 3D
│       ├── grid_board.dart         # tablero 6x5 en cascada
│       ├── virtual_keyboard.dart   # teclado QWERTY con Ñ
│       ├── stats_dialog.dart       # modal + cuadro de emojis
│       ├── shake_transition.dart   # sacudida del tablero
│       ├── home_background.dart    # jergas flotantes
│       ├── settings_sheet.dart     # hoja de ajustes
│       └── app_header.dart         # cabecera con racha
└── utils/day_key.dart             # helpers de fecha (yyyy-MM-dd)
assets/audio/                      # efectos de sonido (.wav)
```

### Palabras repetidas

El evaluador usa dos pasadas (igual que Wordle):

1. **Verdes primero**: toda letra en su posición exacta se marca verde y se
   "consume" de la palabra secreta.
2. **Amarillos después**: para el resto, se cuenta cuántas letras quedan
   disponibles. Si no queda ninguna, la letra es gris.

Esto evita el error clásico de marcar en amarillo una letra que en realidad no
está en la palabra.

### Palabra del día

```dart
index = diasTranscurridosDesde(2024-01-01) % totalDePalabras
```

Como el diccionario es local y está en el mismo orden para todos, todos los
usuarios obtienen la misma palabra el mismo día, sin necesidad de servidor.

### Rachas

- `currentStreak`: +1 al ganar; si se salta un día, se reinicia a 0.
- `maxStreak`: récord histórico.
- Si se juega dos veces el mismo día, la racha no se altera.
- Las estadísticas sólo se cuentan cuando la partida **termina**, no en cada
  intento.

### Persistencia

Todo se guarda en `SharedPreferences` con claves versionadas:

| Clave | Contenido |
|-------|-----------|
| `jergadle.stats` | estadísticas y rachas (JSON) |
| `jergadle.daily.<yyyy-MM-dd>` | partida del día (intentos + estado) |
| `jergadle.daily.last` | clave del último día jugado |
| `jergadle.history` | historial de partidas |
| `jergadle.settings` | tema, sonido, háptica y consejos |

Al reabrir la app el mismo día, la partida se restaura tal cual estaba.

---

## Flujo de trabajo (GitFlow)

El repositorio sigue [GitFlow](https://gitflow.gitbook.io/):

```
main        # producción: solo releases con tag SemVer
develop     # integración: siempre desplegable
feature/*   # una rama por funcionalidad, PR hacia develop
release/*   # preparación de release, PR hacia main
hotfix/*    # correcciones urgentes desde main
```

Reglas:

- Cada `feature/*` sale de `develop` y vuelve a `develop` vía **Pull Request**.
- Commits con [Conventional Commits](https://www.conventionalcommits.org/):
  `feat(ui): ...`, `fix(provider): ...`, `docs: ...`, `test: ...`, `chore: ...`.
- Merges con `--no-ff` para conservar el historial de la rama.
- `main` sólo se modifica mediante un PR de `release/*` o `hotfix/*`.
- Todo PR debe pasar `flutter analyze` y `flutter test`.

Detalle completo en [CONTRIBUTING.md](CONTRIBUTING.md).

---

## Extender el diccionario

Las 84 jergas son **de uso real en Lima y la costa central**, tomadas de:

- **DiPerú**, diccionario de la Academia Peruana de la Lengua
- **Peruanismos de Lima y la costa central** (108 términos)
- **Wikilengua**, *Jerga juvenil/Perú*
- **Martha Hildebrandt**, *Peruanismos*

Quedaron fuera las palabras que no son propiamente peruanas (chileno,
argentino, mexicano) y las que son español estándar sin uso jergático local.

Todas tienen **exactamente 5 letras** y se pueden teclear con el teclado
virtual (el test lo comprueba letra por letra). Algunas son de registro vulgar
(`CACHI`, `TARRO`, `PICHI`, `TALCO`), tal como se usan en la calle.

Para añadir más, inserta en `lib/data/peruvian_words.dart` (en orden
alfabético):

```dart
WordEntry(
  word: 'NUEVA',
  definition: 'Significado peruano de la jerga.',
);
```

El test `word_service_test.dart` valida que todas tengan 5 letras, que no
haya duplicados, que las definiciones no contengan caracteres corruptos y que
cada letra exista en el teclado.

---

## Licencia

MIT
