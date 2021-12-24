Song1A_Start:
	cType		ctMusic
	cFadeOut	$0000
	cTempo		$C0
	cChannel	Song1A_FM1
	cChannel	Song1A_FM2
	cChannel	Song1A_FM3
	cChannel	Song1A_FM4
	cChannel	Song1A_FM5
	cChannel	Song1A_DAC
	cChannel	Song1A_PSG1
	cChannel	Song1A_PSG2
	cChannel	Song1A_PSG3
	cChannel	Song1A_Noise

Song1A_FM1:
	cInsFM		patch0E
	cVolFM		$0C
	cRelease	$01
	cVibrato	$02, $03
	cPan		cpCenter
	cLoopCnt	$01
		cNote		cnG0, $00
		cSlide		$40
		cVibrato	$02, $0A
		cNote		cnB0, $0C
		cSlideStop
		cNote		cnD1, $0C
		cNote		cnRst, $30
		cNote		cnRst, $18
	cLoopCntEnd
	cNote		cnG0, $00
	cSlide		$40
	cNote		cnB0, $0C
	cSlideStop
	cNote		cnD1, $0B
	cNote		cnRst, $2A
	cNote		cnDs0, $01
	cNote		cnE1, $06
	cNote		cnCs1, $00
	cSlide		$40
	cNote		cnF1, $06
	cSlideStop
	cNote		cnE1
	cNote		cnD1
	cNote		cnF0
	cNote		cnB0, $0C
	cSustain
	cNote		cnD1, $0C
	cRelease	$01
	cSlide		$0A
	cNote		cnG0, $12
	cSlideStop
	cNote		cnRst, $12
	cNote		cnD1, $0C
	cNote		cnDs1
	cNote		cnE1
	cLoopStart
		cVolFM		$0C
		cLoopCnt	$1E
			cVibrato	$02, $0A
			cNote		cnB0, $0C
			cNote		cnB0
			cNote		cnD1, $12
			cNote		cnB0, $06
			cNote		cnRst, $0C
			cNote		cnAs0, $00
			cSlide		$20
			cNote		cnD1, $12
			cSlideStop
			cVibrato	$0E, $05
			cNote		cnE1
		cLoopCntEnd
		cVibrato	$02, $0A
		cNote		cnB0, $0C
		cNote		cnB0
		cNote		cnD1, $12
		cNote		cnB0, $06
		cNote		cnRst, $0C
		cNote		cnAs0, $00
		cSlide		$20
		cNote		cnD1, $12
		cSlideStop
		cVolFM		$0B
		cVibrato	$0E, $05
		cNote		cnE1, $00
		cSlide		$50
		cNote		cnB1, $06
		cSlide		$10
		cNote		cnB0, $0C
		cSlideStop
	cLoopEnd
	cStop

Song1A_FM2:
	cRelease	$01
	cVibrato	$02, $0A
	cPan		cpLeft
	cVolFM		$00
	cNote		cnRst, $60
	cNote		cnRst
	cNote		cnRst
	cNote		cnRst, $3C
	cInsFM		patch12
	cVolFM		$0B
	cNote		cnD3, $0B
	cNote		cnRst, $01
	cNote		cnDs3, $0B
	cNote		cnRst, $01
	cNote		cnE3, $0B
	cNote		cnRst, $01
	cLoopStart
		cInsFM		patch12
		cVolFM		$0A
		cNote		cnE4, $C0
		cNote		cnFs4
		cNote		cnA4
		cNote		cnGs4, $60
		cNote		cnG4
		cLoopCnt	$03
			cInsFM		patch2B
			cVolFM		$0B
			cNote		cnA3, $04
			cNote		cnRst, $0E
			cNote		cnA3, $04
			cNote		cnRst, $0E
			cNote		cnA3, $04
			cNote		cnRst, $0E
			cNote		cnA3, $04
			cNote		cnRst, $0E
			cNote		cnA3, $04
			cNote		cnRst, $0E
			cNote		cnA3, $06
			cNote		cnRst, $0C
			cNote		cnA3, $04
			cNote		cnRst, $0E
			cNote		cnA3, $04
			cNote		cnRst, $0E
			cNote		cnA3, $08
			cNote		cnRst, $0A
			cVibrato	$0E, $02
			cNote		cnAs3, $12
			cVibrato	$02, $0A
			cNote		cnB3, $0C
		cLoopCntEnd
	cLoopEnd
	cStop

