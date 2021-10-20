; --------------------------------------------------------------
; Bytecode instructions
; --------------------------------------------------------------

.Instructions:
	dc.l	Bytecode_Disable
	dc.l	Bytecode_FrameDone
	dc.l	Bytecode_Delay
	dc.l	Bytecode_WaitPalFade
	dc.l	Bytecode_Write
	dc.l	Bytecode_RunCode
	dc.l	Bytecode_Jump
	dc.l	Bytecode_JumpIfClear
	dc.l	Bytecode_JumpIfSet
	dc.l	Bytecode_JumpTable
	dc.l	Bytecode_VDPRegs
	dc.l	Bytecode_PuyoDec
	dc.l	Bytecode_PlaneCmdList
	dc.l	Bytecode_LoadPal
	dc.l	Bytecode_FadePal
	dc.l	Bytecode_PlaySound
	dc.l	Bytecode_PlaySnd_ChkPCM
	dc.l	Bytecode_FadeSound
	dc.l	Bytecode_StopSound
	dc.l	Bytecode_PlaySnd_ChkPCM2
	dc.l	Bytecode_NemDec
	dc.l	Bytecode_FadePal_Intro
	dc.l	Bytecode_PuyoDec_Intro
	
	if PuyoCompression=1
	dc.l    Bytecode_NemDec_Intro
	endc

; --------------------------------------------------------------
; Disable bytecode
; --------------------------------------------------------------

Bytecode_Disable:
	subq.l	#2,bytecode_addr
	move.b	#-1,bytecode_done
	move.b	#-1,bytecode_disabled
	rts

; --------------------------------------------------------------
; Stop running bytecode for this frame
; --------------------------------------------------------------

Bytecode_FrameDone:
	subq.l	#2,bytecode_addr
	move.b	#-1,bytecode_done
	rts

; --------------------------------------------------------------
; Delay running bytecode for a number of frames
; --------------------------------------------------------------
; PARAMETERS:
;	$00.w	- Number of frames to delay for
; --------------------------------------------------------------

Bytecode_Delay:
	move.b	#-1,bytecode_done
	move.b	#-1,bytecode_disabled

	lea	ActBytecodeDelay,a1
	bsr.w	FindActorSlot
	bcc.w	.Spawned
	rts

.Spawned:
	move.w	d0,aDelay(a1)
	rts

; --------------------------------------------------------------
; Bytecode delay actor
; --------------------------------------------------------------

ActBytecodeDelay:
	bsr.w	ActorBookmark

.Done:
	clr.b	bytecode_disabled
	bra.w	ActorDeleteSelf

; --------------------------------------------------------------
; Wait for a palette fade to end
; --------------------------------------------------------------

Bytecode_WaitPalFade:
	subq.l	#2,bytecode_addr
	move.b	#-1,bytecode_done
	move.b	#-1,bytecode_disabled

	lea	ActWaitPalFade,a1
	bra.w	FindActorSlot

; --------------------------------------------------------------
; Palette fade wait actor
; --------------------------------------------------------------

ActWaitPalFade:
	bsr.w	CheckPaletteFade
	bcc.w	.Done
	rts

.Done:
	clr.b	bytecode_disabled
	bra.w	ActorDeleteSelf

; --------------------------------------------------------------
; Check if a palette fade is occurring
; --------------------------------------------------------------
; RETURNS:
;	cc/cs	- Not occurring/Occurring
; --------------------------------------------------------------

CheckPaletteFade:
	lea	pal_fade_data,a2
	move.w	#4-1,d0

.LineCheck:
	tst.w	(a2)
	bne.w	.IsFading

	adda.l	#$82,a2
	dbf	d0,.LineCheck

	CLEAR_CARRY
	rts

.IsFading:
	SET_CARRY
	rts
	
; --------------------------------------------------------------
; Write a word to an address
; --------------------------------------------------------------
; PARAMETERS:
;	00.l	- Destination address
;	04.w	- Value to write
; --------------------------------------------------------------

Bytecode_Write:
	movea.l	bytecode_addr,a0
	swap	d0
	move.w	(a0)+,d0
	move.w	(a0)+,d1
	move.l	a0,bytecode_addr
	movea.l	d0,a0

	move.w	d1,(a0)
	rts

; --------------------------------------------------------------
; Run code
; --------------------------------------------------------------
; PARAMETERS:
;	00.l	- Code address
; --------------------------------------------------------------

