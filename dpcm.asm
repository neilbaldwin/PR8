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

;kick01.dmc
;kick02.dmc
;kick03.dmc
;kick04.dmc
;kick06.dmc
;kick08.dmc
;kick10.dmc
;kick14.dmc
;kick15.dmc
;kick18.dmc
;kick19.dmc
;kick20.dmc
;kick21.dmc
;kick25.dmc
;kick26.dmc
;kick30.dmc
;kick31.dmc
;kick32.dmc
;kick36.dmc
;kick44.dmc
;kick45.dmc
;kick48.dmc
;snare03.dmc
;snare05.dmc
;snare07.dmc
;snare11.dmc
;snare12.dmc
;snare13.dmc
;snare14.dmc
;snare16.dmc
;snare17.dmc
;snare19.dmc
;snare20.dmc
;snare21.dmc
;perc002.dmc
;perc003.dmc
;perc004.dmc
;perc005.dmc
;perc006.dmc
;perc007.dmc
;perc009.dmc
;perc011.dmc
;perc012.dmc
;perc015.dmc
;perc019.dmc
;perc020.dmc
;perc024.dmc
;perc026.dmc
;perc032.dmc
;perc037.dmc
;perc038.dmc
;perc045.dmc
;perc048.dmc
;perc049.dmc
;perc050.dmc
;perc062.dmc
;perc070.dmc
;perc075.dmc
;perc081.dmc
;perc088.dmc
;perc089.dmc
;perc090.dmc
;perc091.dmc
;perc092.dmc
;perc093.dmc
;perc097.dmc
;perc099.dmc
;perc100.dmc
;perc101.dmc
;perc102.dmc
;perc110.dmc
;perc118.dmc
;perc132.dmc
;perc140.dmc
;perc143.dmc
;perc146.dmc
;perc150.dmc


		

