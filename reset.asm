;------------------------------------------------------------------------------
; RESET CODE
;------------------------------------------------------------------------------

RESET:
	sei
	ldx #$FF
	txs
	lda #$00
	sta PPU0
	sta PPU1
	
	sta vblankLastFlag
	sta vblankFlag
	
	lda #$01
	sta doNotInterrupt
	
	jsr vblankwait
	jsr vblankwait

	jsr blankPalette
		
	jsr resetMMC1		
	lda #$00
	jsr setPRGBank
	
	jsr vblankwait
	jsr vblankwait
	
	lda #%00001100		;Set bank layout, H&V mirror, 16kb ROM at $C000. 8KB CHR
	jsr setMMC1r0
	
	jsr clearRam
	.IF EXT_SYNC=1
	lda #$00
	sta old4017
	sta newStepNeeded
	.ENDIF
	
	lda #BANK_SCREEN
	jsr setPRGBank
	jsr clearGraphics
	
	lda #WRAM_BANK_00
	jsr setMMC1r1
	lda #$01
	sta $7FFF	
	lda #WRAM_BANK_01
	jsr setMMC1r1
	lda #$02
	sta $7FFF	
	lda #WRAM_BANK_02
	jsr setMMC1r1
	lda #$04
	sta $7FFF	
	lda #WRAM_BANK_03
	jsr setMMC1r1
	lda #$08
	sta $7FFF
		
	lda #WRAM_BANK_00
	jsr setMMC1r1
	lda $7FFF
	cmp #$01
	bne @lockUp	
	lda #WRAM_BANK_01
	jsr setMMC1r1
	lda $7FFF
	cmp #$02
	bne @lockUp
	lda #WRAM_BANK_02
	jsr setMMC1r1
	lda $7FFF
	cmp #$04
	bne @lockUp
	lda #WRAM_BANK_03
	jsr setMMC1r1
	lda $7FFF
	cmp #$08
	beq @noLock

@lockUp:	lda #BANK_SCREEN
	jsr setPRGBank
	jsr errorScreen
	lda #%00001000 
	sta PPU0
	lda #%00011110
	sta PPU1
	lda #$00
	sta $2005
	sta $2006
	sta $2006
	jmp *
	
@noLock:	

	lda #BANK_SCREEN
	jsr setPRGBank
	jsr initGraphics
	
	lda #BANK_PLAYER
	jsr setPRGBank
	jsr initSound
	lda #$00
	jsr setPRGBank

	lda #%00001100		;Set bank layout, H&V mirror, 16kb ROM at $C000. 8KB CHR
	jsr setMMC1r0
	
	jsr initProcBuffer
	
	;jsr compress
	;jsr decompress

	;lda #procTrackDrumAll
	;jsr addProcessToBuffer

	jsr vblankwait	;warm up
	jsr vblankwait

	lda #%10001000 
	sta PPU0
	lda #%00011110
	sta PPU1
	
mainLoop:
	lda #$01
	sta doNotInterrupt
	
	lda #BANK_EDITOR
	jsr setPRGBank
	jsr editorInit
	lda #BANK_PLAYER
	jsr setPRGBank
	jsr plyrSetupSong
	lda #$00
	sta doNotInterrupt

	.IF EXT_SYNC=0	
mainLoop2:

	lda vblankLastFlag
:	cmp vblankFlag
	beq :-
	
	lda vblankFlag
	sta vblankLastFlag

	jsr readPad1
	
	jsr refreshAudio
	
	lda #BANK_PLAYER
	jsr setPRGBank
	jsr playNotes
		
	lda #BANK_EDITOR
	jsr setPRGBank
	jsr editorRefresh

	jmp mainLoop2

	.ELSE

mainLoop2:	
	lda vblankLastFlag		;EXT SYNC VERSION
:	cmp vblankFlag
	beq :-
	
	lda vblankFlag
	sta vblankLastFlag

	jsr readPad2
	lda #BANK_PLAYER
	jsr setPRGBank
	jsr syncFunctions
	bcs mainLoop2

	jsr readPad1
	jsr refreshAudio

	lda #BANK_PLAYER
	jsr setPRGBank
	jsr playNotes
	
	lda #BANK_EDITOR
	jsr setPRGBank
	jsr editorRefresh

	jmp mainLoop2
	
	.ENDIF
	
	
vblankwait:
:	bit $2002
	bpl :-
	rts
	
vblankendwait:
:	bit $2002
	bmi :-
	rts
	
NMI:	pha
	txa
	pha
	tya
	pha
	bit $2002

	;inc nmiCounter
	
	lda curPrgBank
	sta oldPrgBank
	lda curWramBank
	sta oldWramBank

	inc vblankFlag

	lda doNotInterrupt
	bne :+ ;@exitNMI
		
	.IF DEBUG=1
	jsr debugNumbers
	.ENDIF
	
	lda #BANK_SCREEN
	jsr setPRGBank
	jsr process_DMA_queue
	jsr shiftProcessBuffer
	jsr spriteWriteFlashColour
	lda #BANK_0
	jsr setPRGBank
	jsr spriteDMA
	
	lda #$00
	sta $2005
	sta $2006
	sta $2006
	
