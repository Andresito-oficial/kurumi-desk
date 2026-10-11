#!/usr/bin/env python3
"""
hypr-sound-daemon.py
Daemon unificado de sonidos para Hyprland, basado en libcanberra (KDE/Plasma).

Escucha:
  1. Notificaciones de escritorio (D-Bus: org.freedesktop.Notifications)
  2. Eventos del socket IPC de Hyprland (.socket2.sock): ventanas, workspaces, campana
  3. Eventos de sesión (login/logout) mediante llamadas explícitas

Reproduce sonidos usando canberra-gtk-play, que busca automáticamente
los archivos .ogg en el tema de sonido activo (Moosound.iori).
"""

import asyncio
import json
import logging
import os
import subprocess
import sys
from pathlib import Path

from dbus_next.aio import MessageBus
from dbus_next.constants import BusType, MessageType
from dbus_next import Message, Variant

# ---------------------------------------------------------------------------
# Configuración
# ---------------------------------------------------------------------------

CONFIG_DIR = Path.home() / ".config" / "hypr"
SOUND_MAP_FILE = CONFIG_DIR / "sound-map.json"

logging.basicConfig(
    level=logging.INFO,
    format="%(asctime)s [%(levelname)s] %(message)s",
    datefmt="%H:%M:%S",
)
log = logging.getLogger("hypr-sound-daemon")

# ---------------------------------------------------------------------------
# Carga del mapa de sonidos
# ---------------------------------------------------------------------------

def load_sound_map() -> dict:
    """Carga el mapa de eventos desde el archivo JSON."""
    if not SOUND_MAP_FILE.exists():
        log.warning("No se encontró %s, usando mapa por defecto.", SOUND_MAP_FILE)
        return {
            "hyprland_events": {},
            "notification_sounds": {},
            "default_notification_sound": "message-new-instant",
            "default_hyprland_sound": "button-pressed",
        }
    with open(SOUND_MAP_FILE, "r", encoding="utf-8") as f:
        return json.load(f)

SOUND_MAP = load_sound_map()

# ---------------------------------------------------------------------------
# Motor de sonido (libcanberra)
# ---------------------------------------------------------------------------

def play_xdg_sound(event_id: str) -> None:
    """
    Reproduce un sonido por su ID XDG usando canberra-gtk-play.
    libcanberra buscará el archivo en el tema de sonido activo.
    """
    if not event_id:
        return
    try:
        subprocess.Popen(
            ["canberra-gtk-play", "--id", event_id],
            stdout=subprocess.DEVNULL,
            stderr=subprocess.DEVNULL,
        )
        log.debug("Reproduciendo sonido: %s", event_id)
    except FileNotFoundError:
        log.error("canberra-gtk-play no encontrado. Instala libcanberra-gtk3.")
    except Exception as e:
        log.error("Error reproduciendo '%s': %s", event_id, e)


def play_notification_sound(hints: dict, app_name: str) -> None:
    """
    Reproduce el sonido adecuado para una notificación.
    Prioridad:
      1. Hint 'sound-name' enviado por la aplicación.
      2. Hint 'sound-file' (ruta directa a un archivo).
      3. Mapa personalizado por app_name.
      4. Sonido por defecto.
    """
    # 1. sound-name (nombre XDG del sonido)
    sound_name = hints.get("sound-name")
    if sound_name and isinstance(sound_name, Variant):
        sound_name = sound_name.value
    if sound_name:
        play_xdg_sound(sound_name)
        return

    # 2. sound-file (ruta a un archivo específico)
    sound_file = hints.get("sound-file")
    if sound_file and isinstance(sound_file, Variant):
        sound_file = sound_file.value
    if sound_file and os.path.isfile(sound_file):
        try:
            subprocess.Popen(
                ["canberra-gtk-play", "--file", sound_file],
                stdout=subprocess.DEVNULL,
                stderr=subprocess.DEVNULL,
            )
            log.debug("Reproduciendo archivo: %s", sound_file)
            return
        except Exception as e:
            log.error("Error reproduciendo archivo '%s': %s", sound_file, e)

    # 3. Mapa personalizado por aplicación
    notif_map = SOUND_MAP.get("notification_sounds", {})
    mapped = notif_map.get(app_name)
    if mapped:
        play_xdg_sound(mapped)
        return

    # 4. Sonido por defecto
    default = SOUND_MAP.get("default_notification_sound", "message-new-instant")
    play_xdg_sound(default)


# ---------------------------------------------------------------------------
# Módulo 1: Escucha de notificaciones D-Bus
# ---------------------------------------------------------------------------

NOTIF_SERVICE = "org.freedesktop.Notifications"
NOTIF_PATH = "/org/freedesktop/Notifications"
NOTIF_INTERFACE = "org.freedesktop.Notifications"


def _variant_to_value(v):
    """Convierte un Variant de dbus-next a su valor Python nativo."""
    if isinstance(v, Variant):
        return v.value
    return v


