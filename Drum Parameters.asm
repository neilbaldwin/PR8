;00 A OSC (AOC) Coarse Pitch	;signed semitone offset
;01 A OSC (AOF) Fine Pitch	;signed detune offset
;02 A OSC (AOH) Hard Frequency;00=off, anything else = on
;03 A LFO (ALD) Delay	;00-7F = vib/sweep delay, 80-FF = arpeggio speed
;04 A LFO (ALS) Speed	;vib speed or if 00, sweep mode. If arpeggio mode, speed = number of repeats
;05 A LFO (ALW) Width	;vib depth or if sweep mode, pitch sweep. If arpeggio, depth = chord
;06 A ENV (AEV) Volume	;Nx = curve number, xN = volume scale
;07 A ENV (AEE) Envelope	;Nx = attack, xN = decay
;08 A ENV (AEG) Gate Time	;00-7F = one-shot, 80-FF = looped envelope
;09 A DTY (AP1) Pulse Width 1	;00 40 80 C0, if lower 6 bits = 0 then hold, otherwise delay
;0A A DTY (AP2) Pulse Width 2	;00 40 80 C0

;0B B OSC (BOC) Coarse Pitch (semitone)
;0C B OSC (BOF) Fine Pitch (detune)
;0D B OSC (BOH) Hard Frequency
;0E B LFO (BLD) Delay
;0F B LFO (BLS) Speed
;10 B LFO (BLW) Width
;11 B ENV (BEV) Volume
;12 B ENV (BEE) Envelope
;13 B ENV (BEG) Gate Time
;14 B DTY (BP1) Pulse Width 1
;15 B DTY (BP2) Pulse Width 2

;16 C OSC (COC) Coarse Pitch (semitone)
;17 C OSC (COF) Fine Pitch (detune)
;18 C LFO (CLD) Delay
;19 C LFO (CLS) Speed
;1A C LFO (CLW) Width
;1B C ENV (CEP) Envelope Pulse
;1C C ENV (CEG) Gate Time

;1D D ENV (DEV) Volume
;1E D ENV (DEE) Envelope
;1F D ENV (DEG) Gate Time
;20 D LFO (DLD) Delay
;21 D LFO (DLS) Speed
;22 D LFO (DLD) Depth
;23 D OSC (DOC) Coarse Pitch

;24 E SMP (ESM) Sample Number
;25 E SMP (EST) Start Offset
;26 E SMP (EEN) End Offset
;27 E SMP (EPT) Pitch
;28 E SMP (ELP) Loop

;29/2A/2B Drum Name

;2C Seq Parameter 1
;2D Seq Parameter 2
;2E Seq Parameter 3

;2F Global - Voice Select (bit mask)

;LFO delay: if negative then arpeggio, LFO depth is chord digits, LFO Speed is speed. If LFO Delay = 80 then
;           arpeggio is one-shot starting with first digit. Any other number is number of arpeggio loops

;LFO Speed: if not arpeggio and speed > 00 then LFO is cyclic, otherwise LFO is sweep, LFO depth is signed
;           8-bit sweep. Depth can be signed with cyclic (vibrato) though it's odd.





