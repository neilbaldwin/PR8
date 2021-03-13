;------------------------------------------------------------------------------
; Noise LFO
;------------------------------------------------------------------------------
	.MACRO noiseLFO _delay,_counter,_phase,_note,_delayCounter,_speed,_depth,_freqLo
	lda _delay		;if delay >=$80 then arpeggio
	bpl :+++++
	lda _counter		;time to change phase?
	beq :++
	dec _counter		;not yet
	
	lda _note		;get original pitch
	ldx _phase		;which phase?
	beq :+		;0, so use original pitch
	clc		;otherwise add _depth to original
	adc _depth
:	sta _freqLo
	rts
	
:	lda _phase
	bne :+
	lda _delayCounter
	beq :++
	dec _delayCounter
:	lda _speed
	sta _counter
	lda _phase
	eor #$01
	sta _phase
:	rts
	
	;LFO/SWEEP
:	lda _delayCounter
	beq :+
	dec _delayCounter
	rts
		
:	lda _counter
	beq :+
	dec _counter
	rts
	
:	lda _freqLo
	and #$10
	sta plyrTmp0
	lda _freqLo
	and #$0F
	clc
	adc _depth
	and #$0F
	ora plyrTmp0
	sta _freqLo
	lda _speed
	sta _counter
	rts
	.ENDMACRO

;------------------------------------------------------------------------------
; Pitch LFO
;------------------------------------------------------------------------------
	.MACRO pitchLFO _delay,_counter,_phase,_note,_delayCounter,_speed,_depth,_freqLo,_freqHi,_slide
	
	lda _slide
	bne :+++++++
	
	lda _delay		;if delay >+$80 then arpeggio
	bpl :+++++

	lda _counter		;time to change note?
	beq :++
	dec _counter		;no, update phase counter
	
	ldx _phase		;which note? if 0 then use original pitch
	lda _note	
	cpx #$00
	beq :+
	clc		;otherwise add arpeggio offset
	adc _note,x
:	tax
	lda periodLo,x
	sta _freqLo
	lda periodHi,x
	sta _freqHi
	rts
	
:	lda _phase		;arpeggio index change, reached end?
	cmp #$02
	bcc :+
	
	lda _delayCounter	;if arpeggio, lower 7 bits of delay = number of
	beq :++		; arpeggio cycles
	dec _delayCounter
:	lda _speed		;if cycle counter not done, reset phase counter
	sta _counter		;and reset note index
	inc _phase
	lda _phase
	sec
	sbc #$03
	bne :+
	sta _phase
:	rts

	;LFO/sweep
:	lda _delayCounter	;delay done?
	beq :+
	dec _delayCounter	;not yet, do nothing
	rts
	
:	lda _speed		;yes. if speed=0 then sweep, otherwise vibrato
	bne :+++
	
	lda _depth		;sweep
:	eor #$FF
	tax
	inx
	txa
	bpl :+
	clc
	adc _freqLo
	sta _freqLo
	lda _freqHi
	adc #$FF
	sta _freqHi
	rts

:	clc
	adc _freqLo
	sta _freqLo
	lda _freqHi
	adc #$00
	sta _freqHi
	rts
	
:	lda _phase		;vibrato
	and #$01
	beq :+
	
	lda _depth
	clc
	adc _freqLo
	sta _freqLo
	lda _freqHi
	adc #$00
	sta _freqHi
	dec _counter
	beq :++
	rts
	
:	lda _freqLo
	sec
	sbc _depth
	sta _freqLo
	lda _freqHi
	sbc #$00
	sta _freqHi
	dec _counter
	beq :+
	rts
	
:	lda _speed
	asl a
	sta _counter
	inc _phase
	rts
	.ENDMACRO


;------------------------------------------------------------------------------
; Amplitude Envelope
;------------------------------------------------------------------------------
	.MACRO ampEnvelope _phase,_env,_vol,_ampIndex,_counter,_gate
	lda _phase
	bne :+
	sta _ampIndex
	rts	
