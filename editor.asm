
editorInit:
	jsr setupSpriteCursor
	jsr initKeyRepeats
	
	.IF 0=1
	ldx #$00
	lda #$FF
:	sta dmaSafe,x
	inx
	cpx #32
	bcc :-
	.ENDIF
	
	lda #$00
	sta maxDma
	;sta nmiCounter
	
	sta editorDecoding
	sta editorEditingValue
	sta editorEditingBuffer
	
	lda #PLAY_MODE_STOPPED
	sta plyrMode
	sta plyrModeOld
	
	lda #EDIT_MODE_GRID
	sta editorMode
	lda #$00
	sta cursorX_grid
	sta cursorY_grid
	sta cursorY_editMenu	
	
	lda #$00
	sta keyStopB
	sta keyDelayA
	sta keyDelayB
	sta keyDelayUD
	sta keyDelayLR
	
	sta editorWaitForAB
	sta editorWaitForClone
	sta editorPhraseForClone

	lda #$00
	sta triggerCopyBuffer+0
	sta triggerCopyBuffer+1
	sta triggerCopyBuffer+2
	sta triggerCopyBuffer+3
	sta triggerCopyBuffer+4
	
	ldx #$00
	stx editorTriggerIndex+0
	stx editorTriggerIndex+1
	stx editorTriggerIndex+2
	stx editorTriggerIndex+3
	stx editorTriggerIndex+4
	stx editorTriggerIndex+5

	lda #4+(2*12)
	sta editorTrackLastNote+0
	sta editorTrackLastNote+1
	sta editorTrackLastNote+2
	sta editorTrackLastNote+3
	sta editorTrackLastNote+4
	sta editorTrackLastNote+5

	lda #$00
	sta editorTrackLastTrigger+0
	sta editorTrackLastTrigger+1
	sta editorTrackLastTrigger+2
	sta editorTrackLastTrigger+3
	sta editorTrackLastTrigger+4
	sta editorTrackLastTrigger+5
	
	lda #$01
	sta editorChannelStatus+0
	sta editorChannelStatus+1
	sta editorChannelStatus+2
	sta editorChannelStatus+3
	sta editorChannelStatus+4
	sta editorChannelStatus+5
	lda #$FF
	sta editorSoloChannel
		
	lda #$00
	sta editorSubModeIndexes+0
	sta editorSubModeIndexes+1
	sta editorSubModeIndexes+2
	sta editorSubModeIndexes+3
	sta editorSubModeIndexes+4
	sta editorSubModeIndexes+5
	
	sta editorDrumAuxIndex
	sta editorEditDrumName
	sta lastDrumParameterValue
	sta editorTrackWipeSpeed
	sta editorForceTrackLoad
	sta editMenuActive
	sta editCopyBuffer
	sta cursorY_grid
	sta cursorX_track
	sta editPatternInfoSubMode
	sta editorDrumSubMode	
	sta editorLastDrumValue
	sta editorLastPhraseValue
	sta editorLastSongLoop
	
	sta editSongIndex
	sta editorSongLastPattern
	
	lda #STARTING_SONG
	jsr editorSelectSong
	
	lda #SONG_MODE_OFF
	sta editSongMode
	lda #$00
	sta editSongModeRecord
	
	jsr editorInitVoiceSwitchSprites

	jsr editorCheckSignature
	bcc :+
	jsr editorWipeAll
:	
	lda #STARTING_PATTERN
	sta editorCurrentPattern	
	jmp editorInit2
	
editorInit2:
	
	lda editorCurrentPattern
	jsr editorSelectPattern
	
	jsr editorInitCopyInfo
	ldx #$07
	jsr editorSetPlayBackMessage
		
	jsr editorDecodePattern
	jsr editorDecodeTriggerParameters

	ldy cursorY_grid
	lda (editorTmp0),y
	lda editorTrackDrum,y
	sta editorCurrentDrum
	jsr editorDecodeDrum
	
	jsr editorDecodeSong
	lda #procSongAll
	jsr addProcessToBuffer
	
	lda #procGridRowAll
	jsr addProcessToBuffer
	lda #procTrackDrumAll
	jsr addProcessToBuffer	
	jsr editorPrintTriggers
	jsr editorPrintDrum
	lda #procCopyInfoAll
	jsr addProcessToBuffer
	lda #procGridPattern
	jsr addProcessToBuffer	
	rts
	
editorCheckSignature:
	lda #WRAM_BANK_00
	jsr setMMC1r1
	ldx #$00
:	lda PR8_HEADER,x
	cmp @header,x
	bne :+
	inx
	cpx #@headerEnd-@header
	bcc :-
	clc
	rts
	
:	ldx #$00
:	lda @header,x
	sta PR8_HEADER,x
	inx
	cpx #@headerEnd-@header
	bcc :-
	sec
	rts
	

@header:	.BYTE "P","R","8",0
@headerEnd:

editorMainLoop:
	lda vblankFlag
:	cmp vblankFlag
	beq :-

	jsr editorRefresh
	jmp editorMainLoop

editorRefresh:	
	jsr editorGlobalKeys
	jsr editorFlashCursor
	jsr editorUpdateTrackIndexCursor	
	jsr editorTrackWipeSprites
	jsr editorStepIndicator
	jsr editorMeters
	jsr editorShowParameterHint
	jsr editorGhostCursor
	jsr editorShowSongMode
	jsr editorShowTimer
	jsr editorCheckCopyInfoMessage	
		
	ldx editorMode
	lda editModeJumpLo,x
	sta editModeVector
	lda editModeJumpHi,x
	sta editModeVector+1
	jmp (editModeVector)
	
editModeJumpLo:	.LOBYTES editorDisabled
	.LOBYTES editTrack,editGrid,editTriggerParameters
	.LOBYTES editDrum,editDrumAux
	.LOBYTES editorEditGridMenu,editorEditDrumMenu
	.LOBYTES editorEditPatternNumber
	.LOBYTES editorSong,editorEditSongMenu
	.LOBYTES editorEditEchoMenu
	.LOBYTES editorClearMenu
	
editModeJumpHi:	.HIBYTES editorDisabled
	.HIBYTES editTrack,editGrid,editTriggerParameters
	.HIBYTES editDrum,editDrumAux
	.HIBYTES editorEditGridMenu,editorEditDrumMenu
	.HIBYTES editorEditPatternNumber
	.HIBYTES editorSong,editorEditSongMenu
	.HIBYTES editorEditEchoMenu
	.HIBYTES editorClearMenu
	
editorDisabled:
	rts
	
editorTryLoadingPattern:
	lda editSongMode
	cmp #SONG_MODE_OFF
	bne :+
	lda editorCurrentPattern
	sta plyrNextPattern
:	rts
	
editorGlobalKeys:
	jsr checkRepeatKeySelect
	jsr checkRepeatKeyStart

	lda PAD1_firea
	beq :+
	lda keyReleaseStart
	beq :+
	lda #PLAY_MODE_SONG_LOOP
	sta plyrMode
	jsr editorTryLoadingPattern	
	rts

:	lda PAD1_fireb
	beq :++++
	lda keyReleaseSelect
	beq :+
	ldx cursorY_grid
	lda editorChannelStatus,x
	eor #$01
	sta editorChannelStatus,x
	rts
	
:	lda keyReleaseStart
	beq :++
	lda cursorY_grid
	cmp editorSoloChannel
	bne :+
	lda #$FF
	bmi :+
:	sta editorSoloChannel
:	rts	

:	lda PAD1_sel
	beq :++
	lda keyReleaseStart
	beq :+
	lda #PLAY_MODE_START
	sta plyrMode
	jsr editorTryLoadingPattern
:	rts
	
:	lda keyReleaseStart
	beq :+
	lda plyrMode
	eor #$01
	sta plyrMode
	jsr editorTryLoadingPattern
:	rts


	.IF 0=1
	lda keyReleaseStart
	beq :+++
	lda PAD1_firea
	beq :+
	
	;Start song from Loop point
	lda #PLAY_MODE_SONG_LOOP
	sta plyrMode
	jsr editorTryLoadingPattern	
	rts
	
:	lda PAD1_fireb
	bne :++
	lda #PLAY_MODE_START
	ldx PAD1_sel
	bne :+
	lda plyrMode
	eor #$01
:	sta plyrMode
	jsr editorTryLoadingPattern
:


	lda PAD1_fireb
	beq :+++
	lda keyReleaseSelect
	beq :+
	ldx cursorY_grid
	lda editorChannelStatus,x
	eor #$01
	sta editorChannelStatus,x
	rts
	
:	lda keyReleaseStart
	beq :++
	lda cursorY_grid
	cmp editorSoloChannel
	bne :+
	lda #$FF
	bmi :+
:	sta editorSoloChannel

:	rts
	.ENDIF
	
;------------------------------------------------------------------------------
; SPRITE CURSOR ROUTINES
;------------------------------------------------------------------------------
	
setupSpriteCursor:
	ldx #$00
:	lda @cursor,x
	sta SPR00_Y,x
	inx
	cpx #(5 *4)
	bcc :-
	rts
	
@cursor:	;     Y   CH  AT  X
	.BYTE $23,$01,$00,$0C	;0
	.BYTE $23,$02,$00,$14	;1
	.BYTE $2B,$03,$00,$0C	;2
	.BYTE $2B,$04,$00,$14	;3
	
	.BYTE $20,$05,$02,$20	;4
	
editorUpdateCursor:
	ldx editorCursorMode
	bne :+
	lda #240
	sta SPR00_Y
	sta SPR01_Y
	sta SPR02_Y
	sta SPR03_Y
	rts
	
:	lda #$01
	sta SPR00_CHAR
	lda #$02
	sta SPR01_CHAR
	cpx #$05
	bcc :+
	lda #$00
	sta SPR00_CHAR
	sta SPR01_CHAR
:
	lda editorCursorX
	sta SPR00_X
	sta SPR02_X
	clc
	adc @cursorModeXOffsets,x
	sta SPR01_X
	sta SPR03_X
	lda editorCursorY
	sta SPR00_Y
	sta SPR01_Y
	clc
	adc @cursorModeYOffsets,x
	sta SPR02_Y
	sta SPR03_Y
	rts
	
@cursorModeXOffsets:
	.BYTE $00
	.BYTE $0A,$12,$1B,$3A,$0A
@cursorModeYOffsets:
	.BYTE $00
	.BYTE $0A,$09,$09,$09,$0A


editorFlashCursor:
	lda #CURSOR_HOLD_COLOUR
	sta cursorFlashColour
	lda keyRepeatA
	ora keyRepeatB
	beq @b
	rts

;	lda editBufferFlag
;	bne @b
;	lda editNavFlag
;	bne @d
;@c:	rts
	
@b:	ldx cursorFlashIndex
	lda cursorFlashColours,x
	sta cursorFlashColour
	inx
	cpx #cursorFlashColoursEnd-cursorFlashColours
	bcc @a
	ldx #$00
@a:	stx cursorFlashIndex
	rts
		
cursorFlashColours:
	;.RES 5,$30
	.RES 3,$30
	.RES 3,$30+CURSOR_BASE_COLOUR
	.RES 2,$20+CURSOR_BASE_COLOUR
	.RES 1,$10+CURSOR_BASE_COLOUR
	;.RES 1,$00+CURSOR_BASE_COLOUR
	.RES 6,$0F
	;.RES 1,$00+CURSOR_BASE_COLOUR
	.RES 2,$10+CURSOR_BASE_COLOUR
	.RES 4,$20+CURSOR_BASE_COLOUR
	.RES 6,$30+CURSOR_BASE_COLOUR
		
cursorFlashColoursEnd:

editorUpdateTriggerIndexCursor:
	ldx cursorY_grid
	lda editorTriggerIndex,x
	tay
	lda @triggerIndexY,y
	sta SPR04_Y
	lda #TRIGGER_CURSOR_X_BASE
	sta SPR04_X
	rts
@triggerIndexY:
	.REPEAT 5,i
	.BYTE TRIGGER_CURSOR_Y_BASE + (8 * i)
	.ENDREPEAT
	
editorUpdateTrackIndexCursor:
	ldx cursorY_grid
	lda @trackCursorY,x
	sta SPR0F_Y
	lda #9*8
	sta SPR0F_X
	rts
@trackCursorY:
	.BYTE 9*8-2,10*8-2,11*8-2,12*8-2,13*8-2,14*8-2

editorInitVoiceSwitchSprites:
	ldx #$00
:	lda @sprites,x
	sta SPR05_Y,x
	inx
	cpx #(27 * 4)
	bcc :-
	rts
	
@sprites:	.BYTE 19*8,SPR_VOICE_OFF,$01,14*8	;5 drum voice switches
	.BYTE 19*8,SPR_VOICE_OFF,$01,28*8	;6
	.BYTE 24*8,SPR_VOICE_OFF,$01,11*8	;7
	.BYTE 24*8,SPR_VOICE_OFF,$01,15*8	;8
	.BYTE 24*8,SPR_VOICE_OFF,$01,28*8	;9

	.BYTE 17*8,$00,%00100010,4*8		;A hints
	.BYTE 17*8,$00,%00100010,5*8		;B
	.BYTE 17*8,$00,%00100010,5*8		;C
	
	.BYTE 9*8-1,$0A,%00100010,9*8-1		;D track wipe anim
	
	.BYTE 8*8,$0B,%00100000,10*8		;E step indicator
	
	.BYTE 9*8-2,$09,%00000010,9*8		;F track index
	
	.BYTE 9*8-1,$10,%00100011,3*8		;10 mute/solo/activity
	.BYTE 10*8-1,$10,%00100011,3*8		;11
	.BYTE 11*8-1,$10,%00100011,3*8		;12
	.BYTE 12*8-1,$10,%00100011,3*8		;13
	.BYTE 13*8-1,$10,%00100011,3*8		;14
	.BYTE 14*8-1,$10,%00100011,3*8		;15
	
	.BYTE 0,$00,%00000010,0		;16
	.BYTE 0,$00,%00000010,0		;17
	.BYTE 0,$00,%00000010,0		;18
	.BYTE 0,$00,%00000010,0		;19
	
	.BYTE 4*8-1,$20,%00000001,13*8		;1A play mode
	.BYTE 4*8-1,$21,%00000001,14*8		;1B

	.BYTE 4*8-1,$30,%00100000,5*8		;1C ghost cursor
	.BYTE 4*8-1,$30,%00100000,6*8		;1D
	.BYTE 4*8-1,$30,%00100000,8*8		;1E
	.BYTE 4*8-1,$30,%00100000,9*8		;1F
	

editorShowTimer:
	lda editSongMode
	cmp #SONG_MODE_OFF
	bne :+
	lda plyrCurrentPattern
	ldx #$00
	jsr @printHexSpr
	lda patternIndex
	ldx #$08
	jsr @printHexSpr
	rts
	
:	lda plyrSongBar
	ldx #$00
	jsr @printHexSpr
	lda plyrCurrentPattern
	ldx #$08
	jsr @printHexSpr	
	rts

	
@printHexSpr:
	cmp #$FF
	beq :+
	pha
	lsr a
	lsr a
	lsr a
	lsr a
	clc
	adc #$30
	sta SPR1C_CHAR,x
	pla
	and #$0F
	clc
	adc #$30
	sta SPR1D_CHAR,x
	rts

:	lda #$0F
	sta SPR1C_CHAR,x
	sta SPR1D_CHAR,x
	rts
	
editorShowSongMode:
	ldx editSongMode
	lda @chr0,x
	sta SPR1A_CHAR
	lda @chr1,x
	sta SPR1B_CHAR
	lda @attr,x
	sta SPR1A_ATTR
	sta SPR1B_ATTR
	rts
	
@chr0:	.BYTE $20,$22,$24
@chr1:	.BYTE $21,$23,$25
@attr:	.BYTE $01,$03,$00

trackWipeSpeed	= 3
trackWipeX	= 9*8-4
trackWipeY	= 9*8-1

editorTrackWipeSprites:
	lda editorTrackWipeSpeed
	bne :+
	sta SPR0D_CHAR
	rts
:	clc
	adc SPR0D_X
	sta SPR0D_X
	cmp #26*8
	bcs :+
	lda #$0A
	sta SPR0D_CHAR
	ldx cursorY_grid
	lda @wipeY,x
	sta SPR0D_Y
	rts
:	lda #$00
	sta editorTrackWipeSpeed
	lda #trackWipeX
	sta SPR0D_X
	rts
	
@wipeY:	.REPEAT 6,i
	.BYTE trackWipeY+(i *8)
	.ENDREPEAT
	
editorStepIndicator:
	ldx patternIndex
	bpl :+
	ldx #$00
:	lda #8*8
	sta SPR0E_Y
	lda @indicatorY,x
	sta SPR0E_X
	rts
		
@indicatorY:	.REPEAT 16,i
	.BYTE 10*8 + (i * 8)
	.ENDREPEAT

editorMeters:	
	inc editorMuteFlashIndex
	lda editorMuteFlashIndex
	cmp #(@muteSpritesEnd-@muteSprites)
	bcc :+
	lda #$00
	sta editorMuteFlashIndex
	
:	lda editorSoloChannel
	bmi @noSolo
	
	ldx #$00
:	cpx editorSoloChannel
	beq :+++
	lda editorChannelStatus,x
	bne :+
	pha
	beq :++
:	ldy editorMuteFlashIndex
	lda @muteSprites,y
	pha
:	txa
	asl a
	asl a
	tay
	pla
	sta SPR10_CHAR,y
	lda #$00
	beq :++
	
:	lda editorMeterCounters,x
	tay
	lda @meterSprites,y
	pha
	txa
	asl a
	asl a
	tay
	pla
	clc
	adc #$08
	sta SPR10_CHAR,y
:	lda editorMeterCounters,x
	beq :++
	clc
	adc #$01
	cmp #@meterSpritesEnd-@meterSprites
	bcc :+
	lda #$00
:	sta editorMeterCounters,x
:	inx
	cpx #numberOfTracks
	bcc :-------
	rts
	
@noSolo:	ldx #$00
:	lda editorChannelStatus,x
	bne :+
	lda #$00
	bpl :++
:	lda editorMeterCounters,x
	tay
	lda @meterSprites,y
:	pha
	txa
	asl a
	asl a
	tay
	pla
	sta SPR10_CHAR,y
	lda editorMeterCounters,x
	beq :++
	clc
	adc #$01
	cmp #@meterSpritesEnd-@meterSprites
	bcc :+
	lda #$00
:	sta editorMeterCounters,x
:	inx
	cpx #numberOfTracks
	bcc :-----
	rts

@meterSprites:
	.BYTE $17,$10,$11,$12,$13,$14,$15,$16,$17
@meterSpritesEnd:
	.BYTE $00

@muteSprites:
	.BYTE $17,$17,$17,$17,$17
	.REPEAT 32
	.BYTE $00
	.ENDREPEAT
	
@muteSpritesEnd:

HINT_X_BASE	= (4*8)+4
HINT_Y_BASE	= (17*8)-1
HINT_CHR_DARK	= $0C
HINT_CHR_LIGHT	= $0D

editorShowParameterHint:
	lda vblankFlag
	and #%00001000
	sta editorTmp2
	
	lda vblankFlag
	and #%00000011
	bne :+
	
	lda editorMultiHintIndex
	clc
	adc #$01
	and #$03
	sta editorMultiHintIndex
:
	lda #HINT_CHR_DARK
	sta SPR0A_CHAR
	sta SPR0B_CHAR
	sta SPR0C_CHAR
	
	lda #240
	sta SPR0A_Y
	sta SPR0B_Y
	sta SPR0C_Y
	
	lda #WRAM_DRUMS
	jsr setMMC1r1
	ldx editorCurrentDrum
	lda drumAddressLo,x
	sta editorTmp0
	lda drumAddressHi,x
	sta editorTmp1
	
	lda editorMode
	cmp #EDIT_MODE_DRUM_AUX
	bne :+
	lda editorDrumAuxIndex
	beq :+
	sec
	sbc #$01
	bpl :++
	
:	ldx cursorY_grid
	lda editorTriggerIndex,x
	beq :++
	cmp #$02
	bcc :++
	sbc #$02
:	asl a
	asl a
	tax
	lda #HINT_CHR_LIGHT
	sta SPR0A_CHAR,x	

:	ldy #mod_Parameter0
	lda (editorTmp0),y
	bmi :+
	jsr @checkMulti
	tax
	lda #HINT_X_BASE
	clc
	adc auxHintXOffsets,x
	sta SPR0A_X
	lda #HINT_Y_BASE
	clc
	adc auxHintYOffsets,x
	sta SPR0A_Y
	
