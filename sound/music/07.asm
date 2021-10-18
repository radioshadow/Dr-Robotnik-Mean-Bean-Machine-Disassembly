Song07_Start:
	cType		ctMusic
	cFadeOut	$0000
	cTempo		$C4
	cChannel	Song07_FM1
	cChannel	Song07_FM2
	cChannel	Song07_FM3
	cChannel	Song07_FM4
	cChannel	Song07_FM5
	cChannel	Song07_DAC
	cChannel	Song07_PSG1
	cChannel	Song07_PSG2
	cChannel	Song07_PSG3
	cChannel	Song07_Noise

Song07_FM1:
	cLoopStart
		cInsFM		patch7F
		cVolFM		$0D
		cRelease	$01
		cPan		cpCenter
		cVibrato	$02, $0A
		cLoopCnt	$03
			cNoteShift	$00, $00, $0C
			cNote		cnA0, $07
			cNote		cnRst
			cNote		cnA0
			cNote		cnRst
			cNote		cnA1
			cNote		cnRst
			cNote		cnA0
			cNote		cnG1
			cNote		cnRst
			cNote		cnA0
			cNote		cnE1
			cNote		cnRst
			cNote		cnC1
			cNote		cnRst
			cNote		cnD1
			cNote		cnRst
		cLoopCntEnd
		cLoopCnt	$03
			cNote		cnD1, $07
			cNote		cnRst
			cNote		cnD1
			cNote		cnRst
			cNote		cnD2
			cNote		cnRst
			cNote		cnD1
			cNote		cnC2
			cNote		cnRst
			cNote		cnD1
			cNote		cnA1
			cNote		cnRst
			cNote		cnF1
			cNote		cnRst
			cNote		cnG1
			cNote		cnRst
		cLoopCntEnd
		cLoopCnt	$03
			cNote		cnA0, $07
			cNote		cnRst
			cNote		cnA0
			cNote		cnRst
			cNote		cnA1
			cNote		cnRst
			cNote		cnA0
			cNote		cnG1
			cNote		cnRst
			cNote		cnA0
			cNote		cnE1
			cNote		cnRst
			cNote		cnC1
			cNote		cnRst
			cNote		cnD1
			cNote		cnRst
		cLoopCntEnd
		cLoopCnt	$07
			cNote		cnA0, $07
		cLoopCntEnd
		cLoopCnt	$07
			cNote		cnC1, $07
		cLoopCntEnd
		cLoopCnt	$07
			cNote		cnE1, $07
		cLoopCntEnd
		cLoopCnt	$07
			cNote		cnG1, $07
		cLoopCntEnd
		cLoopCnt	$07
			cNote		cnB1, $07
		cLoopCntEnd
		cLoopCnt	$07
			cNote		cnD2, $07
		cLoopCntEnd
		cLoopCnt	$07
			cNote		cnFs2, $07
		cLoopCntEnd
		cSlide		$05
		cLoopCnt	$03
			cNote		cnA2, $07
			cSlideStop
			cNote		cnA2, $07
		cLoopCntEnd
	cLoopEnd
	cStop

