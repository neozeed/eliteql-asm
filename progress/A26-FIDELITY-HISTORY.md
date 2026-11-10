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

# A11 update

See README.md for the connected hostile missile/ECM implementation and its
explicit sound-carry, slot-allocation and missing player-missile boundaries.
New native code is src/missile.s; missile_check.h exercises the live application.
ELITETAC adds 1,024 original-instruction homing cases. ELITEMSL adds boundary
tests, not an instruction oracle. A11 logs record the current build.
Stats magic is EQB1/6800; pointers at offsets 102 and 106 expose ECM and launches.

The following describes the inherited A9 implementation and validation.

# Source relationship and limits

A1 follows the original Electron LL9 rendering pipeline but is a semantic
adaptation to 68000 word arithmetic, not a completed instruction translation.
A3 implements MVEIT parts 3–8, including MVS4, MVS5 and their arithmetic; the complete main flight loop is still absent.

| Original stage | A1 treatment |
| --- | --- |
| LL10 field-of-view/distance rejection | Rejects behind, very near and outside the original 45-degree centre cone |
| XX4 distance classification | `min(31,z/128)`; original blueprint visibility thresholds retained |
| SHPPT far representation | A small two-pixel horizontal mark; not the exact original blob routine |
| LL17 orientation preparation | A2 live INWK vectors converted to Q8; legacy table retained only for regression tests; no original LL9 normalization yet |
| LL90 centre reduction | Reduce signed coordinate magnitudes until Z fits a byte before local-camera conversion |
| EE29 / LL89 face visibility | Source face distances and normals; model-local camera/normal-plane test using native MULS |
| LL48 vertex visibility | All four original face associations and original vertex distance retained |
| LL49..LL60 vertex projection | Native MULS/DIVS, 256 focal scale, centre (128,96), near Z clamped to 4 |
| LL75 edge selection | Original edge distances, adjacent faces and blueprint line cap |
| LL147 / LL118 clipping | New native Cohen–Sutherland clipping to 256x192; not original gradient arithmetic |
| LL80 / LL155 line heap | Four byte endpoints per retained segment; XOR erase using old heap, then draw new heap |
| LOIN / LL30 rasterization | New 68000 major-axis integer line loop adapted to QL mode-8 packing |

The original packed ship geometry is expanded into word records. The face-plane
constant is derived from the original normal and normal scale. Camera reduction
keeps intermediates bounded; matrix products retain native word precision and
round differently from the original sign/magnitude products. Projection also
retains more precision than the original common 8-bit reduction. Native lines
include both endpoints, so shared endpoints follow this rasterizer's XOR rules.

The independent Python oracle checks this documented A1 adaptation. It is not
an oracle obtained by running the original 6502 program. Passing these tests
establishes consistency and bounds for A1, not original pixel-for-pixel identity.

Not implemented: missile/pod/station tactics and universe spawning, planet movement (MV40), secondary keyboard controls/configuration, the rest of the flight loop,
 planet/sun drawing, fuel/altitude/cabin-temperature/compass instruments, markets, commander saves,
sound, hyperspace or docking. R3 commander files are not read or written.

The renderer uses a shared scratch workspace and is intentionally non-reentrant.
The only poll callback increments a counter and never calls rendering code.
Positions remain bounded to +/-30000. A non-null `_live_matrix` supplies nine
native signed Q8 words for the current render call; null selects the legacy
angle-table path. Matrix storage must remain valid through the synchronous call.

A3 movement fidelity is checked by `tests/flight_reference.py`, which executes
the bundled original instructions for MVEIT parts 3–8, MVT1, MVT6, FMLTU,
MLTU2, MVS4, MULT1, MAD, ADD and MVS5. Native 68000 multiplication replaces
shift/add loops but retains their externally observable byte/sign/rounding
behavior. All 33 state bytes match in the 768 tested cases. The original A2
own-rotation corpus is also retained as an independent narrower regression.

A5 obtains ALPHA/BETA from the original DOKEY rate updates and M% part 2.
The QL scan replaces Electron hardware access; arrows map to the four source
pitch/roll keys, A/Z to speed. DOKEY's pause/configuration and secondary keys
remain unported. The scene itself is test scaffolding. A4 implements TIDY
dispatch from MVEIT part 1; A9 implements normal-ship TACTICS; A6 implements the SCAN/part 9 path.

