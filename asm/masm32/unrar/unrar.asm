;	Uzycie biblioteki UNRAR.DLL w win32asm
;
;	bart^CrackPl
;	cryogen@poland.com

	.386
	.model flat,stdcall

	extrn		wsprintfA:proc

	includelib	e:\dev\masm\lib\kernel32.lib
	includelib	e:\dev\masm\lib\user32.lib
	includelib	e:\dev\masm\lib\comdlg32.lib
	includelib	e:\dev\masm\lib\comctl32.lib
	includelib	e:\dev\masm\lib\advapi32.lib
	includelib	e:\dev\masm\lib\shell32.lib

	include		e:\dev\masm\include\kernel32.inc
	include		e:\dev\masm\include\user32.inc
	include		e:\dev\masm\include\comdlg32.inc
	include		e:\dev\masm\include\comctl32.inc
	include		e:\dev\masm\include\advapi32.inc
	include		e:\dev\masm\include\shell32.inc

	include		unrar.inc

	option		casemap	:none
	assume		fs	:flat

BROWSEINFO			struct
	bi_hWnd			dd ?	; uchwyt okna-wlasciciela
	bi_pidlRoot		dd ?	; okresla poczatkowy katalog,uzytkownik
					; nie moze sie cofnac powyzej tego katalogu
	bi_szDisplayName	dd ?	; tu zostanie zapisana nazwa wybranego katalogu
					; ale nie sciezka!
	bi_szTitle		dd ?	; text okienka wyboru katalogow
	bi_Flags		dd ?	; typ przegladanych folderow
	bi_lpCallback		dd ?	; wskaznik do funkcji callback
	bi_lParam		dd ?	; wartosc uzywana w funkcji callback
	bi_iImage		dd ?	; indeks ikony w systemowej ImageList wybranego katalogu
BROWSEINFO			ends

; parametry dla bi_Flags

BIF_BROWSEFORCOMPUTER	equ 1000h	; przegladanie otoczenia sieciowego.
BIF_BROWSEFORPRINTER	equ 2000h	; przegladanie drukarek sieciowych.
BIF_RETURNONLYFSDIRS	equ 1		; zwraca dyski i katalogi.
BIF_DONTGOBELOWDOMAIN	equ 2		; zapobiega wyswietlaniu folderow sieciowych
BIF_STATUSTEXT		equ 4		; wyswietla tekst na okienku dialogowym.					; lezacych ponizej poziomu domeny.
BIF_RETURNFSANCESTORS	equ 8		; zwraca przodkow systemu plikow (co to jest??)

; parametry ktore otrzymuje funkcja callback
; lpCallback(HWND hwnd,UINT uMsg, LPARAM lParam, LPARAM lpData )

WM_USER			equ 400h
BFFM_INITIALIZED	equ 1
BFFM_SELCHANGED		equ 2
BFFM_SETSTATUSTEXT	equ (WM_USER + 100)
BFFM_ENABLEOK		equ (WM_USER + 101)
BFFM_SETSELECTION	equ (WM_USER + 102)

LPMALLOC			struct
	ma_lpMallocVtabl	dd ?	; adres wskaznika do virtualnej tabeli z offsetami funkcji
LPMALLOC			ends

ma_QueryInterface	equ 0		; kolejne lokacje funkcji w virtualnej tabeli
ma_AddRef		equ 4
ma_Release		equ 8
ma_Alloc		equ 12
ma_Realloc		equ 16
ma_Free			equ 20
ma_GetSize		equ 24
ma_DidAlloc		equ 28
ma_HeapMinimize		equ 32

.data

	lpMyDir			BROWSEINFO <?>
	lpMyMalloc		LPMALLOC <?>
	lpDirectory		db 255 dup(?)
	szTitle			db 'Wybierz katalog docelowy',0
	pidl			dd ?
	lpFolder		dd ?

;ллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллл
	lpOfn			label byte
	ofn_lStructSize		dd	cbOfn	;number of bytes
	ofnhWndOwner		dd	0
	ofnhInstance		dd	0	;dialog box template id
	ofn_lpstrFilter		dd	offset szFilter		;filter strings
	ofn_lpstrCustomFilter	dd	0	;user-defined filter stings
	ofn_nMaxCustFilter	dd	0	;size of custom filter buffer
	ofn_nFilterIndex	dd	0	;index into the filter buffer
	ofn_lpstrFile		dd	offset lpFilename	;default file name buffer
	ofn_nMaxFile		dd	255	;size of the file name buffer
	ofn_lpstrFileTitle	dd	0	;file title buffer
	ofn_nMaxFileTitle	dd	0	;size of the file title buffer
	ofn_lpstrInitialDir	dd	0	;initial directory
	ofn_lpstrTitle		dd	offset szCaption	;dialog box title
	ofn_Flags		dd	4	;dialog box creation flags
	ofn_nFileOffset		dw	0	;file name offset in lpstrFile
	ofn_nFileExtension	dw	0	;file ext offset in lpstrFile
	ofn_lpstrDefExt		dd	0	;default extension
	ofn_lCustData		dd	0	;application-defined hook data
	ofn_lpfnHook		dd	0	;hook function
	ofn_lpTemplateName	dd	0	;dialog box template name
	cbOfn			equ $-lpOfn

	szFilter		db 'Rar files(*.rar)',0,'*.rar',0,'All files(*.*)',0,'*.*',0,0

	szCaption		db 'Unrar by bart^CrackPl',0
	lCaption		equ $-szCaption-1

	szOpenError		db 'Cannot open archive file!',0
	szReadError		db 'There was errors while reading file:',0Dh,0Ah,0Dh,0Ah
				db '%s',0Dh,0Ah,0Dh,0Ah
				db 'Press OK to process next file in archive,hit CANCEL to exit',0

	lpFilename		db 255 dup(?)
	lpBuf			db 255 dup(?)

	szUnrar			db 'UNRAR.DLL',0	

	szApis			db 0
	RAROpenArchive		db 'RAROpenArchive',0
	RARCloseArchive		db 'RARCloseArchive',0
	RARReadHeader		db 'RARReadHeader',0
	RARProcessFile		db 'RARProcessFile',0
	RARSetChangeVolProc	db 'RARSetChangeVolProc',0
	RARSetProcessDataProc	db 'RARSetProcessDataProc',0
	RARSetPassword		db 'RARSetPassword',0
				db 0

	RARHeader		RARHeaderData <>
	RARData			RAROpenArchiveData <>

	lpComment		db 16384 dup(?)
	lComment		equ 16384

	hArcData		dd ?
