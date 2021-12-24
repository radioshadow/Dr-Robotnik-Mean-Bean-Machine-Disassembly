Song10_Start:
	cType		ctMusic
	cFadeOut	$0000
	cTempo		$BB
	cChannel	Song10_FM1
	cChannel	Song10_FM2
	cChannel	Song10_FM3
	cChannel	Song10_FM4
	cChannel	Song10_FM5
	cChannel	Song10_DAC
	cChannel	Song10_PSG1
	cChannel	Song10_PSG2
	cChannel	Song10_PSG3
	cChannel	Song10_Noise

Song10_FM1:
	cLoopStart
		cInsFM		patch07
		cVolFM		$0C
		cRelease	$01
		cVibrato	$02, $0A
		cPan		cpCenter
		cLoopCnt	$03
			cNote		cnRst, $60
		cLoopCntEnd
		cVoltaLoop
			cLoopCnt	$01
				cInsFM		patch07
				cVolFM		$0E
				cSlideStop
				cRelease	$02
				cNote		cnRst, $0C
				cNote		cnCs4, $18
				cSlide		$16
				cNote		cnA3, $0C
				cNote		cnB3, $18
				cNote		cnA3, $0C
				cNote		cnB3
				cNote		cnD4
				cNote		cnD4
				cNote		cnCs4
				cNote		cnB3
				cNote		cnA3
				cNote		cnB3, $24
				cNote		cnRst, $0C
				cNote		cnCs4, $18
				cNote		cnA3, $0C
				cNote		cnB3, $18
				cNote		cnA3, $0C
				cNote		cnB3
				cNote		cnFs3
				cNote		cnFs3
				cNote		cnE3
				cNote		cnD3, $3C
			cLoopCntEnd
			cSlideStop
			cInsFM		patch22
			cVolFM		$0B
			cRelease	$03
			cNote		cnE2, $0C
			cSlide		$7E
			cNote		cnE3, $06
			cNote		cnRst, $12
			cNote		cnE2, $06
			cNote		cnRst
			cNote		cnE2, $0C
			cNote		cnE3, $06
			cNote		cnRst
			cNote		cnE2, $0C
			cNote		cnE3, $04
			cNote		cnRst, $08
			cNote		cnE2, $0C
			cNote		cnE3, $06
			cNote		cnRst
			cNote		cnE2, $0C
			cNote		cnE3, $06
			cNote		cnRst, $36
			cNote		cnE2, $0C
			cNote		cnE3, $06
			cNote		cnRst, $12
			cNote		cnE2, $06
			cNote		cnRst
			cNote		cnE2, $0C
			cNote		cnE3, $06
			cNote		cnRst
			cNote		cnE2, $0C
			cNote		cnE3, $06
			cNote		cnRst
			cVoltaSect1
				cInsFM		patch22
				cRelease	$01
				cVolFM		$0B
				cRelease	$05
				cNote		cnE3, $0C
				cNote		cnE4
				cNote		cnE4, $00
				cSlide		$01
				cNote		cnDs4, $0C
				cSlideStop
				cNote		cnE4, $00
				cSlide		$02
				cNote		cnDs4, $0C
				cSlideStop
				cNote		cnE4, $00
				cSlide		$04
				cNote		cnD4, $0C
				cSlideStop
				cNote		cnE4, $00
				cSlide		$07
				cNote		cnD4, $0C
				cSlideStop
				cNote		cnE4, $00
				cSlide		$0C
				cNote		cnCs4, $0C
				cSlideStop
				cNote		cnE4, $00
				cSlide		$14
				cNote		cnC4, $0C
				cSlideStop
				cNoteShift	$00, $00, $00
				cRelease	$01
			cVoltaSectEnd
			cVoltaSect2
				cNote		cnRst, $60
				cInsFM		patch1F
				cVolFM		$0D
				cSlideStop
				cRelease	$02
				cNote		cnRst, $0C
				cNote		cnB3, $00
				cSlide		$50
				cNote		cnD4, $0C
				cNote		cnD4
				cNote		cnD4
				cNote		cnD4
				cNote		cnD4
				cNote		cnD4
				cNote		cnD4
				cNote		cnE4, $18
				cNote		cnD4, $0C
				cNote		cnCs4, $18
				cNote		cnB3, $24
				cNote		cnRst, $0C
				cNote		cnD4
				cNote		cnD4
				cNote		cnD4
				cNote		cnD4
				cNote		cnD4
				cNote		cnD4
				cNote		cnD4
				cNote		cnGs3, $18
				cNote		cnB3, $0C
				cNote		cnE4, $18
				cNote		cnD4, $24
				cNote		cnRst, $0C
				cNote		cnD4
				cNote		cnD4
				cNote		cnD4
				cNote		cnD4
				cNote		cnD4
				cNote		cnD4
				cNote		cnD4
				cNote		cnE4, $18
				cNote		cnD4, $0C
				cNote		cnCs4, $18
				cNote		cnB3, $0C
				cNote		cnA3
				cNote		cnB3
				cNote		cnCs4, $60
				cNote		cnB3, $24
				cNote		cnCs4
				cNote		cnA3, $18
				cNote		cnCs4, $60
				cNote		cnB3, $24
				cNote		cnCs4
				cNote		cnA3, $18
	cLoopEnd
	cStop

