; Electron SCAN geometry and MVEIT part 9, with a native QL pixel backend.
; scanner_project(inwk,type,out[4]): x, dot_y, base_y, visible. Returns visible.
; scanner_flags(inwk): original exploding/killed visibility update.
.sect .text
.globl _scanner_project
.globl _scanner_flags
.globl _scanner_xor
.globl _scanner_frame
.globl _scanner_reset
.extern _dashboard_pixels
_scanner_flags:
 move.l 4(sp),a0
 move.b 31(a0),d0
 and.b #160,d0
 bne scanner_hide
 or.b #16,31(a0)
 rts
scanner_hide:
 and.b #239,31(a0)
 rts
_scanner_project:
 move.l 4(sp),a0
 move.l 8(sp),d0
 move.l 12(sp),a1
 clr.b 3(a1)
 tst.b d0
 bmi scanner_reject
 btst #4,31(a0)
 beq scanner_reject
 move.b 1(a0),d0
 or.b 4(a0),d0
 or.b 7(a0),d0
 and.b #192,d0
 bne scanner_reject
 moveq #0,d0
 move.b 1(a0),d0
 tst.b 2(a0)
 bpl scanner_xplus
 ; EOR #255 / ADC #1 leaves carry set for negative zero.
 neg.w d0
 bne scanner_xplus
 moveq #1,d0
scanner_xplus:
 add.w #123,d0
 move.b d0,(a1)
 moveq #0,d0
 move.b 7(a0),d0
 lsr.w #2,d0
 tst.b 8(a0)
 bpl scanner_zplus
 neg.w d0
scanner_zplus:
 neg.w d0
 add.w #220,d0
 move.b d0,2(a1)
 moveq #0,d1
 move.b 4(a0),d1
 lsr.w #1,d1
 tst.b 5(a0)
 bmi scanner_yminus
 neg.w d1
scanner_yminus:
 add.w d1,d0
 cmp.w #194,d0
 bge scanner_ymin
 move.w #194,d0
scanner_ymin:
 cmp.w #246,d0
 ble scanner_ymax
 move.w #246,d0
scanner_ymax:
 move.b d0,1(a1)
 move.b #1,3(a1)
 moveq #1,d0
 rts
scanner_reject:
 moveq #0,d0
 rts
; scanner_xor(screen, projected). Projected records must come from SCAN.
; CPIX4 draws three pixels wide by two high (the source's JSR P%+3).
_scanner_xor:
 move.l 4(sp),a0
 move.l 8(sp),a1
 movem.l d2-d7,-(sp)
 tst.b 3(a1)
 beq scanner_draw_done
 moveq #0,d5
 move.b (a1),d5
 moveq #0,d6
 move.b 1(a1),d6
 moveq #0,d7
 move.b 2(a1),d7
 move.w d5,d0
 move.w d6,d1
 bsr scanner_pixel
 addq.w #1,d0
 bsr scanner_pixel
 addq.w #1,d0
 bsr scanner_pixel
 subq.w #1,d1
 bsr scanner_pixel
 subq.w #1,d0
 bsr scanner_pixel
 subq.w #1,d0
 bsr scanner_pixel
 addq.w #2,d0
 cmp.w d7,d6
 beq scanner_draw_done
 blt scanner_stick_down
 ; Original VLL1 starts above the top dot row and ends at base-1.
 subq.w #1,d1
 subq.w #1,d7
scanner_stick_up_loop:
 bsr scanner_pixel
 subq.w #1,d1
 cmp.w d7,d1
 bge scanner_stick_up_loop
 bra scanner_draw_done
scanner_stick_down:
 ; Original VLL2 skips both dot rows and ends on the base row.
 move.w d6,d1
 addq.w #1,d1
scanner_stick_down_loop:
 bsr scanner_pixel
 addq.w #1,d1
 cmp.w d7,d1
 ble scanner_stick_down_loop
scanner_draw_done:
 movem.l (sp)+,d2-d7
 rts
scanner_pixel:
 move.w d1,d2
 lsl.w #7,d2
 move.w d0,d3
 lsr.w #2,d3
 add.w d3,d3
 add.w d3,d2
 move.w d0,d3
 and.w #3,d3
 add.w d3,d3
 lea scanner_masks(pc),a1
 move.w 0(a1,d3.w),d4
 eor.w d4,0(a0,d2.w)
 rts
scanner_masks: .data2 0x80c0,0x2030,0x080c,0x0203
; scanner_reset(screen): original artwork and empty cached contacts.
_scanner_reset:
 move.l 4(sp),a0
 adda.l #24576,a0
 lea _dashboard_pixels,a1
 move.w #1791,d0
scanner_background:
 move.l (a1)+,(a0)+
 dbra d0,scanner_background
 lea scanner_cache,a0
 moveq #11,d0
scanner_clear_cache:
 clr.l (a0)+
 dbra d0,scanner_clear_cache
 rts
; scanner_frame(screen, inwk_slots[12][36], count), count in 0..12.
; Erase all old records, apply part 9, then plot current records.
_scanner_frame:
 movem.l d2-d7/a2-a4,-(sp)
 move.l 40(sp),a2
 move.l 44(sp),a3
 move.l 48(sp),d7
 lea scanner_cache,a4
 moveq #11,d6
scanner_erase_loop:
 move.l a4,-(sp)
 move.l a2,-(sp)
 jsr _scanner_xor
 addq.l #8,sp
 clr.b 3(a4)
 addq.l #4,a4
 dbra d6,scanner_erase_loop
 lea scanner_cache,a4
 subq.w #1,d7
 bmi scanner_frame_done
scanner_frame_loop:
 move.l a3,-(sp)
 jsr _scanner_flags
 addq.l #4,sp
 move.l a4,-(sp)
 move.l #1,-(sp)
 move.l a3,-(sp)
 jsr _scanner_project
 lea 12(sp),sp
 move.l a4,-(sp)
 move.l a2,-(sp)
 jsr _scanner_xor
 addq.l #8,sp
 lea 36(a3),a3
 addq.l #4,a4
 dbra d7,scanner_frame_loop
scanner_frame_done:
 movem.l (sp)+,d2-d7/a2-a4
 rts
.sect .bss
.align 2
scanner_cache: .space 48
