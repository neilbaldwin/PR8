initSound:	jsr init_APU
	jsr plyrClearEchoBuffers
	
	lda #$00
	sta noteCounter
	lda #$FF
	sta plyrSongBar
	lda #$FF
	sta patternIndex
	
	lda #$00
	sta plyrEchoCounter
	sta plyrEchoIndex
	lda #$01
	sta plyrEchoSpeed
	sta plyrEchoInitAttnA	
	sta plyrEchoInitAttnB	
	sta plyrEchoInitAttnD
	sta plyrEchoAttn	
	rts
	
init_APU:	lda #$0F
	sta $4015
	
	ldx #$00
@a:	lda @apu_regs,x
	sta APU_00,x
	sta VAPU_00,x
	inx
	cpx #$18
	bne @a
	rts

@apu_regs:
	.BYTE $30,$08,$00,$00
	.BYTE $30,$08,$00,$00
	.BYTE $80,$00,$00,$00
	.BYTE $30,$00,$00,$00
	.BYTE $00,$3F,$00,$00
	.BYTE $00,$0F,$00,$00
	
plyrClearEchoBuffers:
	lda #WRAM_ECHO
	jsr setMMC1r1
	ldx #$00
:	lda #$30
	sta echoBufferA_0,x
	lda #$00
	sta echoBufferA_2,x
	sta echoBufferA_3,x
	lda #$30
	sta echoBufferB_0,x
	lda #$00
	sta echoBufferB_2,x
	sta echoBufferB_3,x
	lda #$30
	sta echoBufferD_0,x
	lda #$00
	sta echoBufferD_2,x
	inx
	cpx #SIZE_OF_ECHO_BUFFER
	bcc :-
	rts
	
	.IF EXT_SYNC=1
	
;------------------------------------------------------------------------------
; SYNC Functions
;------------------------------------------------------------------------------
syncFunctions:
	clc
	lda PAD2_dsta
	beq @notStart
	jmp syncNextStep

@notStart:
	lda PAD2_dsel
	beq @notSelect
	jmp syncRestartPattern

@notSelect:
	lda PAD2_dlr
	beq @notLeftRight
	bmi @right
	jmp syncNextPattern
	
@right:	jmp syncPreviousPattern
	

@notLeftRight:
	lda PAD2_dud
	beq @notUpDown
	bpl @down
	jmp syncSetNextPattern
@down:	jmp syncSetPreviousPattern

@notUpDown:

	rts

syncNextStep:
	lda #$00
	sta noteCounter
	jsr playNotes
	sec
	rts
	
syncRestartPattern:
	ldx #$00
	stx noteCounter
	dex
	stx patternIndex
	jsr playNotes
	sec	
	rts
	
syncNextPattern:
	ldx #$00
	stx noteCounter
	dex
	stx patternIndex
	lda plyrCurrentPattern
	clc
	adc #$01
	sta plyrNextPattern
	sta plyrCurrentPattern
	sta editorCurrentPattern
	jsr playNotes
	sec
	rts
	
syncPreviousPattern:
	ldx #$00
	stx noteCounter
	dex
	stx patternIndex
	lda plyrCurrentPattern
	beq :+
	sec
	sbc #$01
	sta plyrNextPattern
	sta plyrCurrentPattern
	sta editorCurrentPattern
:	jsr playNotes
	sec
	rts
	
syncSetNextPattern:
	lda plyrCurrentPattern
	clc
	adc #$01
	sta plyrNextPattern
	clc
	rts

syncSetPreviousPattern:
	lda plyrCurrentPattern
	beq :+
	sec
	sbc #$01
	sta plyrNextPattern
:	clc
	rts
	



	.ENDIF
;------------------------------------------------------------------------------
; Setup Song
;------------------------------------------------------------------------------
plyrSetupSong:	

	rts

;------------------------------------------------------------------------------
; Setup Pattern
;------------------------------------------------------------------------------
plyrSetupPattern:
	tax
	lda #WRAM_PATTERNS
	jsr setMMC1r1
	lda patternTableLo,x
	sta plyrTmp0
	lda patternTableHi,x
	sta plyrTmp1
	
	ldy #$00
:	lda (plyrTmp0),y
	sta plyrTrackDrum,y
	iny
	cpy #bytesPerPattern
	bcc :-
	
	lda editSongMode
	cmp #SONG_MODE_OFF
	beq :++
	ldx plyrCurrentSong
	lda songSpeedTable,x
	cmp #$FF
	beq :+
	sta plyrTrackDrum+PATTERN_SPEED
