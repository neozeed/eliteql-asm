# A25 validation results

ELITEASM: **44,146 bytes**, plus **8,090 bytes** QDOS data space.
The archive preserves the XTcc trailer and QLBox executable metadata.
Only the game executable (and an optional 144-byte commander save) is needed
for play; the complete development/diagnostic corpus need not fit on the QL disk.

| Launch | RAM | Result | Largest free block after startup |
| --- | --- | --- | --- |
| Direct QDOS job | 128 KB | PASS | 2,048 bytes |
| Direct QDOS job | 640 KB | PASS | 517,120 bytes |
| BASIC EXEC_W | 128 KB | PASS | 1,536 bytes |
| BASIC EXEC_W | 640 KB | PASS | 516,608 bytes |

These are QLBox R9 JS ROM results, not physical 68008 timing measurements.
The small 128KB free block warrants keeping that environment minimal.

- ELITEVW: 2,048 original PLUT/PUS1 transformations and 4,096 original
  station TACTICS/DORND/SFS2/MVT1 cases, including 1,075 launch intents;
  zero failures. Checks include output bytes, RNG, immutable parents and guards.
- All retained source diagnostics passed, including planet geometry/altitude,
  station generation/warp, encounters, travel, equipment, combat and movement.
- Both complete live harnesses passed at both RAM sizes: view changes, exact
  viewport/cache reconstruction, scanner independence, missile locking, unfitted
  side/rear laser suppression, explosion view changes/lifetime, rear planet,
  station provocation/police cap, safe-zone aggression and hostile docking denial.
- Existing docking, market, hyperspace, galaxy changes, save/load/corruption,
  combat, ECM, cargo, keyboard queue, screen restoration and clean exit passed.
- Deep-space-to-solo regression fixed: stale deep-space variant state can no
  longer clear the solo ship. The integrated view test exercises that sequence.

Logs: A25-BUILD.log, A25-INTEGRATION.log, A25-BASIC.log, A25-FOCUSED.log.
The focused log predates only the final scene-reset guard; the complete logs
exercise the final binary and include those same tests.

A25-views.png and A25-station-police.png are actual emulator test captures.
Ship and planet positions are injected for repeatable view tests; the station
uses source-generated approach geometry, then actual firing/launch behaviour.
A25-views.png combines four separate poses; it is not a simultaneous panorama.

The inherited ELITEBEN passive benchmark reports 53.1 FPS for one ship and
8.2 FPS for twelve in this run. It does not run the active A25 shell and is
not evidence of current gameplay speed or real-hardware performance.

Remaining boundaries: front-only laser equipment/save schema; original QDOS
UI/allocation/raster adapters; no civilian launch scheduler added; no docking
computer, witchspace, stardust or sound in this pass. See README.md.
