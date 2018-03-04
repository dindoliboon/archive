program tks_rdl;

uses
    Windows, Messages, ShellAPI, SysUtils;

{$R *.RES}

const
    szAppName = 'SFMenu Sorter v1.0';
    szRegPath = 'Software\Microsoft\Windows\CurrentVersion\Explorer\MenuOrder';

var
    tryID    : TNotifyIconData;
    winClass : array[0..50] of char;

{Processes Menu Commands}
procedure HandleCommand (hWnd: HWND; wParam: Word);
begin
    case wParam of
        Ord('S'): RegDeleteKeyA($80000001, szRegPath + '\Start Menu');
        Ord('F'): RegDeleteKeyA($80000001, szRegPath + '\Favorites');
        Ord('B'): RegDeleteKeyA($80000001, szRegPath);
        Ord('X'): PostMessage (hWnd, WM_CLOSE, 0, 0);
        Ord('A'): MessageBox (0, 'Sort Start and Favorites Menu alphabetically!', szAppName, MB_OK);
    end;
end;

{Processes Messages}
function WndProc (hWnd: HWND; uMsg, wParam: Word; lParam: LongInt): LongInt; stdcall;
var
    tryhWnd: THandle;
    hndMenu: HMenu;
    pt: TPoint;
begin
    WndProc := 0;
    StrPCopy(@winClass[0], 'TKS_SFMENUS');
    tryhWnd := FindWindow(@winClass[0], nil);
    case uMsg of
    //Define system-tray
    WM_CREATE:
    begin
        //On run-time sort Both
        if LowerCase(ParamStr(1)) = 'both' then
        begin
            HandleCommand(0, Ord('B'));
            PostMessage (hWnd, WM_CLOSE, 0, 0);
        end;

        //On run-time sort Start Menu
        if LowerCase(ParamStr(1)) = 'smnu' then
        begin
            HandleCommand(0, Ord('S'));
            PostMessage (hWnd, WM_CLOSE, 0, 0);
        end;

        //On run-time sort Favorites Menu
        if LowerCase(ParamStr(1)) = 'fmnu' then
        begin
            HandleCommand(0, Ord('F'));
            PostMessage (hWnd, WM_CLOSE, 0, 0);
        end;

        tryID.cbSize           := SizeOf (tryID);
        tryID.Wnd              := hWnd;
        tryID.uID              := 1;
        tryID.uFlags           := NIF_MESSAGE or NIF_ICON or NIF_TIP;
        tryID.uCallBackMessage := WM_USER;
        tryID.hIcon            := LoadIcon (hInstance, 'MAINICON');
        lstrcpy (tryID.szTip, szAppName);
        Shell_NotifyIcon (nim_Add, @tryID);
    end;

    //Kills tray icon
    WM_DESTROY:
    begin
        Shell_NotifyIcon (NIM_DELETE, @tryID);
        PostQuitMessage (0);
        ShowWindow(tryhWnd, SW_RESTORE);
    end;

    //Sends info to process menu commands
    WM_COMMAND:
    begin
        HandleCommand (hWnd, LoWord (wParam));
        Exit;
    end;

    //Creates menu
    WM_USER:
        if (lParam = WM_RBUTTONDOWN) then
        begin
            GetCursorPos (pt);
            hndMenu := CreatePopupMenu;
            AppendMenu (hndMenu, 0, Ord ('S'), 'Sort &Start Menu');
            AppendMenu (hndMenu, 0, Ord ('F'), 'Sort &Favorites');
            AppendMenu (hndMenu, 0, Ord ('B'), 'Sort &Both');
            AppendMenu (hndMenu, MF_SEPARATOR, 0, Nil);
            AppendMenu (hndMenu, 0, Ord ('X'), 'E&xit');
            AppendMenu (hndMenu, MF_SEPARATOR, 0, Nil);
            AppendMenu (hndMenu, 0, Ord ('A'), '&About');
            SetForegroundWindow (hWnd);
            if TrackPopupMenu (hndMenu, TPM_BOTTOMALIGN or TPM_RIGHTALIGN, pt.x, pt.y,0, hWnd, Nil) then
            begin
                SetForegroundWindow (hWnd);
                DestroyMenu (hndMenu);
            end;
        end;
    end;
    WndProc := DefWindowProc (hWnd, uMsg, wParam, lParam);
end;

{Main window creation}
procedure WinMain;
var
    sWnd: hWnd;
    uMsg: TMsg;
    wCls: TWndClass;
begin
    //Checks for previous instances
    if FindWindow (szAppName, Nil) <> 0 then Halt;

    //Registers the window class
    FillChar (wCls, SizeOf (wCls), 0);
    wCls.lpfnWndProc := @WndProc;
    wCls.hInstance := hInstance;
    wCls.lpszClassName := szAppName;
    RegisterClass (wCls);

    //Creates main window
    sWnd := CreateWindow (szAppName, szAppName, WS_OVERLAPPEDWINDOW,
    CW_USEDEFAULT, CW_USEDEFAULT, CW_USEDEFAULT, CW_USEDEFAULT,
    0, 0, hInstance, Nil);

    if sWnd <> 0 then
    begin
        ShowWindow (sWnd, SW_HIDE);
        while GetMessage (uMsg, 0, 0, 0) do
        begin
            TranslateMessage (uMsg);
            DispatchMessage (uMsg);
        end;
    end;
end;

begin
WinMain;
end.
