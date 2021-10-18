Song01_Start:
	cType		ctMusic
	cFadeOut	$0000
	cTempo		$C4
	cChannel	Song01_FM1
	cChannel	Song01_FM2
	cChannel	Song01_FM3
	cChannel	Song01_FM4
	cChannel	Song01_FM5
	cChannel	Song01_DAC
	cChannel	Song01_PSG1
	cChannel	Song01_PSG2
	cChannel	Song01_PSG3
	cChannel	Song01_Noise

Song01_FM1:
	cLoopStart
		cInsFM		patch07
		cVolFM		$0D
		cRelease	$01
		cVibrato	$02, $0A
		cPan		cpCenter
		cNoteShift	$00, $00, $00
		cLoopCnt	$0F
			cNote		cnRst, $70
		cLoopCntEnd
		cSlideStop
		cNote		cnB1, $00
		cSlide		$60
		cNote		cnB2, $38
		cSlideStop
		cNote		cnD2, $00
		cSlide		$60
		cNote		cnD3, $38
		cSlideStop
		cNote		cnFs2, $00
		cSlide		$60
		cNote		cnFs3, $38
		cSlideStop
		cNote		cnA2, $00
		cSlide		$60
		cNote		cnA3, $38
		cSlideStop
		cNote		cnCs4, $00
		cSlide		$60
		cNote		cnCs4, $38
		cSlideStop
		cNote		cnE4, $00
		cSlide		$60
		cNote		cnE4, $38
		cSlideStop
		cNote		cnGs4, $00
		cSlide		$60
		cNote		cnGs4, $38
		cSlideStop
		cNote		cnB3, $00
		cSlide		$60
		cNote		cnB4, $38
		cSlideStop
		cNote		cnRst, $70
		cNote		cnRst
		cNote		cnRst
		cNote		cnRst
		cNote		cnRst
		cNote		cnRst, $38
		cSlideStop
		cNote		cnB2, $00
		cSlide		$60
		cNote		cnB3, $15
		cSlide		$50
		cNote		cnC4
		cNote		cnA3, $0E
		cNote		cnB3, $31
		cNote		cnRst, $AF
		cNote		cnRst, $70
		cNote		cnRst, $38
		cSlideStop
		cNote		cnE3, $00
		cSlide		$60
		cNote		cnE4, $15
		cSlide		$50
		cNote		cnF4
		cNote		cnD4, $0E
		cNote		cnE4, $31
		cNote		cnRst, $AF
		cNote		cnRst, $70
		cNote		cnRst, $38
		cSlideStop
		cNote		cnB2, $00
		cSlide		$60
		cNote		cnB3, $15
		cSlide		$50
		cNote		cnC4
		cNote		cnA3, $0E
		cNote		cnB3, $31
		cNote		cnRst, $AF
		cLoopCnt	$02
			cSlideStop
			cNote		cnB2, $00
			cSlide		$60
			cNote		cnB3, $13
			cNote		cnFs4, $0E
			cNote		cnRst
			cNote		cnB3, $07
			cNote		cnRst, $03
			cNote		cnF4, $09
			cNote		cnE4
			cNote		cnD4
			cNote		cnB3, $13
			cNote		cnRst, $09
		cLoopCntEnd
		cSlideStop
		cNote		cnA2, $00
		cSlide		$60
		cNote		cnA3, $13
		cNote		cnFs3, $09
		cNote		cnA3, $13
		cNote		cnB3, $2A
		cNote		cnRst, $17
	cLoopEnd
	cStop

