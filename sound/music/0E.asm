Song0E_Start:
	cType		ctMusic
	cFadeOut	$0000
	cTempo		$C5
	cChannel	Song0E_FM1
	cChannel	Song0E_FM2
	cChannel	Song0E_FM3
	cChannel	Song0E_FM4
	cChannel	Song0E_FM5
	cChannel	Song0E_DAC
	cChannel	Song0E_PSG1
	cChannel	Song0E_PSG2
	cChannel	Song0E_PSG3
	cChannel	Song0E_Noise

Song0E_FM1:
	cLoopStart
		cInsFM		patch09
		cVolFM		$0C
		cRelease	$01
		cPan		cpCenter
		cNoteShift	$00, $00, $00
		cVibrato	$02, $0A
		cNote		cnC4, $70
		cNote		cnD4
		cNote		cnE4, $62
		cNote		cnD4, $07
		cNote		cnE4
		cNote		cnD4, $70
		cNote		cnC4
		cNote		cnD4
		cNote		cnE4, $62
		cNote		cnD4, $07
		cNote		cnE4
		cNote		cnD4, $70
		cInsFM		patch07
		cVolFM		$0E
		cNote		cnC4, $15
		cNote		cnB3
		cNote		cnE3, $70
		cNote		cnE3, $07
		cNote		cnE3
		cNote		cnC4, $15
		cNote		cnB3
		cRelease	$00
		cNote		cnG3, $0E
		cNote		cnA3, $62
		cNote		cnG3, $07
		cNote		cnA3
		cNote		cnG3, $15
		cNote		cnE3
		cNote		cnD3, $46
		cNote		cnC4, $15
		cNote		cnB3
		cNote		cnE3, $70
		cNote		cnE3, $07
		cNote		cnE3
		cNote		cnC4, $15
		cNote		cnB3
		cNote		cnG3, $0E
		cNote		cnA3, $62
		cNote		cnB3, $07
		cNote		cnC4
		cNote		cnB3, $15
		cNote		cnG3
		cNote		cnD4, $2A
		cNote		cnC4, $0E
		cNote		cnB3
		cNote		cnA3, $2A
		cNote		cnC4
		cNote		cnE4, $1C
		cNote		cnD4, $15
		cNote		cnB3
		cNote		cnG3, $2A
		cNote		cnD4, $1C
		cNote		cnC4, $2A
		cNote		cnA3, $0E
		cNote		cnE4, $1C
		cNote		cnD4, $0E
		cNote		cnC4
		cNote		cnD4, $38
		cNote		cnC4, $1C
		cNote		cnB3
		cNote		cnA3, $2A
		cNote		cnC4
		cNote		cnE4, $1C
		cNote		cnD4, $15
		cNote		cnB3
		cNote		cnG3, $2A
		cNote		cnD4, $1C
		cNote		cnC4, $2A
		cNote		cnA3, $0E
		cNote		cnE4, $1C
		cNote		cnD4, $0E
		cNote		cnC4
		cNote		cnD4, $38
		cNote		cnG4, $1C
		cNote		cnF4
	cLoopEnd
	cStop