Original positions have 23 magnitude bits plus sign. The renderer adapter
rejects magnitudes above 30000; the original position remains untouched and
continues updating. A range rejection erases its old line cache, so a returning
object can be redrawn without stale lines. This is a renderer interface limit,
not a new game-world boundary.

The simulation runs once per drawn frame. There is no invented delta-time
physics, collision, respawn, AI, combat or save behavior.

A4 TIDY uses original high-byte vectors, dominant-coordinate selection,
normalization, roof correction and side-vector cross products. NORM uses an
integer square root with the same floor result as LL5; byte division retains
shift overflow and source rounding. MULT1 zero-Q sign behavior is retained.
The Electron routine clears vector low bytes at INWK 9 through 23 (odd
indices), but leaves INWK 25 unchanged; this port deliberately does the same.
The independent source-instruction oracle checks all 33 bytes in 512 direct
cases and 24 trajectories with scheduled TIDY and movement.

A5 control fidelity includes the carry from the roll CMP #8 that survives cntr
and affects pitch ADC #4, neutral pitch's signed zero, and both configuration
flags. REDU2 retains the exact-zero result when subtraction lands on zero;
its underflow path alone clamps to 1. Likewise, slowing DELTA=0 wraps to 255
in the original routine: the oracle tests this, while the normal shell starts
at DELTA=1. Simultaneous opposing keys run in original order. These are source
behaviors, not substituted idealized control formulas.

A6 scanner geometry follows SCAN, including the high-byte range rejection,
negative-zero X offset (124 instead of 123), integer shifts and dot-Y clipping
to 194–246. The QL backend preserves source CPIX4/CPIX2's three-by-two dot;
the annotated source's wider-dot description is not substituted for its
instructions. Upward sticks run from dot_y-2 to base_y-1, while downward
sticks run from dot_y+1 to base_y, retaining the source's asymmetric endpoints.

The source-instruction oracle executes the original Electron screen-address
calculation, dash and stick stores. Only its resulting pixels are converted
to QL words for comparison. The test checks geometry and framebuffer hashes
for 512 cases, plus all visibility flag values. Separate integration tests
compare the complete dashboard byte-for-byte. The original artwork is decoded
from P.DIALS.bin; it is not a recreated or AI-generated dashboard.

A7 adds live speed, roll, pitch, shields, energy banks and laser-temperature
indicators. Fuel, altitude, cabin temperature, compass and missile state remain
unconnected. FPS/speed text is a diagnostic overlay below the original bitmap.

A7 DIALS ports parts 1–3 and the shield and laser-temperature sections of part
4. The native backend reproduces DIL's 32-pixel three-row bars and DIL2's
16 two-pixel positions over four rows. It follows actual instructions rather
than inconsistent range/width comments in the annotated source.

In particular, DIL2 jumps through NEXTR, whose final ADC clears carry at the
actual dashboard address. The subsequent pitch SBC #1 therefore subtracts TWO
when BET1 is nonzero. This can blank the marker at some small pitch values;
it is an original source behavior, not a new intended control rule. The pixel
oracle executes that path and checks the resulting display.

Recharge is the MA77 section of main flight loop part 13, including the
SHD/DENGY effects. Laser cooling comes from MLOOP. Their tests cover the 127/128
energy threshold, full shields, energy-unit values, saturation, rejected
addition on carry, and sequential updates. Status begins with RES4's full
shields/energy; A8 connects original laser heating and drain; A9 connects OOPS player damage
to original enemy laser HIT. Collisions remain unported.

A7 also corrects the scheduling phase: original MCNT decrements after the
flight loop and before DIALS. Earlier milestones used the increasing frame
total for TIDY's periodic test. The corrected counter preserves the original
slot schedule, with refreshed instruction-oracle trajectories.


A8 combat ports original MA68/ma1, LASLI arithmetic, DORND, HITCH (including
SQUA2/MU11 results), MA47 through its killed-bit boundary, ANGRY and MLOOP's
laser countdown. Blueprint targetable area and maximum energy are extracted
from the supplied source. Exact-zero energy survives; underflow kills except
for the station. HITCH ignores x/y sign bytes but rejects any nonzero z_sign,
nonzero x/y high byte, exploding flag or negative type. Overflow of the sum
of squared coordinate low bytes rejects a hit. It is not a screen-space test.

