# EliteQL ASM A19 — hyperspace and eight galaxies

A19 connects original Electron galaxy generation and hyperspace logic to the
native 68000 flight, docking and trading loop. A18 is preserved separately.
The archive contains all source, runnable QDOS jobs and test fixtures.

Mount this folder's host directory and run `EXEC_W WIN1_ELITEASM`:

```
bin\win64\qlbox.exe --ram 128 --speed 1 --mount eliteql-asm-a19\host
```

## Fly somewhere

**9 opens navigation.** You begin at Lave in galaxy 1 with 7.0 light years of
fuel. Left/Right selects the previous/next system within remaining fuel;
Up/Down browses all 256 systems. The page shows the actual generated name,
economy, government, tech level, distance and remaining fuel. Economy and
government use original 0–7 values; displayed tech is the original value +1.
Navigation freezes flight and preserves an existing pause.

**H starts hyperspace from flight.** You can choose a destination while docked,
but must close navigation (9) and launch (L) before jumping. Zero-distance and
out-of-fuel jumps are rejected. The original counters start at 15, wait 15 game
updates for the first decrement, then 5 per decrement:85 updates in total.
The HUD shows the countdown, flight/combat continues, and Space pauses it.
Destination selection is frozen while the countdown runs.

Arrival deducts the original rounded distance, halves legal status, preserves
commander/cargo/ammo/equipment and generates the destination's market from its
economy plus a new visit fluctuation. Dock, buy/sell, then open 9 and press **R**
to buy a full tank at the original 0.2 Cr per fuel tenth. Insufficient cash
leaves both tank and cash unchanged. The cockpit fuel gauge now tracks fuel.
Local launches preserve the current market; a hyperspace visit regenerates it.

**G uses the one-use galactic hyperdrive.** One is fitted in this test loadout.
The Superior Electron variant rotates each of the six galaxy-seed bytes,
advances the galaxy modulo 8, clears legal status and selects the nearest
system to (96,96). The first jump arrives at Ororra in galaxy 2. Galactic travel
does not consume normal fuel. The drive is spent when the countdown begins.
There is no drive-purchase screen yet, so only the initially fitted drive is
available in an uninterrupted game; native tests refit it to verify all eight
transitions and wraparound. **N/scene reset still erases progress**, returns to
Lave and restores the test loadout. There is no disk save yet.

## What is original, and what is still a test scene

travel.s translates TT54/TT20 seed twisting, cpl names, TT24 economy/government/
tech, TT111 distance, hyp/wW/TT107 countdown, Ghy seed rotation/selection,
TT18 fuel deduction and SOLAR legal decay. No C game loop or 6502 interpreter
is linked into ELITEASM. Original instruction interpreters are test tools only.

The navigation directory is a QL UI, not a recreation of the chart crosshairs.
Arrivals place the station ahead with two nearby fighters using the A18 approach
fixture; this is not the original SOLAR planet/station geometry or encounter
population. No hyperspace tunnel, rendered planet, witchspace, sound or full
universe creation is claimed. Galactic seed/location/legal changes commit at
countdown completion rather than immediately in Ghy. GVL uses the existing
DORND routine with explicit carry0 at the missing whole-game RNG boundary.

Docking retains original alignment, hostility, proximity and failed-approach
speed checks. A bad approach below speed 5 dents the ship; at 5 or above it is
fatal. Docked Up/Down selects cargo, B buys one, S sells all selected stock,
and L launches. Docking replenishes shields and energy; launches do not grant
new missiles, bombs or equipment. Station compass selection is scene-based.

## A19 validation

- All 2,048 systems across eight galaxies: original-instruction seed/name,
  economy, government and tech comparisons.
- 2,048 original SQUA2/LL5 distance comparisons, including 16-bit sum wrapping.
- Native checks for countdown length, rejection, fuel purchase, legal decay,
  destination locking and all eight galactic transitions.
- Connected travel/docking/refuelling/galactic travel at 128/640 KB under both
  direct-job and BASIC EXEC_W harnesses, plus all earlier combat regressions.

The game is 40,440 bytes plus 8,456 bytes QDOS data space. BASIC EXEC_W leaves a
5,120-byte largest free block at 128 KB. Physical 68008 timing remains unmeasured;
the passive benchmark is not an active-game performance claim. Logs are in
A19-BUILD/INTEGRATION/BASIC.log, with focused travel checks in A19-TRAVEL.log.
SCREENS.png contains actual emulator navigation, destination-market and galaxy 2
captures. Tests inject cargo/equipment/legal states for preservation checks and
disable nearby fighter AI during the travel test; combat is tested separately.

## Controls

| Key | Action |
| --- | --- |
| 4 | Sidewinder/Viper/Mamba missile encounter |
| 5 | Python/Cobra/Mamba salvage encounter |
| 6 | Open/close commander status and cargo manifest |
| 7 | Reset to station approach encounter at Lave |
| 9 | Navigation page; press again to return |
| Navigation: Left/Right | Previous/next system within remaining fuel |
| Navigation: Up/Down | Browse all 256 systems |
| H / G | Hyperspace to selected system / use galactic hyperdrive |
| Navigation while docked: R | Buy enough fuel to fill the tank |
| Docked: Up/Down, B, S, L | Select commodity, buy one, sell all selected, launch |
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
legal status. Credits, tally and cargo persist through docking, launch and hyperspace.
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
commander a fugitive; police spawning and docking fines are absent; hyperspace now halves legal status.

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
original pod navigation routines. Inter-system and galactic travel now work with destination markets. A complete
universe, rendered planets, original station-safe-zone selection, equipment
purchases beyond refuelling, player escape launch, sound and commander saves
are unfinished. Arrivals still use the station-approach encounter fixture. Native projection/clipping and fixed slots
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
A BASIC EXEC_W launch at 128 KB leaves a 5,120-byte largest free block.
Logs and actual emulator captures are in docs/A19-*.log and docs/SCREENS.png.
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
The A19 release was rebuilt after generation and tested with that setting.
QLBox sources, JS ROM and compiler are external and not bundled. No compiler is
needed to run ELITEASM. Attribution: NOTICE.md.

Blueprint headers append the original bounty word at offset 38 (40-byte header),
preserving earlier offsets. Stats magic is EQB9/6800. Pointers at offsets 138
and 142 expose the 10-byte commander record and modal-page word. Commander
layout: CASH[4], TALLY[2], FIST, DLY, native message ID, padding. The source
excerpts describe logic; native presentation and test-scene reset are explicit
adapters. No modern combat-rating table replaces the Electron thresholds.

A17 appends debug pointers at 146 (equipment[5]),150 (compass cache[4]) and
154 (loss count). Cargo[17] and equipment[5] are contiguous in original QQ20
order: ECM,scoops,bomb,energy-unit,docking-computer. The new jobs are ELITEEQP,
ELITECMP and ELITEPLN; the large fixture jobs should be run with640KB.

A18 appends pointers at 158 (docked word),162 (market34 bytes),166 (selection
word). New jobs ELITEMKT and ELITEDCK use large fixtures and run at 640 KB.

A19 adds debug pointers170(travel64),174(navigation word),178(arrival word).
ELITETRV contains the large original-source travel fixture corpus; run at 640 KB.
