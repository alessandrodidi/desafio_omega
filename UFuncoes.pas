unit UFuncoes;

interface

uses
  Windows, Forms, SysUtils, Controls, Data.Win.ADODB, IniFiles, Dialogs;

  procedure Encerrar;
  procedure InciarConexao(Conn: TADOConnection; ArqConfBD: String);

implementation

procedure Encerrar;
begin
  //Solicita confirmação para sair do programa
  if Application.MessageBox('Deseja sair do sistema?'
                           ,'Confirmação'
                           ,MB_ICONQUESTION + MB_YESNO) = mrYes then
    //Casso ação seja confirma encerra a aplicação
    Application.Terminate
  else
    Abort;
end;

procedure InciarConexao(Conn: TADOConnection; ArqConfBD: String);
var
  CaminhoArqIni, DadosConexao: String;
  ArqIni: TIniFile;
begin
  CaminhoArqIni := ExtractFilePath(Application.ExeName)+ArqConfBD;
  ShowMessage(CaminhoArqIni);
  if FileExists(CaminhoArqIni) then
    begin
      try
        ArqIni := TIniFile.Create(CaminhoArqIni);

        DadosConexao := ArqIni.ReadString('CONEXAO','CONEXAO','');
      except
        ArqIni.Free;
        Application.MessageBox('Falha ao ler o arquivo de configuração','Erro', MB_ICONERROR + MB_OK);
      end;
    end
  else
    begin
      ArqIni.Free;
      Application.MessageBox(PChar('O arquivo de configuração não foi encontrado'+#13#13+'Arquivo: '+ArqConfBD),'Erro', MB_ICONSTOP + MB_OK);
    end;
end;

end.