Song1A_FM3:
	cInsFM		patch25
	cVolFM		$0E
	cRelease	$01
	cVibrato	$02, $03
	cPan		cpCenter
	cLoopCnt	$01
		cVibrato	$02, $0A
		cNote		cnG1, $00
		cSlide		$40
		cNote		cnB1, $0C
		cSlideStop
		cNote		cnD2, $0C
		cNote		cnRst, $30
		cNote		cnRst, $18
	cLoopCntEnd
	cNote		cnG1, $00
	cSlide		$40
	cNote		cnB1, $0C
	cSlideStop
	cNote		cnD2, $0B
	cNote		cnRst, $2A
	cNote		cnDs1, $01
	cNote		cnE2, $06
	cNote		cnCs2, $00
	cSlide		$40
	cNote		cnF2, $06
	cSlideStop
	cNote		cnE2
	cNote		cnD2
	cNote		cnF1
	cNote		cnB1, $0C
	cSustain
	cNote		cnD2
	cSlide		$0A
	cRelease	$01
	cNote		cnG1, $12
	cSlideStop
	cNote		cnRst, $12
	cNote		cnD2, $0C
	cNote		cnDs2
	cNote		cnE2
	cLoopStart
		cVolFM		$0E
		cLoopCnt	$1E
			cVibrato	$02, $0A
			cNote		cnB1, $0C
			cNote		cnB1
			cNote		cnD2, $12
			cNote		cnB1, $06
			cNote		cnRst, $0C
			cNote		cnAs1, $00
			cSlide		$20
			cNote		cnD2, $12
			cSlideStop
			cVibrato	$0E, $05
			cNote		cnE2
		cLoopCntEnd
		cVibrato	$02, $0A
		cNote		cnB1, $0C
		cNote		cnB1
		cNote		cnD2, $12
		cNote		cnB1, $06
		cNote		cnRst, $0C
		cNote		cnAs1, $00
		cSlide		$20
		cNote		cnD2, $12
		cSlideStop
		cVibrato	$0E, $05
		cVolFM		$0C
		cNote		cnE2, $00
		cSlide		$50
		cNote		cnB2, $06
		cSlide		$10
		cNote		cnB1, $0C
		cSlideStop
	cLoopEnd
	cStop

Song1A_FM4:
	cRelease	$01
	cVibrato	$02, $0A
	cPan		cpRight
	cVolFM		$00
	cNote		cnRst, $60
	cNote		cnRst
	cNote		cnRst
	cNote		cnRst, $3C
	cInsFM		patch12
	cVolFM		$0B
	cNote		cnA3, $0B
	cNote		cnRst, $01
	cNote		cnAs3, $0B
	cNote		cnRst, $01
	cNote		cnB3, $0B
	cNote		cnRst, $01
	cLoopStart
		cInsFM		patch12
		cVolFM		$0A
		cNote		cnB3, $C0
		cNote		cnCs4
		cNote		cnE4
		cNote		cnDs4, $60
		cNote		cnD4
		cLoopCnt	$03
			cInsFM		patch2B
			cVolFM		$0B
			cNote		cnE3, $04
			cNote		cnRst, $0E
			cNote		cnE3, $04
			cNote		cnRst, $0E
			cNote		cnE3, $04
			cNote		cnRst, $0E
			cNote		cnE3, $04
			cNote		cnRst, $0E
			cNote		cnE3, $04
			cNote		cnRst, $0E
			cNote		cnE3, $06
			cNote		cnRst, $0C
			cNote		cnE3, $04
			cNote		cnRst, $0E
			cNote		cnE3, $04
			cNote		cnRst, $0E
			cNote		cnE3, $08
			cNote		cnRst, $0A
			cVibrato	$0E, $02
			cNote		cnF3, $12
			cVibrato	$02, $0A
			cNote		cnFs3, $0C
		cLoopCntEnd
	cLoopEnd
	cStop