:	;jsr refreshAudio			
	.IF DEBUG_COLOURS=1
	lda #%00111110
	sta PPU1
	.ENDIF
	
	;lda #BANK_PLAYER
	;jsr setPRGBank
	
	;.IF EXT_SYNC=0
	;jsr playNotes
	;.ENDIF
	
	.IF DEBUG_COLOURS=1
	lda #%00011110
	sta PPU1
	.ENDIF

	lda oldPrgBank
	jsr setPRGBank
	lda oldWramBank
	jsr setMMC1r1
	
@exitNMI:	;dec nmiCounter
	pla
	tay
	pla
	tax
	pla
	rti

IRQ:	rti


initProcBuffer:
	ldx #$00
	lda #$FF
:	sta dmaProcessBuffer,x
	inx
	cpx #$20
	bcc :-
	rts

	.IF 0=1
countProcesses:
	ldx #$00
:	lda dmaProcessBuffer,x
	cmp #$FF
	beq :+
	inx
	cpx #$1F
	bcc :-
:	cpx maxDma
	bcc :+
	stx maxDma
:	rts
	.ENDIF
	
addProcessToBuffer:
	sta tmp0
	ldx #$00
:	lda dmaProcessBuffer,x
	cmp tmp0
	beq :++
	cmp #$FF
	beq :+
	inx
	cpx #$1F
	bcc :-
	inc errorCount
	rts

:	lda tmp0
	sta dmaProcessBuffer,x
	inx
	lda #$FF
	sta dmaProcessBuffer,x
:	rts
	
	
shiftProcessBuffer:
	lda dmaProcessBuffer
	cmp #$FF
	bne :+
	rts
	
:	ldx #$01
:	lda dmaProcessBuffer,x
	sta dmaProcessBuffer-1,x
	cmp #$FF
	beq :+
	inx
	bpl :-
:	rts


refreshAudio:

	lda editorDecoding
	beq :+
	rts
:
	lda #BANK_SYNTH
	jsr setPRGBank
	jsr synthRefresh
	lda #BANK_PLAYER
	jsr setPRGBank
	jsr plyrUpdateEchoIndex

	ldx #$05		;only do this delay if no new note needed
	ldy #$00		;in which case, time taken to setup note is enough
:	dey
	bne :-
	dex
	bne :-

	lda #BANK_SYNTH
	jsr setPRGBank
	jsr synthRefresh
	lda #BANK_PLAYER
	jsr setPRGBank
	jsr plyrUpdateEchoIndex
	


	rts


clearRam:
	lda #0
	tax
@a:	sta $000,x
	sta $200,x
	sta $300,x
	sta $400,x
	sta $500,x
	sta $600,x
	inx
	bne @a
	
	; Clear below stack
	tsx
	inx
@b:	dex
	sta $100,x
	bne @b	
	rts
	
	.IF 0=1
clearWRAM:	lda #%00010000		;WRAM bank 0?
	jsr setMMC1r1
	lda #$FF
	jsr @clear
	
	lda #%00010100		;WRAM bank 1?
	jsr setMMC1r1
	lda #$FF
	jsr @clear

	lda #%00011000		;WRAM bank 2?
	jsr setMMC1r1
	lda #$FF
	jsr @clear

	lda #%00011100		;WRAM bank 3?
	jsr setMMC1r1
	lda #$FF

@clear:	ldx #<WRAM
	stx tmp0
	ldx #>WRAM
	stx tmp1
	ldx #$20
	ldy #$00
:
	sta (tmp0),y
	iny
	bne :-
	inc tmp1
	dex
	bne :-
	rts
	.ENDIF
	

blankPalette:
	lda #$3F
	sta DMA_ADDR
	lda #$00
	sta DMA_ADDR
	ldx #$0F
	txa
:	sta $2007
	dex
	bpl :-
	rts



spriteDMA:	
	lda #$00
	sta $2003
	lda #>sprBuf
	sta $4014
	rts

spriteWriteFlashColour:
	;Flash palette
	lda #>$3F13
	sta $2006
	lda #<$3F13
	sta $2006
	lda cursorFlashColour
	sta $2007
	;lda #$00
	;sta $2006
	;sta $2006
	rts
	



	.include "debug.asm"
	.include "joypad.asm"


SET_BITS:	.BYTE %00000001,%00000010,%00000100,%00001000,%00010000

CLR_BITS:	.BYTE %11111110,%11111101,%11111011,%11110111,%11101111	

	.include "patternTable.asm"

;------------------------------------------------------------------------------
; MMC1 Resgister Handling
;------------------------------------------------------------------------------

resetMMC1:
	ldx #$80
	stx $8000
	rts

setPRGBank:
	sta curPrgBank
	sta $E000
	lsr a
	sta $E000
	lsr a
	sta $E000
	lsr a
	sta $E000
	lsr a
	sta $E000
	rts
	
setMMC1r0:
	sta $9fff
	lsr a
	sta $9fff
	lsr a
	sta $9fff
	lsr a
	sta $9fff
	lsr a
	sta $9fff
	rts

setMMC1r1:
	sta curWramBank
	sta $Bfff
	lsr a
	sta $Bfff
	lsr a
	sta $Bfff
	lsr a
	sta $Bfff
	lsr a
	sta $Bfff
	rts

setMMC1r2:
	sta $Dfff
	lsr a
	sta $Dfff
	lsr a
	sta $Dfff
	lsr a
	sta $Dfff
	lsr a
	sta $Dfff
	rts
		