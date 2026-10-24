# EliteQL ASM A25 — station police and four flight views

A25 adds the original Electron station tactics and front/rear/left/right views,
all in native 68000 assembly. A24 is preserved separately; existing commander
saves are compatible. The archive includes the complete integrated source,
built QDOS jobs, source excerpts, diagnostics and test logs.

**Try it:** press **7** for the aligned station approach. Fire **F** at the
station to provoke its police response, or dock normally and press **L** to
launch; **F2** then looks back at the station. Use **F1** front, **F2** rear,
**F3** left and **F4** right during live flight. The bottom status strip names
the current view. Views do not switch while paused, on a modal page or docked.
The existing inverted pitch controls are unchanged.

The hostile station uses TACTICS' original eight-update scheduling, DORND
threshold140 and cap of three police already present. SFS1/SFS2 place each
Viper along the station's nose, with speed32, AI225 (ECM and aggression), and
roll damping. Launches use the existing twelve-slot native ship pool; a full
pool declines insertion. Friendly stations do not launch this response.
Station presence now also connects TA13's suppression of ordinary pirate and
bounty-hunter aggression. Hostile stations refuse docking through the existing
ISDK path. The Electron source has no separate peaceful-station traffic
scheduler in this path; this pass does not invent one.

PLUT/PUS1 transform both ship position and all three orientation vectors. Ships,
planets, enemy beams, explosion clouds and missile targeting follow the selected
view. Physics, AI, docking, altitude and the scanner retain ship-relative world
state. Switching clears old XOR drawing and rebuilds the view without resetting
the universe, cargo or commander. There is no extra framebuffer.
A retained deep-space scene flag is now scoped to deep-space mode, fixing
a return-to-solo reset that could leave the solo ship marked absent.

The current equipment/save adapter still stores a **front laser only**. Rear
and side views have no crosshair or player laser, as for unfitted original
views. Directional laser purchases and saving four laser fittings remain to be
ported. Missiles can lock in any view, while launch geometry remains forward.

ELITEVW compares 2,048 PLUT/PUS1 transforms and 4,096 station TACTICS/DORND/SFS2/
MVT1 cases against executed original 6502 excerpts, including negative zero,
overflow, RNG state and the police cap. QDOS allocation is an explicit adapter
boundary. Live tests cover all four views, exact XOR reconstruction, modal
restoration, unfitted lasers, missile locks, explosion lifetime across views,
rear-view planets, police provocation/launch/cap, safe-zone aggression and
hostile docking denial. Source constants and geometry are not newly imagined.

Release validation and memory figures are in docs/A25-RESULTS.md. Physical
68008 timing remains unmeasured. The 640KB target has ample room; 128KB remains
a tight configuration with little room for extra resident software.

Still unfinished: directional laser fitting, docking computer, witchspace,
sound, stardust and remaining presentation. The fixed ship pool, QL UI and
raster backend remain adaptations, rather than a complete instruction-for-
instruction translation. A24 planet rendering/altitude is retained; its source
boundaries are in docs/A24-RETAINED-NOTES.md.

