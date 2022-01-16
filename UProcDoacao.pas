unit UProcDoacao;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, Data.DB,
  Vcl.Grids, Vcl.DBGrids, Data.Win.ADODB, Vcl.Mask, DateUtils;

type
  TfrmProcDoacao = class(TForm)
    gpbxPessoa: TGroupBox;
    pnlComandos: TPanel;
    btnAtualizar: TButton;
    btnNovo: TButton;
    gpbxDoacoes: TGroupBox;
    dbgPessoas: TDBGrid;
    ADOQuery: TADOQuery;
    DataSource: TDataSource;
    btnEditar: TButton;
    btnExcluir: TButton;
    ADOQuery2: TADOQuery;
    edtIDPessoa: TEdit;
    lblID: TLabel;
    lblNome: TLabel;
    edtNome: TEdit;
    gpbxDoacao: TGroupBox;
    lblIDDoacao: TLabel;
    edtIDDoacao: TEdit;
    lblData: TLabel;
    medtDtDoacao: TMaskEdit;
    lblQtde: TLabel;
    btnIncluir: TButton;
    btnCancelar: TButton;
    btnLocalizar: TButton;
    edtQtde: TEdit;
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
    procedure medtDtDoacaoKeyPress(Sender: TObject; var Key: Char);
    procedure medtCPFKeyPress(Sender: TObject; var Key: Char);
    procedure medtCelularKeyPress(Sender: TObject; var Key: Char);
    procedure edtEmailKeyPress(Sender: TObject; var Key: Char);
    procedure cbTipoSanguineoSelect(Sender: TObject);
    function LocalizarPessoa(IDPessoa: String): TArray<String>;
    procedure Incluir;
    procedure Cancelar;
    procedure btnCancelarClick(Sender: TObject);
    procedure edtQtdeKeyPress(Sender: TObject; var Key: Char);
    procedure btnIncluirClick(Sender: TObject);
    procedure edtIDPessoaKeyPress(Sender: TObject; var Key: Char);
    procedure btnLocalizarClick(Sender: TObject);
  private
    Doa_ID, PesID, PesNome, Acao: String;
    Editado: Boolean;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmProcDoacao: TfrmProcDoacao;

implementation

uses
  UConexao, UFuncoes;

{$R *.dfm}

procedure TfrmProcDoacao.btnAtualizarClick(Sender: TObject);
begin
  Atualizar;
end;

procedure TfrmProcDoacao.btnCancelarClick(Sender: TObject);
begin
  Cancelar;
end;

procedure TfrmProcDoacao.Atualizar;
var
  Filtro: String;
begin
  if PesID <> EmptyStr then
    Filtro := 'P.pes_id = '+PesID
  else
    Filtro := '1=1';
  SQL(ADOQuery,['SELECT D.doa_id AS "ID DOA��O"'
               ,',D.doa_data AS "DATA"'
               ,',D.doa_qtde AS "QUANTIDADE"'
               ,',P.pes_id AS "ID PESSOA"'
               ,',P.pes_nome AS "NOME"'
               ,'FROM bs_pessoa P'
                     ,'INNER JOIN bs_doacao D'
                            ,'ON D.pes_id = P.pes_id'
               ,'WHERE '+Filtro]);
end;

function TfrmProcDoacao.LocalizarPessoa(IDPessoa: String): TArray<String>;
begin
  try
    if IDPessoa = EmptyStr then
      begin
        Application.MessageBox('Informe o ID para localizar o cadastro de pessoa'
                              ,'Aviso'
                              ,MB_ICONEXCLAMATION + MB_OK);
        Exit;
      end;
    SQL(ADOQuery2,['SELECT * FROM bs_pessoa'
                  ,'WHERE pes_id = '+IDPessoa]);
    if ADOQuery2.RecordCount > 0 then
      begin
        SetLength(Result,2);
        Result[0] := ADOQuery2.FieldByName('pes_id').Text;
        Result[1] := ADOQuery2.FieldByName('pes_nome').Text;
      end
    else
      begin
        Application.MessageBox(PChar('N�o foi localizado nenhum cadastro com o ID "'+IDPessoa+'"')
                              ,'Aviso'
                              ,MB_ICONEXCLAMATION + MB_OK);
        SetLength(Result,2);
        Result[0] := EmptyStr;
        Result[0] := EmptyStr;
      end;
  except on E: exception do
    begin
      if E.ClassName <> 'EAbort' then
        begin
          Application.MessageBox(PChar('Erro ao tentar localizar o cadastro de pessoa'#13#13
                                      +'Classe '+E.ClassName+#13
                                      +'Detalhes: '+E.Message)
                                ,'Erro'
                                ,MB_ICONERROR + MB_OK);
          Abort;
        end;
    end;
  end;
end;