:	ldy #mod_Parameter1
	lda (editorTmp0),y
	bmi :+
	jsr @checkMulti
	tax
	lda #HINT_X_BASE
	clc
	adc auxHintXOffsets,x
	sta SPR0B_X
	lda #HINT_Y_BASE
	clc
	adc auxHintYOffsets,x
	sta SPR0B_Y
	
:	ldy #mod_Parameter2
	lda (editorTmp0),y
	bmi :+
	jsr @checkMulti
	tax
	lda #HINT_X_BASE
	clc
	adc auxHintXOffsets,x
	sta SPR0C_X
	lda #HINT_Y_BASE
	clc
	adc auxHintYOffsets,x
	sta SPR0C_Y

:	rts	

;MLD = $29	$03,$0E,$18,$0E
;MLS = $2A	$04,$0F,$19,$0F
;MLW = $2B	$05,$10,$1A,$10
;
;MAV = $2C	$06,$11,$21,$11
;MAE = $2D	$07,$12,$22,$12
;MAT = $2D	$08,$13,$1C,$23
;
@checkMulti:	cmp #$29
	bcc :+
	sec
	sbc #$29
	asl a
	asl a
	clc
	adc editorMultiHintIndex
	tax
	lda @multiIndexes,x
	rts

:	ldy editorTmp2
	bne :+
	lda #$29
:	rts

@multiIndexes:	.BYTE $03,$0E,$18,$2a
	.BYTE $04,$0F,$19,$2a
	.BYTE $05,$10,$1A,$2a
	
	.BYTE $06,$11,$21,$2a
	.BYTE $07,$12,$22,$2a
	.BYTE $08,$13,$1C,$23
	
auxHintXOffsets:
	.BYTE $00,$00,$00, $18,$18,$18, $30,$30,$30, $48,$48
	.BYTE $70,$70,$70, $88,$88,$88, $A0,$A0,$A0, $B8,$B8
	.BYTE $00,$00, $18,$18,$18, $30,$30
	.BYTE $50, $68,$68,$68, $80,$80,$80
	.BYTE $A0,$A0,$A0, $B8,$B8
	
	.BYTE $00,$00,$00,$00,$00,$00

auxHintYOffsets:
	.BYTE $00,$08,$10, $00,$08,$10, $00,$08,$10, $00,$08
	.BYTE $00,$08,$10, $00,$08,$10, $00,$08,$10, $00,$08
	.BYTE $28,$30, $28,$30,$38, $28,$30
	.BYTE $28, $28,$30,$38, $28,$30,$38
	.BYTE $28,$30,$38, $28,$30
	
	.BYTE 240-(17*8)
	.BYTE 240-(17*8)
	.BYTE 240-(17*8)
	.BYTE 240-(17*8)
	.BYTE 240-(17*8)
	.BYTE 240-(17*8)
	.BYTE 240-(17*8)


editorGhostCursor:	
	ldx #$00
	lda editorMode
	cmp #EDIT_MODE_TRIGGER_PARAMETER
	beq :+
	stx SPR16_CHAR
	stx SPR17_CHAR
	stx SPR18_CHAR
	stx SPR19_CHAR
	rts
:	inx
	stx SPR16_CHAR
	inx
	stx SPR17_CHAR
	inx
	stx SPR18_CHAR
	inx
	stx SPR19_CHAR
	rts
	
;------------------------------------------------------------------------------
;
;------------------------------------------------------------------------------
editorInitCopyInfo:
	ldx #$00
	stx editorCopyInfoTimer
	jsr editorSetPlayBackMessage
	rts

editorCheckCopyInfoMessage:
	lda editorCopyInfoTimer
	beq :+
	cmp #$FF
	beq :++
	dec editorCopyInfoTimer
	bne :+
	
	ldx editSongMode
	lda @infoModes,x
	tax
	jsr editorSetPlayBackMessage
	lda #procCopyInfoAll
	jsr addProcessToBuffer
	rts
	
:	lda editSongMode
	beq :+

:	rts

@infoModes:	.BYTE MSG_PTRN,MSG_SONG,MSG_SONG

@printHex:	pha
	lsr a
	lsr a
	lsr a
	lsr a
	clc
	adc #$30
	sta scnCopyInfoBuffer,y
	iny
	pla
	and #$0F
	clc
	adc #$30
	sta scnCopyInfoBuffer,y
	iny
	rts
	
editorSetPlayBackMessage:
	lda infoTextIndexes,x
	tax
	ldy #$00
:	lda infoMessages,x
	sta scnCopyInfoBuffer,y
	inx
	iny
	cpy #12
	bcc :-
	rts

editorSetErrorMessage:
	pha
	lda infoTextIndexes,x
	tax
	ldy #$00
:	lda infoMessages,x
	sta scnCopyInfoBuffer,y
	inx
	iny
	cpy #12
	bcc :-
	pla
	sta editorCopyInfoTimer
	lda #procCopyInfoAll
	jsr addProcessToBuffer
	rts
		
editorSetCopyInfoMessage:
	pha
	lda infoTextIndexes,x
	tax
	ldy #$00
:	lda infoMessages,x
	sta scnCopyInfoBuffer,y
	inx
	iny
	cpy #12
	bcc :-
	pla
	ldy #$04
	jsr @printHex	
	lda #$60
	sta editorCopyInfoTimer
	lda #procCopyInfoAll
	jsr addProcessToBuffer
	rts

@printHex:	pha
	lsr a
	lsr a
	lsr a
	lsr a
	clc
	adc #$30
	sta scnCopyInfoBuffer,y
	iny
	pla
	and #$0F
	clc
	adc #$30
	sta scnCopyInfoBuffer,y
	iny
	rts	
	
editorSetConfirmMessage:
	lda infoTextIndexes,x
	tax
	ldy #$00
:	lda infoMessages,x
	sta scnCopyInfoBuffer,y
	inx
	iny
	cpy #12
	bcc :-
	lda #$FF
	sta editorCopyInfoTimer
	lda #procCopyInfoAll
	jsr addProcessToBuffer
	rts

editorSelectSong:
	sta editorCurrentSong
	sta plyrCurrentSong
	tax
	lda #WRAM_SONGS
	jsr setMMC1r1
	
	lda songSpeedTable,x
	sta editorSongSpeedTemp
	lda songSwingTable,x
	sta editorSongSwingTemp
	lda songLoopStartTable,x
	sta editorSongLoopStartTemp
	lda songLoopLengthTable,x
	sta editorSongLoopLengthTemp
	rts
	
	
	
editorSelectPattern:
	sta editorCurrentPattern
	tax
	lda #WRAM_PATTERNS
	jsr setMMC1r1
	lda patternTableLo,x
	sta editorTmp0
	lda patternTableHi,x
	sta editorTmp1
	
	ldy #$00
	lda (editorTmp0),y
	sta editorTrackDrum+0
	iny
	lda (editorTmp0),y
	sta editorTrackDrum+1
	iny
	lda (editorTmp0),y
	sta editorTrackDrum+2
	iny
	lda (editorTmp0),y
	sta editorTrackDrum+3
	iny
	lda (editorTmp0),y
	sta editorTrackDrum+4
	iny
	lda (editorTmp0),y
	sta editorTrackDrum+5
	iny
	
	lda (editorTmp0),y
	sta editorTrackPhrase+0
	iny
	lda (editorTmp0),y
	sta editorTrackPhrase+1
	iny
	lda (editorTmp0),y
	sta editorTrackPhrase+2
	iny
	lda (editorTmp0),y
	sta editorTrackPhrase+3
	iny
	lda (editorTmp0),y
	sta editorTrackPhrase+4
	iny
	lda (editorTmp0),y
	sta editorTrackPhrase+5
	iny
	
	lda (editorTmp0),y
	sta editorPatternSpeed
	iny
	lda (editorTmp0),y
	sta editorPatternGroove
	iny
	lda (editorTmp0),y
	sta editorPatternSteps
	
	rts

	
;------------------------------------------------------------------------------
; UTILITY ROUTINES
;------------------------------------------------------------------------------
editorDecodePattern:
	lda #$00		;track counter
	sta editorTmp2

:	lda editorTmp2
	jsr editorDecodePhrase
	lda editorTmp2
	jsr editorDecodeTrackDrum
	inc editorTmp2
	lda editorTmp2
	cmp #numberOfTracks
	bcc :-
	
	jsr editorDecodePatternInfo
	
	rts
	
	
editorDecodeTrackDrums:
	lda #$00
	sta editorTmp2
:	lda editorTmp2
	jsr editorDecodeTrackDrum
	inc editorTmp2
	lda editorTmp2
	cmp #numberOfTracks
	bcc :-
	rts	

editorDecodePhrase:
	pha
	tax
	lda editorTrackPhrase,x
	tax
	lda phraseBanks,x
	jsr setMMC1r1
	lda phraseTableLo,x
	sta editorTmp0
	lda phraseTableHi,x
	sta editorTmp1
	pla
	tax
	lda @trackBufferIndexes,x
	tax
	ldy #$00
:	lda (editorTmp0),y
	jsr editorDecodeTrigger
	sta scnGridBuffer,x
	inx
	iny
	iny
	iny
	iny
	iny
	cpy #(stepsPerPhrase * bytesPerPhraseStep)
	bcc :-
	rts
	
@trackBufferIndexes:
	.REPEAT numberOfTracks,i
	.BYTE stepsPerPhrase * i
	.ENDREPEAT

editorDecodeTrackDrum:
	tay
	lda @drumTrackBufferIndex,y
	tax
	lda editorTrackDrum,y
	jsr @printHex
	lda editorTrackPhrase,y
	jsr @printHex
	rts
	
@printHex:	pha
	lsr a
	lsr a
	lsr a
	lsr a
	sta scnTrackDrumBuffer,x
	inx
	pla
	and #$0F
	sta scnTrackDrumBuffer,x
	inx
	rts
		
@drumTrackBufferIndex:
	.BYTE 0,4,8,12,16,20
	.BYTE 2,6,10,14,18,22

editorDecodeTrigger:
	bne :++
	txa
	and #%00000100
	beq :+
	lda #CHR_EMPTY_GRID_CELL_1
	rts
:	lda #CHR_EMPTY_GRID_CELL_0
	rts

:	bmi :+
	lda #CHR_GRID_NOTE
	rts

:	cmp #$FF
	beq :+
	lda #CHR_GRID_TIE
	rts
	
:	lda #CHR_GRID_KILL
	rts
		

editorPrintTrack:
	lda @gridTrackProcs,x
	jmp addProcessToBuffer

@gridTrackProcs:
	.BYTE procGridRow00,procGridRow01,procGridRow02
	.BYTE procGridRow03,procGridRow04,procGridRow05
	
;------------------------------------------------------------------------------
; EDIT TRACK - drum assignments and also order of tracks
;------------------------------------------------------------------------------
editTrack:	
	jsr checkRepeatKeyA
	jsr checkRepeatKeyB
	jsr checkRepeatKeyUD
	jsr checkRepeatKeyLR

	lda #WRAM_PATTERNS
	jsr setMMC1r1
	ldx editorCurrentPattern
	lda patternTableLo,x
	sta editorTmp0
	lda patternTableHi,x
	sta editorTmp1
	
	lda editorWaitForAB
	beq :+
	jmp @keyWaitAB

:	lda editorWaitForClone
	beq :+++++
	lda editorPhraseForClone
	bne :++
	jsr editorFindClonePhrase
	bcc :+
	lda #$00		;print error
	sta editorWaitForClone
	ldx #MSG_CLONE_ERROR
	lda #$60
	jsr editorSetErrorMessage
:	jmp @x

:	lda editorFoundEmpty
	bne :+
	jsr editorFindEmptyPhrase
	bcc :++
	lda #$00
	sta editorWaitForClone	;error
	ldx #MSG_CLONE_ERROR
	lda #$60
	jsr editorSetErrorMessage
	jmp @x
:	jsr editorClonePhrase
	lda #$00
	sta editorWaitForClone
:	jmp @x
	

:
	jsr _holdSelect_tapDown
	bcc :+

	ldx #EDIT_GRID_MENU
	jsr editorShowEditMenu
	lda editorMode
	sta editorModeBeforeMenu
	lda #EDIT_MODE_GRID_MENU
	sta editorMode
	jmp @x	
	
	
:	jsr _holdSelect_tapUp
	bcc :+
	ldx #MSG_PASTE
	jsr editorSetConfirmMessage
	lda #$01
	sta editorWaitForAB
	jmp @x
	
:	lda cursorY_grid
	clc
	adc #PATTERN_DRUM_0
	adc cursorX_track
	tay

	lda #numberOfDrums
	ldx cursorX_track
	beq :+
	lda #numberOfPhrases
:	sta editorTmp2
	

	lda keyReleaseA		;tap A to repeat last value
	beq :++
	lda PAD1_fireb
	bne :++
	lda editorLastDrumValue
	ldx cursorX_track
 	beq :+
	lda editorLastPhraseValue
:	sta (editorTmp0),y
	sta editorTrackDrum,y
	jmp :+++++++++


:	lda keyRepeatB
	beq :++++
	lda PAD1_dud
	beq :++
	bmi :+
	lda editorMode
	sta previousEditorMode
	jsr editAdjustDrumSubMode
	lda #EDIT_MODE_DRUM
	sta editorMode
	jmp @x

:	lda editorMode
	sta previousEditorMode
	lda #EDIT_MODE_PATTERN_NUMBER
	sta editorMode
	jmp @x
	
:	lda PAD1_dlr
	beq :+
	bmi :+
	lda #EDIT_MODE_GRID
	sta editorMode
	jmp @x
	
:	lda keyReleaseA		;hold B, tap A
	beq :+
	lda #$00
	sta editorPhraseForClone
	sta editorPatternToCheck
	sta editorPatternToCheck+1
	sta editorFoundEmpty
	lda #$01
	sta editorWaitForClone
	jsr editClearPhraseUsedTable
	jmp @x
	
:	lda keyReleaseB
	beq :+
	lda cursorY_grid
	clc
	adc cursorX_track
	tay
	lda #$00
	sta (editorTmp0),y
	sta editorTrackDrum,y
	jmp :++++

:	lda keyRepeatA
	bne :+
	jmp :+++++++
:	lda PAD1_sel
	beq :+
	jsr editorReorderTracks
	jmp @x

:	lda PAD1_dud
	ora keyRepeatUD
	ora PAD1_dlr
	ora keyRepeatLR
	beq :+++
	
	swapSign PAD1_dud
	swapSign keyRepeatUD

	lda PAD1_dud
	ora keyRepeatUD
	asl a
	asl a
	asl a
	asl a
	sta editorTmp3
	
	lda PAD1_dlr
	ora keyRepeatLR
	clc
	adc editorTmp3
	clc
	adc (editorTmp0),y
	;bmi :+++
	cmp #$FF
	beq :++++
	cmp editorTmp2
	bcs :++++
	sta (editorTmp0),y
	sta editorTrackDrum,y
:	ldx cursorX_track	;editing drum or phrase number?
	bne :+++
	cmp editorCurrentDrum	;drum, has it changed?
	beq :+
	sta editorCurrentDrum
	sta editorLastDrumValue
	jsr editorDecodeDrum
	jsr editorPrintDrum
:
	lda cursorY_grid
	jsr editorDecodeTrackDrum	
	ldy cursorY_grid
	lda @trackProcs,y
	jsr addProcessToBuffer
:	jmp @x

:	sta editorLastPhraseValue
	lda cursorY_grid	;phrase
	jsr editorDecodePhrase
	lda cursorY_grid
	jsr editorDecodeTrackDrum
	ldy cursorY_grid
	lda @phraseProcs,y
	jsr addProcessToBuffer
	ldy cursorY_grid
	lda @trackProcs,y
	jsr addProcessToBuffer
	jmp @x
	
:	lda PAD1_dud
	ora keyRepeatUD
	beq :++
	clc
	adc cursorY_grid
	bmi :++
	cmp #rowsPerGrid
	bcs :++
	sta cursorY_grid
	
	ldy cursorY_grid
	lda editorTrackDrum,y
	cmp editorCurrentDrum
	beq :+
	sta editorCurrentDrum
	jsr editorDecodeDrum
	jsr editorPrintDrum
	
	jsr editorDecodeTriggerParameters
	jsr editorPrintTriggers
:	jmp @x

:	lda PAD1_dlr
	beq :+
	lda cursorX_track
	eor #$06
	sta cursorX_track
:
	lda cursorY_grid
	clc
	adc #PATTERN_DRUM_0
	adc cursorX_track
	tax	
	lda @cursorX,x
	sta editorCursorX
	lda @cursorY,x
	sta editorCursorY
	

@x:	lda #$02
	sta editorCursorMode
	jsr editorUpdateCursor
	rts ;jmp editorMainLoop


@keyWaitAB:
	lda editorWaitForAB
	beq :++
	lda keyReleaseB
	bne :+
	lda keyReleaseA
	beq :++
	jsr editorPasteGrid
:	lda #$01
	sta editorCopyInfoTimer
	lda #$00
	sta editorWaitForAB
:	rts

	
@cursorY:	.REPEAT rowsPerGrid,i
	.BYTE TRACK_CURSOR_Y_BASE + (i * 8)
	.ENDREPEAT
	.REPEAT rowsPerGrid,i
	.BYTE TRACK_CURSOR_Y_BASE + (i * 8)
	.ENDREPEAT
@cursorX:	.REPEAT rowsPerGrid,i
	.BYTE TRACK_CURSOR_X_BASE + (1 * 8)
	.ENDREPEAT
	.REPEAT rowsPerGrid,i
	.BYTE TRACK_CURSOR_X_BASE + (4 *8)
	.ENDREPEAT

@trackProcs:	.BYTE procTrackDrum00,procTrackDrum01,procTrackDrum02
	.BYTE procTrackDrum03,procTrackDrum04,procTrackDrum05
	
@phraseProcs:	.BYTE procGridRow00,procGridRow01,procGridRow02
	.BYTE procGridRow03,procGridRow04,procGridRow05

editAdjustDrumSubMode:
	ldx editorCurrentDrum
	lda drumAddressLo,x
	sta editorTmp0
	lda drumAddressHi,x
	sta editorTmp1
	lda #WRAM_DRUMS
	jsr setMMC1r1
	
	ldy #gbl_VoiceSelect
	lda (editorTmp0),y
	sta editorTmp2
	
	ldx editorDrumSubMode
	and @bitMasks,x
	bne :+++
	
	ldx #$00
:	lda editorTmp2
	and @bitMasks,x
	beq :+
	stx editorDrumSubMode
	rts
	
:	inx
	cpx #5
	bcc :--
	
:	rts

@bitMasks:	.BYTE %00000001,%00000010,%00000100,%00001000,%00010000

editClearPhraseUsedTable:
	lda #WRAM_PATTERNS
	jsr setMMC1r1
	ldx #$00
	lda #$00
:	sta phrasesUsed,x
	inx
	cpx #numberOfPhrases
	bcc :-
	rts

editClearPatternUsedTable:
	lda #WRAM_PATTERNS
	jsr setMMC1r1
	ldx #$00
	lda #$00
:	sta patternsUsed,x
	inx
	bne :-
	rts

editorFindClonePattern:
	lda #WRAM_PATTERNS
	jsr setMMC1r1
	
	ldx editorSongToCheck
	bpl :+++
	
	ldx #$01		;start at Pattern 1
:	lda patternsUsed,x
	beq :+
	inx
	bne :-
	sec
	rts

:	stx editorPatternForClone
	clc
	rts
	
:	lda songTableLo,x
	sta editorTmp0
	lda songTableHi,x
	sta editorTmp1
	ldy #$00
:	lda (editorTmp0),y
	beq :+
	tax
	lda #$01
	sta patternsUsed,x
:	iny
	bne :--
	
	dec editorSongToCheck
	clc
	rts
	
	
	
editorClonePattern:
	lda #WRAM_PATTERNS
	jsr setMMC1r1
	
	ldx editorCurrentPattern
	lda patternTableLo,x
	sta editorTmp0
	lda patternTableHi,x
	sta editorTmp1
	
	ldx editorPatternForClone
	lda patternTableLo,x
	sta editorTmp2
	lda patternTableHi,x
	sta editorTmp3
	
	ldy #$00
