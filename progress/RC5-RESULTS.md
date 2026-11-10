# EliteQL 1.0 RC5 — optional cheat menu

ELITEASM: 62,514 bytes; declared QDOS data space: 7,198 bytes. Full source and
QDOS executable metadata included. RC4 is preserved independently.

Press 0 in normal play to open the labelled QL cheat menu. Keys 1–6 add 1,000
credits, refill four missiles, fit docking computer, replenish the single bomb,
fit ECM, and fit galactic hyperdrive. 0/Esc returns to the prior screen. Simulation
freezes while the menu is open and the prior pause state is preserved. Held keys
do not repeat grants. Equipment grants are idempotent; cash saturates at the
unsigned 32-bit commander limit. The menu never cancels an active bomb countdown.

Cheats write existing commander fields, so ordinary named save/load preserves
them. Normal startup and the source-derived mechanics remain unchanged. This
explicit user-requested QL extension is outside Electron fidelity claims.

Validation: RC5-PRODUCTION.log contains passing BASIC EXEC_W production runs at
128KB and 640KB. They cover the existing stock startup, RC4 universe integration,
trade/travel/docking, death/title/load flow and pause settings, then all six menu
grants, key repeat gating, overflow, duplicate fitting, bomb countdown, save/load,
navigation restore, paused-flight byte-exact viewport restoration, unpaused-flight
freeze and resume. Screenshot rc5-cheat-menu.png was visually inspected.

RC4 and earlier logs are retained historical evidence. The unchanged arithmetic
modules were not rerun merely for this menu addition. Physical QL validation is
still external. Run EXEC_W WIN1_ELITEASM as before.
