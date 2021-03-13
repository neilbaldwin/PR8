PR8 NES Drum Synth by Neil Baldwin (C) 2010
-------------------------------------------

Contact: info@marmotaudio.co.uk

What's in the package?

PR8.NES     - the NES ROM image
DCM2PR8.C   - source for ROM patcher
DCM2PR8     - Mac/Unix executable of ROM patcher
DCM2PR8.EXE - Windows executable of ROM patcher
pr8_dcm.txt - text file for patcher to 'restore' original samples
pr8_ex.sav  - .sav file containing some example Patterns and Drums
+ DPCM      - folder of DCM drum samples
+ Manual    - folder containing manual (index.html)
+ Powerpak  - folder containing mapper update required for Powerpak
              and blank 32kb .save file (if required)

readme.txt  - this file

Release History
---------------

V1.01 - February 6th 2012
- Tightened up the reset code to overcome some reset issues on real hardware

V1.00  - November 11th January 2012
Added some new features and controls:

- in Song Editor, if the current (editing) Bar is within the Loop the Bar
  number is displayed in inverted text
- there is now a 'INS LP' and 'PST LP' command in the Song Edit Menu
  (see manual, Menus->Song Menu, for details)
- there are now key combos to insert/delete bars in the Song Editor
  (see manual, Controls->Song Controls for details)
- when in Song Editor, tapping SELECT will 'load' the Pattern assigned to 
  the current (editing) Bar and jumps to the Pattern Editor


V0.99c - November 6th 2011
Bug - tapping B on the Song Loop Length (LP []) parameter didn't toggle loop on/off
Added new control - holding A and tapping Start will (if Song is active) start playing
the Song from the loop instead of from the start of the Song

V0.99b - October 31st 2011
Fixed a bug which prevented you from editing a Song longer than sixteen (10) steps

V0.99a - February 16th 2011
+ Added a check to make sure the emulator you are using can support
32KB save files. You'll get an error screen if 32K save files are
not supported

V0.99 - February 12th 2011
+ Initial release

Notes
-----

If you want to try out the example .sav file you'll need to rename it to
'pr8.sav' and copy it to where your emulator looks for .sav files. If you
are using PowerPak you can just copy it to your Compact Flash card and
then point PowerPak at it when loading PR8 by using the 'Load Battry File'
feature.

PowerPak
--------

You need a blank 32kb .save file to run PR8 on PowerPak. Copy the file
'32KB.sav' to the 'SAVES' folder on your Compact Flash card then rename
it to 'PR8.SAV'


Known Issues
------------

- using Retrigger can, in certain conditions, cause notes to sound 
  continuosly when changing Patterns.

- it's sometimes possible to set a Pitch value (note + octave) outside 
  of the 'legal' range. You'll see 'corrupt' display in the Note parameter
  of a Trigger. Please get in touch if you have this happen.

- not all Drum Patch parameters work properly when using Tie Notes

Planned Updates
---------------

+ External Sync
+ Better 'transport' controls for Song mode


