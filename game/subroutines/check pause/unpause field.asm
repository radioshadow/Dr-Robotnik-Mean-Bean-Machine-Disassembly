; =============== S U B	R O U T	I N E =======================================
; Unpause field
; ---------------------------------------------------------------------------
					
	movem.l	d1-d2,-(sp)
	bsr.w	GetSavedPuyoField
	move.w	d0,d5
	move.w	#$17,d1

loc_924E:
	jsr	(SetVRAMWrite).l
	addi.w	#$80,d5
	move.w	#$B,d2

loc_925C:
	move.w	(a1)+,VDP_DATA
	dbf	d2,loc_925C
	dbf	d1,loc_924E
	movem.l	(sp)+,d1-d2
	rts