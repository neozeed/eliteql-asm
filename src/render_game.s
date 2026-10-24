; Generated game renderer; benchmarks retain render.s.
; Electron LL9-stage renderer, adapted to native 68000 signed words.
; Preserves original blueprints, vertex/face associations, distance thresholds,
; face-plane culling and per-ship line-heap erase/draw. Arithmetic/raster rounding
; is native and is NOT a bit-exact translation of the 6502 routines.
; C shell supplies model, position and a demo orientation index only.
.sect .text
.sect .rom
.sect .data
.sect .bss
.sect .text
.globl _render_ship
.globl _render_exploding
.globl _render_inwk
.globl _effect_visible
.globl _effect_vertices
.globl _projected_total
.globl _line_total
.extern clip_segment
.extern xor_segment
_render_ship:
 movem.l d2-d7/a2-a6,-(sp)
 move.l 48(sp),a6
 move.l 52(sp),a5
 clr.w _effect_visible
 ; LL155: redraw old cached segments with XOR to remove this ship.
 bsr draw_cache
 clr.w 12(a5)
 tst.w 14(a5)
 bne render_return
 move.l (a5),d0
 beq render_return
 move.l d0,a4
 ; LL10: reject ship behind viewer or outside the original 45-degree cone.
 move.w 8(a5),d2
 cmp.w #4,d2
 blt render_return
 move.w 4(a5),d0
 bpl origin_x_positive
 neg.w d0
origin_x_positive:
 cmp.w d2,d0
 bge render_return
 move.w 6(a5),d0
 bpl origin_y_positive
 neg.w d0
origin_y_positive:
 cmp.w d2,d0
 bge render_return
 ; XX4 = min(31,z/128). Far objects become small marks, as SHPPT does.
 move.w d2,d0
 lsr.w #7,d0
 cmp.w #31,d0
 ble distance_ready
 moveq #31,d0
 distance_ready:
 move.w d0,distance_level
 move.w d2,d0
 lsr.w #8,d0
 cmp.w #16,d0
 blt full_ship
 cmp.w 6(a4),d0
 bgt distant_ship
full_ship:
 move.l _live_matrix,d0
 beq demo_matrix
 move.l d0,a3
 bra matrix_ready
demo_matrix:
 ; ELITEASM supplies original motion matrices; no demo rotation fallback.
 bra render_return
matrix_ready:
 ; LL90: reduce centre magnitudes until Z fits a byte. This bounds the
 ; local-camera words even when a distant station is near a field-of-view edge.
 move.w 4(a5),d0
 move.w 6(a5),d1
 move.w 8(a5),d2
 moveq #0,d3
camera_reduce:
 cmp.w #255,d2
 ble camera_reduced
 lsr.w #1,d2
 tst.w d0
 bpl camera_reduce_x
 addq.w #1,d0
camera_reduce_x:
 asr.w #1,d0
 tst.w d1
 bpl camera_reduce_y
 addq.w #1,d1
camera_reduce_y:
 asr.w #1,d1
 addq.w #1,d3
 bra camera_reduce
camera_reduced:
 move.w d0,camera_position
 move.w d1,camera_position+2
 move.w d2,camera_position+4
 move.w d3,camera_shift
 ; LL17/EE29: express camera-to-ship centre in the model's local axes.
 move.w camera_position,d0
 muls.w 0(a3),d0
 move.w camera_position+2,d1
 muls.w 6(a3),d1
 add.l d1,d0
 move.w camera_position+4,d1
 muls.w 12(a3),d1
 add.l d1,d0
 asr.l #8,d0
 move.w d0,camera_local+0
 move.w camera_position,d0
 muls.w 2(a3),d0
 move.w camera_position+2,d1
 muls.w 8(a3),d1
 add.l d1,d0
 move.w camera_position+4,d1
 muls.w 14(a3),d1
 add.l d1,d0
 asr.l #8,d0
 move.w d0,camera_local+2
 move.w camera_position,d0
 muls.w 4(a3),d0
 move.w camera_position+2,d1
 muls.w 10(a3),d1
 add.l d1,d0
 move.w camera_position+4,d1
 muls.w 16(a3),d1
 add.l d1,d0
 asr.l #8,d0
 move.w d0,camera_local+4
 clr.l visible_faces
 clr.l visible_faces+4
 clr.l visible_faces+8
 clr.l visible_faces+12
 move.b #1,visible_faces+15
 move.l 18(a4),a2
 moveq #0,d7
