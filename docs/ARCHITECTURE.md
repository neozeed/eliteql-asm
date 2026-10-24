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

# A11 update

See README.md for the connected hostile missile/ECM implementation and its
explicit sound-carry, slot-allocation and missing player-missile boundaries.
New native code is src/missile.s; missile_check.h exercises the live application.
ELITETAC adds 1,024 original-instruction homing cases. ELITEMSL adds boundary
tests, not an instruction oracle. A11 logs record the current build.
Stats magic is EQB1/6800; pointers at offsets 102 and 106 expose ECM and launches.

The following describes the inherited A9 implementation and validation.

# Native implementation and next boundary

| Source | Responsibility |
| --- | --- |
| `src/shell.s` | Small QDOS entry point, native keyboard/timer/screen ownership, demo state, FPS text, cleanup |
| `src/render.s` | Visibility, vertex transformation/projection, clipping dispatch and old/new line heaps |
| `src/line.s` | Native segment clipping, packed-word XOR rasterizer and diagnostic screen hash |
| `src/flight.s` | MVEIT parts 3–7 and complete parts 3–8 dispatch; position adapter |
| `src/tactics.s` | Original normal-ship TACTICS, TAS2/TAS3 and scheduling |
| `src/explosion.s` | DOEXP/PTCLS/EXS1/PIXEL and native particle cache |
| `src/combat.s` | Original laser, RNG, hit/damage, anger and player-damage arithmetic; sight/beam geometry |
| `src/dials.s` | Original gauge pixels, shield/energy recharge and laser cooling |
| `src/scanner.s` | Original scanner projection/flags; native dot/stick XOR backend and contact cache |
| `src/dashboard.s` | Generated QL pixels from original P.DIALS.bin |
| `src/controls.s` | Original player rate update, damping, angle calculation and speed controls |
| `src/keyboard.s` | Bounded QDOS character queue draining using IO.QOUT |
| `src/tidy.s` | Original TIDY/NORM vector correction and helpers |
| `src/motion.s` | MVEIT part 8, MVS5/ADD and Q8 adapter |
| `src/models.s` | Expanded Electron data and demo orientation matrices |
| `src/main.c` | Separate benchmark/diagnostic driver, excluded from ELITEASM |
| `tools/extract.py` | Extract all original vertex/face/edge metadata and generate expanded JAS data |
| `tests/reference.py` | Scalar oracle and fixture generation |
| `tests/qlbox_keys.c` | Native keyboard, framebuffer, memory-size and cleanup integration test |

## Renderer ABI

`render_ship(screen, ship)` uses the recovered compiler's 32-bit argument ABI.
It preserves D2–D7 and A2–A6. Its application is equally callable directly from
JAS. A ship is 272 bytes:

| Offset | Bytes | Meaning |
| --- | ---: | --- |
| 0 | 4 | Native model pointer; zero hides the ship after erasing its old lines |
| 4, 6, 8 | 2 each | Signed centre X, Y, Z |
| 10 | 2 | Demo orientation index, low eight bits |
| 12 | 2 | Current cached line count |
| 14 | 2 | Nonzero hides an out-of-range position, after erasing old cached lines |
| 16 | 256 | Space for 64 byte-coordinate line segments |

Twelve ships occupy 3264 bytes. Shared scratch includes 16 face flags, 32 vertex
flags, 32 projected word-coordinate pairs, the reduced camera vector, clipping
endpoints and a few scalar temporaries. The expanded model arrays retain the
original vertex-to-face references that the C prototype had discarded.

The rasterizer clips once per segment. Its inner loop XORs a packed word and
advances a rotating pixel mask and screen address, with no per-pixel function
call, clipping check or multiplication. All flight drawing stays above line 192.
The original dashboard occupies rows 192–247; FPS/speed text uses rows 248–254.

## QDOS ownership

The ordinary relocatable toolchain startup enters `asm_main` through `__Cstart`.
C environment initialization, malloc and stdio are not linked into ELITEASM.
The stack is 2048 bytes. A job-owned 32768-byte MT.ALCHP block holds the old
screen; it is not a drawing backbuffer. Mode changes use MT.DMODE. Keyboard
rows use MT.IPCOM. A linked poll callback increments the 50 Hz counter without
changing data/address registers. ESC unlinks it, restores mode/screen, frees the
snapshot and removes the job with status zero.

