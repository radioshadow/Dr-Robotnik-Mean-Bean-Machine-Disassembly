Song19_Start:
	cType		ctMusic
	cFadeOut	$0000
	cTempo		$C6
	cChannel	Song19_FM1
	cChannel	Song19_FM2
	cChannel	Song19_FM3
	cChannel	Song19_FM4
	cChannel	Song19_FM5
	cChannel	Song19_DAC
	cChannel	Song19_PSG1
	cChannel	Song19_PSG2
	cChannel	Song19_PSG3
	cChannel	Song19_Noise

Song19_FM1:
	cInsFM		patch0E
	cVolFM		$0D
	cRelease	$01
	cVibrato	$02, $0A
	cPan		cpCenter
	cNote		cnE1, $18
	cNote		cnFs1, $0C
	cNote		cnRst, $06
	cNote		cnG1, $15
	cNote		cnA1, $0C
	cNote		cnRst
	cVolFM		$0E
	cNote		cnB1, $06
	cNote		cnRst, $03
	cNote		cnRst
	cNote		cnB1, $06
	cNote		cnRst, $57
	cStop

Song19_FM2:
	cInsFM		patch0F
	cVolFM		$00
	cRelease	$01
	cVibrato	$02, $0A
	cPan		cpRight
	cNote		cnRst, $0C
	cVolFM		$0E
	cNote		cnE3
	cNote		cnRst, $06
	cNote		cnFs3, $0C
	cNote		cnA3, $15
	cNote		cnFs3, $18
	cVolFM		$0D
	cNote		cnA5, $06
	cNote		cnRst, $06
	cNote		cnB5, $06
	cNote		cnRst, $12
	cVolFM		$09
	cNote		cnB5, $06
	cNote		cnRst, $12
	cVolFM		$06
	cNote		cnB5, $06
	cNote		cnRst, $12
	cVolFM		$03
	cNote		cnB5, $06
	cNote		cnRst, $12
	cVolFM		$01
	cNote		cnB5, $06
	cStop

Song19_FM3:
	cInsFM		patch0F
	cVolFM		$00
	cRelease	$01
	cVibrato	$02, $0A
	cPan		cpLeft
	cNote		cnRst, $0C
	cVolFM		$0E
	cNote		cnA3
	cNote		cnRst, $06
	cNote		cnB3, $0C
	cNote		cnD4, $15
	cNote		cnB3, $18
	cVolFM		$0D
	cNote		cnA4, $06
	cNote		cnRst, $06
	cNote		cnB4, $06
	cNote		cnRst, $12
	cVolFM		$09
	cNote		cnB4, $06
	cNote		cnRst, $12
	cVolFM		$06
	cNote		cnB4, $06
	cNote		cnRst, $12
	cVolFM		$03
	cNote		cnB4, $06
	cNote		cnRst, $12
	cVolFM		$01
	cNote		cnB4, $06
	cStop
	cInsFM		patch0F
	cVolFM		$00
	cRelease	$01
	cVibrato	$02, $0A
	cPan		cpRight
	cNote		cnRst, $10
	cVolFM		$08
	cNote		cnE2, $0C
	cNote		cnRst, $06
	cNote		cnFs2, $0C
	cNote		cnA2, $15
	cNote		cnFs2, $14
	cNote		cnB2, $06
	cNote		cnRst, $03
	cNote		cnRst
	cNote		cnCs2, $06
	cNote		cnRst, $57
	cStop
	cInsFM		patch0F
	cVolFM		$00
	cRelease	$01
	cVibrato	$02, $0A
	cPan		cpLeft
	cNote		cnRst, $10
	cVolFM		$08
	cNote		cnA2, $0C
	cNote		cnRst, $06
	cNote		cnB2, $0C
	cNote		cnD3, $15
	cNote		cnB2, $14
	cNote		cnE4, $06
	cNote		cnRst, $03
	cNote		cnRst
	cNote		cnFs4, $06
	cNote		cnRst, $57
	cStop

Song19_DAC:
	cPan		cpCenter
	cNote		cnC0, $0C
	cNote		cnCs0
	cNote		cnC0, $06
	cNote		cnCs0, $0C
	cNote		cnCs0, $12
	cNote		cnC0, $03
	cNote		cnCs0, $06
	cNote		cnCs0, $0C
	cNote		cnCs0, $06
	cNote		cnCs0, $0C
	cNote		cnCs0, $5D
	cStop
	cVolFM		$00
	cRelease	$01
	cVibrato	$02, $0A
	cNote		cnRst, $14
	cVolFM		$0C
	cNote		cnE2, $0C
	cNote		cnRst, $06
	cNote		cnFs2, $0C
	cNote		cnA2, $15
	cNote		cnFs2, $18
	cNote		cnB2, $06
	cNote		cnRst
	cNote		cnCs3
	cNote		cnRst, $12
	cVolFM		$09
	cNote		cnCs3, $06
	cNote		cnRst, $12
	cVolFM		$06
	cNote		cnCs3, $06
	cNote		cnRst, $12
	cVolFM		$03
	cNote		cnCs3, $06
	cNote		cnRst, $12
	cVolFM		$01
	cNote		cnCs3, $06
	cStop
	cVolFM		$00
	cRelease	$01
	cVibrato	$02, $0A
	cNote		cnRst, $14
	cVolFM		$0C
	cNote		cnA2, $0C
	cNote		cnRst, $06
	cNote		cnB2, $0C
	cNote		cnD3, $15
	cNote		cnB2, $18
	cNote		cnE3, $06
	cNote		cnRst
	cNote		cnFs3
	cNote		cnRst, $12
	cVolFM		$09
	cNote		cnFs3, $06
	cNote		cnRst, $12
	cVolFM		$06
	cNote		cnFs3, $06
	cNote		cnRst, $12
	cVolFM		$03
	cNote		cnFs3, $06
	cNote		cnRst, $12
	cVolFM		$01
	cNote		cnFs3, $06
	cStop

Song19_PSG3:
	cStop

Song19_FM4:

Song19_FM5:

Song19_PSG1:

Song19_PSG2:

Song19_Noise:
	cStop
