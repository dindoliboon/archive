; #########################################################################
;
;   title   : CMon
;   version : 1.1
;   date    : April 15, 2001
;   updated : June 27, 2001
;           : Removed width limit
;           : Removed height limit
;           : Removed refresh limit
;           : Added msgbox with usage notes
;   abstract: Allows you to quickly change several properties for
;             your monitor.
;   target  : Windows 2000
;   tools   : Microsoft Macro Assembler 6.15.8803
;             Microsoft Incremental Linker 5.12.8078
;   compile : build.bat
;   usage   : cmon [width] [height] [color depth] [refresh rate] [save]
;             width         - Accepts values from 640 and up
;             height        - Accepts values from 480 and up
;             color depth   - Accepts values from 4   to 32
;             refresh reate - Accepts values from 56  and up
;             save          - Accepts values from 0   to 1
;
;             color depth in detail:
;                  4 - stands for 16 colors
;                  8 - stands for 256 colors
;                 16 - stands for 16-bit color
;                 32 - stands for 32-bit color
;
;             save in detail:
;                  0 - resets but does not save settings
;                  1 - resets and save settings
;
;             * currently, save is optional and will default to 0.
;
;             setting a screen to 800x600 with 16-bit colors at 85 Hz
;             cmon 800 600 16 85
;
;             setting a screen to 640x480 with 256 colors at 85 Hz
;             cmon 640 480 8 85
;
;   *** WARNING ***
;   Use this program at your own risk! Modifing your screen's properties
;   may damage your monitor.
;
;   - dl (dl@tks.cjb.net)
;
; #########################################################################
