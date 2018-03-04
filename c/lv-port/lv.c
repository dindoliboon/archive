#include <windows.h>
#include <shellapi.h>

HINSTANCE hInstance;
HWND      Form1;
HWND      Canvas1;
HWND      Static1;
char     *szClass1 = "loview_class";
char     *szClass2 = "canvas_class";
BOOLEAN   bOnTop;
BOOLEAN   bFullScreen;
COLORREF  clrSecond;
COLORREF  bg;
HBITMAP   hBitmap;
int       speed = 15;
int       counter;
int       position;
char      szFile[256];

int WINAPI WinMain(HINSTANCE, HINSTANCE, LPSTR, int);
LRESULT CALLBACK Form1Proc(HWND, UINT, WPARAM, LPARAM);
LRESULT CALLBACK Canvas1Proc(HWND, UINT, WPARAM, LPARAM);
void Form1_Load(HINSTANCE);
void CenterWindow(HWND);
BOOLEAN ValidateBmp(char *);
void OpenBmp(char *);
void AnimateGradient(void);
void AnimateProgress(void);
void UpdateProgress(void);
void FullScreen(int bDoFullScreen);
void DrawMessage(char *);

int WINAPI WinMain(HINSTANCE hInst, HINSTANCE hPrevInst, LPSTR lpCmdLine, int nCmdShow)
{
  WNDCLASS wc;
  MSG      msg;

  hInstance = hInst;

  wc.style         = CS_HREDRAW | CS_VREDRAW | CS_DBLCLKS;
  wc.lpfnWndProc   = Form1Proc;
  wc.cbClsExtra    = 0;
  wc.cbWndExtra    = 0;
  wc.hInstance     = hInst;
  wc.hIcon         = LoadIcon(hInst, MAKEINTRESOURCE(100));
  wc.hCursor       = LoadCursor(NULL, IDC_ARROW);
  wc.hbrBackground = CreateSolidBrush(RGB(0, 0, 0));
  wc.lpszMenuName  = NULL;
  wc.lpszClassName = szClass1;
  RegisterClass(&wc);

  wc.style         = CS_HREDRAW | CS_VREDRAW | CS_DBLCLKS;
  wc.lpfnWndProc   = Canvas1Proc;
  wc.cbClsExtra    = 0;
  wc.cbWndExtra    = 0;
  wc.hInstance     = hInst;
  wc.hIcon         = NULL;
  wc.hCursor       = LoadCursor(NULL, IDC_SIZEALL);
  wc.hbrBackground = CreateSolidBrush(RGB(0, 0, 0));
  wc.lpszMenuName  = NULL;
  wc.lpszClassName = szClass2;
  RegisterClass(&wc);

  Form1_Load(hInst);

  while (GetMessage(&msg, NULL, 0, 0))
  {
    if (!IsWindow(GetActiveWindow()) | !IsDialogMessage(GetActiveWindow(), &msg))
    {
      TranslateMessage(&msg);
      DispatchMessage(&msg);
    }
  }

  return msg.wParam;
}

void Form1_Load(HINSTANCE hInst)
{
  Form1   = CreateWindow(szClass1, "Windows 2000 Logo Viewer", DS_MODALFRAME | WS_MINIMIZEBOX | WS_MAXIMIZEBOX | WS_POPUP | WS_CAPTION | WS_SYSMENU | WS_THICKFRAME | WS_CLIPCHILDREN, 0, 0, 350, 300, NULL, NULL, hInst, NULL);
  Canvas1 = CreateWindow(szClass2, "", WS_CHILD, 0, 0, 640, 480, Form1, NULL, hInst, NULL);
  Static1 = CreateWindow("static", "", WS_CHILD, 0, 0, 2096, 2096, Form1, NULL, hInst, NULL);

  DragAcceptFiles(Form1, TRUE);

  OpenBmp("help.bmp");
  UpdateWindow(Form1);

  CenterWindow(Form1);

  ShowWindow(Form1, SW_SHOWNORMAL);
}

