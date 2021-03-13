

SCN_GRID_ROW_00	= SCREEN + (9 * 32) + 10
SCN_GRID_ROW_01	= SCREEN + (10 * 32) + 10
SCN_GRID_ROW_02	= SCREEN + (11 * 32) + 10
SCN_GRID_ROW_03	= SCREEN + (12 * 32) + 10
SCN_GRID_ROW_04	= SCREEN + (13 * 32) + 10
SCN_GRID_ROW_05	= SCREEN + (14 * 32) + 10

SCN_TRACK_DRUM_00 = SCREEN + (9 * 32) + 4
SCN_TRACK_DRUM_01 = SCREEN + (10 * 32) + 4
SCN_TRACK_DRUM_02 = SCREEN + (11 * 32) + 4
SCN_TRACK_DRUM_03 = SCREEN + (12 * 32) + 4
SCN_TRACK_DRUM_04 = SCREEN + (13 * 32) + 4
SCN_TRACK_DRUM_05 = SCREEN + (14 * 32) + 4

SCN_TRIGGER_00	= SCREEN + (10 * 32) + 27
SCN_TRIGGER_01	= SCREEN + (11 * 32) + 28
SCN_TRIGGER_02	= SCREEN + (12 * 32) + 28
SCN_TRIGGER_03	= SCREEN + (13 * 32) + 28
SCN_TRIGGER_04	= SCREEN + (14 * 32) + 28

SCN_GRID_PATTERN = SCREEN + (7 * 32) + 12
SCN_GRID_SPEED	= SCREEN + (7 * 32) + 17
SCN_GRID_SWING = SCREEN + (7 * 32) + 22
SCN_GRID_STEPS = SCREEN + (7 * 32) + 27

SCN_VOICEA_00	= SCREEN + (17 * 32) + 4
SCN_VOICEA_01	= SCREEN + (18 * 32) + 4
SCN_VOICEA_02	= SCREEN + (19 * 32) + 4
SCN_VOICEA_03	= SCREEN + (17 * 32) + 7
SCN_VOICEA_04	= SCREEN + (18 * 32) + 7
SCN_VOICEA_05	= SCREEN + (19 * 32) + 7
SCN_VOICEA_06	= SCREEN + (17 * 32) + 10
SCN_VOICEA_07	= SCREEN + (18 * 32) + 10
SCN_VOICEA_08	= SCREEN + (19 * 32) + 10
SCN_VOICEA_09	= SCREEN + (17 * 32) + 13
SCN_VOICEA_0A	= SCREEN + (18 * 32) + 13

SCN_VOICEB_00	= SCREEN + (17 * 32) + 18
SCN_VOICEB_01	= SCREEN + (18 * 32) + 18
SCN_VOICEB_02	= SCREEN + (19 * 32) + 18
SCN_VOICEB_03	= SCREEN + (17 * 32) + 21
SCN_VOICEB_04	= SCREEN + (18 * 32) + 21
SCN_VOICEB_05	= SCREEN + (19 * 32) + 21
SCN_VOICEB_06	= SCREEN + (17 * 32) + 24
SCN_VOICEB_07	= SCREEN + (18 * 32) + 24
SCN_VOICEB_08	= SCREEN + (19 * 32) + 24
SCN_VOICEB_09	= SCREEN + (17 * 32) + 27
SCN_VOICEB_0A	= SCREEN + (18 * 32) + 27

SCN_VOICEC_00	= SCREEN + (22 * 32) + 4
SCN_VOICEC_01	= SCREEN + (23 * 32) + 4

SCN_VOICEC_02	= SCREEN + (22 * 32) + 7
SCN_VOICEC_03	= SCREEN + (23 * 32) + 7
SCN_VOICEC_04	= SCREEN + (24 * 32) + 7

SCN_VOICEC_05	= SCREEN + (22 * 32) + 10
SCN_VOICEC_06	= SCREEN + (23 * 32) + 10

SCN_VOICED_00	= SCREEN + (22 * 32) + 14

SCN_VOICED_01	= SCREEN + (22 * 32) + 17
SCN_VOICED_02	= SCREEN + (23 * 32) + 17
SCN_VOICED_03	= SCREEN + (24 * 32) + 17

SCN_VOICED_04	= SCREEN + (22 * 32) + 20
SCN_VOICED_05	= SCREEN + (23 * 32) + 20
SCN_VOICED_06	= SCREEN + (24 * 32) + 20

SCN_VOICEE_00	= SCREEN + (22 * 32) + 24
SCN_VOICEE_01	= SCREEN + (23 * 32) + 24
SCN_VOICEE_02	= SCREEN + (24 * 32) + 24

