; Native Electron TAS2/TAS3 and normal-ship TACTICS parts 2-7.
; Explicit event boundaries: 1 missile request, 2 escape-pod request,
; 3 laser/shields, 4 laser/OUCH, 5 laser/DEATH. Sound/cargo/spawning are external.
.sect .text
.globl _tactics_vector
.globl _tactics_dot
.globl _tactics_step
.globl _tactics_due
.extern normalize_vector
.extern tidy_mult
.extern sign_add
.extern _elite_random
.extern _player_damage
; TAS2(inwk,out[3]); INWK coordinates untouched, including sign low bits.
_tactics_vector:
 movem.l d2-d7/a2-a3,-(sp)
 move.l 36(sp),a3
 move.l 40(sp),a2
 subq.l #6,sp
 moveq #0,d0
 moveq #0,d1
 moveq #0,d2
 move.b 1(a3),d0
 lsl.w #8,d0
 move.b (a3),d0
 move.b 4(a3),d1
 lsl.w #8,d1
 move.b 3(a3),d1
 move.b 7(a3),d2
 lsl.w #8,d2
 move.b 6(a3),d2
 move.w d0,d3
 or.w d1,d3
 or.w d2,d3
 or.w #1,d3
vector_shift:
 tst.w d3
 bmi vector_scaled
 add.w d3,d3
 add.w d0,d0
 add.w d1,d1
 add.w d2,d2
 bra vector_shift
vector_scaled:
 lsr.w #8,d0
 lsr.w #1,d0
 or.b 2(a3),d0
 move.b d0,(sp)
 lsr.w #8,d1
 lsr.w #1,d1
 or.b 5(a3),d1
 move.b d1,2(sp)
 lsr.w #8,d2
 lsr.w #1,d2
 or.b 8(a3),d2
 move.b d2,4(sp)
 move.l sp,a0
 jsr normalize_vector
 move.b (sp),(a2)
 move.b 2(sp),1(a2)
 move.b 4(sp),2(a2)
 addq.l #6,sp
 movem.l (sp)+,d2-d7/a2-a3
 rts
; TAS3(inwk,vec[3],highByteOffset), return original sign-magnitude word.
_tactics_dot:
 movem.l d2-d6/a2-a3,-(sp)
 move.l 32(sp),a2
 move.l 36(sp),a3
 move.l 40(sp),d0
 adda.w d0,a2
 moveq #0,d5
 moveq #2,d6
vector_dot_loop:
 moveq #0,d0
 moveq #0,d1
 move.b (a3)+,d0
 move.b (a2),d1
 jsr tidy_mult
 cmp.w #2,d6
 beq vector_dot_first
 move.w d5,d1
 jsr sign_add
vector_dot_first:
 move.w d0,d5
 addq.l #2,a2
 dbra d6,vector_dot_loop
 and.l #65535,d0
 movem.l (sp)+,d2-d6/a2-a3
 rts
; Original MVEIT part2 dispatch, separate from TIDY's every-16 schedule.
_tactics_due:
 move.l 4(sp),a0
 moveq #0,d0
 move.b 31(a0),d1
 and.b #160,d1
 bne due_done
 tst.b 32(a0)
 bpl due_done
 move.l 8(sp),d1
 cmp.b #8,d1
 beq due_yes
 move.l 12(sp),d1
 move.l 16(sp),d0
 eor.w d1,d0
 and.w #7,d0
 bne due_no
 due_yes:
 moveq #1,d0
 rts
 due_no:
 moveq #0,d0
 due_done:
 rts
; step(inwk,params[5]={type,maxEnergy,weaponByte,safeZone,ecm},rng,status).
; Missile, station and escape-pod tactics need their universe context and are
; deliberately excluded from this normal-ship entry (types1..6).
_tactics_step:
 movem.l d2-d7/a2-a6,-(sp)
 subq.l #8,sp
 move.l sp,a6
 move.l 56(sp),a2
 move.l 60(sp),a3
 move.l 64(sp),a4
 move.l 68(sp),a5
 moveq #0,d0
 cmp.b #1,(a3)
 blo tactics_done
 cmp.b #6,(a3)
 bhi tactics_done
 cmp.b #6,(a3)
 beq tactics_recharge
 cmp.b #2,(a3)
 beq tactics_recharge
 tst.b 3(a3)
 beq tactics_recharge
 and.b #129,32(a2)
tactics_recharge:
 move.b 1(a3),d0
 cmp.b 35(a2),d0
 bls tactics_vectors
 addq.b #1,35(a2)
