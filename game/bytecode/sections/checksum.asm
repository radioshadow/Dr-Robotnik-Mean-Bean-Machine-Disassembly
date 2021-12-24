; --------------------------------------------------------------
; Checksum
; --------------------------------------------------------------

	if LoadChecksum=1					; If LoadChecksum is off, skip this section	
	
	else
	
	BRUN	InitPalette_Safe
	BRUN	InitDebugFlags
	BRUN	CheckChecksum				; Check checksum
	
	BJCLR	BC_Sega
	BVDP	1
	
	if PuyoCompression=0
	BPUYO	$0000,  ArtPuyo_LessonMode
	BPUYO	$A000,  ArtPuyo_OldFont
	else
	BNEM	$0000,  ArtPuyo_LessonMode
	BNEM	$A000,  ArtPuyo_OldFont
	endc
	
	BRUN	ChecksumError
	BFRMEND
	BPAL	Pal_White, 0
	BPAL	Pal_OptTextRed, 1
	BPAL	Pal_Options, 2
	
	if ChecksumScreen=1					; If ChecksumScreen is on, use code below	
ChecksumFail:
	BJMP	ChecksumFail				; Run ChecksumFail forever!
	endc
	
	BDISABLE
	BPAL	Pal_Black, 0
	BPAL	Pal_Black, 1
	BPAL	Pal_Black, 2
	BFRMEND
	
	endc