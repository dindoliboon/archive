ERAR_END_ARCHIVE	equ	10
ERAR_NO_MEMORY		equ	11
ERAR_BAD_DATA		equ	12
ERAR_BAD_ARCHIVE	equ	13
ERAR_UNKNOWN_FORMAT	equ	14
ERAR_EOPEN		equ	15
ERAR_ECREATE		equ	16
ERAR_ECLOSE		equ	17
ERAR_EREAD		equ	18
ERAR_EWRITE		equ	19
ERAR_SMALL_BUF		equ	20

RAR_OM_LIST		equ	0
RAR_OM_EXTRACT		equ	1

RAR_SKIP		equ	0
RAR_TEST		equ	1
RAR_EXTRACT		equ	2

RAR_VOL_ASK		equ	0
RAR_VOL_NOTIFY		equ	1

RARHeaderData		struct
	ArcName		db 260 dup(?)
	FileName	db 260 dup(?)
	Flags		dd ?
	PackSize	dd ?
	UnpSize		dd ?
	HostOS		dd ?
	FileCRC		dd ?
	FileTime	dd ?
	UnpVer		dd ?
	Method		dd ?
	FileAttr	dd ?
	CmtBuf		dd ?
	CmtBufSize	dd ?
	CmtSize		dd ?
	CmtState	dd ?
RARHeaderData		ends

RAROpenArchiveData	struct
	ArcName		dd ?
	OpenMode	dd ?
	OpenResult	dd ?
	CmtBuf		dd ?
	CmtBufSize	dd ?
	CmtSize		dd ?
	CmtState	dd ?
RAROpenArchiveData	ends


;HANDLE PASCAL RAROpenArchive(struct RAROpenArchiveData *ArchiveData);
;int PASCAL RARCloseArchive(HANDLE hArcData);
;int PASCAL RARReadHeader(HANDLE hArcData,struct RARHeaderData *HeaderData);
;int PASCAL RARProcessFile(HANDLE hArcData,int Operation,char *DestPath,char *DestName);
;void PASCAL RARSetChangeVolProc(HANDLE hArcData,int (*ChangeVolProc)(char *ArcName,int Mode));
;void PASCAL RARSetProcessDataProc(HANDLE hArcData,int (*ProcessDataProc)(unsigned char *Addr,int Size));
;void PASCAL RARSetPassword(HANDLE hArcData,char *Password);
