# A26 validation results

ELITEASM: **44,928 bytes**, plus **8,056 bytes** QDOS data space.
The game remains all-assembly. C is used for diagnostics/benchmarks only.

| Launch | RAM | Result | Largest free block after startup |
| --- | --- | --- | --- |
| Direct job | 128 KB | PASS | 1,536 bytes |
| Direct job | 640 KB | PASS | 516,608 bytes |
| BASIC EXEC_W | 128 KB | PASS | 1,024 bytes |
| BASIC EXEC_W | 640 KB | PASS | 516,096 bytes |

These are QLBox R9 JS ROM results. Physical68008 timing is unmeasured.
128KB remains a tight, minimal setup. Only ELITEASM and an optional148-byte
commander save are needed on the game disk; diagnostic jobs/source are optional.

- ELITEFIT:2,592 executed original et3/et4/MCASH cases across all four views,
  pulse/beam/empty mount combinations and cash/refund edges; zero failures.
- ELITEFIT:4,096 executed original MA64 docking-computer cases covering key,
  fitting, safe-zone mask and hostile/friendly station AI; zero failures.
- ELITESHP:3,072 retained source-derived full equipment transactions, now
  including purchase/duplicate/technology rules for the docking computer.
- All retained original-instruction diagnostics passed, including A25 views/
  police, station generation/warp, planets/altitude, travel, combat and movement.
- Both full live harnesses passed at128KB and640KB, including individual
  rear/side purchases and beam trade-ins, independent mount state, launch
  preservation, five-hit kills in every view, original heat/cooldown behaviour,
  EQA2 roundtrip, EQA1 import, checksum-valid invalid side fitting rejection,
  missing v2 tail rejection, C pause/modal/chart/fitting/station/hostility gates,
  successful immediate docking and shield/energy restoration.
- Exact dashboard comparison includes the original S and E bulbs. Existing
  ECM, police launches/cap, hostile manual docking, safe-zone aggression,
  station generation/departure, markets, hyperspace/galactic travel, save/load,
  keyboard queue, screen restore and clean-exit regressions all passed.

Logs:A26-BUILD.log, A26-INTEGRATION.log, A26-BASIC.log, A26-FOCUSED.log.
The focused log precedes the final empty-front-reticle and dock-target reset
adjustments; both complete logs test the final executable with those fixes.

A26-fittings.png, A26-rear-laser.png and A26-left-laser.png are actual emulator
test captures. Tests inject credits/tech and repeatable target positions; these
are verification fixtures, not a claim of earning that equipment through play.

The inherited passive ELITEBEN reported53.1FPS with one ship and8.2FPS with
12 ships. It does not execute the active A26 shell; those figures are not an
A26 gameplay or real-hardware performance claim.

Original boundaries: Electron MA64 performs immediate safe-zone docking,
not animated auto-flight. The fixed pool, equipment menu, QDOS save and raster
backend remain adapters. No civilian traffic scheduler, sound, stardust,
witchspace or tunnel effects are newly invented in this release.
