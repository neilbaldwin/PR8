
	.include "nesaudio.h"
	.include "pr8.h"

.segment "ZEROPAGE"

vblankFlag:	.RES 1
vblankLastFlag:	.RES 1

doNotInterrupt:	.RES 1

curPrgBank:	.RES 1
oldPrgBank:	.RES 1
curWramBank:	.RES 1
oldWramBank:	.RES 1
tmp0:	.RES 1
tmp1:	.RES 1
tmp2:	.RES 1
tmp3:	.RES 1
tmp4:	.RES 1

debug0:	.RES 1
debug1:	.RES 1

VAPU:	.RES $15
VAPU_03_OLD:	.RES 1
VAPU_07_OLD:	.RES 1

PAD1_jt:	.RES 2

PAD1_lr:	.RES 1
PAD1_ud:	.RES 1
PAD1_str:	.RES 1
PAD1_sel:	.RES 1
PAD1_fireb:	.RES 1
PAD1_firea:	.RES 1

PAD1_oldlr:	.RES 6

PAD1_dlr:	.RES 1
PAD1_dud:	.RES 1
PAD1_dsta:	.RES 1
PAD1_dsel:	.RES 1
PAD1_dfireb:	.RES 1
PAD1_dfirea:	.RES 1

PAD2_jt:	.RES 2

PAD2_lr:	.RES 1
PAD2_ud:	.RES 1
PAD2_str:	.RES 1
PAD2_sel:	.RES 1
PAD2_fireb:	.RES 1
PAD2_firea:	.RES 1

PAD2_oldlr:	.RES 6

PAD2_dlr:	.RES 1
PAD2_dud:	.RES 1
PAD2_dsta:	.RES 1
PAD2_dsel:	.RES 1
PAD2_dfireb:	.RES 1
PAD2_dfirea:	.RES 1

processVector:	.RES 2
editModeVector:	.RES 2
jumpVector:	.RES 2

dmaProcessBuffer:
	.RES 32
	
	
errorCount:	.RES 1
maxDma:	.RES 1

editorTmp0:	.RES 1
editorTmp1:	.RES 1
editorTmp2:	.RES 1
editorTmp3:	.RES 1
editorTmp4:	.RES 1
editorTmp5:	.RES 1
editorTmp6:	.RES 1

plyrTmp0:	.RES 1
plyrTmp1:	.RES 1
plyrTmp2:	.RES 1
plyrTmp3:	.RES 1

plyrTrackVectorLo:
	.RES numberOfTracks
plyrTrackVectorHi:
	.RES numberOfTracks

editorDecoding:	.RES 1

editorMultiHintIndex:
	.RES 1
	
	

;------------------------------------------------------------------------------

.segment "RAM"

;------------------------------------------------------------------------------
; SPRITE RAM
;------------------------------------------------------------------------------
sprBuf:	.include "spr_vars.asm"


;------------------------------------------------------------------------------
; Drum Variables (per Track)
;------------------------------------------------------------------------------

noteNumberA0:	.RES 1	;need to be in this order for arpeggio
arpNotesA0:	.RES 2	
noteNumberA1:	.RES 1	;need to be in this order for arpeggio
arpNotesA1:	.RES 2	
noteNumberA2:	.RES 1	;need to be in this order for arpeggio
arpNotesA2:	.RES 2	
noteNumberA3:	.RES 1	;need to be in this order for arpeggio
arpNotesA3:	.RES 2	
noteNumberA4:	.RES 1	;need to be in this order for arpeggio
arpNotesA4:	.RES 2	
noteNumberA5:	.RES 1	;need to be in this order for arpeggio
arpNotesA5:	.RES 2	

noteNumberB0:	.RES 1	;need to be in this order for arpeggio
arpNotesB0:	.RES 2	
noteNumberB1:	.RES 1	;need to be in this order for arpeggio
arpNotesB1:	.RES 2	
noteNumberB2:	.RES 1	;need to be in this order for arpeggio
arpNotesB2:	.RES 2	
noteNumberB3:	.RES 1	;need to be in this order for arpeggio
arpNotesB3:	.RES 2	
noteNumberB4:	.RES 1	;need to be in this order for arpeggio
arpNotesB4:	.RES 2	
noteNumberB5:	.RES 1	;need to be in this order for arpeggio
arpNotesB5:	.RES 2	

