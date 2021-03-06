; #########################################################################

      .386
      .model flat, stdcall
      option casemap :none   		; case sensitive

; #########################################################################

      include \masm32\include\windows.inc
      include \masm32\include\gdi32.inc
      include \masm32\include\user32.inc
      include \masm32\include\kernel32.inc

      includelib \masm32\lib\gdi32.lib
      includelib \masm32\lib\user32.lib
      includelib \masm32\lib\kernel32.lib

; #########################################################################

    ;=============
    ; Local macros
    ;=============
    m2m MACRO M1, M2
        push M2
        pop  M1
    ENDM

    return MACRO arg
        mov eax, arg
        ret
    ENDM


    ;=================
    ; Local prototypes
    ;=================
    WinMain PROTO :DWORD,:DWORD,:DWORD,:DWORD
    WndProc PROTO :DWORD,:DWORD,:DWORD,:DWORD
    TopXY   PROTO   :DWORD,:DWORD
    EditSl  PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD

; #########################################################################


    .data
        szTitle     db 'AIM Console Commands', 0
        szCList     db 065,079,076,032,073,110,115,116,097,110,116,032,077,101,115
                    db 115,101,110,103,101,114,032,118,049,046,055,053,046,053,054
                    db 051,032,067,111,110,115,111,108,101,032,067,111,109,109,097
                    db 110,100,115,013,010,061,061,061,061,061,061,061,061,061,061
                    db 061,061,061,061,061,061,061,061,061,061,061,061,061,061,061
                    db 061,061,061,061,061,061,061,061,061,061,061,061,061,061,061
                    db 061,061,061,061,061,061,061,061,013,010,111,109,013,010,067
                    db 111,109,112,108,101,116,101,032,099,111,109,109,097,110,100
                    db 115,032,097,114,101,032,117,110,107,110,111,119,110,013,010
                    db 111,109,032,115,101,110,100,032,091,101,120,112,101,099,116
                    db 101,100,032,079,077,032,116,121,112,101,093,013,010,013,010
                    db 105,110,118,105,116,101,013,010,084,104,105,115,032,119,105
                    db 108,108,032,115,101,110,100,032,101,045,109,097,105,108,032
                    db 116,111,032,116,104,101,032,117,115,101,114,032,100,101,115
                    db 099,114,105,098,105,110,103,032,065,079,076,039,115,032,073
                    db 110,115,116,097,110,116,032,077,101,115,115,101,110,103,101
                    db 114,032,083,101,114,118,105,099,101,046,032,083,109,097,108
                    db 108,032,099,117,115,116,111,109,032,109,101,115,115,097,103
                    db 101,115,032,099,097,110,032,098,101,032,105,110,099,108,117
                    db 100,101,100,032,097,115,032,119,101,108,108,046,013,010,105
                    db 110,118,105,116,101,032,069,077,097,105,108,065,100,100,114
                    db 101,115,115,032,089,111,117,114,077,101,115,115,097,103,101
                    db 013,010,101,120,058,032,105,110,118,105,116,101,032,077,089
                    db 065,068,068,064,097,046,099,111,109,032,084,104,105,115,032
                    db 105,115,032,109,121,032,099,117,115,116,111,109,032,109,101
                    db 115,115,097,103,101,013,010,013,010,108,111,111,107,117,112
                    db 013,010,073,032,104,097,118,101,032,110,111,116,032,115,101
                    db 101,110,032,097,110,121,032,114,101,115,117,108,116,115,032
                    db 111,110,032,116,104,105,115,032,099,111,109,109,097,110,100
                    db 046,013,010,108,111,111,107,117,112,032,069,077,097,105,108
                    db 065,100,100,114,101,115,115,013,010,101,120,058,032,108,111
                    db 111,107,117,112,032,084,114,117,110,107,115,095,120,057,057
                    db 064,098,105,103,102,111,111,116,046,099,111,109,013,010,013
                    db 010,108,111,103,013,010,067,111,109,112,108,101,116,101,032
                    db 099,111,109,109,097,110,100,115,032,097,114,101,032,117,110
                    db 107,110,111,119,110,013,010,108,111,103,032,111,112,101,110
                    db 032,091,101,120,112,101,099,116,101,100,032,102,105,108,101
                    db 032,110,097,109,101,093,013,010,013,010,116,105,109,101,114
                    db 013,010,076,105,115,116,115,032,097,099,116,105,118,101,032
                    db 116,105,109,101,114,115,044,032,109,097,120,032,097,099,116
                    db 105,118,101,032,116,105,109,101,114,115,044,032,097,110,100
                    db 032,099,114,101,097,116,105,111,110,032,111,102,032,115,104
                    db 111,114,116,047,108,111,110,103,032,116,105,109,101,114,115
                    db 046,013,010,116,105,109,101,114,032,115,116,097,116,115,013
                    db 010,013,010,116,114,097,099,101,013,010,065,108,108,111,119
                    db 115,032,121,111,117,032,116,111,032,116,114,097,099,101,032
                    db 115,101,118,101,114,097,108,032,099,111,109,109,097,110,100
                    db 115,046,032,073,032,104,097,118,101,032,110,111,116,032,115
                    db 101,101,110,032,097,110,121,032,114,101,115,117,108,116,115
                    db 032,111,110,032,116,104,105,115,032,099,111,109,109,097,110
                    db 100,046,013,010,116,114,097,099,101,032,103,101,110,101,114
                    db 097,108,032,111,110,047,111,102,102,013,010,116,114,097,099
                    db 101,032,098,117,100,100,121,032,111,110,047,111,102,102,013
                    db 010,116,114,097,099,101,032,098,111,115,032,111,110,047,111
                    db 102,102,013,010,116,114,097,099,101,032,111,100,108,032,111
                    db 110,047,111,102,102,013,010,116,114,097,099,101,032,111,109
                    db 032,111,110,047,111,102,102,013,010,116,114,097,099,101,032
                    db 110,105,099,107,100,098,032,111,110,047,111,102,102,013,010
                    db 116,114,097,099,101,032,108,111,103,032,111,110,047,111,102
                    db 102,013,010,116,114,097,099,101,032,108,111,111,107,117,112
                    db 032,111,110,047,111,102,102,013,010,116,114,097,099,101,032
                    db 105,110,118,105,116,101,032,111,110,047,111,102,102,013,010
                    db 116,114,097,099,101,032,112,114,111,116,111,032,111,110,047
                    db 111,102,102,013,010,116,114,097,099,101,032,097,100,109,105
                    db 110,032,111,110,047,111,102,102,013,010,116,114,097,099,101
                    db 032,097,100,118,101,114,116,032,111,110,047,111,102,102,013
                    db 010,116,114,097,099,101,032,099,104,097,116,032,111,110,047
                    db 111,102,102,013,010,116,114,097,099,101,032,111,100,105,114
                    db 032,111,110,047,111,102,102,013,010,116,114,097,099,101,032
                    db 115,116,097,116,115,032,111,110,047,111,102,102,013,010,101
                    db 120,058,032,116,114,097,099,101,032,098,117,100,100,121,032
                    db 111,110,013,010,013,010,099,097,099,104,101,013,010,065,108
                    db 108,111,119,115,032,121,111,117,032,116,111,032,099,117,115
                    db 116,111,109,105,122,101,032,116,104,101,032,099,097,099,104
                    db 101,032,102,111,114,032,115,101,118,101,114,097,108,032,111
                    db 098,106,101,099,116,115,046,032,073,032,104,097,118,101,032
                    db 110,111,116,032,115,101,101,110,032,097,110,121,032,114,101
                    db 115,117,108,116,115,032,111,110,032,116,104,105,115,032,099
                    db 111,109,109,097,110,100,046,013,010,099,097,099,104,101,032
                    db 109,097,120,115,105,122,101,032,098,117,116,116,111,110,099
                    db 111,108,111,114,115,032,091,110,101,119,032,115,105,122,101
                    db 093,013,010,099,097,099,104,101,032,109,097,120,115,105,122
                    db 101,032,102,111,110,116,032,091,110,101,119,032,115,105,122
                    db 101,093,013,010,099,097,099,104,101,032,109,097,120,115,105
                    db 122,101,032,097,114,116,119,111,114,107,032,091,110,101,119
                    db 032,115,105,122,101,093,013,010,101,120,058,032,099,097,099
                    db 104,101,032,109,097,120,115,105,122,101,032,102,111,110,116
                    db 032,050,048,048,048,013,010,013,010,112,114,101,102,115,013
                    db 010,084,104,105,115,032,119,105,108,108,032,098,114,105,110
                    db 103,032,117,112,032,116,104,101,032,112,114,101,102,114,101
                    db 110,099,101,115,032,100,105,097,108,111,103,046,013,010,013
                    db 010,099,116,108,103,114,111,117,112,013,010,084,104,105,115
                    db 032,098,114,105,110,103,115,032,117,112,032,097,032,112,111
                    db 112,117,112,032,119,105,110,100,111,119,032,119,105,116,104
                    db 032,115,101,118,101,114,097,108,032,101,100,105,116,097,098
                    db 108,101,032,102,101,097,116,117,114,101,115,046,013,010,099
                    db 116,108,103,114,111,117,112,032,109,111,110,105,116,111,114
                    db 032,111,110,047,111,102,102,013,010,101,120,058,032,099,116
                    db 108,103,114,111,117,112,032,109,111,110,105,116,111,114,032
                    db 111,110,013,010,013,010,105,099,111,110,013,010,083,101,116
                    db 115,032,116,104,101,032,105,099,111,110,032,105,110,116,101
                    db 114,118,097,108,032,116,111,032,088,035,032,111,102,032,109
                    db 105,108,108,105,115,101,099,111,110,100,115,046,032,073,032
                    db 104,097,118,101,032,110,111,116,032,115,101,101,110,032,097
                    db 110,121,032,114,101,115,117,108,116,115,032,111,110,032,116
                    db 104,105,115,032,099,111,109,109,097,110,100,046,013,010,105
                    db 099,111,110,032,105,110,116,101,114,118,097,108,032,091,101
                    db 120,112,101,099,116,101,100,032,105,099,111,110,032,105,110
                    db 116,101,114,118,097,108,032,105,110,032,109,105,108,108,105
                    db 115,101,099,111,110,100,115,093,013,010,101,120,058,032,105
                    db 099,111,110,032,105,110,116,101,114,118,097,108,032,050,048
                    db 013,010,013,010,112,111,112,117,112,013,010,084,104,105,115
                    db 032,115,104,111,119,115,032,097,032,119,105,110,100,111,119
                    db 032,119,105,116,104,032,097,032,109,101,115,115,097,103,101
                    db 046,013,010,112,111,112,117,112,032,100,105,115,112,108,097
                    db 121,032,119,105,100,116,104,032,104,101,105,103,104,116,032
                    db 109,101,115,115,097,103,101,013,010,101,120,058,032,112,111
                    db 112,117,112,032,100,105,115,112,108,097,121,032,049,048,048
                    db 032,049,048,048,032,084,104,105,115,032,105,115,032,119,104
                    db 101,114,101,032,109,121,032,109,101,115,115,097,103,101,032
                    db 103,111,101,115,033,013,010,013,010,099,104,097,116,013,010
                    db 067,111,109,112,108,101,116,101,032,099,111,109,109,097,110
                    db 100,115,032,097,114,101,032,117,110,107,110,111,119,110,013
                    db 010,099,104,097,116,032,100,117,109,112,013,010,099,104,097
                    db 116,032,109,115,103,095,116,111,104,111,115,116,032,089,111
                    db 117,114,077,101,115,115,097,103,101,032,091,047,119,104,105
                    db 115,112,101,114,032,085,115,101,114,078,097,109,101,093,013
                    db 010,099,104,097,116,032,106,111,105,110,095,114,111,111,109
                    db 032,101,120,099,104,097,110,103,101,032,099,111,111,107,105
                    db 101,032,105,110,115,116,097,110,099,101,013,010,099,104,097
                    db 116,032,099,114,101,097,116,101,095,114,111,111,109,013,010
                    db 099,104,097,116,032,114,101,113,095,111,099,099,117,112,097
                    db 110,116,095,108,105,115,116,032,101,120,099,104,097,110,103
                    db 101,032,099,111,111,107,105,101,032,105,110,115,116,097,110
                    db 099,101,013,010,099,104,097,116,032,114,101,113,095,114,111
                    db 111,109,095,105,110,102,111,032,101,120,099,104,097,110,103
                    db 101,032,099,111,111,107,105,101,032,100,101,116,097,105,108
                    db 013,010,099,104,097,116,032,114,101,113,095,101,120,099,104
                    db 097,110,103,101,095,105,110,102,111,032,101,120,099,104,097
                    db 110,103,101,013,010,099,104,097,116,032,114,101,113,095,099
                    db 104,097,116,095,114,105,103,104,116,115,013,010,013,010,105
                    db 099,098,109,013,010,073,077,115,032,121,111,117,114,115,101
                    db 108,102,047,104,111,115,116,032,119,105,116,104,032,097,032
                    db 109,101,115,115,097,103,101,013,010,105,099,098,109,032,109
                    db 115,103,116,111,099,108,105,101,110,116,032,034,089,111,117
                    db 114,078,097,109,101,034,032,089,111,117,114,077,101,115,115
                    db 097,103,101,013,010,105,099,098,109,032,109,115,103,116,111
                    db 104,111,115,116,032,034,089,111,117,114,078,097,109,101,034
                    db 032,089,111,117,114,077,101,115,115,097,103,101,013,010,101
                    db 120,058,032,105,099,098,109,032,109,115,103,116,111,099,108
                    db 105,101,110,116,032,034,084,114,117,110,107,115,032,120,057
                    db 057,034,032,072,101,121,044,032,116,104,105,115,032,105,115
                    db 032,109,121,032,109,101,115,115,097,103,101,033,013,010,013
                    db 010,112,105,109,013,010,067,111,109,112,108,101,116,101,032
                    db 099,111,109,109,097,110,100,115,032,097,114,101,032,117,110
                    db 107,110,111,119,110,013,010,112,105,109,032,091,101,120,112
                    db 101,099,116,101,100,032,080,073,077,032,099,111,109,109,097
                    db 110,100,093,013,010,013,010,098,111,115,013,010,073,032,104
                    db 097,118,101,032,110,111,116,032,115,101,101,110,032,097,110
                    db 121,032,114,101,115,117,108,116,115,032,111,110,032,116,104
                    db 105,115,032,099,111,109,109,097,110,100,046,013,010,098,111
                    db 115,032,105,100,108,101,032,111,110,047,111,102,102,013,010
                    db 098,111,115,032,109,097,115,107,013,010,099,108,097,115,115
                    db 032,109,097,115,107,058,032,100,097,109,110,101,100,095,116
                    db 114,097,110,115,105,101,110,116,032,097,100,109,105,110,105
                    db 115,116,114,097,116,111,114,032,097,111,108,032,111,115,099
                    db 097,114,095,112,097,121,032,111,115,099,097,114,095,102,114
                    db 101,101,013,010,098,111,115,032,112,101,114,109,105,116,032
                    db 034,085,115,101,114,078,097,109,101,034,013,010,101,120,058
                    db 032,098,111,115,032,112,101,114,109,105,116,032,034,084,114
                    db 117,110,107,115,032,120,057,057,034,013,010,013,010,115,116
                    db 101,097,108,116,104,013,010,084,104,105,115,032,119,105,108
                    db 108,032,039,116,101,109,112,111,114,097,114,108,121,039,032
                    db 109,097,107,101,032,105,116,032,115,101,101,109,032,116,104
                    db 097,116,032,121,111,117,032,097,114,101,032,108,111,103,103
                    db 101,100,032,111,102,102,046,013,010,115,116,101,097,108,116
                    db 104,032,111,110,047,111,102,102,013,010,101,120,058,032,115
                    db 116,101,097,108,116,104,032,111,110,013,010,013,010,098,117
                    db 100,100,121,013,010,084,104,105,115,032,097,108,108,111,119
                    db 115,032,121,111,117,032,116,111,032,109,111,100,105,102,121
                    db 032,121,111,117,114,032,098,117,100,100,121,032,108,105,115
                    db 116,032,105,110,032,099,111,110,115,111,108,101,032,118,105
                    db 101,119,046,013,010,098,117,100,100,121,032,099,104,097,110
                    db 103,101,032,034,085,115,101,114,078,097,109,101,034,013,010
                    db 083,105,109,117,108,097,116,101,115,032,098,117,100,100,121
                    db 032,115,105,103,110,105,110,103,032,111,102,102,013,010,013
                    db 010,098,117,100,100,121,032,108,105,115,116,095,103,114,111
                    db 117,112,115,013,010,076,105,115,116,115,032,121,111,117,114
                    db 032,103,114,111,117,112,115,013,010,013,010,098,117,100,100
                    db 121,032,108,105,115,116,032,034,066,117,100,100,121,032,071
                    db 114,111,117,112,034,013,010,076,105,115,116,115,032,117,115
                    db 101,114,115,032,105,110,032,115,101,108,101,099,116,101,100
                    db 032,103,114,111,117,112,013,010,013,010,098,117,100,100,121
                    db 032,100,101,108,101,116,101,095,103,114,111,117,112,032,034
                    db 066,117,100,100,121,032,071,114,111,117,112,034,013,010,082
                    db 101,109,111,118,101,115,032,115,101,108,101,099,116,101,100
                    db 032,103,114,111,117,112,013,010,013,010,098,117,100,100,121
                    db 032,097,100,100,095,103,114,111,117,112,032,034,066,117,100
                    db 100,121,032,071,114,111,117,112,034,013,010,065,100,100,115
                    db 032,115,101,108,101,099,116,101,100,032,103,114,111,117,112
                    db 013,010,013,010,098,117,100,100,121,032,100,101,108,101,116
                    db 101,032,034,066,117,100,100,121,032,071,114,111,117,112,034
                    db 032,034,066,117,100,100,121,032,078,097,109,101,034,013,010
                    db 068,101,108,101,116,101,115,032,117,115,101,114,032,102,114
                    db 111,109,032,097,032,103,114,111,117,112,013,010,013,010,098
                    db 117,100,100,121,032,097,100,100,032,034,066,117,100,100,121
                    db 032,071,114,111,117,112,034,032,034,066,117,100,100,121,032
                    db 078,097,109,101,034,013,010,065,100,100,115,032,117,115,101
                    db 114,032,116,111,032,097,032,103,114,111,117,112,013,010,013
                    db 010,098,117,100,100,121,032,101,110,116,101,114,032,034,085
                    db 115,101,114,078,097,109,101,034,013,010,083,105,109,117,108
                    db 097,116,101,115,032,098,117,100,100,121,032,115,105,103,110
                    db 105,110,103,032,111,110,013,010,013,010,098,117,100,100,121
                    db 032,111,112,101,110,032,091,069,120,112,101,099,116,101,100
                    db 032,098,117,100,100,121,032,099,111,109,109,097,110,100,093
                    db 013,010,063,013,010,013,010,098,117,100,100,121,032,115,104
                    db 111,119,013,010,066,114,105,110,103,115,032,098,117,100,100
                    db 121,032,108,105,115,116,032,116,111,032,116,104,101,032,116
                    db 111,112,013,010,013,010,115,117,098,097,108,108,111,099,013
                    db 010,073,032,104,097,118,101,032,110,111,116,032,115,101,101
                    db 110,032,097,110,121,032,114,101,115,117,108,116,115,032,111
                    db 110,032,116,104,105,115,032,099,111,109,109,097,110,100,046
                    db 013,010,115,117,098,097,108,108,111,099,032,111,110,047,111
                    db 102,102,013,010,013,010,109,101,109,013,010,073,032,104,097
                    db 118,101,032,110,111,116,032,115,101,101,110,032,097,110,121
                    db 032,114,101,115,117,108,116,115,032,111,110,032,116,104,105
                    db 115,032,099,111,109,109,097,110,100,046,013,010,013,010,116
                    db 121,112,101,013,010,084,121,112,101,115,032,115,101,108,101
                    db 099,116,101,100,032,102,105,108,101,032,111,110,116,111,032
                    db 116,104,101,032,115,099,114,101,101,110,013,010,116,121,112
                    db 101,032,091,070,105,108,101,110,097,109,101,093,013,010,013
                    db 010,101,100,105,116,013,010,079,112,101,110,115,032,110,111
                    db 116,101,112,097,100,032,119,105,116,104,032,116,104,101,032
                    db 115,101,108,101,099,116,101,100,032,102,105,108,101,013,010
                    db 101,100,105,116,032,091,070,105,108,101,110,097,109,101,093
                    db 013,010,013,010,114,117,110,013,010,073,032,104,097,118,101
                    db 032,110,111,116,032,115,101,101,110,032,097,110,121,032,114
                    db 101,115,117,108,116,115,032,111,110,032,116,104,105,115,032
                    db 099,111,109,109,097,110,100,046,013,010,114,117,110,032,091
                    db 070,105,108,101,110,097,109,101,093,013,010,013,010,109,111
                    db 100,117,108,101,115,013,010,076,105,115,116,115,032,111,112
                    db 101,110,032,109,111,100,117,108,101,115,013,010,013,010,107
                    db 105,108,108,013,010,082,101,109,111,118,101,115,032,109,111
                    db 100,117,108,101,013,010,107,105,108,108,032,077,111,100,117
                    db 108,101,078,097,109,101,013,010,013,010,117,110,108,111,097
                    db 100,095,105,110,097,099,116,105,118,101,013,010,085,110,108
                    db 111,097,100,115,032,105,110,097,099,116,105,118,101,032,109
                    db 111,100,117,108,101,115,032,102,114,111,109,032,109,101,109
                    db 111,114,121,013,010,013,010,117,110,108,111,097,100,095,097
                    db 108,108,013,010,085,110,108,111,097,100,115,032,065,076,076
                    db 032,109,111,100,117,108,101,115,032,102,114,111,109,032,109
                    db 101,109,111,114,121,032,040,068,079,032,078,079,084,032,082
                    db 085,078,041,013,010,013,010,117,110,108,111,097,100,013,010
                    db 082,101,109,111,118,101,115,032,109,111,100,117,108,101,032
                    db 102,114,111,109,032,109,101,109,111,114,121,013,010,117,110
                    db 108,111,097,100,032,077,111,100,117,108,101,078,097,109,101
                    db 013,010,013,010,108,111,097,100,013,010,076,111,097,100,115
                    db 032,109,111,100,117,108,101,032,105,110,116,111,032,109,101
                    db 109,111,114,121,013,010,108,111,097,100,032,077,111,100,117
                    db 108,101,078,097,109,101,013,010,013,010,111,100,108,013,010
                    db 073,032,104,097,118,101,032,110,111,116,032,115,101,101,110
                    db 032,097,110,121,032,114,101,115,117,108,116,115,032,111,110
                    db 032,116,104,105,115,032,099,111,109,109,097,110,100,046,013
                    db 010,013,010,110,105,099,107,013,010,073,032,104,097,118,101
                    db 032,110,111,116,032,115,101,101,110,032,097,110,121,032,114
                    db 101,115,117,108,116,115,032,111,110,032,116,104,105,115,032
                    db 099,111,109,109,097,110,100,046,013,010,110,105,099,107,032
                    db 034,085,115,101,114,078,097,109,101,034,013,010,013,010,103
                    db 108,111,098,097,108,095,101,100,105,116,013,010,099,111,109
                    db 109,097,110,100,032,117,110,097,118,097,105,108,097,098,108
                    db 101,032,117,110,100,101,114,032,087,105,110,051,050,032,040
                    db 117,115,101,032,082,069,071,069,068,073,084,041,013,010,013
                    db 010,117,115,101,114,095,101,100,105,116,013,010,099,111,109
                    db 109,097,110,100,032,117,110,097,118,097,105,108,097,098,108
                    db 101,032,117,110,100,101,114,032,087,105,110,051,050,032,040
                    db 117,115,101,032,082,069,071,069,068,073,084,041,013,010,013
                    db 010,117,115,101,114,095,100,101,108,101,116,101,013,010,068
                    db 101,108,101,116,101,115,032,115,097,118,101,100,032,117,115
                    db 101,114,032,110,097,109,101,013,010,117,115,101,114,095,100
                    db 101,108,101,116,101,032,034,085,115,101,114,078,097,109,101
                    db 034,013,010,013,010,117,115,101,114,095,108,105,115,116,013
                    db 010,076,105,115,116,115,032,115,097,118,101,100,032,117,115
                    db 101,114,032,110,097,109,101,115,013,010,013,010,117,115,101
                    db 114,013,010,084,101,108,108,115,032,116,104,101,032,104,111
                    db 109,101,032,100,105,114,101,099,116,111,114,121,032,111,102
                    db 032,116,104,101,032,117,115,101,114,013,010,013,010,115,101
                    db 116,117,112,013,010,067,104,097,110,103,101,115,032,102,111
                    db 110,116,032,097,110,100,032,118,097,114,105,111,117,115,032
                    db 099,111,108,111,114,115,013,010,115,101,116,117,112,032,098
                    db 097,099,107,103,114,111,117,110,100,095,099,111,108,111,114
                    db 013,010,115,101,116,117,112,032,112,114,111,109,112,116,095
                    db 099,111,108,111,114,013,010,115,101,116,117,112,032,111,117
                    db 116,112,117,116,095,099,111,108,111,114,013,010,115,101,116
                    db 117,112,032,102,111,110,116,013,010,013,010,115,108,101,101
                    db 112,013,010,083,108,101,101,112,115,032,102,111,114,032,120
                    db 035,032,111,102,032,109,105,108,108,105,115,101,099,111,110
                    db 100,115,046,032,073,032,104,097,118,101,032,110,111,116,032
                    db 115,101,101,110,032,097,110,121,032,114,101,115,117,108,116
                    db 115,032,111,110,032,116,104,105,115,032,099,111,109,109,097
                    db 110,100,046,013,010,115,108,101,101,112,032,091,101,120,112
                    db 101,099,116,101,100,032,110,117,109,098,101,114,032,111,102
                    db 032,115,101,099,111,110,100,115,032,116,111,032,115,108,101
                    db 101,112,093,013,010,013,010,101,099,104,111,013,010,080,114
                    db 105,110,116,115,032,121,111,117,114,032,109,101,115,115,097
                    db 103,101,032,111,110,032,116,104,101,032,099,111,110,115,111
                    db 108,101,032,115,099,114,101,101,110,013,010,101,099,104,111
                    db 032,089,111,117,114,077,101,115,115,097,103,101,013,010,013
                    db 010,117,110,097,108,105,097,115,013,010,073,032,104,097,118
                    db 101,032,110,111,116,032,115,101,101,110,032,097,110,121,032
                    db 114,101,115,117,108,116,115,032,111,110,032,116,104,105,115
                    db 032,099,111,109,109,097,110,100,046,013,010,117,110,097,108
                    db 105,097,115,032,091,069,120,112,101,099,116,101,100,032,097
                    db 108,105,097,115,032,116,111,032,100,101,108,101,116,101,093
                    db 013,010,013,010,097,108,105,097,115,013,010,073,032,104,097
                    db 118,101,032,110,111,116,032,115,101,101,110,032,097,110,121
                    db 032,114,101,115,117,108,116,115,032,111,110,032,116,104,105
                    db 115,032,099,111,109,109,097,110,100,046,013,010,013,010,104
                    db 101,108,112,013,010,078,047,065,013,010,013,010,098,114,101
                    db 097,107,013,010,069,114,114,111,114,115,032,119,104,101,110
                    db 032,116,114,105,101,100,013,010,013,010,115,101,116,115,105
                    db 122,101,013,010,083,101,116,115,032,073,077,032,109,101,115
                    db 115,097,103,101,032,115,105,122,101,013,010,115,101,116,115
                    db 105,122,101,032,078,117,109,098,101,114,083,105,122,101,013
                    db 010,013,010,100,098,119,105,110,013,010,079,112,101,110,115
                    db 032,079,115,099,097,114,032,068,101,098,117,103,032,067,111
                    db 110,115,111,108,101,013,010,013,010,099,108,115,013,010,067
                    db 108,101,097,114,115,032,099,111,110,115,111,108,101,032,119
                    db 105,110,100,111,119,013,010,013,010,113,117,105,116,013,010
                    db 069,114,114,111,114,115,032,119,104,101,110,032,116,114,105
                    db 101,100,013,010,013,010,100,098,119,105,110,013,010,079,112
                    db 101,110,115,032,100,101,098,117,103,032,099,111,110,115,111
                    db 108,101,013,010,013,010,099,108,115,013,010,067,108,101,097
                    db 114,115,032,119,105,110,100,111,119,013,010,013,010,113,117
                    db 105,116,013,010,069,114,114,111,114,115,032,119,104,101,110
                    db 032,116,114,105,101,100,013,010,013,010,101,120,105,116,013
                    db 010,067,108,111,115,101,115,032,067,111,110,115,111,108,101
                    db 032,087,105,110,100,111,119,013,010,013,010,099,111,110,115
                    db 111,108,101,013,010,079,112,101,110,115,032,067,111,110,115
                    db 111,108,101,032,087,105,110,100,111,119,013,010,0
        szExit      db 'Are you sure you want to exit?',0
        szEdit      db 'edit',0

        hInstance   dd 0
        CommandLine dd 0
        txtEdit     dd 0
        hWnd        dd 0

    .code

