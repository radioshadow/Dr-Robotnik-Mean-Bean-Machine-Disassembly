Song17_Start:
	cType		ctMusic
	cFadeOut	$0000
	cTempo		$B9
	cChannel	Song17_FM1
	cChannel	Song17_FM2
	cChannel	Song17_FM3
	cChannel	Song17_FM4
	cChannel	Song17_FM5
	cChannel	Song17_DAC
	cChannel	Song17_PSG1
	cChannel	Song17_PSG2
	cChannel	Song17_PSG3
	cChannel	Song17_Noise

Song17_FM1:
	cLoopStart
		cInsFM		patch39
		cVolFM		$0E
		cRelease	$01
		cVibrato	$02, $0A
		cPan		cpCenter
		cNote		cnD1, $0C
		cNote		cnRst, $18
		cNote		cnC2, $06
		cNote		cnD2
		cNote		cnRst
		cNote		cnF1, $12
		cNote		cnG1, $06
		cNote		cnRst
		cNote		cnF1
		cNote		cnRst
		cNote		cnG1, $12
		cNote		cnG1, $06
		cNote		cnRst, $0C
		cNote		cnF2, $06
		cNote		cnG2
		cNote		cnRst
		cNote		cnC2, $12
		cNote		cnB1, $06
		cNote		cnRst
		cNote		cnG1
		cNote		cnRst
	cLoopEnd
	cStop

Song17_FM2:
	cLoopStart
		cInsFM		patch07
		cVolFM		$0D
		cRelease	$01
		cVibrato	$02, $0A
		cPan		cpCenter
		cNote		cnRst, $0C
		cNote		cnD4, $04
		cNote		cnRst, $08
		cNote		cnF4, $04
		cNote		cnRst, $08
		cNote		cnF4, $04
		cNote		cnRst, $08
		cNote		cnF4, $04
		cNote		cnRst, $08
		cNote		cnF4, $04
		cNote		cnRst, $08
		cNote		cnF4, $04
		cNote		cnRst, $08
		cNote		cnF4, $04
		cNote		cnRst, $08
		cNote		cnF4, $06
		cNote		cnFs4, $03
		cNote		cnG4
		cNote		cnRst, $06
		cNote		cnG4, $4E
		cNote		cnRst, $0C
		cNote		cnD4, $04
		cNote		cnRst, $08
		cNote		cnF4, $04
		cNote		cnRst, $08
		cNote		cnF4, $04
		cNote		cnRst, $08
		cNote		cnF4, $04
		cNote		cnRst, $08
		cNote		cnF4, $04
		cNote		cnRst, $08
		cNote		cnF4, $04
		cNote		cnRst, $08
		cNote		cnF4, $04
		cNote		cnRst, $08
		cNote		cnF4, $06
		cNote		cnFs4, $03
		cNote		cnG4
		cNote		cnRst, $06
		cNote		cnD4, $4E
	cLoopEnd
	cStop

Song17_FM3:
	cLoopStart
		cInsFM		patch09
		cVolFM		$0C
		cRelease	$01
		cVibrato	$02, $0A
		cPan		cpRight
		cNote		cnC4, $30
		cNote		cnD4
		cNote		cnG4
		cNote		cnF4
		cNote		cnD4
		cNote		cnC4
		cNote		cnA3
		cNote		cnG3
		cNote		cnC4
		cNote		cnD4
		cNote		cnG4
		cNote		cnF4
		cNote		cnD4
		cNote		cnC4
		cNote		cnA4
		cNote		cnG4
	cLoopEnd
	cStop

