; ------------------------------------------------------------------------------
; Nemesis decompression - improved
; ------------------------------------------------------------------------------
; Optimized by vladikcomper, further optimizations & comments by carljr17
; ------------------------------------------------------------------------------
 
NemDecRAM:
 
    ; INPUT:
    ;   a0 -> number of patterns + mode, followed by compressed data
    ;   a4 -> RAM to output patterns to
 
    movem.l d0-d6/a0-a1/a3-a5,-(sp)     ; 8 + 8*12 = 104
 
	lea     NemDec_WriteRowToRAM(pc),a3 ; 8
 
    bra.s   NemDec_Main                 ; 10
 
; ------------------------------------------------------------------------------
 
NemDec:
 
    ; INPUT:
    ;   a0 -> number of patterns + mode, followed by compressed data
 
    movem.l d0-d6/a0-a1/a3-a5,-(sp)
	
	andi.l	#$FFFF,d0
	add.l	d0,d0
	add.l	d0,d0
	lsr.w	#2,d0
	swap	d0
	addi.l	#$40000000,d0
	move.l	d0,VDP_CTRL
 
    lea     NemDec_WriteRowToVDP(pc),a3 ;  8 a3  = jump address for pixel row writes
    lea		VDP_DATA,a4                 ; 12 a4 -> [vdp_data_port]

