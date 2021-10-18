; =============== S U B	R O U T	I N E =====================================================
; Get region
; -----------------------------------------------------------------------------------------
					
					move.b	CONSOLE_VER,d0		; Get the region of the console
												; 76543210
												; RME VVVV
												; R = Region : 0 = JPN  | 1 = ENG
												; M = TV Mode: 0 = NTSC | 0 = PAL
												; VVV = Version
					
					andi.b	#$C0,d0				; Removes bits 5-0 from the console byte,
												; leaving us with the the Region and TV Mode

; -----------------------------------------------------------------------------------------
					
					if RegionCheckCode=0		; Use original code
												
					subi.b	#$80,d0				; Takes away hex 80 from console byte
												; 80 = 10000000 = ENG and NTSC
					nop
					nop
					nop
					nop
					move.b	d0,bytecode_flag	; Moves this byte into bytecode_flag
												; If 0, then the flag will be clear (the correct region)
												; If not 0, then the flag will be clear (the wrong region) 
												
					rts							; Return to Start
					
; -----------------------------------------------------------------------------------------
					
					else						; Use improved code
					
					if RegionSetCheck=0
					cmpi.b	#$00,d0				; Compare the Japan Region with Actual Region
												; 00 = 00000000 = JPN and NTSC (Japan Console)
					endc
					
					if RegionSetCheck=1
					cmpi.b	#$80,d0				; Compare the USA Region with Actual Region
												; 80 = 10000000 = ENG and NTSC (USA Console)
					endc
					
					if RegionSetCheck=2
					cmpi.b	#$C0,d0				; Compare the Europe Region with Actual Region
												; C0 = 11000000 = ENG and PAL (Europe Console)
					endc
					
					if RegionSetCheck=3
					cmpi.b	#$40,d0				; Compare the Asia Region with Actual Region
												; 40 = 01000000 = JPN and PAL (Asia Console)
					endc
											
							
					bne		WrongRegion			; If region is wrong, then jump to WrongRegion
					
					nop
					nop
					nop
					nop
					move.b	#$0,bytecode_flag	; Set to 0 so the flag will be clear (the correct region)
												
					rts							; Return to Start

WrongRegion:					
					nop
					nop
					nop
					nop
					move.b	#$1,bytecode_flag	; Set to 1 so the flag will not be clear (the wrong region)
												
					rts							; Return to Start
					endc