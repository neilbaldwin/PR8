DEBUG	= 0
DEBUG_COLOURS	= 0
MUTE_AUDIO	= 0
STARTING_PATTERN = 0
STARTING_SONG	= 0
DEFAULT_SPEED	= 12
DEFAULT_SWING	= 0
PAL_VERSION	= 0
EXT_SYNC		= 0

;------------------------------------------------------------------------------
PPU0	= $2000
PPU1	= $2001
DMA_ADDR	= $2006
DMA_DATA	= $2007
SCREEN	= $2000

CHR_RAM_0	= $0000
CHR_RAM_1	= $1000

ENV_PHASE_ATTACK= $03
ENV_PHASE_HOLD	= $02
ENV_PHASE_RELEASE = $01
ENV_PHASE_OFF	= $00


;------------------------------------------------------------------------------
; ROM BANKS
;------------------------------------------------------------------------------
BANK_0	= $00
BANK_1	= $01
BANK_2	= $02
BANK_3	= $03
BANK_4	= $04
BANK_5	= $05
BANK_6	= $06
BANK_7	= $07

BANK_FONT	= BANK_5
BANK_SCREEN	= BANK_5
BANK_PLAYER	= BANK_1
BANK_SYNTH	= BANK_2
BANK_EDITOR	= BANK_0

;------------------------------------------------------------------------------
; WRAM BANKS
;------------------------------------------------------------------------------
WRAM_BANK_00	= %00010000
WRAM_BANK_01	= %00010100
WRAM_BANK_02	= %00011000
WRAM_BANK_03	= %00011100

WRAM_PHRASES_0	= WRAM_BANK_00
WRAM_PHRASES_1	= WRAM_BANK_01
WRAM_PATTERNS	= WRAM_BANK_02
WRAM_SONGS	= WRAM_PATTERNS
WRAM_DRUMS	= WRAM_BANK_03
WRAM_ECHO	= WRAM_BANK_03

;------------------------------------------------------------------------------
; DMA PROCESS IDS
;------------------------------------------------------------------------------
procTrackDrum00	= $00
procTrackDrum01	= $01
procTrackDrum02	= $02
procTrackDrum03	= $03
procTrackDrum04	= $04
procTrackDrum05	= $05
procTrackDrumAll = $06

procGridRow00	= $07
procGridRow01	= $08
procGridRow02	= $09
procGridRow03	= $0A
procGridRow04	= $0B
procGridRow05	= $0C
procGridRowAll	= $0D

procTrackDrumTop = $0E
procTrackDrumBottom = $0F
procGridRowTop	= $10
procGridRowBottom = $11

procTrigger	= $12

procGridPattern	= $13

procVoiceA	= $14
procVoiceB	= $15
procVoiceC	= $16
procVoiceD	= $17
procVoiceE	= $18

procDrumAux	= $19

procDrumAll	= $1A

procCopyInfoAll	= $1B

procSongAll	= $1C
procSongSpeed	= $1D
procSongBar	= $1E
procSongLoop	= $1F

procCopyInfoTop = $20
procCopyInfoBottom = $21


numberOfSpeeds = 20

SONG_MODE_OFF	= $00
SONG_MODE_PLY	= $01
SONG_MODE_REC	= $02

;------------------------------------------------------------------------------
; Drum parameters
;------------------------------------------------------------------------------

osc_A_Coarse	= $00
osc_A_Fine	= $01
osc_A_Hard	= $02
lfo_A_Delay	= $03
lfo_A_Speed	= $04
lfo_A_Depth	= $05
env_A_Volume	= $06	
env_A_Env	= $07
env_A_Gate	= $08
dty_A_Width0	= $09
dty_A_Width1	= $0A
	
osc_B_Coarse	= $0B
osc_B_Fine	= $0C
osc_B_Hard	= $0D
lfo_B_Delay	= $0E
lfo_B_Speed	= $0F
lfo_B_Depth	= $10
env_B_Volume	= $11	
env_B_Env	= $12
env_B_Gate	= $13
dty_B_Width0	= $14
dty_B_Width1	= $15
	
