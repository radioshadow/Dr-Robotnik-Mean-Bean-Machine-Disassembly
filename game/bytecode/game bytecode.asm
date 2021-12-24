; --------------------------------------------------------------
; Game bytecode
; --------------------------------------------------------------

	if SplashScreen=1
	BRUN	SHC ; Run Sonic Hacking Contest splash screen
	endc

	include "game/bytecode/sections/region check.asm"
			
BC_Checksum:
	include "game/bytecode/sections/checksum.asm"
	
BC_Sega:
	include "game/bytecode/sections/sega logo.asm"

BC_Title:
	include "game/bytecode/sections/title.asm"

BC_GameIntro:
	BVDP	1
	BRUN	DisableSHMode
	
	if PuyoCompression=0
	BPUYO	$2000,	ArtPuyo_LevelIntro
	else
	BNEM	$2000,	ArtPuyo_LevelIntro
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
	BFADE	Pal_GameIntroGrounder, 1, 0
	BFADE	Pal_GameIntroScratch, 2, 0
	BFADE	Pal_GameIntroRobotnik, 3, 0
	BDISABLE
	BFADE	Pal_Black, 0, 0
	BFADE	Pal_Black, 1, 0
	BFADE	Pal_Black, 2, 0
	BFADE	Pal_Black, 3, 0
	BFADEW
	BRUN	InitPalette_Safe
	BRUN	InitActors
	BSFADE
	BFRMEND
	BJTBL
	dc.l BC_Title
	dc.l BC_Tutorial
	dc.l BC_Demo
	dc.l BC_GameIntro
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
	BPAL	Pal_LevelIntroBG, 1
	BPAL	Pal_MainMenuShadow, 2
	BPAL	Pal_MainMenuSel, 3
	BFRMEND
	BRUN	loc_BA3C
	BDISABLE
	BJTBL
	dc.l BC_GameStart
	dc.l BC_GameStart
	dc.l BC_GameStart
	dc.l BC_GameStart
	dc.l BC_Password
	BJTBLE

BC_Password:
	include "game/bytecode/sections/password.asm"
	
BC_GameStart:
	BSFADE
	BPAL	Pal_Black, 0
	BPAL	Pal_Black, 1
	BPAL	Pal_Black, 2
	BPAL	Pal_Black, 3
	BRUN	InitActors
	BFRMEND

	BJTBL
	dc.l BC_Scenario
	dc.l BC_VersusMode
	dc.l BC_ExerciseMode
	dc.l BC_Options
	dc.l BC_Scenario
	dc.l BC_MainMenu
	BJTBLE

BC_Options:
	BVDP	1
	BSND	BGM_MENU
	
	if PuyoCompression=0
	BPUYO	$0000,  ArtPuyo_LessonMode
	BPUYO	$A000,	ArtPuyo_OldFont
	else
	BNEM	$0000,  ArtPuyo_LessonMode
	BNEM	$A000,	ArtPuyo_OldFont
	endc
	
	BNEM	$4000,  ArtNem_MainFont
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
	BPUYO	$0000,  ArtPuyo_LessonMode
	BPUYO	$A000,	ArtPuyo_OldFont
	else
	BNEM	$0000,  ArtPuyo_LessonMode
	BNEM	$A000,	ArtPuyo_OldFont
	endc	
	
	BRUN	SoundTest_SetupPlanes
	BFRMEND
	BPAL	Pal_Characters_Puyo, 0
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
	dc.l BC_OpponentScreen
	dc.l BC_LevelIntro
	BJTBLE

BC_OpponentScreen:
	BVDP	0
	BPCMD	0
	BWRITE	word_FF1122, $FFFF
	
	if PuyoCompression=0
	BPUYO	$8000,	ArtPuyo_BestRecord
	else
	BNEM	$8000,	ArtPuyo_BestRecord
	endc
	
	BNEM	$8000, ArtNem_OpponentScreen
	BPCMD	$1E
	BFRMEND
	BRUN	SpawnOpponentScrActors
	BFRMEND
	BRUN	DrawOpponentScrBoxes
	BFRMEND
	BWRITE	word_FF1122, 0
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
	BRUN	CheckFinalLevel
	BJCLR	BC_LevelIntro
	BVDP	1
	BRUN	ClearScroll
	BDELAY	$3C
	BFRMEND
	
	if BattleBoards=0
	BRUN	LoadLevelBGArt
	else
	BRUN	LoadScenarioBGArt
	endc
	
	BFADE	Pal_GreenTealPuyos, 2, 0
	BFADEW
	BFRMEND
	BJMP	BC_Level

