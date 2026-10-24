; Electron NWSHP/NWSPS/KILLSHP bookkeeping. Native 68000, no interpreter.
; State30: FRIN[13], pad, count.word, heapUsed.word, heapSize[12].
; K%=$900, WP=$d40, SLSP starts WP-1: data+line heaps have1087 bytes.
; Slot0 planet, slot1 station/placeholder. Station has its separate LSO heap.
.sect .text
.globl _universe_reset
.globl _universe_add
.globl _universe_remove
.globl _universe_cost
.globl _universe_missile_target
_universe_reset:
 move.l 4(sp),a0
 moveq #29,d0
ul_zero:
 clr.b 0(a0,d0.w)
 dbra d0,ul_zero
 move.b #128,(a0)
 move.b #129,1(a0)
 move.w #2,14(a0)
 rts
; cost(type): original blueprint byte5, derived from original max-line field.
_universe_cost:
 move.l 4(sp),d0
 and.w #255,d0
 cmp.w #11,d0
 bhi ul_cost_zero
 lea ul_costs(pc),a0
 move.b 0(a0,d0.w),d0
 and.w #255,d0
 rts
ul_cost_zero:
 moveq #0,d0
 rts
; add(state,type,cost): original logical slot, or -1; failure leaves state intact.
_universe_add:
 movem.l d2-d4,-(sp)
 move.l 16(sp),a0
 move.l 20(sp),d2
 move.l 24(sp),d3
 cmp.w #7,d2
 beq ul_station
 moveq #0,d0
ul_find:
 tst.b 0(a0,d0.w)
 beq ul_free
 addq.w #1,d0
 cmp.w #12,d0
 blo ul_find
 bra ul_full
ul_free:
 move.w d0,d1
 addq.w #1,d1
 mulu.w #36,d1
 move.w 16(a0),d4
 add.w d3,d4
 add.w d4,d1
 cmp.w #1087,d1
 bhi ul_full
 move.b d2,0(a0,d0.w)
 move.b d3,18(a0,d0.w)
 move.w d4,16(a0)
 move.w d0,d1
 addq.w #1,d1
 move.w d1,14(a0)
 bra ul_add_done
ul_station:
 move.b #7,1(a0)
 moveq #1,d0
 bra ul_add_done
ul_full:
 moveq #-1,d0
ul_add_done:
 movem.l (sp)+,d2-d4
 rts
; remove(state,logical slot): compact FRIN/heaps; station becomes placeholder.
_universe_remove:
 move.l 4(sp),a0
 move.l 8(sp),d0
 cmp.w #1,d0
 beq ul_remove_station
 cmp.w #2,d0
 blo ul_remove_done
 cmp.w 14(a0),d0
 bhs ul_remove_done
 moveq #0,d1
 move.b 18(a0,d0.w),d1
 sub.w d1,16(a0)
 subq.w #1,14(a0)
ul_shift:
 cmp.w 14(a0),d0
 bhs ul_shift_end
 move.b 1(a0,d0.w),0(a0,d0.w)
 move.b 19(a0,d0.w),18(a0,d0.w)
 addq.w #1,d0
 bra ul_shift
ul_shift_end:
 clr.b 0(a0,d0.w)
 clr.b 18(a0,d0.w)
 rts
ul_remove_station:
 move.b #129,1(a0)
ul_remove_done:
 rts
; KS2/KSL4/KS6: ai byte, removed ORIGINAL logical slot. This applies to all
; AI-enabled missiles, including the original hostile byte's decrement.
_universe_missile_target:
 move.l 4(sp),d0
 and.w #255,d0
 btst #7,d0
 beq ul_target_done
 move.w d0,d1
 and.w #127,d1
 lsr.w #1,d1
 cmp.w 10(sp),d1
 blo ul_target_done
 beq ul_target_dumb
 subq.w #1,d1
 add.w d1,d1
 or.w #128,d1
 move.w d1,d0
 rts
ul_target_dumb:
 moveq #0,d0
ul_target_done:
 rts
ul_costs: .data1 0,61,77,93,85,153,153,0,81,65,49,25
.align 2
