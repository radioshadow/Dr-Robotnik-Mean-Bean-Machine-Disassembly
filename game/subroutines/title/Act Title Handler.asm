; =============== S U B	R O U T	I N E =======================================
; Act Title Handler
; ---------------------------------------------------------------------------
					
; FUNCTION CHUNK AT 0000ECE8 SIZE 0000004A BYTES

	move.w	#$FFFF,(sound_test_enabled).l
	bsr.w	CheckIfJapan
	move.b	(p1_ctrl_press).l,d0
	or.b	(p2_ctrl_press).l,d0
	andi.b	#$F0,d0
	beq.s	.End
	tst.b	(word_FF1126+1).l
	bmi.w	.loc_E142
	bne.s	.End
	move.w	#1,(word_FF1126).l
	lea	(.FadeToBlack).l,a1
	jsr	(FindActorSlot).l
	rts
; ---------------------------------------------------------------------------

.loc_E142:
	btst	#7,d0
	beq.w	.End
	jsr	(CheckCoinInserted).l
	bcc.w	loc_ECE8

.End:
	rts
; ---------------------------------------------------------------------------

.FadeToBlack:
	moveq	#3,d3

.LineFade:
	lea	(Palettes).l,a2
	move.w	d3,d0
	moveq	#0,d1
	jsr	(FadeToPalette).l
	dbf	d3,.LineFade
	jsr	(ActorBookmark).l
	jsr	(CheckPaletteFade).l
	bcc.w	.SetupScr
	rts
; ---------------------------------------------------------------------------

.SetupScr:
	move.w	#2,(word_FF1126).l
	move.w	#$160,(hscroll_buffer).l
	move.w	#0,(vscroll_buffer).l
	bsr.w	sub_E202
	move.w	#$1E,d0
	jsr	(ActorBookmark_SetDelay).l
	jsr	(ActorBookmark).l
	moveq	#3,d3

.FadeToPal:
	lea	(Palettes).l,a2
	move.l	d3,d0
	move.l	d0,d2
	addi.w	#(Pal_Title1-Palettes)>>5,d2
	lsl.w	#5,d2
	adda.l	d2,a2
	moveq	#0,d1
	jsr	(FadeToPalette).l
	dbf	d3,.FadeToPal
	jsr	(ActorBookmark).l
	jsr	(CheckPaletteFade).l
	bcc.w	.Delay
	rts
; ---------------------------------------------------------------------------

.Delay:
	move.w	#3,(word_FF1126).l
	move.w	#$3C,d0
	jsr	(ActorBookmark_SetDelay).l
	jsr	(ActorBookmark).l
	move.w	#$FFFF,(word_FF1126).l
	jmp	(ActorDeleteSelf).l
; End of function ActTitleHandler


; =============== S U B	R O U T	I N E =======================================


sub_E202:
	lea	(off_E314).l,a2
	moveq	#7,d0
	moveq	#1,d2

loc_E20C:
	lea	(sub_E27E).l,a1
	jsr	(FindActorSlot).l
	bcs.w	locret_E242
	move.l	(a2)+,$32(a1)
	move.w	(a2)+,$A(a1)
	move.w	(a2)+,$E(a1)
	move.b	#$80,6(a1)
	move.b	#$24,8(a1)
	move.b	d2,$22(a1)
	addq.w	#4,d2
	move.w	d0,$26(a1)
	dbf	d0,loc_E20C

locret_E242:
	rts
; End of function sub_E202

; ---------------------------------------------------------------------------
; START	OF FUNCTION CHUNK FOR sub_E678

loc_E244:
	cmpi.w	#2,(word_FF1126).l
	beq.w	loc_E6A8
	bsr.w	sub_E2CE
	bcs.w	loc_E2B2
	jsr	(ActorBookmark).l
	move.w	$2A(a0),d0
	cmpi.w	#$B,d0
	bne.w	loc_E294
	move.w	#0,$2A(a0)
	move.l	#loc_E244,2(a0)
	jmp	(ActorAnimate).l
; END OF FUNCTION CHUNK	FOR sub_E678

; =============== S U B	R O U T	I N E =======================================


sub_E27E:

; FUNCTION CHUNK AT 0000E2A4 SIZE 0000000E BYTES

	bsr.w	sub_E2CE
	bcs.s	loc_E2B2
	jsr	(ActorBookmark).l
	move.w	$2A(a0),d0
	cmpi.w	#$B,d0
	beq.s	loc_E2A4
; End of function sub_E27E

; START	OF FUNCTION CHUNK FOR sub_E678

loc_E294:
	add.w	d0,d0
	move.w	unk_E2B8(pc,d0.w),d0
	add.w	d0,$E(a0)
	addq.w	#1,$2A(a0)
	bra.s	loc_E2B2
