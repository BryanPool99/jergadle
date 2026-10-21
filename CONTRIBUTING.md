# Guía de contribución — Jergadle

## Flujo GitFlow

```
main         (producción, sólo releases)
  ↑
release/*    (cut de release + PR a main + tag)
  ↑
develop      (integración)
  ↑
feature/*    (PR hacia develop)
hotfix/*     (desde main, PR a main + merge de vuelta a develop)
```

### Ramas

| Rama | Propósito | Destino de los merges |
|------|-----------|------------------------|
| `main` | Código en producción | PR desde `release/*` o `hotfix/*` |
| `develop` | Integración diaria | PR desde `feature/*` |
| `feature/<n>-<descripcion>` | Una funcionalidad | PR a `develop` |
| `release/<version>` | Preparación de release | PR a `main` + tag |
| `hotfix/<descripcion>` | Corrección urgente | PR a `main` y `develop` |

### Reglas

1. **Nunca commitees directo a `main` ni a `develop`.** Todo pasa por PR.
2. Crea la rama desde `develop` actualizado:
   ```bash
   git checkout develop
   git pull
   git checkout -b feature/7-nueva-funcionalidad
   ```
3. Commits pequeños y atómicos con Conventional Commits:
   ```
   feat(ui): add Ñ key to virtual keyboard
   fix(provider): reset streak when day is skipped
   docs: update README with build instructions
   test: cover repeated letter evaluation
   chore: bump shared_preferences to 2.3.3
   ```
   Tipos válidos: `feat`, `fix`, `docs`, `style`, `refactor`, `perf`, `test`,
   `build`, `ci`, `chore`, `revert`.
4. Antes de abrir el PR:
   ```bash
   flutter analyze
   flutter test
   ```
5. Merge con `--no-ff` para preservar el historial:
   ```bash
   git checkout develop
   git merge --no-ff feature/7-nueva-funcionalidad
   ```
6. Release:
   ```bash
   git checkout -b release/0.2.0 develop
   # actualizar CHANGELOG.md y pubspec.yaml version
   git commit -m "chore(release): 0.2.0"
   # PR release/0.2.0 -> main, luego:
   git tag -a v0.2.0 -m "Jergadle 0.2.0"
   git checkout develop && git merge --no-ff release/0.2.0
   ```

## Estructura del proyecto

- `lib/models/` — modelos puros, sin dependencias de Flutter.
- `lib/services/` — lógica de dominio y persistencia.
- `lib/providers/` — `ChangeNotifier` que orquesta el juego.
- `lib/ui/` — widgets y pantallas (sin lógica de negocio).
- `test/` — tests unitarios con `flutter test`.

Reglas rápidas:

- Nada de lógica de negocio dentro de widgets.
- Todo acceso a `SharedPreferences` pasa por `StorageService`.
- Las palabras del diccionario siempre tienen 5 letras y una definición.
- Comentarios y documentación en español.

## Plantilla de Pull Request

```markdown
## Descripción
Qué cambia y por qué.

## Tipo de cambio
- [ ] feat
- [ ] fix
- [ ] docs
- [ ] refactor
- [ ] test

## Verificación
- [ ] `flutter analyze` sin errores
- [ ] `flutter test` pasa
- [ ] Probado en web
- [ ] Probado en Android
```