:	lsr a
	beq :+++++		;01 release
	bcc :+++		;10 hold

	lda _env		;11 attack
	and #$F0
	beq :++
	lda _vol
	and #$F0
	ora _ampIndex
	tax
	lda ampTable,x
	cmp #$0F
	beq :++
	lda _env
	and #$F0
	clc
	adc _counter
	sta _counter
	bcc :+
	inc _ampIndex
:	rts

:	lda #$0F
	sta _ampIndex
	dec _phase
	lda _gate
	sta _counter
	beq :++
	rts
	
:	dec _counter		;hold
	beq :+
	rts	
:	dec _phase
	lda _env
	and #$0F
	beq :+++
	rts
	
:	lda _vol
	and #$F0
	ora _ampIndex
	tax
	lda ampTable,x
	beq :++
	lda _env
	asl a
	asl a
	asl a
	asl a
	clc
	adc _counter
	sta _counter
	bcc :+
	dec _ampIndex
:	rts

:	sta _ampIndex
	sta _phase
	rts
	.ENDMACRO
	
;------------------------------------------------------------------------------
; Amp Envelope C
;------------------------------------------------------------------------------
	.MACRO ampEnvelopeC _gateTimer,_gate,_ampIndex,_phase,_pulse,_counter
	lda _gateTimer
	bne :+
	sta _ampIndex
	rts

:	dec _gateTimer
	lda _phase
	and #$01
	bne :+
	
	lda #$81
	sta _ampIndex
	lda _pulse
	and #$F0
	clc
	bcc :++
	
:	lda #$00
	sta _ampIndex
	lda _pulse
	asl a
	asl a
	asl a
	asl a
	clc

:	adc _counter
	sta _counter
	bcc :+
	inc _phase
:	rts
	.ENDMACRO
	
;------------------------------------------------------------------------------
; Duty Modulation
;------------------------------------------------------------------------------	
	.MACRO dutyMod _counter,_index,_widths,_width
	lda _counter
	beq :+
	dec _counter
	rts

:	lda _index
	and #$01
	tax
	lda _widths,x
	pha
	and #%11000000
	sta _width
	pla
	and #%00111111
	sta _counter
	beq :+
	inc _index
:	rts
	.ENDMACRO
	

	
;------------------------------------------------------------------------------
; Write VAPU A
;------------------------------------------------------------------------------
	.MACRO writeVAPU_A _flags,_vol,_ampIndex,_duty,_freqLo,_freqHi,_hard,_fine,_phase
	lda _flags
	and #%00000001
	beq :+++
	lda _hard
	beq :+
	dec _hard
	lda #$FF
	sta VAPU_03_OLD
:	lda _vol
	and #$F0
	ora _ampIndex
	tax
	lda _vol
	asl a
	asl a
	asl a
	asl a
	ora ampTable,x		;output amp 0-F
	tax
	lda VOLUME_TABLE,x
	pha
	ora _duty
	ora #%00110000
	sta VAPU_00
	
	ldx #$00
	lda _fine
	bpl :+
	dex
:	clc
	adc _freqLo
	sta VAPU_02
	txa
	adc _freqHi
	and #$07
	sta VAPU_03
	
	pla
	bne :+
	ldx _phase
	cpx #ENV_PHASE_ATTACK
	bcs :+
	ora #%00110000
	sta VAPU_00
	lda _flags
	and #%11111110
	sta _flags

:
	.ENDMACRO
	
	
	.MACRO writeVAPU_B _flags,_vol,_ampIndex,_duty,_freqLo,_freqHi,_hard,_fine,_phase
	lda _flags
	and #%00000010
	beq :+++
	lda _hard
	beq :+
	dec _hard
	lda #$FF
	sta VAPU_07_OLD
:	lda _vol
	and #$F0
	ora _ampIndex
	tax
	lda _vol
	asl a
	asl a
	asl a
	asl a
	ora ampTable,x		;output amp 0-F
	tax
	lda VOLUME_TABLE,x
	pha
	ora _duty
	ora #%00110000
	sta VAPU_04
	
	ldx #$00
	lda _fine
	bpl :+
	dex