Song0E_FM2:
	cLoopStart
		cInsFM		patch09
		cVolFM		$0C
		cRelease	$01
		cVibrato	$02, $0A
		cPan		cpRight
		cNoteShift	$00, $00, $00
		cLoopCnt	$03
			cNote		cnA3, $70
			cNote		cnB3
			cNote		cnC4, $62
			cNote		cnB3, $07
			cNote		cnC4
			cNote		cnB3, $70
		cLoopCntEnd
		cInsFM		patch0C
		cVolFM		$0C
		cRelease	$03
		cLoopCnt	$03
			cNote		cnA3, $07
			cNote		cnA4
			cNote		cnA3
			cNote		cnA3
		cLoopCntEnd
		cLoopCnt	$03
			cNote		cnB3, $07
			cNote		cnB4
			cNote		cnB3
			cNote		cnB3
		cLoopCntEnd
		cLoopCnt	$03
			cNote		cnC4, $07
			cNote		cnC5
			cNote		cnC4
			cNote		cnC4
		cLoopCntEnd
		cLoopCnt	$03
			cNote		cnD4, $07
			cNote		cnD5
			cNote		cnD4
			cNote		cnD4
		cLoopCntEnd
		cLoopCnt	$03
			cNote		cnA3, $07
			cNote		cnA4
			cNote		cnA3
			cNote		cnA3
		cLoopCntEnd
		cLoopCnt	$03
			cNote		cnB3, $07
			cNote		cnB4
			cNote		cnB3
			cNote		cnB3
		cLoopCntEnd
		cLoopCnt	$03
			cNote		cnC4, $07
			cNote		cnC5
			cNote		cnC4
			cNote		cnC4
		cLoopCntEnd
		cNote		cnB3, $07
		cNote		cnG3
		cNote		cnA3
		cNote		cnB3
		cNote		cnC4
		cNote		cnD4
		cNote		cnE4
		cNote		cnF4
		cNote		cnG4
		cNote		cnE4
		cNote		cnF4
		cNote		cnG4
		cNote		cnA4
		cNote		cnB4
		cNote		cnC5
		cNote		cnD5
	cLoopEnd
	cStop

Song0E_FM3:
	cLoopStart
		cInsFM		patch1A
		cVolFM		$0C
		cRelease	$01
		cVibrato	$02, $0A
		cPan		cpCenter
		cNoteShift	$00, $00, $00
		cLoopCnt	$03
			cNote		cnA1, $0E
			cNote		cnA2, $04
			cNote		cnRst, $03
			cNote		cnA2, $04
			cNote		cnRst, $03
			cNote		cnA1, $0E
			cNote		cnA2, $04
			cNote		cnRst, $03
			cNote		cnA2, $04
			cNote		cnRst, $03
			cNote		cnA1, $0E
			cNote		cnA2, $04
			cNote		cnRst, $03
			cNote		cnA2, $04
			cNote		cnRst, $03
			cNote		cnA1, $0E
			cNote		cnA2, $04
			cNote		cnRst, $03
			cNote		cnA2, $04
			cNote		cnRst, $03
			cNote		cnA1, $0E
			cNote		cnA2, $04
			cNote		cnRst, $03
			cNote		cnA2, $04
			cNote		cnRst, $03
			cNote		cnA1, $0E
			cNote		cnA2, $04
			cNote		cnRst, $03
			cNote		cnA2, $04
			cNote		cnRst, $03
			cNote		cnA1, $0E
			cNote		cnA2, $04
			cNote		cnRst, $03
			cNote		cnA2, $04
			cNote		cnRst, $03
			cNote		cnA1, $0E
			cNote		cnA2, $04
			cNote		cnRst, $03
			cNote		cnA2, $04
			cNote		cnRst, $03
			cNote		cnF1, $0E
			cNote		cnF2, $04
			cNote		cnRst, $03
			cNote		cnF2, $04
			cNote		cnRst, $03
			cNote		cnF1, $0E
			cNote		cnF2, $04
			cNote		cnRst, $03
			cNote		cnF2, $04
			cNote		cnRst, $03
			cNote		cnF1, $0E
			cNote		cnF2, $04
			cNote		cnRst, $03
			cNote		cnF2, $04
			cNote		cnRst, $03
			cNote		cnF1, $0E
			cNote		cnF2, $04
			cNote		cnRst, $03
			cNote		cnF2, $04
			cNote		cnRst, $03
			cNote		cnG1, $0E
			cNote		cnG2, $04
			cNote		cnRst, $03
			cNote		cnG2, $04
			cNote		cnRst, $03
			cNote		cnG1, $0E
			cNote		cnG2, $04
			cNote		cnRst, $03
			cNote		cnG2, $04
			cNote		cnRst, $03
			cNote		cnG1, $0E
			cNote		cnG2, $04
			cNote		cnRst, $03
			cNote		cnG2, $04
			cNote		cnRst, $03
			cNote		cnG1, $0E
			cNote		cnG2, $04
			cNote		cnRst, $03
			cNote		cnG2, $04
			cNote		cnRst, $03
		cLoopCntEnd
		cLoopCnt	$03
			cNote		cnF1, $0E
			cNote		cnF2, $04
			cNote		cnRst, $03
			cNote		cnF2, $04
			cNote		cnRst, $03
			cNote		cnF1, $0E
			cNote		cnF2, $04
			cNote		cnRst, $03
			cNote		cnF2, $04
			cNote		cnRst, $03
			cNote		cnF1, $0E
			cNote		cnF2, $04
			cNote		cnRst, $03
			cNote		cnF2, $04
			cNote		cnRst, $03
			cNote		cnF1, $0E
			cNote		cnF2, $04
			cNote		cnRst, $03
			cNote		cnF2, $04
			cNote		cnRst, $03
			cNote		cnG1, $0E
			cNote		cnG2, $04
			cNote		cnRst, $03
			cNote		cnG2, $04
			cNote		cnRst, $03
			cNote		cnG1, $0E
			cNote		cnG2, $04
			cNote		cnRst, $03
			cNote		cnG2, $04
			cNote		cnRst, $03
			cNote		cnG1, $0E
			cNote		cnG2, $04
			cNote		cnRst, $03
			cNote		cnG2, $04
			cNote		cnRst, $03
			cNote		cnG1, $0E
			cNote		cnG2, $04
			cNote		cnRst, $03
			cNote		cnG2, $04
			cNote		cnRst, $03
		cLoopCntEnd
	cLoopEnd
	cStop

