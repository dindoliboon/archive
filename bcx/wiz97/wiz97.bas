    '
    '
    ' Copyright (c) 1998  Microsoft Corporation
    ' All rights reserved.
    '
    ' Module Name:Wiz97
    '
    '

    CONST IDS_TITLE1      =  1
    CONST IDS_SUBTITLE1   =  2
    CONST IDS_TITLE2      =  3
    CONST IDS_SUBTITLE2   =  4
    CONST IDS_CAPTION     =  5
    CONST IDB_BANNER      =  102
    CONST IDB_WATERMARK   =  103
    CONST IDD_INTRO       =  107
    CONST IDD_INTERIOR1   =  108
    CONST IDD_INTERIOR2   =  109
    CONST IDD_END         =  110
    CONST IDC_TITLE       =  1000
    CONST IDC_INTRO_TEXT  =  1001
    CONST IDC_RADIO1      =  1002
    CONST IDC_RADIO2      =  1003
    CONST IDC_RADIO3      =  1004
    CONST IDC_EDIT2       =  1006
    CONST IDC_EDIT3       =  1007
    CONST IDC_EDIT4       =  1008
    CONST IDC_CHECK1      =  1010
    CONST IDC_GROUP1      =  1011

    '----- New flags for wizard97 --------------
    CONST PSP_HIDEHEADER        = 0x00000800
    CONST PSP_USEHEADERTITLE    = 0x00001000
    CONST PSP_USEHEADERSUBTITLE = 0x00002000
    CONST PSH_WIZARD97          = 0x01000000
    CONST PSH_WATERMARK         = 0x00008000
    CONST PSH_HEADER            = 0x00080000
    '-------------------------------------------

    '--- wiz97.h ---
    CONST LASTPAGE = 3 'index of the last page

    !typedef struct SHAREDWIZDATA {
    !    HFONT hTitleFont; //The title font for the Welcome and Completion pages
    !    BOOL IsBoxChecked; //The state of the first interior page's check box
    !    BOOL IsButtonClicked; //The state of the first interior page's group box
    !    //other shared data added here
    !} SHAREDWIZDATA, *LPSHAREDWIZDATA;


    '--- wiz97.cpp ---
FUNCTION WinMain                _
(                               _
    hInstance AS HINSTANCE,     _
    hPrevInstance AS HINSTANCE, _
    lpszCmdLine AS LPSTR,       _
    nCmdShow AS INT             _
)

    !    PROPSHEETPAGE   psp =       {0}; //defines the property sheet pages
    !    HPROPSHEETPAGE  ahpsp[4] =  {0}; //an array to hold the page's HPROPSHEETPAGE handles
    !    PROPSHEETHEADER psh =       {0}; //defines the property sheet
    !    SHAREDWIZDATA wizdata =     {0}; //the shared data structure

    '
    'Create the Wizard pages
    '

    'Opening page
    psp.dwSize =        sizeof(psp)
    psp.dwFlags =       PSP_DEFAULT|PSP_HIDEHEADER
    psp.hInstance =     hInstance
    psp.lParam =        (LPARAM) &wizdata 'The shared data structure
    psp.pfnDlgProc =    IntroDlgProc
    psp.pszTemplate =   MAKEINTRESOURCE(IDD_INTRO)
    ahpsp[0] =          CreatePropertySheetPage(&psp)

    'First interior page
    psp.dwFlags =           PSP_DEFAULT|PSP_USEHEADERTITLE|PSP_USEHEADERSUBTITLE
    psp.pszHeaderTitle =    MAKEINTRESOURCE(IDS_TITLE1)
    psp.pszHeaderSubTitle = MAKEINTRESOURCE(IDS_SUBTITLE1)
    psp.pszTemplate =       MAKEINTRESOURCE(IDD_INTERIOR1)
    psp.pfnDlgProc =        IntPage1DlgProc
    ahpsp[1] =              CreatePropertySheetPage(&psp)

    'Second interior page
    psp.dwFlags =           PSP_DEFAULT|PSP_USEHEADERTITLE|PSP_USEHEADERSUBTITLE
    psp.pszHeaderTitle =    MAKEINTRESOURCE(IDS_TITLE2)
    psp.pszHeaderSubTitle = MAKEINTRESOURCE(IDS_SUBTITLE2)
    psp.pszTemplate =       MAKEINTRESOURCE(IDD_INTERIOR2)
    psp.pfnDlgProc =        IntPage2DlgProc
    ahpsp[2] =              CreatePropertySheetPage(&psp)

    'Final page
    psp.dwFlags =       PSP_DEFAULT|PSP_HIDEHEADER
    psp.pszTemplate =   MAKEINTRESOURCE(IDD_END)
    psp.pfnDlgProc =    EndDlgProc
    ahpsp[3] =          CreatePropertySheetPage(&psp)

    'Create the property sheet
    psh.dwSize =            sizeof(psh)
    psh.hInstance =         hInstance
    psh.hwndParent =        NULL
    psh.phpage =            ahpsp
    psh.dwFlags =           PSH_WIZARD97|PSH_WATERMARK|PSH_HEADER
    psh.pszbmWatermark =    MAKEINTRESOURCE(IDB_WATERMARK)
    psh.pszbmHeader =       MAKEINTRESOURCE(IDB_BANNER)
    psh.nStartPage =        0
    psh.nPages =            4

    'Set up the font for the titles on the intro and ending pages
    ! NONCLIENTMETRICS ncm = {0};
    ncm.cbSize = sizeof(ncm)
    SystemParametersInfo(SPI_GETNONCLIENTMETRICS, 0, &ncm, 0)

    'Create the intro/end title font
    ! LOGFONT TitleLogFont = ncm.lfMessageFont;
    TitleLogFont.lfWeight = FW_BOLD
    lstrcpy(TitleLogFont.lfFaceName, TEXT("Verdana Bold"))

    ! HDC hdc = GetDC(NULL); //gets the screen DC
    ! INT FontSize = 12;
    TitleLogFont.lfHeight = 0 - GetDeviceCaps(hdc, LOGPIXELSY) * FontSize / 72
    wizdata.hTitleFont = CreateFontIndirect(&TitleLogFont)
    ReleaseDC(NULL, hdc)

    'Display the wizard
    PropertySheet(&psh)

    ' Destroy the fonts
    DeleteObject(wizdata.hTitleFont)

    FUNCTION = 0
