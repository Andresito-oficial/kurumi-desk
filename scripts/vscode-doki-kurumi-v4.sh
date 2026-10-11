#!/bin/bash
# vscode-doki-kurumi-v4.sh — reemplaza cualquier color base residual, preservando alpha

set -e

EXT_DIR=$(find ~/.vscode/extensions -maxdepth 1 -type d -name "unthrottled.doki-theme-*" | sort -V | tail -1)
GEN="$EXT_DIR/generatedThemes"

LIGHT="$GEN/Tokisaki Kurumi.theme.json"
DARK="$GEN/Tokisaki Kurumi Dark.theme.json"

[ ! -f "$LIGHT" ] && { echo "❌ Falta $LIGHT"; exit 1; }
[ ! -f "$DARK" ]  && { echo "❌ Falta $DARK"; exit 1; }

# ─── Función: reemplaza #RRGGBB conservando los 2 últimos dígitos si existen
replace_color() {
    local file="$1" src="$2" dst="$3"
    # Sin alpha (6 dígitos)
    sed -i "s/${src}\"/${dst}\"/gI" "$file"
    # Con alpha (8 dígitos): mantén los 2 últimos
    sed -i -E "s/${src}([0-9A-Fa-f]{2})/${dst}\1/gI" "$file"
}

echo "══ LIGHT ══"
# Colores residuales de Zero Two → Kurumi
declare -A LIGHT_MAP=(
    # Verdes/mentas
    ["#c1e9d4"]="#f5dce5"
    ["#E3E8DE"]="#f5dce5"
    ["#42a373"]="#a01453"
    ["#CBFFCE"]="#c8f0c8"
    # Rosas pálidos Zero Two
    ["#ffdce7"]="#f5dce5"
    ["#ffdbe5"]="#f5dce5"
    ["#f1e4f6"]="#f5dce5"
    # Rojos
    ["#FF5555"]="#b3003c"
    # Nuestros ya aplicados (por si sed los re-toca)
    ["#c2185b"]="#c2185b"
)
for src in "${!LIGHT_MAP[@]}"; do
    replace_color "$LIGHT" "$src" "${LIGHT_MAP[$src]}"
done

echo "══ DARK ══"
declare -A DARK_MAP=(
    # Rojos oscuros Zero Two → nuestros oscuros Kurumi
    ["#531e1e"]="#1f0008"
    ["#491e1e"]="#1f0008"
    ["#461819"]="#1f0008"
    ["#3c1818"]="#1f0008"
    ["#3c1616"]="#0d0003"
    ["#3c1414"]="#1f0008"
    # Dorados Zero Two
    ["#b19e78"]="#ffb8c6"
    # Verde oscuro Zero Two
    ["#102d0e"]="#001a08"
    # Rojos
    ["#FF5555"]="#ff003c"
)
for src in "${!DARK_MAP[@]}"; do
    replace_color "$DARK" "$src" "${DARK_MAP[$src]}"
done

echo "✅ Hecho. Verificando..."

echo ""
echo "=== LIGHT: alphas residuales ==="
jq -r '.colors | to_entries[] | select(.value | test("^#[0-9A-Fa-f]{8}$")) | "\(.key) = \(.value)"' "$LIGHT"

echo ""
echo "=== DARK: alphas residuales ==="
jq -r '.colors | to_entries[] | select(.value | test("^#[0-9A-Fa-f]{8}$")) | "\(.key) = \(.value)"' "$DARK"

# Reiniciar VSCode
pkill -f code 2>/dev/null || true
sleep 2
code &
