## A17 additions

**Press minus (`-`) to use the energy bomb.** One bomb is fitted in these test
encounters and restored by N/reset. The original MA24 shift activates it,
MA18 shifts its remaining active bits each update, and the ship-loop branch
kills eligible objects. Stations and already-exploding objects are immune.
Kills use EXNO2 and subsequent original bounty/legal settlement; the bomb does
not run the laser-specific debris path. Holding minus follows the original
repeated-shift rule. Pause freezes activation and expiry. This is a test
loadout, not a claim about the equipment of a fresh original commander.

When a hit penetrates your shields but you survive, **OUCH can destroy an
entire commodity stock or one piece of equipment**. The original DORND/CPX
selection and DLY gate determine whether anything is lost. Lost ECM prevents
new E activation; lost scoops make a close canister collide rather than collect;
lost bombs cannot fire; energy-unit loss removes its recharge bonus. An already
active ECM cycle is not cancelled just because the equipment is destroyed.
The source's docking-computer flag is included in the damage layout, but no
working docking computer is fitted or implemented. The status strip names the
lost item. Page 6 now shows ECM, scoops, bomb and energy-unit Y/N indicators.
Cargo names and quantities are separated more clearly than in A16.

**The cockpit compass now follows the planet reference.** It uses original
SPS1/SPS3 normalisation, SPS2/SP2 placement and DOT/CPIX2 shapes: a double-height
dash ahead, single-height behind. The actual source writes three horizontal
pixels, despite its four-pixel description. Drawing/erasure retains underlying
dashboard artwork. There is still no station-safe-zone selection or rendered
planet; this instrument currently tracks the existing test planet only.

The live compass test exposed an A14/A16 limitation: the planet had been sent
through the ship coordinate-rotation path. The source has a separate **MV40**
path for its larger coordinates. A17 ports MV40, MULT3, MVT3 and the MV45/MVT1
translation, preserving 23-bit magnitudes and original fractional carry/borrow.
That corrected reference also feeds escape-pod navigation. Only its coordinates
are advanced; no rendered planet orientation/altitude/travel system is claimed.

The source's MV40 reads a pre-existing K2 low scratch byte. The native entry
exposes it as an argument, and tests cover all 256 values; the scene passes zero.
This is an explicit boundary, not a claim to recreate incidental zero-page
aliasing throughout the complete original game. OUCH's incoming random carry
is similarly explicit **1** at the absent EXNO3 sound boundary. Complete original
sound-dependent RNG sequencing is not reproduced.

## A17 validation

New original-instruction comparisons:

- 2,048 OUCH states, comparing all 22 cargo/equipment bytes and RNG state.
- 4,096 bomb targets, 512 key states and all 256 expiry states.
- 512 compass placement/bitmap/XOR/guard cases.
- 1,024 MV40/MULT3/MVT3/MV45 cases, including repeated trajectories, large
  coordinates and all K2-low inputs.

The complete suite and both real-QDOS-job harnesses pass at 128/640 KB, including
BASIC EXEC_W. Live checks cover planet front/rear direction, exact dashboard
pixels, bomb consumption, eleven fleet kills with station immunity, no duplicate
tally, cargo and equipment loss, blocked ECM/bomb/scooping, reset, and all earlier
combat, pod, salvage, commander, controls and keyboard/exit behavior.

The game is 35,124 bytes plus 8,732 bytes QDOS data space. BASIC EXEC_W leaves
10,240 bytes in the largest free block at 128 KB. Physical 68008 timing remains
unmeasured. The inherited benchmark exercises passive ships, not active bombs,
compass or AI, so its results are not a new whole-game performance claim.

All gameplay remains native assembly. C and the original 6502 interpreters are
build-time/test tools only. Logs are docs/A17-BUILD.log, A17-INTEGRATION.log and
A17-BASIC.log. SCREENS.png contains actual emulator captures from the bomb and
forced-equipment-loss integration tests.

