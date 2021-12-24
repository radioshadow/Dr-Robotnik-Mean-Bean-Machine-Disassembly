Song04_Start:
	cType		ctMusic
	cFadeOut	$0000
	cTempo		$C1
	cChannel	Song04_FM1
	cChannel	Song04_FM2
	cChannel	Song04_FM3
	cChannel	Song04_FM4
	cChannel	Song04_FM5
	cChannel	Song04_DAC
	cChannel	Song04_PSG1
	cChannel	Song04_PSG2
	cChannel	Song04_PSG3
	cChannel	Song04_Noise

Song04_FM1:
	cLoopStart
		cRelease	$01
		cVibrato	$02, $0A
		cLoopCnt	$02
			cPan		cpRight
			cInsFM		patch6C
			cVolFM		$0C
			cNote		cnA1, $05
			cNote		cnE2
			cNote		cnA2
			cNote		cnE2
			cRelease	$01
			cInsFM		patch20
			cVolFM		$0C
			cNote		cnD3, $07
			cNote		cnRst
			cVolFM		$0A
			cNote		cnD3, $06
			cNote		cnRst, $07
			cVolFM		$06
			cNote		cnD3, $03
			cVolFM		$0C
			cNote		cnC3, $07
			cNote		cnRst, $07
			cVolFM		$0A
			cNote		cnC3, $06
			cNote		cnRst, $07
			cVolFM		$06
			cNote		cnC3, $03
			cVolFM		$0C
			cNote		cnD3, $07
			cNote		cnRst
			cVolFM		$0A
			cNote		cnD3, $06
			cNote		cnRst, $07
			cVolFM		$06
			cNote		cnD3, $03
			cVolFM		$0D
			cNote		cnC3, $07
			cNote		cnRst
			cVolFM		$0A
			cNote		cnC3, $06
			cNote		cnRst, $07
			cVolFM		$06
			cNote		cnC3, $03
			cVolFM		$0D
			cNote		cnC3, $0A
			cNote		cnD3
		cLoopCntEnd
		cInsFM		patch6C
		cVolFM		$0C
		cNote		cnA1, $05
		cNote		cnE2
		cNote		cnA2
		cNote		cnE2
		cRelease	$01
		cInsFM		patch20
		cVolFM		$0D
		cNote		cnD3, $07
		cNote		cnRst
		cVolFM		$0A
		cNote		cnD3, $06
		cNote		cnRst, $07
		cVolFM		$06
		cNote		cnD3, $03
		cVolFM		$0D
		cNote		cnC3, $07
		cNote		cnRst
		cVolFM		$0A
		cNote		cnC3, $06
		cNote		cnRst, $07
		cVolFM		$06
		cNote		cnC3, $03
		cVolFM		$0D
		cNote		cnD3, $07
		cNote		cnRst
		cVolFM		$0A
		cNote		cnD3, $06
		cNote		cnRst, $07
		cVolFM		$06
		cNote		cnD3, $03
		cVolFM		$0D
		cNote		cnC3, $07
		cNote		cnRst
		cVolFM		$0A
		cNote		cnC3, $06
		cNote		cnRst, $07
		cVolFM		$06
		cNote		cnC3, $03
		cVolFM		$0D
		cNote		cnC3, $0A
		cNote		cnD3
		cLoopCnt	$05
			cInsFM		patch82
			cVolFM		$0C
			cVibrato	$02, $0A
			cSustain
			cNote		cnE3, $78
			cVibrato	$05, $00
			cRelease	$01
			cNote		cnE3, $28
			cVibrato	$02, $0A
			cSustain
			cNote		cnG3, $78
			cVibrato	$05, $00
			cRelease	$01
			cNote		cnG3, $28
		cLoopCntEnd
		cNote		cnRst, $50
	cLoopEnd
	cStop

