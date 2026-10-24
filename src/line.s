; Native 68000 QL mode-8 XOR line backend. No C calls, no pixel call per step.
; C ABI: xor_line(screen,x0,y0,x1,y1); input coordinates must be -8191..8191.
; Internal clip_segment: D0..D3 words -> clipped D0..D3; D4=1 accept, 0 reject.
; xor_segment: clipped word coordinates in D0..D3, A0 screen; preserves all.
.sect .text
.sect .rom
.sect .data
.sect .bss
.sect .text
.globl _xor_line
.globl clip_segment
.globl xor_segment
_xor_line:
 movem.l d2-d7/a2-a6,-(sp)
 move.l 48(sp),a0
 move.l 52(sp),d0
 move.l 56(sp),d1
 move.l 60(sp),d2
 move.l 64(sp),d3
 bsr clip_segment
 tst.w d4
 beq line_return
 bsr xor_segment
line_return:
 movem.l (sp)+,d2-d7/a2-a6
 rts
; Outcode for D0,D1. Return D4. Inclusive viewport 0..255,0..191.
code_xy:
 moveq #0,d4
 tst.w d0
 bge code_right
 or.w #1,d4
code_right:
 cmp.w #255,d0
 ble code_top
 or.w #2,d4
code_top:
 tst.w d1
 bge code_bottom
 or.w #4,d4
code_bottom:
 cmp.w #191,d1
 ble code_done
 or.w #8,d4
code_done:
 rts
clip_segment:
 movem.w d0-d3,clip_xy
 move.w #8,clip_left
clip_again:
 move.w clip_xy,d0
 move.w clip_xy+2,d1
 bsr code_xy
 move.w d4,clip_a
 move.w clip_xy+4,d0
 move.w clip_xy+6,d1
 bsr code_xy
 move.w d4,d5
 and.w clip_a,d5
 bne clip_reject
 move.w d4,d5
 or.w clip_a,d5
 beq clip_accept
 tst.w clip_left
 beq clip_reject
 subq.w #1,clip_left
 move.w clip_a,d5
 bne clip_have
 move.w d4,d5
clip_have:
 move.w d5,clip_code
 move.w clip_xy,d0
 move.w clip_xy+2,d1
 move.w clip_xy+4,d2
 move.w clip_xy+6,d3
 move.w d2,d6
 sub.w d0,d6
 move.w d3,d7
 sub.w d1,d7
 btst #3,d5
 bne clip_bottom
 btst #2,d5
 bne clip_top
 btst #1,d5
 bne clip_right
 moveq #0,d4
 bra clip_vertical
clip_right:
 move.w #255,d4
clip_vertical:
 tst.w d6
 beq clip_reject
 move.w d4,d5
 sub.w d0,d5
 muls.w d7,d5
 divs.w d6,d5
 add.w d5,d1
 move.w d4,d0
 bra clip_store
clip_bottom:
 move.w #191,d4
 bra clip_horizontal
clip_top:
 moveq #0,d4
clip_horizontal:
 tst.w d7
 beq clip_reject
 move.w d4,d5
 sub.w d1,d5
 muls.w d6,d5
 divs.w d7,d5
 add.w d5,d0
 move.w d4,d1
clip_store:
 tst.w clip_a
 beq clip_second
 move.w d0,clip_xy
 move.w d1,clip_xy+2
 bra clip_again
clip_second:
 move.w d0,clip_xy+4
 move.w d1,clip_xy+6
 bra clip_again
clip_accept:
 movem.w clip_xy,d0-d3
 moveq #1,d4
 rts
clip_reject:
 moveq #0,d4
 rts
xor_segment:
 movem.l d0-d7/a0-a2,-(sp)
 ; Normalize to increasing X. Mask stepping then needs no direction branch.
 cmp.w d0,d2
 bge xor_ordered
 exg d0,d2
 exg d1,d3
xor_ordered:
 move.w d1,d7
 lsl.w #7,d7
 lea 0(a0,d7.w),a1
 ; Y*128 can exceed signed 16 bits only outside the 192-line viewport.
 move.w d0,d7
 lsr.w #2,d7
 add.w d7,d7
 adda.w d7,a1
 sub.w d0,d2
 sub.w d1,d3
 move.w #128,d5
 tst.w d3
 bge xor_dy
 neg.w d3
 neg.w d5
xor_dy:
 and.w #3,d0
 add.w d0,d0
 lea xor_masks(pc),a2
 move.w 0(a2,d0.w),d4
 move.w d2,d0
 move.w d3,d1
 cmp.w d0,d1
 bgt xor_steep
 move.w d0,d2
 lsr.w #1,d2
 move.w d0,d3
xor_shallow_loop:
 eor.w d4,(a1)
 sub.w d1,d2
 bge xor_shallow_x
 adda.w d5,a1
 add.w d0,d2
xor_shallow_x:
 ror.w #2,d4
 bcc xor_shallow_next
 move.w #0x80c0,d4
 addq.l #2,a1
xor_shallow_next:
 dbra d3,xor_shallow_loop
 bra xor_done
xor_steep:
 move.w d1,d2
 lsr.w #1,d2
 move.w d1,d3
xor_steep_loop:
 eor.w d4,(a1)
 sub.w d0,d2
 bge xor_steep_y
 ror.w #2,d4
 bcc xor_steep_adjust
 move.w #0x80c0,d4
 addq.l #2,a1
xor_steep_adjust:
 add.w d1,d2
xor_steep_y:
 adda.w d5,a1
 dbra d3,xor_steep_loop
xor_done:
 movem.l (sp)+,d0-d7/a0-a2
 rts
xor_masks:
 .data2 0x80c0,0x2030,0x080c,0x0203
.sect .bss
.align 2
clip_xy: .space 8
clip_a: .space 2
clip_code: .space 2
clip_left: .space 2
.sect .text
.globl _hash_screen
_hash_screen:
 movem.l d2-d3,-(sp)
 move.l 12(sp),a0
 move.l #5381,d0
 move.w #32767,d1
hash_loop:
 move.l d0,d3
 lsl.l #5,d0
 add.l d3,d0
 moveq #0,d2
 move.b (a0)+,d2
 eor.l d2,d0
 dbra d1,hash_loop
 movem.l (sp)+,d2-d3
 rts
