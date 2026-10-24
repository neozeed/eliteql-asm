; Native MV40/MULT3/MVT3 then MV45/MVT1. SM24 coordinates, full products.
; move_planet(inwk[36],params[4],K2_low): the original fractional scratch byte
; is explicit. Shell supplies zero; no claim of whole-program scratch aliasing.
.sect .text
.globl _move_planet
_move_planet:
 movem.l d2-d7/a2-a3,-(sp)
 move.l 36(sp),a2
 move.l 40(sp),a3
 move.l 44(sp),d7
 and.l #255,d7
 move.l a2,a0
 bsr planet_load
 moveq #0,d1
 move.b (a3),d1
 eor.b #128,d1
 bsr planet_multiply
 lsr.l #8,d0
 move.l d0,d4
 lea 3(a2),a0
 bsr planet_load
 move.l d0,d1
 move.l d4,d0
 bsr planet_add
 move.l d0,d4
 moveq #0,d1
 move.b 1(a3),d1
 bsr planet_multiply
 lsr.l #8,d0
 move.l d0,d5
 lea 6(a2),a0
 bsr planet_load
 move.l d0,d1
 move.l d5,d0
 bsr planet_add
 move.l d0,d5
 bsr planet_store
 move.l d5,d0
 eor.l #0x800000,d0
 moveq #0,d1
 move.b 1(a3),d1
 bsr planet_multiply
 ; y = (K + K2)/256: original fractional carry/borrow is significant.
 move.l d0,d6
 and.l #0x80000000,d6
 move.l d4,d1
 lsl.l #8,d1
 or.l d7,d1
 move.l d0,d2
 eor.l d1,d2
 bmi planet_y_sub
 add.l d1,d0
 eor.l d6,d0
 lsr.l #8,d0
 bra planet_y_ready
planet_y_sub:
 and.l #0x7fffffff,d0
 and.l #0x7fffffff,d1
 sub.l d1,d0
 bcc planet_y_sign
 lsr.l #8,d0
 neg.l d0
 and.l #0x7fffff,d0
 eor.l #0x80000000,d6
 lsr.l #8,d6
 or.l d6,d0
 bra planet_y_ready
planet_y_sign:
 lsr.l #8,d0
 lsr.l #8,d6
 or.l d6,d0
planet_y_ready:
 lea 3(a2),a0
 bsr planet_store
 ; x += alpha*y/256
 bsr planet_load
 moveq #0,d1
 move.b (a3),d1
 bsr planet_multiply
 lsr.l #8,d0
 move.l d0,d4
 move.l a2,a0
 bsr planet_load
 move.l d0,d1
 move.l d4,d0
 bsr planet_add
 bsr planet_store
 ; MV45 subtracts DELTA using the full 23-bit MVT1 coordinate path.
 lea 6(a2),a0
 bsr planet_load
 move.l d0,d1
 move.l #0x800000,d0
 move.b 2(a3),d0
 bsr planet_add
 bsr planet_store
 movem.l (sp)+,d2-d7/a2-a3
 rts
planet_load:
 moveq #0,d0
 move.b 2(a0),d0
 lsl.l #8,d0
 move.b 1(a0),d0
 lsl.l #8,d0
 move.b (a0),d0
 rts
planet_store:
 move.b d0,(a0)
 lsr.l #8,d0
 move.b d0,1(a0)
 lsr.l #8,d0
 move.b d0,2(a0)
 rts
; MULT3: SM24 d0 * SM8 d1 -> SM32 d0, including fractional byte.
planet_multiply:
 move.l d0,d2
 lsl.l #8,d2
 move.l d1,d3
 lsl.l #8,d3
 lsl.l #8,d3
 lsl.l #8,d3
 eor.l d3,d2
 and.l #0x80000000,d2
 and.w #127,d1
 beq planet_product_zero
 and.l #0x7fffff,d0
 move.l d0,d3
 swap d3
 mulu.w d1,d3
 swap d3
 mulu.w d1,d0
 add.l d3,d0
 or.l d2,d0
 rts
planet_product_zero:
 moveq #0,d0
 rts
; MVT3: SM24 K=d0, coordinate=d1. Equal opposite magnitudes keep coord sign.
planet_add:
 move.l d0,d2
 and.l #0x800000,d2
 move.l d1,d3
 and.l #0x800000,d3
 and.l #0x7fffff,d0
 and.l #0x7fffff,d1
 cmp.l d2,d3
 bne planet_add_opposite
 add.l d1,d0
 and.l #0x7fffff,d0
 or.l d2,d0
 rts
planet_add_opposite:
 sub.l d0,d1
 bcc planet_coord_larger
 neg.l d1
 move.l d2,d3
planet_coord_larger:
 move.l d1,d0
 or.l d3,d0
 rts
