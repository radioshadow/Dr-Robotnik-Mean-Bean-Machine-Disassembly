; --------------------------------------------------------------
;
;	Dr. Robotnik's Mean Bean Machine Disassembly
;	Original game by Compile
;
;	Disassembled by Devon Artmeier
;
; --------------------------------------------------------------

; --------------------------------------------------------------
; Queue a list of plane commands
; --------------------------------------------------------------
; PARAMETERS:
;	d0.w	- Plane command list ID
; RETURNS:
;	d0.b	- FE - List was fully queued
;		  FF - Lsit was partially queued
; --------------------------------------------------------------

QueuePlaneCmdList:
	DISABLE_INTS					; Disable interrupts
	movem.l	d1-d3/a2-a3,-(sp)			; Save registers

	move.b	#$FF,d2					; Set return code to "fully queued"

	lea	PlaneCmdLists,a2			; Get pointer to plane command list
	lsl.w	#2,d0
	movea.l	(a2,d0.w),a3

	move.w	(a3)+,d0				; Add number of list entries to overall queue count
	lea	plane_cmd_count,a2
	move.w	(a2),d1
	add.w	d0,d1

	cmpi.w	#PLANE_CMD_SLOT_COUNT+1,d1		; Have the overall number of queue slots overflown?
	bcs.w	.Queue					; If not, branch

	clr.b	d2					; Set return code to "partially queued"
	subi.w	#PLANE_CMD_SLOT_COUNT,d1		; Discard overflowing entries
	move.w	d1,d0
	move.w	#PLANE_CMD_SLOT_COUNT,d1

.Queue:
	move.w	(a2),d3					; Get pointer to current queue slot
	move.w	d1,(a2)+				; Save new queue count
	lsl.w	#2,d3
	adda.w	d3,a2

	subq.w	#1,d0					; Subtract count by 1 for dbf
	bcs.w	.Done					; If there are no commands to queue, branch

.QueueLoop:
	move.l	(a3)+,(a2)+				; Queue commands
	dbf	d0,.QueueLoop				; Loop until all commands are queued

.Done:
	move.b	d2,d0					; Set return code

	movem.l	(sp)+,d1-d3/a2-a3			; Restore registers
	ENABLE_INTS					; Enable interrupts

	subq.b	#1,d0					; Subtract return code by 1
	rts

; --------------------------------------------------------------
; Queue plane command
; --------------------------------------------------------------
; PARAMETERS:
;	d0.l	- Plane command
; RETURNS:
;	cc/cs	- Queued/Queue full
; --------------------------------------------------------------

QueuePlaneCmd:
	cmpi.w	#PLANE_CMD_SLOT_COUNT,plane_cmd_count	; Is the queue full?
	bcs.s	.Queue					; If not, branch

	SET_CARRY					; Set return code to "queue full"
	rts

.Queue:
	DISABLE_INTS					; Disable interrupts
	movem.l	d1/a2,-(sp)				; Save registers

	lea	plane_cmd_count,a2			; Add command to the end of the queue
	move.w	(a2),d1
	addq.w	#1,(a2)					; Increment queue count
	lsl.w	#2,d1
	move.l	d0,2(a2,d1.w)

	movem.l	(sp)+,d1/a2				; Restore registers
	ENABLE_INTS					; Enable interrupts

	CLEAR_CARRY					; Set return code to "queued"
	rts

; -------------------------------------------------------------- 
