#define _WIN32_WINNT 0x500
#define WIN32 1

#include <windows.h>
#include <stdio.h>

#define TRANSX_MAX_WINDOWTEXT_LENGTH 256
#define TRANSX_DEFAULT_ALPHA 192

#define TRANSX_TRANS 1
#define TRANSX_NOTRANS 2
#define TRANSX_TOPMOST 4
#define TRANSX_NOTOPMOST 8

int nFlags;
int nAlpha;
char* cWndName;

BOOL CALLBACK EnumProc(HWND hWnd, LPARAM lParam)
{
	char wndtitle[TRANSX_MAX_WINDOWTEXT_LENGTH];
	HWND hDesktop = GetDesktopWindow();
	RECT rcDesktop, rcThis;
	GetClientRect(hDesktop, &rcDesktop);
	GetClientRect(hWnd, &rcThis);

	if (cWndName != NULL)
	{
		GetWindowText(hWnd, wndtitle, TRANSX_MAX_WINDOWTEXT_LENGTH);
		if (strstr(_strlwr(wndtitle), _strlwr(cWndName)) == NULL) return TRUE;
		// For specific windows, make them topmost/non-topmost as well!
		if (nFlags & TRANSX_NOTOPMOST)
		{
			SetWindowPos(hWnd, HWND_NOTOPMOST, 0, 0, 0, 0, SWP_NOMOVE | SWP_NOSIZE);
		}
		else if (nFlags & TRANSX_TOPMOST)
		{
			SetWindowPos(hWnd, HWND_TOPMOST, 0, 0, 0, 0, SWP_NOMOVE | SWP_NOSIZE);
		}
	}

	if (nFlags & TRANSX_NOTRANS)
	{ 
		// turn off
		DWORD dwLong = GetWindowLong(hWnd, GWL_EXSTYLE);
		SetWindowLong(hWnd, GWL_EXSTYLE, dwLong & ~WS_EX_LAYERED);
	} else if (nFlags & TRANSX_TRANS)
	{
		if (rcThis.right < rcDesktop.right || rcThis.bottom < rcDesktop.bottom)
		{
			// turn on
			DWORD dwLong = GetWindowLong(hWnd, GWL_EXSTYLE);
			SetWindowLong(hWnd, GWL_EXSTYLE, dwLong | WS_EX_LAYERED);
			SetLayeredWindowAttributes(hWnd, RGB(0,0,0), nAlpha, LWA_ALPHA);

		};
	};

	return TRUE;
}

int main(int argc, char **argv)
{
	if (argc < 2)
	{
		printf("Usage:\n\ntransx [<windowname> | all] [-notrans] [-top | -notop][-alphaxxx]\n\n");
		printf("where:\n\t<windowname> => Title of a specific window to change, or \"all\" for all.\n");
    		printf("\t-notrans => Remove transparency from the window\n");
    		printf("\t-top => Make the window topmost (only works for specific windows)\n");
    		printf("\t-notop => Remove \"topmost\" from specific window\n");
    		printf("\t-alphaxxx => Sets the alpha blend level to xxx\n\n");

		printf("e.g.:\n\ttransx notepad -top -alpha128\n\ttransx notepad -notop\n\ttransx all -alpha92\n\ttransx notepad -notrans\n");
		printf("\nTransX 1.1 - originally by Steve Tibbett, with improvements by Chris Smith.\n");
		printf("Only works with Windows 2000 - Email comments to stevex@home.com.\n");
		exit(1);
	};

	nAlpha = TRANSX_DEFAULT_ALPHA;
	nFlags = 0;
	for (int n = 1; n < argc; n++)
	{
		if (strcmpi(argv[n], "-top") == 0) nFlags += TRANSX_TOPMOST;
		if (strcmpi(argv[n], "-notop") == 0) nFlags += TRANSX_NOTOPMOST;
		if (strcmpi(argv[n], "-notrans") == 0) nFlags += TRANSX_NOTRANS;
		if (strstr(strlwr(argv[n]), "-alpha") != NULL)
			nAlpha = strtoul(&argv[n][6], NULL, 0);
	}

	if (!(nFlags & TRANSX_NOTRANS)) nFlags = TRANSX_TRANS;

	if (argc == 1) cWndName = NULL;
	if (argc > 1)
	{
		if (strcmpi(argv[1], "all") == 0) cWndName = NULL;
		else cWndName = argv[1];
	}
	EnumWindows(EnumProc, 0);
	return 0;
}
