Song0A_Start:
	cType		ctMusic
	cFadeOut	$0000
	cTempo		$BE
	cChannel	Song0A_FM1
	cChannel	Song0A_FM2
	cChannel	Song0A_FM3
	cChannel	Song0A_FM4
	cChannel	Song0A_FM5
	cChannel	Song0A_DAC
	cChannel	Song0A_PSG1
	cChannel	Song0A_PSG2
	cChannel	Song0A_PSG3
	cChannel	Song0A_Noise

Song0A_FM1:
	cLoopStart
		cVolFM		$00
		cRelease	$01
		cVibrato	$02, $0A
		cNoteShift	$01, $04, $00
		cNoteShift	$00, $00, $00
		cNote		cnRst, $60
		cNote		cnRst
		cNote		cnRst
		cNote		cnRst
		cLoopCnt	$01
			cInsFM		patch20
			cVolFM		$0D
			cNote		cnRst, $0C
			cNote		cnCs4, $12
			cNote		cnRst, $06
			cNote		cnB3, $0E
			cNote		cnRst, $2E
			cNote		cnD4, $0E
			cNote		cnRst, $16
			cNote		cnB3, $0E
			cNote		cnRst, $2E
			cNote		cnRst, $0C
			cNote		cnCs4, $12
			cNote		cnRst, $06
			cNote		cnB3, $0E
			cNote		cnRst, $2E
			cNote		cnFs3, $0E
			cNote		cnRst, $16
			cNote		cnD3, $16
			cNote		cnRst, $26
			cNote		cnRst, $0C
			cNote		cnCs4, $12
			cNote		cnRst, $06
			cNote		cnB3, $0E
			cNote		cnRst, $2E
			cNote		cnD4, $0E
			cNote		cnRst, $16
			cNote		cnB3, $0E
			cNote		cnRst, $2E
			cNote		cnRst, $0C
			cNote		cnCs4, $12
			cNote		cnRst, $06
			cNote		cnB3, $0E
			cNote		cnRst, $2E
			cNote		cnFs3, $0E
			cNote		cnRst, $16
			cNote		cnD3, $16
			cNote		cnRst, $26
			cInsFM		patch1F
			cVolFM		$0C
			cNote		cnA4, $02
			cNote		cnRst, $04
			cNote		cnA5, $02
			cNote		cnRst, $04
			cNote		cnA4, $02
			cNote		cnRst, $04
			cNote		cnA4, $02
			cNote		cnRst, $04
			cNote		cnA5, $02
			cNote		cnRst, $04
			cNote		cnA4, $02
			cNote		cnRst, $04
			cNote		cnA4, $02
			cNote		cnRst, $04
			cNote		cnA5, $02
			cNote		cnRst, $04
			cNote		cnA4, $02
			cNote		cnRst, $04
			cNote		cnA5, $02
			cNote		cnRst, $04
			cNote		cnA4, $02
			cNote		cnRst, $04
			cNote		cnA4, $02
			cNote		cnRst, $04
			cNote		cnA4, $02
			cNote		cnRst, $04
			cNote		cnA5, $02
			cNote		cnRst, $04
			cNote		cnA4, $02
			cNote		cnRst, $04
			cNote		cnA4, $02
			cNote		cnRst, $04
			cNote		cnA4, $02
			cNote		cnRst, $04
			cNote		cnA5, $02
			cNote		cnRst, $04
			cNote		cnA4, $02
			cNote		cnRst, $04
			cNote		cnA4, $02
			cNote		cnRst, $04
			cNote		cnA5, $02
			cNote		cnRst, $04
			cNote		cnA4, $02
			cNote		cnRst, $04
			cNote		cnA4, $02
			cNote		cnRst, $04
			cNote		cnA5, $02
			cNote		cnRst, $04
			cNote		cnA4, $02
			cNote		cnRst, $04
			cNote		cnA5, $02
			cNote		cnRst, $04
			cNote		cnA4, $02
			cNote		cnRst, $04
			cNote		cnA4, $02
			cNote		cnRst, $04
			cNote		cnA4, $02
			cNote		cnRst, $04
			cNote		cnA5, $02
			cNote		cnRst, $04
			cNote		cnA4, $02
			cNote		cnRst, $04
			cNote		cnA5, $02
			cNote		cnRst, $04
			cNote		cnA4, $02
			cNote		cnRst, $04
			cNote		cnA5, $02
			cNote		cnRst, $04
			cNote		cnA4, $02
			cNote		cnRst, $04
			cNote		cnA4, $02
			cNote		cnRst, $04
			cNote		cnA5, $02
			cNote		cnRst, $04
			cNote		cnA4, $02
			cNote		cnRst, $04
			cNote		cnA4, $02
			cNote		cnRst, $04
			cNote		cnA5, $02
			cNote		cnRst, $04
			cNote		cnA4, $02
			cNote		cnRst, $04
			cNote		cnA5, $02
			cNote		cnRst, $04
			cNote		cnA4, $02
			cNote		cnRst, $04
			cNote		cnA4, $02
			cNote		cnRst, $04
			cNote		cnA4, $02
			cNote		cnRst, $04
			cNote		cnA5, $02
			cNote		cnRst, $04
			cNote		cnA4, $02
			cNote		cnRst, $04
			cNote		cnA4, $02
			cNote		cnRst, $04
			cNote		cnA4, $02
			cNote		cnRst, $04
			cNote		cnA5, $02
			cNote		cnRst, $04
			cNote		cnA4, $02
			cNote		cnRst, $04
			cNote		cnA4, $02
			cNote		cnRst, $04
			cNote		cnA5, $02
			cNote		cnRst, $04
			cNote		cnA4, $02
			cNote		cnRst, $04
			cNote		cnA4, $02
			cNote		cnRst, $04
			cNote		cnA5, $02
			cNote		cnRst, $04
			cNote		cnA4, $02
			cNote		cnRst, $04
			cNote		cnA5, $02
			cNote		cnRst, $04
			cNote		cnA4, $02
			cNote		cnRst, $04
			cNote		cnA4, $02
			cNote		cnRst, $04
			cNote		cnA4, $02
			cNote		cnRst, $04
			cNote		cnA5, $02
			cNote		cnRst, $04
			cNote		cnA4, $02
			cNote		cnRst, $04
			cNote		cnA5, $02
			cNote		cnRst, $04
		cLoopCntEnd
		cInsFM		patch7D
		cVolFM		$0C
		cNote		cnRst, $0C
		cNote		cnD3
		cSlide		$50
		cNote		cnD3
		cNote		cnD3
		cNote		cnD3
		cNote		cnD3
		cNote		cnD3
		cNote		cnD3
		cNote		cnE3, $18
		cNote		cnD3, $0C
		cNote		cnCs3, $18
		cNote		cnB2, $24
		cNote		cnRst, $0C
		cNote		cnD3
		cNote		cnD3
		cNote		cnD3
		cNote		cnD3
		cNote		cnD3
		cNote		cnD3
		cNote		cnD3
		cNote		cnGs2, $18
		cNote		cnB2, $0C
		cNote		cnE3, $18
		cNote		cnD3, $24
		cNote		cnRst, $0C
		cNote		cnD3
		cNote		cnD3
		cNote		cnD3
		cNote		cnD3
		cNote		cnD3
		cNote		cnD3
		cNote		cnD3
		cNote		cnE3, $18
		cNote		cnD3, $0C
		cNote		cnCs3, $18
		cNote		cnB2, $0C
		cNote		cnA2
		cNote		cnB2
		cNote		cnCs3, $60
		cNote		cnB2, $24
		cNote		cnCs3
		cNote		cnA2, $18
		cNote		cnCs3, $60
		cNote		cnB2, $24
		cNote		cnCs3
		cNote		cnA2, $18
		cSlideStop
	cLoopEnd
	cStop

