synthRefresh:
	jsr ampEnvelopeA0
	jsr ampEnvelopeA1
	jsr ampEnvelopeA2
	jsr ampEnvelopeA3
	jsr ampEnvelopeA4
	jsr ampEnvelopeA5
	
	jsr ampEnvelopeB0
	jsr ampEnvelopeB1
	jsr ampEnvelopeB2
	jsr ampEnvelopeB3
	jsr ampEnvelopeB4
	jsr ampEnvelopeB5
	
	jsr ampEnvelopeC0
	jsr ampEnvelopeC1
	jsr ampEnvelopeC2
	jsr ampEnvelopeC3
	jsr ampEnvelopeC4
	jsr ampEnvelopeC5
	
	jsr ampEnvelopeD0
	jsr ampEnvelopeD1
	jsr ampEnvelopeD2
	jsr ampEnvelopeD3
	jsr ampEnvelopeD4
	jsr ampEnvelopeD5
	
	jsr pitchLFOA0
	jsr pitchLFOA1
	jsr pitchLFOA2
	jsr pitchLFOA3
	jsr pitchLFOA4
	jsr pitchLFOA5

	jsr pitchLFOB0
	jsr pitchLFOB1
	jsr pitchLFOB2
	jsr pitchLFOB3
	jsr pitchLFOB4
	jsr pitchLFOB5

	jsr pitchLFOC0
	jsr pitchLFOC1
	jsr pitchLFOC2
	jsr pitchLFOC3
	jsr pitchLFOC4
	jsr pitchLFOC5
	
	jsr pitchLFOD0
	jsr pitchLFOD1
	jsr pitchLFOD2
	jsr pitchLFOD3
	jsr pitchLFOD4
	jsr pitchLFOD5
	
	jsr dutyModA0
	jsr dutyModA1
	jsr dutyModA2
	jsr dutyModA3
	jsr dutyModA4
	jsr dutyModA5
	
	jsr dutyModB0
	jsr dutyModB1
	jsr dutyModB2
	jsr dutyModB3
	jsr dutyModB4
	jsr dutyModB5
	
	jsr writeVAPU

	jsr echoTrackA
	jsr echoTrackB
	jsr echoTrackD
	
	jsr writeAPU_A
	jsr writeAPU_B
	jsr writeAPU_C
	jsr writeAPU_D


	rts


echoTrackA:
	echoEffect 0,envAmpIndexA,envPhaseA,plyrEchoInitAttnA,plyrEchoAttn,plyrEchoSelect,echoBufferA_0,echoBufferA_2,echoBufferA_3,VAPU_00,VAPU_02,VAPU_03
echoTrackB:
	echoEffect 1,envAmpIndexB,envPhaseB,plyrEchoInitAttnB,plyrEchoAttn,plyrEchoSelect,echoBufferB_0,echoBufferB_2,echoBufferB_3,VAPU_04,VAPU_06,VAPU_07
echoTrackD:
	echoEffect 2,envAmpIndexD,envPhaseD,plyrEchoInitAttnD,plyrEchoAttn,plyrEchoSelect,echoBufferD_0,echoBufferD_2,echoBufferD_2,VAPU_0C,VAPU_0E,VAPU_0E

pitchLFOA0: pitchLFO drumParameters0+lfo_A_Delay,lfoCounterA+0,lfoPhaseA+0,noteNumberA0,lfoDelCounterA+0,drumParameters0+lfo_A_Speed,drumParameters0+lfo_A_Depth,freqLoA+0,freqHiA+0,slideA+0
pitchLFOA1: pitchLFO drumParameters1+lfo_A_Delay,lfoCounterA+1,lfoPhaseA+1,noteNumberA1,lfoDelCounterA+1,drumParameters1+lfo_A_Speed,drumParameters1+lfo_A_Depth,freqLoA+1,freqHiA+1,slideA+1
pitchLFOA2: pitchLFO drumParameters2+lfo_A_Delay,lfoCounterA+2,lfoPhaseA+2,noteNumberA2,lfoDelCounterA+2,drumParameters2+lfo_A_Speed,drumParameters2+lfo_A_Depth,freqLoA+2,freqHiA+2,slideA+2
pitchLFOA3: pitchLFO drumParameters3+lfo_A_Delay,lfoCounterA+3,lfoPhaseA+3,noteNumberA3,lfoDelCounterA+3,drumParameters3+lfo_A_Speed,drumParameters3+lfo_A_Depth,freqLoA+3,freqHiA+3,slideA+3
pitchLFOA4: pitchLFO drumParameters4+lfo_A_Delay,lfoCounterA+4,lfoPhaseA+4,noteNumberA4,lfoDelCounterA+4,drumParameters4+lfo_A_Speed,drumParameters4+lfo_A_Depth,freqLoA+4,freqHiA+4,slideA+4
pitchLFOA5: pitchLFO drumParameters5+lfo_A_Delay,lfoCounterA+5,lfoPhaseA+5,noteNumberA5,lfoDelCounterA+5,drumParameters5+lfo_A_Speed,drumParameters5+lfo_A_Depth,freqLoA+5,freqHiA+5,slideA+5