.code
_start:
	push	offset lpOfn
	call	GetOpenFileNameA
	test	eax,eax
	je	_exit

	push	offset szUnrar
	call	LoadLibraryA
	test	eax,eax
	je	_exit

	xchg	eax,ebx

	push	7			; lacznie jest 7 funkcji

	mov	edi,offset szApis
_next_api:
	sub	eax,eax
_end_string:
	scasb				; szukaj 00h pod edi
	jne	_end_string		; jezeli nie znaleziono edi++

	push	edi			; ptr do funkcji api
	push	ebx			; image base dll-a
	call	GetProcAddress

	stosd				; eax adres api zapisz

	dec	dword ptr[esp]
	jne	_next_api

	pop	eax
	
	mov	eax,offset RARData

	push	offset lpFilename	; nazwa archiwum
	pop	dword ptr[eax+RAROpenArchiveData.ArcName]
	
	push	RAR_OM_EXTRACT		; typ operacji
	pop	dword ptr[eax+RAROpenArchiveData.OpenMode]

	push	offset lpComment	; adres bufora gdzie zostanie zapisany komentarz archiwum
	pop	[eax+RAROpenArchiveData.CmtBuf]

					; rozmiar bufora
	mov	[eax+RAROpenArchiveData.CmtBufSize],lComment

	push	offset RARData		; adres struktury
	call	dword ptr[RAROpenArchive]

	mov	edx,[RARData.OpenResult]
	test	edx,edx
	jne	_open_error

	mov	[hArcData],eax
;
	push	offset lpMyMalloc
	call	SHGetMalloc

	mov	eax,offset lpMyDir
	sub	edx,edx

	mov	[eax+BROWSEINFO.bi_hWnd],edx
	mov	[eax+BROWSEINFO.bi_pidlRoot],edx
	mov	[eax+BROWSEINFO.bi_szDisplayName],offset lpDirectory
	mov	[eax+BROWSEINFO.bi_szTitle],offset szTitle
	mov	[eax+BROWSEINFO.bi_Flags],BIF_RETURNONLYFSDIRS or BIF_STATUSTEXT
	mov	[eax+BROWSEINFO.bi_lpCallback],edx
	mov	[eax+BROWSEINFO.bi_lParam],edx
	
	push	eax
	call	SHBrowseForFolder	; wyswietl okno dialogowe z katalogami

	test	eax,eax
	je	_default

	push	offset lpDirectory

	mov	[pidl],eax

	push	offset lpDirectory
	push	eax
	call	SHGetPathFromIDList

	push	[pidl]

	mov	ebx,[lpMyMalloc.ma_lpMallocVtabl]
	push	ebx
	mov	eax,[ebx]
	call	dword ptr[eax+ma_Free]	; w srodku tej funkcji zwykle LocalFree(pidl);

	push	ebx
	mov	eax,[ebx]
	call	dword ptr[eax+ma_Release]; a w srodku tej mov eax,1,ret

	pop	eax
_default:
	mov	[lpFolder],eax
	
;	push	offset lpChangeVolProc	; callback
;	push	eax			; hArcData
;	call	dword ptr[RARSetChangeVolProc]

_extract:
	push	offset RARHeader	; struktura header kolejnych plikow
	push	[hArcData]		; uchwyt archiwum
	call	dword ptr[RARReadHeader]; czytaj naglowek kolejnych plikow z archiwum
	test	eax,eax
	jne	_end_extracting

	push	0			; nazwa pliku
	push	[lpFolder]		; katalog docelowy
	push	RAR_EXTRACT		; operacja
	push	[hArcData]		; uchwyt archiwum
	call	dword ptr[RARProcessFile]; dekompresuj kolejne pliki

	test	eax,eax			; jezeli 0 operacja udala sie
	je	_extract

	push	offset RARHeader.FileName
	push	offset szReadError
	push	offset lpBuf
	call	wsprintfA

	pop	eax
	add	esp,4*2

	push	1 or 10h		; MB_OKCANCEL or MB_ICONHAND
	push	offset szCaption
	push	eax
	push	0
	call	MessageBoxA
	cmp	eax,1			; IDOK
	je	_extract

_end_extracting:
	push	[hArcData]
	call	dword ptr[RARCloseArchive]

	push	-1
	call	MessageBeep
_exit:
	push	-1
	call	ExitProcess

_open_error:
	mov	eax,offset szOpenError
_msg:
	push	10h
	push	offset szCaption
	push	eax
	push	0
	call	MessageBoxA

	jmp	_exit

end	_start



