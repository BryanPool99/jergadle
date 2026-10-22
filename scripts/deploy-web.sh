#!/usr/bin/env bash
# Despliegue local de Jergadle a Vercel.
#
# Uso:
#   bash scripts/deploy-web.sh            # preview
#   bash scripts/deploy-web.sh --prod     # produccion
#
# Requisitos: Node 18+, Flutter 3.47+ y la CLI de Vercel (npm i -g vercel).
set -euo pipefail

TARGET="preview"
if [ "${1:-}" = "--prod" ]; then
  TARGET="production"
fi

if ! command -v vercel >/dev/null 2>&1; then
  echo ">> Falta la CLI de Vercel. Instala con: npm install --global vercel@latest"
  exit 1
fi

echo ">> Compilando Flutter web..."
flutter build web --release --no-web-resources-cdn

echo ">> Vinculando con el proyecto de Vercel..."
vercel link --yes --project="${VERCEL_PROJECT_NAME:-jergadle}" --token="${VERCEL_TOKEN:-}"

echo ">> Preparando la salida de Vercel..."
if [ "$TARGET" = "production" ]; then
  vercel pull --yes --environment=production --token="${VERCEL_TOKEN:-}"
  vercel build --prod --token="${VERCEL_TOKEN:-}"
  vercel deploy --prebuilt --prod --token="${VERCEL_TOKEN:-}"
else
  vercel pull --yes --environment=preview --token="${VERCEL_TOKEN:-}"
  vercel build --token="${VERCEL_TOKEN:-}"
  vercel deploy --prebuilt --token="${VERCEL_TOKEN:-}"
fi

echo ">> Listo."
