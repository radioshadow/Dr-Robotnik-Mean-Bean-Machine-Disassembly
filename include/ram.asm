; --------------------------------------------------------------
; Actor structure
; --------------------------------------------------------------

	rsreset
aField0			rs.b	1
aField1			rs.b	1
aAddr			rs.l	1
aDrawFlags		rs.b	1
aField7			rs.b	1
aMappings		rs.b	1
aFrame			rs.b	1
aX			rs.l	1
aY			rs.l	1
aField12		rs.b	1
aField13		rs.b	1
aField14		rs.b	1
aField15		rs.b	1
aField16		rs.b	1
aField17		rs.b	1
aField18		rs.b	1
aField19		rs.b	1
aField1A		rs.b	1
aField1B		rs.b	1
aField1C		rs.b	1
aField1D		rs.b	1
aField1E		rs.b	1
aField1F		rs.b	1
aField20		rs.b	1
aField21		rs.b	1
aAnimTime		rs.w	1
aDelay			rs.w	1
aField26		rs.b	1
aField27		rs.b	1
aField28		rs.b	1
aField29		rs.b	1
aPlayerID		rs.b	1
aField2B		rs.b	1
aField2C		rs.b	1
aField2D		rs.b	1
aField2E		rs.b	1
aField2F		rs.b	1
aField30		rs.b	1
aField31		rs.b	1
aAnim			rs.l	1
aField36		rs.b	1
aField37		rs.b	1
aField38		rs.b	1
aField39		rs.b	1
aField3A		rs.b	1
aField3B		rs.b	1
aField3C		rs.b	1
aField3D		rs.b	1
aField3E		rs.b	1
aField3F		rs.b	1
aSize			rs.b	0

; --------------------------------------------------------------
; Puyo field structure
; --------------------------------------------------------------

PUYO_FIELD_COLS		EQU	6
PUYO_FIELD_ROWS		EQU	14

	rsreset
pPuyos			rs.w	PUYO_FIELD_COLS
pPlaceablePuyos		rs.w	PUYO_FIELD_COLS
pVisiblePuyos		rs.w	PUYO_FIELD_COLS*(PUYO_FIELD_ROWS-2)
pUnk1			rs.w	PUYO_FIELD_COLS*(PUYO_FIELD_ROWS-2)
pPuyosCopy		rs.w	PUYO_FIELD_COLS
pPlaceablePuyosCopy	rs.w	PUYO_FIELD_COLS
pVisiblePuyosCopy	rs.w	PUYO_FIELD_COLS*(PUYO_FIELD_ROWS-2)
pUnk6			rs.b	$B4
pUnk2			rs.b	8
pCount			rs.w	1
pUnk3			rs.b	(PUYO_FIELD_ROWS-2)
pUnk4			rs.b	8*(PUYO_FIELD_ROWS-2)
pUnk5			rs.b	8*(PUYO_FIELD_ROWS-2)
pSize			rs.b	0

; --------------------------------------------------------------
; RAM definitions
; --------------------------------------------------------------

	rsset	RAM_START
puyo_dec_buffer		rs.b	$100
puyo_dec_vdp_buf	rs.l	1

byte_FF0104		rs.b	1
byte_FF0105		rs.b	1
word_FF0106		rs.w	1
			rs.b	6
word_FF010E		rs.w	1
word_FF0110		rs.w	1

level			rs.b	1
opponent		rs.b	1

byte_FF0114		rs.b	1
byte_FF0115		rs.b	1

opponents_defeated	rs.b	$12

byte_FF0128		rs.b	1
byte_FF0129		rs.b	1
byte_FF012A		rs.b	1
byte_FF012B		rs.b	1
byte_FF012C		rs.b	1
byte_FF012D		rs.b	1
byte_FF012E		rs.b	1
			rs.b	5

dma_disabled		rs.w	1

byte_FF0136		rs.b	1
			rs.b	1

vram_buffer_id		rs.w	1

hblank_count		rs.b	1
hblank_buffer_id	rs.b	1
hblank_buffer_ptr	rs.l	1
hblank_counter		rs.w	1

			rs.b	1
p1_paused		rs.b	1

player_1_flags		rs.b	1
player_2_flags		rs.b	1

saved_puyo_field_p1	rs.b	$240
saved_puyo_field_p2	rs.b	$240

frame_count		rs.w	1
			rs.b	2

time_frames		rs.w	1
time_total_secs		rs.w	1
time_seconds		rs.w	1
time_minutes		rs.w	1

vscroll_buffer		rs.b	$50
hscroll_buffer		rs.b	$400

