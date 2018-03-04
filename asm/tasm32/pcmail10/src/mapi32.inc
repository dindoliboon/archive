SUCCESS_SUCCESS equ 0
MAPI_LOGON_UI	equ 1
MAPI_NEW_SESSION equ 2
MAPI_RECEIPT_REQUESTED equ 2
; Virogen's Simple MAPI Structures
MapiMessage struct
     resd 		dd ?
     lpszSubject 	dd ?
     lpszNoteText 	dd ?
     lpszMessageType 	dd ?
     lpszDateReceived	dd ?
     lpszConversationID dd ?
     flags 		dd ?	
     lpOriginator 	dd ?	; ptr to MapiRecipDesc
     nRecipCount	dd ?	; # of MapiRecipDesc structures
     lpRecips		dd ?	; ptr to first MapiRecipDesc
     nFileCount		dd ?	; # of MapiFileDesc structures
     lpFiles		dd ?	; ptr to first MapiFileDesc
MapiMessage ends

MapiRecipDesc struct
     resd 		dd ?
     ulRecipClass	dd ?
     lpszName		dd ?
     lpszAddress	dd ?
     ulEIDSize		dd ?
     lpEntryID		dd ?
MapiRecipDesc ends

MapiFileDesc struct
     resd		dd ?
     flFlags		dd ?
     nPosition		dd ?
     lpszPathName	dd ?
     lpszFileName	dd ?
     lpFileType		dd ?	
MapiFileDesc ends