:	lda (editorTmp0),y
	sta (editorTmp2),y
	iny
	cpy #bytesPerPattern
	bcc :-
	
	ldx editorCurrentPattern
	ldy editorPatternForClone
	
	lda songEchoSelect,x
	sta songEchoSelect,y
	lda songEchoLevelA,x
	sta songEchoLevelA,y
	lda songEchoLevelB,x
	sta songEchoLevelB,y
	lda songEchoLevelD,x
	sta songEchoLevelD,y
	lda songEchoDecay,x
	sta songEchoDecay,y
	lda songEchoSpeed,x
	sta songEchoSpeed,y
	
	lda editorPatternForClone
	sta editorCurrentPattern
	
		
	rts
	
	
editorFindClonePhrase:
	lda editorPatternToCheck+1
	beq :+++
		
	lda #WRAM_PATTERNS
	jsr setMMC1r1
	ldx #$01
:	lda phrasesUsed,x
	beq :+
	inx
	cpx #numberOfPhrases
	bcc :-
	sec
	rts
	
:	stx editorPhraseForClone
	clc
	rts

:	lda #$08
	sta editorTmp4
:	ldx editorPatternToCheck
	lda patternTableLo,x
	sta editorTmp0
	lda patternTableHi,x
	sta editorTmp1
	
	ldy #PATTERN_PHRASE_0
	lda (editorTmp0),y
	beq :+
	tax
	lda #$12
	sta phrasesUsed,x
:	iny
	lda (editorTmp0),y
	beq :+
	tax
	lda #$11
	sta phrasesUsed,x
:	iny
	lda (editorTmp0),y
	beq :+
	tax
	lda #$11
	sta phrasesUsed,x
:	iny
	lda (editorTmp0),y
	beq :+
	tax
	lda #$11
	sta phrasesUsed,x
:	iny
	lda (editorTmp0),y
	beq :+
	tax
	lda #$11
	sta phrasesUsed,x
:	iny
	lda (editorTmp0),y
	beq :+
	tax
	lda #$11
	sta phrasesUsed,x
:	
	
	inc editorPatternToCheck
	bne :+
	inc editorPatternToCheck+1
:	dec editorTmp4
	bne :--------
		
	clc
	rts

editorFindEmptyPattern:
	lda #WRAM_PATTERNS
	jsr setMMC1r1
	
	lda #$08
	sta editorTmp2
	
:	ldx editorPatternForClone
	lda patternTableLo,x
	sta editorTmp0
	lda patternTableHi,x
	sta editorTmp1
		
	ldy #PATTERN_PHRASE_0
	lda (editorTmp0),y
	iny
	ora (editorTmp0),y
	iny
	ora (editorTmp0),y
	iny
	ora (editorTmp0),y
	iny
	ora (editorTmp0),y
	iny
	ora (editorTmp0),y
	beq :+

	inc editorPatternForClone
	beq :++
	dec editorTmp2
	bne :-
	clc
	rts
	
:	lda #$01
	sta editorFoundEmpty
	clc
	rts
	
:	sec
	rts
	
editorFindEmptyPhrase:
	lda editorPhraseForClone
	cmp #numberOfPhrases
	bcc :+
	sec
	rts
:	lda #$08
	sta editorTmp2
:	ldx editorPhraseForClone
	lda phraseTableLo,x
	sta editorTmp0
	lda phraseTableHi,x
	sta editorTmp1
	lda phraseBanks,x
	jsr setMMC1r1
	ldy #$00
:	lda (editorTmp0),y
	bne :+
	iny
	iny
	iny
	iny
	iny
	cpy #stepsPerPhrase * bytesPerPhraseStep
	bcc :-
	lda #$01
	sta editorFoundEmpty
	clc
	rts
	
:	inc editorPhraseForClone
	lda editorPhraseForClone
	cmp #numberOfPhrases
	bcc :+
	sec
	rts
:	dec editorTmp2
	bne :----
	clc
	rts
	
	
editorCheckUpdatePhrases:
	ldx cursorY_grid
	lda editorTrackPhrase,x
	sta editorTmp2
	lda #$00
	sta editorTmp3
:	ldx editorTmp3
	lda editorTrackPhrase,x
	cmp editorTmp2
	bne :+
	txa
	jsr editorDecodePhrase
	ldx editorTmp3
	lda @phraseProcs,x
	jsr addProcessToBuffer
:	inc editorTmp3
	lda editorTmp3
	cmp #numberOfTracks
	bcc :--
	rts

@phraseProcs:	.BYTE procGridRow00,procGridRow01,procGridRow02
	.BYTE procGridRow03,procGridRow04,procGridRow05

;------------------------------------------------------------------------------
; EDIT GRID - set triggers etc.
;------------------------------------------------------------------------------
editGrid:
	lda #$01
	sta editorCursorMode
	
	ldx cursorY_grid
	lda editorTrackPhrase,x
	tax
	lda phraseBanks,x
	jsr setMMC1r1
	lda phraseTableLo,x
	sta editorTmp0
	lda phraseTableHi,x
	sta editorTmp1
	
	jsr checkRepeatKeyA
	jsr checkRepeatKeyB
	jsr checkRepeatKeyUD
	jsr checkRepeatKeyLR
	
	lda editorWaitForAB
	beq :+
	jmp @keyWaitAB
	
:	lda keyRepeatSelect
	beq :+++++++++
	
	lda keyRepeatA
	beq :++++
	
	;HOLDING SELECT+A
	lda PAD1_dud
	beq :+
	jsr editorReorderTracks
	jmp @x
	
:	lda PAD1_dlr
	beq :++
	bmi :+
	jsr editorShiftTrackRight
	jmp @x
:	jsr editorShiftTrackLeft
:	jmp @x	
	
:	lda PAD1_dud
	beq :+++++
	bmi :++
	;edit menu
	lda PAD1_fireb
	beq :+
	jmp @goEchoMenu
	
:	ldx #EDIT_GRID_MENU
	jsr editorShowEditMenu
	lda editorMode
	sta editorModeBeforeMenu
	lda #EDIT_MODE_GRID_MENU
	sta editorMode
	jmp @x
	
:	lda editCopyBuffer
	beq :++
	cmp #COPY_ID_PHRASE
	beq :+
	cmp #COPY_ID_PATTERN
	bne :++
:	ldx #MSG_PASTE
	jsr editorSetConfirmMessage
	lda #$01
	sta editorWaitForAB
	jmp @x	

:	ldx #MSG_PASTE_ERROR
	lda #$60
	jsr editorSetErrorMessage
	jmp @x

:	lda keyRepeatA
	bne :++
	lda keyReleaseA
	bne :+
	lda keyReleaseB
	beq :++++
	
:	ldx cursorX_grid		;tap A
	lda editorGridXOffsets,x
	tay
	lda (editorTmp0),y
	jsr editorCycleTrigger
	ldx cursorY_grid
	jsr editorDecodeTriggerParameters
	jsr editorPrintTriggers
	jsr editorCheckUpdatePhrases
	jmp @x
	
:	
	ldx cursorX_grid
	lda editorGridXOffsets,x
	tay
	lda (editorTmp0),y
	beq :+
	tya
	ldx cursorY_grid
	clc
	adc editorTriggerIndex,x
	tay
	
	;ldx cursorX_grid		;
	;lda editorGridXOffsets,x
	;ldx cursorY_grid
	;clc
	;adc editorTriggerIndex,x
	tay
	jsr editorModifyTriggerParameter
	jsr editorDecodeTriggerParameters
	jsr editorPrintTriggers
:	jmp @x

:	lda keyRepeatB
	beq :+++++
	ldx #$00
:	lda SPR00_X,x
	sta SPR16_X,x
	lda SPR00_Y,x
	sta SPR16_Y,x
	inx
	inx
	inx
	inx
	cpx #4*4
	bcc :-
	
	lda PAD1_dlr		;HOLD B, TAP U/D/L/R
	beq :++
	bpl :+
	lda #EDIT_MODE_TRACK
	sta editorMode
	jmp @x
:	lda #EDIT_MODE_TRIGGER_PARAMETER
	sta editorMode
	jmp @x
	
:	lda PAD1_dud
	beq :++
	bmi :+
	lda editorMode
	sta previousEditorMode
	jsr editAdjustDrumSubMode
	lda #EDIT_MODE_DRUM
	sta editorMode
	jmp @x
:	lda editorMode
	sta previousEditorMode
	lda #EDIT_MODE_PATTERN_NUMBER
	sta editorMode
	jmp @x

:	lda PAD1_firea
	ora PAD1_fireb
	bne @noMovement
	jsr editorMoveAroundGrid
	jmp @x
	
@noMovement:	

@x:	ldx cursorX_grid
	lda @cursorX,x
	sta editorCursorX
	ldx cursorY_grid
	lda @cursorY,x
	sta editorCursorY

	jsr editorUpdateTriggerIndexCursor
	jsr editorUpdateCursor
	rts;jmp editorMainLoop

	
@cursorX:	.REPEAT colsPerGrid,i
	.BYTE GRID_CURSOR_X_BASE + (i * 8)
	.ENDREPEAT

@cursorY:	.REPEAT rowsPerGrid,i
	.BYTE GRID_CURSOR_Y_BASE + (i * 8)
	.ENDREPEAT

@keyWaitAB:
	lda editorWaitForAB
	beq :++
	lda keyReleaseB
	bne :+
	lda keyReleaseA
	beq :++
	jsr editorPasteGrid
:	lda #$01
	sta editorCopyInfoTimer
	lda #$00
	sta editorWaitForAB
:	rts


@goEchoMenu:	lda #$00
	sta editMenuActive
	sta cursorY_editMenu
	lda editorMode
	sta editorModeBeforeMenu
	ldx #EDIT_ECHO_MENU
	jsr editorShowEditMenu
	jsr editorDecodeEchoMenu
	lda #procGridRow00
	jsr addProcessToBuffer
	lda #procGridRow01
	jsr addProcessToBuffer
	lda #procGridRow02
	jsr addProcessToBuffer
	lda #procGridRow03
	jsr addProcessToBuffer
	lda #procGridRow04
	jsr addProcessToBuffer
	lda #procGridRow05
	jsr addProcessToBuffer
	lda #EDIT_MODE_ECHO
	sta editorMode
	jmp @x

editorMoveAroundGrid:
	lda PAD1_dud
	ora keyRepeatUD
	beq :++
	clc
	adc cursorY_grid
	bmi :+
	cmp #rowsPerGrid
	bcs :+
	sta cursorY_grid
	
	jsr editorDecodeTriggerParameters
	jsr editorPrintTriggers
	
	ldy cursorY_grid
	lda editorTrackDrum,y
	cmp editorCurrentDrum
	beq :+
	sta editorCurrentDrum
	jsr editorDecodeDrum
	jsr editorPrintDrum
:	rts

:	lda PAD1_dlr
	ora keyRepeatLR
	beq :+++
	clc
	adc cursorX_grid
	bpl :+
	lda #colsPerGrid-1
	bpl :++
:	cmp #colsPerGrid
	bcc :+
	lda #$00
:	sta cursorX_grid
	jsr editorDecodeTriggerParameters
	jsr editorPrintTriggers

:	rts

editorGridXOffsets:
	.REPEAT stepsPerPhrase,i
	.BYTE (bytesPerPhraseStep * i)
	.ENDREPEAT
		
editorCycleTrigger:
	;if 0 then set note from last note for this track
	;if <$7F then ora $80
	;if <$FF then set $FF
	;or set 0
	
	;lda keyRepeatA
	;beq :++++
	lda keyReleaseB
	beq :+
	jmp :+++++++++++++++
	
:	ldx cursorY_grid
	lda (editorTmp0),y
	beq :+
	jmp :+++++++++++
	
:	lda editorTrackLastNote,x
	sta (editorTmp0),y
	iny
	lda #$00
	sta (editorTmp0),y
	iny
	sty editorTmp4
	ldx editorCurrentDrum
	lda drumAddressLo,x
	sta editorTmp2
	lda drumAddressHi,x
	sta editorTmp3
	
	lda #WRAM_DRUMS
	jsr setMMC1r1
	
	ldy #mod_Parameter2	;set values for T1, T2 and T3
	lda (editorTmp2),y
	bpl :+
	lda #$00
	beq :+++
:	cmp #gbl_DrumName
	bcc :+
	sbc #gbl_DrumName
	tax
	lda editorMultiTriggerDefaults,x
	jmp :++
:	tay
	lda (editorTmp2),y
:	pha

	ldy #mod_Parameter1
	lda (editorTmp2),y
	bpl :+
	lda #$00
	beq :+++
:	cmp #gbl_DrumName
	bcc :+
	sbc #gbl_DrumName
	tax
	lda editorMultiTriggerDefaults,x
	jmp :++
:	tay
	lda (editorTmp2),y
:	pha

	ldy #mod_Parameter0
	lda (editorTmp2),y
	bpl :+
	lda #$00
	beq :+++
:	cmp #gbl_DrumName
	bcc :+
	sbc #gbl_DrumName
	tax
	lda editorMultiTriggerDefaults,x
	jmp :++
:	tay
	lda (editorTmp2),y
:	pha
	ldy editorTmp4
	
	ldx cursorY_grid
	lda editorTrackPhrase,x
	tax
	lda phraseBanks,x
	jsr setMMC1r1
	pla
	sta (editorTmp0),y
	pla
	iny
	sta (editorTmp0),y
	pla
	iny
	sta (editorTmp0),y
	rts
	
:	bmi :+
	lda (editorTmp0),y
	sta editorTrackLastNote,x
	ora #$80
	sta (editorTmp0),y
	rts
:	cmp #$FF
	beq :+
	lda #$FF
	sta (editorTmp0),y
	rts
:	lda #$00
	sta (editorTmp0),y
	rts
	
:	lda (editorTmp0),y
	beq :+		;if cell empty, try paste
	sty editorTmp2		;otherwise, copy to buffer and clear
	lda (editorTmp0),y
	sta triggerCopyBuffer+0
	lda #$00
	sta (editorTmp0),y
	iny
	lda (editorTmp0),y
	sta triggerCopyBuffer+1
	lda #$00
	sta (editorTmp0),y
	iny
	lda (editorTmp0),y
	sta triggerCopyBuffer+2
	lda #$00
	sta (editorTmp0),y
	iny
	lda (editorTmp0),y
	sta triggerCopyBuffer+3
	lda #$00
	sta (editorTmp0),y
	iny
	lda (editorTmp0),y
	sta triggerCopyBuffer+4
	lda #$00
	sta (editorTmp0),y
	ldy editorTmp2
	rts

:	lda triggerCopyBuffer+0
	beq :+
	sty editorTmp2
	sta (editorTmp0),y
	iny
	lda triggerCopyBuffer+1
	sta (editorTmp0),y
	iny
	lda triggerCopyBuffer+2
	sta (editorTmp0),y
	iny
	lda triggerCopyBuffer+3
	sta (editorTmp0),y
	iny
	lda triggerCopyBuffer+4
	sta (editorTmp0),y
:	rts

editorMultiTriggerDefaults:
	.BYTE $00	;MLD
	.BYTE $00	;MLS
	.BYTE $00	;MLW
	
	.BYTE $8F	;MAV
	.BYTE $08	;MAE
	.BYTE $10	;MAH
	
	
	
;------------------------------------------------------------------------------
; EDIT TRIGGER PARAMETERS
;------------------------------------------------------------------------------
editTriggerParameters:
	ldx cursorY_grid
	lda editorTrackPhrase,x
	tax
	lda phraseBanks,x
	jsr setMMC1r1
	lda phraseTableLo,x
	sta editorTmp0
	lda phraseTableHi,x
	sta editorTmp1

	jsr checkRepeatKeyA
	jsr checkRepeatKeyB
	jsr checkRepeatKeyUD
	jsr checkRepeatKeyLR
	
	lda editorWaitForAB
	beq :+
	jmp @keyWaitAB
	
:	jsr _holdSelectTapA
	bcc :+
	jsr editorRemapTriggerParameters
	jmp @x

:	jsr _holdSelect_tapDown	;open edit menu?
	bcc :+

	ldx #EDIT_GRID_MENU
	jsr editorShowEditMenu
	lda editorMode
	sta editorModeBeforeMenu
	lda #EDIT_MODE_GRID_MENU
	sta editorMode
	jmp @x	
		
:	jsr _holdSelect_tapUp
	bcc :+
	ldx #MSG_CONFIRM
	jsr editorSetConfirmMessage
	lda #$01
	sta editorWaitForAB
	jmp @x

:	lda keyRepeatA
	beq :+++
	lda PAD1_dud
	ora PAD1_dlr
	ora keyRepeatUD
	ora keyRepeatLR
	beq :++
	ldx cursorX_grid
	lda editorGridXOffsets,x
	tay
	lda (editorTmp0),y
	beq :++
	tya
	ldx cursorY_grid
	clc
	adc editorTriggerIndex,x
	tay
	jsr editorModifyTriggerParameter
:	jsr editorDecodeTriggerParameters
	jsr editorPrintTriggers
:	jmp @x	
	
:	lda keyReleaseB
	beq :+++
	ldx cursorX_grid
	lda editorGridXOffsets,x
	ldx cursorY_grid
	clc
	adc editorTriggerIndex,x
	tay
	lda editorTriggerIndex,x
	beq :++		;can't clear note
	cmp #TRIGGER_INDEX_P1
	bcs :+
	;clear retrigger
	lda #$00
	sta (editorTmp0),y
	jmp :---

:	;clear mod parameter
	sty editorTmp4
	lda #WRAM_DRUMS
	jsr setMMC1r1
	ldx editorCurrentDrum
	lda drumAddressLo,x
	sta editorTmp2
	lda drumAddressHi,x
	sta editorTmp3
	lda editorTriggerIndex,x
	clc
	adc #mod_Parameter0-2
	tay
	lda (editorTmp2),y
	tay
	;dey			;BUG FIX: tapping B on mod paramter would set wrong value
	lda (editorTmp2),y
	pha
	ldx cursorY_grid
	lda editorTrackPhrase,x
	tax
	lda phraseBanks,x
	jsr setMMC1r1
	ldy editorTmp4
	pla
	sta (editorTmp0),y
:	jmp :-----
	
:	lda keyReleaseA
	beq :+++
	ldx cursorY_grid
	lda editorTriggerIndex,x
	bne :+
	lda editorTrackLastNote,x
	pha
	jmp :++
:	lda editorTrackLastTrigger,x
	pha
:	ldx cursorX_grid
	lda editorGridXOffsets,x
	ldx cursorY_grid
	clc
	adc editorTriggerIndex,x
	tay
	pla
	sta (editorTmp0),y
	jmp :--------	

:	lda keyRepeatB
	beq :++++
	lda PAD1_dud
	beq :+++
	bpl :+
	lda editorMode
	sta previousEditorMode
	lda #EDIT_MODE_PATTERN_NUMBER
	sta editorMode
	jmp @x
	
:	lda editorMode
	sta previousEditorMode
	lda editorTriggerIndex
	cmp #$02
	bcc :+
	sbc #$01
	sta editorDrumAuxIndex
	lda #EDIT_MODE_DRUM_AUX
	sta editorMode
	jmp @x
:	jsr editAdjustDrumSubMode
	lda #EDIT_MODE_DRUM
	sta editorMode
	jmp @x
	
:	lda PAD1_dlr
	beq :++++
	bpl :++++
	lda #EDIT_MODE_GRID
	sta editorMode
	jmp @x
	
:	lda PAD1_sel
	beq :+
	jsr editorMoveAroundGrid
	jsr editorUpdateGhostCursor
	jmp @x
	
:	ldx cursorY_grid
	lda PAD1_dud
	clc
	adc editorTriggerIndex,x
	bpl :+
	lda #$00
:	cmp #$05
	bcs :+
	sta editorTriggerIndex,x

:	ldx cursorY_grid
	lda editorTriggerIndex,x
	tax
	lda @cursorTableX,x
	sta editorCursorX
	lda @cursorTableY,x
	sta editorCursorY
	lda @cursorModes,x
	sta editorCursorMode
		
@x:	jsr editorUpdateTriggerIndexCursor
	jsr editorUpdateCursor
	rts ;jmp editorMainLoop

@cursorTableX:	.BYTE TRIGGER_PARAMETER_X_BASE
	.BYTE TRIGGER_PARAMETER_X_BASE+8
	.BYTE TRIGGER_PARAMETER_X_BASE+8
	.BYTE TRIGGER_PARAMETER_X_BASE+8
	.BYTE TRIGGER_PARAMETER_X_BASE+8

@cursorTableY:	.BYTE TRIGGER_PARAMETER_Y_BASE
	.BYTE TRIGGER_PARAMETER_Y_BASE+$08
	.BYTE TRIGGER_PARAMETER_Y_BASE+$10
	.BYTE TRIGGER_PARAMETER_Y_BASE+$18
	.BYTE TRIGGER_PARAMETER_Y_BASE+$20
	
