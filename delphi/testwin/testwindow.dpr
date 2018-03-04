program testwindow;

uses
  Windows,
  Messages;

var
  WinClass: TWndClassA;
  Inst, Handle, Button1, Label1, Edit1: Integer;
  Msg: TMsg;
  hFont: Integer;

{ Checks if typed password is 'Amigreen' and shows Message }
procedure CheckPassword;
var
  Textlength: Integer;
  Text: PChar;
begin
  TextLength := GetWindowTextLength(Edit1);
  if TextLength = 8 then
  begin
    GetMem(Text, TextLength + 1);
    GetWindowText(Edit1, Text, TextLength + 1);
    if Text = 'Amigreen' then
    begin
      MessageBoxA(Handle, 'Password is correct.', 'Password check', MB_OK);
      FreeMem(Text, TextLength + 1);
      Exit;
    end;
  end;
  MessageBoxA(Handle, 'Password is incorrect.', 'Password check', MB_OK);
end;

{ Custom WindowProc function }
function WindowProc(hWnd, uMsg,	wParam,	lParam: Integer): Integer; stdcall;
begin
  Result := DefWindowProc(hWnd, uMsg, wParam, lParam);
  { Checks for messages }
  if (lParam = Button1) and (uMsg = WM_COMMAND) then
    CheckPassword;
  if uMsg = WM_DESTROY then
    Halt;
end;

begin
  { ** Register Custom WndClass ** }
  Inst := hInstance;
  with WinClass do
  begin
    style              := CS_CLASSDC or CS_PARENTDC;
    lpfnWndProc        := @WindowProc;
    hInstance          := Inst;
    hbrBackground      := color_btnface + 1;
    lpszClassname      := 'AG_TESTWINDOW';
    hCursor            := LoadCursor(0, IDC_ARROW);
  end; { with }
  RegisterClass(WinClass);

  { ** Create Main Window ** }
  Handle := CreateWindowEx(WS_EX_WINDOWEDGE, 'AG_TESTWINDOW', 'Amigreen TestWindow 1.00',
                           WS_VISIBLE or WS_SIZEBOX or WS_CAPTION or WS_SYSMENU,
                           363, 278, 305, 65, 0, 0, Inst, nil);
  { ** Create a button ** }
  Button1 := CreateWindow('Button', 'OK', WS_VISIBLE or WS_CHILD or BS_PUSHLIKE or BS_TEXT,
                           216, 8, 75, 25, handle, 0, Inst, nil);
  { ** Create a label (static) ** }
  Label1 := Createwindow('Static', '', WS_VISIBLE or WS_CHILD or SS_LEFT,
               8, 12, 76, 13, Handle, 0, Inst, nil);

  { ** Create an edit field ** }
  Edit1 := CreateWindowEx(WS_EX_CLIENTEDGE, 'Edit', '', WS_CHILD or WS_VISIBLE or
                          WS_BORDER or ES_PASSWORD, 88, 8, 121, 21, Handle, 0, Inst, nil);

  { ** Create Font Handle ** }
  hFont := CreateFont(-11, 0, 0, 0, 400, 0, 0, 0, DEFAULT_CHARSET,
                      OUT_DEFAULT_PRECIS, CLIP_DEFAULT_PRECIS, DEFAULT_QUALITY,
                      DEFAULT_PITCH or FF_DONTCARE, 'MS Sans Serif');

  { Change fonts }
  if hFont <> 0 then
  begin
    SendMessage(Button1, WM_SETFONT, hFont, 0);
    SendMessage(Label1, WM_SETFONT, hFont, 0);
    SendMessage(Edit1, WM_SETFONT, hFont, 0);
  end;
  { Change label (static) text }
  SetWindowText(Label1, 'Enter password:');
  { Set the focus to the edit control }
  SetFocus(Edit1);

  UpdateWindow(Handle);

  { ** Message Loop ** }
  while(GetMessage(Msg, Handle, 0, 0)) do
  begin
    TranslateMessage(msg);
    DispatchMessage(msg);
  end; { with }
end.
