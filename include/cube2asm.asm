; --------------------------------------------------------------
; Music/SFX types
; --------------------------------------------------------------

ctMusic		EQU	$00				; Music
ctSFX1		EQU	$01				; SFX type 1
ctSFX2		EQU	$02				; SFX type 2

; --------------------------------------------------------------
; Notes
; --------------------------------------------------------------

cnRst		EQU	$70				; Rest

cnC0		EQU	$00				; Octave 0
cnCs0		EQU	$01
cnDb0		EQU	$01
cnD0		EQU	$02
cnDs0		EQU	$03
cnEb0		EQU	$03
cnE0		EQU	$04
cnF0		EQU	$05
cnFs0		EQU	$06
cnGb0		EQU	$06
cnG0		EQU	$07
cnGs0		EQU	$08
cnAb0		EQU	$08
cnA0		EQU	$09
cnAs0		EQU	$0A
cnBb0		EQU	$0A
cnB0		EQU	$0B

cnC1		EQU	$0C				; Octave 1
cnCs1		EQU	$0D
cnDb1		EQU	$0D
cnD1		EQU	$0E
cnDs1		EQU	$0F
cnEb1		EQU	$0F
cnE1		EQU	$10
cnF1		EQU	$11
cnFs1		EQU	$12
cnGb1		EQU	$12
cnG1		EQU	$13
cnGs1		EQU	$14
cnAb1		EQU	$14
cnA1		EQU	$15
cnAs1		EQU	$16
cnBb1		EQU	$16
cnB1		EQU	$17

cnC2		EQU	$18				; Octave 2
cnCs2		EQU	$19
cnDb2		EQU	$19
cnD2		EQU	$1A
cnDs2		EQU	$1B
cnEb2		EQU	$1B
cnE2		EQU	$1C
cnF2		EQU	$1D
cnFs2		EQU	$1E
cnGb2		EQU	$1E
cnG2		EQU	$1F
cnGs2		EQU	$20
cnAb2		EQU	$20
cnA2		EQU	$21
cnAs2		EQU	$22
cnBb2		EQU	$22
cnB2		EQU	$23

cnC3		EQU	$24				; Octave 3
cnCs3		EQU	$25
cnDb3		EQU	$25
cnD3		EQU	$26
cnDs3		EQU	$27
cnEb3		EQU	$27
cnE3		EQU	$28
cnF3		EQU	$29
cnFs3		EQU	$2A
cnGb3		EQU	$2A
cnG3		EQU	$2B
cnGs3		EQU	$2C
cnAb3		EQU	$2C
cnA3		EQU	$2D
cnAs3		EQU	$2E
cnBb3		EQU	$2E
cnB3		EQU	$2F

cnC4		EQU	$30				; Octave 4
cnCs4		EQU	$31
cnDb4		EQU	$31
cnD4		EQU	$32
cnDs4		EQU	$33
cnEb4		EQU	$33
cnE4		EQU	$34
cnF4		EQU	$35
cnFs4		EQU	$36
cnGb4		EQU	$36
cnG4		EQU	$37
cnGs4		EQU	$38
cnAb4		EQU	$38
cnA4		EQU	$39
cnAs4		EQU	$3A
cnBb4		EQU	$3A
cnB4		EQU	$3B

cnC5		EQU	$3C				; Octave 5
cnCs5		EQU	$3D
cnDb5		EQU	$3D
cnD5		EQU	$3E
cnDs5		EQU	$3F
cnEb5		EQU	$3F
; The rest of the notes are FM only
cnE5		EQU	$40
cnF5		EQU	$41
cnFs5		EQU	$42
cnGb5		EQU	$42
cnG5		EQU	$43
cnGs5		EQU	$44
cnAb5		EQU	$44
cnA5		EQU	$45
cnAs5		EQU	$46
cnBb5		EQU	$46
cnB5		EQU	$47

cnC6		EQU	$48				; Octave 6
cnCs6		EQU	$49
cnDb6		EQU	$49
cnD6		EQU	$4A
cnDs6		EQU	$4B
cnEb6		EQU	$4B
cnE6		EQU	$4C
cnF6		EQU	$4D
cnFs6		EQU	$4E
cnGb6		EQU	$4E
cnG6		EQU	$4F
cnGs6		EQU	$50
cnAb6		EQU	$50
cnA6		EQU	$51
cnAs6		EQU	$52
cnBb6		EQU	$52
cnB6		EQU	$53

cnMaxFM		EQU	cnB6				; Max FM note
cnMaxPSG	EQU	cnDs5				; Max PSG note

; --------------------------------------------------------------
; Panning
; --------------------------------------------------------------

