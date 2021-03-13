
patternTableLo:	.REPEAT numberOfPatterns,i
	.BYTE <(patterns + (i * bytesPerPattern))
	.ENDREPEAT

patternTableHi:	.REPEAT numberOfPatterns,i
	.BYTE >(patterns + (i * bytesPerPattern))
	.ENDREPEAT

phraseTableLo:	.REPEAT phrasesPerBank,i
	.BYTE <(phrases0+(i * stepsPerPhrase * bytesPerPhraseStep))
	.ENDREPEAT
	.REPEAT phrasesPerBank,i
	.BYTE <(phrases1+(i * stepsPerPhrase * bytesPerPhraseStep))
	.ENDREPEAT
		
phraseTableHi:	.REPEAT phrasesPerBank,i
	.BYTE >(phrases0+(i * stepsPerPhrase * bytesPerPhraseStep))
	.ENDREPEAT
	.REPEAT phrasesPerBank,i
	.BYTE >(phrases1+(i * stepsPerPhrase * bytesPerPhraseStep))
	.ENDREPEAT
	
phraseBanks:	.REPEAT phrasesPerBank
	.BYTE WRAM_PHRASES_0
	.ENDREPEAT
	
	.REPEAT phrasesPerBank
	.BYTE WRAM_PHRASES_1
	.ENDREPEAT
		
songTableLo:	.REPEAT numberOfSongs,i
	.BYTE <(songs+(i * bytesPerSong))
	.ENDREPEAT
	
songTableHi:	.REPEAT numberOfSongs,i
	.BYTE >(songs+(i * bytesPerSong))
	.ENDREPEAT