pitchLFOB0: pitchLFO drumParameters0+lfo_B_Delay,lfoCounterB+0,lfoPhaseB+0,noteNumberB0,lfoDelCounterB+0,drumParameters0+lfo_B_Speed,drumParameters0+lfo_B_Depth,freqLoB+0,freqHiB+0,slideB+0
pitchLFOB1: pitchLFO drumParameters1+lfo_B_Delay,lfoCounterB+1,lfoPhaseB+1,noteNumberB1,lfoDelCounterB+1,drumParameters1+lfo_B_Speed,drumParameters1+lfo_B_Depth,freqLoB+1,freqHiB+1,slideB+1
pitchLFOB2: pitchLFO drumParameters2+lfo_B_Delay,lfoCounterB+2,lfoPhaseB+2,noteNumberB2,lfoDelCounterB+2,drumParameters2+lfo_B_Speed,drumParameters2+lfo_B_Depth,freqLoB+2,freqHiB+2,slideB+2
pitchLFOB3: pitchLFO drumParameters3+lfo_B_Delay,lfoCounterB+3,lfoPhaseB+3,noteNumberB3,lfoDelCounterB+3,drumParameters3+lfo_B_Speed,drumParameters3+lfo_B_Depth,freqLoB+3,freqHiB+3,slideB+3
pitchLFOB4: pitchLFO drumParameters4+lfo_B_Delay,lfoCounterB+4,lfoPhaseB+4,noteNumberB4,lfoDelCounterB+4,drumParameters4+lfo_B_Speed,drumParameters4+lfo_B_Depth,freqLoB+4,freqHiB+4,slideB+4
pitchLFOB5: pitchLFO drumParameters5+lfo_B_Delay,lfoCounterB+5,lfoPhaseB+5,noteNumberB5,lfoDelCounterB+5,drumParameters5+lfo_B_Speed,drumParameters5+lfo_B_Depth,freqLoB+5,freqHiB+5,slideB+5

pitchLFOC0: pitchLFO drumParameters0+lfo_C_Delay,lfoCounterC+0,lfoPhaseC+0,noteNumberC0,lfoDelCounterC+0,drumParameters0+lfo_C_Speed,drumParameters0+lfo_C_Depth,freqLoC+0,freqHiC+0,slideC+0
pitchLFOC1: pitchLFO drumParameters1+lfo_C_Delay,lfoCounterC+1,lfoPhaseC+1,noteNumberC1,lfoDelCounterC+1,drumParameters1+lfo_C_Speed,drumParameters1+lfo_C_Depth,freqLoC+1,freqHiC+1,slideC+1
pitchLFOC2: pitchLFO drumParameters2+lfo_C_Delay,lfoCounterC+2,lfoPhaseC+2,noteNumberC2,lfoDelCounterC+2,drumParameters2+lfo_C_Speed,drumParameters2+lfo_C_Depth,freqLoC+2,freqHiC+2,slideC+2
pitchLFOC3: pitchLFO drumParameters3+lfo_C_Delay,lfoCounterC+3,lfoPhaseC+3,noteNumberC3,lfoDelCounterC+3,drumParameters3+lfo_C_Speed,drumParameters3+lfo_C_Depth,freqLoC+3,freqHiC+3,slideC+3
pitchLFOC4: pitchLFO drumParameters4+lfo_C_Delay,lfoCounterC+4,lfoPhaseC+4,noteNumberC4,lfoDelCounterC+4,drumParameters4+lfo_C_Speed,drumParameters4+lfo_C_Depth,freqLoC+4,freqHiC+4,slideC+4
pitchLFOC5: pitchLFO drumParameters5+lfo_C_Delay,lfoCounterC+5,lfoPhaseC+5,noteNumberC5,lfoDelCounterC+5,drumParameters5+lfo_C_Speed,drumParameters5+lfo_C_Depth,freqLoC+5,freqHiC+5,slideC+5

