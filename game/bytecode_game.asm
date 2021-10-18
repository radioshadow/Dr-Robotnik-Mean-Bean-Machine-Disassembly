; -----------------------------------------------------------------------------------------
; Game bytecode
; -----------------------------------------------------------------------------------------

Bytecode:			; Start of bytecode
					include "game/sections/region_check.asm"

BC_Checksum:		; Checksum
					include "game/sections/checksum.asm"

BC_Sega:			; Sega Intro
	BRUN	InitPaletteSafe
	BRUN	sub_F8F4
	BVDP	1
	BNEM	$2000, ArtNem_SegaLogo
	BFRMEND
	BPAL	Pal_SegaLogo, 0
	BRUN	LoadSegaLogo
	BDISABLE
	BPAL	Pal_Black, 0
	BRUN	InitActors
	BFRMEND
	BWRITE	hblank_count, 0
	BWRITE	vscroll_buffer, 0
	BFRMEND

BC_Title:
	BVDP	0
	BNEM	0, ArtNem_TitleLogo
	BNEM	$A000, ArtNem_MainFont
	BFRMEND
	BRUN	ClearPlaneA
	BRUN	ClearPlaneB
	BFRMEND
	BRUN	Title_LoadBG
	BFRMEND
	BRUN	Title_LoadFG
	BFRMEND
	BRUN	InitTitle
	BFADE	Pal_Title1, 0, 0
	BFADE	Pal_Title2, 1, 0
	BFADE	Pal_Title3, 2, 0
	BFADE	Pal_Title4, 3, 0
	BDISABLE
	BFADE	Pal_Black, 0, 0
	BFADE	Pal_Black, 1, 0
	BFADE	Pal_Black, 2, 0
	BFADE	Pal_Black, 3, 0
	BFADEW
	BRUN	InitPaletteSafe
	BRUN	InitActors
	BFRMEND
	BWRITE	hblank_count, 0
	BWRITE	vscroll_buffer, 0
	BFRMEND
	BRUN	ClearScroll
	BDELAY	6
	BJTBL
	dc.l	BC_MainMenu
	dc.l	BC_GameIntro
	BJTBLE

BC_GameIntro:
	BVDP	1
	BRUN	DisableSHMode
	
	if PuyoCompression=0
	BPUYO	$2000, ArtPuyo_StageCutscene
	else
	BNEM	$2000, ArtPuyo_StageCutscene
	endc
	
	BNEM	$4000, ArtNem_Intro
	BNEM	$1200, ArtNem_IntroBadniks
	BRUN	sub_F8F4
	BFRMEND
	BRUN	LoadLairMachineMap
	BFRMEND
	BRUN	LoadLairWallMap
	BFRMEND
	BRUN	LoadLairFloorMap
	BFRMEND
	BRUN	sub_EFFE
	BFADE	Pal_RobotnikLair, 0, 0
	BFADE	Pal_Grounder, 1, 0
	BFADE	Pal_Scratch, 2, 0
	BFADE	Pal_Robotnik, 3, 0
	BDISABLE
	BFADE	Pal_Black, 0, 0
	BFADE	Pal_Black, 1, 0
	BFADE	Pal_Black, 2, 0
	BFADE	Pal_Black, 3, 0
	BFADEW
	BRUN	InitPaletteSafe
	BRUN	InitActors
	BSFADE
	BFRMEND
	BJTBL
	dc.l	BC_Title
	dc.l	BC_Tutorial
	dc.l	BC_DemoMode
	dc.l	BC_GameIntro
	BJTBLE

BC_MainMenu:
	BVDP	0
	BSND	BGM_MENU
	BNEM	$3200, ArtNem_MainMenu
	BFRMEND
	BRUN	LoadMainMenuMap
	BFRMEND
	BRUN	LoadScenarioMenuMap
	BFRMEND
	BRUN	LoadMainMenuClouds1
	BRUN	loc_BAAA
	BFRMEND
	BRUN	LoadMainMenuClouds2
	BRUN	sub_BAC0
	BFRMEND
	BRUN	LoadMainMenuClouds3
	BFRMEND
	BRUN	LoadMainMenuClouds4
	BFRMEND
	BRUN	LoadMainMenuMountains
	BFRMEND
	BPAL	Pal_MainMenu, 0
	BPAL	Pal_StageCutsceneBG, 1
	BPAL	Pal_MainMenuShadow, 2
	BPAL	Pal_MainMenuSel, 3
	BFRMEND
	BRUN	loc_BA3C
	BDISABLE
	BJTBL
	dc.l	BC_GameStart
	dc.l	BC_GameStart
	dc.l	BC_GameStart
	dc.l	BC_GameStart
	dc.l	BC_Password
	BJTBLE

