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
__prog_name: .data1 69,108,105,116,101,81,76,32,65,83,77,32,65,57,0
.align 2
asm_stats:
 .data4 0x45514242,0x36383030
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
asm_cloud_debug: .data4 asm_clouds
asm_ai_params_debug: .data4 asm_ai_params
asm_dead_debug: .data4 asm_dead
asm_mode_debug: .data4 asm_mode
asm_rng_debug: .data4 asm_laser+5
asm_ai_calls_debug: .data4 asm_ai_calls
asm_ai_events_debug: .data4 asm_ai_events
asm_ecm_debug: .data4 asm_ecm
asm_launch_debug: .data4 asm_launches
asm_player_debug: .data4 asm_player
asm_planet_debug: .data4 asm_planet
asm_pods_debug: .data4 asm_pods
asm_cargo_debug: .data4 asm_cargo
asm_scooped_debug: .data4 asm_scooped
asm_debris_debug: .data4 asm_debris
asm_full_debug: .data4 asm_full
asm_commander_debug: .data4 asm_commander
asm_page_debug: .data4 asm_page
asm_equipment_debug: .data4 asm_equipment
asm_compass_debug: .data4 asm_compass
asm_losses_debug: .data4 asm_losses
asm_docked_debug: .data4 asm_docked
asm_market_debug: .data4 asm_market
asm_selection_debug: .data4 asm_market_selection
asm_travel_debug: .data4 asm_travel
asm_nav_debug: .data4 asm_nav
asm_arrival_debug: .data4 asm_arriving
asm_fit_debug: .data4 _ship_fit
asm_shop_debug: .data4 asm_shop
asm_chart: .data2 0
asm_solar_legal: .data2 0
asm_shop: .data2 0
asm_travel: .space 64
asm_nav: .data2 0
asm_nav_keys: .data2 0
asm_nav_step: .data2 0
asm_nav_tries: .data2 0
asm_arriving: .data2 0
asm_arrival_rng: .data4 0
asm_docked: .data2 0
asm_market_selection: .data2 0
asm_market_keys: .data2 0
asm_market_result: .data2 0
asm_keep_launch: .data2 0
asm_keep: .space 34
asm_market: .space 34
asm_compass: .data1 0,0,0,0
asm_losses: .data4 0
asm_bomb_held: .data2 0
asm_commander: .data4 1000
 .data1 0,0,0,0,0,0
asm_page: .data2 0
asm_page_key: .data2 0
asm_salvage: .data2 0
asm_cargo: .space 17
asm_equipment: .data1 255,255,127,0,0
asm_scooped: .data4 0
asm_debris: .data4 0
asm_full: .data4 0
asm_planet: .space 36
asm_pods: .data4 0
asm_spawn_kind: .data2 6
asm_player: .data1 4,0,255,0
asm_mkeys: .data1 0,0,0,0
asm_ecm: .data1 0,0
asm_launches: .data4 0
asm_dead: .data2 0
asm_mode: .data2 0
asm_ai_calls: .data4 0
asm_ai_events: .data4 0
asm_ai_params: .data1 1,70,16,0,0,0
asm_slot: .data2 0
asm_cloud: .data4 0
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
asm_dead_text: .ascii "DESTROYED - N / 1 / 2 / 3\0"
.align 2
asm_fps_text: .ascii "FPS 00.0  SPEED 00"
asm_msl_text: .ascii " M4 -"
asm_cargo_text: .ascii " C00\0"
.align 2
asm_poll: .data4 0,asm_clock
asm_ipc: .data1 9,1,0,0,0,0,1,2
.sect .text
.extern _equipment_damage
.extern _bomb_key
.extern _bomb_ship
.extern _bomb_tick
.extern _dock_check
.extern _market_init
.extern _market_trade
.extern _launch_legal
.extern _tactics_vector
.extern _move_planet
.extern _compass_frame
.extern _commander_tally
.extern _commander_settle
.extern _commander_rank
.extern _commander_tick
.extern _render_cache
.extern _elite_random
.extern _scoop_step
.extern _debris_count
.extern _cargo_tumble
.extern _player_damage
.extern _pod_step
.extern _tactics_cnt
.extern _missile_icons
.extern _friendly_missile
.extern _player_missile_init
.extern _hostile_missile
.extern _spawn_child
.extern _ecm_step
.extern _tactics_step
.extern _tactics_due
.extern _explosion_start
.extern _explosion_frame
.extern _cloud_xor
.extern _render_exploding
.extern _render_inwk
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
 ; Modal commander page: freezes simulation, preserves the pre-existing pause.
 moveq #1,d0
 bsr asm_keyrow
 btst #3,d0
 bne asm_finish
 bsr asm_navigation_keys
 tst.w d0
 bne asm_update_stats
 tst.w asm_docked
 beq asm_flight_keys
 bsr asm_dock_keys
 bra asm_update_stats
asm_flight_keys:
 moveq #6,d0
 bsr asm_keyrow
 and.w #4,d0
 move.w asm_page_key,d1
 eor.w d0,d1
 move.w d0,asm_page_key
 and.w d0,d1
 beq asm_page_key_done
 eor.w #1,asm_page
 bsr asm_clear_view
 tst.w asm_page
 beq asm_page_close
 bsr asm_commander_page
 bra asm_page_key_done
asm_page_close:
 bsr asm_restore_view
asm_page_key_done:
 tst.w asm_page
 bne asm_update_stats
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
 clr.w asm_mode
 bsr asm_setup
asm_check_fleet:
 moveq #4,d0
 bsr asm_keyrow
 btst #1,d0
 beq asm_check_two
 cmp.w #2,asm_mode
 bne asm_start_encounter
 tst.w asm_dead
 beq asm_check_two
asm_start_encounter:
 move.w #3,asm_count
 move.w #2,asm_mode
 bsr asm_setup
asm_check_two:
 moveq #6,d0
 bsr asm_keyrow
 btst #1,d0
 beq asm_move
 cmp.w #1,asm_mode
 beq asm_move
 move.w #12,asm_count
 move.w #1,asm_mode
 bsr asm_setup
asm_move:
 moveq #0,d0
 bsr asm_keyrow
 btst #6,d0
 beq asm_check_salvage
 tst.w asm_salvage
 bne asm_missile_scene
 cmp.w #3,asm_mode
 bne asm_missile_scene
 tst.w asm_dead
 beq asm_check_ecm
asm_missile_scene:
 clr.w asm_salvage
 move.w #12,asm_count
 move.w #3,asm_mode
 bsr asm_setup
asm_check_salvage:
 moveq #0,d0
 bsr asm_keyrow
 btst #2,d0
 beq asm_check_ecm
 cmp.w #3,asm_mode
 bne asm_salvage_scene
 tst.w asm_salvage
 beq asm_salvage_scene
 tst.w asm_dead
 beq asm_check_ecm
asm_salvage_scene:
 move.w #1,asm_salvage
 move.w #12,asm_count
 move.w #3,asm_mode
 bsr asm_setup
asm_check_ecm:
 moveq #0,d0
 bsr asm_keyrow
 btst #7,d0
 beq asm_port_key_done
 cmp.w #3,asm_mode
 bne asm_start_port
 cmp.w #2,asm_salvage
 bne asm_start_port
 tst.w asm_dead
 beq asm_port_key_done
asm_start_port:
 move.w #2,asm_salvage
 move.w #12,asm_count
 move.w #3,asm_mode
 bsr asm_setup
asm_port_key_done:
 tst.b asm_equipment
 beq asm_ecm_key_done
 moveq #6,d0
 bsr asm_keyrow
 btst #4,d0
 beq asm_ecm_key_done
 tst.b asm_ecm
 bne asm_ecm_key_done
 move.b #32,asm_ecm
 move.b #255,asm_ecm+1
asm_ecm_key_done:
 moveq #5,d0
 bsr asm_keyrow
 and.w #32,d0
 move.w d0,asm_bomb_held
 moveq #6,d0
 bsr asm_keyrow
 btst #6,d0
 sne asm_mkeys
 btst #7,d0
 sne asm_mkeys+1
 moveq #2,d0
 bsr asm_keyrow
 btst #6,d0
 sne asm_mkeys+2
 ; Map raw QL keys to original DOKEY/KY1/KY2 held states.
 ; Rate updates run once per simulation frame below, not per scan.
 lea asm_keys,a0
 move.w asm_row1,d0
 btst #1,d0
 sne (a0)
 btst #4,d0
 sne 1(a0)
 ; Traditional flight mapping: Down pulls up, Up pushes down.
 btst #7,d0
 sne 2(a0)
 btst #2,d0
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
 tst.w asm_nav
 bne asm_update_stats
 tst.w asm_docked
 bne asm_update_stats
 tst.w asm_page
 bne asm_update_stats
 tst.w asm_dead
 bne asm_update_stats
 tst.w asm_paused
 bne asm_update_stats
 pea asm_travel
 jsr _travel_tick
 addq.l #4,sp
 tst.w d0
 bne asm_arrival
 moveq #0,d0
 move.w asm_bomb_held,d0
 move.l d0,-(sp)
 pea asm_equipment+2
 jsr _bomb_key
 addq.l #8,sp
 bsr asm_player_input
 pea asm_keys
 pea asm_controls
 jsr _control_step
 addq.l #8,sp
 move.b asm_controls+4,asm_params
 move.b asm_controls+5,asm_params+1
 move.b asm_controls+12,asm_params+2
 ; Test-scene planet follows original player-relative movement.
 clr.b asm_params+3
 clr.l -(sp)
 pea asm_params
 pea asm_planet
 jsr _move_planet
 lea 12(sp),sp
 ; MA68/LASLI. With Electron sound absent, LASLI entry carry is explicit 0.
 clr.l -(sp)
 moveq #0,d0
 move.b _ship_fit+1,d0
 move.l d0,-(sp)
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
 move.w d0,asm_slot
 mulu.w #448,d0
 lea asm_clouds,a1
 adda.l d0,a1
 move.l a1,asm_cloud
 move.w asm_slot,d0
 mulu.w #36,d0
 adda.l d0,a0
 move.l a0,a4
 moveq #0,d0
 move.b asm_equipment+2,d0
 move.l d0,-(sp)
 move.l (a5),a0
 move.w 28(a0),d0
 move.l d0,-(sp)
 move.l a4,-(sp)
 jsr _bomb_ship
 lea 12(sp),sp
 tst.l d0
 beq asm_bomb_ship_done
 pea asm_commander
 jsr _commander_tally
 addq.l #4,sp