; END OF FUNCTION CHUNK	FOR sub_E678
; ---------------------------------------------------------------------------
; START	OF FUNCTION CHUNK FOR sub_E27E

loc_E2A4:
	move.w	#0,$2A(a0)
	move.l	#sub_E27E,2(a0)
; END OF FUNCTION CHUNK	FOR sub_E27E
; START	OF FUNCTION CHUNK FOR sub_E678

loc_E2B2:
	jmp	(ActorAnimate).l
; END OF FUNCTION CHUNK	FOR sub_E678
; ---------------------------------------------------------------------------
unk_E2B8:	dc.b $FF
	dc.b $F0
	dc.b $FF
	dc.b $F8
	dc.b $FF
	dc.b $FC
	dc.b $FF
	dc.b $FE
	dc.b $FF
	dc.b $FF
	dc.b   0
	dc.b   0
	dc.b   0
	dc.b   1
	dc.b   0
	dc.b   2
	dc.b   0
	dc.b   4
	dc.b   0
	dc.b   8
	dc.b   0
	dc.b $10

; =============== S U B	R O U T	I N E =======================================


sub_E2CE:
	move.b	(p1_ctrl_press).l,d1
	lsl.w	#8,d1
	move.b	(p2_ctrl_press).l,d1
	move.w	$26(a0),d0
	add.w	d0,d0
	move.w	unk_E304(pc,d0.w),d0
	and.w	d0,d1
	beq.s	loc_E2FE
	move.w	$26(a0),d0
	addi.b	#$4C,d0
	jsr	(PlaySound_ChkPCM).l
	andi	#$FFFE,sr
	rts
; ---------------------------------------------------------------------------

loc_E2FE:
	ori	#1,sr
	rts
; End of function sub_E2CE

; ---------------------------------------------------------------------------
unk_E304:	dc.b  $F
	dc.b   0
	dc.b $40
	dc.b   0
	dc.b $10
	dc.b   0
	dc.b $20
	dc.b   0
	dc.b   0
	dc.b  $F
	dc.b   0
	dc.b $40
	dc.b   0
	dc.b $10
	dc.b   0
	dc.b $20
off_E314:	dc.l unk_E786
	dc.w $16C
	dc.w $BE
	dc.l unk_E76A
	dc.w $154
	dc.w $C3
	dc.l unk_E74E
	dc.w $13E
	dc.w $B9
	dc.l unk_E7A2
	dc.w $127
	dc.w $C4
	dc.l unk_E786
	dc.w $10B
	dc.w $C9
	dc.l unk_E76A
	dc.w $F3
	dc.w $BD
	dc.l unk_E74E
	dc.w $DD
	dc.w $CA
	dc.l unk_E732
	dc.w $C3
	dc.w $C2
; ---------------------------------------------------------------------------

ActTitleMachineText:
	cmpi.w	#2,(word_FF1126).l
	beq.w	loc_E4E2
	movea.l	$2E(a0),a1
	cmpi.w	#$1A,$28(a1)
	beq.s	loc_E36E
	rts
; ---------------------------------------------------------------------------

loc_E36E:
	move.b	#$1A,d0
	jsr	(JmpTo_PlaySound).l
	move.b	#1,(word_FF1124).l
	jsr	(ActorBookmark).l
	jsr	(Random).l
	andi.b	#$1F,d0
	move.b	d0,aField26(a0)
	move.b	#6,aField28(a0)
	move.b	#6,aField29(a0)
	jsr	(ActorBookmark).l
	cmpi.w	#2,(word_FF1126).l
	beq.w	loc_E4E2
	cmpi.w	#$160,(hscroll_buffer).l
	beq.w	loc_E416
	addq.w	#1,(hscroll_buffer).l

loc_E3C4:
	tst.b	aField26(a0)
	beq.s	loc_E3D2
	subq.b	#1,aField26(a0)
	bra.w	sub_E40E
; ---------------------------------------------------------------------------

loc_E3D2:
	tst.b	aField28(a0)
	beq.s	loc_E3E4
	subq.b	#1,aField28(a0)
	addq.w	#2,(vscroll_buffer).l
	bra.s	sub_E40E
; ---------------------------------------------------------------------------

loc_E3E4:
	tst.b	aField29(a0)
	beq.s	loc_E3F6
	subq.b	#1,aField29(a0)
	subq.w	#2,(vscroll_buffer).l
	bra.s	sub_E40E
; ---------------------------------------------------------------------------

loc_E3F6:
	jsr	(Random).l
	andi.w	#$707,d0
	move.b	d0,aField26(a0)
	lsr.w	#8,d0
	move.b	d0,aField28(a0)
	move.b	d0,aField29(a0)

; =============== S U B	R O U T	I N E =======================================


