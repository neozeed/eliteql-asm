; Original main-loop part14, MAS1/MVT3/FAROF2 and NWSPS.
; station_candidate(out36,planet36): 1 if eligible, 0 otherwise.
; Allocation, line heaps and slot ownership are native shell responsibilities.
.sect .text
.globl _station_candidate
_station_candidate:
 movem.l d2-d7/a2-a3,-(sp)
 move.l 36(sp),a2
 move.l 40(sp),a3
 moveq #0,d0
 move.b 2(a3),d0
 or.b 5(a3),d0
 or.b 8(a3),d0
 and.b #127,d0
 bne station_no
 moveq #35,d0
station_clear:
 clr.b 0(a2,d0.w)
 dbra d0,station_clear
 moveq #28,d0
station_copy:
 move.b 0(a3,d0.w),0(a2,d0.w)
 dbra d0,station_copy
 move.l a2,a0
 lea 9(a2),a1
 moveq #2,d7
station_axis:
 ; MAS1 doubles the full sign-magnitude vector, shifting sign into byte3.
 moveq #0,d0
 move.b 1(a1),d0
 lsl.w #8,d0
 move.b (a1),d0
 move.l d0,d2
 and.l #0x8000,d2
 lsl.l #8,d2
 and.l #0x7fff,d0
 add.l d0,d0
 moveq #0,d1
 move.b 2(a0),d1
 lsl.l #8,d1
 move.b 1(a0),d1
 lsl.l #8,d1
 move.b (a0),d1
 move.l d1,d3
 and.l #0x800000,d3
 and.l #0x7fffff,d1
 cmp.l d2,d3
 bne station_sub
 add.l d1,d0
 and.l #0x7fffff,d0
 or.l d2,d0
 bra station_store
station_sub:
 sub.l d0,d1
 bcc station_coord_larger
 neg.l d1
 move.l d2,d3
station_coord_larger:
 move.l d1,d0
 or.l d3,d0
station_store:
 move.b d0,(a0)
 lsr.l #8,d0
 move.b d0,1(a0)
 lsr.l #8,d0
 move.b d0,2(a0)
 and.b #127,d0
 bne station_no
 addq.l #3,a0
 addq.l #2,a1
 dbra d7,station_axis
 cmp.b #192,1(a2)
 bhi station_no
 cmp.b #192,4(a2)
 bhi station_no
 cmp.b #192,7(a2)
 bhi station_no
 move.b #1,32(a2)
 clr.b 30(a2)
 move.b #255,29(a2)
 eor.b #128,10(a2)
 eor.b #128,12(a2)
 eor.b #128,14(a2)
 moveq #1,d0
 bra station_return
station_no:
 moveq #0,d0
station_return:
 movem.l (sp)+,d2-d7/a2-a3
 rts
; TT110/SOS1/NWSPS launch: planet at +65536, station at -256.
.globl _station_launch
_station_launch:
 move.l 4(sp),a0
 move.l 8(sp),a1
 moveq #35,d0
launch_world_zero:
 clr.b 0(a0,d0.w)
 clr.b 0(a1,d0.w)
 dbra d0,launch_world_zero
 move.b #224,14(a0)
 move.b #96,18(a0)
 move.b #96,22(a0)
 move.b #1,8(a0)
 move.b #127,29(a0)
 move.b #127,30(a0)
 move.b #96,14(a1)
 move.b #96,18(a1)
 move.b #96,22(a1)
 ; NwS1 also flips zero nose x/y signs.
 move.b #128,10(a1)
 move.b #128,12(a1)
 move.b #128,8(a1)
 move.b #1,7(a1)
 move.b #255,29(a1)
 move.b #1,32(a1)
 rts
; WARP planet-side arithmetic. warp_planet(planet,blocked): return success.
; This primitive is called by the complete two-body _warp_world below.
.globl _warp_planet
_warp_planet:
 move.l 4(sp),a0
 tst.l 8(sp)
 bne warp_no
 tst.b 8(a0)
 bmi warp_go
 move.b 2(a0),d0
 or.b 5(a0),d0
 or.b 8(a0),d0
 and.b #127,d0
 cmp.b #2,d0
 blo warp_no
warp_go:
 ; ADD of (z_sign,0x81) and (0x81,0x81), storing only high byte.
 move.b 8(a0),d0
 bmi warp_negative
 tst.b d0
 beq warp_cross
 subq.b #1,d0
 bra warp_store
warp_cross:
 move.b #129,d0
 bra warp_store
warp_negative:
 ; Original ADD carries from 0x81+0x81: high magnitude grows by TWO.
 addq.b #2,d0
 or.b #128,d0
warp_store:
 move.b d0,8(a0)
 moveq #1,d0
 rts
warp_no:
 moveq #0,d0
 rts
; Full two-body WARP: the Electron's second body is a frozen type129
; station placeholder, not a rendered sun. Both distance gates precede mutation.
.globl _warp_world
_warp_world:
 movem.l d2/a2-a3,-(sp)
 move.l 16(sp),a2
 move.l 20(sp),a3
 tst.l 24(sp)
 bne warp_world_no
 move.l a2,a0
 bsr warp_distance
 tst.w d0
 beq warp_world_no
 move.l a3,a0
 bsr warp_distance
 tst.w d0
 beq warp_world_no
 clr.l -(sp)
 move.l a2,-(sp)
 jsr _warp_planet
 addq.l #8,sp
 clr.l -(sp)
 move.l a3,-(sp)
 jsr _warp_planet
 addq.l #8,sp
 moveq #1,d0
 bra warp_world_return
warp_world_no:
 moveq #0,d0
warp_world_return:
 movem.l (sp)+,d2/a2-a3
 rts
warp_distance:
 tst.b 8(a0)
 bmi warp_distance_yes
 move.b 2(a0),d0
 or.b 5(a0),d0
 or.b 8(a0),d0
 and.b #127,d0
 cmp.b #2,d0
 blo warp_no
warp_distance_yes:
 moveq #1,d0
 rts
