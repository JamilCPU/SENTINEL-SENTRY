#!/usr/bin/env bash
# lidar-power on|off|status - switch the LD19 lidar's power via the Pi 5 USB ports.
# On the Pi 5, USB 5V only drops when ALL four ports are off, so this cuts every
# USB device (including the Pico once it's plugged in). Ports power back on at reboot.
set -euo pipefail

# compose.yaml lives one level up from this script (resolves the /usr/local/bin symlink).
COMPOSE_DIR="$(cd "$(dirname "$(readlink -f "$0")")/.." && pwd)"
HUBS=(1 2 3 4)
DEVICE=/dev/ldlidar

set_ports() {
  for hub in "${HUBS[@]}"; do
    sudo /usr/sbin/uhubctl -l "$hub" -a "$1" >/dev/null
  done
}

case "${1:-status}" in
  off)
    docker compose -f "$COMPOSE_DIR/compose.yaml" stop lidar
    set_ports off
    echo "Lidar powered off (all USB ports off)."
    ;;
  on)
    set_ports on
    for _ in $(seq 1 20); do
      [ -e "$DEVICE" ] && break
      sleep 0.5
    done
    if [ ! -e "$DEVICE" ]; then
      echo "Error: $DEVICE did not appear after power-on. Is the lidar plugged in?" >&2
      exit 1
    fi
    docker compose -f "$COMPOSE_DIR/compose.yaml" up -d lidar
    echo "Lidar powered on; driver started."
    ;;
  status)
    if [ -e "$DEVICE" ]; then echo "Lidar: on ($DEVICE present)"; else echo "Lidar: off (no $DEVICE)"; fi
    docker compose -f "$COMPOSE_DIR/compose.yaml" ps lidar --format "Driver: {{.Status}}"
    ;;
  *)
    echo "Usage: lidar-power on|off|status" >&2
    exit 2
    ;;
esac
