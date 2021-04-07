;--------------------------------------------------------------------------------						
; DO NOT CHANGE: Macros to set start address and length value of each sample
;--------------------------------------------------------------------------------						

		.MACRO DEF_DPCM address
	 	;.BYTE <(address >> 6)
		.BYTE <(address / 64)
		.ENDMACRO
		
		.MACRO END_DPCM address
		;.BYTE <(address >> 6)
		.BYTE <(address / 64)
		.ENDMACRO

;--------------------------------------------------------------------------------
; Sample Address table
;
; Format: DEF_DPCM <sample label>,LOOPING or NOT_LOOPING
;         Need "END_DPCM dmcEnd" at end of table
;--------------------------------------------------------------------------------
;.EXPORT dmcAddressTable
dmcAddressTable:
		DEF_DPCM kick01
		DEF_DPCM snare01
		DEF_DPCM perc01
		DEF_DPCM perc02
		DEF_DPCM perc03

		END_DPCM dmcEnd


;--------------------------------------------------------------------------------
; Sample Data
;
; Format: <sample label> incbin <sample file name>
;         Need "dmcEnd:" at end of table
;--------------------------------------------------------------------------------		
		.ALIGN 64
kick01:	.incbin "DPCM/kick06.dmc"
snare01:	.incbin "DPCM/snare20.dmc"
perc01:	.incbin "DPCM/perc100.dmc"
perc02:	.incbin "DPCM/perc101.dmc"
perc03:	.incbin "DPCM/perc102.dmc"
;100
dmcEnd:
