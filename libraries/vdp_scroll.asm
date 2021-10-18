; --------------------------------------------------------------
;
;	Dr. Robotnik's Mean Bean Machine Disassembly
;	Original game by Compile
;
;	Disassembled by Devon Artmeier
;
; --------------------------------------------------------------

; --------------------------------------------------------------
; Clear scroll buffers
; --------------------------------------------------------------

ClearScroll:
	move.w	#$400/2-1,d0				; Clear the HScroll buffer
	lea	hscroll_buffer,a1

.ClearHScroll:
	clr.w	(a1)+
	dbf	d0,.ClearHScroll

	move.w	#$50-1,d0				; Clear the VScroll buffer
	lea	vscroll_buffer,a1			; (NOTE: Should be "$50/2-1", not "$50-1")

.ClearVScroll:
	clr.w	(a1)+
	dbf	d0,.ClearVScroll

	rts

; --------------------------------------------------------------