Song0E_FM4:
	cNote		cnRst, $12
	cLoopStart
		cInsFM		patch09
		cVolFM		$09
		cRelease	$01
		cVibrato	$02, $0A
		cPan		cpCenter
		cNoteShift	$00, $01, $00
		cNote		cnC4, $70
		cNote		cnD4
		cNote		cnE4, $62
		cNote		cnD4, $07
		cNote		cnE4
		cNote		cnD4, $70
		cNote		cnC4
		cNote		cnD4
		cNote		cnE4, $62
		cNote		cnD4, $07
		cNote		cnE4
		cNote		cnD4, $70
		cInsFM		patch07
		cVolFM		$0B
		cNote		cnC4, $15
		cNote		cnB3
		cNote		cnE3, $70
		cNote		cnE3, $07
		cNote		cnE3
		cNote		cnC4, $15
		cNote		cnB3
		cRelease	$00
		cNote		cnG3, $0E
		cNote		cnA3, $62
		cNote		cnG3, $07
		cNote		cnA3
		cNote		cnG3, $15
		cNote		cnE3
		cNote		cnD3, $46
		cNote		cnC4, $15
		cNote		cnB3
		cNote		cnE3, $70
		cNote		cnE3, $07
		cNote		cnE3
		cNote		cnC4, $15
		cNote		cnB3
		cNote		cnG3, $0E
		cNote		cnA3, $62
		cNote		cnB3, $07
		cNote		cnC4
		cNote		cnB3, $15
		cNote		cnG3
		cNote		cnD4, $2A
		cNote		cnC4, $0E
		cNote		cnB3
		cNote		cnA3, $2A
		cNote		cnC4
		cNote		cnE4, $1C
		cNote		cnD4, $15
		cNote		cnB3
		cNote		cnG3, $2A
		cNote		cnD4, $1C
		cNote		cnC4, $2A
		cNote		cnA3, $0E
		cNote		cnE4, $1C
		cNote		cnD4, $0E
		cNote		cnC4
		cNote		cnD4, $38
		cNote		cnC4, $1C
		cNote		cnB3
		cNote		cnA3, $2A
		cNote		cnC4
		cNote		cnE4, $1C
		cNote		cnD4, $15
		cNote		cnB3
		cNote		cnG3, $2A
		cNote		cnD4, $1C
		cNote		cnC4, $2A
		cNote		cnA3, $0E
		cNote		cnE4, $1C
		cNote		cnD4, $0E
		cNote		cnC4
		cNote		cnD4, $38
		cNote		cnG4, $1C
		cNote		cnF4
	cLoopEnd
	cStop

