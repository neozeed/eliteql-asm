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
