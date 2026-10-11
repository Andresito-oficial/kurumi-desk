#!/usr/bin/env bash
# ============================================================================
#  sync-to-repo.sh — copia los ficheros del sistema al repo kurumi-desk
#  Crea todas las carpetas necesarias. Omite lo que no exista.
# ============================================================================

set -euo pipefail

# ─── Colores ────────────────────────────────────────────────────────────────
C_RESET="\e[0m"
C_ROSE="\e[38;5;211m"
C_CRIMSON="\e[38;5;197m"
C_GREEN="\e[38;5;114m"
C_GREY="\e[38;5;245m"

info()  { printf "${C_ROSE}◆${C_RESET} %s\n" "$*"; }
ok()    { printf "${C_GREEN}✓${C_RESET} %s\n" "$*"; }
skip()  { printf "${C_GREY}·${C_RESET} %s\n" "$*"; }

# ─── Detectar raíz del repo (directorio del propio script) ─────────────────
REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
info "Repo destino: $REPO_DIR"

# ─── Helpers ────────────────────────────────────────────────────────────────
copy_file() {
    local src="$1" dst="$2"
    if [[ -f "$src" ]]; then
        mkdir -p "$(dirname "$dst")"
        cp -a "$src" "$dst"
        ok "$dst"
    else
        skip "No existe: $src"
    fi
}

copy_dir() {
    local src="$1" dst="$2"
    if [[ -d "$src" ]]; then
        mkdir -p "$(dirname "$dst")"
        rm -rf "$dst"
        cp -a "$src" "$dst"
        ok "$dst"
    else
        skip "No existe: $src"
    fi
}

# ─── 1. Hyprland ────────────────────────────────────────────────────────────
info "Hyprland"
copy_file "$HOME/.config/hypr/hyprland.conf"  "$REPO_DIR/hypr/hyprland.conf"
copy_file "$HOME/.config/hypr/hyprlock.conf"  "$REPO_DIR/hypr/hyprlock.conf"
copy_file "$HOME/.config/hypr/hyprpaper.conf" "$REPO_DIR/hypr/hyprpaper.conf"
copy_file "$HOME/.config/hypr/sound-map.json" "$REPO_DIR/hypr/sound-map.json"

copy_file "$HOME/.config/hypr/scripts/hypr-sound-daemon.py" \
          "$REPO_DIR/hypr/scripts/hypr-sound-daemon.py"
copy_file "$HOME/.config/hypr/scripts/logout-sound.sh" \
          "$REPO_DIR/hypr/scripts/logout-sound.sh"

# ─── 2. Waybar ──────────────────────────────────────────────────────────────
info "Waybar"
copy_dir "$HOME/.config/waybar" "$REPO_DIR/waybar"

# ─── 3. SwayNC ──────────────────────────────────────────────────────────────
info "SwayNC"
copy_dir "$HOME/.config/swaync" "$REPO_DIR/swaync"

# ─── 4. GTK Themes ──────────────────────────────────────────────────────────
info "GTK Themes"
copy_dir "$HOME/.themes/Zaphkiel"      "$REPO_DIR/gtk/Zaphkiel"
copy_dir "$HOME/.themes/Zaphkiel-Dark" "$REPO_DIR/gtk/Zaphkiel-Dark"

# GTK4 / libadwaita (fichero real, no el symlink)
if [[ -f "$HOME/.config/gtk-4.0/gtk.css" ]]; then
    mkdir -p "$REPO_DIR/gtk/gtk-4.0"
    # -L sigue el symlink y copia el contenido real
    cp -L "$HOME/.config/gtk-4.0/gtk.css" "$REPO_DIR/gtk/gtk-4.0/gtk.css"
    ok "$REPO_DIR/gtk/gtk-4.0/gtk.css"
else
    skip "No existe: $HOME/.config/gtk-4.0/gtk.css"
fi

# ─── 5. Sonidos ─────────────────────────────────────────────────────────────
info "Tema de sonido"
copy_dir "$HOME/.local/share/sounds/Moesound_iori" \
         "$REPO_DIR/sounds/Moesound_iori"

# ─── 6. Vim colorscheme ─────────────────────────────────────────────────────
info "Vim colorscheme"
copy_file "$HOME/.vim/colors/tokisaki_kurumi.vim" \
          "$REPO_DIR/vim/tokisaki_kurumi.vim"

# ─── 7. Scripts personales (~/scripts) ─────────────────────────────────────
info "Scripts personales"
if [[ -d "$HOME/scripts" ]]; then
    mkdir -p "$REPO_DIR/scripts"
    for s in "$HOME/scripts"/*.sh; do
        [[ -f "$s" ]] || continue
        cp -a "$s" "$REPO_DIR/scripts/"
        ok "$REPO_DIR/scripts/$(basename "$s")"
    done
else
    skip "No existe: $HOME/scripts"
fi

# ─── 8. systemd user services ──────────────────────────────────────────────
info "systemd user services"
copy_file "$HOME/.config/systemd/user/hypr-sound-daemon.service" \
          "$REPO_DIR/systemd/user/hypr-sound-daemon.service"
copy_file "$HOME/.config/systemd/user/zaphkiel-sync.service" \
          "$REPO_DIR/systemd/user/zaphkiel-sync.service"

# ─── 9. GIFs de bloqueo (opcional) ─────────────────────────────────────────
info "GIFs de bloqueo"
if [[ -d "$HOME/.config/hypr/lock_frames" ]]; then
    mkdir -p "$REPO_DIR/gifs"
    cp -a "$HOME/.config/hypr/lock_frames/." "$REPO_DIR/gifs/"
    ok "$REPO_DIR/gifs/"
else
    skip "No existe: $HOME/.config/hypr/lock_frames"
fi

# ─── 10. GNOME Shell (si tienes los CSS sueltos) ───────────────────────────
# Descomenta y ajusta si guardas los CSS de GNOME Shell en otra ruta
# info "GNOME Shell CSS"
# copy_file "$HOME/.local/share/gnome-shell/theme.css" "$REPO_DIR/gnome-shell/theme.css"

# ─── Fin ────────────────────────────────────────────────────────────────────
echo
printf "${C_CRIMSON}══ Sincronización completada ══${C_RESET}\n"
info "Revisa los cambios con: git status"
info "Luego: git add . && git commit -m 'Update from live system' && git push"
