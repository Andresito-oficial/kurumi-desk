# Zaphkiel — Sonidos y GIFs de bloqueo
# Guía unificada · GNOME 46/51 · Plasma 6 · Hyprland + SwayNC

═══════════════════════════════════════════════════════════════
 PARTE 1 — TEMA DE SONIDO Moesound_iori
═══════════════════════════════════════════════════════════════

## 1.1 — Colocar el tema

Los tres entornos leen el mismo tema desde la ruta de usuario.

  mkdir -p ~/.local/share/sounds
  # Copia aquí la carpeta Moesound_iori (con su subcarpeta stereo/)
  # Estructura final:
  #   ~/.local/share/sounds/Moesound_iori/
  #   ├── index.theme
  #   └── stereo/
  #       ├── button-pressed.ogg
  #       ├── dialog-error.ogg
  #       ├── message-new-instant.ogg
  #       └── ...

## 1.2 — Crear el index.theme (si falta)

  cat > ~/.local/share/sounds/Moesound_iori/index.theme << 'EOF'
  [Sound Theme]
  Name=Moesound_iori
  Inherits=freedesktop
  Directories=stereo
  EOF

## 1.3 — Probar que suena

  canberra-gtk-play -i message-new-instant
  canberra-gtk-play -i button-pressed
  canberra-gtk-play -i dialog-error

Si los tres suenan, el tema está bien instalado.

───────────────────────────────────────────────────────────────
 1.4 — GNOME (46, 51)
───────────────────────────────────────────────────────────────

  gsettings set org.gnome.desktop.sound theme-name 'Moesound_iori'
  gsettings set org.gnome.desktop.sound event-sounds true

Verificar:
  gsettings get org.gnome.desktop.sound theme-name

Recargar el daemon (sin sudo):
  killall gsd-media-keys 2>/dev/null
  nohup /usr/libexec/gsd-media-keys >/dev/null 2>&1 &

Qué suena en GNOME 46/51 (según experiencia real):
  ✅ Cerrar ventanas / apps
  ✅ Errores del sistema
  ✅ Notificaciones de apps
  ✅ Botones / clicks
  ✅ Teclas (input-feedback)
  ❌ Login / logout        (eliminado de gnome-shell)
  ❌ Subir/bajar volumen   (eliminado de gsd-media-keys)
  ❌ Abrir/cerrar menús    (eliminado desde GNOME 3.38)

Si quieres login sound: systemd user service aparte (no nativo).
  ~/.config/systemd/user/login-sound.service
  ─────────────────────────────────────────
  [Unit]
  Description=Login sound
  [Service]
  Type=oneshot
  ExecStart=/usr/bin/paplay %h/.local/share/sounds/Moesound_iori/stereo/desktop-login.ogg
  [Install]
  WantedBy=default.target
  ─────────────────────────────────────────

  systemctl --user daemon-reload
  systemctl --user enable login-sound.service

Nota: suena al arrancar servicios de usuario, no al mostrar el
escritorio. No es equivalente al login sound nativo de Plasma.

───────────────────────────────────────────────────────────────
 1.5 — Plasma 6
───────────────────────────────────────────────────────────────

Plasma usa Phonon, no libcanberra. Lee directamente de
~/.local/share/sounds/ y respeta el index.theme.

GUI:
  Preferencias del Sistema → Apariencia → Sonidos del Sistema
  → Seleccionar "Moesound_iori"

Por aplicación (notificaciones granulares):
  Preferencias del Sistema → Notificaciones
  → Seleccionar app (ej. Thunderbird) → Configurar Eventos
  → Marcar "Reproducir un sonido" y elegir el .ogg concreto

Login / Logout:
  Preferencias del Sistema → Notificaciones
  → "Sistema" / "KDE Workspace" → Configurar Eventos
  → "Inicio de sesión" / "Cierre de sesión"
  → Marcar "Reproducir un sonido"

Volumen:
  Preferencias del Sistema → Sonido → Volumen
  → "Reproducir sonido al cambiar el volumen"
  → Seleccionar el .ogg

Si el login no suena:
  systemctl --user enable --now pipewire.service

───────────────────────────────────────────────────────────────
 1.6 — Hyprland + SwayNC
───────────────────────────────────────────────────────────────

SwayNC no reproduce sonidos por defecto. Se usan scripts.

Paso 1: Script de sonido
  ~/.config/swaync/sounds.sh
  ─────────────────────────────────────────
  #!/bin/bash
  SOUND="$HOME/.local/share/sounds/Moesound_iori/stereo/message-new-instant.ogg"
  [ -f "$SOUND" ] && paplay "$SOUND"
  ─────────────────────────────────────────

  chmod +x ~/.config/swaync/sounds.sh

Paso 2: Enganchar en config.json
  ~/.config/swaync/config.json → añadir bloque:
  ─────────────────────────────────────────
  {
    "scripts": {
      "notification-sound": {
        "exec": "/home/TU_USUARIO/.config/swaync/sounds.sh",
        "app-name": ".*"
      }
    }
  }
  ─────────────────────────────────────────

  "app-name": ".*" → cualquier notificación dispara el script.

