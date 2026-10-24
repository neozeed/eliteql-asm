# EliteQL ASM A7 — original instruments, recharge and cooling

A7 adds native 68000 ports of **DIALS parts 1–3, the shield and laser-temperature
sections of part 4, DIL/DIL2, shield/energy recharge and laser cooling**.
Speed, roll and pitch indicators now follow the live controls. The energy
banks, forward/aft shields and laser-temperature bar reflect player status.

Player status starts with full shields and energy, as in source RES4; the
energy unit is absent and laser temperature starts at zero. Recharge uses the
original energy threshold, charging order, drain and overflow behavior. There
is no combat or firing yet, so normal play does not damage shields or heat the
laser; the tests exercise those states without adding invented gameplay keys.

The main scheduling byte now **counts down**, as the original MCNT does. TIDY
uses that byte, recharge runs every eight updates, and slower instruments
refresh every four, after the original end-of-loop decrement. A6 remains a
separate baseline. The original scanner and keyboard-exit fix are retained.

**This remains a flight test scene, not a complete playable Elite port.**
Fuel, cabin temperature, altitude and compass remain unconnected artwork;
AI/TACTICS, combat and the rest of the main loop still need porting. The
application contains no C game logic and no runtime 6502 interpreter.

## Run

Extract beside QLBox:

```bat
bin\win64\qlbox.exe --ram 128 --speed 1 --mount eliteql-asm-a7\host
```

At BASIC, use the waiting form so BASIC does not draw over the application:

```text
EXEC_W WIN1_ELITEASM
```

640 KB is also tested. No compiler or external game data is needed to run it.

| Key | Action |
| --- | --- |
| Left / right | Build opposite roll rates through original DOKEY logic |
| Up / down | Build opposite pitch rates through original DOKEY logic |
| A / Z | Increase / decrease player speed, 1–40; displayed beside FPS |
| N | Reset positions, vectors and player speed; advance the solo model selection |
| 1 / 2 | Select solo / twelve-ship scene and reset it |
| Space | Pause / resume simulation and drawing |
| B | Toggle uncapped updates; default cap is 10 Hz |
| Escape | Release all keys; queued input is drained, then screen restored and job exits |

The QL key mapping is retained, but the response now follows the original
Electron routines: roll steps by 7, pitch by 14, with damping and auto-recentre
enabled. Neutral pitch can carry the original negative-zero byte (0x80).
Damping takes time after release; the opposite key recentres more quickly.
A/Z now follows the original speed handling, with a normal range of 1–40.
N and scene changes reset controls and speed to 1.

Raw keys are sampled at 10 Hz; the original control calculation runs once per
simulation update. Pausing freezes rates, speed and movement. The source's
configuration toggles and secondary flight keys are not yet exposed.

The scene seeds ship speed byte 2 (station 0), pitch counter 16 and roll counter
32. These are test-scene initial conditions. Own rotation damps to zero after
32 updates, but translation and player controls continue. Objects can leave
the view or pass behind you; press N to reset. There is no invented respawn.

B uncaps both simulation and drawing, so motion accelerates. FPS updates once
a second, includes paused time, and saturates at 99.9. The application owns the
screen by convention and writes directly to the standard QL framebuffer.

## Faithfulness and tests

The native core retains original INWK byte layout, sign-magnitude values,
byte-width overflow, signed zero, original update order, and arithmetic
rounding. Blueprint maximum speeds are extracted from the supplied Electron
source. MLTU2's final carry is clear: the following MV43 subtraction therefore
subtracts an extra unit. That behavior is deliberately retained.

A Python instruction interpreter executes the bundled **original 6502 source
instructions**, including the arithmetic helpers, to produce expected INWK
records. This is a documented instruction subset, not a full machine emulator.
The native QDOS tests compare all 33 movement-state bytes and all 13 player
control-state bytes, not just visible geometry:

- Instruments: **512 original framebuffer cases**, zero mismatches.
- Recharge/cooling: **2,048 state cases and 1,024 sequential updates**, zero mismatches.
- Scanner: **512 source geometry/pixel cases and all 256 visibility flags**, zero mismatches.
- Player controls: **2,048 byte-state cases and 1,024 sequential updates**, zero mismatches.
- TIDY: **512 direct cases and 24 scheduled trajectories (5,248 movement steps)**, zero mismatches.
- MVEIT parts 3–8: **768 fixtures, 4,224 steps**, zero mismatches.
- Existing own-rotation tests: **768 fixtures, 11,904 steps**, zero mismatches.
- Existing renderer: **52 line and 244 renderer fixtures**, plus bounds,
  XOR erase, range hiding/re-entry and overlapping line caches.
- Actual ELITEASM integration at **128 KB and 640 KB**: pause, damping,
  scene changes, full cached-line/framebuffer comparison, roll/pitch/throttle
  input, uncapping, screen restoration, poll cleanup and successful exit.

Actual BASIC `EXEC_W` launches at both RAM sizes also verify that BASIC is
suspended and a burst of printable game keys leaves the queue empty on exit.
Tests check rate buildup, sign, damping to centre, both speed limits and
Escape waiting until a held game key is released. Scanner integration also
compares all 7,168 dashboard bytes against independently decoded original
artwork plus contacts and live gauges, including erasure when contacts become
hidden. Tests inject depleted shields and a warm laser, then compare every
status byte and the countdown against the source-derived sequence.

