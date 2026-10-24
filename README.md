# EliteQL ASM A2 — original ship pitch and roll

A2 ports **Electron MVEIT part 8, MVS5 and ADD** to native 68000/JAS and
connects their live orientation vectors to the renderer. The interactive
application no longer uses A1's precomputed animation path. A1 and the earlier
C prototype remain separate baselines.

**This is a source-led motion/renderer milestone, not a playable game yet.**
Original position updates, player pitch/roll, TIDY, tactics and the main flight
loop are not connected. No new flight physics or gameplay have been invented.

## Run

Extract beside QLBox:

```bat
bin\win64\qlbox.exe --ram 128 --speed 1 --mount eliteql-asm-a2\host
```

At BASIC:

```text
EXEC_W WIN1_ELITEASM
```

640 KB works too. The application starts with the original orientation convention
(side +X, roof +Y, nose -Z). The test scene seeds pitch counter 16 and roll
counter 32. The original damping reduces these to zero, so **rotation stops
after 32 updates**. This is intentional. N selects the next model and restarts
the demonstration; changing between one and twelve ships also resets it.

| Key | Action |
| --- | --- |
| N | Next original blueprint and restart damped rotation |
| 1 / 2 | One ship / twelve ships |
| Left / right | Inspection control: move first ship horizontally |
| Up / down | Inspection control: move first ship nearer / farther |
| Space | Pause / resume |
| B | Toggle uncapped rendering; default cap is 10 Hz |
| Escape | Restore screen and return to QDOS |

Arrow keys remain positioning tools, not the original cockpit controls. The
rotation update occurs once per rendered frame; uncapping therefore accelerates
the demonstration. The FPS strip includes shell work, updates once a second,
counts paused time, and saturates at 99.9.

## What is faithful

The port retains the original 33-byte INWK representation: little-endian,
sign-magnitude vectors, original counter signs, counter value 127 meaning
continuous rotation, pitch-before-roll ordering, and ADD's signed-zero/overflow
behavior. Both components in MVS5 use the old input pair. The native code is
ordinary 68000 arithmetic, not a 6502 emulator.

For testing, a small Python interpreter executes the extracted **original 6502
instructions** for part 8, MVS5 and ADD. The native QDOS executable matches all
33 output bytes in **768 fixtures / 11,904 movement steps**. Cases cover every
counter byte, randomized vectors, overflow, signed zero and repeated updates.
The interpreter is a documented instruction subset, not a full machine emulator.
These tests support the implemented routines; they do not establish whole-game
or pixel-for-pixel equivalence.

Rendering still uses A1's native projection, clipping and QL rasterizer. A2
converts the live vectors to the renderer's Q8 matrix with magnitude divided
by 96 (original unity is 96*256). This adapter is not original LL9 normalization.
See `docs/FIDELITY.md` for the remaining boundaries.

## Measured performance and memory

QLBox R7, JS ROM, speed 1, 640 KB, 300 frames, continuous original pitch and roll:

| Scene | 50 Hz ticks | FPS |
| --- | ---: | ---: |
| One Cobra at z=640 | 237 | 63.2 |
| Twelve ships at z=2400 | 1465 | 10.2 |

This includes native motion, matrix conversion, projection and XOR erase/draw.
It excludes the future flight loop, TIDY, AI, dashboard and keyboard polling.
It follows a different orientation trajectory from A1, so the numbers are not
an apples-to-apples speedup measurement. **Real QL speed is untested:** QLBox's
68000 cycle budget does not reproduce the 68008 bus/contention costs exactly.

`ELITEASM` is **14,270 bytes**, with **3,820 bytes** of QDOS data space, plus a
2,048-byte stack and a 32,768-byte screen-restoration allocation. The tested
128 KB configuration retained a **36,352-byte largest free block** after startup.
This milestone fits 128 KB; a finished-game fit is not yet established.

For a real QDOS filesystem transfer ELITEASM as **file type 1, data space 3820**
using a QDOS-aware method. The bundled XTcc trailer and `.qlbox-meta` support
QLBox; an ordinary byte copy does not set a real QDOS file's executable header.
No external data files or compiler are needed to run the interactive application.

## Executables

| File | Purpose |
| --- | --- |
| `host/ELITEASM` | All-assembly interactive application; tested at 128 and 640 KB |
| `host/ELITEBEN` | C benchmark shell calling native routines; use 640 KB |
| `host/ELITETST` | Existing renderer diagnostics; use 640 KB |
| `host/ELITEMOT` | Original-instruction motion fixtures and matrix checks; use 640 KB |

```bat
bin\win64\qlrun.exe --ram 640 eliteql-asm-a2\host\ELITEMOT
bin\win64\qlrun.exe --ram 640 eliteql-asm-a2\host\ELITETST --args "--selftest"
bin\win64\qlrun.exe --ram 640 --speed 1 eliteql-asm-a2\host\ELITEBEN --args "--bench --motion --fleet 12 --frames 300"
```

Omit `--motion` to retain A1's table-driven benchmark for renderer regression
work. Only that legacy path uses `--angle`. The interactive ELITEASM uses live
vectors and ignores command-line arguments. C and fixture data are excluded
from ELITEASM; it retains the recovered relocatable startup with C initialization
bypassed.

## Build and verify

Use the recovered QDOS GCC 2.95.3 R2 toolchain with its signed-remainder fix:

```sh
make QCC=/absolute/path/to/qdos-gcc-linux-x86_64/bin/qdos-gcc
sh tests/run-qlbox.sh /absolute/path/to/qlbox-r7
```

The C drivers retain the required `-fno-omit-frame-pointer` workaround. JAS
assembles the application. The test harness requires QLBox R7 source, its Linux
runner, Musashi and JS ROM; those and the compiler are not bundled.

Regenerate motion fixtures from the bundled source excerpt:

```sh
python3 tests/motion_reference.py
```

Or re-extract the instructions from the supplied full annotated source:

```sh
python3 tests/motion_reference.py /path/to/elite-source.asm
```

Existing geometry/renderer fixture regeneration remains:

```sh
python3 tools/extract.py /path/to/elite-source.asm
python3 tests/reference.py
```

`docs/A2-INTEGRATION.log` records the tests and timing. Integration exercises
pause, damping completion, model/fleet changes, cached-lines versus framebuffer,
uncapping, movement, complete screen restoration, poll cleanup and successful
exit at both memory sizes. `docs/SCREENS.png` shows the native output.