osc_C_Coarse	= $16
osc_C_Fine	= $17
lfo_C_Delay	= $18
lfo_C_Speed	= $19
lfo_C_Depth	= $1A
env_C_Pulse	= $1B
env_C_Gate	= $1C

osc_D_Coarse	= $1D
lfo_D_Delay	= $1E
lfo_D_Speed	= $1F
lfo_D_Depth	= $20
env_D_Volume	= $21	
env_D_Env	= $22
env_D_Gate	= $23

smp_E_Sample	= $24
smp_E_Start	= $25
smp_E_End	= $26
smp_E_Pitch	= $27
smp_E_Loop	= $28

gbl_DrumName	= $29	;29/2A/2B

mod_Parameter0	= $2C
mod_Parameter1	= $2D
mod_Parameter2	= $2E

gbl_VoiceSelect	= $2F	;2d,2e,2f

bytesPerDrum	= $30

SIZE_OF_ECHO_BUFFER = $80

numberOfTracks	= 6
phrasesPerBank	= 96
numberOfPhrases = phrasesPerBank * 2

stepsPerPhrase	= 16
bytesPerPhraseStep = 5

numberOfPatterns = 256

numberOfNotes	= 96

voicesPerDrum	= 5

numberOfDrums	= 128

numberOfSongs	= 8
bytesPerSong	= 256


PATTERN_DRUM_0	= $00
PATTERN_DRUM_1	= $01
PATTERN_DRUM_2	= $02
PATTERN_DRUM_3	= $03
PATTERN_DRUM_4	= $04
PATTERN_DRUM_5	= $05
PATTERN_PHRASE_0 = $06
PATTERN_PHRASE_1 = $07
PATTERN_PHRASE_2 = $08
PATTERN_PHRASE_3 = $09
PATTERN_PHRASE_4 = $0A
PATTERN_PHRASE_5 = $0B
PATTERN_SPEED	= $0C
PATTERN_SWING	= $0D
PATTERN_STEPS	= $0E
PATTERN_PAD0	= $0F

bytesPerPattern	= $10

;------------------------------------------------------------------------------
; MISC EDITOR CONSTANTS
;------------------------------------------------------------------------------
NOTE_ABSOLUTE	= $50
NOTE_NEGATIVE	= $B0

NOTE_C	= $12
NOTE_D	= $13
NOTE_E	= $14
NOTE_F	= $15
NOTE_G	= $16
NOTE_A	= $10
NOTE_B	= $11

OCT_1	= $01
OCT_2	= $02
OCT_3	= $03
OCT_4	= $04
OCT_5	= $05
OCT_6	= $06
OCT_7	= $07
OCT_8	= $08
OCT_9	= $09

SHARP	= $2B
NONE	= $2C

TRIGGER_INDEX_NOTE = $00
TRIGGER_INDEX_REPEAT = $01
TRIGGER_INDEX_P1 = $02
TRIGGER_INDEX_P2 = $03
TRIGGER_INDEX_P3 = $04

CHR_EMPTY_GRID_CELL_0 = $FD
CHR_EMPTY_GRID_CELL_1 = $FE
CHR_GRID_NOTE	= $F9
CHR_GRID_KILL = $F8
CHR_GRID_TIE = $F7

EDIT_MODE_OFF	= $00
EDIT_MODE_TRACK	= $01
EDIT_MODE_GRID	= $02
EDIT_MODE_TRIGGER_PARAMETER = $03
EDIT_MODE_DRUM	= $04
EDIT_MODE_DRUM_AUX = $05
EDIT_MODE_GRID_MENU = $06
EDIT_MODE_DRUM_MENU = $07
EDIT_MODE_PATTERN_NUMBER = $08
EDIT_MODE_SONG = $09
EDIT_MODE_SONG_MENU = $0A
EDIT_MODE_ECHO = $0B
EDIT_MODE_CLEAR_MENU = $0C

INIT_ECHO_SELECT = $00
INIT_ECHO_LEVEL	= $00
INIT_ECHO_DECAY = $00
INIT_ECHO_SPEED = $00

