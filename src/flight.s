; Electron MVEIT parts 3-8. Ships only; TIDY/TACTICS/SCAN are not implemented.
; Native 68000 arithmetic with original byte-width/sign-magnitude boundaries.
; void move_ship(unsigned char inwk[33], const unsigned char params[4]);
; params = sign-magnitude ALPHA, BETA, DELTA, blueprint maximum speed.
.sect .text
.sect .rom
.sect .data
.sect .bss
.sect .text
.globl _move_ship
.extern _own_rotate
.extern sign_add
_move_ship:
 movem.l d2-d7/a2-a3,-(sp)
 move.l 36(sp),a2
 move.l 40(sp),a3
 ; Part 3: speed*4 wraps as a BYTE before FMLTU's high-byte product.
 moveq #0,d5
 move.b 27(a2),d5
 lsl.b #2,d5
 and.w #255,d5
 lea 0(a2),a0
 lea 10(a2),a1
 moveq #2,d6
forward_axis:
 moveq #0,d0
 move.b (a1),d0
 move.w d0,d1
 and.w #127,d0
 mulu.w d5,d0
 lsr.w #8,d0
 and.w #128,d1
 bsr translate_axis
 addq.l #3,a0
 addq.l #2,a1
 dbra d6,forward_axis
 ; Part 4: byte addition, signed clamp, then unsigned blueprint limit.
 move.b 27(a2),d0
 add.b 28(a2),d0
 bpl speed_positive
 clr.b d0
speed_positive:
 cmp.b 3(a3),d0
 blo speed_ready
 move.b 3(a3),d0
speed_ready:
 move.b d0,27(a2)
 clr.b 28(a2)
 ; Part 5: original sequential universe position rotation.
 bsr position_rotate
 ; Part 6: subtract player speed from object's relative Z.
 lea 6(a2),a0
 moveq #0,d0
 move.b 2(a3),d0
 move.w #128,d1
 bsr translate_axis
orientation_body:
 ; Part 7: MVS4 on nose, roof, side, in the original order.
 lea 9(a2),a0
 moveq #2,d7
vector_loop:
 bsr mvs4_vector
 addq.l #6,a0
 dbra d7,vector_loop
 ; Part 8: already validated MVS5 pitch/roll counters.
 move.l a2,-(sp)
 jsr _own_rotate
 addq.l #4,sp
 movem.l (sp)+,d2-d7/a2-a3
 rts
; MVT1 with zero delta_hi magnitude: d0 delta byte, d1 delta sign, a0 coord.
; Preserve the coordinate's 23 magnitude bits and signed zero.
translate_axis:
 moveq #0,d2
 move.b 2(a0),d2
 lsl.l #8,d2
 move.b 1(a0),d2
 lsl.l #8,d2
 move.b (a0),d2
 move.l d2,d3
 and.l #0x800000,d3
 lsl.l #8,d1
 lsl.l #8,d1
 eor.l d3,d1
 bne translate_opposite
 add.l d2,d0
 or.l d3,d0
 bra translate_store
translate_opposite:
 and.l #0x7fffff,d2
 sub.l d0,d2
 bcc translate_sign
 neg.l d2
 eor.l #0x800000,d3
translate_sign:
 move.l d2,d0
 or.l d3,d0
translate_store:
 move.b d0,(a0)
 lsr.l #8,d0
 move.b d0,1(a0)
 lsr.l #8,d0
 move.b d0,2(a0)
 rts
; Load magnitude of coordinate at a0 into d0.
coordinate_mag:
 moveq #0,d0
 move.b 1(a0),d0
 lsl.w #8,d0
 move.b (a0),d0
 rts
; MVT6: d0 unsigned delta word, d1 original sign byte; a0 coordinate.
; Return magnitude in d0 and sign BYTE (including original low bits) in d1.
mvt6_native:
 moveq #0,d2
 move.b 1(a0),d2
 lsl.w #8,d2
 move.b (a0),d2
 move.b 2(a0),d3
 eor.b d1,d3
 bmi mvt6_opposite
 add.w d2,d0
 rts
mvt6_opposite:
 sub.w d0,d2
 bcc mvt6_coord_larger
 neg.w d2
 move.w d2,d0
 rts
mvt6_coord_larger:
 move.w d2,d0
 eor.b #128,d1
 rts
coordinate_store:
 move.b d0,(a0)
 lsr.w #8,d0
 move.b d0,1(a0)
 move.b d1,2(a0)
 rts