BC_Password:
	BSFADE
	BPAL	Pal_Black, 0
	BPAL	Pal_Black, 1
	BPAL	Pal_Black, 2
	BPAL	Pal_Black, 3
	BRUN	InitActors
	BPCMD	$14
	BFRMEND
	BVDP	0
	BRUN	ClearScroll
	
	if PuyoCompression=0
	BPUYO	$2000, ArtPuyo_StageSprites
	else
	BNEM	$2000, ArtPuyo_StageSprites
	endc
	
	BNEM	$8000, ArtNem_Password
	BFRMEND
	BSND	BGM_PASSWORD
	BRUN	loc_CE3A
	BFRMEND
	BRUN	loc_CF4A
	BFADE	Pal_RedYellowPuyos, 0, 0
	BFADE	Pal_BluePurplePuyos, 1, 0
	BFADE	Pal_Password3, 2, 0
	BFADE	Pal_Password4, 3, 0
	BFADEW
	BDISABLE

BC_GameStart:
	BSFADE
	BPAL	Pal_Black, 0
	BPAL	Pal_Black, 1
	BPAL	Pal_Black, 2
	BPAL	Pal_Black, 3
	BRUN	InitActors
	BFRMEND

	BJTBL
	dc.l	BC_Scenario
	dc.l	BC_VersusMode
	dc.l	BC_ExerciseMode
	dc.l	BC_Options
	dc.l	BC_Scenario
	dc.l	BC_MainMenu
	BJTBLE

BC_Options:
	BVDP	1
	BSND	BGM_MENU
	
	if PuyoCompression=0
	BPUYO	$0000, ArtPuyo_LessonMode
	BPUYO	$A000, ArtPuyo_OldFont
	else
	BNEM	$0000, ArtPuyo_LessonMode
	BNEM	$A000, ArtPuyo_OldFont
	endc
	
	BNEM	$4000, ArtNem_MainFont
	BFRMEND
	BRUN	Options_SetupPlanes
	BFRMEND
	BPAL	Pal_Options, 0
	BPAL	Pal_OptTextBlue, 1
	BPAL	Pal_OptTextRed, 2
	BPAL	Pal_OptTextGreen, 3
	BFRMEND
	BRUN	SpawnOptionsActor
	BDISABLE
	BPAL	Pal_Black, 0
	BPAL	Pal_Black, 1
	BPAL	Pal_Black, 2
	BPAL	Pal_Black, 3
	BRUN	InitActors
	BSSTOP
	BFRMEND
	BJSET	BC_SoundTest
	BJMP	BC_Title

BC_SoundTest:
	BVDP	1
	
	if PuyoCompression=0
	BPUYO	$0000, ArtPuyo_LessonMode
	BPUYO	$A000, ArtPuyo_OldFont
	else
	BNEM	$0000, ArtPuyo_LessonMode
	BNEM	$A000, ArtPuyo_OldFont
	endc
	
	BRUN	SoundTest_SetupPlanes
	BFRMEND
	BPAL	Pal_2856, 0
	BPAL	Pal_White, 1
	BPAL	Pal_Options, 2
	BPAL	Pal_OptTextGreen, 3
	BRUN	SpawnSoundTestActor
	BDISABLE
	BPAL	Pal_Black, 0
	BPAL	Pal_Black, 1
	BPAL	Pal_Black, 2
	BPAL	Pal_Black, 3
	BFRMEND
	BSSTOP
	BRUN	InitActors
	BJMP	BC_Options

BC_Scenario:
	BRUN	SetOpponent
	BJTBL
	dc.l	BC_OpponentScreen
	dc.l	BC_StageCutscene
	BJTBLE

