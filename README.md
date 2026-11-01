# SENTINEL-SENTRY

A home-built apartment patrol robot running ROS 2 Jazzy on a Raspberry Pi 5.

The goal: a robot that drives itself around the apartment, notices things with its camera, logs what it saw, and returns to its charger when the battery runs low.

## Marks

| Mark | Status | What it is |
|------|--------|------------|
| **MK0** | ✅ Built | Stationary test rig: Pi 5 + LD19 lidar publishing `/scan`, viewable from the PC |
| **MK1** | 🛠 In progress | First driving robot: 2 encoder motors, Pico motor controller, battery power |
| MK2+ | Planned | Camera, charging dock, patrol + sighting log |

## What runs on the robot (MK0)

ROS 2 Jazzy has no packages for the Pi's Debian 13, so everything runs in Docker. One image (`sentinel-ros:jazzy`) and three services:

| Service | What it does | Port |
|---------|--------------|------|
| `lidar` | LD19 driver (`ldlidar_stl_ros2`) → `/scan` at 10 Hz, frame `laser` | - |
| `foxglove` | Foxglove bridge, for viewing in Lichtblick | 8765 |
| `rosbridge` | rosbridge + rosapi, for the `ros-mcp` AI server | 9091 (9090 is Cockpit) |

All services use host networking and `ipc: host`, and restart automatically (`unless-stopped`).

## Repository layout

```
robot/
  Dockerfile           ROS image: ros:jazzy-ros-base + LD19 driver + bridges
  entrypoint.sh        Sources ROS before running a command
  compose.yaml         The three services above
  scripts/
    lidar-power.sh     lidar-power on|off|status (Pi 5 USB power switch)
    install-udev.sh    Installs the /dev/ldlidar rule
  udev/
    99-ldlidar.rules   Names the lidar's USB-serial adapter /dev/ldlidar
docs/
  parts-list.md        What's built and what MK1 needs
```

## Setting up a fresh Pi

On the robot's Raspberry Pi 5 (Docker installed, user in the `docker` and `dialout` groups):

```bash
git clone https://github.com/JamilCPU/SENTINEL-SENTRY.git
cd SENTINEL-SENTRY/robot
sudo ./scripts/install-udev.sh
docker build -t sentinel-ros:jazzy .
docker compose up -d
```

Lidar power switch (needs `sudo apt install uhubctl`):

```bash
sudo ln -sf "$PWD/scripts/lidar-power.sh" /usr/local/bin/lidar-power
lidar-power status
```

> The live Pi currently runs these files from `~/sentinel-ros`. `lidar-power.sh` expects the compose file there.

## Viewing and talking to the robot

- **Lichtblick** (open-source Foxglove viewer) → *Open connection* → *Foxglove WebSocket* → `ws://192.0.2.102:8765`
- **Claude + ros-mcp-server** → "connect to the robot at 192.0.2.102 port 9091"

## Gotchas learned

- `ldlidar_stl_ros2` doesn't compile on Jazzy (GCC 13) without `#include <pthread.h>` in `log_module.cpp`; the Dockerfile patches it.
- ROS nodes in separate containers on the same machine need `ipc: host`. Otherwise Fast DDS discovery works but no data arrives.
- `foxglove_bridge` 3.x only accepts the `foxglove.sdk.v1` WebSocket subprotocol.
- On the Pi 5, USB power only drops when **all four** ports are switched off, so `lidar-power off` cuts every USB device.
