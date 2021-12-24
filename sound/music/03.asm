Song03_Start:
	cType		ctMusic
	cFadeOut	$0000
	cTempo		$C4
	cChannel	Song03_FM1
	cChannel	Song03_FM2
	cChannel	Song03_FM3
	cChannel	Song03_FM4
	cChannel	Song03_FM5
	cChannel	Song03_DAC
	cChannel	Song03_PSG1
	cChannel	Song03_PSG2
	cChannel	Song03_PSG3
	cChannel	Song03_Noise

Song03_FM1:
	cLoopStart
		cInsFM		patch07
		cVolFM		$0E
		cRelease	$01
		cVibrato	$02, $0A
		cPan		cpCenter
		cLoopCnt	$02
			cNote		cnC3, $08
			cNote		cnDs3
			cNote		cnG3
			cNote		cnF3
			cNote		cnRst
			cNote		cnG3
			cNote		cnRst
			cNote		cnDs3
			cNote		cnRst
			cNote		cnF3
			cNote		cnRst
			cNote		cnD3
			cNote		cnDs3, $10
			cNote		cnC3
		cLoopCntEnd
		cNote		cnC3, $08
		cNote		cnDs3
		cNote		cnG3
		cNote		cnF3
		cNote		cnRst
		cNote		cnG3, $18
		cNote		cnDs3, $20
		cNote		cnD3
	cLoopEnd
	cStop

Song03_FM2:
	cLoopStart
		cRelease	$01
		cVibrato	$02, $0A
		cPan		cpCenter
		cLoopCnt	$02
			cNote		cnRst, $40
			cInsFM		patch22
			cVolFM		$09
			cNote		cnG2, $04
			cNote		cnC3
			cNote		cnCs3
			cNote		cnG3
			cNote		cnC4
			cNote		cnCs4
			cNote		cnG4
			cNote		cnCs4
			cNote		cnC4
			cNote		cnG3
			cNote		cnCs3
			cNote		cnC3
			cNote		cnG2
			cNote		cnRst, $0C
		cLoopCntEnd
		cRelease	$03
		cInsFM		patch15
		cVolFM		$0B
		cNote		cnA4, $06
		cNote		cnAs4, $05
		cNote		cnB4
		cNote		cnC5, $06
		cNote		cnA4, $05
		cNote		cnAs4
		cNote		cnB4, $06
		cNote		cnC5, $05
		cNote		cnA4
		cNote		cnAs4, $06
		cNote		cnB4, $05
		cNote		cnC5
		cNote		cnA4, $06
		cNote		cnAs4, $05
		cNote		cnB4
		cNote		cnC5, $06
		cNote		cnA4, $05
		cNote		cnAs4
		cNote		cnB4, $06
		cNote		cnC5, $05
		cNote		cnA4
		cNote		cnAs4, $06
		cNote		cnB4, $05
		cNote		cnC5
	cLoopEnd
	cStop

Song03_FM3:
	cLoopStart
		cInsFM		patch0E
		cVolFM		$0B
		cRelease	$01
		cPan		cpCenter
		cVibrato	$02, $0A
		cNote		cnC2, $10
		cNote		cnC2, $05
		cNote		cnRst, $03
		cNote		cnC3, $05
		cNote		cnRst, $0B
		cNote		cnC2, $05
		cNote		cnRst, $03
		cNote		cnC2, $10
		cNote		cnC2
		cNote		cnC2, $05
		cNote		cnRst, $03
		cNote		cnC3, $05
		cNote		cnRst, $03
		cNote		cnC2, $05
		cNote		cnRst, $03
		cNote		cnC3, $05
		cNote		cnRst, $03
		cNote		cnC2, $10
		cNote		cnAs1
		cNote		cnAs1, $05
		cNote		cnRst, $03
		cNote		cnAs1, $05
		cNote		cnRst, $0B
		cNote		cnAs1, $05
		cNote		cnRst, $03
		cNote		cnAs1, $10
		cNote		cnAs1
		cNote		cnAs1, $05
		cNote		cnRst, $03
		cNote		cnAs1, $05
		cNote		cnRst, $0B
		cNote		cnAs1, $05
		cNote		cnRst, $03
		cNote		cnAs1, $10
		cNote		cnGs1
		cNote		cnGs1, $05
		cNote		cnRst, $03
		cNote		cnGs1, $05
		cNote		cnRst, $0B
		cNote		cnGs1, $05
		cNote		cnRst, $03
		cNote		cnGs1, $10
		cNote		cnGs1
		cNote		cnGs1, $05
		cNote		cnRst, $03
		cNote		cnGs1, $05
		cNote		cnRst, $0B
		cNote		cnGs1, $05
		cNote		cnRst, $03
		cNote		cnGs1, $10
		cNote		cnG1
		cNote		cnG1, $05
		cNote		cnRst, $03
		cNote		cnG1, $05
		cNote		cnRst, $0B
		cNote		cnG1, $05
		cNote		cnRst, $03
		cNote		cnG1, $10
		cNote		cnG1
		cNote		cnG1, $05
		cNote		cnRst, $03
		cNote		cnG1, $05
		cNote		cnRst, $0B
		cNote		cnG1, $05
		cNote		cnRst, $03
		cNote		cnG1, $10
	cLoopEnd
	cStop