asm_bomb_ship_done:
 btst #7,31(a4)
 beq asm_pending_done
 btst #5,31(a4)
 bne asm_pending_done
 pea asm_laser+5
 move.l (a5),-(sp)
 move.l asm_cloud,-(sp)
 move.l a4,-(sp)
 jsr _explosion_start
 lea 16(sp),sp
 bsr asm_abort_target
asm_pending_done:
 move.b 31(a4),d0
 and.b #160,d0
 beq asm_live_ship
 cmp.b #32,d0
 beq asm_no_tidy
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
 ; Original cadence, with universe-dependent types left outside this entry.
 moveq #0,d0
 move.w asm_slot,d0
 move.l d0,-(sp)
 moveq #0,d0
 move.b asm_mcnt,d0
 move.l d0,-(sp)
 move.l (a5),a0
 moveq #0,d0
 move.w 28(a0),d0
 move.l d0,-(sp)
 move.l a4,-(sp)
 jsr _tactics_due
 lea 16(sp),sp
 tst.l d0
 beq asm_ai_done
 tst.w asm_dead
 bne asm_ai_done
 move.l (a5),a0
 cmp.w #11,28(a0)
 beq asm_pod_ai
 cmp.w #8,28(a0)
 beq asm_ai_allowed
 cmp.w #6,28(a0)
 bhi asm_ai_done
 bra asm_ai_allowed
asm_pod_ai:
 moveq #0,d0
 move.b _tactics_cnt,d0
 move.l d0,-(sp)
 pea asm_planet
 move.l a4,-(sp)
 jsr _pod_step
 lea 12(sp),sp
 bra asm_ai_done
asm_ai_allowed:
 move.w 28(a0),d0
 move.b d0,asm_ai_params
 move.w 24(a0),d0
 move.b d0,asm_ai_params+1
 move.w 30(a0),d0
 move.b d0,asm_ai_params+2
 move.b asm_ecm,asm_ai_params+4
 pea asm_status
 pea asm_laser+5
 pea asm_ai_params
 move.l a4,-(sp)
 cmp.b #8,asm_ai_params
 bne asm_normal_ai
 tst.b asm_ecm
 bne asm_hostile_path
 btst #6,32(a4)
 bne asm_hostile_path
 ; The friendly entry has a different ABI, discard the common arguments.
 lea 16(sp),sp
 moveq #0,d0
 move.b 32(a4),d0
 lsr.w #1,d0
 and.w #31,d0
 cmp.w #12,d0
 bhs asm_friendly_invalid
 move.w d0,d1
 mulu.w #272,d1
 lea asm_ships,a0
 adda.l d1,a0
 move.l (a0),a0
 moveq #0,d1
 move.w 28(a0),d1
 mulu.w #36,d0
 lea asm_vectors,a0
 adda.l d0,a0
 btst #7,31(a0)
 bne asm_friendly_invalid
 bra asm_friendly_target
asm_friendly_invalid:
 suba.l a0,a0
 moveq #0,d1
asm_friendly_target:
 pea asm_laser+5
 move.l d1,-(sp)
 move.l a0,-(sp)
 move.l a4,-(sp)
 jsr _friendly_missile
 lea 16(sp),sp
 cmp.w #7,d0
 bne asm_friendly_not_ecm
 move.b #32,asm_ecm
 moveq #0,d0
 bra asm_ai_result
asm_friendly_not_ecm:
 cmp.w #6,d0
 blo asm_ai_result
 ; TA35 collateral blast uses the existing explicit-carry adapter.
 move.b #1,asm_ai_params+4
 pea asm_status
 pea asm_laser+5
 pea asm_ai_params
 move.l a4,-(sp)
asm_hostile_path:
 tst.b asm_ai_params+4
 beq asm_missile_no_tally
 pea asm_commander
 jsr _commander_tally
 addq.l #4,sp
asm_missile_no_tally:
 jsr _hostile_missile
 bra asm_ai_return
asm_normal_ai:
 jsr _tactics_step
asm_ai_return:
 lea 16(sp),sp
asm_ai_result:
 addq.l #1,asm_ai_calls
 cmp.w #1,d0
 bne asm_ai_not_launch
 bsr asm_spawn_missile
 moveq #0,d0
asm_ai_not_launch:
 cmp.w #2,d0
 bne asm_ai_not_escape
 move.w #9,asm_spawn_kind
 bsr asm_spawn_missile
 move.w #6,asm_spawn_kind
 moveq #0,d0
asm_ai_not_escape:
 cmp.w #3,d0
 blo asm_ai_not_hit
 addq.l #1,asm_ai_events
asm_ai_not_hit:
 cmp.w #4,d0
 bne asm_ai_no_ouch
 bsr asm_equipment_ouch
 moveq #4,d0
asm_ai_no_ouch:
 cmp.w #5,d0
 bne asm_ai_done
 move.w #1,asm_dead
asm_ai_done:
 btst #7,31(a4)
 beq asm_ai_alive
 pea asm_laser+5
 move.l (a5),-(sp)
 move.l asm_cloud,-(sp)
 move.l a4,-(sp)
 jsr _explosion_start
 lea 16(sp),sp
 bsr asm_abort_target
asm_ai_alive:
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
 bsr asm_contact
 tst.w asm_docked
 bne asm_dock_commit
 move.b 31(a4),d0
 and.b #160,d0
 bne asm_no_hit
 tst.b asm_player+1
 beq asm_lock_done
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
 beq asm_lock_done
 move.w asm_slot,d0
 move.b d0,asm_player+2
 clr.b asm_player+1
asm_lock_done:
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
 pea asm_commander
 jsr _commander_tally
 addq.l #4,sp
 bsr asm_drop_cargo
 ; LL9 initializes a real original explosion cloud at the kill boundary.
 pea asm_laser+5
 move.l (a5),-(sp)
 move.l asm_cloud,-(sp)
 move.l a4,-(sp)
 jsr _explosion_start
 lea 16(sp),sp
 bsr asm_abort_target
 addq.l #1,asm_kills
 bra asm_no_hit
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
 clr.w _render_exploding
 move.l a4,_render_inwk
 btst #5,31(a4)
 beq asm_render_effect_ready
 move.w #1,_render_exploding
asm_render_effect_ready:
 move.l a5,-(sp)
 pea 0x20000
 jsr _render_ship
 addq.l #8,sp
 clr.l _live_matrix
 clr.l _render_inwk
 clr.w _render_exploding
 btst #5,31(a4)
 beq asm_cloud_done
 move.l asm_cloud,a0
 tst.b 2(a0)
 beq asm_cloud_done
 pea asm_laser+5
 move.l a0,-(sp)
 move.l a4,-(sp)
 pea 0x20000
 jsr _explosion_frame
 lea 16(sp),sp
 btst #7,31(a4)
 beq asm_cloud_done
 move.l asm_cloud,a0
 clr.b 2(a0)
 move.l (a5),a0
 moveq #0,d0
 move.w 38(a0),d0
 move.l d0,-(sp)
 move.w 28(a0),d0
 move.l d0,-(sp)
 pea asm_commander
 jsr _commander_settle
 lea 12(sp),sp
asm_cloud_done:
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
 move.b asm_equipment+3,asm_status+4
 pea asm_status
 jsr _energy_step
 addq.l #8,sp
 pea asm_status
 pea asm_ecm
 jsr _ecm_step
 addq.l #8,sp
 ; MA23 erases pulse lines when LASCT falls below 8.
 tst.b asm_laser+9
 beq asm_laser_end
 cmp.b #8,asm_laser
 bhs asm_laser_end
 bsr asm_erase_laser
asm_laser_end:
 ; Laser-counter adapter retains explicit C=1 MLOOP cadence (10,6,2,0).
 move.l #1,-(sp)
 pea asm_laser
 jsr _laser_tick
 addq.l #8,sp
 pea asm_equipment+2
 jsr _bomb_tick
 addq.l #4,sp
 pea asm_commander
 jsr _commander_tick
 addq.l #4,sp
 subq.b #1,asm_mcnt
 bsr asm_draw_dials
 addq.l #1,asm_frames
 bra asm_update_stats
