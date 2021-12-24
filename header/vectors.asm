; --------------------------------------------------------------
; Vectors
; --------------------------------------------------------------

	dc.l Stack_Base		; Initial stack pointer value
	dc.l Entry			; Start of program
	dc.l Exception		; Bus error
	dc.l Exception		; Address error (4)
	dc.l Exception		; Illegal instruction
	dc.l Exception		; Division by zero
	dc.l Exception		; CHK exception
	dc.l Exception		; TRAPV exception (8)
	dc.l Exception		; Privilege violation
	dc.l Exception		; TRACE exception
	dc.l Exception		; Line-A emulator
	dc.l Exception		; Line-F emulator (12)
	dc.l Exception		; Unused (reserved)
	dc.l Exception		; Unused (reserved)
	dc.l Exception		; Unused (reserved)
	dc.l Exception		; Unused (reserved) (16)
	dc.l Exception		; Unused (reserved)
	dc.l Exception		; Unused (reserved)
	dc.l Exception		; Unused (reserved)
	dc.l Exception		; Unused (reserved) (20)
	dc.l Exception		; Unused (reserved)
	dc.l Exception		; Unused (reserved)
	dc.l Exception		; Unused (reserved)
	dc.l Exception		; Unused (reserved) (24)
	dc.l Exception		; Spurious exception
	dc.l Exception		; IRQ level 1
	dc.l Exception		; IRQ level 2
	dc.l Exception		; IRQ level 3 (28)
	dc.l HBlank			; IRQ level 4 (horizontal retrace interrupt)
	dc.l Exception		; IRQ level 5
	dc.l VBlank			; IRQ level 6 (vertical retrace interrupt)
	dc.l Exception		; IRQ level 7 (32)
	dc.l Exception		; TRAP #00 exception
	dc.l Exception		; TRAP #01 exception
	dc.l Exception		; TRAP #02 exception
	dc.l Exception		; TRAP #03 exception (36)
	dc.l Exception		; TRAP #04 exception
	dc.l Exception		; TRAP #05 exception
	dc.l Exception		; TRAP #06 exception
	dc.l Exception		; TRAP #07 exception (40)
	dc.l Exception		; TRAP #08 exception
	dc.l Exception		; TRAP #09 exception
	dc.l Exception		; TRAP #10 exception
	dc.l Exception		; TRAP #11 exception (44)
	dc.l Exception		; TRAP #12 exception
	dc.l Exception		; TRAP #13 exception
	dc.l Exception		; TRAP #14 exception
	dc.l Exception		; TRAP #15 exception (48)
	dc.l Exception		; Unused (reserved)
	dc.l Exception		; Unused (reserved)
	dc.l Exception		; Unused (reserved)
	dc.l Exception		; Unused (reserved) (52)
	dc.l Exception		; Unused (reserved)
	dc.l Exception		; Unused (reserved)
	dc.l Exception		; Unused (reserved)
	dc.l Exception		; Unused (reserved) (56)
	dc.l Exception		; Unused (reserved)
	dc.l Exception		; Unused (reserved)
	dc.l Exception		; Unused (reserved)
	dc.l Exception		; Unused (reserved) (60)
	dc.l Exception		; Unused (reserved)
	dc.l Exception		; Unused (reserved)
	dc.l Exception		; Unused (reserved)
	dc.l Exception		; Unused (reserved) (64)
	
; --------------------------------------------------------------