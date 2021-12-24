Song16_Start:
	cType		ctMusic
	cFadeOut	$0000
	cTempo		$C1
	cChannel	Song16_FM1
	cChannel	Song16_FM2
	cChannel	Song16_FM3
	cChannel	Song16_FM4
	cChannel	Song16_FM5
	cChannel	Song16_DAC
	cChannel	Song16_PSG1
	cChannel	Song16_PSG2
	cChannel	Song16_PSG3
	cChannel	Song16_Noise

Song16_FM1:
	cLoopStart
		cInsFM		patch09
		cVolFM		$0C
		cRelease	$01
		cVibrato	$02, $0A
		cPan		cpCenter
		cNote		cnG3, $1C
		cNote		cnFs3, $C4
		cNote		cnF3, $1C
		cNote		cnE3, $C4
	cLoopEnd
	cStop

Song16_FM2:
	cLoopStart
		cInsFM		patch09
		cVolFM		$0D
		cRelease	$01
		cVibrato	$02, $0A
		cPan		cpRight
		cNote		cnRst, $2A
		cNote		cnG2, $B6
		cNote		cnRst, $2A
		cNote		cnFs2, $B6
	cLoopEnd
	cStop

Song16_FM4:
	cLoopStart
		cInsFM		patch09
		cVolFM		$0D
		cRelease	$01
		cVibrato	$02, $0A
		cPan		cpLeft
		cNote		cnRst, $31
		cNote		cnCs3, $AF
		cNote		cnRst, $31
		cNote		cnC3, $AF
	cLoopEnd
	cStop

Song16_FM3:
	cLoopStart
		cInsFM		patch0E
		cVolFM		$0C
		cRelease	$01
		cVibrato	$02, $0A
		cNote		cnE1, $0E
		cNote		cnG1, $05
		cNote		cnRst, $09
		cNote		cnA1, $0E
		cNote		cnG1, $07
		cNote		cnE1, $15
		cNote		cnE1, $05
		cNote		cnRst, $09
		cNote		cnA1, $05
		cNote		cnRst, $09
		cNote		cnD1, $07
		cNote		cnE1, $15
		cNote		cnG1, $05
		cNote		cnRst, $09
		cNote		cnA1, $0E
		cNote		cnG1, $07
		cNote		cnE1, $15
		cNote		cnE1, $05
		cNote		cnRst, $09
		cNote		cnA1, $05
		cNote		cnRst, $09
		cNote		cnB1, $0E
		cNote		cnE1
		cNote		cnG1, $05
		cNote		cnRst, $09
		cNote		cnA1, $0E
		cNote		cnG1, $07
		cNote		cnE1, $15
		cNote		cnE1, $05
		cNote		cnRst, $09
		cNote		cnD1, $05
		cNote		cnRst, $09
		cNote		cnDs1, $07
		cNote		cnE1, $15
		cNote		cnG1, $05
		cNote		cnRst, $09
		cNote		cnA1, $0E
		cNote		cnG1, $07
		cNote		cnE1, $15
		cNote		cnE1, $05
		cNote		cnRst, $09
		cNote		cnA1, $07
		cNote		cnB1
		cNote		cnGs1, $0E
	cLoopEnd
	cStop

Song16_FM5:
	cNote		cnRst, $10
	cLoopStart
		cInsFM		patch09
		cVolFM		$09
		cRelease	$01
		cVibrato	$02, $0A
		cNoteShift	$00, $04, $00
		cNote		cnG3, $1C
		cNote		cnFs3, $C4
		cNote		cnF3, $1C
		cNote		cnE3, $C4
	cLoopEnd
	cStop

Song16_DAC:
	cLoopStart
		cNote		cnC0, $1C
		cNote		cnCs0, $15
		cNote		cnC0
		cNote		cnC0, $0E
		cNote		cnCs0, $1C
	cLoopEnd
	cStop

Song16_PSG1:
	cLoopStart
		cInsVolPSG	$00, $09
		cRelease	$01
		cVibrato	$02, $0A
		cNote		cnC2, $05
		cNote		cnRst, $09
		cNote		cnE2, $05
		cNote		cnRst, $09
		cNote		cnD2, $07
		cNote		cnE2
		cNote		cnD2, $05
		cNote		cnRst, $09
		cNote		cnG2, $05
		cNote		cnRst, $09
		cNote		cnC2, $07
		cNote		cnFs2
		cNote		cnD2, $05
		cNote		cnRst, $09
		cNote		cnFs2, $07
		cNote		cnG2
		cNote		cnC2, $05
		cNote		cnRst, $09
		cNote		cnE2, $05
		cNote		cnRst, $09
		cNote		cnD2, $07
		cNote		cnFs2
		cNote		cnC2, $05
		cNote		cnRst, $09
		cNote		cnG2, $05
		cNote		cnRst, $09
		cNote		cnD2, $07
		cNote		cnFs2
		cNote		cnC2, $05
		cNote		cnRst, $09
		cNote		cnG2, $0E
	cLoopEnd
	cStop

Song16_PSG2:
	cLoopStart
		cInsVolPSG	$00, $0A
		cRelease	$01
		cVibrato	$02, $0A
		cNote		cnRst, $0E
		cNote		cnC3, $06
		cNote		cnRst, $0F
		cNote		cnC3, $06
		cNote		cnRst, $0F
		cNote		cnC3, $06
		cNote		cnRst, $0F
		cNote		cnC3, $06
		cNote		cnRst, $0F
		cNote		cnC3, $07
		cNote		cnC3
		cNote		cnRst, $0E
		cNote		cnC3, $06
		cNote		cnRst, $0F
		cNote		cnC3, $06
		cNote		cnRst, $0F
		cNote		cnC3, $06
		cNote		cnRst, $0F
		cNote		cnC3, $06
		cNote		cnRst, $0F
		cNote		cnC3, $0E
	cLoopEnd
	cStop

Song16_PSG3:
	cInsVolPSG	$00, $00
	cStop

Song16_Noise:
	cLoopStart
		cInsVolPSG	$0F, $0D
		cRelease	$01
		cVibrato	$02, $0A
		cNote		cnRst, $1C
		cNote		cnG0, $1C
		cNote		cnG0, $1C
		cNote		cnG0, $1C
		cNote		cnG0, $07
		cNote		cnG0, $69
	cLoopEnd
	cStop
