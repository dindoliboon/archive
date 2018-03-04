/* ------------------------------------------------------------------------ */
/* SPLITIT.C (C) Copyright Bill Buckels 1992-1999                           */
/* All Rights Reserved.                                                     */
/*                                                                          */
/* Licence Agreement                                                        */
/* -----------------                                                        */
/*                                                                          */
/* You have a royalty-free right to use, modify, reproduce and              */
/* distribute this source code in any non-competetive way you find useful,  */
/* provided that you agree that Bill Buckels has no warranty obligations    */
/* or liability resulting from said distribution in any way whatsoever.     */
/* If you don't agree, remove this source code from your computer now.      */
/*                                                                          */
/* Written by   : Bill Buckels                                              */
/*                589 Oxford Street                                         */
/*                Winnipeg, Manitoba, Canada R3M 3J2                        */
/*                                                                          */
/* Email: bbuckels@escape.ca                                                */
/* WebSite: http://www.escape.ca/~bbuckels                                  */
/*                                                                          */
/* Date Written : November 1999                                             */
/* Purpose      : Split and Join Binary and Ascii Files                     */
/* Revision     : 3.0                                                       */
/* ------------------------------------------------------------------------ */
/* Written and Produced using                                               */
/* Microsoft (R) 32-bit C/C++ Optimizing Compiler                           */
/* Version 12.00.8168 for 80x86                                             */
/* Copyright (C) Microsoft Corp 1984-1998.                                  */
/* ------------------------------------------------------------------------ */

// our own header
#include "splitit.h"

// microsoft runtime headers
#include <stdlib.h>
#include <fcntl.h>
#include <stdio.h>
#include <io.h>
#include <sys\stat.h>
#include <string.h>
#include <dos.h>

// ------------------------------------------------------------------------
// Function prototypes
// ------------------------------------------------------------------------

// winprocs
LRESULT CALLBACK WndProc(HWND, UINT, WPARAM, LPARAM);
LRESULT CALLBACK EntryDlgProc(HWND, UINT, WPARAM, LPARAM);

// message handlers
LRESULT MultiEntry(HWND, LPSTR, LPSTR);
LRESULT MyLoad(HWND, WPARAM);
LRESULT MyAbout(HWND);
LRESULT MyHelp(HWND);
LRESULT MyMessage(HWND, LPSTR, LPSTR, LPSTR, int);

// process functions
LRESULT SplitIt(HWND, char *, unsigned long, unsigned long, WPARAM);
LRESULT TextSplit(HWND, char *, unsigned long, unsigned long);
LRESULT JoinIt(HWND, char *);
LRESULT MyCopy(LPSTR, LPSTR, BOOL);

// helper functions
LRESULT InitDialog(HWND,WORD,LPSTR);
BOOL FAR PASCAL FileExists(LPSTR, LPSTR);
LRESULT ParseCommandLine(LPSTR);
int BaseName(char *, char *);
BOOL FAR PASCAL CopyErrProc(HWND, LPSTR, LPSTR, LONG);
LRESULT FloppySize(char);
int ClearScreen(HWND,HDC,COLORREF);
void Restart(HWND);

// ------------------------------------------------------------------------
// Variables
// ------------------------------------------------------------------------
char *lpszAppName = "Splitit";
char *lpszTitle   = "SPLITIT\251 v3.0 Copyright Bill Buckels 1992-1999";

char *lpszBTitle = "B - Behead a BIN file (Split)",
     *lpszTTitle = "T - Trim a BIN file (Split)",
     *lpszCTitle = "C - Chunk a BIN file (Split)",
     *lpszATitle = "A - Chunk a TEXT file (Split)",
     *lpszJTitle = "J - Join a file (Join)",
     *lpszLTitle = "L - List current directory",
     *lpszKTitle = "K - Kill a file (Erase)",
     *lpszSplitFrom = "Select/Enter file to Split From...",
     *lpszSplitTo   = "Enter Floppy Drive Letter to Split To...",
     *lpszJoinFrom  = "Enter Floppy Drive Letter to Join From...",
     *lpszJoinTo    = "Select/Enter file to Join To...",
     *lpszCopyFrom = "Copy a File From...",
     *lpszCopyTo   = "Copy a File To...",
     *lpszMoveFrom = "Move a File From...",
     *lpszMoveTo   = "Move a File To...";

char *lpszSplitTitle   = "Now Splitting %s";
char *lpszTrimTitle    = "Now Trinmming %s";
char *lpszBeheadTitle  = "Now Beheading %s";
char *lpszJoinTitle    = "Now Joining %s";

char *lpMemoryError =  "Memory Allocation Error.\nUnable to proceed.";
char *lpSaveError   =  "Unable to save file %s.";
char *lpOpenError   =  "Unable to open file %s.";
char *lpEraseError  =  "Unable to erase file %s.";

char *lpChecksumPrompt    = "File is %ld bytes long...";
char *lpInvalidExtension  = "Numeric file extension %s not allowed.";
char *lpInvalidDriveLetter = "Drive Letter %s is Invalid... Enter A or B";

char *lpSaveSuccess =  "Congratulations!\n\n"
                       "As far as we know, File %s was Successfully saved.";
char *lpSplitSuccess = "Congratulations!\n\n"
                       "As far as we know, File %s was Successfully split.";
char *lpEraseSuccess = "Congratulations!\n\n"
                       "As far as we know, File %s was Successfully erased.";

char *lpFileExists  =  "File %s Already Exists.\nOverWrite?";

// lazy global state flags...
static BOOL HELPACTIVE=FALSE;
static BOOL BATCHMODE=FALSE;
static BOOL STARTED=FALSE;

HWND hwndParent;

HINSTANCE hInst;
HACCEL hAccTable;                        // handle to accelerator table

// directory list globals
char szCustFilterSpec[MAXCUSTFILTER];     // custom filter buffer
OPENFILENAME ofn;                         // struct. passed to GetOpenFileName

static char PathName[MAX_PATH] = "\0";         // ofn global
static char FileName[MAX_PATH] = "\0";         // ofn global
static char FloppyDriveLetter = ASCIIZ;        // global for floppy drive

// Command Line Args for Batchmode
WPARAM Arg1 = IDM_QUIT;
static char Arg2[MAX_PATH] = "\0";
unsigned long Arg3;

// filter string for dir. listings
char *szFilterSpec;

// filter string variables for different types of filename dialogs

static char szAnySpec[MAX_PATH]
          = "Any Old Files(*.*)\0*.*\0"
            "Exe Files (*.EXE)\0*.EXE\0"
            "Text Files (*.TXT)\0*.TXT\0";

static char szImportSpec[MAX_PATH]
          = "Any Old Files(*.*)\0*.*\0"
            "Exe Files (*.EXE)\0*.EXE\0"
            "Text Files (*.TXT)\0*.TXT\0";

static char szExportSpec[MAX_PATH]
          = "Any Old Files(*.*)\0*.*\0"
            "Exe Files (*.EXE)\0*.EXE\0"
            "Text Files (*.TXT)\0*.TXT\0";

char szWorkBuf[BUFFERSIZE];
char szMessageBuf[BUFFERSIZE];
char szDialogBuf[BUFFERSIZE];       // user's input buffer
char szDialogTitleBuf[TITLESIZE];

// declarations required by MyCopy
HFILE hfSource, hfTarget;                        // file handles

