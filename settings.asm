; --------------------------------------------------------------
; ROM settings
; --------------------------------------------------------------
				
EnableSRAM:			equ 0	; Change to 1 to enable SRAM
BackupSRAM:			equ 1
AddressSRAM:		equ 3	; 0 = odd+even
							; 2 = even only
							; 3 = odd only
							
ConsoleHeader:		equ 1	; 0 = Header says "SEGA MEGA DRIVE"
							; 1 = Header says "SEGA GENESIS"

PuyoCompression:	equ 0   ; 0 = Puyo Art uses Compile Compression
							; 1 = Puyo Art uses Nemesis Compression
							
FastNemesis:		equ 0   ; 0 = Use the orginal Nemesis Decompression routine
							; 1 = Use a faster Nemesis Decompression routine
							
RegionLock:			equ 0   ; 0 = Only work on USA Console
							; 1 = Work on any Console
							
RegionCheckCode:	Equ 0 	; 0 = Use original Region Check code	
							; 1 = Use improved Region Check code
							
RegionSetCheck:		Equ 1 	; Will only work if "Improved Region Check" code is used
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
							; 1 =   Use Konami Code = ↑ ↑ ↓ ↓ ← → ← → B A S
							; 2 =   Use Custom Code = data/misc/Lockout Bypass Code.asm
						
LoadChecksum:		Equ 0   ; 0 = Check the Checksum
							; 1 = Skip the Checksum
							
ChecksumScreen:		Equ 0   ; 0 = The Checksum Screen can be skipped
							; 1 = The Checksum Screen will always be displayed
														
OpponentNames:		equ 0   ; 0 = Scenario always displays "DR R" for 2P
							; 1 = Scenario uses 4 letter names for each opponent (like in Puyo Puyo)
							
BattleBoards:		equ 0   ; 0 = Only the Grass Board is used
							; 1 = Each mode/opponent can use a different Board
							
DemoOpponenet:		equ 0   ; 0 = Opponent is always Frankly.
							; 1 = You choose the opponent (see "DemoOpponenet" subroutine)
							; 2 = Opponent is picked at random

DemoText:			equ 0   ; 0 = During Demo, text says "1P"
							; 1 = During Demo, text says "DEMO"

SplashScreen:		equ 0   ; 0 = Skip Sonic Hacking Contest Splash Screen
							; 1 = Use Sonic Hacking Contest Splash Screen