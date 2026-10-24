; Minimal all-assembly QDOS foreground shell. Uses the recovered linker's
; relocatable job startup, but bypasses C initialization, stdio and malloc.
.sect .text
.sect .rom
.sect .data
.sect .bss
.sect .data
.align 2
.globl __Cstart
.globl __stack
.globl __prog_name
__Cstart: .data4 asm_main
__stack: .data4 2048
__prog_name: .data1 69,108,105,116,101,81,76,32,65,83,77,32,65,56,0
.align 2
asm_stats:
 .data4 0x45514138,0x36383030
asm_frames: .data4 0
asm_ticks: .data4 0
asm_free: .data4 0
asm_count: .data2 1
asm_paused: .data2 0
asm_model: .data2 4
asm_ready: .data2 0
asm_snapshot: .data4 0
asm_uncapped: .data2 0
asm_ship_debug: .data4 asm_ships
asm_vector_debug: .data4 asm_vectors
asm_params_debug: .data4 asm_params
asm_controls_debug: .data4 asm_controls
asm_status_debug: .data4 asm_status
asm_mcnt_debug: .data4 asm_mcnt
asm_dials_debug: .data4 _dials_last_status
asm_laser_debug: .data4 asm_laser
asm_hits_debug: .data4 asm_hits
asm_kills_debug: .data4 asm_kills
asm_station: .data4 0
asm_hits: .data4 0
asm_kills: .data4 0
; Fixed reproducible scene seed, NOT the original game's clock initialization.
asm_laser: .data1 0,0,0,128,96,90,111,23,201,0,0,0
asm_fire_key: .data1 0
asm_sight: .data1 0
asm_params: .data1 0,0,1,0
asm_controls: .data1 128,128,0,0,0,0,0,0,0,0,0,0,1
asm_keys: .data1 0,0,0,0,0,0
asm_status: .data1 255,255,255,0,0
asm_mcnt: .data1 0
.align 2
asm_fps_text: .ascii "FPS 00.0  SPEED 00\0"
.align 2
asm_poll: .data4 0,asm_clock
asm_ipc: .data1 9,1,0,0,0,0,1,2
.sect .text
.extern _laser_fire
.extern _laser_tick
.extern _laser_hit
.extern _ship_damage
.extern _ship_angry
.extern _laser_xor
.extern _sight_xor
.extern _dials_frame
.extern _dials_last_status
.extern _energy_step
.extern _scanner_frame
.extern _scanner_reset
.extern _control_step
.extern _keyboard_drain
.extern _models
.extern _render_ship
.extern _tidy_ship
.extern _move_ship
.extern _motion_position
.extern _motion_matrix
.extern _live_matrix
.globl _exit
asm_clock:
 addq.l #1,asm_ticks
 rts
asm_main:
 ; MT.ALCHP, block owned by this job. No permanent allocation on failure.
 moveq #0x18,d0
 move.l #32768,d1
 moveq #-1,d2
 trap #1
 tst.l d0
 bne _exit
 move.l a0,asm_snapshot
 move.l a0,a1
 move.l #0x20000,a0
 move.w #8191,d0
asm_save_screen:
 move.l (a0)+,(a1)+
 dbra d0,asm_save_screen
 moveq #0x10,d0
 moveq #-1,d1
 moveq #-1,d2
 trap #1
 move.w d1,asm_oldmode
 move.w d2,asm_olddisplay
 moveq #0x10,d0
 moveq #8,d1
 moveq #0,d2
 trap #1
 move.l #0x20000,a0
 move.w #8191,d0
asm_clear_screen:
 clr.l (a0)+
 dbra d0,asm_clear_screen
 bsr asm_labels
 bsr asm_setup
 lea asm_poll,a0
 moveq #0x1c,d0
 trap #1
 moveq #6,d0
 trap #1
 move.l d1,asm_free
 move.w #1,asm_ready
