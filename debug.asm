	.include "macros.asm"
debugNumbers:
	setdmapos 20,2
	lda debug0
	jsr phex
	lda #$FF
	sta $2007
	lda cursorX_track
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
	
	
	