OOPS is translated and tested through its OUCH/DEATH call boundaries, including
the incoming carry. A9 connects it to enemy laser hits, dispatches normal-ship
TACTICS and replaces immediate target removal with original explosion clouds.
Debris, EXNO2 rewards/tally and sound remain unimplemented. ANGRY changes the
original state; active AI is dispatched in encounter mode.

The full original surrounding loop determines incidental carry through sound,
spawning and ECM. Those sections are absent here. LASLI gets explicit C=0 and
MLOOP gets explicit C=1 in this shell; this limitation is not hidden as full
instruction equivalence. Both carry values are supported in DORND/countdown
and tested. SIGHT/LASLI2 endpoint geometry uses the native line backend above,
including its inclusive endpoints rather than original HLOIN/LOIN pixels.


A9 supersedes the earlier combat boundaries above for normal-ship tactics,
enemy laser hits and explosion particles. TACTICS parts2–7 execute for types1–6,
including original low-energy decisions, but SFRMIS and SESCP remain external
events. The scene does not spawn the requested missile/pod. Station spawning,
missile homing, escape-pod planet navigation, cargo loss, sound and the original
player-death animation remain unported. A shell DEATH latch freezes the test
encounter and permits reset/exit. This is explicitly not the original death
presentation, and the wrapped ENERGY value on fatal underflow is retained.

DOEXP/PTCLS/EXS1 uses original arithmetic and per-vertex reseeding. Its PIXEL
backend matches original Electron stores converted to QL pixels, including the
asymmetric horizontal dash placement and row choice at character boundaries.
The original loops draw U+1 particles per vertex, not U. Far clouds increment
the counter by5 (retained CMP carry), near clouds by4. EXS1's positive branch
adds one because FMLTU returns carry set; the negative branch has no extra unit.

The native projection remains an adaptation and supplies the cloud vertices.
Original DOEXP initialization is ported with an explicit first RNG carry of0.
The missing planet contributes z_lo0 on PTCLS exit. Cached erase avoids rerunning
PTCLS: this preserves pixels but can change incidental RNG state when an old
cloud is erased without a new visible cloud being drawn. No equivalence to the
complete game's global RNG sequence, memory layout or timing is claimed.
Enemy-beam endpoints follow LL9 part9 while using the established native clipper.

## A16 commander integration

Original EXNO2 tally, MA15/q2 settlement, MCASH and STATUS rank branches now
execute in src/commander.s. Bounty is settled once at native explosion expiry,
including collision explosions; scoops have no explosion and no reward.
DLY gates payment and a zero low bounty byte suppresses it, as in the source.
Tally is incremented at laser and TA35 sites, not for hostile TA34 impacts or
collisions. Fixed-slot invalidation is not an original TA35 execution.

CASH is BE32 tenths, TALLY LE16; both preserve wrapping arithmetic. Original
rank thresholds are tested for every possible tally. MESS is a 22-tick
presentation boundary, not the original text engine; other message sources
remain disconnected. Scene resets initialize 100.0 Cr/zero tally/clean status.
Commander values are not saved and do not survive resets. This overrides older
notes describing all rewards/rank as absent.

The 6-key page is a native modal display with all seventeen stocks and original
commodity units. It clears only the viewport and restores cached drawing with
no simulation step or extra framebuffer. Exact source STATUS layout, condition,
system names and equipment listing are not claimed. OUCH remains unconnected.

## A17 equipment and planet corrections

OUCH, MA24/MA18 and bomb ship eligibility are translated in equipment.s.
The 22-byte original QQ20 layout includes cargo plus ECM/BST/BOMB/ENGY/DKCMP.
Surviving OOPS energy damage returns through the shared native OUCH adapter
from enemy lasers, missiles and collision paths. Missing EXNO3 sound supplies
explicit DORND carry1; whole-game RNG sequencing is not claimed. Destruction
messages share DLY with commander rewards. Bomb kills tally once; stations
and already exploding records are immune. Passive/fighter scenes start with
one fitted bomb, an explicit test-loadout choice. Existing active ECM is not
cancelled on loss; subsequent activation is blocked.