Song10_FM2:
	cLoopStart
		cInsFM		patch01
		cVolFM		$0B
		cRelease	$01
		cVibrato	$02, $0A
		cPan		cpRight
		cLoopCnt	$0C
			cRelease	$02
			cNote		cnCs3, $0C
			cNote		cnCs3
			cNote		cnCs3
			cNote		cnCs3
			cNote		cnCs3
			cNote		cnCs3
			cNote		cnCs3
			cNote		cnCs3
			cNote		cnD3
			cNote		cnD3
			cNote		cnD3
			cNote		cnD3
			cNote		cnD3
			cNote		cnD3
			cNote		cnD3
			cNote		cnD3
			cSlideStop
		cLoopCntEnd
		cNote		cnCs3, $0C
		cNote		cnCs3
		cNote		cnCs3
		cNote		cnCs3
		cNote		cnCs3
		cNote		cnCs3
		cNote		cnCs3
		cNote		cnCs3
		cInsFM		patch06
		cVolFM		$0E
		cRelease	$01
		cNote		cnC4, $01
		cSlide		$18
		cNote		cnRst, $0B
		cNote		cnE4, $0C
		cNote		cnC4, $01
		cNote		cnRst, $0B
		cNote		cnE4, $0C
		cNote		cnC4, $01
		cNote		cnRst, $0B
		cNote		cnE4, $0C
		cNote		cnC4, $01
		cNote		cnRst, $0B
		cNote		cnE4, $0C
		cSlideStop
		cInsFM		patch1F
		cVolFM		$0B
		cNote		cnRst
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

Song10_FM3:
	cLoopStart
		cInsFM		patch0E
		cVolFM		$0C
		cRelease	$03
		cVibrato	$02, $0A
		cPan		cpCenter
		cLoopCnt	$0D
			cNote		cnA1, $0C
			cNote		cnA1
			cNote		cnB1
			cNote		cnB1
			cNote		cnC2
			cNote		cnC2
			cNote		cnCs2
			cNote		cnCs2
			cNote		cnD2
			cNote		cnD2
			cNote		cnFs2
			cNote		cnFs2
			cNote		cnD2
			cNote		cnD2
			cNote		cnE2
			cNote		cnE2
		cLoopCntEnd
		cLoopCnt	$02
			cNote		cnD2, $0C
			cNote		cnD2
			cNote		cnE2
			cNote		cnE2
			cNote		cnFs2
			cNote		cnFs2
			cNote		cnGs2
			cNote		cnGs2
			cNote		cnE2
			cNote		cnE2
			cNote		cnFs2
			cNote		cnFs2
			cNote		cnGs2
			cNote		cnGs2
			cNote		cnB2
			cNote		cnB2
		cLoopCntEnd
		cLoopCnt	$07
			cNote		cnFs2, $0C
		cLoopCntEnd
		cLoopCnt	$03
			cNote		cnD2, $0C
		cLoopCntEnd
		cLoopCnt	$03
			cNote		cnE2, $0C
		cLoopCntEnd
		cLoopCnt	$07
			cNote		cnFs2, $0C
		cLoopCntEnd
		cLoopCnt	$07
			cNote		cnD2, $0C
		cLoopCntEnd
	cLoopEnd
	cStop

Song10_FM4:
	cLoopStart
		cInsFM		patch01
		cVolFM		$0B
		cRelease	$01
		cVibrato	$02, $0A
		cPan		cpLeft
		cLoopCnt	$1A
			cRelease	$02
			cNote		cnA2, $0C
			cNote		cnA2
			cNote		cnA2
			cNote		cnA2
			cNote		cnA2
			cNote		cnA2
			cNote		cnA2
			cNote		cnA2
		cLoopCntEnd
		cNote		cnRst, $02
		cInsFM		patch06
		cVolFM		$0E
		cRelease	$01
		cNote		cnC4, $01
		cSlide		$18
		cNote		cnRst, $0B
		cNote		cnE4, $0C
		cNote		cnC4, $01
		cNote		cnRst, $0B
		cNote		cnE4, $0C
		cNote		cnC4, $01
		cNote		cnRst, $0B
		cNote		cnE4, $0C
		cNote		cnC4, $01
		cNote		cnRst, $0B
		cNote		cnE4, $0A
		cSlideStop
		cInsFM		patch1F
		cVolFM		$0B
		cNote		cnRst, $0C
		cRelease	$01
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

