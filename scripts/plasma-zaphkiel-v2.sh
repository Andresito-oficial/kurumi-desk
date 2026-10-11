#!/bin/bash
# plasma-zaphkiel-v2.sh — Global Themes Kurumi para Plasma 6 (formato correcto)

set -e

LF_DIR="$HOME/.local/share/plasma/look-and-feel"
CS_DIR="$HOME/.local/share/color-schemes"
BIN_DIR="$HOME/.local/bin"
SVC_DIR="$HOME/.config/systemd/user"

mkdir -p "$LF_DIR" "$CS_DIR" "$BIN_DIR" "$SVC_DIR"

c_rose="\e[38;5;211m"; c_green="\e[38;5;114m"; c_red="\e[38;5;197m"; c_reset="\e[0m"
info()  { printf "${c_rose}◆${c_reset} %s\n" "$*"; }
ok()    { printf "${c_green}✓${c_reset} %s\n" "$*"; }
step()  { printf "\n${c_red}══ %s ══${c_reset}\n" "$*"; }

# ══════════════════════════════════════════════════════════════
#  0. LIMPIAR LO ROTO
# ══════════════════════════════════════════════════════════════
step "Limpiando intentos anteriores"
rm -rf "$LF_DIR/Zaphkiel" "$LF_DIR/Zaphkiel-Dark"
rm -f  "$CS_DIR/Zaphkiel.colors" "$CS_DIR/Zaphkiel-Dark.colors"
ok "Limpio"

# ══════════════════════════════════════════════════════════════
#  1. COLOR SCHEMES
# ══════════════════════════════════════════════════════════════
step "Color schemes"

# ─── Zaphkiel (día) ────────────────────────────────────────
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

# ─── Zaphkiel-Dark (noche) ─────────────────────────────────
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
#  2. LOOK-AND-FEEL (metadata.json — formato Plasma 6 correcto)
# ══════════════════════════════════════════════════════════════
step "Look-and-Feel"

build_lf() {
    local name="$1"
    local cs="$2"
    local dir="$LF_DIR/$name"

    mkdir -p "$dir/contents"

    cat > "$dir/metadata.json" << EOF
{
    "KPlugin": {
        "Authors": [
            {
                "Name": "Andrés"
            }
        ],
        "Category": "Plasma Look And Feel",
        "Description": "Tokisaki Kurumi theme for Plasma 6",
        "Id": "$name",
        "License": "MIT",
        "Name": "$name",
        "Version": "1.0",
        "Website": ""
    },
    "X-Plasma-APIVersion": "2"
}
EOF

    cat > "$dir/contents/defaults" << EOF
[kdeglobals][KDE]
LookAndFeelPackage=$name
widgetStyle=Breeze

[kdeglobals][General]
ColorScheme=$cs
Name=$name

[kdeglobals][Icons]
Theme=AnimeApps

[kdeglobals][Sounds]
Theme=Moesound_MGd
EnableOnLogin=true

[kdeglobals][KDE]
AnimationDurationFactor=1

[kcminputrc][Mouse]
cursorTheme=Luka-animated-cursor
cursorSize=24

[plasmarc][Theme]
name=default

[plasmashell]
icontheme=AnimeApps
widgetStyle=Breeze
SoundTheme=Moesound_MGd

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

[Effect-Blur]
BlurStrength=8
NoiseStrength=2
EOF

    ok "$name (metadata.json + contents/defaults)"
}

build_lf "Zaphkiel"      "Zaphkiel"
build_lf "Zaphkiel-Dark" "Zaphkiel-Dark"

# ══════════════════════════════════════════════════════════════
#  3. SCRIPT DE SWITCH (con Opera incluido)
# ══════════════════════════════════════════════════════════════
step "Script de switch"

cat > "$BIN_DIR/plasma-theme-switch.sh" << 'EOF'
#!/bin/bash
# plasma-theme-switch.sh — aplica los temas Kurumi en Plasma y llama a Opera

MODE="${1:-light}"

if [ "$MODE" = "dark" ]; then
    CS="Zaphkiel-Dark"
    LF="Zaphkiel-Dark"
    STATE="Nightmare"
else
    CS="Zaphkiel"
    LF="Zaphkiel"
    STATE="Kurumi"
fi

echo "[$(date)] Plasma → $MODE (cs=$CS, lf=$LF)"

# 1. Color scheme (rápido, se ve al instante)
plasma-apply-colorscheme "$CS" 2>/dev/null

# 2. Cursor theme (por si algún perfil lo cambió)
kwriteconfig6 --file kcminputrc --group Mouse --key cursorTheme "Luka-animated-cursor"
kwriteconfig6 --file kcminputrc --group Mouse --key cursorSize "24"

# 3. Icon theme
kwriteconfig6 --file kdeglobals --group Icons --key Theme "AnimeApps"

# 4. Sound theme
kwriteconfig6 --file kdeglobals --group Sounds --key Theme "Moesound_MGd"

# 5. Notificar a KWin que relea la config
qdbus6 org.kde.KWin /KWin reconfigure 2>/dev/null || true

