Song11_Start:
	cType		ctMusic
	cFadeOut	$0000
	cTempo		$C1
	cChannel	Song11_FM1
	cChannel	Song11_FM2
	cChannel	Song11_FM3
	cChannel	Song11_FM4
	cChannel	Song11_FM5
	cChannel	Song11_DAC
	cChannel	Song11_PSG1
	cChannel	Song11_PSG2
	cChannel	Song11_PSG3
	cChannel	Song11_Noise

Song11_FM1:
	cLoopStart
		cRelease	$01
		cVibrato	$02, $0A
		cPan		cpCenter
		cNoteShift	$00, $00, $00
		cLoopCnt	$01
			cVoltaLoop
				cInsFM		patch07
				cVolFM		$0E
				cRelease	$01
				cNote		cnC4, $0A
				cNote		cnRst
				cNote		cnC4, $19
				cNote		cnRst, $05
				cNote		cnC4, $0A
				cNote		cnRst
				cNote		cnC4
				cNote		cnRst
				cNote		cnC4, $1E
				cNote		cnC4, $0A
				cNote		cnC4
				cNote		cnC4
				cNote		cnC4
				cNote		cnB3
				cNote		cnRst
				cNote		cnB3, $19
				cNote		cnRst, $05
				cNote		cnB3, $0A
				cNote		cnRst
				cNote		cnC4
				cNote		cnRst
				cNote		cnC4, $1E
				cNote		cnC4, $0A
				cNote		cnC4
				cNote		cnC4
				cNote		cnC4
				cVoltaSect1
				cVoltaSectEnd
				cVoltaSect2
			cVoltaLoop
				cInsFM		patch24
				cVolFM		$0B
				cRelease	$03
				cNote		cnF3, $0A
				cNote		cnG3
				cNote		cnA3
				cNote		cnC4
				cNote		cnB3
				cNote		cnG3
				cNote		cnRst
				cNote		cnE3
				cNote		cnF3
				cNote		cnA3
				cNote		cnRst
				cNote		cnF3
				cNote		cnG3
				cNote		cnB3
				cNote		cnRst
				cNote		cnE3
				cVoltaSect1
					cNote		cnF3, $0A
					cNote		cnG3
					cNote		cnA3
					cNote		cnC4
					cNote		cnB3
					cNote		cnG3
					cNote		cnRst
					cNote		cnD3
					cNote		cnRst, $50
				cVoltaSectEnd
				cVoltaSect2
					cNote		cnF3, $0A
					cNote		cnG3
					cNote		cnA3
					cNote		cnC4
					cNote		cnD4, $14
					cNote		cnE4, $0A
					cNote		cnA3
					cNote		cnRst, $50
		cLoopCntEnd
		cInsFM		patch09
		cVolFM		$0C
		cRelease	$01
		cNote		cnA3, $19
		cNote		cnRst, $05
		cNote		cnE4, $32
		cNote		cnE4, $0A
		cNote		cnD4
		cNote		cnC4
		cNote		cnB3, $14
		cNote		cnA3, $1E
		cNote		cnG3, $19
		cNote		cnRst, $05
		cNote		cnD4, $32
		cNote		cnC4, $0A
		cNote		cnD4, $05
		cVolFM		$00
		cNote		cnRst
		cVolFM		$0C
		cNote		cnC4, $0A
		cNote		cnD4, $05
		cVolFM		$00
		cNote		cnRst
		cVolFM		$0C
		cNote		cnC4, $28
		cNote		cnA3, $19
		cNote		cnRst, $05
		cNote		cnE4, $32
		cNote		cnE4, $0A
		cNote		cnD4
		cNote		cnC4
		cNote		cnB3, $14
		cNote		cnA3, $1E
		cNote		cnG3, $19
		cNote		cnRst, $05
		cNote		cnD4, $32
		cNote		cnC4, $0F
		cNote		cnRst, $05
		cNote		cnB3, $0F
		cNote		cnRst, $05
		cNote		cnC4, $0A
		cNote		cnD4, $1E
		cInsFM		patch07
		cVolFM		$0E
		cNote		cnG2, $0A
		cNote		cnRst
		cNote		cnG2
		cNote		cnF3
		cNote		cnRst
		cNote		cnF3
		cNote		cnE3
		cNote		cnG2, $05
		cNote		cnA2
		cNote		cnA2, $0A
		cNote		cnB2, $05
		cNote		cnRst
		cNote		cnA2, $0A
		cNote		cnB2, $05
		cNote		cnRst, $0F
		cNote		cnB2, $0A
		cNote		cnA2, $14
		cNote		cnG2, $0A
		cNote		cnRst
		cNote		cnG2
		cNote		cnF3
		cNote		cnRst
		cNote		cnF3
		cNote		cnE3
		cNote		cnF2, $05
		cNote		cnG2
		cNote		cnA2, $0A
		cNote		cnB2
		cNote		cnA2
		cNote		cnG3
		cNote		cnRst, $28
		cNote		cnG2, $0A
		cNote		cnRst
		cNote		cnG2
		cNote		cnF3
		cNote		cnRst
		cNote		cnF3
		cNote		cnE3
		cNote		cnF2, $05
		cNote		cnG2
		cNote		cnA2, $0A
		cNote		cnB2
		cNote		cnC3
		cNote		cnB2
		cNote		cnA2
		cNote		cnG2, $19
		cNote		cnRst, $05
		cNote		cnG2, $0A
		cNote		cnRst
		cNote		cnG2
		cNote		cnF3
		cNote		cnRst
		cNote		cnF3
		cNote		cnE3
		cNote		cnF2, $05
		cNote		cnG2
		cNote		cnA2, $0A
		cNote		cnB2
		cNote		cnA2
		cNote		cnG3
		cNote		cnRst, $28
		cInsFM		patch07
		cVolFM		$0D
		cNote		cnA3, $19
		cNote		cnRst, $05
		cNote		cnE4, $32
		cNote		cnE4, $0A
		cNote		cnD4
		cNote		cnC4
		cNote		cnB3, $14
		cNote		cnA3, $1E
		cNote		cnG3, $19
		cNote		cnRst, $05
		cNote		cnD4, $32
		cNote		cnC4, $0A
		cNote		cnD4, $05
		cNote		cnRst
		cNote		cnC4, $0A
		cNote		cnD4, $05
		cNote		cnRst
		cNote		cnC4, $28
		cNote		cnA3, $19
		cNote		cnRst, $05
		cNote		cnE4, $32
		cNote		cnE4, $0A
		cNote		cnD4
		cNote		cnC4
		cNote		cnB3, $14
		cNote		cnA3, $1E
		cNote		cnG3, $19
		cNote		cnRst, $05
		cNote		cnD4, $32
		cNote		cnC4, $0F
		cNote		cnRst, $05
		cNote		cnB3, $0F
		cNote		cnRst, $05
		cNote		cnC4, $0A
		cNote		cnD4, $1E
	cLoopEnd
	cStop

