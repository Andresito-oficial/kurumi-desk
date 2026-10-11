#!/bin/bash
# plasma-zaphkiel.sh — Global Theme Kurumi para KDE Plasma 6

set -e

LF_DIR="$HOME/.local/share/plasma/look-and-feel"
CS_DIR="$HOME/.local/share/color-schemes"
DT_DIR="$HOME/.local/share/plasma/desktoptheme"
AU_DIR="$HOME/.local/share/aurorae/themes"

mkdir -p "$LF_DIR" "$CS_DIR" "$DT_DIR" "$AU_DIR"

c_rose="\e[38;5;211m"; c_green="\e[38;5;114m"; c_red="\e[38;5;197m"; c_reset="\e[0m"
info()  { printf "${c_rose}◆${c_reset} %s\n" "$*"; }
ok()    { printf "${c_green}✓${c_reset} %s\n" "$*"; }
step()  { printf "\n${c_red}══ %s ══${c_reset}\n" "$*"; }

# ══════════════════════════════════════════════════════════════
#  1. COLOR SCHEMES
# ══════════════════════════════════════════════════════════════

step "Color schemes"

# ─── Zaphkiel (DÍA) ────────────────────────────────────────────
cat > "$CS_DIR/Zaphkiel.colors" << 'EOF'
[ColorEffects:Disabled]
Color=242,230,217
ColorAmount=0
ColorEffect=0
ContrastAmount=0.65
ContrastEffect=1
IntensityAmount=0.1
IntensityEffect=2

[ColorEffects:Inactive]
ChangeSelectionColor=true
Color=236,208,218
ColorAmount=0.025
ColorEffect=2
ContrastAmount=0.1
ContrastEffect=2
Enable=false
IntensityAmount=0
IntensityEffect=0

[Colors:Button]
BackgroundAlternate=242,230,217
BackgroundNormal=252,238,243
DecorationFocus=194,24,91
DecorationHover=194,24,91
ForegroundActive=194,24,91
ForegroundInactive=185,138,156
ForegroundLink=194,24,91
ForegroundNegative=179,0,60
ForegroundNeutral=160,20,83
ForegroundNormal=139,13,71
ForegroundPositive=26,122,61
ForegroundVisited=139,13,71

[Colors:Complementary]
BackgroundAlternate=245,220,229
BackgroundNormal=242,230,217
DecorationFocus=194,24,91
DecorationHover=194,24,91
ForegroundActive=194,24,91
ForegroundInactive=185,138,156
ForegroundLink=194,24,91
ForegroundNegative=179,0,60
ForegroundNeutral=160,20,83
ForegroundNormal=139,13,71
ForegroundPositive=26,122,61
ForegroundVisited=139,13,71

[Colors:Header]
BackgroundAlternate=245,220,229
BackgroundNormal=242,230,217
DecorationFocus=194,24,91
DecorationHover=194,24,91
ForegroundActive=194,24,91
ForegroundInactive=185,138,156
ForegroundLink=194,24,91
ForegroundNegative=179,0,60
ForegroundNeutral=160,20,83
ForegroundNormal=139,13,71
ForegroundPositive=26,122,61
ForegroundVisited=139,13,71

[Colors:Header][Inactive]
BackgroundAlternate=245,220,229
BackgroundNormal=242,230,217
DecorationFocus=194,24,91
DecorationHover=194,24,91
ForegroundActive=194,24,91
ForegroundInactive=185,138,156
ForegroundLink=194,24,91
ForegroundNegative=179,0,60
ForegroundNeutral=160,20,83
ForegroundNormal=139,13,71
ForegroundPositive=26,122,61
ForegroundVisited=139,13,71

[Colors:Selection]
BackgroundAlternate=194,24,91
BackgroundNormal=194,24,91
DecorationFocus=194,24,91
DecorationHover=160,20,83
ForegroundActive=255,255,255
ForegroundInactive=255,255,255
ForegroundLink=255,255,255
ForegroundNegative=255,255,255
ForegroundNeutral=255,255,255
ForegroundNormal=255,255,255
ForegroundPositive=255,255,255
ForegroundVisited=255,255,255

[Colors:Tooltip]
BackgroundAlternate=242,230,217
BackgroundNormal=139,13,71
DecorationFocus=194,24,91
DecorationHover=194,24,91
ForegroundActive=250,244,236
ForegroundInactive=236,208,218
ForegroundLink=250,244,236
ForegroundNegative=250,244,236
ForegroundNeutral=250,244,236
ForegroundNormal=250,244,236
ForegroundPositive=250,244,236
ForegroundVisited=250,244,236

