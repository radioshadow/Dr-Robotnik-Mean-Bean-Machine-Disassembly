; =============== S U B	R O U T	I N E =======================================
; Initiate title
; ---------------------------------------------------------------------------
					
	bsr.w	InitTitleFlags
	jsr	(ClearScroll).l
	lea	(ActTitleHandler).l,a1
	jsr	(FindActorSlot).l
	bcs.w	loc_DECC
	lea	(ActTitleRobotnik).l,a1
	jsr	(FindActorSlot).l
	bcs.w	loc_DECC
	move.b	#1,aField26(a1)
	movea.l	a1,a2
	lea	(ActTitleMachineText).l,a1
	jsr	(FindActorSlot).l
	bcs.w	loc_DECC
	move.l	a2,aField2E(a1)
	move.b	#$24,aMappings(a1)
	move.b	#$39,aFrame(a1)
	move.w	#0,aX(a1)
	move.w	#$CF,aY(a1)
	movea.w	a1,a3
	lea	(TitleAnimPieces).l,a2
	move.w	#9,d0

loc_DEA6:
	movea.l	(a2)+,a1
	jsr	(FindActorSlot).l
	bcs.w	loc_DECC
	move.l	a3,aField2E(a1)
	move.l	(a2)+,aAnim(a1)
	move.b	#$24,aMappings(a1)
	move.w	(a2)+,aX(a1)
	move.w	(a2)+,aY(a1)
	dbf	d0,loc_DEA6

loc_DECC:
	lea	(ActTitleRobotnikText).l,a1
	jsr	(FindActorSlot).l
	bcs.w	locret_DEFA
	move.b	#$24,aMappings(a1)
	move.b	#$49,aFrame(a1)
	move.w	#$98,aX(a1)
	move.w	#$90,aY(a1)
	move.b	#$80,aDrawFlags(a1)

locret_DEFA:
	rts

; ---------------------------------------------------------------------------

TitleAnimPieces:
	dc.l ActTitleHPiston
	dc.l Anim_TitleHPiston
	dc.w $FFA0
	dc.w $D0
	dc.l ActTitleHLeftMeter
	dc.l Anim_TitleHLeftMeter
	dc.w $FFB0
	dc.w $10F
	dc.l ActTitleNElectricity
	dc.l ActTitleNElectricity
	dc.w $FFE8
	dc.w $DF
	dc.l ActTitleHRightMeters
	dc.l Anim_TitleHRightMeters
	dc.w $FFC0
	dc.w $F8
	dc.l ActTitleHSiren
	dc.l Anim_TitleHSiren
	dc.w $FFC3
	dc.w $E3
	dc.l ActTitleALight
	dc.l ActTitleALight
	dc.w $FF78
	dc.w $F4
	dc.l ActTitleILights
	dc.l ActTitleILights
	dc.w $FFCF
	dc.w $10A
	dc.l ActTitleESteam1
	dc.l Anim_TitleESteam1
	dc.w $2F
	dc.w $E9
	dc.l ActTitleESteam2
	dc.l Anim_TitleESteam2
	dc.w $35
	dc.w $EA
	dc.l ActTitleCParticles
	dc.l ActTitleCParticles
	dc.w $FF9F
	dc.w $F8
	
	even