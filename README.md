# EliteQL ASM A25 — station police and four flight views

A25 adds the original Electron station tactics and front/rear/left/right views,
all in native 68000 assembly. A24 is preserved separately; existing commander
saves are compatible. The archive includes the complete integrated source,
built QDOS jobs, source excerpts, diagnostics and test logs.

**Try it:** press **7** for the aligned station approach. Fire **F** at the
station to provoke its police response, or dock normally and press **L** to
launch; **F2** then looks back at the station. Use **F1** front, **F2** rear,
**F3** left and **F4** right during live flight. The bottom status strip names
the current view. Views do not switch while paused, on a modal page or docked.
The existing inverted pitch controls are unchanged.

The hostile station uses TACTICS' original eight-update scheduling, DORND
threshold140 and cap of three police already present. SFS1/SFS2 place each
Viper along the station's nose, with speed32, AI225 (ECM and aggression), and
roll damping. Launches use the existing twelve-slot native ship pool; a full
pool declines insertion. Friendly stations do not launch this response.
Station presence now also connects TA13's suppression of ordinary pirate and
bounty-hunter aggression. Hostile stations refuse docking through the existing
ISDK path. The Electron source has no separate peaceful-station traffic
scheduler in this path; this pass does not invent one.

PLUT/PUS1 transform both ship position and all three orientation vectors. Ships,
planets, enemy beams, explosion clouds and missile targeting follow the selected
view. Physics, AI, docking, altitude and the scanner retain ship-relative world
state. Switching clears old XOR drawing and rebuilds the view without resetting
the universe, cargo or commander. There is no extra framebuffer.
A retained deep-space scene flag is now scoped to deep-space mode, fixing
a return-to-solo reset that could leave the solo ship marked absent.

The current equipment/save adapter still stores a **front laser only**. Rear
and side views have no crosshair or player laser, as for unfitted original
views. Directional laser purchases and saving four laser fittings remain to be
ported. Missiles can lock in any view, while launch geometry remains forward.

ELITEVW compares 2,048 PLUT/PUS1 transforms and 4,096 station TACTICS/DORND/SFS2/
MVT1 cases against executed original 6502 excerpts, including negative zero,
overflow, RNG state and the police cap. QDOS allocation is an explicit adapter
boundary. Live tests cover all four views, exact XOR reconstruction, modal
restoration, unfitted lasers, missile locks, explosion lifetime across views,
rear-view planets, police provocation/launch/cap, safe-zone aggression and
hostile docking denial. Source constants and geometry are not newly imagined.

Release validation and memory figures are in docs/A25-RESULTS.md. Physical
68008 timing remains unmeasured. The 640KB target has ample room; 128KB remains
a tight configuration with little room for extra resident software.

Still unfinished: directional laser fitting, docking computer, witchspace,
sound, stardust and remaining presentation. The fixed ship pool, QL UI and
raster backend remain adaptations, rather than a complete instruction-for-
instruction translation. A24 planet rendering/altitude is retained; its source
boundaries are in docs/A24-RETAINED-NOTES.md.

Run `EXEC_W WIN1_ELITEASM` with this archive's host directory mounted:

```
bin\win64\qlbox.exe --ram 128 --speed 1 --mount eliteql-asm-a25\host
```

On a real QL, deploy **ELITEASM** as an executable with its QDOS data-space
metadata preserved. The large diagnostic jobs and source corpus are development
files; they are not needed on your 5MB game disk.

## Equipment and upgrades

Dock, then press **8**. Up/Down selects an item, **B** buys it, **L** launches,
and **8** returns to the market. The original technology rule limits available
items to index <= internal tech + 2. Prices are the Electron PRXS values.
Insufficient funds and duplicate/full equipment leave cash and inventory intact.

Available equipment: fuel, up to four missiles, the 35-tonne large cargo bay,
ECM, forward pulse/beam laser, fuel scoops, escape capsule, energy bomb,
energy unit and galactic hyperdrive. The docking computer remains unavailable
and cannot take your money. Laser purchases currently apply to the forward
view only; fitting lasers to the other views is still unfinished.

A beam costs 1000 Cr up front, with a 400 Cr refund for an installed pulse
laser. The full 1000 Cr must be available before that refund, as in the source.
Beam operation uses the existing original MA68 laser path: the beam flag clears
pulse cooldown; energy consumption and overheating still apply. The larger
hold changes both market buying and scooping. Purchased equipment survives
launch and hyperspace, and remains subject to the existing damage rules.

## Keep your commander

On the equipment screen, **S saves** and **O loads** `WIN1_ELITESAVE`.
The 144-byte versioned file contains credits, tally, legal status, cargo,
equipment, missiles, fitted forward laser, hold size, escape capsule, galaxy,
current/selected system, fuel and the station market. Load is docked-only and
returns to the equipment page; launch normally afterwards. To resume from a
fresh process, press7, approach/dock, press8, then O.

The file is a native QDOS adapter, not the Electron tape format. It has a
checksum and basic field validation. Missing, short or damaged files are
rejected before any live commander state is committed. Save overwrites this
single slot: keep a separate copy for multiple commanders or backup. It is
not a crash-atomic save. No save file containing the test commander's injected
credits is distributed.

## Escape capsule