BC_OpponentScreen:
	BVDP	0
	BPCMD	0
	BWRITE	disallow_skipping, $FFFF
	
	if PuyoCompression=0
	BPUYO	$8000, ArtPuyo_BestRecord
	else
	BNEM	$8000, ArtPuyo_BestRecord
	endc
	
	BNEM	$8000, ArtNem_OpponentScreen
	BPCMD	$1E
	BFRMEND
	BRUN	SpawnOpponentScrActors
	BFRMEND
	BRUN	DrawOpponentScrBoxes
	BFRMEND
	BWRITE	disallow_skipping, 0
	BDISABLE
	BRUN	InitActors
	BFADE	Pal_Black, 0, 0
	BFADE	Pal_Black, 1, 0
	BFADE	Pal_Black, 2, 0
	BFADE	Pal_Black, 3, 0
	BDELAY	$10
	BFADEW
	BPCMD	0
	BFRMEND
	BRUN	CheckFinalStage
	BJCLR	BC_StageCutscene
	BVDP	1
	BRUN	ClearScroll
	BDELAY	$3C
	BFRMEND
	BRUN	LoadStageBG
	BFADE	Pal_GreenTealPuyos, 2, 0
	BFADEW
	BFRMEND
	BJMP	BC_Stage

BC_StageCutscene:
	BVDP	1
	BRUN	DisableSHMode
	
	if PuyoCompression=0
	BPUYOI	$6000, ArtPuyo_StageCutscene
	else
	BNEMI	$6000, ArtPuyo_StageCutscene
	endc
	
	BWRITE	disallow_skipping, $FFFF
	BFRMEND
	BWRITE	vscroll_buffer, $FF20
	BWRITE	vscroll_buffer+2, $FF60
	BRUN	LoadOpponentIntro
	BRUN	SetupStageTransition
	BRUN	LoadStageCutscene
	BRUN	PlayStageCutsceneMusic
	BFRMEND
	BRUN	LoadStageCutsceneArt
	BFRMEND
	BRUN	sub_F5F6
	BFRMEND
	BRUN	sub_F640
	BFRMEND
	BRUN	sub_F680
	BFRMEND
	BRUN	sub_F6C0
	BFRMEND
	BRUN	loc_B0D6
	BRUN	loc_F8FC
	BFRMEND
	BFADEI	Pal_StageCutsceneFG, Pal_RobotnikLair, 0, 0
	BFADEI	Pal_StageCutsceneBG, Pal_Grounder, 1, 0
	BFADEI	Pal_GreenTealPuyos, Pal_Scratch, 2, 0
	BFADEI	Pal_Black, Pal_Robotnik, 3, 0
	BWRITE	disallow_skipping, 0
	BDISABLE
	BRUN	CheckFinalStage
	BJCLR	BC_StageTransition
	BSFADE
	BFADE	Pal_Black, 0, 0
	BFADE	Pal_Black, 1, 0
	BFADE	Pal_Black, 2, 0
	BFADE	Pal_Black, 3, 0
	BFADEW
	BRUN	InitPaletteSafe
	BRUN	InitActors
	BDELAY	$10
	BJMP	BC_OpponentScreen

BC_StageTransition:
	BFADEW
	BFRMEND
	BRUN	LoadStageBG
	BSFADE
	BRUN	LessonModePalClear
	BFRMEND
	BWRITE	Stage_transition_flag, 0
	BDISABLE

BC_Stage:
	BRUN	EnableSHMode
	BRUN	InitActors
	
	if PuyoCompression=0
	BPUYO	$2000, ArtPuyo_StageSprites
	BPUYO	$A000, ArtPuyo_StageFonts
	else
	BNEM	$2000, ArtPuyo_StageSprites
	BNEM	$A000, ArtPuyo_StageFonts
	endc
	
	BSSTOP
	BFADEW

	BPAL	Pal_RedYellowPuyos, 0
	BPAL	Pal_BluePurplePuyos, 1
	BPAL	Pal_2856, 3

	BRUN	LoadStageBGPal
	BWRITE	press_pulse_time, $802
	BRUN	GenPuyoSpawnList
	BFRMEND
	BRUN	InitStage
	BFRMEND
	BRUN	loc_6070
	BRUN	Stage_DrawSmallText
	BDISABLE
	BWRITE	press_pulse_time, $1003
	BSFADE
	BFADE	Pal_Black, 0, 0
	BFADE	Pal_Black, 1, 0
	BFADE	Pal_Black, 2, 0
	BFADE	Pal_Black, 3, 0
	BFADEW
	BRUN	InitPaletteSafe
	BRUN	InitActors
	BSSTOP
	BJSET	BC_GameOver
	BRUN	StageEnd
	BJTBL
	dc.l	BC_Scenario
	dc.l	BC_Ending
	dc.l	BC_Ending
	BJTBLE

