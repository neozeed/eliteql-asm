; SPBLB/ECBLB original 8x8 bitmaps at logical (192,232)/(56,232).
; Dashboard regions start black. Write current state rather than tracking XOR toggles.
.sect .text
.globl _dashboard_bulbs
_dashboard_bulbs:
 movem.l d2/a2,-(sp)
 move.l 12(sp),a2
 lea 29792(a2),a0
 lea bulb_rows+12,a1
 move.l 16(sp),d0
 bsr bulb_draw
 lea 29724(a2),a0
 lea bulb_rows,a1
 move.l 20(sp),d0
 bsr bulb_draw
 movem.l (sp)+,d2/a2
 rts
bulb_draw:
 moveq #7,d2
bulb_row:
 move.l (a1)+,d1
 tst.l d0
 bne bulb_on
 moveq #0,d1
bulb_on:
 move.l d1,(a0)
 lea 128(a0),a0
 dbra d2,bulb_row
 rts
.sect .data
.align 2
bulb_rows:
 .data2 0xaaff,0xa8fc
 .data2 0xaaff,0xa8fc
 .data2 0xa8fc,0x0
 .data2 0xaaff,0xa8fc
 .data2 0xaaff,0xa8fc
 .data2 0xa8fc,0x0
 .data2 0xaaff,0xa8fc
 .data2 0xaaff,0xa8fc
 .data2 0x0,0xa8fc
 .data2 0xaaff,0xa8fc
 .data2 0xaaff,0xa8fc
