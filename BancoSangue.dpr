program BancoSangue;

uses
  Vcl.Forms,
  UPrincipal in 'UPrincipal.pas' {frmPrincipal},
  UProcDoacao in 'UProcDoacao.pas' {frmProcDoacao},
  UFuncoes in 'UFuncoes.pas',
  UConexao in 'UConexao.pas' {dmConexao: TDataModule},
  UArqPessoa in 'UArqPessoa.pas' {frmArqPessoa},
  ULocalizar in 'ULocalizar.pas' {frmLocalizar},
  URelatorio in 'URelatorio.pas' {dmRelatorio: TDataModule};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmPrincipal, frmPrincipal);
  Application.CreateForm(TdmConexao, dmConexao);
  Application.CreateForm(TdmRelatorio, dmRelatorio);
  Application.Run;
end.