[Colors:View]
BackgroundAlternate=242,230,217
BackgroundNormal=253,245,247
DecorationFocus=194,24,91
DecorationHover=194,24,91
ForegroundActive=194,24,91
ForegroundInactive=185,138,156
ForegroundLink=194,24,91
ForegroundNegative=179,0,60
ForegroundNeutral=160,20,83
ForegroundNormal=139,13,71
ForegroundPositive=26,122,61
ForegroundVisited=139,13,71

[Colors:Window]
BackgroundAlternate=242,230,217
BackgroundNormal=250,244,236
DecorationFocus=194,24,91
DecorationHover=194,24,91
ForegroundActive=194,24,91
ForegroundInactive=185,138,156
ForegroundLink=194,24,91
ForegroundNegative=179,0,60
ForegroundNeutral=160,20,83
ForegroundNormal=139,13,71
ForegroundPositive=26,122,61
ForegroundVisited=139,13,71

[General]
ColorScheme=Zaphkiel
Name=Zaphkiel
shadeSortColumn=true

[KDE]
contrast=4

[WM]
activeBackground=242,230,217
activeBlend=194,24,91
activeForeground=139,13,71
inactiveBackground=245,220,229
inactiveBlend=236,208,218
inactiveForeground=185,138,156
EOF
ok "Zaphkiel.colors"

# ─── Zaphkiel-Dark (NOCHE) ────────────────────────────────────
cat > "$CS_DIR/Zaphkiel-Dark.colors" << 'EOF'
[ColorEffects:Disabled]
Color=20,0,5
ColorAmount=0
ColorEffect=0
ContrastAmount=0.65
ContrastEffect=1
IntensityAmount=0.1
IntensityEffect=2

[ColorEffects:Inactive]
ChangeSelectionColor=true
Color=31,0,8
ColorAmount=0.025
ColorEffect=2
ContrastAmount=0.1
ContrastEffect=2
Enable=false
IntensityAmount=0
IntensityEffect=0

[Colors:Button]
BackgroundAlternate=20,0,5
BackgroundNormal=31,0,8
DecorationFocus=255,0,60
DecorationHover=255,107,138
ForegroundActive=255,184,198
ForegroundInactive=107,0,24
ForegroundLink=255,107,138
ForegroundNegative=255,0,60
ForegroundNeutral=255,107,138
ForegroundNormal=255,184,198
ForegroundPositive=95,255,159
ForegroundVisited=255,107,138

[Colors:Complementary]
BackgroundAlternate=13,0,3
BackgroundNormal=20,0,5
DecorationFocus=255,0,60
DecorationHover=255,107,138
ForegroundActive=255,184,198
ForegroundInactive=107,0,24
ForegroundLink=255,107,138
ForegroundNegative=255,0,60
ForegroundNeutral=255,107,138
ForegroundNormal=255,184,198
ForegroundPositive=95,255,159
ForegroundVisited=255,107,138

[Colors:Header]
BackgroundAlternate=13,0,3
BackgroundNormal=13,0,3
DecorationFocus=255,0,60
DecorationHover=255,107,138
ForegroundActive=255,184,198
ForegroundInactive=107,0,24
ForegroundLink=255,107,138
ForegroundNegative=255,0,60
ForegroundNeutral=255,107,138
ForegroundNormal=255,184,198
ForegroundPositive=95,255,159
ForegroundVisited=255,107,138

[Colors:Header][Inactive]
BackgroundAlternate=13,0,3
BackgroundNormal=13,0,3
DecorationFocus=255,0,60
DecorationHover=255,107,138
ForegroundActive=255,184,198
ForegroundInactive=107,0,24
ForegroundLink=255,107,138
ForegroundNegative=255,0,60
ForegroundNeutral=255,107,138
ForegroundNormal=255,184,198
ForegroundPositive=95,255,159
ForegroundVisited=255,107,138

[Colors:Selection]
BackgroundAlternate=255,0,60
BackgroundNormal=255,0,60
DecorationFocus=255,0,60
DecorationHover=255,107,138
ForegroundActive=5,0,0
ForegroundInactive=5,0,0
ForegroundLink=5,0,0
ForegroundNegative=5,0,0
ForegroundNeutral=5,0,0
ForegroundNormal=5,0,0
ForegroundPositive=5,0,0
ForegroundVisited=5,0,0

