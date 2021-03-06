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
    dbgDoacoes: TDBGrid;
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
    btnSalvar: TButton;
    btnCancelar: TButton;
    btnLocalizar: TButton;
    edtQtde: TEdit;
    lblUnidade: TLabel;
    procedure FormShow(Sender: TObject);
    procedure btnAtualizarClick(Sender: TObject);
    procedure btnEditarClick(Sender: TObject);
    procedure btnExcluirClick(Sender: TObject);
    procedure Atualizar;
    procedure Excluir;
    procedure dbgDoacoesKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure btnNovoClick(Sender: TObject);
    procedure edtNomeKeyPress(Sender: TObject; var Key: Char);
    procedure medtDtDoacaoKeyPress(Sender: TObject; var Key: Char);
    procedure medtCPFKeyPress(Sender: TObject; var Key: Char);
    procedure medtCelularKeyPress(Sender: TObject; var Key: Char);
    procedure edtEmailKeyPress(Sender: TObject; var Key: Char);
    procedure cbTipoSanguineoSelect(Sender: TObject);
    function LocalizarPessoa(IDPessoa: String): TArray<String>;
    procedure Salvar;
    procedure Cancelar;
    procedure btnCancelarClick(Sender: TObject);
    procedure edtQtdeKeyPress(Sender: TObject; var Key: Char);
    procedure btnSalvarClick(Sender: TObject);
    procedure edtIDPessoaKeyPress(Sender: TObject; var Key: Char);
    procedure btnLocalizarClick(Sender: TObject);
    procedure dbgDoacoesDblClick(Sender: TObject);
    procedure dbgDoacoesDrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
  private
    Doa_ID, PesID, PesNome, PesDtNasc, DoaID, Acao: String;
    Editado: Boolean;
    QtdeEdicao: Double;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmProcDoacao: TfrmProcDoacao;

implementation

uses
  UConexao, UFuncoes, ULocalizar;

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
  SQL(ADOQuery,['SELECT D.doa_id AS "ID DOA??O"'
               ,',D.doa_data AS "DATA"'
               ,',D.doa_qtde AS "QUANTIDADE"'
               ,',P.pes_id AS "ID PESSOA"'
               ,',P.pes_nome AS "NOME"'
               ,',FORMAT(P.pes_datanasc,''dd/MM/yyyy'') AS "NASCIMENTO"'
               ,',P.pes_tiposang AS "TIPO SANGU?NEO"'
               ,',D.doa_status'
               ,'FROM bs_pessoa P'
                     ,'INNER JOIN bs_doacao D'
                            ,'ON D.pes_id = P.pes_id'
               ,'WHERE '+Filtro
               ,'ORDER BY P.pes_id, D.doa_data']);
  dbgDoacoes.Fields[7].Visible := False;
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
        SetLength(Result,3);
        Result[0] := ADOQuery2.FieldByName('pes_id').Text;
        Result[1] := ADOQuery2.FieldByName('pes_nome').Text;
        Result[2] := ADOQuery2.FieldByName('pes_datanasc').Text;
      end
    else
      begin
        Application.MessageBox(PChar('N?o foi localizado nenhum cadastro com o ID "'+IDPessoa+'"')
                              ,'Aviso'
                              ,MB_ICONEXCLAMATION + MB_OK);
        SetLength(Result,2);
        Result[0] := EmptyStr;
        Result[1] := EmptyStr;
        Result[2] := EmptyStr;
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

procedure TfrmProcDoacao.Salvar;
var
  descAcao, Filtro: String;
  Idade, DiasUltDoacao: Integer;
  qtdeDia: Double;
  DtNasc: TDateTime;