OFSTRUCT ofSource, ofTarget;                     // OF Structures
// note: the OFSTRUCT is NOT the same as the OFN structure...
// don't get the two confused. review windows.h for add'l info.

static BYTE szSourcePath[MAX_PATH]="\0";        // work buffers
static BYTE szTargetPath[MAX_PATH]="\0";

LONG lTargetSize, lSourceSize;                   // values for length check

// some window values for centering etc.
// these are used to avoid miscalculating the top left offset of the
// window by adjusting for caption height and window borders.

int xborder=0,yborder=0;


// ------------------------------------------------------------------------
// Windows Entry Point (main module)
// ------------------------------------------------------------------------
int APIENTRY WinMain (HINSTANCE hInstance, HINSTANCE hPrevInstance,
                    LPSTR lpszCmdParam, int nCmdShow)
    {
    HWND        hwnd ;
    MSG         msg ;
    WNDCLASSEX  wndclass ;
    int x1=0,y1=0,yfactor;
    int WindowWidth, WindowHeight;

    ParseCommandLine(lpszCmdParam);

    hInst = hInstance; // save instance handle
    if (!hPrevInstance)
          {
          wndclass.cbSize        = sizeof(WNDCLASSEX);
          wndclass.style         = CS_HREDRAW | CS_VREDRAW ;
          wndclass.lpfnWndProc   = (WNDPROC)WndProc ;
          wndclass.cbClsExtra    = 0 ;
          wndclass.cbWndExtra    = 0 ;
          wndclass.hInstance     = hInstance ;
          wndclass.hIcon         = LoadIcon(hInstance, "SplititIcon");
          wndclass.hCursor       = LoadCursor (NULL, IDC_ARROW);
          wndclass.hbrBackground = (HBRUSH)(COLOR_WINDOW+1);
          wndclass.lpszMenuName  = lpszAppName;
          wndclass.lpszClassName = lpszAppName;
          wndclass.hIconSm       = LoadImage(hInstance,
                                   "SplititIcon",
                                   IMAGE_ICON,
                                   16, 16,
                                   0);

          if (!RegisterClassEx(&wndclass))
          {
              // if RegisterClassEx() is not implemented
              // try calling RegisterClass().
              RegisterClass((LPWNDCLASS)&wndclass.style);
          }

	  }

    // put the window onto centre-stage
    WindowWidth=GetSystemMetrics(SM_CXSCREEN);
    WindowHeight=GetSystemMetrics(SM_CYSCREEN);

    xborder=GetSystemMetrics(SM_CXBORDER)*2;
    x1=(WindowWidth-BMP_WIDTH)/2 -xborder;
    WindowWidth=BMP_WIDTH+xborder+xborder;
    xborder/=2;

    yborder = GetSystemMetrics(SM_CYBORDER)*2;
    yfactor = GetSystemMetrics(SM_CYCAPTION);
    y1 = ((WindowHeight-BMP_HEIGHT)/2)-yborder-yfactor;
    WindowHeight= BMP_HEIGHT+yborder+yfactor+yfactor;
    yborder/=2;

    hwndParent = hwnd = CreateWindow (lpszAppName,lpszTitle,
                        WS_OVERLAPPEDWINDOW, // Window style
                        x1, y1,    // Use centered positioning
                        WindowWidth, WindowHeight,    // Use bitmap size
                        NULL,                // Overlapped has no parent
                        NULL,                // Use the window class menu
                        hInstance,           // This instance owns this window
                        NULL                 // Don't need data in WM_CREATE
    );

    if (BATCHMODE == TRUE)
      ShowWindow(hwnd, SW_SHOWMINIMIZED);
    else
      ShowWindow (hwnd, nCmdShow) ;

    UpdateWindow (hwnd) ;
    LoadCursor (NULL, IDC_ARROW);

    hAccTable = LoadAccelerators(hInstance, lpszAppName);
    while (GetMessage (&msg, NULL, 0, 0))
     {
        if (!TranslateAccelerator(msg.hwnd, hAccTable, &msg))
        {
          TranslateMessage (&msg) ;
          DispatchMessage (&msg) ;
        }
     }

    hwndParent = NULL;

    return msg.wParam ;
}


// ------------------------------------------------------------------------
// As the function name suggests, parse the commandline and test
// for running in non-interactive mode.
// we are expecting 2 args for join and 3 for the rest
// ------------------------------------------------------------------------

LRESULT ParseCommandLine(LPSTR lpszCmdParam)
{
  char c, K;
  int idx, pos;

  Arg1    = IDM_QUIT;
  Arg2[0] = ASCIIZ;
  Arg3    = 0L;

  BATCHMODE = FALSE;

  if (lpszCmdParam != NULL && lpszCmdParam[1] == ' ' &&
      strlen(lpszCmdParam) > 3) {
    c = toupper(lpszCmdParam[0]);
    switch(c) {
      case 'B':
       Arg1 = IDM_BEHEAD;
       break;
      case 'T':
       Arg1 = IDM_TRIM;
       break;
      case 'C':
       Arg1 = IDM_CHUNK;
       break;
      case 'A':
       Arg1 = IDM_TEXT;
       break;
      case 'J':
       Arg1 = IDM_JOIN;
       BATCHMODE = TRUE;
       break;
    }

    // if we have a valid action argument
    if (Arg1 != IDM_QUIT) {
      strcpy(Arg2, &lpszCmdParam[2]);    // get filename string

      if (Arg1 != IDM_JOIN) {            // splitting requires a 3rd arg
        pos = strlen(Arg2)-1;
        K = toupper(Arg2[pos]);
        pos = 0;
        for (idx = 0; Arg2[idx] != ASCIIZ; idx++) {
          if (Arg2[idx] == ' ') {
            pos = 0;
            c = Arg2[idx+1];
            if (c > '0' && c <= '9') {   // cursory check for numeric arg
              pos = idx;
            }
          }
        }
        // there may be spaces in the filename...
        // we made sure we have the last space before assuming
        // that we can break the string into 2 args.
        if (pos != 0) {
          Arg2[pos] = ASCIIZ;        // trim filename string
          Arg3 = atol(&Arg2[pos+1]); // get chunk size
          if (K == 'K') Arg3 = Arg3 * 1024;
          BATCHMODE = TRUE;          // run in batchmode
        }
      }
    }
  }

  return (Arg1);
}


