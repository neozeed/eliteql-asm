# EliteQL ASM A15 — salvage, cargo and collisions

A15 adds original laser-kill canister spawning, cargo tumbling, automatic
scooping, a 20-tonne hold and nearby collision damage. Missile combat, escape
pods, cockpit symbols and inverted pitch controls are retained. A14 remains
a separate baseline. This is the complete source and runnable build.

Launch `EXEC_W WIN1_ELITEASM` with this folder's `host` directory mounted.

```
bin\win64\qlbox.exe --ram 128 --speed 1 --mount eliteql-asm-a15\host
```

## Controls

| Key | Action |
| --- | --- |
| 4 | Sidewinder/Viper/Mamba missile encounter |
| 5 | Python/Cobra/Mamba salvage encounter |
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

Player missiles and salvage are enabled in scenes 4 and 5. The status strip shows `M4 -` when
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

This is still a flight/combat test scene. Player escape-pod launch,
station police, rewards/rank, sound, docking, travel, markets and saves
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
At 128 KB a BASIC EXEC_W launch leaves a largest free block of 13,312 bytes;
640 KB is also tested. Physical 68008 timing has not been measured.

The new `ELITEMSL` diagnostic tests 65,536 ECM states and 1,024 sets of impact,
ECM destruction and child initialization cases. These are independent boundary
checks, not a full original-instruction missile-system oracle. The homing
comparisons in `ELITETAC` do execute original 6502 instructions.

Both live-job harnesses check launch, homing, E activation, countdown expiry,
explosion, slot reuse, fatal impact and restart, together with the earlier combat,
framebuffer, scanner, controls, keyboard and clean-exit regressions at 128/640 KB.
Logs are in docs/A15-*.log. Older architecture/testing sections describe inherited
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

## Inherited target and lifetime behavior

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
sounds remain outside this pass. A14 adds original missile bitmap shapes in
the cockpit alongside the small QL shell text status.

`ELITETGT` covers 1,024 original TAS1/MVT3/TA19 cases, including signed zero
and carry, plus 256 launch states. Friendly missile branch checks compare
states and RNG against the original arithmetic/steering helpers with independent
proximity and ECM expectations; this is not a complete 6502 TA18 emulator.
Live tests cover T/U/M, inventory, hits, explosion cleanup, a full pool and enemy
ECM at 128/640 KB, including BASIC EXEC_W. The inherited enemy-missile,
laser, controls, scanner, framebuffer and exit checks also pass.

## A14 escape-pod path

In scene 4, the original normal-ship TACTICS routine may choose SESCP when a
ship's energy is very low. The ship's AI is disabled and a type-11 escape pod
is created in the shared free-slot pool. Its position, orientation and speed
come from its parent; SFS1/NWSHP initializes its damped roll, AI and blueprint
energy. Pods appear on the scanner, move and turn, and can be targeted with
lasers or missiles. They are not immune to combat. If the pool is full, creation
fails after the original escape decision has disabled the parent AI.

To see this naturally, weaken a Viper and stop firing before the final killing
shot. Escape is the original random low-energy decision, not a scripted timer.
N resets the encounter and removes pods as well as missiles and clouds.

SPS1/SPS3 derives the planet direction from its original high coordinate bytes.
TA15 applies the original pod steering and acceleration decisions. The scene
now carries a separate planet navigation record, initially x=65536, y=0,
z=262144. It follows player-relative MVEIT movement so pitching, rolling and
flying change the reference direction. This is a test-scene reference only:
there is no rendered planet, altitude model, docking destination or full universe
initialization in this build.

The source's escape-pod entry uses the pre-existing CNT scratch byte rather
than calculating a new nose dot product. The native entry exposes CNT explicitly
and the shell supplies the latest native tactics CNT. The 512 source cases
exercise every CNT value. The original whole program reuses zero-page scratch
outside tactics too, so this is not a claim that complete-game incidental scratch
state has been recreated. No replacement steering formula is introduced.