pitchLFOD0: noiseLFO drumParameters0+lfo_D_Delay,lfoCounterD+0,lfoPhaseD+0,noteNumberD0,lfoDelCounterD+0,drumParameters0+lfo_D_Speed,drumParameters0+lfo_D_Depth,freqLoD+0
pitchLFOD1: noiseLFO drumParameters1+lfo_D_Delay,lfoCounterD+1,lfoPhaseD+1,noteNumberD1,lfoDelCounterD+1,drumParameters1+lfo_D_Speed,drumParameters1+lfo_D_Depth,freqLoD+1
pitchLFOD2: noiseLFO drumParameters2+lfo_D_Delay,lfoCounterD+2,lfoPhaseD+2,noteNumberD2,lfoDelCounterD+2,drumParameters2+lfo_D_Speed,drumParameters2+lfo_D_Depth,freqLoD+2
pitchLFOD3: noiseLFO drumParameters3+lfo_D_Delay,lfoCounterD+3,lfoPhaseD+3,noteNumberD3,lfoDelCounterD+3,drumParameters3+lfo_D_Speed,drumParameters3+lfo_D_Depth,freqLoD+3
pitchLFOD4: noiseLFO drumParameters4+lfo_D_Delay,lfoCounterD+4,lfoPhaseD+4,noteNumberD4,lfoDelCounterD+4,drumParameters4+lfo_D_Speed,drumParameters4+lfo_D_Depth,freqLoD+4
pitchLFOD5: noiseLFO drumParameters5+lfo_D_Delay,lfoCounterD+5,lfoPhaseD+5,noteNumberD5,lfoDelCounterD+5,drumParameters5+lfo_D_Speed,drumParameters5+lfo_D_Depth,freqLoD+5

ampEnvelopeA0: ampEnvelope envPhaseA+0,drumParameters0+env_A_Env,drumParameters0+env_A_Volume,envAmpIndexA+0,envCounterA+0,drumParameters0+env_A_Gate
ampEnvelopeA1: ampEnvelope envPhaseA+1,drumParameters1+env_A_Env,drumParameters1+env_A_Volume,envAmpIndexA+1,envCounterA+1,drumParameters1+env_A_Gate
ampEnvelopeA2: ampEnvelope envPhaseA+2,drumParameters2+env_A_Env,drumParameters2+env_A_Volume,envAmpIndexA+2,envCounterA+2,drumParameters2+env_A_Gate
ampEnvelopeA3: ampEnvelope envPhaseA+3,drumParameters3+env_A_Env,drumParameters3+env_A_Volume,envAmpIndexA+3,envCounterA+3,drumParameters3+env_A_Gate
ampEnvelopeA4: ampEnvelope envPhaseA+4,drumParameters4+env_A_Env,drumParameters4+env_A_Volume,envAmpIndexA+4,envCounterA+4,drumParameters4+env_A_Gate
ampEnvelopeA5: ampEnvelope envPhaseA+5,drumParameters5+env_A_Env,drumParameters5+env_A_Volume,envAmpIndexA+5,envCounterA+5,drumParameters5+env_A_Gate

ampEnvelopeB0: ampEnvelope envPhaseB+0,drumParameters0+env_B_Env,drumParameters0+env_B_Volume,envAmpIndexB+0,envCounterB+0,drumParameters0+env_B_Gate
ampEnvelopeB1: ampEnvelope envPhaseB+1,drumParameters1+env_B_Env,drumParameters1+env_B_Volume,envAmpIndexB+1,envCounterB+1,drumParameters1+env_B_Gate
ampEnvelopeB2: ampEnvelope envPhaseB+2,drumParameters2+env_B_Env,drumParameters2+env_B_Volume,envAmpIndexB+2,envCounterB+2,drumParameters2+env_B_Gate
ampEnvelopeB3: ampEnvelope envPhaseB+3,drumParameters3+env_B_Env,drumParameters3+env_B_Volume,envAmpIndexB+3,envCounterB+3,drumParameters3+env_B_Gate
ampEnvelopeB4: ampEnvelope envPhaseB+4,drumParameters4+env_B_Env,drumParameters4+env_B_Volume,envAmpIndexB+4,envCounterB+4,drumParameters4+env_B_Gate
ampEnvelopeB5: ampEnvelope envPhaseB+5,drumParameters5+env_B_Env,drumParameters5+env_B_Volume,envAmpIndexB+5,envCounterB+5,drumParameters5+env_B_Gate