@cursorModes:	.BYTE 3,2,2,2,2

@keyWaitAB:
	lda editorWaitForAB
	beq :++
	lda keyReleaseB
	bne :+
	lda keyReleaseA
	beq :++
	jsr editorPasteGrid
:	lda #$01
	sta editorCopyInfoTimer
	lda #$00
	sta editorWaitForAB

:	rts


editorUpdateGhostCursor:
	ldx cursorX_grid
	lda @cursorX,x
	;sta editorCursorX
	sta SPR16_X
	sta SPR18_X
	clc
	adc #$0A
	sta SPR17_X
	sta SPR19_X
	
	ldx cursorY_grid
	lda @cursorY,x
	;sta editorCursorY
	sta SPR16_Y
	sta SPR17_Y
	clc
	adc #$0A
	sta SPR18_Y
	sta SPR19_Y

	;jsr editorUpdateTriggerIndexCursor
	;jsr editorUpdateCursor
	rts
	
@cursorX:	.REPEAT colsPerGrid,i
	.BYTE GRID_CURSOR_X_BASE + (i * 8)
	.ENDREPEAT

@cursorY:	.REPEAT rowsPerGrid,i
	.BYTE GRID_CURSOR_Y_BASE + (i * 8)
	.ENDREPEAT

editorModifyTriggerParameter:
	;sty editorTmp3
	;ldx cursorX_grid
	;lda editorGridXOffsets,x
	;ldx cursorY_grid
	;clc
	;adc editorTriggerIndex,x
	;tay


	ldx cursorY_grid
	lda editorTriggerIndex,x
	cmp #TRIGGER_INDEX_NOTE
	bne :+++++++

;modify note
	swapSign PAD1_dud
	swapSign keyRepeatUD
	
	lda PAD1_dlr
	ora keyRepeatLR
	sta editorTmp3
	bne :++
	
	ldx #$0C
	lda PAD1_dud
	ora keyRepeatUD
	beq :+++
	bpl :+
	ldx #$F4
:	stx editorTmp3
:	lda keyRepeatB
	bne :++
	jsr @modNote
	ldx cursorY_grid
	and #$7F
	sta editorTrackLastNote,x
:	rts

:	ldy #$00
:	lda (editorTmp0),y
	beq :+
	jsr @modNote
:	iny
	iny
	iny
	iny
	iny
	cpy #stepsPerPhrase * bytesPerPhraseStep
	bcc :--
	rts
	


;modify parameter
:	swapSign PAD1_dud
	swapSign keyRepeatUD
	
	lda PAD1_dud
	ora keyRepeatUD
	asl a
	asl a
	asl a
	asl a
	sta editorTmp2
	lda keyRepeatB
	bne :+
	jsr @modParameter
	rts

:	ldx cursorY_grid
	lda editorTriggerIndex,x
	tay
:	jsr @modParameter
	iny
	iny
	iny
	iny
	iny
	cpy #stepsPerPhrase * bytesPerPhraseStep
	bcc :-
	rts
	
@modNote:	lda (editorTmp0),y
	pha
	and #$80
	sta editorTmp2
	pla
	and #$7F
	clc
	adc editorTmp3
	bmi :+
	beq :+
	cmp #numberOfNotes
	bcs :+
	ldx cursorY_grid
	sta editorTrackLastNote,x
	ora editorTmp2
	sta (editorTmp0),y
:	rts

@modParameter:
	lda PAD1_dlr
	ora keyRepeatLR
	clc
	adc (editorTmp0),y
	clc
	adc editorTmp2
	sta (editorTmp0),y
	sta editorTrackLastTrigger,x
	rts
	
editorDecodeTriggerParameters:
	ldx cursorY_grid
	lda editorTrackPhrase,x
	tax
	lda phraseBanks,x
	jsr setMMC1r1
	lda phraseTableLo,x
	sta editorTmp0
	lda phraseTableHi,x
	sta editorTmp1
	
	ldx cursorX_grid
	lda editorGridXOffsets,x
	tay
	lda (editorTmp0),y	;note?
	beq :+
	cmp #$FF
	beq :+
	
	and #$7F
	tax
	lda noteOctaves,x
	pha
	lda noteAccidentals,x
	pha
	lda noteNames,x
	sta scnTriggerBuffer+0
	pla
	sta scnTriggerBuffer+1
	pla
	sta scnTriggerBuffer+2
	
	ldx #$03
	iny
	lda (editorTmp0),y	;retrigger
	jsr @printHex
	iny
	lda (editorTmp0),y	;p1
	jsr @printHex
	iny
	lda (editorTmp0),y	;p2
	jsr @printHex
	iny
	lda (editorTmp0),y	;p3
	jsr @printHex
	rts
	
:	ldx #$00
	lda #NONE
:	sta scnTriggerBuffer,x
	inx
	cpx #$0B
	bcc :-
	rts

@printHex:	pha
	lsr a
	lsr a
	lsr a
	lsr a
	sta scnTriggerBuffer,x
	inx
	pla
	and #$0F
	sta scnTriggerBuffer,x
	inx
	rts
	


noteNames:	.BYTE $00
	;.BYTE NOTE_A,NOTE_A,NOTE_B
	.BYTE NOTE_A,NOTE_B
	.REPEAT 8
	.BYTE NOTE_C,NOTE_C,NOTE_D,NOTE_D,NOTE_E,NOTE_F,NOTE_F,NOTE_G,NOTE_G,NOTE_A,NOTE_A,NOTE_B
	.ENDREPEAT
	
noteOctaves:	.BYTE $00
	;.BYTE OCT_1,OCT_1,OCT_1
	.BYTE OCT_1,OCT_1
	.REPEAT 12
	.BYTE OCT_2
	.ENDREPEAT
	.REPEAT 12
	.BYTE OCT_3
	.ENDREPEAT
	.REPEAT 12
	.BYTE OCT_4
	.ENDREPEAT
	.REPEAT 12
	.BYTE OCT_5
	.ENDREPEAT
	.REPEAT 12
	.BYTE OCT_6
	.ENDREPEAT
	.REPEAT 12
	.BYTE OCT_7
	.ENDREPEAT
	.REPEAT 12
	.BYTE OCT_8
	.ENDREPEAT
	.REPEAT 12
	.BYTE OCT_9
	.ENDREPEAT
	

noteAccidentals:
	.BYTE $00
	;.BYTE NONE,SHARP,NONE
	.BYTE SHARP,NONE
	.REPEAT 8
	.BYTE NONE,SHARP,NONE,SHARP,NONE,NONE,SHARP,NONE,SHARP,NONE,SHARP,NONE
	.ENDREPEAT

editorPrintTriggers:
	lda #procTrigger
	jsr addProcessToBuffer
	rts
	
;------------------------------------------------------------------------------
; DRUM EDITOR
;------------------------------------------------------------------------------
editDrum:
	lda #WRAM_DRUMS
	jsr setMMC1r1
	
	ldx editorCurrentDrum
	lda drumAddressLo,x
	sta editorTmp0
	lda drumAddressHi,x
	sta editorTmp1
	
	jsr checkRepeatKeyA
	jsr checkRepeatKeyB
	jsr checkRepeatKeyUD
	jsr checkRepeatKeyLR

	lda editorWaitForAB
	beq :+
	jmp @keyWaitAB

:	lda keyRepeatSelect
	beq :+++
	lda PAD1_dud
	beq :+++
	bmi :+
	;edit menu
	ldx #EDIT_DRUM_MENU
	jsr editorShowEditMenu
	lda editorMode
	sta editorModeBeforeMenu
	lda #EDIT_MODE_DRUM_MENU
	sta editorMode
	jmp @x
:	;jsr editorPasteDrum
	lda editCopyBuffer
	cmp #COPY_ID_DRUM
	bne :+
	ldx #MSG_PASTE
	jsr editorSetConfirmMessage
	lda #$01
	sta editorWaitForAB
	jmp @x	

:	ldx #MSG_PASTE_ERROR
	lda #$60
	jsr editorSetErrorMessage
	jmp @x

:	ldx editorDrumSubMode
	lda @parameterMapIndexStart,x
	sta cursorDrumMin
	lda @parameterMapIndexEnd,x
	sta cursorDrumMax
	lda cursorDrumMin
	cmp editorSubModeIndexes,x
	bcc :+
	sta editorSubModeIndexes,x
:	
	lda keyRepeatB
	beq :+++
	lda PAD1_dud
	beq :++
	bpl :+
	;lda #EDIT_MODE_GRID
	lda previousEditorMode
	sta editorMode
	jmp @x
:	lda #EDIT_MODE_DRUM_AUX
	sta editorMode
	jmp @x
	
:	lda PAD1_dlr
	beq :+
	clc
	adc editorDrumSubMode
	bmi :+
	cmp #5
	bcs :+
	sta editorDrumSubMode
	jmp @x
	
:	ldx editorDrumSubMode
	lda editorSubModeIndexes,x
	tax
	lda @parameterMap,x
	tay
	
	lda keyReleaseB
	beq :+
	lda EMPTY_DRUM_DEFINITION,y
	sta (editorTmp0),y
	jmp @y
	
:	lda keyReleaseA
	beq :+
	lda lastDrumParameterValue
	sta (editorTmp0),y
	jmp @y
	
:	lda PAD1_firea
	ora PAD1_fireb
	bne @noMovement
		
	ldx editorDrumSubMode
	lda PAD1_dlr
	ora keyRepeatLR
	sta editorTmp2
	
	beq :+++
	lda editorSubModeIndexes,x
:	clc
	adc editorTmp2
	bmi :++
	cmp cursorDrumMin
	bcc :++
	cmp cursorDrumMax
	bcs :++
	tay
	lda @parameterMap,y
	cmp #$FF
	bne :+
	tya
	jmp :-
:	tya
	sta editorSubModeIndexes,x

:	lda PAD1_dud
	;ora keyRepeatUD
	asl a
	asl a
	sta editorTmp2
	beq :+++
	lda editorSubModeIndexes,x
:	clc
	adc editorTmp2
	bmi :++
	cmp cursorDrumMin
	bcc :++
	cmp cursorDrumMax
	bcs :++
	tay
	lda @parameterMap,y
	cmp #$FF
	bne :+
	tya
	jmp :-
:	tya
	sta editorSubModeIndexes,x
	jmp @x
:	
	
@noMovement:
	ldx editorDrumSubMode
	lda editorSubModeIndexes,x
	tax
	lda @parameterMap,x
	tay
	
	lda keyReleaseSelect
	beq :+
	lda PAD1_fireb
	bne :+
	ldy #gbl_VoiceSelect
	bne :++
		
:	lda keyRepeatA
	beq :++
	
	cpy #gbl_VoiceSelect
	bne :+++
	lda PAD1_dud
	ora PAD1_dlr
	beq :++
	
:	lda (editorTmp0),y
	and #%00011111
	ldx editorDrumSubMode
	eor SET_BITS,x
	sta (editorTmp0),y
:	jmp @y


:	swapSign PAD1_dud
	swapSign keyRepeatUD
		
	lda PAD1_dud
	ora keyRepeatUD
	
	cpy #osc_A_Coarse
	beq :+
	cpy #osc_B_Coarse
	beq :+
	cpy #osc_C_Coarse
	beq :+
	
	asl a
	asl a
	asl a
	asl a
	jmp :++
	
:	asl a		; x 12 for coarse pitch
	asl a
	sta editorTmp2
	asl a
	clc
	adc editorTmp2
:	sta editorTmp2
	
	lda PAD1_dlr
	ora keyRepeatLR
	sta editorTmp3
	
	lda editorTmp2
	ora editorTmp3
	beq :++++
	
	cpy #env_A_Volume
	beq :+
	cpy #env_A_Env
	beq :+
	cpy #env_B_Volume
	beq :+
	cpy #env_B_Env
	beq :+
	cpy #env_D_Volume
	beq :+
	cpy #env_D_Env
	bne :++

:	lda (editorTmp0),y
	clc
	adc editorTmp3
	and #$0F
	sta editorTmp3
	lda (editorTmp0),y
	and #$F0
	clc
	adc editorTmp2
	ora editorTmp3
	sta (editorTmp0),y
	sta lastDrumParameterValue
	jmp :++
	
:	lda (editorTmp0),y
	clc
	adc editorTmp2
	clc
	adc editorTmp3
	sta (editorTmp0),y
	sta lastDrumParameterValue
	
:	lda editorDrumSubMode
	jsr editorDecodeDrumVoice
	ldx editorDrumSubMode
	lda @drumProcs,x
	jsr addProcessToBuffer
		
:	ldx editorDrumSubMode
	lda editorSubModeIndexes,x
	tax
	lda #DRUM_CURSOR_X_BASE
	clc
	adc @drumCursorXOffsets,x
	sta editorCursorX
	lda #DRUM_CURSOR_Y_BASE
	clc
	adc @drumCursorYOffsets,x
	sta editorCursorY
	lda @drumCursorModes,x
	sta editorCursorMode

@x:	jsr editorUpdateCursor	
	rts ;jmp editorMainLoop

@y:	lda editorDrumSubMode
	jsr editorDecodeDrumVoice
	ldx editorDrumSubMode
	lda @drumProcs,x
	jsr addProcessToBuffer
	jmp :-
	
@keyWaitAB:
	lda editorWaitForAB
	beq :++
	lda keyReleaseB
	bne :+
	lda keyReleaseA
	beq :++
	jsr editorPasteDrum
:	lda #$01
	sta editorCopyInfoTimer
	lda #$00
	sta editorWaitForAB

:	rts

@drumProcs:	.BYTE procVoiceA,procVoiceB,procVoiceC,procVoiceD,procVoiceE
	.BYTE procDrumAux
	
@drumCursorModes:
	.BYTE $02,$02,$02,$02
	.BYTE $02,$02,$02,$02
	.BYTE $02,$02,$02,$03
	
	.BYTE $02,$02,$02,$02
	.BYTE $02,$02,$02,$02
	.BYTE $02,$02,$02,$03

	.BYTE $02,$02,$02,$02
	.BYTE $02,$02,$02,$02
	.BYTE $02,$02,$03,$02

	.BYTE $02,$02,$02,$02
	.BYTE $02,$02,$02,$02
	.BYTE $03,$02,$02,$02

	.BYTE $02,$02,$02,$02
	.BYTE $02,$02,$02,$02
	.BYTE $02,$03,$02,$02
	
@parameterMap:
	.BYTE $00,$03,$06,$09
	.BYTE $01,$04,$07,$0A
	.BYTE $02,$05,$08,gbl_VoiceSelect

	.BYTE $0B,$0E,$11,$14
	.BYTE $0C,$0F,$12,$15
	.BYTE $0D,$10,$13,gbl_VoiceSelect

	.BYTE $16,$18,$1B,$FF
	.BYTE $17,$19,$1C,$FF
	.BYTE $FF,$1A,gbl_VoiceSelect,$FF

	.BYTE $1D,            $1E,$21,$FF
	.BYTE $FF,            $1F,$22,$FF
	.BYTE gbl_VoiceSelect,$20,$23,$FF
	
;	.BYTE $1D,$20,$23,$FF
;	.BYTE $1E,$21,$FF,$FF
;	.BYTE $1F,$22,gbl_VoiceSelect,$FF

	.BYTE $24,$27,$FF,$FF
	.BYTE $25,$28,$FF,$FF
	.BYTE $26,gbl_VoiceSelect,$FF,$FF
	
@parameterMapIndexStart:
	.BYTE 0,12,24,36,48
@parameterMapIndexEnd:
	.BYTE 12,24,36,48,60

@drumCursorXOffsets:
	.BYTE $00,$18,$30,$48
	.BYTE $00,$18,$30,$48
	.BYTE $00,$18,$30,$41
	
	.BYTE $70,$88,$A0,$B8
	.BYTE $70,$88,$A0,$B8
	.BYTE $70,$88,$A0,$B1

	.BYTE $00,$18,$30,$FF
	.BYTE $00,$18,$30,$FF
	.BYTE $FF,$18,$29,$FF
	
	.BYTE $50,$68,$80,$FF
	.BYTE $FF,$68,$80,$FF
	.BYTE $49,$68,$80,$FF
	
;	.BYTE $50,$68,$80,$FF
;	.BYTE $50,$68,$FF,$FF
;	.BYTE $50,$68,$79,$FF
	
	.BYTE $A0,$B8,$FF,$FF
	.BYTE $A0,$B8,$FF,$FF
	.BYTE $A0,$B1,$FF,$FF
	
@drumCursorYOffsets:
	.BYTE $00,$00,$00,$00
	.BYTE $08,$08,$08,$08
	.BYTE $10,$10,$10,$11

	.BYTE $00,$00,$00,$00
	.BYTE $08,$08,$08,$08
	.BYTE $10,$10,$10,$11

	.BYTE $28,$28,$28,$FF
	.BYTE $30,$30,$30,$FF
	.BYTE $FF,$38,$39,$FF

	.BYTE $28,$28,$28,$FF
	.BYTE $FF,$30,$30,$FF
	.BYTE $39,$38,$38,$FF
	
;	.BYTE $28,$28,$28,$FF
;	.BYTE $30,$30,$FF,$FF
;	.BYTE $38,$38,$39,$FF

	.BYTE $28,$28,$FF,$FF
	.BYTE $30,$30,$FF,$FF
	.BYTE $38,$39,$FF,$FF

	
editorDecodeDrum:
	ldx editorCurrentDrum
	lda drumAddressLo,x
	sta editorTmp0
	lda drumAddressHi,x
	sta editorTmp1
	
	lda #WRAM_DRUMS
	jsr setMMC1r1

	lda #$00
	sta editorTmp3		;all voices
	lda editorTmp3
:	jsr editorDecodeDrumVoice
	inc editorTmp3
	lda editorTmp3
	cmp #voicesPerDrum
	bcc :-
	
	jsr editorDecodeDrumAux
	
	rts
	

editorDecodeDrumAux:
	lda editorCurrentDrum
	ldx #$00
	jsr @printHex
	ldy #gbl_DrumName
	lda (editorTmp0),y
	tax
	lda editorDrumNameTranslate,x
	sta scnDrumAuxBuffer+2
	iny
	lda (editorTmp0),y
	tax
	lda editorDrumNameTranslate,x
	sta scnDrumAuxBuffer+3
	iny
	lda (editorTmp0),y
	tax
	lda editorDrumNameTranslate,x
	sta scnDrumAuxBuffer+4
	
	iny
	lda (editorTmp0),y
	bpl :+
	ldx #(parameterNamesEnd-parameterNames)
	bne :++
:	sta editorTmp2
	asl a
	clc
	adc editorTmp2
	tax
:	lda parameterNames+0,x
	sta scnDrumAuxBuffer+5
	lda parameterNames+1,x
	sta scnDrumAuxBuffer+6
	lda parameterNames+2,x
	sta scnDrumAuxBuffer+7

	iny
	lda (editorTmp0),y
	bpl :+
	ldx #(parameterNamesEnd-parameterNames)
	bne :++
:	sta editorTmp2
	asl a
	clc
	adc editorTmp2
	tax
:	lda parameterNames+0,x
	sta scnDrumAuxBuffer+8
	lda parameterNames+1,x
	sta scnDrumAuxBuffer+9
	lda parameterNames+2,x
	sta scnDrumAuxBuffer+10

	iny
	lda (editorTmp0),y
	bpl :+
	ldx #(parameterNamesEnd-parameterNames)
	bne :++
:	sta editorTmp2
	asl a
	clc
	adc editorTmp2
	tax
:	lda parameterNames+0,x
	sta scnDrumAuxBuffer+11
	lda parameterNames+1,x
	sta scnDrumAuxBuffer+12
	lda parameterNames+2,x
	sta scnDrumAuxBuffer+13
	rts
	
	
@printHex:	pha
	lsr a
	lsr a
	lsr a
	lsr a
	clc
	adc #$30
	sta scnDrumAuxBuffer,x
	inx
	pla
	and #$0F
	clc
	adc #$30
	sta scnDrumAuxBuffer,x
	inx
	rts
	
	
editorDecodeDrumVoice:
	tax
	ldy #bytesPerDrum-1
	lda (editorTmp0),y
	ldy #SPR_VOICE_OFF
	and SET_BITS,x
	beq :+
	iny
:	tya
	pha
	lda @spriteIndex,x
	tay
	pla
	sta SPR05_CHAR,y
	
	lda @drumVoiceStartIndex,x
	tay
	lda @drumVoiceEndIndex,x
	sta editorTmp2
	
	lda @drumVoiceBufferOffsets,x
	tax
	
