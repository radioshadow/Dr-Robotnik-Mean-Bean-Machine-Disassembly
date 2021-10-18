Song13_Start:
	cType		ctMusic
	cFadeOut	$0000
	cTempo		$C4
	cChannel	Song13_FM1
	cChannel	Song13_FM2
	cChannel	Song13_FM3
	cChannel	Song13_FM4
	cChannel	Song13_FM5
	cChannel	Song13_DAC
	cChannel	Song13_PSG1
	cChannel	Song13_PSG2
	cChannel	Song13_PSG3
	cChannel	Song13_Noise

Song13_FM1:
	cLoopStart
		cInsFM		patch15
		cVolFM		$09
		cRelease	$01
		cVibrato	$02, $0A
		cPan		cpCenter
		cNoteShift	$00, $00, $00
		cLoopCnt	$03
			cNote		cnC3, $09
			cNote		cnRst, $03
			cNote		cnC3, $09
			cNote		cnRst, $03
			cNote		cnAs2, $09
			cNote		cnRst, $03
			cNote		cnAs2, $09
			cNote		cnRst, $03
			cNote		cnA2, $09
			cNote		cnRst, $03
			cNote		cnA2, $09
			cNote		cnRst, $03
			cNote		cnGs2, $09
			cNote		cnRst, $03
			cNote		cnG2, $09
			cNote		cnRst, $03
			cNote		cnF3, $09
			cNote		cnRst, $03
			cNote		cnF3, $09
			cNote		cnRst, $03
			cNote		cnDs3, $09
			cNote		cnRst, $03
			cNote		cnDs3, $09
			cNote		cnRst, $03
			cNote		cnD3, $09
			cNote		cnRst, $03
			cNote		cnD3, $09
			cNote		cnRst, $03
			cNote		cnCs3, $09
			cNote		cnRst, $03
			cNote		cnCs3, $09
			cNote		cnRst, $03
		cLoopCntEnd
		cInsFM		patch0A
		cVolFM		$0C
		cNote		cnC4, $60
		cNote		cnRst
		cNote		cnFs3
		cNote		cnRst
		cNote		cnC4, $90
		cNote		cnF4, $18
		cNote		cnDs4
		cNote		cnC4, $60
		cNote		cnRst
	cLoopEnd
	cStop

Song13_FM2:
	cLoopStart
		cRelease	$01
		cVibrato	$02, $0A
		cPan		cpCenter
		cNoteShift	$00, $00, $00
		cLoopCnt	$07
			cNote		cnRst, $60
		cLoopCntEnd
		cInsFM		patch1F
		cVolFM		$0B
		cRelease	$05
		cLoopCnt	$01
			cNote		cnG5, $06
			cNote		cnG5
			cNote		cnC6
			cNote		cnC6
			cNote		cnG5
			cNote		cnG5
			cNote		cnAs5
			cNote		cnAs5
			cNote		cnG5
			cNote		cnG5
			cNote		cnRst, $0C
			cNote		cnC6, $06
			cNote		cnC6
			cNote		cnRst, $0C
			cNote		cnG5, $06
			cNote		cnG5
			cNote		cnC6
			cNote		cnC6
			cNote		cnG5
			cNote		cnG5
			cNote		cnAs5
			cNote		cnAs5
			cNote		cnG5
			cNote		cnG5
			cNote		cnG5
			cNote		cnG5
			cNote		cnG5
			cNote		cnRst, $12
		cLoopCntEnd
		cNote		cnF5, $06
		cNote		cnF5
		cNote		cnB5
		cNote		cnB5
		cNote		cnF5
		cNote		cnF5
		cNote		cnC6
		cNote		cnC6
		cNote		cnF5
		cNote		cnF5
		cNote		cnRst, $0C
		cNote		cnB5, $06
		cNote		cnB5
		cNote		cnRst, $0C
		cNote		cnF5, $06
		cNote		cnF5
		cNote		cnB5
		cNote		cnB5
		cNote		cnF5
		cNote		cnF5
		cNote		cnC6
		cNote		cnC6
		cNote		cnF5
		cNote		cnF5
		cNote		cnF5
		cNote		cnF5
		cNote		cnF5
		cNote		cnRst, $12
		cNote		cnG5, $06
		cNote		cnG5
		cNote		cnC6
		cNote		cnC6
		cNote		cnG5
		cNote		cnG5
		cNote		cnAs5
		cNote		cnAs5
		cNote		cnG5
		cNote		cnG5
		cNote		cnRst, $0C
		cNote		cnC6, $06
		cNote		cnC6
		cNote		cnRst, $0C
		cNote		cnG5, $06
		cNote		cnG5
		cNote		cnC6
		cNote		cnC6
		cNote		cnG5
		cNote		cnG5
		cNote		cnAs5
		cNote		cnAs5
		cNote		cnG5
		cNote		cnG5
		cNote		cnG5
		cNote		cnG5
		cNote		cnG5
		cNote		cnRst, $12
	cLoopEnd
	cStop

