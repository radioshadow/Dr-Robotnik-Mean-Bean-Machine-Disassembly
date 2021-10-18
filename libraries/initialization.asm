; --------------------------------------------------------------
;
;	Dr. Robotnik's Mean Bean Machine Disassembly
;	Original game by Compile
;
;	Disassembled by Devon Artmeier
;
; --------------------------------------------------------------
 
; --------------------------------------------------------------
; High score entry macro
; --------------------------------------------------------------

HIGH_SCORE macro name, score, blocks

len = strlen(\name)
	if len>3
len = 3
	endif

i = 0
	while i<len
c substr 1+i,1+i,\name
	; Space
	if "\c"=" "
		dc.b	$00
	; A-Z
	elseif ("\c">="A")&("\c"<="Z")
		dc.b	"\c"-$40
	; a-z
	elseif ("\c">="a")&("\c"<="z")
		dc.b	"\c"-$60
	; .
	elseif ("\c"=".")
		dc.b	$1B
	endif
i = i+1
	endw

	dcb.b	3-i, $00

	dc.b	$FF, $FF, $FF
	dc.l	\score
	dc.w	\blocks
	dc.l	0

	endm

; --------------------------------------------------------------
; Loads the default high score table into RAM
; --------------------------------------------------------------

LoadDefaultHighScores:
	lea	.Scores,a1				; Load default high scores
	lea	high_scores,a2
	move.w	#(.Scores_End-.Scores)/4-1,d0

.Load:
	move.l	(a1)+,(a2)+
	dbf	d0,.Load

	rts

; --------------------------------------------------------------

.Scores:
	; Scenario Mode
	HIGH_SCORE "DRR", 18594, 416
	HIGH_SCORE "SCR", 16976, 348
	HIGH_SCORE "DB",  12382, 204
	HIGH_SCORE "SIR", 9260,  137
	HIGH_SCORE "SPK", 6650,  152
	
	; Exercise Mode
	HIGH_SCORE "GRD", 108382, 558
	HIGH_SCORE "DYN", 105375, 499
	HIGH_SCORE "SKW", 103476, 384
	HIGH_SCORE "DS",  99873,  405
	HIGH_SCORE "COC", 97200,  367
.Scores_End:

; --------------------------------------------------------------
; Checks the high score table for broken entries and fixes them
; --------------------------------------------------------------

FixHighScores:
	lea	high_scores,a1				; Get high score table
	moveq	#$A-1,d0

.Loop:
	move.l	0(a1),d1				; Get current entry name
	bpl.s	.Store					; If it's not broken, branch
	move.l	#$1B1B1BFF,d1				; Fix the entry name

.Store:
	move.l	d1,(a1)					; Store the entry name

	lea	$10(a1),a1				; Next entry
	dbf	d0,.Loop				; Loop until all entries are checked

	rts

; --------------------------------------------------------------
; Initialize options
; --------------------------------------------------------------

InitOptions:
	move.b	#2,com_level				; Normal difficulty
	move.b	#1,game_matches				; 1 match in VS. mode
	move.b	#0,disable_samples			; Enable sampling

	move.b	#2,player_1_a				; A turns right
	move.b	#1,player_1_b				; B turns left
	move.b	#2,player_1_c				; C turns right

	move.b	#2,player_2_a				; A turns right
	move.b	#1,player_2_b				; B turns left
	move.b	#2,player_2_c				; C turns right
	rts

; --------------------------------------------------------------
; Wait for DMA to be over
; --------------------------------------------------------------

WaitDMA:
	nop						; Delay for a bit
	nop
	nop
	nop

	move.w	VDP_CTRL,d0				; Is DMA still active?
	btst	#1,d0
	bne.s	WaitDMA					; If so, wait

	rts

; --------------------------------------------------------------
; Initialize the game
; --------------------------------------------------------------

InitGame:
	lea	save_data,a1				; Check if the save data has been initialized
	jsr	CalcSaveDataChecksum
	cmp.w	save_data_checksum,d0
	beq.w	.Initialize				; If so, branch

	lea	save_backup,a1				; Check if the save data backup has been initialized
	jsr	CalcSaveDataChecksum
	cmp.w	save_backup_checksum,d0
	beq.w	.Copy					; If so, branch
	bsr.w	.InitSaveData				; If not, initialize the save data

.Copy:
	lea	save_backup_checksum,a1			; Load save backup
	lea	save_data_checksum,a2
	move.w	#$2C-1,d0

.CopyLoop:
	move.l	(a1)+,(a2)+
	dbf	d0,.CopyLoop

	bra.w	.Initialize				; Continue initialization

; --------------------------------------------------------------

.InitSaveData:
	lea	save_data_checksum,a0			; Clear save data
	moveq	#0,d0
	move.w	#$100-1,d1

.Loop:
	move.l	d0,(a0)+
	dbf	d1,.Loop

	bsr.w	LoadDefaultHighScores			; Load default high scores
	bsr.w	InitOptions				; Initialize options
	move.w	#$FFFF,current_password			; Reset current level password

	jmp	SaveData				; Save data

; --------------------------------------------------------------

.Initialize:
	move.w	current_password,d2			; Backup current level password

	lea	RAM_START,a0				; Clear RAM up to the stack
	moveq	#0,d0
	move.w	#(stack-RAM_START)/4-1,d1

.ClearRAM:
	move.l	d0,(a0)+
	dbf	d1,.ClearRAM

	move.w	d2,current_password			; Restore current level password

	jsr	InitSound				; Initialize sound
	bsr.w	InitVDP					; Initialize VDP
	bsr.w	InitBytecode				; Initialize bytecode
	jsr	InitSpriteDraw				; Initialize sprite drawing
	bsr.w	InitControllers				; Initialize controllers

	jsr	DrawActors				; Draw actor sprites (doesn't do anything)
	bsr.w	TransferSprites				; Reset sprite table in VRAM
	bsr.w	FixHighScores				; Fix potential broken high score entries
	bsr.w	TransferPalette				; Reset palette in CRAM

	lea	vdp_reg_1,a0				; Enable display
	ori.b	#$40,(a0)
	move.w	#$8100,d0
	move.b	(a0),d0
	move.w	d0,VDP_CTRL

	rts

; --------------------------------------------------------------