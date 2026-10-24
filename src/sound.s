; Electron NOS1/NO3/SFXL decisions, with a separate QL IPC hardware adapter.
; NO3 really indexes SFX2 by 0,8,...72. Preserve the shipped binary bytes;
; do not silently "correct" this to a ten-entry priority table.
; state[24]: priorities0..1,durations2..3,active4,id5,channel6,amplitude7,
; pitch8,env9,stage10,steps11,base12,unused13,remaining10ms14..15,
; last50HzTick16..19,lastEmittedPitch20..21,hardwareActive22..23.
.sect .text
.globl _sound_event
.globl _sound_tick
.globl _sound_advance
.globl _sound_poll
.globl _sound_stop
_sound_event:
 movem.l d2-d4/a2-a3,-(sp)
 move.l 24(sp),a2
 move.l 28(sp),d2
 cmp.w #72,d2
 bhi sound_reject
 move.w d2,d0
 and.w #7,d0
 bne sound_reject
 lsr.w #1,d2
 lea sound_effects,a3
 adda.w d2,a3
 moveq #0,d3
 move.b (a3),d3
 and.w #1,d3
 lsr.w #2,d2
 lea sound_priorities,a0
 move.b 0(a0,d2.w),d4
 cmp.b 0(a2,d3.w),d4
 blo sound_reject
 move.b d4,0(a2,d3.w)
 and.b #15,d4
 move.b d4,2(a2,d3.w)
 move.b #1,4(a2)
 move.b d2,5(a2)
 move.b d3,6(a2)
 move.b 1(a3),7(a2)
 move.b 2(a3),8(a2)
 move.b 2(a3),12(a2)
 clr.b 9(a2)
 clr.b 10(a2)
 clr.b 11(a2)
 moveq #0,d0
 move.b 3(a3),d0
 mulu.w #5,d0
 move.w d0,14(a2)
 move.l 32(sp),16(a2)
 move.w #-1,20(a2)
 tst.b 1(a3)
 beq sound_silence
 moveq #0,d0
 move.b 1(a3),d0
 cmp.w #4,d0
 bhi sound_accept
 move.b d0,9(a2)
 subq.w #1,d0
 mulu.w #6,d0
 lea sound_envelopes,a0
 move.b 3(a0,d0.w),11(a2)
 bra sound_accept
sound_silence:
 clr.b 4(a2)
sound_accept:
 moveq #1,d0
 bra sound_event_done
sound_reject:
 moveq #0,d0
sound_event_done:
 movem.l (sp)+,d2-d4/a2-a3
 rts
_sound_tick:
 move.l 4(sp),a0
 moveq #1,d0
sound_priority_tick:
 subq.b #1,2(a0,d0.w)
 bpl sound_priority_next
 clr.b 2(a0,d0.w)
 clr.b 0(a0,d0.w)
sound_priority_next:
 dbra d0,sound_priority_tick
 rts
; MOS ENVELOPE adapter: all four supplied envelopes have T=1 (10ms), repeat.
; Electron ignores envelope amplitude fields9..14 (Acorn User Guide ch22).
_sound_advance:
 movem.l d2-d4/a2,-(sp)
 move.l 20(sp),a2
 move.l 24(sp),d4
sound_step:
 tst.l d4
 beq sound_advance_done
 tst.b 4(a2)
 beq sound_advance_done
 subq.l #1,d4
 tst.w 14(a2)
 beq sound_expired
 subq.w #1,14(a2)
 beq sound_expired
 moveq #0,d0
 move.b 9(a2),d0
 beq sound_step
 subq.w #1,d0
 mulu.w #6,d0
 lea sound_envelopes,a0
 adda.w d0,a0
 moveq #0,d1
 move.b 10(a2),d1
 move.b 0(a0,d1.w),d0
 add.b d0,8(a2)
 subq.b #1,11(a2)
 bne sound_step
 addq.b #1,10(a2)
 cmp.b #3,10(a2)
 blo sound_stage
 clr.b 10(a2)
 move.b 12(a2),8(a2)