Song04_FM2:
	cLoopStart
		cInsFM		patch20
		cVolFM		$0B
		cRelease	$01
		cVibrato	$02, $0A
		cPan		cpLeft
		cLoopCnt	$02
			cVolFM		$00
			cNote		cnRst, $14
			cVolFM		$0B
			cVolFM		$0C
			cNote		cnA2, $07
			cNote		cnRst
			cVolFM		$0A
			cNote		cnA2, $06
			cNote		cnRst, $07
			cVolFM		$06
			cNote		cnA2, $03
			cVolFM		$0C
			cNote		cnG2, $07
			cNote		cnRst
			cVolFM		$0A
			cNote		cnG2, $06
			cNote		cnRst, $07
			cVolFM		$06
			cNote		cnG2, $03
			cVolFM		$0C
			cNote		cnA2, $07
			cNote		cnRst
			cVolFM		$0A
			cNote		cnA2, $06
			cNote		cnRst, $07
			cVolFM		$06
			cNote		cnA2, $03
			cVolFM		$0C
			cNote		cnG2, $07
			cNote		cnRst
			cVolFM		$0A
			cNote		cnG2, $06
			cNote		cnRst, $07
			cVolFM		$06
			cNote		cnG2, $03
			cVolFM		$0C
			cNote		cnG2, $0A
			cNote		cnA2
		cLoopCntEnd
		cNote		cnRst, $14
		cVolFM		$0C
		cNote		cnA2, $07
		cNote		cnRst
		cVolFM		$0A
		cNote		cnA2, $06
		cNote		cnRst, $07
		cVolFM		$06
		cNote		cnA2, $03
		cVolFM		$0C
		cNote		cnG2, $07
		cNote		cnRst
		cVolFM		$0A
		cNote		cnG2, $06
		cNote		cnRst, $07
		cVolFM		$06
		cNote		cnG2, $03
		cVolFM		$0C
		cNote		cnA2, $07
		cNote		cnRst
		cVolFM		$0A
		cNote		cnA2, $06
		cNote		cnRst, $07
		cVolFM		$06
		cNote		cnA2, $03
		cVolFM		$0C
		cNote		cnG2, $07
		cNote		cnRst
		cVolFM		$0A
		cNote		cnG2, $06
		cNote		cnRst, $07
		cVolFM		$06
		cNote		cnG2, $03
		cVolFM		$0C
		cNote		cnG2, $0A
		cNote		cnA2
		cLoopCnt	$05
			cInsFM		patch82
			cVolFM		$0C
			cVibrato	$02, $0A
			cSustain
			cNote		cnB2, $78
			cRelease	$01
			cVibrato	$05, $00
			cNote		cnB2, $28
			cVibrato	$02, $0A
			cSustain
			cNote		cnD3, $78
			cRelease	$01
			cVibrato	$05, $00
			cNote		cnD3, $28
		cLoopCntEnd
		cNote		cnRst, $50
	cLoopEnd
	cStop

