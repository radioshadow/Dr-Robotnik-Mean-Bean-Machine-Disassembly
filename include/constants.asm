; --------------------------------------------------------------
; BGM track IDs
; --------------------------------------------------------------

BGM_PROTO_TITLE		EQU	1
BGM_MENU		EQU	2
BGM_FINAL_CUTSCENE	EQU	3
BGM_DANGER		EQU	4
BGM_STAGE_1		EQU	5
BGM_FINAL_STAGE		EQU	6
BGM_STAGE_3		EQU	7
BGM_FINAL_WIN		EQU	8
BGM_GAME_OVER		EQU	9
BGM_ROLE_CALL		EQU	$A
BGM_CREDITS		EQU	$B
BGM_PUYO_WIN		EQU	$C
BGM_SILENCE		EQU	$D
BGM_PASSWORD		EQU	$E
BGM_PUYO_BRAVE		EQU	$F
BGM_PUYO_THEME		EQU	$10
BGM_EXERCISE		EQU	$11
BGM_VERSUS		EQU	$12
BGM_STAGE_2		EQU	$13
BGM_FINAL_DANGER	EQU	$14
BGM_UNKNOWN		EQU	$15
BGM_CUTSCENE_3		EQU	$16
BGM_CUTSCENE_1		EQU	$17
BGM_CUTSCENE_2		EQU	$18
BGM_WIN			EQU	$19
BGM_TITLE		EQU	$1A

; --------------------------------------------------------------
; SFX IDs
; --------------------------------------------------------------

SFX_MENU_SELECT		EQU	$41
SFX_MENU_MOVE		EQU	$42
SFX_PUYO_MOVE		EQU	$43
SFX_PUYO_ROTATE		EQU	$44
SFX_PUYO_LAND		EQU	$45
SFX_46			EQU	$46
SFX_47			EQU	$47
SFX_PUYO_LAND_HARD	equ	$48
SFX_49			EQU	$49
SFX_4A			EQU	$4A
SFX_4B			EQU	$4B
SFX_PUYO_POP_1		EQU	$4C
SFX_PUYO_POP_2		EQU	$4D
SFX_PUYO_POP_3		EQU	$4E
SFX_PUYO_POP_4		EQU	$4F
SFX_PUYO_POP_5		EQU	$50
SFX_PUYO_POP_6		EQU	$51
SFX_PUYO_POP_7		EQU	$52
SFX_53			EQU	$53
SFX_GARBAGE_1		EQU	$54
SFX_GARBAGE_2		EQU	$55
SFX_GARBAGE_3		EQU	$56
SFX_57			EQU	$57
SFX_58			EQU	$58
SFX_LOSE		EQU	$59
SFX_5A			EQU	$5A
SFX_5B			EQU	$5B
SFX_5C			EQU	$5C
SFX_5D			EQU	$5D
SFX_5E			EQU	$5E
SFX_5F			EQU	$5F
SFX_60			EQU	$60
SFX_61			EQU	$61
SFX_62			EQU	$62
SFX_LEVEL_START		EQU	$63
SFX_64			EQU	$64
SFX_65			EQU	$65
SFX_66			EQU	$66
SFX_67			EQU	$67
SFX_68			EQU	$68
SFX_69			EQU	$69
SFX_6A			EQU	$6A
SFX_ROBOTNIK_LAUGH	equ	$6B
SFX_6C			EQU	$6C
SFX_ROBOTNIK_LAUGH_2	EQU	$6D
SFX_GARBAGE_4		EQU	$6E
SFX_STOP		EQU	$6F
SFX_70			EQU	$70
SFX_71			EQU	$71
SFX_72			EQU	$72

; --------------------------------------------------------------
; Voice IDs
; --------------------------------------------------------------

VOI_P1_COMBO_1		EQU	$81
VOI_P1_COMBO_2		EQU	$82
VOI_P1_COMBO_3		EQU	$83
VOI_P1_COMBO_4		EQU	$84
VOI_P2_COMBO_1		EQU	$85
VOI_P2_COMBO_2		EQU	$86
VOI_87			EQU	$87
VOI_GARBAGE_1		EQU	$88
VOI_GARBAGE_2		EQU	$89
VOI_GARBAGE_3		EQU	$8A
VOI_8B			EQU	$8B
VOI_8C			EQU	$8C
VOI_P2_COMBO_3		EQU	$8D
VOI_P2_COMBO_4		EQU	$8E
VOI_8F			EQU	$8F
VOI_ROBOTNIK_LOSE	EQU	$90
VOI_91			EQU	$91
VOI_THUNDER_1		EQU	$92
VOI_THUNDER_2		EQU	$93
VOI_THUNDER_3		EQU	$94
VOI_THUNDER_4		EQU	$95
VOI_96			EQU	$96
VOI_VANISH		EQU	$97

; --------------------------------------------------------------
; Sound command IDs
; --------------------------------------------------------------

SND_FADE_OUT		EQU	$FD
BGM_STOP		EQU	$FE
SND_PAUSE		EQU	$FF

; --------------------------------------------------------------
; Opponent IDs
; --------------------------------------------------------------

OPP_LESSON_1		EQU	$00
OPP_FRANKLY		EQU	$01
OPP_DYNAMIGHT		EQU	$02
OPP_ARMS		EQU	$03
OPP_LESSON_2		EQU	$04
OPP_GROUNDER		EQU	$05
OPP_DAVY		EQU	$06
OPP_COCONUTS		EQU	$07
OPP_SPIKE		EQU	$08
OPP_SIR_FFUZZY		EQU	$09
OPP_DRAGON		EQU	$0A
OPP_SCRATCH		EQU	$0B
OPP_ROBOTNIK		EQU	$0C
OPP_LESSON_3		EQU	$0D
OPP_HUMPTY		EQU	$0E
OPP_SKWEEL		EQU	$0F

; --------------------------------------------------------------
; Puyo color IDs
; --------------------------------------------------------------

PUYO_RED		EQU	$00
PUYO_YELLOW		EQU	$01
PUYO_TEAL		EQU	$02
PUYO_GREEN		EQU	$03
PUYO_PURPLE		EQU	$04
PUYO_BLUE		EQU	$05
PUYO_GARBAGE		EQU	$06

; --------------------------------------------------------------
; Button press IDs
; --------------------------------------------------------------

BUTTON_U		EQU $01 ; Up
BUTTON_D		EQU $02 ; Down
BUTTON_L		EQU $04 ; Left
BUTTON_R		EQU $08 ; Right
BUTTON_A		EQU $40 ; A
BUTTON_B		EQU $10 ; B
BUTTON_C		EQU $20 ; C
BUTTON_S		EQU $80 ; START

END_OF_CODE		EQU $FF ; End of code

; --------------------------------------------------------------