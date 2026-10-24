# EliteQL ASM A11 — enemy missiles and ECM

A11 connects the A10 missile-homing kernel to a playable encounter. A9 remains
the separate stable baseline. This archive includes the complete project source,
generated data, original instruction excerpts, diagnostics and QDOS executables.

Launch `EXEC_W WIN1_ELITEASM` after mounting this folder's `host` directory.
For example, from QLBox on Windows:

```
bin\win64\qlbox.exe --ram 128 --speed 1 --mount eliteql-asm-a11\host
```

## Controls

| Key | Action |
| --- | --- |
| 1 | Passive solo target |
| 2 | Passive twelve-ship scene |
| 3 | Three-fighter laser encounter, as in A9 |
| 4 | Missile-enabled encounter; restart this scene after destruction |
| E | Activate fitted test-scene ECM; holding E repeats when it expires |
| F | Hold to fire the forward pulse laser |
| Arrows | Accumulate pitch/roll rates; release to damp |
| A / Z | Increase / decrease player speed |
| Space | Pause / resume |
| N | Reset; advance the solo model |
| B | Toggle the 10 Hz cap; uncapping also speeds up simulation |
| Escape | Release held keys, restore the screen and exit |

Scene 4 starts the same three fighters, with their original blueprint missile
stocks: Sidewinder zero, Viper one, Mamba two. Original TACTICS decides when to
launch as their energy drops. Damage a fighter with F to provoke a launch;
missiles are not fired on an invented periodic timer. Nine extra slots are
reserved for missiles and become reusable after their explosion cache expires.
There is no automatic fighter respawn.

Hostile missiles inherit the parent's position, orientation and speed through
the normal-parent SFS1 path. NWSHP initializes energy and missile flags from the
missile blueprint. Each update runs the original homing/steering and acceleration
logic, including stronger missile braking. The original high-coordinate-byte
proximity test triggers a 250-point OOPS hit, then an explosion. Lasers can shoot
missiles down. E starts a 32-count ECM cycle; each simulation update drains one
energy and decrements the timer by two. ECM destroys active missiles. Pause
freezes simulation, although E can arm the countdown while paused.

This is still a flight/combat test scene. Player missile inventory/locking,
friendly target-relative missile tracking, escape-pod spawning/navigation,
station police, debris, rewards/rank, sound, docking, travel, markets and saves
are not finished. The ECM lamp and incoming-missile text/sound are not connected.

## Source fidelity and adapter boundaries

Missile steering executes the port of TA21/TA19/TA20/TA15 through TA10, checked
against 1,024 original 6502 instruction cases. Normal-ship tactics retains its
1,536 source comparisons. Hostile proximity, ECM destruction, child initialization
and countdown follow TA18/TA34/TA35, SFS1/NWSHP and MA16/MA69. Original excerpts
are bundled in `tests/original-missile-boundaries.asm` for inspection.

The sound paths are absent. OOPS is called with explicit carry=1 at missile
impact and the rare ECM blast boundary; this is an adapter choice, not a claim
that the surrounding original sound code preserves that carry. The ECM blast
checks the original OR of coordinate low bytes, including its surprising behavior
at distant positions with zero low bytes. Tally/rewards from EXNO2 are absent.

Slot allocation uses twelve fixed native records and cached line/cloud storage,
not the original UNIV table and dynamic line heap. Child INWK heap-pointer bytes
33/34 are zeroed because native heaps are stored separately. A full pool rejects
a launch after TACTICS has consumed the parent's missile, matching the existing
external spawn-failure boundary. Stations are not supported as parents here.
The absent planet prevents correct escape-pod navigation, so it remains outside
this pass. Existing renderer adaptation and random-state limits remain as
documented in FIDELITY.md.

## Validation and build

ELITEASM is entirely native assembly. C is used only for diagnostics/benchmarks.
At 128 KB a BASIC EXEC_W launch leaves a largest free block of 15,872 bytes;
640 KB is also tested. Physical 68008 timing has not been measured.

The new `ELITEMSL` diagnostic tests 65,536 ECM states and 1,024 sets of impact,
ECM destruction and child initialization cases. These are independent boundary
checks, not a full original-instruction missile-system oracle. The homing
comparisons in `ELITETAC` do execute original 6502 instructions.

Both live-job harnesses check launch, homing, E activation, countdown expiry,
explosion, slot reuse, fatal impact and restart, together with the earlier combat,
framebuffer, scanner, controls, keyboard and clean-exit regressions at 128/640 KB.
Logs are in docs/A11-*.log. Older architecture/testing sections describe inherited
milestones; the A11 notes in those documents specify changes and limits.

Build with the recovered GCC 2.95.3 R2 signed-remainder-fix cross toolchain:

```
make QCC=/absolute/path/to/qdos-gcc
bash tests/run-qlbox.sh /absolute/path/to/qlbox-r9
bash tests/run-basic.sh /absolute/path/to/qlbox-r9
```

Keep `-fno-omit-frame-pointer` for C diagnostics. Regenerate changed reference
fixtures before building their tests. The test runner regenerates reference data
but runs already-built jobs. QLBox sources, JS ROM and compiler are external;
no compiler is needed to run ELITEASM. Attribution: NOTICE.md.
