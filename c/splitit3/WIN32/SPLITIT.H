#include <windows.h>

// menu constants

// file menu
#define  IDM_QUIT      0x100
#define  IDM_LIST      0x101
#define  IDM_COPY      0x102
#define  IDM_MOVE      0x103
#define  IDM_DELETE    0x104

// split menu
#define  IDM_BEHEAD    0x200
#define  IDM_TRIM      0x201
#define  IDM_CHUNK     0x202
#define  IDM_TEXT      0x203
#define  IDM_SPLIT     0x204

// join menu
#define  IDM_JOIN      0x300
#define  IDM_FLOPPY    0x301

// future use
// tools submenus
#define  IDM_GREP          0x400
#define  IDM_BINGREP       0x401
#define  IDM_DIFF          0x402
#define  IDM_BINTOHEX      0x403
#define  IDM_HEXTOBIN      0x404

// help menu
#define  IDM_HELP      0x500
#define  IDM_ABOUT     0x501


// dialog constants
#define IDD_OK       5000
#define IDD_CANCEL   5001
#define IDD_EDITTEXT 5002

#define DIR_ANY       0
#define DIR_IMPORT    1
#define DIR_EXPORT    2

#define SUCCESS        0
#define FAILURE       -1

#define ASCIIZ         0

#define FLOPPY1440K    1457664L
#define FLOPPY1200K    1213952L
#define FLOPPY360K     362496L
#define FLOPPY720K     730112L

#define MAXFLOPPYSIZE  FLOPPY1440K


#define MAXCUSTFILTER 256
#define MAXFILENAME   MAX_PATH
#define INPUTSIZE     128   // max length of input - various cases
#define BIGBUFFERSIZE 1026
#define BUFFERSIZE    514
#define TITLESIZE     128

#define MB_SUCCESS  (MB_OK|MB_ICONINFORMATION)
#define MB_FAILURE  (MB_OK|MB_ICONSTOP)
#define MB_QUESTION (MB_ICONQUESTION|MB_YESNO)

// general purpose constants
#define E_NOTHING     0L          // Something to Return

// error return codes from MyCopy

#define E_SUCCESS       0L
#define E_NOSOURCENAME  1L          // source not specified
#define E_NOTARGETNAME  2L          // target not specified
#define E_WILDSOURCE    3L          // wild cards are not allowed in source
#define E_WILDTARGET    4L          // wild cards are not allowed in target
#define E_SAMENAME      5L          // source and target are the same
#define E_NOSOURCE      6L          // source was not found
#define E_SOURCEOPEN    7L          // unable to open source
#define E_TARGETOPEN    8L          // unable to create target
#define E_NOMEMORY      9L          // could not alloc -or- lock memory
#define E_READERROR    10L          // error reading source
#define E_DISKSPACE    11L          // no disk space for target
#define E_SOURCEREMOVE 12L          // file move error, cannot remove source
#define E_UNKNOWN      13L          // error unknown

#define BMP_WIDTH      504
#define BMP_HEIGHT     420
