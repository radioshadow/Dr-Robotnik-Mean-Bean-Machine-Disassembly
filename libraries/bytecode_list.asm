; --------------------------------------------------------------
;
;	Dr. Robotnik's Mean Bean Machine Disassembly
;	Original game by Compile
;
;	Disassembled by Devon Artmeier
;
; --------------------------------------------------------------

; --------------------------------------------------------------
; Initialize bytecode
; --------------------------------------------------------------

InitBytecode:
	move.l	#Bytecode,bytecode_addr			; Set bytecode address

	clr.b	bytecode_flag				; Clear bytecode flag
	clr.b	bytecode_disabled			; Enable the bytecode

	rts

; --------------------------------------------------------------
; Run bytecode
; --------------------------------------------------------------

RunBytecode:
	tst.b	bytecode_disabled			; Is the bytecode disabled?
	beq.w	.Run					; If not, branch
	rts

.Run:
	clr.b	bytecode_done				; Clear bytecode done flag

	movea.l	bytecode_addr,a0			; Get bytecode instruction and parameter
	move.w	(a0)+,d1
	move.w	(a0)+,d0
	move.l	a0,bytecode_addr

	asl.w	#2,d1					; Execute instruction
	movea.l	.Instructions(pc,d1.w),a0
	jsr	(a0)

	tst.b	bytecode_done				; Is the bytecode done for this frame?
	beq.s	.Run					; If not, branch

	rts

; --------------------------------------------------------------

.Instructions:
	dc.l	Bytecode_Disable			; 00 - Disable
	dc.l	Bytecode_FrameDone			; 01 - Frame done
	dc.l	Bytecode_Delay				; 02 - Delay
	dc.l	Bytecode_WaitPalFade			; 03 - Wait for palette fade to end
	dc.l	Bytecode_Write				; 04 - Write to address
	dc.l	Bytecode_RunCode			; 05 - Run code
	dc.l	Bytecode_Jump				; 06 - Jump to address
	dc.l	Bytecode_JumpIfClear			; 07 - Jump if flag is clear
	dc.l	Bytecode_JumpIfSet			; 08 - Jump if flag is set
	dc.l	Bytecode_JumpTable			; 09 - Jump with address table
	dc.l	Bytecode_VDPRegs			; 0A - Set VDP registers
	dc.l	Bytecode_PuyoDec			; 0B - Decompress Puyo art
	dc.l	Bytecode_PlaneCmdList			; 0C - Queue plane command list
	dc.l	Bytecode_LoadPal			; 0D - Load palette
	dc.l	Bytecode_FadePal			; 0E - Fade to palette
	dc.l	Bytecode_PlaySound			; 0F - Play sound
	dc.l	Bytecode_PlaySnd_ChkSamp		; 10 - Play sound (checks if sampling is enabled)
	dc.l	Bytecode_FadeSound			; 11 - Fade out sound
	dc.l	Bytecode_StopSound			; 12 - Stop sound
	dc.l	Bytecode_PlaySnd_ChkSamp2		; 13 - Play sound (checks if sampling is enabled)
	dc.l	Bytecode_NemDec				; 14 - Decompress Nemesis art
	dc.l	Bytecode_FadePal_Cutscene		; 15 - Fade to palette (for cutscenes)
	dc.l	Bytecode_PuyoDec_Cutscene		; 16 - Decompress Puyo art (for cutscenes)
	
	if PuyoCompression=1
	dc.l	Bytecode_NemDec_Cutscene		; 17 - Decompress Nem art (for cutscenes)
	endc

; --------------------------------------------------------------
; Disable bytecode
; --------------------------------------------------------------

Bytecode_Disable:
	subq.l	#2,bytecode_addr			; No parameters
	move.b	#-1,bytecode_done			; Mark as done for this frame
	move.b	#-1,bytecode_disabled			; Disable bytecode

	rts

; --------------------------------------------------------------
; Stop running bytecode for this frame
; --------------------------------------------------------------

