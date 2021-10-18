; --------------------------------------------------------------
;
;	Dr. Robotnik's Mean Bean Machine Disassembly
;	Original game by Compile
;
;	Disassembled by Devon Artmeier
;
; --------------------------------------------------------------

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
; PARAMETERS:
;	src	- Source address
;	dest	- Destination VDP address
;	size	- Size of data
;	type	- Type of data
;	szvar	- Set to nonzero if size is a variable
; --------------------------------------------------------------

VDP_VRAM	EQU	%100001
VDP_CRAM	EQU	%101011
VDP_VSRAM	EQU	%100101
VDP_READ	EQU	%001100
VDP_WRITE	EQU	%000111
VDP_DMA		EQU	%100111

DMA_COPY macro src, dest, size, type, szvar

	lea	VDP_CTRL,a0
	move.w	#$8100,d0
	move.b	vdp_reg_1,d0
	ori.b	#$10,d0
	move.w	d0,(a0)

	if szvar=0
		move.w	#$9400|(((\size)>>9)&$FF),(a0)
		move.w	#$9300|(((\size)>>1)&$FF),(a0)
	else
		move.w	#$9400,d0
		move.b	(\size),d0
		move.w	d0,(a0)
		move.w	#$9300,d0
		move.b	(\size)+1,d0
		move.w	d0,(a0)
	endif
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
; Queue a DMA copy
; --------------------------------------------------------------

QUEUE_DMA macro src, dest, size, type

	lea	dma_queue,a0
	adda.w	dma_slot,a0

	move.w	#$8F02,(a0)+
	move.l	#(($9400|(((\size)>>9)&$FF))<<16)|($9300|(((\size)>>1)&$FF)),(a0)+
	move.l	#(($9600|(((\src)>>9)&$FF))<<16)|($9500|(((\src)>>1)&$FF)),(a0)+
	move.w	#$9700|(((\src)>>17)&$7F),(a0)+
	move.l	#(((((VDP_\type&VDP_DMA)&3)<<14)|((\dest)&$3FFF))<<16)|((((VDP_\type&VDP_DMA)&$FC)<<2)|(((\dest)&$C000)>>14)),(a0)

	addi.w	#$10,dma_slot

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

; --------------------------------------------------------------
; Set cutscene dialogue textbox text
; --------------------------------------------------------------
; PARAMETERS:
;	text	- Text
; --------------------------------------------------------------

CUTSCENE_TEXT macro text

i = 0
escape = 0
	while i<strlen(\text)
c substr 1+i, 1+i, \text

	if escape=0
		; Escape character
		if "\c"="%"
escape = 1
		; Regular character
		else
			dc.b	"\c"
		endif
	else
		; Line break
		if "\c"="n"
			dc.b	$86
		; Space with no sound
		elseif "\c"="s"
			dc.b	$89
		; Invalid
		else
			inform 2,"Invalid escape character '%s'", "\c"
		endif
escape = 0
	endif

i = i+1
	endw

	endm

; --------------------------------------------------------------
; End cutscene
; --------------------------------------------------------------

CUTSCENE_END macro

	dc.b	$80
	if (*)&1
		ALIGN	2
	endif

	endm

; --------------------------------------------------------------
; Initialize cutscene dialogue textbox
; --------------------------------------------------------------
; PARAMETERS:
;	width	- Textbox width
;	height	- Textbox height
;	vram	- VRAM address to load textbox at
; --------------------------------------------------------------

CUTSCENE_TEXTBOX macro width, height, vram

	dc.b	$81, (((\height)&7)<<5)|((\width)&$1F)
	dc.w	\vram

	endm

; --------------------------------------------------------------
; Close cutscene dialogue textbox
; --------------------------------------------------------------

CUTSCENE_TEXT_CLOSE macros

	dc.b	$82

; --------------------------------------------------------------
; Delay cutscene by N*10 frames
; --------------------------------------------------------------
; PARAMETERS:
;	time	- Delay time (divided by 10)
; --------------------------------------------------------------

CUTSCENE_DELAY macros time

	dc.b	$83, \time

; --------------------------------------------------------------
; Set animation for Arle in cutscene (leftover from Puyo Puyo)
; --------------------------------------------------------------
; PARAMETERS:
;	anim	- Animation ID
; --------------------------------------------------------------

CUTSCENE_ARLE_ANIM macros anim

	dc.b	$84, \anim

; --------------------------------------------------------------
; Set animation for enemy in cutscene
; --------------------------------------------------------------
; PARAMETERS:
;	anim	- Animation ID
; --------------------------------------------------------------

CUTSCENE_ENEMY_ANIM macros anim

	dc.b	$85, \anim

; --------------------------------------------------------------
; Clear cutscene dialogue textbox (broken)
; --------------------------------------------------------------
; PARAMETERS:
;	anim	- Animation ID
; --------------------------------------------------------------

CUTSCENE_TEXT_CLEAR macros anim

	dc.b	$87

; --------------------------------------------------------------
; Play a sound in cutscene
; --------------------------------------------------------------
; PARAMETERS:
;	snd	- Sound ID
; --------------------------------------------------------------

CUTSCENE_SOUND macros snd

	dc.b	$8A, \snd

; --------------------------------------------------------------
; Stage text data
; --------------------------------------------------------------
; PARAMETERS:
;	font	- 0 for large font, 1 for small font
;	text	- Text to store
; --------------------------------------------------------------

STAGE_TEXT macro font, text

foff = 0
	if (\font)<>0
foff = $6A
	endif

escape = 0
i = 0
	while i<strlen(\text)
c substr 1+i,1+i,\text
	if escape=0
		; Escape character
		if "\c"="%"
escape = 1
		; Space
		elseif "\c"=" "
			dc.b	$00
		; ? (small font)
		elseif ("\c"="?")&((\font)<>0)
			dc.b	$B4
		; 0-9
		elseif ("\c">="0")&("\c"<="9")
			dc.b	("\c"-$2F)*2+foff
		; A-Z
		elseif ("\c">="A")&("\c"<="Z")
			dc.b	("\c"-$40)*2+(10*2)+foff
		; Small "x" (large font)
		elseif ("\c"="x")&((\font)=0)
			dc.b	$4A
		; a-z
		elseif ("\c">="a")&("\c"<="z")
			dc.b	("\c"-$60)*2+(10*2)+foff
		endif
	else
		; Custom character
		if "\c"="c"
			dc.b	$FE
		; Invalid
		else
			inform 2,"Invalid escape character '%s'", "\c"
		endif
escape = 0
	endif
i = i+1
	endw

	endm

; --------------------------------------------------------------
; Print stage text at location
; --------------------------------------------------------------
; PARAMETERS:
;	font	- 0 for large font, 1 for small font
;	loc	- VRAM location to store text
;		  If >= $C000, it's used as an absolute address,
;		  otherwise, it's treated as relative to a
;		  player's puyo field
;	base	- Base VRAM address for font
;	text	- Text to store
; --------------------------------------------------------------

STAGE_TEXT_LOC macro font, loc, base, text

	if (\loc)<$C000
		dc.w	0, \loc, \base
	else
		dc.w	\loc, \base
	endif

	STAGE_TEXT \font, \text

	dc.b	$FF
	if (*)&1
		ALIGN	2
	endif

	endm

; --------------------------------------------------------------