noteNumberC0:	.RES 1	;need to be in this order for arpeggio
arpNotesC0:	.RES 2	
noteNumberC1:	.RES 1	;need to be in this order for arpeggio
arpNotesC1:	.RES 2	
noteNumberC2:	.RES 1	;need to be in this order for arpeggio
arpNotesC2:	.RES 2	
noteNumberC3:	.RES 1	;need to be in this order for arpeggio
arpNotesC3:	.RES 2	
noteNumberC4:	.RES 1	;need to be in this order for arpeggio
arpNotesC4:	.RES 2	
noteNumberC5:	.RES 1	;need to be in this order for arpeggio
arpNotesC5:	.RES 2	

noteNumberD0:	.RES 1	;need to be in this order for arpeggio
arpNotesD0:	.RES 2	
noteNumberD1:	.RES 1	;need to be in this order for arpeggio
arpNotesD1:	.RES 2	
noteNumberD2:	.RES 1	;need to be in this order for arpeggio
arpNotesD2:	.RES 2	
noteNumberD3:	.RES 1	;need to be in this order for arpeggio
arpNotesD3:	.RES 2	
noteNumberD4:	.RES 1	;need to be in this order for arpeggio
arpNotesD4:	.RES 2	
noteNumberD5:	.RES 1	;need to be in this order for arpeggio
arpNotesD5:	.RES 2	

noteNumberE0:	.RES 1
noteNumberE1:	.RES 1
noteNumberE2:	.RES 1
noteNumberE3:	.RES 1
noteNumberE4:	.RES 1
noteNumberE5:	.RES 1

noteCounter:	.RES 1

sampleNumber0:	.RES 1
sampleNumber1:	.RES 1
sampleNumber2:	.RES 1
sampleNumber3:	.RES 1
sampleNumber4:	.RES 1
sampleNumber5:	.RES 1

samplePitch0:	.RES 1
samplePitch1:	.RES 1
samplePitch2:	.RES 1
samplePitch3:	.RES 1
samplePitch4:	.RES 1
samplePitch5:	.RES 1

sampleStartOffset0: .RES 1
sampleStartOffset1: .RES 1
sampleStartOffset2: .RES 1
sampleStartOffset3: .RES 1
sampleStartOffset4: .RES 1
sampleStartOffset5: .RES 1
	
sampleEndOffset0: .RES 1
sampleEndOffset1: .RES 1
sampleEndOffset2: .RES 1
sampleEndOffset3: .RES 1
sampleEndOffset4: .RES 1
sampleEndOffset5: .RES 1

sampleLoopSwitch0: .RES 1
sampleLoopSwitch1: .RES 1
sampleLoopSwitch2: .RES 1
sampleLoopSwitch3: .RES 1
sampleLoopSwitch4: .RES 1
sampleLoopSwitch5: .RES 1
	
freqLoA:	.RES numberOfTracks	;noise pitch goes here
freqHiA:	.RES numberOfTracks
freqHiOldA:	.RES numberOfTracks

freqLoB:	.RES numberOfTracks	;noise pitch goes here
freqHiB:	.RES numberOfTracks
freqHiOldB:	.RES numberOfTracks

freqLoC:	.RES numberOfTracks	;noise pitch goes here
freqHiC:	.RES numberOfTracks

freqLoD:	.RES numberOfTracks

lfoCounterA:	.RES numberOfTracks
lfoDelCounterA:	.RES numberOfTracks
lfoPhaseA:	.RES numberOfTracks	

lfoCounterB:	.RES numberOfTracks
lfoDelCounterB:	.RES numberOfTracks
lfoPhaseB:	.RES numberOfTracks	

lfoCounterC:	.RES numberOfTracks
lfoDelCounterC:	.RES numberOfTracks
lfoPhaseC:	.RES numberOfTracks	