The application leaves the second standard screen address alone: 0x28000 is
also the normal QDOS system-variable area. Drawing uses 0x20000 directly.

## Diagnostics

The assembly shell exports a tagged diagnostic state block, beginning with
`EQA9` and `6800`. Relative offsets are frame count 8, timer count 12, startup
largest free block 16, ship count 20, paused 22, model 24, ready 26, snapshot
pointer 28, uncapped flag 32, ship-array pointer 34, INWK-array pointer 38, motion-parameter pointer 42, control-state pointer 46, player-status pointer 50, MCNT-byte pointer 54,
last-drawn slow-instrument status pointer 58, laser-state pointer 62,
scene-hit counter pointer 66, scene-kill counter pointer 70. A9 adds pointers: cloud array 74, AI params 78,
player-dead word 82, scene-mode word 86, shared RNG bytes 90, AI-call counter 94,
enemy-hit counter 98. Integration tests inspect
this block after loading the actual job; the game does not depend on QLBox hooks.

## Expanded blueprint header

The existing 22-byte model header retains its pointers at offsets 10, 14 and
18. A3 appends the original maximum speed as a native word at offset 22.
A8 appends maximum energy at 24, targetable area at 26 and ship type at 28,
all native words. A9 appends weapon/missile byte at 30, explosion count at 32,
and gun-vertex byte offset at 34, expanded to words. Header size is 36 bytes. Cobra geometry is type 5; the
original trader type 6 shares that blueprint but is not spawned in this scene.
Geometry pointers are rebuilt by the extractor; renderer offsets are unchanged.

## Motion ABI and remaining port

`own_rotate(inwk)` updates the original 33-byte little-endian INWK record.
`motion_matrix(inwk, output)` writes nine native signed Q8 words in row-major
side/roof/nose order. Both obey the compiler ABI and preserve callee-saved
registers. The shell reserves twelve full 36-byte original slots,
plus one 18-byte matrix. Rendering is synchronous and non-reentrant: the shell
sets `_live_matrix` for the current ship, renders, then clears it.

`move_ship(inwk, params)` executes parts 3–8. Params are four bytes: ALPHA,
BETA, DELTA and blueprint maximum speed. It preserves the normal C callee-saved
registers and has no global scratch. ALPHA/BETA are sign-magnitude bytes.
`motion_position(inwk, xyz)` returns 1 and writes three native signed words
when all coordinates fit +/-30000, otherwise returns 0. On rejection output
may be partially written and must not be rendered. The shell sets the ship's
hide flag accordingly, without modifying authoritative INWK coordinates.

`tidy_ship(inwk)` preserves D2–D7/A2–A4 and updates the original vector
bytes. Before movement, the shell calls it when `(MCNT ^ slot) & 15` is zero
and `INWK[31] & 160` is zero, following MVEIT part 1 scheduling. A9 adds the normal-ship TACTICS entry.
A6 applies part 9 and SCAN after movement.

`keyboard_drain` reads SV.KEYQ at system variables +0x4c and consumes up to
128 events through the IO.QOUT ROM vector at 0xe2. It does not write queue
pointers. The foreground EXEC_W application drains at each 10 Hz input scan,
including while paused. On exit, it waits for all eight raw key rows to clear,
requires three clear scans separated by polling intervals, then drains again.
The red BASIC screen is restored normally; game characters are consumed.

Next: TACTICS/main-loop integration and the remaining cockpit instruments. The current
33-byte state and exact arithmetic fixtures provide those routines' boundary.
The 128 KB test is a current budget measurement, not a finished-game promise.

## Player control ABI

`control_step(state, keys)` takes two native pointers and preserves D2–D7/A2–A6.
The 13-byte state is JSTX, JSTY, DAMP, DJD, ALPHA, BETA, ALP1, ALP2,
ALP2+1, BET1, BET2, BET2+1, DELTA. Keys are six nonzero/zero bytes in order:
left, right, up, down, faster, slower. Each call applies DOKEY rate changes,
M% part 2 angle conversion/damping, then the speed-key section of part 3.
The active key bytes are sampled at 10 Hz. The shell calls the routine once
per unpaused simulation update, then copies ALPHA/BETA/DELTA to the existing
movement parameters. No 6502 processor state is retained at runtime.

