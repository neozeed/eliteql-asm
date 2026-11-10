# EliteQL 1.0 RC6 — live information screens and animated GAME OVER

Production ELITEASM: 64,114 bytes; declared QDOS data space: 9,116 bytes.
SHA256: c9a9f96c409c4a1a9e3eedf0edb040fd6b632cf1aa24995498e00fd41792b1b5

## Player-facing changes

- Status (6), cargo (7), navigation (9) and flight market prices (8) keep the
  flight simulation running. F5 pauses on these pages. Primary flight keys
  stay live; firing heats/uses energy but cannot draw over the page or hit ships.
- Key8 shows current-system prices in flight. Buying/selling remains docked-only.
- Docked B asks for a quantity. Type digits and Enter; Esc cancels. Invalid
  quantities, insufficient capacity and insufficient cash retry atomically.
  S still sells the whole holding without replenishing station stock.
- GAME OVER continues the existing debris/explosion/stardust scene indefinitely.
  The first ten updates must finish; release then press Space to restart.
  Held Space, other keys and repeated animation updates cannot restart it.
- Hyperspace can complete while a page is open, keeping that information page
  rather than drawing the tunnel over it. New stardust is deferred until return.

## Source boundaries

MA26 -> MA15 skips LL9/DOEXP and missile/laser hit testing when QQ11 is nonzero;
STARS likewise skips its update. Ships and tactics continue in M%/TT100.
This is deliberately not an invisible full-render path. Native XOR caches are
kept for restoration, with removal/laser erasure prevented from touching pages.
The QL key aliases, selected-row trading interface and Esc cancellation remain
platform adapters. No 6502 interpreter or C gameplay loop is linked in ELITEASM.
Only src/shell.s and src/market.s changed in the native game sources.

The arrival audit established that TT24's final productivity shift returns C=0
for all 256 relevant seed-bit combinations and both input carries (512 runs of
the original instructions). hyp1's remaining copy instructions preserve carry.
Thus the existing explicit carry0 for GVL is justified. LL164/NOISE/HFS2 do not
consume DORND in this Electron source; the old “sound RNG not reproduced”
comment at this boundary was inaccurate. Whole-game RNG identity, and the
initial death-scene text-boundary carry, are still not proven.

## Validation

RC6-PRODUCTION.log: actual BASIC EXEC_W ELITEASM runs at 128KB and 640KB.
Includes prior startup/travel/docking/save/load/universe/cheat/quit checks plus:

- Multi-unit keyboard purchase, correct debit/cargo/stock, complete sale,
  cancel, invalid-stock retry, insufficient capacity and insufficient cash.
- Four information pages: frames/MCNT/planet continue; page pixels remain
  unchanged; F5 pauses; in-flight B/S cannot trade; Esc restores the cockpit.
- Firing behind status consumes/warms the weapon without hits or page drawing.
- Actual hostile-ship tactics scheduled while STATUS is open.
- Hyperspace completion while STATUS remains selected.
- Moving death screen beyond the timer, held-Space rejection, unrelated-key
  rejection and a fresh Space returning only to the first title.

RC6-MODULES-AND-DEV.log: packaged native routine tests passed, including 1,024
new quantity cases against executed original tnpr/LCASH, with explicit GCASH
16-bit width, plus the prior arithmetic/market/travel/combat/universe/etc corpus.
The development CLI integration and diagnostic benchmarks also passed at both
RAM sizes. This run preceded the final production-only laser-bookkeeping and quantity-help guards;
no isolated routine implementation changed afterward.

RC6-BASIC.log: ELITEDEV through real BASIC EXEC_W at 128KB and 640KB,
including queue consumption, suspended BASIC, screen restoration, poll cleanup,
full development integration, and exit. DEV intentionally retains its old modal
pages and test-scene keys; its historical log wording is not production behavior.

RC6-ORACLES.log records the new 6502 helper fixture generation and carry proof.
Existing fixtures were reused for the broad regression (SKIP_REFERENCES=1).
Historical logs retain their original filenames and are not relabelled as RC6.

These are QLBox checks, not a physical-QL performance claim or an exhaustive
proof of every full-game trajectory. The death waiting policy is an intentional
user-requested QL extension of the original timed transition.

## Installing

Use host/ELITEASM with its QDOS job metadata. Launch as before:

    EXEC_W WIN1_ELITEASM

Save formats are unchanged. The canonical long player guide is now README.md
in this full-source package, with RC6 amendments; prior RC5b remains untouched.
