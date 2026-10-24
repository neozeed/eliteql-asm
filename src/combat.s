; Electron combat arithmetic, translated to native 68000. All public functions
; use the QDOS C ABI; no C implementation or emulated CPU is linked in ELITEASM.
; INWK is the full original 36 bytes. Byte buffers need not be aligned.
.sect .text
.globl _elite_random
.globl _laser_fire
.globl _laser_tick
.globl _laser_hit
.globl _ship_angry
.globl _ship_damage
.globl _player_damage
.globl _laser_xor
.globl _sight_xor
.extern xor_segment

; DORND(seed[4], carry): return A | C<<8 | X<<16.
_elite_random:
 move.l 4(sp),a0
 move.l 8(sp),d1
 and.w #1,d1
 movem.l d2-d3,-(sp)
 bsr random_core
 movem.l (sp)+,d2-d3
 rts
random_core:
 moveq #0,d0
 move.b (a0),d0
 move.w d0,d2
 lsr.w #7,d2
 add.w d0,d0
 or.w d1,d0
 and.w #255,d0
 move.w d0,d3
 moveq #0,d1
 move.b 2(a0),d1
 add.w d1,d0
 add.w d2,d0
 move.b d0,(a0)
 move.b d3,2(a0)
 lsr.w #8,d0
 moveq #0,d2
 move.b 1(a0),d2
 add.w d2,d0
 moveq #0,d1
 move.b 3(a0),d1
 add.w d1,d0
 move.b d0,1(a0)
 move.b d2,3(a0)
 swap d2
 or.l d2,d0
 rts

; MA68/ma1 + LASLI/DENGY. laser[12]: LASCT,LAS,LAS2,LASX,LASY,
; RAND[4],drawn,reserved[2]. fire(laser,status,held,power,entryCarry).
; Sound is an unported boundary; caller supplies LASLI's incoming carry.
_laser_fire:
 movem.l d2-d4/a2-a3,-(sp)
 move.l 24(sp),a2
 move.l 28(sp),a3
 clr.b 1(a2)
 moveq #0,d0
 tst.b (a2)
 bne fire_done
 tst.l 32(sp)
 beq fire_done
 cmp.b #242,3(a3)
 bhs fire_done
 move.l 36(sp),d4
 tst.b d4
 beq fire_done
 move.b d4,d0
 and.b #127,d0
 move.b d0,1(a2)
 move.b d0,2(a2)
 lea 5(a2),a0
 move.l 40(sp),d1
 and.w #1,d1
 bsr random_core
 move.w d0,d1
 lsr.w #8,d1
 and.w #7,d0
 add.w d1,d0
 add.w #92,d0
 move.b d0,4(a2)
 moveq #0,d1
 bsr random_core
 move.w d0,d1
 lsr.w #8,d1
 and.w #7,d0
 add.w d1,d0
 add.w #124,d0
 move.b d0,3(a2)
 addq.b #8,3(a3)
 subq.b #1,2(a3)
 bne fire_energy_done
 addq.b #1,2(a3)
fire_energy_done:
 tst.b d4
 bpl fire_pulse
 moveq #0,d4
fire_pulse:
 and.b #250,d4
 move.b d4,(a2)
 moveq #1,d0
fire_done:
 movem.l (sp)+,d2-d4/a2-a3
 rts

; MLOOP subtraction includes the original caller's carry: subtract 4 or 5.
_laser_tick:
 move.l 4(sp),a0
 moveq #0,d0
 move.b (a0),d0
 move.l 8(sp),d1
 and.w #1,d1
 add.w d1,d0
 subq.w #5,d0
 bpl tick_store
 moveq #0,d0
tick_store:
 move.b d0,(a0)
 rts

; HITCH(inwk,type,targetableArea). Original unsigned x_lo/y_lo squares,
; NOT projected screen distance. Any nonzero z_sign rejects, including +high.
_laser_hit:
 movem.l d2-d3,-(sp)
 move.l 12(sp),a0
 move.l 16(sp),d1
 moveq #0,d0
 tst.b 8(a0)
 bne hitch_done
 tst.b d1
 bmi hitch_done
 move.b 31(a0),d1
 and.b #32,d1
 or.b 1(a0),d1
 or.b 4(a0),d1
 bne hitch_done
 moveq #0,d1
 move.b (a0),d1
 mulu.w d1,d1
 moveq #0,d2
 move.b 3(a0),d2
 mulu.w d2,d2
 add.l d2,d1
 cmp.l #65535,d1
 bhi hitch_done
 move.l 20(sp),d2
 and.l #65535,d2
 cmp.l d1,d2
 blo hitch_done
 moveq #1,d0