asm_loop:
 move.l asm_ticks,d0
 addq.l #5,d0
 move.l d0,asm_deadline
 ; Scan the IPC keyboard at 10 Hz even in uncapped render mode.
 move.l asm_ticks,d0
 cmp.l asm_nextkeys,d0
 blt asm_draw_begin
 addq.l #5,d0
 move.l d0,asm_nextkeys
 jsr _keyboard_drain
 moveq #2,d0
 bsr asm_keyrow
 move.w d0,asm_row2
 btst #4,d0
 beq asm_bench_done
 btst #4,asm_old2+1
 bne asm_bench_done
 eor.w #1,asm_uncapped
asm_bench_done:
 move.w asm_row2,asm_old2
 moveq #1,d0
 bsr asm_keyrow
 move.w d0,asm_row1
 btst #3,d0
 bne asm_finish
 btst #6,d0
 beq asm_pause_done
 btst #6,asm_old1+1
 bne asm_pause_done
 eor.w #1,asm_paused
asm_pause_done:
 move.w asm_row1,asm_old1
 moveq #7,d0
 bsr asm_keyrow
 move.w d0,asm_row7
 btst #6,d0
 beq asm_next_done
 btst #6,asm_old7+1
 bne asm_next_done
 addq.w #1,asm_model
 cmp.w #10,asm_model
 blt asm_next_valid
 clr.w asm_model
asm_next_valid:
 move.w asm_model,d0
 lsl.w #2,d0
 lea _models,a0
 move.l 0(a0,d0.w),asm_ships
 bsr asm_setup
asm_next_done:
 move.w asm_row7,asm_old7
 moveq #4,d0
 bsr asm_keyrow
 btst #3,d0
 beq asm_check_fleet
 cmp.w #1,asm_count
 beq asm_check_fleet
 move.w #1,asm_count
 bsr asm_setup
asm_check_fleet:
 moveq #6,d0
 bsr asm_keyrow
 btst #1,d0
 beq asm_move
 cmp.w #12,asm_count
 beq asm_move
 move.w #12,asm_count
 bsr asm_setup
asm_move:
 ; Map raw QL keys to original DOKEY/KY1/KY2 held states.
 ; Rate updates run once per simulation frame below, not per scan.
 lea asm_keys,a0
 move.w asm_row1,d0
 btst #1,d0
 sne (a0)
 btst #4,d0
 sne 1(a0)
 btst #2,d0
 sne 2(a0)
 btst #7,d0
 sne 3(a0)
 moveq #4,d0
 bsr asm_keyrow
 lea asm_keys,a0
 btst #4,d0
 sne 4(a0)
 moveq #2,d0
 bsr asm_keyrow
 lea asm_keys,a0
 btst #1,d0
 sne 5(a0)
 moveq #3,d0
 bsr asm_keyrow
 btst #4,d0
 sne asm_fire_key
asm_draw_begin:
 tst.w asm_paused
 bne asm_update_stats
 pea asm_keys
 pea asm_controls
 jsr _control_step
 addq.l #8,sp
 move.b asm_controls+4,asm_params
 move.b asm_controls+5,asm_params+1
 move.b asm_controls+12,asm_params+2
 ; MA68/LASLI. With Electron sound absent, LASLI entry carry is explicit 0.
 clr.l -(sp)
 move.l #15,-(sp)
 moveq #0,d0
 move.b asm_fire_key,d0
 move.l d0,-(sp)
 pea asm_status
 pea asm_laser
 jsr _laser_fire
 lea 20(sp),sp
 tst.l d0
 beq asm_fire_drawn
 pea asm_laser
 pea 0x20000
 jsr _laser_xor
 addq.l #8,sp
 move.b #1,asm_laser+9
asm_fire_drawn:
 lea asm_ships,a5
 move.w asm_count,d7
 subq.w #1,d7
