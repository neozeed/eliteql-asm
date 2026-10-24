# EliteQL ASM A8 — original pulse-laser combat

A8 brings a connected set of Electron combat routines into the native 68000
application: **MA68/ma1 laser controls, LASLI heat/energy use, DORND random
numbers, HITCH target checks, MA47 damage, ANGRY hostility and MLOOP pulse timing**.
The original SIGHT crosshair and LASLI2 beam geometry use the QL XOR rasterizer.
Hold **F** to fire the original 15-power forward pulse laser.

Ship records now hold the full original **36 bytes**, including energy at
INWK+35. Energy and targetable area come from the original ship blueprints.
A target at exactly zero energy survives; the next hit kills it. Killed test
objects disappear from the view and scanner. The station cannot be destroyed,
and being hit marks it hostile. This does not yet give it attacking AI.

Laser heating, energy drain, cooling and the existing instruments work together.
The native OOPS forward/aft shield and energy-damage arithmetic is also ported
and tested, ready for the future collision/enemy-fire callers. Those callers
are not connected yet, so ordinary firing does not damage your shields.

**This remains a flight/combat test scene, not complete Elite.** Enemy TACTICS,
explosions, debris, bounty/rank updates, sound, missiles, docking, travel,
markets and saves remain unfinished. Fuel, cabin temperature, altitude and
compass still show unconnected artwork. There is no C game loop and no runtime
6502 interpreter. A7 is preserved separately.

## Run

Extract the complete folder beside QLBox:

```bat
bin\win64\qlbox.exe --ram 128 --speed 1 --mount eliteql-asm-a8\host
```

At BASIC:

```text
EXEC_W WIN1_ELITEASM
```

640 KB is also tested. No compiler or external game data is needed to run it.
The executable is **25,746 bytes**. A BASIC launch at 128 KB leaves a largest
free block of **24,576 bytes** after startup and the screen snapshot allocation.
This is the current test scene's footprint, not a promise for the finished game.

| Key | Action |
| --- | --- |
| F | Hold to fire the forward pulse laser |
| Left / right | Original roll-rate accumulation |
| Up / down | Original pitch-rate accumulation |
| A / Z | Increase / decrease player speed, 1–40 |
| N | Reset the scene and player status; advance the solo model |
| 1 / 2 | Select solo / twelve-ship scene and reset |
| Space | Pause / resume, including laser and thermal state |
| B | Toggle uncapped simulation and drawing; default cap is 10 Hz |
| Escape | Wait for key release, drain input, restore screen and exit |

The initial solo Cobra is in front of you. Hold F to try a kill; N gives you a
fresh target. Fleet objects need steering into the sights. Nothing respawns
automatically. A/Z remains throttle, so the Electron fire control maps to F.
Firing respects the original pulse delay and temperature threshold of 242.

Arrows accumulate rates rather than setting an immediate angle. Damping takes
time after release. Scene resets use test initial conditions: ship speed 2
(station 0), roll counter 32, pitch counter 16, player speed 1. N/scene reset
restores full shields/energy and clears heat, targets and pulse state.

B accelerates simulation along with drawing. The FPS strip includes paused
time. Drawing goes directly to the standard QL screen at 0x20000; the old
screen snapshot is for restoring BASIC, not a second drawing buffer.

## Source fidelity and boundaries

The new arithmetic is checked against an interpreter executing the bundled
original 6502 instructions, including SQUA2/MU11 for HITCH. MULU replaces the
shift/add square while preserving the observable result. Target checks use
original world-space coordinates and targetable area, not the apparent pixel
size of the rendered wireframe.

The current scene has no reserved station slot. ANGRY therefore receives the
actual station-AI pointer when a station is present. The source's trader
station-hostility path is also tested. Ship death currently stops at the
original killed-bit boundary: the scene clears its cached lines and scanner
contact instead of inventing an explosion or awarding a bounty.

Sound and the surrounding spawn/ECM loop are absent. Their carry boundaries
are explicit: this shell supplies C=0 to LASLI and C=1 to the MLOOP subtraction,
giving the 10/6/2/0 pulse countdown. DORND and countdown routines support both
incoming carry values, and the tests cover both. The scene's fixed RNG seed is
test scaffolding, not the original clock-derived initialization.

Crosshair and laser endpoint geometry comes from SIGHT/TT15 and LASLI2/las.
They use the existing native inclusive-endpoint line rasterizer, so this is
not a claim of original Electron pixel-identical line drawing. The dashboard,
scanner and supported gauges retain their earlier original-pixel tests.

See `docs/FIDELITY.md` and `docs/ARCHITECTURE.md` for remaining adaptations.

## Validation and performance

- **8,192 new source-instruction cases**: RNG, HITCH, damage, hostility,
  forward/aft player damage, firing and both-carry countdowns; zero mismatches.
- **2,048 sustained-fire updates**, including heat inhibition and recovery;
  buffer guards and double-XOR erasure checks.
- Actual native job at **128 KB and 640 KB**, both direct loading and BASIC
  `EXEC_W`: F/pause, five-hit Sidewinder kill, scanner removal, misses, station
  immunity/hostility, frozen laser pulse, scene-reset pixels and exit cleanup.
- All prior movement, TIDY, controls, scanner, instruments and renderer tests pass.

QLBox R9, speed 1, 300-frame benchmark: **53.5 FPS solo / 8.3 FPS twelve ships**.
It includes the original movement/control/scanner/instrument paths and idle
laser dispatch/countdown. It excludes keyboard polling, active firing and
unported AI. These are emulator measurements, not physical 7.5 MHz 68008 timing.

## Build and tests

The full source, generated data, original instruction excerpts, fixtures,
Makefile and all ten executables are included. `host/ELITEASM` is the game job;
`ELITEBEN` is the benchmark and the remaining jobs are independent diagnostics.
Use 640 KB for the larger diagnostics, including the new `ELITECBT`.

```bat
bin\win64\qlrun.exe --ram 640 eliteql-asm-a8\host\ELITECBT
bin\win64\qlrun.exe --ram 640 eliteql-asm-a8\host\ELITETST --args "--selftest"
bin\win64\qlrun.exe --ram 640 --speed 1 eliteql-asm-a8\host\ELITEBEN --args "--bench --flight --fleet 12 --frames 300"
```

Build with the recovered QDOS GCC 2.95.3 R2 signed-remainder-fix toolchain:

```sh
make QCC=/absolute/path/to/qdos-gcc-linux-x86_64/bin/qdos-gcc
bash tests/run-qlbox.sh /absolute/path/to/qlbox-r9
bash tests/run-basic.sh /absolute/path/to/qlbox-r9
```

C test drivers retain `-fno-omit-frame-pointer` for the recovered compiler bug.
The integration harness needs QLBox R9 sources, Musashi, Linux runner and JS ROM;
these and the toolchain are not bundled. ELITEASM ignores command-line arguments.

Regenerate the source-based fixtures with `python3 tests/NAME_reference.py`,
where NAME is `motion`, `flight`, `tidy`, `controls`, `scanner`, `dials` or
`combat`. Pass `/path/to/elite-source.asm` to re-extract from the supplied full
source. Run generators before rebuilding their diagnostics. Regenerate expanded
blueprints with `python3 tools/extract.py /path/to/elite-source.asm`, renderer
fixtures with `python3 tests/reference.py`, and the original dashboard conversion
with `python3 tools/dashboard.py`.

Validation logs and actual emulator captures are in `docs/`. Attribution is in
`NOTICE.md`; file checksums are in `SHA256SUMS`.