lfoCounterD:	.RES numberOfTracks
lfoDelCounterD:	.RES numberOfTracks
lfoPhaseD:	.RES numberOfTracks	

envPhaseA:	.RES numberOfTracks
envCounterA:	.RES numberOfTracks
envAmpIndexA:	.RES numberOfTracks
envGateTimerA:	.RES numberOfTracks

envPhaseB:	.RES numberOfTracks
envCounterB:	.RES numberOfTracks
envAmpIndexB:	.RES numberOfTracks
envGateTimerB:	.RES numberOfTracks

envPhaseC:	.RES numberOfTracks
envCounterC:	.RES numberOfTracks
envAmpIndexC:	.RES numberOfTracks
envGateTimerC:	.RES numberOfTracks

envPhaseD:	.RES numberOfTracks
envCounterD:	.RES numberOfTracks
envAmpIndexD:	.RES numberOfTracks
envGateTimerD:	.RES numberOfTracks

dutyIndexA:	.RES numberOfTracks
dutyCounterA:	.RES numberOfTracks
dutyWidthA:	.RES numberOfTracks

dutyIndexB:	.RES numberOfTracks
dutyCounterB:	.RES numberOfTracks
dutyWidthB:	.RES numberOfTracks

hardFreqA:	.RES numberOfTracks
hardFreqB:	.RES numberOfTracks

detuneA:	.RES numberOfTracks
detuneB:	.RES numberOfTracks
detuneC:	.RES numberOfTracks

slideA:	.RES numberOfTracks
slideB:	.RES numberOfTracks
slideC:	.RES numberOfTracks

plyrDpcmOn:	.RES numberOfTracks

voiceActive:	.RES numberOfTracks

noteTrack:	.RES numberOfTracks
lastNoteTrack:	.RES numberOfTracks

retriggerSpeed:	.RES numberOfTracks
retriggerCount:	.RES numberOfTracks
retriggerTemp:	.RES 1


triggerTmp:	.RES 4

patternIndex:	.RES 1

plyrCurrentPattern:
	.RES 1
plyrNextPattern:
	.RES 1

plyrSongBar:	.RES 1
editorSongBar:	.RES 1

plyrTrackDrum:	.RES numberOfTracks
plyrTrackPhrase:
	.RES numberOfTracks
plyrPatternSpeed:
	.RES 1
plyrPatternGroove:
	.RES 1
plyrPatternEcho:
	.RES 6

drumParameters:	.RES bytesPerDrum * numberOfTracks

drumParameters0	= drumParameters  + (0 * bytesPerDrum)
drumParameters1	= drumParameters  + (1 * bytesPerDrum)
drumParameters2	= drumParameters  + (2 * bytesPerDrum)
drumParameters3	= drumParameters  + (3 * bytesPerDrum)
drumParameters4	= drumParameters  + (4 * bytesPerDrum)
drumParameters5	= drumParameters  + (5 * bytesPerDrum)

;------------------------------------------------------------------------------
; SCREEN BUFFERS
;------------------------------------------------------------------------------

scnGridBuffer:	.RES 96

scnTriggerBuffer:
	.RES 11
	
scnVoiceABuffer:
	.RES 22	;0
scnVoiceBBuffer:
	.RES 22	;22
scnVoiceCBuffer:
	.RES 14	;44
scnVoiceDBuffer:
	.RES 14	;58
scnVoiceEBuffer:
	.RES 10	;72
scnDrumAuxBuffer:
	.RES 14	;82
	
scnTrackDrumBuffer:
	.RES numberOfTracks * 4
	
scnGridPatternBuffer:
	.RES 8
	
scnCopyInfoBuffer:
	.RES 28

scnSongBuffer:
	.RES 14
	
	
;------------------------------------------------------------------------------
; EDITOR VARS
;------------------------------------------------------------------------------
editorMode:	.RES 1
previousEditorMode:
	.RES 1
editorDrumSubMode:
	.RES 1
editorDrumAuxIndex:
	.RES 1
