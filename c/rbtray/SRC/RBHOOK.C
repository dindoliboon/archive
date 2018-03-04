#include <windows.h>
#include "rbtray.h"

static HHOOK hMouse=NULL,
//             hCall =NULL,
             hMsg  =NULL;
static HWND  LastHit;

LRESULT CALLBACK
MouseProc(int nCode, WPARAM wParam, LPARAM lParam)
{
	if (nCode<0)return CallNextHookEx(hMouse, nCode, wParam, lParam);
	if (wParam == WM_NCRBUTTONDOWN
    	&& ((MOUSEHOOKSTRUCT*)lParam)->wHitTestCode == HTREDUCE)
	{
		LastHit=((MOUSEHOOKSTRUCT*)lParam)->hwnd;
	};
	if (wParam == WM_NCRBUTTONUP && LastHit==((MOUSEHOOKSTRUCT*)lParam)->hwnd
		&& ((MOUSEHOOKSTRUCT*)lParam)->wHitTestCode == HTREDUCE)
	{
		LastHit=(HWND)NULL;
		PostMessage(FindWindow(NAME, NAME), WM_MYCMD, IDM_TRAY,
			(LPARAM)(((MOUSEHOOKSTRUCT*)lParam)->hwnd));
	}
	return CallNextHookEx(hMouse, nCode, wParam, lParam);
};

LRESULT CALLBACK
GetMsgProc(int nCode, WPARAM wParam, LPARAM lParam)
{
	int i;
	HMENU hSysMenu;
    if (nCode<0)return CallNextHookEx(hMsg, nCode, wParam, lParam);
	if (((MSG*)lParam)->message==WM_SYSCOMMAND   &&
		(LOWORD(((MSG*)lParam)->wParam) == IDM_TRAY ||
         LOWORD(((MSG*)lParam)->wParam) == IDM_ONTOP))
	{
		PostMessage(FindWindow(NAME, NAME), WM_MYCMD,((MSG*)lParam)->wParam,(LPARAM)(((MSG*)lParam)->hwnd));
	};
	if (((MSG*)lParam)->message==WM_PAINT)
	{
		hSysMenu=GetSystemMenu(((MSG*)lParam)->hwnd, FALSE);
		for(i=0;i<GetMenuItemCount(hSysMenu) && hSysMenu;i++)
			if(GetMenuItemID(hSysMenu,i)==IDM_TRAY) hSysMenu=0;
		if (hSysMenu)
		{
			InsertMenu (hSysMenu, GetMenuItemID(hSysMenu,0),MF_SEPARATOR,IDM_SEPARATOR, NULL) ;
			if(GetWindowLong(((MSG*)lParam)->hwnd,GWL_EXSTYLE) & WS_EX_TOPMOST)
				InsertMenu (hSysMenu, GetMenuItemID(hSysMenu,0),MF_STRING|MF_CHECKED,IDM_ONTOP, "Always on top");
			else
				InsertMenu (hSysMenu, GetMenuItemID(hSysMenu,0),MF_STRING,IDM_ONTOP, "Always on top");
			InsertMenu (hSysMenu, GetMenuItemID(hSysMenu,0),MF_STRING,IDM_TRAY,  "Minimize in tray");
		}
	};
	return 0;
};
/*LRESULT CALLBACK
CallWndProc(int hCode,WPARAM wParam,LPARAM lParam)
{
    CWPSTRUCT *pcwps;

    pcwps = (CWPSTRUCT*)lParam;

    if (hCode >= 0 && pcwps && pcwps->hwnd && pcwps->message==WM_SHOWWINDOW)
	{
       PostMessage(FindWindow(NAME, NAME),WM_SHOWWINDOW,0,(WPARAM)(pcwps->hwnd));
       return 0;
    }
    return CallNextHookEx(NULL, hCode, wParam, lParam);
}
*/
BOOL DLLIMPORT
RegisterHook(HMODULE hLib)
{
	hMouse = SetWindowsHookEx(WH_MOUSE,     (HOOKPROC)MouseProc,  hLib, 0);
	hMsg   = SetWindowsHookEx(WH_GETMESSAGE,(HOOKPROC)GetMsgProc, hLib, 0);
//	hCall  = SetWindowsHookEx(WH_CALLWNDPROC,(HOOKPROC)CallWndProc, hLib, 0);
	if(hMouse==NULL || hMsg==NULL )//|| hCall==NULL)
	{
		UnRegisterHook();
		return FALSE;
	}
	return TRUE;
}
void DLLIMPORT
UnRegisterHook(void)
{
	if(hMouse)UnhookWindowsHookEx(hMouse);
	if(hMsg)  UnhookWindowsHookEx(hMsg);
//	if(hCall) UnhookWindowsHookEx(hCall);
}
