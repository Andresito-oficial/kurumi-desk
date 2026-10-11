#!/bin/bash
# 1. Llamamos a tu script original para capturar el porcentaje numérico
PORCENTAJE=$(~/.config/hypr/scripts/brightness.sh)

# 2. Le pasamos ese número exacto a la Kamvas 13 de forma nativa en enteros (0-100)
kscreen-doctor output.HDMI-A-1.brightness."$PORCENTAJE" &