[Colors:Tooltip]
BackgroundAlternate=13,0,3
BackgroundNormal=255,0,60
DecorationFocus=255,0,60
DecorationHover=255,107,138
ForegroundActive=5,0,0
ForegroundInactive=5,0,0
ForegroundLink=5,0,0
ForegroundNegative=5,0,0
ForegroundNeutral=5,0,0
ForegroundNormal=5,0,0
ForegroundPositive=5,0,0
ForegroundVisited=5,0,0

[Colors:View]
BackgroundAlternate=13,0,3
BackgroundNormal=13,0,3
DecorationFocus=255,0,60
DecorationHover=255,107,138
ForegroundActive=255,184,198
ForegroundInactive=107,0,24
ForegroundLink=255,107,138
ForegroundNegative=255,0,60
ForegroundNeutral=255,107,138
ForegroundNormal=255,184,198
ForegroundPositive=95,255,159
ForegroundVisited=255,107,138

[Colors:Window]
BackgroundAlternate=13,0,3
BackgroundNormal=5,0,0
DecorationFocus=255,0,60
DecorationHover=255,107,138
ForegroundActive=255,184,198
ForegroundInactive=107,0,24
ForegroundLink=255,107,138
ForegroundNegative=255,0,60
ForegroundNeutral=255,107,138
ForegroundNormal=255,184,198
ForegroundPositive=95,255,159
ForegroundVisited=255,107,138

[General]
ColorScheme=Zaphkiel-Dark
Name=Zaphkiel-Dark
shadeSortColumn=true

[KDE]
contrast=4

[WM]
activeBackground=31,0,8
activeBlend=255,0,60
activeForeground=255,184,198
inactiveBackground=13,0,3
inactiveBlend=20,0,5
inactiveForeground=107,0,24
EOF
ok "Zaphkiel-Dark.colors"

# ══════════════════════════════════════════════════════════════
#  2. LOOK-AND-FEEL (Global Themes)
# ══════════════════════════════════════════════════════════════

step "Look-and-Feel"

for mode in "Zaphkiel:Zaphkiel:Breeze:Zaphkiel" "Zaphkiel-Dark:Zaphkiel-Dark:Breeze:Zaphkiel-Dark"; do
    IFS=":" read -r name scheme widgeticon csname <<< "$mode"

    mkdir -p "$LF_DIR/$name/contents"

    cat > "$LF_DIR/$name/metadata.desktop" << EOF
[Desktop Entry]
Name=$name
Comment=Tokisaki Kurumi theme for Plasma 6
Type=X-KDE-ThemedPackage
Encoding=UTF-8
X-KDE-PluginInfo-Author=Andrés
X-KDE-PluginInfo-Email=
X-KDE-PluginInfo-Name=$name
X-KDE-PluginInfo-Version=1.0
X-KDE-PluginInfo-License=MIT
X-KDE-PluginInfo-EnabledByDefault=false
EOF

    cat > "$LF_DIR/$name/contents/defaults" << EOF
[kdeglobals][KDE]
widgetStyle=Breeze

[kdeglobals][General]
ColorScheme=$csname

[kdeglobals][Icons]
Theme=AnimeApps

[kcminputrc][Mouse]
cursorTheme=Luka_Static

[plasmarc][Theme]
name=default

[kwinrc][org.kde.kdecoration2]
theme=Breeze
library=org.kde.breeze
BorderSize=Normal
BorderSizeAuto=true
ButtonsOnLeft=M
ButtonsOnRight=IAX

[kwinrc][WindowSwitcher]
LayoutName=thumbnail_grid

[kwinrc][DesktopSwitcher]
LayoutName=thumbnail_grid

[Windows]
Placement=Centered

[Plugins]
forceblurEnabled=true
kwin4_effect_dimscreenEnabled=true
kwin4_effect_fadeEnabled=true
kwin4_effect_scaleEnabled=true
kwin4_effect_squashEnabled=false
magiclampEnabled=true
wobblywindowsEnabled=false
EOF

    ok "$name"
done

# ══════════════════════════════════════════════════════════════
#  3. SCRIPT DE AUTO-SWITCH
# ══════════════════════════════════════════════════════════════

step "Script de auto-switch"

mkdir -p "$HOME/.local/bin"

cat > "$HOME/.local/bin/plasma-theme-switch.sh" << 'EOF'
#!/bin/bash
# plasma-theme-switch.sh — aplica el ColorScheme y Look-and-Feel según modo

