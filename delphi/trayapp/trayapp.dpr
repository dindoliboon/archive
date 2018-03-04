program TrayApp;

uses
  Windows,
  Messages,
  ShellAPI;

{$D-,L-,O+,Y-}
{$R *.RES}

const
  AppName = 'Screen Saver Starter';
  ToolTipText = 'Click to start the screen saver';

var
  tid: TNotifyIconData;

{--------------------------------------------------------------}
{                   Things to actually do...                   }
{--------------------------------------------------------------}
procedure DoSomething(Wnd: hWnd);
begin
  PostMessage(Wnd, WM_SYSCOMMAND, SC_SCREENSAVE, 0);
end; { Do Something }

{--------------------------------------------------------------}
{                        The Popup Menu                        }
{--------------------------------------------------------------}
procedure DoPopupMenu(Wnd: hWnd);
var
  dc: hDC;
  pm: HMenu;
  pt: TPoint;
begin
  GetCursorPos (pt);
  pm := CreatePopupMenu;

  { define the popup menu items (& their commands) here }
  AppendMenu (pm, 0, Ord ('S'), 'Start Screen Saver');
  AppendMenu (pm, mf_Separator, 0, Nil);
  AppendMenu (pm, 0, Ord ('A'), 'About...');
  AppendMenu (pm, mf_Separator, 0, Nil);
  AppendMenu (pm, 0, Ord ('E'), 'Exit');

  SetForegroundWindow (Wnd);
  dc := GetDC (0);
  if TrackPopupMenu (pm, {tpm_Rightbutton or }tpm_BottomAlign or tpm_RightAlign, pt.x,GetDeviceCaps(dc,HORZRES){pt.y}, 0, Wnd, Nil)
    then SetForegroundWindow (Wnd);
  DestroyMenu (pm)
end;  { DoPopupMenu }

{--------------------------------------------------------------}
{                     Menu Item responses                      }
{--------------------------------------------------------------}
procedure HandleCommand (Wnd: hWnd; Cmd: Word);
begin
  { Respond to popup menu commands here }
  case Cmd of
    Ord ('A'){about}: MessageBox (0, 'Freeware - by Warren Young' + #10 + 'Use /s option to start the screen saver immediately.'+#10+'Use no parameters to put an icon in the system tray.', AppName, mb_ok);
    Ord ('E'){exit} : PostMessage (Wnd, wm_Close, 0, 0);
    Ord ('S'){start}: DoSomething(Wnd);
  end;
end;

{--------------------------------------------------------------}
{                        Mouse events                          }
{--------------------------------------------------------------}
procedure LeftClick(Wnd: hWnd);
begin
  DoSomething(Wnd);
end;  { LeftClick }

procedure RightClick(Wnd: hWnd);
begin
  DoPopupmenu(Wnd);
end;  { RightClick }

procedure LeftDblClick(Wnd: hWnd);
begin
  DoSomething(Wnd);
end;

procedure RightDblClick(Wnd: hWnd);
begin
  DoPopupmenu(Wnd);
end;

procedure LeftButtonUp(Wnd: hWnd);
begin end;
procedure RightButtonUp(Wnd: hWnd);
begin end;

{--------------------------------------------------------------}
{  WindowProc - to intercept the messages for our application  }
{--------------------------------------------------------------}
function DummyWindowProc (Wnd: hWnd; Msg, wParam: Word; lParam: LongInt): LongInt; stdcall;
begin
  DummyWindowProc := 0;
  case Msg of
    wm_Create:      // Program initialisation - just set up a tray icon
    begin
      tid.cbSize           := sizeof (tid);
      tid.Wnd              := Wnd;
      tid.uID              := 1;
      tid.uFlags           := nif_Message or nif_Icon or nif_Tip;
      tid.uCallBackMessage := wm_User;
      tid.hIcon            := LoadIcon (hInstance, 'MAINICON');
      lstrcpy (tid.szTip,ToolTipText);
      Shell_NotifyIcon (nim_Add, @tid);
      { Initialisation code can go here }
    end;
    wm_Destroy:
    begin
      Shell_NotifyIcon (nim_Delete, @tid);
      PostQuitMessage (0);
      { Any other cleaning up does here }
    end;
    wm_Command:     // Command notification
    begin
      HandleCommand (Wnd, LoWord (wParam));
      Exit;
    end;
    wm_User:        // Had a tray notification - see what to do
    begin
      if (lParam = wm_LButtonDown)   then LeftClick(Wnd);
      if (lParam = wm_LButtonDblClk) then LeftDblClick(Wnd);
{      if (lParam = wm_LButtonUp)     then LeftButtonUp(Wnd); {}
      if (lParam = wm_RButtonDown)   then RightClick(Wnd);
      if (lParam = wm_RButtonDblClk) then RightDblClick(Wnd);
{      if (lParam = wm_RButtonUp)     then RightButtonUp(Wnd); {}
    end;
  end;  { case of Msg }

  DummyWindowProc := DefWindowProc (Wnd, Msg, wParam, lParam);
end;

{--------------------------------------------------------------}
{  WinMain - to setup the application and handle the messages  }
{--------------------------------------------------------------}
procedure WinMain;
var
  Wnd: hWnd;
  Msg: TMsg;
  cls: TWndClass;
begin
  { Register the window class }
  FillChar(cls, sizeof (cls), 0);
  cls.lpfnWndProc := @DummyWindowProc;
  cls.hInstance := hInstance;
  cls.lpszClassName := AppName;
  RegisterClass (cls);

  { Now create the dummy window }
  Wnd := CreateWindow(AppName, AppName, ws_OverlappedWindow,
                      cw_UseDefault, cw_UseDefault, cw_UseDefault, cw_UseDefault,
                      0, 0, hInstance, Nil);
  if Wnd <> 0 then
  begin
    ShowWindow(Wnd, sw_Hide);
    while GetMessage(Msg, 0, 0, 0) do
    begin
      TranslateMessage(Msg);
      DispatchMessage(Msg);
    end;
  end;
end;  { WinMain }


{--------------------------------------------------------------}
{  The Program                                                 }
{         - test for command line parameters,                  }
{         - check if another instance of the app is running    }
{         - run "WinMain", to actually run the program         }
{--------------------------------------------------------------}
begin
  { is the command line saying to start screen saver  and exit immediately? }
  if paramstr(1) = '/s' then begin DoSomething(FindWindow(AppName, Nil)); exit; end;
  if paramstr(1) = '/S' then begin DoSomething(FindWindow(AppName, Nil)); exit; end;

  { If app is already running then start screen saver and exit immediately }
  if FindWindow(AppName, Nil) <> 0 then begin DoSomething(FindWindow(AppName, Nil)); exit; end;

  { Run the main program.... }
  WinMain;
end.
