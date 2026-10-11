#!/bin/bash
# ~/.config/hypr/scripts/logout-sound.sh
# Reproduce el sonido de logout y luego cierra Hyprland.

# Sonido de logout (bloqueante: espera a que termine)
canberra-gtk-play --id desktop-logout

# Pequeña pausa por si el sonido tiene cola
sleep 0.3

# Cerrar Hyprland
hyprctl dispatch exit