Song0A_FM2:
	cLoopStart
		cInsFM		patch1D
		cVolFM		$0D
		cRelease	$01
		cVibrato	$02, $0A
		cPan		cpLeft
		cNoteShift	$00, $00, $00
		cVoltaLoop
			cVoltaSect1
				cLoopCnt	$0C
					cNote		cnCs3, $0C
					cNote		cnCs3
					cNote		cnD3
					cNote		cnD3
					cNote		cnCs3
					cNote		cnCs3
					cNote		cnE3
					cNote		cnE3
					cNote		cnFs3
					cNote		cnFs3
					cNote		cnE3
					cNote		cnE3
					cNote		cnB3
					cNote		cnB3
					cNote		cnA3
					cNote		cnA3
				cLoopCntEnd
			cVoltaSectEnd
			cVoltaSect2
				cNote		cnCs3, $0C
				cNote		cnCs3
				cNote		cnD3
				cNote		cnD3
				cNote		cnCs3
				cNote		cnCs3
				cNote		cnE3
				cNote		cnE3
				cInsFM		patch14
				cVolFM		$0B
				cNote		cnD5, $04
				cNote		cnCs5
				cNote		cnC5
				cNote		cnB4
				cNote		cnAs4
				cNote		cnA4
				cNote		cnGs4
				cNote		cnG4
				cNote		cnFs4
				cNote		cnF4
				cNote		cnE4
				cNote		cnDs4
				cNote		cnD4
				cNote		cnCs4
				cNote		cnC4
				cNote		cnB3
				cNote		cnAs3
				cNote		cnA3
				cNote		cnGs3
				cNote		cnG3
				cNote		cnFs3
				cNote		cnF3
				cNote		cnE3
				cNote		cnDs3
				cInsFM		patch0A
				cVolFM		$0C
				cNote		cnRst, $0C
				cNote		cnFs3
				cNote		cnFs3
				cNote		cnFs3
				cNote		cnFs3
				cNote		cnFs3
				cNote		cnFs3
				cNote		cnFs3
				cNote		cnGs3, $18
				cNote		cnFs3, $0C
				cNote		cnE3, $18
				cNote		cnE3, $24
				cNote		cnRst, $0C
				cNote		cnFs3
				cNote		cnFs3
				cNote		cnFs3
				cNote		cnFs3
				cNote		cnFs3
				cNote		cnFs3
				cNote		cnFs3
				cNote		cnB2, $18
				cNote		cnD3, $0C
				cNote		cnGs3, $18
				cNote		cnFs3, $24
				cNote		cnRst, $0C
				cNote		cnFs3
				cNote		cnFs3
				cNote		cnFs3
				cNote		cnFs3
				cNote		cnFs3
				cNote		cnFs3
				cNote		cnFs3
				cNote		cnGs3, $18
				cNote		cnFs3, $0C
				cNote		cnE3, $18
				cNote		cnD3, $0C
				cNote		cnCs3
				cNote		cnD3
				cNote		cnE3, $60
				cNote		cnD3, $24
				cNote		cnE3
				cNote		cnCs3, $18
				cNote		cnE3, $60
				cNote		cnD3, $24
				cNote		cnE3
				cNote		cnCs3, $18
	cLoopEnd
	cStop