Song07_FM2:
	cLoopStart
		cRelease	$01
		cVibrato	$02, $0A
		cPan		cpCenter
		cVolFM		$00
		cNoteShift	$00, $00, $00
		cNote		cnRst, $70
		cNote		cnRst
		cNote		cnRst
		cNote		cnRst
		cNote		cnRst
		cNote		cnRst
		cNote		cnRst
		cNote		cnRst
		cLoopCnt	$01
			cInsFM		patch6F
			cVolFM		$0D
			cNote		cnA3, $00
			cSlide		$70
			cNote		cnA4, $09
			cNote		cnRst, $05
			cNote		cnC5, $09
			cNote		cnRst, $13
			cNote		cnG4, $07
			cNote		cnRst
			cNote		cnAs4
			cNote		cnAs4
			cNote		cnRst, $23
			cNote		cnD4, $07
			cNote		cnA4, $09
			cNote		cnRst, $05
			cNote		cnC5, $09
			cNote		cnRst, $59
			cSlideStop
		cLoopCntEnd
		cInsFM		patch76
		cVolFM		$0D
		cVolFM		$0D
		cNote		cnA4, $0A
		cNote		cnRst, $02
		cVolFM		$0A
		cNote		cnA4, $0A
		cNote		cnRst, $02
		cVolFM		$07
		cNote		cnA4, $0A
		cNote		cnRst, $02
		cVolFM		$04
		cNote		cnA4, $0A
		cNote		cnRst, $0A
		cVolFM		$0D
		cNote		cnC5, $0A
		cNote		cnRst, $02
		cVolFM		$0A
		cNote		cnC5, $0A
		cNote		cnRst, $02
		cVolFM		$07
		cNote		cnC5, $0A
		cNote		cnRst, $02
		cVolFM		$04
		cNote		cnC5, $0A
		cNote		cnRst, $0A
		cVolFM		$0D
		cNote		cnE5, $0A
		cNote		cnRst, $02
		cVolFM		$0A
		cNote		cnE5, $0A
		cNote		cnRst, $02
		cVolFM		$07
		cNote		cnE5, $0A
		cNote		cnRst, $02
		cVolFM		$04
		cNote		cnE5, $0A
		cNote		cnRst, $0A
		cVolFM		$0D
		cNote		cnG5, $0A
		cNote		cnRst, $02
		cVolFM		$0A
		cNote		cnG5, $0A
		cNote		cnRst, $02
		cVolFM		$07
		cNote		cnG5, $0A
		cNote		cnRst, $02
		cVolFM		$04
		cNote		cnG5, $0A
		cNote		cnRst, $0A
		cVolFM		$0D
		cNote		cnB5, $0A
		cNote		cnRst, $02
		cVolFM		$0A
		cNote		cnB5, $0A
		cNote		cnRst, $02
		cVolFM		$07
		cNote		cnB5, $0A
		cNote		cnRst, $02
		cVolFM		$04
		cNote		cnB5, $0A
		cNote		cnRst, $0A
		cVolFM		$0D
		cNote		cnD6, $0A
		cNote		cnRst, $02
		cVolFM		$0A
		cNote		cnD6, $0A
		cNote		cnRst, $02
		cVolFM		$07
		cNote		cnD6, $0A
		cNote		cnRst, $02
		cVolFM		$04
		cNote		cnD6, $0A
		cNote		cnRst, $0A
		cVolFM		$0D
		cNote		cnFs6, $0A
		cNote		cnRst, $02
		cVolFM		$0A
		cNote		cnFs6, $0A
		cNote		cnRst, $02
		cVolFM		$07
		cNote		cnFs6, $0A
		cNote		cnRst, $02
		cVolFM		$04
		cNote		cnFs6, $0A
		cNote		cnRst, $0A
		cVolFM		$0D
		cNote		cnA6, $0A
		cNote		cnRst, $02
		cVolFM		$0A
		cNote		cnA6, $0A
		cNote		cnRst, $02
		cVolFM		$07
		cNote		cnA6, $0A
		cNote		cnRst, $02
		cVolFM		$04
		cNote		cnA6, $0A
		cNote		cnRst, $0A
	cLoopEnd
	cStop

Song07_FM5:
	cNote		cnRst, $10
	cLoopStart
		cInsFM		patch7F
		cVolFM		$0A
		cRelease	$01
		cPan		cpLeft
		cVibrato	$02, $0A
		cLoopCnt	$03
			cNoteShift	$00, $00, $0C
			cNote		cnA0, $07
			cNote		cnRst
			cNote		cnA0
			cNote		cnRst
			cNote		cnA1
			cNote		cnRst
			cNote		cnA0
			cNote		cnG1
			cNote		cnRst
			cNote		cnA0
			cNote		cnE1
			cNote		cnRst
			cNote		cnC1
			cNote		cnRst
			cNote		cnD1
			cNote		cnRst
		cLoopCntEnd
		cLoopCnt	$03
			cNote		cnD1, $07
			cNote		cnRst
			cNote		cnD1
			cNote		cnRst
			cNote		cnD2
			cNote		cnRst
			cNote		cnD1
			cNote		cnC2
			cNote		cnRst
			cNote		cnD1
			cNote		cnA1
			cNote		cnRst
			cNote		cnF1
			cNote		cnRst
			cNote		cnG1
			cNote		cnRst
		cLoopCntEnd
		cLoopCnt	$03
			cNote		cnA0, $07
			cNote		cnRst
			cNote		cnA0
			cNote		cnRst
			cNote		cnA1
			cNote		cnRst
			cNote		cnA0
			cNote		cnG1
			cNote		cnRst
			cNote		cnA0
			cNote		cnE1
			cNote		cnRst
			cNote		cnC1
			cNote		cnRst
			cNote		cnD1
			cNote		cnRst
		cLoopCntEnd
		cLoopCnt	$07
			cNote		cnA0, $07
		cLoopCntEnd
		cLoopCnt	$07
			cNote		cnC1, $07
		cLoopCntEnd
		cLoopCnt	$07
			cNote		cnE1, $07
		cLoopCntEnd
		cLoopCnt	$07
			cNote		cnG1, $07
		cLoopCntEnd
		cLoopCnt	$07
			cNote		cnB1, $07
		cLoopCntEnd
		cLoopCnt	$07
			cNote		cnD2, $07
		cLoopCntEnd
		cLoopCnt	$07
			cNote		cnFs2, $07
		cLoopCntEnd
		cSlide		$05
		cLoopCnt	$03
			cNote		cnA2, $07
			cSlideStop
			cNote		cnA2, $07
		cLoopCntEnd
	cLoopEnd
	cStop

