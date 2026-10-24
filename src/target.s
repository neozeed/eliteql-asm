; TAS1/MVT3: exact 23-bit sign-magnitude target-relative coordinates.
.sect .text
.globl _relative_vector
_relative_vector:
 movem.l d2-d7/a2,-(sp)
 move.l 32(sp),a0
 move.l 36(sp),a1
 move.l 40(sp),a2
 moveq #2,d7
relative_axis:
 moveq #0,d0
 moveq #0,d1
 move.b 2(a0),d0
 lsl.l #8,d0
 move.b 1(a0),d0
 lsl.l #8,d0
 move.b (a0),d0
 move.b 2(a1),d1
 lsl.l #8,d1
 move.b 1(a1),d1
 lsl.l #8,d1
 move.b (a1),d1
 move.l d0,d2
 and.l #0x800000,d2
 move.l d1,d3
 and.l #0x800000,d3
 eor.l #0x800000,d3
 and.l #0x7fffff,d0
 and.l #0x7fffff,d1
 cmp.l d2,d3
 bne relative_sub
 moveq #0,d4
 tst.l d2
 beq relative_add
 moveq #1,d4
relative_add:
 add.l d1,d0
 and.l #0x7fffff,d0
 bra relative_store
relative_sub:
 moveq #1,d4
 sub.l d1,d0
 bcc relative_store
 moveq #0,d4
 neg.l d0
 move.l d3,d2
relative_store:
 or.l d2,d0
 move.b d0,(a2)+
 lsr.l #8,d0
 move.b d0,(a2)+
 lsr.l #8,d0
 move.b d0,(a2)+
 addq.l #3,a0
 addq.l #3,a1
 dbra d7,relative_axis
 move.l d4,d0
 movem.l (sp)+,d2-d7/a2
 rts
; friendly(missile,target,targetType,rng): caller handles active ECM first.
; 0 steering, 6 destroy missile, 7 target ECM request, 8 target killed.
.globl _friendly_missile
.extern _missile_steer
.extern _elite_random
_friendly_missile:
 movem.l d2-d7/a2-a6,-(sp)
 lea -48(sp),sp
 move.l sp,a6
 move.l 96(sp),a2
 move.l 100(sp),a3
 move.l 104(sp),d6
 move.l 108(sp),a4
 move.l a3,d0
 beq friendly_destroy
 moveq #35,d0
friendly_copy:
 move.b 0(a2,d0.w),0(a6,d0.w)
 dbra d0,friendly_copy
 move.l a6,-(sp)
 move.l a3,-(sp)
 move.l a2,-(sp)
 jsr _relative_vector
 lea 12(sp),sp
 move.l d0,d5
 move.b 2(a6),d0
 or.b 5(a6),d0
 or.b 8(a6),d0
 and.b #127,d0
 or.b 1(a6),d0
 or.b 4(a6),d0
 or.b 7(a6),d0
 bne friendly_far
 cmp.w #7,d6
 beq friendly_destroy
 btst #5,31(a3)
 bne friendly_destroy
 or.b #128,31(a3)
 or.b #128,31(a2)
 moveq #8,d0
 bra friendly_done
friendly_destroy:
 or.b #128,31(a2)
 moveq #6,d0
 bra friendly_done
friendly_far:
 ; TAS1/MVT3 returns the original z-axis carry.
 move.l d5,d0
 move.l d0,-(sp)
 move.l a4,-(sp)
 jsr _elite_random
 addq.l #8,sp
 cmp.b #16,d0
 bhs friendly_steer
 btst #0,32(a3)
 beq friendly_steer
 moveq #7,d0
 bra friendly_done
friendly_steer:
 move.b #8,36(a6)
 clr.l -(sp)
 move.l a4,-(sp)
 pea 36(a6)
 move.l a6,-(sp)
 jsr _missile_steer
 lea 16(sp),sp
 move.b 28(a6),28(a2)
 move.b 29(a6),29(a2)
 move.b 30(a6),30(a2)
 moveq #0,d0
friendly_done:
 lea 48(sp),sp
 movem.l (sp)+,d2-d7/a2-a6
 rts
; FRS1/ZINF + NWSHP for a player missile: out, target slot, player speed.
.globl _player_missile_init
_player_missile_init:
 move.l 4(sp),a0
 moveq #35,d0
player_zero:
 clr.b 0(a0,d0.w)
 dbra d0,player_zero
 move.b #28,3(a0)
 move.b #128,5(a0)
 move.b #14,6(a0)
 move.b #96,14(a0)
 move.b #96,18(a0)
 move.b #224,22(a0)
 move.l 8(sp),d0
 add.b d0,d0
 or.b #128,d0
 move.b d0,32(a0)
 move.l 12(sp),d0
 add.b d0,d0
 move.b d0,27(a0)
 move.b #2,35(a0)
 rts