:	clc
	adc _freqLo
	sta VAPU_06
	txa
	adc _freqHi
	and #$07
	sta VAPU_07
	
	pla
	bne :+
	ldx _phase
	cpx #ENV_PHASE_ATTACK
	bcs :+
	ora #%00110000
	sta VAPU_04
	lda _flags
	and #%11111101
	sta _flags
:
	.ENDMACRO

	.MACRO writeVAPU_C _flags,_ampIndex,_freqLo,_freqHi,_fine,_gate
	lda _flags
	and #%00000100
	beq :++
	lda _ampIndex
	sta VAPU_08
	
	ldx #$00
	lda _fine
	bpl :+
	dex
:	clc
	adc _freqLo
	sta VAPU_0A
	txa
	adc _freqHi
	and #$07
	sta VAPU_0B
		
	lda _gate
	bne :+
	sta VAPU_08
	lda _flags
	and #%11111011
	sta _flags
:
	.ENDMACRO

	.MACRO writeVAPU_D _flags,_vol,_ampIndex,_freqLo,_phase
	lda _flags
	and #%00001000
	beq :++
	lda _vol
	and #$F0
	ora _ampIndex
	tax
	lda _vol
	asl a
	asl a
	asl a
	asl a
	ora ampTable,x		;output amp 0-F
	tax
	lda VOLUME_TABLE,x
	pha
	ora #%00110000
	sta VAPU_0C
	
	lda _freqLo
	cmp #$0F
	bcc :+
	ora #$80
:	and #%10001111
	sta VAPU_0E
	pla
	bne :+
	ora #%00110000
	ldx _phase
	cpx #ENV_PHASE_ATTACK
	bcs :+
	sta VAPU_0C
	lda _flags
	and #%11110111
	sta _flags
:	
	.ENDMACRO
	
	.MACRO writeVAPU_E _flags,_on
	lda _flags
	and #%00010000
	beq :+

	lda _on
	beq :+
	lda VAPU_10
	sta APU_10
	lda VAPU_11
	sta APU_11
	lda VAPU_12
	sta APU_12
	lda VAPU_13
	sta APU_13
	
	lda APU_15
	and #$0F
	ora _on
	sta APU_15
	
	lda #$00
	sta _on
:
	.ENDMACRO

;------------------------------------------------------------------------------
; Play Note
;------------------------------------------------------------------------------
	.MACRO playNote _track,_parameters
	lda editorSoloChannel
	bmi :+
	cmp #_track
	beq :+
	rts
	
:	lda editorChannelStatus+_track
	bne :+
	rts
	
:	lda #WRAM_DRUMS
	jsr setMMC1r1
	
	lda noteTrack+_track
	bmi :+		;tie note?
	lda #$00		;no, reset retrigger counter
	sta retriggerCount+_track
	lda retriggerSpeed+_track
	beq :+
	jmp :+++++++

:	jsr @loadDrum
	
	ldy _parameters+mod_Parameter0
	bmi :++
	cpy #gbl_DrumName
	bcc :+
	tya
	sbc #gbl_DrumName
	asl a
	asl a
	tax
	lda plyrMultiTriggers,x
	tay
	lda triggerTmp+0
	sta _parameters,y
	inx
	lda plyrMultiTriggers,x
	tay
	lda triggerTmp+0
	sta _parameters,y
	inx
	lda plyrMultiTriggers,x
	tay	
:	lda triggerTmp+0
	sta _parameters,y
		
:	ldy _parameters+mod_Parameter1
	bmi :++
	cpy #gbl_DrumName
	bcc :+
	tya
	sbc #gbl_DrumName
	asl a
	asl a
	tax
	lda plyrMultiTriggers,x
	tay
	lda triggerTmp+1
	sta _parameters,y
	inx
	lda plyrMultiTriggers,x
	tay
	lda triggerTmp+1
	sta _parameters,y
	inx
	lda plyrMultiTriggers,x
	tay	
:	lda triggerTmp+1
	sta _parameters,y
	
:	ldy _parameters+mod_Parameter2
	bmi :++
	cpy #gbl_DrumName
	bcc :+
	tya
	sbc #gbl_DrumName
	asl a
	asl a
	tax
	lda plyrMultiTriggers,x
	tay
	lda triggerTmp+2
	sta _parameters,y
	inx
	lda plyrMultiTriggers,x
	tay
	lda triggerTmp+2
	sta _parameters,y
	inx
	lda plyrMultiTriggers,x
	tay	