Bytecode_FrameDone:
	subq.l	#2,bytecode_addr			; No parameters
	move.b	#-1,bytecode_done			; Mark as done for this frame

	rts

; --------------------------------------------------------------
; Delay running bytecode for a number of frames
; --------------------------------------------------------------
; PARAMETERS:
;	$00.w	- Number of frames to delay for
; --------------------------------------------------------------

Bytecode_Delay:
	move.b	#-1,bytecode_done			; Mark as done for this frame
	move.b	#-1,bytecode_disabled			; Disable bytecode

	lea	ActBytecodeDelay,a1			; Load bytecode delay actor
	bsr.w	FindActorSlot
	bcc.w	.Spawned				; If it was spawned, branch
	rts

.Spawned:
	move.w	d0,aDelay(a1)				; Set delay time
	rts

; --------------------------------------------------------------
; Bytecode delay actor
; --------------------------------------------------------------

ActBytecodeDelay:
	bsr.w	ActorBookmark				; Bookmark and handle delay

; --------------------------------------------------------------

ActBytecodeDelay_Done:
	clr.b	bytecode_disabled			; Reenable bytecode
	bra.w	ActorDeleteSelf				; Delete ourselves

; --------------------------------------------------------------
; Wait for a palette fade to end
; --------------------------------------------------------------

Bytecode_WaitPalFade:
	subq.l	#2,bytecode_addr			; No parameters
	move.b	#-1,bytecode_done			; Mark as done for this frame
	move.b	#-1,bytecode_disabled			; Disable bytecode

	lea	ActWaitPalFade,a1			; Load palette fade wait actor
	bra.w	FindActorSlot

; --------------------------------------------------------------
; Palette fade wait actor
; --------------------------------------------------------------

ActWaitPalFade:
	bsr.w	CheckPaletteFade			; Check if palette fading is done
	bcc.w	.Done					; If it is, branch
	rts

.Done:
	clr.b	bytecode_disabled			; Reenable bytecode
	bra.w	ActorDeleteSelf				; Delete ourselves

; --------------------------------------------------------------
; Check if a palette fade is occurring
; --------------------------------------------------------------
; RETURNS:
;	cc/cs	- Not occurring/Occurring
; --------------------------------------------------------------

CheckPaletteFade:
	lea	pal_fade_data,a2			; Get palette fade data pointer
	move.w	#4-1,d0					; 4 palette lines

.LineCheck:
	tst.w	(a2)					; Is this line done fading?
	bne.w	.IsFading				; If not, branch

	adda.l	#pfdSize,a2				; Next line
	dbf	d0,.LineCheck				; Loop until all lines are checked

	CLEAR_CARRY					; Mark palette fading as not occurring
	rts

.IsFading:
	SET_CARRY					; Mark palette fading as occurring
	rts
	
; --------------------------------------------------------------
; Write a word to an address
; --------------------------------------------------------------
; PARAMETERS:
;	00.l	- Destination address
;	04.w	- Value to write
; --------------------------------------------------------------

Bytecode_Write:
	movea.l	bytecode_addr,a0			; Get address and value
	swap	d0
	move.w	(a0)+,d0
	move.w	(a0)+,d1
	move.l	a0,bytecode_addr

	movea.l	d0,a0					; Write value to address
	move.w	d1,(a0)
	rts

; --------------------------------------------------------------
; Run code
; --------------------------------------------------------------
; PARAMETERS:
;	00.l	- Code address
; --------------------------------------------------------------

Bytecode_RunCode:
	movea.l	bytecode_addr,a0			; Get address
	swap	d0
	move.w	(a0)+,d0
	move.l	a0,bytecode_addr

	movea.l	d0,a0					; Run code
	jmp	(a0)

; --------------------------------------------------------------
; Jump to an address in bytecode
; --------------------------------------------------------------
; PARAMETERS:
;	00.l	- Jump address
; --------------------------------------------------------------

Bytecode_Jump:
	movea.l	bytecode_addr,a0			; Jump to address
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
	tst.b	bytecode_flag				; Is the bytecode flag clear?
	beq.s	Bytecode_Jump				; If so, branch
	addq.l	#2,bytecode_addr			; Skip jump instruction

	rts

