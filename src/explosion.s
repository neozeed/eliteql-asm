; Native DOEXP/PTCLS/EXS1/PIXEL. Original cloud counter, deterministic per-vertex
; seeds, particle counts, random spread, clipping and two/four-pixel shapes.
; Renderer supplies projected vertices using the documented native projection.
.sect .text
.globl _cloud_advance
.globl _cloud_points
.globl _cloud_xor
.globl _explosion_start
.globl _explosion_frame
.extern _elite_random
.extern _effect_visible
.extern _effect_vertices
; advance(inwk,heap[56]): return1 active,0 expired. Heap original bytes0..54.
_cloud_advance:
 move.l 4(sp),a0
 move.l 8(sp),a1
 moveq #0,d0
 move.b 7(a0),d0
 cmp.w #32,d0
 bhs cloud_far
 lsl.w #3,d0
 moveq #0,d1
 move.b 6(a0),d1
 lsr.w #5,d1
 and.w #6,d1
 or.w d1,d0
 or.w #1,d0
 move.w d0,-(sp)
 moveq #0,d0
 move.b 1(a1),d0
 addq.w #4,d0
 bra cloud_counter
cloud_far:
 move.w #254,-(sp)
 moveq #0,d0
 move.b 1(a1),d0
 addq.w #5,d0
cloud_counter:
 cmp.w #255,d0
 bhi cloud_expired
 move.b d0,1(a1)
 lsl.l #8,d0
 move.w (sp)+,d1
 divu.w d1,d0
 and.l #65535,d0
 cmp.w #7168,d0
 bhs cloud_size_max
 lsr.w #5,d0
 bra cloud_size_store
cloud_size_max:
 move.w #254,d0
cloud_size_store:
 move.b d0,(a1)
 and.b #191,31(a0)
 moveq #1,d0
 rts
cloud_expired:
 addq.l #2,sp
 or.b #160,31(a0)
 moveq #0,d0
 rts
; points(heap,out[96][4],rng,planetZlo) -> count. Input heap count <=54.
_cloud_points:
 movem.l d2-d7/a2-a6,-(sp)
 subq.l #8,sp
 move.l sp,a6
 move.l 56(sp),a2
 move.l 60(sp),a3
 move.l 64(sp),a4
 move.b 1(a4),6(a6)
 clr.w 4(a6)
 moveq #0,d0
 move.b (a2),d0
 move.w d0,2(a6)
 lea 7(a2),a5
 moveq #10,d6
cloud_vertex:
 moveq #0,d0
 move.b 2(a2),d0
 cmp.w d0,d6
 bhi cloud_points_done
 ; RAND[i] = heap[3+i] EOR (10+4*vertex).
 moveq #3,d0
cloud_seed_loop:
 move.b 3(a2,d0.w),d1
 eor.b d6,d1
 move.b d1,0(a4,d0.w)
 dbra d0,cloud_seed_loop
 moveq #0,d7
 move.b 1(a2),d7
 bpl cloud_particle_count
 eor.b #255,d7
cloud_particle_count:
 lsr.w #4,d7
 or.w #1,d7
cloud_particle:
 bsr cloud_random
 move.b d0,d5
 moveq #0,d0
 move.b 3(a5),d0
 lsl.w #8,d0
 move.b 2(a5),d0
 bsr cloud_offset
 cmp.w #191,d0
 bhs cloud_skip_y
 move.w d0,4(a6)
 moveq #0,d0
 move.b 1(a5),d0
 lsl.w #8,d0
 move.b (a5),d0
 bsr cloud_offset
 cmp.w #255,d0
 bhi cloud_next_particle
 move.b d0,(a3)+
 move.b 5(a6),(a3)+
 move.b d5,(a3)+
 clr.b (a3)+
 bra cloud_next_particle
cloud_skip_y:
 ; EX11 consumes the skipped x random number too.
 bsr cloud_random
cloud_next_particle:
 dbra d7,cloud_particle
 addq.w #4,d6
 addq.l #4,a5
 bra cloud_vertex
cloud_points_done:
 move.b 6(a6),1(a4)
 move.l 68(sp),d0
 move.b d0,3(a4)
 move.l a3,d0
 sub.l 60(sp),d0
 lsr.l #2,d0
 addq.l #8,sp
 movem.l (sp)+,d2-d7/a2-a6
 rts
cloud_random:
 clr.l -(sp)
 move.l a4,-(sp)
 jsr _elite_random
 addq.l #8,sp
 rts
cloud_offset:
 move.w d0,(a6)
 bsr cloud_random
 move.w d0,d1
 lsr.w #8,d1
 move.w d0,d2
 and.w #128,d2
 add.b d0,d0
 or.b d1,d0
 and.w #255,d0
 mulu.w 2(a6),d0
 lsr.w #8,d0
 tst.w d2
 bne cloud_offset_minus
 addq.w #1,d0
 add.w (a6),d0
 rts
