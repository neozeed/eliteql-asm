; Electron PLANET/PROJ/DVID3B2/CIRCLE, native QL clipping and XOR cache.
.sect .text
.globl _planet_geometry
_planet_geometry:
 movem.l d2-d7/a2-a3,-(sp)
 move.l 36(sp),a2
 move.l 40(sp),a3
 clr.w (a3)
 move.b 8(a2),d0
 cmp.b #48,d0
 bhs pg_done
 or.b 7(a2),d0
 beq pg_done
 lea 6(a2),a0
 bsr pg_load
 move.l d0,d7
 move.l a2,a0
 bsr pg_load
 bsr pg_divide
 cmp.l #1024,d0
 bhs pg_done
 btst #7,2(a2)
 beq pg_x
 neg.w d0
pg_x:
 add.w #128,d0
 move.w d0,2(a3)
 lea 3(a2),a0
 bsr pg_load
 bsr pg_divide
 cmp.l #1024,d0
 bhs pg_done
 btst #7,5(a2)
 bne pg_y
 neg.w d0
pg_y:
 add.w #96,d0
 move.w d0,4(a3)
 move.l #24576,d0
 bsr pg_divide
 cmp.l #256,d0
 blo pg_radius
 move.w #248,d0
pg_radius:
 move.w d0,6(a3)
 move.w #1,(a3)
pg_done:
 movem.l (sp)+,d2-d7/a2-a3
 rts
pg_load:
 moveq #0,d0
 move.b 2(a0),d0
 and.w #127,d0
 lsl.l #8,d0
 move.b 1(a0),d0
 lsl.l #8,d0
 move.b (a0),d0
 rts
; Original DVID3B scaling: force numerator odd, normalize both, divide
; only top bytes, then undo their relative shift count. d7 denominator.
pg_divide:
 or.l #1,d0
 moveq #0,d2
pg_numerator:
 cmp.l #0x400000,d0
 bhs pg_denominator
 lsl.l #1,d0
 addq.w #1,d2
 bra pg_numerator
pg_denominator:
 move.l d7,d1
pg_den_loop:
 lsl.l #1,d1
 subq.w #1,d2
 btst #23,d1
 beq pg_den_loop
 swap d0
 and.l #255,d0
 swap d1
 and.w #255,d1
 lsl.l #8,d0
 divu.w d1,d0
 and.l #255,d0
 tst.w d2
 bmi pg_shift_left
 lsr.l d2,d0
 rts
pg_shift_left:
 neg.w d2
 lsl.l d2,d0
 rts

.globl _planet_frame
_planet_frame:
 movem.l d2-d7/a2-a6,-(sp)
 move.l 48(sp),a6
 move.l 52(sp),a5
 move.l 56(sp),a4
 move.l a5,-(sp)
 move.l a6,-(sp)
 jsr _render_cache
 addq.l #8,sp
 clr.w 12(a5)
 sub.l #20,sp
 move.l sp,-(sp)
 move.l a4,-(sp)
 jsr _planet_geometry
 addq.l #8,sp
 tst.w (sp)
 beq pv_done
 move.w #8,8(sp)
 cmp.w #9,6(sp)
 blo pv_step_ready
 move.w #4,8(sp)
pv_step_ready:
 clr.w 10(sp)
pv_point:
 moveq #0,d0
 move.w 10(sp),d0
 bsr pv_sine
 cmp.w #33,10(sp)
 blo pv_x
 neg.w d0
pv_x:
 add.w 2(sp),d0
 move.w d0,16(sp)
 move.w 10(sp),d0
 add.w #16,d0
 bsr pv_sine
 move.w 10(sp),d1
 add.w #16,d1
 and.w #63,d1
 cmp.w #33,d1
 blo pv_y
 neg.w d0
pv_y:
 add.w 4(sp),d0
 move.w d0,18(sp)
 tst.w 10(sp)
 beq pv_next
 move.w 12(sp),d0
 move.w 14(sp),d1
 move.w 16(sp),d2
 move.w 18(sp),d3
 jsr clip_segment
 tst.w d4
 beq pv_next
 moveq #0,d5
 move.w 12(a5),d5
 lsl.w #2,d5
 lea 16(a5,d5.w),a1
 move.b d0,(a1)+
 move.b d1,(a1)+
 move.b d2,(a1)+
 move.b d3,(a1)+
 addq.w #1,12(a5)
 move.l a6,a0
 jsr xor_segment
pv_next:
 move.l 16(sp),12(sp)
 move.w 8(sp),d0
 add.w d0,10(sp)
 cmp.w #65,10(sp)
 blo pv_point
pv_done:
 add.l #20,sp
 movem.l (sp)+,d2-d7/a2-a6
 rts
pv_sine:
 and.w #31,d0
 lea planet_sine,a0
 move.b 0(a0,d0.w),d0
 and.w #255,d0
 ; Return-address pushes caller's radius from6(sp) to10(sp).
 mulu.w 10(sp),d0
 lsr.w #8,d0
 rts

; altitude(planet36,scratchQ): packed result bit8=collision, low8=ALTIT.
.globl _planet_altitude
_planet_altitude:
 movem.l d2-d4,-(sp)
 move.l 16(sp),a0
 moveq #0,d0
 move.b 2(a0),d0
 or.b 5(a0),d0
 or.b 8(a0),d0
 and.b #127,d0
 bne pa_far
 moveq #0,d2
 moveq #2,d4
pa_sum:
 moveq #0,d0
 move.b 1(a0),d0
 mulu.w d0,d0
 lsr.w #8,d0
 add.w d0,d2
 cmp.w #256,d2
 bhs pa_far
 addq.l #3,a0
 dbra d4,pa_sum
 sub.w #37,d2
 bmi pa_inside
 lsl.w #8,d2
 move.l 20(sp),d0
 and.w #255,d0
 or.w d0,d2
 ; LL5 integer square root, exact 16-bit result.
 moveq #0,d0
 moveq #1,d1
pa_root:
 cmp.w d1,d2
 blo pa_root_done
 sub.w d1,d2
 addq.w #2,d1
 addq.w #1,d0
 bra pa_root
pa_root_done:
 tst.w d0
 beq pa_crash
 bra pa_return
pa_far:
 move.w #255,d0
 bra pa_return
pa_inside:
 move.w #511,d0
 bra pa_return
pa_crash:
 move.w #256,d0
pa_return:
 movem.l (sp)+,d2-d4
 rts
.sect .data
planet_sine: .data1 0,25,50,74,98,121,142,162,181,198,213,226,237,245,251,255,255,255,251,245,237,226,213,198,181,162,142,121,98,74,50,25
.align 2
