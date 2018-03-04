program FontLook;

{  This program brings up the standard Win95 Choose Font Dialog, and then
   copies the selected font facename to the clipboard. If I used the Dialog
   and Clipbrd units of Delphi it would only be 3 lines long, but it would
   compile to 200KB which I think is excessive. And anyway, I just wanted
   to do it from scratch using just the win32 API. One of the uses of this
   simple program (compiles to 17KB!) is if you are a Notepad (or equivalent)
   HTML author, and want an easy and quick way to choose and preview fonts }

uses
  Windows, Commdlg;   // look ma, no Delphi units!

{$R *.RES}  // OK, so we do include an icon!

type

  MyArray = array[0..31] of AnsiChar;   // This is how the lfFaceName field
                                        // of the TLogFont structure is defined
                                        // in the Windows.PAS unit
var                               
  MyChooseFont : TChooseFont;   // Defined in the Commdlg.PAS unit
  MyLogFont : TLogFont;         // Includes the font facename data field
  DataHandle : THandle;         // Handle to the data to be transferred
  DataPointer : ^MyArray;       // Pointer to the data to be transferred

begin

{ Initialise the TChooseFont structure }

  MyChooseFont.lStructSize := SizeOf(TChooseFont);
  MyChooseFont.hWndOwner := 0;          // no owner in this example
  MyChooseFont.lpLogFont := @MyLogFont; // address of TLogFont structure
  MyChooseFont.Flags := CF_SCREENFONTS  // List supported screen fonts, +
                        or CF_EFFECTS;  // effects like color, underline...

{ Execute the ChooseFont structure, which brings up the ChooseFont dialog }

  if ChooseFont(MyChooseFont) then begin

{ Allocate a glocal moveable memory block for our font facename data}

    DataHandle := GlobalAlloc(GMEM_DDESHARE or GMEM_MOVEABLE,
                              SizeOf(MyChooseFont.lpLogFont.lfFaceName));

{ Lock the global memory block above, returning a pointer to the first byte }

    DataPointer := GlobalLock(DataHandle);

{ Copy the font facename data to the buffer. Notice I use typecasting }

    DataPointer^ := MyArray(MyChooseFont.lpLogFont.lfFaceName);

{ Unlock the global memory object }

    GlobalUnlock(DataHandle);

{ Open clipboard for your exclusive use }

    OpenClipBoard(0);

{ Empty the clipboard before writing to it }

    EmptyClipBoard;

{ Place our data on to the clipboard in text format }

    SetClipBoardData(CF_TEXT, DataHandle);

{ Close Clipboard }

    CloseClipBoard;

  end; {if}

end.