Zero DAMP/DJD means enabled, as in the original. Both are zero in the shell;
nonzero modes are supported and tested but have no UI toggle yet. Neutral
rates are JSTX=JSTY=128. Scene reset starts DELTA at 1. The source's complete
DOKEY scanning/configuration routine and all of M% are not claimed complete.

## Scanner ABI and drawing

`scanner_project(inwk, type, out)` writes four bytes: x, dot_y, base_y,
visible. It returns 0/1 and always clears visible on rejection; other output
bytes are unspecified on rejection. It leaves INWK unchanged. Type is passed
as a 32-bit C argument, with its low byte interpreted like the source TYPE.
`scanner_flags(inwk)` implements the MVEIT part 9 bit-4 update from flags 5/7.

`scanner_xor(screen, projected)` uses a valid projected record and reproduces
the original three-by-two dot and stick pixels in QL white, without calling C
or the viewport-clipped ship rasterizer. No clipping is needed after SCAN's
range checks: all scanner pixels lie within the 256x56 dashboard.

`scanner_frame(screen, slots, count)` accepts 0–12 packed 36-byte INWK slots.
It erases the twelve cached contacts, applies part 9 to each active slot,
projects and plots current contacts, then retains four bytes per slot. The
48-byte cache is private and non-reentrant. The shell currently contains only
ships, so it supplies positive TYPE=1; the public projector tests negative
planet types too. Erasing cached contacts after all motion preserves the final
XOR result of the source's per-ship erase/move/redraw order.

`scanner_reset(screen)` copies the embedded 7,168-byte original dashboard
conversion and clears the cache. Scene resets use it to remove old contacts.
The rest of the frame is incremental; this is not a new full-screen backbuffer.
The compiler-generated C benchmark calls the same scanner once per frame.

## Instruments and status

`energy_step(status, mcnt)` takes a five-byte state: FSH, ASH, ENERGY, GNTMP,
ENGY. It runs the source MA77 recharge section when `(mcnt & 7)==0`, then
cools GNTMP by one unless it is already zero. Shields are charged only when
ENERGY has bit 7 set, aft before forward, with each increment paid from energy.
The subsequent ENGY+ENERGY+1 addition is stored only if it does not overflow.

`dials_frame(screen, controls, status, mcnt)` uses the existing 13-byte control
record. Speed/roll/pitch are redrawn every call; energy banks, shields and laser
temperature only when `(mcnt & 3)==0`. The native backend writes the same bar
and marker pixels as source DIL/DIL2 in the QL format. It overwrites only each
indicator's interior. The 5-byte `_dials_last_status` diagnostic snapshot keeps
the inputs used for the most recent slower redraw, so integration can verify
the displayed values even between refreshes.

The shell now owns an explicit MCNT byte, reset to zero with the scene. TIDY
and recharge use its pre-decrement value; the shell decrements it and draws
the instruments using its post-decrement value. The diagnostic frame total
continues to count upwards independently. Scene setup draws once with MCNT=0
to initialise every supported gauge. The benchmark uses the same sequencing.

Fuel, altitude, cabin-temperature and compass routines are not called with
placeholder inputs. The source's full DIALS tail to COMPAS is not claimed
complete. No combat/damage/firing behavior is simulated to animate the bars.

## Combat ABI and adapter

`laser_fire(laser, status, held, power, entryCarry)` returns 1 on a new shot.
The 12-byte laser state is LASCT, LAS, LAS2, LASX, LASY, four RAND bytes,
a native drawn flag, and two reserved bytes. Status remains the five A7 bytes.
`laser_tick(laser, carry)` executes the original subtract-four-with-carry and
underflow clamp. The shell chooses C=1 explicitly while the source's preceding
spawn/ECM paths remain absent; its LASLI input carry is zero without sound.
The native routines accept unaligned byte-state pointers and preserve the ABI.

`elite_random(seed, carry)` returns A | C<<8 | X<<16 after original DORND.
`laser_hit(inwk, type, targetableArea)` returns HITCH's boolean carry result.
`ship_damage(inwk, power, type)` returns 1 survived, 2 killed, or 3 protected
station. For death it stops at the original flag-store boundary, before debris
and EXNO2. A9 starts an original explosion cloud and increments a diagnostic scene counter;
that counter is not commander TALLY and provides no rank or rewards.
`ship_angry(inwk, type, stationAIbyte)` implements ANGRY with a nullable station
pointer instead of a fixed station slot. Passive test targets start with AI byte zero. Scene 3 starts with byte240
and dispatches the original normal-ship AI.

