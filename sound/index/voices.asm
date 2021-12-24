VoiceIndex:
    ZDW	Voice06 ; Yippee 1   
	ZDW	Voice05 ; Yippee 2
	ZDW	Voice04 ; Yippee 3
	ZDW	Voice03 ; Yippee 4
	ZDW	Voice22 ; Yeehaw 1
	ZDW	Voice13 ; Yeehaw 2
	ZDW	Voice10 ; *screech noise 1*
	ZDW	Voice09 ; Yohoho 1
	ZDW	Voice15 ; Yohoho 2
	ZDW	Voice16 ; Yohoho 3
	ZDW	Voice14 ; *robot noise
	ZDW	Voice12 ; *boom noise*
	ZDW	Voice08 ; Yeehaw 3
	ZDW	Voice07 ; Yeehaw 4
	ZDW	Voice02 ; *crash noise*
	ZDW	Voice01 ; ARRGHH
	ZDW	Voice17 ; Yippee (celebrate)
	ZDW	Voice18 ; *thunder noise 1*
	ZDW	Voice19 ; *thunder noise 2*
	ZDW	Voice20 ; *thunder noise 3*
	ZDW	Voice21 ; *thunder noise 4*
	ZDW	Voice11 ; *screech noise 2*
	ZDW	Voice23 ; *pow noise*

	dc.w    $FF00
	dc.b	$00	
				
;-------------------------------------------------------------------------------

Voice01:
    dc.b    $02, $2E, $80, $2E, $80, $38, $80, $8A, $48, $FF, $00, $00  
				
Voice02:
    dc.b    $02, $2E, $80, $2E, $80, $44, $80, $8B, $48, $FF, $00, $00    
				
Voice03:
    dc.b    $02, $2E, $80, $2E, $80, $50, $80, $8C, $2D, $FF, $00, $00
				
Voice04:
    dc.b    $02, $2E, $80, $2E, $80, $5C, $80, $8D, $2D, $FF, $00, $00
				
Voice05:
    dc.b    $02, $2E, $80, $2E, $80, $68, $80, $8E, $2D, $FF, $00, $00 
				
Voice06:
    dc.b    $02 ; Type = SFX Type 2
	dc.w	$2E80
	dc.w	$2E80
	dc.w	$7480 ; Voice Offset?
	dc.b	$8F ; ID
	dc.b	$2D ; Voice Length

	dc.w    $FF00 ; End of Voice Data
	dc.b	$00    
				
Voice07:
    dc.b    $02, $2E, $80, $2E, $80, $80, $80, $90, $2D, $FF, $00, $00  
				
Voice08:
    dc.b    $02, $2E, $80, $2E, $80, $8C, $80, $91, $2D, $FF, $00, $00    
				
Voice09:
    dc.b    $02, $2E, $80, $2E, $80, $98, $80, $92, $2D, $FF, $00, $00    
				
Voice10:
    dc.b    $02, $2E, $80, $2E, $80, $A4, $80, $93, $75, $FF, $00, $00   
				
Voice11:
    dc.b    $02, $2E, $80, $2E, $80, $B0, $80, $94, $75, $FF, $00, $00     
				
Voice12:
    dc.b    $02, $2E, $80, $2E, $80, $BC, $80, $97, $6C, $FF, $00, $00   
				
Voice13:
    dc.b    $02, $2E, $80, $2E, $80, $C8, $80, $98, $6C, $FF, $00, $00    
				
Voice14:
    dc.b    $02, $2E, $80, $2E, $80, $D4, $80, $9A, $E5, $FF, $00, $00 
				
Voice15:
    dc.b    $02, $2E, $80, $2E, $80, $E0, $80, $9B, $6C, $FF, $00, $00   
				
Voice16:
    dc.b    $02, $2E, $80, $2E, $80, $EC, $80, $9C, $6C, $FF, $00, $00 
				
Voice17:
    dc.b    $02, $2E, $80, $2E, $80, $F8, $80, $9D, $E5, $FF, $00, $00    
				
Voice18:
    dc.b    $02, $2E, $80, $2E, $80, $04, $81, $A0, $7E, $FF, $00, $00    
				
Voice19:
    dc.b    $02, $2E, $80, $2E, $80, $10, $81, $A1, $7E, $FF, $00, $00    
				
Voice20:
    dc.b    $02, $2E, $80, $2E, $80, $1C, $81, $A2, $7E, $FF, $00, $00 
				
Voice21:
    dc.b    $02, $2E, $80, $2E, $80, $28, $81, $A3, $7E, $FF, $00, $00    
				
Voice22:
    dc.b    $02, $2E, $80, $2E, $80, $34, $81, $A4, $2D, $FF, $00, $00    
				
Voice23:
    dc.b    $02, $2E, $80, $2E, $80, $40, $81, $99, $24, $FF, $00, $00  
	
; -------------------------------------------------------------- 
