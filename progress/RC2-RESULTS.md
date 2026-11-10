# RC2 keyboard results

ELITEASM and ELITEDEV are55,194 bytes with7,710 bytes of QDOS data space.
Production IPC tests cover shifted < >, X/S, Space/?, A firing without speed
changes, damping, F5 pause/resume and Space not changing pause in either state.
V local-chart entry/exit is covered by the production loop. All changes are key
mapping/presentation adapters; original control_step arithmetic is unchanged.

All four full live runs and all four production runs passed.

Final logs: RC2-BUILD.log, RC2-INTEGRATION.log, RC2-BASIC.log,
RC2-PRODUCTION.log and RC2-PRODUCTION-DIRECT.log. The production tests run the
actual ELITEASM at128/640 KB, through BASIC EXEC_W and direct job launch.
The full retained suites use ELITEDEV and cover combat, travel, docking, trading,
save/load, planet/station logic, four views, dust, sound and screen restoration.

RC1 remains an independent fallback. Saves remain EQA2/EQA1-compatible. This is a
keyboard RC update, not a fix for the universe-list fidelity issue documented
in RELEASE-AUDIT.md. Physical QL performance is not measured by these tests.
