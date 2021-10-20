; =============== S U B	R O U T	I N E =======================================
; Region lockout
; ---------------------------------------------------------------------------
	
	if RegionCheckCode=0
	lea	(Str_RegionLockNTSC).l,a2
	move.b	#$80,d0
	cmpi.b	#$80,d0
	beq.s	.print
	lea	(Str_RegionLockPAL).l,a2
	
	else
	
	if RegionSetCheck=0 ; Japan
	lea	(Str_RegionLockJapan).l,a2
	endc
					
	if RegionSetCheck=1 ; USA
	lea	(Str_RegionLockUSA).l,a2
	endc
					
	if RegionSetCheck=2 ; Europe
	lea	(Str_RegionLockEurope).l,a2
	endc
					
	if RegionSetCheck=3 ; Asia
	lea	(Str_RegionLockAsia).l,a2
	endc
	endc	

.print:
	move.w	#$C500,d5
	moveq	#1,d0
	moveq	#$27,d1
	move.w	#$500,d6
	jsr	(RegionLock_Print).l
	lea	(ActRegionLockout).l,a1
	jmp	(FindActorSlot).l

; =============== S U B	R O U T	I N E =======================================


ActRegionLockout:
	move.w	#0,aField26(a0)
	move.w	#$258,aField28(a0)
	jsr	(ActorBookmark).l
	move.b	#$80,d0
	cmpi.b	#$80,d0
	bne.s	.NoMatch
	
	if RegionCheckCode=0 ; Checking if console is Asia?
	move.b	CONSOLE_VER,d0
	andi.b	#$40,d0
	bne.s	.NoMatch	
	endc
	
	tst.w	aField26(a0)
	beq.s	.CheckCode
	subq.w	#1,aField28(a0)
	bmi.s	.NoMatch

.CheckCode:
	if RegionByPassPad=0
	lea	(p1_ctrl_hold).l,a1 ; Use P1 Controller
	else
	lea	(p2_ctrl_hold).l,a1 ; Use P2 Controller
	endc
	
	lea	(LockoutBypassCode).l,a2
	move.w	aField26(a0),d0
	move.b	(a2,d0.w),d0
	cmpi.b	#$FF,d0
	
	if RegionByPassUse=0
	beq.s	.BypassLockout
	else
	bsr		.NoMatch
	endc
	
	move.b	1(a1),d1
	beq.s	.NoButton
	cmp.b	d0,d1
	
	if RegionByPassTry=0	; 1 attempt at entering the code
	bne.s	.NoMatch
	else 					; Unlimited attempts at entering the code
	bne.s	ActRegionLockout
	endc
	
	addq.w	#1,aField26(a0)

.NoButton:
	rts
; ---------------------------------------------------------------------------

.BypassLockout:
	move.b	#0,(bytecode_disabled).l
	rts
; ---------------------------------------------------------------------------

.NoMatch:
	jsr	(ActorBookmark).l
	nop
	rts

; =============== S U B	R O U T	I N E =======================================

RegionLock_Print:
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
	include "data/font/Table - Region Error.asm"