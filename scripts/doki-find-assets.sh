#!/bin/bash
# doki-find-assets.sh — localiza dónde van los stickers de cada Doki Theme

c_rose="\e[38;5;211m"; c_green="\e[38;5;114m"; c_yellow="\e[38;5;221m"; c_red="\e[38;5;197m"; c_reset="\e[0m"
info()  { printf "${c_rose}◆${c_reset} %s\n" "$*"; }
ok()    { printf "${c_green}✓${c_reset} %s\n" "$*"; }
warn()  { printf "${c_yellow}⚠${c_reset} %s\n" "$*"; }
step()  { printf "\n${c_red}══ %s ══${c_reset}\n" "$*"; }

# ══════════════════════════════════════════════════════════════
step "1. VSCODE DOKI"
# ══════════════════════════════════════════════════════════════

EXT=$(find ~/.vscode/extensions -maxdepth 1 -type d -name "unthrottled.doki-theme-*" 2>/dev/null | sort -V | tail -1)

if [ -z "$EXT" ]; then
    warn "No encuentro Doki Theme en VSCode"
else
    info "Extensión: $EXT"
    echo ""

    info "Estructura de primer nivel:"
    ls -1 "$EXT" | head -20
    echo ""

    info "Carpetas con 'asset'/'sticker'/'themes' en el nombre:"
    find "$EXT" -maxdepth 3 -type d \( -iname "*asset*" -o -iname "*sticker*" -o -iname "*theme*" -o -iname "*image*" \) 2>/dev/null | grep -v node_modules
    echo ""

    info "PNGs de stickers que tenga (muestra estructura):"
    find "$EXT" -name "*.png" 2>/dev/null | grep -viE "icon|logo|screenshot" | head -10
    echo ""

    info "¿Cómo referencia a los stickers en un theme.json existente?"
    THEME_TEST=$(find "$EXT/generatedThemes" -name "*.theme.json" 2>/dev/null | head -1)
    if [ -n "$THEME_TEST" ]; then
        echo "Ejemplo: $(basename "$THEME_TEST")"
        jq '.stickers, .backgrounds' "$THEME_TEST" 2>/dev/null || echo "  (sin campo stickers)"
    fi
    echo ""

    info "Nuestros temas tienen stickers?"
    for t in "$EXT/generatedThemes/Tokisaki Kurumi.theme.json" "$EXT/generatedThemes/Tokisaki Kurumi Dark.theme.json"; do
        [ -f "$t" ] && echo "$(basename "$t"): $(jq -c '.stickers' "$t" 2>/dev/null)"
    done
fi

# ══════════════════════════════════════════════════════════════
step "2. INTELLIJ DOKI"
# ══════════════════════════════════════════════════════════════

# Localizar todas las instalaciones
IDEA_DIRS=$(find ~/.local/share/JetBrains ~/.config/JetBrains -maxdepth 2 -type d -iname "*doki*" 2>/dev/null)

info "Directorios Doki en IntelliJ:"
echo "$IDEA_DIRS"

info "Doki Theme Assets (config):"
if [ -d ~/.config/JetBrains/dokiThemeAssets ]; then
    find ~/.config/JetBrains/dokiThemeAssets -maxdepth 3 -type d 2>/dev/null | head -20
    echo ""
    info "PNGs en assets:"
    find ~/.config/JetBrains/dokiThemeAssets -name "*.png" 2>/dev/null | head -10
else
    warn "No existe ~/.config/JetBrains/dokiThemeAssets"
fi
echo ""

info "Carpeta del plugin instalado:"
find ~/.local/share/JetBrains -maxdepth 3 -type d -name "doki-theme-jetbrains" 2>/dev/null

info "¿Dónde tiene los stickers dentro del JAR?"
JAR=$(find ~/.local/share/JetBrains -name "doki-theme-jetbrains*.jar" 2>/dev/null | head -1)
if [ -n "$JAR" ]; then
    echo "JAR: $JAR"
    echo ""
    info "Carpetas con 'sticker'/'asset' en el JAR:"
    unzip -l "$JAR" 2>/dev/null | grep -iE "sticker|asset|background" | head -20
fi
echo ""

info "Referencias a stickers en un theme.meta.json de ejemplo:"
TMPDIR=$(mktemp -d)
unzip -o "$JAR" "doki/themes/*/*.theme.meta.json" -d "$TMPDIR" >/dev/null 2>&1
TEST_META=$(find "$TMPDIR" -name "*.theme.meta.json" | head -1)
if [ -n "$TEST_META" ]; then
    echo "Ejemplo: $(basename "$TEST_META")"
    jq '.stickers, .backgrounds' "$TEST_META" 2>/dev/null
fi
rm -rf "$TMPDIR"

# ══════════════════════════════════════════════════════════════
step "3. HYPER DOKI (referencia de lo que ya funciona)"
# ══════════════════════════════════════════════════════════════

info "Stickers instalados en Hyper:"
ls -la ~/.doki-theme-hyper-config/stickers/ 2>/dev/null | head

info "Sticker de Kurumi que metimos:"
find ~/.doki-theme-hyper-config/stickers/dateALive -name "*.png" -exec ls -la {} \; 2>/dev/null

# ══════════════════════════════════════════════════════════════
step "4. RESUMEN — dónde hay que copiar el PNG"
# ══════════════════════════════════════════════════════════════

echo ""
echo "En VSCode, comprobar el campo 'path' de los theme.json existentes:"
echo "  Los theme.json apuntan a rutas tipo '/xxx/yyy/zzz.png'"
echo "  y VSCode los busca en la carpeta raíz del plugin (o en assets/)"
echo ""
echo "En IntelliJ, comprobar cómo carga los assets el plugin:"
echo "  Mirar el theme.meta.json de otros temas que sí tengan stickers"
echo "  Si pone '/franxx/zeroTwo/sakura/zero_two_sakura.png'"
echo "  → hay que copiar el PNG a la ruta equivalente"
echo ""

ok "Búsqueda completada"
