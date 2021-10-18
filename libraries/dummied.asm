; --------------------------------------------------------------
;
;	Dr. Robotnik's Mean Bean Machine Disassembly
;	Original game by Compile
;
;	Disassembled by Devon Artmeier
;
; --------------------------------------------------------------

; --------------------------------------------------------------
; This function appears to have been dummied out, as some
; parts of the game call this and check if the carry flag was
; set after calling this, even in Puyo Puyo.
; --------------------------------------------------------------

DummiedFunc:
	CLEAR_CARRY
	rts

; --------------------------------------------------------------