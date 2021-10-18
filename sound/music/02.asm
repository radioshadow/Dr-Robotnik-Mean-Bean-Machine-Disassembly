Song02_Start:
	cType		ctMusic
	cFadeOut	$0000
	cTempo		$C1
	cChannel	Song02_FM1
	cChannel	Song02_FM2
	cChannel	Song02_FM3
	cChannel	Song02_FM4
	cChannel	Song02_FM5
	cChannel	Song02_DAC
	cChannel	Song02_PSG1
	cChannel	Song02_PSG2
	cChannel	Song02_PSG3
	cChannel	Song02_Noise

Song02_FM1:
	cLoopStart
		cInsFM		patch0E
		cVolFM		$0C
		cRelease	$05
		cVibrato	$02, $0A
		cPan		cpCenter
		cNoteShift	$00, $00, $00
		cLoopCnt	$01
			cVolFM		$0C
			cNote		cnF2, $2A
			cNote		cnDs2, $1C
			cNote		cnC2, $0E
			cNote		cnAs1
			cNote		cnC2
			cVolFM		$00
			cNote		cnRst, $70
		cLoopCntEnd
		cLoopCnt	$07
			cVolFM		$0C
			cNote		cnF2, $2A
			cNote		cnDs2, $1C
			cNote		cnC2, $0E
			cNote		cnAs1
			cNote		cnC2
		cLoopCntEnd
		cLoopCnt	$03
			cVolFM		$0C
			cNote		cnG1, $07
			cNote		cnG1
			cNote		cnG1
			cNote		cnG1
			cNote		cnG1
			cNote		cnRst
			cNote		cnG1
			cNote		cnG1
			cNote		cnG1
			cNote		cnG1
			cNote		cnG1
			cNote		cnRst
			cNote		cnAs1, $0E
			cNote		cnB1
			cVolFM		$00
			cNote		cnRst, $70
		cLoopCntEnd
		cLoopCnt	$07
			cVolFM		$0C
			cNote		cnF2, $2A
			cNote		cnDs2, $1C
			cNote		cnC2, $0E
			cNote		cnAs1
			cNote		cnC2
		cLoopCntEnd
		cLoopCnt	$01
			cVolFM		$00
			cNote		cnRst, $70
			cNote		cnRst
			cVolFM		$0C
			cNote		cnG1, $07
			cNote		cnG1
			cNote		cnG1
			cNote		cnG1
			cNote		cnG1
			cNote		cnRst
			cNote		cnG1
			cNote		cnG1
			cNote		cnG1
			cNote		cnG1
			cNote		cnG1
			cNote		cnRst
			cNote		cnAs1, $0E
			cNote		cnB1
			cVolFM		$00
			cNote		cnRst, $70
		cLoopCntEnd
	cLoopEnd
	cStop

