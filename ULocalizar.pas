unit ULocalizar;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Buttons, Vcl.StdCtrls, Data.DB,
  Data.Win.ADODB, Vcl.Grids, Vcl.DBGrids, Vcl.ExtCtrls;

type
  TfrmLocalizar = class(TForm)
    gpbxCriteriosPesquisa: TGroupBox;
    lblCampo: TLabel;
    cbCampo_1: TComboBox;
    lblCriterio: TLabel;
    cbCriterio_1: TComboBox;
    lblValor: TLabel;
    edtValor1_1: TEdit;
    lblE_1: TLabel;
    edtValor2_1: TEdit;
    cbCondicao_1: TComboBox;
    lblCondicao: TLabel;
    sbtnIncluirCriterio: TSpeedButton;
    sbtnPesquisar: TSpeedButton;
    sbtnLimparPesquisa_999: TSpeedButton;
    ADOQuery: TADOQuery;
    gpbxResultado: TGroupBox;
    pnlComandos: TPanel;
    dbgResultados: TDBGrid;
    DataSource: TDataSource;
    btnUtilizar: TButton;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure cbCriterio_1Change(Sender: TObject);
    procedure sbtnIncluirCriterioClick(Sender: TObject);
    function Identificador(Sender: TObject): String;
    procedure habCampoValor2(Sender: TObject);
    procedure RemoverCamposCriterio_Click(Sender: TObject);
    procedure RemoverCamposCriterio(idObjRem: String);
    procedure ReorganizarObjetos(idObjetoExcluido: Integer);
    procedure sbtnLimparPesquisa_999Click(Sender: TObject);
    procedure sbtnPesquisarClick(Sender: TObject);
    procedure Atualizar;
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure btnUtilizarClick(Sender: TObject);
    procedure dbgResultadosDblClick(Sender: TObject);
  private
    nCriterios, idObj, posObjeto: Integer;
    posObjetos: Array of Array of Integer;
    consSQL, Filtro: String;
    { Private declarations }
  public
    posX, posY: Integer;
    RefConsulta, Param1: String;
    const
      DefaultCaption: String = 'Pesquisar';
    { Public declarations }
  end;

var
  frmLocalizar: TfrmLocalizar;

implementation

uses
  UFuncoes, UConexao, UProcDoacao;

{$R *.dfm}

