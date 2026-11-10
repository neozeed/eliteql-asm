# Historical notes; not the A27 completion list

# A26 current update

README.md and A26-RESULTS.md describe the current release. Older milestone
sections below are historical, not the current completion list.

Native shop_buy_view extends the original transaction adapter with an explicit
view argument; shop_buy remains a front-view ABI entry for retained tests.
_ship_fit is eight bytes: capacity,front,escape,reserved,rear,left,right,reserved.
Only the selected mount is tested/refunded/replaced. The game loop reads the
current fitting through laser_fitting; targeting uses A25's PLUT/PUS1 workspace.

MA64's computer gate is key & DKCMP & SSPR, followed by the station AI sign test.
The shell supplies the actual allocated station (not a fixed slot), then joins
the existing GOIN/RES4 bay adapter. C is live-flight-only; no invented autopilot.
The dashboard S/E bulb adapter writes the original SPBT/ECBT bitmaps into
otherwise black8x8 regions: logical192,232 and56,232. Original screen addresses
7d20/7c98 use the Electron320-pixel stride and32-pixel left border.

Stats magic:EQBG/6800. New pointers:242 shop direction word,246 computer-dock
count long. Existing offsets and the first four _ship_fit bytes are unchanged.

Save EQA2 is148 bytes: old144-byte prefix with new magic/checksum plus four
bytes at144..147 (rear,left,right,reserved). A staged EQA1 read defaults those
bytes to zero. EQA2 requires its entire tail. Version, checksum, existing fields
and all four laser bytes validate before commit. The save remains a native
single-slot adapter, not the Electron cassette format or an atomic replacement.

ELITEFIT executes source fixtures from original-fittings-computer.asm; the
qv view prompt, prx price lookup and pres error/refund exit are explicit adapters.
Actual et3/et4 and MCASH instructions determine laser changes and trade-in refund.
Price availability/technology/rejection are also covered by retained3072 shop
cases. MA64 uses a relocated station-AI byte and boolean GOIN/MA68 exits.
Original-bulbs.asm records the glyph/address source. ONLY_FITTINGS=1 selects
live fitting/save/computer tests; complete harnesses include those tests too.

# A25 current update

See README.md and A25-RESULTS.md for the current release. Earlier milestone
sections below are retained historical notes, not the current completion list.

src/views.s ports PLUT/PUS1 into a separate 36-byte render workspace. Original
world INWK stays authoritative. Renderer beam-consumption and explosion flags
are copied back to world INWK. Both player hit tests use transformed geometry;
front-only equipment remains explicit. Planet rendering uses another 36-byte
view copy; altitude and station generation use the original world planet.

src/station_ai.s ports the hostile station branch and SFS2 launch geometry.
The shell counts live/exploding cops and inserts the result through its existing
ship-pool adapter. Normal ship tactics receives station presence as SSPR.

Stats magic is EQBF/6800. New pointers:230 view word,234 police-launch long,
238 crosshair byte. Earlier offsets are unchanged. F1-F4 map to QL IPC row0
bits1,3,4,0, respectively. View changes are rising-edge actions during live
flight, and scene/launch initialization resets to front.

ELITEVW uses tests/views_reference.py, original-views.asm and
original-station-police.asm. The oracle uses extracted source instructions,
with a caller-supplied carry1 at the equal CPX #SST boundary and allocation/
workspace adapters. It verifies output bytes and RNG, not CPU timing.
ONLY_VIEWS=1 selects the shared focused live test. run-qlbox.sh and run-basic.sh
also run it in the full suite. Generate fixtures before building changed jobs.

# A15 update

See README.md for the native cargo/debris/collision path and explicit remaining
boundaries. New code is src/cargo.s; tests/cargo_reference.py executes bundled
source through the stated boundaries. A15 logs are current. Blueprint header
size is now38 bytes, with debris mask at36 and all previous offsets preserved.

# A14 update

README.md describes the new pod path, explicit CNT boundary, navigation-only
planet and original missile symbols. Native navigation.s supplies SPS1/SPS3
and MSBAR pixel conversion; tactics.s adds the pod entry at TA15. Stats magic
is EQB4/6800, with planet pointer at114 and pod-count pointer at118.
A14 logs are current; earlier sections below describe inherited milestones.

# A13 update

Current behavior and limits are documented in README.md. Native target.s
adds TAS1/MVT3, friendly missile tactics and FRS1 initialization. Shell T/U/M
state is {inventory,armed,target,internalLaunchFlag}; stats offset110 points
to this four-byte block. Magic is EQB3/6800. A13 logs supersede earlier logs.
The text HUD is an adapter; original missile bitmap drawing is not connected.