// ------------------------------------------------------------------------
// Main Message Loop
// ------------------------------------------------------------------------
LRESULT CALLBACK WndProc (HWND hwnd, UINT message,
                          WPARAM wParam, LPARAM lParam)
{
    HDC hMemoryDC, hdc;
    HBITMAP hBitmap, hOldBitmap;
    BITMAP bitmap;
    PAINTSTRUCT ps;
    WORD wCommand;

    switch (message)
	  {
        case WM_CREATE:
          // if running in batchmode, just do it!
          if (BATCHMODE == TRUE)
            PostMessage(hwnd, WM_COMMAND, Arg1, 0L);
          break;

        case WM_COMMAND:

          wCommand = LOWORD(wParam);
          // command message handler switch

          switch(wCommand)
          {
            /*

                   B - Behead a file      (Split)
                   T - Trim   a file      (Split)
                   C - Chunk  a BIN file  (Split)
                   A - Chunk  a TEXT file (Split)
                   J - Join   a file      (Join)
                   L - List current directory
                   K - Kill   a file      (Erase)

            */

            case IDM_BEHEAD:
            case IDM_TRIM:
            case IDM_CHUNK:
            case IDM_TEXT:
            case IDM_SPLIT:
            case IDM_JOIN:
            case IDM_FLOPPY:
            case IDM_LIST:
            case IDM_COPY:
            case IDM_MOVE:
            case IDM_DELETE:

              // clear the splash screen...
              // let's get to work.
              // commented out for now... leave splash screen in place
              // if (STARTED == FALSE && BATCHMODE == FALSE) {
              //   ClearScreen(hwnd,NULL,RGB(255,255,255));
              //   STARTED = TRUE;
              // }

              MyLoad(hwnd, wCommand);

              if (BATCHMODE == FALSE)
                return 0L;
              // if batchmode, let this fall through to QUIT.
            case IDM_QUIT:
              DestroyWindow(hwnd);
              return 0L;
            case IDM_ABOUT:
              return MyAbout(hwnd);
            case IDM_HELP:
              return MyHelp(hwnd);
           }
           break;

      case WM_PAINT:
        hdc=BeginPaint(hwnd,&ps);

        // if we have already started, we have wiped the screen clean.
        // if they go poking around in help or about we redisplay it
        // simply for the sake of promotion, but no point in being
        // obnoxious...

        if (BATCHMODE == FALSE && STARTED == FALSE) {

          if((hBitmap=LoadBitmap(hInst,"Splitit"))!=NULL)
          {
            if((hMemoryDC=CreateCompatibleDC(hdc))!=NULL)
            {
              hOldBitmap=SelectObject(hMemoryDC,hBitmap);
              if(hOldBitmap)
              {
                GetObject(hBitmap,sizeof(BITMAP),(LPSTR)&bitmap);
                BitBlt(hdc,xborder,yborder,
                           BMP_WIDTH,BMP_HEIGHT,
                           hMemoryDC,
                           0,0,
                           SRCCOPY);
                SelectObject(hMemoryDC,hOldBitmap);
              }
              DeleteDC(hMemoryDC);
            }
            DeleteObject(hBitmap);
          }

        }
        EndPaint(hwnd,&ps);
        return 0L;

      case WM_DESTROY:   

           if(HELPACTIVE!=FALSE)WinHelp(hwnd,"SPLITIT.HLP",HELP_QUIT,0L);
           HELPACTIVE = FALSE;
           PostQuitMessage(0);
           return 0L;
    }

    return DefWindowProc (hwnd, message, wParam, lParam) ;
}


// ------------------------------------------------------------------------
// Initialize variant info for the ofn dialog
// ------------------------------------------------------------------------
LRESULT InitDialog(HWND hWnd, WORD wDirType, LPSTR lpTitle)
{
    // fill in fields of OPENFILENAME struct.
    // depending on what kind of file we are processing

    switch(wDirType)
    {
        case DIR_IMPORT:
          PathName[0] = FileName[0] = ASCIIZ; /* wipeout previous contents */
          szFilterSpec=(char far *)&szImportSpec[0];
          break;
        case DIR_EXPORT:
          PathName[0] = FileName[0] = ASCIIZ; /* wipeout previous contents */
          szFilterSpec=(char far *)&szExportSpec[0];
          break;
        case DIR_ANY:
        default:
          PathName[0] = FileName[0] = ASCIIZ; /* wipeout previous contents */
          szFilterSpec=(char far *)&szAnySpec[0];
          break;
    }

    ofn.lStructSize       = sizeof(OPENFILENAME);
    ofn.hwndOwner         = hWnd;
    ofn.lpstrFilter       = szFilterSpec;
    ofn.lpstrCustomFilter = szCustFilterSpec;
    ofn.nMaxCustFilter	  = MAXCUSTFILTER;
    ofn.nFilterIndex      = 1;
    ofn.lpstrFile         = FileName;
    ofn.nMaxFile          = MAXFILENAME;
    ofn.lpstrInitialDir   = PathName;
    ofn.Flags             = OFN_HIDEREADONLY;
    ofn.lpfnHook          = NULL;

    if (NULL == lpTitle)
      ofn.lpstrTitle        = (LPSTR)"Select/Enter Filename";
    else
      ofn.lpstrTitle        = lpTitle;

    return 0;
}


