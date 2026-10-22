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

## Despliegue web (Vercel)

La app web es un sitio estático: Vercel sólo sirve los archivos de
`build/web`. El despliegue está automatizado con **GitHub Actions** para no
gastar minutos de build de Vercel y aprovechar la caché del SDK de Flutter.

### 1. Crear el proyecto en Vercel

1. Entra en [vercel.com/new](https://vercel.com/new) e importa el repositorio
   `BryanPool99/jergadle`.
2. **Framework Preset:** `Other`.
3. **Build Command:** `flutter build web --release --no-web-resources-cdn`
4. **Output Directory:** `build/web`
5. Despliega una vez. Tu URL será `jergadle.vercel.app` (si el nombre está
   libre; si no, `jergadle-xxx.vercel.app`, cámbiala en *Settings → Domains*).

> Vercel no tiene Flutter en su imagen de build, pero **no pasa nada**: el
> build real lo hace GitHub Actions y a Vercel solo se le sube el resultado.

### 2. Secretos en GitHub

En *Settings → Secrets and variables → Actions* crea:

| Secreto | Dónde se saca |
|---------|---------------|
| `VERCEL_TOKEN` | Vercel → *Account Settings → Tokens* → *Create Token* (scope `vercel.com`, Full Access) |
| `VERCEL_ORG_ID` | Vercel → *Settings → General → ID* (o el `orgId` de `.vercel/project.json`) |
| `VERCEL_PROJECT_ID` | Vercel → *Settings → General → Project ID* (o el `projectId` de `.vercel/project.json`) |

### 3. Qué hace el workflow

`.github/workflows/deploy-web.yml` tiene tres trabajos:

| Job | Cuándo corre | Qué hace |
|-----|--------------|----------|
| `test` | siempre | `flutter analyze` + `flutter test`. **Ninguna versión se despliega si falla.** |
| `deploy-production` | push a `main` | Compila y despliega a producción (`jergadle.vercel.app`) |
| `deploy-preview` | push a `develop` o PR | Compila y despliega una URL de preview |

Cada despliegue usa el flujo oficial de Vercel:

```
vercel pull              ->  descarga .vercel/project.json
vercel build             ->  ejecuta el buildCommand y deja .vercel/output
vercel deploy --prebuilt --prod
```

### 4. Despliegue manual

```bash
npm install --global vercel@latest
vercel login
bash scripts/deploy-web.sh --prod
```

### Detalles importantes de la configuración

`vercel.json` define lo que hace que la app funcione bien:

- **`--no-web-resources-cdn`**: sin este flag, Flutter descarga el motor
  CanvasKit desde `gstatic.com`. Con él, el motor se sirve desde el mismo
  dominio: más rápido y sin depender de Google (muy útil en redes de Perú).
- **`Cache-Control`**: `main.dart.js` tiene nombre fijo, así que **no puede**
  cachearse un año o los usuarios se quedarían con la versión vieja para
  siempre. Va con `max-age=0, must-revalidate`. En cambio `assets/` y
  `canvaskit/` sí se cachean un año (`immutable`), porque no cambian.
- **`Content-Type: application/wasm`**: necesario para que el navegador
  compile el motor con WebAssembly.
- **`rewrites`**: todo cae en `index.html`. Vercel sirve primero los archivos
  del disco, así que los assets no se rompen.

### Service worker y PWA

El service worker de Flutter **se mantiene activo**: la app se puede instalar
como PWA y el juego funciona sin conexión (útil para la jerga del día).
Flutter versiona el `flutter_service_worker.js` y, gracias a los headers
anteriores, una actualización se descarga en la visita siguiente. Si prefieres
que la app nunca se cachee, quita el `flutter_service_worker.js` del build (la
app sigue funcionando, solo pierde el modo offline).

---

## Licencia

MIT