# A12 control update

Up/down mapping reversed. Both live BASIC harness runs pass at 128/640 KB,
including expected reversed pitch-rate and ALPHA/BETA signs, damping, speed
limits, combat, enemy missiles, ECM and exit. See A12-BASIC.log.
Only shell mapping and those input expectations change from A11.

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

## A16 release validation

ELITECMD:65536 original STATUS rank results and4096 MA15/q2/MCASH,EXNO2 and
TT100/DLY instruction cases. MESS is an explicit presentation stub. State,
untouched bytes and guards are compared. Run this large-fixture job at640KB.
Both live harnesses verify laser tally, delayed one-time bounty, police FIST,
ECM tally, manifest units, modal freeze/key ownership, exact viewport restore
(including live particles), reset and all prior regressions at128/640KB.
See A16-BUILD.log,A16-INTEGRATION.log,A16-BASIC.log. Screen captures use
injected cargo/tally values to cover every commodity and high-value formatting.
SKIP_REFERENCES=1 allows a regression run after reference generation/rebuild
without regenerating unchanged fixture data. It does not skip diagnostics.

## A17 original-source and connected tests

ELITEEQP:2048 OUCH cases,4096 bomb targets,512 key states,256 expiry values.
ELITECMP:512 source-derived compass projection/full-dashboard hashes, XOR
involution and buffer guards. ELITEPLN:1024 MV40/MULT3/MVT3/MV45 cases including
large coordinates, trajectories and every K2-low input. Raw excerpts are bundled.

equipment_check.h runs under direct-job and BASIC EXEC_W harnesses at128/640KB.
It verifies compass front/rear, station survival,11 bomb kills, one-time tally,
cargo/ECM/scoop/bomb/unit destruction, disabled actions (including a real
canister collision after scoop loss), state/page display and reset. The older
recharge test now sets the authoritative equipment ENGY byte as well as its
status mirror. All inherited viewport/dashboard checks include the compass.
ONLY_EQUIPMENT=1 is an optional focused harness mode; release logs use the full
suite without it. Logs:A17-BUILD/INTEGRATION/BASIC.log.

## A18 original-source and connected tests

ELITEMKT:2048 markets (every economy0..7/fluctuation0..255),2048 transaction/BAD
cases. ELITEDCK:2048 proximity/ISDK/SPS4/failure states. Both compare native
outputs, unchanged inputs and guards. Market transaction decisions use an
adapter that executes original tnpr,LCASH,MCASH,BAD helpers; full TT219 text/UI
is not emulated. Raw source excerpts, Python oracles and generated fixtures
are bundled. Generate fixtures before building.

dock_loop_check.h runs in both direct-job and BASIC EXEC_W harnesses at128/640KB.
First docking uses real approach movement. Re-docking and failure checks inject
station poses; contraband/equipment/ammo cases inject states. Checks cover
market freeze, buy/sell, rejection, persistent stock, commander/cargo/equipment/
ammo preservation, BAD, exact flight/scanner rendering, slow dent, fast crash
and restart. ONLY_DOCK=1 is a focused mode; release logs use the entire suite.
Logs:A18-BUILD/INTEGRATION/BASIC.log. Largest BASIC free block:7680 bytes at128KB,
522752 at640KB. This is an emulator memory result, not real-hardware timing.

## A19 travel

travel_reference.py executes bundled original-travel.asm using the6502 test
interpreter with BIT/BVS and a TT27 digram-output adapter. Corpus:2048 system
seed/name/economy/government/tech records and2048 original SQUA2/LL5 distances.
Nearest IDs are first strict minima over those original-generated records.
ELITETRV checks all records, distance results, output guards,85-tick countdown,
failed starts, frozen destination, fuel/cash, arrival legality and eight galaxy
transitions. Transition checks are source-derived expectations; the full
original UI/Ghy/tunnel is not instruction-emulated. Raw transition excerpts
are also bundled for review.

travel_check.h runs with both job harnesses at128/640KB, checking selection,
page freeze, countdown/pause, commander/cargo/equipment/ammo preservation,
fuel/legal decay, destination market, approach/dock/refuel, launch and Ororra
in galaxy2 with a consumed drive. Initial fighters are disabled to isolate
travel; inherited tests still exercise live combat. Screens use injected cargo
and legal states. The additional market check compares all17 price/stock pairs
against destination economy/fluctuation. Fuel gauge is checked by the full
dashboard oracle. ONLY_TRAVEL=1 runs this focused check.

