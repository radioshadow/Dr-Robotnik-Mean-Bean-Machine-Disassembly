; --------------------------------------------------------------
;
;	Dr. Robotnik's Mean Bean Machine Disassembly
;	Original game by Compile
;
;	Disassembled by Devon Artmeier
;
; --------------------------------------------------------------

; --------------------------------------------------------------
; V-BLANK routine
; --------------------------------------------------------------

VBlank:
	DISABLE_INTS					; Disable interrupts
	movem.l	d0-a6,-(sp)				; Save registers

	addq.w	#1,frame_count				; Increment frame count

.WaitDMA:
	move.w	VDP_CTRL,d0				; Is DMA still active?
	btst	#1,d0
	bne.s	.WaitDMA				; If so, wait

	move.w	dma_slot,d2				; Get current DMA queue slot
	beq.w	.NoDMA					; If there's no DMAs queued, branch

	lsr.w	#4,d2					; Convert current slot into queue count
	subq.w	#1,d2

	lea	dma_queue,a0				; Setup DMA queue for processing
	lea	VDP_CTRL,a1

.DMALoop:
	move.w	#$8100,d0				; Enable DMA
	move.b	vdp_reg_1,d0
	ori.b	#$10,d0
	move.b	d0,vdp_reg_1
	move.w	d0,VDP_CTRL

	move.w	(a0)+,(a1)				; Process DMA queue slot
	move.l	(a0)+,(a1)
	move.l	(a0)+,(a1)
	move.l	(a0)+,(a1)
	Z80_STOP
	move.w	(a0)+,(a1)

.WaitDMA2:
	move.w	VDP_CTRL,d0				; Is DMA still active?
	btst	#1,d0
	bne.s	.WaitDMA2				; If so, wait
	
	move.w	#$8100,d0				; Disable DMA
	move.b	vdp_reg_1,d0
	andi.b	#~$10,d0
	move.b	d0,vdp_reg_1
	move.w	d0,VDP_CTRL

	Z80_START
	dbf	d2,.DMALoop				; Loop until all queued DMAs are done

	clr.w	dma_slot				; Mark DMA queue as empty

	move.w	#$8F02,VDP_CTRL				; Set autoincrement to 2
	move.b	#2,vdp_reg_f

.NoDMA:
	bsr.w	SetupHBlank				; Setup H-BLANK for the next frame
	bsr.w	HandleGameTimer				; Handle game timer
	jsr	UpdateSound				; Update sound

	bsr.w	TransferSprites				; Transfer sprites into VRAM
	bsr.w	TransferVScroll				; Transfer VScroll data into VSRAM
	bsr.w	TransferHScroll				; Transfer HScroll data into VRAM
	bsr.w	TransferPalette				; Transfer palette into CRAM

	jsr	ProcPlaneCommands			; Process plane commands
	jsr	ProcEniTilemapQueue			; Process Enigma tilemap queue

	bsr.w	Random					; Update RNG

	tst.w	use_plane_a_buffer			; Should we transfer the plane A buffer into VRAM?
	beq.w	.End					; If not, branch
	bsr.w	TransferPlaneABuffer			; If so, do it

.End:
	movem.l	(sp)+,d0-a6				; Restore registers
	ENABLE_INTS					; Enable interrupts
	rtr

; --------------------------------------------------------------
; Transfer the plane A buffer into VRAM
; --------------------------------------------------------------

TransferPlaneABuffer:
	tst.w	dma_disabled				; Is DMA disabled?
	bne.w	.ManualCopy				; If so, branch

	DMA_COPY plane_a_buffer, $C000, $E00, VRAM, 0	; Copy the buffer into VRAM via DMA
	rts

.ManualCopy:
	lea	plane_a_buffer,a1			; Manually copy the buffer into VRAM
	move.w	#$4000,VDP_CTRL
	move.w	#3,VDP_CTRL
	move.w	#$E00/2-1,d0

.Copy:
	move.w	(a1)+,VDP_DATA
	dbf	d0,.Copy

	rts

; --------------------------------------------------------------
; Handle game timer
; --------------------------------------------------------------

HandleGameTimer:
	move.b	p1_pause,d0				; Is the game paused?
	or.b	p2_pause,d0
	bmi.w	.TimeDisabled				; If so, branch

	addq.w	#1,time_frames				; Increment frame count
	bcc.w	.SplitTime				; If it hasn't overflowed, branch
	subq.w	#1,time_frames				; Cap the frame count

.SplitTime:
	clr.l	d0					; Convert frame count into seconds
	move.w	time_frames,d0
	divu.w	#60,d0
	move.w	d0,time_total_seconds
	
	clr.l	d0					; Split seconds into seconds and minutes
	move.w	time_total_seconds,d0
	divu.w	#60,d0
	move.l	d0,time_seconds

.TimeDisabled:
	rts

; --------------------------------------------------------------
; Setup H-BLANK (leftover from Puyo Puyo)
; --------------------------------------------------------------

