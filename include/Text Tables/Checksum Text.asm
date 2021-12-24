; --------------------------------------------------------------
; Checksum text data
; --------------------------------------------------------------
; PARAMETERS:
;	text	- Text to store
; --------------------------------------------------------------

CHECKSUM_TEXT macro text

escape = 0
i = 0
	while i<strlen(\text)
c substr 1+i,1+i,\text
	if escape=0
		; Escape character
		if "\c"="%"
escape = 1
		; Space
		elseif "\c"=" "
			dc.b	$00
			
		; .
		elseif ("\c"=".")
			dc.b	$25			
			
		; ,
		elseif ("\c"=",")
			dc.b	$26			
			
		; /
		elseif ("\c"="/")
			dc.b	$27	

		; :
		elseif ("\c"=":")
			dc.b	$28					
			
		; #
		elseif ("\c"="#")
			dc.b	$29
			
		; (
		elseif ("\c"="(")
			dc.b	$2A
						
		; )
		elseif ("\c"=")")
			dc.b	$2B
			
		; OFF
		elseif ("\c"="@")
			dc.w	$2C2D
						
		; -
		elseif ("\c"="-")
			dc.b	$2E
		
		; ~
		elseif ("\c"="~")
			dc.b	$2F

		; >
		elseif ("\c"=">")
			dc.b	$30

		; <
		elseif ("\c"="<")
			dc.b	$31

		; ?
		elseif ("\c"="?")
			dc.b	$32

		; !
		elseif ("\c"="!")
			dc.b	$3A
			
		; 0-9
		elseif ("\c">="0")&("\c"<="9")
			dc.b	("\c"-$2F)
			
		; A-Z
		elseif ("\c">="A")&("\c"<="Z")
			dc.b	("\c"-$40)+(10)			
		
		endif
	else
		; Custom character
		if "\c"="c"
			dc.b	$FE
		; Invalid
		else
			inform 2,"Invalid escape character '%s'", "\c"
		endif
escape = 0
	endif
i = i+1
	endw
	
	dc.b	$FF
	even

	endm