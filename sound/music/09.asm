Song09_Start:
	cType		ctMusic
	cFadeOut	$0000
	cTempo		$C6
	cChannel	Song09_FM1
	cChannel	Song09_FM2
	cChannel	Song09_FM3
	cChannel	Song09_FM4
	cChannel	Song09_FM5
	cChannel	Song09_DAC
	cChannel	Song09_PSG1
	cChannel	Song09_PSG2
	cChannel	Song09_PSG3
	cChannel	Song09_Noise

Song09_FM1:
	cLoopStart
		cInsFM		patch0A
		cVolFM		$0C
		cRelease	$01
		cVibrato	$02, $0A
		cPan		cpCenter
		cNoteShift	$00, $00, $00
		cNote		cnC4, $06
		cNote		cnRst, $12
		cNote		cnC4, $24
		cNote		cnC4, $10
		cNote		cnRst, $08
		cNote		cnC4
		cNote		cnRst, $04
		cNote		cnRst, $0C
		cNote		cnC4, $54
		cNote		cnB3, $06
		cNote		cnRst, $12
		cNote		cnB3, $24
		cNote		cnB3, $10
		cNote		cnRst, $08
		cNote		cnC4
		cNote		cnRst, $04
		cNote		cnRst, $0C
		cNote		cnC4, $54
	cLoopEnd
	cStop

Song09_FM2:
	cLoopStart
		cInsFM		patch0A
		cVolFM		$0C
		cRelease	$01
		cVibrato	$02, $0A
		cPan		cpRight
		cNoteShift	$00, $00, $00
		cNote		cnA3, $06
		cNote		cnRst, $12
		cNote		cnA3, $24
		cNote		cnA3, $10
		cNote		cnRst, $08
		cNote		cnG3
		cNote		cnRst, $04
		cNote		cnRst, $0C
		cNote		cnG3, $54
		cNote		cnG3, $06
		cNote		cnRst, $12
		cNote		cnG3, $18
		cNote		cnG3, $03
		cNote		cnRst, $09
		cNote		cnG3, $11
		cNote		cnRst, $07
		cNote		cnG3, $0C
		cNote		cnRst
		cNote		cnG3, $54
	cLoopEnd
	cStop

Song09_FM3:
	cLoopStart
		cInsFM		patch0D
		cVolFM		$0C
		cRelease	$01
		cVibrato	$02, $0A
		cNote		cnD2, $18
		cNote		cnE2
		cNote		cnA1, $0C
		cNote		cnA1
		cNote		cnA1
		cNote		cnD2, $18
		cNote		cnE2
		cNote		cnA1, $0C
		cNote		cnA2
		cNote		cnG2
		cNote		cnE2
		cNote		cnC2
		cNote		cnD2, $18
		cNote		cnE2
		cNote		cnA1, $0C
		cNote		cnA1
		cNote		cnA1
		cNote		cnD2, $18
		cNote		cnE2
		cNote		cnA1, $04
		cNote		cnRst, $08
		cNote		cnG1, $0C
		cNote		cnG1
		cNote		cnC2
		cNote		cnC2
	cLoopEnd
	cStop

Song09_FM4:
	cLoopStart
		cRelease	$01
		cVibrato	$02, $0A
		cPan		cpLeft
		cNoteShift	$00, $00, $00
		cNote		cnRst, $60
		cNote		cnRst, $30
		cInsFM		patch1E
		cVolFM		$0A
		cLoopCnt	$01
			cNote		cnA3, $06
			cNote		cnA4
			cNote		cnA3
			cNote		cnA4
		cLoopCntEnd
	cLoopEnd
	cStop

Song09_FM5:
	cNote		cnRst, $10
	cLoopStart
		cInsFM		patch0A
		cVolFM		$09
		cRelease	$01
		cVibrato	$02, $0A
		cPan		cpCenter
		cNoteShift	$00, $00, $00
		cNote		cnC4, $06
		cNote		cnRst, $12
		cNote		cnC4, $24
		cNote		cnC4, $10
		cNote		cnRst, $08
		cNote		cnC4
		cNote		cnRst, $04
		cNote		cnRst, $0C
		cNote		cnC4, $54
		cNote		cnB3, $06
		cNote		cnRst, $12
		cNote		cnB3, $24
		cNote		cnB3, $10
		cNote		cnRst, $08
		cNote		cnC4
		cNote		cnRst, $04
		cNote		cnRst, $0C
		cNote		cnC4, $54
		cStop

Song09_DAC:
	cLoopStart
		cNote		cnC0, $18
		cNote		cnCs0
		cNote		cnC0
		cNote		cnCs0
		cNote		cnC0
		cNote		cnCs0
		cNote		cnC0
		cNote		cnCs0, $0C
		cNote		cnCs0
		cNote		cnC0, $18
		cNote		cnCs0
		cNote		cnC0
		cNote		cnCs0
		cNote		cnC0
		cNote		cnCs0
		cNote		cnC0, $0C
		cNote		cnCs0
		cNote		cnCs0
		cNote		cnCs0
		cNote		cnC0, $18
		cNote		cnCs0
		cNote		cnC0
		cNote		cnCs0
		cNote		cnC0
		cNote		cnCs0
		cNote		cnC0
		cNote		cnCs0, $0C
		cNote		cnCs0
		cNote		cnC0, $18
		cNote		cnCs0
		cNote		cnC0
		cNote		cnCs0
		cNote		cnC0, $0C
		cNote		cnCs0
		cNote		cnC0
		cNote		cnCs0
		cNote		cnC0
		cNote		cnCs0
		cNote		cnCs0
		cNote		cnCs0
	cLoopEnd
	cStop

Song09_PSG1:
	cStop

Song09_PSG2:
	cStop

Song09_PSG3:
	cStop

Song09_Noise:
	cLoopStart
		cInsVolPSG	$00, $00
		cNote		cnRst
		cNote		cnC1
		cInsVolPSG	$0F, $0D
		cNote		cnG0, $06
		cInsVolPSG	$00, $00
		cNote		cnRst
		cNote		cnRst
		cNote		cnRst
		cInsVolPSG	$0F, $0D
		cNote		cnG0
		cNote		cnG0
	cLoopEnd
	cStop
