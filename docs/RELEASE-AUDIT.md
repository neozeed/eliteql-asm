# 1.0 RC1 source audit and release boundary

The supplied Electron6502 source is authoritative. Native arithmetic modules
remain supported by executed-original fixture comparisons; no new combat or
economic rules were invented for presentation.

## Corrected plan and release blockers fixed

NA% with Q%=FALSE gives100 Cr, four missiles,70 fuel, front pulse laser and no
purchased upgrades. The former demonstration startup supplied several upgrades
and a galactic drive. Production now clears these, starts docked, and hides the
numbered scenes and live reset/uncap keys. ELITEDEV retains them only for tests.

ESCAPE/ESL1/ESL2 resets cargo/legal status, consumes the capsule, refills fuel and
jumps to BAY. There is no animated escape flight in this Electron source. RC1
removes the previous recovery launch-tunnel detour. QL bay presentation remains
a market/status adapter; it is not an exact reconstruction of all original screens.

TT102 dispatches charts, data, inventory, market, trading/equipment/save actions
and flight controls. Chart actions include D/O and cursor motion through TT16;
there is no system-name search in this source. A prior plan promised one in error.
TT23 and TT24/TT25 were the actual missing chart/data presentation routines.

## Remaining gameplay-relevant fidelity qualification

The original FRIN/UNIV list has12 occupied entries including universe bodies,
compacts in KILLSHP, and places the station in FRIN+1 through NWSPS. The native
shell instead stores planet/placeholder separately from a12-record fixed ship
pool, reuses available slots and keeps direct physical-slot missile references.
Original cadence tests use (MCNT XOR XSAV)&15 for TIDY and &7 for tactics, but
shell XSAV is a physical native slot rather than the compacted original position.
Consequently crowded-bubble capacity, post-removal/new-spawn order, tactic phase
and shared-RNG consumption order can differ from Electron. This is a real
integration difference, not merely a graphical adaptation. The current lifetime
rules prevent missiles/locks retargeting recycled records; those regressions pass.

RC1 does not silently rewrite that ownership model during a presentation pass.
A strict Electron-fidelity1.0 freeze still needs a source-derived universe order
and capacity implementation, with targeted spawn/removal/missile-order tests.
Passing isolated arithmetic fixtures does not establish full-game trajectory
identity. This qualification is why the deliverable is labelled RC1.

Other explicit platform boundaries: QL XOR clipping/rasterization and6-pixel
uppercase font, native menus/key mapping, QDOS save format (not cassette format),
clock pacing, and single-speaker tonal approximation of Electron sound. These
can remain documented1.0 platform adaptations. N after death starts a new default
commander; loading a saved commander is explicit through the equipment screen.

## Bounded candidate coverage

The complete playable cycle is present: stock commander, launch, combat,
missiles/ECM/bomb, pods/salvage, travel, station approach/dock, trading/equipment,
save/load, death/restart and escape recovery. Full development regressions test
rare conditions; separate production runs test actual stock startup and travel.
Physical QL testing and a longer human playthrough remain external validation.
