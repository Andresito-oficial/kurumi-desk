#!/usr/bin/env bash
# ============================================================================
#  kurumi-desk — instalador
#  Tokisaki Kurumi theme pack: GTK, GNOME Shell, Hyprland, Vim, sounds, GIFs
#  Autor: Andrés · Licencia: MIT
# ============================================================================

set -euo pipefail

# ─── Colores ────────────────────────────────────────────────────────────────
C_RESET="\e[0m"
C_ROSE="\e[38;5;211m"
C_CRIMSON="\e[38;5;197m"
C_GREY="\e[38;5;245m"
C_GREEN="\e[38;5;114m"
C_YELLOW="\e[38;5;221m"

info()  { printf "${C_ROSE}◆${C_RESET} %s\n" "$*"; }
ok()    { printf "${C_GREEN}✓${C_RESET} %s\n" "$*"; }
warn()  { printf "${C_YELLOW}⚠${C_RESET} %s\n" "$*"; }
err()   { printf "${C_CRIMSON}✗${C_RESET} %s\n" "$*" >&2; }
step()  { printf "\n${C_CRIMSON}══ %s ══${C_RESET}\n" "$*"; }

# ─── Configuración ──────────────────────────────────────────────────────────
REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BACKUP_DIR="$HOME/.kurumi-desk-backup-$(date +%Y%m%d-%H%M%S)"
DRY_RUN=0
FORCE=0

# ─── Flags ──────────────────────────────────────────────────────────────────
usage() {
    cat <<EOF
Uso: $0 [opciones]

Opciones:
  -n, --dry-run    Muestra qué haría sin tocar nada
  -f, --force      No pregunta antes de sobrescribir
  -h, --help       Muestra esta ayuda

Instala el pack Tokisaki Kurumi en ~/. Detecta GNOME / Plasma / Hyprland.
EOF
}

while [[ $# -gt 0 ]]; do
    case "$1" in
        -n|--dry-run) DRY_RUN=1; shift ;;
        -f|--force)   FORCE=1; shift ;;
        -h|--help)    usage; exit 0 ;;
        *)            err "Opción desconocida: $1"; usage; exit 1 ;;
    esac
done

# ─── Helpers ────────────────────────────────────────────────────────────────
run() {
    if (( DRY_RUN )); then
        printf "${C_GREY}  [dry]${C_RESET} %s\n" "$*"
    else
        "$@"
    fi
}

backup_if_exists() {
    local target="$1"
    if [[ -e "$target" && ! -L "$target" ]]; then
        if (( ! FORCE )); then
            printf "${C_YELLOW}?${C_RESET} Existe %s. ¿Backup y reemplazar? [s/N] " "$target"
            read -r ans
            [[ "${ans,,}" != "s" ]] && { warn "Omitido: $target"; return 1; }
        fi
        mkdir -p "$BACKUP_DIR"
        local rel="${target#"$HOME"/}"
        local dest="$BACKUP_DIR/$rel"
        mkdir -p "$(dirname "$dest")"
        run cp -a "$target" "$dest"
        ok "Backup: $target → $dest"
    fi
    return 0
}

install_dir() {
    local src="$1" dst="$2"
    [[ ! -d "$src" ]] && { warn "No existe $src — salto"; return 0; }
    backup_if_exists "$dst" || return 0
    run mkdir -p "$(dirname "$dst")"
    run rm -rf "$dst"
    run cp -a "$src" "$dst"
    ok "$dst"
}

install_file() {
    local src="$1" dst="$2" mode="${3:-0644}"
    [[ ! -f "$src" ]] && { warn "No existe $src — salto"; return 0; }
    backup_if_exists "$dst" || return 0
    run mkdir -p "$(dirname "$dst")"
    run cp -a "$src" "$dst"
    run chmod "$mode" "$dst"
    ok "$dst"
}

