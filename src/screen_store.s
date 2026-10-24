; QL-only lossless backing-store compression. No gameplay state is compressed.
; pack(src32768,dstOrNull,capacity) -> bytes, or -1 if capacity is insufficient.
; A null destination measures the exact size. Runs are BE word count/value.
.sect .text
.globl _screen_pack
.globl _screen_unpack
_screen_pack:
 movem.l d2-d5/a2,-(sp)
 move.l 24(sp),a0
 move.l 28(sp),a1
 move.l 32(sp),d5
 move.l a1,a2
 move.w #16384,d2
 moveq #0,d0
pack_run:
 move.w (a0)+,d3
 moveq #1,d4
 subq.w #1,d2
 beq pack_emit
pack_scan:
 cmp.w (a0),d3
 bne pack_emit
 addq.l #2,a0
 addq.w #1,d4
 subq.w #1,d2
 bne pack_scan
pack_emit:
 addq.l #4,d0
 move.l a2,d1
 beq pack_next
 cmp.l d5,d0
 bhi pack_overflow
 move.w d4,(a1)+
 move.w d3,(a1)+
pack_next:
 tst.w d2
 bne pack_run
 bra pack_done
pack_overflow:
 moveq #-1,d0
pack_done:
 movem.l (sp)+,d2-d5/a2
 rts
; unpack(src,dst32768) -> 0; bounded decoder rejects malformed run lengths.
_screen_unpack:
 movem.l d2-d3,-(sp)
 move.l 12(sp),a0
 move.l 16(sp),a1
 move.w #16384,d2
unpack_run:
 moveq #0,d0
 move.w (a0)+,d0
 beq unpack_bad
 cmp.w d2,d0
 bhi unpack_bad
 sub.w d0,d2
 move.w (a0)+,d1
 subq.w #1,d0
unpack_copy:
 move.w d1,(a1)+
 dbra d0,unpack_copy
 tst.w d2
 bne unpack_run
 moveq #0,d0
 bra unpack_done
unpack_bad:
 moveq #-1,d0
unpack_done:
 movem.l (sp)+,d2-d3
 rts