asm_draw_loop:
 lea asm_vectors,a0
 move.w asm_count,d0
 subq.w #1,d0
 sub.w d7,d0
 mulu.w #36,d0
 adda.l d0,a0
 move.l a0,a4
 move.b 31(a4),d0
 and.b #160,d0
 beq asm_live_ship
 move.w #1,14(a5)
 bra asm_render_current
asm_live_ship:
 ; Original MVEIT part 1 scheduling: (MCNT XOR XSAV) AND 15.
 move.b 31(a4),d0
 and.b #160,d0
 bne asm_no_tidy
 move.w asm_count,d0
 subq.w #1,d0
 sub.w d7,d0
 moveq #0,d1
 move.b asm_mcnt,d1
 eor.w d1,d0
 and.w #15,d0
 bne asm_no_tidy
 move.l a4,-(sp)
 jsr _tidy_ship
 addq.l #4,sp
asm_no_tidy:
 move.l (a5),a0
 move.w 22(a0),d0
 move.b d0,asm_params+3
 pea asm_params
 move.l a4,-(sp)
 jsr _move_ship
 addq.l #8,sp
 pea 4(a5)
 move.l a4,-(sp)
 jsr _motion_position
 addq.l #8,sp
 eor.w #1,d0
 move.w d0,14(a5)
 ; Original HITCH runs on world-space INWK, independently of line projection.
 tst.b asm_laser+1
 beq asm_no_hit
 move.l (a5),a0
 moveq #0,d0
 move.w 26(a0),d0
 move.l d0,-(sp)
 moveq #0,d0
 move.w 28(a0),d0
 move.l d0,-(sp)
 move.l a4,-(sp)
 jsr _laser_hit
 lea 12(sp),sp
 tst.l d0
 beq asm_no_hit
 addq.l #1,asm_hits
 move.l (a5),a0
 moveq #0,d0
 move.w 28(a0),d0
 move.l d0,-(sp)
 moveq #0,d0
 move.b asm_laser+1,d0
 move.l d0,-(sp)
 move.l a4,-(sp)
 jsr _ship_damage
 lea 12(sp),sp
 cmp.w #2,d0
 bne asm_hit_survived
 ; Adapter boundary: remove killed test target, pending original debris/LL9.
 move.w #1,14(a5)
 addq.l #1,asm_kills
 bra asm_render_current
asm_hit_survived:
 move.l asm_station,-(sp)
 move.l (a5),a0
 moveq #0,d0
 move.w 28(a0),d0
 move.l d0,-(sp)
 move.l a4,-(sp)
 jsr _ship_angry
 lea 12(sp),sp
asm_no_hit:
 pea asm_matrix
 move.l a4,-(sp)
 jsr _motion_matrix
 addq.l #8,sp
 move.l #asm_matrix,_live_matrix
asm_render_current:
 move.l a5,-(sp)
 pea 0x20000
 jsr _render_ship
 addq.l #8,sp
 clr.l _live_matrix
 lea 272(a5),a5
 dbra d7,asm_draw_loop
 moveq #0,d0
 move.w asm_count,d0
 move.l d0,-(sp)
 pea asm_vectors
 pea 0x20000
 jsr _scanner_frame
 lea 12(sp),sp
 moveq #0,d0
 move.b asm_mcnt,d0
 move.l d0,-(sp)
 pea asm_status
 jsr _energy_step
 addq.l #8,sp
 ; MA23 erases pulse lines when LASCT falls below 8.
 tst.b asm_laser+9
 beq asm_laser_end
 cmp.b #8,asm_laser
 bhs asm_laser_end
 bsr asm_erase_laser
asm_laser_end:
 ; Spawn/ECM branches are not ported; explicit C=1 MLOOP cadence (10,6,2,0).
 move.l #1,-(sp)
 pea asm_laser
 jsr _laser_tick
 addq.l #8,sp
 subq.b #1,asm_mcnt
 bsr asm_draw_dials
 addq.l #1,asm_frames
