; =============== S U B	R O U T	I N E =======================================
; Password checks
; ---------------------------------------------------------------------------
					
	jsr	(EnableSHMode).l
	moveq	#0,d0
	move.w	d0,(vscroll_buffer).l
	move.w	d0,(hscroll_buffer).l
	lea	(loc_D192).l,a1
	jsr	(FindActorSlot).l
	bcc.w	loc_CF70
	rts
	
; ---------------------------------------------------------------------------

loc_CF70:
	move.b	#$80,6(a1)
	move.b	#$1D,8(a1)
	move.b	#3,9(a1)
	move.w	#$8C,$A(a1)
	move.w	#$C9,$E(a1)
	move.w	#3,$2A(a1)
	move.w	(current_password).l,$2C(a1)
	movea.l	a1,a0
	bsr.w	sub_CFB8
	bsr.w	sub_D096
	bsr.w	sub_D0FC
	lea	(loc_D3B4).l,a1
	jsr	(FindActorSlot).l
	rts

; =============== S U B	R O U T	I N E =======================================

sub_CFB8:
	move.w	#9,d0
	lea	(unk_D01A).l,a2

loc_CFC2:
	lea	(sub_D00C).l,a1
	jsr	(FindActorSlot).l
	bcs.w	loc_D006
	move.l	a0,$2E(a1)
	move.b	(a2)+,8(a1)
	move.b	(a2)+,$22(a1)
	move.b	(a2)+,9(a1)
	move.b	(a2)+,$28(a1)
	move.b	#$80,6(a1)
	move.w	d0,d2
	muls.w	#$1C,d2
	move.w	#$198,d1
	sub.w	d2,d1
	move.w	d1,$A(a1)
	move.w	#$D8,$E(a1)
	move.l	(a2)+,$32(a1)

loc_D006:
	dbf	d0,loc_CFC2
	rts

; =============== S U B	R O U T	I N E =======================================

sub_D00C:
	tst.b	$28(a0)
	bne.s	locret_D018
	jsr	(ActorAnimate).l

locret_D018:
	rts

; ---------------------------------------------------------------------------

unk_D01A:	
	dc.b   0 ; Image to use
	dc.b   0 ; Start Animation 
	dc.b   0
	dc.b   0
	dc.l unk_D072 ; Frame Animations
	
	dc.b   1
	dc.b   8
	dc.b   0
	dc.b   0
	dc.l unk_D072
	
	dc.b   5
	dc.b $10
	dc.b   0
	dc.b   0
	dc.l unk_D072
	
	dc.b   4
	dc.b $18
	dc.b   0
	dc.b   0
	dc.l unk_D072
	
	dc.b   3
	dc.b $40
	dc.b   0
	dc.b   0
	dc.l unk_D072
	
	dc.b   6
	dc.b   0
	dc.b   0
	dc.b   0
	dc.l unk_D06A
	
	dc.b $19
	dc.b   0
	dc.b   0
	dc.b   0
	dc.l unk_D088
	
	dc.b $1D
	dc.b   0
	dc.b   5
	dc.b   1
	dc.l unk_D06A
	
	dc.b $1D
	dc.b   0
	dc.b   4
	dc.b   1
	dc.l unk_D06A
	
	dc.b $1D
	dc.b   0
	dc.b   2
	dc.b   1
	dc.l unk_D06A
	
unk_D06A:	
	dc.b   8
	dc.b   0
	dc.b $FF
	dc.b   0
	dc.l unk_D06A
	
unk_D072:	
	dc.b   3
	dc.b   2
	dc.b   1
	dc.b   0
	dc.b   2
	dc.b   3
	dc.b   1
	dc.b   0
	dc.b   3
	dc.b   2
	dc.b   1
	dc.b   0
	dc.b   2
	dc.b   3
	dc.b $60
	dc.b   0
	dc.b $FF
	dc.b   0
	dc.l unk_D072
	
