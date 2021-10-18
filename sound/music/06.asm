Song06_Start:
	cType		ctMusic
	cFadeOut	$0000
	cTempo		$C3
	cChannel	Song06_FM1
	cChannel	Song06_FM2
	cChannel	Song06_FM3
	cChannel	Song06_FM4
	cChannel	Song06_FM5
	cChannel	Song06_DAC
	cChannel	Song06_PSG1
	cChannel	Song06_PSG2
	cChannel	Song06_PSG3
	cChannel	Song06_Noise

Song06_FM1:
	cLoopStart
		cRelease	$01
		cVibrato	$02, $0A
		cPan		cpCenter
		cNoteShift	$00, $00, $00
		cVolFM		$00
		cNote		cnRst, $60
		cNote		cnRst
		cNote		cnRst
		cNote		cnRst
		cLoopCnt	$02
			cInsFM		patch0D
			cVolFM		$0D
			cNote		cnC2, $0C
			cNote		cnDs2
			cNote		cnC2, $06
			cNote		cnDs2, $0C
			cNote		cnC2, $06
			cNote		cnDs2, $0C
			cNote		cnC2, $06
			cNote		cnF2, $12
			cNote		cnDs2, $0C
			cNote		cnC2
			cNote		cnDs2
			cNote		cnC2, $06
			cNote		cnDs2, $0C
			cNote		cnC2, $06
			cNote		cnDs2, $0C
			cNote		cnC2, $06
			cNote		cnFs2, $12
			cNote		cnF2, $0C
		cLoopCntEnd
		cNote		cnC2, $0C
		cNote		cnDs2
		cNote		cnC2, $06
		cNote		cnDs2, $0C
		cNote		cnC2, $06
		cNote		cnDs2, $0C
		cNote		cnC2, $06
		cNote		cnF2, $12
		cNote		cnDs2, $0C
		cNote		cnRst, $60
		cLoopCnt	$01
			cNote		cnF2, $0C
			cNote		cnGs2
			cNote		cnF2, $06
			cNote		cnGs2, $0C
			cNote		cnF2, $06
			cNote		cnGs2, $0C
			cNote		cnF2, $06
			cNote		cnAs2, $12
			cNote		cnGs2, $0C
			cNote		cnF2
			cNote		cnGs2
			cNote		cnF2, $06
			cNote		cnGs2, $0C
			cNote		cnF2, $06
			cNote		cnGs2, $0C
			cNote		cnF2, $06
			cNote		cnB2, $12
			cNote		cnAs2, $0C
		cLoopCntEnd
		cNote		cnC2, $0C
		cNote		cnDs2
		cNote		cnC2, $06
		cNote		cnDs2, $0C
		cNote		cnC2, $06
		cNote		cnDs2, $0C
		cNote		cnC2, $06
		cNote		cnF2, $12
		cNote		cnDs2, $0C
		cNote		cnC2
		cNote		cnDs2
		cNote		cnC2, $06
		cNote		cnDs2, $0C
		cNote		cnC2, $06
		cNote		cnDs2, $0C
		cNote		cnC2, $06
		cNote		cnFs2, $12
		cNote		cnF2, $0C
		cNote		cnC2
		cNote		cnDs2
		cNote		cnC2, $06
		cNote		cnDs2, $0C
		cNote		cnC2, $06
		cNote		cnDs2, $0C
		cNote		cnC2, $06
		cNote		cnF2, $12
		cNote		cnDs2, $0C
		cNote		cnRst, $60
		cLoopCnt	$02
			cNote		cnC2, $0C
			cNote		cnDs2
			cNote		cnC2, $06
			cNote		cnDs2, $0C
			cNote		cnC2, $06
			cNote		cnDs2, $0C
			cNote		cnC2, $06
			cNote		cnF2, $12
			cNote		cnDs2, $0C
			cNote		cnC2
			cNote		cnDs2
			cNote		cnC2, $06
			cNote		cnDs2, $0C
			cNote		cnC2, $06
			cNote		cnDs2, $0C
			cNote		cnC2, $06
			cNote		cnFs2, $12
			cNote		cnF2, $0C
		cLoopCntEnd
		cNote		cnC2, $0C
		cNote		cnDs2
		cNote		cnC2, $06
		cNote		cnDs2, $0C
		cNote		cnC2, $06
		cNote		cnDs2, $0C
		cNote		cnC2, $06
		cNote		cnF2, $12
		cNote		cnDs2, $0C
		cNote		cnRst, $60
	cLoopEnd
	cStop