vdp_reg_0		rs.b	1
vdp_reg_1		rs.b	1
vdp_reg_2		rs.b	1
vdp_reg_3		rs.b	1
vdp_reg_4		rs.b	1
vdp_reg_5		rs.b	1
vdp_reg_6		rs.b	1
vdp_reg_7		rs.b	1
vdp_reg_8		rs.b	1
vdp_reg_9		rs.b	1
vdp_reg_a		rs.b	1
vdp_reg_b		rs.b	1
vdp_reg_c		rs.b	1
vdp_reg_d		rs.b	1
vdp_reg_e		rs.b	1
vdp_reg_f		rs.b	1
vdp_reg_10		rs.b	1
vdp_reg_11		rs.b	1
vdp_reg_12		rs.b	1
vdp_reg_13		rs.b	1

bytecode_addr		rs.l	1
bytecode_flag		rs.b	1
bytecode_disabled	rs.b	1
bytecode_done		rs.b	1
			rs.b	1

palette_pointers	rs.b	6*4
palette_buffer		rs.b	$20*4
pal_fade_data		rs.b	$82*4

plane_cmd_count		rs.w	1
plane_cmd_queue		rs.b	4*$40
plane_cmd_queue_end	rs.b	0

word_FF0DE0		rs.w	1

draw_order		rs.w	1
sprite_count		rs.w	1
sprite_layers		rs.b	$50
sprite_links		rs.b	$50

sprite_buffer		rs.b	$280

dma_cmd_low		rs.w	1

pressed_time		rs.b	1
unpressed_time		rs.b	1

p1_ctrl_hold		rs.b	1
p1_ctrl_press		rs.b	1
byte_FF110C		rs.b	1
			rs.b	3

p2_ctrl_hold		rs.b	1
p2_ctrl_press		rs.b	1
byte_FF1112		rs.b	1
			rs.b	3

rng_seed		rs.l	1
cur_level_music		rs.b	1
			rs.b	1

dma_slot		rs.w	1

current_password	rs.w	1
difficulty		rs.b	1
byte_FF1121		rs.b	1
word_FF1122		rs.w	1
word_FF1124		rs.w	1
word_FF1126		rs.w	1
byte_FF1128		rs.b	1
byte_FF1129		rs.b	1

use_lair_background	rs.w	1

dword_FF112C		rs.l	1
dword_FF1130		rs.l	1
word_FF1134		rs.w	1
word_FF1136		rs.w	1

sound_playing		rs.b	1
			rs.b	1
sound_queue_open	rs.b	1
sound_queue_tail	rs.b	1
sounds_queued		rs.b	1
sound_queue_current	rs.b	1

sound_queue		rs.b	$100

p1_puyo_order		rs.b	$100
p2_puyo_order		rs.b	$100
byte_FF143E		rs.b	8
byte_FF1446		rs.b	$A2
byte_FF14E8		rs.b	$A2
byte_FF158A		rs.b	$A2
byte_FF162C		rs.b	$A2
byte_FF16CE		rs.b	$A2
byte_FF1770		rs.b	$A2
byte_FF1812		rs.b	$A2
byte_FF18B4		rs.b	$A2

use_plane_a_buffer	rs.w	1

control_player_1	rs.b	1
control_puyo_drop	rs.b	1
skip_scenario_stages	rs.b	1
byte_FF195B		rs.b	1
dword_FF195C		rs.l	1
dword_FF1960		rs.l	1

level_mode		rs.b	1
byte_FF1965		rs.b	1
swap_controls		rs.b	1
			rs.b	3
byte_FF196A		rs.b	1
byte_FF196B		rs.b	1
			rs.b	2
word_FF196E		rs.w	1
byte_FF1970		rs.b	1
byte_FF1971		rs.b	1
high_score_table_id	rs.b	1
byte_FF1973		rs.b	1
level_transition_flag	rs.w	1

stage_text_buffer	rs.b	8
			rs.b	4

byte_FF1982		rs.b	8
word_FF198A		rs.w	1
word_FF198C		rs.w	1
word_FF198E		rs.w	1
word_FF1990		rs.w	1
word_FF1992		rs.w	1
word_FF1994		rs.w	1

garbage_puyo_data	rs.b	6
			rs.b	6
			rs.b	6

word_FF19A8		rs.w	1
puyos_popping		rs.w	1
garbage_glow_x		rs.w	1
garbage_glow_y		rs.w	1

byte_FF19B0		rs.b	1
byte_FF19B1		rs.b	1
byte_FF19B2		rs.b	1
			rs.b	1
			rs.b	2
byte_FF19B6		rs.b	4*6
byte_FF19CE		rs.b	$192
byte_FF1B60		rs.b	4*6
byte_FF1B78		rs.b	$192
byte_FF1D0A		rs.b	1
byte_FF1D0B		rs.b	1
byte_FF1D0C		rs.b	1
byte_FF1D0D		rs.b	1
byte_FF1D0E		rs.b	1
			rs.b	1