Song03_FM4:
	cLoopStart
		cInsFM		patch07
		cVolFM		$0D
		cRelease	$01
		cVibrato	$02, $0A
		cPan		cpLeft
		cLoopCnt	$02
			cNote		cnF3, $08
			cNote		cnGs3
			cNote		cnC4
			cNote		cnAs3
			cNote		cnRst
			cNote		cnC4
			cNote		cnRst
			cNote		cnGs3
			cNote		cnRst
			cNote		cnAs3
			cNote		cnRst
			cNote		cnG3
			cNote		cnGs3, $10
			cNote		cnF3
		cLoopCntEnd
		cNote		cnF3, $08
		cNote		cnGs3
		cNote		cnC4
		cNote		cnAs3
		cNote		cnRst
		cNote		cnC4, $18
		cNote		cnGs3, $20
		cNote		cnG3
	cLoopEnd
	cStop

Song03_FM5:
	cNote		cnRst, $12
	cLoopStart
		cInsFM		patch07
		cVolFM		$0C
		cRelease	$01
		cVibrato	$02, $0A
		cPan		cpRight
		cLoopCnt	$02
			cNote		cnC3, $08
			cNote		cnDs3
			cNote		cnG3
			cNote		cnF3
			cNote		cnRst
			cNote		cnG3
			cNote		cnRst
			cNote		cnDs3
			cNote		cnRst
			cNote		cnF3
			cNote		cnRst
			cNote		cnD3
			cNote		cnDs3, $10
			cNote		cnC3
		cLoopCntEnd
		cNote		cnC3, $08
		cNote		cnDs3
		cNote		cnG3
		cNote		cnF3
		cNote		cnRst
		cNote		cnG3, $18
		cNote		cnDs3, $20
		cNote		cnD3
	cLoopEnd
	cStop

Song03_DAC:
	cLoopStart
		cNote		cnC0, $10
		cPan		cpLeft
		cNote		cnD0, $08
		cNote		cnD0
		cPan		cpCenter
		cNote		cnCs0
		cNote		cnDs0
		cNote		cnDs0
		cNote		cnC0
		cNote		cnC0, $10
		cNote		cnC0, $08
		cNote		cnC0
		cNote		cnCs0
		cPan		cpRight
		cNote		cnE0
		cNote		cnE0
		cPan		cpCenter
		cNote		cnC0
		cNote		cnC0
		cPan		cpLeft
		cNote		cnD0
		cNote		cnD0, $10
		cPan		cpCenter
		cNote		cnCs0, $08
		cNote		cnDs0, $10
		cNote		cnC0, $08
		cPan		cpRight
		cNote		cnE0, $10
		cPan		cpCenter
		cNote		cnC0, $08
		cPan		cpRight
		cNote		cnE0
		cPan		cpCenter
		cNote		cnCs0
		cPan		cpRight
		cNote		cnE0
		cNote		cnE0
		cPan		cpCenter
		cNote		cnC0
		cNote		cnC0, $10
		cPan		cpLeft
		cNote		cnD0, $08
		cNote		cnD0
		cPan		cpCenter
		cNote		cnCs0
		cNote		cnDs0
		cNote		cnDs0
		cNote		cnC0
		cNote		cnC0, $10
		cNote		cnC0, $08
		cNote		cnC0
		cNote		cnCs0
		cPan		cpRight
		cNote		cnE0
		cNote		cnE0
		cPan		cpCenter
		cNote		cnC0
		cNote		cnC0
		cNote		cnCs0
		cNote		cnCs0
		cNote		cnC0
		cNote		cnCs0
		cNote		cnCs0, $10
		cNote		cnDs0, $08
		cNote		cnC0
		cNote		cnCs0
		cNote		cnC0
		cNote		cnC0
		cNote		cnCs0
		cNote		cnCs0
		cNote		cnDs0
		cPan		cpRight
		cNote		cnE0
	cLoopEnd
	cStop

Song03_PSG1:
	cInsVolPSG	$00, $00
	cStop

Song03_PSG2:
	cInsVolPSG	$00, $00
	cStop

Song03_PSG3:
	cInsVolPSG	$00, $00
	cStop

Song03_Noise:
	cLoopStart
		cInsVolPSG	$0F, $0D
		cNote		cnG0, $08
		cNote		cnRst
		cNote		cnG0
		cNote		cnG0
	cLoopEnd
	cStop
