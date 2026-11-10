# EliteQL 1.0 RC5a — menu Escape

ELITEASM: 62,670 bytes; QDOS declared data space: 7,182 bytes.

Esc returns production menus to the station bay/market when docked, or cockpit
when flying. It clears nested menu state and preserves pause state. Holding Esc
cannot fall through to outer exit/restart handling. Esc at the station root stays
there. In-game save/load cancels to the same root; title-load cancel remains at
the title. Cheat key 0 returns to its previous page, while Esc returns to the root.
No gameplay or save-format changes. RC5 is kept independently.

RC5a-PRODUCTION.log: passing actual BASIC EXEC_W production tests at 128KB and
640KB. New menu_escape_check.h covers status, cargo, equipment, navigation, cheats,
save/load cancellation, station-root Esc, nested local-chart/cheat Escape, long
Esc holds, paused cockpit preservation and resume. Existing production lifecycle,
RC4 compact universe and RC5 cheat/save/load checks also pass. The final ordinary
cockpit exit still completes cleanly. Earlier logs are historical, not rerun claims.

This pass targets menu routing; unchanged arithmetic module fixtures were not
rerun. Physical QL testing remains external. Use EXEC_W WIN1_ELITEASM as before.