position_rotate:
 moveq #0,d4
 move.b (a3),d4
 and.w #127,d4
 moveq #0,d5
 move.b 1(a3),d5
 and.w #127,d5
 ; K2 = y - alpha*x / 256, retaining MVT6's sign-byte low bits.
 move.l a2,a0
 bsr coordinate_mag
 mulu.w d4,d0
 lsr.l #8,d0
 move.b (a3),d1
 and.b #128,d1
 eor.b #128,d1
 move.b 2(a2),d3
 eor.b d3,d1
 lea 3(a2),a0
 bsr mvt6_native
 move.w d0,d6
 move.b d1,d7
 ; z = z + beta*K2 / 256.
 mulu.w d5,d0
 lsr.l #8,d0
 move.b 1(a3),d1
 and.b #128,d1
 eor.b d7,d1
 lea 6(a2),a0
 bsr mvt6_native
 ; Save full new z magnitude before coordinate_store shifts d0.
 move.w d0,d2
 bsr coordinate_store
 move.w d2,d0
 mulu.w d5,d0
 lsr.l #8,d0
 ; MLTU2 ends with carry CLEAR: MV43 subtracts product PLUS ONE.
 move.b 1(a3),d1
 and.b #128,d1
 eor.b d7,d1
 move.b 8(a2),d3
 eor.b d3,d1
 bmi position_y_add
 ; Use a long subtraction to retain borrow when product == 65535.
 and.l #65535,d6
 and.l #65535,d0
 addq.l #1,d0
 sub.l d0,d6
 bcc position_y_ready
 neg.l d6
 eor.b #128,d7
 bra position_y_ready
position_y_add:
 add.w d0,d6
position_y_ready:
 move.w d6,d0
 move.b d7,d1
 lea 3(a2),a0
 bsr coordinate_store
 ; x = x + alpha*y / 256, using the newly updated y.
 move.w d6,d0
 mulu.w d4,d0
 lsr.l #8,d0
 move.b (a3),d1
 and.b #128,d1
 eor.b d7,d1
 move.l a2,a0
 bsr mvt6_native
 bsr coordinate_store
 rts
; MVS4: four MAD operations, each using the newly updated vector component.
; a0 -> six-byte vector. Each helper receives high byte d0, Q d5,
; original destination pointer a1. Original MULT1 suppresses sign if |Q|=0.
mvs4_vector:
 move.b (a3),d5
 move.b 1(a0),d0
 eor.b #128,d0
 lea 2(a0),a1
 bsr mad_component
 move.b 3(a0),d0
 move.l a0,a1
 bsr mad_component
 move.b 1(a3),d5
 move.b 5(a0),d0
 eor.b #128,d0
 lea 2(a0),a1
 bsr mad_component
 move.b 3(a0),d0
 lea 4(a0),a1
 bsr mad_component
 rts
mad_component:
 move.w d0,d2
 eor.w d5,d2
 and.w #128,d2
 lsl.w #8,d2
 and.w #127,d0
 move.w d5,d1
 and.w #127,d1
 beq mad_zero
 mulu.w d1,d0
 or.w d2,d0
 bra mad_add
mad_zero:
 moveq #0,d0
mad_add:
 moveq #0,d1
 move.b 1(a1),d1
 lsl.w #8,d1
 move.b (a1),d1
 jsr sign_add
 move.b d0,(a1)
 lsr.w #8,d0
 move.b d0,1(a1)
 rts
; int motion_position(inwk, short xyz[3]); renderer adapter only.
; Reject positions outside A1's safe signed-word range, without changing INWK.
.globl _motion_position
_motion_position:
 movem.l d2-d3,-(sp)
 move.l 12(sp),a0
 move.l 16(sp),a1
 moveq #2,d3
position_adapter_loop:
 move.b 2(a0),d1
 and.b #127,d1
 bne position_adapter_reject
 moveq #0,d2
 move.b 1(a0),d2
 lsl.w #8,d2
 move.b (a0),d2
 cmp.w #30000,d2
 bhi position_adapter_reject
 tst.b 2(a0)
 bpl position_adapter_positive
 neg.w d2
position_adapter_positive:
 move.w d2,(a1)+
 addq.l #3,a0
 dbra d3,position_adapter_loop
 moveq #1,d0
 bra position_adapter_return
position_adapter_reject:
 moveq #0,d0
position_adapter_return:
 movem.l (sp)+,d2-d3
 rts

; Shared original parts7/8, used after full-width MV40 planet translation.
.globl _rotate_body
_rotate_body:
 movem.l d2-d7/a2-a3,-(sp)
 move.l 36(sp),a2
 move.l 40(sp),a3
 bra orientation_body
