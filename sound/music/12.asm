Song12_Start:
	cType		ctMusic
	cFadeOut	$0000
	cTempo		$C0
	cChannel	Song12_FM1
	cChannel	Song12_FM2
	cChannel	Song12_FM3
	cChannel	Song12_FM4
	cChannel	Song12_FM5
	cChannel	Song12_DAC
	cChannel	Song12_PSG1
	cChannel	Song12_PSG2
	cChannel	Song12_PSG3
	cChannel	Song12_Noise

Song12_FM1:
	cRelease	$01
	cVibrato	$02, $0A
	cPan		cpCenter
	cNoteShift	$00, $00, $00
	cLoopCnt	$03
		cInsFM		patch12
		cVolFM		$0B
		cNote		cnA1, $05
		cNote		cnA1
		cNote		cnA1
		cNote		cnA1
		cNote		cnD3, $0A
		cNote		cnA1, $05
		cNote		cnA1
		cNote		cnA1
		cNote		cnA1
		cNote		cnC3, $0A
		cNote		cnA1, $05
		cNote		cnA1
		cNote		cnA1
		cNote		cnFs2
		cNote		cnD3, $0A
		cNote		cnA1, $05
		cNote		cnA1
		cNote		cnA1
		cNote		cnA1
		cNote		cnC3, $0A
		cNote		cnA1, $05
		cNote		cnA1
		cNote		cnA1
		cNote		cnA1
		cNote		cnC3, $0A
		cNote		cnD3
	cLoopCntEnd
	cLoopStart
		cLoopCnt	$01
			cInsFM		patch26
			cVolFM		$0B
			cNote		cnE3, $05
			cNote		cnFs3
			cNote		cnG3
			cNote		cnE3
			cNote		cnB3, $0A
			cNote		cnE3, $05
			cNote		cnFs3
			cNote		cnG3
			cNote		cnE3
			cNote		cnC4, $0A
			cNote		cnE3, $05
			cNote		cnFs3
			cNote		cnG3
			cNote		cnE3
			cNote		cnD4, $0A
			cNote		cnE3, $05
			cNote		cnFs3
			cNote		cnG3
			cNote		cnE3
			cNote		cnC4, $0A
			cNote		cnFs3, $05
			cNote		cnG3
			cNote		cnA3
			cNote		cnG3
			cNote		cnFs3
			cNote		cnD3
			cNote		cnE3
			cNote		cnFs3
			cNote		cnFs3
			cNote		cnG3
			cNote		cnB3, $0A
			cNote		cnE3, $05
			cNote		cnFs3
			cNote		cnG3
			cNote		cnE3
			cNote		cnC4, $0A
			cNote		cnE3, $05
			cNote		cnFs3
			cNote		cnG3
			cNote		cnE3
			cNote		cnD4, $0A
			cNote		cnE3, $05
			cNote		cnFs3
			cNote		cnG3
			cNote		cnE3
			cNote		cnC4, $0A
			cNote		cnE3, $05
			cNote		cnFs3
			cNote		cnG3
			cNote		cnA3
			cNote		cnG3
			cNote		cnFs3
			cNote		cnG3
			cNote		cnA3
			cNote		cnB3
			cNote		cnC4
		cLoopCntEnd
		cLoopCnt	$01
			cSlide		$7A
			cNote		cnE4, $0A
			cNote		cnG4, $14
			cNote		cnE4, $0A
			cNote		cnA4, $14
			cNote		cnE4, $0A
			cNote		cnG4, $14
			cNote		cnE4, $0A
			cNote		cnA4, $14
			cNote		cnG4, $0A
			cNote		cnFs4
			cNote		cnE4
			cNote		cnFs4
			cNote		cnE4
			cNote		cnG4, $14
			cNote		cnE4, $0A
			cNote		cnA4, $14
			cNote		cnE4, $0A
			cNote		cnG4, $14
			cNote		cnE4, $0A
			cNote		cnB4, $14
			cNote		cnA4, $0A
			cNote		cnG4
			cNote		cnFs4
			cNote		cnD4
		cLoopCntEnd
		cInsFM		patch12
		cVolFM		$0C
		cNote		cnE3, $05
		cNote		cnG3
		cNote		cnB3
		cNote		cnD4
		cNote		cnC4
		cNote		cnB3
		cNote		cnA3
		cNote		cnG3
		cNote		cnC4
		cNote		cnA3
		cNote		cnB3
		cNote		cnG3
		cNote		cnA3
		cNote		cnFs3
		cNote		cnG3
		cNote		cnE3
		cNote		cnFs3
		cNote		cnD3
		cNote		cnE3
		cNote		cnC3
		cNote		cnD3
		cNote		cnB2
		cNote		cnC3
		cNote		cnA2
		cNote		cnB2
		cNote		cnG2
		cNote		cnA2
		cNote		cnFs2
		cNote		cnG2
		cNote		cnE2
		cNote		cnFs2
		cNote		cnD2
		cNote		cnFs2, $1E
		cNote		cnE2, $05
		cNote		cnD2
		cNote		cnE2, $0A
		cNote		cnFs2, $1E
		cNote		cnFs2
		cNote		cnE2, $05
		cNote		cnD2
		cNote		cnE2, $0A
		cNote		cnFs2
		cNote		cnG2, $05
		cNote		cnA2
		cNote		cnB2
		cNote		cnC3
		cNote		cnB2, $1E
		cNote		cnB2, $05
		cNote		cnC3
		cNote		cnA2, $1E
		cNote		cnA2, $05
		cNote		cnB2
		cNote		cnG2, $1E
		cNote		cnG2, $05
		cNote		cnA2
		cNote		cnFs2, $1E
		cNote		cnE2, $05
		cNote		cnD2
		cNote		cnE2, $07
		cNote		cnE2
		cNote		cnFs2, $06
		cNote		cnFs2, $07
		cNote		cnG2
		cNote		cnG2, $06
		cNote		cnA2, $07
		cNote		cnA2
		cNote		cnG2, $06
		cNote		cnG2, $07
		cNote		cnFs2
		cNote		cnFs2, $06
		cSustain
		cNote		cnD2, $14
		cRelease	$01
		cSlide		$03
		cNote		cnD0, $3C
		cSlideStop
		cNote		cnE3, $05
		cNote		cnG3
		cNote		cnB3
		cNote		cnD3
		cNote		cnFs3
		cNote		cnA3
		cNote		cnE3
		cNote		cnG3
		cNote		cnB3
		cNote		cnD3
		cNote		cnFs3
		cNote		cnA3
		cNote		cnE3
		cNote		cnG3
		cNote		cnB3
		cNote		cnD3
		cNote		cnFs3
		cNote		cnA3
		cNote		cnE3
		cNote		cnG3
		cNote		cnB3
		cNote		cnD3
		cNote		cnFs3
		cNote		cnA3
		cNote		cnE3
		cNote		cnG3
		cNote		cnB3
		cNote		cnD3
		cNote		cnFs3
		cNote		cnA3
		cNote		cnE3
		cNote		cnG3
		cNote		cnB3
		cNote		cnD3
		cNote		cnFs3
		cNote		cnA3
		cNote		cnE3
		cNote		cnG3
		cNote		cnB3
		cNote		cnD3
		cNote		cnFs3
		cNote		cnA3
		cNote		cnE3
		cNote		cnG3
		cNote		cnB3
		cNote		cnD3
		cNote		cnFs3
		cNote		cnA3
		cNote		cnB3
		cNote		cnD4
		cNote		cnC4
		cNote		cnB3
		cNote		cnA3
		cNote		cnC4
		cNote		cnB3
		cNote		cnA3
		cNote		cnG3
		cNote		cnB3
		cNote		cnA3
		cNote		cnG3
		cNote		cnFs3
		cNote		cnA3
		cNote		cnG3
		cNote		cnFs3
		cNote		cnE3
		cNote		cnD3
		cNote		cnE3
		cNote		cnFs3
		cNote		cnG3, $0A
		cNote		cnG3, $05
		cNote		cnFs3
		cNote		cnG3
		cNote		cnA3
		cNote		cnB3, $0A
		cNote		cnA3, $05
		cNote		cnB3
		cNote		cnC4
		cNote		cnD4
		cNote		cnG3
		cNote		cnB3
		cNote		cnD3
		cNote		cnG3
		cNote		cnB3
		cNote		cnD3
		cNote		cnG3
		cNote		cnA3
		cNote		cnD3
		cNote		cnG3
		cNote		cnB3
		cNote		cnD3
		cNote		cnG3
		cNote		cnA3
		cNote		cnD3
		cNote		cnG3
		cNote		cnG3
		cNote		cnC3
		cNote		cnE3
		cNote		cnG3
		cNote		cnC3
		cNote		cnE3
		cNote		cnA3
		cNote		cnC3
		cNote		cnE3
		cNote		cnG3
		cNote		cnC3
		cNote		cnE3
		cNote		cnA3
		cNote		cnC3
		cNote		cnE3
		cNote		cnG3
		cNote		cnB2
		cNote		cnD3
		cNote		cnFs3
		cNote		cnB2
		cNote		cnD3
		cNote		cnFs3
		cNote		cnB2
		cNote		cnD3
		cNote		cnB4, $03
		cNote		cnAs4, $02
		cNote		cnA4, $03
		cNote		cnGs4, $02
		cNote		cnG4, $03
		cNote		cnFs4, $02
		cNote		cnF4, $03
		cNote		cnE4, $02
		cNote		cnDs4, $03
		cNote		cnD4, $02
		cNote		cnCs4, $03
		cNote		cnC4, $02
		cNote		cnB3, $03
		cNote		cnAs3, $02
		cNote		cnA3, $03
		cNote		cnGs3, $02
		cNote		cnRst, $0A
		cNote		cnA3, $0D
		cNote		cnRst, $02
		cNote		cnG3, $0D
		cNote		cnRst, $02
		cNote		cnF3, $0D
		cNote		cnRst, $02
		cNote		cnE3, $0C
		cNote		cnRst, $03
		cNote		cnD3, $0A
		cNote		cnRst
		cNote		cnG3, $0D
		cNote		cnRst, $02
		cNote		cnF3, $0D
		cNote		cnRst, $02
		cNote		cnE3, $0D
		cNote		cnRst, $02
		cNote		cnD3, $0D
		cNote		cnRst, $02
		cNote		cnC3, $0A
		cNote		cnRst
		cNote		cnF3, $0D
		cNote		cnRst, $02
		cNote		cnE3, $0D
		cNote		cnRst, $02
		cNote		cnD3, $0D
		cNote		cnRst, $02
		cNote		cnC3, $0D
		cNote		cnRst, $02
		cNote		cnB2, $0A
		cNote		cnRst
		cNote		cnE3, $0D
		cNote		cnRst, $02
		cNote		cnD3, $0D
		cNote		cnRst, $02
		cNote		cnC3, $0D
		cNote		cnRst, $02
		cNote		cnB2, $0D
		cNote		cnRst, $02
		cNote		cnA2, $0A
	cLoopEnd
	cStop