Paso 3: Recargar
  swaync-client -rs

Si usas mako en lugar de swaync:
  ~/.config/mako/config:
    on-notify=exec paplay ~/.local/share/sounds/Moesound_iori/stereo/message-new-instant.ogg

Si usas dunst:
  ~/.config/dunst/dunstrc:
    [urgency_normal]
        sound = ~/.local/share/sounds/Moesound_iori/stereo/message-new-instant.ogg

═══════════════════════════════════════════════════════════════
 PARTE 2 — GIFs EN PANTALLA DE BLOQUEO
═══════════════════════════════════════════════════════════════

## 2.1 — Hyprland (hyprlock) — ya funcional, referencia

hyprlock NO soporta GIFs nativos. Se simula con reload_cmd.

  ~/.config/hypr/lock-reload.sh:
  ─────────────────────────────────────────
  #!/bin/bash
  FRAME_DIR="$HOME/.config/hypr/lock_frames"
  find "$FRAME_DIR" -type f -iname "*.png" | shuf -n 1
  ─────────────────────────────────────────

  chmod +x ~/.config/hypr/lock-reload.sh

  ~/.config/hypr/hyprlock.conf:
  ─────────────────────────────────────────
  background {
      monitor =
      path = $HOME/.config/hypr/lock_frames/frame_01.png
      reload_cmd = $HOME/.config/hypr/lock-reload.sh
      reload_time = 0.2
      crossfade_time = 0.1
  }
  ─────────────────────────────────────────

───────────────────────────────────────────────────────────────
 2.2 — GNOME (46 / 51) — extensión Live Lock Screen
───────────────────────────────────────────────────────────────

Extensión: Live Lock Screen
  https://extensions.gnome.org/extension/9419/live-lock-screen/

Instalación:
  Opción A — desde la web (recomendado)
    1. Instala "GNOME Shell integration" en el navegador.
    2. Abre la URL y pulsa Install.

  Opción B — manual
    mkdir -p ~/.local/share/gnome-shell/extensions
    cp ~/Descargas/live-lock-screen@nick-redwill.github.io.zip \
       ~/.local/share/gnome-shell/extensions/
    cd ~/.local/share/gnome-shell/extensions
    unzip live-lock-screen@nick-redwill.github.io.zip
    rm live-lock-screen@nick-redwill.github.io.zip

Requisito: GStreamer o mpv
  sudo apt install gstreamer1.0-plugins-good gstreamer1.0-plugins-bad
  # (o mpv, según qué backend use la extensión)

Activar:
  gnome-extensions enable live-lock-screen@nick-redwill.github.io

Preferencias:
  gnome-extensions prefs live-lock-screen@nick-redwill.github.io
  → Seleccionar el GIF
  → Modo de escalado: fill / fit / stretch
  → Opciones: desenfoque, escala de grises, silenciar audio

Probar:
  Super + L

───────────────────────────────────────────────────────────────
 2.3 — Alternativas si Live Lock Screen falla en GNOME 51
───────────────────────────────────────────────────────────────

Idlescape (recomendado si el anterior falla)
  https://extensions.gnome.org/extension/5615/idlescape/
  - Usa mpv, optimizado para Wayland
  - Actúa como salvapantallas tras inactividad

Video Wallpaper & Screensaver
  https://extensions.gnome.org/extension/8610/video-wallpaper-screensaver/
  - Enfocado a fondo de escritorio, incluye modo salvapantallas

═══════════════════════════════════════════════════════════════
 NOTAS FINALES
═══════════════════════════════════════════════════════════════

- El tema de sonido es COMPARTIDO entre GNOME, Plasma y Hyprland
  porque los tres leen ~/.local/share/sounds/. No dupliques archivos.

- Los eventos que suenan dependen del ENTORNO, no del tema:
    GNOME  : cerrando, errores, notis, botones, teclas
    Plasma : todo (incluido login/logout y volumen)
    Hyprland: lo que configures en SwayNC + scripts propios

- GNOME 51 NO reproduce login/logout ni cambio de volumen.
  Es decisión de diseño del equipo de GNOME, no configurable.

- Los GIFs en pantalla de bloqueo consumen CPU/GPU. Si notas
  que el ventilador se acelera o la batería baja rápido,
  reduce la resolución o los FPS del GIF.

- Backup de todo esto (por si cambias de torre):
    tar czf ~/zaphkiel-sonido-gifs.tar.gz \
        ~/.local/share/sounds/Moesound_iori \
        ~/.config/swaync \
        ~/.config/mako \
        ~/.config/dunst \
        ~/.config/hypr/lock-reload.sh \
        ~/.config/hypr/lock_frames \
        ~/.config/systemd/user/login-sound.service
    cp ~/zaphkiel-sonido-gifs.tar.gz ~/OneDrive/