sub_E40E:
	move.w	#0,d0
	bra.w	sub_EBF8
; End of function sub_E40E

; ---------------------------------------------------------------------------

loc_E416:
	tst.w	(vscroll_buffer).l
	bne.w	loc_E3C4
	bsr.s	sub_E40E
	move.l	#unk_E5FA,$32(a0)
	move.w	#$3C,d0
	jsr	(ActorBookmark_SetDelay).l
	cmpi.w	#2,(word_FF1126).l
	beq.w	loc_E4DC
	jsr	(ActorBookmark).l
	cmpi.w	#2,(word_FF1126).l
	beq.w	loc_E4E2
	move.b	#1,$2C(a0)
	jsr	(ActorAnimate).l
	bcs.s	loc_E462
	rts
; ---------------------------------------------------------------------------

loc_E462: ; Beans coming out of the machine
	move.l	#unk_E606,$32(a0)
	move.b	#0,$22(a0)
	jsr	(ActorBookmark).l
	cmpi.w	#2,(word_FF1126).l
	beq.w	loc_E4E2
	jsr	(ActorAnimate).l
	cmpi.b	#$3F,9(a0)
	bne.s	locret_E4B2
	cmpi.b	#3,$22(a0)
	bne.s	locret_E4B2
	bsr.w	sub_E61E
	move.b	#$57,d0
	jsr	(PlaySound_ChkPCM).l
	addq.w	#1,$2A(a0)
	cmpi.w	#8,$2A(a0) ; Outputs 8 Beans
	beq.s	loc_E4B4

locret_E4B2:
	rts
; ---------------------------------------------------------------------------

loc_E4B4:
	move.l	#unk_E612,$32(a0)
	move.b	#0,$22(a0)
	jsr	(ActorBookmark).l
	cmpi.w	#2,(word_FF1126).l
	beq.s	loc_E4E2
	jsr	(ActorAnimate).l
	bcs.s	loc_E4E2
	rts
; ---------------------------------------------------------------------------

loc_E4DC:
	move.w	#0,$24(a0)

loc_E4E2:
	tst.w	(word_FF1126).l
	bne.s	loc_E4F2
	move.w	#4,(word_FF1126).l

loc_E4F2:
	tst.b	(word_FF1124).l
	bne.s	loc_E504
	move.b	#$1A,d0
	jsr	(JmpTo_PlaySound).l

loc_E504:
	move.w	#0,d0
	bsr.w	sub_EBF8
	move.b	#$39,9(a0)
	move.b	#$80,6(a0)
	move.b	#2,$2C(a0)
	lea	(locret_E5B6).l,a1
	jsr	(FindActorSlot).l
	bcs.w	loc_E54C
	move.b	#$80,6(a1)
	move.w	#$197,$A(a1)
	move.w	#$100,$E(a1)
	move.b	#$24,8(a1)
	move.b	#$48,9(a1)

loc_E54C:			
	lea	(Str_SegaCpy).l,a1  	; Text
	move.w	#$F918,d5			; Address
	bsr.w	sub_EC6A			; Load
	
	lea	(Str_CompileCpy).l,a1	; Text
	move.w	#$FA18,d5			; Address
	bsr.w	sub_EC6A			; Load
	
	move.w	#$2B2,$28(a0)
	jsr	(ActorBookmark).l
	cmpi.w	#$258,$28(a0)
	bne.s	loc_E584
	move.w	#$FFFF,(word_FF1126).l

loc_E584:
	subq.w	#1,$28(a0)
	beq.w	loc_E5B8
	addq.b	#1,$26(a0)
	move.b	$26(a0),d0
	move.b	d0,d1
	andi.b	#$F,d0
	bne.s	locret_E5B6
	
	lea	(Str_PressStart).l,a1	; Text
	move.w	#$D6BA,d5			; Address
	
	andi.b	#$10,d1
	beq.s	loc_E5B2
	bsr.w	sub_EC98
	bra.s	locret_E5B6
; ---------------------------------------------------------------------------

loc_E5B2:
	bsr.w	sub_EC6A			; Load

locret_E5B6:
	rts
; ---------------------------------------------------------------------------

loc_E5B8:
	move.b	#1,(bytecode_flag).l
	clr.b	(bytecode_disabled).l
	rts
; ---------------------------------------------------------------------------

Str_PressStart:	
	include "data/text/Title/Press Start.asm"
	
Str_CompileCpy:
	include "data/text/Title/Compile.asm"
	
Str_SegaCpy:
	include "data/text/Title/Sega.asm"
	
; ---------------------------------------------------------------------------
	
unk_E5FA:	
	dc.b   5
	dc.b $39
	dc.b   5
	dc.b $3A
	dc.b   5
	dc.b $3B
	dc.b $28
	dc.b $3C
	dc.b $FE
	dc.b   0
	