Release logs:A19-BUILD/INTEGRATION/BASIC.log; A19-TRAVEL.log adds focused checks.
BASIC largest free blocks:5120 bytes at128KB,520192 bytes at640KB.

## A20 equipment and persistence
ELITESHP exercises3072 source-derived transaction states (12 items x16 tech x16
loadouts/cash states), including unsupported docking computers and original
pulse trade-in affordability. It compares all commander, cargo/equipment,
missile, travel and fit bytes. Original EQSHP and ESCAPE excerpts are bundled.
shop_check.h runs under both harnesses at128/640KB: purchase/full rejection,
hold and beam upgrades, bomb/unit/drive replacement, QDOS save/load, corruption
and truncation rejection, launch preservation, live beam heating and escape.
Tests inject cash and technology to exercise expensive equipment; screenshot
credits are fixture values. ONLY_SHOP=1 runs the focused test. Release logs
A20-BUILD/INTEGRATION/BASIC.log cover the combined regression. Test save files
are deliberately excluded from the release.

Final A20:42914-byte job,8330-byte QDOS data space. BASIC largest free block
2560 bytes at128KB,517632 at640KB. Focused A20-SHOP.log also checks loading
a saved commander after resetting all live commander/equipment state.

## A21 chart and SOLAR boundary

universe.s translates SOLAR/ZINF/SOS1 planet workspace initialization; old FIST
bit0 is captured before travel_arrive halves it. Galactic arrival supplies0.
SOS1 type128/130 is returned but not rendered; the planet orientation and
rotation fields are initialized although current movement advances position
only. NWSHP/station placeholder handling and universe population are unfinished.
Chart uses256 original generated seeds, x=s1_hi,y=s0_hi/2 with a32-pixel vertical
offset, native one-pixel stars and clipped current/target crosses. It is a QL
presentation adapter, not original TT22 cursor/star-size/raster equivalence.
ELITEUNI checks4096 source-derived seed/legal/tech cases; travel_check.h checks
the exact chart area against original-generated coordinates in the live job.
Stats magic EQBB/6800; offsets and EQA1 save format remain unchanged.

## A22 ambient encounters (supersedes earlier fixture limitations)

encounters.s translates the TT100/me3 spawning section, MTT4, MTT1, mt1/mt3,
Ze, DORND and BAD from the Electron source. The scheduler runs on MCNT wrap
(every 256 flight updates). Safe-zone presence, asteroid/police counts,
government, FIST, cargo and EV drive the original branch logic. Cobra types5/6
share geometry with separate hunter/trader identities. Incoming carry is an
explicit zero at the shell boundary; NWSHP is a capacity-limited success/failure
adapter, not the original heap/UNIV implementation. The twelve-slot pool remains.

Launch/arrival clears staged fighters and enables ambient traffic. The 0 key
enters an empty deep-space flight scene while retaining commander state; this
is a shortcut through the existing launch adapter, including shield reset.
Station placement is still the approach fixture, not original station creation.
Station record presence controls the spawning safe-zone flag. Per-frame FAROF
removes objects if any unsigned position high byte exceeds224, clears locks,
and allows reuse after rendering cleanup; departures earn no bounty or tally.

Stats magic EQBC/6800 appends pointers190(ambient word),194(eight encounter
parameters),198(total spawned long). Existing offsets and EQA1 saves remain.
The encounter interface emits up to five40-byte records (type word, INWK36,
padding2); output begins with a count word. The shell supplies blueprint energy
and missile inventory on insertion. Encounter state is transient across saves.

ELITEENC executes2,048 deterministic cases against an interpreter of the bundled
original excerpts. NWSHP is hooked for capacity and records, and the loop exits
are stop adapters. RNG, params and all generated INWK bytes are compared.
Live tests inject seeds for trader, asteroid, canister, police, Sidewinder,
Mamba, Python and Cobra hunter paths, then check renderer/scanner, preservation
and FAROF cleanup at128/640KB. ONLY_ENCOUNTERS=1 selects this focused harness.

Game-only generated render_game.s/models_game.s omit the obsolete demo matrix
lookup/table. All live game rendering supplies converted motion matrices.
Benchmarks and renderer diagnostics retain the full original native renderer.

## A23 world integration (supersedes fixture-only station notes)