asm_dock_commit:
 clr.b asm_travel+11
 clr.b asm_travel+13
 ; GOIN/RES4 state boundary. Tunnel/text and local scene are QL adapters.
 move.b #255,asm_status
 move.b #255,asm_status+1
 move.b #255,asm_status+2
 clr.b asm_status+3
 clr.w asm_ecm
 clr.b asm_laser
 clr.b asm_laser+1
 clr.b asm_laser+9
 clr.w asm_market_keys
 bsr asm_draw_dials
 bsr asm_clear_view
 bsr asm_market_page
 bra asm_update_stats
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
 clr.w asm_chart
 clr.w asm_shop
 clr.w asm_docked
 clr.w asm_market_keys
 clr.w asm_market_selection
 clr.w asm_market_result
 tst.w asm_keep_launch
 bne asm_market_kept
 move.b #22,_ship_fit
 move.b #15,_ship_fit+1
 clr.w _ship_fit+2
 pea asm_travel
 jsr _travel_init
 addq.l #4,sp
 clr.w asm_nav
 clr.w asm_nav_keys
 ; Initial Lave market, fluctuation0.
 clr.l -(sp)
 move.l #5,-(sp)
 pea asm_market
 jsr _market_init
 lea 12(sp),sp
asm_market_kept:
 ; Erase all old particle caches before clearing their authoritative state.
 lea asm_clouds,a4
 moveq #11,d7
asm_cloud_reset_loop:
 moveq #0,d0
 move.w 56(a4),d0
 move.l d0,-(sp)
 pea 58(a4)
 pea 0x20000
 jsr _cloud_xor
 lea 12(sp),sp
 lea 448(a4),a4
 dbra d7,asm_cloud_reset_loop
 lea asm_clouds,a0
 move.w #1343,d0
asm_cloud_zero:
 clr.l (a0)+
 dbra d0,asm_cloud_zero
 lea asm_cargo,a0
 moveq #21,d0
asm_cargo_zero:
 clr.b 0(a0,d0.w)
 dbra d0,asm_cargo_zero
 move.b #255,asm_equipment
 move.b #255,asm_equipment+1
 move.b #127,asm_equipment+2
 clr.l asm_losses
 clr.w asm_bomb_held
 clr.l asm_compass
 move.l #1000,asm_commander
 clr.l asm_commander+4
 clr.w asm_commander+8
 clr.l asm_scooped
 clr.l asm_debris
 clr.l asm_full
 clr.l asm_pods
 move.w #6,asm_spawn_kind
 clr.b _tactics_cnt
 lea asm_planet,a0
 moveq #35,d0
asm_planet_zero:
 clr.b 0(a0,d0.w)
 dbra d0,asm_planet_zero
 move.b #1,asm_planet+2
 move.b #4,asm_planet+8
 move.b #4,asm_player
 clr.b asm_player+1
 move.b #255,asm_player+2
 clr.b asm_player+3
 clr.w asm_ecm
 clr.l asm_launches
 clr.w asm_dead
 clr.l asm_ai_calls
 clr.l asm_ai_events
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
 cmp.w #2,asm_mode
 blo asm_encounter_ready
 move.w #-160,asm_ships+4
 clr.w asm_ships+6
 move.w #1400,asm_ships+8
 move.w #160,asm_ships+272+4
 clr.w asm_ships+272+6
 move.w #1400,asm_ships+272+8
 clr.w asm_ships+544+4
 move.w #-160,asm_ships+544+6
 move.w #1400,asm_ships+544+8
asm_encounter_ready:
 cmp.w #3,asm_mode
 bne asm_salvage_models_done
 tst.w asm_salvage
 beq asm_salvage_models_done
 lea _models,a0
 move.l 12(a0),asm_ships
 move.l 16(a0),asm_ships+272
asm_salvage_models_done:
 cmp.w #3,asm_mode
 bne asm_port_models_done
 cmp.w #2,asm_salvage
 bne asm_port_models_done
 lea _models,a0
 move.l 20(a0),asm_ships
 move.l 12(a0),asm_ships+272
 clr.w asm_ships+4
 clr.w asm_ships+6
 move.w #1200,asm_ships+8
 move.w #-500,asm_ships+272+4
 move.w #2600,asm_ships+272+8
 move.w #500,asm_ships+544+4
 move.w #2600,asm_ships+544+8
asm_port_models_done:
 bsr asm_reset_vectors
 cmp.w #3,asm_mode
 bne asm_port_pose_done
 cmp.w #2,asm_salvage
 bne asm_port_pose_done
 ; Test approach pose: original Coriolis, slot horizontal, nose toward player.
 clr.b asm_vectors+27
 clr.b asm_vectors+29
 clr.b asm_vectors+30
 clr.b asm_vectors+32
 clr.b asm_vectors+18
 clr.b asm_vectors+22
 move.b #96,asm_vectors+16
 move.b #224,asm_vectors+24
asm_port_pose_done:
 move.b #255,asm_status
 move.b #255,asm_status+1
 move.b #255,asm_status+2
 clr.b asm_status+3
 clr.b asm_status+4
 clr.b asm_mcnt
 bsr asm_draw_dials
 rts
 ; Fixed-slot lifetime rule: no missile/lock may retarget a recycled record.
asm_abort_target:
 movem.l d0-d3/a0-a2,-(sp)
 move.w asm_slot,d0
 cmp.b asm_player+2,d0
 bne asm_abort_followers
 move.b #255,asm_player+2
 clr.b asm_player+1
asm_abort_followers:
 add.b d0,d0
 or.b #128,d0
 lea asm_vectors,a0
 lea asm_ships,a1
 moveq #11,d3
asm_abort_loop:
 move.l (a1),a2
 move.l a2,d2
 beq asm_abort_next
 cmp.w #8,28(a2)
 bne asm_abort_next
 cmp.b 32(a0),d0
 bne asm_abort_next
 move.b 31(a0),d1
 and.b #160,d1
 bne asm_abort_next
 or.b #128,31(a0)
asm_abort_next:
 lea 272(a1),a1
 lea 36(a0),a0
 dbra d3,asm_abort_loop
 movem.l (sp)+,d0-d3/a0-a2
 rts
asm_drop_cargo:
 cmp.w #3,asm_mode
 bne asm_drop_done
 movem.l d2-d7/a2-a3,-(sp)
 move.l (a5),a0
 pea asm_laser+5
 moveq #0,d0
 move.w 36(a0),d0
 move.l d0,-(sp)
 move.w 28(a0),d0
 move.l d0,-(sp)
 jsr _debris_count
 lea 12(sp),sp
 move.w d0,d5
 beq asm_drop_restore
 move.w #8,asm_spawn_kind
asm_drop_loop:
 bsr asm_spawn_missile
 subq.w #1,d5
 bne asm_drop_loop
 move.w #6,asm_spawn_kind
asm_drop_restore:
 movem.l (sp)+,d2-d7/a2-a3
asm_drop_done:
 rts
asm_equipment_ouch:
 movem.l d2-d7/a2-a6,-(sp)
 ; Missing EXNO3 sound boundary: incoming DORND carry explicitly 1.
 move.l #1,-(sp)
 moveq #0,d0
 move.b asm_commander+7,d0
 move.l d0,-(sp)
 pea asm_laser+5
 pea asm_cargo
 jsr _equipment_damage
 lea 16(sp),sp
 tst.l d0
 beq asm_equipment_ouch_done
 addq.l #1,asm_losses
 subq.w #1,d0
 lea asm_commodity_names,a0
 cmp.w #17,d0
 blo asm_loss_name
 sub.w #17,d0
 lea asm_equipment_names,a0
asm_loss_name:
 lsl.w #4,d0
 adda.w d0,a0
 lea asm_loss_text,a1
 moveq #15,d0
asm_loss_copy:
 move.b (a0)+,(a1)+
 dbra d0,asm_loss_copy
 move.b #22,asm_commander+7
 move.b #3,asm_commander+8
asm_equipment_ouch_done:
 movem.l (sp)+,d2-d7/a2-a6
 rts
asm_contact:
 move.l (a5),a0
 cmp.w #7,28(a0)
 bne asm_contact_nonstation
 cmp.w #2,asm_salvage
 bne asm_contact_done
 cmp.w #3,asm_mode
 bne asm_contact_done
 moveq #0,d0
 move.b asm_controls+12,d0
 move.l d0,-(sp)
 move.l a4,-(sp)
 jsr _dock_check
 addq.l #8,sp
 tst.l d0
 beq asm_contact_done
 cmp.w #1,d0
 bne asm_dock_not_success
 move.w #1,asm_docked
 bra asm_contact_done
asm_dock_not_success:
 cmp.w #3,d0
 bne asm_dock_dent
 move.w #1,asm_dead
 bra asm_contact_done
asm_dock_dent:
 move.b #1,asm_controls+12
 move.b #1,asm_params+2
 clr.l -(sp)
 moveq #0,d0
 move.b 8(a4),d0
 move.l d0,-(sp)
 move.l #5,-(sp)
 pea asm_status
 jsr _player_damage
 lea 16(sp),sp
 cmp.w #2,d0
 bne asm_dock_dent_alive
 move.w #1,asm_dead
 bra asm_contact_done