Song04_FM3:
	cLoopStart
		cInsFM		patch1A
		cVolFM		$0C
		cRelease	$01
		cVibrato	$02, $0A
		cLoopCnt	$06
			cNote		cnA1, $0A
			cNote		cnE2, $05
			cNote		cnA2, $03
			cNote		cnRst, $07
			cNote		cnE2, $05
			cNote		cnGs2, $0A
			cNote		cnG2
			cNote		cnE2, $05
			cNote		cnRst
			cNote		cnA1, $0A
			cNote		cnD2, $03
			cNote		cnRst, $02
			cNote		cnE2, $03
			cNote		cnRst, $02
		cLoopCntEnd
		cNote		cnA1, $04
		cNote		cnRst, $06
		cNote		cnA1, $04
		cNote		cnRst, $06
		cNote		cnA2, $0E
		cNote		cnRst, $06
		cNote		cnA1, $03
		cNote		cnRst, $02
		cNote		cnA2, $05
		cNote		cnRst, $0A
		cNote		cnA2, $0E
		cNote		cnRst, $06
		cLoopCnt	$02
			cNote		cnE1, $05
			cNote		cnB1
			cNote		cnE2
			cNote		cnE1
			cNote		cnDs2
			cNote		cnE1
			cNote		cnD2
			cNote		cnE1
			cNote		cnA1
			cNote		cnB1
			cNote		cnE1
			cNote		cnA1
			cNote		cnB1
			cNote		cnD2
			cNote		cnE2
			cNote		cnE1
			cNote		cnE1
			cNote		cnB1
			cNote		cnE2
			cNote		cnE1
			cNote		cnDs2
			cNote		cnE1
			cNote		cnD2
			cNote		cnE1
			cNote		cnA1
			cNote		cnB1
			cNote		cnE1
			cNote		cnA1
			cNote		cnB1
			cNote		cnD2
			cNote		cnE2
			cNote		cnE1
			cNote		cnG1
			cNote		cnD2
			cNote		cnG2
			cNote		cnG1
			cNote		cnFs2
			cNote		cnG1
			cNote		cnF2
			cNote		cnG1
			cNote		cnC2
			cNote		cnD2
			cNote		cnG1
			cNote		cnC2
			cNote		cnD2
			cNote		cnF2
			cNote		cnG2
			cNote		cnG1
			cNote		cnG1
			cNote		cnD2
			cNote		cnG2
			cNote		cnG1
			cNote		cnFs2
			cNote		cnG1
			cNote		cnF2
			cNote		cnG1
			cNote		cnC2
			cNote		cnD2
			cNote		cnG1
			cNote		cnC2
			cNote		cnD2
			cNote		cnF2
			cNote		cnG2
			cNote		cnG1
			cNote		cnE1
			cNote		cnB1
			cNote		cnE2
			cNote		cnE1
			cNote		cnDs2
			cNote		cnE1
			cNote		cnD2
			cNote		cnE1
			cNote		cnA1
			cNote		cnB1
			cNote		cnE1
			cNote		cnA1
			cNote		cnB1
			cNote		cnD2
			cNote		cnE2
			cNote		cnE1
			cNote		cnE1
			cNote		cnB1
			cNote		cnE2
			cNote		cnE1
			cNote		cnDs2
			cNote		cnE1
			cNote		cnD2
			cNote		cnE1
			cNote		cnA1
			cNote		cnB1
			cNote		cnE1
			cNote		cnA1
			cNote		cnB1
			cNote		cnD2
			cNote		cnE2
			cNote		cnE1
			cNote		cnG1
			cNote		cnD2
			cNote		cnG2
			cNote		cnG1
			cNote		cnFs2
			cNote		cnG1
			cNote		cnF2
			cNote		cnG1
			cNote		cnC2
			cNote		cnD2
			cNote		cnG1
			cNote		cnC2
			cNote		cnD2
			cNote		cnF2
			cNote		cnG2
			cNote		cnG1
			cNote		cnD1
			cNote		cnD1
			cNote		cnD1
			cNote		cnD1
			cNote		cnD2, $0A
			cNote		cnD1, $05
			cNote		cnD1
			cNote		cnD1
			cNote		cnD1
			cNote		cnD2, $0A
			cNote		cnDs1, $05
			cNote		cnDs1
			cNote		cnDs2, $0A
		cLoopCntEnd
		cNote		cnRst, $50
	cLoopEnd
	cStop

