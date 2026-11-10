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


## RC5 optional cheats (intentional QL extension)

0 opens the labelled cheat menu in normal production play. Simulation is held
without changing pause state, cached ship images or the current screen selection.
1 adds 1,000 credits; 2 refills four missiles; 3 fits docking computer; 4 refills
the single bomb; 5 fits ECM; 6 fits galactic hyperdrive. 0/Esc returns to the
previous screen with a release gate. Fittings are idempotent, cash saturates,
and an active bomb countdown is preserved. Normal save/load records these ordinary
commander fields. No default equipment, economic prices or Electron combat rules
were changed. This menu is a user-requested extension outside fidelity claims.
The debug header adds cheat_active at offset 326 for harness verification.


## RC5a menu Escape routing

Production menus now route Esc through menu_escape: clear page/shop/navigation/
chart/cheat state, redraw bay market or cached cockpit, and require key release.
In-game filename prompts use the same path; title-load cancellation still returns
to the title. Station-root Esc stays in the bay. Pause state is preserved, and
bare-cockpit/title exit semantics remain unchanged. Cheat key 0 keeps the earlier
return-to-previous-screen behavior. This is an explicit user-requested QL UI fix.


## RC5b deliberate quit (supersedes previous Escape exit notes)

In production, backslash (QL matrix key 0x35) opens a modal QUIT TO BASIC? Y/N
prompt before title, menu or gameplay dispatch. Only fresh Y exits. N/Esc cancels;
other keys are ignored. Opening sets the shared release gate so a preheld Y cannot
confirm. A 2,048-byte saved screen band restores the exact prior pixels; no full
screen allocation is needed. Simulation is frozen; nested menu and pause state
are retained. Debug pointer 330 exposes quit_active for the harness.

All production direct-Escape exit paths are removed, including both titles and
the second flight key scan. Bare-cockpit Esc stays in game; paused Esc no longer
restarts the commander. Menus retain RC5a's root return. Legacy ELITEDEV diagnostic
exit shortcuts are unchanged. This is a deliberate user-requested QL UI policy.


## RC6 live information screens, quantity trading and animated death wait

M%/TT100 continues behind information pages. The native shell now advances the
same movement/tactics/energy/encounter loop, skips LL9/DOEXP at MA26->MA15,
skips STARS, and suppresses target acquisition and laser hit testing. DOKEY's
primary keys remain live; LASLI's energy/temperature/RNG work still occurs for
fire, while LASLI2's drawing is suppressed. Secondary flight actions do not
leak across screen changes. F5, cheat and quit remain explicit modal holds.
Native chart arrow aliases are used for chart selection, not simultaneous pitch.
Arrival on an information page suppresses the tunnel/new star field, restores
the page, and defers new dust creation until the cockpit is entered.

TT167 is exposed on flight key8 without any purchase or sale path. Docked B
opens an ASCII quantity prompt; TT224 stock/tnpr/16-bit GCASH/LCASH checks are
atomic. Native row selection and Esc cancellation remain QL interface choices.

The requested death extension now runs the existing canister movement, TIDY,
explosion and dust updates beyond the initial ten updates. The count saturates
at zero; the fresh-key latch is armed once, so held Space does not restart.

Correction to the old arrival comment: LL164/NOISE/HFS2 do not consume DORND.
TT24's final productivity shift returns carry0 for all 256 relevant seed-bit
combinations, tested from both incoming carries. hyp1 preserves that carry
through its final copies; GVL's explicit zero is therefore justified. Other
shared-RNG qualifications, including the first death-scene text boundary,
remain. This is not an exhaustive whole-game execution equivalence claim.
