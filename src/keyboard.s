; Consume character events while retaining IPC held-key matrix controls.
; This foreground application uses the current QDOS keyboard queue. IO.QOUT
; is the documented ROM vector, rather than writing queue internals directly.
.sect .text
.sect .rom
.sect .data
.sect .bss
.sect .text
.globl _keyboard_drain
.extern __sys_var
_keyboard_drain:
 movem.l d2-d4/a2-a3,-(sp)
 move.l __sys_var,a0
 move.l 0x4c(a0),a2
 move.l a2,d0
 beq drain_done
 move.w #127,d4
queue_next:
 move.w 0xe2,a0
 jsr (a0)
 tst.l d0
 bne drain_done
 dbra d4,queue_next
 drain_done:
 movem.l (sp)+,d2-d4/a2-a3
 rts