Song04_FM4:
	cLoopStart
		cInsFM		patch2D
		cVolFM		$0B
		cRelease	$01
		cVibrato	$02, $0A
		cPan		cpCenter
		cNoteShift	$00, $00, $00
		cLoopCnt	$03
			cNote		cnRst, $50
			cNote		cnRst
			cNote		cnRst
			cNote		cnRst, $28
			cInsFM		patch6A
			cVolFM		$0B
			cNote		cnA3, $05
			cNote		cnAs3
			cNote		cnGs3
			cNote		cnD4
			cNote		cnCs4
			cNote		cnC4
			cNote		cnB3
			cNote		cnAs3
		cLoopCntEnd
		cLoopCnt	$03
			cInsFM		patch6B
			cVolFM		$0C
			cNote		cnE4, $05
			cVolFM		$09
			cNote		cnE4
			cVolFM		$0C
			cNote		cnG4
			cVolFM		$09
			cNote		cnG4
			cVolFM		$0C
			cNote		cnG4
			cVolFM		$09
			cNote		cnG4
			cVolFM		$0C
			cNote		cnE4
			cVolFM		$09
			cNote		cnE4
			cVolFM		$0C
			cNote		cnA4
			cVolFM		$09
			cNote		cnA4
			cVolFM		$0C
			cNote		cnA4
			cVolFM		$09
			cNote		cnA4
			cVolFM		$0C
			cNote		cnE4
			cVolFM		$09
			cNote		cnE4
			cVolFM		$0C
			cNote		cnG4
			cVolFM		$09
			cNote		cnG4
			cVolFM		$0C
			cNote		cnG4
			cVolFM		$09
			cNote		cnG4
			cVolFM		$0C
			cNote		cnE4
			cVolFM		$09
			cNote		cnE4
			cVolFM		$0C
			cNote		cnA4
			cVolFM		$09
			cNote		cnA4
			cVolFM		$0C
			cNote		cnA4
			cVolFM		$09
			cNote		cnA4
			cVolFM		$0C
			cNote		cnG4
			cVolFM		$09
			cNote		cnG4
			cVolFM		$0C
			cNote		cnFs4
			cVolFM		$09
			cNote		cnFs4
			cVolFM		$0C
			cNote		cnE4
			cVolFM		$09
			cNote		cnE4
			cVolFM		$0C
			cNote		cnFs4
			cVolFM		$09
			cNote		cnFs4
			cVolFM		$0C
			cNote		cnE4
			cVolFM		$09
			cNote		cnE4
			cVolFM		$0C
			cNote		cnG4
			cVolFM		$09
			cNote		cnG4
			cVolFM		$0C
			cNote		cnG4
			cVolFM		$09
			cNote		cnG4
			cVolFM		$0C
			cNote		cnE4
			cVolFM		$09
			cNote		cnE4
			cVolFM		$0C
			cNote		cnA4
			cVolFM		$09
			cNote		cnA4
			cVolFM		$0C
			cNote		cnA4
			cVolFM		$09
			cNote		cnA4
			cVolFM		$0C
			cNote		cnE4
			cVolFM		$09
			cNote		cnE4
			cVolFM		$0C
			cNote		cnG4
			cVolFM		$09
			cNote		cnG4
			cVolFM		$0C
			cNote		cnG4
			cVolFM		$09
			cNote		cnG4
			cVolFM		$0C
			cNote		cnE4
			cVolFM		$09
			cNote		cnE4
			cVolFM		$0C
			cNote		cnB4
			cVolFM		$09
			cNote		cnB4
			cVolFM		$0C
			cNote		cnB4
			cVolFM		$09
			cNote		cnB4
			cVolFM		$0C
			cNote		cnA4
			cVolFM		$09
			cNote		cnA4
			cVolFM		$0C
			cNote		cnG4
			cVolFM		$09
			cNote		cnG4
			cVolFM		$0C
			cNote		cnFs4
			cVolFM		$09
			cNote		cnFs4
			cVolFM		$0C
			cNote		cnD4
			cVolFM		$09
			cNote		cnD4
		cLoopCntEnd
		cVolFM		$0C
		cNote		cnD4, $05
		cVolFM		$09
		cNote		cnD4
		cVolFM		$0C
		cNote		cnA3
		cVolFM		$09
		cNote		cnA3
		cVolFM		$0C
		cNote		cnE4
		cVolFM		$09
		cNote		cnE4
		cVolFM		$0C
		cNote		cnG4
		cVolFM		$09
		cNote		cnG4
		cVolFM		$0C
		cNote		cnFs4
		cVolFM		$09
		cNote		cnFs4
		cVolFM		$0C
		cNote		cnD4
		cVolFM		$09
		cNote		cnD4
		cVolFM		$0C
		cNote		cnDs4
		cVolFM		$09
		cNote		cnDs4
		cVolFM		$0C
		cNote		cnB3
		cVolFM		$09
		cNote		cnB3
	cLoopEnd
	cStop