BC_GameOver:
	BVDP	1
	BRUN	DisableSHMode
	BWRITE	vscroll_buffer, 0
	BWRITE	vscroll_buffer+2, 0
	BNEM	$4000, ArtNem_GameOver
	BFRMEND
	BNEM	$5400, ArtNem_GameOverBG
	BPCMD	$13
	BFRMEND
	BRUN	sub_F71E
	BFRMEND
	BRUN	sub_F740
	BFRMEND
	BSND	BGM_GAME_OVER
	BPCMD	$12
	BFRMEND
	BFADE	Pal_GameOverFG, 0, 0
	BFADE	Pal_GameOverBG, 1, 0
	BFADE	Pal_Robotnik, 2, 0
	BFADE	Pal_GameOverText, 3, 0
	BRUN	sub_DA90
	BDISABLE
	BFADE	Pal_Black, 0, 0
	BFADE	Pal_Black, 1, 0
	BFADE	Pal_Black, 2, 0
	BFADE	Pal_Black, 3, 0
	BFADEW
	BSSTOP
	BRUN	InitPaletteSafe
	BRUN	ClearScroll
	BRUN	InitActors
	BJCLR	BC_Scenario
	BWRITE	high_score_table_id, 0
	BJMP	BC_HighScores

BC_Ending:
	BWRITE	is_japan, $FFFF
	BRUN	SaveData
	BVDP	1
	BRUN	DisableSHMode
	BNEM	$4000, ArtNem_EndingBG
	BNEM	$8000, ArtNem_EndingSprites
	BRUN	sub_F8F4
	BFRMEND
	BRUN	loc_F840
	BFRMEND
	BRUN	loc_F886
	BFRMEND
	BRUN	loc_F8C4
	BFRMEND
	BRUN	sub_C972
	BRUN	loc_1047A
	BFADE	Pal_RobotnikLair, 0, 0, 0
	BFADE	Pal_Grounder, 1, 0, 0
	BFADE	Pal_EndingBeans, 2, 0, 0
	BFADE	Pal_Robotnik, 3, 0, 0
	BDISABLE
	BJCLR	stru_2068
	BFADE	Pal_Black, 0, 0
	BFADE	Pal_Black, 1, 0
	BFADE	Pal_Black, 2, 0
	BFADE	Pal_Black, 3, 0
	BFADEW
	BRUN	InitPaletteSafe
	BRUN	InitActors
	BSSTOP
	BFRMEND
	BJMP	BC_RoleCall

stru_2068:
	BFADE	Pal_Black, 0, 0
	BFADE	Pal_Black, 1, 0
	BFADE	Pal_Black, 2, 0
	BFADE	Pal_Black, 3, 0
	BFADEW
	BRUN	InitPaletteSafe
	BRUN	InitActors
	BRUN	sub_F8F4
	BSSTOP
	BDELAY	$40

BC_RoleCall:
	BVDP	1
	BRUN	DisableSHMode
	BWRITE	vscroll_buffer, $FF20
	BWRITE	vscroll_buffer+2, $FF60
	BSND	BGM_ROLE_CALL
	BRUN	LoadRoleCallFont
	BFRMEND
	BWRITE	use_lair_background, 0
	BRUN	LoadStageCutsceneArt
	BFRMEND
	BRUN	sub_F5F6
	BFRMEND
	BRUN	sub_F640
	BFRMEND
	BRUN	sub_F680
	BFRMEND
	BRUN	sub_F6C0
	BFRMEND
	BNEM	$5D20, ArtNem_CreditsLair
	BFRMEND
	BNEM	$1000, ArtNem_CreditsExplosion
	BFRMEND
	BRUN	loc_F958
	BRUN	loc_F9F8
	BRUN	loc_B152
	BFRMEND
	BNEM	$200, ArtNem_RoleCallTextbox
	BFRMEND
	BPAL	Pal_StageCutsceneFG, 0
	BPAL	Pal_StageCutsceneBG, 1
	BWRITE	stage, $403

