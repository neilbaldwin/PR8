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
	lda (editorTmp0),y                  ;if cell empty, insert fresh trigger or cycle current
	beq :+
	jmp :+++++++++++
	
:	lda editorTrackLastNote,x           ;tap A to insert trigger same as last
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
	
:	lda (editorTmp0),y          ;B tapped - clear or paste depending on cell contents
	beq :+		                ;if cell empty, try paste
	sty editorTmp2		        ;otherwise, copy to buffer and clear
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
	
	