Bytecode_RunCode:
	movea.l	bytecode_addr,a0
	swap	d0
	move.w	(a0)+,d0
	move.l	a0,bytecode_addr
	movea.l	d0,a0

	jmp	(a0)

; --------------------------------------------------------------
; Jump to an address in bytecode
; --------------------------------------------------------------
; PARAMETERS:
;	00.l	- Jump address
; --------------------------------------------------------------

Bytecode_Jump:
	movea.l	bytecode_addr,a0
	swap	d0
	move.w	(a0),d0

	move.l	d0,bytecode_addr
	rts

; --------------------------------------------------------------
; Jump to an address in bytecode if the bytecode flag is clear
; --------------------------------------------------------------
; PARAMETERS:
;	00.l	- Jump address
; --------------------------------------------------------------

Bytecode_JumpIfClear:
	tst.b	bytecode_flag
	beq.s	Bytecode_Jump

	addq.l	#2,bytecode_addr
	rts

; --------------------------------------------------------------
; Jump to an address in bytecode if the bytecode flag is set
; --------------------------------------------------------------
; PARAMETERS:
;	00.l	- Jump address
; --------------------------------------------------------------

Bytecode_JumpIfSet:
	tst.b	bytecode_flag
	bne.s	Bytecode_Jump

	addq.l	#2,bytecode_addr
	rts

; --------------------------------------------------------------
; Jump to an address in bytecode from a table using the
; bytecode flag as an index
; --------------------------------------------------------------
; PARAMETERS:
;	00.w	- Number of addresses
;	02.l	- Address 1
;	06.l	- Address 2
;	NN.l	- Address N
; --------------------------------------------------------------

Bytecode_JumpTable:
	movea.l	bytecode_addr,a0

	clr.w	d1
	move.b	bytecode_flag,d1

	cmp.w	d0,d1
	bcs.w	.Jump
	move.w	d0,d1
	subq.w	#1,d1

.Jump:
	lsl.w	#2,d1
	move.l	(a0,d1.w),d2
	move.l	d2,bytecode_addr
	rts

; --------------------------------------------------------------
; Set up VDP registers
; --------------------------------------------------------------
; PARAMETERS:
;	00.w	- VDP register table ID
; --------------------------------------------------------------

Bytecode_VDPRegs:
	bra.w	SetupVDPRegs_DisplayOn

; --------------------------------------------------------------
; Decompress Puyo compressed art
; --------------------------------------------------------------
; PARAMETERS:
;	00.w	- VRAM address
;	02.l	- Pointer to compressed art
; --------------------------------------------------------------

Bytecode_PuyoDec:
	movea.l	bytecode_addr,a1
	movea.l	(a1)+,a0
	move.l	a1,bytecode_addr

	bra.w	PuyoDec

; --------------------------------------------------------------
; Decompress Puyo compressed art (also checks if the Robotnik
; intro cutscene is active, and if so, it forces the VRAM
; address to be $2000)
; --------------------------------------------------------------
; PARAMETERS:
;	00.w	- VRAM address
;	02.l	- Pointer to compressed art
; --------------------------------------------------------------

Bytecode_PuyoDec_Intro:
	cmpi.b	#$F,level
	bne.s	.NotRobotnik
	move.w	#$2000,d0

.NotRobotnik:
	movea.l	bytecode_addr,a1
	movea.l	(a1)+,a0
	move.l	a1,bytecode_addr

	bra.w	PuyoDec

; --------------------------------------------------------------
; Decompress Nemesis compressed art
; --------------------------------------------------------------
; PARAMETERS:
;	00.w	- VRAM address
;	02.l	- Pointer to compressed art
; --------------------------------------------------------------

Bytecode_NemDec:
	movea.l	bytecode_addr,a1
	movea.l	(a1)+,a0
	move.l	a1,bytecode_addr

	DISABLE_INTS
	jsr	NemDec
	ENABLE_INTS
	rts
	
	if PuyoCompression=1
; --------------------------------------------------------------
; Decompress Nemesis compressed art (also checks if the Robotnik
; stage cutscene is active, and if so, it forces the VRAM
; address to be $2000)
; --------------------------------------------------------------
; PARAMETERS:
;	00.w	- VRAM address
;	02.l	- Pointer to compressed art
; --------------------------------------------------------------