station.s translates main flight-loop part14, MAS2/MAS1/MVT3/FAROF2 and NWSPS.
MAS2 rejects any nonzero coordinate sign-byte magnitude; candidate coordinates
are planet + 2*nosev using original sign-magnitude arithmetic. All sign-byte
magnitudes must remain zero and each high byte must be <=192 (the code includes
192 despite looser wording in source comments). NWSPS flips all three nose high
sign bits, sets AI1, pitch0 and roll255. Energy/missiles and renderer storage are
supplied by the existing native insertion adapter. Bytes33/34 are zero rather
than Electron line-heap addresses. Planet input is never modified.

Original planet orientation now runs TIDY every16 updates and shares native
MVEIT parts7/8 with ships; position uses the existing full-width MV40 path.
SOLAR arrivals create no station fixture. A station is attempted every32 updates
when absent; allocation failure retries later. Its actual allocated address
controls compass, safe zone and friendly station AI references. Docking is no
longer limited to the old numbered station scene. After docking, normal launch
uses TT110/SOS1/NWSPS planet +65536, station -256, speed12. Key7 still offers the
old aligned approach fixture; key0 is a commander-preserving SOLAR sortie shortcut.

J translates WARP: any present non-asteroid/pod/canister ship or station blocks
it, as do original distance gates for both planet and type129 placeholder.
The placeholder is copied from SOLAR planet coordinates and remains frozen
between jumps; station departure resets it to KS4 coordinates(0,6*65536,0).
Both distance gates run before either body changes. Original ADD with low bytes
0x81 preserves a surprising negative-z high-byte increment of TWO, including
byte wrap; the port follows instructions rather than the simplified comment.
Successful WARP sets MCNT1 and EV0. Ship coordinates stay in the local bubble.
Sound/view-clear is replaced with a brief QL status message; jump input is
edge-triggered and blocked during modal/pause/countdown/dead/docked states.
No witchspace implementation or original packed FRIN allocation is claimed.

Stats EQBD/6800 appends pointers202(world word),206(station AI pointer variable),
210(last jump result word:0 none,1 jumped,2 blocked),214(jump count long),
218(frozen placeholder9). Station AI address minus32 identifies its INWK block.
Existing offsets and EQA1 commander files are unchanged.

ELITESTA compares4096 station cases (1769 eligible),2048 WARP planet primitives,
1024 complete two-body WARP cases and768 shared orientation cases against executed
original excerpts. Launch state is source-derived. Source oracle adapters own
entry/exit, allocation, sound and line-heap addresses. Live tests at both RAM
sizes seed a nearby planet, create a station in slot5, freeze roll after creation
for deterministic alignment, then fly/dock/launch. Travel tests similarly inject
only the nearby planet pose to avoid a long manual approach. Production arrivals
keep SOLAR state and station roll. A23 logs record actual completed regressions.

## A24 planet rendering and altitude (supersedes unrendered-planet notes)

planet_view.s implements PLANET/PROJ/PLS6/DVID3B2 visibility and projection,
original CIRCLE/SNE step selection and segment coordinates, then native QL
clipping/XOR rasterization. Behind, z_sign>=48, or z_sign|z_hi==0 rejects the
planet. Normalized top-byte division and forced odd numerator match the source;
projection magnitude>=1024 rejects it. A nonzero radius high byte selects248.
The Electron draws an outline circle for both planet types. CHKON is replaced
by per-segment native clipping; BLINE/LOIN pixels and line-heap layout are QL
adaptations. At most16 cached segments fit80 bytes (count at12, segments at16),
reusing _render_cache. Pause/modal redraw, reset and launch maintain XOR parity.

ALTIT is computed at MCNT mod32==10 in live-world sorties. MAS2 rejects nonzero
sign-byte magnitude. MAS3 adds each individually truncated unsigned square;
overflow leaves ALTIT255. The result minus37 implements SBC36 with carry clear.
Underflow or zero LL5 result sets death; otherwise the integer square root is
ALTIT. Live LL5 scratch Q is explicitly0; tests cover all256 incoming Q bytes.
The existing native DIL scaling draws ALTIT at AL, y234. ENERGY LOW message and
sound from the adjacent MA22 branch are not implemented here.

Stats EQBE/6800 appends pointers222(planet cache80),226(altitude word).
ELITEPV compares2048 original projection and4096 altitude cases. The interpreter
runs original instruction excerpts with drawing/sound/death exit adapters.
Live checks validate the original radius64 circle endpoints independently,
complete viewport/scanner/gauge pixels, clipped limb, behind erasure, modal
restore, low altitude, scheduled surface death and reset. Positions are injected
for these repeatable tests; production retains original SOLAR/world coordinates.
No new framebuffer or C game loop is introduced. EQA1 saves are unchanged.
