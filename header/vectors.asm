; --------------------------------------------------------------
;
;	Dr. Robotnik's Mean Bean Machine Disassembly
;	Original game by Compile
;
;	Disassembled by Devon Artmeier
;
; --------------------------------------------------------------

; --------------------------------------------------------------
; Vector table
; --------------------------------------------------------------

	dc.l	stack_base
	dc.l	Entry

	dc.l	Exception
	dc.l	Exception
	dc.l	Exception
	dc.l	Exception
	dc.l	Exception
	dc.l	Exception
	dc.l	Exception
	dc.l	Exception
	dc.l	Exception
	dc.l	Exception

	dcb.l	$C, Exception

	dc.l	Exception
	dc.l	Exception
	dc.l	Exception
	dc.l	Exception
	dc.l	HBlank
	dc.l	Exception
	dc.l	VBlank
	dc.l	Exception

	dc.l	Exception
	dc.l	Exception
	dc.l	Exception
	dc.l	Exception
	dc.l	Exception
	dc.l	Exception
	dc.l	Exception
	dc.l	Exception
	dc.l	Exception
	dc.l	Exception
	dc.l	Exception
	dc.l	Exception
	dc.l	Exception
	dc.l	Exception
	dc.l	Exception
	dc.l	Exception

	dcb.l	$10, Exception

; --------------------------------------------------------------