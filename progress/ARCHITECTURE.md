# RC1 current update

README.md, RELEASE-AUDIT.md and RC1-RESULTS.md supersede the A27 completion list below. Short-range chart/system data and production startup are now implemented. Name search and animated escape flight are absent from the Electron source, not pending features.

# A27 native architecture

ELITEASM links only assembly modules. src/shell.s owns the QDOS job, keys, native
compact production universe, frame cadence and presentation integration. The retained
arithmetic/gameplay modules operate on original byte-shaped state records.

src/dust.s adapts screen access and shared RNG; tools/dust_native.py emits
src/dust_generated.s from tests/original-dust.asm. Translation happens offline.
The game executes straight-line 68000 blocks, not an interpreter. Dead flag
writes are removed using backward liveness; live carry/N/Z remain explicit.
The independent tests/dust_reference.py executes original instructions to
produce fixtures and screen-call expectations.

src/sound.s implements source priority/lifetime/envelope state. sound_poll runs
from normal job code, including waits and tunnels, never the interrupt handler.
It uses QL IPC tone commands and stops playback on expiry/exit. The 24-byte
state preserves software priority channels while driving one physical speaker.

src/screen_store.s measures and bounds word-run compression of the complete
32768-byte BASIC bitmap. The shell chooses compressed storage only when smaller;
otherwise it allocates the raw bitmap. Changed data exceeding the measured
capacity fails safely before changing screen/mode. Exit restores the old mode
and complete saved bitmap, releases the buffer and drains held keys.

src/planet_view.s exposes the original circle geometry for tunnels and the
chart. The chart's step2 cache is144 bytes; planet/tunnel caches are80 bytes.
XOR caches are invalidated at modal/scene transitions. Stardust can redraw its
state without advancing it, preserving pause/modal parity.

Save EQA2 remains148 bytes with EQA1 staged import. The existing native save
format is not the Electron tape format or an atomic file replacement.

## Diagnostic ABI

Magic EQBH/6800. Existing A26 offsets remain unchanged. Added pointers:
250 dust state168,254 dust-valid word,258 snapshot-size long,
262 snapshot-RLE word,266 tunnel-phase word,270 chart cursor2,274 sound state24.
Headers are contiguous; backing state follows them. These are development
interfaces used by the emulated QDOS launch harnesses, not a gameplay API.

Historical architectural notes are in A26-ARCHITECTURE-HISTORY.md.

## RC3 lifecycle, status and configuration

The production shell dispatches a modal flow before normal flight key handling:
0 normal, 1 Cobra/load question, 2 Mamba/ready, 3 load-name editor, 4 save-name
editor, 5 DEATH. Development scene controls remain separate. TITLE uses the
existing native MVEIT/TIDY and renderer, with original z_hi96 approaching1,
z_lo128 and roll/pitch127. DEATH initializes four canisters from Ze/fq1/D1,
including the actual ASL DELTA twice and ROR carry-dependent pitch/killed flag;
then uses existing controls, movement, dust and explosion arithmetic. The
LASCT50 countdown decreases five per update. No C game code or runtime6502
interpreter is linked.

QU5 uses a148-byte in-memory snapshot plus eight-byte commander name. Only a
successful file save or validated load replaces that snapshot. Startup records
the stock default. Restoring resets transient state and selects the current
system as the hyperspace target, corresponding to ping. QDOS I/O accepts a
mutable length-prefixed filename; EQA2 payload size/checksum and EQA1 import
remain unchanged. Named saves use WIN1_<NAME>; empty load-name imports the old
WIN1_ELITESAVE. The accepted name alphabet is a QDOS UI adaptation, not the
original OSWORD RLINE alphabet. Cancel transitions wait for key release.

STATUS uses the native current/target records, fuel, existing rank/legal
routines and equipment/laser state. Its condition check excludes station and
asteroids. The aggregate native pool interpretation remains subject to the
whole-game RNG qualification. Cargo is a separate7 page, closed with6.
FREEZE keeps the screen intact. DAMP/DJD persist through reset, DNOIZ gates new
sound requests and stops the current sound when muted, PATG selects credits,
and FLH is retained as an inert byte exactly as documented for Electron.

Debug header additions are append-only: offsets286,290,294 point to flow_state,
flow_config[4] and flow_name[8]. Previous offsets are unchanged. The old N/dead
production shortcut is superseded by the modal DEATH/BR1 flow. Source excerpts
are retained in tests/original-lifecycle-ui.asm as provenance, not executable
fixture coverage. The initial Ze incoming carry at the text-output boundary
is explicitly clear; whole-game bit-identical RNG sequences are not claimed.

RC3a: at the user’s request, the completed ten-update DEATH animation now
holds its final frame until a fresh Space press. Held Space is release-gated;
other keys are ignored. This is an intentional QL presentation difference from
the Electron timed transition. The subsequent saved-commander flow is unchanged.


## RC4 compact universe

`universe_list.s` holds pure NWSHP/KILLSHP/KS2 bookkeeping. State is 30 bytes:
FRIN[13], padding, BE count at 14, heap usage at 16, 12 byte costs at 18.
Planet logical 0 is external; logical 1 maps to native record 0 and is station
or placeholder; logical L>=2 maps to native record L-1. Native record 11 is unused
in production. The native arrays remain 12 records for legacy development scenes.

Production launch/arrival enables uni_active. Allocation appends and applies
36*(next count)+line heap <=1087, with station's separate LSO budget exempt.
Removal shifts INWK36, render272 and cloud448 blocks and clears the tail. It
remaps every missile with KS2, including the original hostile AI-byte behavior.
The loop uses the changing FRIN count, repeats an index after removal and passes
logical XSAV to cadence tests. Planet/placeholder use full-width movement.

Encounter generation clones the state into uni_plan. en_add commits admission to
that plan immediately, so a failure controls original subsequent RNG/branches;
accepted records are then committed to the live state in the same order. MANY
asteroid/cop counts include explosions until actual removal.

Debug ABI additions: 298 universe state, 302 active flag, 306 current physical
slot, 310 allocation routine, 314 removal routine, 318 current-cloud pointer,
322 model table. These are harness inspection pointers, not gameplay hotkeys.


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