END FUNCTION



FUNCTION IntroDlgProc  _
(                      _
    hwndDlg AS HWND,   _
    uMsg    AS UINT,   _
    wParam  AS WPARAM, _
    lParam  AS LPARAM  _
) AS BOOL CALLBACK

    'Process messages from the Welcome page

    'Retrieve the shared user data from GWL_USERDATA

    ! LPSHAREDWIZDATA pdata = (LPSHAREDWIZDATA) GetWindowLong(hwndDlg, GWL_USERDATA);

    SELECT CASE uMsg
        CASE WM_INITDIALOG
        'Get the shared data from PROPSHEETPAGE lParam value
        'and load it into GWL_USERDATA

        pdata = (LPSHAREDWIZDATA) ((LPPROPSHEETPAGE) lParam) -> lParam

        SetWindowLong(hwndDlg, GWL_USERDATA, (DWORD_PTR) pdata)

        'It's an intro/end page, so get the title font
        'from  the shared data and use it for the title control

        ! HWND hwndControl = GetDlgItem(hwndDlg, IDC_TITLE);
        SetWindowFont(hwndControl,pdata->hTitleFont, TRUE)
        CASE WM_NOTIFY
        ! LPNMHDR lpnm = (LPNMHDR) lParam;
        SELECT CASE (lpnm->code)
            CASE PSN_SETACTIVE  'Enable the Next button
            PropSheet_SetWizButtons(GetParent(hwndDlg), PSWIZB_NEXT)
            CASE PSN_WIZNEXT
            'Handle a Next button click here
            CASE PSN_RESET
            'Handle a Cancel button click, IF necessary
        END SELECT
    END SELECT

    FUNCTION = 0
END FUNCTION



FUNCTION IntPage1DlgProc _
(                      _
    hwndDlg AS HWND,   _
    uMsg    AS UINT,   _
    wParam  AS WPARAM, _
    lParam  AS LPARAM  _
) AS BOOL CALLBACK

    'Process messages from the first interior page

    'Retrieve the shared user data from GWL_USERDATA

    ! LPSHAREDWIZDATA pdata = (LPSHAREDWIZDATA) GetWindowLong(hwndDlg, GWL_USERDATA);

    SELECT CASE uMsg
        CASE WM_INITDIALOG
        'Get the PROPSHEETPAGE lParam value and load it into
        'DWL_USERDATA

        pdata = (LPSHAREDWIZDATA) ((LPPROPSHEETPAGE) lParam) -> lParam
        SetWindowLong(hwndDlg, GWL_USERDATA, (DWORD_PTR) pdata)
        CASE WM_COMMAND
        SELECT CASE LOWORD (wParam)
            CASE IDC_CHECK1
            pdata->IsBoxChecked = !(pdata->IsBoxChecked)
            CASE IDC_RADIO1
            pdata->IsButtonClicked = TRUE
            CASE IDC_RADIO2
            pdata->IsButtonClicked = TRUE
            CASE IDC_RADIO3
            pdata->IsButtonClicked = TRUE
        END SELECT

        'If any of the radio buttons are clicked, or the
        'checkbox checked, enable the Next button

        IF pdata->IsBoxChecked OR pdata->IsButtonClicked THEN
            PropSheet_SetWizButtons(GetParent(hwndDlg), PSWIZB_BACK | PSWIZB_NEXT)
        else 'otherwise, only enable the Back button
            PropSheet_SetWizButtons(GetParent(hwndDlg), PSWIZB_BACK)
        END IF

        CASE WM_NOTIFY
        ! LPNMHDR lpnm = (LPNMHDR) lParam;
        SELECT CASE (lpnm->code)
            CASE PSN_SETACTIVE  'Enable the appropriate buttons
            'If a radio button has been clicked or the
            'checkbox checked, enable Back and Next
            if(pdata->IsBoxChecked OR pdata->IsButtonClicked) then
            PropSheet_SetWizButtons(GetParent(hwndDlg), PSWIZB_BACK | PSWIZB_NEXT)
        else 'Otherwise, only enable Back
            PropSheet_SetWizButtons(GetParent(hwndDlg), PSWIZB_BACK)
        END IF
        CASE PSN_WIZNEXT
        'If the checkbox is checked, jump to the final page

        if(pdata->IsBoxChecked) then
        SetWindowLong(hwndDlg, DWL_MSGRESULT, IDD_END)
        FUNCTION = TRUE
    END IF
    CASE PSN_WIZBACK
    'Handle a Back button click, IF necessary
    CASE PSN_RESET
    'Handle a Cancel button click, IF necessary
    END SELECT
    END SELECT

    FUNCTION = 0
