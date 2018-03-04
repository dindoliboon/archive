;   
; PCMail v1.00 
;
; synopsis: 
; This win32asm program demonstrates use of simple MAPI to send
; an email message with file attachments,etc. This is not one
; of my greater achievements but anyone interested in using 
; MAPI32.DLL might be interested. 
;
; info and usage:
;  -self explanitory really. Multiple file attachments are 
;   seperated by a semicolon. Maximum of 10 file attachments 
;   allowed.
;  -your last typed from box will be saved in pcmail.ini, and
;   restored on next load. Note that this field may not be 
;   effective and will not allow you to send anonymous emails.
; 
;					latez..
;					Virogen
;  
;

extrn ExitProcess:PROC
extrn GetProcAddress:PROC
extrn LoadLibraryA:PROC
extrn MessageBoxA:PROC
extrn FreeLibrary:PROC
extrn GetModuleHandleA:PROC
extrn DialogBoxParamA:PROC
extrn LoadIconA:PROC
extrn DispatchMessageA:PROC
extrn PostQuitMessage:PROC
extrn GetDlgItemTextA:PROC
extrn SetDlgItemTextA:PROC
extrn GlobalAlloc:PROC
extrn GlobalFree:PROC
extrn GetOpenFileNameA:PROC
extrn lstrlen:PROC
extrn lstrcat:PROC
extrn SetFocus:PROC
extrn SendDlgItemMessageA:PROC
extrn SendMessageA:PROC
extrn LoadIconA:PROC
extrn GetPrivateProfileStringA:PROC
extrn WritePrivateProfileStringA:PROC

MAX_TXT equ 1000h
MAX_SUBJECT equ 100h
MAX_SINGLEFNAME equ 100h
MAX_ATTACH equ 10
MAX_FNAME equ MAX_SINGLEFNAME*MAX_ATTACH

.386p
locals
jumps
.model flat,STDCALL
include vgres.inc
include mywin.inc
include mapi32.inc

; whoop, all our dynamic variables
dynvars STRUCT
mapihnd 	dd 0
MAPISendMail 	dd 0
PCMapiMessage 	MapiMessage <0>
Originator 	MapiRecipDesc <0>
Recips 		MapiRecipDesc <0>
Attachments	MapiFileDesc MAX_ATTACH dup (<0>)
wc 		WNDCLASSEX <0>
msg 		MSG <0>
ofn 		OFN <0>
DateReceived 	db 10 dup (0)
MessageText 	db MAX_TXT dup(0)
Subject 	db MAX_SUBJECT dup(0)
OriginatorAddress db 200 dup(0)
RecipName 	db 200 dup(0)
RecipAddress 	db 200 dup(0)
r_wparam 	dd 0
hInst 		dd 0
hMain 		dd 0
fname 		dd MAX_FNAME dup(0)
singlefname 	dd MAX_SINGLEFNAME dup(0)
dynvars ENDS

.code
start:
	call    GlobalAlloc,64,size dynvars
	or	eax,eax
	jnz	good_alloc	
	call	MessageBoxA,0,offset memerr_txt,offset caption,MB_ICONSTOP
	call	ExitProcess,-1
good_alloc:	
	
	xchg	edi,eax	
	mov	pdynvars,edi
		
	call 	GetModuleHandleA,0
	mov	[dynvars.hInst+edi],eax
  	 	 	 	
 	call	DialogBoxParamA, eax, IDD_PCSMAIL, 0, offset WndProc, 0
	
	call	GlobalFree,edi
	call	ExitProcess,0	
	
WndProc  PROC   hwnd:DWORD, wmsg:DWORD, wparam:DWORD, lparam:DWORD
	 USES ebx, edi, esi							
	mov	edi,pdynvars	
	mov	eax,wparam		
	mov	[dynvars.r_wparam+edi],eax			
	mov	eax,hwnd
	mov	[dynvars.hMain+edi],eax
	mov	eax,wmsg	
	cmp	ax,WM_INITDIALOG
	jz	init
	cmp	ax,WM_DESTROY
	jz	destroy
	cmp	ax,WM_COMMAND
	jz	cmd
	xor	eax,eax  
	ret
