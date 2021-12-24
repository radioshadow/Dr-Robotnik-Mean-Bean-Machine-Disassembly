; --------------------------------------------------------------
; Score text data
; --------------------------------------------------------------
; PARAMETERS:
;	text	- Text to store
; --------------------------------------------------------------

SCORE_TEXT macro text

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
		elseif "\c"="."
			dc.b	$1B
			
		; A-Z
		elseif ("\c">="A")&("\c"<="Z")
			dc.b	("\c"-$40)	
		
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

	endm