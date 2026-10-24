; Hostile TA18/TA34 and ECM adapter. Sound is absent: explicit OOPS C=1.
.sect .text
.globl _hostile_missile
.extern _missile_steer
.extern _player_damage
_hostile_missile:
 move.l 4(sp),a0
 move.l 8(sp),a1
 tst.b 4(a1)
 bne missile_ecm
 move.b 1(a0),d0
 or.b 4(a0),d0
 or.b 7(a0),d0
 beq missile_impact
 jmp _missile_steer
missile_ecm:
 or.b #128,31(a0)
 move.b (a0),d0
 or.b 3(a0),d0
 or.b 6(a0),d0
 beq missile_blast
 moveq #6,d0
 rts
missile_blast:
 moveq #80,d0
 bra missile_damage
missile_impact:
 or.b #128,31(a0)
 move.w #250,d0
missile_damage:
 move.l 16(sp),a1
 moveq #0,d1
 move.b 8(a0),d1
 move.l #1,-(sp)
 move.l d1,-(sp)
 move.l d0,-(sp)
 move.l a1,-(sp)
 jsr _player_damage
 lea 16(sp),sp
 addq.l #3,d0
 rts
; SFS1 normal parent + NWSHP blueprint initialization; private heap pointers zero.
.globl _spawn_child
_spawn_child:
 move.l 4(sp),a0
 move.l 8(sp),a1
 move.l 12(sp),d1
 moveq #35,d0
child_copy:
 move.b 0(a0,d0.w),0(a1,d0.w)
 dbra d0,child_copy
 move.l d1,a0
 move.b #254,32(a1)
 and.b #254,29(a1)
 move.w 24(a0),d0
 move.b d0,35(a1)
 move.w 30(a0),d0
 and.b #7,d0
 move.b d0,31(a1)
 clr.b 33(a1)
 clr.b 34(a1)
 rts
; ECM state {ECMA,ECMP}, status {front,aft,energy,heat,unit}.
; Original MA16/MA69: one energy, two countdown ticks per simulation update.
.globl _ecm_step
_ecm_step:
 move.l 4(sp),a0
 move.l 8(sp),a1
 tst.b 1(a0)
 beq ecm_count
 subq.b #1,2(a1)
 bne ecm_count
 addq.b #1,2(a1)
 bra ecm_off
ecm_count:
 tst.b (a0)
 beq ecm_done
 subq.b #2,(a0)
 bne ecm_done
ecm_off:
 clr.b (a0)
 clr.b 1(a0)
ecm_done:
 rts
