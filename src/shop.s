; EQSHP/PRXS/et0-etB: original transactions and four-view laser selection.
; buy(cmd,cargoEquipment22,missileState,travel64,item) returns
; 0 bought,1 cash,2 present/full,3 technology,4 unsupported item.
.sect .text
.globl _shop_buy
.globl _shop_buy_view
.globl _laser_fitting
.extern _ship_fit
_shop_buy:
 moveq #0,d0
 bra shop_entry
_shop_buy_view:
 move.l 24(sp),d0
shop_entry:
 movem.l d2-d7/a2-a5,-(sp)
 move.l 44(sp),a2
 move.l 48(sp),a3
 move.l 52(sp),a4
 move.l 56(sp),a5
 move.l d0,d5
 move.l 60(sp),d7
 moveq #4,d0
 cmp.w #12,d7
 bhs shop_done
 cmp.w #4,d5
 bhs shop_done
 moveq #0,d1
 move.b 24(a5),d1
 addq.w #2,d1
 moveq #3,d0
 cmp.w d1,d7
 bhi shop_done
 lea shop_prices,a0
 move.w d7,d1
 add.w d1,d1
 moveq #0,d6
 move.w 0(a0,d1.w),d6
 tst.w d7
 bne shop_price_ready
 moveq #70,d6
 sub.b 9(a5),d6
 add.w d6,d6
shop_price_ready:
 moveq #1,d0
 cmp.l (a2),d6
 bhi shop_done
 ; Original eq charges first; pres refunds an unfittable item. Validate
 ; before writing to produce the same final cash without a transient debit.
 moveq #2,d0
 cmp.w #1,d7
 bne shop_bay
 cmp.b #4,(a4)
 bhs shop_done
 addq.b #1,(a4)
 clr.b 1(a4)
 move.b #255,2(a4)
 bra shop_pay
shop_bay:
 cmp.w #2,d7
 bne shop_laser
 cmp.b #37,_ship_fit
 beq shop_done
 move.b #37,_ship_fit
 bra shop_pay
shop_laser:
 lea _ship_fit+1,a1
 tst.w d5
 beq shop_laser_pointer
 lea _ship_fit+3,a1
 adda.w d5,a1
shop_laser_pointer:
 cmp.w #4,d7
 beq shop_pulse
 cmp.w #5,d7
 bne shop_flags
 tst.b (a1)
 bmi shop_done
 beq shop_beam_fit
 ; Gross beam price must be affordable before the pulse refund.
 add.l #4000,(a2)
shop_beam_fit:
 move.b #143,(a1)
 bra shop_pay
shop_pulse:
 tst.b (a1)
 bne shop_done
 move.b #15,(a1)
 bra shop_pay
shop_flags:
 tst.w d7
 bne shop_not_fuel
 move.b #70,9(a5)
 bra shop_pay
shop_not_fuel:
 cmp.w #7,d7
 bne shop_not_escape
 lea _ship_fit+2,a0
 moveq #-1,d1
 bra shop_flag
shop_not_escape:
 cmp.w #11,d7
 bne shop_qq20
 lea 10(a5),a0
 moveq #-1,d1
 bra shop_flag
shop_qq20:
 lea 17(a3),a0
 moveq #-1,d1
 cmp.w #3,d7
 beq shop_flag
 addq.l #1,a0
 cmp.w #6,d7
 beq shop_flag
 addq.l #1,a0
 moveq #127,d1
 cmp.w #8,d7
 beq shop_flag
 addq.l #1,a0
 moveq #1,d1
 cmp.w #9,d7
 beq shop_flag
 addq.l #1,a0
 moveq #-1,d1
shop_flag:
 tst.b (a0)
 bne shop_done
 move.b d1,(a0)
shop_pay:
 sub.l d6,(a2)
 moveq #0,d0
shop_done:
 movem.l (sp)+,d2-d7/a2-a5
 rts
.sect .data
.align 2
shop_prices: .data2 0,300,4000,6000,4000,10000,5250,10000,9000,15000,10000,50000

.sect .text
; ESCAPE/ESL2 state effects after RESET: lose cargo/legal/pod, fill fuel.
.globl _escape_commander
_escape_commander:
 moveq #0,d0
 tst.b _ship_fit+2
 beq escape_done
 move.l 4(sp),a0
 clr.b 6(a0)
 move.l 8(sp),a0
 moveq #16,d1
escape_empty:
 clr.b (a0)+
 dbra d1,escape_empty
 move.l 12(sp),a0
 move.b #70,9(a0)
 clr.b 11(a0)
 clr.b 13(a0)
 clr.b _ship_fit+2
 moveq #1,d0
escape_done:
 rts

.sect .text
; laser_fitting(fit8,view): byte LASER[view], or zero for invalid view.
_laser_fitting:
 move.l 4(sp),a0
 move.l 8(sp),d1
 moveq #0,d0
 cmp.l #4,d1
 bhs fitting_done
 tst.w d1
 bne fitting_side
 move.b 1(a0),d0
 rts
fitting_side:
 move.b 3(a0,d1.w),d0
fitting_done:
 rts
