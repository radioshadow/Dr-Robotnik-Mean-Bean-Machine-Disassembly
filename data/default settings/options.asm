; --------------------------------------------------------------
; Default Options
; --------------------------------------------------------------	
					
	move.b	#2, com_level			; VS. COM Level (Scenario Mode)
	
	move.b	#1, game_matches		; # Game Matches (1P VS 2P Mode) 
	
	move.b	#0, disable_samples		; Use Voice Samples
	
	move.b	#2, player_1_a			; Action for Button A (P1)
	move.b	#1, player_1_b			; Action for Button B (P1)
	move.b	#2, player_1_c			; Action for Button C (P1)
	
	move.b	#2, player_2_a			; Action for Button A (P2)
	move.b	#1, player_2_b			; Action for Button B (P2)
	move.b	#2, player_2_c			; Action for Button C (P2)
	
	rts