asm_dock_dent_alive:
 cmp.w #1,d0
 bne asm_contact_done
 bsr asm_equipment_ouch
 bra asm_contact_done
asm_contact_nonstation:
 cmp.w #3,asm_mode
 bne asm_contact_done
 moveq #0,d0
 move.b _ship_fit,d0
 move.l d0,-(sp)
 pea asm_laser+5
 pea asm_cargo
 moveq #0,d0
 move.b asm_equipment+1,d0
 move.l d0,-(sp)
 move.l (a5),a0
 moveq #0,d0
 move.w 28(a0),d0
 move.l d0,-(sp)
 move.l a4,-(sp)
 jsr _scoop_step
 lea 24(sp),sp
 tst.l d0
 beq asm_contact_done
 cmp.w #3,d0
 beq asm_collision
 cmp.w #1,d0
 bne asm_contact_full
 addq.l #1,asm_scooped
 bra asm_contact_remove
asm_contact_full:
 addq.l #1,asm_full
asm_contact_remove:
 or.b #160,31(a4)
 bsr asm_abort_target
 bra asm_contact_done
asm_collision:
 moveq #0,d0
 move.b 35(a4),d0
 move.w d0,d1
 and.w #1,d1
 move.l d1,-(sp)
 moveq #0,d1
 move.b 8(a4),d1
 move.l d1,-(sp)
 lsr.w #1,d0
 or.w #128,d0
 move.l d0,-(sp)
 pea asm_status
 jsr _player_damage
 lea 16(sp),sp
 cmp.w #1,d0
 bne asm_collision_no_ouch
 bsr asm_equipment_ouch
 moveq #1,d0
asm_collision_no_ouch:
 cmp.w #2,d0
 bne asm_collision_alive
 move.w #1,asm_dead
asm_collision_alive:
 pea asm_laser+5
 move.l (a5),-(sp)
 move.l asm_cloud,-(sp)
 move.l a4,-(sp)
 jsr _explosion_start
 lea 16(sp),sp
 bsr asm_abort_target
asm_contact_done:
 rts
asm_player_input:
 cmp.w #3,asm_mode
 bne asm_player_input_done
 tst.b asm_mkeys+1
 beq asm_player_arm
 clr.b asm_player+1
 move.b #255,asm_player+2
asm_player_arm:
 tst.b asm_mkeys
 beq asm_player_fire
 tst.b asm_player
 beq asm_player_fire
 tst.b asm_player+2
 bpl asm_player_fire
 move.b #255,asm_player+1
asm_player_fire:
 tst.b asm_mkeys+2
 beq asm_player_input_done
 tst.b asm_player+2
 bmi asm_player_input_done
 moveq #0,d0
 move.b asm_player+2,d0
 mulu.w #36,d0
 lea asm_vectors,a0
 adda.l d0,a0
 move.b 31(a0),d0
 and.b #160,d0
 bne asm_player_unlock
 move.b #1,asm_player+3
 bsr asm_spawn_missile
 clr.b asm_player+3
 move.l a0,d0
 beq asm_player_input_done
 subq.b #1,asm_player
 moveq #0,d0
 move.b asm_player+2,d0
 move.w d0,d1
 mulu.w #272,d1
 lea asm_ships,a0
 adda.l d1,a0
 move.l (a0),a0
 moveq #0,d1
 move.w 28(a0),d1
 mulu.w #36,d0
 lea asm_vectors,a0
 adda.l d0,a0
 move.l asm_station,-(sp)
 move.l d1,-(sp)
 move.l a0,-(sp)
 jsr _ship_angry
 lea 12(sp),sp
asm_player_unlock:
 clr.b asm_player+1
 move.b #255,asm_player+2
asm_player_input_done:
 rts
asm_spawn_missile:
 cmp.w #3,asm_mode
 bne asm_spawn_return
 movem.l d2-d7/a2-a6,-(sp)
 lea asm_vectors+108,a2
 lea asm_ships+816,a3
 lea asm_clouds+1344,a6
 moveq #8,d6
asm_spawn_find:
 move.b 31(a2),d0
 and.b #160,d0
 cmp.b #160,d0
 bne asm_spawn_next
 tst.w 56(a6)
 bne asm_spawn_next
 ; An expired slot's line heap is already empty; retain its native cache header.
 lea _models,a0
 move.w asm_spawn_kind,d0
 lsl.w #2,d0
 move.l 0(a0,d0.w),(a3)
 tst.b asm_player+3
 beq asm_spawn_enemy
 moveq #0,d0
 move.b asm_controls+12,d0
 move.l d0,-(sp)
 moveq #0,d0
 move.b asm_player+2,d0
 move.l d0,-(sp)
 move.l a2,-(sp)
 jsr _player_missile_init
 lea 12(sp),sp
 bra asm_spawn_initialized
asm_spawn_enemy:
 move.l (a3),-(sp)
 move.l a2,-(sp)
 move.l a4,-(sp)
 jsr _spawn_child
 lea 12(sp),sp
asm_spawn_initialized:
 cmp.w #8,asm_spawn_kind
 bne asm_spawn_no_tumble
 pea asm_laser+5
 move.l a2,-(sp)
 jsr _cargo_tumble
 addq.l #8,sp
 addq.l #1,asm_debris
asm_spawn_no_tumble:
 cmp.w #8,asm_spawn_kind
 beq asm_count_spawned
 clr.w 14(a3)
 clr.b 2(a6)
 cmp.w #9,asm_spawn_kind
 bne asm_count_missile
 addq.l #1,asm_pods
 bra asm_count_spawned
asm_count_missile:
 addq.l #1,asm_launches
asm_count_spawned:
 move.l a2,a0
 bra asm_spawn_end
asm_spawn_next:
 lea 36(a2),a2
 lea 272(a3),a3
 lea 448(a6),a6
 dbra d6,asm_spawn_find
 cmp.w #8,asm_spawn_kind
 bne asm_spawn_failed
 ; SFS1 consumes its tumble RNG before NWSHP discovers a full pool.
 move.l #1,-(sp)
 pea asm_laser+5
 jsr _elite_random
 addq.l #8,sp
asm_spawn_failed:
 suba.l a0,a0
asm_spawn_end:
 movem.l (sp)+,d2-d7/a2-a6
asm_spawn_return:
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
 moveq #0,d0
 move.b asm_travel+9,d0
 move.l d0,-(sp)
 pea 0x20000
 jsr _dials_fuel
 addq.l #8,sp
 pea asm_player
 pea 0x20000
 jsr _missile_icons
 addq.l #8,sp
 clr.l -(sp)
 pea asm_compass
 pea asm_planet
 cmp.w #3,asm_mode
 bne asm_compass_target_done
 cmp.w #2,asm_salvage
 bne asm_compass_target_done
 move.l #asm_vectors,(sp)
 move.l #1,8(sp)
asm_compass_target_done:
 pea 0x20000
 jsr _compass_frame
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
 cmp.w #2,asm_mode
 blo asm_seed_passive
 ; Deterministic aggressive encounter initialization, not a universe spawner.
 move.b #240,32(a0)
 cmp.w #3,asm_mode
 bne asm_seed_passive
 cmp.w #9,d0
 blo asm_seed_unused
 move.w 30(a3),d2
 and.b #7,d2
 move.b d2,31(a0)
 bra asm_seed_passive
asm_seed_unused:
 move.b #160,31(a0)
 clr.b 32(a0)
asm_seed_passive:
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
 move.b asm_player,d0
 add.b #48,d0
 move.b d0,asm_msl_text+2
 move.b #45,asm_msl_text+4
 tst.b asm_player+1
 beq asm_hud_lock
 move.b #65,asm_msl_text+4
asm_hud_lock:
 move.b asm_player+2,d0
 bmi asm_hud_ready
 add.b #48,d0
 move.b d0,asm_msl_text+4
asm_hud_ready:
 lea asm_cargo,a0
 moveq #12,d1
 moveq #0,d0
asm_hud_cargo_sum:
 moveq #0,d2
 move.b (a0)+,d2
 add.w d2,d0
 dbra d1,asm_hud_cargo_sum
 divu.w #10,d0
 move.w d0,d2
 add.b #48,d2
 move.b d2,asm_cargo_text+2
 swap d0
 add.b #48,d0
 move.b d0,asm_cargo_text+3
 lea asm_fps_text,a4
 tst.b asm_commander+7
 beq asm_hud_message_done
 lea asm_bounty_message,a4
 cmp.b #3,asm_commander+8
 bne asm_hud_not_loss
 lea asm_loss_text,a4
 bra asm_hud_message_done
asm_hud_not_loss:
 cmp.b #2,asm_commander+8
 bne asm_hud_message_done
 lea asm_rank_message,a4
asm_hud_message_done:
 tst.b asm_travel+11
 beq asm_hud_no_hyper
 moveq #0,d0
 move.b asm_travel+11,d0
 lea asm_hyper_digits,a0
 moveq #2,d1
 bsr asm_decimal
 lea asm_hyper_line,a4
asm_hud_no_hyper:
 tst.w asm_dead
 beq asm_status_text
 lea asm_dead_text,a4
