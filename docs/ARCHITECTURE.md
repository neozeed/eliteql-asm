# RC1 current update

README.md, RELEASE-AUDIT.md and RC1-RESULTS.md supersede the A27 completion list below. Short-range chart/system data and production startup are now implemented. Name search and animated escape flight are absent from the Electron source, not pending features.

# A27 native architecture

ELITEASM links only assembly modules. src/shell.s owns the QDOS job, keys, native
fixed ship pool, frame cadence and presentation integration. The retained
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
known universe-order qualification. Cargo is a separate7 page, closed with6.
FREEZE keeps the screen intact. DAMP/DJD persist through reset, DNOIZ gates new
sound requests and stops the current sound when muted, PATG selects credits,
and FLH is retained as an inert byte exactly as documented for Electron.

Debug header additions are append-only: offsets286,290,294 point to flow_state,
flow_config[4] and flow_name[8]. Previous offsets are unchanged. The old N/dead
production shortcut is superseded by the modal DEATH/BR1 flow. Source excerpts
are retained in tests/original-lifecycle-ui.asm as provenance, not executable
fixture coverage. The initial Ze incoming carry at the text-output boundary
is explicitly clear; whole-game bit-identical RNG sequences are not claimed.
