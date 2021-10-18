;-------------------------------------------------------------------------------

PCM_Samples:                                                   ; Offset_0x0B0000
                incbin  "sound/pcm/pcmbank0.bin" 
				ALIGN	$B8000, $FF
															   ; Offset_0x0B8000                 
                incbin  "sound/pcm/pcmbank1.bin"  
                ALIGN	$C0000, $FF   
															   ; Offset_0x0C0000                     
                incbin  "sound/pcm/pcmbank2.bin"  
                ALIGN	$C8000, $FF
															   ; Offset_0x0C8000                           
                incbin  "sound/pcm/pcmbank3.bin"  
                ALIGN	$D0000, $FF 
															   ; Offset_0x0D0000                             
                incbin  "sound/pcm/pcmbank4.bin"  
                ALIGN	$D8000, $FF  
															   ; Offset_0x0D8000                                 
                incbin  "sound/pcm/pcmbank5.bin"
                ALIGN	$E0000, $FF
															   ; Offset_0x0E0000                   
                incbin  "sound/pcm/pcmbank6.bin"
                ALIGN	$E8000, $FF 
DAC_Samples:                                                   ; Offset_0x0E8000
                incbin  "sound/dac/dac_data.bin"
                ALIGN	$F0000, $FF  
				
;-------------------------------------------------------------------------------   

Sfx_Pointers:                                                  
                dc.w    $6D80   ; Offset_0x0F006D
                dc.w    $6180   ; Offset_0x0F0061
                dc.w    $5580   ; Offset_0x0F0055
                dc.w    $4980   ; Offset_0x0F0049
                dc.w    $2D81   ; Offset_0x0F012D           
                dc.w    $C180   ; Offset_0x0F00C1
                dc.w    $9D80   ; Offset_0x0F009D
                dc.w    $9180   ; Offset_0x0F0091
                dc.w    $D980   ; Offset_0x0F00D9
                dc.w    $E580   ; Offset_0x0F00E5
                dc.w    $CD80   ; Offset_0x0F00CD
                dc.w    $B580   ; Offset_0x0F00B5
                dc.w    $8580   ; Offset_0x0F0085
                dc.w    $7980   ; Offset_0x0F0079
                dc.w    $3D80   ; Offset_0x0F003D
                dc.w    $3180   ; Offset_0x0F0031
                dc.w    $F180   ; Offset_0x0F00F1
                dc.w    $FD80   ; Offset_0x0F00FD
                dc.w    $0981   ; Offset_0x0F0109
                dc.w    $1581   ; Offset_0x0F0115
                dc.w    $2181   ; Offset_0x0F0121
                dc.w    $A980   ; Offset_0x0F00A9
                dc.w    $3981   ; Offset_0x0F0139
               
                dc.b    $FF, $00, $00
				
;-------------------------------------------------------------------------------

Offset_0x0F0031:
                dc.b    $02, $2E, $80, $2E, $80, $38, $80, $8A
                dc.b    $48, $FF, $00, $00  
				
Offset_0x0F003D:
                dc.b    $02, $2E, $80, $2E, $80, $44, $80, $8B
                dc.b    $48, $FF, $00, $00    
				
Offset_0x0F0049:
                dc.b    $02, $2E, $80, $2E, $80, $50, $80, $8C
                dc.b    $2D, $FF, $00, $00
				
Offset_0x0F0055:
                dc.b    $02, $2E, $80, $2E, $80, $5C, $80, $8D
                dc.b    $2D, $FF, $00, $00
				
Offset_0x0F0061:
                dc.b    $02, $2E, $80, $2E, $80, $68, $80, $8E
                dc.b    $2D, $FF, $00, $00 
				
Offset_0x0F006D:
                dc.b    $02, $2E, $80, $2E, $80, $74, $80, $8F
                dc.b    $2D, $FF, $00, $00    
				
Offset_0x0F0079:
                dc.b    $02, $2E, $80, $2E, $80, $80, $80, $90
                dc.b    $2D, $FF, $00, $00  
				
Offset_0x0F0085:
                dc.b    $02, $2E, $80, $2E, $80, $8C, $80, $91
                dc.b    $2D, $FF, $00, $00    
				
Offset_0x0F0091:
                dc.b    $02, $2E, $80, $2E, $80, $98, $80, $92
                dc.b    $2D, $FF, $00, $00    
				
