# RC1 current update

README.md, RELEASE-AUDIT.md and RC1-RESULTS.md supersede the A27 completion list below. Short-range chart/system data and production startup are now implemented. Name search and animated escape flight are absent from the Electron source, not pending features.

# A27 verification

Build with the recovered qdos-gcc 2.95.3 R2 toolchain. The normal make target
builds the native game plus diagnostics; large fixture jobs run at640 KB.

```
make QCC=/absolute/path/to/qdos-gcc
sh tests/run-qlbox.sh /absolute/path/to/qlbox-r9
sh tests/run-basic.sh /absolute/path/to/qlbox-r9
```

Run reference generators before rebuilding when changing fixture sources.
SKIP_REFERENCES=1 skips regeneration for an already rebuilt fixture set.
The harnesses use the QLBox R9 JS ROM and Musashi68000 core. Run them sequentially
because screenshot names and the BASIC save fixture are shared.

ELITEDST compares768 dust cases, including original instruction execution,
shared RNG, all view paths, carry and screen call geometry. ELITEFID covers all
65536 TT123 input/delta pairs,1024 TT111 queries across eight galaxies, bounded
screen compression/roundtrips,2560 sound-priority decisions,256 SFXL states and
envelope progression/repeat/expiry. ELITEENC additionally checks source-return
carry for2048 encounter cases. The full retained diagnostic corpus covers the
previous combat, navigation, station, fittings, economic and renderer ports.

Both direct-job and BASIC EXEC_W harnesses run at128 and640 KB. They exercise
actual keys, modal/pause restoration, combat, missiles/ECM, pods/salvage, trading,
travel, save/load, station behavior, four views, fittings/computer, planet/altitude
and the new fidelity features. Whole-screen restoration and return to BASIC are
checked by decoding the saved backing store independently.

Focused selection variables include ONLY_FIDELITY, ONLY_STATION, ONLY_TRAVEL,
ONLY_CARGO and the retained subsystem selectors. These shorten investigation;
they do not replace the final full-suite logs.

Tests inject deterministic coordinates, equipment and RNG where documented to
reach rare branches without long flights. The FAROF test moves the planet beyond
the station generation range so it tests removal independently of legitimate
replacement generation. Other station tests explicitly verify generation.
Screenshots are regression scenes, not claims of earned commander achievements.

Timing printed by fidelity_check measures active native flight with dust/sound
in the emulated setup. ELITEBEN is a separate rendering benchmark; neither is a
measurement on physical68008 hardware. See A27-RESULTS.md for this build's results.

## RC3 additions

run-release.sh now runs actual ELITEASM title/load/death/configuration flows
through BASIC EXEC_W at128/640KB. ONLY_RELEASE on qlbox-keys runs the same checks
through direct job startup. flow_check.h tests a named ALEX save, saved-state
restart after death, missing/corrupt-load rollback, old ELITESAVE import,
configuration persistence and paused Escape restart. Keys go through IPC;
death is triggered using the authoritative flag written by combat/collision.
The four-canister model check inspects native model types. Existing production
travel and actual station-approach/docking checks remain in the same run.

The retained station mass-lock fixture now initializes a complete INWK and
explicitly chooses a type1..8 blueprint. Reusing an ambient asteroid or cargo
canister cannot test mass lock: the original rule deliberately excludes them.
This is a test correction, not a game-rule change.

RC3 logs: RC3-BUILD.log, RC3-INTEGRATION.log, RC3-BASIC.log,
RC3-PRODUCTION.log, RC3-PRODUCTION-DIRECT.log. Retained original arithmetic
fixture binaries are rerun; unchanged Python fixture generation is skipped.
The lifecycle UI excerpts are source provenance; no claim is made that every
6502 lifecycle instruction has an executed-original differential test.

RC3a: at the user’s request, the completed ten-update DEATH animation now
holds its final frame until a fresh Space press. Held Space is release-gated;
other keys are ignored. This is an intentional QL presentation difference from
the Electron timed transition. The subsequent saved-commander flow is unchanged.
