; --------------------------------------------------------------
;
;	Dr. Robotnik's Mean Bean Machine Disassembly
;	Original game by Compile
;
;	Disassembled by Devon Artmeier
;
; --------------------------------------------------------------

; --------------------------------------------------------------
; Exception
; --------------------------------------------------------------

Exception:
	DISABLE_INTS					; Disable interrupts

	bsr.w	InvertPalette				; Invert the palette
	bsr.w	TransferPalette

.Loop:
	nop						; Loop here forever
	nop
	bra.s	.Loop

; --------------------------------------------------------------