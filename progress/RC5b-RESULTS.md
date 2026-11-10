# EliteQL 1.0 RC5b — deliberate quit

ELITEASM: 62,878 bytes; declared QDOS data space: 9,220 bytes.

Backslash opens QUIT TO BASIC? Y/N. Only a fresh Y exits to QDOS. N or Esc cancels,
other keys are ignored, and a Y already held when opening cannot confirm. Exact
screen pixels, nested menu selection and pause state are restored on cancellation.
Simulation freezes while prompting. The extra screen backing uses 2,048 bytes.

Esc no longer quits or restarts production play anywhere: menu Escape returns to
bay/cockpit, bare-cockpit Escape stays in the game, paused Escape stays paused,
and title Escape stays at the title. ELITEDEV retains historical diagnostic keys.
No save-format or gameplay changes. RC5a is preserved independently.

RC5b-PRODUCTION.log contains passing actual BASIC EXEC_W runs at 128KB and 640KB.
The retained production lifecycle, universe, cheats/save/load and menu-back probes
pass. New quit_check.h checks title/cockpit Escape, long holds, preheld Y rejection,
unrelated-key rejection, N/Esc cancellation, exact viewport restoration, nested
cheat preservation, pause preservation, live freeze/resume, and final fresh-Y
quit with ready/poll cleanup. The production flow test now verifies paused Escape
stays in game and uses death/title for its restart/load scenario instead.

The prompt screenshot was visually inspected. Earlier release logs are historical;
unchanged arithmetic-module tests were not rerun for this UI fix. Physical QL
validation is still external. Launch with EXEC_W WIN1_ELITEASM as before.
