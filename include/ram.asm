; --------------------------------------------------------------
;
;	Dr. Robotnik's Mean Bean Machine Disassembly
;	Original game by Compile
;
;	Disassembled by Devon Artmeier
;
; --------------------------------------------------------------

PLANE_CMD_SLOT_COUNT	EQU	$40
ACTOR_SLOT_COUNT	EQU	$40

; --------------------------------------------------------------
; Palette fade data structure
; --------------------------------------------------------------

	rsreset

pfdActive		rs.w	1
pfdSplitPal		rs.b	$10*3
pfdAccums		rs.b	$10*3
pfdMDPal		rs.b	$10*2
pfdSize			rs.b	0

; --------------------------------------------------------------
; Controller data structure
; --------------------------------------------------------------

	rsreset
ctlHold			rs.b	1
ctlPress		rs.b	1
ctlPulse		rs.b	1
ctlPulseH		rs.b	1
ctlPulseV		rs.b	1
ctlSize			rs.b	0

; --------------------------------------------------------------
; Puyo field structure
; --------------------------------------------------------------

PUYO_FIELD_W		EQU	6
PUYO_FIELD_H		EQU	12

	rsreset
pfColors		rs.w	PUYO_FIELD_W*2
pfVisColors		rs.w	PUYO_FIELD_W*PUYO_FIELD_H
pfPuyoFlags		rs.w	PUYO_FIELD_W*PUYO_FIELD_H

; --------------------------------------------------------------
; Garbage puyo data structure
; --------------------------------------------------------------

	rsreset

gpOrder			rs.b	PUYO_FIELD_W
gpFreeSpace		rs.b	PUYO_FIELD_W
gpCounts		rs.b	PUYO_FIELD_W
gpSize			rs.b	0

; --------------------------------------------------------------
; Actor structure
; --------------------------------------------------------------

	rsreset

aRunFlags		rs.b	1			; 0
aLoaded			rs.b	1			; 1
aAddr			rs.l	1			; 2
aFlags			rs.b	1			; 6
aField7			rs.b	1			; 7
aMappings		rs.b	1			; 8
aFrame			rs.b	1			; 9
aX			rs.l	1			; A
aY			rs.l	1			; E
aXVel			rs.l	1			; 12
aYVel			rs.l	1			; 16
aXAccel			rs.w	1			; 1A
aYAccel			rs.w	1			; 1C
aXTarget		rs.w	1			; 1E
aYTarget		rs.w	1			; 20
aAnimTime		rs.w	1			; 22
aDelay			rs.w	1			; 24
aField26		rs.b	1			; 26
aField27		rs.b	1			; 27
aField28		rs.b	1			; 28
aField29		rs.b	1			; 29
aPuyoField		rs.b	0			; 2A
aField2A		rs.b	1			; 2A
aDifficulty		rs.b	0			; 2B
aField2B		rs.b	1			; 2B
aField2C		rs.b	1			; 2C
aField2D		rs.b	1			; 2D
aField2E		rs.b	1			; 2E
aField2F		rs.b	1			; 2F
aField30		rs.b	1			; 30
aField31		rs.b	1			; 31
aAnim			rs.l	1			; 32
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
; RAM definitions
; --------------------------------------------------------------

	rsset	RAM_START

buffer			rs.b	0
puyo_dec_buffer		rs.b	$100
puyo_dec_vdp_buf	rs.l	1

byte_FF0104		rs.b	1
byte_FF0105		rs.b	1
word_FF0106		rs.w	1
			rs.b	6
word_FF010E		rs.w	1
word_FF0110		rs.w	1

stage			rs.b	1
opponent		rs.b	1

byte_FF0114		rs.b	1
byte_FF0115		rs.b	1

opponents_defeated	rs.b	$12

p1_win_count		rs.b	1
p2_win_count		rs.b	1
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
player_paused		rs.b	1

p1_pause		rs.b	1
p2_pause		rs.b	1

p1_puyo_field_gfx	rs.b	$240
p2_puyo_field_gfx	rs.b	$240

frame_count		rs.w	1
			rs.b	2

time_frames		rs.w	1
time_total_seconds	rs.w	1
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

pal_load_queue		rs.b	6*4
palette_buffer		rs.b	$20*4
pal_fade_data		rs.b	pfdSize*4

plane_cmd_count		rs.w	1
plane_cmd_queue		rs.b	4*PLANE_CMD_SLOT_COUNT
plane_cmd_queue_end	rs.b	0

word_FF0DE0		rs.w	1

draw_order		rs.w	1
sprite_count		rs.w	1
sprite_layers		rs.b	$50
sprite_links		rs.b	$50

sprite_buffer		rs.b	$280

dma_cmd_low		rs.w	1

press_pulse_time	rs.b	1
hold_pulse_time		rs.b	1

p1_ctrl			rs.b	ctlSize
			rs.b	1

p2_ctrl			rs.b	ctlSize
			rs.b	1

rng_seed		rs.l	1
current_stage_music	rs.b	1
			rs.b	1

dma_slot		rs.w	1

current_password	rs.w	1
difficulty		rs.b	1
byte_FF1121		rs.b	1
disallow_skipping	rs.w	1
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

puyo_order_1		rs.b	$100
puyo_order_2		rs.b	$100

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

use_cpu_player		rs.b	1
control_puyo_drops	rs.b	1
skip_stages		rs.b	1
unk_debug_flag		rs.b	1

dword_FF195C		rs.l	1
dword_FF1960		rs.l	1

stage_mode		rs.b	1
byte_FF1965		rs.b	1
swap_fields		rs.b	1
			rs.b	3
main_player_field	rs.b	1
byte_FF196B		rs.b	1
			rs.b	2
word_FF196E		rs.w	1
byte_FF1970		rs.b	1
byte_FF1971		rs.b	1
high_score_table_id	rs.b	1
byte_FF1973		rs.b	1
stage_transition_flag	rs.w	1

stage_text_buffer	rs.b	8
			rs.b	4

byte_FF1982		rs.b	8
p1_score_vram		rs.w	1
word_FF198C		rs.w	1
word_FF198E		rs.w	1
word_FF1990		rs.w	1
word_FF1992		rs.w	1
word_FF1994		rs.w	1

garbage_puyo_data	rs.b	gpSize

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

p1_puyo_field		rs.b	$29C
p1_puyo_count		rs.w	1
			rs.b	$CC
p2_puyo_field		rs.b	$29C
puyo_count_p2		rs.w	1
			rs.b	$CC
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
i = 0
	while i<ACTOR_SLOT_COUNT
actor_slot_\$i\		rs.b	aSize
i = i+1
	endw
actors_end		rs.b	0

stack			rs.b	$C00
stack_base		rs.b	0

save_data_checksum	rs.w	1
save_data		rs.b	0
is_japan		rs.w	1
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
			rs.b	3

			rs.b	$150

save_backup_checksum	rs.w	$1
save_backup		rs.b	$AE

			rs.b	$150

; --------------------------------------------------------------