SCN_VOICEE_03	= SCREEN + (22 * 32) + 27
SCN_VOICEE_04	= SCREEN + (23 * 32) + 27

SCN_DRUM_NUMBER	= SCREEN + (26 * 32) + 5
SCN_DRUM_NAME	= SCREEN + (26 * 32) + 11
SCN_DRUM_P1	= SCREEN + (26 * 32) + 16
SCN_DRUM_P2	= SCREEN + (26 * 32) + 21
SCN_DRUM_P3	= SCREEN + (26 * 32) + 26

SCN_COPY_INFO_00 = SCREEN + (4 * 32) + 4
SCN_COPY_INFO_01 = SCREEN + (5 * 32) + 4

SCN_SONG_NUMBER = SCREEN + (5 * 32) + 13
SCN_SONG_SPEED = SCREEN + (4 * 32) + 18
SCN_SONG_SWING = SCREEN + (5 * 32) + 18
SCN_SONG_BAR = SCREEN + (4 * 32) + 23
SCN_SONG_PATTERN = SCREEN + (5 * 32) + 23
SCN_SONG_LOOP_START = SCREEN + (4 * 32) + 28
SCN_SONG_LOOP_LENGTH = SCREEN + (5 * 32) + 28


process_DMA_queue:
	ldx dmaProcessBuffer
	cpx #$FF
	bne :+
	rts
	
:	lda _processLo,x
	sta processVector+0
	lda _processHi,x
	sta processVector+1
	jmp (processVector)
	rts

_processLo:	.LOBYTES _dmaTrackDrum00,_dmaTrackDrum01,_dmaTrackDrum02
	.LOBYTES _dmaTrackDrum03,_dmaTrackDrum04,_dmaTrackDrum05
	.LOBYTES _dmaTrackDrumAll

	.LOBYTES _dmaGridRow00,_dmaGridRow01,_dmaGridRow02
	.LOBYTES _dmaGridRow03,_dmaGridRow04,_dmaGridRow05
	.LOBYTES _dmaGridRowAll
	
	.LOBYTES _dmaTrackDrumTop,_dmaTrackDrumBottom
	.LOBYTES _dmaGridRowTop,_dmaGridRowBottom
	
	.LOBYTES _dmaTriggerParameters
	
	.LOBYTES _dmaGridPattern
	
	.LOBYTES _dmaVoiceA,_dmaVoiceB,_dmaVoiceC,_dmaVoiceD,_dmaVoiceE
	
	.LOBYTES _dmaDrumAux
	
	.LOBYTES _dmaDrumAll
	
	.LOBYTES _dmaCopyInfoAll
	
	.LOBYTES _dmaSongAll
	.LOBYTES _dmaSongSpeed,_dmaSongBar,_dmaSongLoop
	
	.LOBYTES _dmaCopyInfoTop,_dmaCopyInfoBottom
	
_processHi:	.HIBYTES _dmaTrackDrum00,_dmaTrackDrum01,_dmaTrackDrum02
	.HIBYTES _dmaTrackDrum03,_dmaTrackDrum04,_dmaTrackDrum05
	.HIBYTES _dmaTrackDrumAll

	.HIBYTES _dmaGridRow00,_dmaGridRow01,_dmaGridRow02
	.HIBYTES _dmaGridRow03,_dmaGridRow04,_dmaGridRow05
	.HIBYTES _dmaGridRowAll

	.HIBYTES _dmaTrackDrumTop,_dmaTrackDrumBottom
	.HIBYTES _dmaGridRowTop,_dmaGridRowBottom
	
	.HIBYTES _dmaTriggerParameters
	
	.HIBYTES _dmaGridPattern
	
	.HIBYTES _dmaVoiceA,_dmaVoiceB,_dmaVoiceC,_dmaVoiceD,_dmaVoiceE
	
	.HIBYTES _dmaDrumAux
	
	.HIBYTES _dmaDrumAll

	.HIBYTES _dmaCopyInfoAll

	.HIBYTES _dmaSongAll
	.HIBYTES _dmaSongSpeed,_dmaSongBar,_dmaSongLoop
	
	.HIBYTES _dmaCopyInfoTop,_dmaCopyInfoBottom
	


_dmaSongAll:	
	lda #>SCN_SONG_NUMBER
	sta $2006
	lda #<SCN_SONG_NUMBER
	sta $2006
	lda scnSongBuffer+$00
	sta $2007
	lda scnSongBuffer+$01
	sta $2007
	jsr _dmaSongBar
	jsr _dmaSongLoop
	