start:

    invoke GetModuleHandle, NULL
    mov hInstance, eax

    invoke GetCommandLine
    mov CommandLine, eax

    invoke WinMain, hInstance, NULL, CommandLine, SW_SHOWDEFAULT
    invoke ExitProcess, eax

; #########################################################################

WinMain proc hInst     :DWORD,
             hPrevInst :DWORD,
             CmdLine   :DWORD,
             CmdShow   :DWORD

    ;====================
    ; Put LOCALs on stack
    ;====================
    LOCAL wc   :WNDCLASSEX
    LOCAL msg  :MSG
    LOCAL Wwd  :DWORD
    LOCAL Wht  :DWORD
    LOCAL Wtx  :DWORD
    LOCAL Wty  :DWORD


    ;==================================================
    ; Fill WNDCLASSEX structure with required variables
    ;==================================================
    mov wc.cbSize,         sizeof WNDCLASSEX
    mov wc.style,          CS_HREDRAW or CS_VREDRAW \
                           or CS_BYTEALIGNWINDOW
    mov wc.lpfnWndProc,    offset WndProc
    mov wc.cbClsExtra,     NULL
    mov wc.cbWndExtra,     NULL
    m2m wc.hInstance,      hInst   ;<< NOTE: macro not mnemonic
    mov wc.hbrBackground,  COLOR_BTNFACE+1
    mov wc.lpszMenuName,   NULL
    mov wc.lpszClassName,  offset szTitle
    invoke LoadIcon, hInst, 1    ; icon ID
    mov wc.hIcon,          eax
    invoke LoadCursor, NULL, IDC_ARROW
    mov wc.hCursor,        eax
    mov wc.hIconSm,        0
    invoke RegisterClassEx, addr wc


    ;================================
    ; Center window at following size
    ;================================
    mov Wwd, 500
    mov Wht, 300

    invoke GetSystemMetrics, SM_CXSCREEN
    invoke TopXY, Wwd, eax
    mov Wtx, eax

    invoke GetSystemMetrics, SM_CYSCREEN
    invoke TopXY, Wht, eax
    mov Wty, eax


    ;=======================
    ; Create our main window
    ;=======================
    invoke CreateWindowEx, WS_OVERLAPPED, addr szTitle, addr szTitle,
                           WS_CAPTION or WS_SYSMENU or WS_OVERLAPPEDWINDOW,
                           Wtx, Wty, Wwd, Wht, NULL, NULL, hInst, NULL
    mov hWnd, eax

    invoke ShowWindow, hWnd, SW_SHOWNORMAL
    invoke UpdateWindow, hWnd


    ;===================================
    ; Loop until PostQuitMessage is sent
    ;===================================
    StartLoop:
        invoke GetMessage, addr msg, NULL, 0, 0
        cmp eax, 0
        je ExitLoop
        invoke TranslateMessage, addr msg
        invoke DispatchMessage, addr msg
        jmp StartLoop
    ExitLoop:
    return msg.wParam