# ─── Detección de entorno ───────────────────────────────────────────────────
detect_de() {
    local de=""
    if [[ -n "${XDG_CURRENT_DESKTOP:-}" ]]; then
        case "${XDG_CURRENT_DESKTOP,,}" in
            *gnome*)   de="gnome" ;;
            *kde*|*plasma*) de="plasma" ;;
            *hyprland*) de="hyprland" ;;
        esac
    fi
    # Fallback por procesos en ejecución
    if [[ -z "$de" ]]; then
        pgrep -x Hyprland     >/dev/null 2>&1 && de="hyprland"
        pgrep -x plasmashell  >/dev/null 2>&1 && de="plasma"
        pgrep -x gnome-shell  >/dev/null 2>&1 && de="gnome"
    fi
    echo "$de"
}

# ─── Cabecera ───────────────────────────────────────────────────────────────
clear
cat <<'BANNER'
   ╭─────────────────────────────────────────────╮
   │   🩸  k u r u m i - d e s k  🩸              │
   │   Tokisaki Kurumi theme pack                │
   │   GTK · GNOME Shell · Hyprland · Vim · 🎵   │
   ╰─────────────────────────────────────────────╯
BANNER

(( DRY_RUN )) && warn "Modo dry-run — no se escribirá nada"
(( FORCE ))   && warn "Modo force — sin preguntas"

DE="$(detect_de)"
info "Entorno detectado: ${DE:-desconocido}"
info "Backup (si hace falta) irá a: $BACKUP_DIR"

# ─── 1. GTK Themes ──────────────────────────────────────────────────────────
step "GTK themes (Zaphkiel / Zaphkiel-Dark)"
install_dir "$REPO_DIR/gtk/Zaphkiel"      "$HOME/.themes/Zaphkiel"
install_dir "$REPO_DIR/gtk/Zaphkiel-Dark" "$HOME/.themes/Zaphkiel-Dark"

# ─── 2. GTK4 / libadwaita user config ───────────────────────────────────────
step "GTK4 / libadwaita (config de usuario)"
run mkdir -p "$HOME/.config/gtk-4.0"
# El symlink lo gestiona zaphkiel-sync, aquí sólo nos aseguramos de que existe el directorio
if [[ -f "$HOME/.themes/Zaphkiel/gtk-4.0/gtk.css" ]]; then
    run ln -sf "$HOME/.themes/Zaphkiel/gtk-4.0/gtk.css" "$HOME/.config/gtk-4.0/gtk.css"
    ok "$HOME/.config/gtk-4.0/gtk.css → Zaphkiel (default)"
fi

# ─── 3. Sonidos ─────────────────────────────────────────────────────────────
step "Tema de sonido Moesound_iori"
install_dir "$REPO_DIR/sounds/Moesound_iori" "$HOME/.local/share/sounds/Moesound_iori"

# ─── 4. Vim colorscheme ─────────────────────────────────────────────────────
step "Vim colorscheme"
install_file "$REPO_DIR/vim/tokisaki_kurumi.vim" "$HOME/.vim/colors/tokisaki_kurumi.vim"