def notification_message_handler(message: Message) -> None:
    """Procesa mensajes D-Bus de la interfaz de notificaciones."""
    if message.interface != NOTIF_INTERFACE:
        return
    if message.message_type != MessageType.METHOD_CALL:
        return
    if message.member != "Notify":
        return

    # Argumentos de Notify:
    # (app_name, replaces_id, app_icon, summary, body, actions, hints, expire_timeout)
    try:
        body = message.body
        app_name = _variant_to_value(body[0]) if len(body) > 0 else "unknown"
        hints_raw = _variant_to_value(body[6]) if len(body) > 6 else {}

        # Convertir el diccionario de hints a valores nativos
        hints = {}
        if isinstance(hints_raw, dict):
            for k, v in hints_raw.items():
                hints[k] = _variant_to_value(v)

        log.info("Notificación de '%s' | hints: %s", app_name, list(hints.keys()))
        play_notification_sound(hints, app_name)
    except Exception as e:
        log.error("Error procesando notificación: %s", e)


async def dbus_listener() -> None:
    """Conecta al bus de sesión y escucha notificaciones."""
    try:
        bus = await MessageBus(bus_type=BusType.SESSION).connect()
        bus.add_message_handler(notification_message_handler)
        log.info("Escuchando notificaciones D-Bus...")
        await bus.wait_for_disconnect()
    except Exception as e:
        log.error("Error en el listener D-Bus: %s", e)


# ---------------------------------------------------------------------------
# Módulo 2: Escucha de eventos de Hyprland (socket2)
# ---------------------------------------------------------------------------

def get_hyprland_socket_path() -> str | None:
    """Obtiene la ruta del socket de eventos de Hyprland."""
    sig = os.environ.get("HYPRLAND_INSTANCE_SIGNATURE")
    runtime = os.environ.get("XDG_RUNTIME_DIR", f"/run/user/{os.getuid()}")
    if sig:
        path = f"{runtime}/hypr/{sig}/.socket2.sock"
        if os.path.exists(path):
            return path
    # Fallback: buscar en /tmp/hypr
    for entry in Path("/tmp/hypr").glob("*/.socket2.sock"):
        return str(entry)
    return None


async def hyprland_event_listener() -> None:
    """
    Conecta al socket de eventos de Hyprland y procesa cada línea.
    Formato: EVENT>>DATA\n
    """
    socket_path = get_hyprland_socket_path()
    if not socket_path:
        log.error("No se encontró el socket de eventos de Hyprland. "
                  "¿Estás ejecutando el daemon dentro de una sesión de Hyprland?")
        return

    log.info("Escuchando eventos de Hyprland en %s", socket_path)

    hypr_map = SOUND_MAP.get("hyprland_events", {})
    default_sound = SOUND_MAP.get("default_hyprland_sound", "button-pressed")

    while True:
        try:
            reader, _ = await asyncio.open_unix_connection(socket_path)
            while True:
                line = await reader.readline()
                if not line:
                    break
                line = line.decode("utf-8", errors="replace").strip()
                if not line:
                    continue

                # Formato: EVENT>>DATA
                if ">>" not in line:
                    continue
                event_name, event_data = line.split(">>", 1)
                event_name = event_name.strip()

                log.debug("Evento Hyprland: %s | data: %s", event_name, event_data[:80])

                # Buscar en el mapa; si no, usar el sonido por defecto
                sound_id = hypr_map.get(event_name, default_sound)
                if sound_id:
                    play_xdg_sound(sound_id)

        except asyncio.CancelledError:
            log.info("Listener de Hyprland cancelado.")
            return
        except FileNotFoundError:
            log.error("Socket de Hyprland no encontrado en %s. Reintentando...", socket_path)
        except ConnectionResetError:
            log.warning("Conexión con Hyprland reiniciada. Reconectando...")
        except Exception as e:
            log.error("Error en el listener de Hyprland: %s", e)

        await asyncio.sleep(3)  # Esperar antes de reintentar


# ---------------------------------------------------------------------------
# Módulo 3: Eventos de sesión (login / logout)
# ---------------------------------------------------------------------------

def play_session_sound(event_id: str) -> None:
    """Reproduce un sonido de sesión (login, logout, etc.)."""
    play_xdg_sound(event_id)


# ---------------------------------------------------------------------------
# Bucle principal
# ---------------------------------------------------------------------------

async def main() -> None:
    log.info("Iniciando hypr-sound-daemon...")

    # Reproducir sonido de login al arrancar (si se desea)
    # play_session_sound("desktop-login")

    await asyncio.gather(
        dbus_listener(),
        hyprland_event_listener(),
    )


if __name__ == "__main__":
    try:
        asyncio.run(main())
    except KeyboardInterrupt:
        log.info("Daemon detenido por el usuario.")
        sys.exit(0)