; --------------------------------------------------------------
; Jump to an address in bytecode if the bytecode flag is set
; --------------------------------------------------------------
; PARAMETERS:
;	00.l	- Jump address
; --------------------------------------------------------------

Bytecode_JumpIfSet:
	tst.b	bytecode_flag				; Is the bytecode flag set?
	bne.s	Bytecode_Jump				; If so, branch
	addq.l	#2,bytecode_addr			; Skip jump instruction

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
	movea.l	bytecode_addr,a0			; Get pointer to address table

	clr.w	d1					; Get table index
	move.b	bytecode_flag,d1

	cmp.w	d0,d1					; Is the index greater than the number of entries?
	bcs.w	.Jump					; If not, branch
	move.w	d0,d1					; Cap the index
	subq.w	#1,d1

.Jump:
	lsl.w	#2,d1					; Jump to address
	move.l	(a0,d1.w),d2
	move.l	d2,bytecode_addr

	rts

; --------------------------------------------------------------
; Setup VDP registers
; --------------------------------------------------------------
; PARAMETERS:
;	00.w	- VDP register table ID
; --------------------------------------------------------------

Bytecode_VDPRegs:
	bra.w	SetupVDPRegsSafe			; Set VDP registers

; --------------------------------------------------------------
; Decompress Puyo compressed art
; --------------------------------------------------------------
; PARAMETERS:
;	00.w	- VRAM address
;	02.l	- Pointer to compressed art
; --------------------------------------------------------------

Bytecode_PuyoDec:
	movea.l	bytecode_addr,a1			; Get art address
	movea.l	(a1)+,a0
	move.l	a1,bytecode_addr

	bra.w	PuyoDec					; Decompress art

; --------------------------------------------------------------
; Decompress Puyo compressed art (also checks if the Robotnik
; stage cutscene is active, and if so, it forces the VRAM
; address to be $2000)
; --------------------------------------------------------------
; PARAMETERS:
;	00.w	- VRAM address
;	02.l	- Pointer to compressed art
; --------------------------------------------------------------

Bytecode_PuyoDec_Cutscene:
	cmpi.b	#$F,stage				; Is this the Robotnik stage cutscene?
	bne.s	.NotRobotnik				; If not, branch
	move.w	#$2000,d0				; Force VRAM address to $2000

.NotRobotnik:
	movea.l	bytecode_addr,a1			; Get art address
	movea.l	(a1)+,a0
	move.l	a1,bytecode_addr

	bra.w	PuyoDec					; Decompress art
	
; --------------------------------------------------------------
; Decompress Nemesis compressed art
; --------------------------------------------------------------
; PARAMETERS:
;	00.w	- VRAM address
;	02.l	- Pointer to compressed art
; --------------------------------------------------------------

Bytecode_NemDec:
	movea.l	bytecode_addr,a1			; Get art address
	movea.l	(a1)+,a0
	move.l	a1,bytecode_addr

	DISABLE_INTS					; Decompress art
	jsr	NemDec
	ENABLE_INTS

	rts

; --------------------------------------------------------------
; Queue a plane command list
; --------------------------------------------------------------
; PARAMETERS:
;	00.w	- Plane command list ID
; --------------------------------------------------------------

Bytecode_PlaneCmdList:
	bra.w	QueuePlaneCmdList			; Queue plane command list

; --------------------------------------------------------------
; Fade to palette
; --------------------------------------------------------------
; PARAMETERS:
;	00.w	- Palette table offset/Palette line
;	02.b	- Fade speed
;	03.b	- Unused
; --------------------------------------------------------------

Bytecode_FadePal:
	move.b	d0,d1					; Get pointer to palette
	lsr.w	#3,d0
	andi.l	#$1FFF,d0
	lea	Palettes,a2
	adda.l	d0,a2
	move.b	d1,d0

	movea.l	bytecode_addr,a0			; Get fade speed and unused parameter
	move.b	(a0)+,d1
	move.b	(a0)+,d2
	move.l	a0,bytecode_addr

	bra.w	FadeToPalette				; Fade to palette