hitch_done:
 movem.l (sp)+,d2-d3
 rts

; ANGRY(inwk,type,stationAIbyte). Nullable station pointer is the adapter
; for test scenes with no station; unlike Elite, slot 1 is not reserved here.
_ship_angry:
 move.l 4(sp),a0
 move.l 8(sp),d0
 move.l 12(sp),a1
 cmp.b #7,d0
 beq angry_station
 bhi angry_done
 cmp.b #6,d0
 bne angry_ship
 bsr angry_station
angry_ship:
 tst.b 32(a0)
 beq angry_done
 or.b #128,32(a0)
 move.b #2,28(a0)
 move.b #4,30(a0)
angry_done:
 rts
angry_station:
 move.l a1,d1
 beq angry_done
 or.b #128,(a1)
 rts

; MA47 arithmetic through the killed-bit boundary. damage(inwk,power,type).
; Return 1 survived (including EXACTLY zero energy), 2 killed, 3 station.
; On death stop BEFORE debris/EXNO2, leaving energy unchanged as at that
; source boundary. Host shell removes the test target; no invented explosion.
_ship_damage:
 move.l 4(sp),a0
 move.l 8(sp),d1
 moveq #0,d0
 move.b 35(a0),d0
 and.w #255,d1
 sub.w d1,d0
 bpl damage_survived
 move.l 12(sp),d1
 cmp.b #7,d1
 beq damage_station
 or.b #128,31(a0)
 moveq #2,d0
 rts
damage_station:
 moveq #3,d0
 rts
damage_survived:
 move.b d0,35(a0)
 moveq #1,d0
 rts

; OOPS(status,damage,z_sign,carry). Return 0 shield absorbed, 1 OUCH,
; 2 DEATH. Preserve the original wrapped energy byte, including underflow.
; Caller owns sound/cargo/death presentation; this routine is separately tested.
_player_damage:
 movem.l d2-d3,-(sp)
 move.l 12(sp),a0
 move.l 16(sp),d1
 and.w #255,d1
 move.l 24(sp),d2
 and.w #1,d2
 subq.w #1,d2
 sub.w d2,d1
 move.l 20(sp),d2
 move.l a0,a1
 tst.b d2
 bpl damage_front
 addq.l #1,a1
damage_front:
 moveq #0,d2
 move.b (a1),d2
 sub.w d1,d2
 bmi damage_banks
 move.b d2,(a1)
 moveq #0,d0
 bra player_done
damage_banks:
 clr.b (a1)
 and.w #255,d2
 moveq #0,d3
 move.b 2(a0),d3
 add.w d3,d2
 move.b d2,2(a0)
 moveq #2,d0
 tst.b d2
 beq player_done
 cmp.w #256,d2
 blo player_done
 moveq #1,d0
player_done:
 movem.l (sp)+,d2-d3
 rts

; LASLI2/las geometry via the QL native rasterizer. Involution for XOR erase.
_laser_xor:
 movem.l d2-d7/a2,-(sp)
 move.l 32(sp),a0
 move.l 36(sp),a2
 moveq #0,d0
 moveq #0,d1
 move.b 3(a2),d0
 move.b 4(a2),d1
 move.w #191,d3
 moveq #32,d2
 jsr xor_segment
 move.w #224,d2
 jsr xor_segment
 moveq #48,d2
 jsr xor_segment
 move.w #208,d2
 jsr xor_segment
 movem.l (sp)+,d2-d7/a2
 rts

; SIGHT's two TT15 crosses (sizes20 then10), using native inclusive lines.
_sight_xor:
 movem.l d2-d7,-(sp)
 move.l 28(sp),a0
 moveq #20,d7
sight_loop:
 move.w #128,d0
 sub.w d7,d0
 moveq #96,d1
 move.w #128,d2
 add.w d7,d2
 moveq #96,d3
 jsr xor_segment
 move.w #128,d0
 moveq #96,d1
 sub.w d7,d1
 move.w #128,d2
 moveq #96,d3
 add.w d7,d3
 jsr xor_segment
 sub.w #10,d7
 bne sight_loop
 movem.l (sp)+,d2-d7
 rts
