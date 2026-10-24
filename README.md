# EliteQL 1.0 RC3

A native 68000 QDOS adaptation of Acorn Electron Elite. RC3 adds the original
start/restart flow, commander names, full status information, and working
keyboard pause settings. All game code is assembly. RC2 remains an independent
fallback. This is still a release candidate: the universe capacity/order and
shared-RNG integration qualification in docs/RELEASE-AUDIT.md remains open.

## RC3 start, death and load flow

The rotating Cobra asks **LOAD NEW COMMANDER (Y/N)?**. Press Y for a name, or N
to use the last saved commander held in memory (Jameson on first start). The
rotating Mamba then shows **PRESS FIRE OR SPACE, COMMANDER** before the docking
bay. Like the original TITLE routine, that second screen accepts any key.
Escape on either title screen exits to QDOS.

Death shows GAME OVER with the Electron DEATH routine's four-canister scene,
then returns to the load question. N restores the last successful save/load;
it does not award a new commander or retain unsaved progress. With no save,
it restores the default Jameson. Paused Escape also returns to the title.

Save/load accepts a commander name of 1–7 letters or digits. Left (or Backspace)
deletes, Enter accepts, Escape cancels. The QDOS file is WIN1_<NAME>; for example,
ALEX saves to WIN1_ALEX. To import an older WIN1_ELITESAVE, delete the entire
load name and press Enter. Legacy EQA1 and EQA2 payload validation is retained;
missing/corrupt files do not replace the live or last-saved commander. Named
files still use EQA2, with the name supplied by the filename. These are native
QDOS files, not Electron cassette images.

6 opens/closes status; docked, it switches between status and market. 7 opens
cargo, and 6 closes it. Status includes present/hyperspace systems, the original
Docked/Green/Yellow/Red condition rule, fuel, cash, legal status, rating, all
installed equipment, and the laser fitted to each view.

While paused with F5:

| Key | Electron setting |
|---|---|
| S / Q | Sound on / off |
| Caps Lock | Toggle flight damping |
| A | Toggle automatic recentring |
| X | Toggle title author credits |
| F | Toggle the original inert flashing-bar flag |
| Escape | Return to the title/load question |
| F5 | Resume |

The screen stays frozen, as in Electron FREEZE. Toggle keys beep if sound is on.
Settings persist across launch/death/restart. The source explicitly says FLH has
no effect in this version; RC3 does not invent flashing bars. The unsupported
joystick options remain excluded rather than adding joystick gameplay.

## RC2 keyboard update

The production flight keys now follow Electron KYTB: comma/less-than and
period/greater-than roll, X pulls up, S pitches down, Space accelerates,
slash/question-mark slows, and A fires. Shift is optional for punctuation.
Arrow keys retain traditional flight pitch/roll; F remains a fire alias and
Z a slow-down alias. A no longer accelerates.

Space never toggles pause in ELITEASM. F5 toggles pause/resume as the QL
substitute for Electron COPY/DELETE. Escape during normal play exits to QDOS and K uses an
escape capsule. Existing T/U/M, E, -, J and C match Electron's secondary flight
commands. Docked S remains sell/save, and chart arrows remain cursor controls.
V now correctly selects the local chart (RC1 accidentally mapped that to X).

The separate ELITEDEV preserves its legacy test controls, including Space pause,
so the full retained arithmetic and integration regression corpus still runs.
This update does not change the universe-order qualification in RELEASE-AUDIT.md.

## Start playing

Mount this archive's host directory in QLBox, then run:

```
EXEC_W WIN1_ELITEASM
```

Decline loading at the first title screen to start as Jameson, docked at Lave, with100 Cr, four missiles, a full tank,
20-tonne cargo capacity and a front pulse laser. No ECM, scoops, energy bomb,
energy unit, escape capsule, docking computer or galactic drive is supplied free.
These starting values follow the original NA% default commander (Q%=FALSE).