These establish the tested movement routines and adapters. The renderer still
uses A1's native projection/clipping/rasterization, not exact Electron pixels.
Live vectors are adapted to Q8; source LL9 normalization remains unported.

## Performance and memory

QLBox R9 / JS ROM / speed 1 / 640 KB, 300 uncapped frames:

| Scene | 50 Hz ticks | FPS |
| --- | ---: | ---: |
| One Cobra, z initially 640 | 279 | 53.7 |
| Twelve ships, z initially 2400 | 1808 | 8.2 |

The benchmark runs the native control calculation once per frame, scheduled TIDY, MVEIT parts 3–8, position/vector adapters, projection and
XOR ship erase/draw, scanner erase/plotting, recharge/cooling and instrument drawing. It seeds continuous own rotation, ALPHA=1, BETA=0, DELTA=0,
ship speed=0. The benchmark disables control damping and supplies fixed rates
for fixed ALPHA/BETA; the interactive scene uses damping. A7's corrected
countdown changes the TIDY schedule from A6, so trajectories differ slightly.
AI, keyboard polling and the unconnected cockpit instruments are absent. Scene
trajectories differ from A2; this is not a controlled per-routine speed delta.

**Physical QL timing is untested.** QLBox's 68000 budget does not reproduce
68008 external-bus/contention and IPC timing exactly.

Final `ELITEASM`: **24,486 bytes**, **3,778-byte QDOS data-space request**, plus
2,048-byte stack and a 32,768-byte original-screen snapshot. Tested largest
free block after startup at 128 KB: **25,600 bytes** (actual BASIC launch; 26,112 with the headless loader). The milestone fits 128 KB;
the finished game's fit is still unproven. A 5 MB disk is ample for this build.

For a real QDOS filesystem transfer ELITEASM as **file type 1, data space 3778**
using a QDOS-aware method. XTcc and included `.qlbox-meta` headers support
QLBox; ordinary byte copying does not set a real QDOS executable header.

## Package and build

| Executable | Purpose |
| --- | --- |
| `host/ELITEASM` | Assembly interactive application; 128/640 KB |
| `host/ELITEBEN` | C CLI shell around native routines; use 640 KB |
| `host/ELITETST` | Renderer diagnostics; use 640 KB |
| `host/ELITEMOT` | A2 own-rotation fixtures and matrix adapter; use 640 KB |
| `host/ELITEFLT` | Full movement fixtures and position adapter; use 640 KB |
| `host/ELITETDY` | Original TIDY fixtures and scheduled movement; use 640 KB |
| `host/ELITECTL` | Original player control fixtures and sequence test; use 640 KB |
| `host/ELITESCN` | Original scanner geometry, pixels, XOR and flags; use 640 KB |
| `host/ELITEDIL` | Original gauge pixels, recharge and cooling; use 640 KB |

C and fixture data are excluded from ELITEASM. The recovered relocatable job
startup is retained with C initialization bypassed.

```bat
bin\win64\qlrun.exe --ram 640 eliteql-asm-a7\host\ELITEDIL
bin\win64\qlrun.exe --ram 640 eliteql-asm-a7\host\ELITESCN
bin\win64\qlrun.exe --ram 640 eliteql-asm-a7\host\ELITECTL
bin\win64\qlrun.exe --ram 640 eliteql-asm-a7\host\ELITETDY
bin\win64\qlrun.exe --ram 640 eliteql-asm-a7\host\ELITEFLT
bin\win64\qlrun.exe --ram 640 eliteql-asm-a7\host\ELITEMOT
bin\win64\qlrun.exe --ram 640 eliteql-asm-a7\host\ELITETST --args "--selftest"
bin\win64\qlrun.exe --ram 640 --speed 1 eliteql-asm-a7\host\ELITEBEN --args "--bench --flight --fleet 12 --frames 300"
```

`--motion` benchmarks A2 own rotation only; neither flag selects the A1 demo
matrix path. ELITEASM ignores command-line arguments.

Build with the recovered QDOS GCC 2.95.3 R2 signed-remainder-fix toolchain:

```sh
make QCC=/absolute/path/to/qdos-gcc-linux-x86_64/bin/qdos-gcc
bash tests/run-qlbox.sh /absolute/path/to/qlbox-r9
bash tests/run-basic.sh /absolute/path/to/qlbox-r9
```

C drivers keep `-fno-omit-frame-pointer` for the recovered compiler bug.
The test harness needs QLBox R9 source, Linux runner, Musashi and JS ROM;
those and the toolchain are not bundled. Generated sources/fixtures are included.

Regenerate expected motion from the bundled original excerpts:

```sh
python3 tests/motion_reference.py
python3 tests/flight_reference.py
python3 tests/tidy_reference.py
python3 tests/controls_reference.py
python3 tests/scanner_reference.py
python3 tests/dials_reference.py
```

Pass `/path/to/elite-source.asm` as an argument to any of these scripts to re-extract
from the full supplied source. Geometry regeneration uses
`python3 tools/extract.py /path/to/elite-source.asm`; renderer fixtures use
`python3 tests/reference.py`. Dashboard conversion uses
`python3 tools/dashboard.py` with the bundled original asset.

See `docs/A7-BENCHMARK.log`, `docs/A7-INTEGRATION.log`, `docs/A7-BASIC-EXIT.log`, `docs/TESTING.md`,
`docs/FIDELITY.md` and `docs/SCREENS.png`. Attribution is in `NOTICE.md`.