asm_status_text:
 move.w #248,d6
 bsr asm_text
fps_return:
 rts
; Native presentation adapter; source arithmetic/state lives in commander.s.
asm_dock_keys:
 moveq #0,d4
 moveq #1,d0
 bsr asm_keyrow
 btst #2,d0
 beq dock_key_down
 bset #0,d4
dock_key_down:
 btst #7,d0
 beq dock_key_buy
 bset #1,d4
dock_key_buy:
 moveq #2,d0
 bsr asm_keyrow
 btst #4,d0
 beq dock_key_sell
 bset #2,d4
dock_key_sell:
 moveq #3,d0
 bsr asm_keyrow
 btst #3,d0
 beq dock_key_launch
 bset #3,d4
dock_key_launch:
 moveq #4,d0
 bsr asm_keyrow
 btst #0,d0
 beq dock_key_shop
 bset #4,d4
dock_key_shop:
 moveq #6,d0
 bsr asm_keyrow
 btst #0,d0
 beq dock_key_load
 bset #5,d4
dock_key_load:
 moveq #5,d0
 bsr asm_keyrow
 btst #7,d0
 beq dock_key_edges
 bset #6,d4
dock_key_edges:
 move.w asm_market_keys,d0
 eor.w d4,d0
 and.w d4,d0
 move.w d4,asm_market_keys
 move.w d0,d4
 beq dock_keys_done
 btst #5,d4
 beq dock_not_shop_toggle
 eor.w #1,asm_shop
 clr.w asm_market_selection
 clr.w asm_market_result
 bra dock_page_refresh
dock_not_shop_toggle:
 btst #4,d4
 bne asm_launch
 btst #0,d4
 beq dock_select_down
 subq.w #1,asm_market_selection
 bpl dock_select_down
 move.w #16,asm_market_selection
 tst.w asm_shop
 beq dock_select_down
 move.w #11,asm_market_selection
dock_select_down:
 btst #1,d4
 beq dock_transaction
 addq.w #1,asm_market_selection
 moveq #17,d0
 tst.w asm_shop
 beq dock_select_limit
 moveq #12,d0
dock_select_limit:
 cmp.w asm_market_selection,d0
 bhi dock_transaction
 clr.w asm_market_selection
dock_transaction:
 tst.w asm_shop
 bne asm_shop_transaction
 move.w d4,d0
 and.w #12,d0
 beq dock_page_refresh
 moveq #0,d0
 btst #3,d4
 beq dock_trade_args
 moveq #1,d0
dock_trade_args:
 move.l d0,-(sp)
 moveq #0,d0
 move.w asm_market_selection,d0
 move.l d0,-(sp)
 pea asm_market
 pea asm_cargo
 pea asm_commander
 jsr _market_trade
 lea 20(sp),sp
 move.w d0,asm_market_result
dock_page_refresh:
 bsr asm_clear_view
 tst.w asm_shop
 beq dock_show_market
 bsr asm_shop_page
 bra dock_keys_done
dock_show_market:
 bsr asm_market_page
dock_keys_done:
 rts
asm_launch:
 ; Keep commander, equipment, cargo and remaining missiles across the local
 ; sortie reset. Market AVL persists; no free ammo/bomb/equipment replenishment.
 lea asm_commander,a0
 lea asm_keep,a1
 moveq #9,d0
launch_keep_cmd:
 move.b (a0)+,(a1)+
 dbra d0,launch_keep_cmd
 lea asm_cargo,a0
 moveq #21,d0
launch_keep_cargo:
 move.b (a0)+,(a1)+
 dbra d0,launch_keep_cargo
 move.b asm_player,(a1)
 bsr asm_clear_view
 lea asm_ships,a0
 lea asm_clouds,a1
 moveq #11,d0
launch_clear_caches:
 clr.w 12(a0)
 clr.w 56(a1)
 lea 272(a0),a0
 lea 448(a1),a1
 dbra d0,launch_clear_caches
 clr.b asm_sight
 clr.b asm_laser+9
 clr.w asm_page
 clr.w asm_paused
 move.w #1,asm_keep_launch
 bsr asm_setup
 clr.w asm_keep_launch
 lea asm_keep,a0
 lea asm_commander,a1
 moveq #9,d0
launch_restore_cmd:
 move.b (a0)+,(a1)+
 dbra d0,launch_restore_cmd
 lea asm_cargo,a1
 moveq #21,d0
launch_restore_cargo:
 move.b (a0)+,(a1)+
 dbra d0,launch_restore_cargo
 move.b (a0),asm_player
 clr.b asm_commander+7
 clr.b asm_commander+8
 tst.w asm_arriving
 bne launch_arrival_pose
 pea asm_cargo
 pea asm_commander
 jsr _launch_legal
 addq.l #8,sp
 ; Local launch fixture: station behind at -2048, facing the departing ship.
 clr.b asm_vectors+6
 move.b #8,asm_vectors+7
 move.b #128,asm_vectors+8
 move.b #96,asm_vectors+14
 move.b #96,asm_vectors+24
 move.w #-2048,asm_ships+8
launch_arrival_pose:
 bsr asm_draw_dials
 rts
asm_market_page:
 move.b asm_travel+22,d0
 add.b #48,d0
 move.b d0,asm_market_economy
 lea asm_market_title,a4
 moveq #0,d6
 bsr asm_text
 move.l asm_commander,d0
 lea asm_cash_digits,a0
 moveq #10,d1
 bsr asm_decimal
 move.b asm_cash_digits+9,asm_cash_digits+10
 move.b #46,asm_cash_digits+9
 lea asm_cash_line,a4
 moveq #10,d6
 bsr asm_text
 lea asm_market_header,a4
 moveq #22,d6
 bsr asm_text
 clr.w asm_page_item
 lea asm_commodity_names,a5
market_page_loop:
 lea asm_market_line+1,a0
 moveq #11,d0
market_copy_name:
 move.b (a5)+,(a0)+
 dbra d0,market_copy_name
 addq.l #4,a5
 move.w asm_page_item,d2
 lea asm_market,a0
 moveq #0,d0
 move.b 0(a0,d2.w),d0
 lsl.w #2,d0
 lea asm_price_digits,a0
 moveq #4,d1
 bsr asm_decimal
 move.b asm_price_digits+3,asm_price_digits+4
 move.b #46,asm_price_digits+3
 lea asm_market,a0
 moveq #0,d0
 move.b 17(a0,d2.w),d0
 lea asm_stock_digits,a0
 moveq #3,d1
 bsr asm_decimal
 lea asm_cargo,a0
 moveq #0,d0
 move.b 0(a0,d2.w),d0
 lea asm_held_digits,a0
 moveq #3,d1
 bsr asm_decimal
 move.b #32,asm_market_line
 cmp.w asm_market_selection,d2
 bne market_no_arrow
 move.b #62,asm_market_line
market_no_arrow:
 move.b #84,asm_market_unit
 move.b #32,asm_market_unit+1
 cmp.w #13,d2
 blo market_unit_done
 cmp.w #16,d2
 beq market_unit_done
 move.b #75,asm_market_unit
 move.b #71,asm_market_unit+1
 cmp.w #15,d2
 bne market_unit_done
 move.b #71,asm_market_unit
 move.b #32,asm_market_unit+1
market_unit_done:
 move.w d2,d6
 lsl.w #3,d6
 add.w #32,d6
 lea asm_market_line,a4
 bsr asm_text
 addq.w #1,asm_page_item
 cmp.w #17,asm_page_item
 blo market_page_loop
 lea asm_market_help,a4
 move.w #172,d6
 moveq #16,d7
 bsr asm_text_at
 move.w asm_market_result,d0
 lsl.w #2,d0
 lea asm_market_messages,a0
 move.l 0(a0,d0.w),a4
 move.w #184,d6
 bsr asm_text
 rts
asm_clear_view:
 move.l #0x20000,a0
 move.w #6143,d0
asm_clear_view_loop:
 clr.l (a0)+
 dbra d0,asm_clear_view_loop
 rts
asm_restore_view:
 lea asm_ships,a5
 lea asm_clouds,a6
 moveq #11,d7
asm_restore_loop:
 movem.l d7/a5-a6,-(sp)
 move.l a5,-(sp)
 pea 0x20000
 jsr _render_cache
 addq.l #8,sp
 moveq #0,d0
 move.w 56(a6),d0
 move.l d0,-(sp)
 pea 58(a6)
 pea 0x20000
 jsr _cloud_xor
 lea 12(sp),sp
 movem.l (sp)+,d7/a5-a6
 lea 272(a5),a5
 lea 448(a6),a6
 dbra d7,asm_restore_loop
 tst.b asm_sight
 beq asm_restore_laser
 pea 0x20000
 jsr _sight_xor
 addq.l #4,sp
asm_restore_laser:
 tst.b asm_laser+9
 beq asm_restore_done
 pea asm_laser
 pea 0x20000
 jsr _laser_xor
 addq.l #8,sp
asm_restore_done:
 rts
; Format unsigned 32-bit D0 as D1 fixed decimal digits at A0. No 68020 divide.
asm_decimal:
 movem.l d2-d5,-(sp)
 adda.w d1,a0
 subq.w #1,d1
