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


