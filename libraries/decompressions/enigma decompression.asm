; --------------------------------------------------------------
; Enigma decompression
; --------------------------------------------------------------

NemEniDec_ChkGetNextByte:
	sub.w	d0,d6
	cmpi.w	#9,d6
	bcc.s	locret_23930
	addq.w	#8,d6
	asl.w	#8,d5
	move.b	(a0)+,d5

locret_23930:
	rts

; ---------------------------------------------------------------------------

EniDec_AndVals:	
	dc.w 1
	dc.w 3
	dc.w 7
	dc.w $F
	dc.w $1F
	dc.w $3F
	dc.w $7F
	dc.w $FF
	dc.w $1FF
	dc.w $3FF
	dc.w $7FF
	dc.w $FFF
	dc.w $1FFF
	dc.w $3FFF
	dc.w $7FFF
	dc.w $FFFF
	even

; =============== S U B	R O U T	I N E =======================================

EniDec_GetInlineCopyVal:
	move.w	a3,d3
	swap	d4
	bpl.s	loc_23962
	subq.w	#1,d6
	btst	d6,d5
	beq.s	loc_23962
	ori.w	#$1000,d3

loc_23962:
	swap	d4
	bpl.s	loc_23970
	subq.w	#1,d6
	btst	d6,d5
	beq.s	loc_23970
	ori.w	#$800,d3

loc_23970:
	move.w	d5,d1
	move.w	d6,d7
	sub.w	a5,d7
	bcc.s	loc_239A0
	move.w	d7,d6
	addi.w	#$10,d6
	neg.w	d7
	lsl.w	d7,d1
	move.b	(a0),d5
	rol.b	d7,d5
	add.w	d7,d7
	and.w	EniDec_AndVals-2(pc,d7.w),d5
	add.w	d5,d1

loc_2398E:
	move.w	a5,d0
	add.w	d0,d0
	and.w	EniDec_AndVals-2(pc,d0.w),d1
	add.w	d3,d1
	move.b	(a0)+,d5
	lsl.w	#8,d5
	move.b	(a0)+,d5
	rts
	
; ---------------------------------------------------------------------------

loc_239A0:
	beq.s	loc_239B4
	lsr.w	d7,d1
	move.w	a5,d0
	add.w	d0,d0
	and.w	EniDec_AndVals-2(pc,d0.w),d1
	add.w	d3,d1
	move.w	a5,d0
	bra.w	NemEniDec_ChkGetNextByte
	
; ---------------------------------------------------------------------------

loc_239B4:
	moveq	#$10,d6
	bra.s	loc_2398E

; =============== S U B	R O U T	I N E =======================================

EniDecPrioMap:
	jsr	(EniDec).l
	lea	(eni_tilemap_buffer).l,a1
	lea	(eni_tilemap_queue).l,a2
	move.w	4(a2),d6

.Row:
	move.w	2(a2),d7

.Tile:
	move.w	(a1),d0
	move.b	(a3)+,d1
	ror.w	#1,d1
	andi.w	#$8000,d1
	or.w	d1,d0
	move.w	d0,(a1)+
	dbf	d7,.Tile
	dbf	d6,.Row
	rts

; =============== S U B	R O U T	I N E =======================================

EniDec:
	lea	(eni_tilemap_queue).l,a2
	move.w	#1,(a2)+
	move.w	d1,(a2)+
	move.w	d2,(a2)+
	move.w	a1,(a2)
	lea	(eni_tilemap_buffer).l,a1
	movem.l	d0-d7/a1-a5,-(sp)
	movea.w	d0,a3
	move.b	(a0)+,d0
	ext.w	d0
	movea.w	d0,a5
	move.b	(a0)+,d0
	ext.w	d0
	ext.l	d0
	ror.l	#1,d0
	ror.w	#1,d0
	move.l	d0,d4
	movea.w	(a0)+,a2
	adda.w	a3,a2
	movea.w	(a0)+,a4
	adda.w	a3,a4
	move.b	(a0)+,d5
	asl.w	#8,d5
	move.b	(a0)+,d5
	moveq	#$10,d6

EniDec_Loop:
	moveq	#7,d0
	move.w	d6,d7
	sub.w	d0,d7
	move.w	d5,d1
	lsr.w	d7,d1
	andi.w	#$7F,d1
	move.w	d1,d2
	cmpi.w	#$40,d1
	bcc.s	loc_23A42
	moveq	#6,d0
	lsr.w	#1,d2

loc_23A42:
	bsr.w	NemEniDec_ChkGetNextByte
	andi.w	#$F,d2
	lsr.w	#4,d1
	add.w	d1,d1
	jmp	EniDec_JmpTable(pc,d1.w)

; ---------------------------------------------------------------------------

EniDec_Sub0:
	move.w	a2,(a1)+
	addq.w	#1,a2
	dbf	d2,EniDec_Sub0
	bra.s	EniDec_Loop
	
; ---------------------------------------------------------------------------

EniDec_Sub4:
	move.w	a4,(a1)+
	dbf	d2,EniDec_Sub4
	bra.s	EniDec_Loop
	
; ---------------------------------------------------------------------------

EniDec_Sub8:
	bsr.w	EniDec_GetInlineCopyVal

loc_23A68:
	move.w	d1,(a1)+
	dbf	d2,loc_23A68
	bra.s	EniDec_Loop
	
; ---------------------------------------------------------------------------

EniDec_SubA:
	bsr.w	EniDec_GetInlineCopyVal

loc_23A74:
	move.w	d1,(a1)+
	addq.w	#1,d1
	dbf	d2,loc_23A74
	bra.s	EniDec_Loop
	
; ---------------------------------------------------------------------------

EniDec_SubC:
	bsr.w	EniDec_GetInlineCopyVal

loc_23A82:
	move.w	d1,(a1)+
	subq.w	#1,d1
	dbf	d2,loc_23A82
	bra.s	EniDec_Loop
	
; ---------------------------------------------------------------------------

EniDec_SubE:
	cmpi.w	#$F,d2
	beq.s	EniDec_End

loc_23A92:
	bsr.w	EniDec_GetInlineCopyVal
	move.w	d1,(a1)+
	dbf	d2,loc_23A92
	bra.s	EniDec_Loop
	
; ---------------------------------------------------------------------------

EniDec_JmpTable:
	bra.s	EniDec_Sub0
	bra.s	EniDec_Sub0
	bra.s	EniDec_Sub4
	bra.s	EniDec_Sub4
	bra.s	EniDec_Sub8
	bra.s	EniDec_SubA
	bra.s	EniDec_SubC
	bra.s	EniDec_SubE
	
; ---------------------------------------------------------------------------

EniDec_End:
	subq.w	#1,a0
	cmpi.w	#$10,d6
	bne.s	loc_23AB8
	subq.w	#1,a0

loc_23AB8:
	move.w	a0,d0
	lsr.w	#1,d0
	bcc.s	loc_23AC0
	addq.w	#1,a0

loc_23AC0:
	movem.l	(sp)+,d0-d7/a1-a5
	rts