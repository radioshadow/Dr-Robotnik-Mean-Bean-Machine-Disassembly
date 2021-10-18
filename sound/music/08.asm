Song08_Start:
	cType		ctMusic
	cFadeOut	$0000
	cTempo		$C9
	cChannel	Song08_FM1
	cChannel	Song08_FM2
	cChannel	Song08_FM3
	cChannel	Song08_FM4
	cChannel	Song08_FM5
	cChannel	Song08_DAC
	cChannel	Song08_PSG1
	cChannel	Song08_PSG2
	cChannel	Song08_PSG3
	cChannel	Song08_Noise

Song08_FM1:
	cInsFM		patch09
	cVolFM		$0B
	cRelease	$01
	cVibrato	$02, $0A
	cPan		cpCenter
	cNoteShift	$00, $00, $00
	cNote		cnC4, $0F
	cNote		cnRst, $03
	cNote		cnD4, $0F
	cNote		cnRst, $03
	cNote		cnE4, $0A
	cNote		cnRst, $02
	cNote		cnD4, $30
	cNote		cnC4, $0F
	cNote		cnRst, $03
	cNote		cnB3, $0F
	cNote		cnRst, $03
	cNote		cnE3, $63
	cNote		cnE3, $06
	cNote		cnRst, $03
	cNote		cnC4, $0F
	cNote		cnRst, $03
	cNote		cnB3, $0F
	cNote		cnRst, $03
	cNote		cnE3, $0C
	cNote		cnG3, $08
	cNote		cnRst, $04
	cNote		cnA3, $08
	cNote		cnRst, $09
	cVolFM		$09
	cNote		cnA3, $0D
	cNote		cnRst, $04
	cVolFM		$06
	cNote		cnA3, $0D
	cNote		cnRst, $04
	cVolFM		$03
	cNote		cnA3, $0D
	cVolFM		$00
	cNote		cnRst, $02
	cStop

Song08_FM2:
	cInsFM		patch09
	cVolFM		$0B
	cRelease	$01
	cVibrato	$02, $0A
	cPan		cpCenter
	cNoteShift	$00, $00, $00
	cNote		cnA3, $0F
	cNote		cnRst, $03
	cNote		cnB3, $0F
	cNote		cnRst, $03
	cNote		cnC4, $0A
	cNote		cnRst, $02
	cNote		cnB3, $30
	cNote		cnA3, $0F
	cNote		cnRst, $03
	cNote		cnG3, $0F
	cNote		cnRst, $03
	cNote		cnC3, $63
	cNote		cnC3, $06
	cNote		cnRst, $03
	cNote		cnA3, $0F
	cNote		cnRst, $03
	cNote		cnG3, $0F
	cNote		cnRst, $03
	cNote		cnC3, $0C
	cNote		cnE3, $08
	cNote		cnRst, $04
	cNote		cnE3, $08
	cNote		cnRst, $09
	cVolFM		$09
	cNote		cnE3, $0D
	cNote		cnRst, $04
	cVolFM		$06
	cNote		cnE3, $0D
	cNote		cnRst, $04
	cVolFM		$03
	cNote		cnE3, $0D
	cNote		cnRst, $04
	cVolFM		$00
	cStop

Song08_FM3:
	cInsFM		patch0E
	cVolFM		$0C
	cRelease	$01
	cVibrato	$02, $0A
	cPan		cpCenter
	cNote		cnA1, $0F
	cNote		cnRst, $03
	cNote		cnB1, $0F
	cNote		cnRst, $03
	cNote		cnC2, $0C
	cNote		cnB1, $30
	cNote		cnA1, $03
	cNote		cnRst
	cNote		cnA1, $02
	cNote		cnRst, $04
	cNote		cnA2, $0C
	cNote		cnGs1, $03
	cNote		cnRst
	cNote		cnGs1, $02
	cNote		cnRst, $04
	cNote		cnGs2, $0C
	cNote		cnG1, $03
	cNote		cnRst
	cNote		cnG1, $02
	cNote		cnRst, $04
	cNote		cnG2, $0C
	cNote		cnFs1, $03
	cNote		cnRst
	cNote		cnFs1, $02
	cNote		cnRst, $04
	cNote		cnFs2, $0C
	cNote		cnF1, $03
	cNote		cnRst
	cNote		cnF1, $02
	cNote		cnRst, $04
	cNote		cnF2, $0C
	cNote		cnE1, $03
	cNote		cnRst
	cNote		cnE1, $02
	cNote		cnRst, $04
	cNote		cnE2, $0C
	cNote		cnE1, $03
	cNote		cnRst
	cNote		cnE1, $02
	cNote		cnRst, $04
	cNote		cnE2, $0C
	cNote		cnB1, $03
	cNote		cnRst
	cNote		cnB1, $02
	cNote		cnRst, $04
	cNote		cnB2, $0C
	cNote		cnG1, $08
	cNote		cnRst, $04
	cNote		cnA1, $08
	cNote		cnRst, $04
	cVolFM		$00
	cStop