byte_FF1D10		rs.b	5
			rs.b	1
byte_FF1D16		rs.b	1
byte_FF1D17		rs.b	1
byte_FF1D18		rs.b	1
byte_FF1D19		rs.b	1
byte_FF1D1A		rs.b	1
byte_FF1D1B		rs.b	1
byte_FF1D1C		rs.b	1
byte_FF1D1D		rs.b	1
byte_FF1D1E		rs.b	4*12
byte_FF1D4E		rs.b	$A
byte_FF1D58		rs.b	$A

puyo_field_p1		rs.b	pSize
puyo_field_p2		rs.b	pSize

			rs.b	$BCA

eni_tilemap_buffer	rs.b	$1000
eni_tilemap_queue	rs.b	$100
nem_buffer		rs.b	$200
dma_queue		rs.b	$10*$D0

hblank_buffer_1		rs.b	$200
hblank_buffer_2		rs.b	$200
			rs.b	$400
			rs.b	$800
			rs.b	$800

misc_buffer_1		rs.b	$620
misc_buffer_2		rs.b	$51E0

plane_a_buffer		rs.b	$1000

vram_buffer		rs.b	$800
			rs.b	$800

actors			rs.b	0
actor_slot_0		rs.b	aSize
actor_slot_1		rs.b	aSize
actor_slot_2		rs.b	aSize
actor_slot_3		rs.b	aSize
actor_slot_4		rs.b	aSize
actor_slot_5		rs.b	aSize
actor_slot_6		rs.b	aSize
actor_slot_7		rs.b	aSize
actor_slot_8		rs.b	aSize
actor_slot_9		rs.b	aSize
actor_slot_a		rs.b	aSize
actor_slot_b		rs.b	aSize
actor_slot_c		rs.b	aSize
actor_slot_d		rs.b	aSize
actor_slot_e		rs.b	aSize
actor_slot_f		rs.b	aSize
actor_slot_10		rs.b	aSize
actor_slot_11		rs.b	aSize
actor_slot_12		rs.b	aSize
actor_slot_13		rs.b	aSize
actor_slot_14		rs.b	aSize
actor_slot_15		rs.b	aSize
actor_slot_16		rs.b	aSize
actor_slot_17		rs.b	aSize
actor_slot_18		rs.b	aSize
actor_slot_19		rs.b	aSize
actor_slot_1a		rs.b	aSize
actor_slot_1b		rs.b	aSize
actor_slot_1c		rs.b	aSize
actor_slot_1d		rs.b	aSize
actor_slot_1e		rs.b	aSize
actor_slot_1f		rs.b	aSize
actor_slot_20		rs.b	aSize
actor_slot_21		rs.b	aSize
actor_slot_22		rs.b	aSize
actor_slot_23		rs.b	aSize
actor_slot_24		rs.b	aSize
actor_slot_25		rs.b	aSize
actor_slot_26		rs.b	aSize
actor_slot_27		rs.b	aSize
actor_slot_28		rs.b	aSize
actor_slot_29		rs.b	aSize
actor_slot_2a		rs.b	aSize
actor_slot_2b		rs.b	aSize
actor_slot_2c		rs.b	aSize
actor_slot_2d		rs.b	aSize
actor_slot_2e		rs.b	aSize
actor_slot_2f		rs.b	aSize
actor_slot_30		rs.b	aSize
actor_slot_31		rs.b	aSize
actor_slot_32		rs.b	aSize
actor_slot_33		rs.b	aSize
actor_slot_34		rs.b	aSize
actor_slot_35		rs.b	aSize
actor_slot_36		rs.b	aSize
actor_slot_37		rs.b	aSize
actor_slot_38		rs.b	aSize
actor_slot_39		rs.b	aSize
actor_slot_3a		rs.b	aSize
actor_slot_3b		rs.b	aSize
actor_slot_3c		rs.b	aSize
actor_slot_3d		rs.b	aSize
actor_slot_3e		rs.b	aSize
actor_slot_3f		rs.b	aSize
actors_end		rs.b	0

stack			rs.b	$C00
stack_base		rs.b	0

			rs.b	2
sound_test_enabled	rs.w	1

high_scores		rs.b	$A0

game_matches		rs.b	1
com_level		rs.b	1
player_1_a		rs.b	1
player_1_b		rs.b	1
player_1_c		rs.b	1
player_2_a		rs.b	1
player_2_b		rs.b	1
player_2_c		rs.b	1
disable_samples		rs.b	1

			rs.b	$153
byte_FFFE00		rs.b	$B0
			rs.b	$150

; --------------------------------------------------------------