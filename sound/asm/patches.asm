; --------------------------------------------------------------
;
;	Dr. Robotnik's Mean Bean Machine Disassembly
;	Original game by Compile
;
;	Disassembled by Devon Artmeier
;
; --------------------------------------------------------------

FMInstruments:
	; Patch 00
	; 7F 23 22 11   14 23 1E 7F   9F 9F 8F 5A
	; 0F 00 00 00   09 00 00 00   71 83 14 05
	; 00 00 00 00   3A
	cfiName		patch00
	cfiMultiple	$0F, $03, $02, $01
	cfiDetune	$07, $02, $02, $01
	cfiTotalLv	$14, $23, $1E, $7F
	cfiAttack	$1F, $1F, $0F, $1A
	cfiRateScale	$02, $02, $02, $01
	cfiDecayRate	$0F, $00, $00, $00
	cfiAmpMod	$00, $00, $00, $00
	cfiSustainRt	$09, $00, $00, $00
	cfiReleaseRt	$01, $03, $04, $05
	cfiSustainLv	$07, $08, $01, $00
	cfiSSGEG	$00, $00, $00, $00
	cfiAlgorithm	$02
	cfiFeedback	$07

	; Patch 01
	; 7F 22 06 01   14 1E 23 7F   9F 8E 9F 5A
	; 0F 00 00 00   09 00 00 00   71 14 83 05
	; 00 00 00 00   3A
	cfiName		patch01
	cfiMultiple	$0F, $02, $06, $01
	cfiDetune	$07, $02, $00, $00
	cfiTotalLv	$14, $1E, $23, $7F
	cfiAttack	$1F, $0E, $1F, $1A
	cfiRateScale	$02, $02, $02, $01
	cfiDecayRate	$0F, $00, $00, $00
	cfiAmpMod	$00, $00, $00, $00
	cfiSustainRt	$09, $00, $00, $00
	cfiReleaseRt	$01, $04, $03, $05
	cfiSustainLv	$07, $01, $08, $00
	cfiSSGEG	$00, $00, $00, $00
	cfiAlgorithm	$02
	cfiFeedback	$07

	; Patch 02
	; 04 02 02 02   16 19 28 7F   DF D4 9F 9F
	; 11 0A 0B 0B   02 05 01 01   53 53 53 2C
	; 00 00 00 00   33
	cfiName		patch02
	cfiMultiple	$04, $02, $02, $02
	cfiDetune	$00, $00, $00, $00
	cfiTotalLv	$16, $19, $28, $7F
	cfiAttack	$1F, $14, $1F, $1F
	cfiRateScale	$03, $03, $02, $02
	cfiDecayRate	$11, $0A, $0B, $0B
	cfiAmpMod	$00, $00, $00, $00
	cfiSustainRt	$02, $05, $01, $01
	cfiReleaseRt	$03, $03, $03, $0C
	cfiSustainLv	$05, $05, $05, $02
	cfiSSGEG	$00, $00, $00, $00
	cfiAlgorithm	$03
	cfiFeedback	$06

	; Patch 03
	; 54 02 31 01   21 25 23 7F   9A 56 97 59
	; 0A 03 07 08   03 06 08 08   54 34 14 39
	; 00 00 00 00   22
	cfiName		patch03
	cfiMultiple	$04, $02, $01, $01
	cfiDetune	$05, $00, $03, $00
	cfiTotalLv	$21, $25, $23, $7F
	cfiAttack	$1A, $16, $17, $19
	cfiRateScale	$02, $01, $02, $01
	cfiDecayRate	$0A, $03, $07, $08
	cfiAmpMod	$00, $00, $00, $00
	cfiSustainRt	$03, $06, $08, $08
	cfiReleaseRt	$04, $04, $04, $09
	cfiSustainLv	$05, $03, $01, $03
	cfiSSGEG	$00, $00, $00, $00
	cfiAlgorithm	$02
	cfiFeedback	$04

	; Patch 04
	; 64 22 12 42   28 5F 7C 7F   14 4E 10 10
	; 0A 0A 0C 05   01 01 01 01   53 63 0D 0D
	; 00 00 00 00   14
	cfiName		patch04
	cfiMultiple	$04, $02, $02, $02
	cfiDetune	$06, $02, $01, $04
	cfiTotalLv	$28, $5F, $7C, $7F
	cfiAttack	$14, $0E, $10, $10
	cfiRateScale	$00, $01, $00, $00
	cfiDecayRate	$0A, $0A, $0C, $05
	cfiAmpMod	$00, $00, $00, $00
	cfiSustainRt	$01, $01, $01, $01
	cfiReleaseRt	$03, $03, $0D, $0D
	cfiSustainLv	$05, $06, $00, $00
	cfiSSGEG	$00, $00, $00, $00
	cfiAlgorithm	$04
	cfiFeedback	$02

	; Patch 05
	; 01 04 02 01   27 33 2C 7C   5F 5F 13 53
	; 00 0F 0B 0F   00 00 00 00   02 0B 4D 0A
	; 00 00 00 00   3B
	cfiName		patch05
	cfiMultiple	$01, $04, $02, $01
	cfiDetune	$00, $00, $00, $00
	cfiTotalLv	$27, $33, $2C, $7C
	cfiAttack	$1F, $1F, $13, $13
	cfiRateScale	$01, $01, $00, $01
	cfiDecayRate	$00, $0F, $0B, $0F
	cfiAmpMod	$00, $00, $00, $00
	cfiSustainRt	$00, $00, $00, $00
	cfiReleaseRt	$02, $0B, $0D, $0A
	cfiSustainLv	$00, $00, $04, $00
	cfiSSGEG	$00, $00, $00, $00
	cfiAlgorithm	$03
	cfiFeedback	$07

	; Patch 06
	; 31 32 38 34   25 2F 25 7F   59 19 5C 11
	; 0B 10 0C 0A   00 00 02 00   05 0D 1D 0D
	; 00 00 00 00   3A
	cfiName		patch06
	cfiMultiple	$01, $02, $08, $04
	cfiDetune	$03, $03, $03, $03
	cfiTotalLv	$25, $2F, $25, $7F
	cfiAttack	$19, $19, $1C, $11
	cfiRateScale	$01, $00, $01, $00
	cfiDecayRate	$0B, $10, $0C, $0A
	cfiAmpMod	$00, $00, $00, $00
	cfiSustainRt	$00, $00, $02, $00
	cfiReleaseRt	$05, $0D, $0D, $0D
	cfiSustainLv	$00, $00, $01, $00
	cfiSSGEG	$00, $00, $00, $00
	cfiAlgorithm	$02
	cfiFeedback	$07

	; Patch 07
	; 01 01 03 01   14 2E 28 7A   14 10 10 14
	; 0A 05 05 05   03 00 00 00   28 18 18 1B
	; 00 00 00 00   3A
	cfiName		patch07
	cfiMultiple	$01, $01, $03, $01
	cfiDetune	$00, $00, $00, $00
	cfiTotalLv	$14, $2E, $28, $7A
	cfiAttack	$14, $10, $10, $14
	cfiRateScale	$00, $00, $00, $00
	cfiDecayRate	$0A, $05, $05, $05
	cfiAmpMod	$00, $00, $00, $00
	cfiSustainRt	$03, $00, $00, $00
	cfiReleaseRt	$08, $08, $08, $0B
	cfiSustainLv	$02, $01, $01, $01
	cfiSSGEG	$00, $00, $00, $00
	cfiAlgorithm	$02
	cfiFeedback	$07

	; Patch 08
	; 0E 01 02 08   32 75 75 6B   92 15 14 12
	; 0A 00 00 00   00 00 00 00   13 0A 0A 0A
	; 00 00 00 00   06
	cfiName		patch08
	cfiMultiple	$0E, $01, $02, $08
	cfiDetune	$00, $00, $00, $00
	cfiTotalLv	$32, $75, $75, $6B
	cfiAttack	$12, $15, $14, $12
	cfiRateScale	$02, $00, $00, $00
	cfiDecayRate	$0A, $00, $00, $00
	cfiAmpMod	$00, $00, $00, $00
	cfiSustainRt	$00, $00, $00, $00
	cfiReleaseRt	$03, $0A, $0A, $0A
	cfiSustainLv	$01, $00, $00, $00
	cfiSSGEG	$00, $00, $00, $00
	cfiAlgorithm	$06
	cfiFeedback	$00

	; Patch 09
	; 02 11 72 01   14 5C 7A 7F   1F 1F 10 14
	; 00 00 0A 00   00 00 00 00   02 02 F8 08
	; 00 00 00 00   34
	cfiName		patch09
	cfiMultiple	$02, $01, $02, $01
	cfiDetune	$00, $01, $07, $00
	cfiTotalLv	$14, $5C, $7A, $7F
	cfiAttack	$1F, $1F, $10, $14
	cfiRateScale	$00, $00, $00, $00
	cfiDecayRate	$00, $00, $0A, $00
	cfiAmpMod	$00, $00, $00, $00
	cfiSustainRt	$00, $00, $00, $00
	cfiReleaseRt	$02, $02, $08, $08
	cfiSustainLv	$00, $00, $0F, $00
	cfiSSGEG	$00, $00, $00, $00
	cfiAlgorithm	$04
	cfiFeedback	$06

	; Patch 0A
	; 01 01 01 01   23 2D 1E 7F   0D 0F 10 12
	; 0B 0F 0A 06   00 00 00 00   85 75 15 1B
	; 00 00 00 00   3A
	cfiName		patch0A
	cfiMultiple	$01, $01, $01, $01
	cfiDetune	$00, $00, $00, $00
	cfiTotalLv	$23, $2D, $1E, $7F
	cfiAttack	$0D, $0F, $10, $12
	cfiRateScale	$00, $00, $00, $00
	cfiDecayRate	$0B, $0F, $0A, $06
	cfiAmpMod	$00, $00, $00, $00
	cfiSustainRt	$00, $00, $00, $00
	cfiReleaseRt	$05, $05, $05, $0B
	cfiSustainLv	$08, $07, $01, $01
	cfiSSGEG	$00, $00, $00, $00
	cfiAlgorithm	$02
	cfiFeedback	$07

	; Patch 0B
	; 0C 02 0F 02   1B 23 22 7B   9F 9F 9F 5F
	; 05 10 0A 0C   04 06 10 0A   29 19 F9 3A
	; 00 00 00 00   3A
	cfiName		patch0B
	cfiMultiple	$0C, $02, $0F, $02
	cfiDetune	$00, $00, $00, $00
	cfiTotalLv	$1B, $23, $22, $7B
	cfiAttack	$1F, $1F, $1F, $1F
	cfiRateScale	$02, $02, $02, $01
	cfiDecayRate	$05, $10, $0A, $0C
	cfiAmpMod	$00, $00, $00, $00
	cfiSustainRt	$04, $06, $10, $0A
	cfiReleaseRt	$09, $09, $09, $0A
	cfiSustainLv	$02, $01, $0F, $03
	cfiSSGEG	$00, $00, $00, $00
	cfiAlgorithm	$02
	cfiFeedback	$07

	; Patch 0C
	; 7C 7C 71 31   31 31 7F 7F   5F 5F 5F 5F
	; 12 16 0C 0C   01 01 02 02   68 88 4A 4A
	; 00 00 00 00   14
	cfiName		patch0C
	cfiMultiple	$0C, $0C, $01, $01
	cfiDetune	$07, $07, $07, $03
	cfiTotalLv	$31, $31, $7F, $7F
	cfiAttack	$1F, $1F, $1F, $1F
	cfiRateScale	$01, $01, $01, $01
	cfiDecayRate	$12, $16, $0C, $0C
	cfiAmpMod	$00, $00, $00, $00
	cfiSustainRt	$01, $01, $02, $02
	cfiReleaseRt	$08, $08, $0A, $0A
	cfiSustainLv	$06, $08, $04, $04
	cfiSSGEG	$00, $00, $00, $00
	cfiAlgorithm	$04
	cfiFeedback	$02

	; Patch 0D
	; 70 21 40 60   0C 10 7F 67   9F 1F 1F 5F
	; 0C 0C 09 15   04 06 04 06   56 46 46 4F
	; 00 00 00 00   2C
	cfiName		patch0D
	cfiMultiple	$00, $01, $00, $00
	cfiDetune	$07, $02, $04, $06
	cfiTotalLv	$0C, $10, $7F, $67
	cfiAttack	$1F, $1F, $1F, $1F
	cfiRateScale	$02, $00, $00, $01
	cfiDecayRate	$0C, $0C, $09, $15
	cfiAmpMod	$00, $00, $00, $00
	cfiSustainRt	$04, $06, $04, $06
	cfiReleaseRt	$06, $06, $06, $0F
	cfiSustainLv	$05, $04, $04, $04
	cfiSSGEG	$00, $00, $00, $00
	cfiAlgorithm	$04
	cfiFeedback	$05

	; Patch 0E
	; 39 30 35 31   17 14 32 7F   1F 1F 1F 1F
	; 0C 07 0A 0A   07 07 07 09   27 17 17 F7
	; 00 00 00 00   28
	cfiName		patch0E
	cfiMultiple	$09, $00, $05, $01
	cfiDetune	$03, $03, $03, $03
	cfiTotalLv	$17, $14, $32, $7F
	cfiAttack	$1F, $1F, $1F, $1F
	cfiRateScale	$00, $00, $00, $00
	cfiDecayRate	$0C, $07, $0A, $0A
	cfiAmpMod	$00, $00, $00, $00
	cfiSustainRt	$07, $07, $07, $09
	cfiReleaseRt	$07, $07, $07, $07
	cfiSustainLv	$02, $01, $01, $0F
	cfiSSGEG	$00, $00, $00, $00
	cfiAlgorithm	$00
	cfiFeedback	$05

	; Patch 0F
	; 06 00 00 00   1D 1C 17 7A   1F 1F 1F 1F
	; 11 0B 04 09   13 07 00 03   B7 36 46 17
	; 00 00 00 00   3B
	cfiName		patch0F
	cfiMultiple	$06, $00, $00, $00
	cfiDetune	$00, $00, $00, $00
	cfiTotalLv	$1D, $1C, $17, $7A
	cfiAttack	$1F, $1F, $1F, $1F
	cfiRateScale	$00, $00, $00, $00
	cfiDecayRate	$11, $0B, $04, $09
	cfiAmpMod	$00, $00, $00, $00
	cfiSustainRt	$13, $07, $00, $03
	cfiReleaseRt	$07, $06, $06, $07
	cfiSustainLv	$0B, $03, $04, $01
	cfiSSGEG	$00, $00, $00, $00
	cfiAlgorithm	$03
	cfiFeedback	$07

	; Patch 10
	; 61 22 00 32   13 1B 14 7F   5F 5F 5F 1F
	; 00 00 00 00   00 00 00 00   05 04 05 08
	; 00 00 00 00   30
	cfiName		patch10
	cfiMultiple	$01, $02, $00, $02
	cfiDetune	$06, $02, $00, $03
	cfiTotalLv	$13, $1B, $14, $7F
	cfiAttack	$1F, $1F, $1F, $1F
	cfiRateScale	$01, $01, $01, $00
	cfiDecayRate	$00, $00, $00, $00
	cfiAmpMod	$00, $00, $00, $00
	cfiSustainRt	$00, $00, $00, $00
	cfiReleaseRt	$05, $04, $05, $08
	cfiSustainLv	$00, $00, $00, $00
	cfiSSGEG	$00, $00, $00, $00
	cfiAlgorithm	$00
	cfiFeedback	$06

	; Patch 11
	; 71 31 00 32   0D 14 1B 7F   58 5F 5F 1F
	; 00 00 00 00   00 00 00 00   05 04 05 08
	; 00 00 00 00   30
	cfiName		patch11
	cfiMultiple	$01, $01, $00, $02
	cfiDetune	$07, $03, $00, $03
	cfiTotalLv	$0D, $14, $1B, $7F
	cfiAttack	$18, $1F, $1F, $1F
	cfiRateScale	$01, $01, $01, $00
	cfiDecayRate	$00, $00, $00, $00
	cfiAmpMod	$00, $00, $00, $00
	cfiSustainRt	$00, $00, $00, $00
	cfiReleaseRt	$05, $04, $05, $08
	cfiSustainLv	$00, $00, $00, $00
	cfiSSGEG	$00, $00, $00, $00
	cfiAlgorithm	$00
	cfiFeedback	$06

	; Patch 12
	; 3E 41 42 33   14 0A 13 7D   DE 1E 14 14
	; 14 0F 0F 00   01 00 00 00   36 26 25 29
	; 00 00 00 00   3B
	cfiName		patch12
	cfiMultiple	$0E, $01, $02, $03
	cfiDetune	$03, $04, $04, $03
	cfiTotalLv	$14, $0A, $13, $7D
	cfiAttack	$1E, $1E, $14, $14
	cfiRateScale	$03, $00, $00, $00
	cfiDecayRate	$14, $0F, $0F, $00
	cfiAmpMod	$00, $00, $00, $00
	cfiSustainRt	$01, $00, $00, $00
	cfiReleaseRt	$06, $06, $05, $09
	cfiSustainLv	$03, $02, $02, $02
	cfiSSGEG	$00, $00, $00, $00
	cfiAlgorithm	$03
	cfiFeedback	$07

	; Patch 13
	; 6F 10 5A 33   25 07 16 7F   06 1F 1E 1E
	; 00 1B 01 1C   00 01 01 01   11 08 F9 0A
	; 00 00 00 00   03
	cfiName		patch13
	cfiMultiple	$0F, $00, $0A, $03
	cfiDetune	$06, $01, $05, $03
	cfiTotalLv	$25, $07, $16, $7F
	cfiAttack	$06, $1F, $1E, $1E
	cfiRateScale	$00, $00, $00, $00
	cfiDecayRate	$00, $1B, $01, $1C
	cfiAmpMod	$00, $00, $00, $00
	cfiSustainRt	$00, $01, $01, $01
	cfiReleaseRt	$01, $08, $09, $0A
	cfiSustainLv	$01, $00, $0F, $00
	cfiSSGEG	$00, $00, $00, $00
	cfiAlgorithm	$03
	cfiFeedback	$00

	; Patch 14
	; 4E 7E 44 74   23 29 7F 7F   5B 5F 8C 0C
	; 04 07 07 08   00 02 01 03   F8 E7 F9 F9
	; 00 00 00 00   34
	cfiName		patch14
	cfiMultiple	$0E, $0E, $04, $04
	cfiDetune	$04, $07, $04, $07
	cfiTotalLv	$23, $29, $7F, $7F
	cfiAttack	$1B, $1F, $0C, $0C
	cfiRateScale	$01, $01, $02, $00
	cfiDecayRate	$04, $07, $07, $08
	cfiAmpMod	$00, $00, $00, $00
	cfiSustainRt	$00, $02, $01, $03
	cfiReleaseRt	$08, $07, $09, $09
	cfiSustainLv	$0F, $0E, $0F, $0F
	cfiSSGEG	$00, $00, $00, $00
	cfiAlgorithm	$04
	cfiFeedback	$06

	; Patch 15
	; 3D 7D 44 74   23 29 7F 7F   5B 5F 9F 1F
	; 08 0A 0A 0B   00 02 01 03   FF FF FF FF
	; 00 00 00 00   34
	cfiName		patch15
	cfiMultiple	$0D, $0D, $04, $04
	cfiDetune	$03, $07, $04, $07
	cfiTotalLv	$23, $29, $7F, $7F
	cfiAttack	$1B, $1F, $1F, $1F
	cfiRateScale	$01, $01, $02, $00
	cfiDecayRate	$08, $0A, $0A, $0B
	cfiAmpMod	$00, $00, $00, $00
	cfiSustainRt	$00, $02, $01, $03
	cfiReleaseRt	$0F, $0F, $0F, $0F
	cfiSustainLv	$0F, $0F, $0F, $0F
	cfiSSGEG	$00, $00, $00, $00
	cfiAlgorithm	$04
	cfiFeedback	$06

	; Patch 16
	; 07 01 02 00   19 7F 77 7F   1F 11 13 0C
	; 0A 00 0A 00   00 00 00 00   14 06 F8 0A
	; 00 00 00 00   06
	cfiName		patch16
	cfiMultiple	$07, $01, $02, $00
	cfiDetune	$00, $00, $00, $00
	cfiTotalLv	$19, $7F, $77, $7F
	cfiAttack	$1F, $11, $13, $0C
	cfiRateScale	$00, $00, $00, $00
	cfiDecayRate	$0A, $00, $0A, $00
	cfiAmpMod	$00, $00, $00, $00
	cfiSustainRt	$00, $00, $00, $00
	cfiReleaseRt	$04, $06, $08, $0A
	cfiSustainLv	$01, $00, $0F, $00
	cfiSSGEG	$00, $00, $00, $00
	cfiAlgorithm	$06
	cfiFeedback	$00

	; Patch 17
	; 54 61 34 01   06 0E 6B 7F   11 4A 0B 4C
	; 0A 06 0C 03   01 02 00 00   02 2A FF 2C
	; 00 00 00 00   3C
	cfiName		patch17
	cfiMultiple	$04, $01, $04, $01
	cfiDetune	$05, $06, $03, $00
	cfiTotalLv	$06, $0E, $6B, $7F
	cfiAttack	$11, $0A, $0B, $0C
	cfiRateScale	$00, $01, $00, $01
	cfiDecayRate	$0A, $06, $0C, $03
	cfiAmpMod	$00, $00, $00, $00
	cfiSustainRt	$01, $02, $00, $00
	cfiReleaseRt	$02, $0A, $0F, $0C
	cfiSustainLv	$00, $02, $0F, $02
	cfiSSGEG	$00, $00, $00, $00
	cfiAlgorithm	$04
	cfiFeedback	$07

	; Patch 18
	; 70 00 00 01   0D 0F 7F 7F   1F 1F 0B 0B
	; 00 00 00 00   00 00 00 00   02 02 08 08
	; 00 00 00 00   04
	cfiName		patch18
	cfiMultiple	$00, $00, $00, $01
	cfiDetune	$07, $00, $00, $00
	cfiTotalLv	$0D, $0F, $7F, $7F
	cfiAttack	$1F, $1F, $0B, $0B
	cfiRateScale	$00, $00, $00, $00
	cfiDecayRate	$00, $00, $00, $00
	cfiAmpMod	$00, $00, $00, $00
	cfiSustainRt	$00, $00, $00, $00
	cfiReleaseRt	$02, $02, $08, $08
	cfiSustainLv	$00, $00, $00, $00
	cfiSSGEG	$00, $00, $00, $00
	cfiAlgorithm	$04
	cfiFeedback	$00

	; Patch 19
	; 0F 42 07 02   14 7F 75 7F   1C 0F 12 0F
	; 0F 00 0F 00   07 00 0F 00   A9 09 A9 09
	; 00 00 00 00   3E
	cfiName		patch19
	cfiMultiple	$0F, $02, $07, $02
	cfiDetune	$00, $04, $00, $00
	cfiTotalLv	$14, $7F, $75, $7F
	cfiAttack	$1C, $0F, $12, $0F
	cfiRateScale	$00, $00, $00, $00
	cfiDecayRate	$0F, $00, $0F, $00
	cfiAmpMod	$00, $00, $00, $00
	cfiSustainRt	$07, $00, $0F, $00
	cfiReleaseRt	$09, $09, $09, $09
	cfiSustainLv	$0A, $00, $0A, $00
	cfiSSGEG	$00, $00, $00, $00
	cfiAlgorithm	$06
	cfiFeedback	$07

	; Patch 1A
	; 70 00 76 01   21 26 14 7F   1F 1F 92 1F
	; 0F 05 10 0D   07 03 03 00   2A 19 49 39
	; 00 00 00 00   3A
	cfiName		patch1A
	cfiMultiple	$00, $00, $06, $01
	cfiDetune	$07, $00, $07, $00
	cfiTotalLv	$21, $26, $14, $7F
	cfiAttack	$1F, $1F, $12, $1F
	cfiRateScale	$00, $00, $02, $00
	cfiDecayRate	$0F, $05, $10, $0D
	cfiAmpMod	$00, $00, $00, $00
	cfiSustainRt	$07, $03, $03, $00
	cfiReleaseRt	$0A, $09, $09, $09
	cfiSustainLv	$02, $01, $04, $03
	cfiSSGEG	$00, $00, $00, $00
	cfiAlgorithm	$02
	cfiFeedback	$07

	; Patch 1B
	; 0A 30 70 00   24 13 2D 7F   9F 9F 9F 9F
	; 10 0D 0A 0A   00 04 04 03   28 28 28 08
	; 00 00 00 00   08
	cfiName		patch1B
	cfiMultiple	$0A, $00, $00, $00
	cfiDetune	$00, $03, $07, $00
	cfiTotalLv	$24, $13, $2D, $7F
	cfiAttack	$1F, $1F, $1F, $1F
	cfiRateScale	$02, $02, $02, $02
	cfiDecayRate	$10, $0D, $0A, $0A
	cfiAmpMod	$00, $00, $00, $00
	cfiSustainRt	$00, $04, $04, $03
	cfiReleaseRt	$08, $08, $08, $08
	cfiSustainLv	$02, $02, $02, $00
	cfiSSGEG	$00, $00, $00, $00
	cfiAlgorithm	$00
	cfiFeedback	$01

	; Patch 1C
	; 01 21 31 31   1E 1E 14 7F   1F 1F 1F 1F
	; 00 00 00 07   00 00 00 00   02 03 05 35
	; 00 00 00 00   38
	cfiName		patch1C
	cfiMultiple	$01, $01, $01, $01
	cfiDetune	$00, $02, $03, $03
	cfiTotalLv	$1E, $1E, $14, $7F
	cfiAttack	$1F, $1F, $1F, $1F
	cfiRateScale	$00, $00, $00, $00
	cfiDecayRate	$00, $00, $00, $07
	cfiAmpMod	$00, $00, $00, $00
	cfiSustainRt	$00, $00, $00, $00
	cfiReleaseRt	$02, $03, $05, $05
	cfiSustainLv	$00, $00, $00, $03
	cfiSSGEG	$00, $00, $00, $00
	cfiAlgorithm	$00
	cfiFeedback	$07

	; Patch 1D
	; 71 21 42 61   0C 0A 78 78   9F 1F 1F 5F
	; 0C 0C 09 15   05 04 06 06   57 47 47 50
	; 00 00 00 00   2C
	cfiName		patch1D
	cfiMultiple	$01, $01, $02, $01
	cfiDetune	$07, $02, $04, $06
	cfiTotalLv	$0C, $0A, $78, $78
	cfiAttack	$1F, $1F, $1F, $1F
	cfiRateScale	$02, $00, $00, $01
	cfiDecayRate	$0C, $0C, $09, $15
	cfiAmpMod	$00, $00, $00, $00
	cfiSustainRt	$05, $04, $06, $06
	cfiReleaseRt	$07, $07, $07, $00
	cfiSustainLv	$05, $04, $04, $05
	cfiSSGEG	$00, $00, $00, $00
	cfiAlgorithm	$04
	cfiFeedback	$05

	; Patch 1E
	; 01 70 71 00   19 18 7F 7F   DE DC DF DC
	; 06 04 07 05   08 01 08 08   B6 56 B6 B6
	; 00 00 00 00   2C
	cfiName		patch1E
	cfiMultiple	$01, $00, $01, $00
	cfiDetune	$00, $07, $07, $00
	cfiTotalLv	$19, $18, $7F, $7F
	cfiAttack	$1E, $1C, $1F, $1C
	cfiRateScale	$03, $03, $03, $03
	cfiDecayRate	$06, $04, $07, $05
	cfiAmpMod	$00, $00, $00, $00
	cfiSustainRt	$08, $01, $08, $08
	cfiReleaseRt	$06, $06, $06, $06
	cfiSustainLv	$0B, $05, $0B, $0B
	cfiSSGEG	$00, $00, $00, $00
	cfiAlgorithm	$04
	cfiFeedback	$05

	; Patch 1F
	; 01 01 00 01   17 75 7F 75   8F 59 59 59
	; 02 05 05 05   00 00 00 00   18 1C 4C 2C
	; 00 00 00 00   3D
	cfiName		patch1F
	cfiMultiple	$01, $01, $00, $01
	cfiDetune	$00, $00, $00, $00
	cfiTotalLv	$17, $75, $7F, $75
	cfiAttack	$0F, $19, $19, $19
	cfiRateScale	$02, $01, $01, $01
	cfiDecayRate	$02, $05, $05, $05
	cfiAmpMod	$00, $00, $00, $00
	cfiSustainRt	$00, $00, $00, $00
	cfiReleaseRt	$08, $0C, $0C, $0C
	cfiSustainLv	$01, $01, $04, $02
	cfiSSGEG	$00, $00, $00, $00
	cfiAlgorithm	$05
	cfiFeedback	$07

	; Patch 20
	; 70 11 70 11   1E 16 7F 7F   1F 1F 0F 0F
	; 00 00 00 00   00 00 00 00   02 02 09 09
	; 00 00 00 00   3C
	cfiName		patch20
	cfiMultiple	$00, $01, $00, $01
	cfiDetune	$07, $01, $07, $01
	cfiTotalLv	$1E, $16, $7F, $7F
	cfiAttack	$1F, $1F, $0F, $0F
	cfiRateScale	$00, $00, $00, $00
	cfiDecayRate	$00, $00, $00, $00
	cfiAmpMod	$00, $00, $00, $00
	cfiSustainRt	$00, $00, $00, $00
	cfiReleaseRt	$02, $02, $09, $09
	cfiSustainLv	$00, $00, $00, $00
	cfiSSGEG	$00, $00, $00, $00
	cfiAlgorithm	$04
	cfiFeedback	$07

	; Patch 21
	; 06 01 74 03   4C 1A 25 7F   1F 5F 5F 5F
	; 19 04 10 0A   01 02 01 00   24 C4 D4 F5
	; 00 00 00 00   3A
	cfiName		patch21
	cfiMultiple	$06, $01, $04, $03
	cfiDetune	$00, $00, $07, $00
	cfiTotalLv	$4C, $1A, $25, $7F
	cfiAttack	$1F, $1F, $1F, $1F
	cfiRateScale	$00, $01, $01, $01
	cfiDecayRate	$19, $04, $10, $0A
	cfiAmpMod	$00, $00, $00, $00
	cfiSustainRt	$01, $02, $01, $00
	cfiReleaseRt	$04, $04, $04, $05
	cfiSustainLv	$02, $0C, $0D, $0F
	cfiSSGEG	$00, $00, $00, $00
	cfiAlgorithm	$02
	cfiFeedback	$07

	; Patch 22
	; 08 72 05 12   19 6B 7F 6B   1F 0F 0F 0F
	; 00 00 0F 00   00 00 00 00   02 11 39 11
	; 00 00 00 00   3E
	cfiName		patch22
	cfiMultiple	$08, $02, $05, $02
	cfiDetune	$00, $07, $00, $01
	cfiTotalLv	$19, $6B, $7F, $6B
	cfiAttack	$1F, $0F, $0F, $0F
	cfiRateScale	$00, $00, $00, $00
	cfiDecayRate	$00, $00, $0F, $00
	cfiAmpMod	$00, $00, $00, $00
	cfiSustainRt	$00, $00, $00, $00
	cfiReleaseRt	$02, $01, $09, $01
	cfiSustainLv	$00, $01, $03, $01
	cfiSSGEG	$00, $00, $00, $00
	cfiAlgorithm	$06
	cfiFeedback	$07

	; Patch 23
	; 01 01 01 01   19 1E 28 7F   19 19 19 19
	; 00 00 00 00   00 00 00 00   04 04 04 09
	; 00 00 00 00   3B
	cfiName		patch23
	cfiMultiple	$01, $01, $01, $01
	cfiDetune	$00, $00, $00, $00
	cfiTotalLv	$19, $1E, $28, $7F
	cfiAttack	$19, $19, $19, $19
	cfiRateScale	$00, $00, $00, $00
	cfiDecayRate	$00, $00, $00, $00
	cfiAmpMod	$00, $00, $00, $00
	cfiSustainRt	$00, $00, $00, $00
	cfiReleaseRt	$04, $04, $04, $09
	cfiSustainLv	$00, $00, $00, $00
	cfiSSGEG	$00, $00, $00, $00
	cfiAlgorithm	$03
	cfiFeedback	$07

	; Patch 24
	; 7C 36 38 72   1C 1C 7F 7F   DF 5F 5F 1F
	; 0F 12 11 0F   01 0A 0D 05   14 15 3A 3A
	; 00 00 00 00   3C
	cfiName		patch24
	cfiMultiple	$0C, $06, $08, $02
	cfiDetune	$07, $03, $03, $07
	cfiTotalLv	$1C, $1C, $7F, $7F
	cfiAttack	$1F, $1F, $1F, $1F
	cfiRateScale	$03, $01, $01, $00
	cfiDecayRate	$0F, $12, $11, $0F
	cfiAmpMod	$00, $00, $00, $00
	cfiSustainRt	$01, $0A, $0D, $05
	cfiReleaseRt	$04, $05, $0A, $0A
	cfiSustainLv	$01, $01, $03, $03
	cfiSSGEG	$00, $00, $00, $00
	cfiAlgorithm	$04
	cfiFeedback	$07

	; Patch 25
	; 34 76 30 70   2A 20 7F 7F   58 58 D8 98
	; 11 14 04 0C   00 00 00 00   F9 FC F4 F8
	; 00 00 00 00   2C
	cfiName		patch25
	cfiMultiple	$04, $06, $00, $00
	cfiDetune	$03, $07, $03, $07
	cfiTotalLv	$2A, $20, $7F, $7F
	cfiAttack	$18, $18, $18, $18
	cfiRateScale	$01, $01, $03, $02
	cfiDecayRate	$11, $14, $04, $0C
	cfiAmpMod	$00, $00, $00, $00
	cfiSustainRt	$00, $00, $00, $00
	cfiReleaseRt	$09, $0C, $04, $08
	cfiSustainLv	$0F, $0F, $0F, $0F
	cfiSSGEG	$00, $00, $00, $00
	cfiAlgorithm	$04
	cfiFeedback	$05

	; Patch 26
	; 71 21 43 01   1A 1E 32 7F   95 8E 9F 5A
	; 00 00 00 00   09 00 00 00   55 15 8C 07
	; 00 00 00 00   3A
	cfiName		patch26
	cfiMultiple	$01, $01, $03, $01
	cfiDetune	$07, $02, $04, $00
	cfiTotalLv	$1A, $1E, $32, $7F
	cfiAttack	$15, $0E, $1F, $1A
	cfiRateScale	$02, $02, $02, $01
	cfiDecayRate	$00, $00, $00, $00
	cfiAmpMod	$00, $00, $00, $00
	cfiSustainRt	$09, $00, $00, $00
	cfiReleaseRt	$05, $05, $0C, $07
	cfiSustainLv	$05, $01, $08, $00
	cfiSSGEG	$00, $00, $00, $00
	cfiAlgorithm	$02
	cfiFeedback	$07

	; Patch 27
	; 05 31 01 71   15 14 19 7F   1F 1F 1F 1F
	; 13 0B 0A 0E   17 00 00 00   FF FF FF FF
	; 00 00 00 00   3A
	cfiName		patch27
	cfiMultiple	$05, $01, $01, $01
	cfiDetune	$00, $03, $00, $07
	cfiTotalLv	$15, $14, $19, $7F
	cfiAttack	$1F, $1F, $1F, $1F
	cfiRateScale	$00, $00, $00, $00
	cfiDecayRate	$13, $0B, $0A, $0E
	cfiAmpMod	$00, $00, $00, $00
	cfiSustainRt	$17, $00, $00, $00
	cfiReleaseRt	$0F, $0F, $0F, $0F
	cfiSustainLv	$0F, $0F, $0F, $0F
	cfiSSGEG	$00, $00, $00, $00
	cfiAlgorithm	$02
	cfiFeedback	$07

	; Patch 28
	; 14 41 4E 41   0B 23 1A 7F   9F 1F 1F 1F
	; 12 03 06 0C   0F 0C 19 13   FE FF FF 0D
	; 00 00 00 00   3A
	cfiName		patch28
	cfiMultiple	$04, $01, $0E, $01
	cfiDetune	$01, $04, $04, $04
	cfiTotalLv	$0B, $23, $1A, $7F
	cfiAttack	$1F, $1F, $1F, $1F
	cfiRateScale	$02, $00, $00, $00
	cfiDecayRate	$12, $03, $06, $0C
	cfiAmpMod	$00, $00, $00, $00
	cfiSustainRt	$0F, $0C, $19, $13
	cfiReleaseRt	$0E, $0F, $0F, $0D
	cfiSustainLv	$0F, $0F, $0F, $00
	cfiSSGEG	$00, $00, $00, $00
	cfiAlgorithm	$02
	cfiFeedback	$07

	; Patch 29
	; 01 03 04 01   1A 29 22 7F   0E 14 12 1B
	; 00 00 00 00   1F 00 00 00   11 11 11 11
	; 00 00 00 00   02
	cfiName		patch29
	cfiMultiple	$01, $03, $04, $01
	cfiDetune	$00, $00, $00, $00
	cfiTotalLv	$1A, $29, $22, $7F
	cfiAttack	$0E, $14, $12, $1B
	cfiRateScale	$00, $00, $00, $00
	cfiDecayRate	$00, $00, $00, $00
	cfiAmpMod	$00, $00, $00, $00
	cfiSustainRt	$1F, $00, $00, $00
	cfiReleaseRt	$01, $01, $01, $01
	cfiSustainLv	$01, $01, $01, $01
	cfiSSGEG	$00, $00, $00, $00
	cfiAlgorithm	$02
	cfiFeedback	$00

	; Patch 2A
	; 05 01 0A 01   14 26 0A 7F   1C 1B 1A 1F
	; 12 0C 13 0D   00 00 00 00   FF FF FF FF
	; 00 00 00 00   31
	cfiName		patch2A
	cfiMultiple	$05, $01, $0A, $01
	cfiDetune	$00, $00, $00, $00
	cfiTotalLv	$14, $26, $0A, $7F
	cfiAttack	$1C, $1B, $1A, $1F
	cfiRateScale	$00, $00, $00, $00
	cfiDecayRate	$12, $0C, $13, $0D
	cfiAmpMod	$00, $00, $00, $00
	cfiSustainRt	$00, $00, $00, $00
	cfiReleaseRt	$0F, $0F, $0F, $0F
	cfiSustainLv	$0F, $0F, $0F, $0F
	cfiSSGEG	$00, $00, $00, $00
	cfiAlgorithm	$01
	cfiFeedback	$06

	; Patch 2B
	; 05 0A 00 01   15 19 25 7F   1F 1F 1F 1F
	; 10 11 13 08   00 00 00 00   FF FF FF FF
	; 00 00 00 00   01
	cfiName		patch2B
	cfiMultiple	$05, $0A, $00, $01
	cfiDetune	$00, $00, $00, $00
	cfiTotalLv	$15, $19, $25, $7F
	cfiAttack	$1F, $1F, $1F, $1F
	cfiRateScale	$00, $00, $00, $00
	cfiDecayRate	$10, $11, $13, $08
	cfiAmpMod	$00, $00, $00, $00
	cfiSustainRt	$00, $00, $00, $00
	cfiReleaseRt	$0F, $0F, $0F, $0F
	cfiSustainLv	$0F, $0F, $0F, $0F
	cfiSSGEG	$00, $00, $00, $00
	cfiAlgorithm	$01
	cfiFeedback	$00

	; Patch 2C
	; 00 01 06 00   0E 20 23 7F   1F 1F 1F 1F
	; 0E 00 0F 00   00 00 00 00   FF 11 FF 11
	; 00 00 00 00   01
	cfiName		patch2C
	cfiMultiple	$00, $01, $06, $00
	cfiDetune	$00, $00, $00, $00
	cfiTotalLv	$0E, $20, $23, $7F
	cfiAttack	$1F, $1F, $1F, $1F
	cfiRateScale	$00, $00, $00, $00
	cfiDecayRate	$0E, $00, $0F, $00
	cfiAmpMod	$00, $00, $00, $00
	cfiSustainRt	$00, $00, $00, $00
	cfiReleaseRt	$0F, $01, $0F, $01
	cfiSustainLv	$0F, $01, $0F, $01
	cfiSSGEG	$00, $00, $00, $00
	cfiAlgorithm	$01
	cfiFeedback	$00

	; Patch 2D
	; 01 00 01 01   07 17 16 7F   1F 1F 1F 1F
	; 00 00 00 00   00 00 00 00   11 11 11 11
	; 00 00 00 00   32
	cfiName		patch2D
	cfiMultiple	$01, $00, $01, $01
	cfiDetune	$00, $00, $00, $00
	cfiTotalLv	$07, $17, $16, $7F
	cfiAttack	$1F, $1F, $1F, $1F
	cfiRateScale	$00, $00, $00, $00
	cfiDecayRate	$00, $00, $00, $00
	cfiAmpMod	$00, $00, $00, $00
	cfiSustainRt	$00, $00, $00, $00
	cfiReleaseRt	$01, $01, $01, $01
	cfiSustainLv	$01, $01, $01, $01
	cfiSSGEG	$00, $00, $00, $00
	cfiAlgorithm	$02
	cfiFeedback	$06

	; Patch 2E
	; 60 22 30 60   00 19 0E 7F   1C 1F 1A 1F
	; 10 05 12 00   00 00 00 00   E1 F1 FF FF
	; 00 00 00 00   01
	cfiName		patch2E
	cfiMultiple	$00, $02, $00, $00
	cfiDetune	$06, $02, $03, $06
	cfiTotalLv	$00, $19, $0E, $7F
	cfiAttack	$1C, $1F, $1A, $1F
	cfiRateScale	$00, $00, $00, $00
	cfiDecayRate	$10, $05, $12, $00
	cfiAmpMod	$00, $00, $00, $00
	cfiSustainRt	$00, $00, $00, $00
	cfiReleaseRt	$01, $01, $0F, $0F
	cfiSustainLv	$0E, $0F, $0F, $0F
	cfiSSGEG	$00, $00, $00, $00
	cfiAlgorithm	$01
	cfiFeedback	$00

	; Patch 2F
	; 7A 78 16 10   0D 18 13 7F   0C 12 14 16
	; 02 00 02 0A   00 00 00 00   F2 F2 F2 F8
	; 00 00 00 00   3A
	cfiName		patch2F
	cfiMultiple	$0A, $08, $06, $00
	cfiDetune	$07, $07, $01, $01
	cfiTotalLv	$0D, $18, $13, $7F
	cfiAttack	$0C, $12, $14, $16
	cfiRateScale	$00, $00, $00, $00
	cfiDecayRate	$02, $00, $02, $0A
	cfiAmpMod	$00, $00, $00, $00
	cfiSustainRt	$00, $00, $00, $00
	cfiReleaseRt	$02, $02, $02, $08
	cfiSustainLv	$0F, $0F, $0F, $0F
	cfiSSGEG	$00, $00, $00, $00
	cfiAlgorithm	$02
	cfiFeedback	$07

	; Patch 30
	; 75 60 10 00   08 12 22 7F   0F 08 0D 0E
	; 05 01 06 08   01 00 00 00   F5 F2 D5 F7
	; 00 00 00 00   3A
	cfiName		patch30
	cfiMultiple	$05, $00, $00, $00
	cfiDetune	$07, $06, $01, $00
	cfiTotalLv	$08, $12, $22, $7F
	cfiAttack	$0F, $08, $0D, $0E
	cfiRateScale	$00, $00, $00, $00
	cfiDecayRate	$05, $01, $06, $08
	cfiAmpMod	$00, $00, $00, $00
	cfiSustainRt	$01, $00, $00, $00
	cfiReleaseRt	$05, $02, $05, $07
	cfiSustainLv	$0F, $0F, $0D, $0F
	cfiSSGEG	$00, $00, $00, $00
	cfiAlgorithm	$02
	cfiFeedback	$07

	; Patch 31
	; 41 49 40 40   00 05 05 7F   D1 0F 0D 0E
	; 02 02 03 01   01 00 00 00   F5 F2 D4 F7
	; 00 00 00 00   00
	cfiName		patch31
	cfiMultiple	$01, $09, $00, $00
	cfiDetune	$04, $04, $04, $04
	cfiTotalLv	$00, $05, $05, $7F
	cfiAttack	$11, $0F, $0D, $0E
	cfiRateScale	$03, $00, $00, $00
	cfiDecayRate	$02, $02, $03, $01
	cfiAmpMod	$00, $00, $00, $00
	cfiSustainRt	$01, $00, $00, $00
	cfiReleaseRt	$05, $02, $04, $07
	cfiSustainLv	$0F, $0F, $0D, $0F
	cfiSSGEG	$00, $00, $00, $00
	cfiAlgorithm	$00
	cfiFeedback	$00

	; Patch 32
	; 40 43 40 40   00 23 16 7F   1F 1F 1F 12
	; 12 02 06 01   01 00 00 00   F5 F2 D4 FB
	; 00 00 00 00   10
	cfiName		patch32
	cfiMultiple	$00, $03, $00, $00
	cfiDetune	$04, $04, $04, $04
	cfiTotalLv	$00, $23, $16, $7F
	cfiAttack	$1F, $1F, $1F, $12
	cfiRateScale	$00, $00, $00, $00
	cfiDecayRate	$12, $02, $06, $01
	cfiAmpMod	$00, $00, $00, $00
	cfiSustainRt	$01, $00, $00, $00
	cfiReleaseRt	$05, $02, $04, $0B
	cfiSustainLv	$0F, $0F, $0D, $0F
	cfiSSGEG	$00, $00, $00, $00
	cfiAlgorithm	$00
	cfiFeedback	$02

	; Patch 33
	; 0F 60 02 00   00 00 00 7F   1F 1F 0A 1F
	; 15 04 07 00   00 00 00 00   FF A1 B7 11
	; 00 00 00 00   39
	cfiName		patch33
	cfiMultiple	$0F, $00, $02, $00
	cfiDetune	$00, $06, $00, $00
	cfiTotalLv	$00, $00, $00, $7F
	cfiAttack	$1F, $1F, $0A, $1F
	cfiRateScale	$00, $00, $00, $00
	cfiDecayRate	$15, $04, $07, $00
	cfiAmpMod	$00, $00, $00, $00
	cfiSustainRt	$00, $00, $00, $00
	cfiReleaseRt	$0F, $01, $07, $01
	cfiSustainLv	$0F, $0A, $0B, $01
	cfiSSGEG	$00, $00, $00, $00
	cfiAlgorithm	$01
	cfiFeedback	$07

	; Patch 34
	; 01 00 01 01   01 22 16 7F   1F 1F 1F 1F
	; 0C 07 0A 08   00 00 00 00   F3 F9 FA F9
	; 00 00 00 00   32
	cfiName		patch34
	cfiMultiple	$01, $00, $01, $01
	cfiDetune	$00, $00, $00, $00
	cfiTotalLv	$01, $22, $16, $7F
	cfiAttack	$1F, $1F, $1F, $1F
	cfiRateScale	$00, $00, $00, $00
	cfiDecayRate	$0C, $07, $0A, $08
	cfiAmpMod	$00, $00, $00, $00
	cfiSustainRt	$00, $00, $00, $00
	cfiReleaseRt	$03, $09, $0A, $09
	cfiSustainLv	$0F, $0F, $0F, $0F
	cfiSSGEG	$00, $00, $00, $00
	cfiAlgorithm	$02
	cfiFeedback	$06

	; Patch 35
	; 56 29 58 51   1C 7A 76 7F   12 15 14 12
	; 00 00 00 00   00 00 00 00   13 0A 0A 0A
	; 00 00 00 00   3E
	cfiName		patch35
	cfiMultiple	$06, $09, $08, $01
	cfiDetune	$05, $02, $05, $05
	cfiTotalLv	$1C, $7A, $76, $7F
	cfiAttack	$12, $15, $14, $12
	cfiRateScale	$00, $00, $00, $00
	cfiDecayRate	$00, $00, $00, $00
	cfiAmpMod	$00, $00, $00, $00
	cfiSustainRt	$00, $00, $00, $00
	cfiReleaseRt	$03, $0A, $0A, $0A
	cfiSustainLv	$01, $00, $00, $00
	cfiSSGEG	$00, $00, $00, $00
	cfiAlgorithm	$06
	cfiFeedback	$07

	; Patch 36
	; 00 62 61 41   0E 13 18 7F   3F 1F 1F 1F
	; 09 0C 09 01   01 00 00 00   D4 D4 B4 D6
	; 00 00 00 00   38
	cfiName		patch36
	cfiMultiple	$00, $02, $01, $01
	cfiDetune	$00, $06, $06, $04
	cfiTotalLv	$0E, $13, $18, $7F
	cfiAttack	$3F, $1F, $1F, $1F
	cfiRateScale	$00, $00, $00, $00
	cfiDecayRate	$09, $0C, $09, $01
	cfiAmpMod	$00, $00, $00, $00
	cfiSustainRt	$01, $00, $00, $00
	cfiReleaseRt	$04, $04, $04, $06
	cfiSustainLv	$0D, $0D, $0B, $0D
	cfiSSGEG	$00, $00, $00, $00
	cfiAlgorithm	$00
	cfiFeedback	$07

	; Patch 37
	; 0A 00 01 01   20 13 07 7F   13 1F 1F 1F
	; 0E 11 00 0A   00 00 00 00   FF FF FF FF
	; 00 00 00 00   3A
	cfiName		patch37
	cfiMultiple	$0A, $00, $01, $01
	cfiDetune	$00, $00, $00, $00
	cfiTotalLv	$20, $13, $07, $7F
	cfiAttack	$13, $1F, $1F, $1F
	cfiRateScale	$00, $00, $00, $00
	cfiDecayRate	$0E, $11, $00, $0A
	cfiAmpMod	$00, $00, $00, $00
	cfiSustainRt	$00, $00, $00, $00
	cfiReleaseRt	$0F, $0F, $0F, $0F
	cfiSustainLv	$0F, $0F, $0F, $0F
	cfiSSGEG	$00, $00, $00, $00
	cfiAlgorithm	$02
	cfiFeedback	$07

	; Patch 38
	; 0E 07 00 02   26 10 18 7F   1F 1F 1F 1F
	; 00 00 00 00   00 00 00 00   11 11 11 11
	; 00 00 00 00   38
	cfiName		patch38
	cfiMultiple	$0E, $07, $00, $02
	cfiDetune	$00, $00, $00, $00
	cfiTotalLv	$26, $10, $18, $7F
	cfiAttack	$1F, $1F, $1F, $1F
	cfiRateScale	$00, $00, $00, $00
	cfiDecayRate	$00, $00, $00, $00
	cfiAmpMod	$00, $00, $00, $00
	cfiSustainRt	$00, $00, $00, $00
	cfiReleaseRt	$01, $01, $01, $01
	cfiSustainLv	$01, $01, $01, $01
	cfiSSGEG	$00, $00, $00, $00
	cfiAlgorithm	$00
	cfiFeedback	$07

	; Patch 39
	; 20 10 10 00   14 0D 0F 7F   51 1F 16 16
	; 08 06 06 01   07 06 06 0D   44 44 14 6A
	; 00 00 00 00   35
	cfiName		patch39
	cfiMultiple	$00, $00, $00, $00
	cfiDetune	$02, $01, $01, $00
	cfiTotalLv	$14, $0D, $0F, $7F
	cfiAttack	$11, $1F, $16, $16
	cfiRateScale	$01, $00, $00, $00
	cfiDecayRate	$08, $06, $06, $01
	cfiAmpMod	$00, $00, $00, $00
	cfiSustainRt	$07, $06, $06, $0D
	cfiReleaseRt	$04, $04, $04, $0A
	cfiSustainLv	$04, $04, $01, $06
	cfiSSGEG	$00, $00, $00, $00
	cfiAlgorithm	$05
	cfiFeedback	$06

	; Patch 3A
	; 25 45 11 51   0B 04 76 7F   1F 18 1F 1F
	; 11 17 05 0F   00 00 00 00   FF 59 FE 59
	; 00 00 00 00   34
	cfiName		patch3A
	cfiMultiple	$05, $05, $01, $01
	cfiDetune	$02, $04, $01, $05
	cfiTotalLv	$0B, $04, $76, $7F
	cfiAttack	$1F, $18, $1F, $1F
	cfiRateScale	$00, $00, $00, $00
	cfiDecayRate	$11, $17, $05, $0F
	cfiAmpMod	$00, $00, $00, $00
	cfiSustainRt	$00, $00, $00, $00
	cfiReleaseRt	$0F, $09, $0E, $09
	cfiSustainLv	$0F, $05, $0F, $05
	cfiSSGEG	$00, $00, $00, $00
	cfiAlgorithm	$04
	cfiFeedback	$06

	; Patch 3B
	; 41 41 41 41   7F 7F 7F 7F   DF DF DF DF
	; 1F 1F 1F 1F   00 00 00 00   FF FF FF FF
	; 00 00 00 00   00
	cfiName		patch3B
	cfiMultiple	$01, $01, $01, $01
	cfiDetune	$04, $04, $04, $04
	cfiTotalLv	$7F, $7F, $7F, $7F
	cfiAttack	$1F, $1F, $1F, $1F
	cfiRateScale	$03, $03, $03, $03
	cfiDecayRate	$1F, $1F, $1F, $1F
	cfiAmpMod	$00, $00, $00, $00
	cfiSustainRt	$00, $00, $00, $00
	cfiReleaseRt	$0F, $0F, $0F, $0F
	cfiSustainLv	$0F, $0F, $0F, $0F
	cfiSSGEG	$00, $00, $00, $00
	cfiAlgorithm	$00
	cfiFeedback	$00

	; Patch 3C
	; 1B 7B 10 00   08 0F 23 7F   1F 1F 1F 1F
	; 0E 00 0C 0A   00 00 00 1E   FF 11 91 D1
	; 00 00 00 00   3A
	cfiName		patch3C
	cfiMultiple	$0B, $0B, $00, $00
	cfiDetune	$01, $07, $01, $00
	cfiTotalLv	$08, $0F, $23, $7F
	cfiAttack	$1F, $1F, $1F, $1F
	cfiRateScale	$00, $00, $00, $00
	cfiDecayRate	$0E, $00, $0C, $0A
	cfiAmpMod	$00, $00, $00, $00
	cfiSustainRt	$00, $00, $00, $1E
	cfiReleaseRt	$0F, $01, $01, $01
	cfiSustainLv	$0F, $01, $09, $0D
	cfiSSGEG	$00, $00, $00, $00
	cfiAlgorithm	$02
	cfiFeedback	$07

	; Patch 3D
	; 51 60 7A 40   0D 15 11 7F   0C 1F 13 1F
	; 05 00 01 00   00 00 00 00   FF FF FF FF
	; 00 00 00 00   3B
	cfiName		patch3D
	cfiMultiple	$01, $00, $0A, $00
	cfiDetune	$05, $06, $07, $04
	cfiTotalLv	$0D, $15, $11, $7F
	cfiAttack	$0C, $1F, $13, $1F
	cfiRateScale	$00, $00, $00, $00
	cfiDecayRate	$05, $00, $01, $00
	cfiAmpMod	$00, $00, $00, $00
	cfiSustainRt	$00, $00, $00, $00
	cfiReleaseRt	$0F, $0F, $0F, $0F
	cfiSustainLv	$0F, $0F, $0F, $0F
	cfiSSGEG	$00, $00, $00, $00
	cfiAlgorithm	$03
	cfiFeedback	$07

	; Patch 3E
	; 7F 43 51 43   0B 04 7F 7F   1F 1E 1E 10
	; 04 01 01 01   01 01 01 01   B4 B4 21 21
	; 00 00 00 00   3C
	cfiName		patch3E
	cfiMultiple	$0F, $03, $01, $03
	cfiDetune	$07, $04, $05, $04
	cfiTotalLv	$0B, $04, $7F, $7F
	cfiAttack	$1F, $1E, $1E, $10
	cfiRateScale	$00, $00, $00, $00
	cfiDecayRate	$04, $01, $01, $01
	cfiAmpMod	$00, $00, $00, $00
	cfiSustainRt	$01, $01, $01, $01
	cfiReleaseRt	$04, $04, $01, $01
	cfiSustainLv	$0B, $0B, $02, $02
	cfiSSGEG	$00, $00, $00, $00
	cfiAlgorithm	$04
	cfiFeedback	$07

	; Patch 3F
	; 48 41 43 40   2F 18 1E 7F   11 12 13 12
	; 0E 08 14 0A   00 00 00 00   FA F6 F5 AB
	; 00 00 00 00   02
	cfiName		patch3F
	cfiMultiple	$08, $01, $03, $00
	cfiDetune	$04, $04, $04, $04
	cfiTotalLv	$2F, $18, $1E, $7F
	cfiAttack	$11, $12, $13, $12
	cfiRateScale	$00, $00, $00, $00
	cfiDecayRate	$0E, $08, $14, $0A
	cfiAmpMod	$00, $00, $00, $00
	cfiSustainRt	$00, $00, $00, $00
	cfiReleaseRt	$0A, $06, $05, $0B
	cfiSustainLv	$0F, $0F, $0F, $0A
	cfiSSGEG	$00, $00, $00, $00
	cfiAlgorithm	$02
	cfiFeedback	$00

	; Patch 40
	; 0A 01 08 02   28 24 23 7F   14 10 14 0E
	; 05 02 08 08   00 00 00 00   99 09 09 19
	; 00 00 00 00   38
	cfiName		patch40
	cfiMultiple	$0A, $01, $08, $02
	cfiDetune	$00, $00, $00, $00
	cfiTotalLv	$28, $24, $23, $7F
	cfiAttack	$14, $10, $14, $0E
	cfiRateScale	$00, $00, $00, $00
	cfiDecayRate	$05, $02, $08, $08
	cfiAmpMod	$00, $00, $00, $00
	cfiSustainRt	$00, $00, $00, $00
	cfiReleaseRt	$09, $09, $09, $09
	cfiSustainLv	$09, $00, $00, $01
	cfiSSGEG	$00, $00, $00, $00
	cfiAlgorithm	$00
	cfiFeedback	$07

	; Patch 41
	; 31 34 32 31   27 33 24 7F   5F 5F 13 53
	; 00 0F 0B 0F   00 00 00 00   00 07 49 06
	; 00 00 00 00   3B
	cfiName		patch41
	cfiMultiple	$01, $04, $02, $01
	cfiDetune	$03, $03, $03, $03
	cfiTotalLv	$27, $33, $24, $7F
	cfiAttack	$1F, $1F, $13, $13
	cfiRateScale	$01, $01, $00, $01
	cfiDecayRate	$00, $0F, $0B, $0F
	cfiAmpMod	$00, $00, $00, $00
	cfiSustainRt	$00, $00, $00, $00
	cfiReleaseRt	$00, $07, $09, $06
	cfiSustainLv	$00, $00, $04, $00
	cfiSSGEG	$00, $00, $00, $00
	cfiAlgorithm	$03
	cfiFeedback	$07

	; Patch 42
	; 20 40 33 32   14 7F 7F 5F   1D 1F 1F 03
	; 0D 12 11 00   00 00 00 00   5A 38 18 18
	; 00 00 00 00   2D
	cfiName		patch42
	cfiMultiple	$00, $00, $03, $02
	cfiDetune	$02, $04, $03, $03
	cfiTotalLv	$14, $7F, $7F, $5F
	cfiAttack	$1D, $1F, $1F, $03
	cfiRateScale	$00, $00, $00, $00
	cfiDecayRate	$0D, $12, $11, $00
	cfiAmpMod	$00, $00, $00, $00
	cfiSustainRt	$00, $00, $00, $00
	cfiReleaseRt	$0A, $08, $08, $08
	cfiSustainLv	$05, $03, $01, $01
	cfiSSGEG	$00, $00, $00, $00
	cfiAlgorithm	$05
	cfiFeedback	$05

	; Patch 43
	; 20 40 30 00   00 7F 7F 7F   5F 1D 1F 1F
	; 0A 0C 0D 07   00 00 00 00   50 3F 1F 1F
	; 00 00 00 00   05
	cfiName		patch43
	cfiMultiple	$00, $00, $00, $00
	cfiDetune	$02, $04, $03, $00
	cfiTotalLv	$00, $7F, $7F, $7F
	cfiAttack	$1F, $1D, $1F, $1F
	cfiRateScale	$01, $00, $00, $00
	cfiDecayRate	$0A, $0C, $0D, $07
	cfiAmpMod	$00, $00, $00, $00
	cfiSustainRt	$00, $00, $00, $00
	cfiReleaseRt	$00, $0F, $0F, $0F
	cfiSustainLv	$05, $03, $01, $01
	cfiSSGEG	$00, $00, $00, $00
	cfiAlgorithm	$05
	cfiFeedback	$00

	; Patch 44
	; 01 30 00 60   19 7F 7F 7F   16 14 15 0E
	; 18 19 13 0D   00 1B 05 05   0C 3C 2C FC
	; 00 00 00 00   05
	cfiName		patch44
	cfiMultiple	$01, $00, $00, $00
	cfiDetune	$00, $03, $00, $06
	cfiTotalLv	$19, $7F, $7F, $7F
	cfiAttack	$16, $14, $15, $0E
	cfiRateScale	$00, $00, $00, $00
	cfiDecayRate	$18, $19, $13, $0D
	cfiAmpMod	$00, $00, $00, $00
	cfiSustainRt	$00, $1B, $05, $05
	cfiReleaseRt	$0C, $0C, $0C, $0C
	cfiSustainLv	$00, $03, $02, $0F
	cfiSSGEG	$00, $00, $00, $00
	cfiAlgorithm	$05
	cfiFeedback	$00

	; Patch 45
	; 61 10 6B 6C   13 13 1B 7F   10 51 91 11
	; 0E 0E 0E 03   00 00 00 00   FE FD FD FE
	; 00 00 00 00   3A
	cfiName		patch45
	cfiMultiple	$01, $00, $0B, $0C
	cfiDetune	$06, $01, $06, $06
	cfiTotalLv	$13, $13, $1B, $7F
	cfiAttack	$10, $11, $11, $11
	cfiRateScale	$00, $01, $02, $00
	cfiDecayRate	$0E, $0E, $0E, $03
	cfiAmpMod	$00, $00, $00, $00
	cfiSustainRt	$00, $00, $00, $00
	cfiReleaseRt	$0E, $0D, $0D, $0E
	cfiSustainLv	$0F, $0F, $0F, $0F
	cfiSSGEG	$00, $00, $00, $00
	cfiAlgorithm	$02
	cfiFeedback	$07

	; Patch 46
	; 41 41 51 31   1A 14 7F 7F   50 50 14 14
	; 05 05 01 01   01 01 01 01   18 18 18 18
	; 00 00 00 00   3C
	cfiName		patch46
	cfiMultiple	$01, $01, $01, $01
	cfiDetune	$04, $04, $05, $03
	cfiTotalLv	$1A, $14, $7F, $7F
	cfiAttack	$10, $10, $14, $14
	cfiRateScale	$01, $01, $00, $00
	cfiDecayRate	$05, $05, $01, $01
	cfiAmpMod	$00, $00, $00, $00
	cfiSustainRt	$01, $01, $01, $01
	cfiReleaseRt	$08, $08, $08, $08
	cfiSustainLv	$01, $01, $01, $01
	cfiSSGEG	$00, $00, $00, $00
	cfiAlgorithm	$04
	cfiFeedback	$07

	; Patch 47
	; 41 0B 41 43   1F 35 7F 7F   0E 58 10 19
	; 05 0B 01 0A   01 01 01 0A   F8 76 F8 16
	; 00 00 00 00   3C
	cfiName		patch47
	cfiMultiple	$01, $0B, $01, $03
	cfiDetune	$04, $00, $04, $04
	cfiTotalLv	$1F, $35, $7F, $7F
	cfiAttack	$0E, $18, $10, $19
	cfiRateScale	$00, $01, $00, $00
	cfiDecayRate	$05, $0B, $01, $0A
	cfiAmpMod	$00, $00, $00, $00
	cfiSustainRt	$01, $01, $01, $0A
	cfiReleaseRt	$08, $06, $08, $06
	cfiSustainLv	$0F, $07, $0F, $01
	cfiSSGEG	$00, $00, $00, $00
	cfiAlgorithm	$04
	cfiFeedback	$07

	; Patch 48
	; 40 30 40 41   0C 01 01 7F   5F 5F 5F 5F
	; 0A 1F 02 0D   07 07 00 07   A0 F9 F9 F9
	; 00 00 00 00   2D
	cfiName		patch48
	cfiMultiple	$00, $00, $00, $01
	cfiDetune	$04, $03, $04, $04
	cfiTotalLv	$0C, $01, $01, $7F
	cfiAttack	$1F, $1F, $1F, $1F
	cfiRateScale	$01, $01, $01, $01
	cfiDecayRate	$0A, $1F, $02, $0D
	cfiAmpMod	$00, $00, $00, $00
	cfiSustainRt	$07, $07, $00, $07
	cfiReleaseRt	$00, $09, $09, $09
	cfiSustainLv	$0A, $0F, $0F, $0F
	cfiSSGEG	$00, $00, $00, $00
	cfiAlgorithm	$05
	cfiFeedback	$05

	; Patch 49
	; 7B 40 5B 40   21 01 01 7F   9F 1F 1F 1F
	; 0F 05 0B 0C   0F 0C 19 0D   F9 F9 F5 06
	; 00 00 00 00   3A
	cfiName		patch49
	cfiMultiple	$0B, $00, $0B, $00
	cfiDetune	$07, $04, $05, $04
	cfiTotalLv	$21, $01, $01, $7F
	cfiAttack	$1F, $1F, $1F, $1F
	cfiRateScale	$02, $00, $00, $00
	cfiDecayRate	$0F, $05, $0B, $0C
	cfiAmpMod	$00, $00, $00, $00
	cfiSustainRt	$0F, $0C, $19, $0D
	cfiReleaseRt	$09, $09, $05, $06
	cfiSustainLv	$0F, $0F, $0F, $00
	cfiSSGEG	$00, $00, $00, $00
	cfiAlgorithm	$02
	cfiFeedback	$07

	; Patch 4A
	; 30 60 60 64   0E 06 14 7F   4C 9D 50 9D
	; 05 06 04 04   01 05 01 1F   55 25 25 A8
	; 00 00 00 00   3A
	cfiName		patch4A
	cfiMultiple	$00, $00, $00, $04
	cfiDetune	$03, $06, $06, $06
	cfiTotalLv	$0E, $06, $14, $7F
	cfiAttack	$0C, $1D, $10, $1D
	cfiRateScale	$01, $02, $01, $02
	cfiDecayRate	$05, $06, $04, $04
	cfiAmpMod	$00, $00, $00, $00
	cfiSustainRt	$01, $05, $01, $1F
	cfiReleaseRt	$05, $05, $05, $08
	cfiSustainLv	$05, $02, $02, $0A
	cfiSSGEG	$00, $00, $00, $00
	cfiAlgorithm	$02
	cfiFeedback	$07

	; Patch 4B
	; 01 61 30 60   0D 7F 7F 7F   16 14 19 19
	; 03 06 05 08   00 00 00 00   66 47 26 26
	; 00 00 00 00   3D
	cfiName		patch4B
	cfiMultiple	$01, $01, $00, $00
	cfiDetune	$00, $06, $03, $06
	cfiTotalLv	$0D, $7F, $7F, $7F
	cfiAttack	$16, $14, $19, $19
	cfiRateScale	$00, $00, $00, $00
	cfiDecayRate	$03, $06, $05, $08
	cfiAmpMod	$00, $00, $00, $00
	cfiSustainRt	$00, $00, $00, $00
	cfiReleaseRt	$06, $07, $06, $06
	cfiSustainLv	$06, $04, $02, $02
	cfiSSGEG	$00, $00, $00, $00
	cfiAlgorithm	$05
	cfiFeedback	$07

	; Patch 4C
	; 01 01 01 01   00 00 7F 7F   1F 1F 1F 1F
	; 00 00 00 00   00 00 00 00   0F 0F 0F 0F
	; 00 00 00 00   07
	cfiName		patch4C
	cfiMultiple	$01, $01, $01, $01
	cfiDetune	$00, $00, $00, $00
	cfiTotalLv	$00, $00, $7F, $7F
	cfiAttack	$1F, $1F, $1F, $1F
	cfiRateScale	$00, $00, $00, $00
	cfiDecayRate	$00, $00, $00, $00
	cfiAmpMod	$00, $00, $00, $00
	cfiSustainRt	$00, $00, $00, $00
	cfiReleaseRt	$0F, $0F, $0F, $0F
	cfiSustainLv	$00, $00, $00, $00
	cfiSSGEG	$00, $00, $00, $00
	cfiAlgorithm	$07
	cfiFeedback	$00

	; Patch 4D
	; 28 75 73 18   04 3E 3D 7F   0D 10 8C 09
	; 00 00 00 04   00 00 00 08   00 00 00 5C
	; 00 00 00 00   32
	cfiName		patch4D
	cfiMultiple	$08, $05, $03, $08
	cfiDetune	$02, $07, $07, $01
	cfiTotalLv	$04, $3E, $3D, $7F
	cfiAttack	$0D, $10, $0C, $09
	cfiRateScale	$00, $00, $02, $00
	cfiDecayRate	$00, $00, $00, $04
	cfiAmpMod	$00, $00, $00, $00
	cfiSustainRt	$00, $00, $00, $08
	cfiReleaseRt	$00, $00, $00, $0C
	cfiSustainLv	$00, $00, $00, $05
	cfiSSGEG	$00, $00, $00, $00
	cfiAlgorithm	$02
	cfiFeedback	$06

	; Patch 4E
	; 7F 3B 70 4F   06 19 17 7E   12 50 15 48
	; 00 00 00 03   00 00 00 04   03 04 03 0F
	; 00 00 00 00   2B
	cfiName		patch4E
	cfiMultiple	$0F, $0B, $00, $0F
	cfiDetune	$07, $03, $07, $04
	cfiTotalLv	$06, $19, $17, $7E
	cfiAttack	$12, $10, $15, $08
	cfiRateScale	$00, $01, $00, $01
	cfiDecayRate	$00, $00, $00, $03
	cfiAmpMod	$00, $00, $00, $00
	cfiSustainRt	$00, $00, $00, $04
	cfiReleaseRt	$03, $04, $03, $0F
	cfiSustainLv	$00, $00, $00, $00
	cfiSSGEG	$00, $00, $00, $00
	cfiAlgorithm	$03
	cfiFeedback	$05

	; Patch 4F
	; 01 01 01 01   18 1D 7F 7F   9F 9F 1F 5F
	; 00 00 00 00   00 00 00 00   1F 1F 0F 0F
	; 00 00 00 00   3A
	cfiName		patch4F
	cfiMultiple	$01, $01, $01, $01
	cfiDetune	$00, $00, $00, $00
	cfiTotalLv	$18, $1D, $7F, $7F
	cfiAttack	$1F, $1F, $1F, $1F
	cfiRateScale	$02, $02, $00, $01
	cfiDecayRate	$00, $00, $00, $00
	cfiAmpMod	$00, $00, $00, $00
	cfiSustainRt	$00, $00, $00, $00
	cfiReleaseRt	$0F, $0F, $0F, $0F
	cfiSustainLv	$01, $01, $00, $00
	cfiSSGEG	$00, $00, $00, $00
	cfiAlgorithm	$02
	cfiFeedback	$07

	; Patch 50
	; 00 00 02 02   32 23 7F 75   1F 1F 1F 1F
	; 00 00 00 00   00 00 00 00   0F 0F 0F 0F
	; 00 00 00 00   3C
	cfiName		patch50
	cfiMultiple	$00, $00, $02, $02
	cfiDetune	$00, $00, $00, $00
	cfiTotalLv	$32, $23, $7F, $75
	cfiAttack	$1F, $1F, $1F, $1F
	cfiRateScale	$00, $00, $00, $00
	cfiDecayRate	$00, $00, $00, $00
	cfiAmpMod	$00, $00, $00, $00
	cfiSustainRt	$00, $00, $00, $00
	cfiReleaseRt	$0F, $0F, $0F, $0F
	cfiSustainLv	$00, $00, $00, $00
	cfiSSGEG	$00, $00, $00, $00
	cfiAlgorithm	$04
	cfiFeedback	$07

	; Patch 51
	; 01 03 01 01   23 17 2E 7F   1F 1F 1F 1F
	; 00 00 00 00   00 00 00 00   0F 0F 0F 0F
	; 00 00 00 00   00
	cfiName		patch51
	cfiMultiple	$01, $03, $01, $01
	cfiDetune	$00, $00, $00, $00
	cfiTotalLv	$23, $17, $2E, $7F
	cfiAttack	$1F, $1F, $1F, $1F
	cfiRateScale	$00, $00, $00, $00
	cfiDecayRate	$00, $00, $00, $00
	cfiAmpMod	$00, $00, $00, $00
	cfiSustainRt	$00, $00, $00, $00
	cfiReleaseRt	$0F, $0F, $0F, $0F
	cfiSustainLv	$00, $00, $00, $00
	cfiSSGEG	$00, $00, $00, $00
	cfiAlgorithm	$00
	cfiFeedback	$00

	; Patch 52
	; 03 02 70 30   10 19 7F 7F   1F 1F 0C 0A
	; 00 00 0A 06   00 00 00 00   02 22 17 47
	; 00 00 00 00   3C
	cfiName		patch52
	cfiMultiple	$03, $02, $00, $00
	cfiDetune	$00, $00, $07, $03
	cfiTotalLv	$10, $19, $7F, $7F
	cfiAttack	$1F, $1F, $0C, $0A
	cfiRateScale	$00, $00, $00, $00
	cfiDecayRate	$00, $00, $0A, $06
	cfiAmpMod	$00, $00, $00, $00
	cfiSustainRt	$00, $00, $00, $00
	cfiReleaseRt	$02, $02, $07, $07
	cfiSustainLv	$00, $02, $01, $04
	cfiSSGEG	$00, $00, $00, $00
	cfiAlgorithm	$04
	cfiFeedback	$07

	; Patch 53
	; 0F 04 02 02   0E 0D 7F 7F   1F 1F 1F 1F
	; 00 00 0C 0E   00 00 0B 0A   0F 0F 4F 4F
	; 00 00 00 00   04
	cfiName		patch53
	cfiMultiple	$0F, $04, $02, $02
	cfiDetune	$00, $00, $00, $00
	cfiTotalLv	$0E, $0D, $7F, $7F
	cfiAttack	$1F, $1F, $1F, $1F
	cfiRateScale	$00, $00, $00, $00
	cfiDecayRate	$00, $00, $0C, $0E
	cfiAmpMod	$00, $00, $00, $00
	cfiSustainRt	$00, $00, $0B, $0A
	cfiReleaseRt	$0F, $0F, $0F, $0F
	cfiSustainLv	$00, $00, $04, $04
	cfiSSGEG	$00, $00, $00, $00
	cfiAlgorithm	$04
	cfiFeedback	$00

	; Patch 54
	; 0E 01 02 08   32 75 75 6B   92 15 14 12
	; 0A 00 00 00   00 00 00 00   11 08 08 08
	; 00 00 00 00   06
	cfiName		patch54
	cfiMultiple	$0E, $01, $02, $08
	cfiDetune	$00, $00, $00, $00
	cfiTotalLv	$32, $75, $75, $6B
	cfiAttack	$12, $15, $14, $12
	cfiRateScale	$02, $00, $00, $00
	cfiDecayRate	$0A, $00, $00, $00
	cfiAmpMod	$00, $00, $00, $00
	cfiSustainRt	$00, $00, $00, $00
	cfiReleaseRt	$01, $08, $08, $08
	cfiSustainLv	$01, $00, $00, $00
	cfiSSGEG	$00, $00, $00, $00
	cfiAlgorithm	$06
	cfiFeedback	$00

	; Patch 55
	; 02 11 72 01   14 5C 7A 7F   1F 1F 10 14
	; 00 00 0A 00   00 00 00 00   00 00 F6 06
	; 00 00 00 00   34
	cfiName		patch55
	cfiMultiple	$02, $01, $02, $01
	cfiDetune	$00, $01, $07, $00
	cfiTotalLv	$14, $5C, $7A, $7F
	cfiAttack	$1F, $1F, $10, $14
	cfiRateScale	$00, $00, $00, $00
	cfiDecayRate	$00, $00, $0A, $00
	cfiAmpMod	$00, $00, $00, $00
	cfiSustainRt	$00, $00, $00, $00
	cfiReleaseRt	$00, $00, $06, $06
	cfiSustainLv	$00, $00, $0F, $00
	cfiSSGEG	$00, $00, $00, $00
	cfiAlgorithm	$04
	cfiFeedback	$06

	; Patch 56
	; 01 01 01 01   23 2D 1E 7F   0D 0F 10 12
	; 0B 0F 0A 06   00 00 00 00   82 72 12 18
	; 00 00 00 00   3A
	cfiName		patch56
	cfiMultiple	$01, $01, $01, $01
	cfiDetune	$00, $00, $00, $00
	cfiTotalLv	$23, $2D, $1E, $7F
	cfiAttack	$0D, $0F, $10, $12
	cfiRateScale	$00, $00, $00, $00
	cfiDecayRate	$0B, $0F, $0A, $06
	cfiAmpMod	$00, $00, $00, $00
	cfiSustainRt	$00, $00, $00, $00
	cfiReleaseRt	$02, $02, $02, $08
	cfiSustainLv	$08, $07, $01, $01
	cfiSSGEG	$00, $00, $00, $00
	cfiAlgorithm	$02
	cfiFeedback	$07

	; Patch 57
	; 0C 02 0F 02   1B 23 22 7B   9F 9F 9F 5F
	; 05 10 0A 0C   04 06 10 0A   27 17 F7 38
	; 00 00 00 00   3A
	cfiName		patch57
	cfiMultiple	$0C, $02, $0F, $02
	cfiDetune	$00, $00, $00, $00
	cfiTotalLv	$1B, $23, $22, $7B
	cfiAttack	$1F, $1F, $1F, $1F
	cfiRateScale	$02, $02, $02, $01
	cfiDecayRate	$05, $10, $0A, $0C
	cfiAmpMod	$00, $00, $00, $00
	cfiSustainRt	$04, $06, $10, $0A
	cfiReleaseRt	$07, $07, $07, $08
	cfiSustainLv	$02, $01, $0F, $03
	cfiSSGEG	$00, $00, $00, $00
	cfiAlgorithm	$02
	cfiFeedback	$07

	; Patch 58
	; 7C 7C 71 31   31 31 7F 7F   5F 5F 5F 5F
	; 12 16 0C 0C   01 01 02 02   66 86 48 48
	; 00 00 00 00   14
	cfiName		patch58
	cfiMultiple	$0C, $0C, $01, $01
	cfiDetune	$07, $07, $07, $03
	cfiTotalLv	$31, $31, $7F, $7F
	cfiAttack	$1F, $1F, $1F, $1F
	cfiRateScale	$01, $01, $01, $01
	cfiDecayRate	$12, $16, $0C, $0C
	cfiAmpMod	$00, $00, $00, $00
	cfiSustainRt	$01, $01, $02, $02
	cfiReleaseRt	$06, $06, $08, $08
	cfiSustainLv	$06, $08, $04, $04
	cfiSSGEG	$00, $00, $00, $00
	cfiAlgorithm	$04
	cfiFeedback	$02

	; Patch 59
	; 70 21 40 60   0C 10 7F 67   9F 1F 1F 5F
	; 0C 0C 09 15   04 06 04 06   55 45 45 4E
	; 00 00 00 00   2C
	cfiName		patch59
	cfiMultiple	$00, $01, $00, $00
	cfiDetune	$07, $02, $04, $06
	cfiTotalLv	$0C, $10, $7F, $67
	cfiAttack	$1F, $1F, $1F, $1F
	cfiRateScale	$02, $00, $00, $01
	cfiDecayRate	$0C, $0C, $09, $15
	cfiAmpMod	$00, $00, $00, $00
	cfiSustainRt	$04, $06, $04, $06
	cfiReleaseRt	$05, $05, $05, $0E
	cfiSustainLv	$05, $04, $04, $04
	cfiSSGEG	$00, $00, $00, $00
	cfiAlgorithm	$04
	cfiFeedback	$05

	; Patch 5A
	; 39 35 30 31   32 17 14 7F   1F 1F 1F 1F
	; 0C 0A 07 0A   07 07 07 09   36 16 16 F6
	; 00 00 00 00   28
	cfiName		patch5A
	cfiMultiple	$09, $05, $00, $01
	cfiDetune	$03, $03, $03, $03
	cfiTotalLv	$32, $17, $14, $7F
	cfiAttack	$1F, $1F, $1F, $1F
	cfiRateScale	$00, $00, $00, $00
	cfiDecayRate	$0C, $0A, $07, $0A
	cfiAmpMod	$00, $00, $00, $00
	cfiSustainRt	$07, $07, $07, $09
	cfiReleaseRt	$06, $06, $06, $06
	cfiSustainLv	$03, $01, $01, $0F
	cfiSSGEG	$00, $00, $00, $00
	cfiAlgorithm	$00
	cfiFeedback	$05

	; Patch 5B
	; 06 00 00 00   1D 1C 17 7A   1F 1F 1F 1F
	; 11 0B 04 09   13 07 00 03   B5 34 44 15
	; 00 00 00 00   3B
	cfiName		patch5B
	cfiMultiple	$06, $00, $00, $00
	cfiDetune	$00, $00, $00, $00
	cfiTotalLv	$1D, $1C, $17, $7A
	cfiAttack	$1F, $1F, $1F, $1F
	cfiRateScale	$00, $00, $00, $00
	cfiDecayRate	$11, $0B, $04, $09
	cfiAmpMod	$00, $00, $00, $00
	cfiSustainRt	$13, $07, $00, $03
	cfiReleaseRt	$05, $04, $04, $05
	cfiSustainLv	$0B, $03, $04, $01
	cfiSSGEG	$00, $00, $00, $00
	cfiAlgorithm	$03
	cfiFeedback	$07

	; Patch 5C
	; 61 22 00 32   13 1B 14 7F   5F 5F 5F 1F
	; 00 00 00 00   00 00 00 00   03 02 03 06
	; 00 00 00 00   30
	cfiName		patch5C
	cfiMultiple	$01, $02, $00, $02
	cfiDetune	$06, $02, $00, $03
	cfiTotalLv	$13, $1B, $14, $7F
	cfiAttack	$1F, $1F, $1F, $1F
	cfiRateScale	$01, $01, $01, $00
	cfiDecayRate	$00, $00, $00, $00
	cfiAmpMod	$00, $00, $00, $00
	cfiSustainRt	$00, $00, $00, $00
	cfiReleaseRt	$03, $02, $03, $06
	cfiSustainLv	$00, $00, $00, $00
	cfiSSGEG	$00, $00, $00, $00
	cfiAlgorithm	$00
	cfiFeedback	$06

	; Patch 5D
	; 71 31 00 32   0D 14 1B 7F   58 5F 5F 1F
	; 00 00 00 00   00 00 00 00   03 02 03 06
	; 00 00 00 00   30
	cfiName		patch5D
	cfiMultiple	$01, $01, $00, $02
	cfiDetune	$07, $03, $00, $03
	cfiTotalLv	$0D, $14, $1B, $7F
	cfiAttack	$18, $1F, $1F, $1F
	cfiRateScale	$01, $01, $01, $00
	cfiDecayRate	$00, $00, $00, $00
	cfiAmpMod	$00, $00, $00, $00
	cfiSustainRt	$00, $00, $00, $00
	cfiReleaseRt	$03, $02, $03, $06
	cfiSustainLv	$00, $00, $00, $00
	cfiSSGEG	$00, $00, $00, $00
	cfiAlgorithm	$00
	cfiFeedback	$06

	; Patch 5E
	; 3E 41 42 33   14 0A 13 7D   DE 1E 14 14
	; 14 0F 0F 00   01 00 00 00   34 24 23 27
	; 00 00 00 00   3B
	cfiName		patch5E
	cfiMultiple	$0E, $01, $02, $03
	cfiDetune	$03, $04, $04, $03
	cfiTotalLv	$14, $0A, $13, $7D
	cfiAttack	$1E, $1E, $14, $14
	cfiRateScale	$03, $00, $00, $00
	cfiDecayRate	$14, $0F, $0F, $00
	cfiAmpMod	$00, $00, $00, $00
	cfiSustainRt	$01, $00, $00, $00
	cfiReleaseRt	$04, $04, $03, $07
	cfiSustainLv	$03, $02, $02, $02
	cfiSSGEG	$00, $00, $00, $00
	cfiAlgorithm	$03
	cfiFeedback	$07

	; Patch 5F
	; 6F 10 5A 33   25 07 16 7F   06 1F 1E 1E
	; 00 1B 01 1C   00 01 01 01   0F 06 F7 08
	; 00 00 00 00   03
	cfiName		patch5F
	cfiMultiple	$0F, $00, $0A, $03
	cfiDetune	$06, $01, $05, $03
	cfiTotalLv	$25, $07, $16, $7F
	cfiAttack	$06, $1F, $1E, $1E
	cfiRateScale	$00, $00, $00, $00
	cfiDecayRate	$00, $1B, $01, $1C
	cfiAmpMod	$00, $00, $00, $00
	cfiSustainRt	$00, $01, $01, $01
	cfiReleaseRt	$0F, $06, $07, $08
	cfiSustainLv	$00, $00, $0F, $00
	cfiSSGEG	$00, $00, $00, $00
	cfiAlgorithm	$03
	cfiFeedback	$00

	; Patch 60
	; 4E 7E 44 74   23 29 7F 7F   5B 5F 8C 0C
	; 04 07 07 08   00 02 01 03   F6 E5 F7 F7
	; 00 00 00 00   34
	cfiName		patch60
	cfiMultiple	$0E, $0E, $04, $04
	cfiDetune	$04, $07, $04, $07
	cfiTotalLv	$23, $29, $7F, $7F
	cfiAttack	$1B, $1F, $0C, $0C
	cfiRateScale	$01, $01, $02, $00
	cfiDecayRate	$04, $07, $07, $08
	cfiAmpMod	$00, $00, $00, $00
	cfiSustainRt	$00, $02, $01, $03
	cfiReleaseRt	$06, $05, $07, $07
	cfiSustainLv	$0F, $0E, $0F, $0F
	cfiSSGEG	$00, $00, $00, $00
	cfiAlgorithm	$04
	cfiFeedback	$06

	; Patch 61
	; 3D 7D 44 74   23 29 7F 7F   5B 5F 9F 1F
	; 04 07 07 08   00 02 01 03   F6 E5 F7 F7
	; 00 00 00 00   34
	cfiName		patch61
	cfiMultiple	$0D, $0D, $04, $04
	cfiDetune	$03, $07, $04, $07
	cfiTotalLv	$23, $29, $7F, $7F
	cfiAttack	$1B, $1F, $1F, $1F
	cfiRateScale	$01, $01, $02, $00
	cfiDecayRate	$04, $07, $07, $08
	cfiAmpMod	$00, $00, $00, $00
	cfiSustainRt	$00, $02, $01, $03
	cfiReleaseRt	$06, $05, $07, $07
	cfiSustainLv	$0F, $0E, $0F, $0F
	cfiSSGEG	$00, $00, $00, $00
	cfiAlgorithm	$04
	cfiFeedback	$06

	; Patch 62
	; 07 01 02 00   19 7F 77 7F   1F 11 13 0C
	; 0A 00 0A 00   00 00 00 00   12 04 F6 08
	; 00 00 00 00   06
	cfiName		patch62
	cfiMultiple	$07, $01, $02, $00
	cfiDetune	$00, $00, $00, $00
	cfiTotalLv	$19, $7F, $77, $7F
	cfiAttack	$1F, $11, $13, $0C
	cfiRateScale	$00, $00, $00, $00
	cfiDecayRate	$0A, $00, $0A, $00
	cfiAmpMod	$00, $00, $00, $00
	cfiSustainRt	$00, $00, $00, $00
	cfiReleaseRt	$02, $04, $06, $08
	cfiSustainLv	$01, $00, $0F, $00
	cfiSSGEG	$00, $00, $00, $00
	cfiAlgorithm	$06
	cfiFeedback	$00

	; Patch 63
	; 54 61 34 01   06 0E 6B 7F   11 4A 0B 4C
	; 0A 06 0C 03   01 02 00 00   00 28 FF 2A
	; 00 00 00 00   3C
	cfiName		patch63
	cfiMultiple	$04, $01, $04, $01
	cfiDetune	$05, $06, $03, $00
	cfiTotalLv	$06, $0E, $6B, $7F
	cfiAttack	$11, $0A, $0B, $0C
	cfiRateScale	$00, $01, $00, $01
	cfiDecayRate	$0A, $06, $0C, $03
	cfiAmpMod	$00, $00, $00, $00
	cfiSustainRt	$01, $02, $00, $00
	cfiReleaseRt	$00, $08, $0F, $0A
	cfiSustainLv	$00, $02, $0F, $02
	cfiSSGEG	$00, $00, $00, $00
	cfiAlgorithm	$04
	cfiFeedback	$07

	; Patch 64
	; 70 00 00 01   0D 0F 7F 7F   1F 1F 0B 0B
	; 00 00 00 00   00 00 00 00   00 00 06 06
	; 00 00 00 00   04
	cfiName		patch64
	cfiMultiple	$00, $00, $00, $01
	cfiDetune	$07, $00, $00, $00
	cfiTotalLv	$0D, $0F, $7F, $7F
	cfiAttack	$1F, $1F, $0B, $0B
	cfiRateScale	$00, $00, $00, $00
	cfiDecayRate	$00, $00, $00, $00
	cfiAmpMod	$00, $00, $00, $00
	cfiSustainRt	$00, $00, $00, $00
	cfiReleaseRt	$00, $00, $06, $06
	cfiSustainLv	$00, $00, $00, $00
	cfiSSGEG	$00, $00, $00, $00
	cfiAlgorithm	$04
	cfiFeedback	$00

	; Patch 65
	; 0F 42 07 02   14 7F 75 7F   1C 0F 12 0F
	; 0F 00 0F 00   07 00 0F 00   A7 07 A7 07
	; 00 00 00 00   3E
	cfiName		patch65
	cfiMultiple	$0F, $02, $07, $02
	cfiDetune	$00, $04, $00, $00
	cfiTotalLv	$14, $7F, $75, $7F
	cfiAttack	$1C, $0F, $12, $0F
	cfiRateScale	$00, $00, $00, $00
	cfiDecayRate	$0F, $00, $0F, $00
	cfiAmpMod	$00, $00, $00, $00
	cfiSustainRt	$07, $00, $0F, $00
	cfiReleaseRt	$07, $07, $07, $07
	cfiSustainLv	$0A, $00, $0A, $00
	cfiSSGEG	$00, $00, $00, $00
	cfiAlgorithm	$06
	cfiFeedback	$07

	; Patch 66
	; 70 00 76 01   21 26 14 7F   1F 1F 92 1F
	; 0F 05 10 0D   07 03 03 00   28 17 47 37
	; 00 00 00 00   3A
	cfiName		patch66
	cfiMultiple	$00, $00, $06, $01
	cfiDetune	$07, $00, $07, $00
	cfiTotalLv	$21, $26, $14, $7F
	cfiAttack	$1F, $1F, $12, $1F
	cfiRateScale	$00, $00, $02, $00
	cfiDecayRate	$0F, $05, $10, $0D
	cfiAmpMod	$00, $00, $00, $00
	cfiSustainRt	$07, $03, $03, $00
	cfiReleaseRt	$08, $07, $07, $07
	cfiSustainLv	$02, $01, $04, $03
	cfiSSGEG	$00, $00, $00, $00
	cfiAlgorithm	$02
	cfiFeedback	$07

	; Patch 67
	; 0A 30 70 00   24 13 2D 7F   9F 9F 9F 9F
	; 10 0D 0A 0A   00 04 04 03   26 26 26 06
	; 00 00 00 00   08
	cfiName		patch67
	cfiMultiple	$0A, $00, $00, $00
	cfiDetune	$00, $03, $07, $00
	cfiTotalLv	$24, $13, $2D, $7F
	cfiAttack	$1F, $1F, $1F, $1F
	cfiRateScale	$02, $02, $02, $02
	cfiDecayRate	$10, $0D, $0A, $0A
	cfiAmpMod	$00, $00, $00, $00
	cfiSustainRt	$00, $04, $04, $03
	cfiReleaseRt	$06, $06, $06, $06
	cfiSustainLv	$02, $02, $02, $00
	cfiSSGEG	$00, $00, $00, $00
	cfiAlgorithm	$00
	cfiFeedback	$01

	; Patch 68
	; 01 21 31 31   1E 1E 14 7F   1F 1F 1F 1F
	; 00 00 00 07   00 00 00 00   00 01 02 33
	; 00 00 00 00   38
	cfiName		patch68
	cfiMultiple	$01, $01, $01, $01
	cfiDetune	$00, $02, $03, $03
	cfiTotalLv	$1E, $1E, $14, $7F
	cfiAttack	$1F, $1F, $1F, $1F
	cfiRateScale	$00, $00, $00, $00
	cfiDecayRate	$00, $00, $00, $07
	cfiAmpMod	$00, $00, $00, $00
	cfiSustainRt	$00, $00, $00, $00
	cfiReleaseRt	$00, $01, $02, $03
	cfiSustainLv	$00, $00, $00, $03
	cfiSSGEG	$00, $00, $00, $00
	cfiAlgorithm	$00
	cfiFeedback	$07

	; Patch 69
	; 71 21 42 61   0C 0A 78 78   9F 1F 1F 5F
	; 0C 0C 09 15   05 04 06 06   55 45 45 4E
	; 00 00 00 00   2C
	cfiName		patch69
	cfiMultiple	$01, $01, $02, $01
	cfiDetune	$07, $02, $04, $06
	cfiTotalLv	$0C, $0A, $78, $78
	cfiAttack	$1F, $1F, $1F, $1F
	cfiRateScale	$02, $00, $00, $01
	cfiDecayRate	$0C, $0C, $09, $15
	cfiAmpMod	$00, $00, $00, $00
	cfiSustainRt	$05, $04, $06, $06
	cfiReleaseRt	$05, $05, $05, $0E
	cfiSustainLv	$05, $04, $04, $04
	cfiSSGEG	$00, $00, $00, $00
	cfiAlgorithm	$04
	cfiFeedback	$05

	; Patch 6A
	; 3E 41 42 33   14 0A 13 7D   DE 1F 1F 1F
	; 14 0F 0F 0A   01 00 00 00   3C 2C 2C DD
	; 00 00 00 00   3B
	cfiName		patch6A
	cfiMultiple	$0E, $01, $02, $03
	cfiDetune	$03, $04, $04, $03
	cfiTotalLv	$14, $0A, $13, $7D
	cfiAttack	$1E, $1F, $1F, $1F
	cfiRateScale	$03, $00, $00, $00
	cfiDecayRate	$14, $0F, $0F, $0A
	cfiAmpMod	$00, $00, $00, $00
	cfiSustainRt	$01, $00, $00, $00
	cfiReleaseRt	$0C, $0C, $0C, $0D
	cfiSustainLv	$03, $02, $02, $0D
	cfiSSGEG	$00, $00, $00, $00
	cfiAlgorithm	$03
	cfiFeedback	$07

	; Patch 6B
	; 05 0A 00 01   15 19 25 7F   1F 1F 1F 1F
	; 15 15 17 0B   00 00 00 00   FF FF FF FF
	; 00 00 00 00   01
	cfiName		patch6B
	cfiMultiple	$05, $0A, $00, $01
	cfiDetune	$00, $00, $00, $00
	cfiTotalLv	$15, $19, $25, $7F
	cfiAttack	$1F, $1F, $1F, $1F
	cfiRateScale	$00, $00, $00, $00
	cfiDecayRate	$15, $15, $17, $0B
	cfiAmpMod	$00, $00, $00, $00
	cfiSustainRt	$00, $00, $00, $00
	cfiReleaseRt	$0F, $0F, $0F, $0F
	cfiSustainLv	$0F, $0F, $0F, $0F
	cfiSSGEG	$00, $00, $00, $00
	cfiAlgorithm	$01
	cfiFeedback	$00

	; Patch 6C
	; 7F 22 43 01   14 1E 23 7F   9F 8E 9F 5A
	; 0F 0C 0C 0C   09 00 00 00   FF FE FE FE
	; 00 00 00 00   3A
	cfiName		patch6C
	cfiMultiple	$0F, $02, $03, $01
	cfiDetune	$07, $02, $04, $00
	cfiTotalLv	$14, $1E, $23, $7F
	cfiAttack	$1F, $0E, $1F, $1A
	cfiRateScale	$02, $02, $02, $01
	cfiDecayRate	$0F, $0C, $0C, $0C
	cfiAmpMod	$00, $00, $00, $00
	cfiSustainRt	$09, $00, $00, $00
	cfiReleaseRt	$0F, $0E, $0E, $0E
	cfiSustainLv	$0F, $0F, $0F, $0F
	cfiSSGEG	$00, $00, $00, $00
	cfiAlgorithm	$02
	cfiFeedback	$07

	; Patch 6D
	; 25 45 11 51   0B 04 76 7F   1F 18 1F 1F
	; 11 17 05 0F   00 00 00 00   FF 5D FC 5D
	; 00 00 00 00   34
	cfiName		patch6D
	cfiMultiple	$05, $05, $01, $01
	cfiDetune	$02, $04, $01, $05
	cfiTotalLv	$0B, $04, $76, $7F
	cfiAttack	$1F, $18, $1F, $1F
	cfiRateScale	$00, $00, $00, $00
	cfiDecayRate	$11, $17, $05, $0F
	cfiAmpMod	$00, $00, $00, $00
	cfiSustainRt	$00, $00, $00, $00
	cfiReleaseRt	$0F, $0D, $0C, $0D
	cfiSustainLv	$0F, $05, $0F, $05
	cfiSSGEG	$00, $00, $00, $00
	cfiAlgorithm	$04
	cfiFeedback	$06

	; Patch 6E
	; 08 72 05 12   19 7F 6B 6B   1F 0F 0F 0F
	; 00 00 0F 00   00 00 00 00   00 0F 37 0F
	; 00 00 00 00   3E
	cfiName		patch6E
	cfiMultiple	$08, $02, $05, $02
	cfiDetune	$00, $07, $00, $01
	cfiTotalLv	$19, $7F, $6B, $6B
	cfiAttack	$1F, $0F, $0F, $0F
	cfiRateScale	$00, $00, $00, $00
	cfiDecayRate	$00, $00, $0F, $00
	cfiAmpMod	$00, $00, $00, $00
	cfiSustainRt	$00, $00, $00, $00
	cfiReleaseRt	$00, $0F, $07, $0F
	cfiSustainLv	$00, $00, $03, $00
	cfiSSGEG	$00, $00, $00, $00
	cfiAlgorithm	$06
	cfiFeedback	$07

	; Patch 6F
	; 6F 10 5A 33   25 07 16 7F   06 1F 1E 1E
	; 00 1B 01 1C   00 01 01 01   0F 06 FB 0C
	; 00 00 00 00   03
	cfiName		patch6F
	cfiMultiple	$0F, $00, $0A, $03
	cfiDetune	$06, $01, $05, $03
	cfiTotalLv	$25, $07, $16, $7F
	cfiAttack	$06, $1F, $1E, $1E
	cfiRateScale	$00, $00, $00, $00
	cfiDecayRate	$00, $1B, $01, $1C
	cfiAmpMod	$00, $00, $00, $00
	cfiSustainRt	$00, $01, $01, $01
	cfiReleaseRt	$0F, $06, $0B, $0C
	cfiSustainLv	$00, $00, $0F, $00
	cfiSSGEG	$00, $00, $00, $00
	cfiAlgorithm	$03
	cfiFeedback	$00

	; Patch 70
	; 00 62 61 41   0F 14 1A 7F   3F 1F 1F 1F
	; 09 0C 09 01   00 00 00 00   C6 C6 A4 D5
	; 00 00 00 00   38
	cfiName		patch70
	cfiMultiple	$00, $02, $01, $01
	cfiDetune	$00, $06, $06, $04
	cfiTotalLv	$0F, $14, $1A, $7F
	cfiAttack	$3F, $1F, $1F, $1F
	cfiRateScale	$00, $00, $00, $00
	cfiDecayRate	$09, $0C, $09, $01
	cfiAmpMod	$00, $00, $00, $00
	cfiSustainRt	$00, $00, $00, $00
	cfiReleaseRt	$06, $06, $04, $05
	cfiSustainLv	$0C, $0C, $0A, $0D
	cfiSSGEG	$00, $00, $00, $00
	cfiAlgorithm	$00
	cfiFeedback	$07

	; Patch 71
	; 00 62 61 41   10 14 18 7D   19 1F 1F 1F
	; 0A 0B 0A 05   00 00 00 00   C6 C6 A4 D5
	; 00 00 00 00   38
	cfiName		patch71
	cfiMultiple	$00, $02, $01, $01
	cfiDetune	$00, $06, $06, $04
	cfiTotalLv	$10, $14, $18, $7D
	cfiAttack	$19, $1F, $1F, $1F
	cfiRateScale	$00, $00, $00, $00
	cfiDecayRate	$0A, $0B, $0A, $05
	cfiAmpMod	$00, $00, $00, $00
	cfiSustainRt	$00, $00, $00, $00
	cfiReleaseRt	$06, $06, $04, $05
	cfiSustainLv	$0C, $0C, $0A, $0D
	cfiSSGEG	$00, $00, $00, $00
	cfiAlgorithm	$00
	cfiFeedback	$07

	; Patch 72
	; 08 72 05 12   19 6B 7F 6B   1F 0F 0F 0F
	; 07 07 0F 09   00 00 00 00   FD FF FD FF
	; 00 00 00 00   3E
	cfiName		patch72
	cfiMultiple	$08, $02, $05, $02
	cfiDetune	$00, $07, $00, $01
	cfiTotalLv	$19, $6B, $7F, $6B
	cfiAttack	$1F, $0F, $0F, $0F
	cfiRateScale	$00, $00, $00, $00
	cfiDecayRate	$07, $07, $0F, $09
	cfiAmpMod	$00, $00, $00, $00
	cfiSustainRt	$00, $00, $00, $00
	cfiReleaseRt	$0D, $0F, $0D, $0F
	cfiSustainLv	$0F, $0F, $0F, $0F
	cfiSSGEG	$00, $00, $00, $00
	cfiAlgorithm	$06
	cfiFeedback	$07

	; Patch 73
	; 07 07 02 02   21 21 7F 7F   1F 1F 1F 1F
	; 00 00 10 10   00 00 00 00   FF FF FF FF
	; 00 00 00 00   04
	cfiName		patch73
	cfiMultiple	$07, $07, $02, $02
	cfiDetune	$00, $00, $00, $00
	cfiTotalLv	$21, $21, $7F, $7F
	cfiAttack	$1F, $1F, $1F, $1F
	cfiRateScale	$00, $00, $00, $00
	cfiDecayRate	$00, $00, $10, $10
	cfiAmpMod	$00, $00, $00, $00
	cfiSustainRt	$00, $00, $00, $00
	cfiReleaseRt	$0F, $0F, $0F, $0F
	cfiSustainLv	$0F, $0F, $0F, $0F
	cfiSSGEG	$00, $00, $00, $00
	cfiAlgorithm	$04
	cfiFeedback	$00

	; Patch 74
	; 0F 42 07 02   14 7F 75 7F   1C 0F 12 0F
	; 0F 00 0F 00   07 00 0F 00   A9 09 A9 09
	; 00 00 00 00   3E
	cfiName		patch74
	cfiMultiple	$0F, $02, $07, $02
	cfiDetune	$00, $04, $00, $00
	cfiTotalLv	$14, $7F, $75, $7F
	cfiAttack	$1C, $0F, $12, $0F
	cfiRateScale	$00, $00, $00, $00
	cfiDecayRate	$0F, $00, $0F, $00
	cfiAmpMod	$00, $00, $00, $00
	cfiSustainRt	$07, $00, $0F, $00
	cfiReleaseRt	$09, $09, $09, $09
	cfiSustainLv	$0A, $00, $0A, $00
	cfiSSGEG	$00, $00, $00, $00
	cfiAlgorithm	$06
	cfiFeedback	$07

	; Patch 75
	; 01 01 01 01   17 19 7F 7F   1F 1F 1F 1F
	; 00 00 00 00   1F 00 00 00   0F 0F 0F 0F
	; 00 00 00 00   3C
	cfiName		patch75
	cfiMultiple	$01, $01, $01, $01
	cfiDetune	$00, $00, $00, $00
	cfiTotalLv	$17, $19, $7F, $7F
	cfiAttack	$1F, $1F, $1F, $1F
	cfiRateScale	$00, $00, $00, $00
	cfiDecayRate	$00, $00, $00, $00
	cfiAmpMod	$00, $00, $00, $00
	cfiSustainRt	$1F, $00, $00, $00
	cfiReleaseRt	$0F, $0F, $0F, $0F
	cfiSustainLv	$00, $00, $00, $00
	cfiSSGEG	$00, $00, $00, $00
	cfiAlgorithm	$04
	cfiFeedback	$07

	; Patch 76
	; 39 30 35 31   17 14 32 7F   1F 1F 1F 1F
	; 0C 07 0A 0A   07 07 07 09   2D 1B 1B FD
	; 00 00 00 00   28
	cfiName		patch76
	cfiMultiple	$09, $00, $05, $01
	cfiDetune	$03, $03, $03, $03
	cfiTotalLv	$17, $14, $32, $7F
	cfiAttack	$1F, $1F, $1F, $1F
	cfiRateScale	$00, $00, $00, $00
	cfiDecayRate	$0C, $07, $0A, $0A
	cfiAmpMod	$00, $00, $00, $00
	cfiSustainRt	$07, $07, $07, $09
	cfiReleaseRt	$0D, $0B, $0B, $0D
	cfiSustainLv	$02, $01, $01, $0F
	cfiSSGEG	$00, $00, $00, $00
	cfiAlgorithm	$00
	cfiFeedback	$05

	; Patch 77
	; 39 30 35 31   17 14 32 7B   1F 1F 1F 1F
	; 0C 07 0A 0A   07 07 07 09   26 16 16 F6
	; 00 00 00 00   28
	cfiName		patch77
	cfiMultiple	$09, $00, $05, $01
	cfiDetune	$03, $03, $03, $03
	cfiTotalLv	$17, $14, $32, $7B
	cfiAttack	$1F, $1F, $1F, $1F
	cfiRateScale	$00, $00, $00, $00
	cfiDecayRate	$0C, $07, $0A, $0A
	cfiAmpMod	$00, $00, $00, $00
	cfiSustainRt	$07, $07, $07, $09
	cfiReleaseRt	$06, $06, $06, $06
	cfiSustainLv	$02, $01, $01, $0F
	cfiSSGEG	$00, $00, $00, $00
	cfiAlgorithm	$00
	cfiFeedback	$05

	; Patch 78
	; 00 01 02 01   14 17 16 7B   1F 1F 1F 1F
	; 00 00 00 00   00 00 00 00   0F 0F 0F 0F
	; 00 00 00 00   03
	cfiName		patch78
	cfiMultiple	$00, $01, $02, $01
	cfiDetune	$00, $00, $00, $00
	cfiTotalLv	$14, $17, $16, $7B
	cfiAttack	$1F, $1F, $1F, $1F
	cfiRateScale	$00, $00, $00, $00
	cfiDecayRate	$00, $00, $00, $00
	cfiAmpMod	$00, $00, $00, $00
	cfiSustainRt	$00, $00, $00, $00
	cfiReleaseRt	$0F, $0F, $0F, $0F
	cfiSustainLv	$00, $00, $00, $00
	cfiSSGEG	$00, $00, $00, $00
	cfiAlgorithm	$03
	cfiFeedback	$00

	; Patch 79
	; 01 00 01 01   07 17 16 7F   1F 1F 1F 1F
	; 00 00 00 00   00 00 00 00   0F 0F 0F 0F
	; 00 00 00 00   32
	cfiName		patch79
	cfiMultiple	$01, $00, $01, $01
	cfiDetune	$00, $00, $00, $00
	cfiTotalLv	$07, $17, $16, $7F
	cfiAttack	$1F, $1F, $1F, $1F
	cfiRateScale	$00, $00, $00, $00
	cfiDecayRate	$00, $00, $00, $00
	cfiAmpMod	$00, $00, $00, $00
	cfiSustainRt	$00, $00, $00, $00
	cfiReleaseRt	$0F, $0F, $0F, $0F
	cfiSustainLv	$00, $00, $00, $00
	cfiSSGEG	$00, $00, $00, $00
	cfiAlgorithm	$02
	cfiFeedback	$06

	; Patch 7A
	; 01 00 00 00   0B 12 14 7F   5F 5F 5F 5F
	; 08 03 03 09   00 01 02 00   C1 B2 82 BB
	; 00 00 00 00   20
	cfiName		patch7A
	cfiMultiple	$01, $00, $00, $00
	cfiDetune	$00, $00, $00, $00
	cfiTotalLv	$0B, $12, $14, $7F
	cfiAttack	$1F, $1F, $1F, $1F
	cfiRateScale	$01, $01, $01, $01
	cfiDecayRate	$08, $03, $03, $09
	cfiAmpMod	$00, $00, $00, $00
	cfiSustainRt	$00, $01, $02, $00
	cfiReleaseRt	$01, $02, $02, $0B
	cfiSustainLv	$0C, $0B, $08, $0B
	cfiSSGEG	$00, $00, $00, $00
	cfiAlgorithm	$00
	cfiFeedback	$04

	; Patch 7B
	; 00 02 01 00   02 06 7F 7F   1F 1F 1F 1F
	; 10 14 0E 0E   01 01 02 02   F7 F7 F7 F7
	; 00 00 00 00   14
	cfiName		patch7B
	cfiMultiple	$00, $02, $01, $00
	cfiDetune	$00, $00, $00, $00
	cfiTotalLv	$02, $06, $7F, $7F
	cfiAttack	$1F, $1F, $1F, $1F
	cfiRateScale	$00, $00, $00, $00
	cfiDecayRate	$10, $14, $0E, $0E
	cfiAmpMod	$00, $00, $00, $00
	cfiSustainRt	$01, $01, $02, $02
	cfiReleaseRt	$07, $07, $07, $07
	cfiSustainLv	$0F, $0F, $0F, $0F
	cfiSSGEG	$00, $00, $00, $00
	cfiAlgorithm	$04
	cfiFeedback	$02

	; Patch 7C
	; 0A 30 70 00   24 13 2D 7C   9F 9F 9F 9F
	; 10 0D 0A 0A   00 04 04 03   26 26 26 06
	; 00 00 00 00   08
	cfiName		patch7C
	cfiMultiple	$0A, $00, $00, $00
	cfiDetune	$00, $03, $07, $00
	cfiTotalLv	$24, $13, $2D, $7C
	cfiAttack	$1F, $1F, $1F, $1F
	cfiRateScale	$02, $02, $02, $02
	cfiDecayRate	$10, $0D, $0A, $0A
	cfiAmpMod	$00, $00, $00, $00
	cfiSustainRt	$00, $04, $04, $03
	cfiReleaseRt	$06, $06, $06, $06
	cfiSustainLv	$02, $02, $02, $00
	cfiSSGEG	$00, $00, $00, $00
	cfiAlgorithm	$00
	cfiFeedback	$01

	; Patch 7D
	; 01 21 31 31   0B 1C 11 7E   0F 12 15 1B
	; 00 00 00 07   00 00 00 00   0C 0C 0E 3D
	; 00 00 00 00   40
	cfiName		patch7D
	cfiMultiple	$01, $01, $01, $01
	cfiDetune	$00, $02, $03, $03
	cfiTotalLv	$0B, $1C, $11, $7E
	cfiAttack	$0F, $12, $15, $1B
	cfiRateScale	$00, $00, $00, $00
	cfiDecayRate	$00, $00, $00, $07
	cfiAmpMod	$00, $00, $00, $00
	cfiSustainRt	$00, $00, $00, $00
	cfiReleaseRt	$0C, $0C, $0E, $0D
	cfiSustainLv	$00, $00, $00, $03
	cfiSSGEG	$00, $00, $00, $00
	cfiAlgorithm	$00
	cfiFeedback	$08

	; Patch 7E
	; 0F 09 00 00   00 66 75 7F   1F 0D 11 0F
	; 00 0C 0C 0A   00 00 00 00   0F 6F FF 4F
	; 00 00 00 00   3E
	cfiName		patch7E
	cfiMultiple	$0F, $09, $00, $00
	cfiDetune	$00, $00, $00, $00
	cfiTotalLv	$00, $66, $75, $7F
	cfiAttack	$1F, $0D, $11, $0F
	cfiRateScale	$00, $00, $00, $00
	cfiDecayRate	$00, $0C, $0C, $0A
	cfiAmpMod	$00, $00, $00, $00
	cfiSustainRt	$00, $00, $00, $00
	cfiReleaseRt	$0F, $0F, $0F, $0F
	cfiSustainLv	$00, $06, $0F, $04
	cfiSSGEG	$00, $00, $00, $00
	cfiAlgorithm	$06
	cfiFeedback	$07

	; Patch 7F
	; 00 02 01 00   07 16 7D 7D   1F 1F 1F 1F
	; 10 14 0E 0E   01 01 02 02   FE FE FE FE
	; 00 00 00 00   14
	cfiName		patch7F
	cfiMultiple	$00, $02, $01, $00
	cfiDetune	$00, $00, $00, $00
	cfiTotalLv	$07, $16, $7D, $7D
	cfiAttack	$1F, $1F, $1F, $1F
	cfiRateScale	$00, $00, $00, $00
	cfiDecayRate	$10, $14, $0E, $0E
	cfiAmpMod	$00, $00, $00, $00
	cfiSustainRt	$01, $01, $02, $02
	cfiReleaseRt	$0E, $0E, $0E, $0E
	cfiSustainLv	$0F, $0F, $0F, $0F
	cfiSSGEG	$00, $00, $00, $00
	cfiAlgorithm	$04
	cfiFeedback	$02

	; Patch 80
	; 41 1B 50 0E   02 78 78 78   4C 1F 1F 1F
	; 07 02 1F 0D   10 04 07 07   84 07 07 07
	; 00 00 00 00   2D
	cfiName		patch80
	cfiMultiple	$01, $0B, $00, $0E
	cfiDetune	$04, $01, $05, $00
	cfiTotalLv	$02, $78, $78, $78
	cfiAttack	$0C, $1F, $1F, $1F
	cfiRateScale	$01, $00, $00, $00
	cfiDecayRate	$07, $02, $1F, $0D
	cfiAmpMod	$00, $00, $00, $00
	cfiSustainRt	$10, $04, $07, $07
	cfiReleaseRt	$04, $07, $07, $07
	cfiSustainLv	$08, $00, $00, $00
	cfiSSGEG	$00, $00, $00, $00
	cfiAlgorithm	$05
	cfiFeedback	$05

	; Patch 81
	; 01 30 70 00   19 11 2D 7F   9F 9F 9F 9F
	; 10 0D 0A 0A   00 04 04 03   26 26 26 06
	; 00 00 00 00   08
	cfiName		patch81
	cfiMultiple	$01, $00, $00, $00
	cfiDetune	$00, $03, $07, $00
	cfiTotalLv	$19, $11, $2D, $7F
	cfiAttack	$1F, $1F, $1F, $1F
	cfiRateScale	$02, $02, $02, $02
	cfiDecayRate	$10, $0D, $0A, $0A
	cfiAmpMod	$00, $00, $00, $00
	cfiSustainRt	$00, $04, $04, $03
	cfiReleaseRt	$06, $06, $06, $06
	cfiSustainLv	$02, $02, $02, $00
	cfiSSGEG	$00, $00, $00, $00
	cfiAlgorithm	$00
	cfiFeedback	$01

	; Patch 82
	; 02 11 72 01   14 5C 7A 7F   1F 1F 10 14
	; 03 03 03 03   00 00 00 00   FA FA F9 FB
	; 00 00 00 00   34
	cfiName		patch82
	cfiMultiple	$02, $01, $02, $01
	cfiDetune	$00, $01, $07, $00
	cfiTotalLv	$14, $5C, $7A, $7F
	cfiAttack	$1F, $1F, $10, $14
	cfiRateScale	$00, $00, $00, $00
	cfiDecayRate	$03, $03, $03, $03
	cfiAmpMod	$00, $00, $00, $00
	cfiSustainRt	$00, $00, $00, $00
	cfiReleaseRt	$0A, $0A, $09, $0B
	cfiSustainLv	$0F, $0F, $0F, $0F
	cfiSSGEG	$00, $00, $00, $00
	cfiAlgorithm	$04
	cfiFeedback	$06

	; Patch 83
	; 05 0C 01 02   0B 09 0A 7F   13 19 19 19
	; 0E 11 00 0A   00 00 00 00   0C 0C 0C 0C
	; 00 00 00 00   34
	cfiName		patch83
	cfiMultiple	$05, $0C, $01, $02
	cfiDetune	$00, $00, $00, $00
	cfiTotalLv	$0B, $09, $0A, $7F
	cfiAttack	$13, $19, $19, $19
	cfiRateScale	$00, $00, $00, $00
	cfiDecayRate	$0E, $11, $00, $0A
	cfiAmpMod	$00, $00, $00, $00
	cfiSustainRt	$00, $00, $00, $00
	cfiReleaseRt	$0C, $0C, $0C, $0C
	cfiSustainLv	$00, $00, $00, $00
	cfiSSGEG	$00, $00, $00, $00
	cfiAlgorithm	$04
	cfiFeedback	$06

	; Patch 84
	; 01 00 01 00   02 02 02 7F   5F 5F 5F 5F
	; 0B 03 03 08   00 01 02 00   C1 B2 82 BB
	; 00 00 00 00   38
	cfiName		patch84
	cfiMultiple	$01, $00, $01, $00
	cfiDetune	$00, $00, $00, $00
	cfiTotalLv	$02, $02, $02, $7F
	cfiAttack	$1F, $1F, $1F, $1F
	cfiRateScale	$01, $01, $01, $01
	cfiDecayRate	$0B, $03, $03, $08
	cfiAmpMod	$00, $00, $00, $00
	cfiSustainRt	$00, $01, $02, $00
	cfiReleaseRt	$01, $02, $02, $0B
	cfiSustainLv	$0C, $0B, $08, $0B
	cfiSSGEG	$00, $00, $00, $00
	cfiAlgorithm	$00
	cfiFeedback	$07

	; Patch 85
	; 35 6D 6B 64   12 11 7F 7F   5F 1F DF 9F
	; 07 0A 08 07   01 05 01 1F   54 24 26 A7
	; 00 00 00 00   04
	cfiName		patch85
	cfiMultiple	$05, $0D, $0B, $04
	cfiDetune	$03, $06, $06, $06
	cfiTotalLv	$12, $11, $7F, $7F
	cfiAttack	$1F, $1F, $1F, $1F
	cfiRateScale	$01, $00, $03, $02
	cfiDecayRate	$07, $0A, $08, $07
	cfiAmpMod	$00, $00, $00, $00
	cfiSustainRt	$01, $05, $01, $1F
	cfiReleaseRt	$04, $04, $06, $07
	cfiSustainLv	$05, $02, $02, $0A
	cfiSSGEG	$00, $00, $00, $00
	cfiAlgorithm	$04
	cfiFeedback	$00

	; Patch 86
	; 75 71 05 01   1E 7D 1E 7D   10 0A 10 0A
	; 02 02 02 02   08 08 08 08   F2 FA F5 FA
	; 00 00 00 00   1D
	cfiName		patch86
	cfiMultiple	$05, $01, $05, $01
	cfiDetune	$07, $07, $00, $00
	cfiTotalLv	$1E, $7D, $1E, $7D
	cfiAttack	$10, $0A, $10, $0A
	cfiRateScale	$00, $00, $00, $00
	cfiDecayRate	$02, $02, $02, $02
	cfiAmpMod	$00, $00, $00, $00
	cfiSustainRt	$08, $08, $08, $08
	cfiReleaseRt	$02, $0A, $05, $0A
	cfiSustainLv	$0F, $0F, $0F, $0F
	cfiSSGEG	$00, $00, $00, $00
	cfiAlgorithm	$05
	cfiFeedback	$03

	; Patch 87
	; 05 20 73 41   00 07 7F 7F   D0 1F 5F 1F
	; 0C 0C 0D 01   00 00 00 00   FF FF FF FF
	; 00 00 00 00   3C
	cfiName		patch87
	cfiMultiple	$05, $00, $03, $01
	cfiDetune	$00, $02, $07, $04
	cfiTotalLv	$00, $07, $7F, $7F
	cfiAttack	$10, $1F, $1F, $1F
	cfiRateScale	$03, $00, $01, $00
	cfiDecayRate	$0C, $0C, $0D, $01
	cfiAmpMod	$00, $00, $00, $00
	cfiSustainRt	$00, $00, $00, $00
	cfiReleaseRt	$0F, $0F, $0F, $0F
	cfiSustainLv	$0F, $0F, $0F, $0F
	cfiSSGEG	$00, $00, $00, $00
	cfiAlgorithm	$04
	cfiFeedback	$07

	; Patch 88
	; 7F 2E 77 27   21 1F 7F 7F   1F 5F 9F 1F
	; 09 09 07 04   00 00 00 0B   17 17 F7 05
	; 00 00 00 00   3C
	cfiName		patch88
	cfiMultiple	$0F, $0E, $07, $07
	cfiDetune	$07, $02, $07, $02
	cfiTotalLv	$21, $1F, $7F, $7F
	cfiAttack	$1F, $1F, $1F, $1F
	cfiRateScale	$00, $01, $02, $00
	cfiDecayRate	$09, $09, $07, $04
	cfiAmpMod	$00, $00, $00, $00
	cfiSustainRt	$00, $00, $00, $0B
	cfiReleaseRt	$07, $07, $07, $05
	cfiSustainLv	$01, $01, $0F, $00
	cfiSSGEG	$00, $00, $00, $00
	cfiAlgorithm	$04
	cfiFeedback	$07

	; Patch 89
	; 21 41 10 51   01 03 02 7F   5F 5F 5F 5F
	; 13 10 14 03   00 01 02 00   C2 B5 83 35
	; 00 00 00 00   19
	cfiName		patch89
	cfiMultiple	$01, $01, $00, $01
	cfiDetune	$02, $04, $01, $05
	cfiTotalLv	$01, $03, $02, $7F
	cfiAttack	$1F, $1F, $1F, $1F
	cfiRateScale	$01, $01, $01, $01
	cfiDecayRate	$13, $10, $14, $03
	cfiAmpMod	$00, $00, $00, $00
	cfiSustainRt	$00, $01, $02, $00
	cfiReleaseRt	$02, $05, $03, $05
	cfiSustainLv	$0C, $0B, $08, $03
	cfiSSGEG	$00, $00, $00, $00
	cfiAlgorithm	$01
	cfiFeedback	$03

	; Patch 8A
	; 28 75 73 18   04 3E 3D 7F   0D 10 8C 09
	; 00 00 00 04   00 00 00 08   00 00 00 5C
	; 00 00 00 00   32
	cfiName		patch8A
	cfiMultiple	$08, $05, $03, $08
	cfiDetune	$02, $07, $07, $01
	cfiTotalLv	$04, $3E, $3D, $7F
	cfiAttack	$0D, $10, $0C, $09
	cfiRateScale	$00, $00, $02, $00
	cfiDecayRate	$00, $00, $00, $04
	cfiAmpMod	$00, $00, $00, $00
	cfiSustainRt	$00, $00, $00, $08
	cfiReleaseRt	$00, $00, $00, $0C
	cfiSustainLv	$00, $00, $00, $05
	cfiSSGEG	$00, $00, $00, $00
	cfiAlgorithm	$02
	cfiFeedback	$06

	; Patch 8B
	; 7F 3B 70 4F   06 19 17 7E   12 50 15 48
	; 00 00 00 03   00 00 00 04   03 04 03 0F
	; 00 00 00 00   2B
	cfiName		patch8B
	cfiMultiple	$0F, $0B, $00, $0F
	cfiDetune	$07, $03, $07, $04
	cfiTotalLv	$06, $19, $17, $7E
	cfiAttack	$12, $10, $15, $08
	cfiRateScale	$00, $01, $00, $01
	cfiDecayRate	$00, $00, $00, $03
	cfiAmpMod	$00, $00, $00, $00
	cfiSustainRt	$00, $00, $00, $04
	cfiReleaseRt	$03, $04, $03, $0F
	cfiSustainLv	$00, $00, $00, $00
	cfiSSGEG	$00, $00, $00, $00
	cfiAlgorithm	$03
	cfiFeedback	$05

	; Patch 8C
	; 00 00 00 00   00 00 00 00   00 00 00 00
	; 00 00 00 00   00 00 00 00   00 00 00 00
	; 00 00 00 00   00
	cfiName		patch8C
	cfiMultiple	$00, $00, $00, $00
	cfiDetune	$00, $00, $00, $00
	cfiTotalLv	$00, $00, $00, $00
	cfiAttack	$00, $00, $00, $00
	cfiRateScale	$00, $00, $00, $00
	cfiDecayRate	$00, $00, $00, $00
	cfiAmpMod	$00, $00, $00, $00
	cfiSustainRt	$00, $00, $00, $00
	cfiReleaseRt	$00, $00, $00, $00
	cfiSustainLv	$00, $00, $00, $00
	cfiSSGEG	$00, $00, $00, $00
	cfiAlgorithm	$00
	cfiFeedback	$00

	; Patch 8D
	; 00 00 00 00   00 00 00 00   00 00 00 00
	; 00 00 00 00   00 00 00 00   00 00 00 00
	; 00 00 00 00   00
	cfiName		patch8D
	cfiMultiple	$00, $00, $00, $00
	cfiDetune	$00, $00, $00, $00
	cfiTotalLv	$00, $00, $00, $00
	cfiAttack	$00, $00, $00, $00
	cfiRateScale	$00, $00, $00, $00
	cfiDecayRate	$00, $00, $00, $00
	cfiAmpMod	$00, $00, $00, $00
	cfiSustainRt	$00, $00, $00, $00
	cfiReleaseRt	$00, $00, $00, $00
	cfiSustainLv	$00, $00, $00, $00
	cfiSSGEG	$00, $00, $00, $00
	cfiAlgorithm	$00
	cfiFeedback	$00

	; Patch 8E
	; 00 00 00 00   00 00 00 00   00 00 00 00
	; 00 00 00 00   00 00 00 00   00 00 00 00
	; 00 00 00 00   00
	cfiName		patch8E
	cfiMultiple	$00, $00, $00, $00
	cfiDetune	$00, $00, $00, $00
	cfiTotalLv	$00, $00, $00, $00
	cfiAttack	$00, $00, $00, $00
	cfiRateScale	$00, $00, $00, $00
	cfiDecayRate	$00, $00, $00, $00
	cfiAmpMod	$00, $00, $00, $00
	cfiSustainRt	$00, $00, $00, $00
	cfiReleaseRt	$00, $00, $00, $00
	cfiSustainLv	$00, $00, $00, $00
	cfiSSGEG	$00, $00, $00, $00
	cfiAlgorithm	$00
	cfiFeedback	$00

	; Patch 8F
	; 00 00 00 00   00 00 00 00   00 00 00 00
	; 00 00 00 00   00 00 00 00   00 00 00 00
	; 00 00 00 00   00
	cfiName		patch8F
	cfiMultiple	$00, $00, $00, $00
	cfiDetune	$00, $00, $00, $00
	cfiTotalLv	$00, $00, $00, $00
	cfiAttack	$00, $00, $00, $00
	cfiRateScale	$00, $00, $00, $00
	cfiDecayRate	$00, $00, $00, $00
	cfiAmpMod	$00, $00, $00, $00
	cfiSustainRt	$00, $00, $00, $00
	cfiReleaseRt	$00, $00, $00, $00
	cfiSustainLv	$00, $00, $00, $00
	cfiSSGEG	$00, $00, $00, $00
	cfiAlgorithm	$00
	cfiFeedback	$00

	; Patch 90
	; 00 00 00 00   00 00 00 00   00 00 00 00
	; 00 00 00 00   00 00 00 00   00 00 00 00
	; 00 00 00 00   00
	cfiName		patch90
	cfiMultiple	$00, $00, $00, $00
	cfiDetune	$00, $00, $00, $00
	cfiTotalLv	$00, $00, $00, $00
	cfiAttack	$00, $00, $00, $00
	cfiRateScale	$00, $00, $00, $00
	cfiDecayRate	$00, $00, $00, $00
	cfiAmpMod	$00, $00, $00, $00
	cfiSustainRt	$00, $00, $00, $00
	cfiReleaseRt	$00, $00, $00, $00
	cfiSustainLv	$00, $00, $00, $00
	cfiSSGEG	$00, $00, $00, $00
	cfiAlgorithm	$00
	cfiFeedback	$00

	; Patch 91
	; 00 00 00 00   00 00 00 00   00 00 00 00
	; 00 00 00 00   00 00 00 00   00 00 00 00
	; 00 00 00 00   00
	cfiName		patch91
	cfiMultiple	$00, $00, $00, $00
	cfiDetune	$00, $00, $00, $00
	cfiTotalLv	$00, $00, $00, $00
	cfiAttack	$00, $00, $00, $00
	cfiRateScale	$00, $00, $00, $00
	cfiDecayRate	$00, $00, $00, $00
	cfiAmpMod	$00, $00, $00, $00
	cfiSustainRt	$00, $00, $00, $00
	cfiReleaseRt	$00, $00, $00, $00
	cfiSustainLv	$00, $00, $00, $00
	cfiSSGEG	$00, $00, $00, $00
	cfiAlgorithm	$00
	cfiFeedback	$00

	; Patch 92
	; 00 00 00 00   00 00 00 00   00 00 00 00
	; 00 00 00 00   00 00 00 00   00 00 00 00
	; 00 00 00 00   00
	cfiName		patch92
	cfiMultiple	$00, $00, $00, $00
	cfiDetune	$00, $00, $00, $00
	cfiTotalLv	$00, $00, $00, $00
	cfiAttack	$00, $00, $00, $00
	cfiRateScale	$00, $00, $00, $00
	cfiDecayRate	$00, $00, $00, $00
	cfiAmpMod	$00, $00, $00, $00
	cfiSustainRt	$00, $00, $00, $00
	cfiReleaseRt	$00, $00, $00, $00
	cfiSustainLv	$00, $00, $00, $00
	cfiSSGEG	$00, $00, $00, $00
	cfiAlgorithm	$00
	cfiFeedback	$00

	; Patch 93
	; 00 00 00 00   00 00 00 00   00 00 00 00
	; 00 00 00 00   00 00 00 00   00 00 00 00
	; 00 00 00 00   00
	cfiName		patch93
	cfiMultiple	$00, $00, $00, $00
	cfiDetune	$00, $00, $00, $00
	cfiTotalLv	$00, $00, $00, $00
	cfiAttack	$00, $00, $00, $00
	cfiRateScale	$00, $00, $00, $00
	cfiDecayRate	$00, $00, $00, $00
	cfiAmpMod	$00, $00, $00, $00
	cfiSustainRt	$00, $00, $00, $00
	cfiReleaseRt	$00, $00, $00, $00
	cfiSustainLv	$00, $00, $00, $00
	cfiSSGEG	$00, $00, $00, $00
	cfiAlgorithm	$00
	cfiFeedback	$00

	; Patch 94
	; 00 00 00 00   00 00 00 00   00 00 00 00
	; 00 00 00 00   00 00 00 00   00 00 00 00
	; 00 00 00 00   00
	cfiName		patch94
	cfiMultiple	$00, $00, $00, $00
	cfiDetune	$00, $00, $00, $00
	cfiTotalLv	$00, $00, $00, $00
	cfiAttack	$00, $00, $00, $00
	cfiRateScale	$00, $00, $00, $00
	cfiDecayRate	$00, $00, $00, $00
	cfiAmpMod	$00, $00, $00, $00
	cfiSustainRt	$00, $00, $00, $00
	cfiReleaseRt	$00, $00, $00, $00
	cfiSustainLv	$00, $00, $00, $00
	cfiSSGEG	$00, $00, $00, $00
	cfiAlgorithm	$00
	cfiFeedback	$00

	; Patch 95
	; 00 00 00 00   00 00 00 00   00 00 00 00
	; 00 00 00 00   00 00 00 00   00 00 00 00
	; 00 00 00 00   00
	cfiName		patch95
	cfiMultiple	$00, $00, $00, $00
	cfiDetune	$00, $00, $00, $00
	cfiTotalLv	$00, $00, $00, $00
	cfiAttack	$00, $00, $00, $00
	cfiRateScale	$00, $00, $00, $00
	cfiDecayRate	$00, $00, $00, $00
	cfiAmpMod	$00, $00, $00, $00
	cfiSustainRt	$00, $00, $00, $00
	cfiReleaseRt	$00, $00, $00, $00
	cfiSustainLv	$00, $00, $00, $00
	cfiSSGEG	$00, $00, $00, $00
	cfiAlgorithm	$00
	cfiFeedback	$00

	; Patch 96
	; 00 00 00 00   00 00 00 00   00 00 00 00
	; 00 00 00 00   00 00 00 00   00 00 00 00
	; 00 00 00 00   00
	cfiName		patch96
	cfiMultiple	$00, $00, $00, $00
	cfiDetune	$00, $00, $00, $00
	cfiTotalLv	$00, $00, $00, $00
	cfiAttack	$00, $00, $00, $00
	cfiRateScale	$00, $00, $00, $00
	cfiDecayRate	$00, $00, $00, $00
	cfiAmpMod	$00, $00, $00, $00
	cfiSustainRt	$00, $00, $00, $00
	cfiReleaseRt	$00, $00, $00, $00
	cfiSustainLv	$00, $00, $00, $00
	cfiSSGEG	$00, $00, $00, $00
	cfiAlgorithm	$00
	cfiFeedback	$00

	; Patch 97
	; 00 00 00 00   00 00 00 00   00 00 00 00
	; 00 00 00 00   00 00 00 00   00 00 00 00
	; 00 00 00 00   00
	cfiName		patch97
	cfiMultiple	$00, $00, $00, $00
	cfiDetune	$00, $00, $00, $00
	cfiTotalLv	$00, $00, $00, $00
	cfiAttack	$00, $00, $00, $00
	cfiRateScale	$00, $00, $00, $00
	cfiDecayRate	$00, $00, $00, $00
	cfiAmpMod	$00, $00, $00, $00
	cfiSustainRt	$00, $00, $00, $00
	cfiReleaseRt	$00, $00, $00, $00
	cfiSustainLv	$00, $00, $00, $00
	cfiSSGEG	$00, $00, $00, $00
	cfiAlgorithm	$00
	cfiFeedback	$00

	; Patch 98
	; 00 00 00 00   00 00 00 00   00 00 00 00
	; 00 00 00 00   00 00 00 00   00 00 00 00
	; 00 00 00 00   00
	cfiName		patch98
	cfiMultiple	$00, $00, $00, $00
	cfiDetune	$00, $00, $00, $00
	cfiTotalLv	$00, $00, $00, $00
	cfiAttack	$00, $00, $00, $00
	cfiRateScale	$00, $00, $00, $00
	cfiDecayRate	$00, $00, $00, $00
	cfiAmpMod	$00, $00, $00, $00
	cfiSustainRt	$00, $00, $00, $00
	cfiReleaseRt	$00, $00, $00, $00
	cfiSustainLv	$00, $00, $00, $00
	cfiSSGEG	$00, $00, $00, $00
	cfiAlgorithm	$00
	cfiFeedback	$00

	; Patch 99
	; 00 00 00 00   00 00 00 00   00 00 00 00
	; 00 00 00 00   00 00 00 00   00 00 00 00
	; 00 00 00 00   00
	cfiName		patch99
	cfiMultiple	$00, $00, $00, $00
	cfiDetune	$00, $00, $00, $00
	cfiTotalLv	$00, $00, $00, $00
	cfiAttack	$00, $00, $00, $00
	cfiRateScale	$00, $00, $00, $00
	cfiDecayRate	$00, $00, $00, $00
	cfiAmpMod	$00, $00, $00, $00
	cfiSustainRt	$00, $00, $00, $00
	cfiReleaseRt	$00, $00, $00, $00
	cfiSustainLv	$00, $00, $00, $00
	cfiSSGEG	$00, $00, $00, $00
	cfiAlgorithm	$00
	cfiFeedback	$00

	; Patch 9A
	; 00 00 00 00   00 00 00 00   00 00 00 00
	; 00 00 00 00   00 00 00 00   00 00 00 00
	; 00 00 00 00   00
	cfiName		patch9A
	cfiMultiple	$00, $00, $00, $00
	cfiDetune	$00, $00, $00, $00
	cfiTotalLv	$00, $00, $00, $00
	cfiAttack	$00, $00, $00, $00
	cfiRateScale	$00, $00, $00, $00
	cfiDecayRate	$00, $00, $00, $00
	cfiAmpMod	$00, $00, $00, $00
	cfiSustainRt	$00, $00, $00, $00
	cfiReleaseRt	$00, $00, $00, $00
	cfiSustainLv	$00, $00, $00, $00
	cfiSSGEG	$00, $00, $00, $00
	cfiAlgorithm	$00
	cfiFeedback	$00

	; Patch 9B
	; 00 00 00 00   00 00 00 00   00 00 00 00
	; 00 00 00 00   00 00 00 00   00 00 00 00
	; 00 00 00 00   00
	cfiName		patch9B
	cfiMultiple	$00, $00, $00, $00
	cfiDetune	$00, $00, $00, $00
	cfiTotalLv	$00, $00, $00, $00
	cfiAttack	$00, $00, $00, $00
	cfiRateScale	$00, $00, $00, $00
	cfiDecayRate	$00, $00, $00, $00
	cfiAmpMod	$00, $00, $00, $00
	cfiSustainRt	$00, $00, $00, $00
	cfiReleaseRt	$00, $00, $00, $00
	cfiSustainLv	$00, $00, $00, $00
	cfiSSGEG	$00, $00, $00, $00
	cfiAlgorithm	$00
	cfiFeedback	$00

	; Patch 9C
	; 00 00 00 00   00 00 00 00   00 00 00 00
	; 00 00 00 00   00 00 00 00   00 00 00 00
	; 00 00 00 00   00
	cfiName		patch9C
	cfiMultiple	$00, $00, $00, $00
	cfiDetune	$00, $00, $00, $00
	cfiTotalLv	$00, $00, $00, $00
	cfiAttack	$00, $00, $00, $00
	cfiRateScale	$00, $00, $00, $00
	cfiDecayRate	$00, $00, $00, $00
	cfiAmpMod	$00, $00, $00, $00
	cfiSustainRt	$00, $00, $00, $00
	cfiReleaseRt	$00, $00, $00, $00
	cfiSustainLv	$00, $00, $00, $00
	cfiSSGEG	$00, $00, $00, $00
	cfiAlgorithm	$00
	cfiFeedback	$00

	; Patch 9D
	; 00 00 00 00   00 00 00 00   00 00 00 00
	; 00 00 00 00   00 00 00 00   00 00 00 00
	; 00 00 00 00   00
	cfiName		patch9D
	cfiMultiple	$00, $00, $00, $00
	cfiDetune	$00, $00, $00, $00
	cfiTotalLv	$00, $00, $00, $00
	cfiAttack	$00, $00, $00, $00
	cfiRateScale	$00, $00, $00, $00
	cfiDecayRate	$00, $00, $00, $00
	cfiAmpMod	$00, $00, $00, $00
	cfiSustainRt	$00, $00, $00, $00
	cfiReleaseRt	$00, $00, $00, $00
	cfiSustainLv	$00, $00, $00, $00
	cfiSSGEG	$00, $00, $00, $00
	cfiAlgorithm	$00
	cfiFeedback	$00

	; Patch 9E
	; 00 00 00 00   00 00 00 00   00 00 00 00
	; 00 00 00 00   00 00 00 00   00 00 00 00
	; 00 00 00 00   00
	cfiName		patch9E
	cfiMultiple	$00, $00, $00, $00
	cfiDetune	$00, $00, $00, $00
	cfiTotalLv	$00, $00, $00, $00
	cfiAttack	$00, $00, $00, $00
	cfiRateScale	$00, $00, $00, $00
	cfiDecayRate	$00, $00, $00, $00
	cfiAmpMod	$00, $00, $00, $00
	cfiSustainRt	$00, $00, $00, $00
	cfiReleaseRt	$00, $00, $00, $00
	cfiSustainLv	$00, $00, $00, $00
	cfiSSGEG	$00, $00, $00, $00
	cfiAlgorithm	$00
	cfiFeedback	$00

	; Patch 9F
	; 00 00 00 00   00 00 00 00   00 00 00 00
	; 00 00 00 00   00 00 00 00   00 00 00 00
	; 00 00 00 00   00
	cfiName		patch9F
	cfiMultiple	$00, $00, $00, $00
	cfiDetune	$00, $00, $00, $00
	cfiTotalLv	$00, $00, $00, $00
	cfiAttack	$00, $00, $00, $00
	cfiRateScale	$00, $00, $00, $00
	cfiDecayRate	$00, $00, $00, $00
	cfiAmpMod	$00, $00, $00, $00
	cfiSustainRt	$00, $00, $00, $00
	cfiReleaseRt	$00, $00, $00, $00
	cfiSustainLv	$00, $00, $00, $00
	cfiSSGEG	$00, $00, $00, $00
	cfiAlgorithm	$00
	cfiFeedback	$00

	; Patch A0
	; 00 00 00 00   00 00 00 00   00 00 00 00
	; 00 00 00 00   00 00 00 00   00 00 00 00
	; 00 00 00 00   00
	cfiName		patchA0
	cfiMultiple	$00, $00, $00, $00
	cfiDetune	$00, $00, $00, $00
	cfiTotalLv	$00, $00, $00, $00
	cfiAttack	$00, $00, $00, $00
	cfiRateScale	$00, $00, $00, $00
	cfiDecayRate	$00, $00, $00, $00
	cfiAmpMod	$00, $00, $00, $00
	cfiSustainRt	$00, $00, $00, $00
	cfiReleaseRt	$00, $00, $00, $00
	cfiSustainLv	$00, $00, $00, $00
	cfiSSGEG	$00, $00, $00, $00
	cfiAlgorithm	$00
	cfiFeedback	$00

	; Patch A1
	; 00 00 00 00   00 00 00 00   00 00 00 00
	; 00 00 00 00   00 00 00 00   00 00 00 00
	; 00 00 00 00   00
	cfiName		patchA1
	cfiMultiple	$00, $00, $00, $00
	cfiDetune	$00, $00, $00, $00
	cfiTotalLv	$00, $00, $00, $00
	cfiAttack	$00, $00, $00, $00
	cfiRateScale	$00, $00, $00, $00
	cfiDecayRate	$00, $00, $00, $00
	cfiAmpMod	$00, $00, $00, $00
	cfiSustainRt	$00, $00, $00, $00
	cfiReleaseRt	$00, $00, $00, $00
	cfiSustainLv	$00, $00, $00, $00
	cfiSSGEG	$00, $00, $00, $00
	cfiAlgorithm	$00
	cfiFeedback	$00

	; Patch A2
	; 00 00 00 00   00 00 00 00   00 00 00 00
	; 00 00 00 00   00 00 00 00   00 00 00 00
	; 00 00 00 00   00
	cfiName		patchA2
	cfiMultiple	$00, $00, $00, $00
	cfiDetune	$00, $00, $00, $00
	cfiTotalLv	$00, $00, $00, $00
	cfiAttack	$00, $00, $00, $00
	cfiRateScale	$00, $00, $00, $00
	cfiDecayRate	$00, $00, $00, $00
	cfiAmpMod	$00, $00, $00, $00
	cfiSustainRt	$00, $00, $00, $00
	cfiReleaseRt	$00, $00, $00, $00
	cfiSustainLv	$00, $00, $00, $00
	cfiSSGEG	$00, $00, $00, $00
	cfiAlgorithm	$00
	cfiFeedback	$00

	; Patch A3
	; 00 00 00 00   00 00 00 00   00 00 00 00
	; 00 00 00 00   00 00 00 00   00 00 00 00
	; 00 00 00 00   00
	cfiName		patchA3
	cfiMultiple	$00, $00, $00, $00
	cfiDetune	$00, $00, $00, $00
	cfiTotalLv	$00, $00, $00, $00
	cfiAttack	$00, $00, $00, $00
	cfiRateScale	$00, $00, $00, $00
	cfiDecayRate	$00, $00, $00, $00
	cfiAmpMod	$00, $00, $00, $00
	cfiSustainRt	$00, $00, $00, $00
	cfiReleaseRt	$00, $00, $00, $00
	cfiSustainLv	$00, $00, $00, $00
	cfiSSGEG	$00, $00, $00, $00
	cfiAlgorithm	$00
	cfiFeedback	$00

	; Patch A4
	; 00 00 00 00   00 00 00 00   00 00 00 00
	; 00 00 00 00   00 00 00 00   00 00 00 00
	; 00 00 00 00   00
	cfiName		patchA4
	cfiMultiple	$00, $00, $00, $00
	cfiDetune	$00, $00, $00, $00
	cfiTotalLv	$00, $00, $00, $00
	cfiAttack	$00, $00, $00, $00
	cfiRateScale	$00, $00, $00, $00
	cfiDecayRate	$00, $00, $00, $00
	cfiAmpMod	$00, $00, $00, $00
	cfiSustainRt	$00, $00, $00, $00
	cfiReleaseRt	$00, $00, $00, $00
	cfiSustainLv	$00, $00, $00, $00
	cfiSSGEG	$00, $00, $00, $00
	cfiAlgorithm	$00
	cfiFeedback	$00

	; Patch A5
	; 00 00 00 00   00 00 00 00   00 00 00 00
	; 00 00 00 00   00 00 00 00   00 00 00 00
	; 00 00 00 00   00
	cfiName		patchA5
	cfiMultiple	$00, $00, $00, $00
	cfiDetune	$00, $00, $00, $00
	cfiTotalLv	$00, $00, $00, $00
	cfiAttack	$00, $00, $00, $00
	cfiRateScale	$00, $00, $00, $00
	cfiDecayRate	$00, $00, $00, $00
	cfiAmpMod	$00, $00, $00, $00
	cfiSustainRt	$00, $00, $00, $00
	cfiReleaseRt	$00, $00, $00, $00
	cfiSustainLv	$00, $00, $00, $00
	cfiSSGEG	$00, $00, $00, $00
	cfiAlgorithm	$00
	cfiFeedback	$00

	; Patch A6
	; 00 00 00 00   00 00 00 00   00 00 00 00
	; 00 00 00 00   00 00 00 00   00 00 00 00
	; 00 00 00 00   00
	cfiName		patchA6
	cfiMultiple	$00, $00, $00, $00
	cfiDetune	$00, $00, $00, $00
	cfiTotalLv	$00, $00, $00, $00
	cfiAttack	$00, $00, $00, $00
	cfiRateScale	$00, $00, $00, $00
	cfiDecayRate	$00, $00, $00, $00
	cfiAmpMod	$00, $00, $00, $00
	cfiSustainRt	$00, $00, $00, $00
	cfiReleaseRt	$00, $00, $00, $00
	cfiSustainLv	$00, $00, $00, $00
	cfiSSGEG	$00, $00, $00, $00
	cfiAlgorithm	$00
	cfiFeedback	$00

	; Patch A7
	; 00 00 00 00   00 00 00 00   00 00 00 00
	; 00 00 00 00   00 00 00 00   00 00 00 00
	; 00 00 00 00   00
	cfiName		patchA7
	cfiMultiple	$00, $00, $00, $00
	cfiDetune	$00, $00, $00, $00
	cfiTotalLv	$00, $00, $00, $00
	cfiAttack	$00, $00, $00, $00
	cfiRateScale	$00, $00, $00, $00
	cfiDecayRate	$00, $00, $00, $00
	cfiAmpMod	$00, $00, $00, $00
	cfiSustainRt	$00, $00, $00, $00
	cfiReleaseRt	$00, $00, $00, $00
	cfiSustainLv	$00, $00, $00, $00
	cfiSSGEG	$00, $00, $00, $00
	cfiAlgorithm	$00
	cfiFeedback	$00

	; Patch A8
	; 00 00 00 00   00 00 00 00   00 00 00 00
	; 00 00 00 00   00 00 00 00   00 00 00 00
	; 00 00 00 00   00
	cfiName		patchA8
	cfiMultiple	$00, $00, $00, $00
	cfiDetune	$00, $00, $00, $00
	cfiTotalLv	$00, $00, $00, $00
	cfiAttack	$00, $00, $00, $00
	cfiRateScale	$00, $00, $00, $00
	cfiDecayRate	$00, $00, $00, $00
	cfiAmpMod	$00, $00, $00, $00
	cfiSustainRt	$00, $00, $00, $00
	cfiReleaseRt	$00, $00, $00, $00
	cfiSustainLv	$00, $00, $00, $00
	cfiSSGEG	$00, $00, $00, $00
	cfiAlgorithm	$00
	cfiFeedback	$00

	; Patch A9
	; 00 00 00 00   00 00 00 00   00 00 00 00
	; 00 00 00 00   00 00 00 00   00 00 00 00
	; 00 00 00 00   00
	cfiName		patchA9
	cfiMultiple	$00, $00, $00, $00
	cfiDetune	$00, $00, $00, $00
	cfiTotalLv	$00, $00, $00, $00
	cfiAttack	$00, $00, $00, $00
	cfiRateScale	$00, $00, $00, $00
	cfiDecayRate	$00, $00, $00, $00
	cfiAmpMod	$00, $00, $00, $00
	cfiSustainRt	$00, $00, $00, $00
	cfiReleaseRt	$00, $00, $00, $00
	cfiSustainLv	$00, $00, $00, $00
	cfiSSGEG	$00, $00, $00, $00
	cfiAlgorithm	$00
	cfiFeedback	$00

	; Patch AA
	; 00 00 00 00   00 00 00 00   00 00 00 00
	; 00 00 00 00   00 00 00 00   00 00 00 00
	; 00 00 00 00   00
	cfiName		patchAA
	cfiMultiple	$00, $00, $00, $00
	cfiDetune	$00, $00, $00, $00
	cfiTotalLv	$00, $00, $00, $00
	cfiAttack	$00, $00, $00, $00
	cfiRateScale	$00, $00, $00, $00
	cfiDecayRate	$00, $00, $00, $00
	cfiAmpMod	$00, $00, $00, $00
	cfiSustainRt	$00, $00, $00, $00
	cfiReleaseRt	$00, $00, $00, $00
	cfiSustainLv	$00, $00, $00, $00
	cfiSSGEG	$00, $00, $00, $00
	cfiAlgorithm	$00
	cfiFeedback	$00

	; Patch AB
	; 00 00 00 00   00 00 00 00   00 00 00 00
	; 00 00 00 00   00 00 00 00   00 00 00 00
	; 00 00 00 00   00
	cfiName		patchAB
	cfiMultiple	$00, $00, $00, $00
	cfiDetune	$00, $00, $00, $00
	cfiTotalLv	$00, $00, $00, $00
	cfiAttack	$00, $00, $00, $00
	cfiRateScale	$00, $00, $00, $00
	cfiDecayRate	$00, $00, $00, $00
	cfiAmpMod	$00, $00, $00, $00
	cfiSustainRt	$00, $00, $00, $00
	cfiReleaseRt	$00, $00, $00, $00
	cfiSustainLv	$00, $00, $00, $00
	cfiSSGEG	$00, $00, $00, $00
	cfiAlgorithm	$00
	cfiFeedback	$00

; --------------------------------------------------------------