:	lda triggerTmp+2
	sta _parameters,y

:	lda noteTrack+_track
	bpl :+
	and #$7F
	sta noteTrack+_track
	lda _parameters+gbl_VoiceSelect
	sta voiceActive+_track
	sta plyrTmp0
	jsr @plyrPlayTieNote
	rts
	
:	lda _parameters+gbl_VoiceSelect
	sta voiceActive+_track
	sta plyrTmp0
	jsr @plyrPlayNormalNote
	rts

@plyrPlayTieNote:
	lsr plyrTmp0
	bcc :++++
	
	lda noteTrack+_track
	cmp lastNoteTrack+_track
	bne :+
	jmp @skipTie

:	lda slideA+_track
	bne :++++
	lda _parameters+osc_A_Coarse
	cmp #NOTE_ABSOLUTE
	bcc :++
	cmp #NOTE_NEGATIVE
	bcs :+
	adc #$00-NOTE_ABSOLUTE
	bpl :+++
:	clc
:	adc noteTrack+_track
:	sta noteNumberA0+(_track * 3)
	tax
	lda periodLo,x
	sta freqLoA+_track
	lda periodHi,x
	sta freqHiA+_track
	lda #$FF
	sta VAPU_03_OLD
	
	;Start Note on Voice B
:	lsr plyrTmp0
	bcc :++++
	lda slideB+_track
	bne :++++
	lda _parameters+osc_B_Coarse
	cmp #NOTE_ABSOLUTE
	bcc :++
	cmp #NOTE_NEGATIVE
	bcs :+
	adc #$00-NOTE_ABSOLUTE
	bpl :+++
:	clc
:	adc noteTrack+_track
:	sta noteNumberB0+(_track*3)
	tax
	lda periodLo,x
	sta freqLoB+_track
	lda periodHi,x
	sta freqHiB+_track
	lda #$FF
	sta VAPU_07_OLD

	;voice C
:	lsr plyrTmp0
	bcc :++++
	lda slideC+_track
	bne :++++
	lda _parameters+osc_C_Coarse
	cmp #NOTE_ABSOLUTE
	bcc :++
	cmp #NOTE_NEGATIVE
	bcs :+
	adc #$00-NOTE_ABSOLUTE
	bpl :+++
:	clc
:	adc noteTrack+_track
:	sta noteNumberC0+(_track*3)
	tax
	lda periodLo,x
	sta freqLoC+_track
	lda periodHi,x
	sta freqHiC+_track

	;D
:	lsr plyrTmp0
	bcc :++++
	lda _parameters+osc_D_Coarse
	cmp #NOTE_ABSOLUTE
	bcc :++
	cmp #NOTE_NEGATIVE
	bcs :+
	adc #$00-NOTE_ABSOLUTE
	bpl :+++
:	clc
:	adc noteTrack+_track
:	and #$1F
	sta noteNumberD0+(_track*3)
	sta freqLoD+_track

@skipTie:
:	lsr plyrTmp0
	bcc :+
	lda #$0F
	sta $4015
	lda #$10
	sta plyrDpcmOn+_track
	
:	rts
	

@plyrPlayNormalNote:
;Start note on Voice A
	lda #%00110000
	sta VAPU_00
	sta VAPU_04
	sta VAPU_0C
	lda #$00
	sta VAPU_08

	lsr plyrTmp0
	bcs :+
	jmp @b
	
:	lda noteTrack+_track
	ldx slideA+_track
	beq :+
	lda lastNoteTrack+_track
:	sta plyrTmp1
	lda _parameters+osc_A_Coarse
	cmp #NOTE_ABSOLUTE
	bcc :++
	cmp #NOTE_NEGATIVE
	bcs :+
	adc #$00-NOTE_ABSOLUTE
	bpl :+++
