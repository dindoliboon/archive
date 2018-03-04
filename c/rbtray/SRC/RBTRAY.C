#include <windows.h>
#include "rbtray.h"

#define MAXCOUNT 64
#define MAXTEXT  64
#define WS_WINDOW_STYLE WS_OVERLAPPED


 typedef BOOL (*RegHook)(HMODULE hLib);
 typedef void (*UnRegHook)(void);

static HWND hwndHook;
static HINSTANCE thisInstance;
static HWND list[MAXCOUNT];
static HWND CurrentWindow;
static HMODULE hLib;

BOOL CALLBACK
UpdMenu(HWND  hwnd,LPARAM lParam)
{
    int i;
    BOOL flag=lParam;
    int Checked;
    HMENU hSysMenu=GetSystemMenu(hwnd, FALSE);
    for(i=0;i<GetMenuItemCount(hSysMenu) && hSysMenu;i++)
        if(GetMenuItemID(hSysMenu,i)==IDM_TRAY) hSysMenu = 0;
    if (hSysMenu && lParam)
    {
        InsertMenu (hSysMenu, GetMenuItemID(hSysMenu,0),MF_SEPARATOR,IDM_SEPARATOR, NULL) ;
        if(GetWindowLong(hwnd,GWL_EXSTYLE)&WS_EX_TOPMOST)
            InsertMenu (hSysMenu, GetMenuItemID(hSysMenu,0),MF_STRING|MF_CHECKED,IDM_ONTOP,"Always on top");
        else
            InsertMenu (hSysMenu, GetMenuItemID(hSysMenu,0),MF_STRING,IDM_ONTOP,"Always on top");
        InsertMenu (hSysMenu, GetMenuItemID(hSysMenu,0),MF_STRING,IDM_TRAY,"Minimize in tray");
    }
    if (hSysMenu && lParam==FALSE)
    {
        DeleteMenu (hSysMenu,IDM_TRAY,MF_BYCOMMAND);    
        DeleteMenu (hSysMenu,IDM_ONTOP,MF_BYCOMMAND);   
        DeleteMenu (hSysMenu,IDM_SEPARATOR,MF_BYCOMMAND);   
    }
    return TRUE;
}

int
FindInTray(HWND hwnd)
{
  int i;
  for (i = MAXCOUNT - 1; i >= 0; i--)
    if (list[i] == hwnd) break;
  return i;
}

static void
DelFromTray(int i)
{
  NOTIFYICONDATA nid;

  if (i < 0)
    return;
  nid.cbSize = sizeof(NOTIFYICONDATA);
  nid.hWnd   = hwndHook;
  nid.uID    = (UINT)list[i];
  list[i] = 0;
  Shell_NotifyIcon(NIM_DELETE, &nid);
}

static void
ShowIt(HWND hwnd)
{
  ShowWindow(hwnd, SW_SHOW);
  ShowWindow(hwnd, SW_RESTORE);
  SetForegroundWindow(hwnd);
}

static void
ShowTheWindow(HWND hwnd)
{
  if ((GetWindowLong(hwnd, GWL_STYLE) & WS_CHILD))
  {
    HWND parent = hwnd;
    do
      parent = GetParent(parent);
      while (parent && FindInTray(parent) < 0);
    if (parent)
      ShowTheWindow(parent);
  }
  ShowIt(hwnd);
  DelFromTray(FindInTray(hwnd));

}

static void
CloseTheWindow(HWND hwnd)
{
  SetForegroundWindow(hwnd);
  SendMessage(hwnd, WM_CLOSE, 0, 0);
  if (!IsWindow(hwnd)) DelFromTray(FindInTray(hwnd));

}
HICON
GetWindowIcon(HWND hwnd)
{
  HICON icon;
  if (icon = (HICON)SendMessage(hwnd, WM_GETICON, ICON_SMALL, 0))
    return icon;
  if (icon = (HICON)SendMessage(hwnd, WM_GETICON, ICON_BIG, 0))
    return icon;
  if (icon = (HICON)GetClassLong(hwnd, GCL_HICONSM))
    return icon;
  if (icon = (HICON)GetClassLong(hwnd, GCL_HICON))
    return icon;
  return LoadIcon(NULL, IDI_WINLOGO);
}