SPS2/SP2/DOT/CPIX2 now draws the planet compass with exact original pixel
results translated to QL words. Only the planet target is supported; no station
safe-zone selector. DVID4's unused fractional-return path is a clear-carry
oracle boundary, while its integer quotient executes original instructions.

MV40/MULT3/MVT3/MV45/MVT1 now advances planet coordinates instead of the
ship-only 16-bit rotation path used in A14–A16. That older planet update could
lose high coordinate bits. The new entry is tested against1024 original cases
and trajectories. K2-low is explicit and shell supplies0; original incidental
shared scratch state is not recreated. Planet orientation/rendering remains
absent. This supersedes earlier claims that the old planet movement was fully
original player-relative movement. Ship movement itself is unchanged.

## A18 docking/market boundary

Original proximity, ISDK/SPS4 and MA62 speed gates are translated in docking.s.
Successful docking returns through a native docked-state transition, not the
original tunnel animation. market.s uses original QQ23 entries, economy and
fluctuation arithmetic, byte wrapping, negative quantity clamping and AVL16=0.
Buy-one uses tnpr/LCASH rules; sell-all follows TT210, leaves AVL unchanged and
retains the original 16-bit GCASH product wrap. BAD retains ASL carry into ADC
and ORs the result into FIST.

Only economy5/fluctuation0 is live. No galaxy seed or market reroll is claimed.
Station orientation/position, launch coordinates and encounter regeneration
are native fixtures. Station compass uses SPS4 but its selection is scene-based,
not SSPR. Cargo, cash, tally, legal status, ammo and equipment persist across
local launch; universe objects do not. N and scene keys are still resets.
The docked market UI and per-key single-unit buying are presentation adapters.

## A19 universe arithmetic and adapter boundaries

All eight galaxies derive from4A5A480253B7 in original byte order. TT20 performs
four TT54 twists per system; cpl uses three/four digrams, skips pair0 and omits
the '?' character. TT24 government fixes anarchy/feudal economy and rounds
government/2 upwards when adding tech. Displayed tech is native value+1.
Distance uses floor(abs(dy)/2), square/sum modulo65536, floor square root, then
multiplies by4; it is not floating-point Euclidean rounding.

Normal hyp requires nonzero distance and adequate fuel. TT107 takes85 update
calls from wW to arrival. SOLAR's LSR FIST is retained. Ghy uses Superior's
nearest(96,96), not Acornsoft's random destination. Nearest score is
floor(abs(dx)/2)+floor(abs(dy)/2), first strict minimum; galaxy number wraps8.
Native tests cover all eight transitions. GHYP is consumed at start; seed,
location and legal updates commit on arrival, an explicit timing adaptation.

Market GVL uses existing DORND with explicit input carry0; complete original
RNG/sound sequencing is absent. Local launch keeps market stock, hyperspace
regenerates it. Refuelling uses PRXS=(70-QQ14)*2 tenths and original affordability
semantics. One galactic drive is a test-loadout grant, not a normal new commander
equipment claim. It cannot yet be purchased again in the UI.

Arrival geometry, fighters, modal directory and station selection are QL/test
adapters. SOLAR universe placement, actual charts, tunnel, planet rendering,
witchspace, equipment shop and disk saves remain absent.

## A20 equipment/escape/save boundary
PRXS prices and EQSHP tech range are original. Duplicate/full purchases validate
before debit, matching the final state of original eq/pres charge/refund. Beam
requires gross affordability then refunds pulse400Cr. Only forward lasers are
connected. Docking computers remain unavailable; no charge is possible.
CRGO22/37 values are retained and used by original tnpr for buying and scooping.
ESCAPE/ESL2 cargo/legal/pod/fuel effects are translated; RESET/RES4 uses the
native scene/docking adapter. Credits, tally, other equipment and missile stock
are preserved. No escape animation or sound is added.
QDOS commander files and checksum are native adapters, not original cassette
format. Universe/encounter generation and original SOLAR geometry remain absent.

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

On the underflow collision branch ALTIT remains255, as in the original
(initialized before the distance check); only a zero LL5 result leaves ALTIT0.
Both death paths are compared including their altitude byte.
