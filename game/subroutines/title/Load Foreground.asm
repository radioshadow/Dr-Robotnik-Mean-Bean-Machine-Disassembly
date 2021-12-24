; =============== S U B	R O U T	I N E =======================================
; Load forground
; ---------------------------------------------------------------------------
					
	DISABLE_INTS
	lea	(MapEni_TitleLogo).l,a0
	lea	($CDB0).l,a1
	move.w	#0,d0
	move.w	#$17,d1
	move.w	#7,d2
	jsr	(EniDec).l
	ENABLE_INTS
	rts