Song04_FM5:
	cVolFM		$00
	cNote		cnRst, $12
	cLoopStart
		cRelease	$01
		cVibrato	$02, $0A
		cPan		cpCenter
		cNoteShift	$00, $00, $00
		cLoopCnt	$03
			cInsFM		patch3B
			cVolFM		$00
			cVoltaLoop
				cNote		cnC3, $04
				cNote		cnC3
				cNote		cnC3
				cNote		cnC3
				cNote		cnC3
				cNote		cnC3
				cNote		cnC3
				cNote		cnC3
				cNote		cnC3
				cNote		cnC3
				cVoltaSect1
				cVoltaSectEnd
				cVoltaSect2
				cVoltaSectEnd
				cVoltaSect3
			cVoltaLoop
				cNote		cnC3, $04
				cNote		cnC3
				cNote		cnC3
				cNote		cnC3
				cNote		cnC3
				cNote		cnC3
				cNote		cnC3
				cNote		cnC3
				cNote		cnC3
				cNote		cnC3
				cVoltaSect1
				cVoltaSectEnd
				cVoltaSect2
				cVoltaSectEnd
				cVoltaSect3
					cNote		cnC3, $04
					cNote		cnC3
					cNote		cnC3
					cNote		cnC3
					cNote		cnC3
					cNote		cnC3
					cNote		cnC3
					cNote		cnC3
					cNote		cnC3
					cNote		cnC3
					cInsFM		patch6A
					cVolFM		$09
					cNote		cnA3, $05
					cNote		cnAs3
					cNote		cnGs3
					cNote		cnD4
					cNote		cnCs4
					cNote		cnC4
					cNote		cnB3
					cNote		cnAs3
		cLoopCntEnd
		cLoopCnt	$03
			cInsFM		patch6B
			cVolFM		$0A
			cNote		cnE4, $05
			cVolFM		$07
			cNote		cnE4
			cVolFM		$0A
			cNote		cnG4
			cVolFM		$07
			cNote		cnG4
			cVolFM		$0A
			cNote		cnG4
			cVolFM		$07
			cNote		cnG4
			cVolFM		$0A
			cNote		cnE4
			cVolFM		$07
			cNote		cnE4
			cVolFM		$0A
			cNote		cnA4
			cVolFM		$07
			cNote		cnA4
			cVolFM		$0A
			cNote		cnA4
			cVolFM		$07
			cNote		cnA4
			cVolFM		$0A
			cNote		cnE4
			cVolFM		$07
			cNote		cnE4
			cVolFM		$0A
			cNote		cnG4
			cVolFM		$07
			cNote		cnG4
			cVolFM		$0A
			cNote		cnG4
			cVolFM		$07
			cNote		cnG4
			cVolFM		$0A
			cNote		cnE4
			cVolFM		$07
			cNote		cnE4
			cVolFM		$0A
			cNote		cnA4
			cVolFM		$07
			cNote		cnA4
			cVolFM		$0A
			cNote		cnA4
			cVolFM		$07
			cNote		cnA4
			cVolFM		$0A
			cNote		cnG4
			cVolFM		$07
			cNote		cnG4
			cVolFM		$0A
			cNote		cnFs4
			cVolFM		$07
			cNote		cnFs4
			cVolFM		$0A
			cNote		cnE4
			cVolFM		$07
			cNote		cnE4
			cVolFM		$0A
			cNote		cnFs4
			cVolFM		$07
			cNote		cnFs4
			cVolFM		$0A
			cNote		cnE4
			cVolFM		$07
			cNote		cnE4
			cVolFM		$0A
			cNote		cnG4
			cVolFM		$07
			cNote		cnG4
			cVolFM		$0A
			cNote		cnG4
			cVolFM		$07
			cNote		cnG4
			cVolFM		$0A
			cNote		cnE4
			cVolFM		$07
			cNote		cnE4
			cVolFM		$0A
			cNote		cnA4
			cVolFM		$07
			cNote		cnA4
			cVolFM		$0A
			cNote		cnA4
			cVolFM		$07
			cNote		cnA4
			cVolFM		$0A
			cNote		cnE4
			cVolFM		$07
			cNote		cnE4
			cVolFM		$0A
			cNote		cnG4
			cVolFM		$07
			cNote		cnG4
			cVolFM		$0A
			cNote		cnG4
			cVolFM		$07
			cNote		cnG4
			cVolFM		$0A
			cNote		cnE4
			cVolFM		$07
			cNote		cnE4
			cVolFM		$0A
			cNote		cnB4
			cVolFM		$07
			cNote		cnB4
			cVolFM		$0A
			cNote		cnB4
			cVolFM		$07
			cNote		cnB4
			cVolFM		$0A
			cNote		cnA4
			cVolFM		$07
			cNote		cnA4
			cVolFM		$0A
			cNote		cnG4
			cVolFM		$07
			cNote		cnG4
			cVolFM		$0A
			cNote		cnFs4
			cVolFM		$07
			cNote		cnFs4
			cVolFM		$0A
			cNote		cnD4
			cVolFM		$07
			cNote		cnD4
		cLoopCntEnd
		cVolFM		$0A
		cNote		cnD4, $05
		cVolFM		$07
		cNote		cnD4
		cVolFM		$0A
		cNote		cnA3
		cVolFM		$07
		cNote		cnA3
		cVolFM		$0A
		cNote		cnE4
		cVolFM		$07
		cNote		cnE4
		cVolFM		$0A
		cNote		cnG4
		cVolFM		$07
		cNote		cnG4
		cVolFM		$0A
		cNote		cnFs4
		cVolFM		$07
		cNote		cnFs4
		cVolFM		$0A
		cNote		cnD4
		cVolFM		$07
		cNote		cnD4
		cVolFM		$0A
		cNote		cnDs4
		cVolFM		$07
		cNote		cnDs4
		cVolFM		$0A
		cNote		cnB3
		cVolFM		$07
		cNote		cnB3
	cLoopEnd
	cStop

