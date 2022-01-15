unit UFuncoes;

interface

uses
  Windows, Forms, SysUtils, Controls, Data.Win.ADODB, IniFiles, Dialogs,
  StdCtrls, Vcl.Mask, ExtCtrls, System.Classes;

  procedure Encerrar;
  procedure InciarConexao(Conn: TADOConnection; ArqConfBD: String);
  procedure EncerrarConexao(Conn: TADOConnection);
  procedure SQL(SQLQ: TADOQuery; Syntax: Array of String);
  function ValidarData(Data: String): Boolean;
  function ValidarCPF(CPF: String): Boolean;
  function ValidarEmail(Email: String): Boolean;
  procedure LimparForm(Form: TForm);
  procedure HDControles(Comp: array of TComponent; HD: Boolean);

implementation

//procedure para encerrar a aplicação
procedure Encerrar;
begin
  //Solicita confirmação para sair do programa
  if Application.MessageBox('Deseja sair do sistema?'
                           ,'Confirmação'
                           ,MB_ICONQUESTION + MB_YESNO) = mrYes then
    //Casso ação seja confirma encerra a aplicação
    Application.Terminate
  else
    //senão aporta o procedimento
    Abort;
end;

//procedure para iniciar a conexao com o banco de dados
procedure InciarConexao(Conn: TADOConnection; ArqConfBD: String);
var
  CaminhoArqIni, DadosConexao: String;
  ArqIni: TIniFile;
begin
  //Pega o caminho do arquivo de INI de configuração, que deve estar junto com o executável do programa
  CaminhoArqIni := ExtractFilePath(Application.ExeName)+ArqConfBD;
  //Verifica se o arquivo INI existe no diretorio do programa
  if FileExists(CaminhoArqIni) then
    begin
      try
        //Inicializa o arquivo INI
        ArqIni := TIniFile.Create(CaminhoArqIni);
        //Passa os parâmetros de conexão para a variável DadosConexao
        DadosConexao := ArqIni.ReadString('CONEXAO','CONEXAO','');
      except
        //Em caso de erro libera arquivo INI da memória e apresenta mensagem
        ArqIni.Free;
        Application.MessageBox('Falha ao ler o arquivo de configuração','Erro', MB_ICONERROR + MB_OK);
      end;
    end
  else
    begin
      //Se o arquivo INI não for encontrado no diretório do programa apresenta mensagem
      Application.MessageBox(PChar('O arquivo de configuração não foi encontrado'+#13#13
                                  +'Arquivo: '+ArqConfBD)
                             ,'Erro'
                             ,MB_ICONSTOP + MB_OK);
    end;
  try
     Conn.ConnectionString := DadosConexao;
     Conn.Connected := True;
  except on E: exception do
    begin
      //Em caso de erro ao conectar ao banco de dados libera o conector da memória e encerra a aplicação
      Conn.Free;
      Application.MessageBox(PChar('Não foi possível se conectar ao banco de dados'+#13
                                  +'O sistema será encerrado!'+#13#13
                                  +'Classe '+E.ClassName+#13
                                  +'Detalhes: '+E.Message)
                            ,'Erro'
                            ,MB_ICONERROR + MB_OK);
      Application.Terminate;
    end;
  end;
end;

//procedure para encerrar a conexao com o banco de dados
procedure EncerrarConexao(Conn: TADOConnection);
begin
  try
    //Tenta encerrar a conexão com o banco de dados
    Conn.Connected := False;
  except on E: exception do
    begin
      //Em caso de erro libera o conector da memória e encerra a aplicação
      Conn.Free;
      Application.MessageBox(PChar('Falha ao desconectar o banco de dados'+#13#13
                                  +'Classe '+E.ClassName+#13
                                  +'Detalhes: '+E.Message)
                            ,'Erro'
                            ,MB_ICONERROR + MB_OK);
      Application.Terminate;
    end;
  end;
end;

//procedure para executar comandos query
procedure SQL(SQLQ: TADOQuery; Syntax: Array of String);
var
  i: Integer;
  Command: String;
begin
  try
    SQLQ.Close;
    SQLQ.SQL.Clear;
    //Insere a syntax no componente Query
    for i := low(Syntax) to high(Syntax) do
      begin
        if Syntax[i] <> EmptyStr then
          SQLQ.SQL.Add(Syntax[i]);
          Command := Copy(Syntax[0],1,6);
      end;
    //Verifica se o comando for um SELECT abre o componente, caso contrário executa a sentença
    if CompareText(Copy(Syntax[0],1,6),'SELECT') = 0 then
      SQLQ.Open
    else
      SQLQ.ExecSQL;
  except on E: exception do
    begin
      //Em caso de erro fecha a conexão com o componente query, apresenta mensagem de erro e aporta a rotina
      SQLQ.Close;
      Application.MessageBox(PChar('Falha na execução da senteça SQL'+#13#13
                                  +'Classe '+E.ClassName+#13
                                  +'Detalhes: '+E.Message)
                            ,'Erro'
                            ,MB_ICONERROR + MB_OK);
      Abort;
    end;
  end;
