# Rage Against the Alkaline Remotes

*RF Signal Capture & Replay — CC1101 + XIAO ESP32-C6*

A from-scratch build that turns a $2 CC1101 sub-GHz transceiver and a Seeed
XIAO ESP32-C6 into a fully working RF capture-and-replay device, controlled
through Home Assistant via ESPHome. Built to reverse-engineer two Minka Aire
ceiling fan remotes (FCC ID **KUJCE10007**) that had no public protocol
documentation anywhere — this project produced what appears to be the first
public decode of that remote.

It also produced **Signal Bench**, a small self-hosted web app for cataloging
RF and IR codes as a community resource, seeded with the real codes captured
here — see [`src/README.md`](src/README.md#related-signal-bench) for details.

This repo is deliberately scoped narrow — one board, one protocol family,
two remotes — but it's built as the first working instance of a much
broader idea: a universal, community-supported RF/IR transceiver, where the
hardware and ESPHome software pattern generalize to any 300–928MHz remote
(and, with an IR LED/receiver added, to IR devices too), and Signal Bench is
what turns each person's one-off reverse-engineering work into a shared,
growing catalog instead of something redone from scratch every time.

---

## Why this project matters

Most consumer RF remotes — ceiling fans, garage doors, gate openers — use
cheap, undocumented sub-GHz chips with no published protocol, no open
database, and no vendor incentive to ever publish one. Commercial universal
receivers (like Bond Bridge) solve this by doing the reverse-engineering
work privately and never releasing the results. If your device isn't in
their tested list, you're stuck.

This project shows that reverse-engineering a real, undocumented remote is
achievable with under $10 of hardware and an evening of careful capture
work — and that the result is worth publishing rather than keeping private.
**Signal Bench** exists to make that publishing step easy, so the next
person with the same fan (or the same FCC ID) doesn't have to redo this
work from scratch.

---

## Repo layout

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
