; Electron TT100/me3/MTT1/mt1/MTT4 and Ze, scheduled by shell at MCNT=0.
; step(out[202],rng[4],params[8],cargo[17]). Params:
; safe,asteroidCount,copCount,government,FIST,EV,entryCarry,freeSlots.
; Output BE count word, then up to5 records {type word,INWK36,pad2}.
; NWSHP boundary models successful insertion iff capacity remains; it sets C.
.sect .text
.globl _encounter_step
_encounter_step:
 movem.l d2-d7/a2-a6,-(sp)
 move.l 48(sp),a2
 move.l 52(sp),a3
 move.l 56(sp),a4
 move.l 60(sp),a5
 sub.l #36,sp
 move.l sp,a6
 clr.w (a2)
 moveq #0,d3
 move.b 6(a4),d3
 and.w #1,d3
 bsr en_random
 cmp.b #35,d0
 bhs en_police
 cmp.b #3,1(a4)
 bhs en_police
 bsr en_zero
 move.b #38,7(a6)
 moveq #0,d3
 bsr en_random
 move.b d0,(a6)
 move.b d1,3(a6)
 and.b #128,d0
 move.b d0,2(a6)
 and.b #128,d1
 move.b d1,5(a6)
 add.w d3,d3
 move.b d3,1(a6)
 moveq #0,d3
 bsr en_random
 tst.w d4
 bne en_trader
 move.b d0,d2
 or.b #111,d2
 move.b d2,29(a6)
 tst.b (a4)
 bne en_police
 tst.w d3
 bne en_pitch
 move.b d1,d0
 and.b #31,d0
 or.b #16,d0
 move.b d0,27(a6)
 bra en_rock
 en_pitch:
 or.b #127,d1
 move.b d1,30(a6)
en_rock:
 bsr en_random
 cmp.b #5,d0
 blo en_canister
 moveq #9,d0
 bra en_benign_add
en_canister:
 moveq #10,d0
en_benign_add:
 bsr en_add
 bra en_police
en_trader:
 move.b d0,d2
 and.b #1,d2
 move.b d2,31(a6)
 lsr.b #1,d0
 move.b d0,32(a6)
 move.b d0,29(a6)
 and.b #31,d0
 or.b #16,d0
 move.b d0,27(a6)
 moveq #6,d0
 bsr en_add
 bra en_done
en_police:
 tst.b (a4)
 bne en_done
 ; BAD's ASL carry into ADC firearms, then caller ASL, byte wrap.
 moveq #0,d0
 move.b 3(a5),d0
 add.b 6(a5),d0
 move.w d0,d1
 lsr.w #7,d1
 and.w #1,d1
 add.b d0,d0
 add.b 10(a5),d0
 add.b d1,d0
 moveq #0,d3
 btst #7,d0
 beq en_bad_shift
 moveq #1,d3
en_bad_shift:
 add.b d0,d0
 tst.b 2(a4)
 beq en_bad_ready
 or.b 4(a4),d0
en_bad_ready:
 move.b d0,d6
 bsr en_ze
 moveq #1,d3
 cmp.b d6,d0
 bhs en_no_cop
 moveq #2,d0
 bsr en_add
 tst.w d3
 beq en_no_cop
 addq.b #1,2(a4)
en_no_cop:
 tst.b 2(a4)
 bne en_done
 subq.b #1,5(a4)
 bpl en_done
 addq.b #1,5(a4)
 ; CMP T leaves C=1 when no cop is attempted, or NWSHP result otherwise.
 bsr en_random
 tst.b 3(a4)
 beq en_hostile
 cmp.b #90,d0
 bhs en_done
 and.b #7,d0
 cmp.b 3(a4),d0
 blo en_done
 moveq #1,d3
en_hostile:
 bsr en_ze
 cmp.b #200,d0
 bhs en_pirates
 addq.b #1,5(a4)
 and.b #3,d0
 addq.b #3,d0
 move.w d0,d5
 moveq #0,d2
 cmp.b #200,d1
 blo en_hunter_ecm
 moveq #1,d2
en_hunter_ecm:
 add.b d1,d1
 or.b d2,d1
 or.b #192,d1
 move.b d1,32(a6)
 move.w d5,d0
 bsr en_add
 bra en_done
en_pirates:
 and.w #3,d0
 move.b d0,5(a4)
 move.w d0,d7
 moveq #1,d3
en_pirate_loop:
 bsr en_random
 and.b #3,d0
 or.b #1,d0
 bsr en_add
 dbra d7,en_pirate_loop
en_done:
 add.l #36,sp
 movem.l (sp)+,d2-d7/a2-a6
 rts
en_zero:
 moveq #35,d2
en_clear:
 clr.b 0(a6,d2.w)
 dbra d2,en_clear
 move.b #96,18(a6)
 move.b #96,22(a6)
 move.b #224,14(a6)
 rts
en_ze:
 bsr en_zero
 bsr en_random
 and.b #128,d0
 move.b d0,2(a6)
 move.b d1,d0
 and.b #128,d0
 move.b d0,5(a6)
 move.b #32,1(a6)
 move.b #32,4(a6)
 move.b #32,7(a6)
 moveq #0,d2
 cmp.b #245,d1
 blo en_ze_ecm
 moveq #1,d2
en_ze_ecm:
 add.b d1,d1
 or.b d2,d1
 or.b #192,d1
 move.b d1,32(a6)
 moveq #0,d3
 bra en_random
; Return D0=A,D1=X,D3=C,D4=V. Explicit byte overflow from final ADC.
en_random:
 moveq #0,d0
 move.b (a3),d0
 move.w d0,d2
 lsr.w #7,d2
 add.w d0,d0
 or.w d3,d0
 and.w #255,d0
 moveq #0,d4
 move.b 2(a3),d4
 move.b d0,2(a3)
 add.w d4,d0
 add.w d2,d0
 move.b d0,(a3)
 lsr.w #8,d0
 moveq #0,d1
 move.b 1(a3),d1
 moveq #0,d4
 move.b 3(a3),d4
 add.w d1,d0
 add.w d4,d0
 move.b d0,1(a3)
 move.b d1,3(a3)
 move.w d0,d3
 lsr.w #8,d3
 move.w d1,d2
 eor.w d4,d2
 not.w d2
 move.w d1,d4
 eor.w d0,d4
 and.w d2,d4
 and.w #128,d4
 and.w #255,d0
 rts
en_add:
 moveq #0,d3
 moveq #0,d2
 move.b 7(a4),d2
 cmp.w (a2),d2
 bls en_add_done
 cmp.w #5,(a2)
 bhs en_add_done
 move.w (a2),d2
 mulu.w #40,d2
 lea 2(a2,d2.w),a0
 move.w d0,(a0)+
 move.l a6,a1
 moveq #35,d2
en_add_copy:
 move.b (a1)+,(a0)+
 dbra d2,en_add_copy
 clr.w (a0)
 addq.w #1,(a2)
 moveq #1,d3
en_add_done:
 rts