GRID_CURSOR_X_BASE	= $4B
GRID_CURSOR_Y_BASE	= $42

TRACK_CURSOR_X_BASE	= $13
TRACK_CURSOR_Y_BASE	= $42

TRIGGER_CURSOR_X_BASE	= $D0
TRIGGER_CURSOR_Y_BASE	= $4E

TRIGGER_PARAMETER_X_BASE	= $D3
TRIGGER_PARAMETER_Y_BASE	= $4A

DRUM_CURSOR_X_BASE	= $1B
DRUM_CURSOR_Y_BASE	= $82

DRUM_AUX_CURSOR_X_BASE	= $2B
DRUM_AUX_CURSOR_Y_BASE	= $CA

rowsPerGrid	= 6
colsPerGrid	= 16

SPR_VOICE_OFF	= $06
SPR_VOICE_ON	= $07

CURSOR_BASE_COLOUR = $06
CURSOR_BASE_COLOUR2 = $02
CURSOR_HOLD_COLOUR = $26
CURSOR_NAV_COLOUR = $11

COPY_ID_EMPTY	= $00
COPY_ID_DRUM	= $01
COPY_ID_PATTERN	= $02
COPY_ID_PHRASE	= $03

PLAY_MODE_STOPPED = $00
PLAY_MODE_PLAYING = $01
PLAY_MODE_START = $02
PLAY_MODE_SONG_LOOP = $03

;------------------------------------------------------------------------------
; ZP RAM
;------------------------------------------------------------------------------
.globalzp vblankFlag,vblankLastFlag
.globalzp doNotInterrupt
.globalzp curPrgBank,oldPrgBank,curWramBank, oldWramBank

.globalzp curPrgBank
.globalzp curWramBank
.globalzp tmp0,tmp1,tmp2,tmp3,tmp4

.globalzp debug0
.globalzp debug1

.globalzp VAPU
.globalzp VAPU_03_OLD
.globalzp VAPU_07_OLD

.globalzp PAD1_jt

.globalzp PAD1_lr
.globalzp PAD1_ud
.globalzp PAD1_str
.globalzp PAD1_sel
.globalzp PAD1_fireb
.globalzp PAD1_firea

.globalzp PAD1_oldlr

.globalzp PAD1_dlr
.globalzp PAD1_dud
.globalzp PAD1_dsta
.globalzp PAD1_dsel
.globalzp PAD1_dfireb
.globalzp PAD1_dfirea

.globalzp PAD2_jt

.globalzp PAD2_lr
.globalzp PAD2_ud
.globalzp PAD2_str
.globalzp PAD2_sel
.globalzp PAD2_fireb
.globalzp PAD2_firea

.globalzp PAD2_oldlr

.globalzp PAD2_dlr
.globalzp PAD2_dud
.globalzp PAD2_dsta
.globalzp PAD2_dsel
.globalzp PAD2_dfireb
.globalzp PAD2_dfirea

.globalzp processVector, dmaProcessBuffer, jumpVector

.globalzp errorCount
.globalzp maxDma

.globalzp VAPU_00,VAPU_01,VAPU_02,VAPU_03
.globalzp VAPU_04,VAPU_05,VAPU_06,VAPU_07
.globalzp VAPU_08,VAPU_09,VAPU_0A,VAPU_0B
.globalzp VAPU_0C,VAPU_0D,VAPU_0E,VAPU_0F
.globalzp VAPU_10,VAPU_11,VAPU_12,VAPU_13,VAPU_14,VAPU_15

.globalzp editModeVector

.globalzp editorTmp0,editorTmp1,editorTmp2,editorTmp3,editorTmp4,editorTmp5,editorTmp6

.globalzp editorTrackVectorLo,editorTrackVectorHi

.globalzp editorDecoding

.globalzp editorMultiHintIndex

;------------------------------------------------------------------------------
; RAM
;------------------------------------------------------------------------------

