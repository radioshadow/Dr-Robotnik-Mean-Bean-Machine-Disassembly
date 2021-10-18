; --------------------------------------------------------------
;
;	Dr. Robotnik's Mean Bean Machine Disassembly
;	Original game by Compile
;
;	Disassembled by Devon Artmeier
;
; --------------------------------------------------------------

; --------------------------------------------------------------
; Decompress Puyo compressed art
; This is an LZ-based algorithm that opts to use a raw data
; count instead of marking individual raw bytes with a flag
; --------------------------------------------------------------
; PARAMETERS:
;	d0.w	- VRAM address
;	a0.l	- Pointer to compressed art
; --------------------------------------------------------------

PuyoDec:
	DISABLE_INTS					; Disable interrupts

	move.w	d0,d1					; Convert VRAM address to VDP command
	andi.w	#$3FFF,d1
	ori.w	#$4000,d1
	move.w	d1,VDP_CTRL
	lsl.l	#2,d0
	swap	d0
	andi.w	#3,d0
	move.w	d0,VDP_CTRL

	lea	puyo_dec_buffer,a1			; Decompression buffer
	lea	puyo_dec_vdp_buf,a2			; VDP write buffer
	clr.w	d0					; Reset decompression buffer index
	clr.w	d1					; Reset VDP write buffer index

.DecompLoop:
	move.b	(a0)+,d2				; Get byte from compressed data
	tst.b	d2
	bmi.w	.Window					; If we should go back into the sliding window, branch
	bne.w	.RawData				; If we should copy raw data, branch

	ENABLE_INTS					; Enable interrupts
	rts

; --------------------------------------------------------------

.RawData:
	andi.w	#$7F,d2					; Get length of raw data block
	subq.w	#1,d2

.RawDataLoop:
	move.b	(a0)+,d4				; Copy raw data into VDP buffer
	move.b	d4,(a2,d1.w)

	addq.b	#1,d1					; Increment VDP buffer index
	btst	#2,d1					; Should we copy the VDP buffer into VRAM and loop back?
	beq.w	.RawDataStore				; If not, branch
	clr.b	d1					; Loop back to the start of the VDP buffer
	move.l	(a2),VDP_DATA				; Copy the VDP buffer into VRAM

.RawDataStore:
	move.b	d4,(a1,d0.w)				; Copy raw data into the sliding window
	addq.b	#1,d0					; Move sliding window
	dbf	d2,.RawDataLoop				; Loop until all of the raw data block is copied

	bra.s	.DecompLoop				; Go handle the next data block

; --------------------------------------------------------------

.Window:
	andi.w	#$7F,d2					; Get length of data to copy
	addq.w	#2,d2

	move.w	d0,d3					; Go to offset in the sliding window
	sub.b	(a0)+,d3
	subq.b	#1,d3

.WindowLoop:
	move.b	(a1,d3.w),d4				; Copy data from the sliding window into VDP buffer
	move.b	d4,(a2,d1.w)

	addq.b	#1,d1					; Increment VDP buffer index
	btst	#2,d1					; Should we copy the VDP buffer into VRAM and loop back?
	beq.w	.WindowStore				; If not, branch
	clr.b	d1					; Loop back to the start of the VDP buffer
	move.l	(a2),VDP_DATA				; Copy the VDP buffer into VRAM

.WindowStore:
	move.b	d4,(a1,d0.w)				; Copy raw data into the sliding window
	addq.b	#1,d0					; Move sliding window
	addq.b	#1,d3					; Move sliding window copy offset
	dbf	d2,.WindowLoop				; Loop until all of the data needed is copied

	bra.s	.DecompLoop				; Go handle the next data block

; --------------------------------------------------------------