asm_decimal_loop:
 move.l d0,d2
 swap d2
 and.l #65535,d2
 divu.w #10,d2
 move.w d2,d3
 clr.w d2
 move.w d0,d2
 divu.w #10,d2
 move.w d2,d0
 swap d0
 move.w d3,d0
 swap d0
 swap d2
 add.b #48,d2
 move.b d2,-(a0)
 dbra d1,asm_decimal_loop
 movem.l (sp)+,d2-d5
 rts
asm_commander_page:
 lea asm_page_title,a4
 moveq #4,d6
 bsr asm_text
 move.l asm_commander,d0
 lea asm_cash_digits,a0
 moveq #10,d1
 bsr asm_decimal
 ; Ten decimal tenths digits -> nine integral digits, dot, final digit.
 move.b asm_cash_digits+9,asm_cash_digits+10
 move.b #46,asm_cash_digits+9
 lea asm_cash_digits,a0
 moveq #7,d0
asm_cash_trim:
 cmp.b #48,(a0)
 bne asm_cash_trim_done
 move.b #32,(a0)+
 dbra d0,asm_cash_trim
asm_cash_trim_done:
 lea asm_cash_line,a4
 moveq #20,d6
 bsr asm_text
 pea asm_commander
 jsr _commander_rank
 addq.l #4,sp
 subq.w #1,d0
 lsl.w #2,d0
 lea asm_rank_names,a0
 move.l 0(a0,d0.w),a4
 moveq #36,d6
 bsr asm_text
 lea asm_clean,a4
 tst.b asm_commander+6
 beq asm_page_legal
 lea asm_offender,a4
 cmp.b #50,asm_commander+6
 blo asm_page_legal
 lea asm_fugitive,a4
asm_page_legal:
 moveq #48,d6
 bsr asm_text
 moveq #0,d0
 move.b asm_commander+5,d0
 lsl.w #8,d0
 move.b asm_commander+4,d0
 lea asm_tally_digits,a0
 moveq #5,d1
 bsr asm_decimal
 lea asm_tally_line,a4
 moveq #60,d6
 bsr asm_text
 lea asm_commodity_names,a5
 lea asm_cargo,a6
 clr.w asm_page_item
asm_page_cargo_loop:
 lea asm_cargo_line,a0
 moveq #11,d0
asm_page_copy_name:
 move.b (a5)+,(a0)+
 dbra d0,asm_page_copy_name
 addq.l #4,a5
 move.b #32,(a0)+
 moveq #0,d0
 move.b (a6)+,d0
 moveq #3,d1
 bsr asm_decimal
 move.b #84,asm_cargo_unit
 move.b #32,asm_cargo_unit+1
 cmp.w #16,asm_page_item
 beq asm_page_cargo_unit
 cmp.w #13,asm_page_item
 blo asm_page_cargo_unit
 move.b #75,asm_cargo_unit
 move.b #71,asm_cargo_unit+1
 cmp.w #15,asm_page_item
 bne asm_page_cargo_unit
 move.b #71,asm_cargo_unit
 move.b #32,asm_cargo_unit+1
asm_page_cargo_unit:
 moveq #0,d6
 move.w asm_page_item,d6
 divu.w #9,d6
 move.w d6,d7
 mulu.w #128,d7
 addq.w #8,d7
 swap d6
 mulu.w #12,d6
 add.w #72,d6
 lea asm_cargo_line,a4
 bsr asm_text_at
 addq.w #1,asm_page_item
 cmp.w #17,asm_page_item
 blo asm_page_cargo_loop
 lea asm_equipment,a0
 lea asm_equipment_line,a1
 lea asm_equipment_fields,a2
 moveq #3,d1
asm_page_equipment_loop:
 moveq #0,d0
 move.b (a2)+,d0
 move.b #78,0(a1,d0.w)
 tst.b (a0)+
 beq asm_page_equipment_next
 move.b #89,0(a1,d0.w)
asm_page_equipment_next:
 dbra d1,asm_page_equipment_loop
 lea asm_equipment_line,a4
 move.w #184,d6
 bsr asm_text
 rts

; Original dashboard is copied by scanner_reset during scene setup.
asm_labels:
 rts
asm_text:
 move.w #32,d7
asm_text_at:
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

.sect .bss
.align 2
asm_clouds: .space 5376

.sect .data
.align 2
asm_page_item: .data2 0
asm_page_title: .ascii "COMMANDER / CARGO - 6 TO RETURN\0"
asm_cash_line: .ascii "CASH "
asm_cash_digits: .ascii "000000000.0 CR\0"
asm_tally_line: .ascii "KILLS "
asm_tally_digits: .ascii "00000  /  HOLD 20 T\0"
asm_cargo_line: .ascii "             000 "
asm_cargo_unit: .ascii "T \0"
asm_clean: .ascii "LEGAL: CLEAN\0"
asm_offender: .ascii "LEGAL: OFFENDER\0"
asm_fugitive: .ascii "LEGAL: FUGITIVE\0"
asm_bounty_message: .ascii "BOUNTY AWARDED - 6 COMMANDER\0"
asm_rank_message: .ascii "RIGHT ON COMMANDER!\0"
.align 2
asm_rank_names: .data4 asm_rank_0,asm_rank_1,asm_rank_2,asm_rank_3,asm_rank_4,asm_rank_5,asm_rank_6,asm_rank_7,asm_rank_8
asm_rank_0: .ascii "RATING: HARMLESS\0"
asm_rank_1: .ascii "RATING: MOSTLY HARMLESS\0"
asm_rank_2: .ascii "RATING: POOR\0"
asm_rank_3: .ascii "RATING: AVERAGE\0"
asm_rank_4: .ascii "RATING: ABOVE AVERAGE\0"
asm_rank_5: .ascii "RATING: COMPETENT\0"
asm_rank_6: .ascii "RATING: DANGEROUS\0"
asm_rank_7: .ascii "RATING: DEADLY\0"
asm_rank_8: .ascii "RATING: ELITE\0"
asm_commodity_names:
 .ascii "FOOD            "
 .ascii "TEXTILES        "
 .ascii "RADIOACTIVES    "
 .ascii "SLAVES          "
 .ascii "LIQUOR/WINES    "
 .ascii "LUXURIES        "
 .ascii "NARCOTICS       "
 .ascii "COMPUTERS       "
 .ascii "MACHINERY       "
 .ascii "ALLOYS          "
 .ascii "FIREARMS        "
 .ascii "FURS            "
 .ascii "MINERALS        "
 .ascii "GOLD            "
 .ascii "PLATINUM        "
 .ascii "GEM-STONES      "
 .ascii "ALIEN ITEMS     "

.align 2

.sect .data
asm_equipment_line: .ascii "ECM N SCOOPS N BOMB N UNIT N\0"
asm_equipment_fields: .data1 4,13,20,27
asm_equipment_names:
 .ascii "ECM SYSTEM      "
 .ascii "FUEL SCOOPS     "
 .ascii "ENERGY BOMB     "
 .ascii "ENERGY UNIT     "
 .ascii "DOCK COMPUTER   "
asm_loss_text: .ascii "                DESTROYED\0"
.align 2

.sect .data
asm_market_title: .ascii "DOCKED / LOCAL MARKET / ECONOMY "
asm_market_economy: .ascii "5\0"
asm_market_header: .ascii " ITEM         PRICE STOCK HOLD\0"
asm_market_line: .ascii "              "
asm_price_digits: .ascii "000.0 "
asm_stock_digits: .ascii "000 "
asm_held_digits: .ascii "000 "
asm_market_unit: .ascii "T \0"
asm_market_help: .ascii "UP/DN  B BUY1  S SELLALL  L LAUNCH\0"
.align 2
asm_market_messages: .data4 market_ok,market_stock,market_hold,market_cash
market_ok: .ascii "READY\0"
market_stock: .ascii "NO STOCK\0"
market_hold: .ascii "HOLD FULL\0"
market_cash: .ascii "NOT ENOUGH CASH\0"
.align 2

.sect .text
; Navigation UI owns keys only while open. 9 toggles, H/G starts from flight.
asm_navigation_keys:
 moveq #0,d4
 moveq #5,d0
 bsr asm_keyrow
 btst #4,d0
 beq nav_nine
 bset #3,d4
nav_nine:
 btst #0,d0
 beq nav_h
 bset #0,d4
nav_h:
 moveq #4,d0
 bsr asm_keyrow
 btst #2,d0
 beq nav_g
 bset #1,d4
nav_g:
 moveq #3,d0
 bsr asm_keyrow
 btst #2,d0
 beq nav_gal_key
 bset #8,d4
nav_gal_key:
 btst #6,d0
 beq nav_r
 bset #2,d4
nav_r:
nav_arrows:
 tst.w asm_nav
 beq nav_edges
 moveq #1,d0
 bsr asm_keyrow
 btst #2,d0
 beq nav_down
 bset #4,d4
nav_down:
 btst #7,d0
 beq nav_left
 bset #5,d4
nav_left:
 btst #1,d0
 beq nav_right
 bset #6,d4
nav_right:
 btst #4,d0
 beq nav_chart_key
 bset #7,d4
nav_chart_key:
 moveq #2,d0
 bsr asm_keyrow
 btst #3,d0
 beq nav_edges
 bset #9,d4
