<img src="ratar-color.svg" align="left" width="120" alt="Ratar logo" />

# Ratar

*Rage Against the Alkaline Remote — RF signal capture & replay with an XIAO ESP32-C6 and CC1101*

<br clear="left"/>

Just as [Paul Wieland built his Ratgdo](https://www.nytimes.com/2025/12/04/technology/personaltech/why-on),
my goal was equally simple: an open-source, sub-$10 device to control my Minka-Aire
fans (FCC ID **KUJCE10007**), built from the same kind of open-source
software and commodity parts he used — ESPHome, 3D printing, inexpensive
ESP32 boards with an added CC1101-based RF module.

I also planned to capture my Minka-Aire remotes' RF codes directly, or fall
back to a [Flipper repository of RF codes](https://github.com/search?q=repo%3AZero-Sploit%2FFlipperZero-Subghz-DB+minka&type=code)
if needed.

While Ratar is narrow in scope today, I designed it to support a much
larger idea: a universal, community-supported RF/IR transceiver, where the
hardware (PCBs), software (YAML), and CAD (OpenSCAD) files are shared and
easily extensible to any 300–928MHz remote. (I'm currently adding an IR
LED/receiver to the Ratar HAT.)

---

## Repo layout

It's clean and simple, and should be easy to navigate. Questions or
comments? Please use Issues above to post.

| Path | Contents |
|---|---|
| [`pcb/README.md`](pcb/README.md) | Hardware — component list, CC1101↔XIAO pin assignments, the RF-HAT KiCad project |
| [`src/README.md`](src/README.md) | Software — the ESPHome `cc1101` config, reverse-engineering notes, Signal Bench pointer |
| [`3d/README.md`](3d/README.md) | Enclosure — parametric OpenSCAD design for the printed case |
| `OPL_Kicad_Library/` | Git submodule — Seeed's KiCad footprint/symbol library, used by the RF-HAT PCB |
| `ratar.svg`, `ratar-color.svg` | Project logo |

`OPL_Kicad_Library/` is a git submodule, so clone with:

```sh
git clone --recurse-submodules https://github.com/fpgirard/ratar.git
```

(Already cloned without it? Run `git submodule update --init` to pull it in.)

---

## Future enhancements

See each area's own README for topic-specific roadmap items (IR support and
protocol decoding in [`src/`](src/README.md), the KiCad schematic net-label
cleanup in [`pcb/`](pcb/README.md)).

By design, the house-shaped Ratar logo is drawn from the KiCad copper
traces on the PCB HAT. :)
