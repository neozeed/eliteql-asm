# 1.0 RC4 source audit and release boundary

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

## Universe allocation and order: RC4 implementation

Production now uses the original 12-entry FRIN limit, reserved body positions,
blueprint line-heap admission costs and packed removal order. Native storage is
still wider where QL rendering requires it, but extra storage does not grant more
spawns. KILLSHP compacts all three per-ship arrays and resumes the same index.
New children are visible to the current frame's dynamic loop bound. TIDY and
TACTICS receive logical XSAV; station creation remains after the ship loop.
Missiles use logical AI target numbers and exact KS2 remapping. Equal player locks
abort; later locks deliberately retain the original MSTG behavior.

Executed-original tests cover 4,096 allocation/removal operations and all 256
missile AI bytes at ten removal positions. An additional 256 encounter cases
execute the original encounter instructions with the independently verified heap
admission rule. Production harness probes exercise limits, compaction and order;
see RC4-RESULTS.md. These close the identified fixed-pool integration difference,
not a proof of every possible full-game trajectory or shared-RNG boundary.

Other explicit platform boundaries: QL XOR clipping/rasterization and6-pixel
uppercase font, native menus/key mapping, QDOS save format (not cassette format),
clock pacing, and single-speaker tonal approximation of Electron sound.

RC3 ports the BR1/QU5 two-title/restart flow, DEATH four-canister scene, named
QDOS save/load, STATUS fields and keyboard FREEZE/DKS3 settings. N at the title
restores the last successful save/load (default Jameson if none). The death
scene uses native existing movement/explosion/dust modules, rather than a new
physics model. Exact whole-game RNG identity is not claimed: the first Ze
DORND carry across the text-output boundary is explicitly seeded clear, and
sound/text integration qualifications still apply.
DEATH has a bounded ten-update timer from LASCT=50, MA23 subtracting four and
D2 subtracting one. Native rendering/font, QDOS naming and 10 Hz pacing remain
platform adapters. FLH is deliberately inert, as in the Electron source.

## Bounded candidate coverage

The complete playable cycle is present: stock commander, launch, combat,
missiles/ECM/bomb, pods/salvage, travel, station approach/dock, trading/equipment,
save/load, death/restart and escape recovery. Full development regressions test
rare conditions; separate production runs test actual stock startup and travel.
Physical QL testing and a longer human playthrough remain external validation.

RC3a: at the user’s request, the completed ten-update DEATH animation now
holds its final frame until a fresh Space press. Held Space is release-gated;
other keys are ignored. This is an intentional QL presentation difference from
the Electron timed transition. The subsequent saved-commander flow is unchanged.