void
ExecuteMenu()
{
    HMENU hMenu;
    POINT point;

    hMenu=CreatePopupMenu();
    if(!hMenu)
    {
        MessageBox(NULL, "Error crerating menu", "RBTray",MB_OK);
        return;
    };
    AppendMenu(hMenu,MF_STRING,IDM_ABOUT,   "About RBTray\0");
    AppendMenu(hMenu,MF_SEPARATOR,0,NULL);//------------------
    AppendMenu(hMenu,MF_STRING,IDM_RESTORE, "Restore window\0");
    AppendMenu(hMenu,MF_STRING,IDM_CLOSE,   "Close window\0");
    AppendMenu(hMenu,MF_STRING,IDM_DESTROY, "Kill window\0");
    AppendMenu(hMenu,MF_SEPARATOR,0,NULL);//------------------
    AppendMenu(hMenu,MF_STRING,IDM_EXIT,    "Exit RBTray\0");

    GetCursorPos (&point);
    SetForegroundWindow (hwndHook);

    TrackPopupMenu (hMenu, TPM_LEFTBUTTON | TPM_RIGHTBUTTON | TPM_RIGHTALIGN | TPM_BOTTOMALIGN,
                    point.x, GetSystemMetrics(SM_CYSCREEN), 0, hwndHook, NULL);

    PostMessage (hwndHook, WM_USER, 0, 0);
    DestroyMenu(hMenu);
}

BOOL CALLBACK
AboutDlgProc( HWND hWnd, UINT Msg, WPARAM wParam, LPARAM lParam )
{
    switch( Msg )
    {
        case WM_INITDIALOG:
            SetDlgItemText(hWnd,IDC_EDIT,"nike@sendmail.ru");
        break;

        case WM_CLOSE:
            PostMessage( hWnd, WM_COMMAND, IDCANCEL, 0l );
        break;

        case WM_COMMAND:
            switch( LOWORD(wParam) )
            {
                case IDOK:
                    EndDialog( hWnd, TRUE );
                break;

                case IDCANCEL:
                    EndDialog( hWnd, FALSE );
                break;

            }
        break;
        default:
            return FALSE;
    }
    return TRUE;
}

void
DestroyTheWindow(HWND hwnd)
{
    DWORD pID;
    HANDLE hProc;

    GetWindowThreadProcessId(hwnd,&pID);
    hProc=OpenProcess(PROCESS_ALL_ACCESS,TRUE,pID);
    if(TerminateProcess(hProc,1)) DelFromTray(FindInTray(hwnd));
}

