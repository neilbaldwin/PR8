EDIT_GRID_MENU	= 0
EDIT_DRUM_MENU	= 1
EDIT_SONG_MENU	= 2
EDIT_ECHO_MENU	= 3
EDIT_CLEAR_MENU = 4

editMenuText:
	.BYTE $7b,$1f,$23,$1d,$ff,$14,$13,$18,$23,$ff,$7c
	.BYTE $7b,$4f,$42,$4f,$58,$fc,$4f,$47,$51,$fc,$7c
	.BYTE $7b,$fc,$42,$4f,$58,$fc,$4f,$53,$4d,$fc,$7c
	.BYTE $7b,$fc,$42,$54,$53,$fc,$4f,$47,$51,$fc,$7c
	.BYTE $7b,$fc,$42,$54,$53,$fc,$4f,$53,$4d,$fc,$7c
	.BYTE $7e,$7f,$7f,$7f,$7f,$7d,$7d,$7d,$7d,$7f,$fe
	.BYTE $7b,$13,$21,$1c,$ff,$14,$13,$18,$23,$ff,$7c
	.BYTE $7b,$fc,$42,$4f,$58,$fc,$43,$51,$4c,$fc,$7c
	.BYTE $7b,$fc,$42,$54,$53,$fc,$43,$51,$4c,$fc,$7c
	.BYTE $7b,$fc,$52,$56,$40,$4f,$fc,$40,$41,$fc,$7c
	.BYTE $7b,$fc,$fc,$fc,$fc,$fc,$fc,$fc,$fc,$fc,$7c
	.BYTE $7e,$7f,$7f,$7f,$7f,$7d,$7d,$7d,$7d,$7f,$fe
	.BYTE $7b,$22,$1d,$16,$ff,$14,$13,$18,$23,$ff,$7c
	.BYTE $7b,$fc,$4f,$52,$53,$fc,$4b,$4f,$fc,$fc,$7c
	.BYTE $7b,$fc,$48,$4d,$52,$fc,$4b,$4f,$fc,$fc,$7c
	.BYTE $7b,$fc,$fc,$fc,$fc,$fc,$fc,$fc,$fc,$fc,$7c
	.BYTE $7b,$fc,$fc,$fc,$fc,$fc,$fc,$fc,$fc,$fc,$7c
	.BYTE $7e,$7f,$7f,$7f,$7f,$7d,$7d,$7d,$7d,$7f,$fe
	.BYTE $7b,$1f,$23,$1d,$ff,$14,$12,$17,$1e,$ff,$7c
	.BYTE $7b,$40,$fa,$fc,$00,$fc,$43,$00,$00,$fc,$7c
	.BYTE $7b,$41,$fa,$fc,$00,$fc,$52,$00,$00,$fc,$7c
	.BYTE $7b,$43,$fa,$fc,$00,$fc,$af,$fa,$fc,$fc,$7c
	.BYTE $7b,$fc,$fc,$fc,$fc,$fc,$fc,$fc,$fc,$fc,$7c
	.BYTE $7e,$7d,$7d,$7d,$7d,$7d,$7d,$7d,$7d,$7f,$fe
	.BYTE $7b,$12,$1b,$21,$ff,$1c,$14,$1d,$24,$ff,$7c
	.BYTE $7b,$fc,$42,$4b,$51,$fc,$52,$4d,$46,$fc,$7c
	.BYTE $7b,$fc,$42,$4b,$51,$fc,$4f,$53,$4d,$fc,$7c
	.BYTE $7b,$fc,$42,$4b,$51,$fc,$4f,$47,$51,$fc,$7c
	.BYTE $7b,$fc,$42,$4b,$51,$fc,$43,$51,$4c,$fc,$7c
	.BYTE $7b,$fc,$42,$4b,$51,$fc,$40,$4b,$4b,$fc,$7c

editMenuLo:	.REPEAT 5,i
	.BYTE <(editMenuText+i*66)
	.ENDREPEAT

editMenuHi:	.REPEAT 5,i
	.BYTE >(editMenuText+i*66)
	.ENDREPEAT
	


;------------------------------------------------------------------------------
; INFO TEXT
;------------------------------------------------------------------------------
infoTextIndexes:
	.REPEAT 16,i
	.BYTE i*12
	.ENDREPEAT

MSG_BLANK	= $00		;done
MSG_DRM_COPY	= $01		;done
MSG_PTN_COPY	= $02		;done		
MSG_PHR_COPY	= $03		;done
MSG_LOOP_COPY	= $04
MSG_PASTE	= $05
MSG_INSERT	= $06
MSG_PTRN	= $07		;done
MSG_SONG	= $08		;done
MSG_CONFIRM	= $09
MSG_PASTE_ERROR = $0A
MSG_CLONE_ERROR = $0B
	
infoMessages:	
	.BYTE $ff,$ff,$ff,$ff,$ff,$ff
	.BYTE $ff,$ff,$ff,$ff,$ff,$ff
	.BYTE $43,$51,$4c,$fc,$5c,$5c
	.BYTE $42,$4e,$4f,$48,$44,$43
	.BYTE $4f,$53,$4d,$fc,$5c,$5c
	.BYTE $42,$4e,$4f,$48,$44,$43
	.BYTE $4f,$47,$51,$fc,$5c,$5c
	.BYTE $42,$4e,$4f,$48,$44,$43
	.BYTE $4b,$4e,$4e,$4f,$fc,$fc
	.BYTE $42,$4e,$4f,$48,$44,$43
	.BYTE $4f,$40,$52,$53,$44,$6f
	.BYTE $6d,$4d,$fc,$6e,$58,$fc
	.BYTE $48,$4d,$52,$51,$53,$6f
	.BYTE $6d,$4d,$fc,$6e,$58,$fc
	.BYTE $5f,$ff,$ff,$2a,$ff,$ff
	.BYTE $4f,$53,$4d,$fc,$fc,$fc
	.BYTE $5f,$ff,$ff,$2a,$ff,$ff
	.BYTE $52,$4e,$4d,$46,$fc,$fc
	.BYTE $52,$54,$51,$44,$fc,$6f
	.BYTE $6d,$4d,$fc,$6e,$58,$fc
	.BYTE $4f,$40,$52,$53,$44,$fc
	.BYTE $44,$51,$51,$4e,$51,$fc
	.BYTE $42,$4b,$4e,$4d,$44,$fc
	.BYTE $44,$51,$51,$4e,$51,$fc