Song06_FM2:
	cLoopStart
		cRelease	$01
		cVibrato	$02, $0A
		cPan		cpCenter
		cNoteShift	$00, $00, $00
		cLoopCnt	$0B
			cNote		cnRst, $60
		cLoopCntEnd
		cInsFM		patch01
		cVolFM		$0A
		cNote		cnC3, $90
		cNote		cnFs3, $0E
		cNote		cnRst, $04
		cNote		cnF3, $0E
		cNote		cnRst, $04
		cNote		cnDs3, $09
		cNote		cnRst, $03
		cNote		cnC3, $60
		cNote		cnRst
		cNote		cnC3, $90
		cNote		cnFs3, $0E
		cNote		cnRst, $04
		cNote		cnF3, $0E
		cNote		cnRst, $04
		cNote		cnDs3, $09
		cNote		cnRst, $03
		cNote		cnC3, $60
		cNote		cnRst
		cNote		cnG3
		cNote		cnD4
		cNote		cnG4
		cNote		cnGs4
		cNote		cnRst
		cNote		cnRst
		cNote		cnRst
		cVolFM		$00
		cNote		cnRst
	cLoopEnd
	cStop

Song06_FM3:
	cLoopStart
		cVolFM		$00
		cRelease	$01
		cVibrato	$02, $0A
		cNoteShift	$00, $00, $00
		cLoopCnt	$05
			cNote		cnRst, $60
		cLoopCntEnd
		cInsFM		patch1F
		cVolFM		$0B
		cRelease	$05
		cNote		cnGs4, $06
		cNote		cnGs4
		cNote		cnGs4
		cNote		cnGs4
		cNote		cnGs4
		cNote		cnGs4
		cNote		cnGs4
		cNote		cnGs4
		cNote		cnGs4
		cNote		cnGs4
		cNote		cnGs4
		cNote		cnGs4
		cNote		cnGs4
		cNote		cnGs4
		cNote		cnGs4
		cNote		cnGs4
		cNote		cnGs4
		cNote		cnGs4
		cNote		cnGs4
		cNote		cnGs4
		cNote		cnGs4
		cNote		cnGs4
		cNote		cnGs4
		cNote		cnGs4
		cNote		cnGs4
		cNote		cnGs4
		cNote		cnGs4
		cNote		cnGs4
		cNote		cnGs4
		cNote		cnGs4
		cNote		cnGs4
		cNote		cnGs4
		cNote		cnRst, $60
		cNote		cnRst
		cNote		cnRst
		cNote		cnRst
		cNote		cnRst
		cNote		cnRst
		cNote		cnGs4, $06
		cNote		cnGs4
		cNote		cnGs4
		cNote		cnGs4
		cNote		cnGs4
		cNote		cnGs4
		cNote		cnGs4
		cNote		cnGs4
		cNote		cnGs4
		cNote		cnGs4
		cNote		cnGs4
		cNote		cnGs4
		cNote		cnGs4
		cNote		cnGs4
		cNote		cnGs4
		cNote		cnGs4
		cNote		cnGs4
		cNote		cnGs4
		cNote		cnGs4
		cNote		cnGs4
		cNote		cnGs4
		cNote		cnGs4
		cNote		cnGs4
		cNote		cnGs4
		cNote		cnGs4
		cNote		cnGs4
		cNote		cnGs4
		cNote		cnGs4
		cNote		cnGs4
		cNote		cnGs4
		cNote		cnGs4
		cNote		cnGs4
		cNote		cnRst, $60
		cNote		cnRst
		cNote		cnRst
		cNote		cnRst
		cNote		cnRst
		cNote		cnRst
		cNote		cnGs4, $06
		cNote		cnGs4
		cNote		cnGs4
		cNote		cnGs4
		cNote		cnGs4
		cNote		cnGs4
		cNote		cnGs4
		cNote		cnGs4
		cNote		cnGs4
		cNote		cnGs4
		cNote		cnGs4
		cNote		cnGs4
		cNote		cnGs4
		cNote		cnGs4
		cNote		cnGs4
		cNote		cnGs4
		cNote		cnGs4
		cNote		cnGs4
		cNote		cnGs4
		cNote		cnGs4
		cNote		cnGs4
		cNote		cnGs4
		cNote		cnGs4
		cNote		cnGs4
		cNote		cnGs4
		cNote		cnGs4
		cNote		cnGs4
		cNote		cnGs4
		cNote		cnGs4
		cNote		cnGs4
		cNote		cnGs4
		cNote		cnGs4
		cNote		cnD4
		cNote		cnD4
		cNote		cnD4
		cNote		cnD4
		cNote		cnD4
		cNote		cnD4
		cNote		cnD4
		cNote		cnD4
		cNote		cnD4
		cNote		cnD4
		cNote		cnD4
		cNote		cnD4
		cNote		cnD4
		cNote		cnD4
		cNote		cnD4
		cNote		cnD4
		cNote		cnRst, $60
		cNote		cnD4, $06
		cNote		cnD4
		cNote		cnD4
		cNote		cnD4
		cNote		cnD4
		cNote		cnD4
		cNote		cnD4
		cNote		cnD4
		cNote		cnD4
		cNote		cnD4
		cNote		cnD4
		cNote		cnD4
		cNote		cnD4
		cNote		cnD4
		cNote		cnD4
		cNote		cnD4
		cNote		cnGs4
		cNote		cnGs4
		cNote		cnGs4
		cNote		cnGs4
		cNote		cnGs4
		cNote		cnGs4
		cNote		cnGs4
		cNote		cnGs4
		cNote		cnGs4
		cNote		cnGs4
		cNote		cnGs4
		cNote		cnGs4
		cNote		cnGs4
		cNote		cnGs4
		cNote		cnGs4
		cNote		cnGs4
	cLoopEnd
	cStop

