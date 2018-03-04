; #########################################################################

    !packhdr             tmp.dat "cleanup.bat"
    SetDateSave          on
    SetDatablockOptimize on
    CRCCheck             on
    Name                 "D-Color"
    OutFile              "setup.exe"
    Icon                 "setup.ico"
    EnabledBitmap        "c1.bmp"
    DisabledBitmap       "c2.bmp"
    ShowInstDetails      show
    InstallDir           "$PROGRAMFILES\DL Software\D-Color"
    InstallDirRegKey     HKCU "Software\DL Software\D-Color" "Install_Dir"

; #########################################################################

    ComponentText "Welcome to the NSIS program. Please choose the options that you would like to have installed on your system."
    DirText       "Setup will install D-Color in the following folder. To install to this folder, click Next. To install to a different folder, click Browse and select another folder."

; #########################################################################

Section "D-Color Software (required)"
    SetOutPath $INSTDIR

    File       "dcolor.dll"
    File       "dcolor.exe"

    WriteRegStr HKCU "Software\DL Software\D-Color" "Install_Dir" "$INSTDIR"
    WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\D-Color" "DisplayName" "D-Color 1.0 (remove only)"
    WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\D-Color" "UninstallString" '"$INSTDIR\uninstall.exe"'
SectionEnd

; #########################################################################

Section "D-Color Help Files"
    SetOutPath "$INSTDIR\Help"

    File       "tray.gif"
    File       "after.gif"
    File       "before.gif"
    File       "details.gif"
    File       "menu.gif"
    File       "panel.gif"
    File       "index.htm"
SectionEnd

; #########################################################################

Section "Add to Start Menu"
    SetOutPath      "$INSTDIR"
    CreateDirectory "$SMPROGRAMS\DL Software\D-Color"
    CreateShortCut  "$SMPROGRAMS\DL Software\D-Color\D-Color.lnk" "$INSTDIR\dcolor.exe" "" "$INSTDIR\dcolor.exe" 0
    CreateShortCut  "$SMPROGRAMS\DL Software\D-Color\Uninstall.lnk" "$INSTDIR\uninstall.exe" "" "$INSTDIR\uninstall.exe" 0
SectionEnd

; #########################################################################

    UninstallText    "This will remove D-Color from your system. If you do not want to continue, click Cancel."
    UninstallExeName "uninstall.exe"

; #########################################################################

Section "Uninstall"
    DeleteRegKey   HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\D-Color"
    DeleteRegKey   HKCU "Software\DL Software\D-Color"
    DeleteRegValue HKCU "Software\Microsoft\Windows\CurrentVersion\Run" "D-Color"

    Delete "$INSTDIR\Help\tray.gif"
    Delete "$INSTDIR\Help\after.gif"
    Delete "$INSTDIR\Help\before.gif"
    Delete "$INSTDIR\Help\details.gif"
    Delete "$INSTDIR\Help\menu.gif"
    Delete "$INSTDIR\Help\panel.gif"
    Delete "$INSTDIR\Help\index.htm"
    Delete "$INSTDIR\dcolor.exe"
    Delete "$INSTDIR\dcolor.dll"
    Delete "$INSTDIR\uninstall.exe"
    Delete "$SMPROGRAMS\DL Software\D-Color\*.*"

    RMDir "$SMPROGRAMS\DL Software\D-Color"
    RMDir "$SMPROGRAMS\DL Software"
    RMDir "$INSTDIR\Help"
    RMDir "$INSTDIR"
SectionEnd

; #########################################################################