# ─── 5. Scripts ─────────────────────────────────────────────────────────────
step "Scripts (~/.local/bin)"
run mkdir -p "$HOME/.local/bin"
for s in "$REPO_DIR"/scripts/*.sh; do
    [[ -f "$s" ]] || continue
    install_file "$s" "$HOME/.local/bin/$(basename "$s")" 0755
done

# ─── 6. systemd user service ────────────────────────────────────────────────
step "systemd user service (zaphkiel-sync)"
if [[ -f "$REPO_DIR/systemd/user/zaphkiel-sync.service" ]]; then
    install_file "$REPO_DIR/systemd/user/zaphkiel-sync.service" \
                 "$HOME/.config/systemd/user/zaphkiel-sync.service"
    run systemctl --user daemon-reload
    if (( ! DRY_RUN )); then
        systemctl --user enable --now zaphkiel-sync.service 2>/dev/null \
            && ok "zaphkiel-sync.service activo" \
            || warn "No se pudo activar zaphkiel-sync (revísalo a mano)"
    fi
fi

# ─── 7. Configuración específica por entorno ────────────────────────────────
case "$DE" in
    gnome)
        step "GNOME — temas GTK, Shell y sonido"

        # Verificar extensión User Themes
        if ! gnome-extensions list --enabled 2>/dev/null | grep -q "user-theme@gnome-shell-extensions"; then
            warn "Extensión 'User Themes' no activa."
            warn "  Actívala:  gnome-extensions enable user-theme@gnome-shell-extensions.gcampax.github.com"
        fi

        if (( ! DRY_RUN )); then
            gsettings set org.gnome.desktop.interface gtk-theme "Zaphkiel"
            gsettings set org.gnome.desktop.interface color-scheme "prefer-light"
            gsettings set org.gnome.desktop.sound theme-name "Moesound_iori"
            gsettings set org.gnome.desktop.sound event-sounds true
            gsettings set org.gnome.shell.extensions.user-theme name "Zaphkiel" 2>/dev/null \
                || warn "No se pudo setear el tema de Shell (¿User Themes?)"
            ok "gsettings aplicados"
        else
            info "[dry] gsettings set gtk-theme/sound/user-theme"
        fi
        ;;

    plasma)
        step "Plasma — tema de sonido"
        info "Configura manualmente:"
        info "  · Apariencia → Sonidos del Sistema → Moesound_iori"
        info "  · Notificaciones → Sistema → login/logout → Reproducir sonido"
        info "  · Sonido → Volumen → reproducir sonido al cambiar volumen"
        ;;

    hyprland)
        step "Hyprland — copiando configs"
        install_dir "$REPO_DIR/hypr"    "$HOME/.config/hypr"
        install_dir "$REPO_DIR/waybar"  "$HOME/.config/waybar"
        install_dir "$REPO_DIR/swaync"  "$HOME/.config/swaync"

        # Aviso sobre el script de sonido de SwayNC
        if [[ -f "$HOME/.config/swaync/sounds.sh" ]]; then
            run chmod +x "$HOME/.config/swaync/sounds.sh"
            ok "swaync/sounds.sh ejecutable"
        fi
        ;;

    *)
        warn "Entorno desconocido. Los archivos se han instalado,"
        warn "pero tendrás que aplicar los temas a mano."
        ;;
esac

# ─── 8. GIFs (opcional, sólo se copian si el usuario quiere) ────────────────
if [[ -d "$REPO_DIR/gifs" ]]; then
    step "GIFs de bloqueo (opcional)"
    printf "${C_YELLOW}?${C_RESET} ¿Copiar GIFs a ~/.config/hypr/lock_frames? [s/N] "
    read -r ans
    if [[ "${ans,,}" == "s" ]]; then
        run mkdir -p "$HOME/.config/hypr/lock_frames"
        run cp -a "$REPO_DIR/gifs/." "$HOME/.config/hypr/lock_frames/"
        ok "GIFs copiados"
    else
        info "GIFs omitidos"
    fi
fi

# ─── 9. Backup final (si hicimos alguno) ────────────────────────────────────
if [[ -d "$BACKUP_DIR" ]]; then
    step "Backup"
    ok "Tus archivos anteriores: $BACKUP_DIR"
fi

# ─── 10. Resumen y siguientes pasos ─────────────────────────────────────────
cat <<EOF

${C_CRIMSON}══ Hecho ══${C_RESET}

$( [[ "$DE" == "gnome"    ]] && echo "GNOME  → Cierra sesión o Alt+F2 → r para aplicar el tema Shell." )
$( [[ "$DE" == "hyprland" ]] && echo "Hyprland → Recarga: hyprctl reload" )
$( [[ "$DE" == "plasma"   ]] && echo "Plasma → Aplica el tema desde Preferencias." )

Notas:
  · Los sonidos de evento se aplican a pestañas NUEVAS de apps GTK3.
  · El tema Shell de GNOME cambia tras relogin (Wayland) o Alt+F2 r (X11).
  · Si algo falla: backup en $BACKUP_DIR

¿Dudas? Lee el README.md o la guía en docs/.

EOF

ok "Instalación completada 🩸"