Song06_FM4:
	cNote		cnRst, $08
	cLoopStart
		cVolFM		$00
		cRelease	$01
		cVibrato	$02, $0A
		cPan		cpCenter
		cNoteShift	$00, $02, $00
		cLoopCnt	$0B
			cNote		cnRst, $60
		cLoopCntEnd
		cInsFM		patch01
		cVolFM		$07
		cNote		cnC3, $90
		cNote		cnFs3, $0E
		cNote		cnRst, $04
		cNote		cnF3, $0E
		cNote		cnRst, $04
		cNote		cnDs3, $09
		cNote		cnRst, $03
		cNote		cnC3, $60
		cNote		cnRst
		cNote		cnC3, $90
		cNote		cnFs3, $0E
		cNote		cnRst, $04
		cNote		cnF3, $0E
		cNote		cnRst, $04
		cNote		cnDs3, $09
		cNote		cnRst, $03
		cNote		cnC3, $60
		cNote		cnRst
		cNote		cnG3
		cNote		cnD4
		cNote		cnG4
		cNote		cnGs4
		cNote		cnRst
		cNote		cnRst
		cNote		cnRst
		cVolFM		$00
		cNote		cnRst
	cLoopEnd
	cStop

Song06_FM5:
	cNote		cnRst, $10
	cLoopStart
		cVolFM		$00
		cRelease	$01
		cVibrato	$02, $0A
		cPan		cpCenter
		cNoteShift	$00, $04, $00
		cLoopCnt	$0B
			cNote		cnRst, $60
		cLoopCntEnd
		cInsFM		patch01
		cVolFM		$06
		cNote		cnC3, $90
		cNote		cnFs3, $0E
		cNote		cnRst, $04
		cNote		cnF3, $0E
		cNote		cnRst, $04
		cNote		cnDs3, $09
		cNote		cnRst, $03
		cNote		cnC3, $60
		cNote		cnRst
		cNote		cnC3, $90
		cNote		cnFs3, $0E
		cNote		cnRst, $04
		cNote		cnF3, $0E
		cNote		cnRst, $04
		cNote		cnDs3, $09
		cNote		cnRst, $03
		cNote		cnC3, $60
		cNote		cnRst
		cNote		cnG3
		cNote		cnD4
		cNote		cnG4
		cNote		cnGs4
		cNote		cnRst
		cNote		cnRst
		cNote		cnRst
		cVolFM		$00
		cNote		cnRst
	cLoopEnd
	cStop

