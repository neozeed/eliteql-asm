# Validation

The final build completed through the recovered QDOS GCC driver, JAS and linker.
ELITEASM contains the assembly shell and renderer. ELITEBEN/ELITETST use the
separate C driver and the same renderer sources.

Native tests, QLBox R7 / JS ROM:

- 52 line fixtures: all octants, endpoint reversal, clipping, boundary pixels,
  packed mask transitions, degenerate and rejected lines.
- 244 renderer fixtures: all ten blueprints, multiple orientations, near/far
  detail, field-of-view rejection and +/-30000 coordinate cases.
- Every rendered fixture is checked against a separately implemented scalar
  oracle, including projected-vertex count, cached-line count and framebuffer
  hash. These check the A1 adaptation, not exact original 6502 output.
- XOR reversal, moving/hiding ships, overlapping caches and patterned-background
  restoration; guard bytes around the test framebuffer remain intact.
- The real assembly application runs at both 128 KB and 640 KB, speed 1.
  Keyboard input exercises pause, model selection, fleet/solo, uncapped mode,
  movement and ESC. At a stable paused frame, an independent host rasterizer
  reconstructs all twelve cached line lists and compares all 24,576 bytes of
  the flight viewport to the actual QL screen.
- ESC restores all 32,768 original screen bytes and the original poll-chain
  head, then removes the job with status zero.
- Renderer-only benchmarks cover 300 frames for one and twelve ships at speed 1.

Raw results are in NATIVE-TESTS.log. The screenshot sheet was visually inspected;
the fleet is paused for a stable capture, so its FPS readout includes paused time.

Run `sh tests/run-qlbox.sh /path/to/qlbox-r7` from the project directory.
The script uses a private temporary mount and never writes commander files.
Generated data and fixtures can be reproduced with tools/extract.py and
tests/reference.py, as described in the main README.

Physical 68008 QL execution and speed are not yet verified. QLBox's 68000 timing
model does not reproduce real external-bus/ULA contention and IPC costs exactly.
The full game, its eventual memory footprint, and original 6502 equivalence are
outside the scope of this renderer milestone.