Song0A_FM3:
	cLoopStart
		cInsFM		patch7C
		cVolFM		$0D
		cRelease	$01
		cVibrato	$02, $0A
		cLoopCnt	$0D
			cNote		cnA1, $0F
			cNote		cnRst, $03
			cNote		cnA1, $06
			cNote		cnC2, $0C
			cNote		cnCs2, $0B
			cNote		cnRst, $0D
			cNote		cnD2, $04
			cNote		cnRst, $08
			cNote		cnDs2, $0C
			cNote		cnE2
			cNote		cnD2
			cNote		cnD2, $04
			cNote		cnRst, $08
			cNote		cnCs2, $0C
			cNote		cnCs2, $0B
			cNote		cnRst, $07
			cNote		cnC2, $02
			cNote		cnRst, $04
			cNote		cnC2, $0C
			cNote		cnB1
			cNote		cnB1
		cLoopCntEnd
		cLoopCnt	$02
			cNote		cnD2, $0C
			cNote		cnD2, $04
			cNote		cnRst, $08
			cNote		cnE2, $0C
			cNote		cnE2, $04
			cNote		cnRst, $08
			cNote		cnFs2, $0C
			cNote		cnFs2, $04
			cNote		cnRst, $08
			cNote		cnGs2, $0C
			cNote		cnGs2, $04
			cNote		cnRst, $08
			cNote		cnE2, $0C
			cNote		cnE2, $04
			cNote		cnRst, $08
			cNote		cnFs2, $0C
			cNote		cnFs2, $04
			cNote		cnRst, $08
			cNote		cnGs2, $0C
			cNote		cnGs2, $04
			cNote		cnRst, $08
			cNote		cnB2, $0C
			cNote		cnB2, $04
			cNote		cnRst, $08
		cLoopCntEnd
		cNote		cnFs2, $06
		cNote		cnRst
		cNote		cnFs2
		cNote		cnRst
		cNote		cnFs2
		cNote		cnRst
		cNote		cnFs2
		cNote		cnRst
		cNote		cnFs2
		cNote		cnRst
		cNote		cnFs2
		cNote		cnRst
		cNote		cnFs2
		cNote		cnRst
		cNote		cnFs2, $03
		cNote		cnRst
		cNote		cnFs2
		cNote		cnRst
		cNote		cnD2, $06
		cNote		cnRst
		cNote		cnD2
		cNote		cnRst
		cNote		cnD2
		cNote		cnRst
		cNote		cnD2, $03
		cNote		cnRst
		cNote		cnD2
		cNote		cnRst
		cNote		cnE2, $06
		cNote		cnRst
		cNote		cnE2
		cNote		cnRst
		cNote		cnE2
		cNote		cnRst
		cNote		cnE2, $03
		cNote		cnRst
		cNote		cnE2
		cNote		cnRst
		cNote		cnFs1, $06
		cNote		cnRst
		cNote		cnFs1
		cNote		cnRst
		cNote		cnFs1
		cNote		cnRst
		cNote		cnFs1
		cNote		cnRst
		cNote		cnFs1
		cNote		cnRst
		cNote		cnFs1
		cNote		cnRst
		cNote		cnFs1
		cNote		cnRst
		cNote		cnFs1, $03
		cNote		cnRst
		cNote		cnFs1
		cNote		cnRst
		cNote		cnD2, $06
		cNote		cnRst
		cNote		cnD2
		cNote		cnRst
		cNote		cnD2
		cNote		cnRst
		cNote		cnD2
		cNote		cnRst
		cNote		cnD2
		cNote		cnRst
		cNote		cnD2
		cNote		cnRst
		cNote		cnD2
		cNote		cnRst
		cNote		cnD2, $03
		cNote		cnRst
		cNote		cnD2
		cNote		cnRst
	cLoopEnd
	cStop

