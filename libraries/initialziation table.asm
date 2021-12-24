; --------------------------------------------------------------
; Initialziation table
; --------------------------------------------------------------

.InitTable:
	; d5-d7
	dc.w	$8000
	dc.w	$3FFF
	dc.w	$100

	; a0-a4
	dc.l	ZRAM_START
	dc.l	Z80_BUS
	dc.l	Z80_RESET
	dc.l	VDP_DATA
	dc.l	VDP_CTRL

.VDPRegsInit:
	; VDP register data
	dc.b	$04
	dc.b	$14
	dc.b	$30
	dc.b	$3C
	dc.b	$07
	dc.b	$6C
	dc.b	$00
	dc.b	$00
	dc.b	$00
	dc.b	$00
	dc.b	$FF
	dc.b	$00
	dc.b	$81
	dc.b	$37
	dc.b	$00
	dc.b	$01
	dc.b	$01
	dc.b	$00
	dc.b	$00
	dc.b	$FF
	dc.b	$FF
	dc.b	$00
	dc.b	$00
	dc.b	$80
.VDPRegsInit_End:

	; VRAM DMA at $0000
	dc.l	$40000080

.Z80Init:
	; Z80 initialization program
	dc.b	$AF
	dc.b	$01, $D9, $1F
	dc.b	$11, $27, $00
	dc.b	$21, $26, $00
	dc.b	$F9
	dc.b	$77
	dc.b	$ED, $B0
	dc.b	$DD, $E1
	dc.b	$FD, $E1
	dc.b	$ED, $47
	dc.b	$ED, $4F
	dc.b	$D1
	dc.b	$E1
	dc.b	$F1
	dc.b	$08
	dc.b	$D9
	dc.b	$C1
	dc.b	$D1
	dc.b	$E1
	dc.b	$F1
	dc.b	$F9
	dc.b	$F3
	dc.b	$ED, $56
	dc.b	$36, $E9
	dc.b	$E9
.Z80Init_End:

	; VDP register 1 and 15 reset
	dc.w	$8104
	dc.w	$8F02

	; CRAM and VSRAM write at $0000
	dc.l	$C0000000
	dc.l	$40000010

.PSGSilence:
	; PSG silence data
	dc.b	$9F
	dc.b	$BF
	dc.b	$DF
	dc.b	$FF
.PSGSilence_End: