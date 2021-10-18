; --------------------------------------------------------------
;
;	Dr. Robotnik's Mean Bean Machine Disassembly
;	Original game by Compile
;
;	Disassembled by Devon Artmeier
;
; --------------------------------------------------------------

; --------------------------------------------------------------
; Initialize actors
; --------------------------------------------------------------

InitActors:
	move.w	#(actors_end-actors)/4-1,d1		; Size of actor data in longwords
	lea	actors,a0				; Pointer to actor data
	moveq	#0,d0					; Clear actor data

.ClearActors:
	move.l	d0,(a0)+
	dbf	d1,.ClearActors

	lea	pal_fade_data,a2			; Pointer to palette fade data
	move.w	#4-1,d0					; 4 palette lines

.ClearPalFade:
	clr.w	(a2)					; Mark line as not fading

	adda.l	#pfdSize,a2				; Next line
	dbf	d0,.ClearPalFade			; Loop until all lines are marked

	rts

; --------------------------------------------------------------
; Run actors
; --------------------------------------------------------------

RunActors:
	move.b	p1_pause,d0				; Get actor run flag mask
	rol.b	#1,d0					; Actors can stop running if the game gets paused.
	andi.b	#1,d0					; This can be overridden with the upper 2 bits, so
	eori.b	#1,d0					; that an actor can continue running, even if paused.
	move.b	p2_pause,d1
	rol.b	#2,d1
	andi.b	#2,d1
	eori.b	#2,d1
	or.b	d0,d1
	ori.b	#%1100,d1

	lea	actors,a0				; Pointer to actor data
	move.w	#ACTOR_SLOT_COUNT-1,d0			; Number of actors

.ActorLoop:
	move.b	aRunFlags(a0),d2			; Should this actor run?
	and.b	d1,d2
	beq.w	.NextActor				; If not, branch

	movem.l	d0-d1,-(sp)				; Run actor
	movea.l	aAddr(a0),a1
	jsr	(a1)
	movem.l	(sp)+,d0-d1

.NextActor:
	adda.l	#aSize,a0				; Next actor
	dbf	d0,.ActorLoop				; Loop until all actors are run

	rts

; --------------------------------------------------------------
; Find and initialize an actor slot
; --------------------------------------------------------------
; PARAMETERS:
;	d0.b	- Initial flags
;	a1.l	- Pointer to actor code
; RETURNS:
;	cc/cs	- Found/Not found
;	a1.l	- Pointer to actor slot if found
; --------------------------------------------------------------

FindActorSlot:
	bsr.w	FindActorSlotQuick			; Quickly find a free slot
	bcc.w	.Loaded					; If one was found, branch
	movem.l	d0/a0,-(sp)				; Save registers

	lea	actors,a0				; Pointer to actor data
	move.w	#ACTOR_SLOT_COUNT-1,d0			; Number of actors

.FindSlot:
	btst	#7,aLoaded(a0)				; Is this slot marked as loaded?
	beq.w	.FoundSlot				; If not, branch
	adda.l	#aSize,a0				; Next actor
	dbf	d0,.FindSlot				; Loop until all actors are run

	movem.l	(sp)+,d0/a0				; Restore registers
	SET_CARRY					; Mark slot as not found
	rts

.FoundSlot:
	move.l	a1,aAddr(a0)				; Set actor code pointer
	movea.l	a0,a1					; Set returning actor slot pointer

	adda.l	#aFlags,a0				; Clear actor variables
	move.w	#(aSize-aFlags)/2-1,d0

.ClearSlot:
	move.w	#0,(a0)+
	dbf	d0,.ClearSlot

	movem.l	(sp)+,d0/a0				; Restore registers

.Loaded:
	ori.b	#$80,aLoaded(a1)			; Mark slot as loaded
	CLEAR_CARRY					; Mark slot as found
	rts

; --------------------------------------------------------------
; Find and initialize an actor slot (quick)
; --------------------------------------------------------------
; PARAMETERS:
;	d0.b	- Initial flags
;	a1.l	- Pointer to actor code
; RETURNS:
;	cc/cs	- Found/Not found
;	a1.l	- Pointer to actor slot if found
; --------------------------------------------------------------

FindActorSlotQuick:
	movem.l	d0/a0,-(sp)				; Save registers

	lea	actors,a0				; Pointer to actor data
	move.w	#ACTOR_SLOT_COUNT-1,d0			; Number of actors