ampEnvelopeC0: ampEnvelopeC envGateTimerC+0,drumParameters0+env_C_Gate,envAmpIndexC+0,envPhaseC+0,drumParameters0+env_C_Pulse,envCounterC+0
ampEnvelopeC1: ampEnvelopeC envGateTimerC+1,drumParameters1+env_C_Gate,envAmpIndexC+1,envPhaseC+1,drumParameters1+env_C_Pulse,envCounterC+1
ampEnvelopeC2: ampEnvelopeC envGateTimerC+2,drumParameters2+env_C_Gate,envAmpIndexC+2,envPhaseC+2,drumParameters2+env_C_Pulse,envCounterC+2
ampEnvelopeC3: ampEnvelopeC envGateTimerC+3,drumParameters3+env_C_Gate,envAmpIndexC+3,envPhaseC+3,drumParameters3+env_C_Pulse,envCounterC+3
ampEnvelopeC4: ampEnvelopeC envGateTimerC+4,drumParameters4+env_C_Gate,envAmpIndexC+4,envPhaseC+4,drumParameters4+env_C_Pulse,envCounterC+4
ampEnvelopeC5: ampEnvelopeC envGateTimerC+5,drumParameters5+env_C_Gate,envAmpIndexC+5,envPhaseC+5,drumParameters5+env_C_Pulse,envCounterC+5

ampEnvelopeD0: ampEnvelope envPhaseD+0,drumParameters0+env_D_Env,drumParameters0+env_D_Volume,envAmpIndexD+0,envCounterD+0,drumParameters0+env_D_Gate
ampEnvelopeD1: ampEnvelope envPhaseD+1,drumParameters1+env_D_Env,drumParameters1+env_D_Volume,envAmpIndexD+1,envCounterD+1,drumParameters1+env_D_Gate
ampEnvelopeD2: ampEnvelope envPhaseD+2,drumParameters2+env_D_Env,drumParameters2+env_D_Volume,envAmpIndexD+2,envCounterD+2,drumParameters2+env_D_Gate
ampEnvelopeD3: ampEnvelope envPhaseD+3,drumParameters3+env_D_Env,drumParameters3+env_D_Volume,envAmpIndexD+3,envCounterD+3,drumParameters3+env_D_Gate
ampEnvelopeD4: ampEnvelope envPhaseD+4,drumParameters4+env_D_Env,drumParameters4+env_D_Volume,envAmpIndexD+4,envCounterD+4,drumParameters4+env_D_Gate
ampEnvelopeD5: ampEnvelope envPhaseD+5,drumParameters5+env_D_Env,drumParameters5+env_D_Volume,envAmpIndexD+5,envCounterD+5,drumParameters5+env_D_Gate

dutyModA0: dutyMod dutyCounterA+0,dutyIndexA+0,drumParameters0+dty_A_Width0,dutyWidthA+0
dutyModA1: dutyMod dutyCounterA+1,dutyIndexA+1,drumParameters1+dty_A_Width0,dutyWidthA+1
dutyModA2: dutyMod dutyCounterA+2,dutyIndexA+2,drumParameters2+dty_A_Width0,dutyWidthA+2
dutyModA3: dutyMod dutyCounterA+3,dutyIndexA+3,drumParameters3+dty_A_Width0,dutyWidthA+3
dutyModA4: dutyMod dutyCounterA+4,dutyIndexA+4,drumParameters4+dty_A_Width0,dutyWidthA+4
dutyModA5: dutyMod dutyCounterA+5,dutyIndexA+5,drumParameters5+dty_A_Width0,dutyWidthA+5

dutyModB0: dutyMod dutyCounterB+0,dutyIndexB+0,drumParameters0+dty_B_Width0,dutyWidthB+0
dutyModB1: dutyMod dutyCounterB+1,dutyIndexB+1,drumParameters1+dty_B_Width0,dutyWidthB+1
dutyModB2: dutyMod dutyCounterB+2,dutyIndexB+2,drumParameters2+dty_B_Width0,dutyWidthB+2
dutyModB3: dutyMod dutyCounterB+3,dutyIndexB+3,drumParameters3+dty_B_Width0,dutyWidthB+3
dutyModB4: dutyMod dutyCounterB+4,dutyIndexB+4,drumParameters4+dty_B_Width0,dutyWidthB+4
dutyModB5: dutyMod dutyCounterB+5,dutyIndexB+5,drumParameters5+dty_B_Width0,dutyWidthB+5

