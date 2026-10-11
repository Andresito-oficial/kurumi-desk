#!/bin/bash
# plasma-global-fix.sh — convierte Zaphkiel y Zaphkiel-Dark en Global Themes funcionales

set -e

LF_DIR="$HOME/.local/share/plasma/look-and-feel"
CS_DIR="$HOME/.local/share/color-schemes"

c_rose="\e[38;5;211m"; c_green="\e[38;5;114m"; c_red="\e[38;5;197m"; c_reset="\e[0m"
ok()   { printf "${c_green}✓${c_reset} %s\n" "$*"; }
step() { printf "\n${c_red}══ %s ══${c_reset}\n" "$*"; }

# ══════════════════════════════════════════════════════════════
step "1. Verificando dependencias"

for dep in AnimeApps Luka-animated-cursor Moesound_MGd; do
    if [ -d "$HOME/.icons/$dep" ] || [ -d "$HOME/.local/share/icons/$dep" ] || \
       [ -d "/usr/share/icons/$dep" ] || \
       [ -d "$HOME/.local/share/sounds/$dep" ] || [ -d "/usr/share/sounds/$dep" ]; then
        ok "$dep encontrado"
    else
        printf "  ${c_red}⚠ $dep NO encontrado${c_reset}\n"
    fi
done

[ ! -f "$CS_DIR/Zaphkiel.colors" ] && { echo "❌ Falta Zaphkiel.colors"; exit 1; }
[ ! -f "$CS_DIR/Zaphkiel-Dark.colors" ] && { echo "❌ Falta Zaphkiel-Dark.colors"; exit 1; }
ok "Color schemes en su sitio"

# ══════════════════════════════════════════════════════════════
step "2. Reconstruyendo Zaphkiel (día)"

D="$LF_DIR/Zaphkiel"
rm -rf "$D"
mkdir -p "$D/contents"

cat > "$D/metadata.json" << 'EOF'
{
    "KPlugin": {
        "Authors": [{"Name": "Andrés"}],
        "Category": "Plasma Look And Feel",
        "Description": "Tokisaki Kurumi (Arena) — tema claro",
        "Id": "Zaphkiel",
        "License": "MIT",
        "Name": "Zaphkiel",
        "Version": "1.0",
        "Website": ""
    },
    "KPackageStructure": "Plasma/LookAndFeel",
    "X-Plasma-APIVersion": "2"
}
EOF

cat > "$D/contents/defaults" << 'EOF'
[kdeglobals][KDE]
LookAndFeelPackage=Zaphkiel
widgetStyle=Breeze

[kdeglobals][General]
ColorScheme=Zaphkiel
Name=Zaphkiel

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
splash=org.kde.breeze.desktop

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

chmod -R 755 "$D"
ok "Zaphkiel reconstruido"

# ══════════════════════════════════════════════════════════════
step "3. Reconstruyendo Zaphkiel-Dark (noche)"

D="$LF_DIR/Zaphkiel-Dark"
rm -rf "$D"
mkdir -p "$D/contents"

cat > "$D/metadata.json" << 'EOF'
{
    "KPlugin": {
        "Authors": [{"Name": "Andrés"}],
        "Category": "Plasma Look And Feel",
        "Description": "Tokisaki Kurumi (Nightmare) — tema oscuro",
        "Id": "Zaphkiel-Dark",
        "License": "MIT",
        "Name": "Zaphkiel-Dark",
        "Version": "1.0",
        "Website": ""
    },
    "KPackageStructure": "Plasma/LookAndFeel",
    "X-Plasma-APIVersion": "2"
}
EOF

cat > "$D/contents/defaults" << 'EOF'
[kdeglobals][KDE]
LookAndFeelPackage=Zaphkiel-Dark
widgetStyle=Breeze

[kdeglobals][General]
ColorScheme=Zaphkiel-Dark
Name=Zaphkiel-Dark

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
splash=org.kde.breeze.desktop

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

chmod -R 755 "$D"
ok "Zaphkiel-Dark reconstruido"

# ══════════════════════════════════════════════════════════════
step "4. Sincronizando cursor/iconos/sonidos en kdeglobals"

kwriteconfig6 --file kdeglobals --group Icons --key Theme "AnimeApps"
kwriteconfig6 --file kdeglobals --group Sounds --key Theme "Moesound_MGd"
kwriteconfig6 --file kcminputrc --group Mouse --key cursorTheme "Luka-animated-cursor"
kwriteconfig6 --file kcminputrc --group Mouse --key cursorSize "24"
ok "kdeglobals actualizado"

# ══════════════════════════════════════════════════════════════
step "5. Matando plasmashell para que refresque la lista"

pkill plasmashell 2>/dev/null || true
sleep 2
nohup plasmashell --replace >/dev/null 2>&1 &
sleep 3
ok "plasmashell reiniciado"

# ══════════════════════════════════════════════════════════════
step "6. Verificación"

echo ""
echo "Color schemes disponibles:"
plasma-apply-colorscheme --list-schemes 2>&1 | grep -i zaphkiel || echo "  (ninguno)"

echo ""
echo "Look-and-feel disponibles:"
plasma-apply-lookandfeel --list 2>&1 | grep -i zaphkiel || echo "  (ninguno)"

echo ""
echo "Estructura Zaphkiel:"
ls -la "$LF_DIR/Zaphkiel/"
ls -la "$LF_DIR/Zaphkiel/contents/"

echo ""
echo "Estructura Zaphkiel-Dark:"
ls -la "$LF_DIR/Zaphkiel-Dark/"
ls -la "$LF_DIR/Zaphkiel-Dark/contents/"

# ══════════════════════════════════════════════════════════════
cat << 'EOF'

══ Listo ══

Abre: Ajustes del Sistema → Apariencia → Tema global
Deberías ver: "Zaphkiel" y "Zaphkiel-Dark"

Si NO aparecen:
  Pásame la salida de:
    plasma-apply-lookandfeel --list 2>&1
    cat ~/.local/share/plasma/look-and-feel/Zaphkiel/metadata.json

Si aparecen pero al aplicar dan error:
  pásame:
    plasma-apply-lookandfeel -a Zaphkiel 2>&1
EOF
