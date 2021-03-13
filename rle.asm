;RLE decompressor by Shiru (NESASM version)
;uses 4 bytes in zero page
;decompress data from an address in X/Y to PPU_DATA

RLE_LOW	= $00
RLE_HIGH	= RLE_LOW+1
RLE_TAG	= RLE_HIGH+1
RLE_BYTE	= RLE_TAG+1


unrle:	stx RLE_LOW
	sty RLE_HIGH
	ldy #$00
	jsr @rle_byte
	sta RLE_TAG
:	jsr rle_byte
	cmp RLE_TAG
	beq :+
	sta PPU_DATA
	sta RLE_BYTE
	bne :-
:	jsr rle_byte
	cmp #$00
	beq :++
	tax
	lda RLE_BYTE
:	sta PPU_DATA
	dex
	bne :-
	beq :---
:	rts

@rle_byte
	lda (RLE_LOW),y
	inc RLE_LOW
	bne :+
	inc RLE_HIGH
:	rts