Song01_FM2:
	cLoopStart
		cInsFM		patch1F
		cVolFM		$09
		cRelease	$05
		cVibrato	$02, $0A
		cLoopCnt	$07
			cNote		cnB4, $07
			cNote		cnB4
			cNote		cnB4
			cNote		cnB4
			cNote		cnB4
			cNote		cnRst, $0E
			cNote		cnB4, $07
			cNote		cnB4
			cNote		cnB4
			cNote		cnB4
			cNote		cnB4
			cNote		cnRst
			cNote		cnB4
			cNote		cnB4
			cNote		cnB4
		cLoopCntEnd
		cLoopCnt	$03
			cNote		cnD5, $07
			cNote		cnD5
			cNote		cnD5
			cNote		cnD5
			cNote		cnD5
			cNote		cnRst, $0E
			cNote		cnD5, $07
			cNote		cnD5
			cNote		cnD5
			cNote		cnD5
			cNote		cnD5
			cNote		cnRst, $0E
			cNote		cnD5, $07
			cNote		cnD5
		cLoopCntEnd
		cLoopCnt	$04
			cNote		cnB4, $07
			cNote		cnB4
			cNote		cnB4
			cNote		cnB4
			cNote		cnB4
			cNote		cnRst, $0E
			cNote		cnB4, $07
			cNote		cnB4
			cNote		cnB4
			cNote		cnB4
			cNote		cnB4
			cNote		cnRst
			cNote		cnB4
			cNote		cnB4
			cNote		cnB4
		cLoopCntEnd
		cNote		cnB3, $07
		cNote		cnB3
		cNote		cnB3
		cNote		cnB3
		cNote		cnB3
		cNote		cnRst, $0E
		cNote		cnB3, $07
		cNote		cnB3
		cNote		cnB3
		cNote		cnB3
		cNote		cnB3
		cNote		cnRst, $0E
		cNote		cnB3, $07
		cNote		cnB3
		cVolFM		$0B
		cNote		cnB5
		cNote		cnB5
		cNote		cnB5
		cNote		cnB5
		cNote		cnB5
		cNote		cnRst, $0E
		cNote		cnB5, $07
		cNote		cnB5
		cNote		cnB5
		cNote		cnB5
		cNote		cnB5
		cNote		cnRst, $0E
		cNote		cnB5, $07
		cNote		cnB5
		cNote		cnB6
		cNote		cnB6
		cNote		cnB6
		cNote		cnB6
		cNote		cnB6
		cNote		cnRst, $0E
		cNote		cnB6, $07
		cNote		cnB6
		cNote		cnB6
		cNote		cnB6
		cNote		cnB6
		cNote		cnRst, $0E
		cNote		cnB6, $07
		cNote		cnB6
		cLoopCnt	$07
			cNote		cnB4, $07
			cNote		cnB4
			cNote		cnB4
			cNote		cnB4
			cNote		cnB4
			cNote		cnRst, $0E
			cNote		cnB4, $07
			cNote		cnB4
			cNote		cnB4
			cNote		cnB4
			cNote		cnB4
			cNote		cnRst
			cNote		cnB4
			cNote		cnB4
			cNote		cnB4
		cLoopCntEnd
		cLoopCnt	$03
			cNote		cnD5, $07
			cNote		cnD5
			cNote		cnD5
			cNote		cnD5
			cNote		cnD5
			cNote		cnRst, $0E
			cNote		cnD5, $07
			cNote		cnD5
			cNote		cnD5
			cNote		cnD5
			cNote		cnD5
			cNote		cnRst, $0E
			cNote		cnD5, $07
			cNote		cnD5
		cLoopCntEnd
		cLoopCnt	$07
			cNote		cnB4, $07
			cNote		cnB4
			cNote		cnB4
			cNote		cnB4
			cNote		cnB4
			cNote		cnRst, $0E
			cNote		cnB4, $07
			cNote		cnB4
			cNote		cnB4
			cNote		cnB4
			cNote		cnB4
			cNote		cnRst
			cNote		cnB4
			cNote		cnB4
			cNote		cnB4
		cLoopCntEnd
	cLoopEnd
	cStop

