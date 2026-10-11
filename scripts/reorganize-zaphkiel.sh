#!/bin/bash
# reorganize-zaphkiel.sh — estructura Yaru

set -e

THEMES="$HOME/.themes"
BACKUP="$HOME/.themes-backup-$(date +%Y%m%d-%H%M%S)"

echo "══ 1. Backup ══"
mkdir -p "$BACKUP"
cp -a "$THEMES/Zaphkiel" "$BACKUP/"
cp -a "$THEMES/Zaphkiel-dark" "$BACKUP/"
echo "✅ Backup en: $BACKUP"

echo ""
echo "══ 2. Guardar CSS temporalmente ══"
TMPDIR=$(mktemp -d)

cp "$THEMES/Zaphkiel/gtk-3.0/gtk.css"      "$TMPDIR/gtk3-light.css"
cp "$THEMES/Zaphkiel/gtk-4.0/gtk.css"      "$TMPDIR/gtk4-light.css"
cp "$THEMES/Zaphkiel/gnome-shell/gnome-shell.css" "$TMPDIR/shell-light.css"

cp "$THEMES/Zaphkiel-dark/gtk-3.0/gtk.css"      "$TMPDIR/gtk3-dark.css"
cp "$THEMES/Zaphkiel-dark/gtk-4.0/gtk.css"      "$TMPDIR/gtk4-dark.css"
cp "$THEMES/Zaphkiel-dark/gnome-shell/gnome-shell.css" "$TMPDIR/shell-dark.css"

echo "✅ CSS temporales en $TMPDIR"

echo ""
echo "══ 3. Base Zaphkiel (shell = dark, gtk = light) ══"

# Shell del base = dark (es el look "default")
cp "$TMPDIR/shell-dark.css" "$THEMES/Zaphkiel/gnome-shell/gnome-shell.css"

# GTK3: gtk.css (light) + gtk-dark.css (dark)
cp "$TMPDIR/gtk3-light.css" "$THEMES/Zaphkiel/gtk-3.0/gtk.css"
cp "$TMPDIR/gtk3-dark.css"  "$THEMES/Zaphkiel/gtk-3.0/gtk-dark.css"

# GTK4: gtk.css (light) + gtk-dark.css (symlink al dark)
cp "$TMPDIR/gtk4-light.css" "$THEMES/Zaphkiel/gtk-4.0/gtk.css"
ln -sf "../../Zaphkiel-dark/gtk-4.0/gtk.css" "$THEMES/Zaphkiel/gtk-4.0/gtk-dark.css"

# index.theme del base
cat > "$THEMES/Zaphkiel/index.theme" << 'EOF'
[X-GNOME-Metatheme]
Name=Zaphkiel
Type=X-GNOME-Metatheme
Comment=Tema Kurumi (auto claro/oscuro)
Encoding=UTF-8
GtkTheme=Zaphkiel
IconTheme=AnimeApps
CursorTheme=Luka_Static
CursorSize=24
EOF

echo "✅ Base listo"

echo ""
echo "══ 4. Zaphkiel-light (shell claro, gtk claro) ══"

mkdir -p "$THEMES/Zaphkiel-light/gnome-shell" "$THEMES/Zaphkiel-light/gtk-3.0" "$THEMES/Zaphkiel-light/gtk-4.0"
cp "$TMPDIR/shell-light.css" "$THEMES/Zaphkiel-light/gnome-shell/gnome-shell.css"
cp "$TMPDIR/gtk3-light.css"  "$THEMES/Zaphkiel-light/gtk-3.0/gtk.css"
cp "$TMPDIR/gtk4-light.css"  "$THEMES/Zaphkiel-light/gtk-4.0/gtk.css"

cat > "$THEMES/Zaphkiel-light/index_light.theme" << 'EOF'
[X-GNOME-Metatheme]
Name=Zaphkiel-light
Type=X-GNOME-Metatheme
Comment=Tema Kurumi (light)
Encoding=UTF-8
GtkTheme=Zaphkiel
IconTheme=AnimeApps
CursorTheme=Luka_Static
CursorSize=24
EOF

echo "✅ Zaphkiel-light listo"

echo ""
echo "══ 5. Zaphkiel-dark (gtk dark, SIN gnome-shell, hereda del base) ══"

# Asegurar que tiene los CSS propios
cp "$TMPDIR/gtk3-dark.css" "$THEMES/Zaphkiel-dark/gtk-3.0/gtk.css"
cp "$TMPDIR/gtk4-dark.css" "$THEMES/Zaphkiel-dark/gtk-4.0/gtk.css"

# Quitar gnome-shell (hereda del base)
rm -rf "$THEMES/Zaphkiel-dark/gnome-shell"

cat > "$THEMES/Zaphkiel-dark/index_dark.theme" << 'EOF'
[X-GNOME-Metatheme]
Name=Zaphkiel-dark
Type=X-GNOME-Metatheme
Comment=Tema Kurumi (dark)
Encoding=UTF-8
GtkTheme=Zaphkiel
IconTheme=AnimeApps
CursorTheme=Luka_Static
CursorSize=24
EOF

echo "✅ Zaphkiel-dark listo"

echo ""
echo "══ 6. Estado final ══"
echo "Zaphkiel/:";        ls "$THEMES/Zaphkiel/"
echo "Zaphkiel-light/:"; ls "$THEMES/Zaphkiel-light/"
echo "Zaphkiel-dark/:";  ls "$THEMES/Zaphkiel-dark/"

echo ""
echo "══ 7. Aplicando ══"
gsettings set org.gnome.desktop.interface gtk-theme "Zaphkiel"
gsettings set org.gnome.shell.extensions.user-theme name "Zaphkiel"

echo ""
echo "✅ Hecho. Backup: $BACKUP"
echo ""
echo "🧪 Prueba:"
echo "  gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'"
echo "  sleep 2   # apps + shell a dark"
echo "  gsettings set org.gnome.desktop.interface color-scheme 'prefer-light'"
echo "  sleep 2   # apps + shell a light"