unk_E604:	
	dc.b $1E
	dc.b $3C
	
unk_E606:	
	dc.b   4
	dc.b $3D
	dc.b   8
	dc.b $3E
	dc.b   4
	dc.b $3F
	dc.b $FF
	dc.b   0
	dc.l unk_E604
	
unk_E612:	
	dc.b   3
	dc.b $3F
	dc.b $78
	dc.b $3C
	dc.b   5
	dc.b $3B
	dc.b   5
	dc.b $3A
	dc.b $28
	dc.b $39
	dc.b $FE
	dc.b   0
	
	even

; =============== S U B	R O U T	I N E =======================================


sub_E61E:
	lea	(sub_E678).l,a1
	jsr	(FindActorSlot).l
	bcs.w	locret_E676
	move.w	$2A(a0),d0
	move.w	d0,$26(a1)
	lsl.w	#4,d0
	lea	(off_E6AE).l,a2
	adda.w	d0,a2
	move.w	#$100,$20(a1)
	move.b	#$BF,6(a1)
	move.w	#$180,$A(a1)
	move.w	#$D0,$E(a1)
	move.l	(a2)+,$32(a1)
	move.l	(a2)+,$12(a1)
	move.l	(a2)+,$16(a1)
	move.b	#$24,8(a1)
	move.b	(a2)+,9(a1)
	move.b	(a2)+,$1C(a1)
	move.w	(a2),$28(a1)

locret_E676:
	rts
; End of function sub_E61E


; =============== S U B	R O U T	I N E =======================================


sub_E678:

; FUNCTION CHUNK AT 0000E244 SIZE 0000003A BYTES
; FUNCTION CHUNK AT 0000E294 SIZE 00000010 BYTES
; FUNCTION CHUNK AT 0000E2B2 SIZE 00000006 BYTES

	cmpi.w	#2,(word_FF1126).l
	beq.s	loc_E6A8
	jsr	(sub_3810).l
	move.w	$28(a0),d0
	cmp.w	$A(a0),d0
	blt.s	locret_E6A6
	jsr	(ActorBookmark).l
	cmpi.w	#2,(word_FF1126).l
	beq.s	loc_E6A8
	bra.w	loc_E244
; ---------------------------------------------------------------------------

locret_E6A6:
	rts
; ---------------------------------------------------------------------------

loc_E6A8:
	jmp	(ActorDeleteSelf).l
; End of function sub_E678

; ---------------------------------------------------------------------------
off_E6AE:	dc.l unk_E72E
	dc.l $FFFD0000
	dc.l $FFF9F800
	dc.b $C
	dc.b $30
	dc.w $C3
	dc.l unk_E74A
	dc.l $FFFD2800
	dc.l $FFFA8C00
	dc.b 6
	dc.b $31
	dc.w $DD
	dc.l unk_E766
	dc.l $FFFD4000
	dc.l $FFF97A00
	dc.b $36
	dc.b $3F
	dc.w $F3
	dc.l unk_E782
	dc.l $FFFC4000
	dc.l $FFFC7600
	dc.b $25
	dc.b $39
	dc.w $10B
	dc.l unk_E79E
	dc.l $FFFE4E00
	dc.l $FFF88200
	dc.b $C
	dc.b $49
	dc.w $127
	dc.l unk_E74A
	dc.l $FFFEEE00
	dc.l $FFF48000
	dc.b 6
	dc.b $5F
	dc.w $13E
	dc.l unk_E766
	dc.l $FFFDEE00
	dc.l $FFFDD200
	dc.b $36
	dc.b $28
	dc.w $154
	dc.l unk_E782
	dc.l $FFFFA000
	dc.l $FFFAC800
	dc.b $25
	dc.b $32
	dc.w $16C
unk_E72E:	dc.b   5
	dc.b  $D
	dc.b   5
	dc.b  $E
unk_E732:	dc.b   4
	dc.b $15
	dc.b   4
	dc.b $16
	dc.b   2
	dc.b $15
	dc.b   3
	dc.b $17
	dc.b   2
	dc.b $15
	dc.b   4
	dc.b $16
	dc.b   2
	dc.b $15
	dc.b   3
	dc.b $17
	dc.b $28
	dc.b $15
	dc.b $FF
	dc.b   0
	dc.l unk_E732
unk_E74A:	dc.b   5
	dc.b   7
	dc.b   5
	dc.b   8
unk_E74E:	dc.b   4
	dc.b   9
	dc.b   4
	dc.b  $A
	dc.b   2
	dc.b   9
	dc.b   3
	dc.b  $B
	dc.b   2
	dc.b   9
	dc.b   4
	dc.b  $A
	dc.b   2
	dc.b   9
	dc.b   3
	dc.b  $B
	dc.b $28
	dc.b   9
	dc.b $FF
	dc.b   0
	dc.l unk_E74E