Song12_FM2:
	cInsFM		patch12
	cVolFM		$09
	cRelease	$01
	cVibrato	$02, $0A
	cPan		cpRight
	cNoteShift	$00, $00, $00
	cVolFM		$00
	cLoopCnt	$03
		cVolFM		$09
		cNote		cnRst, $14
		cNote		cnA2, $09
		cNote		cnRst, $15
		cNote		cnG2, $09
		cNote		cnRst, $15
		cNote		cnA2, $09
		cNote		cnRst, $15
		cNote		cnG2, $09
		cNote		cnRst, $15
		cNote		cnG2, $0A
		cNote		cnA2
	cLoopCntEnd
	cLoopStart
		cLoopCnt	$03
			cRelease	$04
			cNote		cnE1, $05
			cNote		cnE1
			cNote		cnE1
			cNote		cnE1
			cRelease	$01
			cNote		cnE2, $0A
			cRelease	$04
			cNote		cnE1, $05
			cNote		cnE1
			cNote		cnE1
			cNote		cnE1
			cRelease	$01
			cNote		cnE2, $0A
			cRelease	$04
			cNote		cnE1, $05
			cNote		cnE1
			cNote		cnE1
			cNote		cnE1
			cRelease	$04
			cNote		cnE1
			cNote		cnE1
			cNote		cnE1
			cNote		cnE1
			cRelease	$01
			cNote		cnE2, $0A
			cRelease	$04
			cNote		cnE1, $05
			cNote		cnE1
			cNote		cnE1
			cNote		cnE1
			cRelease	$04
			cNote		cnE2, $0A
			cRelease	$04
			cNote		cnE1, $05
			cNote		cnE1
			cNote		cnE1
			cNote		cnE1
			cRelease	$04
			cNote		cnG1
			cNote		cnG1
			cNote		cnG1
			cNote		cnG1
			cRelease	$01
			cNote		cnG2, $0A
			cRelease	$04
			cNote		cnG1, $05
			cNote		cnG1
			cNote		cnG1
			cNote		cnG1
			cRelease	$01
			cNote		cnG2, $0A
			cRelease	$04
			cNote		cnG1, $05
			cNote		cnG1
			cNote		cnG1
			cNote		cnG1
			cRelease	$04
			cNote		cnG1
			cNote		cnG1
			cNote		cnG1
			cNote		cnG1
			cRelease	$01
			cNote		cnG2, $0A
			cRelease	$04
			cNote		cnG1, $05
			cNote		cnG1
			cNote		cnG1
			cNote		cnG1
			cRelease	$01
			cNote		cnG2, $0A
			cRelease	$04
			cNote		cnG1, $05
			cNote		cnG1
			cNote		cnG1
			cNote		cnG1
			cRelease	$04
			cNote		cnE1
			cNote		cnE1
			cNote		cnE1
			cNote		cnE1
			cRelease	$01
			cNote		cnE2, $0A
			cRelease	$04
			cNote		cnE1, $05
			cNote		cnE1
			cNote		cnE1
			cNote		cnE1
			cRelease	$01
			cNote		cnE2, $0A
			cRelease	$04
			cNote		cnE1, $05
			cNote		cnE1
			cNote		cnE1
			cNote		cnE1
			cNote		cnE1
			cNote		cnE1
			cNote		cnE1
			cNote		cnE1
			cRelease	$01
			cNote		cnE2, $0A
			cRelease	$04
			cNote		cnE1, $05
			cNote		cnE1
			cNote		cnE1
			cNote		cnE1
			cRelease	$01
			cNote		cnE2, $0A
			cRelease	$04
			cNote		cnE1, $05
			cNote		cnE1
			cNote		cnE1
			cNote		cnE1
			cNote		cnG1
			cNote		cnG1
			cNote		cnG1
			cNote		cnG1
			cRelease	$01
			cNote		cnG2, $0A
			cRelease	$04
			cNote		cnG1, $05
			cNote		cnG1
			cNote		cnG1
			cNote		cnG1
			cRelease	$01
			cNote		cnG2, $0A
			cRelease	$04
			cNote		cnG1, $05
			cNote		cnG1
			cNote		cnG1
			cNote		cnG1
			cNote		cnD1
			cNote		cnD1
			cNote		cnD1
			cNote		cnD1
			cRelease	$01
			cNote		cnD2, $0A
			cRelease	$04
			cNote		cnD1, $05
			cNote		cnD1
			cNote		cnD1
			cNote		cnD1
			cRelease	$01
			cNote		cnD2, $0A
			cRelease	$04
			cNote		cnDs1, $05
			cNote		cnDs1
			cRelease	$01
			cNote		cnDs2, $0A
		cLoopCntEnd
		cNote		cnRst, $0A
		cNote		cnF3, $0D
		cNote		cnRst, $02
		cNote		cnE3, $0D
		cNote		cnRst, $02
		cNote		cnD3, $0D
		cNote		cnRst, $02
		cNote		cnC3, $0D
		cNote		cnRst, $02
		cNote		cnB2, $0A
		cNote		cnRst
		cNote		cnE3, $0D
		cNote		cnRst, $02
		cNote		cnD3, $0D
		cNote		cnRst, $02
		cNote		cnC3, $0D
		cNote		cnRst, $02
		cNote		cnB2, $0D
		cNote		cnRst, $02
		cNote		cnA2, $0A
		cNote		cnRst
		cNote		cnD3, $0D
		cNote		cnRst, $02
		cNote		cnC3, $0D
		cNote		cnRst, $02
		cNote		cnB2, $0D
		cNote		cnRst, $02
		cNote		cnA2, $0D
		cNote		cnRst, $02
		cNote		cnG2, $0A
		cNote		cnRst
		cNote		cnC3, $0D
		cNote		cnRst, $02
		cNote		cnB2, $0D
		cNote		cnRst, $02
		cNote		cnA2, $0D
		cNote		cnRst, $02
		cNote		cnG2, $0D
		cNote		cnRst, $02
		cNote		cnF2, $0A
	cLoopEnd
	cStop

