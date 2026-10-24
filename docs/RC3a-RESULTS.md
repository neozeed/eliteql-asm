# RC3a GAME OVER hold

At the user's request, the original ten-update death animation now finishes
and holds its final frame with PRESS SPACE TO CONTINUE. The next fresh Space
press returns to the Cobra/load question. Space held during the animation must
be released first; other keys do not dismiss it. No simulation advances while
held. This is an intentional presentation departure from Electron's automatic
return, not a claim about the original program.

ELITEASM/ELITEDEV:60,044 bytes; QDOS dataspace7,352 bytes.
RC3a-BUILD.log and RC3a-PRODUCTION.log record this build and the production
BASIC EXEC_W tests at128KB and640KB. Tests check the held key, a stable final
frame, ignored non-Space keys, a fresh press reaching only the first title,
and the retained save/load/configuration/travel/docking production checks.
RC3-* logs are retained historical baseline results; the full development
suite was not rerun for this isolated production modal-state change.