unk_D088:		
	dc.b  $C ; Pause
	dc.b  $E ; Sprite
	dc.b  $A
	dc.b $35
	dc.b  $C
	dc.b  $F
	dc.b  $A
	dc.b $36
	dc.b $FF
	dc.b   0
	dc.l unk_D088
	
	even

; =============== S U B	R O U T	I N E =======================================

sub_D096:
	move.w	#3,d0

loc_D09A:
	lea	(sub_D0DE).l,a1
	jsr	(FindActorSlot).l
	bcs.w	locret_D0DC
	move.l	a0,$2E(a1)
	move.b	#$1D,8(a1)
	move.b	#1,9(a1)
	move.b	#$80,6(a1)
	move.w	d0,d2
	lsl.w	#5,d2
	move.w	#$148,d1
	sub.w	d2,d1
	move.w	d1,$A(a1)
	move.w	#$120,$E(a1)
	move.w	d0,$26(a1)
	dbf	d0,loc_D09A

locret_D0DC:
	rts

; =============== S U B	R O U T	I N E =======================================


sub_D0DE:
	movea.l	$2E(a0),a1
	move.w	$2A(a1),d0
	sub.w	$26(a0),d0
	bne.s	loc_D0F4
	move.b	#0,9(a0)
	rts
	
; ---------------------------------------------------------------------------

loc_D0F4:
	move.b	#1,9(a0)
	rts

; =============== S U B	R O U T	I N E =======================================

sub_D0FC:
	move.w	#3,d0

loc_D100:
	lea	(sub_D13A).l,a1
	jsr	(FindActorSlot).l
	bcs.w	locret_D138
	move.l	a0,$2E(a1)
	move.w	d0,d2
	lsl.w	#5,d2
	move.w	#$150,d1
	sub.w	d2,d1
	move.w	d1,$A(a1)
	move.w	#$118,$E(a1)
	move.w	d0,$26(a1)
	move.l	#unk_D072,$32(a1)
	dbf	d0,loc_D100

locret_D138:
	rts

; =============== S U B	R O U T	I N E =======================================

sub_D13A:
	movea.l	$2E(a0),a1
	move.w	$2C(a1),d0
	move.w	$26(a0),d1
	lsl.w	#2,d1
	lsr.w	d1,d0
	andi.w	#$F,d0
	cmpi.b	#$F,d0
	beq.s	loc_D18A
	lea	(unk_D01A).l,a1
	lsl.w	#3,d0
	adda.w	d0,a1
	move.b	(a1),d0
	cmp.b	8(a0),d0
	beq.s	loc_D17E
	move.b	d0,8(a0)
	move.b	#0,9(a0)
	move.b	#0,$22(a0)
	adda.w	#4,a1
	move.l	(a1),$32(a0)

loc_D17E:
	move.b	#$80,6(a0)
	jmp	(ActorAnimate).l
	
; ---------------------------------------------------------------------------

loc_D18A:
	move.b	#0,6(a0)
	rts

; ---------------------------------------------------------------------------

loc_D192:
	move.w	#0,$26(a0)
	jsr	(ActorBookmark).l
	jsr	(GetCtrlData).l
	btst	#7,d0
	bne.w	loc_D282
	btst	#4,d0
	bne.w	loc_D35C
	andi.b	#$60,d0
	bne.w	loc_D21C
	move.b	(byte_FF110C).l,d0
	tst.b	(swap_controls).l
	beq.w	loc_D1D2
	move.b	(byte_FF1112).l,d0

loc_D1D2:
	btst	#3,d0
	bne.w	loc_D1E4
	btst	#2,d0
	bne.w	loc_D1F4
	rts
	
; ---------------------------------------------------------------------------

loc_D1E4:
	cmpi.w	#9,$26(a0)
	bcc.w	locret_D202
	addq.w	#1,$26(a0)
	bra.s	loc_D204
	
; ---------------------------------------------------------------------------

loc_D1F4:
	subq.w	#1,$26(a0)
	bcc.w	loc_D204
	move.w	#0,$26(a0)