Song02_FM2:
	cLoopStart
		cRelease	$01
		cVibrato	$02, $0A
		cPan		cpCenter
		cNoteShift	$00, $00, $00
		cVolFM		$00
		cNote		cnRst, $70
		cNote		cnRst
		cNote		cnRst
		cNote		cnRst
		cInsFM		patch72
		cVolFM		$0C
		cNote		cnRst, $0E
		cRelease	$02
		cNote		cnF3
		cNote		cnGs3
		cNote		cnC4
		cNote		cnAs3
		cNote		cnGs3
		cNote		cnF3
		cNote		cnGs3
		cNote		cnRst
		cNote		cnGs3
		cNote		cnAs3
		cNote		cnF3
		cNote		cnGs3
		cNote		cnGs3
		cNote		cnAs3
		cNote		cnRst
		cNote		cnRst
		cNote		cnF3
		cNote		cnGs3
		cNote		cnC4
		cNote		cnAs3
		cNote		cnGs3
		cNote		cnF3
		cNote		cnGs3
		cNote		cnRst
		cNote		cnGs3
		cNote		cnF3
		cNote		cnAs3
		cNote		cnRst
		cNote		cnGs3
		cNote		cnRst, $1C
		cNote		cnRst, $0E
		cNote		cnF3
		cNote		cnGs3
		cNote		cnC4
		cNote		cnAs3
		cNote		cnGs3
		cNote		cnF3
		cNote		cnGs3
		cNote		cnRst
		cNote		cnGs3
		cNote		cnAs3
		cNote		cnRst, $07
		cNote		cnF3
		cNote		cnGs3
		cNote		cnRst
		cNote		cnGs3, $0E
		cNote		cnAs3
		cNote		cnRst
		cNote		cnRst
		cNote		cnF3
		cNote		cnGs3
		cNote		cnC4
		cNote		cnAs3
		cNote		cnGs3
		cNote		cnF3
		cNote		cnGs3
		cNote		cnRst
		cNote		cnGs3
		cNote		cnAs3
		cNote		cnGs3
		cNote		cnRst
		cNote		cnF3
		cVolFM		$00
		cNote		cnRst, $1C
		cNote		cnRst, $70
		cInsFM		patch09
		cVolFM		$0C
		cRelease	$01
		cVibrato	$02, $0A
		cSustain
		cNote		cnF3, $3C
		cRelease	$01
		cVibrato	$05, $0D
		cNote		cnF3, $30
		cNote		cnRst, $04
		cSustain
		cVibrato	$02, $0A
		cNote		cnG3, $3C
		cRelease	$01
		cVibrato	$05, $0D
		cNote		cnG3, $30
		cNote		cnRst, $04
		cSustain
		cVibrato	$02, $0A
		cNote		cnB3, $3C
		cVibrato	$05, $0D
		cRelease	$01
		cNote		cnB3, $30
		cNote		cnRst, $04
		cVibrato	$02, $0A
		cSustain
		cNote		cnC4, $3C
		cRelease	$01
		cVibrato	$05, $0D
		cNote		cnC4, $30
		cNote		cnRst, $04
		cVibrato	$02, $0A
		cSustain
		cNote		cnD4, $3C
		cRelease	$01
		cVibrato	$05, $0D
		cNote		cnD4, $30
		cNote		cnRst, $04
		cSustain
		cVibrato	$02, $0A
		cNote		cnF4, $3C
		cRelease	$01
		cVibrato	$05, $0D
		cNote		cnF4, $30
		cNote		cnRst, $04
		cSustain
		cVibrato	$02, $0A
		cNote		cnFs4, $3C
		cRelease	$01
		cVibrato	$05, $0D
		cNote		cnFs4, $30
		cNote		cnRst, $04
		cVibrato	$02, $0A
		cInsFM		patch72
		cVolFM		$0C
		cRelease	$02
		cNote		cnRst, $0E
		cNote		cnF3
		cNote		cnGs3
		cNote		cnC4
		cNote		cnAs3
		cNote		cnGs3
		cNote		cnF3
		cNote		cnGs3
		cNote		cnRst
		cNote		cnGs3
		cNote		cnAs3
		cNote		cnF3
		cNote		cnGs3
		cNote		cnGs3
		cNote		cnAs3
		cNote		cnRst
		cNote		cnRst
		cNote		cnF3
		cNote		cnGs3
		cNote		cnC4
		cNote		cnAs3
		cNote		cnGs3
		cNote		cnF3
		cNote		cnGs3
		cNote		cnRst
		cNote		cnGs3
		cNote		cnF3
		cNote		cnAs3
		cNote		cnRst
		cNote		cnGs3
		cNote		cnRst, $1C
		cNote		cnRst, $0E
		cNote		cnF3
		cNote		cnGs3
		cNote		cnC4
		cNote		cnAs3
		cNote		cnGs3
		cNote		cnF3
		cNote		cnGs3
		cNote		cnRst
		cNote		cnGs3
		cNote		cnAs3
		cNote		cnRst, $07
		cNote		cnF3
		cNote		cnGs3
		cNote		cnRst
		cNote		cnGs3, $0E
		cNote		cnAs3
		cNote		cnRst
		cNote		cnRst
		cNote		cnF3
		cNote		cnGs3
		cNote		cnC4
		cNote		cnAs3
		cNote		cnGs3
		cNote		cnF3
		cNote		cnGs3
		cNote		cnRst
		cNote		cnGs3
		cNote		cnAs3
		cNote		cnGs3
		cNote		cnRst
		cNote		cnF3
		cVolFM		$00
		cNote		cnRst, $1C
		cLoopCnt	$07
			cNote		cnRst, $70
		cLoopCntEnd
	cLoopEnd
	cStop

Song02_FM3:
	cLoopStart
		cInsFM		patch08
		cVolFM		$0D
		cRelease	$05
		cVibrato	$02, $0A
		cPan		cpLeft
		cNoteShift	$00, $00, $00
		cLoopCnt	$01
			cNote		cnC5, $07
			cNote		cnC5
			cNote		cnC5
			cNote		cnRst, $15
			cNote		cnC5, $07
			cNote		cnC5
			cNote		cnC5
			cNote		cnRst, $15
			cNote		cnC5, $07
			cNote		cnC5
			cNote		cnC5
			cNote		cnRst
			cNote		cnRst, $70
		cLoopCntEnd
		cLoopCnt	$0B
			cRelease	$05
			cNote		cnC5, $07
			cNote		cnC5
			cNote		cnC5
			cNote		cnRst, $15
			cNote		cnC5, $07
			cNote		cnC5
			cNote		cnC5
			cNote		cnRst, $15
			cNote		cnC5, $07
			cNote		cnC5
			cNote		cnC5
			cNote		cnRst
			cNote		cnC5
			cNote		cnC5
			cNote		cnC5
			cNote		cnRst, $5B
		cLoopCntEnd
		cLoopCnt	$01
			cNote		cnRst, $70
			cNote		cnRst
			cNote		cnRst
			cNote		cnC5, $07
			cNote		cnC5
			cNote		cnC5
			cNote		cnRst, $5B
		cLoopCntEnd
	cLoopEnd
	cStop