// ------------------------------------------------------------------------
// Display ofn dialog, select file, display file...
// ------------------------------------------------------------------------
LRESULT MyLoad(HWND hWnd, WPARAM wParam)
{
    LONG lRetVal;
    WORD wDirType = DIR_ANY;
    LPSTR lpTitle = NULL, lpTitleToo;
    int iLen, pos;
    unsigned long checksum, target;
    FILE *fp;
    char K = ASCIIZ;

    FloppyDriveLetter = szDialogBuf[0] = ASCIIZ;

    // assign title
    switch(wParam)
    {
      case IDM_BEHEAD:
        lpTitle = lpszBTitle;break;
      case IDM_TRIM:
        lpTitle = lpszTTitle; break;
      case IDM_CHUNK:
        lpTitle = lpszCTitle; break;
      case IDM_TEXT:
        lpTitle = lpszATitle; break;
      case IDM_SPLIT:
        lpTitle = lpszSplitFrom;
        lpTitleToo = lpszSplitTo;
        break;
      case IDM_JOIN:
        lpTitle = lpszJTitle; break;
      case IDM_FLOPPY:
        lpTitle = lpszJoinTo;
        lpTitleToo = lpszJoinFrom;
        break;
      case IDM_LIST:
        lpTitle = lpszLTitle; break;
      case IDM_DELETE:
        lpTitle = lpszKTitle; break;
      case IDM_COPY:
        lpTitle = lpszCopyFrom;
        lpTitleToo = lpszCopyTo;
        break;
      case IDM_MOVE:
        lpTitle = lpszMoveFrom;
        lpTitleToo = lpszMoveTo;
        break;
    }

    // select file name...
    InitDialog(hWnd, wDirType, lpTitle);

    if (BATCHMODE == TRUE)
      strcpy(FileName, Arg2);

    if (BATCHMODE == TRUE || GetOpenFileName ((LPOPENFILENAME)&ofn)) {

      // can't allow 3 digit numeric file extensions since they
      // conflict with our output and input...

      if (wParam != IDM_COPY && wParam != IDM_MOVE && wParam != IDM_DELETE) {
        iLen = strlen(ofn.lpstrFile) - 4;

        if (iLen > 0 && ofn.lpstrFile[iLen] == '.') {
          if (ofn.lpstrFile[iLen + 1] >= '0' &&
            ofn.lpstrFile[iLen + 2] >= '0' &&
            ofn.lpstrFile[iLen + 3] >= '0' &&
            ofn.lpstrFile[iLen + 1] <= '9' &&
            ofn.lpstrFile[iLen + 2] <= '9' &&
            ofn.lpstrFile[iLen + 3] <= '9') {
            MyMessage(hWnd, lpInvalidExtension,
                            &ofn.lpstrFile[iLen], NULL, MB_FAILURE);

            wParam = 0;  // this aborts further processing
          }
        }
      }
      switch(wParam)
      {
        case IDM_COPY:
        case IDM_MOVE:
          strcpy(Arg2, ofn.lpstrFile);
          ofn.lpstrTitle = lpTitleToo;
          if (GetOpenFileName ((LPOPENFILENAME)&ofn))
            lRetVal = MyCopy(Arg2, ofn.lpstrFile, (wParam == IDM_MOVE));;
          CopyErrProc(hWnd, Arg2, ofn.lpstrFile, lRetVal);
          break;
        case IDM_SPLIT:
        case IDM_FLOPPY:

            // for this version we only map to a floppy
            // in either drives A or B...
            // this is probably sufficient.

            szDialogBuf[0] = 'A';
            szDialogBuf[1] = ':';
            szDialogBuf[2] = ASCIIZ;

            while (FloppyDriveLetter != 'A' && FloppyDriveLetter != 'B') {
              if (MultiEntry(hWnd, lpTitleToo, "TextEntryBox")) {
                FloppyDriveLetter = ASCIIZ;
                break;
              }
              FloppyDriveLetter = toupper(szDialogBuf[0]);
              if (FloppyDriveLetter != 'A' && FloppyDriveLetter != 'B') {
                MyMessage(hWnd, lpInvalidDriveLetter,
                                szDialogBuf, NULL, MB_FAILURE);
              }
            }
            if (FloppyDriveLetter == ASCIIZ)
              break;

            if (wParam == IDM_FLOPPY) {
                // if we are joining from floppy we are now OK
                JoinIt(hWnd, ofn.lpstrFile);break;
                break;

            }

            // if we are splitting to floppy, it falls through to normal
            // processing now...
            // some may argue that the floppy save should be smart enough
            // to know the floppy size and to not bother the user...
            // in the interests of getting on with life, and
            // getting this version out the door,
            // I have made the floppy save the same as the others...
            // although I provide some guidance regarding floppy sizes.

        case IDM_BEHEAD:
        case IDM_TRIM:
        case IDM_CHUNK:
        case IDM_TEXT:
          fp = fopen(ofn.lpstrFile, "rb");
          if (NULL == fp) {
            MyMessage(hWnd, lpOpenError, ofn.lpstrFile, NULL, MB_FAILURE);
            break;
          }
          checksum=(unsigned long) filelength(fileno(fp));
          fclose(fp);

          if (BATCHMODE == TRUE) {
            target = Arg3;
          }
          else {
            sprintf(szWorkBuf, lpChecksumPrompt, checksum);

            // If we are splitting to floppy, we provide the floppy size
            // if the file size exceeds the free space on the floppy.
            // But if no disk in drive we just guess.

            if (wParam == IDM_SPLIT) {
              lRetVal = FloppySize(FloppyDriveLetter);
              if (lRetVal < 1L)
                lRetVal = MAXFLOPPYSIZE;
            }
            else {
              lRetVal = checksum;
            }
            if (lRetVal > (long)checksum)
              lRetVal = checksum;

            switch((long)lRetVal)
            {
               case FLOPPY1440K:
                 strcpy(szDialogBuf, "1.44M");break;
               case FLOPPY720K:
                 strcpy(szDialogBuf, "720K");break;
               case FLOPPY1200K:
                 strcpy(szDialogBuf, "1.2M");break;
               case FLOPPY360K:
                 strcpy(szDialogBuf, "1.44M");break;
               default:
                 sprintf(szDialogBuf, "%ld", lRetVal);
            }

            if (MultiEntry(hWnd, szWorkBuf, "NumEntryBox"))
              break;

            target = 0L;

            // drives are oddballs...
            // not really 720K or 1.44M etc. at all...
            // I hate long else if's so I didn't use one below.

            if (_strcmpi(szDialogBuf, "1.44M") == SUCCESS ||
                _strcmpi(szDialogBuf, "1.44") == SUCCESS  ||
                _strcmpi(szDialogBuf, "1440K") == SUCCESS)
              target = FLOPPY1440K;

            if (target == 0L && _strcmpi(szDialogBuf, "720K") == SUCCESS)
              target = FLOPPY720K;

            if (target == 0L &&
               (_strcmpi(szDialogBuf, "1.2M") == SUCCESS ||
                _strcmpi(szDialogBuf, "1.2") == SUCCESS  ||
                _strcmpi(szDialogBuf, "1200K") == SUCCESS))
              target = FLOPPY1200K;

            if (target == 0L && _strcmpi(szDialogBuf, "360K") == SUCCESS)
              target = FLOPPY360K;

            if (target == 0L) {
              target=(unsigned long)atol(szDialogBuf);
              pos = strlen(szDialogBuf)-1;
              if (pos)
                K = toupper(szDialogBuf[pos]);     // express file size in K
              if (K == 'K') target = target * 1024;
            }
          }
          if (target > checksum)
            target = checksum;

          if(target<1 || (wParam == IDM_SPLIT && target > MAXFLOPPYSIZE))
          {
            MyMessage(hWnd, NULL,
                            "Sorry... invalid number of bytes in split.",
                            NULL, MB_FAILURE);
            break;
          }
          if (wParam == IDM_TEXT)
            TextSplit(hWnd, ofn.lpstrFile,checksum,target);
          else
            SplitIt(hWnd, ofn.lpstrFile,checksum,target,wParam);
          break;
        case IDM_JOIN:
          JoinIt(hWnd, ofn.lpstrFile);break;
        case IDM_LIST:
          break;
        case IDM_DELETE:
          remove(ofn.lpstrFile);
          // check to see if we were successful...
          if (FileExists(ofn.lpstrFile, NULL))
            MyMessage(hWnd, lpEraseError, ofn.lpstrFile,
                            NULL, MB_FAILURE);
          else
            MyMessage(hWnd, lpEraseSuccess,ofn.lpstrFile,
                            NULL, MB_SUCCESS);
          break;
      }
    }
    szDialogBuf[0] = FloppyDriveLetter = ASCIIZ;
    return 0L;
}


// ------------------------------------------------------------------------
// Generic Text Entry Dialog - A Simple InputBox that uses 2 global buffers
// the global buffer is called szDialogBuf...
// ------------------------------------------------------------------------
LRESULT MultiEntry(HWND hWnd, LPSTR lpszDialogTitleBuf, LPSTR lpszVarDlg)
{
     LONG lRetVal = (LONG)FAILURE;

     if (NULL != lpszDialogTitleBuf)
       strcpy(szDialogTitleBuf, lpszDialogTitleBuf);
     else
       szDialogTitleBuf[0] = ASCIIZ;

     if (TRUE == DialogBox(hInst, lpszVarDlg, hWnd, (DLGPROC)EntryDlgProc) &&
         szDialogBuf[0]!=ASCIIZ) {
       lRetVal = (LONG)SUCCESS;
     }
     InvalidateRect(hWnd, NULL, TRUE);   // repaint everything
     UpdateWindow(hWnd);                 // force WM_PAINT message
     return lRetVal;

}


// ------------------------------------------------------------------------
// EntryDlgProc - callback function for "Text Entry..." dialog
// ------------------------------------------------------------------------
LRESULT CALLBACK EntryDlgProc(HWND hDlg, UINT uMsg, WPARAM wParam, LPARAM lParam)
{
   WORD wCommand;

    switch (uMsg)
    {
        case WM_INITDIALOG:                 // dialog box initialization

            if (szDialogTitleBuf[0] != ASCIIZ)
              SetWindowText(hDlg, szDialogTitleBuf);
            if (szDialogBuf[0] != ASCIIZ)  {
              SetDlgItemText(hDlg, IDD_EDITTEXT, szDialogBuf);
              szDialogBuf[0] = ASCIIZ;
            }
            return (TRUE);                  // signal message processed

        case WM_COMMAND:                    // command received
            wCommand = LOWORD(wParam);

            if(wCommand == IDD_OK)            // OK button clicked?
            {                                 // yes, retrieve text
              szDialogBuf[0]=0x00;
              GetDlgItemText(hDlg, IDD_EDITTEXT, szDialogBuf, INPUTSIZE-1);
              EndDialog(hDlg, TRUE);        // signal text accepted
            }
            else if(wCommand == IDD_CANCEL)   // Cancel button clicked?
            {
                                            // Input was cancelled
              EndDialog(hDlg, FALSE);       // signal text not accepted
            }
    }
    return(FALSE);                          // signal message not processed
}


