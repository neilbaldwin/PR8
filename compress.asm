;
; Sequencer Pattern Compress/Decompress (RLE)
;
compress:
	lda #WRAM_PATTERNS
	jsr setMMC1r1
		
	lda #<patterns
	sta tmp0
	lda #>patterns
	sta tmp1
	lda #<$7000
	sta tmp2
	lda #>$7000
	sta tmp3
	
	ldy #$00
	lda #$FF
:	sta (tmp2),y
	iny
	bne :-
	
	ldx #$60		;96 blocks
	lda #$00
	sta tmp4
	
:	ldy #$00
	lda (tmp0),y	;0?
	bne :++
	lda tmp4		;yes, doing RLE?
	bne :+			;yes
	sta (tmp2),y	;no, store 0 token
	inc tmp2		;update dest address
	bne :+
	inc tmp3
:	inc tmp4		;update RLE count
	bne :+++		;should never go over 255 (pattern would be 255 * 5)

:	pha				;save byte
	lda tmp4		;any RLE?
	beq :+			;no
	sta (tmp2),y	;yes, write count
	lda #$00		;clear count
	sta tmp4
	inc tmp2		;update dest address
	bne :+
	inc tmp3
	
:	pla				;retrieve byte
	sta (tmp2),y
	iny
	lda (tmp0),y
	sta (tmp2),y
	iny
	lda (tmp0),y
	sta (tmp2),y
	iny
	lda (tmp0),y
	sta (tmp2),y
	iny
	lda (tmp0),y
	sta (tmp2),y

	lda tmp2
	clc
	adc #$05
	sta tmp2
	bcc :+
	inc tmp3
	
:	lda tmp0
	clc
	adc #$05
	sta tmp0
	bcc :+
	inc tmp1
	
:	dex
	bne :------

	ldy #$00
	lda tmp4
	beq :+
	sta (tmp2),y
	iny
:	lda #$00
	sta (tmp2),y
	iny
	sta (tmp2),y

	rts

decompress:	lda #<$7000
	sta tmp0
	lda #>$7000
	sta tmp1
	lda #<$7200
	sta tmp2
	lda #>$7200
	sta tmp3
	
:	ldy #$00
	lda (tmp0),y		;token?
	bne :++				;no
	iny					;yes, get count
	lda (tmp0),y
	beq :+++++			;00 00 so done
	tax					;otherwise load count in X
	
:	ldy #$00			;clear 5 bytes
	tya
	sta (tmp2),y
	iny
	sta (tmp2),y
	iny
	sta (tmp2),y
	iny
	sta (tmp2),y
	iny
	sta (tmp2),y
	
	lda tmp2			;update dest pointer
	clc
	adc #$05
	sta tmp2
	lda tmp3
	adc #$00
	sta tmp3
	dex					;dec count
	bne :-				;done?
	
	lda tmp0			;yes update source pointer
	clc
	adc #$02
	sta tmp0
	lda tmp2
	clc
	adc #$00
	sta tmp2
	jmp :--				;get more

:	sta (tmp2),y		;copy 5 bytes
	iny
	lda (tmp0),y
	sta (tmp2),y
	iny
	lda (tmp0),y
	sta (tmp2),y
	iny
	lda (tmp0),y
	sta (tmp2),y
	iny
	lda (tmp0),y
	sta (tmp2),y
	
	lda tmp0			;update source 
	clc
	adc #$05
	sta tmp0
	bne :+
	inc tmp1
	
:	lda tmp2			;update dest
	clc
	adc #$05
	sta tmp2
	bne :+
	inc tmp3
:	
	jmp :-----			;get more
	
:	rts
	