Press6 to leave the commander status screen for the market. Buy with B,
sell with S, select with Up/Down, and launch with L. Press8 for equipment;
S saves and O loads while in that screen. Save before launching if desired.
The native EQA2 save format and EQA1 import are retained from A26/A27.

Press9 for system data. C opens/closes the galactic chart; V opens the local
chart or switches between local and galactic charts. On either chart use arrows
to move, D to select the nearest system, and O to return the cursor home. H starts
hyperspace after launch. G uses a purchased galactic drive. R refuels while docked
on the navigation page. Press9 again to close navigation.

## Flight controls

|Key|Action|
|---|---|
|X / S|Pull up / pitch down|
|Up / Down|Nose down / nose up (aliases)|
|< / > (or comma / period)|Roll left / right|
|Left / Right|Roll aliases|
|Space / ? (or slash)|Increase / decrease speed|
|Z|Slow-down alias|
|F1 / F2 / F3 / F4|Front / rear / left / right view|
|A / F|Fire the fitted laser in this view|
|T / U / M|Arm/acquire missile / disarm / launch|
|E|Use fitted ECM|
|-|Use fitted energy bomb|
|J|In-system jump, subject to mass lock|
|C in flight|Use fitted docking computer near a friendly station|
|K|Use fitted escape capsule|
|6 / 7|Commander status / cargo; close with6|
|9|Navigation/data/charts|
|F5|Pause/resume|
|N at the load question|Restore the last saved commander|
|Escape|Exit normally; when paused, return to title|

The production job ignores numbered test scenes, live commander reset and
uncapped simulation. ELITEDEV retains these development controls and the
fixture-friendly equipment. It is deliberately a separate executable.

## Presentation changes

- Original TT23 short-range geometry, range circle, current/target crosses,
  system names, label-row occupancy and CPIX4 dots. ASL carry into coordinate
  addition is preserved, including the one-pixel negative-delta asymmetry.
- TT24/TT25 system information: named economy/government, technology,
  population, inhabitants, productivity, radius and distance.
- Stock docked commander startup, docked commander/inventory access and a
  production HUD without the development FPS field.
- Escape recovery skips the invented launch tunnel and follows the Electron's
  immediate recovery/docking-bay logic.

Two earlier planned items were incorrect for this source: Electron has no
system-name search and no animated escape-capsule flight sequence. Neither has
been invented. Likewise this source has no Thargoids, witchspace misjumps or
missions. Native QL text layout/font and controls are adaptations.

## Hardware and files

ELITEASM is 59,970 bytes with 7,356 bytes of declared QDOS data space. The game is
all native68000 assembly; C and Python are development diagnostics only.
Only ELITEASM and your commander save files are needed on the QL's disk. Preserve QDOS
executable metadata when copying it. The large source/diagnostic archive is not
the runtime installation and need not fit on the5 MB disk.

Both128 KB and640 KB QLBox configurations pass.128 KB depends on the starting
BASIC screen compressing sufficiently for its lossless backup;640 KB is the
comfortable choice. Physical68008 performance and sound remain unmeasured.
Measured emulated active solo flight remains10 updates/second, not a guarantee
for crowded combat. QL speaker output approximates Electron sound.

## Build/test

Use the recovered GCC2.95.3 R2 signed-remainder-fix QDOS toolchain and QLBox R9:

```
python3 tests/presentation_reference.py
make QCC=/absolute/path/to/qdos-gcc
SKIP_REFERENCES=1 sh tests/run-qlbox.sh /absolute/path/to/qlbox-r9
sh tests/run-basic.sh /absolute/path/to/qlbox-r9
sh tests/run-release.sh /absolute/path/to/qlbox-r9
```

The first two full live suites mount ELITEDEV under the test job name, preserving
all prior deterministic scene coverage. run-release.sh runs the actual ELITEASM
via BASIC EXEC_W with stock equipment. Final logs, screenshots, source provenance
and known differences are in docs. See RC2-RESULTS.md and RELEASE-AUDIT.md; RC1-RESULTS.md is historical.
