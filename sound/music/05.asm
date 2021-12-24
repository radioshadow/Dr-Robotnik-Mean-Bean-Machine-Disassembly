Song05_Start:
	cType		ctMusic
	cFadeOut	$0000
	cTempo		$C4
	cChannel	Song05_FM1
	cChannel	Song05_FM2
	cChannel	Song05_FM3
	cChannel	Song05_FM4
	cChannel	Song05_FM5
	cChannel	Song05_DAC
	cChannel	Song05_PSG1
	cChannel	Song05_PSG2
	cChannel	Song05_PSG3
	cChannel	Song05_Noise

Song05_FM1:
	cLoopStart
		cInsFM		patch15
		cVolFM		$09
		cRelease	$01
		cVibrato	$02, $0A
		cPan		cpCenter
		cNoteShift	$00, $00, $00
		cLoopCnt	$03
			cNote		cnC3, $0E
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
		cInsFM		patch0A
		cVolFM		$0C
		cVibrato	$02, $0A
		cSustain
		cNote		cnC4, $38
		cVibrato	$05, $00
		cRelease	$01
		cNote		cnC4, $38
		cNote		cnRst, $70
		cVibrato	$02, $0A
		cSustain
		cNote		cnFs3, $38
		cVibrato	$05, $00
		cRelease	$01
		cNote		cnFs3, $38
		cNote		cnRst, $70
		cVibrato	$02, $0A
		cSustain
		cNote		cnC4, $54
		cVibrato	$05, $00
		cRelease	$01
		cNote		cnC4, $54
		cVibrato	$02, $0A
		cNote		cnF4, $1C
		cNote		cnDs4
		cVibrato	$02, $0A
		cSustain
		cNote		cnC4, $38
		cVibrato	$05, $00
		cRelease	$01
		cNote		cnC4, $38
		cNote		cnRst, $70
	cLoopEnd
	cStop

Song05_FM2:
	cLoopStart
		cRelease	$01
		cVibrato	$02, $0A
		cPan		cpCenter
		cNoteShift	$00, $00, $00
		cLoopCnt	$07
			cNote		cnRst, $70
		cLoopCntEnd
		cInsFM		patch1F
		cVolFM		$0B
		cRelease	$05
		cLoopCnt	$01
			cNote		cnG5, $07
			cNote		cnG5
			cNote		cnC6
			cNote		cnC6
			cNote		cnG5
			cNote		cnG5
			cNote		cnAs5
			cNote		cnAs5
			cNote		cnG5
			cNote		cnG5
			cNote		cnRst, $0E
			cNote		cnC6, $07
			cNote		cnC6
			cNote		cnRst, $0E
			cNote		cnG5, $07
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
			cNote		cnRst, $15
		cLoopCntEnd
		cNote		cnF5, $07
		cNote		cnF5
		cNote		cnB5
		cNote		cnB5
		cNote		cnF5
		cNote		cnF5
		cNote		cnC6
		cNote		cnC6
		cNote		cnF5
		cNote		cnF5
		cNote		cnRst, $0E
		cNote		cnB5, $07
		cNote		cnB5
		cNote		cnRst, $0E
		cNote		cnF5, $07
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
		cNote		cnRst, $15
		cNote		cnG5, $07
		cNote		cnG5
		cNote		cnC6
		cNote		cnC6
		cNote		cnG5
		cNote		cnG5
		cNote		cnAs5
		cNote		cnAs5
		cNote		cnG5
		cNote		cnG5
		cNote		cnRst, $0E
		cNote		cnC6, $07
		cNote		cnC6
		cNote		cnRst, $0E
		cNote		cnG5, $07
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
		cNote		cnRst, $15
	cLoopEnd
	cStop

Song05_FM3:
	cLoopStart
		cInsFM		patch0D
		cVolFM		$0C
		cRelease	$01
		cVibrato	$02, $0A
		cPan		cpCenter
		cNoteShift	$00, $00, $00
		cLoopCnt	$03
			cNote		cnC2, $0E
			cNote		cnRst
			cNote		cnC2
			cNote		cnAs1, $09
			cNote		cnRst, $13
			cNote		cnD2, $07
			cNote		cnRst
			cNote		cnDs2
			cNote		cnRst
			cNote		cnE2
			cNote		cnRst
			cNote		cnF2, $09
			cNote		cnRst, $13
			cNote		cnF2, $09
			cNote		cnRst, $05
			cNote		cnDs2, $09
			cNote		cnRst, $13
			cNote		cnA1, $09
			cNote		cnRst, $05
			cNote		cnAs1, $09
			cNote		cnRst, $05
			cNote		cnB1, $07
			cNote		cnRst
		cLoopCntEnd
		cLoopCnt	$01
			cNote		cnC2, $0E
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
			cNote		cnC3, $0E
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

