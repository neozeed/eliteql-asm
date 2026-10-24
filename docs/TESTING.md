# A8 validation

The recovered GCC driver/JAS/linker builds all ten executables. ELITEASM uses
only assembly application sources; C is confined to diagnostics and benchmarks.

`A8-INTEGRATION.log` records the final build's movement, TIDY, renderer,
keyboard, framebuffer, cleanup and benchmark passes under QLBox R9 / JS ROM.
`A8-BASIC-EXIT.log` records actual BASIC EXEC_W launches at 128 KB and 640 KB.
The BASIC harness sends a burst of printable game keys, checks that BASIC is
suspended, then verifies the QDOS character queue is empty before and after
Escape. It also checks job cleanup and restores the poll-chain head.

The instruction corpora test native routines against original 6502:

- Instruments: 512 framebuffer-hash cases execute the original DIALS, DIL,
  DIL2, ADD and NEXTR instructions into an Electron framebuffer, then convert
  the final pixels to QL words. They cover both signs, zero, bar limits and
  the every-four-updates slow-instrument gate.
- Recharge/cooling: 2,048 state cases and 1,024 sequential updates execute
  original MA77, SHD/DENGY and the MLOOP cooling section; all five bytes match.
- Scanner: 512 geometry/framebuffer cases cover positive/negative coordinates,
  signed zero, both stick directions, dot clipping, range rejection, planets,
  visible/hidden flags, and dots across character boundaries. All 256 flag
  bytes are checked against original MVEIT part 9. Native XOR drawing is
  applied twice to verify exact erasure; guard bytes protect projected output.
- Controls: 2,048 cases cover every raw JSTX/JSTY byte with damping and
  auto-recentre enabled/disabled, arbitrary state, simultaneous keys and speed
  edges. A further 1,024 sequential updates cover hold/reversal, random input,
  acceleration, braking and neutral decay. All 13 state bytes are compared.
- TIDY: 512 direct cases, including arbitrary bytes, axis-aligned vectors,
  zero vectors and the retained INWK 25 low byte; 24 scheduled trajectories,
  5,248 movement steps, including exploding/killed flags that skip TIDY.
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
zero; keyboard tests verify accumulated rates, ALPHA/BETA signs, damping to centre,
A/Z clamps at 1 and 40, and Escape waiting for held game-key release.

Integration waits for actual damping completion with a bounded timeout rather
than assuming that 32 updates fit a fixed number of emulator frames. The first
A3 run exposed that old timing assumption as added motion reduced fleet FPS.

The screenshot sheet shows actual native 128 KB fleet output, a frozen pulse,
a hot laser and BASIC after the printable burst and exit, with no leaked game characters. The fleet is
paused for capture; its FPS readout can include paused time.
Physical QL execution and timing are not verified. Main-loop/AI/cockpit
work and the finished game's memory footprint remain outside this milestone.

The BASIC harness allows BASIC to redraw after exit, so its screen is not
compared byte-for-byte. The headless integration harness checks exact screen
restoration. These tests do not reproduce every ROM or physical keyboard.

`controls_reference.py` executes the separately bundled original control
instructions, including their flags. It resolves P% jumps and label+byte
entries using instruction byte positions. Its instruction subset is separate
from the movement oracle. Fixture expected values are not generated using
native port formulas. `ELITECTL` checks both standalone cases and a continuous
sequence; guard bytes catch writes past the 13-byte state.

The A7 benchmark also invokes control_step once per frame. It disables damping
with JSTX=136/JSTY=127 to reproduce fixed ALPHA=1/BETA=0 and DELTA=0 for the
same movement trajectory as A4; these are benchmark settings, not shell defaults.

A7 integration reconstructs the dashboard directly from the bundled 1,792-byte
Electron asset, independently plots the live contact records, and compares
all 7,168 QL bytes. It marks one ship as exploding and moves another beyond
scanner range, then verifies stale contacts are removed. These checks run
through the native application at 128 KB and 640 KB, including BASIC EXEC_W.
The scanner oracle executes original instructions and framebuffer writes;
it does not call the native geometry or pixel formulas to derive fixtures.
The A7 benchmark includes live scanner erasure, flags, projection and drawing.

A7 integration reconstructs the original background and contacts plus all
supported gauges and compares every dashboard byte. The slow-instrument input
snapshot accounts for their original four-update cadence. A separate live
sequence sets depleted shields, 128 energy, an energy unit and a warm laser,
then verifies each resulting status byte against the number of actual updates
and initial MCNT. It checks MCNT decrements and that pause freezes status.
Both BASIC-launch and headless integration pass at 128 KB and 640 KB.

The scheduling trajectories now use `(-frame) & 255` to model the original
countdown. The final benchmark includes recharge, cooling and gauge drawing
as well as the scanner, movement, TIDY and ship renderer.

`A8-BENCHMARK.log` records completed 300-frame runs for both scene sizes,
with the expected result line checked in addition to the runner exit code.


A8 adds `ELITECBT` and `combat_reference.py`. The latter executes bundled
original instructions with explicit external-call/stop boundaries. It contains
no native combat formulas. Cases cover 1,024 DORND states with both carry
inputs, 2,048 HITCH cases (including edge equality, overflow, signed coordinate
bytes and exclusions), 1,024 target damage cases, 512 ANGRY states, 2,048 OOPS
cases, 1,024 firing cases (pulse, beam, absent weapon, heat and energy limits),
and every LASCT byte with both incoming carries (512). Total: 8,192 cases.
The native test also runs 2,048 held-fire updates to check thermal inhibition
and recovery, unaligned byte buffers, guard bytes and XOR erase behavior.

`combat_check.h` extends both real-job harnesses: a 70-energy Sidewinder must
survive four 15-point hits and die on the fifth; death removes both its wireframe
and scanner contact. Off-axis shots must leave target energy unchanged. A station
at zero energy must survive repeated hits and acquire hostility. Pause freezes
firing, and resetting a frozen visible pulse must erase every old laser pixel.
A long held-fire run checks the live heat limit as well. All viewport bytes are
reconstructed from ship caches, sight geometry and active laser endpoints, and
all dashboard bytes are checked independently. `A8-LIVE-COMBAT.log` records the
extended headless thermal runs; BASIC repeats the same checks through EXEC_W.

The benchmark uses no active fire: it includes idle laser dispatch and the pulse
counter in addition to previous components. 300 frames complete in 280 ticks
solo (53.5 FPS), or 1806 ticks for twelve ships (8.3 FPS), under QLBox R9 speed 1.
The original geometry counts are unchanged: 3,690/4,637 vertices/lines solo,
29,990/39,974 fleet. This is not real-68008 timing or a complete-combat benchmark.
