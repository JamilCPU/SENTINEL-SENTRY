#!/usr/bin/env bash
# install-udev.sh - install the udev rule that names the LD19 lidar /dev/ldlidar.
# Run once on the robot's Pi: sudo ./install-udev.sh
set -euo pipefail

RULE_SRC="$(cd "$(dirname "$0")/../udev" && pwd)/99-ldlidar.rules"
RULE_DST=/etc/udev/rules.d/99-ldlidar.rules

if [ "$(id -u)" -ne 0 ]; then
  echo "Run with sudo: sudo $0" >&2
  exit 1
fi

install -m 0644 "$RULE_SRC" "$RULE_DST"
udevadm control --reload-rules
udevadm trigger --subsystem-match=tty
echo "Installed $RULE_DST. Plug in the lidar and check: ls -l /dev/ldlidar"
