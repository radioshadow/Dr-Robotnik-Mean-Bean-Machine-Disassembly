; --------------------------------------------------------------
;
;	Dr. Robotnik's Mean Bean Machine Disassembly
;	Original game by Compile
;
;	Disassembled by Devon Artmeier
;
; --------------------------------------------------------------

; --------------------------------------------------------------
; Generate a random number
; --------------------------------------------------------------
; RETURNS:
;	d0.l	- Random number
; --------------------------------------------------------------

Random:
	movem.l	d1,-(sp)				; Save registers

	move.l	rng_seed,d1				; Get RNG seed
	bne.s	.GotSeed				; If it was initialized already, branch
	move.l	#$2A6D365A,d1				; If it wasn't, initialize it

.GotSeed:
	move.l	d1,d0					; Generate a random number
	asl.l	#2,d1
	add.l	d0,d1
	asl.l	#3,d1
	add.l	d0,d1
	move.w	d1,d0
	swap	d1
	add.w	d1,d0
	move.w	d0,d1
	swap	d1

	move.l	d1,rng_seed				; Update RNG seed

	movem.l	(sp)+,d1				; Restore registers
	rts

; --------------------------------------------------------------
; Generate a random number within a boundary
; --------------------------------------------------------------
; PARAMETERS:
;	d0.w	- Boundary (exclusive)
; RETURNS:
;	d0.l	- Random number
; --------------------------------------------------------------

RandomBound:
	movem.l	d1,-(sp)				; Save registers

	move.l	d0,d1					; Save boundary
	bsr.s	Random					; Generate a random number
	mulu.w	d1,d0					; Apply the boundary
	swap	d0

	movem.l	(sp)+,d1				; Restore registers
	rts

; --------------------------------------------------------------
; Get the cosine of a value
; --------------------------------------------------------------
; PARAMETERS:
;	d0.w	- Value
;	d1.w	- Multiplier
; RETURNS:
;	d0.l	- The cosine of the input value
; --------------------------------------------------------------

Cos:
	addi.b	#$40,d0					; Shift angle for cosine

; --------------------------------------------------------------
; Get the sine of a value
; --------------------------------------------------------------
; PARAMETERS:
;	d0.w	- Value
;	d1.w	- Multiplier
; RETURNS:
;	d0.l	- The sine of the input value
; --------------------------------------------------------------

Sin:
	movem.w	d0,-(sp)				; Save registers

	andi.w	#$7F,d0					; Get sine of angle
	lsl.w	#1,d0
	move.w	SineTable(pc,d0.w),d2
	mulu.w	d1,d2					; Apply multiplier

	movem.w	(sp)+,d0				; Restore registers

	or.b	d0,d0					; Should the sine value be negated?
	bpl.w	.End					; If not, branch
	neg.l	d2					; If so, negate it

.End:
	rts
	
; --------------------------------------------------------------
; Sine table
; --------------------------------------------------------------

SineTable:
	dc.w	$0000, $0006, $000D, $0013, $0019, $001F, $0026, $002C
	dc.w	$0032, $0038, $003E, $0044, $004A, $0050, $0056, $005C
	dc.w	$0062, $0068, $006D, $0073, $0079, $007E, $0084, $0089
	dc.w	$008E, $0093, $0098, $009D, $00A2, $00A7, $00AC, $00B1
	dc.w	$00B5, $00B9, $00BE, $00C2, $00C6, $00CA, $00CE, $00D1
	dc.w	$00D5, $00D8, $00DC, $00DF, $00E2, $00E5, $00E7, $00EA
	dc.w	$00ED, $00EF, $00F1, $00F3, $00F5, $00F7, $00F8, $00FA
	dc.w	$00FB, $00FC, $00FD, $00FE, $00FF, $00FF, $0100, $0100
	dc.w	$0100, $0100, $0100, $00FF, $00FF, $00FE, $00FD, $00FC
	dc.w	$00FB, $00FA, $00F8, $00F7, $00F5, $00F3, $00F1, $00EF
	dc.w	$00ED, $00EA, $00E7, $00E5, $00E2, $00DF, $00DC, $00D8
	dc.w	$00D5, $00D1, $00CE, $00CA, $00C6, $00C2, $00BE, $00B9
	dc.w	$00B5, $00B1, $00AC, $00A7, $00A2, $009D, $0098, $0093
	dc.w	$008E, $0089, $0084, $007E, $0079, $0073, $006D, $0068
	dc.w	$0062, $005C, $0056, $0050, $004A, $0044, $003E, $0038
	dc.w	$0032, $002C, $0026, $001F, $0019, $0013, $000D, $0006

; --------------------------------------------------------------