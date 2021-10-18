; -----------------------------------------------------------------------------------------
; Checksum
; -----------------------------------------------------------------------------------------
					
					BRUN	InitPaletteSafe				; Initialize palette
					BRUN	InitDebugFlags				; Initialize debug flags
					
					if LoadChecksum=1					; If LoadChecksum is off, skip the code		
					BJMP	BC_Sega						; Run Sega Logo
					
					else							    ; If LoadChecksum is on, then use code below
					BRUN	CheckChecksum				; Check checksum
					endc
					
					BJCLR	BC_Sega						; If it's correct, branch

					BVDP	1							; Set up VDP registers
					
					if PuyoCompression=0
					BPUYO	$0000, ArtPuyo_LessonMode
					BPUYO	$A000, ArtPuyo_OldFont
					else
					BNEM	$0000, ArtPuyo_LessonMode
					BNEM	$A000, ArtPuyo_OldFont
					endc

					BRUN	ChecksumError				; Setup checksum error
					BFRMEND

					BPAL	Pal_White, 0				; Load palette
					BPAL	Pal_OptTextRed, 1
					BPAL	Pal_Options, 2

					if ChecksumScreen=1					; If ChecksumScreen is on, use code below	
ChecksumFail:		
					BJMP	ChecksumFail				; Run ChecksumFail forever!
					endc								; User will be stuck on the checksum screen
					
					BDISABLE							; Stop here until the checksum error is over

					BPAL	Pal_Black, 0				; Clear palette
					BPAL	Pal_Black, 1
					BPAL	Pal_Black, 2
					BFRMEND