stru_2132:
	BRUN	sub_10800
	BRUN	loc_1047A
	BDISABLE
	BFRMEND
	BJTBL
	dc.l	stru_2172
	dc.l	stru_2132
	dc.l	stru_2152
	BJTBLE

stru_2152:
	BPAL	Pal_Black, 0
	BPAL	Pal_Black, 1
	BPAL	Pal_Black, 2
	BPAL	Pal_Black, 3
	BRUN	InitActors
	BSSTOP
	BFRMEND
	BJMP	BC_Credits

stru_2172:
	BSFADE
	BFADE	Pal_Black, 0, 6
	BFADE	Pal_Black, 1, 6
	BFADE	Pal_Black, 2, 6
	BFADE	Pal_Black, 3, 6
	BDELAY	$70
	BFADEW
	BRUN	InitActors
	BDELAY	$1E
	BSSTOP

BC_Credits:
	BFADE	Pal_Black, 0, 0
	BFADE	Pal_Black, 1, 0
	BFADE	Pal_Black, 2, 0
	BFADE	Pal_Black, 3, 0
	BFRMEND
	BVDP	1
	BRUN	DisableSHMode
	BSND	BGM_CREDITS
	BWRITE	vscroll_buffer, $FF20
	BWRITE	vscroll_buffer+2, $FF60
	BNEM	$A000, ArtNem_MainFont
	BFRMEND
	BNEM	0, ArtNem_CreditsSky
	BFRMEND
	BWRITE	use_lair_background, 0
	BRUN	LoadStageCutsceneArt
	BFRMEND
	BRUN	sub_F5F6
	BFRMEND
	BRUN	sub_F640
	BFRMEND
	BRUN	sub_F680
	BFRMEND
	BRUN	sub_F6C0
	BFRMEND
	BNEM	$5D20, ArtNem_CreditsLair
	BFRMEND
	BNEM	$9C00, ArtNem_CreditsSmoke
	BFRMEND
	BRUN	loc_F958
	BRUN	loc_F9A4
	BRUN	loc_FAAE
	BRUN	loc_B152
	BFRMEND
	BFADE	Pal_StageCutsceneFG, 0, 0
	BFADE	Pal_StageCutsceneBG, 1, 0
	BFADE	Pal_32B6, 3, 0
	BFADEW
	BRUN	sub_C858
	BRUN	loc_1047A
	BDISABLE
	BJCLR	stru_2298
	BPAL	Pal_Black, 0
	BPAL	Pal_Black, 1
	BPAL	Pal_Black, 2
	BPAL	Pal_Black, 3
	BRUN	InitActors
	BFRMEND
	BSSTOP
	BWRITE	high_score_table_id, 0
	BJMP	BC_HighScores

stru_2298:
	BSFADE
	BFADE	Pal_Black, 0, 0
	BFADE	Pal_Black, 1, 0
	BFADE	Pal_Black, 2, 0
	BFADE	Pal_Black, 3, 0
	BDELAY	$10
	BFADEW
	BRUN	InitActors
	BSSTOP
	BWRITE	high_score_table_id, 0

BC_HighScores:
	BVDP	0
	BRUN	EnableSHMode
	BSND	BGM_MENU
	BRUN	ClearPlaneA
	BRUN	ClearPlaneB
	BFRMEND
	
	if PuyoCompression=0
	BPUYO	$0000, ArtPuyo_BestRecordModes
	BPUYO	$2000, ArtPuyo_StageSprites
	BPUYO	$6000, ArtPuyo_BestRecord
	BPUYO	$A000, ArtPuyo_StageFonts
	else
	BNEM	$0000, ArtPuyo_BestRecordModes
	BNEM	$2000, ArtPuyo_StageSprites
	BNEM	$6000, ArtPuyo_BestRecord
	BNEM	$A000, ArtPuyo_StageFonts
	endc
	
	BFRMEND
	BNEM	$5000, ArtNem_HighScores
	BFRMEND
	BRUN	sub_F75C
	BPCMD	8
	BFRMEND
	BRUN	loc_C54C
	BFADE	Pal_RedYellowPuyos, 0, 0
	BFADE	Pal_BluePurplePuyos, 1, 0
	BFADE	Pal_GreenTealPuyos, 2, 0
	BFADE	Pal_HighScoresBG, 3, 0
	BDISABLE
	BSFADE
	BFADE	Pal_Black, 0, 0
	BFADE	Pal_Black, 1, 0
	BFADE	Pal_Black, 2, 0
	BFADE	Pal_Black, 3, 0
	BDELAY	$10
	BFADEW
	BRUN	InitActors
	BSSTOP
	BJMP	BC_Sega