Song05_FM4:
	cNote		cnRst, $0C
	cLoopStart
		cInsFM		patch15
		cVolFM		$08
		cRelease	$01
		cVibrato	$02, $0A
		cPan		cpRight
		cNoteShift	$00, $02, $00
		cLoopCnt	$03
			cNote		cnC3, $0A
			cNote		cnRst, $04
			cNote		cnC3, $0A
			cNote		cnRst, $04
			cNote		cnAs2, $0A
			cNote		cnRst, $04
			cNote		cnAs2, $0A
			cNote		cnRst, $04
			cNote		cnA2, $0A
			cNote		cnRst, $04
			cNote		cnA2, $0A
			cNote		cnRst, $04
			cNote		cnGs2, $0A
			cNote		cnRst, $04
			cNote		cnG2, $0A
			cNote		cnRst, $04
			cNote		cnF3, $0A
			cNote		cnRst, $04
			cNote		cnF3, $0A
			cNote		cnRst, $04
			cNote		cnDs3, $0A
			cNote		cnRst, $04
			cNote		cnDs3, $0A
			cNote		cnRst, $04
			cNote		cnD3, $0A
			cNote		cnRst, $04
			cNote		cnD3, $0A
			cNote		cnRst, $04
			cNote		cnCs3, $0A
			cNote		cnRst, $04
			cNote		cnCs3, $0A
			cNote		cnRst, $04
		cLoopCntEnd
		cInsFM		patch0A
		cVolFM		$0D
		cVibrato	$05, $0A
		cNote		cnC4, $70
		cNote		cnRst
		cNote		cnFs3
		cNote		cnRst
		cNote		cnC4, $A8
		cNote		cnF4, $1C
		cNote		cnDs4
		cNote		cnC4, $70
		cNote		cnRst
	cLoopEnd
	cStop

Song05_FM5:
	cNote		cnRst, $18
	cLoopStart
		cInsFM		patch15
		cVolFM		$05
		cRelease	$01
		cVibrato	$02, $0A
		cPan		cpLeft
		cNoteShift	$00, $04, $00
		cLoopCnt	$03
			cNote		cnC3, $0A
			cNote		cnRst, $04
			cNote		cnC3, $0A
			cNote		cnRst, $04
			cNote		cnAs2, $0A
			cNote		cnRst, $04
			cNote		cnAs2, $0A
			cNote		cnRst, $04
			cNote		cnA2, $0A
			cNote		cnRst, $04
			cNote		cnA2, $0A
			cNote		cnRst, $04
			cNote		cnGs2, $0A
			cNote		cnRst, $04
			cNote		cnG2, $0A
			cNote		cnRst, $04
			cNote		cnF3, $0A
			cNote		cnRst, $04
			cNote		cnF3, $0A
			cNote		cnRst, $04
			cNote		cnDs3, $0A
			cNote		cnRst, $04
			cNote		cnDs3, $0A
			cNote		cnRst, $04
			cNote		cnD3, $0A
			cNote		cnRst, $04
			cNote		cnD3, $0A
			cNote		cnRst, $04
			cNote		cnCs3, $0A
			cNote		cnRst, $04
			cNote		cnCs3, $0A
			cNote		cnRst, $04
		cLoopCntEnd
		cInsFM		patch0A
		cVolFM		$0C
		cVibrato	$02, $0A
		cRelease	$50
		cNote		cnC4, $38
		cVibrato	$05, $00
		cRelease	$01
		cNote		cnC4, $38
		cNote		cnRst, $70
		cVibrato	$02, $0A
		cRelease	$50
		cNote		cnFs3, $38
		cVibrato	$05, $0D
		cRelease	$01
		cNote		cnFs3, $38
		cNote		cnRst, $70
		cVibrato	$02, $0A
		cRelease	$50
		cNote		cnC4, $54
		cVibrato	$05, $00
		cRelease	$01
		cNote		cnC4, $54
		cVibrato	$02, $0A
		cNote		cnF4, $1C
		cNote		cnDs4
		cVibrato	$02, $0A
		cRelease	$50
		cNote		cnC4, $38
		cVibrato	$05, $00
		cRelease	$01
		cNote		cnC4, $38
		cNote		cnRst, $70
	cLoopEnd
	cStop

Song05_DAC:
	cPan		cpCenter
	cLoopStart
		cNote		cnC0, $1C
		cNote		cnCs0
		cNote		cnC0, $0E
		cNote		cnC0
		cNote		cnCs0, $1C
		cNote		cnC0
		cNote		cnCs0, $15
		cNote		cnC0, $07
		cNote		cnC0, $0E
		cNote		cnC0
		cNote		cnCs0, $1C
	cLoopEnd
	cStop

Song05_PSG1:
	cInsVolPSG	$00, $00
	cStop

Song05_PSG2:
	cInsVolPSG	$00, $00
	cStop

Song05_PSG3:
	cInsVolPSG	$00, $00
	cStop

Song05_Noise:
	cLoopStart
		cInsVolPSG	$0F, $0E
		cNote		cnG0, $0E
		cInsVolPSG	$0F, $0C
		cNote		cnG0, $0E
	cLoopEnd
	cStop