asm_update_stats:
 bsr asm_fps
 tst.w asm_uncapped
 bne asm_loop
asm_wait:
 move.l asm_deadline,d0
 sub.l asm_ticks,d0
 ble asm_loop
 moveq #8,d0
 moveq #-1,d1
 moveq #1,d3
 suba.l a1,a1
 trap #1
 bra asm_wait
asm_finish:
 ; Wait for release so autorepeat cannot inject the exit key into BASIC.
 clr.w asm_release_quiet
asm_release_wait:
 jsr _keyboard_drain
 clr.w asm_release_keys
 clr.w asm_release_row
asm_release_scan:
 move.w asm_release_row,d0
 bsr asm_keyrow
 or.w d0,asm_release_keys
 addq.w #1,asm_release_row
 cmp.w #8,asm_release_row
 blt asm_release_scan
 tst.w asm_release_keys
 beq asm_release_idle
 clr.w asm_release_quiet
 bra asm_release_tick
asm_release_idle:
 addq.w #1,asm_release_quiet
 cmp.w #3,asm_release_quiet
 bge asm_release_done
asm_release_tick:
 moveq #8,d0
 moveq #-1,d1
 moveq #1,d3
 suba.l a1,a1
 trap #1
 bra asm_release_wait
asm_release_done:
 jsr _keyboard_drain
 clr.w asm_ready
 lea asm_poll,a0
 moveq #0x1d,d0
 trap #1
 moveq #0x10,d0
 move.w asm_oldmode,d1
 move.w asm_olddisplay,d2
 trap #1
 move.l asm_snapshot,a0
 move.l #0x20000,a1
 move.w #8191,d0
asm_restore_screen:
 move.l (a0)+,(a1)+
 dbra d0,asm_restore_screen
 move.l asm_snapshot,a0
 moveq #0x19,d0
 trap #1
 clr.l asm_snapshot
 moveq #0,d0
_exit:
 move.l d0,d3
 moveq #-1,d1
 moveq #5,d0
 trap #1
 bra _exit
; Row in D0, byte result in D0. MT.IPCOM clobbers D5/D7/A3.
asm_keyrow:
 move.b d0,asm_ipc+6
 lea asm_ipc,a3
 moveq #0x11,d0
 trap #1
 moveq #0,d0
 move.b d1,d0
 rts
; Erase all old caches before changing between one and twelve ships.
asm_erase_laser:
 tst.b asm_laser+9
 beq asm_erase_laser_done
 pea asm_laser
 pea 0x20000
 jsr _laser_xor
 addq.l #8,sp
 clr.b asm_laser+9
 clr.b asm_laser+2
asm_erase_laser_done:
 rts
asm_setup:
 bsr asm_erase_laser
 tst.b asm_sight
 bne asm_sight_ready
 pea 0x20000
 jsr _sight_xor
 addq.l #4,sp
 move.b #1,asm_sight
asm_sight_ready:
 clr.b asm_laser
 clr.b asm_laser+1
 clr.b asm_laser+2
 clr.l asm_hits
 clr.l asm_kills
 clr.l asm_station
 pea 0x20000
 jsr _scanner_reset
 addq.l #4,sp
 lea asm_ships,a5
 moveq #11,d7
asm_erase_all:
 clr.w 14(a5)
 clr.l (a5)
 move.l a5,-(sp)
 pea 0x20000
 jsr _render_ship
 addq.l #8,sp
 lea 272(a5),a5
 dbra d7,asm_erase_all
 lea asm_ships,a5
 lea asm_fleet_positions,a4
 lea _models,a3
 moveq #0,d7
asm_setup_loop:
 move.w d7,d0
 cmp.w #10,d0
 blt asm_setup_model
 sub.w #10,d0
