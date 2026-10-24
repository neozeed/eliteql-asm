; Original proximity/ISDK/MA62 decisions. Return0 far,1 dock,2 dent,3 fatal.
.sect .text
.globl _dock_check
.extern _tactics_vector
_dock_check:
 movem.l d2/a2,-(sp)
 move.l 12(sp),a2
 move.l 16(sp),d2
 move.b 31(a2),d0
 and.b #160,d0
 or.b 1(a2),d0
 or.b 4(a2),d0
 or.b 7(a2),d0
 bne dock_far
 move.b (a2),d0
 or.b 3(a2),d0
 or.b 6(a2),d0
 bmi dock_far
 tst.b 32(a2)
 bmi dock_bad
 cmp.b #214,14(a2)
 blo dock_bad
 subq.l #4,sp
 move.l sp,a0
 move.l a0,-(sp)
 move.l a2,-(sp)
 jsr _tactics_vector
 addq.l #8,sp
 move.b 2(sp),d0
 addq.l #4,sp
 tst.b d0
 bmi dock_bad
 cmp.b #89,d0
 blo dock_bad
 move.b 16(a2),d0
 and.b #127,d0
 cmp.b #80,d0
 blo dock_bad
 moveq #1,d0
 bra dock_done
dock_bad:
 moveq #2,d0
 cmp.b #5,d2
 blo dock_done
 moveq #3,d0
 bra dock_done
dock_far:
 moveq #0,d0
dock_done:
 movem.l (sp)+,d2/a2
 rts

; Original MA64 gate. key & DKCMP & SSPR must be nonzero; station AI nonnegative.
; computer_dock(key,fitted,safeZone,stationAI) -> boolean GOIN intent.
.globl _computer_dock
_computer_dock:
 move.l 4(sp),d0
 and.l 8(sp),d0
 and.l 12(sp),d0
 and.l #255,d0
 beq computer_no
 move.l 16(sp),d1
 tst.b d1
 bmi computer_no
 moveq #1,d0
 rts
computer_no:
 moveq #0,d0
 rts