Song02_FM4:
	cLoopStart
		cInsFM		patch0F
		cVolFM		$0C
		cRelease	$01
		cVibrato	$02, $0A
		cPan		cpCenter
		cNoteShift	$00, $00, $00
		cLoopCnt	$12
			cNote		cnRst, $70
		cLoopCntEnd
		cInsFM		patch1F
		cVolFM		$0D
		cRelease	$05
		cNote		cnGs3, $07
		cNote		cnGs3
		cNote		cnGs3
		cNote		cnGs3
		cNote		cnGs3
		cNote		cnGs3
		cNote		cnGs3
		cNote		cnGs3
		cNote		cnGs3
		cNote		cnGs3
		cNote		cnGs3
		cNote		cnGs3
		cNote		cnGs3
		cNote		cnGs3
		cNote		cnGs3
		cNote		cnGs3
		cLoopCnt	$07
			cNote		cnRst, $70
		cLoopCntEnd
		cLoopCnt	$03
			cNote		cnGs3, $07
			cNote		cnGs3
			cNote		cnGs3
			cNote		cnGs3
			cNote		cnGs3
			cNote		cnGs3
			cNote		cnGs3
			cNote		cnGs3
			cNote		cnGs3
			cNote		cnGs3
			cNote		cnGs3
			cNote		cnGs3
			cNote		cnGs3
			cNote		cnGs3
			cNote		cnGs3
			cNote		cnGs3
			cNote		cnRst, $70
		cLoopCntEnd
	cLoopEnd
	cStop

