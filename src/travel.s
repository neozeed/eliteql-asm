; Native TT54/TT20, cpl, TT24, TT111 distance, hyp/wW/TT107, Ghy.
; State64: galaxy seed6,galaxy,current,target,fuel,GHYP,count,tick,kind,
; fluct,error,current record24,target record24. Records:seed6,econ,gov,tech,
; uppercase name9,padding6. Public entries follow the QDOS C ABI.
.sect .text
.globl _galaxy_system
_galaxy_system:
 movem.l d2-d7/a2-a4,-(sp)
 move.l 40(sp),a0
 move.l 44(sp),d7
 move.l 48(sp),a2
 moveq #0,d0
 moveq #5,d1
gs_copy:
 move.b (a0)+,(a2)+
 dbra d1,gs_copy
 subq.l #6,a2
 move.l a2,a0
 and.w #255,d7
 lsl.w #2,d7
 subq.w #1,d7
 bmi gs_data
gs_twists:
 bsr seed_twist
 dbra d7,gs_twists
gs_data:
 moveq #0,d0
 move.b 1(a2),d0
 and.w #7,d0
 moveq #0,d1
 move.b 2(a2),d1
 lsr.w #3,d1
 and.w #7,d1
 move.b d1,7(a2)
 cmp.w #2,d1
 bhs gs_econ
 or.w #2,d0
gs_econ:
 move.b d0,6(a2)
 eor.w #7,d0
 moveq #0,d2
 move.b 3(a2),d2
 and.w #3,d2
 add.w d2,d0
 addq.w #1,d1
 lsr.w #1,d1
 add.w d1,d0
 move.b d0,8(a2)
 ; cpl twists a temporary seed; three/four digrams, skip token0 and '?'.
 subq.l #6,sp
 move.l sp,a0
 move.l (a2),(a0)
 move.w 4(a2),4(a0)
 lea 9(a2),a3
 moveq #2,d7
 btst #6,(a2)
 beq gs_name
 addq.w #1,d7
gs_name:
 moveq #0,d0
 move.b 5(a0),d0
 and.w #31,d0
 beq gs_name_next
 add.w d0,d0
 lea digrams,a4
 move.b 0(a4,d0.w),(a3)+
 move.b 1(a4,d0.w),d1
 cmp.b #63,d1
 beq gs_name_next
 move.b d1,(a3)+
gs_name_next:
 bsr seed_twist
 dbra d7,gs_name
 clr.b (a3)
 addq.l #6,sp
 movem.l (sp)+,d2-d7/a2-a4
 rts
seed_twist:
 moveq #0,d0
 move.b 1(a0),d0
 lsl.w #8,d0
 move.b (a0),d0
 moveq #0,d1
 move.b 3(a0),d1
 lsl.w #8,d1
 move.b 2(a0),d1
 add.w d1,d0
 move.w 2(a0),(a0)
 move.w 4(a0),2(a0)
 move.b 5(a0),d1
 lsl.w #8,d1
 move.b 4(a0),d1
 add.w d1,d0
 move.b d0,4(a0)
 lsr.w #8,d0
 move.b d0,5(a0)
 rts
.globl _galaxy_distance
_galaxy_distance:
 move.l 4(sp),a0
 move.l 8(sp),a1
 movem.l d2-d3,-(sp)
 moveq #0,d0
 moveq #0,d1
 move.b 3(a0),d0
 move.b 3(a1),d1
 sub.w d1,d0
 bpl gd_x
 neg.w d0
gd_x:
 mulu.w d0,d0
 move.l d0,d2
 moveq #0,d0
 moveq #0,d1
 move.b 1(a0),d0
 move.b 1(a1),d1
 sub.w d1,d0
 bpl gd_y
 neg.w d0
gd_y:
 lsr.w #1,d0
 mulu.w d0,d0
 add.w d0,d2
 and.l #65535,d2
 ; LL5 floor square-root of the wrapped 16-bit sum, then multiply by4.
 moveq #0,d0
 moveq #7,d3
gd_sqrt:
 bset d3,d0
 move.w d0,d1
 mulu.w d1,d1
 cmp.l d2,d1
 bls gd_bit_ok
 bclr d3,d0
gd_bit_ok:
 dbra d3,gd_sqrt
 lsl.w #2,d0
 movem.l (sp)+,d2-d3
 rts
.globl _travel_select
_travel_select:
 movem.l d2/a2,-(sp)
 move.l 12(sp),a2
 tst.b 11(a2)
 bne ts_done
 move.l 16(sp),d2
 move.b d2,8(a2)
 pea 40(a2)
 move.l d2,-(sp)
 move.l a2,-(sp)
 jsr _galaxy_system
 lea 12(sp),sp
ts_done:
 movem.l (sp)+,d2/a2
 rts
.globl _travel_init
_travel_init:
 move.l a2,-(sp)
 move.l 8(sp),a2
 move.l a2,a0
 moveq #15,d0
ti_zero:
 clr.l (a0)+
 dbra d0,ti_zero
 move.b #0x4a,(a2)
 move.b #0x5a,1(a2)
 move.b #0x48,2(a2)
 move.b #0x02,3(a2)
 move.b #0x53,4(a2)
 move.b #0xb7,5(a2)
 move.b #7,7(a2)
 move.b #70,9(a2)
 move.b #255,10(a2)
 pea 16(a2)
 move.l #7,-(sp)
 move.l a2,-(sp)
 jsr _galaxy_system
 lea 12(sp),sp
 move.l #7,-(sp)
 move.l a2,-(sp)
 jsr _travel_select
 addq.l #8,sp
 move.l (sp)+,a2
 rts
