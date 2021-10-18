Console:		DC.b "SEGA GENESIS    " 	; Hardware system ID (Console name)
Date:			dc.b "(C)SEGA 1993.SEP" 	; Copyright holder and release date (generally year)

Title_Local:	DC.b "Dr. Robotnik's Mean Bean Machine                " ; Domestic name
Title_Int:		DC.b "Dr. Robotnik's Mean Bean Machine                " ; International name

Serial: 		DC.b "GM MK-1706 -00"  		; Serial/version number

Checksum:		DC.w $0			            ; Checksum
Support:		DC.b "J               "		; I/O support

RomStartLoc:	DC.l StartOfRom				; Start address of ROM
RomEndLoc:		DC.l EndOfRom-1				; End address of ROM

RamStartLoc:	DC.l $00FF0000				; Start address of RAM
RamEndLoc		DC.l $00FFFFFF				; End address of RAM

SRAMSupport:	if EnableSRAM=1
				DC.b $52, $41, $A0+(BackupSRAM<<6)+(AddressSRAM<<3), $20
				DC.l $00200000				; SRAM start ($200001)
				DC.l $00202000				; SRAM end	 ($20xxxx)
				
				else
				DC.l $20202020
				DC.l $20202020
				DC.l $20202020
				endc
								  
ModemSupport:	DC.b "            "			; Modem support

Notes:			DC.b "                                        " ; Notes (unused, anything can be put in this space, but it has to be 40 bytes.)
				
Region:			DC.b "U               " 	; Region (Country code)