# EliteQL ASM A9 — enemy tactics and original explosions

A9 adds a connected native 68000 port of **normal-ship TACTICS, TAS2/TAS3 vector
maths, enemy laser fire and OOPS damage**, plus **DOEXP/PTCLS/EXS1 explosion
clouds and PIXEL particle drawing**. A8 remains a separate working baseline.

Press **3** for a three-fighter hostile encounter. Ships use the original aim,
pursuit/avoidance, pitch/roll, acceleration and energy-recharge decisions.
Enemy beams originate at the blueprint gun vertex and reach toward a screen
edge as in LL9 part 9. Hits drain the appropriate shield and then energy.
When the original OOPS code reaches DEATH, this test scene freezes and displays
`DESTROYED`; **3** or **N** restarts it. Escape still returns cleanly to BASIC.

Killed targets now produce the original expanding, thinning particle clouds
around their projected vertices. Cloud lifetime, distance scaling, random
spread, particle count, clipping and two/four-pixel shapes follow the source.
The cloud is erased when it expires or the scene resets. Ships continue their
original movement during the explosion, while tactics and TIDY are skipped.

**This is still a flight/combat test scene, not complete Elite.** The encounter
is deterministic test setup. Universe spawning, missile homing/launching,
station police, debris/cargo spawning, bounty/rank, cargo loss, the original
player-death animation, sound, travel, markets, docking and saves remain
unfinished. Normal-ship missile and escape decisions are ported through event
boundaries; child objects are not spawned yet. Encounter ships start with zero
missiles. A ship deciding to escape loses AI as in the source, but no escape
pod is added. Fuel, cabin temperature, altitude and compass remain unconnected.

## Run

Extract the full folder beside QLBox:

```bat
bin\win64\qlbox.exe --ram 128 --speed 1 --mount eliteql-asm-a9\host
```

At BASIC:

```text
EXEC_W WIN1_ELITEASM
```

640 KB is also tested. No compiler or external game data is needed to run it.
ELITEASM is **28,236 bytes**, with **9,040 bytes of QDOS data space**.
A BASIC launch at 128 KB leaves a largest free block of **16,384 bytes** after
startup, including the old-screen snapshot. The finished game may need more RAM.

| Key | Action |
| --- | --- |
| F | Hold to fire the original 15-power forward pulse laser |
| Left / right | Build roll rate; release to damp back toward centre |
| Up / down | Build pitch rate |
| A / Z | Increase / decrease player speed, 1–40 |
| 1 | Passive solo target scene |
| 2 | Passive twelve-ship scene |
| 3 | Hostile three-fighter encounter; also restarts after player destruction |
| N | Reset scene/status; advance the model used in solo mode |
| Space | Pause / resume simulation, including beams and clouds |
| B | Uncap simulation and drawing; default cap is 10 Hz |
| Escape | Wait for all keys to be released, restore the screen and exit |

Scenes 1 and 2 retain A8's passive targets for comparison. Scene 3 gives the
first three models active AI with aggression byte 240, at preset positions.
Those are test initial conditions, not a substitute for Elite's universe
spawner. There is no automatic respawn. N resets the encounter in mode 3;
select 1 to see the newly selected solo model.

The original keyboard-rate accumulation and damping remain unchanged. B speeds
up the simulation as well as rendering. FPS includes paused time. The shell
writes directly to QL screen memory at 0x20000; the 32 KB snapshot restores
BASIC on exit and is not a drawing backbuffer.

## What is original, and what is adapted

Tactics run at the original `(MCNT XOR slot) AND 7` cadence, after the existing
TIDY schedule and before movement. The translated normal-ship path covers safe
zone suppression, recharge, aim, occasional roll, low-energy escape/missile
decisions, laser checks, steering and acceleration. It preserves the original
byte arithmetic, sign-magnitude values and carry-sensitive OOPS damage. For
example, a Sidewinder's blueprint weapon byte makes a hit drain nine shield
units, not eight, because its LSR supplies clear carry to OOPS.

TAS2 normalises original position bytes; TAS3 computes original signed dot
products. The earlier native NORM/MULT1/ADD helpers are reused. The source's
normal ships are supported here (types 1–6); missile homing, escape-to-planet
navigation and hostile-station spawning need universe context still absent.

