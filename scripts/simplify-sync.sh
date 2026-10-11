#!/bin/bash
# simplify-sync.sh — reduce zaphkiel-sync a extras

set -e

SCRIPT="$HOME/.local/bin/zaphkiel-sync.sh"
cp "$SCRIPT" "$SCRIPT.bak-$(date +%Y%m%d-%H%M%S)"

cat > "$SCRIPT" << 'EOF'
#!/bin/bash
# zaphkiel-sync.sh — Extras que GNOME no hace solo
# (GTK/Shell/iconos auto-cambian con color-scheme)

LIGHT_MODE="Kurumi"
DARK_MODE="Nightmare"

LIVE_LOCK_SCHEMA="$HOME/.local/share/gnome-shell/extensions/live-lockscreen@nick-redwill/schemas"
GIF_DAY="$HOME/Vídeos/Wallpaper/kurumi-day.gif"
GIF_NIGHT="$HOME/Vídeos/Wallpaper/kurumi-nightmare.gif"

HYPER_LIGHT="7a8c3e21-4b5f-4d9a-8e2c-1f6b3a9d7c04"
HYPER_DARK="9d2f6b14-7e3a-4c81-b5d2-8a1e4c7f9035"

apply_extras() {
    local mode="$1"
    echo "[$(date)] Extras → $mode"

    echo "$mode" > /tmp/kurumi_mode

    # Hyper Doki
    local hyper_cfg="$HOME/.doki-theme-hyper-config/.hyper.doki.config.json"
    if [ -f "$hyper_cfg" ] && command -v jq >/dev/null 2>&1; then
        if [ "$mode" = "$DARK_MODE" ]; then
            jq --arg id "$HYPER_DARK" '.themeId = $id' "$hyper_cfg" > "$hyper_cfg.tmp" && mv "$hyper_cfg.tmp" "$hyper_cfg"
        else
            jq --arg id "$HYPER_LIGHT" '.themeId = $id' "$hyper_cfg" > "$hyper_cfg.tmp" && mv "$hyper_cfg.tmp" "$hyper_cfg"
        fi
    fi

    # GIF lock screen
    if [ -d "$LIVE_LOCK_SCHEMA" ]; then
        if [ "$mode" = "$DARK_MODE" ] && [ -f "$GIF_NIGHT" ]; then
            GSETTINGS_SCHEMA_DIR="$LIVE_LOCK_SCHEMA" gsettings set org.gnome.shell.extensions.live-lockscreen background-video-path "$GIF_NIGHT"
        elif [ "$mode" = "$LIGHT_MODE" ] && [ -f "$GIF_DAY" ]; then
            GSETTINGS_SCHEMA_DIR="$LIVE_LOCK_SCHEMA" gsettings set org.gnome.shell.extensions.live-lockscreen background-video-path "$GIF_DAY"
        fi
    fi

    # Opera GX
    if pgrep -f "opera-gx" > /dev/null && [ -x "$HOME/.local/bin/opera-theme.sh" ]; then
        [ "$mode" = "$DARK_MODE" ] && "$HOME/.local/bin/opera-theme.sh" dark & || "$HOME/.local/bin/opera-theme.sh" light &
    fi
}

current=$(gsettings get org.gnome.desktop.interface color-scheme)
[[ "$current" == *"dark"* ]] && apply_extras "$DARK_MODE" || apply_extras "$LIGHT_MODE"

LAST=""
while true; do
    current=$(gsettings get org.gnome.desktop.interface color-scheme 2>/dev/null)
    if [ "$current" != "$LAST" ]; then
        LAST="$current"
        [[ "$current" == *"dark"* ]] && apply_extras "$DARK_MODE" || apply_extras "$LIGHT_MODE"
    fi
    sleep 2
done
EOF

chmod +x "$SCRIPT"
systemctl --user restart zaphkiel-sync.service
echo "✅ Listo"
