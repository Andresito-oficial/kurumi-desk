#!/bin/bash
# Obtiene el brillo actual en porcentaje
brightnessctl -m | cut -d, -f4 | tr -d '%'

