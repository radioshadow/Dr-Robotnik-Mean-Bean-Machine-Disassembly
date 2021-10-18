; --------------------------------------------------------------
;
;	Dr. Robotnik's Mean Bean Machine Disassembly
;	Original game by Compile
;
;	Disassembled by Devon Artmeier
;
; --------------------------------------------------------------

; --------------------------------------------------------------
; Mega Drive initialization
; --------------------------------------------------------------

InitMegaDrive:
	tst.l	PORT_A_CTRL-1				; Is this a hot start?
	bne.s	.IsHotStart				; If so, branch
	tst.w	PORT_C_CTRL-1

.IsHotStart:
	bne.s	.HotStart				; If so, branch

	lea	.InitTable(pc),a5			; Setup registers
	movem.w	(a5)+,d5-d7
	movem.l	(a5)+,a0-a4

	move.b	CONSOLE_VER-Z80_BUS(a1),d0		; Does this console have TMSS?
	andi.b	#$F,d0
	beq.s	.NoTMSS					; If not, branch
	move.l	#"SEGA",TMSS_SEGA-Z80_BUS(a1)		; If so, satisfy it

.NoTMSS:
	move.w	(a4),d0					; Clear write-pending flag in VDP

	moveq	#0,d0					; Setup for RAM clearing
	movea.l	d0,a6

	move.l	a6,usp					; Clear user stack pointer

	moveq	#.VDPRegs_End-.VDPRegs-1,d1		; Get number of VDP registers to initialize

.InitVDPRegs:
	move.b	(a5)+,d5				; Write register data
	move.w	d5,(a4)
	add.w	d7,d5					; Next register
	dbf	d1,.InitVDPRegs				; Loop until all registers are initialized

	move.l	(a5)+,(a4)				; Clear VRAM via DMA fill
	move.w	d0,(a3)

	move.w	d7,(a1)					; Stop the Z80
	move.w	d7,(a2)

.WaitZ80Stop
	btst	d0,(a1)
	bne.s	.WaitZ80Stop

	moveq	#.Z80Init_End-.Z80Init-1,d2		; Load the Z80 initialization program

.LoadZ80Init:
	move.b	(a5)+,(a0)+
	dbf	d2,.LoadZ80Init

	move.w	d0,(a2)					; Restart the Z80
	move.w	d0,(a1)
	move.w	d7,(a2)

.ClearRAM:
	move.l	d0,-(a6)				; Clear RAM
	dbf	d6,.ClearRAM

	move.l	(a5)+,(a4)				; Disable DMA and set autoincrement to 2

	move.l	(a5)+,(a4)				; Clear CRAM
	moveq	#$80/4-1,d3

.ClearCRAM:
	move.l	d0,(a3)
	dbf	d3,.ClearCRAM

	move.l	(a5)+,(a4)				; Clear VSRAM
	moveq	#$50/4-1,d4

.VSRAM:
	move.l	d0,(a3)
	dbf	d4,.VSRAM

	moveq	#.PSGData_End-.PSGData-1,d5		; Silence PSG

.SilencePSG:
	move.b	(a5)+,PSG_CTRL-VDP_DATA(a3)
	dbf	d5,.SilencePSG

	move.w	d0,(a2)					; Set Z80 reset

	movem.l	(a6),d0-a6				; Reset registers
	move	#$2700,sr

.HotStart:
	bra.s	.GameProgram				; Go to game program

; --------------------------------------------------------------
; Initialziation table
; --------------------------------------------------------------

.InitTable:
	dc.w	$8000					; VDP register base
	dc.w	(RAM_END-RAM_START+1)/4-1		; Size of RAM in longwords (minus 1)
	dc.w	$100					; VDP register increment and Z80 port flag set

	dc.l	ZRAM_START				; Z80 RAM start
	dc.l	Z80_BUS					; Z80 bus request
	dc.l	Z80_RESET				; Z80 reset
	dc.l	VDP_DATA				; VDP data port
	dc.l	VDP_CTRL				; VDP control port

.VDPRegs:
	dc.b	%00000100				; Disable H/V latch, disable H-BLANK
	dc.b	%00010100				; Enable DMA, disable V-BLANK
	dc.b	$C000/$400				; Plane A location at $C000
	dc.b	$F000/$400				; Window location at $F000
	dc.b	$E000/$2000				; Plane B location at $E000
	dc.b	$D800/$200				; Sprite table location at $D800
	dc.b	%00000000				; Disable sprite pattern generator rebasing
	dc.b	$00					; Background color at line 0, color 0
	dc.b	%00000000				; Unused
	dc.b	%00000000				; Unused
	dc.b	$FF					; H-BLANK counter at 255
	dc.b	%00000000				; Scroll by screen
	dc.b	%10000001				; H40 resolution mode
	dc.b	$DC00/$400				; HScroll table location at $DC00
	dc.b	%00000000				; Disable nametable generator rebasing
	dc.b	$01					; Autoincrement at 1
	dc.b	%00000001				; Plane size at 64x32
	dc.b	$00					; Window plane horizontal position
	dc.b	$00					; Window plane vertical position
	dc.b	$FF					; DMA length at $10000 (low byte)
	dc.b	$FF					; DMA length at $10000 (high byte)
	dc.b	$00					; DMA source at $0000 (low byte)
	dc.b	$00					; DMA source at $0000 (mid byte)
	dc.b	$80					; DMA source at $0000 (high byte), DMA fill
.VDPRegs_End:

	dc.l	$40000080				; VRAM DMA at $0000

.Z80Init:
	dc.b	$AF					; xor	a
	dc.b	$01, $D9, $1F				; ld	bc,1FD9h
	dc.b	$11, $27, $00				; ld	de,27h
	dc.b	$21, $26, $00				; ld	hl,26h
	dc.b	$F9					; ld	sp,hl
	dc.b	$77					; ld	(hl),a
	dc.b	$ED, $B0				; ldir
	dc.b	$DD, $E1				; pop	ix
	dc.b	$FD, $E1				; pop	iy
	dc.b	$ED, $47				; ld	i,a
	dc.b	$ED, $4F				; ld	r,a
	dc.b	$D1					; pop	de
	dc.b	$E1					; pop	hl
	dc.b	$F1					; pop	af
	dc.b	$08					; ex	af,af'
	dc.b	$D9					; exx
	dc.b	$C1					; pop	bc
	dc.b	$D1					; pop	de
	dc.b	$E1					; pop	hl
	dc.b	$F1					; pop	af
	dc.b	$F9					; ld	sp,hl
	dc.b	$F3					; di
	dc.b	$ED, $56				; im	1
	dc.b	$36, $E9				; ld	(hl),E9h
	dc.b	$E9					; jp	(hl)
.Z80Init_End:

	dc.w	$8104					; Disable DMA
	dc.w	$8F02					; Autoincrement at 2

	dc.l	$C0000000				; CRAM WRITE at $0000
	dc.l	$40000010				; VSRAM WRITE at $0000

.PSGData:
	dc.b	$9F					; PSG1 silence
	dc.b	$BF					; PSG2 silence
	dc.b	$DF					; PSG3 silence
	dc.b	$FF					; Noise silence
.PSGData_End:

; --------------------------------------------------------------
; Game program
; --------------------------------------------------------------

.GameProgram:
	tst.w	VDP_CTRL				; Test the VDP

; --------------------------------------------------------------