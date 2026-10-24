# A11 update

See README.md for the connected hostile missile/ECM implementation and its
explicit sound-carry, slot-allocation and missing player-missile boundaries.
New native code is src/missile.s; missile_check.h exercises the live application.
ELITETAC adds 1,024 original-instruction homing cases. ELITEMSL adds boundary
tests, not an instruction oracle. A11 logs record the current build.
Stats magic is EQB1/6800; pointers at offsets 102 and 106 expose ECM and launches.

The following describes the inherited A9 implementation and validation.

# A9 validation

The recovered GCC 2.95.3 driver/JAS/linker builds all twelve executables.
ELITEASM uses only assembly application sources. C is confined to independent
diagnostics and benchmarks, with `-O2 -fno-omit-frame-pointer -Wall` retained.

`A9-INTEGRATION.log` records the source comparisons, native job integration
and benchmarks under QLBox R9 / JS ROM. `A9-BASIC-EXIT.log` repeats the live
checks through actual BASIC `EXEC_W` at 128 KB and 640 KB. `A9-BUILD.log`
records the final rebuild. All twelve rebuilt executables were checked against
the hashes of the tested executables before packaging.

## New original-instruction comparisons

- TAS2: 512 vector cases, including byte/sign and normalization edges.
- TAS3: 1,536 signed dot products across all three orientation vectors.
- Normal-ship TACTICS: 1,536 cases comparing all ship, RNG and player-status
  bytes and returned events. Event counts are 1,065 ordinary returns, 65 missile
  requests, 22 escape requests, 345 shield hits, 9 cargo-loss boundaries and
  30 player-death boundaries. Child spawning, cargo loss and the death animation
  remain outside this implementation.
- MVEIT AI dispatch: 3,072 cadence/type/AI/dead-flag combinations.
- DOEXP: 2,048 distance, counter, flag, scaling and lifetime states, including
  the retained carry that advances far clouds by five instead of four.
- PTCLS/EXS1/PIXEL: 256 cases compare particle records, RNG state and original
  Electron framebuffer pixels converted to QL format. Native drawing must also
  erase exactly when XORed twice and leave buffer guards intact.

The reference generators execute bundled original 6502 instruction excerpts;
they do not derive expectations from the native formulas. External calls stop
or return at documented boundaries. These CPU subsets omit decimal mode,
interrupts and timing; this is not full-machine equivalence. The live shell's
projection, beam rasterizer, cached particle erasure and absent universe context
have the explicit limits described in FIDELITY.md.

## Retained regressions

- Combat: 8,192 original source cases across DORND, HITCH, damage, ANGRY,
  OOPS, firing and countdown; 2,048 sequential held-fire thermal updates,
  unaligned state, guard bytes and XOR erasure.
- DIALS: 512 original framebuffer cases. Recharge/cooling: 2,048 state cases
  and 1,024 sequential updates, comparing all five status bytes.
- SCAN: 512 geometry/framebuffer cases, all 256 visibility flags, double-XOR
  erasure and projected-output bounds.
- Controls: 2,048 byte-state cases and 1,024 sequential updates, comparing all
  13 state bytes, including damping, reversal and speed limits.
- TIDY: 512 direct cases and 24 scheduled trajectories (5,248 movement steps).
- Own rotation: 768 cases and 11,904 updates.
- Complete MVEIT parts 3–8: 768 cases and 4,224 updates, including arbitrary
  bytes, signed zero, overflow and acceleration/speed edges.
- Renderer: 52 line and 244 scene fixtures from the earlier scalar renderer
  oracle. These verify the native adapter, not original LL9 pixel equivalence.

## Connected native application checks

Both headless job loading and BASIC EXEC_W run the following at 128 KB and
640 KB:

- Player fire: a 70-energy target survives four 15-power hits and explodes on
  the fifth. Original cloud lifetime and pixels are verified; the scanner
  contact disappears and the expired cloud leaves no stale pixels.
- Off-axis shots miss. Stations survive hits and acquire hostility. Long
  held-fire runs reach the heat limit. Pause freezes a pulse; reset erases it.
- Encounter mode activates three fighters, changes their orientation and runs
  scheduled tactics. An aligned Sidewinder fires at the player; each hit's nine
  points of damage and intervening recharge/cooling match the actual updates.
- Enemy beam pixels are independently reconstructed along with the viewport.
  Fatal OOPS damage freezes simulation; 3 restarts and 1 restores solo mode.
- Ship line caches, sights, beams and cached cloud particles reconstruct every
  one of the 24,576 viewport bytes. Original artwork, contact records and gauge
  state reconstruct all 7,168 dashboard bytes; slow gauges use their four-update
  snapshot. These checks do not claim that the native wireframe projection is
  pixel-identical to original Elite.
- Pause preserves state. Control rates accumulate and damp; A/Z clamp at 1 and
  40. Reset removes old scanner/line/beam/cloud caches. Escape waits for held
  keys to release, restores the poll chain and exits successfully.
- BASIC remains suspended during EXEC_W. A burst of printable game keys is
  consumed, and the character queue is empty before and after exit. The
  headless harness checks exact restoration of all 32,768 screen bytes; BASIC
  is allowed to redraw after exit, so its screen is not compared byte-for-byte.

Each live run completed 1,626 simulation frames. Largest free blocks after
startup were 16,896 / 531,968 bytes headless and 16,384 / 531,456 bytes through
BASIC, at 128 / 640 KB respectively. ELITEASM is 28,236 bytes with 9,040 bytes
of QDOS data space. The large diagnostic executables are run with 640 KB.

SCREENS.png contains actual 128 KB QLBox captures of encounter mode, a cloud,
an enemy beam and the player-destruction boundary. They are test captures;
paused time can affect the displayed FPS counter.

## Benchmark scope and reproduction

A9-BENCHMARK.log records 300 completed frames at QLBox speed 1: solo 282 ticks
(53.1 FPS), twelve passive ships 1,821 ticks (8.2 FPS). Geometry counts remain
3,690 vertices / 4,637 lines solo and 29,990 / 39,974 for the fleet.

The benchmark includes movement, controls, TIDY, scanner, recharge/cooling,
gauges, idle AI scheduling and idle laser dispatch. It has no active AI,
explosions or firing. Its fixed control inputs reproduce the established
movement trajectory; they are not the interactive shell defaults. This is
neither physical 68008 timing nor a complete-combat performance measurement.

Regenerate fixtures before building diagnostics, using the commands in README.
The test runner regenerates reference data as an additional source check but
runs the already-built jobs. Build after regeneration when changing a corpus.
Then run `tests/run-qlbox.sh` and `tests/run-basic.sh` with the QLBox R9 root.

Physical QL execution, other ROMs and all physical keyboard behavior remain
unverified. The finished game's memory footprint is not established.
