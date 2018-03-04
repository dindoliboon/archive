program ColorGet;

uses
   Windows, Commdlg;

{$R *.RES}

{ I don't want to use the SysUtils unit, so I wrote my own ByteToHex function }

function ByteToHex( b: Byte ): String;
const
     HexChar : array[0..15] of Char = '0123456789ABCDEF';
begin
     Result := HexChar[b shr 4] + HexChar[b and $F];
end;

type
  StrArr = array[0..6] of Char;
var
  i : Byte;
  MyColor : TChooseColor;           // The CHOOSECOLOR structure
  MyArr : array[0..15] of COLORREF; // Array of 16 custom colors (DWORDS)
  DataHandle : THandle;             // Handle to the data to be transferred
  DataPointer : ^StrArr;            // Pointer to the data to be transferred
  IniFile : array[0..255] of Char;  // Name of ini file
  IniStr, ArrStr : string;          // string name of ini file, and temp string

begin
  GetCurrentDirectory(254, IniFile);
  IniStr := string(IniFile) + '\ColorGet.ini';
  for i := 0 to 15 do begin
    MyArr[i] := GetPrivateProfileInt('CustColors', PChar(ByteToHex(i)),
                                     $FFFFFF, PChar(IniStr)); //color array
  end;
  MyColor.lStructSize := SizeOf(TChooseColor);  //set the size of the struct
  MyColor.rgbResult := GetPrivateProfileInt('RGBResult',
                                            'Color',
                                            $FFFFFF,
                                            PChar(IniStr)); // initial color
  MyColor.hwndOwner := 0;                       //no handle
  MyColor.lpCustColors := @MyArr;               //field set to address of array
  MyColor.Flags := CC_FULLOPEN or CC_RGBINIT;   //color dialog fully open

{ Open the color dialog and process data if user chooses OK (Result := True) }

  if ChooseColor(MyColor) then begin

{ Allocate a glocal moveable memory block for our font facename data}

    DataHandle := GlobalAlloc(GMEM_DDESHARE or GMEM_MOVEABLE,
                              SizeOf(MyColor.rgbResult));

{ Lock the global memory block above, returning a pointer to the first byte }

    DataPointer := GlobalLock(DataHandle);

{ Copy the chosen color to the buffer as a string, using ByteToHex function }

    DataPointer^[0] := '#';
    DataPointer^[1] := ByteToHex(GetRValue(MyColor.rgbResult))[1];
    DataPointer^[2] := ByteToHex(GetRValue(MyColor.rgbResult))[2];
    DataPointer^[3] := ByteToHex(GetGValue(MyColor.rgbResult))[1];
    DataPointer^[4] := ByteToHex(GetGValue(MyColor.rgbResult))[2];
    DataPointer^[5] := ByteToHex(GetBValue(MyColor.rgbResult))[1];
    DataPointer^[6] := ByteToHex(GetBValue(MyColor.rgbResult))[2];

{ Unlock the global memory object }

    GlobalUnlock(DataHandle);

{ Open clipboard for your exclusive use }

    OpenClipBoard(0);

{ Empty the clipboard before writing to it }

    EmptyClipBoard;

{ Place the data on to the clipboard in text format }

    SetClipBoardData(CF_TEXT, DataHandle);

{ Close Clipboard }

    CloseClipBoard;

{ Write custom colors in private ini file - a lot of the follwing machinations
  would have been avoided with use of the SysUtils unit, but such is life! }

    for i := 0 to 15 do begin
      ArrStr := '0x' + ByteToHex(GetBValue(MyArr[i])) +
                       ByteToHex(GetGValue(MyArr[i])) +
                       ByteToHex(GetRValue(MyArr[i]));
      WritePrivateProfileString('CustColors', PChar(ByteToHex(i)),
                                PChar(ArrStr), PChar(IniStr));

    end;
    ArrStr := '0x' + ByteToHex(GetBValue(MyColor.rgbResult)) +
                       ByteToHex(GetGValue(MyColor.rgbResult)) +
                       ByteToHex(GetRValue(MyColor.rgbResult));
    WritePrivateProfileString('RGBResult', 'Color',
                                PChar(ArrStr), PChar(IniStr));

  end;
end.
