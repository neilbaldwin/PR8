.segment "CODE_FIXED"
	.include "pr8.h"
	.include "reset.asm"
.segment "DPCM"
	.include "dpcm.asm"

.segment "RESET_FIXED"
	.include "reset_stub.asm"
