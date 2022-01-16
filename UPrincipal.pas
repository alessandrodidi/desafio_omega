unit UPrincipal;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Menus, Vcl.ComCtrls, ppBands,
  ppCache, ppClass, ppDesignLayer, ppParameter, ppComm, ppRelatv, ppProd,
  ppReport, ppTypes;

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
    procedure FormShow(Sender: TObject);
    procedure miProcDoacaoClick(Sender: TObject);
    procedure miRelDoacaoClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmPrincipal: TfrmPrincipal;

implementation

uses
  UFuncoes, UConexao, UArqPessoa, UProcDoacao, URelatorio;

{$R *.dfm}

procedure TfrmPrincipal.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  //Chama o procedimento de encerramento da aplicação
  Encerrar;
end;

procedure TfrmPrincipal.FormShow(Sender: TObject);
begin
  InciarConexao(dmConexao.adocConexao, 'conexao.ini');
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

procedure TfrmPrincipal.miProcDoacaoClick(Sender: TObject);
begin
  //Ferifica se o formulário já foi criado
  if frmProcDoacao = Nil then
    begin
      //Caso o formulário não tenha sido criado, cria-o e o abre
      frmProcDoacao := TfrmProcDoacao.Create(Self);
      frmProcDoacao.ShowModal;
    end
  else
    //Caso o formulário já tenha sido criado apenas o abre
    frmProcDoacao.ShowModal;
end;

procedure TfrmPrincipal.miRelDoacaoClick(Sender: TObject);
begin
  dmRelatorio.pprDoacoes.DeviceType := dtScreen;
  dmRelatorio.pprDoacoes.ShowPrintDialog := False;
  dmRelatorio.pprDoacoes.Print;
end;

procedure TfrmPrincipal.miSisSairClick(Sender: TObject);
begin
  //Chama o procedimento de encerramento da aplicação
  Encerrar;
end;

end.
