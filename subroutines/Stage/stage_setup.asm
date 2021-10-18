; --------------------------------------------------------------
;
;	Dr. Robotnik's Mean Bean Machine Disassembly
;	Original game by Compile
;
;	Disassembled by Devon Artmeier
;
; --------------------------------------------------------------

; --------------------------------------------------------------
; Play stage cutscene music
; --------------------------------------------------------------

PlayStageCutsceneMusic:
	clr.w	d1					; Play stage cutscene music
	move.b	stage,d1
	move.b	.MusicIDs(pc,d1.w),d0
	jmp	JmpTo_PlaySound

; --------------------------------------------------------------

.MusicIDs:
	dc.b	0					; Lesson Stage 1 (Unused)
	dc.b	0					; Lesson Stage 2 (Unused)
	dc.b	0					; Lesson Stage 3 (Unused)

	dc.b	BGM_CUTSCENE_1				; Scenario Stage 1
	dc.b	BGM_CUTSCENE_1				; Scenario Stage 2
	dc.b	BGM_CUTSCENE_1				; Scenario Stage 3
	dc.b	BGM_CUTSCENE_1				; Scenario Stage 4
	dc.b	BGM_CUTSCENE_2				; Scenario Stage 5
	dc.b	BGM_CUTSCENE_2				; Scenario Stage 6
	dc.b	BGM_CUTSCENE_2				; Scenario Stage 7
	dc.b	BGM_CUTSCENE_2				; Scenario Stage 8
	dc.b	BGM_CUTSCENE_3				; Scenario Stage 9
	dc.b	BGM_CUTSCENE_3				; Scenario Stage 10
	dc.b	BGM_CUTSCENE_3				; Scenario Stage 11
	dc.b	BGM_CUTSCENE_3				; Scenario Stage 12
	dc.b	BGM_FINAL_CUTSCENE			; Scenario Stage 13

	ALIGN	2

; --------------------------------------------------------------
; Play stage music
; --------------------------------------------------------------

PlayStageMusic:
	clr.w	d1					; Get stage music ID
	move.b	stage,d1
	move.b	.MusicIDs(pc,d1.w),d0
	cmp.b	current_stage_music,d0			; Is this a new music track being played?
	bne.w	.NewTrack				; If so, branch
	rts

.NewTrack:
	move.b	d0,current_stage_music			; Set current music ID
	jmp	JmpTo_PlaySound				; Play stage music

; --------------------------------------------------------------

.MusicIDs:
	dc.b	0					; Lesson Stage 1 (Unused)
	dc.b	0					; Lesson Stage 2 (Unused)
	dc.b	0					; Lesson Stage 3 (Unused)

	dc.b	BGM_STAGE_1				; Scenario Stage 1
	dc.b	BGM_STAGE_1				; Scenario Stage 2
	dc.b	BGM_STAGE_1				; Scenario Stage 3
	dc.b	BGM_STAGE_1				; Scenario Stage 4
	dc.b	BGM_STAGE_2				; Scenario Stage 5
	dc.b	BGM_STAGE_2				; Scenario Stage 6
	dc.b	BGM_STAGE_2				; Scenario Stage 7
	dc.b	BGM_STAGE_2				; Scenario Stage 8
	dc.b	BGM_STAGE_3				; Scenario Stage 9
	dc.b	BGM_STAGE_3				; Scenario Stage 10
	dc.b	BGM_STAGE_3				; Scenario Stage 11
	dc.b	BGM_STAGE_3				; Scenario Stage 12
	dc.b	BGM_FINAL_STAGE				; Scenario Stage 13

	ALIGN	2

; --------------------------------------------------------------
; Play stage win music
; --------------------------------------------------------------

PlayStageWinMusic:					; Get stage win music ID
	clr.w	d1
	move.b	stage,d1
	move.b	.MusicIDs(pc,d1.w),d0
	cmp.b	current_stage_music,d0			; Is this a new music track being played?
	bne.w	.NewTrack				; If so, branch
	rts

.NewTrack:
	move.b	d0,current_stage_music			; Set current music ID
	jmp	JmpTo_PlaySound				; Play stage win music

; --------------------------------------------------------------