:	lda songSwingTable,x
	cmp #$FF
	beq :+
	sta plyrTrackDrum+PATTERN_SWING
	
:	ldx plyrCurrentPattern
	lda #WRAM_PATTERNS
	jsr setMMC1r1
	lda songEchoLevelA,x
	sta plyrEchoInitAttnA
	lda songEchoLevelB,x
	sta plyrEchoInitAttnB
	lda songEchoLevelD,x
	sta plyrEchoInitAttnD
	lda songEchoDecay,x
	sta plyrEchoAttn
	lda songEchoSelect,x
	sta plyrEchoSelect
	
	and #%00001000
	bne :+
	lda songEchoSpeed,x
	sta plyrEchoSpeed
	sta plyrEchoCounter
	lda #$00
	sta plyrEchoIndex
	rts
	
:	lda songEchoSpeed,x
	sta plyrEchoNoteCount
	lda plyrTrackDrum+PATTERN_SPEED
	tay
	lda echoTable,y
	sta plyrEchoSpeed
	sta plyrEchoCounter
	lda #$00
	sta plyrEchoIndex
	rts


plyrUpdateEchoIndex:
	inc plyrEchoIndex
	lda plyrEchoIndex
	cmp #SIZE_OF_ECHO_BUFFER		;ECHO_MAX_DELAY
	bcc :+
	lda #$00
	sta plyrEchoIndex
	rts
	
:	dec plyrEchoCounter
	bmi :+
	rts
	
:	lda plyrEchoSpeed
	sta plyrEchoCounter
	lda plyrEchoSelect
	and #%00001000
	beq :++
	dec plyrEchoNoteCount
	beq :+
	bmi :+
	rts

:	ldx plyrCurrentPattern
	lda #WRAM_PATTERNS
	jsr setMMC1r1
	lda songEchoSpeed,x
	sta plyrEchoNoteCount
:	lda #$00
	sta plyrEchoIndex
	rts
		
;------------------------------------------------------------------------------
; New Note
;------------------------------------------------------------------------------

playNotes:
	;jsr plyrUpdateEchoIndex
	lda plyrMode
	cmp plyrModeOld
	beq :+++

	sta plyrModeOld
	and #$FF
	bne :+
	; stop
	jsr killNote0
	jsr killNote1
	jsr killNote2
	jsr killNote3
	jsr killNote4
	jsr killNote5
	rts

	;continue playing
:	cmp #PLAY_MODE_SONG_LOOP
	bne :+
	lda editSongMode
	cmp #SONG_MODE_OFF
	beq :+
	
	lda #$00
	sta noteCounter
	lda #$FF
	sta patternIndex	

	lda #WRAM_SONGS
	jsr setMMC1r1
	
	ldx plyrCurrentSong
	lda songLoopStartTable,x
	tax
	dex
	stx plyrSongBar
	
	lda #$01
	sta plyrMode
	sta plyrModeOld
	jmp :+++	
	
:	cmp #PLAY_MODE_START
	bne :++
	lda #$00
	sta noteCounter
	lda #$FF
	sta patternIndex	
	sta plyrSongBar
	lda #$01
	sta plyrMode
	sta plyrModeOld
	jmp :++
		
:	and #$FF
	bne :+
	rts
		
:	lda curWramBank
	pha	
	lda noteCounter
	beq @newStep
	.IF EXT_SYNC=0
	dec noteCounter
	.ENDIF
	checkRetrigger 0
	checkRetrigger 1
	checkRetrigger 2
	checkRetrigger 3
	checkRetrigger 4
	checkRetrigger 5
	jmp @newStep2

@newStep:
	jsr playNotesNewStep
@newStep2:

	pla
	jsr setMMC1r1
	rts
	
playNotesNewStep:
	
	inc patternIndex

	lda patternIndex
	ldy #PATTERN_STEPS
	cmp plyrTrackDrum,y
	bcc :+
	lda #$00
	sta patternIndex
:

	lda patternIndex
	bne :++

	lda editSongMode
	cmp #SONG_MODE_OFF
	beq :+
	
	jsr playSong
	
:	lda plyrNextPattern
	sta plyrCurrentPattern
	jsr plyrSetupPattern
	lda #$00
	sta editorForceTrackLoad
		