tactics_vectors:
 move.l a6,-(sp)
 move.l a2,-(sp)
 jsr _tactics_vector
 addq.l #8,sp
 moveq #10,d0
 bsr tactics_dot
 move.b d0,3(a6)
 ; TYPE CMP MSL immediately before DORND supplies clear carry for types1..6.
 moveq #0,d0
 bsr tactics_random
 cmp.b #250,d0
 blo tactics_energy
 moveq #1,d0
 bsr tactics_random
 or.b #104,d0
 move.b d0,29(a2)
tactics_energy:
 moveq #0,d0
 move.b 1(a3),d0
 lsr.b #1,d0
 cmp.b 35(a2),d0
 blo tactics_lasers
 lsr.b #2,d0
 cmp.b 35(a2),d0
 blo tactics_missile
 moveq #1,d0
 bsr tactics_random
 cmp.b #230,d0
 blo tactics_missile
 clr.b 32(a2)
 moveq #2,d0
 bra tactics_done
tactics_missile:
 moveq #0,d7
 move.b 31(a2),d7
 and.w #7,d7
 beq tactics_lasers
 ; Entered after a failed CMP eighth-energy or CMP #230: C=0.
 moveq #0,d0
 bsr tactics_random
 and.b #31,d0
 cmp.b d7,d0
 bhs tactics_lasers
 tst.b 4(a3)
 bne tactics_lasers
 subq.b #1,31(a2)
 moveq #1,d0
 bra tactics_done
tactics_lasers:
 move.b 1(a2),d0
 or.b 4(a2),d0
 or.b 7(a2),d0
 and.b #224,d0
 bne tactics_manoeuvre
 cmp.b #160,3(a6)
 blo tactics_manoeuvre
 or.b #64,31(a2)
 cmp.b #163,3(a6)
 blo tactics_manoeuvre
 ; HIT's LSR weaponByte leaves the low missile bit in carry for OOPS.
 moveq #0,d0
 move.b 2(a3),d0
 move.w d0,d1
 and.w #1,d1
 move.l d1,-(sp)
 moveq #0,d1
 move.b 8(a2),d1
 move.l d1,-(sp)
 lsr.w #1,d0
 move.l d0,-(sp)
 move.l a5,-(sp)
 jsr _player_damage
 lea 16(sp),sp
 cmp.w #2,d0
 beq tactics_death
 subq.b #1,28(a2)
 addq.l #3,d0
 bra tactics_done
tactics_death:
 moveq #5,d0
 bra tactics_done
tactics_manoeuvre:
 moveq #1,d0
 cmp.b #3,7(a2)
 bhs tactics_choose
 move.b 1(a2),d0
 or.b 4(a2),d0
 and.b #254,d0
 beq tactics_steer
 moveq #0,d0
tactics_choose:
 bsr tactics_random
 or.b #128,d0
 cmp.b 32(a2),d0
 bhs tactics_steer
 eor.b #128,(a6)
 eor.b #128,1(a6)
 eor.b #128,2(a6)
 eor.b #128,3(a6)
tactics_steer:
 moveq #16,d0
 bsr tactics_dot
 eor.b #128,d0
 and.b #128,d0
 or.b #3,d0
 move.b d0,30(a2)
 move.b 29(a2),d0
 and.b #127,d0
 cmp.b #16,d0
 bhs tactics_accel
 moveq #22,d0
 bsr tactics_dot
 move.b 30(a2),d1
 eor.b d1,d0
 and.b #128,d0
 eor.b #133,d0
 move.b d0,29(a2)
tactics_accel:
 move.b 3(a6),d0
 bmi tactics_brake
 cmp.b #22,d0
 blo tactics_brake
 move.b #3,28(a2)
 bra tactics_quiet
tactics_brake:
 and.b #127,d0
 cmp.b #18,d0
 blo tactics_quiet
 move.b #255,28(a2)
tactics_quiet:
 moveq #0,d0
tactics_done:
 addq.l #8,sp
 movem.l (sp)+,d2-d7/a2-a6
 rts
tactics_random:
 move.l d0,-(sp)
 move.l a4,-(sp)
 jsr _elite_random
 addq.l #8,sp
 rts
tactics_dot:
 move.l d0,-(sp)
 move.l a6,-(sp)
 move.l a2,-(sp)
 jsr _tactics_dot
 lea 12(sp),sp
 lsr.w #8,d0
 rts