cloud_offset_minus:
 neg.w d0
 add.w (a6),d0
 rts
; xor(screen,points,count), preserving the original PIXEL dash position.
_cloud_xor:
 movem.l d2-d7/a2-a3,-(sp)
 move.l 36(sp),a2
 move.l 40(sp),a3
 move.l 44(sp),d7
 subq.w #1,d7
 bmi cloud_xor_done
cloud_xor_next:
 moveq #0,d0
 moveq #0,d1
 move.b (a3),d0
 move.b 1(a3),d1
 move.w d0,d2
 and.w #7,d2
 beq cloud_dash_ready
 subq.w #1,d0
cloud_dash_ready:
 bsr cloud_dash
 cmp.b #80,2(a3)
 bhs cloud_xor_advance
 move.w d1,d2
 and.w #7,d2
 beq cloud_second_below
 subq.w #1,d1
 bra cloud_second
cloud_second_below:
 addq.w #1,d1
cloud_second:
 bsr cloud_dash
cloud_xor_advance:
 addq.l #4,a3
 dbra d7,cloud_xor_next
cloud_xor_done:
 movem.l (sp)+,d2-d7/a2-a3
 rts
cloud_dash:
 bsr cloud_pixel
 addq.w #1,d0
 bsr cloud_pixel
 subq.w #1,d0
 rts
cloud_pixel:
 move.w d1,d2
 lsl.w #7,d2
 move.w d0,d3
 lsr.w #2,d3
 add.w d3,d3
 add.w d3,d2
 move.l a2,a0
 adda.w d2,a0
 move.w d0,d3
 and.w #3,d3
 add.w d3,d3
 lea cloud_masks(pc),a1
 move.w 0(a1,d3.w),d3
 eor.w d3,(a0)
 rts
cloud_masks: .data2 0x80c0,0x2030,0x080c,0x0203
; start(inwk,cloud[448],model,rng), LL9 kill->explosion state and EE55 seed.
_explosion_start:
 movem.l d2-d4/a2-a4,-(sp)
 move.l 28(sp),a2
 move.l 32(sp),a3
 move.l 36(sp),a0
 move.l 40(sp),a4
 or.b #32,31(a2)
 and.b #63,31(a2)
 clr.b 28(a2)
 clr.b 30(a2)
 move.b #18,1(a3)
 move.w 32(a0),d0
 move.b d0,2(a3)
 moveq #0,d4
cloud_start_seed:
 ; CPY #6 leaves clear carry between the four original DORND calls.
 clr.l -(sp)
 move.l a4,-(sp)
 jsr _elite_random
 addq.l #8,sp
 move.b d0,3(a3,d4.w)
 addq.w #1,d4
 cmp.w #4,d4
 blo cloud_start_seed
 movem.l (sp)+,d2-d4/a2-a4
 rts
; frame(screen,inwk,cloud[448],rng): erase cached old pixels, advance, snapshot
; current projected vertices, generate and draw. Cache count56, records58.
_explosion_frame:
 movem.l d2-d7/a2-a6,-(sp)
 move.l 48(sp),a2
 move.l 52(sp),a3
 move.l 56(sp),a4
 move.l 60(sp),a5
 moveq #0,d0
 move.w 56(a4),d0
 move.l d0,-(sp)
 pea 58(a4)
 move.l a2,-(sp)
 jsr _cloud_xor
 lea 12(sp),sp
 clr.w 56(a4)
 move.b 31(a3),d0
 and.b #160,d0
 cmp.b #32,d0
 bne cloud_frame_done
 move.l a4,-(sp)
 move.l a3,-(sp)
 jsr _cloud_advance
 addq.l #8,sp
 tst.l d0
 beq cloud_frame_done
 tst.w _effect_visible
 beq cloud_frame_done
 ; Native projected coordinates -> original little-endian XX3 heap layout.
 lea _effect_vertices,a0
 lea 7(a4),a1
 moveq #0,d7
 move.b 2(a4),d7
 subq.w #6,d7
 lsr.w #1,d7
 subq.w #1,d7
cloud_copy_vertices:
 move.w (a0)+,d0
 move.b d0,(a1)+
 lsr.w #8,d0
 move.b d0,(a1)+
 dbra d7,cloud_copy_vertices
 clr.l -(sp)
 move.l a5,-(sp)
 pea 58(a4)
 move.l a4,-(sp)
 jsr _cloud_points
 lea 16(sp),sp
 move.w d0,56(a4)
 or.b #64,31(a3)
 move.l d0,-(sp)
 pea 58(a4)
 move.l a2,-(sp)
 jsr _cloud_xor
 lea 12(sp),sp
cloud_frame_done:
 movem.l (sp)+,d2-d7/a2-a6
 rts
