
PCM_Samples:                                            ; Offset_0x0B0000
    incbin  "sound/pcm/pcmbank0.bin" 					; ARRGH, *crash noise*
	ALIGN	$B8000, $FF									
														; Offset_0x0B8000                 
    incbin  "sound/pcm/pcmbank1.bin"					; Yippe, Yeehaw, Yohoho  				
    ALIGN	$C0000, $FF   
														; Offset_0x0C0000                     
    incbin  "sound/pcm/pcmbank2.bin"  					; *screech noise*
    ALIGN	$C8000, $FF
														; Offset_0x0C8000                           
    incbin  "sound/pcm/pcmbank3.bin"  					; *thunder noise*, Yippee, ???
    ALIGN	$D0000, $FF 
														; Offset_0x0D0000                             
    incbin  "sound/pcm/pcmbank4.bin"  					; *Robot noise*
    ALIGN	$D8000, $FF  
														; Offset_0x0D8000                                 
    incbin  "sound/pcm/pcmbank5.bin"					; Yippee Ending
    ALIGN	$E0000, $FF
														; Offset_0x0E0000                   
    incbin  "sound/pcm/pcmbank6.bin"					; *thunder noise*
    ALIGN	$E8000, $FF 

DAC_Samples:                                            ; Offset_0x0E8000
    incbin  "sound/dac/dac_data.bin"					; *drum 1*, *drum 2*, *drum 3*, Ha
    ALIGN	$F0000, $FF  
				
; -------------------------------------------------------------- 

	include	"sound/index/voices.asm"							
				
	ALIGN	$F2280, $00
				
; --------------------------------------------------------------

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
				
; --------------------------------------------------------------
; Cube sound driver
; --------------------------------------------------------------

CubeDriver:
	incbin	"sound/driver/cube.bin"
CubeDriver_End:
              
; --------------------------------------------------------------

	ALIGN	$F8000, $FF
				
	include	"sound/patches/patches.asm"
	include	"sound/index/songs.asm"