Buy the capsule, then press **K in flight** while alive. The original ESCAPE/
ESL2 effects clear all17 cargo stocks, legal status and the one-use capsule,
and restore fuel to7.0. The RESET/RES4 boundary restores shields/energy and
returns you docked. Credits, tally and other equipment are retained. Local
objects are reset through the existing native scene adapter. There is no new
escape animation or sound. Escape is ignored while docked, on the commander
page, without a capsule or after death. Escape can cancel a pending jump;
a galactic drive already consumed by starting that jump is not refunded.

## Scope and verification

This is another substantial step, **not feature completion**.
Remaining special encounters,
full chart interaction, directional laser fitting, docking-computer operation, sound and presentation still
need work. Key7 retains the A18 approach fixture as a test shortcut.

ELITESHP tests3072 source-derived transaction combinations across all12 item
indices,16 tech values and16 cash/equipment configurations. These expectations
are a test adapter based on the bundled original EQSHP/et0-etB source; they are
not a full instruction-emulated shop UI. Live tests at128/640KB check buying,
missile capacity, larger hold, beam trade-in, replacements, actual QDOS file
round-trip, corrupt/truncated rejection, launch preservation, beam heat and
escape recovery. All previous diagnostics and both direct-job/BASIC EXEC_W
harnesses are retained. Current logs:docs/A25-BUILD/INTEGRATION/BASIC.log.

The initial test loadout is unchanged except that the escape capsule starts
absent. Scene reset still clears progress and restores that test loadout.

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
A20 can sell replacement drives at sufficiently advanced stations for 5000 Cr. **N/scene reset still erases progress**, returns to
Lave and restores the test loadout. Use the equipment screen to save before resetting.

## What is original, and what is still a test scene

travel.s translates TT54/TT20 seed twisting, cpl names, TT24 economy/government/
tech, TT111 distance, hyp/wW/TT107 countdown, Ghy seed rotation/selection,
TT18 fuel deduction and SOLAR legal decay. No C game loop or 6502 interpreter
is linked into ELITEASM. Original instruction interpreters are test tools only.

The navigation directory is a QL UI, not a recreation of the chart crosshairs.
Arrivals use original SOLAR planet placement, clear staged fighters and enable
original ambient spawning. Station creation uses original main-loop part14. No hyperspace tunnel, witchspace, sound or complete
universe lifecycle is claimed. Galactic seed/location/legal changes commit at
countdown completion rather than immediately in Ghy. GVL uses the existing
DORND routine with explicit carry0 at the missing whole-game RNG boundary.

Docking retains original alignment, hostility, proximity and failed-approach
speed checks. A bad approach below speed 5 dents the ship; at 5 or above it is
fatal. Docked Up/Down selects cargo, B buys one, S sells all selected stock,
and L launches. Docking replenishes shields and energy; launches do not grant
new missiles, bombs or equipment. Station compass selection follows the live allocated station.

## A19 validation

- All 2,048 systems across eight galaxies: original-instruction seed/name,
  economy, government and tech comparisons.
- 2,048 original SQUA2/LL5 distance comparisons, including 16-bit sum wrapping.
- Native checks for countdown length, rejection, fuel purchase, legal decay,
  destination locking and all eight galactic transitions.
- Connected travel/docking/refuelling/galactic travel at 128/640 KB under both
  direct-job and BASIC EXEC_W harnesses, plus all earlier combat regressions.

See docs/A25-RESULTS.md for current size and validation. The passive benchmark is not an
active-game performance claim.
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
| 0 | SOLAR deep space with original encounters; retain commander |
| J | In-system jump, subject to mass lock and distance checks |
| 8 while docked | Equipment shop; press again for market |
| Shop: B / S / O | Buy selected item / save / load |
| K in flight | Use a fitted escape capsule |
| 9 | Navigation page; press again to return |
| F1 / F2 / F3 / F4 | Front / rear / left / right during live flight |
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
N/scene reset clears the live state; load a saved commander from the docked equipment screen to restore progress.

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

The live planet follows player-relative movement and drives the
original pod navigation routines. Inter-system and galactic travel now work with destination markets. A complete
universe lifecycle, directional laser fitting, docking-computer operation and sound remain unfinished. Key7 retains the station-approach fixture. Native projection/clipping and fixed slots
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
Current BASIC EXEC_W memory measurements are recorded in docs/A25-BASIC.log.
Current logs are docs/A25-*.log. Current captures are docs/A25-views.png
and docs/A25-station-police.png; SCREENS.png retains earlier travel captures.
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
preserving earlier offsets. Stats magic is EQBB/6800. Pointers at offsets 138
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

A20 adds stats pointers182(ship_fit[4]) and186(equipment-page word).
The focused A20-SHOP.log additionally verifies file restoration after scene reset.

ELITEENC needs 640 KB for its diagnostic fixture corpus. Regenerate it with
`python3 tests/encounters_reference.py` before rebuilding. `ONLY_ENCOUNTERS=1`
selects the focused live check in either harness.

ELITESTA needs640KB for the original station/WARP/orientation diagnostic corpus.
Regenerate with `python3 tests/station_reference.py` before rebuilding.
`ONLY_STATION=1` selects the focused live world checks in either harness.


ELITEPV needs640KB for its diagnostic corpus. Regenerate with
`python3 tests/planet_view_reference.py` before building.
`ONLY_PLANET_VIEW=1` selects focused live tests in either harness.