end;

//função para validação de datas
function ValidarData(Data: String): Boolean;
begin
  try
    StrToDate(Data);
    Result := True;
  except on E: Exception do
    Result := False;
  end;
end;

//função para validar CPF
function ValidarCPF(CPF: String): Boolean;
const
  A: Set of Char = ['.','-'];
var
  i,D1,D2: Integer;
  xCPF: String;
begin
  try
    xCPF := EmptyStr;
    for i := 1 to length(CPF) do
      begin
        if not (CPF[i] in A) then
          if not (CPF[i] = ' ') then
            xCPF := xCPF+CPF[i];
      end;
    if ((length(xCPF) <> 11) or
       (xCPF = '00000000000') or (xCPF = '11111111111') or
       (xCPF = '22222222222') or (xCPF = '33333333333') or
       (xCPF = '44444444444') or (xCPF = '55555555555') or
       (xCPF = '66666666666') or (xCPF = '77777777777') or
       (xCPF = '88888888888') or (xCPF = '99999999999')) then
      begin
        Result := False;
        Exit;
      end;

    D1 := 0;
    for i := 1 to 9 do
      begin
        D1 := D1+(strtoint(xCPF[10-i])*(i+1));
      end;
    D1 := ((11 - (D1 mod 11))mod 11) mod 10;
    if D1 > 9 then
      D1 := 0;


    D2 := 0;
    for i := 1 to 10 do
      begin
        D2 := D2+(strtoint(xCPF[11-i])*(i+1));
      end;
    D2 := ((11 - (D2 mod 11))mod 11) mod 10;
    if D2 > 9 then
      D2 := 0;

    if ((IntToStr(D1) <> xCPF[10]) or (IntToStr(D2) <> xCPF[11])) then
      begin
        Result := False;
        Exit;
      end;

    Result := True;
  except
    Result := False;
  end;
end;

//função para validar email
function ValidarEmail(Email: String): Boolean;
var
  i, cont: Integer;
begin
  Email := LowerCase(Email);
  Result := True;

  if Email = EmptyStr then
    begin
      Result := False;
      Exit;
    end;

  if not ((Pos('@', EMail)<>0) and (Pos('.', EMail)<>0)) then
    begin
      Result := False;
      Exit;
    end;

  if (abs(Pos('@', EMail) - Pos('.', EMail)) = 1) or
     (abs(Pos('@', EMail) - Pos('_', EMail)) = 1) or
     (abs(Pos('@', EMail) - Pos('-', EMail)) = 1) then
    begin
      Result := False;
      Exit;
    end;

  cont := 0;
  for i := 1 to Length(Email) do
    begin
      if not (Email[i] in ['a' .. 'z', '0' .. '9', '_', '-', '.', '@']) then
        begin
          Result := False;
          Exit;
        end;

      if (EMail[i] = '.') and (EMail[i+1] = '.') then
        begin
          Result := false;
          Exit;
        end;

      if EMail[i] = '@' then
        begin
          cont := cont + 1;
          if cont > 1 then
            begin
              Result := False;
              Exit;
            end;
        end;
    end;
end;

procedure LimparForm(Form: TForm);
var
  i: Integer;
begin
  for i := 0 to Form.ComponentCount -1 do
    begin
      if (Form.Components[i] is TEdit) then
        (Form.Components[i] as TEdit).Clear;

      if (Form.Components[i] is TMaskEdit) then
        (Form.Components[i] as TMaskEdit).Clear;

      if (Form.Components[i] is TRadioGroup) then
        (Form.Components[i] as TRadioGroup).ItemIndex := -1;

      if (Form.Components[i] is TCheckBox) then
        (Form.Components[i] as TCheckBox).Checked := False;

      if (Form.Components[i] is TComboBox) then
        (Form.Components[i] as TComboBox).ItemIndex := -1;

      if (Form.Components[i] is TMemo) then
        (Form.Components[i] as TMemo).Clear;
    end;
end;

//Função para habilita/desabilitar controles
procedure HDControles(Comp: array of TComponent; HD: Boolean);
var
  i: Integer;
begin
  for i := low(Comp) to high(Comp) do
    begin
      if (Comp[i] is TEdit) then
        (Comp[i] as TEdit).Enabled := HD;

      if (Comp[i] is TMaskEdit) then
        (Comp[i] as TMaskEdit).Enabled := HD;

      if (Comp[i] is TCheckBox) then
        (Comp[i] as TCheckBox).Enabled := HD;

      if (Comp[i] is TListBox) then
        (Comp[i] as TListBox).Enabled := HD;

      if (Comp[i] is TComboBox) then
        (Comp[i] as TComboBox).Enabled := HD;

      if (Comp[i] is TRadioGroup) then
        (Comp[i] as TRadioGroup).Enabled := HD;
    end;
end;

end.
