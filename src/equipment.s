; Original OUCH item selection; MESS and missing sound are caller boundaries.
; damage(cargoAndEquipment[22],rng[4],DLY,carry) -> lost index+1, or 0.
.sect .text
.globl _equipment_damage
.extern _elite_random
_equipment_damage:
 movem.l d2/a2,-(sp)
 move.l 12(sp),a2
 move.l 20(sp),d2
 move.l 24(sp),-(sp)
 move.l 20(sp),-(sp)
 jsr _elite_random
 addq.l #8,sp
 tst.b d0
 bmi equipment_no_loss
 swap d0
 and.l #255,d0
 cmp.w #22,d0
 bhs equipment_no_loss
 tst.b 0(a2,d0.w)
 beq equipment_no_loss
 tst.b d2
 bne equipment_no_loss
 clr.b 0(a2,d0.w)
 addq.l #1,d0
 bra equipment_damage_done
equipment_no_loss:
 moveq #0,d0
equipment_damage_done:
 movem.l (sp)+,d2/a2
 rts
.globl _bomb_key
_bomb_key:
 move.l 4(sp),a0
 move.l 8(sp),d0
 tst.b d0
 beq bomb_key_done
 move.b (a0),d0
 add.b d0,d0
 move.b d0,(a0)
bomb_key_done:
 rts
; Original MA loop branch, called only for actual populated ship records.
.globl _bomb_ship
_bomb_ship:
 move.l 4(sp),a0
 move.l 12(sp),d0
 tst.b d0
 bpl bomb_spared
 move.l 8(sp),d0
 cmp.b #7,d0
 beq bomb_spared
 btst #5,31(a0)
 bne bomb_spared
 or.b #128,31(a0)
 moveq #1,d0
 rts
bomb_spared:
 moveq #0,d0
 rts
.globl _bomb_tick
_bomb_tick:
 move.l 4(sp),a0
 tst.b (a0)
 bpl bomb_tick_done
 move.b (a0),d0
 add.b d0,d0
 move.b d0,(a0)
bomb_tick_done:
 rts
