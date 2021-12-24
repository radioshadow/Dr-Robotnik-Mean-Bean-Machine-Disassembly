; --------------------------------------------------------------
; Puyo decompression
; --------------------------------------------------------------

PuyoDec:
	DISABLE_INTS

	move.w	d0,d1
	andi.w	#$3FFF,d1
	ori.w	#$4000,d1
	move.w	d1,VDP_CTRL
	lsl.l	#2,d0
	swap	d0
	andi.w	#3,d0
	move.w	d0,VDP_CTRL

	lea	puyo_dec_buffer,a1
	lea	puyo_dec_vdp_buf,a2
	clr.w	d0
	clr.w	d1

.DecompLoop:
	move.b	(a0)+,d2
	tst.b	d2
	bmi.w	.CopyBackward
	bne.w	.CopyForward

	ENABLE_INTS
	rts

.CopyForward:
	andi.w	#$7F,d2
	subq.w	#1,d2

.CopyForwardLoop:
	move.b	(a0)+,d4
	move.b	d4,(a2,d1.w)

	addq.b	#1,d1
	btst	#2,d1
	beq.w	.CopyForwardStore
	clr.b	d1
	move.l	(a2),VDP_DATA

.CopyForwardStore:
	move.b	d4,(a1,d0.w)

	addq.b	#1,d0
	dbf	d2,.CopyForwardLoop
	bra.s	.DecompLoop

.CopyBackward:
	andi.w	#$7F,d2
	addq.w	#2,d2
	move.w	d0,d3
	sub.b	(a0)+,d3
	subq.b	#1,d3

.CopyBackwardLoop:
	move.b	(a1,d3.w),d4
	move.b	d4,(a2,d1.w)

	addq.b	#1,d1
	btst	#2,d1
	beq.w	.CopyBackwardStore
	clr.b	d1
	move.l	(a2),VDP_DATA

.CopyBackwardStore:
	move.b	d4,(a1,d0.w)

	addq.b	#1,d0
	addq.b	#1,d3
	dbf	d2,.CopyBackwardLoop
	bra.s	.DecompLoop