_dmaSongSpeed:
	lda #>SCN_SONG_SPEED
	sta $2006
	lda #<SCN_SONG_SPEED
	sta $2006
	lda scnSongBuffer+$02
	sta $2007
	lda scnSongBuffer+$03
	sta $2007

	lda #>SCN_SONG_SWING
	sta $2006
	lda #<SCN_SONG_SWING
	sta $2006
	lda scnSongBuffer+$04
	sta $2007
	lda scnSongBuffer+$05
	sta $2007
	rts
	
_dmaSongLoop:
	lda #>SCN_SONG_LOOP_START
	sta $2006
	lda #<SCN_SONG_LOOP_START
	sta $2006
	lda scnSongBuffer+$06
	sta $2007
	lda scnSongBuffer+$07
	sta $2007

	lda #>SCN_SONG_LOOP_LENGTH
	sta $2006
	lda #<SCN_SONG_LOOP_LENGTH
	sta $2006
	lda scnSongBuffer+$08
	sta $2007
	lda scnSongBuffer+$09
	sta $2007
	rts
		
_dmaSongBar:
	lda #>SCN_SONG_BAR
	sta $2006
	lda #<SCN_SONG_BAR
	sta $2006
	lda scnSongBuffer+$0A
	sta $2007
	lda scnSongBuffer+$0B
	sta $2007

	lda #>SCN_SONG_PATTERN
	sta $2006
	lda #<SCN_SONG_PATTERN
	sta $2006
	lda scnSongBuffer+$0C
	sta $2007
	lda scnSongBuffer+$0D
	sta $2007
	rts	

	
_dmaCopyInfoAll:
	jsr _dmaCopyInfoTop
	jsr _dmaCopyInfoBottom
	rts
	
_dmaCopyInfoTop:
	lda #>SCN_COPY_INFO_00
	sta $2006
	lda #<SCN_COPY_INFO_00
	sta $2006
	lda scnCopyInfoBuffer+0
	sta $2007
	lda scnCopyInfoBuffer+1
	sta $2007
	lda scnCopyInfoBuffer+2
	sta $2007
	lda scnCopyInfoBuffer+3
	sta $2007
	lda scnCopyInfoBuffer+4
	sta $2007
	lda scnCopyInfoBuffer+5
	sta $2007
	rts

_dmaCopyInfoBottom:
	lda #>SCN_COPY_INFO_01
	sta $2006
	lda #<SCN_COPY_INFO_01
	sta $2006
	lda scnCopyInfoBuffer+6
	sta $2007
	lda scnCopyInfoBuffer+7
	sta $2007
	lda scnCopyInfoBuffer+8
	sta $2007
	lda scnCopyInfoBuffer+9
	sta $2007
	lda scnCopyInfoBuffer+10
	sta $2007
	lda scnCopyInfoBuffer+11
	sta $2007
	rts
	
_dmaDrumAll:
	jsr _dmaVoiceA
	jsr _dmaVoiceB
	jsr _dmaVoiceC
	jsr _dmaVoiceD
	jsr _dmaVoiceE
	jsr _dmaDrumAux
	rts
	
_dmaDrumAux:	lda #>SCN_DRUM_NUMBER
	sta $2006
	lda #<SCN_DRUM_NUMBER
	sta $2006
	lda scnDrumAuxBuffer + 0
	sta $2007
	lda scnDrumAuxBuffer + 1
	sta $2007

	lda #>SCN_DRUM_NAME
	sta $2006
	lda #<SCN_DRUM_NAME
	sta $2006
	lda scnDrumAuxBuffer + 2
	sta $2007
	lda scnDrumAuxBuffer + 3
	sta $2007
	lda scnDrumAuxBuffer + 4
	sta $2007

	lda #>SCN_DRUM_P1
	sta $2006
	lda #<SCN_DRUM_P1
	sta $2006
	lda scnDrumAuxBuffer + 5
	sta $2007
	lda scnDrumAuxBuffer + 6
	sta $2007
	lda scnDrumAuxBuffer + 7
	sta $2007

	lda #>SCN_DRUM_P2
	sta $2006
	lda #<SCN_DRUM_P2
	sta $2006
	lda scnDrumAuxBuffer + 8
	sta $2007
	lda scnDrumAuxBuffer + 9
	sta $2007
	lda scnDrumAuxBuffer + 10
	sta $2007

	lda #>SCN_DRUM_P3
	sta $2006
	lda #<SCN_DRUM_P3
	sta $2006
	lda scnDrumAuxBuffer + 11
	sta $2007
	lda scnDrumAuxBuffer + 12
	sta $2007
	lda scnDrumAuxBuffer + 13
	sta $2007

	rts

