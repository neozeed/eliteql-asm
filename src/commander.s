; Original EXNO2, MA15/q2/MCASH and STATUS rank decisions.
; State: CASH big-endian32, TALLY little-endian16, FIST, DLY, message ID, pad.
.sect .text
.globl _commander_tally
_commander_tally:
 move.l 4(sp),a0
 addq.b #1,4(a0)
 bne commander_tally_done
 addq.b #1,5(a0)
 move.b #22,7(a0)
 move.b #2,8(a0)
commander_tally_done:
 rts
; settle(state,type,bounty). Called once at completed explosion removal, NOT
; for scoops. DLY really gates MCASH in the original (not just its message).
.globl _commander_settle
_commander_settle:
 move.l 4(sp),a0
 move.l 8(sp),d0
 cmp.b #2,d0
 bne commander_bounty
 or.b #64,6(a0)
commander_bounty:
 tst.b 7(a0)
 bne commander_no_cash
 move.l 12(sp),d0
 tst.b d0
 beq commander_no_cash
 and.l #65535,d0
 add.l d0,(a0)
 move.b #22,7(a0)
 move.b #1,8(a0)
 moveq #1,d0
 rts
commander_no_cash:
 moveq #0,d0
 rts
.globl _commander_rank
_commander_rank:
 move.l 4(sp),a0
 moveq #0,d0
 move.b 5(a0),d0
 beq commander_low_rank
 moveq #9,d1
 cmp.b #25,d0
 bhs commander_rank_done
 subq.w #1,d1
 cmp.b #10,d0
 bhs commander_rank_done
 subq.w #1,d1
 cmp.b #2,d0
 bhs commander_rank_done
 subq.w #1,d1
 bra commander_rank_done
commander_low_rank:
 move.b 4(a0),d0
 lsr.b #2,d0
 moveq #0,d1
commander_rank_loop:
 addq.w #1,d1
 lsr.b #1,d0
 bne commander_rank_loop
commander_rank_done:
 move.l d1,d0
 rts
.globl _commander_tick
_commander_tick:
 move.l 4(sp),a0
 subq.b #1,7(a0)
 beq commander_tick_done
 bpl commander_tick_done
 addq.b #1,7(a0)
commander_tick_done:
 rts