:	clc
:	adc plyrTmp1 ;noteTrack+_track
:	sta noteNumberA0+(_track*3)
	tax
	lda periodLo,x
	sta freqLoA+_track
	lda periodHi,x
	sta freqHiA+_track
	lda _parameters+osc_A_Hard
	sta hardFreqA+_track
	lda _parameters+osc_A_Fine
	sta detuneA+_track

	lda #$FF			;BUG FIX: notes not played correctly with arpeggio mod
	sta VAPU_03_OLD
	
	lda #$00
	sta dutyIndexA+_track
	sta dutyCounterA+_track
	sta envCounterA+_track	
	sta lfoPhaseA+_track
	
	lda #ENV_PHASE_ATTACK
	sta envPhaseA+_track

	lda _parameters+env_A_Gate
	sta envGateTimerA+_track

	lda _parameters+env_A_Volume
	lsr a
	lsr a
	lsr a
	lsr a
	tax
	lda ampTableIndex,x
	sta envAmpIndexA+_track
	
	lda _parameters+lfo_A_Speed
	sta lfoCounterA+_track
	lda _parameters+lfo_A_Delay
	bmi :+
	sta lfoDelCounterA+_track	;vibrato/sweep
	lda lfoCounterA+_track
	beq @b
	lda _parameters+lfo_A_Depth
	bpl @b
	eor #$FF
	clc
	adc #$01
	sta _parameters+lfo_A_Depth
	lda #$01
	sta lfoPhaseA+_track
	bpl @b
	
:	and #$7F
	pha
	bne :+
	sta arpNotesA0+(_track*3)+1
	inc lfoPhaseA+_track
	lda _parameters+lfo_A_Depth
	sta arpNotesA0+(_track*3)
	pla
	sta lfoDelCounterA+_track	
	bpl @b
	
:	lda _parameters+lfo_A_Depth
	lsr a
	lsr a
	lsr a
	lsr a
	sta arpNotesA0+(_track*3)
	lda _parameters+lfo_A_Depth
	and #$0F
	sta arpNotesA0+(_track*3)+1
	pla
	sta lfoDelCounterA+_track

;Start Note on Voice B

@b:
	lsr plyrTmp0
	bcs :+
	jmp @c
:	lda noteTrack+_track
	ldx slideB+_track
	beq :+
	lda lastNoteTrack+_track
:	sta plyrTmp1
	lda _parameters+osc_B_Coarse
	cmp #NOTE_ABSOLUTE
	bcc :++
	cmp #NOTE_NEGATIVE
	bcs :+
	adc #$00-NOTE_ABSOLUTE
	bpl :+++
:	clc
:	adc plyrTmp1 ;noteTrack+_track
:	sta noteNumberB0+(_track*3)
	tax
	lda periodLo,x
	sta freqLoB+_track
	lda periodHi,x
	sta freqHiB+_track
	lda _parameters+osc_B_Hard
	sta hardFreqB+_track
	lda _parameters+osc_B_Fine
	sta detuneB+_track
	lda #$FF
	sta VAPU_07_OLD
	
	lda #$00
	sta dutyIndexB+_track
	sta dutyCounterB+_track
	sta envCounterB+_track	
	sta lfoPhaseB+_track
	
	lda #ENV_PHASE_ATTACK
	sta envPhaseB+_track

	lda _parameters+env_B_Gate
	sta envGateTimerB+_track

	lda _parameters+env_B_Volume
	lsr a
	lsr a
	lsr a
	lsr a
	tax
	lda ampTableIndex,x
	sta envAmpIndexB+_track
	
	lda _parameters+lfo_B_Speed
	sta lfoCounterB+_track
	lda _parameters+lfo_B_Delay
	bmi :+
	sta lfoDelCounterB+_track	;vibrato/sweep
	lda lfoCounterB+_track
	beq @c
	lda _parameters+lfo_B_Depth
	bpl @c
	eor #$FF
	clc
	adc #$01
	sta _parameters+lfo_B_Depth
	lda #$01
	sta lfoPhaseB+_track
	bpl @c
	
:	and #$7F
	pha
	bne :+
	sta arpNotesB0+(_track*3)+1
	inc lfoPhaseB+_track
	lda _parameters+lfo_B_Depth
	sta arpNotesB0+(_track*3)
	pla
	sta lfoDelCounterB+_track	
	bpl @c
	
