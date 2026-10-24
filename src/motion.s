; Electron MVEIT part 8 / MVS5 / ADD, native 68000 implementation.
; State remains original 33-byte INWK, including little-endian sign-magnitude
; vectors. No emulated CPU, trigonometry, or precomputed rotation is used.
.sect .text
.sect .rom
.sect .data
.sect .bss
.sect .text
.globl _own_rotate
.globl _motion_matrix
; void own_rotate(unsigned char *inwk). Preserves C ABI registers.
_own_rotate:
 movem.l d2-d7/a2-a3,-(sp)
 move.l 36(sp),a2
 moveq #30,d6
 moveq #9,d7
 bsr rotate_counter
 moveq #29,d6
 moveq #21,d7
 bsr rotate_counter
 movem.l (sp)+,d2-d7/a2-a3
 rts
rotate_counter:
 moveq #0,d5
 move.b 0(a2,d6.w),d5
 move.w d5,d0
 and.w #127,d0
 beq counter_done
 cmp.w #127,d0
 beq counter_fixed
 subq.b #1,0(a2,d6.w)
counter_fixed:
 and.w #128,d5
 lsl.w #8,d5
 lea 15(a2),a0
 lea 0(a2,d7.w),a1
 moveq #2,d6
pair_loop:
 bsr mvs5_pair
 addq.l #2,a0
 addq.l #2,a1
 dbra d6,pair_loop
counter_done:
 rts
; Encoded sign-magnitude words in d2/d3, loaded bytewise for host independence.
mvs5_pair:
 moveq #0,d2
 move.b 1(a0),d2
 lsl.w #8,d2
 move.b (a0),d2
 moveq #0,d3
 move.b 1(a1),d3
 lsl.w #8,d3
 move.b (a1),d3
 ; First ADD: (roof - |roof|/512) + signed(nose/16).
 move.w d2,d1
 and.w #32767,d1
 lsr.w #8,d1
 lsr.w #1,d1
 neg.w d1
 add.w d2,d1
 move.w d3,d0
 and.w #32767,d0
 lsr.w #4,d0
 move.w d3,d4
 and.w #32768,d4
 or.w d4,d0
 eor.w d5,d0
 bsr sign_add
 move.w d0,-(sp)
 ; Second ADD uses OLD roof and nose, not the newly computed roof.
 move.w d3,d1
 and.w #32767,d1
 lsr.w #8,d1
 lsr.w #1,d1
 neg.w d1
 add.w d3,d1
 move.w d2,d0
 and.w #32767,d0
 lsr.w #4,d0
 move.w d2,d4
 and.w #32768,d4
 or.w d4,d0
 eor.w #32768,d0
 eor.w d5,d0
 bsr sign_add
 move.b d0,(a1)
 lsr.w #8,d0
 move.b d0,1(a1)
 move.w (sp)+,d0
 move.b d0,(a0)
 lsr.w #8,d0
 move.b d0,1(a0)
 rts
; Original ADD behavior, including signed zero and 16-bit overflow.
; d0 = (A P), d1 = (S R), result encoded in d0; clobbers d1,d4.
.globl sign_add
sign_add:
 move.w d0,d4
 eor.w d1,d4
 bmi add_different
 move.w d0,d4
 and.w #32768,d4
 add.w d1,d0
 or.w d4,d0
 rts
add_different:
 move.w d0,d4
 and.w #32768,d4
 and.w #32767,d0
 and.w #32767,d1
 sub.w d1,d0
 bcc add_sign
 neg.w d0
 eor.w #32768,d4
add_sign:
 eor.w d4,d0
 rts
; void motion_matrix(inwk, short *matrix). Adapter to A1 renderer Q8.
; Native rows are sidev,roofv,nosev components; unity in INWK is 96*256.
_motion_matrix:
 movem.l d2-d4/a2,-(sp)
 move.l 20(sp),a0
 move.l 24(sp),a1
 lea matrix_offsets,a2
 moveq #8,d4
matrix_loop:
 moveq #0,d2
 move.b (a2)+,d2
 moveq #0,d0
 move.b 1(a0,d2.w),d0
 lsl.w #8,d0
 move.b 0(a0,d2.w),d0
 move.w d0,d3
 and.l #32767,d0
 divu.w #96,d0
 tst.w d3
 bpl matrix_positive
 neg.w d0
matrix_positive:
 move.w d0,(a1)+
 dbra d4,matrix_loop
 movem.l (sp)+,d2-d4/a2
 rts
.sect .rom
matrix_offsets: .data1 21,15,9,23,17,11,25,19,13