LRESULT SplitIt(HWND hWnd,
            char *lpszInfileName,
            unsigned long checksum,
            unsigned long target,
            WPARAM wParam)
{
    int fh,fh2;
    char infile[BUFFERSIZE];
    char buf[MAX_PATH];
    char shortname[MAX_PATH];
    char far *inbuff;
    unsigned long ctr=0l, count=0l, numdisks=0l;
    unsigned fctr = 1;
    unsigned i, packet, remainder;
    unsigned tester;
    BOOL bWriteError = FALSE;
    int DONE=0;
    int iContinue = IDYES;

    /* if the file is being trimmed we use the difference between */
    /* the totalsize and the target to make the adjusted target.  */

    if(wParam==IDM_TRIM)target=(checksum-target);

    strcpy(infile,lpszInfileName);
    BaseName(infile, shortname);
    if (FloppyDriveLetter == ASCIIZ) {
      sprintf(buf,"%s.%0003d",infile,fctr);
    }
    else  {
      numdisks = (unsigned)(checksum/target);
      if (checksum%target)
        numdisks = (numdisks + 1L);
      sprintf(buf,"%c:\\%s.%0003d",FloppyDriveLetter,shortname,fctr);
      sprintf(infile,
              "You will need %ld floppy disks if you are splitting "
              "one chunk per disk.\n\nWhen you are ready, "
              "put a formatted floppy (disk 1 of %ld) for %s "
              "into drive %c: and click YES if you wish to proceed.\n\n"
              "Click NO if you don't.",
               numdisks, numdisks, buf, FloppyDriveLetter);
    }

    if((fh=open(lpszInfileName,O_RDONLY|O_BINARY))==-1)
    {
      MyMessage(hWnd, lpOpenError, lpszInfileName, NULL, MB_FAILURE);
      return FAILURE;
    }

    if (FloppyDriveLetter != ASCIIZ)
      iContinue = MyMessage(hWnd, NULL, infile, NULL, MB_QUESTION);

    if(iContinue != IDYES || (fh2=open(buf,O_CREAT|O_TRUNC|O_WRONLY|O_BINARY,S_IWRITE))==-1)
    {
      close(fh);
      MyMessage(hWnd, lpSaveError, buf, NULL, MB_FAILURE);
      return FAILURE;
    }
    inbuff=malloc(16384);
    if (NULL == inbuff) {
      close(fh);
      close(fh2);
      MyMessage(hWnd, NULL, lpMemoryError, NULL, MB_FAILURE);
      return FAILURE;
    }

    SetCursor(LoadCursor(NULL,IDC_WAIT));

    switch(wParam)
    {
      case IDM_TRIM   : sprintf(szWorkBuf, lpszTrimTitle, lpszInfileName);
                        break;
      case IDM_BEHEAD : sprintf(szWorkBuf, lpszBeheadTitle, lpszInfileName);
                        break;
      case IDM_CHUNK  :
      case IDM_SPLIT  :
      default:          sprintf(szWorkBuf, lpszSplitTitle, lpszInfileName);
                        break;

    }
    SetWindowText(hWnd,szWorkBuf);

    packet= (unsigned)(target/16384);
    remainder = (unsigned)(target%16384);

    DONE=0;

    while(!DONE)
    {

      /* write the packets */
      for(i=0;i<packet;i++)
      {
        if((tester=read(fh,inbuff,16384))!=16384)
        {
            DONE=packet;
            i=packet;
        }

        if(tester<= 16384 && tester >0)
        {
            // handle write errors
            // never done in previous version (dos version 2.0)
            if (((int)tester) > write(fh2,inbuff,tester)) {
              close(fh2);
              fh2 = FAILURE;
              remove(buf);
            }
            else {
              ctr+=tester;
              count+= tester;
            }
        }
      }

      /* write the remainder */
      if(!DONE && remainder!=0 && fh2 != FAILURE)
      {

        if((tester=read(fh,inbuff,remainder))!=remainder)DONE=remainder;

        if(tester<= remainder && tester >0)
        {
            if (((int)tester) > write(fh2,inbuff,tester)) {
              close(fh2);
              fh2 = FAILURE;
              remove(buf);
            }
            else {
              ctr+=tester;
              count+=tester;
            }
        }
      }

      if(ctr==target && fh2!= FAILURE)
      {

        switch(wParam)
        {
          case IDM_SPLIT  :
          case IDM_CHUNK  : ctr=0;

          case IDM_TRIM   :
          case IDM_BEHEAD :
                    if (count >= checksum) {
                      DONE++;
                      ctr++;
                      break;
                    }

                    close(fh2);
                    fctr++;
                    if (FloppyDriveLetter == ASCIIZ) {
                      sprintf(buf,"%s.%0003d",infile,fctr);
                    }
                    else  {
                      fh2 = FAILURE;
                      sprintf(buf,"%c:\\%s.%0003d",
                              FloppyDriveLetter,shortname,fctr);
                      sprintf(infile, "Congratulations!\n\n"
                              "Disk %d is finished. "
                              "Remove it from drive %c after the drive "
                              "light goes off "
                              "(unless you are splitting multiple "
                              "chunks to the same floppy).\n\n"
                              "Then put the next formatted floppy "
                              "(disk %d of %ld) for %s "
                              "into drive %c: and click YES to proceed.\n\n"
                              "Click NO if you want to stop.",
                              fctr-1, FloppyDriveLetter,
                              fctr, numdisks,
                              buf, FloppyDriveLetter);
                      SetCursor(LoadCursor(NULL,IDC_ARROW));
                      iContinue = MyMessage(hWnd, NULL, infile, NULL,
                                            MB_QUESTION);
                      SetCursor(LoadCursor(NULL,IDC_WAIT));

                    }
                    if (iContinue == IDYES)
                      fh2=open(buf,
                               O_CREAT|O_TRUNC|O_WRONLY|O_BINARY,S_IWRITE);

        }
      }
      if (FAILURE == fh2) {
        DONE = FAILURE;
        break;
      }
    }

    close(fh);
    free(inbuff);

    SetWindowText(hWnd,lpszTitle);

    SetCursor(LoadCursor(NULL,IDC_ARROW));

    if (FAILURE == fh2) {
       MyMessage(hWnd, lpSaveError, buf, NULL, MB_FAILURE);
    }
    else {
      close(fh2);
      fh2 = SUCCESS;
      if(ctr==0L)remove(buf);
      if (BATCHMODE == FALSE) {

        // if we are splitting to floppy, our message is different...
        // need to remind them to remove the disk from the drive.

        if (FloppyDriveLetter == ASCIIZ) {
          MyMessage(hWnd, lpSplitSuccess, lpszInfileName, NULL, MB_SUCCESS);
        }
        else {
          sprintf(infile, "Congratulations!\n\nAs far as we know "
                          "%s was Split Successfully\n\n"
                          "Disk %d of %ld is finished. After the drive "
                          "light goes out, "
                          "remove it from drive %c and you are done.\n\n"
                          "To avoid all sorts of confusion, "
                          "remember to label your disks.",
                           lpszInfileName,
                           fctr, numdisks,
                           FloppyDriveLetter);
          MyMessage(hWnd, NULL, infile, NULL, MB_SUCCESS);
        }
      }
    }

    return fh2;

}


