# EliteQL ASM A24 — visible planets and original altitude checks

A24 draws the live planet and connects original altitude/surface collision logic.
The Electron PLANET path draws a simple circle for both planet types128/130;
it does not draw the equator/crater detail suggested by their type names.

Projection follows original PLANET/PROJ/PLS6/DVID3B2, including the deliberately
approximate top-byte division, forced odd numerator, signed coordinates, distance
rejection,1024-pixel projection limit and248-pixel radius cap. CIRCLE uses the
original SNE values and step8 below radius9, otherwise step4. Final segment
clipping and pixel rasterization use the existing QL backend. This is not a
claim of pixel-identical Electron BLINE/LOIN output.

The planet has an80-byte XOR line cache: old segments erase before new ones are
drawn. It survives navigation/commander-page restore and clears on launch/reset.
There is no extra framebuffer. All gameplay remains native68000 assembly.

The AL gauge now displays original ALTIT. Every32 updates at counter phase10,
MA22/MAS2/MAS3/LL5 logic checks distance, sums individually truncated coordinate
squares, subtracts37 with the original carry rule and computes altitude.
The original radius is24576; crossing the source collision threshold enters
player death, with the existing restart controls. As elsewhere in this port,
the untracked incoming scratch Q for LL5 is explicitly zero in live play;
the diagnostic covers all256 Q values. The adjacent ENERGY LOW message/sound
branch is not newly implemented by this pass.

Use **0** for a commander-preserving deep-space sortie, follow the compass to
find the planet, and use **J** for in-system jumps when clear. **7** retains the
quick aligned station approach. Hyperspace arrivals use original SOLAR placement;
stations spawn from the moving planet's orientation as in A23. Fly toward the
station once the compass changes target rather than continuing into the planet.

The test captures A24-planet.png and A24-planet-limb.png use injected positions
for repeatable visibility and clipping checks. Production uses live positions.
ELITEPV compares2048 projection and4096 altitude cases with executed original
6502 excerpts. Live tests check circle endpoints, edge clipping, behind-view
erasure, exact view restoration, the altitude gauge and collision/restart.

A23 is preserved separately; commander saves remain compatible. ELITEASM is
42,972 bytes plus8,148 bytes QDOS data space. Full direct-job and BASIC EXEC_W
regressions pass at128KB and640KB; BASIC at128KB leaves a2,560-byte largest
free block after startup. Physical68008 timing remains
unmeasured. Release logs are docs/A24-BUILD/INTEGRATION/BASIC/PLANET.log.

Still unfinished: original station traffic/tactics, other views and their
weapons, docking computer, witchspace, sound, stardust and remaining presentation.
The native ship pool, UI and raster backend remain documented adaptations.

