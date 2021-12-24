; --------------------------------------------------------------
; Sega logo
; --------------------------------------------------------------
					
	BRUN	InitPalette_Safe
	BRUN	sub_F8F4
	BVDP	1
	BNEM	$2000, ArtNem_SegaLogo
	BFRMEND
	BPAL	Pal_SegaLogo, 0
	BRUN	LoadSegaLogo
	BDISABLE
	BPAL	Pal_Black, 0
	BRUN	InitActors
	BFRMEND
	BWRITE	hblank_count, 0
	BWRITE	vscroll_buffer,	0
	BFRMEND