The original explosion particle generator is tested by executing its 6502
instructions, including original Electron PIXEL framebuffer writes. The QL
particle output matches those pixels after format conversion. Vertex positions
still use the existing native renderer, whose projection, clipping and line
rounding are documented adaptations rather than exact original LL9 arithmetic.
Enemy beams and sights use that native line backend too.

A native cache replaces re-running PTCLS to erase the old cloud. Each slot has
448 bytes for the original cloud heap plus up to 96 cached particle records.
Initial cloud setup and the existing laser adapter use explicit carry inputs
at unported boundaries. The missing planet contributes zero as the PTCLS
planet-z seed byte. Lasers, tactics and clouds now share one RNG state. This is
not a claim of the complete original game's global random sequence or timing.

On player DEATH, the shell freezes the encounter and offers reset/exit. It does
not invent a replacement for the original death animation. Cargo-loss and
spawn events remain explicit unfinished boundaries. Killed slots remain
inactive until scene reset; universe compaction and rewards are not implemented.

## Validation

New source comparisons cover:

- **512 TAS2 vectors and 1,536 TAS3 dot products**.
- **1,536 complete normal-ship tactics cases**, comparing every ship, RNG and
  player-status byte plus returned events, including 30 DEATH cases.
- **2,048 DOEXP states**, including near/far carry differences and expiry.
- **256 PTCLS/PIXEL cases**, comparing particle records, RNG state, original
  framebuffer pixels, exact XOR erasure and buffer bounds.
- **3,072 scheduling combinations** for original AI cadence and dead/AI flags.

All A8 combat, movement, TIDY, controls, scanner, gauges and renderer regressions
also pass. Native integration at **128 KB and 640 KB**, through direct loading
and BASIC `EXEC_W`, checks cloud lifetime and pixels, steering, enemy fire,
exact shield/recharge state, player destruction, restart, key draining and exit.

The passive fleet benchmark is recorded in `docs/A9-BENCHMARK.log`. It includes
idle AI scheduling and laser dispatch along with the previous movement/rendering
work, but no active AI, clouds or firing. These are QLBox R9 speed-1 measurements,
not physical 68008 timing or a full-combat performance claim.

## Build and tests

The full source, generated data, original instruction excerpts, fixtures,
Makefile and twelve QDOS executables are included. ELITEASM is entirely assembly.
C is used only for independent diagnostics/benchmarks. Use 640 KB for those.
The new test jobs are `ELITETAC` and `ELITEEXP`.

```bat
bin\win64\qlrun.exe --ram 640 eliteql-asm-a9\host\ELITETAC
bin\win64\qlrun.exe --ram 640 eliteql-asm-a9\host\ELITEEXP
```

Build with the recovered QDOS GCC 2.95.3 R2 signed-remainder-fix toolchain:

```sh
make QCC=/absolute/path/to/qdos-gcc-linux-x86_64/bin/qdos-gcc
bash tests/run-qlbox.sh /absolute/path/to/qlbox-r9
bash tests/run-basic.sh /absolute/path/to/qlbox-r9
```

Keep `-fno-omit-frame-pointer` on C diagnostics for the recovered compiler bug.
The integration tests require QLBox R9 sources, Musashi, Linux runner and JS ROM;
these and the compiler are not bundled. ELITEASM ignores command-line arguments.

Run `python3 tests/NAME_reference.py` to regenerate fixtures, where NAME is
`motion`, `flight`, `tidy`, `controls`, `scanner`, `dials`, `combat`, `tactics`
or `explosion`. Supplying `/path/to/elite-source.asm` re-extracts original
instructions. Run generators before rebuilding diagnostics. Blueprints use
`python3 tools/extract.py /path/to/elite-source.asm`; the original dashboard
uses `python3 tools/dashboard.py`; legacy renderer fixtures use
`python3 tests/reference.py`.

See `docs/` for logs, emulator captures, ABI notes and fidelity limits.
Attribution is in `NOTICE.md`; file checksums are in `SHA256SUMS`.