:	lda editorForceTrackLoad
	bne :--

	lda patternIndex
	and #$01
	sta plyrTmp0
	lda plyrPatternGroove
	asl a
	sta plyrTmp1
	lda plyrPatternSpeed
	asl a
	asl a
	asl a
	ora plyrTmp0
	clc
	adc plyrTmp1
	tax
	.IF EXT_SYNC=0
	lda speedTable,x
	sta noteCounter
	.ELSE
	lda #$01
	sta noteCounter
	.ENDIF
	
	newStep 0
	newStep 1
	newStep 2
	newStep 3
	newStep 4
	newStep 5
	
	rts
	


playSong:	lda #WRAM_SONGS
	jsr setMMC1r1
	
	ldx plyrCurrentSong
	
	inc plyrSongBar

	lda songLoopLengthTable,x
	beq :+
	clc
	adc songLoopStartTable,x
	sta plyrTmp0
	lda plyrSongBar
	cmp plyrTmp0
	bcc :+
	lda songLoopStartTable,x
	sta plyrSongBar

:	lda songTableLo,x
	sta plyrTmp0
	lda songTableHi,x
	sta plyrTmp1
	ldy plyrSongBar
	lda (plyrTmp0),y
	sta plyrNextPattern
	rts

	

patternIndexX5:	.REPEAT 16,i
	.BYTE i*5
	.ENDREPEAT
	
speedTable:
	.IF 0=1
	.BYTE $00,$00,$00,$00,$00,$00,$00,$00	;0
	.BYTE $01,$00,$01,$00,$01,$00,$01,$00	;1
	.BYTE $01,$01,$02,$00,$02,$00,$02,$00	;2
	.BYTE $02,$01,$03,$00,$03,$00,$03,$00	;3
	.BYTE $02,$02,$03,$01,$04,$00,$04,$00	;4
	.BYTE $03,$02,$04,$01,$05,$00,$05,$00	;5
	.BYTE $03,$03,$04,$02,$05,$01,$06,$00	;6
	.BYTE $04,$03,$05,$02,$06,$01,$06,$01	;7
	.BYTE $04,$04,$05,$03,$06,$02,$07,$01	;8
	.BYTE $05,$04,$06,$03,$07,$02,$08,$01	;9
	.BYTE $05,$05,$06,$04,$07,$03,$08,$02	;10
	.BYTE $06,$05,$07,$04,$08,$03,$09,$02	;11
	.BYTE $06,$06,$07,$05,$08,$04,$09,$03	;12
	.BYTE $07,$06,$08,$05,$09,$04,$0A,$03	;13
	.BYTE $07,$07,$08,$06,$09,$05,$0B,$03	;14
	.BYTE $08,$07,$09,$06,$0A,$05,$0C,$03	;15
	.BYTE $08,$08,$0A,$06,$0B,$05,$0C,$04	;16
	.BYTE $09,$08,$0A,$07,$0C,$05,$0D,$04	;17
	.BYTE $09,$09,$0A,$08,$0D,$05,$0E,$04	;18
	.BYTE $0A,$09,$0B,$08,$0D,$06,$0E,$05	;19
	.BYTE $0A,$0A,$0C,$08,$0D,$07,$0E,$06	;20
	.ENDIF
	

	.BYTE $00,$00,$00,$00,$00,$00,$00,$00
	.BYTE $00,$01,$00,$01,$00,$01,$00,$01
	.BYTE $01,$01,$01,$01,$01,$01,$01,$01
	.BYTE $01,$02,$01,$02,$01,$02,$01,$02
	.BYTE $02,$02,$02,$02,$03,$01,$03,$01
	.BYTE $02,$03,$02,$03,$03,$02,$03,$02
	.BYTE $03,$03,$03,$03,$04,$02,$05,$01
	.BYTE $03,$04,$03,$04,$04,$03,$05,$02
	.BYTE $04,$04,$05,$03,$06,$02,$07,$01
	.BYTE $04,$05,$05,$04,$06,$03,$07,$02
	.BYTE $05,$05,$06,$04,$07,$03,$08,$02
	.BYTE $05,$06,$06,$05,$07,$04,$08,$03
	.BYTE $06,$06,$07,$05,$09,$03,$0A,$02
	.BYTE $06,$07,$07,$06,$09,$04,$0A,$03
	.BYTE $07,$07,$08,$06,$0A,$04,$0C,$02
	.BYTE $07,$08,$08,$07,$0A,$05,$0C,$03
	.BYTE $08,$08,$0A,$06,$0C,$04,$0E,$02
	.BYTE $08,$09,$0A,$07,$0C,$05,$0E,$03
	.BYTE $09,$09,$0B,$07,$0D,$05,$0F,$03
	.BYTE $09,$0A,$0B,$08,$0D,$06,$0F,$04
	.BYTE $0A,$0A,$0C,$08,$0F,$05,$11,$03
	.BYTE $0A,$0B,$0C,$09,$0F,$06,$11,$04
	.BYTE $0B,$0B,$0D,$09,$10,$06,$13,$03
	.BYTE $0B,$0C,$0D,$0A,$10,$07,$13,$04
	.BYTE $0C,$0C,$0F,$09,$12,$06,$15,$03
	.BYTE $0C,$0D,$0F,$0A,$12,$07,$15,$04
	.BYTE $0D,$0D,$10,$0A,$13,$07,$16,$04
	.BYTE $0D,$0E,$10,$0B,$13,$08,$16,$05
	.BYTE $0E,$0E,$11,$0B,$15,$07,$18,$04
	.BYTE $0E,$0F,$11,$0C,$15,$08,$18,$05

	;lda #((tempo+2)*1)-1
	; 11+2 = 13, 13*4 = 52, 39-1 = 55
	; 12+1 = 13 13-1 = 12

