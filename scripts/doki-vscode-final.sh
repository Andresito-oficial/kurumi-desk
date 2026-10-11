#!/bin/bash
# doki-vscode-final.sh — sirve el CDN local y parchea VSCode

set -e

EXT=$(find ~/.vscode/extensions -maxdepth 1 -type d -name "unthrottled.doki-theme-*" | sort -V | tail -1)
ENV="$EXT/out/ENV.js"
CDN=~/.local/share/doki-cdn
PORT=8765

echo "══ 1. Preparando CDN local ══"
mkdir -p "$CDN/stickers/vscode/dateALive/kurumi/light"
mkdir -p "$CDN/stickers/vscode/dateALive/kurumi/dark"

cp ~/.doki-theme-hyper-config/stickers/dateALive/kurumi/light/kurumi.png \
   "$CDN/stickers/vscode/dateALive/kurumi/light/kurumi.png"
cp ~/.doki-theme-hyper-config/stickers/dateALive/kurumi/light/kurumi.png \
   "$CDN/stickers/vscode/dateALive/kurumi/dark/kurumi.png"

echo "✅ PNGs en $CDN"

echo ""
echo "══ 2. Levantando servidor HTTP en 127.0.0.1:$PORT ══"
pkill -f "http.server $PORT" 2>/dev/null || true
sleep 1
cd "$CDN"
nohup python3 -m http.server $PORT --bind 127.0.0.1 >/dev/null 2>&1 &
sleep 2

# Verificar
if curl -sf -I "http://127.0.0.1:$PORT/stickers/vscode/dateALive/kurumi/dark/kurumi.png" >/dev/null; then
    echo "✅ Servidor OK"
else
    echo "❌ Servidor no responde"
    exit 1
fi

echo ""
echo "══ 3. Parcheando ENV.js para apuntar al local ══"
cp "$ENV" "$ENV.bak-$(date +%s)"
sed -i 's|https://doki.assets.unthrottled.io|http://127.0.0.1:'$PORT'|g' "$ENV"

grep "ASSETS_URL = " "$ENV"

echo ""
echo "══ 4. Borrando timestamps de check del state.vscdb ══"
STATE=~/.config/Code/User/globalStorage/state.vscdb
if [ -f "$STATE" ]; then
    pkill -f code 2>/dev/null || true
    sleep 2
    # Borrar todos los "check.https://doki.assets..." para forzar redescarga
    sqlite3 "$STATE" "DELETE FROM ItemTable WHERE key LIKE 'check.https://doki.assets.unthrottled.io/%';" 2>/dev/null || \
    sqlite3 "$STATE" "DELETE FROM ItemTable WHERE key LIKE 'check.%doki.assets%';" 2>/dev/null || \
    echo "⚠ No se pudo borrar (sqlite3 no instalado?)"

    # Comprobar
    sqlite3 "$STATE" "SELECT COUNT(*) FROM ItemTable WHERE key LIKE 'check.%doki.assets%';" 2>/dev/null || true
fi

echo ""
echo "══ 5. Reiniciando VSCode ══"
sleep 1
code &

echo ""
echo "✅ Listo."
echo ""
echo "En VSCode:"
echo "  1. Ctrl+K Ctrl+T → 'Tokisaki Kurumi Dark'"
echo "  2. Debería cargar el sticker del CDN local"
echo "  3. Si no aparece, Ctrl+Shift+P → 'Doki Theme: Install Sticker'"