LRESULT TextSplit(HWND hWnd,
              char *lpszInfileName,
              unsigned long checksum, unsigned long target)
{



    FILE *fp2, *fp;
    char temp[MAX_PATH];
    char buf[MAX_PATH];
    unsigned long ctr=0l,count=0l;
    unsigned fctr = 1;
    char filebuf[BIGBUFFERSIZE];

    fp = fopen(lpszInfileName, "r");
    if (NULL == fp) {
      MyMessage(hWnd, lpOpenError, lpszInfileName, NULL, MB_FAILURE);
      return FAILURE;
    }

    strcpy(temp,lpszInfileName);
    BaseName(temp, NULL);
    sprintf(buf,"%s.%0003d",temp,fctr);

    fp2=fopen(buf,"w");
    if (NULL == fp2) {
      fclose(fp);
      MyMessage(hWnd, lpSaveError, buf, NULL, MB_FAILURE);
      return FAILURE;
    }

    SetCursor(LoadCursor(NULL,IDC_WAIT));

    sprintf(szWorkBuf, lpszSplitTitle, lpszInfileName);
    SetWindowText(hWnd,szWorkBuf);

    while(fgets(filebuf,1024,fp)!=NULL)
    {

      ctr+=(strlen(filebuf)+1);
      count++;
      fputs(filebuf,fp2);

      if(ctr>=target)
      {
        ctr=0l;
        fclose(fp2);
        fctr++;
        sprintf(buf,"%s.%0003d",temp,fctr);
        fp2=fopen(buf,"w");
        if(NULL == fp2) {
          fctr = FAILURE;
          break;
        }
      }
    }

    fclose(fp);

    SetWindowText(hWnd,lpszTitle);

    SetCursor(LoadCursor(NULL,IDC_ARROW));

    if (fctr == FAILURE) {
      MyMessage(hWnd, lpSaveError, buf, NULL, MB_FAILURE);
    }
    else {
      fclose(fp2);
      if(ctr==0l)remove(buf);
      if (BATCHMODE == FALSE) {
        MyMessage(hWnd, lpSplitSuccess, lpszInfileName, NULL, MB_SUCCESS);
      }
    }

    return fctr;

}


LRESULT JoinIt(HWND hWnd, char *lpszInfileName)
{
    int fh,fh2, iContinue = IDYES;
    char *inbuff;
    char shortname[MAX_PATH];
    char temp[BUFFERSIZE];
    char buf[MAX_PATH];
    unsigned numbytes;
    unsigned long count=0l;
    unsigned fctr = 1;
    unsigned ctr, retries;


    // don't overwrite existing files without asking
    if (TRUE == FileExists(lpszInfileName, NULL)) {
      if (IDYES !=
          MyMessage(hWnd, lpFileExists, lpszInfileName, NULL, MB_QUESTION))
        return FAILURE;
    }

    if((fh=open(lpszInfileName,O_CREAT|O_TRUNC|O_WRONLY|O_BINARY,S_IWRITE))==-1)
    {
      MyMessage(hWnd, lpSaveError, lpszInfileName, NULL, MB_FAILURE);
      return FAILURE;
    }

    inbuff=malloc(16384);
    if (NULL == inbuff) {
      MyMessage(hWnd, NULL, lpMemoryError, NULL, MB_FAILURE);
      close(fh);
      return FAILURE;
    }

    sprintf(szWorkBuf, lpszJoinTitle, lpszInfileName);
    SetWindowText(hWnd,szWorkBuf);

    strcpy(temp,lpszInfileName);
    BaseName(temp, shortname);

    if (FloppyDriveLetter == ASCIIZ) {
      sprintf(buf,"%s.%0003d",temp,fctr);
    }
    else  {
      sprintf(buf,"%c:\\%s.%0003d",FloppyDriveLetter,shortname,fctr);
      sprintf(temp, "Put the floppy containing %s into drive %c: and click YES "
                    "if you wish to proceed.\n\n"
                    "Click NO if you wish to stop.",
              buf, FloppyDriveLetter);
    }

    if (FloppyDriveLetter != ASCIIZ)
      iContinue = MyMessage(hWnd, NULL, temp, NULL, MB_QUESTION);

    SetCursor(LoadCursor(NULL,IDC_WAIT));

    /* read files until there aren't any more */
    retries = 2;
    while(iContinue == IDYES)
    {
      for (ctr = 0; ctr < retries; ctr++) {
        fh2=open(buf,O_RDONLY|O_BINARY);
        if (fh2 != -1)
          break;
      }
      if (fh2 == -1)
        break;

      for(;;)
      {
        for (ctr = 0; ctr < retries; ctr++) {
          numbytes=read(fh2,inbuff,16384);
          if (numbytes > 0)
            break;
        }
        if (numbytes < 1)
          break;
        for (ctr = 0; ctr < retries; ctr++) {
          if (write(fh,inbuff,numbytes) > 0)
            break;
        }
        count+=numbytes;
      }
      close(fh2);
      fctr++;
      if (FloppyDriveLetter == ASCIIZ) {
        sprintf(buf,"%s.%0003d",temp,fctr);
      }
      else  {
        sprintf(buf,"%c:\\%s.%0003d",
                FloppyDriveLetter,shortname,fctr);
        sprintf(temp,
               "Disk %d is complete. "
               "After the drive light goes out, "
               "You can remove it from the drive.\n\n"
               "If you still have floppies to join, "
               "Put the floppy containing %s "
               "into drive %c: and click YES.\n\n"
               "Click NO "
               "if you are finished.",
               fctr-1, buf, FloppyDriveLetter);
        SetCursor(LoadCursor(NULL,IDC_ARROW));
        iContinue = MyMessage(hWnd, NULL, temp, NULL, MB_QUESTION);
        SetCursor(LoadCursor(NULL,IDC_WAIT));
      }
    }
    close(fh);
    if(count==0l)remove(lpszInfileName);
    free(inbuff);

    SetWindowText(hWnd,lpszTitle);

    SetCursor(LoadCursor(NULL,IDC_ARROW));

    if (count == 0l)
      MyMessage(hWnd, lpSaveError, lpszInfileName, NULL, MB_FAILURE);
    else {
      if (BATCHMODE == FALSE) {
        if (FloppyDriveLetter == ASCIIZ) {
          MyMessage(hWnd, lpSaveSuccess, lpszInfileName, NULL, MB_SUCCESS);
        }
        else {
          sprintf(temp,
                  "Congratulations!\n\nAs far as we know "
                  "%s was Saved (Joined) Successfully.\n\n"
                  "If a disk is still in drive %c, "
                  "after the drive light goes out, remove it from the drive, "
                  "put it safely away, and you are done.",
                  lpszInfileName,
                  FloppyDriveLetter);
          MyMessage(hWnd, NULL, temp, NULL, MB_SUCCESS);
        }
      }
    }

    return SUCCESS;
}


