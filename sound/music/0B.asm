Song0B_Start:
	cType		ctMusic
	cFadeOut	$0000
	cTempo		$B1
	cChannel	Song0B_FM1
	cChannel	Song0B_FM2
	cChannel	Song0B_FM3
	cChannel	Song0B_FM4
	cChannel	Song0B_FM5
	cChannel	Song0B_DAC
	cChannel	Song0B_PSG1
	cChannel	Song0B_PSG2
	cChannel	Song0B_PSG3
	cChannel	Song0B_Noise

Song0B_FM1:
	cLoopStart
		cInsFM		patch07
		cVolFM		$0D
		cRelease	$01
		cVibrato	$02, $0A
		cPan		cpCenter
		cNoteShift	$00, $00, $00
		cLoopCnt	$01
			cNote		cnA3, $0C
			cNote		cnRst
			cNote		cnB3
			cNote		cnRst, $06
			cNote		cnG3
			cNote		cnRst
			cNote		cnE3, $12
			cNote		cnD3, $09
			cNote		cnRst, $03
			cNote		cnC3, $09
			cNote		cnRst, $03
			cNote		cnD3, $0C
			cNote		cnE3, $06
			cNote		cnA2, $1E
			cNote		cnD3, $0C
			cNote		cnG3, $06
			cNote		cnA3, $0C
			cNote		cnG3, $12
			cNote		cnA3, $0C
			cNote		cnRst
			cNote		cnB3
			cNote		cnRst, $06
			cNote		cnG3
			cNote		cnRst
			cNote		cnE3, $12
			cNote		cnD3, $06
			cNote		cnRst
			cNote		cnC3
			cNote		cnRst
			cNote		cnD3, $0C
			cNote		cnE3, $06
			cNote		cnA2
			cNote		cnRst
			cNote		cnE3, $12
			cNote		cnD3, $0C
			cNote		cnC3, $06
			cNote		cnB2, $0C
			cNote		cnC3, $12
		cLoopCntEnd
		cInsFM		patch04
		cVolFM		$0B
		cNote		cnA3, $3C
		cNote		cnA3, $0C
		cNote		cnC4
		cNote		cnE4
		cNote		cnF4, $18
		cNote		cnE4, $0C
		cNote		cnC4, $18
		cNote		cnA3, $24
		cNote		cnGs3, $3C
		cNote		cnGs3, $0C
		cNote		cnC4
		cNote		cnE4
		cNote		cnF4, $18
		cNote		cnE4, $0C
		cNote		cnC4, $18
		cNote		cnGs3, $24
		cNote		cnG3
		cNote		cnE4
		cNote		cnG3, $18
		cNote		cnGs3, $24
		cNote		cnE4
		cNote		cnGs3, $18
		cNote		cnG3, $24
		cNote		cnE4
		cNote		cnG3, $18
		cNote		cnGs3, $24
		cNote		cnE4, $3C
		cNote		cnA3
		cNote		cnA3, $0C
		cNote		cnC4
		cNote		cnE4
		cNote		cnF4, $18
		cNote		cnE4, $0C
		cNote		cnC4, $18
		cNote		cnA3, $24
		cNote		cnGs3, $3C
		cNote		cnGs3, $0C
		cNote		cnC4
		cNote		cnE4
		cNote		cnF4, $18
		cNote		cnE4, $0C
		cNote		cnG4, $18
		cNote		cnF4, $24
		cNote		cnG3
		cNote		cnE4
		cNote		cnG3, $18
		cNote		cnGs3, $24
		cNote		cnE4
		cNote		cnGs3, $18
		cNote		cnG3, $24
		cNote		cnE4
		cNote		cnG3, $18
		cNote		cnGs3, $24
		cNote		cnE4, $3C
		cInsFM		patch09
		cVolFM		$0C
		cNote		cnA3, $60
		cNote		cnC4, $30
		cNote		cnE4
		cNote		cnD4, $60
		cNote		cnG4
		cNote		cnA4
		cNote		cnE4, $30
		cNote		cnA4
		cNote		cnG4, $60
		cNote		cnE4
		cInsFM		patch07
		cVolFM		$0D
		cNote		cnA3
		cNote		cnC4, $30
		cNote		cnE4
		cNote		cnD4, $60
		cNote		cnG4
		cNote		cnA4
		cNote		cnE4, $30
		cNote		cnA4
		cNote		cnG4, $60
		cNote		cnA4
		cNote		cnG2, $30
		cNote		cnC3
		cNote		cnD3
		cNote		cnF3
		cNote		cnG3
		cNote		cnC4
		cNote		cnD4
		cNote		cnF4
		cNote		cnG4
		cNote		cnC5
		cNote		cnD5
		cNote		cnF5
		cNote		cnG3, $06
		cNote		cnG3
		cNote		cnB3, $06
		cNote		cnD4
		cNote		cnA4
		cNote		cnG4
		cNote		cnF4
		cNote		cnE4
		cNote		cnD4
		cNote		cnE4
		cNote		cnF4
		cNote		cnC4
		cNote		cnD4
		cNote		cnE4
		cNote		cnB3
		cNote		cnC4
		cNote		cnG3, $06
		cNote		cnG3
		cNote		cnB3, $06
		cNote		cnD4
		cNote		cnB4
		cNote		cnA4
		cNote		cnG4
		cNote		cnF4
		cNote		cnE4
		cNote		cnF4
		cNote		cnG4
		cNote		cnA4
		cNote		cnB4
		cNote		cnC5
		cNote		cnD5
		cNote		cnE5
	cLoopEnd
	cStop