Song08_FM4:
	cNote		cnRst, $10
	cInsFM		patch09
	cVolFM		$09
	cRelease	$01
	cVibrato	$02, $0A
	cPan		cpLeft
	cNoteShift	$00, $03, $00
	cNote		cnC4, $0F
	cNote		cnRst, $03
	cNote		cnD4, $0F
	cNote		cnRst, $03
	cNote		cnE4, $0A
	cNote		cnRst, $02
	cNote		cnD4, $30
	cNote		cnC4, $0F
	cNote		cnRst, $03
	cNote		cnB3, $0F
	cNote		cnRst, $03
	cNote		cnE3, $63
	cNote		cnE3, $06
	cNote		cnRst, $03
	cNote		cnC4, $0F
	cNote		cnRst, $03
	cNote		cnB3, $0F
	cNote		cnRst, $03
	cNote		cnE3, $0C
	cNote		cnG3, $08
	cNote		cnRst, $04
	cVolFM		$00
	cStop

Song08_FM5:
	cNote		cnRst, $10
	cInsFM		patch09
	cVolFM		$0A
	cRelease	$01
	cVibrato	$02, $0A
	cPan		cpRight
	cNoteShift	$00, $03, $00
	cNote		cnA3, $0F
	cNote		cnRst, $03
	cNote		cnB3, $0F
	cNote		cnRst, $03
	cNote		cnC4, $0A
	cNote		cnRst, $02
	cNote		cnB3, $30
	cNote		cnA3, $0F
	cNote		cnRst, $03
	cNote		cnG3, $0F
	cNote		cnRst, $03
	cNote		cnC3, $63
	cNote		cnC3, $06
	cNote		cnRst, $03
	cNote		cnA3, $0F
	cNote		cnRst, $03
	cNote		cnG3, $0F
	cNote		cnRst, $03
	cNote		cnC3, $0C
	cNote		cnE3, $08
	cNote		cnRst, $04
	cVolFM		$00
	cStop

Song08_DAC:
	cPan		cpCenter
	cNote		cnCs0, $06
	cNote		cnC0
	cNote		cnC0
	cNote		cnCs0
	cNote		cnC0
	cNote		cnC0
	cNote		cnCs0
	cNote		cnC0
	cNote		cnCs0, $0C
	cNote		cnC0, $04
	cNote		cnC0
	cNote		cnC0
	cNote		cnCs0, $18
	cNote		cnC0, $0C
	cNote		cnCs0, $06
	cNote		cnC0, $0C
	cNote		cnC0
	cNote		cnC0, $06
	cNote		cnC0, $0C
	cNote		cnC0
	cNote		cnCs0, $18
	cNote		cnC0, $0C
	cNote		cnCs0, $06
	cNote		cnC0, $0C
	cNote		cnC0
	cNote		cnC0, $06
	cNote		cnC0, $0C
	cNote		cnC0
	cNote		cnCs0, $06
	cNote		cnCs0
	cNote		cnDs0
	cPan		cpRight
	cNote		cnE0
	cPan		cpCenter
	cNote		cnCs0, $0C
	cNote		cnCs0
	cStop

Song08_PSG1:
	cInsVolPSG	$00, $00
	cStop

Song08_PSG2:
	cInsVolPSG	$00, $00
	cStop

Song08_PSG3:
	cInsVolPSG	$00, $00
	cStop

Song08_Noise:
	cInsVolPSG	$00, $00
	cNote		cnRst, $60
	cLoopCnt	$07
		cInsVolPSG	$0F, $0D
		cNote		cnG0, $06
		cInsVolPSG	$0F, $0A
		cNote		cnG0, $06
		cNote		cnG0, $06
		cNote		cnG0, $06
	cLoopCntEnd
	cStop
