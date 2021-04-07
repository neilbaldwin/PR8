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

;	cmp #$FF                    ;BUG - allows Phrase to be set lower than 0
;	beq :++++                   ;      because max phrase number is 192 which is negative (8-bit signed)
;	cmp editorTmp2              ;      but Drum assignment only goes to 127 (positive)
;	bcs :++++

    cmp editorTmp2              ;BUG FIX - see comment above
    bcs :+++

	sta (editorTmp0),y
	sta editorTrackDrum,y
:	ldx cursorX_track	        ;editing drum or phrase number?
	bne :+++
	cmp editorCurrentDrum	    ;drum, has it changed?
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

	
@cursorY:
	.REPEAT rowsPerGrid,i
	.BYTE TRACK_CURSOR_Y_BASE + (i * 8)
	.ENDREPEAT
	.REPEAT rowsPerGrid,i
	.BYTE TRACK_CURSOR_Y_BASE + (i * 8)
	.ENDREPEAT
@cursorX:
	.REPEAT rowsPerGrid,i
	.BYTE TRACK_CURSOR_X_BASE + (1 * 8)
	.ENDREPEAT
	.REPEAT rowsPerGrid,i
	.BYTE TRACK_CURSOR_X_BASE + (4 *8)
	.ENDREPEAT

@trackProcs:
	.BYTE procTrackDrum00,procTrackDrum01,procTrackDrum02
	.BYTE procTrackDrum03,procTrackDrum04,procTrackDrum05
	
@phraseProcs:
	.BYTE procGridRow00,procGridRow01,procGridRow02
	.BYTE procGridRow03,procGridRow04,procGridRow05
