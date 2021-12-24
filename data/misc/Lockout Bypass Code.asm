; ---------------------------------------------------------------------------
; Lockout Bypass Code
; ---------------------------------------------------------------------------

	if RegionByPassCode=0 ; Original Code

	; A A ↑ → ↓ ← B B → ↓ ← ↑ C C ↓ ← ↑ → S S
										
	dc.b	BUTTON_A ; A
	dc.b	BUTTON_A ; A
	dc.b	BUTTON_U ; ↑
	dc.b	BUTTON_R ; →
	dc.b	BUTTON_D ; ↓
	dc.b	BUTTON_L ; ←
	dc.b	BUTTON_B ; B
	dc.b	BUTTON_B ; B
	dc.b	BUTTON_R ; →
	dc.b	BUTTON_D ; ↓
	dc.b	BUTTON_L ; ←
	dc.b	BUTTON_U ; ↑
	dc.b	BUTTON_C ; C
	dc.b	BUTTON_C ; C
	dc.b	BUTTON_D ; ↓
	dc.b	BUTTON_L ; ←
	dc.b	BUTTON_U ; ↑
	dc.b	BUTTON_R ; →
	dc.b	BUTTON_S ; START
	dc.b	BUTTON_S ; START
					
	dc.b	END_OF_CODE
	dc.b	$00
	even
	endc

; ---------------------------------------------------------------------------
					
	if RegionByPassCode=1 ; Konami Code

	; ↑ ↑ ↓ ↓ ← → ← → B A S
										
	dc.b	BUTTON_U ; ↑
	dc.b	BUTTON_U ; ↑
	dc.b	BUTTON_D ; ↓
	dc.b	BUTTON_D ; ↓
	dc.b	BUTTON_L ; ←
	dc.b	BUTTON_R ; →
	dc.b	BUTTON_L ; ←
	dc.b	BUTTON_R ; →
	dc.b	BUTTON_B ; B
	dc.b	BUTTON_A ; A
	dc.b	BUTTON_S ; START
					
	dc.b	END_OF_CODE
	dc.b	$00
	even
	endc

; ---------------------------------------------------------------------------

	if RegionByPassCode=2 ; Custom Code

	; S
									
	dc.b	BUTTON_S ; START
					
	dc.b	END_OF_CODE
	dc.b	$00
	even
	endc