init:	
        call    LoadIconA,[dynvars.hInst+edi],IDI_ICON1                                                 
        push	eax
        call    SendMessageA,[dynvars.hMain+edi],WM_SETICON,ICON_SMALL,eax      
        pop 	eax
        call    SendMessageA,[dynvars.hMain+edi],WM_SETICON,ICON_BIG,eax
       	lea	ebx,[dynvars.OriginatorAddress+edi]	
	call    GetPrivateProfileStringA,offset AppName,offset KeyName,offset Default,ebx,200,offset FileName		
	call	SetDlgItemTextA, [dynvars.hMain+edi], IDC_FROMBOX, ebx
	xor	eax,eax
	ret

destroy:
	call	PostQuitMessage,0
	xor	eax,eax
	ret	

cmd:	
	mov	eax,[dynvars.r_wparam+edi]
	cmp	ax,IDCANCEL
	jz	destroy
	cmp	ax,IDOK
	jz	sendmail
	cmp	ax,IDC_BROWSE
	jz	getfile
	xor	eax,eax
	ret
			
getfile:	
	mov	eax,[dynvars.hMain+edi]
	mov	[dynvars.ofn.hWndOwner+edi],eax			
	mov	[dynvars.ofn.lpstrFilter+edi],offset filter
	lea	eax,[dynvars.singlefname+edi]
	mov	[dynvars.ofn.lpstrFile+edi],eax
	mov	[dynvars.ofn.lStructSize+edi],size ofn
	mov	[dynvars.ofn.nMaxFile+edi],MAX_SINGLEFNAME
	mov	[dynvars.ofn.ofn_Flags+edi],OFN_HIDEREADONLY
	lea	eax,[dynvars.ofn+edi]
	call	GetOpenFileNameA, eax
	or	eax,eax
	jz	no_file
	lea	ebx,[dynvars.fname+edi]	
	call	GetDlgItemTextA, [dynvars.hMain+edi], IDC_ATTACH, ebx
	or	eax,eax
	jz	no_semi
	call	lstrcat,ebx,offset semicolon	
no_semi:	
	lea	eax,[dynvars.singlefname+edi]
	lea	ebx,[dynvars.fname+edi]
	call	lstrcat,ebx,eax	
	
	lea	eax,[dynvars.fname+edi]
	call	SetDlgItemTextA, [dynvars.hMain+edi], IDC_ATTACH, eax
	xor	eax,eax
no_file:	
	ret
		
sendmail:		
	lea	eax,[dynvars.RecipAddress+5+edi]
	call	GetDlgItemTextA,[dynvars.hMain+edi],IDC_TOBOX,eax,200
	or	eax,eax
	jz	no_recip
	mov	dword ptr [dynvars.RecipAddress+edi],'ptms'
	mov	[dynvars.RecipAddress+4+edi],':'
	lea	ebx,[dynvars.OriginatorAddress+edi]	
	call	GetDlgItemTextA,[dynvars.hMain+edi],IDC_FROMBOX,ebx,200		
	call    WritePrivateProfileStringA,offset AppName,offset KeyName,ebx,offset FileName		
	lea	eax,[dynvars.MessageText+edi]
	call	GetDlgItemTextA,[dynvars.hMain+edi],IDC_MSGTEXT,eax,MAX_TXT
	lea	eax,[dynvars.Subject+edi]
	call	GetDlgItemTextA,[dynvars.hMain+edi],IDC_SUBJECT,eax,MAX_SUBJECT
	lea 	eax,[dynvars.fname+edi]
	call	GetDlgItemTextA,[dynvars.hMain+edi],IDC_ATTACH,eax,MAX_FNAME
	call 	domapi	
	xor	eax,eax
	ret	
no_recip:
	call	MessageBoxA,[dynvars.hMain+edi],offset norecip_txt,offset caption,MB_ICONHAND
	xor	eax,eax
	ret
WndProc endp	