asm_setup_model:
 lsl.w #2,d0
 move.l 0(a3,d0.w),(a5)
 move.w (a4)+,4(a5)
 move.w (a4)+,6(a5)
 move.w #2400,8(a5)
 move.w d7,d0
 mulu.w #21,d0
 add.w #128,d0
 and.w #255,d0
 move.w d0,10(a5)
 lea 272(a5),a5
 addq.w #1,d7
 cmp.w asm_count,d7
 blt asm_setup_loop
 cmp.w #1,asm_count
 bne asm_setup_done
 move.w asm_model,d0
 lsl.w #2,d0
 move.l 0(a3,d0.w),asm_ships
 clr.w asm_ships+4
 clr.w asm_ships+6
 move.w #640,asm_ships+8
asm_setup_done:
 bsr asm_reset_vectors
 move.b #255,asm_status
 move.b #255,asm_status+1
 move.b #255,asm_status+2
 clr.b asm_status+3
 clr.b asm_status+4
 clr.b asm_mcnt
 bsr asm_draw_dials
 rts
asm_draw_dials:
 moveq #0,d0
 move.b asm_mcnt,d0
 move.l d0,-(sp)
 pea asm_status
 pea asm_controls
 pea 0x20000
 jsr _dials_frame
 lea 16(sp),sp
 rts
asm_reset_vectors:
 clr.b asm_params
 clr.b asm_params+1
 move.b #1,asm_params+2
 lea asm_controls,a0
 moveq #12,d0
asm_clear_controls:
 clr.b 0(a0,d0.w)
 dbra d0,asm_clear_controls
 move.b #128,(a0)
 move.b #128,1(a0)
 move.b #1,12(a0)
 lea asm_vectors,a0
 lea asm_ships,a1
 moveq #11,d0
asm_reset_vector:
 moveq #35,d1
asm_zero_vector:
 clr.b 0(a0,d1.w)
 dbra d1,asm_zero_vector
 move.b #0xe0,14(a0)
 move.b #0x60,18(a0)
 move.b #0x60,22(a0)
 ; Copy scene coordinates into authoritative original INWK format.
 moveq #0,d4
 moveq #4,d5
 moveq #2,d6
asm_seed_coordinate:
 move.w 0(a1,d5.w),d2
 moveq #0,d3
 tst.w d2
 bpl asm_seed_positive
 neg.w d2
 move.w #128,d3
asm_seed_positive:
 move.b d2,0(a0,d4.w)
 lsr.w #8,d2
 move.b d2,1(a0,d4.w)
 move.b d3,2(a0,d4.w)
 addq.w #3,d4
 addq.w #2,d5
 dbra d6,asm_seed_coordinate
 move.b #2,27(a0)
 move.l (a1),d2
 beq asm_seed_station_done
 move.l d2,a3
 move.w 24(a3),d2
 move.b d2,35(a0)
 cmp.w #7,28(a3)
 bne asm_seed_energy_done
 lea 32(a0),a2
 move.l a2,asm_station
asm_seed_energy_done:
 tst.w 22(a3)
 bne asm_seed_station_done
 clr.b 27(a0)
asm_seed_station_done:
 move.b #32,29(a0)
 move.b #16,30(a0)
 lea 36(a0),a0
 lea 272(a1),a1
 dbra d0,asm_reset_vector
 rts
 ; Update a small status strip once per second; never clear the flight view.
asm_fps:
 move.l asm_ticks,d1
 sub.l asm_stat_ticks,d1
 cmp.l #50,d1
 blt fps_return
 move.l asm_ticks,asm_stat_ticks
 move.l asm_frames,d0
 sub.l asm_stat_frames,d0
 move.l asm_frames,asm_stat_frames
 mulu.w #500,d0
 divu.w d1,d0
 and.l #65535,d0
 cmp.w #999,d0
 ble fps_bounded
 move.w #999,d0