unk_E766:	dc.b   5
	dc.b $37
	dc.b   5
	dc.b $38
unk_E76A:	dc.b   4
	dc.b   0
	dc.b   4
	dc.b   1
	dc.b   2
	dc.b   0
	dc.b   3
	dc.b   2
	dc.b   2
	dc.b   0
	dc.b   4
	dc.b   1
	dc.b   2
	dc.b   0
	dc.b   3
	dc.b   2
	dc.b $28
	dc.b   0
	dc.b $FF
	dc.b   0
	dc.l unk_E76A
unk_E782:	dc.b   5
	dc.b $26
	dc.b   5
	dc.b $27
unk_E786:	dc.b   4
	dc.b $1C
	dc.b   4
	dc.b $1D
	dc.b   2
	dc.b $1C
	dc.b   3
	dc.b $1E
	dc.b   2
	dc.b $1C
	dc.b   4
	dc.b $1D
	dc.b   2
	dc.b $1C
	dc.b   3
	dc.b $1E
	dc.b $28
	dc.b $1C
	dc.b $FF
	dc.b   0
	dc.l unk_E786
unk_E79E:	dc.b   5
	dc.b  $D
	dc.b   5
	dc.b  $E
unk_E7A2:	dc.b   4
	dc.b   3
	dc.b   4
	dc.b   4
	dc.b   2
	dc.b   3
	dc.b   3
	dc.b   5
	dc.b   2
	dc.b   3
	dc.b   4
	dc.b   4
	dc.b   2
	dc.b   3
	dc.b   3
	dc.b   5
	dc.b $28
	dc.b   3
	dc.b $FF
	dc.b   0
	dc.l unk_E7A2
; ---------------------------------------------------------------------------

ActTitleHPiston:
	jsr	(ActorAnimate).l
	movea.l	$2E(a0),a1
	tst.b	$2C(a1)
	bne.s	loc_E7D4
	move.w	#$FFA0,d0
	jmp	(sub_EBF8).l
; ---------------------------------------------------------------------------

loc_E7D4:
	move.w	#$FFA0,d0
	bsr.w	sub_EBF8
	cmpi.b	#$1F,9(a0)
	bne.s	locret_E7EA
	jsr	(ActorBookmark).l

locret_E7EA:
	rts
; ---------------------------------------------------------------------------
Anim_TitleHPiston:dc.b	$C
	dc.b $1F
	dc.b   5
	dc.b $20
	dc.b   5
	dc.b $21
	dc.b  $B
	dc.b $22
	dc.b   3
	dc.b $23
	dc.b   5
	dc.b $24
	dc.b $FF
	dc.b   0
	dc.l Anim_TitleHPiston
; ---------------------------------------------------------------------------

ActTitleHLeftMeter:
	jsr	(ActorAnimate).l
	movea.l	$2E(a0),a1
	tst.b	$2C(a1)
	bne.s	loc_E818
	move.w	#$FFB0,d0
	jmp	(sub_EBF8).l
; ---------------------------------------------------------------------------

loc_E818:
	move.w	#$FFB0,d0
	bsr.w	sub_EBF8
	cmpi.b	#$12,9(a0)
	bne.s	locret_E82E
	jsr	(ActorBookmark).l

locret_E82E:
	rts
; ---------------------------------------------------------------------------
Anim_TitleHLeftMeter:dc.b  $C
	dc.b $12
	dc.b   5
	dc.b $13
	dc.b   5
	dc.b $14
	dc.b  $F
	dc.b $11
	dc.b   5
	dc.b $12
	dc.b $FF
	dc.b   0
	dc.l Anim_TitleHLeftMeter
; ---------------------------------------------------------------------------

ActTitleHRightMeters:
	jsr	(ActorAnimate).l
	move.w	#$FFC0,d0
	jmp	(sub_EBF8).l
; ---------------------------------------------------------------------------
Anim_TitleHRightMeters:dc.b   5
	dc.b $18
	dc.b   5
	dc.b $19
	dc.b   5
	dc.b $1A
	dc.b   5
	dc.b $1B
	dc.b $FF
	dc.b   0
	dc.l Anim_TitleHRightMeters
; ---------------------------------------------------------------------------

ActTitleHSiren:
	jsr	(ActorAnimate).l
	move.w	#$FFC3,d0
	jmp	(sub_EBF8).l
; ---------------------------------------------------------------------------
Anim_TitleHSiren:dc.b	3
	dc.b $28
	dc.b   3
	dc.b $29
	dc.b   3
	dc.b $2A
	dc.b   3
	dc.b $2B
	dc.b   3
	dc.b $2C
	dc.b  $C
	dc.b $2D
	dc.b $FF
	dc.b   0
	dc.l Anim_TitleHSiren