cpNone		EQU	$00
cpRight		EQU	$40
cpLeft		EQU	$80
cpCenter	EQU	$C0
cpCentre	EQU	$C0				; Silly brits :U

; --------------------------------------------------------------
; Store a pointer for the Z80
; --------------------------------------------------------------
; PARAMETERS:
;	addr	- Address to store
; --------------------------------------------------------------

ZDW macros addr

	dc.b	\addr&$FF, ((\addr>>8)&$7F)|$80

; --------------------------------------------------------------
; Set music/SFX type
; --------------------------------------------------------------
; PARAMETERS:
;	 type	- Music/SFX type
; --------------------------------------------------------------

cType macros type

	dc.b	\type

; --------------------------------------------------------------
; Set fade out timer
; --------------------------------------------------------------
; PARAMETERS:
;	time	- Time it takes before it fades out
; --------------------------------------------------------------

cFadeOut macros time

	dc.b	(\time)&$FF, (\time)>>8

; --------------------------------------------------------------
; Set tempo
; --------------------------------------------------------------
; PARAMETERS:
;	tempo	- Tempo
; --------------------------------------------------------------

cTempo macros tempo

	dc.b	\tempo

; --------------------------------------------------------------
; Channel pointer
; --------------------------------------------------------------
; PARAMETERS:
;	addr	- Channel address
; --------------------------------------------------------------

cChannel macros addr

	ZDW	\addr

; --------------------------------------------------------------
; Store a note
; --------------------------------------------------------------
; PARAMETERS:
;	note	- Note ID
;	length	- Note length (optional)
; --------------------------------------------------------------

cNote macro note, length

	if (narg=1)
		dc.b	\note
	else
		dc.b	(\note)|$80, \length
	endif

	endm

; --------------------------------------------------------------
; Main loop start
; --------------------------------------------------------------

cLoopStart macros

	dc.b	$F8, $00

; --------------------------------------------------------------
; Main loop end
; --------------------------------------------------------------

cLoopEnd macros

	dc.b	$F8, $A1

; --------------------------------------------------------------
; Set volta loop position
; --------------------------------------------------------------

cVoltaLoop macros

	dc.b	$F8, $20

; --------------------------------------------------------------
; Volta section 1 start
; --------------------------------------------------------------

cVoltaSect1 macros

	dc.b	$F8, $40

; --------------------------------------------------------------
; Volta section 2 start
; --------------------------------------------------------------

cVoltaSect2 macros

	dc.b	$F8, $60

; --------------------------------------------------------------
; Volta section 3 start
; --------------------------------------------------------------

cVoltaSect3 macros

	dc.b	$F8, $80

; --------------------------------------------------------------
; Volta section end
; --------------------------------------------------------------

cVoltaSectEnd macros

	dc.b	$F8, $A0

; --------------------------------------------------------------
; Loop (with counter) start
; --------------------------------------------------------------
; PARAMETERS:
;	count	- Loop count
; --------------------------------------------------------------

cLoopCnt macros count

	dc.b	$F8, $C0|(\count)

; --------------------------------------------------------------
; Loop (with counter) end
; --------------------------------------------------------------

cLoopCntEnd macros count

	dc.b	$F8, $E0

; --------------------------------------------------------------
; Set note shift
; --------------------------------------------------------------
; PARAMETERS:
;	dir	- Shift direction
;	detune	- Detune
;	trns	- Transposition
; --------------------------------------------------------------

cNoteShift macros dir, detune, trns

	dc.b	$F9, ((\dir)<<7)|((\detune)<<4)|(\trns)

; --------------------------------------------------------------
; Set panning
; --------------------------------------------------------------
; PARAMETERS:
;	pan	- Pan settings
; --------------------------------------------------------------

cPan macros pan

	dc.b	$FA, \pan

; --------------------------------------------------------------
; Set tempo
; --------------------------------------------------------------
; PARAMETERS:
;	tempo	- Tempo
; --------------------------------------------------------------

cSetTempo macros tempo

	dc.b	$FA, \tempo

; --------------------------------------------------------------
; Set vibrato
; --------------------------------------------------------------
; PARAMETERS:
;	vib	- Vibrato ID
;	delay	- Vibrato delay
; --------------------------------------------------------------

cVibrato macros vib, delay

	dc.b	$FB, ((\vib)<<4)|(\delay)

; --------------------------------------------------------------
; Set note slide
; --------------------------------------------------------------
; PARAMETERS:
;	speed	- Slide speed
; --------------------------------------------------------------

cSlide macros speed

	dc.b	$FC, (\speed)|$80

