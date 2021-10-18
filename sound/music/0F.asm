Song0F_Start:
	cType		ctMusic
	cFadeOut	$0000
	cTempo		$C0
	cChannel	Song0F_FM1
	cChannel	Song0F_FM2
	cChannel	Song0F_FM3
	cChannel	Song0F_FM4
	cChannel	Song0F_FM5
	cChannel	Song0F_DAC
	cChannel	Song0F_PSG1
	cChannel	Song0F_PSG2
	cChannel	Song0F_PSG3
	cChannel	Song0F_Noise

Song0F_FM1:
	cInsFM		patch12
	cVolFM		$0B
	cRelease	$01
	cVibrato	$02, $0A
	cPan		cpCenter
	cLoopCnt	$02
		cNote		cnC3, $08
		cNote		cnDs3
		cNote		cnG3
		cNote		cnF3
		cNote		cnRst
		cNote		cnG3, $10
		cNote		cnDs3
		cNote		cnF3
		cNote		cnD3, $08
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
	cLoopStart
		cInsFM		patch03
		cVolFM		$0C
		cNote		cnC4, $08
		cNote		cnRst
		cNote		cnAs3
		cNote		cnC4
		cNote		cnRst
		cNote		cnAs3
		cNote		cnC4
		cNote		cnRst
		cNote		cnAs3
		cNote		cnC4
		cNote		cnRst
		cNote		cnAs3
		cNote		cnC4, $10
		cNote		cnAs3
		cNote		cnAs3, $08
		cNote		cnC4
		cNote		cnD4
		cNote		cnDs4
		cNote		cnC4
		cNote		cnD4
		cNote		cnDs4
		cNote		cnAs4
		cNote		cnRst
		cNote		cnGs4
		cNote		cnRst
		cNote		cnG4
		cNote		cnF4
		cNote		cnDs4
		cNote		cnD4, $10
		cNote		cnDs4, $08
		cNote		cnRst
		cNote		cnD4
		cNote		cnC4
		cNote		cnD4
		cNote		cnDs4
		cNote		cnRst
		cNote		cnD4
		cNote		cnRst, $10
		cNote		cnDs4, $08
		cNote		cnD4
		cNote		cnC4, $15
		cNote		cnRst, $0B
		cNote		cnD4, $40
		cNote		cnDs4, $1B
		cNote		cnRst, $05
		cNote		cnD4, $1B
		cNote		cnRst, $05
		cNote		cnRst, $10
		cNote		cnDs4, $08
		cNote		cnD4
		cNote		cnC4
		cNote		cnAs3
		cNote		cnC4
		cNote		cnD4
		cNote		cnDs4
		cNote		cnRst, $10
		cNote		cnDs4, $08
		cNote		cnD4
		cNote		cnC4
		cNote		cnAs3
		cNote		cnC4
		cNote		cnD4
		cNote		cnDs4
		cNote		cnRst, $10
		cNote		cnDs4, $08
		cNote		cnD4
		cNote		cnC4
		cNote		cnAs3
		cNote		cnC4
		cNote		cnD4
		cNote		cnDs4
		cNote		cnF4
		cNote		cnG4
		cNote		cnGs4
		cNote		cnAs4
		cNote		cnGs4
		cNote		cnG4
		cNote		cnF4
		cNote		cnDs4, $70
		cNote		cnG4, $08
		cNote		cnDs4
		cNote		cnC4, $20
		cNote		cnG3, $50
		cInsFM		patch12
		cVolFM		$0D
		cNote		cnRst, $10
		cNote		cnAs2, $08
		cNote		cnDs3
		cNote		cnAs3
		cNote		cnAs2
		cNote		cnDs3
		cNote		cnAs3
		cNote		cnAs2
		cNote		cnDs3
		cNote		cnAs3
		cNote		cnAs2
		cNote		cnDs3
		cNote		cnAs3
		cNote		cnAs2
		cNote		cnDs3
		cNote		cnAs3
		cNote		cnAs2
		cNote		cnDs3
		cNote		cnAs3
		cNote		cnAs2
		cNote		cnDs3
		cNote		cnAs3
		cNote		cnAs2
		cNote		cnDs3
		cNote		cnAs3
		cNote		cnAs2
		cNote		cnDs3
		cNote		cnAs3
		cNote		cnAs2
		cNote		cnDs3
		cNote		cnAs3
		cNote		cnGs2
		cNote		cnC3
		cNote		cnGs3
		cNote		cnAs2
		cNote		cnDs3
		cNote		cnAs3
		cNote		cnGs2
		cNote		cnC3
		cNote		cnGs3
		cNote		cnAs2
		cNote		cnDs3
		cNote		cnAs3
		cNote		cnGs2
		cNote		cnC3
		cNote		cnGs3
		cNote		cnAs2
		cNote		cnD3
		cNote		cnAs3
		cNote		cnGs3
		cNote		cnG3
		cNote		cnGs3
		cNote		cnG3
		cNote		cnF3
		cNote		cnG3
		cNote		cnF3
		cNote		cnDs3
		cNote		cnD3
		cNote		cnD3
		cNote		cnRst, $10
		cNote		cnAs2
		cNote		cnC3, $08
		cNote		cnD3
		cNote		cnDs3
		cNote		cnC3
		cNote		cnRst
		cNote		cnD3, $10
		cNote		cnDs3, $08
		cNote		cnF3, $05
		cNote		cnRst, $0B
		cNote		cnDs3, $08
		cNote		cnAs2, $28
		cNote		cnC3, $08
		cNote		cnD3
		cNote		cnDs3
		cNote		cnC3
		cNote		cnRst
		cNote		cnD3, $10
		cNote		cnDs3, $08
		cNote		cnF3
		cNote		cnRst
		cNote		cnDs3
		cNote		cnAs2, $28
		cNote		cnF3, $08
		cNote		cnDs3
		cNote		cnF3, $20
		cNote		cnDs3, $08
		cNote		cnD3
		cNote		cnDs3, $18
		cNote		cnD3, $08
		cNote		cnC3
		cNote		cnD3, $18
		cNote		cnC3, $40
		cNote		cnB2
	cLoopEnd
	cStop

