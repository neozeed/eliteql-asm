# EliteQL ASM A27 — Electron fidelity pass

A27 ports the Electron's four-view stardust, launch/docking/hyperspace tunnels,
long-range chart cursor and nearest-system selection, sound control and pitch
envelopes, and more of the message and random-number timing into native 68000
assembly. It retains A26's four laser mounts, docking computer, station police,
trading, travel, combat, salvage and commander saves.

The Electron 6502 instructions are the reference. No Thargoids, Tharglets,
witchspace misjumps or missions have been invented: those are absent from this
Electron source. Earlier release notes incorrectly listed witchspace as a gap.
This is a substantial fidelity pass, not a claim that every original routine or
screen has now been ported. See docs/FIDELITY.md for the remaining boundaries.

## Run

With this release's host directory mounted in QLBox:

```
bin\win64\qlbox.exe --ram 640 --speed 1 --mount eliteql-asm-a27\host
```

Then enter `EXEC_W WIN1_ELITEASM` in BASIC. The real QL needs only ELITEASM,
installed as a QDOS executable with its data-space metadata preserved, and an
optional ELITESAVE. Source and large diagnostic jobs are development files;
they do not need to fit on the QL's 5 MB disk.

The game also runs in the tested 128 KB QLBox configuration. Its saved BASIC
screen now uses lossless word-run compression when smaller than the raw bitmap.
An unusually complex pre-launch screen may require the full 32 KB backup and
therefore more memory. Failure to allocate exits before changing the screen.
640 KB remains the comfortable configuration. Physical 68008 performance has
not been measured; the emulated active-flight measurement is in A27-RESULTS.md.

## What's new

- The original ten dust particles use STARS1/STARS6/STARS2 and FLIP, including
  byte arithmetic, carry, shared DORND state, view changes and original dash shapes.
  The generator emits native 68000 instructions at build time; no 6502 interpreter
  is included in the game.
- LAUN and LL164 use the original HFS ring-radius sequences and XOR erasure.
  QL frame pacing and line rasterization are explicit hardware adaptations.
- The galaxy chart uses original star positions/dashes, fuel-circle geometry,
  cursor movement bounds and TT111 nearest-system selection.
- SFX/NO3 priorities and SFXL lifetime gates follow the source, including the
  original unusual priority-table addressing. Loader pitch envelopes drive QL
  IPC sound. The QL tone output approximates Electron sound; noise is not exact.
- ENERGY LOW, TARGET LOST, INCOMING MISSILE and MISSILE JAMMED join the existing
  messages. Bounty presentation now displays current cash, matching the original.
- The M% random seed update, stardust consumption, message expiry and encounter
  carry feed the native loop in source order. Encounter fixtures check carry as
  well as returned state.

EQA2 saves remain 148 bytes and include rear/side laser fittings and the docking
computer. EQA1 saves load with empty rear/side mounts. Keep a backup when moving
between versions. Invalid or truncated files are rejected before commander commit.

## Controls

| Key | Action |
| --- | --- |
| 4 | Sidewinder/Viper/Mamba missile encounter |
| 5 | Python/Cobra/Mamba salvage encounter |
| 6 | Open/close commander status and cargo manifest |
| 7 | Reset to station approach encounter at Lave |
| 0 | SOLAR deep space with original encounters; retain commander |
| J | In-system jump, subject to mass lock and distance checks |
| 8 while docked | Equipment shop; press again for market |
| Shop: F1 / F2 / F3 / F4 | Select front / rear / left / right laser mount |
| C in flight | Use fitted docking computer at a friendly station (S bulb) |
| Shop: B / S / O | Buy selected item / save / load |
| K in flight | Use a fitted escape capsule |
| 9 | Navigation page; press again to return |
| F1 / F2 / F3 / F4 | Front / rear / left / right during live flight |
| Navigation data page: Left/Right | Previous/next system within remaining fuel |
| Navigation data page: Up/Down | Browse all 256 systems |
| Navigation: C | Switch data/chart; closing the chart selects its nearest system |
| Chart: arrows / D / O | Move cursor / select nearest system / return cursor to current system |
| H / G | Hyperspace to selected system / use galactic hyperdrive |
| Navigation while docked: R | Buy enough fuel to fill the tank |
| Docked: Up/Down, B, S, L | Select commodity, buy one, sell all selected, launch |
| T / U / M | Arm and acquire a missile target / disarm / launch |
| E | ECM, if fitted; holding repeats after expiry |
| - | Fire the fitted energy bomb |
| F | Hold to fire the current view’s fitted pulse or beam laser |
| Up / Down | Push nose down / pull nose up |
| Left / Right | Roll; release controls to damp |
| A / Z | Increase / decrease speed |
| 1 / 2 / 3 | Passive solo / passive fleet / laser encounter |
| Space | Pause / resume |
| N | Reset encounter, commander and cargo; advance solo model |
| B | Toggle the 10 Hz cap (also changes simulation speed) |
| Escape | Wait for held-key release, restore QDOS screen and exit |

The commander page freezes simulation and ignores other gameplay controls.
Closing it preserves the previous pause state. Escape still exits normally.
It does not allocate another screen buffer: existing line, particle, laser and
sight caches restore the flight view. The page is a native QL presentation
adapter, not a recreation of the original STATUS screen's system-name layout.

## Build and verify

Use the recovered GCC 2.95.3 R2 signed-remainder-fix QDOS toolchain:

```
make QCC=/absolute/path/to/qdos-gcc
sh tests/run-qlbox.sh /absolute/path/to/qlbox-r9
sh tests/run-basic.sh /absolute/path/to/qlbox-r9
```

ELITEASM's game and shell are native 68000 assembly. C is used for host diagnostic
jobs and benchmarks only. Fixture interpreters execute bundled original 6502
excerpts on the development machine. See docs/TESTING.md and A27-RESULTS.md for
coverage and actual results. Historical release notes are explicitly labelled;
they are not the current feature list.
