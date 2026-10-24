; TACTICS station branch + SFS1/SFS2 launch geometry.
; station_police(out36,parent36,rng4,copCount): bool intent.
; Called only on hostile station's original tactics cadence.
.sect .text
.globl _station_police
_station_police:
 movem.l d2-d7/a2-a3,-(sp)
 move.l 36(sp),a2
 move.l 40(sp),a3
 ; CPX #SST on equal type supplies C=1 to original DORND.
 move.l #1,-(sp)
 move.l 48(sp),-(sp)
 jsr _elite_random
 addq.l #8,sp
 cmp.b #140,d0
 blo police_no
 cmp.l #3,48(sp)
 bhs police_no
 moveq #35,d0
police_copy:
 move.b 0(a3,d0.w),0(a2,d0.w)
 dbra d0,police_copy
 move.b #32,27(a2)
 move.b #225,32(a2)
 and.b #254,29(a2)
 move.l a2,a0
 lea 10(a2),a1
 moveq #2,d7
police_axis:
 moveq #0,d0
 move.b (a1),d0
 move.l d0,d2
 and.l #128,d2
 lsl.l #8,d2
 lsl.l #8,d2
 and.l #127,d0
 add.w d0,d0
 moveq #0,d1
 move.b 2(a0),d1
 lsl.l #8,d1
 move.b 1(a0),d1
 lsl.l #8,d1
 move.b (a0),d1
 move.l d1,d3
 and.l #0x800000,d3
 and.l #0x7fffff,d1
 cmp.l d2,d3
 bne police_sub
 add.l d1,d0
 and.l #0xffffff,d0
 or.l d3,d0
 bra police_store
police_sub:
 sub.l d0,d1
 bcc police_coord_sign
 neg.l d1
 eor.l #0x800000,d3
police_coord_sign:
 move.l d1,d0
 or.l d3,d0
police_store:
 move.b d0,(a0)
 lsr.l #8,d0
 move.b d0,1(a0)
 lsr.l #8,d0
 move.b d0,2(a0)
 addq.l #3,a0
 addq.l #2,a1
 dbra d7,police_axis
 moveq #1,d0
 bra police_return
police_no:
 moveq #0,d0
police_return:
 movem.l (sp)+,d2-d7/a2-a3
 rts