face_loop:
 cmp.w 4(a4),d7
 bge vertices_begin
 move.w 6(a2),d0
 cmp.w distance_level,d0
 blt face_visible
 ; LL89: N dot (camera_local + N / normal_scale) < 0.
 ; N squared / normal_scale was expanded once by the data extractor.
 move.w (a2),d0
 muls.w camera_local,d0
 move.w 2(a2),d1
 muls.w camera_local+2,d1
 add.l d1,d0
 move.w 4(a2),d1
 muls.w camera_local+4,d1
 add.l d1,d0
 move.l 8(a2),d1
 move.w camera_shift,d2
 lsr.l d2,d1
 add.l d1,d0
 bpl face_next
face_visible:
 lea visible_faces,a0
 move.b #1,0(a0,d7.w)
face_next:
 lea 12(a2),a2
 addq.w #1,d7
 bra face_loop
vertices_begin:
 lea vertex_valid,a0
 moveq #7,d0
vertices_clear:
 clr.l (a0)+
 dbra d0,vertices_clear
 move.l 10(a4),a2
 moveq #0,d7
vertex_loop:
 cmp.w (a4),d7
 bge edges_begin
 tst.w _render_exploding
 bne vertex_project
 ; LL48: vertex LOD and its four associated faces gate projection work.
 move.w 6(a2),d0
 cmp.w distance_level,d0
 blt vertex_next
 lea visible_faces,a0
 moveq #0,d0
 move.b 8(a2),d0
 tst.b 0(a0,d0.w)
 bne vertex_project
 move.b 9(a2),d0
 tst.b 0(a0,d0.w)
 bne vertex_project
 move.b 10(a2),d0
 tst.b 0(a0,d0.w)
 bne vertex_project
 move.b 11(a2),d0
 tst.b 0(a0,d0.w)
 beq vertex_next
vertex_project:
 addq.l #1,_projected_total
 ; LL49..LL57: rotate visible vertex, add ship centre, clamp near Z to 4.
 move.w (a2),d0
 muls.w 0(a3),d0
 move.w 2(a2),d1
 muls.w 2(a3),d1
 add.l d1,d0
 move.w 4(a2),d1
 muls.w 4(a3),d1
 add.l d1,d0
 asr.l #8,d0
 add.w 4(a5),d0
 move.w d0,vertex_world+0
 move.w (a2),d0
 muls.w 6(a3),d0
 move.w 2(a2),d1
 muls.w 8(a3),d1
 add.l d1,d0
 move.w 4(a2),d1
 muls.w 10(a3),d1
 add.l d1,d0
 asr.l #8,d0
 add.w 6(a5),d0
 move.w d0,vertex_world+2
 move.w (a2),d0
 muls.w 12(a3),d0
 move.w 2(a2),d1
 muls.w 14(a3),d1
 add.l d1,d0
 move.w 4(a2),d1
 muls.w 16(a3),d1
 add.l d1,d0
 asr.l #8,d0
 add.w 8(a5),d0
 move.w d0,vertex_world+4
 move.w vertex_world+4,d2
 cmp.w #4,d2
 bge vertex_z_ready
 moveq #4,d2
vertex_z_ready:
 ; LL60: screen = (128+256*x/z,96-256*y/z).
 move.w d7,d6
 lsl.w #2,d6
 lea projected_vertices,a0
 move.w vertex_world,d0
 ext.l d0
 lsl.l #8,d0
 divs.w d2,d0
 add.w #128,d0
 bsr bound_projection
 move.w d0,0(a0,d6.w)
 move.w vertex_world+2,d0
 ext.l d0
 lsl.l #8,d0
 divs.w d2,d0
 neg.w d0
 add.w #96,d0
 bsr bound_projection
 move.w d0,2(a0,d6.w)
 lea vertex_valid,a0
 move.b #1,0(a0,d7.w)
vertex_next:
 lea 12(a2),a2
 addq.w #1,d7
 bra vertex_loop
edges_begin:
 move.w #1,_effect_visible
 tst.w _render_exploding
 bne render_return
 ; LL9 part9: a firing ship's gun vertex to screen edge, Y = z_lo.
 move.l _render_inwk,d0
 beq enemy_beam_done
 move.l d0,a0
 btst #6,31(a0)
 beq enemy_beam_done
 bclr #6,31(a0)
 moveq #0,d6
 move.w 34(a4),d6
 move.w d6,d0
 lsr.w #2,d0
 lea vertex_valid,a1
 tst.b 0(a1,d0.w)
 beq enemy_beam_done
 lea projected_vertices,a1
 move.w 0(a1,d6.w),d0
 cmp.b #255,d0
 beq enemy_beam_done
 move.w d0,d1
 lsr.w #8,d1
 cmp.b #255,d1
 beq enemy_beam_done
 move.w 2(a1,d6.w),d1
 moveq #0,d2
 tst.b 2(a0)
 bpl enemy_beam_side
 move.w #255,d2
