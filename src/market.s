; Original QQ23/var/GVL/TT151, TT219 purchase and TT210 whole-stock sale.
; Market =17 price/4 bytes +17 AVL bytes. Native UI purchases one unit per key.
.sect .text
.globl _market_init
_market_init:
 movem.l d2-d7/a2-a3,-(sp)
 move.l 36(sp),a2
 move.l 40(sp),d6
 move.l 44(sp),d7
 lea market_table,a3
 moveq #0,d5
market_item:
 moveq #0,d0
 move.b 1(a3),d0
 and.w #31,d0
 mulu.w d6,d0
 ; Economies 0..7: var never overflows, hence returns carry clear.
 move.w d0,d4
 moveq #0,d1
 move.b 3(a3),d1
 and.b d7,d1
 move.b (a3),d0
 add.b d1,d0
 tst.b 1(a3)
 bmi market_negative_price
 add.b d4,d0
 bra market_price
market_negative_price:
 sub.b d4,d0
market_price:
 move.b d0,0(a2,d5.w)
 move.b 2(a3),d0
 add.b d1,d0
 tst.b 1(a3)
 bmi market_negative_qty
 sub.b d4,d0
 bra market_qty
market_negative_qty:
 add.b d4,d0
market_qty:
 tst.b d0
 bpl market_qty_nonnegative
 moveq #0,d0
market_qty_nonnegative:
 and.b #63,d0
 move.b d0,17(a2,d5.w)
 addq.l #4,a3
 addq.w #1,d5
 cmp.w #17,d5
 blo market_item
 clr.b 33(a2)
 movem.l (sp)+,d2-d7/a2-a3
 rts
; trade(commander,cargo,market,item,sell):0 success,1 stock,2 capacity,3 cash.
.globl _market_trade
.extern _cargo_room
_market_trade:
 movem.l d2-d7/a2-a4,-(sp)
 move.l 40(sp),a2
 move.l 44(sp),a3
 move.l 48(sp),a4
 move.l 52(sp),d7
 cmp.w #17,d7
 bhs trade_stock
 moveq #0,d6
 move.b 0(a4,d7.w),d6
 move.l 56(sp),d0
 tst.b d0
 bne trade_sell
 tst.b 17(a4,d7.w)
 beq trade_stock
 move.l #22,-(sp)
 move.l #1,-(sp)
 move.l d7,-(sp)
 move.l a3,-(sp)
 jsr _cargo_room
 lea 16(sp),sp
 tst.l d0
 beq trade_capacity
 lsl.w #2,d6
 cmp.l (a2),d6
 bhi trade_cash
 sub.l d6,(a2)
 addq.b #1,0(a3,d7.w)
 subq.b #1,17(a4,d7.w)
 bra trade_success
trade_sell:
 moveq #0,d0
 move.b 0(a3,d7.w),d0
 beq trade_stock
 mulu.w d0,d6
 lsl.w #2,d6
 and.l #65535,d6
 add.l d6,(a2)
 clr.b 0(a3,d7.w)
 ; Electron TT210 does not add sold goods back to AVL.
trade_success:
 moveq #0,d0
 bra trade_done
trade_stock:
 moveq #1,d0
 bra trade_done
trade_capacity:
 moveq #2,d0
 bra trade_done
trade_cash:
 moveq #3,d0
trade_done:
 movem.l (sp)+,d2-d7/a2-a4
 rts
.globl _launch_legal
_launch_legal:
 move.l 4(sp),a0
 move.l 8(sp),a1
 move.b 3(a1),d0
 add.b 6(a1),d0
 moveq #0,d1
 move.b d0,d1
 add.b d0,d0
 lsr.w #7,d1
 add.b 10(a1),d0
 add.b d1,d0
 or.b d0,6(a0)
 rts
.sect .rom
market_table:
.data1 19,130,6,1
.data1 20,129,10,3
.data1 65,131,2,7
.data1 40,133,226,31
.data1 83,133,251,15
.data1 196,8,54,3
.data1 235,29,8,120
.data1 154,14,56,3
.data1 117,6,40,7
.data1 78,1,17,31
.data1 124,13,29,7
.data1 176,137,220,63
.data1 32,129,53,3
.data1 97,161,66,7
.data1 171,162,55,31
.data1 45,193,250,15
.data1 53,15,192,7