Song1A_FM5:
	cNote		cnRst, $10
	cRelease	$01
	cVibrato	$02, $0A
	cNoteShift	$00, $07, $00
	cPan		cpCenter
	cVolFM		$00
	cNote		cnRst, $60
	cNote		cnRst
	cNote		cnRst
	cNote		cnRst, $3C
	cInsFM		patch12
	cVolFM		$09
	cNote		cnD3, $0C
	cNote		cnDs3
	cNote		cnE3
	cLoopStart
		cInsFM		patch12
		cVolFM		$08
		cNote		cnE4, $C0
		cNote		cnFs4
		cNote		cnA4
		cNote		cnGs4, $60
		cNote		cnG4
		cLoopCnt	$03
			cInsFM		patch2B
			cVolFM		$08
			cNote		cnA3, $04
			cNote		cnRst, $0E
			cNote		cnA3, $04
			cNote		cnRst, $0E
			cNote		cnA3, $04
			cNote		cnRst, $0E
			cNote		cnA3, $04
			cNote		cnRst, $0E
			cNote		cnA3, $04
			cNote		cnRst, $0E
			cNote		cnA3, $06
			cNote		cnRst, $0C
			cNote		cnA3, $04
			cNote		cnRst, $0E
			cNote		cnA3, $04
			cNote		cnRst, $0E
			cNote		cnA3, $08
			cNote		cnRst, $0A
			cNote		cnAs3, $12
			cNote		cnB3, $0C
		cLoopCntEnd
	cLoopEnd
	cStop

Song1A_DAC:
	cLoopCnt	$02
		cNote		cnC0, $0C
		cNote		cnC0
		cNote		cnCs0, $12
		cNote		cnC0, $05
		cNote		cnRst, $0D
		cNote		cnC0, $0C
		cNote		cnCs0
		cNote		cnE0
	cLoopCntEnd
	cNote		cnC0, $0C
	cNote		cnC0
	cNote		cnCs0, $12
	cNote		cnC0, $36
	cLoopStart
		cLoopCnt	$0E
			cNote		cnC0, $0C
			cNote		cnC0
			cNote		cnCs0, $12
			cNote		cnC0
			cNote		cnC0, $0C
			cNote		cnCs0
			cNote		cnC0
		cLoopCntEnd
		cNote		cnC0, $0C
		cNote		cnC0
		cNote		cnCs0, $12
		cNote		cnC0, $06
		cNote		cnCs0, $0C
		cNote		cnCs0
		cNote		cnCs0, $06
		cNote		cnCs0
		cNote		cnCs0
		cNote		cnCs0
	cLoopEnd
	cStop

Song1A_PSG1:
	cRelease	$01
	cVibrato	$04, $0A
	cInsVolPSG	$00, $00
	cNote		cnRst, $60
	cNote		cnRst
	cNote		cnRst
	cNote		cnRst
	cLoopStart
		cInsVolPSG	$00, $09
		cNote		cnA3, $C0
		cNote		cnB3
		cNote		cnD4
		cNote		cnCs4, $60
		cNote		cnC4
		cLoopCnt	$03
			cInsVolPSG	$00, $00
			cNote		cnRst, $60
			cNote		cnRst
		cLoopCntEnd
	cLoopEnd
	cStop