Song0B_FM2:
	cLoopStart
		cInsFM		patch07
		cVolFM		$0C
		cRelease	$01
		cVibrato	$02, $0A
		cPan		cpCenter
		cNoteShift	$00, $00, $00
		cLoopCnt	$01
			cNote		cnF3, $0C
			cNote		cnRst
			cNote		cnG3
			cNote		cnRst, $06
			cNote		cnE3
			cNote		cnRst
			cNote		cnC3, $12
			cNote		cnB2, $09
			cNote		cnRst, $03
			cNote		cnA2, $09
			cNote		cnRst, $03
			cNote		cnB2, $0C
			cNote		cnB2, $06
			cNote		cnF2, $1E
			cNote		cnB2, $0C
			cNote		cnD3, $06
			cNote		cnF3, $0C
			cNote		cnE3, $12
			cNote		cnF3, $0C
			cNote		cnRst
			cNote		cnG3
			cNote		cnRst, $06
			cNote		cnE3
			cNote		cnRst
			cNote		cnC3, $12
			cNote		cnB2, $06
			cNote		cnRst
			cNote		cnA2
			cNote		cnRst
			cNote		cnB2, $0C
			cNote		cnC3, $06
			cNote		cnF2
			cNote		cnRst
			cNote		cnC3, $12
			cNote		cnB2, $0C
			cNote		cnA2, $06
			cNote		cnG2, $0C
			cNote		cnA2, $12
		cLoopCntEnd
		cLoopCnt	$07
			cNote		cnRst, $60
		cLoopCntEnd
		cInsFM		patch04
		cVolFM		$0A
		cNote		cnF3, $3C
		cNote		cnF3, $0C
		cNote		cnA3
		cNote		cnC4
		cNote		cnC4, $18
		cNote		cnC4, $0C
		cNote		cnA3, $18
		cNote		cnF3, $24
		cNote		cnF3, $3C
		cNote		cnF3, $0C
		cNote		cnGs3
		cNote		cnC4
		cNote		cnC4, $18
		cNote		cnC4, $0C
		cNote		cnE4, $18
		cNote		cnD4, $24
		cNote		cnE3
		cNote		cnC4
		cNote		cnE3, $18
		cNote		cnE3, $24
		cNote		cnC4
		cNote		cnE3, $18
		cNote		cnE3, $24
		cNote		cnC4
		cNote		cnE3, $18
		cNote		cnE3, $24
		cNote		cnC4, $3C
		cLoopCnt	$03
			cInsFM		patch0C
			cVolFM		$0B
			cNote		cnE4, $06
			cNote		cnA3
			cNote		cnC4
			cNote		cnE4
			cNote		cnRst
			cNote		cnF3
			cNote		cnA3
			cNote		cnC4
			cNote		cnE4
			cNote		cnF3
			cNote		cnE4
			cNote		cnF3
			cNote		cnD4
			cNote		cnF3
			cNote		cnC4
			cNote		cnF3
			cNote		cnE4
			cNote		cnA3
			cNote		cnC4
			cNote		cnE4
			cNote		cnRst
			cNote		cnF3
			cNote		cnA3
			cNote		cnC4
			cNote		cnE4
			cNote		cnF3
			cNote		cnE4
			cNote		cnF3
			cNote		cnD4
			cNote		cnF3
			cNote		cnC4
			cNote		cnF3
			cNote		cnD4
			cNote		cnG3
			cNote		cnB3
			cNote		cnD4
			cNote		cnRst
			cNote		cnE3
			cNote		cnG3
			cNote		cnB3
			cNote		cnD4
			cNote		cnG3
			cNote		cnD4
			cNote		cnG3
			cNote		cnC4
			cNote		cnG3
			cNote		cnB3
			cNote		cnG3
			cNote		cnD4
			cNote		cnG3
			cNote		cnB3
			cNote		cnD4
			cNote		cnRst
			cNote		cnE3
			cNote		cnG3
			cNote		cnB3
			cNote		cnD4
			cNote		cnG3
			cNote		cnD4
			cNote		cnG3
			cNote		cnC4
			cNote		cnG3
			cNote		cnB3
			cNote		cnG3
		cLoopCntEnd
		cInsFM		patch07
		cVolFM		$0C
		cNote		cnG2, $06
		cNote		cnG2
		cNote		cnB2, $06
		cNote		cnD3
		cNote		cnG3
		cNote		cnF3
		cNote		cnE3
		cNote		cnD3
		cNote		cnC3
		cNote		cnD3
		cNote		cnE3
		cNote		cnB2
		cNote		cnC3
		cNote		cnD3
		cNote		cnA2
		cNote		cnB2
		cNote		cnG2, $06
		cNote		cnG2
		cNote		cnB2, $06
		cNote		cnD3
		cNote		cnA3
		cNote		cnG3
		cNote		cnF3
		cNote		cnE3
		cNote		cnD3
		cNote		cnE3
		cNote		cnF3
		cNote		cnC3
		cNote		cnD3
		cNote		cnE3
		cNote		cnB2
		cNote		cnC3
		cNote		cnG2, $06
		cNote		cnG2
		cNote		cnB2, $06
		cNote		cnD3
		cNote		cnB3
		cNote		cnA3
		cNote		cnG3
		cNote		cnF3
		cNote		cnE3
		cNote		cnF3
		cNote		cnG3
		cNote		cnD3
		cNote		cnE3
		cNote		cnF3
		cNote		cnC3
		cNote		cnD3
		cNote		cnG2, $06
		cNote		cnG2
		cNote		cnB2, $06
		cNote		cnD3
		cNote		cnC4
		cNote		cnB3
		cNote		cnA3
		cNote		cnG3
		cNote		cnF3
		cNote		cnG3
		cNote		cnA3
		cNote		cnE3
		cNote		cnF3
		cNote		cnG3
		cNote		cnD3
		cNote		cnE3
		cNote		cnG2, $06
		cNote		cnG2
		cNote		cnB2, $06
		cNote		cnD3
		cNote		cnD4
		cNote		cnC4
		cNote		cnB3
		cNote		cnA3
		cNote		cnG3
		cNote		cnA3
		cNote		cnB3
		cNote		cnF3
		cNote		cnG3
		cNote		cnA3
		cNote		cnE3
		cNote		cnF3
		cNote		cnG2, $06
		cNote		cnG2
		cNote		cnB2, $06
		cNote		cnD3
		cNote		cnE4
		cNote		cnD4
		cNote		cnC4
		cNote		cnB3
		cNote		cnA3
		cNote		cnB3
		cNote		cnC4
		cNote		cnG3
		cNote		cnA3
		cNote		cnB3
		cNote		cnF3
		cNote		cnG3
		cNote		cnD3, $06
		cNote		cnD3
		cNote		cnG3, $06
		cNote		cnB3
		cNote		cnF4
		cNote		cnE4
		cNote		cnD4
		cNote		cnC4
		cNote		cnB3
		cNote		cnC4
		cNote		cnD4
		cNote		cnA3
		cNote		cnB3
		cNote		cnC4
		cNote		cnG3
		cNote		cnA3
		cNote		cnE3, $06
		cNote		cnE3
		cNote		cnG3, $06
		cNote		cnB3
		cNote		cnG4
		cNote		cnF4
		cNote		cnE4
		cNote		cnD4
		cNote		cnC4
		cNote		cnD4
		cNote		cnE4
		cNote		cnF4
		cNote		cnG4
		cNote		cnA4
		cNote		cnB4
		cNote		cnC5
	cLoopEnd
	cStop