.FindSlot:
	tst.w	aRunFlags(a0)				; Is this slot active?
	beq.w	.FoundSlot				; If not, branch
	adda.l	#aSize,a0				; Next actor
	dbf	d0,.FindSlot				; Loop until all actors are run

	movem.l	(sp)+,d0/a0				; Restore registers
	SET_CARRY					; Mark slot as not found
	rts

.FoundSlot:
	ori.w	#$FF00,d0				; Mark slot as active
	move.w	d0,aRunFlags(a0)
	move.l	a1,aAddr(a0)				; Set actor code pointer
	movea.l	a0,a1					; Set returning actor slot pointer

	movem.l	(sp)+,d0/a0				; Restore registers
	CLEAR_CARRY					; Mark slot as found
	rts

; --------------------------------------------------------------
; Have an actor delete itself
; --------------------------------------------------------------
; PARAMETERS:
;	a0.l	- Pointer to actor slot
; --------------------------------------------------------------

ActorDeleteSelf:
	movem.l	a2,-(sp)				; Save registers
	movea.l	a0,a2					; Delete ourselves
	bra.w	DeleteActor

; --------------------------------------------------------------
; Delete an actor
; --------------------------------------------------------------
; PARAMETERS:
;	a1.l	- Pointer to actor slot
; --------------------------------------------------------------

ActorDeleteOther:
	movem.l	a2,-(sp)				; Save registers
	movea.l	a1,a2					; Set actor to delete

; --------------------------------------------------------------
; Delete an actor
; --------------------------------------------------------------
; PARAMETERS:
;	a2.l	- Pointer to actor slot
; --------------------------------------------------------------

DeleteActor:
	movem.l	d0-d1,-(sp)				; Save registers

	moveq	#0,d0					; Clear slot data
	move.w	#aSize/4-1,d1

.Clear:
	move.l	d0,(a2)+
	dbf	d1,.Clear

	movem.l	(sp)+,d0-d1				; Restore registers
	movem.l	(sp)+,a2
	rts

; --------------------------------------------------------------
; Set a bookmark in an actor's code and set delay timer
; --------------------------------------------------------------
; PARAMETERS:
;	a0.l	- Pointer to actor slot
; --------------------------------------------------------------

ActorBookmark_SetDelay:
	move.w	d0,aDelay(a0)				; Set delay timer
	move.l	(sp)+,aAddr(a0)				; Bookmark actor code and exit
	rts

; --------------------------------------------------------------
; Set a bookmark in an actor's code (with delay timer handling)
; --------------------------------------------------------------
; PARAMETERS:
;	a0.l	- Pointer to actor slot
; --------------------------------------------------------------

ActorBookmark:
	tst.w	aDelay(a0)				; Is the delay timer active?
	beq.w	.Bookmark				; If not, branch
	subq.w	#1,aDelay(a0)				; Decrement delay time
	beq.w	.Bookmark				; If it has run out, branch

	move.l	(sp)+,d0				; Exit actor, but don't bookmark
	rts

.Bookmark:
	move.l	(sp)+,aAddr(a0)				; Bookmark actor code and exit
	rts

; --------------------------------------------------------------
; Set a bookmark in an actor's code (with delay timer and
; controller checks for bypassing the delay)
; --------------------------------------------------------------
; PARAMETERS:
;	a0.l	- Pointer to actor slot
; --------------------------------------------------------------

ActorBookmark_Ctrl:
	move.b	p1_ctrl+ctlPress,d0			; Has A, B, C, or start been pressed?
	or.b	p2_ctrl+ctlPress,d0
	andi.b	#$F0,d0
	bne.w	.Bookmark				; If so, branch

	tst.w	aDelay(a0)				; Is the delay timer active?
	beq.w	.Bookmark				; If not, branch
	subq.w	#1,aDelay(a0)				; Decrement delay time
	beq.w	.Bookmark				; If it has run out, branch

	move.l	(sp)+,d0				; Exit actor, but don't bookmark
	rts

.Bookmark:
	clr.w	aDelay(a0)				; Clear delay timer
	move.l	(sp)+,aAddr(a0)				; Bookmark actor code and exit
	rts

