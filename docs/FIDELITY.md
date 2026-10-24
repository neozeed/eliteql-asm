# Source relationship and limits

A1 follows the original Electron LL9 rendering pipeline but is a semantic
adaptation to 68000 word arithmetic, not a completed instruction translation.
A2 adds MVEIT part 8, MVS5 and ADD; the complete main flight loop is still absent.

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

Not implemented: MVEIT parts 1–7 and 9, TIDY, player rotation, position updates, tactics, flight loop, combat, explosions,
laser beams, planet/sun drawing, scanner/dashboard, markets, commander saves,
sound, hyperspace or docking. R3 commander files are not read or written.

The renderer uses a shared scratch workspace and is intentionally non-reentrant.
The only poll callback increments a counter and never calls rendering code.
Positions remain bounded to +/-30000. A non-null `_live_matrix` supplies nine
native signed Q8 words for the current render call; null selects the legacy
angle-table path. Matrix storage must remain valid through the synchronous call.

A2 motion fidelity is tested separately by executing the bundled original 6502
instruction excerpt in `tests/motion_reference.py`. Its 768 fixtures compare
all 33 INWK bytes after one or multiple calls against `src/motion.s` on QDOS.
The native matrix adapter is also checked for every fixture. No claim is made
that the Python subset interpreter is a complete 6502 emulator.

The demo seeds finite counters and stops when they damp to zero. The benchmark
uses counters 127/127 and executes 300 updates without TIDY. This is sufficient
to exercise this port boundary, not a substitute for the original periodic
vector normalization needed by a complete flight loop.
