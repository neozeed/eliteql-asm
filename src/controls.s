; Electron DOKEY rate update, M% part 2, and part 3 speed keys.
; void control_step(unsigned char state[13], const unsigned char keys[6]);
; State: JSTX,JSTY,DAMP,DJD,ALPHA,BETA,ALP1,ALP2,ALP2+1,
;        BET1,BET2,BET2+1,DELTA. Keys: left,right,up,down,faster,slower.
; Zero DAMP/DJD enables damping/auto-recentre. Nonzero keys mean held.
; This routine is native 68000; no interpreter or C dependency.
.sect .text
.globl _control_step
_control_step:
 move.l 4(sp),a0
 move.l 8(sp),a1
 movem.l d2-d4,-(sp)
 moveq #0,d0
 move.b (a0),d0
 moveq #7,d1
 tst.b (a1)
 beq control_right
 bsr control_bump2
control_right:
 tst.b 1(a1)
 beq control_pitch
 bsr control_redu2
control_pitch:
 move.b d0,(a0)
 move.b 1(a0),d0
 moveq #14,d1
 tst.b 2(a1)
 beq control_down
 bsr control_redu2
control_down:
 tst.b 3(a1)
 beq control_angles
 bsr control_bump2
control_angles:
 move.b d0,1(a0)
 move.b (a0),d0
 bsr control_cntr
 bsr control_cntr
 move.b d0,(a0)
 eor.b #128,d0
 move.b d0,d3
 and.b #128,d3
 move.b d3,7(a0)
 move.b d3,d2
 eor.b #128,d2
 move.b d2,8(a0)
 tst.b d0
 bpl control_roll_abs
 neg.b d0
control_roll_abs:
 and.w #255,d0
 lsr.w #2,d0
 moveq #1,d4
 cmp.w #8,d0
 bhs control_roll_mag
 lsr.w #1,d0
 moveq #0,d4
control_roll_mag:
 move.b d0,6(a0)
 or.b d3,d0
 move.b d0,4(a0)
 moveq #0,d0
 move.b 1(a0),d0
 bsr control_cntr
 move.b d0,1(a0)
 eor.b #128,d0
 move.b d0,d3
 and.b #128,d3
 move.b d3,11(a0)
 eor.b #128,d3
 move.b d3,10(a0)
 tst.b d0
 bpl control_pitch_abs
 not.b d0
control_pitch_abs:
 ; 6502 ADC #4 inherits C from the roll CMP #8, not from cntr.
 addq.w #4,d0
 add.w d4,d0
 lsr.w #4,d0
 cmp.w #3,d0
 bhs control_pitch_mag
 lsr.w #1,d0
control_pitch_mag:
 move.b d0,9(a0)
 or.b d3,d0
 move.b d0,5(a0)
 tst.b 4(a1)
 beq control_slower
 cmp.b #40,12(a0)
 bhs control_slower
 addq.b #1,12(a0)
control_slower:
 tst.b 5(a1)
 beq control_done
 subq.b #1,12(a0)
 bne control_done
 addq.b #1,12(a0)
control_done:
 movem.l (sp)+,d2-d4
 rts
control_cntr:
 tst.b 2(a0)
 bne control_return
 cmp.w #128,d0
 beq control_return
 bhi control_cntr_down
 addq.w #1,d0
 rts
control_cntr_down:
 subq.w #1,d0
 rts
control_bump2:
 add.w d1,d0
 cmp.w #255,d0
 bls control_bump_range
 move.w #255,d0
control_bump_range:
 cmp.w #128,d0
 bhs control_return
 bra control_recentre
control_redu2:
 sub.w d1,d0
 bpl control_redu_range
 moveq #1,d0
control_redu_range:
 ; Exact subtraction to zero is retained, just as in Electron REDU2.
 cmp.w #128,d0
 blo control_return
control_recentre:
 tst.b 3(a0)
 bne control_return
 move.w #128,d0
control_return:
 rts