Song0B_FM3:
	cLoopStart
		cInsFM		patch1E
		cVolFM		$0C
		cRelease	$01
		cVibrato	$02, $0A
		cPan		cpCenter
		cNoteShift	$00, $00, $00
		cLoopCnt	$07
			cRelease	$02
			cNote		cnC2, $0C
			cNote		cnC2
			cNote		cnC2
			cNote		cnC2
			cNote		cnC2
			cNote		cnC2
			cNote		cnC2
			cNote		cnC2
		cLoopCntEnd
		cLoopCnt	$02
			cNote		cnF1, $0C
			cNote		cnF1
			cNote		cnF1
			cNote		cnF1
			cNote		cnF1
			cNote		cnF1
			cNote		cnF1
			cNote		cnF1
		cLoopCntEnd
		cNote		cnF1, $0C
		cNote		cnF1
		cNote		cnF1
		cNote		cnF1
		cNote		cnF1
		cNote		cnA1
		cNote		cnC2
		cNote		cnF2
		cLoopCnt	$03
			cNote		cnC2, $0C
			cNote		cnC2
			cNote		cnC2
			cNote		cnC2, $06
			cNote		cnC2
			cNote		cnC2
			cNote		cnC2
			cNote		cnC2, $0C
			cNote		cnC2
			cNote		cnC2
		cLoopCntEnd
		cLoopCnt	$02
			cNote		cnF1, $0C
			cNote		cnF1
			cNote		cnF1
			cNote		cnF1
			cNote		cnF1
			cNote		cnF1
			cNote		cnF1
			cNote		cnF1
		cLoopCntEnd
		cNote		cnF1, $0C
		cNote		cnF1
		cNote		cnF1
		cNote		cnF1
		cNote		cnF1
		cNote		cnA1
		cNote		cnC2
		cNote		cnF2
		cLoopCnt	$03
			cNote		cnC2, $0C
			cNote		cnC2
			cNote		cnC2
			cNote		cnC2, $06
			cNote		cnC2
			cNote		cnC2
			cNote		cnC2
			cNote		cnC2, $0C
			cNote		cnC2
			cNote		cnC2
		cLoopCntEnd
		cLoopCnt	$01
			cInsFM		patch1A
			cVolFM		$0C
			cNote		cnF1, $0A
			cNote		cnRst, $0E
			cNote		cnF1, $0C
			cNote		cnF1, $0A
			cNote		cnRst, $0E
			cNote		cnF1, $0C
			cNote		cnF1, $0A
			cNote		cnRst, $0E
			cNote		cnF1, $0C
			cNote		cnF1, $0A
			cNote		cnRst, $0E
			cNote		cnF1, $0A
			cNote		cnRst, $0E
			cNote		cnF1, $0C
			cNote		cnF1, $0A
			cNote		cnRst, $0E
			cNote		cnE1, $0A
			cNote		cnRst, $0E
			cNote		cnE1, $0C
			cNote		cnE1, $0A
			cNote		cnRst, $0E
			cNote		cnE1, $0C
			cNote		cnE1, $0A
			cNote		cnRst, $0E
			cNote		cnE1, $0C
			cNote		cnE1, $0A
			cNote		cnRst, $0E
			cNote		cnE1, $0A
			cNote		cnRst, $0E
			cNote		cnE1, $0C
			cNote		cnE1, $0A
			cNote		cnRst, $0E
			cNote		cnF1, $0A
			cNote		cnRst, $0E
			cNote		cnF1, $0C
			cNote		cnF1, $0A
			cNote		cnRst, $0E
			cNote		cnF1, $0C
			cNote		cnF1, $0A
			cNote		cnRst, $0E
			cNote		cnF1, $0C
			cNote		cnF1, $0A
			cNote		cnRst, $0E
			cNote		cnF1, $0A
			cNote		cnRst, $0E
			cNote		cnF1, $0C
			cNote		cnF1, $0A
			cNote		cnRst, $0E
			cNote		cnE1, $0A
			cNote		cnRst, $0E
			cNote		cnE1, $0C
			cNote		cnE1, $0A
			cNote		cnRst, $0E
			cNote		cnE1, $0C
			cNote		cnE1, $0A
			cNote		cnRst, $0E
			cNote		cnA1, $0C
			cNote		cnA1, $0A
			cNote		cnRst, $0E
			cNote		cnA1, $0C
			cNote		cnRst
			cRelease	$03
			cNote		cnA1, $06
			cNote		cnB1
			cNote		cnC2
			cNote		cnB1
			cRelease	$01
			cNote		cnA1, $0C
		cLoopCntEnd
		cLoopCnt	$06
			cNote		cnG1, $06
			cNote		cnRst
			cNote		cnG1
			cNote		cnRst
			cNote		cnG1
			cNote		cnRst
			cNote		cnG1
			cNote		cnG1
			cNote		cnG1
			cNote		cnG1
			cNote		cnG1
			cNote		cnRst
			cNote		cnG1
			cNote		cnRst
			cNote		cnG1
			cNote		cnG1
		cLoopCntEnd
		cNote		cnG1, $0C
		cNote		cnG2, $06
		cNote		cnG2
		cNote		cnG1, $0C
		cNote		cnG2, $06
		cNote		cnRst
		cNote		cnG1, $0C
		cNote		cnG2, $06
		cNote		cnRst
		cNote		cnG1
		cNote		cnG1
		cNote		cnD2
		cNote		cnF2
	cLoopEnd
	cStop

