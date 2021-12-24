; --------------------------------------------------------------
; Region check
; --------------------------------------------------------------
					
	if RegionLock=1						; If region lock is off, then skip code	
	BJMP	BC_Checksum					; Run checksum
	
	else								; If region lock is on, then use code below
	BRUN	GetRegion					; Get region
	endc								
	
	BJCLR	BC_Checksum					; If this is an American console, branch
	BVDP	1							
	BRUN	DisableSHMode				
	BNEM	$A000, ArtNem_MainFont		
	BPCMD	0
	BFRMEND
	BRUN	RegionLockout
	BFRMEND
	BPAL	Pal_RedYellowPuyos, 0
	BDISABLE
	BFADE	Pal_Black, 0, 0
	BFADE	Pal_Black, 1, 0
	BFADE	Pal_Black, 2, 0
	BFADE	Pal_Black, 3, 0
	BFADEW
	BRUN	InitActors