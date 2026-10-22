#!/usr/bin/env bash
# Despliegue local de Jergadle a Vercel.
#
# Uso:
#   bash scripts/deploy-web.sh            # preview
#   bash scripts/deploy-web.sh --prod     # produccion
#
# Requisitos: Node 18+, Flutter 3.47+ y la CLI de Vercel (npm i -g vercel).
#
# El token se toma de la variable de entorno VERCEL_TOKEN (nunca del codigo).
set -euo pipefail

TARGET="preview"
if [ "${1:-}" = "--prod" ]; then
  TARGET="production"
fi

if ! command -v vercel >/dev/null 2>&1; then
  echo ">> Falta la CLI de Vercel. Instala con: npm install --global vercel@latest"
  exit 1
fi

if [ -z "${VERCEL_TOKEN:-}" ]; then
  echo ">> Falta VERCEL_TOKEN. Exporta tu token de https://vercel.com/account/tokens"
  exit 1
fi

export VERCEL_TOKEN

echo ">> Compilando Flutter web..."
flutter build web --release --no-web-resources-cdn

echo ">> Vinculando con el proyecto de Vercel..."
if [ ! -f .vercel/project.json ]; then
  vercel link --yes --non-interactive --project="${VERCEL_PROJECT_NAME:-jergadle}"
fi

echo ">> Preparando la salida de Vercel..."
if [ "$TARGET" = "production" ]; then
  vercel pull --yes --non-interactive --environment=production
  vercel build --prod --non-interactive
  vercel deploy --prebuilt --prod --non-interactive
else
  vercel pull --yes --non-interactive --environment=preview
  vercel build --non-interactive
  vercel deploy --prebuilt --non-interactive
fi

echo ">> Listo."