editorCursorX:	.RES 1
editorCursorY:	.RES 1
editorCursorMode:
	.RES 1
cursorX_grid:	.RES 1
cursorY_grid:	.RES 1
cursorX_trigger:
	.RES 1
cursorY_trigger:
	.RES 1

cursorX_drum:	.RES 1
cursorY_drum:	.RES 1

cursorY_editMenu:
	.RES 1

cursorX_track:	.RES 1

cursorDrumMin:	.RES 1
cursorDrumMax:	.RES 1

editorSubModeIndexes:
	.RES 5

editPatternInfoSubMode:
	.RES 1

lastDrumParameterValue:
	.RES 1
	
editorEditDrumName:
	.RES 1
editorCurrentPattern:
	.RES 1
editorTrackLastNote:
	.RES numberOfTracks
editorTrackLastTrigger:
	.RES numberOfTracks
editorTriggerIndex:
	.RES numberOfTracks

editSongIndex:	.RES 1
editSongMode:	.RES 1
editSongModeRecord:
	.RES 1
	
editorCurrentSong:
	.RES 1
plyrCurrentSong:
	.RES 1

keyRepeatRateUD:
	.RES 1
keyRepeatUD:	.RES 1
keyRepeatOldUD:	.RES 1
keyRepeatCounterUD:
	.RES 1
keyRepeatRateLR:
	.RES 1
keyRepeatLR:	.RES 1
keyRepeatOldLR:	.RES 1
keyRepeatCounterLR:
	.RES 1
keyRepeatB:	.RES 1
keyReleaseB:	.RES 1
keyStopB:	.RES 1
keyRepeatA:	.RES 1
keyReleaseA:	.RES 1
keyDelayB:	.RES 1
keyDelayA:	.RES 1
keyDelayUD:	.RES 1
keyDelayLR:	.RES 1
keyRepeatStart:	.RES 1
keyReleaseStart:
	.RES 1
keyRepeatSelect:
	.RES 1
keyReleaseSelect:
	.RES 1

cursorFlashIndex:
	.RES 1
cursorFlashColour:
	.RES 1
	
editorCurrentDrum:
	.RES 1
	
editorTrackDrum:
	.RES numberOfTracks
editorTrackPhrase:
	.RES numberOfTracks
editorPatternSpeed:
	.RES 1
editorPatternGroove:
	.RES 1
editorPatternSteps:
	.RES 1
	.RES 1	;padding
	
triggerCopyBuffer:
	.RES 5
	
editorTrackWipeSpeed:
	.RES 1
	
editorMeterCounters:
	.RES numberOfTracks
editorChannelStatus:
	.RES numberOfTracks
editorSoloChannel:
	.RES 1
editorMuteFlashIndex:
	.RES 1
	
editorCopyInfoTimer:
	.RES 1

editorForceTrackLoad:
	.RES 1
	
editMenuActive:	.RES 1
editorModeBeforeMenu:
	.RES 1

editCopyBuffer:
	.RES 1
	.RES stepsPerPhrase * bytesPerPhraseStep

plyrMode:	.RES 1
plyrModeOld:	.RES 1

editorWaitForAB:
	.RES 1
	
editorWaitForClone:
	.RES 1
editorPhraseForClone:
	.RES 1
editorPatternToCheck:
	.RES 2
editorFoundEmpty:
	.RES 1
	
editorPatternForClone = editorPhraseForClone
editorSongToCheck = editorPatternToCheck
	
editorLastDrumValue:
	.RES 1
editorLastPhraseValue:
	.RES 1
editorLastSongLoop:
	.RES 1
	
plyrEchoIndex:	.RES 1
plyrEchoSpeed:	.RES 1
plyrEchoAttn:	.RES 1
plyrEchoInitAttnA:
	.RES 1
plyrEchoInitAttnB:
	.RES 1
plyrEchoInitAttnD:
	.RES 1
plyrEchoSelect:
	.RES 1
plyrEchoCounter:
	.RES 1
plyrEchoNoteCount:
	.RES 1
	
plyrEchoWrite:	.RES 3

