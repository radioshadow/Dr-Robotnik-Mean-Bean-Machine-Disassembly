; --------------------------------------------------------------
; Nemesis decompression - original
; --------------------------------------------------------------

NemDec:
	movem.l	d0-a5,-(sp)
	andi.l	#$FFFF,d0
	add.l	d0,d0
	add.l	d0,d0
	lsr.w	#2,d0
	swap	d0
	addi.l	#$40000000,d0
	move.l	d0,VDP_CTRL
	lea	(NemDec_WriteAndStay).l,a3
	lea	VDP_DATA,a4
	bra.s	NemDecMain
	
; ---------------------------------------------------------------------------

NemDecRAM:
	movem.l	d0-a5,-(sp)
	lea	(NemDec_WriteAndAdvance).l,a3

NemDecMain:
	DISABLE_INTS
	lea	(nem_buffer).l,a1
	move.w	(a0)+,d2
	lsl.w	#1,d2
	bcc.s	loc_237F2
	adda.w	#NemDec_WriteAndStay_XOR-NemDec_WriteAndStay,a3

loc_237F2:
	lsl.w	#2,d2
	movea.w	d2,a5
	moveq	#8,d3
	moveq	#0,d2
	moveq	#0,d4
	bsr.w	NemDecPrepare
	bsr.w	sub_23904

NemDecRun:
	moveq	#8,d0
	bsr.w	sub_2390E
	cmpi.w	#$FC,d1
	bcc.s	loc_23840
	add.w	d1,d1
	move.b	(a1,d1.w),d0
	ext.w	d0
	bsr.w	NemEniDec_ChkGetNextByte
	move.b	1(a1,d1.w),d1

loc_23820:
	move.w	d1,d0
	andi.w	#$F,d1
	andi.w	#$F0,d0
	lsr.w	#4,d0

loc_2382C:
	lsl.l	#4,d4
	or.b	d1,d4
	subq.w	#1,d3
	bne.s	NemDec_WriteIter_Part2
	jmp	(a3)
	
; ---------------------------------------------------------------------------

NemDec_WriteIter:
	moveq	#0,d4
	moveq	#8,d3

NemDec_WriteIter_Part2:
	dbf	d0,loc_2382C
	bra.s	NemDecRun
	
; ---------------------------------------------------------------------------

loc_23840:
	moveq	#6,d0
	bsr.w	NemEniDec_ChkGetNextByte
	moveq	#7,d0
	bsr.w	sub_2391E
	bra.s	loc_23820

; =============== S U B	R O U T	I N E =======================================

NemDec_WriteAndStay:
	move.l	d4,(a4)
	subq.w	#1,a5
	move.w	a5,d4
	bne.s	NemDec_WriteIter
	bra.s	loc_23878
	
; ---------------------------------------------------------------------------

NemDec_WriteAndStay_XOR:
	eor.l	d4,d2
	move.l	d2,(a4)
	subq.w	#1,a5
	move.w	a5,d4
	bne.s	NemDec_WriteIter
	bra.s	loc_23878
	
; ---------------------------------------------------------------------------

NemDec_WriteAndAdvance:
	move.l	d4,(a4)+
	subq.w	#1,a5
	move.w	a5,d4
	bne.s	NemDec_WriteIter
	bra.s	loc_23878
	
; ---------------------------------------------------------------------------

NemDec_WriteAndAdvance_XOR:
	eor.l	d4,d2
	move.l	d2,(a4)+
	subq.w	#1,a5
	move.w	a5,d4
	bne.s	NemDec_WriteIter

loc_23878:
	movem.l	(sp)+,d0-a5
	ENABLE_INTS
	rts

; =============== S U B	R O U T	I N E =======================================

NemDecPrepare:
	move.b	(a0)+,d0

loc_23884:
	cmpi.b	#$FF,d0
	bne.s	loc_2388C
	rts
	
; ---------------------------------------------------------------------------

loc_2388C:
	move.w	d0,d7

loc_2388E:
	move.b	(a0)+,d0
	cmpi.b	#$80,d0
	bcc.s	loc_23884
	move.b	d0,d1
	andi.w	#$F,d7
	andi.w	#$70,d1
	or.w	d1,d7
	andi.w	#$F,d0
	move.b	d0,d1
	lsl.w	#8,d1
	or.w	d1,d7
	moveq	#8,d1
	sub.w	d0,d1
	bne.s	loc_238BC
	move.b	(a0)+,d0
	add.w	d0,d0
	move.w	d7,(a1,d0.w)
	bra.s	loc_2388E
	
; ---------------------------------------------------------------------------

loc_238BC:
	move.b	(a0)+,d0
	lsl.w	d1,d0
	add.w	d0,d0
	moveq	#1,d5
	lsl.w	d1,d5
	subq.w	#1,d5

loc_238C8:
	move.w	d7,(a1,d0.w)
	addq.w	#2,d0
	dbf	d5,loc_238C8
	bra.s	loc_2388E

; ---------------------------------------------------------------------------

	; Unused code?
	lsl.w	d0,d5
	add.w	d0,d6
	add.w	d0,d0
	and.w	locret_23930(pc,d0.w),d1
	add.w	d1,d5
	move.w	d6,d0
	subq.w	#8,d0
	bcs.s	locret_238F6
	bne.s	loc_238EE
	clr.w	d6
	move.b	d5,(a0)+
	rts
	
; ---------------------------------------------------------------------------

loc_238EE:
	move.w	d5,d6
	lsr.w	d0,d6
	move.b	d6,(a0)+
	move.w	d0,d6

locret_238F6:
	rts
	
; ---------------------------------------------------------------------------

	neg.w	d6
	beq.s	locret_23902
	addq.w	#8,d6
	lsl.w	d6,d5
	move.b	d5,(a0)+

locret_23902:
	rts

; =============== S U B	R O U T	I N E =======================================

sub_23904:
	move.b	(a0)+,d5
	asl.w	#8,d5
	move.b	(a0)+,d5
	moveq	#$10,d6
	rts

; =============== S U B	R O U T	I N E =======================================

sub_2390E:
	move.w	d6,d7
	sub.w	d0,d7
	move.w	d5,d1
	lsr.w	d7,d1
	add.w	d0,d0
	and.w	EniDec_AndVals-2(pc,d0.w),d1
	rts

; =============== S U B	R O U T	I N E =======================================

sub_2391E:
	bsr.s	sub_2390E
	lsr.w	#1,d0