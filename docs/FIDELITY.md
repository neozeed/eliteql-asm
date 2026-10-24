# RC1 current update

README.md, RELEASE-AUDIT.md and RC1-RESULTS.md supersede the A27 completion list below. Short-range chart/system data and production startup are now implemented. Name search and animated escape flight are absent from the Electron source, not pending features.

# A27 fidelity and remaining work

The source of authority is the supplied Acorn Electron Elite disassembly, not
features from other Elite releases. SOURCE-PROVENANCE.txt identifies it and the
bundled excerpts. A27 adds actual Electron features; no alien encounter or
mission system exists in this source to port.

## Source-derived mechanics added in A27

STARS1, STARS6, STARS2, FLIP, nWq and their arithmetic helpers determine the ten
particles (NOST=10). The generated native instruction blocks retain explicit
6502 carry and live N/Z state. The QL PIXEL adapter retains the Electron dash
shape, including near-particle row selection and the negative-zero y case.
Unused capacity in the 19-entry arrays is not additional visible stardust.

HFS2/HFS1/HFL1/HFL2 generate two passes over starting radii 8..15, doubling each
radius while below160. LAUN uses step8; LL164 uses step4. Native circle endpoints
use the existing original SNE geometry. QL XOR clipping and two-tick group pacing
replace Electron display hardware and timing.

TT123 controls byte cursor movement, including rejected signed overflow. TT111
selects the first strict minimum of floor(abs(dx)/2)+floor(abs(dy)/2). The chart
uses original seed coordinates, y=24+(galaxy_y>>1), PIXEL dash placement, crosshair
sizes and fuel radius=fuel>>2. D selects, O moves the cursor home and C returns to
the data page. Long-range chart geometry is source-derived; the surrounding
text layout and key mapping are QL adaptations.

NOISE/NO3/SFX/SFXL supply sound event blocks, priority decisions and software
lifetime gates. Actual source NO3 indexes SFX2 with 0,8,...72, not 0..9: the
bundled 73-byte addressed region retains the resulting priorities
112,240,42,162,162,134,133,169,135,57. This apparent original indexing mistake
is preserved rather than silently repaired. The loader's four E% pitch envelopes
supply pitch steps/repeats. The QL IPC single speaker approximates those pitches;
channel0 noise and the Electron ULA waveform are not reproduced. QLBox output
and physical QL audio should not be assumed identical.

M% reseeds RAND[0] from planet x_lo. STARS consumes shared RNG before DLY/MCNT and
encounters; encounter return carry reaches the laser lifetime calculation.
Sound acceptance carry also reaches laser and OUCH paths. Warning/messages use
the source22-tick duration. The QL message region differs from the Electron
text screen; current-cash bounty output follows source token0 semantics.

## Retained source-derived systems

Existing native modules cover ship movement, steering, tactics, missiles, ECM,
energy bomb, damage, cargo/scooping, escape pods, bounty/tally/legal state,
markets and equipment, galaxy seeds/travel, planet projection/altitude,
station generation/rotation/police/docking and four-view laser fittings.
The Electron docking computer immediately takes GOIN when eligible; there is
no animated autopilot in this source. Original excerpts and tests document the
scope of each port; historical notes give routine-by-routine details.

## Still adapted or unfinished

- The native shell uses fixed ship slots rather than original packed UNIV/FRIN
  compaction. Allocation, scene transitions and parts of scheduling remain QL
  integration code; complete main-loop equivalence is not claimed.
- Wireframe clipping/rasterization, screen caches and keyboard/QDOS services are
  native platform adapters. Identical full-frame Electron pixels are not claimed.
- The short-range chart, system-name search, original screen layouts/text-token
  presentation and full escape-capsule presentation remain unfinished.
- Sound priorities/envelopes are ported, but waveform/noise fidelity and every
  event's cycle-level ordering are not established.
- Fixture comparisons isolate routines at stated boundaries. A passing corpus
  is not proof that every possible game trajectory is identical.

The numbered demonstration scenes, commander reset key, native menus and save
format are retained development conveniences, not original Electron mechanics.

RC3 adds Electron BR1/QU5/TITLE/DEATH and STATUS/FREEZE/DKS3-derived behavior.
See RELEASE-AUDIT.md and ARCHITECTURE.md for exact boundaries: native QDOS names
and files, raster/font/pacing, initial death-scene RNG carry, sound integration,
and the still-open universe capacity/compaction/processing-order difference.
FLH is inert in the actual Electron program, so no flashing-bar effect is added.
Unsupported joystick leftovers are documented rather than turned into new
joystick mechanics. RC3 is not labelled a completed fidelity1.0 release.

RC3a: at the user’s request, the completed ten-update DEATH animation now
holds its final frame until a fresh Space press. Held Space is release-gated;
other keys are ignored. This is an intentional QL presentation difference from
the Electron timed transition. The subsequent saved-commander flow is unchanged.
