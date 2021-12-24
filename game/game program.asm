; =============== S U B	R O U T	I N E =======================================
; Game program
; ---------------------------------------------------------------------------

	tst.w	VDP_CTRL
	DISABLE_INTS
	bsr.w	WaitDMA
	bsr.w	InitGame
	ENABLE_INTS

.GameLoop:
	bsr.w	VSync
	jsr		CheckPause
	bsr.w	ReadCtrls_Safe
	bsr.w	RunBytecode
	bsr.w	RunActors
	jsr		DrawActors
	bra.s	.GameLoop