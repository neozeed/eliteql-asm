; Native Electron TIDY / NORM / TIS2 / TIS3 / TIS1 arithmetic.
; Original signed zero, byte division, and uncleared sidev_z_lo retained.
.sect .text
.sect .rom
.sect .data
.sect .bss
.sect .text
.globl _tidy_ship
.globl normalize_vector
.globl tidy_mult
.extern sign_add
_tidy_ship:
 movem.l d2-d7/a2-a4,-(sp)
 move.l 40(sp),a2
 lea 10(a2),a0
 bsr normalize_vector
 ; Select dominant nose coordinate, exactly TI1/TI2/TIDY's masks.
 moveq #0,d7
 move.b 10(a2),d0
 and.b #96,d0
 bne tidy_x
 moveq #2,d7
 move.b 12(a2),d0
 and.b #96,d0
 bne tidy_y
 moveq #4,d7
 moveq #0,d5
 moveq #2,d6
 bra tidy_project
 tidy_x:
 moveq #2,d5
 moveq #4,d6
 bra tidy_project
 tidy_y:
 moveq #0,d5
 moveq #4,d6
 tidy_project:
 move.b 16(a2,d5.w),d0
 move.b 10(a2,d5.w),d1
 bsr tidy_mult
 move.w d0,-(sp)
 move.b 16(a2,d6.w),d0
 move.b 10(a2,d6.w),d1
 bsr tidy_mult
 move.w (sp)+,d1
 jsr sign_add
 ; DVIDT: absolute numerator / absolute Q, low quotient byte OR sign.
 eor.w #32768,d0
 move.w d0,d2
 lsr.w #8,d2
 moveq #0,d1
 move.b 10(a2,d7.w),d1
 eor.b d1,d2
 and.w #128,d2
 and.l #32767,d0
 and.w #127,d1
 beq tidy_divzero
 divu.w d1,d0
 bra tidy_divsign
 tidy_divzero:
 move.w #255,d0
 tidy_divsign:
 or.b d2,d0
 move.b d0,16(a2,d7.w)
 lea 16(a2),a0
 bsr normalize_vector
 ; side = roof cross nose, with original TIS1 high-byte division rounding.
 lea cross_offsets,a4
 moveq #2,d7
 tidy_cross:
 moveq #0,d5
 moveq #0,d6
 move.b (a4)+,d5
 move.b (a4)+,d6
 move.b 16(a2,d6.w),d0
 move.b 10(a2,d5.w),d1
 bsr tidy_mult
 move.w d0,-(sp)
 move.b 16(a2,d5.w),d0
 eor.b #128,d0
 move.b 10(a2,d6.w),d1
 bsr tidy_mult
 move.w (sp)+,d1
 jsr sign_add
 lsr.w #8,d0
 move.w #96,d5
 bsr divide_byte_fraction
 eor.b #128,d0
 moveq #0,d1
 move.b (a4)+,d1
 move.b d0,0(a2,d1.w)
 dbra d7,tidy_cross
 ; Original TIL1 starts X=14, deliberately leaves INWK+25 unchanged.
 moveq #14,d0
 tidy_clear:
 clr.b 9(a2,d0.w)
 subq.w #2,d0
 bpl tidy_clear
 movem.l (sp)+,d2-d7/a2-a4
 rts
; Original MULT1: d0=A, d1=Q, result encoded sign-magnitude word.
tidy_mult:
 move.w d0,d2
 eor.w d1,d2
 and.w #128,d2
 lsl.w #8,d2
 and.w #127,d0
 and.w #127,d1
 beq tidy_mult_zero
 mulu.w d1,d0
 or.w d2,d0
 rts
tidy_mult_zero:
 moveq #0,d0
 rts
; Normalize three high bytes at a0,a0+2,a0+4.
normalize_vector:
 moveq #0,d4
 moveq #0,d0
 move.b (a0),d0
 and.w #127,d0
 mulu.w d0,d0
 add.l d0,d4
 moveq #0,d0
 move.b 2(a0),d0
 and.w #127,d0
 mulu.w d0,d0
 add.l d0,d4
 moveq #0,d0
 move.b 4(a0),d0
 and.w #127,d0
 mulu.w d0,d0
 add.l d0,d4
 ; LL5 integer square root via native trial bits (same floor result).
 moveq #0,d5
 move.w #128,d6
 tidy_sqrt:
 move.w d5,d0
 or.w d6,d0
 move.w d0,d2
 mulu.w d0,d0
 cmp.l d4,d0
 bhi tidy_sqrt_next
 move.w d2,d5
 tidy_sqrt_next:
 lsr.w #1,d6
 bne tidy_sqrt
 moveq #2,d7
 tidy_norm_component:
 moveq #0,d0
 move.b (a0),d0
 move.w d0,d1
 and.w #127,d1
 cmp.w d5,d1
 bhs tidy_norm_saturated
 bsr divide_byte_fraction
 ; TIS2 scaling: T/4 + ceil((T/4)/2), retain original sign.
 ; Fraction helper returns quotient OR sign; retain raw quotient in d3.
 lsr.w #2,d3
 move.w d3,d0
 addq.w #1,d0
 lsr.w #1,d0
 add.w d3,d0
 or.w d1,d0
 bra tidy_norm_store
 tidy_norm_saturated:
 and.w #128,d0
 or.w #96,d0
 tidy_norm_store:
 move.b d0,(a0)
 addq.l #2,a0
 dbra d7,tidy_norm_component
 rts
; Shared literal 8-bit shift/subtract kernel of TIS2 and DVID96.
; d0 encoded high byte; d5 positive divisor. d3 returns raw quotient.
; ASL is BYTE sized, including lost overflow. Preserve sign separately in d1.
divide_byte_fraction:
 move.w d0,d1
 and.w #128,d1
 and.w #127,d0
 moveq #0,d3
 moveq #7,d2
 tidy_fraction_loop:
 add.b d0,d0
 add.w d3,d3
 cmp.b d5,d0
 blo tidy_fraction_next
 sub.b d5,d0
 addq.w #1,d3
 tidy_fraction_next:
 dbra d2,tidy_fraction_loop
 move.w d3,d0
 or.w d1,d0
 rts
.sect .rom
cross_offsets: .data1 2,4,22,4,0,24,0,2,26