Song13_FM3:
	cLoopStart
		cInsFM		patch0D
		cVolFM		$0C
		cRelease	$01
		cVibrato	$02, $0A
		cPan		cpCenter
		cNoteShift	$00, $00, $00
		cLoopCnt	$03
			cNote		cnC2, $0C
			cNote		cnRst
			cNote		cnC2
			cNote		cnAs1, $08
			cNote		cnRst, $10
			cNote		cnD2, $06
			cNote		cnRst
			cNote		cnDs2
			cNote		cnRst
			cNote		cnE2
			cNote		cnRst
			cNote		cnF2, $08
			cNote		cnRst, $10
			cNote		cnF2, $08
			cNote		cnRst, $04
			cNote		cnDs2, $08
			cNote		cnRst, $10
			cNote		cnA1, $08
			cNote		cnRst, $04
			cNote		cnAs1, $08
			cNote		cnRst, $04
			cNote		cnB1, $06
			cNote		cnRst
		cLoopCntEnd
		cLoopCnt	$01
			cNote		cnC2, $0C
			cNote		cnC2
			cNote		cnD2
			cNote		cnD2
			cNote		cnDs2
			cNote		cnDs2
			cNote		cnE2
			cNote		cnE2
			cNote		cnF2
			cNote		cnF2
			cNote		cnG2
			cNote		cnG2
			cNote		cnGs2
			cNote		cnGs2
			cNote		cnA2
			cNote		cnA2
		cLoopCntEnd
		cLoopCnt	$01
			cNote		cnC3, $0C
			cNote		cnC3
			cNote		cnAs2
			cNote		cnAs2
			cNote		cnA2
			cNote		cnA2
			cNote		cnGs2
			cNote		cnG2
			cNote		cnF3
			cNote		cnF3
			cNote		cnDs3
			cNote		cnDs3
			cNote		cnD3
			cNote		cnD3
			cNote		cnCs3
			cNote		cnCs3
		cLoopCntEnd
	cLoopEnd
	cStop

Song13_FM4:
	cNote		cnRst, $0A
	cLoopStart
		cInsFM		patch15
		cVolFM		$08
		cRelease	$01
		cVibrato	$02, $0A
		cPan		cpRight
		cNoteShift	$00, $02, $00
		cLoopCnt	$03
			cNote		cnC3, $09
			cNote		cnRst, $03
			cNote		cnC3, $09
			cNote		cnRst, $03
			cNote		cnAs2, $09
			cNote		cnRst, $03
			cNote		cnAs2, $09
			cNote		cnRst, $03
			cNote		cnA2, $09
			cNote		cnRst, $03
			cNote		cnA2, $09
			cNote		cnRst, $03
			cNote		cnGs2, $09
			cNote		cnRst, $03
			cNote		cnG2, $09
			cNote		cnRst, $03
			cNote		cnF3, $09
			cNote		cnRst, $03
			cNote		cnF3, $09
			cNote		cnRst, $03
			cNote		cnDs3, $09
			cNote		cnRst, $03
			cNote		cnDs3, $09
			cNote		cnRst, $03
			cNote		cnD3, $09
			cNote		cnRst, $03
			cNote		cnD3, $09
			cNote		cnRst, $03
			cNote		cnCs3, $09
			cNote		cnRst, $03
			cNote		cnCs3, $09
			cNote		cnRst, $03
		cLoopCntEnd
		cInsFM		patch0A
		cVolFM		$0D
		cNote		cnC4, $60
		cNote		cnRst
		cNote		cnFs3
		cNote		cnRst
		cNote		cnC4, $90
		cNote		cnF4, $18
		cNote		cnDs4
		cNote		cnC4, $60
		cNote		cnRst
	cLoopEnd
	cStop

Song13_FM5:
	cNote		cnRst, $15
	cLoopStart
		cInsFM		patch15
		cVolFM		$05
		cRelease	$01
		cVibrato	$02, $0A
		cPan		cpLeft
		cNoteShift	$00, $04, $00
		cLoopCnt	$03
			cNote		cnC3, $09
			cNote		cnRst, $03
			cNote		cnC3, $09
			cNote		cnRst, $03
			cNote		cnAs2, $09
			cNote		cnRst, $03
			cNote		cnAs2, $09
			cNote		cnRst, $03
			cNote		cnA2, $09
			cNote		cnRst, $03
			cNote		cnA2, $09
			cNote		cnRst, $03
			cNote		cnGs2, $09
			cNote		cnRst, $03
			cNote		cnG2, $09
			cNote		cnRst, $03
			cNote		cnF3, $09
			cNote		cnRst, $03
			cNote		cnF3, $09
			cNote		cnRst, $03
			cNote		cnDs3, $09
			cNote		cnRst, $03
			cNote		cnDs3, $09
			cNote		cnRst, $03
			cNote		cnD3, $09
			cNote		cnRst, $03
			cNote		cnD3, $09
			cNote		cnRst, $03
			cNote		cnCs3, $09
			cNote		cnRst, $03
			cNote		cnCs3, $09
			cNote		cnRst, $03
		cLoopCntEnd
		cInsFM		patch0A
		cVolFM		$0C
		cNote		cnC4, $60
		cNote		cnRst
		cNote		cnFs3
		cNote		cnRst
		cNote		cnC4, $90
		cNote		cnF4, $18
		cNote		cnDs4
		cNote		cnC4, $60
		cNote		cnRst
	cLoopEnd
	cStop

Song13_DAC:
	cLoopStart
		cNote		cnC0, $18
		cNote		cnCs0
		cNote		cnC0, $0C
		cNote		cnC0
		cNote		cnCs0, $18
		cNote		cnC0
		cNote		cnCs0, $12
		cNote		cnC0, $06
		cNote		cnC0, $0C
		cNote		cnC0
		cNote		cnCs0, $18
	cLoopEnd
	cStop

Song13_PSG1:
	cStop

Song13_PSG2:
	cStop

Song13_PSG3:
	cStop

Song13_Noise:
	cLoopStart
		cInsVolPSG	$0F, $0E
		cNote		cnG0, $0C
		cInsVolPSG	$0F, $0C
		cNote		cnG0, $0C
	cLoopEnd
	cStop
