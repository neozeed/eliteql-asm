; QDOS-native commander file adapter, not an Electron tape-format conversion.
; io(buffer148,write): 0 success, nonzero QDOS/short-transfer error.
.sect .text
.globl _commander_io
_commander_io:
 movem.l d2-d7/a2-a6,-(sp)
 move.l 48(sp),a4
 move.l 52(sp),d4
 lea _commander_filename,a0
 moveq #-1,d1
 moveq #1,d3
 tst.w d4
 beq save_open
 moveq #3,d3
save_open:
 moveq #1,d0
 trap #2
 tst.l d0
 bne save_return
 move.l a0,a5
 move.l a4,a1
 move.w #144,d2
 moveq #-1,d3
 moveq #3,d0
 tst.w d4
 beq save_transfer
 move.w #148,d2
 moveq #7,d0
save_transfer:
 trap #3
 move.l d0,d5
 tst.l d5
 bne save_close
 tst.w d4
 beq save_read_size
 cmp.w #148,d1
 beq save_close
 bra save_short
save_read_size:
 cmp.w #144,d1
 bne save_short
 cmp.l #0x45514132,(a4)
 bne save_close
 move.l a5,a0
 lea 144(a4),a1
 moveq #4,d2
 moveq #-1,d3
 moveq #3,d0
 trap #3
 move.l d0,d5
 bne save_close
 cmp.w #4,d1
 beq save_close
save_short:
 moveq #-10,d5
save_close:
 move.l a5,a0
 moveq #2,d0
 trap #2
 tst.l d5
 beq save_return
 move.l d5,d0
save_return:
 movem.l (sp)+,d2-d7/a2-a6
 rts
.sect .data
.align 2
 .globl _commander_filename
_commander_filename: .data2 14
 .ascii "WIN1_ELITESAVE"
 .space 4
