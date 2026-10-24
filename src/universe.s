; SOLAR/ZINF/SOS1 planet workspace; native station pool remains an adapter.
; solar(planet36,seed6,tech,oldLegal): returns original planet type128/130.
.sect .text
.globl _solar_planet
_solar_planet:
 move.l 4(sp),a0
 move.l 8(sp),a1
 moveq #35,d0
solar_zero:
 clr.b 0(a0,d0.w)
 dbra d0,solar_zero
 move.b #96,18(a0)
 move.b #96,22(a0)
 move.b #224,14(a0)
 move.l 16(sp),d1
 and.w #1,d1
 moveq #0,d0
 move.b 1(a1),d0
 and.w #7,d0
 addq.w #6,d0
 add.w d1,d0
 move.w d0,d1
 lsr.w #1,d0
 move.b d0,8(a0)
 lsr.w #1,d0
 and.w #1,d1
 lsl.w #7,d1
 or.w d1,d0
 move.b d0,2(a0)
 move.b d0,5(a0)
 move.b #127,29(a0)
 move.b #127,30(a0)
 move.l 12(sp),d0
 and.w #2,d0
 or.w #128,d0
 rts

; Electron TT22 star coordinates and PIXEL/TWOS2 dashes, TT14 fuel radius,
; TT15 clipped current cross (size7) and cursor cross (size4).
; galaxy_chart(screen,travel) wrapper uses selected system as cursor.
.globl _galaxy_chart
_galaxy_chart:
 move.l 8(sp),a0
 subq.l #2,sp
 move.b 43(a0),(sp)
 move.b 41(a0),1(sp)
 move.l sp,a0
 move.l a0,-(sp)
 move.l 14(sp),-(sp)
 move.l 14(sp),-(sp)
 jsr _galaxy_chart_cursor
 lea 14(sp),sp
 rts
.globl _galaxy_chart_cursor
_galaxy_chart_cursor:
 movem.l d2-d7/a2-a6,-(sp)
 move.l 48(sp),a5
 move.l 52(sp),a6
 move.l 56(sp),a4
 sub.l #168,sp
 move.l a6,a0
 move.l sp,a1
 moveq #5,d0
chart_seed:
 move.b (a0)+,(a1)+
 dbra d0,chart_seed
 ; TT14 range circle: radius QQ14>>2, angular step2.
 move.l #2,-(sp)
 moveq #0,d0
 move.b 9(a6),d0
 lsr.w #2,d0
 move.l d0,-(sp)
 moveq #0,d0
 move.b 17(a6),d0
 lsr.w #1,d0
 add.w #24,d0
 move.l d0,-(sp)
 moveq #0,d0
 move.b 19(a6),d0
 move.l d0,-(sp)
 pea 40(sp)
 move.l a5,-(sp)
 jsr _circle_xy
 lea 24(sp),sp
 moveq #0,d0
 move.b 19(a6),d0
 moveq #0,d1
 move.b 17(a6),d1
 moveq #7,d5
 bsr chart_cross
 moveq #0,d7
chart_system:
 moveq #0,d0
 moveq #0,d1
 move.b 3(sp),d0
 move.b 1(sp),d1
 lsr.w #1,d1
 add.w #24,d1
 move.w d0,d2
 and.w #7,d2
 beq chart_dash
 subq.w #1,d0
chart_dash:
 move.w d0,d2
 addq.w #1,d2
 move.w d1,d3
 move.l a5,a0
 jsr xor_segment
 ; Four twists advance one complete system, exactly TT20.
 move.l sp,a0
 move.l a0,-(sp)
 move.l #1,-(sp)
 move.l a0,-(sp)
 jsr _galaxy_system
 lea 12(sp),sp
 addq.w #1,d7
 cmp.w #256,d7
 blo chart_system
 moveq #0,d0
 move.b (a4),d0
 moveq #0,d1
 move.b 1(a4),d1
 moveq #4,d5
 bsr chart_cross
 add.l #168,sp
 movem.l (sp)+,d2-d7/a2-a6
 rts
.globl _chart_cursor_xor
_chart_cursor_xor:
 movem.l d2-d7/a2-a6,-(sp)
 move.l 48(sp),a5
 move.l 52(sp),a4
 moveq #0,d0
 move.b (a4),d0
 moveq #0,d1
 move.b 1(a4),d1
 moveq #4,d5
 bsr chart_cross
 movem.l (sp)+,d2-d7/a2-a6
 rts
; TT15 long-range clipping. D0 galacticX,D1 galacticY,D5 cross size.
chart_cross:
 lsr.w #1,d1
 add.w #24,d1
 move.w d0,d2
 move.w d1,d3
 sub.w d5,d0
 bpl chart_cross_left
 clr.w d0
chart_cross_left:
 add.w d5,d2
 cmp.w #255,d2
 bls chart_cross_right
 move.w #255,d2
chart_cross_right:
 movem.l d0-d3/d5,-(sp)
 move.l a5,a0
 jsr xor_segment
 movem.l (sp)+,d0-d3/d5
 ; Recover unclipped centre from caller, not from the clipped horizontal ends.
 moveq #0,d0
 cmp.w #7,d5
 bne chart_cross_cursor
 move.b 19(a6),d0
 bra chart_cross_vertical
chart_cross_cursor:
 move.b (a4),d0
chart_cross_vertical:
 move.w d0,d2
 sub.w d5,d1
 cmp.w #24,d1
 bhs chart_cross_top
 moveq #24,d1
chart_cross_top:
 add.w d5,d3
 cmp.w #151,d3
 bls chart_cross_bottom
 move.w #151,d3
chart_cross_bottom:
 move.l a5,a0
 jsr xor_segment
 rts