domapi:
       	call 	LoadLibraryA,offset mapi32
       	mov	[dynvars.mapihnd+edi],eax
       	or 	eax,eax
       	jz	no_mapi
       	call	GetProcAddress,[dynvars.mapihnd+edi],offset MSendMail
       	mov	[dynvars.MAPISendMail+edi],eax
       	or	eax,eax
       	jz	no_mapi_unload
       
       	mov	[dynvars.Recips.ulRecipClass+edi],1	; primar recip
       	lea	eax,[dynvars.RecipAddress+edi]
       	mov	[dynvars.Recips.lpszName+edi],eax
       	mov	[dynvars.Recips.lpszAddress+edi],eax
      	; originator defaults 0        
       	lea	eax,[dynvars.OriginatorAddress+edi]
       	mov	[dynvars.Originator.lpszName+edi],eax
       	mov	[dynvars.Originator.lpszAddress+edi],eax

       	lea	eax,[dynvars.Subject+edi]
       	mov 	[dynvars.PCMapiMessage.lpszSubject+edi],eax
       	lea	eax,[dynvars.MessageText+edi]
       	mov	[dynvars.PCMapiMessage.lpszNoteText+edi],eax
       	mov	[dynvars.PCMapiMessage.lpszMessageType+edi],0
       	lea	eax,[dynvars.DateReceived+edi]
       	mov	[dynvars.PCMapiMessage.lpszDateReceived+edi],eax
       	mov	[dynvars.PCMapiMessage.flags+edi],MAPI_RECEIPT_REQUESTED 
       	lea	eax,[dynvars.Originator+edi]
       	mov	[dynvars.PCMapiMessage.lpOriginator+edi],eax
       	mov	[dynvars.PCMapiMessage.nRecipCount+edi],1	
       	lea	eax,[dynvars.Recips+edi]
       	mov	[dynvars.PCMapiMessage.lpRecips+edi],eax
       	cmp	byte ptr [dynvars.fname+edi],0
       	jnz	are_attachments
       	mov	[dynvars.PCMapiMessage.nFileCount+edi],0      
       	jmp	no_attach
are_attachments:       
       	lea	esi,[dynvars.fname+edi]       
       	call	parse_files       
       	mov	[dynvars.PCMapiMessage.nFileCount+edi],eax
       	lea	eax,[dynvars.Attachments+edi]
       	mov	[dynvars.PCMapiMessage.lpFiles+edi],eax
no_attach:       
       	lea	eax,[dynvars.PCMapiMessage+edi]       
       	call	[dynvars.MAPISendMail+edi],0,[dynvars.hMain+edi],eax,0,0
       	or	eax,eax
       	jz	good_send
       	call	MessageBoxA,[dynvars.hMain+edi],offset senderr_txt,offset caption,0
       	jmp	all_good
good_send:       
       	call 	MessageBoxA,[dynvars.hMain+edi],offset good_txt,offset caption,0
       	jmp	all_good
no_mapi_unload:
       	call 	MessageBoxA,[dynvars.hMain+edi],offset bad_txt,offset caption,MB_ICONEXCLAMATION
all_good:
       	call	FreeLibrary,[dynvars.mapihnd+edi]
       	ret
no_mapi:
       	call	MessageBoxA,[dynvars.hMain+edi],offset bad_txt,offset caption,MB_ICONEXCLAMATION
       	ret

; entry esi->fnames
parse_files:                     
       	push	edi ebp
       	mov	ebx,edi       
       	lea	edx,[dynvars.Attachments.lpszPathName+edi]       
       	mov	edi,esi       
       	xor	ebp,ebp
ploop0:       	
       	inc	ebp
       	mov	[edx],esi	
       	mov	ecx,MAX_FNAME              
ploop: 	      
       	lodsb
       	or 	al,al
       	jz 	over_files
       	cmp	al,';'
       	jz	afile
       	stosb       
       	loop	ploop
afile: 	             
       	add	edx,size MapiFileDesc             
       	xor	eax,eax
       	stosb              
       	cmp	ebp,MAX_ATTACH
       	jnz	ploop0
over_files:       
       	stosb       
       	xchg 	eax,ebp
       	pop	ebp edi              	
       	ret
.data
semicolon   db ';',0
caption     db 'PCMAIL v1.00',0
bad_txt     db 'Could not load MAPI32.DLL and/or import necessary APIs',0
senderr_txt db 'Error sending message!',0
norecip_txt db 'You must specify a recipient first!',0
memerr_txt  db 'Error allocating memory!',0
MSendMail   db 'MAPISendMail',0
good_txt    db 'Message Sent!',0
mapi32      db 'MAPI32.DLL',0
szClass     db 'PCSMAIL',0
filter 	    db 'All files',0,'*.*',0
AppName     db 'PCMAIL',0
KeyName     db 'Originator',0
Default     db 'Default',0
FileName    db 'PCMAIL.INI',0
pdynvars    dd 0
end start
ends
		 
 
 
 
 
