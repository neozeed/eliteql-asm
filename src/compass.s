; Original SPS2/SP2/DOT results with QL mode-8 bitmap adaptation.
; Vector bytes are original normalized sign-magnitude XX15.
.sect .text
.globl _compass_project
_compass_project:
 move.l 4(sp),a0
 move.l 8(sp),a1
 moveq #0,d0
 move.b (a0),d0
 bsr compass_div10
 add.w #193,d0
 move.b d0,(a1)
 moveq #0,d0
 move.b 1(a0),d0
 bsr compass_div10
 neg.w d0
 add.w #203,d0
 move.b d0,1(a1)
 move.b #240,2(a1)
 tst.b 2(a0)
 bpl compass_front
 move.b #255,2(a1)
compass_front:
 move.b #1,3(a1)
 rts
compass_div10:
 move.w d0,d1
 and.w #127,d0
 divu.w #10,d0
 and.l #65535,d0
 tst.b d1
 bpl compass_positive
 neg.w d0
compass_positive:
 rts
; xor(screen,state[4]). Original CPIX2 writes THREE pixels, including the
; initial pixel and the two executions of its JSR P%+3 tail.
.globl _compass_xor
_compass_xor:
 movem.l d2-d7/a2,-(sp)
 move.l 32(sp),a0
 move.l 36(sp),a2
 tst.b 3(a2)
 beq compass_xor_done
 moveq #0,d7
 cmp.b #240,2(a2)
 bne compass_rows
 moveq #1,d7
compass_rows:
 moveq #0,d6
 move.b 1(a2),d6
 sub.w d7,d6
 mulu.w #128,d6
 moveq #2,d5
compass_pixels:
 moveq #0,d0
 move.b (a2),d0
 add.w d5,d0
 move.w d0,d1
 lsr.w #2,d0
 add.w d0,d0
 add.w d6,d0
 and.w #3,d1
 add.w d1,d1
 lea compass_masks(pc),a1
 move.w 0(a1,d1.w),d2
 eor.w d2,0(a0,d0.w)
 dbra d5,compass_pixels
 dbra d7,compass_rows
compass_xor_done:
 movem.l (sp)+,d2-d7/a2
 rts
compass_masks: .data2 0x80c0,0x2030,0x080c,0x0203
.globl _compass_frame
.extern _planet_vector
_compass_frame:
 movem.l a2-a4,-(sp)
 move.l 16(sp),a2
 move.l 20(sp),a3
 move.l 24(sp),a4
 subq.l #4,sp
 move.l a4,-(sp)
 move.l a2,-(sp)
 jsr _compass_xor
 addq.l #8,sp
 move.l sp,a0
 move.l a0,-(sp)
 move.l a3,-(sp)
 jsr _planet_vector
 addq.l #8,sp
 move.l sp,a0
 move.l a4,-(sp)
 move.l a0,-(sp)
 jsr _compass_project
 addq.l #8,sp
 move.l a4,-(sp)
 move.l a2,-(sp)
 jsr _compass_xor
 addq.l #8,sp
 addq.l #4,sp
 movem.l (sp)+,a2-a4
 rts