_dmaVoiceA:	lda #>SCN_VOICEA_00
	sta $2006
	lda #<SCN_VOICEA_00
	sta $2006
	lda scnVoiceABuffer + 0
	sta $2007
	lda scnVoiceABuffer + 1
	sta $2007

	lda #>SCN_VOICEA_01
	sta $2006
	lda #<SCN_VOICEA_01
	sta $2006
	lda scnVoiceABuffer + 2
	sta $2007
	lda scnVoiceABuffer + 3
	sta $2007

	lda #>SCN_VOICEA_02
	sta $2006
	lda #<SCN_VOICEA_02
	sta $2006
	lda scnVoiceABuffer + 4
	sta $2007
	lda scnVoiceABuffer + 5
	sta $2007

	lda #>SCN_VOICEA_03
	sta $2006
	lda #<SCN_VOICEA_03
	sta $2006
	lda scnVoiceABuffer + 6
	sta $2007
	lda scnVoiceABuffer + 7
	sta $2007
	
	lda #>SCN_VOICEA_04
	sta $2006
	lda #<SCN_VOICEA_04
	sta $2006
	lda scnVoiceABuffer + 8
	sta $2007
	lda scnVoiceABuffer + 9
	sta $2007

	lda #>SCN_VOICEA_05
	sta $2006
	lda #<SCN_VOICEA_05
	sta $2006
	lda scnVoiceABuffer + 10
	sta $2007
	lda scnVoiceABuffer + 11
	sta $2007

	lda #>SCN_VOICEA_06
	sta $2006
	lda #<SCN_VOICEA_06
	sta $2006
	lda scnVoiceABuffer + 12
	sta $2007
	lda scnVoiceABuffer + 13
	sta $2007

	lda #>SCN_VOICEA_07
	sta $2006
	lda #<SCN_VOICEA_07
	sta $2006
	lda scnVoiceABuffer + 14
	sta $2007
	lda scnVoiceABuffer + 15
	sta $2007
	
	lda #>SCN_VOICEA_08
	sta $2006
	lda #<SCN_VOICEA_08
	sta $2006
	lda scnVoiceABuffer + 16
	sta $2007
	lda scnVoiceABuffer + 17
	sta $2007

	lda #>SCN_VOICEA_09
	sta $2006
	lda #<SCN_VOICEA_09
	sta $2006
	lda scnVoiceABuffer + 18
	sta $2007
	lda scnVoiceABuffer + 19
	sta $2007

	lda #>SCN_VOICEA_0A
	sta $2006
	lda #<SCN_VOICEA_0A
	sta $2006
	lda scnVoiceABuffer + 20
	sta $2007
	lda scnVoiceABuffer + 21
	sta $2007
	rts

_dmaVoiceB:	lda #>SCN_VOICEB_00
	sta $2006
	lda #<SCN_VOICEB_00
	sta $2006
	lda scnVoiceBBuffer + 0
	sta $2007
	lda scnVoiceBBuffer + 1
	sta $2007

	lda #>SCN_VOICEB_01
	sta $2006
	lda #<SCN_VOICEB_01
	sta $2006
	lda scnVoiceBBuffer + 2
	sta $2007
	lda scnVoiceBBuffer + 3
	sta $2007

	lda #>SCN_VOICEB_02
	sta $2006
	lda #<SCN_VOICEB_02
	sta $2006
	lda scnVoiceBBuffer + 4
	sta $2007
	lda scnVoiceBBuffer + 5
	sta $2007

	lda #>SCN_VOICEB_03
	sta $2006
	lda #<SCN_VOICEB_03
	sta $2006
	lda scnVoiceBBuffer + 6
	sta $2007
	lda scnVoiceBBuffer + 7
	sta $2007

	lda #>SCN_VOICEB_04
	sta $2006
	lda #<SCN_VOICEB_04
	sta $2006
	lda scnVoiceBBuffer + 8
	sta $2007
	lda scnVoiceBBuffer + 9
	sta $2007

	lda #>SCN_VOICEB_05
	sta $2006
	lda #<SCN_VOICEB_05
	sta $2006
	lda scnVoiceBBuffer + 10
	sta $2007
	lda scnVoiceBBuffer + 11
	sta $2007

	lda #>SCN_VOICEB_06
	sta $2006
	lda #<SCN_VOICEB_06
	sta $2006
	lda scnVoiceBBuffer + 12
	sta $2007
	lda scnVoiceBBuffer + 13
	sta $2007

	lda #>SCN_VOICEB_07
	sta $2006
	lda #<SCN_VOICEB_07
	sta $2006
	lda scnVoiceBBuffer + 14
	sta $2007
	lda scnVoiceBBuffer + 15
	sta $2007
	
	lda #>SCN_VOICEB_08
	sta $2006
	lda #<SCN_VOICEB_08
	sta $2006
	lda scnVoiceBBuffer + 16
	sta $2007
	lda scnVoiceBBuffer + 17
	sta $2007

	lda #>SCN_VOICEB_09
	sta $2006
	lda #<SCN_VOICEB_09
	sta $2006
	lda scnVoiceBBuffer + 18
	sta $2007
	lda scnVoiceBBuffer + 19
	sta $2007

	lda #>SCN_VOICEB_0A
	sta $2006
	lda #<SCN_VOICEB_0A
	sta $2006
	lda scnVoiceBBuffer + 20
	sta $2007
	lda scnVoiceBBuffer + 21
	sta $2007
	rts
		