nav_edges:
 move.w asm_nav_keys,d0
 eor.w d4,d0
 and.w d4,d0
 move.w d4,asm_nav_keys
 move.w d0,d4
 btst #8,d4
 beq nav_no_escape
 tst.w asm_page
 bne nav_no_escape
 tst.w asm_docked
 bne nav_no_escape
 tst.w asm_dead
 bne nav_no_escape
 pea asm_travel
 pea asm_cargo
 pea asm_commander
 jsr _escape_commander
 lea 12(sp),sp
 tst.w d0
 beq nav_no_escape
 clr.w asm_nav
 move.w #3,asm_mode
 move.w #2,asm_salvage
 move.w #12,asm_count
 bsr asm_launch
 move.w #1,asm_docked
 bsr asm_clear_view
 bsr asm_market_page
 bra nav_consumed
nav_no_escape:
 ; Countdown is live flight, selection remains frozen until arrival.
 tst.b asm_travel+11
 bne nav_not_consumed
 tst.w asm_page
 bne nav_not_consumed
 btst #0,d4
 beq nav_actions
 eor.w #1,asm_nav
 bsr asm_clear_view
 tst.w asm_nav
 bne nav_redraw
 tst.w asm_docked
 beq nav_close_flight
 clr.w asm_shop
 bsr asm_market_page
 bra nav_consumed
nav_close_flight:
 bsr asm_restore_view
 bra nav_consumed
nav_actions:
 tst.w asm_dead
 bne nav_no_start
 btst #1,d4
 bne nav_start_normal
 btst #2,d4
 bne nav_start_galaxy
nav_no_start:
 tst.w asm_nav
 beq nav_not_consumed
 btst #3,d4
 beq nav_select
 tst.w asm_docked
 beq nav_consumed
 pea asm_commander
 pea asm_travel
 jsr _travel_refuel
 addq.l #8,sp
 move.b d0,asm_travel+15
 beq nav_refueled
 move.b #6,asm_travel+15
 bra nav_redraw
nav_refueled:
 clr.b asm_mcnt
 bsr asm_draw_dials
 bra nav_redraw
nav_select:
 btst #9,d4
 beq nav_select_system
 eor.w #1,asm_chart
 bra nav_redraw
nav_select_system:
 tst.w d4
 beq nav_consumed
 move.w #1,asm_nav_step
 btst #4,d4
 bne nav_decrement
 btst #6,d4
 beq nav_direction_ready
nav_decrement:
 move.w #-1,asm_nav_step
nav_direction_ready:
 move.w #255,asm_nav_tries
nav_find:
 clr.b asm_travel+15
 moveq #0,d0
 move.b asm_travel+8,d0
 add.w asm_nav_step,d0
 and.w #255,d0
 move.l d0,-(sp)
 pea asm_travel
 jsr _travel_select
 addq.l #8,sp
 move.w asm_nav_keys,d0
 and.w #192,d0
 beq nav_redraw
 pea asm_travel+40
 pea asm_travel+16
 jsr _galaxy_distance
 addq.l #8,sp
 tst.w d0
 beq nav_find_next
 moveq #0,d1
 move.b asm_travel+9,d1
 cmp.w d1,d0
 bls nav_redraw
nav_find_next:
 subq.w #1,asm_nav_tries
 bpl nav_find
 bra nav_redraw
nav_start_normal:
 moveq #0,d0
 bra nav_start
nav_start_galaxy:
 moveq #1,d0
nav_start:
 moveq #0,d1
 move.w asm_docked,d1
 move.l d1,-(sp)
 move.l d0,-(sp)
 pea asm_travel
 jsr _travel_start
 lea 12(sp),sp
 tst.w d0
 bne nav_start_failed
 tst.w asm_nav
 beq nav_consumed
 clr.w asm_nav
 bsr asm_clear_view
 bsr asm_restore_view
 bra nav_consumed
nav_start_failed:
 move.w #1,asm_nav
nav_redraw:
 bsr asm_clear_view
 tst.w asm_chart
 beq nav_text_page
 bsr asm_chart_page
 bra nav_consumed
nav_text_page:
 bsr asm_nav_page
nav_consumed:
 moveq #1,d0
 rts
nav_not_consumed:
 moveq #0,d0
 rts
asm_arrival:
 moveq #0,d0
 move.b asm_commander+6,d0
 cmp.b #2,asm_travel+13
 bne solar_keep_carry
 moveq #0,d0
solar_keep_carry:
 move.w d0,asm_solar_legal
 move.w #1,asm_arriving
 ; GVL's DORND boundary uses explicit carry0; sound RNG is not reproduced.
 clr.l -(sp)
 pea asm_laser+5
 jsr _elite_random
 addq.l #8,sp
 and.l #255,d0
 lea asm_laser+5,a0
 lea asm_arrival_rng,a1
 moveq #3,d1
arrival_keep_rng:
 move.b (a0)+,(a1)+
 dbra d1,arrival_keep_rng
 move.l d0,-(sp)
 pea asm_commander
 pea asm_travel
 jsr _travel_arrive
 lea 12(sp),sp
 move.w #3,asm_mode
 move.w #2,asm_salvage
 move.w #12,asm_count
 move.w #1,asm_arriving
 bsr asm_launch
 clr.w asm_arriving
 moveq #0,d0
 move.w asm_solar_legal,d0
 move.l d0,-(sp)
 move.b asm_travel+24,d0
 move.l d0,-(sp)
 pea asm_travel+16
 pea asm_planet
 jsr _solar_planet
 lea 16(sp),sp
 lea asm_arrival_rng,a0
 lea asm_laser+5,a1
 moveq #3,d1
arrival_restore_rng:
 move.b (a0)+,(a1)+
 dbra d1,arrival_restore_rng
 moveq #0,d0
 move.b asm_travel+14,d0
 move.l d0,-(sp)
 move.b asm_travel+22,d0
 move.l d0,-(sp)
 pea asm_market
 jsr _market_init
 lea 12(sp),sp
 bra asm_update_stats
asm_nav_page:
 moveq #0,d0
 move.b asm_travel+6,d0
 addq.w #1,d0
 lea nav_gal_digit,a0
 moveq #1,d1
 bsr asm_decimal
 lea nav_title,a4
 moveq #4,d6
 bsr asm_text
 lea nav_current,a4
 moveq #22,d6
 bsr asm_text
 lea asm_travel+25,a4
 moveq #34,d6
 bsr asm_text
 lea nav_target,a4
 moveq #52,d6
 bsr asm_text
 lea asm_travel+49,a4
 moveq #64,d6
 bsr asm_text
 moveq #0,d0
 move.b asm_travel+8,d0
 lea nav_index,a0
 moveq #3,d1
 bsr asm_decimal
 moveq #0,d0
 move.b asm_travel+46,d0
 lea nav_econ,a0
 moveq #1,d1
 bsr asm_decimal
 moveq #0,d0
 move.b asm_travel+47,d0
 lea nav_gov,a0
 moveq #1,d1
 bsr asm_decimal
 moveq #0,d0
 move.b asm_travel+48,d0
 addq.w #1,d0
 lea nav_tech,a0
 moveq #2,d1
 bsr asm_decimal
 lea nav_details,a4
 moveq #80,d6
 bsr asm_text
 pea asm_travel+40
 pea asm_travel+16
 jsr _galaxy_distance
 addq.l #8,sp
 lea nav_distance,a0
 moveq #4,d1
 bsr asm_decimal
 move.b nav_distance+3,nav_distance+4
 move.b #46,nav_distance+3
 moveq #0,d0
 move.b asm_travel+9,d0
 lea nav_fuel,a0
 moveq #2,d1
 bsr asm_decimal
 move.b nav_fuel+1,nav_fuel+2
 move.b #46,nav_fuel+1
 move.b #78,nav_drive
 tst.b asm_travel+10
 beq nav_no_drive
 move.b #89,nav_drive
nav_no_drive:
 lea nav_range,a4
 moveq #96,d6
 bsr asm_text
 lea nav_help1,a4
 moveq #116,d6
 bsr asm_text
 lea nav_help2,a4
 move.w #128,d6
 bsr asm_text
 lea nav_help3,a4
 move.w #140,d6
 bsr asm_text
 lea nav_help4,a4
 move.w #152,d6
 bsr asm_text
 moveq #0,d0
 move.b asm_travel+15,d0
 lsl.w #2,d0
 lea nav_errors,a0
 move.l 0(a0,d0.w),a4
 move.w #176,d6
 bsr asm_text
 rts
.sect .data
asm_hyper_line: .ascii "HYPERSPACE "
asm_hyper_digits: .ascii "00 - HOLD COURSE\0"
nav_title: .ascii "NAVIGATION / GALAXY "
nav_gal_digit: .ascii "1\0"
nav_current: .ascii "CURRENT SYSTEM\0"
nav_target: .ascii "DESTINATION\0"
nav_details: .ascii "ID "
nav_index: .ascii "000  ECON "
nav_econ: .ascii "0 GOV "
nav_gov: .ascii "0 TECH "
nav_tech: .ascii "00\0"
nav_range: .ascii "DIST "
nav_distance: .ascii "000.0 FUEL "
nav_fuel: .ascii "7.0 GDRV "
nav_drive: .ascii "Y\0"
nav_help1: .ascii "LEFT/RIGHT NEXT WITHIN FUEL\0"
nav_help2: .ascii "UP/DN ALL SYSTEMS  C CHART\0"
nav_help3: .ascii "H HYPERSPACE  G NEXT GALAXY\0"
nav_help4: .ascii "DOCKED R REFUEL  9 CLOSE\0"
 .align 2