:	lda (editorTmp0),y
	jsr @printHex
	iny
	cpy editorTmp2
	bcc :-
	rts

@spriteIndex:	.BYTE $00,$04,$08,$0C,$10	

@printHex:	pha
	lsr a
	lsr a
	lsr a
	lsr a
	sta scnVoiceABuffer,x
	inx
	pla
	and #$0F
	sta scnVoiceABuffer,x
	inx
	rts
	
@drumVoiceStartIndex:
	.BYTE $00,$0B,$16,$1D,$24

@drumVoiceEndIndex:
	.BYTE $0B,$16,$1D,$24,$29
	
@drumVoiceBufferOffsets:
	.BYTE 0, 22, 44, 58, 72, 82
	
	
editorPrintDrum:
	lda #procVoiceA
	jsr addProcessToBuffer
	lda #procVoiceB
	jsr addProcessToBuffer
	lda #procVoiceC
	jsr addProcessToBuffer
	lda #procVoiceD
	jsr addProcessToBuffer
	lda #procVoiceE
	jsr addProcessToBuffer
	lda #procDrumAux
	jsr addProcessToBuffer
	rts



	
drumAddressLo:
	.REPEAT numberOfDrums,i
	.LOBYTES drums+(bytesPerDrum * i)
	.ENDREPEAT

drumAddressHi:
	.REPEAT numberOfDrums,i
	.HIBYTES drums+(bytesPerDrum * i)
	.ENDREPEAT
	
;------------------------------------------------------------------------------
; EDIT DRUM AUX
;------------------------------------------------------------------------------

editDrumAux:
	lda #WRAM_DRUMS
	jsr setMMC1r1
	
	ldx editorCurrentDrum
	lda drumAddressLo,x
	sta editorTmp0
	lda drumAddressHi,x
	sta editorTmp1
	
	
	lda editorWaitForAB
	beq :+
	jmp @keyWaitAB

:	jsr checkRepeatKeyA
	jsr checkRepeatKeyB
	jsr checkRepeatKeyUD
	jsr checkRepeatKeyLR

	lda keyRepeatSelect
	beq :+++
	lda PAD1_dud
	beq :+++
	bmi :+
	;edit menu
	ldx #EDIT_DRUM_MENU
	jsr editorShowEditMenu
	lda editorMode
	sta editorModeBeforeMenu
	lda #EDIT_MODE_DRUM_MENU
	sta editorMode
	jmp @x

:	lda editCopyBuffer
	cmp #COPY_ID_DRUM
	bne :+
	;jsr editorPasteDrum
	ldx #MSG_PASTE
	jsr editorSetCopyInfoMessage
	lda #$01
	sta editorWaitForAB
	jmp @x
		
:	ldx #MSG_PASTE_ERROR
	lda #$60
	jsr editorSetErrorMessage
	jmp @x
	
:	jsr @modifyValues
	lda editorEditDrumName
	bne @x	
	
	lda keyRepeatB
	beq :+
	lda PAD1_dud
	beq :+
	bpl :+
	lda #EDIT_MODE_DRUM
	sta editorMode
	jmp @x

:	lda PAD1_firea
	ora PAD1_fireb
	bne :++
	lda PAD1_dlr
	clc
	adc editorDrumAuxIndex
	bmi :+
	cmp #$04
	bcs :+
	sta editorDrumAuxIndex
:	jmp @x

:	lda PAD1_sel
	beq :+
	lda PAD1_dlr
	beq :+
	clc
	adc editorCurrentDrum
	bmi :+
	cmp #numberOfDrums
	bcs :+
	sta editorCurrentDrum
	jsr editorDecodeDrum
	jsr editorPrintDrum
	jmp @x
:	
	
@x:	lda editorEditDrumName
	bne :+
	ldx editorDrumAuxIndex
	lda #DRUM_AUX_CURSOR_X_BASE
	clc
	adc @cursorX,x
	sta editorCursorX
	lda #DRUM_AUX_CURSOR_Y_BASE
	clc
	adc @cursorY,x
	sta editorCursorY
	lda @cursorMode,x
	sta editorCursorMode
:	
	
	jsr editorUpdateCursor
	rts ;jmp editorMainLoop
	
@cursorX:	.BYTE $28,$50,$78,$A0
@cursorY:	.BYTE $00,$00,$00,$00
@cursorMode:	.BYTE $03,$03,$03,$03
@nameX:	.BYTE $00,$28,$30,$38

@modifyValues:	
	
	lda editorDrumAuxIndex
	beq :+
	jmp :+++++++
	
	;edit drum name
:	lda editorEditDrumName
	bne :++
	lda keyReleaseA
	bne :+
	rts
	
:	lda #$01
	sta editorEditDrumName
	lda #$00
	sta keyReleaseA
:	clc
	adc #gbl_DrumName-1
	tay
	lda #$05
	sta editorCursorMode
	lda keyRepeatUD
	ora PAD1_dud
	beq :+
	clc
	adc (editorTmp0),y
	bmi :+
	cmp #editorDrumNameTranslateEnd-editorDrumNameTranslate
	bcs :+
	sta (editorTmp0),y
	jsr editorDecodeDrumAux
	lda #procDrumAux
	jsr addProcessToBuffer
	rts

:	lda keyReleaseA
	beq :+
	lda #$00
	sta editorEditDrumName
	lda @cursorMode+0
	sta editorCursorMode
	jsr editorDecodeTrackDrums
	lda #procTrackDrumAll
	jsr addProcessToBuffer
	lda #WRAM_DRUMS
	jsr setMMC1r1
	rts

:	lda PAD1_dlr
	beq :+
	clc
	adc editorEditDrumName
	beq :+
	cmp #$04
	bcs :+
	sta editorEditDrumName

:	ldx editorEditDrumName
	lda @nameX,x
	clc
	adc #DRUM_AUX_CURSOR_X_BASE
	sta editorCursorX
	lda #DRUM_AUX_CURSOR_Y_BASE
	sta editorCursorY
	rts


;EDIT TRIGGER PARAMETERS
:	

	jsr _holdSelectTapA
	bcc :+
	jsr editorRemapTriggerParameters
	rts ;jmp :+++++

:	lda editorDrumAuxIndex
	clc
	adc #mod_Parameter0-1
	tay
	lda keyReleaseB
	beq :+
	lda (editorTmp0),y
	eor #$80
	sta (editorTmp0),y
	jmp :+++++
	
:	lda keyRepeatA
	beq :+++++
	lda PAD1_dud
	ora keyRepeatUD
	sta editorTmp2
	bne :++
	lda PAD1_dlr
	beq :+++++
	bmi :+
	lda (editorTmp0),y
	and #$7F
	tax
	lda @modForwards,x
	jmp :+++
:	lda (editorTmp0),y
	and #$7F
	tax
	lda @modBackwards,x
	jmp :++
	
:	lda (editorTmp0),y
	and #$7F
	clc
	adc editorTmp2
	bmi :++
	cmp #((parameterNamesEnd-parameterNames) / 3)
	bcs :++
:	sta (editorTmp0),y
:	jsr editorDecodeDrumAux
	lda #procDrumAux
	jsr addProcessToBuffer
:	rts	
	
@modForwards:	.BYTE $01
	.BYTE $0C,$0C,$0C,$0C,$0C,$0C,$0C,$0C,$0C,$0C,$0C
	.BYTE $17,$17,$17,$17,$17,$17,$17,$17,$17,$17,$17
	.BYTE $1E,$1E,$1E,$1E,$1E,$1E,$1E
	.BYTE $25,$25,$25,$25,$25,$25,$25
	.BYTE $25,$25,$25,$25,$25
	
@modBackwards:	.BYTE $00
	.BYTE $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
	.BYTE $01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01
	.BYTE $0C,$0C,$0C,$0C,$0C,$0C,$0C
	.BYTE $17,$17,$17,$17,$17,$17,$17
	.BYTE $1E,$1E,$1E,$1E,$1E,$1E,$1E
	

@keyWaitAB:
	lda editorWaitForAB
	beq :++
	lda keyReleaseB
	bne :+
	lda keyReleaseA
	beq :++
	jsr editorPasteDrum
:	lda #$01
	sta editorCopyInfoTimer
	lda #$00
	sta editorWaitForAB
:	rts

editorRemapTriggerParameters:
	;get current mod parameter number and value (from drum)
	;scan current track, when a note is found replace mod parameter value
	;need to do this from drum aux editor and grid/trigger editor
	lda #WRAM_DRUMS
	jsr setMMC1r1
	
	ldx editorCurrentDrum
	lda drumAddressLo,x
	sta editorTmp0
	lda drumAddressHi,x
	sta editorTmp1
	
	lda editorMode
	cmp #EDIT_MODE_TRIGGER_PARAMETER
	beq :+
	cmp #EDIT_MODE_GRID
	beq :+
	
	lda editorDrumAuxIndex
	beq @x
	sta editorTmp2		;contains 1 to 3 = parameter number
	clc
	adc #mod_Parameter0-1	;+1? for 0 offset
	tay
	lda (editorTmp0),y
	tay
	cpy #gbl_DrumName
	bcs @x
	lda (editorTmp0),y
	sta editorTmp3		;value
	dec editorTmp2		;adust 0 - 2
	jmp :++

:	ldx cursorY_grid
	lda editorTriggerIndex,x	;editing trigger/grid
	cmp #$02
	bcc @x
	sec
	sbc #$02
	sta editorTmp2
	clc
	adc #mod_Parameter0
	tay
	lda (editorTmp0),y
	tay
	cpy #gbl_DrumName
	bcs @x
	lda (editorTmp0),y
	sta editorTmp3

:	ldx cursorY_grid
	lda editorTrackPhrase,x
	tax
	lda phraseBanks,x
	jsr setMMC1r1
	lda phraseTableLo,x
	sta editorTmp0
	lda phraseTableHi,x
	sta editorTmp1
	
	ldy #$00
:	lda (editorTmp0),y
	beq :+
	cmp #$FF
	beq :+
	tya
	pha		;save y index
	iny
	iny		;move index to first mod parameter
	tya
	clc
	adc editorTmp2		;add trigger index to get right one
	tay
	lda editorTmp3		;write value to trigger
	sta (editorTmp0),y
	pla
	tay		;restore Y
	
:	iny
	iny
	iny
	iny
	iny
	cpy #(16*5);stepsPerPhrase * bytesPerPhraseStep
	bcc :--
	
	lda #trackWipeSpeed
	sta editorTrackWipeSpeed
	
	jsr editorDecodeTriggerParameters
	jsr editorPrintTriggers


@x:	rts
	
	
_holdSelectTapA:
	clc
	lda PAD1_sel
	beq :+
	lda keyReleaseA
	beq :+
	sec
:	rts

_holdSelect_tapDown:
	clc
	lda PAD1_sel
	beq :+
	lda PAD1_dud
	beq :+
	bmi :+
	sec
:	rts

_holdSelect_tapUp:
	clc
	lda PAD1_sel
	beq :+
	lda PAD1_dud
	beq :+
	bpl :+
	sec
:	rts

editorReorderTracks:
	lda #WRAM_PATTERNS
	jsr setMMC1r1
	
	lda PAD1_dud
	bne :+
@x2:	rts
	
:	clc
	adc cursorY_grid	;trying to move track off top/bottom of grid
	bmi @x2		;so return
	cmp #$06
	bcs @x2
	
	sta editorTmp4		;dest

	ldx cursorY_grid	;swap phrase and drum assignments
	ldy editorTmp4
	lda editorTrackPhrase,x
	pha
	lda editorTrackPhrase,y
	sta editorTrackPhrase,x
	pla
	sta editorTrackPhrase,y
	
	lda editorTrackDrum,x
	pha
	lda editorTrackDrum,y
	sta editorTrackDrum,x
	pla
	sta editorTrackDrum,y
	
	ldx editorCurrentPattern
	lda patternTableLo,x
	sta editorTmp0
	lda patternTableHi,x
	sta editorTmp1

	ldy #PATTERN_DRUM_0
:	lda editorTrackDrum,y
	sta (editorTmp0),y
	iny
	cpy #bytesPerPattern
	bcc :-
	
	lda cursorY_grid
	sta editorTmp5		;old cursor Y
	lda editorTmp4		;new cursor Y
	sta cursorY_grid
	
	;reorder mutes
	lda editorSoloChannel
	bmi :++
	
	cmp cursorY_grid
	bne :+
	lda editorTmp5
	sta editorSoloChannel
	jmp :+
:	cmp editorTmp5
	bne :+
	lda cursorY_grid
	sta editorSoloChannel
	
:	
	ldx cursorY_grid	;reorder solo
	ldy editorTmp5
	lda editorChannelStatus,x
	pha
	lda editorChannelStatus,y
	sta editorChannelStatus,x
	pla
	sta editorChannelStatus,y
	
	lda cursorY_grid
	jsr editorDecodePhrase
	lda editorTmp5
	jsr editorDecodePhrase
	lda cursorY_grid
	jsr editorDecodeTrackDrum
	lda editorTmp5
	jsr editorDecodeTrackDrum	
	jsr editorDecodeTriggerParameters

	ldx editorTmp4
	jsr editorPrintTrack
	ldx editorTmp5
	jsr editorPrintTrack
	
	jsr editorPrintTriggers
	lda #procTrackDrumAll
	jsr addProcessToBuffer
	jsr editorPrintDrum
	
	lda #$01
	sta editorForceTrackLoad
	
	ldx cursorY_grid
	lda @cursorY,x
	sta editorCursorY
	
		
@x:	rts

@cursorY:	.REPEAT rowsPerGrid,i
	.BYTE TRACK_CURSOR_Y_BASE + (i * 8)
	.ENDREPEAT

editorShiftTrackRight:
	ldx cursorY_grid
	lda editorTrackPhrase,x
	tax
	lda phraseBanks,x
	jsr setMMC1r1
	
	lda phraseTableLo,x
	clc
	adc #<(stepsPerPhrase-2)*bytesPerPhraseStep
	sta editorTmp0
	lda phraseTableHi,x
	adc #>(stepsPerPhrase-2)*bytesPerPhraseStep
	sta editorTmp1

	lda phraseTableLo,x
	clc
	adc #<(stepsPerPhrase-1)*bytesPerPhraseStep
	sta editorTmp2
	lda phraseTableHi,x
	adc #>(stepsPerPhrase-1)*bytesPerPhraseStep
	sta editorTmp3
	
	;do 15 times
	lda #stepsPerPhrase-1
	sta editorTmp4		;count
	
	ldy #$00		;save last step
	lda (editorTmp2),y
	pha
	iny
	lda (editorTmp2),y
	pha
	iny
	lda (editorTmp2),y
	pha
	iny
	lda (editorTmp2),y
	pha
	iny
	lda (editorTmp2),y
	pha
	
:	ldy #$00		;move 5 bytes to right
	lda (editorTmp0),y
	sta (editorTmp2),y
	iny
	lda (editorTmp0),y
	sta (editorTmp2),y
	iny
	lda (editorTmp0),y
	sta (editorTmp2),y
	iny
	lda (editorTmp0),y
	sta (editorTmp2),y
	iny
	lda (editorTmp0),y
	sta (editorTmp2),y
	
	lda editorTmp0		;move pointers to previous step
	sec
	sbc #bytesPerPhraseStep
	sta editorTmp0
	lda editorTmp1
	sbc #$00
	sta editorTmp1
	
	lda editorTmp2
	sec
	sbc #bytesPerPhraseStep
	sta editorTmp2
	lda editorTmp3
	sbc #$00
	sta editorTmp3
	
	dec editorTmp4
	bne :-
	
	;At this point, Tmp0/Tmp1 should point to first step
	ldy #bytesPerPhraseStep-1	;move last step to first step
	pla
	sta (editorTmp2),y
	dey
	pla
	sta (editorTmp2),y
	dey
	pla
	sta (editorTmp2),y
	dey
	pla
	sta (editorTmp2),y
	dey
	pla
	sta (editorTmp2),y
	
	;lda cursorY_grid	;print track
	;jsr editorDecodePhrase
	;ldx cursorY_grid
	;jsr editorPrintTrack
	
	jsr editorCheckUpdatePhrases
	jsr editorDecodeTriggerParameters
	jsr editorPrintTriggers
	rts
	
editorShiftTrackLeft:
	ldx cursorY_grid
	lda editorTrackPhrase,x
	tax
	lda phraseBanks,x
	jsr setMMC1r1
	
	lda phraseTableLo,x
	sta editorTmp0
	lda phraseTableHi,x
	sta editorTmp1

	lda phraseTableLo,x
	clc
	adc #bytesPerPhraseStep
	sta editorTmp2
	lda phraseTableHi,x
	adc #$00
	sta editorTmp3
	
	;do 15 times
	lda #stepsPerPhrase-1
	sta editorTmp4		;count
	
	ldy #$00		;save last step
	lda (editorTmp0),y
	pha
	iny
	lda (editorTmp0),y
	pha
	iny
	lda (editorTmp0),y
	pha
	iny
	lda (editorTmp0),y
	pha
	iny
	lda (editorTmp0),y
	pha
	
:	ldy #$00		;move 5 bytes to right
	lda (editorTmp2),y
	sta (editorTmp0),y
	iny
	lda (editorTmp2),y
	sta (editorTmp0),y
	iny
	lda (editorTmp2),y
	sta (editorTmp0),y
	iny
	lda (editorTmp2),y
	sta (editorTmp0),y
	iny
	lda (editorTmp2),y
	sta (editorTmp0),y
	
	lda editorTmp0		;move pointers to previous step
	clc
	adc #bytesPerPhraseStep
	sta editorTmp0
	lda editorTmp1
	adc #$00
	sta editorTmp1
	
	lda editorTmp2
	clc
	adc #bytesPerPhraseStep
	sta editorTmp2
	lda editorTmp3
	adc #$00
	sta editorTmp3
	
	dec editorTmp4
	bne :-
	
	;At this point, Tmp0/Tmp1 should point to first step
	ldy #bytesPerPhraseStep-1	;move last step to first step
	pla
	sta (editorTmp0),y
	dey
	pla
	sta (editorTmp0),y
	dey
	pla
	sta (editorTmp0),y
	dey
	pla
	sta (editorTmp0),y
	dey
	pla
	sta (editorTmp0),y
	
	;lda cursorY_grid	;print track
	;jsr editorDecodePhrase
	;ldx cursorY_grid
	;jsr editorPrintTrack
	jsr editorCheckUpdatePhrases
	jsr editorDecodeTriggerParameters
	jsr editorPrintTriggers
	
	rts


editorEditGridMenu:
	jsr checkRepeatKeyA
	jsr checkRepeatKeyB
	jsr checkRepeatKeyUD
	jsr checkRepeatKeyLR
	
	lda #$04
	sta editorCursorMode
	
	lda keyReleaseB		;cancel
	beq :+
	jsr editorShowEditMenu	;toggle
	lda editorModeBeforeMenu
	sta editorMode
	lda #$00
	sta cursorY_editMenu
	jmp @x

:	lda keyReleaseA
	beq :+
	ldx cursorY_editMenu
	lda @jumpTableLo,x
	sta jumpVector
	lda @jumpTableHi,x
	sta jumpVector+1
	jsr editorShowEditMenu	;toggle
	lda editorModeBeforeMenu
	sta editorMode
	jmp (jumpVector)

:	lda cursorY_editMenu
	clc
	adc PAD1_dud
	bmi :+
	cmp #$04
	bcs :+
	sta cursorY_editMenu
:
	
@x:	ldx cursorY_editMenu
	lda @cursorX,x
	clc
	adc #GRID_CURSOR_X_BASE
	sta editorCursorX
	lda @cursorY,x
	clc
	adc #GRID_CURSOR_Y_BASE
	sta editorCursorY
	jsr editorUpdateCursor
	rts
	
@cursorX:	.BYTE $28,$28,$28,$28

@cursorY:	.BYTE $08,$10,$18,$20

@jumpTableLo:	.LOBYTES editorCopyPhrase,editorCopyPattern,editorCutPhrase,editorCutPattern
@jumpTableHi:	.HIBYTES editorCopyPhrase,editorCopyPattern,editorCutPhrase,editorCutPattern


editorClearMenu:
	jsr checkRepeatKeyA
	jsr checkRepeatKeyB
	jsr checkRepeatKeyUD
	jsr checkRepeatKeyLR
	
	lda editorWaitForAB
	beq :+
	jmp @keyWaitAB
	