locret_D202:
	rts
	
; ---------------------------------------------------------------------------

loc_D204:
	move.w	$26(a0),d0
	muls.w	#$1C,d0
	addi.w	#$8C,d0
	move.w	d0,$A(a0)
	move.b	#$42,d0
	bra.w	PlaySound_ChkPCM
	
; ---------------------------------------------------------------------------

loc_D21C:
	move.w	$26(a0),d0
	move.w	$2C(a0),d1
	move.w	$2A(a0),d2
	move.w	d0,d3
	subq.w	#7,d3
	bmi.s	loc_D242
	lsl.w	#2,d3
	movea.l	off_D236(pc,d3.w),a1
	jmp	(a1)
	
; ---------------------------------------------------------------------------

off_D236:	
	dc.l loc_D264
	dc.l loc_D26E
	dc.l loc_D282
	
; ---------------------------------------------------------------------------

loc_D242:
	tst.w	d2
	beq.s	loc_D24A
	subq.w	#1,$2A(a0)

loc_D24A:
	lsl.w	#2,d2
	ror.w	d2,d1
	andi.w	#$FFF0,d1
	or.w	d0,d1
	rol.w	d2,d1
	move.w	d1,$2C(a0)
	move.b	#$41,d0
	bsr.w	PlaySound_ChkPCM
	rts
	
; ---------------------------------------------------------------------------

loc_D264:
	cmpi.w	#3,d2
	beq.s	locret_D280
	addq.w	#1,d2
	bra.s	loc_D274
	
; ---------------------------------------------------------------------------

loc_D26E:
	tst.w	d2
	beq.s	locret_D280
	subq.w	#1,d2

loc_D274:
	move.w	d2,$2A(a0)
	move.b	#$41,d0
	bsr.w	PlaySound_ChkPCM

locret_D280:
	rts
	
; ---------------------------------------------------------------------------

loc_D282:
	move.w	$2C(a0),d0
	cmpi.w	#$FFFF,d0
	beq.w	loc_D394
	lea	(Passwords).l,a1
	adda.w	#$60,a1
	moveq	#$2F,d1

loc_D29A:
	cmp.w	-(a1),d0
	beq.s	loc_D2AC
	dbf	d1,loc_D29A
	move.b	#$46,d0
	bsr.w	PlaySound_ChkPCM
	rts
; ---------------------------------------------------------------------------

loc_D2AC:
	move.w	d0,(current_password).l
	move.w	d1,d0
	andi.b	#3,d0
	eori.b	#3,d0
	move.b	d0,(difficulty).l
	lsr.w	#2,d1
	move.w	d1,d0
	addq.w	#4,d1
	move.b	d1,(level).l
	lea	(opponents_defeated).l,a2
	lea	(unk_D34E).l,a1
	clr.w	d1

loc_D2DC:
	move.b	(a1)+,d1
	move.b	#$FF,(a2,d1.w)
	dbf	d0,loc_D2DC
	move.b	#SFX_5D,d0
	bsr.w	PlaySound_ChkPCM
	bsr.w	sub_DF74
	lea	(locret_D348).l,a1
	jsr	(FindActorSlot).l
	bcs.w	loc_D334
	clr.l	d0
	move.b	(difficulty).l,d0
	move.b	#$1D,8(a1)
	move.b	d0,9(a1)
	addq.b	#6,9(a1)
	move.b	#$80,6(a1)
	move.b	unk_D34A(pc,d0.w),d0
	move.w	#$80,d1
	add.w	d0,d1
	move.w	d1,$A(a1)
	move.w	#$140,$E(a1) ; Password Level Text - Y Position (All)

loc_D334:
	moveq	#$5A,d0
	jsr	(ActorBookmark_SetDelay).l
	jsr	(ActorBookmark_Ctrl).l
	clr.b	(bytecode_disabled).l

locret_D348:
	rts
	
; ---------------------------------------------------------------------------