Song06_DAC:
	cLoopStart
		cPan		cpCenter
		cNote		cnC0, $0C
		cNote		cnC0
		cNote		cnDs0, $12
		cNote		cnCs0, $06
		cNote		cnC0, $0C
		cNote		cnC0
		cNote		cnE0, $18
		cNote		cnC0, $0C
		cNote		cnC0
		cNote		cnDs0, $12
		cNote		cnCs0, $06
		cNote		cnC0, $0C
		cNote		cnC0
		cNote		cnE0, $18
		cNote		cnC0, $0C
		cNote		cnC0
		cNote		cnDs0, $12
		cNote		cnCs0, $06
		cNote		cnC0, $0C
		cNote		cnC0
		cNote		cnE0, $18
		cNote		cnD0, $06
		cNote		cnD0
		cNote		cnD0
		cNote		cnD0
		cNote		cnD0, $0C
		cNote		cnDs0, $06
		cNote		cnDs0
		cNote		cnDs0, $0C
		cNote		cnE0, $06
		cNote		cnE0
		cNote		cnE0
		cNote		cnE0
		cNote		cnE0, $0C
		cLoopCnt	$02
			cNote		cnC0, $0C
			cNote		cnC0
			cNote		cnDs0, $12
			cNote		cnCs0, $06
			cNote		cnC0, $0C
			cNote		cnC0
			cNote		cnE0, $18
			cNote		cnC0, $0C
			cNote		cnC0
			cNote		cnDs0, $12
			cNote		cnCs0, $06
			cNote		cnC0, $0C
			cNote		cnC0
			cNote		cnE0, $18
		cLoopCntEnd
		cNote		cnC0, $0C
		cNote		cnC0
		cNote		cnDs0, $12
		cNote		cnCs0, $06
		cNote		cnC0, $0C
		cNote		cnC0
		cNote		cnE0, $18
		cNote		cnD0, $06
		cNote		cnD0
		cNote		cnD0
		cNote		cnD0
		cNote		cnD0, $0C
		cNote		cnDs0, $06
		cNote		cnDs0
		cNote		cnDs0, $0C
		cNote		cnE0, $06
		cNote		cnE0
		cNote		cnE0
		cNote		cnE0
		cNote		cnE0, $0C
		cLoopCnt	$02
			cNote		cnC0, $0C
			cNote		cnC0
			cNote		cnDs0, $12
			cNote		cnCs0, $06
			cNote		cnC0, $0C
			cNote		cnC0
			cNote		cnE0, $18
			cNote		cnC0, $0C
			cNote		cnC0
			cNote		cnDs0, $12
			cNote		cnCs0, $06
			cNote		cnC0, $0C
			cNote		cnC0
			cNote		cnE0, $18
		cLoopCntEnd
		cNote		cnC0, $0C
		cNote		cnC0
		cNote		cnDs0, $12
		cNote		cnCs0, $06
		cNote		cnC0, $0C
		cNote		cnC0
		cNote		cnE0, $18
		cNote		cnD0, $06
		cNote		cnD0
		cNote		cnD0
		cNote		cnD0
		cNote		cnD0, $0C
		cNote		cnDs0, $06
		cNote		cnDs0
		cNote		cnDs0, $0C
		cNote		cnE0, $06
		cNote		cnE0
		cNote		cnE0
		cNote		cnE0
		cNote		cnE0, $0C
		cLoopCnt	$02
			cNote		cnC0, $0C
			cNote		cnC0
			cNote		cnDs0, $12
			cNote		cnCs0, $06
			cNote		cnC0, $0C
			cNote		cnC0
			cNote		cnE0, $18
			cNote		cnC0, $0C
			cNote		cnC0
			cNote		cnDs0, $12
			cNote		cnCs0, $06
			cNote		cnC0, $0C
			cNote		cnC0
			cNote		cnE0, $18
		cLoopCntEnd
		cNote		cnC0, $0C
		cNote		cnC0
		cNote		cnDs0, $12
		cNote		cnE0, $06
		cNote		cnC0, $0C
		cNote		cnC0
		cNote		cnE0, $18
		cNote		cnD0, $06
		cNote		cnD0
		cNote		cnD0
		cNote		cnD0
		cNote		cnD0, $0C
		cNote		cnDs0, $06
		cNote		cnDs0
		cNote		cnDs0, $0C
		cNote		cnE0, $06
		cNote		cnE0
		cNote		cnE0
		cNote		cnE0
		cNote		cnE0, $0C
	cLoopEnd
	cStop

Song06_PSG1:
	cInsVolPSG	$00, $00
	cStop

Song06_PSG2:
	cInsVolPSG	$00, $00
	cStop

Song06_PSG3:
	cInsVolPSG	$00, $00
	cStop

Song06_Noise:
	cLoopStart
		cInsVolPSG	$0F, $0E
		cNote		cnG0, $06
		cInsVolPSG	$0F, $0B
		cNote		cnG0, $06
		cNote		cnG0
		cNote		cnG0
	cLoopEnd
	cStop
