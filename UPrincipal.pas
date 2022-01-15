unit UPrincipal;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Menus, Vcl.ComCtrls;

type
  TfrmPrincipal = class(TForm)
    mmMenuPrincipal: TMainMenu;
    miSistema: TMenuItem;
    miSisSair: TMenuItem;
    miArquivo: TMenuItem;
    miArqPessoa: TMenuItem;
    miProcesso: TMenuItem;
    miProcDoacao: TMenuItem;
    miRelatorio: TMenuItem;
    sbBarraStatusPrincipal: TStatusBar;
    miRelDoacao: TMenuItem;
    procedure miArqPessoaClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmPrincipal: TfrmPrincipal;

implementation

uses
  UArqPessoa;

{$R *.dfm}

procedure TfrmPrincipal.miArqPessoaClick(Sender: TObject);
begin
  if frmArqPessoa = Nil then
    begin
      frmArqPessoa := TForm.Create(Self);
      frmArqPessoa.ShowModal;
    end
  else
    frmArqPessoa.ShowModal;
end;

end.
