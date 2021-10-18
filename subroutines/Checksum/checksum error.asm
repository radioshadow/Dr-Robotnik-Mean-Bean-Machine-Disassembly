; =============== S U B	R O U T	I N E =====================================================
; Check checksum
; -----------------------------------------------------------------------------------------

					move.b	#$FF,(use_plane_a_buffer).l
					move.w	#$E000,d5
					move.w	#$1B,d0
					move.w	#$406C,d6

.bg_row:
					DISABLE_INTS
					jsr		SetVRAMWrite
					addi.w	#$80,d5
					move.w	#$27,d1

.bg_tile:
					move.w	d6,VDP_DATA
					eori.b	#1,d6
					dbf		d1,.bg_tile
					ENABLE_INTS
					eori.b	#2,d6
					dbf		d0,.bg_row
					bsr.w	Options_ClearPlaneA
					move.w	#$5A0,d5
					move.w	#$A500,d6
					lea		(Str_ChecksumWarning).l,a1
					bsr.w	Options_PrintRaw
					move.w	#$796,d5
					move.w	#$8500,d6
					lea		(Str_ChecksumIncorrect).l,a1
					bsr.w	Options_PrintRaw
					lea		(ActChecksumError).l,a1
					jmp		FindActorSlot

; -----------------------------------------------------------------------------------------
Str_ChecksumWarning:
					include "data/text/Checksum/Checksum - Line 1.asm"
					
Str_ChecksumIncorrect:
					include "data/text/Checksum/Checksum - Line 2.asm"

; =============== S U B	R O U T	I N E =====================================================

ActChecksumError:
					move.w	#$100,d0
					jsr	(ActorBookmark_SetDelay).l

.Wait:
					jsr	(ActorBookmark_Ctrl).l

.Exit:
					clr.b	(use_plane_a_buffer).l
					clr.b	(bytecode_disabled).l
					jmp		(ActorDeleteSelf).l	