Offset_0x0F009D:
                dc.b    $02, $2E, $80, $2E, $80, $A4, $80, $93
                dc.b    $75, $FF, $00, $00   
				
Offset_0x0F00A9:
                dc.b    $02, $2E, $80, $2E, $80, $B0, $80, $94
                dc.b    $75, $FF, $00, $00     
				
Offset_0x0F00B5:
                dc.b    $02, $2E, $80, $2E, $80, $BC, $80, $97
                dc.b    $6C, $FF, $00, $00   
				
Offset_0x0F00C1:
                dc.b    $02, $2E, $80, $2E, $80, $C8, $80, $98
                dc.b    $6C, $FF, $00, $00    
				
Offset_0x0F00CD:
                dc.b    $02, $2E, $80, $2E, $80, $D4, $80, $9A
                dc.b    $E5, $FF, $00, $00 
				
Offset_0x0F00D9:
                dc.b    $02, $2E, $80, $2E, $80, $E0, $80, $9B
                dc.b    $6C, $FF, $00, $00   
				
Offset_0x0F00E5:
                dc.b    $02, $2E, $80, $2E, $80, $EC, $80, $9C
                dc.b    $6C, $FF, $00, $00 
				
Offset_0x0F00F1:
                dc.b    $02, $2E, $80, $2E, $80, $F8, $80, $9D
                dc.b    $E5, $FF, $00, $00    
				
Offset_0x0F00FD:
                dc.b    $02, $2E, $80, $2E, $80, $04, $81, $A0
                dc.b    $7E, $FF, $00, $00    
				
Offset_0x0F0109:
                dc.b    $02, $2E, $80, $2E, $80, $10, $81, $A1
                dc.b    $7E, $FF, $00, $00    
				
Offset_0x0F0115:
                dc.b    $02, $2E, $80, $2E, $80, $1C, $81, $A2
                dc.b    $7E, $FF, $00, $00 
				
Offset_0x0F0121:
                dc.b    $02, $2E, $80, $2E, $80, $28, $81, $A3
                dc.b    $7E, $FF, $00, $00    
				
Offset_0x0F012D:
                dc.b    $02, $2E, $80, $2E, $80, $34, $81, $A4
                dc.b    $2D, $FF, $00, $00    
				
Offset_0x0F0139:
                dc.b    $02, $2E, $80, $2E, $80, $40, $81, $99
                dc.b    $24, $FF, $00, $00                                            
				
				ALIGN	$F2280, $00
				
;------------------------------------------------------------------------------- 
; Offset_0x0F2280: ; Left Over ???

                dc.b    $CC, $A2, $CC, $A2, $CC, $A2, $CC, $A2
                dc.b    $CC, $A2, $CC, $A2, $CC, $A2, $CC, $A2
                dc.b    $CC, $A2, $CC, $A2, $CC, $A2, $CC, $A2
                dc.b    $CC, $A2, $CC, $A2, $CC, $A2, $CC, $A2
                dc.b    $CC, $A2, $CC, $A2, $CC, $A2, $CC, $A2
                dc.b    $CC, $A2, $CC, $A2, $CC, $A2, $CC, $A2
                dc.b    $CC, $A2, $CC, $A2, $CC, $A2, $CC, $A2
                dc.b    $CC, $A2, $CC, $A2, $CC, $A2, $CC, $A2
                dc.b    $F0, $00, $FF, $00, $00, $02, $C0, $A2
                dc.b    $C0, $A2, $C0, $A2, $00, $00, $00, $C8
                dc.b    $E4, $A2, $E4, $A2, $E4, $A2, $E4, $A2
                dc.b    $E4, $A2, $E4, $A2, $E4, $A2, $E4, $A2
                dc.b    $E4, $A2, $E4, $A2, $FF, $00, $00, $FF             
				
				ALIGN	$F6000, $FF    
				
; ------------------------------------------------------------------------------
; Cube sound driver
; ------------------------------------------------------------------------------

CubeDriver:
				incbin	"data/sound/cube.bin"
CubeDriver_End:
              
; ------------------------------------------------------------------------------

				ALIGN	$F8000, $FF
				
				include	"sound/asm/patches.asm"
				include	"sound/asm/songs.asm"