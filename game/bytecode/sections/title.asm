; --------------------------------------------------------------
; Title
; --------------------------------------------------------------

	BVDP	0
	BNEM	$0000, ArtNem_TitleLogo
	BNEM	$A000, ArtNem_MainFont
	BFRMEND
	BRUN	ClearPlaneA
	BRUN	ClearPlaneB
	BFRMEND
	BRUN	Title_LoadBG
	BFRMEND
	BRUN	Title_LoadFG
	BFRMEND
	BRUN	InitTitle
	BFADE	Pal_Title1, 0, 0
	BFADE	Pal_Title2, 1, 0
	BFADE	Pal_Title3, 2, 0
	BFADE	Pal_TitleA, 3, 0
	BDISABLE
	BFADE	Pal_Black, 0, 0
	BFADE	Pal_Black, 1, 0
	BFADE	Pal_Black, 2, 0
	BFADE	Pal_Black, 3, 0
	BFADEW
	BRUN	InitPalette_Safe
	BRUN	InitActors
	BFRMEND
	BWRITE	hblank_count, 0
	BWRITE	vscroll_buffer,	0
	BFRMEND
	BRUN	ClearScroll
	BDELAY	6
	BJTBL
	dc.l BC_MainMenu
	dc.l BC_GameIntro
	BJTBLE