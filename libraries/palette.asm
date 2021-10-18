; --------------------------------------------------------------
;
;	Dr. Robotnik's Mean Bean Machine Disassembly
;	Original game by Compile
;
;	Disassembled by Devon Artmeier
;
; --------------------------------------------------------------

; --------------------------------------------------------------
; Fade to palette with an amount of steps
; --------------------------------------------------------------
; PARAMETERS:
;	d0.w	- Palette line
;	d1.b	- Fade speed
;	d2.b	- Step count
;	a2.l	- Target palette
; --------------------------------------------------------------

FadeToPal_StepCount:
	lea	ActPalFade,a1				; Load palette fade actor
	bsr.w	FindActorSlot
	bcc.w	.Spawned				; If it has spawned, branch
	rts

.Spawned:
	andi.b	#7,d2					; Set number of palette fade steps
	addq.b	#1,d2
	move.b	d2,pfSteps+1(a1)

	bra.w	FadeToPal_Setup				; Setup palette fade

; --------------------------------------------------------------
; Fade to palette
; --------------------------------------------------------------
; PARAMETERS:
;	d0.w	- Palette line
;	d1.b	- Fade speed
;	a2.l	- Target palette
; --------------------------------------------------------------

FadeToPalette:
	lea	ActPalFade,a1				; Load palette fade actor
	bsr.w	FindActorSlot
	bcc.w	.Spawned				; If it has spawned, branch
	rts

.Spawned:
	move.w	#8,pfSteps(a1)				; Fade the palette fully

; --------------------------------------------------------------

FadeToPal_Setup:
	andi.w	#3,d0					; Set palette line
	move.w	d0,pfLine(a1)
	move.b	d1,pfSpeed+1(a1)			; Set fade speed

	mulu.w	#pfdSize,d0				; Set pointer to palette fade data
	lea	pal_fade_data,a3
	adda.l	d0,a3
	move.l	a3,pfData(a1)
	addq.w	#1,(a3)					; Mark as fading
	move.w	(a3),pfFlag(a1)				; Make a copy of the fading flag

	movem.l	a2,-(sp)

	clr.l	d0					; Split up this palette line for fading
	move.w	pfLine(a1),d0
	lsl.l	#5,d0
	lea	palette_buffer,a2
	adda.l	d0,a2
	adda.l	#2,a3
	bsr.w	ActPalFade_Split

	movem.l	(sp)+,a2

	movea.l	pfData(a1),a3				; Split up the target palette for fading into
	adda.l	#pfdAccums,a3
	bsr.w	ActPalFade_Split

	bsr.w	ActPalFade_GetAccums			; Get fade accumulators
	rts

; --------------------------------------------------------------
; Palette fade actor
; --------------------------------------------------------------

pfLine		EQU	$08				; Palette fade line
pfData		EQU	$0E				; Palette fade data pointer
pfFlag		EQU	$12				; Palette fade flag
pfTimer		EQU	$26				; Palette fade timer
pfSpeed		EQU	$28				; Palette fade speed
pfSteps		EQU	$2A				; Palette fade steps

; --------------------------------------------------------------

ActPalFade:
	move.w	pfFlag(a0),d0				; Has palette fading ended prematurely?
	movea.l	pfData(a0),a2
	cmp.w	(a2),d0
	bne.w	ActorDeleteSelf				; If so, branch

	addq.w	#1,pfTimer(a0)				; Increment fade timer
	move.w	pfSpeed(a0),d0
	cmp.w	pfTimer(a0),d0				; Is it time to continue fading?
	bcs.w	.DoFade					; If so, branch
	rts

.DoFade:
	clr.w	pfTimer(a0)				; Reset fade timer
	bsr.w	ActPalFade_DoFade			; Do fading

	subq.w	#1,pfSteps(a0)				; Decrement fade step counter
	beq.w	.Done					; If we are done, branch
	rts

.Done:
	movea.l	pfData(a0),a2				; Mark fading as done
	clr.w	(a2)

	bra.w	ActorDeleteSelf				; Delete ourselves

; --------------------------------------------------------------
; Perform palette fading
; --------------------------------------------------------------
; PARAMETERS:
;	a0.l	- Pointer to palette fade actor data
; --------------------------------------------------------------

ActPalFade_DoFade:
	movea.l	pfData(a0),a2				; Get pointer to palette fade data
	movea.l	a2,a3
	adda.l	#pfdSplitPal,a2				; Get pointer to split palette data
	adda.l	#pfdAccums,a3				; Get pointer to fade accumulators

	move.w	#($10*3)-1,d0				; 16*3 color channels in a palette line

.Fade:
	move.b	(a3,d0.w),d1				; Fade each color channel
	add.b	d1,(a2,d0.w)
	dbf	d0,.Fade				; Loop until every color channel has faded

	adda.l	#pfdMDPal-pfdAccums,a3			; Get pointer to compiled palette buffer
	bsr.w	ActPalFade_CompilePal			; Compile the palette

	movea.l	pfData(a0),a2				; Load the compiled palette
	adda.l	#pfdMDPal,a2
	move.w	pfLine(a0),d0
	bra.w	LoadPalette

; --------------------------------------------------------------
; Get accumulators for palette fading
; --------------------------------------------------------------
; PARAMETERS:
;	a1.l	- Pointer to palette fade actor slot
; --------------------------------------------------------------