Song12_FM3:
	cInsFM		patch0E
	cVolFM		$0E
	cRelease	$01
	cVibrato	$02, $0A
	cPan		cpCenter
	cNoteShift	$00, $00, $00
	cVolFM		$00
	cVolFM		$0C
	cLoopCnt	$07
		cNote		cnA1, $05
		cNote		cnRst
		cNote		cnA1
		cNote		cnRst
		cNote		cnA2, $0D
		cNote		cnRst, $07
		cNote		cnA1, $03
		cNote		cnRst, $02
		cNote		cnA2, $05
		cNote		cnRst, $0A
		cNote		cnA2, $0D
		cNote		cnRst, $07
	cLoopCntEnd
	cLoopStart
		cLoopCnt	$03
			cNote		cnE1, $0A
			cNote		cnE1
			cNote		cnE2
			cNote		cnE1
			cNote		cnE1
			cNote		cnE2
			cNote		cnE1
			cNote		cnE1
			cNote		cnE1
			cNote		cnE1
			cNote		cnE2
			cNote		cnE1
			cNote		cnE1
			cNote		cnE2
			cNote		cnE1
			cNote		cnE1
			cNote		cnG1
			cNote		cnG1
			cNote		cnG2
			cNote		cnG1
			cNote		cnG1
			cNote		cnG2
			cNote		cnG1
			cNote		cnG1
			cNote		cnG1
			cNote		cnG1
			cNote		cnG2
			cNote		cnG1
			cNote		cnG1
			cNote		cnG2
			cNote		cnG1
			cNote		cnG1
			cNote		cnE1
			cNote		cnE1
			cNote		cnE2
			cNote		cnE1
			cNote		cnE1
			cNote		cnE2
			cNote		cnE1
			cNote		cnE1
			cNote		cnE1
			cNote		cnE1
			cNote		cnE2
			cNote		cnE1
			cNote		cnE1
			cNote		cnE2
			cNote		cnE1
			cNote		cnE1
			cNote		cnG1
			cNote		cnG1
			cNote		cnG2
			cNote		cnG1
			cNote		cnG1
			cNote		cnG2
			cNote		cnG1
			cNote		cnG1
			cNote		cnD1
			cNote		cnD1
			cNote		cnD2
			cNote		cnD1
			cNote		cnD1
			cNote		cnD2
			cNote		cnDs1
			cNote		cnDs2
		cLoopCntEnd
		cNote		cnRst, $0A
		cNote		cnF2, $0D
		cNote		cnRst, $02
		cNote		cnE2, $0D
		cNote		cnRst, $02
		cNote		cnD2, $0D
		cNote		cnRst, $02
		cNote		cnC2, $0D
		cNote		cnRst, $02
		cNote		cnB1, $0A
		cNote		cnRst
		cNote		cnE2, $0D
		cNote		cnRst, $02
		cNote		cnD2, $0D
		cNote		cnRst, $02
		cNote		cnC2, $0D
		cNote		cnRst, $02
		cNote		cnB1, $0D
		cNote		cnRst, $02
		cNote		cnA1, $0A
		cNote		cnRst
		cNote		cnD2, $0D
		cNote		cnRst, $02
		cNote		cnC2, $0D
		cNote		cnRst, $02
		cNote		cnB1, $0D
		cNote		cnRst, $02
		cNote		cnA1, $0D
		cNote		cnRst, $02
		cNote		cnG1, $0A
		cNote		cnRst
		cNote		cnC2, $0D
		cNote		cnRst, $02
		cNote		cnB1, $0D
		cNote		cnRst, $02
		cNote		cnA1, $0D
		cNote		cnRst, $02
		cNote		cnG1, $0D
		cNote		cnRst, $02
		cNote		cnF1, $0A
	cLoopEnd
	cStop