Song0A_FM4:
	cLoopStart
		cInsFM		patch1D
		cVolFM		$0D
		cRelease	$01
		cVibrato	$02, $0A
		cPan		cpRight
		cNoteShift	$00, $00, $00
		cLoopCnt	$1A
			cNote		cnA2, $0C
			cNote		cnA2
			cNote		cnA2
			cNote		cnA2
			cNote		cnA2
			cNote		cnA2
			cNote		cnA2
			cNote		cnA2
		cLoopCntEnd
		cNote		cnRst, $0C
		cInsFM		patch14
		cVolFM		$09
		cNote		cnD5, $04
		cNote		cnCs5
		cNote		cnC5
		cNote		cnB4
		cNote		cnAs4
		cNote		cnA4
		cNote		cnGs4
		cNote		cnG4
		cNote		cnFs4
		cNote		cnF4
		cNote		cnE4
		cNote		cnDs4
		cNote		cnD4
		cNote		cnCs4
		cNote		cnC4
		cNote		cnB3
		cNote		cnAs3
		cNote		cnA3
		cNote		cnGs3
		cNote		cnG3
		cNote		cnFs3
		cInsFM		patch0A
		cVolFM		$0C
		cNote		cnRst, $0C
		cNote		cnA3
		cNote		cnA3
		cNote		cnA3
		cNote		cnA3
		cNote		cnA3
		cNote		cnA3
		cNote		cnA3
		cNote		cnB3, $18
		cNote		cnA3, $0C
		cNote		cnGs3, $18
		cNote		cnGs3, $24
		cNote		cnRst, $0C
		cNote		cnA3
		cNote		cnA3
		cNote		cnA3
		cNote		cnA3
		cNote		cnA3
		cNote		cnA3
		cNote		cnA3
		cNote		cnE3, $18
		cNote		cnGs3, $0C
		cNote		cnB3, $18
		cNote		cnB3, $24
		cNote		cnRst, $0C
		cNote		cnA3
		cNote		cnA3
		cNote		cnA3
		cNote		cnA3
		cNote		cnA3
		cNote		cnA3
		cNote		cnA3
		cNote		cnB3, $18
		cNote		cnA3, $0C
		cNote		cnGs3, $18
		cNote		cnGs3, $0C
		cNote		cnFs3
		cNote		cnGs3
		cNote		cnA3, $60
		cNote		cnGs3, $24
		cNote		cnA3
		cNote		cnFs3, $18
		cNote		cnA3, $60
		cNote		cnGs3, $24
		cNote		cnA3
		cNote		cnFs3, $18
	cLoopEnd
	cStop

