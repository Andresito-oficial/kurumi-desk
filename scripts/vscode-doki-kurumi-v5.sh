#!/bin/bash
# vscode-doki-kurumi-v5.sh — limpia colores residuales (fallbacks VSCode)

set -e

EXT_DIR=$(find ~/.vscode/extensions -maxdepth 1 -type d -name "unthrottled.doki-theme-*" | sort -V | tail -1)
GEN="$EXT_DIR/generatedThemes"

LIGHT="$GEN/Tokisaki Kurumi.theme.json"
DARK="$GEN/Tokisaki Kurumi Dark.theme.json"

# ─── LIGHT ─── reemplaza residuales
declare -A LIGHT_MAP=(
    # Texto/foreground olvidados
    ["#252427"]="#8b0d47"
    ["#444444"]="#8b0d47"
    ["#646465"]="#b98a9c"
    ["#6c6c6c"]="#b98a9c"
    ["#969696"]="#b98a9c"
    ["#424242"]="#8b0d47"
    ["#cccccc"]="#f2e6d9"

    # Acentos Zero Two
    ["#a62210"]="#c2185b"
    ["#d66f95"]="#c2185b"

    # Azules VSCode
    ["#0063d3"]="#c2185b"
    ["#007acc"]="#c2185b"
    ["#0000ff"]="#c2185b"
    ["#d6ecf2"]="#f5dce5"
    ["#d6ebff"]="#f5dce5"
    ["#3b8eea"]="#8b0d47"
    ["#236b8e"]="#c2185b"

    # Rojos y dorados de validación
    ["#f89da6"]="#f4b3c3"
    ["#be1100"]="#b3003c"
    ["#faf5e0"]="#fcf2c5"
    ["#b89500"]="#c2185b"
    ["#855f00"]="#c2185b"
    ["#a31515"]="#c2185b"
    ["#e2e7e2"]="#c8f0c8"

    # Grises residuales
    ["#f0f0f0"]="#f5dce5"
    ["#ececec"]="#ecd0da"
    ["#dddddd"]="#ecd0da"
    ["#e0afaa"]="#f5dce5"
    ["#c2675c"]="#b98a9c"
    ["#93727c"]="#b98a9c"
    ["#ffd1e2"]="#f2e6d9"
    ["#ffe5ef"]="#f2e6d9"

    # Amarillos residuales
    ["#ddb100"]="#c2185b"
)

for src in "${!LIGHT_MAP[@]}"; do
    dst="${LIGHT_MAP[$src]}"
    # Sin alpha
    sed -i "s/\"${src}\"/\"${dst}\"/gI" "$LIGHT"
    # Con alpha (mantén los últimos 2)
    sed -i -E "s/${src}([0-9A-Fa-f]{2})/${dst}\1/gI" "$LIGHT"
done

# ─── DARK ───
declare -A DARK_MAP=(
    # Texto/foreground
    ["#252427"]="#ffb8c6"
    ["#444444"]="#ffb8c6"
    ["#646465"]="#6b0018"
    ["#6c6c6c"]="#6b0018"
    ["#969696"]="#6b0018"
    ["#424242"]="#ffb8c6"
    ["#cccccc"]="#1f0008"

    # Acentos Zero Two
    ["#a62210"]="#ff003c"
    ["#d66f95"]="#ff003c"

    # Azules
    ["#0063d3"]="#ff003c"
    ["#007acc"]="#ff003c"
    ["#0000ff"]="#ff003c"
    ["#d6ecf2"]="#1f0008"
    ["#d6ebff"]="#1f0008"
    ["#3b8eea"]="#ffb8c6"
    ["#236b8e"]="#ff003c"

    # Rojos y dorados
    ["#f89da6"]="#ff003c"
    ["#be1100"]="#ff003c"
    ["#faf5e0"]="#3d1a0a"
    ["#b89500"]="#ff6b8a"
    ["#855f00"]="#ff6b8a"
    ["#a31515"]="#ff003c"
    ["#e2e7e2"]="#001a08"

    # Grises
    ["#f0f0f0"]="#1f0008"
    ["#ececec"]="#1f0008"
    ["#dddddd"]="#1f0008"
    ["#e0afaa"]="#1f0008"
    ["#c2675c"]="#6b0018"
    ["#93727c"]="#6b0018"
    ["#ffd1e2"]="#0d0003"
    ["#ffe5ef"]="#0d0003"

    # Amarillos
    ["#ddb100"]="#ff6b8a"
)

for src in "${!DARK_MAP[@]}"; do
    dst="${DARK_MAP[$src]}"
    sed -i "s/\"${src}\"/\"${dst}\"/gI" "$DARK"
    sed -i -E "s/${src}([0-9A-Fa-f]{2})/${dst}\1/gI" "$DARK"
done

echo "✅ V5 aplicado"

pkill -f code 2>/dev/null || true
sleep 2
code
