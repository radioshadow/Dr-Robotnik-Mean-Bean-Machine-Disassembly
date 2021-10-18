; --------------------------------------------------------------
;
;	Dr. Robotnik's Mean Bean Machine Disassembly
;	Original game by Compile
;
;	Disassembled by Devon Artmeier
;
; --------------------------------------------------------------

; --------------------------------------------------------------
; Enable shadow/highlight mode
; --------------------------------------------------------------

EnableSHMode:
	move.w	#$8C00,d0				; Enable S/H mode
	move.b	vdp_reg_c,d0
	ori.b	#8,d0
	move.b	d0,vdp_reg_c
	rts

; --------------------------------------------------------------
; Disable shadow/highlight mode
; --------------------------------------------------------------

DisableSHMode:
	move.w	#$8C00,d0				; Disable S/H mode
	move.b	vdp_reg_c,d0
	andi.b	#~8,d0
	move.b	d0,vdp_reg_c
	rts

; --------------------------------------------------------------