; --------------------------------------------------------------
; Process an actor's animation script
; --------------------------------------------------------------
; PARAMETERS:
;	cc/cs	- Set animation frame/Ran command
;	d0.b	- If an animation frame was set, frame ID
;	a0.l	- Pointer to actor slot
; --------------------------------------------------------------

ActorAnimate:
	tst.b	aAnimTime(a0)				; Is the animation timer active?
	beq.w	.ChkStop				; If not, branch
	subq.b	#1,aAnimTime(a0)			; Decrement animation time
	rts

.ChkStop:
	movea.l	aAnim(a0),a2				; Get pointer to animation data
	cmpi.b	#$FE,(a2)				; Is the next data block an animation frame?
	bcs.w	ActorParseAnim				; If so, branch
	bne.w	.Jump					; If it's a jump command, branch

.Stop:
	SET_CARRY					; Animation stops here, mark command as run
	rts

.Jump:
	movea.l	2(a2),a3				; Jump animation pointer
	movea.l	a3,a2
	bsr.w	ActorParseAnim

	SET_CARRY					; Mark command as run
	rts

; --------------------------------------------------------------
; Parse an actor's animation script
; --------------------------------------------------------------
; PARAMETERS:
;	a0.l	- Pointer to actor slot
;	a2.l	- Pointer to animation script
; RETURNS:
;	cc	- Animation frame set
;	d0.b	- Animation frame ID
; --------------------------------------------------------------

ActorParseAnim:
	move.b	(a2)+,d0				; Get animation time
	cmpi.b	#$F0,d0					; Should this be a random time?
	bcs.w	.GetFrame				; If not, branch
	bsr.w	ActorRandomAnimTime			; If so, generate a random time

.GetFrame:
	move.b	d0,aAnimTime(a0)			; Set animation time
	move.b	(a2)+,d0				; Set animation frame
	move.b	d0,aFrame(a0)
	move.l	a2,aAnim(a0)				; Update animation data pointer

	CLEAR_CARRY					; Mark animation frame as set
	rts

; --------------------------------------------------------------
; Get a random animation frame time
; --------------------------------------------------------------
; PARAMETERS:
;	d0.b	- Random animation time array ID
; RETURNS:
;	cs	- Random animation time used
;	d0.b	- Random animation time
; --------------------------------------------------------------

ActorRandomAnimTime:
	clr.w	d1					; Pick which set of times to use
	move.b	d0,d1
	lsl.b	#3,d1
	andi.b	#$38,d1

	bsr.w	Random					; Get random index
	andi.b	#7,d0

	clr.w	d2					; Get random animation time
	move.b	d0,d2
	add.w	d1,d2
	move.b	.AnimTimes(pc,d2.w),d0

	SET_CARRY					; Mark random animation time as used
	rts

; --------------------------------------------------------------

.AnimTimes:
	dc.b	$30, $60, $02, $6C, $40, $46, $50, $5C
	dc.b	$30, $60, $20, $6C, $40, $46, $50, $5C
	dc.b	$00, $00, $00, $00, $00, $46, $50, $5C
	dc.b	$80, $A0, $60, $78, $BD, $AA, $B4, $C0
	dc.b	$00, $00, $00, $00, $20, $10, $0C, $30
	dc.b	$30, $60, $00, $6C, $40, $46, $50, $5C
	dc.b	$30, $60, $00, $6C, $40, $46, $50, $5C
	dc.b	$30, $60, $00, $6C, $40, $46, $50, $5C

; --------------------------------------------------------------
; Handle actor movement
; --------------------------------------------------------------
; PARAMETERS:
;	a0.l	- Pointer to actor slot
; RETURNS:
;	cc/cs	- Onscreen/Offscreen
;	d0.b	- If offscreen:
;		      00 - Horizontally offscreen
;		      FF - Vertically offscreen
; --------------------------------------------------------------

ActorMove:
	move.b	aFlags(a0),d0				; Get flags

	bsr.w	ActorMoveX				; Move horizontally
	bsr.w	ActorMoveY				; Move vertically
	bsr.w	ActorMoveTowardsX			; Move towards horizontal target
	bsr.w	ActorMoveTowardsY			; Move towards vertical target
	
	CLEAR_CARRY					; Mark as onscreen
	rts

; --------------------------------------------------------------
; Handle actor horizontal movement
; --------------------------------------------------------------
; PARAMETERS:
;	a0.l	- Pointer to actor slot
; RETURNS:
;	cs	- Horizontally offscreen
;	d0.b	- If offscreen, 00
; --------------------------------------------------------------