LRESULT CALLBACK
HookWndProc(HWND hwnd, UINT msg, WPARAM wParam, LPARAM lParam)
{
  NOTIFYICONDATA nid;
  int i;
  DWORD ProcessId;
  HMENU hSysMenu;
  switch (msg) {
    case WM_COMMAND:
        switch (LOWORD(wParam))
        {
           case IDM_RESTORE:
              ShowTheWindow(CurrentWindow);
              break;
           case IDM_EXIT:
               SendMessage(hwndHook,WM_DESTROY,0,0);
               break;
           case IDM_CLOSE:
               CloseTheWindow(CurrentWindow);
               break;
           case IDM_ABOUT:
               DialogBox(thisInstance, MAKEINTRESOURCE(IDD_DIALOG1), hwndHook, (DLGPROC)AboutDlgProc );
               break;
           case IDM_DESTROY:
               if(MessageBox(NULL,"Kill the window?","RBTray",MB_YESNO | MB_ICONWARNING )==IDYES)DestroyTheWindow(CurrentWindow);
               break;
        };
        break;
    case WM_MYCMD:
        switch (wParam)
        {
           case IDM_TRAY:
              for(i=MAXCOUNT-1;i>=0;i--)
              if(!list[i])break;
              if (i < 0)break;
              list[i]=(HWND)lParam;
              nid.cbSize           = sizeof(NOTIFYICONDATA);
              nid.hWnd             = hwndHook;
              nid.uID              = (UINT)lParam;
              nid.uFlags           = NIF_MESSAGE | NIF_ICON | NIF_TIP;
              nid.uCallbackMessage = WM_TRAYCMD;
              nid.hIcon            = GetWindowIcon((HWND)lParam);
              ShowWindow((HWND)lParam, SW_HIDE);
              ShowWindow((HWND)lParam, SW_MINIMIZE);
              GetWindowText((HWND)lParam, nid.szTip, MAXTEXT);
              Shell_NotifyIcon(NIM_ADD, &nid);
              ShowWindow((HWND)lParam, SW_HIDE);
              break;
          case IDM_ONTOP:
            hSysMenu=GetSystemMenu((HWND)lParam, FALSE);
            if(hSysMenu)
            {
                if(GetMenuState(hSysMenu, IDM_ONTOP,MF_BYCOMMAND) & MF_CHECKED)
                //GetWindowLong((HWND)lParam,GWL_EXSTYLE)&WS_EX_TOPMOST)
                {
                    CheckMenuItem(hSysMenu,IDM_ONTOP,MF_BYCOMMAND |MF_UNCHECKED);
                    SetWindowPos((HWND)lParam,HWND_NOTOPMOST,0,0,0,0,SWP_NOMOVE|SWP_NOSIZE|SWP_NOREDRAW);
                }
                else 
                {
                    CheckMenuItem(hSysMenu,IDM_ONTOP,MF_BYCOMMAND |MF_CHECKED);
                    SetWindowPos((HWND)lParam,HWND_TOPMOST,0,0,0,0,SWP_NOMOVE|SWP_NOSIZE|SWP_NOREDRAW);
                }
            }
            break;
        }              
    case WM_DELTRAY:
      CloseTheWindow((HWND)wParam);
      break;
    case WM_TRAYCMD:
      switch ((UINT)lParam) {
        case WM_LBUTTONDOWN:
          ShowTheWindow((HWND)wParam);
          break;
        case WM_RBUTTONDOWN:
            CurrentWindow=(HWND)wParam;
            ExecuteMenu();
          break;
        case WM_MOUSEMOVE:
          if (!IsWindow((HWND)wParam))
            DelFromTray(FindInTray((HWND)wParam));
          else {
            nid.uID              = (UINT)wParam;
            nid.uFlags           = NIF_ICON | NIF_TIP;
            nid.hIcon            = GetWindowIcon((HWND)wParam);
            GetWindowText((HWND)wParam, nid.szTip, MAXTEXT);
            Shell_NotifyIcon(NIM_MODIFY, &nid);
            }
        }
        break;
    case WM_DESTROY:
      for (i = MAXCOUNT - 1; i >= 0; i--)
        if (list[i])
        {
          ShowIt(list[i]);
          DelFromTray(i);
        }
      UnRegisterHook();
      FreeLibrary(hLib);
      EnumWindows((WNDENUMPROC)UpdMenu,FALSE);
      PostQuitMessage(0);
      break;
    }
  return DefWindowProc(hwnd, msg, wParam, lParam);
}

int WINAPI
WinMain (HINSTANCE hInstance, HINSTANCE hPrevInstance,LPSTR szCmdLine, int iCmdShow)
{
    WNDCLASS wc;
    MSG msg;

    thisInstance = hInstance;
    hwndHook = FindWindow(NAME, NAME);
    if (strstr(szCmdLine,"--exit"))
    {
        if (hwndHook)SendMessage(hwndHook, WM_CLOSE, 0, 0);
        return 0;
    };
    if (!(hLib = LoadLibrary("RBHook.dll")))
    {
        MessageBox(NULL, "Error loading RBHook.dll", "RBTray", MB_OK
            | MB_ICONHAND);
        return FALSE;
    }
    if (!RegisterHook(hLib))
    {
        MessageBox(NULL, "Error setting hook procedure", "RBTray", MB_OK | MB_ICONHAND);
        return FALSE;
    }
    wc.hCursor        = NULL;
    wc.hIcon          = NULL;
    wc.lpszMenuName   = NULL;
    wc.lpszClassName  = NAME;
    wc.hbrBackground  = (HBRUSH)(COLOR_WINDOW + 1);
    wc.hInstance      = hInstance;
    wc.style          = 0;
    wc.lpfnWndProc    = HookWndProc;
    wc.cbWndExtra     = sizeof(HWND) + sizeof(HWND);
    wc.cbClsExtra     = 0;
    if (!RegisterClass(&wc))
    {
        MessageBox(NULL,"Error creating window class", "RBTray", MB_OK | MB_ICONHAND);
        return 2;
    }
    if (!(hwndHook = CreateWindow(NAME, NAME,
            WS_WINDOW_STYLE,
            0, 0, 0, 0,
            (HWND) NULL,
            (HMENU) NULL,
            (HINSTANCE)hInstance,
            (LPVOID) NULL)))
    {
        MessageBox(NULL, "Error creating window", "RBTray", MB_OK);
        return 3;
    }
    EnumWindows((WNDENUMPROC)UpdMenu,TRUE);
    while (IsWindow(hwndHook) && GetMessage(&msg, hwndHook, 0, 0))
    {
        TranslateMessage(&msg);
        DispatchMessage(&msg);
    }
    return 0;
}