.global noteNumberA0
.global arpNotesA0	
.global noteNumberA1
.global arpNotesA1
.global noteNumberA2
.global arpNotesA2	
.global noteNumberA3
.global arpNotesA3	
.global noteNumberA4
.global arpNotesA4
.global noteNumberA5
.global arpNotesA5

.global noteNumberB0
.global arpNotesB0
.global noteNumberB1
.global arpNotesB1
.global noteNumberB2
.global arpNotesB2
.global noteNumberB3
.global arpNotesB3
.global noteNumberB4
.global arpNotesB4
.global noteNumberB5
.global arpNotesB5

.global noteNumberC0
.global arpNotesC0
.global noteNumberC1
.global arpNotesC1
.global noteNumberC2
.global arpNotesC2
.global noteNumberC3
.global arpNotesC3
.global noteNumberC4
.global arpNotesC4
.global noteNumberC5
.global arpNotesC5

.global noteNumberD0
.global arpNotesD0
.global noteNumberD1
.global arpNotesD1
.global noteNumberD2
.global arpNotesD2
.global noteNumberD3
.global arpNotesD3
.global noteNumberD4
.global arpNotesD4
.global noteNumberD5
.global arpNotesD5

.global noteNumberE0,noteNumberE1,noteNumberE2,noteNumberE3,noteNumberE4,noteNumberE5
.global sampleNumber0,sampleNumber1,sampleNumber2,sampleNumber3,sampleNumber4,sampleNumber5
.global samplePitch0,samplePitch1,samplePitch2,samplePitch3,samplePitch4,samplePitch5
.global sampleStartOffset0,sampleStartOffset1,sampleStartOffset2,sampleStartOffset3
.global sampleStartOffset4,sampleStartOffset5
.global sampleEndOffset0,sampleEndOffset1,sampleEndOffset2,sampleEndOffset3
.global sampleEndOffset4,sampleEndOffset5
.global sampleLoopSwitch0,sampleLoopSwitch1,sampleLoopSwitch3
.global sampleLoopSwitch4,sampleLoopSwitch5


.global noteCounter
	
.global freqLoA
.global freqHiA
.global freqHiOldA

.global freqLoB
.global freqHiB
.global freqHiOldB

.global freqLoC
.global freqHiC

.global freqLoD

.global lfoCounterA
.global lfoDelCounterA
.global lfoPhaseA

.global lfoCounterB
.global lfoDelCounterB
.global lfoPhaseB

.global lfoCounterC
.global lfoDelCounterC
.global lfoPhaseC

.global lfoCounterD
.global lfoDelCounterD
.global lfoPhaseD

.global envPhaseA
.global envCounterA
.global envAmpIndexA
.global envGateTimerA

.global envPhaseB
.global envCounterB
.global envAmpIndexB
.global envGateTimerB

.global envPhaseC
.global envCounterC
.global envAmpIndexC
.global envGateTimerC

.global envPhaseD
.global envCounterD
.global envAmpIndexD
.global envGateTimerD

.global dutyIndexA
.global dutyCounterA
.global dutyWidthA

.global dutyIndexB
.global dutyCounterB
.global dutyWidthB

.global plyrDpcmOn

.global voiceActive
.global noteTrack,lastNoteTrack
.global retriggerSpeed,retriggerCount,retriggerTemp
.global slideA,slideB,slideC

.global triggerTmp

.global patternIndex
.global plyrTrackDrum,plyrTrackPhrase,plyrPatternSpeed,plyrPatternGroove
.global plyrCurrentPattern,plyrNextPattern
.global plyrSongBar,editorSongBar

.global hardFreqA,hardFreqB
.global detuneA,detuneB,detuneC

.global drumParameters,drumParameters0,drumParameters1,drumParameters2,drumParameters3
.global drumParameters4,drumParameters5

.global scnGridBuffer,scnTriggerBuffer
.global scnVoiceABuffer,scnVoiceBBuffer,scnVoiceCBuffer,scnVoiceDBuffer,scnVoiceEBuffer
.global scnDrumAuxBuffer,scnTrackDrumBuffer
.global scnGridPatternBuffer
.global scnCopyInfoBuffer
.global scnSongBuffer

