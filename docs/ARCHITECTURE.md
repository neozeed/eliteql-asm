# Native implementation and next boundary

| Source | Responsibility |
| --- | --- |
| `src/shell.s` | Small QDOS entry point, native keyboard/timer/screen ownership, demo state, FPS text, cleanup |
| `src/render.s` | Visibility, vertex transformation/projection, clipping dispatch and old/new line heaps |
| `src/line.s` | Native segment clipping, packed-word XOR rasterizer and diagnostic screen hash |
| `src/flight.s` | MVEIT parts 3–7 and complete parts 3–8 dispatch; position adapter |
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
`EQA7` and `6800`. Relative offsets are frame count 8, timer count 12, startup
largest free block 16, ship count 20, paused 22, model 24, ready 26, snapshot
pointer 28, uncapped flag 32, ship-array pointer 34, INWK-array pointer 38, motion-parameter pointer 42, control-state pointer 46, player-status pointer 50, MCNT-byte pointer 54,
last-drawn slow-instrument status pointer 58. Integration tests inspect
this block after loading the actual job; the game does not depend on QLBox hooks.

## Expanded blueprint header

The existing 22-byte model header retains its pointers at offsets 10, 14 and
18. A3 appends the original maximum speed as a native word at offset 22.
Geometry pointers are rebuilt by the extractor; renderer offsets are unchanged.

## Motion ABI and remaining port

`own_rotate(inwk)` updates the original 33-byte little-endian INWK record.
`motion_matrix(inwk, output)` writes nine native signed Q8 words in row-major
side/roof/nose order. Both obey the compiler ABI and preserve callee-saved
registers. The shell reserves twelve 34-byte slots (one byte padding each),
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
and `INWK[31] & 160` is zero, following MVEIT part 1 scheduling. TACTICS remains absent.
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

`scanner_frame(screen, slots, count)` accepts 0–12 packed 34-byte INWK slots.
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