:	lda #$04
	sta editorCursorMode
	
	lda keyReleaseB		;cancel
	beq :+
	jsr editorShowEditMenu	;toggle
	lda editorModeBeforeMenu
	sta editorMode
	lda #$00
	sta cursorY_editMenu
	jmp @x

:	lda keyReleaseA
	beq :+
	
	ldx #MSG_CONFIRM
	;show confirmation
	jsr editorSetConfirmMessage
	lda #$01
	sta editorWaitForAB
	jmp @x
	

:	lda cursorY_editMenu
	clc
	adc PAD1_dud
	bmi :+
	cmp #$05
	bcs :+
	sta cursorY_editMenu
:
	
@x:	ldx cursorY_editMenu
	lda @cursorX,x
	clc
	adc #GRID_CURSOR_X_BASE
	sta editorCursorX
	lda @cursorY,x
	clc
	adc #GRID_CURSOR_Y_BASE
	sta editorCursorY
	jsr editorUpdateCursor
	rts

@keyWaitAB:
	lda editorWaitForAB
	beq :++
	lda keyReleaseB
	bne :+
	lda keyReleaseA
	beq :++
	
	lda #$01		;A = select
	sta editorCopyInfoTimer
	lda #$00
	sta editorWaitForAB

	ldx cursorY_editMenu
	lda @jumpTableLo,x
	sta jumpVector
	lda @jumpTableHi,x
	sta jumpVector+1
	jsr editorShowEditMenu	;toggle
	lda editorModeBeforeMenu
	sta editorMode

	lda #PLAY_MODE_STOPPED	;stop playback always
	sta plyrMode
	sta plyrModeOld
	jmp (jumpVector)

:	lda #$01		;B = cancel
	sta editorCopyInfoTimer
	lda #$00
	sta editorWaitForAB
:	rts
	
@cursorX:	.BYTE $28,$28,$28,$28,$28

@cursorY:	.BYTE $08,$10,$18,$20,$28

@jumpTableLo:	.LOBYTES menuWipeSongs,menuWipePatterns,menuWipePhrases,menuWipeDrums,editorWipeAll
@jumpTableHi:	.HIBYTES menuWipeSongs,menuWipePatterns,menuWipePhrases,menuWipeDrums,editorWipeAll
	
editorEditDrumMenu:
	jsr checkRepeatKeyA
	jsr checkRepeatKeyB
	jsr checkRepeatKeyUD
	jsr checkRepeatKeyLR
	
	lda #$04
	sta editorCursorMode
	
	lda keyReleaseB		;cancel
	beq :+
	jsr editorShowEditMenu	;toggle
	lda editorModeBeforeMenu
	sta editorMode
	lda #$00
	sta cursorY_editMenu
	jmp @x

:	lda keyReleaseA
	beq :+
	ldx cursorY_editMenu
	lda @jumpTableLo,x
	sta jumpVector
	lda @jumpTableHi,x
	sta jumpVector+1
	jsr editorShowEditMenu	;toggle
	lda editorModeBeforeMenu
	sta editorMode
	jmp (jumpVector)

:	lda cursorY_editMenu
	clc
	adc PAD1_dud
	bmi :+
	cmp #$03
	bcs :+
	sta cursorY_editMenu
:
	
@x:	ldx cursorY_editMenu
	lda @cursorX,x
	clc
	adc #GRID_CURSOR_X_BASE
	sta editorCursorX
	lda @cursorY,x
	clc
	adc #GRID_CURSOR_Y_BASE
	sta editorCursorY
	jsr editorUpdateCursor
	rts
	
@cursorX:	.BYTE $28,$28,$28,$28

@cursorY:	.BYTE $08,$10,$18,$20

@jumpTableLo:	.LOBYTES editorCopyDrum,editorCutDrum,editorSwapAB
@jumpTableHi:	.HIBYTES editorCopyDrum,editorCutDrum,editorSwapAB


editorSwapAB:	
	lda #WRAM_DRUMS
	jsr setMMC1r1
	
	ldx editorCurrentDrum
	lda drumAddressLo,x
	sta editorTmp0
	lda drumAddressHi,x
	sta editorTmp1
	
	ldy #$00
:	lda (editorTmp0),y
	pha
	iny
	cpy #osc_B_Coarse
	bcc :-

:	lda (editorTmp0),y
	pha
	iny
	cpy #osc_C_Coarse
	bcc :-
	
	ldy #dty_A_Width1
:	pla
	sta (editorTmp0),y
	dey
	bpl :-
	
	ldy #dty_B_Width1
:	pla
	sta (editorTmp0),y
	dey
	cpy #osc_B_Coarse
	bcs :-
	
	ldy #gbl_VoiceSelect
	lda (editorTmp0),y
	and #%00000001
	asl a
	sta editorTmp2
	lda (editorTmp0),y
	and #%00000010
	lsr a
	sta editorTmp3
	lda (editorTmp0),y
	and #%11111100
	ora editorTmp2
	ora editorTmp3
	sta (editorTmp0),y
	
	jsr editorDecodeDrum
	jsr editorPrintDrum
	rts
	
	
	

editorEditSongMenu:
	jsr checkRepeatKeyA
	jsr checkRepeatKeyB
	jsr checkRepeatKeyUD
	jsr checkRepeatKeyLR
	
	lda #$04
	sta editorCursorMode
	
	lda keyReleaseB		;cancel
	beq :+
	jsr editorShowEditMenu	;toggle
	lda editorModeBeforeMenu
	sta editorMode
	lda #$00
	sta cursorY_editMenu
	jmp @x

:	lda keyReleaseA
	beq :+
	ldx cursorY_editMenu
	lda @jumpTableLo,x
	sta jumpVector
	lda @jumpTableHi,x
	sta jumpVector+1
	jsr editorShowEditMenu	;toggle
	lda editorModeBeforeMenu
	sta editorMode
	jmp (jumpVector)

:	lda cursorY_editMenu
	clc
	adc PAD1_dud
	bmi :+
	cmp #$02
	bcs :+
	sta cursorY_editMenu
:
	
@x:	ldx cursorY_editMenu
	lda @cursorX,x
	clc
	adc #GRID_CURSOR_X_BASE
	sta editorCursorX
	lda @cursorY,x
	clc
	adc #GRID_CURSOR_Y_BASE
	sta editorCursorY
	jsr editorUpdateCursor
	rts
	
@cursorX:	.BYTE $28,$28,$28,$28

@cursorY:	.BYTE $08,$10,$20,$20

@jumpTableLo:	.LOBYTES editorPasteLoop,editorInsertLoop
@jumpTableHi:	.HIBYTES editorPasteLoop,editorInsertLoop


editorDecodeEchoMenu:
CHR_OFF	= $FA
CHR_ON	= $FB
	ldy editorCurrentPattern
	lda #WRAM_PATTERNS
	jsr setMMC1r1
	ldx @gridBufferIndexes+0
	lda songEchoSelect,y
	sta editorTmp0
	lda #CHR_OFF
	lsr editorTmp0
	adc #$00
	sta scnGridBuffer,x
	ldx @gridBufferIndexes+1
	lda #CHR_OFF
	lsr editorTmp0
	adc #$00
	sta scnGridBuffer,x
	ldx @gridBufferIndexes+2
	lda #CHR_OFF
	lsr editorTmp0
	adc #$00
	sta scnGridBuffer,x
	ldx @gridBufferIndexes+8
	lda #CHR_OFF
	lsr editorTmp0
	adc #$00
	sta scnGridBuffer,x	

	ldx @gridBufferIndexes+3
	lda songEchoLevelA,y
	jsr @printHex1
	ldx @gridBufferIndexes+4
	lda songEchoLevelB,y
	jsr @printHex1
	ldx @gridBufferIndexes+5
	lda songEchoLevelD,y
	jsr @printHex1

	ldx @gridBufferIndexes+6
	lda songEchoDecay,y
	jsr @printHex
	ldx @gridBufferIndexes+7
	lda songEchoSpeed,y
	jsr @printHex
	rts
	
@printHex:	pha
	lsr a
	lsr a
	lsr a
	lsr a
	sta scnGridBuffer,x
	inx
	pla
@printHex1:	and #$0F
	sta scnGridBuffer,x
	inx
	rts

@gridBufferIndexes:
	.BYTE 21,37,53
	.BYTE 23,39,55
	.BYTE 26,42,58
	
	.BYTE 21,23,26
	.BYTE 37,39,42
	.BYTE 53,55,58
	
editorEditEchoMenu:
	jsr checkRepeatKeyA
	jsr checkRepeatKeyB
	jsr checkRepeatKeyUD
	jsr checkRepeatKeyLR
	
	lda #WRAM_PATTERNS
	jsr setMMC1r1
				
	lda keyReleaseB		;cancel
	beq :+
	jsr editorShowEditMenu	;toggle
	lda editorModeBeforeMenu
	sta editorMode
	lda #$00
	sta cursorY_editMenu
	jmp @x

:	ldx cursorY_editMenu
	lda @echoParameterLo,x
	sta editorTmp0
	lda @echoParameterHi,x
	sta editorTmp1
	cpx #$03
	bcc :+
	cpx #$08
	beq :+
	
	lda keyRepeatA		;modify numbers
	beq :++	
	ldy editorCurrentPattern
	lda PAD1_dlr
	ora keyRepeatLR
	beq @x
	clc
	adc (editorTmp0),y
	bmi @x
	cmp @max,x
	bcs @x
	sta (editorTmp0),y
	jmp @y

:	lda keyReleaseA		;modify switches
	beq :+
	ldy editorCurrentPattern
	lda (editorTmp0),y
	eor @bitMasks,x
	sta (editorTmp0),y
	lda #procGridRow02
	jsr addProcessToBuffer
	jmp @y

:	ldx cursorY_editMenu
	lda PAD1_dlr
	beq :++
	bpl :+
	lda @deltaU,x
	bmi @x
	sta cursorY_editMenu
	jmp @x
:	lda @deltaD,x
	bmi @x
	sta cursorY_editMenu
	jmp @x
	
:	lda PAD1_dud
	beq @x
	bpl :+
	lda @deltaL,x
	bmi @x
	sta cursorY_editMenu
	jmp @x
:	lda @deltaR,x
	bmi @x
	sta cursorY_editMenu
	jmp @x

@y:	jsr editorDecodeEchoMenu
	ldx cursorY_editMenu
	lda @procs,x
	jsr addProcessToBuffer
	
@x:	ldx cursorY_editMenu
	lda @cursorX,x
	clc
	adc #GRID_CURSOR_X_BASE
	sta editorCursorX
	lda @cursorY,x
	clc
	adc #GRID_CURSOR_Y_BASE
	sta editorCursorY
	lda @cursorMode,x
	sta editorCursorMode
	jsr editorUpdateCursor
	rts

@echoParameterLo:
	.LOBYTES songEchoSelect,songEchoSelect,songEchoSelect
	.LOBYTES songEchoLevelA,songEchoLevelB,songEchoLevelD
	.LOBYTES songEchoDecay,songEchoSpeed
	.LOBYTES songEchoSelect
@echoParameterHi:
	.HIBYTES songEchoSelect,songEchoSelect,songEchoSelect
	.HIBYTES songEchoLevelA,songEchoLevelB,songEchoLevelD
	.HIBYTES songEchoDecay,songEchoSpeed
	.HIBYTES songEchoSelect
	
@max:	.BYTE $00,$00,$00
	.BYTE $10,$10,$10
	.BYTE $10,$40,$00
	
@bitMasks:	.BYTE $01,$02,$04
	.BYTE $00,$00,$00
	.BYTE $00,$00,$08

@procs:	.BYTE procGridRow01,procGridRow02,procGridRow03
	.BYTE procGridRow01,procGridRow02,procGridRow03
	.BYTE procGridRow01,procGridRow02,procGridRow03
	
@cursorX:	.BYTE $28,$28,$28
	.BYTE $38,$38,$38
	.BYTE $50,$50,$50
@cursorY:	.BYTE $08,$10,$18
	.BYTE $08,$10,$18
	.BYTE $08,$10,$18
@cursorMode:	.BYTE $01,$01,$01
	.BYTE $01,$01,$01
	.BYTE $02,$02,$01
@deltaU:	.BYTE $FF,$FF,$FF
	.BYTE $00,$01,$02
	.BYTE $03,$04,$05
@deltaD:	.BYTE $03,$04,$05
	.BYTE $06,$07,$08
	.BYTE $FF,$FF,$FF
@deltaL:	.BYTE $FF,$00,$01
	.BYTE $FF,$03,$04
	.BYTE $FF,$06,$07
@deltaR:	.BYTE $01,$02,$FF
	.BYTE $04,$05,$FF
	.BYTE $07,$08,$FF



;Errors
; No Loop
; No Space
; Record not enabled
editorPasteLoop:
	lda editSongMode
	cmp #SONG_MODE_REC
	bne :+++
	
	lda #WRAM_SONGS
	jsr setMMC1r1

	ldx editorCurrentSong
	lda songLoopLengthTable,x
	bne :+
	rts
	
:	sta editorTmp4		;count
	lda songTableLo,x
	sta editorTmp0
	clc
	adc songLoopLengthTable,x
	sta editorTmp2
	lda songTableHi,x
	sta editorTmp1
	adc #$00
	sta editorTmp3
	
	lda songLoopStartTable,x
	tay
:	lda (editorTmp0),y
	sta (editorTmp2),y
	iny
	beq :+		;can't go past end of Song
	dec editorTmp4
	bne :-
	
	lda songLoopStartTable,x
	clc
	adc songLoopLengthTable,x
	bcs :+
	sta editorSongLoopStartTemp
	sta songLoopStartTable,x
	
	ldx #MSG_LOOP_COPY
	lda #$60
	jsr editorSetErrorMessage
	jsr editorDecodeSong
	lda #procSongAll
	jsr addProcessToBuffer
	
	rts
	
:	;error
	ldx #MSG_PASTE_ERROR
	lda #$60
	jsr editorSetErrorMessage
	rts

editorInsertSongBar:
	lda editSongMode
	cmp #SONG_MODE_REC
	beq :+
	rts
	
:	lda #WRAM_SONGS
	jsr setMMC1r1
	ldx editorCurrentSong
	lda songTableLo,x
	sta editorTmp0
	lda songTableHi,x
	sta editorTmp1
	
	lda editorSongBar
	sta editorTmp4
	
	lda #$FF
	sta editorTmp2
	lda #$FE
	sta editorTmp3
	jsr _insertBars
	jsr editorDecodeSong
	lda #procSongAll
	jsr addProcessToBuffer
	rts
	
editorRemoveSongBar:
	lda editSongMode
	cmp #SONG_MODE_REC
	beq :+
	rts
	
:	lda #WRAM_SONGS
	jsr setMMC1r1
	ldx editorCurrentSong
	lda songTableLo,x
	sta editorTmp0
	lda songTableHi,x
	sta editorTmp1
	
	lda editorSongBar
	cmp #$FF
	beq :+
	sta editorTmp2
	sta editorTmp3
	inc editorTmp3
	
	jsr _removeBars
	jsr editorDecodeSong
	lda #procSongAll
	jsr addProcessToBuffer
:	rts

_insertBars:
:	ldy editorTmp3
	lda (editorTmp0),y
	ldy editorTmp2
	sta (editorTmp0),y
	dec editorTmp2
	dec editorTmp3
	inc editorTmp4
	bne :-
	
	ldx editorCurrentSong
	lda editorSongBar
	cmp editorSongLoopStartTemp
	beq :+
	bcc :+
	
	inc editorSongLoopLengthTemp
	lda editorSongLoopLengthTemp
	sta songLoopLengthTable,x	
	rts
	
:	inc editorSongLoopStartTemp
	lda editorSongLoopStartTemp
	sta songLoopStartTable,x
	rts

_removeBars:

:	ldy editorTmp3
	lda (editorTmp0),y
	ldy editorTmp2
	sta (editorTmp0),y
	inc editorTmp2
	inc editorTmp3
	bne :-
	ldy #$FF
	lda #$00
	sta (editorTmp0),y
	
	ldx editorCurrentSong
	lda editorSongBar
	cmp editorSongLoopStartTemp
	bcc :+
	
	dec editorSongLoopLengthTemp
	lda editorSongLoopLengthTemp
	sta songLoopLengthTable,x	
	rts
	
:	dec editorSongLoopStartTemp
	lda editorSongLoopStartTemp
	sta songLoopStartTable,x	
	
	rts
	

	
	
editorInsertLoop:
	
	lda editSongMode
	cmp #SONG_MODE_REC
	bne :++
	
	lda #WRAM_SONGS
	jsr setMMC1r1

	ldx editorCurrentSong
	lda songLoopLengthTable,x
	bne :+
	rts

	;because of way editing Loop Start and Length is range checked
	; should never be able to get a loop outside of Song range
:	clc
	adc songLoopStartTable,x
	sta editorTmp4

	lda #$FF
	sta editorTmp2
	sec
	sbc songLoopLengthTable,x
	sta editorTmp3

	lda songTableLo,x
	sta editorTmp0
	lda songTableHi,x
	sta editorTmp1
	
	jsr _insertBars

	lda songLoopStartTable,x
	clc
	adc songLoopLengthTable,x
	sta editorSongLoopStartTemp
	sta songLoopStartTable,x
	
	ldx #MSG_LOOP_COPY
	lda #$60
	jsr editorSetErrorMessage
	jsr editorDecodeSong
	lda #procSongAll
	jsr addProcessToBuffer
	rts

:	;error
	ldx #MSG_PASTE_ERROR
	lda #$60
	jsr editorSetErrorMessage
	rts
	
editorCopyPhrase:
	ldx cursorY_grid
	lda editorTrackPhrase,x
	tax
	lda phraseBanks,x
	jsr setMMC1r1
	lda phraseTableLo,x
	sta editorTmp0
	lda phraseTableHi,x
	sta editorTmp1
	ldy #$00
:	lda (editorTmp0),y
	sta editCopyBuffer+1,y
	iny
	cpy #stepsPerPhrase * bytesPerPhraseStep
	bcc :-
	lda #COPY_ID_PHRASE
	sta editCopyBuffer
	ldx cursorY_grid
	lda editorTrackPhrase,x
	ldx #MSG_PHR_COPY
	jsr editorSetCopyInfoMessage
	rts

editorCopyPattern:
	lda #WRAM_PATTERNS
	jsr setMMC1r1
	
	ldx #$00
:	lda editorTrackDrum,x
	sta editCopyBuffer+1,x
	inx
	cpx #bytesPerPattern
	bcc :-
	
	ldy editorCurrentPattern
	lda songEchoSelect,y
	sta editCopyBuffer+1,x
	inx
	lda songEchoLevelA,y
	sta editCopyBuffer+1,x
	inx
	lda songEchoLevelB,y
	sta editCopyBuffer+1,x
	inx
	lda songEchoLevelD,y
	sta editCopyBuffer+1,x
	inx
	lda songEchoDecay,y
	sta editCopyBuffer+1,x
	inx
	lda songEchoSpeed,y
	sta editCopyBuffer+1,x
	
	lda #COPY_ID_PATTERN
	sta editCopyBuffer
	lda editorCurrentPattern
	ldx #MSG_PTN_COPY
	jsr editorSetCopyInfoMessage
	rts

editorCutPhrase:
	jsr editorCopyPhrase
	jsr editorClearPhrase
	rts


editorClearPhrase:
	ldx cursorY_grid
	jsr _editorClearPhrase
	jsr editorCheckUpdatePhrases
	lda cursorY_grid
	jsr editorDecodeTrackDrum	
	jsr editorDecodeDrum
	jsr editorDecodeTriggerParameters
	ldx cursorY_grid
	lda @trackProcs,x
	jsr addProcessToBuffer
	jsr editorPrintTriggers
	rts
@trackProcs:	.BYTE procTrackDrum00,procTrackDrum01,procTrackDrum02
	.BYTE procTrackDrum03,procTrackDrum04,procTrackDrum05
	
_editorClearPhrase:
	lda editorTrackPhrase,x
	tax
	lda phraseBanks,x
	jsr setMMC1r1
	lda phraseTableLo,x
	sta editorTmp0
	lda phraseTableHi,x
	sta editorTmp1
	ldy #$00
	tya
:	sta (editorTmp0),y
	iny
	cpy #stepsPerPhrase * bytesPerPhraseStep
	bcc :-
	rts
	
editorCutPattern:
	lda #WRAM_PATTERNS
	jsr setMMC1r1
	
	jsr editorCopyPattern

	ldx editorCurrentPattern
	lda patternTableLo,x
	sta editorTmp0
	lda patternTableHi,x
	sta editorTmp1

	ldy #$00
	lda #$00