Song11_FM2:
	cLoopStart
		cInsFM		patch07
		cVolFM		$0B
		cRelease	$01
		cVibrato	$02, $0A
		cPan		cpRight
		cNoteShift	$00, $00, $00
		cLoopCnt	$01
			cVoltaLoop
				cNote		cnA3, $0A
				cNote		cnRst
				cNote		cnA3, $19
				cNote		cnRst, $05
				cNote		cnA3, $0A
				cNote		cnRst
				cNote		cnG3
				cNote		cnRst
				cNote		cnG3, $1E
				cNote		cnG3, $0A
				cNote		cnG3
				cNote		cnG3
				cNote		cnG3
				cNote		cnG3
				cNote		cnRst
				cNote		cnG3, $19
				cNote		cnRst, $05
				cNote		cnG3, $0A
				cNote		cnRst
				cNote		cnG3
				cNote		cnRst
				cNote		cnG3, $1E
				cNote		cnG3, $0A
				cNote		cnG3
				cNote		cnG3
				cNote		cnG3
				cVoltaSect1
				cVoltaSectEnd
				cVoltaSect2
			cVoltaLoop
				cInsFM		patch1F
				cVolFM		$0A
				cNote		cnA3, $0A
				cNote		cnRst
				cNote		cnA3, $19
				cNote		cnRst, $05
				cNote		cnG3, $0A
				cNote		cnRst
				cNote		cnA3
				cNote		cnRst
				cNote		cnA3, $19
				cNote		cnRst, $05
				cNote		cnB3, $0F
				cNote		cnRst, $05
				cNote		cnA3, $0F
				cNote		cnRst, $05
				cNote		cnA3, $0A
				cNote		cnRst
				cNote		cnA3, $19
				cNote		cnRst, $05
				cNote		cnB3, $0A
				cNote		cnRst
				cNote		cnA3
				cNote		cnRst
				cNote		cnG3, $19
				cNote		cnRst, $05
				cNote		cnF3, $0F
				cNote		cnRst, $05
				cNote		cnG3, $0F
				cNote		cnRst, $05
				cVoltaSect1
				cVoltaSectEnd
				cVoltaSect2
		cLoopCntEnd
		cInsFM		patch0C
		cVolFM		$0A
		cNote		cnF4, $0A
		cNote		cnA3
		cNote		cnB3
		cNote		cnA3
		cNote		cnC4
		cNote		cnA3
		cNote		cnE4
		cNote		cnA3
		cNote		cnG4
		cNote		cnB3
		cNote		cnC4
		cNote		cnB3
		cNote		cnD4
		cNote		cnB3
		cNote		cnC4
		cNote		cnB3
		cNote		cnE4
		cNote		cnG3
		cNote		cnA3
		cNote		cnG3
		cNote		cnB3
		cNote		cnG3
		cNote		cnD4
		cNote		cnC4
		cNote		cnF4
		cNote		cnA3
		cNote		cnB3
		cNote		cnA3
		cNote		cnC4
		cNote		cnA3
		cNote		cnE4
		cNote		cnA3
		cNote		cnF4
		cNote		cnA3
		cNote		cnB3
		cNote		cnA3
		cNote		cnC4
		cNote		cnA3
		cNote		cnE4
		cNote		cnA3
		cNote		cnG4
		cNote		cnB3
		cNote		cnC4
		cNote		cnB3
		cNote		cnD4
		cNote		cnB3
		cNote		cnC4
		cNote		cnB3
		cNote		cnE4
		cNote		cnG3
		cNote		cnA3
		cNote		cnG3
		cNote		cnB3
		cNote		cnG3, $05
		cNote		cnA3
		cNote		cnB3
		cNote		cnC4
		cNote		cnD4
		cNote		cnE4
		cNote		cnA3
		cNote		cnB3
		cNote		cnC4
		cNote		cnD4
		cNote		cnE4
		cNote		cnF4
		cNote		cnG4
		cNote		cnA4
		cNote		cnB4
		cNote		cnC5
		cNote		cnD5
		cNote		cnE5
		cNote		cnF5
		cNote		cnG5
		cNote		cnA5
		cNote		cnB5
		cNote		cnRst, $50
		cNote		cnRst
		cNote		cnRst
		cNote		cnRst
		cInsFM		patch07
		cVolFM		$0E
		cNote		cnB2, $0A
		cNote		cnRst
		cNote		cnB2
		cNote		cnA3
		cNote		cnRst
		cNote		cnA3
		cNote		cnG3
		cNote		cnA2, $05
		cNote		cnB2
		cNote		cnC3, $0A
		cNote		cnD3
		cNote		cnE3
		cNote		cnD3
		cNote		cnC3
		cNote		cnB2, $19
		cNote		cnRst, $05
		cNote		cnB2, $0A
		cNote		cnRst
		cNote		cnB2
		cNote		cnA3
		cNote		cnRst
		cNote		cnA3
		cNote		cnG3
		cNote		cnA2, $05
		cNote		cnB2
		cNote		cnC3, $0A
		cNote		cnD3
		cNote		cnC3
		cNote		cnB3
		cNote		cnRst, $28
		cInsFM		patch0B
		cVolFM		$0C
		cNote		cnF4, $0A
		cNote		cnA3
		cNote		cnB3
		cNote		cnA3
		cNote		cnC4
		cNote		cnA3
		cNote		cnE4
		cNote		cnA3
		cNote		cnG4
		cNote		cnB3
		cNote		cnC4
		cNote		cnB3
		cNote		cnD4
		cNote		cnB3
		cNote		cnC4
		cNote		cnB3
		cNote		cnE4
		cNote		cnG3
		cNote		cnA3
		cNote		cnG3
		cNote		cnB3
		cNote		cnG3
		cNote		cnD4
		cNote		cnC4
		cNote		cnF4
		cNote		cnA3
		cNote		cnB3
		cNote		cnA3
		cNote		cnC4
		cNote		cnA3
		cNote		cnE4
		cNote		cnA3
		cNote		cnG4
		cNote		cnB3
		cNote		cnC4
		cNote		cnB3
		cNote		cnD4
		cNote		cnB3
		cNote		cnC4
		cNote		cnB3
		cInsFM		patch01
		cVolFM		$0A
		cNote		cnB4, $28
		cNote		cnC5
		cNote		cnD5, $50
		cInsFM		patch0B
		cVolFM		$0D
		cNote		cnA3, $05
		cNote		cnB3
		cNote		cnC4
		cNote		cnD4
		cNote		cnE4
		cNote		cnF4
		cNote		cnG4
		cNote		cnA4
		cNote		cnB4
		cNote		cnC5
		cNote		cnD5
		cNote		cnE5
		cNote		cnF5
		cNote		cnG5
		cNote		cnA5
		cNote		cnB5
	cLoopEnd
	cStop