; ---------------------------------------------------------------------------

ActTitleESteam1:
	move.w	#$2F,$28(a0)
	bra.s	loc_E894
; ---------------------------------------------------------------------------

ActTitleESteam2:
	move.w	#$35,$28(a0)
	move.b	#$14,$2A(a0)

loc_E894:
	jsr	(ActorBookmark).l
	move.w	$28(a0),d0
	bsr.w	sub_EBF8
	cmpi.w	#1,(word_FF1126).l
	beq.s	loc_E8CA
	jsr	(ActorAnimate).l
	movea.l	$2E(a0),a1
	tst.b	$2C(a1)
	bne.s	loc_E8DE
	tst.b	9(a0)
	bne.s	locret_E8C8
	move.b	#0,6(a0)

locret_E8C8:
	rts
; ---------------------------------------------------------------------------

loc_E8CA:
	move.b	#0,6(a0)
	move.b	#0,9(a0)
	move.l	#Anim_TitleESteam2,$32(a0)

loc_E8DE:
	tst.b	9(a0)
	bne.s	locret_E924
	move.b	#0,6(a0)
	jsr	(ActorBookmark).l
	movea.l	$2E(a0),a1
	cmpi.b	#2,$2C(a1)
	bne.s	locret_E924
	move.b	$2A(a0),d0
	move.b	d0,$22(a0)
	jsr	(ActorBookmark).l
	jsr	(ActorAnimate).l
	move.w	$28(a0),d0
	bsr.w	sub_EBF8
	tst.b	9(a0)
	bne.s	locret_E924
	move.b	#0,6(a0)

locret_E924:
	rts
; ---------------------------------------------------------------------------
Anim_TitleESteam1:dc.b	 5
	dc.b $2E
	dc.b   5
	dc.b $2F
	dc.b   5
	dc.b $30
	dc.b   5
	dc.b $31
	dc.b   5
	dc.b $32
Anim_TitleESteam2:dc.b $14
	dc.b   0
	dc.b $FF
	dc.b   0
	dc.l Anim_TitleESteam1
; ---------------------------------------------------------------------------

ActTitleCParticles:
	move.w	#1,$26(a0)
	jsr	(ActorBookmark).l
	movea.l	$2E(a0),a1
	tst.b	$2C(a1)
	bne.w	loc_E9E0
	move.w	#$FF9F,d0
	bsr.w	sub_EBF8
	move.b	#0,6(a0)
	subq.w	#1,$26(a0)
	bpl.s	locret_E9BE
	jsr	(Random).l
	andi.w	#$F,d0
	addi.w	#$F,d0
	move.w	d0,$26(a0)
	lea	(loc_E9C0).l,a1
	jsr	(FindActorSlot).l
	bcs.s	locret_E9BE
	move.w	$A(a0),$A(a1)
	move.w	$E(a0),$E(a1)
	move.w	#$3C,$26(a1)
	move.b	#$33,6(a1)
	move.b	#$24,8(a1)
	move.b	#$40,9(a1)
	move.b	#2,$22(a1)
	move.l	#unk_E9E6,$32(a1)
	move.l	#$FFFF8000,$16(a1)

locret_E9BE:
	rts
; ---------------------------------------------------------------------------

loc_E9C0:
	move.w	#$FF9F,d0
	bsr.w	sub_EBF8
	ori.b	#$3F,6(a0)
	jsr	(sub_3810).l
	jsr	(ActorAnimate).l
	subq.w	#1,$26(a0)
	bpl.s	locret_E9BE

loc_E9E0:
	jmp	(ActorDeleteSelf).l
; ---------------------------------------------------------------------------
unk_E9E6:	dc.b   2
	dc.b $40
	dc.b   3
	dc.b $41
	dc.b   2
	dc.b $42
	dc.b   3
	dc.b $43
	dc.b   2
	dc.b $44
	dc.b   3
	dc.b $45
	dc.b   2
	dc.b $46
	dc.b   3
	dc.b $47
	dc.b $FF
	dc.b   0
	dc.l unk_E9E6
; ---------------------------------------------------------------------------

ActTitleALight:
	move.b	#$10,9(a0)
	move.w	#$A,d0
	jsr	(ActorBookmark_SetDelay).l
	move.w	#$FF78,d0
	bsr.w	sub_EBF8
	jsr	(ActorBookmark).l
	tst.w	(word_FF1126).l
	ble.s	loc_EA36
	cmpi.w	#3,(word_FF1126).l
	beq.s	loc_EA36
	move.w	#$FF78,d0
	bsr.w	sub_EBF8
	rts
; ---------------------------------------------------------------------------