Song0A_FM5:
	cNote		cnRst, $0F
	cLoopStart
		cVolFM		$00
		cRelease	$01
		cVibrato	$02, $0A
		cPan		cpCenter
		cNoteShift	$00, $03, $00
		cNote		cnRst, $60
		cNote		cnRst
		cNote		cnRst
		cNote		cnRst
		cLoopCnt	$01
			cInsFM		patch20
			cVolFM		$0B
			cNote		cnRst, $0C
			cNote		cnCs4, $12
			cNote		cnRst, $06
			cNote		cnB3, $0E
			cNote		cnRst, $2E
			cNote		cnD4, $0E
			cNote		cnRst, $16
			cNote		cnB3, $0E
			cNote		cnRst, $2E
			cNote		cnRst, $0C
			cNote		cnCs4, $12
			cNote		cnRst, $06
			cNote		cnB3, $0E
			cNote		cnRst, $2E
			cNote		cnFs3, $0E
			cNote		cnRst, $16
			cNote		cnD3, $16
			cNote		cnRst, $26
			cNote		cnRst, $0C
			cNote		cnCs4, $12
			cNote		cnRst, $06
			cNote		cnB3, $0E
			cNote		cnRst, $2E
			cNote		cnD4, $0E
			cNote		cnRst, $16
			cNote		cnB3, $0E
			cNote		cnRst, $2E
			cNote		cnRst, $0C
			cNote		cnCs4, $12
			cNote		cnRst, $06
			cNote		cnB3, $0E
			cNote		cnRst, $2E
			cNote		cnFs3, $0E
			cNote		cnRst, $16
			cNote		cnD3, $16
			cNote		cnRst, $26
			cInsFM		patch1F
			cVolFM		$07
			cNote		cnA4, $02
			cNote		cnRst, $04
			cNote		cnA5, $02
			cNote		cnRst, $04
			cNote		cnA4, $02
			cNote		cnRst, $04
			cNote		cnA4, $02
			cNote		cnRst, $04
			cNote		cnA5, $02
			cNote		cnRst, $04
			cNote		cnA4, $02
			cNote		cnRst, $04
			cNote		cnA4, $02
			cNote		cnRst, $04
			cNote		cnA5, $02
			cNote		cnRst, $04
			cNote		cnA4, $02
			cNote		cnRst, $04
			cNote		cnA5, $02
			cNote		cnRst, $04
			cNote		cnA4, $02
			cNote		cnRst, $04
			cNote		cnA4, $02
			cNote		cnRst, $04
			cNote		cnA4, $02
			cNote		cnRst, $04
			cNote		cnA5, $02
			cNote		cnRst, $04
			cNote		cnA4, $02
			cNote		cnRst, $04
			cNote		cnA4, $02
			cNote		cnRst, $04
			cNote		cnA4, $02
			cNote		cnRst, $04
			cNote		cnA5, $02
			cNote		cnRst, $04
			cNote		cnA4, $02
			cNote		cnRst, $04
			cNote		cnA4, $02
			cNote		cnRst, $04
			cNote		cnA5, $02
			cNote		cnRst, $04
			cNote		cnA4, $02
			cNote		cnRst, $04
			cNote		cnA4, $02
			cNote		cnRst, $04
			cNote		cnA5, $02
			cNote		cnRst, $04
			cNote		cnA4, $02
			cNote		cnRst, $04
			cNote		cnA5, $02
			cNote		cnRst, $04
			cNote		cnA4, $02
			cNote		cnRst, $04
			cNote		cnA4, $02
			cNote		cnRst, $04
			cNote		cnA4, $02
			cNote		cnRst, $04
			cNote		cnA5, $02
			cNote		cnRst, $04
			cNote		cnA4, $02
			cNote		cnRst, $04
			cNote		cnA5, $02
			cNote		cnRst, $04
			cNote		cnA4, $02
			cNote		cnRst, $04
			cNote		cnA5, $02
			cNote		cnRst, $04
			cNote		cnA4, $02
			cNote		cnRst, $04
			cNote		cnA4, $02
			cNote		cnRst, $04
			cNote		cnA5, $02
			cNote		cnRst, $04
			cNote		cnA4, $02
			cNote		cnRst, $04
			cNote		cnA4, $02
			cNote		cnRst, $04
			cNote		cnA5, $02
			cNote		cnRst, $04
			cNote		cnA4, $02
			cNote		cnRst, $04
			cNote		cnA5, $02
			cNote		cnRst, $04
			cNote		cnA4, $02
			cNote		cnRst, $04
			cNote		cnA4, $02
			cNote		cnRst, $04
			cNote		cnA4, $02
			cNote		cnRst, $04
			cNote		cnA5, $02
			cNote		cnRst, $04
			cNote		cnA4, $02
			cNote		cnRst, $04
			cNote		cnA4, $02
			cNote		cnRst, $04
			cNote		cnA4, $02
			cNote		cnRst, $04
			cNote		cnA5, $02
			cNote		cnRst, $04
			cNote		cnA4, $02
			cNote		cnRst, $04
			cNote		cnA4, $02
			cNote		cnRst, $04
			cNote		cnA5, $02
			cNote		cnRst, $04
			cNote		cnA4, $02
			cNote		cnRst, $04
			cNote		cnA4, $02
			cNote		cnRst, $04
			cNote		cnA5, $02
			cNote		cnRst, $04
			cNote		cnA4, $02
			cNote		cnRst, $04
			cNote		cnA5, $02
			cNote		cnRst, $04
			cNote		cnA4, $02
			cNote		cnRst, $04
			cNote		cnA4, $02
			cNote		cnRst, $04
			cNote		cnA4, $02
			cNote		cnRst, $04
			cNote		cnA5, $02
			cNote		cnRst, $04
			cNote		cnA4, $02
			cNote		cnRst, $04
			cNote		cnA5, $02
			cNote		cnRst, $04
		cLoopCntEnd
		cInsFM		patch7D
		cVolFM		$09
		cNote		cnRst, $0C
		cNote		cnD3
		cSlide		$50
		cNote		cnD3
		cNote		cnD3
		cNote		cnD3
		cNote		cnD3
		cNote		cnD3
		cNote		cnD3
		cNote		cnE3, $18
		cNote		cnD3, $0C
		cNote		cnCs3, $18
		cNote		cnB2, $24
		cNote		cnRst, $0C
		cNote		cnD3
		cNote		cnD3
		cNote		cnD3
		cNote		cnD3
		cNote		cnD3
		cNote		cnD3
		cNote		cnD3
		cNote		cnGs2, $18
		cNote		cnB2, $0C
		cNote		cnE3, $18
		cNote		cnD3, $24
		cNote		cnRst, $0C
		cNote		cnD3
		cNote		cnD3
		cNote		cnD3
		cNote		cnD3
		cNote		cnD3
		cNote		cnD3
		cNote		cnD3
		cNote		cnE3, $18
		cNote		cnD3, $0C
		cNote		cnCs3, $18
		cNote		cnB2, $0C
		cNote		cnA2
		cNote		cnB2
		cNote		cnCs3, $60
		cNote		cnB2, $24
		cNote		cnCs3
		cNote		cnA2, $18
		cNote		cnCs3, $60
		cNote		cnB2, $24
		cNote		cnCs3
		cNote		cnA2, $18
		cSlideStop
	cLoopEnd
	cStop

