; =============== S U B	R O U T	I N E =====================================================
; Check checksum
; -----------------------------------------------------------------------------------------

					lea		($1A4).w,a0	; Load Checksum Address 1A4 into A0
					move.l	(a0),d1
					addq.l	#1,d1
					movea.l	#$200,a0
					sub.l	a0,d1
					asr.l	#1,d1
					move.w	d1,d2
					subq.w	#1,d2
					swap	d1
					moveq	#0,d0

loc_234F0:
					add.w	(a0)+,d0
					dbf		d2,loc_234F0
					dbf		d1,loc_234F0
					nop
					nop
					nop
					nop
					move.b	#0,bytecode_flag
					cmp.w	($18E).w,d0
					beq.s	loc_23518
					move.b	#$FF,bytecode_flag

loc_23518:
					move.w	d0,(word_FF0106).l
					rts