Song17_FM4:
	cLoopStart
		cInsFM		patch09
		cVolFM		$0B
		cRelease	$01
		cVibrato	$02, $0A
		cPan		cpLeft
		cNote		cnE3, $04
		cNote		cnRst, $08
		cNote		cnB3, $06
		cNote		cnD3, $04
		cNote		cnRst, $08
		cNote		cnA3, $06
		cNote		cnC3
		cNote		cnG3, $04
		cNote		cnRst, $08
		cNote		cnA2, $06
		cNote		cnF3, $04
		cNote		cnRst, $08
		cNote		cnG2, $04
		cNote		cnRst, $08
		cNote		cnE3, $04
		cNote		cnRst, $08
		cNote		cnE3, $04
		cNote		cnRst, $08
		cNote		cnB3, $06
		cNote		cnE3, $04
		cNote		cnRst, $08
		cNote		cnA3, $04
		cNote		cnRst, $08
		cNote		cnD3, $06
		cNote		cnG3
		cNote		cnC3
		cNote		cnG3, $04
		cNote		cnRst, $08
		cNote		cnF3, $04
		cNote		cnRst, $08
		cNote		cnD4, $04
		cNote		cnRst, $08
	cLoopEnd
	cStop

Song17_FM5:
	cLoopStart
		cInsFM		patch01
		cVolFM		$0A
		cRelease	$01
		cVibrato	$02, $0A
		cPan		cpCenter
		cNote		cnD4, $04
		cNote		cnRst, $08
		cNote		cnE3, $04
		cNote		cnRst, $08
		cNote		cnB3, $06
		cNote		cnD3, $04
		cNote		cnRst, $08
		cNote		cnA3, $06
		cNote		cnC3
		cNote		cnD3, $04
		cNote		cnRst, $08
		cNote		cnA2, $06
		cNote		cnD3, $04
		cNote		cnRst, $08
		cNote		cnG2, $04
		cNote		cnRst, $08
		cNote		cnE3, $04
		cNote		cnRst, $08
		cNote		cnE3, $04
		cNote		cnRst, $08
		cNote		cnB3, $06
		cNote		cnE3, $04
		cNote		cnRst, $08
		cNote		cnA3, $04
		cNote		cnRst, $08
		cNote		cnD3, $06
		cNote		cnG3
		cNote		cnC3
		cNote		cnG3, $04
		cNote		cnRst, $08
		cNote		cnF3, $04
		cNote		cnRst, $08
	cLoopEnd
	cStop

Song17_DAC:
	cLoopStart
		cPan		cpCenter
		cNote		cnC0, $12
		cNote		cnC0
		cNote		cnC0, $06
		cNote		cnC0, $0C
		cNote		cnC0, $06
		cNote		cnC0, $0C
		cNote		cnC0
		cNote		cnC0
		cNote		cnC0, $12
		cNote		cnC0
		cNote		cnC0, $06
		cNote		cnC0, $0C
		cNote		cnC0, $06
		cNote		cnC0, $0C
		cNote		cnC0
		cNote		cnCs0
	cLoopEnd
	cStop

Song17_PSG1:
	cLoopStart
		cInsVolPSG	$01, $09
		cRelease	$01
		cVibrato	$04, $0A
		cNote		cnRst, $0C
		cNote		cnRst, $18
		cNote		cnC4, $30
		cNote		cnD4
		cNote		cnG4
		cNote		cnF4
		cNote		cnD4
		cNote		cnC4
		cNote		cnA3
		cNote		cnG3
		cNote		cnC4
		cNote		cnD4
		cNote		cnG4
		cNote		cnF4
		cNote		cnD4
		cNote		cnC4
		cNote		cnA4
		cNote		cnG4
		cNote		cnRst, $3C
	cLoopEnd
	cStop

Song17_PSG2:
	cInsVolPSG	$00, $00
	cStop

Song17_PSG3:
	cInsVolPSG	$00, $00
	cStop

Song17_Noise:
	cLoopStart
		cRelease	$01
		cInsVolPSG	$0F, $0D
		cNote		cnRst, $06
		cNote		cnG0, $0C
		cNote		cnG0, $0C
		cNote		cnG0, $0C
		cNote		cnG0, $0C
		cNote		cnG0, $0C
		cNote		cnG0, $0C
		cNote		cnG0, $0C
		cNote		cnG0, $06
		cLoopCnt	$07
			cNote		cnG0, $0C
		cLoopCntEnd
	cLoopEnd
	cStop