Song02_FM5:
	cNote		cnRst, $13
	cLoopStart
		cRelease	$01
		cVibrato	$02, $0A
		cPan		cpRight
		cNoteShift	$00, $02, $00
		cVolFM		$00
		cNote		cnRst, $70
		cNote		cnRst
		cNote		cnRst
		cNote		cnRst
		cInsFM		patch72
		cVolFM		$09
		cNote		cnRst, $0E
		cRelease	$02
		cNote		cnF3
		cNote		cnGs3
		cNote		cnC4
		cNote		cnAs3
		cNote		cnGs3
		cNote		cnF3
		cNote		cnGs3
		cNote		cnRst
		cNote		cnGs3
		cNote		cnAs3
		cNote		cnF3
		cNote		cnGs3
		cNote		cnGs3
		cNote		cnAs3
		cNote		cnRst
		cNote		cnRst
		cNote		cnF3
		cNote		cnGs3
		cNote		cnC4
		cNote		cnAs3
		cNote		cnGs3
		cNote		cnF3
		cNote		cnGs3
		cNote		cnRst
		cNote		cnGs3
		cNote		cnF3
		cNote		cnAs3
		cNote		cnRst
		cNote		cnGs3
		cNote		cnRst, $1C
		cNote		cnRst, $0E
		cNote		cnF3
		cNote		cnGs3
		cNote		cnC4
		cNote		cnAs3
		cNote		cnGs3
		cNote		cnF3
		cNote		cnGs3
		cNote		cnRst
		cNote		cnGs3
		cNote		cnAs3
		cNote		cnRst, $07
		cNote		cnF3
		cNote		cnGs3
		cNote		cnRst
		cNote		cnGs3, $0E
		cNote		cnAs3
		cNote		cnRst
		cNote		cnRst
		cNote		cnF3
		cNote		cnGs3
		cNote		cnC4
		cNote		cnAs3
		cNote		cnGs3
		cNote		cnF3
		cNote		cnGs3
		cNote		cnRst
		cNote		cnGs3
		cNote		cnAs3
		cNote		cnGs3
		cNote		cnRst
		cNote		cnF3
		cNote		cnRst, $1C
		cVolFM		$00
		cNote		cnRst, $70
		cVibrato	$05, $0D
		cInsFM		patch09
		cVolFM		$09
		cRelease	$01
		cVibrato	$02, $0A
		cSustain
		cNote		cnF3, $3C
		cVibrato	$02, $0A
		cRelease	$01
		cNote		cnF3, $30
		cNote		cnRst, $04
		cVibrato	$02, $0A
		cSustain
		cNote		cnG3, $3C
		cVibrato	$05, $0D
		cRelease	$01
		cNote		cnG3, $30
		cNote		cnRst, $04
		cVibrato	$02, $0A
		cSustain
		cNote		cnB3, $3C
		cVibrato	$05, $0D
		cRelease	$01
		cNote		cnB3, $30
		cNote		cnRst, $04
		cVibrato	$02, $0A
		cSustain
		cNote		cnC4, $3C
		cVibrato	$05, $0D
		cRelease	$01
		cNote		cnC4, $30
		cNote		cnRst, $04
		cVibrato	$02, $0A
		cSustain
		cNote		cnD4, $3C
		cVibrato	$05, $0D
		cRelease	$01
		cNote		cnD4, $30
		cNote		cnRst, $04
		cVibrato	$02, $0A
		cSustain
		cNote		cnF4, $3C
		cVibrato	$05, $0D
		cRelease	$01
		cNote		cnF4, $30
		cNote		cnRst, $04
		cVibrato	$02, $0A
		cSustain
		cNote		cnFs4, $3C
		cVibrato	$05, $0D
		cRelease	$01
		cNote		cnFs4, $30
		cNote		cnRst, $04
		cVibrato	$02, $0A
		cInsFM		patch72
		cVolFM		$09
		cRelease	$02
		cNote		cnRst, $0E
		cNote		cnF3
		cNote		cnGs3
		cNote		cnC4
		cNote		cnAs3
		cNote		cnGs3
		cNote		cnF3
		cNote		cnGs3
		cNote		cnRst
		cNote		cnGs3
		cNote		cnAs3
		cNote		cnF3
		cNote		cnGs3
		cNote		cnGs3
		cNote		cnAs3
		cNote		cnRst
		cNote		cnRst
		cNote		cnF3
		cNote		cnGs3
		cNote		cnC4
		cNote		cnAs3
		cNote		cnGs3
		cNote		cnF3
		cNote		cnGs3
		cNote		cnRst
		cNote		cnGs3
		cNote		cnF3
		cNote		cnAs3
		cNote		cnRst
		cNote		cnGs3
		cNote		cnRst, $1C
		cNote		cnRst, $0E
		cNote		cnF3
		cNote		cnGs3
		cNote		cnC4
		cNote		cnAs3
		cNote		cnGs3
		cNote		cnF3
		cNote		cnGs3
		cNote		cnRst
		cNote		cnGs3
		cNote		cnAs3
		cNote		cnRst, $07
		cNote		cnF3
		cNote		cnGs3
		cNote		cnRst
		cNote		cnGs3, $0E
		cNote		cnAs3
		cNote		cnRst
		cNote		cnRst
		cNote		cnF3
		cNote		cnGs3
		cNote		cnC4
		cNote		cnAs3
		cNote		cnGs3
		cNote		cnF3
		cNote		cnGs3
		cNote		cnRst
		cNote		cnGs3
		cNote		cnAs3
		cNote		cnGs3
		cNote		cnRst
		cNote		cnF3
		cNote		cnRst, $1C
		cLoopCnt	$07
			cVolFM		$00
			cNote		cnRst, $70
		cLoopCntEnd
	cLoopEnd
	cStop

Song02_DAC:
	cLoopStart
		cPan		cpCenter
		cNote		cnC0, $1C
		cNote		cnCs0
		cNote		cnC0, $0E
		cNote		cnC0
		cNote		cnCs0, $1C
		cNote		cnC0
		cNote		cnCs0, $15
		cNote		cnC0, $07
		cNote		cnC0, $0E
		cNote		cnC0
		cNote		cnCs0, $1C
	cLoopEnd
	cStop

Song02_PSG1:
	cInsVolPSG	$00, $00
	cStop

Song02_PSG2:
	cInsVolPSG	$00, $00
	cStop

Song02_PSG3:
	cInsVolPSG	$00, $00
	cStop

Song02_Noise:
	cLoopStart
		cLoopCnt	$17
			cInsVolPSG	$0F, $0E
			cNote		cnG0, $0E
			cInsVolPSG	$0F, $0C
			cNote		cnG0, $0E
			cInsVolPSG	$0F, $0E
			cNote		cnG0, $0E
			cInsVolPSG	$0F, $0C
			cNote		cnG0, $0E
		cLoopCntEnd
		cLoopCnt	$1F
			cInsVolPSG	$0F, $0E
			cNote		cnG0, $07
			cInsVolPSG	$0F, $0C
			cNote		cnG0, $07
			cNote		cnG0
			cNote		cnG0
		cLoopCntEnd
	cLoopEnd
	cStop
