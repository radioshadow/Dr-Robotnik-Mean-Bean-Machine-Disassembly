; --------------------------------------------------------------
; Stop the Z80
; --------------------------------------------------------------

Z80_STOP macro

	move.w	#$100,Z80_BUS

.WaitZ80Stop\@:
	nop
	nop
	nop
	nop
	btst	#0,Z80_BUS
	bne.s	.WaitZ80Stop\@

	endm

; --------------------------------------------------------------
; Start the Z80
; --------------------------------------------------------------

Z80_START macro

	move.w	#0,Z80_BUS

.WaitZ80Start\@:
	nop
	nop
	nop
	nop
	btst	#0,Z80_BUS
	beq.s	.WaitZ80Start\@

	endm

; --------------------------------------------------------------
; DMA copy
; --------------------------------------------------------------

VDP_VRAM	EQU	%100001
VDP_CRAM	EQU	%101011
VDP_VSRAM	EQU	%100101
VDP_READ	EQU	%001100
VDP_WRITE	EQU	%000111
VDP_DMA		EQU	%100111

DMA_COPY macro src, dest, size, type

	lea	VDP_CTRL,a0
	move.w	#$8100,d0
	move.b	vdp_reg_1,d0
	ori.b	#$10,d0
	move.w	d0,(a0)

	move.w	#$9400|(((\size)>>9)&$FF),(a0)
	move.w	#$9300|(((\size)>>1)&$FF),(a0)
	move.w	#$9600|(((\src)>>9)&$FF),(a0)
	move.w	#$9500|(((\src)>>1)&$FF),(a0)
	move.w	#$9700|(((\src)>>17)&$7F),(a0)
	move.w	#(((VDP_\type&VDP_DMA)&3)<<14)|((\dest)&$3FFF),(a0)
	move.w	#(((VDP_\type&VDP_DMA)&$FC)<<2)|(((\dest)&$C000)>>14),dma_cmd_low

	Z80_STOP
	move.w	dma_cmd_low,(a0)
	move.w	#$8100,d0
	move.b	vdp_reg_1,d0
	move.w	d0,(a0)
	Z80_START

	endm

; --------------------------------------------------------------
; Disable interrupts
; --------------------------------------------------------------

DISABLE_INTS macros &

	ori	#$700,sr

; --------------------------------------------------------------
; Enable interrupts
; --------------------------------------------------------------

ENABLE_INTS macros &

	andi	#~$700,sr

; --------------------------------------------------------------
; Set carry flag
; --------------------------------------------------------------

SET_CARRY macros &

	ori	#1,sr

; --------------------------------------------------------------
; Clear carry flag
; --------------------------------------------------------------

CLEAR_CARRY macros &

	andi	#~1,sr
	
; --------------------------------------------------------------
; Bankswitch between SRAM and ROM (enable SRAM in the header!)
; --------------------------------------------------------------

USE_SRAM macro

	move.b  #1,($A130F1).l
	endm

USE_ROM macro
		
	move.b  #0,($A130F1).l
	endm