Song11_FM3:
	cLoopStart
		cInsFM		patch77
		cVolFM		$0D
		cRelease	$04
		cVibrato	$02, $0A
		cPan		cpCenter
		cNoteShift	$00, $00, $00
		cLoopCnt	$07
			cNote		cnD2, $0A
			cNote		cnRst
			cNote		cnE2, $14
			cNote		cnA1, $0A
			cNote		cnA1
			cNote		cnA1
			cNote		cnD2
			cNote		cnRst
			cNote		cnE2, $14
			cNote		cnA1, $0A
			cSlide		$50
			cNote		cnA2
			cSlideStop
			cNote		cnG2
			cNote		cnE2
			cNote		cnC2
			cNote		cnD2
			cNote		cnRst
			cNote		cnE2
			cNote		cnRst
			cNote		cnA1
			cNote		cnA1
			cNote		cnA1
			cNote		cnD2
			cNote		cnRst
			cNote		cnE2, $14
			cNote		cnA1, $05
			cNote		cnRst
			cNote		cnG1, $0A
			cNote		cnG1
			cNote		cnC2
			cNote		cnC2
		cLoopCntEnd
		cNote		cnF1, $0A
		cNote		cnF1
		cNote		cnG1
		cNote		cnRst
		cNote		cnA1
		cNote		cnRst
		cNote		cnC2
		cNote		cnG1
		cNote		cnRst
		cNote		cnG1
		cNote		cnA1
		cNote		cnRst
		cNote		cnB1
		cNote		cnB1
		cNote		cnD2
		cNote		cnD2
		cNote		cnE1
		cNote		cnE1
		cNote		cnG1
		cNote		cnRst
		cNote		cnD2
		cNote		cnRst
		cNote		cnG1
		cNote		cnF1, $14
		cNote		cnG1, $0A
		cNote		cnA1
		cNote		cnC2
		cNote		cnB1
		cNote		cnA1
		cNote		cnG1
		cNote		cnE1
		cNote		cnF1
		cNote		cnF1
		cNote		cnG1
		cNote		cnRst
		cNote		cnA1
		cNote		cnRst
		cNote		cnC2
		cNote		cnG1
		cNote		cnRst
		cNote		cnG1
		cNote		cnA1
		cNote		cnRst
		cNote		cnB1
		cNote		cnB1
		cNote		cnD2
		cNote		cnD2
		cNote		cnE1
		cNote		cnE1
		cNote		cnG1
		cNote		cnRst
		cNote		cnD2
		cNote		cnRst
		cNote		cnG1
		cNote		cnF1, $14
		cNote		cnG1, $0A
		cNote		cnA1
		cNote		cnB1
		cNote		cnC2
		cNote		cnD2
		cNote		cnE2
		cNote		cnF2
		cNote		cnG1
		cNote		cnRst
		cNote		cnG1
		cNote		cnG1
		cNote		cnRst
		cNote		cnG1
		cNote		cnRst
		cNote		cnG1
		cNote		cnRst
		cNote		cnG1, $1E
		cNote		cnE1, $14
		cNote		cnF1, $0A
		cNote		cnF1
		cNote		cnG1
		cNote		cnRst
		cNote		cnG1
		cNote		cnG1
		cNote		cnRst
		cNote		cnG1
		cNote		cnRst
		cNote		cnG1
		cNote		cnRst
		cNote		cnE1
		cNote		cnF1
		cNote		cnG1
		cNote		cnRst
		cNote		cnE1
		cNote		cnF1
		cNote		cnG1
		cNote		cnG1
		cNote		cnRst
		cNote		cnG1
		cNote		cnG1
		cNote		cnRst
		cNote		cnG1
		cNote		cnRst
		cNote		cnG1
		cNote		cnRst
		cNote		cnG1, $1E
		cNote		cnE1, $14
		cNote		cnF1, $0A
		cNote		cnF1
		cNote		cnG1
		cNote		cnRst
		cNote		cnG1
		cNote		cnG1
		cNote		cnRst
		cNote		cnG1
		cNote		cnRst
		cNote		cnG1
		cNote		cnRst
		cNote		cnA1
		cNote		cnC2
		cNote		cnA2
		cNote		cnG2
		cNote		cnF2
		cNote		cnE2
		cNote		cnC2
		cLoopCnt	$01
			cNote		cnF1, $0A
			cNote		cnF2
			cNote		cnF1
			cNote		cnF2
			cNote		cnF1
			cNote		cnF2
			cNote		cnF1
			cNote		cnF2
			cNote		cnG1
			cNote		cnG2
			cNote		cnG1
			cNote		cnG2
			cNote		cnG1
			cNote		cnG2
			cNote		cnG1
			cNote		cnG2
			cNote		cnE1
			cNote		cnE2
			cNote		cnE1
			cNote		cnE2
			cNote		cnE1
			cNote		cnE2
			cNote		cnE1
			cNote		cnE2
			cNote		cnF1
			cNote		cnF2
			cNote		cnE1
			cNote		cnE2
			cNote		cnF1
			cNote		cnF2
			cNote		cnG1
			cNote		cnG2
		cLoopCntEnd
	cLoopEnd
	cStop

