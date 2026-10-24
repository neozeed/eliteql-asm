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

Not implemented: MVEIT parts 1–2 and 9, TIDY, planet movement (MV40), original keyboard response, tactics, flight loop, combat, explosions,
laser beams, planet/sun drawing, scanner/dashboard, markets, commander saves,
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

Input ALPHA/BETA bytes are supplied directly; deriving them from the original
keyboard controls is not implemented. The demo's scene and control mapping are
test scaffolding. MVEIT's TIDY/TACTICS/SCAN dispatch is not stubbed and claimed
complete: those surrounding parts are explicitly absent.

Original positions have 23 magnitude bits plus sign. The renderer adapter
rejects magnitudes above 30000; the original position remains untouched and
continues updating. A range rejection erases its old line cache, so a returning
object can be redrawn without stale lines. This is a renderer interface limit,
not a new game-world boundary.

The simulation runs once per drawn frame. There is no invented delta-time
physics, collision, respawn, AI, combat or save behavior. Without the original
periodic TIDY, prolonged turns can accumulate vector drift; reset the scene.