; start(state,galactic,docked):0 started,1 docked,2 busy,3 zero distance,
; 4 range,5 no drive. Selected seeds are frozen during the countdown.
.globl _travel_start
_travel_start:
 move.l a2,-(sp)
 move.l 8(sp),a2
 moveq #1,d0
 tst.l 16(sp)
 bne hs_exit
 moveq #2,d0
 tst.b 11(a2)
 bne hs_exit
 tst.l 12(sp)
 beq hs_normal
 moveq #5,d0
 tst.b 10(a2)
 beq hs_exit
 move.b #2,13(a2)
 clr.b 10(a2)
 bra hs_begin
hs_normal:
 pea 40(a2)
 pea 16(a2)
 jsr _galaxy_distance
 addq.l #8,sp
 tst.w d0
 beq hs_zero
 moveq #0,d1
 move.b 9(a2),d1
 cmp.w d1,d0
 bhi hs_range
 move.b #1,13(a2)
hs_begin:
 move.b #15,11(a2)
 move.b #15,12(a2)
 moveq #0,d0
 bra hs_exit
hs_zero:
 moveq #3,d0
 bra hs_exit
hs_range:
 moveq #4,d0
hs_exit:
 move.b d0,15(a2)
 move.l (sp)+,a2
 rts
; tick returns arrival kind, only on final tick. Original TT107 counters.
.globl _travel_tick
_travel_tick:
 move.l 4(sp),a0
 moveq #0,d0
 tst.b 11(a0)
 beq ht_done
 subq.b #1,12(a0)
 bne ht_done
 move.b #5,12(a0)
 subq.b #1,11(a0)
 bne ht_done
 move.b 13(a0),d0
ht_done:
 rts
; arrival(state,commander,fluct): native scene commits after TT107 countdown.
; Superior Ghy nearest(96,96), first minimum of floor(abs dx/2)+floor(abs dy/2).
.globl _travel_arrive
_travel_arrive:
 movem.l d2-d7/a2-a3,-(sp)
 move.l 36(sp),a2
 move.l 40(sp),a3
 move.l 44(sp),d0
 move.b d0,14(a2)
 cmp.b #2,13(a2)
 beq ha_galaxy
 pea 40(a2)
 pea 16(a2)
 jsr _galaxy_distance
 addq.l #8,sp
 sub.b d0,9(a2)
 bra ha_copy
ha_galaxy:
 clr.b 6(a3)
 addq.b #1,6(a2)
 and.b #7,6(a2)
 moveq #5,d0
ha_rotate:
 move.b 0(a2,d0.w),d1
 rol.b #1,d1
 move.b d1,0(a2,d0.w)
 dbra d0,ha_rotate
 sub.l #24,sp
 move.l (a2),(sp)
 move.w 4(a2),4(sp)
 moveq #0,d7
 moveq #127,d6
 moveq #0,d5
ha_nearest:
 move.l sp,a0
 move.l a0,-(sp)
 clr.l -(sp)
 move.l a0,-(sp)
 jsr _galaxy_system
 lea 12(sp),sp
 moveq #0,d0
 move.b 3(sp),d0
 sub.w #96,d0
 bpl ha_x
 neg.w d0
ha_x:
 lsr.w #1,d0
 moveq #0,d1
 move.b 1(sp),d1
 sub.w #96,d1
 bpl ha_y
 neg.w d1
ha_y:
 lsr.w #1,d1
 add.w d1,d0
 cmp.w d6,d0
 bhs ha_next
 move.w d0,d6
 move.w d7,d5
ha_next:
 move.l sp,a0
 bsr seed_twist
 bsr seed_twist
 bsr seed_twist
 bsr seed_twist
 addq.w #1,d7
 cmp.w #256,d7
 blo ha_nearest
 add.l #24,sp
 clr.b 11(a2)
 move.l d5,-(sp)
 move.l a2,-(sp)
 jsr _travel_select
 addq.l #8,sp
ha_copy:
 move.b 8(a2),7(a2)
 lea 40(a2),a0
 lea 16(a2),a1
 moveq #5,d0
ha_copy_loop:
 move.l (a0)+,(a1)+
 dbra d0,ha_copy_loop
 ; SOLAR legal decay; new galaxy is already clean.
 move.b 6(a3),d0
 lsr.b #1,d0
 move.b d0,6(a3)
 clr.b 13(a2)
 clr.b 11(a2)
 clr.b 15(a2)
 movem.l (sp)+,d2-d7/a2-a3
 rts
; Fuel purchase: original PRXS=(70-QQ14)*2 tenths, fill only if affordable.
.globl _travel_refuel
_travel_refuel:
 move.l 4(sp),a0
 move.l 8(sp),a1
 moveq #70,d0
 sub.b 9(a0),d0
 add.w d0,d0
 cmp.l (a1),d0
 bhi tr_fail
 sub.l d0,(a1)
 move.b #70,9(a0)
 moveq #0,d0
 rts
tr_fail:
 moveq #1,d0
 rts
.sect .data
.align 2
digrams: .ascii "ALLEXEGEZACEBISOUSESARMAINDIREA?ERATENBERALAVETIEDORQUANTEISRION"
