# EliteQL ASM A18 — dock, trade and launch

A18 adds a connected local docking/market/launch loop, translated from the
Electron game's original 6502 logic into native 68000 assembly. A17 is preserved.
This archive includes the complete source and runnable QDOS jobs.

Mount this folder's host directory and run `EXEC_W WIN1_ELITEASM`:

```
bin\win64\qlbox.exe --ram 128 --speed 1 --mount eliteql-asm-a18\host
```

## Try the new loop

Press **7** for the station approach encounter. The station starts aligned ahead;
use A/Z for speed and the existing inverted flight controls to approach it.
Docking checks original proximity, station hostility, nose alignment, approach
vector and roll alignment. A failed approach below speed 5 dents your ship;
a failed approach at speed 5 or above is fatal. A correctly aligned approach
can succeed at higher speeds. The compass follows the station in this scene.

Once docked, flight simulation freezes and the market opens:

- Up/Down selects one of the 17 original commodities.
- B buys one unit, subject to stock, cash and original hold checks.
- S sells the entire selected cargo stock.
- L launches again; the station is behind you.

Docking replenishes shields and energy. Launch preserves credits, tally, cargo,
legal status, remaining missiles and equipment, including spent bombs and lost
equipment. Contraband applies the original BAD legal-status arithmetic.
The market persists across launches and re-docking. Original selling does not
replenish station stock. **N and scene-selection keys still reset progress.**

This is one fixed local test system: economy 5, fluctuation 0. Station placement,
launch pose and the two nearby fighters are native test fixtures; fighters and
other encounter objects reset on launch. There is no galaxy/hyperspace travel,
commander save, equipment shop, docking computer or tunnel animation yet.
Station compass selection is scene-based, not the original safe-zone selector.

## A18 validation

ELITEMKT passes 2,048 original economy/fluctuation market comparisons and 2,048
transaction/BAD cases. ELITEDCK passes 2,048 original docking cases. Transaction
tests execute original tnpr/LCASH/MCASH/BAD helpers with a test adapter around
buy/sell decisions; they do not emulate the complete original trading UI.

All diagnostic jobs and both live harnesses pass, including BASIC EXEC_W at
128 and 640 KB. Live tests fly the first approach, dock, trade, launch and
re-dock, checking state preservation, rejected trades, contraband status,
slow collision damage, fast collision death and all earlier combat regressions.

ELITEASM is 37,518 bytes plus 8,584 bytes QDOS data space. At 128 KB, BASIC
EXEC_W leaves a 7,680-byte largest free block. Physical 68008 timing remains
unmeasured. The inherited passive benchmark is not an active-game FPS claim.
Logs are docs/A18-BUILD.log, A18-INTEGRATION.log and A18-BASIC.log.
SCREENS.png shows actual market and launched-flight captures; some test cargo
and equipment states are injected to exercise persistence.

## Controls

| Key | Action |
| --- | --- |
| 4 | Sidewinder/Viper/Mamba missile encounter |
| 5 | Python/Cobra/Mamba salvage encounter |
| 6 | Open/close commander status and cargo manifest |
| 7 | Reset to station approach encounter |
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
legal status. Credits, tally and cargo persist through docking and launch in the local loop.
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
original pod navigation routines. Local docking and markets now work. Galaxy travel, a complete universe, rendered
planets, original station-safe-zone selection, equipment purchases, player
escape launch, sound and commander saves are unfinished. Native projection/clipping and fixed slots
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
A BASIC EXEC_W launch at 128 KB leaves a 7,680-byte largest free block.
Logs and actual emulator captures are in docs/A18-*.log and docs/SCREENS.png.
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
The A18 release was rebuilt after generation and tested with that setting.
QLBox sources, JS ROM and compiler are external and not bundled. No compiler is
needed to run ELITEASM. Attribution: NOTICE.md.

Blueprint headers append the original bounty word at offset 38 (40-byte header),
preserving earlier offsets. Stats magic is EQB8/6800. Pointers at offsets 138
and 142 expose the 10-byte commander record and modal-page word. Commander
layout: CASH[4], TALLY[2], FIST, DLY, native message ID, padding. The source
excerpts describe logic; native presentation and test-scene reset are explicit
adapters. No modern combat-rating table replaces the Electron thresholds.

A17 appends debug pointers at146 (equipment[5]),150 (compass cache[4]) and
154 (loss count). Cargo[17] and equipment[5] are contiguous in original QQ20
order: ECM,scoops,bomb,energy-unit,docking-computer. The new jobs are ELITEEQP,
ELITECMP and ELITEPLN; the large fixture jobs should be run with640KB.

A18 appends pointers at158 (docked word),162 (market34 bytes),166 (selection
word). New jobs ELITEMKT and ELITEDCK use large fixtures and run at640KB.
