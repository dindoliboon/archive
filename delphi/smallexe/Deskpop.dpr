program DeskPop;

uses
    Windows, Messages, ShellAPI, sysutils;

{$R *.RES}
{$R ICONS.RES}

const
    AppName = 'DeskTop Hide';

var
    x: integer;
    tid: TNotifyIconData;
    WndClass: array[0..50] of char;

procedure Panic (szMessage: PChar);
begin
    if szMessage <> Nil then
    MessageBox (0, szMessage, AppName, mb_ok);
    Halt (0);
end;

procedure HandleCommand (Wnd: hWnd; Cmd: Word);
begin
case Cmd of
Ord ('A'): MessageBox (0, 'Freeware brian.slack@strath.ac.uk 1997', AppName, mb_ok);
Ord ('E'): PostMessage (Wnd, wm_Close, 0, 0);
end;
end;

function DummyWindowProc (Wnd: hWnd; Msg, wParam: Word; lParam: LongInt): LongInt; stdcall;
var
    TrayHandle: THandle;
    dc: hDC;
    i: Integer;
    pm: HMenu;
    pt: TPoint;
begin
DummyWindowProc := 0;
StrPCopy(@WndClass[0], 'Progman');
TrayHandle := FindWindow(@WndClass[0], nil);
case Msg of
wm_Create:      // Program initialisation - just set up a tray icon
begin
     tid.cbSize           := sizeof (tid);
     tid.Wnd              := Wnd;
     tid.uID              := 1;
     tid.uFlags           := nif_Message or nif_Icon or nif_Tip;
     tid.uCallBackMessage := wm_User;
     tid.hIcon            := LoadIcon (hInstance, 'MAINICON');
     lstrcpy (tid.szTip,'Desktop is on');
     Shell_NotifyIcon (nim_Add, @tid);
end;
wm_Destroy:
begin
     Shell_NotifyIcon (nim_Delete, @tid);
     PostQuitMessage (0);
     ShowWindow(TrayHandle, SW_RESTORE);
end;
wm_Command:     // Command notification
begin
     HandleCommand (Wnd, LoWord (wParam));
     Exit;
end;
wm_User:        // Had a tray notification - see what to do
if (lParam = wm_LButtonDown) then
begin
if x = 0 then
begin
ShowWindow(TrayHandle, SW_HIDE);
tid.hIcon := LoadIcon (hInstance, 'offICON');
lstrcpy (tid.szTip,'Desktop is off');
Shell_NotifyIcon (NIM_MODIFY, @tid);
x:=1
end else
begin
ShowWindow(TrayHandle, SW_RESTORE);
tid.hIcon := LoadIcon (hInstance, 'ONICON');
lstrcpy (tid.szTip,'Desktop is on');
Shell_NotifyIcon (NIM_MODIFY, @tid);
x:= 0;
end;
end else
if  (lParam = wm_RButtonDown) then
begin
GetCursorPos (pt);
pm := CreatePopupMenu;
AppendMenu (pm, 0, Ord ('A'), 'About DeskTop Hide...');
AppendMenu (pm, mf_Separator, 0, Nil);
AppendMenu (pm, 0, Ord ('E'), 'Exit DeskTop Hide');
SetForegroundWindow (Wnd);
dc := GetDC (0);
if TrackPopupMenu (pm, tpm_BottomAlign or tpm_RightAlign, pt.x,GetDeviceCaps(dc,HORZRES){pt.y}, 0, Wnd, Nil) then
                 SetForegroundWindow (Wnd);
                 DestroyMenu (pm)
end;
end;

DummyWindowProc := DefWindowProc (Wnd, Msg, wParam, lParam);
end;

procedure WinMain;
var
    Wnd: hWnd;
    Msg: TMsg;
    cls: TWndClass;
begin
    { Previous instance running ?  If so, exit }
    if FindWindow (AppName, Nil) <> 0 then Panic (AppName + ' is already running.');

    { Register the window class }
    FillChar (cls, sizeof (cls), 0);
    cls.lpfnWndProc := @DummyWindowProc;
    cls.hInstance := hInstance;
    cls.lpszClassName := AppName;
    RegisterClass (cls);

    { Now create the dummy window }
    Wnd := CreateWindow (AppName, AppName, ws_OverlappedWindow,
                         cw_UseDefault, cw_UseDefault, cw_UseDefault, cw_UseDefault,
                         0, 0, hInstance, Nil);
    x:= 0;
    if Wnd <> 0 then
    begin
        ShowWindow (Wnd, sw_Hide);
        while GetMessage (Msg, 0, 0, 0) do
        begin
            TranslateMessage (Msg);
            DispatchMessage (Msg);
        end;
    end;
end;

begin
    WinMain;
end.
