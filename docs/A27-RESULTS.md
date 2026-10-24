# A27 results

Final game: **51,990 bytes**, QDOS data space **7,894 bytes**.
All native diagnostics and both full live harnesses passed. Logs:
A27-BUILD.log, A27-INTEGRATION.log, A27-BASIC.log.

| Launch | RAM | Largest free block after startup |
|---|---:|---:|
| Direct job |128 KB|25,600 bytes|
| BASIC EXEC_W |128 KB|24,576 bytes|
| Direct job |640 KB|540,672 bytes|
| BASIC EXEC_W |640 KB|539,648 bytes|

These are measured in QLBox R9 with its JS ROM and the test's initial BASIC
screen. The backup is losslessly compressed when that saves memory. A complex
initial screen may need a raw32 KB backup and prevent128 KB startup.

Active solo flight with dust and sound enabled measured50 updates in250 50-Hz
ticks in all four configurations: **10 updates/second**. This is emulated active
flight, not a physical68008 measurement or a guarantee for crowded combat.
The separate rendering benchmark reports53.1 FPS solo and8.2 FPS for12 ships;
that benchmark excludes the complete live-game workload.

New diagnostics:768 original6502 dust cases;65,536 cursor deltas;1,024 nearest
queries;2,560 sound priority decisions;256 SFXL states; pitch envelope/expiry;
bounded bitmap compression. The2,048 encounter cases now include return carry.
All retained diagnostics passed, including combat, physics, economy, station,
planet/altitude, four views and laser fitting/docking computer fixtures.

Each full live run completed5,256 updates across its scenarios. Both RAM sizes
passed actual keys, combat, missiles/ECM, pods/salvage, commander/equipment,
market/docking, hyperspace/galactic travel, save/load, encounters, station police,
four-view fittings, docking computer, planet/altitude, dust, chart and tunnels.
BASIC EXEC_W suspension, queued printable-key consumption, held-key exit, full
screen restoration, polling cleanup and job exit passed.

The FAROF regression initially observed a correctly regenerated replacement
station. Its fixture now places the planet outside station-generation range,
so removal is checked independently; separate tests retain generation coverage.
No production station removal behavior was changed for that fixture.

The package contains source, generators, original-reference excerpts, fixtures,
QDOS executables/metadata, these logs and captures. A26 remains a separate build.
See FIDELITY.md for remaining adaptations and unfinished presentation features.
