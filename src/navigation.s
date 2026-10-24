; Original SPS1/SPS3 planet vector: use coordinate high and sign bytes.
.sect .text
.globl _planet_vector
.extern _tactics_vector
_planet_vector:
 movem.l d2/a2-a3,-(sp)
 move.l 16(sp),a2
 move.l 20(sp),a3
 lea -12(sp),sp
 move.l sp,a0
 moveq #2,d2
planet_axis:
 move.b 1(a2),(a0)+
 move.b 2(a2),d0
 and.b #127,d0
 move.b d0,(a0)+
 move.b 2(a2),d0
 and.b #128,d0
 move.b d0,(a0)+
 addq.l #3,a2
 dbra d2,planet_axis
 move.l sp,a0
 move.l a3,-(sp)
 move.l a0,-(sp)
 jsr _tactics_vector
 addq.l #8,sp
 lea 12(sp),sp
 movem.l (sp)+,d2/a2-a3
 rts
; MSBAR/MDIALS equivalent pixels in QL mode 4, screen/player[4].
; Four five-row indicators at logical x=16,24,32,40, y=241..245.
.globl _missile_icons
_missile_icons:
 movem.l d2-d7/a2-a4,-(sp)
 move.l 40(sp),a2
 move.l 44(sp),a3
 moveq #4,d7
icons_slot:
 moveq #0,d6
 moveq #0,d0
 move.b (a3),d0
 cmp.w d7,d0
 blo icons_shape
 moveq #9,d6
 cmp.w d7,d0
 bne icons_shape
 tst.b 1(a3)
 beq icons_lock
 moveq #13,d6
icons_lock:
 tst.b 2(a3)
 bmi icons_shape
 moveq #17,d6
icons_shape:
 lea icon_bits,a4
 tst.w d6
 bne icons_have_shape
 moveq #4,d6
icons_have_shape:
 adda.w d6,a4
 move.w d7,d0
 lsl.w #3,d0
 neg.w d0
 add.w #48,d0
 ; Each logical 8-pixel block occupies four QL bytes.
 lsr.w #1,d0
 move.l a2,a0
 adda.w d0,a0
 adda.l #31360,a0
 moveq #4,d5
icons_row:
 moveq #0,d2
 moveq #0,d3
 move.b (a4),d4
 subq.l #1,a4
 moveq #7,d1
icons_pixels:
 lsl.w #2,d2
 lsl.w #2,d3
 add.b d4,d4
 bcc icons_black
 or.w #2,d2
 or.w #3,d3
icons_black:
 dbra d1,icons_pixels
 ; Interleave ink bitplane bytes (mode4 green+white mapping).
 move.w d2,d0
 lsr.w #8,d0
 and.b #85,(a0)
 or.b d0,(a0)
 move.w d3,d0
 lsr.w #8,d0
 move.b d0,1(a0)
 and.b #85,2(a0)
 or.b d2,2(a0)
 move.b d3,3(a0)
 lea -128(a0),a0
 dbra d5,icons_row
 subq.w #1,d7
 bne icons_slot
 movem.l (sp)+,d2-d7/a2-a4
 rts
.sect .rom
; Indexed by source Y and read backwards; native rows run bottom to top.
icon_bits:
 .data1 0,0,0,0,0,252,252,252,252,252,132,180,132,252,196,236,236,252