Song04_DAC:
	cLoopStart
		cLoopCnt	$03
			cPan		cpCenter
			cNote		cnC0, $0A
			cNote		cnC0, $05
			cNote		cnC0
			cNote		cnCs0, $0A
			cNote		cnC0
			cNote		cnC0, $05
			cNote		cnC0
			cNote		cnC0
			cNote		cnC0
			cNote		cnCs0, $14
			cNote		cnC0, $0A
			cNote		cnC0, $05
			cNote		cnC0
			cNote		cnCs0, $0A
			cNote		cnC0
			cNote		cnC0, $05
			cNote		cnC0
			cNote		cnC0
			cNote		cnC0
			cNote		cnCs0, $0A
			cNote		cnCs0, $05
			cNote		cnCs0
		cLoopCntEnd
		cLoopCnt	$0B
			cNote		cnC0, $0A
			cNote		cnC0, $05
			cNote		cnC0
			cNote		cnCs0, $0A
			cNote		cnC0
			cNote		cnC0, $05
			cNote		cnC0
			cNote		cnC0
			cNote		cnC0
			cNote		cnCs0, $0A
			cNote		cnCs0, $05
			cNote		cnCs0
			cNote		cnC0, $0A
			cNote		cnC0, $05
			cNote		cnC0
			cNote		cnCs0, $0A
			cNote		cnC0
			cNote		cnC0, $05
			cNote		cnC0
			cNote		cnC0
			cNote		cnC0
			cNote		cnCs0, $14
		cLoopCntEnd
		cNote		cnRst, $32
		cNote		cnC0, $04
		cNote		cnC0, $03
		cNote		cnC0
		cNote		cnCs0, $0A
		cNote		cnCs0, $05
		cNote		cnCs0
	cLoopEnd
	cStop

Song04_PSG1:
	cInsVolPSG	$00, $00
	cStop

Song04_PSG2:
	cInsVolPSG	$00, $00
	cStop

Song04_PSG3:
	cInsVolPSG	$00, $00
	cStop

Song04_Noise:
	cLoopStart
		cRelease	$01
		cInsVolPSG	$0F, $0D
		cNote		cnG0, $05
		cNote		cnRst
		cNote		cnG0
		cNote		cnG0
	cLoopEnd
	cStop