loc_EA36:
	move.w	#$FF78,d0
	bsr.w	sub_EBF8
	tst.b	$22(a0)
	beq.s	loc_EA4A
	subq.b	#1,$22(a0)
	rts
; ---------------------------------------------------------------------------

loc_EA4A:
	move.w	$26(a0),d0
	addq.b	#1,d0
	cmpi.b	#$C,d0
	blt.s	loc_EA5A
	move.b	#0,d0

loc_EA5A:
	move.w	d0,$26(a0)
	move.b	unk_EA98(pc,d0.w),d1
	move.b	d1,$22(a0)
	lsl.w	#3,d0
	lea	(unk_EAA4).l,a1
	adda.w	d0,a1
	move.w	(a1)+,(palette_buffer+$36).l
	move.w	(a1)+,(palette_buffer+$38).l
	move.w	(a1)+,(palette_buffer+$3A).l
	move.w	(a1),(palette_buffer+$3C).l
	move.b	#1,d0
	lea	((palette_buffer+$20)).l,a2
	jmp	(LoadPalette).l
; ---------------------------------------------------------------------------
unk_EA98:	dc.b  $A
	dc.b   4
	dc.b   4
	dc.b   4
	dc.b   4
	dc.b   4
	dc.b  $A
	dc.b   4
	dc.b   4
	dc.b   4
	dc.b   4
	dc.b   4
unk_EAA4:	dc.b   0
	dc.b $22
	dc.b   0
	dc.b $24
	dc.b   0
	dc.b $24
	dc.b   0
	dc.b $24
	dc.b   0
	dc.b $24
	dc.b   0
	dc.b $26
	dc.b   0
	dc.b $48
	dc.b   0
	dc.b $6A
	dc.b   2
	dc.b $48
	dc.b   0
	dc.b $4A
	dc.b   2
	dc.b $6A
	dc.b   2
	dc.b $8C
	dc.b   2
	dc.b $48
	dc.b   0
	dc.b $6C
	dc.b   2
	dc.b $AC
	dc.b   4
	dc.b $CE
	dc.b   4
	dc.b $6A
	dc.b   2
	dc.b $8E
	dc.b   4
	dc.b $CE
	dc.b   8
	dc.b $CE
	dc.b   6
	dc.b $8C
	dc.b   4
	dc.b $AE
	dc.b   6
	dc.b $CE
	dc.b   8
	dc.b $EE
	dc.b   8
	dc.b $CE
	dc.b   8
	dc.b $EE
	dc.b  $A
	dc.b $EE
	dc.b  $C
	dc.b $EE
	dc.b   6
	dc.b $8C
	dc.b   4
	dc.b $AE
	dc.b   6
	dc.b $CE
	dc.b   8
	dc.b $EE
	dc.b   4
	dc.b $6A
	dc.b   2
	dc.b $8E
	dc.b   4
	dc.b $CE
	dc.b   8
	dc.b $CE
	dc.b   2
	dc.b $48
	dc.b   0
	dc.b $6C
	dc.b   2
	dc.b $AC
	dc.b   4
	dc.b $CE
	dc.b   2
	dc.b $48
	dc.b   0
	dc.b $4A
	dc.b   2
	dc.b $6A
	dc.b   2
	dc.b $8C
	dc.b   0
	dc.b $24
	dc.b   0
	dc.b $26
	dc.b   0
	dc.b $48
	dc.b   0
	dc.b $6A
; ---------------------------------------------------------------------------

ActTitleILights:
	move.b	#$F,9(a0)
	move.w	#$A,d0
	jsr	(ActorBookmark_SetDelay).l
	move.w	#$FFCF,d0
	bsr.w	sub_EBF8
	jsr	(ActorBookmark).l
	tst.w	(word_FF1126).l
	ble.s	loc_EB3E
	cmpi.w	#3,(word_FF1126).l
	beq.s	loc_EB3E
	move.w	#$FFCF,d0
	bsr.w	sub_EBF8
	rts
; ---------------------------------------------------------------------------

loc_EB3E:
	move.w	#$FFCF,d0
	bsr.w	sub_EBF8
	tst.b	$22(a0)
	beq.s	loc_EB52
	subq.b	#1,$22(a0)
	rts
; ---------------------------------------------------------------------------

loc_EB52:
	addq.w	#1,$26(a0)
	move.w	$26(a0),d0
	andi.w	#1,d0
	move.b	#$A,$22(a0)
	lsl.w	#3,d0
	lea	(byte_EB96).l,a1
	adda.w	d0,a1
	move.w	(a1)+,(palette_buffer+$22).l
	move.w	(a1)+,(palette_buffer+$24).l
	move.w	(a1)+,(palette_buffer+$28).l
	move.w	(a1),(palette_buffer+$2A).l
	move.b	#1,d0
	lea	((palette_buffer+$20)).l,a2
	jmp	(LoadPalette).l
