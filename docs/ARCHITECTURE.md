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