MODE="${1:-light}"

LIGHT_CS="Zaphkiel"
DARK_CS="Zaphkiel-Dark"
LIGHT_LF="Zaphkiel"
DARK_LF="Zaphkiel-Dark"

if [ "$MODE" = "dark" ]; then
    CS="$DARK_CS"
    LF="$DARK_LF"
else
    CS="$LIGHT_CS"
    LF="$LIGHT_LF"
fi

# 1. Color scheme (rápido, en caliente)
plasma-apply-colorscheme "$CS"

# 2. Look-and-Feel (más global, tarda un poco)
plasma-apply-lookandfeel -a "$LF" 2>/dev/null || true

# 3. Cambiar el color-scheme de apps GTK para que combinen
if [ "$MODE" = "dark" ]; then
    gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark' 2>/dev/null
    gsettings set org.gnome.desktop.interface gtk-theme 'Zaphkiel-dark' 2>/dev/null
else
    gsettings set org.gnome.desktop.interface color-scheme 'prefer-light' 2>/dev/null
    gsettings set org.gnome.desktop.interface gtk-theme 'Zaphkiel' 2>/dev/null
fi

# 4. Waybar (si está corriendo en esta sesión)
if pgrep -x waybar >/dev/null; then
    if [ "$MODE" = "dark" ] && [ -f "$HOME/.config/waybar/style-dark.css" ]; then
        cp "$HOME/.config/waybar/style-dark.css" "$HOME/.config/waybar/style.css"
    elif [ -f "$HOME/.config/waybar/style-light.css" ]; then
        cp "$HOME/.config/waybar/style-light.css" "$HOME/.config/waybar/style.css"
    fi
    pkill -USR2 waybar 2>/dev/null || true
fi

echo "[$(date)] Plasma → $MODE (cs=$CS, lf=$LF)"
EOF
chmod +x "$HOME/.local/bin/plasma-theme-switch.sh"
ok "plasma-theme-switch.sh instalado"

# ══════════════════════════════════════════════════════════════
#  4. INTEGRACIÓN CON zaphkiel_nightmare.sh
# ══════════════════════════════════════════════════════════════

step "Integración con zaphkiel_nightmare.sh"

NM="$HOME/.local/bin/zaphkiel_nightmare.sh"
if [ -f "$NM" ]; then
    # Añadir llamada al switcher de Plasma si no está ya
    if ! grep -q "plasma-theme-switch.sh" "$NM"; then
        # Buscar la línea del bloque de Opera y meterlo antes
        if grep -q "opera-theme.sh" "$NM"; then
            sed -i '/opera-theme.sh/i \
    # ─── Plasma ───────────────────────────────────────────────\
    if pgrep -x plasmashell > /dev/null; then\
        if [ "$STATE" = "Nightmare" ]; then\
            "$HOME/.local/bin/plasma-theme-switch.sh" dark \& \
        else\
            "$HOME/.local/bin/plasma-theme-switch.sh" light \& \
        fi\
    fi\
' "$NM"
            ok "Añadida llamada a Plasma en zaphkiel_nightmare.sh"
        else
            info "No encuentro opera-theme.sh, mete la llamada manualmente"
        fi
    else
        info "Ya estaba integrado"
    fi
else
    info "No existe $NM, no hay nada que integrar"
fi

# ══════════════════════════════════════════════════════════════
#  VERIFICACIÓN
# ══════════════════════════════════════════════════════════════

step "Verificación"

echo "Color schemes:"
ls -1 "$CS_DIR" | grep -i zaphkiel

echo ""
echo "Look-and-Feel:"
ls -1 "$LF_DIR" | grep -i zaphkiel

echo ""
echo "Script:"
ls -la "$HOME/.local/bin/plasma-theme-switch.sh"

# ══════════════════════════════════════════════════════════════
#  RESUMEN
# ══════════════════════════════════════════════════════════════

cat <<EOF

${c_red}══ Listo ══${c_reset}

${c_rose}Probar ahora:${c_reset}
  plasma-theme-switch.sh dark
  plasma-theme-switch.sh light

${c_rose}Aplicar desde Ajustes del Sistema:${c_reset}
  Apariencia → Tema global → busca "Zaphkiel" o "Zaphkiel-Dark"

${c_rose}Alternativa manual:${c_reset}
  Apariencia → Colores → "Zaphkiel" / "Zaphkiel-Dark"
EOF