Song1A_PSG2:
	cInsVolPSG	$00, $0A
	cRelease	$01
	cVibrato	$02, $0A
	cLoopCnt	$02
		cInsVolPSG	$00, $0B
		cNote		cnB4, $02
		cInsVolPSG	$00, $00
		cNote		cnRst, $04
		cInsVolPSG	$00, $0B
		cNote		cnB5, $02
		cInsVolPSG	$00, $00
		cNote		cnRst, $04
		cInsVolPSG	$00, $0B
		cNote		cnB5, $02
		cInsVolPSG	$00, $00
		cNote		cnRst, $04
		cInsVolPSG	$00, $0B
		cNote		cnB4, $02
		cInsVolPSG	$00, $00
		cNote		cnRst, $04
		cInsVolPSG	$00, $0B
		cNote		cnB5, $02
		cInsVolPSG	$00, $00
		cNote		cnRst, $04
		cNote		cnRst, $06
		cInsVolPSG	$00, $0B
		cNote		cnB4, $02
		cInsVolPSG	$00, $00
		cNote		cnRst, $04
		cInsVolPSG	$00, $0B
		cNote		cnB5, $02
		cInsVolPSG	$00, $00
		cNote		cnRst, $04
		cNote		cnRst, $06
		cInsVolPSG	$00, $0B
		cNote		cnB4, $02
		cInsVolPSG	$00, $00
		cNote		cnRst, $04
		cInsVolPSG	$00, $0B
		cNote		cnB4, $02
		cInsVolPSG	$00, $00
		cNote		cnRst, $04
		cInsVolPSG	$00, $0B
		cNote		cnB5, $02
		cInsVolPSG	$00, $00
		cNote		cnRst, $04
		cInsVolPSG	$00, $0B
		cNote		cnB4, $02
		cInsVolPSG	$00, $00
		cNote		cnRst, $04
		cNote		cnRst, $06
		cInsVolPSG	$00, $0B
		cNote		cnB4, $02
		cInsVolPSG	$00, $00
		cNote		cnRst, $04
		cInsVolPSG	$00, $0B
		cNote		cnB5, $02
		cInsVolPSG	$00, $00
		cNote		cnRst, $04
	cLoopCntEnd
	cInsVolPSG	$00, $0B
	cNote		cnB4, $02
	cInsVolPSG	$00, $00
	cNote		cnRst, $04
	cInsVolPSG	$00, $0B
	cNote		cnB5, $02
	cInsVolPSG	$00, $00
	cNote		cnRst, $04
	cInsVolPSG	$00, $0B
	cNote		cnB5, $02
	cInsVolPSG	$00, $00
	cNote		cnRst, $04
	cInsVolPSG	$00, $0B
	cNote		cnB4, $02
	cInsVolPSG	$00, $00
	cNote		cnRst, $04
	cInsVolPSG	$00, $0B
	cNote		cnB5, $02
	cInsVolPSG	$00, $00
	cNote		cnRst, $04
	cNote		cnRst, $06
	cInsVolPSG	$00, $0B
	cNote		cnB4, $02
	cInsVolPSG	$00, $00
	cNote		cnRst, $04
	cInsVolPSG	$00, $0B
	cNote		cnB5, $02
	cInsVolPSG	$00, $00
	cNote		cnRst, $04
	cNote		cnRst, $18
	cNote		cnRst
	cLoopStart
		cInsVolPSG	$00, $0B
		cNote		cnB4, $02
		cInsVolPSG	$00, $00
		cNote		cnRst, $04
		cInsVolPSG	$00, $0B
		cNote		cnB5, $02
		cInsVolPSG	$00, $00
		cNote		cnRst, $04
		cInsVolPSG	$00, $0B
		cNote		cnB5, $02
		cInsVolPSG	$00, $00
		cNote		cnRst, $04
		cInsVolPSG	$00, $0B
		cNote		cnB4, $02
		cInsVolPSG	$00, $00
		cNote		cnRst, $04
		cInsVolPSG	$00, $0B
		cNote		cnB5, $02
		cInsVolPSG	$00, $00
		cNote		cnRst, $04
		cNote		cnRst, $06
		cInsVolPSG	$00, $0B
		cNote		cnB4, $02
		cInsVolPSG	$00, $00
		cNote		cnRst, $04
		cInsVolPSG	$00, $0B
		cNote		cnB5, $02
		cInsVolPSG	$00, $00
		cNote		cnRst, $04
		cNote		cnRst, $06
		cInsVolPSG	$00, $0B
		cNote		cnB4, $02
		cInsVolPSG	$00, $00
		cNote		cnRst, $04
		cInsVolPSG	$00, $0B
		cNote		cnB4, $02
		cInsVolPSG	$00, $00
		cNote		cnRst, $04
		cInsVolPSG	$00, $0B
		cNote		cnB5, $02
		cInsVolPSG	$00, $00
		cNote		cnRst, $04
		cInsVolPSG	$00, $0B
		cNote		cnB4, $02
		cInsVolPSG	$00, $00
		cNote		cnRst, $04
		cNote		cnRst, $06
		cInsVolPSG	$00, $0B
		cNote		cnB4, $02
		cInsVolPSG	$00, $00
		cNote		cnRst, $04
		cInsVolPSG	$00, $0B
		cNote		cnB5, $02
		cInsVolPSG	$00, $00
		cNote		cnRst, $04
	cLoopEnd
	cStop

Song1A_PSG3:
	cStop

Song1A_Noise:
	cLoopStart
		cInsVolPSG	$0F, $0E
		cRelease	$01
		cNote		cnG0, $06
		cInsVolPSG	$0F, $0B
		cNote		cnG0
		cNote		cnG0
		cNote		cnG0
	cLoopEnd
	cStop