:	sta (editorTmp0),y
	sta editorTrackDrum,y
	iny
	cpy #PATTERN_PHRASE_5+1
	bcc :-
	lda #DEFAULT_SPEED
	sta (editorTmp0),y
	sta editorPatternSpeed
	iny
	lda #DEFAULT_SWING
	sta (editorTmp0),y
	sta editorPatternGroove
	

	ldx editorCurrentPattern
	lda #INIT_ECHO_SELECT
	sta songEchoSelect,x
	lda #INIT_ECHO_LEVEL
	sta songEchoLevelA,x
	sta songEchoLevelB,x
	sta songEchoLevelD,x
	lda #INIT_ECHO_DECAY
	sta songEchoDecay,x
	lda #INIT_ECHO_SPEED
	sta songEchoSpeed,x
	
	lda #$01
	sta doNotInterrupt
	jsr editorReprintPattern

	ldx cursorY_grid
	lda editorTrackDrum,x
	sta editorCurrentDrum
	
	jsr editorDecodeDrum
	jsr editorDecodeTrackDrums
	jsr editorPrintDrum
	lda #procTrackDrumAll
	jsr addProcessToBuffer
	lda #$00
	sta doNotInterrupt
	rts

editorPasteGrid:
	lda editCopyBuffer
	bne :+
	rts		;error message?
	
:	lda editCopyBuffer
	cmp #COPY_ID_PHRASE
	beq :+
	cmp #COPY_ID_PATTERN
	beq :+++
	rts		;error message?

;paste phrase	
:	ldx cursorY_grid
	lda editorTrackPhrase,x
	tax
	lda phraseBanks,x
	jsr setMMC1r1
	lda phraseTableLo,x
	sta editorTmp0
	lda phraseTableHi,x
	sta editorTmp1	
	ldy #$00
:	lda editCopyBuffer+1,y
	sta (editorTmp0),y
	iny
	cpy #stepsPerPhrase * bytesPerPhraseStep
	bcc :-
	
	lda #$01
	sta editorForceTrackLoad
		
	jsr editorCheckUpdatePhrases
	jsr editorDecodeTriggerParameters
	ldx cursorY_grid
	lda @trackProcs,x
	jsr addProcessToBuffer
	jsr editorPrintTriggers
	rts	

;All pattern
:	lda #WRAM_PATTERNS
	jsr setMMC1r1
	
	ldx editorCurrentPattern
	lda patternTableLo,x
	sta editorTmp0
	lda patternTableHi,x
	sta editorTmp1
	
	ldy #$00
:	lda editCopyBuffer+1,y
	sta (editorTmp0),y
	sta editorTrackDrum,y
	iny
	cpy #bytesPerPattern
	bcc :-
		
	ldx editorCurrentPattern
	lda editCopyBuffer+1,y
	sta songEchoSelect,x
	iny
	lda editCopyBuffer+1,y
	sta songEchoLevelA,x
	iny
	lda editCopyBuffer+1,y
	sta songEchoLevelB,x
	iny
	lda editCopyBuffer+1,y
	sta songEchoLevelD,x
	iny
	lda editCopyBuffer+1,y
	sta songEchoDecay,x
	iny
	lda editCopyBuffer+1,y
	sta songEchoSpeed,x
	
	ldx cursorY_grid
	lda editorTrackDrum,x
	sta editorCurrentDrum
	lda #$01
	sta doNotInterrupt
	jsr editorDecodeDrum
	jsr editorDecodeTrackDrums
	jsr editorPrintDrum
	lda #procTrackDrumAll
	jsr addProcessToBuffer
	jsr editorReprintPattern
	lda #$00
	sta doNotInterrupt
	rts

@trackProcs:	.BYTE procTrackDrum00,procTrackDrum01,procTrackDrum02
	.BYTE procTrackDrum03,procTrackDrum04,procTrackDrum05	

editorReprintPattern:	
	jsr editorDecodePatternInfo
	lda #procGridPattern
	jsr addProcessToBuffer
	
	lda #$00
	jsr editorDecodePhrase
	lda #$01
	jsr editorDecodePhrase
	lda #$02
	jsr editorDecodePhrase
	lda #$03
	jsr editorDecodePhrase
	lda #$04
	jsr editorDecodePhrase
	lda #$05
	jsr editorDecodePhrase
	
	lda cursorY_grid
	jsr editorDecodeTrackDrum
	jsr editorDecodeTriggerParameters
	
	ldx #$00
	jsr editorPrintTrack
	ldx #$01
	jsr editorPrintTrack
	ldx #$02
	jsr editorPrintTrack
	ldx #$03
	jsr editorPrintTrack
	ldx #$04
	jsr editorPrintTrack
	ldx #$05
	
	jsr editorPrintTrack
	ldx cursorY_grid
	lda @trackProcs,x
	jsr addProcessToBuffer
	ldx cursorY_grid
	jsr editorPrintTriggers
	rts

@trackProcs:	.BYTE procTrackDrum00,procTrackDrum01,procTrackDrum02
	.BYTE procTrackDrum03,procTrackDrum04,procTrackDrum05	

editorDecodePatternInfo:
	ldx #$00
	lda editorCurrentPattern
	jsr @phex
	lda editorPatternSpeed
	jsr @phex
	ldy editorPatternGroove
	lda @swingTable,y
	jsr @phex
	lda editorPatternSteps
	
@phex:	pha
	lsr a
	lsr a
	lsr a
	lsr a
	sta scnGridPatternBuffer,x
	inx
	pla
	and #$0F
	sta scnGridPatternBuffer,x
	inx
	rts
	
@swingTable:	.BYTE $00,$25,$50,$75
	
editorCutDrum:
	jsr editorCopyDrum
	jsr editorClearDrum
	jsr editorDecodeDrum
	jsr editorDecodeTrackDrums
	jsr editorPrintDrum
	lda #procTrackDrumAll
	jsr addProcessToBuffer
	rts

editorCopyDrum:
	lda #WRAM_DRUMS
	jsr setMMC1r1
	ldx editorCurrentDrum
	lda drumAddressLo,x
	sta editorTmp0
	lda drumAddressHi,x
	sta editorTmp1
	lda #COPY_ID_DRUM
	sta editCopyBuffer
	ldy #$00
:	lda (editorTmp0),y
	sta editCopyBuffer+1,y
	iny
	cpy #bytesPerDrum
	bcc :-
	lda editorCurrentDrum
	ldx #MSG_DRM_COPY
	jsr editorSetCopyInfoMessage	
	rts
	
editorPasteDrum:
	lda #WRAM_DRUMS
	jsr setMMC1r1
	lda editCopyBuffer
	cmp #COPY_ID_DRUM
	beq :+
	rts		;error

:	ldx editorCurrentDrum
	lda drumAddressLo,x
	sta editorTmp0
	lda drumAddressHi,x
	sta editorTmp1
	
	ldy #$00
:	lda editCopyBuffer+1,y
	sta (editorTmp0),y
	iny
	cpy #bytesPerDrum
	bcc :-
	jsr editorDecodeDrum
	jsr editorDecodeTrackDrums
	
	jsr editorPrintDrum
	lda #procTrackDrumAll
	jsr addProcessToBuffer
	rts
	
editorClearDrum:
	lda #WRAM_DRUMS
	jsr setMMC1r1
	
	ldx editorCurrentDrum
	lda drumAddressLo,x
	sta editorTmp0
	lda drumAddressHi,x
	sta editorTmp1
	ldy #$00
:	lda EMPTY_DRUM_DEFINITION,y
	sta (editorTmp0),y
	iny
	cpy #bytesPerDrum
	bcc :-
	rts



_editMenuX	= 3	
editorShowEditMenu:
	lda editMenuActive
	bne editorClearEditMenu
	
	lda editMenuLo,x
	sta editorTmp0
	lda editMenuHi,x
	sta editorTmp1
	lda #<(scnGridBuffer+_editMenuX)
	sta editorTmp2
	lda #>(scnGridBuffer+_editMenuX)
	sta editorTmp3
	
	ldx #6
:	ldy #$00
:	lda (editorTmp0),y
	sta (editorTmp2),y
	iny
	cpy #11
	bcc :-
	lda editorTmp0
	clc
	adc #11
	sta editorTmp0
	lda editorTmp1
	adc #$00
	sta editorTmp1
	lda editorTmp2
	clc
	adc #$10
	sta editorTmp2
	lda editorTmp3
	adc #$00
	sta editorTmp3
	dex
	bne :--
	
	lda #$01
	sta editMenuActive
	lda #procGridRow00
	jsr addProcessToBuffer
	lda #procGridRow01
	jsr addProcessToBuffer
	lda #procGridRow02
	jsr addProcessToBuffer
	lda #procGridRow03
	jsr addProcessToBuffer
	lda #procGridRow04
	jsr addProcessToBuffer
	lda #procGridRow05
	jsr addProcessToBuffer
	rts
	
editorClearEditMenu:
	lda #$00
	sta editMenuActive
	jsr editorDecodePhrase
	lda #$01
	jsr editorDecodePhrase
	lda #$02
	jsr editorDecodePhrase
	lda #$03
	jsr editorDecodePhrase
	lda #$04
	jsr editorDecodePhrase
	lda #$05
	jsr editorDecodePhrase
	lda #procGridRow05
	jsr addProcessToBuffer
	lda #procGridRow04
	jsr addProcessToBuffer
	lda #procGridRow03
	jsr addProcessToBuffer
	lda #procGridRow02
	jsr addProcessToBuffer
	lda #procGridRow01
	jsr addProcessToBuffer
	lda #procGridRow00
	jsr addProcessToBuffer
	rts

GRID_PATTERN_NUMBER_X = (11*8)+3
GRID_PATTERN_NUMBER_Y = (6*8)+2
	
editorEditPatternNumber:
	jsr checkRepeatKeyA
	jsr checkRepeatKeyB
	jsr checkRepeatKeyUD
	jsr checkRepeatKeyLR

	lda #$02
	sta editorCursorMode

	lda editorWaitForClone
	beq :+++++
	lda editorPatternForClone
	bne :++
	jsr editorFindClonePattern
	bcc :+
	lda #$00		;print error
	sta editorWaitForClone
	ldx #MSG_CLONE_ERROR
	lda #$60
	jsr editorSetErrorMessage
:	jmp @x

:	lda editorFoundEmpty
	bne :+
	jsr editorFindEmptyPattern
	bcc :++
	lda #$00
	sta editorWaitForClone	;error
	ldx #MSG_CLONE_ERROR
	lda #$60
	jsr editorSetErrorMessage
	jmp @x
:	jsr editorClonePattern
	lda #$00
	sta editorWaitForClone
	lda editorCurrentPattern
	jsr editorSelectPattern
	lda #$01
	sta doNotInterrupt
	ldx cursorY_grid
	lda editorTrackDrum,x
	sta editorCurrentDrum
	jsr editorDecodeDrum
	jsr editorDecodeTrackDrums
	jsr editorReprintPattern
	lda #procTrackDrumAll
	jsr addProcessToBuffer
	jsr editorPrintDrum
	lda #$00
	sta doNotInterrupt
:	jmp @x
	
	
:	ldx editPatternInfoSubMode
	lda editorWaitForAB
	beq :+
	jmp @keyWaitAB

:	jsr _holdSelect_tapDown
	bcc :+

	ldx #EDIT_GRID_MENU
	jsr editorShowEditMenu
	lda editorMode
	sta editorModeBeforeMenu
	lda #EDIT_MODE_GRID_MENU
	sta editorMode
	jmp @x	
	
	
:	lda keyRepeatB		
	beq :++++++
	lda keyReleaseA
	beq :+
	lda #$00		;hold B, tap A = Pattern Clone
	sta editorPatternForClone
	sta editorFoundEmpty
	lda #$07
	sta editorSongToCheck
	lda #$01
	sta editorWaitForClone
	jsr editClearPatternUsedTable
	jmp @x
	
:	lda PAD1_dud		;hold B, move around = change editor mode
	beq :++
	bmi :+
	lda previousEditorMode
	sta editorMode
	jmp @x
:	lda #EDIT_MODE_SONG
	sta editorMode
	jmp @x
:	lda PAD1_dlr
	beq :+
	bpl :++
	lda #EDIT_MODE_TRACK
	sta editorMode
:	jmp @x
:	lda #EDIT_MODE_TRIGGER_PARAMETER
	sta editorMode
	jmp @x
	
:	lda keyRepeatA		;hold A = modify value
	bne :+
	jmp :++++++++++
:	lda #$01
	sta editorEditingValue
	lda PAD1_dlr
	ora keyRepeatLR
	ora PAD1_dud
	beq :++
	cpx #$01
	bcs :+++++
	swapSign PAD1_dud
	lda PAD1_dud
	asl a
	asl a
	asl a
	asl a
	sta editorTmp2
	lda PAD1_dlr
	clc
	adc editorCurrentPattern	;change pattern number
	clc
	adc editorTmp2
	sta editorTmp3
	bmi :+++
	lda editorCurrentPattern
	bpl :+
	cmp #128+16
	bcs :++++
:	lda editorTmp3
	sta editorCurrentPattern
	
	ldx #$01
	stx doNotInterrupt
	jsr editorSelectPattern
	ldx cursorY_grid
	lda editorTrackDrum,x
	sta editorCurrentDrum
	;jsr editorDecodeDrum
	jsr editorDecodeTrackDrums
	jsr editorReprintPattern
	lda #procTrackDrumAll
	jsr addProcessToBuffer
	;jsr editorPrintDrum
	lda #$00
	sta doNotInterrupt
:	jmp @x
	
:	lda editorCurrentPattern
	bmi :---
	cmp #127-16
	bcs :---
:	
	jmp @x
	
:	cpx #$03
	bcc :+
	clc
	adc editorPatternSpeed-1,x
	beq :+++
	cmp @speedGrooveLimit,x
	bcs :+++
	bcc :++
:	clc
	adc editorPatternSpeed-1,x
	bmi :++
	cmp @speedGrooveLimit,x
	bcs :++
:	sta editorPatternSpeed-1,x
	
	jsr editorDecodePatternInfo
	lda #procGridPattern
	jsr addProcessToBuffer
:	jmp @x
	
:	lda editorEditingValue	;A released, write value
	beq :+
	dec editorEditingValue

	lda editorCurrentPattern
	sta plyrNextPattern

	ldx editorCurrentPattern
	lda patternTableLo,x
	sta editorTmp0
	lda patternTableHi,x
	sta editorTmp1
	lda #WRAM_PATTERNS
	jsr setMMC1r1
	ldy #PATTERN_SPEED
	lda editorPatternSpeed
	sta (editorTmp0),y
	iny
	lda editorPatternGroove
	sta (editorTmp0),y
	iny
	lda editorPatternSteps
	sta (editorTmp0),y

	jmp @x
	
:	lda keyRepeatSelect
	beq :++++
	lda PAD1_dud
	beq :++++
	bmi :+
	;edit menu
	ldx #EDIT_GRID_MENU
	jsr editorShowEditMenu
	lda editorMode
	sta editorModeBeforeMenu
	lda #EDIT_MODE_GRID_MENU
	sta editorMode
	jmp @x
:	lda editCopyBuffer
	beq :++
	cmp #COPY_ID_PHRASE
	beq :+
	cmp #COPY_ID_PATTERN
	bne :++
:	ldx #MSG_PASTE
	jsr editorSetConfirmMessage
	lda #$01
	sta editorWaitForAB
	;jsr editorPasteGrid
:	jmp @x		

:	lda PAD1_dlr
	beq :+
	txa
	clc
	adc PAD1_dlr
	bmi :+
	cmp #$04
	bcs :+
	sta editPatternInfoSubMode
	tax
:

@x:	
	ldx editPatternInfoSubMode
	lda #GRID_PATTERN_NUMBER_X
	clc
	adc @xOffsets,x
	sta editorCursorX
	lda #GRID_PATTERN_NUMBER_Y
	clc
	adc @yOffsets,x
	sta editorCursorY
	jsr editorUpdateCursor
	rts
	
@xOffsets:	.BYTE 0*8, 5*8, 10*8, 15*8
@yOffsets:	.BYTE 0,0,0
@speedGrooveLimit:
	.BYTE 0 ;dummy
	.BYTE 30,4,17

@keyWaitAB:
	lda editorWaitForAB
	beq :++
	lda keyReleaseB
	bne :+
	lda keyReleaseA
	beq :++
	jsr editorPasteGrid
:	lda #$01
	sta editorCopyInfoTimer
	lda #$00
	sta editorWaitForAB
:	rts


editorWipeAll:
	
	lda #$01
	sta doNotInterrupt
	
	jsr editorWipeSongs
	jsr editorWipePatterns
	jsr editorWipePhrases
	jsr editorWipeDrums

	lda #$FF
	sta dmaProcessBuffer

	jsr editorInit2
	
	lda #$00
	sta doNotInterrupt
	rts
	

menuWipeSongs:	lda #$01
	sta doNotInterrupt
	jsr editorWipeSongs
	lda #$FF
	sta dmaProcessBuffer
	jsr editorInit2
	lda #$00
	sta doNotInterrupt
	rts
	
editorWipeSongs:
	ldx #$00
:	jsr editorWipeSong
	inx
	cpx #numberOfSongs
	bcc :-
	rts
	
editorWipeSong:
	lda #WRAM_SONGS
	jsr setMMC1r1
	lda songTableLo,x
	sta editorTmp0
	lda songTableHi,x
	sta editorTmp1
	ldy #$00
	tya
:	sta (editorTmp0),y
	iny
	bne :-
	lda #$00
	sta songLoopStartTable,x
	lda #$01
	sta songLoopLengthTable,x
	lda #$FF
	sta songSpeedTable,x
	sta songSwingTable,x
	rts

menuWipePhrases:
	lda #$01
	sta doNotInterrupt
	jsr editorWipePhrases
	lda #$FF
	sta dmaProcessBuffer
	jsr editorInit2
	lda #$00
	sta doNotInterrupt
	rts
	
editorWipePhrases:
	ldx #$00
:	lda phraseBanks,x
	jsr setMMC1r1
	lda phraseTableLo,x
	sta editorTmp0
	lda phraseTableHi,x
	sta editorTmp1
	ldy #$00
	lda #$00
:	sta (editorTmp0),y
	iny
	cpy #stepsPerPhrase * bytesPerPhraseStep
	bcc :-
	inx
	cpx #numberOfPhrases
	bcc :--
	rts

menuWipePatterns:
	lda #$01
	sta doNotInterrupt
	jsr editorWipePatterns
	lda #$FF
	sta dmaProcessBuffer
	jsr editorInit2
	lda #$00
	sta doNotInterrupt
	rts
		
editorWipePatterns:
	lda #WRAM_PATTERNS
	jsr setMMC1r1

	ldx #$00
:	lda patternTableLo,x
	sta editorTmp0
	lda patternTableHi,x
	sta editorTmp1

	ldy #$00
:	lda @blankPattern,y
	sta (editorTmp0),y
	iny
	cpy #bytesPerPattern
	bcc :-
	
	lda #INIT_ECHO_SELECT
	sta songEchoSelect,x
	lda #INIT_ECHO_LEVEL
	sta songEchoLevelA,x
	sta songEchoLevelB,x
	sta songEchoLevelD,x
	lda #INIT_ECHO_DECAY
	sta songEchoDecay,x
	lda #INIT_ECHO_SPEED
	sta songEchoSpeed,x
	
	inx
	;cpx #numberOfPatterns-1
	;bcc :--
	bne :--
	rts

@blankPattern:	.BYTE $00,$00,$00,$00,$00,$00	;drums
	.BYTE $00,$00,$00,$00,$00,$00	;phrases
	.BYTE $0C,$00		;speed, swing
	.BYTE $10		;steps
	.BYTE $00

menuWipeDrums:	lda #$01
	sta doNotInterrupt
	jsr editorWipeDrums
	lda #$FF
	sta dmaProcessBuffer
	jsr editorInit2
	lda #$00
	sta doNotInterrupt
	rts
	
editorWipeDrums:
	lda #WRAM_DRUMS
	jsr setMMC1r1
	
	ldx editorCurrentDrum
:	lda drumAddressLo,x
	sta editorTmp0
	lda drumAddressHi,x
	sta editorTmp1
	ldy #$00
:	lda EMPTY_DRUM_DEFINITION,y
	sta (editorTmp0),y
	iny
	cpy #bytesPerDrum
	bcc :-
	inx
	cpx #numberOfDrums
	bcc :--
	rts
	
	
