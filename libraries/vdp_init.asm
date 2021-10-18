; --------------------------------------------------------------
;
;	Dr. Robotnik's Mean Bean Machine Disassembly
;	Original game by Compile
;
;	Disassembled by Devon Artmeier
;
; --------------------------------------------------------------

; --------------------------------------------------------------
; Initialize the VDP
; --------------------------------------------------------------

InitVDP:
	clr.w	d0					; Setup first VDP register set
	bsr.w	SetupVDPRegs
	bsr.w	InitPalette				; Initialize palette
	rts

; --------------------------------------------------------------
; Setup VDP registers (interrupt safe)
; --------------------------------------------------------------
; PARAMETERS:
;	d0.w	- VDP register table ID
; --------------------------------------------------------------

SetupVDPRegsSafe:
	DISABLE_INTS					; Disable interrupts

	bsr.w	SetupVDPregs				; Setup VDP registers
	
	lea	vdp_reg_1,a0				; Enable display
	ori.b	#$40,(a0)
	move.w	#$8100,d0
	move.b	(a0),d0
	move.w	d0,VDP_CTRL

	ENABLE_INTS					; Enable interrupts
	rts

; --------------------------------------------------------------
; Setup VDP registers
; --------------------------------------------------------------
; PARAMETERS:
;	d0.w	- VDP register table ID
; --------------------------------------------------------------

SetupVDPRegs:
	lsl.w	#2,d0					; Get VDP register table
	movea.l	.VDPRegTables(pc,d0.w),a2

	lea	vdp_reg_0,a3				; Initialize up to VDP register 12
	move.w	#(vdp_reg_13-vdp_reg_0)-1,d0

.RegLoop:
	move.w	(a2)+,d1				; Setup VDP register
	move.w	d1,VDP_CTRL
	move.b	d1,(a3)+				; Make a copy of it in RAM
	dbf	d0,.RegLoop				; Loop until all VDP registers are setup

	clr.l	vscroll_buffer				; Reset scrolling
	clr.l	hscroll_buffer

	rts

; --------------------------------------------------------------

.VDPRegTables:
	dc.l	.Table0
	dc.l	.Table1
	dc.l	.Table2
	dc.l	.Table3

; --------------------------------------------------------------

.Table0:
	dc.w	$8000|(%00000100)			; Disable H/V latch, disable H-BLANK
	dc.w	$8100|(%00100100)			; Disable DMA, enable V-BLANK
	dc.w	$8200|($C000/$400)			; Plane A location at $C000
	dc.w	$8300|($F000/$400)			; Window location at $F000
	dc.w	$8400|($E000/$2000)			; Plane B location at $E000
	dc.w	$8500|($BC00/$200)			; Sprite table location at $BC00
	dc.w	$8600|(%00000000)			; Disable sprite pattern generator rebasing
	dc.w	$8700|($00)				; Background color at line 0, color 0
	dc.w	$8800|(%00000000)			; Unused
	dc.w	$8900|(%00000000)			; Unused
	dc.w	$8A00|($00)				; H-BLANK counter at 0
	dc.w	$8B00|(%00000011)			; VScroll by screen, HScroll by line
	dc.w	$8C00|(%10000001)			; H40 resolution mode
	dc.w	$8D00|($B800/$400)			; HScroll table location at $B800
	dc.w	$8E00|($00)				; Disable nametable generator rebasing
	dc.w	$8F00|($02)				; Autoincrement at 2
	dc.w	$9000|(%00000011)			; Plane size at 128x32
	dc.w	$9100|($00)				; Window plane horizontal position
	dc.w	$9200|($00)				; Window plane vertical position

; --------------------------------------------------------------