Song0F_FM2:
	cInsFM		patch09
	cVolFM		$0D
	cRelease	$01
	cVibrato	$02, $0A
	cPan		cpRight
	cNote		cnC2, $80
	cNote		cnD2
	cNote		cnDs2
	cNote		cnF2, $40
	cNote		cnG2
	cLoopStart
		cInsFM		patch21
		cVolFM		$09
		cNote		cnC3, $10
		cNote		cnC3, $08
		cNote		cnDs3
		cNote		cnG3, $10
		cNote		cnDs3
		cNote		cnG3
		cNote		cnDs3
		cNote		cnC3
		cNote		cnG2
		cNote		cnAs2
		cNote		cnAs2, $08
		cNote		cnD3
		cNote		cnF3, $10
		cNote		cnD3
		cNote		cnF3
		cNote		cnD3
		cNote		cnAs2
		cNote		cnF2
		cNote		cnGs2
		cNote		cnGs2, $08
		cNote		cnC3
		cNote		cnDs3, $10
		cNote		cnC3
		cNote		cnDs3
		cNote		cnC3
		cNote		cnGs2
		cNote		cnDs2
		cNote		cnG2
		cNote		cnG2, $08
		cNote		cnB2
		cNote		cnD3, $10
		cNote		cnB2
		cNote		cnD3
		cNote		cnB2
		cNote		cnG2
		cNote		cnD2
	cLoopEnd
	cStop

Song0F_FM3:
	cLoopStart
		cInsFM		patch1E
		cVolFM		$0C
		cRelease	$01
		cVibrato	$02, $0A
		cNote		cnC1, $10
		cNote		cnC1, $04
		cNote		cnRst
		cNote		cnC1
		cNote		cnRst, $0C
		cNote		cnC1, $04
		cNote		cnRst
		cNote		cnC1, $10
		cNote		cnC1
		cNote		cnC1, $04
		cNote		cnRst
		cNote		cnC1
		cNote		cnRst, $0C
		cNote		cnC1, $04
		cNote		cnRst
		cNote		cnC1, $10
		cNote		cnAs0
		cNote		cnAs0, $04
		cNote		cnRst
		cNote		cnAs0
		cNote		cnRst, $0C
		cNote		cnAs0, $04
		cNote		cnRst
		cNote		cnAs0, $10
		cNote		cnAs0
		cNote		cnAs0, $04
		cNote		cnRst
		cNote		cnAs0
		cNote		cnRst, $0C
		cNote		cnAs0, $04
		cNote		cnRst
		cNote		cnAs0, $10
		cNote		cnGs0
		cNote		cnGs0, $04
		cNote		cnRst
		cNote		cnGs0
		cNote		cnRst, $0C
		cNote		cnGs0, $04
		cNote		cnRst
		cNote		cnGs0, $10
		cNote		cnGs0
		cNote		cnGs0, $04
		cNote		cnRst
		cNote		cnGs0
		cNote		cnRst, $0C
		cNote		cnGs0, $04
		cNote		cnRst
		cNote		cnGs0, $10
		cNote		cnG0
		cNote		cnG0, $04
		cNote		cnRst
		cNote		cnG0
		cNote		cnRst, $0C
		cNote		cnG0, $04
		cNote		cnRst
		cNote		cnG0, $10
		cNote		cnG0
		cNote		cnG0, $04
		cNote		cnRst
		cNote		cnG0
		cNote		cnRst, $0C
		cNote		cnG0, $04
		cNote		cnRst
		cNote		cnG0, $10
	cLoopEnd
	cStop