nav_errors: .data4 nav_ok,nav_dock,nav_busy,nav_zero,nav_far,nav_no,nav_cash
nav_ok: .ascii "READY - REFUEL COST 0.2 CR/UNIT\0"
nav_dock: .ascii "LAUNCH BEFORE HYPERSPACE\0"
nav_busy: .ascii "COUNTDOWN IN PROGRESS\0"
nav_zero: .ascii "SELECT ANOTHER SYSTEM\0"
nav_far: .ascii "HYPERSPACE RANGE?\0"
nav_no: .ascii "NO GALACTIC HYPERDRIVE\0"
nav_cash: .ascii "NOT ENOUGH CASH FOR FUEL\0"
.align 2

.sect .text
asm_shop_transaction:
 btst #3,d4
 bne asm_save_commander
 btst #6,d4
 bne asm_load_commander
 btst #2,d4
 beq dock_page_refresh
 moveq #0,d0
 move.w asm_market_selection,d0
 move.l d0,-(sp)
 pea asm_travel
 pea asm_player
 pea asm_cargo
 pea asm_commander
 jsr _shop_buy
 lea 20(sp),sp
 move.w d0,asm_market_result
 bne shop_no_fuel_reset
 tst.w asm_market_selection
 bne shop_no_fuel_reset
 clr.b asm_mcnt
shop_no_fuel_reset:
 bsr asm_draw_dials
 bra dock_page_refresh
asm_shop_page:
 lea shop_title,a4
 moveq #0,d6
 bsr asm_text
 move.l asm_commander,d0
 lea asm_cash_digits,a0
 moveq #10,d1
 bsr asm_decimal
 move.b asm_cash_digits+9,asm_cash_digits+10
 move.b #46,asm_cash_digits+9
 lea asm_cash_line,a4
 moveq #10,d6
 bsr asm_text
 clr.w asm_page_item
shop_page_loop:
 move.w asm_page_item,d0
 lsl.w #2,d0
 lea shop_names,a0
 move.l 0(a0,d0.w),a4
 move.w asm_page_item,d6
 mulu.w #12,d6
 add.w #28,d6
 bsr asm_text
 cmp.w asm_market_selection,d0
 ; Text routines clobber data registers, so compare authoritative indices.
 move.w asm_page_item,d0
 cmp.w asm_market_selection,d0
 bne shop_page_next
 lea shop_arrow,a4
 move.w asm_page_item,d6
 mulu.w #12,d6
 add.w #28,d6
 moveq #24,d7
 bsr asm_text_at
shop_page_next:
 addq.w #1,asm_page_item
 cmp.w #12,asm_page_item
 blo shop_page_loop
 lea shop_help,a4
 move.w #174,d6
 bsr asm_text
 move.w asm_market_result,d0
 lsl.w #2,d0
 lea shop_messages,a0
 move.l 0(a0,d0.w),a4
 move.w #184,d6
 bsr asm_text
 rts
.sect .data
shop_title: .ascii "EQUIP SHIP / 8 RETURNS TO MARKET\0"
shop_arrow: .ascii ">\0"
shop_help: .ascii "B BUY S SAVE O LOAD 8 BACK L GO\0"
.align 2
shop_names: .data4 shop0,shop1,shop2,shop3,shop4,shop5,shop6,shop7,shop8,shop9,shop10,shop11
shop0: .ascii "FUEL              0.2 CR/UNIT\0"
shop1: .ascii "MISSILE                30 CR\0"
shop2: .ascii "LARGE CARGO BAY       400 CR\0"
shop3: .ascii "ECM SYSTEM            600 CR\0"
shop4: .ascii "FORWARD PULSE LASER   400 CR\0"
shop5: .ascii "FORWARD BEAM LASER   1000 CR\0"
shop6: .ascii "FUEL SCOOPS           525 CR\0"
shop7: .ascii "ESCAPE POD           1000 CR\0"
shop8: .ascii "ENERGY BOMB           900 CR\0"
shop9: .ascii "ENERGY UNIT          1500 CR\0"
shop10: .ascii "DOCK COMPUTER    UNAVAILABLE\0"
shop11: .ascii "GALACTIC DRIVE      5000 CR\0"
.align 2
shop_messages: .data4 shop_ok,shop_cash,shop_present,shop_tech,shop_absent,save_ok,load_ok,save_error,load_error
shop_ok: .ascii "READY / PRICES SUBJECT TO TECH\0"
shop_cash: .ascii "NOT ENOUGH CASH\0"
shop_present: .ascii "ALREADY PRESENT / MISSILES FULL\0"
shop_tech: .ascii "NOT AVAILABLE AT THIS TECH LEVEL\0"
shop_absent: .ascii "NOT IMPLEMENTED - NO CHARGE\0"
.align 2

.sect .text
asm_save_commander:
 lea save_buffer,a0
 moveq #35,d0
save_zero:
 clr.l (a0)+
 dbra d0,save_zero
 move.l #0x45514131,save_buffer
 moveq #0,d6
 bsr save_copy
 bsr save_checksum
 move.l d0,save_buffer+4
 move.l #1,-(sp)
 pea save_buffer
 jsr _commander_io
 addq.l #8,sp
 move.w #5,asm_market_result
 tst.l d0
 beq dock_page_refresh
 move.w #7,asm_market_result
 bra dock_page_refresh
asm_load_commander:
 clr.l -(sp)
 pea save_buffer
 jsr _commander_io
 addq.l #8,sp
 tst.l d0
 bne save_bad_load
 cmp.l #0x45514131,save_buffer
 bne save_bad_load
 bsr save_checksum
 cmp.l save_buffer+4,d0
 bne save_bad_load
 ; Payload: commander10,cargo22,travel64,market34,missile1,fit2.
 cmp.b #7,save_buffer+46
 bhi save_bad_load
 cmp.b #70,save_buffer+49
 bhi save_bad_load
 tst.b save_buffer+51
 bne save_bad_load
 cmp.b #4,save_buffer+138
 bhi save_bad_load
 move.b save_buffer+139,d0
 cmp.b #22,d0
 beq save_fit_valid
 cmp.b #37,d0
 bne save_bad_load
save_fit_valid:
 move.b save_buffer+140,d0
 beq save_laser_valid
 cmp.b #15,d0
 beq save_laser_valid
 cmp.b #143,d0
 bne save_bad_load
save_laser_valid:
 moveq #1,d6
 bsr save_copy
 clr.b asm_commander+7
 clr.b asm_commander+8
 clr.b asm_player+1
 move.b #255,asm_player+2
 bsr asm_draw_dials
 move.w #6,asm_market_result
 bra dock_page_refresh
save_bad_load:
 move.w #8,asm_market_result
 bra dock_page_refresh
save_copy:
 lea save_parts,a2
 lea save_buffer+8,a1
 moveq #5,d7
save_part:
 move.l (a2)+,a0
 move.w (a2)+,d0
 subq.w #1,d0
save_byte:
 tst.w d6
 bne save_restore_byte
 move.b (a0)+,(a1)+
 bra save_byte_done
save_restore_byte:
 move.b (a1)+,(a0)+
save_byte_done:
 dbra d0,save_byte
 dbra d7,save_part
 rts
save_checksum:
 lea save_buffer+8,a0
 moveq #0,d0
 move.w #135,d1
save_sum:
 rol.l #1,d0
 moveq #0,d2
 move.b (a0)+,d2
 add.l d2,d0
 dbra d1,save_sum
 rts
.sect .data
.align 2
save_parts: .data4 asm_commander
 .data2 10
 .data4 asm_cargo
 .data2 22
 .data4 asm_travel
 .data2 64
 .data4 asm_market
 .data2 34
 .data4 asm_player
 .data2 1
 .data4 _ship_fit
 .data2 4
save_buffer: .space 144
save_ok: .ascii "SAVED WIN1_ELITESAVE\0"
load_ok: .ascii "COMMANDER LOADED\0"
save_error: .ascii "SAVE FAILED - CHECK WIN1\0"
load_error: .ascii "LOAD FAILED - STATE UNCHANGED\0"
.align 2

.sect .text
asm_chart_page:
 lea chart_title,a4
 moveq #4,d6
 bsr asm_text
 lea asm_travel+25,a4
 moveq #18,d6
 bsr asm_text
 lea asm_travel+49,a4
 moveq #18,d6
 move.w #160,d7
 bsr asm_text_at
 pea asm_travel
 pea 0x20000
 jsr _galaxy_chart
 addq.l #8,sp
 lea chart_help,a4
 move.w #170,d6
 bsr asm_text
 lea chart_help2,a4
 move.w #182,d6
 bsr asm_text
 rts
.sect .data
chart_title: .ascii "GALACTIC CHART / CURRENT > TARGET\0"
chart_help: .ascii "ARROWS SELECT  H JUMP  G GALAXY\0"
chart_help2: .ascii "C DATA  9 CLOSE\0"
.align 2
