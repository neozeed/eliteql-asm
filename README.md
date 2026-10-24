# EliteQL ASM A1 — native renderer milestone

A separate 68000/JAS branch, following the decision to stop extending the C
reimplementation. **This is a renderer test, not a playable Elite port yet.**
R3 remains the separate playable reference.

The runnable `ELITEASM` application is assembled from `.s` files. It uses the
original Electron blueprints and the original rendering structure: distance
rejection, face/vertex visibility, projection, clipped line lists, and XOR
redrawing to erase old ships. It uses native word arithmetic, expanded data
records and new QL-specific clipping/rasterization. It is not a byte-exact
translation of all of LL9; see `docs/FIDELITY.md`.

There is no full-frame clear, redraw or framebuffer comparison during animation.
The original screen is copied once at startup and once on exit. Static labels
are drawn once; the FPS strip is updated once a second. The renderer writes
straight to standard QL mode-8 video memory.

## Run

Extract beside QLBox and start the graphical emulator:

```bat
bin\win64\qlbox.exe --ram 128 --speed 1 --mount eliteql-asm-a1\host
```

Then at BASIC:

```text
EXEC_W WIN1_ELITEASM
```

640 KB also works. This application has been exercised at both memory sizes
with JS ROM. Escape restores the original screen and removes the poll callback.

| Key | Action |
| --- | --- |
| N | Next original ship blueprint |
| 1 / 2 | One ship / twelve ships |
| Left / right | Move the first ship horizontally |
| Up / down | Move the first ship nearer / farther |
| Space | Pause / resume animation |
| B | Toggle uncapped rendering; default is a 10 Hz cap |
| Escape | Restore screen and return to QDOS |

The FPS readout counts rendered frames, including the assembly shell's work.
It refreshes once a second, falls while paused, and saturates at 99.9. Keyboard
scanning remains at 10 Hz in uncapped mode. Rotation is a precomputed demo path;
these controls are not yet the original flight dynamics.

## Performance and memory

Renderer-only benchmark, 300 frames, Linux QLBox R7, JS ROM, speed 1, 640 KB:

| Scene | 50 Hz ticks | Frames/second |
| --- | ---: | ---: |
| One rotating Cobra, z=640 | 265 | 56.6 |
| Twelve ships, z=2400 | 1357 | 11.0 |

The benchmark includes projection, clipping, erasing old segments and drawing
new ones. It excludes the future game loop, AI, dashboard, and keyboard polling.
The two scenes have different object sizes and workloads; these numbers are
not a measured speedup factor over the complete C game.

`ELITEASM` is **13,804 bytes**, with **3,416 bytes** in its XTcc data-space
request. It additionally allocates a **2,048-byte stack** and a **32,768-byte
screen-restoration buffer**. On the tested 128 KB configuration, QDOS reported
a **37,376-byte largest free block** after startup. This demonstrates that the
renderer fits; it does not establish that the finished game will fit in 128 KB.

**Physical QL performance is untested.** QLBox uses a 68000 core with a nominal
7.5 MHz budget at speed 1; this is not a cycle-accurate measurement of the
68008's external bus and real QL contention/IPC costs. The executable uses
68000-compatible instructions, standard QDOS traps and the standard screen.
The B key and FPS display are provided for the real-machine check.

For a real QDOS filesystem, transfer `ELITEASM` as **file type 1**, with data
space **3416 bytes**, using a QDOS-aware transfer method. The XTcc trailer and
included `.qlbox-meta` header support QLBox; copying bytes alone does not set a
real QDOS filesystem's executable metadata. No external game data files or
compiler are needed to run it. The executable is small enough that a 5 MB disk
is not a storage constraint at this stage.

## Three executables

| File | Purpose |
| --- | --- |
| `host/ELITEASM` | Small interactive application; assembly application source; tested at 128 and 640 KB |
| `host/ELITEBEN` | C command-line shell around exactly the same assembly renderer; use 640 KB |
| `host/ELITETST` | Diagnostic build with generated oracle fixtures; use 640 KB |

The C runtime and test fixtures are deliberately excluded from `ELITEASM`.
The recovered compiler driver is used to invoke JAS and the linker for that
binary; it does not compile C application code into it. The toolchain's normal
relocatable QDOS job startup is retained, with the C initialization bypassed.

```bat
bin\win64\qlrun.exe --ram 640 --speed 1 eliteql-asm-a1\host\ELITEBEN --args "--bench --frames 300"
bin\win64\qlrun.exe --ram 640 --speed 1 eliteql-asm-a1\host\ELITEBEN --args "--bench --fleet 12 --frames 300"
bin\win64\qlrun.exe --ram 640 eliteql-asm-a1\host\ELITETST --args "--selftest"
```

`ELITEASM` ignores command-line arguments; run it graphically. `ELITEBEN` also
supports `--scene --model N --angle N --x N --y N --z N` for still-image tests.
Model indices are Sidewinder 0, Viper 1, Mamba 2, Python 3, Cobra 4, Coriolis 5,
missile 6, asteroid 7, canister 8 and escape pod 9.

## Build and verify

Use the previously supplied QDOS GCC 2.95.3 R2 signed-remainder-fix toolchain:

```sh
make QCC=/absolute/path/to/qdos-gcc-linux-x86_64/bin/qdos-gcc
sh tests/run-qlbox.sh /absolute/path/to/qlbox-r7
```

The test harness needs the supplied QLBox R7 source, Linux runner, Musashi and
JS ROM. They are not included. Generated model data and fixtures are included,
so rebuilding the executables does not require the Electron source checkout.

Optional regeneration:

```sh
python3 tools/extract.py /path/to/elite-source.asm
python3 tests/reference.py
```

`docs/NATIVE-TESTS.log` records the final results. `docs/ARCHITECTURE.md` describes
interfaces and the next port boundary. `docs/SCREENS.png` contains native images.
Original-data attribution is in `NOTICE.md`.