; --------------------------------------------------------------
; Stop note slide
; --------------------------------------------------------------

cSlideStop macros

	dc.b	$FC, $FF

; --------------------------------------------------------------
; Set note release time
; --------------------------------------------------------------
; PARAMETERS:
;	time	- Key release time
; --------------------------------------------------------------

cRelease macros time

	dc.b	$FC, \time

; --------------------------------------------------------------
; Set note sustain
; --------------------------------------------------------------

cSustain macros

	dc.b	$FC, $80

; --------------------------------------------------------------
; Set FM volume
; --------------------------------------------------------------
; PARAMETERS:
;	vol	- FM volume
; --------------------------------------------------------------

cVolFM macros vol

	dc.b	$FD, \vol

; --------------------------------------------------------------
; Set PSG instrument and volume
; --------------------------------------------------------------
; PARAMETERS:
;	ins	- PSG instrument
;	vol	- PSG volume
; --------------------------------------------------------------

cInsVolPSG macros ins, vol

	dc.b	$FD, ((\ins)<<4)|(\vol)

; --------------------------------------------------------------
; Set FM instrument
; --------------------------------------------------------------
; PARAMETERS:
;	INS	- FM instrument
; --------------------------------------------------------------

cInsFM macros ins

	dc.b	$FE, \ins

; --------------------------------------------------------------
; Stop channel
; --------------------------------------------------------------

cStop macros

	dc.b	$FF, $00, $00

; --------------------------------------------------------------
; Play sound
; --------------------------------------------------------------
; PARAMETERS:
;	id	- Sound ID
; --------------------------------------------------------------

cPlay macros id

	dc.b	$FF, \id, $00

; --------------------------------------------------------------
; Jump to address
; --------------------------------------------------------------
; PARAMETERS:
;	addr	- Address
; --------------------------------------------------------------

cJump macro addr

	dc.b	$FF
	ZDW	\addr

	endm

; --------------------------------------------------------------
; Set FM instrument name
; --------------------------------------------------------------
; PARAMETERS:
;	name	- FM instrument name
; --------------------------------------------------------------

cfiCur	= 0

cfiName macro name

\name\	EQU	cfiCur
cfiCur	=	cfiCur+1

	endm

; --------------------------------------------------------------
; Set FM instrument multiple registers
; --------------------------------------------------------------
; PARAMETERS:
;	op1	- Operator 1 value
;	op2	- Operator 2 value
;	op3	- Operator 3 value
;	op4	- Operator 4 value
; --------------------------------------------------------------

cfiMultiple macro op1, op2, op3, op4

cfiMULT1	= op1
cfiMULT2	= op2
cfiMULT3	= op3
cfiMULT4	= op4

	endm

; --------------------------------------------------------------
; Set FM instrument detune registers
; --------------------------------------------------------------
; PARAMETERS:
;	op1	- Operator 1 value
;	op2	- Operator 2 value
;	op3	- Operator 3 value
;	op4	- Operator 4 value
; --------------------------------------------------------------

cfiDetune macro op1, op2, op3, op4

cfiDT1		= op1
cfiDT2		= op2
cfiDT3		= op3
cfiDT4		= op4

	endm

; --------------------------------------------------------------
; Set FM instrument total level registers
; --------------------------------------------------------------
; PARAMETERS:
;	op1	- Operator 1 value
;	op2	- Operator 2 value
;	op3	- Operator 3 value
;	op4	- Operator 4 value
; --------------------------------------------------------------

cfiTotalLv macro op1, op2, op3, op4

cfiTL1		= op1
cfiTL2		= op2
cfiTL3		= op3
cfiTL4		= op4

	endm

; --------------------------------------------------------------
; Set FM instrument attack rate registers
; --------------------------------------------------------------
; PARAMETERS:
;	op1	- Operator 1 value
;	op2	- Operator 2 value
;	op3	- Operator 3 value
;	op4	- Operator 4 value
; --------------------------------------------------------------

cfiAttack macro op1, op2, op3, op4

cfiAR1		= op1
cfiAR2		= op2
cfiAR3		= op3
cfiAR4		= op4

	endm

; --------------------------------------------------------------
; Set FM instrument rate scale registers
; --------------------------------------------------------------
; PARAMETERS:
;	op1	- Operator 1 value
;	op2	- Operator 2 value
;	op3	- Operator 3 value
;	op4	- Operator 4 value
; --------------------------------------------------------------

cfiRateScale macro op1, op2, op3, op4

cfiRS1		= op1
cfiRS2		= op2
cfiRS3		= op3
cfiRS4		= op4

	endm