Song07_FM4:
	cNote		cnRst, $0C
	cLoopStart
		cRelease	$01
		cVibrato	$02, $0A
		cPan		cpCenter
		cNoteShift	$00, $00, $00
		cPan		cpCenter
		cVolFM		$00
		cNote		cnRst, $70
		cNote		cnRst
		cNote		cnRst
		cNote		cnRst
		cNote		cnRst
		cNote		cnRst
		cNote		cnRst
		cNote		cnRst
		cLoopCnt	$01
			cInsFM		patch6F
			cVolFM		$09
			cNote		cnA3, $00
			cSlide		$70
			cNote		cnA4, $09
			cNote		cnRst, $05
			cNote		cnC5, $09
			cNote		cnRst, $13
			cNote		cnG4, $07
			cNote		cnRst
			cNote		cnAs4
			cNote		cnAs4
			cNote		cnRst, $23
			cNote		cnD4, $07
			cNote		cnA4, $09
			cNote		cnRst, $05
			cNote		cnC5, $09
			cNote		cnRst, $59
			cSlideStop
		cLoopCntEnd
		cInsFM		patch76
		cVolFM		$0B
		cNote		cnA4, $0A
		cNote		cnRst, $2E
		cNote		cnC5, $0A
		cNote		cnRst, $2E
		cNote		cnE5, $0A
		cNote		cnRst, $2D
		cNote		cnG5, $0B
		cNote		cnRst, $2E
		cNote		cnB5, $0A
		cNote		cnRst, $2E
		cNote		cnD6, $0A
		cNote		cnRst, $2E
		cNote		cnFs6, $0A
		cNote		cnRst, $2E
		cNote		cnA6, $0A
		cNote		cnRst, $2E
	cLoopEnd
	cStop

