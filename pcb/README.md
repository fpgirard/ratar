# Hardware

*RF-HAT — CC1101 ↔ XIAO ESP32-C6 carrier board*

| Component | Role |
|---|---|
| **Seeed XIAO ESP32-C6** | Main microcontroller. Chosen over the ESP32-S3 specifically for its **built-in ceramic antenna** — avoids needing an external antenna for the C6's own WiFi/BLE radio. Requires the **ESP-IDF** framework in ESPHome (Arduino isn't supported on this chip). |
| **CC1101 sub-GHz transceiver module** (8-pin breakout, SMA antenna connector) | The actual RF transceiver. Handles 300–928MHz, ASK/OOK and other modulations. Controlled entirely over SPI. |
| **Custom KiCad PCB ("RF-HAT")** | Carrier board connecting the CC1101 module's 8-pin header to the XIAO C6's pins, matching the wiring below. Designed and verified against this pinout table before fabrication. |
| **SMA antenna** (right-angle/elbow recommended) | Rated for the ~300MHz range being used — not all "SMA-compatible" antennas are tuned correctly for this band. An elbow connector is worth using if the antenna would otherwise sit close to and in-line with a noise source like a USB-C cable/connector, since it moves the radiating element further away and off-axis. |

## Pin assignments — CC1101 ↔ XIAO ESP32-C6 (final)

| CC1101 Pin # | Signal      | XIAO Pin | GPIO   | Notes |
|--------------|-------------|----------|--------|-------|
| 1            | GND         | GND      | -      | |
| 2            | VCC         | 3V3      | -      | 1.8-3.6V only - never 5V |
| 3            | GDO0        | D2       | GPIO2  | Wired to `remote_transmitter` (TX path) |
| 4            | CSN         | D3       | GPIO21 | SPI chip select |
| 5            | SCK         | D8       | GPIO19 | SPI clock |
| 6            | MOSI        | D10      | GPIO18 | SPI data in |
| 7            | MISO / GDO1 | D9       | GPIO20 | SPI data out (dual-purpose pin) |
| 8            | GDO2        | D1       | GPIO1  | Wired to `remote_receiver` (RX/capture path) |

All connections use clean, non-strapping GPIOs on the C6. 

**A note on the KiCad schematic**: when the RF-HAT board was designed, the CC1101 header (`J1`) was wired as a generic 8-pin connector with no net labels. If you're referencing or modifying the KiCad source, verify the physical pin-to-signal mapping against the table above (and against how the CC1101 module actually plugs into the header) before trusting the schematic alone — run KiCad's ERC and pull the netlist to catch any wiring mismatches (a GND/VCC short was caught this way during this build) rather than relying on manual trace-reading. 

## Manufacturing
If you're thinking of using PCBWay, the file RF-HAT.kicad_pcb.zip can be uploaded directly.  Making 5 PCBs is the same cost ($5) as making 10 ($5) since you will be sub-100mm x 100mm.


## Directory contents

- `RF-HAT/` — the KiCad project: schematic, PCB layout, and fab-ready
  gerbers/drill files (`RF-HAT.kicad_pcb.zip` is ready to upload directly
  to a fab like PCBWay).
- `OPL_Kicad_Library/` (at the repo root, git submodule) — Seeed's KiCad
  footprint/symbol library, used for the XIAO and other Seeed parts on this
  board.

## Future enhancements

- **Resolve the KiCad schematic labeling gap** — add proper net labels to
  the RF-HAT schematic so future revisions (or anyone else building from
  the design files) don't have to manually trace wire coordinates to
  verify pin assignments.