begin
  try
    if Editado then
      begin
        //verifica se o nome foi preenchido
        if PesID = EmptyStr then
          begin
            Application.MessageBox('Selecione uma pessoa para incluir a doa??o'
                                  ,'Aviso'
                                  ,MB_ICONEXCLAMATION + MB_OK);
            edtNome.SetFocus;
            Exit;
          end;
        //valida a data de doa??o
        if not ValidarData(medtDtDoacao.Text) then
          begin
            Application.MessageBox('Data inv?lida'
                                  ,'Aviso'
                                  ,MB_ICONEXCLAMATION + MB_OK);
            medtDtDoacao.SetFocus;
            Exit;
          end;
        //Verifica se a data de lan?amento ? maior do que a data atual
        if StrToDate(medtDtDoacao.Text) > Now then
          begin
            Application.MessageBox('O lan?amento n?o pode ser feito em data futura'
                                  ,'Aviso'
                                  ,MB_ICONEXCLAMATION + MB_OK);
            medtDtDoacao.SetFocus;
            Exit;
          end;
        //Verifica a idade - deve estar entre 18 e 60 anos
        Idade := YearsBetween(StrToDate(PesDtNasc),StrToDate(medtDtDoacao.Text));
        if ((Idade < 18) or (Idade > 60)) then
          begin
            Application.MessageBox('Idade deve ser entre 18 e 60 anos'
                                  ,'Aviso'
                                  ,MB_ICONEXCLAMATION + MB_OK);
            medtDtDoacao.SetFocus;
            Exit;
          end;
        //Verifica se a ?ltima data de lan?amento ? maior que 15 dias
        SQL(ADOQuery2,['SELECT MAX(doa_data) ultima_doacao'
                      ,'FROM bs_doacao'
                      ,'WHERE pes_id = '+PesID
                            ,'AND doa_status = ''A'''
                            ,'AND FORMAT(doa_data, ''dd/MM/yyyy'') <> '''+medtDtDoacao.Text+'''']);
        if ADOQuery2.FieldByName('ultima_doacao').Text <> EmptyStr then
          DiasUltDoacao := DaysBetween(StrToDate(ADOQuery2.FieldByName('ultima_doacao').Text),StrToDate(medtDtDoacao.Text));
        if ((ADOQuery2.FieldByName('ultima_doacao').Text <> EmptyStr) and
            (DiasUltDoacao <= 15)) then
          begin
            Application.MessageBox('O intervalo de doa??es deve ser maior que 15 dias'
                                  ,'Aviso'
                                  ,MB_ICONEXCLAMATION + MB_OK);
            edtQtde.SetFocus;
            Exit;
          end;
        //verifica se foi informada a quantidade
        if edtQtde.Text = EmptyStr then
          begin
            Application.MessageBox('Informe a quantidade'
                                  ,'Aviso'
                                  ,MB_ICONEXCLAMATION + MB_OK);
            edtQtde.SetFocus;
            Exit;
          end;
        //valida o n?mero informado na quantidade
        if not ValidarFloat(edtQtde.Text) then
          begin
            Application.MessageBox('Valor informado est? incorreto'
                                  ,'Aviso'
                                  ,MB_ICONEXCLAMATION + MB_OK);
            edtQtde.SetFocus;
            Exit;
          end;
        //consulta lan?amentos para a pessoa na mesma data
        SQL(ADOQuery2,['SELECT sum(doa_qtde) qtde_dia'
                      ,'FROM bs_doacao'
                      ,'WHERE pes_id = '+PesID
                            ,'AND FORMAT(doa_data, ''dd/MM/yyyy'') = '''+medtDtDoacao.Text+''''
                            ,'AND doa_status = ''A''']);
        qtdeDia := ADOQuery2.FieldByName('qtde_dia').AsFloat-QtdeEdicao;
        //valida a quantidade
        if (qtdeDia+StrToFloat(edtQtde.Text)) > 1000 then
          begin
            Application.MessageBox('A quantidade informada excede o limite permitido por doa??o (1 litro)'
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
            SQL(ADOQuery,['UPDATE bs_doacao SET'
                         ,'pes_id = '''+PesID+''''
                         ,',doa_data = '''+medtDtDoacao.Text+''''
                         ,',doa_qtde = '''+edtQtde.Text+''''
                         ,'WHERE doa_id = '+DoaID]);
          end;
        Acao := EmptyStr;
        Editado := False;
        PesID := EmptyStr;
        PesNome := EmptyStr;
        PesDtNasc := EmptyStr;
        DoaID := EmptyStr;
        LimparForm(Self);
        HDControles([edtIDDoacao,medtDtDoacao,edtQtde],False);
        Atualizar;
        Application.MessageBox(PChar('Cadastro '+descAcao+' com sucesso!')
                              ,'Informa??o'
                              ,MB_ICONINFORMATION + MB_OK);
      end
    else

  except on E: exception do
    begin
      if E.ClassName <> 'EAbort' then
        begin
          Application.MessageBox(PChar('Erro ao tentar salvar dados da doa??o'+#13#13
                                      +'Classe '+E.ClassName+#13
                                      +'Detalhes: '+E.Message)
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
      if Application.MessageBox('Deseja cancelar a inser??o/edi??o?'
                                ,'Confirma??o'
                                ,MB_ICONQUESTION + MB_YESNO) = mrYes then
        begin
          Acao := EmptyStr;
          Editado := False;
          DoaID := EmptyStr;
          PesID := EmptyStr;
          medtDtDoacao.Text := EmptyStr;
          edtQtde.Text := EmptyStr;
          LimparForm(Self);
          HDControles([edtIDDoacao,medtDtDoacao,edtQtde],False);
          dbgDoacoes.SelectedRows.Clear;
          Atualizar;
        end
      else
        Exit;
    end
  else
    begin
      if Acao = 'ADICIONAR' then
        begin
          medtDtDoacao.Text := EmptyStr;
          edtQtde.Text := EmptyStr;
          HDControles([edtIDDoacao,medtDtDoacao,edtQtde],False);
          Acao := EmptyStr;
        end
      else if Acao = 'EDITAR' then
        begin
          edtIDDoacao.Text := EmptyStr;
          medtDtDoacao.Text := EmptyStr;
          edtQtde.Text := EmptyStr;
          HDControles([edtIDDoacao,medtDtDoacao,edtQtde],False);
          Acao := EmptyStr;
        end
      else
        begin
          LimparForm(Self);
          PesID := EmptyStr;
          DoaID := EmptyStr;
          HDControles([edtIDDoacao,medtDtDoacao,edtQtde],False);
          dbgDoacoes.SelectedRows.Clear;
          Atualizar;
        end;
    end;
end;

procedure TfrmProcDoacao.Excluir;
begin
  try
    DoaID := dbgDoacoes.DataSource.DataSet.FieldByName('ID DOA??O').Text;
    if DoaID <> EmptyStr then
      begin
        if Application.MessageBox(PChar('Deseja realmente excluir o lan?amento de doa??o selecionado?')
                                 ,'Confirma??o'
                                 ,MB_ICONQUESTION + MB_YESNO) = mrYes then
          begin
            //SQL(ADOQuery2,['SELECT * FROM bs_pessoa']);
            SQL(ADOQuery2,['UPDATE bs_doacao SET'
                         ,'doa_status = ''I'''
                         ,'WHERE doa_id = '+DoaID]);
            Atualizar;
            Application.MessageBox(PChar('Registro exclu?do com suceso!')
                                  ,'Informa??o'
                                  ,MB_ICONINFORMATION + MB_OK);
            DoaID := EmptyStr;
          end;
      end;
  except on E: exception do
    begin
      if E.ClassName <> 'EAbort' then
        begin
          Application.MessageBox(PChar('Erro ao tentar excluir o lan?amento selecionado'+#13#13
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
  DoaID := dbgDoacoes.DataSource.DataSet.Fields[0].AsString;
  if dbgDoacoes.DataSource.DataSet.FieldByName('doa_status').AsString = 'I' then
    begin
      Application.MessageBox('Este lan?amento n?o pode ser editado'
                            ,'Aviso'
                            ,MB_ICONEXCLAMATION + MB_OK);
      Exit;
    end;

  if DoaID <> EmptyStr then
    begin
      Acao := 'EDITAR';
      Cancelar;
      HDControles([medtDtDoacao,edtQtde],True);
      SQL(ADOQuery2,['SELECT *'
                    ,'FROM bs_doacao'
                    ,'WHERE doa_id = '+DoaID]);
      edtIDDoacao.Text := ADOQuery2.FieldByName('doa_id').Text;
      medtDtDoacao.Text := ADOQuery2.FieldByName('doa_data').Text;
      edtQtde.Text := ADOQuery2.FieldByName('doa_qtde').Text;
      QtdeEdicao := ADOQuery2.FieldByName('doa_qtde').AsFloat;
      if PesID = EmptyStr then
        begin
          PesID := ADOQuery2.FieldByName('pes_id').Text;
          edtIDPessoa.Text := ADOQuery2.FieldByName('pes_id').Text;
          btnLocalizar.Click;
        end;
    end;
end;

procedure TfrmProcDoacao.btnExcluirClick(Sender: TObject);
begin
  if dbgDoacoes.DataSource.DataSet.FieldByName('doa_status').AsString <> 'I' then
    Excluir;
end;

procedure TfrmProcDoacao.btnSalvarClick(Sender: TObject);
begin
  Salvar;
end;

procedure TfrmProcDoacao.btnLocalizarClick(Sender: TObject);
begin
  if edtIDPessoa.Text <> EmptyStr then
    begin
      PesID := LocalizarPessoa(edtIDPessoa.Text)[0];
      if PesID <> EmptyStr then
        begin
          PesNome := LocalizarPessoa(edtIDPessoa.Text)[1];
          PesDtNasc := LocalizarPessoa(edtIDPessoa.Text)[2];
          edtIDPessoa.Text := PesID;
          edtNome.Text := PesNome;
          Atualizar;
        end;
    end
  else
    begin
      edtNome.Text := EmptyStr;
      frmLocalizar := TfrmLocalizar.Create(Self);
      frmLocalizar.RefConsulta := 'Doa??o (Pessoa)';
      frmLocalizar.Show;
      {if frmLocalizar = Nil then
        begin
          frmLocalizar := TfrmLocalizar.Create(Self);
          frmLocalizar.RefConsulta := 'Doa??o (Pessoa)';
          frmLocalizar.Show;
        end
      else
        begin
          frmLocalizar.RefConsulta := 'Doa??o (Pessoa)';
          frmLocalizar.Show;
        end; }

    end;

end;

procedure TfrmProcDoacao.btnNovoClick(Sender: TObject);
begin
  if PesID = EmptyStr then
    begin
      Application.MessageBox('Selecione a pessoa'
                            ,'Aviso'
                            ,MB_ICONEXCLAMATION + MB_OK);
      edtIDPessoa.SetFocus;
      Exit;
    end;
  Acao := 'ADICIONAR';
  Cancelar;
  HDControles([medtDtDoacao,edtQtde],True);
  medtDtDoacao.Text := FormatDateTime('DD/MM/YYYY', Now);
  medtDtDoacao.SetFocus;
end;

procedure TfrmProcDoacao.cbTipoSanguineoSelect(Sender: TObject);
begin
  Editado := Enabled;
end;

procedure TfrmProcDoacao.dbgDoacoesDblClick(Sender: TObject);
begin
  btnEditar.Click;
end;

procedure TfrmProcDoacao.dbgDoacoesDrawColumnCell(Sender: TObject;
  const Rect: TRect; DataCol: Integer; Column: TColumn; State: TGridDrawState);
begin
  If ADOQuery.FieldByName('doa_status').Text = 'I' then
    dbgDoacoes.Canvas.Font.Color:= clRed;
  dbgDoacoes.DefaultDrawDataCell(Rect, dbgDoacoes.columns[datacol].field, State);
end;

procedure TfrmProcDoacao.dbgDoacoesKeyDown(Sender: TObject; var Key: Word;
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

procedure TfrmProcDoacao.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_ESCAPE then
    Cancelar;
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