Song0F_FM4:
	cNote		cnRst, $13
	cInsFM		patch12
	cVolFM		$09
	cRelease	$01
	cVibrato	$02, $0A
	cPan		cpCenter
	cLoopCnt	$02
		cNote		cnC3, $08
		cNote		cnDs3
		cNote		cnG3
		cNote		cnF3
		cNote		cnRst
		cNote		cnG3, $10
		cNote		cnDs3
		cNote		cnF3
		cNote		cnD3, $08
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
	cLoopStart
		cInsFM		patch03
		cVolFM		$09
		cNote		cnC4, $08
		cNote		cnRst
		cNote		cnAs3
		cNote		cnC4
		cNote		cnRst
		cNote		cnAs3
		cNote		cnC4
		cNote		cnRst
		cNote		cnAs3
		cNote		cnC4
		cNote		cnRst
		cNote		cnAs3
		cNote		cnC4, $10
		cNote		cnAs3
		cNote		cnAs3, $08
		cNote		cnC4
		cNote		cnD4
		cNote		cnDs4
		cNote		cnC4
		cNote		cnD4
		cNote		cnDs4
		cNote		cnAs4
		cNote		cnRst
		cNote		cnGs4
		cNote		cnRst
		cNote		cnG4
		cNote		cnF4
		cNote		cnDs4
		cNote		cnD4, $10
		cNote		cnDs4, $08
		cNote		cnRst
		cNote		cnD4
		cNote		cnC4
		cNote		cnD4
		cNote		cnDs4
		cNote		cnRst
		cNote		cnD4
		cNote		cnRst, $10
		cNote		cnDs4, $08
		cNote		cnD4
		cNote		cnC4, $15
		cNote		cnRst, $0B
		cNote		cnD4, $40
		cNote		cnDs4, $1B
		cNote		cnRst, $05
		cNote		cnD4, $1B
		cNote		cnRst, $05
		cNote		cnRst, $10
		cNote		cnDs4, $08
		cNote		cnD4
		cNote		cnC4
		cNote		cnAs3
		cNote		cnC4
		cNote		cnD4
		cNote		cnDs4
		cNote		cnRst, $10
		cNote		cnDs4, $08
		cNote		cnD4
		cNote		cnC4
		cNote		cnAs3
		cNote		cnC4
		cNote		cnD4
		cNote		cnDs4
		cNote		cnRst, $10
		cNote		cnDs4, $08
		cNote		cnD4
		cNote		cnC4
		cNote		cnAs3
		cNote		cnC4
		cNote		cnD4
		cNote		cnDs4
		cNote		cnF4
		cNote		cnG4
		cNote		cnGs4
		cNote		cnAs4
		cNote		cnGs4
		cNote		cnG4
		cNote		cnF4
		cNote		cnDs4, $70
		cNote		cnG4, $08
		cNote		cnDs4
		cNote		cnC4, $20
		cNote		cnG3, $50
		cInsFM		patch12
		cVolFM		$0A
		cNote		cnRst, $10
		cNote		cnAs2, $08
		cNote		cnDs3
		cNote		cnAs3
		cNote		cnAs2
		cNote		cnDs3
		cNote		cnAs3
		cNote		cnAs2
		cNote		cnDs3
		cNote		cnAs3
		cNote		cnAs2
		cNote		cnDs3
		cNote		cnAs3
		cNote		cnAs2
		cNote		cnDs3
		cNote		cnAs3
		cNote		cnAs2
		cNote		cnDs3
		cNote		cnAs3
		cNote		cnAs2
		cNote		cnDs3
		cNote		cnAs3
		cNote		cnAs2
		cNote		cnDs3
		cNote		cnAs3
		cNote		cnAs2
		cNote		cnDs3
		cNote		cnAs3
		cNote		cnAs2
		cNote		cnDs3
		cNote		cnAs3
		cNote		cnGs2
		cNote		cnC3
		cNote		cnGs3
		cNote		cnAs2
		cNote		cnDs3
		cNote		cnAs3
		cNote		cnGs2
		cNote		cnC3
		cNote		cnGs3
		cNote		cnAs2
		cNote		cnDs3
		cNote		cnAs3
		cNote		cnGs2
		cNote		cnC3
		cNote		cnGs3
		cNote		cnAs2
		cNote		cnD3
		cNote		cnAs3
		cNote		cnGs3
		cNote		cnG3
		cNote		cnGs3
		cNote		cnG3
		cNote		cnF3
		cNote		cnG3
		cNote		cnF3
		cNote		cnDs3
		cNote		cnD3
		cNote		cnD3
		cNote		cnRst, $10
		cNote		cnAs2
		cNote		cnC3, $08
		cNote		cnD3
		cNote		cnDs3
		cNote		cnC3
		cNote		cnRst
		cNote		cnD3, $10
		cNote		cnDs3, $08
		cNote		cnF3, $05
		cNote		cnRst, $0B
		cNote		cnDs3, $08
		cNote		cnAs2, $28
		cNote		cnC3, $08
		cNote		cnD3
		cNote		cnDs3
		cNote		cnC3
		cNote		cnRst
		cNote		cnD3, $10
		cNote		cnDs3, $08
		cNote		cnF3
		cNote		cnRst
		cNote		cnDs3
		cNote		cnAs2, $28
		cNote		cnF3, $08
		cNote		cnDs3
		cNote		cnF3, $20
		cNote		cnDs3, $08
		cNote		cnD3
		cNote		cnDs3, $18
		cNote		cnD3, $08
		cNote		cnC3
		cNote		cnD3, $18
		cNote		cnC3, $40
		cNote		cnB2
	cLoopEnd
	cStop