:	lda _parameters+lfo_B_Depth
	lsr a
	lsr a
	lsr a
	lsr a
	sta arpNotesB0+(_track*3)
	lda _parameters+lfo_B_Depth
	and #$0F
	sta arpNotesB0+(_track*3)+1
	pla
	sta lfoDelCounterB+_track

@c:	lsr plyrTmp0
	bcs @doC
	jmp @d

@doC:	lda noteTrack+_track
	ldx slideC+_track
	beq :+
	lda lastNoteTrack+_track
:	sta plyrTmp1
	lda _parameters+osc_C_Coarse
	cmp #NOTE_ABSOLUTE
	bcc :++
	cmp #NOTE_NEGATIVE
	bcs :+
	adc #$00-NOTE_ABSOLUTE
	bpl :+++
:	clc
:	adc plyrTmp1 ;noteTrack+_track
:	sta noteNumberC0+(_track*3)
	tax
	lda periodLo,x
	sta freqLoC+_track
	lda periodHi,x
	sta freqHiC+_track
	lda _parameters+osc_C_Fine
	sta detuneC+_track
	
	lda #$00
	sta envCounterC+_track	
	sta envPhaseC+_track
	sta lfoPhaseC+_track
	lda _parameters+env_C_Gate
	sta envGateTimerC+_track
		
	lda _parameters+lfo_C_Speed
	sta lfoCounterC+_track
	lda _parameters+lfo_C_Delay
	bmi :+
	sta lfoDelCounterC+_track	;vibrato/sweep
	lda lfoCounterC+_track
	beq @d
	lda _parameters+lfo_C_Depth
	bpl @d
	eor #$FF
	clc
	adc #$01
	sta _parameters+lfo_C_Depth
	lda #$01
	sta lfoPhaseC+_track
	bpl @d
	
:	and #$7F
	pha
	bne :+
	sta arpNotesC0+(_track*3)+1
	inc lfoPhaseC+_track
	lda _parameters+lfo_C_Depth
	sta arpNotesC0+(_track*3)
	pla
	sta lfoDelCounterC+_track	
	bpl @d
	
:	lda _parameters+lfo_C_Depth
	lsr a
	lsr a
	lsr a
	lsr a
	sta arpNotesC0+(_track*3)
	lda _parameters+lfo_C_Depth
	and #$0F
	sta arpNotesC0+(_track*3)+1
	pla
	sta lfoDelCounterC+_track


@d:	lsr plyrTmp0
	bcc @e
	
	lda _parameters+osc_D_Coarse
	cmp #NOTE_ABSOLUTE
	bcc :+
	sbc #NOTE_ABSOLUTE
	jmp :++
:	adc noteTrack+_track
	tax
	dex
	txa
:	and #$1F
	sta noteNumberD0+(_track*3)
	sta freqLoD+_track
	
	lda #$00
	sta envCounterD+_track	
	sta lfoPhaseD+_track
	
	lda #ENV_PHASE_ATTACK
	sta envPhaseD+_track

	lda _parameters+env_D_Gate
	sta envGateTimerD+_track

	lda _parameters+env_D_Volume
	lsr a
	lsr a
	lsr a
	lsr a
	tax
	lda ampTableIndex,x
	sta envAmpIndexD+_track
	
	lda _parameters+lfo_D_Speed
	sta lfoCounterD+_track
	lda _parameters+lfo_D_Delay
	bpl :++
	and #$7F
	pha
	bne :+
	inc lfoPhaseD+_track
	
:	lda _parameters+lfo_D_Depth
	lsr a
	lsr a
	lsr a
	lsr a
	sta arpNotesD0+(_track*3)
	lda _parameters+lfo_D_Depth
	and #$0F
	sta arpNotesD0+(_track*3)+1
	pla
:	sta lfoDelCounterD+_track

