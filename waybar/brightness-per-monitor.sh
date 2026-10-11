#!/usr/bin/env bash
# brightness-per-monitor.sh
# Control de brillo por hardware para Hyprland + Waybar (scroll)
# Monitores conocidos con buses hardcodeados (setup fijo)

set -euo pipefail

# ─── CONFIGURACIÓN ──────────────────────────────────────────────
STEP=5
DDCUTIL_OPTS=(--sleep-multiplier 0.1)

# Mapeo monitor (Hyprland) → bus I²C (hardcodeado, setup fijo)
#   HDMI-A-1  → HP P27q G4   (bus 1)
#   DP-5      → Kamvas 13    (bus 15)
# Si cambias un cable de puerto, actualiza esta tabla.
declare -A BUSES=(
    ["HDMI-A-1"]="1"
    ["DP-5"]="15"
)

# ─── UTILIDADES ─────────────────────────────────────────────────

get_focused_monitor() {
    hyprctl monitors -j | jq -r '.[] | select(.focused == true) | .name'
}

get_brightness() {
    local bus="$1"
    ddcutil --bus "$bus" "${DDCUTIL_OPTS[@]}" getvcp 10 --terse 2>/dev/null \
        | awk '{print $4}'
}

set_brightness() {
    local bus="$1"
    local value="$2"

    (( value < 0 ))   && value=0
    (( value > 100 )) && value=100

    ddcutil --bus "$bus" "${DDCUTIL_OPTS[@]}" setvcp 10 "$value" &>/dev/null &
}

# ─── LÓGICA PRINCIPAL ───────────────────────────────────────────

main() {
    local action="${1:-get}"
    local monitor_name
    monitor_name=$(get_focused_monitor)

    # ─── Panel interno (eDP-1) → brightnessctl ───────────────────
    if [[ "$monitor_name" == "eDP-1" ]]; then
        case "$action" in
            up)   brightnessctl set "${STEP}%+" -q ;;
            down) brightnessctl set "${STEP}%-" -q ;;
            get)  brightnessctl -m | cut -d, -f4 | tr -d '%' ;;
        esac
        exit 0
    fi

    # ─── Monitor externo → ddcutil ───────────────────────────────
    local bus="${BUSES[$monitor_name]:-}"

    if [[ -z "$bus" ]]; then
        # Monitor no listado en la tabla (Huion, temporal, etc.)
        [[ "$action" == "get" ]] && echo "N/A"
        exit 0
    fi

    local current new
    current=$(get_brightness "$bus")

    case "$action" in
        up)
            new=$(( current + STEP ))
            set_brightness "$bus" "$new"
            ;;
        down)
            new=$(( current - STEP ))
            set_brightness "$bus" "$new"
            ;;
        get)
            echo "$current"
            ;;
        *)
            echo "Uso: $0 {up|down|get}" >&2
            exit 1
            ;;
    esac
}

main "$@"
