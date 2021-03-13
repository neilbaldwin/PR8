.segment "CODE_01"
	.include "pr8.h"
	.include "nesaudio.h"
	.include "synth_macros.asm"
	.include "player.asm"
	
.segment "RESET_BANKED_1"
	.include "reset_stub.asm"