; --------------------------------------------------------------
; Fade to palette (also checks if the Robotnik stage cutscene
; is active, and if so, use the alternate palette)
; --------------------------------------------------------------
; PARAMETERS:
;	00.w	- Palette table offset/Palette line
;	02.b	- Fade speed
;	03.b	- Alternate palette table offset
; --------------------------------------------------------------

Bytecode_FadePal_Cutscene:
	tst.b	use_lair_background			; Are we in Robotnik's lair?
	bne.s	.RobotniksLair				; If so, branch

	move.b	d0,d1					; Get pointer to palette
	lsr.w	#3,d0
	andi.l	#$1FFF,d0
	move.w	d0,d3
	lea	Palettes,a2
	adda.l	d0,a2
	move.b	d1,d0

	movea.l	bytecode_addr,a0			; Get fade speed and unused parameter
	move.b	(a0)+,d1
	move.b	(a0)+,d2
	move.l	a0,bytecode_addr

	tst.w	d3					; Were we fading to black?
	beq.s	.End					; If so, branch
	bra.w	FadeToPalette				; Fade to palette

.End:
	rts

.RobotniksLair:
	moveq	#0,d2					; Get fade speed and palette offset
	movea.l	bytecode_addr,a0
	move.b	(a0)+,d1
	move.b	(a0)+,d2
	move.l	a0,bytecode_addr

	lea	Palettes,a2				; Get pointer to palette
	asl.w	#5,d2
	adda.w	d2,a2

	bra.w	FadeToPalette				; Fade to palette

; --------------------------------------------------------------
; Load a palette
; --------------------------------------------------------------
; PARAMETERS
;	00.w	- Palette table offset/Palette line
; --------------------------------------------------------------

Bytecode_LoadPal:
	move.b	d0,d1					; Get pointer to palette
	lsr.w	#3,d0
	andi.l	#$1FFF,d0
	lea	Palettes,a2
	adda.l	d0,a2
	move.b	d1,d0

	bra.w	LoadPalette				; Load palette

; --------------------------------------------------------------
; Play a sound
; --------------------------------------------------------------
; PARAMETERS
;	00.w	- Sound ID
; --------------------------------------------------------------

Bytecode_PlaySound:
	jmp	JmpTo_PlaySound				; Play sound

; --------------------------------------------------------------
; Play a sound (checks if PCM is enabled)
; --------------------------------------------------------------
; PARAMETERS
;	00.w	- Sound ID
; --------------------------------------------------------------

Bytecode_PlaySnd_ChkSamp:
	jmp	PlaySound_ChkSamp			; Play sound

; --------------------------------------------------------------
; Fade out sound
; --------------------------------------------------------------

Bytecode_FadeSound:
	subq.l	#2,bytecode_addr			; No parameters
	jmp	FadeSound				; Fade out sound

; --------------------------------------------------------------
; Stop all sounds
; --------------------------------------------------------------

Bytecode_StopSound:
	subq.l	#2,bytecode_addr			; No parameters
	jmp	StopSound				; Stop sound

; --------------------------------------------------------------
; Play a sound (checks if PCM is enabled)
; --------------------------------------------------------------
; PARAMETERS
;	00.w	- Sound ID
; --------------------------------------------------------------

Bytecode_PlaySnd_ChkSamp2:
	jmp	PlaySound_ChkSamp			; Play sound
	
; --------------------------------------------------------------

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

Bytecode_NemDec_Cutscene:
	cmpi.b	#$F,stage				; Is this the Robotnik stage cutscene?
	bne.s	.NotRobotnik				; If not, branch
	move.w	#$2000,d0				; Force VRAM address to $2000

.NotRobotnik:
	movea.l	bytecode_addr,a1			; Get art address
	movea.l	(a1)+,a0
	move.l	a1,bytecode_addr

	DISABLE_INTS					; Decompress art
	jsr	NemDec
	ENABLE_INTS
					endc
					
; --------------------------------------------------------------