.global WRAM,WRAM0,WRAM1,WRAM2,WRAM3

.global sprBuf
.global SPR00_X,SPR00_Y,SPR00_ATTR,SPR00_CHAR
.global SPR01_X,SPR01_Y,SPR01_ATTR,SPR01_CHAR
.global SPR02_X,SPR02_Y,SPR02_ATTR,SPR02_CHAR
.global SPR03_X,SPR03_Y,SPR03_ATTR,SPR03_CHAR
.global SPR04_X,SPR04_Y,SPR04_ATTR,SPR04_CHAR
.global SPR05_X,SPR05_Y,SPR05_ATTR,SPR05_CHAR
.global SPR06_X,SPR06_Y,SPR06_ATTR,SPR06_CHAR
.global SPR07_X,SPR07_Y,SPR07_ATTR,SPR07_CHAR
.global SPR08_X,SPR08_Y,SPR08_ATTR,SPR08_CHAR
.global SPR09_X,SPR09_Y,SPR09_ATTR,SPR09_CHAR
.global SPR0A_X,SPR0A_Y,SPR0A_ATTR,SPR0A_CHAR
.global SPR0B_X,SPR0B_Y,SPR0B_ATTR,SPR0B_CHAR
.global SPR0C_X,SPR0C_Y,SPR0C_ATTR,SPR0C_CHAR
.global SPR0D_X,SPR0D_Y,SPR0D_ATTR,SPR0D_CHAR
.global SPR0E_X,SPR0E_Y,SPR0E_ATTR,SPR0E_CHAR
.global SPR0F_X,SPR0F_Y,SPR0F_ATTR,SPR0F_CHAR

.global SPR10_X,SPR10_Y,SPR10_ATTR,SPR10_CHAR
.global SPR11_X,SPR11_Y,SPR11_ATTR,SPR11_CHAR
.global SPR12_X,SPR12_Y,SPR12_ATTR,SPR12_CHAR
.global SPR13_X,SPR13_Y,SPR13_ATTR,SPR13_CHAR
.global SPR14_X,SPR14_Y,SPR14_ATTR,SPR14_CHAR
.global SPR15_X,SPR15_Y,SPR15_ATTR,SPR15_CHAR

.global SPR16_X,SPR16_Y,SPR16_ATTR,SPR16_CHAR
.global SPR17_X,SPR17_Y,SPR17_ATTR,SPR17_CHAR
.global SPR18_X,SPR18_Y,SPR18_ATTR,SPR18_CHAR
.global SPR19_X,SPR19_Y,SPR19_ATTR,SPR19_CHAR

.global SPR1A_X,SPR1A_Y,SPR1A_ATTR,SPR1A_CHAR
.global SPR1B_X,SPR1B_Y,SPR1B_ATTR,SPR1B_CHAR

.global SPR1C_X,SPR1C_Y,SPR1C_ATTR,SPR1C_CHAR
.global SPR1D_X,SPR1D_Y,SPR1D_ATTR,SPR1D_CHAR
.global SPR1E_X,SPR1E_Y,SPR1E_ATTR,SPR1E_CHAR
.global SPR1F_X,SPR1F_Y,SPR1F_ATTR,SPR1F_CHAR

.global process_DMA_queue

.global editorMode,previousEditorMode
.global cursorX_grid,cursorY_grid
.global editorCursorX,editorCursorY,editorCursorMode
.global editorCurrentPattern
.global cursorY_editMenu
.global cursorX_track
.global editorCurrentSong,plyrCurrentSong

.global editorTrackLastNote,editorTrackLastTrigger
.global editorTriggerIndex
.global editSongIndex,editSongMode,editSongModeRecord
.global lastDrumParameterValue
.global editorMeterCounters
.global editorChannelStatus, editorSoloChannel, editorMuteFlashIndex