@e:	lsr plyrTmp0
	bcc @x

	ldx _parameters+smp_E_Sample
	beq @x

	lda #$0F
	sta APU_15
		
	lda #$3F
	sta VAPU_11

	dex
	lda dmcAddressTable,x
	clc
	adc _parameters+smp_E_Start
	sta VAPU_12
	eor #$3f
	clc
	adc dmcAddressTable+1,x
	asl a
	asl a
	ora #$03
	sec
	sbc _parameters+smp_E_End		
	sta VAPU_13

	lda _parameters+smp_E_Pitch
	cmp #NOTE_ABSOLUTE
	bcc :++
	cmp #NOTE_NEGATIVE
	bcs :+
	adc #$00-NOTE_ABSOLUTE
	bpl :+++
:	clc
:	adc noteTrack+_track
:	and #$0F
	sta noteNumberE0+_track
	
	lda _parameters+smp_E_Loop
	asl a
	asl a
	asl a
	asl a
	asl a
	asl a
	ora noteNumberE0+_track		
	sta VAPU_10
				
				
	lda #$10
	sta plyrDpcmOn+_track
@x:	
	rts
	
@loadDrum:
	ldx plyrTrackDrum+_track
	lda plyrDrumAddressLo,x
	sta plyrTmp0
	lda plyrDrumAddressHi,x
	sta plyrTmp1
	ldy #$00
:	lda (plyrTmp0),y
	sta _parameters,y
	iny
	cpy #bytesPerDrum
	bcc :-
	rts
	.ENDMACRO





	.MACRO newStep _track
	ldx plyrTrackPhrase+_track
	lda phraseBanks,x
	jsr setMMC1r1
	
	lda phraseTableLo,x
	sta plyrTmp0
	lda phraseTableHi,x
	sta plyrTmp1

	ldx patternIndex
	lda patternIndexX5,x
	tay
	lda (plyrTmp0),y
	beq :++++
	
	cmp #$FF
	bne :+
	.IF (_track=0)
	jsr killNote0
	jmp :++++
	.ELSEIF (_track=1)
	jsr killNote1
	jmp :++++
	.ELSEIF (_track=2)
	jsr killNote2
	jmp :++++
	.ELSEIF (_track=3)
	jsr killNote3
	jmp :++++
	.ELSEIF (_track=4)
	jsr killNote4
	jmp :++++
	.ELSEIF (_track=5)
	jsr killNote5
	jmp :++++
	.ENDIF	
	
:	pha
	lda noteTrack+_track
	sta lastNoteTrack+_track
	and #$7F
	sta plyrTmp2
	pla
	sta noteTrack+_track
	
	lda #$01
	sta editorMeterCounters+_track

	lda #$00
	sta retriggerSpeed+_track
	sta slideA+_track
	sta slideB+_track
	sta slideC+_track

	iny
	lda (plyrTmp0),y
	sta retriggerTemp
	iny
	lda (plyrTmp0),y
	sta triggerTmp+0
	iny
	lda (plyrTmp0),y
	sta triggerTmp+1
	iny
	lda (plyrTmp0),y
	sta triggerTmp+2
	
	lda retriggerTemp
	bpl :++
	and #$7F
	sta slideA+_track
	sta slideB+_track
	sta slideC+_track
	lda #$00
	sta retriggerTemp
		
	lda noteTrack+_track
	and #$7F
	sec
	sbc plyrTmp2 ;lastNoteTrack+_track
	beq :+
	bcs :++
	lda slideA+_track
	eor #$FF
	clc
	adc #$01
:	sta slideA+_track
	sta slideB+_track
	sta slideC+_track
:	
	
	.IF (_track=0)
	jsr playNote0
	.ELSEIF (_track=1)
	jsr playNote1
	.ELSEIF (_track=2)
	jsr playNote2
	.ELSEIF (_track=3)
	jsr playNote3
	.ELSEIF (_track=4)
	jsr playNote4
	.ELSEIF (_track=5)
	jsr playNote5
	.ENDIF
	lda retriggerTemp
	sta retriggerSpeed+_track