BC_LevelIntro:
	BVDP	1
	BRUN	DisableSHMode
	
	if PuyoCompression=0
	BPUYOI	$6000, ArtPuyo_LevelIntro
	else
	BNEMI	$6000, ArtPuyo_LevelIntro
	endc
	
	BWRITE	word_FF1122, $FFFF
	BFRMEND
	BWRITE	vscroll_buffer,	$FF20
	BWRITE	vscroll_buffer+2, $FF60
	BRUN	LoadOpponentIntro
	BRUN	SetupLevelTransition
	BRUN	LoadLevelIntro
	BRUN	PlayLevelIntroMusic
	BFRMEND
	BRUN	LoadLevelIntroArt
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
	BFADEI	Pal_LevelIntroFG, Pal_RobotnikLair, 0, 0
	BFADEI	Pal_LevelIntroBG, Pal_GameIntroGrounder, 1, 0
	BFADEI	Pal_GreenTealPuyos, Pal_GameIntroScratch, 2, 0
	BFADEI	Pal_Black, Pal_GameIntroRobotnik, 3, 0
	BWRITE	word_FF1122, 0
	BDISABLE
	BRUN	CheckFinalLevel
	BJCLR	BC_LevelTransition
	BSFADE
	BFADE	Pal_Black, 0, 0
	BFADE	Pal_Black, 1, 0
	BFADE	Pal_Black, 2, 0
	BFADE	Pal_Black, 3, 0
	BFADEW
	BRUN	InitPalette_Safe
	BRUN	InitActors
	BDELAY	$10
	BJMP	BC_OpponentScreen

BC_LevelTransition:
	BFADEW
	BFRMEND
	
	if BattleBoards=0
	BRUN	LoadLevelBGArt
	else
	BRUN	LoadScenarioBGArt
	BRUN	LoadScenarioBGPal
	endc
	
	BSFADE
	BRUN	CheckTutorialPalInit
	BFRMEND
	BWRITE	level_transition_flag, 0
	BDISABLE

BC_Level:
	BRUN	EnableSHMode
	BRUN	InitActors
	
	if PuyoCompression=0
	BPUYO	$2000,	ArtPuyo_LevelSprites
	BPUYO	$A000,	ArtPuyo_LevelFonts
	else
	BNEM	$2000,	ArtPuyo_LevelSprites
	BNEM	$A000,	ArtPuyo_LevelFonts
	endc
	
	BSSTOP
	BFADEW

	BPAL	Pal_RedYellowPuyos, 0
	BPAL	Pal_BluePurplePuyos, 1
	BPAL	Pal_Characters_Puyo, 3
	
	if BattleBoards=0
	BRUN	LoadLevelBGPal
	else
	BRUN	LoadScenarioBGPal
	endc
	
	BWRITE	pressed_time, $802
	BRUN	GenPuyoOrder
	BFRMEND
	BRUN	loc_3C00
	BFRMEND
	BRUN	loc_6070
	BRUN	Level_DrawSmallText
	BDISABLE
	BWRITE	pressed_time, $1003
	BSFADE
	BFADE	Pal_Black, 0, 0
	BFADE	Pal_Black, 1, 0
	BFADE	Pal_Black, 2, 0
	BFADE	Pal_Black, 3, 0
	BFADEW
	BRUN	InitPalette_Safe
	BRUN	InitActors
	BSSTOP
	BJSET	BC_GameOver
	BRUN	LevelEnd
	BJTBL
	dc.l BC_Scenario
	dc.l BC_Ending
	dc.l BC_Ending
	BJTBLE

BC_GameOver:
	BVDP	1
	BRUN	DisableSHMode
	BWRITE	vscroll_buffer,	0
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
	BFADE	Pal_GameIntroRobotnik, 2, 0
	BFADE	Pal_GameOverText, 3, 0
	BRUN	sub_DA90
	BDISABLE
	BFADE	Pal_Black, 0, 0
	BFADE	Pal_Black, 1, 0
	BFADE	Pal_Black, 2, 0
	BFADE	Pal_Black, 3, 0
	BFADEW
	BSSTOP
	BRUN	InitPalette_Safe
	BRUN	ClearScroll
	BRUN	InitActors
	BJCLR	BC_Scenario
	BWRITE	high_score_table_id, 0
	BJMP	BC_HighScores_1