.MusicIDs:
	dc.b	0					; Lesson Stage 1 (Unused)
	dc.b	0					; Lesson Stage 2 (Unused)
	dc.b	0					; Lesson Stage 3 (Unused)

	dc.b	BGM_WIN					; Scenario Stage 1
	dc.b	BGM_WIN					; Scenario Stage 2
	dc.b	BGM_WIN					; Scenario Stage 3
	dc.b	BGM_WIN					; Scenario Stage 4
	dc.b	BGM_WIN					; Scenario Stage 5
	dc.b	BGM_WIN					; Scenario Stage 6
	dc.b	BGM_WIN					; Scenario Stage 7
	dc.b	BGM_WIN					; Scenario Stage 8
	dc.b	BGM_WIN					; Scenario Stage 9
	dc.b	BGM_WIN					; Scenario Stage 10
	dc.b	BGM_WIN					; Scenario Stage 11
	dc.b	BGM_WIN					; Scenario Stage 12
	dc.b	BGM_FINAL_WIN				; Scenario Stage 13

	ALIGN	2

; --------------------------------------------------------------
; Load stage background art
; --------------------------------------------------------------

LoadStageBG:
	lea	ArtPuyo_StageBG,a0			; Load stage background art
	move.w	#0,d0
	
	if PuyoCompression=0
	jsr	PuyoDec
	else
	DISABLE_INTS
	jsr	NemDec
	ENABLE_INTS
	endc

	move.w	#3,d0					; Load stage background mappings
	jmp	QueuePlaneCmdList

; --------------------------------------------------------------
; Load stage background palette
; --------------------------------------------------------------

LoadStageBGPal:
	move.w	#2,d0					; Load stage background palette
	lea	Palettes,a2
	adda.l	#Pal_GreenTealPuyos-Palettes,a2
	jmp	LoadPalette

; --------------------------------------------------------------
; If Lesson Mode is active, clear the palette
; --------------------------------------------------------------

LessonModePalClear:
	cmpi.b	#3,stage				; Are we in Lesson Mode?
	bcc.w	.NotLesson				; If not, branch
	bsr.w	InitPaletteSafe				; If so, clear the palette

.NotLesson:
	rts

; --------------------------------------------------------------
; Set opponent based on the current stage
; --------------------------------------------------------------
; BYTECODE FLAG:
;	00	- Regular stage
;	01	- Final stage
; --------------------------------------------------------------

SetOpponent:
	moveq	#0,d0					; Mark as regular stage
	cmpi.b	#$F,stage				; Is this the final stage?
	bne.s	.GetOpponentID				; If not, branch
	moveq	#1,d0					; If so, mark as final stage

.GetOpponentID:
	move.b	d0,bytecode_flag			; Mark stage type

	move.b	stage,d0				; Get opponent ID
	lea	.Opponents,a1
	move.b	(a1,d0.w),opponent
	rts

; --------------------------------------------------------------

.Opponents:
	dc.b	OPP_LESSON_1				; Lesson 1 (Unused)
	dc.b	OPP_LESSON_2				; Lesson 2 (Unused)
	dc.b	OPP_LESSON_3				; Lesson 3 (Unused)

	dc.b	OPP_ARMS				; Arms
	dc.b	OPP_FRANKLY				; Frankly
	dc.b	OPP_HUMPTY				; Humpty
	dc.b	OPP_COCONUTS				; Coconuts
	dc.b	OPP_DAVY				; Davy Sprocket
	dc.b	OPP_SKWEEL				; Skweel
	dc.b	OPP_DYNAMIGHT				; Dynamight
	dc.b	OPP_GROUNDER				; Grounder
	dc.b	OPP_SPIKE				; Spike
	dc.b	OPP_SIR_FFUZZY				; Sir Ffuzzy-Logik
	dc.b	OPP_DRAGON				; Dragon Breath
	dc.b	OPP_SCRATCH				; Scratch
	dc.b	OPP_ROBOTNIK				; Dr. Robotnik

; --------------------------------------------------------------
; Initialize debug flags
; --------------------------------------------------------------

InitDebugFlags:
	move.b	#-1,use_cpu_player			; If clear, use a CPU player
	move.b	#0,control_puyo_drops			; If set, a Puyo only appears when C is pressed
	move.b	#0,skip_stages				; In Puyo Puyo, this flag skipped stages if set
	move.b	#0,unk_debug_flag			; Unused, even in Puyo Puyo
	rts

; --------------------------------------------------------------
; Check if we are in the final stage
; --------------------------------------------------------------
; BYTECODE FLAG:
;	00	- No
;	01	- Yes
; --------------------------------------------------------------

CheckFinalStage:
	moveq	#0,d0					; Mark as in regular stage
	cmpi.b	#$F,stage				; Is this the final stage?
	bne.s	.GetOpponentID				; If not, branch
	moveq	#1,d0					; If so, mark as in final stage

.GetOpponentID:
	move.b	d0,bytecode_flag			; Mark whether we are in the final stage or not
	rts
 
; --------------------------------------------------------------