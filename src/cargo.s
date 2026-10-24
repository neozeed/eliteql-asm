; Native tnpr: preserve byte ADC carry between all 13 tonne stocks.
.sect .text
.globl _cargo_room
_cargo_room:
 move.l d2,-(sp)
 move.l 8(sp),a0
 move.l 12(sp),d0
 cmp.w #12,d0
 bhi cargo_kg
 move.l 16(sp),d0
 and.w #255,d0
 moveq #12,d1
 moveq #1,d2
 movem.l d3,-(sp)
cargo_sum:
 moveq #0,d3
 move.b 0(a0,d1.w),d3
 add.w d3,d0
 add.w d2,d0
 move.w d0,d2
 lsr.w #8,d2
 and.w #255,d0
 dbra d1,cargo_sum
 movem.l (sp)+,d3
 cmp.b 23(sp),d0
 scs d0
 and.l #1,d0
 move.l (sp)+,d2
 rts
cargo_kg:
 move.b 0(a0,d0.w),d1
 move.l 16(sp),d0
 add.b d1,d0
 cmp.b #200,d0
 scs d0
 and.l #1,d0
 move.l (sp)+,d2
 rts
; scoop(inwk,type,scoops,cargo,rng,capacityEncoded): 0 none,1 collected,
; 2 full,3 collision. Station/docking excluded. Original flags set on removal.
.globl _scoop_step
.extern _elite_random
_scoop_step:
 movem.l d2-d7/a2-a4,-(sp)
 move.l 40(sp),a2
 move.l 44(sp),d6
 move.b 31(a2),d0
 and.b #160,d0
 or.b 1(a2),d0
 or.b 4(a2),d0
 or.b 7(a2),d0
 bne scoop_none
 move.b (a2),d0
 or.b 3(a2),d0
 or.b 6(a2),d0
 and.b #192,d0
 bne scoop_none
 tst.b d6
 bmi scoop_none
 cmp.b #7,d6
 beq scoop_none
 cmp.b #8,d6
 beq scoop_none
 cmp.b #10,d6
 blo scoop_collision
 move.l 48(sp),d0
 and.b 5(a2),d0
 bpl scoop_collision
 moveq #3,d7
 cmp.b #11,d6
 beq scoop_room
 clr.l -(sp)
 move.l 60(sp),-(sp)
 jsr _elite_random
 addq.l #8,sp
 move.w d0,d7
 and.w #7,d7
scoop_room:
 move.l 52(sp),a3
 move.l 60(sp),-(sp)
 move.l #1,-(sp)
 move.l d7,-(sp)
 move.l a3,-(sp)
 jsr _cargo_room
 lea 16(sp),sp
 or.b #128,31(a2)
 tst.l d0
 beq scoop_full
 addq.b #1,0(a3,d7.w)
 moveq #1,d0
 bra scoop_done
scoop_full:
 moveq #2,d0
 bra scoop_done
scoop_collision:
 or.b #128,31(a2)
 moveq #3,d0
 bra scoop_done
scoop_none:
 moveq #0,d0
scoop_done:
 movem.l (sp)+,d2-d7/a2-a4
 rts
; Original MA47 random canister count, type<7 only; CMP SST gives C=0.
.globl _debris_count
_debris_count:
 move.l 4(sp),d0
 cmp.b #7,d0
 bhs debris_none
 clr.l -(sp)
 move.l 16(sp),-(sp)
 jsr _elite_random
 addq.l #8,sp
 tst.b d0
 bpl debris_none
 and.l 8(sp),d0
 and.l #255,d0
 rts
debris_none:
 moveq #0,d0
 rts
; SFS1 cargo tumble: random pitch, speed from X, endless roll sign from ASL.
.globl _cargo_tumble
_cargo_tumble:
 move.l a2,-(sp)
 move.l 8(sp),a2
 move.l #1,-(sp)
 move.l 16(sp),-(sp)
 jsr _elite_random
 addq.l #8,sp
 clr.b 32(a2)
 move.b d0,d1
 add.b d1,d1
 move.b d1,30(a2)
 move.b #127,29(a2)
 tst.b d0
 bpl tumble_speed
 move.b #255,29(a2)
tumble_speed:
 swap d0
 and.b #15,d0
 move.b d0,27(a2)
 move.l (sp)+,a2
 rts
