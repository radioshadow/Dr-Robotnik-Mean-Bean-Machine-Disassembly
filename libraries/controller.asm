; --------------------------------------------------------------
;
;	Dr. Robotnik's Mean Bean Machine Disassembly
;	Original game by Compile
;
;	Disassembled by Devon Artmeier
;
; --------------------------------------------------------------

; --------------------------------------------------------------
; Initialize controllers
; --------------------------------------------------------------

InitControllers:
	lea	p1_ctrl+ctlHold,a1			; Clear controller data
	moveq	#0,d0
	move.l	d0,(a1)+
	move.l	d0,(a1)+
	move.l	d0,(a1)+

	move.b	#$10,press_pulse_time			; Set D-Pad press pulse times
	move.b	#3,hold_pulse_time

	Z80_STOP					; Setup controller ports
	moveq	#$40,d0
	move.b	d0,PORT_A_CTRL
	move.b	d0,PORT_B_CTRL
	move.b	d0,PORT_C_CTRL
	Z80_START

	rts

; --------------------------------------------------------------
; Read controllers (interrupt and Z80 safe)
; --------------------------------------------------------------

ReadCtrlsSafe:
	DISABLE_INTS					; Disable interrupts

	Z80_STOP					; Read controller data
	bsr.w	ReadControllers
	Z80_START

	ENABLE_INTS					; Enable interrupts
	rts

; --------------------------------------------------------------
; Read controllers
; --------------------------------------------------------------

ReadControllers:
	lea	p1_ctrl+ctlHold,a0			; Read player 1 controller data
	lea	PORT_A_DATA,a1
	bsr.w	ReadController

	lea	p2_ctrl+ctlHold,a0			; Read player 2 controller data
	lea	PORT_B_DATA,a1

; --------------------------------------------------------------
; Read a controller
; --------------------------------------------------------------
; PARAMETERS:
;	a0.l	- Pointer to controller read buffer
;	a1.l	- Pointer to I/O data port
; --------------------------------------------------------------

ReadController:
	move.b	#0,(a1)					; Get start and A buttons
	nop
	nop
	move.b	(a1),d1
	move.b	d1,d2
	asl.b	#2,d1
	andi.b	#$C0,d1

	move.b	#$40,(a1)				; Get D-Pad, B, and C buttons
	nop
	nop
	move.b	(a1),d0
	andi.b	#$3F,d0

	or.b	d1,d0					; Combine controller data
	not.b	d0

	andi.b	#$C,d2					; Were the 6 button controller buttons read?
	beq.w	.Not6Button				; If not, branch
	andi.b	#$CF,d0					; Mask out garbage bits

.Not6Button:
	move.b	ctlHold(a0),d1				; Store button data
	move.b	d0,ctlHold(a0)
	move.b	ctlHold(a0),ctlPress(a0)
	not.b	d1
	and.b	d1,ctlPress(a0)

	bsr.w	CtrlVertiPulse				; Handle press pulse timers for the up and down buttons
	bsr.w	CtrlHorizPulse				; Handle press pulse timers for the left and right buttons

	rts

; --------------------------------------------------------------
; Handle press pulse timers for the left and right buttons
; --------------------------------------------------------------

CtrlHorizPulse:
	andi.b	#$F3,ctlPulse(a0)			; Mask out left and right button data

	move.b	ctlHold(a0),d0				; Get controller data changes
	move.b	ctlPulseH(a0),d1
	move.b	d1,d2
	ror.b	#4,d1
	eor.b	d0,d1

	andi.b	#$C,d1					; Have left or right just been pressed?
	bne.s	.Pressed				; If so, branch
	andi.b	#$3F,d2					; Has the pulse timer run out?
	beq.s	.Refresh				; If so, branch

.Held:
	subq.b	#1,ctlPulseH(a0)			; Decrement pulse timer
	rts

.Refresh:
	andi.b	#$C,d0					; Set the buttons as pressed for this frame
	or.b	d0,ctlPulse(a0)
	move.b	hold_pulse_time,d0			; Set hold pulse timer
	or.b	d0,ctlPulseH(a0)
	rts

.Pressed:
	andi.b	#$C,d0					; Set the buttons as pressed for this frame
	or.b	d0,ctlPulse(a0)
	rol.b	#4,d0					; Update button data
	andi.b	#$C0,d0
	or.b	press_pulse_time,d0			; Set press pulse timer
	move.b	d0,ctlPulseH(a0)
	rts

; --------------------------------------------------------------
; Handle press pulse timers for the up and down buttons
; --------------------------------------------------------------

CtrlVertiPulse:
	andi.b	#$FC,ctlPulse(a0)			; Mask out up and down button data

	move.b	ctlHold(a0),d0				; Get controller data changes
	move.b	ctlPulseV(a0),d1
	move.b	d1,d2
	ror.b	#6,d1
	eor.b	d0,d1

	andi.b	#3,d1					; Have up or down just been pressed?
	bne.s	.Pressed				; If so, branch
	andi.b	#$3F,d2					; Has the pulse timer run out?
	beq.s	.Refresh				; If so, branch

.Held:
	subq.b	#1,ctlPulseV(a0)			; Decrement pulse timer
	rts

.Refresh:
	andi.b	#3,d0					; Set the buttons as pressed for this frame
	or.b	d0,ctlPulse(a0)
	move.b	hold_pulse_time,d0			; Set hold pulse timer
	or.b	d0,ctlPulseV(a0)
	rts

.Pressed:
	andi.b	#3,d0					; Set the buttons as pressed for this frame
	or.b	d0,ctlPulse(a0)
	rol.b	#6,d0					; Update button data
	andi.b	#$C0,d0
	or.b	press_pulse_time,d0			; Set press pulse timer
	move.b	d0,ctlPulseV(a0)
	rts

; --------------------------------------------------------------