unk_D34A:	
	dc.b 	$68 ; Password Level Text - X Position (Hardest)
	dc.b 	$80 ; Password Level Text - X Position (Hard)
	dc.b 	$70 ; Password Level Text - X Position (Normal)
	dc.b 	$80 ; Password Level Text - X Position (Easy)
	
; ---------------------------------------------------------------------------
	
unk_D34E:	 	; Opponents Defeated
	dc.b	OPP_ARMS
	dc.b   	OPP_FRANKLY
	dc.b  	OPP_HUMPTY
	dc.b   	OPP_COCONUTS
	dc.b   	OPP_DAVY
	dc.b  	OPP_SKWEEL
	dc.b   	OPP_DYNAMIGHT
	dc.b   	OPP_GROUNDER
	dc.b   	OPP_SPIKE
	dc.b   	OPP_SIR_FFUZZY
	dc.b  	OPP_DRAGON
	dc.b  	OPP_SCRATCH
	dc.b  	OPP_ROBOTNIK
	dc.b   	0
	
; ---------------------------------------------------------------------------

loc_D35C:
	move.w	$2C(a0),d0
	cmpi.w	#$FFFF,d0
	beq.s	loc_D394
	move.w	$2A(a0),d1
	cmpi.w	#3,d1
	beq.s	loc_D374
	addq.w	#1,$2A(a0)

loc_D374:
	move.w	#$F,d2
	lsl.w	#2,d1
	lsl.w	d1,d2
	move.w	d0,d1
	and.w	d2,d1
	cmp.w	d2,d1
	beq.s	locret_D392
	or.w	d2,d0
	move.w	d0,$2C(a0)
	move.b	#SFX_MENU_SELECT,d0
	bsr.w	PlaySound_ChkPCM

locret_D392:
	rts
	
; ---------------------------------------------------------------------------

loc_D394:
	move.b	#SFX_49,d0
	bsr.w	PlaySound_ChkPCM
	move.b	$27(a0),(level).l
	move.b	#6,(bytecode_flag).l
	clr.b	(bytecode_disabled).l
	rts
	
; ---------------------------------------------------------------------------

loc_D3B4:
	jsr	(ActorBookmark).l
	tst.b	$28(a0)
	bne.w	loc_D40A
	move.b	#5,$28(a0)
	clr.w	d0
	move.b	$29(a0),d0
	addq.b	#1,d0
	cmpi.b	#$F,d0
	bne.s	loc_D3DA
	move.b	#0,d0

loc_D3DA:
	move.b	d0,$29(a0)
	mulu.w	#6,d0
	lea	(word_D456).l,a1
	adda.w	d0,a1
	move.w	(a1)+,(palette_buffer+$E).l
	move.w	(a1)+,(palette_buffer+$1A).l
	move.w	(a1)+,(palette_buffer+$1C).l
	moveq	#0,d0
	lea	(palette_buffer).l,a2
	jsr	(LoadPalette).l

loc_D40A:
	subq.b	#1,$28(a0)
	tst.b	$2A(a0)
	bne.w	loc_D450
	move.b	#2,$2A(a0)
	clr.w	d0
	move.b	$2B(a0),d0
	addq.b	#1,d0
	cmpi.b	#$11,d0
	bne.s	loc_D42E
	move.b	#0,d0

loc_D42E:
	move.b	d0,$2B(a0)
	add.w	d0,d0
	lea	(word_D4B0).l,a1
	adda.w	d0,a1
	move.w	(a1),(palette_buffer+$2E).l
	moveq	#1,d0
	lea	((palette_buffer+$20)).l,a2
	jsr	(LoadPalette).l

loc_D450:
	subq.b	#1,$2A(a0)
	rts
	
; ---------------------------------------------------------------------------

word_D456:	
	incbin	"data/palettes/array/password/highlighter.bin"	
	even

word_D4B0:
	incbin	"data/palettes/array/password/cursor.bin"	
	even
	
; ---------------------------------------------------------------------------