LRESULT CALLBACK Form1Proc(HWND hwnd, UINT uMsg, WPARAM wParam, LPARAM lParam)
{
  static RECT rc;

  switch(uMsg)
  {
  case WM_COMMAND:
    switch (LOWORD(wParam))
    {
    case 2:
      speed += 1;
      break;

    case 3:
      if (speed < 1)
        speed = 0;
      else
        speed -= 1;
      break;

    case 4:
      speed = 15;
    }
    break;

  case WM_TIMER:
    if (!hBitmap) break;

    AnimateGradient();
    UpdateProgress();
    AnimateProgress();
    break;

  case WM_DROPFILES:
    DragQueryFile((HDROP)wParam, 0, szFile, 2047);
    OpenBmp(szFile);
    break;

  case WM_KEYUP:
    if (!hBitmap) break;

    switch (wParam)
    {
    case VK_ADD:
      SendMessage(Form1, WM_COMMAND, MAKEWPARAM(2, 1), 0);
      break;

    case VK_SUBTRACT:
      SendMessage(Form1, WM_COMMAND, MAKEWPARAM(3, 1), 0);
      break;

    case VK_DIVIDE:
      SendMessage(Form1, WM_COMMAND, MAKEWPARAM(4, 1), 0);
      break;

    case VK_RETURN:
      if (!bFullScreen)
      {
        GetWindowRect(hwnd, &rc);

        SetWindowLong(hwnd, GWL_STYLE, WS_POPUP | WS_VISIBLE | WS_SYSMENU | WS_CLIPCHILDREN);
        SetWindowPos(hwnd, HWND_TOPMOST, 0, 0, GetSystemMetrics(SM_CXSCREEN), GetSystemMetrics(SM_CYSCREEN), SWP_SHOWWINDOW);

        SendMessage(hwnd, WM_LBUTTONDBLCLK, 0, 0);
        ShowCursor(FALSE);
        FullScreen(TRUE);
        bFullScreen = TRUE;
      }
      else
      {
        FullScreen(FALSE);
        SetWindowLong(hwnd, GWL_STYLE, DS_MODALFRAME | WS_MINIMIZEBOX | WS_MAXIMIZEBOX | WS_POPUP | WS_CAPTION | WS_SYSMENU | WS_THICKFRAME | WS_CLIPCHILDREN | WS_VISIBLE);

        if (!bOnTop)
        {
          bOnTop = TRUE;
          SendMessage(hwnd, WM_RBUTTONDOWN, 0, 0);
        }

        SetWindowPos(hwnd, 0, rc.left, rc.top, rc.right - rc.left, rc.bottom - rc.top, SWP_NOZORDER);
        SendMessage(hwnd, WM_LBUTTONDBLCLK, 0, 0);
        ShowCursor(TRUE);
        bFullScreen = FALSE;
      }
    }
    break;

  case WM_RBUTTONDOWN:
    if (bOnTop == TRUE)
    {
      SetWindowPos(Form1, HWND_NOTOPMOST, 0, 0, 0, 0, SWP_NOSIZE | SWP_NOMOVE | SWP_NOACTIVATE);
      bOnTop = FALSE;
    }
    else
    {
      SetWindowPos(Form1, HWND_TOPMOST, 0, 0, 0, 0, SWP_NOSIZE | SWP_NOMOVE | SWP_NOACTIVATE);
      bOnTop = TRUE;
    }
    break;

  case WM_LBUTTONDBLCLK:
    SetWindowPos(Canvas1, 0, 0, 0, 0, 0, SWP_NOSIZE | SWP_NOZORDER);
    break;

  case WM_LBUTTONDOWN:
    ReleaseCapture();
    SendMessage(Canvas1, WM_SYSCOMMAND, SC_MOVE | HTCAPTION, 0);
    break;

  case WM_CLOSE:
    DestroyWindow(hwnd);
    break;

  case WM_DESTROY:
    KillTimer(Form1, 1);
    PostQuitMessage(0);
    break;

  default:
    return DefWindowProc(hwnd, uMsg, wParam, lParam);
  }

  return 0;
}