`player_damage(status, damage, zSign, carry)` returns 0 for shield absorption,
1 at the OUCH boundary, or 2 at the DEATH boundary. It retains original shield
selection, carry-sensitive subtraction, wrapped energy and death conditions.
A9 calls it from original TACTICS/HIT. Cargo damage, the player death animation
and sound remain separate boundaries.

`laser_xor(screen, laser)` and `sight_xor(screen)` are XOR involutions using the
native rasterizer. Scene reset first erases a visible pulse, then the scanner
and ship caches. Sights are drawn once and survive all XOR scene redraws.
A9 exploding records continue movement, skip AI/TIDY, and draw clouds until
DOEXP expires. Fully dead records are hidden. Scanner MVEIT9 clears visibility
for both. Dead slots remain until reset, pending universe removal/compaction.


## A9 tactics and explosion interfaces

`tactics_vector(inwk,out[3])` implements TAS2 using a private K3 copy, preserving
all input bytes. `tactics_dot(inwk,vec[3],offset)` returns the original unsigned
encoding of a 16-bit sign-magnitude TAS3 result (offset10/16/22).
`tactics_due(inwk,type,mcnt,slot)` follows MVEIT part2; missiles are due every
update, but their actual dispatch remains excluded until homing is ported.
`tactics_step(inwk,params[5],rng[4],status[5])` supports types1..6. Params are
TYPE, blueprint max energy, blueprint weapon/missile byte, SSPR, ECMA. Returns:
0 ordinary return; 1 missile request; 2 escape-pod request; 3 shield hit;
4 OUCH/cargo boundary; 5 DEATH. Mutation stops at unported child-spawn calls.
The shell uses SSPR=ECMA=0, records enemy hits and freezes on event5.

Each of 12 clouds occupies448 bytes. Offsets0..54 are the original line-heap
cloud data (size, counter, vertex-count marker, four seeds, projected vertices).
56 is a native particle count; 58 begins up to96 four-byte x/y/ZZ/pad records.
`cloud_advance(inwk,heap)` ports DOEXP counter/size/expiry; `cloud_points(heap,
out,rng,planetZlo)` ports PTCLS/EXS1 and returns record count; `cloud_xor(screen,
points,count)` implements PIXEL's original dash placement and sizes in QL mode8.
`explosion_start(inwk,cloud,model,rng)` initializes LL9 flags/counter/seeds.
`explosion_frame(screen,inwk,cloud,rng)` erases, advances, copies projected
vertices, generates and draws the next cloud. No heap allocation occurs.

Renderer globals `_render_exploding` and `_render_inwk` select explosion
projection and enemy-beam handling for one synchronous draw. `_effect_visible`
and `_effect_vertices` expose current projection results to the cloud adapter.
The native renderer still owns all normal/beam line caches and clipping. The
cloud path projects all vertices, without drawing the old wireframe, and returns
those positions to PTCLS. Reset erases particle caches before clearing them.

RNG points at the existing LASLI state's four bytes; lasers, tactics and clouds
share it. The player-dead and mode words are diagnostic shell state, not new
fields in original INWK. Scene modes0/1/2 mean solo/fleet/hostile encounter.

## A16 commander and modal display

commander.s implements tally, settlement, rank and message-countdown entries.
C ABI arguments are 32-bit slots; commander records must be word-aligned.
Record bytes 0..3=CASH BE32,4..5=TALLY LE16,6=FIST,7=DLY,8=native message
ID,9=padding. The original blueprint bounty is appended at offset38; headers
are now40bytes and preceding fields keep their offsets. Stats magic EQB6/6800
adds commander/page pointers at138/142.

Settlement is reached only after explosion_frame transitions to killed+expired.
Clearing that cloud's source vertex count prevents repeated settlement, and
normal explosion_start repopulates it for reused slots. Page6 pauses simulation
without changing the pause flag. Exit restores line heaps through render_cache,
cloud points through cloud_xor, then the sight and optional live laser. Original
QDOS screen snapshot/poll cleanup are unchanged. Formatting is integer 68000
assembly, including full unsigned32 decimal division using two DIVU.W steps.

## A17 equipment, compass and planet coordinate path