Song07_FM3:
	cLoopStart
		cRelease	$01
		cVibrato	$02, $0A
		cPan		cpLeft
		cNoteShift	$00, $00, $00
		cPan		cpRight
		cNote		cnRst, $70
		cNote		cnRst
		cNote		cnRst
		cNote		cnRst
		cInsFM		patch6D
		cVolFM		$0D
		cNote		cnD3, $07
		cVolFM		$09
		cNote		cnD3, $07
		cVolFM		$0D
		cNote		cnF3, $07
		cVolFM		$09
		cNote		cnF3, $07
		cNote		cnRst, $0E
		cVolFM		$0D
		cNote		cnC3, $07
		cVolFM		$09
		cNote		cnC3, $07
		cVolFM		$0D
		cNote		cnDs3, $07
		cNote		cnDs3
		cVolFM		$09
		cNote		cnDs3, $07
		cNote		cnRst, $1C
		cVolFM		$0D
		cNote		cnG2, $07
		cNote		cnD3
		cVolFM		$09
		cNote		cnD3, $07
		cVolFM		$0D
		cNote		cnF3, $07
		cVolFM		$09
		cNote		cnF3, $07
		cNote		cnRst, $54
		cVolFM		$0D
		cNote		cnD3, $07
		cVolFM		$09
		cNote		cnD3, $07
		cVolFM		$0D
		cNote		cnF3, $07
		cVolFM		$09
		cNote		cnF3, $07
		cNote		cnRst, $0E
		cVolFM		$0D
		cNote		cnC3, $07
		cVolFM		$09
		cNote		cnC3, $07
		cVolFM		$0D
		cNote		cnDs3, $07
		cNote		cnDs3
		cVolFM		$09
		cNote		cnDs3, $07
		cNote		cnRst, $1C
		cVolFM		$0D
		cNote		cnG2, $07
		cNote		cnD3
		cVolFM		$09
		cNote		cnD3, $07
		cVolFM		$0D
		cNote		cnF3, $07
		cVolFM		$09
		cNote		cnF3, $07
		cNote		cnRst, $54
		cVolFM		$0D
		cNote		cnA2, $07
		cVolFM		$09
		cNote		cnA2, $07
		cVolFM		$0D
		cNote		cnC3, $07
		cVolFM		$09
		cNote		cnC3, $07
		cNote		cnRst, $0E
		cVolFM		$0D
		cNote		cnG2, $07
		cVolFM		$09
		cNote		cnG2, $07
		cVolFM		$0D
		cNote		cnAs2, $07
		cNote		cnAs2
		cVolFM		$09
		cNote		cnAs2, $07
		cNote		cnRst, $1C
		cVolFM		$0D
		cNote		cnD2, $07
		cNote		cnA2
		cVolFM		$09
		cNote		cnA2, $07
		cVolFM		$0D
		cNote		cnC3, $07
		cVolFM		$09
		cNote		cnC3, $07
		cNote		cnRst, $54
		cVolFM		$0D
		cNote		cnA2, $07
		cVolFM		$09
		cNote		cnA2, $07
		cVolFM		$0D
		cNote		cnC3, $07
		cVolFM		$09
		cNote		cnC3, $07
		cNote		cnRst, $0E
		cVolFM		$0D
		cNote		cnG2, $07
		cVolFM		$09
		cNote		cnG2, $07
		cVolFM		$0D
		cNote		cnAs2, $07
		cNote		cnAs2
		cVolFM		$09
		cNote		cnAs2, $07
		cNote		cnRst, $1C
		cVolFM		$0D
		cNote		cnD2, $07
		cNote		cnA2
		cVolFM		$09
		cNote		cnA2, $07
		cVolFM		$0D
		cNote		cnC3, $07
		cVolFM		$09
		cNote		cnC3, $07
		cNote		cnRst, $54
		cInsFM		patch76
		cVolFM		$0C
		cNote		cnA3, $0A
		cNote		cnRst, $02
		cVolFM		$09
		cNote		cnA3, $0A
		cNote		cnRst, $02
		cVolFM		$06
		cNote		cnA3, $0A
		cNote		cnRst, $02
		cVolFM		$03
		cNote		cnA3, $0A
		cNote		cnRst, $0A
		cVolFM		$0C
		cNote		cnC4, $0A
		cNote		cnRst, $02
		cVolFM		$09
		cNote		cnC4, $0A
		cNote		cnRst, $02
		cVolFM		$06
		cNote		cnC4, $0A
		cNote		cnRst, $02
		cVolFM		$03
		cNote		cnC4, $0A
		cNote		cnRst, $0A
		cVolFM		$0C
		cNote		cnE4, $0A
		cNote		cnRst, $02
		cVolFM		$09
		cNote		cnE4, $0A
		cNote		cnRst, $02
		cVolFM		$06
		cNote		cnE4, $0A
		cNote		cnRst, $02
		cVolFM		$03
		cNote		cnE4, $0A
		cNote		cnRst, $0A
		cVolFM		$0C
		cNote		cnG4, $0A
		cNote		cnRst, $02
		cVolFM		$09
		cNote		cnG4, $0A
		cNote		cnRst, $02
		cVolFM		$06
		cNote		cnG4, $0A
		cNote		cnRst, $02
		cVolFM		$03
		cNote		cnG4, $0A
		cNote		cnRst, $0A
		cVolFM		$0C
		cNote		cnB4, $0A
		cNote		cnRst, $02
		cVolFM		$09
		cNote		cnB4, $0A
		cNote		cnRst, $02
		cVolFM		$06
		cNote		cnB4, $0A
		cNote		cnRst, $02
		cVolFM		$03
		cNote		cnB4, $0A
		cNote		cnRst, $0A
		cVolFM		$0C
		cNote		cnD5, $0A
		cNote		cnRst, $02
		cVolFM		$09
		cNote		cnD5, $0A
		cNote		cnRst, $02
		cVolFM		$06
		cNote		cnD5, $0A
		cNote		cnRst, $02
		cVolFM		$03
		cNote		cnD5, $0A
		cNote		cnRst, $0A
		cVolFM		$0C
		cNote		cnFs5, $0A
		cNote		cnRst, $02
		cVolFM		$09
		cNote		cnFs5, $0A
		cNote		cnRst, $02
		cVolFM		$06
		cNote		cnFs5, $0A
		cNote		cnRst, $02
		cVolFM		$03
		cNote		cnFs5, $0A
		cNote		cnRst, $0A
		cVolFM		$0C
		cNote		cnA5, $0A
		cNote		cnRst, $02
		cVolFM		$09
		cNote		cnA5, $0A
		cNote		cnRst, $02
		cVolFM		$06
		cNote		cnA5, $0A
		cNote		cnRst, $02
		cVolFM		$03
		cNote		cnA5, $0A
		cNote		cnRst, $0A
	cLoopEnd
	cStop

Song07_DAC:
	cLoopStart
		cPan		cpLeft
		cNote		cnD0, $1C
		cPan		cpCenter
		cNote		cnDs0, $15
		cPan		cpRight
		cNote		cnE0, $07
		cPan		cpCenter
		cNote		cnC0, $0E
		cNote		cnC0
		cNote		cnCs0, $1C
	cLoopEnd
	cStop

Song07_PSG1:
	cStop

Song07_PSG2:
	cStop

Song07_PSG3:
	cStop

Song07_Noise:
	cLoopStart
		cInsVolPSG	$0F, $0E
		cNote		cnG0, $07
		cInsVolPSG	$0F, $0B
		cNote		cnG0, $07
		cNote		cnG0
		cNote		cnG0
	cLoopEnd
	cStop