Song12_FM4:
	cNote		cnRst, $0C
	cRelease	$01
	cVibrato	$02, $0A
	cPan		cpCenter
	cNoteShift	$00, $04, $00
	cLoopCnt	$03
		cInsFM		patch12
		cVolFM		$08
		cNote		cnA1, $05
		cNote		cnA1
		cNote		cnA1
		cNote		cnA1
		cNote		cnD3, $0A
		cNote		cnA1, $05
		cNote		cnA1
		cNote		cnA1
		cNote		cnA1
		cNote		cnC3, $0A
		cNote		cnA1, $05
		cNote		cnA1
		cNote		cnA1
		cNote		cnFs2
		cNote		cnD3, $0A
		cNote		cnA1, $05
		cNote		cnA1
		cNote		cnA1
		cNote		cnA1
		cNote		cnC3, $0A
		cNote		cnA1, $05
		cNote		cnA1
		cNote		cnA1
		cNote		cnA1
		cNote		cnC3, $0A
		cNote		cnD3
	cLoopCntEnd
	cLoopStart
		cLoopCnt	$01
			cInsFM		patch26
			cVolFM		$09
			cNote		cnE3, $05
			cNote		cnFs3
			cNote		cnG3
			cNote		cnE3
			cNote		cnB3, $0A
			cNote		cnE3, $05
			cNote		cnFs3
			cNote		cnG3
			cNote		cnE3
			cNote		cnC4, $0A
			cNote		cnE3, $05
			cNote		cnFs3
			cNote		cnG3
			cNote		cnE3
			cNote		cnD4, $0A
			cNote		cnE3, $05
			cNote		cnFs3
			cNote		cnG3
			cNote		cnE3
			cNote		cnC4, $0A
			cNote		cnFs3, $05
			cNote		cnG3
			cNote		cnA3
			cNote		cnG3
			cNote		cnFs3
			cNote		cnD3
			cNote		cnE3
			cNote		cnFs3
			cNote		cnFs3
			cNote		cnG3
			cNote		cnB3, $0A
			cNote		cnE3, $05
			cNote		cnFs3
			cNote		cnG3
			cNote		cnE3
			cNote		cnC4, $0A
			cNote		cnE3, $05
			cNote		cnFs3
			cNote		cnG3
			cNote		cnE3
			cNote		cnD4, $0A
			cNote		cnE3, $05
			cNote		cnFs3
			cNote		cnG3
			cNote		cnE3
			cNote		cnC4, $0A
			cNote		cnE3, $05
			cNote		cnFs3
			cNote		cnG3
			cNote		cnA3
			cNote		cnG3
			cNote		cnFs3
			cNote		cnG3
			cNote		cnA3
			cNote		cnB3
			cNote		cnC4
		cLoopCntEnd
		cLoopCnt	$01
			cSlide		$7A
			cNote		cnE4, $0A
			cNote		cnG4, $14
			cNote		cnE4, $0A
			cNote		cnA4, $14
			cNote		cnE4, $0A
			cNote		cnG4, $14
			cNote		cnE4, $0A
			cNote		cnA4, $14
			cNote		cnG4, $0A
			cNote		cnFs4
			cNote		cnE4
			cNote		cnFs4
			cNote		cnE4
			cNote		cnG4, $14
			cNote		cnE4, $0A
			cNote		cnA4, $14
			cNote		cnE4, $0A
			cNote		cnG4, $14
			cNote		cnE4, $0A
			cNote		cnB4, $14
			cNote		cnA4, $0A
			cNote		cnG4
			cNote		cnFs4
			cNote		cnD4
		cLoopCntEnd
		cInsFM		patch12
		cVolFM		$09
		cNote		cnE3, $05
		cNote		cnG3
		cNote		cnB3
		cNote		cnD4
		cNote		cnC4
		cNote		cnB3
		cNote		cnA3
		cNote		cnG3
		cNote		cnC4
		cNote		cnA3
		cNote		cnB3
		cNote		cnG3
		cNote		cnA3
		cNote		cnFs3
		cNote		cnG3
		cNote		cnE3
		cNote		cnFs3
		cNote		cnD3
		cNote		cnE3
		cNote		cnC3
		cNote		cnD3
		cNote		cnB2
		cNote		cnC3
		cNote		cnA2
		cNote		cnB2
		cNote		cnG2
		cNote		cnA2
		cNote		cnFs2
		cNote		cnG2
		cNote		cnE2
		cNote		cnFs2
		cNote		cnD2
		cNote		cnFs2, $1E
		cNote		cnE2, $05
		cNote		cnD2
		cNote		cnE2, $0A
		cNote		cnFs2, $1E
		cNote		cnFs2
		cNote		cnE2, $05
		cNote		cnD2
		cNote		cnE2, $0A
		cNote		cnFs2
		cNote		cnG2, $05
		cNote		cnA2
		cNote		cnB2
		cNote		cnC3
		cNote		cnB2, $1E
		cNote		cnB2, $05
		cNote		cnC3
		cNote		cnA2, $1E
		cNote		cnA2, $05
		cNote		cnB2
		cNote		cnG2, $1E
		cNote		cnG2, $05
		cNote		cnA2
		cNote		cnFs2, $1E
		cNote		cnE2, $05
		cNote		cnD2
		cNote		cnE2, $07
		cNote		cnE2
		cNote		cnFs2, $06
		cNote		cnFs2, $07
		cNote		cnG2
		cNote		cnG2, $06
		cNote		cnA2, $07
		cNote		cnA2
		cNote		cnG2, $06
		cNote		cnG2, $07
		cNote		cnFs2
		cNote		cnFs2, $06
		cVolFM		$0C
		cSustain
		cNote		cnD2, $14
		cRelease	$01
		cSlide		$03
		cNote		cnD0, $3C
		cVolFM		$09
		cSlideStop
		cNote		cnE3, $05
		cNote		cnG3
		cNote		cnB3
		cNote		cnD3
		cNote		cnFs3
		cNote		cnA3
		cNote		cnE3
		cNote		cnG3
		cNote		cnB3
		cNote		cnD3
		cNote		cnFs3
		cNote		cnA3
		cNote		cnE3
		cNote		cnG3
		cNote		cnB3
		cNote		cnD3
		cNote		cnFs3
		cNote		cnA3
		cNote		cnE3
		cNote		cnG3
		cNote		cnB3
		cNote		cnD3
		cNote		cnFs3
		cNote		cnA3
		cNote		cnE3
		cNote		cnG3
		cNote		cnB3
		cNote		cnD3
		cNote		cnFs3
		cNote		cnA3
		cNote		cnE3
		cNote		cnG3
		cNote		cnB3
		cNote		cnD3
		cNote		cnFs3
		cNote		cnA3
		cNote		cnE3
		cNote		cnG3
		cNote		cnB3
		cNote		cnD3
		cNote		cnFs3
		cNote		cnA3
		cNote		cnE3
		cNote		cnG3
		cNote		cnB3
		cNote		cnD3
		cNote		cnFs3
		cNote		cnA3
		cNote		cnB3
		cNote		cnD4
		cNote		cnC4
		cNote		cnB3
		cNote		cnA3
		cNote		cnC4
		cNote		cnB3
		cNote		cnA3
		cNote		cnG3
		cNote		cnB3
		cNote		cnA3
		cNote		cnG3
		cNote		cnFs3
		cNote		cnA3
		cNote		cnG3
		cNote		cnFs3
		cNote		cnE3
		cNote		cnD3
		cNote		cnE3
		cNote		cnFs3
		cNote		cnG3, $0A
		cNote		cnG3, $05
		cNote		cnFs3
		cNote		cnG3
		cNote		cnA3
		cNote		cnB3, $0A
		cNote		cnA3, $05
		cNote		cnB3
		cNote		cnC4
		cNote		cnD4
		cNote		cnG3
		cNote		cnB3
		cNote		cnD3
		cNote		cnG3
		cNote		cnB3
		cNote		cnD3
		cNote		cnG3
		cNote		cnA3
		cNote		cnD3
		cNote		cnG3
		cNote		cnB3
		cNote		cnD3
		cNote		cnG3
		cNote		cnA3
		cNote		cnD3
		cNote		cnG3
		cNote		cnG3
		cNote		cnC3
		cNote		cnE3
		cNote		cnG3
		cNote		cnC3
		cNote		cnE3
		cNote		cnA3
		cNote		cnC3
		cNote		cnE3
		cNote		cnG3
		cNote		cnC3
		cNote		cnE3
		cNote		cnA3
		cNote		cnC3
		cNote		cnE3
		cNote		cnG3
		cNote		cnB2
		cNote		cnD3
		cNote		cnFs3
		cNote		cnB2
		cNote		cnD3
		cNote		cnFs3
		cNote		cnB2
		cNote		cnD3
		cNote		cnB4, $03
		cNote		cnAs4, $02
		cNote		cnA4, $03
		cNote		cnGs4, $02
		cNote		cnG4, $03
		cNote		cnFs4, $02
		cNote		cnF4, $03
		cNote		cnE4, $02
		cNote		cnDs4, $03
		cNote		cnD4, $02
		cNote		cnCs4, $03
		cNote		cnC4, $02
		cNote		cnB3, $03
		cNote		cnAs3, $02
		cNote		cnA3, $03
		cNote		cnGs3, $02
		cNote		cnRst, $0A
		cNote		cnA3, $0D
		cNote		cnRst, $02
		cNote		cnG3, $0D
		cNote		cnRst, $02
		cNote		cnF3, $0D
		cNote		cnRst, $02
		cNote		cnE3, $0C
		cNote		cnRst, $03
		cNote		cnD3, $0A
		cNote		cnRst
		cNote		cnG3, $0D
		cNote		cnRst, $02
		cNote		cnF3, $0D
		cNote		cnRst, $02
		cNote		cnE3, $0D
		cNote		cnRst, $02
		cNote		cnD3, $0D
		cNote		cnRst, $02
		cNote		cnC3, $0A
		cNote		cnRst
		cNote		cnF3, $0D
		cNote		cnRst, $02
		cNote		cnE3, $0D
		cNote		cnRst, $02
		cNote		cnD3, $0D
		cNote		cnRst, $02
		cNote		cnC3, $0D
		cNote		cnRst, $02
		cNote		cnB2, $0A
		cNote		cnRst
		cNote		cnE3, $0D
		cNote		cnRst, $02
		cNote		cnD3, $0D
		cNote		cnRst, $02
		cNote		cnC3, $0D
		cNote		cnRst, $02
		cNote		cnB2, $0D
		cNote		cnRst, $02
		cNote		cnA2, $0A
	cLoopEnd
	cStop