echoTable:	
	.BYTE 1	;00
	.BYTE 1	;02
	.BYTE 1	;02
	.BYTE 2	;03
	.BYTE 2	;04
	.BYTE 3	;05
	.BYTE 3	;06
	.BYTE 4	;07
	.BYTE 4	;08
	.BYTE 5	;09
	.BYTE 5	;0A
	.BYTE 6	;0B
	.BYTE 6	;0C
	.BYTE 7	;0D
	.BYTE 7	;0E
	.BYTE 8	;0F
	.BYTE 8	;10
	.BYTE 9	;11
	.BYTE 9	;12
	.BYTE 10	;13
	.BYTE 10	;14
	.BYTE 11	;15
	.BYTE 11	;16
	.BYTE 12	;17
	.BYTE 12	;18
	

playNote0:	playNote 0,drumParameters0
	rts
playNote1:	playNote 1,drumParameters1
	rts
playNote2:	playNote 2,drumParameters2
	rts
playNote3:	playNote 3,drumParameters3
	rts
playNote4:	playNote 4,drumParameters4
	rts
playNote5:	playNote 5,drumParameters5
	rts
	
killNote0:	killNote 0
	rts
killNote1:	killNote 1
	rts
killNote2:	killNote 2
	rts
killNote3:	killNote 3
	rts
killNote4:	killNote 4
	rts
killNote5:	killNote 5
	rts

	
plyrDrumAddressLo:
	.REPEAT numberOfDrums,i
	.LOBYTES drums+(bytesPerDrum * i)
	.ENDREPEAT

plyrDrumAddressHi:
	.REPEAT numberOfDrums,i
	.HIBYTES drums+(bytesPerDrum * i)
	.ENDREPEAT



plyrMultiTriggers:
	.BYTE lfo_A_Delay,lfo_B_Delay,lfo_C_Delay,$FF
	.BYTE lfo_A_Speed,lfo_B_Speed,lfo_C_Speed,$FF
	.BYTE lfo_A_Depth,lfo_B_Depth,lfo_C_Depth,$FF
	
	.BYTE env_A_Volume,env_B_Volume,env_D_Volume,$FF
	.BYTE env_A_Env,env_B_Env,env_D_Env,$FF
	.BYTE env_A_Gate,env_B_Gate,env_D_Gate,$FF
	
drumPatch:
@oscA:	.BYTE $00,$00,$00
@lfoA:	.BYTE $00,$00,$10
@envA:	.BYTE $8F,$08,$10
@dtyA:	.BYTE $80,$00

@oscB:	.BYTE $00,$00,$00
@lfoB:	.BYTE $FF,$01,$37
@envB:	.BYTE $8F,$08,$20
@dtyB:	.BYTE $89,$08

@oscC:	.BYTE $00,$00
@lfoC:	.BYTE $00,$00,$C0
@envC:	.BYTE $00,$20

@envD:	.BYTE $8F,$04,$02
@lfoD:	.BYTE $01,$01,$FE
@oscD:	.BYTE $00

@E:	.BYTE $00,$00,$00,$00,$00

@seq:	.BYTE $00,$00,$00

@gbl:	.BYTE %01111

	.include "commonTables.asm"