Song11_FM4:
	cLoopStart
		cRelease	$01
		cVibrato	$02, $0A
		cPan		cpLeft
		cNoteShift	$00, $00, $00
		cLoopCnt	$01
			cVoltaLoop
				cInsFM		patch07
				cVolFM		$0B
				cNote		cnF3, $0A
				cNote		cnRst
				cNote		cnF3, $19
				cNote		cnRst, $05
				cNote		cnF3, $0A
				cNote		cnRst
				cNote		cnE3
				cNote		cnRst
				cNote		cnE3, $1E
				cNote		cnE3, $0A
				cNote		cnE3
				cNote		cnE3
				cNote		cnE3
				cNote		cnD3
				cNote		cnRst
				cNote		cnD3, $19
				cNote		cnRst, $05
				cNote		cnD3, $0A
				cNote		cnRst
				cNote		cnE3
				cNote		cnRst
				cNote		cnE3, $1E
				cNote		cnE3, $0A
				cNote		cnE3
				cNote		cnE3
				cNote		cnE3
				cVoltaSect1
				cVoltaSectEnd
				cVoltaSect2
			cVoltaLoop
				cInsFM		patch1F
				cVolFM		$0A
				cNote		cnF3, $0A
				cNote		cnRst
				cNote		cnF3, $19
				cNote		cnRst, $05
				cNote		cnE3, $0A
				cNote		cnRst
				cNote		cnF3
				cNote		cnRst
				cNote		cnF3, $19
				cNote		cnRst, $05
				cNote		cnG3, $0F
				cNote		cnRst, $05
				cNote		cnF3, $0F
				cNote		cnRst, $05
				cNote		cnF3, $0A
				cNote		cnRst
				cNote		cnF3, $19
				cNote		cnRst, $05
				cNote		cnG3, $0A
				cNote		cnRst
				cNote		cnF3
				cNote		cnRst
				cNote		cnE3, $19
				cNote		cnRst, $05
				cNote		cnD3, $0F
				cNote		cnRst, $05
				cNote		cnE3, $0F
				cNote		cnRst, $05
				cVoltaSect1
				cVoltaSectEnd
				cVoltaSect2
		cLoopCntEnd
		cNote		cnRst, $0A
		cInsFM		patch0C
		cVolFM		$07
		cNote		cnF4
		cNote		cnA3
		cNote		cnB3
		cNote		cnA3
		cNote		cnC4
		cNote		cnA3
		cNote		cnE4
		cNote		cnA3
		cNote		cnG4
		cNote		cnB3
		cNote		cnC4
		cNote		cnB3
		cNote		cnD4
		cNote		cnB3
		cNote		cnC4
		cNote		cnB3
		cNote		cnE4
		cNote		cnG3
		cNote		cnA3
		cNote		cnG3
		cNote		cnB3
		cNote		cnG3
		cNote		cnD4
		cNote		cnC4
		cNote		cnF4
		cNote		cnA3
		cNote		cnB3
		cNote		cnA3
		cNote		cnC4
		cNote		cnA3
		cNote		cnE4
		cNote		cnA3
		cNote		cnF4
		cNote		cnA3
		cNote		cnB3
		cNote		cnA3
		cNote		cnC4
		cNote		cnA3
		cNote		cnE4
		cNote		cnA3
		cNote		cnG4
		cNote		cnB3
		cNote		cnC4
		cNote		cnB3
		cNote		cnD4
		cNote		cnB3
		cNote		cnC4
		cNote		cnB3
		cNote		cnE4
		cNote		cnG3
		cNote		cnA3
		cNote		cnG3
		cNote		cnB3
		cNote		cnG3, $05
		cNote		cnA3
		cNote		cnB3
		cNote		cnC4
		cNote		cnD4
		cNote		cnE4
		cNote		cnA3
		cNote		cnB3
		cNote		cnC4
		cNote		cnD4
		cNote		cnE4
		cNote		cnF4
		cNote		cnG4
		cNote		cnA4
		cNote		cnB4
		cNote		cnC5
		cNote		cnD5
		cNote		cnE5
		cNote		cnF5
		cNote		cnG5
		cNote		cnA5
		cNote		cnB5
		cNote		cnRst, $50
		cNote		cnRst
		cNote		cnRst
		cNote		cnRst
		cInsFM		patch07
		cVolFM		$0A
		cNote		cnB2, $0A
		cNote		cnRst
		cNote		cnB2
		cNote		cnA3
		cNote		cnRst
		cNote		cnA3
		cNote		cnG3
		cNote		cnA2, $05
		cNote		cnB2
		cNote		cnC3, $0A
		cNote		cnD3
		cNote		cnE3
		cNote		cnD3
		cNote		cnC3
		cNote		cnB2, $19
		cNote		cnRst, $05
		cNote		cnB2, $0A
		cNote		cnRst
		cNote		cnB2
		cNote		cnA3
		cNote		cnRst
		cNote		cnA3
		cNote		cnG3
		cNote		cnA2, $05
		cNote		cnB2
		cNote		cnC3, $0A
		cNote		cnD3
		cNote		cnC3
		cNote		cnB3
		cNote		cnRst, $28
		cInsFM		patch0B
		cVolFM		$08
		cNote		cnF4, $0A
		cNote		cnA3
		cNote		cnB3
		cNote		cnA3
		cNote		cnC4
		cNote		cnA3
		cNote		cnE4
		cNote		cnA3
		cNote		cnG4
		cNote		cnB3
		cNote		cnC4
		cNote		cnB3
		cNote		cnD4
		cNote		cnB3
		cNote		cnC4
		cNote		cnB3
		cNote		cnE4
		cNote		cnG3
		cNote		cnA3
		cNote		cnG3
		cNote		cnB3
		cNote		cnG3
		cNote		cnD4
		cNote		cnC4
		cNote		cnF4
		cNote		cnA3
		cNote		cnB3
		cNote		cnA3
		cNote		cnC4
		cNote		cnA3
		cNote		cnE4
		cNote		cnA3
		cNote		cnG4
		cNote		cnB3
		cNote		cnC4
		cNote		cnB3
		cNote		cnD4
		cNote		cnB3
		cNote		cnC4
		cNote		cnB3
		cInsFM		patch01
		cVolFM		$07
		cNote		cnB4, $28
		cNote		cnC5
		cNote		cnD5, $50
		cInsFM		patch0B
		cVolFM		$09
		cNote		cnA3, $05
		cNote		cnB3
		cNote		cnC4
		cNote		cnD4
		cNote		cnE4
		cNote		cnF4
		cNote		cnG4
		cNote		cnA4
		cNote		cnB4
		cNote		cnC5
		cNote		cnD5
		cNote		cnE5
		cNote		cnF5
		cNote		cnG5
	cLoopEnd
	cStop

