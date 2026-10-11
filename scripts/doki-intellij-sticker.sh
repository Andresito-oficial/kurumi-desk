#!/bin/bash
# doki-intellij-sticker.sh — añade sticker Kurumi a IntelliJ Doki Theme

set -e

JAR=~/.local/share/JetBrains/IntelliJIdea2026.2/doki-theme-jetbrains/lib/doki-theme-jetbrains-88.5-1.16.5.jar
ASSETS=~/.config/JetBrains/IntelliJIdea2026.2/dokiThemeAssets
STICKERS="$ASSETS/stickers"
SRC_PNG=~/.doki-theme-hyper-config/stickers/dateALive/kurumi/light/kurumi.png

# ─── Cerrar IntelliJ ────────────────────────────────────────
pkill -9 -f idea 2>/dev/null || true
sleep 2

# ─── 1. Copiar PNG a la ruta que espera el plugin ───────────
mkdir -p "$STICKERS/dateALive/kurumi/light"
mkdir -p "$STICKERS/dateALive/kurumi/dark"

cp "$SRC_PNG" "$STICKERS/dateALive/kurumi/light/kurumi.png"
cp "$SRC_PNG" "$STICKERS/dateALive/kurumi/dark/kurumi.png"

echo "✅ PNG copiados:"
ls -la "$STICKERS/dateALive/kurumi/light/"
ls -la "$STICKERS/dateALive/kurumi/dark/"

# ─── 2. Añadir entradas al assetChecks.json ────────────────
NOW=$(date +%s)
NOW_NANO=$(date +%N)

LIGHT_PATH="$STICKERS/dateALive/kurumi/light/kurumi.png"
DARK_PATH="$STICKERS/dateALive/kurumi/dark/kurumi.png"

jq --arg lp "$LIGHT_PATH" \
   --arg dp "$DARK_PATH" \
   --argjson ts "$NOW" \
   --argjson tn "$((10#$NOW_NANO))" \
   '.[$lp] = {"seconds": $ts, "nanos": $tn} |
    .[$dp] = {"seconds": $ts, "nanos": $tn}' \
   "$ASSETS/assetChecks.json" > "$ASSETS/assetChecks.json.tmp" \
   && mv "$ASSETS/assetChecks.json.tmp" "$ASSETS/assetChecks.json"

echo "✅ assetChecks.json actualizado"
jq 'keys | map(select(test("kurumi")))' "$ASSETS/assetChecks.json"

# ─── 3. Editar theme.meta.json dentro del JAR ──────────────
cd /tmp
rm -rf doki-intellij-fix
mkdir -p doki-intellij-fix
cd doki-intellij-fix

unzip -o "$JAR" "doki/themes/date_a_live/*" -d . >/dev/null

# Light meta
jq '.stickers = {"default": "/dateALive/kurumi/light/kurumi.png"} |
    .backgrounds = {"default": {"name": "kurumi.png", "position": "CENTER", "opacity": 13}}' \
   doki/themes/date_a_live/Tokisaki_Kurumi.theme.meta.json > tmp && \
   mv tmp doki/themes/date_a_live/Tokisaki_Kurumi.theme.meta.json

# Dark meta
jq '.stickers = {"default": "/dateALive/kurumi/dark/kurumi.png"} |
    .backgrounds = {"default": {"name": "kurumi.png", "position": "CENTER", "opacity": 13}}' \
   doki/themes/date_a_live/Tokisaki_Kurumi_Dark.theme.meta.json > tmp && \
   mv tmp doki/themes/date_a_live/Tokisaki_Kurumi_Dark.theme.meta.json

# Verificar
echo ""
echo "=== Light meta.json ==="
jq '.stickers, .backgrounds' doki/themes/date_a_live/Tokisaki_Kurumi.theme.meta.json

echo ""
echo "=== Dark meta.json ==="
jq '.stickers, .backgrounds' doki/themes/date_a_live/Tokisaki_Kurumi_Dark.theme.meta.json

# Reempaquetar
zip -r "$JAR" doki/themes/date_a_live/ >/dev/null
echo ""
echo "✅ JAR actualizado"

cd /
rm -rf /tmp/doki-intellij-fix

# ─── Limpiar caché de IntelliJ ─────────────────────────────
rm -rf ~/.cache/JetBrains/IntelliJIdea2026.2/* 2>/dev/null || true

echo ""
echo "✅ Hecho. Abre IntelliJ:"
echo "  idea &"
echo ""
echo "Y activa el sticker:"
echo "  Settings → Tools → Doki Theme → Sticker Settings → Show Sticker ✅"