Song12_FM5:
	cNote		cnRst, $01
	cRelease	$01
	cVibrato	$02, $0A
	cPan		cpRight
	cNoteShift	$00, $02, $00
	cInsFM		patch12
	cVolFM		$09
	cLoopCnt	$03
		cNote		cnRst, $14
		cNote		cnA2, $09
		cNote		cnRst, $15
		cNote		cnG2, $09
		cNote		cnRst, $15
		cNote		cnA2, $09
		cNote		cnRst, $15
		cNote		cnG2, $09
		cNote		cnRst, $15
		cNote		cnG2, $0A
		cNote		cnA2
	cLoopCntEnd
	cLoopStart
		cLoopCnt	$03
			cRelease	$04
			cNote		cnE1, $05
			cNote		cnE1
			cNote		cnE1
			cNote		cnE1
			cRelease	$01
			cNote		cnE2, $0A
			cRelease	$04
			cNote		cnE1, $05
			cNote		cnE1
			cNote		cnE1
			cNote		cnE1
			cRelease	$01
			cNote		cnE2, $0A
			cRelease	$04
			cNote		cnE1, $05
			cNote		cnE1
			cNote		cnE1
			cNote		cnE1
			cRelease	$04
			cNote		cnE1
			cNote		cnE1
			cNote		cnE1
			cNote		cnE1
			cRelease	$01
			cNote		cnE2, $0A
			cRelease	$04
			cNote		cnE1, $05
			cNote		cnE1
			cNote		cnE1
			cNote		cnE1
			cRelease	$04
			cNote		cnE2, $0A
			cRelease	$04
			cNote		cnE1, $05
			cNote		cnE1
			cNote		cnE1
			cNote		cnE1
			cRelease	$04
			cNote		cnG1
			cNote		cnG1
			cNote		cnG1
			cNote		cnG1
			cRelease	$01
			cNote		cnG2, $0A
			cRelease	$04
			cNote		cnG1, $05
			cNote		cnG1
			cNote		cnG1
			cNote		cnG1
			cRelease	$01
			cNote		cnG2, $0A
			cRelease	$04
			cNote		cnG1, $05
			cNote		cnG1
			cNote		cnG1
			cNote		cnG1
			cRelease	$04
			cNote		cnG1
			cNote		cnG1
			cNote		cnG1
			cNote		cnG1
			cRelease	$01
			cNote		cnG2, $0A
			cRelease	$04
			cNote		cnG1, $05
			cNote		cnG1
			cNote		cnG1
			cNote		cnG1
			cRelease	$01
			cNote		cnG2, $0A
			cRelease	$04
			cNote		cnG1, $05
			cNote		cnG1
			cNote		cnG1
			cNote		cnG1
			cRelease	$04
			cNote		cnE1
			cNote		cnE1
			cNote		cnE1
			cNote		cnE1
			cRelease	$01
			cNote		cnE2, $0A
			cRelease	$04
			cNote		cnE1, $05
			cNote		cnE1
			cNote		cnE1
			cNote		cnE1
			cRelease	$01
			cNote		cnE2, $0A
			cRelease	$04
			cNote		cnE1, $05
			cNote		cnE1
			cNote		cnE1
			cNote		cnE1
			cNote		cnE1
			cNote		cnE1
			cNote		cnE1
			cNote		cnE1
			cRelease	$01
			cNote		cnE2, $0A
			cRelease	$04
			cNote		cnE1, $05
			cNote		cnE1
			cNote		cnE1
			cNote		cnE1
			cRelease	$01
			cNote		cnE2, $0A
			cRelease	$04
			cNote		cnE1, $05
			cNote		cnE1
			cNote		cnE1
			cNote		cnE1
			cNote		cnG1
			cNote		cnG1
			cNote		cnG1
			cNote		cnG1
			cRelease	$01
			cNote		cnG2, $0A
			cRelease	$04
			cNote		cnG1, $05
			cNote		cnG1
			cNote		cnG1
			cNote		cnG1
			cRelease	$01
			cNote		cnG2, $0A
			cRelease	$04
			cNote		cnG1, $05
			cNote		cnG1
			cNote		cnG1
			cNote		cnG1
			cNote		cnD1
			cNote		cnD1
			cNote		cnD1
			cNote		cnD1
			cRelease	$01
			cNote		cnD2, $0A
			cRelease	$04
			cNote		cnD1, $05
			cNote		cnD1
			cNote		cnD1
			cNote		cnD1
			cRelease	$01
			cNote		cnD2, $0A
			cRelease	$04
			cNote		cnDs1, $05
			cNote		cnDs1
			cRelease	$01
			cNote		cnDs2, $0A
		cLoopCntEnd
		cNote		cnRst, $0A
		cNote		cnF3, $0D
		cNote		cnRst, $02
		cNote		cnE3, $0D
		cNote		cnRst, $02
		cNote		cnD3, $0D
		cNote		cnRst, $02
		cNote		cnC3, $0D
		cNote		cnRst, $02
		cNote		cnB2, $0A
		cNote		cnRst
		cNote		cnE3, $0D
		cNote		cnRst, $02
		cNote		cnD3, $0D
		cNote		cnRst, $02
		cNote		cnC3, $0D
		cNote		cnRst, $02
		cNote		cnB2, $0D
		cNote		cnRst, $02
		cNote		cnA2, $0A
		cNote		cnRst
		cNote		cnD3, $0D
		cNote		cnRst, $02
		cNote		cnC3, $0D
		cNote		cnRst, $02
		cNote		cnB2, $0D
		cNote		cnRst, $02
		cNote		cnA2, $0D
		cNote		cnRst, $02
		cNote		cnG2, $0A
		cNote		cnRst
		cNote		cnC3, $0D
		cNote		cnRst, $02
		cNote		cnB2, $0D
		cNote		cnRst, $02
		cNote		cnA2, $0D
		cNote		cnRst, $02
		cNote		cnG2, $0D
		cNote		cnRst, $02
		cNote		cnF2, $0A
	cLoopEnd
	cStop