Song11_FM5:
	cNote		cnRst, $0E
	cLoopStart
		cRelease	$01
		cVibrato	$02, $0A
		cPan		cpCenter
		cNoteShift	$00, $03, $00
		cLoopCnt	$01
			cVoltaLoop
				cInsFM		patch07
				cVolFM		$0B
				cRelease	$01
				cNote		cnC4, $0A
				cNote		cnRst
				cNote		cnC4, $19
				cNote		cnRst, $05
				cNote		cnC4, $0A
				cNote		cnRst
				cNote		cnC4
				cNote		cnRst
				cNote		cnC4, $1E
				cNote		cnC4, $0A
				cNote		cnC4
				cNote		cnC4
				cNote		cnC4
				cNote		cnB3
				cNote		cnRst
				cNote		cnB3, $19
				cNote		cnRst, $05
				cNote		cnB3, $0A
				cNote		cnRst
				cNote		cnC4
				cNote		cnRst
				cNote		cnC4, $1E
				cNote		cnC4, $0A
				cNote		cnC4
				cNote		cnC4
				cNote		cnC4
				cVoltaSect1
				cVoltaSectEnd
				cVoltaSect2
			cVoltaLoop
				cInsFM		patch24
				cVolFM		$07
				cRelease	$03
				cNote		cnF3, $0A
				cNote		cnG3
				cNote		cnA3
				cNote		cnC4
				cNote		cnB3
				cNote		cnG3
				cNote		cnRst
				cNote		cnE3
				cNote		cnF3
				cNote		cnA3
				cNote		cnRst
				cNote		cnF3
				cNote		cnG3
				cNote		cnB3
				cNote		cnRst
				cNote		cnE3
				cVoltaSect1
					cNote		cnF3, $0A
					cNote		cnG3
					cNote		cnA3
					cNote		cnC4
					cNote		cnB3
					cNote		cnG3
					cNote		cnRst
					cNote		cnD3
					cNote		cnRst, $50
				cVoltaSectEnd
				cVoltaSect2
					cNote		cnF3, $0A
					cNote		cnG3
					cNote		cnA3
					cNote		cnC4
					cNote		cnD4, $14
					cNote		cnE4, $0A
					cNote		cnA3
					cNote		cnRst, $50
		cLoopCntEnd
		cInsFM		patch09
		cVolFM		$09
		cRelease	$01
		cNote		cnA3, $19
		cNote		cnRst, $05
		cNote		cnE4, $32
		cNote		cnE4, $0A
		cNote		cnD4
		cNote		cnC4
		cNote		cnB3, $14
		cNote		cnA3, $1E
		cNote		cnG3, $19
		cNote		cnRst, $05
		cNote		cnD4, $32
		cNote		cnC4, $0A
		cNote		cnD4, $05
		cVolFM		$00
		cNote		cnRst
		cVolFM		$09
		cNote		cnC4, $0A
		cNote		cnD4, $05
		cVolFM		$09
		cNote		cnRst
		cVolFM		$00
		cNote		cnC4, $28
		cNote		cnA3, $19
		cNote		cnRst, $05
		cNote		cnE4, $32
		cNote		cnE4, $0A
		cNote		cnD4
		cNote		cnC4
		cNote		cnB3, $14
		cNote		cnA3, $1E
		cNote		cnG3, $19
		cNote		cnRst, $05
		cNote		cnD4, $32
		cNote		cnC4, $0F
		cNote		cnRst, $05
		cNote		cnB3, $0F
		cNote		cnRst, $05
		cNote		cnC4, $0A
		cNote		cnD4, $1E
		cInsFM		patch07
		cVolFM		$0B
		cNote		cnG2, $0A
		cNote		cnRst
		cNote		cnG2
		cNote		cnF3
		cNote		cnRst
		cNote		cnF3
		cNote		cnE3
		cNote		cnG2, $05
		cNote		cnA2
		cNote		cnA2, $0A
		cNote		cnB2, $05
		cNote		cnRst
		cNote		cnA2, $0A
		cNote		cnB2, $05
		cNote		cnRst, $0F
		cNote		cnB2, $0A
		cNote		cnA2, $14
		cNote		cnG2, $0A
		cNote		cnRst
		cNote		cnG2
		cNote		cnF3
		cNote		cnRst
		cNote		cnF3
		cNote		cnE3
		cNote		cnF2, $05
		cNote		cnG2
		cNote		cnA2, $0A
		cNote		cnB2
		cNote		cnA2
		cNote		cnG3
		cNote		cnRst, $28
		cNote		cnG2, $0A
		cNote		cnRst
		cNote		cnG2
		cNote		cnF3
		cNote		cnRst
		cNote		cnF3
		cNote		cnE3
		cNote		cnF2, $05
		cNote		cnG2
		cNote		cnA2, $0A
		cNote		cnB2
		cNote		cnC3
		cNote		cnB2
		cNote		cnA2
		cNote		cnG2, $19
		cNote		cnRst, $05
		cNote		cnG2, $0A
		cNote		cnRst
		cNote		cnG2
		cNote		cnF3
		cNote		cnRst
		cNote		cnF3
		cNote		cnE3
		cNote		cnF2, $05
		cNote		cnG2
		cNote		cnA2, $0A
		cNote		cnB2
		cNote		cnA2
		cNote		cnG3
		cNote		cnRst, $28
		cInsFM		patch07
		cVolFM		$0A
		cNote		cnA3, $19
		cNote		cnRst, $05
		cNote		cnE4, $32
		cNote		cnE4, $0A
		cNote		cnD4
		cNote		cnC4
		cNote		cnB3, $14
		cNote		cnA3, $1E
		cNote		cnG3, $19
		cNote		cnRst, $05
		cNote		cnD4, $32
		cNote		cnC4, $0A
		cNote		cnD4, $05
		cNote		cnRst
		cNote		cnC4, $0A
		cNote		cnD4, $05
		cNote		cnRst
		cNote		cnC4, $28
		cNote		cnA3, $19
		cNote		cnRst, $05
		cNote		cnE4, $32
		cNote		cnE4, $0A
		cNote		cnD4
		cNote		cnC4
		cNote		cnB3, $14
		cNote		cnA3, $1E
		cNote		cnG3, $19
		cNote		cnRst, $05
		cNote		cnD4, $32
		cNote		cnC4, $0F
		cNote		cnRst, $05
		cNote		cnB3, $0F
		cNote		cnRst, $05
		cNote		cnC4, $0A
		cNote		cnD4, $1E
	cLoopEnd
	cStop

