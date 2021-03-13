.segment "CODE_02"
	.include "pr8.h"
	.include "nesaudio.h"
	.include "synth_macros.asm"

	.include "synth.asm"
	
.segment "RESET_BANKED_2"
	.include "reset_stub.asm"