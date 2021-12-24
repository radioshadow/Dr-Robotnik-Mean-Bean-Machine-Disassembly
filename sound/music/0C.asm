Song0C_Start:
	cType		ctMusic
	cFadeOut	$0000
	cTempo		$C6
	cChannel	Song0C_FM1
	cChannel	Song0C_FM2
	cChannel	Song0C_FM3
	cChannel	Song0C_FM4
	cChannel	Song0C_FM5
	cChannel	Song0C_DAC
	cChannel	Song0C_PSG1
	cChannel	Song0C_PSG2
	cChannel	Song0C_PSG3
	cChannel	Song0C_Noise

Song0C_FM1:
	cInsFM		patch07
	cVolFM		$0F
	cRelease	$01
	cVibrato	$02, $0A
	cPan		cpCenter
	cNoteShift	$00, $00, $00
	cNote		cnF2, $04
	cNote		cnG2
	cNote		cnA2
	cNote		cnAs2
	cNote		cnC3
	cNote		cnD3
	cNote		cnE3
	cNote		cnF3
	cNote		cnG3
	cNote		cnA3
	cNote		cnAs3
	cNote		cnC4
	cNote		cnD4
	cNote		cnE4
	cNote		cnF4
	cNote		cnG4
	cNote		cnF4, $18
	cStop

Song0C_FM2:
	cNote		cnRst, $12
	cInsFM		patch07
	cVolFM		$0C
	cRelease	$01
	cVibrato	$02, $0A
	cPan		cpCenter
	cNoteShift	$00, $00, $00
	cNote		cnF2, $04
	cNote		cnG2
	cNote		cnA2
	cNote		cnAs2
	cNote		cnC3
	cNote		cnD3
	cNote		cnE3
	cNote		cnF3
	cNote		cnG3
	cNote		cnA3
	cNote		cnAs3
	cNote		cnC4
	cNote		cnD4
	cNote		cnE4
	cNote		cnF4
	cNote		cnG4
	cNote		cnF4, $18
	cStop

Song0C_FM3:
	cInsFM		patch07
	cVolFM		$0F
	cRelease	$01
	cVibrato	$02, $0A
	cPan		cpRight
	cNoteShift	$00, $00, $00
	cNote		cnAs1, $04
	cNote		cnC2
	cNote		cnD2
	cNote		cnDs2
	cNote		cnF2
	cNote		cnG2
	cNote		cnA2
	cNote		cnAs2
	cNote		cnC3
	cNote		cnD3
	cNote		cnDs3
	cNote		cnF3
	cNote		cnG3
	cNote		cnA3
	cNote		cnAs3
	cNote		cnC4
	cNote		cnAs3, $16
	cStop

Song0C_FM4:
	cNote		cnRst, $12
	cInsFM		patch07
	cVolFM		$0B
	cRelease	$01
	cVibrato	$02, $0A
	cPan		cpRight
	cNoteShift	$00, $00, $00
	cNote		cnAs1, $04
	cNote		cnC2
	cNote		cnD2
	cNote		cnDs2
	cNote		cnF2
	cNote		cnG2
	cNote		cnA2
	cNote		cnAs2
	cNote		cnC3
	cNote		cnD3
	cNote		cnDs3
	cNote		cnF3
	cNote		cnG3
	cNote		cnA3
	cNote		cnAs3
	cNote		cnC4
	cNote		cnAs3, $16
	cStop

Song0C_FM5:
	cInsFM		patch07
	cVolFM		$0F
	cRelease	$01
	cVibrato	$02, $0A
	cPan		cpLeft
	cNoteShift	$00, $00, $00
	cNote		cnB1, $04
	cNote		cnC2
	cNote		cnD2
	cNote		cnE2
	cNote		cnF2
	cNote		cnG2
	cNote		cnA2
	cNote		cnB2
	cNote		cnC3
	cNote		cnD3
	cNote		cnE3
	cNote		cnF3
	cNote		cnG3
	cNote		cnA3
	cNote		cnB3
	cNote		cnC4
	cNote		cnD4, $16
	cStop

Song0C_DAC:
	cStop

Song0C_PSG1:
	cStop

Song0C_PSG2:
	cStop

Song0C_PSG3:
	cStop

Song0C_Noise:
	cStop
