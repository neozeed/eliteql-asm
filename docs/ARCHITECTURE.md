# Native implementation and next boundary

| Source | Responsibility |
| --- | --- |
| `src/shell.s` | Small QDOS entry point, native keyboard/timer/screen ownership, demo state, FPS text, cleanup |
| `src/render.s` | Visibility, vertex transformation/projection, clipping dispatch and old/new line heaps |
| `src/line.s` | Native segment clipping, packed-word XOR rasterizer and diagnostic screen hash |
| `src/flight.s` | MVEIT parts 3–7 and complete parts 3–8 dispatch; position adapter |
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
The shell's static/footer region occupies rows 196–250.

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
`EQA3` and `6800`. Relative offsets are frame count 8, timer count 12, startup
largest free block 16, ship count 20, paused 22, model 24, ready 26, snapshot
pointer 28, uncapped flag 32, ship-array pointer 34, INWK-array pointer 38, motion-parameter pointer 42. Integration tests inspect
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

Next: original TIDY and its scheduled dispatch, followed by the original
keyboard response, TACTICS/main-loop integration and scanner. The current
33-byte state and exact arithmetic fixtures provide those routines' boundary.
The 128 KB test is a current budget measurement, not a finished-game promise.