ActorMoveX:
	btst	#1,d0					; Is horizontal movement enabled?
	bne.w	.DoMove					; If so, branch
	rts

.DoMove:
	move.l	aX(a0),d1				; Add X velocity to X position
	move.l	aXVel(a0),d2
	add.l	d2,d1

	btst	#5,d0					; Is horizontal offscreen checking disabled?
	bne.w	.UpdateX				; If so, branch

	swap	d1
	cmpi.w	#128,d1					; Are we past the left side of the screen?
	bcs.w	.Offscreen				; If so, branch
	cmpi.w	#320+128,d1				; Are we past the right side of the screen?
	bcc.w	.Offscreen				; If so, branch
	swap	d1

.UpdateX:
	move.l	d1,aX(a0)				; Update X position
	rts

.Offscreen:
	movem.l	(sp)+,d0				; Stop further movement
	move.b	#0,d0					; Mark as horizontally offscreen
	SET_CARRY					; Mark as offscreen
	rts

; --------------------------------------------------------------
; Handle actor vertical movement
; --------------------------------------------------------------
; PARAMETERS:
;	a0.l	- Pointer to actor slot
; RETURNS:
;	cs	- Vertically offscreen
;	d0.b	- If offscreen, FF
; --------------------------------------------------------------

ActorMoveY:
	btst	#0,d0					; Is veritcal movement enabled?
	bne.w	.DoMove					; If so, branch
	rts

.DoMove:
	move.l	aY(a0),d1				; Add Y velocity to Y position
	move.l	aYVel(a0),d2
	add.l	d2,d1

	btst	#4,d0					; Is vertical offscreen checking disabled?
	bne.w	.UpdateY				; If so, branch

	swap	d1
	cmpi.w	#128,d1					; Are we past the top of the screen?
	bcs.w	.Offscreen				; If so, branch
	cmpi.w	#224+128,d1				; Are we past the bottom of the screen?
	bcc.w	.Offscreen				; If so, branch
	swap	d1

.UpdateY:
	move.l	d1,aY(a0)				; Update Y position
	rts

.Offscreen:
	movem.l	(sp)+,d0				; Stop further movement
	move.b	#$FF,d0					; Mark as vertically offscreen
	SET_CARRY					; Mark as offscreen
	rts

; --------------------------------------------------------------
; Move an actor towards a target horizontally
; --------------------------------------------------------------
; PARAMETERS:
;	a0.l	- Pointer to actor slot
; --------------------------------------------------------------

ActorMoveTowardsX:
	btst	#3,d0					; Is the horizontal target enabled?
	bne.w	.DoMove					; If so, branch
	rts

.DoMove:
	move.w	aX(a0),d1				; Have we reached the target?
	cmp.w	aXTarget(a0),d1
	bcs.w	.LeftOfTarget				; If we are left of it, branch
	bne.w	.RightOfTarget				; If we are right of it, branch
	rts

.LeftOfTarget:
	clr.l	d1					; Shift velocity to move right towards the target
	move.w	aXAccel(a0),d1
	add.l	d1,aXVel(a0)
	rts

.RightOfTarget:
	clr.l	d1					; Shift velocity to move left towards the target
	move.w	aXAccel(a0),d1
	sub.l	d1,aXVel(a0)
	rts

; --------------------------------------------------------------
; Move an actor towards a target vertically
; --------------------------------------------------------------
; PARAMETERS:
;	a0.l	- Pointer to actor slot
; --------------------------------------------------------------

ActorMoveTowardsY:
	btst	#2,d0					; Is the vertical target enabled?
	bne.w	.DoMove					; If so, branch
	rts

.DoMove:
	move.w	aY(a0),d1				; Have we reached the target?
	cmp.w	aYTarget(a0),d1
	bcs.w	.AboveTarget				; If we are above it, branch
	bne.w	.BelowTarget				; If we are below it, branch
	rts

.AboveTarget:
	clr.l	d1					; Shift velocity to move down towards the target
	move.w	aYAccel(a0),d1
	add.l	d1,aYVel(a0)
	rts

.BelowTarget:
	clr.l	d1					; Shift velocity to move up towards the target
	move.w	aYAccel(a0),d1
	sub.l	d1,aYVel(a0)
	rts

; --------------------------------------------------------------