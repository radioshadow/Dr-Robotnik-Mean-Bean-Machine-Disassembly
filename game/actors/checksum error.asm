; =============== A C T O R =================================================
; Checksum error
; ---------------------------------------------------------------------------

	move.w	#$100,d0
	jsr	(ActorBookmark_SetDelay).l
	jsr	(ActorBookmark_Ctrl).l
	clr.b	(use_plane_a_buffer).l
	clr.b	(bytecode_disabled).l
	jmp	(ActorDeleteSelf).l