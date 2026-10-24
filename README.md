# EliteQL ASM A17 — equipment, energy bomb and planet navigation

A17 adds the original energy bomb, OUCH cargo/equipment destruction, cockpit
compass, and dedicated MV40 planet movement. A16 is preserved separately.
This ZIP contains the complete native 68000 source and runnable QDOS jobs.

Launch `EXEC_W WIN1_ELITEASM` with this folder's `host` directory mounted:

```
bin\win64\qlbox.exe --ram 128 --speed 1 --mount eliteql-asm-a17\host
```

## A17 additions

**Press minus (`-`) to use the energy bomb.** One bomb is fitted in these test
encounters and restored by N/reset. The original MA24 shift activates it,
MA18 shifts its remaining active bits each update, and the ship-loop branch
kills eligible objects. Stations and already-exploding objects are immune.
Kills use EXNO2 and subsequent original bounty/legal settlement; the bomb does
not run the laser-specific debris path. Holding minus follows the original
repeated-shift rule. Pause freezes activation and expiry. This is a test
loadout, not a claim about the equipment of a fresh original commander.

When a hit penetrates your shields but you survive, **OUCH can destroy an
entire commodity stock or one piece of equipment**. The original DORND/CPX
selection and DLY gate determine whether anything is lost. Lost ECM prevents
new E activation; lost scoops make a close canister collide rather than collect;
lost bombs cannot fire; energy-unit loss removes its recharge bonus. An already
active ECM cycle is not cancelled just because the equipment is destroyed.
The source's docking-computer flag is included in the damage layout, but no
working docking computer is fitted or implemented. The status strip names the
lost item. Page 6 now shows ECM, scoops, bomb and energy-unit Y/N indicators.
Cargo names and quantities are separated more clearly than in A16.

**The cockpit compass now follows the planet reference.** It uses original
SPS1/SPS3 normalisation, SPS2/SP2 placement and DOT/CPIX2 shapes: a double-height
dash ahead, single-height behind. The actual source writes three horizontal
pixels, despite its four-pixel description. Drawing/erasure retains underlying
dashboard artwork. There is still no station-safe-zone selection or rendered
planet; this instrument currently tracks the existing test planet only.

The live compass test exposed an A14/A16 limitation: the planet had been sent
through the ship coordinate-rotation path. The source has a separate **MV40**
path for its larger coordinates. A17 ports MV40, MULT3, MVT3 and the MV45/MVT1
translation, preserving 23-bit magnitudes and original fractional carry/borrow.
That corrected reference also feeds escape-pod navigation. Only its coordinates
are advanced; no rendered planet orientation/altitude/travel system is claimed.

The source's MV40 reads a pre-existing K2 low scratch byte. The native entry
exposes it as an argument, and tests cover all 256 values; the scene passes zero.
This is an explicit boundary, not a claim to recreate incidental zero-page
aliasing throughout the complete original game. OUCH's incoming random carry
is similarly explicit **1** at the absent EXNO3 sound boundary. Complete original
sound-dependent RNG sequencing is not reproduced.

## A17 validation

New original-instruction comparisons:

- 2,048 OUCH states, comparing all 22 cargo/equipment bytes and RNG state.
- 4,096 bomb targets, 512 key states and all 256 expiry states.
- 512 compass placement/bitmap/XOR/guard cases.
- 1,024 MV40/MULT3/MVT3/MV45 cases, including repeated trajectories, large
  coordinates and all K2-low inputs.

The complete suite and both real-QDOS-job harnesses pass at 128/640 KB, including
BASIC EXEC_W. Live checks cover planet front/rear direction, exact dashboard
pixels, bomb consumption, eleven fleet kills with station immunity, no duplicate
tally, cargo and equipment loss, blocked ECM/bomb/scooping, reset, and all earlier
combat, pod, salvage, commander, controls and keyboard/exit behavior.

The game is 35,124 bytes plus 8,732 bytes QDOS data space. BASIC EXEC_W leaves
10,240 bytes in the largest free block at 128 KB. Physical 68008 timing remains
unmeasured. The inherited benchmark exercises passive ships, not active bombs,
compass or AI, so its results are not a new whole-game performance claim.

All gameplay remains native assembly. C and the original 6502 interpreters are
build-time/test tools only. Logs are docs/A17-BUILD.log, A17-INTEGRATION.log and
A17-BASIC.log. SCREENS.png contains actual emulator captures from the bomb and
forced-equipment-loss integration tests.

## Controls

| Key | Action |
| --- | --- |
| 4 | Sidewinder/Viper/Mamba missile encounter |
| 5 | Python/Cobra/Mamba salvage encounter |
| 6 | Open/close commander status and cargo manifest |
| T / U / M | Arm and acquire a missile target / disarm / launch |
| E | ECM, if fitted; holding repeats after expiry |
| - | Fire the fitted energy bomb |
| F | Hold to fire the forward pulse laser |
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

## Retained commander behavior

Each reset starts this test commander with **100.0 Cr**, zero kills and clean
legal status. Credits, tally and cargo last for the current encounter only.
There is no disk save or continuity across N/scene reset yet.

Laser kills execute original EXNO2 tally arithmetic, including 16-bit wrap and
"RIGHT ON COMMANDER!" at each low-byte wrap. The original TA35 missile
self-destruction/ECM path also earns one tally point; a hostile TA34 impact on
the player does not. A player missile impact counts its missile destruction,
not an invented second tally increment for the target. Collisions and scooping
do not increment the tally. Native fixed-pool target invalidation remains an
adapter boundary and does not award an extra tally for each invalidated missile.

