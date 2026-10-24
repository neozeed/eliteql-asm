# Source relationship and limits

A1 follows the original Electron LL9 rendering pipeline but is a semantic
adaptation to 68000 word arithmetic, not a completed instruction translation.
It does not yet execute the original main flight loop or MVEIT.

| Original stage | A1 treatment |
| --- | --- |
| LL10 field-of-view/distance rejection | Rejects behind, very near and outside the original 45-degree centre cone |
| XX4 distance classification | `min(31,z/128)`; original blueprint visibility thresholds retained |
| SHPPT far representation | A small two-pixel horizontal mark; not the exact original blob routine |
| LL17 orientation preparation | Expanded Q8 signed matrix from a demo orientation table; no original vector normalization yet |
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

Not implemented: original ship motion, tactics, flight loop, combat, explosions,
laser beams, planet/sun drawing, scanner/dashboard, markets, commander saves,
sound, hyperspace or docking. R3 commander files are not read or written.

The renderer uses a shared scratch workspace and is intentionally non-reentrant.
The only poll callback increments a counter and never calls rendering code.
Positions supplied to A1 must be within +/-30000 and orientations within the
provided 256-entry demo table. The later MVEIT port must supply live per-ship
vectors and will replace this table-driven demonstration interface.
