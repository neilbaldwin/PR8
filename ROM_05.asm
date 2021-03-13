.segment "CODE_05"
	.include "pr8.h"
	.include "screen.asm"
nameTable:
	.incbin "pr8.nam"
errorNameTable:
	.incbin "pr8error.nam"
	
font:	.incbin "pr8.chr"
sprites:	.incbin "pr8spr.chr"

	
.segment "RESET_BANKED_5"
	.include "reset_stub.asm"
