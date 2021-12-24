; --------------------------------------------------------------
; Mega Drive constants
; --------------------------------------------------------------

; ROM
ROM_START		EQU	$000000
ROM_END			EQU	$3FFFFF

; RAM
RAM_START		EQU	$FF0000
RAM_END			EQU	$FFFFFF

; Z80
ZRAM_START		EQU	$A00000
ZRAM_END		EQU	$A01FFF
Z80_BUS			EQU	$A11100
Z80_RESET		EQU	$A11200

; VDP
VDP_DATA		EQU	$C00000
VDP_CTRL		EQU	$C00004
VDP_HV			EQU	$C00008
VDP_DEBUG		EQU	$C0001C

; Sound
YM2612_A0		EQU	$A04000
YM2612_D0		EQU	$A04001
YM2612_A1		EQU	$A04002
YM2612_D1		EQU	$A04003
PSG_CTRL		EQU	$C00011

; I/O
CONSOLE_VER		EQU	$A10001
PORT_A_DATA		EQU	$A10003
PORT_B_DATA		EQU	$A10005
PORT_C_DATA		EQU	$A10007
PORT_A_CTRL		EQU	$A10009
PORT_B_CTRL		EQU	$A1000B
PORT_C_CTRL		EQU	$A1000D
SRAM_ACCESS		EQU	$A130F1
TMSS_SEGA		EQU	$A14000

; --------------------------------------------------------------
; Align macro
; --------------------------------------------------------------
; PARAMETERS:
; 	bound	- Size boundary
;	value	- Value to pad with
; --------------------------------------------------------------

ALIGN macro bound, value

	if narg=1
		dcb.b	((\bound)-(*%(\bound)))%(\bound), 0
	else
		dcb.b	((\bound)-(*%(\bound)))%(\bound), \value
	endif

	endm

; --------------------------------------------------------------