procedure TfrmLocalizar.btnUtilizarClick(Sender: TObject);
begin
  try
  if ADOQuery.Fields.Fields[0].Text = EmptyStr then
    begin
      Application.MessageBox(PChar('Selecione um registro para utilizar')
                            ,'Aviso'
                            ,MB_ICONEXCLAMATION + MB_OK);
      Exit;
    end;

  if RefConsulta = 'Doa??o (Pessoa)' then
      begin
        frmProcDoacao.edtIDPessoa.Text := ADOQuery.Fields.FieldByName('ID').Text;
        frmProcDoacao.btnLocalizar.Click;
      end
    else
      begin
        Application.MessageBox(PChar('N?o foram encontrados par?metros para o retorno da pesquisa em '''+RefConsulta+''''+#13
                                    +'A opera??o ser? abortada e n?o haver?o resultados selecionados'+#13#13
                                    +'- Entre em contato com o administrador do sistema para reportar o problema')
                              ,'Aviso'
                              ,MB_ICONEXCLAMATION + MB_OK);
        Abort;
      end;
  Self.Close;

  except on E: exception do
    begin
      if E.ClassName <> 'EAbort' then
        begin
          Application.MessageBox(PChar('Erro ao utilizar o registro'+#13+#13
                                      +'Classe '+E.ClassName+#13
                                      +'Detalhes: '+E.Message)
                                ,'Erro'
                                ,MB_ICONERROR + MB_OK);
        end;
    end;
  end;
end;

procedure TfrmLocalizar.cbCriterio_1Change(Sender: TObject);
begin
  if ((cbCriterio_1.Text = 'est? entre')
     or (cbCriterio_1.Text = 'n?o est? entre')) then
    begin
      edtValor2_1.Visible := True;
      edtValor1_1.Hint := 'Valor inicial';
      lblE_1.Visible := True;
    end
  else
    begin
      edtValor2_1.Visible := False;
      edtValor1_1.Hint := 'Valor';
      lblE_1.Visible := False;
    end;

  if ((cbCriterio_1.Text = '? nulo')
     or (cbCriterio_1.Text = 'n?o ? nulo')
     or (cbCriterio_1.Text = '? verdadeiro')
     or (cbCriterio_1.Text = '? falso')) then
    begin
      edtValor1_1.Text := '';
      edtValor1_1.Enabled := False;
    end
  else
    begin
      edtValor1_1.Enabled := True;
    end;
end;

procedure TfrmLocalizar.dbgResultadosDblClick(Sender: TObject);
begin
  btnUtilizar.Click;
end;

procedure TfrmLocalizar.FormCreate(Sender: TObject);
var
  i: Integer;
begin
  posX := -1;
  posY := -1;
  nCriterios := 1;
  idObj := 1;
  posObjeto := 0;

  SetLength(posObjetos,9,2);
  i:=0;
  while i < 9 do
    begin
      posObjetos[i,0] := i+2;
      posObjetos[i,1] := 0;
      i:=i+1;
    end;
end;

procedure TfrmLocalizar.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_F5 then
    Atualizar;
end;

procedure TfrmLocalizar.FormShow(Sender: TObject);
begin
  {if ((posX >= 0) and (posY >= 0)) then
    begin
      Self.Position := poDesigned;
      Self.Top := posY;
      Self.Left := posX;
    end
  else
    Self.Position := poOwnerFormCenter;}

  if RefConsulta <> EmptyStr then
    Self.Caption := DefaultCaption+' ['+RefConsulta+']'
  else
    Self.Caption := DefaultCaption;

  Atualizar;
end;

procedure TfrmLocalizar.Atualizar;
begin
  if RefConsulta = 'Doa??o (Pessoa)' then
    begin
      cbCampo_1.Items.Clear;
      cbCampo_1.Items.AddStrings(['pes_id','pes_nome','pes_cpf','pes_datanasc','pes_tiposang']);
      consSQL := 'SELECT pes_id AS "ID"'
                +', pes_nome AS "NOME"'
                +', pes_datanasc AS "NASCIMENTO"'
                +', pes_cpf AS "CPF"'
                +', pes_tiposang AS "TIPO SANGU?NEO" '
                +'FROM bs_pessoa '
                +'WHERE ';
    end
  else
    begin
      Application.MessageBox(PChar('N?o foram encontrados par?metros de pesquisa para '''+RefConsulta+''''+#13#13
                                  +'- Entre em contato com o administrador do sistema para reportar o problema')
                            ,'Erro'
                            ,MB_ICONERROR + MB_OK);
      Self.Close;
      Abort;
    end;

  Filtro := '1=1';
  SQL(ADOQuery,[consSQL+Filtro]);
end;

procedure TfrmLocalizar.sbtnIncluirCriterioClick(Sender: TObject);
var
  cbCampos, cbCriterios, cbCondicao: TComboBox;
  edtValor1, edtValor2: TEdit;
  sbtnRemoverCriterio: TSpeedButton;
  lblE: TLabel;
  topPos, i: Integer;
  idPenObj: String;
begin
  try
    if nCriterios > 9 then
      begin
        Application.MessageBox(PChar('N?o ? poss?vel incluir um novo crit?rio pois o n?mero m?ximo de crit?rios foi atingido')
                              ,'Aviso'
                              ,MB_ICONEXCLAMATION + MB_OK);
        Exit;
      end;

    nCriterios := nCriterios + 1;
    idObj := idObj+1;
    lblCondicao.Visible := True;
    gpbxCriteriosPesquisa.Height := gpbxCriteriosPesquisa.Height+28;
    Self.Height := Self.Height+28;

    i:=0;
    while i < 9 do
      begin
        if posObjetos[i,1] = 0 then
          begin
            posObjetos[i,1] := idObj;
            posObjeto := i+2;
            //Pega o id do pen?ltimo campo ativo
            if posObjeto = 2 then
              idPenObj := '1'
            else
              idPenObj := IntToStr(posObjetos[i-1,1]);
            i:=8;
          end;
        i:=i+1;
      end;
    case posObjeto of
      2: topPos := 64;
      3: topPos := 92;
      4: topPos := 120;
      5: topPos := 148;
      6: topPos := 176;
      7: topPos := 204;
      8: topPos := 232;
      9: topPos := 260;
      10: topPos := 288;
    end;

    //Habilita o pen?ltimo campo de  condi??o
    (Self.Components[FindComponent('cbCondicao_'+idPenObj).ComponentIndex] as TComboBox).Visible := True;

    //Incluir o combobox dos campos para pesquisa
    cbCampos := TComboBox.Create(Self);
    cbCampos.Parent := gpbxCriteriosPesquisa;
    cbCampos.Name := 'cbCampo_'+IntToStr(idObj);
    cbCampos.Top := topPos;
    cbCampos.Left := 8;
    cbCampos.Width := 85;
    cbCampos.Visible := True;
    cbCampos.Text := '';
    cbCampos.Style := csOwnerDrawFixed;
    //cbCampos.Items.AddStrings(CamposTabela);
    cbCampos.Items := cbCampo_1.Items;
    cbCampos.Hint := 'Campo '+IntToStr(idObj);
    cbCampos.ShowHint := True;

    //Incluir o combobox dos crit?rios
    cbCriterios := TComboBox.Create(Self);
    cbCriterios.Parent := gpbxCriteriosPesquisa;
    cbCriterios.Name := 'cbCriterio_'+IntToStr(idObj);
    cbCriterios.Top := topPos;
    cbCriterios.Left := 104;
    cbCriterios.Width := 106;
    cbCriterios.Visible := True;
    cbCriterios.Text := '';
    cbCriterios.Style := csOwnerDrawFixed;
    cbCriterios.Items.AddStrings(['? igual','n?o ? igual','cont?m','n?o cont?m','? nulo','n?o ? nulo','est? entre','n?o est? entre']);
    cbCriterios.OnChange := habCampoValor2;
    cbCriterios.Hint := 'Crit?rio '+IntToStr(idObj);;
    cbCriterios.ShowHint := True;

    //Incluir campo de valor1
    edtValor1 := TEdit.Create(Self);
    edtValor1.Parent := gpbxCriteriosPesquisa;
    edtValor1.Name := 'edtValor1_'+IntToStr(idObj);
    edtValor1.Left := 220;
    edtValor1.Top := topPos;
    edtValor1.Width := 150;
    edtValor1.Visible := True;
    edtValor1.Text := '';
    edtValor1.Hint := 'Valor '+IntToStr(idObj);;
    edtValor1.ShowHint := True;

    //Incluir label E
    lblE := TLabel.Create(Self);
    lblE.Parent := gpbxCriteriosPesquisa;
    lblE.Name := 'lblE_'+IntToStr(idObj);
    lblE.Left := 374;
    lblE.Top := topPos+4;
    lblE.Visible := False;
    lblE.Caption := 'E';

    //Incluir campo de valor2
    edtValor2 := TEdit.Create(Self);
    edtValor2.Parent := gpbxCriteriosPesquisa;
    edtValor2.Name := 'edtValor2_'+IntToStr(idObj);
    edtValor2.Left := 384;
    edtValor2.Top := topPos;
    edtValor2.Width := 150;
    edtValor2.Visible := False;
    edtValor2.Text := '';
    edtValor2.Hint := 'Valor final '+IntToStr(idObj);
    edtValor2.ShowHint := True;

    //Incluir o combobox de condi??es
    cbCondicao := TComboBox.Create(Self);
    cbCondicao.Parent := gpbxCriteriosPesquisa;
    cbCondicao.Name := 'cbCondicao_'+IntToStr(idObj);
    cbCondicao.Top := topPos;
    cbCondicao.Left := 544;
    cbCondicao.Width := 51;
    cbCondicao.Visible := False;
    cbCondicao.Text := '';
    cbCondicao.Style := csOwnerDrawFixed;
    cbCondicao.Items.AddStrings(['E','OU']);
    cbCondicao.Hint := 'Condi??o '+IntToStr(idObj);;
    cbCondicao.ShowHint := True;

    //Inclui o bot?o para remover o crit?rio
    sbtnRemoverCriterio := TSpeedButton.Create(Self);
    sbtnRemoverCriterio.Parent := gpbxCriteriosPesquisa;
    sbtnRemoverCriterio.Name := 'sbtnRemoverCriterio_'+IntToStr(idObj);
    sbtnRemoverCriterio.Top := topPos;
    sbtnRemoverCriterio.Left := 599;
    sbtnRemoverCriterio.Width := 23;
    sbtnRemoverCriterio.Height := 23;
    sbtnRemoverCriterio.Caption := '-';
    sbtnRemoverCriterio.Visible := True;
    sbtnRemoverCriterio.Hint := 'Remover crit?rio';
    sbtnRemoverCriterio.ShowHint := True;
    sbtnRemoverCriterio.Font.Style := [fsBold];
    sbtnRemoverCriterio.OnClick := RemoverCamposCriterio_Click;
  except on E: exception do
    begin
      Application.MessageBox(PChar('Erro ao tentar incluir novos campos de crit?rios'+#13#13
                                   +'Classe '+E.ClassName+#13
                                   +'Detalhes: '+E.Message)
                            ,'Erro'
                            ,MB_ICONERROR + MB_OK);
    end;
  end;
end;

procedure TfrmLocalizar.sbtnLimparPesquisa_999Click(Sender: TObject);
var
  i: Integer;
begin
  try
    LimparForm(Self);

    Filtro := '1=1';
    SQL(ADOQuery,[consSQL+Filtro]);

    if nCriterios > 1 then
      begin
        i := 0;
        while i < 9 do
          begin
            if posObjetos[i,1] > 0 then
              RemoverCamposCriterio(IntToStr(posObjetos[i,1]));
            i:=i+1;
          end;
      end;
  except on E: exception do
    begin
      if E.ClassName <> 'EAbort' then
        begin
          Application.MessageBox(PChar('Falha ao tentar limpar a pesquisa'+#13+#13
                                      +'Classe '+E.ClassName+#13
                                      +'Detalhes: '+E.Message)
                                ,'Erro'
                                ,MB_ICONERROR + MB_OK);
          Abort;
        end;
    end;
  end;
end;

procedure TfrmLocalizar.sbtnPesquisarClick(Sender: TObject);
var
  i, sPos, nCriterio: Integer;
  objNome, objConteudo, objHint, Campo, Criterio, Valor1, Valor2, Condicao: String;
  AddFiltro: Boolean;
begin
  try
    Filtro := EmptyStr;
    AddFiltro := False;
    nCriterio := 0;
    //Rotina da montagem do filtro de pesquisa
    for i:=0 to Self.ComponentCount-1 do
      begin
        if (Self.Components[i] is TComboBox) then
          begin
            objNome := (Self.Components[i] as TComboBox).Name;
            objConteudo := (Self.Components[i] as TComboBox).Text;
            objHint := (Self.Components[i] as TComboBox).Hint;
          end;

        if (Self.Components[i] is TEdit) then
          begin
            objNome := (Self.Components[i] as TEdit).Name;
            objConteudo := (Self.Components[i] as TEdit).Text;
            objHint := (Self.Components[i] as TEdit).Hint;
          end;

        //Extrai o nome do objeto
        sPos := Pos('_', objNome);
        objNome := Copy(objNome, 0, sPos-1);

        //Verifica se os campos est?o preenchidos
        if (((objNome = 'cbCampo') and (objConteudo = EmptyStr))
           or ((objNome = 'cbCriterio') and (objConteudo = EmptyStr))
           or ((objNome = 'edtValor1') and ((Self.Components[i] as TEdit).Enabled) and  (objConteudo = EmptyStr))
           or ((objNome = 'edtValor2') and ((Self.Components[i] as TEdit).Visible) and (objConteudo = EmptyStr))
           or ((objNome = 'cbCondicao') and ((Self.Components[i] as TComboBox).Visible) and (objConteudo = EmptyStr))) then
          begin
            Application.MessageBox(PChar('O campo '''+objHint+''' n?o pode ser vazio'), 'Aviso', MB_ICONEXCLAMATION + MB_OK);
            if (Self.Components[i] is TComboBox) then
              begin
               (Self.Components[i] as TComboBox).SetFocus;
               (Self.Components[i] as TComboBox).DroppedDown := True;
              end;
            if (Self.Components[i] is TEdit) then
              (Self.Components[i] as TEdit).SetFocus;
            Exit;
          end;

        //L? os dados para filtragem
        if (objNome = 'cbCampo') then
          begin
            Campo := (Self.Components[i] as TComboBox).Text;
            nCriterio := nCriterio+1;
            if Campo = 'RAZ?O SOCIAL' then
              Campo := 'razao_social';
          end;

        if (objNome = 'cbCriterio') then
          Criterio := (Self.Components[i] as TComboBox).Text;

        if (objNome = 'edtValor1') then
          if ((Self.Components[i] as TEdit).Enabled) then
            Valor1 := (Self.Components[i] as TEdit).Text;

        if (objNome = 'edtValor2') then
          if ((Self.Components[i] as TEdit).Visible) then
            Valor2 := (Self.Components[i] as TEdit).Text;

        if (objNome = 'cbCondicao') then
          begin
            if ((Self.Components[i] as TComboBox).Visible) then
              Condicao := (Self.Components[i] as TComboBox).Text;
            AddFiltro := True;
          end;

        //Monta o filtro
        if AddFiltro = True then
          begin
            if Condicao = 'E' then
              Filtro := Filtro+' AND '
            else if Condicao = 'OU' then
              Filtro := Filtro+' OR ';

            if nCriterio = 1 then
              Filtro := Campo
            else
              Filtro := Filtro+Campo;

            if Criterio = '? igual' then
              Filtro := Filtro+' = '''+Valor1+''''
            else if Criterio = 'n?o ? igual' then
              Filtro := Filtro+' <> '''+Valor1+''''
            else if Criterio = 'cont?m' then
              Filtro := Filtro+' LIKE '''+Valor1+''''
            else if Criterio = 'n?o cont?m' then
              Filtro := Filtro+' NOT LIKE '''+Valor1+''''
            else if Criterio = 'est? entre' then
              Filtro := Filtro+' BETWEEN '''+Valor1+''' AND '''+Valor2+''''
            else if Criterio = 'n?o est? entre' then
              Filtro := Filtro+' NOT BETWEEN '''+Valor1+''' AND '''+Valor2+''''
            else if Criterio = '? nulo' then
               Filtro := Filtro+' IS NULL'
            else if Criterio = 'n?o ? nulo' then
              Filtro := Filtro+' IS NOT NULL'
            else if Criterio = '? verdadeiro' then
              Filtro := Filtro+ ' = true'
            else if Criterio = '? falso' then
              Filtro := Filtro+ ' = false';

            AddFiltro := False;
          end;
      end;

    //Rotina de execu??o da pesquisa
    SQL(ADOQuery,[consSQL+Filtro]);

  except on E: exception do
    begin
      if E.ClassName <> 'EAbort' then
        begin
          Application.MessageBox(PChar('Erro ao tentar executar a pesquisa'+#13+#13
                                 +'Classe '+E.ClassName+#13+'Detalhes: '+E.Message), 'Erro', MB_ICONERROR + MB_OK);
          Abort;
        end;
    end;
  end;
end;

procedure TfrmLocalizar.habCampoValor2(Sender: TObject);
var
  id: String;
  i: Integer;
begin
  try
  id := Identificador(Sender);

  if (((Sender as TComboBox).Text = 'est? entre')
     or ((Sender as TComboBox).Text = 'n?o est? entre')) then
    begin
      for i:=0 to Self.ComponentCount-1 do
        begin
          if Self.Components[i].Name = 'lblE_'+id then
            (Self.Components[i] as TLabel).Visible := True;
          if Self.Components[i].Name = 'edtValor2_'+id then
            (Self.Components[i] as TEdit).Visible := True;
          if Self.Components[i].Name = 'edtValor1_'+id then
            (Self.Components[i] as TEdit).Hint := 'Valor inicial '+id;
        end;
    end
  else
    begin
      for i:=0 to Self.ComponentCount-1 do
        begin
          if Self.Components[i].Name = 'lblE_'+id then
            (Self.Components[i] as TLabel).Visible := False;
          if Self.Components[i].Name = 'edtValor2_'+id then
            (Self.Components[i] as TEdit).Visible := False;
          if Self.Components[i].Name = 'edtValor1_'+id then
            (Self.Components[i] as TEdit).Hint := 'Valor '+id;
        end;
    end;

  if (((Sender as TComboBox).Text = '? nulo')
     or ((Sender as TComboBox).Text = 'n?o ? nulo')
     or (cbCriterio_1.Text = '? verdadeiro')
     or (cbCriterio_1.Text = '? falso')) then
    begin
      for i:=0 to Self.ComponentCount-1 do
        begin
          if Self.Components[i].Name = 'edtValor1_'+id then
            (Self.Components[i] as TEdit).Text := '';
          if Self.Components[i].Name = 'edtValor1_'+id then
            (Self.Components[i] as TEdit).Enabled := False;
        end;
    end
  else
    begin
      for i:=0 to Self.ComponentCount-1 do
        begin
          if Self.Components[i].Name = 'edtValor1_'+id then
            (Self.Components[i] as TEdit).Enabled := True;
        end;
    end;
  except on E: exception do
    begin
      Application.MessageBox(PChar('Erro ao tentar mostrar/ocultar campo'+#13#13
                                   +'Classe '+E.ClassName+#13
                                   +'Detalhes: '+E.Message)
                            ,'Erro'
                            ,MB_ICONERROR + MB_OK);
    end;
  end;
end;

procedure TfrmLocalizar.RemoverCamposCriterio_Click(Sender: TObject);
var
  idObjRem_2: String;
begin
  //Recebe o identificador dos objetos que devem ser exclu?dos
  idObjRem_2 := Identificador(Sender);
  RemoverCamposCriterio(idObjRem_2);
end;

procedure TfrmLocalizar.RemoverCamposCriterio(idObjRem: String);
  var
  i: Integer;
begin
  try
    i := (Self.ComponentCount)-1;
    while i > 0 do
      begin
        //Verifica se o objeto atual possui identificador igual o identificador para exclus?o
        if Identificador(Self.Components[i]) = idObjRem then
          Self.Components[i].Free;
        i:=i-1;
      end;

    ReorganizarObjetos(StrToInt(idObjRem));
    Self.Height := Self.Height-28;
    gpbxCriteriosPesquisa.Height := gpbxCriteriosPesquisa.Height-28;
    nCriterios := nCriterios-1;
    idObjRem := EmptyStr;
  except on E: exception do
    begin
      if E.ClassName <> 'EAbort' then
        begin
          Application.MessageBox(PChar('Erro ao tentar destruir objetos dos crit?rios de pesquisa'+#13#13
                                       +'Classe '+E.ClassName+#13
                                       +'Detalhes: '+E.Message)
                                ,'Erro'
                                ,MB_ICONERROR + MB_OK);
        end;
      Abort;
    end;
  end;
end;

procedure TfrmLocalizar.ReorganizarObjetos(idObjetoExcluido: Integer);
var
  i, j, p, k, maxPos, novaPos: Integer;
  id, idPenObj, idUltObj: String;
begin
  try
  //Verifica qual a ?ltima posi??o ocupada
  p:=0;
  maxPos:=1;
  while p < 9 do
    begin
      if posObjetos[p,1] > 0 then
        begin
          maxPos := maxPos+1;
          //Pega o id do pen?ltimo campo de condi??o vis?vel
          if p > 0 then
            idPenObj := IntToStr(posObjetos[p-1,1])
          else
            idPenObj := '1';
          //Pega o ?ltimo id id do campo de condi??o vis?vel
          idUltObj := IntToStr(posObjetos[p,1]);
        end;
      p:=p+1;
    end;

  //Verifica a posi??o do objeto exclu?do
  i:=0;
  while i < 9 do
    begin
      if posObjetos[i,1] = idObjetoExcluido then
        begin
          k := posObjetos[i,0];
          posObjetos[i,1] := 0;
          i:=9;
        end;
      i:=i+1;
    end;

  //Oculta o campo condi??o do pen?ltimo registro
  if maxPos = 2 then
    begin
      cbCondicao_1.Visible := False;
      lblCondicao.Visible := False;
    end
  else
    begin
      if k < maxPos then
        (Self.Components[FindComponent('cbCondicao_'+idUltObj).ComponentIndex] as TComboBox).Visible := False
      else
        (Self.Components[FindComponent('cbCondicao_'+idPenObj).ComponentIndex] as TComboBox).Visible := False;
    end;

  //se objeto exclu?do n?o for da ?ltima posi??o reorganiza os objetos
  if k < maxPos then
    begin
      while k < maxPos do
        begin
          id := IntToStr(posObjetos[k-1,1]);
          case k of
            2: novaPos := 64;
            3: novaPos := 92;
            4: novaPos := 120;
            5: novaPos := 148;
            6: novaPos := 176;
            7: novaPos := 204;
            8: novaPos := 232;
            9: novaPos := 260;
            10: novaPos := 288;
          end;
          j:=0;
          while j < Self.ComponentCount do
            begin
              if Self.Components[j].Name = 'cbCampo_'+id then
                begin
                  (Self.Components[j] as TComboBox).Top := novaPos;
                end;
              if Self.Components[j].Name = 'cbCriterio_'+id then
                begin
                  (Self.Components[j] as TComboBox).Top := novaPos;
                end;
              if Self.Components[j].Name = 'cbCondicao_'+id then
                begin
                  (Self.Components[j] as TComboBox).Top := novaPos;
                end;
              if Self.Components[j].Name = 'edtValor1_'+id then
                begin
                  (Self.Components[j] as TEdit).Top := novaPos;
                end;
              if Self.Components[j].Name = 'edtValor2_'+id then
                begin
                  (Self.Components[j] as TEdit).Top := novaPos;
                end;
              if Self.Components[j].Name = 'lblE_'+id then
                begin
                  (Self.Components[j] as TLabel).Top := novaPos+4;
                end;
              if Self.Components[j].Name = 'sbtnRemoverCriterio_'+id then
                begin
                  (Self.Components[j] as TSpeedButton).Top := novaPos;
                end;
              j:=j+1;
            end;
          posObjetos[k-2,1] := posObjetos[k-1,1];
          posObjetos[k-1,1] := posObjetos[k,1];
          k:=k+1;
        end;
      idObjetoExcluido := 0;
    end;
  except on E: exception do
    begin
      if E.ClassName <> 'EAbort' then
        begin
          Application.MessageBox(PChar('Erro ao tentar reorganizar os objetos dos crit?rios de pesquisa'+#13#13
                                       +'Classe '+E.ClassName+#13
                                       +'Detalhes: '+E.Message)
                                ,'Erro'
                                ,MB_ICONERROR + MB_OK);
        end;
      Abort;
    end;
  end;
end;

function TfrmLocalizar.Identificador(Sender: TObject): String;
var
  objNome: String;
  sPos, nPos: Integer;
begin
  if (Sender is TSpeedButton) then
    objNome := (Sender as TSpeedButton).Name;

  if (Sender is TComboBox) then
    objNome := (Sender as TComboBox).Name;

  if (Sender is TEdit) then
    objNome := (Sender as TEdit).Name;

  if (Sender is TLabel) then
    objNome := (Sender as TLabel).Name;

  nPos := StrLen(PChar(objNome));
  sPos := Pos('_', objNome);
  Result := Copy(objNome, sPos+1, nPos);
end;

end.