EMPTY_DRUM_DEFINITION:
@oscA:	.BYTE $00,$00,$00
@lfoA:	.BYTE $00,$00,$00
@envA:	.BYTE $8F,$08,$08
@dtyA:	.BYTE $00,$00

@oscB:	.BYTE $00,$00,$00
@lfoB:	.BYTE $00,$00,$00
@envB:	.BYTE $8F,$08,$08
@dtyB:	.BYTE $00,$00

@oscC:	.BYTE $00,$00
@lfoC:	.BYTE $00,$00,$00
@envC:	.BYTE $00,$10

@oscD:	.BYTE $50
@lfoD:	.BYTE $00,$00,$00
@envD:	.BYTE $8F,$08,$08

@esm:	.BYTE $00
@est:	.BYTE $00
@een:	.BYTE $00
@ept:	.BYTE $5F
@elp:	.BYTE $00

@name:	.BYTE $0D,$04,$16

@seq:	.BYTE $80,$80,$80

@gbl:	.BYTE %00000000


offset = $30

editorDecodeSong:
	lda #WRAM_SONGS
	jsr setMMC1r1
	ldx editorCurrentSong
	;lda songLoopStartTable,x
	lda editorSongLoopStartTemp
	sta editorTmp2
	clc
	;adc songLoopLengthTable,x
	adc editorSongLoopLengthTemp
	sta editorTmp3
	
	lda songTableLo,x
	sta editorTmp0
	lda songTableHi,x
	sta editorTmp1
	txa
	tay
	ldx #$00
	jsr @printHex
	;lda songSpeedTable,y
	lda editorSongSpeedTemp
	jsr @printBlankSpeed
	;lda songSwingTable,y
	lda editorSongSwingTemp
	jsr @printBlankSwing
	;lda songLoopStartTable,y
	lda editorSongLoopStartTemp
	jsr @printHex
	;lda songLoopLengthTable,y
	lda editorSongLoopLengthTemp
	jsr @printBlankLoop
	lda editorSongBar
	tay
	
	lda editorSongBar
	cmp editorTmp2
	bcc :+
	
	lda editorTmp3
	cmp editorSongBar
	beq :+
	bcc :+
	
	tya
	jsr @printTest
	jmp :++
	
:	tya
	jsr @printHex
	
:	lda (editorTmp0),y
	jsr @printHex
	rts

@printTest:	pha
	lsr a
	lsr a
	lsr a
	lsr a
	clc
	adc #offset
	sta scnSongBuffer,x
	inx
	pla
	and #$0F
	clc
	adc #offset
	sta scnSongBuffer,x
	inx
	rts

@printHex:	pha
	lsr a
	lsr a
	lsr a
	lsr a
	sta scnSongBuffer,x
	inx
	pla
	and #$0F
	sta scnSongBuffer,x
	inx
	rts
	
@printBlankSpeed:
	cmp #$FF
	bne @printHex
	lda #$2C
	sta scnSongBuffer,x
	inx
	sta scnSongBuffer,x
	inx
	rts

@printBlankLoop:
	cmp #$00
	bne @printHex
	lda #$2C
	sta scnSongBuffer,x
	inx
	sta scnSongBuffer,x
	inx
	rts

@printBlankSwing:
	cmp #$FF
	bne :+
	lda #$2C
	sta scnSongBuffer,x
	inx
	sta scnSongBuffer,x
	inx
	rts
:	cmp #$00
	bne :+
	lda #$00
	jmp @printHex
:	cmp #$01
	bne :+
	lda #$25
	jmp @printHex
:	cmp #$02
	bne :+
	lda #$50
	jmp @printHex
:	lda #$75
	jmp @printHex
	
	

SONG_CURSOR_X_BASE = -5
SONG_CURSOR_Y_BASE = -6

editorSong:
	jsr checkRepeatKeyA
	jsr checkRepeatKeyB
	jsr checkRepeatKeyUD
	jsr checkRepeatKeyLR
	
	lda #WRAM_SONGS
	jsr setMMC1r1
	ldx editorCurrentSong
	lda songTableLo,x
	sta editorTmp0
	lda songTableHi,x
	sta editorTmp1
	
	lda #$02
	sta editorCursorMode
	ldx editSongIndex

	lda keyReleaseSelect	;tapping SELECT in Song will take you to Grid and load Pattern on current Bar
	beq :+
	ldy editorSongBar
	lda (editorTmp0),y
	sta editorCurrentPattern
	jsr editorSelectPattern
	lda #$01
	sta doNotInterrupt
	ldx cursorY_grid
	lda editorTrackDrum,x
	sta editorCurrentDrum
	jsr editorDecodeDrum
	jsr editorDecodeTrackDrums
	jsr editorReprintPattern
	lda #procTrackDrumAll
	jsr addProcessToBuffer
	jsr editorPrintDrum
	lda #$00
	sta doNotInterrupt
	lda #EDIT_MODE_GRID
	sta editorMode
	jmp @x
:	

	lda keyRepeatA		;handle INS/DEL bars
	beq :+++
	lda keyRepeatB
	beq :+++
	cpx #$04
	beq :+
	cpx #$05
	bne :+++
:	lda PAD1_dlr
	beq :++
	bmi :+
	jmp editorInsertSongBar	
:	jmp editorRemoveSongBar

:
	lda keyReleaseA
	beq :++
	ldx editSongIndex
	cpx #$05
	bne :+
	ldy editorSongBar
	lda editorSongLastPattern
	sta (editorTmp0),y
	jsr editorDecodeSong
	lda #procSongBar
	jsr addProcessToBuffer	
:	jmp @x

:	lda keyRepeatSelect
	beq :+++
	lda PAD1_dud
	beq :+++
	bmi :++
	lda PAD1_fireb
	beq :+
	
	ldx #EDIT_CLEAR_MENU
	jsr editorShowEditMenu
	lda editorMode
	sta editorModeBeforeMenu
	lda #EDIT_MODE_CLEAR_MENU
	sta editorMode
	jmp @x
	
	;edit menu
:	ldx #EDIT_SONG_MENU
	jsr editorShowEditMenu
	lda editorMode
	sta editorModeBeforeMenu
	lda #EDIT_MODE_SONG_MENU
	sta editorMode
	jmp @x
:	;jsr editorPasteDrum
	;ldx #MSG_PASTE
	;jsr editorSetConfirmMessage
	;lda #$01
	;sta editorWaitForAB
	jmp @x	

:	lda keyRepeatB
	beq :+++
	lda PAD1_dud
	beq :+
	bmi :++
	lda #EDIT_MODE_PATTERN_NUMBER
	sta editorMode
	jmp @x
:	lda #$00
	sta editorTmp2
	lda PAD1_dlr
	ora keyRepeatLR
	beq :+
	ldx editSongMode
	cpx #SONG_MODE_REC
	bne :+
	;ldx editSongIndex
	;cpx #$04
	;beq :+++
	jmp @editBarEntry
:	jmp @x

:	lda keyReleaseB
	beq :+
	cpx #$07
	bne :+
	ldx editSongMode
	cpx #SONG_MODE_REC
	bne :+
	ldx editorCurrentSong
	;lda songLoopLengthTable,x
	lda editorSongLoopLengthTemp
	pha
	lda editorLastSongLoop
	sta songLoopLengthTable,x
	sta editorSongLoopLengthTemp
	pla
	sta editorLastSongLoop
	jsr editorDecodeSong
	lda #procSongLoop
	jsr addProcessToBuffer
	jmp @x
		
:	lda keyRepeatA
	beq :++++++++
	lda #$01
	sta editorEditingValue
	
	swapSign keyRepeatUD
	swapSign PAD1_dud
	
	lda keyRepeatUD
	ora PAD1_dud
	asl a
	asl a
	asl a
	asl a
	sta editorTmp2
	ora keyRepeatLR
	ora PAD1_dlr
	beq :---
	
	ldx editSongIndex
	cpx #$00
	bne :+
	jmp @editSongMode
:	cpx #$01
	bne :+
	jmp @editSongNumber
:	cpx #$02
	bne :+
	jmp @editSongSpeed
:	cpx #$03
	bne :+
	jmp @editSongSwing
:	cpx #$04
	bne :+
	jmp @editSongBar
:	cpx #$05
	bne :+
	jmp @editSongPattern
:	cpx #$06
	bne :+
	jmp @editSongLoopStart
:	jmp @editSongLoopLength
	
:	lda editorEditingValue
	beq :+
	lda #$00
	sta editorEditingValue
	jsr @writeSongValue
	jmp @x

:	lda PAD1_dud
	beq :++
:	clc
	adc editSongIndex
	bmi :+++
	cmp #$08
	bcs :+++
	sta editSongIndex
	tax
	jmp @x

:	lda PAD1_dlr
	beq :++
	bmi :+
	lda @deltaRight,x
	bpl :--
:	lda @deltaLeft,x
	bmi :---
:		
@x:	ldx editSongIndex
	lda #SONG_CURSOR_X_BASE
	clc
	adc @cursorX,x
	sta editorCursorX
	lda #SONG_CURSOR_Y_BASE
	clc
	adc @cursorY,x
	sta editorCursorY
	jsr editorUpdateCursor	
	rts

@writeSongValue:
	cpx #$00
	bne :+
	rts
:	cpx #$01
	bne :+
	jmp @writeSongNumber
:	cpx #$02
	bne :+
	jmp @writeSongSpeed
:	cpx #$03
	bne :+
	jmp @writeSongSwing
:	cpx #$04
	bne :+
	rts		;song bar, don't do
:	cpx #$05
	bne :+
	rts ;jmp @writeSongPattern
:	cpx #$06
	bne :+
	jmp @writeSongLoopStart
:	jmp @writeSongLoopLength

@writeSongNumber:
	lda #$FF
	sta plyrSongBar
	lda editorCurrentSong
	sta plyrCurrentSong
	jsr editorSelectSong
	rts

;@writeSongPattern:
;	ldx editorCurrentSong
;	lda songTableLo,x
;	sta editorTmp0
;	lda songTableHi,x
;	sta editorTmp1
;	ldy editorSongBar
;	lda editorEditingBuffer
;	sta (editorTmp0),y
;	rts

@writeSongSpeed:
	ldx editorCurrentSong
	lda editorSongSpeedTemp
	sta songSpeedTable,x
	rts

@writeSongSwing:
	ldx editorCurrentSong
	lda editorSongSwingTemp
	sta songSwingTable,x
	rts

@writeSongLoopStart:
	ldx editorCurrentSong
	lda editorSongLoopStartTemp
	sta songLoopStartTable,x
	rts

@writeSongLoopLength:
	ldx editorCurrentSong
	lda editorSongLoopLengthTemp
	sta songLoopLengthTable,x
	rts

	
@editSongMode:
	lda PAD1_dlr
	beq :++
	bpl :+
	lda #SONG_MODE_OFF
	bpl :+++
:	lda #SONG_MODE_PLY
	bpl :++
:	lda PAD1_dud
	beq :++
	bmi :++
	lda #SONG_MODE_REC
:	sta editSongMode
	tax
	lda @infoMode,x
	tax
	jsr editorSetPlayBackMessage
	lda #procCopyInfoAll
	jsr addProcessToBuffer
	
	lda editSongMode
	cmp #SONG_MODE_OFF
	bne :+
	lda editorCurrentPattern
	sta plyrNextPattern
	lda #$00
	sta editorLastSongLoop
	
	
:	rts

@infoMode:	.BYTE MSG_PTRN,MSG_SONG,MSG_SONG

@editSongNumber:
	lda PAD1_dlr
	beq :+
	clc
	adc editorCurrentSong
	bmi :+
	cmp #numberOfSongs
	bcs :+
	sta editorCurrentSong

	;sta plyrCurrentSong
	;jsr editorSelectSong	
	;lda #$FF
	;sta plyrSongBar

	jsr editorDecodeSong
	lda #procSongAll
	jsr addProcessToBuffer
:	rts

	
@editSongSpeed:
	lda editSongMode
	cmp #SONG_MODE_REC
	beq :+
	rts
	
:	ldx editorCurrentSong
	lda PAD1_dlr
	ora keyRepeatLR
	clc
	;adc songSpeedTable,x
	adc editorSongSpeedTemp
	clc
	adc editorTmp2
	bpl :+
	lda #$FF
	bmi :++
:	cmp #numberOfSpeeds
	bcs :++
:	;sta songSpeedTable,x
	sta editorSongSpeedTemp
	jsr editorDecodeSong
	lda #procSongSpeed
	jsr addProcessToBuffer
:	rts


@editSongSwing:
	lda editSongMode
	cmp #SONG_MODE_REC
	beq :+
	rts
	
:	ldx editorCurrentSong
	lda PAD1_dlr
	ora keyRepeatLR
	clc
	;adc songSwingTable,x
	adc editorSongSwingTemp
	clc
	adc editorTmp2
	bpl :+
	lda #$FF
	bmi :++
:	cmp #$04
	bcs :++
:	;sta songSwingTable,x
	sta editorSongSwingTemp
	jsr editorDecodeSong
	lda #procSongSpeed
	jsr addProcessToBuffer
:	rts

@editSongBar:	
	lda editSongMode
	cmp #SONG_MODE_REC
	beq :+
	rts
	
:	lda PAD1_dlr
	ora keyRepeatLR

@editBarEntry:	clc
	adc editorSongBar
	clc
	adc editorTmp2
	sta editorTmp3

	bmi :++
	lda editorSongBar
	bpl :+
	cmp #128+16
	bcs :+++
:	lda editorTmp3
	sta editorSongBar
	tay
	ldx editorCurrentSong
	lda songTableLo,x
	sta editorTmp0
	lda songTableHi,x
	sta editorTmp0
	lda (editorTmp0),y
	sta plyrNextPattern	
	jsr editorDecodeSong
	lda #procSongBar
	jsr addProcessToBuffer
	
	rts
	
:	lda editorSongBar
	bmi :--
	cmp #127-16
	bcs :--
:	
	rts

@editSongPattern:
	lda editSongMode
	cmp #SONG_MODE_REC
	beq :+
	rts
:	
	lda #WRAM_SONGS
	jsr setMMC1r1
	
	ldx editorCurrentSong
	lda songTableLo,x
	sta editorTmp0
	lda songTableHi,x
	sta editorTmp1
	
	ldy editorSongBar
	
	lda PAD1_dlr
	ora keyRepeatLR
	clc
	adc (editorTmp0),y
	clc
	adc editorTmp2
	sta editorTmp3

	bmi :++
	lda (editorTmp0),y
	bpl :+
	cmp #128+16
	bcs :+++
:	lda editorTmp3
	sta (editorTmp0),y
	sta editorSongLastPattern
	jsr editorDecodeSong
	lda #procSongBar
	jsr addProcessToBuffer
	rts
	
:	lda (editorTmp0),y
	bmi :--
	cmp #127-16
	bcs :--
:	
	rts
	
@editSongLoopStart:
	lda editSongMode
	cmp #SONG_MODE_REC
	beq :+
	rts
:	ldx editorCurrentSong	
	lda PAD1_dlr
	ora keyRepeatLR
	clc
	;adc songLoopStartTable,x
	adc editorSongLoopStartTemp
	clc
	adc editorTmp2
	sta editorTmp3

	bmi :++		;a
	;lda songLoopStartTable,x
	lda editorSongLoopStartTemp
	bpl :+		;b
	cmp #128+16
	bcs :+++		;c
:	lda editorTmp3		;b
	clc
	;adc songLoopLengthTable,x
	adc editorSongLoopLengthTemp
	bcs :++
	lda editorTmp3
	;sta songLoopStartTable,x
	sta editorSongLoopStartTemp
	jsr editorDecodeSong
	lda #procSongLoop
	jsr addProcessToBuffer
	lda #procSongBar
	jsr addProcessToBuffer
	rts
	
:	;lda songLoopStartTable,x	;a
	lda editorSongLoopStartTemp
	bmi :--
	cmp #127-16
	bcs :--
:			;c
	rts
	
@editSongLoopLength:
	lda editSongMode
	cmp #SONG_MODE_REC
	beq :+
	rts
:	ldx editorCurrentSong	
	lda PAD1_dlr
	ora keyRepeatLR
	clc
	;adc songLoopLengthTable,x
	adc editorSongLoopLengthTemp
	clc
	adc editorTmp2
	sta editorTmp3

	bmi :++		;a
	;lda songLoopLengthTable,x
	lda editorSongLoopLengthTemp
	bpl :+		;b
	cmp #128+16
	bcs :+++		;c
:	lda editorTmp3		;b
	clc
	;adc songLoopStartTable,x
	adc editorSongLoopStartTemp
	bcs :++
	lda editorTmp3
	;sta songLoopLengthTable,x	;d
	sta editorSongLoopLengthTemp
	jsr editorDecodeSong
	lda #procSongLoop
	jsr addProcessToBuffer
	lda #procSongBar
	jsr addProcessToBuffer
	rts
	
:	;lda songLoopLengthTable,x	;a
	lda editorSongLoopLengthTemp
	bmi :--
	cmp #127-16
	bcs :--
:			;c
	rts
	
@cursorX:	.BYTE 13*8,13*8,18*8,18*8,23*8,23*8,28*8,28*8
@cursorY:	.BYTE 4*8,5*8,4*8,5*8,4*8,5*8,4*8,5*8

@deltaRight:
	.BYTE $02,$02,$02,$02,$02,$02,$02,$02
@deltaLeft:
	.BYTE $FE,$FE,$FE,$FE,$FE,$FE,$FE,$FE


editorClonePhrase:
	ldx cursorY_grid
	lda editorTrackPhrase,x
	tax
	lda phraseBanks,x
	jsr setMMC1r1
	lda phraseTableLo,x
	sta editorTmp0
	lda phraseTableHi,x
	sta editorTmp1
	ldy #$00
:	lda (editorTmp0),y
	sta editCopyBuffer+1,y
	iny
	cpy #stepsPerPhrase * bytesPerPhraseStep
	bcc :-
	lda #$00
	sta editCopyBuffer
	
	ldx editorPhraseForClone
	lda phraseBanks,x
	jsr setMMC1r1
	lda phraseTableLo,x
	sta editorTmp0
	lda phraseTableHi,x
	sta editorTmp1
	ldy #$00
:	lda editCopyBuffer+1,y
	sta (editorTmp0),y
	iny
	cpy #stepsPerPhrase * bytesPerPhraseStep
	bcc :-
	
	ldx editorCurrentPattern
	lda patternTableLo,x
	sta editorTmp0
	lda patternTableHi,x
	sta editorTmp1
	lda #WRAM_PATTERNS
	jsr setMMC1r1
	lda #PATTERN_PHRASE_0
	clc
	adc cursorY_grid
	tay
	lda editorPhraseForClone
	sta (editorTmp0),y
	sta editorTrackPhrase-6,y
	
	lda cursorY_grid
	jsr editorDecodePhrase
	lda cursorY_grid
	jsr editorDecodeTrackDrum
	ldx cursorY_grid	
	jsr editorDecodeTriggerParameters
	
	ldx cursorY_grid
	lda @trackProcs,x
	jsr addProcessToBuffer
	ldx cursorY_grid
	lda @phraseProcs,x
	jsr addProcessToBuffer
	lda #procTrigger
	jsr addProcessToBuffer
	rts

@phraseProcs:	.BYTE procGridRow00,procGridRow01,procGridRow02
	.BYTE procGridRow03,procGridRow04,procGridRow05

@trackProcs:	.BYTE procTrackDrum00,procTrackDrum01,procTrackDrum02
	.BYTE procTrackDrum03,procTrackDrum04,procTrackDrum05
editorDrumNameTranslate:
	.BYTE $10,$11,$12,$13,$14,$15,$16,$17,$18,$19,$1A,$1B,$1C
	.BYTE $1D,$1E,$1F,$20,$21,$22,$23,$24,$25,$26,$27,$28,$29
	.BYTE $00,$01,$02,$03,$04,$05,$06,$07,$08,$09,$2C
editorDrumNameTranslateEnd:
editorDrumNameTranslate2:
	.BYTE $40,$41,$42,$43,$44,$45,$46,$47,$48,$49,$4A,$4B,$4C
	.BYTE $4D,$4E,$4F,$50,$51,$52,$53,$54,$55,$56,$57,$58,$59
	.BYTE $30,$31,$32,$33,$34,$35,$36,$37,$38,$39,$3C

	.include "editMenus.asm"
	.include "keys.asm"
	.include "parameters.asm"