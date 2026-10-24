; TT24/TT25 data, output six native words:population,productivity,radius,
; first adjective,second adjective,third adjective,species (last four bytes).
.sect .text
.globl _system_details
_system_details:
 move.l 4(sp),a0
 move.l 8(sp),a1
 movem.l d2-d3,-(sp)
 moveq #0,d0
 move.b 8(a0),d0
 lsl.w #2,d0
 moveq #0,d1
 move.b 6(a0),d1
 add.w d1,d0
 move.b 7(a0),d1
 add.w d1,d0
 addq.w #1,d0
 move.w d0,(a1)
 move.b 6(a0),d1
 eor.w #7,d1
 addq.w #3,d1
 mulu.w d1,d0
 moveq #0,d1
 move.b 7(a0),d1
 addq.w #4,d1
 mulu.w d1,d0
 lsl.w #3,d0
 move.w d0,2(a1)
 moveq #0,d0
 move.b 5(a0),d0
 and.w #15,d0
 add.w #11,d0
 lsl.w #8,d0
 move.b 3(a0),d0
 move.w d0,4(a1)
 moveq #0,d0
 move.b 5(a0),d0
 move.w d0,d1
 lsr.w #2,d0
 and.w #7,d0
 move.b d0,6(a1)
 move.w d1,d0
 lsr.w #5,d0
 move.b d0,7(a1)
 move.b 3(a0),d0
 move.b 1(a0),d2
 eor.b d2,d0
 and.w #7,d0
 move.b d0,8(a1)
 and.w #3,d1
 add.w d1,d0
 and.w #7,d0
 move.b d0,9(a1)
 movem.l (sp)+,d2-d3
 rts
; TT182..TT186 with ASL carry retained into ADC104/90.
; local_position(seed6,current6,outWordsXY): return0 outside,1 visible.
.globl _local_position
_local_position:
 move.l a2,-(sp)
 move.l 8(sp),a0
 move.l 12(sp),a1
 move.l 16(sp),a2
 moveq #0,d0
 moveq #0,d1
 move.b 3(a0),d0
 move.b 3(a1),d1
 sub.w d1,d0
 cmp.w #-19,d0
 blt local_no
 cmp.w #19,d0
 bgt local_no
 moveq #0,d1
 tst.w d0
 bpl local_x_positive
 moveq #1,d1
local_x_positive:
 lsl.w #2,d0
 add.w #104,d0
 add.w d1,d0
 move.w d0,(a2)
 moveq #0,d0
 moveq #0,d1
 move.b 1(a0),d0
 move.b 1(a1),d1
 sub.w d1,d0
 cmp.w #-37,d0
 blt local_no
 cmp.w #37,d0
 bgt local_no
 moveq #0,d1
 tst.w d0
 bpl local_y_positive
 moveq #1,d1
local_y_positive:
 add.w d0,d0
 add.w #90,d0
 add.w d1,d0
 move.w d0,2(a2)
 moveq #1,d0
 move.l (sp)+,a2
 rts
local_no:
 moveq #0,d0
 move.l (sp)+,a2
 rts
