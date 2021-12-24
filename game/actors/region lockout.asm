; =============== A C T O R =================================================
; Region lockout
; ---------------------------------------------------------------------------

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