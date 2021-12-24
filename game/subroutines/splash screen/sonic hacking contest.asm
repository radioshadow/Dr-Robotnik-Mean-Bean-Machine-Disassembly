; =============== S U B	R O U T	I N E =======================================
; Sonic Hacking Contest - Splash Screen
; ---------------------------------------------------------------------------
					
	incbin "data/splash screen/SHC21_Full_Advanced.bin"

	dc.b    $04    ; $80
	dc.b    $64    ; $81
	dc.b    $30    ; $82
	dc.b    $3C    ; $83
	dc.b    $07    ; $84
	dc.b    $5E    ; $85
	dc.b    $00    ; $86
	dc.b    $00    ; $87
	dc.b    $00    ; $88
	dc.b    $00    ; $89
	dc.b    $00    ; $8A
	dc.b    $03    ; $8B
	dc.b    $81    ; $8C
	dc.b    $2E    ; $8D
	dc.b    $00    ; $8E
	dc.b    $02    ; $8F
	dc.b    $03    ; $90
	dc.b    $00    ; $91
	dc.b    $00    ; $92
	even		