// ------------------------------------------------------------------------
// Function MyCopy
//
// Purpose
//       - Copy Source File to Target File using LZCopy
//
// Parameters
//     1 - COPY FROM lpszSource - asciiz terminated string source file name
//     2 - COPY TO   lpszTarget - asciiz terminated string target file name
//     3 - REMOVE SOURCE AFTER COPY
//                   bRemove - If bRemove is TRUE, remove Source after copy
//                           - If bRemove is FALSE, don't remove Source
// Returns
//
// Type   - Long Integer
// Values - E_SUCCESS       0L  - copy completed successfully
//          E_NOSOURCENAME  1L  - source not specified
//          E_NOTARGETNAME  2L  - target not specified
//          E_WILDSOURCE    3L  - wild cards are not allowed in source
//          E_WILDTARGET    4L  - wild cards are not allowed in target
//          E_SAMENAME      5L  - source and target are the same
//          E_NOSOURCE      6L  - source was not found
//          E_SOURCEOPEN    7L  - unable to open source
//          E_TARGETOPEN    8L  - unable to create target
//          E_NOMEMORY      9L  - could not alloc -or- lock memory
//          E_READERROR    10L  - error reading source
//          E_DISKSPACE    11L  - no disk space for target
//          E_SOURCEREMOVE 12L  - file move error, cannot remove source
//          E_UNKNOWN      13L  - error unknown
//
// ------------------------------------------------------------------------
LRESULT MyCopy(LPSTR lpszSource, LPSTR lpszTarget, BOOL bRemove)
{
      FILE *fp;
      int i;

      // provide a reasonable level of integrity by checking for
      // common errors and take no action if we find an error.

      // don't accept null strings (empty names)
      if(lpszSource[0]==ASCIIZ)return E_NOSOURCENAME;
      if(lpszTarget[0]==ASCIIZ)return E_NOTARGETNAME;

      // don't accept wild cards
      //   let the calling application worry about building a list
      // expanding pathnames and testing for logical errors requires
      //   an additional set of parsing routines and validation routines
      //   that are beyond the current scope of this function.

      for(i=0;lpszSource[i]!=ASCIIZ;i++)
        if(lpszSource[i]=='*'||lpszSource[i]=='?')return E_WILDSOURCE;

      for(i=0;lpszTarget[i]!=ASCIIZ;i++)
        if(lpszTarget[i]=='*'||lpszTarget[i]=='?')return E_WILDTARGET;

      // use fullpath to copy and expand the file names into the
      // work buffers...
      _fullpath(szSourcePath,lpszSource,MAX_PATH);
      _fullpath(szTargetPath,lpszTarget,MAX_PATH);

      // don't accept duplicate paths
      // use case insensitive compare to test source and target
      if(_strcmpi(szSourcePath,szTargetPath)==0)return E_SAMENAME;

      // read the file...
      // does source file exist... if nothing to do, don't do anything...
      if(NULL == (fp = fopen(szSourcePath,"rb")))
         return E_NOSOURCE;

      // get source file size
      lSourceSize = (LONG) filelength(fileno(fp));
      fclose(fp);

      // Use LZCopy To Copy The File
      // - open in share compatibility mode for network use
      // - deny writing to source when copying
      // - deny all access to target when copying
      // windows will still cak if we violate share compatibility
      //   but we will return to processing after the kernel intervenes
      //   and we report the error correctly, and this is all that matters.
      //   the alternative is to hook the kernel which is beyond our scope.

      hfSource=LZOpenFile(szSourcePath,&ofSource,OF_READ|OF_SHARE_DENY_WRITE);
      if(hfSource==-1)return E_SOURCEOPEN;

      hfTarget=LZOpenFile(szTargetPath,&ofTarget,OF_CREATE|OF_SHARE_EXCLUSIVE);
      if(hfTarget==-1)
      {
        LZClose(hfSource);
        return E_TARGETOPEN;
      }

      // get the filesize or the error returned from the copy operation
      lTargetSize = LZCopy(hfSource,hfTarget);

      // close the files
      LZClose(hfSource);
      LZClose(hfTarget);

      // check for copy errors
      //   if the target size is smaller than the source size
      //   an error has occurred. It should have either expanded or
      //   remained the same size.
      // let the calling application remove any partially copied files
      //   that is beyong our scope.

      if(lTargetSize < lSourceSize)
      {

         switch(lTargetSize)
         {
          // since we check our handles before copying
          // it is unlikely a bad handle error will be returned.
          case LZERROR_BADINHANDLE:
                                     return E_SOURCEOPEN;
          case LZERROR_BADOUTHANDLE:
                                     return E_TARGETOPEN;

          // it makes no difference if we can't allocate or lock
          // the global memory block. use the same error.
          case LZERROR_GLOBALLOC:
          case LZERROR_GLOBLOCK:
                                     return E_NOMEMORY;
          case LZERROR_READ:
          // unknow algorithm, just map to the read error
          case LZERROR_UNKNOWNALG:
                                     return E_READERROR;

          // this could also be generated by a drive that does not exist
          // but just call it a disk space error since this is the likeliest.
          case LZERROR_WRITE:
                                     return E_DISKSPACE;
          default:
                                     return E_UNKNOWN;
         }
      }


      // if this is a move and not a copy, remove the source file
      if(bRemove!=FALSE)
      {
         remove(szSourcePath);
         // if the remove failed report this
         if(TRUE == FileExists(szSourcePath,NULL))
         {
            return E_SOURCEREMOVE;
         }
      }


return E_SUCCESS;
}


// ------------------------------------------------------------------------
// Function CopyErrProc
//
// Displays Status returned from MyCopy after completion of Copy or Move
// Called after MyCopy completes.
// ------------------------------------------------------------------------
BOOL FAR PASCAL CopyErrProc(HWND hWnd, LPSTR lpSrc, LPSTR lpTarget, LONG lResult)
{
     // error strings indexed to result from MyCopy
     LPSTR lpErrorMessage[]={
                "copy completed successfully",
                "source not specified",
                "target not specified",
                "wild cards are not allowed in source",
                "wild cards are not allowed in target",
                "source and target are the same",
                "source was not found",
                "unable to open source",
                "unable to create target",
                "could not alloc -or- lock memory",
                "error reading source",
                "no disk space for target",
                "file move error, cannot remove source",
                "error unknown",
                ""};

     sprintf(szWorkBuf,
              "Copy/Move Operation From %s to %s.\n\nStatus Code return value (%ld)",
              lpSrc, lpTarget, lResult);

     // if the result is out of range use the unknown error message
     if(lResult>E_UNKNOWN || lResult<E_SUCCESS)lResult = E_UNKNOWN;

     MessageBox(hWnd,szWorkBuf,lpErrorMessage[lResult],
                MB_ICONINFORMATION);

     if(lResult == E_SUCCESS)return TRUE;

return FALSE;
}



// ------------------------------------------------------------------------
// Display info about this program
// ------------------------------------------------------------------------
LRESULT MyAbout(HWND hWnd)
{
  
  MessageBox(hWnd,
    "SPLITIT\251 is a utility program that "
    "Splits, Joins, and Kills Files in The Current Directory, or "
    "Splits and Joins from floppy to the current directory. "
    "You can also use SPLITIT\251 to Move and Copy Files.\n\n"
    "Use With Care! Damage can be Caused if Your Disk Is Full!\n\n"
    "SPLITIT\251 is distributed as FreeWare with Open Source.\n\n"
    "You have a royalty-free right to use, modify, reproduce and "
    "distribute this program and its source code in any non-competetive "
    "way you find useful, "
    "provided that you agree that Bill Buckels has no warranty obligations "
    "or liability resulting from said distribution in any way whatsoever.\n\n"
    "\t\tBill Buckels\n"
    "\t\t589 Oxford Street\n"
    "\t\tWinnipeg, Manitoba, Canada R3M 3J2\n\n"
    "Email: bbuckels@escape.ca\n"
    "WebSite: http://www.escape.ca/~bbuckels\n"
    "Home of Teacher's Choice Productions.\n" ,
    lpszTitle,
    MB_SUCCESS);

  return 0L;

}