NemDec_Main:
    ; INPUT:
    ;   a3  = NemDec_WriteRowToRAM/VDP
    ;   a4 -> [$C00000] (vdp_data_port) (or anywhere in RAM)
 
    lea	(nem_buffer).l,a1          	;  8 a1 -> [$FF4100] (Nemesis decompression buffer)
 
    move.w  (a0)+,d3                ;  8 d3 <- #/patterns (MSB set for Mode 1)
    bpl.s   @NemDecBreak            ; 10/8 d3.15 == 1 ? no, so in Mode 0 (not based on changes between rows)
 
    lea     NemDec_WriteRowToVDP_XOR-NemDec_WriteRowToVDP(a3),a3 ;  8 yes, so in Mode 1 (each row XOR'd with last, only changes recorded)

@NemDecBreak:
    lsl.w   #3,d3                   ; 6 + 2*3 = 12 -.
    subq.w  #1,d3                   ;            4 -' d3 = #/patterns * 8 (= number of rows to plot), minus 1
 
	bsr.w   NemDec4                 ; 18 d0-d2/d5/a5 build opcode-to-count/color lookup table
 
    moveq   #0,d2                   ; for use with Mode 1 only (XOR with first row)
    moveq   #1,d4                   ; set stop bit (nybble counter) -- 8 pixels per row
 
    move.b  (a0)+,d5                ; -. get first two bytes of compressed data
    asl.w   #8,d5                   ;  : (can't we replace this with move.w (a0)+,d5 !?)
    move.b  (a0)+,d5                ; -'
 
    moveq   #16,d6                  ; 16 bits ready, set initial shift value
 
    bsr.s   NemDec2                 ; read in from bit stream of opcodes/in-line data, output rows
 
    movem.l (sp)+,d0-d6/a0-a1/a3-a5
 
    rts
 
; ---------------------------------------------------------------------------
; Part of the Nemesis decompressor, processes the actual compressed data
; ---------------------------------------------------------------------------
 
NemDec3: ; this is an entry point for compatibility with code in sonic.asm
 
    move.w  a5,d3                   ;  4 -. number of rows to plot from a5 (for compatibility)
    subq.w  #1,d3                   ;  4 -'
    moveq   #1,d4                   ;  4 reset 8-pixel row, set stop bit/nybble counter
 
    eor.b   d1,d4                   ;  4 cheaper than a branch around next instruction

NemDec_WritePixelLoop:
    eor.b   d1,d4                   ;  4 d4.l = ........ ........ .......! 00001111 etc.

NemDec3_1:
    dbra    d0,NemDec_WritePixel    ; 10/12 --repeat count == -1 ? no, so plot another pixel

NemDec2:
    ; INPUT:
 
    ;   a0 -> stream of bits -- opcodes and/or in-line data
    ;   a1 -> [$FFAA000] (LUT: opcode to palette, repeat count, & opcode width, 512 bytes)
    ;   a3  = NemDec_WriteRowToRAM/VDP/_XOR
    ;   a4 -> [$C00000] (vdp_data_port) (or anywhere in RAM)
 
    ;   d2.l  = previous row of 8 pixels, or 0 if first row; XOR'd with new row (mode 1 only)
    ;   d3.w  = number of patterns * 8 (= number of rows to plot), minus 1
    ;   d4.l  = holds 8 pixel nibbles, initially 1 (used as a stop bit or nybble counter)
    ;   d5.w  = [a0 - 2] (first 16 bits of stream, read left to right)
    ;   d6.b  = #/bits remaining to process, initially 16
 
    ; TRASHES: d0-d1
 
    sub.b   #9,d6                   ;  8 get right shift value to peek ahead at next 9 bits
    move.w  d5,d0                   ;  4    -. left-justify opcode (high bit in bit #8),
    lsr.w   d6,d0                   ;  6+2n -' followed by 1 or more unrelated, unprocessed bits
 
    andi.w  #$01FE,d0               ;  8 isolate 8 bits for lookup: opcode and 1 or more unrelated bits
    sub.b   0(a1,d0.w),d6           ; 14 subtract opcode width, minus 9, from #/bits remaining
    move.b  1(a1,d0.w),d0           ; 14 d0.w <- .......? irrrpppp
    bpl.s   NemDec_NotInline        ; if i == 1, inline: next 7 bits are palette + count (rrrpppp)
 
    cmpi.b  #9,d6                   ; 9 or more bits still available ?
    bcc.s   @NemDec2BreakA          ; no,  so not enough room to read next byte
 
    addq.b  #8,d6                   ; 8 new bits, about to be read in below
    asl.w   #8,d5                   ; shift all remaining bits into high byte
    move.b  (a0)+,d5                ; get next 8 bits into low of d5

@NemDec2BreakA:
    subq.b  #7,d6                   ; 7 bits needed for inline data itself (palette + count) * (could be combined in above sub)
    move.w  d5,d0
    lsr.w   d6,d0                   ; shift so that low bit rrrpppp is in bit position 0

NemDec_NotInline:
    cmpi.b  #9,d6                   ; 9 or more bits still available ?
    bcc.s   @NemDec2BreakB          ; no,  so not enough room for read next byte
 
    addq.b  #8,d6                   ; 8 new bits, about to be read in below
    asl.w   #8,d5                   ; shift all remaining bits into high byte
    move.b  (a0)+,d5                ; get next 8 bits into low of d5

@NemDec2BreakB:
    move.b  d0,d1                   ; d1.w  = ???????? ?rrrpppp
    andi.b  #$0F,d1                 ;       = ???????? ....pppp (palette index)
    andi.w  #$0070,d0               ; d0.w  = ........ .rrr....
    lsr.w   #4,d0                   ;       = ........ .....rrr (repeat count, minus 1; clear bits 8-15)

NemDec_WritePixel:
    lsl.l   #4,d4                   ; d4.l = ........ ........ .......! 0000....
    bcc.s   NemDec_WritePixelLoop   ; 10/8
 
    or.b    d1,d4                   ; d4.l = 00001111 22223333 44445555 66667777
 
    jmp     (a3)                    ; 8
 
; ---------------------------------------------------------------------------
 
NemDec_WriteRowToVDP:
 
loc_1502:
 
    move.l  d4,(a4)                 ; write 8-pixel row to VDP control port
 
    moveq   #1,d4                   ;  4 reset 8-pixel row, set stop bit/nybble counter
 
    dbra    d3,NemDec3_1            ; 10/12 have all 8-pixel rows been written ? if yes, branch
 
    rts
 
NemDec_WriteRowToVDP_XOR:
 
    eor.l   d4,d2                   ; XOR the previous row by the current row
    move.l  d2,(a4)                 ; write new current row to VDP control port
 
    moveq   #1,d4                   ;  4 reset 8-pixel row, set stop bit/nybble counter
 
    dbra    d3,NemDec3_1            ; 10/12 have all 8-pixel rows been written ? if yes, branch
 
    rts
 
; ---------------------------------------------------------------------------
 
NemDec_WriteRowToRAM:
 
    move.l  d4,(a4)+                ; write 8-pixel row to RAM, with post-increment
 
    moveq   #1,d4                   ;  4 reset 8-pixel row, set stop bit/nybble counter
 
    dbra    d3,NemDec3_1            ; 10/12 have all 8-pixel rows been written ? if yes, branch
 
    rts
 
NemDec_WriteRowToRAM_XOR:
 
    eor.l   d4,d2                   ; XOR the previous row by the current row
    move.l  d2,(a4)+                ; write new current row to RAM with post-increment
 
    moveq   #1,d4                   ;  4 reset 8-pixel row, set stop bit/nybble counter
 
	dbra    d3,NemDec3_1            ; 10/12 have all 8-pixel rows been written ? if yes, branch
 
    rts
 
; ---------------------------------------------------------------------------
; Part of the Nemesis decompressor, builds the code table (in RAM)
; ---------------------------------------------------------------------------
 
NemDec4:
 
    ; INPUT:
 
    ;   a0 -> !...pppp (palette index -- 1st need not have bit #7 set)
    ;         .rrrcccc (repeat count + code length)
    ;         cccccccc (opcode, mysteriously right-justified)
    ;         .rrrcccc (repeat count + code length)
    ;         cccccccc (opcode, mysteriously right-justified)
    ;         ...
    ;         $FF      (end-of-table)
    ;   a1 -> [$FFAA000] (nemesis decompression buffer -- actually 512 byte opcode-to-count/color LUT)
 
	; TRASHES: d0-2/d5/a5
 
    lea     $01F8(a1),a5            ;  8 point to last four entries of table (used to flag inline data)
    move.l  #$FDFFFDFF,d5           ; 12 set cccc (opcode width) = 6 (minus 9), i (inline) = 1, rrrpppp = don't care
    move.l  d5,(a5)+                ; 12 [$01F8 + 0/2].w <- !!!!cccc irrrpppp
    move.l  d5,(a5)+                ; 12 [$01F8 + 4/6].w <- !!!!cccc irrrpppp
 
    move.b  (a0)+,d0                ;  8 read 1st byte (????pppp or $FF for end-of-table)
 
    bra.s   @ChkEnd                 ; 10 if d0.7 == 1, end of table ($FF) OR new palette index (!???pppp)
 
@ItemLoop:
 
    move.b  d0,d5                   ;  4 d5.w = ???????? .rrrcccc (rrr = repeat count, cccc = opcode width)
    andi.w  #$000F,d2               ;  8 d2.w = ........ ....pppp
    andi.w  #$0070,d0               ;  8 d0.w = ........ .rrr.... (note bits 8-15 cleared for below)
    or.b    d0,d2                   ;  4 d2.w = ........ .rrrpppp
 
	eor.b   d0,d5                   ;  4 d5.w = ???????? ....cccc
 
    moveq   #8,d1                   ;  4 -. d1.b = 8 - opcode width = shift left count (for left-justify)
    sub.b   d5,d1                   ;  4 -' i.e., 12345678 -> 76543210
 
    sub.b   #9,d5                   ;  8 opcode width - 9 needed for NemDec2 *
    lsl.w   #8,d5                   ; 6 + 2*8 = 22 d5.w = !!!!cccc ........
    or.w    d5,d2                   ;  4           d2.w = !!!!cccc .rrrpppp (table entry)
 
    move.b  (a0)+,d0                ;  8 get actual opcode (mysteriously not shifted into position)
    lsl.b   d1,d0                   ; 6 + 2*d1 d0.b = opcode << ( 8 - opcode width ) (= left justify opcode; but why isn't this just pre-shifted ?)
    add.w   d0,d0                   ;  4 double to index into table of words
 
    moveq   #0,d5                   ;  4 -.
    bset    d1,d5                   ;  6  : d5 = 1 << ( 8 - opcode length ) - 1
    subq.b  #1,d5                   ;  4 -'    = #/times to repeat table entry
 
    lea     (a1,d0.w),a5            ; 12 (versus 4 move.w a1, a5 + 8 add.w d0, a5 = 12)

@ItemShortCodeLoop:
    move.w  d2,(a5)+                ;  8 store entry: !!!!cccc .rrrpppp
    dbra    d5,@ItemShortCodeLoop   ; 10/14 repeat for required number of entries

@ChkNext:
    move.b  (a0)+,d0                ;  8 palette index, repeat count/opcode width, or end-of-table
    bpl.s   @ItemLoop               ; 10/8 if d0.7 == 0, repeat count/opcode width

@ChkEnd:
    move.b  d0,d2                   ;  4 d2.w = ???????? ????pppp (pppp = palette index)
 
    not.b   d0                      ;  4 reached end-of-table ?
    bne.s   @ChkNext                ; 10/8 yes, so return to caller (RTS)
 
    rts                             ; return to caller