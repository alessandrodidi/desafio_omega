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
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure miSisSairClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmPrincipal: TfrmPrincipal;

implementation

uses
  UFuncoes, UArqPessoa;

{$R *.dfm}

procedure TfrmPrincipal.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  //Chama o procedimento de encerramento da aplicação
  Encerrar;
end;

procedure TfrmPrincipal.miArqPessoaClick(Sender: TObject);
begin
  //Ferifica se o formulário já foi criado
  if frmArqPessoa = Nil then
    begin
      //Caso o formulário não tenha sido criado, cria-o e o abre
      frmArqPessoa := TfrmArqPessoa.Create(Self);
      frmArqPessoa.ShowModal;
    end
  else
    //Caso o formulário já tenha sido criado apenas o abre
    frmArqPessoa.ShowModal;
end;

procedure TfrmPrincipal.miSisSairClick(Sender: TObject);
begin
  //Chama o procedimento de encerramento da aplicação
  Encerrar;
end;

end.
