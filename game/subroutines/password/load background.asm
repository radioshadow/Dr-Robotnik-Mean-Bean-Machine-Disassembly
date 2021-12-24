; =============== S U B	R O U T	I N E =======================================
; Load background
; ---------------------------------------------------------------------------
					
	lea	($E000).l,a1
	lea	(MapEni_Password).l,a0
	move.w	#$6400,d0
	move.w	#$27,d1
	move.w	#$1B,d2
	jmp	(EniDec).l