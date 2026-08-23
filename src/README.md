# Software

*ESPHome firmware — RF capture and replay on the CC1101*

## ESPHome + the built-in `cc1101` component

The build uses ESPHome's **official `cc1101` component**, added in
ESPHome **2025.12.0**. This was a major simplification partway through the
project — earlier revisions hand-rolled every SPI register write (reset
sequence, frequency registers, modulation config) either via Arduino's
`SPIClass` or, on the ESP-IDF-only C6, via raw bit-banged `gpio_set_level()`
calls. The built-in component eliminates all of that: frequency and
modulation are plain YAML keys, and it integrates directly with ESPHome's
standard `remote_receiver` / `remote_transmitter` components for capture
and replay.

## Complete working configuration

```yaml
esphome:
  name: xiao-c6-cc1101
  friendly_name: XIAO C6 CC1101
  on_boot:
    priority: 600
    then:
      - cc1101.begin_rx

esp32:
  board: seeed_xiao_esp32c6
  variant: esp32c6
  framework:
    type: esp-idf

wifi:
  ssid: !secret wifi_ssid
  password: !secret wifi_password

api:
  encryption:
    key: !secret api_encryption_key

ota:
  - platform: esphome
    password: !secret ota_password

logger:
  level: DEBUG

spi:
  clk_pin: GPIO19    # D8 - SCK
  mosi_pin: GPIO18   # D10 - MOSI
  miso_pin: GPIO20   # D9 - MISO

cc1101:
  cs_pin: GPIO21      # D3 - CSN
  frequency: 304MHz
  modulation_type: ASK/OOK

remote_receiver:
  id: cc1101_capture
  pin: GPIO1           # D1 - GDO2
  dump: raw
  idle: 15ms
  filter: 100us
  tolerance: 25%
  buffer_size: 10kb

remote_transmitter:
  id: cc1101_tx
  pin: GPIO2            # D2 - GDO0
  carrier_duty_percent: 100%
  on_transmit:
    then:
      - cc1101.begin_tx
  on_complete:
    then:
      - cc1101.begin_rx

button:
  - platform: template
    name: "Capture 304MHz RF"
    id: capture_rf_button
    on_press:
      - cc1101.begin_rx
      - logger.log: "CC1101 armed - press the remote button now"

  # One button per captured remote function - example:
  - platform: template
    name: "Fan 1 - Light Toggle"
    on_press:
      - remote_transmitter.transmit_raw:
          code: [312, -697, 313, -684, 324, -695, 329, -668, 334, -666, 335, -666, 336, -687, 315, -687, 316, -687, 341, -336, 660, -697, 318, -349, 666]
          repeat:
            times: 6
            wait_time: 12ms
```

Full button set for both captured Minka Aire remotes (11 functions total —
light toggle x2, low/mid/high speed, stop/off, and reverse on the second
remote) lives in the project's reference doc / Signal Bench catalog rather
than duplicated here.

## Why 304MHz, not 315MHz

315MHz is the common default assumption for fixed-code fan/garage remotes,
but this specific remote's FCC filing (FCC ID KUJCE10007) documents
**304.0MHz** as its actual operating frequency. Worth checking your own
device's FCC filing rather than assuming a round-number default — the
CC1101's filter bandwidth has some tolerance, but being off by 10MHz+ can
mean the difference between a clean capture and nothing at all.

## Frequency/reverse-engineering notes worth preserving

- Both remotes use a **fixed-code, non-rolling** OOK protocol: an 8-bit
  device/address prefix plus a 4-bit command suffix, with each button
  repeating its code ~6-7 times per press (~11,800µs gap between repeats).
- The two remotes have distinct address prefixes (`00000000` and
  `00000001`), confirming the address bits are what let two remotes/fans
  coexist without cross-triggering each other.
- One remote's "reverse" function was concluded to not exist via RF at
  all: applying the working remote's reverse command-suffix to the other
  remote's address prefix predicts a code that's identical to that
  remote's existing High Speed command — a genuine collision, not a
  capture failure. That fan's direction control is very likely a
  mechanical switch in the receiver canopy instead.
- Long-press behavior (dimming) on this remote family is **receiver-side**:
  holding a light button just re-sends the identical toggle code
  continuously: there's no distinct "dim" RF command. Simulating
  press-and-hold dimming in ESPHome means looping `transmit_raw` on a
  timer until told to stop, not sending a different code.

## Directory contents

- `rf-transceiver-sample.yaml` — the ESPHome config above (CC1101 RF
  capture/replay), with placeholder secrets. Your own `rf-transceiver.yaml`
  (real device name, API key, captured codes) is gitignored — copy the
  sample to that filename and fill in your own values.
- `fix_xiao_footprints.py` — utility script for XIAO KiCad footprint fixes.

## Related: Signal Bench

**Signal Bench** is a separate, self-hosted FastAPI web app (not vendored in
this repo) built alongside this project for cataloging RF/IR codes as a
community resource — paste raw ESPHome `remote_receiver` debug output and it
parses, renders, and stores the code, seeded with the real captures from
this project. See that app's own README for setup.

## Future enhancements

- **IR transmitter and receiver support on the same board.** The CC1101
  handles sub-GHz RF; a standard IR LED (TX) and demodulating IR receiver
  module (RX, e.g. a VS1838B) would let one device handle both RF and IR
  devices in a home, using the same `remote_transmitter`/`remote_receiver`
  pattern already proven here — ESPHome's `remote_receiver`/
  `remote_transmitter` components are protocol-agnostic and already used
  for IR in most ESPHome IR-blaster builds.
- **Protocol-level decoding**, not just raw replay — recognizing known
  encodings (NEC, RC5, etc. for IR; common fixed-code and rolling-code
  families for RF) so Signal Bench can show a decoded address/command
  breakdown automatically instead of just the raw pulse train.
- **Frequency sweep / auto-detect** for captures, rather than requiring the
  operating frequency to be known ahead of time (useful for devices without
  an easily found FCC filing).
- **Moderation/verification workflow** for Signal Bench submissions, so a
  growing public catalog stays trustworthy as more contributors add codes.
