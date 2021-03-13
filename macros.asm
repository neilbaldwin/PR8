;------------------------------------------------------------------------------
; Set screen write position, only for debugging
;------------------------------------------------------------------------------
	.MACRO setdmapos _x,_y
	.LOCAL _scnadd
_scnadd 	= SCREEN +(_y*$20)+_x
	lda #>_scnadd
	sta $2006
	lda #<_scnadd
	sta $2006
	.ENDMACRO

;------------------------------------------------------------------------------
; Swap Sign of a number
;------------------------------------------------------------------------------
	.MACRO swapSign _number
	lda _number
	eor #$FF
	clc
	adc #$01
	sta _number
	.ENDMACRO