Song01_FM3:
	cLoopStart
		cInsFM		patch0E
		cVolFM		$0C
		cRelease	$01
		cVibrato	$02, $0A
		cPan		cpCenter
		cNoteShift	$00, $00, $00
		cNote		cnB0, $09
		cNote		cnRst, $05
		cNote		cnD1, $09
		cNote		cnRst, $52
		cNote		cnE0, $07
		cNote		cnB0, $09
		cNote		cnRst, $05
		cNote		cnD1, $09
		cNote		cnRst, $59
		cNote		cnB0, $09
		cNote		cnRst, $05
		cNote		cnD1, $09
		cNote		cnRst, $52
		cNote		cnE0, $07
		cNote		cnB0, $09
		cNote		cnRst, $05
		cNote		cnD1, $09
		cNote		cnRst, $59
		cNote		cnB0, $09
		cNote		cnRst, $05
		cNote		cnD1, $09
		cNote		cnRst, $13
		cNote		cnA0, $07
		cNote		cnRst
		cNote		cnC1, $04
		cNote		cnRst, $03
		cNote		cnC1, $07
		cNote		cnRst, $23
		cNote		cnE0, $07
		cNote		cnB0, $09
		cNote		cnRst, $05
		cNote		cnD1, $09
		cNote		cnRst, $59
		cNote		cnB0, $09
		cNote		cnRst, $05
		cNote		cnD1, $09
		cNote		cnRst, $13
		cNote		cnA0, $07
		cNote		cnRst
		cNote		cnC1, $04
		cNote		cnRst, $03
		cNote		cnC1, $07
		cNote		cnRst, $23
		cNote		cnE0, $07
		cNote		cnB0, $09
		cNote		cnRst, $05
		cNote		cnD1, $09
		cNote		cnRst, $59
		cNote		cnE1, $09
		cNote		cnRst, $05
		cNote		cnG1, $09
		cNote		cnRst, $13
		cNote		cnD1, $07
		cNote		cnRst
		cNote		cnF1, $04
		cNote		cnRst, $03
		cNote		cnF1, $07
		cNote		cnRst, $23
		cNote		cnA0, $07
		cNote		cnE1, $09
		cNote		cnRst, $05
		cNote		cnG1, $09
		cNote		cnRst, $59
		cNote		cnE1, $09
		cNote		cnRst, $05
		cNote		cnG1, $09
		cNote		cnRst, $13
		cNote		cnD1, $07
		cNote		cnRst
		cNote		cnF1, $04
		cNote		cnRst, $03
		cNote		cnF1, $07
		cNote		cnRst, $23
		cNote		cnA0, $07
		cNote		cnE1, $09
		cNote		cnRst, $05
		cNote		cnG1, $09
		cNote		cnRst, $59
		cNote		cnB0, $09
		cNote		cnRst, $05
		cNote		cnD1, $09
		cNote		cnRst, $13
		cNote		cnA0, $07
		cNote		cnRst
		cNote		cnC1, $04
		cNote		cnRst, $03
		cNote		cnC1, $07
		cNote		cnRst, $23
		cNote		cnE0, $07
		cNote		cnB0, $09
		cNote		cnRst, $05
		cNote		cnD1, $09
		cNote		cnRst, $59
		cNote		cnB0, $09
		cNote		cnRst, $05
		cNote		cnD1, $09
		cNote		cnRst, $13
		cNote		cnA0, $07
		cNote		cnRst
		cNote		cnC1, $04
		cNote		cnRst, $03
		cNote		cnC1, $07
		cNote		cnRst, $23
		cNote		cnE0, $07
		cNote		cnB0, $09
		cNote		cnRst, $05
		cNote		cnD1, $09
		cNote		cnRst, $59
		cNote		cnRst, $70
		cNote		cnRst
		cNote		cnRst
		cNote		cnRst
		cNote		cnB0, $09
		cNote		cnRst, $05
		cNote		cnD1, $09
		cNote		cnRst, $52
		cNote		cnE0, $07
		cNote		cnB0, $09
		cNote		cnRst, $05
		cNote		cnD1, $09
		cNote		cnRst, $59
		cNote		cnB0, $09
		cNote		cnRst, $05
		cNote		cnD1, $09
		cNote		cnRst, $52
		cNote		cnE0, $07
		cNote		cnB0, $09
		cNote		cnRst, $05
		cNote		cnD1, $09
		cNote		cnRst, $59
		cNote		cnB0, $09
		cNote		cnRst, $05
		cNote		cnD1, $09
		cNote		cnRst, $13
		cNote		cnA0, $07
		cNote		cnRst
		cNote		cnC1, $04
		cNote		cnRst, $03
		cNote		cnC1, $07
		cNote		cnRst, $23
		cNote		cnE0, $07
		cNote		cnB0, $09
		cNote		cnRst, $05
		cNote		cnD1, $09
		cNote		cnRst, $59
		cNote		cnB0, $09
		cNote		cnRst, $05
		cNote		cnD1, $09
		cNote		cnRst, $13
		cNote		cnA0, $07
		cNote		cnRst
		cNote		cnC1, $04
		cNote		cnRst, $03
		cNote		cnC1, $07
		cNote		cnRst, $23
		cNote		cnE0, $07
		cNote		cnB0, $09
		cNote		cnRst, $05
		cNote		cnD1, $09
		cNote		cnRst, $59
		cNote		cnE1, $09
		cNote		cnRst, $05
		cNote		cnG1, $09
		cNote		cnRst, $13
		cNote		cnD1, $07
		cNote		cnRst
		cNote		cnF1, $04
		cNote		cnRst, $03
		cNote		cnF1, $07
		cNote		cnRst, $23
		cNote		cnA0, $07
		cNote		cnE1, $09
		cNote		cnRst, $05
		cNote		cnG1, $09
		cNote		cnRst, $59
		cNote		cnE1, $09
		cNote		cnRst, $05
		cNote		cnG1, $09
		cNote		cnRst, $13
		cNote		cnD1, $07
		cNote		cnRst
		cNote		cnF1, $04
		cNote		cnRst, $03
		cNote		cnF1, $07
		cNote		cnRst, $23
		cNote		cnA0, $07
		cNote		cnE1, $09
		cNote		cnRst, $05
		cNote		cnG1, $09
		cNote		cnRst, $59
		cNote		cnB0, $09
		cNote		cnRst, $05
		cNote		cnD1, $09
		cNote		cnRst, $13
		cNote		cnA0, $07
		cNote		cnRst
		cNote		cnC1, $04
		cNote		cnRst, $03
		cNote		cnC1, $07
		cNote		cnRst, $23
		cNote		cnE0, $07
		cNote		cnB0, $09
		cNote		cnRst, $05
		cNote		cnD1, $09
		cNote		cnRst, $59
		cNote		cnB0, $09
		cNote		cnRst, $05
		cNote		cnD1, $09
		cNote		cnRst, $13
		cNote		cnA0, $07
		cNote		cnRst
		cNote		cnC1, $04
		cNote		cnRst, $03
		cNote		cnC1, $07
		cNote		cnRst, $23
		cNote		cnE0, $07
		cNote		cnB0, $09
		cNote		cnRst, $05
		cNote		cnD1, $09
		cNote		cnRst, $59
		cNote		cnB1, $09
		cNote		cnRst, $05
		cNote		cnD2, $09
		cNote		cnRst, $52
		cNote		cnE1, $07
		cNote		cnB1, $09
		cNote		cnRst, $05
		cNote		cnD2, $09
		cNote		cnRst, $59
		cNote		cnB1, $09
		cNote		cnRst, $05
		cNote		cnD2, $09
		cNote		cnRst, $52
		cNote		cnE1, $07
		cNote		cnB1, $09
		cNote		cnRst, $05
		cNote		cnD2, $09
		cNote		cnRst, $59
	cLoopEnd
	cStop

