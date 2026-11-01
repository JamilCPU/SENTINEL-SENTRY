# Parts list

## MK0 - stationary test rig (built)

| Part | Notes |
|------|-------|
| Raspberry Pi 5 (8 GB) - "Pi2" | Debian 13 (trixie), 192.0.2.102 |
| FHL-LD19 lidar (LDROBOT LD19) | 12 m, 360°, CP2102 USB-serial adapter, 230400 baud |

## MK1 - first driving robot (in progress)

**Have:**

| Part | Notes |
|------|-------|
| 2× JGB37-520 geared DC motors, 12 V, 178 rpm | Built-in Hall encoders (6 wires: M1, M2, VCC, GND, A, B), one wheel each |

**To buy:**

| Part | Why |
|------|-----|
| Dual-channel motor driver (Cytron MDD3A or MDD10A) | Switches battery power to the motors on command. Not L298N / TB6612 |
| Raspberry Pi Pico H + micro-USB **data** cable | Counts encoder pulses, keeps wheel speeds matched (PID), stops motors if Pi goes quiet |
| 3S 18650 Li-ion pack (11.1 V, ~5000-6000 mAh) with BMS + 12.6 V charger | Powers everything |
| 12 V → 5 V 5 A buck converter (USB-C out) | Powers the Pi 5 from the battery |
| Ball or swivel caster | Third wheel; swivel is better on carpet |
| 2× 37 mm motor brackets | Skip if included with the motors |
| Base plate (~250 × 200 mm) | The chassis |
| 10 A rocker switch, inline blade fuse holder + 7.5/10 A fuses | Power on/off and short-circuit protection |
| 18 AWG silicone wire, Dupont jumpers, Wago 221 connectors, M3 standoffs, zip ties, Velcro | Wiring and mounting |

**Later:** BNO085 IMU (better turning accuracy), INA219 battery monitor (for return-to-dock).
