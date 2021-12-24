; --------------------------------------------------------------
; Program entry
; --------------------------------------------------------------

	; Check if this is a hot start
	tst.l	PORT_A_CTRL-1
	bne.s	.IsHotStart
	tst.w	PORT_C_CTRL-1

.IsHotStart:
	bne.s	.HotStart

	; Set up for initialization
	lea	.InitTable(pc),a5
	movem.w	(a5)+,d5-d7
	movem.l	(a5)+,a0-a4

	; Handle TMSS
	move.b	CONSOLE_VER-Z80_BUS(a1),d0
	andi.b	#$F,d0
	beq.s	.NoTMSS
	move.l	#"SEGA",TMSS_SEGA-Z80_BUS(a1)

.NoTMSS:
	move.w	(a4),d0
	
	; Set up for RAM clear and set user stack pointer
	moveq	#0,d0
	movea.l	d0,a6
	move.l	a6,usp

	; Initialize VDP registers
	moveq	#.VDPRegsInit_End-.VDPRegsInit-1,d1

.InitVDPRegs:
	move.b	(a5)+,d5
	move.w	d5,(a4)
	add.w	d7,d5
	dbf	d1,.InitVDPRegs

	; Clear VRAM
	move.l	(a5)+,(a4)
	move.w	d0,(a3)

	; Initialize the Z80
	move.w	d7,(a1)
	move.w	d7,(a2)

.WaitZ80Stop
	btst	d0,(a1)
	bne.s	.WaitZ80Stop

	moveq	#.Z80Init_End-.Z80Init-1,d2

.LoadZ80Init:
	move.b	(a5)+,(a0)+
	dbf	d2,.LoadZ80Init

	move.w	d0,(a2)
	move.w	d0,(a1)
	move.w	d7,(a2)

.ClearRAM:
	; Clear RAM
	move.l	d0,-(a6)
	dbf	d6,.ClearRAM

	; Reset VDP registers 1 and 15
	move.l	(a5)+,(a4)

	; Clear CRAM
	move.l	(a5)+,(a4)
	moveq	#$80/4-1,d3

.ClearCRAM:
	move.l	d0,(a3)
	dbf	d3,.ClearCRAM

	; Clear VSRAM
	move.l	(a5)+,(a4)
	moveq	#$50/4-1,d4

.VSRAM:
	move.l	d0,(a3)
	dbf	d4,.VSRAM

	; Silence PSG
	moveq	#.PSGSilence_End-.PSGSilence-1,d5

.SilencePSG:
	move.b	(a5)+,PSG_CTRL-VDP_DATA(a3)
	dbf	d5,.SilencePSG

	; Set Z80 reset
	move.w	d0,(a2)

	; Reset registers
	movem.l	(a6),d0-a6
	move	#$2700,sr

.HotStart:
	; Go to game program
	bra.s	GameProgram