enemy_beam_side:
 moveq #0,d3
 move.b 6(a0),d3
 bsr clip_segment
 tst.w d4
 beq enemy_beam_done
 lea 16(a5),a0
 move.b d0,(a0)+
 move.b d1,(a0)+
 move.b d2,(a0)+
 move.b d3,(a0)+
 move.w #1,12(a5)
 addq.l #1,_line_total
enemy_beam_done:
 move.l 14(a4),a2
 moveq #0,d7
edge_loop:
 cmp.w 2(a4),d7
 bge render_draw
 move.w 12(a5),d0
 cmp.w 8(a4),d0
 bge render_draw
 ; LL75: edge detail and either adjacent face visibility.
 moveq #0,d0
 move.b 4(a2),d0
 cmp.w distance_level,d0
 blt edge_next
 lea visible_faces,a0
 move.b 2(a2),d0
 tst.b 0(a0,d0.w)
 bne edge_vertices
 move.b 3(a2),d0
 tst.b 0(a0,d0.w)
 beq edge_next
edge_vertices:
 moveq #0,d4
 moveq #0,d5
 move.b (a2),d4
 move.b 1(a2),d5
 lea vertex_valid,a0
 tst.b 0(a0,d4.w)
 beq edge_next
 tst.b 0(a0,d5.w)
 beq edge_next
 lsl.w #2,d4
 lsl.w #2,d5
 lea projected_vertices,a0
 move.w 0(a0,d4.w),d0
 move.w 2(a0,d4.w),d1
 move.w 0(a0,d5.w),d2
 move.w 2(a0,d5.w),d3
 move.l d7,-(sp)
 bsr clip_segment
 move.l (sp)+,d7
 tst.w d4
 beq edge_next
 ; LL80: retain the clipped byte endpoints for both draw and later erase.
 move.w 12(a5),d6
 lsl.w #2,d6
 lea 16(a5,d6.w),a0
 move.b d0,(a0)+
 move.b d1,(a0)+
 move.b d2,(a0)+
 move.b d3,(a0)+
 addq.w #1,12(a5)
 addq.l #1,_line_total
edge_next:
 lea 6(a2),a2
 addq.w #1,d7
 bra edge_loop
render_draw:
 bsr draw_cache
render_return:
 movem.l (sp)+,d2-d7/a2-a6
 rts
bound_projection:
 cmp.w #8191,d0
 ble projection_low
 move.w #8191,d0
projection_low:
 cmp.w #-8191,d0
 bge projection_done
 move.w #-8191,d0
projection_done:
 rts
distant_ship:
 tst.w _render_exploding
 bne render_return
 move.w 4(a5),d0
 ext.l d0
 lsl.l #8,d0
 divs.w d2,d0
 add.w #128,d0
 move.w 6(a5),d1
 ext.l d1
 lsl.l #8,d1
 divs.w d2,d1
 neg.w d1
 add.w #96,d1
 move.w d0,d2
 addq.w #1,d2
 move.w d1,d3
 bsr clip_segment
 tst.w d4
 beq render_return
 move.b d0,16(a5)
 move.b d1,17(a5)
 move.b d2,18(a5)
 move.b d3,19(a5)
 move.w #1,12(a5)
 addq.l #1,_line_total
 bra render_draw
; A5 object; A6 screen. xor_segment preserves the cache cursor and counter.
; Redraw existing line heaps without changing simulation or render state.
.globl _render_cache
_render_cache:
 movem.l d2-d7/a2-a6,-(sp)
 move.l 48(sp),a6
 move.l 52(sp),a5
 bsr draw_cache
 movem.l (sp)+,d2-d7/a2-a6
 rts
draw_cache:
 move.w 12(a5),d7
 beq cache_done
 subq.w #1,d7
 lea 16(a5),a1
 move.l a6,a0
cache_loop:
 moveq #0,d0
 moveq #0,d1
 moveq #0,d2
 moveq #0,d3
 move.b (a1)+,d0
 move.b (a1)+,d1
 move.b (a1)+,d2
 move.b (a1)+,d3
 bsr xor_segment
 dbra d7,cache_loop
cache_done:
 rts
.sect .bss
.align 2
_projected_total: .space 4
_line_total: .space 4
visible_faces: .space 16
vertex_valid: .space 32
_effect_vertices:
projected_vertices: .space 128
camera_local: .space 6
vertex_world: .space 6
distance_level: .space 2

camera_position: .space 6
camera_shift: .space 2

.sect .data
.align 2
.globl _live_matrix
_live_matrix: .data4 0

.align 2
_render_exploding: .space 2
_effect_visible: .space 2
_render_inwk: .space 4
