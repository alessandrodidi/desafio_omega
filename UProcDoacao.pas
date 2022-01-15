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
    edtID: TEdit;
    lblID: TLabel;
    lblNome: TLabel;
    edtNome: TEdit;
    gpbxDoacao: TGroupBox;
    lblIDDoacao: TLabel;
    Edit1: TEdit;
    lblData: TLabel;
    medtDtDoacao: TMaskEdit;
    lblQtde: TLabel;
    edtQtde: TEdit;
    btnIncluir: TButton;
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
    procedure medtDtDoacaoKeyPress(Sender: TObject; var Key: Char);
    procedure medtCPFKeyPress(Sender: TObject; var Key: Char);
    procedure medtCelularKeyPress(Sender: TObject; var Key: Char);
    procedure edtEmailKeyPress(Sender: TObject; var Key: Char);
    procedure cbTipoSanguineoSelect(Sender: TObject);
    procedure btnSalvarClick(Sender: TObject);
    procedure Incluir;
    procedure Cancelar;
    procedure btnCancelarClick(Sender: TObject);
    procedure edtQtdeKeyPress(Sender: TObject; var Key: Char);
    procedure btnIncluirClick(Sender: TObject);
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
begin
  SQL(ADOQuery,['SELECT pes_id ID'
               ,',pes_nome AS "NOME"'
               ,',pes_datanasc AS "NASCIMENTO"'
               ,',pes_cpf AS "CPF"'
               ,',pes_celular AS "CELULAR"'
               ,',pes_email AS "EMAIL"'
               ,',pes_tiposang AS "TIPO SANGU�NEO"'
               ,'FROM bs_pessoa']);
end;

procedure TfrmProcDoacao.Incluir;
var
  descAcao: String;
