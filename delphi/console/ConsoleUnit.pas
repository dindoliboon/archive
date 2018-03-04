unit ConsoleUnit;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, ConsoleApp;

type
  TConsoleForm = class(TForm)
    Output: TListBox;
    Panel1: TPanel;
    AppNameLabel: TLabel;
    AppNameEdit: TEdit;
    BrowseButton: TButton;
    RunButton: TButton;
    BrowseDlg: TOpenDialog;
    ExeInfoBUtton: TButton;
    Label1: TLabel;
    InfoLabel: TLabel;
    ParametersLabel: TLabel;
    ParametersEdit: TEdit;
    ExitButton: TButton;
    procedure RunButtonClick(Sender: TObject);
    procedure BrowseButtonClick(Sender: TObject);
    procedure ExeInfoBUttonClick(Sender: TObject);
    procedure ExitButtonClick(Sender: TObject);
  private
    procedure RunningUpdate(Sender: TObject);
  public
    { Public declarations }
  end;

var
  ConsoleForm: TConsoleForm;

implementation


{$R *.DFM}

procedure TConsoleForm.RunButtonClick(Sender: TObject);
var
  s: String;
  CAExitCode: Integer;
begin
  s:= AppNameEdit.Text;
  Output.Items.Clear;
  Output.Items.Add('Executing ' + s);
  CAExitCode:= ExecConsoleApp(s, ParametersEdit.Text, Output.Items, RunningUpdate);
  Output.Items.Add(Format('%s returned %d', [s, CAExitCode]))
end;

procedure TConsoleForm.RunningUpdate(Sender: TObject);
begin
  Output.Update  {flush paint messages to show progress}
end;

procedure TConsoleForm.BrowseButtonClick(Sender: TObject);
begin
  if BrowseDlg.Execute then
    AppNameEdit.Text:= BrowseDlg.Filename
end;

function TranslateExeInfo(BinaryType, Subsystem: DWORD): String;
begin
  case BinaryType of
    SCS_32BIT_BINARY:
    begin
      Result:= 'SCS_32BIT_BINARY';
      case Subsystem of
        IMAGE_SUBSYSTEM_UNKNOWN: Result:= Result + ' (IMAGE_SUBSYSTEM_UNKNOWN)';
        IMAGE_SUBSYSTEM_NATIVE: Result:= Result + ' (IMAGE_SUBSYSTEM_NATIVE)';
        IMAGE_SUBSYSTEM_WINDOWS_GUI: Result:= Result + ' (IMAGE_SUBSYSTEM_WINDOWS_GUI)';
        IMAGE_SUBSYSTEM_WINDOWS_CUI: Result:= Result + ' (IMAGE_SUBSYSTEM_WINDOWS_CUI)';
        IMAGE_SUBSYSTEM_OS2_CUI: Result:= Result + ' (IMAGE_SUBSYSTEM_OS2_CUI)';
        IMAGE_SUBSYSTEM_POSIX_CUI: Result:= Result + ' (IMAGE_SUBSYSTEM_POSIX_CUI)';
        IMAGE_SUBSYSTEM_RESERVED8: Result:= Result + ' (IMAGE_SUBSYSTEM_RESERVED8)';
      end;
    end;
    SCS_DOS_BINARY: Result:= 'SCS_DOS_BINARY';
    SCS_WOW_BINARY: Result:= 'SCS_WOW_BINARY';
    SCS_PIF_BINARY: Result:= 'SCS_PIF_BINARY';
    SCS_POSIX_BINARY: Result:= 'SCS_POSIX_BINARY';
    SCS_OS216_BINARY: Result:= 'SCS_OS216_BINARY';
    SCS_VXD_BINARY: Result:= 'SCS_VXD_BINARY';
    SCS_WIN32_DLL: Result:= 'SCS_WIN32_DLL';
    SCS_DPMI_BINARY: Result:= 'SCS_DPMI_BINARY';
  else
    Result:= 'unknown binary';
  end
end;


procedure TConsoleForm.ExeInfoBUttonClick(Sender: TObject);
var
  bt, sst: DWORD;
begin
  GetExecutableInfo(AppNameEdit.Text, bt, sst);
  InfoLabel.Caption:= TranslateExeInfo(bt, sst)
end;

procedure TConsoleForm.ExitButtonClick(Sender: TObject);
begin
  Close
end;

end.