Song0B_FM4:
	cNote		cnRst, $0C
	cLoopStart
		cInsFM		patch07
		cVolFM		$0A
		cRelease	$01
		cVibrato	$02, $0A
		cPan		cpLeft
		cNoteShift	$00, $02, $00
		cLoopCnt	$01
			cNote		cnA3, $0C
			cNote		cnRst
			cNote		cnB3
			cNote		cnRst, $06
			cNote		cnG3
			cNote		cnRst
			cNote		cnE3, $12
			cNote		cnD3, $09
			cNote		cnRst, $03
			cNote		cnC3, $09
			cNote		cnRst, $03
			cNote		cnD3, $0C
			cNote		cnE3, $06
			cNote		cnA2, $1E
			cNote		cnD3, $0C
			cNote		cnG3, $06
			cNote		cnA3, $0C
			cNote		cnG3, $12
			cNote		cnA3, $0C
			cNote		cnRst
			cNote		cnB3
			cNote		cnRst, $06
			cNote		cnG3
			cNote		cnRst
			cNote		cnE3, $12
			cNote		cnD3, $06
			cNote		cnRst
			cNote		cnC3
			cNote		cnRst
			cNote		cnD3, $0C
			cNote		cnE3, $06
			cNote		cnA2
			cNote		cnRst
			cNote		cnE3, $12
			cNote		cnD3, $0C
			cNote		cnC3, $06
			cNote		cnB2, $0C
			cNote		cnC3, $12
		cLoopCntEnd
		cInsFM		patch04
		cVolFM		$09
		cNote		cnA3, $3C
		cNote		cnA3, $0C
		cNote		cnC4
		cNote		cnE4
		cNote		cnF4, $18
		cNote		cnE4, $0C
		cNote		cnC4, $18
		cNote		cnA3, $24
		cNote		cnGs3, $3C
		cNote		cnGs3, $0C
		cNote		cnC4
		cNote		cnE4
		cNote		cnF4, $18
		cNote		cnE4, $0C
		cNote		cnC4, $18
		cNote		cnGs3, $24
		cNote		cnG3
		cNote		cnE4
		cNote		cnG3, $18
		cNote		cnGs3, $24
		cNote		cnE4
		cNote		cnGs3, $18
		cNote		cnG3, $24
		cNote		cnE4
		cNote		cnG3, $18
		cNote		cnGs3, $24
		cNote		cnE4, $3C
		cNote		cnA3
		cNote		cnA3, $0C
		cNote		cnC4
		cNote		cnE4
		cNote		cnF4, $18
		cNote		cnE4, $0C
		cNote		cnC4, $18
		cNote		cnA3, $24
		cNote		cnGs3, $3C
		cNote		cnGs3, $0C
		cNote		cnC4
		cNote		cnE4
		cNote		cnF4, $18
		cNote		cnE4, $0C
		cNote		cnG4, $18
		cNote		cnF4, $24
		cNote		cnG3
		cNote		cnE4
		cNote		cnG3, $18
		cNote		cnGs3, $24
		cNote		cnE4
		cNote		cnGs3, $18
		cNote		cnG3, $24
		cNote		cnE4
		cNote		cnG3, $18
		cNote		cnGs3, $24
		cNote		cnE4, $3C
		cInsFM		patch09
		cVolFM		$0A
		cNote		cnA3, $60
		cNote		cnC4, $30
		cNote		cnE4
		cNote		cnD4, $60
		cNote		cnG4
		cNote		cnA4
		cNote		cnE4, $30
		cNote		cnA4
		cNote		cnG4, $60
		cNote		cnE4
		cInsFM		patch07
		cVolFM		$0B
		cNote		cnA3
		cNote		cnC4, $30
		cNote		cnE4
		cNote		cnD4, $60
		cNote		cnG4
		cNote		cnA4
		cNote		cnE4, $30
		cNote		cnA4
		cNote		cnG4, $60
		cNote		cnA4
		cNote		cnG2, $30
		cNote		cnC3
		cNote		cnD3
		cNote		cnF3
		cNote		cnG3
		cNote		cnC4
		cNote		cnD4
		cNote		cnF4
		cNote		cnG4
		cNote		cnC5
		cNote		cnD5
		cNote		cnF5
		cNote		cnG3, $06
		cNote		cnG3
		cNote		cnB3, $06
		cNote		cnD4
		cNote		cnA4
		cNote		cnG4
		cNote		cnF4
		cNote		cnE4
		cNote		cnD4
		cNote		cnE4
		cNote		cnF4
		cNote		cnC4
		cNote		cnD4
		cNote		cnE4
		cNote		cnB3
		cNote		cnC4
		cNote		cnG3, $06
		cNote		cnG3
		cNote		cnB3, $06
		cNote		cnD4
		cNote		cnB4
		cNote		cnA4
		cNote		cnG4
		cNote		cnF4
		cNote		cnE4
		cNote		cnF4
		cNote		cnG4
		cNote		cnA4
		cNote		cnB4
		cNote		cnC5
		cNote		cnD5
		cNote		cnE5
	cLoopEnd
	cStop