;------------------------------------------------------------------------------
; Write APU registers
;------------------------------------------------------------------------------

;
;Called for every track
;
writeVAPU:
	.IF MUTE_AUDIO=0
	writeVAPU_A voiceActive+0,drumParameters0+env_A_Volume,envAmpIndexA+0,dutyWidthA+0,freqLoA+0,freqHiA+0,hardFreqA+0,detuneA+0,envPhaseA+0
	writeVAPU_B voiceActive+0,drumParameters0+env_B_Volume,envAmpIndexB+0,dutyWidthB+0,freqLoB+0,freqHiB+0,hardFreqB+0,detuneB+0,envPhaseB+0
	writeVAPU_C voiceActive+0,envAmpIndexC+0,freqLoC+0,freqHiC+0,detuneC+0,envGateTimerC+0
	writeVAPU_D voiceActive+0,drumParameters0+env_D_Volume,envAmpIndexD+0,freqLoD+0,envPhaseD+0
	writeVAPU_E voiceActive+0,plyrDpcmOn+0

	writeVAPU_A voiceActive+1,drumParameters1+env_A_Volume,envAmpIndexA+1,dutyWidthA+1,freqLoA+1,freqHiA+1,hardFreqA+1,detuneA+1,envPhaseA+1
	writeVAPU_B voiceActive+1,drumParameters1+env_B_Volume,envAmpIndexB+1,dutyWidthB+1,freqLoB+1,freqHiB+1,hardFreqB+1,detuneB+1,envPhaseB+1
	writeVAPU_C voiceActive+1,envAmpIndexC+1,freqLoC+1,freqHiC+1,detuneC+1,envGateTimerC+1
	writeVAPU_D voiceActive+1,drumParameters1+env_D_Volume,envAmpIndexD+1,freqLoD+1,envPhaseD+1
	writeVAPU_E voiceActive+1,plyrDpcmOn+1

	writeVAPU_A voiceActive+2,drumParameters2+env_A_Volume,envAmpIndexA+2,dutyWidthA+2,freqLoA+2,freqHiA+2,hardFreqA+2,detuneA+2,envPhaseA+2
	writeVAPU_B voiceActive+2,drumParameters2+env_B_Volume,envAmpIndexB+2,dutyWidthB+2,freqLoB+2,freqHiB+2,hardFreqB+2,detuneB+2,envPhaseB+2
	writeVAPU_C voiceActive+2,envAmpIndexC+2,freqLoC+2,freqHiC+2,detuneC+2,envGateTimerC+2
	writeVAPU_D voiceActive+2,drumParameters2+env_D_Volume,envAmpIndexD+2,freqLoD+2,envPhaseD+2
	writeVAPU_E voiceActive+2,plyrDpcmOn+2

	writeVAPU_A voiceActive+3,drumParameters3+env_A_Volume,envAmpIndexA+3,dutyWidthA+3,freqLoA+3,freqHiA+3,hardFreqA+3,detuneA+3,envPhaseA+3
	writeVAPU_B voiceActive+3,drumParameters3+env_B_Volume,envAmpIndexB+3,dutyWidthB+3,freqLoB+3,freqHiB+3,hardFreqB+3,detuneB+3,envPhaseB+3
	writeVAPU_C voiceActive+3,envAmpIndexC+3,freqLoC+3,freqHiC+3,detuneC+3,envGateTimerC+3
	writeVAPU_D voiceActive+3,drumParameters3+env_D_Volume,envAmpIndexD+3,freqLoD+3,envPhaseD+3
	writeVAPU_E voiceActive+3,plyrDpcmOn+3

	writeVAPU_A voiceActive+4,drumParameters4+env_A_Volume,envAmpIndexA+4,dutyWidthA+4,freqLoA+4,freqHiA+4,hardFreqA+4,detuneA+4,envPhaseA+4
	writeVAPU_B voiceActive+4,drumParameters4+env_B_Volume,envAmpIndexB+4,dutyWidthB+4,freqLoB+4,freqHiB+4,hardFreqB+4,detuneB+4,envPhaseB+4
	writeVAPU_C voiceActive+4,envAmpIndexC+4,freqLoC+4,freqHiC+4,detuneC+4,envGateTimerC+4
	writeVAPU_D voiceActive+4,drumParameters4+env_D_Volume,envAmpIndexD+4,freqLoD+4,envPhaseD+4
	writeVAPU_E voiceActive+4,plyrDpcmOn+4

	writeVAPU_A voiceActive+5,drumParameters5+env_A_Volume,envAmpIndexA+5,dutyWidthA+5,freqLoA+5,freqHiA+5,hardFreqA+5,detuneA+5,envPhaseA+5
	writeVAPU_B voiceActive+5,drumParameters5+env_B_Volume,envAmpIndexB+5,dutyWidthB+5,freqLoB+5,freqHiB+5,hardFreqB+5,detuneB+5,envPhaseB+5
	writeVAPU_C voiceActive+5,envAmpIndexC+5,freqLoC+5,freqHiC+5,detuneC+5,envGateTimerC+5
	writeVAPU_D voiceActive+5,drumParameters5+env_D_Volume,envAmpIndexD+5,freqLoD+5,envPhaseD+5
	writeVAPU_E voiceActive+5,plyrDpcmOn+5

	.ENDIF
	rts