_dmaVoiceC:	lda #>SCN_VOICEC_00
	sta $2006
	lda #<SCN_VOICEC_00
	sta $2006
	lda scnVoiceCBuffer + 0
	sta $2007
	lda scnVoiceCBuffer + 1
	sta $2007

	lda #>SCN_VOICEC_01
	sta $2006
	lda #<SCN_VOICEC_01
	sta $2006
	lda scnVoiceCBuffer + 2
	sta $2007
	lda scnVoiceCBuffer + 3
	sta $2007

	lda #>SCN_VOICEC_02
	sta $2006
	lda #<SCN_VOICEC_02
	sta $2006
	lda scnVoiceCBuffer + 4
	sta $2007
	lda scnVoiceCBuffer + 5
	sta $2007
	

	lda #>SCN_VOICEC_03
	sta $2006
	lda #<SCN_VOICEC_03
	sta $2006
	lda scnVoiceCBuffer + 6
	sta $2007
	lda scnVoiceCBuffer + 7
	sta $2007

	lda #>SCN_VOICEC_04
	sta $2006
	lda #<SCN_VOICEC_04
	sta $2006
	lda scnVoiceCBuffer + 8
	sta $2007
	lda scnVoiceCBuffer + 9
	sta $2007

	lda #>SCN_VOICEC_05
	sta $2006
	lda #<SCN_VOICEC_05
	sta $2006
	lda scnVoiceCBuffer + 10
	sta $2007
	lda scnVoiceCBuffer + 11
	sta $2007
	

	lda #>SCN_VOICEC_06
	sta $2006
	lda #<SCN_VOICEC_06
	sta $2006
	lda scnVoiceCBuffer + 12
	sta $2007
	lda scnVoiceCBuffer + 13
	sta $2007
	rts

_dmaVoiceD:	lda #>SCN_VOICED_00
	sta $2006
	lda #<SCN_VOICED_00
	sta $2006
	lda scnVoiceDBuffer + 0
	sta $2007
	lda scnVoiceDBuffer + 1
	sta $2007

	lda #>SCN_VOICED_01
	sta $2006
	lda #<SCN_VOICED_01
	sta $2006
	lda scnVoiceDBuffer + 2
	sta $2007
	lda scnVoiceDBuffer + 3
	sta $2007

	lda #>SCN_VOICED_02
	sta $2006
	lda #<SCN_VOICED_02
	sta $2006
	lda scnVoiceDBuffer + 4
	sta $2007
	lda scnVoiceDBuffer + 5
	sta $2007
	

	lda #>SCN_VOICED_03
	sta $2006
	lda #<SCN_VOICED_03
	sta $2006
	lda scnVoiceDBuffer + 6
	sta $2007
	lda scnVoiceDBuffer + 7
	sta $2007

	lda #>SCN_VOICED_04
	sta $2006
	lda #<SCN_VOICED_04
	sta $2006
	lda scnVoiceDBuffer + 8
	sta $2007
	lda scnVoiceDBuffer + 9
	sta $2007

	lda #>SCN_VOICED_05
	sta $2006
	lda #<SCN_VOICED_05
	sta $2006
	lda scnVoiceDBuffer + 10
	sta $2007
	lda scnVoiceDBuffer + 11
	sta $2007
	

	lda #>SCN_VOICED_06
	sta $2006
	lda #<SCN_VOICED_06
	sta $2006
	lda scnVoiceDBuffer + 12
	sta $2007
	lda scnVoiceDBuffer + 13
	sta $2007
	rts
	