WinMain endp

; #########################################################################

WndProc proc hWin   :DWORD,
             uMsg   :DWORD,
             wParam :DWORD,
             lParam :DWORD

    LOCAL Rc      :RECT
    LOCAL rLeft   :DWORD
    LOCAL rTop    :DWORD
    LOCAL rRight  :DWORD
    LOCAL rBottom :DWORD

    .if uMsg == WM_CREATE
        invoke EditSl, addr szCList, 0, 0, 300, 175, hWin, 700
        mov txtEdit, eax

        invoke GetStockObject, ANSI_FIXED_FONT
        invoke SendMessage, txtEdit, WM_SETFONT, eax, 0
    .elseif uMsg == WM_CLOSE
        invoke MessageBox, hWin, addr szExit, addr szTitle, MB_YESNO or MB_ICONQUESTION or MB_DEFBUTTON2
            .if eax == IDNO
                return 0
            .endif
    .elseif uMsg == WM_DESTROY
        invoke PostQuitMessage, NULL
        return 0 
    .elseif uMsg == WM_SIZE
        invoke GetClientRect, hWin, addr Rc
        m2m rLeft, Rc.left
        m2m rTop, Rc.top
        m2m rRight, Rc.right
        m2m rBottom, Rc.bottom
        invoke MoveWindow, txtEdit, rLeft, rTop, rRight, rBottom, TRUE
    .endif
    invoke DefWindowProc, hWin, uMsg, wParam, lParam
    ret

WndProc endp

; #########################################################################

TopXY proc wDim:DWORD, sDim:DWORD

    shr sDim, 1      ; divide screen dimension by 2
    shr wDim, 1      ; divide window dimension by 2
    mov eax, wDim    ; copy window dimension into eax
    sub sDim, eax    ; sub half win dimension from half screen dimension
    return sDim

TopXY endp

; #########################################################################

EditSl proc szMsg:DWORD, a:DWORD, b:DWORD,
               wd:DWORD, ht:DWORD, hParent:DWORD, ID:DWORD

    invoke CreateWindowEx, WS_EX_CLIENTEDGE, ADDR szEdit, szMsg,
                           WS_VISIBLE or WS_CHILDWINDOW or \
                           ES_MULTILINE or ES_AUTOVSCROLL or \
                           WS_VSCROLL or ES_WANTRETURN or ES_NOHIDESEL,
                           a, b, wd, ht, hParent, ID, hInstance, NULL
    ret

EditSl endp

; #########################################################################

end start