LRESULT CALLBACK Canvas1Proc(HWND hwnd, UINT uMsg, WPARAM wParam, LPARAM lParam)
{
  HBITMAP     hBitmapOld;
  PAINTSTRUCT ps;
  HDC         hdc;
  HDC         hdcMem;

  switch(uMsg)
  {
  case WM_LBUTTONDOWN:
  case WM_LBUTTONDBLCLK:
  case WM_RBUTTONDOWN:
    SendMessage(Form1, uMsg, 0, 0);
    break;

  case WM_PAINT:
    if (!hBitmap) break;

    hdc        = BeginPaint(hwnd, &ps);
    hdcMem     = CreateCompatibleDC(hdc);
    hBitmapOld = SelectObject(hdcMem, hBitmap);

    BitBlt(hdc, 0, 0, 640, 480, hdcMem, 0, 0, SRCCOPY);

    SelectObject(hdc, hBitmapOld);
    DeleteDC(hdcMem);

    EndPaint(hwnd, &ps);
    break;

  default:
    return DefWindowProc(hwnd, uMsg, wParam, lParam);
  }

  return 0;
}

void CenterWindow(HWND hwnd)
{
  RECT  rc;
  DWORD x;
  DWORD y;

  GetWindowRect(hwnd, &rc);

  x = (GetSystemMetrics(SM_CXSCREEN) - (rc.right - rc.left)) / 2;
  y = (GetSystemMetrics(SM_CYSCREEN) - (rc.bottom - rc.top)) / 2;

  SetWindowPos(hwnd, NULL, x, y, 0, 0, SWP_NOSIZE | SWP_NOZORDER);
}

void OpenBmp(char *szInFile)
{
  RECT rc;
  RECT crc;

  if (hBitmap) DeleteObject(hBitmap);
  hBitmap = NULL;

  if (ValidateBmp(szInFile) == TRUE)
  {
    hBitmap  = (HBITMAP)LoadImage(NULL, szInFile, IMAGE_BITMAP, 0, 0, LR_DEFAULTSIZE | LR_DEFAULTCOLOR | LR_LOADFROMFILE);

    ShowWindow(Static1, SW_HIDE);
    ShowWindow(Canvas1, SW_SHOW);

    GetWindowRect(GetParent(Canvas1), &rc);
    GetClientRect(GetParent(Canvas1), &crc);

    rc.right  = (rc.right  - rc.left) - crc.right;
    rc.bottom = (rc.bottom - rc.top)  - crc.bottom;

    if (rc.left < 0) rc.left = 0;
    if (rc.top  < 0) rc.top = 0;

    SetWindowPos(Form1, 0, rc.left, rc.top, 640 + rc.right, 480 + rc.bottom, SWP_NOACTIVATE | SWP_NOMOVE);
    SetWindowPos(Canvas1, 0, 0, 0, 0, 0, SWP_NOSIZE | SWP_NOZORDER);

    InvalidateRect(Canvas1, NULL, TRUE);
    counter  = 163;
    position = 0 ;
    KillTimer(Form1, 1);
    SetTimer(Form1, 1, 0, NULL);
  }
}

BOOLEAN ValidateBmp(char *szInFile)
{
  BITMAPFILEHEADER bfh;
  BITMAPINFOHEADER bih;
  HFILE            hFile;
  PALETTEENTRY     pe;
  BOOLEAN          bValid;
  char             msg[100];

  *msg   = 0;
  bValid = 0;

  if ((hFile = _lopen(szInFile, OF_READ)) == HFILE_ERROR)
  {
    DrawMessage("File Error: Unable to open file");
    return FALSE;
  }

  if (_lread(hFile, &bfh, sizeof(bfh)) == HFILE_ERROR)
  {
    DrawMessage("File Error: Unable to read file");
    return FALSE;
  }

  if (_lread(hFile, &bih, sizeof(bih)) == HFILE_ERROR)
  {
    DrawMessage("File Error: Unable to read file");
    return FALSE;
  }

  if (_llseek(hFile, 4, FILE_CURRENT) == HFILE_ERROR)
  {
    DrawMessage("File Error: Unable to seek file position");
    return FALSE;
  }

  if (_lread(hFile, &pe, sizeof(pe)) == HFILE_ERROR)
  {
    DrawMessage("File Error: Unable to read file");
    return FALSE;
  }

  if (_lclose(hFile) == HFILE_ERROR) 
  {
    DrawMessage("File Error: Unable to close file");
    return FALSE;
  }

  if (bfh.bfType != 19778)
  {
    DrawMessage("Bitmap Error: Not a valid bitmap");
    return FALSE;
  }

  wsprintf(msg, "%s\n", "Bitmap Error:");

  if (bih.biWidth != 640)
  {
    wsprintf(msg, "%s\n", "Width must be equal to 640 pixels");
    bValid = 1;
  }

  if (bih.biHeight != 480)
  {
    wsprintf(msg, "%s%s\n", msg, "Height must be equal to 480 pixels");
    bValid = 1;
  }

  /* allow viewing of any color depth --
  if (bih.biBitCount != 4)
  {
    wsprintf(msg, "%s%s", msg, "Color depth must be 16 colors");
    bValid = 1;
  }
  -- allow viewing of any color depth */

  if (bValid)
  {
    DrawMessage(msg);
    return FALSE;
  }

  clrSecond = RGB(pe.peBlue, pe.peGreen, pe.peRed);
  return TRUE;
}

