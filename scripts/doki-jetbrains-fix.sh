#!/bin/bash
# doki-jetbrains-fix.sh — repara el Doki Theme para IntelliJ 2026+
# Hace 2 cosas: parchea el JAR y exporta los temas como custom themes nativos.

set -e

JAR_BASE="$HOME/.local/share/JetBrains/IntelliJIdea2026.2/doki-theme-jetbrains"
JAR="$JAR_BASE/lib/doki-theme-jetbrains-88.5-1.16.5.jar"
COLORS_DIR="$HOME/.config/JetBrains/IntelliJIdea2026.2/colors"
CACHE_DIR="$HOME/.cache/JetBrains/IntelliJIdea2026.2"
WORK="/tmp/doki-fix-$$"

c_rose="\e[38;5;211m"; c_green="\e[38;5;114m"; c_yellow="\e[38;5;221m"; c_red="\e[38;5;197m"; c_reset="\e[0m"

info()  { printf "${c_rose}◆${c_reset} %s\n" "$*"; }
ok()    { printf "${c_green}✓${c_reset} %s\n" "$*"; }
warn()  { printf "${c_yellow}⚠${c_reset} %s\n" "$*"; }
err()   { printf "${c_red}✗${c_reset} %s\n" "$*" >&2; }
step()  { printf "\n${c_red}══ %s ══${c_reset}\n" "$*"; }

# ─── Comprobaciones previas ─────────────────────────────────
step "Comprobaciones"

if [ ! -f "$JAR" ]; then
    err "No encuentro el JAR: $JAR"
    err "¿Está instalado el plugin Doki en IntelliJ 2026.2?"
    exit 1
fi
ok "JAR encontrado"

if pgrep -f "idea" >/dev/null; then
    warn "IntelliJ está abierto. Cerrando..."
    pkill -9 -f idea
    sleep 3
fi
ok "IntelliJ cerrado"

# ─── Backup ────────────────────────────────────────────────
step "Backup"

BACKUP_DIR="$HOME/doki-jetbrains-backup-$(date +%Y%m%d-%H%M%S)"
mkdir -p "$BACKUP_DIR"
cp "$JAR" "$BACKUP_DIR/"
[ -d "$COLORS_DIR" ] && cp -r "$COLORS_DIR" "$BACKUP_DIR/colors-backup" 2>/dev/null || true
ok "Backup en: $BACKUP_DIR"

# ─── Extraer el JAR ────────────────────────────────────────
step "Extrayendo JAR"

mkdir -p "$WORK/extracted"
cd "$WORK/extracted"
unzip -q "$JAR"

NUM_THEMES=$(find doki/themes -name "*.theme.json" | wc -l)
info "Temas encontrados en el JAR: $NUM_THEMES"

# ─── Parchear todos los theme.json (quitar "id") ───────────
step "Parcheando theme.json (quitando 'id')"

FIXED=0
for f in $(find doki/themes -name "*.theme.json" ! -name "*.meta.json"); do
    if jq -e 'has("id")' "$f" >/dev/null 2>&1; then
        jq 'del(.id)' "$f" > "$f.tmp" && mv "$f.tmp" "$f"
        FIXED=$((FIXED+1))
    fi
done
ok "Parcheados $FIXED archivos"

# ─── Reparar también los meta.json ─────────────────────────
step "Parcheando theme.meta.json"

FIXED_META=0
for f in $(find doki/themes -name "*.theme.meta.json"); do
    if jq -e 'has("id")' "$f" >/dev/null 2>&1; then
        jq 'del(.id)' "$f" > "$f.tmp" && mv "$f.tmp" "$f"
        FIXED_META=$((FIXED_META+1))
    fi
done
ok "Parcheados $FIXED_META meta.json"

# ─── Exportar TODOS los temas a colors/ (temas nativos) ────
step "Exportando temas a ~/.config/JetBrains/*/colors/"

mkdir -p "$COLORS_DIR"

EXPORTED=0
for f in $(find doki/themes -name "*.theme.json" ! -name "*.meta.json"); do
    # Nombre limpio: quitar ruta y extensión
    basename=$(basename "$f" .theme.json)
    # Sanear nombre (espacios → _, caracteres raros)
    safe=$(echo "$basename" | sed 's/[^a-zA-Z0-9._-]/_/g')
    cp "$f" "$COLORS_DIR/$safe.theme.json"
    EXPORTED=$((EXPORTED+1))
done
ok "Exportados $EXPORTED temas a $COLORS_DIR"

# ─── Reempaquetar el JAR ───────────────────────────────────
step "Reempaquetando JAR"

cd "$WORK/extracted"
zip -q -r "$JAR" doki/ theme-schema/ io/ META-INF/ 2>/dev/null || \
    zip -q -r "$JAR" . -x ".*" -x "__MACOSX" 2>/dev/null

# Verificar
cd "$WORK"
VERIFY=$(unzip -l "$JAR" | grep -c "\.theme\.json$")
info "JAR reempaquetado con $VERIFY theme.json"

# ─── Verificar que nuestros temas están ────────────────────
step "Verificando temas Kurumi"

if unzip -l "$JAR" | grep -q "Tokisaki_Kurumi"; then
    ok "Tokisaki Kurumi presente en el JAR"
else
    warn "Tokisaki Kurumi NO está en el JAR"
fi

if [ -f "$COLORS_DIR/Tokisaki_Kurumi.theme.json" ]; then
    ok "Tokisaki Kurumi en colors/ nativos"
    jq -r '.colors.accentColor' "$COLORS_DIR/Tokisaki_Kurumi.theme.json"
fi

# ─── Limpiar caché ─────────────────────────────────────────
step "Limpiando caché de IntelliJ"

if [ -d "$CACHE_DIR" ]; then
    rm -rf "$CACHE_DIR"/*
    ok "Caché limpiada"
fi

# ─── Limpiar tmp ───────────────────────────────────────────
rm -rf "$WORK"

# ─── Resumen ───────────────────────────────────────────────
cat <<EOF

${c_red}══ Listo ══${c_reset}

Backup:          $BACKUP_DIR
Temas parcheados: $FIXED theme.json + $FIXED_META meta.json
Exportados:      $EXPORTED temas a ~/.config/JetBrains/.../colors/

${c_rose}Siguiente:${c_reset}
  1. Abre IntelliJ:  idea &
  2. Settings → Appearance & Behavior → Appearance → Theme
  3. Busca "Tokisaki Kurumi" o "Zero Two Light Sakura" (los que ahora sí cargan)
  
${c_yellow}Nota:${c_reset}
  Los temas aparecerán en 2 sitios:
   · Como "Doki Theme" (plugin parcheado en el JAR)
   · Como "Custom Theme" (carpeta colors/, método nativo IntelliJ)
  
  Si el dropdown del plugin sigue roto, usa los "Custom Theme".
EOF

ok "Hecho 🩸"