New modules:equipment.s,compass.s,planet.s. All are native68000 and use the
existing QDOS C ABI for testability. The shell now owns contiguous cargo[17]
and equipment[5] in QQ20 order. It gates ECM/scoops/bomb on those bytes and
mirrors ENGY into status[4] before recharge. OUCH is wired only for surviving
shield penetration, not shield-only hits or DEATH.

compass_frame erases its cached dash, computes the planet vector, projects it
and draws a new dash. scanner_reset rewrites the dashboard before a cleared
compass cache is repopulated on scene setup. Page6 does not touch the dashboard.
move_planet uses four split32-bit native multiplies and full sign-magnitude
coordinate sums; no generic6502 interpreter is linked. K2-low is an explicit
third argument. Only the nine position bytes change.

Stats EQB7/6800 retains old offsets and appends equipment ptr146,compass ptr150,
loss counter ptr154. Compass cache:COMX,COMY,COMC,valid. Commander message ID3
selects the formatted destruction message. Equipment page uses four state
indicators; docking computer remains an unsupported zero flag.

## A18 local docking and trading

docking.s implements proximity/ISDK/MA62 checks and returns far/dock/dent/death.
market.s implements QQ23 price/stock arithmetic, buy/sell transactions and BAD.
Market layout is price/4[17],AVL[17]. Commander/cargo layouts are unchanged.
compass_frame now takes a fourth C ABI argument: zero selects planet_vector,
nonzero selects tactics_vector for original SPS4 station coordinates.

The shell's docked state freezes flight and uses edge-triggered market keys.
Dock commit fills shields/energy, clears heat, ECM and laser state. Launch
preserves commander10+cargo/equipment22+remaining-missiles1 bytes around scene
setup, skips market regeneration, clears old XOR caches, and applies BAD.
No replacement ammo/equipment is granted. Station launch pose and fighter
respawn are explicit fixtures. No second framebuffer is allocated.
Stats EQB8/6800 adds docked ptr158,market ptr162,selection ptr166.

## A19 travel and destination markets

travel.s owns a64-byte record: galaxy seed[6],galaxy,current ID,target ID,fuel,
GHYP,countdown,internal countdown,kind,market fluctuation,error,then two24-byte
system records at16 and40. System records contain seed6,economy,government,tech,
name9 and6 padding bytes. Fields are bytes; seed words retain little-endian
layout. C ABI arguments are32-bit stack slots; records must be word-aligned.

Galaxy generation is on demand, avoiding a resident2048-system table. Galactic
nearest search advances the seed four twists per candidate, as TT20 does,
rather than regenerating each system from the galaxy origin. No large heap or
framebuffer was added. RNG storage is byte-copied across arrival to avoid odd
68000 long-word accesses. Only three keyboard rows are scanned for navigation
shortcuts outside its modal page; arrow polling is added inside the page.

Arrival reuses the launch/reset adapter but skips BAD and the behind-player
station pose. It keeps commander,cargo/equipment,ammo and travel record, restores
the RNG, then replaces the market from destination economy/fluctuation. Flight
objects are reset. Docking clears pending countdown. Fuel is drawn through the
new dials_fuel entry using original DILX+2 scaling and the existing DIL writer.
Stats EQB9/6800 appends travel ptr170,nav word ptr174,arrival word ptr178.

## A20 equipment and saves
shop.s implements supported EQSHP transaction effects using PRXS prices and
original technology gate. _ship_fit[4] in cargo.s holds CRGO,forward LASER,ESCP,
padding. Market and scoop capacity consume CRGO; live laser fire consumes LASER.
Scene reset initializes22/15/0/0; local launches preserve all four bytes.
Stats EQBA/6800 adds pointers182(ship_fit) and186(shop word).
save.s performs QDOS IO.OPEN, IO.FSTRG/IO.SSTRG and IO.CLOSE. Shell packs a144-byte
record: EQA1 magic4, checksum4, commander10,cargo/equipment22,travel64,market34,
missiles1,fit4,padding1. Checksum rotates a32-bit accumulator left1 and adds each
of136 payload bytes. Load stages and validates before copying. Save overwrites
a single WIN1_ELITESAVE slot and is not crash-atomic.
ESCAPE state changes are in shop.s; the shell performs native scene/reset and
docked presentation. K is ignored on the commander page, docked or dead.

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