BC_Ending:
	BWRITE	sound_test_enabled, $FFFF
	BRUN	sub_23536
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
	BFADE	Pal_GameIntroGrounder, 1, 0, 0
	BFADE	Pal_EndingBeans, 2, 0, 0
	BFADE	Pal_GameIntroRobotnik, 3, 0, 0
	BDISABLE
	BJCLR	stru_2068
	BFADE	Pal_Black, 0, 0
	BFADE	Pal_Black, 1, 0
	BFADE	Pal_Black, 2, 0
	BFADE	Pal_Black, 3, 0
	BFADEW
	BRUN	InitPalette_Safe
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
	BRUN	InitPalette_Safe
	BRUN	InitActors
	BRUN	sub_F8F4
	BSSTOP
	BDELAY	$40

BC_RoleCall:
	BVDP	1
	BRUN	DisableSHMode
	BWRITE	vscroll_buffer,	$FF20
	BWRITE	vscroll_buffer+2, $FF60
	BSND	BGM_ROLE_CALL
	BRUN	sub_10E5C
	BFRMEND
	BWRITE	use_lair_background, 0
	BRUN	LoadLevelIntroArt
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
	BPAL	Pal_LevelIntroFG, 0
	BPAL	Pal_LevelIntroBG, 1
	BWRITE	level, $403

stru_2132:
	BRUN	sub_10800
	BRUN	loc_1047A
	BDISABLE
	BFRMEND
	BJTBL
	dc.l stru_2172
	dc.l stru_2132
	dc.l stru_2152
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
	BWRITE	vscroll_buffer,	$FF20
	BWRITE	vscroll_buffer+2, $FF60
	BNEM	$A000, ArtNem_MainFont
	BFRMEND
	BNEM	0, ArtNem_CreditsSky
	BFRMEND
	BWRITE	use_lair_background, 0
	BRUN	LoadLevelIntroArt
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
	BFADE	Pal_LevelIntroFG, 0, 0
	BFADE	Pal_LevelIntroBG, 1, 0
	BFADE	Pal_Credits, 3, 0
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
	BJMP	BC_HighScores_1

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

BC_HighScores_1:
	BVDP	0
	BRUN	EnableSHMode
	BSND	BGM_MENU
	BRUN	ClearPlaneA
	BRUN	ClearPlaneB
	BFRMEND
	
	if PuyoCompression=0
	BPUYO	$0000,  ArtPuyo_BestRecordModes
	BPUYO	$2000,	ArtPuyo_LevelSprites
	BPUYO	$6000,	ArtPuyo_BestRecord
	BPUYO	$A000,	ArtPuyo_LevelFonts
	else
	BNEM	$0000,  ArtPuyo_BestRecordModes
	BNEM	$2000,	ArtPuyo_LevelSprites
	BNEM	$6000,	ArtPuyo_BestRecord
	BNEM	$A000,	ArtPuyo_LevelFonts
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
	BWRITE	level, $303
	BWRITE	byte_FF0128, 0
	BRUN	sub_9308
	BVDP	1
	
	if PuyoCompression=0
	BPUYO	$A000,	ArtPuyo_LevelFonts
	else
	BNEM	$A000,	ArtPuyo_LevelFonts
	endc
	
	BRUN	LoadLevelBGArt
	BNEM	$1DE0, ArtNem_GroupedStars
	BFRMEND
	BSND	BGM_VERSUS
	BPAL	Pal_RedYellowPuyos, 0
	BPAL	Pal_BluePurplePuyos, 1
	BPAL	Pal_GreenTealPuyos, 2
	BWRITE	pressed_time, $802

BC_VersusModeLoop:
	BPAL	Pal_RedYellowPuyos, 0
	BPAL	Pal_DifficultyFaces, 3
	
	if PuyoCompression=0
	BPUYO	$2000,	ArtPuyo_LevelSprites
	else
	BNEM	$2000,	ArtPuyo_LevelSprites
	endc
	
	BRUN	sub_93B4
	BRUN	GenPuyoOrder
	BRUN	loc_3C00
	BNEM	$9000, ArtNem_DifficultyFaces
	BNEM	$8800, ArtNem_DifficultyFaces2
	BDISABLE
	BJSET	stru_2400
	BRUN	InitActors
	BPCMD	4
	BFRMEND
	BJMP	BC_VersusModeLoop

