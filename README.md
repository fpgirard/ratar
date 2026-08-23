<img src="ratar-color.svg" align="left" width="240" alt="RATAR logo" />

# Rage Against the Alkaline Remotes (Ratar)
*An RF Signal Capture & Replay Devices that uses the XIAO ESP32-C6 and CC1101*
<br clear="left"/>

Just as [Paul Wieland built his Ratgdo](https://www.nytimes.com/2025/12/04/technology/personaltech/why-on), my objective was equally simple: I needed to build an open-source, sub-$10 device to control my Minka-Aire fans (FCC ID **KUJCE10007**), Like Paul, I intended to leverage open source software and 
commodity components: ESPHome, 3D printing, inexpensive ESP32C6 microprocessors and CC1101-based RF PCBs. 

I also planned to either capture my Minka-Aire RF values from my remotes or use a [Flipper repository of RF codes](https://github.com/search?q=repo%3AZero-Sploit%2FFlipperZero-Subghz-DB+minka&type=code).

While Ratar is initially narrow in scope, I carefully designed it so that it might support a much larger idea: a foundation that might offer our  community a universal, community-supported RF/IR transceiver, where the hardware (PCBs), software (yaml) and CAD (OpenSCAD) files are shared and easily extensable to any 300–928MHz remote.  (I'm currently adding an IR LED/receiver to the Ratar HAT).

---

## Repo layout

It's clean, simple and should be easy to navigate.  Questions?  Comments?  Please uses Issues above to post.  

| Path | Contents |
|---|---|
| [`pcb/README.md`](pcb/README.md) | Hardware — component list, CC1101↔XIAO pin assignments, the RF-HAT KiCad project |
| [`src/README.md`](src/README.md) | Software — the ESPHome `cc1101` config, reverse-engineering notes, Signal Bench pointer |
| [`3d/README.md`](3d/README.md) | Enclosure — parametric OpenSCAD design for the printed case |
| `OPL_Kicad_Library/` | Git submodule — Seeed's KiCad footprint/symbol library, used by the RF-HAT PCB |
| `ratar.svg`, `ratar-color.svg` | Project logo |

---

## Future enhancements

See each area's own README for topic-specific roadmap items (IR support and
protocol decoding in [`src/`](src/README.md), the KiCad schematic net-label
cleanup in [`pcb/`](pcb/README.md)).

By design, the House-shaped Ratar Logo is based on the Kicad copper traces of the PCB Hat. :)
