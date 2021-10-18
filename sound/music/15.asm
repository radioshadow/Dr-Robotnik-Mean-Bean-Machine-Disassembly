Song15_Start:
	cType		ctMusic
	cFadeOut	$0000
	cTempo		$C5
	cChannel	Song15_FM1
	cChannel	Song15_FM2
	cChannel	Song15_FM3
	cChannel	Song15_FM4
	cChannel	Song15_FM5
	cChannel	Song15_DAC
	cChannel	Song15_PSG1
	cChannel	Song15_PSG2
	cChannel	Song15_PSG3
	cChannel	Song15_Noise

Song15_FM1:
	cInsFM		patch4D
	cVolFM		$0F
	cRelease	$01
	cVibrato	$04, $0F
	cPan		cpCenter
	cNoteShift	$00, $00, $05
	cSustain
	cNote		cnF2, $32
	cSlide		$01
	cNote		cnF1, $60
	cNote		cnF1, $30
	cRelease	$01
	cNote		cnF1, $60
	cSlideStop
	cStop

Song15_FM2:
	cInsFM		patch4E
	cVolFM		$0F
	cVibrato	$02, $02
	cPan		cpCenter
	cNoteShift	$00, $00, $00
	cSustain
	cNote		cnF1, $22
	cSlide		$01
	cNote		cnF0, $70
	cNote		cnF0, $30
	cRelease	$01
	cNote		cnF0, $60
	cSlideStop
	cStop

Song15_FM3:
	cNote		cnRst, $03
	cInsFM		patch4E
	cVolFM		$0F
	cVibrato	$02, $02
	cPan		cpCenter
	cNoteShift	$00, $00, $00
	cSustain
	cNote		cnF1, $22
	cSlide		$01
	cNote		cnF0, $70
	cNote		cnF0, $30
	cRelease	$01
	cNote		cnF0, $60
	cSlideStop
	cStop

Song15_FM4:
	cNote		cnRst, $07
	cInsFM		patch4E
	cVolFM		$0F
	cVibrato	$02, $02
	cPan		cpCenter
	cNoteShift	$00, $00, $00
	cSustain
	cNote		cnF1, $22
	cSlide		$01
	cNote		cnF0, $70
	cNote		cnF0, $30
	cRelease	$01
	cNote		cnF0, $60
	cSlideStop
	cStop

Song15_FM5:
	cNote		cnRst, $0A
	cInsFM		patch4E
	cVolFM		$0F
	cVibrato	$02, $02
	cPan		cpCenter
	cNoteShift	$00, $00, $00
	cSustain
	cNote		cnF1, $22
	cSlide		$01
	cNote		cnF0, $70
	cNote		cnF0, $30
	cRelease	$01
	cNote		cnF0, $60
	cSlideStop
	cStop

Song15_DAC:
	cRelease	$01
	cNote		cnRst, $0F
	cNote		cnE1, $1E
	cNote		cnRst, $32
	cNote		cnCs1, $32
	cStop

Song15_PSG1:

Song15_PSG2:

Song15_PSG3:

Song15_Noise:
	cStop
