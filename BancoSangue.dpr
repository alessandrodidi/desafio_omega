program BancoSangue;

uses
  Vcl.Forms,
  UPrincipal in 'UPrincipal.pas' {frmPrincipal},
  UArqPessoa in 'UArqPessoa.pas' {frmArqPessoa};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmPrincipal, frmPrincipal);
  Application.CreateForm(TfrmArqPessoa, frmArqPessoa);
  Application.Run;
end.
