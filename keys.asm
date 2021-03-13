;------------------------------------------------------------------------------
; KEY REPEAT HANDLING
;------------------------------------------------------------------------------
keyRepeatRateStart = 24
keyRepeatRateSelect = 24
keyRepeatSpeed = 1
keyRepeatRateA = 12;8
keyRepeatRateB = 12;8
keyRepeatDelay = 8

initKeyRepeats:
	lda #$00
	sta keyRepeatA
	sta keyRepeatB
	sta keyRepeatUD
	sta keyRepeatLR
	sta keyRepeatStart
	sta keyRepeatSelect

	sta keyReleaseA
	sta keyReleaseB
	sta keyReleaseStart
	sta keyReleaseSelect
	rts
	
checkRepeatKeyB:
	;lda PAD1_sel
	;bne @x
	lda keyDelayB
	beq @no_delay
	dec keyDelayB
	rts
		
@no_delay:	lda keyReleaseB
	beq @a
	dec keyReleaseB
	rts
@a:	lda PAD1_fireb
	bne @b
	lda keyRepeatB
	beq @x
	cmp #keyRepeatRateB
	bcs @b0
	inc keyReleaseB
@b0:	lda #$00
	sta keyRepeatB
	rts
@b:	clc
	adc keyRepeatB
	bmi @x
	sta keyRepeatB
@x:	rts

checkRepeatKeyA:
	;lda PAD1_sel
	;bne @x
	lda keyDelayA
	beq @no_delay
	dec keyDelayA
	rts
		
@no_delay:	lda keyReleaseA
	beq @a
	dec keyReleaseA
	rts
@a:	lda PAD1_firea
	bne @b
	lda keyRepeatA
	beq @x
	cmp #keyRepeatRateA
	bcs @b0
	inc keyReleaseA
@b0:	lda #$00
	sta keyRepeatA
	rts
@b:	clc
	adc keyRepeatA
	bmi @x
	sta keyRepeatA
@x:	rts
		
checkRepeatKeyUD:
	lda keyDelayUD
	beq @no_delay
	dec keyDelayUD
	rts
		
@no_delay:	lda PAD1_ud
	bne @do_key
	sta keyRepeatUD
	sta keyRepeatOldUD
	lda #keyRepeatDelay
	sta keyRepeatRateUD
	rts
		
@do_key:	cmp keyRepeatOldUD
	beq @same_key
	sta keyRepeatOldUD
	rts
		
@same_key:	lda keyRepeatRateUD
	beq @do_repeat
	dec keyRepeatRateUD
	rts
		
@do_repeat:	sta keyRepeatUD
	inc keyRepeatCounterUD
	lda keyRepeatCounterUD
	and #keyRepeatSpeed
	bne @a
	lda keyRepeatOldUD
	sta keyRepeatUD
@a:	rts	
		

checkRepeatKeyLR:
	lda keyDelayLR
	beq @no_delay
	dec keyDelayLR
	rts
		
@no_delay:	lda PAD1_lr
	bne @do_key
	sta keyRepeatLR
	sta keyRepeatOldLR
	lda #keyRepeatDelay
	sta keyRepeatRateLR
	rts
		
@do_key:	cmp keyRepeatOldLR
	beq @same_key
	sta keyRepeatOldLR
	rts
		
@same_key:	lda keyRepeatRateLR
	beq @do_repeat
	dec keyRepeatRateLR
	rts
		
@do_repeat:	sta keyRepeatLR
	inc keyRepeatCounterLR
	lda keyRepeatCounterLR
	and #keyRepeatSpeed
	bne @a
	lda keyRepeatOldLR
	sta keyRepeatLR
@a:	rts	
		

checkRepeatKeyStart:
	lda keyReleaseStart
	beq @a
	dec keyReleaseStart
	rts
@a:	lda PAD1_str
	bne @b
	lda keyRepeatStart
	beq @x
	cmp #keyRepeatRateStart
	bcs @b0
	inc keyReleaseStart
@b0:	lda #$00
	sta keyRepeatStart
	rts
@b:	clc
	adc keyRepeatStart
	bmi @x
	sta keyRepeatStart
@x:	rts

checkRepeatKeySelect:
	lda keyReleaseSelect
	beq @a
	dec keyReleaseSelect
	rts
@a:	lda PAD1_sel
	bne @b
	lda keyRepeatSelect
	beq @x
	cmp #keyRepeatRateSelect
	bcs @b0
	inc keyReleaseSelect
@b0:	lda #$00
	sta keyRepeatSelect
	rts
@b:	clc
	adc keyRepeatSelect
	bmi @x
	sta keyRepeatSelect
@x:	rts