#!/usr/bin/env python3
"""Convert original Electron P.DIALS character bytes into QL mode-8 words."""
from pathlib import Path
p=Path(__file__).resolve().parent.parent
src=(p/'assets/P.DIALS.bin').read_bytes();assert len(src)==1792
words=[]
for y in range(56):
 for x in range(0,256,4):
  word=0
  for bit,mask in enumerate((0x80c0,0x2030,0x080c,0x0203)):
   xx=x+bit
   if src[(y//8)*256+(xx//8)*8+(y%8)]&(128>>(xx%8)):word|=mask
  words.append(word)
with (p/'src/dashboard.s').open('w') as f:
 f.write('; Converted original P.DIALS.bin, 256 x 56 pixels, QL mode 8.\n.sect .text\n.globl _dashboard_pixels\n_dashboard_pixels:\n')
 for i in range(0,len(words),8):f.write(' .data2 '+','.join(hex(w) for w in words[i:i+8])+'\n')
print('Original dashboard: 1792 Electron bytes -> 7168 QL bytes')
