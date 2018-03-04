program tks_gret;

uses
    Forms,
    frm_main in 'frm_main.pas' {frmGreets};

{$R *.RES}

begin
    Application.Initialize;
    Application.Title := 'Greetings';
    Application.CreateForm(TfrmGreets, frmGreets);
    Application.Run;
end.