BC_VersusMode:
	BWRITE	stage, $303
	BWRITE	p1_win_count, 0
	BRUN	sub_9308
	BVDP	1
	
	if PuyoCompression=0
	BPUYO	$A000, ArtPuyo_StageFonts
	else
	BNEM	$A000, ArtPuyo_StageFonts
	endc
	
	BRUN	LoadStageBG
	BNEM	$1DE0, ArtNem_GroupedStars
	BFRMEND
	BSND	BGM_VERSUS
	BPAL	Pal_RedYellowPuyos, 0
	BPAL	Pal_BluePurplePuyos, 1
	BPAL	Pal_GreenTealPuyos, 2
	BWRITE	press_pulse_time, $802

BC_VersusModeLoop:
	BPAL	Pal_RedYellowPuyos, 0
	BPAL	Pal_3096, 3
	
	if PuyoCompression=0
	BPUYO	$2000, ArtPuyo_StageSprites
	else
	BNEM	$2000, ArtPuyo_StageSprites
	endc
	
	BRUN	sub_93B4
	BRUN	GenPuyoSpawnList
	BRUN	InitStage
	BNEM	$9000, ArtNem_DifficultyFaces
	BNEM	$8800, ArtNem_DifficultyFaces2
	BDISABLE
	BJSET	BC_VersusModeEnd
	BRUN	InitActors
	BPCMD	4
	BFRMEND
	BJMP	BC_VersusModeLoop

BC_VersusModeEnd:
	BWRITE	press_pulse_time, $1003
	BSFADE
	BFADE	Pal_Black, 0, 0
	BFADE	Pal_Black, 1, 0
	BFADE	Pal_Black, 2, 0
	BFADE	Pal_Black, 3, 0
	BFADEW
	BRUN	InitActors
	BSSTOP
	BWRITE	high_score_table_id, $FF
	BJMP	BC_HighScores

BC_ExerciseMode:
	BWRITE	stage, $303
	BVDP	1
	
	if PuyoCompression=0
	BPUYO	$0000, ArtPuyo_StageBG
	BPUYO	$2000, ArtPuyo_StageSprites
	BPUYO	$A000, ArtPuyo_StageFonts
	else
	BNEM	$0000, ArtPuyo_StageBG
	BNEM	$2000, ArtPuyo_StageSprites
	BNEM	$A000, ArtPuyo_StageFonts
	endc
	
	BPCMD	$16
	BNEM	$9000, ArtNem_DifficultyFaces
	BFRMEND
	BSND	BGM_EXERCISE
	BFADE	Pal_RedYellowPuyos, 0, 0
	BFADE	Pal_BluePurplePuyos, 1, 0
	BFADE	Pal_GreenTealPuyos, 2, 0
	BFADE	Pal_3096, 3, 0
	BWRITE	press_pulse_time, $802
	BRUN	InitStage
	BDISABLE
	BWRITE	press_pulse_time, $1003
	BSFADE
	BFADE	Pal_Black, 0, 0
	BFADE	Pal_Black, 1, 0
	BFADE	Pal_Black, 2, 0
	BFADE	Pal_Black, 3, 0
	BDELAY	$10
	BFADEW
	BRUN	InitActors
	BSSTOP
	BWRITE	high_score_table_id, $100
	BJMP	BC_HighScores