Song0E_FM5:
	cNote		cnRst, $02
	cLoopStart
		cInsFM		patch09
		cVolFM		$0C
		cRelease	$01
		cVibrato	$02, $0A
		cPan		cpLeft
		cNoteShift	$00, $01, $00
		cLoopCnt	$03
			cNote		cnA3, $70
			cNote		cnB3
			cNote		cnC4, $62
			cNote		cnB3, $07
			cNote		cnC4
			cNote		cnB3, $70
		cLoopCntEnd
		cNote		cnRst, $01
		cInsFM		patch0C
		cVolFM		$0B
		cRelease	$03
		cLoopCnt	$03
			cNote		cnA3, $07
			cNote		cnA4
			cNote		cnA3
			cNote		cnA3
		cLoopCntEnd
		cLoopCnt	$03
			cNote		cnB3, $07
			cNote		cnB4
			cNote		cnB3
			cNote		cnB3
		cLoopCntEnd
		cLoopCnt	$03
			cNote		cnC4, $07
			cNote		cnC5
			cNote		cnC4
			cNote		cnC4
		cLoopCntEnd
		cLoopCnt	$03
			cNote		cnD4, $07
			cNote		cnD5
			cNote		cnD4
			cNote		cnD4
		cLoopCntEnd
		cLoopCnt	$03
			cNote		cnA3, $07
			cNote		cnA4
			cNote		cnA3
			cNote		cnA3
		cLoopCntEnd
		cLoopCnt	$03
			cNote		cnB3, $07
			cNote		cnB4
			cNote		cnB3
			cNote		cnB3
		cLoopCntEnd
		cLoopCnt	$03
			cNote		cnC4, $07
			cNote		cnC5
			cNote		cnC4
			cNote		cnC4
		cLoopCntEnd
		cNote		cnB3, $07
		cNote		cnG3
		cNote		cnA3
		cNote		cnB3
		cNote		cnC4
		cNote		cnD4
		cNote		cnE4
		cNote		cnF4
		cNote		cnG4
		cNote		cnE4
		cNote		cnF4
		cNote		cnG4
		cNote		cnA4
		cNote		cnB4
		cNote		cnC5
		cNote		cnD5, $06
	cLoopEnd
	cStop

Song0E_DAC:
	cLoopStart
		cLoopCnt	$06
			cNote		cnC0, $1C
			cNote		cnCs0
		cLoopCntEnd
		cNote		cnC0, $1C
		cNote		cnCs0, $0E
		cNote		cnCs0, $07
		cNote		cnCs0
		cLoopCnt	$05
			cNote		cnC0, $1C
			cNote		cnCs0
		cLoopCntEnd
		cNote		cnCs0, $07
		cNote		cnD0
		cNote		cnCs0
		cNote		cnD0
		cNote		cnCs0
		cNote		cnCs0, $0E
		cNote		cnDs0, $07
		cNote		cnCs0
		cNote		cnCs0
		cNote		cnDs0
		cNote		cnCs0
		cNote		cnE0
		cNote		cnCs0
		cNote		cnCs0
		cNote		cnCs0
		cLoopCnt	$1E
			cNote		cnC0, $1C
			cNote		cnCs0
		cLoopCntEnd
		cNote		cnC0, $1C
		cNote		cnCs0, $07
		cNote		cnCs0
		cNote		cnCs0
		cNote		cnCs0
	cLoopEnd
	cStop

Song0E_PSG1:
	cStop

Song0E_PSG2:
	cStop

Song0E_PSG3:
	cStop

Song0E_Noise:
	cLoopStart
		cInsVolPSG	$0F, $0E
		cNote		cnRst, $07
		cNote		cnRst
		cNote		cnG0
		cNote		cnRst
		cNote		cnRst
		cNote		cnRst
		cNote		cnG0
		cNote		cnG0
	cLoopEnd
	cStop