Bytecode_NemDec_Intro:
	cmpi.b	#$F,level
	bne.s	.NotRobotnik
	move.w	#$2000,d0

.NotRobotnik:
	movea.l	bytecode_addr,a1
	movea.l	(a1)+,a0
	move.l	a1,bytecode_addr

	DISABLE_INTS
	jsr	NemDec
	ENABLE_INTS
	endc

; --------------------------------------------------------------
; Queue a plane command list
; --------------------------------------------------------------
; PARAMETERS:
;	00.w	- Plane command list ID
; --------------------------------------------------------------

Bytecode_PlaneCmdList:
	bra.w	QueuePlaneCmdList

; --------------------------------------------------------------
; Fade to palette
; --------------------------------------------------------------
; PARAMETERS:
;	00.w	- Palette table offset/Palette line
;	02.b	- Fade speed
;	03.b	- Unused
; --------------------------------------------------------------

Bytecode_FadePal:
	move.b	d0,d1
	lsr.w	#3,d0
	andi.l	#$1FFF,d0
	lea	Palettes,a2
	adda.l	d0,a2

	move.b	d1,d0
	movea.l	bytecode_addr,a0
	move.b	(a0)+,d1
	move.b	(a0)+,d2
	move.l	a0,bytecode_addr

	bra.w	FadeToPalette

; --------------------------------------------------------------
; Fade to palette (also checks if the Robotnik intro cutscene
; is active, and if so, use the alternate palette)
; --------------------------------------------------------------
; PARAMETERS:
;	00.w	- Palette table offset/Palette line
;	02.b	- Fade speed
;	03.b	- Alternate palette table offset
;
;	[Robotnik intro cutscene active]
;	00.w	- Palette line
;	02.b	- Fade speed
;	03.b	- Palette table ID
; --------------------------------------------------------------

Bytecode_FadePal_Intro:
	tst.b	use_lair_background
	bne.s	.RobotniksLair

	move.b	d0,d1
	lsr.w	#3,d0
	andi.l	#$1FFF,d0
	move.w	d0,d3
	lea	Palettes,a2
	adda.l	d0,a2

	move.b	d1,d0
	movea.l	bytecode_addr,a0
	move.b	(a0)+,d1
	move.b	(a0)+,d2
	move.l	a0,bytecode_addr

	tst.w	d3
	beq.s	.End
	bra.w	FadeToPalette

.End:
	rts

.RobotniksLair:
	moveq	#0,d2
	movea.l	bytecode_addr,a0
	move.b	(a0)+,d1
	move.b	(a0)+,d2
	move.l	a0,bytecode_addr

	lea	Palettes,a2
	asl.w	#5,d2
	adda.w	d2,a2

	bra.w	FadeToPalette

; --------------------------------------------------------------
; Load a palette
; --------------------------------------------------------------
; PARAMETERS
;	00.w	- Palette table offset/Palette line
; --------------------------------------------------------------

Bytecode_LoadPal:
	move.b	d0,d1
	lsr.w	#3,d0
	andi.l	#$1FFF,d0
	lea	Palettes,a2
	adda.l	d0,a2
	move.b	d1,d0

	bra.w	LoadPalette

; --------------------------------------------------------------
; Play a sound
; --------------------------------------------------------------
; PARAMETERS
;	00.w	- Sound ID
; --------------------------------------------------------------

Bytecode_PlaySound:
	jmp	JmpTo_PlaySound

; --------------------------------------------------------------
; Play a sound (checks if PCM is enabled)
; --------------------------------------------------------------
; PARAMETERS
;	00.w	- Sound ID
; --------------------------------------------------------------

Bytecode_PlaySnd_ChkPCM:
	jmp	PlaySound_ChkPCM

; --------------------------------------------------------------
; Fade out sound
; --------------------------------------------------------------

Bytecode_FadeSound:
	subq.l	#2,bytecode_addr
	jmp	FadeSound

; --------------------------------------------------------------
; Stop all sounds
; --------------------------------------------------------------

Bytecode_StopSound:
	subq.l	#2,bytecode_addr
	jmp	StopSound

; --------------------------------------------------------------
; Play a sound (checks if PCM is enabled)
; --------------------------------------------------------------
; PARAMETERS
;	00.w	- Sound ID
; --------------------------------------------------------------

Bytecode_PlaySnd_ChkPCM2:
	jmp	PlaySound_ChkPCM
