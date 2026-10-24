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
; Chart(screen,travel64): original 256 seeds, x=s1_hi, y=s0_hi/2.
; Draw in QL viewport y32..159; crosses mark current and selected systems.
.globl _galaxy_chart
_galaxy_chart:
 movem.l d2-d7/a2-a6,-(sp)
 move.l 48(sp),a5
 move.l 52(sp),a6
 sub.l #24,sp
 move.l a6,a0
 move.l sp,a1
 moveq #5,d0
chart_seed:
 move.b (a0)+,(a1)+
 dbra d0,chart_seed
 moveq #0,d7
chart_system:
 move.l sp,a0
 move.l a0,-(sp)
 clr.l -(sp)
 move.l a0,-(sp)
 jsr _galaxy_system
 lea 12(sp),sp
 moveq #0,d0
 moveq #0,d1
 move.b 3(sp),d0
 move.b 1(sp),d1
 lsr.w #1,d1
 add.w #32,d1
 move.w d0,d2
 move.w d1,d3
 move.l a5,a0
 jsr xor_segment
 ; Next original system: galaxy_system(seed,1,seed) performs four twists.
 move.l sp,a0
 move.l a0,-(sp)
 move.l #1,-(sp)
 move.l a0,-(sp)
 jsr _galaxy_system
 lea 12(sp),sp
 addq.w #1,d7
 cmp.w #256,d7
 blo chart_system
 add.l #24,sp
 lea 16(a6),a4
 bsr chart_cross
 lea 40(a6),a4
 ; Same coordinates: only one cross, so XOR does not erase the location.
 move.b 3(a4),d0
 cmp.b 19(a6),d0
 bne chart_target
 move.b 1(a4),d0
 cmp.b 17(a6),d0
 beq chart_done
chart_target:
 bsr chart_cross
chart_done:
 movem.l (sp)+,d2-d7/a2-a6
 rts
chart_cross:
 moveq #0,d0
 moveq #0,d1
 move.b 3(a4),d0
 move.b 1(a4),d1
 lsr.w #1,d1
 add.w #32,d1
 move.w d0,d2
 move.w d1,d3
 subq.w #3,d0
 addq.w #3,d2
 movem.l d0-d3,-(sp)
 jsr clip_segment
 tst.w d4
 beq chart_vertical
 move.l a5,a0
 jsr xor_segment
chart_vertical:
 movem.l (sp)+,d0-d3
 addq.w #3,d0
 move.w d0,d2
 subq.w #3,d1
 addq.w #3,d3
 jsr clip_segment
 tst.w d4
 beq chart_cross_done
 move.l a5,a0
 jsr xor_segment
chart_cross_done:
 rts
