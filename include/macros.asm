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
; Disable bytecode instruction
; --------------------------------------------------------------

BDISABLE macros

	dc.w	0

; --------------------------------------------------------------
; Frame done bytecode instruction
; --------------------------------------------------------------

BFRMEND macros

	dc.w	1

; --------------------------------------------------------------
; Delay bytecode instruction
; --------------------------------------------------------------
; PARAMETERS:
;	delay	- Delay time
; --------------------------------------------------------------

BDELAY macros delay

	dc.w	2, \delay

; --------------------------------------------------------------
; Wait for palette fade bytecode instruction
; --------------------------------------------------------------

BFADEW macros

	dc.w	3

; --------------------------------------------------------------
; Write to memory bytecode instruction
; --------------------------------------------------------------
; PARAMETERS:
;	addr	- Address to write to
;	val	- Value to write
; --------------------------------------------------------------

BWRITE macro addr, val

	dc.w	4
	dc.l	\addr
	dc.w	\val

	endm

; --------------------------------------------------------------
; Run code bytecode instruction
; --------------------------------------------------------------
; PARAMETERS:
;	addr	- Address to run code at
; --------------------------------------------------------------

BRUN macro addr

	dc.w	5
	dc.l	\addr

	endm

; --------------------------------------------------------------
; Jump bytecode instruction
; --------------------------------------------------------------
; PARAMETERS:
;	addr	- Address to jump to
; --------------------------------------------------------------

BJMP macro addr

	dc.w	6
	dc.l	\addr

	endm

; --------------------------------------------------------------
; Jump if flag clear bytecode instruction
; --------------------------------------------------------------
; PARAMETERS:
;	addr	- Address to jump to
; --------------------------------------------------------------

BJCLR macro addr

	dc.w	7
	dc.l	\addr

	endm

; --------------------------------------------------------------
; Jump if flag set bytecode instruction
; --------------------------------------------------------------
; PARAMETERS:
;	addr	- Address to jump to
; --------------------------------------------------------------

BJSET macro addr

	dc.w	8
	dc.l	\addr

	endm

; --------------------------------------------------------------
; Jump with table bytecode instruction
; --------------------------------------------------------------

tbl_id = 0

BJTBL macro

tbl_id = tbl_id+1
	dc.w	9
	dc.w	(BCJMPTBL\#tbl_id\_END-BCJMPTBL\#tbl_id\)/4

BCJMPTBL\#tbl_id\:
	endm

; --------------------------------------------------------------
; Jump table end marker
; --------------------------------------------------------------

BJTBLE macro

BCJMPTBL\#tbl_id\_End:

	endm

; --------------------------------------------------------------
; Set VDP registers bytecode instruction
; --------------------------------------------------------------
; PARAMETERS:
;	set	- VDP register set ID
; --------------------------------------------------------------

BVDP macros set

	dc.w	$A, \set

; --------------------------------------------------------------
; Puyo decompression bytecode instruction
; --------------------------------------------------------------
; PARAMETERS:
;	vram	- VRAM address to decompress to
;	art	- Pointer to compressed art
; --------------------------------------------------------------

BPUYO macro vram, art

	dc.w	$B, \vram
	dc.l	\art

	endm

; --------------------------------------------------------------
; Plame command list queue bytecode instruction
; --------------------------------------------------------------
; PARAMETERS:
;	list	- Plane command list ID
; --------------------------------------------------------------

BPCMD macros list

	dc.w	$C, \list

; --------------------------------------------------------------
; Load palette bytecode instruction
; --------------------------------------------------------------
; PARAMETERS:
;	pal	- Pointer to palette
;	line	- Palette line to load to
; --------------------------------------------------------------

BPAL macros pal, line

	dc.w	$D, ((((\pal)-Palettes)&$1FFF)<<3)|((\line)&3)

; --------------------------------------------------------------
; Fade to palette bytecode instruction
; --------------------------------------------------------------
; PARAMETERS:
;	pal	- Pointer to palette
;	line	- Palette line to load to
;	speed	- Fade speed
; --------------------------------------------------------------

BFADE macros pal, line, speed

	dc.w	$E, ((((\pal)-Palettes)&$1FFF)<<3)|((\line)&3), (\speed)<<8

; --------------------------------------------------------------
; Play sound bytecode instruction
; --------------------------------------------------------------
; PARAMETERS:
;	snd	- Sound ID
; --------------------------------------------------------------

BSND macros snd

	dc.w	$F, \snd

; --------------------------------------------------------------
; Play sound (and check PCM sample) bytecode instruction
; --------------------------------------------------------------
; PARAMETERS:
;	snd	- Sound ID
; --------------------------------------------------------------

BSNDP macros snd

	dc.w	$10, \snd

; --------------------------------------------------------------
; Fade out sound bytecode instruction
; --------------------------------------------------------------

BSFADE macros

	dc.w	$11

; --------------------------------------------------------------
; Stop sound sound bytecode instruction
; --------------------------------------------------------------

BSSTOP macros

	dc.w	$12

; --------------------------------------------------------------
; Play sound (and check PCM sample) bytecode instruction
; --------------------------------------------------------------
; PARAMETERS:
;	snd	- Sound ID
; --------------------------------------------------------------

BSNDP2 macros

	dc.w	$13, \snd

; --------------------------------------------------------------
; Nemesis decompression bytecode instruction
; --------------------------------------------------------------
; PARAMETERS:
;	vram	- VRAM address to decompress to
;	art	- Pointer to compressed art
; --------------------------------------------------------------

BNEM macro vram, art

	dc.w	$14, \vram
	dc.l	\art

	endm

; --------------------------------------------------------------
; Fade to palette (checks intro scenes) bytecode instruction
; --------------------------------------------------------------
; PARAMETERS:
;	pal	- Pointer to palette
;	pal2	- Pointer to alternate palette
;	line	- Palette line to load to
;	speed	- Fade speed
; --------------------------------------------------------------

BFADEI macros pal, pal2, line, speed

	dc.w	$15, ((((\pal)-Palettes)&$1FFF)<<3)|((\line)&3), &
		((\speed)<<8)|((((\pal2)-Palettes)>>5)&$FF)

; --------------------------------------------------------------
; Puyo decompression (checks intro scenes) bytecode instruction
; --------------------------------------------------------------
; PARAMETERS:
;	vram	- VRAM address to decompress to
;	art	- Pointer to compressed art
; --------------------------------------------------------------

BPUYOI macro vram, art

	dc.w	$16, \vram
	dc.l	\art

	endm

; --------------------------------------------------------------
; Nemesis decompression (checks intro scenes) bytecode instruction
; --------------------------------------------------------------
; PARAMETERS:
;	vram	- VRAM address to decompress to
;	art	- Pointer to compressed art
; --------------------------------------------------------------

BNEMI macro vram, art

	dc.w	$17, \vram
	dc.l	\art

	endm