BC_DemoMode:
	BWRITE	Stage_mode, $400
	BVDP	1
	
	if PuyoCompression=0
	BPUYO	0, ArtPuyo_StageBG
	else
	BNEM	0, ArtPuyo_StageBG
	endc
	
	BPCMD	3
	BFRMEND
	
	if PuyoCompression=0
	BPUYO	$2000, ArtPuyo_StageSprites
	BPUYO	$A000, ArtPuyo_StageFonts
	else
	BNEM	$2000, ArtPuyo_StageSprites
	BNEM	$A000, ArtPuyo_StageFonts
	endc
	
	BPAL	Pal_RedYellowPuyos, 0
	BPAL	Pal_BluePurplePuyos, 1
	BPAL	Pal_GreenTealPuyos, 2
	BPAL	Pal_2856, 3
	BRUN	sub_DDD8
	BRUN	GenPuyoSpawnList
	BRUN	InitStage
	BFRMEND
	BRUN	loc_6070
	BFRMEND
	BRUN	Stage_DrawSmallText
	BRUN	LoadTimerCtrlSkip
	BDISABLE
	BRUN	InitActors
	BPAL	Pal_Black, 0
	BPAL	Pal_Black, 1
	BPAL	Pal_Black, 2
	BPAL	Pal_Black, 3
	BSSTOP
	BFRMEND
	BJSET	BC_Title
	BJMP	stru_25F8

BC_Tutorial:
	BWRITE	Stage_mode, $400
	BWRITE	stage, $303
	BVDP	1
	
	if PuyoCompression=0
	BPUYO	$2000, ArtPuyo_StageSprites
	BPUYO	$0000, ArtPuyo_StageBG
	BPUYO	$6600, ArtPuyo_Tutorial
	else
	BNEM	$2000, ArtPuyo_StageSprites
	BNEM	$0000, ArtPuyo_StageBG
	BNEM	$6600, ArtPuyo_Tutorial
	endc
	
	BNEM	$6600, ArtNem_MainFont
	
	if PuyoCompression=0
	BPUYO	$A000, ArtPuyo_StageFonts
	else
	BNEM	$A000, ArtPuyo_StageFonts
	endc
	
	BPCMD	3
	BPCMD	$2A
	BFRMEND
	BRUN	sub_DDD8
	BRUN	loc_13330
	BRUN	loc_1339C
	BFRMEND
	BPAL	Pal_RedYellowPuyos, 0
	BPAL	Pal_BluePurplePuyos, 1
	BPAL	Pal_GreenTealPuyos, 2
	BPAL	Pal_TutorialJoystick, 3
	BRUN	LoadCtrlWait
	BDISABLE
	BPAL	Pal_Black, 0
	BPAL	Pal_Black, 1
	BPAL	Pal_Black, 2
	BPAL	Pal_Black, 3
	BFRMEND
	BRUN	InitActors
	BSSTOP
	BJSET	BC_Title
	BJMP	stru_25F8

stru_25F8:
	BVDP	0
	BRUN	EnableSHMode
	
	if PuyoCompression=0
	BPUYO	$0000, ArtPuyo_BestRecordModes
	BPUYO	$2000, ArtPuyo_StageSprites
	BPUYO	$6000, ArtPuyo_BestRecord
	BPUYO	$A000, ArtPuyo_StageFonts
	else
	BNEM	$0000, ArtPuyo_BestRecordModes
	BNEM	$2000, ArtPuyo_StageSprites
	BNEM	$6000, ArtPuyo_BestRecord
	BNEM	$A000, ArtPuyo_StageFonts
	endc
	
	BPCMD	8
	BNEM	$5000, ArtNem_HighScores
	BFRMEND
	BRUN	sub_F75C
	BFRMEND
	BRUN	LoadCtrlWait
	BWRITE	high_score_table_id, $FF
	BRUN	sub_DDD8
	BRUN	loc_C54C
	BPAL	Pal_RedYellowPuyos, 0
	BPAL	Pal_BluePurplePuyos, 1
	BPAL	Pal_GreenTealPuyos, 2
	BPAL	Pal_HighScoresBG, 3
	BDISABLE
	BRUN	InitActors
	BSFADE
	BPAL	Pal_Black, 0
	BPAL	Pal_Black, 1
	BPAL	Pal_Black, 2
	BPAL	Pal_Black, 3
	BFRMEND
	BRUN	InitActors
	BSSTOP
	BJSET	BC_Title
	BJMP	BC_Sega

; --------------------------------------------------------------