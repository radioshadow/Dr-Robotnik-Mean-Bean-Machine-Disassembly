; --------------------------------------------------------------
; Stage text data
; --------------------------------------------------------------
; PARAMETERS:
;	font	- 0 for large font, 1 for small font
;	text	- Text to store
; --------------------------------------------------------------

STAGE_TEXT macro font, text

foff = 0
	if (\font)<>0
foff = $6A
	endif

escape = 0
i = 0
	while i<strlen(\text)
c substr 1+i,1+i,\text
	if escape=0
		; Escape character
		if "\c"="%"
escape = 1
		; Space
		elseif ("\c"=" ")
			dc.b	$00
			
		; ? (small font)
		elseif ("\c"="?")&((\font)<>0)
			dc.b	$B4
			
		; 0-9
		elseif ("\c">="0")&("\c"<="9")
			dc.b	("\c"-$2F)*2+foff
			
		; A-Z
		elseif ("\c">="A")&("\c"<="Z")
			dc.b	("\c"-$40)*2+(10*2)+foff
			
		; Small "x" (large font)
		elseif ("\c"="x")&((\font)=0)
			dc.b	$4A

			
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

; --------------------------------------------------------------
; Print stage text at location
; --------------------------------------------------------------
; PARAMETERS:
;	font	- 0 for large font, 1 for small font
;	loc	- VRAM location to store text
;		  If >= $C000, it's used as an absolute address,
;		  otherwise, it's treated as relative to a
;		  player's puyo field
;	base	- Base VRAM address for font
;	text	- Text to store
; --------------------------------------------------------------

STAGE_TEXT_LOC macro font, loc, base, text

	if (\loc)<$C000
		dc.w	0, \loc, \base
	else
		dc.w	\loc, \base
	endif

	STAGE_TEXT \font, \text
	
	endm

; --------------------------------------------------------------