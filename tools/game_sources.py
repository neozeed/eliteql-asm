from pathlib import Path
r=Path(__file__).resolve().parents[1]
s=(r/'src/models.s').read_text().split('_orientations:\n')[0].replace('.globl _orientations\n','')
(r/'src/models_game.s').write_text('; Game-only blueprints: legacy benchmark orientation table omitted.\n'+s)
s=(r/'src/render.s').read_text().replace('.extern _orientations\n','')
a=s.index('demo_matrix:\n');b=s.index('matrix_ready:\n',a)
s=s[:a]+'demo_matrix:\n ; ELITEASM supplies original motion matrices; no demo rotation fallback.\n bra render_return\n'+s[b:]
(r/'src/render_game.s').write_text('; Generated game renderer; benchmarks retain render.s.\n'+s)