Song0A_DAC:
	cLoopStart
		cLoopCnt	$02
			cNote		cnC0, $18
			cPan		cpCenter
			cNote		cnCs0
			cNote		cnC0
			cNote		cnCs0
		cLoopCntEnd
		cNote		cnC0, $18
		cNote		cnCs0
		cNote		cnC0
		cNote		cnDs0, $0C
		cNote		cnDs0
		cLoopCnt	$0A
			cNote		cnC0, $18
			cNote		cnCs0
			cNote		cnC0
			cNote		cnCs0
		cLoopCntEnd
		cNote		cnC0, $18
		cNote		cnCs0
		cNote		cnC0, $0C
		cNote		cnDs0
		cNote		cnDs0
		cNote		cnDs0
		cLoopCnt	$0A
			cNote		cnC0, $18
			cNote		cnCs0
			cNote		cnC0
			cNote		cnCs0
		cLoopCntEnd
		cNote		cnC0, $0C
		cNote		cnCs0
		cNote		cnCs0
		cNote		cnCs0
		cNote		cnCs0
		cNote		cnCs0
		cNote		cnCs0
		cNote		cnCs0, $06
		cNote		cnCs0
		cLoopCnt	$08
			cNote		cnC0, $18
			cNote		cnCs0
			cNote		cnC0
			cNote		cnCs0
		cLoopCntEnd
		cNote		cnC0, $18
		cNote		cnCs0
		cNote		cnCs0, $06
		cNote		cnCs0
		cNote		cnCs0, $0C
		cNote		cnCs0
		cNote		cnCs0, $06
		cNote		cnCs0
	cLoopEnd
	cStop

Song0A_PSG1:
	cInsVolPSG	$00, $00
	cStop

Song0A_PSG2:
	cInsVolPSG	$00, $00
	cStop

Song0A_PSG3:
	cInsVolPSG	$00, $00
	cStop

Song0A_Noise:
	cLoopStart
		cInsVolPSG	$00, $00
		cNote		cnRst
		cNote		cnC1
		cInsVolPSG	$0F, $0D
		cNote		cnG0, $06
		cInsVolPSG	$00, $00
		cNote		cnRst, $06
		cNote		cnRst, $0C
		cInsVolPSG	$0F, $0D
		cNote		cnG0, $06
		cNote		cnG0
	cLoopEnd
	cStop
