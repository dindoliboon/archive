unit frm_main;

interface

uses
    Windows, Messages, SysUtils, Menus, StdCtrls, Controls, ExtCtrls, Classes, Forms;

type
    TfrmNodCF = class(TForm)
    mnuMain: TMainMenu;
    MainMenu1: TMenuItem;
    mnuExit: TMenuItem;
    mnuN1: TMenuItem;
    mnuAbout: TMenuItem;
    labInput: TLabel;
    labOutput: TLabel;
    txtInput: TEdit;
    pnlMenu: TPanel;
    txtOutput: TEdit;
    pnlConvert: TPanel;
    cmdConvert: TButton;
    procedure mnuAboutClick(Sender: TObject);
    procedure mnuExitClick(Sender: TObject);
    procedure txtInputChange(Sender: TObject);
    procedure cmdConvertClick(Sender: TObject);
    private
    { Private declarations }
    public
    { Public declarations }
end;

var
    frmNodCF: TfrmNodCF;

implementation

{$R *.DFM}

{Applies the return key values to a string}
function EnterKey:string;
begin
    result := Chr(13) + Chr(10);
end;

{Shows about message}
procedure TfrmNodCF.mnuAboutClick(Sender: TObject);
begin
    Application.MessageBox(PChar('Allows you to convert ASCII strings into its chr value.' + EnterKey + 'Re-coded in Delphi.' + EnterKey + EnterKey + 'Trunks - http://tks.cjb.net'), 'About Nod Chr Finder v3.1', 64);
end;

{Exits program}
procedure TfrmNodCF.mnuExitClick(Sender: TObject);
begin
    Halt;
end;

{Enables/Disables Convert control}
procedure TfrmNodCF.txtInputChange(Sender: TObject);
begin
    if Length(txtInput.Text) <> 0 then
        cmdConvert.Enabled := True
    else
        cmdConvert.Enabled := False;
end;

{Converts ASCII strings into CHR code}
procedure TfrmNodCF.cmdConvertClick(Sender: TObject);
var
    txtLen : longint;
    strCvt : string;
begin
    for txtLen := 1 to Length(txtInput.Text) do
    begin
        strCvt := strCvt + 'Chr(' + IntToStr(Ord(VarToStr(Variant((Copy(txtInput.Text, txtLen, 1))))[1])) + ')' + ' + ';
    end;
    strCvt := Variant((Trim(strCvt)));
    strCvt := Variant((Copy(strCvt, 1, Length(strCvt) - 2)));
    txtOutput.Text := strCvt;
    txtOutput.SetFocus;
end;

end.
