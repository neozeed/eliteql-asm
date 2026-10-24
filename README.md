# EliteQL ASM A13 — player missile combat

A13 adds player arming, lock, launch, target-relative homing, enemy ECM and
missile impacts. A12's inverted pitch controls are retained. A12 remains a
separate baseline. This is the complete source and runnable build.

Launch `EXEC_W WIN1_ELITEASM` with the `host` directory mounted in QLBox.
For example:

```
bin\win64\qlbox.exe --ram 128 --speed 1 --mount eliteql-asm-a13\host
```

## Controls

| Key | Action |
| --- | --- |
| 4 | Full missile encounter: three fighters, nine reusable missile slots |
| T | Arm a missile; acquire the first target passing original HITCH |
| U | Disarm and clear target lock |
| M | Launch at the locked target |
| E | Activate ECM; holding E repeats after expiry |
| F | Hold to fire the forward pulse laser |
| Up / Down | Push nose down / pull nose up; release to damp |
| Left / Right | Roll; release to damp |
| A / Z | Increase / decrease speed |
| 1 / 2 / 3 | Passive solo / passive fleet / original laser encounter |
| Space | Pause / resume |
| N | Reset scene, reload four player missiles, advance solo model |
| B | Toggle 10 Hz cap (also changes simulation speed) |
| Escape | Release held keys, restore screen and exit |

Player missiles are enabled in scene 4. The status strip shows `M4 -` when
four missiles are available and none is armed, `M4 A` while seeking a lock,
and a target slot in place of the dash after locking. Slots 10/11 currently
appear as `:` / `;`. Arming, disarming and launch occur on simulation updates,
so pause freezes those actions. Hold T while bringing a ship into the sights,
then press M once locked. The original HITCH test decides lock, not a new
screen-space aiming approximation. Firing consumes ammunition only when a
slot is available; a jam preserves both ammunition and lock.

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

This is still a flight/combat test scene. Escape-pod spawning/navigation,
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
At 128 KB a BASIC EXEC_W launch leaves a largest free block of 14,848 bytes;
640 KB is also tested. Physical 68008 timing has not been measured.

The new `ELITEMSL` diagnostic tests 65,536 ECM states and 1,024 sets of impact,
ECM destruction and child initialization cases. These are independent boundary
checks, not a full original-instruction missile-system oracle. The homing
comparisons in `ELITETAC` do execute original 6502 instructions.

Both live-job harnesses check launch, homing, E activation, countdown expiry,
explosion, slot reuse, fatal impact and restart, together with the earlier combat,
framebuffer, scanner, controls, keyboard and clean-exit regressions at 128/640 KB.
Logs are in docs/A13-*.log. Older architecture/testing sections describe inherited
milestones; the A13 notes in those documents specify changes and limits.

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

## A13 target and lifetime behavior

FRS1/ZINF initialization launches at y=-28, z=14 with forward nose, reversed
side vector, twice player speed, two energy units and the target slot encoded
in the AI byte. FRMIS clears lock, consumes one missile and calls the existing
ANGRY port after successful allocation. The same pool supports both sides.

TAS1/MVT3 subtracts 23-bit sign-magnitude coordinates, preserving overflow,
signed zero and the final carry used by DORND. TA19 steering uses this relative
vector. When its high/sign-magnitude bytes are zero, the original proximity
path kills the target and missile; a station survives. At distance, TA64 gives
a target equipped with ECM its original random opportunity to activate it.
Both sides' missiles respond to the shared ECM state.

Fixed-slot lifetime handling clears locks and destroys missiles pursuing an
object once that object's explosion starts. This prevents a recycled native
slot from silently becoming a new target. It is a native pool adaptation,
not the original compacting UNIV/FRIN implementation. Ship kill rewards/tally,
sounds and original dashboard missile icon drawing remain outside this pass;
the small text status uses the existing QL shell strip.

`ELITETGT` covers 1,024 original TAS1/MVT3/TA19 cases, including signed zero
and carry, plus 256 launch states. Friendly missile branch checks compare
states and RNG against the original arithmetic/steering helpers with independent
proximity and ECM expectations; this is not a complete 6502 TA18 emulator.
Live tests cover T/U/M, inventory, hits, explosion cleanup, a full pool and enemy
ECM at 128/640 KB, including BASIC EXEC_W. The inherited enemy-missile,
laser, controls, scanner, framebuffer and exit checks also pass.
