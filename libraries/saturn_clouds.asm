; --------------------------------------------------------------
;
;	Dr. Robotnik's Mean Bean Machine Disassembly
;	Original game by Compile
;
;	Disassembled by Devon Artmeier
;
; --------------------------------------------------------------

; --------------------------------------------------------------
; Leftover code from Puyo Puyo that applied the swirling
; effect on the clouds in Satan's introduction scene
; --------------------------------------------------------------

SpawnSatanCloudEffects:
	lea	ActSatanCloudEffects,a1			; Load cloud effects actor
	bsr.w	FindActorSlot
	bcc.w	@Spawned				; If it was spawned, branch
	rts

@Spawned:
	move.w	#$8B00,d0				; HScroll by line
	move.b	vdp_reg_b,d0
	ori.b	#3,d0
	move.b	d0,vdp_reg_b
	rts

; --------------------------------------------------------------
; Satan introduction cutscene cloud effects actor
; --------------------------------------------------------------

sceAngle	EQU	$36				; Starting angle for the effect

; --------------------------------------------------------------

ActSatanCloudEffects:
	lea	hscroll_buffer+(112*4),a2		; Go to bottom of clouds

	move.b	sceAngle(a0),d0				; Get starting angle
	clr.w	d1					; Clear multiplier

	move.w	#112-1,d4				; The clouds take up 112 scanlines

	move.w	vscroll_buffer+2,d3			; Get vertical scroll offset
	subi.w	#-161,d3
	bcs.w	.ApplyEffects				; If the clouds are fully onscreen, branch
	cmpi.w	#112,d3					; Are the clouds fully offscreen?
	bcc.w	.Done					; If so, branch
	sub.w	d3,d4					; Only apply the effect to the scanlines on screen

.Clear:
	clr.w	-(a2)					; Set this scanline as static
	clr.w	-(a2)
	dbf	d3,.Clear				; Loop until all the static scanlines are set

	subq.w	#1,d4					; Are the clouds onscreen?
	bcc.w	.ApplyEffects				; If so, branch
	rts

.ApplyEffects:
	bsr.w	Sin					; Get sine of the current angle
	swap	d2
	asl.w	#1,d2

	move.w	d2,-(a2)				; Set scroll offset for this scanline
	clr.w	-(a2)

	addq.b	#2,d0					; Increment angle
	addi.w	#$100,d1				; Increment sine multiplier
	dbf	d4,.ApplyEffects			; Loop until all scanlines are applied

	addq.b	#1,sceAngle(a0)				; Increment starting angle for next frame
	rts

.Done:
	move.w	#$8B00,d0				; HScroll by screen
	move.b	vdp_reg_b,d0
	andi.b	#$FC,d0
	move.b	d0,vdp_reg_b

	clr.b	byte_FF0136				; Clear unknown flag (not even used in Puyo Puyo)
	clr.w	hscroll_buffer+2			; Reset background horizontal position

	bra.w	ActorDeleteSelf				; Delete ourselves

; --------------------------------------------------------------

	rts
	rts

; --------------------------------------------------------------