; =============== S U B	R O U T	I N E =======================================
; Sega logo
; ---------------------------------------------------------------------------

	lea	(ActSegaLogo).l,a1
	jsr	(FindActorSlot).l
	bcs.s	.NoSpace
	move.b	#$32,aMappings(a1)
	move.w	#$20,aX(a1)
	move.w	#$E0,aY(a1)
	move.b	#$80,aDrawFlags(a1)
	move.l	#Anim_SegaLogo,aAnim(a1)

.NoSpace:
	rts

; =============== S U B	R O U T	I N E =======================================

ActSegaLogo:
	jsr	(ActorAnimate).l
	movea.l	aAnim(a0),a2
	cmpi.b	#$FE,(a2)
	beq.s	ActSegaLogo_Delay
	moveq	#0,d0
	move.b	9(a0),d0
	move.b	SegaLogoXSpeeds(pc,d0.w),d0
	add.w	d0,aX(a0)
	rts
	
; ---------------------------------------------------------------------------

SegaLogoXSpeeds:
	dc.b 6
	dc.b 5
	dc.b 4
	dc.b 4
	dc.b 4
	dc.b 3
	dc.b 3
	dc.b 3
	dc.b 3
	dc.b 3
	dc.b 3
	dc.b 2
	dc.b 2
	dc.b 2
	dc.b 2
	dc.b 1
	dc.b 1
	dc.b 1
	dc.b 0
	dc.b 0
	even
	
; ---------------------------------------------------------------------------

ActSegaLogo_Delay:
	move.b	#$13,9(a0)
	move.w	#3,$28(a0)
	move.w	#$3C,d0
	jsr	(ActorBookmark_SetDelay).l
	jsr	(ActorBookmark).l
	subq.w	#1,$28(a0)
	beq.s	ActSegaLogo_Outline
	rts
	
; ---------------------------------------------------------------------------

ActSegaLogo_Outline:
	jsr	(LoadTimerCtrlSkip).l
	move.w	#3,$28(a0)
	move.w	$26(a0),d0
	cmpi.w	#$EEE,d0
	beq.s	.Delay
	addi.w	#$222,d0
	move.w	d0,$26(a0)
	move.w	d0,(palette_buffer+2).l
	move.b	#0,d0
	lea	(palette_buffer).l,a2
	jmp	(LoadPalette).l
	
; ---------------------------------------------------------------------------

.Delay:
	move.w	#0,$26(a0)
	move.w	#3,$28(a0)
	move.w	#$3C,d0
	jsr	(ActorBookmark_SetDelay).l
	jsr	(ActorBookmark).l
	subq.w	#1,$28(a0)
	beq.s	.PalCycle
	rts
	
; ---------------------------------------------------------------------------

.PalCycle:
	move.w	#3,$28(a0)
	addq.w	#1,$26(a0)
	move.w	$26(a0),d0
	cmpi.w	#$11,d0
	beq.s	.Delete
	add.w	d0,d0
	lea	(PalCycle_SegaLogo).l,a1
	suba.w	d0,a1
	lea	((palette_buffer+4)).l,a2
	moveq	#8,d0

.CopyPal:
	move.w	(a1)+,(a2)+
	dbf	d0,.CopyPal
	move.b	#0,d0
	lea	(palette_buffer).l,a2
	jmp	(LoadPalette).l
	
; ---------------------------------------------------------------------------

.Delete:
	move.w	#$3C,d0
	jsr	(ActorBookmark_SetDelay).l
	jsr	(ActorBookmark).l
	clr.b	(bytecode_disabled).l
	jmp	(ActorDeleteSelf).l

; ---------------------------------------------------------------------------

	incbin	"data/palettes/array/sega logo/logo 1.bin"
	
PalCycle_SegaLogo:
	incbin	"data/palettes/array/sega logo/logo 2.bin"
	even
	
Anim_SegaLogo:
	dc.b   	3
	dc.b   	0
	dc.b   	3
	dc.b   	1
	dc.b   	3
	dc.b   	2
	dc.b   	3
	dc.b   	3
	dc.b   	3
	dc.b   	4
	dc.b   	3
	dc.b   	5
	dc.b   	3
	dc.b   	6
	dc.b   	3
	dc.b   	7
	dc.b   	3
	dc.b   	8
	dc.b   	3
	dc.b   	9
	dc.b   	3
	dc.b	10
	dc.b   	3
	dc.b  	11
	dc.b  	3
	dc.b  	12
	dc.b   	3
	dc.b  	13
	dc.b   	3
	dc.b  	14
	dc.b   	3
	dc.b  	15
	dc.b   	3
	dc.b 	16
	dc.b   	3
	dc.b 	17
	dc.b   	3
	dc.b 	18
	
	dc.b 	$FE ; End of animation
	even