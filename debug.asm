	.include "macros.asm"
debugNumbers:
	setdmapos 20,2
	lda noteCounter
	jsr phex
	lda #$FF
	sta $2007
	lda debug1
	jsr phex
	rts
	

phex:	pha
	lsr a
	lsr a
	lsr a
	lsr a
	sta $2007
	pla
	and #$0F
	sta $2007
	rts
	
	
	