_dmaVoiceE:	lda #>SCN_VOICEE_00
	sta $2006
	lda #<SCN_VOICEE_00
	sta $2006
	lda scnVoiceEBuffer + 0
	sta $2007
	lda scnVoiceEBuffer + 1
	sta $2007

	lda #>SCN_VOICEE_01
	sta $2006
	lda #<SCN_VOICEE_01
	sta $2006
	lda scnVoiceEBuffer + 2
	sta $2007
	lda scnVoiceEBuffer + 3
	sta $2007

	lda #>SCN_VOICEE_02
	sta $2006
	lda #<SCN_VOICEE_02
	sta $2006
	lda scnVoiceEBuffer + 4
	sta $2007
	lda scnVoiceEBuffer + 5
	sta $2007
	
	lda #>SCN_VOICEE_03
	sta $2006
	lda #<SCN_VOICEE_03
	sta $2006
	lda scnVoiceEBuffer + 6
	sta $2007
	lda scnVoiceEBuffer + 7
	sta $2007

	lda #>SCN_VOICEE_04
	sta $2006
	lda #<SCN_VOICEE_04
	sta $2006
	lda scnVoiceEBuffer + 8
	sta $2007
	lda scnVoiceEBuffer + 9
	sta $2007
	rts

_dmaGridPattern:
	lda #>SCN_GRID_PATTERN
	sta $2006
	lda #<SCN_GRID_PATTERN
	sta $2006
	lda scnGridPatternBuffer + 0
	sta $2007
	lda scnGridPatternBuffer + 1
	sta $2007

	lda #>SCN_GRID_SPEED
	sta $2006
	lda #<SCN_GRID_SPEED
	sta $2006
	lda scnGridPatternBuffer + 2
	sta $2007
	lda scnGridPatternBuffer + 3
	sta $2007

	lda #>SCN_GRID_SWING
	sta $2006
	lda #<SCN_GRID_SWING
	sta $2006
	lda scnGridPatternBuffer + 4
	sta $2007
	lda scnGridPatternBuffer + 5
	sta $2007

	lda #>SCN_GRID_STEPS
	sta $2006
	lda #<SCN_GRID_STEPS
	sta $2006
	lda scnGridPatternBuffer + 6
	sta $2007
	lda scnGridPatternBuffer + 7
	sta $2007
	rts
	
	
_dmaTriggerParameters:
	lda #>SCN_TRIGGER_00
	sta $2006
	lda #<SCN_TRIGGER_00
	sta $2006
	lda scnTriggerBuffer + 0
	sta $2007
	lda scnTriggerBuffer + 1
	sta $2007
	lda scnTriggerBuffer + 2
	sta $2007

	lda #>SCN_TRIGGER_01
	sta $2006
	lda #<SCN_TRIGGER_01
	sta $2006
	lda scnTriggerBuffer + 3
	sta $2007
	lda scnTriggerBuffer + 4
	sta $2007

	lda #>SCN_TRIGGER_02
	sta $2006
	lda #<SCN_TRIGGER_02
	sta $2006
	lda scnTriggerBuffer + 5
	sta $2007
	lda scnTriggerBuffer + 6
	sta $2007

	lda #>SCN_TRIGGER_03
	sta $2006
	lda #<SCN_TRIGGER_03
	sta $2006
	lda scnTriggerBuffer + 7
	sta $2007
	lda scnTriggerBuffer + 8
	sta $2007
	
	lda #>SCN_TRIGGER_04
	sta $2006
	lda #<SCN_TRIGGER_04
	sta $2006
	lda scnTriggerBuffer + 9
	sta $2007
	lda scnTriggerBuffer + 10
	sta $2007
	rts


	
	

_dmaTrackDrumAll:
	jsr _dmaTrackDrum00
	jsr _dmaTrackDrum01
	jsr _dmaTrackDrum02
	jsr _dmaTrackDrum03
	jsr _dmaTrackDrum04
	jmp _dmaTrackDrum05
	
_dmaTrackDrumTop:
	jsr _dmaTrackDrum00
	jsr _dmaTrackDrum01
	jmp _dmaTrackDrum02

_dmaTrackDrumBottom:
	jsr _dmaTrackDrum03
	jsr _dmaTrackDrum04
	jmp _dmaTrackDrum05
	
_dmaTrackDrum00:
	lda #>SCN_TRACK_DRUM_00
	sta $2006
	lda #<SCN_TRACK_DRUM_00
	sta $2006
	lda scnTrackDrumBuffer + (0 * 4) + 0
	sta $2007
	lda scnTrackDrumBuffer + (0 * 4) + 1
	sta $2007
	lda #$FC
	sta $2007
	lda scnTrackDrumBuffer + (0 * 4) + 2
	sta $2007
	lda scnTrackDrumBuffer + (0 * 4) + 3
	sta $2007
	rts

