; =============== S U B	R O U T	I N E =======================================
; Load background
; ---------------------------------------------------------------------------
					
	DISABLE_INTS
	lea	(MapEni_TitleRobotnik).l,a0
	lea	($E100).l,a1
	move.w	#$6000,d0
	move.w	#$27,d1
	move.w	#$16,d2
	jsr	(EniDec).l
	movea.l	#(eni_tilemap_buffer+$728),a1
	moveq	#5,d0

loc_EC5E:
	clr.l	(a1)+
	dbf	d0,loc_EC5E
	ENABLE_INTS
	rts