:
	.ENDMACRO
	

	.MACRO checkRetrigger _track
	lda retriggerCount+_track
	clc
	adc retriggerSpeed+_track
	sta retriggerCount+_track
	bcc :+
	.IF (_track=0)
	jsr playNote0
	.ELSEIF (_track=1)
	jsr playNote1
	.ELSEIF (_track=2)
	jsr playNote2
	.ELSEIF (_track=3)
	jsr playNote3
	.ELSEIF (_track=4)
	jsr playNote4
	.ELSEIF (_track=5)
	jsr playNote5
	.ENDIF
:		
	.ENDMACRO
	
	.MACRO killNote _track
	lda #$00
	sta retriggerSpeed+_track
	lda voiceActive+_track
	sta plyrTmp0
	lsr plyrTmp0
	bcc :+
	lda #$00
	sta envPhaseA+_track
	sta envAmpIndexA+_track
	
:	lsr plyrTmp0
	bcc :+
	lda #$00
	sta envPhaseB+_track
	sta envAmpIndexB+_track
	
:	lsr plyrTmp0
	bcc :+
	lda #$00
	sta envGateTimerC+_track
	
:	lsr plyrTmp0
	bcc :+
	lda #$00
	sta envAmpIndexD+_track
	sta envPhaseD+_track
	
:	lsr plyrTmp0
	bcc :+
	lda #$0F
	sta APU_15
:
	.ENDMACRO
	
	
	.MACRO echoEffect _voice,_amp,_phase,_level,_decay,_select,_echo0,_echo2,_echo3,_apu0,_apu2,_apu3
	lda #WRAM_ECHO
	jsr setMMC1r1	
	ldy plyrEchoIndex

	lda _phase+0
	ora _phase+1
	ora _phase+2
	ora _phase+3
	ora _phase+4
	ora _phase+5
	cmp #$01
	bcs :++
	;on
	
	lda plyrEchoWrite+_voice
	bne :+
	.IF (_voice=0)
	lda #$FF
	sta VAPU_03_OLD
	.ELSEIF (_voice=1)
	lda #$FF
	sta VAPU_07_OLD
	.ENDIF
:	lda #$01
	sta plyrEchoWrite+_voice
	bne :+++
	
:	lda plyrEchoWrite+_voice
	beq :+
	.IF (_voice=0)
	lda #$FF
	sta VAPU_03_OLD
	.ELSEIF (_voice=1)
	lda #$FF
	sta VAPU_07_OLD
	.ENDIF	
:	lda #$00
	sta plyrEchoWrite+_voice

;read from buffer
:	lda plyrEchoWrite+_voice
	beq :+++
	.IF (_voice<2)
	lda _echo3,y
	sta _apu3
	.ENDIF
	lda _echo2,y
	sta _apu2
	lda _echo0,y
	sta _apu0
	and #%11110000
	sta plyrTmp0
	lda _select
	.IF (_voice=0)
	and #%00000001
	.ELSEIF (_voice=1)
	and #%00000010
	.ELSEIF (_voice=2)
	and #%00000100
	.ENDIF
	bne :+
	lda _echo0,y
	and #%00001111
	sec
	sbc #$01
	bpl :++
	lda #$00
	beq :++
	rts
	
:	lda _echo0,y
	and #%00001111
	sec
	sbc _decay
	bpl :+
	lda #$00
:	ora plyrTmp0
	sta _echo0,y
	rts
	
;write to buffer
:	lda _select
	.IF (_voice=0)
	and #%00000001
	.ELSEIF (_voice=1)
	and #%00000010
	.ELSEIF (_voice=2)
	and #%00000100
	.ENDIF
	beq :+
	.IF (_voice<2)
	lda _apu3		;hi freq
	sta _echo3,y
	.ENDIF
	lda _apu2		;lo freq
	sta _echo2,y
	lda _apu0		;duty & amp
	and #%11110000
	sta plyrTmp0
	lda _apu0
	and #%00001111
	sty plyrTmp1
	tay
	lda VOLUME_TABLE_LO,y
	sta plyrTmp2
	lda VOLUME_TABLE_HI,y
	sta plyrTmp3
	ldy _level
	lda (plyrTmp2),y
	ora plyrTmp0
	ldy plyrTmp1
	sta _echo0,y
:	rts
	
	.ENDMACRO


		
	