; --------------------------------------------------------------
; Set FM instrument decay rate registers
; --------------------------------------------------------------
; PARAMETERS:
;	op1	- Operator 1 value
;	op2	- Operator 2 value
;	op3	- Operator 3 value
;	op4	- Operator 4 value
; --------------------------------------------------------------

cfiDecayRate macro op1, op2, op3, op4

cfiDR1		= op1
cfiDR2		= op2
cfiDR3		= op3
cfiDR4		= op4

	endm

; --------------------------------------------------------------
; Set FM instrument amplitude modulation enable registers
; --------------------------------------------------------------
; PARAMETERS:
;	op1	- Operator 1 value
;	op2	- Operator 2 value
;	op3	- Operator 3 value
;	op4	- Operator 4 value
; --------------------------------------------------------------

cfiAmpMod macro op1, op2, op3, op4

cfiAM1		= op1
cfiAM2		= op2
cfiAM3		= op3
cfiAM4		= op4

	endm

; --------------------------------------------------------------
; Set FM instrument sustain rate registers
; --------------------------------------------------------------
; PARAMETERS:
;	op1	- Operator 1 value
;	op2	- Operator 2 value
;	op3	- Operator 3 value
;	op4	- Operator 4 value
; --------------------------------------------------------------

cfiSustainRt macro op1, op2, op3, op4

cfiSR1		= op1
cfiSR2		= op2
cfiSR3		= op3
cfiSR4		= op4

	endm

; --------------------------------------------------------------
; Set FM instrument release rate registers
; --------------------------------------------------------------
; PARAMETERS:
;	op1	- Operator 1 value
;	op2	- Operator 2 value
;	op3	- Operator 3 value
;	op4	- Operator 4 value
; --------------------------------------------------------------

cfiReleaseRt macro op1, op2, op3, op4

cfiRR1		= op1
cfiRR2		= op2
cfiRR3		= op3
cfiRR4		= op4

	endm

; --------------------------------------------------------------
; Set FM instrument sustain level registers
; --------------------------------------------------------------
; PARAMETERS:
;	op1	- Operator 1 value
;	op2	- Operator 2 value
;	op3	- Operator 3 value
;	op4	- Operator 4 value
; --------------------------------------------------------------

cfiSustainLv macro op1, op2, op3, op4

cfiSL1		= op1
cfiSL2		= op2
cfiSL3		= op3
cfiSL4		= op4

	endm

; --------------------------------------------------------------
; Set FM instrument SSG-EG registers
; --------------------------------------------------------------
; PARAMETERS:
;	op1	- Operator 1 value
;	op2	- Operator 2 value
;	op3	- Operator 3 value
;	op4	- Operator 4 value
; --------------------------------------------------------------

cfiSSGEG macro op1, op2, op3, op4

cfiSSG1		= op1
cfiSSG2		= op2
cfiSSG3		= op3
cfiSSG4		= op4

	endm

; --------------------------------------------------------------
; Set FM instrument algorithm register
; --------------------------------------------------------------
; PARAMETERS:
;	alg	- Algorithm value
; --------------------------------------------------------------

cfiAlgorithm macro alg

cfiALG		= alg

	endm

; --------------------------------------------------------------
; Set FM instrument feedback register and store instrument data
; --------------------------------------------------------------
; PARAMETERS:
;	fb	- Feedback value
; --------------------------------------------------------------

cfiFeedback macro fb

cfiFB		= fb

	dc.b	(cfiDT1<<4)|cfiMULT1, (cfiDT2<<4)|cfiMULT2, (cfiDT3<<4)|cfiMULT3, (cfiDT4<<4)|cfiMULT4
	dc.b	cfiTL1, cfiTL2, cfiTL3, cfiTL4
	dc.b	(cfiRS1<<6)|cfiAR1, (cfiRS2<<6)|cfiAR2, (cfiRS3<<6)|cfiAR3, (cfiRS4<<6)|cfiAR4
	dc.b	(cfiAM1<<7)|cfiDR1, (cfiAM2<<7)|cfiDR2, (cfiAM3<<7)|cfiDR3, (cfiAM4<<7)|cfiDR4
	dc.b	cfiSR1, cfiSR2, cfiSR3, cfiSR4
	dc.b	(cfiSL1<<4)|cfiRR1, (cfiSL2<<4)|cfiRR2, (cfiSL3<<4)|cfiRR3, (cfiSL4<<4)|cfiRR4
	dc.b	cfiSSG1, cfiSSG2, cfiSSG3, cfiSSG4
	dc.b	(cfiFB<<3)|cfiALG
	
	endm

; --------------------------------------------------------------