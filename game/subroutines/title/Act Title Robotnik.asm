; =============== S U B	R O U T	I N E =======================================
; Act Title Robotnik
; ---------------------------------------------------------------------------
					
	cmpi.w	#1,(word_FF1126).l
	beq.w	loc_E078
	subq.b	#1,$26(a0)
	beq.s	loc_E01C
	rts
; ---------------------------------------------------------------------------

loc_E01C:
	move.w	$28(a0),d0
	addq.w	#1,$28(a0)
	add.w	d0,d0
	lea	(unk_E07E).l,a1
	adda.w	d0,a1
	clr.w	d0
	move.b	(a1)+,d0
	bmi.w	loc_E078
	move.b	(a1),d1
	move.b	d1,$26(a0)
	cmpi.b	#2,d0
	bne.s	loc_E050
	move.l	d0,-(sp)
	move.b	#$94,d0
	jsr	(PlaySound_ChkPCM).l
	move.l	(sp)+,d0

loc_E050:
	lsl.w	#3,d0
	lea	(unk_E0BA).l,a1
	adda.w	d0,a1
	lea	((palette_buffer+$6C)).l,a2
	moveq	#3,d0

loc_E062:
	move.w	(a1)+,(a2)+
	dbf	d0,loc_E062
	move.b	#3,d0
	lea	((palette_buffer+$60)).l,a2
	jmp	(LoadPalette).l
; ---------------------------------------------------------------------------

loc_E078:
	jmp	(ActorDeleteSelf).l
; End of function ActTitleRobotnik

; ---------------------------------------------------------------------------
unk_E07E:	dc.b   0
	dc.b $5A
	dc.b   1
	dc.b   1
	dc.b   2
	dc.b   1
	dc.b   1
	dc.b   1
	dc.b   3
	dc.b   5
	dc.b   1
	dc.b   1
	dc.b   2
	dc.b   1
	dc.b   1
	dc.b   1
	dc.b   3
	dc.b   5
	dc.b   4
	dc.b   5
	dc.b   5
	dc.b   5
	dc.b   6
	dc.b   5
	dc.b   0
	dc.b $5A
	dc.b   1
	dc.b   1
	dc.b   2
	dc.b   1
	dc.b   1
	dc.b   1
	dc.b   3
	dc.b   5
	dc.b   1
	dc.b   1
	dc.b   2
	dc.b   1
	dc.b   1
	dc.b   1
	dc.b   3
	dc.b   5
	dc.b   4
	dc.b   5
	dc.b   5
	dc.b   5
	dc.b   6
	dc.b   5
	dc.b   0
	dc.b $5A
	dc.b   6
	dc.b   6
	dc.b   5
	dc.b   6
	dc.b   4
	dc.b   6
	dc.b   3
	dc.b   6
	dc.b $FF
	dc.b   0
unk_E0BA:	dc.b   2
	dc.b   0
	dc.b   2
	dc.b   0
	dc.b   2
	dc.b   0
	dc.b   2
	dc.b   0
	dc.b  $A
	dc.b   0
	dc.b   8
	dc.b   0
	dc.b   6
	dc.b   0
	dc.b  $A
	dc.b   0
	dc.b  $A
	dc.b   0
	dc.b   8
	dc.b   0
	dc.b  $A
	dc.b   0
	dc.b  $A
	dc.b $20
	dc.b  $A
	dc.b   0
	dc.b   8
	dc.b   0
	dc.b   6
	dc.b   0
	dc.b   4
	dc.b   0
	dc.b   8
	dc.b   0
	dc.b   6
	dc.b   0
	dc.b   4
	dc.b   0
	dc.b   2
	dc.b   0
	dc.b   6
	dc.b   0
	dc.b   4
	dc.b   0
	dc.b   2
	dc.b   0
	dc.b   2
	dc.b   0
	dc.b   4
	dc.b   0
	dc.b   2
	dc.b   0
	dc.b   2
	dc.b   0
	dc.b   2
	dc.b   0