fps_bounded:
 divu.w #10,d0
 move.l d0,d2
 swap d2
 add.b #48,d2
 move.b d2,asm_fps_text+7
 and.l #65535,d0
 divu.w #10,d0
 move.l d0,d2
 swap d2
 add.b #48,d2
 move.b d2,asm_fps_text+5
 add.b #48,d0
 move.b d0,asm_fps_text+4
 moveq #0,d0
 move.b asm_params+2,d0
 divu.w #10,d0
 move.l d0,d2
 swap d2
 add.b #48,d2
 move.b d2,asm_fps_text+17
 add.b #48,d0
 move.b d0,asm_fps_text+16
 move.l #0x27c00,a0
 move.w #255,d0
fps_clear:
 clr.l (a0)+
 dbra d0,fps_clear
 lea asm_fps_text,a4
 move.w #248,d6
 bsr asm_text
fps_return:
 rts
; Original dashboard is copied by scanner_reset during scene setup.
asm_labels:
 rts
asm_text:
 move.w #32,d7
text_character:
 moveq #0,d0
 move.b (a4)+,d0
 beq text_done
 sub.w #32,d0
 mulu.w #7,d0
 lea asm_font,a3
 adda.w d0,a3
 moveq #0,d5
text_row:
 moveq #0,d4
 move.b (a3)+,d4
 moveq #0,d3
text_bit:
 btst #4,d4
 beq text_next_bit
 move.w d6,d0
 add.w d5,d0
 mulu.w #128,d0
 move.w d7,d1
 add.w d3,d1
 move.w d1,d2
 lsr.w #2,d1
 add.w d1,d1
 add.w d1,d0
 move.l #0x20000,a0
 adda.l d0,a0
 and.w #3,d2
 add.w d2,d2
 lea text_masks(pc),a1
 move.w 0(a1,d2.w),d1
 or.w d1,(a0)
text_next_bit:
 lsl.w #1,d4
 addq.w #1,d3
 cmp.w #5,d3
 blt text_bit
 addq.w #1,d5
 cmp.w #7,d5
 blt text_row
 addq.w #6,d7
 bra text_character
text_done:
 rts
text_masks: .data2 0x80c0,0x2030,0x080c,0x0203
label1: .ascii "ELITE / 68000 ASM TEST\0"
label2: .ascii "N RESET  1 SOLO   2 FLEET\0"
label3: .ascii "ARROWS FLY A/Z SPEED SPACE PAUSE\0"
label4: .ascii "B UNCAP / CAP   ESC EXIT\0"
.align 2
asm_fleet_positions:
 .data2 -675,350,-225,350,225,350,675,350
 .data2 -675,0,-225,0,225,0,675,0
 .data2 -675,-350,-225,-350,225,-350,675,-350
.sect .bss
.align 2
asm_ships: .space 3264
asm_deadline: .space 4
asm_oldmode: .space 2
asm_olddisplay: .space 2
asm_old1: .space 2
asm_old7: .space 2
asm_row1: .space 2
asm_row7: .space 2
asm_row2: .space 2
asm_old2: .space 2
asm_nextkeys: .space 4
asm_stat_frames: .space 4
asm_stat_ticks: .space 4