Song12_DAC:
	cLoopCnt	$03
		cPan		cpCenter
		cNote		cnC0, $0A
		cNote		cnC0
		cNote		cnCs0, $14
		cNote		cnC0, $05
		cNote		cnCs0
		cNote		cnC0, $0A
		cNote		cnCs0, $14
		cNote		cnC0, $0A
		cNote		cnC0
		cNote		cnCs0, $14
		cNote		cnC0, $05
		cNote		cnCs0
		cNote		cnC0, $0A
		cNote		cnCs0
		cNote		cnCs0, $05
		cNote		cnCs0
	cLoopCntEnd
	cLoopStart
		cLoopCnt	$0F
			cPan		cpCenter
			cNote		cnC0, $0A
			cNote		cnC0
			cNote		cnCs0, $14
			cNote		cnC0, $05
			cNote		cnCs0
			cNote		cnC0, $0A
			cNote		cnCs0
			cNote		cnCs0, $05
			cNote		cnCs0
			cNote		cnC0, $0A
			cNote		cnC0
			cNote		cnCs0, $14
			cNote		cnC0, $05
			cNote		cnCs0
			cNote		cnC0, $0A
			cNote		cnCs0, $14
		cLoopCntEnd
		cLoopCnt	$02
			cPan		cpCenter
			cNote		cnCs0, $01
			cNote		cnCs0, $09
			cPan		cpLeft
			cNote		cnD0, $05
			cPan		cpCenter
			cNote		cnDs0
			cPan		cpRight
			cNote		cnE0
			cPan		cpLeft
			cNote		cnD0
			cPan		cpCenter
			cNote		cnDs0
			cPan		cpRight
			cNote		cnE0
			cPan		cpLeft
			cNote		cnD0
			cPan		cpCenter
			cNote		cnDs0
			cPan		cpRight
			cNote		cnE0
			cPan		cpLeft
			cNote		cnD0
			cPan		cpCenter
			cNote		cnDs0
			cPan		cpRight
			cNote		cnE0
			cPan		cpLeft
			cNote		cnD0
			cPan		cpCenter
			cNote		cnDs0
		cLoopCntEnd
		cPan		cpCenter
		cNote		cnCs0, $01
		cNote		cnCs0, $09
		cPan		cpLeft
		cNote		cnD0, $04
		cNote		cnD0, $03
		cNote		cnD0, $03
		cNote		cnD0, $04
		cNote		cnD0, $03
		cNote		cnD0, $03
		cPan		cpCenter
		cNote		cnDs0, $04
		cNote		cnDs0, $03
		cNote		cnDs0, $03
		cNote		cnDs0, $04
		cNote		cnDs0, $03
		cNote		cnDs0, $03
		cPan		cpRight
		cNote		cnE0, $04
		cNote		cnE0, $03
		cNote		cnE0, $03
		cNote		cnE0, $04
		cNote		cnE0, $03
		cNote		cnE0, $03
		cPan		cpCenter
		cNote		cnCs0, $05
		cNote		cnCs0
	cLoopEnd
	cStop

Song12_PSG1:

Song12_PSG2:

Song12_PSG3:

Song12_Noise:
	cInsVolPSG	$00, $00
	cStop