; ---------------------------------------------------------------------------
byte_EB96:	dc.b 0
	dc.b   6
	dc.b   0
	dc.b $48
	dc.b   8
	dc.b   0
	dc.b  $A
	dc.b $40
	dc.b   0
	dc.b  $E
	dc.b   0
	dc.b  $E
	dc.b  $E
	dc.b $60
	dc.b  $E
	dc.b $60
; ---------------------------------------------------------------------------

ActTitleNElectricity:
	move.w	#$FFE8,d0
	bsr.w	sub_EBF8
	cmpi.w	#2,$28(a0)
	bge.s	loc_EBBC
	move.b	#0,6(a0)

loc_EBBC:
	tst.b	$22(a0)
	beq.s	loc_EBC8
	subq.b	#1,$22(a0)
	rts
; ---------------------------------------------------------------------------

loc_EBC8:
	move.w	$28(a0),d0
	addq.b	#1,d0
	andi.b	#7,d0
	move.w	d0,$28(a0)
	add.w	d0,d0
	move.w	word_EBE8(pc,d0.w),d0
	move.b	d0,9(a0)
	lsr.w	#8,d0
	move.b	d0,$22(a0)
	rts
; ---------------------------------------------------------------------------
word_EBE8:	dc.w $1933
	dc.w $1933
	dc.w $333
	dc.w $334
	dc.w $335
	dc.w $333
	dc.w $334
	dc.w $335

; =============== S U B	R O U T	I N E =======================================


sub_EBF8:
	add.w	(hscroll_buffer).l,d0
	move.w	d0,$A(a0)
	bmi.s	locret_EC0A
	move.b	#$80,6(a0)

locret_EC0A:
	rts
; End of function sub_EBF8


; =============== S U B	R O U T	I N E =======================================

Title_LoadFG:
	include "game/subroutines/title/Load Foreground.asm"

; =============== S U B	R O U T	I N E =======================================

Title_LoadBG:
	include "game/subroutines/title/Load Background.asm"

; =============== S U B	R O U T	I N E =======================================

sub_EC6A:
	lea	(byte_11258).l,a2 ; Font Table
	clr.w	d1
	move.w	#$E500,d0

loc_EC76:
	move.b	(a1)+,d1
	bmi.s	locret_EC96
	move.b	(a2,d1.w),d0
	DISABLE_INTS
	jsr	(SetVRAMWrite).l
	move.w	d0,VDP_DATA
	ENABLE_INTS
	addq.w	#2,d5
	bra.s	loc_EC76
	
; ---------------------------------------------------------------------------

locret_EC96:
	rts
; End of function sub_EC6A


; =============== S U B	R O U T	I N E =======================================


sub_EC98:
	move.w	#$E500,d0

loc_EC9C:
	move.b	(a1)+,d1
	bmi.s	locret_ECB8
	DISABLE_INTS
	jsr	(SetVRAMWrite).l
	move.w	d0,VDP_DATA
	ENABLE_INTS
	addq.w	#2,d5
	bra.s	loc_EC9C
; ---------------------------------------------------------------------------

locret_ECB8:
	rts
; End of function sub_EC98


; =============== S U B	R O U T	I N E =======================================


CheckIfJapan:
	move.b	CONSOLE_VER,d0
	andi.b	#$C0,d0
	beq.s	locret_ECDA
	move.w	(sound_test_enabled).l,d0
	not.w	d0
	move.w	d0,(sound_test_enabled).l
	jmp	(sub_23536).l
; ---------------------------------------------------------------------------

locret_ECDA:
	rts
; End of function CheckIfJapan

; ---------------------------------------------------------------------------
	rts
; ---------------------------------------------------------------------------
	dc.b $40
	dc.b $40
	dc.b   4
	dc.b $10
	dc.b $10
	dc.b   4
	dc.b $20
	dc.b $20
	dc.b $FF
	dc.b   0
; ---------------------------------------------------------------------------
; START	OF FUNCTION CHUNK FOR ActTitleHandler

loc_ECE8:
	move.b	#1,(swap_controls).l
	move.b	#1,(byte_FF196A).l
	move.b	(p2_ctrl_press).l,d0
	btst	#7,d0
	bne.w	loc_ED16
	eori.b	#1,(swap_controls).l
	eori.b	#1,(byte_FF196A).l

loc_ED16:
	move.b	#$41,d0
	jsr	(PlaySound_ChkPCM).l
	clr.b	(bytecode_disabled).l
	clr.b	(bytecode_flag).l
	jmp	(ActorDeleteSelf).l
; END OF FUNCTION CHUNK	FOR ActTitleHandler