procedure TfrmProcDoacao.Incluir;
var
  descAcao: String;
begin
  try
    if Editado then
      begin
        //verifica se o nome foi preenchido
        if PesID = EmptyStr then
          begin
            Application.MessageBox('Selecione uma pessoa para incluir a doa��o'
                                  ,'Aviso'
                                  ,MB_ICONEXCLAMATION + MB_OK);
            edtNome.SetFocus;
            Exit;
          end;
        //valida a data de nascimento
        if not ValidarData(medtDtDoacao.Text) then
          begin
            Application.MessageBox('Data inv�lida'
                                  ,'Aviso'
                                  ,MB_ICONEXCLAMATION + MB_OK);
            medtDtDoacao.SetFocus;
            Exit;
          end;
        //Verifica a idade - deve estar entre 18 e 60 anos
        if ((YearsBetween(StrToDate(medtDtDoacao.Text),StrToDate(FormatDateTime('dd/mm/yyyy', Now))) < 18) or
            (YearsBetween(StrToDate(medtDtDoacao.Text),StrToDate(FormatDateTime('dd/mm/yyyy', Now))) > 60)) then
          begin
            Application.MessageBox('Idade deve ser entre 18 e 60 anos'
                                  ,'Aviso'
                                  ,MB_ICONEXCLAMATION + MB_OK);
            medtDtDoacao.SetFocus;
            Exit;
          end;
        //verifica se foi informada a quantidade
        if edtQtde.Text <> EmptyStr then
          begin
            Application.MessageBox('Informe a quantidade'
                                  ,'Aviso'
                                  ,MB_ICONEXCLAMATION + MB_OK);
            edtQtde.SetFocus;
            Exit;
          end;
        //valida o n�mero informado na quantidade
        if not ValidarFloat(edtQtde.Text) then
          begin
            Application.MessageBox('Valor informado est� incorreto'
                                  ,'Aviso'
                                  ,MB_ICONEXCLAMATION + MB_OK);
            edtQtde.SetFocus;
            Exit;
          end;
        if Acao = 'ADICIONAR' then
          begin
            descAcao := 'adicionado';
            SQL(ADOQuery,['INSERT INTO bs_doacao'
                         ,'(pes_id'
                         ,',doa_data'
                         ,',doa_qtde'
                         ,',doa_status)'
                         ,'VALUES ('''+PesID+''''
                                  +','''+medtDtDoacao.Text+''''
                                  +','''+edtQtde.Text+''''
                                  +',''A'')']);
          end
        else if Acao = 'EDITAR' then
          begin
            descAcao := 'editado';
          end;
        Acao := EmptyStr;
        Editado := False;
        PesID := EmptyStr;
        PesNome := EmptyStr;
        HDControles([edtIDPessoa,edtNome,edtIDDoacao,medtDtDoacao,edtQtde],False);
        Atualizar;
        Application.MessageBox(PChar('Cadastro '+descAcao+' com sucesso!')
                              ,'Informa��o'
                              ,MB_ICONINFORMATION + MB_OK);
      end;
  except on E: exception do
    begin
      if E.ClassName <> 'EAbort' then
        begin
          Application.MessageBox(PChar('Erro ao tentar salvar o cadastro')
                                ,'Erro'
                                ,MB_ICONERROR + MB_OK);
          Abort;
        end;
    end;
  end;
end;

procedure TfrmProcDoacao.Cancelar;
begin
  if Editado then
    begin
      if Application.MessageBox('Deseja cancelar a inser��o/edi��o?'
                                ,'Confirma��o'
                                ,MB_ICONQUESTION + MB_YESNO) = mrYes then
        begin
          Acao := EmptyStr;
          Editado := False;
          PesID := EmptyStr;
          PesNome := EmptyStr;
          LimparForm(Self);
          HDControles([edtIDPessoa,edtNome,edtIDDoacao,medtDtDoacao,edtQtde],False);
          dbgPessoas.SelectedRows.Clear;
          Atualizar;
        end
      else
        Abort;
    end
  else
    begin
      HDControles([edtIDPessoa,edtNome,edtIDDoacao,medtDtDoacao,edtQtde],False);
      dbgPessoas.SelectedRows.Clear;
    end;
end;

procedure TfrmProcDoacao.Excluir;
begin
  try
    PesID := dbgPessoas.DataSource.DataSet.FieldByName('id').Text;
    PesNome := dbgPessoas.DataSource.DataSet.FieldByName('nome').Text;
    if PesID <> EmptyStr then
      begin
        PesNome := dbgPessoas.Columns.Items[1].Field.Text;
        PesID := dbgPessoas.Columns.Items[0].Field.Text;
        if Application.MessageBox(PChar('Deseja realmente excluir o cadastro de "'+PesNome+'"')
                                 ,'Confirma��o'
                                 ,MB_ICONQUESTION + MB_YESNO) = mrYes then
          begin
            SQL(ADOQuery2,['SELECT * FROM bs_pessoa']);
            SQL(ADOQuery2,['DELETE FROM bs_pessoa'
                         ,'WHERE pes_id = '+PesID]);
            Atualizar;
            Application.MessageBox(PChar('Cadastro de "'+PesNome+'" exclu�do com sucesso!')
                                  ,'Informa��o'
                                  ,MB_ICONINFORMATION + MB_OK);
            PesID := EmptyStr;
            PesNome := EmptyStr;
          end;
      end;
  except on E: exception do
    begin
      if E.ClassName <> 'EAbort' then
        begin
          Application.MessageBox(PChar('Erro ao tentar excluir o cadastro de "'+PesNome+'"'+#13#13
                                      +'Classe '+E.ClassName+#13
                                      +'Detalhes: '+E.Message)
                                ,'Erro'
                                ,MB_ICONERROR + MB_OK);
          Abort;
        end;
    end;
  end;
end;

procedure TfrmProcDoacao.btnEditarClick(Sender: TObject);
begin
  PesID := dbgPessoas.DataSource.DataSet.Fields[0].AsString;

  if PesID <> EmptyStr then
    begin
      Acao := 'EDITAR';
      Cancelar;
      HDControles([edtIDPessoa,edtNome,edtIDDoacao,medtDtDoacao,edtQtde],True);
      SQL(ADOQuery2,['SELECT *'
                    ,'FROM bs_doacao'
                    ,'WHERE pes_id = '+PesID]);
      edtIDDoacao.Text := ADOQuery2.FieldByName('doa_id').Text;
      medtDtDoacao.Text := ADOQuery2.FieldByName('doa_data').Text;
      edtQtde.Text := ADOQuery2.FieldByName('doa_qtde').Text;
    end;
end;

procedure TfrmProcDoacao.btnExcluirClick(Sender: TObject);
begin
  Excluir;
end;

procedure TfrmProcDoacao.btnIncluirClick(Sender: TObject);
begin
  Incluir;
end;

procedure TfrmProcDoacao.btnLocalizarClick(Sender: TObject);
begin
  if edtIDPessoa.Text <> EmptyStr then
    begin
      PesID := LocalizarPessoa(edtIDPessoa.Text)[0];
      PesNome := LocalizarPessoa(edtIDPessoa.Text)[1];
      edtIDPessoa.Text := PesID;
      edtNome.Text := PesNome;
    end
  else
    begin
      edtNome.Text := EmptyStr;
    end;

end;

procedure TfrmProcDoacao.btnNovoClick(Sender: TObject);
begin
  Acao := 'ADICIONAR';
  Cancelar;
  HDControles([edtIDPessoa,edtNome,edtIDDoacao,medtDtDoacao,edtQtde],True);
end;

procedure TfrmProcDoacao.cbTipoSanguineoSelect(Sender: TObject);
begin
  Editado := Enabled;
end;

procedure TfrmProcDoacao.dbgPessoasKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_DELETE then
    Excluir;
end;

procedure TfrmProcDoacao.edtQtdeKeyPress(Sender: TObject; var Key: Char);
begin
  if not (Key in (['0'..'9',#8,#32,#46,#44,#47])) then
    Key := #0
  else
    Editado := Enabled;
end;

procedure TfrmProcDoacao.edtEmailKeyPress(Sender: TObject; var Key: Char);
begin
  Editado := Enabled;
end;

procedure TfrmProcDoacao.edtIDPessoaKeyPress(Sender: TObject; var Key: Char);
begin
  if not (Key in (['0'..'9',#13,#8,#32,#46])) then
    Key := #0;

  if Key = #13 then
    btnLocalizar.Click
end;

procedure TfrmProcDoacao.edtNomeKeyPress(Sender: TObject; var Key: Char);
begin
  if not (Key in (['a'..'z','A'..'Z','0'..'9',#8,#32,#46])) then
    Key := #0
  else
    Editado := Enabled;
end;

procedure TfrmProcDoacao.FormShow(Sender: TObject);
begin
  Atualizar;
  LimparForm(Self);
  Acao := EmptyStr;
  Editado := False;
  //Desabilita os campos
  HDControles([edtNome,edtIDDoacao,medtDtDoacao,edtQtde],False);
end;

procedure TfrmProcDoacao.medtCelularKeyPress(Sender: TObject; var Key: Char);
begin
  Editado := Enabled;
end;

procedure TfrmProcDoacao.medtCPFKeyPress(Sender: TObject; var Key: Char);
begin
  Editado := Enabled;
end;

procedure TfrmProcDoacao.medtDtDoacaoKeyPress(Sender: TObject; var Key: Char);
begin
  Editado := Enabled;
end;

end.