Song01_FM4:
	cLoopStart
		cInsFM		patch25
		cVolFM		$0D
		cRelease	$01
		cVibrato	$02, $0A
		cPan		cpLeft
		cNoteShift	$00, $00, $00
		cNote		cnB3, $07
		cNote		cnRst
		cNote		cnD4
		cNote		cnRst, $54
		cNote		cnE3, $07
		cNote		cnB3
		cNote		cnRst
		cNote		cnD4
		cNote		cnRst, $5B
		cNote		cnB3, $07
		cNote		cnRst
		cNote		cnD4
		cNote		cnRst, $54
		cNote		cnE3, $07
		cNote		cnB3
		cNote		cnRst
		cNote		cnD4
		cNote		cnRst, $5B
		cNote		cnB3, $07
		cNote		cnRst
		cNote		cnD4
		cNote		cnRst, $15
		cNote		cnA3, $07
		cNote		cnRst
		cNote		cnC4
		cNote		cnC4
		cNote		cnRst, $23
		cNote		cnE3, $07
		cNote		cnB3
		cNote		cnRst
		cNote		cnD4
		cNote		cnRst, $5B
		cNote		cnB3, $07
		cNote		cnRst
		cNote		cnD4
		cNote		cnRst, $15
		cNote		cnA3, $07
		cNote		cnRst
		cNote		cnC4
		cNote		cnC4
		cNote		cnRst, $23
		cNote		cnE3, $07
		cNote		cnB3
		cNote		cnRst
		cNote		cnD4
		cNote		cnRst, $5B
		cNote		cnE4, $07
		cNote		cnRst
		cNote		cnG4
		cNote		cnRst, $15
		cNote		cnD4, $07
		cNote		cnRst
		cNote		cnF4
		cNote		cnF4
		cNote		cnRst, $23
		cNote		cnA3, $07
		cNote		cnE4
		cNote		cnRst
		cNote		cnG4
		cNote		cnRst, $5B
		cNote		cnE4, $07
		cNote		cnRst
		cNote		cnG4
		cNote		cnRst, $15
		cNote		cnD4, $07
		cNote		cnRst
		cNote		cnF4
		cNote		cnF4
		cNote		cnRst, $23
		cNote		cnA3, $07
		cNote		cnE4
		cNote		cnRst
		cNote		cnG4
		cNote		cnRst, $5B
		cNote		cnB3, $07
		cNote		cnRst
		cNote		cnD4
		cNote		cnRst, $15
		cNote		cnA3, $07
		cNote		cnRst
		cNote		cnC4
		cNote		cnC4
		cNote		cnRst, $23
		cNote		cnE3, $07
		cNote		cnB3
		cNote		cnRst
		cNote		cnD4
		cNote		cnRst, $5B
		cNote		cnB3, $07
		cNote		cnRst
		cNote		cnD4
		cNote		cnRst, $15
		cNote		cnA3, $07
		cNote		cnRst
		cNote		cnC4
		cNote		cnC4
		cNote		cnRst, $23
		cNote		cnE3, $07
		cNote		cnB3
		cNote		cnRst
		cNote		cnD4
		cNote		cnRst, $5B
		cInsFM		patch07
		cVolFM		$0C
		cSlideStop
		cNote		cnB0, $00
		cSlide		$60
		cNote		cnB1, $38
		cNote		cnD2
		cNote		cnFs2
		cNote		cnA2
		cNote		cnCs3
		cNote		cnE3
		cNote		cnGs3
		cNote		cnB3
		cSlideStop
		cInsFM		patch25
		cVolFM		$0D
		cNote		cnB3, $07
		cNote		cnRst
		cNote		cnD4
		cNote		cnRst, $54
		cNote		cnE3, $07
		cNote		cnB3
		cNote		cnRst
		cNote		cnD4
		cNote		cnRst, $5B
		cNote		cnB3, $07
		cNote		cnRst
		cNote		cnD4
		cNote		cnRst, $54
		cNote		cnE3, $07
		cNote		cnB3
		cNote		cnRst
		cNote		cnD4
		cNote		cnRst, $5B
		cNote		cnB3, $07
		cNote		cnRst
		cNote		cnD4
		cNote		cnRst, $15
		cNote		cnA3, $07
		cNote		cnRst
		cNote		cnC4
		cNote		cnC4
		cNote		cnRst, $23
		cNote		cnE3, $07
		cNote		cnB3
		cNote		cnRst
		cNote		cnD4
		cNote		cnRst, $5B
		cNote		cnB3, $07
		cNote		cnRst
		cNote		cnD4
		cNote		cnRst, $15
		cNote		cnA3, $07
		cNote		cnRst
		cNote		cnC4
		cNote		cnC4
		cNote		cnRst, $23
		cNote		cnE3, $07
		cNote		cnB3
		cNote		cnRst
		cNote		cnD4
		cNote		cnRst, $5B
		cNote		cnE4, $07
		cNote		cnRst
		cNote		cnG4
		cNote		cnRst, $15
		cNote		cnD4, $07
		cNote		cnRst
		cNote		cnF4
		cNote		cnF4
		cNote		cnRst, $23
		cNote		cnA3, $07
		cNote		cnE4
		cNote		cnRst
		cNote		cnG4
		cNote		cnRst, $5B
		cNote		cnE4, $07
		cNote		cnRst
		cNote		cnG4
		cNote		cnRst, $15
		cNote		cnD4, $07
		cNote		cnRst
		cNote		cnF4
		cNote		cnF4
		cNote		cnRst, $23
		cNote		cnA3, $07
		cNote		cnE4
		cNote		cnRst
		cNote		cnG4
		cNote		cnRst, $5B
		cNote		cnB3, $07
		cNote		cnRst
		cNote		cnD4
		cNote		cnRst, $15
		cNote		cnA3, $07
		cNote		cnRst
		cNote		cnC4
		cNote		cnC4
		cNote		cnRst, $23
		cNote		cnE3, $07
		cNote		cnB3
		cNote		cnRst
		cNote		cnD4
		cNote		cnRst, $5B
		cNote		cnB3, $07
		cNote		cnRst
		cNote		cnD4
		cNote		cnRst, $15
		cNote		cnA3, $07
		cNote		cnRst
		cNote		cnC4
		cNote		cnC4
		cNote		cnRst, $23
		cNote		cnE3, $07
		cNote		cnB3
		cNote		cnRst
		cNote		cnD4
		cNote		cnRst, $5B
		cNote		cnB2, $38
		cNote		cnD3
		cNote		cnFs3
		cNote		cnA3
		cNote		cnCs4
		cNote		cnE4
		cNote		cnGs4
		cNote		cnB4
	cLoopEnd
	cStop

