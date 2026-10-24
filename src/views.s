; Original PLUT/PUS1. Copy workspace so simulation remains ship-relative.
.sect .text
.globl _view_transform
_view_transform:
 movem.l d2-d4/a2,-(sp)
 move.l 20(sp),a0
 move.l 24(sp),a1
 move.l 28(sp),d4
 moveq #35,d0
view_copy:
 move.b 0(a1,d0.w),0(a0,d0.w)
 dbra d0,view_copy
 tst.w d4
 beq view_done
 cmp.w #1,d4
 bne view_side
 eor.b #128,2(a0)
 eor.b #128,8(a0)
 lea 9(a0),a2
 moveq #2,d2
view_rear_vectors:
 eor.b #128,1(a2)
 eor.b #128,5(a2)
 addq.l #6,a2
 dbra d2,view_rear_vectors
 bra view_done
view_side:
 move.l #128,d2
 moveq #0,d3
 cmp.w #2,d4
 beq view_side_signs
 exg d2,d3
view_side_signs:
 move.b (a0),d0
 move.b 6(a0),(a0)
 move.b d0,6(a0)
 move.b 1(a0),d0
 move.b 7(a0),1(a0)
 move.b d0,7(a0)
 move.b 2(a0),d0
 eor.b d2,d0
 move.b 8(a0),d1
 eor.b d3,d1
 move.b d1,2(a0)
 move.b d0,8(a0)
 lea 9(a0),a2
 moveq #2,d4
view_side_vectors:
 move.b (a2),d0
 move.b 4(a2),(a2)
 move.b d0,4(a2)
 move.b 1(a2),d0
 eor.b d2,d0
 move.b 5(a2),d1
 eor.b d3,d1
 move.b d1,1(a2)
 move.b d0,5(a2)
 addq.l #6,a2
 dbra d4,view_side_vectors
view_done:
 movem.l (sp)+,d2-d4/a2
 rts
