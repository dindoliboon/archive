program tks_ncf3;

uses
    Forms,
    frm_main in 'frm_main.pas' {frmNodCF};

{$R *.RES}

begin
    Application.Initialize;
    Application.Title := 'Nod CF v3.0d';
    Application.CreateForm(TfrmNodCF, frmNodCF);
    Application.Run;
end.
