; =============== S U B	R O U T	I N E =======================================
; Pause field
; ---------------------------------------------------------------------------
					
	movem.l	d1-d2,-(sp)
	bsr.w	GetSavedPuyoField
	move.w	d0,d5
	move.w	#$17,d1

loc_91F8:
	jsr	(SetVRAMRead).l
	addi.w	#$80,d5
	move.w	#$B,d2

loc_9206:
	move.w	VDP_DATA,d3
	move.w	d3,(a1)+
	dbf	d2,loc_9206
	dbf	d1,loc_91F8
	move.w	d0,d5
	move.w	#$17,d1

loc_921C:
	jsr	(SetVRAMWrite).l
	addi.w	#$80,d5
	move.w	#$B,d2

loc_922A:
	move.w	#$8500,VDP_DATA
	dbf	d2,loc_922A
	dbf	d1,loc_921C
	movem.l	(sp)+,d1-d2
	rts