library First;

{ Important note about DLL memory management: ShareMem must be the
  first unit in your library's USES clause AND your project's (select
  View-Project Source) USES clause if your DLL exports any procedures or
  functions that pass strings as parameters or function results. This
  applies to all strings passed to and from your DLL--even those that
  are nested in records and classes. ShareMem is the interface unit to
  the DELPHIMM.DLL shared memory manager, which must be deployed along
  with your DLL. To avoid using DELPHIMM.DLL, pass string information
  using PChar or ShortString parameters. }

uses
  SysUtils,
  Classes,
  Windows;

type
	//Turn the optimize and huge string option off
  //if Delphi cannot compile your plugin
  // you will see when your have some compilicated typecasts
	iReplace = procedure (Text: PChar);

var
  OwnerApp: Integer;

function GetName: Pchar; far;
begin
	Result := '&First Test';
end;

procedure InsertText; far;
begin
	iReplace(GetProcAddress(OwnerApp, 'ReplaceText'))('Magic Plguins');
end;

{ Old function, only depend on windows user dll
procedure InsertText(AHandle: THandle); far;
var
	Txt: String;
  P: PChar;
	SelStart, Len: Integer;
  TextLen: Integer;
begin
	TextLen := GetWindowTextLength(AHandle);
	SelStart := 0; Len := 0;
	SendMessage(AHandle, EM_GETSEL, LongInt(Addr(SelStart)), LongInt(Addr(Len)));
  Len := Len - SelStart;

  MessageBox(0, PChar(IntToStr(Len) + IntToStr(SelStart)), 'Debug', 0);

  SetString(Txt, PChar(nil), Len);
  if not ((SelStart<0) or (TextLen<=0)) then
  begin
  	if Len <> 0 then
  	begin
    	P := StrAlloc(TextLen + 1);
    	try
      	SendMessage(AHandle, WM_GETTEXT, StrBufSize(P), LongInt(P));
  	    Move(P[SelStart], Pointer(Txt)^, Len);
        Txt := 'Before ' + Txt + ' What';
				SendMessage(AHandle, EM_REPLACESEL, 0, LongInt(PChar(Txt)));
    	finally
      	StrDispose(P);
    	end;
  	end
    else
    begin
      Txt := 'Before  What';
			SendMessage(AHandle, EM_REPLACESEL, 0, LongInt(PChar(Txt)));
    end;
  end;

end;
}

procedure Init(Owner: Integer); far
begin
	OwnerAPP := Owner;
end;

exports
	GetName, InsertText, Init;



begin
end.
