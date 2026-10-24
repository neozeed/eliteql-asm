; Native Electron DIALS 1-3 and shield/laser-temperature sections of part 4.
; No invented fuel, altitude or compass inputs. Original DIL / DIL2 pixels.
; dials_frame(screen, controls[13], status[5], mcnt).
; status: FSH, ASH, ENERGY, GNTMP, ENGY (energy unit).
.sect .text
.globl _dials_frame
.globl _energy_step
.globl _dials_last_status
_energy_step:
 move.l 4(sp),a0
 move.l 8(sp),d0
 and.w #7,d0
 bne energy_cool
 tst.b 2(a0)
 bpl energy_charge
 ; Original SHD order: aft shield, then forward shield.
 cmp.b #255,1(a0)
 beq energy_front
 addq.b #1,1(a0)
 bsr energy_drain
energy_front:
 cmp.b #255,(a0)
 beq energy_charge
 addq.b #1,(a0)
 bsr energy_drain
energy_charge:
 moveq #0,d0
 move.b 2(a0),d0
 moveq #0,d1
 move.b 4(a0),d1
 add.w d1,d0
 addq.w #1,d0
 cmp.w #255,d0
 bhi energy_cool
 move.b d0,2(a0)
energy_cool:
 tst.b 3(a0)
 beq energy_done
 subq.b #1,3(a0)
energy_done:
 rts
energy_drain:
 subq.b #1,2(a0)
 bne energy_drain_done
 addq.b #1,2(a0)
energy_drain_done:
 rts
_dials_frame:
 movem.l d2-d7/a2-a4,-(sp)
 move.l 40(sp),a2
 move.l 44(sp),a3
 move.l 48(sp),a4
 move.l 52(sp),d7
 moveq #0,d0
 move.b 12(a3),d0
 move.w #24936,d1
 bsr dials_bar
 moveq #0,d0
 move.b 6(a3),d0
 lsr.b #2,d0
 or.b 7(a3),d0
 eor.b #128,d0
 bsr dials_add8
 move.w #25832,d1
 bsr dials_marker
 moveq #0,d0
 move.b 5(a3),d0
 tst.b 9(a3)
 beq dials_pitch_zero
 ; NEXTR clears C on the actual dashboard address, so SBC #1 subtracts 2.
 subq.b #2,d0
 and.w #255,d0
 dials_pitch_zero:
 bsr dials_add8
 move.w #26856,d1
 bsr dials_marker
 and.w #3,d7
 bne dials_done
 lea _dials_last_status,a0
 moveq #4,d0
dials_snapshot:
 move.b 0(a4,d0.w),0(a0,d0.w)
 dbra d0,dials_snapshot
 moveq #0,d6
 dials_energy_loop:
 moveq #0,d0
 move.b 2(a4),d0
 lsr.w #1,d0
 moveq #3,d1
 sub.w d6,d1
 lsl.w #5,d1
 sub.w d1,d0
 bpl dials_energy_value
 moveq #0,d0
 dials_energy_value:
 move.w d6,d1
 lsl.w #8,d1
 lsl.w #2,d1
 add.w #28008,d1
 bsr dials_bar
 addq.w #1,d6
 cmp.w #4,d6
 blt dials_energy_loop
 moveq #0,d0
 move.b (a4),d0
 lsr.w #3,d0
 move.w #24840,d1
 bsr dials_bar
 moveq #0,d0
 move.b 1(a4),d0
 lsr.w #3,d0
 move.w #25864,d1
 bsr dials_bar
 moveq #0,d0
 move.b 3(a4),d0
 lsr.w #3,d0
 move.w #28936,d1
 bsr dials_bar
 dials_done:
 movem.l (sp)+,d2-d7/a2-a4
 rts
; ADD with low bytes P=R=0 and positive S=8; preserve signed zero.
 dials_add8:
 tst.b d0
 bmi dials_add_negative
 addq.b #8,d0
 and.w #255,d0
 rts
 dials_add_negative:
 and.w #127,d0
 subq.w #8,d0
 bpl dials_add_sign
 neg.w d0
 rts
 dials_add_sign:
 or.w #128,d0
 rts
; A 32-pixel DIL bar, three rows high. d0 length, d1 screen-byte offset.
 dials_bar:
 lea 0(a2,d1.w),a0
 moveq #7,d5
 dials_bar_loop:
 move.w d0,d2
 cmp.w #4,d2
 bls dials_bar_partial
 moveq #4,d2
 dials_bar_partial:
 sub.w d2,d0
 add.w d2,d2
 lea dials_masks(pc),a1
 move.w 0(a1,d2.w),d3
 move.w d3,(a0)
 move.w d3,128(a0)
 move.w d3,256(a0)
 addq.l #2,a0
 dbra d5,dials_bar_loop
 rts
 dials_masks: .data2 0,0x80c0,0xa0f0,0xa8fc,0xaaff
; DIL2 has 16 positions, each two pixels wide, in four 32-pixel rows.
 dials_marker:
 lea 0(a2,d1.w),a0
 move.l a0,a1
 moveq #7,d5
 dials_marker_clear:
 clr.w (a0)
 clr.w 128(a0)
 clr.w 256(a0)
 clr.w 384(a0)
 addq.l #2,a0
 dbra d5,dials_marker_clear
 cmp.w #15,d0
 bhi dials_marker_done
 move.w d0,d2
 lsr.w #1,d2
 add.w d2,d2
 move.w #0xa0f0,d3
 btst #0,d0
 beq dials_marker_write
 move.w #0x0a0f,d3
 dials_marker_write:
 adda.w d2,a1
 move.w d3,(a1)
 move.w d3,128(a1)
 move.w d3,256(a1)
 move.w d3,384(a1)
 dials_marker_done:
 rts
.sect .bss
.align 2
_dials_last_status: .space 6