Song0F_FM5:
	cNote		cnRst, $02
	cInsFM		patch09
	cVolFM		$0C
	cRelease	$01
	cVibrato	$02, $0A
	cPan		cpLeft
	cNote		cnC3, $80
	cNote		cnD3
	cNote		cnDs3
	cNote		cnF3, $40
	cNote		cnG3
	cLoopStart
		cInsFM		patch21
		cVolFM		$09
		cNote		cnC3, $10
		cNote		cnC3, $08
		cNote		cnDs3
		cNote		cnG3, $10
		cNote		cnDs3
		cNote		cnG3
		cNote		cnDs3
		cNote		cnC3
		cNote		cnG2
		cNote		cnAs2
		cNote		cnAs2, $08
		cNote		cnD3
		cNote		cnF3, $10
		cNote		cnD3
		cNote		cnF3
		cNote		cnD3
		cNote		cnAs2
		cNote		cnF2
		cNote		cnGs2
		cNote		cnGs2, $08
		cNote		cnC3
		cNote		cnDs3, $10
		cNote		cnC3
		cNote		cnDs3
		cNote		cnC3
		cNote		cnGs2
		cNote		cnDs2
		cNote		cnG2
		cNote		cnG2, $08
		cNote		cnB2
		cNote		cnD3, $10
		cNote		cnB2
		cNote		cnD3
		cNote		cnB2
		cNote		cnG2
		cNote		cnD2
	cLoopEnd
	cStop

Song0F_DAC:
	cLoopStart
		cNote		cnC0, $10
		cNote		cnC0, $08
		cNote		cnC0
		cNote		cnCs0, $10
		cNote		cnC0, $08
		cNote		cnC0
		cNote		cnC0, $10
		cNote		cnC0, $08
		cNote		cnC0
		cNote		cnCs0, $10
		cNote		cnC0, $08
		cNote		cnC0
	cLoopEnd
	cStop

Song0F_PSG1:
	cStop

Song0F_PSG2:
	cStop

Song0F_PSG3:
	cStop

Song0F_Noise:
	cInsVolPSG	$0F, $0D
	cLoopStart
		cNote		cnRst, $08
		cInsVolPSG	$0F, $0E
		cNote		cnG0
		cInsVolPSG	$0F, $0C
		cNote		cnG0
		cNote		cnG0
		cNote		cnRst
		cNote		cnRst
		cNote		cnG0
		cNote		cnG0
		cNote		cnRst
		cNote		cnG0
		cInsVolPSG	$0F, $0E
		cNote		cnG0
		cInsVolPSG	$0F, $0C
		cNote		cnG0
		cNote		cnRst
		cNote		cnG0
		cNote		cnG0
		cNote		cnG0
	cLoopEnd
	cStop
