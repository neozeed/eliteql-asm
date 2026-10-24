# EliteQL 1.0 RC4 — universe allocation and processing order

Production binary: 61,762 bytes; QDOS declared data space: 7,238 bytes.
RC3a is preserved independently. Native 68000 gameplay only; no emulated 6502
or C game loop was introduced.

## Implemented from the supplied Electron source

NWSHP/FRIN/UNIV: 12 logical entries including planet and station/placeholder,
first-empty append, original blueprint byte-5 line-heap costs, and the 1,087-byte
combined data/line-heap admission boundary. Station uses its separate LSO budget
and logical slot 1. Extra QL memory is used for native caches, not extra ships.

KILLSHP/KS1: compact INWK, line/render and explosion state together; resume the
same index so the shifted object receives its update. Dynamically appended
children receive their later turn in the same frame. TIDY/TACTICS use original
logical XSAV, rather than the old physical native slot. Station generation stays
at the original post-loop stage. Placeholder movement retains full-width state.

KS2: remap missile targets after compaction; disable AI when its target is removed
so it drifts. Preserve exact hostile AI-byte remapping too. KILLSHP aborts an equal
player lock but does not decrement a later MSTG; that original quirk is retained.
Production no longer applies legacy early target cleanup before KILLSHP.

Encounter NWSHP admission is applied during generation against a cloned live
pool. Heap failure therefore affects the original next branches/random draws.
Asteroid/cop inventory includes explosions until actual removal, like MANY.

## Validation

- ELITEUL: 4,096 allocation/removal operations against executed original 6502
  NWSHP/KILLSHP, plus all 256 AI-byte values at ten KS2 removal positions.
- ELITEUP: 256 executed-original encounter cases with the independently tested
  heap/slot admission rule; compare emitted records, carry, final RNG and pool.
- Production QDOS checks at 128KB and 640KB, through BASIC EXEC_W and direct job
  launch: small-ship slot limit, large-ship heap limit, unchanged state on failed
  allocation, INWK/render/cloud compaction, missile remapping and drifting,
  player-lock semantics, pending killed target retained, same-frame shifted ship
  processing, and a real Viper launch whose missile moves in that same frame.
- Retained native module fixtures and full development gameplay integration
  pass at both memory sizes. BASIC suspension, key queue and exit restoration
  pass. Production title, trade, save/load, hyperspace, docking, death hold and
  saved-commander restart remain covered.
- Legacy benchmark scenes remain approximately 53.1 fps for one ship and 8.2 fps
  for twelve ships uncapped in QLBox; these are diagnostic scenes, not a new
  production crowded-combat or physical-68008 performance measurement.

The full development run preceded the final two production-only legacy-target
bypass branches. Those branches are gated by uni_active; production BASIC and
direct-launch suites were rerun on the final binary. Historical RC1–RC3a logs are
retained as historical evidence, not relabelled as RC4 runs.

Logs: RC4-BUILD.log, RC4-UNIVERSE-ORACLE.log, RC4-ENCOUNTER-POOL.log,
RC4-INTEGRATION.log, RC4-BASIC.log, RC4-PRODUCTION.log,
RC4-PRODUCTION-DIRECT.log. Tests use deterministic harness-injected states for
rare conditions; they are not a substitute for a long human playthrough.

## Release boundary

This closes the identified fixed-pool capacity/compaction/scheduling difference.
It does not establish bit-identical whole-game trajectories. Sound/text RNG
boundaries, QL raster/font/pacing/input/save adaptations and physical hardware
performance remain explicit qualifications. The requested fresh-Space GAME OVER
hold deliberately differs from Electron's timed return. ELITEDEV keeps fixed
scene slots only for retained development diagnostics; ELITEASM uses the compact
production universe. Keep this as RC4 pending real-machine play testing.
