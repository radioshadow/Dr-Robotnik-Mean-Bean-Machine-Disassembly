; =============== S U B	R O U T	I N E =======================================
; Load saved field
; ---------------------------------------------------------------------------

	clr.w	d1
	move.b	(swap_controls).l,d1
	lsl.b	#1,d1
	or.b	d2,d1
	lsl.b	#3,d1
	movea.l	off_9288(pc,d1.w),a1
	move.w	off_9288+4(pc,d1.w),d0
	rts

; ---------------------------------------------------------------------------

off_9288:
	dc.l saved_puyo_field_p1
	dc.w $C104, 0
	dc.l saved_puyo_field_p2
	dc.w $C134, 0
	dc.l saved_puyo_field_p1
	dc.w $C134, 0
	dc.l saved_puyo_field_p2
	dc.w $C104, 0