editorEditingValue:
	.RES 1
editorEditingBuffer:
	.RES 1

editorSongSpeedTemp:
	.RES 1
editorSongSwingTemp:
	.RES 1
editorSongLoopStartTemp:
	.RES 1
editorSongLoopLengthTemp:
	.RES 1
editorSongLastPattern:
	.RES 1
	
old4017:	.RES 1
newStepNeeded:
	.RES 1
	
	
;------------------------------------------------------------------------------
; WRAM MAP
;------------------------------------------------------------------------------
WRAM	= $6000
	
.segment "WRAM0"
	PR8_HEADER:
	.RES 32
	
	phrases0:
	.REPEAT phrasesPerBank
	.RES stepsPerPhrase * bytesPerPhraseStep
	.ENDREPEAT

	phraseUsed_0:	
	.RES phrasesPerBank
	

.segment "WRAM1"
	phrases1:
	.REPEAT phrasesPerBank
	.RES stepsPerPhrase * bytesPerPhraseStep
	.ENDREPEAT

	phraseUsed_1:	
	.RES phrasesPerBank


.segment "WRAM2"
	patterns:	
	.RES numberOfPatterns * bytesPerPattern		;$1000

	phrasesUsed:	
	.RES numberOfPhrases			;$00C0		

	songLoopStartTable:
	.RES numberOfSongs

	songLoopLengthTable:
	.RES numberOfSongs
	
	songSpeedTable:
	.RES numberOfSongs
	
	songSwingTable:
	.RES numberOfSongs
	
	songEchoSelect:
	.RES numberOfPatterns
	
	songEchoLevelA:
	.RES numberOfPatterns

	songEchoLevelB:
	.RES numberOfPatterns

	songEchoLevelD:
	.RES numberOfPatterns
	
	songEchoDecay:
	.RES numberOfPatterns
	
	songEchoSpeed:
	.RES numberOfPatterns
			
	songs:	
	.RES numberOfSongs * bytesPerSong

	patternsUsed:
	.RES numberOfPatterns
	

.segment "WRAM3"
	drums:	
	.RES numberOfDrums * bytesPerDrum

	echoBufferA_0:
	.RES SIZE_OF_ECHO_BUFFER
	echoBufferA_2:
	.RES SIZE_OF_ECHO_BUFFER
	echoBufferA_3:
	.RES SIZE_OF_ECHO_BUFFER

	echoBufferB_0:
	.RES SIZE_OF_ECHO_BUFFER
	echoBufferB_2:
	.RES SIZE_OF_ECHO_BUFFER
	echoBufferB_3:
	.RES SIZE_OF_ECHO_BUFFER

	echoBufferD_0:
	.RES SIZE_OF_ECHO_BUFFER
	echoBufferD_2:
	.RES SIZE_OF_ECHO_BUFFER
	
	nmiCounter:
	.RES 1
	

;------------------------------------------------------------------------------
; Equates Based on RAM Vars
;------------------------------------------------------------------------------

VAPU_00	= VAPU
VAPU_01	= VAPU_00+1
VAPU_02	= VAPU_01+1
VAPU_03	= VAPU_02+1

VAPU_04	= VAPU_03+1
VAPU_05	= VAPU_04+1
VAPU_06	= VAPU_05+1
VAPU_07	= VAPU_06+1

VAPU_08	= VAPU_07+1
VAPU_09	= VAPU_08+1
VAPU_0A	= VAPU_09+1
VAPU_0B	= VAPU_0A+1

VAPU_0C	= VAPU_0B+1
VAPU_0D	= VAPU_0C+1
VAPU_0E	= VAPU_0D+1
VAPU_0F	= VAPU_0E+1

VAPU_10	= VAPU_0F+1
VAPU_11	= VAPU_10+1
VAPU_12	= VAPU_11+1
VAPU_13	= VAPU_12+1

VAPU_14	= VAPU_13+1
VAPU_15	= VAPU_14+1
VAPU_16	= VAPU_15+1
VAPU_17	= VAPU_16+1
VAPU_18	= VAPU_17+1

