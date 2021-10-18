; -----------------------------------------------------------------------------------------
;
;	Dr. Robotnik's Mean Bean Machine Disassembly
;	Original game by Compile
;
;	Disassembled by Devon Artmeier & RadioTails
;
; -----------------------------------------------------------------------------------------

					include	"include/md.asm"
					include	"include/constants.asm"
					include	"include/ram.asm"
					include	"include/macros.asm"	
					include	"include/cube2asm.asm"
					
					include "include/Text Tables/Checksum Text.asm"
					include "include/Text Tables/Stage Text.asm"
					
; -----------------------------------------------------------------------------------------
; ROM settings
; -----------------------------------------------------------------------------------------
				
					include	"settings.asm" ; Change how the ROM should be compiled.

; -----------------------------------------------------------------------------------------
; ROM header
; -----------------------------------------------------------------------------------------

StartOfRom:
					include	"header/vectors.asm"	  ; Vector table
					include	"header/information.asm"  ; ROM Information
EndOfHeader:

; -----------------------------------------------------------------------------------------
; Initialize Mega Drive
; -----------------------------------------------------------------------------------------

Entry:
					include	"libraries/md_init.asm"	  ; Initialize Mega Drive

					DISABLE_INTS
					bsr.w	WaitDMA					  ; Wait for DMA to stop
					bsr.w	InitGame				  ; Initialize the game
					ENABLE_INTS

; -----------------------------------------------------------------------------------------
; Game loop
; -----------------------------------------------------------------------------------------

GameLoop:
					bsr.w	VSync					; VSync

					jsr		HandlePause				; Handle pausing
					bsr.w	ReadCtrlsSafe			; Read controller data
					bsr.w	RunBytecode				; Run bytecode
					bsr.w	RunActors				; Run actors
					jsr		DrawActors				; Draw actors

					bra.s	GameLoop				; Loop the game

; -----------------------------------------------------------------------------------------
; Libraries
; -----------------------------------------------------------------------------------------

					include	"libraries/vsync.asm"					; VSync library
					include	"libraries/initialization.asm"			; Initialization library
					include	"libraries/exception.asm"				; Exception library
					include	"libraries/dummied.asm"					; Dummied library
					include	"libraries/interrupts.asm"				; Interrupts library
					include	"libraries/vdp_scroll.asm"				; VDP scroll library
					include	"libraries/vdp_sh.asm"					; VDP shadow/highlight library
					include	"libraries/plane_cmd_queue.asm"			; Plane command queue library
					include	"libraries/decomp_puyo.asm"				; Puyo decompression library
					include	"libraries/vdp_init.asm"				; VDP initialization library
					include	"libraries/palette.asm"					; Palette library
					include	"libraries/controller.asm"				; Controller library
					include	"libraries/math.asm"					; Math library
					include	"libraries/saturn_clouds.asm" 			; Satan stage cut-scene cloud effects actor

					include	"libraries/bytecode_list.asm"			; Bytecode library
					include	"game/bytecode_game.asm"				; Bytecode data

					include	"subroutines/Stage/stage_setup.asm"		; Stage setup library

; -----------------------------------------------------------------------------------------
; Palette table
; -----------------------------------------------------------------------------------------

Palettes:
					include "data/palettes/palette table.asm"
					
; -----------------------------------------------------------------------------------------
; Animation Frames - Has Bean
; -----------------------------------------------------------------------------------------

					include "data/has bean/Has Bean - Start Match.asm"
					include "data/has bean/Has Bean - Movement.asm"

; -----------------------------------------------------------------------------------------
; Actor library
; -----------------------------------------------------------------------------------------

					include	"libraries/actor.asm"

; -----------------------------------------------------------------------------------------
; Handle puyo landing effects
; -----------------------------------------------------------------------------------------
; PARAMETERS:
;	a0.l	- Pointer to actor slot
; -----------------------------------------------------------------------------------------

PuyoLandEffects:
	cmpi.b	#OPP_FRANKLY,opponent			; Are we battling against Frankly?
	beq.s	.HardLand				; If so, branch
	cmpi.b	#OPP_DRAGON,opponent			; Are we battling against Dragon Breath?
	bne.w	PlayPuyoLandSound			; If not, branch

.HardLand:
	tst.b	aPuyoField(a0)				; Is this the player's puyo field?
	beq.w	PlayPuyoLandSound			; If so, branch

	move.b	#SFX_PUYO_LAND_HARD,d0			; Play the hard Ppuyouyo landing sound
	jsr	PlaySound_ChkSamp

	movem.l	a1,-(sp)				; Save registers

	lea	ActFieldShake,a1			; Load field shake actor
	bsr.w	FindActorSlotQuick
	bcs.w	.End

	move.w	#$400,pfsIntensity(a1)			; Set initial shake intensity
	move.l	#vscroll_buffer+$34,pfsVScroll(a1)	; Shake the field on the right
	tst.b	swap_fields				; Are the fields swapped?
	beq.w	.End					; If not, branch
	move.l	#vscroll_buffer+4,pfsVScroll(a1)	; If so, shake the field on the left

.End:
	movem.l	(sp)+,a1				; Restore registers
	rts

; -----------------------------------------------------------------------------------------
; Field shake actor
; -----------------------------------------------------------------------------------------

pfsVScroll	EQU	$32				; VScroll buffer pointer
pfsAngle	EQU	$36				; Shake angle
pfsIntensity	EQU	$38				; Shake intensity

; -----------------------------------------------------------------------------------------

ActFieldShake:
	move.b	pfsAngle(a0),d0				; Get shake angle
	move.w	pfsIntensity(a0),d1			; Get shake intensity

	movea.l	pfsVScroll(a0),a1			; Get VScroll buffer
	move.w	#6-1,d3					; Shake 6 columns

.Shake:
	andi.b	#$7F,d0					; Get shake scroll offset for this column
	bsr.w	Sin
	swap	d2
	move.w	d2,(a1)+
	clr.w	(a1)+

	addi.b	#$48,d0					; Increment shake angle for the next column
	dbf	d3,.Shake				; Loop until all columns have been shaken

	addi.b	#$28,pfsAngle(a0)			; Increment base shake angle
	subi.w	#$20,pfsIntensity(a0)			; Lessen the intensity
	bcs.w	ActorDeleteSelf				; If the shaking is over, delete ourselves

	rts

; -----------------------------------------------------------------------------------------
; Play the puyo land sound
; -----------------------------------------------------------------------------------------

PlayPuyoLandSound:
	move.b	#SFX_PUYO_LAND,d0			; Use regular land sound
	cmpi.b	#OPP_ROBOTNIK,opponent			; Are we battling against Dr. Robotnik?
	bne.w	.PlaySound				; If not, branch
	move.b	#SFX_PUYO_LAND,d0			; In Puyo Puyo, Satan had a unique puyo land sound

.PlaySound:
	jmp	PlaySound_ChkSamp			; Play the sound

; -----------------------------------------------------------------------------------------
; Play the puyo move sound
; -----------------------------------------------------------------------------------------

PlayPuyoMoveSound:
	move.b	#SFX_PUYO_MOVE,d0			; Use regular land sound
	cmpi.b	#OPP_ROBOTNIK,opponent			; Are we battling against Dr. Robotnik?
	bne.w	.PlaySound				; If not, branch
	move.b	#SFX_PUYO_MOVE,d0			; In Puyo Puyo, Satan had a unique puyo move sound

.PlaySound:
	jmp	PlaySound_ChkSamp			; Play the sound

; -----------------------------------------------------------------------------------------
; Play the puyo rotate sound
; -----------------------------------------------------------------------------------------

PlayPuyoRotateSound:
	move.b	#SFX_PUYO_ROTATE,d0			; Use regular rotate sound
	cmpi.b	#OPP_ROBOTNIK,opponent			; Are we battling against Dr. Robotnik?
	bne.w	.PlaySound				; If not, branch
	move.b	#SFX_PUYO_ROTATE,d0			; In Puyo Puyo, Satan had a unique puyo rotate sound

.PlaySound:
	jmp	PlaySound_ChkSamp			; Play the sound

; -----------------------------------------------------------------------------------------
; Handle stage music
; -----------------------------------------------------------------------------------------
; PARAMETERS:
;	a0.l	- Pointer to actor slot
; -----------------------------------------------------------------------------------------

HandleStageMusic:
	tst.b	stage_mode				; Are we in scenario mode?
	beq.w	.CheckPlayer				; If so, branch
	rts

.CheckPlayer:
	tst.b	aPuyoField(a0)				; Is this the main player's puyo field?
	beq.w	.CheckDanger				; If so, branch
	rts

.CheckDanger:
	cmpi.b	#BGM_DANGER,current_stage_music		; Is the danger music currently playing?
	beq.w	.CheckDangerOver			; If so, branch
	cmpi.w	#60,p1_puyo_count			; Is the puyo count at least 60?
	bcc.w	.InDanger				; If so, branch
	rts

.InDanger:
	move.b	#BGM_DANGER,d0				; Play danger music
	move.b	d0,current_stage_music
	jmp	JmpTo_PlaySound

.CheckDangerOver:
	cmpi.w	#54,p1_puyo_count			; Has the puyo count lowered down to at least 54?
	bcs.w	JmpTo_PlayStageMusic			; If so, branch
	rts

JmpTo_PlayStageMusic:
	jmp	PlayStageMusic				; Play stage music

; -----------------------------------------------------------------------------------------
; List of maximum indicies for the Puyo color spawn table
; -----------------------------------------------------------------------------------------

MaxPuyoSpawnIndicies:
	dc.b	4					; Lesson Stage 1 (Unused)
	dc.b	4					; Lesson Stage 2 (Unused)
	dc.b	4					; Lesson Stage 3 (Unused)

	dc.b	5					; Scenario Stage 1
	dc.b	5					; Scenario Stage 2
	dc.b	5					; Scenario Stage 3
	dc.b	5					; Scenario Stage 4
	dc.b	5					; Scenario Stage 5
	dc.b	5					; Scenario Stage 6
	dc.b	5					; Scenario Stage 7
	dc.b	5					; Scenario Stage 8
	dc.b	5					; Scenario Stage 9
	dc.b	5					; Scenario Stage 10
	dc.b	5					; Scenario Stage 11
	dc.b	5					; Scenario Stage 12
	dc.b	5					; Scenario Stage 13

; -----------------------------------------------------------------------------------------
; Generate the Puyo spawn list
; -----------------------------------------------------------------------------------------
; In scenario mode, the primary list is used for the main
; player, while the secondary list is used for the CPU.
; -----------------------------------------------------------------------------------------
; In versus mode, the primary list is used for the easiest
; difficulty, while the secondary list is used for the harder
; difficulties. Both are shared between players 1 and 2.
; -----------------------------------------------------------------------------------------

GenPuyoSpawnList:
	move.b	#4,d2					; Only spawn red, yellow, green, and purple puyos

	cmpi.b	#1,stage_mode				; Are we in versus mode?
	beq.w	.GetColors				; If so, branch

	clr.w	d1					; If not, depending on the current stage, also spawn blue
	move.b	stage,d1
	move.b	MaxPuyoSpawnIndicies(pc,d1.w),d2

.GetColors:
	move.w	#256-1,d1				; 256 puyos in a spawn list
	clr.w	d0					; Start at the beginning of the color list
	lea	puyo_order_1,a1				; Primary puyo spawn order
	lea	.PuyoColors,a2				; Color list

.GetColorsLoop:
	move.b	(a2,d0.w),(a1)+				; Copy color from color list
	addq.b	#1,d0					; Increment color list index
	cmp.b	d2,d0					; Have we gone past the max index chosen?
	bcs.w	.DoGetColorsLoop			; If not, branch
	clr.b	d0					; If so, go back to the start of the color list

.DoGetColorsLoop:
	dbf	d1,.GetColorsLoop			; Loop until the entire spawn list is filled

	move.w	#256-1,d1				; 256 puyos in a spawn list
	lea	puyo_order_1,a1				; Primary puyo spawn order

.Shuffle:
	jsr	Random					; Get a random index in the spawn list
	andi.w	#$FF,d0
	move.b	(a1,d0.w),d2				; Swap the color in the random index with the
	move.b	(a1,d1.w),(a1,d0.w)			; one in the current index
	move.b	d2,(a1,d1.w)

	dbf	d1,.Shuffle				; Loop until the entire spawn list is shuffled

	move.w	#256-1,d1				; Copy over the primary spawn list over to
	lea	puyo_order_2,a2				; the secondary spawn list

.CopyList:
	move.b	(a1)+,(a2)+
	dbf	d1,.CopyList

	cmpi.b	#1,stage_mode				; Are we in versus mode?
	beq.w	.VersusMode				; If so, branch
	rts

; -----------------------------------------------------------------------------------------

.VersusMode:
	move.w	#248-1,d1				; Only reload 248 spawn list entries
	clr.w	d0					; Start at the beginning of the color list
	lea	puyo_order_2+8,a1			; Start reloading at the 8th list entry in the secondary list
	lea	.PuyoColors,a2				; Color list

.GetColorsLoop2:
	move.b	(a2,d0.w),(a1)+				; Copy color from color list
	addq.b	#1,d0					; Increment color list index
	cmpi.b	#5,d0					; Have we gone past the blue color index?
	bcs.w	.DoGetColorsLoop2			; If not, branch
	clr.b	d0					; If so, go back to the start of the color list

.DoGetColorsLoop2:
	dbf	d1,.GetColorsLoop2			; Loop until the entire spawn list is filled

	move.w	#248-1,d1				; Only reshuffle 248 spawn list entries
	lea	puyo_order_2+8,a1			; Start reshuffling at the 8th list entry in the secondary list

.Shuffle2:
	move.w	#248,d0					; Get a random index in the spawn list
	jsr	RandomBound
	move.b	(a1,d0.w),d2				; Swap the color in the random index with the
	move.b	(a1,d1.w),(a1,d0.w)			; one in the current index
	move.b	d2,(a1,d1.w)

	dbf	d1,.Shuffle2				; Loop until the entire spawn list is shuffled

	rts

; -----------------------------------------------------------------------------------------

.PuyoColors:
	dc.b	PUYO_RED				; Red
	dc.b	PUYO_YELLOW				; Yellow
	dc.b	PUYO_GREEN				; Green
	dc.b	PUYO_PURPLE				; Purple
	dc.b	PUYO_BLUE				; Blue
	dc.b	PUYO_GARBAGE				; Garbage (unused)
	dc.b	PUYO_TEAL				; Teal (unused)
	ALIGN	2

; -----------------------------------------------------------------------------------------
; Get puyo spawn delay time
; -----------------------------------------------------------------------------------------
; PARAMETERS:
;	a0.l	- Pointer to actor slot
; RETURNS:
;	d0.w	- Delay time
; -----------------------------------------------------------------------------------------

GetPuyoSpawnDelay:
	clr.w	d1					; Get difficulty
	move.b	aDifficulty(a0),d1
	cmpi.b	#5,d1					; Is it past the maximum one?
	bcs.w	.GetDelayTime				; If not, branch
	move.b	#4,d1					; Cap it at the maxmimum

.GetDelayTime:
	lsl.w	#1,d1					; Get delay time
	move.w	.DelayTimes(pc,d1.w),d0
	rts

; -----------------------------------------------------------------------------------------

.DelayTimes:
	dc.w	12					; Easiest
	dc.w	8					; Easy
	dc.w	4					; Normal
	dc.w	2					; Hard
	dc.w	0					; Hardest

; -----------------------------------------------------------------------------------------
; Mark the current stage as finished and determine where
; to go next
; -----------------------------------------------------------------------------------------
; BYTECODE FLAG:
;	00	- Next stage
;	01	- Ending
;	02	- Lesson mode ending (leftover from Puyo Puyo)
; -----------------------------------------------------------------------------------------

StageEnd:
	cmpi.b	#$F,stage				; Was the final stage beaten?
	bcc.w	.Ending					; If so, branch
	addq.b	#1,stage				; Go to next stage

	clr.w	d0					; Mark the opponent as beaten
	move.b	opponent,d0
	lea	opponents_defeated,a1
	move.b	#-1,(a1,d0.w)

	move.b	#0,bytecode_flag			; Set to go to next stage
	cmpi.b	#3,stage				; Was lesson mode beaten?
	bne.w	.Exit					; If not, branch
	move.b	#2,bytecode_flag			; Set to go to lesson mode ending

.Exit:
	rts

.Ending:
	move.b	#1,bytecode_flag			; Set to go to ending
	rts

; -----------------------------------------------------------------------------------------
; Spawn the garbage puyo animation handler actor
; -----------------------------------------------------------------------------------------

SpawnGarbagePuyoAnim:
	lea	ActGarbPuyoHandlerAnim,a1			; Spawn garbage puyo animation handler actor
	bra.w	FindActorSlot

; -----------------------------------------------------------------------------------------
; Spawn the garbage puyo animation handler actor
; -----------------------------------------------------------------------------------------

gpaFrame	EQU	$08				; Saved frame ID

; -----------------------------------------------------------------------------------------

ActGarbPuyoHandlerAnim:
	move.b	#-1,gpaFrame(a0)			; Force garbage drawing
	move.l	#Ani_GarbagePuyo,aAnim(a0)		; Set animation script
	bsr.w	ActorBookmark				; Set bookmark

.Main:
	bsr.w	ActorAnimate				; Run animation
	move.b	aFrame(a0),d0				; Has the animation frame changed?
	cmp.b	gpaFrame(a0),d0
	bne.w	.Redraw					; If so, branch
	rts

.Redraw:
	move.b	d0,gpaFrame(a0)				; Update saved frame ID

	move.w	#$8A00,d0				; Draw garbage puyos
	move.b	gpaFrame(a0),d0
	swap	d0
	jmp	QueuePlaneCmd

; -----------------------------------------------------------------------------------------
; Garbage puyo animation script
; -----------------------------------------------------------------------------------------

Ani_GarbagePuyo:
	dc.b	$F3, 0
	dc.b	$02, 4
	dc.b	$04, 5
	dc.b	$02, 4
	dc.b	$FF, 0
	dc.l	Ani_GarbagePuyo

; -----------------------------------------------------------------------------------------
; Initialize the stage
; -----------------------------------------------------------------------------------------

InitStage:
	move.w	#$CB1E,p1_score_vram			; Draw score at (120, 176)
	tst.b	swap_fields				; Are the puyo fields swapped?
	beq.w	.NotSwapped				; If not, branch
	move.w	#$CC22,p1_score_vram			; If so, draw score at (136, 192)

.NotSwapped:
	clr.w	time_frames				; Reset timer
	clr.w	time_minutes
	clr.b	byte_FF1965

	tst.b	stage_mode				; Are we in scenario mode?
	bne.w	.NotScenario				; If not, branch
	clr.b	current_stage_music			; If so, play stage music
	bsr.w	JmpTo_PlayStageMusic

.NotScenario:
	bsr.w	ClearScroll				; Clear scroll data
	move.w	#$8B00,d0				; VScroll by column
	move.b	vdp_reg_b,d0
	ori.b	#4,d0
	move.b	d0,vdp_reg_b

	lea	ActPuyoField,a1				; Spawn player 1's puyo field handler
	bsr.w	FindActorSlot
	move.b	#%11110001,aRunFlags(a1)		; Set to run unless paused
	move.b	#0,aPuyoField(a1)			; Set puyo field ID
	move.b	#3,aField7(a1)
	move.l	dword_FF195C,aX(a1)
	move.w	dword_FF1960,aYVel(a1)
	movea.l	a1,a2					; Copy slot pointer

	lea	ActPuyoField,a1				; Spawn player 1's puyo field handler
	bsr.w	FindActorSlot
	move.b	#%11110010,aRunFlags(a1)		; Set to run unless paused
	move.b	#1,aPuyoField(a1)			; Set puyo field ID
	move.b	#3,aField7(a1)

	move.l	a1,pfhOpponent(a2)			; Set player 1's opponent
	move.l	a2,pfhOpponent(a1)			; Set player 2's opponent

	bsr.w	sub_5B54
	bsr.w	SpawnGarbagePuyoAnim			; Spawn garbage puyo animation handler

	jsr	sub_1233A

	bsr.w	DrawScoreText
	cmpi.b	#2,stage_mode				; Are we in exercise mode?
	bne.w	.End					; If not, branch
	move.l	#$800F0000,d0				; Draw "LV" text
	jsr	QueuePlaneCmd
	bsr.w	DrawExerciseGreenPuyo			; Draw green puyo

.End:
	rts

; -----------------------------------------------------------------------------------------
; Draw "SCORE" text for the stage
; -----------------------------------------------------------------------------------------

DrawScoreText:
	move.l	#$80000000,d0				; Draw "SCORE" text (versus, exercise)
	move.b	stage_mode,d1				; Are we in scenario mode?
	andi.b	#3,d1
	bne.w	.Queue					; If not, branch
	move.l	#$80060000,d0				; If so, draw "SCORE" text (scenario)

.Queue:
	jmp	QueuePlaneCmd				; Queue draw command

; -----------------------------------------------------------------------------------------
; Initialize pause flag
; -----------------------------------------------------------------------------------------
; PARAMETERS:
;	a0.l	- Pointer to actor slot
; -----------------------------------------------------------------------------------------

InitPauseFlag:
	move.b	stage_mode,d2				; Are we in demo/tutorial mode?
	btst	#2,d2
	bne.w	.End					; If so, branch

	clr.w	d0					; Enable pausing for this puyo field
	move.b	aPuyoField(a0),d0
	lea	p1_pause,a1
	move.b	#%01111111,(a1,d0.w)

.End:
	rts

; -----------------------------------------------------------------------------------------
; Puyo field handler actor
; -----------------------------------------------------------------------------------------

pfhScore	EQU	$0A				; Score
pfhGarbage	EQU	$0E				; Garbage queue
pfhGarbageCnt	EQU	$14				; Garbage count
pfhOpponent	EQU	$2E				; Opponent puyo field manager

; -----------------------------------------------------------------------------------------

ActPuyoField:
	jsr	SpawnLessonStartText			; Spawn the lesson mode start text
	bsr.w	sub_44EA

	move.b	main_player_field,d0
	cmp.b	aPuyoField(a0),d0
	beq.w	loc_3D44
	btst	#1,stage_mode
	beq.w	loc_3D44
	bra.w	loc_813C

loc_3D44:
	clr.w	d0					; Mark puyos as not popping for this field
	move.b	aPuyoField(a0),d0
	lea	puyos_popping,a1
	move.b	#0,(a1,d0.w)

	bsr.w	ResetPuyoField				; Reset this puyo field

	DISABLE_INTS					; This code probably used to do something useful
	ENABLE_INTS

	clr.l	d0					; Draw initial score
	bsr.w	AddComboDraw
	clr.w	d1					; Draw initial level
	bsr.w	DrawLevel
	bsr.w	DrawBlockCount				; Draw initial block count

	bset	#0,aField7(a0)
	bsr.w	sub_3F94

	bsr.w	ActorBookmark				; Set bookmark

; -----------------------------------------------------------------------------------------

	btst	#0,aField7(a0)				; Is initialization stage 1 disabled?
	beq.w	loc_3D8C				; If not, branch
	rts

loc_3D8C:
	bsr.w	loc_9CF8
	bsr.w	sub_9BCE
	move.w	#1,d1
	bsr.w	DrawLevel

	bsr.w	ActorBookmark

; -----------------------------------------------------------------------------------------

	btst	#1,7(a0)				; Is initialization stage 2 disabled?
	beq.w	loc_3DAC				; If not, branch
	rts

loc_3DAC:
	bsr.w	InitPauseFlag				; Initialize pause flag

; -----------------------------------------------------------------------------------------

loc_3DB0:
	clr.b	aFrame(a0)
	lea	byte_FF19B2,a1
	clr.w	d0
	move.b	aPuyoField(a0),d0
	move.b	#0,(a1,d0.w)

	bsr.w	SpawnGarbage
	bsr.w	sub_9814

	bsr.w	ActorBookmark

	btst	#2,7(a0)
	beq.w	loc_3DDE
	rts

loc_3DDE:
	jsr	(sub_12BAA).l
	jsr	(sub_88A8).l
	bsr.w	sub_9332
	bsr.w	HandleStageMusic
	bsr.w	ActorBookmark

	move.b	#0,(byte_FF1D0E).l
	jsr	(sub_12C8A).l
	bsr.w	ActorBookmark

	move.b	#$FF,(byte_FF1D0E).l
	jsr	(sub_12C8A).l
	bsr.w	ActorBookmark

	clr.w	d0
	move.b	aPuyoField(a0),d0
	lea	(byte_FF1D0A).l,a1
	clr.b	(a1,d0.w)

	jsr	(sub_127BA).l
	tst.b	control_puyo_drops
	beq.w	loc_3E40
	jsr	(nullsub_4).l

loc_3E40:
	bsr.w	ActorBookmark

.WaitPuyoDrop:
	tst.b	control_puyo_drops
	beq.w	loc_3E5C
	bsr.w	GetFieldCtrlData
	btst	#5,d0
	bne.w	loc_3E5C
	rts
; -----------------------------------------------------------------------------------------

loc_3E5C:
	bsr.w	SpawnFallingPuyos			; Spawn falling puyos
	bcs.w	ActPuyoField_Lose			; If the third column is full, branch

	jsr	(sub_11FA4).l
	bsr.w	ActorBookmark
	addq.b	#1,$26(a0)
	move.b	7(a0),d0
	andi.b	#3,d0
	beq.w	loc_3E96
	btst	#3,7(a0)
	bne.w	loc_3E8A
	rts
; -----------------------------------------------------------------------------------------

loc_3E8A:
	bclr	#3,7(a0)
	moveq	#1,d0
	bra.w	AddComboDraw
; -----------------------------------------------------------------------------------------

loc_3E96:
	bsr.w	ActorBookmark
	bsr.w	sub_5960
	move.w	d1,$26(a0)
	bsr.w	ActorBookmark
	DISABLE_INTS
	bsr.w	sub_5782
	ENABLE_INTS
	bsr.w	ActorBookmark
	tst.w	$26(a0)
	bne.w	loc_3EDA
	bsr.w	GetPuyoSpawnDelay
	bsr.w	ActorBookmark_SetDelay
	bsr.w	ActorBookmark
	tst.b	9(a0)
	beq.w	loc_3DB0
	bsr.w	sub_998A
	bra.w	loc_3DB0
; -----------------------------------------------------------------------------------------

loc_3EDA:
	lea	byte_FF19B2,a1
	clr.w	d0
	move.b	$2A(a0),d0
	move.b	#$FF,(a1,d0.w)
	jsr	(sub_11ECE).l
	bsr.w	sub_58C8
	bsr.w	ActorBookmark
	bsr.w	sub_9A56
	bsr.w	sub_9A40
	bsr.w	ActorBookmark
	bsr.w	sub_49BA
	move.w	#$18,d0
	bsr.w	ActorBookmark_SetDelay
	bsr.w	sub_49D2
	bsr.w	ActorBookmark
	bsr.w	sub_9BBA
	bsr.w	CheckPuyoPop
	jsr	(SpawnGarbageGlow).l
	move.w	#$18,d0
	bsr.w	ActorBookmark_SetDelay
	bsr.w	ActorBookmark
	bsr.w	sub_4DB8
	bset	#4,7(a0)
	bsr.w	ActorBookmark
	btst	#4,7(a0)
	beq.w	loc_3F50
	bra.w	loc_4E14
; -----------------------------------------------------------------------------------------

loc_3F50:
	bsr.w	DrawScore
	bsr.w	sub_9CA2
	bsr.w	ActorBookmark
	addq.b	#1,9(a0)
	bcc.w	loc_3F6A
	move.b	#$FF,9(a0)

loc_3F6A:
	bra.w	loc_3E96
; -----------------------------------------------------------------------------------------
; START	OF FUNCTION CHUNK FOR sub_3F94

loc_3F6E:
	bclr	#0,7(a0)
	clr.w	d0
	move.b	stage,d0
	move.b	unk_3F84(pc,d0.w),aMappings(a0)
	rts
; END OF FUNCTION CHUNK	FOR sub_3F94
; -----------------------------------------------------------------------------------------
unk_3F84:
	dc.b	7
	dc.b	9
	dc.b	$B
	dc.b	8
	dc.b	9
	dc.b	$A
	dc.b	$B
	dc.b	$C
	dc.b	$D
	dc.b	$E
	dc.b	$F
	dc.b	$11
	dc.b	$11
	dc.b	$12
	dc.b	$12
	dc.b	$13

; =============== S U B	R O U T	I N E =====================================================


sub_3F94:
	move.b	stage_mode,d0
	andi.b	#3,d0
	beq.s	loc_3F6E
	lea	(loc_3FE6).l,a1
	bsr.w	FindActorSlot
	bcc.w	loc_3FB0
	rts
; -----------------------------------------------------------------------------------------

loc_3FB0:
	move.b	#$FF,7(a1)
	move.b	aPuyoField(a0),aPuyoField(a1)
	move.l	a0,$2E(a1)
	clr.w	d0
	move.b	aPuyoField(a0),d0
	lsl.w	#2,d0
	move.w	word_3FDE(pc,d0.w),$A(a1)
	move.w	word_3FE0(pc,d0.w),d2
	move.w	#5,$26(a1)
	movea.l	a1,a2
	bra.w	loc_41EC
; -----------------------------------------------------------------------------------------
word_3FDE
	dc.w	$A0
word_3FE0
	dc.w	$D4
	dc.w	$180
	dc.w	$14C
; -----------------------------------------------------------------------------------------

loc_3FE6:
	move.w	#$8000,d0
	move.b	aPuyoField(a0),d0
	addq.b	#3,d0
	swap	d0
	clr.w	d0
	jsr	QueuePlaneCmd
	move.w	#7,$28(a0)
	bsr.w	ActorBookmark
	move.w	#$8300,d0
	move.b	aPuyoField(a0),d0
	swap	d0
	move.w	$28(a0),d0
	jsr	QueuePlaneCmd
	subq.w	#1,$28(a0)
	bcs.w	loc_4022
	rts
; -----------------------------------------------------------------------------------------

loc_4022:
	clr.w	d0
	move.b	aPuyoField(a0),d0
	lsl.w	#1,d0
	lea	(word_FF010E).l,a1
	move.w	(a1,d0.w),$26(a0)
	move.w	#$C0,$E(a0)
	move.w	#$8800,d0
	move.b	aPuyoField(a0),d0
	swap	d0
	move.w	#$8000,d0
	move.b	$27(a0),d0
	jsr	QueuePlaneCmd
	move.b	#SFX_5C,d0
	jsr	PlaySound_ChkSamp
	bsr.w	ActorBookmark
	move.w	#$180,$28(a0)
	move.w	#$80,d4
	move.w	#$CC0A,d5
	move.w	#$8500,d6
	tst.b	aPuyoField(a0)
	beq.w	loc_4084
	move.w	#$CC3A,d5
	move.w	#$A500,d6

loc_4084:
	bsr.w	ActorBookmark
	bsr.w	GetFieldCtrlData
	andi.b	#$F0,d0
	bne.w	loc_4112
	bsr.w	GetFieldCtrlData
	btst	#0,d0
	bne.w	loc_40AA
	btst	#1,d0
	bne.w	loc_40BA
	rts
; -----------------------------------------------------------------------------------------

loc_40AA:
	move.w	#$FFFF,d1
	tst.w	$26(a0)
	beq.w	locret_4110
	bra.w	loc_40C8
; -----------------------------------------------------------------------------------------

loc_40BA:
	move.w	#1,d1
	cmpi.w	#4,$26(a0)
	bcc.w	locret_4110

loc_40C8:
	cmpi.b	#2,stage_mode
	bne.w	loc_40D6
	asl.b	#1,d1

loc_40D6:
	move.w	#$8800,d0
	move.b	$2A(a0),d0
	swap	d0
	move.w	$26(a0),d0
	jsr	QueuePlaneCmd
	add.w	d1,$26(a0)
	move.w	#$8800,d0
	move.b	$2A(a0),d0
	swap	d0
	move.w	#$8000,d0
	move.b	$27(a0),d0
	jsr	QueuePlaneCmd
	move.b	#SFX_MENU_MOVE,d0
	jsr	PlaySound_ChkSamp

locret_4110:
	rts
; -----------------------------------------------------------------------------------------

loc_4112:
	move.b	#SFX_MENU_SELECT,d0
	jsr	PlaySound_ChkSamp
	clr.w	$28(a0)
	bsr.w	ActorBookmark
	move.w	#$18,$28(a0)
	bsr.w	ActorBookmark
	move.w	#$8800,d0
	move.b	$2A(a0),d0
	swap	d0
	move.w	$26(a0),d0
	move.w	$28(a0),d1
	andi.b	#2,d1
	ror.w	#2,d1
	or.w	d1,d0
	jsr	QueuePlaneCmd
	subq.w	#1,$28(a0)
	beq.w	loc_4158
	rts
; -----------------------------------------------------------------------------------------

loc_4158:
	movea.l	$2E(a0),a1
	move.w	$26(a0),d0
	move.b	d0,$2B(a1)
	clr.b	8(a1)
	clr.w	d0
	move.b	$2A(a0),d0
	lsl.w	#1,d0
	lea	(word_FF010E).l,a1
	move.w	$26(a0),(a1,d0.w)
	clr.b	7(a0)
	bsr.w	ActorBookmark
	clr.w	$26(a0)
	bsr.w	ActorBookmark
	move.w	#$8300,d0
	move.b	$2A(a0),d0
	swap	d0
	move.w	$26(a0),d0
	jsr	QueuePlaneCmd
	addq.w	#1,$26(a0)
	cmpi.w	#8,$26(a0)
	bcc.w	loc_41B0
	rts
; -----------------------------------------------------------------------------------------

loc_41B0:
	bsr.w	ActorBookmark
	move.w	#$8300,d0
	move.b	$2A(a0),d0
	swap	d0
	move.b	#$FF,d0
	jsr	QueuePlaneCmd
	move.w	#$8000,d0
	move.b	$2A(a0),d0
	addq.b	#3,d0
	swap	d0
	move.w	#$FF00,d0
	jsr	QueuePlaneCmd
	movea.l	$2E(a0),a1
	bclr	#0,7(a1)
	bra.w	ActorDeleteSelf
; -----------------------------------------------------------------------------------------

loc_41EC:
	move.w	#$B8,d1
	btst	#1,stage_mode
	bne.w	loc_4200
	move.w	#$B0,d1

loc_4200:
	lea	(loc_42FA).l,a1
	bsr.w	FindActorSlotQuick
	bcs.w	locret_4292
	move.b	$2A(a0),$2A(a1)
	move.l	a2,$2E(a1)
	move.b	#0,6(a1)
	move.b	#$30,8(a1)
	clr.w	d0
	tst.b	$2A(a1)
	beq.s	loc_4230
	move.b	#5,d0

loc_4230:
	move.b	d0,9(a1)
	move.w	d2,$A(a1)
	move.w	d1,$34(a1)
	move.w	d1,$E(a1)
	move.b	#$80,$36(a1)
	move.l	a0,-(sp)
	movea.l	a1,a0
	clr.w	d0
	bsr.w	sub_4294
	movea.l	(sp)+,a0
	movea.l	a1,a3
	lea	(loc_436A).l,a1
	bsr.w	FindActorSlotQuick
	bcs.w	locret_4292
	move.l	a2,$2E(a1)
	move.l	a3,$32(a1)
	move.b	#0,6(a1)
	move.b	#$21,8(a1)
	move.b	#0,9(a1)
	move.w	$A(a3),d2
	addi.w	#$10,d2
	move.w	d2,$A(a1)
	move.w	d1,$E(a1)
	addi.w	#$20,$E(a1)

locret_4292:
	rts
; End of function sub_3F94


; =============== S U B	R O U T	I N E =====================================================


sub_4294:
	movem.l	d0/a0,-(sp)
	lsl.w	#2,d0
	tst.b	$2A(a0)
	bne.s	loc_42A8
	lea	((palette_buffer+$68)).l,a3
	bra.s	loc_42AE
; -----------------------------------------------------------------------------------------

loc_42A8:
	lea	((palette_buffer+$72)).l,a3

loc_42AE:
	move.l	(sp)+,d0
	mulu.w	#$A,d0
	lea	(word_42C8).l,a0
	adda.w	d0,a0
	moveq	#4,d1

loc_42BE:
	move.w	(a0)+,(a3)+
	dbf	d1,loc_42BE
	movea.l	(sp)+,a0
	rts
; End of function sub_4294

; -----------------------------------------------------------------------------------------
word_42C8
	dc.w	6
	dc.w	$2A
	dc.w	$24C
	dc.w	$48E
	dc.w	$666
	dc.w	$404
	dc.w	$A46
	dc.w	$C8A
	dc.w	$46
	dc.w	$AC
	dc.w	$40
	dc.w	$282
	dc.w	$4A6
	dc.w	$46
	dc.w	$AC
	dc.w	4
	dc.w	$48
	dc.w	$48C
	dc.w	$8CE
	dc.w	$CE
	dc.w	$624
	dc.w	$A48
	dc.w	$E8A
	dc.w	$64E
	dc.w	$2CE
; -----------------------------------------------------------------------------------------

loc_42FA:
	move.w	#$10,d0
	bsr.w	ActorBookmark_SetDelay
	bsr.w	ActorBookmark
	move.b	#$80,6(a0)
	movea.l	$2E(a0),a1
	tst.b	7(a1)
	beq.w	ActorDeleteSelf
	clr.w	d0
	move.b	$27(a1),d0
	cmp.b	$28(a0),d0
	beq.w	locret_4368
	move.b	d0,$28(a0)
	move.b	d0,9(a0)
	tst.b	$2A(a0)
	beq.s	loc_4338
	addq.b	#5,9(a0)

loc_4338:
	move.w	d0,d1
	moveq	#$14,d2
	btst	#1,stage_mode
	bne.w	loc_434A
	moveq	#$18,d2

loc_434A:
	mulu.w	d2,d1
	add.w	$34(a0),d1
	move.w	d1,$E(a0)
	bsr.w	sub_4294
	move.b	#3,d0
	lea	((palette_buffer+$60)).l,a2
	jsr	LoadPalette

locret_4368:
	rts
; -----------------------------------------------------------------------------------------

loc_436A:
	move.w	#$10,d0
	bsr.w	ActorBookmark_SetDelay
	bsr.w	ActorBookmark
	move.b	#$80,6(a0)
	movea.l	$2E(a0),a1
	tst.b	7(a1)
	beq.w	ActorDeleteSelf
	movea.l	$32(a0),a1
	clr.w	d0
	move.b	$28(a1),d0
	move.b	d0,9(a0)
	moveq	#$14,d2
	btst	#1,stage_mode
	bne.w	loc_43A6
	moveq	#$18,d2

loc_43A6:
	mulu.w	d2,d0
	add.w	$34(a1),d0
	move.w	d0,$E(a0)
	addi.w	#$20,$E(a0)
	rts

; =============== S U B	R O U T	I N E =====================================================


QueueNextPuyoColors:
	movea.l	$32(a0),a1
	move.b	$26(a1),d0
	move.b	$27(a1),d1
	movem.l	d0-d1,-(sp)
	move.w	$28(a1),$26(a1)
	move.w	$2A(a1),$28(a1)
	bsr.w	GetNextPuyoColors
	move.b	d0,$2A(a1)
	move.b	d1,$2B(a1)
	movem.l	(sp)+,d0-d1
	addq.w	#1,$1E(a1)
	rts
; End of function QueueNextPuyoColors


; =============== S U B	R O U T	I N E =====================================================


GetNextPuyoColors:
	move.b	stage_mode,d0
	andi.b	#3,d0
	beq.w	.Scenario
	cmpi.b	#1,d0
	beq.w	.Versus

.Exercise:
	clr.w	d1
	move.b	aDifficulty(a0),d1
	cmpi.b	#5,d1
	bcs.w	.GetRandomColor
	move.b	#4,d1

.GetRandomColor:
	clr.w	d0
	move.b	.IndexLimits(pc,d1.w),d0
	movem.l	d2,-(sp)
	move.w	d0,d1
	jsr	RandomBound
	move.b	.Colors(pc,d0.w),d2
	move.b	d2,d0
	exg	d0,d1
	jsr	RandomBound
	move.b	.Colors(pc,d0.w),d2
	move.b	d2,d0
	movem.l	(sp)+,d2
	cmpi.b	#2,stage_mode
	beq.w	.ExerciseUnk1
	rts
; -----------------------------------------------------------------------------------------
.IndexLimits:
	dc.b	4
	dc.b	5
	dc.b	5
	dc.b	5
	dc.b	5
	ALIGN	2

.Colors:
	dc.b	PUYO_RED
	dc.b	PUYO_YELLOW
	dc.b	PUYO_GREEN
	dc.b	PUYO_PURPLE
	dc.b	PUYO_BLUE
	dc.b	PUYO_TEAL
; -----------------------------------------------------------------------------------------

.ExerciseUnk1:
	movem.l	d2,-(sp)
	move.w	$20(a1),d2
	cmp.w	$1E(a1),d2
	bcc.w	.ExerciseUnk3
	clr.w	$1E(a1)
	addi.w	#$C,$20(a1)
	bcc.w	.ExerciseUnk2
	move.w	#$FFFF,$20(a1)

.ExerciseUnk2:
	move.b	7(a1),d0
	addi.b	#$19,d0
	move.b	d0,d1

.ExerciseUnk3:
	movem.l	(sp)+,d2
	rts
; -----------------------------------------------------------------------------------------

.Scenario:
	movem.l	d2/a2,-(sp)
	clr.w	d2
	move.b	$20(a1),d2
	lea	puyo_order_1,a2
	tst.b	$2A(a0)
	beq.w	.GetScenarioColors
	lea	puyo_order_2,a2

.GetScenarioColors:
	move.b	(a2,d2.w),d0
	move.b	1(a2,d2.w),d1
	addq.b	#2,$20(a1)
	movem.l	(sp)+,d2/a2
	rts
; -----------------------------------------------------------------------------------------

.Versus:
	movem.l	d2/a2,-(sp)
	clr.w	d2
	move.b	$20(a1),d2
	lea	puyo_order_1,a2
	tst.b	$2B(a0)
	beq.w	.GetVersusColors
	lea	puyo_order_2,a2

.GetVersusColors:
	move.b	(a2,d2.w),d0
	move.b	1(a2,d2.w),d1
	addq.b	#2,$20(a1)
	movem.l	(sp)+,d2/a2
	rts
; End of function GetNextPuyoColors


; =============== S U B	R O U T	I N E =====================================================


sub_44EA:
	clr.w	d3
	clr.w	d4

loc_44EE:
	lea	(nullsub_5).l,a1
	bsr.w	FindActorSlot
	bcc.w	loc_44FE
	rts
; -----------------------------------------------------------------------------------------

loc_44FE:
	move.l	a1,$32(a0)
	cmpi.b	#2,stage_mode
	bne.w	loc_4514
	move.w	#$FFFF,$20(a1)

loc_4514:
	move.b	stage_mode,d0
	or.b	$2A(a0),d0
	cmpi.b	#5,d0
	bne.w	*+4

loc_4526:
	move.w	#4,d2
	movem.l	d3-d4,-(sp)

loc_452E:
	bsr.w	GetNextPuyoColors
	move.b	d0,$26(a1,d2.w)
	move.b	d1,$27(a1,d2.w)
	subq.w	#2,d2
	bcc.s	loc_452E
	movea.l	a1,a2
	movem.l	(sp)+,d3-d4
	clr.w	d0
	move.b	stage_mode,d0
	andi.b	#3,d0
	lsl.b	#1,d0
	or.b	$2A(a0),d0
	move.b	swap_fields,d1
	eor.b	d1,d0
	lsl.b	#2,d0
	move.w	word_45CA(pc,d0.w),d1
	move.w	word_45CC(pc,d0.w),d2
	add.w	d3,d1
	add.w	d4,d2
	lea	(loc_45EA).l,a1
	bsr.w	FindActorSlot
	bcc.w	loc_457C
	rts
; -----------------------------------------------------------------------------------------

loc_457C:
	move.l	a2,$2E(a1)
	move.b	#$80,6(a1)
	move.w	d1,$A(a1)
	move.w	d2,$E(a1)
	subi.w	#$10,d2
	move.b	#$FF,$36(a1)
	lea	(loc_45EA).l,a1
	bsr.w	FindActorSlot
	bcc.w	loc_45A8
	rts
; -----------------------------------------------------------------------------------------

loc_45A8:
	move.l	a2,$2E(a1)
	move.b	#$80,6(a1)
	move.b	#1,7(a1)
	move.w	d1,$A(a1)
	move.w	d2,$E(a1)
	move.b	#$FF,$36(a1)
	rts
; End of function sub_44EA


; =============== S U B	R O U T	I N E =====================================================


nullsub_5:
	rts
; End of function nullsub_5

; -----------------------------------------------------------------------------------------
word_45CA
	dc.w	$108
word_45CC
	dc.w	$C6
	dc.w	$138
	dc.w	$C6
	dc.w	$108
	dc.w	$C6
	dc.w	$138
	dc.w	$C6
	dc.w	$108
	dc.w	$C6
	dc.w	$138
	dc.w	$C6
	dc.w	$108
	dc.w	$C6
	dc.w	$138
	dc.w	$C6
; -----------------------------------------------------------------------------------------

loc_45EA:
	movea.l	$2E(a0),a1
	clr.w	d1
	move.b	7(a0),d1
	move.b	$26(a1,d1.w),d0
	move.b	d0,8(a0)
	cmp.b	$36(a0),d0
	beq.w	loc_4610
	move.b	d0,$36(a0)
	clr.w	$22(a0)
	bsr.w	sub_4632

loc_4610:
	move.b	#$80,6(a0)
	tst.b	7(a0)
	beq.w	loc_462E
	cmpi.b	#$19,8(a0)
	bcs.w	loc_462E
	move.b	#0,6(a0)

loc_462E:
	bra.w	ActorAnimate

; =============== S U B	R O U T	I N E =====================================================


sub_4632:
	move.l	#unk_465E,$32(a0)
	cmpi.b	#$19,8(a0)
	beq.w	loc_464A
	bcc.w	loc_4654
	rts
; -----------------------------------------------------------------------------------------

loc_464A:
	move.l	#unk_89AE,$32(a0)
	rts
; -----------------------------------------------------------------------------------------

loc_4654:
	move.l	#unk_4682,$32(a0)
	rts
; End of function sub_4632

; -----------------------------------------------------------------------------------------
unk_465E
	dc.b	$F0
	dc.b	0
	dc.b	1
	dc.b	2
	dc.b	0
	dc.b	0
	dc.b	2
	dc.b	3
	dc.b	0
	dc.b	0
	dc.b	1
	dc.b	2
	dc.b	0
	dc.b	0
	dc.b	2
	dc.b	3
	dc.b	$FF
	dc.b	0
	dc.l	unk_465E
unk_4674
	dc.b	4
	dc.b	0
	dc.b	5
	dc.b	1
	dc.b	4
	dc.b	0
	dc.b	5
	dc.b	2
	dc.b	$FF
	dc.b	0
	dc.l	unk_4674
unk_4682
	dc.b	$F0
	dc.b	0
	dc.b	1
	dc.b	1
	dc.b	0
	dc.b	0
	dc.b	1
	dc.b	2
	dc.b	0
	dc.b	0
	dc.b	1
	dc.b	1
	dc.b	0
	dc.b	0
	dc.b	1
	dc.b	2
	dc.b	$FF
	dc.b	0
	dc.l	unk_4682

; =============== S U B	R O U T	I N E =====================================================


SpawnGarbage:
	tst.w	pfhGarbageCnt(a0)
	bne.w	.HasGarbage
	rts

.HasGarbage:
	bsr.w	GetPuyoField
	adda.l	#pfColors+(PUYO_FIELD_W*2),a2

	lea	garbage_puyo_data,a3
	bsr.w	SetGarbageOrder
	bsr.w	GetGarbageFreeSpace
	bsr.w	SetGarbageCounts

	sub.w	d7,pfhGarbageCnt(a0)

	lea	ActGarbPuyoHandler,a1
	bsr.w	FindActorSlot
	bcc.w	.Spawned
	rts

.Spawned:
	move.b	aRunFlags(a0),aRunFlags(a1)
	move.b	#1,aYTarget(a1)
	move.l	a0,aField2E(a1)
	movea.l	a1,a2
	move.b	aField2A(a0),aField2A(a1)
	bset	#2,aField7(a0)
	move.w	#2,d0
	tst.b	stage_mode
	bne.w	loc_4710
	cmpi.b	#3,(byte_FF0104).l
	bcc.w	loc_4710
	move.b	(byte_FF0104).l,d0

loc_4710:
	lsl.w	#1,d0
	move.w	word_4730(pc,d0.w),d3
	move.w	#5,d2
	bsr.w	GetPuyoFieldTopLeft

.SpawnLoop:
	tst.b	gpCounts(a3,d2.w)
	beq.w	.DoSpawnLoop
	bsr.w	SpawnGarbagePuyo

.DoSpawnLoop:
	dbf	d2,.SpawnLoop
	rts
; End of function SpawnGarbage

; -----------------------------------------------------------------------------------------
word_4730
	dc.w	3
	dc.w	2
	dc.w	0

; =============== S U B	R O U T	I N E =====================================================


SpawnGarbagePuyo:
	lea	(ActGarbagePuyo).l,a1
	bsr.w	FindActorSlot
	bcc.w	.Spawned
	rts

.Spawned:
	move.b	aRunFlags(a0),aRunFlags(a1)
	move.b	aPuyoField(a0),aPuyoField(a1)
	move.b	#%10000101,aFlags(a1)
	move.b	#6,aMappings(a1)

	move.b	gpCounts(a3,d2.w),d4
	addi.b	#$13,d4
	move.b	d4,aFrame(a1)

	move.l	a2,$2E(a1)
	addq.w	#1,$26(a2)
	addq.b	#1,$20(a2)

	jsr	(sub_11E90).l

	move.w	d2,d4
	move.w	d4,aXAccel(a1)
	lsl.w	#4,d4
	add.w	d0,d4
	addq.w	#8,d4
	move.w	d4,aX(a1)

	move.w	#1,aYAccel(a1)
	move.w	#-1,d4
	lsl.w	#4,d4
	add.w	d1,d4
	addq.w	#8,d4
	move.w	d4,aY(a1)

	subi.w	#$F,d4
	move.w	d4,aYTarget(a1)

	move.w	d2,d4
	lsl.w	#1,d4
	move.w	word_47BA(pc,d4.w),d5
	move.w	d5,aXTarget(a1)
	move.w	d3,aYVel(a1)
	rts

; -----------------------------------------------------------------------------------------
word_47BA
	dc.w	$2400
	dc.w	$2600
	dc.w	$2000
	dc.w	$2A00
	dc.w	$2200
	dc.w	$2800

; =============== S U B	R O U T	I N E =====================================================


SetGarbageOrder:
	move.w	#5,d0

loc_47CA:
	move.b	d0,(a3,d0.w)
	dbf	d0,loc_47CA
	move.w	#5,d1

loc_47D6:
	move.w	#6,d0
	jsr	RandomBound
	move.b	(a3,d0.w),d2
	move.b	(a3,d1.w),(a3,d0.w)
	move.b	d2,(a3,d1.w)
	dbf	d1,loc_47D6
	rts
; End of function SetGarbageOrder


; =============== S U B	R O U T	I N E =====================================================


GetGarbageFreeSpace:
	move.w	#5,d0

loc_47F8:
	clr.b	d1
	move.w	d0,d2
	lsl.w	#1,d2
	move.w	#$C,d3

loc_4802:
	tst.b	(a2,d2.w)
	bne.w	loc_480C
	addq.b	#1,d1

loc_480C:
	addi.w	#$C,d2
	dbf	d3,loc_4802
	move.b	d1,gpFreeSpace(a3,d0.w)
	dbf	d0,loc_47F8
	rts
; End of function GetGarbageFreeSpace


; =============== S U B	R O U T	I N E =====================================================


SetGarbageCounts:
	move.w	#5,d0

loc_4822:
	clr.b	gpCounts(a3,d0.w)
	dbf	d0,loc_4822
	move.w	pfhGarbageCnt(a0),d0
	cmpi.w	#$1F,d0
	bcs.w	loc_483A
	move.w	#$1E,d0

loc_483A:
	subq.w	#1,d0
	clr.w	d1
	clr.w	d7

loc_4840:
	clr.w	d2
	move.b	(a3,d1.w),d2
	move.b	gpCounts(a3,d2.w),d3
	cmp.b	gpFreeSpace(a3,d2.w),d3
	bcc.w	loc_4858
	addq.b	#1,gpCounts(a3,d2.w)
	addq.w	#1,d7

loc_4858:
	addq.b	#1,d1
	cmpi.b	#6,d1
	bcs.w	loc_4864
	clr.b	d1

loc_4864:
	dbf	d0,loc_4840
	rts
; End of function SetGarbageCounts


; =============== S U B	R O U T	I N E =====================================================


ActGarbagePuyo:
	bsr.w	sub_4948
	bcs.w	loc_4874
	rts
; -----------------------------------------------------------------------------------------

loc_4874:
	clr.w	d0
	move.b	9(a0),d0
	subi.w	#$14,d0

loc_487E:
	movem.l	d0,-(sp)
	bsr.w	MarkPuyoSpot
	movem.l	(sp)+,d0
	subq.w	#1,$1C(a0)
	dbf	d0,loc_487E
	movea.l	$2E(a0),a1
	subq.w	#1,$26(a1)
	move.b	9(a0),9(a1)
	bra.w	loc_502C
; End of function ActGarbagePuyo


; =============== S U B	R O U T	I N E =====================================================

gphFlags	EQU	$07
gphX		EQU	$2C

ActGarbPuyoHandler:
	move.w	aField26(a0),aField28(a0)
	bsr.w	GetPuyoField
	andi.w	#$7F,d0
	move.w	d0,gphX(a0)
	bsr.w	ActorBookmark

.Main:
	move.w	aField26(a0),d0
	cmp.w	aField28(a0),d0
	beq.w	.Shake
	move.w	d0,aField28(a0)
	move.w	aYTarget(a0),aField38(a0)

	btst	#0,gphFlags(a0)
	bne.w	.Shake
	move.b	#VOI_GARBAGE_1,d0
	jsr	PlaySound_ChkSamp
	bset	#0,gphFlags(a0)

.Shake:
	move.b	aField36(a0),d0
	move.w	aField38(a0),d1
	move.w	gphX(a0),d3
	move.w	#6-1,d4
	lea	(vscroll_buffer).l,a2

loc_4900:
	andi.b	#$7F,d0
	jsr	(Sin).l
	swap	d2
	move.w	d2,(a2,d3.w)
	addi.b	#$20,d0
	addq.w	#4,d3
	dbf	d4,loc_4900

	addi.b	#$18,aField36(a0)
	tst.w	aField38(a0)
	beq.w	loc_4930
	subi.w	#$40,aField38(a0)
	rts
; -----------------------------------------------------------------------------------------

loc_4930:
	tst.w	aField26(a0)
	beq.w	loc_493A
	rts
; -----------------------------------------------------------------------------------------

loc_493A:
	movea.l	aField2E(a0),a1
	bclr	#2,aField7(a1)
	bra.w	ActorDeleteSelf
; End of function ActGarbPuyoHandler


; =============== S U B	R O U T	I N E =====================================================


sub_4948:
	move.l	aY(a0),d0
	move.l	aYVel(a0),d1
	add.l	d0,d1

	move.l	d0,d2
	swap	d2
	move.l	d1,d3
	swap	d3

	sub.w	aYTarget(a0),d2
	sub.w	aYTarget(a0),d3

	eor.l	d2,d3
	btst	#4,d3
	beq.w	loc_4990

	move.b	#2,d0
	bsr.w	CheckPuyoLand2
	btst	#0,d0
	beq.w	loc_498C

.Landed:
	swap	d1
	andi.b	#$F8,d1
	move.w	d1,aY(a0)
	ori	#1,sr
	rts
; -----------------------------------------------------------------------------------------

loc_498C:
	addq.w	#1,aYAccel(a0)

loc_4990:
	move.l	d1,aY(a0)
	clr.l	d0
	move.w	aXTarget(a0),d0
	move.l	aYVel(a0),d1
	add.l	d0,d1
	cmpi.l	#$80000,d1
	bcs.w	loc_49B0
	move.l	#$80000,d1

loc_49B0:
	move.l	d1,aYVel(a0)
	andi	#$FFFE,sr
	rts
; End of function sub_4948


; =============== S U B	R O U T	I N E =====================================================


sub_49BA:
	bsr.w	GetPuyoField
	movea.l	a2,a3
	adda.l	#$138,a3
	move.w	#$53,d0

loc_49CA:
	move.w	(a2)+,(a3)+
	dbf	d0,loc_49CA
	rts
; End of function sub_49BA


; =============== S U B	R O U T	I N E =====================================================


sub_49D2:
	bsr.w	GetPuyoField
	adda.l	#$18,a2
	movea.l	a2,a3
	adda.l	#$90,a3
	movea.l	a3,a4
	adda.l	#$A8,a4
	clr.w	d0
	move.b	aDelay+1(a0),d1
	andi.b	#1,d1
	eori.b	#1,d1
	clr.b	d2
	sub.b	d1,d2

loc_49FE:
	move.b	(a3,d0.w),d1
	bmi.w	.Unaffected
	move.b	(a4,d0.w),d3
	and.b	d2,d3
	move.b	d3,(a2,d0.w)

.Unaffected:
	addq.w	#2,d0
	cmpi.w	#$90,d0
	bcs.s	loc_49FE
	DISABLE_INTS
	bsr.w	sub_5782
	ENABLE_INTS
	rts
; End of function sub_49D2


; =============== S U B	R O U T	I N E =====================================================


CheckPuyoPop:
	bsr.w	GetPuyoField
	bsr.w	GetPuyoFieldTopLeft
	addq.w	#8,d0
	move.w	d0,d2
	addq.w	#8,d1
	move.w	d1,d3
	adda.l	#$18,a2
	movea.l	a2,a3
	adda.l	#$90,a3
	movea.l	a3,a4
	adda.l	#$A8,a4
	clr.w	d4
	clr.b	d5
	clr.w	d6

.CheckPuyos:
	move.b	(a3,d4.w),d7
	bmi.w	.Unaffected
	btst	#6,d7
	beq.w	.Popped

.Removed:
	bsr.w	SpawnGarbageRemove
	bra.w	.Unaffected
; -----------------------------------------------------------------------------------------

.Popped:
	bsr.w	SpawnPuyoPop

.Unaffected:
	addi.w	#$10,d2
	addq.b	#1,d5
	cmpi.b	#6,d5
	bcs.w	.NextPuyo
	clr.b	d5
	move.w	d0,d2
	addi.w	#$10,d3

.NextPuyo:
	addq.w	#2,d4
	cmpi.w	#$90,d4
	bcs.s	.CheckPuyos
	bra.s	loc_4ABC
; -----------------------------------------------------------------------------------------
	btst	#1,stage_mode
	bne.w	loc_4ABC
	clr.w	d1
	cmpi.b	#1,aFrame(a0)
	bne.w	loc_4ABC
	move.b	#VOI_87,d0
	tst.b	aField2A(a0)
	beq.w	loc_4AB6
	move.b	#VOI_P1_COMBO_1,d0

loc_4AB6:
	jmp	PlaySound_ChkSamp
; -----------------------------------------------------------------------------------------

loc_4ABC:
	clr.w	d1
	move.b	aFrame(a0),d1
	cmpi.b	#7,d1
	bcs.w	loc_4ACE
	move.b	#6,d1

loc_4ACE:
	move.b	PuyoPopSounds(pc,d1.w),d0
	jmp	PlaySound_ChkSamp
; End of function CheckPuyoPop

; -----------------------------------------------------------------------------------------
PuyoPopSounds
	dc.b	SFX_PUYO_POP_1
	dc.b	SFX_PUYO_POP_2
	dc.b	SFX_PUYO_POP_3
	dc.b	SFX_PUYO_POP_4
	dc.b	SFX_PUYO_POP_5
	dc.b	SFX_PUYO_POP_6
	dc.b	SFX_PUYO_POP_7
	dc.b	0

; =============== S U B	R O U T	I N E =====================================================


SpawnPuyoPop:
	lea	(ActPuyoPop).l,a1
	bsr.w	FindActorSlotQuick
	bcc.w	.Spawned
	rts
; -----------------------------------------------------------------------------------------

.Spawned:
	move.b	aRunFlags(a0),aRunFlags(a1)
	move.b	aField2A(a0),aField2A(a1)
	move.b	#$80,aFlags(a1)
	move.b	#8,aFrame(a1)
	move.w	d2,aX(a1)
	move.w	d3,aY(a1)
	move.w	d2,(garbage_glow_x).l
	move.w	d3,(garbage_glow_y).l
	move.l	#Anim_PuyoPop,aAnim(a1)
	move.w	d6,aDelay(a1)
	addq.w	#4,d6
	andi.w	#$F,d6
	move.b	(a4,d4.w),d7
	lsr.b	#4,d7
	andi.b	#7,d7
	move.b	d7,aMappings(a1)
	rts
; End of function SpawnPuyoPop


; =============== S U B	R O U T	I N E =====================================================


SpawnGarbageRemove:
	lea	(ActGarbageRemove).l,a1
	bsr.w	FindActorSlotQuick
	bcc.w	.Spawned
	rts
; -----------------------------------------------------------------------------------------

.Spawned:
	move.b	aRunFlags(a0),aRunFlags(a1)
	move.b	#$80,aFlags(a1)
	move.b	#6,aMappings(a1)
	move.w	d2,aX(a1)
	move.w	d3,aY(a1)
	move.l	#Anim_GarbageRemove,aAnim(a1)
	rts
; End of function SpawnGarbageRemove


; =============== S U B	R O U T	I N E =====================================================


ActPuyoPop:
	bsr.w	ActorBookmark
	bsr.w	ActPuyoPop_Pop
	bsr.w	ActorBookmark
	bsr.w	ActorAnimate
	bcs.w	ActorDeleteSelf
	rts
; End of function ActPuyoPop

; -----------------------------------------------------------------------------------------
Anim_PuyoPop
	dc.b	8
	dc.b	8
	dc.b	1
	dc.b	4
	dc.b	1
	dc.b	5
	dc.b	1
	dc.b	6
	dc.b	$FE
	dc.b	0

; =============== S U B	R O U T	I N E =====================================================


ActPuyoPop_Pop:
	move.b	stage_mode,d2
	andi.b	#3,d2
	bne.w	ActPuyoPop_PopNormal
	tst.b	aField2A(a0)
	beq.w	ActPuyoPop_PopNormal
	clr.w	d0
	move.b	opponent,d0
	lsl.b	#2,d0
	movea.l	off_4BB8(pc,d0.w),a1
	jmp	(a1)
; -----------------------------------------------------------------------------------------
off_4BB8
	dc.l	ActPuyoPop_PopNormal
	dc.l	ActPuyoPop_PopNormal
	dc.l	ActPuyoPop_PopNormal
	dc.l	ActPuyoPop_PopNormal
	dc.l	ActPuyoPop_PopNormal
	dc.l	ActPuyoPop_PopNormal
	dc.l	ActPuyoPop_PopNormal
	dc.l	ActPuyoPop_PopNormal
	dc.l	ActPuyoPop_PopNormal
	dc.l	ActPuyoPop_PopNormal
	dc.l	ActPuyoPop_PopNormal
	dc.l	ActPuyoPop_PopNormal
	dc.l	ActPuyoPop_PopNormal
	dc.l	ActPuyoPop_PopNormal
	dc.l	ActPuyoPop_PopNormal
	dc.l	ActPuyoPop_PopNormal
; -----------------------------------------------------------------------------------------
	lea	(loc_4C46).l,a1
	bsr.w	FindActorSlotQuick
	bcs.s	locret_4C44
	move.b	0(a0),0(a1)
	move.b	#$10,8(a1)
	bsr.w	Random
	andi.b	#3,d0
	addi.b	#$F,d0
	move.b	d0,9(a1)
	move.w	$A(a0),$A(a1)
	move.w	$E(a0),$E(a1)
	move.w	#$1400,$1C(a1)
	move.w	#$FFFE,$16(a1)
	move.w	#$FFFF,$20(a1)
	move.w	#$20,$26(a1)

locret_4C44:
	rts
; -----------------------------------------------------------------------------------------

loc_4C46:
	move.w	#4,d0
	bsr.w	ActorBookmark_SetDelay
	bsr.w	ActorBookmark
	move.b	#$85,6(a0)
	bsr.w	ActorMove
	subq.w	#1,$26(a0)
	beq.w	loc_4C66
	rts
; -----------------------------------------------------------------------------------------

loc_4C66:
	jmp	(ActorDeleteSelf).l
; -----------------------------------------------------------------------------------------
	move.b	#$20,d0
	move.w	#$180,d1
	move.w	#3,d3

loc_4C78:
	lea	(loc_4CCE).l,a1
	bsr.w	FindActorSlotQuick
	bcs.s	loc_4CC8
	move.b	0(a0),0(a1)
	move.b	#6,8(a1)
	move.b	#$F,9(a1)
	move.w	$A(a0),$A(a1)
	move.w	$E(a0),$E(a1)
	move.w	#$18,$26(a1)
	movem.l	d0,-(sp)
	jsr	(Sin).l
	move.l	d2,$12(a1)
	jsr	(Cos).l
	move.l	d2,$16(a1)
	movem.l	(sp)+,d0
	addi.b	#$40,d0

loc_4CC8:
	dbf	d3,loc_4C78
	rts
; -----------------------------------------------------------------------------------------

loc_4CCE:
	move.w	#4,d0
	bsr.w	ActorBookmark_SetDelay
	bsr.w	ActorBookmark
	move.b	#$83,6(a0)
	jsr	(ActorMove).l
	subq.w	#1,$26(a0)
	beq.w	loc_4CF0
	rts
; -----------------------------------------------------------------------------------------

loc_4CF0:
	move.w	#4,d0
	bsr.w	ActorBookmark_SetDelay
	bsr.w	ActorBookmark
	jmp	(ActorDeleteSelf).l
; -----------------------------------------------------------------------------------------

ActPuyoPop_PopNormal:
	move.w	#3,d3
	move.w	#$400,d1

.SpawnPieces:
	lea	(ActPuyoPoppedPiece).l,a1
	bsr.w	FindActorSlotQuick
	bcs.s	.DoLoop
	move.b	aRunFlags(a0),aRunFlags(a1)
	move.b	aMappings(a0),aMappings(a1)
	move.b	#6,aFrame(a1)
	move.w	aX(a0),aX(a1)
	move.w	aY(a0),aY(a1)
	move.w	#$4000,aYAccel(a1)
	move.w	#$FFFF,$20(a1)
	move.l	#Anim_PuyoPoppedPiece,aAnim(a1)
	move.b	d3,d2
	ror.b	#4,d2
	addi.b	#$64,d2
	bsr.w	Random
	andi.b	#7,d0
	add.b	d2,d0
	jsr	(Sin).l
	move.l	d2,aXVel(a1)
	jsr	(Cos).l
	move.l	d2,aYVel(a1)

.DoLoop:
	dbf	d3,.SpawnPieces
	rts
; End of function ActPuyoPop_Pop


; =============== S U B	R O U T	I N E =====================================================


ActPuyoPoppedPiece:
	move.w	#4,d0
	bsr.w	ActorBookmark_SetDelay
	bsr.w	ActorBookmark
	move.b	#$87,aFlags(a0)
	bsr.w	ActorAnimate
	bcs.w	ActorDeleteSelf
	bsr.w	ActorMove
	bcs.w	ActorDeleteSelf
	rts
; End of function ActPuyoPoppedPiece

; -----------------------------------------------------------------------------------------
Anim_PuyoPoppedPiece:
	dc.b	1, 6, 3, 5, 6, 4, 3, 5, 4, 6, $FE, 0

; =============== S U B	R O U T	I N E =====================================================


ActGarbageRemove:
	bsr.w	ActorAnimate
	bcs.w	ActorDeleteSelf
	rts
; End of function ActGarbageRemove

; -----------------------------------------------------------------------------------------
Anim_GarbageRemove:dc.b	6
	dc.b	0
	dc.b	6
	dc.b	1
	dc.b	6
	dc.b	2
	dc.b	6
	dc.b	3
	dc.b	$FE
	dc.b	0

; =============== S U B	R O U T	I N E =====================================================


sub_4DB8:
	bsr.w	GetPuyoField
	movea.l	a2,a3
	adda.l	#$C,a2
	adda.l	#$1E0,a3
	move.w	#$9A,d0

loc_4DCE:
	move.w	d0,d1
	move.w	d0,d2
	clr.w	d3

loc_4DD4:
	clr.w	(a3,d1.w)
	addi.w	#$100,d3
	tst.b	(a2,d1.w)
	beq.w	loc_4E04
	move.w	(a2,d1.w),d4
	clr.b	(a2,d1.w)
	andi.w	#$FF00,d4
	move.w	d4,(a2,d2.w)
	subi.w	#$C,d2
	subi.w	#$100,d3
	beq.w	loc_4E04
	move.w	d3,(a3,d1.w)

loc_4E04:
	subi.w	#$C,d1
	bcc.s	loc_4DD4
	subq.w	#2,d0
	cmpi.w	#$90,d0
	bcc.s	loc_4DCE
	rts
; End of function sub_4DB8

; -----------------------------------------------------------------------------------------

loc_4E14:
	move.l	a0,d0
	swap	d0
	move.w	#$8900,d0
	swap	d0
	jmp	QueuePlaneCmd

; -----------------------------------------------------------------------------------------
; Spawn falling puyos
; -----------------------------------------------------------------------------------------
; PARAMETERS:
;	a0.l	- Pointer to puyo field actor slot
; RETURNS:
;	cc/cs	- Spawned/Third column full
; -----------------------------------------------------------------------------------------

SpawnFallingPuyos:
	bsr.w	QueueNextPuyoColors
	cmpi.b	#$19,d0
	beq.w	SpawnCarbuncle
	cmpi.b	#$1A,d1
	beq.w	SpawnGiantPuyo

	movem.l	d0-d1,-(sp)
	bsr.w	GetPuyoField
	movem.l	(sp)+,d0-d1
	tst.b	pfVisColors+(2*2)(a2)
	beq.w	.SpawnPuyos

	SET_CARRY
	rts

.SpawnPuyos:
	lea	ActCenterFallingPuyo,a1
	bsr.w	FindActorSlot
	move.b	0(a0),0(a1)
	move.l	a0,$2E(a1)
	move.l	#unk_4EFC,$32(a1)
	move.b	$2A(a0),$2A(a1)
	move.b	d0,8(a1)
	move.w	#2,$1A(a1)
	move.w	#2,$1C(a1)
	move.w	#0,$1E(a1)
	move.w	#0,$20(a1)
	ori.b	#1,7(a0)
	movea.l	a1,a2

	lea	ActAttachedFallingPuyo,a1
	bsr.w	FindActorSlot
	move.b	0(a0),0(a1)
	move.l	a2,$2E(a1)
	move.l	#unk_4EE4,$32(a1)
	move.b	$2A(a0),$2A(a1)
	move.b	d1,8(a1)
	move.b	#0,$2B(a1)
	move.l	a1,$36(a2)
	ori.b	#2,7(a0)

	CLEAR_CARRY
	rts

; -----------------------------------------------------------------------------------------
unk_4ED4:
	dc.b	1
	dc.b	2
	dc.b	0
	dc.b	0
	dc.b	2
	dc.b	3
	dc.b	0
	dc.b	0
	dc.b	1
	dc.b	2
	dc.b	0
	dc.b	0
	dc.b	2
	dc.b	3
	dc.b	0
	dc.b	0
unk_4EE4:
	dc.b	$FE
	dc.b	0
unk_4EE6:
	dc.b	1
	dc.b	2
	dc.b	0
	dc.b	0
	dc.b	2
	dc.b	3
	dc.b	0
	dc.b	0
	dc.b	1
	dc.b	2
	dc.b	0
	dc.b	0
	dc.b	2
	dc.b	3
	dc.b	0
	dc.b	0
	dc.b	$FF
	dc.b	0
	dc.l	unk_4EFC
unk_4EFC:
	dc.b	$A
	dc.b	1
	dc.b	8
	dc.b	0
	dc.b	$FF
	dc.b	0
	dc.l	unk_4EFC

; -----------------------------------------------------------------------------------------
; Center falling puyo actor
; -----------------------------------------------------------------------------------------

ActCenterFallingPuyo:
	bsr.w	sub_543C
	move.b	#$80,aFlags(a0)
	bsr.w	ActorBookmark
	movea.l	aField2E(a0),a1
	btst	#0,aField7(a1)
	beq.w	loc_4F3A
	bsr.w	ActorAnimate
	bsr.w	sub_5060
	bsr.w	sub_5384
	bsr.w	sub_50DA
	bcs.w	loc_4F50
	bra.w	sub_543C
; -----------------------------------------------------------------------------------------

loc_4F3A:
	move.b	#0,aFlags(a0)
	movea.l	aField36(a0),a1
	move.b	#0,aFlags(a1)
	bsr.w	ActorBookmark
	rts
; -----------------------------------------------------------------------------------------

loc_4F50:
	bsr.w	sub_543C
	bsr.w	CheckPuyoLand
	ori.b	#4,d0
	move.b	d0,aField7(a0)
	btst	#0,d0
	bne.w	loc_4FA0
	move.w	$E(a0),d0
	subi.w	#$F,d0
	move.w	d0,$20(a0)
	move.w	#$3000,$1E(a0)
	move.w	#1,$16(a0)
	move.b	#0,9(a0)
	bsr.w	ActorBookmark
	bsr.w	sub_4948
	bcs.w	loc_4F94
	rts
; -----------------------------------------------------------------------------------------

loc_4F94:
	bsr.w	PlayPuyoLandSound
	move.l	#unk_4ED4,$32(a0)

loc_4FA0:
	clr.b	$22(a0)
	bsr.w	ActorBookmark
	bsr.w	ActorAnimate
	bcs.w	loc_4FB2
	rts
; -----------------------------------------------------------------------------------------

loc_4FB2:
	movea.l	$2E(a0),a1
	bclr	#0,7(a1)
	bsr.w	MarkPuyoSpot

loc_4FC0:
	move.b	#7,9(a0)
	move.w	#$18,d0
	bsr.w	ActorBookmark_SetDelay
	clr.w	d0
	move.b	$2A(a0),d0
	lea	puyos_popping,a1
	tst.b	(a1,d0.w)
	bne.w	ActorDeleteSelf
	bsr.w	ActorBookmark
	move.b	#6,$26(a0)
	clr.b	$28(a0)
	bsr.w	ActorBookmark
	move.b	$2A(a0),d0
	lea	puyos_popping,a1
	tst.b	(a1,d0.w)
	bne.w	ActorDeleteSelf
	addq.b	#1,$28(a0)
	cmpi.b	#4,$28(a0)
	bcc.w	loc_5016
	rts
; -----------------------------------------------------------------------------------------

loc_5016:
	clr.b	$28(a0)
	subq.w	#1,$A(a0)
	subq.w	#1,$E(a0)
	subq.b	#1,$26(a0)
	beq.w	ActorDeleteSelf
	rts
; -----------------------------------------------------------------------------------------
; START	OF FUNCTION CHUNK FOR ActGarbagePuyo

loc_502C:
	cmpi.b	#$15,9(a0)
	bcc.w	ActorDeleteSelf
	addq.b	#6,9(a0)
	move.w	#$30,$26(a0)
	bsr.w	ActorBookmark
	move.b	$2A(a0),d0
	lea	puyos_popping,a1
	tst.b	(a1,d0.w)
	bne.w	ActorDeleteSelf
	subq.w	#1,$26(a0)
	beq.w	ActorDeleteSelf
	rts
; END OF FUNCTION CHUNK	FOR ActGarbagePuyo

; =============== S U B	R O U T	I N E =====================================================


sub_5060:



	tst.w	$1E(a0)
	beq.w	loc_507E
	move.w	#8,d0
	btst	#7,$1E(a0)
	bne.w	loc_5078
	neg.w	d0

loc_5078:
	add.w	d0,$1E(a0)
	rts
; -----------------------------------------------------------------------------------------

loc_507E:
	btst	#3,7(a0)
	beq.w	loc_508A
	rts
; -----------------------------------------------------------------------------------------

loc_508A:
	bsr.w	GetFieldCtrlData
	btst	#2,d1
	bne.w	loc_50A0
	btst	#3,d1
	bne.w	loc_50B0
	rts
; -----------------------------------------------------------------------------------------

loc_50A0:
	move.b	#3,d0
	move.w	#$FFFF,d2
	move.w	#8,d3
	bra.w	loc_50BC
; -----------------------------------------------------------------------------------------

loc_50B0:
	move.b	#1,d0
	move.w	#1,d2
	move.w	#$FFF8,d3

loc_50BC:
	bsr.w	CheckPuyoLand2
	tst.b	d0
	beq.w	loc_50C8
	rts
; -----------------------------------------------------------------------------------------

loc_50C8:
	move.w	$1A(a0),d0
	add.w	d2,d0
	move.w	d0,$1A(a0)
	move.w	d3,$1E(a0)
	bra.w	PlayPuyoMoveSound
; End of function sub_5060


; =============== S U B	R O U T	I N E =====================================================


sub_50DA:



	btst	#3,7(a0)
	bne.w	loc_51B4
	movea.l	$2E(a0),a1
	move.w	$1A(a1),d1
	cmpi.w	#$8001,d1
	bcc.w	loc_5222
	bsr.w	GetFieldCtrlData
	lsr.w	#8,d0
	andi.b	#$E,d0
	cmpi.b	#2,d0
	bne.w	loc_511A
	move.w	#$8000,d1
	move.w	(frame_count).l,d2
	lsl.b	#3,d2
	andi.b	#8,d2
	or.b	d2,7(a1)

loc_511A:
	move.w	$20(a0),d0
	add.w	d0,d1
	bcs.w	loc_516A
	move.w	d1,$20(a0)
	eor.w	d1,d0
	bpl.w	loc_5164
	bsr.w	CheckPuyoLand
	tst.b	d0
	beq.w	loc_5164
	move.b	d0,d2
	bsr.w	PuyoLandEffects
	btst	#0,d2
	beq.w	loc_514A
	bsr.w	sub_5288

loc_514A:
	btst	#1,d2
	beq.w	loc_5156
	bsr.w	sub_52AE

loc_5156:
	addq.w	#1,$26(a0)
	cmpi.w	#8,$26(a0)
	bcc.w	loc_51B4

loc_5164:
	andi	#$FFFE,sr
	rts
; -----------------------------------------------------------------------------------------

loc_516A:
	bsr.w	CheckPuyoLand
	tst.b	d0
	bne.w	loc_5182
	clr.w	$20(a0)
	addq.w	#1,$1C(a0)
	andi	#$FFFE,sr
	rts
; -----------------------------------------------------------------------------------------

loc_5182:
	tst.w	$28(a0)
	bne.w	loc_5194
	bsr.w	sub_51DA
	andi	#$FFFE,sr
	rts
; -----------------------------------------------------------------------------------------

loc_5194:
	subq.w	#1,$28(a0)
	beq.w	loc_51B4
	bsr.w	GetFieldCtrlData
	lsr.w	#8,d0
	andi.b	#$E,d0
	cmpi.b	#2,d0
	beq.w	loc_51B4
	andi	#$FFFE,sr
	rts
; -----------------------------------------------------------------------------------------

loc_51B4:
	bset	#3,7(a0)
	tst.w	$1E(a0)
	bne.w	loc_51D4
	movea.l	$36(a0),a1
	tst.b	$38(a1)

loc_51CA:
	bne.w	loc_51D4
	ori	#1,sr
	rts
; -----------------------------------------------------------------------------------------

loc_51D4:
	andi	#$FFFE,sr
	rts
; End of function sub_50DA


; =============== S U B	R O U T	I N E =====================================================


sub_51DA:
	movea.l	aField2E(a0),a1
	cmpi.b	#8,aField2B(a1)
	clr.w	d0
	move.b	$1A(a0),d0
	bpl.w	loc_51F2
	move.b	#$7F,d0

loc_51F2:
	lsr.b	#3,d0
	neg.w	d0
	addi.w	#$20,d0
	move.w	d0,aField28(a0)
	rts
; End of function sub_51DA

; -----------------------------------------------------------------------------------------
	clr.w	d0
	move.b	aField2B(a1),d0
	subq.b	#8,d0
	lsr.b	#2,d0
	cmpi.b	#8,d0
	bcs.w	loc_5216
	move.b	#7,d0

loc_5216:
	neg.w	d0
	addi.w	#$11,d0
	move.w	d0,aField28(a0)
	rts
; -----------------------------------------------------------------------------------------
; START	OF FUNCTION CHUNK FOR sub_50DA

loc_5222:
	move.w	aYTarget(a0),d2
	add.w	d1,aYTarget(a0)
	bcs.w	loc_5230
	rts
; -----------------------------------------------------------------------------------------

loc_5230:
	bsr.w	CheckPuyoLand
	tst.b	d0
	bne.w	loc_524A
	addq.w	#1,aYAccel(a0)
	andi.b	#$FE,aYTarget+1(a0)
	andi	#$FFFE,sr
	rts
; -----------------------------------------------------------------------------------------

loc_524A:
	cmpi.w	#$FFFF,d2
	beq.w	loc_527E
	move.b	d0,d2
	bsr.w	PuyoLandEffects
	btst	#0,d2
	beq.w	loc_5264
	bsr.w	sub_5288

loc_5264:
	btst	#1,d2
	beq.w	loc_5270
	bsr.w	sub_52AE

loc_5270:
	addq.w	#1,aField26(a0)
	cmpi.w	#8,aField26(a0)
	bcc.w	loc_51B4

loc_527E:
	move.w	#$FFFF,aYTarget(a0)
	bra.w	loc_5182
; END OF FUNCTION CHUNK	FOR sub_50DA

; =============== S U B	R O U T	I N E =====================================================


sub_5288:
	cmpi.b	#$19,aMappings(a0)
	beq.w	locret_52AC
	move.l	#unk_8E92,aAnim(a0)
	cmpi.b	#$1A,aMappings(a0)
	beq.w	locret_52AC
	move.l	#unk_4EE6,aAnim(a0)

locret_52AC:
	rts
; End of function sub_5288


; =============== S U B	R O U T	I N E =====================================================


sub_52AE:
	cmpi.b	#$19,aMappings(a0)
	beq.w	locret_52D4
	bcs.w	loc_52C8
	move.l	#unk_8E92,aAnim(a0)
	bra.w	locret_52D4
; -----------------------------------------------------------------------------------------

loc_52C8:
	movea.l	aField36(a0),a1
	move.l	#unk_4ED4,aAnim(a1)

locret_52D4:
	rts
; End of function sub_52AE


; =============== S U B	R O U T	I N E =====================================================


CheckPuyoLand:
	move.b	#2,d0
	bsr.w	CheckPuyoLand2
	tst.b	d0
	beq.w	locret_52F2
	btst	#0,aField2B(a0)
	bne.w	locret_52F2
	ori.b	#3,d0

locret_52F2:
	rts
; End of function CheckPuyoLand


; =============== S U B	R O U T	I N E =====================================================


CheckPuyoLand2:
	movem.l	d1-d7/a2,-(sp)
	move.b	#3,d7
	clr.w	d2
	move.b	d0,d2
	lsl.b	#2,d2
	clr.w	d3
	move.b	aField2B(a0),d3
	lsl.b	#2,d3
	move.w	aXAccel(a0),d0
	add.w	word_5374(pc,d2.w),d0
	move.w	aYAccel(a0),d1
	add.w	word_5376(pc,d2.w),d1
	cmpi.w	#6,d0
	bcc.w	loc_5344
	cmpi.w	#$E,d1
	bcc.w	loc_5344
	movem.l	d0-d1,-(sp)
	bsr.w	GetPuyoFieldTile
	move.b	(a2,d1.w),d4
	movem.l	(sp)+,d0-d1
	tst.b	d4
	bne.w	loc_5344
	andi.b	#$FE,d7

loc_5344:
	add.w	word_5374(pc,d3.w),d0
	add.w	word_5376(pc,d3.w),d1
	cmpi.w	#6,d0
	bcc.w	loc_536C
	cmpi.w	#$E,d1
	bcc.w	loc_536C
	bsr.w	GetPuyoFieldTile
	tst.b	(a2,d1.w)
	bne.w	loc_536C
	andi.b	#$FD,d7

loc_536C:
	move.b	d7,d0
	movem.l	(sp)+,d1-d7/a2
	rts
; End of function CheckPuyoLand2

; -----------------------------------------------------------------------------------------
word_5374
	dc.w	0
word_5376
	dc.w	-1
	dc.w	1
	dc.w	0
	dc.w	0
	dc.w	1
	dc.w	-1
	dc.w	0

; =============== S U B	R O U T	I N E =====================================================


sub_5384:



	movea.l	aField36(a0),a1
	tst.b	aField38(a1)
	beq.w	*+4

loc_5390:
	btst	#3,7(a0)
	beq.w	loc_539C
	rts
; -----------------------------------------------------------------------------------------

loc_539C:
	bsr.w	GetFieldCtrlData
	bsr.w	sub_5712
	btst	#6,d0
	bne.w	loc_53B6
	btst	#5,d0
	bne.w	loc_53C2
	rts
; -----------------------------------------------------------------------------------------

loc_53B6:
	move.b	#$FF,d0
	move.b	#$F8,d1
	bra.w	loc_53CA
; -----------------------------------------------------------------------------------------

loc_53C2:
	move.b	#1,d0
	move.b	#8,d1

loc_53CA:
	add.b	aField2B(a0),d0
	andi.b	#3,d0
	move.b	d0,d2
	bsr.w	CheckPuyoLand2
	btst	#0,d0
	beq.w	loc_5416
	move.b	d2,d0
	eori.b	#2,d0
	bsr.w	CheckPuyoLand2
	btst	#0,d0
	beq.w	loc_53F4
	rts
; -----------------------------------------------------------------------------------------

loc_53F4:
	clr.w	d0
	move.b	d2,d0
	lsl.b	#2,d0
	move.w	word_542C(pc,d0.w),d3
	move.w	word_542E(pc,d0.w),d4
	add.w	d3,$1A(a0)
	add.w	d4,$1C(a0)
	tst.w	d4
	beq.w	loc_5416
	move.w	#$7FFE,aYTarget(a0)

loc_5416:
	move.b	aField2B(a0),d0
	ror.b	#2,d0
	move.b	d0,aField36(a1)
	move.b	d2,aField2B(a0)
	move.b	d1,aField38(a1)
	bra.w	PlayPuyoRotateSound
; End of function sub_5384

; -----------------------------------------------------------------------------------------
word_542C
	dc.w	0
word_542E
	dc.w	1
	dc.w	-1
	dc.w	0
	dc.w	0
	dc.w	-1
	dc.w	1
	dc.w	0

; =============== S U B	R O U T	I N E =====================================================


sub_543C:
	bsr.w	GetPuyoFieldTopLeft

	move.w	aXAccel(a0),d2
	lsl.w	#4,d2
	add.w	d2,d0

	move.w	aXTarget(a0),d2
	add.w	d2,d0
	addq.w	#8,d0
	move.w	d0,aX(a0)

	move.w	aYAccel(a0),d2
	subq.w	#2,d2
	lsl.w	#4,d2
	add.w	d2,d1
	addq.w	#8,d1

	move.w	aYTarget(a0),d2
	rol.w	#4,d2
	andi.w	#8,d2
	add.w	d2,d1
	subq.w	#8,d1
	move.w	d1,aY(a0)

	rts
; End of function sub_543C

; -----------------------------------------------------------------------------------------

ActAttachedFallingPuyo:
	bsr.w	sub_5552
	move.b	#$80,6(a0)
	bsr.w	ActorBookmark
	bsr.w	ActorAnimate
	bsr.w	sub_5530
	bsr.w	sub_5552
	movea.l	$2E(a0),a1
	btst	#2,7(a1)
	bne.w	loc_549E
	rts
; -----------------------------------------------------------------------------------------

loc_549E:
	move.w	$1A(a1),d0
	move.w	$1C(a1),d1
	clr.w	d2
	move.b	$2B(a1),d2
	lsl.b	#2,d2
	lea	(word_5374).l,a2
	add.w	(a2,d2.w),d0
	add.w	2(a2,d2.w),d1
	move.w	d0,$1A(a0)
	move.w	d1,$1C(a0)
	move.l	$2E(a1),$2E(a0)
	move.b	7(a1),7(a0)
	bsr.w	ActorBookmark
	btst	#1,7(a0)
	bne.w	loc_5510
	move.w	$E(a0),d0
	subi.w	#$F,d0
	move.w	d0,$20(a0)
	move.w	#$3000,$1E(a0)
	move.w	#1,$16(a0)
	bsr.w	ActorBookmark
	bsr.w	sub_4948
	bcs.w	loc_5504
	rts
; -----------------------------------------------------------------------------------------

loc_5504:
	bsr.w	PlayPuyoLandSound
	move.l	#unk_4ED4,$32(a0)

loc_5510:
	bsr.w	ActorBookmark
	bsr.w	ActorAnimate
	bcs.w	loc_551E
	rts
; -----------------------------------------------------------------------------------------

loc_551E:
	movea.l	$2E(a0),a1
	bclr	#1,7(a1)
	bsr.w	MarkPuyoSpot
	bra.w	loc_4FC0

; =============== S U B	R O U T	I N E =====================================================


sub_5530:
	move.b	$38(a0),d0
	bne.w	loc_553A
	rts
; -----------------------------------------------------------------------------------------

loc_553A:
	add.b	d0,$36(a0)
	move.b	$36(a0),d0
	andi.b	#$3F,d0
	beq.w	loc_554C
	rts
; -----------------------------------------------------------------------------------------

loc_554C:
	clr.b	$38(a0)
	rts
; End of function sub_5530


; =============== S U B	R O U T	I N E =====================================================


sub_5552:
	movea.l	$2E(a0),a1
	move.b	$36(a0),d0
	move.w	#$1000,d1
	jsr	(Sin).l
	swap	d2
	add.w	$A(a1),d2
	move.w	d2,$A(a0)
	jsr	(Cos).l
	swap	d2
	neg.w	d2
	add.w	$E(a1),d2
	move.w	d2,$E(a0)
	rts
; End of function sub_5552


; =============== S U B	R O U T	I N E =====================================================


MarkPuyoSpot:
	move.b	aField2A(a0),d0
	lea	puyos_popping,a1
	tst.b	(a1,d0.w)
	beq.w	.MarkSpot
	rts
; -----------------------------------------------------------------------------------------

.MarkSpot:
	move.w	aXAccel(a0),d0
	move.w	aYAccel(a0),d1
	bsr.w	GetPuyoFieldTile
	move.b	aMappings(a0),d2
	lsl.b	#4,d2
	bset	#7,d2
	cmpi.b	#$E0,d2
	bne.w	.NotGarbage
	ori.b	#$D,d2

.NotGarbage:
	move.b	d2,(a2,d1.w)
	move.b	d2,1(a2,d1.w)
	cmpi.w	#2,aYAccel(a0)
	bcs.w	.NoDraw
	move.w	d0,d1
	move.b	d2,d0
	DISABLE_INTS
	bsr.w	DrawPuyo
	ENABLE_INTS

.NoDraw:
	rts
; End of function MarkPuyoSpot


; =============== S U B	R O U T	I N E =====================================================


ResetPuyoField:
	bsr.w	GetPuyoField
	move.w	#$53,d0

loc_55E4:
	move.w	#$FF,(a2)+
	dbf	d0,loc_55E4
	rts
; End of function ResetPuyoField

; -----------------------------------------------------------------------------------------
	tst.b	(byte_FF196B).l
	bne.w	loc_55FA
	rts
; -----------------------------------------------------------------------------------------

loc_55FA:
	movem.l	a2,-(sp)
	suba.l	#$48,a2
	clr.w	d0
	move.b	(byte_FF196B).l,d0
	subq.b	#1,d0
	mulu.w	#$26,d0
	lea	(byte_5636).l,a1
	adda.w	d0,a1
	move.w	#$23,d0

loc_561E:
	move.b	(a1)+,(a2)+
	move.b	#$FF,(a2)+
	dbf	d0,loc_561E
	movea.l	$32(a0),a2
	move.w	(a1)+,$26(a2)
	movem.l	(sp)+,a2
	rts
; -----------------------------------------------------------------------------------------
byte_5636
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	$80
	dc.b	$90
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	$80
	dc.b	$90
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	$D0
	dc.b	$80
	dc.b	$90
	dc.b	0
	dc.b	0
	dc.b	$D0
	dc.b	$D0
	dc.b	$80
	dc.b	$90
	dc.b	0
	dc.b	0
	dc.b	5
	dc.w	$300
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	$B0
	dc.b	$C0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	$D0
	dc.b	$B0
	dc.b	$C0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	$D0
	dc.b	$B0
	dc.b	$C0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	$D0
	dc.b	$B0
	dc.b	$C0
	dc.b	0
	dc.b	0
	dc.b	5
	dc.w	$400
	dc.b	0
	dc.b	0
	dc.b	$C0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	$90
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	$80
	dc.b	$90
	dc.b	0
	dc.b	$B0
	dc.b	0
	dc.b	0
	dc.b	$D0
	dc.b	$80
	dc.b	0
	dc.b	$B0
	dc.b	0
	dc.b	$D0
	dc.b	$80
	dc.b	$90
	dc.b	0
	dc.b	$C0
	dc.b	$C0
	dc.b	$D0
	dc.b	$80
	dc.b	$90
	dc.b	$B0
	dc.b	$B0
	dc.w	$500

; =============== S U B	R O U T	I N E =====================================================


GetCtrlData:
	move.w	(p1_ctrl+ctlHold).l,d0
	tst.b	swap_fields
	beq.w	locret_56BE
	move.w	(p2_ctrl+ctlHold).l,d0

locret_56BE:
	rts
; End of function GetCtrlData


; =============== S U B	R O U T	I N E =====================================================


GetFieldCtrlData:
	movem.l	d2/a2,-(sp)
	clr.w	d2
	move.b	$2A(a0),d2
	move.b	swap_fields,d0
	eor.b	d0,d2
	mulu.w	#6,d2
	lea	(p1_ctrl).l,a2
	move.w	(a2,d2.w),d0
	move.b	ctlPulse(a2,d2.w),d1
	move.b	stage_mode,d2
	btst	#2,d2
	bne.w	loc_5706
	lsl.b	#1,d2
	or.b	$2A(a0),d2
	eori.b	#1,d2
	and.b	use_cpu_player,d2
	bne.w	loc_570C

loc_5706:
	jsr	(GetCPUCtrlData).l

loc_570C:
	movem.l	(sp)+,d2/a2
	rts
; End of function GetFieldCtrlData


; =============== S U B	R O U T	I N E =====================================================


sub_5712:
	move.b	stage_mode,d2
	btst	#2,d2
	bne.w	locret_5778
	lsl.b	#1,d2
	or.b	$2A(a0),d2
	eori.b	#1,d2
	and.b	use_cpu_player,d2
	beq.w	locret_5778
	movem.l	a2-a3,-(sp)
	clr.w	d1
	move.b	$2A(a0),d1
	move.b	swap_fields,d2
	lea	(player_1_a).l,a2
	eor.b	d2,d1
	beq.w	loc_5756
	lea	(player_2_a).l,a2

loc_5756:
	lea	(byte_577A).l,a3
	clr.w	d1

loc_575E:
	move.b	(a3)+,d2
	bmi.w	loc_5770
	and.b	d0,d2
	beq.w	loc_576C
	or.b	(a2),d1

loc_576C:
	addq.l	#1,a2
	bra.s	loc_575E
; -----------------------------------------------------------------------------------------

loc_5770:
	move.b	(a3,d1.w),d0
	movem.l	(sp)+,a2-a3

locret_5778:
	rts
; End of function sub_5712

; -----------------------------------------------------------------------------------------
byte_577A
	dc.b	$40
	dc.b	$10
	dc.b	$20
	dc.b	$FF
	dc.b	0
	dc.b	$40
	dc.b	$20
	dc.b	$40

; =============== S U B	R O U T	I N E =====================================================


sub_5782:
	bsr.w	GetPuyoField
	move.w	d0,d1
	moveq	#0,d2
	moveq	#0,d3

loc_578C:
	move.b	$18(a2,d2.w),d0
	cmp.b	$19(a2,d2.w),d0
	beq.w	loc_57A0
	move.b	d0,$19(a2,d2.w)
	bsr.w	DrawPuyo

loc_57A0:
	addq.w	#4,d1
	addq.w	#1,d3
	cmpi.w	#6,d3
	bcs.w	loc_57B2
	clr.w	d3
	addi.w	#$E8,d1

loc_57B2:
	addq.w	#2,d2
	cmpi.w	#$90,d2
	bcs.s	loc_578C
	rts
; End of function sub_5782


; =============== S U B	R O U T	I N E =====================================================


DrawPuyo:
	movem.l	d0-d3,-(sp)
	bsr.w	GetPuyoTileID
	move.w	#2,d3
	cmpi.w	#$83FE,d0
	bne.w	.Draw
	clr.w	d3

.Draw:
	move.w	d1,d2
	andi.w	#$3FFF,d2
	ori.w	#$4000,d2
	move.w	d2,VDP_CTRL
	move.w	d1,d2
	lsl.l	#2,d2
	swap	d2
	andi.w	#3,d2
	move.w	d2,VDP_CTRL
	move.w	d0,d2
	move.w	d2,VDP_DATA
	add.w	d3,d2
	move.w	d2,VDP_DATA
	move.w	d1,d2
	addi.w	#$80,d2
	andi.w	#$3FFF,d2
	ori.w	#$4000,d2
	move.w	d2,VDP_CTRL
	move.w	d1,d2
	lsl.l	#2,d2
	swap	d2
	andi.w	#3,d2
	move.w	d2,VDP_CTRL
	move.w	d0,d2
	addq.w	#1,d2
	move.w	d2,VDP_DATA
	add.w	d3,d2
	move.w	d2,VDP_DATA
	movem.l	(sp)+,d0-d3
	rts
; End of function DrawPuyo


; =============== S U B	R O U T	I N E =====================================================


GetPuyoTileID:
	movem.l	d1-d4,-(sp)
	move.w	#$83FE,d1
	or.b	d0,d0
	beq.w	loc_589E
	move.w	#$8000,d1
	clr.b	d1
	clr.w	d2
	move.b	d0,d2
	lsr.b	#4,d2
	andi.b	#7,d2
	mulu.w	#$15,d2
	clr.w	d3
	move.b	d0,d3
	andi.b	#$F,d3
	or.b	d0,d0
	bmi.w	loc_5874
	move.b	byte_58C2(pc,d3.w),d4
	move.b	d4,d3

loc_5874:
	add.b	d3,d2
	lsl.w	#2,d2
	addi.w	#$100,d2
	or.w	d2,d1
	clr.w	d2
	move.b	d0,d2
	lsr.b	#3,d2
	andi.b	#$E,d2
	cmpi.b	#$C,d2
	bne.w	loc_589A
	move.b	d0,d2
	andi.b	#7,d2
	addq.b	#6,d2
	lsl.b	#1,d2

loc_589A:
	or.w	PuyoPalLines(pc,d2.w),d1

loc_589E:
	move.w	d1,d0
	movem.l	(sp)+,d1-d4
	rts
; End of function GetPuyoTileID

; -----------------------------------------------------------------------------------------
PuyoPalLines
	dc.w	0
	dc.w	0
	dc.w	$4000
	dc.w	$4000
	dc.w	$2000
	dc.w	$2000
	dc.w	$4000
	dc.w	$4000
	dc.w	$4000
	dc.w	$4000
	dc.w	$4000
	dc.w	$4000
	dc.w	$4000
	dc.w	$4000
byte_58C2
	dc.b	0
	dc.b	0
	dc.b	$10
	dc.b	$11
	dc.b	$12
	dc.b	$14

; =============== S U B	R O U T	I N E =====================================================


sub_58C8:
	bsr.w	GetPuyoField
	adda.l	#$18,a2
	movea.l	a2,a3
	adda.l	#$90,a3
	clr.w	d0
	clr.b	d1

loc_58DE:
	move.b	(a2,d0.w),d3
	andi.b	#$60,d3
	cmpi.b	#$60,d3
	bne.w	loc_58F2
	bsr.w	sub_5908

loc_58F2:
	addq.b	#1,d1
	cmpi.b	#6,d1
	bcs.w	loc_58FE
	clr.b	d1

loc_58FE:
	addq.w	#2,d0
	cmpi.w	#$90,d0
	bcs.s	loc_58DE
	rts
; End of function sub_58C8


; =============== S U B	R O U T	I N E =====================================================


sub_5908:
	move.w	#6,d2
	clr.b	d3

loc_590E:
	clr.w	d4
	move.b	d1,d4
	add.w	byte_5958(pc,d2.w),d4
	cmpi.w	#$FFFE,d4
	beq.w	loc_5942
	cmpi.w	#7,d4
	beq.w	loc_5942
	move.w	d0,d4
	add.w	byte_5958(pc,d2.w),d4
	cmpi.w	#$90,d4
	bcc.w	loc_5942
	move.b	(a3,d4.w),d5
	andi.b	#$C0,d5
	bne.w	loc_5942
	addq.b	#1,d3

loc_5942:
	subq.w	#2,d2
	bcc.s	loc_590E
	tst.b	d3
	bne.w	loc_594E
	rts
; -----------------------------------------------------------------------------------------

loc_594E:
	ori.b	#$40,d3
	move.b	d3,(a3,d0.w)
	rts
; End of function sub_5908

; -----------------------------------------------------------------------------------------
byte_5958
	dc.b	0
	dc.b	$C
	dc.b	$FF
	dc.b	$F4
	dc.b	0
	dc.b	2
	dc.b	$FF
	dc.b	$FE

; =============== S U B	R O U T	I N E =====================================================


sub_5960:
	bsr.w	GetPuyoField
	adda.l	#$18,a2
	movea.l	a2,a3
	adda.l	#$90,a3
	movea.l	a3,a4
	adda.l	#$90,a4
	movea.l	a3,a5
	clr.l	d1
	move.w	#$23,d0

loc_5982:
	move.l	d1,(a5)+
	dbf	d0,loc_5982
	clr.w	d0
	clr.w	d1

loc_598C:
	tst.b	(a3,d0.w)
	bne.s	loc_59A6
	move.b	#$80,(a3,d0.w)
	move.b	(a2,d0.w),d3
	beq.s	loc_59A6
	cmpi.b	#$E0,d3
	bcc.s	loc_59A6
	bsr.s	sub_59B0

loc_59A6:
	addq.w	#2,d0
	cmpi.w	#$90,d0
	bcs.s	loc_598C
	rts
; End of function sub_5960


; =============== S U B	R O U T	I N E =====================================================


sub_59B0:
	movem.l	d0-d1,-(sp)
	clr.w	d3
	move.w	#2,d4
	move.w	d0,(a4)

loc_59BC:
	clr.l	d5
	move.w	(a4,d3.w),d5
	lsr.w	#1,d5
	divu.w	#6,d5
	swap	d5
	move.b	d5,d2
	move.w	(a4,d3.w),d5
	andi.b	#$F0,(a2,d5.w)
	clr.b	d6
	move.w	#6,d7

loc_59DC:
	lsl.b	#1,d6
	clr.w	d0
	move.b	d2,d0
	add.w	byte_5A46(pc,d7.w),d0
	cmpi.w	#$FFFE,d0
	beq.s	loc_5A22
	cmpi.w	#7,d0
	beq.s	loc_5A22
	move.w	d5,d0
	add.w	byte_5A46(pc,d7.w),d0
	cmpi.w	#$90,d0
	bcc.s	loc_5A22
	move.b	(a2,d0.w),d1
	andi.b	#$F0,d1
	beq.s	loc_5A22
	cmp.b	(a2,d5.w),d1
	bne.s	loc_5A22
	addq.b	#1,d6
	tst.b	(a3,d0.w)
	bne.s	loc_5A22
	move.b	#$80,(a3,d0.w)
	move.w	d0,(a4,d4.w)
	addq.w	#2,d4

loc_5A22:
	subq.w	#2,d7
	bcc.s	loc_59DC
	or.b	d6,(a2,d5.w)
	addq.w	#2,d3
	cmp.w	d4,d3
	bcs.s	loc_59BC
	movem.l	(sp)+,d0-d1
	cmpi.w	#8,d4
	bcc.w	loc_5A66
	cmpi.w	#4,d4
	bcc.w	loc_5A4E
	rts
; -----------------------------------------------------------------------------------------
byte_5A46
	dc.b	0
	dc.b	$C
	dc.b	$FF
	dc.b	$F4
	dc.b	0
	dc.b	2
	dc.b	$FF
	dc.b	$FE
; -----------------------------------------------------------------------------------------

loc_5A4E:
	move.b	d4,d2
	subq.w	#2,d4
	lsr.b	#1,d2
	ori.b	#$80,d2

loc_5A58:
	move.w	(a4,d4.w),d3
	move.b	d2,(a3,d3.w)
	subq.w	#2,d4
	bcc.s	loc_5A58
	rts
; -----------------------------------------------------------------------------------------

loc_5A66:
	addq.w	#1,d1
	move.w	d4,d2
	subq.w	#2,d2

loc_5A6C:
	move.w	(a4,d2.w),d3
	move.b	d1,(a3,d3.w)
	subq.w	#2,d2
	bcc.s	loc_5A6C
	movea.l	a4,a5
	adda.l	#$A8,a5
	move.w	d1,d2
	subq.w	#1,d2
	lsl.w	#1,d2
	lsr.b	#1,d4
	move.b	(a2,d3.w),d5
	andi.b	#$70,d5
	move.b	d4,(a5,d2.w)
	move.b	d5,1(a5,d2.w)
	rts
; End of function sub_59B0


; =============== S U B	R O U T	I N E =====================================================


GetPuyoFieldTile:
	movem.l	d2-d3,-(sp)
	move.w	d0,d2
	move.w	d1,d3
	bsr.w	GetPuyoField
	lsl.b	#1,d3
	move.w	d2,d1
	add.w	d3,d1
	add.w	d3,d1
	add.w	d3,d1
	lsl.b	#1,d1
	lsl.b	#2,d2
	subq.b	#4,d3
	lsl.w	#7,d3
	add.w	d2,d0
	add.w	d3,d0
	movem.l	(sp)+,d2-d3
	rts
; End of function GetPuyoFieldTile


; =============== S U B	R O U T	I N E =====================================================


GetPuyoFieldID:
	movem.l	d0-d1,-(sp)
	move.b	$2A(a0),d0
	move.b	swap_fields,d1
	eor.b	d1,d0
	movem.l	(sp)+,d0-d1
	rts
; End of function GetPuyoFieldID


; =============== S U B	R O U T	I N E =====================================================


GetPuyoField:
	movem.l	d1,-(sp)
	clr.w	d1
	move.b	swap_fields,d1
	lsl.b	#1,d1
	or.b	aField2A(a0),d1
	lsl.b	#3,d1
	movea.l	off_5AFA(pc,d1.w),a2
	move.w	off_5AFA+4(pc,d1.w),d0
	movem.l	(sp)+,d1
	rts
; End of function GetPuyoField

; -----------------------------------------------------------------------------------------
off_5AFA:
	dc.l	p1_puyo_field
	dc.w	$C104
	dc.w	0
	dc.l	p2_puyo_field
	dc.w	$C134
	dc.w	0
	dc.l	p1_puyo_field
	dc.w	$C134
	dc.w	0
	dc.l	p2_puyo_field
	dc.w	$C104
	dc.w	0

; =============== S U B	R O U T	I N E =====================================================


GetPuyoFieldTopLeft:
	clr.w	d1
	or.b	aField2A(a0),d1
	move.b	swap_fields,d0
	eor.b	d0,d1
	lsl.b	#2,d1
	move.w	word_5B34(pc,d1.w),d0
	move.w	word_5B36(pc,d1.w),d1
	rts
; End of function GetPuyoFieldTopLeft

; -----------------------------------------------------------------------------------------
word_5B34
	dc.w	$90
word_5B36
	dc.w	$90
	dc.w	$150
	dc.w	$90
	dc.w	$90
	dc.w	$90
	dc.w	$150
	dc.w	$90
	dc.w	$90
	dc.w	$90
	dc.w	$150
	dc.w	$90
	dc.w	$90
	dc.w	$90
	dc.w	$150
	dc.w	$90

; =============== S U B	R O U T	I N E =====================================================


sub_5B54:
	clr.w	(word_FF19A8).l
	lea	(loc_5BCE).l,a1
	bsr.w	FindActorSlot
	bcc.w	loc_5B6A
	rts
; -----------------------------------------------------------------------------------------

loc_5B6A:
	move.b	#$80,6(a1)
	move.b	#$19,8(a1)
	move.b	#9,9(a1)
	move.b	#$FF,$36(a1)
	move.l	a2,$2E(a1)
	clr.w	d0
	move.b	stage_mode,d0
	andi.b	#3,d0
	lsl.b	#3,d0
	move.w	word_5BAE(pc,d0.w),$A(a1)
	move.w	word_5BAE+2(pc,d0.w),$E(a1)
	move.w	word_5BAE+2(pc,d0.w),$20(a1)
	move.l	word_5BAE+4(pc,d0.w),$32(a1)
	rts
; End of function sub_5B54

; -----------------------------------------------------------------------------------------
word_5BAE:
	dc.w	$140
	dc.w	$128
	dc.l	byte_3316
	dc.w	$120
	dc.w	$108
	dc.l	byte_3316
	dc.w	$120
	dc.w	$10C
	dc.l	byte_3330
	dc.w	$120
	dc.w	$108
	dc.l	byte_3330
; -----------------------------------------------------------------------------------------

loc_5BCE:
	cmpi.b	#1,stage_mode
	bne.w	loc_5BF4
	movea.l	$2E(a0),a1
	movea.l	$2E(a1),a2
	move.b	7(a1),d0
	or.b	7(a2),d0
	btst	#0,d0
	beq.w	loc_5BF4
	rts
; -----------------------------------------------------------------------------------------

loc_5BF4:
	bsr.w	ActorBookmark
	bsr.w	ActorAnimate
	bcs.w	loc_5C4A
	move.b	(p1_ctrl+ctlHold).l,d0
	or.b	(p2_ctrl+ctlHold).l,d0
	andi.b	#$F0,d0
	beq.w	loc_5C18
	clr.w	$22(a0)

loc_5C18:
	cmpi.b	#$17,9(a0)
	beq.w	loc_5C24
	rts
; -----------------------------------------------------------------------------------------

loc_5C24:
	move.b	#$63,d0
	jsr	PlaySound_ChkSamp
	movea.l	$2E(a0),a1
	movea.l	$2E(a1),a2
	move.w	$14(a1),d0
	add.w	$14(a2),d0
	cmpi.w	#$25,d0
	bcc.w	loc_5C4A
	bsr.w	sub_5FAA

loc_5C4A:
	movea.l	$2E(a0),a1
	movea.l	$2E(a1),a2
	bclr	#1,7(a1)
	bclr	#1,7(a2)

loc_5C5E:
	bsr.w	ActorBookmark
	tst.b	(word_FF19A8).l
	bmi.w	loc_5D0C
	move.b	p1_pause,d0
	and.b	p2_pause,d0
	bmi.w	loc_5E86
	bsr.w	sub_5F6E
	bsr.w	ActorAnimate
	bcc.w	loc_5CC2
	tst.w	$26(a0)
	beq.w	loc_5CA0
	subq.w	#1,$26(a0)
	move.l	$2E(a0),d0
	move.l	d0,$32(a0)
	bra.w	loc_5CC2
; -----------------------------------------------------------------------------------------

loc_5CA0:
	bsr.w	sub_5EE8
	bsr.w	sub_5F26
	lsl.w	#2,d0
	lea	(off_3334).l,a1
	movea.l	(a1,d0.w),a2
	move.w	(a2)+,d0
	move.w	d0,$26(a0)
	move.l	a2,$32(a0)
	move.l	a2,$2E(a0)

loc_5CC2:
	clr.w	d0
	move.b	9(a0),d0
	cmp.b	$36(a0),d0
	beq.w	locret_5D02
	move.b	d0,$36(a0)
	cmpi.b	#$40,d0
	bcs.w	locret_5D02
	bne.w	loc_5CF0
	bset	#0,7(a0)
	move.w	#$20,$28(a0)
	bra.w	locret_5D02
; -----------------------------------------------------------------------------------------

loc_5CF0:
	subi.b	#$41,d0
	lsl.b	#1,d0
	move.w	unk_5D04(pc,d0.w),d1
	add.w	d1,$A(a0)
	bsr.w	sub_5F4C

locret_5D02:
	rts
; -----------------------------------------------------------------------------------------
unk_5D04
	dc.b	$FF
	dc.b	$FE
	dc.b	0
	dc.b	2
	dc.b	$FF
	dc.b	$FC
	dc.b	0
	dc.b	4
; -----------------------------------------------------------------------------------------

loc_5D0C:
	lea	(loc_5D64).l,a1
	bsr.w	FindActorSlot
	bcc.w	loc_5D24
	clr.w	(word_FF19A8).l
	bra.w	loc_5C5E
; -----------------------------------------------------------------------------------------

loc_5D24:
	move.l	a0,$2E(a1)
	bsr.w	ActorBookmark
	tst.b	(word_FF19A8+1).l
	beq.w	loc_5D38
	rts
; -----------------------------------------------------------------------------------------

loc_5D38:
	andi.b	#$7F,6(a0)
	bsr.w	ActorBookmark
	tst.b	(word_FF19A8+1).l
	bne.w	loc_5D4E
	rts
; -----------------------------------------------------------------------------------------

loc_5D4E:
	ori.b	#$80,6(a0)
	bsr.w	ActorBookmark
	tst.b	(word_FF19A8+1).l
	beq.w	loc_5C5E
	rts
; -----------------------------------------------------------------------------------------

loc_5D64:
	move.l	#unk_5E7C,$32(a0)
	bsr.w	ActorBookmark
	movea.l	$2E(a0),a1
	bsr.w	ActorAnimate
	bcs.w	loc_5D84
	move.b	9(a0),9(a1)
	rts
; -----------------------------------------------------------------------------------------

loc_5D84:
	move.b	#5,6(a0)
	move.w	$A(a1),$A(a0)
	move.w	$A(a1),$36(a0)
	move.w	$E(a1),$E(a0)
	move.w	$E(a1),$38(a0)
	move.w	#$FFFF,$16(a0)
	move.w	#$A00,$1A(a0)
	move.w	#$1800,$1C(a0)
	move.b	#0,d0
	jsr	PlaySound_ChkSamp
	bsr.w	ActorBookmark
	movea.l	$2E(a0),a1
	bsr.w	ActorMove
	bcs.w	loc_5DDC
	move.w	$A(a0),$A(a1)
	move.w	$E(a0),$E(a1)
	rts
; -----------------------------------------------------------------------------------------

loc_5DDC:
	clr.b	(word_FF19A8+1).l
	bsr.w	ActorBookmark
	tst.b	(word_FF19A8+1).l
	bne.w	loc_5DF2
	rts
; -----------------------------------------------------------------------------------------

loc_5DF2:
	move.b	#5,6(a0)
	move.w	$36(a0),$A(a0)
	clr.l	$16(a0)
	move.w	#$FFFF,$20(a0)
	move.w	#$1800,$1C(a0)
	move.l	#unk_5E6E,$32(a0)
	bsr.w	ActorBookmark
	movea.l	$2E(a0),a1
	bsr.w	ActorMove
	bsr.w	ActorAnimate
	move.b	9(a0),9(a1)
	move.w	$A(a0),$A(a1)
	move.w	$E(a0),d0
	move.w	d0,$E(a1)
	cmp.w	$38(a0),d0
	bcc.w	loc_5E44
	rts
; -----------------------------------------------------------------------------------------

loc_5E44:
	move.b	#$D,9(a1)
	move.w	$36(a0),$A(a1)
	move.w	$38(a0),$E(a1)
	move.b	#$FF,$36(a1)
	clr.w	(word_FF19A8).l
	move.b	#$45,d0
	bsr.w	PlaySound_ChkSamp
	bra.w	ActorDeleteSelf
; -----------------------------------------------------------------------------------------
unk_5E6E
	dc.b	1
	dc.b	$D
	dc.b	1
	dc.b	$24
	dc.b	1
	dc.b	$26
	dc.b	1
	dc.b	$25
	dc.b	$FF
	dc.b	0
	dc.l	unk_5E6E
unk_5E7C
	dc.b	8
	dc.b	9
	dc.b	$12
	dc.b	$C
	dc.b	2
	dc.b	$B
	dc.b	1
	dc.b	$D
	dc.b	$FE
	dc.b	0
; -----------------------------------------------------------------------------------------

loc_5E86:
	lea	(loc_5EB6).l,a1
	bsr.w	FindActorSlot
	bcs.w	loc_5C5E
	move.l	a0,$2E(a1)
	move.l	#unk_5ED6,$32(a1)
	bsr.w	ActorBookmark
	move.b	p1_pause,d0
	and.b	p2_pause,d0
	bpl.w	loc_5C5E
	rts
; -----------------------------------------------------------------------------------------

loc_5EB6:
	move.b	p1_pause,d0
	and.b	p2_pause,d0
	bpl.w	ActorDeleteSelf
	bsr.w	ActorAnimate
	movea.l	$2E(a0),a1
	move.b	9(a0),9(a1)
	rts
; -----------------------------------------------------------------------------------------
unk_5ED6
	dc.b	$14
	dc.b	$2B
	dc.b	$16
	dc.b	$2C
	dc.b	$18
	dc.b	$2B
	dc.b	$12
	dc.b	$2C
	dc.b	$15
	dc.b	$2B
	dc.b	$17
	dc.b	$2C
	dc.b	$FF
	dc.b	0
	dc.l	unk_5ED6

; =============== S U B	R O U T	I N E =====================================================


sub_5EE8:
	eori.b	#2,7(a0)
	btst	#1,7(a0)
	beq.w	loc_5EFE
	move.w	#$1E,d0
	rts
; -----------------------------------------------------------------------------------------

loc_5EFE:
	move.w	#$1E,d0
	move.w	#0,d1
	move.b	stage_mode,d2
	andi.b	#3,d2
	bne.w	loc_5F1C
	move.w	#$16,d0
	move.w	#8,d1

loc_5F1C:
	jsr	RandomBound
	add.w	d1,d0
	rts
; End of function sub_5EE8


; =============== S U B	R O U T	I N E =====================================================


sub_5F26:
	cmpi.b	#4,d0
	bcs.w	loc_5F30
	rts
; -----------------------------------------------------------------------------------------

loc_5F30:
	move.l	#$8000,d1
	btst	#0,d0
	beq.w	loc_5F40
	neg.l	d1

loc_5F40:
	move.l	d1,$12(a0)
	move.b	#$82,6(a0)
	rts
; End of function sub_5F26


; =============== S U B	R O U T	I N E =====================================================


sub_5F4C:
	cmpi.w	#$108,$A(a0)
	bcc.w	loc_5F5C
	move.w	#$108,$A(a0)

loc_5F5C:
	cmpi.w	#$139,$A(a0)
	bcs.w	locret_5F6C
	move.w	#$138,$A(a0)

locret_5F6C:
	rts
; End of function sub_5F4C


; =============== S U B	R O U T	I N E =====================================================


sub_5F6E:
	btst	#0,7(a0)
	bne.w	loc_5F7A
	rts
; -----------------------------------------------------------------------------------------

loc_5F7A:
	move.w	$28(a0),d0
	lsl.b	#2,d0
	ori.b	#$80,d0
	move.w	#$1800,d1
	jsr	(Sin).l
	swap	d2
	add.w	$20(a0),d2
	move.w	d2,$E(a0)
	subq.w	#1,$28(a0)
	bmi.w	loc_5FA2
	rts
; -----------------------------------------------------------------------------------------

loc_5FA2:
	bclr	#0,7(a0)
	rts
; End of function sub_5F6E


; =============== S U B	R O U T	I N E =====================================================


sub_5FAA:
	clr.w	time_frames
	move.w	#$1F,d0

loc_5FB4:
	lea	(sub_602C).l,a1
	bsr.w	FindActorSlotQuick
	bcs.w	loc_6026
	move.b	#$83,6(a1)
	move.b	#6,8(a1)
	move.b	#$E,9(a1)
	move.w	$A(a0),$A(a1)
	move.w	$E(a0),$E(a1)
	move.w	#$FFFF,$20(a1)
	move.w	#$2000,$1C(a1)
	movem.l	d0,-(sp)
	lsl.b	#3,d0
	move.b	d0,d3
	move.w	#$C0,d0
	jsr	RandomBound

loc_5FFE:
	addi.w	#$280,d0
	move.w	d0,d1
	move.b	d3,d0
	jsr	(Sin).l
	move.l	d2,$12(a1)
	addq.b	#5,d0
	jsr	(Cos).l
	move.l	d2,$16(a1)
	move.w	#$14,$26(a1)
	movem.l	(sp)+,d0

loc_6026:
	dbf	d0,loc_5FB4
	rts
; End of function sub_5FAA


; =============== S U B	R O U T	I N E =====================================================


sub_602C:
	bsr.w	ActorMove
	bcs.w	ActorDeleteSelf
	subq.w	#1,$26(a0)
	rts
; End of function sub_602C

; -----------------------------------------------------------------------------------------
	move.b	#$87,6(a0)
	bsr.w	ActorBookmark
	bsr.w	ActorMove
	bcs.w	ActorDeleteSelf
	rts

; =============== S U B	R O U T	I N E =====================================================


sub_604E:
	move.w	#1,(word_FF1124).l
	move.w	#$D688,d3
	move.w	#$C000,d2
	cmpi.b	#$C,opponent
	beq.s	loc_6080
	move.w	#$6000,d0
	bra.w	loc_6084
; -----------------------------------------------------------------------------------------

loc_6070:
	move.w	#0,(word_FF1124).l
	move.w	#$C61E,d3
	move.w	#$E000,d2

loc_6080:
	move.w	#$8000,d0

loc_6084:
	move.b	#0,(byte_FF1121).l
	movem.l	d2-d3/a0,-(sp)
	clr.w	d1
	move.b	opponent,d1
	lsl.w	#2,d1
	lea	(off_6216).l,a0
	movea.l	(a0,d1.w),a0
	DISABLE_INTS
	jsr	NemDec
	ENABLE_INTS
	movem.l	(sp)+,d2-d3/a0
	clr.w	(word_FF198C).l
	lea	(sub_60F4).l,a1
	bsr.w	FindActorSlot
	bcs.w	locret_60F2
	move.l	a0,$2E(a1)
	move.w	#0,$28(a1)
	lsr.w	#5,d0
	move.w	d0,$2A(a1)
	move.w	d2,$A(a1)
	move.w	d3,$C(a1)
	move.b	#0,6(a1)
	bsr.w	sub_61E0
	movea.l	a1,a2
	bsr.w	sub_678E

locret_60F2:
	rts
; End of function sub_604E


; =============== S U B	R O U T	I N E =====================================================


sub_60F4:
	move.w	#$FFFF,$26(a0)
	bsr.w	ActorBookmark
	tst.b	(word_FF1124).l
	beq.s	loc_610C
	jmp	(ActorDeleteSelf).l
; -----------------------------------------------------------------------------------------

loc_610C:
	move.w	(word_FF198C).l,d0
	cmp.w	$26(a0),d0
	beq.w	loc_6144
	move.w	d0,$26(a0)
	lea	(off_6256).l,a1
	clr.w	d1
	move.b	opponent,d1
	lsl.w	#2,d1
	movea.l	(a1,d1.w),a1
	add.w	$28(a0),d0
	lsl.w	#2,d0
	movea.l	(a1,d0.w),a1
	move.l	a1,$32(a0)
	clr.b	$22(a0)

loc_6144:
	tst.b	$22(a0)
	beq.s	loc_6150
	subq.b	#1,$22(a0)
	rts
; -----------------------------------------------------------------------------------------

loc_6150:
	movea.l	$32(a0),a2
	move.w	(a2)+,d0
	bge.s	loc_617E
	lea	(off_6256).l,a2
	clr.w	d0
	move.b	opponent,d0
	lsl.w	#2,d0
	movea.l	(a2,d0.w),a2
	move.w	$26(a0),d0
	lsl.w	#2,d0
	movea.l	(a2,d0.w),a2
	move.w	(a2)+,d0
	move.b	#$FF,$2C(a0)

loc_617E:
	addq.b	#1,$2C(a0)
	move.b	d0,$22(a0)
	movea.l	(a2)+,a1
	move.l	a2,$32(a0)
	move.l	a0,-(sp)
	move.w	$2A(a0),d0
	move.w	$A(a0),d1
	or.w	d1,d0
	move.w	#9,d1
	move.w	#6,d2
	movea.l	a1,a2
	movea.l	#0,a1
	movea.w	$C(a0),a1
	movea.l	a2,a0
	DISABLE_INTS
	jsr	(EniDec).l
	ENABLE_INTS
	movea.l	(sp)+,a0
	rts
; End of function sub_60F4


; =============== S U B	R O U T	I N E =====================================================


sub_61C0:
	clr.l	d0
	move.b	opponent,d0
	move.b	byte_6206(pc,d0.w),d0
	lsl.w	#5,d0
	lea	Palettes,a2
	adda.l	d0,a2
	move.b	#3,d0
	jmp	LoadPalette
; End of function sub_61C0


; =============== S U B	R O U T	I N E =====================================================


sub_61E0:
	clr.l	d0
	move.b	opponent,d0
	move.b	byte_6206(pc,d0.w),d0
	lsl.w	#5,d0
	lea	Palettes,a2
	adda.l	d0,a2
	move.w	$A(a1),d0
	rol.w	#3,d0
	andi.b	#$B,d0
	jmp	LoadPalette
; End of function sub_61E0

; -----------------------------------------------------------------------------------------
byte_6206
	dc.b	$2A
	dc.b	$2B
	dc.b	$2D
	dc.b	$44
	dc.b	$2A
	dc.b	$2E
	dc.b	$2F
	dc.b	$2C
	dc.b	$30
	dc.b	$43
	dc.b	$3C
	dc.b	$2A
	dc.b	$3F
	dc.b	$2A
	dc.b	$3E
	dc.b	$40
off_6216:
	dc.l	ArtNem_ScratchPortrait
	dc.l	ArtNem_FranklyPortrait
	dc.l	ArtNem_DynamightPortrait
	dc.l	ArtNem_ArmsPortrait
	dc.l	ArtNem_ScratchPortrait
	dc.l	ArtNem_GrounderPortrait
	dc.l	ArtNem_DavyPortrait
	dc.l	ArtNem_CoconutsPortrait
	dc.l	ArtNem_SpikePortrait
	dc.l	ArtNem_SirFfuzzyPortrait
	dc.l	ArtNem_DragonPortrait
	dc.l	ArtNem_ScratchPortrait
	dc.l	ArtNem_RobotnikPortrait
	dc.l	ArtNem_ScratchPortrait
	dc.l	ArtNem_HumptyPortrait
	dc.l	ArtNem_SkweelPortrait
off_6256:
	dc.l	off_6296
	dc.l	off_62D8
	dc.l	off_636E
	dc.l	off_6734
	dc.l	off_6296
	dc.l	off_63C8
	dc.l	off_64B8
	dc.l	off_6314
	dc.l	off_6422
	dc.l	off_66BC
	dc.l	off_6506
	dc.l	off_6296
	dc.l	off_65FC
	dc.l	off_6296
	dc.l	off_6572
	dc.l	off_664A
off_6296
	dc.l	word_62A6
	dc.l	word_62B4
	dc.l	word_62C2
	dc.l	word_62D0
word_62A6
	dc.w	$32
	dc.l	byte_3CC84
	dc.w	$19
	dc.l	byte_3CC98
	dc.w	$FF00
word_62B4
	dc.w	$32
	dc.l	byte_3CCB4
	dc.w	$F
	dc.l	byte_3CCC8
	dc.w	$FF00
word_62C2
	dc.w	$32
	dc.l	byte_3CCE8
	dc.w	$F
	dc.l	byte_3CCFC
	dc.w	$FF00
word_62D0
	dc.w	$32
	dc.l	byte_3CD1E
	dc.w	$FF00
off_62D8
	dc.l	word_62E8
	dc.l	word_62F6
	dc.l	word_62FE
	dc.l	word_630C
word_62E8
	dc.w	$14
	dc.l	byte_3DFCC
	dc.w	$14
	dc.l	byte_3DFDC
	dc.w	$FF00
word_62F6
	dc.w	$32
	dc.l	byte_3DFF6
	dc.w	$FF00
word_62FE
	dc.w	$A
	dc.l	byte_3E006
	dc.w	$A
	dc.l	byte_3E014
	dc.w	$FF00
word_630C
	dc.w	$32
	dc.l	byte_3E02C
	dc.w	$FF00
off_6314
	dc.l	word_6324
	dc.l	word_633E
	dc.l	word_634C
	dc.l	word_6366
word_6324
	dc.w	$46
	dc.l	byte_3F30C
	dc.w	8
	dc.l	byte_3F320
	dc.w	$C
	dc.l	byte_3F30C
	dc.w	8
	dc.l	byte_3F320
	dc.w	$FF00
word_633E
	dc.w	$32
	dc.l	byte_3F33A
	dc.w	$1E
	dc.l	byte_3F34C
	dc.w	$FF00
word_634C
	dc.w	4
	dc.l	byte_3F364
	dc.w	4
	dc.l	byte_3F384
	dc.w	4
	dc.l	byte_3F3AC
	dc.w	4
	dc.l	byte_3F384
	dc.w	$FF00
word_6366
	dc.w	$32
	dc.l	byte_3F3CE
	dc.w	$FF00
off_636E
	dc.l	word_637E
	dc.l	word_638C
	dc.l	word_63AC
	dc.l	word_63C0
word_637E
	dc.w	$14
	dc.l	byte_4055A
	dc.w	$14
	dc.l	byte_4056E
	dc.w	$FF00
word_638C
	dc.w	4
	dc.l	byte_40586
	dc.w	4
	dc.l	byte_4059A
	dc.w	4
	dc.l	byte_405B4
	dc.w	5
	dc.l	byte_405D0
	dc.w	5
	dc.l	byte_405EC
	dc.w	$FF00
word_63AC
	dc.w	4
	dc.l	byte_40608
	dc.w	4
	dc.l	byte_4061C
	dc.w	4
	dc.l	byte_40636
	dc.w	$FF00
word_63C0
	dc.w	$32
	dc.l	byte_40650
	dc.w	$FF00
off_63C8
	dc.l	word_63D8
	dc.l	word_63F2
	dc.l	word_640C
	dc.l	word_641A
word_63D8
	dc.w	$78
	dc.l	byte_41C9A
	dc.w	4
	dc.l	byte_41CAE
	dc.w	7
	dc.l	byte_41CD0
	dc.w	4
	dc.l	byte_41CAE
	dc.w	$FF00
word_63F2
	dc.w	$3C
	dc.l	byte_41CF2
	dc.w	$A
	dc.l	byte_41D06
	dc.w	$A
	dc.l	byte_41CF2
	dc.w	$A
	dc.l	byte_41D06
	dc.w	$FF00
word_640C
	dc.w	$F
	dc.l	byte_41D2E
	dc.w	$50
	dc.l	byte_41D42
	dc.w	$FF00
word_641A
	dc.w	$32
	dc.l	byte_41D72
	dc.w	$FF00
off_6422
	dc.l	word_6432
	dc.l	word_647C
	dc.l	word_6496
	dc.l	word_64B0
word_6432
	dc.w	$50
	dc.l	byte_444A6
	dc.w	5
	dc.l	byte_444B8
	dc.w	8
	dc.l	byte_444D8
	dc.w	5
	dc.l	byte_444B8
	dc.w	$78
	dc.l	byte_444A6
	dc.w	4
	dc.l	byte_444B8
	dc.w	6
	dc.l	byte_444D8
	dc.w	4
	dc.l	byte_444B8
	dc.w	5
	dc.l	byte_444A6
	dc.w	4
	dc.l	byte_444B8
	dc.w	6
	dc.l	byte_444D8
	dc.w	4
	dc.l	byte_444B8
	dc.w	$FF00
word_647C
	dc.w	$64
	dc.l	byte_444FA
	dc.w	$C
	dc.l	byte_4451E
	dc.w	$C
	dc.l	byte_444FA
	dc.w	$C
	dc.l	byte_4451E
	dc.w	$FF00
word_6496
	dc.w	$5A
	dc.l	byte_44544
	dc.w	$A
	dc.l	byte_44552
	dc.w	6
	dc.l	byte_44544
	dc.w	$A
	dc.l	byte_44552
	dc.w	$FF00
word_64B0
	dc.w	$32
	dc.l	byte_4456E
	dc.w	$FF00
off_64B8
	dc.l	word_64C8
	dc.l	word_64E2
	dc.l	word_64F0
	dc.l	word_64FE
word_64C8
	dc.w	$78
	dc.l	byte_42C96
	dc.w	8
	dc.l	byte_42CAA
	dc.w	8
	dc.l	byte_42C96
	dc.w	8
	dc.l	byte_42CAA
	dc.w	$FF00
word_64E2
	dc.w	8
	dc.l	byte_42CC8
	dc.w	8
	dc.l	byte_42CE4
	dc.w	$FF00
word_64F0
	dc.w	$A
	dc.l	byte_42D0E
	dc.w	$A
	dc.l	byte_42D22
	dc.w	$FF00
word_64FE
	dc.w	$32
	dc.l	byte_42D4A
	dc.w	$FF00
off_6506
	dc.l	word_6516
	dc.l	word_6530
	dc.l	word_653E
	dc.l	word_656A
word_6516
	dc.w	$5A
	dc.l	byte_45D24
	dc.w	8
	dc.l	byte_45D34
	dc.w	5
	dc.l	byte_45D52
	dc.w	8
	dc.l	byte_45D34
	dc.w	$FF00
word_6530
	dc.w	$46
	dc.l	byte_45D70
	dc.w	$14
	dc.l	byte_45D92
	dc.w	$FF00
word_653E
	dc.w	$3C
	dc.l	byte_45DC2
	dc.w	5
	dc.l	byte_45DD2
	dc.w	5
	dc.l	byte_45DEC
	dc.w	5
	dc.l	byte_45DD2
	dc.w	5
	dc.l	byte_45DEC
	dc.w	5
	dc.l	byte_45DD2
	dc.w	5
	dc.l	byte_45DEC
	dc.w	$FF00
word_656A
	dc.w	$32
	dc.l	byte_45E06
	dc.w	$FF00
off_6572
	dc.l	word_6582
	dc.l	word_6590
	dc.l	word_65DA
	dc.l	word_65F4
word_6582
	dc.w	$3C
	dc.l	byte_46FAA
	dc.w	$14
	dc.l	byte_46FC0
	dc.w	$FF00
word_6590
	dc.w	$78
	dc.l	byte_46FE0
	dc.w	5
	dc.l	byte_47002
	dc.w	3
	dc.l	byte_47028
	dc.w	5
	dc.l	byte_47002
	dc.w	6
	dc.l	byte_46FE0
	dc.w	7
	dc.l	byte_47052
	dc.w	6
	dc.l	byte_46FE0
	dc.w	5
	dc.l	byte_47002
	dc.w	3
	dc.l	byte_47028
	dc.w	5
	dc.l	byte_47002
	dc.w	5
	dc.l	byte_46FE0
	dc.w	5
	dc.l	byte_47052
	dc.w	$FF00
word_65DA
	dc.w	9
	dc.l	byte_47076
	dc.w	8
	dc.l	byte_47096
	dc.w	7
	dc.l	byte_470B2
	dc.w	7
	dc.l	byte_47096
	dc.w	$FF00
word_65F4
	dc.w	$32
	dc.l	byte_470CC
	dc.w	$FF00
off_65FC
	dc.l	word_660C
	dc.l	word_6626
	dc.l	word_6634
	dc.l	word_6642
word_660C
	dc.w	$50
	dc.l	byte_48712
	dc.w	5
	dc.l	byte_48720
	dc.w	5
	dc.l	byte_48736
	dc.w	5
	dc.l	byte_48720
	dc.w	$FF00
word_6626
	dc.w	8
	dc.l	byte_4874C
	dc.w	8
	dc.l	byte_48768
	dc.w	$FF00
word_6634
	dc.w	5
	dc.l	byte_48792
	dc.w	5
	dc.l	byte_487AE
	dc.w	$FF00
word_6642
	dc.w	$32
	dc.l	byte_487CE
	dc.w	$FF00
off_664A
	dc.l	word_665A
	dc.l	word_6674
	dc.l	word_668E
	dc.l	word_66B4
word_665A
	dc.w	$3A
	dc.l	byte_49C22
	dc.w	5
	dc.l	byte_49C36
	dc.w	5
	dc.l	byte_49C4E
	dc.w	5
	dc.l	byte_49C36
	dc.w	$FF00
word_6674
	dc.w	9
	dc.l	byte_49C6A
	dc.w	8
	dc.l	byte_49C7C
	dc.w	9
	dc.l	byte_49C6A
	dc.w	8
	dc.l	byte_49C90
	dc.w	$FF00
word_668E
	dc.w	5
	dc.l	byte_49CA4
	dc.w	5
	dc.l	byte_49CB8
	dc.w	5
	dc.l	byte_49CDA
	dc.w	6
	dc.l	byte_49CFC
	dc.w	7
	dc.l	byte_49D20
	dc.w	5
	dc.l	byte_49D40
	dc.w	$FF00
word_66B4
	dc.w	$32
	dc.l	byte_49D60
	dc.w	$FF00
off_66BC
	dc.l	word_66CC
	dc.l	word_66E6
	dc.l	word_6700
	dc.l	word_671A
word_66CC
	dc.w	7
	dc.l	byte_4B20A
	dc.w	7
	dc.l	byte_4B218
	dc.w	7
	dc.l	byte_4B232
	dc.w	7
	dc.l	byte_4B218
	dc.w	$FF00
word_66E6
	dc.w	9
	dc.l	byte_4B24E
	dc.w	9
	dc.l	byte_4B26C
	dc.w	9
	dc.l	byte_4B28E
	dc.w	9
	dc.l	byte_4B26C
	dc.w	$FF00
word_6700
	dc.w	5
	dc.l	byte_4B2B0
	dc.w	5
	dc.l	byte_4B2D0
	dc.w	5
	dc.l	byte_4B2F4
	dc.w	5
	dc.l	byte_4B2D0
	dc.w	$FF00
word_671A
	dc.w	8
	dc.l	byte_4B314
	dc.w	8
	dc.l	byte_4B330
	dc.w	8
	dc.l	byte_4B350
	dc.w	8
	dc.l	byte_4B330
	dc.w	$FF00
off_6734
	dc.l	word_6744
	dc.l	word_675E
	dc.l	word_6778
	dc.l	word_6786
word_6744
	dc.w	$28
	dc.l	byte_4C2D4
	dc.w	4
	dc.l	byte_4C2E4
	dc.w	8
	dc.l	byte_4C2FA
	dc.w	4
	dc.l	byte_4C2E4
	dc.w	$FF00
word_675E
	dc.w	8
	dc.l	byte_4C310
	dc.w	4
	dc.l	byte_4C33A
	dc.w	8
	dc.l	byte_4C368
	dc.w	4
	dc.l	byte_4C33A
	dc.w	$FF00
word_6778
	dc.w	8
	dc.l	byte_4C394
	dc.w	8
	dc.l	byte_4C3B8
	dc.w	$FF00
word_6786
	dc.w	$32
	dc.l	byte_4C3E0
	dc.w	$FF00

; =============== S U B	R O U T	I N E =====================================================


sub_678E:
	move.b	stage_mode,d0
	andi.b	#3,d0
	beq.w	loc_679E
	rts
; -----------------------------------------------------------------------------------------

loc_679E:
	clr.l	d0
	move.b	opponent,d0
	lsl.w	#2,d0
	movea.l	off_67AE(pc,d0.w),a1
	jmp	(a1)
; End of function sub_678E

; -----------------------------------------------------------------------------------------
off_67AE
	dc.l	locret_67EE
	dc.l	loc_67F0
	dc.l	locret_67EE
	dc.l	loc_6F22
	dc.l	locret_67EE
	dc.l	locret_67EE
	dc.l	locret_67EE
	dc.l	loc_6946
	dc.l	locret_67EE
	dc.l	loc_6D80
	dc.l	locret_67EE
	dc.l	locret_67EE
	dc.l	locret_67EE
	dc.l	locret_67EE
	dc.l	loc_6AAE
	dc.l	locret_67EE
; -----------------------------------------------------------------------------------------

locret_67EE:
	rts
; -----------------------------------------------------------------------------------------

loc_67F0:
	move.l	a0,-(sp)
	move.w	#$1E00,d0
	lea	(ArtNem_FranklySparks).l,a0
	DISABLE_INTS
	jsr	NemDec
	ENABLE_INTS
	movea.l	(sp)+,a0
	moveq	#5,d0
	lea	(unk_690A).l,a2

loc_6814:
	lea	(loc_685E).l,a1
	jsr	FindActorSlot
	bcs.s	loc_6858
	move.w	(a2)+,$A(a1)
	move.w	(a2)+,$E(a1)
	move.w	(a2)+,$2A(a1)
	move.w	(a2)+,$2C(a1)
	move.b	#$2C,8(a1)
	move.b	(a2)+,9(a1)
	move.b	(a2)+,$28(a1)
	tst.w	(word_FF1124).l
	beq.s	loc_6858
	subi.w	#$58,$A(a1)
	subi.w	#$F8,$E(a1)
	addq.b	#4,9(a1)

loc_6858:
	dbf	d0,loc_6814
	rts
; -----------------------------------------------------------------------------------------

loc_685E:
	tst.b	(word_FF1124).l
	beq.s	loc_686C
	jmp	(ActorDeleteSelf).l
; -----------------------------------------------------------------------------------------

loc_686C:
	move.w	(word_FF198C).l,d0
	cmpi.w	#1,d0
	beq.s	loc_6886
	move.b	#0,6(a0)
	move.b	#0,$22(a0)
	rts
; -----------------------------------------------------------------------------------------

loc_6886:
	tst.b	$22(a0)
	beq.s	loc_68B4
	tst.b	$26(a0)
	beq.s	loc_6898
	subq.b	#1,$26(a0)
	rts
; -----------------------------------------------------------------------------------------

loc_6898:
	move.w	$2A(a0),d0
	add.w	d0,$A(a0)
	move.w	$2C(a0),d0
	add.w	d0,$E(a0)
	subq.b	#1,$22(a0)
	move.b	#$80,6(a0)
	rts
; -----------------------------------------------------------------------------------------

loc_68B4:
	lea	(unk_690A).l,a1
	clr.w	d0
	move.b	$28(a0),d0
	adda.w	d0,a1
	move.w	(a1)+,$A(a0)
	move.w	(a1),$E(a0)
	move.b	#$A,$22(a0)
	move.b	$32(a0),d0
	move.b	unk_6902(pc,d0.w),d1
	move.b	d1,$26(a0)
	addq.b	#1,d0
	andi.b	#7,d0
	move.b	d0,$32(a0)
	move.b	#0,6(a0)
	tst.w	(word_FF1124).l
	beq.s	locret_6900
	subi.w	#$58,$A(a0)
	subi.w	#$F8,$E(a0)

locret_6900:
	rts
; -----------------------------------------------------------------------------------------
unk_6902
	dc.b	$18
	dc.b	$30
	dc.b	2
	dc.b	$17
	dc.b	$20
	dc.b	5
	dc.b	$14
	dc.b	$1A
unk_690A
	dc.b	1
	dc.b	1
	dc.b	0
	dc.b	$E2
	dc.b	0
	dc.b	2
	dc.b	$FF
	dc.b	$FE
	dc.b	1
	dc.b	0
	dc.b	0
	dc.b	$F5
	dc.b	0
	dc.b	$DF
	dc.b	$FF
	dc.b	$FE
	dc.b	$FF
	dc.b	$FE
	dc.b	0
	dc.b	$A
	dc.b	0
	dc.b	$F3
	dc.b	0
	dc.b	$F6
	dc.b	$FF
	dc.b	$FE
	dc.b	0
	dc.b	2
	dc.b	1
	dc.b	$14
	dc.b	1
	dc.b	$46
	dc.b	0
	dc.b	$E0
	dc.b	0
	dc.b	2
	dc.b	$FF
	dc.b	$FE
	dc.b	1
	dc.b	$1E
	dc.b	1
	dc.b	$39
	dc.b	0
	dc.b	$E3
	dc.b	$FF
	dc.b	$FE
	dc.b	$FF
	dc.b	$FE
	dc.b	2
	dc.b	$28
	dc.b	1
	dc.b	$42
	dc.b	0
	dc.b	$F8
	dc.b	0
	dc.b	1
	dc.b	0
	dc.b	2
	dc.b	3
	dc.b	$32
; -----------------------------------------------------------------------------------------

loc_6946:
	lea	(loc_6954).l,a1
	jsr	FindActorSlot
	rts
; -----------------------------------------------------------------------------------------

loc_6954:
	jsr	(ActorBookmark).l
	tst.b	(word_FF1124).l
	beq.s	loc_6968
	jmp	(ActorDeleteSelf).l
; -----------------------------------------------------------------------------------------

loc_6968:
	move.w	(word_FF198C).l,d0
	cmp.b	$2A(a0),d0
	beq.s	loc_697E
	move.w	#0,$26(a0)
	move.b	d0,$2A(a0)

loc_697E:
	lsl.w	#2,d0
	movea.l	off_6986(pc,d0.w),a1
	jmp	(a1)
; -----------------------------------------------------------------------------------------
off_6986
	dc.l	loc_69FE
	dc.l	loc_69CE
	dc.l	loc_6996
	dc.l	loc_6A44
; -----------------------------------------------------------------------------------------

loc_6996:
	tst.b	(byte_FF1121).l
	bne.s	locret_69B0
	addq.b	#1,$26(a0)
	clr.l	d0
	move.b	$26(a0),d0
	move.b	d0,d1
	andi.b	#3,d1
	beq.s	loc_69B2

locret_69B0:
	rts
; -----------------------------------------------------------------------------------------

loc_69B2:
	andi.b	#$1C,d0
	cmpi.b	#$18,d0
	bne.w	loc_69C6
	move.b	#0,d0
	move.b	d0,$26(a0)

loc_69C6:
	lea	(word_6A4E).l,a1
	bra.s	loc_69FA
; -----------------------------------------------------------------------------------------

loc_69CE:
	tst.b	$22(a0)
	beq.s	loc_69DA
	subq.b	#1,$22(a0)
	rts
; -----------------------------------------------------------------------------------------

loc_69DA:
	move.b	#1,$22(a0)
	move.w	$26(a0),d0
	addq.w	#1,d0
	cmpi.w	#$12,d0
	bne.s	loc_69EE
	clr.w	d0

loc_69EE:
	move.w	d0,$26(a0)
	lsl.w	#2,d0
	lea	(word_6A66).l,a1

loc_69FA:
	adda.w	d0,a1
	bra.s	loc_6A04
; -----------------------------------------------------------------------------------------

loc_69FE:
	lea	(word_6A4A).l,a1

loc_6A04:
	tst.w	(word_FF1124).l
	beq.s	loc_6A28
	move.w	(a1)+,(palette_buffer+$54).l
	move.w	(a1),(palette_buffer+$58).l
	move.b	#2,d0
	lea	((palette_buffer+$40)).l,a2
	jmp	LoadPalette
; -----------------------------------------------------------------------------------------

loc_6A28:
	move.w	(a1)+,(palette_buffer+$74).l
	move.w	(a1),(palette_buffer+$78).l
	move.b	#3,d0
	lea	((palette_buffer+$60)).l,a2
	jmp	LoadPalette
; -----------------------------------------------------------------------------------------

loc_6A44:
	jmp	(sub_61C0).l
; -----------------------------------------------------------------------------------------
word_6A4A
	dc.w	$8E
	dc.w	$6CE
word_6A4E
	dc.w	$8CE
	dc.w	$EEE
	dc.w	$46A
	dc.w	$68C
	dc.w	$24
	dc.w	$24
	dc.w	$E
	dc.w	$E
	dc.w	8
	dc.w	8
	dc.w	2
	dc.w	2
word_6A66
	dc.w	$24
	dc.w	$24
	dc.w	$24
	dc.w	$24
	dc.w	$48
	dc.w	$48
	dc.w	$26A
	dc.w	$26A
	dc.w	$26A
	dc.w	$48C
	dc.w	$48C
	dc.w	$6AE
	dc.w	$6AE
	dc.w	$8CE
	dc.w	$8CE
	dc.w	$AEE
	dc.w	$8CE
	dc.w	$EEE
	dc.w	$8CE
	dc.w	$EEE
	dc.w	$8CE
	dc.w	$EEE
	dc.w	$8CE
	dc.w	$EEE
	dc.w	$8CE
	dc.w	$AEE
	dc.w	$6AE
	dc.w	$8CE
	dc.w	$48C
	dc.w	$6AE
	dc.w	$26A
	dc.w	$48C
	dc.w	$26A
	dc.w	$26A
	dc.w	$48
	dc.w	$48
; -----------------------------------------------------------------------------------------

loc_6AAE:
	lea	(loc_6AFE).l,a1
	jsr	FindActorSlot
	bcs.s	locret_6AFC
	move.w	#$102,$A(a1)
	move.w	#$E6,$E(a1)
	move.b	#$2D,8(a1)
	move.b	#0,9(a1)
	move.b	#0,6(a1)
	move.l	a2,$2E(a1)
	tst.w	(word_FF1124).l
	beq.s	locret_6AFC
	subi.w	#$58,$A(a1)
	subi.w	#$F8,$E(a1)
	addq.b	#8,9(a1)
	move.b	#4,$2A(a1)

locret_6AFC:
	rts
; -----------------------------------------------------------------------------------------

loc_6AFE:
	tst.b	(word_FF1124).l
	beq.s	loc_6B0C
	jmp	(ActorDeleteSelf).l
; -----------------------------------------------------------------------------------------

loc_6B0C:
	move.w	(word_FF198C).l,d0
	cmp.b	$2C(a0),d0
	beq.w	loc_6BA2
	move.b	d0,$2C(a0)
	lsl.w	#2,d0
	movea.l	off_6B26(pc,d0.w),a1
	jmp	(a1)
; -----------------------------------------------------------------------------------------
off_6B26
	dc.l	loc_6B36
	dc.l	loc_6B90
	dc.l	loc_6B74
	dc.l	loc_6B90
; -----------------------------------------------------------------------------------------

loc_6B36:
	move.b	#0,9(a0)
	move.w	#0,$26(a0)
	move.w	#0,$28(a0)
	move.w	#0,$2A(a0)
	move.w	#$102,$A(a0)
	move.w	#$E6,$E(a0)
	tst.w	(word_FF1124).l
	beq.s	locret_6B72
	subi.w	#$58,$A(a1)
	subi.w	#$F8,$E(a1)
	addq.b	#4,9(a1)

locret_6B72:
	rts
; -----------------------------------------------------------------------------------------

loc_6B74:
	move.b	#0,$22(a0)
	move.l	#unk_6CAC,$32(a0)
	move.w	#$12B,$A(a0)
	move.w	#$FA,$E(a0)
	rts
; -----------------------------------------------------------------------------------------

loc_6B90:
	movea.l	$2E(a0),a1
	move.b	#0,$2C(a1)
	move.b	#0,6(a0)
	rts
; -----------------------------------------------------------------------------------------

loc_6BA2:
	lsl.w	#2,d0
	movea.l	off_6BAA(pc,d0.w),a1
	jmp	(a1)
; -----------------------------------------------------------------------------------------
off_6BAA
	dc.l	loc_6BBC
	dc.l	loc_6CC2
	dc.l	loc_6C9E
	dc.l	locret_6BBA
; -----------------------------------------------------------------------------------------

locret_6BBA:
	rts
; -----------------------------------------------------------------------------------------

loc_6BBC:
	tst.b	$2A(a0)
	beq.s	loc_6BCE
	subq.b	#1,$2A(a0)
	move.b	#0,6(a0)
	rts
; -----------------------------------------------------------------------------------------

loc_6BCE:
	move.b	#$80,6(a0)
	addq.b	#1,$22(a0)
	cmpi.b	#3,$22(a0)
	bne.s	loc_6BEC
	eori.b	#1,9(a0)
	move.b	#0,$22(a0)

loc_6BEC:
	tst.b	$28(a0)
	beq.w	loc_6C18
	tst.w	(word_FF1124).l
	beq.s	loc_6C0A
	cmpi.w	#$AC,$A(a0)
	ble.s	loc_6C3C
	subq.w	#6,$A(a0)
	rts
; -----------------------------------------------------------------------------------------

loc_6C0A:
	cmpi.w	#$104,$A(a0)
	ble.s	loc_6C3C
	subq.w	#6,$A(a0)
	rts
; -----------------------------------------------------------------------------------------

loc_6C18:
	tst.w	(word_FF1124).l
	beq.s	loc_6C2E
	cmpi.w	#$C4,$A(a0)
	bgt.s	loc_6C3C
	addq.w	#6,$A(a0)
	rts
; -----------------------------------------------------------------------------------------

loc_6C2E:
	cmpi.w	#$11C,$A(a0)
	bgt.s	loc_6C3C
	addq.w	#6,$A(a0)
	rts
; -----------------------------------------------------------------------------------------

loc_6C3C:
	move.b	#0,6(a0)
	jsr	Random
	andi.b	#$3F,d0
	move.b	d0,$2A(a0)
	andi.b	#1,d0
	beq.s	loc_6C7A
	tst.w	(word_FF1124).l
	beq.s	loc_6C6C
	move.w	#$C4,$A(a0)
	move.b	#1,$28(a0)
	rts
; -----------------------------------------------------------------------------------------

loc_6C6C:
	move.w	#$11C,$A(a0)
	move.b	#1,$28(a0)
	rts
; -----------------------------------------------------------------------------------------

loc_6C7A:
	tst.w	(word_FF1124).l
	beq.s	loc_6C90
	move.w	#$AC,$A(a0)
	move.b	#1,$28(a0)
	rts
; -----------------------------------------------------------------------------------------

loc_6C90:
	move.w	#$104,$A(a0)
	move.b	#0,$28(a0)
	rts
; -----------------------------------------------------------------------------------------

loc_6C9E:
	move.b	#$80,6(a0)
	jsr	(ActorAnimate).l
	rts
; -----------------------------------------------------------------------------------------
unk_6CAC
	dc.b	$78
	dc.b	5
	dc.b	5
	dc.b	6
	dc.b	6
	dc.b	7
	dc.b	8
	dc.b	6
	dc.b	9
	dc.b	5
	dc.b	5
	dc.b	6
	dc.b	6
	dc.b	7
	dc.b	8
	dc.b	6
	dc.b	$FF
	dc.b	0
	dc.l	unk_6CAC
; -----------------------------------------------------------------------------------------

loc_6CC2:
	movea.l	$2E(a0),a1
	move.b	$2C(a1),d0
	cmpi.b	#2,d0
	beq.s	loc_6CDE
	cmpi.b	#8,d0
	beq.s	loc_6CDE
	move.b	#0,$26(a0)
	rts
; -----------------------------------------------------------------------------------------

loc_6CDE:
	tst.b	$26(a0)
	beq.s	loc_6CE6
	rts
; -----------------------------------------------------------------------------------------

loc_6CE6:
	move.b	#1,$26(a0)
	lea	(byte_6D6E).l,a2
	move.w	#2,d0

loc_6CF6:
	lea	(loc_6D50).l,a1
	jsr	FindActorSlot
	bcs.s	loc_6D4A
	move.w	(a2)+,$2A(a1)
	move.w	(a2)+,$2C(a1)
	move.b	#$A,$28(a1)
	move.b	#$2D,8(a1)
	move.b	#2,9(a1)
	add.b	d0,9(a1)
	move.w	(a2)+,$A(a1)
	move.w	#$E2,$E(a1)
	move.b	#$80,6(a1)
	tst.w	(word_FF1124).l
	beq.s	loc_6D4A
	subi.w	#$58,$A(a1)
	subi.w	#$F8,$E(a1)
	addq.b	#8,9(a1)

loc_6D4A:
	dbf	d0,loc_6CF6
	rts
; -----------------------------------------------------------------------------------------

loc_6D50:
	subq.b	#1,$28(a0)
	bne.s	loc_6D5C
	jmp	(ActorDeleteSelf).l
; -----------------------------------------------------------------------------------------

loc_6D5C:
	move.w	$2A(a0),d0
	add.w	d0,$A(a0)
	move.w	$2C(a0),d0
	add.w	d0,$E(a0)
	rts
; -----------------------------------------------------------------------------------------
byte_6D6E
	dc.b	0
	dc.b	2
	dc.b	$FF
	dc.b	$FE
	dc.b	1
	dc.b	$25
	dc.b	0
	dc.b	0
	dc.b	$FF
	dc.b	$FC
	dc.b	1
	dc.b	$1B
	dc.b	$FF
	dc.b	$FE
	dc.b	$FF
	dc.b	$FE
	dc.b	1
	dc.b	$11
; -----------------------------------------------------------------------------------------

loc_6D80:
	lea	(loc_6DCE).l,a1
	jsr	FindActorSlot
	bcs.s	locret_6DCC
	move.w	#$110,$A(a1)
	move.w	#$E8,$E(a1)
	move.b	#$2F,8(a1)
	move.b	#0,9(a1)
	move.b	#0,6(a1)
	move.b	#$32,$22(a1)
	lea	(loc_6E46).l,a1
	jsr	FindActorSlot
	bcs.s	locret_6DCC
	move.b	#$11,$22(a1)
	move.b	#0,6(a1)

locret_6DCC:
	rts
; -----------------------------------------------------------------------------------------

loc_6DCE:
	tst.b	(word_FF1124).l
	beq.s	loc_6DDC
	jmp	(ActorDeleteSelf).l
; -----------------------------------------------------------------------------------------

loc_6DDC:
	cmpi.w	#2,(word_FF198C).l
	beq.s	loc_6DFA
	move.b	#0,6(a0)
	move.b	#$32,$22(a0)
	move.b	#0,9(a0)
	rts
; -----------------------------------------------------------------------------------------

loc_6DFA:
	move.b	#$80,6(a0)
	subq.b	#1,$22(a0)
	beq.s	loc_6E08
	rts
; -----------------------------------------------------------------------------------------

loc_6E08:
	addq.w	#1,$26(a0)
	move.w	$26(a0),d1
	andi.w	#3,d1
	beq.s	loc_6E30
	moveq	#5,d0
	move.b	#2,9(a0)
	andi.b	#1,d1
	beq.s	loc_6E40
	move.b	#6,d0
	move.b	#1,9(a0)
	bra.s	loc_6E40
; -----------------------------------------------------------------------------------------

loc_6E30:
	move.b	#0,9(a0)
	jsr	Random
	andi.b	#$3F,d0

loc_6E40:
	move.b	d0,$22(a0)
	rts
; -----------------------------------------------------------------------------------------

loc_6E46:
	jsr	(ActorBookmark).l
	tst.b	(word_FF1124).l
	beq.s	loc_6E5A
	jmp	(ActorDeleteSelf).l
; -----------------------------------------------------------------------------------------

loc_6E5A:
	tst.b	(byte_FF1121).l
	bne.s	locret_6E68
	subq.b	#1,$22(a0)
	beq.s	loc_6E6A

locret_6E68:
	rts
; -----------------------------------------------------------------------------------------

loc_6E6A:
	move.w	$26(a0),d1
	addq.b	#1,d1
	andi.b	#7,d1
	move.w	d1,$26(a0)
	move.w	(word_FF198C).l,d0
	cmpi.b	#3,d0
	bne.s	loc_6E8C
	lea	(unk_6F06).l,a1
	bra.s	loc_6EA2
; -----------------------------------------------------------------------------------------

loc_6E8C:
	lsl.w	#3,d0
	add.w	d1,d0
	move.b	unk_6EE2(pc,d0.w),d0
	move.b	d0,$22(a0)
	lsl.w	#2,d1
	lea	(unk_6F02).l,a1
	adda.w	d1,a1

loc_6EA2:
	tst.w	(word_FF1124).l
	beq.s	loc_6EC6
	move.w	(a1)+,(palette_buffer+$5A).l
	move.w	(a1),(palette_buffer+$44).l
	move.b	#2,d0
	lea	((palette_buffer+$40)).l,a2
	jmp	LoadPalette
; -----------------------------------------------------------------------------------------

loc_6EC6:
	move.w	(a1)+,(palette_buffer+$7A).l
	move.w	(a1),(palette_buffer+$64).l
	move.b	#3,d0
	lea	((palette_buffer+$60)).l,a2
	jmp	LoadPalette
; -----------------------------------------------------------------------------------------
unk_6EE2
	dc.b	$11
	dc.b	8
	dc.b	$A
	dc.b	$C
	dc.b	$E
	dc.b	5
	dc.b	5
	dc.b	5
	dc.b	5
	dc.b	5
	dc.b	5
	dc.b	5
	dc.b	5
	dc.b	2
	dc.b	2
	dc.b	2
	dc.b	2
	dc.b	2
	dc.b	2
	dc.b	2
	dc.b	2
	dc.b	2
	dc.b	2
	dc.b	2
	dc.b	$11
	dc.b	8
	dc.b	$A
	dc.b	$C
	dc.b	$E
	dc.b	5
	dc.b	5
	dc.b	5
unk_6F02
	dc.b	2
	dc.b	$AC
	dc.b	4
	dc.b	$EE
unk_6F06
	dc.b	0
	dc.b	$8A
	dc.b	0
	dc.b	$CC
	dc.b	0
	dc.b	$68
	dc.b	0
	dc.b	$AA
	dc.b	0
	dc.b	$46
	dc.b	0
	dc.b	$88
	dc.b	0
	dc.b	$24
	dc.b	0
	dc.b	$66
	dc.b	0
	dc.b	$46
	dc.b	0
	dc.b	$88
	dc.b	0
	dc.b	$68
	dc.b	0
	dc.b	$AA
	dc.b	0
	dc.b	$8A
	dc.b	0
	dc.b	$CC
; -----------------------------------------------------------------------------------------

loc_6F22:
	lea	(loc_6F38).l,a1
	jsr	FindActorSlot
	bcs.s	locret_6F36
	move.b	#1,$22(a1)

locret_6F36:
	rts
; -----------------------------------------------------------------------------------------

loc_6F38:
	jsr	(ActorBookmark).l
	tst.b	(word_FF1124).l
	beq.s	loc_6F4C
	jmp	(ActorDeleteSelf).l
; -----------------------------------------------------------------------------------------

loc_6F4C:
	tst.b	(byte_FF1121).l
	bne.s	locret_6F5A
	subq.b	#1,$22(a0)
	beq.s	loc_6F5C

locret_6F5A:
	rts
; -----------------------------------------------------------------------------------------

loc_6F5C:
	move.w	(word_FF198C).l,d0
	cmp.b	$2A(a0),d0
	beq.s	loc_6F72
	move.w	#0,$26(a0)
	move.b	d0,$2A(a0)

loc_6F72:
	cmpi.b	#3,d0
	beq.s	loc_6FB0
	move.b	#$E,d1
	move.b	#6,d2
	lea	(unk_6FF2).l,a1
	tst.b	d0
	beq.s	loc_6F98
	lea	(unk_700E).l,a1
	move.b	#4,d1
	move.b	#4,d2

loc_6F98:
	move.w	$26(a0),d0
	addq.b	#1,d0
	cmp.b	d1,d0
	bne.s	loc_6FA6
	move.b	#0,d0

loc_6FA6:
	move.w	d0,$26(a0)
	add.w	d0,d0
	adda.w	d0,a1
	bra.s	loc_6FBA
; -----------------------------------------------------------------------------------------

loc_6FB0:
	lea	(unk_7016).l,a1
	move.b	#0,d2

loc_6FBA:
	move.b	d2,$22(a0)
	tst.w	(word_FF1124).l
	beq.s	loc_6FDC
	move.w	(a1),(palette_buffer+$5C).l
	move.b	#2,d0
	lea	((palette_buffer+$40)).l,a2
	jmp	LoadPalette
; -----------------------------------------------------------------------------------------

loc_6FDC:
	move.w	(a1),(palette_buffer+$7C).l
	move.b	#3,d0
	lea	((palette_buffer+$60)).l,a2
	jmp	LoadPalette
; -----------------------------------------------------------------------------------------
unk_6FF2
	dc.b	0
	dc.b	$46
	dc.b	0
	dc.b	$48
	dc.b	2
	dc.b	$6A
	dc.b	4
	dc.b	$8C
	dc.b	6
	dc.b	$AE
	dc.b	8
	dc.b	$CE
	dc.b	$A
	dc.b	$EE
	dc.b	$E
	dc.b	$EE
	dc.b	$A
	dc.b	$EE
	dc.b	8
	dc.b	$CE
	dc.b	6
	dc.b	$AE
	dc.b	4
	dc.b	$8C
	dc.b	2
	dc.b	$6A
	dc.b	0
	dc.b	$48
unk_700E
	dc.b	$E
	dc.b	$EE
	dc.b	8
	dc.b	$CE
	dc.b	4
	dc.b	$8C
	dc.b	0
	dc.b	$46
unk_7016
	dc.b	0
	dc.b	$EE

Passwords:
	dc.w	$0006
	dc.w	$6511
	dc.w	$4511
	dc.w	$2241

	dc.w	$5354
	dc.w	$2501
	dc.w	$1535
	dc.w	$4145

	dc.w	$0561
	dc.w	$1253
	dc.w	$2452
	dc.w	$3306

	dc.w	$5223
	dc.w	$6421
	dc.w	$0344
	dc.w	$4032

	dc.w	$5053
	dc.w	$4331
	dc.w	$1154
	dc.w	$3541

	dc.w	$3102
	dc.w	$3246
	dc.w	$3522
	dc.w	$2346

	dc.w	$1436
	dc.w	$4651
	dc.w	$5161
	dc.w	$5361

	dc.w	$1362
	dc.w	$2366
	dc.w	$3224
	dc.w	$3465

	dc.w	$0156
	dc.w	$6015
	dc.w	$5401
	dc.w	$4216

	dc.w	$4325
	dc.w	$5002
	dc.w	$2116
	dc.w	$4360

	dc.w	$0661
	dc.w	$4451
	dc.w	$4552
	dc.w	$0462

	dc.w	$1622
	dc.w	$3165
	dc.w	$6536
	dc.w	$0051

; =============== S U B	R O U T	I N E =====================================================


sub_7078:
	eori.b	#1,$2A(a0)
	bsr.w	GetPuyoFieldTopLeft
	eori.b	#1,$2A(a0)
	addi.w	#$10,d0
	move.w	d0,d3
	move.w	#3,d1

loc_7092:
	lea	(sub_7104).l,a1
	bsr.w	FindActorSlotQuick
	bcs.w	loc_70FE
	move.b	#$F,6(a1)
	move.b	#$25,8(a1)
	move.b	d1,9(a1)
	move.w	d1,d2
	lsl.w	#4,d2
	jsr	Random
	andi.b	#$F,d0
	or.b	d0,d2
	move.w	d2,$26(a1)
	move.w	#$40,d0
	jsr	RandomBound
	add.w	d3,d0
	move.w	d0,$A(a1)
	move.w	#$160,$E(a1)
	move.w	#$FFFC,$16(a1)
	move.w	#$FFFF,$20(a1)
	move.w	#$C00,$1C(a1)
	move.w	$A(a1),$1E(a1)
	move.w	#1,$12(a1)
	move.w	#$2000,$1A(a1)

loc_70FE:
	dbf	d1,loc_7092
	rts
; End of function sub_7078


; =============== S U B	R O U T	I N E =====================================================


sub_7104:
	move.w	#$18,d0
	jsr	(ActorBookmark_SetDelay).l
	jsr	(ActorBookmark).l
	tst.w	$26(a0)
	beq.w	loc_7122
	subq.w	#1,$26(a0)
	rts
; -----------------------------------------------------------------------------------------

loc_7122:
	ori.b	#$80,6(a0)
	move.w	#$40,$26(a0)
	bsr.w	ActorBookmark
	bsr.w	ActorMove
	subq.w	#1,$26(a0)
	beq.w	loc_7140
	rts
; -----------------------------------------------------------------------------------------

loc_7140:
	move.b	#0,6(a0)
	move.w	#8,d0
	bsr.w	ActorBookmark_SetDelay
	bsr.w	ActorBookmark

loc_7152:
	clr.w	d0
	move.b	9(a0),d0
	lsl.w	#2,d0
	movea.l	off_71CC(pc,d0.w),a2
	move.w	#7,d3

loc_7162:
	lea	(loc_7270).l,a1
	bsr.w	FindActorSlotQuick
	bcs.w	loc_71BA
	move.b	#$87,6(a1)
	move.b	8(a0),8(a1)
	move.b	9(a0),9(a1)
	move.l	a2,$32(a1)
	move.w	$A(a0),$A(a1)
	move.w	$E(a0),$E(a1)
	move.w	#$FFFF,$20(a1)
	move.w	#$800,$1C(a1)
	move.b	d3,d0
	lsl.b	#5,d0
	move.w	#$100,d1
	jsr	(Sin).l
	move.l	d2,$12(a1)
	jsr	(Cos).l
	move.l	d2,$16(a1)

loc_71BA:
	dbf	d3,loc_7162
	move.b	#$60,d0
	jsr	PlaySound_ChkSamp
	bra.w	ActorDeleteSelf
; End of function sub_7104

; -----------------------------------------------------------------------------------------
off_71CC
	dc.l	unk_71DC
	dc.l	unk_71E4
	dc.l	unk_71EC
	dc.l	unk_71F4
unk_71DC
	dc.b	8
	dc.b	0
	dc.b	$20
	dc.b	4
	dc.b	$40
	dc.b	8
	dc.b	$FE
	dc.b	0
unk_71E4
	dc.b	8
	dc.b	1
	dc.b	$20
	dc.b	5
	dc.b	$40
	dc.b	9
	dc.b	$FE
	dc.b	0
unk_71EC
	dc.b	8
	dc.b	2
	dc.b	$20
	dc.b	6
	dc.b	$40
	dc.b	$A
	dc.b	$FE
	dc.b	0
unk_71F4
	dc.b	8
	dc.b	3
	dc.b	$20
	dc.b	7
	dc.b	$40
	dc.b	$B
	dc.b	$FE
	dc.b	0
; -----------------------------------------------------------------------------------------

loc_71FC:
	lea	(word_725A).l,a2
	move.w	#$A0,d1
	tst.b	$2A(a0)
	bne.w	loc_7212
	move.w	#$160,d1

loc_7212:
	move.w	#3,d0

loc_7216:
	lea	(loc_7262).l,a1
	jsr	FindActorSlotQuick
	bcs.w	loc_7254
	move.b	#$25,8(a1)
	move.b	d0,9(a1)
	movem.l	d0,-(sp)
	jsr	Random
	andi.w	#$3F,d0
	add.w	d1,d0
	move.w	d0,$A(a1)
	movem.l	(sp)+,d0
	move.w	d0,d2
	lsl.w	#4,d2
	move.w	d2,$26(a1)
	move.w	(a2)+,$E(a1)

loc_7254:
	dbf	d0,loc_7216
	rts
; -----------------------------------------------------------------------------------------
word_725A
	dc.w	$A0
	dc.w	$B8
	dc.w	$B0
	dc.w	$A8
; -----------------------------------------------------------------------------------------

loc_7262:
	tst.w	$26(a0)
	beq.w	loc_7152
	subq.w	#1,$26(a0)
	rts
; -----------------------------------------------------------------------------------------

loc_7270:
	bsr.w	ActorMove
	bcs.w	ActorDeleteSelf
	bsr.w	ActorAnimate
	bcs.w	ActorDeleteSelf
	rts

; =============== S U B	R O U T	I N E =====================================================


sub_7282:
	move.w	#$800A,d0
	swap	d0
	move.b	$2A(a0),d0
	jmp	QueuePlaneCmd
; End of function sub_7282


; =============== S U B	R O U T	I N E =====================================================


sub_7292:
	lea	(loc_72A4).l,a1
	bra.w	FindActorSlot
; End of function sub_7292

; -----------------------------------------------------------------------------------------
	nop
	nop
	nop
	nop

loc_72A4:
	move.w	#$A,$26(a0)
	jsr	(ActorBookmark).l
	move.w	#$9B00,d0
	move.b	$27(a0),d0
	swap	d0
	jsr	QueuePlaneCmd
	subq.w	#1,$26(a0)
	beq.w	loc_72CA
	rts
; -----------------------------------------------------------------------------------------

loc_72CA:
	jsr	(ActorBookmark).l
	move.w	#$800C,d0
	swap	d0
	move.w	#$F00,d0
	jmp	QueuePlaneCmd

; =============== S U B	R O U T	I N E =====================================================


sub_72E0:
	movem.l	a0,-(sp)
	lea	(ArtPuyo_VSWinLose).l,a0
	move.w	#$4000,d0
	
	if PuyoCompression=0
	jsr	PuyoDec
	else
	DISABLE_INTS
	jsr	NemDec
	ENABLE_INTS
	endc
	
	lea	(ArtNem_VSWinLose).l,a0
	move.w	#$2000,d0
	DISABLE_INTS
	jsr	NemDec
	ENABLE_INTS
	lea	Palettes,a2
	adda.l	#(Pal_3156-Palettes),a2
	move.b	#3,d0
	jsr	LoadPalette
	movem.l	(sp)+,a0

	lea	(ActVSAllRight).l,a1
	bsr.w	FindActorSlot
	bcs.w	locret_7482
	move.b	#$80,6(a1)
	move.b	#$27,8(a1)
	move.l	a0,$2E(a1)
	move.b	$2A(a0),$2A(a1)
	eori.b	#1,$2A(a1)
	move.b	#$FF,7(a1)

	movea.l	a1,a2
	lea	(loc_7654).l,a1
	bsr.w	FindActorSlot
	bcs.w	locret_7482
	move.b	#$80,6(a1)
	move.b	#$27,8(a1)
	move.b	#$12,9(a1)
	move.w	#$4B,$28(a1)
	move.w	#$1F,$2A(a1)
	move.l	a2,$2E(a1)
	move.l	#byte_767E,$32(a1)
	moveq	#1,d1
	lea	(byte_7484).l,a3

loc_7398:
	lea	(loc_76B0).l,a1
	bsr.w	FindActorSlot
	bcs.w	locret_7482
	move.b	#0,6(a1)
	move.b	#$27,8(a1)
	move.b	#$15,9(a1)
	move.l	a2,$2E(a1)
	move.b	(a3)+,$29(a1)
	move.b	(a3)+,$2B(a1)
	jsr	Random
	andi.b	#$3F,d0
	move.b	d0,$22(a1)
	dbf	d1,loc_7398

	lea	(ActVSOhNo).l,a1
	bsr.w	FindActorSlot
	bcs.w	locret_7482
	move.b	#$93,6(a1)
	move.b	#$27,8(a1)
	move.b	#1,9(a1)
	move.l	a0,$2E(a1)
	move.b	$2A(a0),$2A(a1)
	move.b	#$FF,7(a1)
	move.l	#unk_7832,$32(a1)

	movea.l	a1,a2
	lea	(loc_7654).l,a1
	bsr.w	FindActorSlot
	bcs.w	locret_7482
	move.b	#$80,6(a1)
	move.b	#$27,8(a1)
	move.b	#$19,9(a1)
	move.w	#$4C,$28(a1)
	move.w	#$2F,$2A(a1)
	move.l	a2,$2E(a1)
	move.l	#unk_7692,$32(a1)
	moveq	#1,d1

loc_744A:
	lea	(ActVSOhNoSmoke).l,a1
	bsr.w	FindActorSlot
	bcs.w	locret_7482
	move.b	#0,6(a1)
	move.b	#$27,8(a1)
	move.b	#$1E,9(a1)
	move.l	a2,$2E(a1)
	move.w	(a3)+,$28(a1)
	move.w	(a3)+,$2A(a1)
	move.l	(a3),$32(a1)
	move.l	(a3)+,$36(a1)
	dbf	d1,loc_744A

locret_7482:
	rts
; End of function sub_72E0

; -----------------------------------------------------------------------------------------
byte_7484:
	dc.b	$2C
	dc.b	4
	dc.b	$52
	dc.b	2
	dc.w	$3C
	dc.w	2
	dc.l	Ani_VSOhNoSmoke1
	dc.w	$FFFB
	dc.w	$37
	dc.l	Ani_VSOhNoSmoke2

; =============== S U B	R O U T	I N E =====================================================


LoadVSAllRightStars:
	move.w	#$1F,d0
	lea	(VSAllRightStarAniData).l,a2

loc_74A2:
	lea	(ActVSAllRightStar).l,a1
	jsr	FindActorSlotQuick
	bcs.w	loc_751C
	move.l	a0,$2E(a1)
	move.b	8(a0),8(a1)
	move.w	$A(a0),$1E(a1)
	addi.w	#$30,$1E(a1)
	move.w	$20(a0),$20(a1)
	addi.w	#$18,$20(a1)

	move.b	d0,d1
	lsl.b	#4,d1
	move.b	d0,d2
	lsr.b	#1,d2
	andi.b	#8,d2
	or.b	d2,d1
	move.b	d1,$36(a1)

	move.w	d0,d1
	andi.b	#$10,d1
	move.w	#8,d2
	lsl.w	d2,d1
	addi.w	#$2000,d1
	move.w	d1,$38(a1)

	move.w	d0,d1
	lsl.b	#2,d1
	andi.b	#$C,d1
	move.l	(a2,d1.w),$32(a1)

	move.b	#1,$12(a1)
	cmpi.b	#$10,d0
	bcc.w	loc_751C
	move.b	#$FF,$12(a1)

loc_751C:
	dbf	d0,loc_74A2
	rts
; End of function LoadVSAllRightStars


; =============== S U B	R O U T	I N E =====================================================


ActVSAllRightStar:
	jsr	(ActorAnimate).l
	move.b	#$80,6(a0)
	jsr	(ActorBookmark).l
	movea.l	$2E(a0),a1
	tst.b	7(a1)
	beq.w	ActorDeleteSelf
	jsr	(ActorAnimate).l
	move.b	$36(a0),d0
	move.w	$38(a0),d1
	jsr	(Sin).l
	swap	d2
	add.w	$1E(a0),d2
	move.w	d2,$A(a0)
	addi.b	#$28,d0
	asr.w	#1,d1
	jsr	(Cos).l
	swap	d2
	add.w	$20(a0),d2
	move.w	d2,$E(a0)
	move.b	$12(a0),d0
	add.b	d0,$36(a0)
	rts
; End of function ActVSAllRightStar

; -----------------------------------------------------------------------------------------
VSAllRightStarAniData:
	dc.l	unk_7592
	dc.l	unk_759E
	dc.l	unk_75AA
	dc.l	unk_75B6
	dc.l	unk_75C2
unk_7592:
	dc.b	4
	dc.b	3
	dc.b	4
	dc.b	4
	dc.b	4
	dc.b	5
	dc.b	$FF
	dc.b	0
	dc.l	unk_7592
unk_759E:
	dc.b	4
	dc.b	8
	dc.b	4
	dc.b	7
	dc.b	4
	dc.b	6
	dc.b	$FF
	dc.b	0
	dc.l	unk_759E
unk_75AA:
	dc.b	4
	dc.b	9
	dc.b	4
	dc.b	$A
	dc.b	4
	dc.b	$B
	dc.b	$FF
	dc.b	0
	dc.l	unk_75AA
unk_75B6:
	dc.b	4
	dc.b	$E
	dc.b	4
	dc.b	$D
	dc.b	4
	dc.b	$C
	dc.b	$FF
	dc.b	0
	dc.l	unk_75B6
unk_75C2:
	dc.b	4
	dc.b	$F
	dc.b	4
	dc.b	$10
	dc.b	4
	dc.b	$11
	dc.b	$FF
	dc.b	0
	dc.l	unk_75C2
; -----------------------------------------------------------------------------------------

ActVSAllRight:
	bsr.w	GetPuyoFieldTopLeft
	move.w	d0,$A(a0)
	addi.w	#$48,d1
	move.w	d1,$20(a0)
	bsr.w	LoadVSAllRightStars
	bsr.w	ActorBookmark
	movea.l	$2E(a0),a1
	btst	#2,7(a1)
	beq.w	ActorDeleteSelf
	btst	#1,7(a1)
	beq.w	loc_7620
	move.b	$36(a0),d0
	ori.b	#$80,d0
	move.w	#$1000,d1
	jsr	(Sin).l
	swap	d2
	add.w	$20(a0),d2
	move.w	d2,$E(a0)
	addq.b	#4,$36(a0)
	rts
; -----------------------------------------------------------------------------------------

loc_7620:
	move.b	#0,7(a0)
	move.b	#$80,6(a0)
	move.b	#$29,8(a0)
	move.l	#unk_8308,$32(a0)
	move.w	$20(a0),$E(a0)
	addi.w	#$30,$A(a0)
	subq.w	#8,$E(a0)
	bsr.w	ActorBookmark
	jmp	(ActorAnimate).l
; -----------------------------------------------------------------------------------------

loc_7654:
	movea.l	$2E(a0),a1
	tst.b	7(a1)
	beq.w	ActorDeleteSelf
	move.w	$A(a1),d0
	add.w	$28(a0),d0
	move.w	d0,$A(a0)
	move.w	$E(a1),d0
	add.w	$2A(a0),d0
	move.w	d0,$E(a0)
	jmp	(ActorAnimate).l
; -----------------------------------------------------------------------------------------
byte_767E
	dc.b	$3C
	dc.b	$12
	dc.b	8
	dc.b	$13
	dc.b	5
	dc.b	$12
	dc.b	5
	dc.b	$14
	dc.b	5
	dc.b	$13
	dc.b	5
	dc.b	$12
	dc.b	5
	dc.b	$13
	dc.b	$FF
	dc.b	0
	dc.l	byte_767E
unk_7692
	dc.b	$1E
	dc.b	$19
	dc.b	7
	dc.b	$1A
	dc.b	5
	dc.b	$1B
	dc.b	4
	dc.b	$1C
	dc.b	3
	dc.b	$1B
	dc.b	3
	dc.b	$1A
	dc.b	3
	dc.b	$19
	dc.b	3
	dc.b	$1D
	dc.b	3
	dc.b	$19
	dc.b	3
	dc.b	$1A
	dc.b	3
	dc.b	$19
	dc.b	3
	dc.b	$1D
	dc.b	$FF
	dc.b	0
	dc.l	unk_7692
; -----------------------------------------------------------------------------------------

loc_76B0:
	movea.l	$2E(a0),a1
	tst.b	7(a1)
	beq.w	ActorDeleteSelf
	move.w	$A(a1),d0
	add.w	$28(a0),d0
	move.w	d0,$A(a0)
	move.w	$E(a1),d0
	add.w	$2A(a0),d0
	move.w	d0,$E(a0)
	tst.b	$22(a0)
	beq.s	loc_76E0
	subq.b	#1,$22(a0)
	rts
; -----------------------------------------------------------------------------------------

loc_76E0:
	move.b	$26(a0),d0
	beq.s	loc_7714
	cmpi.b	#1,d0
	beq.s	loc_770C
	move.b	#0,$26(a0)
	move.b	#0,6(a0)
	jsr	Random
	andi.b	#$3F,d0
	addi.b	#$44,d0
	move.b	d0,$22(a0)
	rts
; -----------------------------------------------------------------------------------------

loc_770C:
	move.b	#$16,9(a0)
	bra.s	loc_7720
; -----------------------------------------------------------------------------------------

loc_7714:
	move.b	#$80,6(a0)
	move.b	#$15,9(a0)

loc_7720:
	addq.b	#1,$26(a0)
	move.b	#5,$22(a0)
	rts

; =============== S U B	R O U T	I N E =====================================================


sub_772C:
	movea.l	$2E(a0),a1
	btst	#2,7(a1)
	beq.w	loc_7746
	btst	#1,7(a1)
	beq.w	loc_7746
	rts
; -----------------------------------------------------------------------------------------

loc_7746:
	movem.l	(sp)+,d0
	clr.b	7(a0)
	bra.w	ActorDeleteSelf
; End of function sub_772C


; =============== S U B	R O U T	I N E =====================================================


ActVSOhNo:
	bsr.w	GetPuyoFieldTopLeft
	subi.w	#$10,d0
	move.w	d0,$A(a0)
	addi.w	#-$30,d1
	move.w	d1,$E(a0)
	move.l	#$10000,$12(a0)
	move.l	#$8000,$16(a0)
	move.w	#6,$28(a0)

loc_777C:
	move.w	#$20,$26(a0)
	bsr.w	ActorBookmark
	bsr.s	sub_772C
	tst.w	$26(a0)
	beq.w	loc_77A2
	jsr	(ActorMove).l
	jsr	(ActorAnimate).l
	subq.w	#1,$26(a0)
	rts
; -----------------------------------------------------------------------------------------

loc_77A2:
	tst.w	$28(a0)
	beq.w	loc_77BA
	subq.w	#1,$28(a0)
	move.l	$12(a0),d0
	neg.l	d0
	move.l	d0,$12(a0)
	bra.s	loc_777C
; -----------------------------------------------------------------------------------------

loc_77BA:
	move.l	$12(a0),d0
	neg.l	d0
	move.l	d0,$12(a0)
	move.w	#$10,d0
	bsr.w	ActorBookmark_SetDelay
	jsr	(ActorMove).l
	jsr	(ActorAnimate).l
	bsr.w	ActorBookmark

loc_77DC:
	bsr.w	ActorBookmark
	bsr.w	sub_772C
	cmpi.w	#$90,$E(a0)
	bcs.w	loc_77F4
	subq.w	#1,$E(a0)
	rts
; -----------------------------------------------------------------------------------------

loc_77F4:
	move.b	#$85,6(a0)
	clr.l	$16(a0)
	move.w	#$2000,$1C(a0)
	move.w	#$FFFF,$20(a0)
	bsr.w	ActorBookmark
	bsr.w	sub_772C
	jsr	(ActorMove).l
	jsr	(ActorAnimate).l
	cmpi.w	#$D0,$E(a0)
	bcc.w	loc_782A
	rts
; -----------------------------------------------------------------------------------------

loc_782A:
	move.w	#$D0,$E(a0)
	bra.s	loc_77DC
; End of function ActVSOhNo

; -----------------------------------------------------------------------------------------
unk_7832
	dc.b	$1E
	dc.b	1
	dc.b	$A
	dc.b	$17
	dc.b	5
	dc.b	1
	dc.b	$D
	dc.b	$18
	dc.b	$FF
	dc.b	0
	dc.l	unk_7832
; -----------------------------------------------------------------------------------------

ActVSOhNoSmoke:
	movea.l	$2E(a0),a1
	tst.b	7(a1)
	beq.w	ActorDeleteSelf
	move.w	$A(a1),d0
	add.w	$28(a0),d0
	move.w	d0,$A(a0)
	move.w	$E(a1),d0
	add.w	$2A(a0),d0
	move.w	d0,$E(a0)
	tst.b	$2C(a0)
	bne.s	loc_7882
	cmpi.b	#$18,9(a1)
	bne.s	locret_7880
	cmpi.b	#$C,$22(a1)
	bne.s	locret_7880
	move.b	#1,$2C(a0)

locret_7880:
	rts
; -----------------------------------------------------------------------------------------

loc_7882:
	move.b	#$80,6(a0)
	jsr	(ActorAnimate).l
	bcc.s	locret_78A2
	move.b	#0,6(a0)
	clr.b	$2C(a0)
	move.l	$36(a0),d0
	move.l	d0,$32(a0)

locret_78A2:
	rts
; -----------------------------------------------------------------------------------------
Ani_VSOhNoSmoke1
	dc.b	4
	dc.b	$1E
	dc.b	5
	dc.b	$1F
	dc.b	6
	dc.b	$20
	dc.b	7
	dc.b	$21
	dc.b	$FE
	dc.b	0
Ani_VSOhNoSmoke2
	dc.b	4
	dc.b	$22
	dc.b	5
	dc.b	$23
	dc.b	6
	dc.b	$24
	dc.b	7
	dc.b	$25
	dc.b	$FE
	dc.b	0

; =============== S U B	R O U T	I N E =====================================================


sub_78B8:
	lea	(loc_78E8).l,a1
	jsr	FindActorSlot
	bcc.w	loc_78CA
	rts
; -----------------------------------------------------------------------------------------

loc_78CA:
	move.l	a0,$2E(a1)
	move.b	#$27,8(a1)
	move.b	#2,9(a1)
	move.w	#$118,$A(a1)
	move.w	#$10C,$E(a1)
	rts
; End of function sub_78B8

; -----------------------------------------------------------------------------------------

loc_78E8:
	move.w	#$40,d0
	jsr	RandomBound
	addi.w	#$20,d0
	move.w	d0,$26(a0)
	bsr.w	ActorBookmark
	tst.w	$26(a0)
	beq.w	loc_790C
	subq.w	#1,$26(a0)
	rts
; -----------------------------------------------------------------------------------------

loc_790C:
	move.b	#$80,6(a0)
	move.w	#$30,d0
	bsr.w	ActorBookmark_SetDelay
	bsr.w	ActorBookmark
	move.b	#0,6(a0)
	bra.s	loc_78E8

; =============== S U B	R O U T	I N E =====================================================


sub_7926:
	bsr.w	GetPuyoField
	adda.l	#$18,a2
	move.w	#$8E,d0

loc_7934:
	move.b	(a2,d0.w),d1
	beq.w	loc_794E
	andi.b	#$70,d1
	cmpi.b	#$60,d1
	beq.w	loc_794E
	andi.b	#$F3,(a2,d0.w)

loc_794E:
	subq.w	#2,d0
	bcc.s	loc_7934
	DISABLE_INTS
	bsr.w	sub_5782
	ENABLE_INTS
	clr.w	d3
	lea	(loc_833E).l,a1
	bsr.w	FindActorSlot
	bcs.w	loc_7982
	addq.w	#1,d3
	move.l	a0,$2E(a1)
	move.l	#unk_837A,$32(a1)
	move.b	#$FF,8(a1)

loc_7982:
	bsr.w	GetPuyoField
	adda.l	#$18,a2
	andi.w	#$7F,d0
	move.w	d0,d2
	bsr.w	GetPuyoFieldTopLeft
	addi.w	#$17,d0
	lea	(unk_7A7C).l,a3
	move.w	#5,d1

loc_79A4:
	lea	(loc_8386).l,a1
	bsr.w	FindActorSlot
	bcs.w	loc_79E6
	bsr.w	sub_8250
	addq.w	#1,d3
	move.l	a0,$2E(a1)
	move.b	#4,6(a1)
	move.w	d0,$A(a1)
	move.w	#$2000,$1C(a1)
	move.w	#$FFFF,$20(a1)
	move.w	d2,$32(a1)
	move.w	d1,d4
	lsl.w	#1,d4
	move.w	(a3,d4.w),$24(a1)
	move.w	$C(a3,d4.w),$1A(a1)

loc_79E6:
	addi.w	#$A,d0
	addq.w	#4,d2
	adda.l	#2,a2
	dbf	d1,loc_79A4
	move.w	d3,$26(a0)
	rts
; End of function sub_7926

; -----------------------------------------------------------------------------------------

ActPuyoField_Lose:
	cmpi.b	#1,stage_mode
	bcc.w	loc_7A12
	jsr	(StopSound).l
	bsr.w	ActorBookmark

loc_7A12:
	bsr.w	sub_7A94
	bsr.w	sub_7926
	bsr.w	ActorBookmark
	tst.w	$26(a0)
	beq.w	loc_7A28
	rts
; -----------------------------------------------------------------------------------------

loc_7A28:
	bsr.w	ResetPuyoField
	DISABLE_INTS
	bsr.w	sub_5782
	ENABLE_INTS
	bsr.w	ActorBookmark
	bsr.w	GetPuyoField
	andi.w	#$7F,d0
	move.w	#5,d1
	lea	(vscroll_buffer).l,a2

loc_7A4E:
	clr.l	(a2,d0.w)
	addq.w	#4,d0
	dbf	d1,loc_7A4E
	clr.w	d0
	move.b	stage_mode,d0
	andi.b	#3,d0
	lsl.b	#2,d0
	movea.l	off_7A6C(pc,d0.w),a2
	jmp	(a2)
; -----------------------------------------------------------------------------------------
off_7A6C
	dc.l	loc_7D78
	dc.l	loc_7F70
	dc.l	loc_80EE
	dc.l	loc_80EE
unk_7A7C
	dc.b	0
	dc.b	$20
	dc.b	0
	dc.b	$14
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	4
	dc.b	0
	dc.b	$10
	dc.b	0
	dc.b	$24
	dc.b	$B
	dc.b	0
	dc.b	9
	dc.b	0
	dc.b	7
	dc.b	0
	dc.b	8
	dc.b	0
	dc.b	$A
	dc.b	0
	dc.b	$B
	dc.b	0

; =============== S U B	R O U T	I N E =====================================================


sub_7A94:
	clr.w	d0
	move.b	stage_mode,d0
	lsl.b	#2,d0
	movea.l	off_7AA4(pc,d0.w),a2
	jmp	(a2)
; End of function sub_7A94

; -----------------------------------------------------------------------------------------
off_7AA4
	dc.l	loc_7ACE
	dc.l	loc_7C50
	dc.l	loc_7CAC
	dc.l	loc_7CAC
	dc.l	loc_7AB8
; -----------------------------------------------------------------------------------------

loc_7AB8:
	movea.l	$2E(a0),a1
	bsr.w	ActorDeleteOther
	clr.b	bytecode_flag
	clr.b	(bytecode_disabled).l
	rts
; -----------------------------------------------------------------------------------------

loc_7ACE:
	move.w	#$FFFF,puyos_popping
	clr.w	p1_pause
	move.b	$2A(a0),d0
	eori.b	#1,d0
	move.b	d0,bytecode_flag
	move.b	d0,(byte_FF0115).l
	clr.w	d0
	move.b	$2A(a0),d0
	lsl.b	#1,d0
	ori.b	#1,d0
	move.w	d0,(word_FF198C).l
	clr.l	dword_FF195C
	clr.w	dword_FF1960
	tst.b	$2A(a0)
	bne.w	loc_7B2C
	movea.l	$2E(a0),a1
	bsr.w	ActorDeleteOther
	bsr.w	sub_7C14
	move.b	#$59,d0
	jmp	PlaySound_ChkSamp
; -----------------------------------------------------------------------------------------

loc_7B2C:
	jsr	(sub_DF74).l
	move.w	(time_total_seconds).l,d0
	cmpi.w	#999+1,d0
	bcs.w	loc_7B44
	move.w	#999,d0

loc_7B44:
	move.w	d0,$16(a0)
	bsr.w	sub_7CF6
	move.w	d0,$12(a0)
	movea.l	$2E(a0),a1
	move.l	$A(a1),$A(a0)
	move.l	$A(a1),dword_FF195C
	add.l	d0,dword_FF195C
	cmpi.l	#99999999+1,dword_FF195C
	bcs.w	loc_7B80
	move.l	#99999999,dword_FF195C

loc_7B80:
	move.w	$16(a1),dword_FF1960
	cmpi.b	#$F,stage
	beq.w	loc_7BB6
	cmpi.b	#2,stage
	beq.w	loc_7BB6

loc_7BA0:
	bsr.w	ActorDeleteOther
	bsr.w	sub_7292
	bsr.w	sub_7078
	bsr.w	sub_7BD8
	jmp	(PlayStageWinMusic).l
; -----------------------------------------------------------------------------------------

loc_7BB6:
	movem.l	a0-a1,-(sp)
	movea.l	a1,a0
	move.l	dword_FF195C,$A(a0)
	move.b	stage_mode,high_score_table_id
	bsr.w	sub_C438
	movem.l	(sp)+,a0-a1
	bra.s	loc_7BA0

; =============== S U B	R O U T	I N E =====================================================


sub_7BD8:
	move.b	opponent,d0
	cmpi.b	#$C,d0
	bne.s	locret_7C12
	lea	(loc_7BF0).l,a1
	jmp	FindActorSlotQuick
; -----------------------------------------------------------------------------------------

loc_7BF0:
	move.w	#$10,$26(a0)
	jsr	(ActorBookmark).l
	subq.w	#1,$26(a0)
	bpl.s	locret_7C12
	move.b	#$90,d0
	jsr	PlaySound_ChkSamp
	jmp	(ActorDeleteSelf).l
; -----------------------------------------------------------------------------------------

locret_7C12:
	rts
; End of function sub_7BD8


; =============== S U B	R O U T	I N E =====================================================


sub_7C14:
	move.b	opponent,d0
	cmpi.b	#$C,d0
	bne.s	locret_7C4E
	lea	(loc_7C2C).l,a1
	jmp	FindActorSlotQuick
; -----------------------------------------------------------------------------------------

loc_7C2C:
	move.w	#$20,$26(a0)
	jsr	(ActorBookmark).l
	subq.w	#1,$26(a0)
	bpl.s	locret_7C4E
	move.b	#$6B,d0
	jsr	PlaySound_ChkSamp
	jmp	(ActorDeleteSelf).l
; -----------------------------------------------------------------------------------------

locret_7C4E:
	rts
; End of function sub_7C14

; -----------------------------------------------------------------------------------------

loc_7C50:
	clr.w	d0
	move.b	$2A(a0),d0
	lea	puyos_popping,a1
	move.b	#$FF,(a1,d0.w)
	clr.w	p1_pause
	movea.l	$2E(a0),a1
	bsr.w	ActorDeleteOther
	move.b	#$59,d0
	jsr	PlaySound_ChkSamp
	move.b	#3,opponent
	clr.w	d0
	move.b	$2A(a0),d0
	eori.b	#1,d0
	lea	(p1_win_count).l,a1
	addq.b	#1,(a1,d0.w)
	cmpi.b	#$64,(a1,d0.w)
	bcs.w	loc_7CA8
	clr.w	(a1)
	move.b	#1,(a1,d0.w)

loc_7CA8:
	bra.w	loc_71FC
; -----------------------------------------------------------------------------------------

loc_7CAC:
	clr.w	d0
	move.b	$2A(a0),d0
	lea	puyos_popping,a1
	lea	p1_pause,a2
	move.b	#$FF,(a1,d0.w)
	clr.b	(a2,d0.w)
	move.b	#$59,d0
	jmp	PlaySound_ChkSamp

; =============== S U B	R O U T	I N E =====================================================


sub_7CD2:
	nop
	nop
	nop
	move.w	#$9800,d0
	swap	d0
	move.w	$16(a0),d0
	jsr	QueuePlaneCmd
	nop
	nop
	move.b	#$5C,d0
	jmp	PlaySound_ChkSamp
; End of function sub_7CD2


; =============== S U B	R O U T	I N E =====================================================


sub_7CF6:
	clr.w	d0
	move.b	(byte_FF0114).l,d0
	addq.b	#1,d0
	mulu.w	#$A,d0
	addi.w	#$6E,d0
	sub.w	$16(a0),d0
	bcc.w	loc_7D12
	clr.w	d0

loc_7D12:
	mulu.w	d0,d0
	mulu.w	#3,d0
	rts
; End of function sub_7CF6

; -----------------------------------------------------------------------------------------

loc_7D1A:
	clr.l	d0
	move.w	$12(a0),d0
	bne.w	loc_7D26
	rts
; -----------------------------------------------------------------------------------------

loc_7D26:
	cmp.w	$28(a0),d0
	bcs.w	loc_7D32
	move.w	$28(a0),d0

loc_7D32:
	sub.w	d0,$12(a0)
	jsr	(AddComboDraw).l
	move.b	$27(a0),d0
	andi.b	#3,d0
	bne.w	loc_7D52
	move.b	#$5F,d0
	jsr	PlaySound_ChkSamp

loc_7D52:
	move.w	#$9900,d0
	swap	d0
	move.w	$12(a0),d0
	jmp	QueuePlaneCmd

; =============== S U B	R O U T	I N E =====================================================


sub_7D62:
	moveq	#0,d0
	move.w	#$9E00,d0
	swap	d0
	jsr	QueuePlaneCmd
	moveq	#$70,d0
	jmp	PlaySound_ChkSamp
; End of function sub_7D62

; -----------------------------------------------------------------------------------------

loc_7D78:
	tst.b	$2A(a0)
	beq.w	loc_7EC2
	move.b	#0,$2A(a0)
	move.w	#$60,d0
	jsr	(ActorBookmark_SetDelay).l
	jsr	(ActorBookmark_Ctrl).l
	bsr.w	sub_7CD2
	move.w	#$20,d0
	jsr	(ActorBookmark_SetDelay).l
	jsr	(ActorBookmark).l
	tst.w	$12(a0)
	beq.w	loc_7E30
	move.w	#$9900,d0
	swap	d0
	move.w	$12(a0),d0
	jsr	QueuePlaneCmd
	move.b	#$5D,d0
	jsr	PlaySound_ChkSamp
	move.w	$12(a0),d0
	lsr.w	#7,d0
	bne.w	loc_7DDA
	move.w	#1,d0

loc_7DDA:
	move.w	d0,$28(a0)
	move.w	#$80,$26(a0)
	move.w	#$3C,d0
	jsr	(ActorBookmark_SetDelay).l
	jsr	(ActorBookmark).l
	bsr.w	GetFieldCtrlData
	andi.b	#$F0,d0
	bne.w	loc_7E14
	subq.w	#1,$26(a0)
	beq.w	loc_7E14
	cmpi.w	#$780,$26(a0)
	bcs.w	loc_7D1A
	rts
; -----------------------------------------------------------------------------------------

loc_7E14:
	clr.l	d0
	move.w	$12(a0),d0
	jsr	(AddComboDraw).l
	move.l	#$99000000,d0
	jsr	QueuePlaneCmd
	bra.w	loc_7E56
; -----------------------------------------------------------------------------------------

loc_7E30:
	move.l	#$80050000,d0
	jsr	QueuePlaneCmd
	move.b	#$5E,d0
	jsr	PlaySound_ChkSamp
	move.w	#$40,d0
	jsr	(ActorBookmark_SetDelay).l
	jsr	(ActorBookmark_Ctrl).l

loc_7E56:
	move.b	stage,d0
	cmpi.b	#$F,d0
	beq.s	loc_7E68
	bsr.w	sub_7D62
	bra.s	loc_7E9E
; -----------------------------------------------------------------------------------------

loc_7E68:
	move.l	#$80160000,d0
	jsr	QueuePlaneCmd
	moveq	#$70,d0
	jsr	PlaySound_ChkSamp
	move.w	#$78,d0
	jsr	(ActorBookmark_SetDelay).l
	jsr	(ActorBookmark).l
	clr.b	7(a0)
	bsr.w	ActorBookmark
	clr.b	(bytecode_disabled).l
	bra.w	ActorDeleteSelf
; -----------------------------------------------------------------------------------------

loc_7E9E:
	jsr	(ActorBookmark).l
	move.w	#$A,$24(a0)
	jsr	(ActorBookmark_Ctrl).l
	clr.b	7(a0)
	bsr.w	ActorBookmark
	clr.b	(bytecode_disabled).l
	bra.w	ActorDeleteSelf
; -----------------------------------------------------------------------------------------

loc_7EC2:
	move.b	#1,7(a0)
	bsr.w	sub_8298
	move.w	#$80,d0
	jsr	(ActorBookmark_SetDelay).l
	jsr	(ActorBookmark_Ctrl).l
	move.b	stage_mode,high_score_table_id
	bsr.w	sub_C438
	bcc.w	loc_7EF2
	bsr.w	sub_BFA6

loc_7EF2:
	bsr.w	ActorBookmark
	btst	#1,7(a0)
	beq.w	loc_7F02
	rts
; -----------------------------------------------------------------------------------------

loc_7F02:
	bsr.w	ResetPuyoField
	DISABLE_INTS
	bsr.w	sub_5782
	ENABLE_INTS
	clr.b	7(a0)
	bsr.w	ActorBookmark
	clr.b	(bytecode_disabled).l
	bra.w	ActorDeleteSelf

; =============== S U B	R O U T	I N E =====================================================


sub_7F24:
	lea	(sub_7F5A).l,a1
	jsr	FindActorSlot
	bcs.w	locret_7F58
	move.l	a0,$2E(a1)
	move.b	#$19,8(a1)
	move.b	#$80,6(a1)
	move.w	#$120,$A(a1)
	move.w	#$108,$E(a1)
	move.l	#unk_7F62,$32(a1)

locret_7F58:
	rts
; End of function sub_7F24


; =============== S U B	R O U T	I N E =====================================================


sub_7F5A:
	jsr	(ActorAnimate).l
	rts
; End of function sub_7F5A

; -----------------------------------------------------------------------------------------
unk_7F62
	dc.b	$C
	dc.b	$E
	dc.b	$A
	dc.b	$35
	dc.b	$C
	dc.b	$F
	dc.b	$A
	dc.b	$36
	dc.b	$FF
	dc.b	0
	dc.l	unk_7F62
; -----------------------------------------------------------------------------------------

loc_7F70:
	move.w	0(a0),d0
	move.b	$2A(a0),d1
	movem.l	d0-d1/a0,-(sp)
	jsr	(InitActors).l
	movem.l	(sp)+,d0-d1/a0
	move.w	d0,0(a0)
	move.b	d1,$2A(a0)
	bsr.w	ActorBookmark
	move.w	#$17,d0
	jsr	QueuePlaneCmdList
	bsr.w	ActorBookmark
	bsr.w	ActorBookmark
	move.w	#4,d0
	bsr.w	ActorBookmark_SetDelay
	bsr.w	ActorBookmark
	move.w	#2,(word_FF198C).l
	move.b	#$E,7(a0)
	bsr.w	sub_72E0
	jsr	(sub_9794).l
	bsr.w	ActorBookmark
	bsr.w	sub_7F24
	clr.w	d0
	move.b	$2A(a0),d0
	lea	(byte_FF012A).l,a1
	subq.b	#1,(a1,d0.w)
	bne.w	loc_80D2
	bsr.w	sub_9308
	ori.b	#1,7(a0)
	bsr.w	sub_8298
	move.w	#$80,d0
	bsr.w	ActorBookmark_SetDelay
	bsr.w	ActorBookmark_Ctrl
	move.w	#$280,$28(a0)
	andi.b	#$F7,7(a0)
	move.w	#$80,d4
	move.w	#$CCA2,d5
	move.w	#$A500,d6
	jsr	(LoadVSCountdown).l
	bsr.w	ActorBookmark
	jsr	(sub_78B8).l
	bsr.w	ActorBookmark
	bsr.w	GetFieldCtrlData
	btst	#7,d0
	beq.w	loc_8044
	jsr	(DummiedFunc).l
	bcs.w	loc_8044
	bra.w	loc_80B8
; -----------------------------------------------------------------------------------------

loc_8044:
	tst.w	$28(a0)
	beq.w	loc_8084
	subq.w	#1,$28(a0)
	andi.b	#$70,d0
	beq.w	loc_805E
	andi.b	#$C0,$29(a0)

loc_805E:
	bsr.w	sub_7282
	move.w	#$8008,d0
	jsr	(DummiedFunc).l
	bcs.w	loc_8074
	move.w	#$8009,d0

loc_8074:
	swap	d0
	move.w	#$F00,d0
	move.b	$2A(a0),d0
	jmp	QueuePlaneCmd
; -----------------------------------------------------------------------------------------

loc_8084:
	bsr.w	sub_7282
	andi.b	#$FD,7(a0)
	move.w	#3,(word_FF198C).l
	bsr.w	ActorBookmark
	move.w	#$80,d0
	bsr.w	ActorBookmark_SetDelay
	bsr.w	ActorBookmark_Ctrl
	clr.b	(bytecode_disabled).l
	move.b	#$FF,bytecode_flag
	bra.w	ActorDeleteSelf
; -----------------------------------------------------------------------------------------

loc_80B8:
	move.b	#$41,d0
	jsr	PlaySound_ChkSamp
	clr.b	(bytecode_disabled).l
	clr.b	bytecode_flag
	bra.w	ActorDeleteSelf
; -----------------------------------------------------------------------------------------

loc_80D2:
	move.w	#$100,d0
	bsr.w	ActorBookmark_SetDelay
	bsr.w	ActorBookmark_Ctrl
	clr.b	(bytecode_disabled).l
	clr.b	bytecode_flag
	bra.w	ActorDeleteSelf
; -----------------------------------------------------------------------------------------

loc_80EE:
	move.b	#1,7(a0)
	bsr.w	sub_8298
	move.w	#$C0,d0
	jsr	(ActorBookmark_SetDelay).l
	jsr	(ActorBookmark).l
	move.b	#1,high_score_table_id
	bsr.w	sub_C438
	bcc.w	loc_811C
	bsr.w	sub_BFA6

loc_811C:
	bsr.w	ActorBookmark
	btst	#1,7(a0)
	beq.w	loc_812C
	rts
; -----------------------------------------------------------------------------------------

loc_812C:
	bsr.w	ResetPuyoField
	DISABLE_INTS
	bsr.w	sub_5782
	ENABLE_INTS

loc_813C:
	move.w	#$1C0,$26(a0)
	bsr.w	ActorBookmark
	move.b	byte_FF1965,d0
	eori.b	#3,d0
	beq.w	loc_81FC
	bsr.w	GetFieldCtrlData
	btst	#7,d0
	beq.w	loc_816E
	jsr	(DummiedFunc).l
	bcs.w	loc_816E
	bra.w	loc_81AE
; -----------------------------------------------------------------------------------------

loc_816E:
	subq.w	#1,$26(a0)
	bcc.w	loc_8188
	move.w	#0,$26(a0)
	move.b	$2A(a0),d0
	addq.b	#1,d0
	or.b	d0,byte_FF1965

loc_8188:
	bsr.w	sub_7282
	move.w	#$8017,d0
	jsr	(DummiedFunc).l
	bcc.w	loc_819E
	move.b	#7,d0

loc_819E:
	swap	d0
	move.w	#$F00,d0
	move.b	$2A(a0),d0
	jmp	QueuePlaneCmd
; -----------------------------------------------------------------------------------------

loc_81AE:
	move.b	$2A(a0),d0
	addq.b	#1,d0
	not.b	d0
	and.b	d0,byte_FF1965
	move.b	#$41,d0
	jsr	PlaySound_ChkSamp
	bclr	#0,7(a0)
	bsr.w	ActorBookmark
	move.w	#$8400,d0
	move.b	$2A(a0),d0
	swap	d0
	move.b	#5,d0
	jsr	QueuePlaneCmd
	bsr.w	sub_8210
	bsr.w	ResetPuyoField
	DISABLE_INTS
	bsr.w	sub_5782
	ENABLE_INTS
	bra.w	loc_3D44
; -----------------------------------------------------------------------------------------

loc_81FC:
	clr.b	(bytecode_disabled).l
	bclr	#0,7(a0)
	bsr.w	ActorBookmark
	bra.w	ActorDeleteSelf

; =============== S U B	R O U T	I N E =====================================================


sub_8210:
	clr.b	8(a0)
	clr.b	$2B(a0)
	clr.l	$A(a0)
	clr.l	$E(a0)
	clr.w	$16(a0)
	clr.w	$18(a0)
	movea.l	$32(a0),a1
	move.w	#$FFFF,$20(a1)
	clr.w	$1E(a1)
	clr.b	7(a1)
	move.w	#4,d2

loc_823E:
	bsr.w	GetNextPuyoColors
	move.b	d0,$26(a1,d2.w)
	move.b	d1,$27(a1,d2.w)
	subq.w	#2,d2
	bcc.s	loc_823E
	rts
; End of function sub_8210


; =============== S U B	R O U T	I N E =====================================================


sub_8250:
	movem.l	d0-d2,-(sp)
	move.w	#$B,d0
	clr.w	d1
	clr.b	d2

loc_825C:
	move.b	(a2,d1.w),d2
	beq.w	loc_8270
	andi.b	#$70,d2
	cmpi.b	#$60,d2
	bne.w	loc_8286

loc_8270:
	addi.w	#$C,d1
	dbf	d0,loc_825C
	move.w	#5,d0
	jsr	RandomBound
	move.b	unk_8292(pc,d0.w),d2

loc_8286:
	lsr.b	#4,d2
	move.b	d2,8(a1)
	movem.l	(sp)+,d0-d2
	rts
; End of function sub_8250

; -----------------------------------------------------------------------------------------
unk_8292
	dc.b	0
	dc.b	$10
	dc.b	$30
	dc.b	$40
	dc.b	$50
	dc.b	$20

; =============== S U B	R O U T	I N E =====================================================


sub_8298:
	lea	(sub_82E0).l,a1
	bsr.w	FindActorSlot
	bcs.w	locret_82DE
	move.l	a0,$2E(a1)
	move.b	$2A(a0),$2A(a1)
	move.b	#$80,6(a1)
	move.b	#$29,8(a1)
	bsr.w	GetPuyoFieldTopLeft
	addi.w	#$30,d0
	move.w	d0,$A(a1)
	addi.w	#$40,d1
	move.w	d1,$20(a1)
	move.w	#$168,$E(a1)
	move.l	#unk_8308,$32(a1)

locret_82DE:
	rts
; End of function sub_8298


; =============== S U B	R O U T	I N E =====================================================


sub_82E0:
	movem.l	$2E(a0),a1
	btst	#0,7(a1)
	beq.w	ActorDeleteSelf
	bsr.w	ActorAnimate
	move.w	$20(a0),d0
	cmp.w	$E(a0),d0
	bcs.w	loc_8302
	rts
; -----------------------------------------------------------------------------------------

loc_8302:
	subq.w	#1,$E(a0)
	rts
; End of function sub_82E0

; -----------------------------------------------------------------------------------------
unk_8308
	dc.b	$40
	dc.b	0
	dc.b	1
	dc.b	1
	dc.b	2
	dc.b	2
	dc.b	1
	dc.b	1
	dc.b	$20
	dc.b	0
	dc.b	1
	dc.b	1
	dc.b	2
	dc.b	2
	dc.b	1
	dc.b	1
	dc.b	0
	dc.b	0
	dc.b	1
	dc.b	1
	dc.b	2
	dc.b	2
	dc.b	1
	dc.b	1
	dc.b	$10
	dc.b	0
	dc.b	1
	dc.b	1
	dc.b	2
	dc.b	2
	dc.b	1
	dc.b	1
	dc.b	$60
	dc.b	0
	dc.b	1
	dc.b	1
	dc.b	2
	dc.b	2
	dc.b	1
	dc.b	1
	dc.b	0
	dc.b	0
	dc.b	1
	dc.b	1
	dc.b	2
	dc.b	2
	dc.b	1
	dc.b	1
	dc.b	$FF
	dc.b	0
	dc.l	unk_8308
; -----------------------------------------------------------------------------------------

loc_833E:
	bsr.w	ActorAnimate
	bcs.w	loc_836E
	move.b	9(a0),d0
	cmp.b	8(a0),d0
	bne.w	loc_8354
	rts
; -----------------------------------------------------------------------------------------

loc_8354:
	move.b	d0,8(a0)
	movea.l	$2E(a0),a1
	swap	d0
	move.w	#$8400,d0
	move.b	$2A(a1),d0
	swap	d0
	jmp	QueuePlaneCmd
; -----------------------------------------------------------------------------------------

loc_836E:
	movea.l	$2E(a0),a1
	subq.w	#1,$26(a1)
	bra.w	ActorDeleteSelf
; -----------------------------------------------------------------------------------------
unk_837A
	dc.b	6
	dc.b	0
	dc.b	5
	dc.b	1
	dc.b	4
	dc.b	2
	dc.b	3
	dc.b	3
	dc.b	2
	dc.b	4
	dc.b	$FE
	dc.b	0
; -----------------------------------------------------------------------------------------

loc_8386:
	bsr.w	ActorBookmark
	move.l	$E(a0),d0
	add.l	$16(a0),d0
	move.l	d0,$E(a0)
	swap	d0
	cmpi.w	#$D0,d0
	bcc.w	loc_83BA
	bsr.w	ActorMove
	move.w	$E(a0),d0
	lea	(vscroll_buffer).l,a2
	move.w	$32(a0),d1
	neg.w	d0
	move.w	d0,(a2,d1.w)
	rts
; -----------------------------------------------------------------------------------------

loc_83BA:
	bsr.w	sub_83D2
	bcc.w	loc_83C6
	bsr.w	sub_83F6

loc_83C6:
	movea.l	$2E(a0),a1
	subq.w	#1,$26(a1)
	bra.w	ActorDeleteSelf

; =============== S U B	R O U T	I N E =====================================================


sub_83D2:
	movea.l	$2E(a0),a1
	clr.w	d0
	move.b	stage_mode,d0
	lsl.b	#1,d0
	or.b	$2A(a1),d0
	move.b	unk_83EC(pc,d0.w),d1
	subq.b	#1,d1
	rts
; End of function sub_83D2

; -----------------------------------------------------------------------------------------
unk_83EC
	dc.b	0
	dc.b	$FF
	dc.b	$FF
	dc.b	$FF
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0

; =============== S U B	R O U T	I N E =====================================================


sub_83F6:
	btst	#1,stage_mode
	beq.w	*+4

loc_8402:
	move.w	#3,d0

loc_8406:
	lea	(loc_8490).l,a1
	bsr.w	FindActorSlotQuick
	bcc.w	loc_8416
	rts
; -----------------------------------------------------------------------------------------

loc_8416:
	move.w	#$FFFF,$20(a1)
	move.w	$1A(a0),$1C(a1)
	move.w	#$FFFD,$16(a1)
	move.b	8(a0),8(a1)
	move.w	#$15F,$E(a1)
	move.b	unk_848C(pc,d0.w),9(a1)
	move.w	$A(a0),$1E(a1)
	move.b	$B(a0),$36(a1)
	move.w	d0,d1
	lsl.w	#2,d1
	addq.w	#1,d1
	move.w	d1,$26(a1)
	dbf	d0,loc_8406
	movea.l	a1,a2
	lea	(loc_84D6).l,a1
	bsr.w	FindActorSlotQuick
	bcc.w	loc_8466
	rts
; -----------------------------------------------------------------------------------------

loc_8466:
	move.b	#$FF,7(a2)
	move.l	a2,$2E(a1)
	move.b	#$80,6(a1)
	move.b	#6,8(a1)
	move.b	#$11,9(a1)
	move.l	#unk_84F4,$32(a1)
	rts
; End of function sub_83F6

; -----------------------------------------------------------------------------------------
unk_848C
	dc.b	8
	dc.b	4
	dc.b	5
	dc.b	6
; -----------------------------------------------------------------------------------------

loc_8490:
	subq.w	#1,$26(a0)
	beq.w	loc_849A
	rts
; -----------------------------------------------------------------------------------------

loc_849A:
	move.b	#$85,6(a0)
	bsr.w	ActorBookmark
	bsr.w	ActorMove
	bcs.w	loc_84CA
	move.b	$36(a0),d0
	move.w	#$1000,d1
	jsr	(Sin).l
	swap	d2
	add.w	$1E(a0),d2
	move.w	d2,$A(a0)
	addq.b	#5,$36(a0)
	rts
; -----------------------------------------------------------------------------------------

loc_84CA:
	clr.b	7(a0)
	bsr.w	ActorBookmark
	bra.w	ActorDeleteSelf
; -----------------------------------------------------------------------------------------

loc_84D6:
	movea.l	$2E(a0),a1
	tst.b	7(a1)
	beq.w	ActorDeleteSelf
	bsr.w	ActorAnimate
	move.w	$A(a1),$A(a0)
	move.w	$E(a1),$E(a0)
	rts
; -----------------------------------------------------------------------------------------
unk_84F4
	dc.b	3
	dc.b	$11
	dc.b	1
	dc.b	$12
	dc.b	2
	dc.b	$13
	dc.b	1
	dc.b	$12
	dc.b	$FF
	dc.b	0
	dc.l	unk_84F4

; -----------------------------------------------------------------------------------------
; Initialize sound
; -----------------------------------------------------------------------------------------

InitSound:
	jsr	LoadCubeDriver
	jsr	InitSoundQueue
	move.b	d0,sound_playing
	rts

; -----------------------------------------------------------------------------------------
; Load the Cube sound driver
; -----------------------------------------------------------------------------------------

LoadCubeDriver:
	move.w	#$100,Z80_BUS
	move.w	#0,Z80_RESET
	rept	14
	nop
	endr
	move.w	#$100,Z80_RESET

.WaitStop:
	btst	#0,Z80_BUS
	bne.s	.WaitStop

	Z80_STOP
	move.w	#$100,Z80_RESET
	rept	14
	nop
	endr

	lea	CubeDriver,a0
	lea	ZRAM_START,a1
	move.w	#CubeDriver_End-CubeDriver-1,d7

.LoadDriver:
	move.b	(a0)+,(a1)+
	dbf	d7,.LoadDriver

	move.w	#0,Z80_RESET
	Z80_START
	move.w	#$100,Z80_RESET
	rept	14
	nop
	endr

	rts

; -----------------------------------------------------------------------------------------
; Update sound
; -----------------------------------------------------------------------------------------

UpdateSound:
	moveq	#0,d0
	move.b	(sound_playing).l,d0
	bne.s	.DoPlay
	jsr	(ProcessSoundQueue).l
	move.b	d0,(sound_playing).l
	beq.s	.End

.DoPlay:
	move.w	#$100,Z80_BUS

.StopZ80:
	nop
	nop
	nop
	nop
	btst	#0,Z80_BUS
	bne.s	.StopZ80
	move.b	ZRAM_START+$1FFF,d1
	bne.s	.Active
	move.b	d0,ZRAM_START+$1FFF
	move.b	unk_8660(pc,d0.w),d1
	beq.s	.NoSound
	move.b	d1,ZRAM_START+$1FFE

.NoSound:
	move.b	#0,(sound_playing).l

.Active:
	move.w	#0,Z80_BUS

.StartZ80:
	nop
	nop
	nop
	nop
	btst	#0,Z80_BUS
	beq.s	.StartZ80

.End:
	rts
; End of function UpdateSound

; -----------------------------------------------------------------------------------------
unk_8660
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	$97
	dc.b	$97
	dc.b	$97
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0

; -----------------------------------------------------------------------------------------
; Play a sound
; -----------------------------------------------------------------------------------------
; PARAMETERS:
;	d0.b	- Sound ID
; -----------------------------------------------------------------------------------------

JmpTo_PlaySound:
	jmp	PlaySound

; -----------------------------------------------------------------------------------------
; Play a sound (checks if PCM is enabled)
; -----------------------------------------------------------------------------------------
; PARAMETERS:
;	d0.b	- Sound ID
; -----------------------------------------------------------------------------------------

PlaySound_ChkSamp:
	tst.b	d0
	bpl.s	JmpTo_PlaySound_2
	tst.b	disable_samples
	beq.s	JmpTo_PlaySound_2

	move.b	d0,d1
	andi.w	#$7F,d1
	move.b	SamplesAllowed(pc,d1.w),d1
	beq.s	PlaySound_End

JmpTo_PlaySound_2:
	jmp	PlaySound

PlaySound_End:
	rts

; -----------------------------------------------------------------------------------------

SamplesAllowed:
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	1
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	1
	dc.b	1
	dc.b	0
	dc.b	0
	dc.b	1
	dc.b	1
	dc.b	1
	dc.b	1
	dc.b	1
	dc.b	1
	dc.b	1
	dc.b	1
	dc.b	1
	dc.b	1
	dc.b	1
	dc.b	1
	dc.b	1
	dc.b	1
	dc.b	1
	dc.b	1
	dc.b	1

; -----------------------------------------------------------------------------------------
; Fade out sound
; -----------------------------------------------------------------------------------------

FadeSound:
	move.b	#$FD,sound_playing
	rts

; -----------------------------------------------------------------------------------------
; Stop all sound
; -----------------------------------------------------------------------------------------

StopSound:
	movem.l	d0,-(sp)

	move.b	#$6F,d0
	jsr	PlaySound
	move.b	#$FE,d0
	jsr	PlaySound

	movem.l	(sp)+,d0
	rts

; -----------------------------------------------------------------------------------------
; Pause sound
; -----------------------------------------------------------------------------------------

PauseSound:
	move.b	#$FF,sound_playing
	rts

; -----------------------------------------------------------------------------------------
; Unpause sound
; -----------------------------------------------------------------------------------------

UnpauseSound:
	move.b	#$FF,sound_playing
	rts

; -----------------------------------------------------------------------------------------
; Stop sound effects
; -----------------------------------------------------------------------------------------

StopSFX:
	move.b	#$6F,sound_playing
	rts

; -----------------------------------------------------------------------------------------

	rts

; -----------------------------------------------------------------------------------------
; Play a sound
; -----------------------------------------------------------------------------------------
; PARAMETERS:
;	d0.b	- Sound ID
; -----------------------------------------------------------------------------------------

PlaySound:
	movem.l	d0-d1/a0,-(sp)
	
	tst.b	sound_queue_open
	beq.s	.End

	moveq	#0,d1
	lea	sound_queue,a0
	move.b	sound_queue_tail,d1
	move.b	d0,(a0,d1.w)

	addq.b	#1,d1
	move.b	d1,sound_queue_tail
	cmp.b	sound_queue_current,d1
	bne.s	.NotFull
	move.b	#0,sound_queue_open

.NotFull:
	move.b	#-1,sounds_queued

.End:
	movem.l	(sp)+,d0-d1/a0
	rts

; -----------------------------------------------------------------------------------------
; Process the sound queue
; -----------------------------------------------------------------------------------------
; RETURNS:
;	d0.b	- Sound ID
; -----------------------------------------------------------------------------------------

ProcessSoundQueue:
	movem.l	d1/a0,-(sp)
	
	tst.b	sounds_queued
	beq.s	.End

	moveq	#0,d1
	lea	sound_queue,a0
	move.b	sound_queue_current,d1
	move.b	(a0,d1.w),d0

	addq.b	#1,d1
	move.b	d1,sound_queue_current
	cmp.b	sound_queue_tail,d1
	bne.s	.NotEmpty
	move.b	#0,sounds_queued

.NotEmpty:
	move.b	#-1,sound_queue_open

.End:
	movem.l	(sp)+,d1/a0
	rts

; -----------------------------------------------------------------------------------------
; Initialize the sound queue
; -----------------------------------------------------------------------------------------

InitSoundQueue:
	moveq	#0,d0
	move.b	d0,sound_queue_tail
	move.b	d0,sound_queue_current
	move.b	#-1,sound_queue_open
	move.b	d0,sounds_queued

	lea	sound_queue,a0
	moveq	#$100/$10-1,d7

.Clear:
	move.l	d0,(a0)+
	move.l	d0,(a0)+
	move.l	d0,(a0)+
	move.l	d0,(a0)+
	dbf	d7,.Clear

	rts

; =============== S U B	R O U T	I N E =====================================================


sub_88A8:
	move.b	stage_mode,d0
	eori.b	#2,d0
	or.b	$2B(a0),d0
	bne.w	locret_890C
	movea.l	$32(a0),a1
	tst.b	7(a1)
	bmi.w	locret_890C
	cmpi.w	#2,$1E(a1)
	bcs.w	locret_890C
	jsr	(GetPuyoField).l
	movea.l	a2,a3
	adda.l	#$294,a2
	adda.l	#$29E,a3
	cmpi.w	#$36,8(a2)
	bcc.w	loc_890E
	move.w	#$A,d0
	clr.b	d1

loc_88F4:
	cmpi.b	#3,(a3,d0.w)
	bcc.w	loc_8900
	addq.b	#1,d1

loc_8900:
	subq.w	#2,d0
	bcc.s	loc_88F4
	cmpi.b	#2,d1
	bcc.w	loc_890E

locret_890C:
	rts
; -----------------------------------------------------------------------------------------

loc_890E:
	tst.b	7(a1)
	bne.w	loc_8924
	jsr	Random
	andi.b	#1,d0
	move.b	d0,7(a1)

loc_8924:
	move.b	#$19,d0
	addi.b	#$41,7(a1)
	btst	#0,7(a1)
	beq.w	loc_893C
	move.b	#$1A,d0

loc_893C:
	move.b	d0,$28(a1)
	move.b	d0,$29(a1)
	clr.w	$1E(a1)
	rts
; End of function sub_88A8


; =============== S U B	R O U T	I N E =====================================================


sub_894A:
	movea.l	$2E(a0),a1
	movem.l	a0,-(sp)
	movea.l	a1,a0
	jsr	(AddComboDraw).l
	movem.l	(sp)+,a0
	rts
; End of function sub_894A

; -----------------------------------------------------------------------------------------
; START	OF FUNCTION CHUNK FOR SpawnFallingPuyos

SpawnCarbuncle:
	lea	(loc_89D8).l,a1
	bsr.w	FindActorSlot
	move.b	0(a0),0(a1)
	move.l	a0,$2E(a1)
	move.b	$2A(a0),$2A(a1)
	move.b	#$19,8(a1)
	move.b	#$45,9(a1)
	move.w	#2,$1A(a1)
	move.w	#1,$1C(a1)
	move.w	#0,$1E(a1)
	move.w	#0,$20(a1)
	move.l	#unk_89AE,$32(a1)
	ori.b	#1,7(a0)
	rts
; END OF FUNCTION CHUNK	FOR SpawnFallingPuyos
; -----------------------------------------------------------------------------------------
unk_89AE
	dc.b	4
	dc.b	0
	dc.b	5
	dc.b	1
	dc.b	4
	dc.b	0
	dc.b	5
	dc.b	2
	dc.b	$FF
	dc.b	0
	dc.l	unk_89AE
unk_89BC
	dc.b	4
	dc.b	3
	dc.b	5
	dc.b	4
	dc.b	4
	dc.b	3
	dc.b	5
	dc.b	5
	dc.b	$FF
	dc.b	0
	dc.l	unk_89BC
unk_89CA
	dc.b	4
	dc.b	6
	dc.b	5
	dc.b	7
	dc.b	4
	dc.b	6
	dc.b	5
	dc.b	8
	dc.b	$FF
	dc.b	0
	dc.l	unk_89CA
; -----------------------------------------------------------------------------------------

loc_89D8:
	bsr.w	sub_543C
	move.b	#$80,6(a0)
	tst.b	(word_FF19A8).l
	bne.w	loc_8A1E
	move.b	$2A(a0),d0
	ori.b	#$80,d0
	move.b	d0,(word_FF19A8).l
	move.b	#$FF,(word_FF19A8+1).l
	bsr.w	ActorBookmark
	tst.b	(word_FF19A8+1).l
	beq.w	loc_8A12
	rts
; -----------------------------------------------------------------------------------------

loc_8A12:
	move.w	#$10,d0
	bsr.w	ActorBookmark_SetDelay
	bsr.w	ActorBookmark

loc_8A1E:
	bsr.w	ActorBookmark
	movea.l	$2E(a0),a1
	btst	#0,7(a1)
	beq.w	loc_4F3A
	bsr.w	ActorAnimate
	cmpi.w	#3,$1C(a0)
	bcc.w	loc_8A44
	move.b	#$45,9(a0)

loc_8A44:
	bsr.w	sub_5060
	bsr.w	sub_50DA
	bcs.w	loc_8A54
	bra.w	sub_543C
; -----------------------------------------------------------------------------------------

loc_8A54:
	move.b	#$45,d0
	bsr.w	PlaySound_ChkSamp
	bsr.w	GetPuyoField
	move.w	$1A(a0),d0
	addq.w	#1,$1C(a0)
	move.w	$1C(a0),d1
	cmpi.w	#$E,d1
	bcc.w	loc_8B64
	mulu.w	#6,d1
	add.w	d1,d0
	lsl.w	#1,d0
	move.w	d0,$26(a0)
	move.b	(a2,d0.w),d1
	andi.b	#$F0,d1
	cmpi.b	#$E0,d1
	bcs.w	loc_8A94
	move.b	#$80,d1

loc_8A94:
	move.b	d1,$36(a0)
	move.w	#1,$16(a0)

loc_8A9E:
	move.w	#$10,$28(a0)
	bsr.w	ActorBookmark
	move.b	$29(a0),d0
	andi.b	#3,d0
	bne.w	loc_8ABC
	move.b	#$4B,d0
	bsr.w	PlaySound_ChkSamp

loc_8ABC:
	bsr.w	ActorAnimate
	move.w	$12(a0),d0
	add.w	d0,$A(a0)
	move.w	$16(a0),d0
	add.w	d0,$E(a0)
	subq.w	#1,$28(a0)
	beq.w	loc_8ADA
	rts
; -----------------------------------------------------------------------------------------

loc_8ADA:
	bsr.w	GetPuyoField
	move.w	$26(a0),d0
	move.b	$36(a0),(a2,d0.w)
	DISABLE_INTS
	bsr.w	sub_5782
	ENABLE_INTS
	bsr.w	sub_8C06
	bcc.s	loc_8A9E
	movea.l	$2E(a0),a1
	bclr	#0,7(a1)
	move.b	#$AF,6(a0)
	move.l	#unk_8B56,$32(a0)
	move.w	#3,$12(a0)
	move.w	#0,$16(a0)
	move.w	#$1A00,$1A(a0)
	move.w	#$800,$1C(a0)
	move.w	$A(a0),$1E(a0)
	move.w	#0,$20(a0)
	tst.b	$2A(a0)
	beq.w	loc_8B44
	move.w	#$FFFE,$12(a0)

loc_8B44:
	bsr.w	ActorBookmark
	bsr.w	ActorAnimate
	bsr.w	ActorMove
	bcs.w	loc_8BE8
	rts
; -----------------------------------------------------------------------------------------
unk_8B56
	dc.b	1
	dc.b	$D
	dc.b	1
	dc.b	$24
	dc.b	1
	dc.b	$26
	dc.b	1
	dc.b	$25
	dc.b	$FF
	dc.b	0
	dc.l	unk_8B56
; -----------------------------------------------------------------------------------------

loc_8B64:
	move.b	#$82,6(a0)
	move.w	#$FFFF,$12(a0)
	move.l	#unk_8BDC,$32(a0)
	tst.b	$2A(a0)
	beq.w	loc_8B8E
	move.w	#1,$12(a0)
	move.l	#unk_8BD0,$32(a0)

loc_8B8E:
	movea.l	$2E(a0),a1
	bclr	#0,7(a1)
	move.l	#$2710,d0
	bsr.w	sub_894A
	bsr.w	ActorBookmark
	bsr.w	ActorAnimate
	cmpi.b	#$43,9(a0)
	bcc.w	loc_8BB6
	rts
; -----------------------------------------------------------------------------------------

loc_8BB6:
	move.w	$12(a0),d0
	add.w	d0,$A(a0)
	move.w	$A(a0),d0
	subi.w	#$78,d0
	cmpi.w	#$150,d0
	bcc.w	loc_8BE8
	rts
; -----------------------------------------------------------------------------------------
unk_8BD0
	dc.b	8
	dc.b	$37
	dc.b	8
	dc.b	$38
	dc.b	6
	dc.b	$44
	dc.b	$FF
	dc.b	0
	dc.l	unk_8BD0
unk_8BDC
	dc.b	8
	dc.b	$3B
	dc.b	8
	dc.b	$3C
	dc.b	8
	dc.b	$43
	dc.b	$FF
	dc.b	0
	dc.l	unk_8BDC
; -----------------------------------------------------------------------------------------

loc_8BE8:
	move.b	$2A(a0),d0
	ori.b	#$80,d0
	cmp.b	(word_FF19A8).l,d0
	bne.w	ActorDeleteSelf
	move.b	#$FF,(word_FF19A8+1).l
	bra.w	ActorDeleteSelf

; =============== S U B	R O U T	I N E =====================================================


sub_8C06:
	bsr.w	GetPuyoField
	lea	(unk_8CAE).l,a1
	eori.b	#$80,7(a0)
	bsr.w	Random
	andi.w	#1,d0
	bsr.w	sub_8C5C
	bcs.w	loc_8C28
	rts
; -----------------------------------------------------------------------------------------

loc_8C28:
	cmpi.w	#$D,$1C(a0)
	bcc.w	loc_8C56
	addq.w	#1,$1C(a0)
	addi.w	#$C,$26(a0)
	move.w	#0,$12(a0)
	move.w	#1,$16(a0)
	move.l	#unk_89AE,$32(a0)
	andi	#$FFFE,sr
	rts
; End of function sub_8C06

; -----------------------------------------------------------------------------------------
; START	OF FUNCTION CHUNK FOR sub_8C5C

loc_8C56:
	ori	#1,sr
	rts
; END OF FUNCTION CHUNK	FOR sub_8C5C

; =============== S U B	R O U T	I N E =====================================================


sub_8C5C:



	move.w	d0,d1
	mulu.w	#$A,d1
	move.w	$1A(a0),d2
	add.w	(a1,d1.w),d2
	cmpi.w	#6,d2
	bcc.s	loc_8C56
	move.w	$26(a0),d3
	add.w	4(a1,d1.w),d3
	move.b	(a2,d3.w),d4
	bpl.s	loc_8C56
	andi.b	#$F0,d4
	cmp.b	$36(a0),d4
	beq.s	loc_8C56
	move.w	d2,$1A(a0)
	move.w	d3,$26(a0)
	move.w	(a1,d1.w),$12(a0)
	move.w	2(a1,d1.w),$16(a0)
	move.l	6(a1,d1.w),$32(a0)
	andi	#$FFFE,sr
	rts
; End of function sub_8C5C

; -----------------------------------------------------------------------------------------
	ori	#1,sr
	rts
; -----------------------------------------------------------------------------------------
unk_8CAE
	dc.b	$FF
	dc.b	$FF
	dc.b	0
	dc.b	0
	dc.b	$FF
	dc.b	$FE
	dc.l	unk_89BC
	dc.b	0
	dc.b	1
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	2
	dc.l	unk_89CA
; -----------------------------------------------------------------------------------------
; START	OF FUNCTION CHUNK FOR SpawnFallingPuyos

SpawnGiantPuyo:
	lea	(loc_8D18).l,a1
	bsr.w	FindActorSlot
	move.b	0(a0),0(a1)
	move.l	a0,$2E(a1)
	move.b	$2A(a0),$2A(a1)
	move.b	#$1A,8(a1)
	move.b	#3,9(a1)
	move.w	#2,$1A(a1)
	move.w	#1,$1C(a1)
	move.w	#0,$1E(a1)
	move.w	#0,$20(a1)
	move.b	#1,$2B(a1)
	move.l	#unk_8D16,$32(a1)
	ori.b	#1,7(a0)
	rts
; END OF FUNCTION CHUNK	FOR SpawnFallingPuyos
; -----------------------------------------------------------------------------------------
unk_8D16
	dc.b	$FE
	dc.b	0
; -----------------------------------------------------------------------------------------

loc_8D18:
	bsr.w	sub_543C
	addq.w	#8,$A(a0)
	move.b	#$80,6(a0)
	bsr.w	ActorBookmark
	movea.l	$2E(a0),a1
	btst	#0,7(a1)
	beq.w	loc_4F3A
	bsr.w	ActorAnimate
	cmpi.w	#3,$1C(a0)
	bcc.w	loc_8D54
	cmpi.b	#3,9(a0)
	bcc.w	loc_8D54
	addq.b	#3,9(a0)

loc_8D54:
	bsr.w	sub_5060
	bsr.w	sub_50DA
	bcs.w	loc_8D6A
	bsr.w	sub_543C
	addq.w	#8,$A(a0)
	rts
; -----------------------------------------------------------------------------------------

loc_8D6A:
	bsr.w	ActorBookmark
	bsr.w	ActorAnimate
	bcs.w	loc_8D90
	cmpi.w	#3,$1C(a0)
	bcc.w	locret_8D8E
	cmpi.b	#3,9(a0)
	bcc.w	locret_8D8E
	addq.b	#3,9(a0)

locret_8D8E:
	rts
; -----------------------------------------------------------------------------------------

loc_8D90:
	bsr.w	GetPuyoField
	move.w	$1A(a0),d0
	lsl.w	#1,d0
	clr.w	(a2,d0.w)
	clr.w	2(a2,d0.w)
	clr.w	$C(a2,d0.w)
	clr.w	$E(a2,d0.w)
	move.b	#0,9(a0)
	cmpi.w	#$D,$1C(a0)
	bcs.w	loc_8DC8
	move.l	#$2EE0,d0
	bsr.w	sub_894A
	bra.w	loc_8E40
; -----------------------------------------------------------------------------------------

loc_8DC8:
	move.w	$1A(a0),d0
	move.w	$1C(a0),d1
	addq.w	#1,d1
	mulu.w	#6,d1
	add.w	d1,d0
	lsl.w	#1,d0
	move.w	d0,$26(a0)
	move.w	$E(a0),$36(a0)
	clr.w	$1E(a0)
	move.b	#$85,6(a0)
	move.w	#$1A00,$1C(a0)
	move.w	#$FFFF,$20(a0)
	bsr.w	ActorBookmark
	bsr.w	ActorMove
	cmpi.w	#6,$16(a0)
	bcs.w	loc_8E14
	move.l	#$60000,$16(a0)

loc_8E14:
	bsr.w	sub_8EA4
	cmpi.w	#$148,$E(a0)
	bcc.w	loc_8E24
	rts
; -----------------------------------------------------------------------------------------

loc_8E24:
	move.w	#$148,$E(a0)
	move.l	#unk_8E92,$32(a0)
	move.w	#$80,$26(a0)
	move.b	#$49,d0
	bsr.w	PlaySound_ChkSamp

loc_8E40:
	bsr.w	sub_8FDA
	move.b	#$B7,6(a0)
	neg.l	$16(a0)
	move.w	#$3400,$1C(a0)
	move.w	#$FFFF,$20(a0)
	move.w	#$8000,$14(a0)
	tst.b	$2A(a0)
	bne.w	loc_8E6C
	neg.l	$12(a0)

loc_8E6C:
	bsr.w	ActorBookmark
	bsr.w	ActorAnimate
	bsr.w	ActorMove
	cmpi.w	#$170,$E(a0)
	bcc.w	loc_8E84
	rts
; -----------------------------------------------------------------------------------------

loc_8E84:
	movea.l	$2E(a0),a1
	bclr	#0,7(a1)
	bra.w	ActorDeleteSelf
; -----------------------------------------------------------------------------------------
unk_8E92
	dc.b	2
	dc.b	1
	dc.b	1
	dc.b	0
	dc.b	3
	dc.b	2
	dc.b	1
	dc.b	0
	dc.b	3
	dc.b	1
	dc.b	1
	dc.b	0
	dc.b	2
	dc.b	2
	dc.b	1
	dc.b	0
	dc.b	$FE
	dc.b	0

; =============== S U B	R O U T	I N E =====================================================


sub_8EA4:
	move.w	$E(a0),d0
	sub.w	$36(a0),d0
	lsr.w	#4,d0
	cmp.w	$1E(a0),d0
	bne.w	loc_8EB8
	rts
; -----------------------------------------------------------------------------------------

loc_8EB8:
	move.w	d0,$1E(a0)
	bsr.w	GetPuyoField
	move.w	$26(a0),d0
	movem.l	d0,-(sp)
	bsr.w	sub_8EF6
	movem.l	(sp)+,d0
	move.w	#$FF,(a2,d0.w)
	move.w	#$FF,2(a2,d0.w)
	addi.w	#$C,$26(a0)
	DISABLE_INTS
	bsr.w	sub_5782
	ENABLE_INTS
	move.b	#$4A,d0
	bra.w	PlaySound_ChkSamp
; End of function sub_8EA4


; =============== S U B	R O U T	I N E =====================================================


sub_8EF6:
	move.w	#1,d1
	clr.l	d5
	clr.w	d6
	movea.l	$2E(a0),a1
	move.b	$2B(a1),d6
	addq.b	#1,d6
	mulu.w	#$A,d6

loc_8F0C:
	move.b	(a2,d0.w),d2
	bpl.w	loc_8F76
	lsr.b	#4,d2
	andi.b	#7,d2
	cmpi.b	#6,d2
	beq.w	loc_8F76
	move.w	#1,d4

loc_8F26:
	lea	(loc_8F92).l,a1
	bsr.w	FindActorSlotQuick
	bcs.w	loc_8F70
	move.b	0(a0),0(a1)
	move.b	#$83,6(a1)
	move.b	d2,8(a1)
	move.b	#4,9(a1)
	move.w	$A(a0),$A(a1)
	move.w	$E(a0),$E(a1)
	move.w	d1,d3
	eori.b	#1,d3
	lsl.w	#4,d3
	add.w	d3,$A(a1)
	move.w	#8,$28(a1)
	move.l	#unk_8F84,$32(a1)

loc_8F70:
	dbf	d4,loc_8F26
	add.l	d6,d5

loc_8F76:
	addq.w	#2,d0
	dbf	d1,loc_8F0C
	move.l	d5,d0
	bsr.w	sub_894A
	rts
; End of function sub_8EF6

; -----------------------------------------------------------------------------------------
unk_8F84
	dc.b	3
	dc.b	4
	dc.b	1
	dc.b	5
	dc.b	2
	dc.b	6
	dc.b	1
	dc.b	5
	dc.b	$FF
	dc.b	0
	dc.l	unk_8F84
; -----------------------------------------------------------------------------------------

loc_8F92:
	tst.w	$26(a0)
	bne.w	loc_8FCA
	tst.w	$28(a0)
	beq.w	ActorDeleteSelf
	subq.w	#1,$28(a0)
	move.w	$28(a0),d1
	addq.w	#1,d1
	lsl.w	#1,d1
	move.w	d1,$26(a0)
	bsr.w	Random
	move.w	#$200,d1
	bsr.w	Sin
	move.l	d2,$12(a0)
	bsr.w	Cos
	move.l	d2,$16(a0)

loc_8FCA:
	subq.w	#1,$26(a0)
	bsr.w	ActorMove
	bcs.w	ActorDeleteSelf
	bra.w	ActorAnimate

; =============== S U B	R O U T	I N E =====================================================


sub_8FDA:
	bsr.w	GetPuyoField
	move.w	d0,d1
	andi.w	#$7F,d1
	move.w	$1A(a0),d2
	mulu.w	#$C,d2
	move.w	#5,d0

loc_8FF0:
	lea	(loc_9066).l,a1
	bsr.w	FindActorSlot
	bcs.w	loc_9020
	move.b	0(a0),0(a1)
	move.b	#$80,$36(a1)
	move.w	d1,$26(a1)
	move.w	unk_902A(pc,d2.w),d3
	move.w	$16(a0),d4
	lsl.w	#1,d4
	addq.w	#4,d4
	mulu.w	d4,d3
	move.w	d3,$38(a1)

loc_9020:
	addq.w	#4,d1
	addq.w	#2,d2
	dbf	d0,loc_8FF0
	rts
; End of function sub_8FDA

; -----------------------------------------------------------------------------------------
unk_902A
	dc.b	1
	dc.b	0
	dc.b	1
	dc.b	0
	dc.b	0
	dc.b	$80
	dc.b	0
	dc.b	$40
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	$80
	dc.b	1
	dc.b	0
	dc.b	1
	dc.b	0
	dc.b	0
	dc.b	$80
	dc.b	0
	dc.b	$40
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	$40
	dc.b	0
	dc.b	$80
	dc.b	1
	dc.b	0
	dc.b	1
	dc.b	0
	dc.b	0
	dc.b	$80
	dc.b	0
	dc.b	$40
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	$40
	dc.b	0
	dc.b	$80
	dc.b	1
	dc.b	0
	dc.b	1
	dc.b	0
	dc.b	0
	dc.b	$80
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	$40
	dc.b	0
	dc.b	$80
	dc.b	1
	dc.b	0
	dc.b	1
	dc.b	0
; -----------------------------------------------------------------------------------------

loc_9066:
	move.b	$36(a0),d0
	ori.b	#$80,d0
	move.w	$38(a0),d1
	bsr.w	Sin
	swap	d2
	lea	(vscroll_buffer).l,a1
	move.w	$26(a0),d0
	move.w	d2,(a1,d0.w)
	subq.b	#4,$36(a0)
	bcs.w	ActorDeleteSelf
	rts
; -----------------------------------------------------------------------------------------
	move.l	#$800E0000,d0
	jsr	QueuePlaneCmd
	lea	(loc_90B0).l,a1
	jsr	FindActorSlot
	move.w	#$258,$26(a1)
	rts
; -----------------------------------------------------------------------------------------

loc_90B0:
	subq.w	#1,$26(a0)
	bcs.w	loc_90BA
	rts
; -----------------------------------------------------------------------------------------

loc_90BA:
	clr.b	(bytecode_disabled).l
	jmp	(ActorDeleteSelf).l

; -----------------------------------------------------------------------------------------
; Handle pausing
; -----------------------------------------------------------------------------------------

HandlePause:
	moveq	#0,d2					; Get player controller data
	move.b	p1_ctrl+ctlPress,d0
	move.b	p2_ctrl+ctlPress,d1
	tst.b	swap_fields
	beq.w	.CheckMode
	exg	d0,d1

.CheckMode:
	btst	#1,stage_mode				; Are we in exercise mode?
	bne.w	.CheckPause				; If so, branch

	or.b	d1,d0					; If this this not exercise mode
	move.b	d0,d1

	tst.b	p1_pause				; Was the game paused?
	bpl.w	.CheckPause				; If not, branch

	move.b	p1_ctrl+ctlPress,d0			; Only get the controller data for the player
	tst.b	player_paused				; that paused the game
	beq.w	.GotPlayer
	move.b	p2_ctrl+ctlPress,d0

.GotPlayer:
	move.b	d0,d1

.CheckPause:
	lea	p1_pause,a2			; Check player 1 pause
	move.w	#0,d2
	bsr.w	CheckPause

	move.b	d1,d0					; Check player 2 pause
	move.w	#1,d2

; -----------------------------------------------------------------------------------------
; Check if a player is pausing/unpausing
; -----------------------------------------------------------------------------------------
; PARAMETERS:
;	d0.b	- Player's controller data
;	d2.b	- Player pause flag index
;	a2.l	- Pointer to player pause flags
; -----------------------------------------------------------------------------------------

CheckPause:
	tst.b	(a2,d2.w)				; Is pausing enabled for this player?
	beq.w	.End					; If not, branch
	btst	#7,d0					; Did this player press the start button?
	beq.w	.End					; If not, branch

	eori.b	#$80,(a2,d2.w)				; Swap pause flag
	bpl.w	.Unpause				; If we are unpausing, branch

	movem.l	d0,-(sp)				; Determine if the first or second player
	move.b	p1_ctrl+ctlPress,d0			; paused the game
	andi.b	#$80,d0
	eori.b	#$80,d0
	move.b	d0,player_paused
	movem.l	(sp)+,d0

	lea	ActPauseText,a1				; Load pause text actor
	jsr	FindActorSlot
	bcs.w	.Pause
	move.b	d2,aPuyoField(a1)

.Pause:
	DISABLE_INTS					; Pause puyo field
	bsr.w	PausePuyoField
	ENABLE_INTS
	jsr	VSync

	btst	#1,stage_mode				; Is this exercise mode?
	beq.w	.PauseSound				; If not, branch

	move.b	#SFX_GARBAGE_1,d0			; Play pause sound
	jmp	PlaySound_ChkSamp

.Unpause:
	DISABLE_INTS					; Unpause puyo field
	bsr.w	UnpausePuyoField
	ENABLE_INTS
	jsr	VSync

	btst	#1,stage_mode				; Is this exercise mode?
	beq.w	.UnpauseSound				; If not, branch

	move.b	#SFX_GARBAGE_1,d0			; Play unpause sound
	jmp	PlaySound_ChkSamp

.End:
	rts

; -----------------------------------------------------------------------------------------

.PauseSound:
	btst	#$10,d2					; Was sound already paused?
	bne.w	.PauseSoundEnd				; If so, branch

	bset	#$10,d2					; Pause sound
	jsr	PauseSound

.PauseSoundEnd:
	rts

; -----------------------------------------------------------------------------------------

.UnpauseSound:
	btst	#$11,d2					; Was sound already unpaused?
	bne.w	.UnpauseSoundEnd			; If so, branch

	bset	#$11,d2					; Unpause sound
	jsr	UnpauseSound

.UnpauseSoundEnd:
	rts

; -----------------------------------------------------------------------------------------
; Pause a puyo field
; -----------------------------------------------------------------------------------------
; PARAMETERS:
;	d2.b	- Puyo field ID
; -----------------------------------------------------------------------------------------

PausePuyoField:
	movem.l	d1-d2,-(sp)

	bsr.w	GetPuyoFieldGfxBuffer			; Get graphics buffer
	move.w	d0,d5					; Save starting VRAM address
	move.w	#$18-1,d1				; 0x18 rows per field

.SaveRow:
	jsr	SetVRAMRead				; Set VRAM read command for this row
	addi.w	#$80,d5					; Prepare VRAM address for next row
	move.w	#$C-1,d2				; 0xC tiles per row

.SaveTile:
	move.w	VDP_DATA,d3				; Copy field graphics into the graphics buffer
	move.w	d3,(a1)+
	dbf	d2,.SaveTile
	dbf	d1,.SaveRow

	move.w	d0,d5					; Restore starting VRAM address
	move.w	#$18-1,d1				; 0x18 rows per field

.ClearRow:
	jsr	SetVRAMWrite				; Set VRAM write command for this row
	addi.w	#$80,d5					; Prepare VRAM address for next row
	move.w	#$C-1,d2				; 0xC tiles per row

.ClearTile:
	move.w	#$8500,VDP_DATA				; Clear field graphics
	dbf	d2,.ClearTile
	dbf	d1,.ClearRow

	movem.l	(sp)+,d1-d2
	rts

; -----------------------------------------------------------------------------------------
; Unpause a puyo field
; -----------------------------------------------------------------------------------------
; PARAMETERS:
;	d2.b	- Puyo field ID
; -----------------------------------------------------------------------------------------

UnpausePuyoField:
	movem.l	d1-d2,-(sp)

	bsr.w	GetPuyoFieldGfxBuffer			; Get graphics buffer
	move.w	d0,d5					; Save starting VRAM address
	move.w	#$18-1,d1				; 0x18 rows per field

.RestoreRow:
	jsr	SetVRAMWrite				; Set VRAM write command for this row
	addi.w	#$80,d5					; Prepare VRAM address for next row
	move.w	#$C-1,d2				; 0xC tiles per row

.RestoreTile:
	move.w	(a1)+,VDP_DATA				; Restore field graphics from graphics buffer
	dbf	d2,.RestoreTile
	dbf	d1,.RestoreRow

	movem.l	(sp)+,d1-d2
	rts

; -----------------------------------------------------------------------------------------
; Get pointer to the graphics buffer for a puyo field
; -----------------------------------------------------------------------------------------
; PARAMETERS:
;	d2.b	- Puyo field ID
; RETURNS:
;	d0.w	- VRAM address of field
;	a1.l	- Pointer to graphics buffer
; -----------------------------------------------------------------------------------------

GetPuyoFieldGfxBuffer:
	clr.w	d1					; Which field is chosen depends on the field ID
	move.b	swap_fields,d1			; and if controls are swapped
	lsl.b	#1,d1
	or.b	d2,d1
	lsl.b	#3,d1

	movea.l	.Buffers(pc,d1.w),a1			; Get graphics buffer
	move.w	.Buffers+4(pc,d1.w),d0			; Get VRAM address

	rts

; -----------------------------------------------------------------------------------------

.Buffers:
	dc.l	p1_puyo_field_gfx				; Player 1 (not swapped)
	dc.w	$C104
	dc.w	0
	dc.l	p2_puyo_field_gfx				; Player 2 (not swapped)
	dc.w	$C134
	dc.w	0
	dc.l	p1_puyo_field_gfx				; Player 1 (swapped)
	dc.w	$C134
	dc.w	0
	dc.l	p2_puyo_field_gfx				; Player 2 (swapped)
	dc.w	$C104
	dc.w	0

; -----------------------------------------------------------------------------------------
; Pause text actor
; -----------------------------------------------------------------------------------------

paTimer		EQU	$26

; -----------------------------------------------------------------------------------------

ActPauseText:
	bsr.w	GetPuyoFieldTopLeft			; Set text position relative to our field
	addi.w	#$30,d0
	move.w	d0,aX(a0)
	addi.w	#$50,d1
	move.w	d1,aY(a0)

	move.b	aPuyoField(a0),d0			; Set mappings and frame ID
	addi.b	#$20,d0
	move.b	#6,aMappings(a0)
	move.b	d0,aFrame(a0)

	bsr.w	ActorBookmark

; -----------------------------------------------------------------------------------------

ActPauseText_Main:
	clr.w	d0					; Delete ourselves if our field is not paused
	move.b	aPuyoField(a0),d0
	lea	p1_pause,a1
	tst.b	(a1,d0.w)
	bpl.w	ActorDeleteSelf

	addq.b	#1,paTimer(a0)				; Increment and loop timer
	andi.b	#$3F,paTimer(a0)

	move.b	#0,aFlags(a0)			; Make the text invisible
	cmpi.b	#$30,paTimer(a0)			; Should the text be made visible?
	bcc.w	.End					; If not, branch
	move.b	#$80,aFlags(a0)			; Make the text visible

.End:
	rts

; =============== S U B	R O U T	I N E =====================================================


sub_9308:
	move.b	#4,stage
	move.b	#3,opponent
	move.b	(game_matches).l,d0
	bne.w	loc_9324
	addq.b	#1,d0

loc_9324:
	move.b	d0,(byte_FF012A).l
	move.b	d0,(byte_FF012B).l
	rts
; End of function sub_9308


; =============== S U B	R O U T	I N E =====================================================


sub_9332:
	cmpi.b	#2,stage_mode
	bne.w	locret_9374
	tst.w	$16(a0)
	beq.w	locret_9374
	bsr.w	GetPuyoField
	adda.l	#$294,a2
	tst.w	8(a2)
	bne.w	locret_9374
	move.b	#SFX_PUYO_POP_1,d0
	bsr.w	PlaySound_ChkSamp
	clr.l	d0
	move.b	$2B(a0),d0
	addq.b	#1,d0
	mulu.w	#$1F4,d0
	addi.w	#$1F40,d0
	bsr.w	AddComboDraw

locret_9374:
	rts
; End of function sub_9332


; =============== S U B	R O U T	I N E =====================================================


DrawExerciseGreenPuyo:
	DISABLE_INTS

	move.w	#$C726,d5
	jsr	SetVRAMWrite
	addi.w	#$80,d5

	move.w	#$C1FC,VDP_DATA
	move.w	#$C1FE,VDP_DATA

	jsr	SetVRAMWrite

	move.w	#$C1FD,VDP_DATA
	move.w	#$C1FF,VDP_DATA

	ENABLE_INTS
	rts
; End of function DrawExerciseGreenPuyo


; =============== S U B	R O U T	I N E =====================================================


sub_93B4:
	clr.l	d0
	move.b	(p1_win_count).l,d0
	divu.w	#$14,d0
	move.w	#$C61E,d5
	lea	(unk_947C).l,a1
	bsr.w	sub_943E
	swap	d0
	move.w	#$282,d4
	move.w	#$C91E,d5
	bsr.w	sub_9406
	clr.l	d0
	move.b	(p2_win_count).l,d0
	divu.w	#$14,d0
	move.w	#$C628,d5
	lea	(unk_94AE).l,a1
	bsr.w	sub_943E
	swap	d0
	move.w	#$27E,d4
	move.w	#$C930,d5
	bsr.w	sub_9406
	rts
; End of function sub_93B4


; =============== S U B	R O U T	I N E =====================================================


sub_9406:
	subq.w	#1,d0
	bcs.w	locret_943C
	move.w	#$832A,d6
	clr.b	d2

loc_9412:
	DISABLE_INTS
	jsr	SetVRAMWrite
	subi.w	#$80,d5
	move.w	d6,VDP_DATA
	ENABLE_INTS
	addq.b	#1,d2
	cmpi.b	#5,d2
	bcs.w	loc_9438
	add.w	d4,d5
	clr.b	d2

loc_9438:
	dbf	d0,loc_9412

locret_943C:
	rts
; End of function sub_9406


; =============== S U B	R O U T	I N E =====================================================


sub_943E:
	DISABLE_INTS
	movem.l	d0,-(sp)
	mulu.w	#$A,d0
	adda.w	d0,a1
	move.w	#1,d0
	move.w	#$8000,d6

loc_9454:
	jsr	SetVRAMWrite
	addi.w	#$80,d5
	move.w	#4,d1

loc_9462:
	move.b	(a1)+,d6
	move.w	d6,VDP_DATA
	dbf	d1,loc_9462
	dbf	d0,loc_9454
	ENABLE_INTS
	movem.l	(sp)+,d0
	rts
; End of function sub_943E

; -----------------------------------------------------------------------------------------
unk_947C
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	$EF
	dc.b	$F0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	$F1
	dc.b	$F2
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	$F3
	dc.b	$F4
	dc.b	$F5
	dc.b	0
	dc.b	0
	dc.b	$F6
	dc.b	$F7
	dc.b	$F8
	dc.b	0
	dc.b	0
	dc.b	$F3
	dc.b	$F9
	dc.b	$FA
	dc.b	$F0
	dc.b	0
	dc.b	$F6
	dc.b	$FB
	dc.b	$FC
	dc.b	$FD
	dc.b	0
	dc.b	$F3
	dc.b	$F9
	dc.b	$F9
	dc.b	$FA
	dc.b	$F0
	dc.b	$F6
	dc.b	$FB
	dc.b	$FB
	dc.b	$FE
	dc.b	$FF
unk_94AE
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	$EF
	dc.b	$F0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	$F1
	dc.b	$F2
	dc.b	0
	dc.b	0
	dc.b	$F3
	dc.b	$F4
	dc.b	$F5
	dc.b	0
	dc.b	0
	dc.b	$F6
	dc.b	$F7
	dc.b	$F8
	dc.b	0
	dc.b	$F3
	dc.b	$F9
	dc.b	$FA
	dc.b	$F0
	dc.b	0
	dc.b	$F6
	dc.b	$FB
	dc.b	$FC
	dc.b	$FD
	dc.b	$F3
	dc.b	$F9
	dc.b	$F9
	dc.b	$FA
	dc.b	$F0
	dc.b	$F6
	dc.b	$FB
	dc.b	$FB
	dc.b	$FE
	dc.b	$FF

; =============== S U B	R O U T	I N E =====================================================


DrawBlockCount:
	cmpi.b	#2,stage_mode
	beq.w	loc_94EE
	rts
; -----------------------------------------------------------------------------------------

loc_94EE:
	move.w	#$9300,d0
	move.b	$2A(a0),d0
	swap	d0
	move.w	$16(a0),d0
	jmp	QueuePlaneCmd
; End of function DrawBlockCount


; =============== S U B	R O U T	I N E =====================================================


DrawLevel:
	cmpi.b	#2,stage_mode
	beq.w	loc_9510
	rts
; -----------------------------------------------------------------------------------------

loc_9510:
	lea	(sub_9572).l,a1
	jsr	FindActorSlot
	bcc.w	loc_9522
	rts
; -----------------------------------------------------------------------------------------

loc_9522:
	move.w	#$80,$12(a1)
	move.w	#$8500,$E(a1)
	move.w	#$C620,$A(a1)
	tst.b	$2A(a0)
	beq.w	loc_9548
	move.w	#$A500,$E(a1)
	move.w	#$C62C,$A(a1)

loc_9548:
	clr.l	d0
	move.b	$2B(a0),d0
	addq.b	#1,d0
	divu.w	#$A,d0
	tst.b	d0
	beq.w	loc_955E
	addq.b	#1,d0
	lsl.b	#1,d0

loc_955E:
	move.b	d0,$17(a1)
	swap	d0
	addq.b	#1,d0
	lsl.b	#1,d0
	move.b	d0,$F(a1)
	move.w	d1,$26(a1)
	rts
; End of function DrawLevel


; =============== S U B	R O U T	I N E =====================================================


sub_9572:
	lea	(dword_95AC).l,a1
	tst.w	$26(a0)
	beq.w	loc_9590
	btst	#2,$27(a0)
	bne.w	loc_9590
	lea	(dword_95A8).l,a1

loc_9590:
	bsr.w	sub_9728
	subq.w	#1,$26(a0)
	beq.w	loc_95A2
	bcs.w	loc_95A2
	rts
; -----------------------------------------------------------------------------------------

loc_95A2:
	jmp	(ActorDeleteSelf).l
; End of function sub_9572

; -----------------------------------------------------------------------------------------
dword_95A8
	dc.l	$1FEFF
dword_95AC
	dc.l	$10000

; =============== S U B	R O U T	I N E =====================================================


LoadVSCountdown:
	lea	(ActVSCountdown).l,a1
	jsr	FindActorSlot
	bcc.w	loc_95C2
	rts
; -----------------------------------------------------------------------------------------

loc_95C2:
	move.l	a0,$2E(a1)
	move.w	d4,$12(a1)
	move.w	d6,$E(a1)
	move.w	d5,$A(a1)
	rts
; End of function LoadVSCountdown

; -----------------------------------------------------------------------------------------
	lea	(ActVSCountdown).l,a1
	jsr	FindActorSlot
	bcc.w	loc_95E6
	rts
; -----------------------------------------------------------------------------------------

loc_95E6:
	move.l	a0,$2E(a1)
	move.w	d4,$12(a1)
	move.w	d6,$E(a1)
	move.w	d5,$A(a1)
	move.b	#$FF,7(a1)
	rts
; -----------------------------------------------------------------------------------------

ActVSCountdown:
	movea.l	$2E(a0),a1
	move.w	$28(a1),d0
	beq.w	loc_964C
	andi.b	#$3F,d0
	beq.w	loc_9614
	rts
; -----------------------------------------------------------------------------------------

loc_9614:
	clr.l	d0
	move.w	$28(a1),d0
	lsr.w	#6,d0
	divu.w	#$A,d0
	tst.b	d0
	beq.w	loc_962A
	addq.b	#1,d0
	lsl.b	#1,d0

loc_962A:
	move.b	d0,$17(a0)
	swap	d0
	addq.b	#1,d0
	lsl.b	#1,d0
	move.b	d0,$F(a0)
	lea	(byte_965C).l,a1
	bsr.w	sub_9728
	move.b	#$69,d0
	jmp	PlaySound_ChkSamp
; -----------------------------------------------------------------------------------------

loc_964C:
	lea	(byte_9664).l,a1
	bsr.w	sub_9728
	jmp	(ActorDeleteSelf).l
; -----------------------------------------------------------------------------------------
byte_965C:
	dc.w	6-1
	STAGE_TEXT 0, "TIME"
	dc.b	$FE, $FF
byte_9664:
	dc.w	6-1
	STAGE_TEXT 0, "      "
; -----------------------------------------------------------------------------------------
	move.w	#$100,d1
	move.w	#$8500,d6
	lea	(loc_96C4).l,a1
	jsr	FindActorSlot
	bcc.w	loc_9686
	rts
; -----------------------------------------------------------------------------------------

loc_9686:
	move.w	d1,$12(a1)
	move.w	d6,$E(a1)
	move.w	d5,$A(a1)
	clr.l	d0
	move.b	stage,d0
	cmpi.b	#3,d0
	bcs.w	loc_96A4
	subq.b	#3,d0

loc_96A4:
	addq.b	#1,d0
	divu.w	#$A,d0
	tst.b	d0
	beq.w	loc_96B4
	addq.b	#1,d0
	lsl.b	#1,d0

loc_96B4:
	move.b	d0,$17(a1)
	swap	d0
	addq.b	#1,d0
	lsl.b	#1,d0
	move.b	d0,$F(a1)
	rts
; -----------------------------------------------------------------------------------------

loc_96C4:
	cmpi.b	#$F,stage
	beq.w	loc_96F2
	lea	(byte_9706).l,a1
	cmpi.b	#3,stage
	bcc.w	loc_96E8
	lea	(byte_9710).l,a1

loc_96E8:
	bsr.w	sub_9728
	jmp	(ActorDeleteSelf).l
; -----------------------------------------------------------------------------------------

loc_96F2:
	subq.w	#4,$A(a0)
	lea	(byte_971A).l,a1
	bsr.w	sub_9728
	jmp	(ActorDeleteSelf).l
; -----------------------------------------------------------------------------------------
byte_9706
	dc.b	0
	dc.b	7
	dc.b	$3A
	dc.b	$3C
	dc.b	$16
	dc.b	$22
	dc.b	$1E
	dc.b	0
	dc.b	$FE
	dc.b	$FF
byte_9710
	dc.b	0
	dc.b	7
	dc.b	$2C
	dc.b	$1E
	dc.b	$3A
	dc.b	$3A
	dc.b	$32
	dc.b	$30
	dc.b	0
	dc.b	$FF
byte_971A
	dc.b	0
	dc.b	$B
	dc.b	$20
	dc.b	$26
	dc.b	$30
	dc.b	$16
	dc.b	$2C
	dc.b	0
	dc.b	0
	dc.b	$3A
	dc.b	$3C
	dc.b	$16
	dc.b	$22
	dc.b	$1E

; =============== S U B	R O U T	I N E =====================================================


sub_9728:
	move.w	(a1)+,d0
	move.w	$A(a0),d5
	move.w	$E(a0),d6
	clr.b	d1
	tst.b	7(a0)
	beq.w	loc_9740
	move.b	#$6A,d1

loc_9740:
	move.b	(a1)+,d6
	cmpi.b	#$FF,d6
	bne.w	loc_974E
	move.b	$F(a0),d6

loc_974E:
	cmpi.b	#$FE,d6
	bne.w	loc_975A
	move.b	$17(a0),d6

loc_975A:
	tst.b	d6
	beq.w	loc_9762
	add.b	d1,d6

loc_9762:
	DISABLE_INTS
	jsr	SetVRAMWrite
	add.w	$12(a0),d5
	move.w	d6,VDP_DATA
	addq.b	#1,d6
	jsr	SetVRAMWrite
	sub.w	$12(a0),d5
	addq.w	#2,d5
	move.w	d6,VDP_DATA
	ENABLE_INTS
	dbf	d0,loc_9740
	rts
; End of function sub_9728


; =============== S U B	R O U T	I N E =====================================================


sub_9794:
	clr.l	d0
	move.b	(p1_win_count).l,d0
	move.w	#$C320,d5
	move.w	#$A500,d6
	bsr.w	sub_97C8
	clr.l	d0
	move.b	(p2_win_count).l,d0
	move.w	#$C32C,d5
	move.w	#$A500,d6
	bsr.w	sub_97C8
	move.l	#$800D0000,d0
	jmp	QueuePlaneCmd
; End of function sub_9794


; =============== S U B	R O U T	I N E =====================================================


sub_97C8:
	divu.w	#$A,d0
	tst.b	d0
	beq.w	loc_97D4
	addq.b	#1,d0

loc_97D4:
	addi.l	#$10000,d0
	lsl.l	#1,d0
	bsr.w	sub_97E2
	swap	d0
; End of function sub_97C8


; =============== S U B	R O U T	I N E =====================================================


sub_97E2:
	move.b	d0,d6
	DISABLE_INTS
	jsr	SetVRAMWrite
	addi.w	#$80,d5
	move.b	d0,d6
	move.w	d6,VDP_DATA
	addq.b	#1,d6
	jsr	SetVRAMWrite
	subi.w	#$7E,d5
	move.w	d6,VDP_DATA
	ENABLE_INTS
	rts
; End of function sub_97E2

; -----------------------------------------------------------------------------------------
	rts

; =============== S U B	R O U T	I N E =====================================================


sub_9814:
	btst	#1,stage_mode
	bne.w	locret_98B2
	lea	byte_FF19B2,a1
	clr.w	d0
	move.b	$2A(a0),d0
	eori.b	#1,d0
	tst.b	(a1,d0.w)
	bne.w	locret_98B2
	clr.l	d0
	move.w	$14(a0),d0
	move.b	$2A(a0),d4
	eori.b	#1,d4
	bra.w	loc_9858
; -----------------------------------------------------------------------------------------

loc_984A:
	bsr.w	sub_99AA
	andi.l	#$FFFF,d0
	move.b	$2A(a0),d4

loc_9858:
	tst.w	puyos_popping
	bne.w	locret_98B2
	lea	(byte_FF19B0).l,a2
	tst.b	d4
	beq.w	loc_9874
	lea	(byte_FF19B1).l,a2

loc_9874:
	addq.b	#1,(a2)
	move.w	#$180,d1
	move.w	#$150,d2
	move.w	#$10,d3
	move.b	swap_fields,d5
	eor.b	d5,d4
	beq.w	loc_989A
	move.w	#$C0,d1
	move.w	#$E0,d2
	move.w	#$FFF0,d3

loc_989A:
	divu.w	#6,d0
	clr.w	d4
	bsr.w	sub_98B4
	swap	d0
	cmpi.w	#6,d4
	bcc.w	locret_98B2
	bsr.w	sub_98F2

locret_98B2:
	rts
; End of function sub_9814


; =============== S U B	R O U T	I N E =====================================================


sub_98B4:
	tst.w	d0
	beq.w	locret_98F0
	lea	(sub_9962).l,a1
	jsr	FindActorSlotQuick
	bcs.w	loc_98E6
	bsr.w	sub_992E
	subq.w	#1,d0
	move.b	#5,9(a1)
	cmpi.w	#4,d0
	bcs.w	loc_98E6
	move.b	#6,9(a1)
	subq.w	#4,d0

loc_98E6:
	add.w	d3,d2
	addq.w	#1,d4
	cmpi.w	#6,d4
	bcs.s	sub_98B4

locret_98F0:
	rts
; End of function sub_98B4


; =============== S U B	R O U T	I N E =====================================================


sub_98F2:
	subq.b	#1,d0
	bcs.w	locret_9922
	lea	(sub_9962).l,a1
	jsr	FindActorSlotQuick
	bcs.w	locret_9922
	bsr.w	sub_992E
	move.b	d0,9(a1)
	cmpi.w	#$C0,d1
	bne.w	locret_9922
	lsl.w	#1,d0
	move.w	unk_9924(pc,d0.w),d1
	add.w	d1,$A(a1)

locret_9922:
	rts
; End of function sub_98F2

; -----------------------------------------------------------------------------------------
unk_9924
	dc.b	0
	dc.b	4
	dc.b	$FF
	dc.b	$F8
	dc.b	$FF
	dc.b	$EC
	dc.b	$FF
	dc.b	$E0
	dc.b	$FF
	dc.b	$D4

; =============== S U B	R O U T	I N E =====================================================


sub_992E:
	move.b	#$A2,6(a1)
	move.b	#2,8(a1)
	move.w	d1,$A(a1)
	move.w	#$88,$E(a1)
	clr.l	d5
	move.w	d2,d5
	sub.w	d1,d5
	swap	d5
	asr.l	#4,d5
	move.l	d5,$12(a1)
	move.w	#$10,$26(a1)
	move.l	a2,$32(a1)
	move.b	(a2),$28(a1)
	rts
; End of function sub_992E


; =============== S U B	R O U T	I N E =====================================================


sub_9962:
	tst.w	$26(a0)
	beq.w	loc_9974
	jsr	(ActorMove).l
	subq.w	#1,$26(a0)

loc_9974:
	movea.l	$32(a0),a1
	move.b	$28(a0),d0
	cmp.b	(a1),d0
	bne.w	loc_9984
	rts
; -----------------------------------------------------------------------------------------

loc_9984:
	jmp	(ActorDeleteSelf).l
; End of function sub_9962


; =============== S U B	R O U T	I N E =====================================================


sub_998A:
	btst	#1,stage_mode
	beq.w	loc_9998
	rts
; -----------------------------------------------------------------------------------------

loc_9998:
	bsr.w	sub_99AA
	move.w	d0,$14(a1)
	clr.w	d0
	swap	d0
	move.l	d0,$E(a0)
	rts
; End of function sub_998A


; =============== S U B	R O U T	I N E =====================================================


sub_99AA:
	lea	unk_99F8,a1
	move.w	time_seconds,d0
	move.w	time_minutes,d1
	beq.w	loc_99CE
	cmpi.b	#1,stage_mode
	bne.w	loc_99CE
	subq.w	#1,d1

loc_99CE:
	cmpi.w	#9,d1
	bcs.w	loc_99DA
	move.w	#8,d1

loc_99DA:
	lsr.w	#4,d0
	lsl.w	#2,d1
	or.w	d1,d0
	lsl.w	#1,d0

	move.w	#$46,d1
	clr.l	d0
	move.w	$10(a0),d0
	divu.w	d1,d0
	movea.l	$2E(a0),a1
	add.w	$14(a1),d0
	rts

; -----------------------------------------------------------------------------------------

unk_99F8:
	dc.w	$46
	dc.w	$46
	dc.w	$46
	dc.w	$46
	dc.w	$46
	dc.w	$46
	dc.w	$2F
	dc.w	$23
	dc.w	$1C
	dc.w	$17
	dc.w	$14
	dc.w	$12
	dc.w	$10
	dc.w	$0E
	dc.w	$0D
	dc.w	$0C
	dc.w	$0B
	dc.w	$0A
	dc.w	$09
	dc.w	$09
	dc.w	$08
	dc.w	$07
	dc.w	$06
	dc.w	$05
	dc.w	$04
	dc.w	$04
	dc.w	$03
	dc.w	$03
	dc.w	$02
	dc.w	$02
	dc.w	$01
	dc.w	$01
	dc.w	$01
	dc.w	$01
	dc.w	$01
	dc.w	$01

; =============== S U B	R O U T	I N E =====================================================


sub_9A40:
	move.l	a0,d0
	swap	d0
	move.b	$2A(a0),d0
	addi.b	#-$7A,d0
	rol.w	#8,d0
	swap	d0
	jmp	QueuePlaneCmd
; End of function sub_9A40


; =============== S U B	R O U T	I N E =====================================================


sub_9A56:
	bsr.w	GetPuyoField
	adda.l	#$1E0,a2
	bsr.w	sub_9B7E
	bsr.w	DrawBlockCount
	clr.w	d0
	btst	#1,stage_mode
	beq.w	loc_9A86
	move.b	$2B(a0),d0
	cmpi.b	#$62,d0
	bcs.w	loc_9A86
	move.b	#$63,d0

loc_9A86:
	addq.b	#1,d0
	mulu.w	#$A,d0
	mulu.w	d2,d0
	move.w	d0,$12(a0)
	swap	d0
	tst.w	d0
	beq.w	loc_9AA0
	move.w	#$FFFF,$12(a0)

loc_9AA0:
	clr.w	$1E(a0)
	bsr.w	sub_9AC2
	bsr.w	sub_9AEE
	bsr.w	sub_9B34
	cmpi.w	#$3E8,$1E(a0)
	bcs.w	locret_9AC0
	move.w	#$3E7,$1E(a0)

locret_9AC0:
	rts
; End of function sub_9A56


; =============== S U B	R O U T	I N E =====================================================


sub_9AC2:
	clr.w	d0
	move.b	9(a0),d0
	cmpi.b	#9,d0
	bcs.s	loc_9AD2
	move.b	#8,d0

loc_9AD2:
	lsl.b	#1,d0
	move.w	unk_9ADC(pc,d0.w),$1E(a0)
	rts
; End of function sub_9AC2

; -----------------------------------------------------------------------------------------
unk_9ADC
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	8
	dc.b	0
	dc.b	$10
	dc.b	0
	dc.b	$20
	dc.b	0
	dc.b	$40
	dc.b	0
	dc.b	$80
	dc.b	1
	dc.b	0
	dc.b	2
	dc.b	0
	dc.b	4
	dc.b	0

; =============== S U B	R O U T	I N E =====================================================


sub_9AEE:
	move.w	$26(a0),d0
	subq.w	#1,d0
	clr.w	d1
	clr.b	d2
	clr.w	d3

loc_9AFA:
	move.b	1(a2,d1.w),d3
	lsr.b	#4,d3
	andi.b	#7,d3
	bset	d3,d2
	addq.w	#2,d1
	dbf	d0,loc_9AFA
	move.w	#5,d0
	clr.w	d1

loc_9B12:
	ror.b	#1,d2
	bcc.s	loc_9B18
	addq.b	#2,d1

loc_9B18:
	dbf	d0,loc_9B12
	move.w	unk_9B26(pc,d1.w),d0
	add.w	d0,$1E(a0)
	rts
; End of function sub_9AEE

; -----------------------------------------------------------------------------------------
unk_9B26
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	3
	dc.b	0
	dc.b	6
	dc.b	0
	dc.b	$C
	dc.b	0
	dc.b	$18
	dc.b	0
	dc.b	$30

; =============== S U B	R O U T	I N E =====================================================


sub_9B34:
	move.w	$26(a0),d0
	subq.w	#1,d0
	clr.w	d1
	clr.w	d2

loc_9B3E:
	move.b	(a2,d1.w),d2
	cmpi.b	#$C,d2
	bcs.s	loc_9B4C
	move.b	#$B,d2

loc_9B4C:
	lsl.b	#1,d2
	move.w	unk_9B66(pc,d2.w),d3
	add.w	d3,$1E(a0)
	bcc.s	loc_9B5E
	move.w	#$FFFF,$1E(a0)

loc_9B5E:
	addq.w	#2,d1
	dbf	d0,loc_9B3E
	rts
; End of function sub_9B34

; -----------------------------------------------------------------------------------------
unk_9B66
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	2
	dc.b	0
	dc.b	3
	dc.b	0
	dc.b	4
	dc.b	0
	dc.b	5
	dc.b	0
	dc.b	6
	dc.b	0
	dc.b	7
	dc.b	0
	dc.b	$A

; =============== S U B	R O U T	I N E =====================================================


sub_9B7E:
	move.w	$26(a0),d0
	subq.w	#1,d0
	clr.w	d1
	clr.w	d2
	clr.w	d3

loc_9B8A:
	move.b	(a2,d1.w),d3
	add.w	d3,d2
	addq.w	#2,d1
	dbf	d0,loc_9B8A
	add.w	d2,$16(a0)
	cmpi.w	#$2710,$16(a0)
	bcs.w	loc_9BAA
	move.w	#$270F,$16(a0)

loc_9BAA:
	add.w	d2,$18(a0)
	bcc.w	locret_9BB8
	move.w	#$FFFF,$18(a0)

locret_9BB8:
	rts
; End of function sub_9B7E


; =============== S U B	R O U T	I N E =====================================================


sub_9BBA:
	clr.l	d0
	move.w	aXVel(a0),d0
	move.w	aXTarget(a0),d1
	beq.w	loc_9BCA
	mulu.w	d1,d0

loc_9BCA:
	bra.w	AddCombo
; End of function sub_9BBA


; =============== S U B	R O U T	I N E =====================================================


sub_9BCE:
	clr.w	d0
	move.b	stage_mode,d0
	andi.b	#3,d0
	lsl.w	#2,d0
	movea.l	off_9BE2(pc,d0.w),a1
	jmp	(a1)
; End of function sub_9BCE

; -----------------------------------------------------------------------------------------
off_9BE2
	dc.l	locret_9BF2
	dc.l	loc_9BF4
	dc.l	loc_9C0E
	dc.l	loc_9C0E
; -----------------------------------------------------------------------------------------

locret_9BF2:
	rts
; -----------------------------------------------------------------------------------------

loc_9BF4:
	clr.w	d0
	move.b	$2B(a0),d0
	lsl.w	#1,d0
	move.w	unk_9C04(pc,d0.w),$14(a0)
	rts
; -----------------------------------------------------------------------------------------
unk_9C04:
	dc.w	0
	dc.w	0
	dc.w	0
	dc.w	$12
	dc.w	$1E
; -----------------------------------------------------------------------------------------

loc_9C0E:
	movea.l	$32(a0),a1
	clr.w	d1
	move.b	$2B(a0),d1
	lsl.b	#2,d1
	andi.b	#$38,d1
	move.w	dword_9C32+4(pc,d1.w),$20(a1)
	move.b	dword_9C32+6(pc,d1.w),7(a1)
	move.l	dword_9C32(pc,d1.w),d0
	bra.w	AddComboDraw
; -----------------------------------------------------------------------------------------
dword_9C32:
	dc.l	0
	dc.w	$FFFF
	dc.b	0
	ALIGN	2

	dc.l	40000
	dc.w	$28
	dc.b	0
	ALIGN	2

	dc.l	90000
	dc.w	$24
	dc.b	1
	ALIGN	2

; =============== S U B	R O U T	I N E =====================================================


AddComboDraw:
	bsr.w	AddCombo
; End of function AddComboDraw


; =============== S U B	R O U T	I N E =====================================================


DrawScore:
	move.l	a0,d0
	swap	d0
	move.b	aPuyoField(a0),d0
	addi.b	#$81,d0
	rol.w	#8,d0
	swap	d0
	jmp	QueuePlaneCmd
; End of function DrawScore


; =============== S U B	R O U T	I N E =====================================================


AddCombo:
	add.l	d0,pfhGarbage(a0)
	tst.w	pfhGarbage(a0)
	beq.w	loc_9C7C
	move.w	#0,pfhGarbage(a0)
	move.w	#$FFFF,pfhGarbage+2(a0)

loc_9C7C:
	move.l	pfhScore(a0),d1
	add.l	d0,d1
	bcc.w	loc_9C8C
	move.l	#99999999,d1

loc_9C8C:
	cmpi.l	#99999999+1,d1
	bcs.w	loc_9C9C
	move.l	#99999999,d1

loc_9C9C:
	move.l	d1,pfhScore(a0)
	rts
; End of function AddCombo


; =============== S U B	R O U T	I N E =====================================================


sub_9CA2:
	move.w	$18(a0),d0
	cmp.w	$1C(a0),d0
	bcc.w	loc_9CB0
	rts
; -----------------------------------------------------------------------------------------

loc_9CB0:
	clr.w	$18(a0)
	addq.b	#1,8(a0)
	move.b	8(a0),d0
	andi.b	#7,d0
	bne.w	loc_9CF0
	move.b	stage_mode,d0
	andi.b	#3,d0
	beq.w	loc_9CF8
	move.b	#SFX_5B,d0
	bsr.w	PlaySound_ChkSamp
	cmpi.b	#$62,$2B(a0)
	bcc.w	loc_9CF4
	addq.b	#1,$2B(a0)
	move.w	#$80,d1
	bsr.w	DrawLevel

loc_9CF0:
	bra.w	loc_9CF8
; -----------------------------------------------------------------------------------------

loc_9CF4:
	bra.w	*+4
; -----------------------------------------------------------------------------------------

loc_9CF8:
	move.b	stage_mode,d0
	andi.b	#3,d0
	beq.w	loc_9D12
	cmpi.b	#1,d0
	beq.w	loc_9D42
	bra.w	loc_9D78
; -----------------------------------------------------------------------------------------

loc_9D12:
	clr.w	d0
	move.b	8(a0),d0
	sub.b	(byte_FF0104).l,d0
	bcc.w	loc_9D24
	clr.b	d0

loc_9D24:
	movem.l	a1,-(sp)
	lea	(unk_9DC4).l,a1
	lsl.w	#2,d0
	move.w	(a1,d0.w),$1A(a0)
	move.w	2(a1,d0.w),$1C(a0)
	movem.l	(sp)+,a1
	rts
; -----------------------------------------------------------------------------------------

loc_9D42:
	clr.w	d0
	move.b	8(a0),d0
	andi.b	#7,d0
	movem.l	d1/a1,-(sp)
	clr.w	d1
	move.b	$2B(a0),d1
	lsl.b	#2,d1
	andi.b	#$18,d1
	or.b	d1,d0
	lea	(unk_9E24).l,a1
	lsl.w	#2,d0
	move.w	(a1,d0.w),$1A(a0)
	move.w	2(a1,d0.w),$1C(a0)
	movem.l	(sp)+,d1/a1
	rts
; -----------------------------------------------------------------------------------------

loc_9D78:
	clr.w	d0
	move.b	8(a0),d0
	andi.b	#7,d0
	movem.l	d1/a1,-(sp)
	clr.w	d1
	move.b	$2B(a0),d1
	cmpi.b	#$D,d1
	bcs.w	loc_9D98
	move.b	#$C,d1

loc_9D98:
	or.b	unk_9DB6(pc,d1.w),d0
	lea	(unk_9E7C).l,a1
	lsl.w	#2,d0
	move.w	(a1,d0.w),$1A(a0)
	move.w	2(a1,d0.w),$1C(a0)
	movem.l	(sp)+,d1/a1
	rts
; End of function sub_9CA2

; -----------------------------------------------------------------------------------------
unk_9DB6
	dc.b	$48
	dc.b	$50
	dc.b	0
	dc.b	8
	dc.b	$10
	dc.b	$18
	dc.b	$20
	dc.b	$28
	dc.b	$30
	dc.b	$38
	dc.b	$38
	dc.b	$38
	dc.b	$40
	dc.b	0
unk_9DC4
	dc.b	4
	dc.b	0
	dc.b	0
	dc.b	$20
	dc.b	4
	dc.b	0
	dc.b	0
	dc.b	$20
	dc.b	5
	dc.b	0
	dc.b	0
	dc.b	$20
	dc.b	5
	dc.b	0
	dc.b	0
	dc.b	$20
	dc.b	6
	dc.b	0
	dc.b	0
	dc.b	$20
	dc.b	8
	dc.b	0
	dc.b	0
	dc.b	$20
	dc.b	$A
	dc.b	0
	dc.b	0
	dc.b	$20
	dc.b	$C
	dc.b	0
	dc.b	0
	dc.b	$28
	dc.b	$10
	dc.b	0
	dc.b	0
	dc.b	$28
	dc.b	$20
	dc.b	0
	dc.b	0
	dc.b	$30
	dc.b	$30
	dc.b	0
	dc.b	0
	dc.b	$30
	dc.b	$40
	dc.b	0
	dc.b	0
	dc.b	$38
	dc.b	$48
	dc.b	0
	dc.b	0
	dc.b	$38
	dc.b	$50
	dc.b	0
	dc.b	0
	dc.b	$40
	dc.b	$60
	dc.b	0
	dc.b	0
	dc.b	$40
	dc.b	$80
	dc.b	0
	dc.b	$FF
	dc.b	$FF
	dc.b	$80
	dc.b	0
	dc.b	$FF
	dc.b	$FF
	dc.b	$80
	dc.b	0
	dc.b	0
	dc.b	4
	dc.b	$80
	dc.b	0
	dc.b	0
	dc.b	4
	dc.b	$80
	dc.b	0
	dc.b	0
	dc.b	4
	dc.b	$A0
	dc.b	0
	dc.b	0
	dc.b	4
	dc.b	$C0
	dc.b	0
	dc.b	0
	dc.b	4
	dc.b	$E0
	dc.b	0
	dc.b	0
	dc.b	4
	dc.b	$FE
	dc.b	0
	dc.b	$FF
	dc.b	$FF
unk_9E24
	dc.b	$10
	dc.b	0
	dc.b	0
	dc.b	$20
	dc.b	$16
	dc.b	0
	dc.b	0
	dc.b	$20
	dc.b	$1A
	dc.b	0
	dc.b	0
	dc.b	$20
	dc.b	$20
	dc.b	0
	dc.b	0
	dc.b	$20
	dc.b	$25
	dc.b	0
	dc.b	0
	dc.b	$20
	dc.b	$30
	dc.b	0
	dc.b	0
	dc.b	$20
	dc.b	$34
	dc.b	0
	dc.b	0
	dc.b	$20
	dc.b	$40
	dc.b	0
	dc.b	$FF
	dc.b	$FF
	dc.b	$20
	dc.b	0
	dc.b	0
	dc.b	$20
	dc.b	$25
	dc.b	0
	dc.b	0
	dc.b	$20
	dc.b	$30
	dc.b	0
	dc.b	0
	dc.b	$20
	dc.b	$34
	dc.b	0
	dc.b	0
	dc.b	$20
	dc.b	$40
	dc.b	0
	dc.b	0
	dc.b	$20
	dc.b	$60
	dc.b	0
	dc.b	0
	dc.b	$20
	dc.b	$80
	dc.b	0
	dc.b	$FF
	dc.b	$FF
	dc.b	$20
	dc.b	0
	dc.b	0
	dc.b	$10
	dc.b	$25
	dc.b	0
	dc.b	0
	dc.b	$10
	dc.b	$30
	dc.b	0
	dc.b	0
	dc.b	$10
	dc.b	$34
	dc.b	0
	dc.b	0
	dc.b	$10
	dc.b	$40
	dc.b	0
	dc.b	0
	dc.b	$10
	dc.b	$60
	dc.b	0
	dc.b	0
	dc.b	$10
	dc.b	$80
	dc.b	0
	dc.b	$FF
	dc.b	$FF
unk_9E7C
	dc.b	$10
	dc.b	0
	dc.b	0
	dc.b	4
	dc.b	$16
	dc.b	0
	dc.b	0
	dc.b	4
	dc.b	$20
	dc.b	0
	dc.b	0
	dc.b	4
	dc.b	$30
	dc.b	0
	dc.b	0
	dc.b	4
	dc.b	$34
	dc.b	0
	dc.b	0
	dc.b	8
	dc.b	$40
	dc.b	0
	dc.b	0
	dc.b	8
	dc.b	$60
	dc.b	0
	dc.b	0
	dc.b	8
	dc.b	$60
	dc.b	0
	dc.b	0
	dc.b	8
	dc.b	$20
	dc.b	0
	dc.b	0
	dc.b	4
	dc.b	$20
	dc.b	0
	dc.b	0
	dc.b	4
	dc.b	$30
	dc.b	0
	dc.b	0
	dc.b	4
	dc.b	$30
	dc.b	0
	dc.b	0
	dc.b	4
	dc.b	$34
	dc.b	0
	dc.b	0
	dc.b	4
	dc.b	$34
	dc.b	0
	dc.b	0
	dc.b	4
	dc.b	$40
	dc.b	0
	dc.b	0
	dc.b	4
	dc.b	$40
	dc.b	0
	dc.b	0
	dc.b	4
	dc.b	$40
	dc.b	0
	dc.b	0
	dc.b	4
	dc.b	$40
	dc.b	0
	dc.b	0
	dc.b	4
	dc.b	$60
	dc.b	0
	dc.b	0
	dc.b	4
	dc.b	$60
	dc.b	0
	dc.b	0
	dc.b	4
	dc.b	$80
	dc.b	0
	dc.b	0
	dc.b	4
	dc.b	$80
	dc.b	0
	dc.b	0
	dc.b	4
	dc.b	$80
	dc.b	0
	dc.b	0
	dc.b	4
	dc.b	$80
	dc.b	0
	dc.b	0
	dc.b	4
	dc.b	$30
	dc.b	0
	dc.b	0
	dc.b	4
	dc.b	$30
	dc.b	0
	dc.b	0
	dc.b	4
	dc.b	$34
	dc.b	0
	dc.b	0
	dc.b	4
	dc.b	$34
	dc.b	0
	dc.b	0
	dc.b	4
	dc.b	$40
	dc.b	0
	dc.b	0
	dc.b	4
	dc.b	$40
	dc.b	0
	dc.b	0
	dc.b	4
	dc.b	$60
	dc.b	0
	dc.b	0
	dc.b	4
	dc.b	$60
	dc.b	0
	dc.b	0
	dc.b	4
	dc.b	$60
	dc.b	0
	dc.b	0
	dc.b	4
	dc.b	$60
	dc.b	0
	dc.b	0
	dc.b	4
	dc.b	$80
	dc.b	0
	dc.b	0
	dc.b	4
	dc.b	$80
	dc.b	0
	dc.b	0
	dc.b	4
	dc.b	$80
	dc.b	0
	dc.b	0
	dc.b	4
	dc.b	$80
	dc.b	0
	dc.b	0
	dc.b	4
	dc.b	$80
	dc.b	0
	dc.b	0
	dc.b	4
	dc.b	$80
	dc.b	0
	dc.b	0
	dc.b	4
	dc.b	$34
	dc.b	0
	dc.b	0
	dc.b	4
	dc.b	$34
	dc.b	0
	dc.b	0
	dc.b	4
	dc.b	$40
	dc.b	0
	dc.b	0
	dc.b	4
	dc.b	$40
	dc.b	0
	dc.b	0
	dc.b	4
	dc.b	$60
	dc.b	0
	dc.b	0
	dc.b	4
	dc.b	$60
	dc.b	0
	dc.b	0
	dc.b	4
	dc.b	$80
	dc.b	0
	dc.b	0
	dc.b	4
	dc.b	$80
	dc.b	0
	dc.b	0
	dc.b	4
	dc.b	$80
	dc.b	0
	dc.b	0
	dc.b	4
	dc.b	$80
	dc.b	0
	dc.b	0
	dc.b	4
	dc.b	$A0
	dc.b	0
	dc.b	0
	dc.b	4
	dc.b	$A0
	dc.b	0
	dc.b	0
	dc.b	4
	dc.b	$C0
	dc.b	0
	dc.b	0
	dc.b	4
	dc.b	$C0
	dc.b	0
	dc.b	0
	dc.b	4
	dc.b	$E0
	dc.b	0
	dc.b	0
	dc.b	4
	dc.b	$E0
	dc.b	0
	dc.b	0
	dc.b	4
	dc.b	$80
	dc.b	0
	dc.b	0
	dc.b	4
	dc.b	$80
	dc.b	0
	dc.b	0
	dc.b	4
	dc.b	$A0
	dc.b	0
	dc.b	0
	dc.b	4
	dc.b	$A0
	dc.b	0
	dc.b	0
	dc.b	4
	dc.b	$C0
	dc.b	0
	dc.b	0
	dc.b	4
	dc.b	$C0
	dc.b	0
	dc.b	0
	dc.b	4
	dc.b	$E0
	dc.b	0
	dc.b	0
	dc.b	4
	dc.b	$FE
	dc.b	0
	dc.b	0
	dc.b	8
	dc.b	$FE
	dc.b	0
	dc.b	0
	dc.b	4
	dc.b	$FE
	dc.b	0
	dc.b	0
	dc.b	4
	dc.b	$FE
	dc.b	0
	dc.b	0
	dc.b	4
	dc.b	$FE
	dc.b	0
	dc.b	0
	dc.b	4
	dc.b	$FE
	dc.b	0
	dc.b	0
	dc.b	4
	dc.b	$FE
	dc.b	0
	dc.b	0
	dc.b	4
	dc.b	$FE
	dc.b	0
	dc.b	0
	dc.b	4
	dc.b	$FE
	dc.b	0
	dc.b	0
	dc.b	4
	dc.b	8
	dc.b	0
	dc.b	0
	dc.b	4
	dc.b	8
	dc.b	0
	dc.b	0
	dc.b	4
	dc.b	$B
	dc.b	0
	dc.b	0
	dc.b	4
	dc.b	$B
	dc.b	0
	dc.b	0
	dc.b	4
	dc.b	$B
	dc.b	0
	dc.b	0
	dc.b	4
	dc.b	$10
	dc.b	0
	dc.b	0
	dc.b	4
	dc.b	$10
	dc.b	0
	dc.b	0
	dc.b	4
	dc.b	$10
	dc.b	0
	dc.b	0
	dc.b	4
	dc.b	$B
	dc.b	0
	dc.b	0
	dc.b	4
	dc.b	$B
	dc.b	0
	dc.b	0
	dc.b	4
	dc.b	$B
	dc.b	0
	dc.b	0
	dc.b	4
	dc.b	$C
	dc.b	0
	dc.b	0
	dc.b	4
	dc.b	$C
	dc.b	0
	dc.b	0
	dc.b	4
	dc.b	$D
	dc.b	0
	dc.b	0
	dc.b	4
	dc.b	$10
	dc.b	0
	dc.b	0
	dc.b	4
	dc.b	$10
	dc.b	0
	dc.b	0
	dc.b	4
ArtNem_GroupedStars:
	incbin	"data/artnem/artnem9FDC.bin"
	ALIGN	2
off_A15E
	dc.l	loc_A748
	dc.l	loc_A58A
	dc.l	loc_A540
	dc.l	loc_A442
	dc.l	sub_A2C8
	dc.l	sub_A7AE
	dc.l	sub_A1C2
	dc.l	sub_A1EA
	dc.l	sub_A18A
	dc.l	sub_A4B4
	dc.l	sub_A846

; =============== S U B	R O U T	I N E =====================================================


sub_A18A:
	move.l	#unk_A19A,aAnim(a0)
	move.b	#0,$22(a0)
	rts
; End of function sub_A18A

; -----------------------------------------------------------------------------------------
unk_A19A
	dc.b	9
	dc.b	$15
	dc.b	9
	dc.b	$16
	dc.b	9
	dc.b	$17
	dc.b	9
	dc.b	$15
	dc.b	9
	dc.b	$16
	dc.b	9
	dc.b	$17
	dc.b	9
	dc.b	$15
	dc.b	9
	dc.b	$16
	dc.b	9
	dc.b	$17
	dc.b	9
	dc.b	$16
	dc.b	9
	dc.b	$17
	dc.b	9
	dc.b	$16
	dc.b	9
	dc.b	$17
	dc.b	9
	dc.b	$16
	dc.b	9
	dc.b	$17
	dc.b	9
	dc.b	$16
	dc.b	9
	dc.b	$17
	dc.b	$FF
	dc.b	0
	dc.l	unk_A19A

; =============== S U B	R O U T	I N E =====================================================


sub_A1C2:
	move.b	#$97,d0
	jsr	PlaySound_ChkSamp
	lea	(loc_A212).l,a1
	bsr.w	FindActorSlot
	bcc.s	loc_A1DA
	rts
; -----------------------------------------------------------------------------------------

loc_A1DA:
	move.w	#$62,$26(a1)
	move.l	#misc_buffer_2,$32(a1)
	rts
; End of function sub_A1C2


; =============== S U B	R O U T	I N E =====================================================


sub_A1EA:
	move.b	#$97,d0
	jsr	PlaySound_ChkSamp
	lea	(loc_A25C).l,a1
	bsr.w	FindActorSlot
	bcc.s	loc_A202
	rts
; -----------------------------------------------------------------------------------------

loc_A202:
	move.w	#$62,$26(a1)
	move.l	#misc_buffer_1,$32(a1)
	rts
; End of function sub_A1EA

; -----------------------------------------------------------------------------------------

loc_A212:
	move.w	$28(a0),d1
	cmpi.w	#$100,d1
	bne.s	loc_A222
	jmp	(ActorDeleteSelf).l
; -----------------------------------------------------------------------------------------

loc_A222:
	addi.w	#$10,$28(a0)
	bsr.w	sub_A2A6
	lea	dma_queue,a0
	adda.w	dma_slot,a0
	move.w	#$8F02,(a0)+
	move.l	#$94039310,(a0)+
	move.l	#$96B79510,(a0)+
	move.w	#$977F,(a0)+
	move.l	#$58200080,(a0)
	addi.w	#$10,dma_slot
	rts
; -----------------------------------------------------------------------------------------

loc_A25C:
	move.w	$28(a0),d1
	cmpi.w	#$100,d1
	bne.s	loc_A26C
	jmp	(ActorDeleteSelf).l
; -----------------------------------------------------------------------------------------

loc_A26C:
	addi.w	#$10,$28(a0)
	bsr.w	sub_A2A6
	lea	dma_queue,a0
	adda.w	dma_slot,a0
	move.w	#$8F02,(a0)+
	move.l	#$94039310,(a0)+
	move.l	#$96B49500,(a0)+
	move.w	#$977F,(a0)+
	move.l	#$52000080,(a0)
	addi.w	#$10,dma_slot
	rts

; =============== S U B	R O U T	I N E =====================================================


sub_A2A6:
	move.w	$26(a0),d0
	movea.l	$32(a0),a1
	lea	(unk_B224).l,a2
	adda.w	d1,a2

loc_A2B6:
	movea.l	a2,a3
	moveq	#3,d2

loc_A2BA:
	move.l	(a3)+,d3
	and.l	d3,(a1)+
	dbf	d2,loc_A2BA
	dbf	d0,loc_A2B6
	rts
; End of function sub_A2A6


; =============== S U B	R O U T	I N E =====================================================


sub_A2C8:
	move.b	#$87,d0
	jsr	PlaySound_ChkSamp
	lea	(sub_A316).l,a1
	bsr.w	FindActorSlot
	bcc.w	loc_A2E2
	rts
; -----------------------------------------------------------------------------------------

loc_A2E2:
	move.l	a0,$2E(a1)
	move.b	#$B3,6(a1)
	move.w	$A(a0),$A(a1)
	move.w	$E(a0),$E(a1)
	move.l	#$FFFE0000,$12(a1)
	move.l	#$50000,$16(a1)
	move.b	#$2B,8(a1)
	move.b	#$1E,9(a1)
	rts
; End of function sub_A2C8


; =============== S U B	R O U T	I N E =====================================================


sub_A316:
	move.w	#$C,d0
	bsr.w	ActorBookmark_SetDelay
	bsr.w	ActorBookmark
	movea.l	$2E(a0),a1
	tst.b	7(a1)
	beq.w	ActorDeleteSelf
	bsr.w	ActorMove
	move.l	$16(a0),d0
	subi.l	#$1270,d0
	bmi.s	loc_A342
	move.l	d0,$16(a0)

loc_A342:
	move.w	$E(a0),$E(a1)
	move.w	$A(a0),d0
	move.w	d0,$A(a1)
	cmpi.w	#$120,d0
	ble.s	loc_A358
	rts
; -----------------------------------------------------------------------------------------

loc_A358:
	move.w	#$101,(word_FF1990).l
	move.w	#8,d0
	bsr.w	ActorBookmark_SetDelay
	bsr.w	ActorBookmark
	lea	(sub_A404).l,a1
	bsr.w	FindActorSlot
	bcc.s	loc_A37A
	bra.s	loc_A3A4
; -----------------------------------------------------------------------------------------

loc_A37A:
	movea.l	$2E(a0),a2
	move.l	a2,$2E(a1)
	move.l	#$FFFEA000,$12(a1)
	move.l	#$FFFC0000,$16(a1)
	move.b	#$33,6(a1)
	move.w	$A(a0),$A(a1)
	move.w	$E(a0),$E(a1)

loc_A3A4:
	move.l	#$FFFE0000,$12(a0)
	move.l	#$FFFF8000,$16(a0)
	move.b	#$B3,6(a0)
	move.w	#$27,d0
	bsr.w	ActorBookmark_SetDelay
	bsr.w	ActorBookmark
	move.b	#$96,d0
	jsr	PlaySound_ChkSamp
	bsr.w	ActorBookmark
	movea.l	$2E(a0),a1
	tst.b	7(a1)
	beq.w	ActorDeleteSelf
	jsr	(ActorMove).l
	move.l	$16(a0),d0
	subi.l	#$2000,d0
	move.l	d0,$16(a0)
	move.w	$A(a0),d0
	cmpi.w	#$A8,d0
	bge.s	locret_A402
	bra.w	ActorDeleteSelf
; -----------------------------------------------------------------------------------------

locret_A402:
	rts
; End of function sub_A316


; =============== S U B	R O U T	I N E =====================================================


sub_A404:
	jsr	(ActorMove).l
	move.l	$16(a0),d0
	addi.l	#$2000,d0
	move.l	d0,$16(a0)
	move.w	$A(a0),d0
	cmpi.w	#$C0,d0
	bge.s	loc_A430
	move.b	#$67,d0
	jsr	PlaySound_ChkSamp
	bra.w	ActorDeleteSelf
; -----------------------------------------------------------------------------------------

loc_A430:
	movea.l	$2E(a0),a1
	move.w	$A(a0),$A(a1)
	move.w	$E(a0),$E(a1)
	rts
; End of function sub_A404

; -----------------------------------------------------------------------------------------

loc_A442:
	lea	(JmpTo_ActorAnimate).l,a1
	bsr.w	FindActorSlot
	bcs.w	locret_A4B2
	move.l	a0,$2E(a1)
	move.w	#$138,$A(a1)
	move.w	#$F8,$E(a1)
	move.b	#$28,8(a1)
	move.b	#0,9(a1)
	move.b	#$80,6(a1)
	move.l	#byte_A52C,$32(a1)
	lea	(JmpTo_ActorAnimate).l,a1
	bsr.w	FindActorSlot
	bcs.w	locret_A4B2
	move.l	a0,$2E(a1)
	move.w	#$168,$A(a1)
	move.w	#$118,$E(a1)
	move.b	#$28,8(a1)
	move.b	#2,9(a1)
	move.l	#unk_A536,$32(a1)
	move.b	#$80,6(a1)

locret_A4B2:
	rts

; =============== S U B	R O U T	I N E =====================================================


sub_A4B4:
	lea	(JmpTo_ActorAnimate).l,a1
	bsr.w	FindActorSlot
	bcs.w	locret_A524
	move.l	a0,$2E(a1)
	move.w	#$140,$A(a1)
	move.w	#$20,$E(a1)
	move.b	#$28,8(a1)
	move.b	#0,9(a1)
	move.b	#$80,6(a1)
	move.l	#byte_A52C,$32(a1)
	lea	(JmpTo_ActorAnimate).l,a1
	bsr.w	FindActorSlot
	bcs.w	locret_A524
	move.l	a0,$2E(a1)
	move.w	#$170,$A(a1)
	move.w	#$40,$E(a1)
	move.b	#$28,8(a1)
	move.b	#2,9(a1)
	move.l	#unk_A536,$32(a1)
	move.b	#$80,6(a1)

locret_A524:
	rts
; End of function sub_A4B4


; =============== S U B	R O U T	I N E =====================================================

; Attributes: thunk

JmpTo_ActorAnimate:
	jmp	(ActorAnimate).l
; End of function JmpTo_ActorAnimate

; -----------------------------------------------------------------------------------------
byte_A52C
	dc.b	$C
	dc.b	0
	dc.b	$18
	dc.b	1
	dc.b	$FF
	dc.b	0
	dc.l	byte_A52C
unk_A536
	dc.b	$2D
	dc.b	2
	dc.b	$F
	dc.b	3
	dc.b	$FF
	dc.b	0
	dc.l	unk_A536
; -----------------------------------------------------------------------------------------

loc_A540:
	lea	(loc_A560).l,a1
	bsr.w	FindActorSlot
	bcs.w	locret_A55E
	move.l	a0,$2E(a1)
	move.w	$A(a0),$1E(a1)
	move.w	$E(a0),$20(a1)

locret_A55E:
	rts
; -----------------------------------------------------------------------------------------

loc_A560:
	movea.l	$2E(a0),a1
	tst.b	7(a1)
	beq.w	ActorDeleteSelf
	move.b	$36(a0),d0
	move.w	#$1C00,d1
	jsr	(Sin).l
	swap	d2
	add.w	$1E(a0),d2
	move.w	d2,$A(a1)
	subq.b	#1,$36(a0)
	rts
; -----------------------------------------------------------------------------------------

loc_A58A:
	lea	(loc_A5F6).l,a1
	bsr.w	FindActorSlot
	bcs.w	loc_A5F0
	move.l	a0,$2E(a1)
	move.w	$A(a0),$1E(a1)
	move.w	$E(a0),$20(a1)
	movea.l	a1,a2
	moveq	#2,d1

loc_A5AC:
	lea	(loc_A692).l,a1
	bsr.w	FindActorSlot
	bcs.w	loc_A5F0
	move.l	a0,$2E(a1)
	move.l	a2,$32(a1)
	move.w	$A(a0),$1E(a1)
	move.w	$E(a0),$20(a1)
	move.b	#$80,6(a1)
	move.b	#$E,8(a1)
	move.b	#$A,9(a1)
	move.b	d1,$28(a1)
	move.b	d1,d0
	lsl.b	#3,d0
	addi.b	#$10,d0
	move.b	d0,$36(a1)

loc_A5F0:
	dbf	d1,loc_A5AC
	rts
; -----------------------------------------------------------------------------------------

loc_A5F6:
	movea.l	$2E(a0),a1
	tst.b	7(a1)
	beq.w	ActorDeleteSelf
	cmpi.b	#$80,$36(a0)
	bne.w	loc_A642
	tst.b	$28(a0)
	beq.s	loc_A63A
	tst.b	(word_FF1990+1).l
	bne.s	loc_A632
	tst.b	$2A(a0)
	beq.s	locret_A630
	subq.b	#4,$36(a0)
	move.b	#0,$28(a0)
	move.b	#0,$2A(a0)

locret_A630:
	rts
; -----------------------------------------------------------------------------------------

loc_A632:
	move.b	#1,$2A(a0)
	rts
; -----------------------------------------------------------------------------------------

loc_A63A:
	move.b	#1,$28(a0)
	rts
; -----------------------------------------------------------------------------------------

loc_A642:
	move.b	$36(a0),d0
	move.w	#$3800,d1
	jsr	(Sin).l
	swap	d2
	add.w	$1E(a0),d2
	move.w	d2,$A(a1)
	move.b	$36(a0),d0
	lsr.b	#1,d0
	move.w	#$800,d1
	jsr	(Sin).l
	swap	d2
	add.w	$20(a0),d2
	move.w	d2,$E(a1)
	subq.b	#4,$36(a0)
	clr.w	d0
	move.b	$36(a0),d0
	lsr.b	#5,d0
	move.b	unk_A68A(pc,d0.w),d0
	move.b	d0,9(a1)
	rts
; -----------------------------------------------------------------------------------------
unk_A68A
	dc.b	0
	dc.b	5
	dc.b	4
	dc.b	3
	dc.b	3
	dc.b	2
	dc.b	1
	dc.b	0
; -----------------------------------------------------------------------------------------

loc_A692:
	movea.l	$2E(a0),a1
	tst.b	7(a1)
	beq.w	ActorDeleteSelf
	movea.l	$32(a0),a1
	tst.b	$28(a1)
	beq.s	loc_A6AA
	rts
; -----------------------------------------------------------------------------------------

loc_A6AA:
	move.b	$36(a0),d0
	move.w	#$3800,d1
	jsr	(Sin).l
	swap	d2
	add.w	$1E(a0),d2
	move.w	d2,$A(a0)
	addi.w	#$10,$A(a0)
	move.b	$36(a0),d0
	lsr.b	#1,d0
	move.w	#$800,d1
	jsr	(Sin).l
	swap	d2
	add.w	$20(a0),d2
	move.w	d2,$E(a0)
	addi.w	#$20,$E(a0)
	subq.b	#4,$36(a0)
	addq.b	#1,$26(a0)
	move.b	$26(a0),d0
	andi.w	#3,d0
	lsl.w	#2,d0
	movea.l	off_A700(pc,d0.w),a2
	jmp	(a2)
; -----------------------------------------------------------------------------------------
off_A700
	dc.l	loc_A710
	dc.l	loc_A718
	dc.l	loc_A710
	dc.l	loc_A730
; -----------------------------------------------------------------------------------------

loc_A710:
	move.b	#0,6(a0)
	rts
; -----------------------------------------------------------------------------------------

loc_A718:
	move.b	#$80,6(a0)
	move.b	$28(a0),d0
	move.b	unk_A72C(pc,d0.w),d0
	move.b	d0,9(a0)
	rts
; -----------------------------------------------------------------------------------------
unk_A72C
	dc.b	8
	dc.b	9
	dc.b	$A
	dc.b	0
; -----------------------------------------------------------------------------------------

loc_A730:
	move.b	#$80,6(a0)
	move.b	$28(a0),d0
	move.b	unk_A744(pc,d0.w),d0
	move.b	d0,9(a0)
	rts
; -----------------------------------------------------------------------------------------
unk_A744
	dc.b	8
	dc.b	8
	dc.b	9
	dc.b	0
; -----------------------------------------------------------------------------------------

loc_A748:
	lea	(loc_A758).l,a1
	bsr.w	FindActorSlot
	move.l	a0,$2E(a1)
	rts
; -----------------------------------------------------------------------------------------

loc_A758:
	movea.l	$2E(a0),a1
	tst.b	7(a1)
	beq.w	ActorDeleteSelf
	addq.b	#1,$26(a0)
	move.b	$26(a0),d0
	move.b	d0,d1
	andi.b	#7,d1
	bne.s	locret_A7AC
	andi.b	#8,d0
	beq.s	loc_A78C
	move.w	#$AEE,(palette_buffer+$74).l
	move.w	#$AEE,(palette_buffer+$78).l
	bra.s	loc_A79C
; -----------------------------------------------------------------------------------------

loc_A78C:
	move.w	#$6C,(palette_buffer+$74).l
	move.w	#$28E,(palette_buffer+$78).l

loc_A79C:
	move.b	#3,d0
	lea	((palette_buffer+$60)).l,a2
	jsr	LoadPalette

locret_A7AC:
	rts

; =============== S U B	R O U T	I N E =====================================================


sub_A7AE:
	lea	(sub_A7C4).l,a1
	bsr.w	FindActorSlot
	move.l	a0,$2E(a1)
	move.b	#4,$26(a1)
	rts
; End of function sub_A7AE


; =============== S U B	R O U T	I N E =====================================================


sub_A7C4:
	movea.l	$2E(a0),a1
	tst.b	7(a1)
	beq.w	ActorDeleteSelf
	tst.b	$26(a0)
	beq.s	loc_A7DC
	subq.b	#1,$26(a0)
	rts
; -----------------------------------------------------------------------------------------

loc_A7DC:
	move.b	#4,$26(a0)
	move.w	$28(a0),d0
	addq.w	#1,d0
	cmpi.b	#$1B,d0
	bne.s	loc_A7F0
	moveq	#0,d0

loc_A7F0:
	move.w	d0,$28(a0)
	add.w	d0,d0
	move.w	word_A810(pc,d0.w),d1
	move.w	d1,(palette_buffer+$7C).l
	move.b	#3,d0
	lea	((palette_buffer+$60)).l,a2
	jmp	LoadPalette
; End of function sub_A7C4

; -----------------------------------------------------------------------------------------
word_A810
	dc.w	$68
	dc.w	$6A
	dc.w	$8A
	dc.w	$8C
	dc.w	$AE
	dc.w	$CE
	dc.w	$EE
	dc.w	$2EE
	dc.w	$4EE
	dc.w	$6EE
	dc.w	$8EE
	dc.w	$AEE
	dc.w	$CEE
	dc.w	$EEE
	dc.w	$EEE
	dc.w	$CEE
	dc.w	$AEE
	dc.w	$8EE
	dc.w	$6EE
	dc.w	$4EE
	dc.w	$2EE
	dc.w	$EE
	dc.w	$CE
	dc.w	$AE
	dc.w	$8C
	dc.w	$8A
	dc.w	$6A

; =============== S U B	R O U T	I N E =====================================================


sub_A846:
	lea	(sub_A85C).l,a1
	bsr.w	FindActorSlotQuick
	move.l	a0,$2E(a1)
	move.w	#4,$26(a1)
	rts
; End of function sub_A846


; =============== S U B	R O U T	I N E =====================================================


sub_A85C:
	subq.w	#1,$26(a0)
	bpl.s	locret_A8E0
	lea	(sub_A8E2).l,a1
	jsr	FindActorSlot
	bcs.s	loc_A8D0
	move.l	#unk_A90A,$32(a1)
	move.b	#$B3,6(a1)
	move.b	#$12,8(a1)
	move.b	#3,9(a1)
	move.w	#$1C0,$A(a1)
	jsr	Random
	andi.w	#$3F,d0
	addi.w	#$38,d0
	move.w	d0,$E(a1)
	moveq	#0,d0
	jsr	Random
	andi.w	#7,d0
	swap	d0
	asr.l	#1,d0
	addi.l	#$20000,d0
	neg.l	d0
	move.l	d0,$12(a1)
	move.w	#$400,$1C(a1)
	move.w	#$10,$20(a1)
	move.w	#$C0,$26(a1)

loc_A8D0:
	jsr	Random
	andi.w	#7,d0
	addq.w	#7,d0
	move.w	d0,$26(a0)

locret_A8E0:
	rts
; End of function sub_A85C


; =============== S U B	R O U T	I N E =====================================================


sub_A8E2:
	move.b	#$BF,6(a0)
	jsr	(ActorMove).l
	jsr	(ActorAnimate).l
	move.w	$A(a0),d0
	cmpi.w	#$60,d0
	bmi.s	loc_A904
	subq.w	#1,$26(a0)
	bpl.s	locret_A8E0

loc_A904:
	jmp	(ActorDeleteSelf).l
; End of function sub_A8E2

; -----------------------------------------------------------------------------------------
unk_A90A
	dc.b	7
	dc.b	3
	dc.b	6
	dc.b	4
	dc.b	5
	dc.b	5
	dc.b	6
	dc.b	6
	dc.b	$FF
	dc.b	0
	dc.l	unk_A90A

; =============== S U B	R O U T	I N E =====================================================


LoadOpponentIntro:
	clr.l	d0
	move.b	opponent,d0
	cmpi.b	#3,d0
	bne.s	.ChkRobotnik
	lea	(ArtNem_ArmsIntro2).l,a0
	move.w	#$6000,d0
	DISABLE_INTS
	jsr	NemDec
	ENABLE_INTS
	bra.s	.GetArtPtr
; -----------------------------------------------------------------------------------------

.ChkRobotnik:
	cmpi.b	#$C,d0
	bne.s	.GetArtPtr
	lea	(ArtNem_RobotnikShip).l,a0
	move.w	#$3000,d0
	bra.s	.DoArtLoad
; -----------------------------------------------------------------------------------------

.GetArtPtr:
	clr.l	d0
	move.b	opponent,d0
	lsl.w	#2,d0
	lea	(OpponentArt).l,a1
	movea.l	(a1,d0.w),a0
	move.w	#$8000,d0

.DoArtLoad:
	DISABLE_INTS
	jsr	NemDec
	ENABLE_INTS
	move.b	#$FF,(word_FF1990).l
	move.b	#0,(word_FF1990+1).l
	clr.w	d0
	move.b	opponent,d0
	move.b	d0,d1
	addi.b	#9,d1
	cmpi.b	#$15,d1
	bne.s	loc_A9B0
	move.b	#$2B,d1
	lea	(ActRobotnikIntro).l,a1
	bsr.w	FindActorSlot
	bcc.w	loc_A9C0
	rts
; -----------------------------------------------------------------------------------------

loc_A9B0:
	lea	(ActOpponentIntro).l,a1
	bsr.w	FindActorSlot
	bcc.w	loc_A9C0
	rts
; -----------------------------------------------------------------------------------------

loc_A9C0:
	move.b	#$FF,aField7(a1)
	move.b	d1,aMappings(a1)
	move.b	#$80,aFlags(a1)
	lsl.w	#2,d0
	move.w	word_A9E2(pc,d0.w),aX(a1)
	move.w	word_A9E4(pc,d0.w),aY(a1)
	movea.l	a1,a2
	rts
; End of function LoadOpponentIntro

; -----------------------------------------------------------------------------------------
word_A9E2
	dc.w	$110
word_A9E4
	dc.w	$40
	dc.w	$F8
	dc.w	$28
	dc.w	$100
	dc.w	8
	dc.w	$E8
	dc.w	$20
	dc.w	$E8
	dc.w	$40
	dc.w	$100
	dc.w	$30
	dc.w	$F0
	dc.w	$20
	dc.w	$108
	dc.w	$38
	dc.w	$100
	dc.w	$20
	dc.w	$100
	dc.w	$20
	dc.w	$F8
	dc.w	$20
	dc.w	$110
	dc.w	$20
	dc.w	$1C0
	dc.w	$FF38
	dc.w	$110
	dc.w	$20
	dc.w	$F8
	dc.w	$30
	dc.w	$100
	dc.w	$20
	dc.w	$D0
	dc.w	$20
OpponentArt:
	dc.l	ArtNem_CoconutsCutscene
	dc.l	ArtNem_FranklyCutscene
	dc.l	ArtNem_DynamightCutscene
	dc.l	ArtNem_ArmsCutscene
	dc.l	ArtNem_CoconutsCutscene
	dc.l	ArtNem_GrounderCutscene
	dc.l	ArtNem_DavyCutscene
	dc.l	ArtNem_CoconutsCutscene
	dc.l	ArtNem_SpikeCutscene
	dc.l	ArtNem_SirFfuzzyCutscene
	dc.l	ArtNem_DragonCutscene
	dc.l	ArtNem_ScratchCutscene
	dc.l	ArtNem_CoconutsCutscene
	dc.l	ArtNem_CoconutsCutscene
	dc.l	ArtNem_HumptyCutscene
	dc.l	ArtNem_SkweelCutscene
	dc.l	ArtNem_CoconutsCutscene

; =============== S U B	R O U T	I N E =====================================================


ActOpponentIntro:
	tst.w	(vscroll_buffer).l
	beq.w	ActOpponentIntro_Done
	move.w	aX(a0),(word_FF1994).l
	tst.b	(word_FF1990).l
	beq.w	loc_AACA
	clr.b	(word_FF1990).l
	clr.w	d0
	move.b	(word_FF1990+1).l,d0
	bpl.w	loc_AAAA
	lea	(off_A15E).l,a1
	andi.b	#$7F,d0
	lsl.w	#2,d0
	movea.l	(a1,d0.w),a2
	jmp	(a2)
; -----------------------------------------------------------------------------------------

loc_AAAA:
	clr.w	d1
	move.b	opponent,d1
	lea	(off_AC48).l,a1
	lsl.w	#2,d1
	movea.l	(a1,d1.w),a2
	lsl.w	#2,d0
	move.l	(a2,d0.w),aAnim(a0)
	clr.w	aAnimTime(a0)

loc_AACA:
	bra.w	ActorAnimate
; -----------------------------------------------------------------------------------------

ActOpponentIntro_Done:
	clr.b	7(a0)
	bsr.w	ActorBookmark
	bra.w	ActorDeleteSelf
; End of function ActOpponentIntro


; =============== S U B	R O U T	I N E =====================================================


ActRobotnikIntro:
	lea	(off_AF44).l,a1
	move.l	(a1),aAnim(a0)
	jsr	(ActorBookmark).l
	tst.w	(vscroll_buffer).l
	beq.s	ActOpponentIntro_Done
	move.w	aX(a0),(word_FF1994).l
	tst.b	(word_FF1990).l
	beq.w	loc_AB42
	clr.b	(word_FF1990).l
	clr.w	d0
	move.b	(word_FF1990+1).l,d0
	bpl.w	loc_AB28
	lea	(off_A15E).l,a1
	andi.b	#$7F,d0
	lsl.w	#2,d0
	movea.l	(a1,d0.w),a2
	jmp	(a2)
; -----------------------------------------------------------------------------------------

loc_AB28:
	clr.w	d1
	move.b	opponent,d1
	lea	(off_AF44).l,a2
	lsl.w	#2,d0
	move.l	(a2,d0.w),aAnim(a0)
	clr.w	aAnimTime(a0)

loc_AB42:
	tst.b	aAnimTime(a0)
	beq.w	loc_AB50
	subq.b	#1,aAnimTime(a0)
	rts
; -----------------------------------------------------------------------------------------

loc_AB50:
	movea.l	aAnim(a0),a2
	cmpi.b	#$FE,(a2)
	beq.w	locret_ABC6
	cmpi.b	#$FF,(a2)
	bne.w	loc_AB68
	movea.l	2(a2),a2

loc_AB68:
	move.b	(a2)+,aAnimTime(a0)
	move.b	(a2)+,d0
	move.b	d0,9(a0)
	move.l	a2,aAnim(a0)
	lsl.w	#2,d0
	move.l	off_ABC8(pc,d0.w),d0
	move.l	a0,-(sp)
	lea	dma_queue,a0
	adda.w	dma_slot,a0
	move.w	#$8F02,(a0)+
	move.l	#$94059380,(a0)+
	lsr.l	#1,d0
	move.l	d0,d1
	lsr.w	#8,d0
	swap	d0
	move.w	d1,d0
	andi.w	#$FF,d0
	addi.l	#$96009500,d0
	swap	d1
	andi.w	#$7F,d1
	addi.w	#$9700,d1
	move.l	d0,(a0)+
	move.w	d1,(a0)+
	move.l	#$60000080,(a0)
	addi.w	#$10,dma_slot
	movea.l	(sp)+,a0

locret_ABC6:
	rts
; End of function ActRobotnikIntro

; -----------------------------------------------------------------------------------------
off_ABC8
	dc.l	byte_30000
	dc.l	byte_30880
	dc.l	byte_31140
	dc.l	byte_31C00
	dc.l	byte_32700
	dc.l	byte_331C0
	dc.l	byte_33C00
	dc.l	byte_34600
	dc.l	byte_34FC0
	dc.l	byte_35980
	dc.l	byte_363A0
	dc.l	byte_36E00
	dc.l	byte_37720
	dc.l	byte_38080
	dc.l	byte_38940
	dc.l	byte_39200
	dc.l	byte_39AC0
	dc.l	byte_3A3E0
	dc.l	byte_3A880
	dc.l	byte_3AC40
	dc.l	byte_3B080
	dc.l	byte_97DA2
	dc.l	byte_98702
	dc.l	byte_99042
	dc.l	byte_38080
	dc.l	byte_38940
	dc.l	byte_39200
	dc.l	byte_39AC0
	dc.l	byte_3A880
	dc.l	ArtNem_RobotnikShip
	dc.l	ArtNem_RobotnikShip
	dc.l	byte_30000
off_AC48
	dc.l	off_AC8C
	dc.l	off_ACC0
	dc.l	off_AD60
	dc.l	off_ADEC
	dc.l	off_AC8C
	dc.l	off_AEA6
	dc.l	off_AD08
	dc.l	off_AC8C
	dc.l	off_AE18
	dc.l	off_AE5C
	dc.l	off_AE4A
	dc.l	off_AEE2
	dc.l	off_AF44
	dc.l	off_AC8C
	dc.l	off_AE6E
	dc.l	off_AEC8
	dc.l	off_AF44
off_AC8C
	dc.l	unk_ACB8
	dc.l	unk_ACA6
	dc.l	unk_AC98
unk_AC98
	dc.b	6
	dc.b	1
	dc.b	6
	dc.b	2
	dc.b	6
	dc.b	1
	dc.b	6
	dc.b	0
	dc.b	$FF
	dc.b	0
	dc.l	unk_AC98
unk_ACA6
	dc.b	4
	dc.b	3
	dc.b	4
	dc.b	4
	dc.b	8
	dc.b	6
	dc.b	8
	dc.b	5
	dc.b	8
	dc.b	6
	dc.b	8
	dc.b	5
	dc.b	4
	dc.b	4
	dc.b	4
	dc.b	3
	dc.b	$FE
	dc.b	0
unk_ACB8
	dc.b	$18
	dc.b	0
	dc.b	$FF
	dc.b	0
	dc.l	unk_ACB8
off_ACC0
	dc.l	unk_ACD0
	dc.l	unk_ACE6
	dc.l	unk_ACF2
	dc.l	unk_ACFC
unk_ACD0
	dc.b	8
	dc.b	0
	dc.b	8
	dc.b	1
	dc.b	8
	dc.b	2
	dc.b	8
	dc.b	3
	dc.b	8
	dc.b	4
	dc.b	8
	dc.b	3
	dc.b	8
	dc.b	2
	dc.b	8
	dc.b	1
	dc.b	$FF
	dc.b	0
	dc.l	unk_ACD0
unk_ACE6
	dc.b	8
	dc.b	0
	dc.b	8
	dc.b	1
	dc.b	8
	dc.b	2
	dc.b	8
	dc.b	3
	dc.b	8
	dc.b	4
	dc.b	$FE
	dc.b	0
unk_ACF2
	dc.b	6
	dc.b	4
	dc.b	6
	dc.b	5
	dc.b	$FF
	dc.b	0
	dc.l	unk_ACF2
unk_ACFC
	dc.b	8
	dc.b	4
	dc.b	8
	dc.b	3
	dc.b	8
	dc.b	2
	dc.b	8
	dc.b	1
	dc.b	8
	dc.b	0
	dc.b	$FE
	dc.b	0
off_AD08
	dc.l	unk_AD20
	dc.l	unk_AD2C
	dc.l	unk_AD30
	dc.l	unk_AD38
	dc.l	unk_AD56
	dc.l	unk_AD3A
unk_AD20
	dc.b	$1E
	dc.b	0
unk_AD22
	dc.b	8
	dc.b	1
	dc.b	8
	dc.b	0
	dc.b	$FF
	dc.b	0
	dc.l	unk_AD22
unk_AD2C
	dc.b	$1E
	dc.b	0
	dc.b	$FE
	dc.b	0
unk_AD30
	dc.b	$F
	dc.b	0
	dc.b	5
	dc.b	2
	dc.b	$F
	dc.b	3
	dc.b	$FE
	dc.b	0
unk_AD38
	dc.b	4
	dc.b	5
unk_AD3A
	dc.b	$A
	dc.b	6
	dc.b	4
	dc.b	5
	dc.b	4
	dc.b	3
	dc.b	$A
	dc.b	4
	dc.b	4
	dc.b	3
	dc.b	4
	dc.b	5
	dc.b	$A
	dc.b	6
	dc.b	4
	dc.b	5
	dc.b	4
	dc.b	3
	dc.b	$A
	dc.b	4
	dc.b	4
	dc.b	3
	dc.b	4
	dc.b	5
	dc.b	$F
	dc.b	6
	dc.b	$FE
	dc.b	0
unk_AD56
	dc.b	8
	dc.b	6
	dc.b	8
	dc.b	7
	dc.b	$FF
	dc.b	0
	dc.l	unk_AD56
off_AD60
	dc.l	unk_AD88
	dc.l	unk_AD8C
	dc.l	unk_AD74
	dc.l	unk_ADA6
	dc.l	unk_ADD2
unk_AD74
	dc.b	5
	dc.b	0
	dc.b	5
	dc.b	1
	dc.b	5
	dc.b	2
	dc.b	5
	dc.b	3
	dc.b	5
	dc.b	4
	dc.b	6
	dc.b	5
	dc.b	7
	dc.b	6
	dc.b	5
	dc.b	7
	dc.b	5
	dc.b	2
	dc.b	5
	dc.b	1
unk_AD88
	dc.b	8
	dc.b	0
	dc.b	$FE
	dc.b	0
unk_AD8C
	dc.b	5
	dc.b	8
	dc.b	5
	dc.b	9
	dc.b	5
	dc.b	0
	dc.b	5
	dc.b	8
	dc.b	5
	dc.b	9
	dc.b	5
	dc.b	0
	dc.b	$16
	dc.b	0
	dc.b	5
	dc.b	8
	dc.b	5
	dc.b	9
	dc.b	$16
	dc.b	0
	dc.b	$FF
	dc.b	0
	dc.l	unk_AD8C
unk_ADA6
	dc.b	3
	dc.b	0
	dc.b	3
	dc.b	1
	dc.b	3
	dc.b	2
	dc.b	3
	dc.b	3
	dc.b	3
	dc.b	4
	dc.b	5
	dc.b	5
	dc.b	6
	dc.b	6
	dc.b	3
	dc.b	7
	dc.b	3
	dc.b	2
	dc.b	3
	dc.b	1
	dc.b	6
	dc.b	0
	dc.b	3
	dc.b	1
	dc.b	3
	dc.b	2
	dc.b	3
	dc.b	3
	dc.b	3
	dc.b	4
	dc.b	5
	dc.b	5
	dc.b	6
	dc.b	6
	dc.b	3
	dc.b	7
	dc.b	3
	dc.b	2
	dc.b	3
	dc.b	1
	dc.b	3
	dc.b	0
	dc.b	$FE
	dc.b	0
unk_ADD2
	dc.b	5
	dc.b	0
	dc.b	5
	dc.b	1
	dc.b	5
	dc.b	2
	dc.b	5
	dc.b	3
	dc.b	5
	dc.b	4
	dc.b	7
	dc.b	5
	dc.b	8
	dc.b	6
	dc.b	5
	dc.b	7
	dc.b	5
	dc.b	2
	dc.b	5
	dc.b	1
	dc.b	$FF
	dc.b	0
	dc.l	unk_ADD2
off_ADEC
	dc.l	unk_ADF4
	dc.l	unk_AE06
unk_ADF4
	dc.b	7
	dc.b	0
	dc.b	7
	dc.b	1
	dc.b	7
	dc.b	2
	dc.b	7
	dc.b	3
	dc.b	7
	dc.b	4
	dc.b	7
	dc.b	5
	dc.b	$FF
	dc.b	0
	dc.l	unk_ADF4
unk_AE06
	dc.b	7
	dc.b	0
	dc.b	7
	dc.b	1
	dc.b	7
	dc.b	2
	dc.b	7
	dc.b	3
	dc.b	7
	dc.b	4
	dc.b	7
	dc.b	6
	dc.b	$FF
	dc.b	0
	dc.l	unk_AE06
off_AE18
	dc.l	unk_AE20
	dc.l	unk_AE32
unk_AE20
	dc.b	9
	dc.b	0
	dc.b	4
	dc.b	1
	dc.b	4
	dc.b	2
	dc.b	$F
	dc.b	3
	dc.b	9
	dc.b	2
	dc.b	8
	dc.b	1
	dc.b	$FF
	dc.b	0
	dc.l	unk_AE20
unk_AE32
	dc.b	$28
	dc.b	0
	dc.b	4
	dc.b	1
	dc.b	4
	dc.b	2
	dc.b	8
	dc.b	3
	dc.b	7
	dc.b	2
	dc.b	6
	dc.b	1
	dc.b	4
	dc.b	1
	dc.b	4
	dc.b	2
	dc.b	8
	dc.b	3
	dc.b	7
	dc.b	2
	dc.b	6
	dc.b	1
	dc.b	$FE
	dc.b	0
off_AE4A
	dc.l	unk_AE4E
unk_AE4E
	dc.b	$E
	dc.b	0
	dc.b	$B
	dc.b	1
	dc.b	$A
	dc.b	2
	dc.b	$C
	dc.b	1
	dc.b	$FF
	dc.b	0
	dc.l	unk_AE4E
off_AE5C
	dc.l	unk_AE60
unk_AE60
	dc.b	5
	dc.b	0
	dc.b	5
	dc.b	1
	dc.b	5
	dc.b	2
	dc.b	5
	dc.b	1
	dc.b	$FF
	dc.b	0
	dc.l	unk_AE60
off_AE6E
	dc.l	unk_AE7A
	dc.l	unk_AE90
	dc.l	unk_AEA2
unk_AE7A
	dc.b	9
	dc.b	2
	dc.b	9
	dc.b	1
	dc.b	9
	dc.b	0
	dc.b	9
	dc.b	1
	dc.b	9
	dc.b	2
	dc.b	9
	dc.b	3
	dc.b	9
	dc.b	4
	dc.b	9
	dc.b	3
	dc.b	$FF
	dc.b	0
	dc.l	unk_AE7A
unk_AE90
	dc.b	$A
	dc.b	2
	dc.b	5
	dc.b	5
	dc.b	5
	dc.b	2
	dc.b	5
	dc.b	5
	dc.b	$1E
	dc.b	2
	dc.b	5
	dc.b	5
	dc.b	$FF
	dc.b	0
	dc.l	unk_AE90
unk_AEA2
	dc.b	$1E
	dc.b	2
	dc.b	$FE
	dc.b	0
off_AEA6
	dc.l	unk_AEAE
	dc.l	unk_AEB6
unk_AEAE
	dc.b	1
	dc.b	0
	dc.b	$FE
	dc.b	0
	dc.l	unk_AEAE
unk_AEB6
	dc.b	$A
	dc.b	6
	dc.b	5
	dc.b	7
	dc.b	5
	dc.b	6
	dc.b	5
	dc.b	7
	dc.b	$1E
	dc.b	6
	dc.b	5
	dc.b	7
	dc.b	$FF
	dc.b	0
	dc.l	unk_AEB6
off_AEC8
	dc.l	unk_AECC
unk_AECC
	dc.b	4
	dc.b	0
	dc.b	4
	dc.b	1
	dc.b	4
	dc.b	2
	dc.b	4
	dc.b	1
	dc.b	4
	dc.b	0
	dc.b	4
	dc.b	3
	dc.b	4
	dc.b	4
	dc.b	4
	dc.b	3
	dc.b	$FF
	dc.b	0
	dc.l	unk_AECC
off_AEE2
	dc.l	unk_AEFE
	dc.l	unk_AF02
	dc.l	unk_AF10
	dc.l	unk_AF1A
	dc.l	unk_AF28
	dc.l	unk_AF32
	dc.l	unk_AF40
unk_AEFE
	dc.b	4
	dc.b	0
	dc.b	$FE
	dc.b	0
unk_AF02
	dc.b	5
	dc.b	0
	dc.b	5
	dc.b	7
	dc.b	5
	dc.b	8
	dc.b	5
	dc.b	7
	dc.b	$FF
	dc.b	0
	dc.l	unk_AF02
unk_AF10
	dc.b	$1E
	dc.b	0
	dc.b	6
	dc.b	1
	dc.b	7
	dc.b	2
	dc.b	$3C
	dc.b	3
	dc.b	$FE
	dc.b	0
unk_AF1A
	dc.b	5
	dc.b	3
	dc.b	5
	dc.b	9
	dc.b	5
	dc.b	$A
	dc.b	5
	dc.b	9
	dc.b	$FF
	dc.b	0
	dc.l	unk_AF1A
unk_AF28
	dc.b	$14
	dc.b	3
	dc.b	7
	dc.b	4
	dc.b	8
	dc.b	5
	dc.b	$1E
	dc.b	6
	dc.b	$FE
	dc.b	0
unk_AF32
	dc.b	5
	dc.b	6
	dc.b	5
	dc.b	$B
	dc.b	5
	dc.b	$C
	dc.b	5
	dc.b	$B
	dc.b	$FF
	dc.b	0
	dc.l	unk_AF32
unk_AF40
	dc.b	$32
	dc.b	6
	dc.b	$FE
	dc.b	0
off_AF44
	dc.l	byte_AF50
	dc.l	unk_AF54
	dc.l	unk_AF62
byte_AF50
	dc.b	$32
	dc.b	$1C
	dc.b	$FE
	dc.b	0
unk_AF54
	dc.b	4
	dc.b	$13
	dc.b	4
	dc.b	$14
	dc.b	$14
	dc.b	$19
	dc.b	$A
	dc.b	$1A
	dc.b	$1C
	dc.b	$1B
	dc.b	$14
	dc.b	$18
	dc.b	$A
	dc.b	$1F
unk_AF62
	dc.b	$32
	dc.b	0
	dc.b	7
	dc.b	1
	dc.b	6
	dc.b	2
	dc.b	7
	dc.b	3
	dc.b	$F
	dc.b	4
	dc.b	$14
	dc.b	5
	dc.b	9
	dc.b	6
	dc.b	$14
	dc.b	7
	dc.b	9
	dc.b	6
	dc.b	$14
	dc.b	8
	dc.b	9
	dc.b	9
	dc.b	$A
	dc.b	$A
	dc.b	9
	dc.b	$B
	dc.b	$32
	dc.b	$C
	dc.b	$FF
	dc.b	0
	dc.l	unk_AF62
; -----------------------------------------------------------------------------------------

SetupstageTransition:
	lea	(ActstageTransitionFG).l,a1
	bsr.w	FindActorSlot
	lea	(ActstageTransitionBG).l,a1
	bsr.w	FindActorSlot
	move.w	#$FF20,(vscroll_buffer).l
	move.w	#$FF60,(vscroll_buffer+2).l
	move.w	#$FFFF,(stage_transition_flag).l
	rts

; =============== S U B	R O U T	I N E =====================================================


ActstageTransitionFG:
	tst.w	(stage_transition_flag).l
	beq.w	ActstageTrans_FGScroll
	rts
; -----------------------------------------------------------------------------------------

ActstageTrans_FGScroll:
	move.w	#$FF20,aY(a0)
	move.l	#$40000,aYVel(a0)
	move.w	#$38,aField26(a0)
	bsr.w	ActorBookmark
	cmpi.b	#3,stage
	bcs.w	ActstageTrans_FGStop
	move.l	aYVel(a0),d0
	add.l	d0,aY(a0)
	move.w	aY(a0),d0
	move.w	d0,(vscroll_buffer).l
	subq.w	#1,aField26(a0)
	beq.w	ActstageTrans_FGStop
	rts
; -----------------------------------------------------------------------------------------

ActstageTrans_FGStop:
	move.w	#0,(vscroll_buffer).l
	move.b	#$45,d0
	jsr	PlaySound_ChkSamp
	clr.b	(bytecode_disabled).l
	bra.w	ActorDeleteSelf
; End of function ActstageTransitionFG


; =============== S U B	R O U T	I N E =====================================================


ActstageTransitionBG:
	tst.w	(stage_transition_flag).l
	beq.w	ActstageTrans_BGScroll
	rts
; -----------------------------------------------------------------------------------------

ActstageTrans_BGScroll:
	move.w	#$FF60,aY(a0)
	move.l	#$2DB6D,aYVel(a0)
	move.w	#$38,aField26(a0)
	bsr.w	ActorBookmark
	cmpi.b	#3,stage
	bcs.w	ActstageTrans_BGStop
	move.l	aYVel(a0),d0
	add.l	d0,aY(a0)
	move.w	aY(a0),d0
	move.w	d0,(vscroll_buffer+2).l
	subq.w	#1,aField26(a0)
	beq.w	ActstageTrans_BGStop
	rts
; -----------------------------------------------------------------------------------------

ActstageTrans_BGStop:
	move.w	#0,(vscroll_buffer+2).l
	move.w	#$8B00,d0
	move.b	vdp_reg_b,d0
	andi.b	#$FC,d0
	move.b	d0,vdp_reg_b
	clr.w	(hscroll_buffer+2).l
	bra.w	ActorDeleteSelf
; End of function ActstageTransitionBG


; =============== S U B	R O U T	I N E =====================================================


LoadStageCutscene:
	lea	(ActstageCutscene).l,a1
	bsr.w	FindActorSlot
	clr.w	d0
	clr.w	d1
	move.b	stage,d0
	move.b	LairBackgroundFlags(pc,d0.w),d1
	move.b	d1,(use_lair_background).l
	move.b	d1,d2
	lsr.b	#1,d2
	move.b	d2,bytecode_flag
	lsl.w	#2,d1
	movea.l	off_B0CE(pc,d1.w),a2
	jmp	(a2)
; End of function LoadStageCutscene

; -----------------------------------------------------------------------------------------
LairBackgroundFlags:dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	1
	dc.b	1
	dc.b	0
off_B0CE
	dc.l	loc_B0F4
	dc.l	loc_B0F4
; -----------------------------------------------------------------------------------------

loc_B0D6:
	clr.w	d0
	clr.w	d1
	move.b	stage,d0
	move.b	LairBackgroundFlags(pc,d0.w),d1
	lsl.w	#2,d1
	movea.l	off_B0EC(pc,d1.w),a2
	jmp	(a2)
; -----------------------------------------------------------------------------------------
off_B0EC
	dc.l	loc_B102
	dc.l	loc_B102
; -----------------------------------------------------------------------------------------

loc_B0F4:
	move.w	#0,d0
	jsr	QueuePlaneCmdList
	bra.w	loc_B152
; -----------------------------------------------------------------------------------------

loc_B102:
	move.b	#1,d0
	move.b	#0,d1
	lea	Palettes,a2
	adda.l	#(Pal_2876-Palettes),a2
	jsr	(FadeToPalette).l
	clr.l	d0
	move.b	opponent,d0
	move.b	unk_B140(pc,d0.w),d0
	lsl.w	#5,d0
	lea	Palettes,a2
	adda.l	d0,a2
	move.b	#3,d0
	move.b	#0,d1
	jmp	(FadeToPalette).l
; -----------------------------------------------------------------------------------------
unk_B140
	dc.b	$31
	dc.b	$3D
	dc.b	$42
	dc.b	$45
	dc.b	$31
	dc.b	$4B
	dc.b	$41
	dc.b	$31
	dc.b	$47
	dc.b	$49
	dc.b	$48
	dc.b	$4E
	dc.b	$31
	dc.b	$31
	dc.b	$4A
	dc.b	$4D
	dc.b	$31
	dc.b	0
; -----------------------------------------------------------------------------------------

loc_B152:
	tst.b	(use_lair_background).l
	bne.s	locret_B1AA
	move.b	#0,(word_FF1126).l
	move.w	#$8B00,d0
	move.b	vdp_reg_b,d0
	ori.b	#3,d0
	move.b	d0,vdp_reg_b
	lea	(loc_B1AC).l,a1
	bsr.w	FindActorSlot
	bcs.w	locret_B1AA
	move.l	a1,(dword_FF112C).l
	move.l	#$FFFF0000,$E(a1)
	move.l	#$FFFF4000,$16(a1)
	move.l	#$FFFF8000,$1E(a1)
	move.l	#$FFFFC000,$26(a1)

locret_B1AA:
	rts
; -----------------------------------------------------------------------------------------

loc_B1AC:
	tst.b	(word_FF1126).l
	beq.s	loc_B1B6
	rts
; -----------------------------------------------------------------------------------------

loc_B1B6:
	move.w	#$A,d0
	move.w	#3,d1

loc_B1BE:
	move.l	4(a0,d0.w),d2
	add.l	d2,(a0,d0.w)
	addq.l	#8,d0
	dbf	d1,loc_B1BE
	lea	(hscroll_buffer).l,a2
	move.w	#$15C,d0
	move.w	(vscroll_buffer+2).l,d1
	subi.w	#$FF60,d1
	cmpi.w	#$58,d1
	bcc.w	ActorDeleteSelf
	subq.w	#1,d1
	bcs.w	loc_B1F8

loc_B1EE:
	clr.l	(a2,d0.w)
	subq.w	#4,d0
	dbf	d1,loc_B1EE

loc_B1F8:
	clr.w	d1
	move.w	#$22,d2

loc_B1FE:
	clr.w	d3
	move.b	unk_B220(pc,d1.w),d3

loc_B204:
	clr.w	(a2,d0.w)
	move.w	(a0,d2.w),2(a2,d0.w)
	subq.w	#4,d0
	bcs.w	locret_B21E
	dbf	d3,loc_B204
	addq.w	#1,d1
	subq.w	#8,d2
	bra.s	loc_B1FE
; -----------------------------------------------------------------------------------------

locret_B21E:
	rts
; -----------------------------------------------------------------------------------------
unk_B220
	dc.b	7
	dc.b	7
	dc.b	$1F
	dc.b	$FF
unk_B224
	dc.b	$F
	dc.b	$FF
	dc.b	$F
	dc.b	$FF
	dc.b	$FF
	dc.b	$FF
	dc.b	$FF
	dc.b	$FF
	dc.b	$FF
	dc.b	$FF
	dc.b	$FF
	dc.b	$FF
	dc.b	$FF
	dc.b	$FF
	dc.b	$FF
	dc.b	$FF
	dc.b	$F
	dc.b	$FF
	dc.b	$F
	dc.b	$FF
	dc.b	$FF
	dc.b	$FF
	dc.b	$FF
	dc.b	$FF
	dc.b	$FF
	dc.b	$F
	dc.b	$FF
	dc.b	$F
	dc.b	$FF
	dc.b	$FF
	dc.b	$FF
	dc.b	$FF
	dc.b	$F
	dc.b	$F
	dc.b	$F
	dc.b	$F
	dc.b	$FF
	dc.b	$FF
	dc.b	$FF
	dc.b	$FF
	dc.b	$FF
	dc.b	$F
	dc.b	$FF
	dc.b	$F
	dc.b	$FF
	dc.b	$FF
	dc.b	$FF
	dc.b	$FF
	dc.b	$F
	dc.b	$F
	dc.b	$F
	dc.b	$F
	dc.b	$FF
	dc.b	$FF
	dc.b	$FF
	dc.b	$FF
	dc.b	$F
	dc.b	$F
	dc.b	$F
	dc.b	$F
	dc.b	$FF
	dc.b	$FF
	dc.b	$FF
	dc.b	$FF
	dc.b	$F
	dc.b	$F
	dc.b	$F
	dc.b	$F
	dc.b	$F0
	dc.b	$FF
	dc.b	$F0
	dc.b	$FF
	dc.b	$F
	dc.b	$F
	dc.b	$F
	dc.b	$F
	dc.b	$FF
	dc.b	$FF
	dc.b	$FF
	dc.b	$FF
	dc.b	$F
	dc.b	$F
	dc.b	$F
	dc.b	$F
	dc.b	$F0
	dc.b	$FF
	dc.b	$F0
	dc.b	$FF
	dc.b	$F
	dc.b	$F
	dc.b	$F
	dc.b	$F
	dc.b	$FF
	dc.b	$F0
	dc.b	$FF
	dc.b	$F0
	dc.b	$F
	dc.b	$F
	dc.b	$F
	dc.b	$F
	dc.b	$F0
	dc.b	$F0
	dc.b	$F0
	dc.b	$F0
	dc.b	$F
	dc.b	$F
	dc.b	$F
	dc.b	$F
	dc.b	$FF
	dc.b	$F0
	dc.b	$FF
	dc.b	$F0
	dc.b	$F
	dc.b	$F
	dc.b	$F
	dc.b	$F
	dc.b	$F0
	dc.b	$F0
	dc.b	$F0
	dc.b	$F0
	dc.b	$F
	dc.b	$F
	dc.b	$F
	dc.b	$F
	dc.b	$F0
	dc.b	$F0
	dc.b	$F0
	dc.b	$F0
	dc.b	$F
	dc.b	$F
	dc.b	$F
	dc.b	$F
	dc.b	0
	dc.b	$F0
	dc.b	0
	dc.b	$F0
	dc.b	$F
	dc.b	$F
	dc.b	$F
	dc.b	$F
	dc.b	$F0
	dc.b	$F0
	dc.b	$F0
	dc.b	$F0
	dc.b	$F
	dc.b	$F
	dc.b	$F
	dc.b	$F
	dc.b	0
	dc.b	$F0
	dc.b	0
	dc.b	$F0
	dc.b	$F
	dc.b	$F
	dc.b	$F
	dc.b	$F
	dc.b	$F0
	dc.b	0
	dc.b	$F0
	dc.b	0
	dc.b	$F
	dc.b	$F
	dc.b	$F
	dc.b	$F
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	$F
	dc.b	$F
	dc.b	$F
	dc.b	$F
	dc.b	$F0
	dc.b	0
	dc.b	$F0
	dc.b	0
	dc.b	$F
	dc.b	$F
	dc.b	$F
	dc.b	$F
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	$F
	dc.b	$F
	dc.b	$F
	dc.b	$F
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	$F
	dc.b	0
	dc.b	$F
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	$F
	dc.b	$F
	dc.b	$F
	dc.b	$F
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	$F
	dc.b	0
	dc.b	$F
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	$F
	dc.b	0
	dc.b	$F
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	$F
	dc.b	0
	dc.b	$F
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0

; =============== S U B	R O U T	I N E =====================================================


LoadSegaLogo:
	lea	(ActSegaLogo).l,a1
	jsr	FindActorSlot
	bcs.s	.NoSpace
	move.b	#$32,aMappings(a1)
	move.w	#$20,aX(a1)
	move.w	#$E0,aY(a1)
	move.b	#$80,aFlags(a1)
	move.l	#Anim_SegaLogo,aAnim(a1)

.NoSpace:
	rts
; End of function LoadSegaLogo


; =============== S U B	R O U T	I N E =====================================================


ActSegaLogo:
	jsr	(ActorAnimate).l
	movea.l	aAnim(a0),a2
	cmpi.b	#$FE,(a2)
	beq.s	ActSegaLogo_Delay
	moveq	#0,d0
	move.b	9(a0),d0
	move.b	SegaLogoXSpeeds(pc,d0.w),d0
	add.w	d0,aX(a0)
	rts
; -----------------------------------------------------------------------------------------
SegaLogoXSpeeds:dc.b	6, 5, 4, 4, 4, 3, 3, 3, 3, 3, 3, 2, 2, 2, 2, 1, 1, 1, 0, 0
; -----------------------------------------------------------------------------------------

ActSegaLogo_Delay:
	move.b	#$13,9(a0)
	move.w	#3,$28(a0)
	move.w	#$3C,d0
	jsr	(ActorBookmark_SetDelay).l
	jsr	(ActorBookmark).l
	subq.w	#1,$28(a0)
	beq.s	ActSegaLogo_Outline
	rts
; -----------------------------------------------------------------------------------------

ActSegaLogo_Outline:
	jsr	(LoadTimerCtrlSkip).l
	move.w	#3,$28(a0)
	move.w	$26(a0),d0
	cmpi.w	#$EEE,d0
	beq.s	.Delay
	addi.w	#$222,d0
	move.w	d0,$26(a0)
	move.w	d0,(palette_buffer+2).l
	move.b	#0,d0
	lea	(palette_buffer).l,a2
	jmp	LoadPalette
; -----------------------------------------------------------------------------------------

.Delay:
	move.w	#0,$26(a0)
	move.w	#3,$28(a0)
	move.w	#$3C,d0
	jsr	(ActorBookmark_SetDelay).l
	jsr	(ActorBookmark).l
	subq.w	#1,$28(a0)
	beq.s	.PalCycle
	rts
; -----------------------------------------------------------------------------------------

.PalCycle:
	move.w	#3,$28(a0)
	addq.w	#1,$26(a0)
	move.w	$26(a0),d0
	cmpi.w	#$11,d0
	beq.s	.Delete
	add.w	d0,d0
	lea	(PalCycle_SegaLogo).l,a1
	suba.w	d0,a1
	lea	((palette_buffer+4)).l,a2
	moveq	#8,d0

.CopyPal:
	move.w	(a1)+,(a2)+
	dbf	d0,.CopyPal
	move.b	#0,d0
	lea	(palette_buffer).l,a2
	jmp	LoadPalette
; -----------------------------------------------------------------------------------------

.Delete:
	move.w	#$3C,d0
	jsr	(ActorBookmark_SetDelay).l
	jsr	(ActorBookmark).l
	clr.b	(bytecode_disabled).l
	jmp	(ActorDeleteSelf).l
; End of function ActSegaLogo

; -----------------------------------------------------------------------------------------
	dc.w	$EC0
	dc.w	$EA0
	dc.w	$E80
	dc.w	$E60
	dc.w	$E40
	dc.w	$E20
	dc.w	$E00
	dc.w	$C00
	dc.w	$A00
	dc.w	$C00
	dc.w	$E00
	dc.w	$E20
	dc.w	$E40
	dc.w	$E60
	dc.w	$E80
	dc.w	$EA0
PalCycle_SegaLogo:
	dc.w	$EC0
	dc.w	$EA0
	dc.w	$E80
	dc.w	$E60
	dc.w	$E40
	dc.w	$E20
	dc.w	$E00
	dc.w	$C00
	dc.w	$A00
Anim_SegaLogo
	dc.b	3
	dc.b	0
	dc.b	3
	dc.b	1
	dc.b	3
	dc.b	2
	dc.b	3
	dc.b	3
	dc.b	3
	dc.b	4
	dc.b	3
	dc.b	5
	dc.b	3
	dc.b	6
	dc.b	3
	dc.b	7
	dc.b	3
	dc.b	8
	dc.b	3
	dc.b	9
	dc.b	3
	dc.b	$A
	dc.b	3
	dc.b	$B
	dc.b	3
	dc.b	$C
	dc.b	3
	dc.b	$D
	dc.b	3
	dc.b	$E
	dc.b	3
	dc.b	$F
	dc.b	3
	dc.b	$10
	dc.b	3
	dc.b	$11
	dc.b	3
	dc.b	$12
	dc.b	$FE
	dc.b	0
; -----------------------------------------------------------------------------------------

loc_B4B6:
	move.b	#$FF,7(a0)
	move.l	#word_B732,aAnim(a0)
	move.w	#$300,d0
	jsr	(ActorBookmark_SetDelay).l
	jsr	(ActorBookmark).l
	tst.w	aField26(a0)
	beq.w	loc_B4E2
	subq.w	#1,aField26(a0)
	rts
; -----------------------------------------------------------------------------------------

loc_B4E2:
	movea.l	aAnim(a0),a1
	move.w	(a1)+,d0
	beq.w	loc_B500
	bmi.w	loc_B54E
	add.w	d0,d0
	move.w	d0,aField26(a0)
	movea.l	(a1)+,a2
	move.l	a1,aAnim(a0)
	bra.w	loc_B570
; -----------------------------------------------------------------------------------------

loc_B500:
	move.b	#0,7(a0)
	move.w	#$BB8,d0
	jsr	(ActorBookmark_SetDelay).l
	jsr	(ActorBookmark).l
	move.w	#$3F,(dword_FF1130).l
	jsr	(FadeSound).l
	move.w	#$12C,d0
	jsr	(ActorBookmark_SetDelay).l
	jsr	(ActorBookmark).l
	move.w	#$FFFF,(word_FF1134).l
	clr.b	(bytecode_disabled).l
	clr.b	bytecode_flag
	jmp	(ActorDeleteSelf).l
; -----------------------------------------------------------------------------------------

loc_B54E:
	moveq	#0,d0
	move.b	(difficulty).l,d0
	lsl.w	#2,d0
	move.l	off_B560(pc,d0.w),aAnim(a0)
	rts
; -----------------------------------------------------------------------------------------
off_B560
	dc.l	word_B648
	dc.l	word_B662
	dc.l	word_B67C
	dc.l	word_B696
; -----------------------------------------------------------------------------------------

loc_B570:
	lea	(byte_FF143E).l,a1
	move.w	#7,d0

loc_B57A:
	tst.b	(a1,d0.w)
	beq.w	loc_B588
	dbf	d0,loc_B57A
	rts
; -----------------------------------------------------------------------------------------

loc_B588:
	move.b	#$FF,(a1,d0.w)
	lea	(loc_B60E).l,a1
	jsr	FindActorSlot
	bcc.w	loc_B5A0
	rts
; -----------------------------------------------------------------------------------------

loc_B5A0:
	move.l	a0,$32(a1)
	move.b	#$91,6(a1)
	move.b	#7,8(a1)
	move.b	d0,9(a1)
	move.w	d0,$26(a1)
	move.w	(a2)+,$A(a1)
	move.w	#$160,$E(a1)
	move.l	#$FFFF8000,$16(a1)
	lea	(ActstageCutscene_CharConv).l,a4
	lea	(byte_FF1446).l,a3
	mulu.w	#$A2,d0
	adda.l	d0,a3
	move.w	(a2)+,d0
	move.w	d0,(a3)+
	subq.w	#1,d0
	clr.w	d1

loc_B5E4:
	moveq	#0,d2
	move.b	(a2)+,d2
	move.b	(a4,d2.w),d2
	bne.s	loc_B5F2
	addq.w	#8,d1
	bra.s	loc_B5E4
; -----------------------------------------------------------------------------------------

loc_B5F2:
	ori.w	#$8500,d2
	move.w	#$120,(a3)+
	move.b	#0,(a3)+
	move.b	#0,(a3)+
	move.w	d2,(a3)+
	move.w	d1,(a3)+
	addq.w	#8,d1
	dbf	d0,loc_B5E4
	rts
; -----------------------------------------------------------------------------------------

loc_B60E:
	movea.l	$32(a0),a1
	tst.b	7(a1)
	beq.w	loc_B640
	jsr	(ActorMove).l
	cmpi.w	#$70,$E(a0)
	bcs.w	loc_B62C
	rts
; -----------------------------------------------------------------------------------------

loc_B62C:
	lea	(byte_FF143E).l,a1
	move.w	$26(a0),d0
	clr.b	(a1,d0.w)
	jmp	(ActorDeleteSelf).l
; -----------------------------------------------------------------------------------------

loc_B640:
	jsr	(ActorBookmark).l
	rts
; -----------------------------------------------------------------------------------------
word_B648
	dc.w	$10
	dc.l	word_B6B0
	dc.w	$30
	dc.l	word_B6BE
	dc.w	$C
	dc.l	word_B6E0
	dc.w	$50
	dc.l	word_B6CE
	dc.w	0
word_B662
	dc.w	$10
	dc.l	word_B6F0
	dc.w	$28
	dc.l	word_B6FE
	dc.w	$C
	dc.l	word_B6E0
	dc.w	$50
	dc.l	word_B6CE
	dc.w	0
word_B67C
	dc.w	$10
	dc.l	word_B6F0
	dc.w	$28
	dc.l	word_B710
	dc.w	$C
	dc.l	word_B6E0
	dc.w	$50
	dc.l	word_B6CE
	dc.w	0
word_B696
	dc.w	$10
	dc.l	word_B6F0
	dc.w	$28
	dc.l	word_B720
	dc.w	$C
	dc.l	word_B6E0
	dc.w	$50
	dc.l	word_B6CE
	dc.w	0
word_B6B0
	dc.w	$D8
	dc.w	9
	dc.b	"Thank you",0
word_B6BE
	dc.w	$108
	dc.w	$C
	dc.b	"for playing."
word_B6CE
	dc.w	$E8
	dc.w	$E
	dc.b	"@ 1993 COMPILE"
word_B6E0
	dc.w	$F4
	dc.w	$B
	dc.b	"@ 1993 |}~",0
word_B6F0
	dc.w	$D0
	dc.w	9
	dc.b	"Let's try",0
word_B6FE
	dc.w	$100
	dc.w	$E
	dc.b	"hardest level."
word_B710
	dc.w	$118
	dc.w	$B
	dc.b	"hard level.",0
word_B720
	dc.w	$108
	dc.w	$D
	dc.b	"normal level.",0
word_B732
	dc.w	$F0
	dc.l	word_B806
	dc.w	$40
	dc.l	word_B9BC
	dc.w	$20
	dc.l	word_B9CA
	dc.w	$20
	dc.l	word_B9D8
	dc.w	$60
	dc.l	word_B9EA
	dc.w	$40
	dc.l	word_B81C
	dc.w	$20
	dc.l	word_B8AC
	dc.w	$20
	dc.l	word_B8BE
	dc.w	$80
	dc.l	word_B9FA
	dc.w	$50
	dc.l	word_B838
	dc.w	$28
	dc.l	word_B8D6
	dc.w	$28
	dc.l	word_B8E8
	dc.w	$28
	dc.l	word_B8FC
	dc.w	$28
	dc.l	word_B90E
	dc.w	$80
	dc.l	word_BA0A
	dc.w	$50
	dc.l	word_B84E
	dc.w	$20
	dc.l	word_B91E
	dc.w	$20
	dc.l	word_B932
	dc.w	8
	dc.l	word_BA20
	dc.w	$80
	dc.l	word_BA2E
	dc.w	$40
	dc.l	word_B85E
	dc.w	8
	dc.l	word_B954
	dc.w	$18
	dc.l	word_B8A2
	dc.w	$60
	dc.l	word_B942
	dc.w	$40
	dc.l	word_B878
	dc.w	$80
	dc.l	word_B968
	dc.w	$60
	dc.l	word_B88E
	dc.w	$40
	dc.l	word_B810
	dc.w	$60
	dc.l	word_B97C
	dc.w	$40
	dc.l	word_B82A
	dc.w	$20
	dc.l	word_B97C
	dc.w	$20
	dc.l	word_B98A
	dc.w	$60
	dc.l	word_B99A
	dc.w	$40
	dc.l	word_B86E
	dc.w	$80
	dc.l	word_B9A9+1
	dc.w	$8000
word_B806
	dc.w	$A8
	dc.w	5
	dc.b	"STAFF",0
word_B810
	dc.w	$A8
	dc.w	8
	dc.b	"PRODUCER"
word_B81C
	dc.w	$A8
	dc.w	9
	dc.b	"DIRECTORS",0
word_B82A
	dc.w	$A8
	dc.w	9
	dc.b	"DESIGNERS",0
word_B838
	dc.w	$A8
	dc.w	$11
	dc.b	"GRAPHIC DESIGNERS",0
word_B84E
	dc.w	$A8
	dc.w	$B
	dc.b	"PROGRAMMERS",0
word_B85E
	dc.w	$A8
	dc.w	$C
	dc.b	"MUSIC AND FX"
word_B86E
	dc.w	$A8
	dc.w	5
	dc.b	"SOUND",0
word_B878
	dc.w	$A8
	dc.w	$11
	dc.b	"SPECIAL THANKS TO",0
word_B88E
	dc.w	$A8
	dc.w	$F
	dc.b	"SEGA OF AMERICA",0
word_B8A2
	dc.w	$170
	dc.w	6
	dc.b	"-CUBE-"
word_B8AC
	dc.w	$110
	dc.w	$D
	dc.b	"Tetsuo Shinyu",0
word_B8BE
	dc.w	$110
	dc.w	$13
	dc.b	"Takayuki Yanagihori",0
word_B8D6
	dc.w	$110
	dc.w	$D
	dc.b	"Takaya Segawa",0
word_B8E8
	dc.w	$110
	dc.w	$F
	dc.b	"Saori Yamaguchi",0
word_B8FC
	dc.w	$110
	dc.w	$E
	dc.b	"Hideaki Moriya"
word_B90E
	dc.w	$110
	dc.w	$C
	dc.b	"Keisuke Saka"
word_B91E
	dc.w	$110
	dc.w	$F
	dc.b	"Manabu Ishihara",0
word_B932
	dc.w	$110
	dc.w	$C
	dc.b	"Tsukasa Aoki"
word_B942
	dc.w	$110
	dc.w	$E
	dc.b	"Masayuki Nagao"
word_B954
	dc.w	$110
	dc.w	$10
	dc.b	"Masanori Hikichi"
word_B968
	dc.w	$110
	dc.w	$10
	dc.b	"Shinobu Yokoyama"
word_B97C
	dc.w	$110
	dc.w	$A
	dc.b	"Max Taylor"
word_B98A
	dc.w	$110
	dc.w	$C
	dc.b	"Brian Ransom"
word_B99A
	dc.w	$110
	dc.w	$B
	dc.b	"Dave Albert"
word_B9A9
	dc.w	1
	dc.w	$1000
	dc.b	$E,"David Javelosa"
word_B9BC
	dc.w	$A8
	dc.w	9
	dc.b	"PRODUCERS",0
word_B9CA
	dc.w	$110
	dc.w	$A
	dc.b	"Yoji Ishii"
word_B9D8
	dc.w	$110
	dc.w	$E
	dc.b	"Noriyoshi Ohba"
word_B9EA
	dc.w	$110
	dc.w	$B
	dc.b	"Moo Niitani",0
word_B9FA
	dc.w	$110
	dc.w	$C
	dc.b	"M. Tsukamoto"
word_BA0A
	dc.w	$110
	dc.w	$12
	dc.b	"COMPILE'S DESIGNER"
word_BA20
	dc.w	$110
	dc.w	9
	dc.b	"COMPILE'S",0
word_BA2E
	dc.w	$138
	dc.w	$A
	dc.b	"PROGRAMMER"
; -----------------------------------------------------------------------------------------

loc_BA3C:
	move.b	#2,d0
	move.b	#0,d1
	move.b	#2,d2
	lea	Palettes,a2
	adda.l	#(Pal_MainMenuShadow-Palettes),a2
	jsr	(FadeToPal_StepCount).l
	lea	(sub_BADA).l,a1
	jsr	FindActorSlot
	bcc.w	loc_BA6C
	rts
; -----------------------------------------------------------------------------------------

loc_BA6C:
	jsr	(sub_BAB2).l
	move.b	#$80,6(a1)
	move.b	#$40,8(a1)
	move.b	#$3E,9(a1)
	move.w	#$C0,$A(a1)
	move.w	#$D0,$E(a1)
	move.b	(byte_FF0105).l,$27(a1)
	move.w	#0,$2A(a1)
	move.l	#byte_BC02,$32(a1)
	bra.w	loc_BD98
; -----------------------------------------------------------------------------------------

loc_BAAA:
	moveq	#$C,d0
	jmp	QueuePlaneCmdList

; =============== S U B	R O U T	I N E =====================================================


sub_BAB2:
	move.w	$26(a0),d0
	addi.w	#$C,d0
	jmp	QueuePlaneCmdList
; End of function sub_BAB2


; =============== S U B	R O U T	I N E =====================================================


sub_BAC0:
	moveq	#$10,d0
	jmp	QueuePlaneCmdList
; End of function sub_BAC0


; =============== S U B	R O U T	I N E =====================================================


sub_BAC8:
	move.w	$26(a0),d0
	andi.w	#1,d0
	addi.w	#$10,d0
	jmp	QueuePlaneCmdList
; End of function sub_BAC8


; =============== S U B	R O U T	I N E =====================================================


sub_BADA:
	move.w	#$100,d4
	move.w	#$D61C,d5
	move.w	#$8500,d6
	move.w	#$280,$28(a0)
	bsr.s	sub_BAB2
	jsr	(ActorBookmark).l
	jsr	(nullsub_3).l
	bsr.w	sub_BB50
	jsr	(ActorAnimate).l
	jsr	(GetCtrlData).l
	move.b	d0,d1
	andi.b	#$F0,d0
	bne.w	loc_BB62
	btst	#0,d1
	bne.w	loc_BB26
	btst	#1,d1
	bne.w	loc_BB36
	rts
; -----------------------------------------------------------------------------------------

loc_BB26:
	tst.w	$26(a0)
	beq.w	loc_BB4C
	subq.w	#1,$26(a0)
	bra.w	loc_BB44
; -----------------------------------------------------------------------------------------

loc_BB36:
	cmpi.w	#3,$26(a0)
	bcc.w	loc_BB4C
	addq.w	#1,$26(a0)

loc_BB44:
	move.b	#$42,d0
	bsr.w	PlaySound_ChkSamp

loc_BB4C:
	bra.w	sub_BAB2
; End of function sub_BADA


; =============== S U B	R O U T	I N E =====================================================


sub_BB50:
	move.w	$26(a0),d0
	mulu.w	#$18,d0
	addi.w	#$D0,d0
	move.w	d0,$E(a0)
	rts
; End of function sub_BB50

; -----------------------------------------------------------------------------------------
; START	OF FUNCTION CHUNK FOR sub_BADA

loc_BB62:
	bsr.w	sub_BCC2
	bcc.w	loc_BB7A
	jsr	(nullsub_3).l
	move.b	#$67,d0
	jmp	PlaySound_ChkSamp
; -----------------------------------------------------------------------------------------

loc_BB7A:
	jsr	(nullsub_3).l
	move.b	$27(a0),(byte_FF0105).l
	move.b	#SFX_MENU_SELECT,d0
	bsr.w	PlaySound_ChkSamp
	clr.w	$28(a0)
	jsr	(ActorBookmark).l
	jsr	(nullsub_3).l
	move.w	#$10,$28(a0)
	jsr	(ActorBookmark).l
	jsr	(nullsub_3).l
	move.w	$28(a0),d0
	ror.b	#2,d0
	andi.b	#$80,d0
	move.b	d0,6(a0)
	subq.w	#1,$28(a0)
	beq.w	loc_BBCA
	rts
; -----------------------------------------------------------------------------------------

loc_BBCA:
	move.w	$26(a0),d0
	move.b	StageModes(pc,d0.w),d1
	move.b	d1,stage_mode
	move.b	d1,bytecode_flag
	beq.w	loc_BDFE
	cmpi.b	#3,d1
	beq.w	loc_BBF0
	clr.b	swap_fields

loc_BBF0:
	clr.b	(bytecode_disabled).l
	jmp	(ActorDeleteSelf).l
; END OF FUNCTION CHUNK	FOR sub_BADA
; -----------------------------------------------------------------------------------------
StageModes
	dc.b	0
	dc.b	1
	dc.b	2
	dc.b	3
	dc.b	4
	dc.b	0
byte_BC02
	dc.b	4
	dc.b	$3E
	dc.b	4
	dc.b	$3F
	dc.b	4
	dc.b	$3E
	dc.b	4
	dc.b	$40
	dc.b	8
	dc.b	$3E
	dc.b	4
	dc.b	$3F
	dc.b	4
	dc.b	$3E
	dc.b	4
	dc.b	$40
	dc.b	$3C
	dc.b	$3E
	dc.b	4
	dc.b	$3E
	dc.b	4
	dc.b	$3F
	dc.b	4
	dc.b	$3E
	dc.b	4
	dc.b	$40
	dc.b	8
	dc.b	$3E
	dc.b	4
	dc.b	$3F
	dc.b	4
	dc.b	$3E
	dc.b	4
	dc.b	$40
	dc.b	$3C
	dc.b	$3E
	dc.b	4
	dc.b	$3E
	dc.b	2
	dc.b	$41
	dc.b	4
	dc.b	$3E
	dc.b	2
	dc.b	$41
	dc.b	$50
	dc.b	$3E
	dc.b	4
	dc.b	$3F
	dc.b	4
	dc.b	$3E
	dc.b	4
	dc.b	$40
	dc.b	8
	dc.b	$3E
	dc.b	4
	dc.b	$3F
	dc.b	4
	dc.b	$3E
	dc.b	4
	dc.b	$40
	dc.b	$3C
	dc.b	$3E
	dc.b	4
	dc.b	$3E
	dc.b	2
	dc.b	$41
	dc.b	$50
	dc.b	$3E
	dc.b	4
	dc.b	$3F
	dc.b	4
	dc.b	$3E
	dc.b	4
	dc.b	$40
	dc.b	8
	dc.b	$3E
	dc.b	4
	dc.b	$3F
	dc.b	4
	dc.b	$3E
	dc.b	4
	dc.b	$40
	dc.b	$3C
	dc.b	$3E
	dc.b	$FF
	dc.b	0
	dc.l	byte_BC02

; =============== S U B	R O U T	I N E =====================================================


nullsub_3:
	rts
; End of function nullsub_3

; -----------------------------------------------------------------------------------------
	move.w	$2A(a0),d0
	jsr	(sub_BC82).l
	move.w	d0,$2A(a0)
	lea	((palette_buffer+$60)).l,a2
	move.w	d1,$1A(a2)
	move.w	d1,$1C(a2)
	moveq	#3,d0
	jmp	LoadPalette

; =============== S U B	R O U T	I N E =====================================================


sub_BC82:
	addq.w	#1,d0
	cmpi.w	#$15,d0
	bmi.s	loc_BC8C
	moveq	#0,d0

loc_BC8C:
	move.w	d0,d1
	add.w	d1,d1
	move.w	unk_BC96(pc,d1.w),d1
	rts
; End of function sub_BC82

; -----------------------------------------------------------------------------------------
unk_BC96
	dc.b	$E
	dc.b	$E0
	dc.b	$C
	dc.b	$E2
	dc.b	$A
	dc.b	$E4
	dc.b	8
	dc.b	$E6
	dc.b	6
	dc.b	$E8
	dc.b	4
	dc.b	$EA
	dc.b	2
	dc.b	$EC
	dc.b	0
	dc.b	$EE
	dc.b	2
	dc.b	$CE
	dc.b	4
	dc.b	$AE
	dc.b	6
	dc.b	$8E
	dc.b	8
	dc.b	$6E
	dc.b	$A
	dc.b	$4E
	dc.b	$C
	dc.b	$2E
	dc.b	$E
	dc.b	$E
	dc.b	$E
	dc.b	$2C
	dc.b	$E
	dc.b	$4A
	dc.b	$E
	dc.b	$68
	dc.b	$E
	dc.b	$86
	dc.b	$E
	dc.b	$A4
	dc.b	$E
	dc.b	$C2
	dc.b	$FF
	dc.b	$FF

; =============== S U B	R O U T	I N E =====================================================


sub_BCC2:
	cmpi.w	#1,$26(a0)
	bne.w	loc_BCDC
	bsr.w	sub_BCE2
	tst.b	d0
	beq.w	loc_BCDC
	ori	#1,sr
	rts
; -----------------------------------------------------------------------------------------

loc_BCDC:
	andi	#$FFFE,sr
	rts
; End of function sub_BCC2


; =============== S U B	R O U T	I N E =====================================================


sub_BCE2:
	DISABLE_INTS
	move.w	#$100,Z80_BUS

loc_BCEE:
	nop
	nop
	nop
	nop
	btst	#0,Z80_BUS
	bne.s	loc_BCEE
	bsr.w	sub_BD24
	move.w	#0,Z80_BUS

loc_BD0C:
	nop
	nop
	nop
	nop
	btst	#0,Z80_BUS
	beq.s	loc_BD0C
	ENABLE_INTS
	rts
; End of function sub_BCE2


; =============== S U B	R O U T	I N E =====================================================


sub_BD24:
	lea	PORT_A_DATA,a1
	bsr.w	sub_BD44
	lea	PORT_B_DATA,a1
	movem.l	d0,-(sp)
	bsr.w	sub_BD44
	movem.l	(sp)+,d1
	or.b	d1,d0
	rts
; End of function sub_BD24


; =============== S U B	R O U T	I N E =====================================================


sub_BD44:
	move.b	#0,(a1)
	nop
	nop
	move.b	(a1),d0
	andi.b	#$F,d0
	move.b	#$40,(a1)
	nop
	nop
	move.b	(a1),d1
	lsl.b	#4,d1
	andi.b	#$F0,d1
	or.b	d1,d0
	moveq	#0,d1
	move.w	#3,d2

loc_BD6A:
	lsl.b	#1,d1
	movem.l	d0,-(sp)
	andi.b	#$C0,d0
	beq.w	loc_BD7C
	ori.b	#1,d1

loc_BD7C:
	movem.l	(sp)+,d0
	lsl.b	#2,d0
	dbf	d2,loc_BD6A
	move.b	#0,d0
	cmpi.b	#$D,d1
	beq.w	locret_BD96
	move.b	#$FF,d0

locret_BD96:
	rts
; End of function sub_BD44

; -----------------------------------------------------------------------------------------

loc_BD98:
	lea	(loc_BDA4).l,a1
	jmp	FindActorSlot
; -----------------------------------------------------------------------------------------

loc_BDA4:
	addq.w	#1,$26(a0)
	move.w	$26(a0),d1
	lea	((hscroll_buffer+2)).l,a1
	lea	(word_BDF4).l,a2

loc_BDB8:
	move.w	(a2)+,d0
	bmi.s	locret_BDC8

loc_BDBC:
	move.w	d1,(a1)+
	addq.w	#2,a1
	dbf	d0,loc_BDBC
	asr.w	#1,d1
	bra.s	loc_BDB8
; -----------------------------------------------------------------------------------------

locret_BDC8:
	rts

; =============== S U B	R O U T	I N E =====================================================


sub_BDCA:
	movem.l	d0-a6,-(sp)
	move.w	#$80,d0
	moveq	#0,d1
	lea	((hscroll_buffer+2)).l,a2

loc_BDDA:
	move.w	d1,(a2)+
	addq.w	#2,a2
	dbf	d0,loc_BDDA
	movea.l	(dword_FF112C).l,a1
	jsr	(ActorDeleteOther).l
	movem.l	(sp)+,d0-a6
	rts
; End of function sub_BDCA

; -----------------------------------------------------------------------------------------
word_BDF4
	dc.w	$28
	dc.w	$18
	dc.w	$18
	dc.w	$20
	dc.w	$FFFF
; -----------------------------------------------------------------------------------------
; START	OF FUNCTION CHUNK FOR sub_BADA

loc_BDFE:
	move.b	#$80,6(a0)
	move.w	#$220,$A(a0)
	move.w	#$D8,$E(a0)
	move.b	#1,opponent
	move.w	#$28,$26(a0)
	jsr	(ActorBookmark).l
	move.w	#$B7,d0
	lea	((hscroll_buffer+$40)).l,a1

loc_BE2E:
	subq.w	#8,(a1)+
	addq.w	#2,a1
	dbf	d0,loc_BE2E
	subq.w	#8,$A(a0)
	subq.w	#1,$26(a0)
	beq.w	loc_BE44
	rts
; -----------------------------------------------------------------------------------------

loc_BE44:
	jsr	(ActorBookmark).l
	jsr	(ActorAnimate).l
	jsr	(GetCtrlData).l
	andi.b	#$F0,d0
	bne.w	loc_BEB4
	jsr	(GetCtrlData).l
	btst	#0,d0
	bne.w	loc_BE76
	btst	#1,d0
	bne.w	loc_BE8E
	rts
; -----------------------------------------------------------------------------------------

loc_BE76:
	tst.w	$26(a0)
	beq.w	locret_BEB2
	move.w	#0,$26(a0)
	move.w	#$D8,$E(a0)
	bra.w	loc_BEA2
; -----------------------------------------------------------------------------------------

loc_BE8E:
	tst.w	$26(a0)
	bne.w	locret_BEB2
	move.w	#1,$26(a0)
	move.w	#$F0,$E(a0)

loc_BEA2:
	jsr	(sub_BAC8).l
	move.b	#$42,d0
	bsr.w	PlaySound_ChkSamp
	bra.s	loc_BE44
; -----------------------------------------------------------------------------------------

locret_BEB2:
	rts
; -----------------------------------------------------------------------------------------

loc_BEB4:
	move.b	#$41,d0
	bsr.w	PlaySound_ChkSamp
	clr.w	$28(a0)
	jsr	(ActorBookmark).l
	move.w	#$10,$28(a0)
	jsr	(ActorBookmark).l
	move.w	$28(a0),d0
	ror.b	#2,d0
	andi.b	#$80,d0
	move.b	d0,6(a0)
	subq.w	#1,$28(a0)
	beq.w	loc_BEEA
	rts
; -----------------------------------------------------------------------------------------

loc_BEEA:
	move.b	#1,(byte_FF0114).l
	move.b	(com_level).l,(difficulty).l
	move.b	#3,stage
	bsr.w	sub_DF74
	bsr.w	ClearOpponentDefeats
	move.w	$26(a0),d0
	lsl.w	#2,d0
	move.b	#0,stage_mode
	move.b	d0,bytecode_flag
	clr.b	(bytecode_disabled).l
	jsr	(ActorBookmark).l
	rts
; END OF FUNCTION CHUNK	FOR sub_BADA

; =============== S U B	R O U T	I N E =====================================================


ClearOpponentDefeats:
	lea	opponents_defeated,a2
	move.w	#3,d0
	moveq	#0,d1

loc_BF3A:
	move.l	d1,(a2)+
	dbf	d0,loc_BF3A
	rts
; End of function ClearOpponentDefeats

; -----------------------------------------------------------------------------------------
	lea	(loc_BF6A).l,a1
	jsr	FindActorSlot
	bcs.w	locret_BF68
	move.l	a0,$2E(a1)
	move.b	#6,8(a1)
	move.b	#4,9(a1)
	move.w	#$A0,$A(a1)

locret_BF68:
	rts
; -----------------------------------------------------------------------------------------

loc_BF6A:
	movea.l	$2E(a0),a1
	tst.w	$26(a1)
	beq.w	loc_BF7E
	move.b	#0,6(a0)
	rts
; -----------------------------------------------------------------------------------------

loc_BF7E:
	move.b	#$80,6(a0)
	move.b	$36(a0),d0
	ori.b	#$80,d0
	move.w	#$400,d1
	jsr	(Sin).l
	swap	d2
	addi.w	#$118,d2
	move.w	d2,$E(a0)
	addq.b	#6,$36(a0)
	rts

; =============== S U B	R O U T	I N E =====================================================


sub_BFA6:
	lea	(loc_C00A).l,a1
	jsr	FindActorSlot
	bcc.w	loc_BFB8
	rts
; -----------------------------------------------------------------------------------------

loc_BFB8:
	move.l	a0,$2E(a1)
	move.b	#3,7(a0)
	move.w	d0,$A(a1)
	move.b	$2A(a0),$2A(a1)
	move.w	#$780,$28(a1)
	movem.l	d0/a0,-(sp)
	movea.l	a1,a0
	move.w	#$80,d4
	clr.w	d0
	move.b	swap_fields,d0
	lsl.b	#1,d0
	or.b	$2A(a0),d0
	lsl.w	#2,d0
	move.w	word_BFFA(pc,d0.w),d5
	move.w	word_BFFC(pc,d0.w),d6
	movem.l	(sp)+,d0/a0
	rts
; End of function sub_BFA6

; -----------------------------------------------------------------------------------------
word_BFFA
	dc.w	$CC0A
word_BFFC
	dc.w	$8500
	dc.w	$CC3A
	dc.w	$A500
	dc.w	$CC3A
	dc.w	$8500
	dc.w	$CC0A
	dc.w	$A500
; -----------------------------------------------------------------------------------------

loc_C00A:
	bsr.w	GetPuyoField
	move.w	d0,d5
	addi.w	#$606,d5
	lea	(unk_C156).l,a1
	bsr.w	sub_C1D0
	move.b	$B(a0),d0
	addi.b	#$21,d0
	bsr.w	sub_C1E8
	bsr.w	GetPuyoField
	move.w	d0,d5
	addi.w	#$702,d5
	lea	(unk_C15C).l,a1
	bsr.w	sub_C1D0
	move.b	#0,d0
	bsr.w	PlaySound_ChkSamp
	jsr	(ActorBookmark).l
	move.w	#4,d0

loc_C050:
	move.b	#1,$12(a0,d0.w)
	dbf	d0,loc_C050
	jsr	(ActorBookmark).l
	clr.b	d0
	bsr.w	sub_C168
	addq.b	#1,$26(a0)
	bsr.w	GetFieldCtrlData
	btst	#2,d0
	bne.w	loc_C0E2
	andi.b	#$70,d0
	bne.w	loc_C0CA
	btst	#1,d1
	bne.w	loc_C090
	btst	#0,d1
	bne.w	loc_C0AC
	rts
; -----------------------------------------------------------------------------------------

loc_C090:
	move.w	$E(a0),d0
	addq.b	#1,$12(a0,d0.w)
	cmpi.b	#$1B,$12(a0,d0.w)
	bcs.w	loc_C0BE
	move.b	#0,$12(a0,d0.w)
	bra.w	loc_C0BE
; -----------------------------------------------------------------------------------------

loc_C0AC:
	move.w	$E(a0),d0
	subq.b	#1,$12(a0,d0.w)
	bpl.w	loc_C0BE
	move.b	#$1A,$12(a0,d0.w)

loc_C0BE:
	clr.b	$26(a0)
	move.b	#$42,d0
	bra.w	PlaySound_ChkSamp
; -----------------------------------------------------------------------------------------

loc_C0CA:
	addq.w	#1,$E(a0)
	move.b	#$41,d0
	bsr.w	PlaySound_ChkSamp
	cmpi.w	#3,$E(a0)
	bcc.w	loc_C0F8
	rts
; -----------------------------------------------------------------------------------------

loc_C0E2:
	tst.w	$E(a0)
	bne.w	loc_C0EC
	rts
; -----------------------------------------------------------------------------------------

loc_C0EC:
	subq.w	#1,$E(a0)
	move.b	#$42,d0
	bra.w	PlaySound_ChkSamp
; -----------------------------------------------------------------------------------------

loc_C0F8:
	move.w	$A(a0),d0
	bsr.w	GetHighScoreEntry
	movea.l	$2E(a0),a2

loc_C104:
	move.l	6(a1),d1
	cmp.l	$A(a2),d1
	beq.w	loc_C126
	adda.l	#$10,a1
	addq.w	#1,$A(a0)
	cmpi.w	#5,$A(a0)
	bcs.s	loc_C104
	bra.w	loc_C12A
; -----------------------------------------------------------------------------------------

loc_C126:
	bsr.w	sub_C420

loc_C12A:
	clr.w	$28(a0)
	move.w	#$20,d0
	jsr	(ActorBookmark_SetDelay).l
	move.b	$25(a0),d0
	bsr.w	sub_C168
	jsr	(ActorBookmark).l
	movea.l	$2E(a0),a1
	bclr	#1,7(a1)
	jmp	(ActorDeleteSelf).l
; -----------------------------------------------------------------------------------------
unk_C156
	dc.b	$12
	dc.b	1
	dc.b	$E
	dc.b	$B
	dc.b	0
	dc.b	$FF
unk_C15C
	dc.b	$19
	dc.b	$F
	dc.b	$15
	dc.b	$12
	dc.b	0
	dc.b	$E
	dc.b	1
	dc.b	$D
	dc.b	5
	dc.b	$1B
	dc.b	$FF
	dc.b	0

; =============== S U B	R O U T	I N E =====================================================


sub_C168:
	movem.l	d0,-(sp)
	bsr.w	GetPuyoField
	move.w	d0,d5
	addi.w	#$888,d5
	movem.l	(sp)+,d2
	clr.w	d1

loc_C17C:
	move.b	$12(a0,d1.w),d0
	bsr.w	sub_C1A8
	btst	#0,d2
	beq.w	loc_C18E
	clr.b	d0

loc_C18E:
	movem.l	d1-d2,-(sp)
	bsr.w	sub_C1E8
	movem.l	(sp)+,d1-d2
	subi.w	#$7E,d5
	addq.w	#1,d1
	cmpi.w	#3,d1
	bcs.s	loc_C17C
	rts
; End of function sub_C168


; =============== S U B	R O U T	I N E =====================================================


sub_C1A8:
	cmp.w	$E(a0),d1
	bcc.w	loc_C1B2
	rts
; -----------------------------------------------------------------------------------------

loc_C1B2:
	beq.w	loc_C1BC
	move.b	#$1C,d0
	rts
; -----------------------------------------------------------------------------------------

loc_C1BC:
	move.b	$26(a0),d3
	lsr.b	#3,d3
	andi.b	#1,d3
	eori.b	#1,d3
	neg.b	d3
	and.b	d3,d0
	rts
; End of function sub_C1A8


; =============== S U B	R O U T	I N E =====================================================


sub_C1D0:
	move.b	(a1)+,d0
	bmi.w	locret_C1E6
	movem.l	d5,-(sp)
	bsr.w	sub_C1E8
	movem.l	(sp)+,d5
	addq.w	#2,d5
	bra.s	sub_C1D0
; -----------------------------------------------------------------------------------------

locret_C1E6:
	rts
; End of function sub_C1D0


; =============== S U B	R O U T	I N E =====================================================


sub_C1E8:
	move.w	#$C500,d1
	move.w	d1,d2
	tst.b	d0
	beq.w	loc_C204
	addi.b	#$3F,d0
	cmpi.b	#$5F,d0
	bcs.w	loc_C204
	subi.b	#$29,d0

loc_C204:
	lsl.b	#1,d0
	move.b	d0,d1
	move.b	d0,d2
	addq.b	#1,d2
	cmpi.b	#$B6,d1
	bne.w	loc_C226
	move.b	d1,d2
	clr.b	d1
	move.b	(frame_count+1).l,d0
	lsr.b	#3,d0
	andi.b	#1,d0
	or.b	d0,d2

loc_C226:
	DISABLE_INTS
	jsr	SetVRAMWrite
	addi.w	#$80,d5
	move.w	d1,VDP_DATA
	jsr	SetVRAMWrite
	move.w	d2,VDP_DATA
	ENABLE_INTS
	rts
; End of function sub_C1E8


; =============== S U B	R O U T	I N E =====================================================


sub_C24C:
	lea	(sub_C28A).l,a1
	jsr	FindActorSlot
	bcc.w	loc_C25E
	rts
; -----------------------------------------------------------------------------------------

loc_C25E:
	move.l	a0,$2E(a1)
	move.b	#$FF,7(a0)
	move.w	d0,$A(a1)
	move.w	#$780,$28(a1)
	movem.l	a0,-(sp)
	movea.l	a1,a0
	move.w	#$100,d4
	move.w	#$C80C,d5
	move.w	#$C500,d6
	movem.l	(sp)+,a0
	rts
; End of function sub_C24C


; =============== S U B	R O U T	I N E =====================================================


sub_C28A:
	move.b	#$FF,7(a0)
	bsr.w	sub_C4BA
	move.w	#4,d0

loc_C298:
	move.b	#1,$12(a0,d0.w)
	dbf	d0,loc_C298

loc_C2A2:
	move.l	#unk_C3DC,$32(a0)
	jsr	(ActorBookmark).l
	jsr	(ActorAnimate).l
	bcs.w	loc_C2BE
	bra.w	sub_C3F0
; -----------------------------------------------------------------------------------------

loc_C2BE:
	jsr	(ActorBookmark).l
	addq.b	#1,$26(a0)
	move.b	p1_ctrl+ctlPress,d0
	or.b	p2_ctrl+ctlPress,d0
	btst	#2,d0
	bne.w	loc_C374
	andi.b	#$70,d0
	bne.w	loc_C350
	move.b	(p1_ctrl+ctlPulse).l,d0
	or.b	(p2_ctrl+ctlPulse).l,d0
	btst	#1,d0
	bne.w	loc_C316
	btst	#0,d0
	bne.w	loc_C332
	move.b	$26(a0),d0
	lsl.b	#1,d0
	andi.b	#$20,d0
	ori.b	#$80,d0
	move.b	d0,9(a0)
	bra.w	sub_C3F0
; -----------------------------------------------------------------------------------------

loc_C316:
	move.w	$E(a0),d0
	addq.b	#1,$12(a0,d0.w)
	cmpi.b	#$1C,$12(a0,d0.w)
	bcs.w	loc_C344
	move.b	#0,$12(a0,d0.w)
	bra.w	loc_C344
; -----------------------------------------------------------------------------------------

loc_C332:
	move.w	$E(a0),d0
	subq.b	#1,$12(a0,d0.w)
	bpl.w	loc_C344
	move.b	#$1C,$12(a0,d0.w)

loc_C344:
	clr.b	$26(a0)
	move.b	#$42,d0
	bra.w	PlaySound_ChkSamp
; -----------------------------------------------------------------------------------------

loc_C350:
	move.b	#$80,9(a0)
	bsr.w	sub_C3F0
	addq.w	#1,$E(a0)
	move.b	#$41,d0
	bsr.w	PlaySound_ChkSamp
	cmpi.w	#3,$E(a0)
	bcc.w	loc_C3AA
	bra.w	loc_C2A2
; -----------------------------------------------------------------------------------------

loc_C374:
	tst.w	$E(a0)
	bne.w	loc_C37E
	rts
; -----------------------------------------------------------------------------------------

loc_C37E:
	move.l	#unk_C3E6,$32(a0)
	jsr	(ActorBookmark).l
	jsr	(ActorAnimate).l
	bcs.w	loc_C39A
	bra.w	sub_C3F0
; -----------------------------------------------------------------------------------------

loc_C39A:
	subq.w	#1,$E(a0)
	move.b	#$42,d0
	bsr.w	PlaySound_ChkSamp
	bra.w	loc_C2A2
; -----------------------------------------------------------------------------------------

loc_C3AA:
	move.w	$A(a0),d0
	bsr.w	GetHighScoreEntry
	bsr.w	sub_C420
	clr.b	7(a0)
	clr.w	$28(a0)
	move.w	#$20,d0
	jsr	(ActorBookmark_SetDelay).l
	jsr	(ActorBookmark).l
	movea.l	$2E(a0),a1
	clr.b	7(a1)
	jmp	(ActorDeleteSelf).l
; End of function sub_C28A

; -----------------------------------------------------------------------------------------
unk_C3DC
	dc.b	0
	dc.b	0
	dc.b	3
	dc.b	$1F
	dc.b	3
	dc.b	$A0
	dc.b	2
	dc.b	$80
	dc.b	$FE
	dc.b	0
unk_C3E6
	dc.b	0
	dc.b	$80
	dc.b	3
	dc.b	$A0
	dc.b	3
	dc.b	$1F
	dc.b	0
	dc.b	0
	dc.b	$FE
	dc.b	0

; =============== S U B	R O U T	I N E =====================================================


sub_C3F0:
	move.w	$A(a0),d0
	bsr.w	GetHighScoreEntry
	move.w	$E(a0),d0
	lsl.w	#2,d0
	add.w	d0,d5
	move.w	$E(a0),d1
	move.b	$12(a0,d1.w),d0
	move.b	9(a0),d1
	bmi.w	loc_C416
	move.b	d1,d0
	bra.w	sub_C800
; -----------------------------------------------------------------------------------------

loc_C416:
	andi.b	#$7F,d1
	add.b	d1,d0
	bra.w	sub_C800
; End of function sub_C3F0


; =============== S U B	R O U T	I N E =====================================================


sub_C420:
	clr.w	d0

loc_C422:
	move.b	$12(a0,d0.w),(a1)+
	addq.w	#1,d0
	cmpi.w	#3,d0
	bcs.s	loc_C422
	move.b	#$FF,(a1)
	jmp	(SaveData).l
; End of function sub_C420


; =============== S U B	R O U T	I N E =====================================================


sub_C438:
	cmpi.b	#4,high_score_table_id
	bcs.w	loc_C44A
	andi	#$FFFE,sr
	rts
; -----------------------------------------------------------------------------------------

loc_C44A:
	clr.w	d0
	bsr.w	GetHighScoreEntry
	movea.l	a1,a2
	clr.w	d0

loc_C454:
	move.l	6(a1),d1
	cmp.l	$A(a0),d1
	bcs.w	loc_C474
	adda.l	#$10,a1
	addq.w	#1,d0
	cmpi.w	#5,d0
	bcs.s	loc_C454
	andi	#$FFFE,sr
	rts
; -----------------------------------------------------------------------------------------

loc_C474:
	movem.l	d0/a1,-(sp)
	move.w	#3,d1
	sub.w	d0,d1
	bcs.w	loc_C49E
	movea.l	a2,a1
	adda.l	#$40,a1
	adda.l	#$50,a2

loc_C490:
	move.w	#7,d0

loc_C494:
	move.w	-(a1),-(a2)
	dbf	d0,loc_C494
	dbf	d1,loc_C490

loc_C49E:
	movem.l	(sp)+,d0/a1
	move.b	#$FF,0(a1)
	move.l	$A(a0),6(a1)
	move.w	$16(a0),$A(a1)
	ori	#1,sr
	rts
; End of function sub_C438


; =============== S U B	R O U T	I N E =====================================================


sub_C4BA:
	move.w	$A(a0),d0
	bsr.w	GetHighScoreEntry
	move.w	#1,d0
	move.w	#$C8,d1

loc_C4CA:
	lea	(loc_C506).l,a1
	jsr	FindActorSlot
	bcs.w	loc_C4F8
	move.b	#3,8(a1)
	move.l	#unk_C536,$32(a1)
	move.l	a0,$2E(a1)
	move.w	d0,$1E(a1)
	move.w	d1,$A(a1)
	move.w	d4,$E(a1)

loc_C4F8:
	addi.w	#$10,d1
	addq.w	#1,d0
	cmpi.w	#3,d0
	bcs.s	loc_C4CA
	rts
; End of function sub_C4BA

; -----------------------------------------------------------------------------------------

loc_C506:
	movea.l	$2E(a0),a1
	tst.b	7(a1)
	bne.w	loc_C518
	jmp	(ActorDeleteSelf).l
; -----------------------------------------------------------------------------------------

loc_C518:
	move.b	#$80,6(a0)
	move.w	$E(a1),d0
	cmp.w	$1E(a0),d0
	bcs.w	loc_C530
	move.b	#0,6(a0)

loc_C530:
	jmp	(ActorAnimate).l
; -----------------------------------------------------------------------------------------
unk_C536
	dc.b	$F0
	dc.b	0
	dc.b	1
	dc.b	2
	dc.b	0
	dc.b	0
	dc.b	2
	dc.b	3
	dc.b	0
	dc.b	0
	dc.b	1
	dc.b	2
	dc.b	0
	dc.b	0
	dc.b	2
	dc.b	3
	dc.b	$FF
	dc.b	0
	dc.l	unk_C536
; -----------------------------------------------------------------------------------------

loc_C54C:
	jsr	(ClearScroll).l
	lea	(loc_C66A).l,a1
	jmp	FindActorSlot

; =============== S U B	R O U T	I N E =====================================================


HighScores_PrintNames:
	move.w	#4,d0

loc_C562:
	movem.l	d0,-(sp)
	bsr.w	GetHighScoreEntry
	move.b	0(a1),$A(a0,d0.w)
	bpl.w	loc_C57A
	move.b	#$FF,$F(a0)

loc_C57A:
	bsr.w	sub_C7B2
	movem.l	(sp)+,d0
	dbf	d0,loc_C562
	rts
; End of function HighScores_PrintNames


; =============== S U B	R O U T	I N E =====================================================


sub_C588:
	move.w	#4,d0

loc_C58C:
	movem.l	d0,-(sp)
	bsr.w	GetHighScoreEntry
	move.l	6(a1),d2
	jsr	(sub_1B350).l
	addi.w	#$14,d5
	move.w	#7,d3
	lea	(byte_FF1982).l,a1
	bsr.w	loc_C5EE
	movem.l	(sp)+,d0
	dbf	d0,loc_C58C
	rts
; End of function sub_C588


; =============== S U B	R O U T	I N E =====================================================


sub_C5BA:
	move.w	#4,d0

loc_C5BE:
	movem.l	d0,-(sp)
	bsr.w	GetHighScoreEntry
	clr.l	d2
	move.w	$A(a1),d2
	jsr	(sub_1B350).l
	addi.w	#$30,d5
	move.w	#4,d3
	lea	((byte_FF1982+3)).l,a1
	bsr.w	loc_C5EE
	movem.l	(sp)+,d0
	dbf	d0,loc_C5BE
	rts
; End of function sub_C5BA

; -----------------------------------------------------------------------------------------

loc_C5EE:
	clr.b	d1
	DISABLE_INTS

loc_C5F4:
	move.w	#$A500,d0
	move.b	(a1)+,d0
	beq.w	loc_C602
	move.b	#1,d1

loc_C602:
	add.b	d1,d0
	lsl.b	#1,d0
	jsr	SetVRAMWrite
	addi.w	#$100,d5
	move.w	d0,VDP_DATA
	addq.b	#1,d0
	jsr	SetVRAMWrite
	subi.w	#$FE,d5
	move.w	d0,VDP_DATA
	dbf	d3,loc_C5F4
	ENABLE_INTS
	rts

; =============== S U B	R O U T	I N E =====================================================


GetHighScoreEntry:
	movem.l	d1-d2,-(sp)
	lea	(high_scores).l,a1
	move.w	d0,d1
	lsl.w	#4,d1
	clr.w	d2
	move.b	high_score_table_id,d2
	mulu.w	#$50,d2
	add.w	d1,d2
	adda.l	d2,a1
	move.w	d0,d5
	mulu.w	#$300,d5
	addi.w	#$CA0C,d5
	move.w	d0,d4
	mulu.w	#$18,d4
	addi.w	#$D8,d4
	movem.l	(sp)+,d1-d2
	rts
; End of function GetHighScoreEntry

; -----------------------------------------------------------------------------------------

loc_C66A:
	move.w	#$140,d1
	move.w	#$13C,$26(a0)
	bsr.w	HighScores_SetScroll
	bsr.w	HighScores_PrintMode
	bsr.w	HighScores_PrintNames
	bsr.w	sub_C588
	bsr.w	sub_C5BA
	jsr	(ActorBookmark).l
	move.w	$26(a0),d1
	bsr.w	HighScores_SetScroll
	subq.w	#4,$26(a0)
	bcs.w	loc_C6D0
	tst.b	$F(a0)
	bne.w	locret_C6CE
	move.b	p1_ctrl+ctlPress,d0
	or.b	p2_ctrl+ctlPress,d0
	andi.b	#$F0,d0
	beq.w	locret_C6CE
	tst.b	$2A(a0)
	bne.w	locret_C6CE
	clr.b	(bytecode_disabled).l
	move.b	#$FF,$2A(a0)

locret_C6CE:
	rts
; -----------------------------------------------------------------------------------------

loc_C6D0:
	move.b	#$67,d0
	jsr	PlaySound_ChkSamp
	tst.b	(bytecode_disabled).l
	beq.w	loc_C700
	move.w	#4,d0

loc_C6E8:
	movem.l	d0,-(sp)
	tst.b	$A(a0,d0.w)
	bpl.w	loc_C6F8
	bsr.w	sub_C24C

loc_C6F8:
	movem.l	(sp)+,d0
	dbf	d0,loc_C6E8

loc_C700:
	move.w	#$100,d0
	jsr	(ActorBookmark_SetDelay).l
	jsr	(ActorBookmark_Ctrl).l
	tst.b	7(a0)
	beq.w	loc_C71A
	rts
; -----------------------------------------------------------------------------------------

loc_C71A:
	tst.b	(byte_FF1973).l
	beq.w	loc_C764
	addq.b	#1,high_score_table_id
	cmpi.b	#2,high_score_table_id
	beq.w	loc_C764
	move.w	#$140,d1
	move.w	d1,$26(a0)
	jsr	(ActorBookmark).l
	move.w	$26(a0),d1
	subi.w	#$140,d1
	bsr.w	HighScores_SetScroll
	subq.w	#4,$26(a0)
	beq.w	loc_C75A
	rts
; -----------------------------------------------------------------------------------------

loc_C75A:
	jsr	(ActorBookmark).l
	bra.w	loc_C66A
; -----------------------------------------------------------------------------------------

loc_C764:
	tst.b	$2A(a0)
	bne.w	loc_C772
	clr.b	(bytecode_disabled).l

loc_C772:
	jmp	(ActorDeleteSelf).l

; =============== S U B	R O U T	I N E =====================================================


HighScores_SetScroll:
	lea	((hscroll_buffer+$140)).l,a1
	move.w	#$6F,d0

loc_C782:
	move.w	d1,(a1)+
	move.w	#0,(a1)+
	dbf	d0,loc_C782
	rts
; End of function HighScores_SetScroll

; -----------------------------------------------------------------------------------------
off_C78E
	dc.l	unk_C796
	dc.l	unk_C7A4
unk_C796
	dc.b	$13
	dc.b	3
	dc.b	5
	dc.b	$E
	dc.b	1
	dc.b	$12
	dc.b	9
	dc.b	$F
	dc.b	0
	dc.b	$D
	dc.b	$F
	dc.b	4
	dc.b	5
	dc.b	$FF
unk_C7A4
	dc.b	5
	dc.b	$18
	dc.b	5
	dc.b	$12
	dc.b	3
	dc.b	9
	dc.b	$13
	dc.b	5
	dc.b	0
	dc.b	$D
	dc.b	$F
	dc.b	4
	dc.b	5
	dc.b	$FF

; =============== S U B	R O U T	I N E =====================================================


sub_C7B2:
	move.b	(a1)+,d0
	bmi.w	locret_C7C8
	movem.l	d5,-(sp)
	bsr.w	sub_C800
	movem.l	(sp)+,d5
	addq.w	#4,d5
	bra.s	sub_C7B2
; -----------------------------------------------------------------------------------------

locret_C7C8:
	rts
; End of function sub_C7B2


; =============== S U B	R O U T	I N E =====================================================


HighScores_PrintMode:
	moveq	#0,d0
	move.b	high_score_table_id,d0
	lea	(off_C78E).l,a2
	lsl.w	#2,d0
	movea.l	(a2,d0.w),a1
	move.w	#$D90E,d5

loc_C7E2:
	move.b	(a1)+,d0
	bmi.s	locret_C7F6
	movem.l	d5,-(sp)
	bsr.w	sub_C7F8
	movem.l	(sp)+,d5
	addq.w	#4,d5
	bra.s	loc_C7E2
; -----------------------------------------------------------------------------------------

locret_C7F6:
	rts
; End of function HighScores_PrintMode


; =============== S U B	R O U T	I N E =====================================================


sub_C7F8:
	move.w	#$A400,d1
	bra.w	loc_C804
; End of function sub_C7F8


; =============== S U B	R O U T	I N E =====================================================


sub_C800:
	move.w	#$C400,d1

loc_C804:
	movem.l	d1,-(sp)
	move.b	d0,d1
	andi.b	#$F,d0
	lsl.b	#1,d0
	andi.b	#$30,d1
	lsl.w	#2,d1
	or.b	d1,d0
	movem.l	(sp)+,d1
	move.b	d0,d1
	DISABLE_INTS
	jsr	SetVRAMWrite
	addi.w	#$100,d5
	move.w	d1,VDP_DATA
	addq.w	#1,d1
	move.w	d1,VDP_DATA
	addi.w	#$1F,d1
	jsr	SetVRAMWrite
	move.w	d1,VDP_DATA
	addq.w	#1,d1
	move.w	d1,VDP_DATA
	ENABLE_INTS
	rts
; End of function sub_C800


; =============== S U B	R O U T	I N E =====================================================


sub_C858:
	lea	(byte_FF143E).l,a1
	move.w	#7,d0

loc_C862:
	clr.b	(a1)+
	dbf	d0,loc_C862
	lea	(loc_B4B6).l,a1
	jsr	FindActorSlot
	lea	(loc_C882).l,a1
	jsr	FindActorSlot
	rts
; End of function sub_C858

; -----------------------------------------------------------------------------------------

loc_C882:
	move.w	#0,$26(a0)
	move.w	#$F0,d0
	jsr	(ActorBookmark_SetDelay).l
	jsr	(ActorBookmark).l

loc_C898:
	move.w	$26(a0),d0
	lea	(word_6F3FE).l,a2
	jsr	(sub_C968).l
	moveq	#0,d0
	jsr	LoadPalette
	lea	(word_6F85E).l,a2
	jsr	(sub_C968).l
	moveq	#1,d0
	jsr	LoadPalette
	move.w	#$C,d0
	jsr	(ActorBookmark_SetDelay).l
	jsr	(ActorBookmark).l
	addq.w	#1,$26(a0)
	move.w	$26(a0),d0
	cmpi.w	#$1B,d0
	bne.s	loc_C898
	moveq	#2,d0
	lea	(unk_C948).l,a2
	jsr	LoadPalette
	jsr	(sub_BDCA).l
	jsr	(sub_F794).l
	jsr	(ActorBookmark).l
	jsr	(sub_F7B8).l
	jsr	(ActorBookmark).l

loc_C90E:
	lea	(word_6F85E).l,a2
	jsr	(sub_C968).l
	moveq	#2,d0
	jsr	LoadPalette
	move.w	#$1E,d0
	jsr	(ActorBookmark_SetDelay).l
	jsr	(ActorBookmark).l
	addq.w	#1,$26(a0)
	move.w	$26(a0),d0
	cmpi.w	#$23,d0
	bne.s	loc_C90E
	jsr	(ActorBookmark).l
	rts
; -----------------------------------------------------------------------------------------
unk_C948
	dc.b	2
	dc.b	0
	dc.b	2
	dc.b	0
	dc.b	2
	dc.b	0
	dc.b	2
	dc.b	0
	dc.b	2
	dc.b	0
	dc.b	2
	dc.b	0
	dc.b	2
	dc.b	0
	dc.b	2
	dc.b	0
	dc.b	2
	dc.b	0
	dc.b	2
	dc.b	0
	dc.b	2
	dc.b	0
	dc.b	2
	dc.b	0
	dc.b	2
	dc.b	0
	dc.b	2
	dc.b	0
	dc.b	2
	dc.b	0
	dc.b	2
	dc.b	0

; =============== S U B	R O U T	I N E =====================================================


sub_C968:
	move.w	$26(a0),d0
	asl.w	#5,d0
	adda.w	d0,a2
	rts
; End of function sub_C968


; =============== S U B	R O U T	I N E =====================================================


sub_C972:
	clr.l	(hscroll_buffer).l
	bsr.w	DisableLineHScroll
	clr.b	(word_FF1990+1).l
	bsr.w	sub_EDD6
	movea.l	a1,a2
	lea	(loc_CB52).l,a1
	jsr	FindActorSlot
	bcs.w	loc_CAE2
	lea	(sub_CAFC).l,a1
	jsr	FindActorSlot
	bcs.w	loc_CAE2
	move.l	a2,$2E(a1)
	move.l	#$1D000,$12(a1)
	move.l	#-$70000,$16(a1)
	move.b	#$33,6(a1)
	move.w	$A(a2),$A(a1)
	move.w	$E(a2),$E(a1)
	lea	(loc_CBBC).l,a1
	jsr	FindActorSlot
	bcs.w	loc_CAE2
	move.l	a2,$2E(a1)
	move.b	#$2B,8(a1)
	move.b	#$1D,9(a1)
	move.b	#$3F,6(a1)
	move.w	#$86,$A(a1)
	move.w	#$37,$E(a1)
	move.b	#1,$28(a1)
	move.w	#$119,$1E(a1)
	move.w	#$80,$20(a1)
	move.l	#0,$12(a1)
	move.l	#$18000,$16(a1)
	move.w	#$2000,$1A(a1)
	move.w	#$5000,$1C(a1)
	move.w	#$12A,$2A(a1)
	moveq	#7,d1
	lea	(unk_CD32).l,a2

loc_CA3C:
	lea	(loc_CCA6).l,a1
	jsr	FindActorSlot
	bcs.w	loc_CAE2
	move.b	#$31,8(a1)
	move.b	#$80,6(a1)
	move.w	(a2)+,$A(a1)
	move.w	(a2)+,$E(a1)
	move.l	(a2)+,$32(a1)
	jsr	Random
	andi.b	#$3F,d0
	move.b	d0,$26(a1)
	dbf	d1,loc_CA3C
	lea	(loc_CCDE).l,a1
	jsr	FindActorSlot
	bcs.w	loc_CAE2
	move.b	#$31,8(a1)
	move.b	#$16,9(a1)
	move.b	#$80,6(a1)
	bsr.w	sub_CD08
	move.w	d0,$A(a1)
	move.w	d1,$E(a1)
	move.l	#unk_CD24,$32(a1)
	lea	(loc_CCCA).l,a1
	jsr	FindActorSlot
	bcs.w	loc_CAE2
	move.b	#$31,8(a1)
	move.b	#$16,9(a1)
	bsr.w	sub_CD08
	move.w	d0,$A(a1)
	move.w	d1,$E(a1)
	move.l	#unk_CD24,$32(a1)
	move.b	#$F,$26(a1)

loc_CAE2:
	lea	(ArtNem_RobotnikShip).l,a0
	move.w	#$3000,d0
	DISABLE_INTS
	jsr	NemDec
	ENABLE_INTS
	rts
; End of function sub_C972


; =============== S U B	R O U T	I N E =====================================================


sub_CAFC:
	movea.l	$2E(a0),a1
	movea.l	$32(a1),a2
	cmpi.b	#$FE,(a2)
	beq.w	loc_CB0E
	rts
; -----------------------------------------------------------------------------------------

loc_CB0E:
	move.l	#unk_EFF2,$32(a1)
	jsr	(ActorBookmark).l
	jsr	(ActorMove).l
	movea.l	$2E(a0),a1
	move.l	$16(a0),d0
	addi.l	#$3200,d0
	move.l	d0,$16(a0)
	move.w	$E(a0),$E(a1)
	move.w	$A(a0),d0
	move.w	d0,$A(a1)
	cmpi.w	#$118,d0
	bge.w	loc_CB4C
	rts
; -----------------------------------------------------------------------------------------

loc_CB4C:
	jmp	(ActorDeleteSelf).l
; End of function sub_CAFC

; -----------------------------------------------------------------------------------------

loc_CB52:
	move.b	#$6A,d0
	jsr	PlaySound_ChkSamp
	move.w	#$82,$26(a0)
	jsr	(ActorBookmark).l
	subq.w	#1,$26(a0)
	beq.s	loc_CB70
	rts
; -----------------------------------------------------------------------------------------

loc_CB70:
	move.b	#$6A,d0
	jsr	PlaySound_ChkSamp
	move.w	#$82,$26(a0)
	jsr	(ActorBookmark).l
	subq.w	#1,$26(a0)
	beq.s	loc_CB8E
	rts
; -----------------------------------------------------------------------------------------

loc_CB8E:
	move.b	#$6A,d0
	jsr	PlaySound_ChkSamp
	move.w	#$C8,$26(a0)
	jsr	(ActorBookmark).l
	subq.w	#1,$26(a0)
	beq.s	loc_CBAC
	rts
; -----------------------------------------------------------------------------------------

loc_CBAC:
	move.b	#$91,d0
	jsr	PlaySound_ChkSamp
	jmp	(ActorDeleteSelf).l
; -----------------------------------------------------------------------------------------

loc_CBBC:
	subq.w	#1,$2A(a0)
	beq.s	loc_CBC4
	rts
; -----------------------------------------------------------------------------------------

loc_CBC4:
	move.b	#$BF,6(a0)
	jsr	(ActorBookmark).l
	jsr	(ActorMove).l
	cmpi.w	#$119,$A(a0)
	bge.s	loc_CBE0
	rts
; -----------------------------------------------------------------------------------------

loc_CBE0:
	move.b	#$85,6(a0)
	move.l	#$30000,$16(a0)
	move.w	#$4020,$1C(a0)
	move.w	#$BA,$20(a0)
	jsr	(ActorBookmark).l
	movea.l	$2E(a0),a1
	cmpi.w	#$119,$A(a1)
	beq.s	loc_CC0E
	rts
; -----------------------------------------------------------------------------------------

loc_CC0E:
	jsr	(ActorBookmark).l
	jsr	(ActorMove).l
	movea.l	$2E(a0),a1
	cmpi.w	#$1C0,$A(a0)
	blt.s	loc_CC32
	andi.b	#$7F,6(a0)
	andi.b	#$7F,6(a1)

loc_CC32:
	subq.b	#1,$28(a0)
	bne.s	loc_CC4C
	move.b	#3,$28(a0)
	move.w	$26(a0),d0
	addq.w	#1,d0
	andi.b	#7,d0
	move.w	d0,$26(a0)

loc_CC4C:
	lea	(byte_CC86).l,a2
	move.w	$26(a0),d0
	lsl.w	#2,d0
	adda.w	d0,a2
	move.l	(a2)+,d0
	add.l	d0,$A(a0)
	add.l	d0,$A(a1)
	move.w	$E(a0),$E(a1)
	cmpi.w	#$1C8,$A(a0)
	bge.s	loc_CC74
	rts
; -----------------------------------------------------------------------------------------

loc_CC74:
	clr.b	(bytecode_disabled).l
	clr.b	bytecode_flag
	jmp	(ActorDeleteSelf).l
; -----------------------------------------------------------------------------------------
byte_CC86
	dc.b	0
	dc.b	1
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	$70
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	$80
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	1
	dc.b	$40
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	$30
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	$70
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	$40
	dc.b	0
; -----------------------------------------------------------------------------------------

loc_CCA6:
	jsr	(ActorAnimate).l
	jsr	(ActorBookmark).l
	tst.b	$26(a0)
	beq.s	loc_CCBE
	subq.b	#1,$26(a0)
	rts
; -----------------------------------------------------------------------------------------

loc_CCBE:
	jsr	(ActorBookmark).l
	jmp	(ActorAnimate).l
; -----------------------------------------------------------------------------------------

loc_CCCA:
	subq.b	#1,$26(a0)
	beq.s	loc_CCD2
	rts
; -----------------------------------------------------------------------------------------

loc_CCD2:
	move.b	#$80,6(a0)
	jsr	(ActorBookmark).l

loc_CCDE:
	jsr	(ActorAnimate).l
	movea.l	$32(a0),a2
	cmpi.b	#$FE,(a2)
	beq.w	loc_CCF2
	rts
; -----------------------------------------------------------------------------------------

loc_CCF2:
	bsr.w	sub_CD08
	move.w	d0,$A(a0)
	move.w	d1,$E(a0)
	move.l	#unk_CD24,$32(a0)
	rts

; =============== S U B	R O U T	I N E =====================================================


sub_CD08:
	jsr	Random
	move.w	d0,d1
	andi.w	#$FF,d0
	addi.w	#$90,d0
	move.w	#9,d2
	lsr.w	d2,d1
	addi.w	#$80,d1
	rts
; End of function sub_CD08

; -----------------------------------------------------------------------------------------
unk_CD24
	dc.b	5
	dc.b	$16
	dc.b	5
	dc.b	$17
	dc.b	5
	dc.b	$18
	dc.b	5
	dc.b	$19
	dc.b	5
	dc.b	$1A
	dc.b	5
	dc.b	$1B
	dc.b	$FE
	dc.b	0
unk_CD32
	dc.b	0
	dc.b	$90
	dc.b	1
	dc.b	$30
	dc.l	unk_CD72
	dc.b	0
	dc.b	$B8
	dc.b	0
	dc.b	$C0
	dc.l	unk_CDB6
	dc.b	0
	dc.b	$E0
	dc.b	1
	dc.b	0
	dc.l	unk_CDE2
	dc.b	1
	dc.b	8
	dc.b	1
	dc.b	$30
	dc.l	unk_CE0A
	dc.b	1
	dc.b	$30
	dc.b	1
	dc.b	0
	dc.l	unk_CD94
	dc.b	1
	dc.b	$58
	dc.b	0
	dc.b	$C0
	dc.l	unk_CDCC
	dc.b	1
	dc.b	$80
	dc.b	1
	dc.b	$10
	dc.l	unk_CDF6
	dc.b	1
	dc.b	$A8
	dc.b	1
	dc.b	0
	dc.l	unk_CE22
unk_CD72
	dc.b	5
	dc.b	0
	dc.b	5
	dc.b	1
	dc.b	5
	dc.b	2
	dc.b	5
	dc.b	1
	dc.b	5
	dc.b	0
	dc.b	5
	dc.b	1
	dc.b	5
	dc.b	2
	dc.b	5
	dc.b	1
	dc.b	5
	dc.b	0
	dc.b	5
	dc.b	1
	dc.b	5
	dc.b	2
	dc.b	5
	dc.b	3
	dc.b	5
	dc.b	1
	dc.b	5
	dc.b	0
	dc.b	$FF
	dc.b	0
	dc.l	unk_CD72
unk_CD94
	dc.b	$32
	dc.b	0
	dc.b	5
	dc.b	1
	dc.b	5
	dc.b	2
	dc.b	5
	dc.b	1
	dc.b	$A
	dc.b	0
	dc.b	4
	dc.b	1
	dc.b	4
	dc.b	2
	dc.b	4
	dc.b	1
	dc.b	$A
	dc.b	0
	dc.b	5
	dc.b	1
	dc.b	5
	dc.b	2
	dc.b	5
	dc.b	3
	dc.b	5
	dc.b	1
	dc.b	5
	dc.b	0
	dc.b	$FF
	dc.b	0
	dc.l	unk_CD94
unk_CDB6
	dc.b	$32
	dc.b	4
	dc.b	8
	dc.b	5
	dc.b	5
	dc.b	6
	dc.b	7
	dc.b	7
	dc.b	8
	dc.b	8
	dc.b	5
	dc.b	9
	dc.b	9
	dc.b	5
	dc.b	5
	dc.b	4
	dc.b	$FF
	dc.b	0
	dc.l	unk_CDB6
unk_CDCC
	dc.b	5
	dc.b	4
	dc.b	8
	dc.b	5
	dc.b	5
	dc.b	6
	dc.b	7
	dc.b	7
	dc.b	8
	dc.b	8
	dc.b	5
	dc.b	9
	dc.b	9
	dc.b	5
	dc.b	5
	dc.b	4
	dc.b	$FF
	dc.b	0
	dc.l	unk_CDCC
unk_CDE2
	dc.b	$1E
	dc.b	$A
	dc.b	8
	dc.b	$B
	dc.b	5
	dc.b	$C
	dc.b	8
	dc.b	$D
	dc.b	5
	dc.b	$E
	dc.b	8
	dc.b	$B
	dc.b	5
	dc.b	$A
	dc.b	$FF
	dc.b	0
	dc.l	unk_CDE2
unk_CDF6
	dc.b	5
	dc.b	$A
	dc.b	5
	dc.b	$B
	dc.b	5
	dc.b	$C
	dc.b	5
	dc.b	$D
	dc.b	5
	dc.b	$E
	dc.b	5
	dc.b	$B
	dc.b	5
	dc.b	$A
	dc.b	$FF
	dc.b	0
	dc.l	unk_CDF6
unk_CE0A
	dc.b	$32
	dc.b	$F
	dc.b	7
	dc.b	$10
	dc.b	5
	dc.b	$11
	dc.b	5
	dc.b	$12
	dc.b	5
	dc.b	$13
	dc.b	5
	dc.b	$14
	dc.b	5
	dc.b	$15
	dc.b	8
	dc.b	$10
	dc.b	5
	dc.b	$F
	dc.b	$FF
	dc.b	0
	dc.l	unk_CE0A
unk_CE22
	dc.b	5
	dc.b	$F
	dc.b	5
	dc.b	$10
	dc.b	5
	dc.b	$11
	dc.b	5
	dc.b	$12
	dc.b	5
	dc.b	$13
	dc.b	5
	dc.b	$14
	dc.b	5
	dc.b	$15
	dc.b	5
	dc.b	$10
	dc.b	5
	dc.b	$F
	dc.b	$FF
	dc.b	0
	dc.l	unk_CE22
; -----------------------------------------------------------------------------------------

loc_CE3A:
	lea	($E000).l,a1
	lea	(MapEni_PasswordBG).l,a0
	move.w	#$6400,d0
	move.w	#$27,d1
	move.w	#$1B,d2
	jmp	(EniDec).l
; -----------------------------------------------------------------------------------------
MapEni_PasswordBG:
	incbin	"data/mapeni/mapeniCE58.bin"
; -----------------------------------------------------------------------------------------

loc_CF4A:
	jsr	(EnableSHMode).l
	moveq	#0,d0
	move.w	d0,(vscroll_buffer).l
	move.w	d0,(hscroll_buffer).l
	lea	(loc_D192).l,a1
	jsr	FindActorSlot
	bcc.w	loc_CF70
	rts
; -----------------------------------------------------------------------------------------

loc_CF70:
	move.b	#$80,6(a1)
	move.b	#$1D,8(a1)
	move.b	#3,9(a1)
	move.w	#$8C,$A(a1)
	move.w	#$C9,$E(a1)
	move.w	#3,$2A(a1)
	move.w	(current_password).l,$2C(a1)
	movea.l	a1,a0
	bsr.w	sub_CFB8
	bsr.w	sub_D096
	bsr.w	sub_D0FC
	lea	(loc_D3B4).l,a1
	jsr	FindActorSlot
	rts

; =============== S U B	R O U T	I N E =====================================================


sub_CFB8:
	move.w	#9,d0
	lea	(unk_D01A).l,a2

loc_CFC2:
	lea	(sub_D00C).l,a1
	jsr	FindActorSlot
	bcs.w	loc_D006
	move.l	a0,$2E(a1)
	move.b	(a2)+,8(a1)
	move.b	(a2)+,$22(a1)
	move.b	(a2)+,9(a1)
	move.b	(a2)+,$28(a1)
	move.b	#$80,6(a1)
	move.w	d0,d2
	muls.w	#$1C,d2
	move.w	#$198,d1
	sub.w	d2,d1
	move.w	d1,$A(a1)
	move.w	#$D8,$E(a1)
	move.l	(a2)+,$32(a1)

loc_D006:
	dbf	d0,loc_CFC2
	rts
; End of function sub_CFB8


; =============== S U B	R O U T	I N E =====================================================


sub_D00C:
	tst.b	$28(a0)
	bne.s	locret_D018
	jsr	(ActorAnimate).l

locret_D018:
	rts
; End of function sub_D00C

; -----------------------------------------------------------------------------------------
unk_D01A
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.l	unk_D072
	dc.b	1
	dc.b	8
	dc.b	0
	dc.b	0
	dc.l	unk_D072
	dc.b	5
	dc.b	$10
	dc.b	0
	dc.b	0
	dc.l	unk_D072
	dc.b	4
	dc.b	$18
	dc.b	0
	dc.b	0
	dc.l	unk_D072
	dc.b	3
	dc.b	$40
	dc.b	0
	dc.b	0
	dc.l	unk_D072
	dc.b	6
	dc.b	0
	dc.b	0
	dc.b	0
	dc.l	unk_D06A
	dc.b	$19
	dc.b	0
	dc.b	0
	dc.b	0
	dc.l	unk_D088
	dc.b	$1D
	dc.b	0
	dc.b	5
	dc.b	1
	dc.l	unk_D06A
	dc.b	$1D
	dc.b	0
	dc.b	4
	dc.b	1
	dc.l	unk_D06A
	dc.b	$1D
	dc.b	0
	dc.b	2
	dc.b	1
	dc.l	unk_D06A
unk_D06A
	dc.b	8
	dc.b	0
	dc.b	$FF
	dc.b	0
	dc.l	unk_D06A
unk_D072
	dc.b	3
	dc.b	2
	dc.b	1
	dc.b	0
	dc.b	2
	dc.b	3
	dc.b	1
	dc.b	0
	dc.b	3
	dc.b	2
	dc.b	1
	dc.b	0
	dc.b	2
	dc.b	3
	dc.b	$60
	dc.b	0
	dc.b	$FF
	dc.b	0
	dc.l	unk_D072
unk_D088
	dc.b	$C
	dc.b	$E
	dc.b	$A
	dc.b	$35
	dc.b	$C
	dc.b	$F
	dc.b	$A
	dc.b	$36
	dc.b	$FF
	dc.b	0
	dc.l	unk_D088

; =============== S U B	R O U T	I N E =====================================================


sub_D096:
	move.w	#3,d0

loc_D09A:
	lea	(sub_D0DE).l,a1
	jsr	FindActorSlot
	bcs.w	locret_D0DC
	move.l	a0,$2E(a1)
	move.b	#$1D,8(a1)
	move.b	#1,9(a1)
	move.b	#$80,6(a1)
	move.w	d0,d2
	lsl.w	#5,d2
	move.w	#$148,d1
	sub.w	d2,d1
	move.w	d1,$A(a1)
	move.w	#$120,$E(a1)
	move.w	d0,$26(a1)
	dbf	d0,loc_D09A

locret_D0DC:
	rts
; End of function sub_D096


; =============== S U B	R O U T	I N E =====================================================


sub_D0DE:
	movea.l	$2E(a0),a1
	move.w	$2A(a1),d0
	sub.w	$26(a0),d0
	bne.s	loc_D0F4
	move.b	#0,9(a0)
	rts
; -----------------------------------------------------------------------------------------

loc_D0F4:
	move.b	#1,9(a0)
	rts
; End of function sub_D0DE


; =============== S U B	R O U T	I N E =====================================================


sub_D0FC:
	move.w	#3,d0

loc_D100:
	lea	(sub_D13A).l,a1
	jsr	FindActorSlot
	bcs.w	locret_D138
	move.l	a0,$2E(a1)
	move.w	d0,d2
	lsl.w	#5,d2
	move.w	#$150,d1
	sub.w	d2,d1
	move.w	d1,$A(a1)
	move.w	#$118,$E(a1)
	move.w	d0,$26(a1)
	move.l	#unk_D072,$32(a1)
	dbf	d0,loc_D100

locret_D138:
	rts
; End of function sub_D0FC


; =============== S U B	R O U T	I N E =====================================================


sub_D13A:
	movea.l	$2E(a0),a1
	move.w	$2C(a1),d0
	move.w	$26(a0),d1
	lsl.w	#2,d1
	lsr.w	d1,d0
	andi.w	#$F,d0
	cmpi.b	#$F,d0
	beq.s	loc_D18A
	lea	(unk_D01A).l,a1
	lsl.w	#3,d0
	adda.w	d0,a1
	move.b	(a1),d0
	cmp.b	8(a0),d0
	beq.s	loc_D17E
	move.b	d0,8(a0)
	move.b	#0,9(a0)
	move.b	#0,$22(a0)
	adda.w	#4,a1
	move.l	(a1),$32(a0)

loc_D17E:
	move.b	#$80,6(a0)
	jmp	(ActorAnimate).l
; -----------------------------------------------------------------------------------------

loc_D18A:
	move.b	#0,6(a0)
	rts
; End of function sub_D13A

; -----------------------------------------------------------------------------------------

loc_D192:
	move.w	#0,$26(a0)
	jsr	(ActorBookmark).l
	jsr	(GetCtrlData).l
	btst	#7,d0
	bne.w	loc_D282
	btst	#4,d0
	bne.w	loc_D35C
	andi.b	#$60,d0
	bne.w	loc_D21C
	move.b	(p1_ctrl+ctlPulse).l,d0
	tst.b	swap_fields
	beq.w	loc_D1D2
	move.b	(p2_ctrl+ctlPulse).l,d0

loc_D1D2:
	btst	#3,d0
	bne.w	loc_D1E4
	btst	#2,d0
	bne.w	loc_D1F4
	rts
; -----------------------------------------------------------------------------------------

loc_D1E4:
	cmpi.w	#9,$26(a0)
	bcc.w	locret_D202
	addq.w	#1,$26(a0)
	bra.s	loc_D204
; -----------------------------------------------------------------------------------------

loc_D1F4:
	subq.w	#1,$26(a0)
	bcc.w	loc_D204
	move.w	#0,$26(a0)

locret_D202:
	rts
; -----------------------------------------------------------------------------------------

loc_D204:
	move.w	$26(a0),d0
	muls.w	#$1C,d0
	addi.w	#$8C,d0
	move.w	d0,$A(a0)
	move.b	#$42,d0
	bra.w	PlaySound_ChkSamp
; -----------------------------------------------------------------------------------------

loc_D21C:
	move.w	$26(a0),d0
	move.w	$2C(a0),d1
	move.w	$2A(a0),d2
	move.w	d0,d3
	subq.w	#7,d3
	bmi.s	loc_D242
	lsl.w	#2,d3
	movea.l	off_D236(pc,d3.w),a1
	jmp	(a1)
; -----------------------------------------------------------------------------------------
off_D236
	dc.l	loc_D264
	dc.l	loc_D26E
	dc.l	loc_D282
; -----------------------------------------------------------------------------------------

loc_D242:
	tst.w	d2
	beq.s	loc_D24A
	subq.w	#1,$2A(a0)

loc_D24A:
	lsl.w	#2,d2
	ror.w	d2,d1
	andi.w	#$FFF0,d1
	or.w	d0,d1
	rol.w	d2,d1
	move.w	d1,$2C(a0)
	move.b	#$41,d0
	bsr.w	PlaySound_ChkSamp
	rts
; -----------------------------------------------------------------------------------------

loc_D264:
	cmpi.w	#3,d2
	beq.s	locret_D280
	addq.w	#1,d2
	bra.s	loc_D274
; -----------------------------------------------------------------------------------------

loc_D26E:
	tst.w	d2
	beq.s	locret_D280
	subq.w	#1,d2

loc_D274:
	move.w	d2,$2A(a0)
	move.b	#$41,d0
	bsr.w	PlaySound_ChkSamp

locret_D280:
	rts
; -----------------------------------------------------------------------------------------

loc_D282:
	move.w	$2C(a0),d0
	cmpi.w	#$FFFF,d0
	beq.w	loc_D394
	lea	(Passwords).l,a1
	adda.w	#$60,a1
	moveq	#$2F,d1

loc_D29A:
	cmp.w	-(a1),d0
	beq.s	loc_D2AC
	dbf	d1,loc_D29A
	move.b	#$46,d0
	bsr.w	PlaySound_ChkSamp
	rts
; -----------------------------------------------------------------------------------------

loc_D2AC:
	move.w	d0,(current_password).l
	move.w	d1,d0
	andi.b	#3,d0
	eori.b	#3,d0
	move.b	d0,(difficulty).l
	lsr.w	#2,d1
	move.w	d1,d0
	addq.w	#4,d1
	move.b	d1,stage
	lea	opponents_defeated,a2
	lea	(unk_D34E).l,a1
	clr.w	d1

loc_D2DC:
	move.b	(a1)+,d1
	move.b	#$FF,(a2,d1.w)
	dbf	d0,loc_D2DC
	move.b	#SFX_5D,d0
	bsr.w	PlaySound_ChkSamp
	bsr.w	sub_DF74
	lea	(locret_D348).l,a1
	jsr	FindActorSlot
	bcs.w	loc_D334
	clr.l	d0
	move.b	(difficulty).l,d0
	move.b	#$1D,8(a1)
	move.b	d0,9(a1)
	addq.b	#6,9(a1)
	move.b	#$80,6(a1)
	move.b	unk_D34A(pc,d0.w),d0
	move.w	#$80,d1
	add.w	d0,d1
	move.w	d1,$A(a1)
	move.w	#$140,$E(a1)

loc_D334:
	moveq	#$5A,d0
	jsr	(ActorBookmark_SetDelay).l
	jsr	(ActorBookmark_Ctrl).l
	clr.b	(bytecode_disabled).l

locret_D348:
	rts
; -----------------------------------------------------------------------------------------
unk_D34A
	dc.b	$68
	dc.b	$80
	dc.b	$70
	dc.b	$80
unk_D34E
	dc.b	3
	dc.b	1
	dc.b	$E
	dc.b	7
	dc.b	6
	dc.b	$F
	dc.b	2
	dc.b	5
	dc.b	8
	dc.b	9
	dc.b	$A
	dc.b	$B
	dc.b	$C
	dc.b	0
; -----------------------------------------------------------------------------------------

loc_D35C:
	move.w	$2C(a0),d0
	cmpi.w	#$FFFF,d0
	beq.s	loc_D394
	move.w	$2A(a0),d1
	cmpi.w	#3,d1
	beq.s	loc_D374
	addq.w	#1,$2A(a0)

loc_D374:
	move.w	#$F,d2
	lsl.w	#2,d1
	lsl.w	d1,d2
	move.w	d0,d1
	and.w	d2,d1
	cmp.w	d2,d1
	beq.s	locret_D392
	or.w	d2,d0
	move.w	d0,$2C(a0)
	move.b	#SFX_MENU_SELECT,d0
	bsr.w	PlaySound_ChkSamp

locret_D392:
	rts
; -----------------------------------------------------------------------------------------

loc_D394:
	move.b	#SFX_49,d0
	bsr.w	PlaySound_ChkSamp
	move.b	$27(a0),stage
	move.b	#6,bytecode_flag
	clr.b	(bytecode_disabled).l
	rts
; -----------------------------------------------------------------------------------------

loc_D3B4:
	jsr	(ActorBookmark).l
	tst.b	$28(a0)
	bne.w	loc_D40A
	move.b	#5,$28(a0)
	clr.w	d0
	move.b	$29(a0),d0
	addq.b	#1,d0
	cmpi.b	#$F,d0
	bne.s	loc_D3DA
	move.b	#0,d0

loc_D3DA:
	move.b	d0,$29(a0)
	mulu.w	#6,d0
	lea	(word_D456).l,a1
	adda.w	d0,a1
	move.w	(a1)+,(palette_buffer+$E).l
	move.w	(a1)+,(palette_buffer+$1A).l
	move.w	(a1)+,(palette_buffer+$1C).l
	moveq	#0,d0
	lea	(palette_buffer).l,a2
	jsr	LoadPalette

loc_D40A:
	subq.b	#1,$28(a0)
	tst.b	$2A(a0)
	bne.w	loc_D450
	move.b	#2,$2A(a0)
	clr.w	d0
	move.b	$2B(a0),d0
	addq.b	#1,d0
	cmpi.b	#$11,d0
	bne.s	loc_D42E
	move.b	#0,d0

loc_D42E:
	move.b	d0,$2B(a0)
	add.w	d0,d0
	lea	(word_D4B0).l,a1
	adda.w	d0,a1
	move.w	(a1),(palette_buffer+$2E).l
	moveq	#1,d0
	lea	((palette_buffer+$20)).l,a2
	jsr	LoadPalette

loc_D450:
	subq.b	#1,$2A(a0)
	rts
; -----------------------------------------------------------------------------------------
word_D456
	dc.w	$6A
	dc.w	$AC
	dc.w	$4EE
	dc.w	$68
	dc.w	$8C
	dc.w	$EE
	dc.w	$46
	dc.w	$6A
	dc.w	$CC
	dc.w	$26
	dc.w	$48
	dc.w	$AA
	dc.w	$24
	dc.w	$46
	dc.w	$88
	dc.w	4
	dc.w	$26
	dc.w	$68
	dc.w	2
	dc.w	6
	dc.w	$48
	dc.w	0
	dc.w	4
	dc.w	$28
	dc.w	2
	dc.w	6
	dc.w	$48
	dc.w	4
	dc.w	$26
	dc.w	$68
	dc.w	$24
	dc.w	$46
	dc.w	$88
	dc.w	$26
	dc.w	$48
	dc.w	$AA
	dc.w	$46
	dc.w	$6A
	dc.w	$CC
	dc.w	$68
	dc.w	$8C
	dc.w	$EE
	dc.w	$6A
	dc.w	$AC
	dc.w	$4EE
word_D4B0
	dc.w	$E60
	dc.w	$E40
	dc.w	$E20
	dc.w	$E00
	dc.w	$C00
	dc.w	$800
	dc.w	$600
	dc.w	$400
	dc.w	$200
	dc.w	$400
	dc.w	$600
	dc.w	$800
	dc.w	$C00
	dc.w	$E00
	dc.w	$E20
	dc.w	$E40
	dc.w	$E60

; =============== S U B	R O U T	I N E =====================================================


DrawOpponentScrBoxes:
	clr.w	d0
	move.b	stage,d0
	add.w	d0,d0
	lea	(OpponentScrBGBases).l,a1
	move.w	(a1,d0.w),d0
	andi.w	#$7FFF,d0
	DISABLE_INTS
	lea	(MapEni_OpponentScrBox).l,a0
	lea	($E000).l,a1
	move.w	#$B,d1
	move.w	#8,d2
	jsr	(EniDec).l
	move.w	#$8000,d0
	lea	(eni_tilemap_buffer).l,a1
	move.w	#$B,d1

.SetHiPrio:
	or.w	d0,(a1)+
	dbf	d1,.SetHiPrio
	move.w	#6,d1

.SetHiPrio2:
	or.w	d0,(a1)+
	adda.w	#$14,a1
	or.w	d0,(a1)+
	dbf	d1,.SetHiPrio2
	move.w	#$B,d1

.SetHiPrio3:
	or.w	d0,(a1)+
	dbf	d1,.SetHiPrio3
	clr.w	d0
	move.b	stage,d0
	move.b	OpponentScrBoxMap(pc,d0.w),d0
	move.w	#3,d1
	lea	(eni_tilemap_queue).l,a1
	move.w	#$E906,d2

.DrawBoxes:
	lsr.b	#1,d0
	bcc.s	.DrawBoxes_Next
	move.w	#1,(a1)+
	move.w	#$B,(a1)+
	move.w	#8,(a1)+
	move.w	d2,(a1)+

.DrawBoxes_Next:
	addi.w	#$1A,d2
	dbf	d1,.DrawBoxes
	ENABLE_INTS
	rts
; End of function DrawOpponentScrBoxes

; -----------------------------------------------------------------------------------------
OpponentScrBoxMap:
	dc.b	%1110
	dc.b	%1110
	dc.b	%1110
	dc.b	%1100
	dc.b	%1110
	dc.b	%1111
	dc.b	%1111
	dc.b	%1111
	dc.b	%1111
	dc.b	%1111
	dc.b	%1111
	dc.b	%1111
	dc.b	%1111
	dc.b	%1111
	dc.b	%0111
	dc.b	%0100
MapEni_OpponentScrBox:
	incbin	"data/mapeni/mapeniD580.bin"

; =============== S U B	R O U T	I N E =====================================================


DrawOpponentScrBG:
	clr.w	d0
	move.b	stage,d0
	add.w	d0,d0
	move.w	OpponentScrBGBases(pc,d0.w),d1
	DISABLE_INTS
	moveq	#$4D,d0
	lea	(eni_tilemap_buffer).l,a1

.StoreBGTiles:
	move.w	d1,(a1)+
	addq.b	#1,d1
	dbf	d0,.StoreBGTiles
	lea	(eni_tilemap_queue).l,a1
	move.w	#$E004,d2
	moveq	#4,d0

.Row:
	moveq	#4,d1

.Section:
	move.w	#1,(a1)+
	move.w	#$C,(a1)+
	move.w	#5,(a1)+
	move.w	d2,(a1)+
	addi.w	#$1A,d2
	dbf	d1,.Section
	addi.w	#$57E,d2
	dbf	d0,.Row
	ENABLE_INTS
	rts
; End of function DrawOpponentScrBG

; -----------------------------------------------------------------------------------------
OpponentScrBGBases:
	dc.w	0
	dc.w	0
	dc.w	0
	dc.w	$C400
	dc.w	$C400
	dc.w	$C400
	dc.w	$C400
	dc.w	$C400
	dc.w	$A400
	dc.w	$A400
	dc.w	$A400
	dc.w	$8400
	dc.w	$8400
	dc.w	$8400
	dc.w	$8400
	dc.w	$E400

; =============== S U B	R O U T	I N E =====================================================


Stage_DrawSmallText:
	move.l	#$97000000,d0
	jsr	QueuePlaneCmd
	move.l	#$9A000000,d0
	jmp	QueuePlaneCmd
; End of function stage_DrawSmallText


; =============== S U B	R O U T	I N E =====================================================


SpawnOpponentScrActors:
	jsr	(EnableSHMode).l
	bsr.w	DisableLineHScroll
	lea	(ActOpponentScr).l,a1
	jsr	FindActorSlot
	bcc.w	.Spawned
	rts
; -----------------------------------------------------------------------------------------

.Spawned:
	move.b	#$22,8(a1)
	move.b	#1,9(a1)
	move.w	#$F8,$A(a1)
	move.w	#$D0,$E(a1)
	move.w	#$FF88,(hscroll_buffer).l
	move.w	#$FF88,(hscroll_buffer+2).l
	clr.w	d1
	move.b	stage,d1
	clr.w	d0
	move.b	OpponentScrScrlFlags(pc,d1.w),d0
	bne.w	.NoScrlOffset
	tst.b	(byte_FF0115).l
	bne.w	.NoScrlOffset
	move.w	#$FFF0,(hscroll_buffer).l
	move.w	#$FFF0,(hscroll_buffer+2).l

.NoScrlOffset:
	bsr.w	DrawOpponentScrBG
	bra.w	loc_D7A0
; -----------------------------------------------------------------------------------------
OpponentScrScrlFlags:
	dc.b	$FF
	dc.b	0
	dc.b	0
	dc.b	$FF
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	$FF
; -----------------------------------------------------------------------------------------

ActOpponentScr:
	move.w	#$A0,aField26(a0)
	jsr	(ActorBookmark).l

ActOpponentScr_Update:
	tst.w	(disallow_skipping).l
	bne.s	.NoInput
	jsr	(GetCtrlData).l
	andi.b	#$F0,d0
	bne.w	ActOpponentScr_Done

.NoInput:
	cmpi.w	#$FF88,(hscroll_buffer+2).l
	beq.w	.ScrollDone
	subq.w	#2,(hscroll_buffer).l
	subq.w	#2,(hscroll_buffer+2).l
	rts
; -----------------------------------------------------------------------------------------

.ScrollDone:
	subq.w	#1,aField26(a0)
	beq.w	ActOpponentScr_Done
	cmpi.w	#$80,aField26(a0)
	beq.w	.StartFlash
	bcs.w	.DoFlash
	rts
; -----------------------------------------------------------------------------------------

.DoFlash:
	move.w	aField26(a0),d0
	rol.b	#5,d0
	andi.b	#$80,d0
	move.b	d0,aFlags(a0)
	rts
; -----------------------------------------------------------------------------------------

.StartFlash:
	move.b	#SFX_GARBAGE_1,d0
	jsr	PlaySound_ChkSamp
	move.w	#$C73E,d5
	clr.l	d2
	clr.w	d0
	move.b	stage,d0
	subq.b	#2,d0
	cmpi.b	#$A,d0
	blt.s	.GetNumberTile
	move.w	#$8476,d2
	subi.b	#$A,d0

.GetNumberTile:
	addi.w	#$8475,d0
	lea	(.StageTextTiles).l,a2
	lea	(eni_tilemap_buffer).l,a1
	move.w	#1,d1

.DrawStageHdrLine:
	move.w	#5,d3

.DrawStageText:
	move.w	(a2)+,(a1)+
	dbf	d3,.DrawStageText
	move.w	d2,(a1)+
	tst.b	d2
	beq.s	.DrawStageNumber
	addi.w	#$A,d2

.DrawStageNumber:
	move.w	d0,(a1)+
	addi.w	#$A,d0
	dbf	d1,.DrawStageHdrLine
	lea	(eni_tilemap_queue).l,a1
	move.w	#1,(a1)+
	move.w	#7,(a1)+
	move.w	#1,(a1)+
	move.w	d5,(a1)+
	rts
; -----------------------------------------------------------------------------------------
.StageTextTiles:
	dc.w	$8493
	dc.w	$8494
	dc.w	$8495
	dc.w	$8496
	dc.w	$8497
	dc.w	0
	dc.w	$8498
	dc.w	$8499
	dc.w	$849A
	dc.w	$849B
	dc.w	$849C
	dc.w	0
; -----------------------------------------------------------------------------------------

ActOpponentScr_Done:
	clr.b	(bytecode_disabled).l
	jmp	(ActorDeleteSelf).l
; -----------------------------------------------------------------------------------------

loc_D7A0:
	lea	(sub_D818).l,a1
	jsr	FindActorSlot
	clr.w	d0
	move.b	stage,d0
	add.w	d0,d0
	move.w	word_D7F8(pc,d0.w),d0
	move.w	d0,aField2C(a1)
	move.w	#$CA08,aField26(a1)
	move.w	d0,d5
	DISABLE_INTS
	move.w	#3,d1

loc_D7CE:
	move.w	d5,d0
	andi.w	#$F,d0
	beq.s	loc_D7EC
	lea	(dword_D916).l,a2
	lsl.w	#4,d0
	adda.w	d0,a2
	move.w	$C(a2),d0
	movea.l	(a2),a0
	jsr	NemDec

loc_D7EC:
	lsr.w	#4,d5
	dbf	d1,loc_D7CE
	ENABLE_INTS
	rts
; End of function SpawnOpponentScrActors

; -----------------------------------------------------------------------------------------
word_D7F8
	dc.w	0
	dc.w	0
	dc.w	0
	dc.w	$1300
	dc.w	$E130
	dc.w	$7E13
	dc.w	$67E1
	dc.w	$F67E
	dc.w	$2F67
	dc.w	$52F6
	dc.w	$852F
	dc.w	$9852
	dc.w	$A985
	dc.w	$BA98
	dc.w	$BA9
	dc.w	$C00

; =============== S U B	R O U T	I N E =====================================================


sub_D818:
	jsr	(ActorBookmark).l
	jsr	(ActorBookmark).l
	cmpi.b	#4,aAnimTime(a0)
	bne.w	loc_D880
	clr.w	d0
	move.b	stage,d0
	add.w	d0,d0
	move.w	word_D860(pc,d0.w),d0
	bmi.w	loc_D85A
	move.w	d0,d1
	andi.w	#$FF,d1
	lsl.w	#5,d1
	lea	Palettes,a2
	adda.l	d1,a2
	lsr.w	#8,d0
	clr.w	d1
	jsr	(FadeToPalette).l

loc_D85A:
	jmp	(ActorDeleteSelf).l
; -----------------------------------------------------------------------------------------
word_D860
	dc.w	$FFFF
	dc.w	$FFFF
	dc.w	$FFFF
	dc.w	$23E
	dc.w	$FFFF
	dc.w	$FFFF
	dc.w	$FFFF
	dc.w	$FFFF
	dc.w	$FFFF
	dc.w	$FFFF
	dc.w	$FFFF
	dc.w	$FFFF
	dc.w	$FFFF
	dc.w	$FFFF
	dc.w	$30
	dc.w	$330
; -----------------------------------------------------------------------------------------

loc_D880:
	addq.b	#1,aAnimTime(a0)
	move.w	aField2C(a0),d5
	move.w	d5,d1
	lsr.w	#4,d1
	move.w	d1,aField2C(a0)
	andi.w	#$F,d5
	beq.w	loc_D8FE
	move.w	d5,d6
	lea	(dword_D916).l,a2
	lsl.w	#4,d5
	adda.w	d5,a2
	move.w	aField26(a0),d4
	move.l	a0,-(sp)
	move.w	$E(a2),d0
	lea	opponents_defeated,a3
	tst.b	(a3,d6.w)
	beq.s	loc_D8C4
	movea.l	8(a2),a0
	andi.w	#$7FFF,d0
	bra.s	loc_D8C8
; -----------------------------------------------------------------------------------------

loc_D8C4:
	movea.l	4(a2),a0

loc_D8C8:
	move.w	#9,d1
	move.w	#6,d2
	movea.w	d4,a1
	jsr	(EniDec).l
	movea.l	(sp)+,a0
	clr.l	d1
	move.w	d6,d2
	lea	(byte_6206).l,a1
	move.b	(a1,d2.w),d1
	lsl.w	#5,d1
	lea	Palettes,a2
	adda.l	d1,a2
	move.b	byte_D906(pc,d6.w),d0
	clr.w	d1
	jsr	(FadeToPalette).l

loc_D8FE:
	addi.w	#$1A,aField26(a0)
	rts
; End of function sub_D818

; -----------------------------------------------------------------------------------------
byte_D906
	dc.b	0
	dc.b	1
	dc.b	2
	dc.b	0
	dc.b	0
	dc.b	3
	dc.b	0
	dc.b	3
	dc.b	0
	dc.b	1
	dc.b	2
	dc.b	3
	dc.b	0
	dc.b	0
	dc.b	2
	dc.b	1
dword_D916
	dc.l	0
	dc.l	0
	dc.l	0
	dc.w	0
	dc.w	0
	dc.l	ArtNem_FranklyPortrait
	dc.l	byte_3DFCC
	dc.l	byte_3E02C
	dc.w	$2000
	dc.w	$A100
	dc.l	ArtNem_DynamightPortrait
	dc.l	byte_4055A
	dc.l	byte_40636
	dc.w	$4000
	dc.w	$C200
	dc.l	ArtNem_ArmsPortrait
	dc.l	byte_4C40E
	dc.l	byte_4C3E0
	dc.w	0
	dc.w	$8000
	dc.l	0
	dc.l	0
	dc.l	0
	dc.w	0
	dc.w	0
	dc.l	ArtNem_GrounderPortrait
	dc.l	byte_41C9A
	dc.l	byte_41D72
	dc.w	$6000
	dc.w	$E300
	dc.l	ArtNem_DavyPortrait
	dc.l	byte_42C96
	dc.l	byte_42D4A
	dc.w	0
	dc.w	$8000
	dc.l	ArtNem_CoconutsPortrait
	dc.l	byte_3F30C
	dc.l	byte_3F3CE
	dc.w	$6000
	dc.w	$E300
	dc.l	ArtNem_SpikePortrait
	dc.l	byte_444A6
	dc.l	byte_4456E
	dc.w	0
	dc.w	$8000
	dc.l	ArtNem_SirFfuzzyPortrait
	dc.l	byte_4B20A
	dc.l	byte_4B350
	dc.w	$2000
	dc.w	$A100
	dc.l	ArtNem_DragonPortrait
	dc.l	byte_45D24
	dc.l	byte_45E06
	dc.w	$4000
	dc.w	$C200
	dc.l	ArtNem_ScratchPortrait
	dc.l	byte_3CC98
	dc.l	byte_3CD1E
	dc.w	$6000
	dc.w	$E300
	dc.l	ArtNem_RobotnikPortrait
	dc.l	byte_48712
	dc.l	byte_487CE
	dc.w	0
	dc.w	$8000
	dc.l	0
	dc.l	0
	dc.l	0
	dc.w	0
	dc.w	0
	dc.l	ArtNem_HumptyPortrait
	dc.l	byte_46FAA
	dc.l	byte_470CC
	dc.w	$4000
	dc.w	$C200
	dc.l	ArtNem_SkweelPortrait
	dc.l	byte_49C22
	dc.l	byte_49D60
	dc.w	$2000
	dc.w	$A100
; -----------------------------------------------------------------------------------------
	DISABLE_INTS
	move.w	#$CC08,d5
	bsr.w	sub_DA5A
	move.w	#$CC48,d5
	bsr.w	sub_DA5A
	move.w	#$E000,d5
	move.w	#7,d0
	move.w	#$41F0,d1

loc_DA36:
	jsr	SetVRAMWrite
	addi.w	#$80,d5
	move.w	#$27,d2

loc_DA44:
	move.w	d1,VDP_DATA
	dbf	d2,loc_DA44
	addq.w	#1,d1
	dbf	d0,loc_DA36
	ENABLE_INTS
	rts

; =============== S U B	R O U T	I N E =====================================================


sub_DA5A:
	jsr	SetVRAMWrite
	addi.w	#$80,d5
	move.w	#$17,d0
	move.w	#$2160,d1

loc_DA6C:
	move.w	d1,VDP_DATA
	addq.w	#1,d1
	dbf	d0,loc_DA6C
	jsr	SetVRAMWrite
	move.w	#$17,d0

loc_DA82:
	move.w	d1,VDP_DATA
	addq.w	#1,d1
	dbf	d0,loc_DA82
	rts
; End of function sub_DA5A


; =============== S U B	R O U T	I N E =====================================================


sub_DA90:
	bsr.w	sub_DBAC
	bsr.w	sub_DBF4
	lea	(sub_DAC8).l,a1
	jsr	FindActorSlot
	bcc.w	loc_DAAA
	rts
; -----------------------------------------------------------------------------------------

loc_DAAA:
	move.w	#1,$12(a1)
	move.w	#$A,$28(a1)
	move.b	#$FF,bytecode_flag
	bsr.w	EnableLineHScroll
	bsr.w	sub_ED9C
	rts
; End of function sub_DA90


; =============== S U B	R O U T	I N E =====================================================


sub_DAC8:



	jsr	(GetCtrlData).l
	btst	#7,d0
	beq.w	loc_DAE4
	jsr	(DummiedFunc).l
	bcs.w	loc_DAE4
	bra.w	loc_DB4A
; -----------------------------------------------------------------------------------------

loc_DAE4:
	andi.b	#$70,d0
	bne.w	loc_DAF4
	tst.w	$26(a0)
	bne.w	loc_DB30

loc_DAF4:
	subq.w	#1,$28(a0)
	bcs.w	loc_DB58
	move.w	#$9200,d0
	move.b	$29(a0),d0
	swap	d0
	jsr	QueuePlaneCmd
	move.w	#$50,$26(a0)
	move.b	#SFX_MENU_MOVE,d0
	cmpi.w	#1,$28(a0)
	bne.s	loc_DB2A
	move.b	#SFX_ROBOTNIK_LAUGH_2,d0
	move.b	#$88,(word_FF1990+1).l

loc_DB2A:
	jsr	PlaySound_ChkSamp

loc_DB30:
	subq.w	#1,$26(a0)
	bsr.w	sub_DB66
	bsr.w	loc_DBB8
	move.b	$27(a0),d0
	andi.b	#3,d0
	beq.w	loc_DBD2
	rts
; -----------------------------------------------------------------------------------------

loc_DB4A:
	move.b	#SFX_MENU_SELECT,d0
	bsr.w	PlaySound_ChkSamp
	clr.b	bytecode_flag

loc_DB58:
	clr.b	(bytecode_disabled).l
	jsr	(ActorBookmark).l
	rts
; End of function sub_DAC8


; =============== S U B	R O U T	I N E =====================================================


sub_DB66:
	lea	hblank_buffer_1,a1
	addq.w	#1,(a1)
	move.w	(a1),d0
	move.w	#$B4,d1
	jsr	(Sin).l
	lea	2(a1),a1
	moveq	#0,d0
	move.w	#$6F,d1

loc_DB84:
	move.l	d0,(a1)+
	add.l	d2,d0
	dbf	d1,loc_DB84
	lea	((hblank_buffer_1+2)).l,a1
	lea	((hscroll_buffer+2)).l,a2
	move.w	#$6F,d1

loc_DB9C:
	move.w	(a1),(a2)+
	move.w	#0,(a2)+
	lea	4(a1),a1
	dbf	d1,loc_DB9C
	rts
; End of function sub_DB66


; =============== S U B	R O U T	I N E =====================================================


sub_DBAC:
	lea	((hscroll_buffer+$302)).l,a1
	move.w	#$80,d0
	bra.s	loc_DBC2
; -----------------------------------------------------------------------------------------

loc_DBB8:
	lea	((hscroll_buffer+$302)).l,a1
	subq.w	#2,(a1)
	move.w	(a1),d0

loc_DBC2:
	move.w	#$F,d1

loc_DBC6:
	move.w	d0,(a1)+
	move.w	#0,(a1)+
	dbf	d1,loc_DBC6
	rts
; End of function sub_DBAC

; -----------------------------------------------------------------------------------------
; START	OF FUNCTION CHUNK FOR sub_DAC8

loc_DBD2:
	move.w	$2A(a0),d0
	jsr	(sub_BC82).l
	move.w	d0,$2A(a0)
	move.w	d1,(palette_buffer+$7E).l
	moveq	#3,d0
	lea	((palette_buffer+$60)).l,a2
	jmp	LoadPalette
; END OF FUNCTION CHUNK	FOR sub_DAC8

; =============== S U B	R O U T	I N E =====================================================


sub_DBF4:
	move.w	#7,d0

loc_DBF8:
	lea	(loc_DC44).l,a1
	jsr	FindActorSlotQuick
	bcs.w	loc_DC2E
	move.b	#$83,6(a1)
	move.b	#$1F,8(a1)
	move.b	d0,9(a1)
	move.w	d0,d1
	lsl.w	#1,d1
	move.w	word_DC34(pc,d1.w),$1E(a1)
	lsl.b	#4,d1
	move.b	d1,$36(a1)
	move.w	#$A0,$38(a1)

loc_DC2E:
	dbf	d0,loc_DBF8
	rts
; End of function sub_DBF4

; -----------------------------------------------------------------------------------------
word_DC34
	dc.w	$C8
	dc.w	$E0
	dc.w	$F8
	dc.w	$110
	dc.w	$130
	dc.w	$148
	dc.w	$160
	dc.w	$178
; -----------------------------------------------------------------------------------------

loc_DC44:
	move.b	$36(a0),d0
	move.w	$38(a0),d1
	jsr	(Sin).l
	asr.l	#8,d2
	addi.w	#$120,d2
	move.w	d2,$A(a0)
	addi.b	#$10,d0
	jsr	(Cos).l
	asr.l	#8,d2
	addi.w	#$F0,d2
	move.w	d2,$E(a0)
	addq.b	#2,$36(a0)
	subq.w	#1,$38(a0)
	bcs.w	loc_DC7E
	rts
; -----------------------------------------------------------------------------------------

loc_DC7E:
	clr.w	d0
	move.b	9(a0),d0
	lsl.w	#3,d0
	move.w	d0,$26(a0)
	clr.b	$36(a0)
	move.w	$1E(a0),d0
	subi.w	#$120,d0
	swap	d0
	asr.l	#7,d0
	move.l	d0,$12(a0)
	move.l	#$FFFF9000,$16(a0)
	jsr	(ActorBookmark).l
	tst.w	$26(a0)
	beq.w	loc_DCBA
	subq.w	#1,$26(a0)
	rts
; -----------------------------------------------------------------------------------------

loc_DCBA:
	move.w	#$80,$26(a0)
	move.l	$E(a0),$32(a0)
	jsr	(ActorBookmark).l
	move.l	$32(a0),$E(a0)
	jsr	(ActorMove).l
	move.l	$E(a0),$32(a0)
	subq.w	#1,$26(a0)
	beq.w	loc_DD00
	move.b	$27(a0),d0
	ori.b	#$80,d0
	move.w	#$7800,d1
	jsr	(Sin).l
	swap	d2
	add.w	d2,$E(a0)
	rts
; -----------------------------------------------------------------------------------------

loc_DD00:
	jsr	(ActorBookmark).l
	jsr	(DummiedFunc).l
	move.b	$36(a0),d0
	ori.b	#$80,d0
	move.w	#$1800,d1
	jsr	(Sin).l
	swap	d2
	addi.w	#$B8,d2
	move.w	d2,$E(a0)
	addq.b	#2,$36(a0)
	rts
; -----------------------------------------------------------------------------------------
	tst.b	9(a0)
	beq.w	loc_DD3C
	jmp	(ActorDeleteSelf).l
; -----------------------------------------------------------------------------------------

loc_DD3C:
	move.b	#0,6(a0)
	jsr	(ActorBookmark).l
	move.l	#$800B0F00,d0
	tst.b	swap_fields
	beq.w	loc_DD5E
	move.l	#$80100F00,d0

loc_DD5E:
	jmp	QueuePlaneCmd

; =============== S U B	R O U T	I N E =====================================================


LoadTimerCtrlSkip:
	lea	(ActTimerCtrlSkip).l,a1
	jsr	FindActorSlot
	bcc.w	.SetTimer
	rts
; -----------------------------------------------------------------------------------------

.SetTimer:
	move.w	#$A00,$26(a1)
	rts
; End of function LoadTimerCtrlSkip


; =============== S U B	R O U T	I N E =====================================================


LoadCtrlWait:
	lea	(ActTimerCtrlSkip).l,a1
	jmp	FindActorSlot
; End of function LoadCtrlWait


; =============== S U B	R O U T	I N E =====================================================


ActTimerCtrlSkip:
	move.b	p1_ctrl+ctlPress,d0
	or.b	p2_ctrl+ctlPress,d0
	andi.b	#$F0,d0
	bne.w	.Skip
	tst.w	aField26(a0)
	bne.w	.ChkTimer
	rts
; -----------------------------------------------------------------------------------------

.ChkTimer:
	subq.w	#1,aField26(a0)
	beq.w	.NotSkipped
	rts
; -----------------------------------------------------------------------------------------

.Skip:
	move.b	#$FF,bytecode_flag
	clr.b	(bytecode_disabled).l
	jmp	(ActorDeleteSelf).l
; -----------------------------------------------------------------------------------------

.NotSkipped:
	clr.b	bytecode_flag
	clr.b	(bytecode_disabled).l
	jmp	(ActorDeleteSelf).l
; End of function ActTimerCtrlSkip


; =============== S U B	R O U T	I N E =====================================================


sub_DDD8:
	lea	(sub_DE0E).l,a1
	jsr	FindActorSlotQuick
	bcc.w	loc_DDEA
	rts
; -----------------------------------------------------------------------------------------

loc_DDEA:
	move.b	#$80,6(a1)
	move.b	#$1C,8(a1)
	clr.w	d0
	move.b	bytecode_flag,d0
	lsl.b	#2,d0
	move.w	word_DE30(pc,d0.w),$A(a1)
	move.w	word_DE32(pc,d0.w),$E(a1)
	rts
; End of function sub_DDD8


; =============== S U B	R O U T	I N E =====================================================


sub_DE0E:
	jsr	(DummiedFunc).l
	bcs.w	loc_DE1E
	jmp	(ActorDeleteSelf).l
; -----------------------------------------------------------------------------------------

loc_DE1E:
	move.b	(frame_count+1).l,d0
	lsl.b	#2,d0
	andi.b	#$80,d0
	move.b	d0,6(a0)
	rts
; End of function sub_DE0E

; -----------------------------------------------------------------------------------------
word_DE30
	dc.w	$EE
word_DE32
	dc.w	$100
	dc.w	$8E
	dc.w	$E0
	dc.w	$8E
	dc.w	$E0

; =============== S U B	R O U T	I N E =====================================================


InitTitle:
	bsr.w	InitTitleFlags
	jsr	(ClearScroll).l
	lea	(ActTitleHandler).l,a1
	jsr	FindActorSlot
	bcs.w	loc_DECC
	lea	(ActTitleRobotnik).l,a1
	jsr	FindActorSlot
	bcs.w	loc_DECC
	move.b	#1,aField26(a1)
	movea.l	a1,a2
	lea	(ActTitleMachineText).l,a1
	jsr	FindActorSlot
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
	jsr	FindActorSlot
	bcs.w	loc_DECC
	move.l	a3,aField2E(a1)
	move.l	(a2)+,aAnim(a1)
	move.b	#$24,aMappings(a1)
	move.w	(a2)+,aX(a1)
	move.w	(a2)+,aY(a1)
	dbf	d0,loc_DEA6

loc_DECC:
	lea	(ActTitleRobotnikText).l,a1
	jsr	FindActorSlot
	bcs.w	locret_DEFA
	move.b	#$24,aMappings(a1)
	move.b	#$49,aFrame(a1)
	move.w	#$98,aX(a1)
	move.w	#$90,aY(a1)
	move.b	#$80,aFlags(a1)

locret_DEFA:
	rts
; End of function InitTitle

; -----------------------------------------------------------------------------------------
TitleAnimPieces:dc.l	ActTitleHPiston
	dc.l	Anim_TitleHPiston
	dc.w	$FFA0
	dc.w	$D0
	dc.l	ActTitleHLeftMeter
	dc.l	Anim_TitleHLeftMeter
	dc.w	$FFB0
	dc.w	$10F
	dc.l	ActTitleNElectricity
	dc.l	ActTitleNElectricity
	dc.w	$FFE8
	dc.w	$DF
	dc.l	ActTitleHRightMeters
	dc.l	Anim_TitleHRightMeters
	dc.w	$FFC0
	dc.w	$F8
	dc.l	ActTitleHSiren
	dc.l	Anim_TitleHSiren
	dc.w	$FFC3
	dc.w	$E3
	dc.l	ActTitleALight
	dc.l	ActTitleALight
	dc.w	$FF78
	dc.w	$F4
	dc.l	ActTitleILights
	dc.l	ActTitleILights
	dc.w	$FFCF
	dc.w	$10A
	dc.l	ActTitleESteam1
	dc.l	Anim_TitleESteam1
	dc.w	$2F
	dc.w	$E9
	dc.l	ActTitleESteam2
	dc.l	Anim_TitleESteam2
	dc.w	$35
	dc.w	$EA
	dc.l	ActTitleCParticles
	dc.l	ActTitleCParticles
	dc.w	$FF9F
	dc.w	$F8

; =============== S U B	R O U T	I N E =====================================================


sub_DF74:
	movem.l	d0,-(sp)
	clr.w	d0
	move.b	(difficulty).l,d0
	move.b	unk_DF8E(pc,d0.w),(byte_FF0104).l
	movem.l	(sp)+,d0
	rts
; End of function sub_DF74

; -----------------------------------------------------------------------------------------
unk_DF8E
	dc.b	0
	dc.b	2
	dc.b	4
	dc.b	6

; =============== S U B	R O U T	I N E =====================================================


InitTitleFlags:
	bsr.s	sub_DF74
	clr.l	dword_FF195C
	clr.l	dword_FF1960
	clr.w	(word_FF010E).l
	clr.w	(word_FF0110).l
	clr.w	p1_pause
	clr.w	stage
	clr.b	(byte_FF0115).l
	clr.b	(byte_FF0105).l
	clr.b	(word_FF1124).l
	clr.b	swap_fields
	clr.w	(word_FF1126).l
	move.w	#$9003,d0
	move.w	d0,VDP_CTRL
	move.b	d0,(vdp_reg_10).l
	move.w	#$8B00,d0
	move.w	d0,VDP_CTRL
	move.b	d0,vdp_reg_b
	move.w	#$11,d0
	lea	opponents_defeated,a1

loc_E000:
	clr.b	(a1)+
	dbf	d0,loc_E000
	rts
; End of function InitTitleFlags


; =============== S U B	R O U T	I N E =====================================================


ActTitleRobotnik:
	cmpi.w	#1,(word_FF1126).l
	beq.w	loc_E078
	subq.b	#1,$26(a0)
	beq.s	loc_E01C
	rts
; -----------------------------------------------------------------------------------------

loc_E01C:
	move.w	$28(a0),d0
	addq.w	#1,$28(a0)
	add.w	d0,d0
	lea	(unk_E07E).l,a1
	adda.w	d0,a1
	clr.w	d0
	move.b	(a1)+,d0
	bmi.w	loc_E078
	move.b	(a1),d1
	move.b	d1,$26(a0)
	cmpi.b	#2,d0
	bne.s	loc_E050
	move.l	d0,-(sp)
	move.b	#$94,d0
	jsr	PlaySound_ChkSamp
	move.l	(sp)+,d0

loc_E050:
	lsl.w	#3,d0
	lea	(unk_E0BA).l,a1
	adda.w	d0,a1
	lea	((palette_buffer+$6C)).l,a2
	moveq	#3,d0

loc_E062:
	move.w	(a1)+,(a2)+
	dbf	d0,loc_E062
	move.b	#3,d0
	lea	((palette_buffer+$60)).l,a2
	jmp	LoadPalette
; -----------------------------------------------------------------------------------------

loc_E078:
	jmp	(ActorDeleteSelf).l
; End of function ActTitleRobotnik

; -----------------------------------------------------------------------------------------
unk_E07E
	dc.b	0
	dc.b	$5A
	dc.b	1
	dc.b	1
	dc.b	2
	dc.b	1
	dc.b	1
	dc.b	1
	dc.b	3
	dc.b	5
	dc.b	1
	dc.b	1
	dc.b	2
	dc.b	1
	dc.b	1
	dc.b	1
	dc.b	3
	dc.b	5
	dc.b	4
	dc.b	5
	dc.b	5
	dc.b	5
	dc.b	6
	dc.b	5
	dc.b	0
	dc.b	$5A
	dc.b	1
	dc.b	1
	dc.b	2
	dc.b	1
	dc.b	1
	dc.b	1
	dc.b	3
	dc.b	5
	dc.b	1
	dc.b	1
	dc.b	2
	dc.b	1
	dc.b	1
	dc.b	1
	dc.b	3
	dc.b	5
	dc.b	4
	dc.b	5
	dc.b	5
	dc.b	5
	dc.b	6
	dc.b	5
	dc.b	0
	dc.b	$5A
	dc.b	6
	dc.b	6
	dc.b	5
	dc.b	6
	dc.b	4
	dc.b	6
	dc.b	3
	dc.b	6
	dc.b	$FF
	dc.b	0
unk_E0BA
	dc.b	2
	dc.b	0
	dc.b	2
	dc.b	0
	dc.b	2
	dc.b	0
	dc.b	2
	dc.b	0
	dc.b	$A
	dc.b	0
	dc.b	8
	dc.b	0
	dc.b	6
	dc.b	0
	dc.b	$A
	dc.b	0
	dc.b	$A
	dc.b	0
	dc.b	8
	dc.b	0
	dc.b	$A
	dc.b	0
	dc.b	$A
	dc.b	$20
	dc.b	$A
	dc.b	0
	dc.b	8
	dc.b	0
	dc.b	6
	dc.b	0
	dc.b	4
	dc.b	0
	dc.b	8
	dc.b	0
	dc.b	6
	dc.b	0
	dc.b	4
	dc.b	0
	dc.b	2
	dc.b	0
	dc.b	6
	dc.b	0
	dc.b	4
	dc.b	0
	dc.b	2
	dc.b	0
	dc.b	2
	dc.b	0
	dc.b	4
	dc.b	0
	dc.b	2
	dc.b	0
	dc.b	2
	dc.b	0
	dc.b	2
	dc.b	0

; =============== S U B	R O U T	I N E =====================================================


ActTitleRobotnikText:
	move.w	#$90,d0
	add.w	(vscroll_buffer).l,d0
	move.w	d0,$E(a0)
	rts
; End of function ActTitleRobotnikText


; =============== S U B	R O U T	I N E =====================================================


ActTitleHandler:
	move.w	#$FFFF,(is_japan).l
	bsr.w	CheckIfJapan
	move.b	p1_ctrl+ctlPress,d0
	or.b	p2_ctrl+ctlPress,d0
	andi.b	#$F0,d0
	beq.s	.End
	tst.b	(word_FF1126+1).l
	bmi.w	.loc_E142
	bne.s	.End
	move.w	#1,(word_FF1126).l
	lea	(.FadeToBlack).l,a1
	jsr	FindActorSlot
	rts
; -----------------------------------------------------------------------------------------

.loc_E142:
	btst	#7,d0
	beq.w	.End
	jsr	(DummiedFunc).l
	bcc.w	loc_ECE8

.End:
	rts
; -----------------------------------------------------------------------------------------

.FadeToBlack:
	moveq	#3,d3

.LineFade:
	lea	Palettes,a2
	move.w	d3,d0
	moveq	#0,d1
	jsr	(FadeToPalette).l
	dbf	d3,.LineFade
	jsr	(ActorBookmark).l
	jsr	(CheckPaletteFade).l
	bcc.w	.SetupScr
	rts
; -----------------------------------------------------------------------------------------

.SetupScr:
	move.w	#2,(word_FF1126).l
	move.w	#$160,(hscroll_buffer).l
	move.w	#0,(vscroll_buffer).l
	bsr.w	sub_E202
	move.w	#$1E,d0
	jsr	(ActorBookmark_SetDelay).l
	jsr	(ActorBookmark).l
	moveq	#3,d3

.FadeToPal:
	lea	Palettes,a2
	move.l	d3,d0
	move.l	d0,d2
	addi.w	#$4F,d2
	lsl.w	#5,d2
	adda.l	d2,a2
	moveq	#0,d1
	jsr	(FadeToPalette).l
	dbf	d3,.FadeToPal
	jsr	(ActorBookmark).l
	jsr	(CheckPaletteFade).l
	bcc.w	.Delay
	rts
; -----------------------------------------------------------------------------------------

.Delay:
	move.w	#3,(word_FF1126).l
	move.w	#$3C,d0
	jsr	(ActorBookmark_SetDelay).l
	jsr	(ActorBookmark).l
	move.w	#$FFFF,(word_FF1126).l
	jmp	(ActorDeleteSelf).l
; End of function ActTitleHandler


; =============== S U B	R O U T	I N E =====================================================


sub_E202:
	lea	(off_E314).l,a2
	moveq	#7,d0
	moveq	#1,d2

loc_E20C:
	lea	(sub_E27E).l,a1
	jsr	FindActorSlot
	bcs.w	locret_E242
	move.l	(a2)+,$32(a1)
	move.w	(a2)+,$A(a1)
	move.w	(a2)+,$E(a1)
	move.b	#$80,6(a1)
	move.b	#$24,8(a1)
	move.b	d2,$22(a1)
	addq.w	#4,d2
	move.w	d0,$26(a1)
	dbf	d0,loc_E20C

locret_E242:
	rts
; End of function sub_E202

; -----------------------------------------------------------------------------------------
; START	OF FUNCTION CHUNK FOR sub_E678

loc_E244:
	cmpi.w	#2,(word_FF1126).l
	beq.w	loc_E6A8
	bsr.w	sub_E2CE
	bcs.w	loc_E2B2
	jsr	(ActorBookmark).l
	move.w	$2A(a0),d0
	cmpi.w	#$B,d0
	bne.w	loc_E294
	move.w	#0,$2A(a0)
	move.l	#loc_E244,2(a0)
	jmp	(ActorAnimate).l
; END OF FUNCTION CHUNK	FOR sub_E678

; =============== S U B	R O U T	I N E =====================================================


sub_E27E:



	bsr.w	sub_E2CE
	bcs.s	loc_E2B2
	jsr	(ActorBookmark).l
	move.w	$2A(a0),d0
	cmpi.w	#$B,d0
	beq.s	loc_E2A4
; End of function sub_E27E

; START	OF FUNCTION CHUNK FOR sub_E678

loc_E294:
	add.w	d0,d0
	move.w	unk_E2B8(pc,d0.w),d0
	add.w	d0,$E(a0)
	addq.w	#1,$2A(a0)
	bra.s	loc_E2B2
; END OF FUNCTION CHUNK	FOR sub_E678
; -----------------------------------------------------------------------------------------
; START	OF FUNCTION CHUNK FOR sub_E27E

loc_E2A4:
	move.w	#0,$2A(a0)
	move.l	#sub_E27E,2(a0)
; END OF FUNCTION CHUNK	FOR sub_E27E
; START	OF FUNCTION CHUNK FOR sub_E678

loc_E2B2:
	jmp	(ActorAnimate).l
; END OF FUNCTION CHUNK	FOR sub_E678
; -----------------------------------------------------------------------------------------
unk_E2B8
	dc.b	$FF
	dc.b	$F0
	dc.b	$FF
	dc.b	$F8
	dc.b	$FF
	dc.b	$FC
	dc.b	$FF
	dc.b	$FE
	dc.b	$FF
	dc.b	$FF
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	1
	dc.b	0
	dc.b	2
	dc.b	0
	dc.b	4
	dc.b	0
	dc.b	8
	dc.b	0
	dc.b	$10

; =============== S U B	R O U T	I N E =====================================================


sub_E2CE:
	move.b	p1_ctrl+ctlPress,d1
	lsl.w	#8,d1
	move.b	p2_ctrl+ctlPress,d1
	move.w	$26(a0),d0
	add.w	d0,d0
	move.w	unk_E304(pc,d0.w),d0
	and.w	d0,d1
	beq.s	loc_E2FE
	move.w	$26(a0),d0
	addi.b	#$4C,d0
	jsr	PlaySound_ChkSamp
	andi	#$FFFE,sr
	rts
; -----------------------------------------------------------------------------------------

loc_E2FE:
	ori	#1,sr
	rts
; End of function sub_E2CE

; -----------------------------------------------------------------------------------------
unk_E304
	dc.b	$F
	dc.b	0
	dc.b	$40
	dc.b	0
	dc.b	$10
	dc.b	0
	dc.b	$20
	dc.b	0
	dc.b	0
	dc.b	$F
	dc.b	0
	dc.b	$40
	dc.b	0
	dc.b	$10
	dc.b	0
	dc.b	$20
off_E314
	dc.l	unk_E786
	dc.w	$16C
	dc.w	$BE
	dc.l	unk_E76A
	dc.w	$154
	dc.w	$C3
	dc.l	unk_E74E
	dc.w	$13E
	dc.w	$B9
	dc.l	unk_E7A2
	dc.w	$127
	dc.w	$C4
	dc.l	unk_E786
	dc.w	$10B
	dc.w	$C9
	dc.l	unk_E76A
	dc.w	$F3
	dc.w	$BD
	dc.l	unk_E74E
	dc.w	$DD
	dc.w	$CA
	dc.l	unk_E732
	dc.w	$C3
	dc.w	$C2
; -----------------------------------------------------------------------------------------

ActTitleMachineText:
	cmpi.w	#2,(word_FF1126).l
	beq.w	loc_E4E2
	movea.l	$2E(a0),a1
	cmpi.w	#$1A,$28(a1)
	beq.s	loc_E36E
	rts
; -----------------------------------------------------------------------------------------

loc_E36E:
	move.b	#BGM_TITLE,d0
	jsr	JmpTo_PlaySound
	move.b	#1,(word_FF1124).l
	jsr	(ActorBookmark).l
	jsr	Random
	andi.b	#$1F,d0
	move.b	d0,aField26(a0)
	move.b	#6,aField28(a0)
	move.b	#6,aField29(a0)
	jsr	(ActorBookmark).l
	cmpi.w	#2,(word_FF1126).l
	beq.w	loc_E4E2
	cmpi.w	#$160,(hscroll_buffer).l
	beq.w	loc_E416
	addq.w	#1,(hscroll_buffer).l

loc_E3C4:
	tst.b	aField26(a0)
	beq.s	loc_E3D2
	subq.b	#1,aField26(a0)
	bra.w	sub_E40E
; -----------------------------------------------------------------------------------------

loc_E3D2:
	tst.b	aField28(a0)
	beq.s	loc_E3E4
	subq.b	#1,aField28(a0)
	addq.w	#2,(vscroll_buffer).l
	bra.s	sub_E40E
; -----------------------------------------------------------------------------------------

loc_E3E4:
	tst.b	aField29(a0)
	beq.s	loc_E3F6
	subq.b	#1,aField29(a0)
	subq.w	#2,(vscroll_buffer).l
	bra.s	sub_E40E
; -----------------------------------------------------------------------------------------

loc_E3F6:
	jsr	Random
	andi.w	#$707,d0
	move.b	d0,aField26(a0)
	lsr.w	#8,d0
	move.b	d0,aField28(a0)
	move.b	d0,aField29(a0)

; =============== S U B	R O U T	I N E =====================================================


sub_E40E:
	move.w	#0,d0
	bra.w	sub_EBF8
; End of function sub_E40E

; -----------------------------------------------------------------------------------------

loc_E416:
	tst.w	(vscroll_buffer).l
	bne.w	loc_E3C4
	bsr.s	sub_E40E
	move.l	#unk_E5FA,$32(a0)
	move.w	#$3C,d0
	jsr	(ActorBookmark_SetDelay).l
	cmpi.w	#2,(word_FF1126).l
	beq.w	loc_E4DC
	jsr	(ActorBookmark).l
	cmpi.w	#2,(word_FF1126).l
	beq.w	loc_E4E2
	move.b	#1,$2C(a0)
	jsr	(ActorAnimate).l
	bcs.s	loc_E462
	rts
; -----------------------------------------------------------------------------------------

loc_E462:
	move.l	#unk_E606,$32(a0)
	move.b	#0,$22(a0)
	jsr	(ActorBookmark).l
	cmpi.w	#2,(word_FF1126).l
	beq.w	loc_E4E2
	jsr	(ActorAnimate).l
	cmpi.b	#$3F,9(a0)
	bne.s	locret_E4B2
	cmpi.b	#3,$22(a0)
	bne.s	locret_E4B2
	bsr.w	sub_E61E
	move.b	#$57,d0
	jsr	PlaySound_ChkSamp
	addq.w	#1,$2A(a0)
	cmpi.w	#8,$2A(a0)
	beq.s	loc_E4B4

locret_E4B2:
	rts
; -----------------------------------------------------------------------------------------

loc_E4B4:
	move.l	#unk_E612,$32(a0)
	move.b	#0,$22(a0)
	jsr	(ActorBookmark).l
	cmpi.w	#2,(word_FF1126).l
	beq.s	loc_E4E2
	jsr	(ActorAnimate).l
	bcs.s	loc_E4E2
	rts
; -----------------------------------------------------------------------------------------

loc_E4DC:
	move.w	#0,$24(a0)

loc_E4E2:
	tst.w	(word_FF1126).l
	bne.s	loc_E4F2
	move.w	#4,(word_FF1126).l

loc_E4F2:
	tst.b	(word_FF1124).l
	bne.s	loc_E504
	move.b	#$1A,d0
	jsr	JmpTo_PlaySound

loc_E504:
	move.w	#0,d0
	bsr.w	sub_EBF8
	move.b	#$39,9(a0)
	move.b	#$80,6(a0)
	move.b	#2,$2C(a0)
	lea	(locret_E5B6).l,a1
	jsr	FindActorSlot
	bcs.w	loc_E54C
	move.b	#$80,6(a1)
	move.w	#$197,$A(a1)
	move.w	#$100,$E(a1)
	move.b	#$24,8(a1)
	move.b	#$48,9(a1)

loc_E54C:			
	lea	(Str_SegaCpy).l,a1
	move.w	#$F918,d5
	bsr.w	sub_EC6A
	lea	(Str_CompileCpy).l,a1
	move.w	#$FA18,d5
	bsr.w	sub_EC6A
	move.w	#$2B2,$28(a0)
	jsr	(ActorBookmark).l
	cmpi.w	#$258,$28(a0)
	bne.s	loc_E584
	move.w	#$FFFF,(word_FF1126).l

loc_E584:
	subq.w	#1,$28(a0)
	beq.w	loc_E5B8
	addq.b	#1,$26(a0)
	move.b	$26(a0),d0
	move.b	d0,d1
	andi.b	#$F,d0
	bne.s	locret_E5B6
	lea	(Str_PressStart).l,a1
	move.w	#$D6BA,d5
	andi.b	#$10,d1
	beq.s	loc_E5B2
	bsr.w	sub_EC98
	bra.s	locret_E5B6
; -----------------------------------------------------------------------------------------

loc_E5B2:
	bsr.w	sub_EC6A

locret_E5B6:
	rts
; -----------------------------------------------------------------------------------------

loc_E5B8:
	move.b	#1,bytecode_flag
	clr.b	(bytecode_disabled).l
	rts
; -----------------------------------------------------------------------------------------
Str_PressStart
	dc.b	"PRESS  START  BUTTON",$FF,0
Str_CompileCpy
	dc.b	"@ 1993 COMPILE",$FF,0
Str_SegaCpy
	dc.b	"@ 1993 ()*+",$FF
unk_E5FA
	dc.b	5
	dc.b	$39
	dc.b	5
	dc.b	$3A
	dc.b	5
	dc.b	$3B
	dc.b	$28
	dc.b	$3C
	dc.b	$FE
	dc.b	0
unk_E604
	dc.b	$1E
	dc.b	$3C
unk_E606
	dc.b	4
	dc.b	$3D
	dc.b	8
	dc.b	$3E
	dc.b	4
	dc.b	$3F
	dc.b	$FF
	dc.b	0
	dc.l	unk_E604
unk_E612
	dc.b	3
	dc.b	$3F
	dc.b	$78
	dc.b	$3C
	dc.b	5
	dc.b	$3B
	dc.b	5
	dc.b	$3A
	dc.b	$28
	dc.b	$39
	dc.b	$FE
	dc.b	0

; =============== S U B	R O U T	I N E =====================================================


sub_E61E:
	lea	(sub_E678).l,a1
	jsr	FindActorSlot
	bcs.w	locret_E676
	move.w	$2A(a0),d0
	move.w	d0,$26(a1)
	lsl.w	#4,d0
	lea	(off_E6AE).l,a2
	adda.w	d0,a2
	move.w	#$100,$20(a1)
	move.b	#$BF,6(a1)
	move.w	#$180,$A(a1)
	move.w	#$D0,$E(a1)
	move.l	(a2)+,$32(a1)
	move.l	(a2)+,$12(a1)
	move.l	(a2)+,$16(a1)
	move.b	#$24,8(a1)
	move.b	(a2)+,9(a1)
	move.b	(a2)+,$1C(a1)
	move.w	(a2),$28(a1)

locret_E676:
	rts
; End of function sub_E61E


; =============== S U B	R O U T	I N E =====================================================


sub_E678:

	cmpi.w	#2,(word_FF1126).l
	beq.s	loc_E6A8
	jsr	(ActorMove).l
	move.w	$28(a0),d0
	cmp.w	$A(a0),d0
	blt.s	locret_E6A6
	jsr	(ActorBookmark).l
	cmpi.w	#2,(word_FF1126).l
	beq.s	loc_E6A8
	bra.w	loc_E244
; -----------------------------------------------------------------------------------------

locret_E6A6:
	rts
; -----------------------------------------------------------------------------------------

loc_E6A8:
	jmp	(ActorDeleteSelf).l
; End of function sub_E678

; -----------------------------------------------------------------------------------------
off_E6AE
	dc.l	unk_E72E
	dc.l	$FFFD0000
	dc.l	$FFF9F800
	dc.b	$C
	dc.b	$30
	dc.w	$C3
	dc.l	unk_E74A
	dc.l	$FFFD2800
	dc.l	$FFFA8C00
	dc.b	6
	dc.b	$31
	dc.w	$DD
	dc.l	unk_E766
	dc.l	$FFFD4000
	dc.l	$FFF97A00
	dc.b	$36
	dc.b	$3F
	dc.w	$F3
	dc.l	unk_E782
	dc.l	$FFFC4000
	dc.l	$FFFC7600
	dc.b	$25
	dc.b	$39
	dc.w	$10B
	dc.l	unk_E79E
	dc.l	$FFFE4E00
	dc.l	$FFF88200
	dc.b	$C
	dc.b	$49
	dc.w	$127
	dc.l	unk_E74A
	dc.l	$FFFEEE00
	dc.l	$FFF48000
	dc.b	6
	dc.b	$5F
	dc.w	$13E
	dc.l	unk_E766
	dc.l	$FFFDEE00
	dc.l	$FFFDD200
	dc.b	$36
	dc.b	$28
	dc.w	$154
	dc.l	unk_E782
	dc.l	$FFFFA000
	dc.l	$FFFAC800
	dc.b	$25
	dc.b	$32
	dc.w	$16C
unk_E72E
	dc.b	5
	dc.b	$D
	dc.b	5
	dc.b	$E
unk_E732
	dc.b	4
	dc.b	$15
	dc.b	4
	dc.b	$16
	dc.b	2
	dc.b	$15
	dc.b	3
	dc.b	$17
	dc.b	2
	dc.b	$15
	dc.b	4
	dc.b	$16
	dc.b	2
	dc.b	$15
	dc.b	3
	dc.b	$17
	dc.b	$28
	dc.b	$15
	dc.b	$FF
	dc.b	0
	dc.l	unk_E732
unk_E74A
	dc.b	5
	dc.b	7
	dc.b	5
	dc.b	8
unk_E74E
	dc.b	4
	dc.b	9
	dc.b	4
	dc.b	$A
	dc.b	2
	dc.b	9
	dc.b	3
	dc.b	$B
	dc.b	2
	dc.b	9
	dc.b	4
	dc.b	$A
	dc.b	2
	dc.b	9
	dc.b	3
	dc.b	$B
	dc.b	$28
	dc.b	9
	dc.b	$FF
	dc.b	0
	dc.l	unk_E74E
unk_E766
	dc.b	5
	dc.b	$37
	dc.b	5
	dc.b	$38
unk_E76A
	dc.b	4
	dc.b	0
	dc.b	4
	dc.b	1
	dc.b	2
	dc.b	0
	dc.b	3
	dc.b	2
	dc.b	2
	dc.b	0
	dc.b	4
	dc.b	1
	dc.b	2
	dc.b	0
	dc.b	3
	dc.b	2
	dc.b	$28
	dc.b	0
	dc.b	$FF
	dc.b	0
	dc.l	unk_E76A
unk_E782
	dc.b	5
	dc.b	$26
	dc.b	5
	dc.b	$27
unk_E786
	dc.b	4
	dc.b	$1C
	dc.b	4
	dc.b	$1D
	dc.b	2
	dc.b	$1C
	dc.b	3
	dc.b	$1E
	dc.b	2
	dc.b	$1C
	dc.b	4
	dc.b	$1D
	dc.b	2
	dc.b	$1C
	dc.b	3
	dc.b	$1E
	dc.b	$28
	dc.b	$1C
	dc.b	$FF
	dc.b	0
	dc.l	unk_E786
unk_E79E
	dc.b	5
	dc.b	$D
	dc.b	5
	dc.b	$E
unk_E7A2
	dc.b	4
	dc.b	3
	dc.b	4
	dc.b	4
	dc.b	2
	dc.b	3
	dc.b	3
	dc.b	5
	dc.b	2
	dc.b	3
	dc.b	4
	dc.b	4
	dc.b	2
	dc.b	3
	dc.b	3
	dc.b	5
	dc.b	$28
	dc.b	3
	dc.b	$FF
	dc.b	0
	dc.l	unk_E7A2
; -----------------------------------------------------------------------------------------

ActTitleHPiston:
	jsr	(ActorAnimate).l
	movea.l	$2E(a0),a1
	tst.b	$2C(a1)
	bne.s	loc_E7D4
	move.w	#$FFA0,d0
	jmp	(sub_EBF8).l
; -----------------------------------------------------------------------------------------

loc_E7D4:
	move.w	#$FFA0,d0
	bsr.w	sub_EBF8
	cmpi.b	#$1F,9(a0)
	bne.s	locret_E7EA
	jsr	(ActorBookmark).l

locret_E7EA:
	rts
; -----------------------------------------------------------------------------------------
Anim_TitleHPiston:dc.b	$C
	dc.b	$1F
	dc.b	5
	dc.b	$20
	dc.b	5
	dc.b	$21
	dc.b	$B
	dc.b	$22
	dc.b	3
	dc.b	$23
	dc.b	5
	dc.b	$24
	dc.b	$FF
	dc.b	0
	dc.l	Anim_TitleHPiston
; -----------------------------------------------------------------------------------------

ActTitleHLeftMeter:
	jsr	(ActorAnimate).l
	movea.l	$2E(a0),a1
	tst.b	$2C(a1)
	bne.s	loc_E818
	move.w	#$FFB0,d0
	jmp	(sub_EBF8).l
; -----------------------------------------------------------------------------------------

loc_E818:
	move.w	#$FFB0,d0
	bsr.w	sub_EBF8
	cmpi.b	#$12,9(a0)
	bne.s	locret_E82E
	jsr	(ActorBookmark).l

locret_E82E:
	rts
; -----------------------------------------------------------------------------------------
Anim_TitleHLeftMeter:dc.b	$C
	dc.b	$12
	dc.b	5
	dc.b	$13
	dc.b	5
	dc.b	$14
	dc.b	$F
	dc.b	$11
	dc.b	5
	dc.b	$12
	dc.b	$FF
	dc.b	0
	dc.l	Anim_TitleHLeftMeter
; -----------------------------------------------------------------------------------------

ActTitleHRightMeters:
	jsr	(ActorAnimate).l
	move.w	#$FFC0,d0
	jmp	(sub_EBF8).l
; -----------------------------------------------------------------------------------------
Anim_TitleHRightMeters:dc.b	5
	dc.b	$18
	dc.b	5
	dc.b	$19
	dc.b	5
	dc.b	$1A
	dc.b	5
	dc.b	$1B
	dc.b	$FF
	dc.b	0
	dc.l	Anim_TitleHRightMeters
; -----------------------------------------------------------------------------------------

ActTitleHSiren:
	jsr	(ActorAnimate).l
	move.w	#$FFC3,d0
	jmp	(sub_EBF8).l
; -----------------------------------------------------------------------------------------
Anim_TitleHSiren:dc.b	3
	dc.b	$28
	dc.b	3
	dc.b	$29
	dc.b	3
	dc.b	$2A
	dc.b	3
	dc.b	$2B
	dc.b	3
	dc.b	$2C
	dc.b	$C
	dc.b	$2D
	dc.b	$FF
	dc.b	0
	dc.l	Anim_TitleHSiren
; -----------------------------------------------------------------------------------------

ActTitleESteam1:
	move.w	#$2F,$28(a0)
	bra.s	loc_E894
; -----------------------------------------------------------------------------------------

ActTitleESteam2:
	move.w	#$35,$28(a0)
	move.b	#$14,$2A(a0)

loc_E894:
	jsr	(ActorBookmark).l
	move.w	$28(a0),d0
	bsr.w	sub_EBF8
	cmpi.w	#1,(word_FF1126).l
	beq.s	loc_E8CA
	jsr	(ActorAnimate).l
	movea.l	$2E(a0),a1
	tst.b	$2C(a1)
	bne.s	loc_E8DE
	tst.b	9(a0)
	bne.s	locret_E8C8
	move.b	#0,6(a0)

locret_E8C8:
	rts
; -----------------------------------------------------------------------------------------

loc_E8CA:
	move.b	#0,6(a0)
	move.b	#0,9(a0)
	move.l	#Anim_TitleESteam2,$32(a0)

loc_E8DE:
	tst.b	9(a0)
	bne.s	locret_E924
	move.b	#0,6(a0)
	jsr	(ActorBookmark).l
	movea.l	$2E(a0),a1
	cmpi.b	#2,$2C(a1)
	bne.s	locret_E924
	move.b	$2A(a0),d0
	move.b	d0,$22(a0)
	jsr	(ActorBookmark).l
	jsr	(ActorAnimate).l
	move.w	$28(a0),d0
	bsr.w	sub_EBF8
	tst.b	9(a0)
	bne.s	locret_E924
	move.b	#0,6(a0)

locret_E924:
	rts
; -----------------------------------------------------------------------------------------
Anim_TitleESteam1:dc.b	5
	dc.b	$2E
	dc.b	5
	dc.b	$2F
	dc.b	5
	dc.b	$30
	dc.b	5
	dc.b	$31
	dc.b	5
	dc.b	$32
Anim_TitleESteam2:dc.b	$14
	dc.b	0
	dc.b	$FF
	dc.b	0
	dc.l	Anim_TitleESteam1
; -----------------------------------------------------------------------------------------

ActTitleCParticles:
	move.w	#1,$26(a0)
	jsr	(ActorBookmark).l
	movea.l	$2E(a0),a1
	tst.b	$2C(a1)
	bne.w	loc_E9E0
	move.w	#$FF9F,d0
	bsr.w	sub_EBF8
	move.b	#0,6(a0)
	subq.w	#1,$26(a0)
	bpl.s	locret_E9BE
	jsr	Random
	andi.w	#$F,d0
	addi.w	#$F,d0
	move.w	d0,$26(a0)
	lea	(loc_E9C0).l,a1
	jsr	FindActorSlot
	bcs.s	locret_E9BE
	move.w	$A(a0),$A(a1)
	move.w	$E(a0),$E(a1)
	move.w	#$3C,$26(a1)
	move.b	#$33,6(a1)
	move.b	#$24,8(a1)
	move.b	#$40,9(a1)
	move.b	#2,$22(a1)
	move.l	#unk_E9E6,$32(a1)
	move.l	#$FFFF8000,$16(a1)

locret_E9BE:
	rts
; -----------------------------------------------------------------------------------------

loc_E9C0:
	move.w	#$FF9F,d0
	bsr.w	sub_EBF8
	ori.b	#$3F,6(a0)
	jsr	(ActorMove).l
	jsr	(ActorAnimate).l
	subq.w	#1,$26(a0)
	bpl.s	locret_E9BE

loc_E9E0:
	jmp	(ActorDeleteSelf).l
; -----------------------------------------------------------------------------------------
unk_E9E6
	dc.b	2
	dc.b	$40
	dc.b	3
	dc.b	$41
	dc.b	2
	dc.b	$42
	dc.b	3
	dc.b	$43
	dc.b	2
	dc.b	$44
	dc.b	3
	dc.b	$45
	dc.b	2
	dc.b	$46
	dc.b	3
	dc.b	$47
	dc.b	$FF
	dc.b	0
	dc.l	unk_E9E6
; -----------------------------------------------------------------------------------------

ActTitleALight:
	move.b	#$10,9(a0)
	move.w	#$A,d0
	jsr	(ActorBookmark_SetDelay).l
	move.w	#$FF78,d0
	bsr.w	sub_EBF8
	jsr	(ActorBookmark).l
	tst.w	(word_FF1126).l
	ble.s	loc_EA36
	cmpi.w	#3,(word_FF1126).l
	beq.s	loc_EA36
	move.w	#$FF78,d0
	bsr.w	sub_EBF8
	rts
; -----------------------------------------------------------------------------------------

loc_EA36:
	move.w	#$FF78,d0
	bsr.w	sub_EBF8
	tst.b	$22(a0)
	beq.s	loc_EA4A
	subq.b	#1,$22(a0)
	rts
; -----------------------------------------------------------------------------------------

loc_EA4A:
	move.w	$26(a0),d0
	addq.b	#1,d0
	cmpi.b	#$C,d0
	blt.s	loc_EA5A
	move.b	#0,d0

loc_EA5A:
	move.w	d0,$26(a0)
	move.b	unk_EA98(pc,d0.w),d1
	move.b	d1,$22(a0)
	lsl.w	#3,d0
	lea	(unk_EAA4).l,a1
	adda.w	d0,a1
	move.w	(a1)+,(palette_buffer+$36).l
	move.w	(a1)+,(palette_buffer+$38).l
	move.w	(a1)+,(palette_buffer+$3A).l
	move.w	(a1),(palette_buffer+$3C).l
	move.b	#1,d0
	lea	((palette_buffer+$20)).l,a2
	jmp	LoadPalette
; -----------------------------------------------------------------------------------------
unk_EA98
	dc.b	$A
	dc.b	4
	dc.b	4
	dc.b	4
	dc.b	4
	dc.b	4
	dc.b	$A
	dc.b	4
	dc.b	4
	dc.b	4
	dc.b	4
	dc.b	4
unk_EAA4
	dc.b	0
	dc.b	$22
	dc.b	0
	dc.b	$24
	dc.b	0
	dc.b	$24
	dc.b	0
	dc.b	$24
	dc.b	0
	dc.b	$24
	dc.b	0
	dc.b	$26
	dc.b	0
	dc.b	$48
	dc.b	0
	dc.b	$6A
	dc.b	2
	dc.b	$48
	dc.b	0
	dc.b	$4A
	dc.b	2
	dc.b	$6A
	dc.b	2
	dc.b	$8C
	dc.b	2
	dc.b	$48
	dc.b	0
	dc.b	$6C
	dc.b	2
	dc.b	$AC
	dc.b	4
	dc.b	$CE
	dc.b	4
	dc.b	$6A
	dc.b	2
	dc.b	$8E
	dc.b	4
	dc.b	$CE
	dc.b	8
	dc.b	$CE
	dc.b	6
	dc.b	$8C
	dc.b	4
	dc.b	$AE
	dc.b	6
	dc.b	$CE
	dc.b	8
	dc.b	$EE
	dc.b	8
	dc.b	$CE
	dc.b	8
	dc.b	$EE
	dc.b	$A
	dc.b	$EE
	dc.b	$C
	dc.b	$EE
	dc.b	6
	dc.b	$8C
	dc.b	4
	dc.b	$AE
	dc.b	6
	dc.b	$CE
	dc.b	8
	dc.b	$EE
	dc.b	4
	dc.b	$6A
	dc.b	2
	dc.b	$8E
	dc.b	4
	dc.b	$CE
	dc.b	8
	dc.b	$CE
	dc.b	2
	dc.b	$48
	dc.b	0
	dc.b	$6C
	dc.b	2
	dc.b	$AC
	dc.b	4
	dc.b	$CE
	dc.b	2
	dc.b	$48
	dc.b	0
	dc.b	$4A
	dc.b	2
	dc.b	$6A
	dc.b	2
	dc.b	$8C
	dc.b	0
	dc.b	$24
	dc.b	0
	dc.b	$26
	dc.b	0
	dc.b	$48
	dc.b	0
	dc.b	$6A
; -----------------------------------------------------------------------------------------

ActTitleILights:
	move.b	#$F,9(a0)
	move.w	#$A,d0
	jsr	(ActorBookmark_SetDelay).l
	move.w	#$FFCF,d0
	bsr.w	sub_EBF8
	jsr	(ActorBookmark).l
	tst.w	(word_FF1126).l
	ble.s	loc_EB3E
	cmpi.w	#3,(word_FF1126).l
	beq.s	loc_EB3E
	move.w	#$FFCF,d0
	bsr.w	sub_EBF8
	rts
; -----------------------------------------------------------------------------------------

loc_EB3E:
	move.w	#$FFCF,d0
	bsr.w	sub_EBF8
	tst.b	$22(a0)
	beq.s	loc_EB52
	subq.b	#1,$22(a0)
	rts
; -----------------------------------------------------------------------------------------

loc_EB52:
	addq.w	#1,$26(a0)
	move.w	$26(a0),d0
	andi.w	#1,d0
	move.b	#$A,$22(a0)
	lsl.w	#3,d0
	lea	(byte_EB96).l,a1
	adda.w	d0,a1
	move.w	(a1)+,(palette_buffer+$22).l
	move.w	(a1)+,(palette_buffer+$24).l
	move.w	(a1)+,(palette_buffer+$28).l
	move.w	(a1),(palette_buffer+$2A).l
	move.b	#1,d0
	lea	((palette_buffer+$20)).l,a2
	jmp	LoadPalette
; -----------------------------------------------------------------------------------------
byte_EB96
	dc.b	0
	dc.b	6
	dc.b	0
	dc.b	$48
	dc.b	8
	dc.b	0
	dc.b	$A
	dc.b	$40
	dc.b	0
	dc.b	$E
	dc.b	0
	dc.b	$E
	dc.b	$E
	dc.b	$60
	dc.b	$E
	dc.b	$60
; -----------------------------------------------------------------------------------------

ActTitleNElectricity:
	move.w	#$FFE8,d0
	bsr.w	sub_EBF8
	cmpi.w	#2,$28(a0)
	bge.s	loc_EBBC
	move.b	#0,6(a0)

loc_EBBC:
	tst.b	$22(a0)
	beq.s	loc_EBC8
	subq.b	#1,$22(a0)
	rts
; -----------------------------------------------------------------------------------------

loc_EBC8:
	move.w	$28(a0),d0
	addq.b	#1,d0
	andi.b	#7,d0
	move.w	d0,$28(a0)
	add.w	d0,d0
	move.w	word_EBE8(pc,d0.w),d0
	move.b	d0,9(a0)
	lsr.w	#8,d0
	move.b	d0,$22(a0)
	rts
; -----------------------------------------------------------------------------------------
word_EBE8
	dc.w	$1933
	dc.w	$1933
	dc.w	$333
	dc.w	$334
	dc.w	$335
	dc.w	$333
	dc.w	$334
	dc.w	$335

; =============== S U B	R O U T	I N E =====================================================


sub_EBF8:
	add.w	(hscroll_buffer).l,d0
	move.w	d0,$A(a0)
	bmi.s	locret_EC0A
	move.b	#$80,6(a0)

locret_EC0A:
	rts
; End of function sub_EBF8


; =============== S U B	R O U T	I N E =====================================================


Title_LoadFG:
	DISABLE_INTS
	lea	(MapEni_TitleLogo).l,a0
	lea	($CDB0).l,a1
	move.w	#0,d0
	move.w	#$17,d1
	move.w	#7,d2
	jsr	(EniDec).l
	ENABLE_INTS
	rts
; End of function Title_LoadFG


; =============== S U B	R O U T	I N E =====================================================


Title_LoadBG:
	DISABLE_INTS
	lea	(MapEni_TitleRobotnik).l,a0
	lea	($E100).l,a1
	move.w	#$6000,d0
	move.w	#$27,d1
	move.w	#$16,d2
	jsr	(EniDec).l
	movea.l	#(eni_tilemap_buffer+$728),a1
	moveq	#5,d0

loc_EC5E:
	clr.l	(a1)+
	dbf	d0,loc_EC5E
	ENABLE_INTS
	rts
; End of function Title_LoadBG


; =============== S U B	R O U T	I N E =====================================================


sub_EC6A:
	lea	(ActstageCutscene_CharConv).l,a2
	clr.w	d1
	move.w	#$E500,d0

loc_EC76:
	move.b	(a1)+,d1
	bmi.s	locret_EC96
	move.b	(a2,d1.w),d0
	DISABLE_INTS
	jsr	SetVRAMWrite
	move.w	d0,VDP_DATA
	ENABLE_INTS
	addq.w	#2,d5
	bra.s	loc_EC76
; -----------------------------------------------------------------------------------------

locret_EC96:
	rts
; End of function sub_EC6A


; =============== S U B	R O U T	I N E =====================================================


sub_EC98:
	move.w	#$E500,d0

loc_EC9C:
	move.b	(a1)+,d1
	bmi.s	locret_ECB8
	DISABLE_INTS
	jsr	SetVRAMWrite
	move.w	d0,VDP_DATA
	ENABLE_INTS
	addq.w	#2,d5
	bra.s	loc_EC9C
; -----------------------------------------------------------------------------------------

locret_ECB8:
	rts
; End of function sub_EC98


; =============== S U B	R O U T	I N E =====================================================


CheckIfJapan:
	move.b	CONSOLE_VER,d0
	andi.b	#$C0,d0
	beq.s	locret_ECDA
	move.w	(is_japan).l,d0
	not.w	d0
	move.w	d0,(is_japan).l
	jmp	(SaveData).l
; -----------------------------------------------------------------------------------------

locret_ECDA:
	rts
; End of function CheckIfJapan

; -----------------------------------------------------------------------------------------
	rts
; -----------------------------------------------------------------------------------------
	dc.b	$40
	dc.b	$40
	dc.b	4
	dc.b	$10
	dc.b	$10
	dc.b	4
	dc.b	$20
	dc.b	$20
	dc.b	$FF
	dc.b	0
; -----------------------------------------------------------------------------------------
; START	OF FUNCTION CHUNK FOR ActTitleHandler

loc_ECE8:
	move.b	#1,swap_fields
	move.b	#1,main_player_field
	move.b	p2_ctrl+ctlPress,d0
	btst	#7,d0
	bne.w	loc_ED16
	eori.b	#1,swap_fields
	eori.b	#1,main_player_field

loc_ED16:
	move.b	#SFX_MENU_SELECT,d0
	jsr	PlaySound_ChkSamp
	clr.b	(bytecode_disabled).l
	clr.b	bytecode_flag
	jmp	(ActorDeleteSelf).l
; END OF FUNCTION CHUNK	FOR ActTitleHandler

; =============== S U B	R O U T	I N E =====================================================


EnableLineHScroll:
	move.w	#$8B00,d0
	move.b	vdp_reg_b,d0
	ori.b	#3,d0
	move.b	d0,vdp_reg_b
	rts
; End of function EnableLineHScroll


; =============== S U B	R O U T	I N E =====================================================


DisableLineHScroll:
	move.w	#$8B00,d0
	move.b	vdp_reg_b,d0
	andi.b	#$FC,d0
	move.b	d0,vdp_reg_b
	jmp	(ClearScroll).l
; End of function DisableLineHScroll


; =============== S U B	R O U T	I N E =====================================================


sub_ED62:
	move.w	#0,(word_FF1990).l
	lea	(sub_EE10).l,a1
	jsr	FindActorSlot
	bcs.w	locret_ED9A
	move.b	#$2B,8(a1)
	move.b	#$80,6(a1)
	move.w	#$90,$A(a1)
	move.w	#$E0,$E(a1)
	move.l	#unk_EF22,$32(a1)

locret_ED9A:
	rts
; End of function sub_ED62


; =============== S U B	R O U T	I N E =====================================================


sub_ED9C:
	move.w	#0,(word_FF1990).l
	lea	(sub_EE10).l,a1
	jsr	FindActorSlot
	bcs.w	locret_EDD4
	move.b	#$1B,8(a1)
	move.b	#$80,6(a1)
	move.w	#$E8,$A(a1)
	move.w	#$90,$E(a1)
	move.l	#unk_EF8E,$32(a1)

locret_EDD4:
	rts
; End of function sub_ED9C


; =============== S U B	R O U T	I N E =====================================================


sub_EDD6:
	move.w	#0,(word_FF1990).l
	lea	(sub_EE10).l,a1
	jsr	FindActorSlot
	bcs.w	locret_EE0E
	move.b	#$2B,8(a1)
	move.b	#$80,6(a1)
	move.w	#$A0,$A(a1)
	move.w	#$E0,$E(a1)
	move.l	#unk_EFC6,$32(a1)

locret_EE0E:
	rts
; End of function sub_EDD6


; =============== S U B	R O U T	I N E =====================================================


sub_EE10:
	jsr	(ActorBookmark).l
	move.b	(word_FF1990+1).l,d0
	bpl.w	loc_EE3A
	lea	(off_A15E).l,a1
	andi.b	#$7F,d0
	lsl.w	#2,d0
	movea.l	(a1,d0.w),a2
	jsr	(a2)
	move.b	#0,(word_FF1990+1).l

loc_EE3A:
	tst.b	$22(a0)
	beq.w	loc_EE48
	subq.b	#1,$22(a0)
	rts
; -----------------------------------------------------------------------------------------

loc_EE48:
	movea.l	$32(a0),a2
	cmpi.b	#$FE,(a2)
	bne.w	loc_EE56
	rts
; -----------------------------------------------------------------------------------------

loc_EE56:
	cmpi.b	#$FF,(a2)
	bne.w	loc_EE62
	movea.l	2(a2),a2

loc_EE62:
	move.b	(a2)+,$22(a0)
	move.b	(a2)+,d0
	move.b	d0,9(a0)
	move.l	a2,$32(a0)
	lsl.w	#2,d0
	move.l	off_EEC2(pc,d0.w),d0
	move.l	a0,-(sp)
	lea	dma_queue,a0
	adda.w	dma_slot,a0
	move.w	#$8F02,(a0)+
	move.l	#$94059380,(a0)+
	lsr.l	#1,d0
	move.l	d0,d1
	lsr.w	#8,d0
	swap	d0
	move.w	d1,d0
	andi.w	#$FF,d0
	addi.l	#-$69FF6B00,d0
	swap	d1
	andi.w	#$7F,d1
	addi.w	#-$6900,d1
	move.l	d0,(a0)+
	move.w	d1,(a0)+
	move.l	#$60000080,(a0)
	addi.w	#$10,dma_slot
	movea.l	(sp)+,a0
	rts
; End of function sub_EE10

; -----------------------------------------------------------------------------------------
off_EEC2
	dc.l	byte_30000
	dc.l	byte_30880
	dc.l	byte_31140
	dc.l	byte_31C00
	dc.l	byte_32700
	dc.l	byte_331C0
	dc.l	byte_33C00
	dc.l	byte_34600
	dc.l	byte_34FC0
	dc.l	byte_35980
	dc.l	byte_363A0
	dc.l	byte_36E00
	dc.l	byte_37720
	dc.l	byte_38080
	dc.l	byte_38940
	dc.l	byte_39200
	dc.l	byte_39AC0
	dc.l	byte_3A3E0
	dc.l	byte_3A880
	dc.l	byte_3AC40
	dc.l	byte_3B080
	dc.l	byte_97DA2
	dc.l	byte_98702
	dc.l	byte_99042
unk_EF22
	dc.b	$32
	dc.b	0
	dc.b	6
	dc.b	1
	dc.b	6
	dc.b	2
	dc.b	6
	dc.b	3
	dc.b	$C
	dc.b	4
	dc.b	$11
	dc.b	5
	dc.b	8
	dc.b	6
	dc.b	$11
	dc.b	7
	dc.b	8
	dc.b	6
	dc.b	$10
	dc.b	8
	dc.b	7
	dc.b	9
	dc.b	8
	dc.b	$A
	dc.b	7
	dc.b	$B
	dc.b	$14
	dc.b	$C
	dc.b	$F
	dc.b	0
	dc.b	6
	dc.b	1
	dc.b	6
	dc.b	2
	dc.b	6
	dc.b	3
	dc.b	$C
	dc.b	4
	dc.b	$11
	dc.b	5
	dc.b	8
	dc.b	6
	dc.b	$11
	dc.b	7
	dc.b	8
	dc.b	6
	dc.b	$11
	dc.b	8
	dc.b	8
	dc.b	0
	dc.b	$15
	dc.b	$D
	dc.b	7
	dc.b	$E
	dc.b	7
	dc.b	$F
	dc.b	7
	dc.b	$10
	dc.b	$15
	dc.b	$D
	dc.b	7
	dc.b	$E
	dc.b	7
	dc.b	$F
	dc.b	7
	dc.b	$10
	dc.b	$15
	dc.b	$D
	dc.b	$10
	dc.b	0
	dc.b	6
	dc.b	1
	dc.b	6
	dc.b	2
	dc.b	6
	dc.b	3
	dc.b	8
	dc.b	4
	dc.b	8
	dc.b	5
	dc.b	$A
	dc.b	6
	dc.b	8
	dc.b	4
	dc.b	8
	dc.b	5
	dc.b	$A
	dc.b	6
	dc.b	8
	dc.b	4
	dc.b	$C
	dc.b	5
	dc.b	5
	dc.b	6
	dc.b	8
	dc.b	4
	dc.b	$C
	dc.b	5
	dc.b	8
	dc.b	6
	dc.b	$A
	dc.b	0
	dc.b	$FF
	dc.b	0
	dc.l	unk_EF22
unk_EF8E
	dc.b	4
	dc.b	0
	dc.b	4
	dc.b	1
	dc.b	4
	dc.b	2
	dc.b	4
	dc.b	3
	dc.b	4
	dc.b	4
	dc.b	4
	dc.b	5
	dc.b	4
	dc.b	6
	dc.b	4
	dc.b	7
	dc.b	4
	dc.b	6
	dc.b	4
	dc.b	8
	dc.b	4
	dc.b	9
	dc.b	4
	dc.b	$A
	dc.b	4
	dc.b	$B
	dc.b	4
	dc.b	$C
	dc.b	4
	dc.b	0
	dc.b	4
	dc.b	$D
	dc.b	4
	dc.b	$E
	dc.b	4
	dc.b	$F
	dc.b	4
	dc.b	$10
	dc.b	4
	dc.b	$D
	dc.b	4
	dc.b	$E
	dc.b	4
	dc.b	$F
	dc.b	4
	dc.b	$10
	dc.b	4
	dc.b	$D
	dc.b	4
	dc.b	0
	dc.b	$FF
	dc.b	0
	dc.l	unk_EF8E
unk_EFC6
	dc.b	$32
	dc.b	0
	dc.b	6
	dc.b	1
	dc.b	6
	dc.b	2
	dc.b	6
	dc.b	3
	dc.b	$C
	dc.b	4
	dc.b	$11
	dc.b	5
	dc.b	8
	dc.b	6
	dc.b	$11
	dc.b	7
	dc.b	8
	dc.b	6
	dc.b	$10
	dc.b	8
	dc.b	7
	dc.b	9
	dc.b	8
	dc.b	$A
	dc.b	7
	dc.b	$B
	dc.b	$14
	dc.b	$C
	dc.b	8
	dc.b	$A
	dc.b	9
	dc.b	$B
	dc.b	$14
	dc.b	$C
	dc.b	9
	dc.b	$A
	dc.b	$A
	dc.b	$B
	dc.b	$1E
	dc.b	$C
	dc.b	$A
	dc.b	0
	dc.b	$FE
	dc.b	0
unk_EFF2
	dc.b	$E
	dc.b	$E
	dc.b	$12
	dc.b	$F
	dc.b	$16
	dc.b	$10
	dc.b	4
	dc.b	$11
	dc.b	4
	dc.b	$12
	dc.b	$FE
	dc.b	0

; =============== S U B	R O U T	I N E =====================================================


sub_EFFE:
	lea	(ArtNem_IntroBadniks).l,a0
	lea	(misc_buffer_1).l,a4
	DISABLE_INTS
	jsr	NemDecRAM
	ENABLE_INTS
	move.b	#$10,opponent
	move.w	#$DA,(word_FF1994).l
	lea	(ActstageCutscene).l,a1
	jsr	FindActorSlot
	moveq	#0,d0
	move.w	d0,(vscroll_buffer).l
	move.w	d0,(hscroll_buffer).l
	move.l	d0,(dword_FF112C).l
	move.l	d0,(dword_FF1130).l
	move.w	#0,(use_lair_background).l
	jsr	(sub_F13A).l
	bsr.w	sub_ED62
	lea	(sub_F074).l,a1
	jmp	FindActorSlot
; End of function sub_EFFE

; -----------------------------------------------------------------------------------------

loc_F06C:
	bra.w	loc_F07E
; -----------------------------------------------------------------------------------------
	bra.w	loc_F086

; =============== S U B	R O U T	I N E =====================================================


sub_F074:
	move.w	(dword_FF112C).l,d0
	jmp	loc_F06C(pc,d0.w)
; End of function sub_F074

; -----------------------------------------------------------------------------------------

loc_F07E:
	addq.w	#4,(dword_FF112C).l
	rts
; -----------------------------------------------------------------------------------------

loc_F086:
	addq.w	#4,(dword_FF1130).l
	moveq	#0,d0
	move.w	(dword_FF1130).l,d0
	move.b	p1_ctrl+ctlPress,d0
	or.b	p2_ctrl+ctlPress,d0
	andi.b	#$F0,d0
	beq.s	loc_F0B8
	clr.b	(bytecode_disabled).l
	clr.b	bytecode_flag
	jmp	(ActorDeleteSelf).l
; -----------------------------------------------------------------------------------------

loc_F0B8:
	tst.b	opponent
	bne.w	locret_F0F2
	clr.b	(bytecode_disabled).l
	move.b	(byte_FF1970).l,d0
	addq.b	#1,d0
	move.b	d0,bytecode_flag
	andi.b	#1,d0
	move.b	d0,(byte_FF1970).l
	cmpi.b	#2,bytecode_flag
	beq.w	loc_F0F4
	jmp	(ActorDeleteSelf).l
; -----------------------------------------------------------------------------------------

locret_F0F2:
	rts
; -----------------------------------------------------------------------------------------

loc_F0F4:
	moveq	#0,d0
	move.b	(byte_FF1971).l,d0
	addq.b	#1,d0
	andi.b	#3,d0
	move.b	d0,(byte_FF1971).l
	addq.b	#3,d0
	move.b	d0,stage
	move.b	d0,stage
	lea	(byte_F12A).l,a1
	move.b	(a1,d0.w),opponent
	jmp	(ActorDeleteSelf).l
; -----------------------------------------------------------------------------------------
byte_F12A
	dc.b	0
	dc.b	4
	dc.b	$D
	dc.b	3
	dc.b	1
	dc.b	$E
	dc.b	7
	dc.b	6
	dc.b	$F
	dc.b	2
	dc.b	5
	dc.b	8
	dc.b	9
	dc.b	$A
	dc.b	$B
	dc.b	$C

; =============== S U B	R O U T	I N E =====================================================


sub_F13A:
	movem.l	d0-a6,-(sp)
	lea	(word_F456).l,a2
	lea	(off_F41E).l,a3
	moveq	#$D,d6

loc_F14C:
	movea.l	(a3)+,a1
	jsr	FindActorSlot
	bcs.s	loc_F18A
	move.b	#$80,6(a1)
	move.b	#$40,8(a1)
	move.w	(a2)+,$A(a1)
	move.w	(a2)+,d2
	tst.b	(use_lair_background).l
	beq.s	loc_F174
	addi.w	#-$E0,d2

loc_F174:
	move.w	d2,$E(a1)
	move.b	(a2)+,9(a1)
	move.b	(a2)+,$22(a1)
	move.l	(a2)+,$32(a1)
	move.w	#0,$26(a1)

loc_F18A:
	dbf	d6,loc_F14C
	lea	(sub_F1AE).l,a1
	jsr	FindActorSlotQuick
	bcs.s	loc_F1A8
	move.w	#0,$26(a1)
	move.w	#0,$28(a1)

loc_F1A8:
	movem.l	(sp)+,d0-a6
	rts
; End of function sub_F13A


; =============== S U B	R O U T	I N E =====================================================


sub_F1AE:
	addq.w	#1,$26(a0)
	move.w	$26(a0),d0
	andi.w	#1,d0
	bne.s	locret_F214
	addq.w	#1,$28(a0)
	DISABLE_INTS
	movem.l	d0-a6,-(sp)
	lea	VDP_DATA,a4
	move.w	$28(a0),d0
	andi.w	#$F,d0
	asl.w	#3,d0
	move.w	#$5E74,d5
	jsr	SetVRAMWrite
	move.w	word_F216(pc,d0.w),(a4)
	move.w	word_F218(pc,d0.w),(a4)
	move.w	word_F216(pc,d0.w),(a4)
	move.w	word_F218(pc,d0.w),(a4)
	move.w	#$5E94,d5
	jsr	SetVRAMWrite
	move.w	word_F21A(pc,d0.w),(a4)
	move.w	word_F21C(pc,d0.w),(a4)
	move.w	word_F21A(pc,d0.w),(a4)
	move.w	word_F21C(pc,d0.w),(a4)
	movem.l	(sp)+,d0-a6
	ENABLE_INTS

locret_F214:
	rts
; End of function sub_F1AE

; -----------------------------------------------------------------------------------------
word_F216
	dc.w	$BB77
word_F218
	dc.w	$7777
word_F21A
	dc.w	$7777
word_F21C
	dc.w	$7777
	dc.w	$7BB7
	dc.w	$7777
	dc.w	$7777
	dc.w	$7777
	dc.w	$77BB
	dc.w	$7777
	dc.w	$7777
	dc.w	$7777
	dc.w	$777B
	dc.w	$B777
	dc.w	$7777
	dc.w	$7777
	dc.w	$7777
	dc.w	$BB77
	dc.w	$7777
	dc.w	$7777
	dc.w	$7777
	dc.w	$7BB7
	dc.w	$7777
	dc.w	$7777
	dc.w	$7777
	dc.w	$77BB
	dc.w	$7777
	dc.w	$7777
	dc.w	$7777
	dc.w	$777B
	dc.w	$B777
	dc.w	$7777
	dc.w	$7777
	dc.w	$7777
	dc.w	$BB77
	dc.w	$7777
	dc.w	$7777
	dc.w	$7777
	dc.w	$7BB7
	dc.w	$7777
	dc.w	$7777
	dc.w	$7777
	dc.w	$77BB
	dc.w	$7777
	dc.w	$7777
	dc.w	$7777
	dc.w	$777B
	dc.w	$B777
	dc.w	$7777
	dc.w	$7777
	dc.w	$7777
	dc.w	$BB77
	dc.w	$7777
	dc.w	$7777
	dc.w	$7777
	dc.w	$7BB7
	dc.w	$7777
	dc.w	$7777
	dc.w	$7777
	dc.w	$77BB
	dc.w	$B777
	dc.w	$7777
	dc.w	$7777
	dc.w	$777B
; -----------------------------------------------------------------------------------------

loc_F296:
	jmp	(ActorAnimate).l
; -----------------------------------------------------------------------------------------
	rts
; -----------------------------------------------------------------------------------------

loc_F29E:
	subq.w	#1,$26(a0)
	bpl.s	locret_F2FE
	jsr	Random
	andi.w	#$F,d0
	addi.w	#$F,d0
	move.w	d0,$26(a0)
	lea	(loc_F300).l,a1
	jsr	FindActorSlot
	bcs.s	locret_F2FE
	move.w	$A(a0),$A(a1)
	move.w	$E(a0),$E(a1)
	move.w	#$78,$26(a1)
	move.b	#$B3,6(a1)
	move.b	#$40,8(a1)
	move.b	#$2E,9(a1)
	move.b	#2,$22(a1)
	move.l	#unk_F4EA,$32(a1)
	move.l	#$FFFF8000,$16(a1)

locret_F2FE:
	rts
; -----------------------------------------------------------------------------------------

loc_F300:
	move.b	#$BF,6(a0)
	jsr	(ActorMove).l
	jsr	(ActorAnimate).l
	subq.w	#1,$26(a0)
	bpl.s	locret_F2FE
	jmp	(ActorDeleteSelf).l
; -----------------------------------------------------------------------------------------

loc_F31E:
	addq.w	#1,$26(a0)
	move.w	$26(a0),d0
	andi.w	#$7F,d0
	bne.s	locret_F38C
	lea	(loc_F38E).l,a1
	jsr	FindActorSlot
	bcs.s	locret_F38C
	move.w	$A(a0),$A(a1)
	move.w	$E(a0),$E(a1)
	move.w	#0,$12(a1)
	move.w	#$8000,$14(a1)
	move.w	#$96,$26(a1)
	move.b	#$40,8(a1)
	move.b	#8,$22(a1)
	move.b	#$23,9(a1)
	move.l	#unk_F56E,$32(a1)
	jsr	Random
	andi.b	#1,d0
	beq.s	locret_F38C
	move.b	#$25,9(a1)
	move.l	#unk_F57C,$32(a1)

locret_F38C:
	rts
; -----------------------------------------------------------------------------------------

loc_F38E:
	move.b	#$83,6(a0)
	jsr	(ActorMove).l
	jsr	(ActorAnimate).l
	subq.w	#1,$26(a0)
	bpl.s	locret_F38C
	move.w	#$10E,$26(a0)
	jsr	(ActorBookmark).l
	jsr	(ActorMove).l
	jsr	(ActorAnimate).l
	subq.w	#1,$26(a0)
	bpl.s	locret_F38C
	move.l	#unk_F58A,$32(a0)
	move.w	#$F0,$26(a0)
	jsr	(ActorBookmark).l
	jsr	(ActorMove).l
	jsr	(ActorAnimate).l
	subq.w	#1,$26(a0)
	bpl.s	locret_F38C
	jmp	(ActorDeleteSelf).l
; -----------------------------------------------------------------------------------------
	move.l	#unk_F58A,$32(a0)
	move.w	#$96,$26(a0)
	jsr	(ActorBookmark).l
	jsr	(ActorMove).l
	jsr	(ActorAnimate).l
	subq.w	#1,$26(a0)
	bpl.w	locret_F38C
	jmp	(ActorDeleteSelf).l
; -----------------------------------------------------------------------------------------
off_F41E
	dc.l	loc_F29E
	dc.l	loc_F296
	dc.l	loc_F296
	dc.l	loc_F296
	dc.l	loc_F296
	dc.l	loc_F296
	dc.l	loc_F296
	dc.l	loc_F296
	dc.l	loc_F296
	dc.l	loc_F296
	dc.l	loc_F296
	dc.l	loc_F296
	dc.l	loc_F296
	dc.l	loc_F31E
word_F456
	dc.w	$164
	dc.w	$A8
	dc.b	0
	dc.b	1
	dc.l	unk_F4EA
	dc.w	$110
	dc.w	$130
	dc.b	$36
	dc.b	$10
	dc.l	unk_F55C
	dc.w	$17E
	dc.w	$A0
	dc.b	$19
	dc.b	$30
	dc.l	unk_F53C
	dc.w	$EF
	dc.w	$B3
	dc.b	1
	dc.b	$20
	dc.l	unk_F500
	dc.w	$AC
	dc.w	$BD
	dc.b	5
	dc.b	$10
	dc.l	unk_F512
	dc.w	$BC
	dc.w	$BA
	dc.b	6
	dc.b	$28
	dc.l	unk_F512
	dc.w	$CE
	dc.w	$BD
	dc.b	7
	dc.b	$42
	dc.l	unk_F512
	dc.w	$13E
	dc.w	$CD
	dc.b	6
	dc.b	8
	dc.l	unk_F512
	dc.w	$1A6
	dc.w	$CD
	dc.b	5
	dc.b	$15
	dc.l	unk_F512
	dc.w	$F2
	dc.w	$C7
	dc.b	$16
	dc.b	$30
	dc.l	unk_F51E
	dc.w	$152
	dc.w	$A0
	dc.b	$10
	dc.b	$20
	dc.l	unk_F52C
	dc.w	$1BA
	dc.w	$A0
	dc.b	$12
	dc.b	$10
	dc.l	unk_F52C
	dc.w	$130
	dc.w	$A8
	dc.b	0
	dc.b	$30
	dc.l	unk_F548
	dc.w	$80
	dc.w	$FC
	dc.b	0
	dc.b	1
	dc.l	unk_F4E2
unk_F4E2
	dc.b	1
	dc.b	0
	dc.b	$FF
	dc.b	0
	dc.l	unk_F4E2
unk_F4EA
	dc.b	2
	dc.b	$2E
	dc.b	3
	dc.b	$2F
	dc.b	2
	dc.b	$30
	dc.b	3
	dc.b	$31
	dc.b	2
	dc.b	$32
	dc.b	3
	dc.b	$33
	dc.b	2
	dc.b	$34
	dc.b	3
	dc.b	$35
	dc.b	$FF
	dc.b	0
	dc.l	unk_F4EA
unk_F500
	dc.b	3
	dc.b	4
	dc.b	4
	dc.b	1
	dc.b	5
	dc.b	2
	dc.b	3
	dc.b	3
	dc.b	4
	dc.b	2
	dc.b	5
	dc.b	1
	dc.b	$FF
	dc.b	0
	dc.l	unk_F500
unk_F512
	dc.b	3
	dc.b	5
	dc.b	4
	dc.b	6
	dc.b	5
	dc.b	7
	dc.b	$FF
	dc.b	0
	dc.l	unk_F512
unk_F51E
	dc.b	3
	dc.b	$16
	dc.b	4
	dc.b	$17
	dc.b	5
	dc.b	$18
	dc.b	7
	dc.b	$17
	dc.b	$FF
	dc.b	0
	dc.l	unk_F51E
unk_F52C
	dc.b	3
	dc.b	$10
	dc.b	4
	dc.b	$11
	dc.b	5
	dc.b	$12
	dc.b	4
	dc.b	$13
	dc.b	5
	dc.b	$14
	dc.b	$FF
	dc.b	0
	dc.l	unk_F52C
unk_F53C
	dc.b	3
	dc.b	$19
	dc.b	4
	dc.b	$1A
	dc.b	5
	dc.b	$1B
	dc.b	$FF
	dc.b	0
	dc.l	unk_F53C
unk_F548
	dc.b	3
	dc.b	$1C
	dc.b	3
	dc.b	$1D
	dc.b	3
	dc.b	$1E
	dc.b	3
	dc.b	$1F
	dc.b	3
	dc.b	$20
	dc.b	3
	dc.b	$21
	dc.b	$3C
	dc.b	0
	dc.b	$FF
	dc.b	0
	dc.l	unk_F548
unk_F55C
	dc.b	$1E
	dc.b	$36
	dc.b	$1C
	dc.b	$37
	dc.b	$32
	dc.b	$38
	dc.b	$A
	dc.b	$37
	dc.b	$14
	dc.b	$36
	dc.b	$14
	dc.b	$37
	dc.b	$FF
	dc.b	0
	dc.l	unk_F55C
unk_F56E
	dc.b	7
	dc.b	$22
	dc.b	8
	dc.b	$23
	dc.b	7
	dc.b	$24
	dc.b	8
	dc.b	$23
	dc.b	$FF
	dc.b	0
	dc.l	unk_F56E
unk_F57C
	dc.b	6
	dc.b	$25
	dc.b	7
	dc.b	$26
	dc.b	5
	dc.b	$27
	dc.b	7
	dc.b	$26
	dc.b	$FF
	dc.b	0
	dc.l	unk_F57C
unk_F58A
	dc.b	7
	dc.b	$28
	dc.b	8
	dc.b	$29
	dc.b	7
	dc.b	$2A
	dc.b	8
	dc.b	$2B
	dc.b	7
	dc.b	$2C
	dc.b	8
	dc.b	$2D
	dc.b	$FF
	dc.b	0
	dc.l	unk_F58A
; -----------------------------------------------------------------------------------------
	rts
; -----------------------------------------------------------------------------------------
	rts
; -----------------------------------------------------------------------------------------

LoadStageCutsceneArt:
	tst.b	(use_lair_background).l
	beq.s	loc_F5CE
	lea	(ArtNem_Intro).l,a0
	move.w	#$4000,d0
	DISABLE_INTS
	jsr	NemDec
	ENABLE_INTS
	lea	(ArtNem_IntroBadniks).l,a0
	move.w	#$1200,d0
	bra.w	NemDecSafe
; -----------------------------------------------------------------------------------------

loc_F5CE:
	lea	(ArtNem_LvlIntroBG).l,a0
	move.w	#$2000,d0
	bra.w	NemDecSafe

; =============== S U B	R O U T	I N E =====================================================


LoadEndingBGArt:
	lea	(ArtNem_EndingBG).l,a0
	move.w	#$4000,d0

NemDecSafe:
	DISABLE_INTS
	jsr	NemDec
	ENABLE_INTS
	rts
; End of function LoadEndingBGArt


; =============== S U B	R O U T	I N E =====================================================


sub_F5F6:



	tst.b	(use_lair_background).l
	beq.s	loc_F602

loc_F5FE:
	bra.w	loc_F61E
; -----------------------------------------------------------------------------------------

loc_F602:
	lea	($D200).l,a1
	lea	(byte_6199E).l,a0
	move.w	#$8100,d0
	move.w	#$27,d1
	move.w	#$1B,d2
	bra.w	EniDecSafe
; -----------------------------------------------------------------------------------------

loc_F61E:
	lea	(MapEni_LairMachine).l,a0
	lea	($D200).l,a1
	move.w	#$200,d0
	move.w	#$27,d1
	move.w	#$12,d2
	lea	(MapPrio_LairMachine).l,a3
	bra.w	EniDec_PrioMapSafe
; End of function sub_F5F6


; =============== S U B	R O U T	I N E =====================================================


sub_F640:
	tst.b	(use_lair_background).l
	bne.s	loc_F664
	lea	($F600).l,a1
	lea	(byte_61A8A).l,a0
	move.w	#$2100,d0
	move.w	#$1F,d1
	move.w	#$A,d2
	bra.w	EniDecSafe
; -----------------------------------------------------------------------------------------

loc_F664:
	lea	(MapEni_LairWall).l,a0
	lea	($F600).l,a1
	move.w	#$6200,d0
	move.w	#$27,d1
	move.w	#$12,d2
	bra.w	EniDecSafe
; End of function sub_F640


; =============== S U B	R O U T	I N E =====================================================


sub_F680:
	tst.b	(use_lair_background).l
	bne.s	loc_F6A4
	lea	($F640).l,a1
	lea	(byte_61A8A).l,a0
	move.w	#$2100,d0
	move.w	#$1F,d1
	move.w	#$A,d2
	bra.w	EniDecSafe
; -----------------------------------------------------------------------------------------

loc_F6A4:
	lea	(MapEni_LairFloor).l,a0
	lea	($DB80).l,a1
	move.w	#$200,d0
	move.w	#$27,d1
	move.w	#8,d2
	bra.w	EniDecSafe
; End of function sub_F680


; =============== S U B	R O U T	I N E =====================================================


sub_F6C0:
	tst.b	(use_lair_background).l
	bne.s	locret_F6E4
	lea	($FB80).l,a1
	lea	(byte_61B22).l,a0
	move.w	#$2100,d0
	move.w	#$27,d1
	move.w	#8,d2
	bra.w	EniDecSafe2
; -----------------------------------------------------------------------------------------

locret_F6E4:
	rts
; End of function sub_F6C0


; =============== S U B	R O U T	I N E =====================================================


LoadMainMenuMap:
	lea	($C306).l,a1
	lea	(MapEni_MainMenu).l,a0
	move.w	#$E190,d0
	move.w	#$21,d1
	move.w	#$13,d2
	bra.w	EniDecSafe
; End of function LoadMainMenuMap


; =============== S U B	R O U T	I N E =====================================================


LoadScenarioMenuMap:
	lea	($C65E).l,a1
	lea	(MapEni_ScenarioMenu).l,a0
	move.w	#$E190,d0
	move.w	#$19,d1
	move.w	#$B,d2
	bra.w	EniDecSafe
; End of function LoadScenarioMenuMap


; =============== S U B	R O U T	I N E =====================================================


sub_F71E:
	lea	($C000).l,a1
	lea	(byte_69FBE).l,a0
	move.w	#$2A0,d0
	move.w	#$27,d1
	move.w	#$1B,d2
	lea	(byte_6A144).l,a3
	bra.w	EniDec_PrioMapSafe
; End of function sub_F71E


; =============== S U B	R O U T	I N E =====================================================


sub_F740:
	lea	($E000).l,a1
	lea	(byte_6A0AA).l,a0
	move.w	#$22A0,d0
	move.w	#$27,d1
	move.w	#$E,d2
	bra.w	EniDecSafe
; End of function sub_F740


; =============== S U B	R O U T	I N E =====================================================


sub_F75C:
	lea	($E000).l,a1
	lea	(byte_6EB68).l,a0
	move.w	#$6280,d0
	move.w	#$27,d1
	move.w	#$1B,d2
; End of function sub_F75C


; =============== S U B	R O U T	I N E =====================================================


EniDecSafe:
	DISABLE_INTS
	jsr	(EniDec).l
	ENABLE_INTS
	rts
; End of function EniDecSafe

; -----------------------------------------------------------------------------------------
; START	OF FUNCTION CHUNK FOR sub_F5F6

EniDec_PrioMapSafe:
	DISABLE_INTS
	jsr	(EniDecPrioMap).l
	ENABLE_INTS
	rts
; END OF FUNCTION CHUNK	FOR sub_F5F6

; =============== S U B	R O U T	I N E =====================================================


sub_F794:
	movem.l	a0,-(sp)
	lea	($F600).l,a1
	lea	(byte_6F158).l,a0
	move.w	#$4000,d0
	move.w	#$27,d1
	move.w	#9,d2
	bsr.s	EniDecSafe
	movem.l	(sp)+,a0
	rts
; End of function sub_F794


; =============== S U B	R O U T	I N E =====================================================


sub_F7B8:
	movem.l	a0,-(sp)
	lea	(ArtNem_CreditsSky).l,a0
	moveq	#0,d0
	jsr	NemDec
	movem.l	(sp)+,a0
	rts
; End of function sub_F7B8


; =============== S U B	R O U T	I N E =====================================================


LoadMainMenuMountains:
	lea	($F300).l,a1
	lea	(MapEni_MainMenuMountains).l,a0
	move.w	#$2190,d0
	move.w	#$27,d1
	move.w	#9,d2
	bra.w	EniDecSafe2
; -----------------------------------------------------------------------------------------

LoadMainMenuClouds1:
	lea	($E000).l,a1
	bra.w	LoadMainMenuClouds
; -----------------------------------------------------------------------------------------

LoadMainMenuClouds2:
	lea	($E040).l,a1
	bra.w	LoadMainMenuClouds
; -----------------------------------------------------------------------------------------

LoadMainMenuClouds3:
	lea	($E080).l,a1
	bra.w	LoadMainMenuClouds
; -----------------------------------------------------------------------------------------

LoadMainMenuClouds4:
	lea	($E0C0).l,a1

LoadMainMenuClouds:
	lea	(MapEni_MainMenuClouds).l,a0
	move.w	#$2190,d0
	move.w	#$1F,d1
	move.w	#$12,d2

EniDecSafe2:
	DISABLE_INTS
	jsr	(EniDec).l
	ENABLE_INTS
	rts
; End of function LoadMainMenuMountains


; =============== S U B	R O U T	I N E =====================================================


sub_F832:
	lea	(byte_6622E).l,a0
	lea	($D200).l,a1
	bra.s	loc_F856
; -----------------------------------------------------------------------------------------

loc_F840:
	lea	(byte_6622E).l,a0
	bra.w	loc_F850
; -----------------------------------------------------------------------------------------

LoadLairMachineMap:
	lea	(MapEni_LairMachine).l,a0

loc_F850:
	lea	($C000).l,a1

loc_F856:
	DISABLE_INTS
	move.w	#$200,d0
	move.w	#$27,d1
	move.w	#$12,d2
	lea	(MapPrio_LairMachine).l,a3
	jsr	(EniDecPrioMap).l
	ENABLE_INTS
	rts
; End of function sub_F832


; =============== S U B	R O U T	I N E =====================================================


sub_F878:
	lea	(byte_66348).l,a0
	lea	($F600).l,a1
	bra.s	loc_F89A
; -----------------------------------------------------------------------------------------

loc_F886:
	lea	(byte_66348).l,a0
	bra.s	loc_F894
; -----------------------------------------------------------------------------------------

LoadLairWallMap:
	lea	(MapEni_LairWall).l,a0

loc_F894:
	lea	($E000).l,a1

loc_F89A:
	DISABLE_INTS
	move.w	#$6200,d0
	move.w	#$27,d1
	move.w	#$12,d2
	jsr	(EniDec).l
	ENABLE_INTS
	rts
; End of function sub_F878


; =============== S U B	R O U T	I N E =====================================================


sub_F8B6:
	lea	(byte_6646C).l,a0
	lea	($DB80).l,a1
	bra.s	loc_F8D8
; -----------------------------------------------------------------------------------------

loc_F8C4:
	lea	(byte_6646C).l,a0
	bra.s	loc_F8D2
; -----------------------------------------------------------------------------------------

LoadLairFloorMap:
	lea	(MapEni_LairFloor).l,a0

loc_F8D2:
	lea	($E980).l,a1

loc_F8D8:
	DISABLE_INTS
	move.w	#$200,d0
	move.w	#$27,d1
	move.w	#8,d2
	jsr	(EniDec).l
	ENABLE_INTS
	rts
; End of function sub_F8B6


; =============== S U B	R O U T	I N E =====================================================


sub_F8F4:
	moveq	#0,d0
	jmp	QueuePlaneCmdList
; End of function sub_F8F4

; -----------------------------------------------------------------------------------------

loc_F8FC:
	tst.b	(use_lair_background).l
	bne.w	loc_F952
	lea	(loc_F942).l,a1
	jsr	FindActorSlot
	bcs.s	locret_F940
	move.b	#$40,8(a1)
	move.b	#$39,9(a1)
	move.l	#unk_F94A,$32(a1)
	move.b	#$80,6(a1)
	move.b	#$20,$22(a1)
	move.w	#$FFE0,$E(a1)
	move.w	#$F1,$A(a1)

locret_F940:
	rts
; -----------------------------------------------------------------------------------------

loc_F942:
	jmp	(ActorAnimate).l
; -----------------------------------------------------------------------------------------
	rts
; -----------------------------------------------------------------------------------------
unk_F94A
	dc.b	3
	dc.b	$39
	dc.b	$FF
	dc.b	0
	dc.l	unk_F94A
; -----------------------------------------------------------------------------------------

loc_F952:
	jmp	(sub_F13A).l
; -----------------------------------------------------------------------------------------

loc_F958:
	lea	(loc_F994).l,a1
	jsr	FindActorSlot
	bcs.s	locret_F992
	move.b	#$40,8(a1)
	move.b	#$43,9(a1)
	move.l	#unk_F99C,$32(a1)
	move.b	#$80,6(a1)
	move.b	#$20,$22(a1)
	move.w	#$FFE0,$E(a1)
	move.w	#$F2,$A(a1)

locret_F992:
	rts
; -----------------------------------------------------------------------------------------

loc_F994:
	jmp	(ActorAnimate).l
; -----------------------------------------------------------------------------------------
	rts
; -----------------------------------------------------------------------------------------
unk_F99C
	dc.b	3
	dc.b	$43
	dc.b	$FF
	dc.b	0
	dc.l	unk_F99C
; -----------------------------------------------------------------------------------------

loc_F9A4:
	lea	(loc_F9E0).l,a1
	jsr	FindActorSlot
	bcs.s	locret_F9DE
	move.b	#$40,8(a1)
	move.b	#$44,9(a1)
	move.l	#unk_F9E8,$32(a1)
	move.b	#$80,6(a1)
	move.b	#3,$22(a1)
	move.w	#$FFC6,$E(a1)
	move.w	#$E2,$A(a1)

locret_F9DE:
	rts
; -----------------------------------------------------------------------------------------

loc_F9E0:
	jmp	(ActorAnimate).l
; -----------------------------------------------------------------------------------------
	rts
; -----------------------------------------------------------------------------------------
unk_F9E8
	dc.b	5
	dc.b	$44
	dc.b	4
	dc.b	$45
	dc.b	5
	dc.b	$46
	dc.b	4
	dc.b	$47
	dc.b	5
	dc.b	$48
	dc.b	$FF
	dc.b	0
	dc.l	unk_F9E8
; -----------------------------------------------------------------------------------------

loc_F9F8:
	lea	(loc_FA04).l,a1
	jmp	FindActorSlotQuick
; -----------------------------------------------------------------------------------------

loc_FA04:
	tst.b	(word_FF1126).l
	bne.w	locret_FA6C
	addq.w	#1,$26(a0)
	move.w	$26(a0),d0
	andi.w	#7,d0
	bne.s	locret_FA6C
	lea	(loc_FA6E).l,a1
	jsr	FindActorSlot
	bcs.s	locret_FA6C
	move.b	#$40,8(a1)
	move.b	#$4F,9(a1)
	move.b	#$80,6(a1)
	move.b	#3,$22(a1)
	move.w	#0,$26(a1)
	jsr	Random
	andi.w	#$1F,d0
	addi.w	#-$40,d0
	move.w	d0,$E(a1)
	jsr	Random
	andi.w	#$1F,d0
	addi.w	#$E2,d0
	move.w	d0,$A(a1)

locret_FA6C:
	rts
; -----------------------------------------------------------------------------------------

loc_FA6E:
	tst.b	(word_FF1126).l
	bne.s	locret_FA98
	addq.w	#1,$28(a0)
	move.w	$28(a0),d1
	andi.w	#3,d1
	bne.s	locret_FA98
	moveq	#0,d0
	move.w	$26(a0),d0
	move.b	unk_FAA0(pc,d0.w),d0
	bmi.s	loc_FA9A
	move.b	d0,9(a0)
	addq.w	#1,$26(a0)

locret_FA98:
	rts
; -----------------------------------------------------------------------------------------

loc_FA9A:
	jmp	(ActorDeleteSelf).l
; -----------------------------------------------------------------------------------------
unk_FAA0
	dc.b	$4F
	dc.b	$50
	dc.b	$51
	dc.b	$52
	dc.b	$FF
	dc.b	0
	dc.b	0
	dc.b	$7F
	dc.b	0
	dc.b	$FF
	dc.b	1
	dc.b	$FF
	dc.b	1
	dc.b	$FF
; -----------------------------------------------------------------------------------------

loc_FAAE:
	move.w	#0,(word_FF1134).l
	move.w	#1,(word_FF1136).l
	lea	(loc_FBA0).l,a1
	jsr	FindActorSlotQuick
	bcs.s	loc_FADA
	move.w	#$1E0,$26(a1)
	move.w	#$1FF,(dword_FF1130).l

loc_FADA:
	lea	(loc_FAE6).l,a1
	jmp	FindActorSlotQuick
; -----------------------------------------------------------------------------------------

loc_FAE6:
	moveq	#0,d0
	move.l	d0,$26(a0)
	move.w	#$2D0,d0
	jsr	(ActorBookmark_SetDelay).l
	jsr	(ActorBookmark).l
	addi.w	#$80,$A(a0)
	addi.w	#$C0,$C(a0)
	addi.w	#$60,$E(a0)
	addi.w	#$100,$10(a0)
	move.b	$A(a0),d0
	lea	(unk_FCD6).l,a1
	bsr.w	sub_FB96
	move.w	(a1),(palette_buffer+$48).l
	move.b	$E(a0),d0
	lea	(unk_FCE6).l,a1
	bsr.w	sub_FB96
	move.w	(a1),(palette_buffer+$4C).l
	move.w	(dword_FF1130+2).l,d0
	lea	(unk_FD16).l,a1
	move.w	d0,d1
	asl.w	#3,d0
	add.w	d1,d1
	add.w	d1,d1
	add.w	d1,d0
	adda.w	d0,a1
	move.w	(a1)+,(palette_buffer+$46).l
	move.w	(a1)+,(palette_buffer+$54).l
	move.w	(a1)+,(palette_buffer+$58).l
	move.w	(a1)+,(palette_buffer+$5A).l
	move.w	(a1)+,(palette_buffer+$5C).l
	move.w	(a1)+,(palette_buffer+$5E).l
	lea	((palette_buffer+$40)).l,a2
	moveq	#2,d0
	jsr	LoadPalette
	tst.w	(word_FF1134).l
	bne.s	loc_FB90
	rts
; -----------------------------------------------------------------------------------------

loc_FB90:
	jmp	(ActorDeleteSelf).l

; =============== S U B	R O U T	I N E =====================================================


sub_FB96:
	andi.w	#7,d0
	add.w	d0,d0
	adda.w	d0,a1
	rts
; End of function sub_FB96

; -----------------------------------------------------------------------------------------

loc_FBA0:
	subq.w	#1,$26(a0)
	bpl.w	locret_FC98
	jsr	(ActorBookmark).l

loc_FBAE:
	jsr	Random
	andi.w	#7,d0
	move.w	d0,(dword_FF1130+2).l
	jsr	Random
	and.w	(dword_FF1130).l,d0
	addi.w	#$3C,d0
	move.w	d0,$26(a0)
	jsr	(ActorBookmark).l
	tst.w	(word_FF1134).l
	bne.w	loc_FC9A
	subq.w	#1,$26(a0)
	bpl.w	locret_FC98
	lea	(loc_FCA0).l,a1
	jsr	FindActorSlot
	bcs.w	loc_FC92
	jsr	Random
	andi.w	#$3F,d0
	subi.w	#$1F,d0
	addi.w	#$160,d0
	move.w	d0,$A(a1)
	jsr	Random
	andi.w	#$1F,d0
	subi.w	#$F,d0
	addi.w	#-$50,d0
	move.w	d0,$E(a1)
	jsr	Random
	andi.l	#3,d0
	add.w	d0,d0
	addi.l	#unk_FCBC,d0
	move.l	d0,$32(a1)
	move.b	#$40,8(a1)
	move.b	#$49,9(a1)
	move.b	#$80,6(a1)
	move.b	#1,$22(a1)
	move.w	#0,$26(a1)
	jsr	Random
	andi.w	#$1FF,d0
	addi.w	#$100,d0
	move.w	d0,d1
	jsr	Random
	andi.w	#$3F,d0
	addi.w	#$C9,d0
	move.w	d0,d7
	jsr	(Sin).l
	move.l	d2,$12(a1)
	move.w	d7,d0
	jsr	(Cos).l
	move.l	d2,$16(a1)

loc_FC92:
	jmp	(loc_FBAE).l
; -----------------------------------------------------------------------------------------

locret_FC98:
	rts
; -----------------------------------------------------------------------------------------

loc_FC9A:
	jmp	(ActorDeleteSelf).l
; -----------------------------------------------------------------------------------------

loc_FCA0:
	move.b	#$BF,6(a0)
	jsr	(ActorMove).l
	jsr	(ActorAnimate).l
	bcs.s	loc_FCB6
	rts
; -----------------------------------------------------------------------------------------

loc_FCB6:
	jmp	(ActorDeleteSelf).l
; -----------------------------------------------------------------------------------------
unk_FCBC
	dc.b	1
	dc.b	$49
	dc.b	1
	dc.b	$54
	dc.b	1
	dc.b	$55
	dc.b	2
	dc.b	$56
	dc.b	4
	dc.b	$57
	dc.b	7
	dc.b	$58
	dc.b	8
	dc.b	$59
	dc.b	3
	dc.b	$57
	dc.b	2
	dc.b	$55
	dc.b	1
	dc.b	$49
	dc.b	$FF
	dc.b	0
	dc.l	unk_FCBC
unk_FCD6
	dc.b	4
	dc.b	$22
	dc.b	2
	dc.b	$22
	dc.b	4
	dc.b	$22
	dc.b	4
	dc.b	$42
	dc.b	4
	dc.b	$22
	dc.b	4
	dc.b	$24
	dc.b	4
	dc.b	$22
	dc.b	4
	dc.b	2
unk_FCE6
	dc.b	8
	dc.b	$66
	dc.b	8
	dc.b	$46
	dc.b	8
	dc.b	$66
	dc.b	$A
	dc.b	$64
	dc.b	8
	dc.b	$66
	dc.b	8
	dc.b	$46
	dc.b	8
	dc.b	$66
	dc.b	8
	dc.b	$64
	dc.b	$A
	dc.b	8
	dc.b	$A
	dc.b	$28
	dc.b	$A
	dc.b	8
	dc.b	$A
	dc.b	$28
	dc.b	$A
	dc.b	8
	dc.b	$A
	dc.b	$28
	dc.b	$A
	dc.b	8
	dc.b	$A
	dc.b	$28
	dc.b	$E
	dc.b	$EE
	dc.b	$E
	dc.b	$EC
	dc.b	$E
	dc.b	$CE
	dc.b	$E
	dc.b	$EE
	dc.b	$E
	dc.b	$EC
	dc.b	$E
	dc.b	$CE
	dc.b	$E
	dc.b	$EE
	dc.b	$C
	dc.b	$EE
unk_FD16
	dc.b	4
	dc.b	0
	dc.b	6
	dc.b	$40
	dc.b	8
	dc.b	$64
	dc.b	$A
	dc.b	$86
	dc.b	$C
	dc.b	$A8
	dc.b	$E
	dc.b	$EA
	dc.b	0
	dc.b	$40
	dc.b	0
	dc.b	$64
	dc.b	4
	dc.b	$86
	dc.b	6
	dc.b	$A8
	dc.b	8
	dc.b	$CA
	dc.b	$A
	dc.b	$EE
	dc.b	0
	dc.b	4
	dc.b	4
	dc.b	6
	dc.b	6
	dc.b	$48
	dc.b	8
	dc.b	$6A
	dc.b	$A
	dc.b	$8C
	dc.b	$E
	dc.b	$AE
	dc.b	4
	dc.b	$40
	dc.b	6
	dc.b	$64
	dc.b	8
	dc.b	$86
	dc.b	$A
	dc.b	$A8
	dc.b	$C
	dc.b	$CA
	dc.b	$E
	dc.b	$EC
	dc.b	0
	dc.b	$44
	dc.b	4
	dc.b	$66
	dc.b	6
	dc.b	$88
	dc.b	8
	dc.b	$AA
	dc.b	$A
	dc.b	$CC
	dc.b	$C
	dc.b	$EE
	dc.b	4
	dc.b	4
	dc.b	6
	dc.b	$46
	dc.b	8
	dc.b	$68
	dc.b	$A
	dc.b	$8A
	dc.b	$C
	dc.b	$AC
	dc.b	$E
	dc.b	$CE
	dc.b	4
	dc.b	0
	dc.b	6
	dc.b	0
	dc.b	8
	dc.b	$20
	dc.b	$A
	dc.b	$40
	dc.b	$C
	dc.b	$80
	dc.b	$E
	dc.b	$E0
	dc.b	0
	dc.b	$40
	dc.b	0
	dc.b	$60
	dc.b	0
	dc.b	$82
	dc.b	0
	dc.b	$A4
	dc.b	0
	dc.b	$C8
	dc.b	0
	dc.b	$EE
; -----------------------------------------------------------------------------------------
	move.w	#$708,d0
	tst.b	(difficulty).l
	bne.s	locret_FDE6
	lea	(loc_FD94).l,a1
	jsr	FindActorSlotQuick
	move.w	#$BB8,d0
	rts
; -----------------------------------------------------------------------------------------

loc_FD94:
	move.w	#0,(word_FF1136).l
	jsr	(ActorBookmark).l

loc_FDA2:
	lea	(loc_FE0C).l,a1
	jsr	FindActorSlotQuick
	bcs.s	locret_FDE6
	move.w	(word_FF1136).l,d0
	move.w	d0,$28(a1)
	addq.w	#1,d0
	cmpi.w	#7,d0
	beq.s	loc_FDE8
	move.w	d0,(word_FF1136).l
	jsr	Random
	andi.w	#$3F,d0
	addi.w	#$3F,d0
	move.w	d0,$26(a0)
	jsr	(ActorBookmark).l
	subq.w	#1,$26(a0)
	bmi.s	loc_FDA2

locret_FDE6:
	rts
; -----------------------------------------------------------------------------------------

loc_FDE8:
	jmp	(ActorDeleteSelf).l
; -----------------------------------------------------------------------------------------
unk_FDEE
	dc.b	1
	dc.b	$28
unk_FDF0
	dc.b	0
	dc.b	$E0
	dc.b	0
	dc.b	$A0
	dc.b	0
	dc.b	$B0
	dc.b	0
	dc.b	$C0
	dc.b	0
	dc.b	$C0
	dc.b	1
	dc.b	0
	dc.b	0
	dc.b	$D0
	dc.b	1
	dc.b	$40
	dc.b	0
	dc.b	$B8
	dc.b	1
	dc.b	$80
	dc.b	0
	dc.b	$C8
	dc.b	1
	dc.b	$B0
	dc.b	0
	dc.b	$D8
	dc.b	$FF
	dc.b	$FF
; -----------------------------------------------------------------------------------------

loc_FE0C:
	move.l	#unk_FEFC,$32(a0)
	move.w	#$80,d0
	jsr	(ActorBookmark_SetDelay).l
	jsr	(ActorBookmark).l
	move.b	#$95,6(a0)
	move.b	#8,8(a0)
	move.b	#0,9(a0)
	move.w	$28(a0),d0
	asl.w	#2,d0
	move.w	unk_FDEE(pc,d0.w),$A(a0)
	move.w	unk_FDF0(pc,d0.w),$26(a0)
	move.w	#$FF90,$E(a0)
	move.w	#$FFFF,$20(a0)
	move.w	#$1000,$1C(a0)
	jsr	(ActorBookmark).l
	move.w	$1E(a0),$E(a0)
	jsr	(ActorMove).l
	jsr	(ActorAnimate).l
	move.w	$E(a0),$1E(a0)
	addi.w	#-$70,$E(a0)
	move.w	$1E(a0),d0
	cmp.w	$26(a0),d0
	bcc.w	loc_FE8C
	rts
; -----------------------------------------------------------------------------------------

loc_FE8C:
	move.l	#unk_FEE6,$32(a0)
	jsr	Random
	andi.w	#3,d0
	asl.w	#6,d0
	addi.w	#$780,d0
	move.w	d0,$26(a0)
	move.b	#$45,d0
	jsr	PlaySound_ChkSamp
	jsr	(ActorBookmark).l
	jsr	(ActorAnimate).l
	subq.w	#1,$26(a0)
	bpl.s	locret_FEE4
	move.l	#unk_FF2C,$32(a0)
	move.b	#$40,8(a0)
	move.b	#$64,9(a0)
	jsr	(ActorBookmark).l
	jmp	(ActorAnimate).l
; -----------------------------------------------------------------------------------------

locret_FEE4:
	rts
; -----------------------------------------------------------------------------------------
unk_FEE6
	dc.b	8
	dc.b	0
	dc.b	8
	dc.b	1
	dc.b	$C
	dc.b	2
	dc.b	8
	dc.b	1
	dc.b	8
	dc.b	0
	dc.b	8
	dc.b	3
	dc.b	$C
	dc.b	4
	dc.b	8
	dc.b	3
	dc.b	$FF
	dc.b	0
	dc.l	unk_FEE6
unk_FEFC
	dc.b	1
	dc.b	5
	dc.b	1
	dc.b	6
unk_FF00
	dc.b	1
	dc.b	7
	dc.b	1
	dc.b	8
	dc.b	$FF
	dc.b	0
	dc.l	unk_FEFC
unk_FF0A
	dc.b	$22
	dc.b	$5B
	dc.b	$26
	dc.b	$5C
	dc.b	$22
	dc.b	$5B
	dc.b	$26
	dc.b	$5C
	dc.b	$22
	dc.b	$5B
	dc.b	$30
	dc.b	$5C
	dc.b	8
	dc.b	$5D
	dc.b	$20
	dc.b	$5E
	dc.b	8
	dc.b	$5F
	dc.b	$FF
	dc.b	0
	dc.l	unk_FF0A
unk_FF22
	dc.b	$18
	dc.b	$60
	dc.b	$18
	dc.b	$61
	dc.b	$FF
	dc.b	0
	dc.l	unk_FF22
unk_FF2C
	dc.b	8
	dc.b	$64
	dc.b	$10
	dc.b	$63
	dc.b	4
	dc.b	$65
	dc.b	4
	dc.b	$66
	dc.b	4
	dc.b	$65
	dc.b	4
	dc.b	$66
	dc.b	4
	dc.b	$65
	dc.b	4
	dc.b	$66
	dc.b	2
	dc.b	$65
	dc.b	2
	dc.b	$66
	dc.b	8
	dc.b	$63
	dc.b	$10
	dc.b	$64
	dc.b	$FF
	dc.b	0
	dc.l	unk_FF22

; =============== S U B	R O U T	I N E =====================================================


sub_FF4A:
	lea	(loc_FFBE).l,a1
	jsr	FindActorSlot
	bcc.w	loc_FF5C
	rts
; -----------------------------------------------------------------------------------------

loc_FF5C:
	movem.l	d1,-(sp)
	lsl.w	#2,d0
	move.w	d0,d1
	cmpi.w	#$20,d1
	bcs.w	loc_FF70
	move.w	#$1C,d1

loc_FF70:
	lea	(unk_FF9E).l,a2
	move.w	(a2,d1.w),$28(a1)
	move.w	2(a2,d1.w),$2A(a1)
	movem.l	(sp)+,d1
	move.b	#$69,8(a1)
	lea	(off_1007A).l,a2
	move.l	(a2,d0.w),$32(a1)
	move.l	a0,$2E(a1)
	rts
; End of function sub_FF4A

; -----------------------------------------------------------------------------------------
unk_FF9E
	dc.b	0
	dc.b	$80
	dc.b	0
	dc.b	1
	dc.b	0
	dc.b	$80
	dc.b	0
	dc.b	1
	dc.b	0
	dc.b	$80
	dc.b	0
	dc.b	1
	dc.b	0
	dc.b	$80
	dc.b	0
	dc.b	1
	dc.b	0
	dc.b	$80
	dc.b	0
	dc.b	0
	dc.b	1
	dc.b	0
	dc.b	0
	dc.b	3
	dc.b	1
	dc.b	0
	dc.b	0
	dc.b	1
	dc.b	0
	dc.b	$80
	dc.b	0
	dc.b	1
; -----------------------------------------------------------------------------------------

loc_FFBE:
	tst.w	$26(a0)
	beq.w	loc_FFCC
	subq.w	#1,$26(a0)
	rts
; -----------------------------------------------------------------------------------------

loc_FFCC:
	movea.l	$32(a0),a1
	move.w	(a1)+,d0
	cmpi.b	#$FF,-2(a1)
	beq.w	loc_10006
	move.l	a1,$32(a0)
	bsr.w	sub_10058
	addq.b	#1,(byte_FF1129).l
	move.b	(byte_FF1129).l,d0
	andi.b	#1,d0
	bne.s	loc_FFFE
	move.b	8(a0),d0
	bsr.w	PlaySound_ChkSamp

loc_FFFE:
	move.w	$2A(a0),$26(a0)
	rts
; -----------------------------------------------------------------------------------------

loc_10006:
	andi.w	#$FF,d0
	move.w	(a1)+,d1

loc_1000C:
	move.l	a1,$32(a0)
	movea.l	off_10016(pc,d0.w),a1
	jmp	(a1)
; -----------------------------------------------------------------------------------------
off_10016
	dc.l	loc_10038
	dc.l	loc_1003E
off_1001E
	dc.l	loc_10044
	dc.l	loc_1004A
off_10026
	dc.l	loc_1002E
	dc.l	loc_10052
; -----------------------------------------------------------------------------------------

loc_1002E:
	movea.l	$2E(a0),a1
	move.b	d1,7(a1)
	rts
; -----------------------------------------------------------------------------------------

loc_10038:
	jmp	(ActorDeleteSelf).l
; -----------------------------------------------------------------------------------------

loc_1003E:
	move.w	d1,$26(a0)
	rts
; -----------------------------------------------------------------------------------------

loc_10044:
	move.w	d1,$12(a0)
	rts
; -----------------------------------------------------------------------------------------

loc_1004A:
	move.w	d1,d0

loc_1004C:
	jmp	QueuePlaneCmdList
; -----------------------------------------------------------------------------------------

loc_10052:
	move.b	d1,8(a0)
	rts

; =============== S U B	R O U T	I N E =====================================================


sub_10058:
	DISABLE_INTS
	eori.w	#$8000,d0
	move.w	$12(a0),d5
	jsr	SetVRAMWrite
	move.w	d0,VDP_DATA
	ENABLE_INTS
	addq.w	#2,$12(a0)
	rts
; End of function sub_10058

; -----------------------------------------------------------------------------------------
off_1007A
	dc.l	unk_1046E
	dc.l	unk_1046E
	dc.l	unk_1046E
	dc.l	unk_1046E
	dc.l	unk_1046E
	dc.l	unk_1046E
	dc.l	unk_10474
	dc.l	unk_100E4
	dc.l	unk_1015A
	dc.l	unk_101EC
	dc.l	unk_10238
	dc.l	unk_102A4
	dc.l	unk_10310
	dc.l	unk_10380
	dc.l	unk_10382
	dc.l	0
	dc.l	unk_100D6
	dc.l	unk_100D8
	dc.l	unk_100DA
	dc.l	unk_100DC
	dc.l	unk_100DE
	dc.l	unk_100E0
	dc.l	unk_100E2
unk_100D6
	dc.b	$FF
	dc.b	0
unk_100D8
	dc.b	$FF
	dc.b	0
unk_100DA
	dc.b	$FF
	dc.b	0
unk_100DC
	dc.b	$FF
	dc.b	0
unk_100DE
	dc.b	$FF
	dc.b	0
unk_100E0
	dc.b	$FF
	dc.b	0
unk_100E2
	dc.b	$FF
	dc.b	0
unk_100E4
	dc.b	$FF
	dc.b	$C
	dc.b	0
	dc.b	$2B
	dc.b	$FF
	dc.b	8
	dc.b	$C2
	dc.b	$24
	dc.b	3
	dc.b	$60
	dc.b	3
	dc.b	$7A
	dc.b	3
	dc.b	$6C
	dc.b	3
	dc.b	$30
	dc.b	3
	dc.b	$57
	dc.b	3
	dc.b	$50
	dc.b	3
	dc.b	$51
	dc.b	3
	dc.b	$5F
	dc.b	3
	dc.b	$30
	dc.b	3
	dc.b	$68
	dc.b	3
	dc.b	$75
	dc.b	3
	dc.b	$6B
	dc.b	3
	dc.b	$30
	dc.b	3
	dc.b	$5D
	dc.b	3
	dc.b	$54
	dc.b	3
	dc.b	$52
	dc.b	3
	dc.b	$53
	dc.b	3
	dc.b	$5F
	dc.b	$FF
	dc.b	8
	dc.b	$C3
	dc.b	$24
	dc.b	3
	dc.b	$7B
	dc.b	3
	dc.b	$76
	dc.b	3
	dc.b	$30
	dc.b	3
	dc.b	$74
	dc.b	3
	dc.b	$76
	dc.b	3
	dc.b	$7D
	dc.b	3
	dc.b	$6C
	dc.b	3
	dc.b	$30
	dc.b	3
	dc.b	$7B
	dc.b	3
	dc.b	$6F
	dc.b	3
	dc.b	$6C
	dc.b	3
	dc.b	$30
	dc.b	3
	dc.b	$69
	dc.b	3
	dc.b	$6C
	dc.b	3
	dc.b	$68
	dc.b	3
	dc.b	$75
	dc.b	3
	dc.b	$7A
	dc.b	$FF
	dc.b	8
	dc.b	$C4
	dc.b	$24
	dc.b	3
	dc.b	$68
	dc.b	3
	dc.b	$7A
	dc.b	3
	dc.b	$30
	dc.b	3
	dc.b	$7B
	dc.b	3
	dc.b	$6F
	dc.b	3
	dc.b	$6C
	dc.b	3
	dc.b	$80
	dc.b	3
	dc.b	$30
	dc.b	3
	dc.b	$68
	dc.b	3
	dc.b	$79
	dc.b	3
	dc.b	$79
	dc.b	3
	dc.b	$70
	dc.b	3
	dc.b	$7D
	dc.b	3
	dc.b	$6C
	dc.b	3
	dc.b	$32
	dc.b	$FF
	dc.b	0
unk_1015A
	dc.b	$FF
	dc.b	$C
	dc.b	0
	dc.b	$2B
	dc.b	$FF
	dc.b	8
	dc.b	$C2
	dc.b	$24
	dc.b	3
	dc.b	$60
	dc.b	3
	dc.b	$7A
	dc.b	3
	dc.b	$6C
	dc.b	3
	dc.b	$30
	dc.b	3
	dc.b	$7B
	dc.b	3
	dc.b	$6F
	dc.b	3
	dc.b	$6C
	dc.b	3
	dc.b	$30
	dc.b	3
	dc.b	$69
	dc.b	3
	dc.b	$7C
	dc.b	3
	dc.b	$7B
	dc.b	3
	dc.b	$7B
	dc.b	3
	dc.b	$76
	dc.b	3
	dc.b	$75
	dc.b	3
	dc.b	$7A
	dc.b	3
	dc.b	$30
	dc.b	3
	dc.b	$7B
	dc.b	3
	dc.b	$76
	dc.b	$FF
	dc.b	8
	dc.b	$C3
	dc.b	$24
	dc.b	3
	dc.b	$79
	dc.b	3
	dc.b	$76
	dc.b	3
	dc.b	$7B
	dc.b	3
	dc.b	$68
	dc.b	3
	dc.b	$7B
	dc.b	3
	dc.b	$6C
	dc.b	3
	dc.b	$30
	dc.b	3
	dc.b	$7B
	dc.b	3
	dc.b	$6F
	dc.b	3
	dc.b	$6C
	dc.b	3
	dc.b	$74
	dc.b	3
	dc.b	$30
	dc.b	3
	dc.b	$76
	dc.b	3
	dc.b	$75
	dc.b	3
	dc.b	$6C
	dc.b	3
	dc.b	$30
	dc.b	3
	dc.b	$7E
	dc.b	3
	dc.b	$68
	dc.b	3
	dc.b	$80
	dc.b	$FF
	dc.b	8
	dc.b	$C4
	dc.b	$24
	dc.b	3
	dc.b	$76
	dc.b	3
	dc.b	$79
	dc.b	3
	dc.b	$30
	dc.b	3
	dc.b	$7B
	dc.b	3
	dc.b	$6F
	dc.b	3
	dc.b	$6C
	dc.b	3
	dc.b	$30
	dc.b	3
	dc.b	$76
	dc.b	3
	dc.b	$7B
	dc.b	3
	dc.b	$6F
	dc.b	3
	dc.b	$6C
	dc.b	3
	dc.b	$79
	dc.b	3
	dc.b	$30
	dc.b	3
	dc.b	$68
	dc.b	3
	dc.b	$7A
	dc.b	$FF
	dc.b	8
	dc.b	$C5
	dc.b	$24
	dc.b	3
	dc.b	$7B
	dc.b	3
	dc.b	$6F
	dc.b	3
	dc.b	$6C
	dc.b	3
	dc.b	$80
	dc.b	3
	dc.b	$30
	dc.b	3
	dc.b	$6D
	dc.b	3
	dc.b	$68
	dc.b	3
	dc.b	$73
	dc.b	3
	dc.b	$73
	dc.b	3
	dc.b	$32
	dc.b	$FF
	dc.b	0
unk_101EC
	dc.b	$FF
	dc.b	$C
	dc.b	0
	dc.b	$2B
	dc.b	$FF
	dc.b	8
	dc.b	$C2
	dc.b	$24
	dc.b	3
	dc.b	$60
	dc.b	3
	dc.b	$7A
	dc.b	3
	dc.b	$6C
	dc.b	3
	dc.b	$30
	dc.b	3
	dc.b	$4F
	dc.b	3
	dc.b	$5A
	dc.b	3
	dc.b	$62
	dc.b	3
	dc.b	$59
	dc.b	3
	dc.b	$30
	dc.b	3
	dc.b	$7B
	dc.b	3
	dc.b	$76
	dc.b	3
	dc.b	$30
	dc.b	3
	dc.b	$7A
	dc.b	3
	dc.b	$77
	dc.b	3
	dc.b	$6C
	dc.b	3
	dc.b	$6C
	dc.b	3
	dc.b	$6B
	dc.b	$FF
	dc.b	8
	dc.b	$C3
	dc.b	$24
	dc.b	3
	dc.b	$7B
	dc.b	3
	dc.b	$6F
	dc.b	3
	dc.b	$6C
	dc.b	3
	dc.b	$70
	dc.b	3
	dc.b	$79
	dc.b	3
	dc.b	$30
	dc.b	3
	dc.b	$6B
	dc.b	3
	dc.b	$6C
	dc.b	3
	dc.b	$7A
	dc.b	3
	dc.b	$6A
	dc.b	3
	dc.b	$6C
	dc.b	3
	dc.b	$75
	dc.b	3
	dc.b	$7B
	dc.b	3
	dc.b	$32
	dc.b	$FF
	dc.b	0
unk_10238
	dc.b	$FF
	dc.b	$C
	dc.b	0
	dc.b	$2B
	dc.b	$FF
	dc.b	8
	dc.b	$C2
	dc.b	$24
	dc.b	3
	dc.b	$52
	dc.b	3
	dc.b	$79
	dc.b	3
	dc.b	$76
	dc.b	3
	dc.b	$7C
	dc.b	3
	dc.b	$77
	dc.b	3
	dc.b	$30
	dc.b	3
	dc.b	$6D
	dc.b	3
	dc.b	$76
	dc.b	3
	dc.b	$7C
	dc.b	3
	dc.b	$79
	dc.b	3
	dc.b	$30
	dc.b	3
	dc.b	$76
	dc.b	3
	dc.b	$79
	dc.b	3
	dc.b	$30
	dc.b	3
	dc.b	$74
	dc.b	3
	dc.b	$76
	dc.b	3
	dc.b	$79
	dc.b	3
	dc.b	$6C
	dc.b	$FF
	dc.b	8
	dc.b	$C3
	dc.b	$24
	dc.b	3
	dc.b	$7B
	dc.b	3
	dc.b	$76
	dc.b	3
	dc.b	$6E
	dc.b	3
	dc.b	$6C
	dc.b	3
	dc.b	$7B
	dc.b	3
	dc.b	$6F
	dc.b	3
	dc.b	$6C
	dc.b	3
	dc.b	$79
	dc.b	3
	dc.b	$30
	dc.b	3
	dc.b	$7B
	dc.b	3
	dc.b	$76
	dc.b	3
	dc.b	$30
	dc.b	3
	dc.b	$73
	dc.b	3
	dc.b	$6C
	dc.b	3
	dc.b	$7B
	dc.b	$FF
	dc.b	8
	dc.b	$C4
	dc.b	$24
	dc.b	3
	dc.b	$7B
	dc.b	3
	dc.b	$6F
	dc.b	3
	dc.b	$6C
	dc.b	3
	dc.b	$74
	dc.b	3
	dc.b	$30
	dc.b	3
	dc.b	$6C
	dc.b	3
	dc.b	$7A
	dc.b	3
	dc.b	$6A
	dc.b	3
	dc.b	$68
	dc.b	3
	dc.b	$77
	dc.b	3
	dc.b	$6C
	dc.b	3
	dc.b	$32
	dc.b	$FF
	dc.b	0
unk_102A4
	dc.b	$FF
	dc.b	$C
	dc.b	0
	dc.b	$2B
	dc.b	$FF
	dc.b	8
	dc.b	$C2
	dc.b	$24
	dc.b	3
	dc.b	$54
	dc.b	3
	dc.b	$6D
	dc.b	3
	dc.b	$30
	dc.b	3
	dc.b	$7A
	dc.b	3
	dc.b	$77
	dc.b	3
	dc.b	$68
	dc.b	3
	dc.b	$6A
	dc.b	3
	dc.b	$6C
	dc.b	3
	dc.b	$30
	dc.b	3
	dc.b	$79
	dc.b	3
	dc.b	$7C
	dc.b	3
	dc.b	$75
	dc.b	3
	dc.b	$7A
	dc.b	3
	dc.b	$30
	dc.b	3
	dc.b	$76
	dc.b	3
	dc.b	$7C
	dc.b	3
	dc.b	$7B
	dc.b	$FF
	dc.b	8
	dc.b	$C3
	dc.b	$24
	dc.b	3
	dc.b	$7B
	dc.b	3
	dc.b	$6F
	dc.b	3
	dc.b	$6C
	dc.b	3
	dc.b	$75
	dc.b	$FF
	dc.b	4
	dc.b	0
	dc.b	$20
	dc.b	$FF
	dc.b	8
	dc.b	$C3
	dc.b	$2E
	dc.b	3
	dc.b	$7B
	dc.b	3
	dc.b	$6F
	dc.b	3
	dc.b	$6C
	dc.b	3
	dc.b	$80
	dc.b	3
	dc.b	$30
	dc.b	3
	dc.b	$6A
	dc.b	3
	dc.b	$68
	dc.b	3
	dc.b	$75
	dc.b	3
	dc.b	$75
	dc.b	3
	dc.b	$76
	dc.b	3
	dc.b	$7B
	dc.b	3
	dc.b	$30
	dc.b	3
	dc.b	$69
	dc.b	3
	dc.b	$6C
	dc.b	$FF
	dc.b	8
	dc.b	$C4
	dc.b	$24
	dc.b	3
	dc.b	$7A
	dc.b	3
	dc.b	$68
	dc.b	3
	dc.b	$7D
	dc.b	3
	dc.b	$6C
	dc.b	3
	dc.b	$6B
	dc.b	3
	dc.b	$32
	dc.b	$FF
	dc.b	0
unk_10310
	dc.b	$FF
	dc.b	$C
	dc.b	0
	dc.b	$2B
	dc.b	$FF
	dc.b	8
	dc.b	$C2
	dc.b	$24
	dc.b	3
	dc.b	$51
	dc.b	3
	dc.b	$79
	dc.b	3
	dc.b	$6C
	dc.b	3
	dc.b	$6C
	dc.b	3
	dc.b	$30
	dc.b	3
	dc.b	$74
	dc.b	3
	dc.b	$68
	dc.b	3
	dc.b	$75
	dc.b	3
	dc.b	$80
	dc.b	3
	dc.b	$30
	dc.b	3
	dc.b	$6E
	dc.b	3
	dc.b	$79
	dc.b	3
	dc.b	$76
	dc.b	3
	dc.b	$7C
	dc.b	3
	dc.b	$77
	dc.b	3
	dc.b	$7A
	dc.b	3
	dc.b	$30
	dc.b	3
	dc.b	$76
	dc.b	3
	dc.b	$6D
	dc.b	$FF
	dc.b	8
	dc.b	$C3
	dc.b	$24
	dc.b	3
	dc.b	$69
	dc.b	3
	dc.b	$6C
	dc.b	3
	dc.b	$68
	dc.b	3
	dc.b	$75
	dc.b	3
	dc.b	$7A
	dc.b	3
	dc.b	$30
	dc.b	3
	dc.b	$7B
	dc.b	3
	dc.b	$76
	dc.b	3
	dc.b	$30
	dc.b	3
	dc.b	$70
	dc.b	3
	dc.b	$75
	dc.b	3
	dc.b	$6A
	dc.b	3
	dc.b	$79
	dc.b	3
	dc.b	$6C
	dc.b	3
	dc.b	$68
	dc.b	3
	dc.b	$7A
	dc.b	3
	dc.b	$6C
	dc.b	$FF
	dc.b	8
	dc.b	$C4
	dc.b	$24
	dc.b	3
	dc.b	$80
	dc.b	3
	dc.b	$76
	dc.b	3
	dc.b	$7C
	dc.b	3
	dc.b	$79
	dc.b	3
	dc.b	$30
	dc.b	3
	dc.b	$7A
	dc.b	3
	dc.b	$6A
	dc.b	3
	dc.b	$76
	dc.b	3
	dc.b	$79
	dc.b	3
	dc.b	$6C
	dc.b	3
	dc.b	$32
	dc.b	$FF
	dc.b	0
unk_10380
	dc.b	$FF
	dc.b	0
unk_10382
	dc.b	$FF
	dc.b	$C
	dc.b	0
	dc.b	$2B
	dc.b	$FF
	dc.b	8
	dc.b	$C2
	dc.b	$24
	dc.b	3
	dc.b	$62
	dc.b	3
	dc.b	$68
	dc.b	3
	dc.b	$7B
	dc.b	3
	dc.b	$6A
	dc.b	3
	dc.b	$6F
	dc.b	3
	dc.b	$30
	dc.b	3
	dc.b	$76
	dc.b	3
	dc.b	$7C
	dc.b	3
	dc.b	$7B
	dc.b	3
	dc.b	$30
	dc.b	3
	dc.b	$6D
	dc.b	3
	dc.b	$76
	dc.b	3
	dc.b	$79
	dc.b	3
	dc.b	$30
	dc.b	3
	dc.b	$7B
	dc.b	3
	dc.b	$6F
	dc.b	3
	dc.b	$6C
	dc.b	$FF
	dc.b	8
	dc.b	$C3
	dc.b	$24
	dc.b	3
	dc.b	$79
	dc.b	3
	dc.b	$6C
	dc.b	3
	dc.b	$6D
	dc.b	3
	dc.b	$7C
	dc.b	3
	dc.b	$6E
	dc.b	3
	dc.b	$6C
	dc.b	3
	dc.b	$6C
	dc.b	3
	dc.b	$30
	dc.b	3
	dc.b	$69
	dc.b	3
	dc.b	$6C
	dc.b	3
	dc.b	$68
	dc.b	3
	dc.b	$75
	dc.b	3
	dc.b	$7A
	dc.b	$FF
	dc.b	8
	dc.b	$C4
	dc.b	$24
	dc.b	3
	dc.b	$7E
	dc.b	3
	dc.b	$6F
	dc.b	3
	dc.b	$70
	dc.b	3
	dc.b	$6A
	dc.b	3
	dc.b	$6F
	dc.b	3
	dc.b	$30
	dc.b	3
	dc.b	$6A
	dc.b	3
	dc.b	$68
	dc.b	3
	dc.b	$75
	dc.b	3
	dc.b	$75
	dc.b	3
	dc.b	$76
	dc.b	3
	dc.b	$7B
	dc.b	3
	dc.b	$30
	dc.b	3
	dc.b	$69
	dc.b	3
	dc.b	$6C
	dc.b	$FF
	dc.b	8
	dc.b	$C5
	dc.b	$24
	dc.b	3
	dc.b	$6E
	dc.b	3
	dc.b	$79
	dc.b	3
	dc.b	$76
	dc.b	3
	dc.b	$7C
	dc.b	3
	dc.b	$77
	dc.b	3
	dc.b	$6C
	dc.b	3
	dc.b	$6B
	dc.b	3
	dc.b	$32
	dc.b	3
	dc.b	$32
	dc.b	3
	dc.b	$32
	dc.b	$FF
	dc.b	4
	dc.b	0
	dc.b	$80
	dc.b	$FF
	dc.b	$C
	dc.b	0
	dc.b	$2B
	dc.b	$FF
	dc.b	8
	dc.b	$C2
	dc.b	$24
	dc.b	3
	dc.b	$32
	dc.b	3
	dc.b	$32
	dc.b	3
	dc.b	$32
	dc.b	3
	dc.b	$69
	dc.b	3
	dc.b	$7C
	dc.b	3
	dc.b	$7B
	dc.b	3
	dc.b	$30
	dc.b	3
	dc.b	$74
	dc.b	3
	dc.b	$7C
	dc.b	3
	dc.b	$7A
	dc.b	3
	dc.b	$7B
	dc.b	3
	dc.b	$30
	dc.b	3
	dc.b	$6C
	dc.b	3
	dc.b	$7A
	dc.b	3
	dc.b	$6A
	dc.b	3
	dc.b	$68
	dc.b	3
	dc.b	$77
	dc.b	3
	dc.b	$6C
	dc.b	$FF
	dc.b	8
	dc.b	$C3
	dc.b	$24
	dc.b	3
	dc.b	$7E
	dc.b	3
	dc.b	$70
	dc.b	3
	dc.b	$7B
	dc.b	3
	dc.b	$6F
	dc.b	3
	dc.b	$30
	dc.b	3
	dc.b	$68
	dc.b	3
	dc.b	$30
	dc.b	3
	dc.b	$75
	dc.b	3
	dc.b	$6C
	dc.b	3
	dc.b	$70
	dc.b	3
	dc.b	$6E
	dc.b	3
	dc.b	$6F
	dc.b	3
	dc.b	$69
	dc.b	3
	dc.b	$76
	dc.b	3
	dc.b	$79
	dc.b	3
	dc.b	$70
	dc.b	3
	dc.b	$75
	dc.b	3
	dc.b	$6E
	dc.b	$FF
	dc.b	8
	dc.b	$C4
	dc.b	$24
	dc.b	3
	dc.b	$6E
	dc.b	3
	dc.b	$79
	dc.b	3
	dc.b	$76
	dc.b	3
	dc.b	$7C
	dc.b	3
	dc.b	$77
	dc.b	3
	dc.b	$32
	dc.b	$FF
	dc.b	0
unk_1046E
	dc.b	$FF
	dc.b	8
	dc.b	$C4
	dc.b	$24
	dc.b	$FF
	dc.b	0
unk_10474
	dc.b	$FF
	dc.b	8
	dc.b	$C4
	dc.b	$24
	dc.b	$FF
	dc.b	0
; -----------------------------------------------------------------------------------------

loc_1047A:
	lea	(loc_10486).l,a1
	jmp	FindActorSlot
; -----------------------------------------------------------------------------------------

loc_10486:
	move.b	p1_ctrl+ctlPress,d0
	or.b	p2_ctrl+ctlPress,d0
	andi.b	#$F0,d0
	bne.w	loc_1049C
	rts
; -----------------------------------------------------------------------------------------

loc_1049C:
	clr.b	(bytecode_disabled).l
	move.b	#2,bytecode_flag
	jmp	(ActorDeleteSelf).l

; =============== S U B	R O U T	I N E =====================================================


sub_104B0:
	lea	(sub_104E2).l,a1
	jsr	FindActorSlotQuick
	bcc.w	loc_104C2
	rts
; -----------------------------------------------------------------------------------------

loc_104C2:
	move.b	#$80,6(a1)
	move.b	#8,8(a1)
	move.b	#9,9(a1)
	move.w	#$A0,$A(a1)
	move.w	#$FFE8,$E(a1)
	rts
; End of function sub_104B0


; =============== S U B	R O U T	I N E =====================================================


sub_104E2:
	tst.b	(word_FF1124).l
	beq.s	locret_104F0
	jmp	(ActorDeleteSelf).l
; -----------------------------------------------------------------------------------------

locret_104F0:
	rts
; End of function sub_104E2


; =============== S U B	R O U T	I N E =====================================================


sub_104F2:
	movem.l	a0,-(sp)
	move.b	opponent,d0
	cmpi.b	#3,d0
	bne.s	loc_10520
	lea	(ArtNem_ArmsIntro2).l,a0
	move.w	#$600,d0
	DISABLE_INTS
	jsr	NemDec
	ENABLE_INTS
	moveq	#$12,d0
	bsr.w	sub_10DB2

loc_10520:
	clr.l	d0
	move.b	opponent,d0
	cmpi.b	#$C,d0
	beq.s	loc_1054C
	lsl.w	#2,d0
	lea	(OpponentArt).l,a1
	movea.l	(a1,d0.w),a0
	move.w	#$8000,d0
	DISABLE_INTS
	jsr	NemDec
	ENABLE_INTS

loc_1054C:
	movem.l	(sp)+,a0
	clr.w	d0
	move.b	opponent,d0
	move.b	d0,d1
	addi.b	#9,d1
	cmpi.b	#$15,d1
	bne.s	loc_1057A
	move.b	#$2B,d1
	lea	(loc_10712).l,a1
	jsr	FindActorSlotQuick
	bcc.w	loc_1058C
	rts
; -----------------------------------------------------------------------------------------

loc_1057A:
	lea	(loc_1066C).l,a1
	jsr	FindActorSlotQuick
	bcc.w	loc_1058C
	rts
; -----------------------------------------------------------------------------------------

loc_1058C:
	move.l	a0,$2E(a1)
	move.b	#$B7,6(a1)
	move.b	#$FF,7(a1)
	move.b	d1,8(a1)
	move.w	#4,$1E(a1)
	move.w	#$34,$26(a1)
	move.w	#6,$12(a1)
	move.w	#$4000,$1C(a1)
	movea.l	a1,a2
	clr.w	d2
	move.b	opponent,d2
	move.w	d2,d3
	lsl.w	#2,d3
	lea	(unk_10628).l,a3
	adda.w	d3,a3
	move.w	(a3)+,$A(a1)
	move.w	(a3),$E(a1)
	lea	(byte_10702).l,a3
	clr.w	d3
	move.b	(a3,d2.w),d3
	lea	(off_AC48).l,a3
	lsl.w	#2,d2
	movea.l	(a3,d2.w),a4
	lsl.w	#2,d3
	move.l	(a4,d3.w),$32(a1)

loc_105F6:
	clr.l	d0
	move.b	opponent,d0
	move.b	byte_10616(pc,d0.w),d0
	lsl.w	#5,d0
	lea	Palettes,a2
	adda.l	d0,a2
	move.b	#3,d0
	jmp	LoadPalette
; End of function sub_104F2

; -----------------------------------------------------------------------------------------
byte_10616
	dc.b	$31
	dc.b	$3D
	dc.b	$42
	dc.b	$45
	dc.b	$31
	dc.b	$4B
	dc.b	$41
	dc.b	$31
	dc.b	$47
	dc.b	$49
	dc.b	$48
	dc.b	$4E
	dc.b	0
	dc.b	$31
	dc.b	$4A
	dc.b	$4D
	dc.b	$31
	dc.b	1
unk_10628
	dc.b	0
	dc.b	$30
	dc.b	0
	dc.b	$40
	dc.b	0
	dc.b	$38
	dc.b	0
	dc.b	$28
	dc.b	0
	dc.b	$40
	dc.b	0
	dc.b	8
	dc.b	0
	dc.b	$28
	dc.b	0
	dc.b	$20
	dc.b	0
	dc.b	$30
	dc.b	0
	dc.b	$40
	dc.b	0
	dc.b	$38
	dc.b	0
	dc.b	$30
	dc.b	0
	dc.b	$30
	dc.b	0
	dc.b	$30
	dc.b	0
	dc.b	$30
	dc.b	0
	dc.b	$38
	dc.b	0
	dc.b	$30
	dc.b	0
	dc.b	$28
	dc.b	0
	dc.b	$30
	dc.b	0
	dc.b	$28
	dc.b	0
	dc.b	$30
	dc.b	0
	dc.b	$28
	dc.b	0
	dc.b	$30
	dc.b	0
	dc.b	$28
	dc.b	0
	dc.b	$28
	dc.b	$FF
	dc.b	$E8
	dc.b	0
	dc.b	$30
	dc.b	0
	dc.b	$20
	dc.b	0
	dc.b	$30
	dc.b	0
	dc.b	$30
	dc.b	0
	dc.b	$30
	dc.b	0
	dc.b	$20
	dc.b	0
	dc.b	$28
	dc.b	0
	dc.b	$20
; -----------------------------------------------------------------------------------------

loc_1066C:
	jsr	(ActorAnimate).l
	jsr	(ActorBookmark).l
	move.w	$1E(a0),d0
	add.w	d0,$A(a0)
	subq.w	#1,$26(a0)
	beq.w	loc_1068A
	rts
; -----------------------------------------------------------------------------------------

loc_1068A:
	jsr	(ActorBookmark).l
	jsr	(ActorAnimate).l
	movea.l	$32(a0),a2
	cmpi.b	#$FE,(a2)
	bne.s	loc_106C8
	clr.w	d2
	move.b	opponent,d2
	lea	(byte_10702).l,a3
	clr.w	d3
	move.b	(a3,d2.w),d3
	lea	(off_AC48).l,a3
	lsl.w	#2,d2
	movea.l	(a3,d2.w),a4
	lsl.w	#2,d3
	move.l	(a4,d3.w),$32(a0)

loc_106C8:
	movea.l	$2E(a0),a1
	tst.b	7(a1)
	beq.w	loc_106D6
	rts
; -----------------------------------------------------------------------------------------

loc_106D6:
	move.w	#$20,$26(a0)
	jsr	(ActorBookmark).l
	jsr	(ActorMove).l
	subq.w	#1,$26(a0)
	beq.w	loc_106F2
	rts
; -----------------------------------------------------------------------------------------

loc_106F2:
	clr.b	7(a0)
	jsr	(ActorBookmark).l
	jmp	(ActorDeleteSelf).l
; -----------------------------------------------------------------------------------------
byte_10702
	dc.b	0
	dc.b	0
	dc.b	4
	dc.b	1
	dc.b	0
	dc.b	1
	dc.b	5
	dc.b	1
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	2
	dc.b	2
	dc.b	0
	dc.b	0
	dc.b	0
; -----------------------------------------------------------------------------------------

loc_10712:
	move.w	#8,$E(a0)
	jsr	(sub_1077C).l
	jsr	(ActorBookmark).l
	move.w	$1E(a0),d0
	add.w	d0,$A(a0)
	subq.w	#1,$26(a0)
	beq.w	loc_10736
	rts
; -----------------------------------------------------------------------------------------

loc_10736:
	jsr	(ActorBookmark).l
	jsr	(sub_1077C).l
	movea.l	$2E(a0),a1
	tst.b	7(a1)
	beq.w	loc_10750
	rts
; -----------------------------------------------------------------------------------------

loc_10750:
	move.w	#$20,$26(a0)
	jsr	(ActorBookmark).l
	jsr	(ActorMove).l
	subq.w	#1,$26(a0)
	beq.w	loc_1076C
	rts
; -----------------------------------------------------------------------------------------

loc_1076C:
	clr.b	7(a0)
	jsr	(ActorBookmark).l
	jmp	(ActorDeleteSelf).l

; =============== S U B	R O U T	I N E =====================================================


sub_1077C:
	tst.b	$22(a0)
	beq.w	loc_1078A
	subq.b	#1,$22(a0)
	rts
; -----------------------------------------------------------------------------------------

loc_1078A:
	movea.l	$32(a0),a2
	cmpi.b	#$FF,(a2)
	bne.w	loc_1079A
	movea.l	2(a2),a2

loc_1079A:
	move.b	(a2)+,$22(a0)
	move.b	(a2)+,d0
	move.b	d0,9(a0)
	move.l	a2,$32(a0)
	lsl.w	#2,d0
	lea	(off_ABC8).l,a1
	move.l	(a1,d0.w),d0
	move.l	a0,-(sp)
	lea	dma_queue,a0
	adda.w	dma_slot,a0
	move.w	#$8F02,(a0)+
	move.l	#$94059380,(a0)+
	lsr.l	#1,d0
	move.l	d0,d1
	lsr.w	#8,d0
	swap	d0
	move.w	d1,d0
	andi.w	#$FF,d0
	addi.l	#-$69FF6B00,d0
	swap	d1
	andi.w	#$7F,d1
	addi.w	#-$6900,d1
	move.l	d0,(a0)+
	move.w	d1,(a0)+
	move.l	#$60000080,(a0)
	addi.w	#$10,dma_slot
	movea.l	(sp)+,a0
	rts
; End of function sub_1077C


; =============== S U B	R O U T	I N E =====================================================


sub_10800:
	clr.w	d0
	move.b	stage,d0
	lea	(unk_10822).l,a1
	move.b	(a1,d0.w),opponent
	lea	(loc_10834).l,a1
	jmp	FindActorSlot
; End of function sub_10800

; -----------------------------------------------------------------------------------------
unk_10822
	dc.b	$10
	dc.b	0
	dc.b	4
	dc.b	$D
	dc.b	3
	dc.b	1
	dc.b	$E
	dc.b	7
	dc.b	6
	dc.b	$F
	dc.b	2
	dc.b	5
	dc.b	8
	dc.b	9
	dc.b	$A
	dc.b	$B
	dc.b	$C
	dc.b	$11
; -----------------------------------------------------------------------------------------

loc_10834:
	move.b	#1,(word_FF1126).l
	move.b	#$FF,7(a0)
	bsr.w	sub_1090A
	jsr	(ActorBookmark).l
	bsr.w	sub_1095A
	jsr	(ActorBookmark).l
	bsr.w	sub_1093A
	jsr	(ActorBookmark).l
	move.b	#0,(word_FF1126).l
	move.w	#$80,d0
	jsr	(ActorBookmark_SetDelay).l
	jsr	(ActorBookmark).l
	moveq	#0,d0
	move.b	stage,d0
	bsr.w	sub_10DB2
	move.w	#1,(word_FF198C).l
	move.w	#$A0,d0
	jsr	(ActorBookmark_SetDelay).l
	jsr	(ActorBookmark).l
	cmpi.b	#$11,stage
	bcs.w	loc_108B8
	move.w	#$100,d0
	jsr	(ActorBookmark_SetDelay).l
	jsr	(ActorBookmark).l

loc_108B8:
	clr.b	7(a0)
	move.w	#$24,d0
	jsr	(ActorBookmark_SetDelay).l
	jsr	(ActorBookmark).l
	move.w	#$101,(word_FF1124).l
	jsr	(ActorBookmark).l
	bsr.w	sub_10BF8
	clr.b	(bytecode_disabled).l
	clr.b	bytecode_flag
	addq.b	#1,stage
	cmpi.b	#$12,stage
	bcc.w	loc_10904
	move.b	#1,bytecode_flag

loc_10904:
	jmp	(ActorDeleteSelf).l

; =============== S U B	R O U T	I N E =====================================================


sub_1090A:
	clr.w	d0
	move.b	stage,d0
	lea	(byte_1098C).l,a1
	clr.w	d1
	move.b	(a1,d0.w),d1
	bmi.w	locret_10938
	lsl.w	#2,d1
	lea	(off_1099E).l,a1
	movea.l	(a1,d1.w),a2
	movem.l	a0,-(sp)
	jsr	(a2)
	movem.l	(sp)+,a0

locret_10938:
	rts
; End of function sub_1090A


; =============== S U B	R O U T	I N E =====================================================


sub_1093A:
	cmpi.b	#$10,opponent
	bcc.w	locret_10958
	bsr.w	sub_104F2
	cmpi.b	#4,opponent
	beq.s	locret_10958
	bsr.w	sub_104B0

locret_10958:
	rts
; End of function sub_1093A


; =============== S U B	R O U T	I N E =====================================================


sub_1095A:
	cmpi.b	#$10,opponent
	bcc.w	loc_1097A
	jsr	(sub_604E).l
	cmpi.b	#4,opponent
	bne.s	loc_1097A
	bsr.w	sub_104B0

loc_1097A:
	cmpi.b	#$C,opponent
	beq.s	loc_10986
	rts
; -----------------------------------------------------------------------------------------

loc_10986:
	jmp	(InitPaletteSafe).l
; End of function sub_1095A

; -----------------------------------------------------------------------------------------
byte_1098C
	dc.b	0
	dc.b	$FF
	dc.b	$FF
	dc.b	$FF
	dc.b	$FF
	dc.b	$FF
	dc.b	$FF
	dc.b	$FF
	dc.b	$FF
	dc.b	$FF
	dc.b	$FF
	dc.b	$FF
	dc.b	$FF
	dc.b	$FF
	dc.b	$FF
	dc.b	$FF
	dc.b	1
	dc.b	2
off_1099E
	dc.l	locret_109AA
	dc.l	locret_109AA
	dc.l	loc_109AC
; -----------------------------------------------------------------------------------------

locret_109AA:
	rts
; -----------------------------------------------------------------------------------------

loc_109AC:
	moveq	#$13,d0
	bsr.w	sub_10DB2
	lea	(loc_10AC8).l,a1
	jsr	FindActorSlot
	movem.l	d2/a0,-(sp)
	lea	(ArtPuyo_StageSprites).l,a0
	move.w	#$2000,d0
	
	if PuyoCompression=0
	jsr	PuyoDec
	else
	DISABLE_INTS
	jsr	NemDec
	ENABLE_INTS
	endc
	
	lea	(ArtNem_HasBeanShadow).l,a0
	move.w	#$400,d0
	DISABLE_INTS
	jsr	NemDec
	ENABLE_INTS
	movem.l	(sp)+,d2/a0
	bsr.w	loc_105F6
	lea	Palettes,a2
	adda.l	#(Pal_32F6-Palettes),a2
	move.b	#2,d0
	jsr	LoadPalette
	lea	(loc_10A14).l,a1
	jmp	FindActorSlotQuick
; -----------------------------------------------------------------------------------------

loc_10A14:
	move.l	#unk_10ABA,$32(a0)
	move.w	#$80,d0
	jsr	(ActorBookmark_SetDelay).l
	jsr	(ActorBookmark).l
	move.b	#$95,6(a0)
	move.b	#8,8(a0)
	move.b	#0,9(a0)
	move.w	#$120,$A(a0)
	move.w	#$FF90,$E(a0)
	move.w	#$FFFF,$20(a0)
	move.w	#$1000,$1C(a0)
	jsr	(ActorBookmark).l
	move.w	$1E(a0),$E(a0)
	jsr	(ActorMove).l
	jsr	(ActorAnimate).l
	move.w	$E(a0),$1E(a0)
	addi.w	#-$70,$E(a0)
	cmpi.w	#$C0,$1E(a0)
	bcc.w	loc_10A86
	rts
; -----------------------------------------------------------------------------------------

loc_10A86:
	move.l	#unk_10AA4,$32(a0)
	move.b	#$45,d0
	jsr	PlaySound_ChkSamp
	jsr	(ActorBookmark).l
	jmp	(ActorAnimate).l
; -----------------------------------------------------------------------------------------
unk_10AA4
	dc.b	8
	dc.b	0
	dc.b	8
	dc.b	1
	dc.b	$C
	dc.b	2
	dc.b	8
	dc.b	1
	dc.b	8
	dc.b	0
	dc.b	8
	dc.b	3
	dc.b	$C
	dc.b	4
	dc.b	8
	dc.b	3
	dc.b	$FF
	dc.b	0
	dc.l	unk_10AA4
unk_10ABA
	dc.b	1
	dc.b	5
	dc.b	1
	dc.b	6
	dc.b	1
	dc.b	7
	dc.b	1
	dc.b	8
	dc.b	$FF
	dc.b	0
	dc.l	unk_10ABA
; -----------------------------------------------------------------------------------------

loc_10AC8:
	move.l	#unk_10B68,$32(a0)
	move.b	#8,8(a0)
	move.b	#$A,9(a0)
	move.w	#$110,$A(a0)
	move.w	#$54,$E(a0)
	move.w	#$B4,$26(a0)
	jsr	(ActorBookmark).l
	move.w	#$24,(palette_buffer+$72).l
	move.b	#3,d0
	lea	((palette_buffer+$60)).l,a2
	jsr	LoadPalette
	jsr	(ActorBookmark).l
	subq.w	#1,$26(a0)
	beq.s	loc_10B1A
	rts
; -----------------------------------------------------------------------------------------

loc_10B1A:
	move.b	#$80,6(a0)
	jsr	(ActorBookmark).l
	moveq	#0,d3
	move.b	9(a0),d3
	jsr	(ActorAnimate).l
	cmp.b	9(a0),d3
	beq.s	locret_10B58
	subi.b	#$A,d3
	add.w	d3,d3
	move.w	word_10B5A(pc,d3.w),d0
	move.w	d0,(palette_buffer+$72).l
	move.b	#3,d0
	lea	((palette_buffer+$60)).l,a2
	jsr	LoadPalette

locret_10B58:
	rts
; -----------------------------------------------------------------------------------------
word_10B5A
	dc.w	$26
	dc.b	0
	dc.b	$48
	dc.b	0
	dc.b	$4A
	dc.b	0
	dc.b	$6A
	dc.b	0
	dc.b	$6C
	dc.b	0
	dc.b	$8C
	dc.b	0
	dc.b	$8E
unk_10B68
	dc.b	3
	dc.b	$A
	dc.b	3
	dc.b	$B
	dc.b	3
	dc.b	$C
	dc.b	3
	dc.b	$D
	dc.b	3
	dc.b	$E
	dc.b	3
	dc.b	$F
	dc.b	3
	dc.b	$10
	dc.b	3
	dc.b	$11
	dc.b	$FE
	dc.b	0
; -----------------------------------------------------------------------------------------
	clr.w	d0
	move.b	stage,d0
	lea	(byte_10BDA).l,a1
	clr.w	d1
	move.b	(a1,d0.w),d1
	bra.w	locret_10BD8
; -----------------------------------------------------------------------------------------
	move.b	#0,d0
	move.b	#0,d1
	lea	Palettes,a2
	adda.l	#(Pal_RedYellowPuyos-Palettes),a2
	cmpi.b	#$11,stage
	beq.w	loc_10BB8
	adda.l	#$60,a2

loc_10BB8:
	jsr	(FadeToPalette).l
	move.b	#2,d0
	move.b	#0,d1
	lea	Palettes,a2
	adda.l	#(Pal_2856-Palettes),a2
	jsr	(FadeToPalette).l

locret_10BD8:
	rts
; -----------------------------------------------------------------------------------------
byte_10BDA
	dc.b	0
	dc.b	$FF
	dc.b	$FF
	dc.b	$FF
	dc.b	$FF
	dc.b	$FF
	dc.b	$FF
	dc.b	$FF
	dc.b	$FF
	dc.b	$FF
	dc.b	$FF
	dc.b	$FF
	dc.b	$FF
	dc.b	$FF
	dc.b	$FF
	dc.b	$FF
	dc.b	1
	dc.b	2
	dc.b	0
	dc.b	0
	dc.b	$B1
	dc.b	2
	dc.b	0
	dc.b	0
	dc.b	$B1
	dc.b	$52
	dc.b	0
	dc.b	0
	dc.b	$B1
	dc.b	2

; =============== S U B	R O U T	I N E =====================================================


sub_10BF8:
	clr.w	d0
	move.b	stage,d0
	lea	(unk_10C78).l,a1
	tst.b	(a1,d0.w)
	beq.w	loc_10C38
	jsr	(InitPaletteSafe).l
	movem.l	a0,-(sp)
	jsr	(InitActors).l
	movem.l	(sp)+,a0
	jsr	(ClearScroll).l
	move.w	#$FF20,(vscroll_buffer).l
	move.w	#$FF60,(vscroll_buffer+2).l

loc_10C38:
	cmpi.b	#$C,opponent
	beq.s	loc_10C56
	cmpi.b	#$11,stage
	bge.s	locret_10C76
	moveq	#$24,d0
	jsr	QueuePlaneCmdList
	bra.s	loc_10C5E
; -----------------------------------------------------------------------------------------

loc_10C56:
	moveq	#0,d0
	jsr	QueuePlaneCmdList

loc_10C5E:
	move.b	stage,d0
	cmpi.b	#$F,d0
	bne.s	locret_10C76
	lea	(loc_10C8A).l,a1
	jmp	FindActorSlot
; -----------------------------------------------------------------------------------------

locret_10C76:
	rts
; End of function sub_10BF8

; -----------------------------------------------------------------------------------------
unk_10C78
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	$FF
	dc.b	$FF
	dc.b	0
; -----------------------------------------------------------------------------------------

loc_10C8A:
	movem.l	a0,-(sp)
	movea.l	(dword_FF112C).l,a0
	jsr	(ActorDeleteSelf).l
	moveq	#0,d0
	lea	(hscroll_buffer).l,a1
	move.w	#$A0,d1

loc_10CA6:
	move.l	d0,(a1)+
	dbf	d1,loc_10CA6
	jsr	QueuePlaneCmdList
	jsr	(InitPaletteSafe).l
	movem.l	(sp)+,a0
	jsr	(ActorBookmark).l
	movem.l	a0,-(sp)
	jsr	(sub_F8B6).l
	movem.l	(sp)+,a0
	moveq	#4,d0
	jsr	(ActorBookmark_SetDelay).l
	jsr	(ActorBookmark).l
	movem.l	a0,-(sp)
	move.b	#1,(use_lair_background).l
	jsr	(LoadEndingBGArt).l
	movem.l	(sp)+,a0
	jsr	(ActorBookmark).l
	movem.l	a0,-(sp)
	jsr	(sub_F878).l
	movem.l	(sp)+,a0
	jsr	(ActorBookmark).l
	movem.l	a0,-(sp)
	jsr	(sub_F832).l
	movem.l	(sp)+,a0
	jsr	(ActorBookmark).l
	movem.l	a0,-(sp)
	jsr	(sub_10D8C).l
	movem.l	(sp)+,a0
	jsr	(ActorBookmark).l
	move.b	#0,d0
	move.b	#0,d1
	lea	(Pal_RobotnikLair).l,a2
	jsr	(FadeToPalette).l
	move.b	#1,d0
	move.b	#0,d1
	lea	(Pal_Grounder).l,a2
	jsr	(FadeToPalette).l
	move.b	#2,d0
	move.b	#0,d1
	lea	(Pal_2FB6).l,a2
	jsr	(FadeToPalette).l
	move.b	#3,d0
	move.b	#0,d1
	lea	(Pal_Robotnik).l,a2
	jsr	(FadeToPalette).l
	jmp	(ActorDeleteSelf).l

; =============== S U B	R O U T	I N E =====================================================


sub_10D8C:
	movea.w	#$D688,a1
	move.w	#$C400,d0
	move.w	#9,d1
	move.w	#6,d2
	movea.l	#byte_48712,a0
	DISABLE_INTS
	jsr	(EniDec).l
	ENABLE_INTS
	rts
; End of function sub_10D8C


; =============== S U B	R O U T	I N E =====================================================


sub_10DB2:
	lsl.w	#2,d0
	lea	(RoleCallText).l,a1
	movea.l	(a1,d0.w),a2
	move.w	#$9100,d0
	swap	d0
	or.l	(a2),d0
	jsr	QueuePlaneCmd
	lea	(sub_10DF2).l,a1
	jsr	FindActorSlotQuick
	bcc.w	loc_10DDE
	rts
; -----------------------------------------------------------------------------------------

loc_10DDE:
	move.w	(a2)+,$28(a1)
	move.w	(a2)+,d0
	addi.w	#$82,d0
	move.w	d0,$2A(a1)
	move.l	a2,$2E(a1)
	rts
; End of function sub_10DB2


; =============== S U B	R O U T	I N E =====================================================


sub_10DF2:
	addq.b	#1,$26(a0)
	move.b	$26(a0),d0
	andi.b	#7,d0
	beq.w	loc_10E04
	rts
; -----------------------------------------------------------------------------------------

loc_10E04:
	bsr.w	sub_10E18
	subq.w	#1,$28(a0)
	beq.w	loc_10E12
	rts
; -----------------------------------------------------------------------------------------

loc_10E12:
	jmp	(ActorDeleteSelf).l
; End of function sub_10DF2


; =============== S U B	R O U T	I N E =====================================================


sub_10E18:
	clr.w	d1
	movea.l	$2E(a0),a1
	move.b	(a1)+,d1
	move.l	a1,$2E(a0)
	lea	(ActstageCutscene_CharConv).l,a1
	move.w	#$E500,d0
	move.b	(a1,d1.w),d0
	move.w	$2A(a0),d5
	DISABLE_INTS
	jsr	SetVRAMWrite
	addi.w	#$80,d5
	move.w	d0,VDP_DATA
	ENABLE_INTS
	addq.w	#2,$2A(a0)
	move.b	#$69,d0
	jmp	PlaySound_ChkSamp
; End of function sub_10E18


; =============== S U B	R O U T	I N E =====================================================


LoadRoleCallFont:
	lea	ArtNem_MainFont,a0
	lea	hblank_buffer_1,a4
	jsr	NemDecRAM
	move.w	#$45F,d0
	move.l	#$11111111,d1

loc_10E78:
	or.l	d1,(a4)+
	dbf	d0,loc_10E78
	lea	dma_queue,a0
	adda.w	dma_slot,a0
	move.w	#$8F02,(a0)+
	move.l	#$940893C0,(a0)+
	move.l	#$96A89500,(a0)+
	move.w	#$977F,(a0)+
	move.l	#$60000082,(a0)
	addi.w	#$10,dma_slot
	rts
; End of function LoadRoleCallFont

; -----------------------------------------------------------------------------------------

ROLE_TEXT macro vram, text

	dc.w	strlen(\text)
	dc.w	\vram
	dc.b	\text
	dc.b	$FF
	if (*)&1
		ALIGN	2
	endif

	endm

; -----------------------------------------------------------------------------------------

RoleCallText:
	dc.l	.Arms
	dc.l	.Arms
	dc.l	.Arms
	dc.l	.Arms
	dc.l	.Arms
	dc.l	.Frankly
	dc.l	.Humpty
	dc.l	.Coconuts
	dc.l	.DavySprocket
	dc.l	.Skweel
	dc.l	.Dynamight
	dc.l	.Grounder
	dc.l	.Spike
	dc.l	.SirFfuzzyLogik
	dc.l	.DragonBreath
	dc.l	.Scratch
	dc.l	.DrRobotnik
	dc.l	.HasBean
	dc.l	.Cast
	dc.l	.And
.Cast:
	ROLE_TEXT $D724, "CAST"
.And:
	ROLE_TEXT $D720, "AND..."
.Arms:
	ROLE_TEXT $D724, "ARMS"
.Frankly:
	ROLE_TEXT $D722, "FRANKLY"
.Humpty:
	ROLE_TEXT $D722, "HUMPTY"
.Coconuts:
	ROLE_TEXT $D722, "COCONUTS"
.DavySprocket:
	ROLE_TEXT $D722, "DAVY SPROCKET"
.Dynamight:
	ROLE_TEXT $D722, "DYNAMIGHT"
.Skweel:
	ROLE_TEXT $D722, "SKWEEL"
.Grounder:
	ROLE_TEXT $D722, "GROUNDER"
.Spike:
	ROLE_TEXT $D722, "SPIKE"
.SirFfuzzyLogik:
	ROLE_TEXT $D722, "SIR FFUZZY-LOGIK"
.DragonBreath:
	ROLE_TEXT $D722, "DRAGON BREATH"
.Scratch:
	ROLE_TEXT $D722, "SCRATCH"
.DrRobotnik:
	ROLE_TEXT $D722, "DR. ROBOTNIK"
.HasBean:
	ROLE_TEXT $D71E, "HAS BEAN"

; -----------------------------------------------------------------------------------------
; stage cutscene actor
; -----------------------------------------------------------------------------------------

liScript	EQU	$32

; -----------------------------------------------------------------------------------------

ActstageCutscene:
	move.l	a0,-(sp)

	lea	ArtNem_MainFont,a0
	lea	hblank_buffer_1,a4
	jsr	NemDecRAM
	move.w	#$45F,d0
	move.l	#$11111111,d1

loc_10FFA:
	or.l	d1,(a4)+
	dbf	d0,loc_10FFA

	QUEUE_DMA hblank_buffer_1, 0, $1180, VRAM

	movea.l	(sp)+,a0

	clr.w	d0
	move.b	opponent,d0
	lsl.w	#2,d0
	lea	OpponentDialogue,a1
	move.l	(a1,d0.w),liScript(a0)

	jsr	(ActorBookmark).l

; -----------------------------------------------------------------------------------------

ActstageCutscene_Main:
	tst.w	(disallow_skipping).l
	bne.s	loc_11062
	jsr	(GetCtrlData).l
	andi.b	#$F0,d0
	bne.w	ActstageCutscene_End

loc_11062:
	tst.w	aField26(a0)
	beq.w	loc_11070
	subq.w	#1,aField26(a0)
	rts

; -----------------------------------------------------------------------------------------

loc_11070:
	movea.l	liScript(a0),a2
	clr.w	d0
	move.b	(a2)+,d0
	move.l	a2,liScript(a0)
	or.b	d0,d0
	bpl.w	ActstageCutscene_PrintChar
	andi.b	#$7F,d0
	lsl.w	#2,d0
	movea.l	off_11096(pc,d0.w),a3
	clr.w	d0
	move.b	(a2)+,d0
	move.l	a2,liScript(a0)
	jmp	(a3)

; -----------------------------------------------------------------------------------------

off_11096:
	dc.l	ActstageCutscene_End
	dc.l	ActstageCutscene_SetupTextbox
	dc.l	ActstageCutscene_CloseTextbox
	dc.l	ActstageCutscene_Delay
	dc.l	ActstageCutscene_ArleAnim
	dc.l	ActstageCutscene_EnemyAnim
	dc.l	ActstageCutscene_LineBreak
	dc.l	ActstageCutscene_ClearTextbox
	dc.l	0
	dc.l	ActstageCutscene_SilentSpace
	dc.l	PlaySound_ChkSamp

; -----------------------------------------------------------------------------------------

ActstageCutscene_End:
	bsr.w	sub_11192
	jsr	(ActorBookmark).l
	cmpi.b	#$10,opponent
	bne.s	loc_110E4
	move.b	#0,opponent
	jmp	(ActorDeleteSelf).l

; -----------------------------------------------------------------------------------------

loc_110E4:
	clr.b	(bytecode_disabled).l
	jmp	(ActorDeleteSelf).l


; =============== S U B	R O U T	I N E =====================================================


ActstageCutscene_LineBreak:
	subq.l	#1,liScript(a0)

loc_110F4:
	clr.w	aX(a0)
	addq.w	#1,aX+2(a0)
	move.w	aX+2(a0),d0
	cmp.w	aY+2(a0),d0
	bcs.w	locret_1110C
	clr.w	aX+2(a0)

locret_1110C:
	rts
; END OF FUNCTION CHUNK	FOR ActstageCutscene_SilentSpace

; =============== S U B	R O U T	I N E =====================================================


ActstageCutscene_ClearTextbox:
	subq.l	#1,liScript(a0)
	clr.w	$A(a0)
	clr.w	$C(a0)
	bsr.w	ActstageCutscene_GetTextboxPosSize
	ori.w	#$8E00,d0
	swap	d0
	jmp	QueuePlaneCmd
; End of function ActstageCutscene_ClearTextbox

; -----------------------------------------------------------------------------------------

ActstageCutscene_SetupTextbox:
	move.w	d0,d1
	andi.b	#$1F,d0
	lsr.b	#5,d1
	andi.b	#7,d1
	move.w	d0,aY(a0)
	move.w	d1,aY+2(a0)
	move.w	#2,aXVel+2(a0)
	move.b	(a2)+,aXVel(a0)
	move.b	(a2)+,aXVel+1(a0)
	move.l	a2,liScript(a0)
	clr.w	aX(a0)
	clr.w	aX+2(a0)
	bsr.w	ActstageCutscene_GetTextboxPosSize
	cmpi.b	#$C,opponent
	beq.s	loc_11170
	cmpi.b	#$10,opponent
	bne.s	loc_11176

loc_11170:
	ori.w	#$9F00,d0
	bra.s	loc_1117A
; -----------------------------------------------------------------------------------------

loc_11176:
	ori.w	#$8C00,d0

loc_1117A:
	swap	d0
	jsr	QueuePlaneCmd
	bsr.w	sub_112D8
	move.b	#$FF,7(a0)
	rts
; -----------------------------------------------------------------------------------------

ActstageCutscene_CloseTextbox:
	subq.l	#1,liScript(a0)

; =============== S U B	R O U T	I N E =====================================================


sub_11192:
	tst.b	7(a0)
	bne.w	loc_1119C
	rts
; -----------------------------------------------------------------------------------------

loc_1119C:
	clr.b	7(a0)
	bsr.w	ActstageCutscene_GetTextboxPosSize
	ori.w	#$8D00,d0
	swap	d0
	jmp	QueuePlaneCmd
; End of function sub_11192


; =============== S U B	R O U T	I N E =====================================================


ActstageCutscene_GetTextboxPosSize:
	move.w	aXVel(a0),d0
	swap	d0
	clr.w	d0
	move.w	aY+2(a0),d0
	lsl.w	#5,d0
	or.w	aY(a0),d0
	rts
; End of function ActstageCutscene_GetTextboxPosSize


; =============== S U B	R O U T	I N E =====================================================


ActstageCutscene_SilentSpace:
	subq.l	#1,liScript(a0)
	bra.w	loc_11246
; -----------------------------------------------------------------------------------------

ActstageCutscene_Delay:
	mulu.w	#$A,d0
	move.w	d0,$26(a0)
	rts
; -----------------------------------------------------------------------------------------

ActstageCutscene_ArleAnim:
	ori.w	#$FF00,d0
	move.w	d0,(word_FF198E).l
	rts
; -----------------------------------------------------------------------------------------

ActstageCutscene_EnemyAnim:
	ori.w	#$FF00,d0
	move.w	d0,(word_FF1990).l
	rts
; -----------------------------------------------------------------------------------------

ActstageCutscene_PrintChar:
	move.b	ActstageCutscene_CharConv(pc,d0.w),d0
	move.w	$A(a0),d1
	move.w	$C(a0),d2
	add.w	d2,d2
	addq.w	#1,d1
	addq.w	#1,d2
	lsl.w	#1,d1
	lsl.w	#7,d2
	move.w	$12(a0),d5
	add.w	d1,d5
	add.w	d2,d5
	ori.w	#$E000,d0
	DISABLE_INTS
	jsr	SetVRAMWrite
	move.w	d0,VDP_DATA
	ENABLE_INTS
	move.w	#1,$26(a0)
	addq.b	#1,(byte_FF1128).l
	move.b	(byte_FF1128).l,d0
	andi.b	#1,d0
	bne.s	loc_11246
	move.b	#$69,d0
	jsr	PlaySound_ChkSamp

loc_11246:
	addq.w	#1,$A(a0)
	move.w	$A(a0),d0
	cmp.w	$E(a0),d0
	bcc.w	loc_110F4
	rts
; End of function ActstageCutscene_SilentSpace

; -----------------------------------------------------------------------------------------
ActstageCutscene_CharConv
	dc.b	$11
	dc.b	$11
	dc.b	$11
	dc.b	$11
	dc.b	$11
	dc.b	$11
	dc.b	$11
	dc.b	$11
	dc.b	$11
	dc.b	$11
	dc.b	$11
	dc.b	$11
	dc.b	$11
	dc.b	$11
	dc.b	$11
	dc.b	$11
	dc.b	$11
	dc.b	$11
	dc.b	$11
	dc.b	$11
	dc.b	$11
	dc.b	$11
	dc.b	$11
	dc.b	$11
	dc.b	$11
	dc.b	$11
	dc.b	$11
	dc.b	$11
	dc.b	$11
	dc.b	$11
	dc.b	$11
	dc.b	$11
	dc.b	$11
	dc.b	7
	dc.b	$11
	dc.b	$36
	dc.b	$37
	dc.b	$11
	dc.b	$11
	dc.b	9
	dc.b	$C
	dc.b	$D
	dc.b	$E
	dc.b	$F
	dc.b	1
	dc.b	8
	dc.b	2
	dc.b	$11
	dc.b	$12
	dc.b	$13
	dc.b	$14
	dc.b	$15
	dc.b	$16
	dc.b	$17
	dc.b	$18
	dc.b	$19
	dc.b	$1A
	dc.b	$1B
	dc.b	4
	dc.b	5
	dc.b	$11
	dc.b	$11
	dc.b	$11
	dc.b	6
	dc.b	$B
	dc.b	$1C
	dc.b	$1D
	dc.b	$1E
	dc.b	$1F
	dc.b	$20
	dc.b	$21
	dc.b	$22
	dc.b	$23
	dc.b	$24
	dc.b	$25
	dc.b	$26
	dc.b	$27
	dc.b	$28
	dc.b	$29
	dc.b	$2A
	dc.b	$2B
	dc.b	$2C
	dc.b	$2D
	dc.b	$2E
	dc.b	$2F
	dc.b	$30
	dc.b	$31
	dc.b	$32
	dc.b	$33
	dc.b	$34
	dc.b	$35
	dc.b	$11
	dc.b	$11
	dc.b	$11
	dc.b	$11
	dc.b	$11
	dc.b	$11
	dc.b	$38
	dc.b	$39
	dc.b	$3A
	dc.b	$3B
	dc.b	$3C
	dc.b	$3D
	dc.b	$3E
	dc.b	$3F
	dc.b	$40
	dc.b	$41
	dc.b	$42
	dc.b	$43
	dc.b	$44
	dc.b	$45
	dc.b	$46
	dc.b	$47
	dc.b	$48
	dc.b	$49
	dc.b	$4A
	dc.b	$4B
	dc.b	$4C
	dc.b	$4D
	dc.b	$4E
	dc.b	$4F
	dc.b	$50
	dc.b	$51
	dc.b	$11
	dc.b	$C
	dc.b	$D
	dc.b	$E
	dc.b	$F

; =============== S U B	R O U T	I N E =====================================================


sub_112D8:
	move.w	$12(a0),d0
	move.w	d0,d1
	lsr.w	#1,d0
	andi.w	#$3F,d0
	lsr.w	#7,d1
	andi.w	#$3F,d1
	move.w	$E(a0),d2
	addq.w	#1,d2
	lsl.w	#3,d2
	move.w	$10(a0),d3
	lsl.w	#4,d3
	lsl.w	#3,d0
	addi.w	#$80,d0
	lsl.w	#3,d1
	addi.w	#$80,d1
	add.w	d0,d2
	add.w	d1,d3
	move.w	#3,d5

loc_1130C:
	lea	(loc_113D8).l,a1
	jsr	FindActorSlotQuick
	bcs.w	loc_11368
	move.l	a0,$2E(a1)
	move.b	#$80,6(a1)
	move.b	#$20,8(a1)
	move.b	d5,9(a1)
	cmpi.b	#$C,opponent
	beq.s	loc_11344
	cmpi.b	#$10,opponent
	bne.s	loc_11348

loc_11344:
	addq.b	#5,9(a1)

loc_11348:
	move.w	d0,$A(a1)
	btst	#0,d5
	beq.w	loc_11358
	move.w	d2,$A(a1)

loc_11358:
	move.w	d1,$E(a1)
	btst	#1,d5
	beq.w	loc_11368
	move.w	d3,$E(a1)

loc_11368:
	dbf	d5,loc_1130C
	lea	(sub_113B8).l,a1
	jsr	FindActorSlotQuick
	bcc.w	loc_1137E
	rts
; -----------------------------------------------------------------------------------------

loc_1137E:
	move.w	$14(a0),$14(a1)
	move.l	a0,$2E(a1)
	move.b	#$20,8(a1)
	move.b	#4,9(a1)
	cmpi.b	#$C,opponent
	beq.s	loc_113A8
	cmpi.b	#$10,opponent
	bne.s	loc_113AC

loc_113A8:
	addq.b	#5,9(a1)

loc_113AC:
	move.w	d3,$E(a1)
	move.b	#$80,6(a1)
	rts
; End of function sub_112D8


; =============== S U B	R O U T	I N E =====================================================


sub_113B8:
	move.w	$14(a0),d0
	lea	(word_FF1992).l,a1
	move.w	(a1,d0.w),$A(a0)
	clr.w	d0
	move.b	opponent,d0
	move.b	byte_113EC(pc,d0.w),d0
	add.w	d0,$A(a0)

loc_113D8:
	movea.l	$2E(a0),a1
	tst.b	7(a1)
	beq.w	loc_113E6
	rts
; -----------------------------------------------------------------------------------------

loc_113E6:
	jmp	(ActorDeleteSelf).l
; End of function sub_113B8

; -----------------------------------------------------------------------------------------
byte_113EC
	dc.b	0
	dc.b	$28
	dc.b	$28
	dc.b	$38
	dc.b	0
	dc.b	$28
	dc.b	$10
	dc.b	0
	dc.b	$28
	dc.b	$28
	dc.b	$28
	dc.b	0
	dc.b	$58
	dc.b	0
	dc.b	$30
	dc.b	8
	dc.b	0
	dc.b	0
OpponentDialogue:
	dc.l	CoconutsDialogue
	dc.l	FranklyDialogue
	dc.l	DynamightDialogue
	dc.l	ArmsDialogue
	dc.l	CoconutsDialogue
	dc.l	GrounderDialogue
	dc.l	DavyDialogue
	dc.l	CoconutsDialogue
	dc.l	SpikeDialogue
	dc.l	SirFfuzzyDialogue
	dc.l	DragonDialogue
	dc.l	ScratchDialogue
	dc.l	RobotnikDialogue
	dc.l	CoconutsDialogue
	dc.l	HumptyDialogue
	dc.l	SkweelDialogue
	dc.l	GameIntroDialogue

HumptyDialogue:
	CUTSCENE_ENEMY_ANIM 2
	CUTSCENE_DELAY 2
	CUTSCENE_ENEMY_ANIM 0
	CUTSCENE_DELAY 8
	CUTSCENE_TEXTBOX 20, 3, $D712
	CUTSCENE_ENEMY_ANIM 1

	CUTSCENE_TEXT "Gracious!%n"
	CUTSCENE_TEXT "You're here already."
	CUTSCENE_TEXT "I'm shell shocked!"

	CUTSCENE_ENEMY_ANIM 0
	CUTSCENE_DELAY 12
	CUTSCENE_TEXT_CLOSE
	CUTSCENE_DELAY 4
	CUTSCENE_TEXTBOX 27, 3, $D70C
	CUTSCENE_ENEMY_ANIM 1

	CUTSCENE_TEXT "But please eggscuse me if I"
	CUTSCENE_TEXT "scramble your chances of%n"
	CUTSCENE_TEXT "seeing Dr. R."
	
	CUTSCENE_ENEMY_ANIM 0
	CUTSCENE_DELAY 12
	CUTSCENE_TEXT_CLOSE
	CUTSCENE_END

SkweelDialogue:
	CUTSCENE_DELAY 2
	CUTSCENE_ENEMY_ANIM $82
	CUTSCENE_ENEMY_ANIM 0
	CUTSCENE_DELAY 4
	CUTSCENE_TEXTBOX 25, 2, $D70C

	CUTSCENE_TEXT "I've got more sizzle than"
	CUTSCENE_TEXT "a rasher of bacon."

	CUTSCENE_DELAY 10
	CUTSCENE_TEXT_CLOSE
	CUTSCENE_DELAY 6
	CUTSCENE_TEXTBOX 23, 3, $D70C

	CUTSCENE_TEXT "I'm hungry and it ain't"
	CUTSCENE_TEXT "meals on wheels%n"
	CUTSCENE_TEXT "I'm after - it's you."
	
	CUTSCENE_DELAY 10
	CUTSCENE_TEXT_CLOSE
	CUTSCENE_END

FranklyDialogue:
	CUTSCENE_ENEMY_ANIM 0
	CUTSCENE_DELAY 6
	CUTSCENE_TEXTBOX 26, 3, $D688
	CUTSCENE_ENEMY_ANIM 1
	CUTSCENE_DELAY 2
	CUTSCENE_ENEMY_ANIM 2

	CUTSCENE_TEXT "Arms is always too wrapped"
	CUTSCENE_TEXT "up in himself to do%n"
	CUTSCENE_TEXT "anything useful."

	CUTSCENE_ENEMY_ANIM 3
	CUTSCENE_DELAY 3
	CUTSCENE_ENEMY_ANIM 0
	CUTSCENE_DELAY 6
	CUTSCENE_TEXT_CLOSE
	CUTSCENE_DELAY 1
	CUTSCENE_TEXTBOX 26, 3, $D688
	CUTSCENE_ENEMY_ANIM 1
	CUTSCENE_DELAY 2
	CUTSCENE_ENEMY_ANIM 2

	CUTSCENE_TEXT "I'm a bright spark though and "
	CUTSCENE_TEXT "I reckon I know how to"
	CUTSCENE_TEXT "beat you."

	CUTSCENE_ENEMY_ANIM 3
	CUTSCENE_DELAY 3
	CUTSCENE_ENEMY_ANIM 0
	CUTSCENE_DELAY 6
	CUTSCENE_TEXT_CLOSE
	CUTSCENE_END

DynamightDialogue:
	CUTSCENE_ENEMY_ANIM 0
	CUTSCENE_DELAY 2
	CUTSCENE_ENEMY_ANIM 2
	CUTSCENE_DELAY 10
	CUTSCENE_TEXTBOX 18, 1, $D810
	CUTSCENE_ENEMY_ANIM 1

	CUTSCENE_TEXT "Well blow me away!"

	CUTSCENE_DELAY 2
	CUTSCENE_ENEMY_ANIM 0
	CUTSCENE_DELAY 4
	CUTSCENE_TEXT_CLOSE
	CUTSCENE_ENEMY_ANIM 3
	CUTSCENE_DELAY 12
	CUTSCENE_TEXTBOX 22, 2, $D78C
	CUTSCENE_ENEMY_ANIM 1

	CUTSCENE_TEXT "As if Dr. R hasn't had"
	CUTSCENE_TEXT "enough stick already."
	
	CUTSCENE_ENEMY_ANIM 0
	CUTSCENE_DELAY 8
	CUTSCENE_TEXT_CLOSE
	CUTSCENE_ENEMY_ANIM 2
	CUTSCENE_DELAY 8
	CUTSCENE_TEXTBOX 22, 2, $D78C
	CUTSCENE_ENEMY_ANIM 1

	CUTSCENE_TEXT "Here I am to provide a"
	CUTSCENE_TEXT "fireworks display."
	
	CUTSCENE_DELAY 2
	CUTSCENE_ENEMY_ANIM 0
	CUTSCENE_DELAY 4
	CUTSCENE_ENEMY_ANIM 2
	CUTSCENE_TEXT_CLOSE
	CUTSCENE_END

ArmsDialogue:
	CUTSCENE_DELAY 2
	CUTSCENE_ENEMY_ANIM 0
	CUTSCENE_TEXTBOX 28, 2, $D788

	CUTSCENE_TEXT "Beans, beans let me give you"
	CUTSCENE_TEXT "a hand - or two."
	
	CUTSCENE_DELAY 10
	CUTSCENE_TEXT_CLOSE
	CUTSCENE_DELAY 4
	CUTSCENE_TEXTBOX 28, 2, $D788

	CUTSCENE_TEXT "I've to prepare Dr. Robotnik"
	CUTSCENE_TEXT "a beautiful bean feast."

	CUTSCENE_DELAY 6
	CUTSCENE_TEXT_CLOSE
	CUTSCENE_DELAY 4
	CUTSCENE_TEXTBOX 25, 1, $D88C

	CUTSCENE_TEXT "Come to Arms my beauties."
	
	CUTSCENE_DELAY 8
	CUTSCENE_TEXT_CLOSE
	CUTSCENE_END

GrounderDialogue:
	CUTSCENE_DELAY 2
	CUTSCENE_ENEMY_ANIM $81
	CUTSCENE_DELAY 4
	CUTSCENE_TEXTBOX 12, 1, $D894
	CUTSCENE_ENEMY_ANIM 1

	CUTSCENE_TEXT "I'm Grounder"

	CUTSCENE_DELAY 8
	CUTSCENE_TEXT_CLOSE
	CUTSCENE_ENEMY_ANIM 0
	CUTSCENE_DELAY 6
	CUTSCENE_TEXTBOX 26, 3, $D78C
	CUTSCENE_ENEMY_ANIM 1

	CUTSCENE_TEXT "but you can call me SAM - "
	CUTSCENE_TEXT "'cos I'm like a Surface to"
	CUTSCENE_TEXT "Air Missile"

	CUTSCENE_DELAY 12
	CUTSCENE_TEXT_CLOSE
	CUTSCENE_ENEMY_ANIM 0
	CUTSCENE_DELAY 6
	CUTSCENE_TEXTBOX 26, 2, $D80C
	CUTSCENE_ENEMY_ANIM 1

	CUTSCENE_TEXT "and I'm gonna have you for"
	CUTSCENE_TEXT "launch."
	
	CUTSCENE_DELAY 12
	CUTSCENE_ENEMY_ANIM 0
	CUTSCENE_TEXT_CLOSE
	CUTSCENE_END

DavyDialogue:
	CUTSCENE_DELAY 2
	CUTSCENE_ENEMY_ANIM 0
	CUTSCENE_DELAY 2
	CUTSCENE_TEXTBOX 26, 2, $D708

	CUTSCENE_TEXT "A squirt like you has been"
	CUTSCENE_TEXT "reuniting too many beans."
	
	CUTSCENE_ENEMY_ANIM 1
	CUTSCENE_DELAY 6
	CUTSCENE_ENEMY_ANIM 2
	CUTSCENE_TEXT_CLOSE
	CUTSCENE_DELAY 2
	CUTSCENE_ENEMY_ANIM 3
	CUTSCENE_DELAY 8
	CUTSCENE_TEXTBOX 28, 2, $D708
	CUTSCENE_ENEMY_ANIM 4

	CUTSCENE_TEXT "I reckon I'll have to%n"
	CUTSCENE_TEXT "pioneer some new techniques."
	
	CUTSCENE_DELAY 4
	CUTSCENE_ENEMY_ANIM 5
	CUTSCENE_DELAY 10
	CUTSCENE_TEXT_CLOSE
	CUTSCENE_END

CoconutsDialogue:
	CUTSCENE_DELAY 2
	CUTSCENE_ENEMY_ANIM $80
	CUTSCENE_TEXTBOX 22, 3, $D70E
	CUTSCENE_ENEMY_ANIM 2

	CUTSCENE_TEXT "I'm Coconuts%n"
	CUTSCENE_TEXT "and I'm Dr. Robotnik's"
	CUTSCENE_TEXT "favorite robot"

	CUTSCENE_DELAY 3
	CUTSCENE_ENEMY_ANIM 0
	CUTSCENE_DELAY 5
	CUTSCENE_TEXT_CLOSE
	CUTSCENE_ENEMY_ANIM 1
	CUTSCENE_DELAY 10
	CUTSCENE_ENEMY_ANIM 1
	CUTSCENE_DELAY 6
	CUTSCENE_TEXTBOX 27, 2, $D80A
	CUTSCENE_ENEMY_ANIM 2

	CUTSCENE_TEXT "because I'm going to finish"
	CUTSCENE_TEXT "you in a flash."

	CUTSCENE_DELAY 6
	CUTSCENE_ENEMY_ANIM 1
	CUTSCENE_DELAY 4
	CUTSCENE_TEXT_CLOSE
	CUTSCENE_END

SpikeDialogue:
	CUTSCENE_DELAY 4
	CUTSCENE_ENEMY_ANIM 0
	CUTSCENE_TEXTBOX 22, 2, $D70C

	CUTSCENE_TEXT "C'mon squirt,let's see"
	CUTSCENE_TEXT "what you're made of."
	
	CUTSCENE_DELAY 6
	CUTSCENE_ENEMY_ANIM 1
	CUTSCENE_DELAY 4
	CUTSCENE_TEXT_CLOSE
	CUTSCENE_DELAY 6
	CUTSCENE_ENEMY_ANIM 0
	CUTSCENE_TEXTBOX 25, 2, $D70C

	CUTSCENE_TEXT "Forget those rivet-brains"
	CUTSCENE_TEXT "you've seen."

	CUTSCENE_DELAY 4
	CUTSCENE_ENEMY_ANIM 1
	CUTSCENE_DELAY 6
	CUTSCENE_TEXT_CLOSE
	CUTSCENE_DELAY 4
	CUTSCENE_ENEMY_ANIM 0
	CUTSCENE_TEXTBOX 23, 2, $D70C

	CUTSCENE_TEXT "I'm Spike and I'm gonna"
	CUTSCENE_TEXT "stick it to ya!"
	
	CUTSCENE_DELAY 10
	CUTSCENE_TEXT_CLOSE
	CUTSCENE_END

	opt m+

SirFfuzzyDialogue:
	CUTSCENE_DELAY 2
	CUTSCENE_ENEMY_ANIM $85
	CUTSCENE_ENEMY_ANIM $8A
	CUTSCENE_ENEMY_ANIM 0
	CUTSCENE_TEXTBOX 21, 2, $D70C

	CUTSCENE_TEXT "Milord is troubled%n"
	CUTSCENE_TEXT "by thy success, Sire."

	CUTSCENE_DELAY 12
	CUTSCENE_TEXT_CLOSE
	CUTSCENE_DELAY 4
	CUTSCENE_TEXTBOX 22, 2, $D70C

	CUTSCENE_TEXT "But thou art destined "
	CUTSCENE_TEXT "to proceed no further."

	CUTSCENE_DELAY 12
	CUTSCENE_TEXT_CLOSE
	CUTSCENE_DELAY 4
	CUTSCENE_TEXTBOX 20, 2, $D70C

	CUTSCENE_TEXT "Prepare to duel Lord"
	CUTSCENE_TEXT "Robotnik's champion."

	CUTSCENE_DELAY 16
	CUTSCENE_TEXT_CLOSE
	CUTSCENE_END

DragonDialogue:
	CUTSCENE_DELAY 4
	CUTSCENE_ENEMY_ANIM 0
	CUTSCENE_TEXTBOX 20, 2, $D70E

	CUTSCENE_TEXT "Ol' Ffuzzy-Fface got"
	CUTSCENE_TEXT "tied in knots, huh?"
	
	CUTSCENE_DELAY 10
	CUTSCENE_TEXT_CLOSE
	CUTSCENE_DELAY 4
	CUTSCENE_TEXTBOX 28, 2, $D70A

	CUTSCENE_TEXT "I guess that's why the Doc's"
	CUTSCENE_TEXT "sending the boys 'round."

	CUTSCENE_DELAY 10
	CUTSCENE_TEXT_CLOSE
	CUTSCENE_DELAY 4
	CUTSCENE_TEXTBOX 15, 1, $D816

	CUTSCENE_TEXT "So long sucker!"
	
	CUTSCENE_DELAY 10
	CUTSCENE_TEXT_CLOSE
	CUTSCENE_END

ScratchDialogue:
	CUTSCENE_DELAY 2
	CUTSCENE_ENEMY_ANIM 0
	CUTSCENE_TEXTBOX 25, 3, $D70C
	CUTSCENE_ENEMY_ANIM 1

	CUTSCENE_TEXT "You've been scratching%n"
	CUTSCENE_TEXT "around here for too long,"
	CUTSCENE_TEXT "worm-bait."

	CUTSCENE_DELAY 3
	CUTSCENE_ENEMY_ANIM 2
	CUTSCENE_DELAY 7
	CUTSCENE_TEXT_CLOSE
	CUTSCENE_DELAY 4
	CUTSCENE_TEXTBOX 22, 2, $D70C
	CUTSCENE_ENEMY_ANIM 3

	CUTSCENE_TEXT "Time to cross the road"
	CUTSCENE_TEXT "and head home, pal."
	
	CUTSCENE_DELAY 3
	CUTSCENE_ENEMY_ANIM 4
	CUTSCENE_DELAY 7
	CUTSCENE_TEXT_CLOSE
	CUTSCENE_DELAY 4
	CUTSCENE_TEXTBOX 23, 2, $D70C
	CUTSCENE_ENEMY_ANIM 5

	CUTSCENE_TEXT "I'm winning this one by"
	CUTSCENE_TEXT "fair means or fowl."

	CUTSCENE_DELAY 3
	CUTSCENE_ENEMY_ANIM 6
	CUTSCENE_DELAY 7
	CUTSCENE_TEXT_CLOSE
	CUTSCENE_END

RobotnikDialogue:
	CUTSCENE_DELAY 1
	CUTSCENE_ENEMY_ANIM $89
	CUTSCENE_DELAY 1
	CUTSCENE_ENEMY_ANIM $84
	CUTSCENE_DELAY 35
	CUTSCENE_TEXTBOX 28, 2, $D58E

	CUTSCENE_TEXT "You dopey duncebots -%n"
	CUTSCENE_TEXT "Can't you do anything right?"

	CUTSCENE_DELAY 10
	CUTSCENE_TEXT_CLOSE
	CUTSCENE_DELAY 6
	CUTSCENE_TEXTBOX 22, 3, $D510

	CUTSCENE_TEXT "Now I'll have to do my"
	CUTSCENE_TEXT "own dirty work and%n"
	CUTSCENE_TEXT "blend those beans."
	
	CUTSCENE_DELAY 16
	CUTSCENE_TEXT_CLOSE
	CUTSCENE_DELAY 6
	CUTSCENE_END

GameIntroDialogue:
	CUTSCENE_ENEMY_ANIM $83
	CUTSCENE_DELAY 10
	CUTSCENE_TEXTBOX 27, 3, $C30C

	CUTSCENE_TEXT "Witness my evil dream to%n"
	CUTSCENE_TEXT "rid Mobius of music and fun"
	CUTSCENE_TEXT "forever."

	CUTSCENE_DELAY 12
	CUTSCENE_TEXT_CLOSE
	CUTSCENE_DELAY 15
	CUTSCENE_TEXTBOX 26, 2, $C38E

	CUTSCENE_TEXT "My latest invention, the  "
	CUTSCENE_TEXT "mean bean-steaming machine"

	CUTSCENE_DELAY 12
	CUTSCENE_TEXT_CLOSE
	CUTSCENE_DELAY 15
	CUTSCENE_TEXTBOX 24, 3, $C310

	CUTSCENE_TEXT "will not only dispose of"
	CUTSCENE_TEXT "those fun-loving jolly  "
	CUTSCENE_TEXT "beans of Beanville"

	CUTSCENE_DELAY 12
	CUTSCENE_TEXT_CLOSE
	CUTSCENE_DELAY 15
	CUTSCENE_TEXTBOX 24, 3, $C310

	CUTSCENE_TEXT "but turn them into robot"
	CUTSCENE_TEXT "slaves to serve my evil "
	CUTSCENE_TEXT "purposes."

	CUTSCENE_DELAY 12
	CUTSCENE_TEXT_CLOSE
	CUTSCENE_DELAY 15
	CUTSCENE_TEXTBOX 21, 2, $C392

	CUTSCENE_TEXT "Robots.%n"
	CUTSCENE_TEXT "Bring me those beans."

	CUTSCENE_DELAY 12
	CUTSCENE_TEXT_CLOSE
	CUTSCENE_DELAY 6
	CUTSCENE_ENEMY_ANIM $86
	CUTSCENE_DELAY 6
	CUTSCENE_ENEMY_ANIM $87
	CUTSCENE_DELAY 3
	CUTSCENE_ENEMY_ANIM $88
	CUTSCENE_SOUND SFX_ROBOTNIK_LAUGH
	CUTSCENE_DELAY 20
	CUTSCENE_END

; -----------------------------------------------------------------------------------------
; Initialize sprite drawing
; -----------------------------------------------------------------------------------------

InitSpriteDraw:
	clr.w	draw_order
	clr.w	sprite_count
	rts

; -----------------------------------------------------------------------------------------
; Draw actors
; -----------------------------------------------------------------------------------------

DrawActors:
	tst.w	sprite_count
	beq.w	.DoDraw
	rts

.DoDraw:
	lea	actors,a0
	moveq	#aSize,d2
	tst.w	draw_order
	beq.w	.StartDraw
	lea	actors_end-aSize,a0
	moveq	#-aSize,d2

.StartDraw:
	lea	sprite_buffer+8,a1
	lea	SpriteMappings,a2
	lea	sprite_layers+1,a4
	move.w	#ACTOR_SLOT_COUNT-1,d0

	move.w	#1,d1
	move.b	p1_pause,d4
	rol.b	#1,d4
	andi.b	#1,d4
	eori.b	#1,d4
	move.b	p2_pause,d5
	rol.b	#2,d5
	andi.b	#2,d5
	eori.b	#2,d5
	or.b	d5,d4
	ori.b	#$C,d4

.DrawLoop:
	move.b	aRunFlags(a0),d5
	and.b	d4,d5
	beq.w	.NextActor
	
	btst	#7,aFlags(a0)
	beq.w	.NextActor

	movem.l	d2,-(sp)
	bsr.w	DrawActorSprite
	movem.l	(sp)+,d2

.NextActor:
	adda.l	d2,a0
	dbf	d0,.DrawLoop

	bsr.w	SetSpriteLinks
	lsl.w	#2,d1
	move.w	d1,sprite_count
	not.w	draw_order

	rts

; -----------------------------------------------------------------------------------------
; Set sprite links
; -----------------------------------------------------------------------------------------
; PARAMETERS:
;	d1.w	- Sprite count
; -----------------------------------------------------------------------------------------

SetSpriteLinks:
	lea	sprite_layers,a0
	lea	sprite_links,a1
	
	move.w	#5-1,d0
	move.b	#0,d2

.LayerLoop:
	move.w	d1,d3
	subq.w	#1,d3

.CheckLayer:
	cmp.b	(a0,d3.w),d0
	bne.w	.NextLayer
	bsr.w	SetSpriteLink

.NextLayer:
	dbf	d3,.CheckLayer
	dbf	d0,.LayerLoop

	lea	sprite_buffer,a0
	move.w	d1,d0
	subq.w	#1,d0

.SetLinks:
	move.b	(a1)+,3(a0)
	adda.l	#8,a0
	dbf	d0,.SetLinks

	rts

; -----------------------------------------------------------------------------------------
; Set a sprite link
; -----------------------------------------------------------------------------------------
; PARAMETERS:
;	d2.b	- Sprite link value
;	d3.w	- Sprite link buffer index
;	a1.l	- Pointer to sprite link buffer
; -----------------------------------------------------------------------------------------

SetSpriteLink:
	move.b	d2,(a1,d3.w)
	move.b	d3,d2
	rts

; -----------------------------------------------------------------------------------------
; Draw an actor
; -----------------------------------------------------------------------------------------
; PARAMETERS:
;	d1.w	- Current sprite count
;	a0.l	- Pointer to actor slot
;	a1.l	- Pointer to sprite buffer
;	a2.l	- Pointer to sprite mappings data table
;	a4.l	- Pointer to sprite layer buffer
; -----------------------------------------------------------------------------------------

DrawActorSprite:
	clr.w	d2
	move.b	aMappings(a0),d2
	lsl.w	#2,d2
	movea.l	(a2,d2.w),a5
	
	clr.w	d2
	move.b	aFrame(a0),d2
	lsl.w	#2,d2
	movea.l	(a5,d2.w),a3
	move.w	(a3)+,d2
	subq.w	#1,d2

.DrawPieces:
	movem.l	a3,-(sp)
	bsr.w	DrawActorSpritePiece
	movem.l	(sp)+,a3

	adda.l	#8,a3
	dbf	d2,.DrawPieces

	rts

; -----------------------------------------------------------------------------------------
; Draw a sprite piece for an actor
; -----------------------------------------------------------------------------------------
; PARAMETERS:
;	d1.w	- Current sprite count
;	a0.l	- Pointer to actor slot
;	a1.l	- Pointer to sprite buffer
;	a3.l	- Pointer to sprite mappings data
;	a4.l	- Pointer to sprite layer buffer
; -----------------------------------------------------------------------------------------

DrawActorSpritePiece:
	cmpi.w	#$50,d1
	bcs.w	.DoDraw
	rts

.DoDraw:
	addq.w	#1,d1

	move.w	(a3)+,d3
	add.w	aY(a0),d3
	sub.w	vscroll_buffer,d3
	move.w	d3,(a1)+

	move.b	(a3)+,(a1)+
	adda.l	#1,a1
	move.b	(a3)+,(a4)+
	move.w	(a3)+,(a1)+

	move.w	(a3)+,d3
	add.w	aX(a0),d3
	bne.w	.SetX
	addq.w	#1,d3

.SetX:
	move.w	d3,(a1)+

	rts


; =============== S U B	R O U T	I N E =====================================================


sub_11E90:
	movem.l	d3-d4/a2,-(sp)
	move.b	d2,d3
	lsl.b	#1,d3
	lea	byte_FF1D4E,a2
	tst.b	aPuyoField(a0)
	beq.w	loc_11EAC
	lea	byte_FF1D58,a2

loc_11EAC:
	move.b	8(a2),d4
	cmp.b	d4,d3
	bcs.w	loc_11EC8
	move.b	9(a2),d4
	cmp.b	d3,d4
	bcs.w	loc_11EC8
	movem.l	(sp)+,d3-d4/a2
	bra.w	sub_11ECE
; -----------------------------------------------------------------------------------------

loc_11EC8:
	movem.l	(sp)+,d3-d4/a2
	rts
; End of function sub_11E90


; =============== S U B	R O U T	I N E =====================================================


sub_11ECE:
	movem.l	a1,-(sp)
	lea	byte_FF1D4E,a1
	tst.b	aPuyoField(a0)
	beq.w	loc_11EE6
	lea	byte_FF1D58,a1

loc_11EE6:
	move.b	#0,1(a1)
	movem.l	(sp)+,a1
	rts
; End of function sub_11ECE


; =============== S U B	R O U T	I N E =====================================================


SpawnLessonStartText:
	move.b	stage_mode,d2
	or.b	stage,d2
	or.b	aPuyoField(a0),d2
	bne.w	.End

	lea	ActLessonStartText,a1
	jsr	FindActorSlotQuick
	bcs.w	.End

	move.b	0(a0),0(a1)
	move.b	#$80,6(a1)
	move.b	#$2A,8(a1)
	move.b	#3,9(a1)
	jsr	(GetPuyoFieldTopLeft).l
	addi.w	#$30,d0
	move.w	d0,$A(a1)
	move.w	#$D0,$E(a1)
	move.w	#$D0,$26(a1)

.End:
	rts


; =============== S U B	R O U T	I N E =====================================================


ActLessonStartText:
	subq.w	#1,$26(a0)
	beq.w	loc_11F74
	addq.b	#1,$28(a0)
	andi.b	#$1F,$28(a0)
	move.b	#$80,6(a0)
	cmpi.b	#$18,$28(a0)
	bcs.w	locret_11F72
	move.b	#0,6(a0)

locret_11F72:
	rts
; -----------------------------------------------------------------------------------------

loc_11F74:
	move.b	#$85,6(a0)
	move.w	#$FFFF,$20(a0)
	move.w	#$3000,$1C(a0)
	move.w	#1,$16(a0)
	jsr	(ActorBookmark).l
	jsr	(ActorMove).l
	bcs.w	loc_11F9E
	rts
; -----------------------------------------------------------------------------------------

loc_11F9E:
	jmp	(ActorDeleteSelf).l
; End of function ActLessonStartText


; =============== S U B	R O U T	I N E =====================================================


sub_11FA4:
	move.b	stage_mode,d2
	or.b	stage,d2
	or.b	aPuyoField(a0),d2
	bne.w	locret_11FFC

	lea	ActPuyoLinkHighlight,a1
	jsr	FindActorSlot
	bcs.w	locret_11FFC
	move.b	0(a0),0(a1)
	move.l	a0,$2E(a1)
	move.b	d0,$26(a1)
	move.b	d1,$27(a1)
	move.b	aPuyoField(a0),aPuyoField(a1)
	move.w	#$15,$28(a1)
	cmp.b	d0,d1
	bne.w	loc_11FF2
	move.w	#$A,$28(a1)

loc_11FF2:
	move.b	#$FF,7(a1)
	bsr.w	sub_11FFE

locret_11FFC:
	rts
; End of function sub_11FA4


; =============== S U B	R O U T	I N E =====================================================


sub_11FFE:
	lea	(byte_FF19B6).l,a1
	tst.b	aPuyoField(a0)
	beq.w	loc_12012
	lea	(byte_FF1B60).l,a1

loc_12012:
	jsr	(GetPuyoField).l
	move.w	#5,d0
	move.w	#$9C,d1

loc_12020:
	move.w	d1,d2

loc_12022:
	tst.b	(a2,d2.w)
	beq.w	loc_12030
	subi.w	#$C,d2
	bcc.s	loc_12022

loc_12030:
	move.w	d2,(a1)+
	subi.w	#$C,d2
	move.w	d2,(a1)+
	addq.w	#2,d1
	dbf	d0,loc_12020
	adda.l	#$92,a1
	clr.w	(a1)
	rts
; End of function sub_11FFE


; =============== S U B	R O U T	I N E =====================================================


ActPuyoLinkHighlight:
	bsr.w	sub_120E8
	bcs.w	loc_120D6
	bsr.w	sub_1213E
	jsr	(sub_5960).l
	bsr.w	sub_1216C
	adda.l	#$18,a1
	adda.l	#$18,a2
	move.w	#$47,d0
	clr.w	d1

loc_12070:
	move.w	d0,d2
	lsl.w	#1,d2
	tst.b	(a3,d2.w)
	bmi.w	loc_1208E
	tst.b	(a2,d2.w)
	beq.w	loc_1208E
	addq.w	#1,d1
	move.w	d1,d2
	lsl.w	#1,d2
	move.w	d0,(a1,d2.w)

loc_1208E:
	dbf	d0,loc_12070
	move.w	d1,(a1)
	beq.w	loc_1209C
	bsr.w	sub_12218

loc_1209C:
	subq.w	#1,$28(a0)
	bcs.w	loc_120A6
	rts
; -----------------------------------------------------------------------------------------

loc_120A6:
	move.b	#$FF,$2D(a0)
	clr.w	$28(a0)
	jsr	(ActorBookmark).l
	addi.w	#$C,$28(a0)
	move.b	$28(a0),d0
	cmp.b	$2C(a0),d0
	bcs.w	loc_120CC
	clr.b	$28(a0)

loc_120CC:
	bsr.w	sub_120E8
	bcs.w	loc_120D6
	rts
; -----------------------------------------------------------------------------------------

loc_120D6:
	move.b	#0,7(a0)
	jsr	(ActorBookmark).l
	jmp	(ActorDeleteSelf).l
; End of function ActPuyoLinkHighlight


; =============== S U B	R O U T	I N E =====================================================


sub_120E8:
	movea.l	$2E(a0),a1
	move.b	7(a1),d0
	andi.b	#3,d0
	cmpi.b	#3,d0
	bne.w	loc_12138
	tst.b	stage_mode
	bne.w	loc_12116
	tst.w	puyos_popping
	bne.w	loc_12138
	andi	#$FFFE,sr
	rts
; -----------------------------------------------------------------------------------------

loc_12116:
	tst.b	$2B(a0)
	bne.w	loc_12138
	clr.w	d0
	move.b	$2A(a0),d0
	lea	puyos_popping,a1
	tst.b	(a1,d0.w)
	bne.w	loc_12138
	andi	#$FFFE,sr
	rts
; -----------------------------------------------------------------------------------------

loc_12138:
	ori	#1,sr
	rts
; End of function sub_120E8


; =============== S U B	R O U T	I N E =====================================================


sub_1213E:
	bsr.w	sub_1218A
	tst.w	d0
	bmi.w	loc_12156
	move.b	$26(a0),d2
	lsl.b	#4,d2
	ori.b	#$80,d2
	move.b	d2,(a2,d0.w)

loc_12156:
	tst.w	d1
	bmi.w	locret_1216A
	move.b	$27(a0),d2
	lsl.b	#4,d2
	ori.b	#$80,d2
	move.b	d2,(a2,d1.w)

locret_1216A:
	rts
; End of function sub_1213E


; =============== S U B	R O U T	I N E =====================================================


sub_1216C:
	bsr.w	sub_1218A
	tst.w	d0
	bmi.w	loc_1217C
	move.b	#0,(a2,d0.w)

loc_1217C:
	tst.w	d1
	bmi.w	locret_12188
	move.b	#0,(a2,d1.w)

locret_12188:
	rts
; End of function sub_1216C


; =============== S U B	R O U T	I N E =====================================================


sub_1218A:
	jsr	(GetPuyoField).l
	lea	(byte_FF19B6).l,a1
	tst.b	$2A(a0)
	beq.w	loc_121A4
	lea	(byte_FF1B60).l,a1

loc_121A4:
	move.w	$28(a0),d2
	lsl.w	#2,d2
	move.w	word_121C0(pc,d2.w),d3
	lsl.w	#1,d3
	move.w	(a1,d3.w),d0
	move.w	word_121C2(pc,d2.w),d3
	lsl.w	#1,d3
	move.w	(a1,d3.w),d1
	rts
; End of function sub_1218A

; -----------------------------------------------------------------------------------------
word_121C0
	dc.w	0
word_121C2
	dc.w	1
	dc.w	2
	dc.w	3
	dc.w	4
	dc.w	5
	dc.w	6
	dc.w	7
	dc.w	8
	dc.w	9
	dc.w	$A
	dc.w	$B
	dc.w	0
	dc.w	2
	dc.w	2
	dc.w	4
	dc.w	4
	dc.w	6
	dc.w	6
	dc.w	8
	dc.w	8
	dc.w	$A
	dc.w	1
	dc.w	0
	dc.w	3
	dc.w	2
	dc.w	5
	dc.w	4
	dc.w	7
	dc.w	6
	dc.w	9
	dc.w	8
	dc.w	$B
	dc.w	$A
	dc.w	2
	dc.w	0
	dc.w	4
	dc.w	2
	dc.w	6
	dc.w	4
	dc.w	8
	dc.w	6
	dc.w	$A
	dc.w	8

; =============== S U B	R O U T	I N E =====================================================


sub_12218:
	bsr.w	sub_122A0
	bcc.w	loc_12222
	rts
; -----------------------------------------------------------------------------------------

loc_12222:
	lea	(byte_FF19CE).l,a2
	tst.b	$2A(a0)
	beq.w	loc_12236
	lea	(byte_FF1B78).l,a2

loc_12236:
	jsr	(GetPuyoFieldTopLeft).l
	addq.w	#8,d0
	addq.w	#8,d1
	move.w	(a2)+,d2
	subq.w	#1,d2

loc_12244:
	lea	(sub_12300).l,a1
	jsr	FindActorSlotQuick
	bcs.w	loc_1228A
	move.b	0(a0),0(a1)
	move.l	a0,$2E(a1)
	move.b	#$2A,8(a1)
	move.l	#unk_12294,$32(a1)
	move.b	$2C(a0),$26(a1)
	clr.l	d3
	move.w	(a2)+,d3
	divu.w	#6,d3
	lsl.l	#4,d3
	add.w	d1,d3
	move.w	d3,$E(a1)
	swap	d3
	add.w	d0,d3
	move.w	d3,$A(a1)

loc_1228A:
	dbf	d2,loc_12244
	addq.b	#1,$2C(a0)
	rts
; End of function sub_12218

; -----------------------------------------------------------------------------------------
unk_12294
	dc.b	1
	dc.b	0
	dc.b	1
	dc.b	1
	dc.b	1
	dc.b	2
	dc.b	$FF
	dc.b	0
	dc.l	unk_12294

; =============== S U B	R O U T	I N E =====================================================


sub_122A0:
	movea.l	a1,a2
	adda.l	#$92,a2
	clr.w	d0

loc_122AA:
	move.w	(a2,d0.w),d1
	beq.w	loc_122DC
	movem.l	a1,-(sp)
	move.b	#0,d2

loc_122BA:
	move.w	(a1)+,d3
	cmp.w	(a2,d0.w),d3
	beq.w	loc_122C8
	move.b	#$FF,d2

loc_122C8:
	addq.w	#2,d0
	dbf	d1,loc_122BA
	movem.l	(sp)+,a1
	tst.b	d2
	bne.s	loc_122AA
	ori	#1,sr
	rts
; -----------------------------------------------------------------------------------------

loc_122DC:
	move.w	(a1),d1
	addq.w	#1,d1
	lsl.w	#1,d1
	add.w	d0,d1
	bcc.w	loc_122EA
	rts
; -----------------------------------------------------------------------------------------

loc_122EA:
	move.w	(a1),d1

loc_122EC:
	move.w	(a1)+,(a2,d0.w)
	addq.w	#2,d0
	dbf	d1,loc_122EC
	clr.w	(a2,d0.w)
	andi	#$FFFE,sr
	rts
; End of function sub_122A0


; =============== S U B	R O U T	I N E =====================================================


sub_12300:
	movea.l	$2E(a0),a1
	tst.b	7(a1)
	beq.w	loc_12334
	jsr	(ActorAnimate).l
	move.b	#0,6(a0)
	tst.b	$2D(a1)
	beq.w	locret_12332
	move.b	$28(a1),d0
	cmp.b	$26(a0),d0
	bne.w	locret_12332
	move.b	#$80,6(a0)

locret_12332:
	rts
; -----------------------------------------------------------------------------------------

loc_12334:
	jmp	(ActorDeleteSelf).l
; End of function sub_12300


; =============== S U B	R O U T	I N E =====================================================


sub_1233A:
	lea	byte_FF1D4E,a2
	move.w	#9,d0
	clr.w	d1

loc_12346:
	move.w	d1,(a2)+
	dbf	d0,loc_12346
	move.b	stage_mode,d0
	andi.b	#3,d0
	beq.w	loc_1235C
	rts
; -----------------------------------------------------------------------------------------

loc_1235C:
	clr.w	puyos_popping
	clr.w	puyo_count_p2
	lea	(sub_12374).l,a1
	jmp	FindActorSlot
; End of function sub_1233A


; =============== S U B	R O U T	I N E =====================================================


sub_12374:
	tst.w	puyos_popping
	bne.w	loc_1239C
	addq.w	#1,$26(a0)
	andi.w	#$7FFF,$26(a0)
	addq.w	#1,$28(a0)
	andi.w	#$7FFF,$28(a0)
	bsr.w	sub_12460
	bsr.w	sub_123AE
	rts
; -----------------------------------------------------------------------------------------

loc_1239C:
	addq.w	#1,(pal_fade_data+$186).l
	jsr	(sub_61C0).l
	jmp	(ActorDeleteSelf).l
; End of function sub_12374


; =============== S U B	R O U T	I N E =====================================================


sub_123AE:
	move.b	#1,(byte_FF1121).l
	tst.w	$2A(a0)
	beq.w	loc_123F0
	subq.w	#1,$2A(a0)
	bne.w	locret_1244C
	clr.l	d0
	move.b	opponent,d0
	lea	(byte_6206).l,a1
	move.b	(a1,d0.w),d0
	lsl.w	#5,d0
	lea	Palettes,a2
	adda.l	d0,a2
	move.b	#3,d0
	move.b	#0,d1
	jmp	(FadeToPalette).l
; -----------------------------------------------------------------------------------------

loc_123F0:
	move.w	puyo_count_p2,d0
	lsr.w	#3,d0
	cmpi.w	#9,d0
	bcs.w	loc_12404
	move.w	#8,d0

loc_12404:
	lsl.w	#1,d0
	lea	(unk_1244E).l,a1
	move.w	(a1,d0.w),d1
	bmi.w	loc_12444
	cmp.w	$28(a0),d1
	bcc.w	locret_1244C
	clr.w	$28(a0)
	move.b	#3,d0
	move.b	#1,d1
	move.b	#3,d2
	lea	Palettes,a2
	adda.l	#Pal_White-Palettes,a2
	jsr	(FadeToPal_StepCount).l
	move.w	#$26,$2A(a0)

loc_12444:
	move.b	#0,(byte_FF1121).l

locret_1244C:
	rts
; End of function sub_123AE

; -----------------------------------------------------------------------------------------
unk_1244E
	dc.b	$FF
	dc.b	$FF
	dc.b	$FF
	dc.b	$FF
	dc.b	$FF
	dc.b	$FF
	dc.b	$FF
	dc.b	$FF
	dc.b	$FF
	dc.b	$FF
	dc.b	$FF
	dc.b	$FF
	dc.b	$FF
	dc.b	$FF
	dc.b	0
	dc.b	$60
	dc.b	0
	dc.b	$30

; =============== S U B	R O U T	I N E =====================================================


sub_12460:
	move.w	puyo_count_p2,d0
	lsr.w	#3,d0
	cmpi.w	#9,d0
	bcs.w	loc_12474
	move.w	#8,d0

loc_12474:
	lsl.w	#1,d0
	lea	(unk_124FE).l,a1
	move.w	(a1,d0.w),d1
	cmp.w	$26(a0),d1
	bcc.w	locret_124FC
	clr.w	$26(a0)
	lea	(loc_1251C).l,a1
	jsr	FindActorSlotQuick
	bcs.w	locret_124FC
	move.b	#$25,8(a1)
	move.w	#$1800,$1C(a1)
	move.w	#$FFFF,$20(a1)
	jsr	Random
	clr.w	d1
	move.b	d0,d1
	andi.b	#$7F,d1
	addi.w	#$240,d1
	andi.b	#$5F,d0
	addi.b	#-$70,d0
	move.l	#unk_12510,$32(a1)
	jsr	(Sin).l
	move.l	d2,$16(a1)
	asl.l	#4,d2
	swap	d2
	addi.w	#$110,d2
	move.w	d2,$E(a1)
	jsr	(Cos).l
	move.l	d2,$12(a1)
	asl.l	#4,d2
	swap	d2
	addi.w	#$120,d2
	move.w	d2,$A(a1)

locret_124FC:
	rts
; End of function sub_12460

; -----------------------------------------------------------------------------------------
unk_124FE
	dc.b	$FF
	dc.b	$FF
	dc.b	$FF
	dc.b	$FF
	dc.b	$FF
	dc.b	$FF
	dc.b	$FF
	dc.b	$FF
	dc.b	$FF
	dc.b	$FF
	dc.b	$FF
	dc.b	$FF
	dc.b	0
	dc.b	3
	dc.b	0
	dc.b	2
	dc.b	0
	dc.b	1
unk_12510
	dc.b	$C
	dc.b	$A
	dc.b	6
	dc.b	6
	dc.b	$FE
	dc.b	0
unk_12516
	dc.b	3
	dc.b	6
	dc.b	3
	dc.b	$A
	dc.b	$FE
	dc.b	0
; -----------------------------------------------------------------------------------------

loc_1251C:
	jsr	(ActorAnimate).l
	move.b	#$87,6(a0)
	jsr	(ActorBookmark).l
	jsr	(ActorMove).l
	jsr	(ActorAnimate).l
	bcs.w	loc_12540
	rts
; -----------------------------------------------------------------------------------------

loc_12540:
	move.l	#unk_12516,$32(a0)
	jsr	(ActorBookmark).l
	jsr	(ActorAnimate).l
	bcs.w	loc_1255A
	rts
; -----------------------------------------------------------------------------------------

loc_1255A:
	jmp	(ActorDeleteSelf).l
; -----------------------------------------------------------------------------------------
	rts

; =============== S U B	R O U T	I N E =====================================================


sub_12562:
	movem.l	d0,-(sp)
	move.w	#5,d0
	tst.b	aPuyoField(a0)
	beq.w	loc_12578
	move.b	opponent,d0

loc_12578:
	lsl.w	#2,d0
	movea.l	off_12584(pc,d0.w),a2
	movem.l	(sp)+,d0
	rts
; End of function sub_12562

; -----------------------------------------------------------------------------------------
off_12584:
	dc.l	unk_125C4
	dc.l	unk_125E4
	dc.l	unk_1260C
	dc.l	unk_125DC
	dc.l	unk_125CC
	dc.l	unk_12614
	dc.l	unk_125FC
	dc.l	byte_125F4
	dc.l	byte_1261C
	dc.l	byte_12624
	dc.l	byte_1262C
	dc.l	byte_12634
	dc.l	byte_1263C
	dc.l	unk_125D4
	dc.l	unk_125EC
	dc.l	byte_12604
unk_125C4:
	dc.b	0
	dc.b	$C0
	dc.b	3
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	$FF
	dc.b	0
unk_125CC:
	dc.b	0
	dc.b	$40
	dc.b	$FF
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	$FF
	dc.b	$83
unk_125D4
	dc.b	0
	dc.b	$10
	dc.b	$FF
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	$FF
	dc.b	$83
unk_125DC
	dc.b	0
	dc.b	$80
	dc.b	$FF
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	$FF
	dc.b	$82
unk_125E4
	dc.b	0
	dc.b	$60
	dc.b	$FF
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	$FF
	dc.b	$83
unk_125EC
	dc.b	0
	dc.b	$20
	dc.b	8
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	$FF
	dc.b	$83
byte_125F4
	dc.b	0
	dc.b	8
	dc.b	8
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	$FF
	dc.b	$83
unk_125FC
	dc.b	$40
	dc.b	8
	dc.b	$FF
	dc.b	$30
	dc.b	$24
	dc.b	0
	dc.b	$C
	dc.b	$83
byte_12604
	dc.b	0
	dc.b	0
	dc.b	$FF
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	$FF
	dc.b	$83
unk_1260C
	dc.b	$20
	dc.b	0
	dc.b	$FF
	dc.b	$3C
	dc.b	$30
	dc.b	$6E
	dc.b	$FF
	dc.b	$83
unk_12614
	dc.b	$10
	dc.b	0
	dc.b	$FF
	dc.b	$30
	dc.b	$30
	dc.b	$2C
	dc.b	$FF
	dc.b	$83
byte_1261C
	dc.b	0
	dc.b	0
	dc.b	$FF
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	$FF
	dc.b	$83
byte_12624
	dc.b	0
	dc.b	0
	dc.b	$FF
	dc.b	$3C
	dc.b	$30
	dc.b	$2A
	dc.b	$FF
	dc.b	$83
byte_1262C
	dc.b	0
	dc.b	0
	dc.b	$FF
	dc.b	$30
	dc.b	$24
	dc.b	$66
	dc.b	$FF
	dc.b	$83
byte_12634
	dc.b	0
	dc.b	0
	dc.b	$FF
	dc.b	$30
	dc.b	$24
	dc.b	0
	dc.b	8
	dc.b	$83
byte_1263C
	dc.b	0
	dc.b	0
	dc.b	$FF
	dc.b	$24
	dc.b	$24
	dc.b	0
	dc.b	8
	dc.b	$83

; =============== S U B	R O U T	I N E =====================================================


nullsub_4:
	rts


; =============== S U B	R O U T	I N E =====================================================


CheckIfCPUPlayer:
	move.b	stage_mode,d0
	btst	#2,d0
	bne.w	loc_1266E
	lsl.b	#1,d0
	or.b	aPuyoField(a0),d0
	eori.b	#1,d0
	and.b	use_cpu_player,d0
	beq.w	loc_1266E
	CLEAR_CARRY
	rts
; -----------------------------------------------------------------------------------------

loc_1266E:
	SET_CARRY
	rts
; End of function CheckIfCPUPlayer


; =============== S U B	R O U T	I N E =====================================================


sub_12674:
	lea	byte_FF1D4E,a6
	tst.b	aPuyoField(a0)
	beq.w	loc_12688
	lea	byte_FF1D58,a6

loc_12688:
	cmpi.w	#2,time_minutes
	bcs.w	loc_1269E
	move.b	#1,0(a6)
	bra.w	loc_126D6
; -----------------------------------------------------------------------------------------

loc_1269E:
	tst.b	0(a6)
	bne.w	loc_126C0
	move.b	9(a4),d0
	cmp.b	3(a2),d0
	bcs.w	loc_126D6
	eori.b	#1,0(a6)
	clr.b	1(a6)
	bra.w	loc_126D6
; -----------------------------------------------------------------------------------------

loc_126C0:
	move.b	9(a4),d0
	cmp.b	4(a2),d0
	bcc.w	loc_126D6
	eori.b	#1,0(a6)
	bra.w	*+4
; -----------------------------------------------------------------------------------------

loc_126D6:
	clr.w	d0
	move.b	0(a6),d0
	rts
; End of function sub_12674


; =============== S U B	R O U T	I N E =====================================================


sub_126DE:
	tst.b	$2A(a0)
	bne.w	loc_126E8
	rts
; -----------------------------------------------------------------------------------------

loc_126E8:
	clr.w	d0
	move.b	opponent,d0
	lsl.b	#2,d0
	movea.l	off_126F8(pc,d0.w),a6
	jmp	(a6)
; End of function sub_126DE

; -----------------------------------------------------------------------------------------
off_126F8
	dc.l	locret_12738
	dc.l	loc_12778
	dc.l	locret_12738
	dc.l	locret_12738
	dc.l	locret_12738
	dc.l	locret_12738
	dc.l	locret_12738
	dc.l	loc_1273A
	dc.l	locret_12738
	dc.l	locret_12738
	dc.l	locret_12738
	dc.l	locret_12738
	dc.l	locret_12738
	dc.l	locret_12738
	dc.l	locret_12738
	dc.l	locret_12738
; -----------------------------------------------------------------------------------------

locret_12738:
	rts
; -----------------------------------------------------------------------------------------

loc_1273A:
	move.b	0(a5),d0
	or.b	$A(a5),d0
	bne.w	loc_12748
	rts
; -----------------------------------------------------------------------------------------

loc_12748:
	move.b	#0,$20(a0)
	move.b	#0,$21(a0)
	move.b	0(a5),d0
	cmp.b	$A(a5),d0
	bcc.w	loc_12766
	move.b	#5,$20(a0)

loc_12766:
	movem.l	(sp)+,a6
	move.b	#0,$2C(a0)
	move.b	#$FF,$2D(a0)
	rts
; -----------------------------------------------------------------------------------------

loc_12778:
	cmpi.w	#$18,8(a4)
	bcs.w	loc_12784
	rts
; -----------------------------------------------------------------------------------------

loc_12784:
	movem.l	(sp)+,a6
	move.w	#5,d0
	clr.b	d1

loc_1278E:
	move.w	d0,d2
	lsl.w	#1,d2
	move.b	(a5,d2.w),d3
	cmp.b	d1,d3
	bcs.w	loc_127A2
	move.b	d0,$20(a0)
	move.b	d3,d1

loc_127A2:
	dbf	d0,loc_1278E
	move.b	#0,$21(a0)
	move.b	#0,$2C(a0)
	move.b	#$FF,$2D(a0)
	rts

; =============== S U B	R O U T	I N E =====================================================


sub_127BA:
	bsr.w	CheckIfCPUPlayer
	bcs.w	loc_127C4
	rts
; -----------------------------------------------------------------------------------------

loc_127C4:
	jsr	(GetPuyoField).l
	movea.l	a2,a3
	movea.l	a2,a4
	movea.l	a2,a5
	bsr.w	sub_12562
	adda.l	#$A8,a3
	adda.l	#$294,a4
	adda.l	#$29E,a5
	movea.l	$32(a0),a1
	bsr.w	sub_12674
	move.b	d0,d3
	bsr.w	sub_128B8
	bsr.w	sub_12FAE
	bsr.w	sub_126DE
	clr.w	d0
	lea	(byte_FF1D1E).l,a6

loc_12804:
	move.b	$26(a1),d1
	bsr.w	sub_12920
	move.w	d4,(a6)+
	move.b	$27(a1),d1
	bsr.w	sub_12920
	move.w	d4,(a6)+
	addq.w	#1,d0
	cmpi.w	#$C,d0
	bcs.s	loc_12804
	move.w	#$15,d0
	clr.w	d1
	clr.w	d2
	lea	(unk_12860).l,a1
	lea	(byte_FF1D1E).l,a6

loc_12834:
	move.w	(a1)+,d3
	move.w	(a1)+,d4
	clr.w	d5
	move.w	(a6,d3.w),d6
	beq.w	loc_1284C
	move.w	(a6,d4.w),d5
	beq.w	loc_1284C
	add.w	d6,d5

loc_1284C:
	cmp.w	d1,d5
	bcs.w	loc_12856
	move.w	d5,d1
	move.w	d0,d2

loc_12856:
	dbf	d0,loc_12834
	move.w	d2,d0
	bra.w	loc_12B14
; End of function sub_127BA

; -----------------------------------------------------------------------------------------
unk_12860
	dc.b	0
	dc.b	$2C
	dc.b	0
	dc.b	$26
	dc.b	0
	dc.b	$24
	dc.b	0
	dc.b	$1E
	dc.b	0
	dc.b	$1C
	dc.b	0
	dc.b	$16
	dc.b	0
	dc.b	$14
	dc.b	0
	dc.b	$E
	dc.b	0
	dc.b	$C
	dc.b	0
	dc.b	6
	dc.b	0
	dc.b	$24
	dc.b	0
	dc.b	$2E
	dc.b	0
	dc.b	$1C
	dc.b	0
	dc.b	$26
	dc.b	0
	dc.b	$14
	dc.b	0
	dc.b	$1E
	dc.b	0
	dc.b	$C
	dc.b	0
	dc.b	$16
	dc.b	0
	dc.b	4
	dc.b	0
	dc.b	$E
	dc.b	0
	dc.b	$28
	dc.b	0
	dc.b	$2E
	dc.b	0
	dc.b	$20
	dc.b	0
	dc.b	$26
	dc.b	0
	dc.b	$18
	dc.b	0
	dc.b	$1E
	dc.b	0
	dc.b	$10
	dc.b	0
	dc.b	$16
	dc.b	0
	dc.b	8
	dc.b	0
	dc.b	$E
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	6
	dc.b	0
	dc.b	$2C
	dc.b	0
	dc.b	$2A
	dc.b	0
	dc.b	$24
	dc.b	0
	dc.b	$22
	dc.b	0
	dc.b	$1C
	dc.b	0
	dc.b	$1A
	dc.b	0
	dc.b	$14
	dc.b	0
	dc.b	$12
	dc.b	0
	dc.b	$C
	dc.b	0
	dc.b	$A
	dc.b	0
	dc.b	4
	dc.b	0
	dc.b	2

; =============== S U B	R O U T	I N E =====================================================


sub_128B8:
	movem.l	d0,-(sp)
	move.b	(a2,d0.w),d2
	bsr.w	sub_128EA
	bsr.w	sub_12906
	move.b	d0,$2C(a0)
	move.b	2(a2),d2
	bsr.w	sub_12906
	move.b	d0,$2D(a0)
	move.b	#0,$27(a0)
	move.b	#0,$26(a0)
	movem.l	(sp)+,d0
	rts
; End of function sub_128B8


; =============== S U B	R O U T	I N E =====================================================


sub_128EA:
	move.b	(byte_FF0104).l,d0
	subq.b	#2,d0
	bcc.w	loc_128F8
	clr.b	d0

loc_128F8:
	lsl.b	#4,d0
	add.b	d0,d2
	bcc.w	locret_12904
	move.b	#$FF,d2

locret_12904:
	rts
; End of function sub_128EA


; =============== S U B	R O U T	I N E =====================================================


sub_12906:
	clr.w	d0
	move.b	d2,d0
	cmpi.b	#$FF,d0
	beq.w	locret_1291E
	lsr.b	#1,d2
	move.b	d2,d0
	jsr	RandomBound
	add.b	d2,d0

locret_1291E:
	rts
; End of function sub_12906


; =============== S U B	R O U T	I N E =====================================================


sub_12920:
	bsr.w	sub_1295E
	bsr.w	sub_12AA4
	bsr.w	sub_12982
	bsr.w	sub_129B8
	move.b	(byte_FF1D16).l,d4
	move.b	(byte_FF1D17).l,d5
	move.b	(byte_FF1D18).l,d6
	move.b	$2A(a0),d2
	ror.b	#1,d2
	eori.b	#$80,d2
	or.b	7(a2),d2
	bpl.w	loc_12958
	lsl.b	#3,d5
	lsl.b	#1,d6

loc_12958:
	add.b	d5,d4
	add.b	d6,d4
	rts
; End of function sub_12920


; =============== S U B	R O U T	I N E =====================================================


sub_1295E:
	move.b	#0,d2
	tst.b	d3
	bne.w	loc_1296C
	move.b	5(a2),d2

loc_1296C:
	move.w	d0,d4
	lsr.w	#1,d4

loc_12970:
	lsl.b	#1,d2
	dbf	d4,loc_12970
	andi.b	#$80,d2
	move.b	d2,(byte_FF1D1D).l
	rts
; End of function sub_1295E


; =============== S U B	R O U T	I N E =====================================================


sub_12982:
	move.b	(byte_FF1D16).l,d1
	subq.b	#1,d1
	cmpi.b	#3,d1
	bcc.w	locret_129B6
	addq.b	#3,(byte_FF1D16).l
	cmpi.b	#4,(byte_FF1D19).l
	bcc.w	locret_129B6
	clr.b	(byte_FF1D19).l
	clr.b	(byte_FF1D1B).l
	subq.b	#4,(byte_FF1D16).l

locret_129B6:
	rts
; End of function sub_12982


; =============== S U B	R O U T	I N E =====================================================


sub_129B8:
	clr.b	(byte_FF1D17).l
	clr.b	(byte_FF1D18).l
	bsr.w	sub_129CE
	bsr.w	sub_12A54
	rts
; End of function sub_129B8


; =============== S U B	R O U T	I N E =====================================================


sub_129CE:
	clr.w	d1
	move.b	(byte_FF1D19).l,d1
	subq.b	#1,d1
	bpl.w	loc_129DE
	rts
; -----------------------------------------------------------------------------------------

loc_129DE:
	cmpi.b	#4,d1
	bcs.w	loc_129EA
	move.b	#3,d1

loc_129EA:
	move.b	(byte_FF1D1A).l,d2
	cmpi.b	#5,d2
	bcs.w	loc_129FC
	move.b	#4,d2

loc_129FC:
	lsl.b	#2,d2
	or.b	d2,d1
	tst.b	(byte_FF1D1D).l
	beq.w	loc_12A0E
	addi.b	#$14,d1

loc_12A0E:
	move.b	byte_12A2C(pc,d1.w),(byte_FF1D17).l
	bpl.w	locret_12A2A
	move.b	(byte_FF1D19).l,d1
	lsl.b	#1,d1
	addq.b	#1,d1
	move.b	d1,(byte_FF1D17).l

locret_12A2A:
	rts
; End of function sub_129CE

; -----------------------------------------------------------------------------------------
byte_12A2C
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	3
	dc.b	5
	dc.b	7
	dc.b	$FF
	dc.b	2
	dc.b	4
	dc.b	6
	dc.b	$FF
	dc.b	1
	dc.b	3
	dc.b	5
	dc.b	$FF
	dc.b	0
	dc.b	0
	dc.b	4
	dc.b	$FF
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	3
	dc.b	5
	dc.b	7
	dc.b	0
	dc.b	2
	dc.b	4
	dc.b	6
	dc.b	0
	dc.b	1
	dc.b	3
	dc.b	5
	dc.b	0
	dc.b	4
	dc.b	6
	dc.b	8
	dc.b	0

; =============== S U B	R O U T	I N E =====================================================


sub_12A54:
	clr.w	d1
	move.b	(byte_FF1D1B).l,d1
	subq.b	#1,d1
	bpl.w	loc_12A64
	rts
; -----------------------------------------------------------------------------------------

loc_12A64:
	cmpi.b	#4,d1
	bcs.w	loc_12A70
	move.b	#3,d1

loc_12A70:
	move.b	(byte_FF1D1C).l,d2
	cmpi.b	#5,d2
	bcs.w	loc_12A82
	move.b	#4,d2

loc_12A82:
	lsl.b	#2,d2
	or.b	d2,d1
	move.b	byte_12A2C(pc,d1.w),(byte_FF1D18).l
	bpl.w	locret_12AA2
	move.b	(byte_FF1D1B).l,d1
	lsl.b	#1,d1
	addq.b	#1,d1
	move.b	d1,(byte_FF1D18).l

locret_12AA2:
	rts
; End of function sub_12A54


; =============== S U B	R O U T	I N E =====================================================


sub_12AA4:
	move.w	d0,d5
	lsl.w	#3,d5
	move.w	d5,d6
	or.b	d1,d6
	clr.w	d1
	move.b	$C(a5,d6.w),d1
	andi.b	#$F,d1
	move.b	d1,(byte_FF1D16).l
	move.b	$C(a5,d6.w),d1
	lsr.b	#4,d1
	move.b	d1,(byte_FF1D19).l
	bsr.w	sub_12AEA
	move.b	d1,(byte_FF1D1A).l
	move.b	$C(a5,d6.w),d1
	lsr.b	#4,d1
	move.b	d1,(byte_FF1D1B).l
	bsr.w	sub_12AEA
	move.b	d1,(byte_FF1D1C).l
	rts
; End of function sub_12AA4


; =============== S U B	R O U T	I N E =====================================================


sub_12AEA:
	clr.b	d1
	move.w	#5,d2

loc_12AF0:
	cmp.w	d5,d6
	beq.w	loc_12B02
	cmp.b	$C(a5,d5.w),d1
	bcc.w	loc_12B02
	move.b	$C(a5,d5.w),d1

loc_12B02:
	addq.w	#1,d5
	dbf	d2,loc_12AF0
	lsr.b	#4,d1
	addi.w	#$5A,d5
	addi.w	#$60,d6
	rts
; End of function sub_12AEA

; -----------------------------------------------------------------------------------------
; START	OF FUNCTION CHUNK FOR sub_127BA

loc_12B14:
	lsl.w	#1,d0
	move.b	byte_12B30(pc,d0.w),$20(a0)
	move.b	byte_12B31(pc,d0.w),$21(a0)
	move.b	7(a2),d0
	andi.b	#3,d0
	and.b	d0,$21(a0)
	rts
; END OF FUNCTION CHUNK	FOR sub_127BA
; -----------------------------------------------------------------------------------------
byte_12B30
	dc.b	0
byte_12B31
	dc.b	0
	dc.b	1
	dc.b	0
	dc.b	2
	dc.b	0
	dc.b	3
	dc.b	0
	dc.b	4
	dc.b	0
	dc.b	5
	dc.b	0
	dc.b	0
	dc.b	2
	dc.b	1
	dc.b	2
	dc.b	2
	dc.b	2
	dc.b	3
	dc.b	2
	dc.b	4
	dc.b	2
	dc.b	5
	dc.b	2
	dc.b	0
	dc.b	1
	dc.b	1
	dc.b	1
	dc.b	2
	dc.b	1
	dc.b	3
	dc.b	1
	dc.b	4
	dc.b	1
	dc.b	1
	dc.b	3
	dc.b	2
	dc.b	3
	dc.b	3
	dc.b	3
	dc.b	4
	dc.b	3
	dc.b	5
	dc.b	3

; =============== S U B	R O U T	I N E =====================================================


sub_12B5C:
	jsr	(GetPuyoField).l
	adda.l	#$29E,a2
	move.w	#$A,d0
	lea	(unk_12B8C).l,a3

loc_12B72:
	move.w	(a3)+,d1
	beq.w	loc_12B86
	add.w	d0,d1
	tst.b	(a2,d1.w)
	bne.s	loc_12B72
	clr.b	(a2,d0.w)
	bra.s	loc_12B72
; -----------------------------------------------------------------------------------------

loc_12B86:
	subq.w	#2,d0
	bcc.s	loc_12B72
	rts
; End of function sub_12B5C

; -----------------------------------------------------------------------------------------
unk_12B8C
	dc.b	$FF
	dc.b	$FE
	dc.b	$FF
	dc.b	$FC
	dc.b	$FF
	dc.b	$FA
	dc.b	0
	dc.b	0
	dc.b	$FF
	dc.b	$FE
	dc.b	$FF
	dc.b	$FC
	dc.b	0
	dc.b	0
	dc.b	$FF
	dc.b	$FE
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	2
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	2
	dc.b	0
	dc.b	4
	dc.b	0
	dc.b	0

; =============== S U B	R O U T	I N E =====================================================


sub_12BAA:
	jsr	(GetPuyoField).l
	movea.l	a2,a3
	movea.l	a2,a4
	movea.l	a2,a5
	adda.l	#$18,a2
	adda.l	#$294,a3
	adda.l	#$29E,a4
	adda.l	#$A8,a5
	move.w	#9,d0

loc_12BD2:
	clr.b	(a3,d0.w)
	dbf	d0,loc_12BD2
	move.w	#$47,d0
	clr.w	d1
	clr.w	d2

loc_12BE2:
	move.b	(a2,d1.w),d2
	beq.s	loc_12BF6
	lsr.b	#4,d2
	andi.b	#7,d2
	addq.b	#1,(a3,d2.w)
	addq.w	#1,8(a3)

loc_12BF6:
	addq.w	#2,d1
	dbf	d0,loc_12BE2
	clr.w	d0

loc_12BFE:
	bsr.w	sub_12C14
	move.w	d1,(a4)+
	addq.w	#1,d0
	cmpi.w	#6,d0
	bcs.s	loc_12BFE
	bsr.w	sub_12B5C
	bra.w	loc_12C38
; End of function sub_12BAA


; =============== S U B	R O U T	I N E =====================================================


sub_12C14:
	move.w	#$C00,d1
	move.w	d0,d2
	lsl.w	#1,d2
	addi.w	#$84,d2

loc_12C20:
	tst.b	(a2,d2.w)
	beq.w	loc_12C30
	subi.w	#$100,d1
	move.b	(a5,d2.w),d1

loc_12C30:
	subi.w	#$C,d2
	bcc.s	loc_12C20
	rts
; End of function sub_12C14

; -----------------------------------------------------------------------------------------
; START	OF FUNCTION CHUNK FOR sub_12BAA

loc_12C38:
	move.b	stage_mode,d0
	andi.b	#3,d0
	lsl.b	#1,d0
	or.b	$2A(a0),d0
	eori.b	#1,d0
	beq.w	loc_12C52
	rts
; -----------------------------------------------------------------------------------------

loc_12C52:
	jsr	(GetPuyoField).l
	adda.l	#$294,a2
	movea.l	a2,a3
	adda.l	#$FFFFFC96,a3
	move.w	#2,d0
	cmpi.w	#$24,8(a2)
	bcc.w	loc_12C82
	subq.w	#1,d0
	cmpi.w	#$24,8(a3)
	bcc.w	loc_12C82
	subq.w	#1,d0

loc_12C82:
	move.w	d0,(word_FF198C).l
	rts
; END OF FUNCTION CHUNK	FOR sub_12BAA

; =============== S U B	R O U T	I N E =====================================================


sub_12C8A:
	bsr.w	CheckIfCPUPlayer
	bcs.w	loc_12C94
	rts
; -----------------------------------------------------------------------------------------

loc_12C94:
	jsr	(GetPuyoField).l
	movea.l	a2,a3
	movea.l	a2,a4
	movea.l	a2,a5
	adda.l	#pfVisColors,a2
	adda.l	#pfPuyoFlags,a3
	adda.l	#$29E,a4
	adda.l	#$2AA,a5
	tst.b	(byte_FF1D0E).l
	beq.w	loc_12CC8
	adda.l	#$60,a5

loc_12CC8:
	clr.w	d0

loc_12CCA:
	bsr.w	sub_12CE2
	bsr.w	sub_12DC2
	adda.l	#8,a5
	addq.w	#1,d0
	cmpi.w	#$C,d0
	bcs.s	loc_12CCA
	rts
; End of function sub_12C8A


; =============== S U B	R O U T	I N E =====================================================


sub_12CE2:
	move.w	d0,d1
	lsr.w	#1,d1
	move.w	d0,d2
	andi.w	#1,d2
	subq.w	#2,d2
	clr.w	d3
	move.w	d1,d4
	lsl.w	#1,d4
	clr.w	d5
	move.b	(a4,d4.w),d5
	add.w	d5,d2
	bmi.s	loc_12D1E
	bsr.w	sub_12D68
	bcs.w	loc_12D1E
	movem.l	a1,-(sp)
	move.w	d1,d3
	lsl.w	#2,d3
	movea.l	off_12D2C(pc,d3.w),a1
	move.b	(a1,d2.w),d3
	movem.l	(sp)+,a1
	ori.b	#$10,d3

loc_12D1E:
	move.w	#7,d4

loc_12D22:
	move.b	d3,(a5,d4.w)
	dbf	d4,loc_12D22
	rts
; End of function sub_12CE2

; -----------------------------------------------------------------------------------------
off_12D2C
	dc.l	unk_12D44
	dc.l	unk_12D50
	dc.l	unk_12D5C
	dc.l	unk_12D50
	dc.l	unk_12D50
	dc.l	unk_12D44
unk_12D44
	dc.b	4
	dc.b	5
	dc.b	6
	dc.b	7
	dc.b	8
	dc.b	9
	dc.b	$A
	dc.b	$B
	dc.b	$C
	dc.b	$D
	dc.b	$E
	dc.b	$F
unk_12D50
	dc.b	2
	dc.b	5
	dc.b	6
	dc.b	7
	dc.b	8
	dc.b	9
	dc.b	$A
	dc.b	$B
	dc.b	$C
	dc.b	$D
	dc.b	$E
	dc.b	$F
unk_12D5C
	dc.b	1
	dc.b	2
	dc.b	3
	dc.b	7
	dc.b	8
	dc.b	9
	dc.b	$A
	dc.b	$B
	dc.b	$C
	dc.b	$D
	dc.b	$E
	dc.b	$F

; =============== S U B	R O U T	I N E =====================================================


sub_12D68:
	tst.b	(byte_FF1D0E).l
	bne.w	loc_12D78
	andi	#$FFFE,sr
	rts
; -----------------------------------------------------------------------------------------

loc_12D78:
	addq.w	#1,d2
	cmpi.w	#$C,d2
	bcc.w	loc_12DB8
	move.w	d2,d4
	mulu.w	#6,d4
	add.w	d1,d4
	lsl.w	#1,d4
	move.b	(a2,d4.w),d5
	andi.b	#$F0,d5
	addi.w	#$C,d4

loc_12D98:
	move.b	(a2,d4.w),d6
	andi.b	#$F0,d6
	cmp.b	d6,d5
	bne.w	loc_12DB2
	addi.w	#$C,d4
	addq.w	#1,d2
	cmpi.b	#$B,d2
	bcs.s	loc_12D98

loc_12DB2:
	andi	#$FFFE,sr
	rts
; -----------------------------------------------------------------------------------------

loc_12DB8:
	move.b	#$1F,d3
	ori	#1,sr
	rts
; End of function sub_12D68


; =============== S U B	R O U T	I N E =====================================================


sub_12DC2:
	tst.b	0(a5)
	bne.w	loc_12DCC
	rts
; -----------------------------------------------------------------------------------------

loc_12DCC:
	move.w	d2,d3
	mulu.w	#6,d3
	add.w	d1,d3
	lsl.w	#1,d3
	move.w	#$FFFF,d4
	bsr.w	sub_12E36
	move.w	#1,d4
	bsr.w	sub_12E36
	bsr.w	*+4
; End of function sub_12DC2


; =============== S U B	R O U T	I N E =====================================================


sub_12DEA:
	cmpi.w	#$B,d2
	bcc.w	locret_12E34
	move.w	#$C,d4
	add.w	d3,d4
	move.b	(a2,d4.w),d5
	beq.s	locret_12E34
	andi.b	#$70,d5
	cmpi.b	#$60,d5
	beq.s	locret_12E34
	move.b	(a2,d4.w),d5
	andi.b	#$C,d5
	move.b	2(a2,d4.w),d6
	lsl.b	#1,d6
	andi.b	#4,d6
	and.b	d5,d6
	bne.s	locret_12E34
	move.b	-2(a2,d4.w),d6
	lsl.b	#2,d6
	andi.b	#8,d6
	and.b	d5,d6
	bne.s	locret_12E34
	move.w	#6,d4
	bra.w	loc_12E44
; -----------------------------------------------------------------------------------------

locret_12E34:
	rts
; End of function sub_12DEA


; =============== S U B	R O U T	I N E =====================================================


sub_12E36:
	move.w	d4,d5
	add.w	d1,d5
	cmpi.w	#6,d5
	bcs.w	loc_12E44
	rts
; -----------------------------------------------------------------------------------------

loc_12E44:
	lsl.w	#1,d4
	add.w	d3,d4
	clr.w	d5
	move.b	(a2,d4.w),d5
	beq.s	locret_12E6A
	lsr.b	#4,d5
	andi.b	#7,d5
	move.b	(a3,d4.w),d6
	andi.b	#3,d6
	bne.w	loc_12E64
	addq.b	#1,d6

loc_12E64:
	lsl.b	#4,d6
	add.b	d6,(a5,d5.w)

locret_12E6A:
	rts
; End of function sub_12E36


; =============== S U B	R O U T	I N E =====================================================


GetCPUCtrlData:
	andi.w	#$FD8F,d0
	andi.b	#$F3,d1
	movem.l	d2-d3/a1-a2,-(sp)
	movea.l	$2E(a0),a1
	lea	(byte_FF1D0A).l,a2
	tst.b	$2A(a1)
	beq.w	loc_12E90
	lea	(byte_FF1D0B).l,a2

loc_12E90:
	addq.b	#1,(a2)
	bne.w	loc_12E9A
	move.b	#$FF,(a2)

loc_12E9A:
	bsr.w	sub_12F82
	move.b	$20(a1),d2
	sub.b	$1B(a0),d2
	beq.w	loc_12ED6
	clr.w	d3
	rol.b	#1,d2
	andi.w	#1,d2
	or.b	byte_12F04(pc,d2.w),d1
	tst.b	$2A(a1)
	beq.w	loc_12ED6
	cmpi.b	#4,stage
	bcc.w	loc_12ED6
	tst.b	$27(a1)
	bmi.w	loc_12ED6
	bsr.w	sub_12F4A

loc_12ED6:
	move.b	$21(a1),d2
	sub.b	$2B(a0),d2
	beq.w	loc_12EF8
	clr.w	d3
	bset	#5,d0
	andi.b	#3,d2
	cmpi.b	#3,d2
	bne.w	loc_12EF8
	eori.b	#$60,d0

loc_12EF8:
	or.w	d3,d0
	bsr.w	sub_12F06
	movem.l	(sp)+,d2-d3/a1-a2
	rts
; End of function GetCPUCtrlData

; -----------------------------------------------------------------------------------------
byte_12F04
	dc.b	8
	dc.b	4

; =============== S U B	R O U T	I N E =====================================================


sub_12F06:
	move.b	d0,d2
	andi.b	#$70,d0
	beq.w	loc_12F18
	move.b	#$FF,(byte_FF1D0C).l

loc_12F18:
	btst	#9,d0
	beq.w	loc_12F2A
	move.b	#$80,(byte_FF1D0D).l
	rts
; -----------------------------------------------------------------------------------------

loc_12F2A:
	clr.w	d2
	move.b	d1,d2
	lsr.b	#2,d2
	andi.b	#3,d2
	move.b	byte_12F46(pc,d2.w),d3
	bne.w	loc_12F3E
	rts
; -----------------------------------------------------------------------------------------

loc_12F3E:
	move.b	d3,(byte_FF1D0D).l
	rts
; End of function sub_12F06

; -----------------------------------------------------------------------------------------
byte_12F46
	dc.b	0
	dc.b	$84
	dc.b	$88
	dc.b	0

; =============== S U B	R O U T	I N E =====================================================


sub_12F4A:
	cmpi.b	#$FF,(a2)
	bcs.w	loc_12F54
	rts
; -----------------------------------------------------------------------------------------

loc_12F54:
	movem.l	d0,-(sp)
	move.b	(a2),d0
	andi.b	#$F,d0
	beq.w	loc_12F6A
	andi.b	#$F3,d1
	bra.w	loc_12F7C
; -----------------------------------------------------------------------------------------

loc_12F6A:
	jsr	Random
	andi.b	#1,d0
	beq.w	loc_12F7C
	eori.b	#$C,d1

loc_12F7C:
	movem.l	(sp)+,d0
	rts
; End of function sub_12F4A


; =============== S U B	R O U T	I N E =====================================================


sub_12F82:
	move.b	$2C(a1),d2
	tst.b	$27(a1)
	beq.w	loc_12F92
	move.b	$2D(a1),d2

loc_12F92:
	cmp.b	$26(a1),d2
	bcc.w	loc_12FA4
	clr.b	$26(a1)
	eori.b	#$80,$27(a1)

loc_12FA4:
	clr.w	d3
	move.b	$27(a1),d3
	lsl.w	#2,d3
	rts
; End of function sub_12F82


; =============== S U B	R O U T	I N E =====================================================


sub_12FAE:



	tst.b	6(a2)
	bmi.w	locret_12FCA
	tst.b	d3
	bne.w	locret_12FCA
	cmpi.b	#8,3(a6)
	bcc.w	loc_12FCC
	addq.b	#1,3(a6)

locret_12FCA:
	rts
; -----------------------------------------------------------------------------------------

loc_12FCC:
	tst.b	1(a6)
	beq.w	loc_13142
	bra.w	*+4
; -----------------------------------------------------------------------------------------

loc_12FD8:
	movea.l	4(a6),a1
	move.b	(a1),d0
	lsr.b	#4,d0
	add.b	2(a6),d0
	move.b	d0,$20(a0)
	move.b	(a1)+,d0
	andi.b	#$F,d0
	move.b	d0,$21(a0)
	move.l	a1,4(a6)
	tst.b	(a1)
	bpl.w	loc_13000
	clr.b	1(a6)

loc_13000:
	movem.l	(sp)+,a1
	rts
; End of function sub_12FAE


; =============== S U B	R O U T	I N E =====================================================


sub_13006:
	move.b	(a3)+,d1
	move.b	(a3)+,d2
	clr.w	d0
	move.b	#$FF,d4
	clr.b	d5

loc_13012:
	move.b	(a5,d0.w),d6
	cmp.b	d2,d6
	bcs.w	loc_1302E
	addq.b	#1,d5
	cmp.b	d4,d6
	beq.w	loc_1302E
	move.b	d0,8(a6)
	move.b	#1,d5
	move.b	d6,d4

loc_1302E:
	cmp.b	d1,d5
	beq.w	loc_13042
	addq.b	#2,d0
	cmpi.b	#$C,d0
	bcs.s	loc_13012
	ori	#1,sr
	rts
; -----------------------------------------------------------------------------------------

loc_13042:
	move.b	d0,9(a6)
	bsr.w	sub_13060
	move.b	#0,$21(a0)
	move.b	8(a6),d0
	lsr.b	#1,d0
	move.b	d0,2(a6)
	andi	#$FFFE,sr
	rts
; End of function sub_13006


; =============== S U B	R O U T	I N E =====================================================


sub_13060:
	move.b	8(a6),d1
	clr.w	d2
	clr.b	d3

loc_13068:
	bsr.w	sub_1308E
	bcs.w	loc_13084
	move.b	(a5,d2.w),d4
	cmp.b	d3,d4
	bcs.w	loc_13084
	move.b	d4,d3
	move.b	d2,d4
	lsr.b	#1,d4
	move.b	d4,$20(a0)

loc_13084:
	addq.b	#2,d2
	cmpi.b	#$C,d2
	bcs.s	loc_13068
	rts
; End of function sub_13060


; =============== S U B	R O U T	I N E =====================================================


sub_1308E:
	cmp.b	d1,d2
	bcs.w	loc_130A0
	cmp.b	d2,d0
	bcs.w	loc_130A0
	ori	#1,sr
	rts
; -----------------------------------------------------------------------------------------

loc_130A0:
	andi	#$FFFE,sr
	rts
; End of function sub_1308E

; -----------------------------------------------------------------------------------------
byte_130A6
	dc.b	0
	dc.b	1
	dc.b	3
	dc.b	4
	dc.b	5
	dc.b	0

; =============== S U B	R O U T	I N E =====================================================


sub_130AC:
	move.w	#4,d0
	lea	(byte_FF1D10).l,a2

loc_130B6:
	move.b	byte_130A6(pc,d0.w),(a2,d0.w)
	dbf	d0,loc_130B6
	bsr.w	sub_13120
	move.w	#$28,d0
	clr.w	d1

loc_130CA:
	move.b	(a3),d1
	lsr.b	#4,d1
	move.b	(a2,d1.w),(a1,d0.w)
	move.b	(a3)+,d1
	andi.b	#$F,d1
	move.b	(a2,d1.w),1(a1,d0.w)
	addq.b	#2,d0
	cmpi.w	#$2C,d0
	bcs.s	loc_130CA
	clr.w	d0
	move.b	$2A(a0),d0
	lsl.w	#8,d0
	move.b	$20(a1),d0
	lea	puyo_order_1,a4

loc_130FA:
	move.b	(a3)+,d1
	bmi.w	loc_1311A
	lsr.b	#4,d1
	move.b	(a2,d1.w),(a4,d0.w)
	move.b	-1(a3),d1
	andi.b	#$F,d1
	move.b	(a2,d1.w),1(a4,d0.w)
	addq.b	#2,d0
	bra.s	loc_130FA
; -----------------------------------------------------------------------------------------

loc_1311A:
	move.l	a3,4(a6)
	rts
; End of function sub_130AC


; =============== S U B	R O U T	I N E =====================================================


sub_13120:
	move.w	#4,d1

loc_13124:
	move.w	#5,d0
	jsr	RandomBound
	move.b	(a2,d0.w),d2
	move.b	(a2,d1.w),(a2,d0.w)
	move.b	d2,(a2,d1.w)
	dbf	d1,loc_13124
	rts
; End of function sub_13120

; -----------------------------------------------------------------------------------------
; START	OF FUNCTION CHUNK FOR sub_12FAE

loc_13142:
	movem.l	a3,-(sp)
	clr.w	d0
	move.b	6(a2),d0
	jsr	RandomBound
	lsl.w	#2,d0
	movea.l	off_1317C(pc,d0.w),a3
	bsr.w	sub_13006
	bcc.w	loc_13168
	movem.l	(sp)+,a3
	clr.b	d3
	rts
; -----------------------------------------------------------------------------------------

loc_13168:
	bsr.w	sub_130AC
	move.b	#$FF,1(a6)
	movem.l	(sp)+,a3
	movem.l	(sp)+,a3
	rts
; END OF FUNCTION CHUNK	FOR sub_12FAE
; -----------------------------------------------------------------------------------------
off_1317C
	dc.l	byte_13226
	dc.l	byte_13232
	dc.l	byte_13240
	dc.l	byte_1324E
	dc.l	byte_131EA
	dc.l	byte_131F8
	dc.l	byte_13208
	dc.l	byte_13218
	dc.l	byte_131DA
	dc.l	byte_131CA
	dc.l	byte_131BA
	dc.l	byte_131AC
byte_131AC
	dc.b	3
	dc.b	5
	dc.b	0
	dc.b	$22
	dc.b	$10
	dc.b	$10
	dc.b	$11
	dc.b	$FF
	dc.b	$10
	dc.b	0
	dc.b	$13
	dc.b	$23
	dc.b	$22
	dc.b	$FF
byte_131BA
	dc.b	3
	dc.b	6
	dc.b	$22
	dc.b	1
	dc.b	$10
	dc.b	$31
	dc.b	0
	dc.b	$21
	dc.b	$FF
	dc.b	$11
	dc.b	1
	dc.b	$23
	dc.b	$13
	dc.b	2
	dc.b	$22
	dc.b	$FF
byte_131CA
	dc.b	3
	dc.b	6
	dc.b	0
	dc.b	1
	dc.b	$12
	dc.b	$34
	dc.b	$10
	dc.b	$12
	dc.b	$FF
	dc.b	2
	dc.b	$10
	dc.b	$11
	dc.b	$22
	dc.b	$10
	dc.b	0
	dc.b	$FF
byte_131DA
	dc.b	3
	dc.b	6
	dc.b	0
	dc.b	$23
	dc.b	$12
	dc.b	$10
	dc.b	$10
	dc.b	$31
	dc.b	$FF
	dc.b	0
	dc.b	$13
	dc.b	$22
	dc.b	$10
	dc.b	$23
	dc.b	$11
	dc.b	$FF
byte_131EA
	dc.b	3
	dc.b	5
	dc.b	0
	dc.b	$11
	dc.b	2
	dc.b	$31
	dc.b	$10
	dc.b	$FF
	dc.b	$11
	dc.b	$22
	dc.b	0
	dc.b	1
	dc.b	$23
	dc.b	$FF
byte_131F8
	dc.b	3
	dc.b	5
	dc.b	$11
	dc.b	$21
	dc.b	0
	dc.b	3
	dc.b	$40
	dc.b	$21
	dc.b	$FF
	dc.b	$11
	dc.b	$11
	dc.b	0
	dc.b	$13
	dc.b	1
	dc.b	$20
	dc.b	$FF
byte_13208
	dc.b	3
	dc.b	5
	dc.b	0
	dc.b	$21
	dc.b	1
	dc.b	1
	dc.b	$30
	dc.b	$14
	dc.b	$FF
	dc.b	1
	dc.b	$13
	dc.b	$11
	dc.b	$11
	dc.b	2
	dc.b	0
	dc.b	$FF
byte_13218
	dc.b	3
	dc.b	5
	dc.b	1
	dc.b	$22
	dc.b	$10
	dc.b	1
	dc.b	$10
	dc.b	$FF
	dc.b	$23
	dc.b	$22
	dc.b	1
	dc.b	$13
	dc.b	0
	dc.b	$FF
byte_13226
	dc.b	2
	dc.b	6
	dc.b	1
	dc.b	1
	dc.b	0
	dc.b	$11
	dc.b	$FF
	dc.b	0
	dc.b	1
	dc.b	0
	dc.b	$10
	dc.b	$FF
byte_13232
	dc.b	2
	dc.b	6
	dc.b	$20
	dc.b	$10
	dc.b	1
	dc.b	1
	dc.b	$13
	dc.b	$FF
	dc.b	$12
	dc.b	$13
	dc.b	1
	dc.b	2
	dc.b	$13
	dc.b	$FF
byte_13240
	dc.b	2
	dc.b	6
	dc.b	0
	dc.b	1
	dc.b	$12
	dc.b	$13
	dc.b	$10
	dc.b	$FF
	dc.b	2
	dc.b	0
	dc.b	$12
	dc.b	$13
	dc.b	$10
	dc.b	$FF
byte_1324E
	dc.b	2
	dc.b	6
	dc.b	0
	dc.b	$11
	dc.b	0
	dc.b	$21
	dc.b	$13
	dc.b	$FF
	dc.b	1
	dc.b	$10
	dc.b	$13
	dc.b	$13
	dc.b	0
	dc.b	$FF

; =============== S U B	R O U T	I N E =====================================================


sub_1325C:
	lea	(sub_13274).l,a1
	jsr	FindActorSlot
	lea	(loc_132E4).l,a1
	jmp	FindActorSlot
; End of function sub_1325C


; =============== S U B	R O U T	I N E =====================================================


sub_13274:
	move.b	#$80,6(a0)
	move.b	#$26,8(a0)
	move.w	#$120,$A(a0)
	move.w	#$150,$E(a0)
	move.l	#byte_132BC,$32(a0)
	jsr	(ActorBookmark).l
	clr.w	d0
	move.b	(byte_FF1D0D).l,d0
	beq.w	loc_132B6
	andi.b	#$7F,d0
	move.l	off_132C0(pc,d0.w),$32(a0)
	clr.b	(byte_FF1D0D).l

loc_132B6:
	jmp	(ActorAnimate).l
; End of function sub_13274

; -----------------------------------------------------------------------------------------
byte_132BC
	dc.b	0
	dc.b	2
	dc.b	$FE
	dc.b	0
off_132C0
	dc.l	byte_132CC
	dc.l	byte_132D4
	dc.l	byte_132DC
byte_132CC
	dc.b	2
	dc.b	4
	dc.b	$FF
	dc.b	0
	dc.l	byte_132BC
byte_132D4
	dc.b	8
	dc.b	3
	dc.b	$FF
	dc.b	0
	dc.l	byte_132BC
byte_132DC
	dc.b	8
	dc.b	5
	dc.b	$FF
	dc.b	0
	dc.l	byte_132BC
; -----------------------------------------------------------------------------------------

loc_132E4:
	move.b	#$80,6(a0)
	move.b	#$26,8(a0)
	move.w	#$150,$A(a0)
	move.w	#$150,$E(a0)
	move.l	#byte_1332C,$32(a0)
	jsr	(ActorBookmark).l
	tst.b	(byte_FF1D0C).l
	beq.w	loc_13322
	move.l	#byte_13328,$32(a0)
	clr.b	(byte_FF1D0C).l

loc_13322:
	jmp	(ActorAnimate).l
; -----------------------------------------------------------------------------------------
byte_13328
	dc.b	1
	dc.b	0
	dc.b	8
	dc.b	1
byte_1332C
	dc.b	0
	dc.b	0
	dc.b	$FE
	dc.b	0
; -----------------------------------------------------------------------------------------

loc_13330:
	lea	puyo_order_1,a1
	lea	(unk_13342).l,a2

loc_1333C:
	move.b	(a2)+,(a1)+
	bpl.s	loc_1333C
	rts
; -----------------------------------------------------------------------------------------
unk_13342
	dc.b	1
	dc.b	0
	dc.b	1
	dc.b	3
	dc.b	4
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	3
	dc.b	0
	dc.b	5
	dc.b	3
	dc.b	0
	dc.b	4
	dc.b	3
	dc.b	4
	dc.b	3
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	4
	dc.b	5
	dc.b	5
	dc.b	0
	dc.b	0
	dc.b	5
	dc.b	5
	dc.b	5
	dc.b	5
	dc.b	1
	dc.b	1
	dc.b	5
	dc.b	5
	dc.b	3
	dc.b	3
	dc.b	3
	dc.b	4
	dc.b	3
	dc.b	5
	dc.b	5
	dc.b	5
	dc.b	4
	dc.b	5
	dc.b	1
	dc.b	1
	dc.b	1
	dc.b	4
	dc.b	1
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	4
	dc.b	0
	dc.b	1
	dc.b	4
	dc.b	1
	dc.b	5
	dc.b	1
	dc.b	5
	dc.b	1
	dc.b	4
	dc.b	4
	dc.b	4
	dc.b	5
	dc.b	5
	dc.b	0
	dc.b	0
	dc.b	5
	dc.b	0
	dc.b	5
	dc.b	0
	dc.b	4
	dc.b	5
	dc.b	3
	dc.b	4
	dc.b	3
	dc.b	4
	dc.b	4
	dc.b	5
	dc.b	3
	dc.b	3
	dc.b	3
	dc.b	4
	dc.b	3
	dc.b	4
	dc.b	3
	dc.b	4
	dc.b	$FF
	dc.b	0
; -----------------------------------------------------------------------------------------

loc_1339C:
	move.w	#$CB3E,p1_score_vram
	clr.w	(word_FF196E).l
	clr.w	time_frames
	clr.b	byte_FF1965
	jsr	(ClearScroll).l
	move.w	#$8B00,d0
	move.b	vdp_reg_b,d0
	ori.b	#4,d0
	move.b	d0,vdp_reg_b
	lea	(loc_133FA).l,a1
	jsr	FindActorSlot
	move.b	#0,$2A(a1)
	move.l	#$80010000,d0
	jsr	QueuePlaneCmd
	jsr	(SpawnGarbagePuyoAnim).l
	jmp	(sub_1325C).l
; -----------------------------------------------------------------------------------------

loc_133FA:
	clr.l	d0
	jsr	(AddComboDraw).l

	jsr	(ResetPuyoField).l
	move.w	#0,d3
	move.w	#$FF38,d4
	jsr	(loc_44EE).l
	DISABLE_INTS
	jsr	(sub_5782).l
	ENABLE_INTS
	jsr	(ActorBookmark).l
	clr.b	(byte_FF0104).l
	move.b	#7,8(a0)
	jsr	(loc_9CF8).l
	jsr	(ActorBookmark).l

loc_13442:
	clr.w	puyos_popping
	cmpi.b	#9,(word_FF196E+1).l
	bcs.w	loc_13476
	move.w	#$20,d0
	jsr	(ActorBookmark_SetDelay).l
	jsr	(ActorBookmark).l
	clr.b	bytecode_flag
	clr.b	(bytecode_disabled).l
	jmp	(ActorDeleteSelf).l
; -----------------------------------------------------------------------------------------

loc_13476:
	clr.b	9(a0)
	bsr.w	sub_13610
	bsr.w	sub_1362C
	jsr	(SpawnGarbage).l
	jsr	(ActorBookmark).l
	btst	#2,7(a0)
	beq.w	loc_1349A
	rts
; -----------------------------------------------------------------------------------------

loc_1349A:
	jsr	SpawnFallingPuyos
	bcs.w	loc_1358A
	jsr	(ActorBookmark).l
	move.b	7(a0),d0
	andi.b	#3,d0
	beq.w	loc_134D0
	btst	#3,7(a0)
	bne.w	loc_134C2
	rts
; -----------------------------------------------------------------------------------------

loc_134C2:
	bclr	#3,7(a0)
	moveq	#1,d0
	jmp	(AddComboDraw).l
; -----------------------------------------------------------------------------------------

loc_134D0:
	jsr	(sub_5960).l
	move.w	d1,$26(a0)
	jsr	(ActorBookmark).l
	DISABLE_INTS
	jsr	(sub_5782).l
	ENABLE_INTS
	move.w	#2,d0
	jsr	(ActorBookmark_SetDelay).l
	jsr	(ActorBookmark).l
	tst.w	$26(a0)
	beq.w	loc_13442
	jsr	(sub_58C8).l
	jsr	(sub_9A56).l
	jsr	(sub_9A40).l
	jsr	(ActorBookmark).l
	jsr	(sub_49BA).l
	move.w	#$18,d0
	jsr	(ActorBookmark_SetDelay).l
	jsr	(sub_49D2).l
	jsr	(ActorBookmark).l
	jsr	(CheckPuyoPop).l
	move.w	#$18,d0
	jsr	(ActorBookmark_SetDelay).l
	jsr	(ActorBookmark).l
	jsr	(sub_4DB8).l
	bset	#4,7(a0)
	jsr	(ActorBookmark).l
	btst	#4,7(a0)
	beq.w	loc_13572
	jmp	(loc_4E14).l
; -----------------------------------------------------------------------------------------

loc_13572:
	jsr	(sub_9BBA).l
	addq.b	#1,9(a0)
	bcc.w	loc_13586
	move.b	#$FF,9(a0)

loc_13586:
	bra.w	loc_134D0
; -----------------------------------------------------------------------------------------

loc_1358A:
	move.b	#$FF,puyos_popping
	move.w	#5,(word_FF196E).l
	jsr	(sub_7926).l
	move.b	#SFX_LOSE,d0
	jsr	PlaySound_ChkSamp
	jsr	(ActorBookmark).l
	tst.w	$26(a0)
	beq.w	loc_135BA
	rts
; -----------------------------------------------------------------------------------------

loc_135BA:
	jsr	(ResetPuyoField).l
	DISABLE_INTS
	jsr	(sub_5782).l
	ENABLE_INTS
	jsr	(GetPuyoField).l
	andi.w	#$7F,d0
	move.w	#5,d1
	lea	(vscroll_buffer).l,a2

loc_135E2:
	clr.l	(a2,d0.w)
	addq.w	#4,d0
	dbf	d1,loc_135E2
	move.w	#$E0,d0
	jsr	(ActorBookmark_SetDelay).l
	jsr	(ActorBookmark).l
	move.w	#$8400,d0
	swap	d0
	move.b	#5,d0
	jsr	QueuePlaneCmd
	bra.w	loc_13442

; =============== S U B	R O U T	I N E =====================================================


sub_13610:
	tst.b	(word_FF196E).l
	beq.w	loc_1361C
	rts
; -----------------------------------------------------------------------------------------

loc_1361C:
	clr.w	d0
	move.b	(word_FF196E+1).l,d0
	addq.b	#7,d0
	jmp	(sub_FF4A).l
; End of function sub_13610


; =============== S U B	R O U T	I N E =====================================================


sub_1362C:
	clr.w	d0
	move.b	(word_FF196E+1).l,d0
	addq.b	#1,(word_FF196E+1).l
	lsl.w	#2,d0
	movea.l	off_13642(pc,d0.w),a1
	jmp	(a1)
; End of function sub_1362C

; -----------------------------------------------------------------------------------------
off_13642
	dc.l	loc_13666
	dc.l	loc_136B6
	dc.l	loc_13712
	dc.l	loc_13756
	dc.l	loc_1376A
	dc.l	loc_1378C
	dc.l	loc_137FE
	dc.l	loc_138F0
	dc.l	loc_138F6
; -----------------------------------------------------------------------------------------

loc_13666:
	lea	(loc_13686).l,a1
	jsr	FindActorSlot
	bcc.w	loc_13678
	rts
; -----------------------------------------------------------------------------------------

loc_13678:
	move.l	a0,$2E(a1)
	move.l	#unk_136A2,$32(a1)
	rts
; -----------------------------------------------------------------------------------------

loc_13686:
	jsr	(ActorAnimate).l
	bcc.w	loc_13696
	jmp	(ActorDeleteSelf).l
; -----------------------------------------------------------------------------------------

loc_13696:
	movea.l	$2E(a0),a1
	move.b	9(a0),$20(a1)
	rts
; -----------------------------------------------------------------------------------------
unk_136A2
	dc.b	$40
	dc.b	2
	dc.b	$10
	dc.b	1
	dc.b	$10
	dc.b	2
	dc.b	$C
	dc.b	3
	dc.b	$C
	dc.b	4
	dc.b	$30
	dc.b	5
	dc.b	$C
	dc.b	4
	dc.b	$C
	dc.b	3
	dc.b	0
	dc.b	2
	dc.b	$FE
	dc.b	0
; -----------------------------------------------------------------------------------------

loc_136B6:
	move.b	#2,$20(a0)
	lea	(loc_136DC).l,a1
	jsr	FindActorSlot
	bcc.w	loc_136CE
	rts
; -----------------------------------------------------------------------------------------

loc_136CE:
	move.l	a0,$2E(a1)
	move.l	#unk_136F8,$32(a1)
	rts
; -----------------------------------------------------------------------------------------

loc_136DC:
	jsr	(ActorAnimate).l
	bcc.w	loc_136EC
	jmp	(ActorDeleteSelf).l
; -----------------------------------------------------------------------------------------

loc_136EC:
	movea.l	$2E(a0),a1
	move.b	9(a0),$21(a1)
	rts
; -----------------------------------------------------------------------------------------
unk_136F8
	dc.b	$40
	dc.b	0
	dc.b	$10
	dc.b	1
	dc.b	$10
	dc.b	2
	dc.b	$10
	dc.b	3
	dc.b	$30
	dc.b	0
	dc.b	8
	dc.b	1
	dc.b	8
	dc.b	2
	dc.b	8
	dc.b	3
	dc.b	8
	dc.b	0
	dc.b	8
	dc.b	1
	dc.b	8
	dc.b	2
	dc.b	0
	dc.b	3
	dc.b	$FE
	dc.b	0
; -----------------------------------------------------------------------------------------

loc_13712:
	move.b	#4,$20(a0)
	move.b	#3,$21(a0)

loc_1371E:
	lea	(loc_1373C).l,a1
	jsr	FindActorSlot
	bcc.w	loc_13730
	rts
; -----------------------------------------------------------------------------------------

loc_13730:
	move.l	a0,$2E(a1)
	move.w	#$80,$26(a1)
	rts
; -----------------------------------------------------------------------------------------

loc_1373C:
	subq.w	#1,$26(a0)
	beq.w	loc_13746
	rts
; -----------------------------------------------------------------------------------------

loc_13746:
	movea.l	$2E(a0),a1
	move.b	#$80,$27(a1)
	jmp	(ActorDeleteSelf).l
; -----------------------------------------------------------------------------------------

loc_13756:
	move.b	#0,$27(a0)
	move.b	#3,$20(a0)
	move.b	#2,$21(a0)
	bra.s	loc_1371E
; -----------------------------------------------------------------------------------------

loc_1376A:
	move.b	#$80,$27(a0)
	addq.b	#1,(word_FF196E).l
	move.b	#4,(word_FF196E+1).l
	move.b	#2,$20(a0)
	move.b	#0,$21(a0)
	rts
; -----------------------------------------------------------------------------------------

loc_1378C:
	move.b	#0,$27(a0)
	jsr	(ResetPuyoField).l
	move.w	#$23,d0
	lea	(loc_137FE).l,a1

loc_137A2:
	move.b	#$FF,-(a2)
	move.b	-(a1),d1
	lsl.b	#4,d1
	move.b	d1,-(a2)
	dbf	d0,loc_137A2
	jsr	(sub_5960).l
	DISABLE_INTS
	jsr	(sub_5782).l
	ENABLE_INTS
	move.b	#0,$27(a0)
	move.b	#4,$20(a0)
	move.b	#0,$21(a0)
	bra.w	loc_1371E
; -----------------------------------------------------------------------------------------
	dc.b	0
	dc.b	9
	dc.b	0
	dc.b	$B
	dc.b	8
	dc.b	9
	dc.b	0
	dc.b	8
	dc.b	$C
	dc.b	$D
	dc.b	8
	dc.b	8
	dc.b	0
	dc.b	$C
	dc.b	$D
	dc.b	9
	dc.b	9
	dc.b	9
	dc.b	0
	dc.b	$C
	dc.b	$D
	dc.b	$D
	dc.b	$C
	dc.b	8
	dc.b	9
	dc.b	$C
	dc.b	9
	dc.b	$B
	dc.b	$C
	dc.b	8
	dc.b	8
	dc.b	8
	dc.b	8
	dc.b	$B
	dc.b	$B
	dc.b	$C
; -----------------------------------------------------------------------------------------

loc_137FE:
	move.b	#6,(word_FF196E+1).l
	clr.w	d0
	move.b	(word_FF196E).l,d0
	lsl.b	#2,d0
	addq.b	#1,(word_FF196E).l
	cmpi.b	#$1A,(word_FF196E).l
	bcs.w	loc_1382A
	move.w	#7,(word_FF196E).l

loc_1382A:
	move.b	byte_1386A(pc,d0.w),$20(a0)
	move.b	byte_1386B(pc,d0.w),$21(a0)
	move.b	#0,$27(a0)
	lea	(loc_138D2).l,a1
	jsr	FindActorSlotQuick
	bcs.w	loc_13856
	move.l	a0,$2E(a1)
	move.b	byte_1386C(pc,d0.w),$27(a1)

loc_13856:
	clr.w	d1
	move.b	byte_1386D(pc,d0.w),d1
	bmi.w	locret_13868
	move.w	d1,d0
	jsr	(sub_FF4A).l

locret_13868:
	rts
; -----------------------------------------------------------------------------------------
byte_1386A
	dc.b	4
byte_1386B
	dc.b	0
byte_1386C
	dc.b	$20
byte_1386D
	dc.b	$10
	dc.b	4
	dc.b	0
	dc.b	$20
	dc.b	$FF
	dc.b	3
	dc.b	2
	dc.b	$40
	dc.b	$11
	dc.b	3
	dc.b	1
	dc.b	$20
	dc.b	$12
	dc.b	3
	dc.b	0
	dc.b	$20
	dc.b	$FF
	dc.b	5
	dc.b	3
	dc.b	$40
	dc.b	$13
	dc.b	1
	dc.b	0
	dc.b	8
	dc.b	$14
	dc.b	1
	dc.b	0
	dc.b	8
	dc.b	$FF
	dc.b	1
	dc.b	1
	dc.b	8
	dc.b	$FF
	dc.b	2
	dc.b	0
	dc.b	8
	dc.b	$FF
	dc.b	2
	dc.b	0
	dc.b	8
	dc.b	$FF
	dc.b	3
	dc.b	0
	dc.b	8
	dc.b	$FF
	dc.b	3
	dc.b	0
	dc.b	8
	dc.b	$FF
	dc.b	3
	dc.b	1
	dc.b	8
	dc.b	$FF
	dc.b	4
	dc.b	0
	dc.b	8
	dc.b	$FF
	dc.b	4
	dc.b	0
	dc.b	$40
	dc.b	$15
	dc.b	2
	dc.b	3
	dc.b	$10
	dc.b	$16
	dc.b	2
	dc.b	1
	dc.b	$10
	dc.b	$FF
	dc.b	3
	dc.b	2
	dc.b	$10
	dc.b	$FF
	dc.b	3
	dc.b	3
	dc.b	$10
	dc.b	$FF
	dc.b	2
	dc.b	3
	dc.b	$10
	dc.b	$FF
	dc.b	4
	dc.b	0
	dc.b	$40
	dc.b	$FF
	dc.b	5
	dc.b	2
	dc.b	0
	dc.b	$FF
	dc.b	5
	dc.b	3
	dc.b	0
	dc.b	$FF
	dc.b	4
	dc.b	1
	dc.b	0
	dc.b	$FF
	dc.b	4
	dc.b	2
	dc.b	0
	dc.b	$FF
; -----------------------------------------------------------------------------------------

loc_138D2:
	tst.w	$26(a0)
	beq.w	loc_138E0
	subq.w	#1,$26(a0)
	rts
; -----------------------------------------------------------------------------------------

loc_138E0:
	movea.l	$2E(a0),a1
	move.b	#$80,$27(a1)
	jmp	(ActorDeleteSelf).l
; -----------------------------------------------------------------------------------------

loc_138F0:
	move.w	#$12,$14(a0)

loc_138F6:
	move.b	#8,(word_FF196E+1).l
	clr.w	d0
	move.b	(word_FF196E).l,d0
	lsl.b	#1,d0
	addq.b	#1,(word_FF196E).l
	cmpi.b	#4,(word_FF196E).l
	bcs.w	loc_13922
	move.b	#9,(word_FF196E+1).l

loc_13922:
	move.b	byte_13936(pc,d0.w),$20(a0)
	move.b	byte_13937(pc,d0.w),$21(a0)
	move.b	#$80,$27(a0)
	rts
; -----------------------------------------------------------------------------------------
byte_13936
	dc.b	1
byte_13937
	dc.b	1
	dc.b	2
	dc.b	1
	dc.b	2
	dc.b	1
	dc.b	1
	dc.b	2
; -----------------------------------------------------------------------------------------
	nop
; -----------------------------------------------------------------------------------------
SpriteMappings:
	dc.l	MapSpr_Unk00
	dc.l	MapSpr_Unk01
	dc.l	MapSpr_Unk02
	dc.l	MapSpr_Unk03
	dc.l	MapSpr_Unk04
	dc.l	MapSpr_Unk05
	dc.l	MapSpr_Unk06
	dc.l	MapSpr_Unk07
	dc.l	MapSpr_Unk08
	dc.l	MapSpr_Unk09
	dc.l	MapSpr_Unk0A
	dc.l	MapSpr_Unk0B
	dc.l	MapSpr_Unk0C
	dc.l	MapSpr_Unk09
	dc.l	MapSpr_Unk0E
	dc.l	MapSpr_Unk0F
	dc.l	MapSpr_Unk09
	dc.l	MapSpr_Unk11
	dc.l	MapSpr_Unk12
	dc.l	MapSpr_Unk13
	dc.l	MapSpr_Unk14
	dc.l	MapSpr_Unk09
	dc.l	MapSpr_Unk09
	dc.l	MapSpr_Unk17
	dc.l	MapSpr_Unk18
	dc.l	MapSpr_Unk19
	dc.l	MapSpr_Unk1A
	dc.l	MapSpr_Unk1B
	dc.l	MapSpr_Unk1C
	dc.l	MapSpr_Unk1D
	dc.l	MapSpr_Unk1E
	dc.l	MapSpr_Unk1F
	dc.l	MapSpr_Unk20
	dc.l	MapSpr_Difficulties
	dc.l	MapSpr_Unk22
	dc.l	MapSpr_Unk22
	dc.l	MapSpr_Unk24
	dc.l	MapSpr_Unk25
	dc.l	MapSpr_Unk26
	dc.l	MapSpr_Unk27
	dc.l	MapSpr_Unk28
	dc.l	MapSpr_Unk29
	dc.l	MapSpr_Unk2A
	dc.l	MapSpr_Unk2B
	dc.l	MapSpr_Unk2C
	dc.l	MapSpr_Unk2D
	dc.l	MapSpr_Unk2E
	dc.l	MapSpr_Unk2F
	dc.l	MapSpr_Unk2E
	dc.l	MapSpr_Unk31
	dc.l	MapSpr_Unk32
	dc.l	MapSpr_Unk09
	dc.l	MapSpr_Unk09
	dc.l	MapSpr_Unk09
	dc.l	MapSpr_Unk09
	dc.l	MapSpr_Unk09
	dc.l	MapSpr_Unk09
	dc.l	MapSpr_Unk09
	dc.l	MapSpr_Unk09
	dc.l	MapSpr_Unk09
	dc.l	MapSpr_Unk09
	dc.l	MapSpr_Unk09
	dc.l	MapSpr_Unk09
	dc.l	MapSpr_Unk09
	dc.l	MapSpr_Unk40
MapSpr_Unk2A
	dc.l	word_13A5C
	dc.l	word_13A6E
	dc.l	word_13A80
	dc.l	word_13A92
	dc.l	word_13AC4
	dc.l	word_13AF6
word_13A5C
	dc.w	2
	dc.w	$FFF8, $101, $2318, $FFF8
	dc.w	$FFF8, $101, $2B18, 0
word_13A6E
	dc.w	2
	dc.w	$FFF8, $101, $231A, $FFF8
	dc.w	$FFF8, $101, $2B1A, 0
word_13A80
	dc.w	2
	dc.w	$FFF8, $101, $2328, $FFF8
	dc.w	$FFF8, $101, $2B28, 0
word_13A92
	dc.w	6
	dc.w	0, $D00, $80, $FFD0
	dc.w	0, $D00, $88, $FFF0
	dc.w	0, $D00, $90, $10
	dc.w	$18, $D00, $C0, $FFD4
	dc.w	$18, $D00, $C8, $FFF4
	dc.w	$18, $D00, $D0, $14
word_13AC4
	dc.w	6
	dc.w	0, $D00, $80, $FFD0
	dc.w	0, $D00, $88, $FFF0
	dc.w	0, $500, $90, $10
	dc.w	$18, $D00, $C0, $FFD0
	dc.w	$18, $D00, $C8, $FFF0
	dc.w	$18, $D00, $D0, $10
word_13AF6
	dc.w	2
	dc.w	$FFF8, $103, $A318, $FFF8
	dc.w	$FFF8, $103, $AB18, 0
MapSpr_Unk28
	dc.l	word_13B18
	dc.l	word_13B5A
	dc.l	word_13B9C
	dc.l	word_13BCE
word_13B18
	dc.w	8
	dc.w	0, $A02, $C090, $18
	dc.w	8, $102, $C099, $10
	dc.w	$10, $302, $C09B, $30
	dc.w	$18, 2, $C09F, $38
	dc.w	$18, $F02, $C0A0, $10
	dc.w	$38, $802, $C0B0, $18
	dc.w	$40, $802, $C0B3, $10
	dc.w	$40, $402, $C0B6, $28
word_13B5A
	dc.w	8
	dc.w	0, $A02, $C0B8, $18
	dc.w	8, $102, $C099, $10
	dc.w	$10, $302, $C09B, $30
	dc.w	$18, 2, $C09F, $38
	dc.w	$18, $F02, $C0A0, $10
	dc.w	$38, $802, $C0B0, $18
	dc.w	$40, $802, $C0B3, $10
	dc.w	$40, $402, $C0B6, $28
word_13B9C
	dc.w	6
	dc.w	0, $E02, $A0C1, $10
	dc.w	8, 2, $A0CD, 8
	dc.w	$10, $502, $A0CE, 0
	dc.w	$18, $C02, $A0D2, $10
	dc.w	$20, $502, $A0D6, 8
	dc.w	$20, $902, $A0DA, $18
word_13BCE
	dc.w	6
	dc.w	0, $E02, $A0E0, $10
	dc.w	8, 2, $A0EC, 8
	dc.w	$10, $502, $A0CE, 0
	dc.w	$18, $802, $A0ED, $10
	dc.w	$20, $502, $A0D6, 8
	dc.w	$20, $902, $A0DA, $18
MapSpr_Unk24
	dc.l	word_13D28
	dc.l	word_13D32
	dc.l	word_13D3C
	dc.l	word_13D46
	dc.l	word_13D50
	dc.l	word_13D5A
	dc.l	word_13D64
	dc.l	word_13D76
	dc.l	word_13D80
	dc.l	word_13D8A
	dc.l	word_13D94
	dc.l	word_13D9E
	dc.l	word_13DA8
	dc.l	word_13DB2
	dc.l	word_13DBC
	dc.l	word_13DC6
	dc.l	word_13DD0
	dc.l	word_13DDA
	dc.l	word_13DE4
	dc.l	word_13DEE
	dc.l	word_13DF8
	dc.l	word_13E02
	dc.l	word_13E14
	dc.l	word_13E26
	dc.l	word_13E30
	dc.l	word_13E3A
	dc.l	word_13E44
	dc.l	word_13E4E
	dc.l	word_13E58
	dc.l	word_13E62
	dc.l	word_13E6C
	dc.l	word_13E76
	dc.l	word_13E88
	dc.l	word_13E92
	dc.l	word_13EAC
	dc.l	word_13ED6
	dc.l	word_13F00
	dc.l	word_13F12
	dc.l	word_13F1C
	dc.l	word_13F26
	dc.l	word_13F30
	dc.l	word_13F3A
	dc.l	word_13F44
	dc.l	word_13F4E
	dc.l	word_13F58
	dc.l	word_13F62
	dc.l	word_13F6C
	dc.l	word_13F76
	dc.l	word_13F80
	dc.l	word_13F8A
	dc.l	word_13F94
	dc.l	word_13F9E
	dc.l	word_13FB8
	dc.l	word_13FD2
	dc.l	word_13FDC
	dc.l	word_13FE6
	dc.l	word_13FF0
	dc.l	word_13FFA
	dc.l	word_14044
	dc.l	word_140A6
	dc.l	word_14108
	dc.l	word_14142
	dc.l	word_1418C
	dc.l	word_141CE
	dc.l	word_14208
	dc.l	word_14212
	dc.l	word_1421C
	dc.l	word_14226
	dc.l	word_14230
	dc.l	word_1423A
	dc.l	word_14244
	dc.l	word_1424E
	dc.l	word_14258
	dc.l	word_14262
word_13D28
	dc.w	1
	dc.w	0, $A02, $423B, 0
word_13D32
	dc.w	1
	dc.w	0, $A02, $4244, 0
word_13D3C
	dc.w	1
	dc.w	0, $A02, $424D, 0
word_13D46
	dc.w	1
	dc.w	0, $A02, $4256, 0
word_13D50
	dc.w	1
	dc.w	0, $A02, $425F, 0
word_13D5A
	dc.w	1
	dc.w	0, $A02, $4268, 0
word_13D64
	dc.w	2
	dc.w	0, $602, $4271, 0
	dc.w	8, $102, $4277, $10
word_13D76
	dc.w	1
	dc.w	8, $902, $4279, 0
word_13D80
	dc.w	1
	dc.w	0, $A02, $427F, 0
word_13D8A
	dc.w	1
	dc.w	0, $A02, $4288, 0
word_13D94
	dc.w	1
	dc.w	0, $A02, $4291, 0
word_13D9E
	dc.w	1
	dc.w	0, $A02, $429A, 0
word_13DA8
	dc.w	1
	dc.w	8, $902, $42A3, 0
word_13DB2
	dc.w	1
	dc.w	8, $902, $42A9, 0
word_13DBC
	dc.w	1
	dc.w	0, $A02, $42AF, 0
word_13DC6
	dc.w	1
	dc.w	0, $402, $22B8, 0
word_13DD0
	dc.w	1
	dc.w	0, $502, $22BA, 0
word_13DDA
	dc.w	1
	dc.w	8, 2, $22BE, 0
word_13DE4
	dc.w	1
	dc.w	0, $102, $22BF, 0
word_13DEE
	dc.w	1
	dc.w	0, $102, $22C1, 0
word_13DF8
	dc.w	1
	dc.w	8, 2, $22C3, 0
word_13E02
	dc.w	2
	dc.w	0, $A02, $42C4, 0
	dc.w	8, $102, $42CD, $18
word_13E14
	dc.w	2
	dc.w	0, $A02, $42CF, 0
	dc.w	8, $102, $42D8, $18
word_13E26
	dc.w	1
	dc.w	0, $A02, $42DA, 0
word_13E30
	dc.w	1
	dc.w	0, $302, $2E3, 0
word_13E3A
	dc.w	1
	dc.w	0, $302, $2E7, 0
word_13E44
	dc.w	1
	dc.w	0, $302, $2EB, 0
word_13E4E
	dc.w	1
	dc.w	0, $302, $2EF, 0
word_13E58
	dc.w	1
	dc.w	0, $A02, $62F3, 0
word_13E62
	dc.w	1
	dc.w	0, $A02, $62FC, 0
word_13E6C
	dc.w	1
	dc.w	0, $A02, $6305, 0
word_13E76
	dc.w	2
	dc.w	$10, $902, $30E, 8
	dc.w	$18, 2, $314, 0
word_13E88
	dc.w	1
	dc.w	$10, $D02, $315, 0
word_13E92
	dc.w	3
	dc.w	8, $C02, $31D, 0
	dc.w	$10, $902, $321, 0
	dc.w	$18, 2, $31C, $18
word_13EAC
	dc.w	5
	dc.w	0, $C02, $31D, 0
	dc.w	8, $802, $327, 0
	dc.w	$10, $502, $32A, 8
	dc.w	$18, 2, $322, 0
	dc.w	$18, 2, $31C, $18
word_13ED6
	dc.w	5
	dc.w	0, $502, $32E, $10
	dc.w	8, $402, $332, 0
	dc.w	$10, $502, $334, 8
	dc.w	$18, 2, $322, 0
	dc.w	$18, 2, $31C, $18
word_13F00
	dc.w	2
	dc.w	$10, $502, $338, $10
	dc.w	$18, $402, $33C, 0
word_13F12
	dc.w	1
	dc.w	8, $902, $633E, 0
word_13F1C
	dc.w	1
	dc.w	8, $902, $6344, 0
word_13F26
	dc.w	1
	dc.w	0, $A02, $634A, 0
word_13F30
	dc.w	1
	dc.w	0, 2, $238D, 0
word_13F3A
	dc.w	1
	dc.w	0, 2, $238E, 0
word_13F44
	dc.w	1
	dc.w	0, 2, $238F, 0
word_13F4E
	dc.w	1
	dc.w	0, 2, $2390, 0
word_13F58
	dc.w	1
	dc.w	0, 2, $2B8D, 0
word_13F62
	dc.w	1
	dc.b	0, 0, 0, 2
	dc.b	$23, $91, 0, 0
word_13F6C
	dc.w	1
	dc.w	8, 2, $392, 0
word_13F76
	dc.w	1
	dc.w	0, $102, $393, 0
word_13F80
	dc.w	1
	dc.w	0, $502, $395, 0
word_13F8A
	dc.w	1
	dc.w	0, $502, $399, 0
word_13F94
	dc.w	1
	dc.w	0, $502, $39D, 0
word_13F9E
	dc.w	3
	dc.w	0, $602, $3A1, 8
	dc.w	8, 2, $3A7, 0
	dc.w	8, $102, $3A8, $18
word_13FB8
	dc.w	3
	dc.w	0, $602, $3AA, 8
	dc.w	8, $102, $3B0, 0
	dc.w	8, $102, $3B2, $18
word_13FD2
	dc.w	1
	dc.w	0, $E02, $3B4, 0
word_13FDC
	dc.w	1
	dc.w	8, $902, $43C0, 0
word_13FE6
	dc.w	1
	dc.w	8, $902, $43C6, 0
word_13FF0
	dc.w	1
	dc.w	0, $A02, $43CC, 0
word_13FFA
	dc.w	9
	dc.w	$18, $302, $3D5, 8
	dc.w	$20, $302, $3D9, 0
	dc.w	$28, $F02, $3DD, $18
	dc.w	$30, $302, $3ED, $10
	dc.w	$38, $202, $3F1, 8
	dc.w	$40, $102, $3F4, 0
	dc.w	$40, $202, $3F6, $38
	dc.w	$48, $D02, $3F9, $18
	dc.w	$50, 2, $401, $10
word_14044
	dc.w	$C
	dc.w	$18, $302, $402, 8
	dc.w	$20, $302, $406, 0
	dc.w	$20, $B02, $40A, $18
	dc.w	$28, $302, $416, $10
	dc.w	$28, $302, $41A, $30
	dc.w	$30, $202, $41E, $38
	dc.w	$38, $102, $421, 8
	dc.w	$38, 2, $423, $40
	dc.w	$40, $102, $424, 0
	dc.w	$40, $902, $426, $18
	dc.w	$48, 2, $42C, $10
	dc.w	$48, 2, $42D, $30
word_140A6
	dc.w	$C
	dc.w	$10, $702, $42E, $18
	dc.w	$18, $702, $436, 8
	dc.w	$18, $302, $43E, $28
	dc.w	$20, $302, $442, 0
	dc.w	$20, $702, $446, $30
	dc.w	$28, $102, $44E, $40
	dc.w	$30, $602, $450, $18
	dc.w	$38, $402, $456, 8
	dc.w	$38, $102, $458, $28
	dc.w	$40, $102, $424, 0
	dc.w	$40, 2, $45A, $10
	dc.w	$40, 2, $44D, $30
word_14108
	dc.w	7
	dc.w	0, $B02, $45B, $20
	dc.w	8, $F02, $467, 0
	dc.w	$20, $802, $477, $20
	dc.w	$28, $D02, $47A, 0
	dc.w	$28, 2, $482, $20
	dc.w	$38, $402, $483, 0
	dc.w	$40, $102, $424, 0
word_14142
	dc.w	9
	dc.w	0, $B02, $485, $20
	dc.w	8, $B02, $467, 0
	dc.w	$10, $302, $491, $18
	dc.w	$20, $802, $495, $20
	dc.w	$28, $902, $47A, 0
	dc.w	$28, 2, $482, $20
	dc.w	$30, 2, $481, $18
	dc.w	$38, $402, $483, 0
	dc.w	$40, $102, $424, 0
word_1418C
	dc.w	8
	dc.w	8, $B02, $467, 0
	dc.w	8, $B02, $498, $20
	dc.w	$10, $302, $491, $18
	dc.w	$28, $902, $47A, 0
	dc.w	$28, 2, $482, $20
	dc.w	$30, 2, $481, $18
	dc.w	$38, $402, $483, 0
	dc.w	$40, $102, $424, 0
word_141CE
	dc.w	7
	dc.w	0, $F01, $4A4, $18
	dc.w	8, $B01, $467, 0
	dc.w	$20, $C01, $476, $18
	dc.w	$28, $D01, $47A, 0
	dc.w	$28, 1, $482, $20
	dc.w	$38, $401, $483, 0
	dc.w	$40, $101, $424, 0
word_14208
	dc.w	1
	dc.w	$FFFC, 1, $44B4, $FFFC
word_14212
	dc.w	1
	dc.w	$FFFC, 1, $44B5, $FFFC
word_1421C
	dc.w	1
	dc.w	$FFFC, 1, $4CB4, $FFFC
word_14226
	dc.w	1
	dc.w	$FFFC, 1, $4CB5, $FFFC
word_14230
	dc.w	1
	dc.w	$FFFC, 1, $54B4, $FFFC
word_1423A
	dc.w	1
	dc.w	$FFFC, 1, $54B5, $FFFC
word_14244
	dc.w	1
	dc.w	$FFFC, 1, $5CB4, $FFFC
word_1424E
	dc.w	1
	dc.w	$FFFC, 1, $5CB5, $FFFC
word_14258
	dc.w	1
	dc.w	0, $402, $4B6, 0
word_14262
	dc.w	9
	dc.w	0, $B03, $6353, $50
	dc.w	8, $303, $635F, $48
	dc.w	8, $103, $6363, $68
	dc.w	$10, $703, $6365, $30
	dc.w	$18, $D03, $636D, 0
	dc.w	$18, $703, $6375, $20
	dc.w	$18, $103, $637D, $40
	dc.w	$28, $B03, $637F, 8
	dc.w	$38, $103, $638B, $20
MapSpr_Unk27
	dc.l	word_144E4
	dc.l	word_1453E
	dc.l	word_145A8
	dc.l	word_145C2
	dc.l	word_145CC
	dc.l	word_145D6
	dc.l	word_145E0
	dc.l	word_145EA
	dc.l	word_145F4
	dc.l	word_145FE
	dc.l	word_14608
	dc.l	word_14612
	dc.l	word_1461C
	dc.l	word_14626
	dc.l	word_14630
	dc.l	word_1463A
	dc.l	word_14644
	dc.l	word_1464E
	dc.l	word_14344
	dc.l	word_1434E
	dc.l	word_14358
	dc.l	word_14362
	dc.l	word_1436C
	dc.l	word_14376
	dc.l	word_143E8
	dc.l	word_14452
	dc.l	word_1445C
	dc.l	word_14466
	dc.l	word_14470
	dc.l	word_1447A
	dc.l	word_14484
	dc.l	word_1448E
	dc.l	word_14498
	dc.l	word_144A2
	dc.l	word_144B4
	dc.l	word_144BE
	dc.l	word_144C8
	dc.l	word_144D2
word_14344
	dc.w	1
	dc.w	0, $502, $8142, 0
word_1434E
	dc.w	1
	dc.w	0, $502, $8146, 0
word_14358
	dc.w	1
	dc.w	0, $502, $814A, 0
word_14362
	dc.w	1
	dc.w	0, $501, $814E, 0
word_1436C
	dc.w	1
	dc.w	0, $501, $8152, 0
word_14376
	dc.w	$E
	dc.w	0, $B02, $E156, $20
	dc.w	8, $B02, $E19F, 8
	dc.w	8, $302, $E16E, $38
	dc.w	$10, $302, $E1AB, 0
	dc.w	$10, $302, $E1AF, $40
	dc.w	$10, $302, $E1B3, $50
	dc.w	$18, $302, $E1B7, $48
	dc.w	$18, $202, $E1BB, $58
	dc.w	$20, $B02, $E1BE, $20
	dc.w	$28, $902, $E1CA, 8
	dc.w	$28, $202, $E19A, $38
	dc.w	$30, $102, $E1D0, $40
	dc.w	$30, 2, $E1D2, $50
	dc.w	$38, 2, $E193, $48
word_143E8
	dc.w	$D
	dc.w	0, $B02, $E156, $20
	dc.w	8, $B02, $E162, 8
	dc.w	8, $302, $E16E, $38
	dc.w	$10, $302, $E1D3, 0
	dc.w	$10, $802, $E1D7, $40
	dc.w	$18, $302, $E17A, $40
	dc.w	$18, $602, $E1DA, $50
	dc.w	$20, $B02, $E184, $20
	dc.w	$20, $302, $E190, $48
	dc.w	$28, $902, $E1E0, 8
	dc.w	$28, $202, $E19A, $38
	dc.w	$30, 2, $E19D, $50
	dc.w	$38, 2, $E19E, $40
word_14452
	dc.w	1
	dc.w	0, $502, $E1E6, 0
word_1445C
	dc.w	1
	dc.w	0, $502, $E1EA, 0
word_14466
	dc.w	1
	dc.w	0, $502, $E1EE, 0
word_14470
	dc.w	1
	dc.w	0, $502, $E1F2, 0
word_1447A
	dc.w	1
	dc.w	0, $502, $E1F6, 0
word_14484
	dc.w	1
	dc.w	0, $501, $E1FA, 0
word_1448E
	dc.w	1
	dc.w	0, $501, $E1FE, 0
word_14498
	dc.w	1
	dc.w	0, $501, $E202, 0
word_144A2
	dc.w	2
	dc.w	0, $401, $E206, 0
	dc.w	8, 1, $E208, 0
word_144B4
	dc.w	1
	dc.w	0, $501, $F1FA, 0
word_144BE
	dc.w	1
	dc.w	0, $501, $F1FE, 0
word_144C8
	dc.w	1
	dc.w	0, $501, $F202, 0
word_144D2
	dc.w	2
	dc.w	8, $401, $F206, 0
	dc.w	0, 1, $F208, 0
word_144E4
	dc.w	$B
	dc.w	0, $B02, $8100, $18
	dc.w	8, $702, $810C, 8
	dc.w	8, $302, $8114, $30
	dc.w	8, $E02, $8118, $40
	dc.w	$10, $202, $8124, 0
	dc.w	$10, $302, $8127, $38
	dc.w	$20, $A02, $812B, $18
	dc.w	$20, $502, $8134, $40
	dc.w	$28, $602, $8138, 8
	dc.w	$28, $102, $813E, $30
	dc.w	$38, $402, $8140, $18
word_1453E
	dc.w	$D
	dc.w	0, $B02, $E156, $20
	dc.w	8, $B02, $E162, 8
	dc.w	8, $302, $E16E, $38
	dc.w	$10, $302, $E172, 0
	dc.w	$10, $C02, $E176, $40
	dc.w	$18, $302, $E17A, $40
	dc.w	$18, $602, $E17E, $50
	dc.w	$20, $B02, $E184, $20
	dc.w	$20, $302, $E190, $48
	dc.w	$28, $902, $E194, 8
	dc.w	$28, $202, $E19A, $38
	dc.w	$30, 2, $E19D, $50
	dc.w	$38, 2, $E19E, $40
word_145A8
	dc.w	3
	dc.w	0, $E01, $8254, $FFE4
	dc.w	0, $E01, $8260, 4
	dc.w	0, $601, $826C, $24
word_145C2
	dc.w	1
	dc.w	$FFFC, 3, $82E2, $FFFC
word_145CC
	dc.w	1
	dc.w	$FFFC, 3, $82E3, $FFFC
word_145D6
	dc.w	1
	dc.w	$FFFC, 3, $82E4, $FFFC
word_145E0
	dc.w	1
	dc.w	$FFFC, 3, $82E5, $FFFC
word_145EA
	dc.w	1
	dc.w	$FFFC, 3, $82E6, $FFFC
word_145F4
	dc.w	1
	dc.w	$FFFC, 3, $82E7, $FFFC
word_145FE
	dc.w	1
	dc.w	$FFFC, 3, $82E8, $FFFC
word_14608
	dc.w	1
	dc.w	$FFFC, 3, $82E9, $FFFC
word_14612
	dc.w	1
	dc.w	$FFFC, 3, $82EA, $FFFC
word_1461C
	dc.w	1
	dc.w	$FFFC, 3, $82EB, $FFFC
word_14626
	dc.w	1
	dc.w	$FFFC, 3, $82EC, $FFFC
word_14630
	dc.w	1
	dc.w	$FFFC, 3, $82ED, $FFFC
word_1463A
	dc.w	1
	dc.w	$FFFC, 3, $82EE, $FFFC
word_14644
	dc.w	1
	dc.w	$FFFC, 3, $82EF, $FFFC
word_1464E
	dc.w	1
	dc.w	$FFFC, 3, $82F0, $FFFC
MapSpr_Unk26
	dc.l	word_14670
	dc.l	word_1468A
	dc.l	word_146A4
	dc.l	word_146D6
	dc.l	word_14708
	dc.l	word_1473A
word_14670
	dc.w	3
	dc.w	$FFE4, $600, $A4C0, $FFF0
	dc.w	$FFE4, $600, $ACC0, 0
	dc.w	$FFD8, $400, $E4CC, $FFF8
word_1468A
	dc.w	3
	dc.w	$FFE4, $600, $A4C6, $FFF0
	dc.w	$FFE4, $600, $ACC6, 0
	dc.w	$FFD8, $400, $E4CE, $FFF8
word_146A4
	dc.w	6
	dc.w	$FFE3, $503, $E4FC, $FFF8
	dc.w	$FFF0, $502, $E4F4, $FFF8
	dc.w	$FFE4, $502, $E4EC, $FFE8
	dc.w	$FFE4, $502, $ECEC, 8
	dc.w	$FFDC, $201, $E4E6, $FFFC
	dc.w	$FFC5, $F00, $E4D0, $FFF0
word_146D6
	dc.w	6
	dc.w	$FFE3, $503, $E4FC, $FFF8
	dc.w	$FFF0, $502, $E4F4, $FFF8
	dc.w	$FFE4, $502, $E4F0, $FFE8
	dc.w	$FFE4, $502, $ECEC, 8
	dc.w	$FFDC, $601, $E4E0, $FFF8
	dc.w	$FFC5, $F00, $E4D0, $FFE8
word_14708
	dc.w	6
	dc.w	$FFE3, $503, $E4FC, $FFF8
	dc.w	$FFF0, $502, $E4F8, $FFF8
	dc.w	$FFE4, $502, $E4EC, $FFE8
	dc.w	$FFE4, $502, $ECEC, 8
	dc.w	$FFDC, $201, $E4E9, $FFFC
	dc.w	$FFC9, $F00, $E4D0, $FFF0
word_1473A
	dc.w	6
	dc.w	$FFE3, $503, $E4FC, $FFF8
	dc.w	$FFF0, $502, $E4F4, $FFF8
	dc.w	$FFE4, $502, $E4EC, $FFE8
	dc.w	$FFE4, $502, $ECF0, 8
	dc.w	$FFDC, $601, $ECE0, $FFF8
	dc.w	$FFC7, $F00, $E4D0, $FFF8
MapSpr_Unk25
	dc.l	word_1479C
	dc.l	word_147BA
	dc.l	word_147D8
	dc.l	word_147F6
	dc.l	word_147A6
	dc.l	word_147C4
	dc.l	word_147E2
	dc.l	word_14800
	dc.l	word_147B0
	dc.l	word_147CE
	dc.l	word_147EC
	dc.l	word_1480A
word_1479C
	dc.w	1
	dc.w	$FFF8, $502, $831C, $FFF8
word_147A6
	dc.w	1
	dc.w	$FFFC, 2, $8324, $FFFC
word_147B0
	dc.w	1
	dc.w	$FFFC, 2, $8326, $FFFC
word_147BA
	dc.w	1
	dc.w	$FFF8, $502, $8320, $FFF8
word_147C4
	dc.w	1
	dc.w	$FFFC, 2, $8325, $FFFC
word_147CE
	dc.w	1
	dc.w	$FFFC, 2, $8327, $FFFC
word_147D8
	dc.w	1
	dc.w	$FFF8, $502, $A31C, $FFF8
word_147E2
	dc.w	1
	dc.w	$FFFC, 2, $A324, $FFFC
word_147EC
	dc.w	1
	dc.w	$FFFC, 2, $A326, $FFFC
word_147F6
	dc.w	1
	dc.w	$FFF8, $502, $A320, $FFF8
word_14800
	dc.w	1
	dc.w	$FFFC, 2, $A325, $FFFC
word_1480A
	dc.w	1
	dc.w	$FFFC, 2, $A327, $FFFC
MapSpr_Unk07
	dc.l	byte_FF1446
	dc.l	byte_FF14E8
	dc.l	byte_FF158A
	dc.l	byte_FF162C
	dc.l	byte_FF16CE
	dc.l	byte_FF1770
	dc.l	byte_FF1812
	dc.l	byte_FF18B4
MapSpr_Unk22
	dc.l	word_14844
	dc.l	word_14844
	dc.l	word_14844
	dc.l	word_14844
word_14844
	dc.w	6
	dc.w	0, $F00, $E4F0, 0
	dc.w	0, $F00, $E4F0, $20
	dc.w	0, $700, $E4F0, $40
	dc.w	$20, $E00, $E4F0, 0
	dc.w	$20, $E00, $E4F0, $20
	dc.w	$20, $600, $E4F0, $40
MapSpr_Difficulties:
	dc.l	.Easiest
	dc.l	.Easy
	dc.l	.Normal
	dc.l	.Hard
	dc.l	.Hardest
.Easiest:
	dc.w	7
	dc.w	$FFF8, $102, $8588, $FFE4
	dc.w	$FFF8, $102, $8580, $FFEC
	dc.w	$FFF8, $102, $85A4, $FFF4
	dc.w	$FFF8, $102, $8590, $FFFC
	dc.w	$FFF8, $102, $8588, 4
	dc.w	$FFF8, $102, $85A4, $C
	dc.w	$FFF8, $102, $85A6, $14
.Easy:
	dc.w	4
	dc.w	$FFF8, $102, $8588, $FFF0
	dc.w	$FFF8, $102, $8580, $FFF8
	dc.w	$FFF8, $102, $85A4, 0
	dc.w	$FFF8, $102, $85B0, 8
.Normal:
	dc.w	6
	dc.w	$FFF8, $102, $859A, $FFE8
	dc.w	$FFF8, $102, $859C, $FFF0
	dc.w	$FFF8, $102, $85A2, $FFF8
	dc.w	$FFF8, $102, $8598, 0
	dc.w	$FFF8, $102, $8580, 8
	dc.w	$FFF8, $102, $8596, $10
.Hard:
	dc.w	4
	dc.w	$FFF8, $102, $858E, $FFF0
	dc.w	$FFF8, $102, $8580, $FFF8
	dc.w	$FFF8, $102, $85A2, 0
	dc.w	$FFF8, $102, $8586, 8
.Hardest:
	dc.w	7
	dc.w	$FFF8, $102, $858E, $FFE4
	dc.w	$FFF8, $102, $8580, $FFEC
	dc.w	$FFF8, $102, $85A2, $FFF4
	dc.w	$FFF8, $102, $8586, $FFFC
	dc.w	$FFF8, $102, $8588, 4
	dc.w	$FFF8, $102, $85A4, $C
	dc.w	$FFF8, $102, $85A6, $14
MapSpr_Unk20
	dc.l	word_1499C
	dc.l	word_149A6
	dc.l	word_149B0
	dc.l	word_149BA
	dc.l	word_149C4
	dc.l	word_149CE
	dc.l	word_149D8
	dc.l	word_149E2
	dc.l	word_149EC
	dc.l	word_149F6
word_1499C
	dc.w	1
	dc.w	0, 0, $E3F7, 0
word_149A6
	dc.w	1
	dc.w	0, 0, $E3F9, 0
word_149B0
	dc.w	1
	dc.w	0, 0, $E3FD, 0
word_149BA
	dc.w	1
	dc.w	0, 0, $E3FF, 0
word_149C4
	dc.w	1
	dc.w	0, $100, $E3F5, 0
word_149CE
	dc.w	1
	dc.w	0, 1, $E1F7, 0
word_149D8
	dc.w	1
	dc.w	0, 1, $E1F9, 0
word_149E2
	dc.w	1
	dc.w	0, 1, $E1FD, 0
word_149EC
	dc.w	1
	dc.w	0, 1, $E1FF, 0
word_149F6
	dc.w	1
	dc.w	0, $100, $E1F5, 0
MapSpr_Unk1F
	dc.l	word_14A20
	dc.l	word_14A2A
	dc.l	word_14A34
	dc.l	word_14A3E
	dc.l	word_14A48
	dc.l	word_14A52
	dc.l	word_14A5C
	dc.l	word_14A66
word_14A20
	dc.w	1
	dc.w	$FFF0, $A00, $E252, $FFF4
word_14A2A
	dc.w	1
	dc.w	$FFF0, $A01, $E25B, $FFF4
word_14A34
	dc.w	1
	dc.w	$FFF0, $A02, $E264, $FFF4
word_14A3E
	dc.w	1
	dc.w	$FFF0, $A03, $E26D, $FFF4
word_14A48
	dc.w	1
	dc.w	$FFF0, $A00, $E276, $FFF4
word_14A52
	dc.w	1
	dc.w	$FFF0, $A01, $E27F, $FFF4
word_14A5C
	dc.w	1
	dc.w	$FFF0, $A02, $E26D, $FFF4
word_14A66
	dc.w	1
	dc.w	$FFF0, $A03, $E288, $FFF4
MapSpr_Unk1E
	dc.l	word_14A98
	dc.l	word_14AA2
	dc.l	word_14AAC
	dc.l	word_14AB6
	dc.l	word_14AC0
	dc.l	word_14ACA
	dc.l	word_14AD4
	dc.l	word_14ADE
	dc.l	word_14AE8
	dc.l	word_14AF2
word_14A98
	dc.w	1
	dc.w	$FFFC, $100, $856C, 0
word_14AA2
	dc.w	1
	dc.w	$FFFC, $100, $856E, 0
word_14AAC
	dc.w	1
	dc.w	$FFFC, $100, $8570, 0
word_14AB6
	dc.w	1
	dc.w	$FFFC, $100, $8572, 0
word_14AC0
	dc.w	1
	dc.w	$FFFC, $100, $8574, 0
word_14ACA
	dc.w	1
	dc.w	$FFFC, $100, $8576, 0
word_14AD4
	dc.w	1
	dc.w	$FFFC, $100, $8578, 0
word_14ADE
	dc.w	1
	dc.w	$FFFC, $100, $857A, 0
word_14AE8
	dc.w	1
	dc.w	$FFFC, $100, $857C, 0
word_14AF2
	dc.w	1
	dc.w	$FFFC, $100, $857E, 0
	dc.l	word_14BB4
	dc.l	word_14BB4
	dc.l	word_14BB4
	dc.l	word_14BB4
	dc.l	word_14BB4
	dc.l	word_14BD6
	dc.l	word_14BF8
	dc.l	word_14BF8
	dc.l	word_14BF8
	dc.l	word_14BF8
	dc.l	word_14BF8
	dc.l	word_14BF8
	dc.l	word_14BF8
	dc.l	word_14BF8
	dc.l	word_14BF8
	dc.l	word_14BF8
	dc.l	word_14BF8
	dc.l	word_14BF8
	dc.l	word_14BF8
	dc.l	word_14C22
	dc.l	word_14C44
	dc.l	word_14C44
	dc.l	word_14C44
	dc.l	word_14C44
	dc.l	word_14C44
	dc.l	word_14C66
	dc.l	word_14C70
	dc.l	word_14C7A
	dc.l	word_14C84
	dc.l	word_14C96
	dc.l	word_14CA8
	dc.l	word_14CC2
	dc.l	word_14CDC
	dc.l	word_14CF6
	dc.l	word_14D10
	dc.l	word_14D22
	dc.l	word_14D3C
	dc.l	word_14D4E
	dc.l	word_14D68
	dc.l	word_14D82
	dc.l	word_14D9C
	dc.l	word_14DB6
	dc.l	word_14DD0
	dc.l	word_14DDA
	dc.l	word_14DE4
	dc.l	word_14DEE
word_14BB4
	dc.w	4
	dc.w	$FFC8, $F02, $8300, $FFE8
	dc.w	$FFC8, $302, $8310, 8
	dc.w	$FFE8, $E02, $8314, $FFE8
	dc.w	$FFE8, $202, $8320, 8
word_14BD6
	dc.w	4
	dc.w	$FFC8, $B02, $8323, $FFD8
	dc.w	$FFC8, $B02, $832F, $FFF0
	dc.w	$FFE8, 2, $833B, $FFE8
	dc.w	$FFE8, $E02, $833C, $FFF0
word_14BF8
	dc.w	5
	dc.w	$FFC8, $E02, $83A6, $FFE0
	dc.w	$FFC8, $202, $83B2, 0
	dc.w	$FFE0, $202, $83B5, $FFE0
	dc.w	$FFF8, $802, $83C4, $FFE0
	dc.w	$FFF0, $902, $83C7, $FFF8
word_14C22
	dc.w	4
	dc.w	$FFC8, $F02, $836B, $FFE0
	dc.w	$FFC8, $702, $837B, 0
	dc.w	$FFE8, $E02, $8383, $FFE0
	dc.w	$FFE8, $602, $838F, 0
word_14C44
	dc.w	4
	dc.w	$FFC8, $F02, $8348, $FFE8
	dc.w	$FFC8, $702, $8358, 8
	dc.w	$FFE8, $D02, $8360, $FFF0
	dc.w	$FFF8, $802, $8368, $FFF0
word_14C66
	dc.w	1
	dc.w	$FFD8, $101, $8397, 0
word_14C70
	dc.w	1
	dc.w	$FFD8, $401, $8399, $FFF8
word_14C7A
	dc.w	1
	dc.w	$FFD8, $401, $839B, $FFF8
word_14C84
	dc.w	2
	dc.w	$FFD8, $100, $8395, 0
	dc.w	$FFD8, 1, $839B, $FFF8
word_14C96
	dc.w	2
	dc.w	$FFE0, $602, $83B8, $FFE8
	dc.w	$FFE0, $902, $83BE, $FFF8
word_14CA8
	dc.w	3
	dc.w	$FFE0, 1, $83F2, $FFF8
	dc.w	$FFE0, $602, $83B8, $FFE8
	dc.w	$FFE0, $902, $83BE, $FFF8
word_14CC2
	dc.w	3
	dc.w	$FFD8, $401, $83E3, $FFF0
	dc.w	$FFE0, $602, $83B8, $FFE8
	dc.w	$FFE0, $902, $83BE, $FFF8
word_14CDC
	dc.w	3
	dc.w	$FFD8, $901, $83D7, $FFF0
	dc.w	$FFE0, $602, $83B8, $FFE8
	dc.w	$FFE0, $902, $83BE, $FFF8
word_14CF6
	dc.w	3
	dc.w	$FFD8, $901, $83DD, $FFF0
	dc.w	$FFE0, $602, $83B8, $FFE8
	dc.w	$FFE0, $902, $83BE, $FFF8
word_14D10
	dc.w	2
	dc.w	$FFE0, $602, $83B8, $FFE8
	dc.w	$FFE0, $902, $83EB, $FFF8
word_14D22
	dc.w	3
	dc.w	$FFE0, $602, $83B8, $FFE8
	dc.w	$FFE0, $902, $83EB, $FFF8
	dc.w	$FFE0, 1, $83F1, $FFF8
word_14D3C
	dc.w	2
	dc.w	$FFE0, $602, $83B8, $FFE8
	dc.w	$FFE0, $902, $83E5, $FFF8
word_14D4E
	dc.w	3
	dc.w	$FFE0, $602, $83B8, $FFE8
	dc.w	$FFE0, $902, $83E5, $FFF8
	dc.w	$FFE0, 1, $83F1, $FFF8
word_14D68
	dc.w	3
	dc.w	$FFE0, $602, $83B8, $FFE8
	dc.w	$FFE0, $902, $83EB, $FFF8
	dc.w	$FFD8, $401, $83E3, $FFF0
word_14D82
	dc.w	3
	dc.w	$FFE0, $602, $83B8, $FFE8
	dc.w	$FFE0, $902, $83E5, $FFF8
	dc.w	$FFD8, $401, $83E3, $FFF0
word_14D9C
	dc.w	3
	dc.w	$FFE0, $602, $83B8, $FFE8
	dc.w	$FFE0, $902, $83EB, $FFF8
	dc.w	$FFD8, $501, $83CD, $FFF0
word_14DB6
	dc.w	3
	dc.w	$FFE0, $602, $83D1, $FFE8
	dc.w	$FFE0, $902, $83EB, $FFF8
	dc.w	$FFD8, $501, $83CD, $FFF0
word_14DD0
	dc.w	1
	dc.w	$FFD8, $101, $83A3, 0
word_14DDA
	dc.w	1
	dc.w	$FFD8, $801, $83A0, $FFF8
word_14DE4
	dc.w	1
	dc.w	$FFD8, $801, $839D, $FFF8
word_14DEE
	dc.w	2
	dc.w	$FFD8, $101, $83A3, 0
	dc.w	$FFD8, 0, $83A5, 0
MapSpr_Unk1C
	dc.l	word_14E96
	dc.l	word_14EF0
	dc.l	word_14E30
	dc.l	word_14E42
	dc.l	word_14E54
	dc.l	word_14E1C
	dc.l	word_14E26
word_14E1C
	dc.w	1
	dc.w	$FFF8, 0, $C560, $FFF8
word_14E26
	dc.w	1
	dc.w	$FFF8, 0, $AD60, $FFF8
word_14E30
	dc.w	2
	dc.w	1, $C00, $85BA, 4
	dc.w	1, 0, $85BE, $24
word_14E42
	dc.w	2
	dc.w	1, $C00, $85BA, 0
	dc.w	1, 0, $85BF, $20
word_14E54
	dc.w	8
	dc.w	$FFFC, $100, $858A, $FFE8
	dc.w	$FFFC, $100, $85A2, $FFF0
	dc.w	$FFFC, $100, $8588, $FFF8
	dc.w	$FFFC, $100, $8588, 0
	dc.w	$FFFC, $100, $859E, $C
	dc.w	$FFFC, $100, $8596, $14
	dc.w	$FFFC, $100, $8580, $1C
	dc.w	$FFFC, $100, $85B0, $24
word_14E96
	dc.w	$B
	dc.w	$FFFC, $100, $8590, 0
	dc.w	$FFFC, $100, $859A, 8
	dc.w	$FFFC, $100, $85A4, $10
	dc.w	$FFFC, $100, $8588, $18
	dc.w	$FFFC, $100, $85A2, $20
	dc.w	$FFFC, $100, $85A6, $28
	dc.w	$FFFC, $100, $8584, $34
	dc.w	$FFFC, $100, $859C, $3C
	dc.w	$FFFC, $100, $8590, $44
	dc.w	$FFFC, $100, $859A, $4C
	dc.w	0, $400, $85B8, $54
word_14EF0
	dc.w	7
	dc.w	$FFF8, $100, $8524, $FFE0
	dc.w	$FFF8, $100, $853E, $FFE8
	dc.w	$FFF8, $100, $8538, $FFF0
	dc.w	$FFF8, $100, $8538, $FFF8
	dc.w	$FFF8, $100, $8546, 0
	dc.w	$FFF8, $100, $853E, $10
	dc.w	$FFF8, $100, $8534, $18
MapSpr_Unk29
	dc.l	word_14F36
	dc.l	word_14F78
	dc.l	word_14F8A
word_14F36
	dc.w	8
	dc.w	$FFF8, $100, $A522, $FFDC
	dc.w	$FFF8, $100, $A516, $FFE4
	dc.w	$FFF8, $100, $A52E, $FFEC
	dc.w	$FFF8, $100, $A51E, $FFF4
	dc.w	$FFF8, $100, $A532, 4
	dc.w	$FFF8, $100, $A540, $C
	dc.w	$FFF8, $100, $A51E, $14
	dc.w	$FFF8, $100, $A538, $1C
word_14F78
	dc.w	2
	dc.w	$FFF8, $D00, $A54C, $FFDC
	dc.w	$FFF8, $D00, $A554, 4
word_14F8A
	dc.w	2
	dc.w	$FFF8, $D00, $A55C, $FFDC
	dc.w	$FFF8, $D00, $A564, 4
MapSpr_Unk00
	dc.l	word_14FC0
	dc.l	word_14FD2
	dc.l	word_14FE4
	dc.l	word_14FF6
	dc.l	word_15008
	dc.l	word_15012
	dc.l	word_1501C
	dc.l	word_15026
	dc.l	word_15030
word_14FC0
	dc.w	2
	dc.w	$FFF8, $501, $100, $FFF8
	dc.w	$FFFE, $503, $614C, $FFFE
word_14FD2
	dc.w	2
	dc.w	$FFF8, $501, $148, $FFF8
	dc.w	$FFFE, $503, $614C, $FFFE
word_14FE4
	dc.w	2
	dc.w	$FFF8, $501, $140, $FFF8
	dc.w	$FFFE, $503, $614C, $FFFE
word_14FF6
	dc.w	2
	dc.w	$FFF8, $501, $144, $FFF8
	dc.w	$FFFE, $503, $614C, $FFFE
word_15008
	dc.w	1
	dc.w	$FFF8, $502, $31C, $FFF8
word_15012
	dc.w	1
	dc.w	$FFFC, 2, $324, $FFFC
word_1501C
	dc.w	1
	dc.w	$FFFC, 2, $326, $FFFC
word_15026
	dc.w	1
	dc.w	$FFFE, $503, $614C, $FFFE
word_15030
	dc.w	2
	dc.w	$FFF8, $501, $150, $FFF8
	dc.w	$FFFE, $503, $614C, $FFFE
MapSpr_Unk01
	dc.l	word_15066
	dc.l	word_15078
	dc.l	word_1508A
	dc.l	word_1509C
	dc.l	word_150AE
	dc.l	word_150B8
	dc.l	word_150C2
	dc.l	word_150CC
	dc.l	word_150D6
word_15066
	dc.w	2
	dc.w	$FFF8, $501, $154, $FFF8
	dc.w	$FFFE, $503, $61A0, $FFFE
word_15078
	dc.w	2
	dc.w	$FFF8, $501, $19C, $FFF8
	dc.w	$FFFE, $503, $61A0, $FFFE
word_1508A
	dc.w	2
	dc.w	$FFF8, $501, $194, $FFF8
	dc.w	$FFFE, $503, $61A0, $FFFE
word_1509C
	dc.w	2
	dc.w	$FFF8, $501, $198, $FFF8
	dc.w	$FFFE, $503, $61A0, $FFFE
word_150AE
	dc.w	1
	dc.w	$FFF8, $502, $320, $FFF8
word_150B8
	dc.w	1
	dc.w	$FFFC, 2, $325, $FFFC
word_150C2
	dc.w	1
	dc.w	$FFFC, 2, $327, $FFFC
word_150CC
	dc.w	1
	dc.w	$FFFE, $503, $61A0, $FFFE
word_150D6
	dc.w	2
	dc.w	$FFF8, $501, $1A4, $FFF8
	dc.w	$FFFE, $503, $61A0, $FFFE
MapSpr_Unk02
	dc.l	word_1535C
	dc.l	word_15366
	dc.l	word_15370
	dc.l	word_15382
	dc.l	word_15394
	dc.l	word_153AE
	dc.l	word_153B8
	dc.l	word_15154
	dc.l	word_15176
	dc.l	word_15198
	dc.l	word_151BA
	dc.l	word_151DC
	dc.l	word_151FE
	dc.l	word_15210
	dc.l	word_15222
	dc.l	word_15234
	dc.l	word_15246
	dc.l	word_15258
	dc.l	word_1527A
	dc.l	word_1529C
	dc.l	word_152BE
	dc.l	word_152E0
	dc.l	word_15302
	dc.l	word_15314
	dc.l	word_15326
	dc.l	word_15338
	dc.l	word_1534A
word_15154
	dc.w	4
	dc.w	$FFF8, 0, $81A8, $FFF8
	dc.w	0, 0, $91A8, $FFF8
	dc.w	$FFF8, 0, $89A8, 0
	dc.w	0, 0, $99A8, 0
word_15176
	dc.w	4
	dc.w	$FFF8, $400, $81A9, $FFF0
	dc.w	0, $400, $91A9, $FFF0
	dc.w	$FFF8, $400, $89A9, 0
	dc.w	0, $400, $99A9, 0
word_15198
	dc.w	4
	dc.w	$FFF0, $500, $81AB, $FFF0
	dc.w	0, $500, $91AB, $FFF0
	dc.w	$FFF0, $500, $89AB, 0
	dc.w	0, $500, $99AB, 0
word_151BA
	dc.w	4
	dc.w	$FFF0, $500, $81AF, $FFF0
	dc.w	0, $500, $91AF, $FFF0
	dc.w	$FFF0, $500, $89AF, 0
	dc.w	0, $500, $99AF, 0
word_151DC
	dc.w	4
	dc.w	$FFF8, 0, $81B3, $FFF8
	dc.w	0, 0, $91B3, $FFF8
	dc.w	$FFF8, 0, $89B3, 0
	dc.w	0, 0, $99B3, 0
word_151FE
	dc.w	2
	dc.w	$FFF8, $400, $81B4, $FFF8
	dc.w	0, $400, $99B4, $FFF8
word_15210
	dc.w	2
	dc.w	$FFF0, $D00, $81B6, $FFF0
	dc.w	0, $D00, $99B6, $FFF0
word_15222
	dc.w	2
	dc.w	$FFF0, $D00, $81BE, $FFF0
	dc.w	0, $D00, $99BE, $FFF0
word_15234
	dc.w	2
	dc.w	$FFF0, $D00, $81C6, $FFF0
	dc.w	0, $D00, $99C6, $FFF0
word_15246
	dc.w	2
	dc.w	$FFF0, $D00, $81CE, $FFF0
	dc.w	0, $D00, $99CE, $FFF0
word_15258
	dc.w	4
	dc.w	$FFF8, 0, $A1A8, $FFF8
	dc.w	0, 0, $B1A8, $FFF8
	dc.w	$FFF8, 0, $A9A8, 0
	dc.w	0, 0, $B9A8, 0
word_1527A
	dc.w	4
	dc.w	$FFF8, $400, $A1A9, $FFF0
	dc.w	0, $400, $B1A9, $FFF0
	dc.w	$FFF8, $400, $A9A9, 0
	dc.w	0, $400, $B9A9, 0
word_1529C
	dc.w	4
	dc.w	$FFF0, $500, $A1AB, $FFF0
	dc.w	0, $500, $B1AB, $FFF0
	dc.w	$FFF0, $500, $A9AB, 0
	dc.w	0, $500, $B9AB, 0
word_152BE
	dc.w	4
	dc.w	$FFF0, $500, $A1AF, $FFF0
	dc.w	0, $500, $B1AF, $FFF0
	dc.w	$FFF0, $500, $A9AF, 0
	dc.w	0, $500, $B9AF, 0
word_152E0
	dc.w	4
	dc.w	$FFF8, 0, $A1B3, $FFF8
	dc.w	0, 0, $B1B3, $FFF8
	dc.w	$FFF8, 0, $A9B3, 0
	dc.w	0, 0, $B9B3, 0
word_15302
	dc.w	2
	dc.w	$FFF8, $400, $A1B4, $FFF8
	dc.w	0, $400, $B9B4, $FFF8
word_15314
	dc.w	2
	dc.w	$FFF0, $D00, $A1B6, $FFF0
	dc.w	0, $D00, $B9B6, $FFF0
word_15326
	dc.w	2
	dc.w	$FFF0, $D00, $A1BE, $FFF0
	dc.w	0, $D00, $B9BE, $FFF0
word_15338
	dc.w	2
	dc.w	$FFF0, $D00, $A1C6, $FFF0
	dc.w	0, $D00, $B9C6, $FFF0
word_1534A
	dc.w	2
	dc.w	$FFF0, $D00, $A1CE, $FFF0
	dc.w	0, $D00, $B9CE, $FFF0
word_1535C
	dc.w	1
	dc.w	$FFF8, $500, $81DE, 0
word_15366
	dc.w	1
	dc.w	$FFF8, $900, $81E2, 0
word_15370
	dc.w	2
	dc.w	$FFF8, $900, $81E2, 0
	dc.w	$FFF8, $500, $81DE, $18
word_15382
	dc.w	2
	dc.w	$FFF8, $900, $81E2, 0
	dc.w	$FFF8, $900, $81E2, $18
word_15394
	dc.w	3
	dc.w	$FFF8, $900, $81E2, 0
	dc.w	$FFF8, $900, $81E2, $18
	dc.w	$FFF8, $500, $81DE, $30
word_153AE
	dc.w	1
	dc.w	$FFF8, $500, $81DA, 0
word_153B8
	dc.w	1
	dc.w	$FFF8, $500, $81D6, 0
MapSpr_Unk03
	dc.l	word_153E6
	dc.l	word_153F8
	dc.l	word_1540A
	dc.l	word_1541C
	dc.l	word_1542E
	dc.l	word_15438
	dc.l	word_15442
	dc.l	word_1544C
	dc.l	word_15456
word_153E6
	dc.w	2
	dc.w	$FFF8, $501, $41FC, $FFF8
	dc.w	$FFFE, $503, $6248, $FFFE
word_153F8
	dc.w	2
	dc.w	$FFF8, $501, $4244, $FFF8
	dc.w	$FFFE, $503, $6248, $FFFE
word_1540A
	dc.w	2
	dc.w	$FFF8, $501, $423C, $FFF8
	dc.w	$FFFE, $503, $6248, $FFFE
word_1541C
	dc.w	2
	dc.w	$FFF8, $501, $4240, $FFF8
	dc.w	$FFFE, $503, $6248, $FFFE
word_1542E
	dc.w	1
	dc.w	$FFF8, $502, $431C, $FFF8
word_15438
	dc.w	1
	dc.w	$FFFC, 2, $4324, $FFFC
word_15442
	dc.w	1
	dc.w	$FFFC, 2, $4326, $FFFC
word_1544C
	dc.w	1
	dc.w	$FFFE, $503, $6248, $FFFE
word_15456
	dc.w	2
	dc.w	$FFF8, $501, $424C, $FFF8
	dc.w	$FFFE, $503, $6248, $FFFE
MapSpr_Unk04
	dc.l	word_1548C
	dc.l	word_1549E
	dc.l	word_154B0
	dc.l	word_154C2
	dc.l	word_154D4
	dc.l	word_154DE
	dc.l	word_154E8
	dc.l	word_154F2
	dc.l	word_154FC
word_1548C
	dc.w	2
	dc.w	$FFF8, $501, $2250, $FFF8
	dc.w	$FFFE, $503, $629C, $FFFE
word_1549E
	dc.w	2
	dc.w	$FFF8, $501, $2298, $FFF8
	dc.w	$FFFE, $503, $629C, $FFFE
word_154B0
	dc.w	2
	dc.w	$FFF8, $501, $2290, $FFF8
	dc.w	$FFFE, $503, $629C, $FFFE
word_154C2
	dc.w	2
	dc.w	$FFF8, $501, $2294, $FFF8
	dc.w	$FFFE, $503, $629C, $FFFE
word_154D4
	dc.w	1
	dc.w	$FFF8, $502, $2320, $FFF8
word_154DE
	dc.w	1
	dc.w	$FFFC, 2, $2325, $FFFC
word_154E8
	dc.w	1
	dc.w	$FFFC, 2, $2327, $FFFC
word_154F2
	dc.w	1
	dc.w	$FFFE, $503, $629C, $FFFE
word_154FC
	dc.w	2
	dc.w	$FFF8, $501, $22A0, $FFF8
	dc.w	$FFFE, $503, $629C, $FFFE
MapSpr_Unk05
	dc.l	word_15532
	dc.l	word_15544
	dc.l	word_15556
	dc.l	word_15568
	dc.l	word_1557A
	dc.l	word_15584
	dc.l	word_1558E
	dc.l	word_15598
	dc.l	word_155A2
word_15532
	dc.w	2
	dc.w	$FFF8, $501, $22A4, $FFF8
	dc.w	$FFFE, $503, $62F0, $FFFE
word_15544
	dc.w	2
	dc.w	$FFF8, $501, $22EC, $FFF8
	dc.w	$FFFE, $503, $62F0, $FFFE
word_15556
	dc.w	2
	dc.w	$FFF8, $501, $22E4, $FFF8
	dc.w	$FFFE, $503, $62F0, $FFFE
word_15568
	dc.w	2
	dc.w	$FFF8, $501, $22E8, $FFF8
	dc.w	$FFFE, $503, $62F0, $FFFE
word_1557A
	dc.w	1
	dc.w	$FFF8, $502, $231C, $FFF8
word_15584
	dc.w	1
	dc.w	$FFFC, 2, $2324, $FFFC
word_1558E
	dc.w	1
	dc.w	$FFFC, 2, $2326, $FFFC
word_15598
	dc.w	1
	dc.w	$FFFE, $503, $62F0, $FFFE
word_155A2
	dc.w	2
	dc.w	$FFF8, $501, $22F4, $FFF8
	dc.w	$FFFE, $503, $62F0, $FFFE
MapSpr_Unk06
	dc.l	word_15866
	dc.l	word_15878
	dc.l	word_1588A
	dc.l	word_1589C
	dc.l	word_156A0
	dc.l	0
	dc.l	word_158AE
	dc.l	word_158B8
	dc.l	word_158C2
	dc.l	word_158CC
	dc.l	word_158FE
	dc.l	0
	dc.l	word_158D6
	dc.l	word_158E0
	dc.l	word_158EA
	dc.l	word_158F4
	dc.l	word_156EA
	dc.l	word_156F4
	dc.l	word_15716
	dc.l	word_15738
	dc.l	word_1575A
	dc.l	word_1576C
	dc.l	word_1577E
	dc.l	word_15798
	dc.l	word_157BA
	dc.l	0
	dc.l	word_157E4
	dc.l	word_157EE
	dc.l	word_15800
	dc.l	word_1581A
	dc.l	word_1583C
	dc.l	0
	dc.l	word_1563C
	dc.l	word_1566E
word_1563C
	dc.w	6
	dc.w	$FFFC, $100, $8534, $FFE8
	dc.w	$FFFC, $100, $8516, $FFF0
	dc.w	$FFFC, $100, $853E, $FFF8
	dc.w	$FFFC, $100, $853A, 0
	dc.w	$FFFC, $100, $851E, 8
	dc.w	$FFFC, $100, $851C, $10
word_1566E
	dc.w	6
	dc.w	$FFFC, $100, $A534, $FFE8
	dc.w	$FFFC, $100, $A516, $FFF0
	dc.w	$FFFC, $100, $A53E, $FFF8
	dc.w	$FFFC, $100, $A53A, 0
	dc.w	$FFFC, $100, $A51E, 8
	dc.w	$FFFC, $100, $A51C, $10
word_156A0
	dc.w	9
	dc.w	$FFFC, 0, $8201, $24
	dc.w	0, $F01, $8220, 0
	dc.w	0, $F01, $8230, $20
	dc.w	0, $F01, $8240, $40
	dc.w	0, $B01, $8250, $60
	dc.w	$20, $E01, $8260, 0
	dc.w	$20, $E01, $826C, $20
	dc.w	$20, $E01, $8278, $40
	dc.w	$20, $A01, $8284, $60
word_156EA
	dc.w	1
	dc.w	0, $D00, $E488, 0
word_156F4
	dc.w	4
	dc.w	$FFF4, 0, $4314, $FFF8
	dc.w	$FFF4, 0, $4B14, 0
	dc.w	$FFFC, 3, $4315, $FFF0
	dc.w	$FFFC, 3, $4B15, 8
word_15716
	dc.w	4
	dc.w	$FFF4, 0, $4314, $FFF8
	dc.w	$FFF4, 0, $4B14, 0
	dc.w	$FFFE, 3, $4316, $FFF0
	dc.w	$FFFE, 3, $4B16, 8
word_15738
	dc.w	4
	dc.w	$FFF4, 0, $4314, $FFF8
	dc.w	$FFF4, 0, $4B14, 0
	dc.w	0, 3, $4317, $FFF0
	dc.w	0, 3, $4B17, 8
word_1575A
	dc.w	2
	dc.w	$FFF8, $502, $42F8, $FFF8
	dc.w	$FFFE, $503, $6310, $FFFE
word_1576C
	dc.w	2
	dc.w	$FFF8, $502, $42F8, $FFF8
	dc.w	$FFE8, $502, $42F8, $FFF8
word_1577E
	dc.w	3
	dc.w	$FFF8, $502, $42F8, $FFF8
	dc.w	$FFE8, $502, $42F8, $FFF8
	dc.w	$FFD8, $502, $42F8, $FFF8
word_15798
	dc.w	4
	dc.w	$FFF8, $502, $42F8, $FFF8
	dc.w	$FFE8, $502, $42F8, $FFF8
	dc.w	$FFD8, $502, $42F8, $FFF8
	dc.w	$FFC8, $502, $42F8, $FFF8
word_157BA
	dc.w	5
	dc.w	$FFF8, $502, $42F8, $FFF8
	dc.w	$FFE8, $502, $42F8, $FFF8
	dc.w	$FFD8, $502, $42F8, $FFF8
	dc.w	$FFC8, $502, $42F8, $FFF8
	dc.w	$FFB8, $502, $42F8, $FFF8
word_157E4
	dc.w	2
	dc.w	$FFFE, $503, $6310, $FFFE
word_157EE
	dc.w	2
	dc.w	$FFFE, $503, $6310, $FFFE
	dc.w	$FFEE, $503, $6310, $FFFE
word_15800
	dc.w	3
	dc.w	$FFFE, $503, $6310, $FFFE
	dc.w	$FFEE, $503, $6310, $FFFE
	dc.w	$FFDE, $503, $6310, $FFFE
word_1581A
	dc.w	4
	dc.w	$FFFE, $503, $6310, $FFFE
	dc.w	$FFEE, $503, $6310, $FFFE
	dc.w	$FFDE, $503, $6310, $FFFE
	dc.w	$FFCE, $503, $6310, $FFFE
word_1583C
	dc.w	5
	dc.w	$FFFE, $503, $6310, $FFFE
	dc.w	$FFEE, $503, $6310, $FFFE
	dc.w	$FFDE, $503, $6310, $FFFE
	dc.w	$FFCE, $503, $6310, $FFFE
	dc.w	$FFBE, $503, $6310, $FFFE
word_15866
	dc.w	2
	dc.w	$FFF8, $502, $42F8, $FFF8
	dc.w	$FFFE, $503, $6310, $FFFE
word_15878
	dc.w	2
	dc.w	$FFF8, $502, $42FC, $FFF8
	dc.w	$FFFE, $503, $6310, $FFFE
word_1588A
	dc.w	2
	dc.w	$FFF8, $502, $4300, $FFF8
	dc.w	$FFFE, $503, $6310, $FFFE
word_1589C
	dc.w	2
	dc.w	$FFF8, $502, $4304, $FFF8
	dc.w	$FFFE, $503, $6310, $FFFE
word_158AE
	dc.w	1
	dc.w	$FFFE, $503, $6310, $FFFE
word_158B8
	dc.w	1
	dc.w	$FFFE, $503, $6310, $FFFE
word_158C2
	dc.w	1
	dc.w	$FFFE, $503, $6310, $FFFE
word_158CC
	dc.w	1
	dc.w	$FFFE, $503, $6310, $FFFE
word_158D6
	dc.w	1
	dc.w	$FFF8, $500, $E0F8, $FFF8
word_158E0
	dc.w	1
	dc.w	$FFF8, $500, $E0FC, $FFF8
word_158EA
	dc.w	1
	dc.w	$FFFC, 0, $832A, $FFFC
word_158F4
	dc.w	1
	dc.w	$FFFC, 3, $832A, $FFFC
word_158FE
	dc.w	1
	dc.w	$FFFC, 3, $32A, $FFFC
MapSpr_Unk19
	dc.l	word_15A2A
	dc.l	word_15A34
	dc.l	word_15A3E
	dc.l	word_15A48
	dc.l	word_15A52
	dc.l	word_15A5C
	dc.l	word_15A66
	dc.l	word_15A70
	dc.l	word_15A7A
	dc.l	word_15A84
	dc.l	word_15A8E
	dc.l	word_15A98
	dc.l	word_15AA2
	dc.l	word_15AAC
	dc.l	word_15AB6
	dc.l	word_15AC0
	dc.l	word_15ACA
	dc.l	word_15AD4
	dc.l	word_15ADE
	dc.l	word_15AE8
	dc.l	word_15AF2
	dc.l	word_15AFC
	dc.l	word_15B06
	dc.l	word_15B10
	dc.l	word_15B10
	dc.l	word_15B1A
	dc.l	word_15B24
	dc.l	word_15B2E
	dc.l	word_15B38
	dc.l	word_15B42
	dc.l	word_15B4C
	dc.l	word_15B56
	dc.l	word_15B60
	dc.l	word_15B6A
	dc.l	word_15B74
	dc.l	word_15B86
	dc.l	word_15B98
	dc.l	word_15BA2
	dc.l	word_15BAC
	dc.l	word_15BB6
	dc.l	word_15BC0
	dc.l	word_15BCA
	dc.l	word_15BD4
	dc.l	word_15BDE
	dc.l	word_15BE8
	dc.l	word_15BF2
	dc.l	word_15BFC
	dc.l	word_15C06
	dc.l	word_15C10
	dc.l	word_15C1A
	dc.l	word_15C24
	dc.l	word_15C2E
	dc.l	word_15C38
	dc.l	word_15C42
	dc.l	word_15C4C
	dc.l	word_15C56
	dc.l	word_15C60
	dc.l	word_15C6A
	dc.l	word_15C74
	dc.l	word_15C7E
	dc.l	word_15C88
	dc.l	word_15C92
	dc.l	word_15C9C
	dc.l	word_15CA6
	dc.l	word_15AAC
	dc.l	word_15A48
	dc.l	word_15A66
	dc.l	word_15A84
	dc.l	word_15A84
	dc.l	word_15A20
word_15A20
	dc.w	1
	dc.w	$FFF8, $500, $400, $FFF8
word_15A2A
	dc.w	1
	dc.w	$FFF8, $500, $8400, $FFF8
word_15A34
	dc.w	1
	dc.w	$FFF8, $500, $8404, $FFF8
word_15A3E
	dc.w	1
	dc.w	$FFF8, $500, $8408, $FFF8
word_15A48
	dc.w	1
	dc.w	$FFF8, $500, $840C, $FFF8
word_15A52
	dc.w	1
	dc.w	$FFF8, $500, $8410, $FFF8
word_15A5C
	dc.w	1
	dc.w	$FFF8, $500, $8414, $FFF8
word_15A66
	dc.w	1
	dc.w	$FFF8, $500, $8C0C, $FFF8
word_15A70
	dc.w	1
	dc.w	$FFF8, $500, $8C10, $FFF8
word_15A7A
	dc.w	1
	dc.w	$FFF8, $500, $8C14, $FFF8
word_15A84
	dc.w	1
	dc.w	$FFF8, $500, $8330, $FFF8
word_15A8E
	dc.w	1
	dc.w	$FFF8, $500, $8334, $FFF8
word_15A98
	dc.w	1
	dc.w	$FFF8, $500, $8338, $FFF8
word_15AA2
	dc.w	1
	dc.w	$FFF8, $500, $833C, $FFF8
word_15AAC
	dc.w	1
	dc.w	$FFF8, $500, $8340, $FFF8
word_15AB6
	dc.w	1
	dc.w	$FFF8, $500, $8344, $FFF8
word_15AC0
	dc.w	1
	dc.w	$FFF8, $500, $8348, $FFF8
word_15ACA
	dc.w	1
	dc.w	$FFF8, $900, $834C, $FFF0
word_15AD4
	dc.w	1
	dc.w	$FFF8, $900, $8352, $FFF0
word_15ADE
	dc.w	1
	dc.w	$FFF8, $900, $8358, $FFF0
word_15AE8
	dc.w	1
	dc.w	$FFF8, $900, $835E, $FFF0
word_15AF2
	dc.w	1
	dc.w	$FFF8, $900, $8364, $FFF0
word_15AFC
	dc.w	1
	dc.w	$FFF8, $D00, $836A, $FFE8
word_15B06
	dc.w	1
	dc.w	$FFF8, $D00, $8372, $FFE8
word_15B10
	dc.w	1
	dc.w	$FFF8, $500, $837A, $FFF8
word_15B1A
	dc.w	1
	dc.w	$FFF8, $500, $837E, $FFF8
word_15B24
	dc.w	1
	dc.w	$FFF8, $500, $8382, $FFF8
word_15B2E
	dc.w	1
	dc.w	$FFF8, $500, $8386, $FFF8
word_15B38
	dc.w	1
	dc.w	$FFF8, $500, $838A, $FFF8
word_15B42
	dc.w	1
	dc.w	$FFF8, $500, $838E, $FFF8
word_15B4C
	dc.w	1
	dc.w	$FFF8, $500, $8392, $FFF8
word_15B56
	dc.w	1
	dc.w	$FFF8, $500, $8396, $FFF8
word_15B60
	dc.w	1
	dc.w	$FFF8, $500, $839A, $FFF8
word_15B6A
	dc.w	1
	dc.w	$FFF8, $500, $839E, $FFF8
word_15B74
	dc.w	2
	dc.w	$FFF0, $100, $83A2, $FFF0
	dc.w	$FFF8, $500, $839A, $FFF8
word_15B86
	dc.w	2
	dc.w	$FFF0, $100, $83A4, $FFF0
	dc.w	$FFF8, $500, $839A, $FFF8
word_15B98
	dc.w	1
	dc.w	$FFF8, $500, $83A6, $FFF8
word_15BA2
	dc.w	1
	dc.w	$FFF8, $500, $8BA6, $FFF8
word_15BAC
	dc.w	1
	dc.w	$FFF8, $500, $83AA, $FFF8
word_15BB6
	dc.w	1
	dc.w	$FFF8, $500, $83AE, $FFF8
word_15BC0
	dc.w	1
	dc.w	$FFF8, $900, $83B2, $FFF0
word_15BCA
	dc.w	1
	dc.w	$FFF8, $900, $83B8, $FFF0
word_15BD4
	dc.w	1
	dc.w	$FFF8, $500, $83BE, $FFF8
word_15BDE
	dc.w	1
	dc.w	$FFF8, $A00, $83C2, $FFF8
word_15BE8
	dc.w	1
	dc.w	$FFF8, $A00, $83CB, $FFF8
word_15BF2
	dc.w	1
	dc.w	$FFF8, $500, $83D4, $FFF8
word_15BFC
	dc.w	1
	dc.w	$FFF8, $900, $83D8, $FFF0
word_15C06
	dc.w	1
	dc.w	$FFF8, $900, $83DE, $FFF0
word_15C10
	dc.w	1
	dc.w	$FFF8, $500, $83E4, $FFF8
word_15C1A
	dc.w	1
	dc.w	$FFF8, $500, $83E8, $FFF8
word_15C24
	dc.w	1
	dc.w	$FFF8, $500, $83EC, $FFF8
word_15C2E
	dc.w	1
	dc.w	$FFF8, $500, $83F0, $FFF8
word_15C38
	dc.w	1
	dc.w	0, $400, $83F4, $FFF8
word_15C42
	dc.w	1
	dc.w	$FFF8, $500, $83F6, $FFF8
word_15C4C
	dc.w	1
	dc.w	$FFF8, $500, $83FA, $FFF8
word_15C56
	dc.w	1
	dc.w	$FFF8, $500, $8418, $FFF8
word_15C60
	dc.w	1
	dc.w	$FFF8, $900, $841C, $FFF8
word_15C6A
	dc.w	1
	dc.w	$FFF8, $900, $8422, $FFF8
word_15C74
	dc.w	1
	dc.w	$FFF8, $900, $8428, $FFF8
word_15C7E
	dc.w	1
	dc.w	$FFF8, $500, $842E, $FFF8
word_15C88
	dc.w	1
	dc.w	$FFF8, $900, $8432, $FFF0
word_15C92
	dc.w	1
	dc.w	$FFF8, $900, $8C22, $FFF0
word_15C9C
	dc.w	1
	dc.w	$FFF8, $900, $8C28, $FFF0
word_15CA6
	dc.w	1
	dc.w	$FFF8, $500, $8BAA, $FFF8
MapSpr_Unk1A
	dc.l	word_15CC8
	dc.l	word_15CD2
	dc.l	word_15CDC
	dc.l	word_15CE6
	dc.l	word_15CF0
	dc.l	word_15CFA
word_15CC8
	dc.w	1
	dc.w	$FFF0, $E01, $C438, $FFF0
word_15CD2
	dc.w	1
	dc.w	$FFF0, $E01, $C444, $FFF0
word_15CDC
	dc.w	1
	dc.w	$FFE8, $F01, $C450, $FFF0
word_15CE6
	dc.w	1
	dc.w	$FFF0, $E01, $4438, $FFF0
word_15CF0
	dc.w	1
	dc.w	$FFF0, $E01, $4444, $FFF0
word_15CFA
	dc.w	1
	dc.w	$FFE8, $F01, $4450, $FFF0
MapSpr_Unk1B
	dc.l	word_15D64
	dc.l	word_15DCE
	dc.l	word_15E28
	dc.l	word_15EB2
	dc.l	word_15F3C
	dc.l	word_15FBE
	dc.l	word_16048
	dc.l	word_160CA
	dc.l	word_16134
	dc.l	word_161B6
	dc.l	word_16240
	dc.l	word_162BA
	dc.l	word_1633C
	dc.l	word_163BE
	dc.l	word_16428
	dc.l	word_16492
	dc.l	word_16514
	dc.l	word_15D64
	dc.l	word_15D64
	dc.l	word_15D64
	dc.l	word_15D64
	dc.l	word_1658E
	dc.l	word_16618
	dc.l	word_1667A
word_15D64
	dc.w	$D
	dc.w	$18, $B04, $4100, $28
	dc.w	$20, $704, $410C, $18
	dc.w	$20, $304, $4114, $40
	dc.w	$30, $304, $4118, $10
	dc.w	$38, $B04, $411C, $28
	dc.w	$40, $704, $4128, $18
	dc.w	$40, $304, $4130, $40
	dc.w	$48, $304, $4134, 8
	dc.w	$50, $204, $4138, $10
	dc.w	$58, $104, $413B, $38
	dc.w	$58, $104, $413D, $48
	dc.w	$60, $C04, $413F, $18
	dc.w	$60, 4, $4143, $40
word_15DCE
	dc.w	$B
	dc.w	$18, $704, $4100, $28
	dc.w	$20, $704, $4108, $18
	dc.w	$20, $904, $4110, $38
	dc.w	$28, $304, $4116, $10
	dc.w	$30, $704, $411A, $38
	dc.w	$38, $704, $4122, $28
	dc.w	$40, $704, $412A, $18
	dc.w	$48, $704, $4132, 8
	dc.w	$50, $604, $413A, $38
	dc.w	$58, $104, $4140, $48
	dc.w	$60, $C04, $4142, $18
word_15E28
	dc.w	$11
	dc.w	$18, $F04, $4100, $20
	dc.w	$20, $304, $4110, $18
	dc.w	$20, $304, $4114, $40
	dc.w	$28, $704, $4118, 8
	dc.w	$28, $304, $4120, $48
	dc.w	$30, $204, $4124, 0
	dc.w	$30, $304, $4127, $50
	dc.w	$38, $F04, $412B, $20
	dc.w	$40, $304, $413B, $18
	dc.w	$40, $304, $413F, $40
	dc.w	$48, $704, $4143, 8
	dc.w	$50, $204, $414B, $48
	dc.w	$58, $104, $414E, $20
	dc.w	$58, $104, $4150, $38
	dc.w	$60, 4, $4152, $18
	dc.w	$60, $404, $4153, $28
	dc.w	$60, 4, $4155, $40
word_15EB2
	dc.w	$11
	dc.w	$18, $304, $4100, $38
	dc.w	$18, $604, $4104, $58
	dc.w	$20, $F04, $410A, $18
	dc.w	$20, $704, $411A, $40
	dc.w	$28, $704, $4122, 8
	dc.w	$28, $104, $412A, $50
	dc.w	$30, 4, $412C, $58
	dc.w	$38, $304, $412D, $38
	dc.w	$40, $E04, $4131, $18
	dc.w	$40, $704, $413D, $40
	dc.w	$48, $304, $4145, $10
	dc.w	$50, $204, $4149, 8
	dc.w	$58, $104, $414C, 0
	dc.w	$58, $504, $414E, $18
	dc.w	$58, $104, $4152, $38
	dc.w	$60, $404, $4154, $28
	dc.w	$60, $404, $4156, $40
word_15F3C
	dc.w	$10
	dc.w	$10, $404, $4100, $40
	dc.w	$18, $704, $4102, $48
	dc.w	$20, $F04, $410A, $18
	dc.w	$20, $704, $411A, $38
	dc.w	$20, $104, $4122, $58
	dc.w	$28, $304, $4124, $10
	dc.w	$30, $204, $4128, 8
	dc.w	$38, $304, $412B, $48
	dc.w	$40, $E04, $412F, $18
	dc.w	$40, $704, $413B, $38
	dc.w	$48, $304, $4143, $10
	dc.w	$50, $204, $4147, 8
	dc.w	$58, $104, $414A, 0
	dc.w	$58, $504, $414C, $18
	dc.w	$58, $104, $4150, $48
	dc.w	$60, $C04, $4152, $28
word_15FBE
	dc.w	$11
	dc.w	$20, $F04, $4100, $20
	dc.w	$20, $304, $4110, $40
	dc.w	$28, $304, $4114, $18
	dc.w	$28, $A04, $4118, $48
	dc.w	$30, $104, $4121, $10
	dc.w	$30, $204, $4123, $60
	dc.w	$38, $404, $4126, $68
	dc.w	$40, $E04, $4128, $20
	dc.w	$40, $704, $4134, $40
	dc.w	$40, 4, $413C, $68
	dc.w	$48, $704, $413D, $10
	dc.w	$50, $204, $4145, 8
	dc.w	$58, $104, $4148, 0
	dc.w	$58, $104, $414A, $20
	dc.w	$58, $104, $414C, $38
	dc.w	$60, $404, $414E, $28
	dc.w	$60, $404, $4150, $40
word_16048
	dc.w	$10
	dc.w	0, $604, $4100, $38
	dc.w	$10, $304, $4106, $48
	dc.w	$18, $304, $410A, $40
	dc.w	$20, $F04, $410E, $18
	dc.w	$20, $304, $411E, $38
	dc.w	$28, $104, $4122, $10
	dc.w	$30, 4, $4124, $48
	dc.w	$38, $304, $4125, $40
	dc.w	$40, $E04, $4129, $10
	dc.w	$40, $604, $4135, $30
	dc.w	$48, $304, $413B, $48
	dc.w	$50, $204, $413F, 8
	dc.w	$58, $104, $4142, 0
	dc.w	$58, $904, $4144, $10
	dc.w	$58, $504, $414A, $38
	dc.w	$60, $404, $414E, $28
word_160CA
	dc.w	$D
	dc.w	$18, $F04, $4100, $30
	dc.w	$20, $704, $4110, $20
	dc.w	$20, $204, $4118, $50
	dc.w	$28, $304, $411B, $18
	dc.w	$30, $104, $411F, $10
	dc.w	$38, $F04, $4121, $30
	dc.w	$40, $604, $4131, $20
	dc.w	$48, $704, $4137, $10
	dc.w	$50, $204, $413F, 8
	dc.w	$58, $104, $4142, 0
	dc.w	$58, $104, $4144, $20
	dc.w	$58, $904, $4146, $38
	dc.w	$60, $404, $414C, $28
word_16134
	dc.w	$10
	dc.w	8, $204, $4100, $40
	dc.w	$10, $304, $4103, $38
	dc.w	$18, $304, $4107, $30
	dc.w	$20, $F04, $410B, 8
	dc.w	$20, $304, $411B, $28
	dc.w	$28, $104, $411F, 0
	dc.w	$30, $304, $4121, $38
	dc.w	$38, $304, $4125, $30
	dc.w	$40, $E04, $4129, 8
	dc.w	$40, $204, $4135, $28
	dc.w	$40, $304, $4138, $40
	dc.w	$50, $204, $413C, $38
	dc.w	$50, $204, $413F, $48
	dc.w	$58, $D04, $4142, 0
	dc.w	$60, $804, $414A, $20
	dc.w	$60, 4, $414D, $40
word_161B6
	dc.w	$11
	dc.w	0, $704, $4100, $38
	dc.w	8, $304, $4108, $30
	dc.w	$18, $304, $410C, $28
	dc.w	$20, $B04, $4110, $10
	dc.w	$20, $304, $411C, $38
	dc.w	$28, $204, $4120, 8
	dc.w	$28, $304, $4123, $30
	dc.w	$30, $304, $4127, $40
	dc.w	$38, $304, $412B, $28
	dc.w	$40, $A04, $412F, $10
	dc.w	$40, $304, $4138, $38
	dc.w	$48, $304, $413C, 8
	dc.w	$48, $104, $4140, $30
	dc.w	$48, $304, $4142, $48
	dc.w	$50, $204, $4146, $40
	dc.w	$58, $504, $4149, $10
	dc.w	$60, $C04, $414D, $20
word_16240
	dc.w	$F
	dc.w	8, $F04, $4100, $18
	dc.w	$10, $304, $4110, $38
	dc.w	$18, $104, $4114, $10
	dc.w	$18, $304, $4116, $40
	dc.w	$28, $F04, $411A, $18
	dc.w	$30, $304, $412A, $38
	dc.w	$38, $304, $412E, $10
	dc.w	$38, $304, $4132, $40
	dc.w	$48, $304, $4136, 8
	dc.w	$48, $D04, $413A, $18
	dc.w	$48, $304, $4142, $48
	dc.w	$50, $204, $4146, $38
	dc.w	$58, $904, $4149, $10
	dc.w	$58, $104, $414F, $40
	dc.w	$60, $404, $4151, $28
word_162BA
	dc.w	$10
	dc.w	$18, $F04, $4100, $18
	dc.w	$18, $304, $4110, $38
	dc.w	$20, $304, $4114, $40
	dc.w	$28, 4, $4118, $10
	dc.w	$30, $304, $4119, $48
	dc.w	$38, $F04, $411D, $18
	dc.w	$38, $304, $412D, $38
	dc.w	$40, $304, $4131, $10
	dc.w	$40, $304, $4135, $40
	dc.w	$48, $304, $4139, 8
	dc.w	$50, $204, $413D, $48
	dc.w	$58, $104, $4140, $18
	dc.w	$58, $104, $4142, $38
	dc.w	$60, 4, $4144, $10
	dc.w	$60, $804, $4145, $20
	dc.w	$60, 4, $4148, $40
word_1633C
	dc.w	$10
	dc.w	$18, $F04, $4100, $18
	dc.w	$18, $304, $4110, $38
	dc.w	$20, $204, $4114, $10
	dc.w	$20, $304, $4117, $40
	dc.w	$30, $304, $411B, $48
	dc.w	$38, $F04, $411F, $18
	dc.w	$38, $304, $412F, $38
	dc.w	$40, $304, $4133, $10
	dc.w	$40, $304, $4137, $40
	dc.w	$48, $304, $413B, 8
	dc.w	$50, $204, $413F, $48
	dc.w	$58, $104, $4142, $18
	dc.w	$58, $104, $4144, $38
	dc.w	$60, 4, $4146, $10
	dc.w	$60, $804, $4147, $20
	dc.w	$60, 4, $414A, $40
word_163BE
	dc.w	$D
	dc.w	$20, $F04, $4100, $20
	dc.w	$20, $304, $4110, $40
	dc.w	$28, $304, $4114, $18
	dc.w	$30, $304, $4118, $10
	dc.w	$38, $304, $411C, $48
	dc.w	$40, $F04, $4120, $20
	dc.w	$40, $304, $4130, $40
	dc.w	$48, $304, $4134, 8
	dc.w	$48, $304, $4138, $18
	dc.w	$50, $204, $413C, $10
	dc.w	$58, $104, $413F, $48
	dc.w	$60, $C04, $4141, $20
	dc.w	$60, 4, $4145, $40
word_16428
	dc.w	$D
	dc.w	$10, $F04, $4100, $18
	dc.w	$10, $B04, $4110, $38
	dc.w	$18, $104, $411C, $10
	dc.w	$18, $104, $411E, $50
	dc.w	$30, $E04, $4120, $18
	dc.w	$30, $B04, $412C, $38
	dc.w	$38, $304, $4138, $10
	dc.w	$48, $404, $413C, $18
	dc.w	$48, 4, $413E, $30
	dc.w	$50, $104, $413F, 8
	dc.w	$50, 4, $4141, $18
	dc.w	$50, $804, $4142, $38
	dc.w	$58, 4, $4145, $10
word_16492
	dc.w	$10
	dc.w	0, $504, $4100, $40
	dc.w	8, $E04, $4104, $18
	dc.w	8, $304, $4110, $38
	dc.w	$10, $304, $4114, $40
	dc.w	$18, $604, $4118, 8
	dc.w	$20, $B04, $411E, $20
	dc.w	$20, $304, $412A, $48
	dc.w	$28, $304, $412E, $18
	dc.w	$28, $304, $4132, $38
	dc.w	$30, $304, $4136, $40
	dc.w	$40, $204, $413A, $10
	dc.w	$40, $804, $413D, $20
	dc.w	$40, 4, $4140, $48
	dc.w	$48, $404, $4141, $18
	dc.w	$48, $404, $4143, $30
	dc.w	$50, 4, $4145, $18
word_16514
	dc.w	$F
	dc.w	0, $704, $4100, $38
	dc.w	8, $D04, $4108, 0
	dc.w	8, $B04, $4110, $20
	dc.w	$18, $404, $411C, $10
	dc.w	$20, $304, $411E, $18
	dc.w	$20, $704, $4122, $38
	dc.w	$28, $B04, $412A, $20
	dc.w	$28, $304, $4136, $48
	dc.w	$40, 4, $413A, $18
	dc.w	$40, $504, $413B, $38
	dc.w	$40, $104, $413F, $50
	dc.w	$48, $804, $4141, $20
	dc.w	$48, $104, $4144, $48
	dc.w	$50, $404, $4146, $28
	dc.w	$50, 4, $4148, $40
word_1658E
	dc.w	$11
	dc.w	$18, $F04, $4100, $18
	dc.w	$18, $304, $4110, $38
	dc.w	$20, $304, $4114, $10
	dc.w	$20, $304, $4118, $40
	dc.w	$30, 4, $411C, 8
	dc.w	$30, $104, $411D, $48
	dc.w	$38, $F04, $411F, $18
	dc.w	$38, $304, $412F, $38
	dc.w	$40, $304, $4133, $10
	dc.w	$40, $304, $4137, $40
	dc.w	$48, $304, $413B, 8
	dc.w	$58, $504, $413F, $18
	dc.w	$58, $104, $4143, $38
	dc.w	$58, $104, $4145, $48
	dc.w	$60, 4, $4147, $10
	dc.w	$60, $404, $4148, $28
	dc.w	$60, 4, $414A, $40
word_16618
	dc.w	$C
	dc.w	$18, $704, $4100, $28
	dc.w	$20, $B04, $4108, $10
	dc.w	$20, $704, $4114, $38
	dc.w	$30, $104, $411C, 8
	dc.w	$38, $704, $411E, $28
	dc.w	$38, 4, $4126, $48
	dc.w	$40, $B04, $4127, $10
	dc.w	$40, $704, $4133, $38
	dc.w	$48, $304, $413B, 8
	dc.w	$48, $304, $413F, $48
	dc.w	$60, $C04, $4143, $10
	dc.w	$60, $804, $4147, $30
word_1667A
	dc.w	$B
	dc.w	$20, $F04, $4100, $10
	dc.w	$20, $704, $4110, $30
	dc.w	$28, $304, $4118, $40
	dc.w	$30, $304, $411C, 8
	dc.w	$38, 4, $4120, $48
	dc.w	$40, $F04, $4121, $10
	dc.w	$40, $704, $4131, $30
	dc.w	$48, $704, $4139, $40
	dc.w	$50, $204, $4141, 8
	dc.w	$60, $C04, $4144, $10
	dc.w	$60, $404, $4148, $30
MapSpr_Unk1D
	dc.l	word_166FC
	dc.l	word_16706
	dc.l	word_16710
	dc.l	word_1671A
	dc.l	word_1673C
	dc.l	word_1674E
	dc.l	word_16760
	dc.l	word_167D2
	dc.l	word_16814
	dc.l	word_16876
word_166FC
	dc.w	1
	dc.w	0, $402, $2510, 0
word_16706
	dc.w	1
	dc.w	0, $402, $2512, 0
word_16710
	dc.w	1
	dc.w	$FFFA, $501, $514, $FFF8
word_1671A
	dc.w	4
	dc.w	0, $502, $518, 0
	dc.w	0, $502, $D18, $10
	dc.w	$10, $502, $1518, 0
	dc.w	$10, $502, $1D18, $10
word_1673C
	dc.w	2
	dc.w	$FFF9, $501, $51C, $FFF8
	dc.w	$FFFE, $503, $6520, $FFFD
word_1674E
	dc.w	2
	dc.w	$FFF9, $501, $D1C, $FFF8
	dc.w	$FFFE, $503, $6D20, $FFFD
word_16760
	dc.w	$E
	dc.w	0, $501, $2548, 0
	dc.w	0, $501, $2528, $10
	dc.w	0, $501, $253C, $20
	dc.w	0, $501, $254C, $30
	dc.w	0, $501, $2524, $40
	dc.w	0, $501, $252C, $50
	dc.w	0, $501, $2550, $60
	dc.w	5, $503, $6578, 5
	dc.w	5, $503, $6558, $15
	dc.w	5, $503, $656C, $25
	dc.w	5, $503, $657C, $35
	dc.w	5, $503, $6554, $45
	dc.w	5, $503, $655C, $55
	dc.w	5, $503, $6580, $65
word_167D2
	dc.w	8
	dc.w	0, $501, $2548, 0
	dc.w	0, $501, $2528, $10
	dc.w	0, $501, $253C, $20
	dc.w	0, $501, $254C, $30
	dc.w	5, $503, $6578, 5
	dc.w	5, $503, $6558, $15
	dc.w	5, $503, $656C, $25
	dc.w	5, $503, $657C, $35
word_16814
	dc.w	$C
	dc.w	0, $501, $2534, 0
	dc.w	0, $501, $2538, $10
	dc.w	0, $501, $253C, $20
	dc.w	0, $501, $2540, $30
	dc.w	0, $501, $2528, $40
	dc.w	0, $501, $2544, $50
	dc.w	5, $503, $6564, 5
	dc.w	5, $503, $6568, $15
	dc.w	5, $503, $656C, $25
	dc.w	5, $503, $6570, $35
	dc.w	5, $503, $6558, $45
	dc.w	5, $503, $6574, $55
word_16876
	dc.w	8
	dc.w	0, $501, $2524, 0
	dc.w	0, $501, $2528, $10
	dc.w	0, $501, $252C, $20
	dc.w	0, $501, $2530, $30
	dc.w	5, $503, $6554, 5
	dc.w	5, $503, $6558, $15
	dc.w	5, $503, $655C, $25
	dc.w	5, $503, $6560, $35
MapSpr_Unk2B
	dc.l	word_16938
	dc.l	word_169A2
	dc.l	word_169FC
	dc.l	word_16A86
	dc.l	word_16B10
	dc.l	word_16B92
	dc.l	word_16C1C
	dc.l	word_16C9E
	dc.l	word_16D08
	dc.l	word_16D8A
	dc.l	word_16E14
	dc.l	word_16E8E
	dc.l	word_16F10
	dc.l	word_16F92
	dc.l	word_16FFC
	dc.l	word_17066
	dc.l	word_170E8
	dc.l	word_17162
	dc.l	word_17194
	dc.l	word_171CE
	dc.l	word_17200
	dc.l	word_1724A
	dc.l	word_172D4
	dc.l	word_17336
	dc.l	word_174CE
	dc.l	word_17538
	dc.l	word_175A2
	dc.l	word_17624
	dc.l	word_1769E
	dc.l	word_17390
	dc.l	word_173FA
	dc.l	word_17464
word_16938
	dc.w	$D
	dc.w	$18, $B00, $E100, $28
	dc.w	$20, $700, $E10C, $18
	dc.w	$20, $300, $E114, $40
	dc.w	$30, $300, $E118, $10
	dc.w	$38, $B00, $E11C, $28
	dc.w	$40, $700, $E128, $18
	dc.w	$40, $300, $E130, $40
	dc.w	$48, $300, $E134, 8
	dc.w	$50, $200, $E138, $10
	dc.w	$58, $100, $E13B, $38
	dc.w	$58, $100, $E13D, $48
	dc.w	$60, $C00, $E13F, $18
	dc.w	$60, 0, $E143, $40
word_169A2
	dc.w	$B
	dc.w	$18, $700, $E100, $28
	dc.w	$20, $700, $E108, $18
	dc.w	$20, $900, $E110, $38
	dc.w	$28, $300, $E116, $10
	dc.w	$30, $700, $E11A, $38
	dc.w	$38, $700, $E122, $28
	dc.w	$40, $700, $E12A, $18
	dc.w	$48, $700, $E132, 8
	dc.w	$50, $600, $E13A, $38
	dc.w	$58, $100, $E140, $48
	dc.w	$60, $C00, $E142, $18
word_169FC
	dc.w	$11
	dc.w	$18, $F00, $E100, $20
	dc.w	$20, $300, $E110, $18
	dc.w	$20, $300, $E114, $40
	dc.w	$28, $700, $E118, 8
	dc.w	$28, $300, $E120, $48
	dc.w	$30, $200, $E124, 0
	dc.w	$30, $300, $E127, $50
	dc.w	$38, $F00, $E12B, $20
	dc.w	$40, $300, $E13B, $18
	dc.w	$40, $300, $E13F, $40
	dc.w	$48, $700, $E143, 8
	dc.w	$50, $200, $E14B, $48
	dc.w	$58, $100, $E14E, $20
	dc.w	$58, $100, $E150, $38
	dc.w	$60, 0, $E152, $18
	dc.w	$60, $400, $E153, $28
	dc.w	$60, 0, $E155, $40
word_16A86
	dc.w	$11
	dc.w	$18, $300, $E100, $38
	dc.w	$18, $600, $E104, $58
	dc.w	$20, $F00, $E10A, $18
	dc.w	$20, $700, $E11A, $40
	dc.w	$28, $700, $E122, 8
	dc.w	$28, $100, $E12A, $50
	dc.w	$30, 0, $E12C, $58
	dc.w	$38, $300, $E12D, $38
	dc.w	$40, $E00, $E131, $18
	dc.w	$40, $700, $E13D, $40
	dc.w	$48, $300, $E145, $10
	dc.w	$50, $200, $E149, 8
	dc.w	$58, $100, $E14C, 0
	dc.w	$58, $500, $E14E, $18
	dc.w	$58, $100, $E152, $38
	dc.w	$60, $400, $E154, $28
	dc.w	$60, $400, $E156, $40
word_16B10
	dc.w	$10
	dc.w	$10, $400, $E100, $40
	dc.w	$18, $700, $E102, $48
	dc.w	$20, $F00, $E10A, $18
	dc.w	$20, $700, $E11A, $38
	dc.w	$20, $100, $E122, $58
	dc.w	$28, $300, $E124, $10
	dc.w	$30, $200, $E128, 8
	dc.w	$38, $300, $E12B, $48
	dc.w	$40, $E00, $E12F, $18
	dc.w	$40, $700, $E13B, $38
	dc.w	$48, $300, $E143, $10
	dc.w	$50, $200, $E147, 8
	dc.w	$58, $100, $E14A, 0
	dc.w	$58, $500, $E14C, $18
	dc.w	$58, $100, $E150, $48
	dc.w	$60, $C00, $E152, $28
word_16B92
	dc.w	$11
	dc.w	$20, $F00, $E100, $20
	dc.w	$20, $300, $E110, $40
	dc.w	$28, $300, $E114, $18
	dc.w	$28, $A00, $E118, $48
	dc.w	$30, $100, $E121, $10
	dc.w	$30, $200, $E123, $60
	dc.w	$38, $400, $E126, $68
	dc.w	$40, $E00, $E128, $20
	dc.w	$40, $700, $E134, $40
	dc.w	$40, 0, $E13C, $68
	dc.w	$48, $700, $E13D, $10
	dc.w	$50, $200, $E145, 8
	dc.w	$58, $100, $E148, 0
	dc.w	$58, $100, $E14A, $20
	dc.w	$58, $100, $E14C, $38
	dc.w	$60, $400, $E14E, $28
	dc.w	$60, $400, $E150, $40
word_16C1C
	dc.w	$10
	dc.w	0, $600, $E100, $38
	dc.w	$10, $300, $E106, $48
	dc.w	$18, $300, $E10A, $40
	dc.w	$20, $F00, $E10E, $18
	dc.w	$20, $300, $E11E, $38
	dc.w	$28, $100, $E122, $10
	dc.w	$30, 0, $E124, $48
	dc.w	$38, $300, $E125, $40
	dc.w	$40, $E00, $E129, $10
	dc.w	$40, $600, $E135, $30
	dc.w	$48, $300, $E13B, $48
	dc.w	$50, $200, $E13F, 8
	dc.w	$58, $100, $E142, 0
	dc.w	$58, $900, $E144, $10
	dc.w	$58, $500, $E14A, $38
	dc.w	$60, $400, $E14E, $28
word_16C9E
	dc.w	$D
	dc.w	$18, $F00, $E100, $30
	dc.w	$20, $700, $E110, $20
	dc.w	$20, $200, $E118, $50
	dc.w	$28, $300, $E11B, $18
	dc.w	$30, $100, $E11F, $10
	dc.w	$38, $F00, $E121, $30
	dc.w	$40, $600, $E131, $20
	dc.w	$48, $700, $E137, $10
	dc.w	$50, $200, $E13F, 8
	dc.w	$58, $100, $E142, 0
	dc.w	$58, $100, $E144, $20
	dc.w	$58, $900, $E146, $38
	dc.w	$60, $400, $E14C, $28
word_16D08
	dc.w	$10
	dc.w	8, $200, $E100, $40
	dc.w	$10, $300, $E103, $38
	dc.w	$18, $300, $E107, $30
	dc.w	$20, $F00, $E10B, 8
	dc.w	$20, $300, $E11B, $28
	dc.w	$28, $100, $E11F, 0
	dc.w	$30, $300, $E121, $38
	dc.w	$38, $300, $E125, $30
	dc.w	$40, $E00, $E129, 8
	dc.w	$40, $200, $E135, $28
	dc.w	$40, $300, $E138, $40
	dc.w	$50, $200, $E13C, $38
	dc.w	$50, $200, $E13F, $48
	dc.w	$58, $D00, $E142, 0
	dc.w	$60, $800, $E14A, $20
	dc.w	$60, 0, $E14D, $40
word_16D8A
	dc.w	$11
	dc.w	0, $700, $E100, $38
	dc.w	8, $300, $E108, $30
	dc.w	$18, $300, $E10C, $28
	dc.w	$20, $B00, $E110, $10
	dc.w	$20, $300, $E11C, $38
	dc.w	$28, $200, $E120, 8
	dc.w	$28, $300, $E123, $30
	dc.w	$30, $300, $E127, $40
	dc.w	$38, $300, $E12B, $28
	dc.w	$40, $A00, $E12F, $10
	dc.w	$40, $300, $E138, $38
	dc.w	$48, $300, $E13C, 8
	dc.w	$48, $100, $E140, $30
	dc.w	$48, $300, $E142, $48
	dc.w	$50, $200, $E146, $40
	dc.w	$58, $500, $E149, $10
	dc.w	$60, $C00, $E14D, $20
word_16E14
	dc.w	$F
	dc.w	8, $F00, $E100, $18
	dc.w	$10, $300, $E110, $38
	dc.w	$18, $100, $E114, $10
	dc.w	$18, $300, $E116, $40
	dc.w	$28, $F00, $E11A, $18
	dc.w	$30, $300, $E12A, $38
	dc.w	$38, $300, $E12E, $10
	dc.w	$38, $300, $E132, $40
	dc.w	$48, $300, $E136, 8
	dc.w	$48, $D00, $E13A, $18
	dc.w	$48, $300, $E142, $48
	dc.w	$50, $200, $E146, $38
	dc.w	$58, $900, $E149, $10
	dc.w	$58, $100, $E14F, $40
	dc.w	$60, $400, $E151, $28
word_16E8E
	dc.w	$10
	dc.w	$18, $F00, $E100, $18
	dc.w	$18, $300, $E110, $38
	dc.w	$20, $300, $E114, $40
	dc.w	$28, 0, $E118, $10
	dc.w	$30, $300, $E119, $48
	dc.w	$38, $F00, $E11D, $18
	dc.w	$38, $300, $E12D, $38
	dc.w	$40, $300, $E131, $10
	dc.w	$40, $300, $E135, $40
	dc.w	$48, $300, $E139, 8
	dc.w	$50, $200, $E13D, $48
	dc.w	$58, $100, $E140, $18
	dc.w	$58, $100, $E142, $38
	dc.w	$60, 0, $E144, $10
	dc.w	$60, $800, $E145, $20
	dc.w	$60, 0, $E148, $40
word_16F10
	dc.w	$10
	dc.w	$18, $F00, $E100, $18
	dc.w	$18, $300, $E110, $38
	dc.w	$20, $200, $E114, $10
	dc.w	$20, $300, $E117, $40
	dc.w	$30, $300, $E11B, $48
	dc.w	$38, $F00, $E11F, $18
	dc.w	$38, $300, $E12F, $38
	dc.w	$40, $300, $E133, $10
	dc.w	$40, $300, $E137, $40
	dc.w	$48, $300, $E13B, 8
	dc.w	$50, $200, $E13F, $48
	dc.w	$58, $100, $E142, $18
	dc.w	$58, $100, $E144, $38
	dc.w	$60, 0, $E146, $10
	dc.w	$60, $800, $E147, $20
	dc.w	$60, 0, $E14A, $40
word_16F92
	dc.w	$D
	dc.w	$20, $F00, $E100, $20
	dc.w	$20, $300, $E110, $40
	dc.w	$28, $300, $E114, $18
	dc.w	$30, $300, $E118, $10
	dc.w	$38, $300, $E11C, $48
	dc.w	$40, $F00, $E120, $20
	dc.w	$40, $300, $E130, $40
	dc.w	$48, $300, $E134, 8
	dc.w	$48, $300, $E138, $18
	dc.w	$50, $200, $E13C, $10
	dc.w	$58, $100, $E13F, $48
	dc.w	$60, $C00, $E141, $20
	dc.w	$60, 0, $E145, $40
word_16FFC
	dc.w	$D
	dc.w	$10, $F00, $E100, $18
	dc.w	$10, $B00, $E110, $38
	dc.w	$18, $100, $E11C, $10
	dc.w	$18, $100, $E11E, $50
	dc.w	$30, $E00, $E120, $18
	dc.w	$30, $B00, $E12C, $38
	dc.w	$38, $300, $E138, $10
	dc.w	$48, $400, $E13C, $18
	dc.w	$48, 0, $E13E, $30
	dc.w	$50, $100, $E13F, 8
	dc.w	$50, 0, $E141, $18
	dc.w	$50, $800, $E142, $38
	dc.w	$58, 0, $E145, $10
word_17066
	dc.w	$10
	dc.w	0, $500, $E100, $40
	dc.w	8, $E00, $E104, $18
	dc.w	8, $300, $E110, $38
	dc.w	$10, $300, $E114, $40
	dc.w	$18, $600, $E118, 8
	dc.w	$20, $B00, $E11E, $20
	dc.w	$20, $300, $E12A, $48
	dc.w	$28, $300, $E12E, $18
	dc.w	$28, $300, $E132, $38
	dc.w	$30, $300, $E136, $40
	dc.w	$40, $200, $E13A, $10
	dc.w	$40, $800, $E13D, $20
	dc.w	$40, 0, $E140, $48
	dc.w	$48, $400, $E141, $18
	dc.w	$48, $400, $E143, $30
	dc.w	$50, 0, $E145, $18
word_170E8
	dc.w	$F
	dc.w	0, $702, $E100, $38
	dc.w	8, $D02, $E108, 0
	dc.w	8, $B02, $E110, $20
	dc.w	$18, $402, $E11C, $10
	dc.w	$20, $302, $E11E, $18
	dc.w	$20, $702, $E122, $38
	dc.w	$28, $B02, $E12A, $20
	dc.w	$28, $302, $E136, $48
	dc.w	$40, 2, $E13A, $18
	dc.w	$40, $502, $E13B, $38
	dc.w	$40, $102, $E13F, $50
	dc.w	$48, $802, $E141, $20
	dc.w	$48, $102, $E144, $48
	dc.w	$50, $402, $E146, $28
	dc.w	$50, 2, $E148, $40
word_17162
	dc.w	6
	dc.w	$10, $F00, $E100, $18
	dc.w	$10, $A00, $E110, $38
	dc.w	$18, $200, $E119, $10
	dc.w	$18, $100, $E11C, $50
	dc.w	$28, $500, $E11E, $38
	dc.w	$30, $800, $E122, $20
word_17194
	dc.w	7
	dc.w	$10, $F00, $E100, $28
	dc.w	$18, $600, $E110, $18
	dc.w	$18, 0, $E116, $48
	dc.w	$28, 0, $E117, $10
	dc.w	$28, 0, $E118, $48
	dc.w	$30, $C00, $E119, $20
	dc.w	$30, 0, $E11D, $40
word_171CE
	dc.w	6
	dc.w	$10, $F00, $E100, $20
	dc.w	$10, $700, $E110, $40
	dc.w	$20, $100, $E118, $18
	dc.w	$30, $C00, $E11A, $28
	dc.w	$30, $100, $E11E, $48
	dc.w	$38, $400, $E120, $38
word_17200
	dc.w	9
	dc.w	0, $B00, $E100, $20
	dc.w	8, $700, $E10C, $10
	dc.w	8, $300, $E114, $38
	dc.w	$18, $300, $E118, $40
	dc.w	$20, $900, $E11C, $20
	dc.w	$20, $200, $E122, $48
	dc.w	$28, $500, $E125, $10
	dc.w	$28, $100, $E129, $38
	dc.w	$30, $400, $E12B, $28
word_1724A
	dc.w	$11
	dc.w	$18, $F00, $E100, $18
	dc.w	$18, $300, $E110, $38
	dc.w	$20, $300, $E114, $10
	dc.w	$20, $300, $E118, $40
	dc.w	$30, 0, $E11C, 8
	dc.w	$30, $100, $E11D, $48
	dc.w	$38, $F00, $E11F, $18
	dc.w	$38, $300, $E12F, $38
	dc.w	$40, $300, $E133, $10
	dc.w	$40, $300, $E137, $40
	dc.w	$48, $300, $E13B, 8
	dc.w	$58, $500, $E13F, $18
	dc.w	$58, $100, $E143, $38
	dc.w	$58, $100, $E145, $48
	dc.w	$60, 0, $E147, $10
	dc.w	$60, $400, $E148, $28
	dc.w	$60, 0, $E14A, $40
word_172D4
	dc.w	$C
	dc.w	$18, $700, $E100, $28
	dc.w	$20, $B00, $E108, $10
	dc.w	$20, $700, $E114, $38
	dc.w	$30, $100, $E11C, 8
	dc.w	$38, $700, $E11E, $28
	dc.w	$38, 0, $E126, $48
	dc.w	$40, $B00, $E127, $10
	dc.w	$40, $700, $E133, $38
	dc.w	$48, $300, $E13B, 8
	dc.w	$48, $300, $E13F, $48
	dc.w	$60, $C00, $E143, $10
	dc.w	$60, $800, $E147, $30
word_17336
	dc.w	$B
	dc.w	$20, $F00, $E100, $10
	dc.w	$20, $700, $E110, $30
	dc.w	$28, $300, $E118, $40
	dc.w	$30, $300, $E11C, 8
	dc.w	$38, 0, $E120, $48
	dc.w	$40, $F00, $E121, $10
	dc.w	$40, $700, $E131, $30
	dc.w	$48, $700, $E139, $40
	dc.w	$50, $200, $E141, 8
	dc.w	$60, $C00, $E144, $10
	dc.w	$60, $400, $E148, $30
word_17390
	dc.w	$D
	dc.w	$28, $B01, $8180, $20
	dc.w	$28, $B01, $818C, $40
	dc.w	$30, $301, $8198, $18
	dc.w	$30, $301, $819C, $38
	dc.w	$30, $301, $81A0, $58
	dc.w	$38, $101, $81A4, $10
	dc.w	$48, $901, $81A6, $20
	dc.w	$48, $901, $81AC, $40
	dc.w	$50, 1, $81B2, $18
	dc.w	$50, $201, $81B3, $38
	dc.w	$58, $501, $81B6, $28
	dc.w	$58, $401, $81BA, $40
	dc.w	$60, 1, $81BC, $40
word_173FA
	dc.w	$D
	dc.w	$28, $B01, $8980, $38
	dc.w	$28, $B01, $898C, $18
	dc.w	$30, $301, $8998, $50
	dc.w	$30, $301, $899C, $30
	dc.w	$30, $301, $89A0, $10
	dc.w	$38, $101, $89A4, $58
	dc.w	$48, $901, $89A6, $38
	dc.w	$48, $901, $89AC, $18
	dc.w	$50, 1, $89B2, $50
	dc.w	$50, $201, $89B3, $30
	dc.w	$58, $501, $89B6, $38
	dc.w	$58, $401, $89BA, $20
	dc.w	$60, 1, $89BC, $28
word_17464
	dc.w	$D
	dc.w	$18, $B00, $E900, $10
	dc.w	$20, $700, $E90C, $28
	dc.w	$20, $300, $E914, 8
	dc.w	$30, $300, $E918, $38
	dc.w	$38, $B00, $E91C, $10
	dc.w	$40, $700, $E928, $28
	dc.w	$40, $300, $E930, 8
	dc.w	$48, $300, $E934, $40
	dc.w	$50, $200, $E938, $38
	dc.w	$58, $100, $E93B, $10
	dc.w	$58, $100, $E93D, 0
	dc.w	$60, $C00, $E93F, $18
	dc.w	$60, 0, $E943, 8
word_174CE
	dc.w	$D
	dc.w	$20, $F00, $E900, $10
	dc.w	$20, $300, $E910, 8
	dc.w	$28, $300, $E914, $30
	dc.w	$30, $300, $E918, $38
	dc.w	$38, $300, $E91C, 0
	dc.w	$40, $F00, $E920, $10
	dc.w	$40, $300, $E930, 8
	dc.w	$48, $300, $E934, $40
	dc.w	$48, $300, $E938, $30
	dc.w	$50, $200, $E93C, $38
	dc.w	$58, $100, $E93F, 0
	dc.w	$60, $C00, $E941, $10
	dc.w	$60, 0, $E945, 8
word_17538
	dc.w	$D
	dc.w	$10, $F02, $E900, $20
	dc.w	$10, $B02, $E910, 8
	dc.w	$18, $102, $E91C, $40
	dc.w	$18, $102, $E91E, 0
	dc.w	$30, $E02, $E920, $20
	dc.w	$30, $B02, $E92C, 8
	dc.w	$38, $302, $E938, $40
	dc.w	$48, $402, $E93C, $30
	dc.w	$48, 2, $E93E, $20
	dc.w	$50, $102, $E93F, $48
	dc.w	$50, 2, $E941, $38
	dc.w	$50, $802, $E942, 8
	dc.w	$58, 2, $E945, $40
word_175A2
	dc.w	$10
	dc.w	0, $500, $E900, 8
	dc.w	8, $E00, $E904, $20
	dc.w	8, $300, $E910, $18
	dc.w	$10, $300, $E914, $10
	dc.w	$18, $600, $E918, $40
	dc.w	$20, $B00, $E91E, $20
	dc.w	$20, $300, $E92A, 8
	dc.w	$28, $300, $E92E, $38
	dc.w	$28, $300, $E932, $18
	dc.w	$30, $300, $E936, $10
	dc.w	$40, $200, $E93A, $40
	dc.w	$40, $800, $E93D, $20
	dc.w	$40, 0, $E940, 8
	dc.w	$48, $400, $E941, $30
	dc.w	$48, $400, $E943, $18
	dc.w	$50, 0, $E945, $38
word_17624
	dc.w	$F
	dc.w	0, $700, $E900, $10
	dc.w	8, $D00, $E908, $38
	dc.w	8, $B00, $E910, $20
	dc.w	$18, $400, $E91C, $38
	dc.w	$20, $300, $E91E, $38
	dc.w	$20, $700, $E922, $10
	dc.w	$28, $B00, $E92A, $20
	dc.w	$28, $300, $E936, 8
	dc.w	$40, 0, $E93A, $38
	dc.w	$40, $500, $E93B, $10
	dc.w	$40, $100, $E93F, 0
	dc.w	$48, $800, $E941, $20
	dc.w	$48, $100, $E944, 8
	dc.w	$50, $400, $E946, $20
	dc.w	$50, 0, $E948, $10
word_1769E
	dc.w	7
	dc.w	$10, $F00, $E900, $18
	dc.w	$18, $600, $E910, $38
	dc.w	$18, 0, $E916, $10
	dc.w	$28, 0, $E917, $48
	dc.w	$28, 0, $E918, $10
	dc.w	$30, $C00, $E919, $20
	dc.w	$30, 0, $E91D, $18
MapSpr_Unk2C
	dc.l	word_176F8
	dc.l	word_17702
	dc.l	word_1770C
	dc.l	word_17716
	dc.l	word_17720
	dc.l	word_1772A
	dc.l	word_17734
	dc.l	word_1773E
word_176F8
	dc.w	1
	dc.w	0, $102, $E0F0, 0
word_17702
	dc.w	1
	dc.w	0, $102, $E0F2, 0
word_1770C
	dc.w	1
	dc.w	0, $102, $E0F4, 0
word_17716
	dc.w	1
	dc.w	0, $102, $E0F6, 0
word_17720
	dc.w	1
	dc.w	0, $100, $C0F0, 0
word_1772A
	dc.w	1
	dc.w	0, $100, $C0F2, 0
word_17734
	dc.w	1
	dc.w	0, $100, $C0F4, 0
word_1773E
	dc.w	1
	dc.w	0, $100, $C0F6, 0
MapSpr_Unk09
	dc.l	word_17764
	dc.l	word_1779E
	dc.l	word_177D8
	dc.l	word_1780A
	dc.l	word_17844
	dc.l	word_1787E
	dc.l	word_178B0
word_17764
	dc.w	7
	dc.w	0, $B02, $E400, 8
	dc.w	8, $102, $E40C, 0
	dc.w	8, $302, $E40E, $20
	dc.w	$10, 2, $E412, $28
	dc.w	$20, $902, $E413, 8
	dc.w	$28, 2, $E419, 0
	dc.w	$28, $402, $E41A, $20
word_1779E
	dc.w	7
	dc.w	0, $B02, $E41C, 8
	dc.w	8, $102, $E428, 0
	dc.w	8, $302, $E42A, $20
	dc.w	$10, 2, $E42E, $28
	dc.w	$20, $902, $E42F, 8
	dc.w	$28, 2, $E419, 0
	dc.w	$28, $402, $E435, $20
word_177D8
	dc.w	6
	dc.w	0, $F02, $E437, 8
	dc.w	8, $102, $E447, 0
	dc.w	8, 2, $E449, $28
	dc.w	$20, $D02, $E44A, 8
	dc.w	$28, 2, $E419, 0
	dc.w	$28, 2, $E41B, $28
word_1780A
	dc.w	7
	dc.w	0, $B02, $E452, 8
	dc.w	8, $302, $E45E, 0
	dc.w	8, $302, $E462, $20
	dc.w	$10, 2, $E412, $28
	dc.w	$20, $902, $E466, 8
	dc.w	$28, 2, $E419, 0
	dc.w	$28, $402, $E41A, $20
word_17844
	dc.w	7
	dc.w	0, $B02, $E46C, 8
	dc.w	8, $102, $E40C, 0
	dc.w	8, $302, $E462, $20
	dc.w	$10, 2, $E412, $28
	dc.w	$20, $902, $E478, 8
	dc.w	$28, 2, $E419, 0
	dc.w	$28, $402, $E41A, $20
word_1787E
	dc.w	6
	dc.w	0, $E02, $E47E, 0
	dc.w	8, $302, $E462, $20
	dc.w	$10, 2, $E412, $28
	dc.w	$18, $A02, $E48A, 8
	dc.w	$28, 2, $E419, 0
	dc.w	$28, $402, $E41A, $20
word_178B0
	dc.w	7
	dc.w	0, $B02, $E493, 8
	dc.w	8, $102, $E49F, 0
	dc.w	8, $302, $E462, $20
	dc.w	$10, 2, $E412, $28
	dc.w	$20, $902, $E4A1, 8
	dc.w	$28, 2, $E419, 0
	dc.w	$28, $402, $E41A, $20
MapSpr_Unk0A
	dc.l	word_17902
	dc.l	word_1794C
	dc.l	word_1799E
	dc.l	word_179F0
	dc.l	word_17A4A
	dc.l	word_17AA4
word_17902
	dc.w	9
	dc.w	0, $902, $E400, 8
	dc.w	0, $902, $E406, $20
	dc.w	$10, $902, $E40C, 0
	dc.w	$10, $902, $E412, $18
	dc.w	$20, $A02, $E418, 0
	dc.w	$20, $E02, $E421, $18
	dc.w	$38, $C02, $E42D, 8
	dc.w	$40, $802, $E431, 0
	dc.w	$40, $402, $E434, $18
word_1794C
	dc.w	$A
	dc.w	0, $902, $E436, $20
	dc.w	0, $902, $E43C, 8
	dc.w	8, 2, $E442, 0
	dc.w	$10, $902, $E443, 0
	dc.w	$10, $902, $E449, $18
	dc.w	$20, $E02, $E44F, 0
	dc.w	$20, $A02, $E45B, $20
	dc.w	$38, $C02, $E42D, 8
	dc.w	$40, $802, $E431, 0
	dc.w	$40, $402, $E434, $18
word_1799E
	dc.w	$A
	dc.w	0, $902, $E464, 0
	dc.w	0, $902, $E46A, $18
	dc.w	$10, $902, $E470, 0
	dc.w	$10, $902, $E476, $18
	dc.w	$20, $A02, $E47C, 0
	dc.w	$20, $602, $E485, $18
	dc.w	$20, $502, $E48B, $28
	dc.w	$38, $C02, $E42D, 8
	dc.w	$40, $802, $E431, 0
	dc.w	$40, $402, $E434, $18
word_179F0
	dc.w	$B
	dc.w	0, $902, $E48F, 0
	dc.w	0, $802, $E495, $18
	dc.w	8, $402, $E498, $18
	dc.w	$10, $902, $E49A, 0
	dc.w	$10, $902, $E4A0, $18
	dc.w	$20, $E02, $E4A6, 0
	dc.w	$20, $902, $E4B2, $20
	dc.w	$30, 2, $E4B8, $20
	dc.w	$38, $C02, $E42D, 8
	dc.w	$40, $802, $E431, 0
	dc.w	$40, $402, $E434, $18
word_17A4A
	dc.w	$B
	dc.w	0, $902, $E4B9, 0
	dc.w	0, $802, $E4BF, $18
	dc.w	8, $402, $E4C2, $18
	dc.w	$10, $902, $E4C4, 0
	dc.w	$10, $902, $E4CA, $18
	dc.w	$20, $E02, $E4D0, 0
	dc.w	$20, $202, $E4DC, $20
	dc.w	$20, $502, $E4DF, $28
	dc.w	$38, $C02, $E42D, 8
	dc.w	$40, $802, $E431, 0
	dc.w	$40, $402, $E434, $18
word_17AA4
	dc.w	$B
	dc.w	0, $902, $E4E3, 0
	dc.w	0, $802, $E4BF, $18
	dc.w	8, $402, $E4E9, $18
	dc.w	$10, $902, $E4C4, 0
	dc.w	$10, $902, $E4CA, $18
	dc.w	$20, $E02, $E4D0, 0
	dc.w	$20, $202, $E4DC, $20
	dc.w	$20, $502, $E4DF, $28
	dc.w	$38, $C02, $E42D, 8
	dc.w	$40, $802, $E431, 0
	dc.w	$40, $402, $E434, $18
MapSpr_Unk2D
	dc.l	word_17B32
	dc.l	word_17B3C
	dc.l	word_17B46
	dc.l	word_17B50
	dc.l	word_17B5A
	dc.l	word_17B64
	dc.l	word_17B76
	dc.l	word_17B80
	dc.l	word_17B92
	dc.l	word_17B9C
	dc.l	word_17BA6
	dc.l	word_17BB0
	dc.l	word_17BBA
word_17B32
	dc.w	1
	dc.w	0, $802, $E4DE, 0
word_17B3C
	dc.w	1
	dc.w	0, $802, $E4E1, 0
word_17B46
	dc.w	1
	dc.w	0, $102, $E4E4, 0
word_17B50
	dc.w	1
	dc.w	0, $102, $E4E6, 0
word_17B5A
	dc.w	1
	dc.w	0, $102, $E4E8, 0
word_17B64
	dc.w	2
	dc.w	0, $802, $E4EA, 0
	dc.w	8, $402, $E4ED, 8
word_17B76
	dc.w	1
	dc.w	0, $902, $E4EF, 0
word_17B80
	dc.w	2
	dc.w	0, $502, $E4F5, 8
	dc.w	8, 2, $E4F9, 0
word_17B92
	dc.w	1
	dc.w	0, $802, $C3DE, 0
word_17B9C
	dc.w	1
	dc.w	0, $802, $C3E1, 0
word_17BA6
	dc.w	1
	dc.w	0, $102, $C3E4, 0
word_17BB0
	dc.w	1
	dc.w	0, $102, $C3E6, 0
word_17BBA
	dc.w	1
	dc.w	0, $102, $C3E8, 0
	dc.w	2
	dc.w	0, $802, $C3EA, 0
	dc.w	8, $402, $C3ED, 8
	dc.w	1
	dc.w	0, $902, $C3EF, 0
	dc.w	2
	dc.w	0, $502, $C3F5, 8
	dc.w	8, 2, $C3F9, 0
MapSpr_Unk0F
	dc.l	word_17C12
	dc.l	word_17C5C
	dc.l	word_17CA6
	dc.l	word_17CE8
	dc.l	word_17D22
	dc.l	word_17D64
	dc.l	word_17D96
	dc.l	word_17DC8
word_17C12
	dc.w	9
	dc.w	8, $D02, $E400, 8
	dc.w	$10, $302, $E408, $28
	dc.w	$18, $B02, $E40C, $10
	dc.w	$20, $302, $E418, $30
	dc.w	$28, $202, $E41C, 8
	dc.w	$30, $102, $E41F, $28
	dc.w	$38, 2, $E421, 0
	dc.w	$38, $802, $E422, $10
	dc.w	$38, 2, $E425, $38
word_17C5C
	dc.w	9
	dc.w	8, $D02, $E426, 8
	dc.w	$10, $302, $E408, $28
	dc.w	$18, $B02, $E42E, $10
	dc.w	$20, $302, $E418, $30
	dc.w	$28, $202, $E41C, 8
	dc.w	$30, $102, $E41F, $28
	dc.w	$38, 2, $E421, 0
	dc.w	$38, $802, $E422, $10
	dc.w	$38, 2, $E425, $38
word_17CA6
	dc.w	8
	dc.w	8, $F02, $E43A, $10
	dc.w	$10, 2, $E44A, 8
	dc.w	$18, $302, $E44B, $30
	dc.w	$20, $202, $E44F, 8
	dc.w	$28, $102, $E452, 0
	dc.w	$28, $C02, $E454, $10
	dc.w	$30, $902, $E458, $18
	dc.w	$38, $402, $E45E, $30
word_17CE8
	dc.w	7
	dc.w	0, $B02, $E460, $18
	dc.w	8, $602, $E46C, 8
	dc.w	$10, $302, $E472, $30
	dc.w	$18, $202, $E476, $38
	dc.w	$20, $B02, $E479, $18
	dc.w	$30, $102, $E41A, $30
	dc.w	$38, 2, $E425, $38
word_17D22
	dc.w	8
	dc.w	0, $B02, $E485, $18
	dc.w	8, $602, $E491, 8
	dc.w	8, $302, $E497, $30
	dc.w	$10, $102, $E49B, 0
	dc.w	$18, $202, $E476, $38
	dc.w	$20, $B02, $E479, $18
	dc.w	$28, $202, $E49D, $30
	dc.w	$38, 2, $E425, $38
word_17D64
	dc.w	6
	dc.w	0, $B02, $E4A0, $18
	dc.w	8, $602, $E4AC, 8
	dc.w	$18, $602, $E4B2, $30
	dc.w	$20, $B02, $E479, $18
	dc.w	$30, $102, $E41A, $30
	dc.w	$38, 2, $E425, $38
word_17D96
	dc.w	6
	dc.w	0, $B02, $E4B8, $18
	dc.w	8, $602, $E4C4, 8
	dc.w	$18, $602, $E4B2, $30
	dc.w	$20, $B02, $E479, $18
	dc.w	$30, $102, $E41A, $30
	dc.w	$38, 2, $E425, $38
word_17DC8
	dc.w	6
	dc.w	0, $B02, $E4CA, $18
	dc.w	8, $602, $E4C4, 8
	dc.w	$18, $602, $E4B2, $30
	dc.w	$20, $B02, $E479, $18
	dc.w	$30, $102, $E41A, $30
	dc.w	$38, 2, $E425, $38
MapSpr_Unk0B
	dc.l	word_17E22
	dc.l	word_17E4C
	dc.l	word_17E7E
	dc.l	word_17EB0
	dc.l	word_17EEA
	dc.l	word_17F2C
	dc.l	word_17F6E
	dc.l	word_17F90
	dc.l	word_17FCA
	dc.l	word_17FF4
word_17E22
	dc.w	5
	dc.w	$28, $C02, $E400, 8
	dc.w	$30, $A02, $E404, $10
	dc.w	$48, $702, $E40D, $10
	dc.w	$60, $402, $E415, 0
	dc.w	$60, 2, $E417, $20
word_17E4C
	dc.w	6
	dc.w	$38, $C02, $E418, 0
	dc.w	$40, $802, $E41C, 8
	dc.w	$48, $702, $E41F, $10
	dc.w	$58, $102, $E427, 8
	dc.w	$60, 2, $E415, 0
	dc.w	$60, 2, $E417, $20
word_17E7E
	dc.w	6
	dc.w	$38, $702, $E429, $10
	dc.w	$40, 2, $E431, 8
	dc.w	$40, $302, $E432, $20
	dc.w	$58, $502, $E436, $10
	dc.w	$60, $402, $E43A, 0
	dc.w	$60, 2, $E417, $20
word_17EB0
	dc.w	7
	dc.w	$20, $902, $E43C, 0
	dc.w	$28, $302, $E442, $18
	dc.w	$30, $402, $E446, 8
	dc.w	$38, $302, $E448, $10
	dc.w	$48, $302, $E44C, $18
	dc.w	$50, $202, $E450, 8
	dc.w	$60, 2, $E453, $10
word_17EEA
	dc.w	8
	dc.w	0, $602, $E454, 8
	dc.w	8, $302, $E45A, $18
	dc.w	$18, $302, $E45E, $10
	dc.w	$28, 2, $E462, $18
	dc.w	$30, $202, $E463, 8
	dc.w	$38, $102, $E466, 0
	dc.w	$38, $502, $E468, $10
	dc.w	$60, $802, $E46C, 8
word_17F2C
	dc.w	8
	dc.w	0, $D02, $E46F, 8
	dc.w	$10, $802, $E477, 8
	dc.w	$18, $602, $E47A, 8
	dc.w	$20, $102, $E480, $18
	dc.w	$28, $102, $E482, 0
	dc.w	$28, 2, $E484, $20
	dc.w	$30, 2, $EC7F, 8
	dc.w	$60, $802, $E485, 8
word_17F6E
	dc.w	4
	dc.w	0, $C02, $E488, 8
	dc.w	8, $F02, $E48C, 0
	dc.w	$10, $102, $E49C, $20
	dc.w	$60, $802, $E485, 8
word_17F90
	dc.w	7
	dc.w	$20, $802, $E49E, 0
	dc.w	$28, $702, $E4A1, 8
	dc.w	$30, $302, $E4A9, $18
	dc.w	$40, $102, $E4AD, $20
	dc.w	$48, $802, $E4AF, 0
	dc.w	$50, $402, $E4B2, 8
	dc.w	$60, $802, $E4B4, 8
word_17FCA
	dc.w	5
	dc.w	$28, $C02, $E400, 8
	dc.w	$30, $A02, $E4B7, $10
	dc.w	$48, $702, $E4C0, $10
	dc.w	$60, $402, $E415, 0
	dc.w	$60, 2, $E417, $20
word_17FF4
	dc.w	5
	dc.w	$28, $C02, $E400, 8
	dc.w	$30, $B02, $E4C8, $10
	dc.w	$50, $602, $E4D4, $10
	dc.w	$60, $402, $E415, 0
	dc.w	$60, 2, $E417, $20
MapSpr_Unk2F
	dc.l	word_1802A
	dc.l	word_18034
	dc.l	word_1803E
word_1802A
	dc.w	1
	dc.w	0, $E02, $E4D7, 0
word_18034
	dc.w	1
	dc.w	0, $E02, $E4E3, 0
word_1803E
	dc.w	1
	dc.w	0, $E02, $E4EF, 0
MapSpr_Unk0C
	dc.l	word_18064
	dc.l	word_180BE
	dc.l	word_18108
	dc.l	word_18172
	dc.l	word_181CC
	dc.l	word_18216
	dc.l	word_18270
word_18064
	dc.w	$B
	dc.w	0, $602, $E400, $28
	dc.w	$10, $302, $E406, $20
	dc.w	$10, $902, $E40A, $58
	dc.w	$18, 2, $E410, $28
	dc.w	$18, $502, $E411, $48
	dc.w	$28, $F02, $E415, $28
	dc.w	$28, $302, $E425, $48
	dc.w	$30, $202, $E429, $20
	dc.w	$38, 2, $E42C, $50
	dc.w	$48, $C02, $E42D, $28
	dc.w	$48, 2, $E431, $48
word_180BE
	dc.w	9
	dc.w	8, $502, $E432, $48
	dc.w	$10, $602, $E436, $10
	dc.w	$18, $702, $E43C, $40
	dc.w	$28, $502, $E444, $18
	dc.w	$28, $702, $E448, $30
	dc.w	$30, $302, $E450, $28
	dc.w	$38, $102, $E454, $20
	dc.w	$38, $902, $E456, $40
	dc.w	$48, $C02, $E45C, $30
word_18108
	dc.w	$D
	dc.w	8, $602, $E460, $30
	dc.w	$10, $402, $E466, $40
	dc.w	$18, $602, $E460, 0
	dc.w	$18, $302, $E468, $48
	dc.w	$20, $C02, $E46C, $10
	dc.w	$20, $302, $E470, $50
	dc.w	$28, $C02, $E474, $20
	dc.w	$28, $302, $E478, $40
	dc.w	$30, $B02, $E47C, $28
	dc.w	$38, $102, $E488, $20
	dc.w	$38, $202, $E48A, $48
	dc.w	$40, 2, $E48D, $50
	dc.w	$48, 2, $E48E, $40
word_18172
	dc.w	$B
	dc.w	0, $602, $E48F, $40
	dc.w	$10, $902, $E495, 8
	dc.w	$10, $302, $E49B, $50
	dc.w	$18, $502, $E49F, $20
	dc.w	$18, 2, $E4A3, $48
	dc.w	$28, $F02, $E4A4, $28
	dc.w	$28, $302, $E4B4, $48
	dc.w	$30, $202, $E4B8, $50
	dc.w	$38, 2, $E4BB, $20
	dc.w	$48, $C02, $E4BC, $28
	dc.w	$48, 2, $E431, $48
word_181CC
	dc.w	9
	dc.w	8, $902, $E4C0, $18
	dc.w	$10, $602, $E4C6, $58
	dc.w	$18, $702, $E4CC, $28
	dc.w	$28, $702, $E4D4, $38
	dc.w	$28, $502, $E4DC, $50
	dc.w	$30, $302, $E4E0, $48
	dc.w	$38, $902, $E4E4, $20
	dc.w	$38, $102, $E4EA, $50
	dc.w	$48, $C02, $E4EC, $28
word_18216
	dc.w	$B
	dc.w	8, $602, $E300, $38
	dc.w	$10, $402, $E306, $28
	dc.w	$18, $302, $E308, $28
	dc.w	$18, $502, $E30C, $68
	dc.w	$20, $C02, $E310, $48
	dc.w	$28, $F02, $E314, $30
	dc.w	$28, 2, $E324, $50
	dc.w	$30, $202, $E325, $20
	dc.w	$38, $202, $E328, $28
	dc.w	$38, $102, $E32B, $50
	dc.w	$48, $C02, $E32D, $30
word_18270
	dc.w	$B
	dc.w	8, $602, $E030, $38
	dc.w	$10, $402, $E036, $28
	dc.w	$18, $302, $E038, $28
	dc.w	$18, $502, $E03C, $68
	dc.w	$20, $C02, $E040, $48
	dc.w	$28, $F02, $E044, $30
	dc.w	$28, 2, $E054, $50
	dc.w	$30, $202, $E055, $20
	dc.w	$38, $202, $E058, $28
	dc.w	$38, $102, $E05B, $50
	dc.w	$48, $C02, $E05D, $30
MapSpr_Unk2E
	dc.l	word_182F2
	dc.l	word_1830C
	dc.l	word_18316
	dc.l	word_18368
	dc.l	word_18320
	dc.l	word_18332
	dc.l	word_1837A
	dc.l	word_1834C
	dc.l	word_18384
	dc.l	word_18356
word_182F2
	dc.w	3
	dc.w	0, $602, $E480, 8
	dc.w	8, $102, $E486, 0
	dc.w	8, $102, $E488, $18
word_1830C
	dc.w	1
	dc.w	0, $E02, $E48A, 0
word_18316
	dc.w	1
	dc.w	0, $E02, $E496, 0
word_18320
	dc.w	2
	dc.w	0, $D02, $E4A2, 0
	dc.w	$10, $802, $E4AA, 0
word_18332
	dc.w	3
	dc.w	0, $602, $E4AD, 8
	dc.w	8, $102, $E4B3, 0
	dc.w	8, $102, $E4B5, $18
word_1834C
	dc.w	1
	dc.w	0, $E02, $E4B7, 0
word_18356
	dc.w	2
	dc.w	0, $D02, $E4C3, 0
	dc.w	$10, $802, $E4CB, 0
word_18368
	dc.w	2
	dc.w	0, $A02, $E440, 0
	dc.w	8, $102, $E449, $18
word_1837A
	dc.w	1
	dc.w	0, $E02, $E44B, 0
word_18384
	dc.w	2
	dc.w	0, $A02, $E457, 0
	dc.w	8, $102, $E460, $18
MapSpr_Unk11
	dc.l	word_183A6
	dc.l	word_18408
	dc.l	word_18452
	dc.l	word_184A4
word_183A6
	dc.w	$C
	dc.w	0, $702, $E400, $10
	dc.w	8, $102, $E408, 8
	dc.w	8, $302, $E40A, $20
	dc.w	$10, $302, $E40E, $28
	dc.w	$18, $202, $E412, $30
	dc.w	$20, $502, $E415, $10
	dc.w	$28, $502, $E419, 0
	dc.w	$28, $202, $E41D, $20
	dc.w	$30, $102, $E420, $10
	dc.w	$30, $102, $E422, $28
	dc.w	$38, 2, $E424, 8
	dc.w	$38, 2, $E425, $18
word_18408
	dc.w	9
	dc.w	0, $302, $E426, $18
	dc.w	8, $302, $E42A, $20
	dc.w	$10, $902, $E42E, 0
	dc.w	$10, $302, $E434, $28
	dc.w	$18, $202, $E438, $30
	dc.w	$20, $B02, $E43B, 8
	dc.w	$28, $202, $E447, $20
	dc.w	$30, 2, $E44A, 0
	dc.w	$30, $102, $E44B, $28
word_18452
	dc.w	$A
	dc.w	8, $702, $E44D, $18
	dc.w	$10, $302, $E455, $10
	dc.w	$10, $302, $E459, $28
	dc.w	$18, $302, $E45D, 8
	dc.w	$18, $202, $E461, $30
	dc.w	$20, 2, $E464, $38
	dc.w	$28, $602, $E465, $18
	dc.w	$30, $102, $E46B, $10
	dc.w	$30, $102, $E46D, $28
	dc.w	$38, 2, $E46F, 8
word_184A4
	dc.w	6
	dc.w	8, $702, $E470, $18
	dc.w	$10, $302, $E478, $10
	dc.w	$10, $602, $E47C, $28
	dc.w	$28, $202, $E482, 8
	dc.w	$28, $A02, $E485, $18
	dc.w	$30, $102, $E48E, $10
MapSpr_Unk13
	dc.l	word_184E2
	dc.l	word_18554
	dc.l	word_185AE
word_184E2
	dc.w	$E
	dc.w	0, $702, $E400, $18
	dc.w	8, $702, $E408, 8
	dc.w	8, $302, $E410, $28
	dc.w	$10, $302, $E414, $30
	dc.w	$18, $102, $E418, 0
	dc.w	$18, $202, $E41A, $38
	dc.w	$20, $702, $E41D, $18
	dc.w	$28, $502, $E425, 8
	dc.w	$28, $302, $E429, $28
	dc.w	$30, 2, $E42D, $30
	dc.w	$38, $102, $E42E, $10
	dc.w	$40, 2, $E430, 8
	dc.w	$40, $402, $E431, $18
	dc.w	$40, 2, $E433, $30
word_18554
	dc.w	$B
	dc.w	0, $702, $E434, $18
	dc.w	8, $702, $E43C, 8
	dc.w	8, $302, $E444, $28
	dc.w	$10, $202, $E448, 0
	dc.w	$10, $702, $E44B, $30
	dc.w	$20, $702, $E453, $18
	dc.w	$28, $702, $E45B, 8
	dc.w	$28, $302, $E463, $28
	dc.w	$30, 2, $E467, $30
	dc.w	$40, $402, $E468, $18
	dc.w	$40, 2, $E433, $30
word_185AE
	dc.w	$B
	dc.w	0, $702, $E46A, $18
	dc.w	8, $702, $E472, 8
	dc.w	8, $302, $E47A, $28
	dc.w	$10, $202, $E47E, 0
	dc.w	$10, $702, $E481, $30
	dc.w	$20, $702, $E489, $18
	dc.w	$28, $702, $E491, 8
	dc.w	$28, $302, $E499, $28
	dc.w	$30, 2, $E49D, $30
	dc.w	$40, $402, $E49E, $18
	dc.w	$40, 2, $E433, $30
MapSpr_Unk12
	dc.l	word_18624
	dc.l	word_1867E
	dc.l	word_186D8
	dc.l	word_18732
	dc.l	word_1873C
	dc.l	word_18746
	dc.l	word_18750
word_18624
	dc.w	$B
	dc.w	0, $F02, $E400, 8
	dc.w	0, $A02, $E410, $28
	dc.w	8, $302, $E419, 0
	dc.w	$18, $602, $E41D, $28
	dc.w	$20, $F02, $E423, 8
	dc.w	$20, $102, $E433, $38
	dc.w	$28, $102, $E435, 0
	dc.w	$30, $202, $E437, $30
	dc.w	$38, $102, $E43A, $28
	dc.w	$40, $C02, $E43C, 0
	dc.w	$40, 2, $E440, $20
word_1867E
	dc.w	$B
	dc.w	0, $F02, $E441, 8
	dc.w	0, $A02, $E451, $28
	dc.w	8, $302, $E45A, 0
	dc.w	$18, $602, $E45E, $28
	dc.w	$20, $F02, $E464, 8
	dc.w	$20, $102, $E433, $38
	dc.w	$28, $102, $E435, 0
	dc.w	$30, $202, $E437, $30
	dc.w	$38, $102, $E43A, $28
	dc.w	$40, $C02, $E43C, 0
	dc.w	$40, 2, $E440, $20
word_186D8
	dc.w	$B
	dc.w	0, $F02, $E474, 8
	dc.w	0, $A02, $E484, $28
	dc.w	8, $302, $E48D, 0
	dc.w	$18, $602, $E41D, $28
	dc.w	$20, $F02, $E491, 8
	dc.w	$20, $102, $E433, $38
	dc.w	$28, $102, $E435, 0
	dc.w	$30, $202, $E437, $30
	dc.w	$38, $102, $E43A, $28
	dc.w	$40, $C02, $E43C, 0
	dc.w	$40, 2, $E440, $20
word_18732
	dc.w	1
	dc.w	0, 1, $84A1, 0
word_1873C
	dc.w	1
	dc.w	0, 1, $8CA1, 0
word_18746
	dc.w	1
	dc.w	0, 1, $94A1, 0
word_18750
	dc.w	1
	dc.w	0, 1, $9CA1, 0
MapSpr_Unk17
	dc.l	word_18772
	dc.l	word_187A4
	dc.l	word_187E6
	dc.l	word_18848
	dc.l	word_1889A
	dc.l	word_188D4
word_18772
	dc.w	6
	dc.w	8, $B02, $E400, 8
	dc.w	$10, $902, $E40C, $20
	dc.w	$20, $302, $E412, 0
	dc.w	$20, $702, $E416, $20
	dc.w	$28, $A02, $E41E, 8
	dc.w	$38, 2, $E427, $30
word_187A4
	dc.w	8
	dc.w	8, $B02, $E428, $10
	dc.w	$10, $302, $E434, 8
	dc.w	$18, $902, $E438, $28
	dc.w	$20, 2, $E43E, 0
	dc.w	$28, $E02, $E43F, $10
	dc.w	$30, $102, $E44B, 8
	dc.w	$38, 2, $E415, 0
	dc.w	$38, 2, $E427, $30
word_187E6
	dc.w	$C
	dc.w	0, $302, $E44D, $18
	dc.w	8, $302, $E451, $10
	dc.w	8, $702, $E455, $20
	dc.w	$10, $302, $E45D, 8
	dc.w	$18, $202, $E461, $30
	dc.w	$20, $302, $E464, $18
	dc.w	$20, $102, $E468, $38
	dc.w	$28, $202, $E46A, $10
	dc.w	$28, $602, $E46D, $20
	dc.w	$30, $102, $E44B, 8
	dc.w	$38, 2, $E415, 0
	dc.w	$38, 2, $E427, $30
word_18848
	dc.w	$A
	dc.w	0, $702, $E473, $18
	dc.w	8, $502, $E47B, $28
	dc.w	$10, $702, $E47F, 8
	dc.w	$18, $302, $E487, $28
	dc.w	$20, $702, $E48B, $18
	dc.w	$20, $102, $E493, $30
	dc.w	$28, 2, $E495, $38
	dc.w	$30, $502, $E496, 8
	dc.w	$38, 2, $E415, 0
	dc.w	$38, $402, $E49A, $28
word_1889A
	dc.w	7
	dc.w	8, $F02, $E49C, $10
	dc.w	$10, $302, $E4AC, $30
	dc.w	$18, $302, $E4B0, 8
	dc.w	$28, $E02, $E4B4, $10
	dc.w	$30, $402, $E4C0, $30
	dc.w	$38, $402, $E4C2, 0
	dc.w	$38, 2, $E427, $30
word_188D4
	dc.w	8
	dc.w	8, $F02, $E4C4, $10
	dc.w	$10, $302, $E45D, 8
	dc.w	$18, $202, $E461, $30
	dc.w	$20, $102, $E468, $38
	dc.w	$28, $E02, $E4D4, $10
	dc.w	$30, $102, $E44B, 8
	dc.w	$38, 2, $E415, 0
	dc.w	$38, 2, $E427, $30
MapSpr_Unk0E
	dc.l	word_189D8
	dc.l	word_189FA
	dc.l	word_18A1C
	dc.l	word_18942
	dc.l	word_18974
	dc.l	word_189A6
	dc.l	word_18A3E
	dc.l	word_18A80
	dc.l	word_18AC2
	dc.l	word_18ACC
	dc.l	word_18AD6
word_18942
	dc.w	6
	dc.w	0, $E02, $E400, 0
	dc.w	0, $302, $E40C, $20
	dc.w	8, $202, $E410, $28
	dc.w	$18, $A02, $E413, 8
	dc.w	$20, $102, $E41C, 0
	dc.w	$20, $102, $E41E, $20
word_18974
	dc.w	6
	dc.w	0, $F02, $E420, 0
	dc.w	0, $302, $E430, $28
	dc.w	8, $302, $E434, $20
	dc.w	$20, $D02, $E438, 0
	dc.w	$20, $102, $E440, $28
	dc.w	$28, 2, $E442, $20
word_189A6
	dc.w	6
	dc.w	0, $F02, $EC20, $10
	dc.w	0, $302, $EC30, 0
	dc.w	8, $302, $EC34, 8
	dc.w	$20, $D02, $EC38, $10
	dc.w	$20, $102, $EC40, 0
	dc.w	$28, 2, $EC42, 8
word_189D8
	dc.w	4
	dc.w	0, $F02, $E443, 8
	dc.w	8, $202, $E453, 0
	dc.w	$18, $202, $E456, $28
	dc.w	$20, $D02, $E459, 8
word_189FA
	dc.w	4
	dc.w	0, $B00, $E461, $18
	dc.w	8, $B00, $E46D, 0
	dc.w	$20, $900, $E479, $18
	dc.w	$28, $800, $E47F, 0
word_18A1C
	dc.w	4
	dc.w	0, $B00, $EC61, 0
	dc.w	8, $B00, $EC6D, $18
	dc.w	$20, $900, $EC79, 0
	dc.w	$28, $800, $EC7F, $18
word_18A3E
	dc.w	8
	dc.w	0, $B02, $E482, 8
	dc.w	0, $302, $E48E, $28
	dc.w	8, $302, $E492, 0
	dc.w	8, $302, $E496, $20
	dc.w	$20, $902, $E49A, 8
	dc.w	$20, $102, $E4A0, $28
	dc.w	$28, 2, $E4A2, 0
	dc.w	$28, 2, $E4A3, $20
word_18A80
	dc.w	8
	dc.w	0, $B02, $E4A4, 8
	dc.w	0, $302, $E48E, $28
	dc.w	8, $302, $E492, 0
	dc.w	8, $302, $E496, $20
	dc.w	$20, $902, $E49A, 8
	dc.w	$20, $102, $E4A0, $28
	dc.w	$28, 2, $E4A2, 0
	dc.w	$28, 2, $E4A3, $20
word_18AC2
	dc.w	1
	dc.w	8, 1, $E4B0, 0
word_18ACC
	dc.w	1
	dc.w	8, $401, $E4B1, 0
word_18AD6
	dc.w	1
	dc.w	0, $501, $E4B3, 0
MapSpr_Unk18
	dc.l	word_18AF4
	dc.l	word_18B3E
	dc.l	word_18B88
	dc.l	word_18BDA
	dc.l	word_18C24
word_18AF4
	dc.w	9
	dc.w	8, $702, $E400, $18
	dc.w	$10, $302, $E408, $10
	dc.w	$18, $302, $E40C, $28
	dc.w	$20, $302, $E410, $30
	dc.w	$28, $702, $E414, $18
	dc.w	$28, $302, $E41C, $38
	dc.w	$30, $202, $E420, $10
	dc.w	$38, $102, $E423, $28
	dc.w	$40, 2, $E425, $30
word_18B3E
	dc.w	9
	dc.w	8, $702, $E426, $18
	dc.w	$10, $302, $E42E, $10
	dc.w	$10, $302, $E432, $28
	dc.w	$20, $302, $E436, $30
	dc.w	$28, $702, $E43A, $18
	dc.w	$28, $302, $E442, $38
	dc.w	$30, $202, $E446, $10
	dc.w	$30, $202, $E449, $28
	dc.w	$40, 2, $E44C, $30
word_18B88
	dc.w	$A
	dc.w	0, $702, $E44D, $18
	dc.w	$10, $302, $E455, $28
	dc.w	$18, $302, $E459, $10
	dc.w	$20, $702, $E45D, $18
	dc.w	$20, $302, $E465, $30
	dc.w	$28, $302, $E469, $38
	dc.w	$30, $202, $E46D, $28
	dc.w	$38, $102, $E470, $10
	dc.w	$40, $402, $E472, $18
	dc.w	$40, 2, $E474, $30
word_18BDA
	dc.w	9
	dc.w	8, $702, $E475, $18
	dc.w	$10, $302, $E47D, $10
	dc.w	$18, $302, $E481, $28
	dc.w	$20, $302, $E485, $30
	dc.w	$28, $702, $E489, $18
	dc.w	$28, $302, $E491, $38
	dc.w	$30, $202, $E495, $10
	dc.w	$38, $102, $E498, $28
	dc.w	$40, 2, $E49A, $30
word_18C24
	dc.w	8
	dc.w	$10, $702, $E49B, $18
	dc.w	$18, $302, $E4A3, $10
	dc.w	$18, $302, $E4A7, $28
	dc.w	$28, $702, $E4AB, $30
	dc.w	$30, $602, $E4B3, $18
	dc.w	$30, $202, $E4B9, $40
	dc.w	$38, $102, $E4BC, $10
	dc.w	$38, $102, $E4BE, $28
MapSpr_Unk14
	dc.l	word_18C9A
	dc.l	word_18CFC
	dc.l	word_18D36
	dc.l	word_18D80
	dc.l	word_18DD2
	dc.l	word_18E0C
	dc.l	word_18E3E
	dc.l	word_18E88
	dc.l	word_18EEA
	dc.l	word_18F4C
	dc.l	word_18F9E
	dc.l	word_18FF0
	dc.l	word_1903A
word_18C9A
	dc.w	$C
	dc.w	0, $802, $E400, $18
	dc.w	8, $302, $E403, $10
	dc.w	8, $302, $E407, $28
	dc.w	$10, $702, $E40B, $18
	dc.w	$10, $302, $E413, $30
	dc.w	$18, $202, $E417, 8
	dc.w	$18, $102, $E41A, $38
	dc.w	$28, 2, $E41C, $10
	dc.w	$28, $102, $E41D, $28
	dc.w	$30, $402, $E41F, $18
	dc.w	$38, $D02, $E4D7, $10
	dc.w	8, $402, $E4DF, $18
word_18CFC
	dc.w	7
	dc.w	0, $B02, $E421, $10
	dc.w	8, $302, $E42D, $28
	dc.w	$10, $202, $E431, 8
	dc.w	$10, $302, $E434, $30
	dc.w	$20, $802, $E438, $10
	dc.w	$28, $902, $E43B, $18
	dc.w	$38, $D02, $E4D7, $10
word_18D36
	dc.w	9
	dc.w	0, $302, $E441, $10
	dc.w	8, $702, $E445, 0
	dc.w	8, $702, $E44D, $18
	dc.w	$10, $702, $E455, $28
	dc.w	$18, $102, $E45D, $38
	dc.w	$20, 2, $E45F, $10
	dc.w	$28, $502, $E43B, $18
	dc.w	$30, 2, $E460, $28
	dc.w	$38, $D02, $E4D7, $10
word_18D80
	dc.w	$A
	dc.w	0, $502, $E461, 0
	dc.w	8, 2, $E465, $10
	dc.w	$10, $202, $E466, 0
	dc.w	$10, $F02, $E469, $18
	dc.w	$18, $302, $E479, $38
	dc.w	$20, $402, $E47D, 8
	dc.w	$30, $402, $E41F, $18
	dc.w	$30, 2, $E47F, $30
	dc.w	$38, $D02, $E4D7, $10
	dc.w	$10, $502, $E4E5, 8
word_18DD2
	dc.w	7
	dc.w	0, $B02, $E480, $10
	dc.w	$10, $702, $E48C, $28
	dc.w	$18, $502, $E494, 0
	dc.w	$20, $802, $E498, $10
	dc.w	$28, $502, $E49B, $18
	dc.w	$30, $402, $E49F, $28
	dc.w	$38, $D02, $E4D7, $10
word_18E0C
	dc.w	6
	dc.w	0, $B02, $E4A1, $10
	dc.w	$10, $702, $E4AD, $28
	dc.w	$18, $102, $E4B5, 8
	dc.w	$20, $902, $E4B7, $10
	dc.w	$30, $802, $E4BD, $18
	dc.w	$38, $D02, $E4D7, $10
word_18E3E
	dc.w	9
	dc.w	8, $C02, $E4C0, 8
	dc.w	8, $302, $E4C4, $28
	dc.w	$10, $702, $E4C8, $18
	dc.w	$10, $302, $E4D0, $30
	dc.w	$20, 2, $E4D4, $10
	dc.w	$28, $102, $E4D5, $28
	dc.w	$30, $402, $E41F, $18
	dc.w	$38, $D02, $E4D7, $10
	dc.w	$10, $502, $E4F1, 8
word_18E88
	dc.w	$C
	dc.w	0, $802, $E400, $18
	dc.w	8, $302, $E403, $10
	dc.w	8, $302, $E407, $28
	dc.w	$10, $702, $E40B, $18
	dc.w	$10, $302, $E413, $30
	dc.w	$18, $202, $E417, 8
	dc.w	$18, $102, $E41A, $38
	dc.w	$28, 2, $E41C, $10
	dc.w	$28, $102, $E41D, $28
	dc.w	$30, $402, $E41F, $18
	dc.w	$38, $D02, $E4D7, $10
	dc.w	8, $402, $E4E1, $18
word_18EEA
	dc.w	$C
	dc.w	0, $802, $E400, $18
	dc.w	8, $302, $E403, $10
	dc.w	8, $302, $E407, $28
	dc.w	$10, $702, $E40B, $18
	dc.w	$10, $302, $E413, $30
	dc.w	$18, $202, $E417, 8
	dc.w	$18, $102, $E41A, $38
	dc.w	$28, 2, $E41C, $10
	dc.w	$28, $102, $E41D, $28
	dc.w	$30, $402, $E41F, $18
	dc.w	$38, $D02, $E4D7, $10
	dc.w	8, $402, $E4E3, $18
word_18F4C
	dc.w	$A
	dc.w	0, $502, $E461, 0
	dc.w	8, 2, $E465, $10
	dc.w	$10, $202, $E466, 0
	dc.w	$10, $F02, $E469, $18
	dc.w	$18, $302, $E479, $38
	dc.w	$20, $402, $E47D, 8
	dc.w	$30, $402, $E41F, $18
	dc.w	$30, 2, $E47F, $30
	dc.w	$38, $D02, $E4D7, $10
	dc.w	$10, $502, $E4E9, 8
word_18F9E
	dc.w	$A
	dc.w	0, $502, $E461, 0
	dc.w	8, 2, $E465, $10
	dc.w	$10, $202, $E466, 0
	dc.w	$10, $F02, $E469, $18
	dc.w	$18, $302, $E479, $38
	dc.w	$20, $402, $E47D, 8
	dc.w	$30, $402, $E41F, $18
	dc.w	$30, 2, $E47F, $30
	dc.w	$38, $D02, $E4D7, $10
	dc.w	$10, $502, $E4ED, 8
word_18FF0
	dc.w	9
	dc.w	8, $C02, $E4C0, 8
	dc.w	8, $302, $E4C4, $28
	dc.w	$10, $702, $E4C8, $18
	dc.w	$10, $302, $E4D0, $30
	dc.w	$20, 2, $E4D4, $10
	dc.w	$28, $102, $E4D5, $28
	dc.w	$30, $402, $E41F, $18
	dc.w	$38, $D02, $E4D7, $10
	dc.w	$10, $502, $E4F5, 8
word_1903A
	dc.w	9
	dc.w	8, $C02, $E4C0, 8
	dc.w	8, $302, $E4C4, $28
	dc.w	$10, $702, $E4C8, $18
	dc.w	$10, $302, $E4D0, $30
	dc.w	$20, 2, $E4D4, $10
	dc.w	$28, $102, $E4D5, $28
	dc.w	$30, $402, $E41F, $18
	dc.w	$38, $D02, $E4D7, $10
	dc.w	$10, $502, $E4F9, 8
MapSpr_Unk08
	dc.l	word_190CC
	dc.l	word_190D6
	dc.l	word_190E0
	dc.l	word_190EA
	dc.l	word_190F4
	dc.l	word_190FE
	dc.l	word_19108
	dc.l	word_19112
	dc.l	word_1911C
	dc.l	word_19126
	dc.l	word_19178
	dc.l	word_19182
	dc.l	word_1918C
	dc.l	word_19196
	dc.l	word_191A0
	dc.l	word_191AA
	dc.l	word_191B4
	dc.l	word_191C6
word_190CC
	dc.w	1
	dc.w	$FFF8, $502, $E330, $FFF8
word_190D6
	dc.w	1
	dc.w	$FFF8, $502, $E38A, $FFF8
word_190E0
	dc.w	1
	dc.w	$FFF8, $502, $E38E, $FFF8
word_190EA
	dc.w	1
	dc.w	$FFF8, $502, $E392, $FFF8
word_190F4
	dc.w	1
	dc.w	$FFF8, $502, $E396, $FFF8
word_190FE
	dc.w	1
	dc.w	$FFF8, $502, $E340, $FFF8
word_19108
	dc.w	1
	dc.w	$FFF8, $502, $E3A6, $FFF8
word_19112
	dc.w	1
	dc.w	$FFF8, $502, $E3AA, $FFF8
word_1911C
	dc.w	1
	dc.w	$FFF8, $502, $EBA6, $FFF8
word_19126
	dc.w	$A
	dc.w	0, $C00, $E014, 0
	dc.w	0, $C00, $E814, $30
	dc.w	$30, $C00, $F014, 0
	dc.w	$30, $C00, $F814, $30
	dc.w	8, $200, $E018, 0
	dc.w	8, $200, $E818, $48
	dc.w	$20, $100, $E818, $48
	dc.w	$20, $100, $E018, 0
	dc.w	$30, $400, $F015, $20
	dc.w	0, $400, $E015, $20
word_19178
	dc.w	1
	dc.w	2, $403, $C020, $A
word_19182
	dc.w	1
	dc.w	1, $403, $C022, 9
word_1918C
	dc.w	1
	dc.w	1, $803, $C024, 6
word_19196
	dc.w	1
	dc.w	1, $803, $C027, 5
word_191A0
	dc.w	1
	dc.w	1, $803, $C02A, 4
word_191AA
	dc.w	1
	dc.w	1, $C03, $C02D, 3
word_191B4
	dc.w	2
	dc.w	0, $C03, $C031, 2
	dc.w	8, $803, $C035, 2
word_191C6
	dc.w	1
	dc.w	0, $D03, $C038, 0
MapSpr_Unk31
	dc.l	word_19240
	dc.l	word_1924A
	dc.l	word_19254
	dc.l	word_1925E
	dc.l	word_19268
	dc.l	word_19272
	dc.l	word_1927C
	dc.l	word_1928E
	dc.l	word_19298
	dc.l	word_192A2
	dc.l	word_192B4
	dc.l	word_192BE
	dc.l	word_192C8
	dc.l	word_192D2
	dc.l	word_192DC
	dc.l	word_192E6
	dc.l	word_192F0
	dc.l	word_192FA
	dc.l	word_19304
	dc.l	word_1930E
	dc.l	word_19318
	dc.l	word_19322
	dc.l	word_1932C
	dc.l	word_19336
	dc.l	word_19340
	dc.l	word_1934A
	dc.l	word_19354
	dc.l	word_1935E
word_19240
	dc.w	1
	dc.w	1, $F03, $C400, 0
word_1924A
	dc.w	1
	dc.w	1, $F03, $C410, 0
word_19254
	dc.w	1
	dc.w	1, $B03, $C420, 4
word_1925E
	dc.w	1
	dc.w	0, $B03, $C42C, 5
word_19268
	dc.w	1
	dc.w	$48, $F03, $C438, 0
word_19272
	dc.w	1
	dc.w	$50, $E03, $C448, 0
word_1927C
	dc.w	2
	dc.w	$20, $F03, $C454, 0
	dc.w	$40, $403, $C464, $A
word_1928E
	dc.w	1
	dc.w	$10, $F03, $C466, 0
word_19298
	dc.w	1
	dc.w	4, $F03, $C476, 0
word_192A2
	dc.w	2
	dc.w	$23, $B03, $C486, 3
	dc.w	$43, $403, $C492, 8
word_192B4
	dc.w	1
	dc.w	$20, $F03, $E494, 0
word_192BE
	dc.w	1
	dc.w	$20, $F03, $E4A4, 0
word_192C8
	dc.w	1
	dc.w	$C, $B03, $E4B4, 6
word_192D2
	dc.w	1
	dc.w	2, $E03, $E4C0, 0
word_192DC
	dc.w	1
	dc.w	$D, $F03, $E4CC, 0
word_192E6
	dc.w	1
	dc.w	$1F, $F03, $C4DC, 0
word_192F0
	dc.w	1
	dc.w	$27, $E03, $C4EC, 0
word_192FA
	dc.w	1
	dc.w	$C, $B03, $C4F8, 2
word_19304
	dc.w	1
	dc.w	$D, $A03, $C504, 3
word_1930E
	dc.w	1
	dc.w	0, $A03, $C50D, 2
word_19318
	dc.w	1
	dc.w	7, $E03, $C516, 0
word_19322
	dc.w	1
	dc.w	$D, $E03, $C522, 0
word_1932C
	dc.w	1
	dc.w	$C, 4, $E52E, $C
word_19336
	dc.w	1
	dc.w	4, $E04, $E52F, 4
word_19340
	dc.w	1
	dc.w	0, $F04, $E53B, 0
word_1934A
	dc.w	1
	dc.w	0, $F04, $E54B, 0
word_19354
	dc.w	1
	dc.w	0, $F04, $855B, 0
word_1935E
	dc.w	1
	dc.w	0, $F04, $856B, 0
MapSpr_Unk32
	dc.l	word_193B8
	dc.l	word_193D2
	dc.l	word_193EC
	dc.l	word_1940E
	dc.l	word_19430
	dc.l	word_19452
	dc.l	word_19474
	dc.l	word_1948E
	dc.l	word_194A8
	dc.l	word_194C2
	dc.l	word_194DC
	dc.l	word_194F6
	dc.l	word_19510
	dc.l	word_1952A
	dc.l	word_1954C
	dc.l	word_1956E
	dc.l	word_19590
	dc.l	word_195B2
	dc.l	word_195CC
	dc.l	word_195E6
word_193B8
	dc.w	3
	dc.w	0, $F01, $8131, 0
	dc.w	0, $F01, $8141, $20
	dc.w	0, $F01, $8151, $40
word_193D2
	dc.w	3
	dc.w	0, $F01, $8161, 0
	dc.w	0, $F01, $8141, $20
	dc.w	0, $F01, $8151, $40
word_193EC
	dc.w	4
	dc.w	8, $501, $8171, 0
	dc.w	0, $701, $8175, $10
	dc.w	0, $F01, $8141, $20
	dc.w	0, $F01, $8151, $40
word_1940E
	dc.w	4
	dc.w	8, $901, $817D, 0
	dc.w	0, $301, $8183, $18
	dc.w	0, $F01, $8187, $20
	dc.w	0, $F01, $8151, $40
word_19430
	dc.w	4
	dc.w	8, $D01, $8197, 0
	dc.w	0, $D01, $819F, $20
	dc.w	$10, $D01, $81A7, $20
	dc.w	0, $F01, $8151, $40
word_19452
	dc.w	4
	dc.w	8, $D01, $81AF, 0
	dc.w	0, $701, $81B7, $20
	dc.w	0, $701, $81BF, $30
	dc.w	0, $F01, $81C7, $40
word_19474
	dc.w	3
	dc.w	8, $501, $81D7, $10
	dc.w	8, $D01, $81DB, $20
	dc.w	0, $F01, $81E3, $40
word_1948E
	dc.w	3
	dc.w	8, $D01, $81F3, 0
	dc.w	8, $D01, $81FB, $20
	dc.w	0, $F01, $8203, $40
word_194A8
	dc.w	3
	dc.w	8, $901, $8213, 0
	dc.w	8, $901, $8219, $28
	dc.w	8, $D01, $821F, $40
word_194C2
	dc.w	3
	dc.w	8, $D01, $8227, 0
	dc.w	8, $D01, $822F, $20
	dc.w	8, $D01, $8237, $40
word_194DC
	dc.w	3
	dc.w	8, $D01, $823F, 0
	dc.w	8, $501, $8247, $20
	dc.w	8, $D01, $824B, $40
word_194F6
	dc.w	3
	dc.w	0, $F01, $8253, 0
	dc.w	8, $D01, $8263, $20
	dc.w	8, $D01, $826B, $40
word_19510
	dc.w	3
	dc.w	0, $F01, $8273, 0
	dc.w	8, $D01, $8283, $20
	dc.w	8, $101, $828B, $40
word_1952A
	dc.w	4
	dc.w	0, $F01, $828D, 0
	dc.w	0, $701, $829D, $20
	dc.w	8, $501, $91FF, $30
	dc.w	8, $D01, $82A5, $40
word_1954C
	dc.w	4
	dc.w	0, $F01, $9131, 0
	dc.w	0, $701, $82AD, $20
	dc.w	8, $501, $91DF, $30
	dc.w	8, $D01, $82B5, $40
word_1956E
	dc.w	4
	dc.w	0, $F01, $9131, 0
	dc.w	0, $F01, $82BD, $20
	dc.w	0, $301, $82CD, $40
	dc.w	8, $901, $9239, $48
word_19590
	dc.w	4
	dc.w	0, $F01, $9131, 0
	dc.w	0, $F01, $9141, $20
	dc.w	0, $301, $82D1, $40
	dc.w	8, $901, $9221, $48
word_195B2
	dc.w	3
	dc.w	0, $F01, $9131, 0
	dc.w	0, $F01, $9141, $20
	dc.w	0, $F01, $82D5, $40
word_195CC
	dc.w	3
	dc.w	0, $F01, $9131, 0
	dc.w	0, $F01, $9141, $20
	dc.w	0, $F01, $9151, $40
word_195E6
	dc.w	5
	dc.w	0, $F01, $8100, 0
	dc.w	0, $F01, $8110, $20
	dc.w	0, $F01, $8120, $40
	dc.w	$18, 1, $8130, $60
	dc.w	0, $400, $82E5, $5C
MapSpr_Unk40
	dc.l	word_197AC
	dc.l	word_197B6
	dc.l	word_197C8
	dc.l	word_197DA
	dc.l	word_197EC
	dc.l	word_197FE
	dc.l	word_19808
	dc.l	word_19812
	dc.l	word_19826
	dc.l	word_19826
	dc.l	word_19830
	dc.l	word_1983A
	dc.l	word_19844
	dc.l	word_1984E
	dc.l	word_19858
	dc.l	word_19862
	dc.l	word_1986C
	dc.l	word_19876
	dc.l	word_19880
	dc.l	word_1988A
	dc.l	word_19894
	dc.l	word_1989E
	dc.l	word_198A8
	dc.l	word_198B2
	dc.l	word_198BC
	dc.l	word_198C6
	dc.l	word_198F0
	dc.l	word_1991A
	dc.l	word_19944
	dc.l	word_1994E
	dc.l	word_19958
	dc.l	word_19962
	dc.l	word_1996C
	dc.l	word_19976
	dc.l	word_19980
	dc.l	word_1998A
	dc.l	word_19994
	dc.l	word_1999E
	dc.l	word_199A8
	dc.l	word_199B2
	dc.l	word_199BC
	dc.l	word_199CE
	dc.l	word_199E0
	dc.l	word_199F2
	dc.l	word_19A04
	dc.l	word_19A16
	dc.l	word_19A28
	dc.l	word_19A32
	dc.l	word_19A3C
	dc.l	word_19A46
	dc.l	word_19A50
	dc.l	word_19A5A
	dc.l	word_19A64
	dc.l	word_19A6E
	dc.l	word_19A78
	dc.l	word_19A8A
	dc.l	word_19A9C
	dc.l	word_19AAE
	dc.l	word_19ACA
	dc.l	word_19AD4
	dc.l	word_19ADE
	dc.l	word_19AE8
	dc.l	word_19AF2
	dc.l	word_19B04
	dc.l	word_19B16
	dc.l	word_19B28
	dc.l	word_19B3A
	dc.l	word_19AC0
	dc.l	word_19B44
	dc.l	word_19B56
	dc.l	word_19B68
	dc.l	word_19B7A
	dc.l	word_19B8C
	dc.l	word_19B9E
	dc.l	word_19BA8
	dc.l	word_19BB2
	dc.l	word_19BBC
	dc.l	word_19BC6
	dc.l	word_19BD0
	dc.l	word_19C2A
	dc.l	word_19C34
	dc.l	word_19C3E
	dc.l	word_19C48
	dc.l	word_19BDA
	dc.l	word_19BE4
	dc.l	word_19BEE
	dc.l	word_19BF8
	dc.l	word_19C02
	dc.l	word_19C0C
	dc.l	word_19C16
	dc.l	word_19C20
	dc.l	word_19C52
	dc.l	word_19C5C
	dc.l	word_19C66
	dc.l	word_19C70
	dc.l	word_19C7A
	dc.l	word_19C84
	dc.l	word_19C8E
	dc.l	word_19C98
	dc.l	word_19CA2
	dc.l	word_19CAC
	dc.l	word_19CB6
	dc.l	word_19CC8
word_197AC
	dc.w	2
	dc.w	0, 3, $3FF, 0
word_197B6
	dc.w	2
	dc.w	$FFE0, $A03, $637B, $FFF8
	dc.w	$FFF8, $403, $6384, $FFF8
word_197C8
	dc.w	2
	dc.w	$FFE0, $A03, $6386, $FFF8
	dc.w	$FFF8, $403, $638F, $FFF8
word_197DA
	dc.w	2
	dc.w	$FFE0, $A03, $391, $FFF8
	dc.w	$FFF8, $403, $39A, $FFF8
word_197EC
	dc.w	2
	dc.w	$FFE0, $A03, $370, $FFF8
	dc.w	$FFF8, $403, $379, $FFF8
word_197FE
	dc.w	1
	dc.w	$FFFC, 3, $239D, $FFFC
word_19808
	dc.w	1
	dc.w	$FFFC, 3, $639E, $FFFC
word_19812
	dc.w	1
	dc.w	$FFFC, 3, $639C, $FFFC
	dc.w	1
	dc.w	$FFFC, 3, $1FE, $FFFC
word_19826
	dc.w	1
	dc.w	$FFFC, 3, $1FF, $FFFC
word_19830
	dc.w	1
	dc.w	$FFFC, $F03, $1FB, $FFF0
word_1983A
	dc.w	1
	dc.w	0, $F03, $1FB, 0
word_19844
	dc.w	1
	dc.w	0, $F03, $1FB, 0
word_1984E
	dc.w	1
	dc.w	0, $F03, $1FB, 0
word_19858
	dc.w	1
	dc.w	0, $F03, $1FB, 0
word_19862
	dc.w	1
	dc.w	0, $F03, $1FB, 0
word_1986C
	dc.w	1
	dc.w	$FFE0, $303, $3E5, 0
word_19876
	dc.w	1
	dc.w	$FFE0, $303, $3E9, 0
word_19880
	dc.w	1
	dc.w	$FFE0, $303, $3ED, 0
word_1988A
	dc.w	1
	dc.w	$FFE0, $303, $3F1, 0
word_19894
	dc.w	1
	dc.w	$FFE0, $303, $3F5, 0
word_1989E
	dc.w	1
	dc.w	0, $F03, $1FB, 0
word_198A8
	dc.w	1
	dc.w	0, 3, $39F, 0
word_198B2
	dc.w	1
	dc.w	0, 3, $3A0, 1
word_198BC
	dc.w	1
	dc.w	1, 3, $3A1, 5
word_198C6
	dc.w	5
	dc.w	0, $503, $63A2, 0
	dc.w	8, $703, $63A6, $10
	dc.w	$10, $303, $63AE, 8
	dc.w	$20, $903, $63B2, $FFF0
	dc.w	$30, $803, $63B8, $FFF8
word_198F0
	dc.w	5
	dc.w	0, $503, $63BB, 0
	dc.w	8, $703, $63BF, $10
	dc.w	$10, $303, $63AE, 8
	dc.w	$20, $903, $63C7, $FFF0
	dc.w	$30, $803, $63CD, $FFF8
word_1991A
	dc.w	5
	dc.w	0, $503, $63D0, 0
	dc.w	8, $703, $63D4, $10
	dc.w	$10, $303, $63AE, 8
	dc.w	$20, $903, $63DC, $FFF0
	dc.w	$30, $803, $63E2, $FFF8
word_19944
	dc.w	1
	dc.w	$FFFC, $403, $3F9, $FFF0
word_1994E
	dc.w	1
	dc.w	$FFF8, $903, $3FB, $FFE8
word_19958
	dc.w	1
	dc.w	$FFF4, $E03, $401, $FFDC
word_19962
	dc.w	1
	dc.w	$FFF4, $E03, $419, $FFDC
word_1996C
	dc.w	1
	dc.w	$FFF4, $E03, $40D, $FFDC
word_19976
	dc.w	1
	dc.w	$FFF4, $A03, $425, $FFDC
word_19980
	dc.w	1
	dc.w	$FFE0, $B03, $644C, $FFF4
word_1998A
	dc.w	1
	dc.w	$FFE0, $B03, $6458, $FFF4
word_19994
	dc.w	1
	dc.w	$FFE0, $B03, $6464, $FFF4
word_1999E
	dc.w	1
	dc.w	$FFE0, $B03, $2470, $FFF4
word_199A8
	dc.w	1
	dc.w	$FFE0, $B03, $247C, $FFF4
word_199B2
	dc.w	1
	dc.w	$FFE0, $B03, $2488, $FFF4
word_199BC
	dc.w	2
	dc.w	$FFF0, $903, $446, $FFF4
	dc.w	$FFE0, $903, $42E, $FFF4
word_199CE
	dc.w	2
	dc.w	$FFF0, $903, $446, $FFF4
	dc.w	$FFE0, $903, $434, $FFF4
word_199E0
	dc.w	2
	dc.w	$FFF0, $903, $446, $FFF4
	dc.w	$FFE0, $903, $43A, $FFF4
word_199F2
	dc.w	2
	dc.w	$FFF0, $903, $446, $FFF4
	dc.w	$FFE1, $903, $42E, $FFF4
word_19A04
	dc.w	2
	dc.w	$FFF0, $903, $446, $FFF4
	dc.w	$FFE1, $903, $434, $FFF4
word_19A16
	dc.w	2
	dc.w	$FFF0, $903, $446, $FFF4
	dc.w	$FFE1, $903, $43A, $FFF4
word_19A28
	dc.w	1
	dc.w	$FFFC, 3, $2495, $FFFC
word_19A32
	dc.w	1
	dc.w	$FFFC, 3, $2494, $FFFC
word_19A3C
	dc.w	1
	dc.w	$FFFC, 3, $2C95, $FFFC
word_19A46
	dc.w	1
	dc.w	$FFFC, 3, $2C94, $FFFC
word_19A50
	dc.w	1
	dc.w	$FFFC, 3, $3495, $FFFC
word_19A5A
	dc.w	1
	dc.w	$FFFC, 3, $3494, $FFFC
word_19A64
	dc.w	1
	dc.w	$FFFC, 3, $3C95, $FFFC
word_19A6E
	dc.w	1
	dc.w	$FFFC, 3, $3C94, $FFFC
word_19A78
	dc.w	2
	dc.w	$FFD0, $603, $2496, 8
	dc.w	$FFE8, $A03, $249C, $FFF8
word_19A8A
	dc.w	2
	dc.w	$FFC8, $A03, $24A5, $FFF8
	dc.w	$FFE0, $B03, $24AE, $FFF8
word_19A9C
	dc.w	2
	dc.w	$FFD0, $603, $2C96, $FFF0
	dc.w	$FFE8, $A03, $2C9C, $FFF8
word_19AAE
	dc.w	2
	dc.w	$FFE0, $F03, $A2E9, $FFEC
	dc.w	$FFF0, $103, $A2F9, $C
word_19AC0
	dc.w	1
	dc.w	$FFE0, $F03, $A2E9, $FFEC
word_19ACA
	dc.w	1
	dc.w	$FFF8, $502, $E383, $FFF8
word_19AD4
	dc.w	1
	dc.w	$FFF8, $502, $E387, $FFF8
word_19ADE
	dc.w	1
	dc.w	$FFF8, $502, $E38B, $FFF8
word_19AE8
	dc.w	1
	dc.w	$FFF8, $502, $E38F, $FFF8
word_19AF2
	dc.w	2
	dc.w	$FFF8, $502, $8383, $FFF8
	dc.w	0, $402, $C393, $FFF6
word_19B04
	dc.w	2
	dc.w	$FFF8, $502, $8387, $FFF8
	dc.w	0, $402, $C395, $FFF6
word_19B16
	dc.w	2
	dc.w	$FFF8, $502, $838B, $FFF8
	dc.w	0, $402, $C397, $FFF6
word_19B28
	dc.w	2
	dc.w	$FFF8, $502, $838F, $FFF8
	dc.w	0, $402, $C393, $FFF6
word_19B3A
	dc.w	1
	dc.w	0, $402, $C30F, $FFF6
word_19B44
	dc.w	2
	dc.w	$FFD8, $303, $24E0, $FFFC
	dc.w	$FFF8, 3, $24E4, $FFFC
word_19B56
	dc.w	2
	dc.w	$FFD8, $303, $24E5, $FFFC
	dc.w	$FFF8, 3, $24E4, $FFFC
word_19B68
	dc.w	2
	dc.w	$FFD8, $303, $24E9, $FFFC
	dc.w	$FFF8, 3, $24ED, $FFFC
word_19B7A
	dc.w	2
	dc.w	$FFD8, $303, $24EE, $FFFC
	dc.w	$FFF8, 3, $24F2, $FFFC
word_19B8C
	dc.w	2
	dc.w	$FFD8, $303, $24F3, $FFFC
	dc.w	$FFF8, 3, $24F2, $FFFC
word_19B9E
	dc.w	1
	dc.w	$FFFC, 3, $4097, $FFFC
word_19BA8
	dc.w	1
	dc.w	$FFFC, 3, $4098, $FFFC
word_19BB2
	dc.w	1
	dc.w	$FFFC, 3, $4099, $FFFC
word_19BBC
	dc.w	1
	dc.w	$FFFC, 3, $409A, $FFFC
word_19BC6
	dc.w	1
	dc.w	$FFFC, 3, $409B, $FFFC
word_19BD0
	dc.w	1
	dc.w	$FFFC, 3, $409C, $FFFC
word_19BDA
	dc.w	1
	dc.w	$FFFC, 3, $409D, $FFFC
word_19BE4
	dc.w	1
	dc.w	$FFFC, 3, $409E, $FFFC
word_19BEE
	dc.w	1
	dc.w	$FFFC, 3, $409F, $FFFC
word_19BF8
	dc.w	1
	dc.w	$FFFC, 3, $40A0, $FFFC
word_19C02
	dc.w	1
	dc.w	$FFFC, 3, $40A1, $FFFC
word_19C0C
	dc.w	1
	dc.w	$FFFC, 3, $40A2, $FFFC
word_19C16
	dc.w	1
	dc.w	$FFFC, 3, $40A3, $FFFC
word_19C20
	dc.w	1
	dc.w	$FFFC, 3, $40A4, $FFFC
word_19C2A
	dc.w	1
	dc.w	$FFFC, 2, $A080, $FFFC
word_19C34
	dc.w	1
	dc.w	$FFF8, $502, $A081, $FFF8
word_19C3E
	dc.w	1
	dc.w	$FFF8, $502, $A085, $FFF8
word_19C48
	dc.w	1
	dc.w	$FFF8, $502, $A089, $FFF8
word_19C52
	dc.w	1
	dc.w	$FFF8, $502, $E3AE, $FFF8
word_19C5C
	dc.w	1
	dc.w	$FFF8, $902, $E3B2, $FFF0
word_19C66
	dc.w	1
	dc.w	$FFF8, $902, $E3B8, $FFF0
word_19C70
	dc.w	1
	dc.w	$FFF8, $502, $E3BE, $FFF8
word_19C7A
	dc.w	1
	dc.w	$FFF8, $502, $E338, $FFF8
word_19C84
	dc.w	1
	dc.w	$FFF8, $A02, $E3C2, $FFF8
word_19C8E
	dc.w	1
	dc.w	$FFF8, $A02, $E3CB, $FFF8
word_19C98
	dc.w	1
	dc.w	$FFF8, $500, $E396, $FFF8
word_19CA2
	dc.w	1
	dc.w	$FFF8, $500, $E39A, $FFF8
word_19CAC
	dc.w	1
	dc.w	$FFF8, $500, $E39E, $FFF8
word_19CB6
	dc.w	2
	dc.w	$FFF0, $100, $E3A2, $FFF0
	dc.w	$FFF8, $500, $E39A, $FFF8
word_19CC8
	dc.w	2
	dc.w	$FFF0, $100, $E3A4, $FFF0
	dc.w	$FFF8, $500, $E39A, $FFF8

; -----------------------------------------------------------------------------------------

off_19CDA:
	dc.l	word_19E40
	dc.l	word_19E7C
	dc.l	word_19E88
	dc.l	word_19EDC
	dc.l	word_19EF0
	dc.l	word_19D56
	dc.l	word_19E66
	dc.l	byte_19DE8
	dc.l	word_19DFE
	dc.l	word_19E10
	dc.l	word_19DBE
	dc.l	word_19DA2
	dc.l	word_19D7E
	dc.l	word_19D90
	dc.l	0
	dc.l	word_19E36
	dc.l	word_19D3A
	dc.l	word_19F04
	dc.l	word_19F1E
	dc.l	word_19F1E
	dc.l	word_19F1E
	dc.l	word_19F1E
	dc.l	word_19D6A
	dc.l	word_19F1E
word_19D3A:
	dc.w	1-1
	STAGE_TEXT_LOC 0, $C514, $E500, "PRESS 2P START BUTTON"
word_19D56:
	dc.w	1-1
	STAGE_TEXT_LOC 0, $0702, $A500, " NO BONUS "
word_19D6A:
	dc.w	1-1
	STAGE_TEXT_LOC 0, $0882, $8500, "ALL CLEAR "
word_19D7E:
	dc.w	1-1
	STAGE_TEXT_LOC 0, $0204, $C500, "YOU  WIN"
word_19D90:
	dc.w	1-1
	STAGE_TEXT_LOC 0, $C11E, $C500, "GAMES  WON"
word_19DA2:
	dc.w	1-1
	STAGE_TEXT_LOC 0, $C514, $E500, "PRESS 1P START BUTTON"
word_19DBE:
	dc.w	2-1
	STAGE_TEXT_LOC 0, $0500, $8500, "            "
	STAGE_TEXT_LOC 0, $0600, $8500, "            "
byte_19DE8:
	dc.w	1-1
	STAGE_TEXT_LOC 1, $0500, $8500, "INSERT COINS"
word_19DFE:
	dc.w	1-1
	STAGE_TEXT_LOC 1, $0504, $8500, "CONTINUE?"
word_19E10:
	dc.w	2-1
	STAGE_TEXT_LOC 1, $0784, $8500, "PRESS %cP"
	STAGE_TEXT_LOC 1, $0880, $8500, "START BUTTON"
word_19E36:
	dc.w	1-1
	STAGE_TEXT_LOC 0, $C626, $C500, "LV"
word_19E40:
	dc.w	4-1
	STAGE_TEXT_LOC 0, $C124, $C500, "NEXT"
	STAGE_TEXT_LOC 1, $C220, $8500, "1P"
	STAGE_TEXT_LOC 1, $C22C, $A500, "2P"
	STAGE_TEXT_LOC 0, $CA20, $C500, "SCORE"
word_19E66:
	dc.w	2-1
	STAGE_TEXT_LOC 0, $C124, $C500, "NEXT"
	STAGE_TEXT_LOC 0, $CA20, $C500, "SCORE"
word_19E7C:
	dc.w	1-1
	STAGE_TEXT_LOC 0, $CA40, $C500, "SCORE"
word_19E88:
	dc.w	3-1
	STAGE_TEXT_LOC 0, $E91E, $C500, "SELECT MODE"
	STAGE_TEXT_LOC 0, $EC1E, $A500, "VS COMPUTER"
	STAGE_TEXT_LOC 0, $EE1E, $A500, "1P VS 2P"
	STAGE_TEXT_LOC 0, $F01E, $A500, "1P"
	; Unused
	STAGE_TEXT_LOC 0, $F222, $A500, "MISSION"
	STAGE_TEXT_LOC 0, $F41E, $A500, "SOUND TRACK"
word_19EDC:
	dc.w	1-1
	STAGE_TEXT_LOC 0, $C184, $8500, "SELECT LEVEL"
word_19EF0:
	dc.w	1-1
	STAGE_TEXT_LOC 0, $C1B4, $A500, "SELECT LEVEL"
word_19F04:
	dc.w	2-1
	STAGE_TEXT_LOC 0, $C86E, $A500, "START"
	STAGE_TEXT_LOC 0, $CC6E, $C500, "CONTINUE"
word_19F1E:
	dc.w	2-1
	STAGE_TEXT_LOC 1, $0504, $8500, "PRESS %cP"
	STAGE_TEXT_LOC 1, $0600, $8500, "START BUTTON"

; =============== S U B	R O U T	I N E =====================================================


ProcPlaneCommands:
	move.w	(plane_cmd_count).l,d0
	beq.w	locret_19F8E
	move.w	(plane_cmd_count).l,(word_FF0DE0).l
	clr.w	(plane_cmd_count).l
	clr.w	d2
	move.b	(vdp_reg_10).l,d2
	andi.b	#3,d2
	lsl.b	#1,d2
	move.w	word_19F90(pc,d2.w),d1
	subq.w	#1,d0
	lea	(plane_cmd_queue).l,a2

loc_19F78:
	movem.l	d0-d1/a2,-(sp)
	bsr.w	ProcPlaneCommand
	movem.l	(sp)+,d0-d1/a2
	adda.l	#4,a2
	dbf	d0,loc_19F78

locret_19F8E:
	rts
; End of function ProcPlaneCommands

; -----------------------------------------------------------------------------------------
word_19F90
	dc.w	$40
	dc.w	$80
	dc.w	$100
	dc.w	$100

; -----------------------------------------------------------------------------------------
; Prcoess a plane command
; -----------------------------------------------------------------------------------------
; PARAMETERS:
;	a2.l	- Pointer to plane command
; -----------------------------------------------------------------------------------------

ProcPlaneCommand:
	move.b	(a2),d2
	bpl.w	QueueLoadMap

	andi.w	#$7F,d2
	lsl.w	#2,d2
	movea.l	off_19FAA(pc,d2.w),a4
	jmp	(a4)

; -----------------------------------------------------------------------------------------

off_19FAA:
	dc.l	SpecPlane80
	dc.l	SpecPlane81
	dc.l	SpecPlane82
	dc.l	SpecPlane83
	dc.l	SpecPlane84
	dc.l	SpecPlane85
	dc.l	SpecPlane86
	dc.l	SpecPlane87
	dc.l	SpecPlane88
	dc.l	SpecPlane89
	dc.l	PlaneCmd_AnimateGarbage
	dc.l	SpecPlane8B
	dc.l	SpecPlane8C
	dc.l	SpecPlane8D
	dc.l	SpecPlane8E
	dc.l	SpecPlane8F
	dc.l	SpecPlane90
	dc.l	SpecPlane91
	dc.l	SpecPlane92
	dc.l	SpecPlane93
	dc.l	SpecPlane94
	dc.l	SpecPlane95
	dc.l	SpecPlane96
	dc.l	SpecPlane97
	dc.l	SpecPlane98
	dc.l	SpecPlane99
	dc.l	SpecPlane9A
	dc.l	SpecPlane9B
	dc.l	SpecPlane9C
	dc.l	SpecPlane9D
	dc.l	SpecPlane9E
	dc.l	SpecPlane9F
; -----------------------------------------------------------------------------------------

SpecPlane9D:
	move.w	#$44,d2
	lea	(off_19CDA).l,a3
	movea.l	(a3,d2.w),a4
	move.w	(a4)+,d0
	move.w	2(a2),d4
	clr.l	d3

loc_1A040:
	andi.b	#1,d3
	adda.l	d3,a4
	clr.b	d3
	move.w	(a4)+,d5
	move.w	(a4)+,d2
	eor.w	d4,d2

loc_1A04E:
	move.b	(a4)+,d2
	addq.b	#1,d3
	cmpi.b	#$FF,d2
	beq.w	loc_1A078
	bsr.w	SetVRAMWrite
	add.w	d1,d5
	move.w	d2,VDP_DATA
	addq.b	#1,d2
	bsr.w	SetVRAMWrite
	sub.w	d1,d5
	addq.w	#2,d5
	move.w	d2,VDP_DATA
	bra.s	loc_1A04E
; -----------------------------------------------------------------------------------------

loc_1A078:
	dbf	d0,loc_1A040
	rts
; -----------------------------------------------------------------------------------------

SpecPlane9C:
	move.w	2(a2),d5
	lea	(word_1A0A0).l,a4
	clr.w	d0
	move.b	1(a2),d0
	mulu.w	#$C,d0
	adda.w	d0,a4
	move.w	#2,d3
	move.w	#1,d4
	bra.w	CopyTilemap
; -----------------------------------------------------------------------------------------
word_1A0A0:
	dc.w	$424B
	dc.w	$424C
	dc.w	$424D
	dc.w	$4257
	dc.w	$4258
	dc.w	$4259
	dc.w	$424F
	dc.w	$4250
	dc.w	$4251
	dc.w	$425B
	dc.w	$425C
	dc.w	$425D
	dc.w	$4252
	dc.w	$4253
	dc.w	$4254
	dc.w	$425E
	dc.w	$425F
	dc.w	$4260
	dc.w	$4A51
	dc.w	$4A50
	dc.w	$4A4F
	dc.w	$4A5D
	dc.w	$4A5C
	dc.w	$4A5B
	dc.w	$4A4D
	dc.w	$4A4C
	dc.w	$4A4B
	dc.w	$4A59
	dc.w	$4A58
	dc.w	$4A57
; -----------------------------------------------------------------------------------------

SpecPlane9B:
	move.w	#$C204,d2
	tst.b	swap_fields
	beq.w	loc_1A0EE
	move.w	#$C234,d2

loc_1A0EE:
	clr.w	d5
	move.b	1(a2),d5
	subq.b	#1,d5
	lsl.w	#7,d5
	add.w	d2,d5
	lea	(word_1A12E).l,a4
	move.w	#$B,d3
	move.w	#1,d4
	bsr.w	CopyTilemap
	clr.w	d5
	move.b	1(a2),d5
	neg.b	d5
	addi.b	#$12,d5
	lsl.w	#7,d5
	add.w	d2,d5
	lea	(word_1A146).l,a4
	move.w	#$B,d3
	move.w	#1,d4
	bra.w	CopyTilemap
; -----------------------------------------------------------------------------------------
word_1A12E
	dc.w	$C1E8
	dc.w	$C1E9
	dc.w	$C1E9
	dc.w	$C1E9
	dc.w	$C1E9
	dc.w	$C1E9
	dc.w	$C1E9
	dc.w	$C1E9
	dc.w	$C1E9
	dc.w	$C1E9
	dc.w	$C1E9
	dc.w	$C1EA
word_1A146
	dc.w	$C1EB
	dc.w	$C1AB
	dc.w	$C1AB
	dc.w	$C1AB
	dc.w	$C1AB
	dc.w	$C1AB
	dc.w	$C1AB
	dc.w	$C1AB
	dc.w	$C1AB
	dc.w	$C1AB
	dc.w	$C1AB
	dc.w	$C1EC
	dc.w	$C1ED
	dc.w	$C1EE
	dc.w	$C1EE
	dc.w	$C1EE
	dc.w	$C1EE
	dc.w	$C1EE
	dc.w	$C1EE
	dc.w	$C1EE
	dc.w	$C1EE
	dc.w	$C1EE
	dc.w	$C1EE
	dc.w	$C1EF
; -----------------------------------------------------------------------------------------

SpecPlane9A:
	lea	(Str_1P).l,a1
	move.w	#3,d0
	move.w	#$A500,d6
	move.w	#$C21E,d5
	tst.b	swap_fields
	beq.w	loc_1A196
	move.w	#$C22A,d5

loc_1A196:
	bsr.w	DrawSmallText
	clr.w	d0
	move.b	stage,d0
	lea	(Str_DrR).l,a1
	move.w	#3,d0
	move.w	#$A500,d6
	move.w	#$C21E,d5
	tst.b	swap_fields
	bne.w	loc_1A1C2
	move.w	#$C22A,d5

loc_1A1C2:
	bsr.w	DrawSmallText
	rts
; -----------------------------------------------------------------------------------------
Str_1P:
	STAGE_TEXT 1, " 1P "
Str_DrR:
	STAGE_TEXT 1, "DR R"
; -----------------------------------------------------------------------------------------

SpecPlane98:
	move.w	#$C506,d5
	move.w	#$A500,d6
	lea	(byte_1A20C).l,a1
	move.w	#9,d0
	bsr.w	DrawPlayerText
	move.w	#$C606,d5
	move.w	#$A500,d6
	lea	(byte_1A216).l,a1
	move.w	#9,d0
	bsr.w	DrawPlayerText
	move.w	2(a2),d2
	move.w	#$C608,d5
	move.w	#$8500,d6
	bra.w	loc_1A3BA
; -----------------------------------------------------------------------------------------
byte_1A20C:
	STAGE_TEXT 1, "PLAY TIME "
byte_1A216:
	STAGE_TEXT 1, "       SEC"
; -----------------------------------------------------------------------------------------

SpecPlane99:
	move.w	#$C706,d5
	move.w	#$A500,d6
	lea	(unk_1A25C).l,a1
	move.w	#9,d0
	bsr.w	DrawPlayerText
	move.w	#$C806,d5
	move.w	#$A500,d6
	lea	(unk_1A266).l,a1
	move.w	#9,d0
	bsr.w	DrawPlayerText
	move.w	2(a2),d2
	move.w	#$C808,d5
	move.w	#$8500,d6
	bra.w	loc_1A3BA
; -----------------------------------------------------------------------------------------
unk_1A25C:
	STAGE_TEXT 1, "BONUS     "
unk_1A266
	STAGE_TEXT 1, "       PTS"
; -----------------------------------------------------------------------------------------

SpecPlane9E:
	move.w	#$C906,d5
	move.w	#$A500,d6
	lea	(unk_1A38E).l,a1
	move.w	#9,d0
	bsr.w	DrawPlayerText
	lea	(Passwords).l,a1
	moveq	#0,d1
	move.b	stage,d1
	subq.w	#3,d1
	bpl.s	loc_1A29A
	moveq	#0,d1

loc_1A29A:
	asl.w	#3,d1
	adda.w	d1,a1
	move.b	(difficulty).l,d1
	neg.w	d1
	subq.w	#1,d1
	andi.w	#3,d1
	add.w	d1,d1
	move.w	(a1,d1.w),d1
	move.w	d1,(current_password).l
	lea	(off_1A348).l,a3
	lea	(unk_1A330).l,a2
	moveq	#3,d0

loc_1A2C6:
	lea	(loc_1A318).l,a1
	jsr	FindActorSlot
	bcs.s	loc_1A312
	rol.w	#4,d1
	move.b	d1,d2
	andi.w	#$F,d2
	move.b	byte_1A320(pc,d2.w),8(a1)
	move.b	byte_1A328(pc,d2.w),9(a1)
	asl.w	#2,d2
	move.l	off_1A348(pc,d2.w),$32(a1)
	move.b	#$80,6(a1)
	move.b	(a2)+,d2
	move.b	(a2)+,$22(a1)
	move.w	(a2)+,d2
	move.w	(a2)+,$E(a1)
	tst.b	swap_fields
	beq.s	loc_1A30E
	addi.w	#$C0,d2

loc_1A30E:
	move.w	d2,$A(a1)

loc_1A312:
	dbf	d0,loc_1A2C6
	rts
; -----------------------------------------------------------------------------------------

loc_1A318:
	jmp	(ActorAnimate).l
; -----------------------------------------------------------------------------------------
	rts
; -----------------------------------------------------------------------------------------
byte_1A320
	dc.b	0
	dc.b	1
	dc.b	5
	dc.b	4
	dc.b	3
	dc.b	6
	dc.b	$19
	dc.b	$FF
byte_1A328
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	$A
	dc.b	$FF
unk_1A330
	dc.b	0
	dc.b	$5D
	dc.b	0
	dc.b	$A8
	dc.b	1
	dc.b	$28
	dc.b	0
	dc.b	$3E
	dc.b	0
	dc.b	$B8
	dc.b	1
	dc.b	$28
	dc.b	0
	dc.b	$48
	dc.b	0
	dc.b	$C8
	dc.b	1
	dc.b	$28
	dc.b	0
	dc.b	$23
	dc.b	0
	dc.b	$D8
	dc.b	1
	dc.b	$28
off_1A348
	dc.l	unk_1A364
	dc.l	unk_1A364
	dc.l	unk_1A364
	dc.l	unk_1A364
	dc.l	unk_1A364
	dc.l	unk_1A37A
	dc.l	unk_1A384
unk_1A364
	dc.b	3
	dc.b	2
	dc.b	1
	dc.b	0
	dc.b	2
	dc.b	3
	dc.b	1
	dc.b	0
	dc.b	3
	dc.b	2
	dc.b	1
	dc.b	0
	dc.b	2
	dc.b	3
	dc.b	$3C
	dc.b	0
	dc.b	$FF
	dc.b	0
	dc.l	unk_1A364
unk_1A37A
	dc.b	$3C
	dc.b	0
	dc.b	$3C
	dc.b	0
	dc.b	$FF
	dc.b	0
	dc.l	unk_1A37A
unk_1A384
	dc.b	$23
	dc.b	$A
	dc.b	$23
	dc.b	$B
	dc.b	$FF
	dc.b	0
	dc.l	unk_1A384
unk_1A38E:
	STAGE_TEXT 1, " PASSWORD "
unk_1A398:
	STAGE_TEXT 1, " ALL CLEAR"
; -----------------------------------------------------------------------------------------
	move.w	#$C906,d5
	move.w	#$A500,d6
	lea	(unk_1A398).l,a1
	move.w	#9,d0
	bsr.w	DrawPlayerText
	rts
; -----------------------------------------------------------------------------------------

loc_1A3BA:
	tst.b	swap_fields
	beq.w	loc_1A3C8
	addi.w	#$30,d5

loc_1A3C8:
	clr.l	(stage_text_buffer).l
	move.b	#2,(stage_text_buffer+4).l
	lea	((stage_text_buffer+5)).l,a1

loc_1A3DC:
	andi.l	#$FFFF,d2
	beq.w	loc_1A3F6
	divu.w	#$A,d2
	swap	d2
	addq.b	#1,d2
	lsl.b	#1,d2
	move.b	d2,-(a1)
	swap	d2
	bra.s	loc_1A3DC
; -----------------------------------------------------------------------------------------

loc_1A3F6:
	lea	(stage_text_buffer).l,a1
	move.w	#4,d0
	bra.w	DrawSmallText
; -----------------------------------------------------------------------------------------

SpecPlane97:
	bsr.w	GetStageText
	bsr.w	DrawStageText
	bsr.w	DrawBGUnderStageText
	rts
; -----------------------------------------------------------------------------------------

GetStageText:
	cmpi.b	#$C,stage
	bcc.w	.DoubleDigit
	lea	(Str_Stage).l,a1
	bsr.w	BufferStageText
	move.b	stage,d0
	subq.b	#3,d0
	lea	((stage_text_buffer+6)).l,a1
	bra.w	BufferStageNumber
; -----------------------------------------------------------------------------------------

.DoubleDigit:
	lea	(Str_Stage1).l,a1
	bsr.w	BufferStageText
	move.b	stage,d0
	subi.b	#$D,d0
	lea	((stage_text_buffer+7)).l,a1
	bra.w	BufferStageNumber
; -----------------------------------------------------------------------------------------

BufferStageText:
	move.w	#7,d0
	lea	(stage_text_buffer).l,a2

.Loop:
	move.b	(a1)+,(a2)+
	dbf	d0,.Loop
	rts
; -----------------------------------------------------------------------------------------

BufferStageNumber:
	addi.b	#$37,d0
	lsl.b	#1,d0
	move.b	d0,(a1)
	rts
; -----------------------------------------------------------------------------------------
Str_Stage:
	STAGE_TEXT 1, "STAGE   "
Str_Stage1
	STAGE_TEXT 1, "STAGE 1 "
; -----------------------------------------------------------------------------------------

DrawStageText:
	move.w	#$C520,d5
	move.w	#$C500,d6
	move.w	#7,d0
	lea	(stage_text_buffer).l,a1
	bra.w	DrawSmallText
; -----------------------------------------------------------------------------------------

DrawBGUnderStageText:
	move.w	#$E520,d5
	move.w	#7,d3
	move.w	#1,d4
	move.w	#$C000,d6
	lea	(StageTextBGTiles).l,a4
	bra.w	CopyTilemap8
; -----------------------------------------------------------------------------------------
StageTextBGTiles:
	dc.b	$11
	dc.b	$12
	dc.b	$13
	dc.b	$14
	dc.b	$15
	dc.b	$16
	dc.b	$17
	dc.b	$18
	dc.b	$22
	dc.b	$23
	dc.b	$24
	dc.b	$25
	dc.b	$26
	dc.b	$27
	dc.b	$28
	dc.b	$29
; -----------------------------------------------------------------------------------------

DrawPlayerText:
	tst.b	swap_fields
	beq.w	DrawSmallText
	addi.w	#$30,d5

DrawSmallText:
	move.b	(a1)+,d6
	jsr	SetVRAMWrite
	add.w	d1,d5
	move.w	d6,VDP_DATA
	addq.b	#1,d6
	jsr	SetVRAMWrite
	sub.w	d1,d5
	addq.w	#2,d5
	move.w	d6,VDP_DATA
	dbf	d0,DrawSmallText
	rts
; -----------------------------------------------------------------------------------------

SpecPlane96:
	move.w	#$27,d3
	move.w	#0,d4
	move.w	2(a2),d5
	andi.w	#$FF00,d5
	addi.w	#$E000,d5
	clr.w	d0
	move.b	3(a2),d0
	mulu.w	#$50,d0
	lea	(byte_1FDEC).l,a4
	adda.w	d0,a4
	bra.w	CopyTilemap
; -----------------------------------------------------------------------------------------

SpecPlane93:
	move.w	#$C71E,d5
	move.w	#$8500,d6
	tst.b	1(a2)
	beq.w	loc_1A53C
	move.w	#$C72A,d5
	move.w	#$A500,d6

loc_1A53C:
	move.w	2(a2),d2
	lea	((byte_FF1982+4)).l,a3
	clr.l	(a3)+
	bsr.w	sub_1B396
	lea	((byte_FF1982+4)).l,a3
	move.w	#3,d0

loc_1A556:
	bsr.w	SetVRAMWrite
	add.w	d1,d5
	move.b	(a3)+,d6
	addq.b	#1,d6
	lsl.b	#1,d6
	move.w	d6,VDP_DATA
	addq.b	#1,d6
	bsr.w	SetVRAMWrite
	sub.w	d1,d5
	move.w	d6,VDP_DATA
	addq.w	#2,d5
	dbf	d0,loc_1A556
	rts
; -----------------------------------------------------------------------------------------

SpecPlane8B:
	move.w	#$10,d3
	move.w	#9,d4
	move.w	#$C716,d5
	bsr.w	SetVRAMWrite
	add.w	d1,d5
	move.w	#$C4D8,VDP_DATA
	move.w	d3,d0
	subq.w	#1,d0

loc_1A59C:
	move.w	#$C4D9,VDP_DATA
	dbf	d0,loc_1A59C
	move.w	#$C4DA,VDP_DATA
	move.w	d4,d0
	subq.w	#1,d0

loc_1A5B4:
	bsr.w	SetVRAMWrite
	move.w	#$C4DB,VDP_DATA
	move.w	d3,d2
	subq.w	#1,d2

loc_1A5C4:
	move.w	#$8500,VDP_DATA
	dbf	d2,loc_1A5C4
	move.w	#$C4DC,VDP_DATA
	add.w	d1,d5
	dbf	d0,loc_1A5B4
	bsr.w	SetVRAMWrite
	move.w	#$C4DD,VDP_DATA
	move.w	d3,d0
	subq.w	#1,d0

loc_1A5EE:
	move.w	#$C4DE,VDP_DATA
	dbf	d0,loc_1A5EE
	move.w	#$C4DF,VDP_DATA
	rts
; -----------------------------------------------------------------------------------------

SpecPlane92:
	moveq	#0,d0
	move.b	1(a2),d0
	moveq	#$46,d3
	mulu.w	d3,d0
	lea	(byte_66C9A).l,a3
	adda.w	d0,a3
	move.w	#$E70C,d5
	moveq	#6,d4

loc_1A61C:
	jsr	SetVRAMWrite
	addi.w	#$80,d5
	moveq	#4,d3

loc_1A628:
	move.w	(a3)+,d0
	addi.w	#$E200,d0
	move.w	d0,VDP_DATA
	dbf	d3,loc_1A628
	dbf	d4,loc_1A61C
	rts
; -----------------------------------------------------------------------------------------

SpecPlane8F:
	move.w	#6,d3
	move.w	#2,d4
	move.w	#$DEB8,d5
	move.w	#$E100,d6
	lea	(unk_1A66A).l,a4
	tst.b	1(a2)
	beq.w	CopyTilemap8
	move.w	#$E900,d6
	lea	(unk_1A680).l,a4
	bra.w	CopyTilemap8
; -----------------------------------------------------------------------------------------
unk_1A66A
	dc.b	$FC
	dc.b	$FC
	dc.b	$CA
	dc.b	$C8
	dc.b	$F1
	dc.b	$C0
	dc.b	$FC
	dc.b	$D5
	dc.b	$D6
	dc.b	$CD
	dc.b	$CE
	dc.b	$CF
	dc.b	$D0
	dc.b	$D1
	dc.b	$DF
	dc.b	$E5
	dc.b	$DD
	dc.b	$DE
	dc.b	$DF
	dc.b	$E0
	dc.b	$E1
	dc.b	0
unk_1A680
	dc.b	$FC
	dc.b	$C0
	dc.b	$F1
	dc.b	$C8
	dc.b	$CA
	dc.b	$FC
	dc.b	$FC
	dc.b	$D1
	dc.b	$D0
	dc.b	$CF
	dc.b	$CE
	dc.b	$CD
	dc.b	$D6
	dc.b	$D5
	dc.b	$E1
	dc.b	$E0
	dc.b	$DF
	dc.b	$DE
	dc.b	$DD
	dc.b	$E5
	dc.b	$DF
	dc.b	0
; -----------------------------------------------------------------------------------------

SpecPlane8E:
	bsr.w	loc_1A7C4
	subq.w	#2,d3
	subq.w	#2,d4
	addi.w	#$82,d5
	move.w	#$83FB,d6
	bra.w	FillPlane
; -----------------------------------------------------------------------------------------

SpecPlane8C:
	bsr.w	loc_1A7C4
	movem.l	d3-d5,-(sp)
	lea	(plane_a_buffer).l,a1

loc_1A6B8:
	bsr.w	SetVRAMRead
	add.w	d1,d5
	move.w	d3,d0

loc_1A6C0:
	move.w	VDP_DATA,d2
	move.w	d2,(a1)+
	dbf	d0,loc_1A6C0
	dbf	d4,loc_1A6B8
	movem.l	(sp)+,d3-d5
	subq.w	#2,d3
	subq.w	#2,d4
	addq.w	#2,d5
	bsr.w	SetVRAMWrite
	subq.w	#2,d5
	add.w	d1,d5
	move.w	d3,d0

loc_1A6E4:
	move.w	#$E3F8,VDP_DATA
	dbf	d0,loc_1A6E4

loc_1A6F0:
	bsr.w	SetVRAMWrite
	add.w	d1,d5
	move.w	#$E3FA,VDP_DATA
	move.w	d3,d0

loc_1A700:
	move.w	#$E3FB,VDP_DATA
	dbf	d0,loc_1A700
	move.w	#$E3FC,VDP_DATA
	dbf	d4,loc_1A6F0
	addq.w	#2,d5
	bsr.w	SetVRAMWrite
	subq.w	#2,d5
	move.w	d3,d0

loc_1A722:
	move.w	#$E3FE,VDP_DATA
	dbf	d0,loc_1A722
	rts
; -----------------------------------------------------------------------------------------

SpecPlane9F:
	bsr.w	loc_1A7C4
	movem.l	d3-d5,-(sp)
	lea	(plane_a_buffer).l,a1

loc_1A73E:
	bsr.w	SetVRAMRead
	add.w	d1,d5
	move.w	d3,d0

loc_1A746:
	move.w	VDP_DATA,d2
	move.w	d2,(a1)+
	dbf	d0,loc_1A746
	dbf	d4,loc_1A73E
	movem.l	(sp)+,d3-d5
	subq.w	#2,d3
	subq.w	#2,d4
	addq.w	#2,d5
	bsr.w	SetVRAMWrite
	subq.w	#2,d5
	add.w	d1,d5
	move.w	d3,d0

loc_1A76A:
	move.w	#$E1F8,VDP_DATA
	dbf	d0,loc_1A76A

loc_1A776:
	bsr.w	SetVRAMWrite
	add.w	d1,d5
	move.w	#$E1FA,VDP_DATA
	move.w	d3,d0

loc_1A786:
	move.w	#$E1FB,VDP_DATA
	dbf	d0,loc_1A786
	move.w	#$E1FC,VDP_DATA
	dbf	d4,loc_1A776
	addq.w	#2,d5
	bsr.w	SetVRAMWrite
	subq.w	#2,d5
	move.w	d3,d0

loc_1A7A8:
	move.w	#$E1FE,VDP_DATA
	dbf	d0,loc_1A7A8
	rts
; -----------------------------------------------------------------------------------------

SpecPlane8D:
	bsr.w	loc_1A7C4
	lea	(plane_a_buffer).l,a4
	bra.w	CopyTilemap
; -----------------------------------------------------------------------------------------

loc_1A7C4:
	clr.w	d3
	move.b	1(a2),d3
	move.w	d3,d4
	andi.b	#$1F,d3
	lsr.b	#5,d4
	addq.w	#1,d3
	add.w	d4,d4
	move.w	2(a2),d5
	rts

; -----------------------------------------------------------------------------------------
; Animate the garbage puyos
; -----------------------------------------------------------------------------------------
; PARAMETERS:
;	00.b	- Garbage puyo animation frame ID
; -----------------------------------------------------------------------------------------

PlaneCmd_AnimateGarbage:
	clr.w	d5
	move.b	1(a2),d5
	lsl.w	#7,d5
	addi.w	#$5F00,d5
	bsr.w	SetVRAMRead

	lea	VDP_DATA,a3
	lea	buffer,a4
	move.w	#$80/2-1,d0

loc_1A7FC:
	move.w	(a3),(a4)+
	dbf	d0,loc_1A7FC

	move.w	#$6580,d5
	bsr.w	SetVRAMWrite

	lea	buffer,a4
	move.w	#$80/2-1,d0

loc_1A814:
	move.w	(a4)+,(a3)
	dbf	d0,loc_1A814

	rts
; -----------------------------------------------------------------------------------------

SpecPlane89:
	lea	(RAM_START).l,a0
	clr.l	d0
	move.w	2(a2),d0
	adda.l	d0,a0
	bclr	#4,7(a0)
	jsr	(GetPuyoField).l
	movea.l	a2,a3
	movea.l	a2,a4
	addi.w	#$A14,d0
	adda.l	#$C,a2
	adda.l	#$1E0,a3
	adda.l	#$144,a4
	move.w	#$8E,d2
	move.w	#5,d3
	move.w	#$16,d4

loc_1A85C:
	move.b	(a3,d2.w),d5
	beq.w	loc_1A86E
	bsr.w	loc_1A884
	bset	#4,7(a0)

loc_1A86E:
	subq.w	#4,d0
	dbf	d3,loc_1A87E
	move.w	#5,d3
	subi.w	#$E8,d0
	subq.w	#2,d4

loc_1A87E:
	subq.w	#2,d2
	bcc.s	loc_1A85C
	rts
; -----------------------------------------------------------------------------------------

loc_1A884:
	clr.w	d7
	lsl.b	#1,d5
	move.b	1(a3,d2.w),d6
	cmp.b	d5,d6
	bcs.w	loc_1A89C
	move.b	d6,d7
	sub.b	d5,d7
	addq.w	#1,d7
	move.b	d5,d6
	subq.b	#1,d6

loc_1A89C:
	clr.w	d1
	move.b	(a4,d2.w),d1
	lsr.b	#3,d1
	andi.b	#$C,d1
	movea.l	off_1A918(pc,d1.w),a5
	move.b	(a5,d7.w),d5
	bpl.w	loc_1A8BA
	clr.b	(a3,d2.w)
	rts
; -----------------------------------------------------------------------------------------

loc_1A8BA:
	clr.w	d1
	move.b	d6,d1
	lsl.w	#7,d1
	add.w	d0,d1
	add.b	d4,d6
	cmpi.b	#3,d6
	bcs.w	loc_1A8D0
	move.b	#2,d6

loc_1A8D0:
	tst.w	d7
	beq.w	loc_1A8DA
	move.b	#1,d6

loc_1A8DA:
	andi.w	#$FF,d6
	lsl.w	#2,d6
	movea.l	off_1A90C(pc,d6.w),a5
	swap	d0
	move.b	(a4,d2.w),d0
	move.b	d0,d7
	andi.b	#$70,d7
	cmpi.b	#$60,d7
	beq.w	loc_1A8FC
	or.b	d5,d7
	move.b	d7,d0

loc_1A8FC:
	jsr	(GetPuyoTileID).l
	jsr	(a5)
	swap	d0
	addq.b	#1,1(a3,d2.w)
	rts
; -----------------------------------------------------------------------------------------
off_1A90C
	dc.l	loc_1A9A2
	dc.l	loc_1A988
	dc.l	loc_1A972
off_1A918
	dc.l	unk_1A928
	dc.l	unk_1A940
	dc.l	unk_1A958
	dc.l	unk_1A970
unk_1A928
	dc.b	1
	dc.b	1
	dc.b	2
	dc.b	2
	dc.b	2
	dc.b	1
	dc.b	3
	dc.b	3
	dc.b	1
	dc.b	2
	dc.b	2
	dc.b	2
	dc.b	1
	dc.b	3
	dc.b	3
	dc.b	1
	dc.b	2
	dc.b	2
	dc.b	1
	dc.b	3
	dc.b	1
	dc.b	2
	dc.b	$FF
	dc.b	0
unk_1A940
	dc.b	1
	dc.b	2
	dc.b	2
	dc.b	2
	dc.b	2
	dc.b	1
	dc.b	3
	dc.b	1
	dc.b	2
	dc.b	1
	dc.b	3
	dc.b	1
	dc.b	2
	dc.b	1
	dc.b	3
	dc.b	1
	dc.b	2
	dc.b	1
	dc.b	3
	dc.b	1
	dc.b	2
	dc.b	1
	dc.b	3
	dc.b	$FF
unk_1A958
	dc.b	1
	dc.b	1
	dc.b	2
	dc.b	2
	dc.b	2
	dc.b	2
	dc.b	3
	dc.b	3
	dc.b	2
	dc.b	2
	dc.b	2
	dc.b	2
	dc.b	3
	dc.b	3
	dc.b	2
	dc.b	1
	dc.b	3
	dc.b	3
	dc.b	1
	dc.b	3
	dc.b	3
	dc.b	1
	dc.b	$FF
	dc.b	0
unk_1A970
	dc.b	1
	dc.b	$FF
; -----------------------------------------------------------------------------------------

loc_1A972:
	move.w	d1,d5
	bsr.w	SetVRAMWrite
	move.w	#$83FE,VDP_DATA
	move.w	#$83FE,VDP_DATA

loc_1A988:
	move.w	d1,d5
	addi.w	#$80,d5
	bsr.w	SetVRAMWrite
	move.w	d0,d5
	move.w	d5,VDP_DATA
	addq.w	#2,d5
	move.w	d5,VDP_DATA

loc_1A9A2:
	move.w	d1,d5
	addi.w	#$100,d5
	bsr.w	SetVRAMWrite
	move.w	d0,d5
	addq.w	#1,d5
	move.w	d5,VDP_DATA
	addq.w	#2,d5
	move.w	d5,VDP_DATA
	rts
; -----------------------------------------------------------------------------------------

SpecPlane88:
	clr.w	d2
	move.b	1(a2),d2
	lsl.b	#2,d2
	lea	(off_1AC82).l,a4
	movea.l	(a4,d2.w),a3
	bsr.w	loc_1AB12
	move.w	2(a2),d6
	andi.w	#$8000,d6
	clr.w	d2
	move.b	3(a2),d2
	mulu.w	#$30,d2
	lea	(unk_1AA22).l,a4
	adda.w	d2,a4
	move.w	#1,d2
	btst	#1,stage_mode
	beq.w	loc_1AA04
	move.w	#3,d2

loc_1AA04:
	bsr.w	SetVRAMWrite
	add.w	d1,d5
	move.w	#5,d0

loc_1AA0E:
	move.w	(a4)+,d3
	or.w	d6,d3
	move.w	d3,VDP_DATA
	dbf	d0,loc_1AA0E
	dbf	d2,loc_1AA04
	rts
; -----------------------------------------------------------------------------------------
unk_1AA22
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	4
	dc.b	$64
	dc.b	4
	dc.b	$66
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	4
	dc.b	$65
	dc.b	4
	dc.b	$67
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	4
	dc.b	$68
	dc.b	4
	dc.b	$6A
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	4
	dc.b	$69
	dc.b	4
	dc.b	$6B
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	4
	dc.b	$6C
	dc.b	4
	dc.b	$6E
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	4
	dc.b	$6D
	dc.b	4
	dc.b	$6F
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	4
	dc.b	$E0
	dc.b	5
	dc.b	$74
	dc.b	5
	dc.b	$6C
	dc.b	5
	dc.b	$6C
	dc.b	5
	dc.b	$6C
	dc.b	5
	dc.b	$6C
	dc.b	4
	dc.b	$E1
	dc.b	5
	dc.b	$75
	dc.b	5
	dc.b	$6D
	dc.b	5
	dc.b	$6D
	dc.b	5
	dc.b	$6D
	dc.b	5
	dc.b	$6D
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	4
	dc.b	$70
	dc.b	4
	dc.b	$72
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	4
	dc.b	$71
	dc.b	4
	dc.b	$73
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	4
	dc.b	$74
	dc.b	4
	dc.b	$76
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	4
	dc.b	$75
	dc.b	4
	dc.b	$77
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	4
	dc.b	$E0
	dc.b	5
	dc.b	$7E
	dc.b	5
	dc.b	$6C
	dc.b	5
	dc.b	$6C
	dc.b	5
	dc.b	$6C
	dc.b	5
	dc.b	$6C
	dc.b	4
	dc.b	$E1
	dc.b	5
	dc.b	$7F
	dc.b	5
	dc.b	$6D
	dc.b	5
	dc.b	$6D
	dc.b	5
	dc.b	$6D
	dc.b	5
	dc.b	$6D
; -----------------------------------------------------------------------------------------

loc_1AB12:
	btst	#1,stage_mode
	beq.w	loc_1AB34
	clr.w	d5
	move.b	3(a2),d5
	lsr.b	#1,d5
	lsl.w	#2,d5
	addq.b	#3,d5
	mulu.w	d1,d5
	addq.w	#2,d5
	add.w	0(a3),d5
	rts
; -----------------------------------------------------------------------------------------

loc_1AB34:
	clr.w	d5
	move.b	3(a2),d5
	mulu.w	#3,d5
	addq.b	#2,d5
	mulu.w	d1,d5
	addq.w	#2,d5
	add.w	0(a3),d5
	rts
; -----------------------------------------------------------------------------------------

SpecPlane83:
	clr.w	d2
	move.b	stage_mode,d2
	andi.b	#2,d2
	or.b	1(a2),d2
	lsl.b	#2,d2
	lea	(off_1AC82).l,a4
	movea.l	(a4,d2.w),a3
	tst.b	3(a2)
	bmi.w	loc_1AC44
	clr.w	d5
	move.b	3(a2),d5
	mulu.w	d1,d5
	add.w	0(a3),d5
	move.w	2(a3),d3
	move.w	4(a3),d4
	clr.w	d2
	move.b	3(a2),d2
	lsl.b	#1,d2
	sub.w	d2,d4
	move.w	6(a3),d6
	clr.w	d2
	move.b	3(a2),d2
	mulu.w	d3,d2
	lsl.w	#1,d2
	movea.l	8(a3),a4
	adda.w	d2,a4
	bsr.w	SetVRAMWrite
	add.w	d1,d5
	move.w	d3,d0
	addq.w	#1,d0

loc_1ABAA:
	move.w	d6,VDP_DATA
	dbf	d0,loc_1ABAA
	bsr.w	SetVRAMWrite
	add.w	d1,d5
	move.w	#$C4D8,VDP_DATA
	move.w	d3,d0
	subq.w	#1,d0

loc_1ABC6:
	move.w	#$C4D9,VDP_DATA
	dbf	d0,loc_1ABC6
	move.w	#$C4DA,VDP_DATA
	move.w	d4,d0
	subq.w	#1,d0
	bmi.w	loc_1AC0A

loc_1ABE2:
	bsr.w	SetVRAMWrite
	move.w	#$C4DB,VDP_DATA
	move.w	d3,d2
	subq.w	#1,d2

loc_1ABF2:
	move.w	(a4)+,VDP_DATA
	dbf	d2,loc_1ABF2
	move.w	#$C4DC,VDP_DATA
	add.w	d1,d5
	dbf	d0,loc_1ABE2

loc_1AC0A:
	bsr.w	SetVRAMWrite
	move.w	#$C4DD,VDP_DATA
	move.w	d3,d0
	subq.w	#1,d0

loc_1AC1A:
	move.w	#$C4DE,VDP_DATA
	dbf	d0,loc_1AC1A
	move.w	#$C4DF,VDP_DATA
	add.w	d1,d5
	bsr.w	SetVRAMWrite
	move.w	d3,d0
	addq.w	#1,d0

loc_1AC38:
	move.w	d6,VDP_DATA
	dbf	d0,loc_1AC38
	rts
; -----------------------------------------------------------------------------------------

loc_1AC44:
	move.w	4(a3),d5
	lsr.w	#1,d5
	addq.w	#1,d5
	mulu.w	d1,d5
	add.w	0(a3),d5
	move.w	6(a3),d6
	move.w	2(a3),d3
	bsr.w	SetVRAMWrite
	add.w	d1,d5
	move.w	d3,d0
	addq.w	#1,d0

loc_1AC64:
	move.w	d6,VDP_DATA
	dbf	d0,loc_1AC64
	bsr.w	SetVRAMWrite
	move.w	d3,d0
	addq.w	#1,d0

loc_1AC76:
	move.w	d6,VDP_DATA
	dbf	d0,loc_1AC76
	rts
; -----------------------------------------------------------------------------------------
off_1AC82
	dc.l	unk_1AC92
	dc.l	unk_1AC9E
	dc.l	unk_1ACAA
	dc.l	unk_1ACB6
unk_1AC92
	dc.b	$C2
	dc.b	$86
	dc.b	0
	dc.b	6
	dc.b	0
	dc.b	$E
	dc.b	$80
	dc.b	0
	dc.l	unk_1ACC2
unk_1AC9E
	dc.b	$C2
	dc.b	$BA
	dc.b	0
	dc.b	6
	dc.b	0
	dc.b	$E
	dc.b	$80
	dc.b	0
	dc.l	unk_1ACC2
unk_1ACAA
	dc.b	$C2
	dc.b	$86
	dc.b	0
	dc.b	6
	dc.b	0
	dc.b	$E
	dc.b	$80
	dc.b	0
	dc.l	unk_1AD6A
unk_1ACB6
	dc.b	$C2
	dc.b	$BA
	dc.b	0
	dc.b	6
	dc.b	0
	dc.b	$E
	dc.b	$80
	dc.b	0
	dc.l	unk_1AD6A
unk_1ACC2
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	4
	dc.b	$64
	dc.b	4
	dc.b	$66
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	4
	dc.b	$65
	dc.b	4
	dc.b	$67
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	4
	dc.b	$68
	dc.b	4
	dc.b	$6A
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	4
	dc.b	$69
	dc.b	4
	dc.b	$6B
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	4
	dc.b	$6C
	dc.b	4
	dc.b	$6E
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	4
	dc.b	$6D
	dc.b	4
	dc.b	$6F
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	4
	dc.b	$70
	dc.b	4
	dc.b	$72
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	4
	dc.b	$71
	dc.b	4
	dc.b	$73
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	4
	dc.b	$74
	dc.b	4
	dc.b	$76
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	4
	dc.b	$75
	dc.b	4
	dc.b	$77
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
unk_1AD6A
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	4
	dc.b	$64
	dc.b	4
	dc.b	$66
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	4
	dc.b	$65
	dc.b	4
	dc.b	$67
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	4
	dc.b	$6C
	dc.b	4
	dc.b	$6E
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	4
	dc.b	$6D
	dc.b	4
	dc.b	$6F
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	4
	dc.b	$E0
	dc.b	5
	dc.b	$74
	dc.b	5
	dc.b	$6C
	dc.b	5
	dc.b	$6C
	dc.b	5
	dc.b	$6C
	dc.b	5
	dc.b	$6C
	dc.b	4
	dc.b	$E1
	dc.b	5
	dc.b	$75
	dc.b	5
	dc.b	$6D
	dc.b	5
	dc.b	$6D
	dc.b	5
	dc.b	$6D
	dc.b	5
	dc.b	$6D
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	4
	dc.b	$74
	dc.b	4
	dc.b	$76
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	4
	dc.b	$75
	dc.b	4
	dc.b	$77
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	4
	dc.b	$E0
	dc.b	5
	dc.b	$7E
	dc.b	5
	dc.b	$6C
	dc.b	5
	dc.b	$6C
	dc.b	5
	dc.b	$6C
	dc.b	5
	dc.b	$6C
	dc.b	4
	dc.b	$E1
	dc.b	5
	dc.b	$7F
	dc.b	5
	dc.b	$6D
	dc.b	5
	dc.b	$6D
	dc.b	5
	dc.b	$6D
	dc.b	5
	dc.b	$6D
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
; -----------------------------------------------------------------------------------------

SpecPlane80:
	clr.w	d2
	move.b	1(a2),d2
	lsl.w	#2,d2
	lea	(off_19CDA).l,a3
	movea.l	(a3,d2.w),a4
	move.b	2(a2),d4
	beq.w	loc_1AE42
	bmi.w	loc_1AE42
	move.b	(frame_count+1).l,d4
	andi.b	#$10,d4
	beq.w	loc_1AE42
	move.b	#$FF,d4

loc_1AE42:
	not.b	d4
	move.w	(a4)+,d0
	clr.l	d3

loc_1AE48:
	andi.b	#1,d3
	adda.l	d3,a4
	clr.b	d3
	move.w	(a4)+,d5
	bne.w	loc_1AE5A
	bsr.w	loc_1AE90

loc_1AE5A:
	move.w	(a4)+,d2

loc_1AE5C:
	move.b	(a4)+,d2
	addq.b	#1,d3
	cmpi.b	#$FF,d2
	beq.w	loc_1AE8A
	bsr.w	loc_1AEB4
	bsr.w	SetVRAMWrite
	add.w	d1,d5
	move.w	d2,VDP_DATA
	addq.b	#1,d2
	bsr.w	SetVRAMWrite
	sub.w	d1,d5
	addq.w	#2,d5
	move.w	d2,VDP_DATA
	bra.s	loc_1AE5C
; -----------------------------------------------------------------------------------------

loc_1AE8A:
	dbf	d0,loc_1AE48
	rts
; -----------------------------------------------------------------------------------------

loc_1AE90:
	movem.l	d0-d1,-(sp)
	move.w	#$C104,d5
	move.b	3(a2),d0
	move.b	swap_fields,d1
	eor.b	d1,d0
	beq.w	loc_1AEAC
	move.w	#$C134,d5

loc_1AEAC:
	add.w	(a4)+,d5
	movem.l	(sp)+,d0-d1
	rts
; -----------------------------------------------------------------------------------------

loc_1AEB4:
	and.b	d4,d2
	cmpi.b	#$FE,d2
	beq.w	loc_1AEC0
	rts
; -----------------------------------------------------------------------------------------

loc_1AEC0:
	move.b	3(a2),d2
	addi.b	#$37,d2
	lsl.b	#1,d2
	rts
; -----------------------------------------------------------------------------------------

SpecPlane81:
	move.w	p1_score_vram,d5
	move.w	#$8500,d2
	bra.w	loc_1AEF0
; -----------------------------------------------------------------------------------------

SpecPlane82:
	move.w	#$CC22,d5
	tst.b	swap_fields
	beq.w	loc_1AEEC
	move.w	#$CB1E,d5

loc_1AEEC:
	move.w	#$A500,d2

loc_1AEF0:
	movem.l	d2,-(sp)
	lea	(RAM_START).l,a3
	clr.l	d3
	move.w	2(a2),d3
	move.l	$A(a3,d3.l),d2
	bsr.w	sub_1B350
	movem.l	(sp)+,d2

loc_1AF0C:
	lea	(byte_FF1982).l,a3
	clr.w	d3
	bsr.w	SetVRAMWrite

loc_1AF18:
	bsr.w	loc_1AF48
	move.w	d2,VDP_DATA
	addq.w	#1,d3
	cmpi.w	#8,d3
	bcs.s	loc_1AF18
	clr.w	d3
	add.w	d1,d5
	bsr.w	SetVRAMWrite

loc_1AF32:
	bsr.w	loc_1AF48
	addq.b	#1,d2
	move.w	d2,VDP_DATA
	addq.w	#1,d3
	cmpi.w	#8,d3
	bcs.s	loc_1AF32
	rts
; -----------------------------------------------------------------------------------------

loc_1AF48:
	move.b	(a3,d3.w),d2
	bmi.w	loc_1AF56
	addq.b	#1,d2
	lsl.b	#1,d2
	rts
; -----------------------------------------------------------------------------------------

loc_1AF56:
	clr.w	d4
	move.b	d2,d4
	andi.b	#$7F,d4
	move.b	byte_1AF64(pc,d4.w),d2
	rts
; -----------------------------------------------------------------------------------------
byte_1AF64
	dc.b	0
	dc.b	$4A
; -----------------------------------------------------------------------------------------

SpecPlane86:
	move.w	p1_score_vram,d5
	move.w	#$8500,d2
	bra.w	loc_1AF8A
; -----------------------------------------------------------------------------------------

SpecPlane87:
	move.w	#$A500,d2
	move.w	#$CC22,d5
	tst.b	swap_fields
	beq.w	loc_1AF8A
	move.w	#$CB1E,d5

loc_1AF8A:
	movem.l	d2,-(sp)
	lea	(byte_FF1982).l,a3
	move.w	#7,d2

loc_1AF98:
	move.b	#$80,(a3)+
	dbf	d2,loc_1AF98
	lea	p1_score_vram,a3
	lea	(RAM_START).l,a4
	clr.l	d3
	move.w	2(a2),d3
	move.w	$1E(a4,d3.l),d2
	beq.w	loc_1AFCA
	movem.l	d3,-(sp)
	bsr.w	sub_1B396
	movem.l	(sp)+,d3
	move.b	#$81,-(a3)

loc_1AFCA:
	clr.l	d2
	move.w	$12(a4,d3.l),d2
	divu.w	#10000,d2
	swap	d2
	bsr.w	sub_1B396
	movem.l	(sp)+,d2
	bra.w	loc_1AF0C
; -----------------------------------------------------------------------------------------

SpecPlane84:
	bsr.w	loc_1B0AE
	lsl.b	#1,d2
	or.b	1(a2),d2
	move.b	swap_fields,d0
	eor.b	d0,d2
	lsl.w	#2,d2
	lea	(off_1B0EA).l,a4
	movea.l	(a4,d2.w),a3
	clr.w	d2
	move.b	3(a2),d2
	move.w	4(a3),d0
	mulu.w	d0,d2
	movea.l	0(a3),a4
	adda.w	d2,a4
	move.w	8(a3),d6
	move.w	$A(a3),d3
	move.w	#1,d4
	move.w	$C(a3),d5
	bsr.w	loc_1B0A0
	tst.b	3(a2)
	beq.w	loc_1B03A
	cmpi.b	#5,3(a2)
	beq.w	loc_1B064
	rts
; -----------------------------------------------------------------------------------------

loc_1B03A:
	move.w	6(a3),d6
	move.w	#$B,d3
	move.w	#1,d4
	move.w	$10(a3),d5
	bsr.w	FillPlane
	move.w	6(a3),d6
	move.w	#$B,d3
	move.w	#$25,d4
	move.w	$E(a3),d5
	bsr.w	FillPlane
	rts
; -----------------------------------------------------------------------------------------

loc_1B064:
	move.w	4(a3),d3
	mulu.w	#6,d3
	movea.l	0(a3),a4
	adda.w	d3,a4
	move.w	6(a3),d6
	move.w	#$B,d3
	move.w	#1,d4
	move.w	$10(a3),d5
	bsr.w	loc_1B0A0
	move.w	6(a3),d6
	move.w	$A(a3),d3
	move.w	#1,d4
	move.w	$C(a3),d5
	movea.l	0(a3),a4
	bsr.w	loc_1B0A0
	rts
; -----------------------------------------------------------------------------------------

loc_1B0A0:
	cmpi.w	#$40,4(a3)
	bcs.w	CopyTilemap8
	bra.w	CopyTilemap
; -----------------------------------------------------------------------------------------

loc_1B0AE:
	clr.w	d2
	move.b	stage_mode,d2
	andi.b	#3,d2
	beq.w	loc_1B0CC
	cmpi.b	#1,d2
	beq.w	loc_1B0CC
	move.b	#3,d2
	rts
; -----------------------------------------------------------------------------------------

loc_1B0CC:
	clr.w	d0
	move.b	stage,d0
	move.b	byte_1B0DA(pc,d0.w),d2
	rts
; -----------------------------------------------------------------------------------------
byte_1B0DA
	dc.b	3
	dc.b	3
	dc.b	3
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
off_1B0EA
	dc.l	off_1B10A
	dc.l	off_1B11C
	dc.l	off_1B12E
	dc.l	off_1B140
	dc.l	off_1B10A
	dc.l	off_1B11C
	dc.l	off_1B10A
	dc.l	off_1B11C
off_1B10A
	dc.l	unk_1B3EA
	dc.b	0
	dc.b	$20
	dc.b	$C0
	dc.b	0
	dc.b	$40
	dc.b	0
	dc.b	0
	dc.b	$F
	dc.b	$ED
	dc.b	0
	dc.b	$CD
	dc.b	4
	dc.b	$C0
	dc.b	4
off_1B11C
	dc.l	unk_1B3EA
	dc.b	0
	dc.b	$20
	dc.b	$C0
	dc.b	0
	dc.b	$40
	dc.b	0
	dc.b	0
	dc.b	$F
	dc.b	$ED
	dc.b	$30
	dc.b	$CD
	dc.b	$34
	dc.b	$C0
	dc.b	$34
off_1B12E
	dc.l	unk_1B4C2
	dc.b	0
	dc.b	$20
	dc.b	$E0
	dc.b	0
	dc.b	$60
	dc.b	0
	dc.b	0
	dc.b	$F
	dc.b	$ED
	dc.b	0
	dc.b	$CD
	dc.b	4
	dc.b	$C0
	dc.b	4
off_1B140
	dc.l	unk_1B4C2
	dc.b	0
	dc.b	$20
	dc.b	$E0
	dc.b	0
	dc.b	$60
	dc.b	0
	dc.b	0
	dc.b	$F
	dc.b	$ED
	dc.b	$30
	dc.b	$CD
	dc.b	$34
	dc.b	$C0
	dc.b	$34
; -----------------------------------------------------------------------------------------

SpecPlane85:
	rts
; -----------------------------------------------------------------------------------------

SpecPlane90:
	rts
; -----------------------------------------------------------------------------------------
	clr.w	d2
	move.b	opponent,d2
	lsl.b	#2,d2
	lea	(off_1B632).l,a4
	movea.l	(a4,d2.w),a3
	move.b	1(a2),d2
	lsl.b	#2,d2
	movea.l	(a3,d2.w),a4
	move.w	(a4)+,d3
	move.w	(a4)+,d4
	move.w	(a4)+,d5
	addi.w	#$FEE,d5
	move.w	#$8000,d6
	bra.w	CopyTilemap8
; -----------------------------------------------------------------------------------------

SpecPlane94:
	clr.w	d2
	move.b	opponent,d2
	lsl.b	#2,d2
	lea	(off_1B632).l,a4
	movea.l	(a4,d2.w),a3
	move.b	1(a2),d2
	lsl.b	#2,d2
	movea.l	(a3,d2.w),a4
	move.w	(a4)+,d3
	move.w	(a4)+,d4
	move.w	(a4)+,d5
	move.w	#$8100,d6
	bra.w	CopyTilemap8
; -----------------------------------------------------------------------------------------

SpecPlane95:
	rts
; -----------------------------------------------------------------------------------------

SpecPlane91:
	clr.w	d3
	move.b	1(a2),d3
	subq.w	#1,d3
	move.w	2(a2),d5
	bsr.w	SetVRAMWrite
	add.w	d1,d5
	move.w	#$E011,VDP_DATA
	move.w	d3,d0

loc_1B1D0:
	move.w	#$E012,VDP_DATA
	dbf	d0,loc_1B1D0
	move.w	#$E811,VDP_DATA
	bsr.w	SetVRAMWrite
	add.w	d1,d5
	move.w	#$E013,VDP_DATA
	move.w	d3,d0

loc_1B1F4:
	move.w	#$E500,VDP_DATA
	dbf	d0,loc_1B1F4
	move.w	#$E813,VDP_DATA
	bsr.w	SetVRAMWrite
	add.w	d1,d5
	move.w	#$F011,VDP_DATA
	move.w	d3,d0

loc_1B218:
	move.w	#$F012,VDP_DATA
	dbf	d0,loc_1B218
	move.w	#$F811,VDP_DATA
	rts
; -----------------------------------------------------------------------------------------

QueueLoadMap:
	movea.l	(a2),a3
	move.w	(a3)+,d2
	clr.w	d3
	move.b	(a3)+,d3
	subq.b	#1,d3
	clr.w	d4
	move.b	(a3)+,d4
	subq.b	#1,d4
	move.w	(a3)+,d5
	movea.l	off_1B246(pc,d2.w),a4
	jmp	(a4)
; End of function ProcPlaneCommand

; -----------------------------------------------------------------------------------------
off_1B246
	dc.l	QueueFillPlane
	dc.l	QueueCopyMap8
	dc.l	QueueCopyMapDirect
	dc.l	QueueCopyTwoMaps
	dc.l	QueueCopyMapPalMap
	dc.l	QueueCopyMap16
; -----------------------------------------------------------------------------------------

QueueFillPlane:
	move.w	(a3)+,d6

; =============== S U B	R O U T	I N E =====================================================


FillPlane:
	bsr.w	SetVRAMWrite
	clr.w	d0
	move.w	d3,d0

loc_1B268:
	move.w	d6,VDP_DATA
	dbf	d0,loc_1B268
	add.w	d1,d5
	dbf	d4,FillPlane
	rts
; End of function FillPlane


; =============== S U B	R O U T	I N E =====================================================


QueueCopyMap8:
	movea.l	(a3)+,a4
	move.w	(a3)+,d6
; End of function QueueCopyMap8

; START	OF FUNCTION CHUNK FOR ProcPlaneCommand

CopyTilemap8:
	bsr.w	SetVRAMWrite
	clr.w	d0
	move.w	d3,d0

.Tile:
	move.b	(a4)+,d6
	move.w	d6,VDP_DATA
	dbf	d0,.Tile
	add.w	d1,d5
	dbf	d4,CopyTilemap8
	rts
; END OF FUNCTION CHUNK	FOR ProcPlaneCommand

; =============== S U B	R O U T	I N E =====================================================


QueueCopyMapDirect:
	movea.l	(a3)+,a4
; End of function QueueCopyMapDirect


; =============== S U B	R O U T	I N E =====================================================


CopyTilemap:
	bsr.w	SetVRAMWrite
	clr.w	d0
	move.w	d3,d0

loc_1B2A4:
	move.w	(a4)+,VDP_DATA
	dbf	d0,loc_1B2A4
	add.w	d1,d5
	dbf	d4,CopyTilemap
	rts
; End of function CopyTilemap


; =============== S U B	R O U T	I N E =====================================================


QueueCopyMap16:
	movea.l	(a3)+,a4
	move.w	(a3)+,d6

loc_1B2BA:
	bsr.w	SetVRAMWrite
	clr.w	d0
	move.w	d3,d0

loc_1B2C2:
	move.w	(a4)+,d2
	add.w	d6,d2
	move.w	d2,VDP_DATA
	dbf	d0,loc_1B2C2
	add.w	d1,d5
	dbf	d4,loc_1B2BA
	rts
; End of function QueueCopyMap16


; =============== S U B	R O U T	I N E =====================================================


QueueCopyTwoMaps:
	movea.l	(a3)+,a4
	movea.l	(a3)+,a5
	move.w	(a3)+,d6
	move.w	(a3)+,d2

loc_1B2E0:
	bsr.w	SetVRAMWrite
	clr.w	d0
	move.w	d3,d0

loc_1B2E8:
	bsr.w	sub_1B2F8
	dbf	d0,loc_1B2E8
	add.w	d1,d5
	dbf	d4,loc_1B2E0
	rts
; End of function QueueCopyTwoMaps


; =============== S U B	R O U T	I N E =====================================================


sub_1B2F8:
	move.b	(a4)+,d6
	move.b	(a5)+,d2
	beq.w	loc_1B308
	move.w	d2,VDP_DATA
	rts
; -----------------------------------------------------------------------------------------

loc_1B308:
	move.w	d6,VDP_DATA
	rts
; End of function sub_1B2F8


; =============== S U B	R O U T	I N E =====================================================


QueueCopyMapPalMap:
	movea.l	(a3)+,a4
	movea.l	(a3)+,a5
	move.w	(a3)+,d6
	clr.b	d2

loc_1B318:
	bsr.w	SetVRAMWrite
	swap	d5
	clr.w	d0
	move.w	d3,d0

loc_1B322:
	andi.b	#3,d2
	bne.w	loc_1B32E
	move.b	(a5)+,d7
	ror.w	#1,d7

loc_1B32E:
	ror.w	#2,d7
	move.w	d7,d5
	andi.w	#$6000,d5
	or.w	d6,d5
	move.b	(a4)+,d5
	move.w	d5,VDP_DATA
	addq.b	#1,d2
	dbf	d0,loc_1B322
	swap	d5
	add.w	d1,d5
	dbf	d4,loc_1B318
	rts
; End of function QueueCopyMapPalMap


; =============== S U B	R O U T	I N E =====================================================


sub_1B350:
	divu.w	#10000,d2
	lea	p1_score_vram,a3
	move.w	#2,d3
	move.l	d2,d4
	swap	d4

loc_1B362:
	andi.l	#$FFFF,d4
	divu.w	#10,d4
	swap	d4
	move.b	d4,-(a3)
	swap	d4
	dbf	d3,loc_1B362
	move.b	d4,-(a3)
	move.w	#2,d3
	move.w	d2,d4

loc_1B37E:
	andi.l	#$FFFF,d4
	divu.w	#10,d4
	swap	d4
	move.b	d4,-(a3)
	swap	d4
	dbf	d3,loc_1B37E
	move.b	d4,-(a3)
	rts
; End of function sub_1B350


; =============== S U B	R O U T	I N E =====================================================


sub_1B396:
	andi.l	#$FFFF,d2
	beq.w	locret_1B3AC
	divu.w	#10,d2
	swap	d2
	move.b	d2,-(a3)
	swap	d2
	bra.s	sub_1B396
; -----------------------------------------------------------------------------------------

locret_1B3AC:
	rts
; End of function sub_1B396


; =============== S U B	R O U T	I N E =====================================================


SetVRAMWrite:
	move.w	d5,d7
	andi.w	#$3FFF,d7
	ori.w	#$4000,d7
	move.w	d7,VDP_CTRL
	move.w	d5,d7
	rol.w	#2,d7
	andi.w	#3,d7
	move.w	d7,VDP_CTRL
	rts
; End of function SetVRAMWrite


; =============== S U B	R O U T	I N E =====================================================


SetVRAMRead:
	move.w	d5,d7
	andi.w	#$3FFF,d7
	move.w	d7,VDP_CTRL
	move.w	d5,d7
	rol.w	#2,d7
	andi.w	#3,d7
	move.w	d7,VDP_CTRL
	rts
; End of function SetVRAMRead

; -----------------------------------------------------------------------------------------
unk_1B3EA
	dc.b	$8E
	dc.b	$8F
	dc.b	$90
	dc.b	$91
	dc.b	$92
	dc.b	$93
	dc.b	$94
	dc.b	$95
	dc.b	$8E
	dc.b	$8F
	dc.b	$90
	dc.b	$91
	dc.b	$92
	dc.b	$93
	dc.b	$94
	dc.b	$95
	dc.b	$A0
	dc.b	$A1
	dc.b	$A2
	dc.b	$A3
	dc.b	$A4
	dc.b	$A5
	dc.b	$A6
	dc.b	$A7
	dc.b	$A0
	dc.b	$A1
	dc.b	$A2
	dc.b	$A3
	dc.b	$A4
	dc.b	$A5
	dc.b	$A6
	dc.b	$A7
	dc.b	$8E
	dc.b	$8F
	dc.b	$90
	dc.b	$91
	dc.b	$B9
	dc.b	$BA
	dc.b	$BB
	dc.b	$BC
	dc.b	$BD
	dc.b	$BE
	dc.b	$BF
	dc.b	$C0
	dc.b	$92
	dc.b	$93
	dc.b	$94
	dc.b	$95
	dc.b	$A0
	dc.b	$A1
	dc.b	$A2
	dc.b	$C1
	dc.b	$C2
	dc.b	$C3
	dc.b	$C4
	dc.b	$C5
	dc.b	$C6
	dc.b	$C7
	dc.b	$C8
	dc.b	$C9
	dc.b	$A4
	dc.b	$A5
	dc.b	$A6
	dc.b	$A7
	dc.b	$8E
	dc.b	$8F
	dc.b	$CA
	dc.b	$CB
	dc.b	$CC
	dc.b	$CD
	dc.b	$CE
	dc.b	$77
	dc.b	$CF
	dc.b	$D0
	dc.b	$D1
	dc.b	$D2
	dc.b	$D3
	dc.b	$D4
	dc.b	$94
	dc.b	$95
	dc.b	$A0
	dc.b	$A1
	dc.b	$D5
	dc.b	$D6
	dc.b	$D7
	dc.b	$D8
	dc.b	$D9
	dc.b	$DA
	dc.b	$DB
	dc.b	$DC
	dc.b	$DD
	dc.b	$DE
	dc.b	$DF
	dc.b	$E0
	dc.b	$A6
	dc.b	$A7
	dc.b	$8E
	dc.b	$8F
	dc.b	$E1
	dc.b	$E2
	dc.b	$74
	dc.b	$75
	dc.b	$76
	dc.b	$77
	dc.b	$78
	dc.b	$79
	dc.b	$7A
	dc.b	$7B
	dc.b	$74
	dc.b	$75
	dc.b	$94
	dc.b	$95
	dc.b	$A0
	dc.b	$A1
	dc.b	$E3
	dc.b	$E4
	dc.b	$E5
	dc.b	$E6
	dc.b	$E7
	dc.b	$E8
	dc.b	$E9
	dc.b	$EA
	dc.b	$EB
	dc.b	$EC
	dc.b	$ED
	dc.b	$EE
	dc.b	$A6
	dc.b	$A7
	dc.b	$8E
	dc.b	$8F
	dc.b	$72
	dc.b	$73
	dc.b	$74
	dc.b	$75
	dc.b	$76
	dc.b	$77
	dc.b	$78
	dc.b	$79
	dc.b	$7A
	dc.b	$7B
	dc.b	$74
	dc.b	$75
	dc.b	$94
	dc.b	$95
	dc.b	$A0
	dc.b	$A1
	dc.b	$84
	dc.b	$85
	dc.b	$86
	dc.b	$87
	dc.b	$88
	dc.b	$89
	dc.b	$8A
	dc.b	$8B
	dc.b	$8C
	dc.b	$8D
	dc.b	$86
	dc.b	$87
	dc.b	$A6
	dc.b	$A7
	dc.b	$8E
	dc.b	$8F
	dc.b	$90
	dc.b	$91
	dc.b	$92
	dc.b	$93
	dc.b	$94
	dc.b	$95
	dc.b	$8E
	dc.b	$8F
	dc.b	$90
	dc.b	$91
	dc.b	$92
	dc.b	$93
	dc.b	$94
	dc.b	$95
	dc.b	$A0
	dc.b	$A1
	dc.b	$A2
	dc.b	$A3
	dc.b	$A4
	dc.b	$A5
	dc.b	$A6
	dc.b	$A7
	dc.b	$A0
	dc.b	$A1
	dc.b	$A2
	dc.b	$A3
	dc.b	$A4
	dc.b	$A5
	dc.b	$A6
	dc.b	$A7
	dc.b	3
	dc.b	4
	dc.b	5
	dc.b	6
	dc.b	7
	dc.b	8
	dc.b	1
	dc.b	2
	dc.b	3
	dc.b	4
	dc.b	5
	dc.b	6
	dc.b	$13
	dc.b	$14
	dc.b	$15
	dc.b	$16
	dc.b	$17
	dc.b	$18
	dc.b	$11
	dc.b	$12
	dc.b	$13
	dc.b	$14
	dc.b	$15
	dc.b	$16
unk_1B4C2
	dc.b	$1B
	dc.b	$18
	dc.b	$15
	dc.b	$14
	dc.b	$15
	dc.b	$16
	dc.b	$17
	dc.b	$18
	dc.b	$19
	dc.b	$15
	dc.b	$16
	dc.b	$1A
	dc.b	$1B
	dc.b	$18
	dc.b	$15
	dc.b	$1A
	dc.b	$3B
	dc.b	$38
	dc.b	$35
	dc.b	$34
	dc.b	$35
	dc.b	$36
	dc.b	$37
	dc.b	$38
	dc.b	$39
	dc.b	$35
	dc.b	$36
	dc.b	$3A
	dc.b	$3B
	dc.b	$38
	dc.b	$35
	dc.b	$34
	dc.b	$1B
	dc.b	$18
	dc.b	$15
	dc.b	$14
	dc.b	$15
	dc.b	$1C
	dc.b	$FF
	dc.b	$FF
	dc.b	$FF
	dc.b	$FF
	dc.b	$13
	dc.b	$1A
	dc.b	$1B
	dc.b	$18
	dc.b	$15
	dc.b	$1A
	dc.b	$3B
	dc.b	$38
	dc.b	$35
	dc.b	$34
	dc.b	$35
	dc.b	$3C
	dc.b	$13
	dc.b	$18
	dc.b	$19
	dc.b	$1C
	dc.b	$33
	dc.b	$3A
	dc.b	$3B
	dc.b	$38
	dc.b	$35
	dc.b	$34
	dc.b	$1B
	dc.b	$18
	dc.b	$15
	dc.b	$1C
	dc.b	$FF
	dc.b	$FF
	dc.b	$FF
	dc.b	$FF
	dc.b	$FF
	dc.b	$FF
	dc.b	$FF
	dc.b	$FF
	dc.b	$13
	dc.b	$18
	dc.b	$15
	dc.b	$1A
	dc.b	$3B
	dc.b	$38
	dc.b	$35
	dc.b	$3C
	dc.b	$13
	dc.b	$1C
	dc.b	$FF
	dc.b	$FF
	dc.b	$FF
	dc.b	$FF
	dc.b	$13
	dc.b	$1C
	dc.b	$33
	dc.b	$38
	dc.b	$35
	dc.b	$34
	dc.b	$1B
	dc.b	$1C
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	$13
	dc.b	$1A
	dc.b	$3B
	dc.b	$3C
	dc.b	$13
	dc.b	$1C
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	$13
	dc.b	$1C
	dc.b	$33
	dc.b	$34
	dc.b	$1B
	dc.b	$1C
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	$13
	dc.b	$1A
	dc.b	$3B
	dc.b	$3C
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	$33
	dc.b	$34
	dc.b	$1B
	dc.b	$18
	dc.b	$15
	dc.b	$14
	dc.b	$15
	dc.b	$16
	dc.b	$17
	dc.b	$18
	dc.b	$19
	dc.b	$15
	dc.b	$16
	dc.b	$1A
	dc.b	$1B
	dc.b	$18
	dc.b	$15
	dc.b	$1A
	dc.b	$3B
	dc.b	$38
	dc.b	$35
	dc.b	$34
	dc.b	$35
	dc.b	$36
	dc.b	$37
	dc.b	$38
	dc.b	$39
	dc.b	$35
	dc.b	$36
	dc.b	$3A
	dc.b	$3B
	dc.b	$38
	dc.b	$35
	dc.b	$34
	dc.b	$13
	dc.b	$14
	dc.b	$15
	dc.b	$16
	dc.b	$17
	dc.b	$16
	dc.b	$1C
	dc.b	5
	dc.b	2
	dc.b	$A
	dc.b	1
	dc.b	2
	dc.b	$33
	dc.b	$34
	dc.b	$35
	dc.b	$36
	dc.b	$37
	dc.b	$36
	dc.b	$3C
	dc.b	5
	dc.b	1
	dc.b	2
	dc.b	6
	dc.b	5
word_1B59A
	dc.w	9
	dc.w	6
	dc.w	$C61E
	dc.b	0, 1, 2, 3, 4, 5, 6, 7, 8, 9, $20, $21, $22, $23, $24, $25
	dc.b	$26, $27, $28, $29, $40, $41, $42, $43, $44, $45, $46, $47, $48, $49, $60, $61
	dc.b	$62, $63, $64, $65, $66, $67, $68, $69, $80, $81, $82, $83, $84, $85, $86, $87
	dc.b	$88, $89, $A0, $A1, $A2, $A3, $A4, $A5, $A6, $A7, $A8, $A9, $C0, $C1, $C2, $C3
	dc.b	$C4, $C5, $C6, $C7, $C8, $C9
word_1B5E6
	dc.w	9
	dc.w	6
	dc.w	$C61E
	dc.b	$16, $17, $18, $19, $1A, $1B, $1C, $1D, $1E, $1F, $36, $37, $38, $39, $3A, $3B
	dc.b	$3C, $3D, $3E, $3F, $56, $57, $58, $59, $5A, $5B, $5C, $5D, $5E, $5F, $76, $77
	dc.b	$78, $79, $7A, $7B, $7C, $7D, $7E, $7F, $96, $97, $98, $99, $9A, $9B, $9C, $9D
	dc.b	$9E, $9F, $B6, $B7, $B8, $B9, $BA, $BB, $BC, $BD, $BE, $BF, $D6, $D7, $D8, $D9
	dc.b	$DA, $DB, $DC, $DD, $DE, $DF
off_1B632
	dc.l	off_1BB24
	dc.l	off_1BC3A
	dc.l	off_1BD2A
	dc.l	off_1BDD8
	dc.l	off_1BEFA
	dc.l	off_1C064
	dc.l	off_1C16E
	dc.l	off_1C228
	dc.l	off_1C314
	dc.l	off_1C4BA
	dc.l	off_1C638
	dc.l	off_1C712
	dc.l	off_1C846
	dc.l	off_1B676
	dc.l	off_1B7A0
	dc.l	off_1B900
	dc.l	off_1BB24
off_1B676
	dc.l	word_1B59A
	dc.l	word_1B5E6
	dc.l	word_1B6A6
	dc.l	word_1B6B4
	dc.l	word_1B6C2
	dc.l	word_1B6D0
	dc.l	word_1B6DE
	dc.l	word_1B6EC
	dc.l	word_1B6FA
	dc.l	word_1B718
	dc.l	word_1B736
	dc.l	word_1B754
word_1B6A6
	dc.w	3
	dc.w	1
	dc.w	$C724
	dc.b	$43, $44, $45, $46, $63, $64, $65, $66
word_1B6B4
	dc.w	3
	dc.w	1
	dc.w	$C724
	dc.b	$A, $B, $C, $D, $2A, $2B, $2C, $2D
word_1B6C2
	dc.w	3
	dc.w	1
	dc.w	$C724
	dc.b	$4A, $4B, $4C, $4D, $6A, $6B, $6C, $6D
word_1B6D0
	dc.w	3
	dc.w	1
	dc.w	$C724
	dc.b	$E, $F, $10, $11, $2E, $2F, $30, $31
word_1B6DE
	dc.w	3
	dc.w	1
	dc.w	$C724
	dc.b	$4E, $4F, $50, $51, $6E, $6F, $70, $71
word_1B6EC
	dc.w	3
	dc.w	1
	dc.w	$C724
	dc.b	$8E, $8F, $90, $91, $AE, $AF, $B0, $B1
word_1B6FA
	dc.w	7
	dc.w	2
	dc.w	$C720
	dc.b	$41, $42, $8A, $8B, $8C, $8D, $47, $48, $12, $13, $AA, $AB, $AC, $AD, $14, $15
	dc.b	$32, $33, $83, $84, $85, $86, $34, $35
word_1B718
	dc.w	7
	dc.w	2
	dc.w	$C720
	dc.b	$41, $42, $CA, $CB, $CC, $CD, $47, $48, $52, $53, $EA, $EB, $EC, $ED, $54, $55
	dc.b	$72, $73, $83, $84, $85, $86, $74, $75
word_1B736
	dc.w	7
	dc.w	2
	dc.w	$C720
	dc.b	$41, $42, $CA, $CB, $CC, $CD, $47, $48, $92, $93, $EA, $EB, $EC, $ED, $94, $95
	dc.b	$B2, $B3, $83, $84, $85, $86, $B4, $B5
word_1B754
	dc.w	9
	dc.w	6
	dc.w	$C61E
	dc.b	$16, $17, $18, $19, $1A, $1B, $F6, $F7, $D4, $D5, $36, $37, $38, $39, $3A, $3B
	dc.b	$D2, $D3, $F4, $F5, $56, $CE, $CF, $59, $D0, $D1, $F2, $F3, $5E, $5F, $76, $EE
	dc.b	$EF, $79, $F0, $F1, $7C, $7D, $7E, $7F, $96, $97, $98, $99, $9A, $9B, $9C, $9D
	dc.b	$9E, $9F, $B6, $B7, $B8, $B9, $BA, $BB, $BC, $BD, $BE, $BF, $D6, $D7, $D8, $D9
	dc.b	$DA, $DB, $DC, $DD, $DE, $DF
off_1B7A0
	dc.l	word_1B59A
	dc.l	word_1B5E6
	dc.l	word_1B7D8
	dc.l	word_1B7EE
	dc.l	word_1B804
	dc.l	word_1B83A
	dc.l	word_1B870
	dc.l	word_1B8D0
	dc.l	word_1B8D8
	dc.l	word_1B8E0
	dc.l	word_1B8E8
	dc.l	word_1B8F0
	dc.l	word_1B8F8
	dc.l	word_1B8A6
word_1B7D8
	dc.w	4
	dc.w	2
	dc.w	$C6A2
	dc.b	$A, $B, $C, $D, $E, $2A, $2B, $2C, $2D, $2E, $4A, $4B, $4C, $4D, $4E, 0
word_1B7EE
	dc.w	4
	dc.w	2
	dc.w	$C6A2
	dc.b	$22, $6B, $6C, $6D, $6E, $8A, $8B, $8C, $8D, $8E, $AA, $AB, $AC, $AD, $AE, 0
word_1B804
	dc.w	7
	dc.w	5
	dc.w	$C6A0
	dc.b	$21, $E0, $E1, $E2, $E3, $E4, $27, $28, $41, $E5, $E6, $E7, $E8, $E9, $47, $48
	dc.b	$61, $EA, $EB, $EC, $ED, $EE, $67, $68, $81, $82, $83, $CE, $CF, $86, $87, $88
	dc.b	$A1, $A2, $A3, $A4, $A5, $A6, $A7, $A8, $C1, $C2, $C3, $C4, $C5, $C6, $C7, $C8
word_1B83A
	dc.w	7
	dc.w	5
	dc.b	$C6, $A0, $21, $E0, $E1, $E2, $E3, $E4, $27, $28, $41, $E5, $E6, $E7, $E8, $E9
	dc.b	$47, $48, $61, $EA, $EB, $EC, $ED, $EE, $67, $68, $6F, $70, $83, $CE, $CF, $86
	dc.b	$14, $15, $8F, $90, $A3, $A4, $A5, $A6, $34, $35, $AF, $B0, $C3, $C4, $C5, $C6
	dc.b	$54, $55
word_1B870
	dc.w	7
	dc.w	5
	dc.w	$C6A0
	dc.b	$21, $E0, $E1, $E2, $E3, $E4, $27, $28, $41, $E5, $E6, $E7, $E8, $E9, $47, $48
	dc.b	$61, $EA, $EB, $EC, $ED, $EE, $67, $68, $71, $72, $83, $CE, $CF, $86, $74, $75
	dc.b	$91, $92, $A3, $A4, $A5, $A6, $94, $95, $B1, $B2, $C3, $C4, $C5, $C6, $B4, $B5
word_1B8A6
	dc.w	6
	dc.w	4
	dc.w	$C624
	dc.b	$19, $1A, $F, $10, $11, $12, $13, $39, $3A, $2F, $30, $31, $32, $33, $59, $5A
	dc.b	$4F, $50, $51, $52, $53, $D4, $D5, $7B, $7C, $7D, $7E, $7F, $F4, $F5, $9B, $9C
	dc.b	$9D, $9E, $9F, 0
word_1B8D0
	dc.w	1
	dc.w	0
	dc.w	$C826
	dc.b	$84, $85
word_1B8D8
	dc.w	1
	dc.w	0
	dc.w	$C826
	dc.b	$CA, $CB
word_1B8E0
	dc.w	1
	dc.w	0
	dc.w	$C826
	dc.b	$CC, $CD
word_1B8E8
	dc.w	1
	dc.w	0
	dc.w	$C826
	dc.b	$CE, $CF
word_1B8F0
	dc.w	1
	dc.w	0
	dc.w	$C826
	dc.b	$D0, $D1
word_1B8F8
	dc.w	1
	dc.w	0
	dc.w	$C826
	dc.b	$D2, $D3
off_1B900
	dc.l	word_1B59A
	dc.l	word_1B5E6
	dc.l	word_1B93C
	dc.l	word_1B94C
	dc.l	word_1B95C
	dc.l	word_1B96E
	dc.l	word_1B980
	dc.l	word_1B992
	dc.l	word_1B9D4
	dc.l	word_1BA16
	dc.l	word_1BA58
	dc.l	word_1BA9A
	dc.l	word_1BADC
	dc.l	word_1BAF4
	dc.l	word_1BB0C
word_1B93C
	dc.w	4
	dc.w	1
	dc.w	$C822
	dc.b	$AA, $AB, $AC, $AD, $AE, $CA, $CB, $CC, $CD, $CE
word_1B94C
	dc.w	4
	dc.w	1
	dc.w	$C822
	dc.b	$EA, $EB, $EC, $ED, $EE, $E5, $E6, $E7, $E8, $E9
word_1B95C
	dc.w	5
	dc.w	1
	dc.w	$C822
	dc.b	$E0, $E1, $E2, $E3, $E4, $87, $E5, $E6, $E7, $E8, $E9, $A7
word_1B96E
	dc.w	5
	dc.w	1
	dc.w	$C822
	dc.b	$E0, $FA, $FB, $FC, $E4, $87, $E5, $E6, $E7, $E8, $E9, $A7
word_1B980
	dc.w	5
	dc.w	1
	dc.w	$C822
	dc.b	$E0, $FD, $FE, $FF, $E4, $87, $E5, $E6, $E7, $E8, $E9, $A7
word_1B992
	dc.w	9
	dc.w	5
	dc.w	$C61E
	dc.b	0, 1, 2, 3, 4, 5, 6, 7, 8, 9, $20, $21, $22, $23, $24, $25
	dc.b	$26, $27, $28, $29, $40, $41, $42, $EF, $44, $F0, $46, $47, $48, $49, $60, $61
	dc.b	$F1, $F2, $64, $F3, $F4, $67, $68, $69, $80, $81, $F5, $F6, $F7, $F8, $F9, $87
	dc.b	$88, $89, $A0, $A1, $E5, $E6, $E7, $E8, $E9, $A7, $A8, $A9
word_1B9D4
	dc.w	9
	dc.w	5
	dc.w	$C61E
	dc.b	0, 1, 2, 3, 4, 5, 6, 7, $14, $15, $20, $91, $22, $23, $24, $25
	dc.b	$26, $27, $34, $35, $40, $B1, $42, $EF, $44, $F0, $46, $47, $54, $55, $60, $D1
	dc.b	$F1, $F2, $64, $F3, $F4, $67, $74, $75, $80, $81, $F5, $D3, $D4, $D5, $F9, $87
	dc.b	$88, $89, $A0, $A1, $E5, $E6, $E7, $E8, $E9, $A7, $A8, $A9
word_1BA16
	dc.w	9
	dc.w	5
	dc.w	$C61E
	dc.b	0, 1, 2, 3, 4, 5, 6, 7, $14, $15, $20, $90, $22, $23, $24, $25
	dc.b	$26, $27, $12, $13, $50, $51, $42, $EF, $44, $F0, $46, $47, $32, $33, $70, $71
	dc.b	$F1, $F2, $64, $F3, $F4, $67, $52, $53, $80, $81, $F5, $F6, $F7, $F8, $F9, $87
	dc.b	$88, $89, $A0, $A1, $E5, $E6, $E7, $E8, $E9, $A7, $A8, $A9
word_1BA58
	dc.w	9
	dc.w	5
	dc.w	$C61E
	dc.b	0, 1, 2, 3, 4, 5, 6, 7, $14, $15, $20, $90, $22, $23, $24, $25
	dc.b	$26, $27, $12, $13, $10, $11, $42, $EF, $44, $F0, $46, $47, $94, $95, $30, $31
	dc.b	$F1, $F2, $64, $F3, $F4, $67, $B4, $B5, $80, $81, $F5, $D3, $D4, $D5, $F9, $87
	dc.b	$88, $89, $A0, $A1, $E5, $E6, $E7, $E8, $E9, $A7, $A8, $A9
word_1BA9A
	dc.w	9
	dc.w	5
	dc.w	$C61E
	dc.b	0, 1, 2, 3, 4, 5, 6, 7, $14, $15, $8F, $90, $22, $23, $24, $25
	dc.b	$26, $27, $72, $73, $AF, $B0, $42, $EF, $44, $F0, $46, $47, $92, $93, $CF, $D0
	dc.b	$F1, $F2, $64, $F3, $F4, $67, $B2, $B3, $80, $81, $F5, $D3, $D4, $D5, $F9, $87
	dc.b	$88, $89, $A0, $A1, $E5, $E6, $E7, $E8, $E9, $A7, $A8, $A9
word_1BADC
	dc.w	5
	dc.w	2
	dc.w	$C7A0
	dc.b	$4C, $4D, $4E, $7A, $7B, $7C, $97, $98, $99, $9A, $C, $D, $B7, $B8, $B9, $BA
	dc.b	$2C, $2D
word_1BAF4
	dc.w	5
	dc.w	2
	dc.w	$C7A0
	dc.b	$77, $4A, $4B, $7A, $7B, $7C, $97, $6A, $6B, $A, $B, $9C, $B7, $B8, $B9, $2A
	dc.b	$2B, $BC
word_1BB0C
	dc.w	5
	dc.w	2
	dc.w	$C7A0
	dc.b	$77, $78, $2F, $7A, $7B, $7C, $97, $98, $4F, $E, $F, $9C, $B7, $B8, $6F, $2E
	dc.b	$BB, $BC
off_1BB24
	dc.l	word_1B59A
	dc.l	word_1B5E6
	dc.l	word_1BB5C
	dc.l	word_1BB6E
	dc.l	word_1BB80
	dc.l	word_1BBA2
	dc.l	word_1BBC4
	dc.l	word_1BBE6
	dc.l	word_1BBF2
	dc.l	word_1BBFE
	dc.l	word_1BC0A
	dc.l	word_1BC16
	dc.l	word_1BC22
	dc.l	word_1BC2E
word_1BB5C
	dc.w	5
	dc.w	1
	dc.w	$C724
	dc.b	$43, $44, $45, $46, $47, $48, $63, $64, $65, $66, $67, $68
word_1BB6E
	dc.w	5
	dc.w	1
	dc.w	$C724
	dc.b	$43, $44, $45, $46, $B4, $B5, $94, $95, $65, $66, $67, $68
word_1BB80
	dc.w	6
	dc.w	3
	dc.w	$C7A4
	dc.b	$63, $64, $65, $66, $14, $15, $34, $D, $E, $F, $10, $11, $12, $13, $2D, $2E
	dc.b	$2F, $30, $31, $32, $33, $4D, $4E, $4F, $50, $51, $52, $53
word_1BBA2
	dc.w	6
	dc.w	3
	dc.w	$C7A4
	dc.b	$63, $64, $65, $66, $54, $55, $34, $6D, $6E, $6F, $70, $71, $72, $73, $8D, $8E
	dc.b	$8F, $90, $91, $92, $93, $AD, $AE, $AF, $B0, $B1, $B2, $B3
word_1BBC4
	dc.w	6
	dc.w	3
	dc.w	$C7A4
	dc.b	$63, $64, $65, $66, $74, $75, $34, $CD, $CE, $CF, $D0, $D1, $D2, $D3, $ED, $EE
	dc.b	$EF, $F0, $F1, $F2, $F3, $F7, $F8, $F9, $FA, $FB, $FC, $FD
word_1BBE6
	dc.w	2
	dc.w	1
	dc.w	$C61E
	dc.b	0, 1, 2, $20, $21, $22
word_1BBF2
	dc.w	2
	dc.w	1
	dc.w	$C61E
	dc.b	$A, $B, $C, $2A, $2B, $2C
word_1BBFE
	dc.w	2
	dc.w	1
	dc.w	$C61E
	dc.b	$4A, $4B, $4C, $6A, $6B, $6C
word_1BC0A
	dc.w	2
	dc.w	1
	dc.w	$C61E
	dc.b	$8A, $8B, $8C, $AA, $AB, $AC
word_1BC16
	dc.w	2
	dc.w	1
	dc.w	$C61E
	dc.b	$CA, $CB, $CC, $EA, $EB, $EC
word_1BC22
	dc.w	2
	dc.w	1
	dc.w	$C61E
	dc.b	$E0, $E1, $E2, $E3, $E4, $E5
word_1BC2E
	dc.w	2
	dc.w	1
	dc.w	$C61E
	dc.b	$E6, $E7, $E8, $F4, $F5, $F6
off_1BC3A
	dc.l	word_1B59A
	dc.l	word_1B5E6
	dc.l	word_1BC66
	dc.l	word_1BC76
	dc.l	word_1BC86
	dc.l	word_1BC96
	dc.l	word_1BCAE
	dc.l	word_1BCC6
	dc.l	word_1BCDE
	dc.l	word_1BCEE
	dc.l	word_1BD0C
word_1BC66
	dc.w	4
	dc.w	1
	dc.w	$C7A0
	dc.b	$61, $62, $63, $64, $65, $81, $82, $83, $84, $85
word_1BC76
	dc.w	4
	dc.w	1
	dc.w	$C7A0
	dc.b	$A, $B, $C, $D, $E, $2A, $2B, $2C, $2D, $2E
word_1BC86
	dc.w	4
	dc.w	1
	dc.w	$C7A0
	dc.b	$4A, $4B, $4C, $4D, $4E, $6A, $6B, $6C, $6D, $6E
word_1BC96
	dc.w	5
	dc.w	2
	dc.w	$C71E
	dc.b	$10, $11, $12, $13, $14, $15, $30, $31, $32, $33, $34, $35, $80, $81, $82, $83
	dc.b	$84, $85
word_1BCAE
	dc.w	5
	dc.w	2
	dc.w	$C71E
	dc.b	$10, $11, $12, $13, $14, $15, $50, $51, $52, $53, $54, $55, $70, $71, $72, $73
	dc.b	$74, $75
word_1BCC6
	dc.w	5
	dc.w	2
	dc.w	$C71E
	dc.b	$10, $11, $12, $13, $14, $15, $90, $91, $92, $93, $94, $95, $B0, $B1, $B2, $B3
	dc.b	$B4, $B5
word_1BCDE
	dc.w	4
	dc.w	1
	dc.w	$C6A0
	dc.b	$D0, $D1, $D2, $D3, $D4, $F0, $F1, $F2, $F3, $F4
word_1BCEE
	dc.w	5
	dc.w	3
	dc.w	$C7A0
	dc.b	$61, $62, $63, $64, $65, $66, $81, $82, $83, $84, $85, $86, $A1, $A2, $A3, $A4
	dc.b	$A5, $A6, $C1, $C2, $C3, $C4, $C5, $C6
word_1BD0C
	dc.w	5
	dc.w	3
	dc.w	$C7A0
	dc.b	$8A, $8B, $8C, $8D, $8E, $8F, $AA, $AB, $AC, $AD, $AE, $AF, $CA, $CB, $CC, $CD
	dc.b	$CE, $CF, $EA, $EB, $EC, $ED, $EE, $EF
off_1BD2A
	dc.l	word_1B59A
	dc.l	word_1B5E6
	dc.l	word_1BD4A
	dc.l	word_1BD5C
	dc.l	word_1BD6E
	dc.l	word_1BD80
	dc.l	word_1BDB8
	dc.l	word_1BDC8
word_1BD4A
	dc.w	3
	dc.w	2
	dc.w	$C7A6
	dc.b	$64, $65, $66, $67, $84, $85, $86, $87, $A4, $A5, $A6, $A7
word_1BD5C
	dc.w	3
	dc.w	2
	dc.w	$C7A6
	dc.b	$11, $12, $13, $14, $31, $32, $33, $34, $51, $52, $53, $54
word_1BD6E
	dc.w	3
	dc.w	2
	dc.w	$C7A6
	dc.b	$71, $72, $73, $74, $91, $92, $93, $94, $B1, $B2, $B3, $B4
word_1BD80
	dc.w	6
	dc.w	6
	dc.w	$C624
	dc.b	$A, $B, $C, $D, $E, $F, $10, $2A, $2B, $2C, $2D, $2E, $2F, $30, $4A, $4B
	dc.b	$4C, $4D, $4E, $4F, $50, $6A, $6B, $6C, $6D, $6E, $6F, $70, $8A, $8B, $8C, $8D
	dc.b	$8E, $8F, $90, $AA, $AB, $AC, $AD, $AE, $AF, $B0, $CA, $CB, $CC, $CD, $CE, $CF
	dc.b	$D0, 0
word_1BDB8
	dc.w	2
	dc.w	2
	dc.w	$C7A6
	dc.b	$6B, $6C, $6D, $8B, $8C, $8D, $AB, $AC, $AD, 0
word_1BDC8
	dc.w	2
	dc.w	2
	dc.w	$C7A6
	dc.b	$D1, $D2, $D3, $F1, $F2, $F3, $F4, $F5, $F6, 0
off_1BDD8
	dc.l	word_1B59A
	dc.l	word_1B5E6
	dc.l	word_1BE1C
	dc.l	word_1BE32
	dc.l	word_1BE48
	dc.l	word_1BE5E
	dc.l	word_1BE68
	dc.l	word_1BE72
	dc.l	word_1BE7C
	dc.l	word_1BE86
	dc.l	word_1BE90
	dc.l	word_1BE9A
	dc.l	word_1BEB0
	dc.l	word_1BEC6
	dc.l	word_1BEDC
	dc.l	word_1BEE6
	dc.l	word_1BEF0
word_1BE1C
	dc.w	4
	dc.w	2
	dc.w	$C6A2
	dc.b	$22, $23, $24, $25, $26, $42, $43, $44, $45, $46, $62, $63, $64, $65, $66, 0
word_1BE32
	dc.w	4
	dc.w	2
	dc.w	$C6A2
	dc.b	$22, $23, $24, $25, $26, $A, $B, $C, $D, $E, $2A, $2B, $2C, $2D, $2E, 0
word_1BE48
	dc.w	4
	dc.w	2
	dc.w	$C6A2
	dc.b	$22, $23, $24, $25, $26, $4A, $4B, $4C, $4D, $4E, $6A, $6B, $6C, $6D, $6E, 0
word_1BE5E
	dc.w	1
	dc.w	1
	dc.w	$C824
	dc.b	$83, $84, $A3, $A4
word_1BE68
	dc.w	1
	dc.w	1
	dc.w	$C824
	dc.b	$F, $10, $A3, $A4
word_1BE72
	dc.w	1
	dc.w	1
	dc.w	$C824
	dc.b	$2F, $30, $A3, $A4
word_1BE7C
	dc.w	1
	dc.w	1
	dc.w	$C824
	dc.b	$8A, $8B, $A3, $A4
word_1BE86
	dc.w	1
	dc.w	1
	dc.w	$C824
	dc.b	$AA, $AB, $A3, $A4
word_1BE90
	dc.w	1
	dc.w	1
	dc.w	$C824
	dc.b	$CA, $CB, $A3, $A4
word_1BE9A
	dc.w	4
	dc.w	2
	dc.w	$C6A2
	dc.b	$11, $12, $13, $14, $15, $31, $32, $33, $34, $35, $51, $52, $53, $54, $55, 0
word_1BEB0
	dc.w	4
	dc.w	2
	dc.w	$C6A2
	dc.b	$71, $72, $73, $74, $75, $91, $92, $93, $94, $95, $B1, $B2, $B3, $B4, $B5, 0
word_1BEC6
	dc.w	4
	dc.w	2
	dc.w	$C6A2
	dc.b	$71, $72, $73, $74, $75, $D1, $D2, $D3, $D4, $D5, $6A, $6B, $6C, $6D, $6E, 0
word_1BEDC
	dc.w	1
	dc.w	1
	dc.w	$C824
	dc.b	$8C, $8D, $A3, $A4
word_1BEE6
	dc.w	1
	dc.w	1
	dc.w	$C824
	dc.b	$AC, $AD, $A3, $A4
word_1BEF0
	dc.w	1
	dc.w	1
	dc.w	$C824
	dc.b	$CC, $CD, $EC, $ED
off_1BEFA
	dc.l	word_1B59A
	dc.l	word_1B5E6
	dc.l	word_1BF22
	dc.l	word_1BF5E
	dc.l	word_1BF9A
	dc.l	word_1BFB8
	dc.l	word_1C018
	dc.l	word_1BFD6
	dc.l	word_1BFEC
	dc.l	word_1C002
word_1BF22
	dc.w	8
	dc.w	5
	dc.w	$C6A0
	dc.b	$21, $22, $23, $24, $25, $26, $27, $28, $29, $41, $42, $43, $44, $45, $46, $47
	dc.b	$48, $49, $61, $62, $63, $64, $65, $66, $67, $68, $69, $81, $82, $83, $84, $85
	dc.b	$86, $87, $88, $89, $A1, $A2, $A3, $A4, $A5, $A6, $A7, $A8, $A9, $C1, $C2, $C3
	dc.b	$C4, $C5, $C6, $C7, $C8, $C9
word_1BF5E
	dc.w	8
	dc.w	5
	dc.w	$C6A0
	dc.b	$10, $11, $12, $24, $25, $26, $27, $28, $29, $30, $31, $32, $44, $45, $46, $47
	dc.b	$48, $49, $50, $51, $63, $64, $65, $66, $13, $14, $15, $70, $71, $83, $84, $85
	dc.b	$86, $33, $34, $35, $A1, $A2, $A3, $A4, $A5, $52, $53, $54, $55, $C1, $C2, $C3
	dc.b	$C4, $C5, $72, $73, $74, $75
word_1BF9A
	dc.w	5
	dc.w	3
	dc.w	$C6A2
	dc.b	$22, $E0, $E1, $25, $26, $27, $A, $B, $C, $D, $E, $F, $2A, $2B, $2C, $2D
	dc.b	$2E, $2F, $82, $83, $84, $4D, $4E, $4F
word_1BFB8
	dc.w	5
	dc.w	3
	dc.w	$C6A2
	dc.b	$4A, $4B, $4C, $25, $26, $27, $6A, $6B, $6C, $6D, $6E, $6F, $8A, $8B, $8C, $8D
	dc.b	$8E, $8F, $AA, $AB, $AC, $AD, $AE, $AF
word_1BFD6
	dc.w	3
	dc.w	3
	dc.w	$C724
	dc.b	$90, $91, $92, $93, $CA, $CB, $CC, $CD, $EA, $EB, $EC, $ED, $F0, $F1, $F2, $F3
word_1BFEC
	dc.w	3
	dc.w	3
	dc.w	$C724
	dc.b	$5B, $5C, $5D, $5E, $7B, $7C, $7D, $7E, $9B, $9C, $9D, $9E, $BB, $BC, $BD, $BE
word_1C002
	dc.w	3
	dc.w	3
	dc.w	$C724
	dc.b	$90, $91, $92, $93, $B0, $B1, $B2, $B3, $D0, $D1, $D2, $D3, $F0, $F1, $F2, $F3
word_1C018
	dc.w	9
	dc.w	6
	dc.w	$C61E
	dc.b	$16, $17, $18, $19, $1A, $1B, $1C, $1D, $1E, $1F, $36, $37, $38, $39, $3A, $3B
	dc.b	$3C, $3D, $3E, $3F, $56, $37, $37, $57, $58, $59, $5A, $37, $37, $5F, $76, $37
	dc.b	$37, $77, $78, $79, $7A, $37, $37, $7F, $96, $37, $37, $97, $98, $99, $9A, $37
	dc.b	$37, $9F, $B6, $37, $37, $B7, $B8, $B9, $BA, $37, $37, $BF, $D6, $D7, $D8, $D9
	dc.b	$DA, $DB, $DC, $DD, $DE, $DF
off_1C064
	dc.l	word_1B59A
	dc.l	word_1B5E6
	dc.l	word_1C0A8
	dc.l	word_1C0C0
	dc.l	word_1C0D8
	dc.l	word_1C0F0
	dc.l	word_1C0F8
	dc.l	word_1C100
	dc.l	word_1C108
	dc.l	word_1C11A
	dc.l	word_1C12C
	dc.l	word_1C13E
	dc.l	word_1C146
	dc.l	word_1C14E
	dc.l	word_1C156
	dc.l	word_1C15E
	dc.l	word_1C166
word_1C0A8
	dc.w	5
	dc.w	2
	dc.w	$C6A2
	dc.b	$22, $23, $24, $25, $26, $27, $42, $43, $44, $45, $46, $47, $62, $63, $64, $65
	dc.b	$66, $67
word_1C0C0
	dc.w	5
	dc.w	2
	dc.w	$C6A2
	dc.b	$A, $B, $C, $D, $E, $F, $2A, $2B, $2C, $2D, $2E, $2F, $4A, $4B, $4C, $4D
	dc.b	$4E, $4F
word_1C0D8
	dc.w	5
	dc.w	2
	dc.w	$C6A2
	dc.b	$6A, $6B, $6C, $6D, $6E, $6F, $8A, $8B, $8C, $8D, $8E, $8F, $AA, $AB, $AC, $AD
	dc.b	$AE, $AF
word_1C0F0
	dc.w	1
	dc.w	0
	dc.w	$C826
	dc.b	$84, $85
word_1C0F8
	dc.w	1
	dc.w	0
	dc.w	$C826
	dc.b	$CA, $CB
word_1C100
	dc.w	1
	dc.w	0
	dc.w	$C826
	dc.b	$EA, $EB
word_1C108
	dc.w	5
	dc.w	1
	dc.w	$C722
	dc.b	$10, $11, $12, $13, $14, $15, $30, $31, $32, $33, $34, $35
word_1C11A
	dc.w	5
	dc.w	1
	dc.w	$C722
	dc.b	$50, $51, $52, $53, $54, $55, $70, $71, $72, $73, $74, $75
word_1C12C
	dc.w	5
	dc.w	1
	dc.w	$C722
	dc.b	$90, $91, $92, $93, $94, $95, $AA, $AB, $AC, $AD, $AE, $AF
word_1C13E
	dc.w	1
	dc.w	0
	dc.w	$C826
	dc.b	$B0, $B1
word_1C146
	dc.w	1
	dc.w	0
	dc.w	$C826
	dc.b	$D0, $D1
word_1C14E
	dc.w	1
	dc.w	0
	dc.w	$C826
	dc.b	$F0, $F1
word_1C156
	dc.w	1
	dc.w	0
	dc.w	$C826
	dc.b	$B2, $B3
word_1C15E
	dc.w	1
	dc.w	0
	dc.w	$C826
	dc.b	$D2, $D3
word_1C166
	dc.w	1
	dc.w	0
	dc.w	$C826
	dc.b	$F2, $F3
off_1C16E
	dc.l	word_1B59A
	dc.l	word_1B5E6
	dc.l	word_1C18E
	dc.l	word_1C1A6
	dc.l	word_1C1BE
	dc.l	word_1C1D6
	dc.l	word_1C1F8
	dc.l	word_1C210
word_1C18E
	dc.w	5
	dc.w	2
	dc.w	$C7A0
	dc.b	$61, $62, $63, $64, $65, $66, $81, $82, $83, $84, $85, $86, $A1, $A2, $A3, $A4
	dc.b	$A5, $A6
word_1C1A6
	dc.w	5
	dc.w	2
	dc.w	$C7A0
	dc.b	$A, $B, $C, $D, $E, $F, $2A, $2B, $2C, $2D, $2E, $2F, $4A, $4B, $4C, $4D
	dc.b	$4E, $4F
word_1C1BE
	dc.w	5
	dc.w	2
	dc.w	$C7A0
	dc.b	$A, $B, $C, $D, $E, $F, $6A, $6B, $6C, $6D, $6E, $6F, $8A, $8B, $8C, $8D
	dc.b	$8E, $8F
word_1C1D6
	dc.w	6
	dc.w	3
	dc.w	$C7A0
	dc.b	$10, $11, $12, $13, $14, $15, $90, $30, $31, $32, $33, $34, $35, $B0, $50, $51
	dc.b	$52, $53, $54, $55, $D0, $70, $71, $72, $73, $74, $75, $F0
word_1C1F8
	dc.w	5
	dc.w	2
	dc.w	$C7A0
	dc.b	$AA, $AB, $AC, $AD, $AE, $AF, $CA, $CB, $CC, $CD, $CE, $CF, $EA, $EB, $EC, $ED
	dc.b	$EE, $EF
word_1C210
	dc.w	5
	dc.w	2
	dc.w	$C7A0
	dc.b	$AA, $AB, $AC, $AD, $AE, $AF, $6A, $6B, $6C, $6D, $6E, $6F, $8A, $8B, $8C, $8D
	dc.b	$8E, $8F
off_1C228
	dc.l	word_1B59A
	dc.l	word_1B5E6
	dc.l	word_1C260
	dc.l	word_1C272
	dc.l	word_1C284
	dc.l	word_1C296
	dc.l	word_1C2A2
	dc.l	word_1C2AE
	dc.l	word_1C2BA
	dc.l	word_1C2C6
	dc.l	word_1C2D2
	dc.l	word_1C2DE
	dc.l	word_1C2F0
	dc.l	word_1C302
word_1C260
	dc.w	5
	dc.w	1
	dc.w	$C724
	dc.b	$43, $44, $45, $46, $47, $48, $63, $64, $65, $66, $67, $68
word_1C272
	dc.w	5
	dc.w	1
	dc.w	$C724
	dc.b	$A, $B, $C, $D, $E, $F, $2A, $2B, $2C, $2D, $2E, $2F
word_1C284
	dc.w	5
	dc.w	1
	dc.w	$C724
	dc.b	$4A, $4B, $4C, $4D, $4E, $4F, $6A, $6B, $6C, $6D, $6E, $6F
word_1C296
	dc.w	2
	dc.w	1
	dc.w	$C826
	dc.b	$84, $85, $86, $A4, $A5, $A6
word_1C2A2
	dc.w	2
	dc.w	1
	dc.w	$C826
	dc.b	$10, $11, $12, $30, $31, $32
word_1C2AE
	dc.w	2
	dc.w	1
	dc.w	$C826
	dc.b	$50, $51, $52, $70, $71, $72
word_1C2BA
	dc.w	2
	dc.w	1
	dc.w	$C826
	dc.b	$13, $14, $15, $33, $34, $35
word_1C2C6
	dc.w	2
	dc.w	1
	dc.w	$C826
	dc.b	$53, $54, $55, $73, $74, $75
word_1C2D2
	dc.w	2
	dc.w	1
	dc.w	$C826
	dc.b	$93, $94, $95, $B3, $B4, $B5
word_1C2DE
	dc.w	5
	dc.w	1
	dc.w	$C724
	dc.b	$8A, $8B, $8C, $8D, $8E, $8F, $AA, $AB, $AC, $AD, $AE, $AF
word_1C2F0
	dc.w	5
	dc.w	1
	dc.w	$C724
	dc.b	$CA, $CB, $CC, $CD, $CE, $CF, $2A, $2B, $2C, $2D, $2E, $2F
word_1C302
	dc.w	5
	dc.w	1
	dc.w	$C724
	dc.b	$EA, $EB, $EC, $ED, $EE, $EF, $6A, $6B, $6C, $6D, $6E, $6F
off_1C314
	dc.l	word_1B59A
	dc.l	word_1B5E6
	dc.l	word_1C340
	dc.l	word_1C35E
	dc.l	word_1C37C
	dc.l	word_1C39A
	dc.l	word_1C3C4
	dc.l	word_1C3EE
	dc.l	word_1C418
	dc.l	word_1C44E
	dc.l	word_1C484
word_1C340
	dc.w	5
	dc.w	3
	dc.w	$C6A2
	dc.b	$22, $23, $24, $25, $26, $27, $42, $43, $44, $45, $46, $47, $62, $63, $64, $65
	dc.b	$66, $67, $82, $83, $84, $85, $86, $87
word_1C35E
	dc.w	5
	dc.w	3
	dc.w	$C6A2
	dc.b	$22, $23, $24, $C, $D, $E, $42, $43, $44, $2C, $2D, $2E, $A, $B, $64, $4C
	dc.b	$4D, $4E, $2A, $2B, $84, $85, $86, $87
word_1C37C
	dc.w	5
	dc.w	3
	dc.w	$C6A2
	dc.b	$22, $23, $24, $6C, $6D, $6E, $42, $43, $44, $8C, $8D, $8E, $4A, $4B, $64, $AC
	dc.b	$AD, $AE, $6A, $6B, $84, $85, $86, $87
word_1C39A
	dc.w	6
	dc.w	4
	dc.w	$C71E
	dc.b	$40, $41, $42, $43, $44, $45, $46, $60, $61, $62, $63, $64, $65, $66, $80, $81
	dc.b	$82, $83, $84, $85, $86, $A0, $A1, $A2, $A3, $A4, $A5, $A6, $C0, $C1, $C2, $C3
	dc.b	$C4, $C5, $C6, 0
word_1C3C4
	dc.w	6
	dc.w	4
	dc.w	$C71E
	dc.b	$40, $41, $42, $43, $44, $45, $46, $F, $10, $11, $12, $13, $14, $15, $2F, $30
	dc.b	$31, $32, $33, $34, $35, $4F, $50, $51, $52, $53, $54, $55, $6F, $70, $71, $72
	dc.b	$73, $74, $75, 0
word_1C3EE
	dc.w	6
	dc.w	4
	dc.w	$C71E
	dc.b	$8F, $90, $91, $92, $93, $94, $95, $AF, $B0, $B1, $B2, $B3, $B4, $B5, $CF, $D0
	dc.b	$D1, $D2, $D3, $D4, $D5, $EF, $F0, $F1, $F2, $F3, $F4, $F5, $F6, $F7, $F8, $F9
	dc.b	$FA, $FB, $FC, 0
word_1C418
	dc.w	7
	dc.w	5
	dc.w	$C69E
	dc.b	$20, $21, $22, $23, $24, $6C, $6D, $6E, $40, $41, $42, $43, $8A, $8B, $8D, $8E
	dc.b	$60, $61, $62, $63, $AA, $AB, $AD, $AE, $80, $81, $82, $83, $84, $85, $86, $87
	dc.b	$A0, $A1, $A2, $A3, $A4, $A5, $A6, $A7, $C0, $C1, $C2, $C3, $C4, $C5, $C6, $C7
word_1C44E
	dc.w	7
	dc.w	5
	dc.w	$C69E
	dc.b	$20, $21, $22, $23, $24, $6C, $6D, $6E, $40, $41, $42, $43, $8A, $8B, $8D, $8E
	dc.b	$F, $10, $11, $12, $AA, $AB, $AD, $AE, $2F, $30, $31, $32, $33, $34, $35, $87
	dc.b	$4F, $50, $51, $52, $53, $54, $55, $A7, $6F, $70, $71, $72, $73, $74, $75, $C7
word_1C484
	dc.w	7
	dc.w	5
	dc.w	$C69E
	dc.b	$20, $21, $22, $23, $24, $6C, $6D, $6E, $8F, $90, $91, $92, $8A, $8B, $8D, $8E
	dc.b	$AF, $B0, $B1, $B2, $AA, $AB, $AD, $AE, $CF, $D0, $D1, $D2, $D3, $D4, $D5, $87
	dc.b	$EF, $F0, $F1, $F2, $F3, $F4, $F5, $A7, $F6, $F7, $F8, $F9, $FA, $FB, $FC, $C7
off_1C4BA
	dc.l	word_1B59A
	dc.l	word_1B5E6
	dc.l	word_1C50E
	dc.l	word_1C524
	dc.l	word_1C53A
	dc.l	word_1C550
	dc.l	word_1C566
	dc.l	word_1C57C
	dc.l	word_1C592
	dc.l	word_1C5A8
	dc.l	word_1C5BE
	dc.l	word_1C5D4
	dc.l	word_1C5DE
	dc.l	word_1C5E8
	dc.l	word_1C5F2
	dc.l	word_1C5FC
	dc.l	word_1C606
	dc.l	word_1C610
	dc.l	word_1C61A
	dc.l	word_1C624
	dc.l	word_1C62E
word_1C50E
	dc.w	4
	dc.w	2
	dc.w	$C6A2
	dc.b	$22, $23, $24, $25, $26, $42, $43, $44, $45, $46, $62, $63, $64, $65, $66, 0
word_1C524
	dc.w	4
	dc.w	2
	dc.w	$C6A2
	dc.b	$A, $B, $C, $D, $E, $2A, $2B, $2C, $2D, $2E, $4A, $4B, $4C, $65, $66, 0
word_1C53A
	dc.w	4
	dc.w	2
	dc.w	$C6A2
	dc.b	$A, $B, $C, $D, $E, $6A, $6B, $6C, $6D, $6E, $8A, $8B, $8C, $65, $66, 0
word_1C550
	dc.w	4
	dc.w	2
	dc.w	$C6A2
	dc.b	$F, $10, $11, $12, $13, $2F, $30, $31, $32, $33, $4F, $50, $51, $14, $15, 0
word_1C566
	dc.w	4
	dc.w	2
	dc.w	$C6A2
	dc.b	$6F, $70, $71, $72, $73, $8F, $90, $91, $92, $93, $AF, $B0, $B1, $14, $15, 0
word_1C57C
	dc.w	4
	dc.w	2
	dc.w	$C6A2
	dc.b	$6F, $70, $71, $72, $73, $CF, $D0, $D1, $D2, $D3, $EF, $F0, $F1, $14, $15, 0
word_1C592
	dc.w	4
	dc.w	2
	dc.w	$C6A2
	dc.b	$F, $10, $11, $12, $13, $2F, $30, $31, $32, $33, $4F, $50, $51, $D4, $D5, 0
word_1C5A8
	dc.w	4
	dc.w	2
	dc.w	$C6A2
	dc.b	$6F, $70, $71, $72, $73, $8F, $90, $91, $92, $93, $AF, $B0, $B1, $D4, $D5, 0
word_1C5BE
	dc.w	4
	dc.w	2
	dc.w	$C6A2
	dc.b	$6F, $70, $71, $72, $73, $CF, $D0, $D1, $D2, $D3, $EF, $F0, $F1, $D4, $D5, 0
word_1C5D4
	dc.w	1
	dc.w	1
	dc.w	$C7A8
	dc.b	$65, $66, $85, $86
word_1C5DE
	dc.w	1
	dc.w	1
	dc.w	$C7A8
	dc.b	$AA, $AB, $CA, $CB
word_1C5E8
	dc.w	1
	dc.w	1
	dc.w	$C7A8
	dc.b	$AC, $AD, $CC, $CD
word_1C5F2
	dc.w	1
	dc.w	1
	dc.w	$C7A8
	dc.b	$14, $15, $34, $35
word_1C5FC
	dc.w	1
	dc.w	1
	dc.w	$C7A8
	dc.b	$54, $55, $74, $75
word_1C606
	dc.w	1
	dc.w	1
	dc.w	$C7A8
	dc.b	$94, $95, $B4, $B5
word_1C610
	dc.w	1
	dc.w	1
	dc.w	$C7A8
	dc.b	$D4, $D5, $F4, $F5
word_1C61A
	dc.w	2
	dc.w	0
	dc.w	$C7A6
	dc.b	$7A, $7B, $7C, 0
word_1C624
	dc.w	2
	dc.w	0
	dc.w	$C7A6
	dc.b	$E0, $E1, $E2, 0
word_1C62E
	dc.w	2
	dc.w	0
	dc.w	$C7A6
	dc.b	$E3, $E4, $E5, 0
off_1C638
	dc.l	word_1B59A
	dc.l	word_1B5E6
	dc.l	word_1C660
	dc.l	word_1C66C
	dc.l	word_1C678
	dc.l	word_1C684
	dc.l	word_1C690
	dc.l	word_1C6AA
	dc.l	word_1C6E6
	dc.l	word_1C6FC
word_1C660
	dc.w	1
	dc.w	2
	dc.w	$C6AC
	dc.b	$27, $28, $47, $48, $67, $68
word_1C66C
	dc.w	1
	dc.w	2
	dc.w	$C6AC
	dc.b	$A, $B, $2A, $2B, $4A, $4B
word_1C678
	dc.w	1
	dc.w	2
	dc.w	$C6AC
	dc.b	$C, $D, $2C, $2D, $4C, $4D
word_1C684
	dc.w	1
	dc.w	2
	dc.w	$C6AC
	dc.b	$E, $F, $2E, $2F, $4E, $4F
word_1C690
	dc.w	4
	dc.w	3
	dc.w	$C7A8
	dc.b	$6A, $6B, $6C, $6D, $6E, $8A, $8B, $8C, $8D, $8E, $AA, $AB, $AC, $AD, $AE, $CA
	dc.b	$CB, $CC, $CD, $CE
word_1C6AA
	dc.w	8
	dc.w	5
	dc.w	$C620
	dc.b	1, 2, 3, 4, 5, 6, 7, $13, $14, $21, $22, $23, $24, $25, $26, $27
	dc.b	$33, $34, $41, $42, $43, $44, $45, $46, $47, $53, $54, $61, $62, $63, $64, $65
	dc.b	$66, $67, $68, $69, $10, $11, $12, $84, $85, $86, $87, $88, $89, $30, $31, $32
	dc.b	$A4, $A5, $A6, $A7, $A8, $A9
word_1C6E6
	dc.w	3
	dc.w	3
	dc.w	$C72A
	dc.b	$46, $2E, $2F, $49, $66, $4E, $4F, $69, $86, $87, $88, $89, $A6, $A7, $A8, $A9
word_1C6FC
	dc.w	3
	dc.w	3
	dc.w	$C72A
	dc.b	$46, $2E, $71, $72, $66, $4E, $91, $92, $AF, $B0, $B1, $B2, $CF, $D0, $D1, $D2
off_1C712
	dc.l	word_1B59A
	dc.l	word_1B5E6
	dc.l	word_1C756
	dc.l	word_1C76E
	dc.l	word_1C786
	dc.l	word_1C79E
	dc.l	word_1C7B6
	dc.l	word_1C7CE
	dc.l	word_1C7E6
	dc.l	word_1C7F0
	dc.l	word_1C7FA
	dc.l	word_1C804
	dc.l	word_1C80E
	dc.l	word_1C818
	dc.l	word_1C822
	dc.l	word_1C82E
	dc.l	word_1C83A
word_1C756
	dc.w	5
	dc.w	2
	dc.w	$C6A2
	dc.b	$22, $23, $24, $25, $26, $27, $42, $43, $44, $45, $46, $47, $62, $63, $64, $65
	dc.b	$66, $67
word_1C76E
	dc.w	5
	dc.w	2
	dc.w	$C6A2
	dc.b	$A, $B, $C, $D, $E, $F, $2A, $2B, $2C, $2D, $2E, $2F, $4A, $4B, $4C, $4D
	dc.b	$4E, $4F
word_1C786
	dc.w	5
	dc.w	2
	dc.w	$C6A2
	dc.b	$A, $B, $C, $D, $E, $F, $6A, $6B, $6C, $6D, $6E, $6F, $8A, $8B, $8C, $8D
	dc.b	$8E, $8F
word_1C79E
	dc.w	5
	dc.w	2
	dc.w	$C6A2
	dc.b	$10, $11, $12, $13, $14, $15, $30, $31, $32, $33, $34, $35, $50, $51, $52, $53
	dc.b	$54, $55
word_1C7B6
	dc.w	5
	dc.w	2
	dc.w	$C6A2
	dc.b	$10, $11, $12, $13, $14, $15, $70, $71, $72, $73, $74, $75, $4A, $4B, $4C, $4D
	dc.b	$4E, $4F
word_1C7CE
	dc.w	5
	dc.w	2
	dc.w	$C6A2
	dc.b	$10, $11, $12, $13, $14, $15, $90, $91, $92, $93, $94, $95, $8A, $8B, $8C, $8D
	dc.b	$8E, $8F
word_1C7E6
	dc.w	1
	dc.w	1
	dc.w	$C7A4
	dc.b	$63, $64, $83, $84
word_1C7F0
	dc.w	1
	dc.w	1
	dc.w	$C7A4
	dc.b	$63, $64, $AA, $AB
word_1C7FA
	dc.w	1
	dc.w	1
	dc.w	$C7A4
	dc.b	$CA, $CB, $EA, $EB
word_1C804
	dc.w	1
	dc.w	1
	dc.w	$C7A4
	dc.b	$51, $52, $AC, $AD
word_1C80E
	dc.w	1
	dc.w	1
	dc.w	$C7A4
	dc.b	$51, $52, $AE, $AF
word_1C818
	dc.w	1
	dc.w	1
	dc.w	$C7A4
	dc.b	$CE, $CF, $EE, $EF
word_1C822
	dc.w	2
	dc.w	1
	dc.w	$C7A4
	dc.b	$51, $52, $53, $CC, $CD, $85
word_1C82E
	dc.w	2
	dc.w	1
	dc.w	$C7A4
	dc.b	$51, $52, $53, $B0, $B1, $B2
word_1C83A
	dc.w	2
	dc.w	1
	dc.w	$C7A4
	dc.b	$D0, $D1, $D2, $F0, $F1, $F2
off_1C846
	dc.l	word_1B59A
	dc.l	word_1B5E6
	dc.l	word_1C88A
	dc.l	word_1C89C
	dc.l	word_1C8AE
	dc.l	word_1C8C0
	dc.l	word_1C8CC
	dc.l	word_1C8D8
	dc.l	word_1C8E4
	dc.l	word_1C8F0
	dc.l	word_1C8FC
	dc.l	word_1C908
	dc.l	word_1C914
	dc.l	word_1C920
	dc.l	word_1C92C
	dc.l	word_1C93C
	dc.l	word_1C94C
word_1C88A
	dc.w	5
	dc.w	1
	dc.w	$C722
	dc.b	$42, $43, $44, $45, $46, $47, $62, $63, $64, $65, $66, $67
word_1C89C
	dc.w	5
	dc.w	1
	dc.w	$C722
	dc.b	$A, $B, $C, $D, $E, $F, $2A, $2B, $2C, $2D, $2E, $2F
word_1C8AE
	dc.w	5
	dc.w	1
	dc.w	$C722
	dc.b	$4A, $4B, $4C, $4D, $4E, $4F, $6A, $6B, $6C, $6D, $6E, $6F
word_1C8C0
	dc.w	2
	dc.w	1
	dc.w	$C824
	dc.b	$83, $84, $85, $A3, $A4, $A5
word_1C8CC
	dc.w	2
	dc.w	1
	dc.w	$C824
	dc.b	$8A, $8B, $8C, $AA, $AB, $AC
word_1C8D8
	dc.w	2
	dc.w	1
	dc.w	$C824
	dc.b	$8D, $8E, $8F, $AD, $AE, $AF
word_1C8E4
	dc.w	2
	dc.w	1
	dc.w	$C824
	dc.b	$10, $11, $12, $30, $31, $32
word_1C8F0
	dc.w	2
	dc.w	1
	dc.w	$C824
	dc.b	$50, $51, $52, $70, $71, $72
word_1C8FC
	dc.w	2
	dc.w	1
	dc.w	$C824
	dc.b	$90, $91, $92, $B0, $B1, $B2
word_1C908
	dc.w	2
	dc.w	1
	dc.w	$C824
	dc.b	$13, $14, $15, $33, $34, $35
word_1C914
	dc.w	2
	dc.w	1
	dc.w	$C824
	dc.b	$53, $54, $55, $73, $74, $75
word_1C920
	dc.w	2
	dc.w	1
	dc.w	$C824
	dc.b	$93, $94, $95, $B3, $B4, $B5
word_1C92C
	dc.w	4
	dc.w	1
	dc.w	$C7A4
	dc.b	$79, $7A, $7B, $7C, $7D, $99, $9A, $9B, $9C, $9D
word_1C93C
	dc.w	4
	dc.w	1
	dc.w	$C7A4
	dc.b	$CA, $CB, $CC, $CD, $CE, $EA, $EB, $EC, $ED, $EE
word_1C94C
	dc.w	4
	dc.w	1
	dc.w	$C7A4
	dc.b	$CF, $D0, $D1, $D2, $D3, $EF, $F0, $F1, $F2, $F3
PlaneCmdLists:
	dc.l	word_1D3BE
	dc.l	word_1D54A
	dc.l	word_1D630
	dc.l	PlameCmds_StageBG
	dc.l	word_1D190
	dc.l	PlameCmds_LateStageBG
	dc.l	word_1D052
	dc.l	word_1D010
	dc.l	word_1D002
	dc.l	word_1CFA8
	dc.l	word_1CF04
	dc.l	word_1CF96
	dc.l	word_1CAD4
	dc.l	word_1CB16
	dc.l	word_1CB58
	dc.l	word_1CB9A
	dc.l	word_1CBDC
	dc.l	word_1CBFE
	dc.l	word_1CC20
	dc.l	word_1CCDE
	dc.l	word_1D02A
	dc.l	0
	dc.l	word_1D190
	dc.l	word_1D14E
	dc.l	0
	dc.l	0
	dc.l	0
	dc.l	0
	dc.l	0
	dc.l	0
	dc.l	word_1D044
	dc.l	word_1CCEC
	dc.l	word_1CE8C
	dc.l	word_1CE8C
	dc.l	word_1CE8C
	dc.l	word_1CE62
	dc.l	word_1CA36
	dc.l	word_1CA24
	dc.l	0
	dc.l	0
	dc.l	0
	dc.l	0
	dc.l	word_1CDF6
	dc.l	word_1CE54
	dc.l	word_1D34E
	dc.l	word_1D358
	dc.l	word_1D37A
	dc.l	word_1D39C
	dc.l	word_1D540
	dc.l	word_1D630
word_1CA24
	dc.w	1
	dc.l	word_1CA2A
word_1CA2A
	dc.w	$14
	dc.b	$28
	dc.b	$B
	dc.w	$D200
	dc.l	byte_6F158
	dc.w	$2000
word_1CA36
	dc.w	2
	dc.l	word_1CA40
	dc.l	word_1CA4C
word_1CA40
	dc.w	4
	dc.b	$A
	dc.b	7
	dc.w	$D688
	dc.l	byte_1CA58
	dc.w	$8100
word_1CA4C
	dc.w	4
	dc.b	$12
	dc.b	3
	dc.w	$D722
	dc.l	byte_1CA9E
	dc.w	$8100
byte_1CA58
	dc.b	0, 0, 0, 0, 0, 0, 0, 0, $E, $F, 0, 0, 0, 0, 0, 0
	dc.b	0, $18, $19, $1A, 0, 0, 0, 0, 0, 0, 0, $25, $26, $27, 0, 0
	dc.b	0, 0, 0, 0, 0, $33, $34, $27, 0, 0, 0, 0, 0, 0, $43, $44
	dc.b	$45, $27, 0, 0, 0, 0, 0, $55, $56, $57, $58, $59, 0, 0, 0, 0
	dc.b	0, $6C, $6D, $6E, $6F, $70
byte_1CA9E
	dc.b	$1E, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, $1F
	dc.b	$20, $21, $2A, $2B, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
	dc.b	$2C, $2D, $2E, $2F, $38, $39, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
	dc.b	0, $3A, $3B, $3C, $3D, $17
word_1CAD4
	dc.w	4
	dc.l	word_1CAE6
	dc.l	word_1CAF2
	dc.l	word_1CAFE
	dc.l	word_1CB0A
word_1CAE6
	dc.w	$14
	dc.b	$18
	dc.b	3
	dc.w	$C912
	dc.l	byte_22172
	dc.w	$E190
word_1CAF2
	dc.w	$14
	dc.b	$18
	dc.b	3
	dc.w	$CC12
	dc.l	byte_22202
	dc.w	$8190
word_1CAFE
	dc.w	$14
	dc.b	$19
	dc.b	3
	dc.w	$CF10
	dc.l	byte_22292
	dc.w	$8190
word_1CB0A
	dc.w	$14
	dc.b	$E
	dc.b	3
	dc.w	$D210
	dc.l	byte_22328
	dc.w	$8190
word_1CB16
	dc.w	4
	dc.l	word_1CB28
	dc.l	word_1CB34
	dc.l	word_1CB40
	dc.l	word_1CB4C
word_1CB28
	dc.w	$14
	dc.b	$18
	dc.b	3
	dc.w	$C912
	dc.l	byte_22172
	dc.w	$8190
word_1CB34
	dc.w	$14
	dc.b	$18
	dc.b	3
	dc.w	$CC12
	dc.l	byte_22202
	dc.w	$E190
word_1CB40
	dc.w	$14
	dc.b	$19
	dc.b	3
	dc.w	$CF10
	dc.l	byte_22292
	dc.w	$8190
word_1CB4C
	dc.w	$14
	dc.b	$E
	dc.b	3
	dc.w	$D210
	dc.l	byte_22328
	dc.w	$8190
word_1CB58
	dc.w	4
	dc.l	word_1CB6A
	dc.l	word_1CB76
	dc.l	word_1CB82
	dc.l	word_1CB8E
word_1CB6A
	dc.w	$14
	dc.b	$18
	dc.b	3
	dc.w	$C912
	dc.l	byte_22172
	dc.w	$8190
word_1CB76
	dc.w	$14
	dc.b	$18
	dc.b	3
	dc.w	$CC12
	dc.l	byte_22202
	dc.w	$8190
word_1CB82
	dc.w	$14
	dc.b	$19
	dc.b	3
	dc.w	$CF10
	dc.l	byte_22292
	dc.w	$E190
word_1CB8E
	dc.w	$14
	dc.b	$E
	dc.b	3
	dc.w	$D210
	dc.l	byte_22328
	dc.w	$8190
word_1CB9A
	dc.w	4
	dc.l	word_1CBAC
	dc.l	word_1CBB8
	dc.l	word_1CBC4
	dc.l	word_1CBD0
word_1CBAC
	dc.w	$14
	dc.b	$18
	dc.b	3
	dc.w	$C912
	dc.l	byte_22172
	dc.w	$8190
word_1CBB8
	dc.w	$14
	dc.b	$18
	dc.b	3
	dc.w	$CC12
	dc.l	byte_22202
	dc.w	$8190
word_1CBC4
	dc.w	$14
	dc.b	$19
	dc.b	3
	dc.w	$CF10
	dc.l	byte_22292
	dc.w	$8190
word_1CBD0
	dc.w	$14
	dc.b	$E
	dc.b	3
	dc.w	$D210
	dc.l	byte_22328
	dc.w	$E190
word_1CBDC
	dc.w	2
	dc.l	word_1CBE6
	dc.l	word_1CBF2
word_1CBE6
	dc.w	$14
	dc.b	$A
	dc.b	3
	dc.w	$CA6C
	dc.l	byte_2237C
	dc.w	$E190
word_1CBF2
	dc.w	$14
	dc.b	$10
	dc.b	3
	dc.w	$CD6A
	dc.l	byte_223B8
	dc.w	$8190
word_1CBFE
	dc.w	2
	dc.l	word_1CC08
	dc.l	word_1CC14
word_1CC08
	dc.w	$14
	dc.b	$A
	dc.b	3
	dc.w	$CA6C
	dc.l	byte_2237C
	dc.w	$8190
word_1CC14
	dc.w	$14
	dc.b	$10
	dc.b	3
	dc.w	$CD6A
	dc.l	byte_223B8
	dc.w	$E190
word_1CC20
	dc.w	1
	dc.l	word_1CC26
word_1CC26
	dc.w	$14
	dc.b	$2B
	dc.b	2
	dc.w	$EC00
	dc.l	byte_1CC32
	dc.w	$E2A0
byte_1CC32
	dc.b	2, $A6, 2, $A7, 2, $A8, $A, $A8, 0, 0, 2, $A9, 2, $AA, 2, $A8
	dc.b	$A, $A8, 2, $AB, 2, $AB, 0, 0, 2, $AC, $A, $AC, 2, $AD, $A, $AD
	dc.b	2, $AE, 2, $AF, 2, $B0, 2, $B1, 0, 0, 2, $B0, 2, $B1, 2, $A8
	dc.b	$A, $A8, 0, 0, 2, $A8, 2, $B2, 2, $A8, $A, $A8, 2, $AE, 2, $AF
	dc.b	2, $B0, 2, $B1, 2, $B3, 2, $AE, 2, $AF, 2, $AB, 2, $AB, 2, $B4
	dc.b	2, $B5, 2, $B6, 2, $B7, $12, $A6, $12, $A7, $12, $A8, $1A, $A8, 0, 0
	dc.b	2, $B8, 2, $B9, $12, $A8, $1A, $A8, 2, $BA, $A, $BA, 0, 0, 2, $BB
	dc.b	$A, $BB, 2, $BC, $A, $BC, 2, $BD, 2, $BE, 2, $B8, 2, $B9, 0, 0
	dc.b	2, $B8, 2, $B9, $12, $A8, $1A, $A8, 0, 0, $12, $A8, $12, $B2, $12, $A8
	dc.b	$1A, $A8, 2, $BD, 2, $BE, 2, $B8, 2, $B9, $12, $B3, 2, $BD, 2, $BE
	dc.b	2, $BA, $A, $BA, $12, $B4, $12, $B5, 2, $BF, 2, $C0
word_1CCDE
	dc.w	1
	dc.l	word_1CCE4
word_1CCE4
	dc.w	0
	dc.b	$40
	dc.b	$F
	dc.w	$E000
	dc.w	$23EC
word_1CCEC
	dc.w	$11
	dc.l	word_1CD32
	dc.l	word_1CD3A
	dc.l	word_1CD46
	dc.l	word_1CD52
	dc.l	word_1CD5A
	dc.l	word_1CD66
	dc.l	word_1CD72
	dc.l	word_1CD7E
	dc.l	word_1CD8A
	dc.l	word_1CD96
	dc.l	word_1CDA2
	dc.l	word_1CDAE
	dc.l	word_1CDBA
	dc.l	word_1CDC6
	dc.l	word_1CDD2
	dc.l	word_1CDDE
	dc.l	word_1CDEA
word_1CD32
	dc.w	0
	dc.b	$50
	dc.b	$1C
	dc.w	$C000
	dc.w	$8000
word_1CD3A
	dc.w	4
	dc.b	$20
	dc.b	$E
	dc.w	$EE00
	dc.l	byte_1DF5A
	dc.w	$100
word_1CD46
	dc.w	4
	dc.b	8
	dc.b	$E
	dc.w	$EE40
	dc.l	byte_1E15A
	dc.w	$100
word_1CD52
	dc.w	0
	dc.b	$80
	dc.b	$E
	dc.w	$E000
	dc.w	$295
word_1CD5A
	dc.w	4
	dc.b	$B
	dc.b	5
	dc.w	$E004
	dc.l	byte_1E3D6
	dc.w	$200
word_1CD66
	dc.w	4
	dc.b	$C
	dc.b	4
	dc.w	$E438
	dc.l	byte_1E40E
	dc.w	$200
word_1CD72
	dc.w	4
	dc.b	$B
	dc.b	5
	dc.w	$E934
	dc.l	byte_1E3D6
	dc.w	$200
word_1CD7E
	dc.w	4
	dc.b	$C
	dc.b	4
	dc.w	$E904
	dc.l	byte_1E40E
	dc.w	$200
word_1CD8A
	dc.w	4
	dc.b	$B
	dc.b	5
	dc.w	$E352
	dc.l	byte_1E3D6
	dc.w	$200
word_1CD96
	dc.w	4
	dc.b	$C
	dc.b	4
	dc.w	$E988
	dc.l	byte_1E40E
	dc.w	$200
word_1CDA2
	dc.w	4
	dc.b	$B
	dc.b	5
	dc.w	$E970
	dc.l	byte_1E3D6
	dc.w	$200
word_1CDAE
	dc.w	4
	dc.b	$C
	dc.b	4
	dc.w	$E568
	dc.l	byte_1E40E
	dc.w	$200
word_1CDBA
	dc.w	4
	dc.b	$B
	dc.b	5
	dc.w	$E2A4
	dc.l	byte_1E3D6
	dc.w	$200
word_1CDC6
	dc.w	4
	dc.b	$C
	dc.b	4
	dc.w	$EAC8
	dc.l	byte_1E40E
	dc.w	$200
word_1CDD2
	dc.w	4
	dc.b	$B
	dc.b	5
	dc.w	$E8AC
	dc.l	byte_1E3D6
	dc.w	$200
word_1CDDE
	dc.w	4
	dc.b	$C
	dc.b	4
	dc.w	$E4BC
	dc.l	byte_1E40E
	dc.w	$200
word_1CDEA
	dc.w	4
	dc.b	$1E
	dc.b	$16
	dc.w	$C30A
	dc.l	byte_21EDE
	dc.w	$E000
word_1CDF6
	dc.w	7
	dc.l	word_1CE14
	dc.l	word_1CE1C
	dc.l	word_1CE24
	dc.l	word_1CE2C
	dc.l	word_1CE38
	dc.l	word_1CE44
	dc.l	word_1CE4C
word_1CE14
	dc.w	0
	dc.b	$17
	dc.b	$19
	dc.w	$C11E
	dc.w	$8000
word_1CE1C
	dc.w	0
	dc.b	$16
	dc.b	$11
	dc.w	$E120
	dc.w	$63FD
word_1CE24
	dc.w	0
	dc.b	$15
	dc.b	$10
	dc.w	$E1A2
	dc.w	$63FC
word_1CE2C
	dc.w	4
	dc.b	1
	dc.b	$11
	dc.w	$E11E
	dc.l	byte_21E14
	dc.w	$4000
word_1CE38
	dc.w	4
	dc.b	$17
	dc.b	8
	dc.w	$E99E
	dc.l	byte_21E26
	dc.w	$4000
word_1CE44
	dc.w	0
	dc.b	$E
	dc.b	6
	dc.w	$EA20
	dc.w	$63FD
word_1CE4C
	dc.w	0
	dc.b	$D
	dc.b	5
	dc.w	$EAA2
	dc.w	$63FC
word_1CE54
	dc.w	1
	dc.l	word_1CE5A
word_1CE5A
	dc.w	0
	dc.b	$16
	dc.b	$11
	dc.w	$C120
	dc.w	$8000
word_1CE62
	dc.w	3
	dc.l	word_1CE70
	dc.l	word_1CE78
	dc.l	word_1CE80
word_1CE70
	dc.w	0
	dc.b	$40
	dc.b	$1C
	dc.w	$C000
	dc.w	$8000
word_1CE78
	dc.w	0
	dc.b	$40
	dc.b	$1C
	dc.w	$E000
	dc.w	0
word_1CE80
	dc.w	4
	dc.b	$C
	dc.b	4
	dc.w	$C61C
	dc.l	byte_21DE4
	dc.w	$8000
word_1CE8C
	dc.w	8
	dc.l	word_1CEAE
	dc.l	word_1CEB6
	dc.l	word_1CEC0
	dc.l	word_1CECA
	dc.l	word_1CED4
	dc.l	word_1CEE0
	dc.l	word_1CEEC
	dc.l	word_1CEF8
word_1CEAE
	dc.w	0
	dc.b	$80
	dc.b	$20
	dc.w	$C000
	dc.w	$500
word_1CEB6
	dc.w	8
	dc.b	$28
	dc.b	4
	dc.w	$E000
	dc.l	byte_2006C
word_1CEC0
	dc.w	8
	dc.b	$28
	dc.b	$C
	dc.w	$E400
	dc.l	byte_1FDEC
word_1CECA
	dc.w	8
	dc.b	$28
	dc.b	$C
	dc.w	$F000
	dc.l	byte_1FDEC
word_1CED4
	dc.w	4
	dc.b	8
	dc.b	7
	dc.w	$C608
	dc.l	byte_201AC
	dc.w	$E300
word_1CEE0
	dc.w	4
	dc.b	8
	dc.b	7
	dc.w	$C618
	dc.l	byte_201E4
	dc.w	$E300
word_1CEEC
	dc.w	4
	dc.b	8
	dc.b	7
	dc.w	$C628
	dc.l	byte_2021C
	dc.w	$E300
word_1CEF8
	dc.w	4
	dc.b	8
	dc.b	7
	dc.w	$C638
	dc.l	byte_20254
	dc.w	$E300
word_1CF04
	dc.w	$A
	dc.l	word_1CF2E
	dc.l	word_1CF36
	dc.l	word_1CF3E
	dc.l	word_1CF46
	dc.l	word_1CF52
	dc.l	word_1CF5E
	dc.l	word_1CF6A
	dc.l	word_1CF72
	dc.l	word_1CF7E
	dc.l	word_1CF8A
word_1CF2E
	dc.w	0
	dc.b	$40
	dc.b	$1C
	dc.w	$C000
	dc.w	$80FF
word_1CF36
	dc.w	0
	dc.b	$20
	dc.b	3
	dc.w	$C708
	dc.w	$8000
word_1CF3E
	dc.w	0
	dc.b	$40
	dc.b	$1C
	dc.w	$E000
	dc.w	0
word_1CF46
	dc.w	4
	dc.b	$20
	dc.b	7
	dc.w	$C888
	dc.l	byte_1FA8C
	dc.w	$8100
word_1CF52
	dc.w	4
	dc.b	$20
	dc.b	9
	dc.w	$C208
	dc.l	byte_1F8EC
	dc.w	$8000
word_1CF5E
	dc.w	4
	dc.b	$20
	dc.b	1
	dc.w	$C688
	dc.l	byte_1F8CC
	dc.w	$8000
word_1CF6A
	dc.w	0
	dc.b	$40
	dc.b	9
	dc.w	$E200
	dc.w	$F
word_1CF72
	dc.w	4
	dc.b	$20
	dc.b	4
	dc.w	$E680
	dc.l	byte_1F84C
	dc.w	0
word_1CF7E
	dc.w	4
	dc.b	$20
	dc.b	4
	dc.w	$E6C0
	dc.l	byte_1F84C
	dc.w	0
word_1CF8A
	dc.w	4
	dc.b	$20
	dc.b	4
	dc.w	$E688
	dc.l	byte_1F84C
	dc.w	0
word_1CF96
	dc.w	1
	dc.l	word_1CF9C
word_1CF9C
	dc.w	4
	dc.b	$20
	dc.b	$14
	dc.w	$C208
	dc.l	byte_1FB6C
	dc.w	$8100
word_1CFA8
	dc.w	6
	dc.l	word_1CFC2
	dc.l	word_1CFCA
	dc.l	word_1CFD2
	dc.l	word_1CFDE
	dc.l	word_1CFEA
	dc.l	word_1CFF6
word_1CFC2
	dc.w	0
	dc.b	$80
	dc.b	$1C
	dc.w	$C000
	dc.w	0
word_1CFCA
	dc.w	0
	dc.b	$80
	dc.b	$1C
	dc.w	$E000
	dc.w	0
word_1CFD2
	dc.w	4
	dc.b	$18
	dc.b	$10
	dc.w	$C820
	dc.l	byte_1F66C
	dc.w	$2200
word_1CFDE
	dc.w	4
	dc.b	$18
	dc.b	4
	dc.w	$D820
	dc.l	byte_1F7EC
	dc.w	$2300
word_1CFEA
	dc.w	4
	dc.b	$20
	dc.b	$D
	dc.w	$E408
	dc.l	byte_1F8EC
	dc.w	0
word_1CFF6
	dc.w	4
	dc.b	$20
	dc.b	7
	dc.w	$F108
	dc.l	byte_1FA8C
	dc.w	$100
word_1D002
	dc.w	1
	dc.l	word_1D008
word_1D008
	dc.w	0
	dc.b	$80
	dc.b	$1C
	dc.w	$C000
	dc.w	$8500
word_1D010
	dc.w	2
	dc.l	word_1D01A
	dc.l	word_1D022
word_1D01A
	dc.w	0
	dc.b	$80
	dc.b	$1C
	dc.w	$C000
	dc.w	$8500
word_1D022
	dc.w	0
	dc.b	$80
	dc.b	$1C
	dc.w	$E000
	dc.w	$500
word_1D02A
	dc.w	2
	dc.l	word_1D034
	dc.l	word_1D03C
word_1D034
	dc.w	0
	dc.b	$80
	dc.b	$1C
	dc.w	$C000
	dc.w	$8000
word_1D03C
	dc.w	0
	dc.b	$80
	dc.b	$1C
	dc.w	$E000
	dc.w	0
word_1D044
	dc.w	1
	dc.l	word_1D04A
word_1D04A
	dc.w	0
	dc.b	$38
	dc.b	$1C
	dc.w	$C000
	dc.w	0
word_1D052
	dc.w	7
	dc.l	word_1D078
	dc.l	word_1D088
	dc.l	word_1D094
	dc.l	word_1D0A0
	dc.l	word_1D0AC
	dc.l	word_1D080
	dc.l	word_1D070
word_1D070
	dc.w	0
	dc.b	$40
	dc.b	$1C
	dc.w	$C000
	dc.w	$1F8
word_1D078
	dc.w	0
	dc.b	$28
	dc.b	4
	dc.w	$E400
	dc.w	1
word_1D080
	dc.w	0
	dc.b	$28
	dc.b	2
	dc.w	$ED00
	dc.w	$101
word_1D088
	dc.w	4
	dc.b	$20
	dc.b	$C
	dc.w	$E400
	dc.l	byte_1EF40
	dc.w	0
word_1D094
	dc.w	4
	dc.b	8
	dc.b	8
	dc.w	$E640
	dc.l	byte_1F0C0
	dc.w	0
word_1D0A0
	dc.w	4
	dc.b	$20
	dc.b	6
	dc.w	$EA00
	dc.l	byte_1F100
	dc.w	$100
word_1D0AC
	dc.w	4
	dc.b	8
	dc.b	6
	dc.w	$EA40
	dc.l	byte_1F1C0
	dc.w	$100
word_1D0B8
	dc.w	0
	dc.b	$28
	dc.b	4
	dc.w	$CE00
	dc.w	$8000
word_1D0C0
	dc.w	0
	dc.b	$28
	dc.b	4
	dc.w	$EE00
	dc.w	$8000
PlameCmds_StageBG:
	dc.w	9
	dc.l	.TopLeftFG
	dc.l	.TopRightFG
	dc.l	.BottomLeftFG
	dc.l	.BottomRightFG
	dc.l	.TopLeftBG
	dc.l	.TopRightBG
	dc.l	.BottomLeftBG
	dc.l	.BottomRightBG
	dc.l	word_1D0B8
.TopLeftFG:
	dc.w	4
	dc.b	$20
	dc.b	$E
	dc.w	$C000
	dc.l	byte_1D69A
	dc.w	$C000
.TopRightFG
	dc.w	4
	dc.b	8
	dc.b	$E
	dc.w	$C040
	dc.l	byte_1D85A
	dc.w	$C000
.BottomLeftFG
	dc.w	4
	dc.b	$20
	dc.b	$E
	dc.w	$C700
	dc.l	byte_1D8CA
	dc.w	$C000
.BottomRightFG
	dc.w	4
	dc.b	8
	dc.b	$E
	dc.w	$C740
	dc.l	byte_1DA8A
	dc.w	$C000
.TopLeftBG
	dc.w	4
	dc.b	$20
	dc.b	$E
	dc.w	$E000
	dc.l	byte_1DAFA
	dc.w	$4000
.TopRightBG
	dc.w	4
	dc.b	8
	dc.b	$E
	dc.w	$E040
	dc.l	byte_1DCBA
	dc.w	$4000
.BottomLeftBG
	dc.w	4
	dc.b	$20
	dc.b	$E
	dc.w	$E700
	dc.l	byte_1DD2A
	dc.w	$4000
.BottomRightBG
	dc.w	4
	dc.b	8
	dc.b	$E
	dc.w	$E740
	dc.l	byte_1DEEA
	dc.w	$4000
word_1D14E
	dc.w	4
	dc.l	word_1D160
	dc.l	word_1D16C
	dc.l	word_1D178
	dc.l	word_1D184
word_1D160
	dc.w	4
	dc.b	$20
	dc.b	$E
	dc.w	$C000
	dc.l	byte_1D69A
	dc.w	$C000
word_1D16C
	dc.w	4
	dc.b	8
	dc.b	$E
	dc.w	$C040
	dc.l	byte_1D85A
	dc.w	$C000
word_1D178
	dc.w	4
	dc.b	$20
	dc.b	$C
	dc.w	$C700
	dc.l	byte_1D8CA
	dc.w	$C000
word_1D184
	dc.w	4
	dc.b	8
	dc.b	$C
	dc.w	$C740
	dc.l	byte_1DA8A
	dc.w	$C000
word_1D190
	dc.w	$C
	dc.l	word_1D1C2
	dc.l	word_1D1CE
	dc.l	word_1D1DA
	dc.l	word_1D1E6
	dc.l	word_1D1F2
	dc.l	word_1D1FE
	dc.l	word_1D20A
	dc.l	word_1D216
	dc.l	word_1D222
	dc.l	word_1D22E
	dc.l	word_1D0B8
	dc.l	word_1D0C0
word_1D1C2
	dc.w	4
	dc.b	$20
	dc.b	$E
	dc.w	$C000
	dc.l	byte_1D69A
	dc.w	$C000
word_1D1CE
	dc.w	4
	dc.b	8
	dc.b	$E
	dc.w	$C040
	dc.l	byte_1D85A
	dc.w	$C000
word_1D1DA
	dc.w	4
	dc.b	$20
	dc.b	$E
	dc.w	$C700
	dc.l	byte_1D8CA
	dc.w	$C000
word_1D1E6
	dc.w	4
	dc.b	8
	dc.b	$E
	dc.w	$C740
	dc.l	byte_1DA8A
	dc.w	$C000
word_1D1F2
	dc.w	4
	dc.b	$20
	dc.b	$E
	dc.w	$E000
	dc.l	byte_1DAFA
	dc.w	$4000
word_1D1FE
	dc.w	4
	dc.b	8
	dc.b	$E
	dc.w	$E040
	dc.l	byte_1DCBA
	dc.w	$4000
word_1D20A
	dc.w	4
	dc.b	$20
	dc.b	$E
	dc.w	$E700
	dc.l	byte_1DD2A
	dc.w	$4000
word_1D216
	dc.w	4
	dc.b	8
	dc.b	$E
	dc.w	$E740
	dc.l	byte_1DEEA
	dc.w	$4000
word_1D222
	dc.w	4
	dc.b	$20
	dc.b	2
	dc.w	$E000
	dc.l	byte_1D69A
	dc.w	$4000
word_1D22E
	dc.w	4
	dc.b	8
	dc.b	2
	dc.w	$E040
	dc.l	byte_1D85A
	dc.w	$4000
PlameCmds_LateStageBG
	dc.w	6
	dc.l	word_1D254
	dc.l	word_1D260
	dc.l	word_1D26C
	dc.l	word_1D278
	dc.l	word_1D0B8
	dc.l	word_1D0C0
word_1D254
	dc.w	4
	dc.b	$20
	dc.b	$1C
	dc.w	$C000
	dc.l	byte_20B4C
	dc.w	$C000
word_1D260
	dc.w	4
	dc.b	8
	dc.b	$1C
	dc.w	$C040
	dc.l	byte_20ECC
	dc.w	$C000
word_1D26C
	dc.w	4
	dc.b	$20
	dc.b	$1C
	dc.w	$E000
	dc.l	byte_20FAC
	dc.w	$4000
word_1D278
	dc.w	4
	dc.b	8
	dc.b	$1C
	dc.w	$E040
	dc.l	byte_2132C
	dc.w	$4000

PlaneCmds_LessonModeBG:
	dc.w	$B
	dc.l	word_1D2BE
	dc.l	word_1D2CE
	dc.l	word_1D2DE
	dc.l	word_1D2EE
	dc.l	word_1D2FE
	dc.l	word_1D30A
	dc.l	word_1D316
	dc.l	word_1D322
	dc.l	word_1D32E
	dc.l	word_1D33E
	dc.l	word_1D2B6
	dc.l	word_1D0B8
word_1D2B6
	dc.w	0
	dc.b	$28
	dc.b	4
	dc.w	$D01C
	dc.w	$8000
word_1D2BE
	dc.w	$10
	dc.b	$20
	dc.b	$E
	dc.w	$C000
	dc.l	byte_2140C
	dc.l	byte_215CC
	dc.w	$8000
word_1D2CE
	dc.w	$10
	dc.b	8
	dc.b	$E
	dc.w	$C040
	dc.l	byte_2163C
	dc.l	byte_216AC
	dc.w	$8000
word_1D2DE
	dc.w	$10
	dc.b	$20
	dc.b	$E
	dc.w	$C700
	dc.l	byte_216C8
	dc.l	byte_21888
	dc.w	$8000
word_1D2EE
	dc.w	$10
	dc.b	8
	dc.b	$E
	dc.w	$C740
	dc.l	byte_218F8
	dc.l	byte_21968
	dc.w	$8000
word_1D2FE
	dc.w	4
	dc.b	$20
	dc.b	$E
	dc.w	$E000
	dc.l	byte_21984
	dc.w	$4000
word_1D30A
	dc.w	4
	dc.b	8
	dc.b	$E
	dc.w	$E040
	dc.l	byte_21B44
	dc.w	$4000
word_1D316
	dc.w	4
	dc.b	$20
	dc.b	$E
	dc.w	$E700
	dc.l	byte_21BB4
	dc.w	$4000
word_1D322
	dc.w	4
	dc.b	8
	dc.b	$E
	dc.w	$E740
	dc.l	byte_21D74
	dc.w	$4000
word_1D32E
	dc.w	$10
	dc.b	$20
	dc.b	2
	dc.w	$E000
	dc.l	byte_2140C
	dc.l	byte_215CC
	dc.w	0
word_1D33E
	dc.w	$10
	dc.b	8
	dc.b	2
	dc.w	$E040
	dc.l	byte_2163C
	dc.l	byte_216AC
	dc.w	0
word_1D34E
	dc.w	2
	dc.l	word_1D428
	dc.l	word_1D434
word_1D358
	dc.w	8
	dc.l	word_1D428
	dc.l	word_1D434
	dc.l	word_1D440
	dc.l	word_1D44C
	dc.l	word_1D458
	dc.l	word_1D462
	dc.l	word_1D46C
	dc.l	word_1D478
word_1D37A
	dc.w	8
	dc.l	word_1D484
	dc.l	word_1D48C
	dc.l	word_1D498
	dc.l	word_1D4A4
	dc.l	word_1D4B0
	dc.l	word_1D4BC
	dc.l	word_1D4C8
	dc.l	word_1D4D4
word_1D39C
	dc.w	8
	dc.l	word_1D4E0
	dc.l	word_1D4EC
	dc.l	word_1D4F8
	dc.l	word_1D504
	dc.l	word_1D510
	dc.l	word_1D51C
	dc.l	word_1D528
	dc.l	word_1D534
word_1D3BE
	dc.w	2
	dc.l	word_1D484
	dc.l	word_1D420
	dc.l	word_1D440
	dc.l	word_1D44C
	dc.l	word_1D458
	dc.l	word_1D462
	dc.l	word_1D46C
	dc.l	word_1D478
	dc.l	word_1D484
	dc.l	word_1D48C
	dc.l	word_1D498
	dc.l	word_1D4A4
	dc.l	word_1D4B0
	dc.l	word_1D4BC
	dc.l	word_1D4C8
	dc.l	word_1D4D4
	dc.l	word_1D4E0
	dc.l	word_1D4EC
	dc.l	word_1D4F8
	dc.l	word_1D504
	dc.l	word_1D510
	dc.l	word_1D51C
	dc.l	word_1D528
	dc.l	word_1D534
word_1D420
	dc.w	0
	dc.b	$40
	dc.b	$40
	dc.w	$C000
	dc.w	$2200
word_1D428
	dc.w	4
	dc.b	$20
	dc.b	$10
	dc.w	$D200
	dc.l	byte_1DF5A
	dc.w	$2100
word_1D434
	dc.w	4
	dc.b	8
	dc.b	$10
	dc.w	$D240
	dc.l	byte_1E15A
	dc.w	$2100
word_1D440
	dc.w	4
	dc.b	$20
	dc.b	9
	dc.w	$DA00
	dc.l	byte_1E1DA
	dc.w	$6200
word_1D44C
	dc.w	4
	dc.b	8
	dc.b	9
	dc.w	$DA40
	dc.l	byte_1E2FA
	dc.w	$6200
word_1D458
	dc.w	8
	dc.b	2
	dc.b	3
	dc.w	$DD00
	dc.l	byte_1E342
word_1D462
	dc.w	8
	dc.b	2
	dc.b	4
	dc.w	$DCCC
	dc.l	byte_1E34E
word_1D46C
	dc.w	4
	dc.b	$20
	dc.b	3
	dc.w	$DE80
	dc.l	byte_1E35E
	dc.w	$E100
word_1D478
	dc.w	4
	dc.b	8
	dc.b	3
	dc.w	$DEC0
	dc.l	byte_1E3BE
	dc.w	$E100
word_1D484
	dc.w	0
	dc.b	$40
	dc.b	$40
	dc.w	$E000
	dc.w	$2200
word_1D48C
	dc.w	4
	dc.b	$B
	dc.b	5
	dc.w	$F480
	dc.l	byte_1E3D6
	dc.w	$2200
word_1D498
	dc.w	4
	dc.b	$B
	dc.b	5
	dc.w	$F518
	dc.l	byte_1E3D6
	dc.w	$2200
word_1D4A4
	dc.w	4
	dc.b	$B
	dc.b	5
	dc.w	$F534
	dc.l	byte_1E3D6
	dc.w	$2200
word_1D4B0
	dc.w	4
	dc.b	$B
	dc.b	5
	dc.w	$F4D2
	dc.l	byte_1E3D6
	dc.w	$2200
word_1D4BC
	dc.w	4
	dc.b	$B
	dc.b	5
	dc.w	$F568
	dc.l	byte_1E3D6
	dc.w	$2200
word_1D4C8
	dc.w	4
	dc.b	$B
	dc.b	5
	dc.w	$F780
	dc.l	byte_1E3D6
	dc.w	$2200
word_1D4D4
	dc.w	4
	dc.b	$B
	dc.b	5
	dc.w	$F79C
	dc.l	byte_1E3D6
	dc.w	$2200
word_1D4E0
	dc.w	4
	dc.b	$B
	dc.b	5
	dc.w	$F832
	dc.l	byte_1E3D6
	dc.w	$2200
word_1D4EC
	dc.w	4
	dc.b	$B
	dc.b	5
	dc.w	$F7CC
	dc.l	byte_1E3D6
	dc.w	$2200
word_1D4F8
	dc.w	4
	dc.b	$B
	dc.b	5
	dc.w	$F864
	dc.l	byte_1E3D6
	dc.w	$2200
word_1D504
	dc.w	4
	dc.b	$C
	dc.b	4
	dc.w	$FB04
	dc.l	byte_1E40E
	dc.w	$2200
word_1D510
	dc.w	4
	dc.b	$C
	dc.b	4
	dc.w	$FAA4
	dc.l	byte_1E40E
	dc.w	$2200
word_1D51C
	dc.w	4
	dc.b	$C
	dc.b	4
	dc.w	$FABE
	dc.l	byte_1E40E
	dc.w	$2200
word_1D528
	dc.w	4
	dc.b	$C
	dc.b	4
	dc.w	$FB5C
	dc.l	byte_1E40E
	dc.w	$2200
word_1D534
	dc.w	4
	dc.b	3
	dc.b	2
	dc.w	$FC78
	dc.l	byte_1E43E
	dc.w	$2200
word_1D540
	dc.w	2
	dc.l	word_1D5A4
	dc.l	word_1D5B0
word_1D54A
	dc.w	$C
	dc.l	word_1D58C
	dc.l	word_1D598
	dc.l	word_1D5A4
	dc.l	word_1D5B0
	dc.l	word_1D5BC
	dc.l	word_1D5C8
	dc.l	word_1D5D4
	dc.l	word_1D5DC
	dc.l	word_1D5E6
	dc.l	word_1D5F2
	dc.l	word_1D57C
	dc.l	word_1D584
word_1D57C
	dc.w	0
	dc.b	$28
	dc.b	4
	dc.w	$C000
	dc.w	$A100
word_1D584
	dc.w	0
	dc.b	$28
	dc.b	8
	dc.w	$E000
	dc.w	$2100
word_1D58C
	dc.w	4
	dc.b	$20
	dc.b	8
	dc.w	$DC10
	dc.l	byte_1E444
	dc.w	$A100
word_1D598
	dc.w	4
	dc.b	8
	dc.b	8
	dc.w	$DC00
	dc.l	byte_1E544
	dc.w	$A100
word_1D5A4
	dc.w	4
	dc.b	$15
	dc.b	$14
	dc.w	$D226
	dc.l	byte_1E584
	dc.w	$A100
word_1D5B0
	dc.w	4
	dc.b	$13
	dc.b	$14
	dc.w	$D200
	dc.l	byte_1E728
	dc.w	$A200
word_1D5BC
	dc.w	4
	dc.b	$20
	dc.b	$C
	dc.w	$F600
	dc.l	byte_1E8A4
	dc.w	$6200
word_1D5C8
	dc.w	4
	dc.b	8
	dc.b	$C
	dc.w	$F640
	dc.l	byte_1EA24
	dc.w	$6200
word_1D5D4
	dc.w	0
	dc.b	$28
	dc.b	8
	dc.w	$FC00
	dc.w	$62BC
word_1D5DC
	dc.w	8
	dc.b	$A
	dc.b	3
	dc.w	$FABC
	dc.l	byte_1EA84
word_1D5E6
	dc.w	4
	dc.b	3
	dc.b	6
	dc.w	$D6A6
	dc.l	byte_1D5FE
	dc.w	$2100
word_1D5F2
	dc.w	4
	dc.b	4
	dc.b	8
	dc.w	$D59C
	dc.l	byte_1D610
	dc.w	$2200
byte_1D5FE
	dc.b	$46, $47, 0, $6A, $6B, 0, $94, $64, 0, $97, $5D, 0, $82, $64, $9B, $A1
	dc.b	$6B, $A2
byte_1D610
	dc.b	0, $20, 0, 0, 0, $27, 0, 0, 0, $2B, 0, $20, 0, $2C, 0, $27
	dc.b	0, $2D, 0, $2D, 0, $2D, 0, $2C, 0, $33, 0, $2D, $38, $39, 0, $2C
word_1D630
	dc.w	7
	dc.l	word_1D64E
	dc.l	word_1D656
	dc.l	word_1D662
	dc.l	word_1D66E
	dc.l	word_1D67A
	dc.l	word_1D686
	dc.l	word_1D692
word_1D64E
	dc.w	0
	dc.b	$40
	dc.b	$E
	dc.w	$D200
	dc.w	$A200
word_1D656
	dc.w	4
	dc.b	$20
	dc.b	$F
	dc.w	$D890
	dc.l	byte_1EAC0
	dc.w	$A100
word_1D662
	dc.w	4
	dc.b	8
	dc.b	$E
	dc.w	$D900
	dc.l	byte_1ECA0
	dc.w	$A100
word_1D66E
	dc.w	4
	dc.b	$20
	dc.b	$E
	dc.w	$F640
	dc.l	byte_1ED10
	dc.w	$2200
word_1D67A
	dc.w	4
	dc.b	$20
	dc.b	$E
	dc.w	$F610
	dc.l	byte_1ED10
	dc.w	$2200
word_1D686
	dc.w	4
	dc.b	8
	dc.b	$E
	dc.w	$F600
	dc.l	byte_1EED0
	dc.w	$2200
word_1D692
	dc.w	0
	dc.b	$40
	dc.b	6
	dc.w	$FD00
	dc.w	$22AE
byte_1D69A
	dc.b	1, 2, 3, 4, 5, 6, 7, 8, 1, 2, 3, 4, 5, 6, 7, 8
	dc.b	1, 2, 3, 4, 5, 6, 7, 8, 1, 2, 3, 4, 5, 6, 7, 8
	dc.b	$11, $12, $13, $14, $15, $16, $17, $18, $11, $12, $13, $14, $15, $16, $17, $18
	dc.b	$11, $12, $13, $14, $15, $16, $17, $18, $11, $12, $13, $14, $15, $16, $17, $18
	dc.b	$22, $23, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, $28, $29
	dc.b	$22, $23, $24, $25, $26, $27, $28, $29, $22, $23, 0, 0, 0, 0, 0, 0
	dc.b	$34, $35, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, $3A, $3B
	dc.b	$34, $35, $36, $37, $38, $39, $3A, $3B, $34, $35, 0, 0, 0, 0, 0, 0
	dc.b	$46, $47, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, $4C, 0
	dc.b	0, 0, 0, $49, $4A, 0, 0, 0, 0, $47, 0, 0, 0, 0, 0, 0
	dc.b	$58, $59, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, $5E, 0
	dc.b	0, 0, 0, $5B, $5C, 0, 0, 0, 0, $59, 0, 0, 0, 0, 0, 0
	dc.b	$6A, $6B, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, $70, 0
	dc.b	0, 0, 0, $6D, $6E, 0, 0, 0, 0, $6B, 0, 0, 0, 0, 0, 0
	dc.b	$7C, $7D, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, $82, 0
	dc.b	0, 0, 0, $7F, $80, 0, 0, 0, 0, $7D, 0, 0, 0, 0, 0, 0
	dc.b	$8E, $8F, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, $94, 0
	dc.b	0, 0, 0, $91, $92, 0, 0, 0, 0, $8F, 0, 0, 0, 0, 0, 0
	dc.b	$A0, $A1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, $A6, 0
	dc.b	0, 0, 0, $A3, $A4, 0, 0, 0, 0, $A1, 0, 0, 0, 0, 0, 0
	dc.b	$11, $12, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, $17, $18
	dc.b	$11, $12, $13, $14, $15, $16, $17, $18, $11, $12, 0, 0, 0, 0, 0, 0
	dc.b	$22, $23, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, $28, $29
	dc.b	$22, $23, $24, $25, $26, $27, $28, $29, $22, $23, 0, 0, 0, 0, 0, 0
	dc.b	$34, $35, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, $3A, 0
	dc.b	0, 0, 0, 0, 0, 0, 0, 0, 0, $35, 0, 0, 0, 0, 0, 0
	dc.b	$46, $47, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, $4C, 0
	dc.b	0, 0, 0, 0, 0, 0, 0, 0, 0, $47, 0, 0, 0, 0, 0, 0
byte_1D85A
	dc.b	1, 2, 3, 4, 5, 6, 7, 8, $11, $12, $13, $14, $15, $16, $17, $18
	dc.b	0, 0, 0, 0, 0, 0, $28, $29, 0, 0, 0, 0, 0, 0, $3A, $3B
	dc.b	0, 0, 0, 0, 0, 0, $4C, $4D, 0, 0, 0, 0, 0, 0, $5E, $5F
	dc.b	0, 0, 0, 0, 0, 0, $70, $71, 0, 0, 0, 0, 0, 0, $82, $83
	dc.b	0, 0, 0, 0, 0, 0, $94, $95, 0, 0, 0, 0, 0, 0, $A6, $A7
	dc.b	0, 0, 0, 0, 0, 0, $17, $18, 0, 0, 0, 0, 0, 0, $28, $29
	dc.b	0, 0, 0, 0, 0, 0, $3A, $3B, 0, 0, 0, 0, 0, 0, $4C, $4D
byte_1D8CA
	dc.b	$58, $59, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, $5E, 0
	dc.b	0, 0, 0, 0, 0, 0, 0, 0, 0, $59, 0, 0, 0, 0, 0, 0
	dc.b	$6A, $6B, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, $70, 0
	dc.b	0, 0, 0, 0, 0, 0, 0, 0, 0, $6B, 0, 0, 0, 0, 0, 0
	dc.b	$7C, $7D, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, $82, 0
	dc.b	0, 0, 0, 0, 0, 0, 0, 0, 0, $7D, 0, 0, 0, 0, 0, 0
	dc.b	$8E, $8F, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, $94, 0
	dc.b	0, 0, 0, 0, 0, 0, 0, 0, 0, $8F, 0, 0, 0, 0, 0, 0
	dc.b	$A0, $A1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, $A6, 0
	dc.b	0, 0, 0, 0, 0, 0, 0, 0, 0, $A1, 0, 0, 0, 0, 0, 0
	dc.b	$11, $12, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, $17, $18
	dc.b	$11, $12, $13, $14, $15, $16, $17, $18, $11, $12, 0, 0, 0, 0, 0, 0
	dc.b	$22, $23, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, $28, $29
	dc.b	$22, $23, $24, $25, $26, $27, $28, $29, $22, $23, 0, 0, 0, 0, 0, 0
	dc.b	$34, $35, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, $3A, $3B
	dc.b	$34, $35, $36, $37, $38, $39, $3A, $3B, $34, $35, 0, 0, 0, 0, 0, 0
	dc.b	$46, $47, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, $4C, $4D
	dc.b	$46, $47, $48, $49, $4A, $4B, $4C, $4D, $46, $47, 0, 0, 0, 0, 0, 0
	dc.b	$58, $59, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, $5E, $5F
	dc.b	$58, $59, $5A, $5B, $5C, $5D, $5E, $5F, $58, $59, 0, 0, 0, 0, 0, 0
	dc.b	$6A, $6B, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, $70, $71
	dc.b	$6A, $6B, $6C, $6D, $6E, $6F, $70, $71, $6A, $6B, 0, 0, 0, 0, 0, 0
	dc.b	$7C, $7D, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, $82, $83
	dc.b	$7C, $7D, $7E, $7F, $80, $81, $82, $83, $7C, $7D, 0, 0, 0, 0, 0, 0
	dc.b	$8E, $8F, $90, $91, $92, $93, $94, $95, $8E, $8F, $90, $91, $92, $93, $94, $95
	dc.b	$8E, $8F, $90, $91, $92, $93, $94, $95, $8E, $8F, $90, $91, $92, $93, $94, $95
	dc.b	$A0, $A1, $A2, $A3, $A4, $A5, $A6, $A7, $A0, $A1, $A2, $A3, $A4, $A5, $A6, $A7
	dc.b	$A0, $A1, $A2, $A3, $A4, $A5, $A6, $A7, $A0, $A1, $A2, $A3, $A4, $A5, $A6, $A7
byte_1DA8A
	dc.b	0, 0, 0, 0, 0, 0, $5E, $5F, 0, 0, 0, 0, 0, 0, $70, $71
	dc.b	0, 0, 0, 0, 0, 0, $82, $83, 0, 0, 0, 0, 0, 0, $94, $95
	dc.b	0, 0, 0, 0, 0, 0, $A6, $A7, 0, 0, 0, 0, 0, 0, $17, $18
	dc.b	0, 0, 0, 0, 0, 0, $28, $29, 0, 0, 0, 0, 0, 0, $3A, $3B
	dc.b	0, 0, 0, 0, 0, 0, $4C, $4D, 0, 0, 0, 0, 0, 0, $5E, $5F
	dc.b	0, 0, 0, 0, 0, 0, $70, $71, 0, 0, 0, 0, 0, 0, $82, $83
	dc.b	$8E, $8F, $90, $91, $92, $93, $94, $95, $A0, $A1, $A2, $A3, $A4, $A5, $A6, $A7
byte_1DAFA
	dc.b	1, 2, 3, 4, 5, 6, 7, 8, 1, 2, 3, 4, 5, 6, 7, 8
	dc.b	1, 2, 3, 4, 5, 6, 7, 8, 1, 2, 3, 4, 5, 6, 7, 8
	dc.b	$11, $12, $13, $14, $15, $16, $17, $18, $11, $12, $13, $14, $15, $16, $17, $18
	dc.b	$11, $12, $13, $14, $15, $16, $17, $18, $11, $12, $13, $14, $15, $16, $17, $18
	dc.b	$22, $23, 9, $A, $B, $C, $D, $E, $F, $10, 9, $A, $B, $C, $28, $29
	dc.b	$22, $23, $24, $25, $26, $27, $28, $29, $22, $23, 9, $A, $B, $C, $D, $E
	dc.b	$34, $35, $19, $1A, $1B, $1C, $1D, $1E, $1F, $20, $21, $1A, $1B, $1C, $3A, $3B
	dc.b	$34, $35, $36, $37, $38, $39, $3A, $3B, $34, $35, $19, $1A, $1B, $1C, $1D, $1E
	dc.b	$46, $47, $2A, $2B, $2C, $2D, $2E, $2F, $30, $31, $32, $33, $2C, $2D, $4C, 9
	dc.b	$A, $B, $C, $49, $4A, 9, $A, $B, $C, $47, $2A, $2B, $2C, $2D, $2E, $2F
	dc.b	$58, $59, $3C, $3D, $3E, $3F, $40, $41, $42, $43, $44, $45, $3E, $3F, $5E, $19
	dc.b	$1A, $1B, $1C, $5B, $5C, $19, $1A, $1B, $1C, $59, $3C, $3D, $3E, $3F, $40, $41
	dc.b	$6A, $6B, $4E, $4F, $50, $51, $52, $53, $54, $55, $56, $57, $50, $51, $70, $2A
	dc.b	$2B, $2C, $2D, $6D, $6E, $2A, $2B, $2C, $2D, $6B, $4E, $4F, $50, $51, $52, $53
	dc.b	$7C, $7D, $60, $61, $62, $63, $64, $65, $66, $67, $68, $69, $62, $63, $82, $3C
	dc.b	$3D, $3E, $3F, $7F, $80, $3C, $3D, $3E, $3F, $7D, $60, $61, $62, $63, $64, $65
	dc.b	$8E, $8F, $72, $73, $74, $75, $76, $77, $78, $79, $7A, $7B, $74, $75, $94, $4E
	dc.b	$4F, $50, $51, $91, $92, $4E, $4F, $50, $51, $8F, $72, $73, $74, $75, $76, $77
	dc.b	$A0, $A1, $84, $85, $86, $87, $88, $89, $8A, $8B, $8C, $8D, $86, $87, $A6, $60
	dc.b	$61, $62, $63, $A3, $A4, $60, $61, $62, $63, $A1, $84, $85, $86, $87, $88, $89
	dc.b	$11, $12, $96, $97, $98, $99, $9A, $9B, $9C, $9D, $9E, $9F, $98, $99, $17, $72
	dc.b	$73, $74, $75, $14, $15, $72, $73, $74, $75, $12, $96, $97, $98, $99, $9A, $9B
	dc.b	$22, $23, 9, $A8, $A9, $AA, $AB, $AC, $AD, $AE, $AF, $B0, $A9, $AA, $28, $84
	dc.b	$85, $86, $87, $25, $26, $84, $85, $86, $87, $23, 9, $A8, $A9, $AA, $AB, $AC
	dc.b	$34, $35, $19, $1A, $B1, $B2, $B3, $B4, $B5, $B6, $B7, $B8, $B1, $B2, $3A, 9
	dc.b	$A, $B, $C, $D, $E, $F, $10, 9, $A, $35, $19, $1A, $B1, $B2, $B3, $B4
	dc.b	$46, $47, $2A, $2B, $2C, $2D, $2E, $2F, $30, $31, $32, $33, $2C, $2D, $4C, $19
	dc.b	$1A, $1B, $1C, $1D, $1E, $1F, $20, $21, $1A, $47, $2A, $2B, $2C, $2D, $2E, $2F
byte_1DCBA
	dc.b	1, 2, 3, 4, 5, 6, 7, 8, $11, $12, $13, $14, $15, $16, $17, $18
	dc.b	$F, $10, 9, $A, $B, $C, $28, $29, $1F, $20, $21, $1A, $1B, $1C, $3A, $3B
	dc.b	$30, $31, $32, $33, $2C, $2D, $4C, $4D, $42, $43, $44, $45, $3E, $3F, $5E, $5F
	dc.b	$54, $55, $56, $57, $50, $51, $70, $71, $66, $67, $68, $69, $62, $63, $82, $83
	dc.b	$78, $79, $7A, $7B, $74, $75, $94, $95, $8A, $8B, $8C, $8D, $86, $87, $A6, $A7
	dc.b	$9C, $9D, $9E, $9F, $98, $99, $17, $18, $AD, $AE, $AF, $B0, $A9, $AA, $28, $29
	dc.b	$B5, $B6, $B7, $B8, $B1, $B2, $3A, $3B, $30, $31, $32, $33, $2C, $2D, $4C, $4D
byte_1DD2A
	dc.b	$58, $59, $3C, $3D, $3E, $3F, $40, $41, $42, $43, $44, $45, $3E, $3F, $5E, $2A
	dc.b	$2B, $2C, $2D, $2E, $2F, $30, $31, $32, $33, $59, $3C, $3D, $3E, $3F, $40, $41
	dc.b	$6A, $6B, $4E, $4F, $50, $51, $52, $53, $54, $55, $56, $57, $50, $51, $70, $3C
	dc.b	$3D, $3E, $3F, $40, $41, $42, $43, $44, $45, $6B, $4E, $4F, $50, $51, $52, $53
	dc.b	$7C, $7D, $60, $61, $62, $63, $64, $65, $66, $67, $68, $69, $62, $63, $82, $4E
	dc.b	$4F, $50, $51, $52, $53, $54, $55, $56, $57, $7D, $60, $61, $62, $63, $64, $65
	dc.b	$8E, $8F, $72, $73, $74, $75, $76, $77, $78, $79, $7A, $7B, $74, $75, $94, $60
	dc.b	$61, $62, $63, $64, $65, $66, $67, $68, $69, $8F, $72, $73, $74, $75, $76, $77
	dc.b	$A0, $A1, $84, $85, $86, $87, $88, $89, $8A, $8B, $8C, $8D, $86, $87, $A6, $72
	dc.b	$73, $74, $75, $76, $77, $78, $79, $7A, $7B, $A1, $84, $85, $86, $87, $88, $89
	dc.b	$11, $12, $96, $97, $98, $99, $9A, $9B, $9C, $9D, $9E, $9F, $98, $99, $17, $84
	dc.b	$85, $86, $87, $88, $89, $8A, $8B, $8C, $8D, $12, $96, $97, $98, $99, $9A, $9B
	dc.b	$22, $23, 9, $A8, $A9, $AA, $AB, $AC, $AD, $AE, $AF, $B0, $A9, $AA, $28, $96
	dc.b	$97, $98, $99, $9A, $9B, $9C, $9D, $9E, $9F, $23, 9, $A8, $A9, $AA, $AB, $AC
	dc.b	$34, $35, $19, $1A, $B1, $B2, $B3, $B4, $B5, $B6, $B7, $B8, $B1, $B2, $3A, 9
	dc.b	$A8, $A9, $AA, $AB, $AC, $AD, $AE, $AF, $B0, $35, $19, $1A, $B1, $B2, $B3, $B4
	dc.b	$46, $47, $2A, $2B, $2C, $2D, $2E, $2F, $30, $31, $32, $33, $2C, $2D, $4C, $19
	dc.b	$1A, $B1, $B2, $B3, $B4, $B5, $B6, $B7, $B8, $47, $2A, $2B, $2C, $2D, $2E, $2F
	dc.b	$58, $59, $3C, $3D, $3E, $3F, $40, $41, $42, $43, $44, $45, $3E, $3F, $5E, $2A
	dc.b	$2B, $2C, $2D, $2E, $2F, $30, $31, $32, $33, $59, $3C, $3D, $3E, $3F, $40, $41
	dc.b	$6A, $6B, $4E, $4F, $50, $51, $52, $53, $54, $55, $56, $57, $50, $51, $70, $3C
	dc.b	$3D, $3E, $3F, $40, $41, $42, $43, $44, $45, $6B, $4E, $4F, $50, $51, $52, $53
	dc.b	$7C, $7D, $60, $61, $62, $63, $64, $65, $66, $67, $68, $69, $62, $63, $82, $4E
	dc.b	$4F, $50, $51, $52, $53, $54, $55, $56, $57, $7D, $60, $61, $62, $63, $64, $65
	dc.b	$8E, $8F, $72, $73, $74, $75, $76, $77, $78, $79, $7A, $7B, $74, $75, $94, $95
	dc.b	$8E, $8F, $90, $91, $92, $93, $94, $95, $8E, $8F, $72, $73, $74, $75, $76, $77
	dc.b	$A0, $A1, $84, $85, $86, $87, $88, $89, $8A, $8B, $8C, $8D, $86, $87, $A6, $A7
	dc.b	$A0, $A1, $A2, $A3, $A4, $A5, $A6, $A7, $A0, $A1, $84, $85, $86, $87, $88, $89
byte_1DEEA
	dc.b	$42, $43, $44, $45, $3E, $3F, $5E, $5F, $54, $55, $56, $57, $50, $51, $70, $71
	dc.b	$66, $67, $68, $69, $62, $63, $82, $83, $78, $79, $7A, $7B, $74, $75, $94, $95
	dc.b	$8A, $8B, $8C, $8D, $86, $87, $A6, $A7, $9C, $9D, $9E, $9F, $98, $99, $17, $18
	dc.b	$AD, $AE, $AF, $B0, $A9, $AA, $28, $29, $B5, $B6, $B7, $B8, $B1, $B2, $3A, $3B
	dc.b	$30, $31, $32, $33, $2C, $2D, $4C, $4D, $42, $43, $44, $45, $3E, $3F, $5E, $5F
	dc.b	$54, $55, $56, $57, $50, $51, $70, $71, $66, $67, $68, $69, $62, $63, $82, $83
	dc.b	$78, $79, $7A, $7B, $74, $75, $94, $95, $8A, $8B, $8C, $8D, $86, $87, $A6, $A7
byte_1DF5A
	dc.b	1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1
	dc.b	1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1
	dc.b	1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1
	dc.b	1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1
	dc.b	1, 1, 2, 3, 2, 4, 5, 6, 1, 1, 1, 1, 1, 1, 1, 1
	dc.b	1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 2
	dc.b	7, 8, 9, $A, $B, $C, $D, $E, $F, $10, 1, 1, 1, 1, 1, 1
	dc.b	1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 7, $11, 8, 9
	dc.b	$16, $17, $18, $19, $1A, $B, $1B, $1C, $1D, $1E, $1F, 1, 1, 1, 1, 1
	dc.b	1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, $20, $12, $16, $21, $17
	dc.b	$23, $26, $E, $23, $27, $28, $29, $2A, $2B, $2C, $D, $2D, 1, 1, 1, 1
	dc.b	1, 1, 1, 1, 1, 1, 1, 1, 1, 1, $2E, $23, $2F, $13, $30, $31
	dc.b	$35, $36, $C, $D, $37, $38, $39, $27, $3A, $3B, $3C, $3D, 1, 1, 1, 1
	dc.b	1, 1, 1, 1, 1, 1, 1, 1, 1, $3E, $F, $A, $23, $26, $3F, $23
	dc.b	$D, $23, $22, $2C, $43, $36, $C, $44, $34, $1C, $29, $1C, $45, 1, 1, 1
	dc.b	1, 1, 1, 1, 1, 1, 1, 1, 1, $11, $46, $18, $35, $E, $D, $23
	dc.b	$48, $49, $4A, $4B, $22, $4C, $4D, $4E, $22, $4F, $2A, $29, $50, $51, 1, 1
	dc.b	1, 1, 1, 1, 1, 1, 1, 1, $2E, $B, $52, $23, $18, $4B, $48, $49
	dc.b	$55, $56, $57, $58, $59, $29, $3C, $D, $5A, $23, $47, $5B, $5C, $5D, 1, 1
	dc.b	1, 1, 1, 1, 1, 1, 1, $5E, $49, $1A, $3F, $5F, $60, $55, $56, $E
	dc.b	$63, $55, $64, $65, $49, $66, $67, $68, $69, $32, $24, $28, $6A, $2D, 1, 1
	dc.b	1, 1, 1, 1, 1, 1, 1, $3E, $4D, $5A, $63, $6B, $64, $6C, $6D, $57
	dc.b	$D, $6C, $70, $47, $71, $72, $73, $74, $75, $59, $76, $3A, $1F, $5D, 1, 1
	dc.b	1, 1, 1, 1, 1, 1, 1, $77, $38, $32, $2A, $D, $78, $79, $7A, $73
	dc.b	$48, $7F, $80, $81, $82, $83, $84, $85, $86, $7E, $2C, $53, $87, 1, 1, 1
	dc.b	1, 1, 1, 1, 1, 1, 1, $88, $F, $B, $49, $66, $7F, $89, $8A, $8B
	dc.b	$56, $E, $1C, $94, $95, $96, $97, $98, $7F, $4B, $99, $9A, 1, 1, 1, 1
	dc.b	1, 1, 1, 1, 1, 1, 1, 1, $9B, $9C, $9D, $9C, $28, $9E, $9F, $A0
	dc.b	$A7, $A8, $A9, $AA, $AB, $AC, $AD, $AE, $A7, $A8, $AF, $B0, $B0, $B0, $B0, $B0
	dc.b	$B0, $B0, $B0, $B0, $B0, $B0, $B0, $B0, $B0, $B0, $B0, $B0, $A7, $B1, $A8, $A9
	dc.b	$B8, $B8, $B8, $B9, $BA, $BB, $BC, $B8, $B8, $B8, $B8, $B8, $B8, $B8, $B8, $B8
	dc.b	$B8, $B8, $B8, $B8, $B8, $B8, $B8, $B8, $B8, $B8, $B8, $B8, $B8, $B8, $B8, $B8
byte_1E15A
	dc.b	1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1
	dc.b	3, 2, 4, 5, 6, 1, 1, 1, $12, $B, $13, $14, $A, $F, $15, $10
	dc.b	$22, $19, $23, $B, $1B, $1C, $24, $25, $32, $1D, $27, $28, $29, $33, $2B, $34
	dc.b	$18, $40, $37, $38, $39, $41, $3A, $42, $47, $2C, $43, $36, $C, $44, $34, $1C
	dc.b	$4A, $53, $22, $4C, $4D, $4E, $54, $4F, $32, $59, $29, $3C, $61, $22, $29, $62
	dc.b	$58, $1E, $6E, $6F, $54, $E, $69, $24, $65, $71, $7B, $7C, $44, $7D, $7E, $76
	dc.b	$8C, $8D, $8E, $8F, $90, $91, $92, $93, $A1, $A2, $A3, $A4, $A5, $A6, $4B, $38
	dc.b	$B2, $B3, $B4, $B5, $B6, $AE, $A9, $B7, $B8, $BD, $BE, $83, $BF, $B8, $B8, $B8
byte_1E1DA
	dc.b	$5D, $5E, $5F, 1, 2, 3, 4, $60, $61, 5, $62, $63, $64, $65, $66, $60
	dc.b	$5D, $67, $68, $69, $6A, $6B, $67, $6C, $6D, $5D, $6E, $6F, $70, $5D, $71, 5
	dc.b	$72, $C, $D, $E, $F, $10, $11, $12, $13, $B, $73, $74, $75, $76, $77, $77
	dc.b	$78, $77, $64, $79, $7A, $7B, $77, $7C, $77, $77, $7D, $7E, $7F, $14, $15, $16
	dc.b	$1E, $1F, $20, $21, $22, $23, $24, $25, $26, $27, $32, $7E, $80, $7B, $81, $82
	dc.b	$83, $58, $84, $85, $86, $87, $88, $89, $88, $6C, $80, $8A, $8B, $28, $29, $2A
	dc.b	$62, $33, $34, $35, $36, $37, $38, $39, $3A, $63, 5, $4A, $88, $50, $4F, $4F
	dc.b	$4F, $4F, $4F, $4F, $4F, $4F, $4F, $4F, $4F, $4F, $4F, $4A, $8C, $3B, $3C, $3D
	dc.b	$64, $82, $8C, $67, $8D, $47, $8E, $57, $4A, $89, $50, $4F, $4F, $4F, $4F, $4F
	dc.b	$4F, $4F, $4F, $4F, $4F, $4F, $4F, $4F, $4F, $4F, $4F, $4F, $50, $44, $45, $46
	dc.b	$77, $8F, $90, $45, $51, $91, $87, $6C, $92, $4F, $4F, $4F, $4F, $4F, $4F, $4F
	dc.b	$4F, $4F, $4F, $4F, $4F, $4F, $4F, $4F, $4F, $4F, $4F, $4F, $4F, $4F, $4F, $4F
	dc.b	0, $5C, $7C, $6C, $44, $57, $50, $93, $4F, $4F, $4F, $4F, $4F, $4F, $4F, $4F
	dc.b	$4F, $4F, $4F, $4F, $4F, $4F, $4F, $4F, $4F, $4F, $4F, $4F, $4F, $4F, $4F, $4F
	dc.b	0, 0, $94, $64, $88, $4F, $4F, $4F, $4F, $4F, $4F, $4F, $4F, $4F, $4F, $4F
	dc.b	$4F, $4F, $4F, $4F, $4F, $4F, $4F, $4F, $4F, $4F, $4F, $4F, $4F, $4F, $4F, $4F
	dc.b	0, 0, $77, $92, $4F, $4F, $4F, $4F, $4F, $4F, $4F, $4F, $4F, $4F, $4F, $4F
	dc.b	$4F, $4F, $4F, $4F, $4F, $4F, $4F, $4F, $4F, $4F, $4F, $4F, $4F, $4F, $4F, $4F
byte_1E2FA
	dc.b	6, 7, 8, 9, $A, $B, $77, $60, $17, $18, $19, $1A, $1B, $1C, $1D, $5D
	dc.b	$2B, $2C, $2D, $2E, $2F, $30, $31, $32, $3E, $3F, $40, $33, $41, $42, $43, $77
	dc.b	$47, $48, $49, $4A, $4B, $4C, $4D, $4E, $50, $44, $51, $52, $53, $54, $55, 0
	dc.b	$4F, $50, $56, $57, $58, $59, 0, 0, $4F, $4F, $5A, $5B, $5C, $55, 0, 0
	dc.b	$4F, $4F, $4F, $50, $5C, $54, 0, 0
byte_1E342
	dc.b	$E1, $C0, $E2, $5C, $E1, $C1, $E1, $C2, $E1, $C3, $E1, $C4
byte_1E34E
	dc.b	$E2, $55, $E1, $CA, $E1, $EB, $E1, $EC, $E1, $ED, $E1, $EE, $E1, $EF, $E1, $F0
byte_1E35E
	dc.b	$C5, $C6, $C7, $C8, $C9, $C0, $FC, $FC, $FC, $FC, $FC, $FC, $FC, $FC, $FC, $FC
	dc.b	$FC, $FC, $FC, $FC, $CA, $C8, $C9, $C0, $FC, $FC, $FC, $FC, $FC, $FC, $CA, $C8
	dc.b	$CB, $CC, $CD, $CE, $CF, $D0, $D1, $D2, $D3, $D4, $D5, $D6, $D7, $D8, $D9, $DA
	dc.b	$D3, $D4, $D5, $D6, $CD, $CE, $CF, $D0, $D1, $D2, $D3, $D4, $D5, $D6, $CD, $CE
	dc.b	$DB, $DC, $DD, $DE, $DF, $E0, $E1, $E2, $E3, $E4, $DF, $E5, $E6, $E7, $E8, $E9
	dc.b	$E3, $E4, $DF, $E5, $DD, $DE, $DF, $E0, $E1, $EA, $E3, $E4, $DF, $E5, $DD, $DE
byte_1E3BE
	dc.b	$F1, $C0, $FC, $FC, $F2, $F3, $F4, $F5, $CF, $D0, $D1, $D2, $F6, $F7, $F8, $F9
	dc.b	$DF, $E0, $E1, $EA, $E3, $E4, $FA, $FB
byte_1E3D6
	dc.b	0, 0, 0, $BB, $BC, $BD, $BE, $BF, $C0, $C1, 0, 0, $C2, $C3, $C4, $A2
	dc.b	$C5, $C6, $C7, $C8, $C9, $CA, $CB, $CC, $CD, $CE, $CF, $D0, $D1, $D2, $D3, $D4
	dc.b	$D5, $D6, $D7, $D8, $D9, $DA, $DB, $DC, $DD, $DE, $DF, $B1, 0, $E0, $E1, $E2
	dc.b	$E3, $E4, $E5, $B8, $B9, $BA, 0, 0
byte_1E40E
	dc.b	0, $96, $97, $98, $99, $9A, $9B, $9C, $9D, $9E, 0, 0, $9F, $A0, $A1, $A2
	dc.b	$A2, $A2, $A2, $A2, $A2, $A3, $A4, $A5, $A6, $A7, $A8, $A9, $AA, $AB, $AC, $AD
	dc.b	$AE, $AF, $B0, $B1, 0, $B2, $B3, $B4, $B5, $B6, $B7, $B8, $B9, $BA, 0, 0
byte_1E43E
	dc.b	$E6, $E7, $E8, $E9, $EA, $EB
byte_1E444
	dc.b	1, 2, 3, 4, 5, 6, 6, 6, 7, 8, 7, 8, 7, 9, $A, 9
	dc.b	$A, $B, $A, $C, $D, $E, $F, $10, $11, 6, $12, $13, $14, $15, $16, $D
	dc.b	$17, $18, $19, $1A, $1B, $18, $19, $1C, $1B, $18, $19, $1C, $1D, $1E, $1F, $20
	dc.b	$21, $1F, $22, $23, $21, $1F, $24, $25, $26, $27, $28, $29, $21, $1F, $23, $2A
	dc.b	$2B, $2C, $2D, $2E, $2B, $2C, $2D, $2E, $2B, $2C, $2D, $2E, $2B, $2B, $2C, $2E
	dc.b	$2B, $2C, $2D, $2E, $2B, $2C, $2D, $2E, $2B, $2C, $2D, $2E, $2B, $2C, $2D, $2E
	dc.b	$2F, $30, $31, $32, $2F, $30, $31, $32, $2F, $33, $34, $33, $31, $32, $2F, $30
	dc.b	$31, $32, $2F, $2F, $30, $31, $32, $2F, $30, $31, $32, $2F, $30, $31, $32, $2F
	dc.b	$35, $36, $36, $35, $36, $37, $35, $36, $38, $39, $3A, $3B, $35, $36, $38, $39
	dc.b	$3B, $3A, $39, $38, $36, $35, $37, $35, $36, $35, $36, $3A, $35, $36, $35, $36
	dc.b	$3C, $3C, $3C, $3C, $3C, $3C, $3C, $3C, $3C, $3C, $3C, $3C, $3C, $3C, $3C, $3C
	dc.b	$3C, $3C, $3C, $3C, $3C, $3C, $3C, $3C, $3C, $3C, $3C, $3C, $3C, $3C, $3C, $3C
	dc.b	$3D, $3E, $3E, $3D, $3E, $3F, $3D, $3E, $40, $40, $41, $42, $43, $44, $45, $43
	dc.b	$42, $41, $40, $40, $3E, $3D, $3F, $3D, $3E, $3D, $3E, $41, $3D, $3E, $3D, $3E
	dc.b	$4A, $4A, $4A, $4A, $4A, $4A, $4A, $4A, $4A, $4A, $4A, $4A, $4A, $4A, $4A, $4A
	dc.b	$4A, $4A, $4A, $4A, $4A, $4A, $4A, $4A, $4A, $4A, $4A, $4A, $4A, $4A, $4A, $4A
byte_1E544
	dc.b	$A, $4B, $4C, $4D, $4E, $4F, $50, $51, $52, $53, $54, $55, $56, $57, $58, $1C
	dc.b	$2B, $59, $5A, $5B, $2B, $2C, $2D, $2E, $33, $31, $32, $2F, $34, $33, $31, $32
	dc.b	$35, $36, $37, $35, $36, $38, $35, $36, $3C, $3C, $3C, $3C, $3C, $3C, $3C, $3C
	dc.b	$3D, $3E, $3F, $3D, $3E, $40, $3D, $3E, $4A, $4A, $4A, $4A, $4A, $4A, $4A, $4A
byte_1E584
	dc.b	0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, $5E, $5F, $60
	dc.b	$61, $62, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
	dc.b	0, 0, $65, $66, $67, $68, $69, 0, 0, 0, 0, 0, 0, 0, 0, 0
	dc.b	0, 0, 0, 0, 0, 0, 0, $65, $66, $6C, $68, $69, 0, 0, 0, 0
	dc.b	0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, $65, $66, $67, $6F
	dc.b	$69, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
	dc.b	0, $71, $72, $67, $6F, $69, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
	dc.b	$74, $75, 0, 0, 0, 0, $5E, $5F, $76, $77, $78, 0, 0, 0, 0, 0
	dc.b	0, 0, 0, 0, 0, $7A, $7B, $7C, 0, 0, 0, $7D, $7E, $7F, $80, $81
	dc.b	0, 0, 0, 0, 0, 0, 0, 0, 0, 0, $83, $84, $85, 0, 0, 0
	dc.b	$86, $87, $67, $88, $89, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, $8B
	dc.b	$8C, $8D, 0, 0, 0, $5E, $5F, $60, $61, $62, 0, 0, 0, $46, $47, 0
	dc.b	0, 0, 0, 0, $8F, $90, $91, 0, 0, 0, $65, $66, $6C, $68, $69, 0
	dc.b	0, 0, $6A, $6B, 0, 0, 0, 0, 0, $92, $93, $8D, 0, 0, 0, $71
	dc.b	$72, $67, $6F, $69, 0, 0, 0, $94, $64, 0, 0, 0, 0, 0, $95, $8C
	dc.b	$96, 0, 0, 0, $65, $66, $6C, $68, $69, 0, 0, 0, $97, $5D, 0, 0
	dc.b	0, 0, 0, $83, $98, $99, 0, 0, 0, $71, $72, $67, $6F, $69, 0, 0
	dc.b	$9A, $82, $64, $9B, 0, 0, 0, 0, $8B, $9C, $91, $9D, $9E, 0, $5E, $5F
	dc.b	$60, $61, $62, 0, $9F, $A0, $A1, $6B, $A2, $A3, $A4, $A5, 0, $92, $93, $8D
	dc.b	$A6, $A7, $A8, $65, $66, $6C, $68, $69, $A9, $AA, $AB, $AC, $AD, $AE, $AF, $B0
	dc.b	$B1, $B2, $95, $8C, $B3, $B4, $B5, $B6, $71, $72, $67, $6F, $69, $B7, $B5, $B6
	dc.b	$B8, $B9, $BA, $BB, $BC, $BD, $BE, $BF, $C0, $C1, $C2, $C3, $C4, $C5, $C6, $C7
	dc.b	$C8, $C9, $CA, $CB, $CC, $CD, $CE, $CF, $D0, $CB, $D1, $D2, $D3, $D4, $D5, $D6
	dc.b	$D7, $D8, $D9, $DA, $DB, $DC, $DD, $DE, 6, 6, $DF, $E0, $E1, $E2, $E3, $E4
	dc.b	$E5, $E6, $E7, $E8, $E9, $EA, $EB, $EC, $ED, $EE, $EF, 6, 6, 6, 6, $F0
	dc.b	$F1, $F2, $F3, $F4, $F5, $F6, $F7, $F8, $F9, $FA, $FB, $FC, $FD, $FE, $FF, $FE
	dc.b	$FF, $FE, $FF, $FE
byte_1E728
	dc.b	0, 0, 0, 0, 0, 1, 2, 3, 4, 5, 6, 7, 0, 0, 0, 0
	dc.b	0, 0, 0, 0, 0, 0, 0, 0, 8, 9, $A, 4, 5, 6, 7, 0
	dc.b	0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, $B, 9, $C, 4, 5
	dc.b	6, 7, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, $D, $E
	dc.b	$F, 4, 5, 6, 7, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
	dc.b	0, $10, $11, $12, 4, 5, 6, 7, 0, 0, 0, 0, 0, 0, 0, 0
	dc.b	0, 0, 0, 0, $13, $14, $15, 4, 5, $16, 7, 0, 0, 0, 0, 0
	dc.b	0, 0, 0, 0, 0, 0, 0, $17, 9, $18, 4, 5, 6, 7, 0, 0
	dc.b	0, 0, 0, 0, 0, 0, 0, 0, 0, 0, $19, $1A, $1B, $1C, $1D, $1E
	dc.b	$1F, 0, 0, 0, $20, 0, 0, 0, 0, 0, 0, 0, 0, $21, $22, $23
	dc.b	$24, $25, $26, $1F, 0, 0, 0, $27, 0, 0, 0, 0, 0, 0, 0, 0
	dc.b	$28, 9, $29, $2A, 5, 6, 7, 0, 0, 0, $2B, 0, $20, 0, 0, 0
	dc.b	0, 0, 0, $17, 9, $18, 4, 5, 6, 7, 0, 0, 0, $2C, 0, $27
	dc.b	0, 0, 0, 0, 0, 0, $13, $14, $15, 4, 5, $16, 7, 0, 0, 0
	dc.b	$2D, 0, $2D, 0, $2E, 0, 0, 0, 0, $10, $11, $12, 4, 5, 6, 7
	dc.b	0, 0, 0, $2D, 0, $2C, 0, $2F, $30, $31, $32, 0, $D, $E, $F, 4
	dc.b	5, 6, 7, 0, 0, 0, $33, 0, $2D, 0, $34, $35, $36, $37, 0, $B
	dc.b	9, $C, 4, 5, 6, 7, 0, 0, $38, $39, 0, $2C, 0, $3A, $3B, $3C
	dc.b	$3D, $3E, 8, 9, $A, 4, 5, 6, 7, $3F, $40, $41, $42, $43, $44, $45
	dc.b	$46, $46, $47, $48, $49, 1, 2, 3, 4, 5, 6, 7, $4A, $4B, $4C, $4D
	dc.b	$4E, $4F, $50, $46, $46, $51, $52, $53, $19, $1A, $1B, $1C, $1D, $1E, $1F, $54
	dc.b	$55, $56, $57, $58, $59, $5A, $46, $5B, $5C, $5D, $5E, $5F, $60, $61, $62, $63
	dc.b	$64, $65, $66, $46, $46, $67, $68, $69, $6A, $6B, $6C, $6D, $6E, $6F, $70, $71
	dc.b	$72, $73, $74, $75, $76, $46, $46, $46, $46, $6B, $77, $78
byte_1E8A4
	dc.b	$79, $79, $79, $79, $79, $79, $79, $79, $79, $79, $79, $79, $79, $79, $79, $79
	dc.b	$79, $79, $79, $79, $79, $79, $79, $79, $79, $79, $79, $79, $79, $79, $79, $79
	dc.b	$7A, $7A, $7A, $7A, $7A, $7A, $7A, $7A, $7A, $7A, $7A, $7A, $7A, $7A, $7A, $7A
	dc.b	$7A, $7A, $7A, $7A, $7A, $7A, $7A, $7A, $7A, $7A, $7A, $7A, $7A, $7A, $7A, $7A
	dc.b	$7B, $7B, $7B, $7B, $7B, $7B, $7B, $7B, $7B, $7B, $7B, $7B, $7B, $7B, $7B, $7B
	dc.b	$7B, $7B, $7B, $7B, $7B, $7B, $7B, $7B, $7B, $7B, $7B, $7B, $7B, $7B, $7B, $7B
	dc.b	$7C, $7C, $7C, $7C, $7C, $7C, $7C, $7C, $7C, $7C, $7C, $7C, $7C, $7C, $7C, $7C
	dc.b	$7C, $7C, $7C, $7C, $7C, $7C, $7C, $7C, $7C, $7C, $7C, $7C, $7C, $7C, $7C, $7C
	dc.b	$7D, $7D, $7D, $7D, $7D, $7D, $7D, $7D, $7D, $7D, $7D, $7D, $7D, $7D, $7D, $7D
	dc.b	$7D, $7D, $7D, $7D, $7D, $7D, $7D, $7D, $7D, $7D, $7D, $7D, $7D, $7D, $7D, $7D
	dc.b	$7E, $7E, $7E, $7E, $7E, $7E, $7E, $7E, $7E, $7E, $7E, $7E, $7E, $7E, $7E, $7E
	dc.b	$7E, $7F, $80, $81, $82, $83, $84, $85, $86, $7E, $7E, $7E, $7E, $7E, $7E, $7E
	dc.b	$87, $87, $87, $87, $87, $87, $87, $87, $87, $87, $87, $87, $87, $87, $87, $87
	dc.b	$88, $89, $8A, $8B, $8C, $8D, $8E, $8F, $90, $91, $87, $87, $87, $87, $87, $87
	dc.b	$92, $92, $92, $92, $92, $92, $92, $92, $92, $92, $92, $92, $92, $92, $93, $94
	dc.b	$95, $96, $97, $98, $99, $9A, $9B, $9C, $9D, $9E, $9F, $A0, $92, $92, $92, $92
	dc.b	$A1, $A1, $A1, $A1, $A1, $A1, $A1, $A1, $A1, $A1, $A1, $A1, $A2, $A3, $A4, $A5
	dc.b	$A6, $A7, $A8, $A9, $AA, $AB, $AC, $AD, $AE, $AF, $B0, $B1, $B2, $B3, $A1, $A1
	dc.b	$B4, $B4, $B4, $B4, $B4, $B4, $B4, $B4, $B4, $B5, $B6, $B7, $B8, $B9, $BA, $BB
	dc.b	$BC, $BD, $BE, $BF, $C0, $BC, $BC, $BC, $BC, $BC, $BC, $BC, $BC, $C1, $B7, $B6
	dc.b	$C2, $C2, $C2, $C2, $C2, $C2, $C3, $C4, $C5, $C6, $BC, $BC, $BC, $BC, $BC, $BC
	dc.b	$BC, $BC, $BC, $BC, $BC, $BC, $BC, $BC, $BC, $BC, $BC, $BC, $BC, $BC, $BC, $BC
	dc.b	$C7, $C8, $C9, $CA, $CB, $CC, $BC, $BC, $BC, $BC, $BC, $BC, $BC, $BC, $BC, $BC
	dc.b	$BC, $BC, $BC, $BC, $BC, $BC, $BC, $BC, $BC, $BC, $BC, $BC, $BC, $BC, $BC, $BC
byte_1EA24
	dc.b	$79, $79, $79, $79, $79, $79, $79, $79, $7A, $7A, $7A, $7A, $7A, $7A, $7A, $7A
	dc.b	$7B, $7B, $7B, $7B, $7B, $7B, $7B, $7B, $7C, $7C, $7C, $7C, $7C, $7C, $7C, $7C
	dc.b	$7D, $7D, $7D, $7D, $7D, $7D, $7D, $7D, $7E, $7E, $7E, $7E, $7E, $7E, $7E, $7E
	dc.b	$87, $87, $87, $87, $87, $87, $87, $87, $92, $92, $92, $92, $92, $92, $92, $92
	dc.b	$A1, $A1, $A1, $A1, $A1, $A1, $A1, $A1, $B5, $B4, $B4, $B4, $B4, $B4, $B4, $B4
	dc.b	$C6, $C5, $C4, $C3, $C2, $C2, $C2, $C2, $BC, $BC, $BC, $BC, $CC, $CB, $CA, $C9
byte_1EA84
	dc.b	$6A, $B7, $6A, $B6, $6A, $B5, $6A, $B4, $62, $B4, $62, $B4, $62, $B4, $62, $B4
	dc.b	$62, $B4, $62, $B4, $62, $BC, $62, $BC, $6A, $C6, $6A, $C5, $6A, $C4, $6A, $C3
	dc.b	$62, $C2, $62, $C2, $62, $C2, $62, $C2, $62, $BC, $62, $BC, $62, $BC, $62, $BC
	dc.b	$62, $BC, $62, $BC, $6A, $CC, $6A, $CB, $6A, $CA, $6A, $C9
byte_1EAC0
	dc.b	0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 2, 0, 0, 0, 0
	dc.b	0, 0, 3, 4, 0, 0, 0, 5, 0, 0, 0, 0, 0, 0, 0, 0
	dc.b	6, 7, 8, 6, 9, $A, $B, $C, $D, $E, $F, $10, $11, $12, $13, 9
	dc.b	$A, $14, $15, $16, $17, 7, 8, 6, 9, $18, $19, $1A, $C, $D, $1B, $A
	dc.b	$1C, $1D, $1E, $1F, $20, $21, $22, $23, $24, $25, $26, $27, $28, $29, $2A, $2B
	dc.b	$2C, $2D, $2E, $2F, $30, $31, $32, $33, $34, $35, $36, $37, $38, $39, $3A, $3B
	dc.b	$3C, $3D, $3E, $3F, $40, $41, $42, $43, $44, $45, $46, $47, $48, $49, $4A, $4B
	dc.b	$4C, $4D, $4E, $4F, $50, $51, $52, $53, $54, $55, $56, $57, $58, $59, $5A, $5B
	dc.b	$5C, $5D, $5E, $5D, $5F, $60, $61, $62, $63, $64, $65, $66, $67, $68, $62, $61
	dc.b	$69, $6A, $6B, $6C, $6D, $6E, $6F, $70, $71, $72, $73, $74, $75, $76, $77, $78
	dc.b	$79, $7A, $79, $79, $79, $7B, $79, $7B, $79, $7C, $7D, $7E, $7F, $7B, $79, $79
	dc.b	$79, $80, $81, $82, $83, $79, $79, $79, $84, $85, $86, $87, $88, $89, $8A, $8B
	dc.b	$79, $8C, $79, $8C, $8D, $8E, $8D, $8E, $79, $8C, $79, $8C, $79, $8C, $79, $8C
	dc.b	$79, $8F, $90, $91, $92, $8C, $8C, $79, $8C, $93, $94, $95, $96, $97, $98, $99
	dc.b	$8D, $8E, $8D, $8E, $9A, $9B, $9C, $9D, $9E, $8E, $8D, $7A, $8D, $8E, $8D, $8E
	dc.b	$8D, $8E, $8D, $8E, $8D, $8E, $8D, $8E, $8D, $8E, $9F, $A0, $A1, $A2, $A3, $A4
	dc.b	$A5, $A6, $A5, $A6, $A7, $A8, $A9, $AA, $8D, $A6, $A5, $A6, $AB, $A6, $AB, $A6
	dc.b	$AC, $A6, $AB, $A6, $AB, $AC, $AB, $A6, $AB, $A6, $AB, $A6, $AD, $AE, $AF, $B0
	dc.b	$7A, $B1, $B2, $B2, $B3, $B1, $B1, $B2, $B3, $B1, $B2, $B3, $B1, $B1, $B2, $B3
	dc.b	$B1, $7A, $B2, $B1, $B3, $B1, $B2, $B4, $B3, $B5, $B2, $B1, $8C, $79, $B3, $B1
	dc.b	$B6, $B7, $B8, $B8, $B6, $7A, $B7, $B6, $B8, $B6, $B8, $B6, $7A, $B7, $B8, $B6
	dc.b	$B7, $B7, $B8, $B6, $B7, $B8, $B7, $B9, $B6, $B7, $B9, $B6, $BA, $BB, $B6, $B7
	dc.b	$BC, $BD, $BD, $BE, $BF, $BD, $BC, $BD, $BD, $BC, $BD, $BD, $BC, $BD, $BD, $BE
	dc.b	$C0, $BD, $BC, $BD, $BD, $BC, $BD, $BD, $BC, $BD, $BD, $BC, $C1, $C2, $BC, $C3
	dc.b	$C4, $C5, $C6, $C3, $C5, $C6, $C4, $C5, $C6, $C4, $C5, $C6, $B5, $C5, $C6, $C4
	dc.b	$C7, $C6, $C4, $C5, $C6, $C4, $B5, $C6, $C8, $C9, $CA, $C4, $C5, $C6, $C4, $C5
	dc.b	$CB, $CC, $CD, $CB, $CC, $CD, $CB, $CC, $C8, $C9, $CA, $CD, $CB, $CC, $CD, $CB
	dc.b	$CC, $CD, $B5, $CC, $CD, $CB, $CC, $CD, $CE, $CF, $D0, $CB, $CC, $CD, $CB, $CC
	dc.b	$D1, $D2, $D3, $D4, $D0, $D5, $D1, $D2, $CE, $CF, $D0, $D5, $D1, $D2, $D3, $D4
	dc.b	$C3, $D5, $D1, $D2, $B5, $D4, $D0, $D5, $D1, $D2, $D3, $D4, $D0, $D5, $D1, $7A
byte_1ECA0
	dc.b	$13, 9, $A, $B, $13, 9, 7, 8, $1E, $1C, $D6, $D7, $D8, $1C, $D9, $DA
	dc.b	$DB, $DB, $DC, $DD, $DE, $DF, $E0, $E1, $E2, $E3, $E4, $E2, $E3, $E4, $E2, $E3
	dc.b	$79, $79, $79, $79, $79, $79, $79, $79, $79, $79, $8C, $79, $79, $79, $8C, $79
	dc.b	$8D, $8D, $8E, $8D, $8D, $8D, $8E, $8D, $A5, $A5, $A6, $A5, $A5, $A5, $A6, $A5
	dc.b	$B2, $B3, $B1, $B2, $B2, $7A, $B1, $B2, $B8, $7A, $B7, $B8, $B8, $B6, $B7, $B8
	dc.b	$BD, $BC, $BD, $BD, $BD, $BC, $BD, $BD, $C6, $C6, $C4, $C5, $BE, $C0, $C5, $C6
	dc.b	$CD, $CD, $CB, $CC, $C4, $C7, $CC, $CD, $D3, $D3, $B5, $D2, $D3, $D1, $D2, $D3
byte_1ED10
	dc.b	1, 2, 3, 4, 5, 6, 7, 8, 9, $A, $B, $C, $D, 1, 2, 3
	dc.b	4, 5, 6, 7, 8, 9, $A, $B, $C, $D, 1, 2, 3, 4, 5, 6
	dc.b	$E, $F, $10, $11, $12, $13, $14, $15, $16, $17, $18, $19, $1A, $E, $F, $10
	dc.b	$11, $12, $13, $14, $15, $16, $17, $18, $19, $1A, $E, $F, $10, $11, $12, $13
	dc.b	$1B, $1C, $1D, $1E, $1F, $20, $21, $22, $23, $24, $25, $26, $27, $1B, $1C, $1D
	dc.b	$1E, $1F, $20, $21, $22, $23, $24, $25, $26, $27, $1B, $1C, $1D, $1E, $1F, $20
	dc.b	$28, $29, $2A, $2B, $2C, $2D, $2E, $2F, $30, $31, $32, $33, $34, $28, $29, $2A
	dc.b	$2B, $2C, $2D, $2E, $2F, $30, $31, $32, $33, $34, $28, $29, $2A, $2B, $2C, $2D
	dc.b	$35, $36, $37, $38, $39, $3A, $3B, $3C, $3D, $3E, $3F, $40, $41, $35, $36, $37
	dc.b	$38, $39, $3A, $3B, $3C, $3D, $3E, $3F, $40, $41, $35, $36, $37, $38, $39, $3A
	dc.b	$42, $43, $44, $45, $46, $47, $48, $49, $4A, $4B, $4C, $4D, $4E, $42, $43, $44
	dc.b	$45, $46, $47, $48, $49, $4A, $4B, $4C, $4D, $4E, $42, $43, $44, $45, $46, $47
	dc.b	$4F, $50, $51, $52, $53, $54, $55, $56, $57, $58, $59, $5A, $5B, $4F, $50, $51
	dc.b	$52, $53, $54, $55, $56, $57, $58, $59, $5A, $5B, $4F, $50, $51, $52, $53, $54
	dc.b	$66, $5D, $5E, $5F, $60, $61, $62, $63, $64, $65, $66, $5D, $5E, $5F, $60, $61
	dc.b	$62, $63, $64, $65, $66, $5D, $5E, $5F, $60, $61, $62, $63, $64, $65, $66, $5D
	dc.b	$5C, $67, $68, $69, $6A, $6B, $6C, $6D, $6E, $6F, $5C, $67, $68, $69, $6A, $6B
	dc.b	$6C, $6D, $6E, $6F, $5C, $67, $68, $69, $6A, $6B, $6C, $6D, $6E, $6F, $5C, $67
	dc.b	$70, $71, $72, $73, $74, $75, $76, $77, $78, $79, $70, $71, $72, $73, $74, $75
	dc.b	$76, $77, $78, $79, $70, $71, $72, $73, $74, $75, $76, $77, $78, $79, $70, $71
	dc.b	$7A, $7B, $7C, $7D, $7E, $7F, $80, $81, $82, $83, $7A, $7B, $7C, $7D, $7E, $7F
	dc.b	$80, $81, $82, $83, $7A, $7B, $7C, $7D, $7E, $7F, $80, $81, $82, $83, $7A, $7B
	dc.b	$92, $85, $86, $87, $88, $89, $8A, $8B, $8C, $8D, $8E, $8F, $90, $91, $92, $85
	dc.b	$86, $87, $88, $89, $8A, $8B, $8C, $8D, $8E, $8F, $90, $91, $92, $85, $86, $87
	dc.b	$84, $93, $94, $95, $96, $97, $98, $99, $9A, $9B, $9C, $99, $9D, $9B, $84, $93
	dc.b	$94, $95, $96, $97, $98, $99, $9A, $9B, $9C, $99, $9D, $9B, $84, $93, $94, $95
	dc.b	$9E, $9F, $A0, $A1, $A2, $A3, $A4, $A5, $A6, $A7, $A8, $A9, $AA, $AB, $9E, $9F
	dc.b	$A0, $A1, $A2, $A3, $A4, $A5, $A6, $A7, $A8, $A9, $AA, $AB, $9E, $9F, $A0, $A1
byte_1EED0
	dc.b	6, 7, 8, 9, $A, $B, $C, $D, $13, $14, $15, $16, $17, $18, $19, $1A
	dc.b	$20, $21, $22, $23, $24, $25, $26, $27, $2D, $2E, $2F, $30, $31, $32, $33, $34
	dc.b	$3A, $3B, $3C, $3D, $3E, $3F, $40, $41, $47, $48, $49, $4A, $4B, $4C, $4D, $4E
	dc.b	$54, $55, $56, $57, $58, $59, $5A, $5B, $5E, $5F, $60, $61, $62, $63, $64, $65
	dc.b	$68, $69, $6A, $6B, $6C, $6D, $6E, $6F, $72, $73, $74, $75, $76, $77, $78, $79
	dc.b	$7C, $7D, $7E, $7F, $80, $81, $82, $83, $8A, $8B, $8C, $8D, $8E, $8F, $90, $91
	dc.b	$98, $99, $9A, $9B, $9C, $99, $9D, $9B, $A4, $A5, $A6, $A7, $A8, $A9, $AA, $AB
byte_1EF40
	dc.b	1, 1, 1, 1, 1, 1, 1, 1, 1, 2, 3, 1, 1, 1, 1, 1
	dc.b	1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 4, 1, 1, 1, 1
	dc.b	1, 1, 1, 1, 1, 1, 1, 1, 5, 6, 7, 8, 9, 1, 1, 1
	dc.b	1, 1, 1, 1, 1, $A, $B, $C, $D, $E, $F, $10, $11, $12, 1, 1
	dc.b	1, 1, 1, 1, 1, 1, 1, 1, $13, $14, $15, $16, 1, 1, 1, 1
	dc.b	1, 1, 1, 1, 1, $17, $18, $19, $1A, $1B, $1C, $1D, $1E, $1F, $20, 1
	dc.b	1, 1, 1, 1, 1, 1, 1, 1, $21, $22, $23, $24, 1, 1, 1, 1
	dc.b	1, 1, 1, 1, $25, $26, $27, $28, $29, $2A, $2B, $2C, $2D, $2E, $2F, 1
	dc.b	$35, $36, $37, $38, $30, $31, $32, $33, $34, $35, $36, $37, $38, $30, $31, $39
	dc.b	$3A, $3B, $3C, $3D, $3E, $3F, $40, $41, $42, $43, $44, $45, $46, $47, $48, $49
	dc.b	$51, $52, $53, $54, $4C, $4D, $4E, $4F, $50, $51, $52, $53, $54, $4C, $4D, $55
	dc.b	$56, $57, $58, $59, $5A, $5B, $5C, $5D, $5E, $5F, $60, $61, $62, $63, $64, $65
	dc.b	$6C, $6D, $6E, $6F, $68, $68, $69, $6A, $6B, $6C, $6D, $6E, $6F, $68, $68, $68
	dc.b	$70, $71, $72, $73, $74, $75, $76, $77, $78, $79, $7A, $7B, $7C, $7D, $7E, $68
	dc.b	$68, $68, $80, $68, $68, $68, $68, $68, $68, $68, $68, $80, $68, $68, $81, $82
	dc.b	$83, $84, $85, $86, $87, $88, $89, $8A, $8B, $8C, $8D, $8E, $8F, $90, $68, $91
	dc.b	$68, $68, $68, $68, $68, $68, $68, $68, $68, $68, $68, $68, $68, $95, $96, $97
	dc.b	$98, $99, $9A, $9B, $9C, $9D, $9E, $9F, $A0, $A1, $A2, $A3, $A4, $A5, $A6, $A7
	dc.b	$68, $68, $68, $68, $68, $68, $AC, $AD, $AE, $AF, $68, $68, $68, $B0, $B1, $B2
	dc.b	$B3, $B4, $B5, $B6, $B7, $B8, $B9, $BA, $BB, $BC, $BD, $BE, $BF, $C0, $C1, $C2
	dc.b	$68, $68, $68, $68, $68, $C7, $C8, $C9, $CA, $CB, $68, $68, $68, $CC, $CD, $CE
	dc.b	$CF, $D0, $D1, $D2, $D3, $D4, $D5, $D6, $D7, $D8, $D9, $DA, $DB, $DC, $DD, $DE
	dc.b	$68, $68, $68, $68, $68, $E3, $E4, $E5, $E6, $E7, $E8, $68, $E9, $EA, $EB, $EC
	dc.b	$ED, $EE, $EF, $F0, $F1, $F2, $F3, $F4, $F5, $F6, $F7, $F8, $F9, $FA, $FB, $FC
byte_1F0C0
	dc.b	$4A, $4B, $32, $33, $34, $35, $36, $37, $66, $67, $4E, $4F, $50, $51, $52, $53
	dc.b	$68, $7F, $69, $6A, $6B, $6C, $6D, $6E, $92, $93, $94, $68, $68, $68, $68, $80
	dc.b	$A8, $A9, $AA, $AB, $68, $68, $68, $68, $C3, $C4, $C5, $C6, $68, $68, $68, $68
	dc.b	$DF, $E0, $E1, $E2, $68, $68, $68, $68, $FD, $FE, $FF, $68, $68, $68, $68, $68
byte_1F100
	dc.b	1, 1, 1, 1, 1, 2, 3, 4, 5, 6, 7, 1, 8, 9, $A, $B
	dc.b	$C, $D, 1, $E, $F, $10, $11, $12, $13, $14, $15, $16, $17, $18, $19, $1A
	dc.b	1, 1, 1, 1, 1, 1, $1E, $1F, $20, $21, $22, $23, $24, $25, 1, $26
	dc.b	$27, $28, $29, $2A, $2B, $2C, $2D, $2E, $2F, $30, $31, $32, $33, $34, $35, $36
	dc.b	1, 1, 1, 1, 1, 1, 1, $3A, $3B, $3C, $3D, $3E, 1, $3F, $40, $41
	dc.b	$42, $43, $44, 1, $45, $46, $47, $48, $49, $4A, $4B, $4C, $4D, $4E, 1, $1E
	dc.b	1, 1, 1, 1, 1, 1, 1, $4F, $50, $51, $52, $53, 1, 1, $54, $42
	dc.b	$42, $55, $56, 1, 1, 1, 1, 1, 1, 1, $57, $58, $59, $5A, 1, 1
	dc.b	1, 1, 1, 1, 1, 1, 1, 1, $1E, $1E, 1, 1, 1, 1, $5B, $5C
	dc.b	$5D, $5E, $5F, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1
	dc.b	1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1
	dc.b	1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1
byte_1F1C0
	dc.b	$1B, $1C, $1D, 1, 1, 1, 1, 1, $37, $38, $39, 1, 1, 1, 1, 1
	dc.b	$1E, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1
	dc.b	1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1
	dc.b	$60, $4D, $88, $89, $8A, $8B, $8C, 1, $8D, $41, $8E, $8F, $81, $82, $83, $84
	dc.b	$85, $86, $20, $87, $60, $4D, $88, $89, $8A, $8B, $8C, 1, $8D, $41, $8E, $8F
	dc.b	$80, $6D, $9A, $9B, $9C, $CA, $CB, $21, $CC, $61, $CD, $CE, $90, $A5, $A6, $A7
	dc.b	$C8, $C9, $40, $2D, $80, $6D, $9A, $9B, $9C, $CA, $CB, $21, $CC, $61, $CD, $CE
	dc.b	$89, $8A, $8B, $8C, 1, 2, 3, 4, 5, 6, 7, 8, 9, $A, $B, $C
	dc.b	$D, $E, $F, $10, $11, $12, $13, $14, $15, $16, $17, $18, $19, $1A, $1B, $1C
	dc.b	$9B, $9C, $CA, $CB, $21, $22, $23, $24, $25, $26, $27, $28, $29, $2A, $2B, $2C
	dc.b	$2D, $2E, $2F, $30, $31, $32, $33, $34, $35, $36, $37, $38, $39, $3A, $3B, $3C
	dc.b	$8B, $8C, 1, $8D, $41, $42, $43, $44, $45, $46, $47, $48, $49, $4A, $4B, $4C
	dc.b	$4D, $4E, $4F, $50, $51, $52, $53, $54, $55, $56, $57, $58, $59, $5A, $5B, $5C
	dc.b	$CA, $CB, $21, $CC, $61, $62, $63, $64, $65, $66, $67, $68, $69, $6A, $6B, $6C
	dc.b	$6D, $6E, $6F, $70, $71, $72, $73, $74, $75, $76, $77, $78, $79, $7A, $7B, $7C
	dc.b	$8D, $41, $8E, $8F, $81, $82, $83, $84, $85, $86, $20, $87, $60, $4D, $88, $89
	dc.b	$8A, $8B, $8C, 1, $8D, $41, $8E, $8F, $81, $82, $83, $84, $85, $86, $20, $87
	dc.b	$CC, $61, $CD, $CE, $90, $91, $92, $93, $94, $95, $96, $97, $98, $99, $9A, $9B
	dc.b	$9C, $9D, $9E, $9F, $A0, $A1, $A2, $A3, $A4, $A5, $A6, $A7, $A8, $A9, $AA, $AB
	dc.b	$8E, $8F, $81, $82, $83, $B0, $B1, $B2, $B3, $B4, $B5, $B6, $B7, $89, $8A, $8B
	dc.b	$8C, $B8, $B9, $BA, $BB, $BC, $BD, $BE, $BF, $84, $85, $86, $C0, $C1, $C2, $C3
	dc.b	$CD, $CE, $90, $A5, $A6, $A7, $C8, $C9, $40, $2D, $80, $6D, $9A, $9B, $9C, $CA
	dc.b	$CB, $21, $CC, $61, $CD, $CE, $90, $A5, $A6, $A7, $C8, $C9, $40, $2D, $80, $6D
	dc.b	$82, $83, $84, $85, $CF, $D0, $87, $60, $4D, $88, $89, $8A, $8B, $8C, 1, $8D
	dc.b	$41, $8E, $8F, $81, $82, $83, $84, $85, $86, $20, $87, $60, $4D, $88, $89, $8A
	dc.b	$A5, $A6, $A7, $C8, $D1, $D2, $2D, $80, $6D, $9A, $9B, $9C, $CA, $CB, $21, $CC
	dc.b	$61, $CD, $CE, $90, $A5, $A6, $A7, $C8, $C9, $40, $2D, $80, $6D, $9A, $9B, $9C
	dc.b	$84, $85, $86, $20, $87, $60, $4D, $88, $89, $8A, $8B, $8C, 1, $8D, $41, $8E
	dc.b	$8F, $81, $82, $83, $84, $85, $86, $20, $87, $60, $4D, $88, $89, $8A, $8B, $8C
	dc.b	$A7, $C8, $C9, $40, $D3, $D4, $6D, $9A, $9B, $9C, $CA, $CB, $21, $CC, $61, $CD
	dc.b	$CE, $90, $A5, $A6, $A7, $C8, $C9, $40, $2D, $80, $6D, $9A, $9B, $9C, $CA, $CB
	dc.b	$20, $87, $60, $4D, $D5, $D6, $8A, $8B, $8C, 1, $8D, $41, $8E, $8F, $81, $82
	dc.b	$83, $84, $85, $86, $20, $87, $60, $4D, $88, $89, $8A, $8B, $8C, 1, $8D, $87
	dc.b	$40, $2D, $80, $6D, $9A, $9B, $9C, $CA, $CB, $21, $CC, $61, $CD, $CE, $90, $A5
	dc.b	$A6, $A7, $C8, $C9, $40, $2D, $80, $6D, $9A, $9B, $9C, $CA, $CB, $21, $CC, $2D
	dc.b	$60, $4D, $88, $89, $D7, $D8, $8C, 1, $8D, $41, $8E, $8F, $81, $82, $83, $84
	dc.b	$85, $86, $20, $87, $60, $4D, $88, $89, $8A, $8B, $8C, 1, $8D, $87, $60, $4D
	dc.b	$80, $6D, $9A, $9B, $D9, $DA, $CB, $21, $CC, $61, $CD, $CE, $90, $A5, $A6, $A7
	dc.b	$C8, $C9, $40, $2D, $80, $6D, $9A, $9B, $9C, $CA, $CB, $21, $CC, $2D, $80, $6D
	dc.b	$89, $8A, $8B, $8C, 1, $8D, $41, $8E, $8F, $81, $82, $83, $84, $85, $86, $20
	dc.b	$87, $60, $4D, $88, $89, $8A, $8B, $8C, 1, $8D, $87, $60, $4D, $88, $89, $8A
	dc.b	$9B, $9C, $CA, $CB, $DB, $DC, $61, $CD, $CE, $90, $A5, $A6, $A7, $C8, $C9, $40
	dc.b	$2D, $80, $6D, $9A, $9B, $9C, $CA, $CB, $21, $CC, $2D, $80, $6D, $9A, $9B, $9C
	dc.b	$8B, $8C, 1, $8D, $DD, $DE, $8F, $81, $82, $83, $84, $85, $86, $20, $87, $60
	dc.b	$4D, $88, $89, $8A, $8B, $8C, 1, $8D, $87, $60, $4D, $88, $89, $8A, $8B, $8C
	dc.b	$CA, $CB, $21, $CC, $2D, $80, $CE, $90, $A5, $A6, $A7, $C8, $C9, $40, $2D, $80
	dc.b	$6D, $9A, $9B, $9C, $CA, $CB, $21, $CC, $2D, $80, $6D, $9A, $9B, $9C, $CA, $CB
	dc.b	$8D, $41, $8E, $8F, $DF, $E0, $83, $84, $85, $86, $20, $87, $60, $4D, $88, $89
	dc.b	$8A, $8B, $8C, 1, $8D, $87, $60, $4D, $88, $89, $8A, $8B, $8C, 1, $8D, $87
	dc.b	$CC, $61, $CD, $CE, $E1, $E2, $A6, $A7, $C8, $C9, $40, $2D, $80, $6D, $9A, $9B
	dc.b	$9C, $CA, $CB, $21, $CC, $2D, $80, $6D, $9A, $9B, $9C, $CA, $CB, $21, $CC, $2D
	dc.b	$8E, $8F, $81, $82, $83, $84, $85, $86, $20, $87, $60, $4D, $88, $89, $8A, $8B
	dc.b	$8C, 1, $8D, $87, $60, $4D, $88, $89, $8A, $8B, $8C, 1, $8D, $87, $60, $4D
	dc.b	$CD, $CE, $90, $A5, $A6, $A7, $C8, $C9, $40, $2D, $80, $6D, $9A, $9B, $9C, $CA
	dc.b	$CB, $21, $CC, $2D, $80, $6D, $9A, $9B, $9C, $CA, $CB, $21, $CC, $2D, $80, $6D
	dc.b	$82, $83, $8B, $85, $86, $20, $87, $60, $4D, $88, $89, $8A, $8B, $8C, 1, $8D
	dc.b	$87, $60, $4D, $88, $89, $8A, $8B, $8C, 1, $8D, $87, $60, $4D, $88, $89, $8A
	dc.b	$A5, $A6, $CA, $C8, $C9, $40, $2D, $80, $6D, $9A, $9B, $9C, $CA, $CB, $21, $CC
	dc.b	$2D, $80, $6D, $9A, $9B, $9C, $CA, $CB, $21, $CC, $2D, $80, $6D, $9A, $9B, $9C
	dc.b	$81, $82, $83, $84, $85, $86, $20, $87, $90, $A5, $A6, $A7, $C8, $C9, $40, $2D
	dc.b	$1D, $1E, $1F, $20, $87, $60, $4D, $88, $3D, $3E, $3F, $40, $2D, $80, $6D, $9A
	dc.b	$5D, $5E, $5F, $60, $4D, $88, $89, $8A, $7D, $7E, $7F, $80, $6D, $9A, $9B, $9C
	dc.b	$60, $4D, $88, $89, $8A, $8B, $8C, 1, $AC, $AD, $AE, $AF, $9C, $CA, $CB, $21
	dc.b	$C4, $C5, $C6, $C7, $8C, 1, $8D, $87, $9A, $9B, $9C, $CA, $CB, $21, $CC, $2D
	dc.b	$8B, $8C, 1, $8D, $87, $60, $4D, $88, $CA, $CB, $21, $CC, $2D, $80, $6D, $9A
	dc.b	1, $8D, $87, $60, $4D, $88, $89, $8A, $21, $CC, $2D, $80, $6D, $9A, $9B, $9C
	dc.b	$60, $4D, $88, $89, $8A, $8B, $8C, 1, $80, $6D, $9A, $9B, $9C, $CA, $CB, $21
	dc.b	$88, $89, $8A, $8B, $8C, 1, $8D, $87, $9A, $9B, $9C, $CA, $CB, $21, $CC, $2D
	dc.b	$8B, $8C, 1, $8D, $87, $60, $4D, $88, $CA, $CB, $21, $CC, $2D, $80, $6D, $9A
	dc.b	1, $8D, $41, $8E, $4D, $88, $89, $8A, $21, $CC, $61, $CD, $6D, $9A, $9B, $9C
	dc.b	$60, $4D, $88, $89, $8A, $8B, $8C, 1, $80, $6D, $9A, $9B, $9C, $CA, $CB, $21
	dc.b	$88, $89, $8A, $8B, $8C, 1, $8D, $87, $9A, $9B, $9C, $CA, $CB, $21, $CC, $2D
	dc.b	$8B, $8C, 1, $8D, $87, $60, $4D, $88, $CA, $CB, $21, $CC, $2D, $80, $6D, $9A
	dc.b	$86, $20, $C9, $40, $87, $60, $2D, $80, $88, $89, $9A, $9B, $8A, $8B, $9C, $CA
	dc.b	1, $8D, $21, $CC, $41, $8E, $61, $CD, $81, $82, $90, $A5
byte_1F66C
	dc.b	0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 2, 3, 4, 0, 0, 0
	dc.b	0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 5
	dc.b	6, 7, 8, 9, $A, $B, $C, 0, 0, 0, 0, 0, 0, 0, 0, 0
	dc.b	0, 0, 0, 0, 0, $D, $E, $F, $10, $11, $12, $13, $14, $15, $16, $17
	dc.b	$18, 0, 0, 0, 0, 0, 0, 0, 0, 0, $19, $1A, $1B, $1C, $1D, $1E
	dc.b	$1F, $20, $21, $22, $23, $24, $25, $26, $27, $28, 0, 0, 0, 0, 0, 0
	dc.b	0, 0, $29, $2A, $2B, $2C, $2D, $2E, $2F, $30, $31, $32, $33, $34, $35, $36
	dc.b	$37, $38, 0, 0, 0, 0, 0, 0, 0, 0, $39, $3A, $3B, $3C, $3D, $3E
	dc.b	$3F, $40, $41, $42, $43, $44, $45, $46, $47, 0, 0, 0, 0, 0, 0, 0
	dc.b	0, 0, $48, $49, $4A, $4B, $4C, $4D, $4E, $4F, $50, $51, $52, $53, $54, $55
	dc.b	$56, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, $57, $58, $59, $5A, $5B
	dc.b	$5C, $5D, $5E, $5F, $60, $61, $62, $63, $64, 0, 0, 0, 0, 0, 0, 0
	dc.b	0, 0, $65, $66, $67, $68, $69, $6A, $6B, $6C, $6D, $6E, $6F, $70, $71, $72
	dc.b	0, 0, 0, 0, 0, 0, 0, 0, 0, 0, $73, $74, $75, $76, $77, $78
	dc.b	$79, $7A, $7B, $7C, $7D, $7E, $7F, $80, 0, 0, 0, 0, 0, 0, 0, 0
	dc.b	0, 0, $81, $82, $83, $84, $85, $86, $87, $88, $89, $8A, $8B, $8C, $8D, $8E
	dc.b	$8F, $90, 0, 0, $91, $92, $93, $94, 0, 0, 0, $95, $96, $97, $98, $99
	dc.b	$9A, $9B, $9C, $9D, $9E, $9F, $A0, $A1, $A2, $A3, $A4, 0, $A5, $A6, $A7, $A8
	dc.b	0, 0, 0, $A9, $AA, $AB, $AC, $AD, $AE, $AF, $B0, $B1, $B2, $B3, $B4, $B5
	dc.b	$B6, $B7, $B8, 0, $B9, $BA, $5E, $BB, 0, 0, 0, 0, $BC, $BD, $5E, $BE
	dc.b	$BF, $C0, $C1, $C2, $C3, $C4, $C5, $C6, $C7, $9C, $C8, $C9, $CA, $CB, $CC, $CD
	dc.b	0, 0, 0, 0, $CE, $CF, $D0, $D1, $D2, $D3, $C0, $C0, $D4, $D5, $D6, $D7
	dc.b	$D8, $9C, $D9, $DA, $DB, $DC, $DD, 0, 0, 0, 0, 0, $DE, $DF, $E0, $E1
	dc.b	$E2, $E3, $C0, $E4, $E5, $E6, $E7, $E8, $E9, $EA, $EB, $EC, $ED, $EE, $EF, 0
byte_1F7EC
	dc.b	0, 0, 0, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, $A, $B, $C
	dc.b	$D, 0, $E, $F, $10, $11, 0, 0, 0, 0, 0, 0, 0, $12, $13, $14
	dc.b	$15, $16, $17, $18, $19, $1A, $1B, $1C, $1D, 0, 0, 0, 0, 0, 0, 0
	dc.b	0, 0, 0, 0, 0, 0, 0, $1E, $1F, $20, $21, $22, $23, $24, $25, $26
	dc.b	$27, $28, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, $29, $2A
	dc.b	$2B, $2C, $2D, $2E, $2F, $30, $31, $32, $33, $34, $35, 0, 0, 0, 0, 0
byte_1F84C
	dc.b	$F, $F, $F, $F, $F, $F, $F, $F, $F, $F, $C5, $C6, $C7, $C8, $C9, $CA
	dc.b	$F, $F, $F, $F, $F, $F, $F, $F, $F, $F, $F, $F, $F, $F, $F, $F
	dc.b	$D3, $D3, $D3, $D3, $D3, $D3, $D3, $D3, $D4, $D5, $D6, $D7, $D8, $D8, $D9, $DA
	dc.b	$DB, $DC, $D3, $D3, $D3, $D3, $D3, $D3, $D3, $D3, $D3, $D3, $D3, $D3, $D3, $D3
	dc.b	$DD, $DD, $DD, $DD, $DD, $DD, $DD, $DE, $DF, $D8, $D8, $D8, $D8, $D8, $D8, $D8
	dc.b	$E0, $E1, $E2, $DD, $DD, $DD, $DD, $DD, $DD, $DD, $DD, $DD, $DD, $DD, $DD, $DD
	dc.b	$E3, $E3, $E3, $E3, $E3, $E3, $E3, $E4, $E5, $D8, $D8, $D8, $D8, $D8, $D8, $D8
	dc.b	$D8, $E0, $E6, $E3, $E3, $E3, $E3, $E3, $E3, $E3, $E3, $E3, $E3, $E3, $E3, $E3
byte_1F8CC
	dc.b	$C0, $C1, $C2, $C3, $C4, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
	dc.b	0, 0, 0, 0, 0, 0, 0, $CB, $CC, $CD, $CE, $CF, $D0, $D1, $D2, $F
byte_1F8EC
	dc.b	1, 2, 3, 4, 5, 6, 7, 8, 9, $A, $B, $C, $D, $E, $F, $F
	dc.b	$F, $F, $10, $11, $12, $13, $14, $15, $16, $17, $18, $19, $1A, $1B, $1C, $1D
	dc.b	$1E, $1F, $20, $21, $22, $23, $24, $25, $26, $27, $28, $29, $F, $F, $F, $F
	dc.b	$F, $F, $2A, $2B, $2C, $2D, $2E, $2F, $30, $31, $32, $33, $34, $35, $36, $37
	dc.b	$38, $39, $3A, $3B, $3C, $3D, $3E, $3F, $40, $41, $42, $43, $44, $F, $F, $F
	dc.b	$F, $F, $F, $F, $45, $46, $47, $48, $49, $4A, $4B, $4C, $4D, $4E, $4F, $50
	dc.b	$51, $52, $53, $54, $55, $56, $57, $58, $59, $5A, $5B, $5C, $5D, $F, $F, $F
	dc.b	$F, $F, $5E, $5F, $60, $61, $62, $63, $64, $65, $66, $67, $68, $69, $6A, $6B
	dc.b	$6C, $F, $6D, $F, $6E, $6F, $70, $71, $72, $73, $74, $F, $F, $F, $F, $F
	dc.b	$75, $76, $77, $78, $79, $7A, $7B, $7C, $7D, $7E, $7F, $80, $81, $82, $83, $84
	dc.b	$F, $F, $85, $F, $F, $F, $F, $86, $F, $F, $F, $F, $F, $F, $F, $87
	dc.b	$88, $89, $8A, $8B, $F, $8C, $8D, $8E, $8F, $90, $91, $92, $93, $94, $95, $F
	dc.b	$F, $96, $97, $98, $99, $9A, $9B, $F, $F, $F, $F, $F, $F, $F, $F, $F
	dc.b	$F, $F, $F, $F, $F, $9C, $9D, $9E, $9F, $A0, $F, $A1, $A2, $F, $F, $F
	dc.b	$A3, $A4, $A5, $A6, $A7, $A8, $A9, $AA, $F, $F, $F, $F, $F, $F, $F, $F
	dc.b	$F, $F, $F, $F, $F, $F, $F, $F, $F, $AB, $AC, $AD, $AE, $AF, $B0, $B1
	dc.b	$B2, $B3, $B4, $B5, $F, $F, $F, $F, $F, $F, $F, $F, $F, $F, $F, $F
	dc.b	$F, $F, $F, $F, $F, $F, $B6, $B7, $B8, $B9, $BA, $BB, $BC, $BD, $BE, $BF
	dc.b	$C0, $C1, $C2, $C3, $C4, $F, $F, $F, $F, $F, $C5, $C6, $C7, $C8, $C9, $CA
	dc.b	$F, $F, $F, $F, $F, $F, $F, $CB, $CC, $CD, $CE, $CF, $D0, $D1, $D2, $F
	dc.b	$D3, $D3, $D3, $D3, $D3, $D3, $D3, $D3, $D4, $D5, $D6, $D7, $D8, $D8, $D9, $DA
	dc.b	$DB, $DC, $D3, $D3, $D3, $D3, $D3, $D3, $D3, $D3, $D3, $D3, $D3, $D3, $D3, $D3
	dc.b	$DD, $DD, $DD, $DD, $DD, $DD, $DD, $DE, $DF, $D8, $D8, $D8, $D8, $D8, $D8, $D8
	dc.b	$E0, $E1, $E2, $DD, $DD, $DD, $DD, $DD, $DD, $DD, $DD, $DD, $DD, $DD, $DD, $DD
	dc.b	$E3, $E3, $E3, $E3, $E3, $E3, $E3, $E4, $E5, $D8, $D8, $D8, $D8, $D8, $D8, $D8
	dc.b	$D8, $E0, $E6, $E3, $E3, $E3, $E3, $E3, $E3, $E3, $E3, $E3, $E3, $E3, $E3, $E3
byte_1FA8C
	dc.b	1, 2, 3, 4, 5, 6, 7, 8, 9, $A, $B, $C, $D, $E, $F, $10
	dc.b	$11, $12, $13, $14, $15, $16, $17, $18, $19, $1A, $1B, $1C, $1D, $1E, $1F, $20
	dc.b	$21, $22, $23, $24, $25, $26, $27, $28, $29, $2A, $2B, $2C, $2D, $2E, $2F, $30
	dc.b	$31, $32, $33, $34, $35, $36, $37, $38, $39, $3A, $3B, $3C, $3D, $3E, $3F, $40
	dc.b	$41, $42, $43, $44, $45, $46, $47, $48, $49, $4A, $4B, $4C, $4D, $4E, $4F, $50
	dc.b	$51, $52, $53, $54, $55, $56, $57, $58, $59, $5A, $5B, $5C, $5D, $5E, $5F, $60
	dc.b	$61, $62, $63, $64, $65, $66, $67, $68, $69, $6A, $6B, $6C, $6D, $6E, $6F, $70
	dc.b	$71, $72, $73, $74, $75, $76, $77, $78, $79, $7A, $7B, $7C, $7D, $7E, $7F, $80
	dc.b	$81, $82, $83, $84, $85, $86, $87, $88, $89, $8A, $8B, $8C, $8D, $8E, $8F, $90
	dc.b	$91, $92, $93, $94, $95, $96, $97, $98, $99, $9A, $9B, $9C, $9D, $9E, $9F, $A0
	dc.b	$A1, $A2, $A3, $A4, $A5, $A6, $A7, $A8, $A9, $AA, $AB, $AC, $AD, $AE, $AF, $B0
	dc.b	$B1, $B2, $B3, $B4, $B5, $B6, $B7, $B8, $B9, $BA, $BB, $BC, $BD, $BE, $BF, $C0
	dc.b	$C1, $C2, $C3, $C4, $C5, $C6, $C7, $C8, $C9, $CA, $CB, $CC, $CD, $CE, $CF, $D0
	dc.b	$D1, $D2, $D3, 4, $D4, $D5, $D6, $D7, 4, $D8, $D9, $DA, $DB, $DC, $DD, $DE
byte_1FB6C
	dc.b	$DF, $DF, $DF, $DF, $DF, $DF, $DF, $DF, $DF, $DF, $DF, $DF, $DF, $E0, $DF, $DF
	dc.b	$DF, $DF, $DF, $DF, $DF, $DF, $DF, $DF, $E1, $DF, $E2, $DF, $DF, $DF, $DF, $DF
	dc.b	$DF, $DF, $DF, $DF, $DF, $DF, $DF, $DF, $DF, $DF, $DF, $DF, $DF, $DF, $DF, $DF
	dc.b	$DF, $DF, $DF, $DF, $DF, $DF, $DF, $E3, $DF, $E4, $DF, $DF, $DF, $DF, $E5, $DF
	dc.b	$DF, $DF, $DF, $DF, $DF, $DF, $DF, $DF, $DF, $DF, $DF, $DF, $DF, $DF, $E6, $DF
	dc.b	$E7, $DF, $E8, $E9, $DF, $EA, $DF, $DF, $DF, $DF, $DF, $DF, $DF, $DF, $DF, $DF
	dc.b	$DF, $DF, $DF, $DF, $DF, $DF, $DF, $DF, $DF, $DF, $DF, $DF, $E6, $DF, $DF, $E2
	dc.b	$EB, $DF, $DF, $EC, $ED, $DF, $DF, $E5, $DF, $DF, $DF, $DF, $DF, $DF, $DF, $DF
	dc.b	$DF, $DF, $DF, $DF, $EE, $DF, $E1, $EF, $DF, $F0, $F1, $DF, $EA, $DF, $DF, $DF
	dc.b	$DF, $DF, $E8, $DF, $DF, $ED, $F2, $F3, $E2, $E5, $DF, $DF, $DF, $DF, $DF, $DF
	dc.b	$DF, $DF, $DF, $F4, $F5, $EA, $DF, $DF, $DF, $DF, $DF, $F6, $DF, $DF, $E4, $DF
	dc.b	$DF, $DF, $DF, $DF, $F7, $DF, $DF, $DF, $DF, $DF, $DF, $DF, $DF, $DF, $DF, $DF
	dc.b	$DF, $DF, $DF, $F8, $F9, $DF, $DF, $DF, $FA, $FB, $E0, $FC, $DF, $EA, $DF, $DF
	dc.b	$F4, $F4, $DF, $DF, $DF, $DF, $DF, $DF, $DF, $DF, $DF, $DF, $E2, $DF, $DF, $DF
	dc.b	$DF, $DF, $DF, $DF, $DF, $DF, $DF, $FD, $DF, $E3, $DF, $DF, $DF, $DF, $DF, $DF
	dc.b	$DF, $E3, $DF, $DF, $DF, $DF, $DF, $DF, $DF, $DF, $DF, $DF, $DF, $DF, $DF, $DF
	dc.b	$DF, $DF, $DF, $DF, $DF, $DF, $DF, $DF, $DF, $DF, $DF, $DF, $DF, $DF, $DF, $DF
	dc.b	$FD, $DF, $DF, $DF, $DF, $DF, $DF, $DF, $DF, $DF, $DF, $DF, $DF, $DF, $DF, $DF
	dc.b	$DF, $DF, $DF, $DF, $DF, $DF, $E2, $DF, $FE, $DF, $DF, $DF, $DF, $DF, $DF, $DF
	dc.b	$DF, $EA, $DF, $DF, $DF, $DF, $DF, $DF, $DF, $DF, $DF, $DF, $DF, $DF, $DF, $DF
	dc.b	$DF, $DF, $DF, $DF, $DF, $DF, $DF, $DF, $DF, $DF, $DF, $DF, $DF, $DF, $DF, $DF
	dc.b	$DF, $DF, $DF, $DF, $DF, $DF, $DF, $DF, $DF, $DF, $DF, $DF, $DF, $DF, $DF, $DF
	dc.b	$DF, $DF, $DF, $DF, $DF, $E1, $E3, $DF, $DF, $F2, $DF, $DF, $DF, $DF, $DF, $DF
	dc.b	$DF, $DF, $DF, $DF, $DF, $DF, $DF, $DF, $DF, $DF, $DF, $DF, $DF, $DF, $DF, $DF
	dc.b	$DF, $DF, $DF, $DF, $DF, $DF, $DF, $DF, $DF, $DF, $DF, $DF, $DF, $DF, $DF, $DF
	dc.b	$DF, $DF, $DF, $DF, $DF, $DF, $DF, $DF, $DF, $DF, $DF, $DF, $DF, $DF, $DF, $DF
	dc.b	1, 2, 3, 4, 5, 6, 7, 8, 9, $A, $B, $C, $D, $E, $F, $10
	dc.b	$11, $12, $13, $14, $15, $16, $17, $18, $19, $1A, $1B, $1C, $1D, $1E, $1F, $20
	dc.b	$21, $22, $23, $24, $25, $26, $27, $28, $29, $2A, $2B, $2C, $2D, $2E, $2F, $30
	dc.b	$31, $32, $33, $34, $35, $36, $37, $38, $39, $3A, $3B, $3C, $3D, $3E, $3F, $40
	dc.b	$41, $42, $43, $44, $45, $46, $47, $48, $49, $4A, $4B, $4C, $4D, $4E, $4F, $50
	dc.b	$51, $52, $53, $54, $55, $56, $57, $58, $59, $5A, $5B, $5C, $5D, $5E, $5F, $60
	dc.b	$61, $62, $63, $64, $65, $66, $67, $68, $69, $6A, $6B, $6C, $6D, $6E, $6F, $70
	dc.b	$71, $72, $73, $74, $75, $76, $77, $78, $79, $7A, $7B, $7C, $7D, $7E, $7F, $80
	dc.b	$81, $82, $83, $84, $85, $86, $87, $88, $89, $8A, $8B, $8C, $8D, $8E, $8F, $90
	dc.b	$91, $92, $93, $94, $95, $96, $97, $98, $99, $9A, $9B, $9C, $9D, $9E, $9F, $A0
	dc.b	$A1, $A2, $A3, $A4, $A5, $A6, $A7, $A8, $A9, $AA, $AB, $AC, $AD, $AE, $AF, $B0
	dc.b	$B1, $B2, $B3, $B4, $B5, $B6, $B7, $B8, $B9, $BA, $BB, $BC, $BD, $BE, $BF, $C0
	dc.b	$C1, $C2, $C3, $C4, $C5, $C6, $C7, $C8, $C9, $CA, $CB, $CC, $CD, $CE, $CF, $D0
	dc.b	$D1, $D2, $D3, 4, $D4, $D5, $D6, $D7, 4, $D8, $D9, $DA, $DB, $DC, $DD, $DE
byte_1FDEC
	dc.b	$42, 2, $42, $16, $42, $17, $42, $18, $42, $19, $42, $1A, $42, 2, $42, $16
	dc.b	$42, $17, $42, $1B, $42, $19, $42, $1A, $42, 2, $42, $16, $42, $17, $42, $1B
	dc.b	$42, $19, $42, $1A, $42, 2, $42, $16, $42, $17, $42, $1B, $42, $19, $42, $1A
	dc.b	$42, 2, $42, $16, $42, $17, $42, $1B, $42, $19, $42, $1A, $42, 2, $42, $16
	dc.b	$42, $17, $42, $1B, $42, $19, $42, $1A, $42, 2, $42, $16, $42, $17, $42, $1B
	dc.b	$42, $1C, $42, $1D, $42, $1E, $42, $1F, $42, $1C, $42, $1C, $42, $1C, $42, $1D
	dc.b	$42, $1E, $42, $1F, $42, $1C, $42, $1C, $42, $1C, $42, $1D, $42, $1E, $42, $1F
	dc.b	$42, $1C, $42, $1C, $42, $1C, $42, $1D, $42, $1E, $42, $1F, $42, $1C, $42, $1C
	dc.b	$42, $1C, $42, $1D, $42, $1E, $42, $1F, $42, $1C, $42, $1C, $42, $1C, $42, $1D
	dc.b	$42, $1E, $42, $1F, $42, $1C, $42, $1C, $42, $1C, $42, $1D, $42, $1E, $42, $1F
	dc.b	$42, $20, $42, $21, $42, $22, $42, $23, $42, $24, $42, $25, $42, $26, $42, $27
	dc.b	$42, $22, $42, $28, $42, $29, $42, $25, $42, $26, $42, $27, $42, $22, $42, $28
	dc.b	$42, $29, $42, $25, $42, $26, $42, $27, $42, $22, $42, $28, $42, $29, $42, $25
	dc.b	$42, $26, $42, $27, $42, $22, $42, $28, $42, $29, $42, $25, $42, $26, $42, $27
	dc.b	$42, $22, $42, $28, $42, $29, $42, $25, $42, $26, $42, $27, $42, $22, $42, $28
	dc.b	$42, $2A, $42, $2B, $42, $2C, $42, $2D, $42, $2E, $42, $2F, $42, $30, $42, $2B
	dc.b	$42, $31, $42, $2D, $42, $2E, $42, $2F, $42, $30, $42, $2B, $42, $31, $42, $2D
	dc.b	$42, $2E, $42, $2F, $42, $30, $42, $2B, $42, $31, $42, $2D, $42, $2E, $42, $2F
	dc.b	$42, $30, $42, $2B, $42, $31, $42, $2D, $42, $2E, $42, $2F, $42, $30, $42, $2B
	dc.b	$42, $31, $42, $2D, $42, $2E, $42, $2F, $42, $30, $42, $2B, $42, $31, $42, $2D
	dc.b	$42, $32, $42, $33, $42, $34, $42, $35, $42, $36, $42, $37, $42, $38, $42, $33
	dc.b	$42, $34, $42, $35, $42, $36, $42, $37, $42, $38, $42, $33, $42, $34, $42, $35
	dc.b	$42, $36, $42, $37, $42, $38, $42, $33, $42, $34, $42, $35, $42, $36, $42, $37
	dc.b	$42, $38, $42, $33, $42, $34, $42, $35, $42, $36, $42, $37, $42, $38, $42, $33
	dc.b	$42, $34, $42, $35, $42, $36, $42, $37, $42, $38, $42, $33, $42, $34, $42, $35
	dc.b	$42, $39, $42, $3A, $42, $3B, $42, $3C, $42, $3D, $42, $3E, $42, $39, $42, $3A
	dc.b	$42, $3B, $42, $3C, $42, $3D, $42, $3E, $4A, $3D, $42, $3A, $42, $3B, $42, $3C
	dc.b	$42, $3D, $42, $3E, $42, $39, $42, $3A, $42, $3B, $42, $3C, $42, $3D, $42, $3E
	dc.b	$42, $39, $42, $3A, $42, $3B, $42, $3C, $42, $3D, $42, $3E, $42, $39, $42, $3A
	dc.b	$42, $3B, $42, $3C, $42, $3D, $42, $3E, $42, $39, $42, $3A, $42, $3B, $42, $3C
	dc.b	$42, $3F, $42, $40, $42, $41, $42, $42, $42, $43, $42, $44, $42, $3F, $42, $40
	dc.b	$42, $41, $42, $42, $42, $43, $42, $44, $42, $3F, $42, $40, $42, $41, $42, $42
	dc.b	$42, $43, $42, $44, $42, $3F, $42, $40, $42, $41, $42, $42, $42, $43, $42, $44
	dc.b	$42, $3F, $42, $40, $42, $41, $42, $42, $42, $43, $42, $44, $42, $3F, $42, $40
	dc.b	$42, $41, $42, $42, $42, $43, $42, $44, $42, $3F, $42, $40, $42, $41, $42, $42
	dc.b	$42, $45, $42, $46, $42, $47, $4A, $46, $4A, $45, $42, $48, $42, $45, $42, $46
	dc.b	$42, $47, $4A, $46, $4A, $45, $42, $48, $42, $45, $42, $49, $42, $47, $4A, $46
	dc.b	$4A, $45, $42, $48, $42, $45, $42, $49, $42, $47, $4A, $46, $4A, $45, $42, $48
	dc.b	$42, $45, $42, $46, $42, $47, $4A, $46, $4A, $45, $42, $48, $42, $45, $42, $46
	dc.b	$42, $47, $4A, $46, $4A, $45, $42, $48, $42, $45, $42, $46, $42, $47, $4A, $46
byte_2006C
	dc.b	$42, $4A, $42, $4B, $42, $4C, $42, $4D, $4A, $4A, $42, $4E, $42, $4A, $42, $4F
	dc.b	$42, $50, $42, $51, $4A, $4A, $42, $4E, $42, $4A, $42, $52, $42, $53, $42, $54
	dc.b	$4A, $4A, $42, $4E, $42, $4A, $4A, $51, $4A, $50, $4A, $4F, $4A, $4A, $42, $4E
	dc.b	$42, $4A, $4A, $4D, $4A, $4C, $4A, $4B, $4A, $4A, $42, $4E, $42, $4A, $42, $4B
	dc.b	$42, $4C, $42, $4D, $4A, $4A, $42, $4E, $42, $4A, $42, $4F, $42, $50, $42, $51
	dc.b	$42, $56, $42, $57, $42, $58, $42, $59, $4A, $56, $42, $5A, $42, $56, $42, $5B
	dc.b	$42, $5C, $42, $5D, $4A, $56, $42, $5A, $42, $56, $42, $5E, $42, $5F, $42, $60
	dc.b	$4A, $56, $42, $5A, $42, $56, $4A, $5D, $4A, $5C, $4A, $5B, $4A, $56, $42, $5A
	dc.b	$42, $56, $4A, $59, $4A, $58, $4A, $57, $4A, $56, $42, $5A, $42, $56, $42, $57
	dc.b	$42, $58, $42, $59, $4A, $56, $42, $5A, $42, $56, $42, $5B, $42, $5C, $42, $5D
	dc.b	$42, $62, $42, $63, $42, $64, $4A, $63, $4A, $62, $42, $65, $42, $62, $42, $63
	dc.b	$42, $66, $4A, $63, $4A, $62, $42, $65, $42, $62, $42, $63, $42, $67, $4A, $63
	dc.b	$4A, $62, $42, $65, $42, $62, $42, $68, $42, $69, $4A, $63, $4A, $62, $42, $65
	dc.b	$42, $62, $42, $63, $42, $6A, $4A, $63, $4A, $62, $42, $65, $42, $62, $42, $63
	dc.b	$42, $69, $4A, $63, $4A, $62, $42, $65, $42, $62, $42, $63, $42, $6A, $4A, $63
	dc.b	$42, $6B, $52, $3A, $52, $3B, $52, $3C, $4A, $6B, $42, $6C, $42, $6B, $52, $3A
	dc.b	$52, $3B, $52, $3C, $4A, $6B, $42, $6C, $42, $6B, $52, $3A, $52, $3B, $52, $3C
	dc.b	$4A, $6B, $42, $6C, $42, $6B, $52, $3A, $52, $3B, $52, $3C, $4A, $6B, $42, $6C
	dc.b	$42, $6B, $52, $3A, $52, $3B, $52, $3C, $4A, $6B, $42, $6C, $42, $6B, $52, $3A
	dc.b	$52, $3B, $52, $3C, $4A, $6B, $42, $6C, $42, $6B, $52, $3A, $52, $3B, $52, $3C
byte_201AC
	dc.b	0, 1, 2, 3, 4, 0, 0, 0, 0, 9, $A, $B, $C, 0, 0, 0
	dc.b	0, 0, $13, $14, $15, 0, 0, 0, $1B, $1C, $1D, $1E, $1F, $20, $21, $22
	dc.b	$29, $2A, $2B, $2C, $2D, $2E, $2F, $30, $39, $3A, $3B, $3C, $3D, $3E, $3F, $40
	dc.b	0, 0, $49, $4A, $4B, $4C, 0, 0
byte_201E4
	dc.b	0, 0, 5, 6, 7, 8, 0, 0, 0, 0, $D, $E, $F, $10, $11, $12
	dc.b	0, 0, 0, $16, $17, $18, $19, $1A, 0, $23, $24, $25, $26, $27, $28, 0
	dc.b	$31, $32, $33, $34, $35, $36, $37, $38, $41, $42, $43, $44, $45, $46, $47, $48
	dc.b	$4D, $4E, $4F, $50, $51, $52, $53, $54
byte_2021C
	dc.b	0, 1, 2, 3, 4, 0, 0, 0, 0, 9, $A, $B, $C, 0, 0, 0
	dc.b	0, 0, $13, $14, $15, 0, 0, 0, $1B, $1C, $1D, $1E, $1F, $20, $21, $22
	dc.b	$29, $2A, $2B, $2C, $2D, $2E, $2F, $30, $39, $3A, $3B, $3C, $3D, $3E, $3F, $40
	dc.b	0, 0, $49, $4A, $4B, $4C, 0, 0
byte_20254
	dc.b	0, 0, 5, 6, 7, 8, 0, 0, 0, 0, $D, $E, $F, $10, $11, $12
	dc.b	0, 0, 0, $16, $17, $18, $19, $1A, 0, $23, $24, $25, $26, $27, $28, 0
	dc.b	$31, $32, $33, $34, $35, $36, $37, $38, $41, $42, $43, $44, $45, $46, $47, $48
	dc.b	$4D, $4E, $4F, $50, $51, $52, $53, $54, 5, 6, $13, $14, $15, $16, $17, $16
	dc.b	$1C, 5, 2, $A, 1, 2, 3, $F, $10, 2, 7, 8, 2, 6, $33, $34
	dc.b	$35, $3C, 5, $F, $10, $D, $E, 3, 2, 6, $33, $34, $35, $36, $37, $36
	dc.b	$3C, 5, 1, 2, 6, 5, 3, $11, $12, 2, 4, 1, 2, 3, 4, 3
	dc.b	4, 1, 2, $11, $12, 4, 3, 3, 2, 6, 0, 0, 0, 0, 0, 0
	dc.b	0, 0, 0, 0, 0, 0, $13, $14, $15, $16, $17, $16, $17, $18, $19, $1A
	dc.b	$1B, $1C, 0, 0, 0, 0, 0, 0, $1B, $1C, 0, 0, 0, 0, 0, 0
	dc.b	0, 0, 0, 0, 0, 0, $33, $34, $35, $36, $37, $36, $37, $38, $39, $3A
	dc.b	$3B, $3C, 0, 0, 0, 0, 0, 0, $3B, $3C, 0, 0, 0, 0, 0, 0
	dc.b	0, 0, 0, 0, 0, 0, $1D, 0, 0, 0, 0, 5, 6, 0, 0, 0
	dc.b	0, $1D, 0, 0, 0, 0, 0, 0, 5, 6, 0, 0, 0, 0, 0, 0
	dc.b	0, 0, 0, 0, 0, 0, $1D, 0, 0, 0, 0, 5, 6, 0, 0, 0
	dc.b	0, $1D, 0, 0, 0, 0, 0, 0, $10, 6, 0, 0, 0, 0, 0, 0
	dc.b	0, 0, 0, 0, 0, 0, $1D, 0, 0, 0, 0, 5, 6, 0, 0, 0
	dc.b	0, $1D, 0, 0, 0, 0, 0, 0, $12, 6, 0, 0, 0, 0, 0, 0
	dc.b	0, 0, 0, 0, 0, 0, $1D, 0, 0, 0, 0, 5, 6, 0, 0, 0
	dc.b	0, $1D, 0, 0, 0, 0, 0, 0, 5, 6, 0, 0, 0, 0, 0, 0
	dc.b	0, 0, 0, 0, 0, 0, $1D, 0, 0, 0, 0, 5, 6, 0, 0, 0
	dc.b	0, $1D, 0, 0, 0, 0, 0, 0, $1B, $1C, 0, 0, 0, 0, 0, 0
	dc.b	0, 0, 0, 0, 0, 0, $1D, 0, 0, 0, 0, 5, 6, 0, 0, 0
	dc.b	0, $1D, 0, 0, 0, 0, 0, 0, $3B, $3C, 0, 0, 0, 0, 0, 0
	dc.b	0, 0, 0, 0, 0, 0, 5, 1, 6, 5, $F, $10, $B, $C, 4, 1
	dc.b	2, 6, 0, 0, 0, 0, 0, 0, 2, 6, 0, 0, 0, 0, 0, 0
	dc.b	0, 0, 0, 0, 0, 0, 5, 1, 2, 3, $11, $12, $D, $E, 7, 8
	dc.b	2, 6, 0, 0, 0, 0, 0, 0, 9, 6, 0, 0, 0, 0, 0, 0
	dc.b	0, 0, 0, 0, 0, 0, $1D, 0, 0, 0, 0, 0, 0, 0, 0, 0
	dc.b	0, $1D, 0, 0, 0, 0, 0, 0, $A, 6, 0, 0, 0, 0, 0, 0
	dc.b	0, 0, 0, 0, 0, 0, $1D, 0, 0, 0, 0, 0, 0, 0, 0, 0
	dc.b	0, $1D, 0, 0, 0, 0, 0, 0, 2, 4, 1, 2, 3, 4, 3, 6
	dc.b	6, 5, 1, 2, 3, 6, $13, $14, 0, 0, 0, 0, 0, 0, $33, $34
	dc.b	0, 0, 0, 0, 0, 0, 5, 1, 0, 0, 0, 0, 0, 0, 5, 9
	dc.b	0, 0, 0, 0, 0, 0, 5, $A, 0, 0, 0, 0, 0, 0, $13, $14
	dc.b	0, 0, 0, 0, 0, 0, $33, $34, 0, 0, 0, 0, 0, 0, 5, 6
	dc.b	0, 0, 0, 0, 0, 0, 5, 6, 0, 0, 0, 0, 0, 0, 5, 1
	dc.b	0, 0, 0, 0, 0, 0, 5, $F, 0, 0, 0, 0, 0, 0, 5, $11
	dc.b	0, 0, 0, 0, 0, 0, 5, 6, 5, 6, 0, 0, 0, 0, 0, 0
	dc.b	0, 0, 0, 0, 0, 0, $1D, 0, 0, 0, 0, 0, 0, 0, 0, 0
	dc.b	0, $1D, 0, 0, 0, 0, 0, 0, 5, 6, 0, 0, 0, 0, 0, 0
	dc.b	0, 0, 0, 0, 0, 0, $1D, 0, 0, 0, 0, 0, 0, 0, 0, 0
	dc.b	0, $1D, 0, 0, 0, 0, 0, 0, 2, 6, 0, 0, 0, 0, 0, 0
	dc.b	0, 0, 0, 0, 0, 0, $1D, 0, 0, 0, 0, 0, 0, 0, 0, 0
	dc.b	0, $1D, 0, 0, 0, 0, 0, 0, 5, 6, 0, 0, 0, 0, 0, 0
	dc.b	0, 0, 0, 0, 0, 0, $1D, 0, 0, 0, 0, 0, 0, 0, 0, 0
	dc.b	0, $1D, 0, 0, 0, 0, 0, 0, $1B, $1C, 0, 0, 0, 0, 0, 0
	dc.b	0, 0, 0, 0, 0, 0, $1D, 0, 0, 0, 0, 0, 0, 0, 0, 0
	dc.b	0, $1D, 0, 0, 0, 0, 0, 0, $3B, $3C, 0, 0, 0, 0, 0, 0
	dc.b	0, 0, 0, 0, 0, 0, 5, $B, $C, 9, 3, 6, $13, $14, $15, $1A
	dc.b	$1B, $1C, 0, 0, 0, 0, 0, 0, 5, 6, 0, 0, 0, 0, 0, 0
	dc.b	0, 0, 0, 0, 0, 0, 5, $D, $E, $A, 2, 6, $33, $34, $35, $3A
	dc.b	$3B, $3C, 0, 0, 0, 0, 0, 0, $10, 6, 0, 0, 0, 0, 0, 0
	dc.b	0, 0, 0, 0, 0, 0, $13, $14, $15, $16, $17, $18, $1B, $1C, 5, 2
	dc.b	4, 6, 0, 0, 0, 0, 0, 0, $12, 6, 0, 0, 0, 0, 0, 0
	dc.b	0, 0, 0, 0, 0, 0, $33, $34, $35, $36, $37, $38, $3B, $3C, 5, 7
	dc.b	8, 6, 0, 0, 0, 0, 0, 0, 5, 6, 0, 0, 0, 0, 0, 0
	dc.b	0, 0, 0, 0, 0, 0, 5, 4, 1, 3, 2, 4, 4, 4, 1, $F
	dc.b	$10, 6, 0, 0, 0, 0, 0, 0, $1B, $1C, 0, 0, 0, 0, 0, 0
	dc.b	0, 0, 0, 0, 0, 0, 5, $B, $C, 3, 2, 4, 4, 4, 1, $11
	dc.b	$12, 6, 0, 0, 0, 0, 0, 0, $3B, $3C, 0, 0, 0, 0, 0, 0
	dc.b	0, 0, 0, 0, 0, 0, 5, $D, $E, 6, 5, 4, 1, 9, 2, 4
	dc.b	2, 6, 0, 0, 0, 0, 0, 0, $1B, $18, $15, $14, $15, $16, $17, $18
	dc.b	$19, $15, $16, $1A, $1B, $18, $15, $1A, $1B, $1C, 5, $F, $10, $A, 6, $13
	dc.b	$1B, $18, $15, $14, $15, $16, $17, $18, $3B, $38, $35, $34, $35, $36, $37, $38
	dc.b	$39, $35, $36, $3A, $3B, $38, $35, $34, $3B, $3C, 5, $11, $12, 4, 6, $33
	dc.b	$3B, $38, $35, $34, $35, $36, $37, $38, 0, 0, 0, 0, 0, 0, 5, $F
	dc.b	0, 0, 0, 0, 0, 0, 5, $11, 0, 0, 0, 0, 0, 0, 5, 6
	dc.b	0, 0, 0, 0, 0, 0, 5, 2, 0, 0, 0, 0, 0, 0, $13, $14
	dc.b	0, 0, 0, 0, 0, 0, $33, $34, 0, 0, 0, 0, 0, 0, 5, 9
	dc.b	0, 0, 0, 0, 0, 0, 5, $A, 0, 0, 0, 0, 0, 0, 5, 2
	dc.b	0, 0, 0, 0, 0, 0, $13, $14, 0, 0, 0, 0, 0, 0, $33, $34
	dc.b	0, 0, 0, 0, 0, 0, 5, 6, $19, $15, $16, $1A, $1B, $18, $15, $1A
	dc.b	$39, $35, $36, $3A, $3B, $38, $35, $34, $52, $53, $54, $55, $56, $57, $58, $59
	dc.b	$5A, $55, $56, $57, $58, $59, $5A, $55, $56, $57, $58, $59, $5A, $55, $56, $57
	dc.b	$58, $59, $5A, $55, $56, $57, $58, $59, $5C, $49, $4A, $4B, $4C, $4D, $4E, $4F
	dc.b	$50, $4B, $4C, $4D, $4E, $4F, $50, $4B, $4C, $4D, $4E, $4F, $50, $4B, $4C, $4D
	dc.b	$4E, $4F, $50, $4B, $4C, $4D, $4E, $4F, $52, $53, $54, $55, $56, $57, $58, $59
	dc.b	$5A, $55, $56, $57, $58, $59, $5A, $55, $56, $57, $58, $59, $5A, $55, $56, $57
	dc.b	$58, $59, $5A, $55, $56, $57, $58, $59, $5C, $49, $4A, $41, $42, $43, $44, $45
	dc.b	$46, $41, $42, $43, $44, $45, $50, $4B, $4C, $4D, $4E, $4F, $50, $4B, $4C, $4D
	dc.b	$4E, $4F, $50, $41, $42, $43, $44, $45, $52, $53, $54, $21, $22, $23, $24, $25
	dc.b	$26, $21, $22, $23, $24, $25, $5A, $55, $56, $57, $58, $59, $5A, $55, $56, $57
	dc.b	$58, $59, $5A, $21, $22, $23, $24, $25, $5C, $49, $4A, $41, $42, $43, $44, $45
	dc.b	$46, $41, $42, $43, $44, $45, $50, $4B, $42, $43, $44, $4F, $50, $4B, $42, $43
	dc.b	$44, $4F, $50, $41, $42, $43, $44, $45, $52, $53, $54, $21, $22, $23, $24, $25
	dc.b	$26, $21, $22, $23, $24, $25, $5A, $55, $22, $23, $24, $59, $5A, $55, $22, $23
	dc.b	$24, $59, $5A, $21, $22, $23, $24, $25, $5C, $49, $4A, $41, $42, $43, $44, $45
	dc.b	$46, $41, $42, $43, $44, $45, $50, $4B, $42, $43, $44, $4F, $50, $4B, $42, $43
	dc.b	$44, $4F, $50, $41, $42, $43, $44, $45, $52, $53, $54, $21, $22, $23, $24, $25
	dc.b	$26, $21, $22, $23, $24, $25, $5A, $55, $22, $23, $24, $59, $5A, $55, $22, $23
	dc.b	$24, $59, $5A, $21, $22, $23, $24, $25, $5C, $49, $4A, $41, $42, $43, $44, $45
	dc.b	$46, $41, $42, $43, $44, $45, $50, $4B, $42, $43, $44, $4F, $50, $4B, $42, $43
	dc.b	$44, $4F, $50, $41, $42, $43, $44, $45, $52, $53, $54, $21, $22, $23, $24, $25
	dc.b	$26, $21, $22, $23, $24, $25, $5A, $55, $56, $57, $58, $59, $5A, $55, $56, $57
	dc.b	$58, $59, $5A, $21, $22, $23, $24, $25, $5C, $49, $4A, $41, $42, $43, $44, $45
	dc.b	$46, $41, $42, $43, $44, $45, $50, $4B, $4C, $4D, $4E, $4F, $50, $4B, $4C, $4D
	dc.b	$4E, $4F, $50, $41, $42, $43, $44, $45, $52, $53, $54, $21, $22, $23, $24, $25
	dc.b	$26, $21, $22, $23, $24, $25, $5A, $55, $56, $57, $58, $59, $5A, $55, $56, $57
	dc.b	$58, $59, $5A, $21, $22, $23, $24, $25, $5C, $49, $4A, $41, $42, $43, $44, $45
	dc.b	$46, $41, $42, $43, $44, $45, $50, $4B, $42, $43, $44, $45, $46, $41, $42, $43
	dc.b	$44, $4F, $50, $41, $42, $43, $44, $45, $5A, $55, $56, $57, $58, $59, $5A, $5B
	dc.b	$50, $4B, $4C, $4D, $4E, $4F, $50, $51, $5A, $55, $56, $57, $58, $59, $5A, $5B
	dc.b	$46, $41, $42, $43, $44, $45, $50, $51, $26, $21, $22, $23, $24, $25, $5A, $5B
	dc.b	$46, $41, $42, $43, $44, $45, $50, $51, $26, $21, $22, $23, $24, $25, $5A, $5B
	dc.b	$46, $41, $42, $43, $44, $45, $50, $51, $26, $21, $22, $23, $24, $25, $5A, $5B
	dc.b	$46, $41, $42, $43, $44, $45, $50, $51, $26, $21, $22, $23, $24, $25, $5A, $5B
	dc.b	$46, $41, $42, $43, $44, $45, $50, $51, $26, $21, $22, $23, $24, $25, $5A, $5B
	dc.b	$46, $41, $42, $43, $44, $45, $50, $51, $52, $53, $54, $21, $22, $23, $24, $25
	dc.b	$26, $21, $22, $23, $24, $25, $5A, $55, $22, $23, $24, $25, $26, $21, $22, $23
	dc.b	$24, $25, $5A, $21, $22, $23, $24, $25, $5C, $49, $4A, $41, $42, $43, $44, $45
	dc.b	$46, $41, $42, $43, $44, $45, $50, $4B, $42, $43, $44, $45, $46, $41, $42, $43
	dc.b	$44, $45, $50, $41, $42, $43, $44, $45, $52, $53, $54, $21, $22, $23, $24, $25
	dc.b	$26, $21, $22, $23, $24, $25, $5A, $55, $22, $23, $24, $25, $26, $21, $22, $23
	dc.b	$24, $59, $5A, $21, $22, $23, $24, $25, $5C, $49, $4A, $41, $42, $43, $44, $45
	dc.b	$46, $41, $42, $43, $44, $45, $50, $4B, $42, $43, $44, $45, $46, $41, $42, $43
	dc.b	$44, $45, $50, $41, $42, $43, $44, $45, $52, $53, $54, $21, $22, $23, $24, $25
	dc.b	$26, $21, $22, $23, $24, $25, $5A, $55, $22, $23, $24, $25, $26, $21, $22, $23
	dc.b	$24, $25, $5A, $21, $22, $23, $24, $25, $5C, $49, $4A, $41, $42, $43, $44, $45
	dc.b	$46, $41, $42, $43, $44, $45, $50, $4B, $42, $43, $44, $45, $46, $41, $42, $43
	dc.b	$44, $45, $50, $41, $42, $43, $44, $45, $52, $53, $54, $21, $22, $23, $24, $25
	dc.b	$26, $21, $22, $23, $24, $25, $5A, $55, $56, $57, $58, $59, $5A, $55, $56, $57
	dc.b	$58, $59, $5A, $21, $22, $23, $24, $25, $5C, $49, $4A, $41, $42, $43, $44, $45
	dc.b	$46, $41, $42, $43, $44, $45, $50, $4B, $4C, $4D, $4E, $4F, $50, $4B, $4C, $4D
	dc.b	$4E, $4F, $50, $41, $42, $43, $44, $45, $52, $53, $54, $21, $22, $23, $24, $25
	dc.b	$26, $21, $22, $23, $24, $25, $5A, $55, $56, $57, $58, $59, $5A, $55, $56, $57
	dc.b	$58, $59, $5A, $21, $22, $23, $24, $25, $5C, $49, $4A, $41, $42, $43, $44, $45
	dc.b	$46, $41, $42, $43, $44, $45, $50, $4B, $4C, $4D, $4E, $4F, $50, $4B, $4C, $4D
	dc.b	$4E, $4F, $50, $41, $42, $43, $44, $45, $52, $53, $54, $21, $22, $23, $24, $25
	dc.b	$26, $21, $22, $23, $24, $25, $5A, $55, $56, $57, $58, $59, $5A, $55, $56, $57
	dc.b	$58, $59, $5A, $21, $22, $23, $24, $25, $5C, $49, $4A, $41, $42, $43, $44, $45
	dc.b	$46, $41, $42, $43, $44, $45, $50, $4B, $4C, $4D, $4E, $4F, $50, $4B, $4C, $4D
	dc.b	$4E, $4F, $50, $41, $42, $43, $44, $45, $52, $53, $54, $55, $56, $57, $58, $59
	dc.b	$5A, $55, $56, $57, $58, $59, $5A, $55, $56, $57, $58, $59, $5A, $55, $56, $57
	dc.b	$58, $59, $5A, $55, $56, $57, $58, $59, $5C, $49, $4A, $4B, $4C, $4D, $4E, $4F
	dc.b	$50, $4B, $4C, $4D, $4E, $4F, $50, $4B, $4C, $4D, $4E, $4F, $50, $4B, $4C, $4D
	dc.b	$4E, $4F, $50, $4B, $4C, $4D, $4E, $4F, $26, $21, $22, $23, $24, $25, $5A, $5B
	dc.b	$46, $41, $42, $43, $44, $45, $50, $51, $26, $21, $22, $23, $24, $25, $5A, $5B
	dc.b	$46, $41, $42, $43, $44, $45, $50, $51, $26, $21, $22, $23, $24, $25, $5A, $5B
	dc.b	$46, $41, $42, $43, $44, $45, $50, $51, $26, $21, $22, $23, $24, $25, $5A, $5B
	dc.b	$46, $41, $42, $43, $44, $45, $50, $51, $26, $21, $22, $23, $24, $25, $5A, $5B
	dc.b	$46, $41, $42, $43, $44, $45, $50, $51, $26, $21, $22, $23, $24, $25, $5A, $5B
	dc.b	$46, $41, $42, $43, $44, $45, $50, $51, $5A, $55, $56, $57, $58, $59, $5A, $5B
	dc.b	$50, $4B, $4C, $4D, $4E, $4F, $50, $51
byte_20B4C
	dc.b	$17, $18, $19, $1A, $1B, $1C, $1D, $1E, $E7, $E6, $E5, $E4, $E3, $E2, $1F, $20
	dc.b	$21, $22, $23, $24, $EC, $EB, $EA, $E9, $E8, $25, $19, $1A, $1B, $1C, $1D, $1E
	dc.b	$26, $27, $28, $29, $2A, $2B, $2C, $2D, $F4, $F3, $F2, $F1, $F0, $EF, $2E, $2F
	dc.b	$30, $31, $32, $33, $F9, $F8, $F7, $F6, $F5, $34, $28, $29, $2A, $2B, $2C, $2D
	dc.b	$35, $DF, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, $36, $37
	dc.b	$38, $39, 0, 0, 0, 0, $FC, $FB, $FA, $3A, 0, 0, 0, 0, 0, 0
	dc.b	$3B, $3C, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, $3D, $3E
	dc.b	$3F, $40, $41, $41, $41, $41, $FF, $FE, $FD, $42, 0, 0, 0, 0, 0, 0
	dc.b	$43, $44, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, $36, 0
	dc.b	0, 0, 0, $45, $46, 0, 0, 0, 0, $47, 0, 0, 0, 0, 0, 0
	dc.b	$48, $49, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, $3D, 0
	dc.b	0, 0, 0, $4A, $4B, 0, 0, 0, 0, $4C, 0, 0, 0, 0, 0, 0
	dc.b	$3B, $3C, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, $36, 0
	dc.b	0, 0, 0, $45, $46, 0, 0, 0, 0, $47, 0, 0, 0, 0, 0, 0
	dc.b	$43, $44, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, $3D, 0
	dc.b	0, 0, 0, $4A, $4B, 0, 0, 0, 0, $47, 0, 0, 0, 0, 0, 0
	dc.b	$48, $49, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, $36, 0
	dc.b	0, 0, 0, $45, $46, 0, 0, 0, 0, $4C, 0, 0, 0, 0, 0, 0
	dc.b	$3B, $3C, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, $3D, 0
	dc.b	0, 0, 0, $4A, $4B, 0, 0, 0, 0, $47, 0, 0, 0, 0, 0, 0
	dc.b	$43, $44, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, $4D, $4E
	dc.b	$4F, $4E, $4F, $4E, $4F, $4E, $4F, $4E, $4F, $50, 0, 0, 0, 0, 0, 0
	dc.b	$48, $49, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, $51, $52
	dc.b	$53, $52, $53, $52, $53, $52, $53, $52, $53, $54, 0, 0, 0, 0, 0, 0
	dc.b	$3B, $3C, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, $36, 0
	dc.b	0, 0, 0, 0, 0, 0, 0, 0, 0, $47, 0, 0, 0, 0, 0, 0
	dc.b	$43, $44, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, $3D, 0
	dc.b	0, 0, 0, 0, 0, 0, 0, 0, 0, $4C, 0, 0, 0, 0, 0, 0
	dc.b	$48, $49, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, $36, 0
	dc.b	0, 0, 0, 0, 0, 0, 0, 0, 0, $47, 0, 0, 0, 0, 0, 0
	dc.b	$3B, $3C, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, $3D, 0
	dc.b	0, 0, 0, 0, 0, 0, 0, 0, 0, $4C, 0, 0, 0, 0, 0, 0
	dc.b	$43, $44, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, $36, 0
	dc.b	0, 0, 0, 0, 0, 0, 0, 0, 0, $47, 0, 0, 0, 0, 0, 0
	dc.b	$48, $49, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, $3D, 0
	dc.b	0, 0, 0, 0, 0, 0, 0, 0, 0, $4C, 0, 0, 0, 0, 0, 0
	dc.b	$3B, $3C, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, $36, 0
	dc.b	0, 0, 0, 0, 0, 0, 0, 0, 0, $47, 0, 0, 0, 0, 0, 0
	dc.b	$43, $44, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, $57, $58
	dc.b	$5A, $5C, $5E, $5F, $60, $61, $62, $63, $64, $47, 0, 0, 0, 0, 0, 0
	dc.b	$48, $49, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, $65, $66
	dc.b	0, 0, 0, 0, 0, $67, $68, $69, $6A, $54, 0, 0, 0, 0, 0, 0
	dc.b	$3B, $3C, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, $6B, $6C
	dc.b	0, 0, 0, 0, 0, $6D, $6E, $6F, $70, $71, 0, 0, 0, 0, 0, 0
	dc.b	$43, $44, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, $72, 0
	dc.b	0, 0, 0, 0, 0, 0, 0, $73, $74, $54, 0, 0, 0, 0, 0, 0
	dc.b	$48, $49, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, $75, 0
	dc.b	0, 0, 0, 0, 0, 0, 0, $76, $77, $78, 0, 0, 0, 0, 0, 0
	dc.b	$3B, $3C, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, $79, $7A
	dc.b	$7B, 0, 0, 0, 0, 0, 0, 0, 0, $7C, 0, 0, 0, 0, 0, 0
	dc.b	$43, $44, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, $7D, $7E
	dc.b	$7F, 0, 0, 0, 0, 0, 0, 0, 0, $80, 0, 0, 0, 0, 0, 0
	dc.b	$48, $49, 9, $B, 9, $B, 9, $B, 9, $B, 9, $B, 9, $B, $81, $82
	dc.b	$83, $84, $85, $86, $87, $88, $89, $8A, $8B, $8C, 9, $B, 9, $B, 9, $B
	dc.b	$3B, $3C, $A, $C, $A, $C, $A, $C, $A, $C, $A, $C, $A, $C, $8D, $8E
	dc.b	$8F, $90, $91, $5D, $92, $5B, $59, $56, $55, $78, $A, $C, $A, $C, $A, $C
byte_20ECC
	dc.b	$E7, $E6, $E5, $E4, $E3, $E2, $E1, $E0, $F4, $F3, $F2, $F1, $F0, $EF, $EE, $ED
	dc.b	0, 0, 0, 0, 0, 0, $35, $DF, 0, 0, 0, 0, 0, 0, $3B, $3C
	dc.b	0, 0, 0, 0, 0, 0, $43, $44, 0, 0, 0, 0, 0, 0, $48, $49
	dc.b	0, 0, 0, 0, 0, 0, $3B, $3C, 0, 0, 0, 0, 0, 0, $43, $44
	dc.b	0, 0, 0, 0, 0, 0, $48, $49, 0, 0, 0, 0, 0, 0, $3B, $3C
	dc.b	0, 0, 0, 0, 0, 0, $43, $44, 0, 0, 0, 0, 0, 0, $48, $49
	dc.b	0, 0, 0, 0, 0, 0, $3B, $3C, 0, 0, 0, 0, 0, 0, $43, $44
	dc.b	0, 0, 0, 0, 0, 0, $48, $49, 0, 0, 0, 0, 0, 0, $3B, $3C
	dc.b	0, 0, 0, 0, 0, 0, $43, $44, 0, 0, 0, 0, 0, 0, $48, $49
	dc.b	0, 0, 0, 0, 0, 0, $3B, $3C, 0, 0, 0, 0, 0, 0, $43, $44
	dc.b	0, 0, 0, 0, 0, 0, $48, $49, 0, 0, 0, 0, 0, 0, $3B, $3C
	dc.b	0, 0, 0, 0, 0, 0, $43, $44, 0, 0, 0, 0, 0, 0, $48, $49
	dc.b	0, 0, 0, 0, 0, 0, $3B, $3C, 0, 0, 0, 0, 0, 0, $43, $44
	dc.b	9, $B, 9, $B, 9, $B, $48, $49, $A, $C, $A, $C, $A, $C, $3B, $3C
byte_20FAC
	dc.b	1, 3, $19, $1A, $1B, $1C, $1D, $1E, $E7, $E6, $E5, $E4, $E3, $E2, 1, 3
	dc.b	1, 3, 1, 3, 1, 3, 1, 3, 1, 3, $19, $1A, $1B, $1C, $1D, $1E
	dc.b	3, 3, $28, $29, $2A, $2B, $2C, $2D, $F4, $F3, $F2, $F1, $F0, $EF, 3, 1
	dc.b	3, 1, 3, 1, 3, 1, 3, 1, 3, 1, $28, $29, $2A, $2B, $2C, $2D
	dc.b	1, 1, 1, 3, 1, 3, 1, 3, 1, 3, 1, 3, 1, 3, 1, 3
	dc.b	1, 3, 1, 3, 1, 3, 1, 3, 1, 3, 3, 3, 1, 3, 1, 3
	dc.b	2, 1, 2, 8, 6, 8, 6, 8, 6, 8, 6, 8, 6, 8, 1, 2
	dc.b	1, 3, 1, 3, 1, 3, 1, 3, 1, 3, 2, 8, 6, 8, 6, 8
	dc.b	1, 2, 1, 7, 5, 7, 5, 7, 5, 7, 5, 7, 5, 7, 2, 1
	dc.b	3, 1, 3, 1, 3, 1, 3, 1, 3, 2, 1, 7, 5, 7, 5, 7
	dc.b	2, 1, 2, 8, 6, 8, 6, 8, 6, 8, 6, 8, 6, 8, 1, 2
	dc.b	8, 6, 8, 2, 1, 2, 8, 6, 8, 1, 2, 8, 6, 8, 6, 8
	dc.b	1, 2, 1, 7, 5, 7, 5, 7, 5, 7, 5, 7, 5, 7, 2, 1
	dc.b	7, 5, 7, 1, 2, 1, 7, 5, 7, 2, 1, 7, 5, 7, 5, 7
	dc.b	2, 1, 2, 8, 6, 8, 6, 8, 6, 8, 6, 8, 6, 8, 1, 2
	dc.b	8, 6, 8, 2, 1, 2, 8, 6, 8, 1, 2, 8, 6, 8, 6, 8
	dc.b	1, 2, 1, 7, 5, 7, 5, 7, 5, 7, 5, 7, 5, 7, 2, 1
	dc.b	7, 5, 7, 1, 2, 1, 7, 5, 7, 2, 1, 7, 5, 7, 5, 7
	dc.b	2, 1, 2, 8, 6, 8, 6, 8, 6, 8, 6, 8, 6, 8, 1, 2
	dc.b	8, 6, 8, 2, 1, 2, 8, 6, 8, 1, 2, 8, 6, 8, 6, 8
	dc.b	1, 2, 1, 7, 5, 7, 5, 7, 5, 7, 5, 7, 5, 7, 2, 1
	dc.b	3, 1, 3, 1, 3, 1, 3, 1, 3, 2, 1, 7, 5, 7, 5, 7
	dc.b	2, 1, 2, 8, 6, 8, 6, 8, 6, 8, 6, 8, 6, 8, 1, 2
	dc.b	1, 3, 1, 3, 1, 3, 1, 3, 2, 1, 2, 8, 6, 8, 6, 8
	dc.b	1, 2, 1, 7, 5, 7, 5, 7, 5, 7, 5, 7, 5, 7, 2, 1
	dc.b	3, 1, 3, 1, 3, 1, 3, 1, 3, 2, 1, 7, 5, 7, 5, 7
	dc.b	2, 1, 2, 8, 6, 8, 6, 8, 6, 8, 6, 8, 6, 8, 1, 2
	dc.b	8, 6, 8, 6, 8, 6, 8, 6, 8, 1, 2, 8, 6, 8, 6, 8
	dc.b	1, 2, 1, 7, 5, 7, 5, 7, 5, 7, 5, 7, 5, 7, 2, 1
	dc.b	7, 5, 7, 5, 7, 5, 7, 5, 7, 2, 1, 7, 5, 7, 5, 7
	dc.b	2, 1, 2, 8, 6, 8, 6, 8, 6, 8, 6, 8, 6, 8, 1, 2
	dc.b	8, 6, 8, 6, 8, 6, 8, 6, 8, 1, 2, 8, 6, 8, 6, 8
	dc.b	1, 2, 1, 7, 5, 7, 5, 7, 5, 7, 5, 7, 5, 7, 2, 1
	dc.b	7, 5, 7, 5, 7, 5, 7, 5, 7, 2, 1, 7, 5, 7, 5, 7
	dc.b	2, 1, 2, 8, 6, 8, 6, 8, 6, 8, 6, 8, 6, 8, 1, 2
	dc.b	8, 6, 8, 6, 8, 6, 8, 6, 8, 1, 2, 8, 6, 8, 6, 8
	dc.b	1, 2, 1, 7, 5, 7, 5, 7, 5, 7, 5, 7, 5, 7, 2, 1
	dc.b	7, 5, 7, 5, 7, 5, 7, 5, 7, 2, 1, 7, 5, 7, 5, 7
	dc.b	2, 1, 2, 8, 6, 8, 6, 8, 6, 8, 6, 8, 6, 8, 1, 2
	dc.b	1, 3, 1, 3, 1, 3, 1, 3, 1, 1, 2, 8, 6, 8, 6, 8
	dc.b	1, 2, 1, 7, 5, 7, 5, 7, 5, 7, 5, 7, 5, 7, 2, 1
	dc.b	3, 1, 3, 1, 3, 1, 3, 1, 3, 2, 1, 7, 5, 7, 5, 7
	dc.b	2, 1, 2, 8, 6, 8, 6, 8, 6, 8, 6, 8, 6, 8, 1, 2
	dc.b	1, 3, 1, 3, 1, 3, 1, 3, 1, 1, 2, 8, 6, 8, 6, 8
	dc.b	1, 2, 1, 7, 5, 7, 5, 7, 5, 7, 5, 7, 5, 7, 2, 1
	dc.b	3, 1, 3, 1, 3, 1, 3, 1, 3, 2, 1, 7, 5, 7, 5, 7
	dc.b	2, 1, 2, 8, 6, 8, 6, 8, 6, 8, 6, 8, 6, 8, 1, 2
	dc.b	1, 3, 1, 3, 1, 3, 1, 3, 1, 1, 2, 8, 6, 8, 6, 8
	dc.b	1, 2, 1, 7, 5, 7, 5, 7, 5, 7, 5, 7, 5, 7, 2, 1
	dc.b	3, 1, 3, 1, 3, 1, 3, 1, 3, 2, 1, 7, 5, 7, 5, 7
	dc.b	2, 1, 2, 8, 6, 8, 6, 8, 6, 8, 6, 8, 6, 8, 1, 2
	dc.b	1, 3, 1, 3, 1, 3, 1, 3, 1, 1, 2, 8, 6, 8, 6, 8
	dc.b	1, 2, 1, 7, 5, 7, 5, 7, 5, 7, 5, 7, 5, 7, 2, 1
	dc.b	3, 1, 3, 1, 3, 1, 3, 1, 3, 2, 1, 7, 5, 7, 5, 7
	dc.b	2, 1, 2, 8, 6, 8, 6, 8, 6, 8, 6, 8, 6, 8, 1, 2
	dc.b	1, 3, 1, 3, 1, 3, 1, 3, 1, 1, 2, 8, 6, 8, 6, 8
byte_2132C
	dc.b	$E7, $E6, $E5, $E4, $E3, $E2, 1, 3, $F4, $F3, $F2, $F1, $F0, $EF, 3, 1
	dc.b	1, 3, 1, 3, 1, 3, 1, 3, 6, 8, 6, 8, 6, 8, 6, 8
	dc.b	5, 7, 5, 7, 5, 7, 5, 7, 6, 8, 6, 8, 6, 8, 6, 8
	dc.b	5, 7, 5, 7, 5, 7, 5, 7, 6, 8, 6, 8, 6, 8, 6, 8
	dc.b	5, 7, 5, 7, 5, 7, 5, 7, 6, 8, 6, 8, 6, 8, 6, 8
	dc.b	5, 7, 5, 7, 5, 7, 5, 7, 6, 8, 6, 8, 6, 8, 6, 8
	dc.b	5, 7, 5, 7, 5, 7, 5, 7, 6, 8, 6, 8, 6, 8, 6, 8
	dc.b	5, 7, 5, 7, 5, 7, 5, 7, 6, 8, 6, 8, 6, 8, 6, 8
	dc.b	5, 7, 5, 7, 5, 7, 5, 7, 6, 8, 6, 8, 6, 8, 6, 8
	dc.b	5, 7, 5, 7, 5, 7, 5, 7, 6, 8, 6, 8, 6, 8, 6, 8
	dc.b	5, 7, 5, 7, 5, 7, 5, 7, 6, 8, 6, 8, 6, 8, 6, 8
	dc.b	5, 7, 5, 7, 5, 7, 5, 7, 6, 8, 6, 8, 6, 8, 6, 8
	dc.b	5, 7, 5, 7, 5, 7, 5, 7, 6, 8, 6, 8, 6, 8, 6, 8
	dc.b	5, 7, 5, 7, 5, 7, 5, 7, 6, 8, 6, 8, 6, 8, 6, 8
byte_2140C
	dc.b	$1D, $1E, $1F, $20, $15, $16, $25, $26, $27, $28, 5, 6, $1D, $1E, $1F, $20
	dc.b	$D, $E, $1D, $1E, $1F, $20, $15, $16, $1D, $1E, $1F, $20, 5, 6, $25, $26
	dc.b	$21, $22, $23, $24, $17, $18, $29, $2A, $2B, $2C, 7, 8, $21, $22, $23, $24
	dc.b	$F, $10, $21, $22, $23, $24, $17, $18, $21, $22, $23, $24, 7, 8, $29, $2A
	dc.b	9, $A, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, $11, $2E
	dc.b	$31, $32, $35, $36, $31, $32, $35, $36, $39, $1A, 0, 0, 0, 0, 0, 0
	dc.b	$B, $C, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, $2F, $30
	dc.b	$33, $34, $37, $30, $33, $34, $37, $30, $33, $3C, 0, 0, 0, 0, 0, 0
	dc.b	3, 3, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 3, 0
	dc.b	0, 0, 0, 5, 6, 0, 0, 0, 0, 3, 0, 0, 0, 0, 0, 0
	dc.b	4, 4, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 4, 0
	dc.b	0, 0, 0, 7, 8, 0, 0, 0, 0, 4, 0, 0, 0, 0, 0, 0
	dc.b	$D, $E, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0
	dc.b	0, 0, 0, 1, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0
	dc.b	$F, $10, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 0
	dc.b	0, 0, 0, 2, 2, 0, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0
	dc.b	$11, $12, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 3, 0
	dc.b	0, 0, 0, 5, 6, 0, 0, 0, 0, 3, 0, 0, 0, 0, 0, 0
	dc.b	$13, $14, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 4, 0
	dc.b	0, 0, 0, 7, 8, 0, 0, 0, 0, 4, 0, 0, 0, 0, 0, 0
	dc.b	$15, $16, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 9, $A
	dc.b	$D, $E, $15, $16, $D, $E, $15, $16, 9, $A, 0, 0, 0, 0, 0, 0
	dc.b	$17, $18, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, $B, $C
	dc.b	$F, $10, $17, $18, $F, $10, $17, $18, $B, $C, 0, 0, 0, 0, 0, 0
	dc.b	$19, $1A, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 3, 0
	dc.b	0, 0, 0, 0, 0, 0, 0, 0, 0, 3, 0, 0, 0, 0, 0, 0
	dc.b	$1B, $1C, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 4, 0
	dc.b	0, 0, 0, 0, 0, 0, 0, 0, 0, 4, 0, 0, 0, 0, 0, 0
byte_215CC
	dc.b	$AA, $50, 5, $55, $5A, $A5, $55, $50, $AA, $50, 5, $55, $5A, $A5, $55, $50
	dc.b	$A, 0, 0, 0, 0, 0, 0, 0, $A, 0, 0, 0, 0, 0, 0, 0
	dc.b	6, 0, 0, $10, 0, 0, 4, 0, 6, 0, 0, $10, 0, 0, 4, 0
	dc.b	$A, 0, 0, 0, $80, 2, 0, 0, $A, 0, 0, 0, $80, 2, 0, 0
	dc.b	$A, 0, 0, $10, $80, 2, 4, 0, $A, 0, 0, $10, $80, 2, 4, 0
	dc.b	$A, 0, 0, $50, $A0, $A, 5, 0, $A, 0, 0, $50, $A0, $A, 5, 0
	dc.b	$A, 0, 0, 0, 0, 0, 0, 0, $A, 0, 0, 0, 0, 0, 0, 0
byte_2163C
	dc.b	$27, $28, $D, $E, $1D, $1E, $1F, $20, $2B, $2C, $F, $10, $21, $22, $23, $24
	dc.b	0, 0, 0, 0, 0, 0, 9, $A, 0, 0, 0, 0, 0, 0, $B, $C
	dc.b	0, 0, 0, 0, 0, 0, 3, 3, 0, 0, 0, 0, 0, 0, 4, 4
	dc.b	0, 0, 0, 0, 0, 0, $15, $16, 0, 0, 0, 0, 0, 0, $17, $18
	dc.b	0, 0, 0, 0, 0, 0, $19, $1A, 0, 0, 0, 0, 0, 0, $1B, $1C
	dc.b	0, 0, 0, 0, 0, 0, $D, $E, 0, 0, 0, 0, 0, 0, $F, $10
	dc.b	0, 0, 0, 0, 0, 0, $11, $12, 0, 0, 0, 0, 0, 0, $13, $14
byte_216AC
	dc.b	5, $AA, 5, $AA, 0, $A0, 0, $A0, 0, $90, 0, $90, 0, $A0, 0, $A0
	dc.b	0, $A0, 0, $A0, 0, $A0, 0, $A0, 0, $A0, 0, $A0
byte_216C8
	dc.b	3, 3, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 0
	dc.b	0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0
	dc.b	4, 4, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 4, 0
	dc.b	0, 0, 0, 0, 0, 0, 0, 0, 0, 4, 0, 0, 0, 0, 0, 0
	dc.b	9, $A, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 0
	dc.b	0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0
	dc.b	$B, $C, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 3, 0
	dc.b	0, 0, 0, 0, 0, 0, 0, 0, 0, 3, 0, 0, 0, 0, 0, 0
	dc.b	$D, $E, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 4, 0
	dc.b	0, 0, 0, 0, 0, 0, 0, 0, 0, 4, 0, 0, 0, 0, 0, 0
	dc.b	$F, $10, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 4
	dc.b	2, 4, 2, 2, 2, 2, 4, 2, 4, 2, 0, 0, 0, 0, 0, 0
	dc.b	$11, $12, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 3, 1
	dc.b	$25, $26, $27, $28, $1D, $1E, $1F, $20, 1, 3, 0, 0, 0, 0, 0, 0
	dc.b	$13, $14, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 4, 2
	dc.b	$29, $2A, $2B, $2C, $21, $22, $23, $24, 2, 4, 0, 0, 0, 0, 0, 0
	dc.b	$15, $16, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 3
	dc.b	5, 6, 5, 6, 9, $A, 9, $A, 3, 1, 0, 0, 0, 0, 0, 0
	dc.b	$17, $18, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 4
	dc.b	7, 8, 7, 8, $B, $C, $B, $C, 4, 2, 0, 0, 0, 0, 0, 0
	dc.b	$19, $1A, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 3, 1
	dc.b	$25, $26, $27, $28, $1D, $1E, $1F, $20, 1, 3, 0, 0, 0, 0, 0, 0
	dc.b	$1B, $1C, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 4, 2
	dc.b	$29, $2A, $2B, $2C, $21, $22, $23, $24, 2, 4, 0, 0, 0, 0, 0, 0
	dc.b	5, 6, $25, $26, $27, $28, $1D, $1E, $1F, $20, $25, $26, $27, $28, 5, 6
	dc.b	$2D, $2E, $31, $32, $35, $36, $39, $3A, 5, 6, $25, $26, $27, $28, $1D, $1E
	dc.b	7, 8, $29, $2A, $2B, $2C, $21, $22, $23, $24, $29, $2A, $2B, $2C, 7, 8
	dc.b	$2F, $30, $33, $34, $37, $38, $3B, $3C, 7, 8, $29, $2A, $2B, $2C, $21, $22
byte_21888
	dc.b	6, 0, 0, 0, 0, 0, 0, 0, 6, 0, 0, $20, 0, 0, 8, 0
	dc.b	0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
	dc.b	0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, $50, $10, 4, 5, 0
	dc.b	0, 0, 0, 0, $AA, $55, 0, 0, 0, 0, 0, 0, $AA, $55, 0, 0
	dc.b	0, 0, 0, $A0, 5, $50, $A, 0, 0, 0, 0, $A0, 5, $50, $A, 0
	dc.b	0, 0, 0, $50, 0, 0, 5, 0, 0, 0, 0, $50, 0, 0, 5, 0
	dc.b	$AA, $5A, $55, 5, $AA, $AA, $50, $55, $AA, $5A, $55, 5, $AA, $AA, $50, $55
byte_218F8
	dc.b	0, 0, 0, 0, 0, 0, 3, 3, 0, 0, 0, 0, 0, 0, 4, 4
	dc.b	0, 0, 0, 0, 0, 0, 9, $A, 0, 0, 0, 0, 0, 0, $B, $C
	dc.b	0, 0, 0, 0, 0, 0, $15, $16, 0, 0, 0, 0, 0, 0, $17, $18
	dc.b	0, 0, 0, 0, 0, 0, $19, $1A, 0, 0, 0, 0, 0, 0, $1B, $1C
	dc.b	0, 0, 0, 0, 0, 0, $D, $E, 0, 0, 0, 0, 0, 0, $F, $10
	dc.b	0, 0, 0, 0, 0, 0, $11, $12, 0, 0, 0, 0, 0, 0, $13, $14
	dc.b	$1F, $20, $25, $26, $27, $28, 5, 6, $23, $24, $29, $2A, $2B, $2C, 7, 8
byte_21968
	dc.b	0, $90, 0, $90, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
	dc.b	0, 0, 0, 0, 0, 0, 0, 0, $A5, $AA, $A5, $AA
byte_21984
	dc.b	$70, $71, $70, $71, $70, $71, $70, $71, $70, $71, $70, $71, $70, $71, $70, $71
	dc.b	$70, $71, $70, $71, $70, $71, $70, $71, $70, $71, $70, $71, $70, $71, $70, $71
	dc.b	$72, $73, $72, $73, $72, $73, $72, $73, $72, $73, $72, $73, $72, $73, $72, $73
	dc.b	$72, $73, $72, $73, $72, $73, $72, $73, $72, $73, $72, $73, $72, $73, $72, $73
	dc.b	$70, $71, $70, $71, $70, $71, $70, $71, $70, $71, $70, $71, $70, $71, $70, $71
	dc.b	$70, $71, $70, $71, $70, $71, $70, $71, $70, $71, $70, $71, $70, $71, $70, $71
	dc.b	$72, $73, $72, $6F, $6E, $6F, $6E, $6F, $6E, $6F, $6E, $6F, $6E, $6F, $72, $73
	dc.b	$72, $73, $72, $73, $72, $73, $72, $73, $72, $73, $72, $6F, $6E, $6F, $6E, $6F
	dc.b	$70, $71, $70, $6D, $6C, $6D, $6C, $6D, $6C, $6D, $6C, $6D, $6C, $6D, $70, $71
	dc.b	$70, $71, $70, $71, $70, $71, $70, $71, $70, $71, $70, $6D, $6C, $6D, $6C, $6D
	dc.b	$72, $73, $72, $6F, $6E, $6F, $6E, $6F, $6E, $6F, $6E, $6F, $6E, $6F, $72, $73
	dc.b	$6E, $6F, $6E, $73, $72, $73, $6E, $6F, $6E, $73, $72, $6F, $6E, $6F, $6E, $6F
	dc.b	$70, $71, $70, $6D, $6C, $6D, $6C, $6D, $6C, $6D, $6C, $6D, $6C, $6D, $70, $71
	dc.b	$6C, $6D, $6C, $71, $70, $71, $6C, $6D, $6C, $71, $70, $6D, $6C, $6D, $6C, $6D
	dc.b	$72, $73, $72, $6F, $6E, $6F, $6E, $6F, $6E, $6F, $6E, $6F, $6E, $6F, $72, $73
	dc.b	$6E, $6F, $6E, $73, $72, $73, $6E, $6F, $6E, $73, $72, $6F, $6E, $6F, $6E, $6F
	dc.b	$70, $71, $70, $6D, $6C, $6D, $6C, $6D, $6C, $6D, $6C, $6D, $6C, $6D, $70, $71
	dc.b	$6C, $6D, $6C, $71, $70, $71, $6C, $6D, $6C, $71, $70, $6D, $6C, $6D, $6C, $6D
	dc.b	$72, $73, $72, $6F, $6E, $6F, $6E, $6F, $6E, $6F, $6E, $6F, $6E, $6F, $72, $73
	dc.b	$6E, $6F, $6E, $73, $72, $73, $6E, $6F, $6E, $73, $72, $6F, $6E, $6F, $6E, $6F
	dc.b	$70, $71, $70, $6D, $6C, $6D, $6C, $6D, $6C, $6D, $6C, $6D, $6C, $6D, $70, $71
	dc.b	$70, $71, $70, $71, $70, $71, $70, $71, $70, $71, $70, $6D, $6C, $6D, $6C, $6D
	dc.b	$72, $73, $72, $6F, $6E, $6F, $6E, $6F, $6E, $6F, $6E, $6F, $6E, $6F, $72, $73
	dc.b	$72, $73, $72, $73, $72, $73, $72, $73, $72, $73, $72, $6F, $6E, $6F, $6E, $6F
	dc.b	$70, $71, $70, $6D, $6C, $6D, $6C, $6D, $6C, $6D, $6C, $6D, $6C, $6D, $70, $71
	dc.b	$70, $71, $70, $71, $70, $71, $70, $71, $70, $71, $70, $6D, $6C, $6D, $6C, $6D
	dc.b	$72, $73, $72, $6F, $6E, $6F, $6E, $6F, $6E, $6F, $6E, $6F, $6E, $6F, $72, $73
	dc.b	$6E, $6F, $6E, $6F, $6E, $6F, $6E, $6F, $6E, $73, $72, $6F, $6E, $6F, $6E, $6F
byte_21B44
	dc.b	$70, $71, $70, $71, $70, $71, $70, $71, $72, $73, $72, $73, $72, $73, $72, $73
	dc.b	$70, $71, $70, $71, $70, $71, $70, $71, $6E, $6F, $6E, $6F, $6E, $6F, $72, $73
	dc.b	$6C, $6D, $6C, $6D, $6C, $6D, $70, $71, $6E, $6F, $6E, $6F, $6E, $6F, $72, $73
	dc.b	$6C, $6D, $6C, $6D, $6C, $6D, $70, $71, $6E, $6F, $6E, $6F, $6E, $6F, $72, $73
	dc.b	$6C, $6D, $6C, $6D, $6C, $6D, $70, $71, $6E, $6F, $6E, $6F, $6E, $6F, $72, $73
	dc.b	$6C, $6D, $6C, $6D, $6C, $6D, $70, $71, $6E, $6F, $6E, $6F, $6E, $6F, $72, $73
	dc.b	$6C, $6D, $6C, $6D, $6C, $6D, $70, $71, $6E, $6F, $6E, $6F, $6E, $6F, $72, $73
byte_21BB4
	dc.b	$70, $71, $70, $6D, $6C, $6D, $6C, $6D, $6C, $6D, $6C, $6D, $6C, $6D, $70, $71
	dc.b	$6C, $6D, $6C, $6D, $6C, $6D, $6C, $6D, $6C, $71, $70, $6D, $6C, $6D, $6C, $6D
	dc.b	$72, $73, $72, $6F, $6E, $6F, $6E, $6F, $6E, $6F, $6E, $6F, $6E, $6F, $72, $73
	dc.b	$6E, $6F, $6E, $6F, $6E, $6F, $6E, $6F, $6E, $73, $72, $6F, $6E, $6F, $6E, $6F
	dc.b	$70, $71, $70, $6D, $6C, $6D, $6C, $6D, $6C, $6D, $6C, $6D, $6C, $6D, $70, $71
	dc.b	$6C, $6D, $6C, $6D, $6C, $6D, $6C, $6D, $6C, $71, $70, $6D, $6C, $6D, $6C, $6D
	dc.b	$72, $73, $72, $6F, $6E, $6F, $6E, $6F, $6E, $6F, $6E, $6F, $6E, $6F, $72, $73
	dc.b	$6E, $6F, $6E, $6F, $6E, $6F, $6E, $6F, $6E, $73, $72, $6F, $6E, $6F, $6E, $6F
	dc.b	$70, $71, $70, $6D, $6C, $6D, $6C, $6D, $6C, $6D, $6C, $6D, $6C, $6D, $70, $71
	dc.b	$6C, $6D, $6C, $6D, $6C, $6D, $6C, $6D, $6C, $71, $70, $6D, $6C, $6D, $6C, $6D
	dc.b	$72, $73, $72, $6F, $6E, $6F, $6E, $6F, $6E, $6F, $6E, $6F, $6E, $6F, $72, $73
	dc.b	$72, $73, $72, $73, $72, $73, $72, $73, $72, $73, $72, $6F, $6E, $6F, $6E, $6F
	dc.b	$70, $71, $70, $6D, $6C, $6D, $6C, $6D, $6C, $6D, $6C, $6D, $6C, $6D, $70, $71
	dc.b	$70, $71, $70, $71, $70, $71, $70, $71, $70, $71, $70, $6D, $6C, $6D, $6C, $6D
	dc.b	$72, $73, $72, $6F, $6E, $6F, $6E, $6F, $6E, $6F, $6E, $6F, $6E, $6F, $72, $73
	dc.b	$72, $73, $72, $73, $72, $73, $72, $73, $72, $73, $72, $6F, $6E, $6F, $6E, $6F
	dc.b	$70, $71, $70, $6D, $6C, $6D, $6C, $6D, $6C, $6D, $6C, $6D, $6C, $6D, $70, $71
	dc.b	$70, $71, $70, $71, $70, $71, $70, $71, $70, $71, $70, $6D, $6C, $6D, $6C, $6D
	dc.b	$72, $73, $72, $6F, $6E, $6F, $6E, $6F, $6E, $6F, $6E, $6F, $6E, $6F, $72, $73
	dc.b	$72, $73, $72, $73, $72, $73, $72, $73, $72, $73, $72, $6F, $6E, $6F, $6E, $6F
	dc.b	$70, $71, $70, $6D, $6C, $6D, $6C, $6D, $6C, $6D, $6C, $6D, $6C, $6D, $70, $71
	dc.b	$70, $71, $70, $71, $70, $71, $70, $71, $70, $71, $70, $6D, $6C, $6D, $6C, $6D
	dc.b	$72, $73, $72, $6F, $6E, $6F, $6E, $6F, $6E, $6F, $6E, $6F, $6E, $6F, $72, $73
	dc.b	$72, $73, $72, $73, $72, $73, $72, $73, $72, $73, $72, $6F, $6E, $6F, $6E, $6F
	dc.b	$70, $71, $70, $6D, $6C, $6D, $6C, $6D, $6C, $6D, $6C, $6D, $6C, $6D, $70, $71
	dc.b	$70, $71, $70, $71, $70, $71, $70, $71, $70, $71, $70, $6D, $6C, $6D, $6C, $6D
	dc.b	$72, $73, $72, $6F, $6E, $6F, $6E, $6F, $6E, $6F, $6E, $6F, $6E, $6F, $72, $73
	dc.b	$72, $73, $72, $73, $72, $73, $72, $73, $72, $73, $72, $6F, $6E, $6F, $6E, $6F
byte_21D74
	dc.b	$6C, $6D, $6C, $6D, $6C, $6D, $70, $71, $6E, $6F, $6E, $6F, $6E, $6F, $72, $73
	dc.b	$6C, $6D, $6C, $6D, $6C, $6D, $70, $71, $6E, $6F, $6E, $6F, $6E, $6F, $72, $73
	dc.b	$6C, $6D, $6C, $6D, $6C, $6D, $70, $71, $6E, $6F, $6E, $6F, $6E, $6F, $72, $73
	dc.b	$6C, $6D, $6C, $6D, $6C, $6D, $70, $71, $6E, $6F, $6E, $6F, $6E, $6F, $72, $73
	dc.b	$6C, $6D, $6C, $6D, $6C, $6D, $70, $71, $6E, $6F, $6E, $6F, $6E, $6F, $72, $73
	dc.b	$6C, $6D, $6C, $6D, $6C, $6D, $70, $71, $6E, $6F, $6E, $6F, $6E, $6F, $72, $73
	dc.b	$6C, $6D, $6C, $6D, $6C, $6D, $70, $71, $6E, $6F, $6E, $6F, $6E, $6F, $72, $73
byte_21DE4
	dc.b	1, 2, 3, 4, 5, 6, 7, 8, 9, $A, $B, 0, $C, $D, $E, $F
	dc.b	$10, $11, $12, $13, $14, $15, $16, $17, $18, $19, $1A, $1B, $1C, $1D, $1E, $1F
	dc.b	$20, $21, $22, $23, $24, $25, $26, $27, $28, $29, $2A, $2B, $2C, $2D, $2E, $2F
byte_21E14
	dc.b	$29, $3B, $4D, $5F, $71, $83, $95, $A7, $18, $29, $3B, $4D, $5F, $71, $83, $95
	dc.b	$A7, 0
byte_21E26
	dc.b	$18, $11, $12, $13, $14, $15, $16, $17, $18, $11, $12, $13, $14, $15, $16, $17
	dc.b	$18, $11, $12, $13, $14, $15, $16, $29, $22, $23, $24, $25, $26, $27, $28, $29
	dc.b	$22, $23, $24, $25, $26, $27, $28, $29, $22, $23, $24, $25, $26, $27, $3B, $34
	dc.b	$35, $36, $37, $38, $39, $3A, $3B, $34, $35, $36, $37, $38, $39, $3A, $3B, $34
	dc.b	$35, $36, $37, $38, $39, $4D, $46, $47, $48, $49, $4A, $4B, $4C, $4D, $46, $47
	dc.b	$48, $49, $4A, $4B, $4C, $4D, $46, $47, $48, $49, $4A, $4B, $5F, $58, $59, $5A
	dc.b	$5B, $5C, $5D, $5E, $5F, $58, $59, $5A, $5B, $5C, $5D, $5E, $5F, $58, $59, $5A
	dc.b	$5B, $5C, $5D, $71, $6A, $6B, $6C, $6D, $6E, $6F, $70, $71, $6A, $6B, $6C, $6D
	dc.b	$6E, $6F, $70, $71, $6A, $6B, $6C, $6D, $6E, $6F, $83, $7C, $7D, $7E, $7F, $80
	dc.b	$81, $82, $83, $7C, $7D, $7E, $7F, $80, $81, $82, $83, $7C, $7D, $7E, $7F, $80
	dc.b	$81, $95, $8E, $8F, $90, $91, $92, $93, $94, $95, $8E, $8F, $90, $91, $92, $93
	dc.b	$94, $95, $8E, $8F, $90, $91, $92, $93
byte_21EDE
	dc.b	0, 0, 0, 0, 0, 0, 1, 2, 0, 0, 0, 0, 0, 0, 0, 3
	dc.b	4, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 5
	dc.b	6, 7, 8, 9, $A, $B, $C, 7, 8, 9, $D, 7, 8, $E, $F, 7
	dc.b	8, 9, $D, $10, $C, 7, 8, 9, $D, $11, $12, 0, 0, $13, $14, $15
	dc.b	$16, $17, $18, $19, $1A, $15, $16, $17, $18, $15, $16, $17, $18, $15, $16, $17
	dc.b	$18, $1B, $1C, $15, $16, $17, $18, $1D, $1E, 0, 0, $1F, $20, $21, $21, $21
	dc.b	$21, $21, $21, $21, $21, $21, $21, $21, $21, $21, $21, $21, $21, $21, $21, $22
	dc.b	$23, $21, $21, $21, $21, $24, $25, 0, 0, $26, $27, $21, $80, $81, $82, $83
	dc.b	$84, $85, $86, $87, $88, $89, $8A, $8B, $8C, $8D, $8E, $8F, $90, $91, $92, $93
	dc.b	$94, $95, $96, $28, $27, 0, 0, $29, $2A, $2B, $A0, $A1, $A2, $A3, $A4, $A5
	dc.b	$A6, $A7, $A8, $A9, $AA, $AB, $AC, $AD, $AE, $AF, $B0, $B1, $B2, $B3, $B4, $B5
	dc.b	$B6, $2C, $2D, 0, 0, $2E, $2F, $30, $21, $21, $21, $21, $21, $21, $21, $21
	dc.b	$21, $21, $21, $21, $21, $21, $21, $21, $21, $21, $21, $21, $21, $21, $21, $31
	dc.b	$32, 0, $33, $34, $35, $21, $21, $21, $21, $21, $21, $21, $21, $21, $21, $21
	dc.b	$21, $21, $21, $21, $21, $21, $21, $21, $21, $21, $21, $21, $21, $36, $35, 0
	dc.b	$37, $38, $39, $21, $21, $21, $21, $21, $21, $21, $21, $21, $21, $21, $21, $21
	dc.b	$21, $21, $21, $21, $21, $21, $21, $21, $21, $21, $21, $3A, $39, 0, 0, $29
	dc.b	$2D, $21, $21, $21, $21, $21, $21, $21, $21, $21, $21, $21, $21, $21, $21, $21
	dc.b	$21, $21, $21, $21, $21, $21, $21, $21, $3B, $3C, $3D, $3E, 0, $2E, $32, $21
	dc.b	$21, $21, $21, $21, $21, $21, $21, $21, $21, $21, $21, $21, $21, $21, $21, $21
	dc.b	$21, $21, $21, $21, $21, $21, $3F, $40, $41, $42, 0, $43, $35, $21, $21, $21
	dc.b	$21, $21, $21, $21, $21, $21, $21, $21, $21, $21, $21, $21, $21, $21, $21, $21
	dc.b	$21, $21, $21, $21, $21, $36, $35, 0, 0, $44, $39, $21, $21, $21, $21, $21
	dc.b	$21, $21, $21, $21, $21, $21, $21, $21, $21, $21, $21, $21, $21, $21, $21, $21
	dc.b	$21, $21, $21, $3A, $39, 0, 0, $45, $46, $21, $21, $21, $21, $21, $21, $21
	dc.b	$21, $21, $21, $21, $21, $21, $21, $21, $21, $21, $21, $21, $21, $21, $21, $21
	dc.b	$21, $47, $46, 0, 0, $48, $25, $21, $21, $21, $21, $21, $21, $21, $21, $21
	dc.b	$21, $21, $21, $21, $21, $21, $21, $21, $21, $21, $21, $21, $21, $21, $21, $49
	dc.b	$4A, $4B, 0, $43, $35, $21, $21, $21, $21, $21, $21, $21, $21, $21, $21, $21
	dc.b	$21, $21, $21, $21, $21, $21, $21, $21, $21, $21, $21, $21, $21, $36, $4C, $4D
	dc.b	0, $44, $39, $21, $21, $21, $21, $21, $21, $21, $21, $21, $21, $21, $21, $21
	dc.b	$21, $21, $21, $21, $21, $21, $21, $21, $21, $21, $21, $3A, $39, 0, 0, $4E
	dc.b	$4F, $21, $21, $21, $21, $21, $21, $21, $21, $21, $21, $21, $21, $21, $21, $21
	dc.b	$21, $21, $21, $21, $21, $21, $21, $21, $21, $50, $4F, 0, 0, $51, $52, $21
	dc.b	$21, $21, $21, $21, $21, $21, $53, $54, $21, $21, $21, $21, $21, $21, $21, $21
	dc.b	$21, $21, $21, $21, $21, $21, $21, $55, $56, 0, 0, $57, $58, 7, 8, 9
	dc.b	$D, 7, 8, 9, $59, $5A, $C, 7, 8, 9, $D, 7, 8, 9, $D, $10
	dc.b	$C, 9, $D, $10, $C, $5B, $5C, 0, 0, $5D, $5E, $5F, $60, $61, $62, $63
	dc.b	$64, $61, $62, $65, $66, $5F, $61, $62, $62, $5F, $60, $61, $62, $65, $63, $64
	dc.b	$62, $65, $66, $67, $68, 0, 0, 0, 0, 0, 0, 0, 0, $69, $6A, 0
	dc.b	0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, $69, $6A, 0, 0
	dc.b	0, 0, 0, 0
byte_22172
	dc.b	1, $70, 1, $71, 1, $72, 1, $73, 1, $74, 1, $75, 1, $76, 1, $77
	dc.b	1, $78, 1, $79, 1, $7A, 1, $7B, 1, $7C, 1, $72, 1, $7D, 1, $7E
	dc.b	1, $7F, 1, $80, 1, $72, 1, $7D, 1, $81, 1, $82, 1, $74, 1, $83
	dc.b	1, $84, 1, $85, 1, $86, 1, $87, 1, $88, 1, $89, 1, $8A, 1, $8B
	dc.b	1, $8C, 1, $8D, 1, $8E, 1, $8F, 1, $90, 1, $86, 1, $91, 1, $92
	dc.b	1, $93, 1, $94, 1, $86, 1, $91, 1, $95, 1, $96, 1, $88, 1, $97
	dc.b	1, $98, 1, $99, 1, $9A, 0, $DD, 1, $9B, 1, $9C, 0, $C1, 1, $9D
	dc.b	0, $C1, 1, $9E, 1, $9F, 1, $9F, 1, $A0, 1, $9A, 0, $DD, 1, $A1
	dc.b	9, $A1, 1, $A2, 1, $9A, 0, $DD, 1, $9B, 0, $DD, 1, $9B, 1, $A0
byte_22202
	dc.b	1, $A3, 1, $A4, 1, $A5, 1, $A6, 1, $A7, 1, $A8, 1, $A9, 1, $70
	dc.b	1, $AA, 0, 0, 0, 0, 1, $AB, 1, $AC, 1, $A5, 1, $A6, 1, $7E
	dc.b	1, $7F, 1, $80, 1, $72, 1, $7D, 1, $81, 1, $82, 1, $74, 1, $83
	dc.b	1, $AD, $11, $A4, 1, $AE, 1, $AF, $11, $7E, 1, $B0, 1, $B1, 1, $84
	dc.b	1, $B2, 1, $B3, 0, 0, 1, $B4, 1, $B5, 1, $AE, 1, $AF, 1, $92
	dc.b	1, $93, 1, $94, 1, $86, 1, $91, 1, $95, 1, $B6, 1, $88, 1, $97
	dc.b	8, $C1, 9, $A1, 1, $B7, 0, 0, 0, 0, 1, $B8, $19, $7E, 1, $98
	dc.b	1, $99, 1, $B9, 0, 0, 1, $BA, 1, $A0, 1, $B7, 0, 0, 1, $A1
	dc.b	9, $A1, 1, $A2, 1, $9A, 0, $DD, 1, $9B, 0, $DD, 1, $9B, 1, $A0
byte_22292
	dc.b	0, $D1, 1, $74, 1, $BB, 1, $BC, 1, $BD, 1, $74, 1, $BE, 1, $7A
	dc.b	1, $BF, 1, $72, 1, $C0, 1, $C1, 1, $70, 1, $C2, 1, $74, 1, $83
	dc.b	1, $7E, 1, $7F, 1, $80, 1, $72, 1, $7D, 1, $81, 1, $82, 1, $74
	dc.b	1, $83, 1, $C3, 1, $88, 1, $C4, 1, $C5, 1, $C6, 1, $88, 1, $C7
	dc.b	1, $8E, 1, $C8, 1, $86, 1, $C9, 1, $CA, 1, $84, 1, $CB, 1, $88
	dc.b	1, $97, 1, $92, 1, $93, 1, $94, 1, $86, 1, $91, 1, $95, 1, $B6
	dc.b	1, $88, 1, $97, 0, 0, 1, $9B, 1, $9C, 0, $C1, 1, $CC, 1, $9B
	dc.b	1, $9F, 1, $9F, 1, $A0, 1, $9A, 1, $CD, 1, $A0, 1, $98, 1, $99
	dc.b	1, $9B, 1, $A0, 1, $A1, 9, $A1, 1, $A2, 1, $9A, 0, $DD, 1, $9B
	dc.b	0, $DD, 1, $9B, 1, $A0
byte_22328
	dc.b	$10, $E2, 1, $72, 1, $7D, 1, $A5, 1, $CE, 1, $CF, 1, $D0, 1, $7C
	dc.b	1, $72, 1, $D1, 1, $D2, 1, $D3, 1, $70, 1, $AA, 1, $D4, 1, $86
	dc.b	1, $91, 1, $AE, 1, $AF, 1, $D5, 1, $D6, 1, $90, 1, $86, 1, $D7
	dc.b	1, $D8, 1, $D9, 1, $84, 1, $B2, 0, 0, 1, $9A, 1, $DA, 1, $B7
	dc.b	0, 0, 9, $B9, 1, $DB, 1, $A0, 1, $9A, 1, $DC, 1, $DD, 1, $CC
	dc.b	1, $98, 1, $DE
byte_2237C
	dc.b	1, $70, 1, $DF, 1, $CF, 1, $E0, 1, $78, 1, $79, 1, $7A, 1, $E1
	dc.b	1, $CF, 1, $E0, 1, $84, 1, $B2, 1, $D5, 1, $E2, 1, $8C, 1, $8D
	dc.b	1, $8E, 1, $E3, 1, $D5, 1, $E4, 1, $98, 1, $99, 9, $B9, 0, $E2
	dc.b	0, $C1, 1, $9E, 1, $9F, 1, $A0, 9, $B9, 0, 0
byte_223B8
	dc.b	$10, $E2, 1, $72, 1, $E5, 1, $72, 1, $D1, 1, $D2, 1, $D3, 1, $CF
	dc.b	1, $D0, 1, $E6, 1, $76, 1, $E7, 1, $E8, 1, $E9, 1, $74, 1, $83
	dc.b	1, $D4, 1, $86, 1, $EA, 1, $86, 1, $D7, 1, $D8, 1, $D9, 1, $D5
	dc.b	1, $D6, 1, $EB, 1, $8A, 1, $EC, 1, $ED, 1, $EE, 1, $88, 1, $97
	dc.b	0, 0, 1, $EF, 0, $DD, 1, $9A, 1, $DC, 1, $DD, 1, $CC, 9, $B9
	dc.b	1, $F0, 1, $F1, 0, $C1, 1, $B7, 1, $F2, 1, $99, 1, $9B, 1, $A0
	
; -----------------------------------------------------------------------------------------

					if RegionCheckCode=0
Str_RegionLockNTSC:	
					include "data/text/Region/Wrong Region NTSC.asm"
					
Str_RegionLockPAL:
					include "data/text/Region/Wrong Region PAL.asm"
					
					else

Str_RegionLockJapan:	
					include "data/text/Region/Wrong Region Japan.asm"
					
Str_RegionLockUSA:
					include "data/text/Region/Wrong Region USA.asm"	

Str_RegionLockEurope:	
					include "data/text/Region/Wrong Region Europe.asm"
					
Str_RegionLockAsia:
					include "data/text/Region/Wrong Region Asia.asm"						
					endc
					
; =============== S U B	R O U T	I N E =====================================================

GetRegion:
					include "subroutines//Region/get region.asm"

; =============== S U B	R O U T	I N E =====================================================


RegionLockout:
					include "subroutines/Region/region lockout.asm"

; =============== S U B	R O U T	I N E =====================================================


SoundTest_SetupPlanes:
	move.b	#$FF,(use_plane_a_buffer).l
	move.w	#$E000,d5
	move.w	#$1B,d0
	move.w	#$406C,d6

loc_22646:
	DISABLE_INTS
	jsr	SetVRAMWrite
	addi.w	#$80,d5
	move.w	#$27,d1

loc_22658:
	move.w	d6,VDP_DATA
	eori.b	#1,d6
	dbf	d1,loc_22658
	ENABLE_INTS
	eori.b	#2,d6
	dbf	d0,loc_22646
	bra.w	Options_ClearPlaneA
; End of function SoundTest_SetupPlanes

; -----------------------------------------------------------------------------------------

SpawnSoundTestActor:
	lea	(ActSoundTest).l,a1
	jmp	FindActorSlot

; =============== S U B	R O U T	I N E =====================================================

ChecksumError:
					include "subroutines/Checksum/checksum error.asm"

; =============== S U B	R O U T	I N E =====================================================


ActSoundTest:
	move.w	#2,d0
	bsr.w	Options_DrawStrings
	bsr.w	sub_228EC
	jsr	(ActorBookmark).l

ActSoundTest_Update:
	bsr.w	sub_22956
	move.b	p1_ctrl+ctlPress,d0
	or.b	p2_ctrl+ctlPress,d0
	btst	#7,d0
	bne.w	.Exit
	btst	#4,d0
	bne.w	.StopSound
	andi.b	#$60,d0
	bne.w	.PlaySound
	move.b	(p1_ctrl+ctlPulse).l,d0
	or.b	(p2_ctrl+ctlPulse).l,d0
	btst	#0,d0
	bne.w	.Up
	btst	#1,d0
	bne.w	.Down
	btst	#3,d0
	bne.w	.Right
	btst	#2,d0
	bne.w	.Left
	rts
; -----------------------------------------------------------------------------------------

.Up:
	subq.w	#1,aField26(a0)
	bcc.w	.UpEnd
	move.w	#5,aField26(a0)

.UpEnd:
	rts
; -----------------------------------------------------------------------------------------

.Down:
	addq.w	#1,aField26(a0)
	cmpi.w	#6,aField26(a0)
	bcs.w	.DownEnd
	move.w	#0,aField26(a0)

.DownEnd:
	rts
; -----------------------------------------------------------------------------------------

.StopSound:
	jmp	(StopSound).l
; -----------------------------------------------------------------------------------------

.Exit:
	clr.b	(use_plane_a_buffer).l
	clr.b	(bytecode_disabled).l
	jmp	(ActorDeleteSelf).l
; -----------------------------------------------------------------------------------------

.Right:
	move.b	#1,d1
	bra.w	.MoveSelection
; -----------------------------------------------------------------------------------------

.Left:
	move.b	#-1,d1

.MoveSelection:
	move.w	aField26(a0),d0
	lea	(.MaxSoundSels).l,a1
	move.b	(a1,d0.w),d2
	cmpi.b	#3,d0
	bne.s	.ChkUnderflow
	move.b	CONSOLE_VER,d7
	andi.b	#$C0,d7
	bne.s	.ChkUnderflow
	move.b	#$1A,d2

.ChkUnderflow:
	add.b	d1,aXVel(a0,d0.w)
	bpl.w	.ChkOverflow
	move.b	d2,aXVel(a0,d0.w)
	subq.b	#1,aXVel(a0,d0.w)

.ChkOverflow:
	move.b	aXVel(a0,d0.w),d3
	cmp.b	d2,d3
	bcs.w	.loc_2282A
	clr.b	aXVel(a0,d0.w)

.loc_2282A:
	subq.w	#3,d0
	bcs.w	.End
	bsr.w	SoundTest_SelNonSFX

.End:
	rts
; -----------------------------------------------------------------------------------------
.MaxSoundSels:
	dc.b	$32
	dc.b	$32
	dc.b	$32
	dc.b	$13
	dc.b	$17
	dc.b	4
; -----------------------------------------------------------------------------------------

.PlaySound:
	move.w	aField26(a0),d1
	clr.w	d0
	move.b	aXVel(a0,d1.w),d0
	subq.w	#3,d1
	bcc.w	.PlayNonSFX

.PlaySFX:
	addi.b	#$41,d0
	jmp	(JmpTo_PlaySound_2).l
; -----------------------------------------------------------------------------------------

.PlayNonSFX:
	lsl.w	#2,d0
	lsl.w	#2,d1
	lea	(off_229EC).l,a1
	movea.l	(a1,d1.w),a2
	movea.l	(a2,d0.w),a1
	move.b	(a1),d0
	movea.l	SoundTest_PlayTypes(pc,d1.w),a1
	jmp	(a1)
; End of function ActSoundTest

; -----------------------------------------------------------------------------------------
SoundTest_PlayTypes:dc.l	SoundTest_PlayBGM
	dc.l	SoundTest_PlayVoice
	dc.l	SoundTest_PlayCmd
; -----------------------------------------------------------------------------------------

SoundTest_PlayBGM:
	jmp	JmpTo_PlaySound
; -----------------------------------------------------------------------------------------

SoundTest_PlayVoice:
	jmp	(JmpTo_PlaySound_2).l
; -----------------------------------------------------------------------------------------

SoundTest_PlayCmd:
	jmp	PlaySound_ChkSamp
; -----------------------------------------------------------------------------------------
	clr.w	d0
	move.b	$17(a0),d0
	mulu.w	#3,d0
	move.b	byte_228D6(pc,d0.w),(byte_FF012C).l
	move.b	byte_228D7(pc,d0.w),(byte_FF012D).l
	move.b	byte_228D8(pc,d0.w),(byte_FF012E).l
	cmpi.b	#$F4,(byte_FF012C).l
	bne.w	locret_228D4
	clr.w	d0
	move.b	$15(a0),d0
	lsl.w	#2,d0
	lea	(off_229F8).l,a1
	movea.l	(a1,d0.w),a2
	move.b	(a2),(byte_FF012E).l

locret_228D4:
	rts
; -----------------------------------------------------------------------------------------
byte_228D6
	dc.b	$F1
byte_228D7
	dc.b	0
byte_228D8
	dc.b	0
	dc.b	$F2
	dc.b	0
	dc.b	0
	dc.b	$F3
	dc.b	$80
	dc.b	0
	dc.b	$F4
	dc.b	$80
	dc.b	$1A
	dc.b	$F5
	dc.b	$80
	dc.b	0
	dc.b	$F6
	dc.b	0
	dc.b	0
	dc.b	$F7
	dc.b	0
	dc.b	0
	dc.b	0

; =============== S U B	R O U T	I N E =====================================================


sub_228EC:
	move.w	#2,d0

loc_228F0:
	movem.l	d0,-(sp)
	bsr.w	SoundTest_SelNonSFX
	movem.l	(sp)+,d0
	dbf	d0,loc_228F0
	rts
; End of function sub_228EC


; =============== S U B	R O U T	I N E =====================================================


SoundTest_SelNonSFX:
	move.w	d0,d1
	lsl.w	#2,d1
	lea	(off_229EC).l,a1
	movea.l	(a1,d1.w),a2
	move.b	$15(a0,d0.w),d1
	lsl.w	#2,d1
	movea.l	(a2,d1.w),a1
	addq.l	#1,a1
	move.w	d0,d5
	lsl.w	#8,d5
	addi.w	#$5A4,d5
	move.w	#$A200,d6
	movem.l	d5-d6/a1,-(sp)
	lea	(asc_2293E).l,a1
	bsr.w	Options_Print
	movem.l	(sp)+,d5-d6/a1
	bra.w	Options_Print
; End of function SoundTest_SelNonSFX

; -----------------------------------------------------------------------------------------
asc_2293E
	dc.b	"                      "
	dc.b	$FF
	dc.b	0

; =============== S U B	R O U T	I N E =====================================================


sub_22956:
	move.w	#5,d0
	move.w	#$79C,d5
	move.w	#$A200,d6

loc_22962:
	bsr.w	sub_229C2
	bsr.w	sub_22980
	movem.l	d0-d5,-(sp)
	bsr.w	Options_Print
	movem.l	(sp)+,d0-d5
	subi.w	#$100,d5
	dbf	d0,loc_22962
	rts
; End of function sub_22956


; =============== S U B	R O U T	I N E =====================================================


sub_22980:
	lea	(stage_text_buffer).l,a1
	move.w	#$2020,(a1)
	move.b	#$FF,2(a1)
	cmp.w	$26(a0),d0
	bne.w	loc_229A6
	btst	#0,(frame_count+1).l
	beq.w	loc_229A6
	rts
; -----------------------------------------------------------------------------------------

loc_229A6:
	move.b	d1,d2
	lsr.b	#4,d2
	andi.b	#$F,d1
	addq.b	#1,d2
	addq.b	#1,d1
	move.b	d2,0(a1)
	move.b	d1,1(a1)
	move.b	#$FF,2(a1)
	rts
; End of function sub_22980


; =============== S U B	R O U T	I N E =====================================================


sub_229C2:
	clr.w	d1
	move.b	$12(a0,d0.w),d1
	move.w	d0,d2
	subq.w	#3,d2
	bcs.w	loc_229E6
	lsl.w	#2,d2
	lea	(off_229EC).l,a1
	movea.l	(a1,d2.w),a2
	lsl.w	#2,d1
	movea.l	(a2,d1.w),a1
	move.b	(a1)+,d1
	rts
; -----------------------------------------------------------------------------------------

loc_229E6:
	addi.b	#$41,d1
	rts
; End of function sub_229C2

; -----------------------------------------------------------------------------------------
off_229EC
	dc.l	off_229F8
	dc.l	off_22AC8
	dc.l	off_22B90
off_229F8
	dc.l	byte_22A64
	dc.l	byte_22A68
	dc.l	byte_22A6C
	dc.l	byte_22A70
	dc.l	byte_22A74
	dc.l	byte_22A78
	dc.l	byte_22A7C
	dc.l	byte_22A80
	dc.l	byte_22A84
	dc.l	byte_22A88
	dc.l	byte_22A94
	dc.l	byte_22AA0
	dc.l	byte_22AA4
	dc.l	byte_22AA8
	dc.l	byte_22AB4
	dc.l	byte_22AB8
	dc.l	byte_22ABC
	dc.l	byte_22AC0
	dc.l	byte_22AC4
	dc.l	byte_22A60
	dc.l	byte_22A8C
	dc.l	byte_22A90
	dc.l	byte_22A98
	dc.l	byte_22A9C
	dc.l	byte_22AAC
	dc.l	byte_22AB0
byte_22A60
	dc.b	1, $20, $20, $FF
byte_22A64
	dc.b	2, $20, $20, $FF
byte_22A68
	dc.b	3, $20, $20, $FF
byte_22A6C
	dc.b	4, $20, $20, $FF
byte_22A70
	dc.b	5, $20, $20, $FF
byte_22A74
	dc.b	6, $20, $20, $FF
byte_22A78
	dc.b	7, $20, $20, $FF
byte_22A7C
	dc.b	8, $20, $20, $FF
byte_22A80
	dc.b	9, $20, $20, $FF
byte_22A84
	dc.b	$A, $20, $20, $FF
byte_22A88
	dc.b	$B, $20, $20, $FF
byte_22A8C
	dc.b	$C, $20, $20, $FF
byte_22A90
	dc.b	$D, $20, $20, $FF
byte_22A94
	dc.b	$E, $20, $20, $FF
byte_22A98
	dc.b	$F, $20, $20, $FF
byte_22A9C
	dc.b	$10, $20, $20, $FF
byte_22AA0
	dc.b	$11, $20, $20, $FF
byte_22AA4
	dc.b	$12, $20, $20, $FF
byte_22AA8
	dc.b	$13, $20, $20, $FF
byte_22AAC
	dc.b	$14, $20, $20, $FF
byte_22AB0
	dc.b	$15, $20, $20, $FF
byte_22AB4
	dc.b	$16, $20, $20, $FF
byte_22AB8
	dc.b	$17, $20, $20, $FF
byte_22ABC
	dc.b	$18, $20, $20, $FF
byte_22AC0
	dc.b	$19, $20, $20, $FF
byte_22AC4
	dc.b	$1A, $20, $20, $FF
off_22AC8
	dc.l	byte_22B24
	dc.l	byte_22B28
	dc.l	byte_22B2C
	dc.l	byte_22B30
	dc.l	byte_22B34
	dc.l	byte_22B38
	dc.l	byte_22B3C
	dc.l	byte_22B40
	dc.l	byte_22B44
	dc.l	byte_22B48
	dc.l	byte_22B4C
	dc.l	byte_22B50
	dc.l	byte_22B54
	dc.l	byte_22B58
	dc.l	byte_22B5C
	dc.l	byte_22B60
	dc.l	byte_22B64
	dc.l	byte_22B68
	dc.l	byte_22B6C
	dc.l	byte_22B70
	dc.l	byte_22B74
	dc.l	byte_22B78
	dc.l	byte_22B7C
byte_22B24
	dc.b	$81, $20, $20, $FF
byte_22B28
	dc.b	$82, $20, $20, $FF
byte_22B2C
	dc.b	$83, $20, $20, $FF
byte_22B30
	dc.b	$84, $20, $20, $FF
byte_22B34
	dc.b	$85, $20, $20, $FF
byte_22B38
	dc.b	$86, $20, $20, $FF
byte_22B3C
	dc.b	$87, $20, $20, $FF
byte_22B40
	dc.b	$88, $20, $20, $FF
byte_22B44
	dc.b	$89, $20, $20, $FF
byte_22B48
	dc.b	$8A, $20, $20, $FF
byte_22B4C
	dc.b	$8B, $20, $20, $FF
byte_22B50
	dc.b	$8C, $20, $20, $FF
byte_22B54
	dc.b	$8D, $20, $20, $FF
byte_22B58
	dc.b	$8E, $20, $20, $FF
byte_22B5C
	dc.b	$8F, $20, $20, $FF
byte_22B60
	dc.b	$90, $20, $20, $FF
byte_22B64
	dc.b	$91, $20, $20, $FF
byte_22B68
	dc.b	$92, $20, $20, $FF
byte_22B6C
	dc.b	$93, $20, $20, $FF
byte_22B70
	dc.b	$94, $20, $20, $FF
byte_22B74
	dc.b	$95, $20, $20, $FF
byte_22B78
	dc.b	$96, $20, $20, $FF
byte_22B7C
	dc.b	$97, $20, $20, $FF
	dc.b	$98, $20, $20, $FF
	dc.b	$99, $20, $20, $FF
	dc.b	$9A, $20, $20, $FF
	dc.b	$9B, $20, $20, $FF
off_22B90
	dc.l	byte_22BA0
	dc.l	byte_22BAE
	dc.l	byte_22BB8
	dc.l	byte_22BC6
byte_22BA0
	dc.b	$FE
	dc.b	"music clear"
	dc.b	$FF
	dc.b	0
byte_22BAE
	dc.b	$FD
	dc.b	"fade out"
	dc.b	$FF
byte_22BB8
	dc.b	$FF
	dc.b	"pause on off"
	dc.b	$FF
byte_22BC6
	dc.b	$6F
	dc.b	"se clear"
	dc.b	$FF
	dc.b	$F5
	dc.b	"rebirth"
	dc.b	$FF
	dc.b	0
	dc.b	$F6
aPauseOn
	dc.b	"pause on"
	dc.b	$FF
	dc.b	$F7
aPauseOff
	dc.b	"pause off"
	dc.b	$FF
	dc.b	0

; =============== S U B	R O U T	I N E =====================================================


Options_SetupPlanes:
	move.b	#$FF,(use_plane_a_buffer).l
	move.w	#$E000,d5
	move.w	#$1B,d0
	move.w	#$6C,d6

.Row:
	DISABLE_INTS
	jsr	SetVRAMWrite
	addi.w	#$80,d5
	move.w	#$27,d1

.Tile:
	move.w	d6,VDP_DATA
	eori.b	#1,d6
	dbf	d1,.Tile
	ENABLE_INTS
	eori.b	#2,d6
	dbf	d0,.Row
	bra.w	Options_ClearPlaneA
; End of function Options_SetupPlanes


; =============== S U B	R O U T	I N E =====================================================


SpawnOptionsActor:
	lea	(ActOptions).l,a1
	jsr	FindActorSlot
	bcc.w	.Spawned
	rts
; -----------------------------------------------------------------------------------------

.Spawned:
	rts
; End of function SpawnOptionsActor


; =============== S U B	R O U T	I N E =====================================================


Options_ClearPlaneA:
	lea	(plane_a_buffer).l,a1
	move.w	#$6FF,d0

.Clear:
	move.w	#$8500,(a1)+
	dbf	d0,.Clear
	rts
; End of function Options_ClearPlaneA


; =============== S U B	R O U T	I N E =====================================================


Options_DrawStrings:
	movem.l	d0,-(sp)
	bsr.s	Options_ClearPlaneA
	movem.l	(sp)+,d0
	lsl.w	#2,d0
	movea.l	OptionsModeStrings(pc,d0.w),a2
	move.w	(a2)+,d0
	subq.w	#1,d0

.Loop:
	movea.l	(a2)+,a1
	movem.l	d0/a2,-(sp)
	move.w	(a1)+,d5
	move.w	(a1)+,d6
	bsr.w	Options_Print
	movem.l	(sp)+,d0/a2
	dbf	d0,.Loop
	rts
; End of function Options_DrawStrings

; -----------------------------------------------------------------------------------------
OptionsModeStrings:dc.l	OptionsStrings
	dc.l	InputTestStrings
	dc.l	SoundTestStrings
InputTestStrings:dc.w	$C
	dc.l	OptStr_InputTest
	dc.l	OptStr_PressStartAndA
	dc.l	OptStr_Pads
	dc.l	OptStr_ButtonA
	dc.l	OptStr_ButtonB
	dc.l	OptStr_ButtonC
	dc.l	OptStr_ButtonUp
	dc.l	OptStr_ButtonDown
	dc.l	OptStr_ButtonRight
	dc.l	OptStr_ButtonLeft
	dc.l	OptStr_ToExit
	dc.l	OptStr_Start
OptStr_InputTest:dc.w	$11E
	dc.w	$A200
	dc.b	"input test"
	dc.b	$FF
	ALIGN	2
OptStr_PressStartAndA:dc.w	$B88
	dc.w	$A200
	dc.b	"press start button and a button"
	dc.b	$FF
OptStr_ToExit
	dc.w	$CBA
	dc.w	$A200
	dc.b	"to exit"
	dc.b	$FF
OptStr_Pads
	dc.w	$222
	dc.w	$E200
	dc.b	"pad1  pad2"
	dc.b	$FF
	ALIGN	2
OptStr_Start
	dc.w	$316
	dc.w	$8200
	dc.b	"start:"
	dc.b	$FF
	ALIGN	2
OptStr_ButtonA
	dc.w	$410
	dc.w	$8200
	dc.b	"button a:"
	dc.b	$FF
OptStr_ButtonB
	dc.w	$510
	dc.w	$8200
	dc.b	"button b:"
	dc.b	$FF
OptStr_ButtonC
	dc.w	$610
	dc.w	$8200
	dc.b	"button c:"
	dc.b	$FF
OptStr_ButtonUp:dc.w	$790
	dc.w	$8200
	dc.b	"      up:"
	dc.b	$FF
OptStr_ButtonDown:dc.w	$890
	dc.w	$8200
	dc.b	"    down:"
	dc.b	$FF
OptStr_ButtonRight:dc.w	$990
	dc.w	$8200
	dc.b	"   right:"
	dc.b	$FF
OptStr_ButtonLeft:dc.w	$A90
	dc.w	$8200
	dc.b	"    left:"
	dc.b	$FF
OptionsStrings
	dc.w	$A
	dc.l	OptStr_Options
	dc.l	OptStr_Players
	dc.l	OptStr_PressStartExit
	dc.l	OptStr_AssignA
	dc.l	OptStr_AssignB
	dc.l	OptStr_AssignC
	dc.l	OptStr_COMLevel
	dc.l	OptStr_VSMode
	dc.l	OptStr_Sampling
	dc.l	OptStr_KeyAssign
OptStr_Options
	dc.w	$120
	dc.w	$A200
	dc.b	"options"
	dc.b	$FF
OptStr_Players
	dc.w	$312
	dc.w	$E200
	dc.b	"player 1       player 2"
	dc.b	$FF
OptStr_PressStartExit:dc.w	$C8E
	dc.w	$A200
	dc.b	"press start button to exit"
	dc.b	$FF
	dc.b	0
OptStr_AssignA
	dc.w	$40C
	dc.w	$E200
	dc.b	"a:              a:"
	dc.b	$FF
	dc.b	0
OptStr_AssignB
	dc.w	$50C
	dc.w	$E200
	dc.b	"b:              b:"
	dc.b	$FF
	dc.b	0
OptStr_AssignC
	dc.w	$60C
	dc.w	$E200
	dc.b	"c:              c:"
	dc.b	$FF
	dc.b	0
OptStr_COMLevel:dc.w	$78C
	dc.w	$E200
	dc.b	"vs.com level   :"
	dc.b	$FF
	dc.b	0
OptStr_VSMode
	dc.w	$88C
	dc.w	$E200
	dc.b	"1p vs.2p mode  :"
	dc.b	$FF
	dc.b	0
OptStr_Sampling:dc.w	$98C
	dc.w	$E200
	dc.b	"sampling       :"
	dc.b	$FF
	dc.b	0
OptStr_KeyAssign:dc.w	$21A
	dc.w	$E200
	dc.b	"key assignment"
	dc.b	$FF
	dc.b	0
SoundTestStrings:dc.w	8
	dc.l	OptStr_SoundTest
	dc.l	OptStr_PressStartExit2
	dc.l	OptStr_Sound1
	dc.l	OptStr_Sound2
	dc.l	OptStr_Sound3
	dc.l	OptStr_BGM
	dc.l	OptStr_Voice
	dc.l	OptStr_SndCmd
OptStr_SoundTest:dc.w	$11C
	dc.w	$8200
	dc.b	"sound test"
	dc.b	$FF
	dc.b	0
OptStr_PressStartExit2:dc.w	$C8E
	dc.w	$E200
	dc.b	"press start button to exit"
	dc.b	$FF
	dc.b	0
OptStr_Sound1
	dc.w	$292
	dc.w	$E200
	dc.b	"se1:"
	dc.b	$FF
	dc.b	0
OptStr_Sound2
	dc.w	$392
	dc.w	$E200
	dc.b	"se2:"
	dc.b	$FF
	dc.b	0
OptStr_Sound3
	dc.w	$492
	dc.w	$E200
	dc.b	"se3:"
	dc.b	$FF
	dc.b	0
OptStr_BGM
	dc.w	$592
	dc.w	$E200
	dc.b	"bgm:"
	dc.b	$FF
	dc.b	0
OptStr_Voice
	dc.w	$68E
	dc.w	$E200
	dc.b	"voice:"
	dc.b	$FF
	dc.b	0
OptStr_SndCmd
	dc.w	$78A
	dc.w	$E200
	dc.b	"command:"
	dc.b	$FF
	dc.b	0

; =============== S U B	R O U T	I N E =====================================================


Options_PrintSelect:
	move.w	#$8200,d6
	btst	#0,$26(a0)
	beq.w	Options_Print
	cmp.b	$2C(a0),d0
	bne.w	loc_22F46
	move.w	#$C200,d6
	bra.w	Options_Print
; -----------------------------------------------------------------------------------------

loc_22F46:
	cmp.b	$2D(a0),d0
	bne.w	Options_Print
	move.w	#$A200,d6
; End of function Options_PrintSelect


; =============== S U B	R O U T	I N E =====================================================


Options_Print:
	lea	((plane_a_buffer+2)).l,a2
	lea	(Options_CharConv).l,a3
	clr.w	d0

.Loop:
	move.b	(a1)+,d0
	bmi.w	.Done
	move.b	(a3,d0.w),d6
	move.w	d6,-2(a2,d5.w)
	addq.w	#2,d5
	bra.s	.Loop
; -----------------------------------------------------------------------------------------

.Done:
	rts
; End of function Options_Print


; =============== S U B	R O U T	I N E =====================================================


Options_PrintRaw:
	lea	((plane_a_buffer+2)).l,a2

.Loop:
	move.b	(a1)+,d0
	bmi.w	.Done
	lsl.b	#1,d0
	move.b	d0,d6
	move.w	d6,-2(a2,d5.w)
	addq.b	#1,d6
	move.w	d6,$7E(a2,d5.w)
	addq.w	#2,d5
	bra.s	.Loop
; -----------------------------------------------------------------------------------------

.Done:
	rts
; End of function Options_PrintRaw

; -----------------------------------------------------------------------------------------
Options_CharConv:dc.b	$11
	dc.b	$12
	dc.b	$13
	dc.b	$14
	dc.b	$15
	dc.b	$16
	dc.b	$17
	dc.b	$18
	dc.b	$19
	dc.b	$1A
	dc.b	$1B
	dc.b	$1C
	dc.b	$1D
	dc.b	$1E
	dc.b	$1F
	dc.b	$20
	dc.b	$21
	dc.b	$11
	dc.b	$11
	dc.b	$11
	dc.b	$11
	dc.b	$11
	dc.b	$11
	dc.b	$11
	dc.b	$11
	dc.b	$11
	dc.b	$11
	dc.b	$11
	dc.b	$11
	dc.b	$11
	dc.b	$11
	dc.b	$11
	dc.b	$11
	dc.b	7
	dc.b	$11
	dc.b	$36
	dc.b	$37
	dc.b	$11
	dc.b	$11
	dc.b	9
	dc.b	$11
	dc.b	$11
	dc.b	$11
	dc.b	$11
	dc.b	1
	dc.b	8
	dc.b	2
	dc.b	$11
	dc.b	$12
	dc.b	$13
	dc.b	$14
	dc.b	$15
	dc.b	$16
	dc.b	$17
	dc.b	$18
	dc.b	$19
	dc.b	$1A
	dc.b	$1B
	dc.b	4
	dc.b	5
	dc.b	$11
	dc.b	$11
	dc.b	$11
	dc.b	6
	dc.b	$11
	dc.b	$1C
	dc.b	$1D
	dc.b	$1E
	dc.b	$1F
	dc.b	$20
	dc.b	$21
	dc.b	$22
	dc.b	$23
	dc.b	$24
	dc.b	$25
	dc.b	$26
	dc.b	$27
	dc.b	$28
	dc.b	$29
	dc.b	$2A
	dc.b	$2B
	dc.b	$2C
	dc.b	$2D
	dc.b	$2E
	dc.b	$2F
	dc.b	$30
	dc.b	$31
	dc.b	$32
	dc.b	$33
	dc.b	$34
	dc.b	$35
	dc.b	$11
	dc.b	$11
	dc.b	$11
	dc.b	$11
	dc.b	$11
	dc.b	$11
	dc.b	$1C
	dc.b	$1D
	dc.b	$1E
	dc.b	$1F
	dc.b	$20
	dc.b	$21
	dc.b	$22
	dc.b	$23
	dc.b	$24
	dc.b	$25
	dc.b	$26
	dc.b	$27
	dc.b	$28
	dc.b	$29
	dc.b	$2A
	dc.b	$2B
	dc.b	$2C
	dc.b	$2D
	dc.b	$2E
	dc.b	$2F
	dc.b	$30
	dc.b	$31
	dc.b	$32
	dc.b	$33
	dc.b	$34
	dc.b	$35
	dc.b	$11
	dc.b	$11
	dc.b	$11
	dc.b	$11
	dc.b	$11
; -----------------------------------------------------------------------------------------
; START	OF FUNCTION CHUNK FOR OptionsCtrl

ActOptions:
	move.w	#0,d0
	bsr.w	Options_DrawStrings
	jsr	(ActorBookmark).l

ActOptions_Update:
	addq.b	#1,aField26(a0)
	bsr.w	PrintMainOptions
	move.b	p1_ctrl+ctlPress,d0
	or.b	p2_ctrl+ctlPress,d0
	btst	#7,d0
	bne.w	.Exit
	move.w	#0,d0
	move.b	p1_ctrl+ctlPress,d1
	bsr.w	OptionsCtrl
	move.w	#1,d0
	move.b	p2_ctrl+ctlPress,d1
	bsr.w	OptionsCtrl
	rts
; -----------------------------------------------------------------------------------------

.Exit:
	bsr.w	SaveData
	clr.b	(use_plane_a_buffer).l
	move.b	#0,bytecode_flag
	clr.b	(bytecode_disabled).l
	jmp	(ActorDeleteSelf).l
; END OF FUNCTION CHUNK	FOR OptionsCtrl

; =============== S U B	R O U T	I N E =====================================================


OptionsCtrl:
	move.b	#2,d2
	cmp.b	swap_fields,d0
	bne.w	.CheckButtons
	move.b	#6,d2
	tst.w	(is_japan).l
	beq.w	.CheckButtons
	move.b	#7,d2

.CheckButtons:
	btst	#0,d1
	bne.w	.Up
	btst	#1,d1
	bne.w	.Down
	btst	#2,d1
	bne.w	.Left
	btst	#3,d1
	bne.w	.Right
	andi.b	#$70,d1
	bne.w	.Select
	rts
; -----------------------------------------------------------------------------------------

.Up:
	subq.b	#1,aField2C(a0,d0.w)
	bcc.w	.UpSound
	move.b	d2,aField2C(a0,d0.w)

.UpSound:
	move.b	#SFX_MENU_MOVE,d0
	jmp	PlaySound_ChkSamp
; -----------------------------------------------------------------------------------------

.Down:
	addq.b	#1,aField2C(a0,d0.w)
	cmp.b	aField2C(a0,d0.w),d2
	bcc.w	.DownSound
	clr.b	aField2C(a0,d0.w)

.DownSound:
	move.b	#SFX_MENU_MOVE,d0
	jmp	PlaySound_ChkSamp
; -----------------------------------------------------------------------------------------

.Left:
	move.b	#-1,d1
	bra.w	.ChangeOption
; -----------------------------------------------------------------------------------------

.Right:
	move.b	#1,d1

.ChangeOption:
	clr.w	d2
	move.b	aField2C(a0,d0.w),d2
	lsl.w	#2,d2
	movea.l	.Options(pc,d2.w),a1
	jmp	(a1)
; -----------------------------------------------------------------------------------------
.Options:
	dc.l	.KeyAssign
	dc.l	.KeyAssign
	dc.l	.KeyAssign
	dc.l	.COMLevel
	dc.l	.VSMode
	dc.l	.Sampling
	dc.l	.Nothing
	dc.l	.Nothing
; -----------------------------------------------------------------------------------------

.KeyAssign:
	lea	(player_1_a).l,a1
	tst.w	d0
	beq.w	.loc_23140
	lea	(player_2_a).l,a1

.loc_23140:
	clr.w	d2
	move.b	aField2C(a0,d0.w),d2
	move.b	(a1,d2.w),d3
	add.b	d1,d3
	bpl.w	.loc_23154
	move.b	#2,d3

.loc_23154:
	cmpi.b	#3,d3
	bcs.w	.loc_2315E
	clr.b	d3

.loc_2315E:
	move.b	d3,(a1,d2.w)
	move.b	#0,d0
	jmp	PlaySound_ChkSamp
; -----------------------------------------------------------------------------------------

.COMLevel:
	addq.b	#1,(com_level).l
	tst.b	d1
	bmi.w	.loc_2317E
	subq.b	#2,(com_level).l

.loc_2317E:
	andi.b	#3,(com_level).l
	move.b	#0,d0
	jmp	PlaySound_ChkSamp
; -----------------------------------------------------------------------------------------

.VSMode:
	move.b	(game_matches).l,d2
	subq.b	#1,d2
	add.b	d1,d2
	andi.b	#7,d2
	addq.b	#1,d2
	move.b	d2,(game_matches).l
	move.b	#0,d0
	jmp	PlaySound_ChkSamp
; -----------------------------------------------------------------------------------------

.Sampling:
	eori.b	#$FF,(disable_samples).l
	move.b	#0,d0
	jmp	PlaySound_ChkSamp
; -----------------------------------------------------------------------------------------

.Nothing:
	rts
; -----------------------------------------------------------------------------------------

.Select:
	cmpi.b	#6,aField2C(a0,d0.w)
	beq.w	.InputTest
	cmpi.b	#7,aField2C(a0,d0.w)
	beq.w	.SoundTest
	rts
; -----------------------------------------------------------------------------------------

.InputTest:
	move.b	#0,d0
	jsr	PlaySound_ChkSamp
	movem.l	(sp)+,d0
	bra.w	ActInputTest
; -----------------------------------------------------------------------------------------

.SoundTest:
	move.b	#0,d0
	jsr	PlaySound_ChkSamp
	movem.l	(sp)+,d0
	clr.b	(use_plane_a_buffer).l
	move.b	#1,bytecode_flag
	clr.b	(bytecode_disabled).l
	jmp	(ActorDeleteSelf).l
; End of function OptionsCtrl


; =============== S U B	R O U T	I N E =====================================================


PrintMainOptions:
	bsr.w	PrintP1CtrlOption
	bsr.w	PrintP2CtrlOption
	bsr.w	sub_232D4
	bsr.w	PrintVSModeOption
	bsr.w	PrintSamplingOption
	bsr.w	PrintInputTest
	bsr.w	PrintSoundTest
	rts
; End of function PrintMainOptions


; =============== S U B	R O U T	I N E =====================================================


PrintP1CtrlOption:
	lea	(player_1_a).l,a2
	move.w	#$2C,d4
	move.w	#$410,d5
	move.w	#$C200,d6
	bra.w	loc_2325A
; End of function PrintP1CtrlOption


; =============== S U B	R O U T	I N E =====================================================


PrintP2CtrlOption:
	lea	(player_2_a).l,a2
	move.w	#$2D,d4
	move.w	#$430,d5
	move.w	#$A200,d6

loc_2325A:
	btst	#0,aField26(a0)
	bne.w	loc_23268
	move.w	#$8200,d6

loc_23268:
	swap	d6
	move.w	#$8200,d6
	clr.w	d3

loc_23270:
	clr.w	d0
	move.b	(a2)+,d0
	lsl.w	#2,d0
	movea.l	PlayerCtrlOptStrings(pc,d0.w),a1
	movem.l	d3-d6/a2,-(sp)
	cmp.b	(a0,d4.w),d3
	bne.w	loc_23288
	swap	d6

loc_23288:
	bsr.w	Options_Print
	movem.l	(sp)+,d3-d6/a2
	addi.w	#$100,d5
	addq.w	#1,d3
	cmpi.w	#3,d3
	bcs.s	loc_23270
	rts
; End of function PrintP2CtrlOption

; -----------------------------------------------------------------------------------------
PlayerCtrlOptStrings:dc.l	OptStr_DontUse
	dc.l	OptStr_TurnLeft
	dc.l	OptStr_TurnRight
OptStr_DontUse
	dc.b	"don",$27,"t use   "
	dc.b	$FF
	dc.b	0
OptStr_TurnLeft:dc.b	"turn left  $"
	dc.b	$FF
	dc.b	0
OptStr_TurnRight:dc.b	"turn right #"
	dc.b	$FF
	dc.b	0

; =============== S U B	R O U T	I N E =====================================================


sub_232D4:
	move.w	#$7AE,d5
	clr.w	d0
	move.b	(com_level).l,d0
	lsl.w	#2,d0
	movea.l	COMLevelStrings(pc,d0.w),a1
	move.b	#3,d0
	bra.w	Options_PrintSelect
; End of function sub_232D4

; -----------------------------------------------------------------------------------------
COMLevelStrings:dc.l	OptStr_Hardest
	dc.l	OptStr_Hard
	dc.l	OptStr_Normal
	dc.l	OptStr_Easy
OptStr_Hardest
	dc.b	"hardest"
	dc.b	$FF
OptStr_Hard
	dc.b	"hard   "
	dc.b	$FF
OptStr_Normal
	dc.b	"normal "
	dc.b	$FF
OptStr_Easy
	dc.b	"easy   "
	dc.b	$FF

; =============== S U B	R O U T	I N E =====================================================


PrintVSModeOption:
	move.w	#$8AE,d5
	clr.w	d0
	move.b	(game_matches).l,d0
	beq.w	.PrintMatchCount
	subq.b	#1,d0

.PrintMatchCount:
	lsl.w	#2,d0
	movea.l	VSModeMatches(pc,d0.w),a1
	movem.l	d0,-(sp)
	move.w	#$C200,d6
	bsr.w	Options_Print
	movem.l	(sp)+,d0
	lea	(OptStr_GameMatch).l,a1
	move.w	#$8B0,d5
	cmpi.w	#$14,d0
	blt.s	.PrintGameMatch
	move.w	#$8B2,d5

.PrintGameMatch:
	move.b	#4,d0
	bra.w	Options_PrintSelect
; End of function PrintVSModeOption

; -----------------------------------------------------------------------------------------
OptStr_GameMatch:dc.b	" game match "
	dc.b	$FF
	dc.b	0
VSModeMatches
	dc.l	VSMode_1Match
	dc.l	VSMode_3Match
	dc.l	VSMode_5Match
	dc.l	VSMode_7Match
	dc.l	VSMode_9Match
	dc.l	VSMode_11Match
	dc.l	VSMode_13Match
	dc.l	VSMode_15Match
VSMode_1Match
	dc.b	2, $20, $FF, 0
VSMode_3Match
	dc.b	4, $20, $FF, 0
VSMode_5Match
	dc.b	6, $20, $FF, 0
VSMode_7Match
	dc.b	8, $20, $FF, 0
VSMode_9Match
	dc.b	$A, $20, $FF, 0
VSMode_11Match
	dc.b	2, 2, $FF, 0
VSMode_13Match
	dc.b	2, 4, $FF, 0
VSMode_15Match
	dc.b	2, 6, $FF, 0

; =============== S U B	R O U T	I N E =====================================================


PrintSamplingOption:
	move.b	#5,d0
	move.w	#$9AE,d5
	lea	(OptStr_On).l,a1
	tst.b	(disable_samples).l
	beq.w	loc_233CE
	lea	(OptStr_Off).l,a1

loc_233CE:
	bra.w	Options_PrintSelect
; End of function PrintSamplingOption

; -----------------------------------------------------------------------------------------
OptStr_On
	dc.b	"on "
	dc.b	$FF
OptStr_Off
	dc.b	"off"
	dc.b	$FF

; =============== S U B	R O U T	I N E =====================================================


PrintInputTest:
	move.b	#6,d0
	move.w	#$A9E,d5
	lea	(OptStr_InputTest2).l,a1
	bra.w	Options_PrintSelect
; End of function PrintInputTest

; -----------------------------------------------------------------------------------------
OptStr_InputTest2:dc.b	"input test"
	dc.b	$FF
	dc.b	0

; =============== S U B	R O U T	I N E =====================================================


PrintSoundTest:
	tst.w	(is_japan).l
	beq.w	locret_23414
	move.b	#7,d0
	move.w	#$B9E,d5
	lea	(OptStr_SoundTest2).l,a1
	bsr.w	Options_PrintSelect

locret_23414:
	rts
; End of function PrintSoundTest

; -----------------------------------------------------------------------------------------
OptStr_SoundTest2:dc.b	"sound test"
	dc.b	$FF
	dc.b	0
; -----------------------------------------------------------------------------------------
; START	OF FUNCTION CHUNK FOR OptionsCtrl

ActInputTest:
	move.w	#1,d0
	bsr.w	Options_DrawStrings
	jsr	(ActorBookmark).l

ActInputTest_Update:
	bsr.w	sub_23468
	move.b	(p1_ctrl+ctlHold).l,d0
	andi.b	#$C0,d0
	eori.b	#$C0,d0
	beq.w	loc_2345A
	move.b	(p2_ctrl+ctlHold).l,d0
	andi.b	#$C0,d0
	eori.b	#$C0,d0
	beq.w	loc_2345A
	rts
; -----------------------------------------------------------------------------------------

loc_2345A:
	move.b	#0,d0
	jsr	PlaySound_ChkSamp
	bra.w	ActOptions
; END OF FUNCTION CHUNK	FOR OptionsCtrl

; =============== S U B	R O U T	I N E =====================================================


sub_23468:
	move.b	(p1_ctrl+ctlHold).l,d0
	lsl.w	#8,d0
	move.b	(p2_ctrl+ctlHold).l,d0
	lea	(word_234B6).l,a2
	move.w	#$F,d1

loc_23480:
	move.w	(a2)+,d5
	lea	(byte_234AE).l,a1
	move.w	#$E500,d6
	ror.l	#1,d0
	bcs.w	loc_2349C
	lea	(byte_234B2).l,a1
	move.w	#$C500,d6

loc_2349C:
	movem.l	d0-d1/a2,-(sp)
	bsr.w	Options_PrintRaw
	movem.l	(sp)+,d0-d1/a2
	dbf	d1,loc_23480
	rts
; End of function sub_23468

; -----------------------------------------------------------------------------------------
byte_234AE
	dc.b	$19, $18, $FF, 0
byte_234B2
	dc.b	$2C, $2D, $FF, 0
word_234B6
	dc.w	$7B0, $8B0, $AB0, $9B0, $530, $630, $430, $330
	dc.w	$7A4, $8A4, $AA4, $9A4, $524, $624, $424, $324

; =============== S U B	R O U T	I N E =====================================================

CheckChecksum:
					include "subroutines/Checksum/check checksum.asm"

; -----------------------------------------------------------------------------------------

LockoutBypassCode:
					include "data/misc/Lockout Bypass Code.asm"

; =============== S U B	R O U T	I N E =====================================================


SaveData:
	movem.l	d0-d3/a1-a2,-(sp)
	lea	(save_data).l,a1
	bsr.w	CalcSaveDataChecksum
	move.w	d0,(save_data_checksum).l
	lea	(save_data_checksum).l,a1
	lea	(save_backup_checksum).l,a2
	move.w	#$2B,d0

loc_2355A:
	move.l	(a1)+,(a2)+
	dbf	d0,loc_2355A
	movem.l	(sp)+,d0-d3/a1-a2
	rts
; End of function SaveData


; =============== S U B	R O U T	I N E =====================================================


CalcSaveDataChecksum:
	move.w	#$56,d2
	clr.w	d0

loc_2356C:
	move.w	(a1)+,d1
	eor.w	d1,d0
	lsr.w	#1,d0
	bcc.w	loc_2357A
	eori.w	#$8810,d0

loc_2357A:
	dbf	d2,loc_2356C
	ror.w	#8,d0
	not.w	d0
	rts
; End of function CalcSaveDataChecksum

; -----------------------------------------------------------------------------------------
ComboVoices
	dc.b	0
	dc.b	VOI_P1_COMBO_1
	dc.b	VOI_P1_COMBO_2
	dc.b	VOI_P1_COMBO_3
	dc.b	VOI_P1_COMBO_4
	dc.b	VOI_P1_COMBO_4
	dc.b	VOI_P1_COMBO_4
	dc.b	VOI_P1_COMBO_4
	dc.b	0
	dc.b	VOI_P2_COMBO_1
	dc.b	VOI_P2_COMBO_2
	dc.b	VOI_P2_COMBO_3
	dc.b	VOI_P2_COMBO_4
	dc.b	VOI_P2_COMBO_4
	dc.b	VOI_P2_COMBO_4
	dc.b	VOI_P2_COMBO_4

; =============== S U B	R O U T	I N E =====================================================


SpawnGarbageGlow:
	btst	#1,stage_mode
	bne.w	.End
	movem.l	d0-a6,-(sp)
	moveq	#0,d0
	move.b	aFrame(a0),d0
	beq.s	.SpawnGlow
	cmpi.b	#6,d0
	bmi.s	.GetVoice
	moveq	#4,d0

.GetVoice:
	lea	(ComboVoices).l,a1
	tst.b	aField2A(a0)
	beq.s	.PlayVoice
	lea	8(a1),a1

.PlayVoice:
	move.b	(a1,d0.w),d0
	jsr	PlaySound_ChkSamp

.SpawnGlow:
	movem.l	(sp)+,d0-a6
	lea	(ActGarbageGlow).l,a1
	jsr	FindActorSlot
	bcs.w	.End
	move.b	aRunFlags(a0),aRunFlags(a1)
	move.l	a0,aField2E(a1)
	move.b	#2,aMappings(a1)
	move.l	#byte_2374C,aAnim(a1)
	tst.b	aField2A(a0)
	beq.w	.SetGlowPosition
	move.l	#byte_2377A,aAnim(a1)

.SetGlowPosition:
	move.w	(garbage_glow_x).l,$A(a1)
	move.w	(garbage_glow_y).l,$E(a1)
	move.b	aFrame(a0),aField2B(a1)
	move.b	aField2A(a0),aField2A(a1)

.End:
	rts
; End of function SpawnGarbageGlow


; =============== S U B	R O U T	I N E =====================================================


ActGarbageGlow:
	tst.b	aField2B(a0)
	beq.w	loc_2371C
	jsr	(ActorAnimate).l
	move.b	#$83,6(a0)
	jsr	(ActorBookmark).l
	move.w	#8,d0
	jsr	(ActorBookmark_SetDelay).l
	jsr	(ActorAnimate).l
	jsr	(ActorBookmark).l
	move.w	#$1F,$26(a0)
	move.l	#$1800000,d0
	jsr	(GetPuyoFieldID).l
	beq.w	loc_23674
	move.l	#$C00000,d0

loc_23674:
	sub.l	$A(a0),d0
	asr.l	#5,d0
	move.l	d0,$12(a0)
	move.l	#$880000,d0
	sub.l	$E(a0),d0
	asr.l	#5,d0
	move.l	d0,$16(a0)
	move.w	$A(a0),$1E(a0)
	jsr	(ActorBookmark).l
	jsr	(ActorAnimate).l
	move.w	$1E(a0),$A(a0)
	jsr	(ActorMove).l
	move.w	$A(a0),$1E(a0)
	move.b	#$80,d0
	jsr	(GetPuyoFieldID).l
	beq.w	loc_236C4
	eori.b	#$80,d0

loc_236C4:
	move.b	$27(a0),d1
	lsl.b	#2,d1
	or.b	d1,d0
	move.w	#$6000,d1
	jsr	(Sin).l
	swap	d2
	add.w	d2,$A(a0)
	subq.w	#1,$26(a0)
	bcs.w	loc_236E6
	rts
; -----------------------------------------------------------------------------------------

loc_236E6:
	move.l	#byte_2375E,aAnim(a0)
	tst.b	aField2A(a0)
	beq.w	loc_236FE
	move.l	#byte_2378C,aAnim(a0)

loc_236FE:
	clr.w	d1
	move.b	aField2B(a0),d1
	subq.b	#1,d1
	cmpi.b	#4,d1
	bcs.w	loc_23712
	move.b	#3,d1

loc_23712:
	move.b	GarbageSounds(pc,d1.w),d0
	jsr	PlaySound_ChkSamp

loc_2371C:
	movem.l	a0,-(sp)
	movea.l	aField2E(a0),a1
	movea.l	a1,a0
	jsr	(loc_984A).l
	movem.l	(sp)+,a0
	jsr	(ActorBookmark).l
	jsr	(ActorAnimate).l
	bcs.w	loc_23742
	rts
; -----------------------------------------------------------------------------------------

loc_23742:
	jmp	(ActorDeleteSelf).l
; End of function ActGarbageGlow

; -----------------------------------------------------------------------------------------
GarbageSounds
	dc.b	SFX_GARBAGE_1
	dc.b	SFX_GARBAGE_2
	dc.b	SFX_GARBAGE_3
	dc.b	SFX_GARBAGE_4
byte_2374C
	dc.b	0
	dc.b	7
	dc.b	0
	dc.b	8
	dc.b	0
	dc.b	9
	dc.b	1
	dc.b	$A
	dc.b	0
	dc.b	9
	dc.b	0
	dc.b	8
	dc.b	$FF
	dc.b	0
	dc.l	byte_2374C
byte_2375E
	dc.b	2
	dc.b	7
	dc.b	1
	dc.b	8
	dc.b	1
	dc.b	9
	dc.b	6
	dc.b	$A
	dc.b	0
	dc.b	9
	dc.b	0
	dc.b	8
	dc.b	0
	dc.b	7
	dc.b	3
	dc.b	$B
	dc.b	3
	dc.b	$C
	dc.b	3
	dc.b	$D
	dc.b	3
	dc.b	$E
	dc.b	3
	dc.b	$F
	dc.b	3
	dc.b	$10
	dc.b	$FE
	dc.b	0
byte_2377A
	dc.b	0
	dc.b	$11
	dc.b	0
	dc.b	$12
	dc.b	0
	dc.b	$13
	dc.b	1
	dc.b	$14
	dc.b	0
	dc.b	$13
	dc.b	0
	dc.b	$12
	dc.b	$FF
	dc.b	0
	dc.l	byte_2377A
byte_2378C
	dc.b	2
	dc.b	$11
	dc.b	1
	dc.b	$12
	dc.b	1
	dc.b	$13
	dc.b	6
	dc.b	$14
	dc.b	0
	dc.b	$13
	dc.b	0
	dc.b	$12
	dc.b	0
	dc.b	$11
	dc.b	3
	dc.b	$15
	dc.b	3
	dc.b	$16
	dc.b	3
	dc.b	$17
	dc.b	3
	dc.b	$18
	dc.b	3
	dc.b	$19
	dc.b	3
	dc.b	$1A
	dc.b	$FE
	dc.b	0

; =============== S U B	R O U T	I N E =====================================================


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
; -----------------------------------------------------------------------------------------

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
; -----------------------------------------------------------------------------------------

NemDec_WriteIter:
	moveq	#0,d4
	moveq	#8,d3

NemDec_WriteIter_Part2:
	dbf	d0,loc_2382C
	bra.s	NemDecRun
; -----------------------------------------------------------------------------------------

loc_23840:
	moveq	#6,d0
	bsr.w	NemEniDec_ChkGetNextByte
	moveq	#7,d0
	bsr.w	sub_2391E
	bra.s	loc_23820
; End of function NemDec


; =============== S U B	R O U T	I N E =====================================================


NemDec_WriteAndStay:
	move.l	d4,(a4)
	subq.w	#1,a5
	move.w	a5,d4
	bne.s	NemDec_WriteIter
	bra.s	loc_23878
; -----------------------------------------------------------------------------------------

NemDec_WriteAndStay_XOR:
	eor.l	d4,d2
	move.l	d2,(a4)
	subq.w	#1,a5
	move.w	a5,d4
	bne.s	NemDec_WriteIter
	bra.s	loc_23878
; -----------------------------------------------------------------------------------------

NemDec_WriteAndAdvance:
	move.l	d4,(a4)+
	subq.w	#1,a5
	move.w	a5,d4
	bne.s	NemDec_WriteIter
	bra.s	loc_23878
; -----------------------------------------------------------------------------------------

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
; End of function NemDec_WriteAndStay


; =============== S U B	R O U T	I N E =====================================================


NemDecPrepare:
	move.b	(a0)+,d0

loc_23884:
	cmpi.b	#$FF,d0
	bne.s	loc_2388C
	rts
; -----------------------------------------------------------------------------------------

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
; -----------------------------------------------------------------------------------------

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
; End of function NemDecPrepare

; -----------------------------------------------------------------------------------------
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
; -----------------------------------------------------------------------------------------

loc_238EE:
	move.w	d5,d6
	lsr.w	d0,d6
	move.b	d6,(a0)+
	move.w	d0,d6

locret_238F6:
	rts
; -----------------------------------------------------------------------------------------
	neg.w	d6
	beq.s	locret_23902
	addq.w	#8,d6
	lsl.w	d6,d5
	move.b	d5,(a0)+

locret_23902:
	rts

; =============== S U B	R O U T	I N E =====================================================


sub_23904:
	move.b	(a0)+,d5
	asl.w	#8,d5
	move.b	(a0)+,d5
	moveq	#$10,d6
	rts
; End of function sub_23904


; =============== S U B	R O U T	I N E =====================================================


sub_2390E:
	move.w	d6,d7
	sub.w	d0,d7
	move.w	d5,d1
	lsr.w	d7,d1
	add.w	d0,d0
	and.w	EniDec_AndVals-2(pc,d0.w),d1
	rts
; End of function sub_2390E


; =============== S U B	R O U T	I N E =====================================================


sub_2391E:
	bsr.s	sub_2390E
	lsr.w	#1,d0
; End of function sub_2391E


; =============== S U B	R O U T	I N E =====================================================


NemEniDec_ChkGetNextByte:
	sub.w	d0,d6
	cmpi.w	#9,d6
	bcc.s	locret_23930
	addq.w	#8,d6
	asl.w	#8,d5
	move.b	(a0)+,d5

locret_23930:
	rts
; End of function NemEniDec_ChkGetNextByte

; -----------------------------------------------------------------------------------------
EniDec_AndVals
	dc.w	1
	dc.w	3
	dc.w	7
	dc.w	$F
	dc.w	$1F
	dc.w	$3F
	dc.w	$7F
	dc.w	$FF
	dc.w	$1FF
	dc.w	$3FF
	dc.w	$7FF
	dc.w	$FFF
	dc.w	$1FFF
	dc.w	$3FFF
	dc.w	$7FFF
	dc.w	$FFFF

; =============== S U B	R O U T	I N E =====================================================


EniDec_GetInlineCopyVal:
	move.w	a3,d3
	swap	d4
	bpl.s	loc_23962
	subq.w	#1,d6
	btst	d6,d5
	beq.s	loc_23962
	ori.w	#$1000,d3

loc_23962:
	swap	d4
	bpl.s	loc_23970
	subq.w	#1,d6
	btst	d6,d5
	beq.s	loc_23970
	ori.w	#$800,d3

loc_23970:
	move.w	d5,d1
	move.w	d6,d7
	sub.w	a5,d7
	bcc.s	loc_239A0
	move.w	d7,d6
	addi.w	#$10,d6
	neg.w	d7
	lsl.w	d7,d1
	move.b	(a0),d5
	rol.b	d7,d5
	add.w	d7,d7
	and.w	EniDec_AndVals-2(pc,d7.w),d5
	add.w	d5,d1

loc_2398E:
	move.w	a5,d0
	add.w	d0,d0
	and.w	EniDec_AndVals-2(pc,d0.w),d1
	add.w	d3,d1
	move.b	(a0)+,d5
	lsl.w	#8,d5
	move.b	(a0)+,d5
	rts
; -----------------------------------------------------------------------------------------

loc_239A0:
	beq.s	loc_239B4
	lsr.w	d7,d1
	move.w	a5,d0
	add.w	d0,d0
	and.w	EniDec_AndVals-2(pc,d0.w),d1
	add.w	d3,d1
	move.w	a5,d0
	bra.w	NemEniDec_ChkGetNextByte
; -----------------------------------------------------------------------------------------

loc_239B4:
	moveq	#$10,d6
	bra.s	loc_2398E
; End of function EniDec_GetInlineCopyVal


; =============== S U B	R O U T	I N E =====================================================


EniDecPrioMap:
	jsr	(EniDec).l
	lea	(eni_tilemap_buffer).l,a1
	lea	(eni_tilemap_queue).l,a2
	move.w	4(a2),d6

.Row:
	move.w	2(a2),d7

.Tile:
	move.w	(a1),d0
	move.b	(a3)+,d1
	ror.w	#1,d1
	andi.w	#$8000,d1
	or.w	d1,d0
	move.w	d0,(a1)+
	dbf	d7,.Tile
	dbf	d6,.Row
	rts
; End of function EniDecPrioMap


; =============== S U B	R O U T	I N E =====================================================


EniDec:
	lea	(eni_tilemap_queue).l,a2
	move.w	#1,(a2)+
	move.w	d1,(a2)+
	move.w	d2,(a2)+
	move.w	a1,(a2)
	lea	(eni_tilemap_buffer).l,a1
	movem.l	d0-d7/a1-a5,-(sp)
	movea.w	d0,a3
	move.b	(a0)+,d0
	ext.w	d0
	movea.w	d0,a5
	move.b	(a0)+,d0
	ext.w	d0
	ext.l	d0
	ror.l	#1,d0
	ror.w	#1,d0
	move.l	d0,d4
	movea.w	(a0)+,a2
	adda.w	a3,a2
	movea.w	(a0)+,a4
	adda.w	a3,a4
	move.b	(a0)+,d5
	asl.w	#8,d5
	move.b	(a0)+,d5
	moveq	#$10,d6

EniDec_Loop:
	moveq	#7,d0
	move.w	d6,d7
	sub.w	d0,d7
	move.w	d5,d1
	lsr.w	d7,d1
	andi.w	#$7F,d1
	move.w	d1,d2
	cmpi.w	#$40,d1
	bcc.s	loc_23A42
	moveq	#6,d0
	lsr.w	#1,d2

loc_23A42:
	bsr.w	NemEniDec_ChkGetNextByte
	andi.w	#$F,d2
	lsr.w	#4,d1
	add.w	d1,d1
	jmp	EniDec_JmpTable(pc,d1.w)
; End of function EniDec

; -----------------------------------------------------------------------------------------

EniDec_Sub0:
	move.w	a2,(a1)+
	addq.w	#1,a2
	dbf	d2,EniDec_Sub0
	bra.s	EniDec_Loop
; -----------------------------------------------------------------------------------------

EniDec_Sub4:
	move.w	a4,(a1)+
	dbf	d2,EniDec_Sub4
	bra.s	EniDec_Loop
; -----------------------------------------------------------------------------------------

EniDec_Sub8:
	bsr.w	EniDec_GetInlineCopyVal

loc_23A68:
	move.w	d1,(a1)+
	dbf	d2,loc_23A68
	bra.s	EniDec_Loop
; -----------------------------------------------------------------------------------------

EniDec_SubA:
	bsr.w	EniDec_GetInlineCopyVal

loc_23A74:
	move.w	d1,(a1)+
	addq.w	#1,d1
	dbf	d2,loc_23A74
	bra.s	EniDec_Loop
; -----------------------------------------------------------------------------------------

EniDec_SubC:
	bsr.w	EniDec_GetInlineCopyVal

loc_23A82:
	move.w	d1,(a1)+
	subq.w	#1,d1
	dbf	d2,loc_23A82
	bra.s	EniDec_Loop
; -----------------------------------------------------------------------------------------

EniDec_SubE:
	cmpi.w	#$F,d2
	beq.s	EniDec_End

loc_23A92:
	bsr.w	EniDec_GetInlineCopyVal
	move.w	d1,(a1)+
	dbf	d2,loc_23A92
	bra.s	EniDec_Loop
; -----------------------------------------------------------------------------------------

EniDec_JmpTable:
	bra.s	EniDec_Sub0
; -----------------------------------------------------------------------------------------
	bra.s	EniDec_Sub0
; -----------------------------------------------------------------------------------------
	bra.s	EniDec_Sub4
; -----------------------------------------------------------------------------------------
	bra.s	EniDec_Sub4
; -----------------------------------------------------------------------------------------
	bra.s	EniDec_Sub8
; -----------------------------------------------------------------------------------------
	bra.s	EniDec_SubA
; -----------------------------------------------------------------------------------------
	bra.s	EniDec_SubC
; -----------------------------------------------------------------------------------------
	bra.s	EniDec_SubE
; -----------------------------------------------------------------------------------------

EniDec_End:
	subq.w	#1,a0
	cmpi.w	#$10,d6
	bne.s	loc_23AB8
	subq.w	#1,a0

loc_23AB8:
	move.w	a0,d0
	lsr.w	#1,d0
	bcc.s	loc_23AC0
	addq.w	#1,a0

loc_23AC0:
	movem.l	(sp)+,d0-d7/a1-a5
	rts

; =============== S U B	R O U T	I N E =====================================================


ProcEniTilemapQueue:
	move.l	#$800000,d4
	move.b	(vdp_reg_10).l,d0
	andi.b	#2,d0
	beq.s	.LoadStart
	move.l	#$1000000,d4

.LoadStart:
	lea	(eni_tilemap_queue).l,a1
	lea	VDP_CTRL,a2
	lea	VDP_DATA,a3

.PlaneLoop:
	tst.w	(a1)
	beq.w	.End
	lea	(eni_tilemap_buffer).l,a0
	move.w	#0,(a1)+
	move.w	(a1)+,d1
	move.w	(a1)+,d2
	move.w	(a1)+,d0
	swap	d0
	andi.l	#$3FFF0000,d0
	ori.l	#$40000003,d0

.LineLoop:
	move.l	d0,(a2)
	move.w	d1,d3

.TileLoop:
	move.w	(a0)+,(a3)
	dbf	d3,.TileLoop
	add.l	d4,d0
	dbf	d2,.LineLoop
	bra.s	.PlaneLoop
; -----------------------------------------------------------------------------------------

.End:
	rts
; End of function ProcEniTilemapQueue


; =============== S U B	R O U T	I N E =====================================================


ClearPlaneA_DMA:
	lea	VDP_CTRL,a0
	move.w	#$8F01,VDP_CTRL
	move.b	#1,(vdp_reg_f).l
	move.l	#$94409300,(a0)
	move.w	#$9780,(a0)
	move.w	#$4000,(a0)
	move.w	#$83,(a0)
	move.w	#0,-4(a0)

.WaitDMA:
	move.w	(a0),d7
	andi.w	#2,d7
	bne.s	.WaitDMA
	move.w	#$8F02,VDP_CTRL
	move.b	#2,(vdp_reg_f).l
	rts
; End of function ClearPlaneA_DMA


; =============== S U B	R O U T	I N E =====================================================


ClearPlaneA:
	DISABLE_INTS
	move.w	#$4000,VDP_CTRL
	move.w	#3,VDP_CTRL
	lea	VDP_DATA,a1
	move.w	#$1FF,d1
	moveq	#0,d0
	bsr.w	MassFill
	ENABLE_INTS
	rts
; End of function ClearPlaneA


; =============== S U B	R O U T	I N E =====================================================


ClearPlaneB:
	DISABLE_INTS
	move.w	#$6000,VDP_CTRL
	move.w	#3,VDP_CTRL
	lea	VDP_DATA,a1
	move.w	#$1FF,d1
	moveq	#0,d0
	bsr.w	MassFill
	ENABLE_INTS
	rts
; End of function ClearPlaneB


; =============== S U B	R O U T	I N E =====================================================

ClearPlaneB_DMA:
	lea	VDP_CTRL,a0
	move.w	#$8F01,VDP_CTRL
	move.b	#1,(vdp_reg_f).l
	move.l	#$94109300,(a0)
	move.w	#$9780,(a0)
	move.w	#$7000,(a0)
	move.w	#$83,(a0)
	move.w	#0,-4(a0)

.WaitDMA:
	move.w	(a0),d7
	andi.w	#2,d7
	bne.s	.WaitDMA
	move.w	#$8F02,VDP_CTRL
	move.b	#2,(vdp_reg_f).l
	rts
; End of function ClearPlaneB_DMA


; =============== S U B	R O U T	I N E =====================================================


MassFill:
	move.l	d0,(a1)
	move.l	d0,(a1)
	move.l	d0,(a1)
	move.l	d0,(a1)
	dbf	d1,MassFill
	rts
; End of function MassFill

; -----------------------------------------------------------------------------------------
	ALIGN	$10000, $FF
byte_30000:
	incbin	"data/artunc/artunc30000.bin"
byte_30880:
	incbin	"data/artunc/artunc30880.bin"
byte_31140:
	incbin	"data/artunc/artunc31140.bin"
byte_31C00:
	incbin	"data/artunc/artunc31C00.bin"
byte_32700:
	incbin	"data/artunc/artunc32700.bin"
byte_331C0:
	incbin	"data/artunc/artunc331C0.bin"
byte_33C00:
	incbin	"data/artunc/artunc33C00.bin"
byte_34600:
	incbin	"data/artunc/artunc34600.bin"
byte_34FC0:
	incbin	"data/artunc/artunc34FC0.bin"
byte_35980:
	incbin	"data/artunc/artunc35980.bin"
byte_363A0:
	incbin	"data/artunc/artunc363A0.bin"
byte_36E00:
	incbin	"data/artunc/artunc36E00.bin"
byte_37720:
	incbin	"data/artunc/artunc37720.bin"
byte_38080:
	incbin	"data/artunc/artunc38080.bin"
byte_38940:
	incbin	"data/artunc/artunc38940.bin"
byte_39200:
	incbin	"data/artunc/artunc39200.bin"
byte_39AC0:
	incbin	"data/artunc/artunc39AC0.bin"
byte_3A3E0:
	incbin	"data/artunc/artunc3A3E0.bin"
byte_3A880:
	incbin	"data/artunc/artunc3A880.bin"
byte_3AC40:
	incbin	"data/artunc/artunc3AC40.bin"
byte_3B080:
	incbin	"data/artunc/artunc3B080.bin"
ArtNem_RobotnikShip:
	incbin	"data/artnem/artnem3B620.bin"
ArtNem_ScratchPortrait:
	incbin	"data/artnem/artnem3BA82.bin"
byte_3CC84:
	incbin	"data/mapeni/mapeni3CC84.bin"
byte_3CC98:
	incbin	"data/mapeni/mapeni3CC98.bin"
byte_3CCB4:
	incbin	"data/mapeni/mapeni3CCB4.bin"
byte_3CCC8:
	incbin	"data/mapeni/mapeni3CCC8.bin"
byte_3CCE8:
	incbin	"data/mapeni/mapeni3CCE8.bin"
byte_3CCFC:
	incbin	"data/mapeni/mapeni3CCFC.bin"
byte_3CD1E:
	incbin	"data/mapeni/mapeni3CD1E.bin"
ArtNem_FranklyPortrait:
	incbin	"data/artnem/artnem3CD38.bin"
byte_3DFCC:
	incbin	"data/mapeni/mapeni3DFCC.bin"
byte_3DFDC:
	incbin	"data/mapeni/mapeni3DFDC.bin"
byte_3DFF6:
	incbin	"data/mapeni/mapeni3DFF6.bin"
byte_3E006:
	incbin	"data/mapeni/mapeni3E006.bin"
byte_3E014:
	incbin	"data/mapeni/mapeni3E014.bin"
byte_3E02C:
	incbin	"data/mapeni/mapeni3E02C.bin"
ArtNem_FranklySparks:
	incbin	"data/artnem/artnem3E038.bin"
	ALIGN	2
ArtNem_CoconutsPortrait:
	incbin	"data/artnem/artnem3E08A.bin"
	ALIGN	2
byte_3F30C:
	incbin	"data/mapeni/mapeni3F30C.bin"
byte_3F320:
	incbin	"data/mapeni/mapeni3F320.bin"
byte_3F33A:
	incbin	"data/mapeni/mapeni3F33A.bin"
byte_3F34C:
	incbin	"data/mapeni/mapeni3F34C.bin"
byte_3F364:
	incbin	"data/mapeni/mapeni3F364.bin"
byte_3F384:
	incbin	"data/mapeni/mapeni3F384.bin"
byte_3F3AC:
	incbin	"data/mapeni/mapeni3F3AC.bin"
byte_3F3CE:
	incbin	"data/mapeni/mapeni3F3CE.bin"
ArtNem_DynamightPortrait:
	incbin	"data/artnem/artnem3F3E0.bin"
	ALIGN	2
byte_4055A:
	incbin	"data/mapeni/mapeni4055A.bin"
byte_4056E:
	incbin	"data/mapeni/mapeni4056E.bin"
byte_40586:
	incbin	"data/mapeni/mapeni40586.bin"
byte_4059A:
	incbin	"data/mapeni/mapeni4059A.bin"
byte_405B4:
	incbin	"data/mapeni/mapeni405B4.bin"
byte_405D0:
	incbin	"data/mapeni/mapeni405D0.bin"
byte_405EC:
	incbin	"data/mapeni/mapeni405EC.bin"
byte_40608:
	incbin	"data/mapeni/mapeni40608.bin"
byte_4061C:
	incbin	"data/mapeni/mapeni4061C.bin"
byte_40636:
	incbin	"data/mapeni/mapeni40636.bin"
byte_40650:
	incbin	"data/mapeni/mapeni40650.bin"
ArtNem_GrounderPortrait:
	incbin	"data/artnem/artnem4065E.bin"
	ALIGN	2
byte_41C9A:
	incbin	"data/mapeni/mapeni41C9A.bin"
byte_41CAE:
	incbin	"data/mapeni/mapeni41CAE.bin"
byte_41CD0:
	incbin	"data/mapeni/mapeni41CD0.bin"
byte_41CF2:
	incbin	"data/mapeni/mapeni41CF2.bin"
byte_41D06:
	incbin	"data/mapeni/mapeni41D06.bin"
byte_41D2E:
	incbin	"data/mapeni/mapeni41D2E.bin"
byte_41D42:
	incbin	"data/mapeni/mapeni41D42.bin"
byte_41D72:
	incbin	"data/mapeni/mapeni41D72.bin"
ArtNem_DavyPortrait:
	incbin	"data/artnem/artnem41D84.bin"
	ALIGN	2
byte_42C96:
	incbin	"data/mapeni/mapeni42C96.bin"
byte_42CAA:
	incbin	"data/mapeni/mapeni42CAA.bin"
byte_42CC8:
	incbin	"data/mapeni/mapeni42CC8.bin"
byte_42CE4:
	incbin	"data/mapeni/mapeni42CE4.bin"
byte_42D0E:
	incbin	"data/mapeni/mapeni42D0E.bin"
byte_42D22:
	incbin	"data/mapeni/mapeni42D22.bin"
byte_42D4A:
	incbin	"data/mapeni/mapeni42D4A.bin"
ArtNem_SpikePortrait:
	incbin	"data/artnem/artnem42D60.bin"
byte_444A6:
	incbin	"data/mapeni/mapeni444A6.bin"
byte_444B8:
	incbin	"data/mapeni/mapeni444B8.bin"
byte_444D8:
	incbin	"data/mapeni/mapeni444D8.bin"
byte_444FA:
	incbin	"data/mapeni/mapeni444FA.bin"
byte_4451E:
	incbin	"data/mapeni/mapeni4451E.bin"
byte_44544:
	incbin	"data/mapeni/mapeni44544.bin"
byte_44552:
	incbin	"data/mapeni/mapeni44552.bin"
byte_4456E:
	incbin	"data/mapeni/mapeni4456E.bin"
ArtNem_DragonPortrait:
	incbin	"data/artnem/artnem4457E.bin"
	ALIGN	2
byte_45D24:
	incbin	"data/mapeni/mapeni45D24.bin"
byte_45D34:
	incbin	"data/mapeni/mapeni45D34.bin"
byte_45D52:
	incbin	"data/mapeni/mapeni45D52.bin"
byte_45D70:
	incbin	"data/mapeni/mapeni45D70.bin"
byte_45D92:
	incbin	"data/mapeni/mapeni45D92.bin"
byte_45DC2:
	incbin	"data/mapeni/mapeni45DC2.bin"
byte_45DD2:
	incbin	"data/mapeni/mapeni45DD2.bin"
byte_45DEC:
	incbin	"data/mapeni/mapeni45DEC.bin"
byte_45E06:
	incbin	"data/mapeni/mapeni45E06.bin"
ArtNem_HumptyPortrait:
	incbin	"data/artnem/artnem45E2A.bin"
byte_46FAA:
	incbin	"data/mapeni/mapeni46FAA.bin"
byte_46FC0:
	incbin	"data/mapeni/mapeni46FC0.bin"
byte_46FE0:
	incbin	"data/mapeni/mapeni46FE0.bin"
byte_47002:
	incbin	"data/mapeni/mapeni47002.bin"
byte_47028:
	incbin	"data/mapeni/mapeni47028.bin"
byte_47052:
	incbin	"data/mapeni/mapeni47052.bin"
byte_47076:
	incbin	"data/mapeni/mapeni47076.bin"
byte_47096:
	incbin	"data/mapeni/mapeni47096.bin"
byte_470B2:
	incbin	"data/mapeni/mapeni470B2.bin"
byte_470CC:
	incbin	"data/mapeni/mapeni470CC.bin"
ArtNem_RobotnikPortrait:
	incbin	"data/artnem/artnem470F0.bin"
	ALIGN	2
byte_48712:
	incbin	"data/mapeni/mapeni48712.bin"
byte_48720:
	incbin	"data/mapeni/mapeni48720.bin"
byte_48736:
	incbin	"data/mapeni/mapeni48736.bin"
byte_4874C:
	incbin	"data/mapeni/mapeni4874C.bin"
byte_48768:
	incbin	"data/mapeni/mapeni48768.bin"
byte_48792:
	incbin	"data/mapeni/mapeni48792.bin"
byte_487AE:
	incbin	"data/mapeni/mapeni487AE.bin"
byte_487CE:
	incbin	"data/mapeni/mapeni487CE.bin"
ArtNem_SkweelPortrait:
	incbin	"data/artnem/artnem487E2.bin"
	ALIGN	2
byte_49C22:
	incbin	"data/mapeni/mapeni49C22.bin"
byte_49C36:
	incbin	"data/mapeni/mapeni49C36.bin"
byte_49C4E:
	incbin	"data/mapeni/mapeni49C4E.bin"
byte_49C6A:
	incbin	"data/mapeni/mapeni49C6A.bin"
byte_49C7C:
	incbin	"data/mapeni/mapeni49C7C.bin"
byte_49C90:
	incbin	"data/mapeni/mapeni49C90.bin"
byte_49CA4:
	incbin	"data/mapeni/mapeni49CA4.bin"
byte_49CB8:
	incbin	"data/mapeni/mapeni49CB8.bin"
byte_49CDA:
	incbin	"data/mapeni/mapeni49CDA.bin"
byte_49CFC:
	incbin	"data/mapeni/mapeni49CFC.bin"
byte_49D20:
	incbin	"data/mapeni/mapeni49D20.bin"
byte_49D40:
	incbin	"data/mapeni/mapeni49D40.bin"
byte_49D60:
	incbin	"data/mapeni/mapeni49D60.bin"
ArtNem_SirFfuzzyPortrait:
	incbin	"data/artnem/artnem49D74.bin"
	ALIGN	2
byte_4B20A:
	incbin	"data/mapeni/mapeni4B20A.bin"
byte_4B218:
	incbin	"data/mapeni/mapeni4B218.bin"
byte_4B232:
	incbin	"data/mapeni/mapeni4B232.bin"
byte_4B24E:
	incbin	"data/mapeni/mapeni4B24E.bin"
byte_4B26C:
	incbin	"data/mapeni/mapeni4B26C.bin"
byte_4B28E:
	incbin	"data/mapeni/mapeni4B28E.bin"
byte_4B2B0:
	incbin	"data/mapeni/mapeni4B2B0.bin"
byte_4B2D0:
	incbin	"data/mapeni/mapeni4B2D0.bin"
byte_4B2F4:
	incbin	"data/mapeni/mapeni4B2F4.bin"
byte_4B314:
	incbin	"data/mapeni/mapeni4B314.bin"
byte_4B330:
	incbin	"data/mapeni/mapeni4B330.bin"
byte_4B350:
	incbin	"data/mapeni/mapeni4B350.bin"
ArtNem_ArmsPortrait:
	incbin	"data/artnem/artnem4B370.bin"
byte_4C2D4:
	incbin	"data/mapeni/mapeni4C2D4.bin"
byte_4C2E4:
	incbin	"data/mapeni/mapeni4C2E4.bin"
byte_4C2FA:
	incbin	"data/mapeni/mapeni4C2FA.bin"
byte_4C310:
	incbin	"data/mapeni/mapeni4C310.bin"
byte_4C33A:
	incbin	"data/mapeni/mapeni4C33A.bin"
byte_4C368:
	incbin	"data/mapeni/mapeni4C368.bin"
byte_4C394:
	incbin	"data/mapeni/mapeni4C394.bin"
byte_4C3B8:
	incbin	"data/mapeni/mapeni4C3B8.bin"
byte_4C3E0:
	incbin	"data/mapeni/mapeni4C3E0.bin"
byte_4C40E:
	incbin	"data/mapeni/mapeni4C40E.bin"
ArtNem_IntroBadniks:
	incbin	"data/artnem/artnem4C432.bin"
	ALIGN	2
ArtNem_OpponentScreen:
	incbin	"data/artnem/artnem4CBB8.bin"
	ALIGN	2
ArtNem_Password:
	incbin	"data/artnem/artnem4D664.bin"
	ALIGN	2
ArtNem_RoleCallTextbox:
	incbin	"data/artnem/artnem4F9BA.bin"
	ALIGN	2
ArtNem_MainFont:
	incbin	"data/artnem/artnem4F9FC.bin"
	ALIGN	2
ArtNem_CoconutsCutscene:
	incbin	"data/artnem/artnem4FCEE.bin"
ArtNem_FranklyCutscene:
	incbin	"data/artnem/artnem50A74.bin"
	ALIGN	2
ArtNem_DavyCutscene:
	incbin	"data/artnem/artnem51CDC.bin"
ArtNem_DynamightCutscene:
	incbin	"data/artnem/artnem52C98.bin"
	ALIGN	2
ArtNem_ArmsCutscene:
	incbin	"data/artnem/artnem53A66.bin"
ArtNem_ArmsIntro2:
	incbin	"data/artnem/artnem549F8.bin"
ArtNem_DragonCutscene:
	incbin	"data/artnem/artnem54D74.bin"
	ALIGN	2
ArtNem_SpikeCutscene:
	incbin	"data/artnem/artnem559DC.bin"
ArtNem_SirFfuzzyCutscene:
	incbin	"data/artnem/artnem565F4.bin"
	ALIGN	2
ArtNem_HumptyCutscene:
	incbin	"data/artnem/artnem571EA.bin"
ArtNem_GrounderCutscene:
	incbin	"data/artnem/artnem582BE.bin"
	ALIGN	2
ArtNem_VSWinLose:
	incbin	"data/artnem/artnem59046.bin"
	ALIGN	2
ArtNem_SkweelCutscene:
	incbin	"data/artnem/artnem5A0EC.bin"
ArtNem_ScratchCutscene:
	incbin	"data/artnem/artnem5AF08.bin"
	ALIGN	$5FC00, $FF
ArtNem_LvlIntroBG:	
	incbin	"data/artnem/artnem5FC00.bin"
byte_6199E:
	incbin	"data/mapeni/mapeni6199E.bin"
byte_61A8A:
	incbin	"data/mapeni/mapeni61A8A.bin"
byte_61B22:
	incbin	"data/mapeni/mapeni61B22.bin"
ArtNem_Intro:	
	incbin	"data/artnem/artnem61BD0.bin"
	ALIGN	2
MapEni_LairMachine:
	incbin	"data/mapeni/mapeni6432E.bin"
MapEni_LairWall:
	incbin	"data/mapeni/mapeni644B4.bin"
MapEni_LairFloor:
	incbin	"data/mapeni/mapeni645D8.bin"
MapPrio_LairMachine:dc.b	0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
	dc.b	0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
	dc.b	0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
	dc.b	0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
	dc.b	0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
	dc.b	0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
	dc.b	0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
	dc.b	0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
	dc.b	0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
	dc.b	0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
	dc.b	0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
	dc.b	0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
	dc.b	0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
	dc.b	0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
	dc.b	0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
	dc.b	0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
	dc.b	0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
	dc.b	0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
	dc.b	0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
	dc.b	0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
	dc.b	0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
	dc.b	0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
	dc.b	0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
	dc.b	0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
	dc.b	0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
	dc.b	0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
	dc.b	0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
	dc.b	0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
	dc.b	0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
	dc.b	0, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 1, 1
	dc.b	0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0
	dc.b	0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1
	dc.b	0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 1, 1, 1, 1, 1
	dc.b	1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
	dc.b	0, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 1, 1
	dc.b	0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0
	dc.b	0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1
	dc.b	0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 1, 1, 1, 1
	dc.b	1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
	dc.b	0, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 1, 1
	dc.b	0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0
	dc.b	0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1
	dc.b	0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0
	dc.b	0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
	dc.b	0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
	dc.b	0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
	dc.b	0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
	dc.b	0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
	dc.b	0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
	dc.b	0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
ArtNem_EndingBG:
	incbin	"data/artnem/artnem6495A.bin"
	ALIGN	2
byte_6622E:
	incbin	"data/mapeni/mapeni6622E.bin"
byte_66348:
	incbin	"data/mapeni/mapeni66348.bin"
byte_6646C:
	incbin	"data/mapeni/mapeni6646C.bin"
ArtNem_CreditsLair:
	incbin	"data/artnem/artnem664CE.bin"
ArtNem_GameOver:
	incbin	"data/artnem/artnem665EA.bin"
	ALIGN	2
byte_66C9A
	dc.b	0, 0, 0, 1, 0, 1, 0, 1, 8, 0, 0, $A, 0, $B, 0, $C
	dc.b	8, $B, 8, $A, 0, $A, 0, $14, 0, 6, 8, $14, 8, $A, 0, $A
	dc.b	0, $14, 0, 6, 8, $14, 8, $A, 0, $A, 0, $14, 0, 6, 8, $14
	dc.b	8, $A, 0, $A, $10, $B, $10, $C, $18, $B, 8, $A, $10, 0, $10, 1
	dc.b	$10, 1, $10, 1, $18, 0, 0, 2, 0, 3, 0, 4, 0, 5, 0, 6
	dc.b	0, $D, 0, $E, 0, $F, 0, $10, 0, 6, 0, 6, 0, $15, 0, $F
	dc.b	0, $10, 0, 6, 0, 6, 0, $15, 0, $F, 0, $10, 0, 6, 0, 6
	dc.b	0, $15, 0, $F, 0, $10, 0, 6, 0, 6, 0, $15, 0, $F, 0, $10
	dc.b	0, 6, 0, 6, 0, $37, $10, 1, $10, 5, 0, 6, 0, 0, 0, 1
	dc.b	0, 1, 0, 1, 8, 0, 0, $A, 0, $B, 0, $C, 8, $B, 8, $A
	dc.b	0, $16, 0, $17, 0, $18, 0, $19, 0, $1A, 0, 6, 0, $18, 0, $22
	dc.b	0, $23, 0, $24, 0, $18, 0, $22, 0, $23, 0, $29, 0, 6, 0, $31
	dc.b	0, $F, 0, $32, 0, $33, $18, $16, 0, $34, $10, 1, $10, 1, $10, 1
	dc.b	8, $34, 0, 0, 0, 1, 0, 1, 0, 1, 8, 0, 0, $A, 0, $B
	dc.b	0, $C, 8, $B, 8, $A, 0, $1B, 0, $1C, 0, $1D, 0, $1E, 0, $1F
	dc.b	0, 6, 0, $25, 0, $26, 0, $F, 0, $27, 0, $2A, 0, $2B, 0, $2C
	dc.b	0, $2D, 8, $A, 0, $A, $10, $B, $10, $C, $18, $B, 8, $A, $10, 0
	dc.b	$10, 1, $10, 1, $10, 1, $18, 0, 0, 6, 0, 7, 0, 8, 0, 1
	dc.b	0, 9, 0, 6, 0, $11, 0, $12, 0, $F, 0, $13, 0, 7, 0, $20
	dc.b	0, $21, 0, $F, 0, $13, 0, $11, $18, $20, 0, $28, 0, $F, 0, $13
	dc.b	$18, $1A, 0, $2E, 0, $2F, 0, $F, 0, $30, 0, $34, $10, 1, 0, $35
	dc.b	0, $F, 0, $36, 0, 6, 0, 6, 0, $37, $10, 1, $10, 9, $10, $34
	dc.b	0, 1, 0, 1, 0, 1, $18, $34, 0, $A, 0, $B, 0, $38, 0, $38
	dc.b	0, $39, 0, $A, $10, $B, 0, $3B, 0, $3C, 0, $3D, 8, $39, 0, $44
	dc.b	0, $45, 0, $2D, 8, $A, 0, $2A, 0, $2B, 0, 6, 8, $14, 8, $A
	dc.b	0, $A, $10, $B, $10, $C, $18, $B, 8, $A, $10, 0, $10, 1, $10, 1
	dc.b	$10, 1, $18, 0, 0, 0, 0, 1, 0, 1, 0, 1, 8, 0, 0, $A
	dc.b	0, $B, 0, $C, 8, $B, 8, $A, 0, $A, 0, $14, 0, $3E, 0, $3F
	dc.b	0, $40, 0, $A, 8, $1E, 0, $46, 0, $F, 0, $47, 0, $A, $18, $19
	dc.b	$10, $43, $10, $19, 8, $A, 0, $A, $10, $B, $10, $C, $18, $B, 8, $A
	dc.b	$10, 0, $10, 1, $10, 1, $10, 1, $18, 0, $10, $34, 0, 1, 0, 1
	dc.b	0, 1, $18, $34, 8, $39, 0, $38, 0, $3A, 0, $F, 0, $1F, 0, 6
	dc.b	0, 6, 0, $41, 0, $F, 0, $42, 0, 6, 0, $48, 0, $49, 0, $4A
	dc.b	0, $4B, 0, 6, 0, $41, 0, $F, 0, $42, 0, 6, 0, $48, 0, $49
	dc.b	0, $4A, 0, $4B, 0, 6, 0, $50, $10, 1, 0, $51, 0, 6, 0, 6
	dc.b	0, 0, 0, 1, 0, 1, 0, 1, 8, 0, 0, $A, 0, $B, 0, $C
	dc.b	8, $B, 8, $A, 8, $1F, $10, $B, $10, $C, $18, $B, 0, $1F, 0, $4C
	dc.b	0, $F, 0, $4D, 0, $F, 8, $4C, 0, $A, 0, $4E, 0, $4F, 8, $4E
	dc.b	8, $A, 0, $A, $10, $B, $10, $C, $18, $B, 8, $A, $10, 0, $10, 1
	dc.b	$10, 1, $10, 1, $18, 0, 0, 0, 0, 1, 0, 1, 0, 1, 8, 0
	dc.b	0, $A, 0, $B, 0, $C, 8, $B, 8, $A, 0, $A, 8, $19, 0, $43
	dc.b	0, $19, 8, $A, $18, $47, 0, $F, $18, $46, $10, $1E, 8, $A, $18, $40
	dc.b	$18, $3F, $18, $3E, 8, $14, 8, $A, 0, $A, $10, $B, $10, $C, $18, $B
	dc.b	8, $A, $10, 0, $10, 1, $10, 1, $10, 1, $18, 0, 0, 0, 0, 1
	dc.b	0, 1, 0, 1, 8, 0, 0, $A, 0, $B, 0, $C, 8, $B, 8, $A
	dc.b	0, $A, 8, $19, 0, $43, 0, $19, 8, $A, $18, $47, 0, $F, $18, $46
	dc.b	$10, $1E, 8, $A, $18, $40, $18, $3F, $18, $3E, 8, $14, 8, $A, 0, $A
	dc.b	$10, $B, $10, $C, $18, $B, 8, $A, $10, 0, $10, 1, $10, 1, $10, 1
	dc.b	$18, 0
ArtNem_GameOverBG:
	incbin	"data/artnem/artnem66F9C.bin"
byte_69FBE:
	incbin	"data/mapeni/mapeni69FBE.bin"
byte_6A0AA:
	incbin	"data/mapeni/mapeni6A0AA.bin"
byte_6A144
	dc.b	0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
	dc.b	0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
	dc.b	0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
	dc.b	0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
	dc.b	0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
	dc.b	0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
	dc.b	0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
	dc.b	0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
	dc.b	0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
	dc.b	0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
	dc.b	0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
	dc.b	0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
	dc.b	0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
	dc.b	0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
	dc.b	0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
	dc.b	0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
	dc.b	0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
	dc.b	0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
	dc.b	0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
	dc.b	0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
	dc.b	0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
	dc.b	0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
	dc.b	0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
	dc.b	0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
	dc.b	0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
	dc.b	0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
	dc.b	0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
	dc.b	0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
	dc.b	0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
	dc.b	0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
	dc.b	0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
	dc.b	0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
	dc.b	0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
	dc.b	0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1
	dc.b	1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
	dc.b	0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1
	dc.b	1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0
	dc.b	0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
	dc.b	0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1
	dc.b	1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
	dc.b	0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1
	dc.b	1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0
	dc.b	0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
	dc.b	0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1
	dc.b	1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
	dc.b	0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1
	dc.b	1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0
	dc.b	0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
	dc.b	0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
	dc.b	0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
	dc.b	0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
	dc.b	0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
	dc.b	0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
	dc.b	0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
	dc.b	0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
	dc.b	0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
	dc.b	0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
	dc.b	0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
	dc.b	0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
	dc.b	0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
	dc.b	0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
	dc.b	0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
	dc.b	0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
	dc.b	0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
	dc.b	0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
	dc.b	0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
	dc.b	0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
	dc.b	0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
	dc.b	0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
	dc.b	0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
ArtNem_MainMenu:
	incbin	"data/artnem/artnem6A5A4.bin"
	ALIGN	2
MapEni_MainMenu:
	incbin	"data/mapeni/mapeni6C7C2.bin"
MapEni_ScenarioMenu:
	incbin	"data/mapeni/mapeni6C872.bin"
MapEni_MainMenuClouds:
	incbin	"data/mapeni/mapeni6C910.bin"
MapEni_MainMenuMountains:
	incbin	"data/mapeni/mapeni6C99C.bin"
ArtNem_HighScores:
	incbin	"data/artnem/artnem6CA30.bin"
byte_6EB68:
	incbin	"data/mapeni/mapeni6EB68.bin"
ArtNem_CreditsSky:
	incbin	"data/artnem/artnem6ED46.bin"
byte_6F158:
	incbin	"data/mapeni/mapeni6F158.bin"
ArtNem_CreditsSmoke:
	incbin	"data/artnem/artnem6F244.bin"
ArtNem_CreditsExplosion:
	incbin	"data/artnem/artnem6F348.bin"
word_6F3FE
	dc.w	0, 0, $884, $862, $ACA, $6A8, $486, $264, $6AE, $62, $A4, $4C8, $26, $4A, $28C, $EEE
	dc.w	0, 0, $884, $862, $ACA, $6A8, $486, $264, $6AE, $62, $A4, $4C8, $26, $4A, $28C, $EEE
	dc.w	0, 0, $884, $862, $ACA, $6A8, $486, $264, $6AE, $62, $A4, $4C8, $26, $4A, $28C, $EEE
	dc.w	0, 0, $884, $862, $ACA, $6A8, $486, $264, $6AE, $62, $A4, $4C8, $26, $4A, $28C, $EEE
	dc.w	0, 0, $884, $862, $ACA, $6A8, $486, $264, $6AE, $62, $A4, $4C8, $26, $4A, $28C, $EEE
	dc.w	0, 0, $884, $862, $ACA, $6A8, $486, $264, $6AE, $62, $A4, $4C8, $26, $4A, $28C, $EEE
	dc.w	0, 0, $884, $862, $ACA, $6A8, $486, $264, $6AE, $62, $A4, $2C8, $26, $4A, $28C, $EEE
	dc.w	0, 0, $884, $862, $8CA, $6A8, $486, $264, $6AE, $62, $A4, $2C8, $26, $4A, $28C, $EEE
	dc.w	0, 0, $884, $862, $8CA, $6A8, $486, $264, $6AE, $62, $A4, $2C8, $26, $4A, $28C, $EEE
	dc.w	0, 0, $662, $642, $6A8, $486, $464, $242, $48C, $42, $84, $A8, $26, $4A, $26A, $EEE
	dc.w	0, 0, $662, $642, $6A8, $486, $464, $242, $48C, $42, $84, $A8, $26, $4A, $26A, $EEE
	dc.w	0, 0, $662, $642, $6A8, $486, $464, $242, $48C, $42, $84, $A8, $26, $4A, $26A, $EEE
	dc.w	0, 0, $662, $642, $6A8, $486, $464, $242, $48C, $42, $84, $A8, $26, $4A, $26A, $EEE
	dc.w	0, 0, $662, $642, $6A8, $486, $464, $242, $48C, $42, $84, $A8, $26, $4A, $26A, $EEE
	dc.w	0, 0, $662, $642, $6A8, $486, $464, $242, $68C, $242, $284, $2A8, $26, $4A, $26A, $EEE
	dc.w	0, 0, $662, $642, $6A6, $684, $462, $242, $68C, $242, $284, $2A8, $26, $4A, $26A, $EEE
	dc.w	0, 0, $662, $642, $6A6, $684, $462, $242, $68C, $242, $484, $4A8, $26, $248, $46A, $EEE
	dc.w	0, 0, $642, $622, $6A6, $682, $662, $442, $88C, $442, $684, $4A8, $24, $448, $66A, $EEE
	dc.w	0, 0, $642, $622, $8A6, $682, $662, $442, $88A, $442, $884, $8A8, $222, $646, $868, $EEE
	dc.w	0, 0, $642, $622, $8A6, $682, $662, $442, $88A, $442, $884, $8A8, $222, $646, $868, $EEE
	dc.w	0, 0, $642, $622, $884, $664, $642, $422, $A8A, $442, $884, $AA8, $222, $646, $868, $EEE
	dc.w	0, 0, $842, $822, $884, $662, $640, $420, $A8A, $442, $864, $A86, $222, $646, $868, $EEE
	dc.w	0, 0, $842, $822, $864, $642, $640, $420, $A88, $422, $862, $A84, $200, $644, $866, $EEE
	dc.w	0, 0, $842, $822, $862, $642, $640, $420, $A66, $422, $862, $A84, $200, $622, $844, $EEE
	dc.w	0, 0, $842, $822, $862, $642, $640, $420, $A66, $422, $862, $A84, $200, $622, $844, $EEE
	dc.w	0, 0, $842, $822, $862, $642, $640, $420, $A66, $422, $862, $A84, $200, $622, $844, $EEE
	dc.w	0, 0, $842, $822, $862, $642, $640, $420, $A66, $422, $862, $A84, $200, $622, $844, $EEE
	dc.w	0, 0, $842, $822, $862, $642, $640, $420, $A66, $422, $862, $A84, $200, $622, $844, $EEE
	dc.w	0, 0, $842, $822, $862, $642, $640, $420, $A66, $422, $862, $A84, $200, $622, $844, $EEE
	dc.w	0, 0, $842, $822, $862, $642, $640, $420, $A66, $422, $862, $A84, $200, $622, $844, $EEE
	dc.w	0, 0, $842, $822, $862, $642, $640, $420, $A66, $422, $862, $A84, $200, $622, $844, $EEE
	dc.w	0, 0, $842, $822, $862, $642, $640, $420, $A66, $422, $862, $A84, $200, $622, $844, $EEE
	dc.w	0, 0, $842, $822, $862, $642, $640, $420, $A66, $422, $862, $A84, $200, $622, $844, $EEE
	dc.w	0, 0, $842, $822, $862, $642, $640, $420, $A66, $422, $862, $A84, $200, $622, $844, $EEE
	dc.w	0, 0, $842, $822, $862, $642, $640, $420, $A66, $422, $862, $A84, $200, $622, $844, $EEE
word_6F85E
	dc.w	0, 0, $222, $666, $AAA, $200, $200, $200, $EEE, $E84, $EA4, $EAA, $E84, $EC6, $EEA, $EEE
	dc.w	0, 0, $222, $666, $AAA, $200, $200, $200, $EEE, $C84, $CA4, $EAA, $C84, $CC6, $EEA, $EEE
	dc.w	0, 0, $222, $666, $AAA, $200, $200, $200, $EEE, $C86, $AA8, $EAA, $A88, $ACA, $CEC, $EEE
	dc.w	0, 0, $222, $666, $AAA, $200, $200, $200, $EEE, $C86, $8AA, $EAA, $88A, $ACA, $CCC, $EEE
	dc.w	0, 0, $222, $666, $AAA, $200, $200, $200, $EEE, $C86, $6AC, $EAA, $68C, $8CC, $ACE, $EEE
	dc.w	0, 0, $222, $666, $AAC, $200, $200, $200, $AEE, $C86, $6AE, $EAA, $68E, $6CE, $ACE, $EEE
	dc.w	0, 0, $222, $666, $AAC, $200, $200, $200, $8CE, $C86, $4AE, $EAA, $48E, $4CE, $8CE, $EEE
	dc.w	0, 0, $222, $666, $AAC, $200, $200, $200, $8CE, $C86, $2AE, $EAA, $48E, $2CE, $6CE, $EEE
	dc.w	0, 0, $222, $666, $AAC, $200, $200, $200, $6CE, $C86, $AE, $EAA, $28E, $2CE, $6CE, $EEE
	dc.w	0, 0, $224, $668, $AAC, $200, $200, $200, $4CE, $C66, $6E, $EAA, $24E, $8E, $4AE, $EEE
	dc.w	0, 0, $224, $668, $AAC, $200, $200, $200, $4AE, $C66, $24E, $EAA, $44C, $6E, $28E, $EEE
	dc.w	0, 0, $224, $668, $AAC, $200, $200, $200, $4AE, $C66, $44C, $EAA, $42A, $24E, $6E, $EEE
	dc.w	0, 0, $224, $668, $AAC, $200, $200, $200, $26C, $A66, $22A, $6AC, $428, $22C, $26E, $EEE
	dc.w	0, 0, $224, $668, $AAC, $200, $200, $200, $26C, $A66, $428, $A8A, $426, $22A, $24E, $EEE
	dc.w	0, 0, $224, $666, $AAC, $200, $200, $200, $26C, $A66, $426, $C8A, $424, $42A, $24E, $EEE
	dc.w	0, 0, $224, $666, $AAA, $200, $200, $200, $26C, $A66, $424, $C8A, $422, $428, $24C, $EEE
	dc.w	0, 0, $222, $666, $AAC, $200, $200, $200, $24A, $A66, $422, $88A, $420, $426, $22A, $EEE
	dc.w	0, 0, $222, $666, $AAA, $200, $200, $200, $448, $844, $602, $A68, $400, $624, $428, $EEE
	dc.w	0, 0, $222, $666, $A88, $200, $200, $200, $626, $844, $600, $A68, $400, $624, $426, $EEE
	dc.w	0, 0, $422, $866, $A88, $200, $200, $200, $426, $844, $400, $A68, $400, $422, $226, $ECC
	dc.w	0, 0, $422, $866, $A88, $200, $200, $200, $426, $622, $200, $846, $200, $402, $226, $ECC
	dc.w	0, 0, $422, $844, $866, $200, $200, $200, $426, $420, $200, $644, $200, $402, $424, $CAA
	dc.w	0, 0, $422, $844, $866, $200, $200, $200, $424, $400, $200, $624, $200, $400, $422, $CAA
	dc.w	0, 0, $422, $844, $866, $200, $200, $200, $800, $400, $200, $620, $200, $400, $600, $CAA
	dc.w	0, 0, $422, $844, $866, $200, $200, $200, $800, $400, $200, $620, $200, $200, $400, $CAA
	dc.w	0, 0, $422, $844, $866, $200, $200, $200, $400, $400, $200, $620, $200, $200, $200, $CAA
	dc.w	0, 0, $422, $844, $866, $200, $200, $200, $200, $400, $200, $620, $200, $200, $200, $CAA
	dc.w	0, 0, $200, $200, $200, $200, $200, $200, $200, $200, $200, $200, $200, $200, $200, $CAA
	dc.w	0, 0, $200, $200, $200, $400, $200, $222, $200, $200, $200, $200, $200, $200, $200, $CAA
	dc.w	0, 0, $200, $200, $420, $400, $200, $444, $200, $200, $200, $200, $200, $200, $200, $CAA
	dc.w	0, 0, $200, $200, $420, $600, $200, $666, $200, $200, $200, $200, $200, $200, $200, $CAA
	dc.w	0, 0, $200, $200, $640, $602, $200, $888, $200, $200, $200, $200, $200, $200, $200, $CAA
	dc.w	0, 0, $200, $200, $642, $804, $200, $AAA, $200, $200, $200, $200, $200, $200, $200, $CAA
	dc.w	0, 0, $200, $200, $864, $A06, $220, $CCC, $200, $400, $200, $420, $200, $200, $200, $CAA
	dc.w	0, 0, $422, $400, $866, $A08, $222, $EEE, $200, $400, $640, $620, $864, $A86, $CA8, $EEA
	dc.w	0, 0, $842, $822, $862, $642, $640, $420, $A66, $422, $862, $A84, $200, $622, $844, $EEE
	dc.w	0, 0, $422, $844, $866, $A08, $222, $CCC, $200, $400, $200, $620, $200, $200, $200, $CAA
	ALIGN	$10000, $FF

; -----------------------------------------------------------------------------------------

					if PuyoCompression=0 ; Puyo Graphics use Compile Compression
ArtPuyo_StageBG:
					incbin	"data/artpuyo/Compression - Compile/Stage - Background.cmp"
					even
					
ArtPuyo_VSWinLose:
					incbin	"data/artpuyo/Compression - Compile/VS Win Lose.cmp"
					even
					
ArtPuyo_StageCutscene:
					incbin	"data/artpuyo/Compression - Compile/Stage - Cutscene.cmp"
					even
					
ArtPuyo_LessonMode:
					incbin	"data/artpuyo/Compression - Compile/Lesson Mode.cmp"
					even
					
ArtPuyo_StageFonts:
					incbin	"data/artpuyo/Compression - Compile/Font - Stage.cmp"
					even
					
ArtPuyo_OldRoleCallFont:
					incbin	"data/artpuyo/Compression - Compile/Font - Puyo Cast.cmp"
					even
					
ArtPuyo_Tutorial:
					incbin	"data/artpuyo/Compression - Compile/Tutorial.cmp"
					even
					
ArtPuyo_OldFont:
					incbin	"data/artpuyo/Compression - Compile/Font - Puyo Options.cmp"
					even
					
ArtPuyo_Harpy:
					incbin	"data/artpuyo/Compression - Compile/Harpy.cmp"
					even
					
ArtPuyo_StageSprites:
					incbin	"data/artpuyo/Compression - Compile/Stage - Sprites.cmp"
					even
					
ArtPuyo_BestRecord:
					incbin	"data/artpuyo/Compression - Compile/Best Records.cmp"
					even
					
ArtPuyo_BestRecordModes:
					incbin	"data/artpuyo/Compression - Compile/Record Modes.cmp"
					even
					
ArtPuyo_OldGameOver:
					incbin	"data/artpuyo/Compression - Compile/Puyo Game Over.cmp"
					even
					
; -----------------------------------------------------------------------------------------
					
					else	; Puyo Graphics use Nemesis Compression
ArtPuyo_StageBG:
					incbin	"data/artpuyo/Compression - Nemesis/Stage - Background.nem"
					even
					
ArtPuyo_VSWinLose:
					incbin	"data/artpuyo/Compression - Nemesis/VS Win Lose.nem"
					even
					
ArtPuyo_StageCutscene:
					incbin	"data/artpuyo/Compression - Nemesis/Stage - Cutscene.nem"
					even
					
ArtPuyo_LessonMode:
					incbin	"data/artpuyo/Compression - Nemesis/Lesson Mode.nem"
					even
					
ArtPuyo_StageFonts:
					incbin	"data/artpuyo/Compression - Nemesis/Font - Stage.nem"
					even
					
ArtPuyo_OldRoleCallFont:
					incbin	"data/artpuyo/Compression - Nemesis/Font - Puyo Cast.nem"
					even
					
ArtPuyo_Tutorial:
					incbin	"data/artpuyo/Compression - Nemesis/Tutorial.nem"
					even
					
ArtPuyo_OldFont:
					incbin	"data/artpuyo/Compression - Nemesis/Font - Puyo Options.nem"
					even
					
ArtPuyo_Harpy:
					incbin	"data/artpuyo/Compression - Nemesis/Harpy.nem"
					even
					
ArtPuyo_StageSprites:
					incbin	"data/artpuyo/Compression - Nemesis/Stage - Sprites.nem"
					even
					
ArtPuyo_BestRecord:
					incbin	"data/artpuyo/Compression - Nemesis/Best Records.nem"
					even
					
ArtPuyo_BestRecordModes:
					incbin	"data/artpuyo/Compression - Nemesis/Record Modes.nem"
					even
					
ArtPuyo_OldGameOver:
					incbin	"data/artpuyo/Compression - Nemesis/Puyo Game Over.nem"
					even					
					endc	

; -----------------------------------------------------------------------------------------					
					
					ALIGN	$10000, $FF
					
ArtNem_TitleLogo:
					incbin	"data/artnem/artnem90000.bin"
					
MapEni_TitleLogo:
					incbin	"data/mapeni/mapeni94716.bin"
					
MapEni_TitleRobotnik:
					incbin	"data/mapeni/mapeni94738.bin"
					
ArtNem_EndingSprites:
					incbin	"data/artnem/artnem947A2.bin"
					ALIGN	2
					
ArtNem_SegaLogo:
					incbin	"data/artnem/artnem95FC6.bin"
					
ArtNem_DifficultyFaces:
					incbin	"data/artnem/artnem97560.bin"
					ALIGN	2
					
ArtNem_DifficultyFaces2:
					incbin	"data/artnem/artnem97B02.bin"
					
byte_97DA2:
					incbin	"data/artunc/artunc97DA2.bin"
					
byte_98702:
					incbin	"data/artunc/artunc98702.bin"
					
byte_99042:
					incbin	"data/artunc/artunc99042.bin"
					
ArtNem_HasBeanShadow:
					incbin	"data/artnem/artnem99982.bin"
	
					ALIGN	$B0000, $FF
	
; -----------------------------------------------------------------------------------------
; Sound data
; -----------------------------------------------------------------------------------------

					include  "sound/sound.asm"
				
; ==============================================================	

					align 	$100000, $FF ; Sets ROM Size to 1MB

EndOfRom:					
					END