ActPalFade_GetAccums:
	movea.l	pfData(a1),a2				; Get pointer to palette fade data
	movea.l	a2,a3
	adda.l	#pfdSplitPal,a2				; Get pointer to split palette data
	adda.l	#pfdAccums,a3				; Get pointer to fade accumulators

	move.w	#($10*3)-1,d0				; 16*3 color channels in a palette line

.GetAccums:
	move.b	(a3),d1					; Color channel fade accumulator =
	sub.b	(a2)+,d1				; (Target palette color - Current palette color) / 8
	asr.b	#3,d1
	move.b	d1,(a3)+
	dbf	d0,.GetAccums				; Loop until all of the accumulators have been calculated

	rts

; --------------------------------------------------------------
; Split palette for fading
; --------------------------------------------------------------
; PARAMETERS:
;	a2.l	- Palette buffer
;	a3.l	- Palette fade data color buffer
; --------------------------------------------------------------

ActPalFade_Split:
	move.w	#$10-1,d0				; 16 colors in a palette line

.Split:
	move.b	(a2)+,d1				; Split out blue channel
	lsl.b	#3,d1
	andi.b	#$70,d1
	move.b	d1,(a3)+
	
	move.b	(a2),d1					; Split out green channel
	lsl.b	#3,d1
	andi.b	#$70,d1
	move.b	d1,(a3)+
	
	move.b	(a2)+,d1				; Split out red channel
	lsr.b	#1,d1
	andi.b	#$70,d1
	move.b	d1,(a3)+

	dbf	d0,.Split				; Loop until all the colors have been split
	rts

; --------------------------------------------------------------
; Get Mega Drive compatible palette from palette fade data
; --------------------------------------------------------------
; PARAMETERS:
;	a2.l	- Palette fade data color buffer
;	a3.l	- Palette buffer
; --------------------------------------------------------------

ActPalFade_CompilePal:
	move.w	#$10-1,d0				; 16 colors in a palette line

.Combine:
	bsr.w	ActPalFade_GetColorChan			; Compile blue channel
	lsr.b	#3,d1
	andi.b	#$E,d1
	move.b	d1,(a3)+

	bsr.w	ActPalFade_GetColorChan			; Compile green channel
	move.b	d1,d2
	lsr.b	#3,d2
	andi.b	#$E,d2
	
	bsr.w	ActPalFade_GetColorChan			; Compile red channel
	lsl.b	#1,d1
	andi.b	#$E0,d1
	or.b	d2,d1
	move.b	d1,(a3)+

	dbf	d0,.Combine				; Loop until all the colors have compiled
	rts

; --------------------------------------------------------------
; Get color channel from palette fade data
; --------------------------------------------------------------
; PARAMETERS:
;	a2.l	- Palette fade data color buffer
; RETURNS:
;	d1.b	- Color channel value
; --------------------------------------------------------------

ActPalFade_GetColorChan:
	move.b	(a2)+,d1				; Get color channel value
	btst	#1,d1					; Should this value be rounded up?
	beq.w	.End					; If not, branch
	addq.b	#4,d1					; Round this value up

.End:
	rts

; --------------------------------------------------------------
; Initialize the palette buffer (interrupt safe)
; --------------------------------------------------------------

InitPaletteSafe:
	DISABLE_INTS					; Disable interrupts
	bsr.w	InitPalette				; Initialize the palette
	ENABLE_INTS					; Enable interrupts

	rts

; --------------------------------------------------------------
; Initialize the palette buffer
; --------------------------------------------------------------

InitPalette:
	moveq	#0,d0					; Clear the palette buffer
	lea	palette_buffer,a2
	move.w	#$80/4-1,d1

.ClearPal:
	move.l	d0,(a2)+
	dbf	d1,.ClearPal

; --------------------------------------------------------------
; Refresh palette
; --------------------------------------------------------------

RefreshPalette:
	lea	pal_load_queue,a2			; Queue palette buffer for loading
	move.w	#-1,(a2)+
	move.l	#palette_buffer,(a2)+
	move.w	#-1,(a2)+
	move.l	#palette_buffer+$20,(a2)+
	move.w	#-1,(a2)+
	move.l	#palette_buffer+$40,(a2)+
	move.w	#-1,(a2)+
	move.l	#palette_buffer+$60,(a2)+

	rts

; --------------------------------------------------------------
; Invert the palette
; --------------------------------------------------------------

InvertPalette:
	lea	palette_buffer,a2			; Get pointer to palette buffer
	move.w	#$40-1,d0				; 64 colors in a palette

.InvertLoop:
	move.w	(a2),d1					; Invert color
	eori.w	#$EEE,d1
	move.w	d1,(a2)+
	dbf	d0,.InvertLoop				; Loop until all colors have been inverted

	bra.s	RefreshPalette				; Refresh the palette

; --------------------------------------------------------------
; Load a palette
; --------------------------------------------------------------
; PARAMETERS
;	d0.w	- Palette line
;	a2.l	- Pointer to palette data
; --------------------------------------------------------------

LoadPalette:
	movem.l	d1/a3,-(sp)				; Save registers
	
	andi.w	#3,d0					; Get palette load queue offset
	lsl.w	#1,d0
	move.w	d0,d1
	lsl.w	#1,d0
	add.w	d1,d0

	lea	pal_load_queue,a3			; Queue palette for loading
	move.l	a2,2(a3,d0.w)
	move.w	#-1,(a3,d0.w)

	movem.l	(sp)+,d1/a3				; Restore registers
	rts

; --------------------------------------------------------------