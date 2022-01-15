unit UArqPessoa;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, Data.DB,
  Vcl.Grids, Vcl.DBGrids, Data.Win.ADODB;

type
  TfrmArqPessoa = class(TForm)
    gpbxCadastro: TGroupBox;
    pnlComandos: TPanel;
    btnAtualizar: TButton;
    btnNovo: TButton;
    gpbxPessoas: TGroupBox;
    dbgPessoas: TDBGrid;
    ADOQuery: TADOQuery;
    DataSource: TDataSource;
    btnEditar: TButton;
    btnExcluir: TButton;
    procedure FormShow(Sender: TObject);
    procedure btnAtualizarClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmArqPessoa: TfrmArqPessoa;

implementation

uses
  UConexao, UFuncoes;

{$R *.dfm}

procedure TfrmArqPessoa.btnAtualizarClick(Sender: TObject);
begin
  SQL(ADOQuery,['SELECT pes_id ID'
                ,',pes_nome AS "NOME"'
                ,',pes_datanasc AS "NASCIMENTO"'
                ,',pes_cpf AS "CPF"'
                ,',pes_celular AS "CELULAR"'
                ,',pes_email AS "EMAIL"'
                ,',pes_tiposang AS "TIPO SANGUÍNEO"'
                ,'FROM bs_pessoa']);
end;

procedure TfrmArqPessoa.FormShow(Sender: TObject);
begin
  btnAtualizar.Click
end;

end.
