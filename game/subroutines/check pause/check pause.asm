; =============== S U B	R O U T	I N E =======================================
; Check pause
; ---------------------------------------------------------------------------
					
	moveq	#0,d2
	move.b	(p1_ctrl_press).l,d0
	move.b	(p2_ctrl_press).l,d1
	tst.b	(swap_controls).l
	beq.w	.NoSwap
	exg	d0,d1

.NoSwap:
	btst	#1,(level_mode).l
	bne.w	loc_9112
	or.b	d1,d0
	move.b	d0,d1
	tst.b	(player_1_flags).l
	bpl.w	loc_9112
	move.b	(p1_ctrl_press).l,d0
	tst.b	(p1_paused).l
	beq.w	loc_9110
	move.b	(p2_ctrl_press).l,d0

loc_9110:
	move.b	d0,d1

loc_9112:
	lea	(player_1_flags).l,a2
	move.w	#0,d2
	bsr.w	CheckPlayerPause
	move.b	d1,d0
	move.w	#1,d2

; ---------------------------------------------------------------------------

CheckPlayerPause:
	tst.b	(a2,d2.w)
	beq.w	.NoUpdate
	btst	#7,d0
	beq.w	.NoUpdate
	eori.b	#$80,(a2,d2.w)
	bpl.w	.Unpause

	movem.l	d0,-(sp)
	move.b	(p1_ctrl_press).l,d0
	andi.b	#$80,d0
	eori.b	#$80,d0
	move.b	d0,(p1_paused).l
	movem.l	(sp)+,d0

	lea	(ActPause).l,a1
	jsr	(FindActorSlot).l
	bcs.w	.Pause
	move.b	d2,aPlayerID(a1)

.Pause:
	DISABLE_INTS
	bsr.w	PausePuyoField
	ENABLE_INTS
	jsr	(VSync).l
	btst	#1,(level_mode).l
	beq.w	.CheckPauseSound
	move.b	#SFX_GARBAGE_1,d0
	jmp	(PlaySound_ChkPCM).l
	
; ---------------------------------------------------------------------------

.Unpause:
	DISABLE_INTS
	bsr.w	UnpausePuyoField
	ENABLE_INTS
	jsr	(VSync).l
	btst	#1,(level_mode).l
	beq.w	.CheckUnpauseSound
	move.b	#SFX_GARBAGE_1,d0
	jmp	(PlaySound_ChkPCM).l
	
; ---------------------------------------------------------------------------

.NoUpdate:
	rts
	
; ---------------------------------------------------------------------------

.CheckPauseSound:
	btst	#$10,d2
	bne.w	.NoPauseSound
	bset	#$10,d2
	jsr	(PauseSound).l

.NoPauseSound:
	rts
	
; ---------------------------------------------------------------------------

.CheckUnpauseSound:
	btst	#$11,d2
	bne.w	.NoUnpauseSound
	bset	#$11,d2
	jsr	(UnpauseSound).l

.NoUnpauseSound:
	rts

