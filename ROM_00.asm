	.include "pr8.h"

.segment "HEADER"
	.byte "NES",$1a 	; iNES identifier
	.byte $08		; Number of PRG-ROM blocks
	.byte $00		; Number of CHR-ROM blocks
	.BYTE %00010010, %00001000
	
	.IF PAL_VERSION=1
	.BYTE %00000000
	.BYTE %00000000
	.ELSE
	.BYTE 0,0
	.ENDIF
	.BYTE $90,$07,$00,$00,$00,$00

.segment "CODE_00"
	.include "macros.asm"
	.include "editor.asm"

.segment "RESET_BANKED_0"
	.include "reset_stub.asm"