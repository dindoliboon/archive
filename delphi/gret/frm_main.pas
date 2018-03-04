Unit frm_main;

interface

uses
    Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
    ExtCtrls, StdCtrls;

type
    TfrmGreets = class(TForm)
    imgMain: TImage;
    cmdGreets: TButton;
    cmdExit: TButton;
    labPW: TLabel;
    labZPW: TLabel;
    labEffects: TLabel;
    procedure cmdExitClick(Sender: TObject);
    procedure cmdGreetsClick(Sender: TObject);
    private
    { Private declarations }
    public
    { Public declarations }
end;

var
    frmGreets: TfrmGreets;

implementation

{$R *.DFM}

{Time out - from exit}
procedure TimeOut(timSec:Cardinal);
var nTime: Cardinal;
begin
    nTime := GetTickCount + timSec;
    while (GetTickCount < nTime) and (not Application.Terminated) do
    Application.ProcessMessages;
end;

{Sets the fore-color of a control with a random color}
procedure rColor(clType:TLabel);
begin
    Randomize;
    Case Random (15) of
    1 :clType.Font.Color := clBlack;
    2 :clType.Font.Color := clMaroon;
    3 :clType.Font.Color := clGreen;
    4 :clType.Font.Color := clOlive;
    5 :clType.Font.Color := clNavy;
    6 :clType.Font.Color := clPurple;
    7 :clType.Font.Color := clGray;
    8 :clType.Font.Color := clSilver;
    9 :clType.Font.Color := clRed;
    10:clType.Font.Color := clLime;
    11:clType.Font.Color := clBlue;
    12:clType.Font.Color := clFuchsia;
    13:clType.Font.Color := clAqua;
    14:clType.Font.Color := clWhite;
    15:clType.Font.Color := clTeal;
    end;
end;

{Adds color and font effects to a string}
procedure GreetPerson(xControl:TLabel; strPerson:String; intSec:LongInt);
var
    GetLetters : LongInt;
    SingleLetter : string;
    xSize : LongInt;
begin
    //Clears control
    xControl.caption := '';

    //Gets each character from a word
    for GetLetters := 1 to Length(strPerson) do
    begin
        SingleLetter := Copy(strPerson, GetLetters, 1);
        Rcolor(xControl);
        xControl.caption := xControl.caption + SingleLetter;
        TimeOut(35);
    end;

    //Increases font size
    for xSize := 8 to 24 do
    begin
        Rcolor(xControl);
        xControl.Font.Size := xSize;
        TimeOut(35);
    end;

    //Decreases font size
    repeat
    xSize := xSize - 1;
    Rcolor(xControl);
    xControl.Font.Size := xSize;
    until xSize = 8;

    xControl.Font.Color := clWhite;
    TimeOut(35);

    xControl.Font.Color := clGray;
    TimeOut(35);

    xControl.Font.Color := clSilver;
    TimeOut(35);

    if intSec = 1 then xControl.Caption := '';
        TimeOut(35);
end;

{Exits the program}
procedure TfrmGreets.cmdExitClick(Sender: TObject);
begin
    Halt;
end;

{People to greet}
procedure TfrmGreets.cmdGreetsClick(Sender: TObject);
begin
    cmdGreets.Enabled := False;
    cmdExit.Enabled := False;
    labZPW.Caption := '';

    GreetPerson(labEffects, 'Greets To:', 1);
    TimeOut(25);

    GreetPerson(labEffects, 'Nod Programming, Inc.', 1);
    TimeOut(25);

    GreetPerson(labEffects, 'WeeZ', 1);
    GreetPerson(labEffects, 'Anjel', 1);
    GreetPerson(labEffects, 'Cheese', 1);
    GreetPerson(labEffects, 'MoNKy', 1);
    GreetPerson(labEffects, 'DrAcO', 1);
    GreetPerson(labEffects, 'Sortain', 1);
    GreetPerson(labEffects, 'Terrax', 1);
    GreetPerson(labEffects, 'Trunks', 1);
    GreetPerson(labEffects, 'A.D.', 1);
    GreetPerson(labEffects, 'MULEHERD', 1);
    TimeOut(25);

    GreetPerson(labEffects, 'Visit us at:', 1);
    GreetPerson(labEffects, 'http://come.to/NodProgrammingInc', 2);
    GreetPerson(labZPW, 'Greetings to NOD!', 2);
    cmdGreets.Enabled := True;
    cmdExit.Enabled := True;
end;

end.