// ------------------------------------------------------------------------
// Displays help...
// ------------------------------------------------------------------------
LRESULT MyHelp(HWND hWnd)
{
    // No Help File Yet
    // SetCursor(LoadCursor(NULL,IDC_WAIT));
    // HELPACTIVE = WinHelp(hWnd,"SPLITIT.HLP",HELP_CONTENTS,0L);
    // SetCursor(LoadCursor(NULL,IDC_ARROW));

  MessageBox(hWnd,

  "Split Files Into Two or more Parts. Headers or Footers may be removed "
  "using this method. Files may also be joined again using the Join Option. "
  "Splitit Offers Both interactive and command line usage modes. "
  "The commandline mode which is covered below allows Splitit to be "
  "called from a batch file and perform its handiwork non-interactively.\n\n"
  "Commandline: SPLITIT [command] ROOTNAME.EXT [checksum-bytes]\n\n"
  "\tB - Behead - remove [checksum] bytes from the beginning of the file."
  " 2-files are created... [ROOTNAME].001 and [ROOTNAME].002.\n"
  "\tT - Trim - remove [checksum] bytes from the end of the file."
  " 2-files are created... [ROOTNAME].001 and [ROOTNAME].002.\n"
  "\tC - Chunk BINARY "
  "- break file into pieces (multiple files) of [checksum] bytes"
  " starting with  file [ROOTNAME].001, [ROOTNAME].002, etc.\n"
  "\tA - Chunk ASCII "
  "- break a file into pieces of [checksum] bytes same as binary"
  " but do not split lines of text. Use for large text files"
  " like Logfiles, etc.\n"
  "\tJ - Join - Join a file that was previously split into pieces"
  " (multiple files) starting with  file [ROOTNAME].001. "
  "The [checksum] is not required for this option.\n\n"
  "This program is distributed without Warranty or liability.",
  lpszTitle,
  MB_SUCCESS);

  return 0L;
}


// ------------------------------------------------------------------------
// Handles Messages used in this program
// ------------------------------------------------------------------------
LRESULT MyMessage(HWND hWnd,
                 LPSTR lpFormat, LPSTR lpMessage, LPSTR lpTitle,
                 int iStyle)
{

  if (NULL == lpFormat)
   strcpy(szMessageBuf, lpMessage);
  else
    sprintf(szMessageBuf, lpFormat, lpMessage);

  if (NULL == lpTitle)
    return (LRESULT)MessageBox(hWnd, szMessageBuf, lpszTitle, iStyle);
  else
    return (LRESULT)MessageBox(hWnd, szMessageBuf, lpTitle, iStyle);
}


// ------------------------------------------------------------------------
// FUNCTION FileExists
//
// returns TRUE if the pathname is valid
// returns FALSE if not
// ------------------------------------------------------------------------
BOOL FAR PASCAL FileExists(LPSTR lpszFileName, LPSTR lpszShortName)
{
   FILE *fp;
   char *ptr;
   int idx;
   char c;

   if(lpszFileName[0]==ASCIIZ)return FALSE;

   if (NULL == (fp = fopen(lpszFileName, "rb")))return FALSE;
   fclose(fp);

   if (NULL != lpszShortName) {
    ptr = (char *)&lpszFileName[0];
    for (idx = 0; lpszFileName[idx]!=0; idx++) {
      c = lpszFileName[idx];
      if (c == 92||c==':')
        ptr = (char *)&lpszFileName[idx+1];
    }
    strcpy(lpszShortName, ptr);
   }

return TRUE;
}


// ------------------------------------------------------------------------
// strip extension from filename... destructive function.
// always work on a copy when calling this function...
// ------------------------------------------------------------------------
int BaseName(char *ptr, char *szShortName)
{
  int idx, jdx = 0, kdx = 0;

  for (idx = 0; ptr[idx]!= ASCIIZ; idx++) {
        if (ptr[idx] == '.')    // track the last known dot
          jdx = idx;
        // avoid directories with .EXTensions
        if (ptr[idx] == 92 || ptr[idx] == ':') {
          jdx = 0;
          kdx = idx + 1;
        }
  }

  if (jdx)
    ptr[jdx] = ASCIIZ;

  if (NULL != szShortName)
    strcpy(szShortName, (char *)&ptr[kdx]);

  return (kdx); // return offset of short file name in longname string
}


// return free bytes for splitting file...
// a diskette must be in the drive for this to work.

LRESULT FloppySize(char DriveLetter)
{
  struct _diskfree_t drive;
  long freebytes   = 0L;
  long totalbytes  = 0L;  // left here for reference

  _getdiskfree((unsigned)(DriveLetter - 64), &drive);

  totalbytes += drive.total_clusters;
  freebytes  += drive.avail_clusters;
  totalbytes *= drive.sectors_per_cluster;
  freebytes *= drive.sectors_per_cluster;
  totalbytes *= drive.bytes_per_sector;
  freebytes  *= drive.bytes_per_sector;

  return freebytes;
}

// ------------------------------------------------------------------------
// FUNCTION ClearScreen
//
// clear the client area of the window to the clearcolor.
// ------------------------------------------------------------------------
int ClearScreen(HWND hWnd, HDC hdcExternal, COLORREF dwClearColor)
{
    HDC hdcTemp;                   // device context to use for this
    HBRUSH hPrevBrush, hClearBrush;// brush to clear client area
    RECT rcClientArea;   // data structure of xy coordinates for rectangle
    HPEN hPrevPen, hClearPen;      // pen to clear area

    if (hdcExternal == NULL)       // during paint method we
      hdcTemp=GetDC(hWnd);         // already have a DC but if we are called
    else                           // outside of paint we don't usually...
      hdcTemp = hdcExternal;

    if(hdcTemp==NULL)return FAILURE;
    hClearBrush = CreateSolidBrush((COLORREF)dwClearColor);     // create brush
    hClearPen   = CreatePen(PS_SOLID,1,(COLORREF)dwClearColor); // create pen
    hPrevBrush = SelectObject(hdcTemp,hClearBrush); // select brush
    hPrevPen   = SelectObject(hdcTemp,hClearPen);   // select pen
    GetClientRect(hWnd,&rcClientArea);         // fetch bounding coordinates
    FillRect(hdcTemp,&rcClientArea,hClearBrush);    // filled rectangle
    SelectObject(hdcTemp,hPrevPen);                 // deselect pen
    SelectObject(hdcTemp,hPrevBrush);               // deselect brush
    DeleteObject(hClearBrush);                      // delete brush
    DeleteObject(hClearPen);                        // delete pen

    if (hdcExternal == NULL)
      ReleaseDC(hWnd,hdcTemp);

return SUCCESS;                                     // return to caller
}

// called to reset paint method and redisplay start-up bitmap
void Restart(HWND hWnd)
{
  STARTED = FALSE;
  InvalidateRect(hWnd, NULL, TRUE);   // repaint everything
  UpdateWindow(hWnd);                 // force WM_PAINT message
}