SetupHBlank:
	clr.w	d0					; Get H-BLANK count
	move.b	hblank_count,d0
	beq.w	DisableHBlank				; If it's 0, disable H-BLANK
	move.w	d0,hblank_counter

	move.l	#hblank_buffer_1,hblank_buffer_ptr	; Get H-BLANK buffer 1
	tst.b	hblank_buffer_id			; Should we use buffer 2?
	beq.w	.Setup					; If not, branch
	move.l	#hblank_buffer_2,hblank_buffer_ptr	; Get H-BLANK buffer 2

.Setup:
	move.w	#$8000,d0				; Enable H-BLANK
	move.b	vdp_reg_0,d0
	ori.b	#$10,d0
	move.w	d0,VDP_CTRL
	move.b	d0,vdp_reg_0
	
	move.w	#$8B00,d0				; VScroll by screen
	move.b	vdp_reg_b,d0
	andi.b	#~4,d0
	move.b	d0,vdp_reg_b

	rts

; --------------------------------------------------------------
; H-BLANK routine (leftover from Puyo Puyo's title screen)
; --------------------------------------------------------------

HBlank:
	DISABLE_INTS					; Disable interrupts
	tst.b	hblank_count				; Is H-BLANK count 0?
	beq.w	.End					; If so, branch
	movem.l	a0,-(sp)

	move.l	#$40000010,VDP_CTRL			; Set VScroll value for this scanline
	movea.l	hblank_buffer_ptr,a0
	move.w	(a0),VDP_DATA
	addq.w	#2,hblank_buffer_ptr+2			; Increment HBlank buffer pointer
	
	subq.w	#1,hblank_counter			; Decrement H-BLANK counter
	bne.w	.EndRestore				; If there are still scanlines to process, branch

	movem.l	d0,-(sp)
	bsr.w	DisableHBlank				; Disable H-BLANK
	movem.l	(sp)+,d0

	move.l	#$40000010,VDP_CTRL			; Set VScroll to 0
	move.w	#0,VDP_DATA

.EndRestore:
	movem.l	(sp)+,a0

.End:
	ENABLE_INTS					; Enable interrupts
	rtr

; --------------------------------------------------------------
; Disable H-BLANK
; --------------------------------------------------------------

DisableHBlank:
	move.w	#$8000,d0				; Disable H-BLANK
	move.b	vdp_reg_0,d0
	andi.b	#~$10,d0
	move.w	d0,VDP_CTRL
	move.b	d0,vdp_reg_0

	rts

; --------------------------------------------------------------
; Refresh palette
; --------------------------------------------------------------

RefreshPalette2:
	move.w	#4-1,d0					; 4 palette lines
	lea	pal_load_queue,a0			; Palette load queue
	lea	palette_buffer,a1			; Palette buffer

.LineLoop:
	tst.w	(a0)					; Is this palette line queued for loading?
	bne.w	.NextLine				; If so, branch
	move.w	#-1,0(a0)				; Mark palette line as queued
	move.l	a1,2(a0)				; Set pointer to palette line in palette buffer

.NextLine:
	adda.l	#6,a0					; Next palette line
	adda.l	#$20,a1
	dbf	d0,.LineLoop				; Loop until all palette lines are queued

	rts

; --------------------------------------------------------------
; Transfer the palette into CRAM
; --------------------------------------------------------------

TransferPalette:
	lea	pal_load_queue,a2			; Palette load queue
	lea	palette_buffer,a3			; Palette buffer

	move.w	#4-1,d0					; 4 palette lines
	moveq	#0,d1					; Start at $0000 in CRAM

.LineLoop:
	tst.w	(a2)					; Is this palette line queued for loading?
	beq.w	.NextLine				; If not, branch
	clr.w	(a2)					; Mark palette line as loaded
	bsr.w	TransferPalLine				; Transfer palette line

.NextLine:
	adda.l	#6,a2					; Next palette line
	adda.l	#$20,a3
	addi.b	#$20,d1
	dbf	d0,.LineLoop				; Loop until all palette lines are loaded

	rts

; --------------------------------------------------------------
; Transfer a palette line into CRAM
; --------------------------------------------------------------
; PARAMETERS:
;	d1.w	- CRAM offset
;	a2.l	- Palette pointer list
;	a3.l	- Palette buffer
; --------------------------------------------------------------

TransferPalLine:
	movem.l	a3,-(sp)

	movea.l	2(a2),a4				; Get pointer to palette data
	move.w	#$C000,d2				; Setup CRAM write
	move.b	d1,d2
	move.w	d2,VDP_CTRL
	move.w	#0,VDP_CTRL

	move.w	#$20/2-1,d2				; 16 words in a palette line

.CopyPal:
	move.w	(a4),VDP_DATA				; Load palette into CRAM
	move.w	(a4)+,(a3)+				; Load palette into palette buffer
	dbf	d2,.CopyPal				; Loop until the palette line is loaded

	movem.l	(sp)+,a3
	rts

; --------------------------------------------------------------
; Transfer the sprite buffer to VRAM
; --------------------------------------------------------------

TransferSprites:
	tst.w	sprite_count				; Are there any sprites that need to be transferred?
	bne.w	.CheckDMA				; If so, branch
	rts

.CheckDMA:
	tst.w	dma_disabled				; Is DMA disabled?
	bne.w	.ManualCopy				; If so, branch

	DMA_COPY sprite_buffer, $BC00, sprite_count, VRAM, 1
	clr.w	sprite_count				; No more sprites need to be transferred
	rts

.ManualCopy:
	lea	sprite_buffer,a1			; Manually copy the buffer into VRAM
	move.w	#$7C00,VDP_CTRL
	move.w	#2,VDP_CTRL
	move.w	sprite_count,d0
	subq.w	#1,d0

.Copy:
	move.w	(a1)+,VDP_DATA
	dbf	d0,.Copy

	clr.w	sprite_count				; No more sprites need to be transferred
	rts

; --------------------------------------------------------------
; Transfer the vertical scroll buffer to VRAM
; --------------------------------------------------------------

TransferVScroll:
	move.w	#$8B00,d0				; Setup VDP register B
	move.b	vdp_reg_b,d0
	move.w	d0,VDP_CTRL
	move.w	#$8C00,d0				; Setup VDP register C
	move.b	vdp_reg_c,d0
	move.w	d0,VDP_CTRL

	btst	#2,vdp_reg_b				; Is VScroll by column enabled?
	bne.w	.ColumnScroll				; If so, branch

	move.l	#$40000010,VDP_CTRL			; Copy the first 4 bytes in the buffer into VSRAM
	move.w	vscroll_buffer,VDP_DATA
	move.w	vscroll_buffer+2,VDP_DATA

	rts

.ColumnScroll:
	tst.w	dma_disabled				; Is DMA disabled?
	bne.w	.ManualCopy				; If so, branch

	DMA_COPY vscroll_buffer, 0, $50, VSRAM, 0	; Copy the buffer into VSRAM via DMA
	rts

.ManualCopy:
	lea	vscroll_buffer,a1			; Manually copy the buffer into VSRAM
	move.l	#$40000010,VDP_CTRL
	move.w	#$50/2-1,d0

.Copy:
	move.w	(a1)+,VDP_DATA
	dbf	d0,.Copy

	rts

; --------------------------------------------------------------
; Transfer the horizontal scroll buffer to VRAM
; --------------------------------------------------------------

TransferHScroll:
	btst	#1,vdp_reg_b				; Is HScroll by row enabled?
	bne.w	.RowScroll				; If so, branch

	move.w	#$7800,VDP_CTRL				; Copy the first 4 bytes in the buffer into VRAM
	move.w	#$2,VDP_CTRL
	move.w	hscroll_buffer,VDP_DATA
	move.w	hscroll_buffer+2,VDP_DATA

	rts

.RowScroll:
	tst.w	dma_disabled				; Is DMA disabled?
	bne.w	.ManualCopy				; If so, branch

	DMA_COPY hscroll_buffer, $B800, $400, VRAM, 0	; Copy the buffer into VRAM via DMA
	rts

.ManualCopy:
	lea	hscroll_buffer,a1			; Manually copy the buffer into VRAM
	move.w	#$7800,VDP_CTRL
	move.w	#2,VDP_CTRL
	move.w	#$400/2-1,d0

.Copy:
	move.w	(a1)+,VDP_DATA
	dbf	d0,.Copy

	rts

; --------------------------------------------------------------
; Dead leftover code from Puyo Puyo. Appears to be old VRAM
; data buffering code that's also dead in Puyo Puyo.
; --------------------------------------------------------------

DeadVRAMBufCode:
	tst.b	vram_buffer_id
	bne.w	.DoTransfer
	rts

.DoTransfer:
	clr.b	vram_buffer_id

	DMA_COPY vram_buffer, $1000, $800, VRAM, 0

	lea	vram_buffer,a1
	lea	hblank_buffer_1,a2
	move.w	vram_buffer_id,d0
	mulu.w	#$800,d0
	adda.l	d0,a2
	move.w	#$800/2-1,d0

.Copy:
	move.w	(a2)+,(a1)+
	dbf	d0,.Copy

	DMA_COPY vram_buffer, $2000, $800, VRAM, 0

	lea	vram_buffer,a1
	lea	hblank_buffer_1,a2
	move.w	vram_buffer_id,d0
	addq.b	#8,d0
	andi.b	#$F,d0
	mulu.w	#$800,d0
	adda.l	d0,a2
	move.w	#$800/2-1,d0

.Copy2:
	move.w	(a2)+,(a1)+
	dbf	d0,.Copy2
	
	DMA_COPY vram_buffer, $2800, $800, VRAM, 0

	rts

; --------------------------------------------------------------