; =============== A C T O R =================================================
; Pause
; ---------------------------------------------------------------------------

	bsr.w	GetPuyoFieldPos
	addi.w	#48,d0
	move.w	d0,aX(a0)
	addi.w	#80,d1
	move.w	d1,aY(a0)
	move.b	aPlayerID(a0),d0
	addi.b	#$20,d0
	move.b	#6,aMappings(a0)
	move.b	d0,aFrame(a0)
	bsr.w	ActorBookmark

ActPause_Update:
	clr.w	d0
	move.b	aPlayerID(a0),d0
	lea	(player_1_flags).l,a1
	tst.b	(a1,d0.w)
	bpl.w	ActorDeleteSelf
	addq.b	#1,aField26(a0)
	andi.b	#$3F,aField26(a0)
	move.b	#0,aDrawFlags(a0)
	cmpi.b	#$30,aField26(a0)
	bcc.w	locret_9306
	move.b	#$80,aDrawFlags(a0)

locret_9306:
	rts