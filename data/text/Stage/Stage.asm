									
	dc.l BattleVsExercise
	dc.l BattleTutorial
	dc.l ModeSelect
	dc.l SelectLevel1P
	dc.l SelectLevel2P
	dc.l NoBonus
	dc.l BattleScenario
	dc.l InsertCoins1
	dc.l Continue
	dc.l PressStartExercise
	dc.l InsertCoins2
	dc.l PressStart1P
	dc.l YouWin
	dc.l GamesWon
	dc.l 0
	dc.l ExerciseLevel
	dc.l PressStart2P
	dc.l StartContinue
	dc.l PressStart1P2P
	dc.l PressStart1P2P
	dc.l PressStart1P2P
	dc.l PressStart1P2P
	dc.l AllClear
	dc.l PressStart1P2P
	even
	
PressStart2P:
	dc.w		  	 0				; # of Text
	
									; Large/Small Text
									; Postion in Plane A
									; Palette
									; Text
	STAGE_TEXT_LOC 	 0, $C514, $E500, "PRESS 2P START BUTTON"

NoBonus:	
	dc.w		0					; # of Text
	
	dc.w		0
	dc.b		7 					; Y Position
	dc.b		2 					; X Position
	dc.w		$A500 				; Palette
	STAGE_TEXT	0, " NO BONUS "		; Text

AllClear:
	dc.w		0					; # of Text
	
	dc.w		0
	dc.b		8 					; Y Position
	dc.b		130 				; X Position
	dc.w		$8500 				; Palette
	STAGE_TEXT	0, "ALL CLEAR "		; Text

YouWin:
	dc.w		0					; # of Text
	
	dc.w		0
	dc.b		2 					; Y Position
	dc.b		4	 				; X Position
	dc.w		$C500 				; Palette
	STAGE_TEXT	0, "YOU  WIN"		; Text

GamesWon:	
	dc.w		  	 0
	
	STAGE_TEXT_LOC 	 0, $C11E, $C500, "GAMES  WON"

PressStart1P:
	dc.w		  	 0
	
	STAGE_TEXT_LOC 	 0, $C514, $E500, "PRESS 1P START BUTTON"

InsertCoins2:	
	dc.w		1					; # of Text
	
	dc.w		0
	dc.b		5 					; Y Position
	dc.b		0	 				; X Position
	dc.w		$8500 				; Palette
	STAGE_TEXT	1, "            "	; Text
	
	dc.w		0
	dc.b		6 					; Y Position
	dc.b		0	 				; X Position
	dc.w		$8500 				; Palette
	STAGE_TEXT	1, "            "	; Text
	
InsertCoins1:
	dc.w		0					; # of Text
	
	dc.w		0
	dc.b		5 					; Y Position
	dc.b		0	 				; X Position
	dc.w		$8500 				; Palette
	STAGE_TEXT	1, "INSERT COINS"	; Text
	
Continue:
	dc.w		0					; # of Text
	
	dc.w		0
	dc.b		5 					; Y Position
	dc.b		4	 				; X Position
	dc.w		$8500 				; Palette
	STAGE_TEXT	1, "CONTINUE?"		; Text

PressStartExercise:
	dc.w		1					; # of Text
	
	dc.w		0
	dc.b		7 					; Y Position
	dc.b		132	 				; X Position
	dc.w		$8500 				; Palette
	STAGE_TEXT	1, "PRESS %cP"		; Text | %c = Player #
	
	dc.w		0
	dc.b		8 					; Y Position
	dc.b		128	 				; X Position
	dc.w		$8500 				; Palette
	STAGE_TEXT	1, "START BUTTON"	; Text

ExerciseLevel:
	dc.w		  	 0
	
	STAGE_TEXT_LOC 	 0, $C626, $C500, "LV"

BattleVsExercise:	
	dc.w			 3
	
	STAGE_TEXT_LOC 	 0, $C124, $C500, "NEXT"
	
	STAGE_TEXT_LOC 	 1, $C220, $8500, "1P"
	
	STAGE_TEXT_LOC 	 1, $C22C, $A500, "2P"
	
	STAGE_TEXT_LOC 	 0, $CA20, $C500, "SCORE"
	
BattleScenario:
	dc.w			 1
	
	STAGE_TEXT_LOC 	 0, $C124, $C500, "NEXT"
	
	STAGE_TEXT_LOC 	 0, $CA20, $C500, "SCORE"

BattleTutorial:
	dc.w			 0

	STAGE_TEXT_LOC 	 0, $CA40, $C500, "SCORE"

ModeSelect:	
	dc.w			 2
	
	STAGE_TEXT_LOC 	 0, $E91E, $C500, "SELECT MODE"
	
	STAGE_TEXT_LOC 	 0, $EC1E, $A500, "VS COMPUTER"
	
	STAGE_TEXT_LOC 	 0, $EE1E, $A500, "1P VS 2P"
	
	STAGE_TEXT_LOC 	 0, $F01E, $A500, "1P"
	
	STAGE_TEXT_LOC 	 0, $F222, $A500, "MISSION"
		
	STAGE_TEXT_LOC 	 0, $F41E, $A500, "SOUND TRACK"
	
SelectLevel1P:
	dc.w			 0

	STAGE_TEXT_LOC 	 0, $C184, $8500, "SELECT LEVEL"
	
SelectLevel2P:
	dc.w			 0

	STAGE_TEXT_LOC 	 0, $C1B4, $A500, "SELECT LEVEL"

StartContinue:
	dc.w			 1
	
	STAGE_TEXT_LOC 	 0, $C86E, $A500, "START"
	
	STAGE_TEXT_LOC 	 0, $CC6E, $C500, "CONTINUE"

PressStart1P2P:	
	dc.w		1					; # of Text
	
	dc.w		0
	dc.b		5 					; Y Position
	dc.b		4	 				; X Position
	dc.w		$8500 				; Palette
	STAGE_TEXT	1, "PRESS %cP"		; Text | %c = Player #
	
	dc.w		0
	dc.b		6 					; Y Position
	dc.b		0	 				; X Position
	dc.w		$8500 				; Palette
	STAGE_TEXT	1, "START BUTTON"	; Text				