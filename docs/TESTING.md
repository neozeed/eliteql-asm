# A3 validation

The recovered GCC driver/JAS/linker builds all executables. ELITEASM uses only
assembly application sources; C exists in the separate test/benchmark drivers.

`A3-INTEGRATION.log` contains the complete movement, renderer, keyboard,
framebuffer, cleanup and benchmark run. Afterward, final diagnostic tests added
explicit +/-30000 position bounds, signed zero, and hide/re-entry assertions;
both ELITEFLT and ELITETST passed again. Only labels/speed-text formatting then
changed in ELITEASM; `A3-FINAL-SHELL.log` records the final executable's repeated
128/640 KB keyboard, framebuffer and cleanup passes. The performance code path
was unchanged by these diagnostic/presentation edits.

Two distinct instruction corpora test native routines against original 6502:

- Own rotation: 768 cases, 11,904 updates.
- Complete MVEIT parts 3–8: 768 cases, 4,224 updates; random byte states,
  every ALPHA byte, opposing BETA signs, normal scene states, repeated updates,
  byte overflow, negative zero, speed clamps, and arbitrary acceleration bytes.

The latter deliberately includes inputs outside the normal cockpit's rate
range. The oracle runs the supplied source instructions and helper loops; it
does not substitute the native port's formulas. Its implemented CPU subset has
no decimal mode, interrupts or timing. P%+4 branches in these excerpts skip one
two-byte instruction. MVT1-2 and MLTU2-2 resolve to the original immediately
preceding two-byte instruction. No full 6502-machine equivalence is claimed.

Renderer tests retain 52 line/244 scene fixtures and use the A1 scalar renderer
oracle, not original pixels. Cached line heaps are independently rasterized in
the host integration harness and compared against all 24,576 viewport bytes.
ESC restores all 32,768 screen bytes, restores the poll-chain head, and exits
with status zero. INWK is unchanged while paused; pitch/roll counters reach
zero; keyboard tests verify ALPHA/BETA signs, neutral release, and A/Z speed.

Integration waits for actual damping completion with a bounded timeout rather
than assuming that 32 updates fit a fixed number of emulator frames. The first
A3 run exposed that old timing assumption as added motion reduced fleet FPS.

The screenshot sheet shows actual native 128 KB output. The fleet is paused
for stable capture; the FPS readout can therefore include paused time.
Physical QL execution and timing are not verified. Main-loop/AI/TIDY/cockpit
work and the finished game's memory footprint remain outside this milestone.