Song0B_FM5:
	cNote		cnRst, $0D
	cLoopStart
		cInsFM		patch07
		cVolFM		$0B
		cRelease	$01
		cVibrato	$02, $0A
		cPan		cpRight
		cNoteShift	$00, $02, $00
		cLoopCnt	$01
			cNote		cnF3, $0C
			cNote		cnRst
			cNote		cnG3
			cNote		cnRst, $06
			cNote		cnE3
			cNote		cnRst
			cNote		cnC3, $12
			cNote		cnB2, $09
			cNote		cnRst, $03
			cNote		cnA2, $09
			cNote		cnRst, $03
			cNote		cnB2, $0C
			cNote		cnB2, $06
			cNote		cnF2, $1E
			cNote		cnB2, $0C
			cNote		cnD3, $06
			cNote		cnF3, $0C
			cNote		cnE3, $12
			cNote		cnF3, $0C
			cNote		cnRst
			cNote		cnG3
			cNote		cnRst, $06
			cNote		cnE3
			cNote		cnRst
			cNote		cnC3, $12
			cNote		cnB2, $06
			cNote		cnRst
			cNote		cnA2
			cNote		cnRst
			cNote		cnB2, $0C
			cNote		cnC3, $06
			cNote		cnF2
			cNote		cnRst
			cNote		cnC3, $12
			cNote		cnB2, $0C
			cNote		cnA2, $06
			cNote		cnG2, $0C
			cNote		cnA2, $12
		cLoopCntEnd
		cLoopCnt	$07
			cNote		cnRst, $60
		cLoopCntEnd
		cInsFM		patch04
		cVolFM		$08
		cNote		cnF3, $3C
		cNote		cnF3, $0C
		cNote		cnA3
		cNote		cnC4
		cNote		cnC4, $18
		cNote		cnC4, $0C
		cNote		cnA3, $18
		cNote		cnF3, $24
		cNote		cnF3, $3C
		cNote		cnF3, $0C
		cNote		cnGs3
		cNote		cnC4
		cNote		cnC4, $18
		cNote		cnC4, $0C
		cNote		cnE4, $18
		cNote		cnD4, $24
		cNote		cnE3
		cNote		cnC4
		cNote		cnE3, $18
		cNote		cnE3, $24
		cNote		cnC4
		cNote		cnE3, $18
		cNote		cnE3, $24
		cNote		cnC4
		cNote		cnE3, $18
		cNote		cnE3, $24
		cNote		cnC4, $3C
		cLoopCnt	$03
			cInsFM		patch0C
			cVolFM		$09
			cNote		cnE4, $06
			cNote		cnA3
			cNote		cnC4
			cNote		cnE4
			cNote		cnRst
			cNote		cnF3
			cNote		cnA3
			cNote		cnC4
			cNote		cnE4
			cNote		cnF3
			cNote		cnE4
			cNote		cnF3
			cNote		cnD4
			cNote		cnF3
			cNote		cnC4
			cNote		cnF3
			cNote		cnE4
			cNote		cnA3
			cNote		cnC4
			cNote		cnE4
			cNote		cnRst
			cNote		cnF3
			cNote		cnA3
			cNote		cnC4
			cNote		cnE4
			cNote		cnF3
			cNote		cnE4
			cNote		cnF3
			cNote		cnD4
			cNote		cnF3
			cNote		cnC4
			cNote		cnF3
			cNote		cnD4
			cNote		cnG3
			cNote		cnB3
			cNote		cnD4
			cNote		cnRst
			cNote		cnE3
			cNote		cnG3
			cNote		cnB3
			cNote		cnD4
			cNote		cnG3
			cNote		cnD4
			cNote		cnG3
			cNote		cnC4
			cNote		cnG3
			cNote		cnB3
			cNote		cnG3
			cNote		cnD4
			cNote		cnG3
			cNote		cnB3
			cNote		cnD4
			cNote		cnRst
			cNote		cnE3
			cNote		cnG3
			cNote		cnB3
			cNote		cnD4
			cNote		cnG3
			cNote		cnD4
			cNote		cnG3
			cNote		cnC4
			cNote		cnG3
			cNote		cnB3
			cNote		cnG3
		cLoopCntEnd
		cInsFM		patch07
		cVolFM		$0A
		cNote		cnG2, $06
		cNote		cnG2
		cNote		cnB2, $06
		cNote		cnD3
		cNote		cnG3
		cNote		cnF3
		cNote		cnE3
		cNote		cnD3
		cNote		cnC3
		cNote		cnD3
		cNote		cnE3
		cNote		cnB2
		cNote		cnC3
		cNote		cnD3
		cNote		cnA2
		cNote		cnB2
		cNote		cnG2, $06
		cNote		cnG2
		cNote		cnB2, $06
		cNote		cnD3
		cNote		cnA3
		cNote		cnG3
		cNote		cnF3
		cNote		cnE3
		cNote		cnD3
		cNote		cnE3
		cNote		cnF3
		cNote		cnC3
		cNote		cnD3
		cNote		cnE3
		cNote		cnB2
		cNote		cnC3
		cNote		cnG2, $06
		cNote		cnG2
		cNote		cnB2, $06
		cNote		cnD3
		cNote		cnB3
		cNote		cnA3
		cNote		cnG3
		cNote		cnF3
		cNote		cnE3
		cNote		cnF3
		cNote		cnG3
		cNote		cnD3
		cNote		cnE3
		cNote		cnF3
		cNote		cnC3
		cNote		cnD3
		cNote		cnG2, $06
		cNote		cnG2
		cNote		cnB2, $06
		cNote		cnD3
		cNote		cnC4
		cNote		cnB3
		cNote		cnA3
		cNote		cnG3
		cNote		cnF3
		cNote		cnG3
		cNote		cnA3
		cNote		cnE3
		cNote		cnF3
		cNote		cnG3
		cNote		cnD3
		cNote		cnE3
		cNote		cnG2, $06
		cNote		cnG2
		cNote		cnB2, $06
		cNote		cnD3
		cNote		cnD4
		cNote		cnC4
		cNote		cnB3
		cNote		cnA3
		cNote		cnG3
		cNote		cnA3
		cNote		cnB3
		cNote		cnF3
		cNote		cnG3
		cNote		cnA3
		cNote		cnE3
		cNote		cnF3
		cNote		cnG2, $06
		cNote		cnG2
		cNote		cnB2, $06
		cNote		cnD3
		cNote		cnE4
		cNote		cnD4
		cNote		cnC4
		cNote		cnB3
		cNote		cnA3
		cNote		cnB3
		cNote		cnC4
		cNote		cnG3
		cNote		cnA3
		cNote		cnB3
		cNote		cnF3
		cNote		cnG3
		cNote		cnD3, $06
		cNote		cnD3
		cNote		cnG3, $06
		cNote		cnB3
		cNote		cnF4
		cNote		cnE4
		cNote		cnD4
		cNote		cnC4
		cNote		cnB3
		cNote		cnC4
		cNote		cnD4
		cNote		cnA3
		cNote		cnB3
		cNote		cnC4
		cNote		cnG3
		cNote		cnA3
		cNote		cnE3, $06
		cNote		cnE3
		cNote		cnG3, $06
		cNote		cnB3
		cNote		cnG4
		cNote		cnF4
		cNote		cnE4
		cNote		cnD4
		cNote		cnC4
		cNote		cnD4
		cNote		cnE4
		cNote		cnF4
		cNote		cnG4
		cNote		cnA4
		cNote		cnB4
		cNote		cnC5
	cLoopEnd
	cStop