stru_2400:
	BWRITE	pressed_time, $1003
	BSFADE
	BFADE	Pal_Black, 0, 0
	BFADE	Pal_Black, 1, 0
	BFADE	Pal_Black, 2, 0
	BFADE	Pal_Black, 3, 0
	BFADEW
	BRUN	InitActors
	BSSTOP
	BWRITE	high_score_table_id, $FF
	BJMP	BC_HighScores_1

BC_ExerciseMode:
	BWRITE	level, $303
	BVDP	1
	
	if PuyoCompression=0
	BPUYO	$0000,  ArtPuyo_LevelBG
	BPUYO	$2000,	ArtPuyo_LevelSprites
	BPUYO	$A000,	ArtPuyo_LevelFonts
	else
	BNEM	$0000,  ArtPuyo_LevelBG
	BNEM	$2000,	ArtPuyo_LevelSprites
	BNEM	$A000,	ArtPuyo_LevelFonts
	endc
	
	BPCMD	$16
	BNEM	$9000, ArtNem_DifficultyFaces
	BFRMEND
	BSND	BGM_EXERCISE
	BFADE	Pal_RedYellowPuyos, 0, 0
	BFADE	Pal_BluePurplePuyos, 1, 0
	BFADE	Pal_GreenTealPuyos, 2, 0
	BFADE	Pal_DifficultyFaces, 3, 0
	BWRITE	pressed_time, $802
	BRUN	loc_3C00
	BDISABLE
	BWRITE	pressed_time, $1003
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
	BJMP	BC_HighScores_1

BC_Demo:
	BWRITE	level_mode, $400

	if DemoOpponenet=1
	BRUN	SetDemoOpponenet
	endc
	
	if DemoOpponenet=2 
	BRUN	SetDemoOpponenet
	endc
	
	BVDP	1
	
	if BattleBoards=0
	
	if PuyoCompression=0
	BPUYO	$0000,  ArtPuyo_LevelBG
	else
	BNEM	$0000,  ArtPuyo_LevelBG
	endc
	
	BPCMD	3
	else

	BRUN	LoadScenarioBGArt
	endc	
	
	BFRMEND
	
	if PuyoCompression=0
	BPUYO	$2000,	ArtPuyo_LevelSprites
	BPUYO	$A000,	ArtPuyo_LevelFonts
	else
	BNEM	$2000,	ArtPuyo_LevelSprites
	BNEM	$A000,	ArtPuyo_LevelFonts
	endc
	
	BPAL	Pal_RedYellowPuyos, 0
	BPAL	Pal_BluePurplePuyos, 1
	
	if BattleBoards=0
	BPAL	Pal_GreenTealPuyos, 2
	else 
	BRUN	LoadDemoBGPal
	endc
	
	BPAL	Pal_Characters_Puyo, 3
	BRUN	sub_DDD8
	BRUN	GenPuyoOrder
	BRUN	loc_3C00
	BFRMEND
	BRUN	loc_6070
	BFRMEND
	BRUN	Level_DrawSmallText
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
	BJMP	BC_HighScores_2

BC_Tutorial:
	BWRITE	level_mode, $400
	BWRITE	level, $303
	BVDP	1
	
	if PuyoCompression=0
	BPUYO	$2000,	ArtPuyo_LevelSprites
	BPUYO	$0000,  ArtPuyo_LevelBG
	BPUYO	$6600,	ArtPuyo_DemoMode
	else
	BNEM	$2000,	ArtPuyo_LevelSprites
	BNEM	$0000,  ArtPuyo_LevelBG
	BNEM	$6600,	ArtPuyo_DemoMode
	endc
	
	BNEM	$6600,  ArtNem_MainFont
	
	if PuyoCompression=0
	BPUYO	$A000,	ArtPuyo_LevelFonts
	else
	BNEM	$A000,	ArtPuyo_LevelFonts
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
	BJMP	BC_HighScores_2

BC_HighScores_2:
	BVDP	0
	BRUN	EnableSHMode
	
	if PuyoCompression=0
	BPUYO	$0000,  ArtPuyo_BestRecordModes
	BPUYO	$2000,	ArtPuyo_LevelSprites
	BPUYO	$6000,	ArtPuyo_BestRecord
	BPUYO	$A000,	ArtPuyo_LevelFonts
	else
	BNEM	$0000,  ArtPuyo_BestRecordModes
	BNEM	$2000,	ArtPuyo_LevelSprites
	BNEM	$6000,	ArtPuyo_BestRecord
	BNEM	$A000,	ArtPuyo_LevelFonts
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