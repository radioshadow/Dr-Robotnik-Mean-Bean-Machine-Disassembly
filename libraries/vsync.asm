; --------------------------------------------------------------
;
;	Dr. Robotnik's Mean Bean Machine Disassembly
;	Original game by Compile
;
;	Disassembled by Devon Artmeier
;
; --------------------------------------------------------------

; --------------------------------------------------------------
; VSync
; --------------------------------------------------------------

VSync:
	lea	frame_count,a0				; Get current frame count
	move.w	(a0),d0

.Wait:
	cmp.w	(a0),d0					; Has the frame count updated?
	beq.s	.Wait					; If not, wait
	rts

; --------------------------------------------------------------