# 6. Estado global (para Vim, Hyper, Waybar, etc.)
echo "$STATE" > /tmp/kurumi_mode

# 7. Aplicar el look-and-feel completo (opcional, es más lento)
# plasma-apply-lookandfeel -a "$LF" 2>/dev/null || true

# 8. Opera GX
if pgrep -f "opera-gx" > /dev/null && [ -x "$HOME/.local/bin/opera-theme.sh" ]; then
    if [ "$MODE" = "dark" ]; then
        "$HOME/.local/bin/opera-theme.sh" dark &
    else
        "$HOME/.local/bin/opera-theme.sh" light &
    fi
fi

# 9. Waybar (si está corriendo)
if pgrep -x waybar >/dev/null; then
    if [ "$MODE" = "dark" ] && [ -f "$HOME/.config/waybar/style-dark.css" ]; then
        cp "$HOME/.config/waybar/style-dark.css" "$HOME/.config/waybar/style.css"
        pkill -USR2 waybar 2>/dev/null || true
    elif [ "$MODE" = "light" ] && [ -f "$HOME/.config/waybar/style-light.css" ]; then
        cp "$HOME/.config/waybar/style-light.css" "$HOME/.config/waybar/style.css"
        pkill -USR2 waybar 2>/dev/null || true
    fi
fi

# 10. Hyper (Doki themeId)
HYPER_L="7a8c3e21-4b5f-4d9a-8e2c-1f6b3a9d7c04"
HYPER_D="9d2f6b14-7e3a-4c81-b5d2-8a1e4c7f9035"
HYPER_CFG="$HOME/.doki-theme-hyper-config/.hyper.doki.config.json"
if [ -f "$HYPER_CFG" ] && command -v jq >/dev/null 2>&1; then
    if [ "$MODE" = "dark" ]; then
        jq --arg id "$HYPER_D" '.themeId = $id' "$HYPER_CFG" > "$HYPER_CFG.tmp" && mv "$HYPER_CFG.tmp" "$HYPER_CFG"
    else
        jq --arg id "$HYPER_L" '.themeId = $id' "$HYPER_CFG" > "$HYPER_CFG.tmp" && mv "$HYPER_CFG.tmp" "$HYPER_CFG"
    fi
fi

echo "[$(date)] Plasma switch OK"
EOF
chmod +x "$BIN_DIR/plasma-theme-switch.sh"
ok "plasma-theme-switch.sh"

# ══════════════════════════════════════════════════════════════
#  4. SERVICIO SYSTEMD (demonio que escucha /tmp/kurumi_mode)
# ══════════════════════════════════════════════════════════════
step "Servicio systemd de usuario"

cat > "$SVC_DIR/plasma-theme-sync.service" << 'EOF'
[Unit]
Description=Plasma Kurumi theme sync (listens to /tmp/kurumi_mode)
After=graphical-session.target
PartOf=graphical-session.target

[Service]
Type=simple
Environment="DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/%U/bus"
ExecStart=/bin/bash -c 'LAST=""; while true; do if [ -f /tmp/kurumi_mode ]; then CUR=$(cat /tmp/kurumi_mode); if [ "$CUR" != "$LAST" ]; then LAST="$CUR"; if [ "$CUR" = "Nightmare" ]; then %h/.local/bin/plasma-theme-switch.sh dark; else %h/.local/bin/plasma-theme-switch.sh light; fi; fi; fi; sleep 2; done'
Restart=on-failure
RestartSec=3

[Install]
WantedBy=default.target
EOF

systemctl --user daemon-reload
systemctl --user enable plasma-theme-sync.service
systemctl --user restart plasma-theme-sync.service
sleep 1
systemctl --user status plasma-theme-sync.service --no-pager | head -5

# ══════════════════════════════════════════════════════════════
#  5. VERIFICAR
# ══════════════════════════════════════════════════════════════
step "Verificación"

echo "Color schemes:"
ls -1 "$CS_DIR" | grep -i zaphkiel

echo ""
echo "Look-and-Feel:"
for d in "$LF_DIR"/Zaphkiel*; do
    [ -d "$d" ] && echo "  $(basename "$d"):" && ls "$d"
done

echo ""
echo "Servicio:"
systemctl --user is-active plasma-theme-sync.service

# ══════════════════════════════════════════════════════════════
#  RESUMEN
# ══════════════════════════════════════════════════════════════
cat << EOF

${c_red}══ Listo ══${c_reset}

${c_rose}Probar ahora:${c_reset}
  ~/.local/bin/plasma-theme-switch.sh dark
  ~/.local/bin/plasma-theme-switch.sh light

${c_rose}Aplicar desde Ajustes (Global Theme):${c_reset}
  Apariencia → Tema global → "Zaphkiel" o "Zaphkiel-Dark"

${c_rose}El demonio hará el cambio automático cuando /tmp/kurumi_mode cambie.${c_reset}
  (que lo escribe zaphkiel_nightmare.sh con el ciclo solar)

Cursor: Luka-animated-cursor
Iconos: AnimeApps
Sonidos: Moesound_MGd
EOF