void AnimateGradient()
{
  HBITMAP hBitmapOld;
  HDC     hdc;
  HDC     hdcMem;

  hdc        = GetDC(Canvas1);
  hdcMem     = CreateCompatibleDC(hdc);
  hBitmapOld = SelectObject(hdcMem, hBitmap);

  if (position > 640)
    position = 0;
  else
  {
    position += speed;

    BitBlt(hdc, position, 416, 640, 10, hdcMem, 0, 416, SRCCOPY);
    BitBlt(hdc, 0, 416, position, 10, hdcMem, 640 - position, 416, SRCCOPY);
  }

  SelectObject(hdcMem, hBitmapOld);
  DeleteDC(hdcMem);
  ReleaseDC(Canvas1, hdc);
}

void AnimateProgress()
{
  HBRUSH   hBrush;
  LOGBRUSH lb;
  HPEN     hPen;
  HPEN     hPenOld;
  HBRUSH   hBrushOld;
  HBITMAP  hBitmapOld;
  HDC      hdc;
  HDC      hdcMem;

  hdc = GetDC(Canvas1);

  if (counter == 0)
  {
    hdcMem     = CreateCompatibleDC(hdc);
    hBitmapOld = SelectObject(hdcMem, hBitmap);

    BitBlt(hdc, 274, 437, 163, 8, hdcMem, 274, 437, SRCCOPY);

    SelectObject(hdcMem, hBitmapOld);
    DeleteDC(hdcMem);
  }

  if(!(counter % 6))
  {
    hPen = CreatePen(0, 1, clrSecond);

    lb.lbStyle = BS_SOLID;
    lb.lbColor = clrSecond;
    hBrush     = CreateBrushIndirect(&lb);

    hBrushOld = SelectObject(hdc, hBrush);
    hPenOld   = SelectObject(hdc, hPen);

    Rectangle(hdc, 275 + counter, 438, 280 + counter, 444);

    SelectObject(hdc, hBrushOld);
    DeleteObject(hBrush);

    SelectObject(hdc, hPenOld);
    DeleteObject(hPen);
  }

  ReleaseDC(Canvas1, hdc);
}

void DrawMessage(char *szMsg)
{
  ShowWindow(Static1, SW_SHOW);
  ShowWindow(Canvas1, SW_HIDE);

  SetWindowText(Static1, szMsg);
}

void UpdateProgress()
{
  HBITMAP  hBitmapOld;
  HDC      hdc;
  HDC      hdcMem;

  if (counter > 158)
    counter = 0;
  else
    counter++;
}

void FullScreen(int bDoFullScreen)
{
  DEVMODE devmode;
  static DWORD dwWidth;
  static DWORD dwHeight;

  devmode.dmSize = sizeof(DEVMODE);
  EnumDisplaySettings(NULL, ENUM_REGISTRY_SETTINGS, &devmode);

  if (bDoFullScreen)
  {
    dwWidth  = devmode.dmPelsWidth;
    dwHeight = devmode.dmPelsHeight;

    devmode.dmPelsWidth  = 640;
    devmode.dmPelsHeight = 480;
    ChangeDisplaySettings(&devmode, CDS_FULLSCREEN);
  }
  else
  {
    devmode.dmPelsWidth  = dwWidth;
    devmode.dmPelsHeight = dwHeight;

    ChangeDisplaySettings(&devmode, 0);
  }
}