_dmaTrackDrum01:
	lda #>SCN_TRACK_DRUM_01
	sta $2006
	lda #<SCN_TRACK_DRUM_01
	sta $2006
	lda scnTrackDrumBuffer + (1 * 4) + 0
	sta $2007
	lda scnTrackDrumBuffer + (1 * 4) + 1
	sta $2007
	lda #$FC
	sta $2007
	lda scnTrackDrumBuffer + (1 * 4) + 2
	sta $2007
	lda scnTrackDrumBuffer + (1 * 4) + 3
	sta $2007
	rts
	
_dmaTrackDrum02:
	lda #>SCN_TRACK_DRUM_02
	sta $2006
	lda #<SCN_TRACK_DRUM_02
	sta $2006
	lda scnTrackDrumBuffer + (2 * 4) + 0
	sta $2007
	lda scnTrackDrumBuffer + (2 * 4) + 1
	sta $2007
	lda #$FC
	sta $2007
	lda scnTrackDrumBuffer + (2 * 4) + 2
	sta $2007
	lda scnTrackDrumBuffer + (2 * 4) + 3
	sta $2007
	rts
	
_dmaTrackDrum03:
	lda #>SCN_TRACK_DRUM_03
	sta $2006
	lda #<SCN_TRACK_DRUM_03
	sta $2006
	lda scnTrackDrumBuffer + (3 * 4) + 0
	sta $2007
	lda scnTrackDrumBuffer + (3 * 4) + 1
	sta $2007
	lda #$FC
	sta $2007
	lda scnTrackDrumBuffer + (3 * 4) + 2
	sta $2007
	lda scnTrackDrumBuffer + (3 * 4) + 3
	sta $2007
	rts
	
_dmaTrackDrum04:
	lda #>SCN_TRACK_DRUM_04
	sta $2006
	lda #<SCN_TRACK_DRUM_04
	sta $2006
	lda scnTrackDrumBuffer + (4 * 4) + 0
	sta $2007
	lda scnTrackDrumBuffer + (4 * 4) + 1
	sta $2007
	lda #$FC
	sta $2007
	lda scnTrackDrumBuffer + (4 * 4) + 2
	sta $2007
	lda scnTrackDrumBuffer + (4 * 4) + 3
	sta $2007
	rts
	
_dmaTrackDrum05:
	lda #>SCN_TRACK_DRUM_05
	sta $2006
	lda #<SCN_TRACK_DRUM_05
	sta $2006
	lda scnTrackDrumBuffer + (5 * 4) + 0
	sta $2007
	lda scnTrackDrumBuffer + (5 * 4) + 1
	sta $2007
	lda #$FC
	sta $2007
	lda scnTrackDrumBuffer + (5 * 4) + 2
	sta $2007
	lda scnTrackDrumBuffer + (5 * 4) + 3
	sta $2007
	rts

_dmaGridRowAll:
	jsr _dmaGridRow00
	jsr _dmaGridRow01
	jsr _dmaGridRow02
	jsr _dmaGridRow03
	jsr _dmaGridRow04
	jmp _dmaGridRow05
	
_dmaGridRowTop:
	jsr _dmaGridRow00
	jsr _dmaGridRow01
	jmp _dmaGridRow02
	
_dmaGridRowBottom:
	jsr _dmaGridRow03
	jsr _dmaGridRow04
	jmp _dmaGridRow05


_dmaGridRow00:	lda #>SCN_GRID_ROW_00
	sta $2006
	lda #<SCN_GRID_ROW_00
	sta $2006
	.REPEAT 16,i
	lda scnGridBuffer + (0 * 16) +i
	sta $2007
	.ENDREPEAT
	rts
	
_dmaGridRow01:	lda #>SCN_GRID_ROW_01
	sta $2006
	lda #<SCN_GRID_ROW_01
	sta $2006
	.REPEAT 16,i
	lda scnGridBuffer + (1 * 16) +i
	sta $2007
	.ENDREPEAT
	rts

_dmaGridRow02:	lda #>SCN_GRID_ROW_02
	sta $2006
	lda #<SCN_GRID_ROW_02
	sta $2006
	.REPEAT 16,i
	lda scnGridBuffer + (2 * 16) +i
	sta $2007
	.ENDREPEAT
	rts

_dmaGridRow03:	lda #>SCN_GRID_ROW_03
	sta $2006
	lda #<SCN_GRID_ROW_03
	sta $2006
	.REPEAT 16,i
	lda scnGridBuffer + (3 * 16) +i
	sta $2007
	.ENDREPEAT
	rts