.global keyRepeatRateUD
.global keyRepeatUD
.global keyRepeatOldUD
.global keyRepeatCounterUD
.global keyRepeatRateLR
.global keyRepeatLR
.global keyRepeatOldLR
.global keyRepeatCounterLR
.global keyRepeatB
.global keyReleaseB
.global keyStopB
.global keyRepeatA
.global keyReleaseA
.global keyDelayB
.global keyDelayA
.global keyDelayUD
.global keyDelayLR
.global keyRepeatStart
.global keyReleaseStart
.global keyRepeatSelect
.global keyReleaseSelect

.global cursorFlashColour,cursorFlashIndex

.global editorCurrentDrum
.global editorTrackDrum,editorTrackPhrase,editorPatternSpeed,editorPatternGroove, editorPatternSteps

.global cursorX_drum,cursorY_drum
.global cursorDrumMin,cursorDrumMax
.global editorDrumSubMode,editorSubModeIndexes,editorDrumAuxIndex

.global triggerCopyBuffer

.global editorEditDrumName

.global editorTrackWipeSpeed

.global editorCopyInfoTimer

.global editorForceTrackLoad
.global editMenuActive
.global editorModeBeforeMenu
.global editCopyBuffer
.global editPatternInfoSubMode

.global plyrMode,plyrModeOld
.global editorWaitForAB
.global editorWaitForClone,editorPhraseForClone,editorPatternToCheck
.global editorFoundEmpty

.global editorPatternForClone,editorSongToCheck

.globalzp plyrTmp0,plyrTmp1,plyrTmp2,plyrTmp3
.globalzp plyrTrackVectorLo,plyrTrackVectorHi

.global editorLastDrumValue,editorLastPhraseValue,editorLastSongLoop

.global editorSongSpeedTemp,editorSongSwingTemp,editorSongLoopStartTemp,editorSongLoopLengthTemp
.global editorSongLastPattern

.global editModNote

;------------------------------------------------------------------------------
; WRAM
;------------------------------------------------------------------------------
.global patterns, drums, phrases0, phrases1, songs
.global songLoopStartTable,songLoopLengthTable,songSpeedTable,songSwingTable
;------------------------------------------------------------------------------
; GLOBAL ROUTINES
;------------------------------------------------------------------------------

.global RESET,NMI,IRQ
.global font,sprites

.global initGraphics,clearGraphics

.global _dmaGridRow00,_dmaGridRow01,_dmaGridRow02
.global _dmaGridRow03,_dmaGridRow04,_dmaGridRow05

.global _dmaTrackDrum00,_dmaTrackDrum01,_dmaTrackDrum02
.global _dmaTrackDrum03,_dmaTrackDrum04,_dmaTrackDrum05

.global synthRefresh,initSound,playNote

.global readPad1

.global editorInit,editorMainLoop

.global addProcessToBuffer

.global SET_BITS,CLR_BITS

.global setMMC1r0,setMMC1r1

.global parameterNames, parameterNamesEnd

.global dmcAddressTable

.global playNotes

.global editorRefresh

.global patternTableLo,patternTableHi,phraseTableLo,phraseTableHi,phraseBanks
.global songTableLo,songTableHi
.global infoTextIndexes,infoMessages

.global phrases0,phrases1,phrasesUsed
.global patternsUsed

.global echoBufferA_0,echoBufferA_2,echoBufferA_3
.global echoBufferB_0,echoBufferB_2,echoBufferB_3
.global echoBufferD_0,echoBufferD_2

.global nmiCounter

.global plyrEchoAttn,plyrEchoInitAttnA,plyrEchoInitAttnB,plyrEchoInitAttnD
.global plyrEchoIndex,plyrEchoSpeed,plyrEchoCounter,plyrEchoSelect
.global plyrEchoNoteCount

.global plyrEchoWrite

.global editorEditingValue,editorEditingBuffer

.global nameTable,errorNameTable,errorScreen

.global songEchoLevelA,songEchoLevelB,songEchoLevelD,songEchoDecay,songEchoSpeed,songEchoSelect

.global plyrSetupSong

.global plyrUpdateEchoIndex

.global playNotesNewStep

.global PR8_HEADER

.global old4017
.global newStepNeeded

.global syncFunctions