## A14 cockpit symbols and validation

The four original MSBAR/MDIALS symbols are now drawn at their source dashboard
locations: white for available, hollow when armed, T-shaped when locked, and
black when spent. Original five-row bitmaps are converted to QL mode-4 pixels;
unrelated QL colour bits are preserved. The existing text status remains useful
for slot diagnostics. The compass is not connected yet.

ELITENAV tests 512 original SPS1/SPS3/TA15 states, all 256 incoming CNT values,
and 20 inventory/armed/locked full-frame bitmap cases with buffer guards. The
bitmap tests independently convert the source table; they do not execute the
original MSBAR instruction loop. Both live harnesses additionally check the
escape decision, pod spawn, parent AI shutdown, planet-relative movement,
scanner/viewport pixels and reset at 128 KB and 640 KB. Earlier missile,
ECM, laser, inverted controls and clean-exit checks remain in the suite.

## A15 salvage loop

Press 5 for the salvage encounter. Laser kills of ordinary ships follow the
original MA47/um decision: half the random outcomes suppress debris; otherwise
the random byte is ANDed with the blueprint's canister mask. The original masks
are zero for Sidewinder/Viper, one for Mamba, and three for Python/Cobra. A kill
can therefore leave nothing, even in the salvage scene. Missile kills do not
run this laser-specific debris path.

Canisters inherit their parent's location and orientation. The original SFS1
cargo branch sets random pitch, speed and endless roll, with no AI. Canisters,
pods and missiles share the nine reusable child slots. A full pool can lose
new debris; its original tumble RNG call is still consumed on allocation failure.

Fuel scoops are fitted in these test scenes. Approach slowly with a canister
below the nose. Scooping is automatic when the original coordinate tests pass:
all three high bytes zero, each low byte below 64, and negative y with scoops
fitted. Cargo canisters produce an original random commodity from 0–7. Escape
pods use the original commodity 3 mapping (slaves). The authoritative hold has
17 byte stocks; tnpr checks its original tonne and special-unit limits. The
scene supplies a standard 20-tonne hold (encoded CRGO=22).

The HUD's C00 counter shows carried tonnes. N resets all cargo, debris and
collection counters along with the scene. The cargo manifest, commodity
messages, trading and persistent commander saves are not implemented yet.

A full hold destroys the attempted scoop without adding cargo. Approaching a
nearby object above the nose causes a collision instead. Original MA58 damage
is 128 + half the object's energy, with the ROR carry passed into OOPS; shields,
energy and the existing death boundary respond. Missiles retain their own impact
logic. Station docking/collision checks are excluded from this new entry.
Collision destruction uses the native explosion adapter; successful/failed
scoops remove the item without drawing a cloud. OUCH cargo/equipment loss and
collision sounds remain unconnected.

## A15 validation and format notes

ELITECRG compares 2,048 tnpr cases, 1,024 proximity/scoop/collision-boundary
cases and 512 debris/tumble cases with bundled original instruction excerpts.
It compares ship bytes, all cargo stocks, RNG state, results and guard bytes.
The oracle ends at the collision boundary; OOPS is covered by the existing
combat corpus and the live collision test. It does not emulate docking, messages
or sound. The already-tested OOPS and damage logic remains native assembly.

Both real-job harnesses exercise scene 5, laser-spawned cargo, tumbling,
collection, a full hold, collision shield damage, reset and exact viewport/
dashboard reconstruction at 128/640 KB, including BASIC EXEC_W. All inherited
combat, navigation, controls, scanner, icon and exit checks remain in the suite.

Blueprint headers append the original debris mask at offset 36; earlier field
offsets remain unchanged. Stats magic is EQB5/6800. Debug pointers at offsets
122,126,130,134 expose cargo stocks, collected count, spawned canister count
and full-hold rejection count. These diagnostics are not commander rewards.