Song10_FM5:
	cNote		cnRst, $10
	cLoopStart
		cInsFM		patch07
		cVolFM		$09
		cRelease	$01
		cVibrato	$02, $0A
		cPan		cpCenter
		cLoopCnt	$03
			cNote		cnRst, $60
		cLoopCntEnd
		cVoltaLoop
			cLoopCnt	$01
				cInsFM		patch07
				cVolFM		$0B
				cSlideStop
				cRelease	$02
				cNote		cnRst, $0C
				cNote		cnCs4, $18
				cSlide		$16
				cNote		cnA3, $0C
				cNote		cnB3, $18
				cNote		cnA3, $0C
				cNote		cnB3
				cNote		cnD4
				cNote		cnD4
				cNote		cnCs4
				cNote		cnB3
				cNote		cnA3
				cNote		cnB3, $24
				cNote		cnRst, $0C
				cNote		cnCs4, $18
				cNote		cnA3, $0C
				cNote		cnB3, $18
				cNote		cnA3, $0C
				cNote		cnB3
				cNote		cnFs3
				cNote		cnFs3
				cNote		cnE3
				cNote		cnD3, $3C
			cLoopCntEnd
			cSlideStop
			cInsFM		patch22
			cVolFM		$08
			cRelease	$03
			cNote		cnE2, $0C
			cSlide		$7E
			cNote		cnE3, $06
			cNote		cnRst, $12
			cNote		cnE2, $06
			cNote		cnRst
			cNote		cnE2, $0C
			cNote		cnE3, $06
			cNote		cnRst
			cNote		cnE2, $0C
			cNote		cnE3, $04
			cNote		cnRst, $08
			cNote		cnE2, $0C
			cNote		cnE3, $06
			cNote		cnRst
			cNote		cnE2, $0C
			cNote		cnE3, $06
			cNote		cnRst, $36
			cNote		cnE2, $0C
			cNote		cnE3, $06
			cNote		cnRst, $12
			cNote		cnE2, $06
			cNote		cnRst
			cNote		cnE2, $0C
			cNote		cnE3, $06
			cNote		cnRst
			cNote		cnE2, $0C
			cNote		cnE3, $06
			cNote		cnRst
			cVoltaSect1
				cInsFM		patch22
				cRelease	$01
				cVolFM		$08
				cRelease	$05
				cNote		cnE3, $0C
				cNote		cnE4
				cNote		cnE4, $00
				cSlide		$01
				cNote		cnDs4, $0C
				cSlideStop
				cNote		cnE4, $00
				cSlide		$02
				cNote		cnDs4, $0C
				cSlideStop
				cNote		cnE4, $00
				cSlide		$04
				cNote		cnD4, $0C
				cSlideStop
				cNote		cnE4, $00
				cSlide		$07
				cNote		cnD4, $0C
				cSlideStop
				cNote		cnE4, $00
				cSlide		$0C
				cNote		cnCs4, $0C
				cSlideStop
				cNote		cnE4, $00
				cSlide		$14
				cNote		cnC4, $0C
				cSlideStop
				cNoteShift	$00, $00, $00
				cRelease	$01
			cVoltaSectEnd
			cVoltaSect2
				cNote		cnRst, $60
				cInsFM		patch1F
				cVolFM		$09
				cSlideStop
				cRelease	$02
				cNote		cnRst, $0C
				cNote		cnB3, $00
				cSlide		$50
				cNote		cnD4, $0C
				cNote		cnD4
				cNote		cnD4
				cNote		cnD4
				cNote		cnD4
				cNote		cnD4
				cNote		cnD4
				cNote		cnE4, $18
				cNote		cnD4, $0C
				cNote		cnCs4, $18
				cNote		cnB3, $24
				cNote		cnRst, $0C
				cNote		cnD4
				cNote		cnD4
				cNote		cnD4
				cNote		cnD4
				cNote		cnD4
				cNote		cnD4
				cNote		cnD4
				cNote		cnGs3, $18
				cNote		cnB3, $0C
				cNote		cnE4, $18
				cNote		cnD4, $24
				cNote		cnRst, $0C
				cNote		cnD4
				cNote		cnD4
				cNote		cnD4
				cNote		cnD4
				cNote		cnD4
				cNote		cnD4
				cNote		cnD4
				cNote		cnE4, $18
				cNote		cnD4, $0C
				cNote		cnCs4, $18
				cNote		cnB3, $0C
				cNote		cnA3
				cNote		cnB3
				cNote		cnCs4, $60
				cNote		cnB3, $24
				cNote		cnCs4
				cNote		cnA3, $18
				cNote		cnCs4, $60
				cNote		cnB3, $24
				cNote		cnCs4
				cNote		cnA3, $18
	cLoopEnd
	cStop

Song10_DAC:
	cLoopStart
		cLoopCnt	$02
			cNote		cnC0, $18
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

Song10_PSG1:
	cStop

Song10_PSG2:
	cStop

Song10_PSG3:
	cStop

Song10_Noise:
	cStop