Song01_FM5:
	cNote		cnRst, $0E
	cLoopStart
		cInsFM		patch07
		cVolFM		$0B
		cRelease	$01
		cVibrato	$02, $0A
		cPan		cpCenter
		cNoteShift	$00, $03, $00
		cLoopCnt	$0F
			cNote		cnRst, $70
		cLoopCntEnd
		cSlideStop
		cNote		cnB1, $00
		cSlide		$60
		cNote		cnB2, $38
		cSlideStop
		cNote		cnD2, $00
		cSlide		$60
		cNote		cnD3, $38
		cSlideStop
		cNote		cnFs2, $00
		cSlide		$60
		cNote		cnFs3, $38
		cSlideStop
		cNote		cnA2, $00
		cSlide		$60
		cNote		cnA3, $38
		cSlideStop
		cNote		cnCs4, $00
		cSlide		$60
		cNote		cnCs4, $38
		cSlideStop
		cNote		cnE4, $00
		cSlide		$60
		cNote		cnE4, $38
		cSlideStop
		cNote		cnGs4, $00
		cSlide		$60
		cNote		cnGs4, $38
		cSlideStop
		cNote		cnB3, $00
		cSlide		$60
		cNote		cnB4, $38
		cSlideStop
		cNote		cnRst, $70
		cNote		cnRst
		cNote		cnRst
		cNote		cnRst
		cNote		cnRst
		cNote		cnRst, $38
		cSlideStop
		cNote		cnB2, $00
		cSlide		$60
		cNote		cnB3, $15
		cSlide		$50
		cNote		cnC4
		cNote		cnA3, $0E
		cNote		cnB3, $31
		cNote		cnRst, $AF
		cNote		cnRst, $70
		cNote		cnRst, $38
		cSlideStop
		cNote		cnE3, $00
		cSlide		$60
		cNote		cnE4, $15
		cSlide		$50
		cNote		cnF4
		cNote		cnD4, $0E
		cNote		cnE4, $31
		cNote		cnRst, $AF
		cNote		cnRst, $70
		cNote		cnRst, $38
		cSlideStop
		cNote		cnB2, $00
		cSlide		$60
		cNote		cnB3, $15
		cSlide		$50
		cNote		cnC4
		cNote		cnA3, $0E
		cNote		cnB3, $31
		cNote		cnRst, $AF
		cLoopCnt	$02
			cSlideStop
			cNote		cnB2, $00
			cSlide		$60
			cNote		cnB3, $13
			cNote		cnFs4, $0E
			cNote		cnRst
			cNote		cnB3, $07
			cNote		cnRst, $03
			cNote		cnF4, $09
			cNote		cnE4
			cNote		cnD4
			cNote		cnB3, $13
			cNote		cnRst, $09
		cLoopCntEnd
		cSlideStop
		cNote		cnA2, $00
		cSlide		$60
		cNote		cnA3, $13
		cNote		cnFs3, $09
		cNote		cnA3, $13
		cNote		cnB3, $2A
		cNote		cnRst, $17
	cLoopEnd
	cStop

Song01_DAC:
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

Song01_PSG1:
	cInsVolPSG	$00, $00
	cStop

Song01_PSG2:
	cInsVolPSG	$00, $00
	cStop

Song01_PSG3:
	cInsVolPSG	$00, $00
	cStop

Song01_Noise:
	cLoopStart
		cInsVolPSG	$0F, $0E
		cRelease	$01
		cNote		cnG0, $07
		cInsVolPSG	$0F, $0B
		cNote		cnG0
		cNote		cnG0
		cNote		cnG0
	cLoopEnd
	cStop
