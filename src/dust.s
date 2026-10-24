; Electron STARS1/STARS6/STARS2/FLIP/nWq native entry and QL PIXEL adapter.
; void dust_run(state[168], params[3], rng[4], view, operation, screen);
; operation 0=nWq initialization, 1=STARS, 2=FLIP, 3=redraw without advance.
; NOST=10 in this Electron source. Arrays reserve 0..18 for ABI stability;
; only particles 1..10 are processed.
; The original PIXEL plots a TWOS2 dash even at the far-distance threshold.
; Screen reads affect A only, which all callers overwrite before use.
.sect .text
.globl _dust_run
.globl dust_plot
.extern dust_original_init
.extern dust_original_step
.extern dust_original_flip
.extern dust_original_redraw
.extern _cloud_xor
_dust_run:
 movem.l d2-d7/a2-a6,-(sp)
 move.l 48(sp),a2
 move.l 52(sp),a0
 move.l 56(sp),a4
 move.l 60(sp),d0
 move.b d0,162(a2)
 move.l 68(sp),a3
 move.b (a0),142(a2)
 move.b (a0),d0
 and.b #127,d0
 move.b d0,146(a2)
 move.b (a0),d0
 and.b #128,d0
 move.b d0,148(a2)
 eor.b #128,d0
 move.b d0,149(a2)
 move.b 1(a0),144(a2)
 move.b 1(a0),d0
 and.b #127,d0
 move.b d0,150(a2)
 move.b 1(a0),d0
 and.b #128,d0
 move.b d0,152(a2)
 eor.b #128,d0
 move.b d0,153(a2)
 moveq #0,d0
 move.b 2(a0),d0
 move.b d0,154(a2)
 lsl.w #6,d0
 move.b d0,156(a2)
 lsr.w #8,d0
 move.b d0,157(a2)
 moveq #3,d0
 dust_rng_in:
 move.b 0(a4,d0.w),114(a2,d0.w)
 dbra d0,dust_rng_in
 move.l 64(sp),d7
 moveq #0,d0
 moveq #0,d1
 moveq #0,d2
 moveq #0,d3
 moveq #0,d4
 tst.w d7
 bne dust_not_init
 ; RES2's low-coordinate workspace boundary.
 lea 57(a2),a0
 moveq #56,d0
 dust_clear_low:
 clr.b (a0)+
 dbra d0,dust_clear_low
 dust_init_no_clear:
 bsr dust_original_init
 bra dust_return
 dust_not_init:
 cmp.w #4,d7
 beq dust_init_no_clear
 cmp.w #1,d7
 bne dust_not_step
 bsr dust_original_step
 bra dust_return
 dust_not_step:
 cmp.w #2,d7
 bne dust_redraw
 bsr dust_original_flip
 bra dust_return
 dust_redraw:
 bsr dust_original_redraw
 dust_return:
 move.b d3,166(a2)
 moveq #3,d0
 dust_rng_out:
 move.b 114(a2,d0.w),0(a4,d0.w)
 dbra d0,dust_rng_out
 movem.l (sp)+,d2-d7/a2-a6
 rts
; A=y, X=x, Y=particle index. The QL adapter preserves the original
; PIXEL's C=(ZZ>=80), X=x&7 and final N/Z from restored Y.
 dust_plot:
 movem.l d0-d7/a0-a6,-(sp)
 move.l a3,d5
 beq dust_plot_done
 subq.l #4,sp
 move.b d1,(sp)
 move.b d0,1(sp)
 move.b 140(a2),2(sp)
 clr.b 3(sp)
 move.l sp,a0
 move.l #1,-(sp)
 move.l a0,-(sp)
 move.l a3,-(sp)
 jsr _cloud_xor
 lea 16(sp),sp
 dust_plot_done:
 movem.l (sp)+,d0-d7/a0-a6
 and.b #7,d1
 cmp.b #80,140(a2)
 scc d3
 and.b #1,d3
 move.b d2,d4
 clr.b d0
 rts
