; -----------------------------------------------------------------------------------------
; ROM settings (change how the ROM should be compiled)
; -----------------------------------------------------------------------------------------
				
EnableSRAM:			equ 0	; Change to 1 to enable SRAM
BackupSRAM:			equ 1
AddressSRAM:		equ 3	; 0 = odd+even
							; 2 = even only
							; 3 = odd only
							
PuyoCompression:	equ 0   ; 0 = Puyo Art uses Compile Compression
							; 1 = Puyo Art uses Nemesis Compression
							
RegionLock:			equ 0   ; 0 = Only work on USA Console
							; 1 = Work on any Console
							
RegionCheckCode:	Equ 0 	; 0 = Use original Region Check code	
							; 1 = Use improved Region Check code
							
RegionSetCheck:		Equ 1 	; Will only work if Improved Region Check code is used
							; 0 = Console must be Japan	(JPN | NTSC)
							; 1 = Console must be USA (ENG | NTSC)
							; 2 = Console must be Europe (ENG | PAL)
							; 3 = Console must be Asia (JPN | PAL)
							
RegionByPassUse:	Equ 0	; 0 = Enter a code to bypass Region Screen
							; 1 = Can't bypass Region Screen
							
RegionByPassPad:	Equ 1	; 0 = Use Controller 1 to enter code to bypass Region Screen
							; 1 = Use Controller 2 to enter code to bypass Region Screen
							
RegionByPassTry:	Equ 0	; 0 = Only 1 attempt to enter code
							; 1 = Enter code as many times as you like
							
RegionByPassCode:	Equ 0	; 0 = Use Original Code = A A ↑ → ↓ ← B B → ↓ ← ↑ C C ↓ ← ↑ → S S
							; 1 = Use Konami Code = ↑ ↑ ↓ ↓ ← → ← → B A S
							; 2 = Use Custom Code
						
LoadChecksum:		Equ 0   ; 0 = Check the Checksum
							; 1 = Skip the Checksum
							
ChecksumScreen:		Equ 0   ; 0 = The Checksum Screen can be skipped
							; 1 = The Checksum Screen will always be displayed