# EliteQL ASM A4 — original TIDY and clean keyboard exit

A4 ports Electron **TIDY/NORM** and schedules vector correction before the
existing native MVEIT parts 3–8, once per ship per 16 updates when eligible.
The arithmetic, sign-magnitude state and update order follow the original
6502 instructions. A3 remains a separate baseline.

It also consumes queued QDOS characters while raw held-key controls operate.
Escape waits for all keys to be released and the queue to settle before
restoring BASIC, preventing game keystrokes from appearing at its prompt.

**This is a flight-motion test scene, not a complete playable Elite port.**
AI/TACTICS, scanner, cockpit, original keyboard response, and the main flight
loop remain unfinished. Planet/sun movement is not included.

## Run

Extract beside QLBox:

```bat
bin\win64\qlbox.exe --ram 128 --speed 1 --mount eliteql-asm-a4\host
```

At BASIC, use the waiting form so BASIC does not draw over the application:

```text
EXEC_W WIN1_ELITEASM
```

640 KB is also tested. No compiler or external game data is needed to run it.

| Key | Action |
| --- | --- |
| Left / right | Feed opposite roll inputs into original ALPHA calculations |
| Up / down | Feed opposite pitch inputs into original BETA calculations |
| A / Z | Increase / decrease player speed, 0–40; displayed beside FPS |
| N | Reset positions, vectors and player speed; advance the solo model selection |
| 1 / 2 | Select solo / twelve-ship scene and reset it |
| Space | Pause / resume simulation and drawing |
| B | Toggle uncapped updates; default cap is 10 Hz |
| Escape | Release all keys; queued input is drained, then screen restored and job exits |

Arrows are **direct test inputs** (roll magnitude 8, pitch magnitude 3), not
the original M% keyboard acceleration/damping. Releasing them returns the
input to zero. A/Z changes speed once per keyboard scan. Ship positions are
now updated through the original routines, not by incrementing screen offsets.

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
The native QDOS tests compare all 33 bytes, not just visible geometry:

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

These establish the tested movement routines and adapters. The renderer still
uses A1's native projection/clipping/rasterization, not exact Electron pixels.
Live vectors are adapted to Q8; source LL9 normalization remains unported.

## Performance and memory

QLBox R9 / JS ROM / speed 1 / 640 KB, 300 uncapped frames:

| Scene | 50 Hz ticks | FPS |
| --- | ---: | ---: |
| One Cobra, z initially 640 | 253 | 59.2 |
| Twelve ships, z initially 2400 | 1679 | 8.9 |

The benchmark runs scheduled TIDY, MVEIT parts 3–8, position/vector adapters, projection and
XOR erase/draw. It seeds continuous own rotation, ALPHA=1, BETA=0, DELTA=0,
ship speed=0. AI, keyboard polling and cockpit work are absent. Scene
trajectories differ from A2; this is not a controlled per-routine speed delta.

**Physical QL timing is untested.** QLBox's 68000 budget does not reproduce
68008 external-bus/contention and IPC timing exactly.

Final `ELITEASM`: **15,814 bytes**, **3,790-byte QDOS data-space request**, plus
2,048-byte stack and a 32,768-byte original-screen snapshot. Tested largest
free block after startup at 128 KB: **34,304 bytes** (actual BASIC launch; 34,816 with the headless loader). The milestone fits 128 KB;
the finished game's fit is still unproven. A 5 MB disk is ample for this build.

For a real QDOS filesystem transfer ELITEASM as **file type 1, data space 3790**
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

C and fixture data are excluded from ELITEASM. The recovered relocatable job
startup is retained with C initialization bypassed.

```bat
bin\win64\qlrun.exe --ram 640 eliteql-asm-a4\host\ELITETDY
bin\win64\qlrun.exe --ram 640 eliteql-asm-a4\host\ELITEFLT
bin\win64\qlrun.exe --ram 640 eliteql-asm-a4\host\ELITEMOT
bin\win64\qlrun.exe --ram 640 eliteql-asm-a4\host\ELITETST --args "--selftest"
bin\win64\qlrun.exe --ram 640 --speed 1 eliteql-asm-a4\host\ELITEBEN --args "--bench --flight --fleet 12 --frames 300"
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
```

Pass `/path/to/elite-source.asm` as an argument to any of these scripts to re-extract
from the full supplied source. Geometry regeneration uses
`python3 tools/extract.py /path/to/elite-source.asm`; renderer fixtures use
`python3 tests/reference.py`.

See `docs/A4-INTEGRATION.log`, `docs/A4-BASIC-EXIT.log`, `docs/TESTING.md`,
`docs/FIDELITY.md` and `docs/SCREENS.png`. Attribution is in `NOTICE.md`.