When an explosion finishes, the original MA15/q2 settlement sets FIST bit 6
for a Viper and considers the original blueprint bounty. Payment happens once,
not once per explosion frame. The source's DLY check gates MCASH itself: when a
commander message is already active, that settlement pays no bounty. Its other
quirk is retained too: a zero bounty LOW byte suppresses payment even if the
high byte is nonzero. Current blueprint bounties are 5.0 Cr Sidewinder, 15.0 Cr
Mamba, 20.0 Cr Python, 0.5 Cr asteroid, and zero for the other supplied models.
The status strip briefly displays bounty or encouragement messages.

Native CASH is the original big-endian four-byte total in tenths of a credit;
TALLY retains its original little-endian byte pair. STATUS rank decisions are
ported, with thresholds 8,16,32,64,128,512,2560,6400. Legal presentation uses
Clean at zero, Offender at 1–49, and Fugitive at 50+. Killing a Viper makes this
commander a fugitive; police spawning, legal decay and docking fines are absent.

DLY is shared by the two new commander messages and decremented once per
simulation update. The complete original text-token/message system is not
ported; scoop and collision messages remain absent; OUCH destruction now shares DLY
with these commander messages. Consequently, whole-game message interference with bounty
payment is not yet reproduced. The bundled oracle explicitly ends at MESS,
with a 22-tick presentation adapter. There is no new sound implementation.

## Existing combat and salvage

Scenes 4 and 5 use three original fighters plus nine reusable child slots for
missiles, pods and canisters. TACTICS decides missile launches and escape-pod
launches from the original energy/random conditions. There is no periodic
launch script or automatic fighter respawn. Weaken a Viper and stop firing to
give it an opportunity to eject. ECM destroys active missiles and costs energy.
Player missiles use HITCH targeting and original relative-coordinate homing;
a full pool preserves the player's inventory and lock.

Scene 5 offers more debris: laser kills run the original MA47 canister-mask
rule. Cargo inherits the parent's pose and original SFS1 random tumble. Fuel
scoops are fitted: approach slowly with a canister below the nose to collect it.
The original proximity and tnpr capacity checks govern the 20-tonne hold.
Canisters produce an original random commodity 0–7; pods become commodity 3
(slaves), as in the source. A full hold removes the attempted scoop without
adding cargo. Approaching above the nose causes original MA58 collision damage.

The manifest displays the seventeen original stocks. Gold/platinum are kg,
gem-stones are g, and the other commodities are t. It preserves the source's
unusual tnpr special branch for indices 13–16; the underlying hold arithmetic
was not changed to match a newly invented capacity model. N resets all stocks.

The unrendered test planet follows player-relative movement and drives the
original pod navigation routines. This is still a flight/combat encounter:
travel, a complete universe, rendered planets, station compass selection,
docking, markets, equipment purchases, player escape launch, sound and
commander saves are unfinished. Native projection/clipping and fixed slots
remain adaptations; see docs/FIDELITY.md for inherited arithmetic boundaries.

## Validation and build

ELITEASM's gameplay and shell are entirely native 68000 assembly. C is used
only for diagnostics and benchmarks. Physical 68008 performance is unmeasured.

ELITECMD compares **all 65,536 tally/rank values** and **4,096 settlement,
tally and countdown states** against executed original 6502 instruction
excerpts. It includes cash overflow/carry propagation, police legal flags,
zero-low-byte bounties, busy-message suppression and tally overflow. This large
fixture diagnostic needs 640 KB; the game itself is tested at 128 and 640 KB.

Both live-job harnesses exercise delayed bounty, one-time settlement, tally,
ECM tally, police status, all cargo display units, frozen state, exact viewport
restoration (including an active explosion), reset, and inherited combat,
scanner, controls, inverted pitch, keyboard/EXEC_W and clean-exit behavior.
A BASIC EXEC_W launch at 128 KB leaves a 10,240-byte largest free block.
Logs and actual emulator captures are in docs/A17-*.log and docs/SCREENS.png.
Screenshots containing every commodity or Elite rank use injected test states;
these are display tests, not claims of completing those achievements in play.

Build using the recovered GCC 2.95.3 R2 signed-remainder-fix toolchain:

```
make QCC=/absolute/path/to/qdos-gcc
bash tests/run-qlbox.sh /absolute/path/to/qlbox-r9
bash tests/run-basic.sh /absolute/path/to/qlbox-r9
```

Keep `-fno-omit-frame-pointer` for C diagnostics. Regenerate modified reference
fixtures BEFORE building. `run-qlbox.sh` normally regenerates fixtures but runs
already-built jobs; `SKIP_REFERENCES=1` skips that generation when already done.
The A17 release was rebuilt after generation and tested with that setting.
QLBox sources, JS ROM and compiler are external and not bundled. No compiler is
needed to run ELITEASM. Attribution: NOTICE.md.

Blueprint headers append the original bounty word at offset 38 (40-byte header),
preserving earlier offsets. Stats magic is EQB7/6800. Pointers at offsets 138
and 142 expose the 10-byte commander record and modal-page word. Commander
layout: CASH[4], TALLY[2], FIST, DLY, native message ID, padding. The source
excerpts describe logic; native presentation and test-scene reset are explicit
adapters. No modern combat-rating table replaces the Electron thresholds.

A17 appends debug pointers at146 (equipment[5]),150 (compass cache[4]) and
154 (loss count). Cargo[17] and equipment[5] are contiguous in original QQ20
order: ECM,scoops,bomb,energy-unit,docking-computer. The new jobs are ELITEEQP,
ELITECMP and ELITEPLN; the large fixture jobs should be run with640KB.
