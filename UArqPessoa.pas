unit UArqPessoa;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, Data.DB,
  Vcl.Grids, Vcl.DBGrids, Data.Win.ADODB, Vcl.Mask;

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
    lblID: TLabel;
    lblNome: TLabel;
    lblDtNasc: TLabel;
    lblCPF: TLabel;
    lblTipoSanguineo: TLabel;
    lblCelular: TLabel;
    lblEmail: TLabel;
    edtID: TEdit;
    edtNome: TEdit;
    medtDtNasc: TMaskEdit;
    medtCPF: TMaskEdit;
    cbTipoSanguineo: TComboBox;
    medtCelular: TMaskEdit;
    edtEmail: TEdit;
    btnSalvar: TButton;
    btnCancelar: TButton;
    procedure FormShow(Sender: TObject);
    procedure btnAtualizarClick(Sender: TObject);
    procedure btnEditarClick(Sender: TObject);
    procedure btnExcluirClick(Sender: TObject);
    procedure Atualizar;
    procedure Excluir;
    procedure dbgPessoasKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure btnNovoClick(Sender: TObject);
    procedure edtNomeKeyPress(Sender: TObject; var Key: Char);
    procedure medtDtNascKeyPress(Sender: TObject; var Key: Char);
    procedure medtCPFKeyPress(Sender: TObject; var Key: Char);
    procedure medtCelularKeyPress(Sender: TObject; var Key: Char);
    procedure edtEmailKeyPress(Sender: TObject; var Key: Char);
    procedure cbTipoSanguineoSelect(Sender: TObject);
  private
    PesID, PesNome, Acao: String;
    Editado: Boolean;
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
  Atualizar;
end;

procedure TfrmArqPessoa.Atualizar;
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

procedure TfrmArqPessoa.Excluir;
begin
  try
    if dbgPessoas.SelectedRows.Count > 0 then
      begin
        PesNome := dbgPessoas.Columns.Items[1].Field.Text;
        PesID := dbgPessoas.Columns.Items[0].Field.Text;
        if Application.MessageBox(PChar('Deseja realmente excluir o cadastro de "'+PesNome+'"')
                                 ,'Confirmação'
                                 ,MB_ICONQUESTION + MB_YESNO) = mrYes then
          begin
            SQL(ADOQuery,['DELETE FROM bs_pessoa'
                     +'WHERE pes_id = '+PesID]);
          end;
      end;
  except on E: exception do
    begin
      Application.MessageBox(PChar('Erro ao tentar excluir o cadastro de "'+PesNome+'"')
                            ,'Erro'
                            ,MB_ICONERROR + MB_OK);
      Abort;
    end;
  end;
end;

procedure TfrmArqPessoa.btnEditarClick(Sender: TObject);
begin
  if dbgPessoas.SelectedRows.Count > 0 then
    begin
      Acao := 'EDITAR';
    end;
end;

procedure TfrmArqPessoa.btnExcluirClick(Sender: TObject);
begin
  Excluir;
end;

procedure TfrmArqPessoa.btnNovoClick(Sender: TObject);
begin
  Acao := 'ADICIONAR';
end;

procedure TfrmArqPessoa.cbTipoSanguineoSelect(Sender: TObject);
begin
  Editado := Enabled;
end;

procedure TfrmArqPessoa.dbgPessoasKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_DELETE then
    Excluir;
end;

procedure TfrmArqPessoa.edtEmailKeyPress(Sender: TObject; var Key: Char);
begin
  Editado := Enabled;
end;

procedure TfrmArqPessoa.edtNomeKeyPress(Sender: TObject; var Key: Char);
begin
  Editado := Enabled;
end;

procedure TfrmArqPessoa.FormShow(Sender: TObject);
begin
  Atualizar;
  Acao := EmptyStr;
  Editado := False;
end;

procedure TfrmArqPessoa.medtCelularKeyPress(Sender: TObject; var Key: Char);
begin
  Editado := Enabled;
end;

procedure TfrmArqPessoa.medtCPFKeyPress(Sender: TObject; var Key: Char);
begin
  Editado := Enabled;
end;

procedure TfrmArqPessoa.medtDtNascKeyPress(Sender: TObject; var Key: Char);
begin
  Editado := Enabled;
end;

end.
