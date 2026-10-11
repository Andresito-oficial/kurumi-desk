#!/bin/bash
# doki-jetbrains-fix2.sh — registra Kurumi en plugin.xml

set -e

JAR="$HOME/.local/share/JetBrains/IntelliJIdea2026.2/doki-theme-jetbrains/lib/doki-theme-jetbrains-88.5-1.16.5.jar"
CACHE_DIR="$HOME/.cache/JetBrains/IntelliJIdea2026.2"
WORK="/tmp/doki-fix2-$$"

UUID_L="7a8c3e21-4b5f-4d9a-8e2c-1f6b3a9d7c04"
UUID_D="9d2f6b14-7e3a-4c81-b5d2-8a1e4c7f9035"
PATH_L="/doki/themes/date_a_live/Tokisaki_Kurumi.theme.json"
PATH_D="/doki/themes/date_a_live/Tokisaki_Kurumi_Dark.theme.json"

c_rose="\e[38;5;211m"; c_green="\e[38;5;114m"; c_red="\e[38;5;197m"; c_reset="\e[0m"
info()  { printf "${c_rose}◆${c_reset} %s\n" "$*"; }
ok()    { printf "${c_green}✓${c_reset} %s\n" "$*"; }
err()   { printf "${c_red}✗${c_reset} %s\n" "$*" >&2; }
step()  { printf "\n${c_red}══ %s ══${c_reset}\n" "$*"; }

# ─── Cerrar IntelliJ ───────────────────────────────────────
step "Cerrando IntelliJ"
pkill -9 -f idea 2>/dev/null || true
sleep 3
ok "Cerrado"

# ─── Backup ────────────────────────────────────────────────
step "Backup"
BK="$HOME/doki-jetbrains-backup-$(date +%Y%m%d-%H%M%S)"
mkdir -p "$BK"
cp "$JAR" "$BK/"
ok "Backup: $BK"

# ─── Extraer ───────────────────────────────────────────────
step "Extrayendo JAR"
mkdir -p "$WORK"
cd "$WORK"
unzip -q "$JAR"
ok "Extraído"

# ─── Meter el id de vuelta en los JSON ─────────────────────
step "Restaurando 'id' en los JSON"

# Leer de los theme.json (nuestros)
for pair in "Tokisaki_Kurumi:$UUID_L" "Tokisaki_Kurumi_Dark:$UUID_D"; do
    name="${pair%%:*}"
    uuid="${pair##*:}"
    json="doki/themes/date_a_live/${name}.theme.json"
    meta="doki/themes/date_a_live/${name}.theme.meta.json"

    [ ! -f "$json" ] && { err "Falta $json"; exit 1; }

    jq --arg id "$uuid" '.id = $id' "$json" > "$json.tmp" && mv "$json.tmp" "$json"
    jq --arg id "$uuid" '.id = $id' "$meta" > "$meta.tmp" && mv "$meta.tmp" "$meta"
    ok "$name → id=$uuid"
done

# ─── Añadir themeProvider al plugin.xml ────────────────────
step "Registrando en plugin.xml"

PLUGIN_XML="META-INF/plugin.xml"

if grep -q "$UUID_L" "$PLUGIN_XML"; then
    info "Ya estaba registrado, saltando"
else
    # Encontrar la línea del último <themeProvider
    LAST_LINE=$(grep -n "<themeProvider" "$PLUGIN_XML" | tail -1 | cut -d: -f1)
    if [ -z "$LAST_LINE" ]; then
        err "No encuentro themeProvider en plugin.xml"
        exit 1
    fi

    # Insertar después de esa línea
    sed -i "${LAST_LINE}a\\
    <themeProvider id=\"$UUID_L\" path=\"$PATH_L\" />\\
    <themeProvider id=\"$UUID_D\" path=\"$PATH_D\" />" "$PLUGIN_XML"

    ok "Añadidos 2 themeProvider tras la línea $LAST_LINE"
fi

# Verificar
info "themeProvider de Kurumi en plugin.xml:"
grep -c "Tokisaki_Kurumi" "$PLUGIN_XML" || true

# ─── Reempaquetar ──────────────────────────────────────────
step "Reempaquetando JAR"
zip -q -r "$JAR" META-INF/plugin.xml doki/themes/date_a_live/
ok "Reempaquetado"

# Verificar dentro del JAR
info "Verificando en el JAR:"
unzip -p "$JAR" META-INF/plugin.xml | grep "Tokisaki_Kurumi"

# ─── Limpiar caché ─────────────────────────────────────────
step "Limpiando caché"
rm -rf "$CACHE_DIR"/*
ok "Caché limpiada"

# ─── Limpiar tmp ───────────────────────────────────────────
rm -rf "$WORK"

cat <<EOF

${c_red}══ Listo ══${c_reset}

Backup: $BK

${c_rose}Abre IntelliJ y comprueba el dropdown de Theme.${c_reset}
Ahora deberían aparecer "Tokisaki Kurumi" y "Tokisaki Kurumi Dark".
EOF