Song0B_DAC:
	cLoopStart
		cLoopCnt	$06
			cPan		cpCenter
			cNote		cnC0, $18
			cNote		cnC0
			cNote		cnC0
			cNote		cnCs0
		cLoopCntEnd
		cNote		cnC0, $18
		cNote		cnC0
		cNote		cnCs0, $06
		cNote		cnCs0
		cNote		cnDs0, $0C
		cNote		cnDs0
		cNote		cnCs0, $06
		cNote		cnCs0
		cLoopCnt	$1F
			cNote		cnC0, $18
			cNote		cnCs0
			cNote		cnC0
			cNote		cnCs0
		cLoopCntEnd
		cLoopCnt	$07
			cNote		cnC0, $18
			cNote		cnCs0
			cNote		cnC0
			cNote		cnCs0
		cLoopCntEnd
	cLoopEnd
	cStop

Song0B_PSG1:
	cStop

Song0B_PSG2:
	cStop

Song0B_PSG3:
	cStop

Song0B_Noise:
	cLoopStart
		cInsVolPSG	$0F, $0C
		cRelease	$01
		cVibrato	$04, $0A
		cNote		cnG0, $0C
		cNote		cnG0
		cNote		cnRst, $0C
		cNote		cnG0, $06
		cNote		cnG0
		cNote		cnRst
		cNote		cnG0
		cNote		cnG0
		cNote		cnRst
		cNote		cnRst, $0C
		cNote		cnG0
	cLoopEnd
	cStop