.sect .rom
asm_font:
 .data1 0,0,0,0,0,0,0
 .data1 0,0,0,0,0,0,0
 .data1 0,0,0,0,0,0,0
 .data1 0,0,0,0,0,0,0
 .data1 0,0,0,0,0,0,0
 .data1 0,0,0,0,0,0,0
 .data1 0,0,0,0,0,0,0
 .data1 0,0,0,0,0,0,0
 .data1 0,0,0,0,0,0,0
 .data1 0,0,0,0,0,0,0
 .data1 0,0,0,0,0,0,0
 .data1 0,4,4,31,4,4,0
 .data1 0,0,0,0,0,0,0
 .data1 0,0,0,31,0,0,0
 .data1 0,0,0,0,0,4,4
 .data1 1,2,2,4,8,8,16
 .data1 14,17,19,21,25,17,14
 .data1 4,12,4,4,4,4,14
 .data1 14,17,1,2,4,8,31
 .data1 30,1,1,14,1,1,30
 .data1 2,6,10,18,31,2,2
 .data1 31,16,16,30,1,1,30
 .data1 14,16,16,30,17,17,14
 .data1 31,1,2,4,8,8,8
 .data1 14,17,17,14,17,17,14
 .data1 14,17,17,15,1,1,14
 .data1 0,4,4,0,4,4,0
 .data1 0,0,0,0,0,0,0
 .data1 0,0,0,0,0,0,0
 .data1 0,0,0,0,0,0,0
 .data1 16,8,4,2,4,8,16
 .data1 14,17,1,2,4,0,4
 .data1 0,0,0,0,0,0,0
 .data1 14,17,17,31,17,17,17
 .data1 30,17,17,30,17,17,30
 .data1 15,16,16,16,16,16,15
 .data1 30,17,17,17,17,17,30
 .data1 31,16,16,30,16,16,31
 .data1 31,16,16,30,16,16,16
 .data1 15,16,16,23,17,17,15
 .data1 17,17,17,31,17,17,17
 .data1 31,4,4,4,4,4,31
 .data1 7,2,2,2,18,18,12
 .data1 17,18,20,24,20,18,17
 .data1 16,16,16,16,16,16,31
 .data1 17,27,21,21,17,17,17
 .data1 17,25,21,19,17,17,17
 .data1 14,17,17,17,17,17,14
 .data1 30,17,17,30,16,16,16
 .data1 14,17,17,17,21,18,13
 .data1 30,17,17,30,20,18,17
 .data1 15,16,16,14,1,1,30
 .data1 31,4,4,4,4,4,4
 .data1 17,17,17,17,17,17,14
 .data1 17,17,17,17,17,10,4
 .data1 17,17,17,21,21,21,10
 .data1 17,17,10,4,10,17,17
 .data1 17,17,10,4,4,4,4
 .data1 31,1,2,4,8,16,31
 .data1 0,0,0,0,0,0,0
 .data1 0,0,0,0,0,0,0
 .data1 0,0,0,0,0,0,0
 .data1 0,0,0,0,0,0,0
 .data1 0,0,0,0,0,0,0
 .data1 0,0,0,0,0,0,0
 .data1 0,0,0,0,0,0,0
 .data1 0,0,0,0,0,0,0
 .data1 0,0,0,0,0,0,0
 .data1 0,0,0,0,0,0,0
 .data1 0,0,0,0,0,0,0
 .data1 0,0,0,0,0,0,0
 .data1 0,0,0,0,0,0,0
 .data1 0,0,0,0,0,0,0
 .data1 0,0,0,0,0,0,0
 .data1 0,0,0,0,0,0,0
 .data1 0,0,0,0,0,0,0
 .data1 0,0,0,0,0,0,0
 .data1 0,0,0,0,0,0,0
 .data1 0,0,0,0,0,0,0
 .data1 0,0,0,0,0,0,0
 .data1 0,0,0,0,0,0,0
 .data1 0,0,0,0,0,0,0
 .data1 0,0,0,0,0,0,0
 .data1 0,0,0,0,0,0,0
 .data1 0,0,0,0,0,0,0
 .data1 0,0,0,0,0,0,0
 .data1 0,0,0,0,0,0,0
 .data1 0,0,0,0,0,0,0
 .data1 0,0,0,0,0,0,0
 .data1 0,0,0,0,0,0,0
 .data1 0,0,0,0,0,0,0
 .data1 0,0,0,0,0,0,0
 .data1 0,0,0,0,0,0,0
 .data1 0,0,0,0,0,0,0
 .data1 0,0,0,0,0,0,0
 .data1 0,0,0,0,0,0,0

.sect .bss
.align 2
asm_vectors: .space 432
asm_matrix: .space 18

.sect .bss
.align 2
asm_release_keys: .space 2
asm_release_row: .space 2
asm_release_quiet: .space 2