.Table1:
	dc.w	$8000|(%00000100)			; Disable H/V latch, disable H-BLANK
	dc.w	$8100|(%00100100)			; Disable DMA, enable V-BLANK
	dc.w	$8200|($C000/$400)			; Plane A location at $C000
	dc.w	$8300|($F000/$400)			; Window location at $F000
	dc.w	$8400|($E000/$2000)			; Plane B location at $E000
	dc.w	$8500|($BC00/$200)			; Sprite table location at $BC00
	dc.w	$8600|(%00000000)			; Disable sprite pattern generator rebasing
	dc.w	$8700|($00)				; Background color at line 0, color 0
	dc.w	$8800|(%00000000)			; Unused
	dc.w	$8900|(%00000000)			; Unused
	dc.w	$8A00|($00)				; H-BLANK counter at 0
	dc.w	$8B00|(%00000000)			; Scroll by screen
	dc.w	$8C00|(%10001001)			; H40 resolution mode, enable S/H mode
	dc.w	$8D00|($B800/$400)			; HScroll table location at $B800
	dc.w	$8E00|($00)				; Disable nametable generator rebasing
	dc.w	$8F00|($02)				; Autoincrement at 2
	dc.w	$9000|(%00010001)			; Plane size at 64x64
	dc.w	$9100|($00)				; Window plane horizontal position
	dc.w	$9200|($00)				; Window plane vertical position

; --------------------------------------------------------------

.Table2:
	dc.w	$8000|(%00000100)			; Disable H/V latch, disable H-BLANK
	dc.w	$8100|(%00100100)			; Disable DMA, enable V-BLANK
	dc.w	$8200|($C000/$400)			; Plane A location at $C000
	dc.w	$8300|($F000/$400)			; Window location at $F000
	dc.w	$8400|($E000/$2000)			; Plane B location at $E000
	dc.w	$8500|($BC00/$200)			; Sprite table location at $BC00
	dc.w	$8600|(%00000000)			; Disable sprite pattern generator rebasing
	dc.w	$8700|($00)				; Background color at line 0, color 0
	dc.w	$8800|(%00000000)			; Unused
	dc.w	$8900|(%00000000)			; Unused
	dc.w	$8A00|($00)				; H-BLANK counter at 0
	dc.w	$8B00|(%00000000)			; Scroll by screen
	dc.w	$8C00|(%10000001)			; H40 resolution mode
	dc.w	$8D00|($B800/$400)			; HScroll table location at $B800
	dc.w	$8E00|($00)				; Disable nametable generator rebasing
	dc.w	$8F00|($02)				; Autoincrement at 2
	dc.w	$9000|(%00000001)			; Plane size at 64x32
	dc.w	$9100|($8E)				; Window plane horizontal position
	dc.w	$9200|($92)				; Window plane vertical position

; --------------------------------------------------------------

.Table3:
	dc.w	$8000|(%00000100)			; Disable H/V latch, disable H-BLANK
	dc.w	$8100|(%00100100)			; Disable DMA, enable V-BLANK
	dc.w	$8200|($C000/$400)			; Plane A location at $C000
	dc.w	$8300|($F000/$400)			; Window location at $F000
	dc.w	$8400|($E000/$2000)			; Plane B location at $E000
	dc.w	$8500|($BC00/$200)			; Sprite table location at $BC00
	dc.w	$8600|(%00000000)			; Disable sprite pattern generator rebasing
	dc.w	$8700|($00)				; Background color at line 0, color 0
	dc.w	$8800|(%00000000)			; Unused
	dc.w	$8900|(%00000000)			; Unused
	dc.w	$8A00|($00)				; H-BLANK counter at 0
	dc.w	$8B00|(%00000000)			; Scroll by screen
	dc.w	$8C00|(%10000001)			; H40 resolution mode
	dc.w	$8D00|($B800/$400)			; HScroll table location at $B800
	dc.w	$8E00|($00)				; Disable nametable generator rebasing
	dc.w	$8F00|($02)				; Autoincrement at 2
	dc.w	$9000|(%00000011)			; Plane size at 128x32
	dc.w	$9100|($92)				; Window plane horizontal position
	dc.w	$9200|($94)				; Window plane vertical position

; --------------------------------------------------------------