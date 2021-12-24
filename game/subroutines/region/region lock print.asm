; =============== S U B	R O U T	I N E =======================================
; Region Lock Print
; ---------------------------------------------------------------------------

	DISABLE_INTS
	move.w	d1,d3
	lea	(CharConvTable).l,a3

.Line:
	jsr	(SetVRAMWrite).l
	move.w	d3,d1

.Char:
	moveq	#0,d2
	move.b	(a2)+,d2
	move.b	(a3,d2.w),d2
	add.w	d6,d2
	move.w	d2,VDP_DATA
	dbf	d1,.Char
	addi.w	#$80,d5
	dbf	d0,.Line
	ENABLE_INTS
	rts

; ---------------------------------------------------------------------------

CharConvTable:
	include "data/font tables/Table - Region Error.asm"