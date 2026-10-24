# EliteQL — Acorn Electron Elite for the Sinclair QL

<img width="1024" height="544" alt="ql-elite" src="https://github.com/user-attachments/assets/1dd69050-a571-4b13-898a-e6ca0aec76d8" />

**Player guide, controls and project notes for EliteQL 1.0 RC5b**  
Documentation revision: 24 October 2026

EliteQL is a native 68000-family assembly adaptation of **Acorn Electron Elite**, targeting QDOS on the Sinclair QL. The aim is to bring the Electron game's actual mechanics to the QL: its flight arithmetic, tactics, trading, travel, encounters and limitations, with a QL display, keyboard and file interface.

This is a playable **release candidate**, not a claim that every possible game trajectory is identical to the Electron. The complete trading-and-combat loop is present. QLBox tests pass with both 128KB and 640KB configurations; physical QL performance and long play sessions remain important validation.

**Use `ELITEASM` to play.** `ELITEDEV` and the other executables are development tools with different controls and assumptions.

## Contents

1. [Quick start](#quick-start)
2. [What this version contains](#what-this-version-contains)
3. [Your first trading trip](#your-first-trading-trip)
4. [Flight, combat and survival](#flight-combat-and-survival)
5. [Complete production controls](#complete-production-controls)
6. [Saving, loading and death](#saving-loading-and-death)
7. [Optional cheat menu](#optional-cheat-menu)
8. [Hardware, performance and files](#hardware-performance-and-files)
9. [How the port works](#how-the-port-works)
10. [Discoveries and observations](#discoveries-and-observations)
11. [Validation and remaining qualifications](#validation-and-remaining-qualifications)
12. [Building and source layout](#building-and-source-layout)
13. [Troubleshooting](#troubleshooting)
14. [Credits and rights](#credits-and-rights)

## Quick start

Mount the release's `host` directory as `WIN1_` in QLBox, or copy `ELITEASM` to your QL using a method that preserves its QDOS executable metadata. At the BASIC prompt:

```basic
EXEC_W WIN1_ELITEASM
```

`EXEC_W` waits for the game to finish. On an ordinary successful exit, the game restores the saved screen and returns control to BASIC. You should not have BASIC processing your flight keys in the background.

At the rotating Cobra's **LOAD NEW COMMANDER (Y/N)?** question, press **N** to start with the default commander on a fresh run. The following rotating Mamba screen accepts a key to enter the docking bay.

Your starting commander is **Jameson**, docked at **Lave**, with:

| Item | Starting state |
| --- | --- |
| Cash | 100 credits |
| Fuel | Full: 7.0 light-years of normal hyperspace range |
| Missiles | Four |
| Cargo capacity | 20 tonnes |
| Laser | Front pulse laser |
| Purchased upgrades | None |

Press **6** to switch from status to the market. **Up/Down** selects a commodity, **B** buys one unit and **S** sells your entire holding of the selected commodity. **L** launches from the bay/market or equipment screen. From status or cargo, use **Esc** to return to the bay first.

For a low-pressure introduction, you can use **0** to open the optional cheat menu and fit a docking computer. Cheats are optional; normal startup is not pre-equipped.

**To quit:** press **backslash (`\`)**, release it, then press **Y** at **QUIT TO BASIC? Y/N**. **N** or **Esc** cancels. Esc by itself never quits production gameplay.

## What this version contains

The playable cycle is: start or load a commander, buy cargo, launch, travel, encounter other ships, fight or evade, approach a station, dock, sell, upgrade and save. Death and escape-capsule recovery return you through the appropriate commander/bay flow.

The current implementation includes:

- Native wireframe ships, scanner, instruments, compass, stardust, explosions and planet rendering.
- Source-derived flight movement, control response, orientation maintenance and AI scheduling.
- Front, rear, left and right views, with separate laser fittings.
- Pulse and beam lasers, missiles, ECM, energy bombs, shields, energy, damage and equipment loss.
- Traders, pirates, hunters, police, asteroids, cargo canisters and escape pods, with the relevant source-derived behavior.
- Cargo scooping, legal status, bounty/rating progression and markets.
- Station generation, rotation, hostility, police launches, manual docking and docking-computer use.
- System data, local and galactic charts, normal hyperspace, in-system jump and galactic travel.
- Equipment purchases, named QDOS commander files, title/load flow and death/restart.
- The original universe allocation limits and compact processing order, rather than an expanded QL-only population.

The QL-specific additions include the optional cheat menu, flight key aliases, F5 pause, native save files, the fresh-Space GAME OVER hold, menu back-navigation and confirmed quitting.

This is specifically the **Electron** branch of Elite. Do not use a feature list from another Elite version as a checklist for this one. The supplied Electron source has no Thargoid/witchspace encounter system, mission system, system-name search, or animated escape-capsule flight sequence to reproduce. The docking computer also behaves differently from versions with a visible autopilot approach.

The presentation is a QL adaptation. Expect monochrome-style wireframes and a compact text interface, not modern graphics or exact Electron screen pixels.

## Your first trading trip

### 1. Look around while docked

Begin on the commander status page. Check cash, fuel, legal status and equipment. **6** returns to the market; **7** opens cargo. **Esc** from a normal menu returns to the station bay/market.

The market shows price, station stock and your holding. Prices are shown in credits, including decimal fractions. Pay attention to the commodity's unit: tonne, kilogram and gram goods do not all use cargo capacity in the same way.

Buy a modest quantity with **B**, leaving money for fuel. Buying fails without charging you if stock, hold space or cash is insufficient. **S sells all of the selected commodity**, not one unit.

A reasonable beginner's trading approach is to compare economies: agricultural and industrial systems often provide complementary goods. Treat this as trading guidance, not a guaranteed profitable route. Read the actual prices and do not assume every journey makes money.

### 2. Choose a destination

Press **9** for navigation/system data. **V** opens the local chart; **C** switches between chart and data. On a chart, move the cursor with the arrows and press **D** to select the nearest system. **O** puts the cursor back at your current system.

Check the selected system's distance against your remaining fuel. The local chart is useful for a first trip because nearby systems are easier to compare. Government and economy are clues about the place you are visiting; avoid assuming all systems are equally safe.

You can also select systems from the text data page. **Up/Down** steps backward/forward through system indices; **Left/Right** searches backward/forward for another nonzero-distance system within your present fuel range.

There is no text box for typing a system name. Selection is through the chart or data-page controls.

### 3. Save before leaving

Return to the bay with **Esc**, then press **8** for equipment. **S** opens the save-name prompt. Enter a name of one to seven letters/digits and press **Enter**. Save before experimenting with docking or combat.

The equipment screen is also where **O** opens the load prompt. Save/load keys are context-sensitive: **S on the market sells cargo; S on equipment saves**.

### 4. Launch and make the hyperspace jump

From the bay or equipment screen, press **L**. In flight, **Space** increases speed and **slash (`/`)** decreases it. The punctuation keys do not require Shift.

Use **X** to pull up and **S** to pitch down. **Comma/less-than** and **period/greater-than** roll. You steer by rolling into the desired direction and pitching; this is not a mouse-steered game with independent yaw.

Press **H** to start normal hyperspace to the selected destination. You must be in flight with a valid destination and enough fuel. A countdown precedes arrival. Opening information pages does not itself make a jump.

**G is different:** it uses a fitted galactic hyperdrive to move between galaxies. That drive is a consumable upgrade, not the ordinary hyperspace capability already installed in your ship.

### 5. Reach the station

After arrival, use the compass to orient toward the planet, then toward the station when the station becomes the local target. Watch the forward/rear indication rather than assuming a centered compass marker means the target is ahead of you.

**J** performs an in-system jump when allowed. It is useful for crossing empty space, but nearby mass-locking objects can prevent it. It does not select or visit another star system, and it is not the same as **H**.

Do not fly into the planet. The altitude indication is a warning, not an invitation to land. Station approach and docking are the destination.

### 6. Dock, sell and refuel

For manual docking, reduce speed, approach the entrance from the front, align with its rotation and keep centered. Coming at the station from the wrong side or at a bad angle does not count as docking. A slow bad contact can cause damage; a fast bad contact can be fatal.

If you fitted a docking computer, press **C** in flight when an eligible friendly station is present. In this Electron implementation, successful computer docking enters the bay immediately. There is no animated autopilot to watch. It will not dock you from arbitrary deep space or make a hostile station friendly.

Once docked, sell cargo, inspect the equipment list and refuel. Fuel can be purchased in equipment, or **R** on the docked navigation page fills the tank if you can afford the charge. Save your progress after a successful trip.

## Flight, combat and survival

### Learn the instruments before fighting

The scanner shows local contacts relative to your ship; it is not a galactic map. The compass points toward the current navigation body/station. Watch front and rear shields, energy, laser temperature, fuel, speed and altitude.

Status shows a condition of Docked, Green, Yellow or Red according to the ported rule. A condition indicator is useful context, not a guarantee that you are safe. Keep watching the scanner and incoming fire.

A laser can overheat. Continuous firing is not always useful: aim, fire in bursts and let it cool. Shields and energy interact, and equipment can be lost when damage reaches the relevant source conditions. Buying an upgrade does not make it indestructible.

### Use the correct view and weapon

**F1–F4** choose front, rear, left and right views. **A** fires the laser fitted to the current view; **F** is an alias. Jameson starts with only a front pulse laser. An empty rear or side fitting is not a broken fire button.

To buy a rear/side laser, use **F1–F4 in the equipment screen** to choose the fitting, then buy the selected laser. View selection there chooses where the purchase goes; in flight it chooses where you look and fire.

### Missiles and ECM

Press **T** to arm/acquire a missile target, bring the intended ship into the targeting sight and wait for a lock. **M** launches at the acquired target; **U** disarms. You carry at most four missiles. A launch can fail if the local universe has no allocation room—even with spare QL RAM.

**E** activates fitted ECM. It is useful against missiles but uses energy; it is not an unlimited shield. Opponents can also have ECM.

After a target is removed from the universe, a missile following it can lose AI guidance and drift. That is deliberately preserved from the original removal logic, not automatically treated as an explosion.

### Bombs, cargo and escape

**Minus (`-`)** uses a fitted energy bomb. It is a one-use item, and the original station immunity remains. The cheat option replenishes the single bomb slot; it does not create an inventory of stacked bombs.

Fuel scoops enable the source's cargo/pod collection mechanics. Approach collectible objects carefully with available hold capacity. Flying into an object is not always a successful scoop. This guide does not promise a separate sun-skimming refuelling system; use the implemented station fuel purchases for route planning.

**K** uses an installed escape capsule. It is consumed, cargo/legal state is reset as implemented by the Electron recovery routine, and you return to the bay. There is no invented cinematic escape flight. It is not the same as quitting or loading a save.

Attacking the station can make it hostile and provoke police launches. The docking computer will not override that hostility. Avoid using the station as a target while learning the controls.

## Complete production controls

Keys are context-sensitive. These tables describe **ELITEASM RC5b**, not the development executable.

### Global, menus and quitting

| Key | Action |
| --- | --- |
| Backslash `\` | Open the quit-to-BASIC confirmation, including from titles and menus |
| Y at quit prompt | Confirm quit, on a fresh press only |
| N or Esc at quit prompt | Cancel; restore the previous display and pause/menu state |
| Other keys at quit prompt | Ignored |
| Esc in a normal menu | Return to station bay/market when docked, or cockpit when flying |
| Esc in cockpit | Stay in the game; it does not quit or restart |
| Esc while cockpit is paused | Stay paused |
| Esc at a title screen | Stay at that title |
| 0 during normal play | Open the optional cheat menu |
| F5 in flight | Pause/resume |

Holding Esc cannot fall through from closing a menu into an exit action. A Y held before opening the quit prompt cannot confirm it. Quitting does **not** automatically save your commander.

Normal information pages and the cheat/quit prompts stop simulation while open. F5 is the flight pause control; Space is never pause in the production game.

### Flight and weapons

| Key | Action |
| --- | --- |
| X | Pull up |
| S | Pitch down |
| Down arrow | Pull-up alias |
| Up arrow | Pitch-down alias |
| Comma / `<` | Roll left |
| Period / `>` | Roll right |
| Left / Right arrows | Roll aliases |
| Space | Increase speed |
| Slash / `?` | Decrease speed |
| Z | Decrease-speed alias |
| F1 / F2 / F3 / F4 | Front / rear / left / right view |
| A or F | Fire the current view's fitted laser |
| T | Arm/acquire missile target |
| U | Disarm missile targeting |
| M | Launch a locked missile |
| E | Activate fitted ECM |
| Minus `-` | Use fitted energy bomb |
| J | In-system jump, subject to the original mass-lock rules |
| C | Use fitted docking computer when eligible; navigation must be closed |
| K | Use fitted escape capsule |
| 6 | Open/close commander status; also closes cargo |
| 7 | Open cargo inventory |
| 9 | Open/close navigation/system data |

Shift is optional for comma, period and slash. Arrow pitch follows traditional flight-stick direction: pushing Up lowers the nose; pulling Down raises it.

### Station, market and equipment

| Context | Key | Action |
| --- | --- | --- |
| Docked status/market | 6 | Switch between status and market |
| Normal play | 7 | Cargo inventory; use 6 or Esc to leave |
| Bay/market | Up / Down | Select commodity |
| Market | B | Buy one unit of selected commodity |
| Market | S | Sell all held units of selected commodity |
| Bay/market or equipment | L | Launch |
| Bay/market | 8 | Open equipment |
| Equipment | Up / Down | Select equipment item |
| Equipment | F1–F4 | Choose front/rear/left/right laser fitting |
| Equipment | B | Buy selected item for the selected fitting, where applicable |
| Equipment | S | Save commander |
| Equipment | O | Load commander |
| Equipment | 8 | Return to market |
| Any normal docked menu | Esc | Return directly to bay/market |

Purchases depend on cash, existing equipment, capacity and local technology. An item being listed does not mean the current system sells it. A rejected purchase reports its reason without charging you.

### Equipment catalogue

These are the prices shown by this build. Technology restrictions still apply.

| Item | Listed price | Purpose or limit |
| --- | --- | --- |
| Fuel | 0.2 Cr per internal fuel unit | Refills normal hyperspace fuel; the equipment purchase fills the shortfall |
| Missile | 30 Cr | One replacement, maximum four aboard |
| Large cargo bay | 400 Cr | Increases cargo capacity |
| ECM system | 600 Cr | Enables E; uses energy when active |
| Extra pulse laser | 400 Cr | Fits the selected view |
| Extra beam laser | 1,000 Cr | Fits/upgrades the selected view; a pulse fitting has the implemented trade-in treatment |
| Fuel scoops | 525 Cr | Enables collectible cargo/pod scooping |
| Escape pod | 1,000 Cr | One-use recovery through K |
| Energy bomb | 900 Cr | One fitted bomb, used with minus |
| Energy unit | 1,500 Cr | Improves the source-derived energy recharge behavior |
| Docking computer | 1,000 Cr | Immediate docking when the original eligibility checks succeed |
| Galactic drive | 5,000 Cr | One-use galactic hyperspace through G |

A beam upgrade's trade-in is not an advance loan: the original purchase logic
requires the gross beam price to be affordable before applying the pulse refund.
Check cash and technology if an apparently affordable upgrade is refused.

### Navigation and travel

| Context | Key | Action |
| --- | --- | --- |
| Normal play | 9 | Open/close navigation |
| Navigation | C | Toggle chart/data display |
| Navigation | V | Open chart and toggle local/galactic chart mode |
| Chart | Arrows | Move cursor |
| Chart | D | Select system nearest the cursor |
| Chart | O | Return cursor to current system |
| Data page | Up / Down | Previous/next system index |
| Data page | Left / Right | Search backward/forward for another system within current fuel range |
| Flight | H | Start normal hyperspace to selected system; from an open chart, selection is snapped to the cursor first |
| Flight | G | Use fitted galactic hyperdrive |
| Docked navigation | R | Refuel, subject to available cash |
| Navigation | Esc | Return directly to bay/cockpit |

**H, J and G are different operations.** H changes star system using normal fuel; J advances within the local system when allowed; G consumes the galactic drive to change galaxy. Normal hyperspace cannot start while docked.

### Paused configuration

Pause with **F5**, release it, then use:

| Key | Action |
| --- | --- |
| S / Q | Sound on / off |
| Caps Lock | Toggle flight damping |
| A | Toggle automatic recentring |
| X | Toggle title author-credit display |
| F | Toggle the original flashing-bar flag, which has no visual effect in this source |
| F5 | Resume |
| Esc | Stay paused in game |
| 0 | Open cheats while retaining the paused state |
| Backslash | Open quit confirmation while retaining the paused state if cancelled |

Settings persist across launch, death and restart in the running game. The inert flashing-bar option is intentional: the Electron source does not read the flag to produce an effect. Unsupported joystick options have not been turned into invented joystick gameplay.

### Titles, names and GAME OVER

| Context | Key | Action |
| --- | --- | --- |
| First title/load question | Y | Enter a commander filename to load |
| First title/load question | N | Use the last successfully saved/loaded commander in memory; default Jameson on a fresh run |
| Second title | A normal key, e.g. Space | Enter the docking bay |
| Name entry | Letters/digits | Enter up to seven characters |
| Name entry | Left arrow or Backspace | Delete a character |
| Name entry | Enter | Accept name |
| In-game name entry | Esc | Cancel and return to bay/cockpit |
| Title-load name entry | Esc | Cancel back to the title |
| GAME OVER after animation | Fresh Space | Return to the load question |

Backslash quit confirmation takes priority over these screens. Esc is excluded from the second title's ordinary “any key” progression.

## Saving, loading and death

Save from **8 → S** at the station's equipment screen. Load with **8 → O**, or choose **Y** at the initial load question. Name files using one to seven letters or digits. For example, `ALEX` uses the QDOS filename `WIN1_ALEX`.

The current native format is **EQA2**; the loader retains support for the older **EQA1** format. These are QDOS port files, not Electron cassette commander images. To import an older port file named `WIN1_ELITESAVE`, erase the entire load-name field and press Enter.

Missing, corrupt or truncated loads are rejected without replacing the live commander or the last successful saved/loaded state. Loading is a deliberate rollback to that file: unsaved purchases, cash and other progress are not preserved.

After death, the four-canister GAME OVER sequence runs and then holds its last frame until a **fresh Space** press. Holding Space during the animation does not skip it. This hold is a requested QL presentation change; the Electron original returned on a timer.

At the subsequent load question, **N restores the last successful save/load held in memory**. It does not give you a fresh reward or keep unsaved progress. With no such state in the current run, it restores default Jameson. On a newly started program, choose Y to load an existing disk file; N does not search the disk for your last commander automatically.

Cheated money and equipment are ordinary commander state. They are saved if you save, and lost with other unsaved changes if you die/reload. Use a different name for experiments if you want to keep a clean commander.

## Optional cheat menu

Press **0** during normal play, including in flight, docked, paused or on a navigation page. The menu is explicitly labelled **CHEAT MENU — QL EXTRAS**.

| Key | Grant |
| --- | --- |
| 1 | Add 1,000 credits |
| 2 | Refill missiles to four |
| 3 | Fit docking computer |
| 4 | Replenish the single energy bomb |
| 5 | Fit ECM |
| 6 | Fit galactic hyperdrive |
| 0 | Return to the screen from which cheats were opened |
| Esc | Return directly to bay/market or cockpit |

Cash is added once per fresh press and saturates instead of overflowing. Equipment is fitted, not toggled off. Reapplying it does not stack duplicates. Replenishing a bomb does not overwrite an already active detonation countdown.

This is not a new Electron rule, and no fidelity claim includes it. It is a convenience requested for exploring the port. There is no automatic save, invulnerability or infinite ammunition implied by these grants.

## Hardware, performance and files

The target is a QDOS Sinclair QL using the **68008-compatible 68000 instruction set**. The design does not depend on a 68020 or floating-point hardware.

| Item | RC5b status |
| --- | --- |
| Production executable | `host/ELITEASM` |
| Executable size | 62,878 bytes |
| Declared QDOS data space | 9,220 bytes |
| QLBox configurations tested | 128KB and 640KB |
| Normal pacing | Target of ten simulation updates per second |
| Real physical QL performance | Not established by the supplied automated results |
| Disk requirement for playing | Executable plus commander saves; not the entire development archive |

The executable size and declared data space are **not a total peak-memory figure**. QDOS, screen preservation and other allocations also need memory. The 128KB path depends on compressing the pre-existing BASIC screen sufficiently for its lossless backup. 640KB is the more comfortable configuration.

A 5MB hard disk does not need to contain the source, fixtures and diagnostic executables. The production game itself is much smaller. The source ZIP is a development distribution, not a minimum installation.

Preserve executable job metadata when transferring `ELITEASM`. The package includes QLBox metadata and `tools/qlmeta.py`; a raw copy through a tool that discards QDOS attributes may need those attributes restored. QLBox metadata is not a universal real-hardware disk format.

Expect an early-1980s pace. The game is capped around ten updates per second when it can keep up; crowded combat can run slower. Historical QLBox uncapped diagnostic scenes measured approximately 53.1 fps with one ship and 8.2 fps with twelve. Those are particular test scenes, **not** real-68008 measurements or a promise for production combat. The twelve-ship diagnostic scene also does not describe the production universe capacity.

The renderer uses QL-specific bitmap drawing and caches. This is not a full-screen, fully redrawn modern double-buffered engine. QL speaker output approximates the Electron's sound; waveform identity is not claimed.

## How the port works

### Native assembly, rather than an emulated Electron

The project began with cross-toolchain work and an earlier C-oriented approach. Performance concerns led to native assembly gameplay, translating the Electron routines into 68000 implementations and replacing the hardware-dependent interfaces.

There is **no 6502 CPU interpreter in the production game**. Python instruction interpreters are used by development tests to execute original routines and generate expected results. C is used for diagnostics, harnesses and older benchmark paths. The `ELITEASM` gameplay link is assembly.

### Preserve representation when it preserves behavior

The Electron uses compact byte-oriented state, sign-magnitude vectors, fixed-point calculations and carry-dependent operations. A mechanically similar sequence of 68000 instructions does not automatically have the same meaning.

The port retains original state layouts where useful and performs byte operations explicitly. Native QL drawing caches and pointers are separate where necessary. This avoids silently replacing the original flight model with conventional floating-point physics.

### Replace the hardware interface

QL-specific code handles keyboard scanning and queue draining, QDOS job lifecycle, native files, screen backup/restore, bitmap rasterization, text and speaker output. These are adaptations around the ported mechanics.

The original dashboard artwork and ship blueprints feed native drawing code. Movement state remains authoritative; render caches retain enough prior geometry to erase and redraw with XOR without rebuilding the game world from the displayed image.

### Keep the original crowded-universe rules

Production uses twelve logical entries **including the planet and station/placeholder**, leaving ten ordinary ship slots. Allocation also observes the original blueprint line-heap costs and 1,087-byte combined record/heap budget. A collection of large ships may exhaust that budget before exhausting slots.

Removal compacts the list and its native render/explosion caches. The ship shifted into the removed slot still receives its turn that frame; newly appended children can also be processed later in that frame. AI/TIDY cadence uses the original logical slot, not a convenient native array index.

More QL RAM therefore provides room for implementation state and caches, **not permission to change the population or spawning rules**.

## Discoveries and observations

### Carry flags are part of the algorithm

The original code often treats carry as an input, a temporary bit and a branch result across operations. Preserving the numerical inputs alone can still give a different answer. Signed remainder, byte wrapping, shifts and overflow deserve explicit tests when moving between the original machine, a 64-bit host toolchain and a big-endian target.

The practical lesson was to port small arithmetic boundaries and compare their actual output, rather than assume “equivalent-looking” code is equivalent. Successful compilation and a working Hello World were useful milestones, not proof of game correctness.

### Allocation order changes gameplay

A fixed reusable ship pool initially looked like harmless native bookkeeping. It changes when ships act, which slot participates in cadence tests, whether a spawn succeeds and what the shared random-number generator does next.

RC4 replaced that model in production. Heap admission now happens during encounter generation, so a failed spawn affects the following original branches and random draws. Exploding ships remain in the relevant counts until actual removal.

This was one of the strongest findings of the port: memory management can be part of the game rules.

### Some surprising behavior is authentic

When a missile's target is removed, the original target-remapping logic can disable its AI and leave it drifting. It does not necessarily explode immediately.

The original player-lock removal code aborts a lock on the removed slot but does not decrement a later lock index. That quirk was retained rather than silently “improved.” The flashing-bar setting is another example: the flag exists, but the supplied Electron program does not use it to produce the presumed effect.

### Port the supplied edition, not remembered Elite

Remembered behavior from other Elite releases led to some early mistaken expectations. The supplied source, rather than memory, resolved them: no invented system-name search, no animated escape-capsule flight, and no visible docking-autopilot sequence were required.

This distinction also keeps the project manageable. Feature fidelity means matching this edition's rules, not combining favorite features from every version bearing the name.

### Host integration matters as much as the renderer

A game can appear to run correctly while BASIC still receives keys, a job fails to suspend its caller, or a modal screen damages an XOR cache. Keyboard ownership, release gating, screen restoration and job cleanup all required dedicated integration checks.

The recent Escape fixes are a useful example: “back from a menu” and “terminate the QDOS job” must be different actions. RC5b makes quitting deliberate, with the same fresh-key discipline used for the GAME OVER hold.

### Even sound tables have behavioral details

The sound port found that the original priority-table access uses offsets
0, 8, 16 and so on, rather than a simple consecutive event index. The resulting
priority values were retained instead of silently replacing the apparent indexing
mistake with a more intuitive table. Sound-event ordering and shared randomness
are reasons not to equate correct isolated routines with proven whole-game identity.

The QL speaker can approximate the intended effects, but it cannot make the
Electron ULA and the QL sound hardware the same device. Event selection, priority
and lifetime are separate questions from exact waveform reproduction.

### My assessment of this version

The port is beyond a wireframe demonstration: it supports an actual commander journey through trading, travel, combat, docking, saving and recovery. The source comparisons provide stronger evidence than visual resemblance alone, and the live reports established that the evolving game was playable.

I would still describe RC5b as a release candidate. The most valuable next evidence is extended play on the intended hardware, especially crowded combat, repeated arrivals/docking, equipment loss, missile targets being removed and repeated save/load cycles. A clean scripted test corpus cannot prove every ordering combination or physical-machine timing behavior.

The ten-update target is appropriate to the project, but it should remain a measured behavior rather than a slogan. Native assembly helped make the design practical; correctness still depends on the exact arithmetic, data flow and scheduling.

## Validation and remaining qualifications

The tests combine executed-original routine comparisons with QLBox integration checks of the actual QDOS programs.

Examples of concrete coverage include:

| Area | Evidence |
| --- | --- |
| Universe admission/removal | 4,096 operations compared with executed original NWSHP/KILLSHP |
| Missile target compaction | All 256 AI-byte values across ten removal positions: 2,560 cases |
| Heap-sensitive encounters | 256 cases comparing emitted state, carry, planned pool and final RNG |
| Production integration | Stock startup, trade, travel, docking, save/load, death/title flow and universe probes |
| Cheats | Grants, held-key rejection, overflow, bomb countdown, save/load and screen restoration |
| Escape/quit | Menu return, long holds, title/cockpit safety, preheld-Y rejection, cancel restoration and confirmed exit |
| Memory configurations | Actual BASIC EXEC_W production runs at 128KB and 640KB |

Historical releases also retain extensive arithmetic, renderer, controls, scanner, tactics, market, travel, sound and other fixtures. **Historical logs are not relabelled as new runs.** RC5b's UI change reran the production suite; it did not rerun every unchanged isolated arithmetic corpus.

Remaining qualifications are explicit:

- No proof of bit-identical whole-game trajectories or shared-RNG state at every sound/text/platform boundary.
- The first death-scene random-call carry across a text-output boundary is explicitly seeded clear in the adapter.
- Native QL clipping, rasterization, font, input mappings, pacing and file format differ from Electron hardware.
- Speaker output is an approximation; cycle-accurate sound identity is not established.
- Physical QL timing, hardware-specific behavior and long-duration play are not established by QLBox results alone.
- Intentional QL extras—cheats, confirmed quit and the held GAME OVER frame—are not presented as original Electron mechanics.

Source-derived tests can demonstrate a routine's behavior at a documented boundary. They cannot honestly produce a universal “100% identical” certificate for an entire game.

## Building and source layout

The retained build uses the recovered **GCC 2.95.3 QDOS cross-toolchain**, including the project's signed-remainder fix, and QLBox R9 for the documented live harnesses. The compiler and ROM are separate dependencies, not bundled into the game source ZIP.

From the project directory:

```sh
# Production assembly game only:
make host/ELITEASM QCC=/absolute/path/to/qdos-gcc

# Game plus development/diagnostic targets:
make QCC=/absolute/path/to/qdos-gcc

# Retained module and development integration suites:
SKIP_REFERENCES=1 sh tests/run-qlbox.sh /absolute/path/to/qlbox-r9
sh tests/run-basic.sh /absolute/path/to/qlbox-r9

# Actual production game, entered through BASIC EXEC_W:
sh tests/run-release.sh /absolute/path/to/qlbox-r9
```

`SKIP_REFERENCES=1` uses the checked-in generated fixtures. Reference-generation scripts execute documented source excerpts; consult their inputs and `docs/SOURCE-PROVENANCE.txt` before regenerating. Building diagnostic targets requires more time and disk space than building the game alone.

| Location | Purpose |
| --- | --- |
| `host/ELITEASM` | Production game |
| `host/ELITEDEV` | Legacy development scenes and controls; not the player release |
| Other `host/ELITE*` files | Benchmarks and module diagnostics |
| `src/shell.s` | QDOS/keyboard/menu/game-loop integration |
| `src/motion.s`, `flight.s`, `tidy.s`, `controls.s` | Motion and control arithmetic |
| `src/tactics.s`, `combat.s`, `missile.s`, `target.s` | Combat and AI mechanics |
| `src/universe_list.s`, `encounters.s`, `station*.s` | Allocation, encounters and station behavior |
| `src/travel.s`, `market.s`, `shop.s`, `save.s` | Travel, commerce, equipment and file adapter |
| `src/render_game.s`, `line.s`, `models_game.s` | Native rendering and blueprint data |
| `tests/` | Original excerpts, fixture generators, native checks and QLBox harnesses |
| `tools/` | Asset/metadata support |
| `docs/` | Architecture, provenance, release results and historical logs |
| `NOTICE.md` | Attribution and rights statement |

Some C and older rendering sources remain because the diagnostics use them. Their presence does not mean the production game runs a C simulation loop.

Read the **latest** release results first: `docs/RC5b-RESULTS.md`, then RC5a/RC5 for UI changes and RC4 for universe ordering. Older notes preserve the history and may describe issues subsequently fixed.

## Troubleshooting

| Symptom | Check |
| --- | --- |
| Space pauses, or number keys create test scenes | You probably launched ELITEDEV or an older executable. Production Space accelerates. |
| Esc immediately drops to BASIC | Verify the installed binary is RC5b. Earlier releases retained cockpit exit paths. |
| The job will not run after copying to a QL disk | Check QDOS executable type/data-space metadata, not just the filename and bytes. |
| BASIC reacts to flight keys | Confirm EXEC_W and the current build. Keyboard ownership is part of the tested job integration. |
| Laser will not fire in rear/side view | Check that a laser is fitted to that view, and that it is not overheated. |
| C does not dock | Close navigation, check docking computer installation, station presence and hostility. |
| J will not jump | Check for mass-locking objects; it is not a hyperspace key. |
| H will not jump | Check that you launched, selected another reachable system and have enough fuel. |
| G does nothing | Normal hyperspace does not supply a galactic drive. Buy or explicitly cheat one in. |
| An equipment purchase fails | Read the message: cash, technology, already fitted or capacity can block it. |
| Save/load keys trade cargo instead | Open equipment with 8 first; market S is Sell All. |
| GAME OVER does not dismiss | Wait for the animation, release Space and press it again. Other keys do not dismiss it. |
| A menu appears to stop the universe | Information/modal pages intentionally suspend simulation. Exit the page to continue. |
| 128KB startup cannot preserve the screen | Try a simpler BASIC screen or more RAM; compressed backup capacity is finite. |

When reporting a problem, include the exact release, RAM setting, QLBox version or real QL configuration, how it was launched, the keys/actions leading to the issue and whether a fresh commander or saved file reproduces it. Keep an untouched save when investigating a repeatable state-dependent problem.

## Credits and rights

Original **Elite**: **Ian Bell and David Braben**, copyright **Acornsoft 1984**.

The supplied annotated Acorn Electron disassembly and commentary are by **Mark Moxon**. The port was developed against that supplied source; the companion project is identified in `NOTICE.md` as:

<https://github.com/markmoxon/elite-source-code-acorn-electron>

Ship blueprints, dashboard artwork, routine structure and bundled original instruction excerpts derive from that material. The native 68000 adaptation, QL drawing/backend integration, tests and tools were developed for this project, with iterative play feedback from Jason.

This is an unofficial adaptation. The supplied disassembly does not provide a licence granting new rights to the original Elite material. This package does not invent such a licence. See `NOTICE.md` for the retained attribution; the original full source checkout, QLBox ROM and compiler are not bundled.