_dmaGridRow04:	lda #>SCN_GRID_ROW_04
	sta $2006
	lda #<SCN_GRID_ROW_04
	sta $2006
	.REPEAT 16,i
	lda scnGridBuffer + (4 * 16) +i
	sta $2007
	.ENDREPEAT
	rts
_dmaGridRow05:	lda #>SCN_GRID_ROW_05
	sta $2006
	lda #<SCN_GRID_ROW_05
	sta $2006
	.REPEAT 16,i
	lda scnGridBuffer + (5 * 16) +i
	sta $2007
	.ENDREPEAT
	rts


errorScreen:
	lda #<errorNameTable
	sta tmp0
	lda #>errorNameTable
	sta tmp1

	lda #>SCREEN
	sta $2006
	lda #<SCREEN
	sta $2006
	ldy #$00
	ldx #$04
@c:	lda (tmp0),y
	sta $2007
	iny
	bne @c
	inc tmp1
	dex
	bne @c
		
	lda #$00
	sta $2006
	sta $2006
	rts
	

clearGraphics:
	jsr initPalette
	jsr clearVram
	jsr clearSprites

	;CHR Font
	lda #<font
	sta tmp0
	lda #>font
	sta tmp1
	lda #>CHR_RAM_0
	sta $2006
	lda #<CHR_RAM_0
	sta $2006
	jsr writeFont
	lda #$00
	sta $2006
	sta $2006
	
	;SPR Font
	lda #<sprites
	sta tmp0
	lda #>sprites
	sta tmp1
	lda #>CHR_RAM_1
	sta $2006
	lda #<CHR_RAM_1
	sta $2006
	jsr writeFont
	lda #$00
	sta $2006
	sta $2006
	rts
		

initGraphics:

	lda #<nameTable
	sta tmp0
	lda #>nameTable
	sta tmp1

	lda #>SCREEN
	sta $2006
	lda #<SCREEN
	sta $2006
	ldy #$00
	ldx #$04
@c:	lda (tmp0),y
	sta $2007
	iny
	bne @c
	inc tmp1
	dex
	bne @c
		
	lda #$00
	sta $2006
	sta $2006
	rts

clearVram:
	lda #>SCREEN
	ldx #<SCREEN
	sta DMA_ADDR
	stx DMA_ADDR
		
	lda #<nameTable
	sta tmp0
	lda #>nameTable
	sta tmp1
	ldx #$04
	ldy #$00
@a:	lda (tmp0),y
	.IF DEBUG=1
	;lda #$FF
	.ENDIF
	sta DMA_DATA
	iny
	bne @a
	inc tmp1
	dex
	bne @a	
	rts

initPalette:
	lda #$3F
	sta DMA_ADDR
	lda #$00
	sta DMA_ADDR
	ldx #$00
@a:	lda palette+0,x
	sta $2007
	inx
	cpx #$20
	bne @a
	rts

writeFont:
	ldx #$10
	ldy #$00
@writeFont:
	lda (tmp0),y
	sta $2007
	iny
	bne @writeFont
	inc tmp1
	dex
	bne @writeFont
	rts

clearSprites:
	ldx #$00
@a:	lda #240
	sta SPR00_Y,x
	lda #$FF
	sta SPR00_CHAR,x
	lda #$00
	sta SPR00_ATTR,x
	lda #$00
	sta SPR00_X,x
	inx
	inx
	inx
	inx
	bne @a	
	rts


palette:
	.incbin "pr8.pal"
	.incbin "pr8spr.pal"

;
;Changing Pattern Number from Pattern Editor
;	+ Pattern Number
;	+ Drum assignments per track (number and name)
;	+ Grid
;	+ Trigger parameters under cursor
;	+ Drum parameters for track assignment under cursor
;
;Changing Drum Assignment on a Track
;	+ Drum name and number
;	+ Drum parameters
;
;Modifying Grid
;	+ Grid
;	+ Trigger parameters
;
;Modifying Trigger Parameters
;	+ Trigger parameter
;
;
;Modifying Drum Parameters
;	+ Drum parameter
;
;Modifying Song
;	+ Song parameter
;	+ Possibly grid, drum assignments, triggers, drum parameters but low priority
;
;

;
;Assign DMA sets a numerical number
;
;FF = nothing
;00 = drum track assignments
;01 = drum grid
;02 = trigger parameters
;
;then when needing to update screen, add these numbers to a processing chain according to priority
;
;00 01 02 FF
;
;FF = end of processing
;
;jump to subroutine based on number then shift list to the right until FF = first item
;
;
