; --------------------------------------------------------------
; Password
; --------------------------------------------------------------

	BSFADE
	BPAL	Pal_Black, 0
	BPAL	Pal_Black, 1
	BPAL	Pal_Black, 2
	BPAL	Pal_Black, 3
	BRUN	InitActors
	BPCMD	$14
	BFRMEND
	BVDP	0
	BRUN	ClearScroll
	
	if PuyoCompression=0
	BPUYO	$2000,	ArtPuyo_LevelSprites
	else
	BNEM	$2000,	ArtPuyo_LevelSprites
	endc
	
	BNEM	$8000,  ArtNem_Password
	BFRMEND
	BSND	BGM_PASSWORD
	BRUN	Password_LoadBG
	BFRMEND
	BRUN	Password_Checks
	BFADE	Pal_RedYellowPuyos, 0, 0
	BFADE	Pal_BluePurplePuyos, 1, 0
	BFADE	Pal_Password3, 2, 0
	BFADE	Pal_Password4, 3, 0
	BFADEW
	BDISABLE