begin
  try
    if Editado then
      begin
        //verifica se o nome foi preenchido
        if Length(edtNome.Text) < 5 then
          begin
            Application.MessageBox('O nome informado � inv�lido'
                                  ,'Aviso'
                                  ,MB_ICONEXCLAMATION + MB_OK);
            edtNome.SetFocus;
            Exit;
          end;
        //valida a data de nascimento
        if not ValidarData(medtDtNasc.Text) then
          begin
            Application.MessageBox('Data de nascimento inv�lida'
                                  ,'Aviso'
                                  ,MB_ICONEXCLAMATION + MB_OK);
            medtDtNasc.SetFocus;
            Exit;
          end;
        //Verifica a idade - deve estar entre 18 e 60 anos
        //showmessage(IntToStr(YearsBetween(StrToDate('23/11/1986'),now)));
        if ((YearsBetween(StrToDate(medtDtNasc.Text),StrToDate(FormatDateTime('dd/mm/yyyy', Now))) < 18) or
            (YearsBetween(StrToDate(medtDtNasc.Text),StrToDate(FormatDateTime('dd/mm/yyyy', Now))) > 60)) then
          begin
            Application.MessageBox('Idade deve ser entre 18 e 60 anos'
                                  ,'Aviso'
                                  ,MB_ICONEXCLAMATION + MB_OK);
            medtDtNasc.SetFocus;
            Exit;
          end;
        //valida o CPF
        if not ValidarCPF(medtCPF.Text) then
          begin
            Application.MessageBox('CPF inv�lido'
                                  ,'Aviso'
                                  ,MB_ICONEXCLAMATION + MB_OK);
            medtCPF.SetFocus;
            Exit;
          end;
        //vefica se foi selecionado o tipo sangu�neo
        if cbTipoSanguineo.Text = EmptyStr then
          begin
            Application.MessageBox('Selecione o tipo sangu�neo'
                                  ,'Aviso'
                                  ,MB_ICONEXCLAMATION + MB_OK);
            cbTipoSanguineo.SetFocus;
            Exit;
          end;
        //verifica se foi preenchido o n�mero do celular
        if medtCelular.Text = '(__) _.____-____' then
          begin
            Application.MessageBox('Selecione o tipo sangu�neo'
                                  ,'Aviso'
                                  ,MB_ICONEXCLAMATION + MB_OK);
            medtCelular.SetFocus;
            Exit;
          end;
        //valida o email
        if not ValidarEmail(edtEmail.Text) then
          begin
            Application.MessageBox('Email inv�lido'
                                  ,'Aviso'
                                  ,MB_ICONEXCLAMATION + MB_OK);
            edtEmail.SetFocus;
            Exit;
          end;
        //verifica se pessoa j� foi cadastrada
        SQL(ADOQuery2,['SELECT * FROM bs_pessoa'
                      ,'WHERE ((UPPER(pes_nome) = '''+UpperCase(edtNome.Text)+''''
                               ,'and pes_datanasc = '''+medtDtNasc.Text+''')'
                              ,'or (pes_cpf = '''+medtCPF.Text+'''))']);
        if ADOQuery2.RecordCount > 0 then
          begin
            Application.MessageBox(PChar('"'+edtNome.Text+'" j� est� cadastrado com o ID '+ADOQuery2.FieldByName('pes_id').Text)
                                  ,'Aviso'
                                  ,MB_ICONEXCLAMATION + MB_OK);
            edtNome.SetFocus;
            Exit;
          end;
        if Acao = 'ADICIONAR' then
          begin
            descAcao := 'adicionado';
            SQL(ADOQuery,['INSERT INTO bs_pessoa '
                          ,'(pes_nome'
                          ,',pes_datanasc'
                          ,',pes_cpf'
                          ,',pes_tiposang'
                          ,',pes_celular'
                          ,',pes_email)'
                          ,'VALUES ('''+edtNome.Text+''''
                                   ,','''+medtDtNasc.Text+''''
                                   +','''+medtCPF.Text+''''
                                   +','''+cbTipoSanguineo.Text+''''
                                   +','''+medtCelular.Text+''''
                                   +','''+edtEmail.Text+''')']);
          end
        else if Acao = 'EDITAR' then
          begin
            descAcao := 'editado';
          end;
        Acao := EmptyStr;
        Editado := False;
        PesID := EmptyStr;
        PesNome := EmptyStr;
        HDControles([edtNome,medtDtNasc,medtCPF,cbTipoSanguineo,medtCelular,edtEmail],False);
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
          HDControles([edtNome,medtDtNasc,medtCPF,cbTipoSanguineo,medtCelular,edtEmail],False);
          dbgPessoas.SelectedRows.Clear;
          Atualizar;
        end
      else
        Abort;
    end
  else
    begin
      HDControles([edtNome,medtDtNasc,medtCPF,cbTipoSanguineo,medtCelular,edtEmail],False);
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
      HDControles([edtNome,medtDtNasc,medtCPF,cbTipoSanguineo,medtCelular,edtEmail],True);
      SQL(ADOQuery2,['SELECT *'
                    ,'FROM bs_pessoa'
                    ,'WHERE pes_id = '+PesID]);
      edtID.Text := ADOQuery2.FieldByName('pes_id').Text;
      edtNome.Text := ADOQuery2.FieldByName('pes_nome').Text;
      medtDtNasc.Text := ADOQuery2.FieldByName('pes_datanasc').Text;
      medtCPF.Text := ADOQuery2.FieldByName('pes_cpf').Text;
      cbTipoSanguineo.ItemIndex := cbTipoSanguineo.Items.IndexOf(ADOQuery2.FieldByName('pes_tiposang').Text);
      medtCelular.Text := ADOQuery2.FieldByName('pes_celular').Text;
      edtEmail.Text := ADOQuery2.FieldByName('pes_email').Text;
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

procedure TfrmProcDoacao.btnNovoClick(Sender: TObject);
begin
  Acao := 'ADICIONAR';
  Cancelar;
  HDControles([edtNome,medtDtNasc,medtCPF,cbTipoSanguineo,medtCelular,edtEmail],True);
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
if not (Key in (['0'..'9',#8,#32,#46])) then
    Key := #0
  else
    Editado := Enabled;
end;

procedure TfrmProcDoacao.edtEmailKeyPress(Sender: TObject; var Key: Char);
begin
  Editado := Enabled;
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
  HDControles([edtNome,medtDtNasc,medtCPF,cbTipoSanguineo,medtCelular,edtEmail],False);
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