sound_stage:
 moveq #0,d1
 move.b 10(a2),d1
 move.b 3(a0,d1.w),11(a2)
 bra sound_step
sound_expired:
 clr.b 4(a2)
sound_advance_done:
 movem.l (sp)+,d2-d4/a2
 rts
; Clock-driven output, safe in normal job context; never trap from poll ISR.
_sound_poll:
 movem.l d2-d7/a2-a6,-(sp)
 move.l 48(sp),a2
 move.l 52(sp),d0
 move.l d0,d1
 sub.l 16(a2),d1
 move.l d0,16(a2)
 add.l d1,d1
 move.l d1,-(sp)
 move.l a2,-(sp)
 jsr _sound_advance
 addq.l #8,sp
 tst.b 4(a2)
 beq sound_poll_silent
 moveq #0,d0
 move.b 8(a2),d0
 ; QL has one speaker: last accepted source channel owns its output.
 lea sound_pitch,a0
 move.b 0(a0,d0.w),d0
 and.w #255,d0
 cmp.w 20(a2),d0
 beq sound_poll_done
 move.w d0,20(a2)
 move.b d0,sound_ipc+6
 move.w #1,22(a2)
 lea sound_ipc,a3
 moveq #17,d0
 trap #1
 bra sound_poll_done
sound_poll_silent:
 tst.w 22(a2)
 beq sound_poll_done
 clr.w 22(a2)
 lea sound_stop_ipc,a3
 moveq #17,d0
 trap #1
sound_poll_done:
 movem.l (sp)+,d2-d7/a2-a6
 rts
_sound_stop:
 movem.l d2-d7/a2-a6,-(sp)
 move.l 48(sp),a2
 clr.b 4(a2)
 clr.w 22(a2)
 lea sound_stop_ipc,a3
 moveq #17,d0
 trap #1
 movem.l (sp)+,d2-d7/a2-a6
 rts
.sect .data
sound_effects:
 .data1 17,1,0,3,17,2,44,4,17,3,240,6,16,241,4,5
 .data1 1,241,188,1,17,244,12,8,16,241,4,6,16,2,96,16
 .data1 17,4,194,255,17,0,0,0
sound_priorities: .data1 112,240,42,162,162,134,133,169,135,57
sound_envelopes:
 .data1 0,111,248,4,1,8,14,238,255,44,32,50
 .data1 1,255,253,17,32,128,4,248,44,4,6,8
; QL 72us half-period quantization, Acorn pitch88=A440, four steps/semitone.
; This is an explicit tonal hardware approximation (not Electron ULA noise).
sound_pitch:
 .data1 56,55,55,54,53,52,52,51,50,49,49,48,47,47,46,45
 .data1 45,44,43,43,42,42,41,40,40,39,39,38,38,37,36,36
 .data1 35,35,34,34,33,33,32,32,32,31,31,30,30,29,29,29
 .data1 28,28,27,27,27,26,26,25,25,25,24,24,24,23,23,23
 .data1 22,22,22,21,21,21,20,20,20,20,19,19,19,18,18,18
 .data1 18,17,17,17,17,16,16,16,16,16,15,15,15,15,14,14
 .data1 14,14,14,13,13,13,13,13,13,12,12,12,12,12,11,11
 .data1 11,11,11,11,11,10,10,10,10,10,10,10,9,9,9,9
 .data1 9,9,9,8,8,8,8,8,8,8,8,8,7,7,7,7
 .data1 7,7,7,7,7,7,6,6,6,6,6,6,6,6,6,6
 .data1 6,6,5,5,5,5,5,5,5,5,5,5,5,5,5,4
 .data1 4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4
 .data1 4,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3
 .data1 3,3,3,3,3,3,3,3,2,2,2,2,2,2,2,2
 .data1 2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2
 .data1 2,2,2,2,2,2,2,2,2,2,2,1,1,1,1,1
.align 2
; Exact ROM BEEP IPC packet format, continuous tone; software owns duration.
sound_ipc: .data1 10,16,68,68,170,102,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0
sound_stop_ipc: .data1 11,0,0,0,0,0,1,0