;
;Only called once per synth refresh
;
writeAPU_A:
	lda VAPU_00
	sta $4000
	lda VAPU_02
	sta $4002

	.IF 1=1
	lda plyrEchoWrite+0
	bne @normal
	lda VAPU_03_OLD
	bmi @normal	
	lda VAPU_03
	and #$07
	sec
	sbc VAPU_03_OLD
	beq @noHi
	bmi @down
	cmp #$02
	bcs @normal
	lda VAPU_03
	and #$07
	sta VAPU_03_OLD
	lda #$40
	sta APU_17
	lda #$FF
	sta APU_02
	lda #$87
	sta APU_01
	lda #$C0
	sta APU_17
	lda #$0F
	sta APU_01
	jmp @noHi
	
@down:	cmp #$FD
	bcc @normal
	lda VAPU_03
	and #$07
	sta VAPU_03_OLD
	lda #$40
	sta APU_17
	lda #$00
	sta APU_02
	lda #$8F
	sta APU_01
	lda #$C0
	sta APU_17
	lda #$0F
	sta APU_01
	jmp @noHi


@normal:	lda VAPU_03
	and #$07
	cmp VAPU_03_OLD
	beq @noHi
	sta VAPU_03_OLD
	sta APU_03
@noHi:	lda VAPU_02
	sta APU_02
	rts


	.ELSE
	lda VAPU_03
	cmp VAPU_03_OLD
	beq :+
	sta APU_03
	sta VAPU_03_OLD
:	rts
	.ENDIF
	
	
writeAPU_B:	lda VAPU_04
	sta $4004
	lda VAPU_06
	sta $4006

	.IF 1=1
	lda plyrEchoWrite+1
	bne @normal
	lda VAPU_07_OLD
	bmi @normal
	lda VAPU_07
	and #$07
	sec
	sbc VAPU_07_OLD
	beq @noHi
	bmi @down
	cmp #$02
	bcs @normal
	lda VAPU_07
	and #$07
	sta VAPU_07_OLD
	lda #$40
	sta APU_17
	lda #$FF
	sta APU_06
	lda #$87
	sta APU_05
	lda #$C0
	sta APU_17
	lda #$0F
	sta APU_05
	jmp @noHi
	
@down:	cmp #$FD
	bcc @normal
	lda VAPU_07
	and #$07
	sta VAPU_07_OLD
	lda #$40
	sta APU_17
	lda #$00
	sta APU_06
	lda #$8F
	sta APU_05
	lda #$C0
	sta APU_17
	lda #$0F
	sta APU_05
	jmp @noHi


@normal:	lda VAPU_07
	and #$07
	cmp VAPU_07_OLD
	beq @noHi
	sta VAPU_07_OLD
	sta APU_07
@noHi:	lda VAPU_06
	sta APU_06
	rts



	.ELSE
	lda VAPU_07
	cmp VAPU_07_OLD
	beq :+
	sta $4007
	sta VAPU_07_OLD
:	rts
	.ENDIF

writeAPU_C:	lda VAPU_08
	sta $4008
	lda VAPU_0A
	sta $400A
	lda VAPU_0B
	sta $400B
	rts

writeAPU_D:	lda VAPU_0C
	sta $400C
	lda VAPU_0E
	sta $400E

	rts
	
	.include "commonTables.asm"