Song11_DAC:
	cLoopStart
		cPan		cpCenter
		cNote		cnC0, $14
		cNote		cnCs0
		cNote		cnC0
		cNote		cnCs0
		cNote		cnC0
		cNote		cnCs0
		cNote		cnC0
		cNote		cnCs0, $0A
		cNote		cnCs0
		cNote		cnC0, $14
		cNote		cnCs0
		cNote		cnC0
		cNote		cnCs0
		cNote		cnC0
		cNote		cnCs0
		cNote		cnC0, $0A
		cNote		cnCs0
		cNote		cnCs0
		cNote		cnCs0
		cNote		cnC0, $14
		cNote		cnCs0
		cNote		cnC0
		cNote		cnCs0
		cNote		cnC0
		cNote		cnCs0
		cNote		cnC0
		cNote		cnCs0, $0A
		cNote		cnCs0
		cNote		cnC0, $14
		cNote		cnCs0
		cNote		cnC0
		cNote		cnCs0
		cNote		cnC0, $0A
		cNote		cnCs0
		cNote		cnC0
		cNote		cnCs0
		cNote		cnC0
		cNote		cnCs0
		cNote		cnCs0
		cNote		cnCs0
		cNote		cnC0, $14
		cNote		cnCs0
		cNote		cnC0
		cNote		cnCs0
		cLoopCnt	$01
			cNote		cnC0, $14
			cNote		cnCs0
			cNote		cnC0
			cNote		cnCs0
		cLoopCntEnd
		cNote		cnC0, $14
		cNote		cnCs0
		cNote		cnC0
		cNote		cnCs0, $0A
		cNote		cnCs0
		cLoopCnt	$01
			cNote		cnC0, $14
			cNote		cnCs0
			cNote		cnC0
			cNote		cnCs0
			cNote		cnC0
			cNote		cnCs0
			cNote		cnC0
			cNote		cnCs0
			cNote		cnC0
			cNote		cnCs0
			cNote		cnC0
			cNote		cnCs0
			cNote		cnC0
			cNote		cnCs0
			cNote		cnC0
			cNote		cnCs0, $0A
			cNote		cnCs0
		cLoopCntEnd
		cLoopCnt	$01
			cNote		cnC0, $14
			cNote		cnCs0
			cNote		cnC0
			cNote		cnCs0
			cNote		cnC0
			cNote		cnCs0
			cNote		cnC0
			cNote		cnCs0
			cNote		cnC0
			cNote		cnCs0
			cNote		cnC0
			cNote		cnCs0
			cNote		cnC0
			cNote		cnCs0
			cNote		cnC0, $0A
			cNote		cnCs0
			cNote		cnCs0
			cNote		cnCs0
		cLoopCntEnd
		cLoopCnt	$01
			cNote		cnC0, $14
			cNote		cnCs0
			cNote		cnC0
			cNote		cnCs0
		cLoopCntEnd
		cNote		cnC0, $14
		cNote		cnCs0
		cNote		cnC0
		cNote		cnD0, $0A
		cNote		cnD0
		cNote		cnRst
		cNote		cnDs0, $14
		cNote		cnE0
		cNote		cnCs0, $0A
		cNote		cnCs0
		cNote		cnCs0
		cLoopCnt	$02
			cNote		cnC0, $14
			cNote		cnCs0
			cNote		cnC0
			cNote		cnCs0
			cNote		cnC0
			cNote		cnCs0
			cNote		cnC0
			cNote		cnCs0
			cNote		cnC0
			cNote		cnCs0
			cNote		cnC0
			cNote		cnCs0
			cNote		cnC0
			cNote		cnCs0
			cNote		cnC0
			cNote		cnCs0, $0A
			cNote		cnCs0
		cLoopCntEnd
		cLoopCnt	$02
			cNote		cnC0, $14
			cNote		cnCs0
			cNote		cnC0
			cNote		cnCs0
		cLoopCntEnd
		cPan		cpLeft
		cNote		cnD0, $0A
		cNote		cnD0
		cPan		cpCenter
		cNote		cnDs0
		cNote		cnDs0
		cPan		cpRight
		cNote		cnE0
		cNote		cnE0
		cPan		cpCenter
		cNote		cnCs0
		cNote		cnCs0
		cLoopCnt	$01
			cNote		cnC0, $14
			cNote		cnCs0
			cNote		cnC0
			cNote		cnCs0
			cNote		cnC0
			cNote		cnCs0
			cNote		cnC0
			cNote		cnCs0
			cNote		cnC0
			cNote		cnCs0
			cNote		cnC0
			cNote		cnCs0
			cNote		cnC0
			cNote		cnCs0
			cNote		cnC0
			cNote		cnCs0, $0A
			cNote		cnCs0
		cLoopCntEnd
	cLoopEnd
	cStop

Song11_PSG1:
	cStop

Song11_PSG2:
	cStop

Song11_PSG3:
	cStop

Song11_Noise:
	cLoopStart
		cRelease	$01
		cInsVolPSG	$0F, $0C
		cNote		cnRst, $0A
		cNote		cnG0, $0A
	cLoopEnd
	cStop
