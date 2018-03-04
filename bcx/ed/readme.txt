; #########################################################################
;
;   title   : ed
;   version : 1.1
;   date    : February 05, 2001
;   history : July 31, 2001
;                 Updated encoder to read in chunks.
;   abstract: Encodes or decodes a file based on a key file. The encoder
;             has been updated to read files in chunks. That means that
;             the decoder is slower than the encoder because it reads
;             the file byte by byte. Originally created to see how BCX
;             handles binary files, which it does very well!
;   target  : Windows 95/NT or Higher
;   tools   : BCX Translator 2.39
;             LCC-Win32 Development System 1.3
;   compile : build.bat
;   usage   : run eds.bat
;
;   - dl (dl@tks.cjb.net)
;
; #########################################################################