END FUNCTION



FUNCTION IntPage2DlgProc _
(                      _
    hwndDlg AS HWND,   _
    uMsg    AS UINT,   _
    wParam  AS WPARAM, _
    lParam  AS LPARAM  _
) AS BOOL CALLBACK

    'Process messages from the second interior page

    'Retrieve the shared user data from GWL_USERDATA

    ! LPSHAREDWIZDATA pdata = (LPSHAREDWIZDATA) GetWindowLong(hwndDlg, GWL_USERDATA);

    SELECT CASE uMsg
        CASE WM_INITDIALOG
        'Get the PROPSHEETPAGE lParam value and load it into
        'DWL_USERDATA

        pdata = (LPSHAREDWIZDATA) ((LPPROPSHEETPAGE) lParam) -> lParam
        SetWindowLong(hwndDlg, GWL_USERDATA, (DWORD_PTR) pdata)
        CASE WM_NOTIFY
        ! LPNMHDR lpnm = (LPNMHDR) lParam;
        SELECT CASE (lpnm->code)
            CASE PSN_SETACTIVE 'Enable the Next and Back buttons
            PropSheet_SetWizButtons(GetParent(hwndDlg), PSWIZB_BACK | PSWIZB_NEXT)
            CASE PSN_WIZNEXT
            'Handle a Next button click, IF necessary
            CASE PSN_WIZBACK
            'Handle a Back button click, IF necessary
            CASE PSN_RESET
            'Handle a Cancel button click, IF necessary
        END SELECT
    END SELECT

    FUNCTION = 0
END FUNCTION



FUNCTION EndDlgProc _
(                      _
    hwndDlg AS HWND,   _
    uMsg    AS UINT,   _
    wParam  AS WPARAM, _
    lParam  AS LPARAM  _
) AS BOOL CALLBACK


    'Process messages from the Completion page

    'Retrieve the shared user data from GWL_USERDATA

    ! LPSHAREDWIZDATA pdata = (LPSHAREDWIZDATA) GetWindowLong(hwndDlg, GWL_USERDATA);

    SELECT CASE (uMsg)
        CASE WM_INITDIALOG
        'Get the shared data from PROPSHEETPAGE lParam value
        'and load it into GWL_USERDATA

        pdata = (LPSHAREDWIZDATA) ((LPPROPSHEETPAGE) lParam) -> lParam
        SetWindowLong(hwndDlg, GWL_USERDATA, (DWORD_PTR) pdata)

        'It's an intro/end page, so get the title font
        'from  userdata and use it on the title control

        ! HWND hwndControl = GetDlgItem(hwndDlg, IDC_TITLE);
        SetWindowFont(hwndControl,pdata->hTitleFont, TRUE)
        CASE WM_NOTIFY
        ! LPNMHDR lpnm = (LPNMHDR) lParam;
        SELECT CASE (lpnm->code)
            CASE PSN_SETACTIVE  'Enable the correct buttons on for the active page

            PropSheet_SetWizButtons(GetParent(hwndDlg), PSWIZB_BACK | PSWIZB_FINISH)
            CASE PSN_WIZBACK

            'If the checkbox was checked, jump back
            'to the first interior page, not the second
            if(pdata->IsBoxChecked) then
            SetWindowLong(hwndDlg, DWL_MSGRESULT, IDD_INTERIOR1)
            FUNCTION =  TRUE
        END IF
        CASE PSN_WIZFINISH
        'Handle a Finish button click, IF necessary
        CASE PSN_RESET
        'Handle a Cancel button click, IF necessary
    END SELECT
    END SELECT

    FUNCTION = 0
END FUNCTION
